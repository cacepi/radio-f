;;; radio-f-vrt.el --- VRT plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 27 Sep 26
;; Keywords: hypermedia, network, streaming, radio, Belgium, Flanders

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
;; VRT (Flanders), 17 stations.
;;
;; In other words, I'll need help.  So please, help!
;;

;;; Code:


;; == STATION PLIST =====

;;
;; VRT - https://www.vrt.be/vrtnu-api/graphql/public/v1
;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-radio1

;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-stubruuntz
;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-stubru-vuurland
;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-radio1classics
;; Radio 2 Relax
;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-radio2unwind
;; https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-stubrudejarennul

;; == STATION PLIST =====

(defconst radio-f--vrt-stations
  '((vrt-radio1
     :name "VRT Radio 1" :carrier vrt :id "radio1"
     :l1 "radio1" :key "radio1"
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-radio2-antwerpen
     :name "VRT Radio 2 Antwerpen" :carrier vrt :id "ra2ant"
     :l1 "radio2-antwerpen" :key "ra2ant"
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-radio2-oost-vlaanderen
     :name "VRT Radio 2 Oost-Vlaandere" :carrier vrt :id "ra2ovl"
     :l1 "radio2-oost-vlaanderen" :key "ra2ant"
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-radio2-west-vlaanderen
     :name "VRT Radio 1" :carrier vrt :id "ra2wvl"
     :l1 "radio2-west-vlaanderen" :key "ra2wvl"
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-radio2-vlaams-brabant
     :name "VRT Radio 1" :carrier vrt :id "ra2vlb"
     :l1 "radio2-vlaams-brabant" :key "ra2vlb"
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-radio2-limburg
     :name "VRT Radio 1" :carrier vrt :id "ra2lim"
     :l1 "radio2-limburg" :key "ra2lim"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-studio-brussels
     :name "VRT Studio Brussels" :carrier vrt :id "stubru"
     :l1 "stubru" :key "stubru"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-klara
     :name "VRT Klara" :carrier vrt :id "klara"
     :l1 "klara" :key "klara"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-mnm
     :name "VRT MNM" :carrier vrt :id "mnm"
     :l1 "mnm" :key "mnm"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-mnm
     :name "VRT MNM Hits" :carrier vrt :id "mnm_hits"
     :l1 "mnm_hits" :key "mnm_hits"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-de-tijdloze
     :name "VRT De Tijdloze" :carrier vrt :id "stubru_tijdloze"
     :l1 "stubru_tijdloze" :key "stubrutijdloze"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    (vrt-zware-gitaren
     :name "VRT Studio Brussel Zware Gitaren" :carrier vrt :id "stubru_bruut"
     :l1 "stubru_bruut" :key "studio-brussel-zware-gitaren"
     :api radio-f--vrt-api-url
     :l1-stream radio-f--vrt-stream-level-one
     :l2-stream radio-f--vrt-stream-level-two
     :processor radio-f--vrt-processor)
    )
    "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--vrt-api-url
  "https://media-services-public.vrt.be/vualto-video-aggregator-web/rest/external/v2/channels/livestream-audio-<<id>>"
  "Template to retrieve metadata for VRT streams")

(defconst radio-f--vrt-www-url
  "https://www.vrt.be/vrtmax/livestream/audio/<<key>>/?tab=playlist"
  "URL template for VRT station home pages.")


;; == STREAM URLS =======

(defconst radio-f--vrt-radio-level-one ;; AAC, 192kbps
  "https://radio.vrtcdn.be/vrt/<<id>>/live.m3u8"
  "Template used for VERT Level One audio stream playback.")

(defconst radio-f--vrt-radio-level-two ;; MP3, 128kpbs
  "https://icecast.vrtcdn.be/<<id>>-high.mp3"
  "Template for VRT Level Two audio stream playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-vrt-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--vrt-api-url
          (symbol-value api))))

(defun radio-f--set-vrt-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--swr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-vrt-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--swr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--vrt-streams
  `((One     . radio-f--set-vrt-stream-level-one)
    (Two     . radio-f--set-vrt-stream-level-two)
    (default . radio-f--set-vrt-stream-level-one))
  "Audio stream templates provided by Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--vrt-radio-processor (data station)
  "Process VRT Radio DATA for STATION."
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

(defun radio-f--vrt-web-processor (data station)
  "Process VRT Web DATA for STATION."
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

(provide 'radio-f-vrt)
