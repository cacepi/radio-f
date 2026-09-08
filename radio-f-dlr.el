;;; radio-f-ard.el --- DLR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Mon 31 Aug 26
;; Keywords: hypermedia, network, streaming, radio, Radio France

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
;; Deutschlandradio plugin for Radio F: 3 stations.
;;
;; ARD might be even better organized than the BBC. A single, unified
;; URL template to retrieve metadata for every ARD station, complete
;; with multiple streams for each carrier defined in the master
;; JSON list. Give it to German public radio for being even more
;; punctilious than the BBC.
;;
;; All's not love and roses, as Deutschlandradio refuses to play ball
;; with the other carriers, so little to no proper artwork for their
;; regular programming.  Radio F has to supply its own, instead.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--dlr-stations
  '((dlf
     :name "Deutschlandfunk" :carrier dlr :metadata dlf :id "01"
     :tag "funk" :raw t
     :api radio-f--dlf-api-url
     :processor radio-f--dlf-processor
     :www radio-f--dlf-url
     :visual-url nil :visual radio-f--dlf-visual)
    (dlf-kultur
     :name "Deutschlandfunk Kultur" :carrier dlr :metadata dlf-kultur :id "02"
     :tag "funkkultur" :raw t
     :api radio-f--dlf-kultur-api-url
     :processor radio-f--dlf-processor
     :www radio-f--dlf-url
     :visual-url nil :visual radio-f--dlf-kultur-visual)
    (dlf-nova
     :name "Deutschlandfunk Nova" :carrier dlr :metadata dlf-nova :id "03"
     :tag "funknova" :api radio-f--dlf-nova-api-url
     :processor radio-f--dlf-nova-processor
     :www radio-f--dlf-url
     :visual-url nil :visual radio-f--dlf-nova-visual))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for development purposes.")

(defconst radio-f--ard-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=<<float>>"
  "Template to retrieve metadata from all supported carriers through the ARD Audiothek API.")

(defconst radio-f--dlf-api-url
  "https://www.deutschlandfunk.de/api/partials/CurrentBroadcast?dlrsearch:_ajax=1"
    "URL to AJAX data from Deutschlandfunk.")

(defconst radio-f--dlf-kultur-api-url
  "https://www.deutschlandfunkkultur.de/api/partials/CurrentBroadcast?dlrsearch:_ajax=1"
  "URL to AJAX data from Deutschlandfunk Kultur.")

(defconst radio-f--dlf-nova-api-url
  "https://static.deutschlandfunknova.de/actions/dradio/playlist/onair"
  "Template used to retrieve JSON data from Deutschlandfunk Nova.")


;; == WEB URLS ==========

(defconst radio-f--dlf-www-url
  "https://www.deutschland[tag].de"
  "Template used to return the web URL for Deutschland Radio stations.")


;; == ARTWORK URLS ==========

(defconst radio-f--dlf-visual
  "assets/dlr/dlf.png"
  "Artwork image for Deutschlandfunk.")

(defconst radio-f--dlf-kultur-visual
  "assets/dlr/dlf-kultur.png"
  "Artwork image for Deutschlandfunk Kultur.")

(defconst radio-f--dlf-nova-visual
  "assets/dlr/dlf-nova.png"
  "Artwork image for Deutschlandfunk Kultur.")


;; == STREAM URLS =======

(defconst radio-f--dlr-level-one ;; AAC, 192kbps
  "https://st<<id>>.sslstream.dlf.de/dlf/<<id>>/high/aac/stream.aac"
  "Template used to return a level one audio stream for playback.")

(defconst radio-f--dlr-level-two ;; AAC, 96kbps
  "https://st<<id>>.sslstream.dlf.de/dlf/<<id>>/mid/aac/stream.aac"
  "Template used to return a level two stream for playback.")

(defconst radio-f--dlr-level-three ;; Opus, 64kbps
  "https://st<<id>>.sslstream.dlf.de/dlf/<<id>>/high/opus/stream.opus"
  "Template used to return a level three audio stream for playback.")

