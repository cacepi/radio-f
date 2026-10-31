;;; radio-f-mdr.el --- MDR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Thu 1 Oct 26
;; Keywords: hypermedia, network, streaming, radio, Germany

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
;; MDR plugin for Radio F: 26 Stations.
;;
;; Uses the ARD Audiothek API for JSON metadata.

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--mdr-stations
  '((mdr-aktuell
     :name "MDR Aktuell" :carrier mdr :id "mdraktuell"
     :station "0" :l2-id "284340" :bitrate "high"
     :publisher "3e6537f312b8ee7e" :livestream "f6796de5b1812b75"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-jump
     :name "MDR Jump" :carrier mdr :id "mdrjump"
     :station "0" :l2-id "284320" :bitrate "high"
     :publisher "3e6537f312b8ee7e" :livestream "4ce6861c20c7af36"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-klassik
     :name "MDR Klassik" :carrier mdr :id "mdrklassik"
     :station "0" :l2-id "284350" :bitrate "high"
     :publisher "3e6537f312b8ee7e" :livestream "a4a713490dda3905"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-kultur
     :name "MDR Kultur" :carrier mdr :id "mdrkultur"
     :station "0" :l2-id "284310" :bitrate "high"
     :publisher "3e6537f312b8ee7e" :livestream "4127500380e33b19"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-kultur-konzerte
     :name "MDR Kultur Konzerte Web" :carrier mdr
     :station "0" :l2-id "284311" :bitrate "high"
     :publisher "3e6537f312b8ee7e" :livestream "746477d13d92a028"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sorbische
     :name "MDR Serbian" :carrier mdr :id "mdrsachsensorb"
     :station "0" :l2-id "990100" :bitrate "high"
     :publisher "4a35b75753f10416" :livestream "79e67262b85dca0a"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-dresden
     :name "MDR Dresden" :carrier mdr :id "mdrsachsendd"
     :station "0" :l2-id "284280" :bitrate "high"
     :publisher "4a35b75753f10416" :livestream "2c2ba1a9a224a773"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-bautzen
     :name "MDR Bautzen" :carrier mdr :id "mdrsachsenbz"
     :station "1" :l2-id "284280" :bitrate "high"
     :publisher "4a35b75753f10416" :livestream "9debbd83e147166b"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-chemnitz
     :name "MDR Chemnitz" :carrier mdr :id "mdrsachsenc"
     :station "2" :l2-id "284280" :bitrate "high"
     :publisher "4a35b75753f10416" :livestream "3a761199dd060810"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-leipzig
     :name "MDR Leipzig" :carrier mdr :id "mdrsachsenl"
     :station "3" :l2-id "284280" :bitrate "high"
     :publisher "4a35b75753f10416" :livestream "5a836d887c2c437a"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-magdeburg
     :name "MDR Magdeburg" :carrier mdr :id "mdrsachsenanhaltmd"
     :station "0" :l2-id "284290" :bitrate "high"
     :publisher "08c556bcfa1b3285" :livestream "acab5d4e5c36577d"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-dessau
     :name "MDR Dessau" :carrier mdr :id "mdrsachsenanhaltde"
     :station "1" :l2-id "284290" :bitrate "high"
     :publisher "08c556bcfa1b3285" :livestream "6e9099353f695ea7"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-halle
     :name "MDR Stendal" :carrier mdr :id "mdrsachsenanhalthal"
     :station "2" :l2-id "284290" :bitrate "high"
     :publisher "08c556bcfa1b3285" :livestream "1f6dbcb634b580d3"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-stendal
     :name "MDR Stendal" :carrier mdr :id "mdrsachsenanhaltsdl"
     :station "3" :l2-id "284290" :bitrate "high"
     :publisher "08c556bcfa1b3285" :livestream "0a5a98a41ef6c259"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik
     :name "MDR Sputnik Web" :carrier mdr
     :station "0" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "cb686e1bbd1c9adb"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-firstplay
     :name "MDR Sputnik Firstplay Web" :carrier mdr
     :station "3" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "a2524d96ebbd663e"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-rock
     :name "MDR Sputnik Rock Web" :carrier mdr
     :station "1" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "163f07b378c75798"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-club
     :name "MDR Sputnik Club Web" :carrier mdr
     :station "2" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "d68a29a554c58ef7"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-popkult
     :name "MDR Sputnik Popkult Web" :carrier mdr
     :station "4" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "eee1e451f4894828"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-roboton
     :name "MDR Sputnik Roboton Web" :carrier mdr
     :station "5" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "62d470446f2156a1"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-sputnik-soundcheck
     :name "MDR Sputnik Soundcheck Web" :carrier mdr
     :station "6" :l2-id "284330" :bitrate "high"
     :publisher "b047738ae6c45914" :livestream "373253aafb6675d7"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-thuringen-mitte
     :name "MDR Thüringen Mitte" :carrier mdr :id "mdrthueringenmwth"
     :station "0" :l2-id "284300" :bitrate "high"
     :publisher "775651b61cfa02a1" :livestream "4fe4449ee498fb97"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-thuringen-ost
     :name "MDR Thüringen Ost" :carrier mdr :id "mdrthueringenoth"
     :station "1" :l2-id "284300" :bitrate "high"
     :publisher "775651b61cfa02a1" :livestream "e8edfa26cfa9661a"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-thuringen-north
     :name "MDR Thüringen Nord" :carrier mdr :id "mdrthueringennth"
     :station "2" :l2-id "284300" :bitrate "high"
     :publisher "775651b61cfa02a1" :livestream "ebf2dcd2050be8e5"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-thuringen-sud
     :name "MDR Thüringen Süd" :carrier mdr :id "mdrthueringensth"
     :station "3" :l2-id "284300" :bitrate "high"
     :publisher "775651b61cfa02a1" :livestream "7d089b005b4c2db3"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-one
     :l2-stream radio-f--mdr-radio-level-two)
    (mdr-tweens
     :name "MDR Tweens Web" :carrier mdr
     :station "0" :l2-id "991101" :bitrate "high"
     :publisher "7a96971f9ce005ad" :livestream "823dcb1b2033a30c"
     :api radio-f--mdr-web-api-url
     :processor radio-f--mdr-web-processor
     :l1-stream radio-f--mdr-radio-level-two
     :l2-stream radio-f--mdr-radio-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--mdr-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:mdr:permanent-livestream:<<livestream>>?pastHours=0.1"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--mdr-web-api-url
  "https://api.ardaudiothek.de/graphql?query=query%20MediaCollectionPermanentLivestreamsQuery(%24id%3AString!)%7BpermanentLivestream(id%3A%24id)%7BmediaCollection(v%3AV6A)%7D%7D&variables=%7B%22id%22%3A%22urn%3Aard%3Apermanent-livestream%3A<<livestream>>%22%7D"
  "Template to submit a GraphQL query for MDR web/radio streams")

