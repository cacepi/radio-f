;;; radio-f-rtbf.el --- RTBF plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 27 Sep 26
;; Keywords: hypermedia, network, streaming, radio, Belgium

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
;; RTBF (Belgium) plugin for Radio F: 15 Stations ATM.

;;; Code:

;; == STATION PLIST =====

;;
;; VRT - https://www.vrt.be/vrtnu-api/graphql/public/v1
;;

;; https://mapi-prod.radioplayer.co.uk/api/be/public/service/12
;; https://radio.rtbf.be/viva-bxl/aac-128/rp-web
;; https://bff-service.rtbf.be/radioplayer/v1/threads?keys=vivacite


(defconst radio-f--rtbf-stations
  '(
    (rtbf-lapremiere
     :name "RTBF La Premiere" :carrier rtbf :id "lapremiere"
     :api radio-f--rtbf-api-url :radio-id "lapremiere"
     :processor radio-f--rtbf-radio-processor
     :stream radio-f--rtbf-radio-level-one)
    (rtbf-classic21
     :name "RTBF Classic 21" :carrier rtbf :id "classic21"
     :api radio-f--rtbf-api-url :radio-id "classic21"
     :processor radio-f--rtbf-radio-processor
     :stream radio-f--rtbf-radio-level-one)
    (rtbf-classic21-60s
     :name "RTBF Classic 21 60s Web" :carrier rtbf :id "classic21_60"
     :api radio-f--rtbf-api-url :web-id "c21-60s" :service "21"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-70s
     :name "RTBF Classic 21 70s Web" :carrier rtbf :id "classic21_70"
     :api radio-f--rtbf-api-url :web-id "c21-70s" :service "22"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-80s
     :name "RTBF Classic 21 80s Web" :carrier rtbf :id "classic21_80"
     :api radio-f--rtbf-api-url :web-id "c21-80s" :service "20"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-newwave
     :name "RTBF Classic 21 New Wave Web" :carrier rtbf :id "classic21_newwave"
     :api radio-f--rtbf-api-url :web-id "c21-80nw" :service "148"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-90s
     :name "RTBF Classic 21 90s Web" :carrier rtbf :id "classic21_90"
     :api radio-f--rtbf-api-url :web-id "c21-90s" :service "90"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-blues
     :name "RTBF Classic 21 Blues Web" :carrier rtbf :id "classic21_blues"
     :api radio-f--rtbf-api-url :web-id "c21-blues" :service "200"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-live
     :name "RTBF Classic 21 Live Web" :carrier rtbf :id "classic21_live"
     :api radio-f--rtbf-api-url :web-id "c21-live" :service "1107"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-metal
     :name "RTBF Classic 21 Metal Web" :carrier rtbf :id "classic21_metal"
     :api radio-f--rtbf-api-url :web-id "c21-metal" :service "29"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-njr
     :name "RTBF Classic 21 80s Web" :carrier rtbf :id "classic21_njr"
     :api radio-f--rtbf-api-url :web-id "c21-njr" :service "27"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-66
     :name "RTBF Classic 21 Route 66 Web" :carrier rtbf :id "classic21_66"
     :api radio-f--rtbf-api-url :web-id "c21-66" :service "201"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-soul
     :name "RTBF Classic 21 Soul Web" :carrier rtbf :id "classic21_soul"
     :api radio-f--rtbf-api-url :web-id "c21-soul" :service "26"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-classic21-underground
     :name "RTBF Classic 21 Soul Web" :carrier rtbf :id "classic21_underground"
     :api radio-f--rtbf-api-url :web-id "c21-under" :service "19"
     :processor radio-f--rtbf-web-processor
     :stream radio-f--rtbf-web-level-one)
    (rtbf-vivacite
     :name "RTBF 2" :carrier rtbf :id "vivacite"
     :api radio-f--rtbf-api-url :radio-id "viva-bxl"
     :processor radio-f--rtbf-radio-processor
     :stream radio-f--rtbf-radio-level-one))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--rtbf-api-url
  "https://bff-service.rtbf.be/radioplayer/v1/threads?keys=<<id>>"
  "Template to retrieve metadata for RTBF streams")

(defconst radio-f--rtbf-url
  "https://www.rtbf.be/radio/<<id>>"
  "URL template for RBTF station WWW homepages.")

;; == STREAM URLS =======

(defconst radio-f--rtbf-radio-level-one ;; AAC, 128kbps
  "https://radio.rtbf.be/<<radio-id>>/aac-128/rp-web"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--rtbf-web-level-one ;; MP3, 128kpbs
  "https://radio.rtbf.be/<<web-id>>/mp3-128/rp-web"
  "Template used to return a Level One web audio stream for playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-rtbf-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--rtbf-api-url
          (symbol-value api))))

(defun radio-f--set-rtbf-stream ()
  (let* ((station (radio-f--get-current-station-data))
         (stream (plist-get station :stream)))
    (setq radio-f--rtbf-level-one
          (symbol-value stream))))

;; (defun radio-f--set-rtbf-stream-level-two ()
;;   (let* ((station (radio-f--get-current-station-data))
;;          (l2-stream (plist-get station :l2-stream)))
;;     (setq radio-f--rtbf-level-two
;;           (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--rtbf-streams
  `((One     . radio-f--set-rtbf-stream)
    (default . radio-f--set-rtbf-stream))
  "Audio stream templates provided by RBTF.")


;; (defun radio-f--set-rtbf-streams ()
;;   (let* ((station (radio-f--get-current-station-data))
;;          (stream (plist-get station :stream))
;;          (streams-symbol
;;           (cdr (assq stream radio-f--ard-stream-providers))))
;;     (setq radio-f--rtbf-streams
;;           (symbol-value streams-symbol))))


;; == PROCESSORS ================================

(defun radio-f--rtbf-radio-processor (data station)
  "Process RTBF Radio DATA for STATION."
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
         (end (cdr (assoc "duration" now)))
         ;; (end (+ duration start))
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

(defun radio-f--rtbf-web-processor (data station)
  "Process RTBF Web DATA for STATION."
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
         (end (cdr (assoc "duration" now)))
         ;; (end (+ duration start))
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

(provide 'radio-f-rtbf)

;;; radio-f-ard.el ends here