(defconst radio-f--dlr-level-four ;; Opus, 24kbps
  "https://st<<id>>.sslstream.dlf.de/dlf/<<id>>/low/opus/stream.opus"
  "Template used to return a level four audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--dlr-streams
  `((One     . ,radio-f--dlr-level-one)
    (Two     . ,radio-f--dlr-level-two)
    (Three   . ,radio-f--dlr-level-three)
    (Four    . ,radio-f--dlr-level-four)
    (default . ,radio-f--dlr-level-one))
  "Audio stream templates provided by Deutschland Radio.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-dlr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--dlr-api-url
          (symbol-value api))))

(defun radio-f--extract-dlr-json (data)
  "Extract Deutschlandfunk JSON from HTML DATA."
  (when (string-match
         "class=\"js-client-queries\"[^>]+data-json=\"\\([^\"]+\\)\""
         data)
    (replace-regexp-in-string
     "&quot;" "\""
     (match-string 1 data))))


;; == PROCESSORS ================================

(defun radio-f--ard-processor (data station)
  (let* ((events (cdr (assoc "events" data)))
         (object (aref events 0))
         (track-info (cdr (assoc "title" object)))
         (image  (cdr (assoc "image" object)))
         (artist (cdr (assoc "short" track-info)))
         (title (cdr (assoc "subTitle" track-info)))
         (start-string (cdr (assoc "startDate" object)))
         (end-string (cdr (assoc "endDate" object)))
         (start (time-convert
                 (date-to-time start-string) 'integer))
         (end (time-convert
               (date-to-time end-string) 'integer))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startDate" object)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "endDate" object)))
           'integer))
         (visual-url (cdr (assoc "contentUrl" image)))
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--dlf-processor (data station)
  "Process Deutschlandfunk DATA for STATION."
  (let* ((json-object-type 'alist)
         (json-key-type 'string)
         (json-string (radio-f--extract-dlr-json data))
         (json (json-read-from-string json-string))
         (key (cdr (assoc "key" json)))
         (value (cdr (assoc "value" json)))
         (payload (cdr (assoc "data" value)))
         (now (cdr (assoc "currentBroadcast" payload)))
         (artist (cdr (assoc "producer" now)))
         (title (cdr (assoc "title" now)))
         ;; (start-string (cdr (assoc "startTime" now)))
         ;; (end-string (cdr (assoc "endTime" now)))
         ;; (start (time-convert
         ;;         (date-to-time start-string) 'integer))
         ;; (end (time-convert
         ;;       (date-to-time end-string) 'integer))
         ;; (start
         ;;  (time-convert
         ;;   (date-to-time
         ;;    (cdr (assoc "startTime" object)))
         ;;   'integer))
         ;; (end
         ;;  (time-convert
         ;;   (date-to-time
         ;;    (cdr (assoc "endTime" object)))
         ;;   'integer))
         (visual-url (symbol-value (plist-get station :visual-url)))
         (start (cdr (assoc "startTime" now)))
         (end (cdr (assoc "endTime" now)))
         ;; Deutschland Radio has no UUID for track/program
         ;; info, so we have to make our own.
         ;;
         ;; But don't worry, it's secure!
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--dlf-nova-processor (data station)
  "Process Deutschlandfunk Nova DATA for STATION."
  (let* ((now (cdr (assoc "playlistItem" data)))
         (presenter (cdr (assoc "presenter" data)))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start (cdr (assoc "starttime" now)))
         (end (cdr (assoc "stoptime" now)))
         (cover (cdr (assoc "cover" now)))
         (dab320 (cdr (assoc "dab320" presenter)))
         (avatar  (cdr (assoc "avatar" presenter)))
         ;; DLR Nova loves to make it difficult to find
         ;; artwork.
         (visual-url (symbol-value (plist-get station :visual-url)))
         ;; (visual-url
         ;;  (cond
         ;;   ((and cover
         ;;         (not (string-empty-p cover)))
         ;;    cover)
         ;;   ((and dab320
         ;;         (not (string-empty-p dab320)))
         ;;    dab320)
         ;;   ((and avatar
         ;;         (not (string-empty-p avatar)))
         ;;    avatar)
         ;;   ;; The Postmaster still needs a visual-url, even if we know
         ;;   ;; that there isn't one. The Gatekeeper will know if there
         ;;   ;; is no image data, and call the local artwork accordingly.
         ;;   (_
         ;;    (symbol-value
         ;;     (plist-get station :visual-url)))))
         ;; Like its sister stations, DLR Nova has no UUID
         ;; for JSON objects. Use the same fix as the others.
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
      ;; Fill in the returned values.  Postmaster takes it from there.
      `((item-id    . ,item-id)
        (artist     . ,artist)
        (title      . ,title)
        (start      . ,start)
        (end        . ,end)
        (visual-url . ,visual-url))))

(provide 'radio-f-dlr)

;;; radio-f-dlr.el ends here