(defconst radio-f--mdr-url
  "https://www1.mdr.de/radio/<<mdr-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--mdr-radio-level-one ;; AAC, 192kbps
  "https://mdr-radio.ard-mcdn.de/mdr/radio/<<id>>/hls/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--mdr-radio-level-two ;; MP3
  "https://mdr-<<l2-id>>-<<station>>.sslcast.mdr.de/mdr/<<l2-id>>/<<station>>/mp3/<<bitrate>>/stream.mp3"
  "Template used to return a Level Two audio stream for playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-mdr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--mdr-api-url
          (symbol-value api))))

(defun radio-f--set-mdr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--mdr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-mdr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--mdr-level-two
          (symbol-value l2-stream))))

;; == STREAM LEVELS =====

(defvar radio-f--mdr-streams
  `((One     . radio-f--set-mdr-stream-level-one)
    (Two     . radio-f--set-mdr-stream-level-two)
    (default . radio-f--set-mdr-stream-level-one))
  "Audio stream templates provided by Rundfunk.")

;; == PROCESSORS ================================

(defun radio-f--mdr-web-processor (data station)
  "Process MDR Web DATA for STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "data" data)))
         (stream (cdr (assoc "permanentLivestream" root)))
         (media (cdr (assoc "mediaCollection" stream)))
         (meta (cdr (assoc "meta" media)))
         (images (cdr (assoc "images" meta)))
         (now (aref images 1))
         (artist (cdr (assoc "title" meta)))
         (title (cdr (assoc "clipSourceName" meta)))
         (start (floor (float-time)))
         (end (floor (float-time)))
         (visual-url (cdr (assoc "url" now)))
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

;; As always, this processor keeps breaking; MDR can't seem to
;; decide to place new tracks on the top of the list or the bottom.
;; If the former, it works; if the latter, new track info never
;; transistions.

(defun radio-f--mdr-radio-processor (data station)
  (let* ((name (plist-get station :name))
         (events (cdr (assoc "events" data)))
         (events (aref events 0))
         (clips (cdr (assoc "clips" events)))
         (now (aref clips 0))
         (image  (cdr (assoc "image" now)))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "start" now)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "end" now)))
           'integer))
         (visual-url (cdr (assoc "url" image)))
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(provide 'radio-f-mdr)

;;; radio-f-mdr.el ends here
