;;; radio-f-err.el --- ERR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Tue 10 Nov 26
;; Keywords: hypermedia, network, streaming, radio, Estonia

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
;; ERR (Estonia) plugin for Radio F: 19 Stations.
;;
;; Uses an API similar to the BEEB: a single JSON file contains all
;; stations in a separate array, with each array pointing to the endpoint
;; names, artwork, streams, metadata, etc. for a specific station.  Nice!
;;
;; When a carrier is organized as well as this, it's easy to add all the
;; stations very quickly: this only took 25 minutes to do.  Compare that to
;; struggling for days with more abstruse carriers that I could name.
;;
;; Hello, Deutschlandradio!
;;
;; Three stations, three days.

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--err-stations
  '((err-vikerraadio
     :name "ERR Vikerraadio" :carrier err :id "vikerraadio"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-raadio2
     :name "ERR Raadio 2" :carrier err :id "raadio2"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-klassikraadio
     :name "ERR Klassik Raadio" :carrier err :id "klassikraadio"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-raadio4
     :name "ERR Raadio 4" :carrier err :id "raadio4"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-raadiotallinn
     :name "ERR Raadio Tallinn" :carrier err :id "raadiotallinn"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2chill
     :name "ERR R2 Chill" :carrier err :id "r2chill"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2eesti
     :name "ERR R2 Eesti" :carrier err :id "r2eesti"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2pop
     :name "ERR R2 Pop" :carrier err :id "r2pop"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2p
     :name "ERR R2 Rapp" :carrier err :id "r2p"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2rock
     :name "ERR R2 Rock" :carrier err :id "r2rock"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2alternatiiv
     :name "ERR R2 Alternatiiv" :carrier err :id "r2alternatiiv"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r2music
     :name "ERR R2 Music" :carrier err :id "r2music"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-klaraklassik
     :name "ERR Klara Klassik" :carrier err :id "klaraklassik"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-klarajazz
     :name "ERR Klara Jazz" :carrier err :id "klarajazz"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-klaranostalgia
     :name "ERR Klara Nostalgia" :carrier err :id "klaranostalgia"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-klarameditatsioon
     :name "ERR Klara Meditatsioon" :carrier err :id "klarameditatsioon"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-r4retro
     :name "ERR R4 Retro" :carrier err :id "r4retro"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-eestiraadio
     :name "ERR Eesti Raadio" :carrier err :id "eestiraadio"
     :api radio-f--err-api-url :processor radio-f--err-processor)
    (err-eri3
     :name "ERR Eri3" :carrier err :id "eri3"
     :api radio-f--err-api-url :processor radio-f--err-processor))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

;; ALL CHANNELS
;; https://eestiraadio.err.ee/api/v1/channels

(defconst radio-f--err-api-url
  "https://eestiraadio.err.ee/api/v1/channels/<<id>>"
  "Template to retrieve metadata for ERR stations.")

(defconst radio-f--err-www-url
  "https://eestiraadio.err.ee/<<id>>"
  "URL Template for ERR station home pages.")


;; == STREAM URL ========

(defconst radio-f--err-stream-level-one ;; AAC, 192kbps
  "https://live.err.ee/live/<<id>>.m3u8"
  "Template used to return a Level One audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--err-streams
  `((One     . ,radio-f--err-stream-level-one)
    (_       . ,radio-f--err-stream-level-one))
  "Audio stream templates provided by ERR.")


;; == PROCESSORS ================================

(defun radio-f--err-processor (data station)
  "Process ERR JSON DATA for STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "data" data)))
         (channels (cdr (assoc "channels" root)))
         (now (aref channels 0))
         (artist (plist-get station :name))
         (title (cdr (assoc "seriesName" now)))
         (start (cdr (assoc "startTime" now)))
         (end (cdr (assoc "endTime" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title start end))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,(format
                     "https://img.err.ee/insecure/resize:fit:620:620/plain/image:///%s"
                     (cdr (assoc "photoUrlBase" now)))))))

(provide 'radio-f-err)
