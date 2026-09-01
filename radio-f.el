;;; radio-f.el --- A streaming library to access radio stations through Emacs -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Version: 0.2.6
;; Package-Requires: ((emacs "30.1"))
;; Created: Thu 30 Jul 26
;; Keywords: hypermedia, network, streaming, radio

;; This file is NOT part of Emacs.


;; Copyright (C) 2026 Jason Martens.
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License version 3, as
;; published by the Free Software Foundation.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:
;;
;; Radio F is a streaming library to access radio stations through Emacs.
;;
;; * Supports 150+ stations from Radio France, BBC, RTÉ, and more.
;; * Customizable information display, with artwork, track data, and
;;   selectable view style.
;; * Uses your choice of mpv, VLC, and EMMS as audio backends, with
;;   access to a selection of most commonly used controls: volume
;;   up/down, mute/unmute, pause, play, etc.
;;
;; See README.md for full documentation.



;;; Code:

(require 'json)
(require 'url)
(require 'seq)
(require 'emms nil t)
(require 'svg nil t)


;; == Custom ============

(defgroup radio-f nil
  "Radio F: a streaming library to access and play stations under
the Radio France banner."
  :group 'multimedia)

(defcustom radio-f-plugins
  '(radio-france bbc rte sbfm)
  "List of plugins that provide stations to Radio F. When a plugin is
enabled, all stations defined by that plugin are available for playback.

The default is all available plugins."
  :type '(set
          (const :tag "BBC" bbc)
          (const :tag "Radio France" radio-france)
          (const :tag "RTÉ" rte)
          (const :tag "Shonan Beach FM" sbfm))
  :group 'radio-f)

(defcustom radio-f-preferred-station "FIP"
  "The station to preferably play when launching Radio F.

Radio F determines available stations by examining the providers included
in `radio-f-plugins'.  If the preferred station is not available from
those plugins, the first station listed by the first plugin named in
`radio-f-plugins' is played instead."
  :type 'string
  :group 'radio-f)

(defcustom radio-f-view-style 'frame
  "View style for Radio F.

Window view displays the track information in a standard Emacs window.

Frame view displays the track information in a floating child frame,
locked to the frame of the calling parent.

Visibility of either view can be toggled with the function
`radio-f-toggle-view'."
  :type '(choice
          (const :tag "View track information in a child frame." frame)
          (const :tag "View track information in a window." window))
  :group 'radio-f)

(defcustom radio-f-player-program 'vlc
  "Audio backend used for Radio F playback.

The value may be one of:

  `emms'  Use EMMS for playback.
  `mpv'   Use mpv directly.
  `vlc'   Use VLC directly."
  :type '(choice
          (const :tag "EMMS" emms)
          (const :tag "mpv"  mpv)
          (const :tag "VLC"  vlc))
  :group 'radio-f)

(defcustom radio-f-favorite-stations nil
  "Stations to present as favorites for completion.

When nil, include all stations supplied by the plugins enabled in
`radio-f-plugins'."
  :type '(repeat string)
  :group 'radio-f)



;; == Custom Appearances ========================

(defgroup radio-f-appearance nil
  "Appearance settings for the Radio F presentation views."
  :group 'radio-f)

(defcustom radio-f-artwork-size 240
  "Set the pixel width and height of the artwork used in
the presentation views."
  :type 'integer
  :group 'radio-f-appearance)

(defcustom radio-f-show-track-info t
  "Show track info in the presentation views.  A non-nil value shows
track info; nil disables track info."
  :type '(choice
          (const :tag "Show Track Info." t)
          (const :tag "Don't Show Track Info" nil))
  :group 'radio-f-appearance)

(defcustom radio-f-show-artwork t
  "Display artwork in the presentation views.  A non-nil value displays
the artwork; nil disables artwork."
  :type '(choice
          (const :tag "Show Track Info." t)
          (const :tag "Don't Show Track Info" nil))
  :group 'radio-f-appearance)

(defcustom radio-f-artwork-border-width 1
  "Width of the artwork border in pixels.  A value of zero disables
the border."
  :type 'integer
  :group 'radio-f-appearance)

(defcustom radio-f-artwork-radius 16
  "Radius of the corners, in pixels, of the track artwork.  A value of
zero disables the artwork radius."
  :type 'integer
  :group 'radio-f-appearance)

(defcustom radio-f-show-track-timeline nil
  "Display a track timeline in both presentation views, showing time
played and length for each track.  Non-nil values show the timeline;
nil disables it."
  :type 'boolean
  :group 'radio-f-appearance)



;; == Custom Audio settings =====================

(defgroup radio-f-audio nil
  "Audio settings for Radio F."
  :group 'radio-f)

(defcustom radio-f-default-volume 70
  "Set the default volume level for station playback.  The same volume
level is used for mpv and VLC.  This setting is not available in EMMS."
  :type 'integer
  :group 'radio-f-audio)

(defcustom radio-f-stream-level 'One
  "Choice of audio stream level.  Higher numbers represent increasingly lower quality or bitrate."
  :type '(choice
          (const :tag "Level One: highest quality or bitrate stream available." One)
          (const :tag "Level Two: lower quality/bitrate than a level one stream." Two)
          (const :tag "Level Three: lower quality/bitrate than a level two stream." Three)
          (const :tag "Level Four: lower quality/bitrate than a level three stream." Four)
          (const :tag "Level Five: lower quality/bitrate than a level four stream." Five)
          (const :tag "Level Six: Lowest quality/bitrate available." Six))
  :group 'radio-f-audio)



;; == Custom Face settings  =====================

(defgroup radio-f-faces nil
  "Faces used by Radio F."
  :group 'radio-f)

(defface radio-f-regular
  '((t :inherit (variable-pitch) :weight regular :height 120))
  "Defines the underlying base face applied to the text in the Radio F
track info buffer.  This face is used in both frame and window view."
  :group 'radio-f-faces)

(defface radio-f-bold
  '((t :inherit (radio-f-regular) :weight bold))
  "Face used for the artist of the playing track.  This face is used
in both frame and window view."
  :group 'radio-f-faces)

(defface radio-f-timeline
  '((t :iherit (default) :weight medium :height 0.9))
  "Face used for the track timeline."
  :group 'radio-f-faces)



;; == Modes ============

(define-derived-mode radio-f-mode special-mode "Radio-F"
  "Major mode Radio F.

\\{radio-f-mode-map}"
  :keymap radio-f-mode-map
  :interactive nil
  (setq-local cursor-type nil)
  (setq-local left-margin-width 1)
  (setq-local right-margin-width 1)
  (setq-local truncate-lines nil)
  (setq-local word-wrap t)
  (setq-local radio-f-volume-change-amount 2)
  ;; Let the mouse wheel events control the volume level when
  ;; inside a view.
  (dolist (event '(wheel-up
                   double-wheel-up
                   triple-wheel-up))
    (define-key radio-f-mode-map
                (vector (list event))
                #'radio-f-volume-up))
  (dolist (event '(wheel-down
                   double-wheel-down
                   triple-wheel-down))
    (define-key radio-f-mode-map
                (vector (list event))
                #'radio-f-volume-down)))

(defvar-keymap radio-f-control-mode-map
  :doc "Global controls available while Radio F is running."
  "C-c f r"   #'radio-f
  "C-c f a"   #'radio-f-change-to-any-station
  "C-c f c"   #'radio-f-change-station
  "C-c f h"   #'radio-f-play-preferred-station
  "C-c f m"   #'radio-f-dark-mode
  "C-c f o"   #'radio-f-down
  "C-c f v"   #'radio-f-toggle-view
  "C-c f w"   #'radio-f-browse-station-page
  "C-c f ?"   #'radio-f-surprise-me
  "<f7>"      #'radio-f-play-preferred-station
  "<f8>"      #'radio-f-pause-audio    ;; hit again to unpause
  "<f9>"      #'radio-f-change-station
  "<f10>"     #'radio-f-mute-audio     ;; hit again to unmute
  "<f11>"     #'radio-f-volume-down
  "<f12>"     #'radio-f-volume-up)

(define-minor-mode radio-f-control-mode
  "Provide global key bindings while Radio F is running."
  :global t
  :lighter " RadioF-Control"
  :keymap radio-f-control-mode-map
  :group 'radio-f)



;; == Variables for station/stream control ======

(defconst radio-f--all-plugins
  '(bbc radio-france rte sbfm)
  "All Plugins supported by Radio F.")



(defvar radio-f--current-station nil
  "Saves the identity of the currently playing station.")

(defvar radio-f--directory
  (if (null load-file-name)
      (expand-file-name default-directory)
    (file-name-directory
     (or load-file-name (buffer-file-name))))
    "Stores the full pathname for the Radio F package.")



;; == Metadata system ===

(defvar radio-f--player-process nil
  "Tracks external player process.")

(defvar radio-f--timer nil
  "Timer for the polling interval.")

(defvar radio-f--cover-uuid nil
  "UUID for the artwork of the most recently dispatched track.")

(defvar radio-f--current-track-info nil
  "Accepted metadata for the currently playing track.")

(defvar radio-f--current-item-id nil
  "Identifier for the currently accepted program or track.")

(defun radio-f--stations ()
  "Return stations supplied by enabled plugins."
  (apply #'append
         (mapcar
          (lambda (plugin)
            (pcase plugin
              ('bbc radio-f--bbc-stations)
              ('radio-france radio-f--radio-france-stations)
              ('rte radio-f--rte-stations)
              ('sbfm radio-f--sbfm-stations)
              (_ nil)))
          radio-f-plugins)))

;; It's a surprise!
(defun radio-f--all-stations ()
  "Return all stations supported by Radio F."
  (radio-f--load-all-plugins)
  (append radio-f--bbc-stations
          radio-f--radio-france-stations
          radio-f--rte-stations
          radio-f--sbfm-stations))

(defun radio-f--set-initial-station ()
  "Return the preferred station, or the first available station from the first plugin defined in `radio-f-plugins'."e
  (let ((stations
         (radio-f--all-station-names)))
    (if (member radio-f-preferred-station stations)
        radio-f-preferred-station
      (car stations))))

(defun radio-f--load-plugins ()
  "Load plugin modules, as defined in `radio-f-plugins'."
  (dolist (plugin radio-f-plugins)
    (pcase plugin
      ('bbc
       (require 'radio-f-bbc))
      ('radio-france
       (require 'radio-f-radio-france))
      ('rte
       (require 'radio-f-rte))
      ('sbfm
       (require 'radio-f-sbfm)))))

(defun radio-f--load-all-plugins ()
  "Load all plugin modules supported by Radio F."
  (dolist (plugin radio-f-plugins)
    (pcase plugin
      ('bbc
       (require 'radio-f-bbc))
      ('radio-france
       (require 'radio-f-radio-france))
      ('rte
       (require 'radio-f-rte))
      ('sbfm
       (require 'radio-f-sbfm)))))

(defun radio-f--favorite-stations ()
  "Return the effective list of favorite stations."
  (or radio-f-favorite-stations
      (radio-f--all-station-names)))


(defun radio-f--get-current-station-data ()
  "Return the metadata plist for the current station."
  (cdr
   (seq-find
    (lambda (entry)
      (equal
       (plist-get (cdr entry) :name)
       radio-f--current-station))
    (radio-f--stations))))

(defun radio-f--get-station-page-template (plugin)
  "Return the station page URL template for PLUGIN."
  (pcase plugin
    ('bbc
     radio-f--bbc-url)
    ('radio-france
     radio-f--radio-france-url)
    ('rte
     radio-f--rte-url)
    ('sbfm
     radio-f--sbfm-url)
    (_
     nil)))

(defun radio-f--get-stream-template (plugin)
  "Return the stream template for PLUGIN."
  (let* ((streams
          (pcase plugin
            ('bbc radio-f--bbc-streams)
            ('radio-france radio-f--radio-france-streams)
            ('rte radio-f--rte-streams)
            ('sbfm radio-f--sbfm-streams)))
         (level
          (or radio-f--session-stream-level
              radio-f-stream-level)))
    (or (cdr (assq level streams))
        (cdr (assq 'default streams)))))

(defun radio-f--expand-url (template station)
  "Expand URL TEMPLATE using values from STATION."
  (let ((url template))
    (while (string-match "\\[\\([^]]+\\)\\]" url)
      (let* ((name (match-string 1 url))
             (key (intern (concat ":" name)))
             (value (plist-get station key)))
        (setq url
              (replace-match
               (or value "")
               t t url))))
    url))

(defun radio-f--get-stream-url ()
  "Return the streaming URL for the current station.

The URl is determined by examining the streams that a plugin has
available. If the user has specificed a stream type that the plugin
does not have, the stream returned is the highest level stream."
  (let* ((station
          (radio-f--get-current-station-data))
         (plugin
          (plist-get station :plugin))
         (template
          (radio-f--get-stream-template plugin)))
    (radio-f--expand-url template station)))

(defun radio-f--get-api-template (plugin)
  "Return the metadata URL template for PLUGIN."
  (pcase plugin
    ('bbc
     radio-f--bbc-api-url)
    ('radio-france
     radio-f--radio-france-api-url)
    ('sbfm
     radio-f--sbfm-api-url)
    ('rte
     radio-f--rte-api-url)
    (_
     (error "Radio F: No metadata template for plugin %S"
            plugin))))



;; Networking functions

(defun radio-f--fetch-json ()
  "Fetch metadata JSON for the current station."
  (let* ((station (radio-f--get-current-station-data))
         (plugin (plist-get station :plugin))
         (template (radio-f--get-api-template plugin))
         (url (radio-f--expand-url template station)))
    ;; Testing.  Move along.
    ;; (message "Radio F metadata URL: %s" url)
    (url-retrieve
     url
     (lambda (status)
       (let ((retrieval-buffer (current-buffer))
             (error-data (plist-get status :error)))
         (unwind-protect
             (cond
              (error-data
               (message
                "Radio F: Metadata retrieval error: %S."
                error-data))
              ((not (progn
                      (goto-char (point-min))
                      (re-search-forward "\r?\n\r?\n" nil t)))
               (let ((message-log-max nil))
                 (message
                  "Radio F: Could not find end of HTTP headers.")))
              (t
               (let* ((raw-json
                       (buffer-substring-no-properties
                        (point)
                        (point-max)))
                      (decoded-json
                       (decode-coding-string raw-json 'utf-8)))
                 (radio-f--json-postmaster decoded-json))))
           (when (buffer-live-p retrieval-buffer)
             (kill-buffer retrieval-buffer)))))
     nil t t)))

(defun radio-f--json-postmaster (raw-json-string)
  "Parse RAW-JSON-STRING and process changed station metadata."
  (let* ((json-object-type 'alist)
         (json-array-type 'vector)
         (json-key-type 'string)
         (data (json-read-from-string raw-json-string))
         (station (radio-f--get-current-station-data))
         (metadata (plist-get station :metadata))
         (processor (plist-get station :processor))
         (track-info (funcall processor data station))
         (item-id (alist-get 'item-id track-info))
         (artist (alist-get 'artist track-info))
         (title (alist-get 'title track-info))
         (start (alist-get 'start track-info))
         (end (alist-get 'end track-info))
         (visual-url (alist-get 'visual-url track-info)))
    ;; Don't call the views if "item-id" hasn't changed.
    ;; Instead, Wait for a fetch to return fresh JSON.
    (unless (equal item-id radio-f--current-item-id)
      (setq radio-f--current-item-id item-id
            radio-f--current-track-info
            (cons `(fetch-time . ,(floor (float-time)))
                  track-info))
    (radio-f--record-track-log)
    (pcase radio-f-view-style
      ('window
       (radio-f--create-window-view))
      ('frame
       (radio-f--create-frame-view))
      (_
       (message
        "Radio F: unknown view style: %S. Check your view style settings."
        radio-f-view-style))))))

(defun radio-f--fetch-artwork (visual-url callback)
  "Retrieve the image returned by VISUAL-URL.

VISUAL-URL comes from the alist built by `radio-f--json-postmaster'.

CALLBACK is called with two arguments: the image data and its MIME type."
  (url-retrieve
   visual-url
   (lambda (status)
     (let ((retrieval-buffer (current-buffer)))
       (unwind-protect
           (if-let* ((error-data (plist-get status :error)))
               (message "Artwork retrieval error: %S" error-data)
             (goto-char (point-min))
             (let ((image-type
                    (when (re-search-forward
                           "^Content-Type:[ \t]*\\([^;\r\n]+\\)"
                           nil t)
                      (match-string-no-properties 1))))
               (goto-char (point-min))
               (if (re-search-forward "\r?\n\r?\n" nil t)
                   (funcall
                    callback
                    (buffer-substring-no-properties
                     (point)
                     (point-max))
                    image-type)
                 (let ((message-log-max nil))
                   (message "Could not find end of HTTP headers")))))
         (when (buffer-live-p retrieval-buffer)
           (kill-buffer retrieval-buffer)))))
   nil t t))

(defun radio-f--stylize-artwork (image-data image-type)
  "Return a presentation image made from IMAGE-DATA.

When SVG support is available, stylize the artwork with rounded corners
and a rounded border; otherwise it returns a normally resized webp image
without the effect.

The size of the image is set to the value of the custom variable
`radio-f-artwork-size'.  The border color is taken from the face
`radio-f-regular'."
  (if (and (featurep 'svg)
           (image-type-available-p 'svg)
           (> radio-f-artwork-radius 0))
      (let* ((size radio-f-artwork-size)
             (radius radio-f-artwork-radius)
             (stroke-width (* 2 radio-f-artwork-border-width))
             (half-stroke (/ stroke-width 2.0))
             (border-color
              (or (face-foreground 'radio-f-regular nil t)
                  (face-foreground 'default nil t)))
             (svg (svg-create size size))
             (clip-path
              (svg-clip-path
               svg
               :id "radio-f-artwork-clip")))
        (svg-rectangle
         clip-path
         0 0 size size
         :rx radius
         :ry radius)
        (svg-embed
         svg
         image-data
         image-type
         t
         :x 0
         :y 0
         :width size
         :height size
         :preserveAspectRatio "xMidYMid slice"
         :clip-path "url(#radio-f-artwork-clip)")
        ;; Inset another rectangle inside the first
        ;; so that the stroke won't bleed into the
        ;; corners of the radius mask.
        (when (> radio-f-artwork-border-width 0)
          (svg-rectangle
           svg
           half-stroke
           half-stroke
           (- size stroke-width)
           (- size stroke-width)
           :rx (max 0 (- radius half-stroke))
           :ry (max 0 (- radius half-stroke))
           :fill "none"
           :stroke border-color
           :stroke-width stroke-width))
        (svg-image
         svg
         :width size
         :height size))
    ;; If no SVG support, just return the image
    ;; after resizing.
    (create-image
     image-data
     (pcase image-type
       ("image/webp" 'webp)
       ("image/jpeg" 'jpeg)
       ("image/png"  'png))
     t
     :width radio-f-artwork-size
     :height radio-f-artwork-size)))



;; == View control ======

(defvar radio-f--view-visible-p t
  "Visibility of the default view.  Non-nil when the view should
be visible.")


(defun radio-f--generate-buffer-name ()
  "Generate a buffer name for the current station.

The same name is used for all views."
  (format "*Radio F: Now Playing on %s*"
          (or radio-f--current-station
              "Radio F")))


(defun radio-f--configure-child-window (frame buffer)
  "Configure the child FRAME's root window to display its BUFFER."
  (let ((window (frame-root-window frame)))
    (set-window-buffer window buffer)
    (set-window-dedicated-p window t)
    (set-window-fringes window 0 0)
    (setq mouse-autoselect-window nil)
    (set-window-scroll-bars window 0 nil 0 nil)
    (set-window-margins window 1 1)
    window))

(defun radio-f--fit-child-frame (frame buffer)
  "Fit FRAME to BUFFER at a fixed width.

FRAME width is the value of `radio-f-artwork-size' plus
one character-width of horizontal padding on each side,
and its height is calculated after text wrapping."
  (when (and (frame-live-p frame)
             (buffer-live-p buffer))
    (let* ((window (frame-root-window frame))
           (char-width (frame-char-width frame))
           (horizontal-padding (* 2 char-width))
           (frame-width (+ radio-f-artwork-size
                           horizontal-padding))
           (frame-resize-pixelwise t))
      (set-window-buffer window buffer)
      (with-current-buffer buffer
        (setq-local truncate-lines nil)
        (setq-local word-wrap t))
      (set-frame-width frame frame-width nil t)
      (when radio-f--view-visible-p
        (make-frame-visible frame))
      (redisplay t)
      (with-current-buffer buffer
        (let* ((size
                (window-text-pixel-size
                 window
                 (point-min)
                 (point-max)
                 nil
                 nil
                 t))
               (content-height (cdr size))
               (vertical-padding
                (frame-char-height frame)))
          (set-frame-size
           frame
           frame-width
           (+ content-height vertical-padding)
           t)))
      (radio-f--position-child-frame frame))))

(defun radio-f--position-child-frame (frame)
  "Place FRAME at the bottom-right of its parent frame.

Keep it above the parent's mode line and echo area, with
a small external margin of one character height."
  (when-let* ((parent (frame-parent frame)))
    (let* ((bottom-windows
            (window-at-side-list parent 'bottom))
           (bottom-window
            (car bottom-windows))
           (mode-line-height
            (if bottom-window
                (window-mode-line-height bottom-window)
              0))
           (minibuffer-height
            (window-pixel-height
             (minibuffer-window parent)))
           (content-bottom
            (- (frame-pixel-height parent)
               minibuffer-height
               mode-line-height))
           (x-margin
            (* 2 (frame-char-width parent)))
           (y-margin
            (frame-char-height parent)))
      (set-frame-position
       frame
       (max 0
            (- (frame-pixel-width parent)
               (frame-pixel-width frame)
               x-margin))
       (max 0
            (- content-bottom
               (frame-pixel-height frame)
               y-margin))))))

(defun radio-f--reposition-on-resize (frame)
  "Reposition the child frame when its parent FRAME changes size."
  (when (and (frame-live-p radio-f--child-frame)
             (eq frame
                 (frame-parent radio-f--child-frame)))
    ;; Guard against possible race where a window can pass
    ;; `window-live-p' as its configuration is coming down.
    (let ((window
           (frame-root-window radio-f--child-frame)))
      (when (window-live-p window)
        (radio-f--position-child-frame
         radio-f--child-frame)))))


(defun radio-f-resize-window-view ()
  "Shrink the window view if it is larger than its buffer."
  (interactive)
  (let* ((buffer (get-buffer
                  (radio-f--generate-buffer-name)))
         (window (and buffer
                      (get-buffer-window buffer t))))
    (when (window-live-p window)
      (with-selected-window window
        (shrink-window-if-larger-than-buffer)))))

(defun radio-f--restore-window-view (buffer)
  "Display the restored window view BUFFER."
  (display-buffer-in-side-window
   buffer
   `((side . bottom)
     (slot . 0)
     (preserve-size . (nil . t))
     (window-parameters
      . ((radio-f-window . t)))))
  (unless (display-graphic-p)
    (radio-f-resize-window-view)))

(defun radio-f-toggle-view ()
  "Toggle visibility of the active Radio F view.

For frame view, hide or show the existing child frame.

For window view, delete the window when it is visible.  When
it is not visible, recreate the window and display the current
window view buffer.  The buffer itself stays alive and continues
to be rebuilt on track changes, waiting for the view to return
when the user calls this function again.

If the window view buffer has been killed, retrieve the cached
alist data from `radio-f--current-track-info', pass it to
`radio-f--refresh-window-view-buffer', and restore the view."
  (interactive)
  (pcase radio-f-view-style
    ('frame
     (when (frame-live-p radio-f--child-frame)
       (setq radio-f--view-visible-p
             (not radio-f--view-visible-p))
       (if radio-f--view-visible-p
           (progn
             (make-frame-visible radio-f--child-frame)
             (radio-f--fit-child-frame
              radio-f--child-frame
              (get-buffer (radio-f--generate-buffer-name)))
             (radio-f--position-child-frame
              radio-f--child-frame)
             (redisplay t)
             (let ((message-log-max nil))
               (message
                "Radio F: frame view restored.")))
         (make-frame-invisible
          radio-f--child-frame t)
         (let ((message-log-max nil))
           (message
            "Radio F: frame view disabled.")))))
    ('window
     (let* ((buffer-name
             ( radio-f--generate-buffer-name))
            (buffer
             (get-buffer buffer-name))
            (window
             (and buffer
                  (get-buffer-window buffer t))))
       (if (window-live-p window)
           (progn
             (delete-window window)
             (setq radio-f--view-visible-p nil)
             (let ((message-log-max nil))
               (message "Radio F: window view disabled.")))
         ;; Rebuild buffer on demand if the user kills it.
         (unless (buffer-live-p buffer)
           (setq buffer
                 (radio-f--restore-window-buffer)))
         (if (buffer-live-p buffer)
             (progn
               (radio-f--restore-window-view buffer)
               (setq radio-f--view-visible-p t)
               (let ((message-log-max nil))
                 (message "Radio F: window view restored.")))
           (message
            "Radio F: no track metadata is available.")))))
    (_
     (message
      "Radio F: unknown view style: %S. Check your view style setting."
      radio-f-view-style))))

(defun radio-f--delete-views ()
  "Delete all views."
  (remove-hook 'window-size-change-functions
               #'radio-f--reposition-on-resize)
  (let* ((frame radio-f--child-frame)
         (buffer
          (if (frame-live-p frame)
              (window-buffer (frame-root-window frame))
            (get-buffer
             (radio-f--generate-buffer-name))))
         (win
          (and buffer
               (get-buffer-window buffer nil))))
    (when (frame-live-p frame)
      (delete-frame frame))
    (setq radio-f--child-frame nil)
    (when (and (window-live-p win)
               (not (window-minibuffer-p win))
               (not (eq win
                        (frame-root-window
                         (window-frame win)))))
      (delete-window win))
    (when (buffer-live-p buffer)
      (kill-buffer buffer))))



;; == Frame view ========

(defvar radio-f--child-frame nil
  "Floating controller child frame.")


(defun radio-f--create-child-frame (buffer)
  "Create a child frame displaying BUFFER.

BUFFER name is generated dynamically by `radio-f--generate-buffer-name'."
  (let* ((parent (selected-frame))
         (frame-resize-pixelwise t)
         (frame
          (make-frame
           `((parent-frame . ,parent)
             (minibuffer . nil)
             (undecorated . t)
             (skip-taskbar . t)
             (desktop-dont-save . t)
             (menu-bar-lines . 0)
             (tool-bar-lines . 0)
             (tab-bar-lines . 0)
             (vertical-scroll-bars . nil)
             (horizontal-scroll-bars . nil)
             (left-fringe . 0)
             (right-fringe . 0)
             (internal-border-width . 0)
             (border-width . 0)
             ;; A square border around a RoundRect looks
             ;; strange. No border for the child frame.
             (child-frame-border-width . 0)
             (no-other-frame . t)
             (no-accept-focus . t)
             (no-focus-on-map . t)
             (focus-follow-mouse . nil)
             (no-special-glyphs . t)
             (mouse-wheel-frame . ,parent)
             (unsplittable . t)
             (visibility . nil)))))
    (setq radio-f--child-frame frame)
    (set-face-background
     'child-frame-border
     (face-foreground 'default frame nil) frame)
    (radio-f--configure-child-window frame buffer)
    (radio-f--fit-child-frame frame buffer)
    (radio-f--position-child-frame frame)
    (when radio-f--view-visible-p
      (make-frame-visible frame))
    ;; Make background alpha zero on systems that support it.
    (when (memq window-system '(ns pgtk))
      (set-frame-parameter radio-f--child-frame 'alpha-background 0))
    (add-hook 'window-size-change-functions
              #'radio-f--reposition-on-resize)
    frame))

(defun radio-f--create-frame-view ()
  "Initialize frame view's child framer."
  (let ((buffer
         (radio-f--refresh-frame-view-buffer)))
    (if (frame-live-p radio-f--child-frame)
        (progn
          (radio-f--fit-child-frame
           radio-f--child-frame buffer)
          (radio-f--position-child-frame
           radio-f--child-frame))
      (radio-f--create-child-frame buffer))))

(defun radio-f--refresh-frame-view-buffer ()
  "Show the frame view buffer."
  (let ((buffer
         (get-buffer-create (radio-f--generate-buffer-name))))
    (let-alist radio-f--current-track-info
      (with-current-buffer buffer
        (let ((inhibit-read-only t))
          (erase-buffer)
          (radio-f-mode)
          (setq-local mode-line-format nil
                      header-line-format nil
                      truncate-lines nil
                      word-wrap t
                      desktop-save-buffer nil
                      mouse-autoselect-window nil
                      show-trailing-whitespace nil)
          (insert "\n")
          (when .visual-url
            (let ((artwork-marker (copy-marker (point) nil)))
              (radio-f--fetch-artwork
               .visual-url
               (lambda (image-data image-type)
                 (when (and (buffer-live-p buffer)
                            (marker-position artwork-marker))
                   (let ((image
                          (radio-f--stylize-artwork image-data image-type)))
                     (when image
                       (radio-f--insert-frame-artwork
                        buffer artwork-marker image))))))))
          (when radio-f-show-track-info
            (insert "\n\n")
            (radio-f--insert-track-info))
          (when radio-f-show-track-timeline
            (insert "\n\n")
            (radio-f--insert-track-timeline))
          (setq buffer-read-only t)
          (goto-char (point-min)))))
    buffer))



;; == Window view =======

(defun radio-f--create-window-view ()
  "Create Radio F's window view."
  (let ((buffer
         (radio-f--refresh-window-view-buffer)))
    (display-buffer-in-side-window
     buffer
     `((side . bottom)
       (slot . 0)
       (preserve-size . (nil . t))
       (window-parameters
        . ((radio-f-window . t)))))
    (unless (display-graphic-p)
      (radio-f-resize-window-view))))

(defun radio-f--refresh-window-view-buffer ()
  "Show the window view buffer."
  (let ((buffer (get-buffer-create
                 (radio-f--generate-buffer-name))))
    (let-alist radio-f--current-track-info
      (with-current-buffer buffer
        (let ((inhibit-read-only t))
          (erase-buffer)
          (radio-f-mode)
          (unless (eq radio-f-show-artwork nil)
            (insert "\n")
            (when .visual-url
              (let ((artwork-marker (copy-marker (point) nil)))
                (radio-f--fetch-artwork
                 .visual-url
                 (lambda (image-data image-type)
                   (when (and (buffer-live-p buffer)
                              (marker-position artwork-marker))
                     (let ((image
                            (radio-f--stylize-artwork image-data image-type)))
                       (when image
                         (radio-f--insert-window-artwork
                          buffer artwork-marker image))))))))
            (insert "\n"))
          (when (display-graphic-p)
            (insert "\n"))
          (when radio-f-show-track-info
            (radio-f--insert-track-info))
          (insert "\n\n")
          (when radio-f-show-track-timeline
            (radio-f--insert-track-timeline))
          (setq buffer-read-only t)
          (goto-char (point-min)))))
    buffer))

(defun radio-f--restore-window-buffer ()
  "Reconstruct and return the current window view buffer."
  (when radio-f--current-track-info
    (radio-f--refresh-window-view-buffer)))



;; == Inserts ===========

(defun radio-f--insert-track-info ()
  "Insert current track metadata into the Radio F buffer."
  (let-alist radio-f--current-track-info
    (when .artist
      (insert (propertize .artist 'face 'radio-f-bold) "\n"))
    (when .title
      (insert (propertize .title 'face 'radio-f-regular)))))

(defun radio-f--insert-window-artwork (buffer marker image)
  "Insert IMAGE into BUFFER at MARKER."
  (when (and (buffer-live-p buffer)
             (marker-position marker))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (save-excursion
          (goto-char marker)
          (insert-image image))))
    (set-marker marker nil)))

(defun radio-f--insert-frame-artwork (buffer marker image)
  "Insert IMAGE into BUFFER at MARKER and refit the child frame."
  (unwind-protect
      (when (and (buffer-live-p buffer)
                 (markerp marker)
                 (marker-buffer marker)
                 (marker-position marker)
                 (frame-live-p radio-f--child-frame))
        (let* ((frame radio-f--child-frame)
               (window (frame-root-window frame))
               scaled-image
               available-width)
          (set-window-margins window 1 1)
          (redisplay t)
          (setq available-width
                (window-body-width window t))
          (setq scaled-image (copy-tree image))
          (setcdr scaled-image
                  (plist-put (cdr scaled-image)
                             :max-width
                             available-width))
          (with-current-buffer buffer
            (let ((buffer-read-only nil)
                  (inhibit-read-only t))
              (save-excursion
                (goto-char marker)
                (insert-image scaled-image))))
          (redisplay t)
          (radio-f--fit-child-frame frame buffer)
          (radio-f--position-child-frame frame)))
    (when (markerp marker)
      (set-marker marker nil))))

(defun radio-f--insert-track-timeline ()
  "Insert the timeline for the current track or program."
  (let-alist radio-f--current-track-info
    ;; Radio France runs their times as (- now .start).
    ;; This isn't quite right, as the JSON is, by necessity,
    ;; always early. Their timeline invariably shows songs
    ;; starting with 30+ seconds having already elapsed.
    ;;
    ;; Always show the time as starting at 0:00 for any
    ;; track that is under 10 minutes long, and show the
    ;; elapsed time playing for anything that goes over
    ;; that.
    (when (and .fetch-time .start .end)
      (let* ((now (float-time))
             (length (- .end .start))
             (played
              (if (>= length 600)
                  (- now .start)
                (- now .fetch-time))))
        ;; Showing (4:12/3:48) for a track looks wrong, too.
        ;; When `played' time exceeds `length', kill the timer.
        ;; The rest of the view remains until the value of
        ;; `.cover' changes.
        (if (>= played length)
            (radio-f--reinitialize-timeline)
          (insert
           (propertize
            (format "%s/%s"
                    (radio-f--format-track-time played)
                    (radio-f--format-track-time length))
            'face 'radio-f-timeline
            'radio-f-track-timeline t)))))))



;; == Track Timeline ======

(defvar radio-f--timeline-timer nil
  "Timer used to update the current track timeline.")


(defun radio-f--format-track-time (seconds)
  "Format SECONDS as M:SS, or H:MM:SS when program is one hour or longer."
  (let* ((seconds (floor seconds))
         (hours (/ seconds 3600))
         (minutes (% (/ seconds 60) 60))
         (seconds (% seconds 60)))
    (if (> hours 0)
        (format "%d:%02d:%02d"
                hours minutes seconds)
      (format "%d:%02d"
              minutes seconds))))

(defun radio-f--refresh-timeline-in-buffer (buffer)
  "Refresh the existing track timeline in BUFFER."
  (when (buffer-live-p buffer)
    (with-current-buffer buffer
      (let ((position
             (text-property-any
              (point-min)
              (point-max)
              'radio-f-track-timeline
              t)))
        (when position
          (let ((inhibit-read-only t)
                (timeline-end
                 (or
                  (next-single-property-change
                   position
                   'radio-f-track-timeline)
                  (point-max))))
            (delete-region position timeline-end)
            (goto-char position)
            (radio-f--insert-track-timeline)))))))

(defun radio-f--update-track-timeline ()
  "Update the track timeline in all live views."
  (when-let* ((buffer (get-buffer (radio-f--generate-buffer-name))))
    (radio-f--refresh-timeline-in-buffer buffer)))

(defun radio-f--reinitialize-timeline ()
  "Restart the Radio F timeline timer."
  (when (timerp radio-f--timeline-timer)
    (cancel-timer radio-f--timeline-timer)
    (setq radio-f--timeline-timer nil))
  (setq radio-f--timeline-timer
        (run-at-time 1 1 #'radio-f--update-track-timeline)))



;; == Timing control =============================

(defun radio-f--kill-timeline ()
  "Turn off the track timeline timer and reset the variables that use it."
  (when (timerp radio-f--timeline-timer)
    (cancel-timer radio-f--timeline-timer)
    (setq radio-f--timeline-timer nil)))

(defun radio-f--kill-timer ()
  "Turn off the JSON timer and reset the variables that use it."
  (when (timerp radio-f--timer)
    (cancel-timer radio-f--timer)
    (setq radio-f--timer nil)))



;; == Transport control =========================

(defun radio-f--send-command (command &optional value)
  "Send COMMAND to the configured external player.

VALUE is used by commands requiring an argument, such as `volume'."
  (pcase radio-f-player-program
    ('mpv
     (pcase command
       ('pause
        (radio-f--send-mpv-command
         '("cycle" "pause")))
       ('stop
        (radio-f--send-mpv-command
         '("quit")))
       ('volume
        (radio-f--send-mpv-command
         (list "set_property" "volume" value)))
       (_
        (error "Unsupported mpv command: %S" command))))
    ('vlc
     (pcase command
       ('pause
        (radio-f--send-vlc-command "pause"))
       ('stop
        (radio-f--send-vlc-command "shutdown"))
       ;; VLC volume is an 8-bit value; give it the
       ;; numbers it expects to see.
       ('volume
        (radio-f--send-vlc-command
         (format "volume %d"
                 (round (* value 2.56)))))
       (_
        (error "Unsupported VLC command: %S" command))))
    (_
     (error "Unsupported player: %S"
            radio-f-player-program))))

(defun radio-f--send-mpv-command (command)
  "Send COMMAND to mpv's JSON IPC socket and return its response.

COMMAND must be a list representing an mpv command, such as
\\='(\"set_property\" \"volume\" 50\).

The return value is an alist parsed from mpv's JSON response."
  (unless (file-exists-p "/tmp/radio-f-mpv.sock")
    (error "mpv IPC socket does not exist"))
  (let* ((buffer
          (generate-new-buffer " *radio-f-mpv-response*"))
         (process
          (make-network-process
           :name "radio-f-mpv-command"
           :family 'local
           :service "/tmp/radio-f-mpv.sock"
           :buffer buffer
           :coding 'utf-8
           :noquery t))
         (deadline (+ (float-time) 0.05))
         response)
    (unwind-protect
        (progn
          (process-send-string
           process
           (concat
            (json-serialize
             `((command . ,(vconcat command))))
            "\n"))
          ;; NOTE: mpv terminates each JSON response with a newline!
          (while (and (process-live-p process)
                      (< (float-time) deadline)
                      (with-current-buffer buffer
                        (not (search-forward "\n" nil t))))
            (accept-process-output process 0.05))
          (setq response
                (with-current-buffer buffer
                  (goto-char (point-min))
                  (unless (search-forward "\n" nil t)
                    (error "Timed out waiting for mpv response"))
                  (json-parse-string
                   (buffer-substring-no-properties
                    (point-min)
                    (1- (point)))
                   :object-type 'alist
                   :array-type 'list
                   :null-object nil
                   :false-object nil)))
          (unless (equal (alist-get 'error response) "success")
            (error "mpv command failed: %s"
                   (alist-get 'error response)))
          response)
      (when (process-live-p process)
        (process-send-eof process)
        (delete-process process))
      (kill-buffer buffer))))

(defun radio-f--query-vlc-command (command)
  "Send COMMAND to VLC and return its textual response."
  (let* ((buffer
          (generate-new-buffer
           " *radio-f-vlc-response*"))
         (process
          (make-network-process
           :name "radio-f-vlc-query"
           :family 'ipv4
           :host "127.0.0.1"
           :service 1971
           :buffer buffer
           :coding 'utf-8
           :noquery t))
         (deadline (+ (float-time) 1.0)))
    (unwind-protect
        (progn
          (while (and (< (float-time) deadline)
                      (with-current-buffer buffer
                        (not (string-suffix-p
                              "> "
                              (buffer-string)))))
            (accept-process-output process 0.05))
          (with-current-buffer buffer
            (erase-buffer))
          (process-send-string process
                               (concat command "\n"))
          (setq deadline (+ (float-time) 0.5))
          (while (and (< (float-time) deadline)
                      (with-current-buffer buffer
                        (not (string-suffix-p
                              "> "
                              (buffer-string)))))
            (accept-process-output process 0.05))
          (with-current-buffer buffer
            (let ((response (buffer-string)))
              ;; Clean up the prompt.
              (setq response
                    (replace-regexp-in-string
                     "\r" "" response))
              (setq response
                    (string-remove-suffix
                     "> " response))
              (string-trim response))))
      (when (process-live-p process)
        (delete-process process))
      (kill-buffer buffer))))

(defun radio-f--send-vlc-command (command)
  "Send COMMAND to VLC's RC interface."
  (let ((process
         (make-network-process
          :name "radio-f-vlc-command"
          :family 'ipv4
          :host "127.0.0.1"
          :service 1971
          :coding 'utf-8
          :noquery t)))
    (unwind-protect
        (process-send-string process
                             (concat command "\n"))
      (when (process-live-p process)
        (process-send-eof process)
        (delete-process process)))))

(defun radio-f--wait-for-player-control ()
  "Wait briefly after startup before interacting with the active player's
remote control interface."
  (let ((deadline (+ (float-time) 1.0))
        ready)
    (while (and (not ready)
                (< (float-time) deadline))
      (setq ready
            (pcase radio-f-player-program
              ('mpv
               (file-exists-p "/tmp/radio-f-mpv.sock"))
              ('vlc
               (condition-case nil
                   (let ((process
                          (make-network-process
                           :name "radio-f-vlc-probe"
                           :family 'ipv4
                           :host "127.0.0.1"
                           :service 1971
                           :noquery t)))
                     (delete-process process)
                     t)
                 (file-error nil)))
              (_ t)))
      (unless ready
        (sleep-for 0.25)))
    ready))



;; == Playback controls =========================

(defvar radio-f--current-volume nil
  "Current volume level of the player process.")

(defvar radio-f--previous-volume nil
  "Record the value of `radio-f--current-volume' before volume changes.")

(defvar radio-f--session-stream-level nil
  "Record a different stream level for `radio-f-audio-start` to use if the
user has requested it.")


(defun radio-f-change-stream-level ()
  "Change the stream level for the current Radio F session."
  (interactive)
  (let* ((station (radio-f--get-current-station-data))
         (plugin (plist-get station :plugin))
         (streams
          (pcase plugin
            ('bbc radio-f--bbc-streams)
            ('radio-france radio-f--radio-france-streams)
            ('rte radio-f--rte-streams)
            ('sbfm radio-f--sbfm-streams)))
         (levels
          (seq-filter
           (lambda (level)
             (memq level '(One Two Three Four)))
           (mapcar #'car streams)))
         (level
          (intern
           (completing-read
            "Select stream level: "
            (mapcar #'symbol-name levels)
            nil t nil t nil nil))))
         ;; Set session stream level and restart stream.
         (setq radio-f--session-stream-level level)
         (radio-f-audio-stop)
         (radio-f-audio-start)))

(defun radio-f-volume-up ()
  "Increase playback volume by two points."
  (interactive)
  (setq radio-f--previous-volume radio-f--current-volume)
  ;; VLC's GUI lets you set the volume up to 125%, and mpv
  ;; shows up to 130% in its default install. Give users
  ;; the numbers they would normally see.
  ;;
  ;; Protect your hearing, kids!
  (pcase radio-f-player-program
    ((or 'mpv 'vlc)
    (setq radio-f--current-volume
        (min 130
             (+ radio-f--current-volume 2)))
    (radio-f--send-command 'volume radio-f--current-volume)
    (let ((message-log-max nil))
  (message "Radio F volume: %d"
           radio-f--current-volume)))
    ('emms
     (emms-volume-raise))
    (_
     (error "Unknown player: %S"
            radio-f-player-program))))

(defun radio-f-volume-down ()
  "Decrease playback volume by two points."
  (interactive)
  (setq radio-f--previous-volume radio-f--current-volume)
 (pcase radio-f-player-program
    ((or 'mpv 'vlc)
    (setq radio-f--current-volume
        (max 0
             (- radio-f--current-volume 2)))
    (radio-f--send-command 'volume radio-f--current-volume)
    (let ((message-log-max nil))
      (message "Radio F volume: %d"
               radio-f--current-volume)))
    ('emms
     (emms-volume-lower))
    (_
     (error "Unknown player: %S"
            radio-f-player-program))))

(defun radio-f-reset-volume ()
  "Reset volume to its default level, as defined in `radio-f-default-volume'."
  (interactive)
  (setq radio-f--current-volume radio-f-preferred-volume)
  (radio-f--send-command 'volume
                           radio-f-preferred-volume)
  (let ((message-log-max nil))
    (let ((message-log-max nil))
      (message "Radio F reset to: %d"
               radio-f--current-volume))))

(defun radio-f-mute-audio ()
  "Toggle audio mute for the default player."
  (interactive)
  (if (eq radio-f--current-volume 0)
      (progn
        (radio-f--send-command 'volume radio-f--previous-volume)
        (setq radio-f--current-volume radio-f--previous-volume)
    (let ((message-log-max nil))
      (message "Radio F: audio restored."
               radio-f--current-volume)))
    (progn
      (setq radio-f--previous-volume radio-f--current-volume)
      (radio-f--send-command 'volume 0)
      (setq radio-f--current-volume 0)
    (let ((message-log-max nil))
      (message "Radio F: audio muted."
               radio-f--current-volume)))))

(defun radio-f-pause-audio ()
  "Toggle playback pause for the default player."
  (interactive)
  (pcase radio-f-player-program
    ('emms
     (emms-pause))
    ((or 'mpv 'vlc)
     (radio-f--send-command 'pause))
    (_
     (error "Unknown player: %S"
            radio-f-player-program))))

(defun radio-f-audio-start ()
  "Start playing the live stream of the current station."
  (interactive)
  (let ((stream-url
         (radio-f--get-stream-url)))
    (if (not stream-url)
        (message "No audio stream available for station: %s"
                 radio-f--current-station)
      ;; Stop any existing playback before starting a new player.
      (radio-f-audio-stop)
      (radio-f-control-mode 1)
      (condition-case err
          (pcase radio-f-player-program
            ('emms
             (emms-play-url stream-url))
            ('mpv
             (when (file-exists-p "/tmp/radio-f-mpv.sock")
               (radio-f--clear-mpv-socket))
             (setq radio-f--player-process
                   (make-process
                    :name "radio-f-mpv"
                    :buffer nil
                    :command
                    (list
                     "mpv"
                     "--no-video"
                     "--really-quiet"
                     "--idle"
                     "--input-ipc-server=/tmp/radio-f-mpv.sock"
                     stream-url)
                    :noquery t))
             (radio-f--send-command 'volume radio-f-default-volume)
             (unless (process-live-p radio-f--player-process)
               (error "mpv started but died immediately")))
            ('vlc
               (setq radio-f--player-process
                     (make-process
                      :name "radio-f-vlc"
                      :buffer nil
                      :command
                      (list
                       "vlc"
                       "-I" "rc"
                       ;; Port is "1971" because FIP started in 1971.
                       "--rc-host=127.0.0.1:1971"
                       "--rc-fake-tty"
                       "--no-video"
                       "--quiet"
                       "--network-caching=1500"
                       stream-url)
                      :noquery t))
             (unless (process-live-p radio-f--player-process)
               (error "VLC started but died immediately")))
            (_
             (error "Unknown player: %S"
                    radio-f-player-program)))
        (radio-f--wait-for-player-control)
        ;; VLC saves its volume level after shutdown, and
        ;; the --volume flag is no longer supported?
        ;;
        ;; Pourquoi, VLC?  Pourquoi?
        (radio-f--send-command 'volume radio-f-default-volume)
        (error
         (radio-f--log-error "audio-start" err)
         (message
          "Radio F Error: Failed to start player. See /tmp/fip-errors.log")
         (setq radio-f--player-process nil))))))

(defun radio-f-audio-stop ()
  "Stop audio playback."
  (interactive)
  (pcase radio-f-player-program
    ('emms
     (emms-stop))
    ('mpv
     (condition-case nil
         (radio-f--send-mpv-command '("quit"))
       (error nil))
     (ignore-errors
       (delete-file "/tmp/radio-f-mpv.sock")))
    ('vlc
     (condition-case nil
         (radio-f--send-vlc-command "shutdown")
       (error nil)))
    (_
     (error "Unsupported player: %S"
            radio-f-player-program)))
  (setq radio-f--player-process nil))



;; == Private helper functions ==================

(defconst radio-f--track-log-buffer-name
  "*Radio F Track Log*"
  "Name of the buffer used to record incoming track data.")

(defconst radio-f--alist-buffer-name
  "*Radio F - Alist Dump*"
  "Name of the buffer used to dump the alist of `radio-f--current-track-info'.")

(defconst radio-f--current-date-time-format
  "%a %b %d %H:%M:%S %Z %Y")


;; I told you, it's a surprise. Don't spoil it.
(defun radio-f--all-station-names ()
  "List all station names, with the preferred station appearing first."
  (let* ((stations
          (mapcar
           (lambda (station)
             (plist-get (cdr station) :name))
           (radio-f--stations)))
         (default radio-f-preferred-station))
    (if (member default stations)
        (cons default
              (delete default
                      (copy-sequence stations)))
      stations)))

(defun radio-f--favorite-stations-names ()
  "List favorite station names, with the preferred station appearing first."
  (let* ((stations
          (mapcar
           (lambda (station)
             (plist-get (cdr station) :name))
           (radio-f--stations)))
         (stations
          (if radio-f-favorite-stations
              (seq-filter
               (lambda (name)
                 (member name radio-f-favorite-stations))
               stations)
            stations))
         (default radio-f-preferred-station))
    (if (member default stations)
        (cons default
              (delete default (copy-sequence stations)))
      stations)))

(defun radio-f--record-track-log ()
  "Log the current time and track data to the buffer defined in `radio-f--track-log-buffer-name'.  Time is listed in the user's local timezone, not CET/CDT."
       (interactive)
       (let-alist radio-f--current-track-info
         (with-current-buffer
             (get-buffer-create radio-f--track-log-buffer-name)
           (let ((inhibit-read-only t))
             (goto-char (point-max))
             (unless (= (point) (point-min))
               (insert "\n"))
             (insert (format-time-string
                      radio-f--current-date-time-format) "\n")
             (insert (or .artist "No Artist") "\n")
             (insert (or .title "No Title") "\n")
             (insert (or .visual-url "No Artwork URL") "\n")))))

(defun radio-f--dump-current-track-data ()
  "Dump the current track's info alist into the buffer defined in `radio-f--alist-buffer-name'."
  (interactive)
  (when radio-f--current-track-info
    (with-current-buffer
        (get-buffer-create radio-f--alist-buffer-name)
      (let ((inhibit-read-only t))
        (goto-char (point-max))
        (insert "\n")
        (insert (format-time-string
                 radio-f--current-date-time-format
                 (current-time)))
        (insert "\n")
        (prin1 radio-f--current-track-info (current-buffer))
        (insert "\n")))))

(defun radio-f--prune-error-log ()
  "Delete the error log if it is more than a week old."
  (let* ((log-file "/tmp/radio-f-errors.log"))
    (when (file-exists-p log-file)
      (let* ((attrs (file-attributes log-file))
             (mtime (file-attribute-modification-time attrs))
             (age (float-time
                   (time-subtract (current-time) mtime))))
        ;; 168 hours = 604800 seconds
        (when (> age (* 168 60 60))
          (delete-file log-file))))))

(defun radio-f--set-frame-transparency (number)
  "Set the alpha value of the Frame view display.

NUMBER is the alpha value from from 0-100.

Does not work reliably in many operating systems and graphical
environments, X11 and Wayland in particular."
  (interactive "nInput transparency level (0-100): ")
    (set-frame-parameter radio-f--child-frame 'alpha-background number))

(defun radio-f--log-error (context err)
  "Log an error to /tmp/fip-errors.log with timestamp and CONTEXT.

CONTEXT is the function reporting the error.

ERR is the error sent to the Emacs \*Message\* buffer."
  (let ((log-file "/tmp/fip-errors.log")
        (timestamp (format-time-string "[%Y-%m-%d %H:%M:%S]")))
    (with-temp-buffer
      (insert (format "%s ERROR (%s): %s\n" timestamp context err))
      (append-to-file (point-min) (point-max) log-file))))

(defun radio-f--clear-mpv-socket ()
  "Clear mpv's Unix socket."
  (let ((socket "/tmp/radio-f-mpv.sock"))
    (when (file-exists-p socket)
      (delete-file socket))))

(defun radio-f--get-window-view-height ()
  "Retrieve the window view height."
  (interactive)
  (let* ((buf
          (get-buffer
           ( radio-f--generate-buffer-name)))
         (radio-f-window
          (and buf
               (get-buffer-window buf))))
    (when (window-live-p radio-f-window)
      (window-pixel-height radio-f-window))))

(defun radio-f--set-window-view-height (height)
  "Set the window view to HEIGHT pixels."
  (interactive "nWindow height in pixels: ")
  (let* ((buf
          (get-buffer
           ( radio-f--generate-buffer-name)))
         (win
          (and buf
               (get-buffer-window buf))))
    (when (window-live-p win)
      (let ((delta
             (- height
                (window-pixel-height win))))
        (window-resize win delta nil nil t)))))

(defun radio-f--dump-stations ()
  "Dump all supported Radio F stations into the buffer defined
in `radio-f--alist-buffer-name'."
  (interactive)
  (let ((stations (radio-f--all-station-names)))
    (with-current-buffer
        (get-buffer-create radio-f--alist-buffer-name)
      (let ((inhibit-read-only t))
        (goto-char (point-max))
        (prin1 stations (current-buffer))
        (insert "\n")))))



;; == Public functions ==

;;;###autoload
(defun radio-f (&optional station)
  "Play a radio station.  Its current track information is displayed
in a dynamically refreshing temporary buffer.

STATION is the desired station to play.  When called with no arguments,
the station played is governed by the custom variable
`radio-f-default-station'."
  (interactive)
  ;; Load the preferred plugins before doing anything else.
  (radio-f--load-plugins)
  ;; Provide a good view setting for TUI Emacs.
  (unless (display-graphic-p)
    (setq radio-f-view-style 'window
          radio-f-show-artwork nil
          radio-f-show-track-timeline nil))
  ;; Clear out any previous state that may still be lingering about.
  (radio-f-down)
  (radio-f--clear-mpv-socket)
  (setq station (or station
                    radio-f-preferred-station))
  (radio-f--prune-error-log)
  (let ((chosen-station (if (or (null station)
                                (string-empty-p station))
                            radio-f-preferred-station
                          station)))
    (setq radio-f--current-station chosen-station)
    (setq radio-f--current-volume radio-f-default-volume)
    (radio-f-audio-start)
    (let ((message-log-max nil))
      (message "Starting stream for %s" chosen-station))
    (when radio-f-show-track-timeline
      (setq radio-f--timeline-timer
            (run-at-time 1 1 #'radio-f--update-track-timeline)))
    ;; Hold on to your lily-white butts.
    (setq radio-f--timer
          (run-at-time 0 20 #'radio-f--fetch-json))))

;;;###autoload
(defun radio-f-down ()
  "Stop audio playback, remove the view, and reset all program state."
  (interactive)
  (radio-f-audio-stop)
  (radio-f--delete-views)
  (radio-f--kill-timeline)
  (radio-f--kill-timer)
  (setq radio-f--current-station nil
        radio-f--player-process nil
        radio-f--cover-uuid nil
        radio-f--current-track-info nil
        radio-f--timer nil
        radio-f--timeline-timer nil
        radio-f--child-frame nil
        radio-f--current-volume nil
        radio-f--previous-volume nil
        radio-f--view-visible-p t)
  (radio-f-control-mode -1)
  (radio-f--clear-mpv-socket)
  (let ((message-log-max nil))
    (message "Radio F: Stopped.")))

;;;###autoload
(defun radio-f-change-station ()
  "Switch to a different STATION from your favorites list."
  (interactive)
  ;; Try to keep the station order consistent by asking the
  ;; reader to ignore completion history, but doesn't always
  ;; succeed.  YMMV.
  (let* ((favorite-picked
          (completing-read
           "Choose Station: "
           (radio-f--favorite-stations-names)
           nil t nil t nil nil)))
    (setq radio-f--current-station favorite-picked)
    (radio-f--delete-views)
    (radio-f--kill-timer)
    (when radio-f-show-track-timeline
      (radio-f--reinitialize-timeline))
    ;; Keep holding onto those lily-white butts.
    (setq radio-f--timer
          (run-at-time 0 20 #'radio-f--fetch-json))
    (let ((message-log-max nil))
      (message "Radio F: You are listening to %s." favorite-picked))
    (radio-f-audio-start)))

;;;###autoload
(defun radio-f-change-to-any-station (&optional station)
  "Switch to a different STATION.

STATION is any station from all plugins."
  (interactive)
  ;; Try to keep the station order consistent by asking the
  ;; reader to ignore completion history, but doesn't always
  ;; succeed.  YMMV.
   (unless station
    (setq station
           (completing-read
            "Choose Station: "
           (radio-f--all-station-names)
           nil t nil t nil nil)))
   (setq radio-f--current-station station)
   (radio-f--delete-views)
   (radio-f--kill-timer)
   (when radio-f-show-track-timeline
    (radio-f--reinitialize-timeline))
  ;; Keep holding onto those lily-white butts.
  (setq radio-f--timer
        (run-at-time 0 20 #'radio-f--fetch-json))
  (let ((message-log-max nil))
    (message "Radio F: Now listening to %s." station))
  (radio-f-audio-start))

(defun radio-f-dark-mode ()
  "Start Radio F with its view hidden.  While hidden, the view continues
to refresh with new track information and timeline data.  The view will
remain hidden until the command `radio-f-toggle-view' displays the view."
  (interactive)
  (let ((radio-f--view-visible-p nil))
    (radio-f)))

(defun radio-f-play-preferred-station ()
  "Switch back to the preferred station."
  (interactive)
  (radio-f-change-to-any-station
   radio-f-preferred-station))

;; SURPRISE!!
(defun radio-f-surprise-me ()
  "Tune to a random station."
  (interactive)
  (let* ((stations
          (radio-f--all-stations))
         (station
          (nth (random (length stations))
               stations))
         (name
          (plist-get (cdr station) :name)))
    (radio-f-change-to-any-station name)))

(defun radio-f-browse-station-page ()
  "Open a browser to the page of the currently playing station."
  (interactive)
  (let* ((station
          (radio-f--get-current-station-data))
         (plugin
          (plist-get station :plugin))
         (template
          (radio-f--get-station-page-template plugin)))
    (browse-url
     (radio-f--expand-url template station))))



;; == Housekeeping ======

(radio-f--prune-error-log)

(provide 'radio-f)

;;; radio-f.el ends here
