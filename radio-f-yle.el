;;; radio-f-yle.el --- YLE plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 27 Sep 26
;; Keywords: hypermedia, network, streaming, radio, Finland

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
;; YLE (Finland), 17 stations.
;;
;; In other words, I'll need help.  So please, help!
;;

;;; Code:

;; == STATION PLIST =====

;;
;; YLE - https://yleradiolive5.akamaized.net/hls/live/20000869/yleradio1/master.m3u8
;; https://icecast.live.yle.fi/radio/yleradio1/icecast.audio
;; https://player.api.yle.fi/v1/preview/yle-radio-1.json?app_id=player_static_prod&app_key=8930d72170e48303cf5f3867780d549b&language=fin&countryCode=US&host=areena.yle.fi&isMobile=false&isPortabilityRegion=false&ssl=true

;; == STATION PLIST =====

(defconst radio-f--yle-stations
  '((yle-radio1
     :name "YLE Radio 1" :carrier yle :id "radio1"
     :l1 "radio1" :key "radio1"
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-radio2-antwerpen
     :name "YLE Radio 2 Antwerpen" :carrier yle :id "ra2ant"
     :l1 "radio2-antwerpen" :key "ra2ant"
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-radio2-oost-vlaanderen
     :name "YLE Radio 2 Oost-Vlaandere" :carrier yle :id "ra2ovl"
     :l1 "radio2-oost-vlaanderen" :key "ra2ant"
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-radio2-west-vlaanderen
     :name "YLE Radio 1" :carrier yle :id "ra2wvl"
     :l1 "radio2-west-vlaanderen" :key "ra2wvl"
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-radio2-vlaams-brabant
     :name "YLE Radio 1" :carrier yle :id "ra2vlb"
     :l1 "radio2-vlaams-brabant" :key "ra2vlb"
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-radio2-limburg
     :name "YLE Radio 1" :carrier yle :id "ra2lim"
     :l1 "radio2-limburg" :key "ra2lim"
     :api radio-f--yle-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-studio-brussels
     :name "YLE Studio Brussels" :carrier yle :id "stubru"
     :l1 "stubru" :key "stubru"
     :api radio-f--yle-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    (yle-klara
     :name "YLE Klara" :carrier yle :id "klara"
     :l1 "klara" :key "klara"
     :api radio-f--yle-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :processor radio-f--yle-processor)
    )
    "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--yle-api-url
  "https://media-services-public.yle.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-<<id>>"
  "Template to retrieve metadata for YLE streams")

(defconst radio-f--yle-www-url
  "https://www.yle.be/radio/<<id>>"
  "URL template for YLE station home pages.")


;; == STREAM URLS =======

(defconst radio-f--yle-radio-level-one ;; AAC, 192kbps
  "https://radio.ylecdn.be/yle/<<id>>/live.m3u8"
  "Template used for VERT Level One audio stream playback.")

(defconst radio-f--yle-radio-level-two ;; MP3, 128kpbs
  "https://icecast.ylecdn.be/<<id>>-high.mp3"
  "Template for YLE Level Two audio stream playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-yle-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--yle-api-url
          (symbol-value api))))

(defun radio-f--set-yle-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--swr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-yle-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--swr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--yle-streams
  `((One     . radio-f--set-yle-stream-level-one)
    (Two     . radio-f--set-yle-stream-level-two)
    (default . radio-f--set-yle-stream-level-one))
  "Audio stream templates provided by Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--yle-radio-processor (data station)
  "Process YLE Radio DATA for STATION."
  (let* ((name (plist-get station :name))
         (data (cdr (assoc "data" data)))
         (now (aref data 0))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startStamp" now)))
           'integer))
         (duration (cdr (assoc "duration" now)))
         (length (/ 1000 duration))
         (end (+ duration start))
         (visual-url (cdr (assoc "image" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--yle-web-processor (data station)
  "Process YLE Web DATA for STATION."
  (let* ((name (plist-get station :name))
         (data (cdr (assoc "data" data)))
         (now (aref data 0))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startStamp" now)))
           'integer))
         (duration (cdr (assoc "duration" now)))
         (length (/ 1000 duration))
         (end (+ length start))
         (visual-url (cdr (assoc "image" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(provide 'radio-f-yle)

;;; radio-f-ard.el ends here
