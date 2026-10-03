;;; radio-f-swr.el --- SWR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Thu 1 Oct 26
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
;; SWR plugin for Radio F: 33 Stations.
;;
;; Uses the ARD Audiothek API for JSON metadata.


;;; Code:

;; == STATION PLIST =====

;; https://dispatcher.rndfnk.com/swr/swraktuell/live/mp3/128/stream.mp3?aggregator=web

(defconst radio-f--swr-stations
  '((swr1-rock
     :name "SWR1 Rock Web" :carrier swr :id "sw331ch/raka14"
     :publisher "a8aa147108ee961a" :livestream "f6796de5b1812b75"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr1-90s
     :name "SWR1 Die 90er Web" :carrier swr :id "sw331ch/raka17"
     :publisher "a8aa147108ee961a" :livestream "0a193ff3c3e0b2a2"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr1-80s
     :name "SWR1 Die 80er Web" :carrier swr :id "sw331ch/raka16"
     :publisher "a8aa147108ee961a" :livestream "48e9de186a0a8431"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr1-deutsch
     :name "SWR1 Deutsch Web" :carrier swr :id "sw331ch/raka13"
     :publisher "a8aa147108ee961a" :livestream "432a59b6cda25e7d"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr1-country
     :name "SWR1 Country Web" :carrier swr :id "sw331ch/raka15"
     :publisher "a8aa147108ee961a" :livestream "8ff8fc249034df84"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr1-rheinland-pfalz
     :name "SWR1 Rheinland-Pfalz" :carrier swr :id "sw73hl2"
     :station "swr1" :l2-id "rp" :bitrate "128"
     :publisher "2d74b4350f0d4d53" :livestream "e55592f337f172a5"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr1-radio-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr1-baden-wurttemberg
     :name "SWR1 Baden-Württemberg" :carrier swr :id "sw73hl2"
     :station "swr1" :l2-id "bw" :bitrate "128"
     :publisher "2d74b4350f0d4d53" :livestream "c2656164ae0f6745"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr1-radio-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr-aktuell
     :name "SWR Aktuell" :carrier swr :id "sw73hl2"
     :station "swraktuell" :l2-id "live" :bitrate "128"
     :publisher "cb42f81b52c17e85" :livestream "5dd1df844b699812"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr-kultur
     :name "SWR Kultur" :carrier swr :id "sw73hl2"
     :station "swr2" :l2-id "live" :bitrate "256"
     :publisher "6f8455dea6e77bc0" :livestream "2842238ca9012473"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr3
     :name "SWR3" :carrier swr :id "sw73hl2"
     :station "swr3" :l2-id "live" :bitrate "128"
     :publisher "73c0dd2d4e1e1514" :livestream "fcd7ffb2396f6fbd"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr3-newpop
     :name "SWR3 New Pop Web" :carrier swr :id "sw331ch/raka08"
     :publisher "a8aa147108ee961a" :livestream "b9589d6b7897037f"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr3-party
     :name "SWR3 Party Web" :carrier swr :id "sw331ch/raka06"
     :publisher "a8aa147108ee961a" :livestream "e7ecf47339845b38"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr3-2000
     :name "SWR3 2000er Web" :carrier swr :id "sw331ch/raka09"
     :publisher "a8aa147108ee961a" :livestream "fba87c80d17d35ec"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr3-rock
     :name "SWR3 Rock Web" :carrier swr :id "sw331ch/raka05"
     :publisher "a8aa147108ee961a" :livestream "20fdd64fc3ba008d"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr3-lyrix
     :name "SWR3 Lyrix Web" :carrier swr :id "sw331ch/raka03"
     :publisher "a8aa147108ee961a" :livestream "ec2f73dd9e2c8174"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (dasding-chillout
     :name "DASDING Chillout Web" :carrier swr :id "sw331ch/raka10"
     :publisher "a8aa147108ee961a" :livestream "843b7b8a379c05c8"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (dasding-rap
     :name "DASDING Rap Web" :carrier swr :id "sw331ch/raka11"
     :publisher "a8aa147108ee961a" :livestream "c6cb9a619e76335b"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (dasding-zukunftsmusik
     :name "DASDING Zukunftsmusik Web" :carrier swr :id "sw331ch/raka12"
     :publisher "a8aa147108ee961a" :livestream "01dab85d644868ee"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (dasding-weekend
     :name "DASDING Weekend WarmUp Web" :carrier swr :id "sw331ch/raka04"
     :publisher "a8aa147108ee961a" :livestream "620d37a46a50361e"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr4-sonntagskonzert
     :name "SWR4 Sonntagskonzert Web" :carrier swr :id "sw331ch/raka20"
     :publisher "ea5af59aa104a089" :livestream "37c4e4dc6ae55240"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr4-70s
     :name "SWR4 70er im Mix Web" :carrier swr :id "sw331ch/raka19"
     :publisher "ea5af59aa104a089" :livestream "54ad56eb82f3eae5"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr4-pure-70s
     :name "70er Pur im SWR4 Web" :carrier swr :id "sw331ch/raka18"
     :publisher "ea5af59aa104a089" :livestream "165db7002b19dc76"
     :api radio-f--ard-web-api-url
     :processor radio-f--ard-web-processor
     :l1-stream radio-f--swr-web-stream-level-one
     :l2-stream radio-f--swr-web-stream-level-one)
    (swr4-stuttgart
     :name "SWR4 Stuttgart" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "bw" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "a9356cc0a8315ee0"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-trier
     :name "SWR4 Trier" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "tr" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "b5c6c6c61a73ddd5"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-tubingen
     :name "SWR4 Tübingen" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "tu" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "8b51e3f83fa7c00a"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-ludwigshafen
     :name "SWR4 Ludwigshafen" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "lu" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "cbb0808a49c4428c"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-friedrichshafen
     :name "SWR4 Friedrichsafen" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "fn" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "a0b0b5c4575384d8"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-ulm
     :name "SWR4 Ulm" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "ul" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "38ae7cae62de9782"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-karlsruhe
     :name "SWR4 Karlsruhe" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "ka" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "a754229c1632f361"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-heilbronn
     :name "SWR4 Heilbronn" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "hn" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "b445a15a0b87504c"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-kaiserslautern
     :name "SWR4 Kaiserslautern" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "kl" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "b00b36d51bcf8348"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-koblenz
     :name "SWR4 Koblenz" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "ko" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "65920d2ae364afa6"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-freiburg
     :name "SWR4 Freiburg" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "fr" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "b2a489822248d108"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-mannheim
     :name "SWR4 Mannheim" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "ma" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "05ef8204bc5555eb"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two)
    (swr4-mainz
     :name "SWR4 Mainz" :carrier swr :id "sw73hl2"
     :station "swr4" :l2-id "rp" :bitrate "128"
     :publisher "ea5af59aa104a089" :livestream "94568a21e73a5857"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ard-radio-processor
     :l1-stream radio-f--swr4-radio-stream-level-one
     :l2-stream radio-f--dispatcher-stream-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all SWR stations.  Used for
development purposes.")

(defconst radio-f--ard-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.2"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--ard-web-api-url
  "https://api.ardaudiothek.de/graphql?query=query%20MediaCollectionPermanentLivestreamsQuery(%24id%3AString!)%7BpermanentLivestream(id%3A%24id)%7BmediaCollection(v%3AV6A)%7D%7D&variables=%7B%22id%22%3A%22urn%3Aard%3Apermanent-livestream%3A<<livestream>>%22%7D"
  "Template to retrieve metadata for WDR web streams")

(defconst radio-f--swr-radio-api-url
 "https://www.swr.de/~webradio/<<station>>/<<l2-id>>/<<station>><<l2-id>>-playerbar-100~playerbarContainer.json"
 "SWR Template for web/radio streams")

(defconst radio-f-swr-aktuell-api-url
  "https://www.swr.de/~webradio/<<station>>/playerbar/<<station>>-playerbar-100~playerbarContainer.json"
  "SWR Template for web/radio streams")

(defconst radio-f--swr-url
  "https://www1.swr.de/radio/<<swr-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--ard-radio-level-one ;; AAC, 192kbps
  "https://swr-radio.ard-mcdn.de/swr/radio/<<id>>/hls/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--swr-web-stream-level-one ;; AAC, 96kbps
  "https://liveradio.swr.de/<<id>>/play.aac"
  "Template used to return a Level One web audio stream for playback.")

(defconst radio-f--swr-radio-stream-level-one ;; AAC, 192kbps
  "https://liveradio.swr.de/<<id>>/<<station>>/play.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--swr4-radio-stream-level-one ;; AAC, 192kbps
  "https://liveradio.swr.de/<<id>>/<<station>><<l2-id>>/play.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--dispatcher-stream-level-two ;; MP3
  "https://dispatcher.rndfnk.com/swr/<<station>>/<<l2-id>>/mp3/<<bitrate>>/stream.mp3"
  "Template used to return a Level Two audio stream for playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-swr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--swr-api-url
          (symbol-value api))))

(defun radio-f--set-swr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--swr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-swr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--swr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--swr-streams
  `((One     . radio-f--set-swr-stream-level-one)
    (Two     . radio-f--set-swr-stream-level-two)
    (default . radio-f--set-swr-stream-level-one))
  "Audio stream templates provided by Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--swr1-radio-processor (data station)
  "Process SWR Web DATA for STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "playlist" data)))
         (playlist (cdr (assoc "data" root)))
         (now (aref playlist 0))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (length  (cdr (assoc "duration" now)))
         (start (cdr (assoc "starttime" now)))
         (end (+ length start))
         (visual-url (cdr (assoc "cover" now)))
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

(defun radio-f--ard-radio-processor (data station)
  "Process SWR JSON DATA provided by ARD Audiothek for STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "events" data)))
         (now (aref root 0))
         (image (cdr (assoc "image" now)))
         (credits (cdr (assoc "title" now)))
         (artist (cdr (assoc "short" credits)))
         (title (cdr (assoc "subTitle" credits)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startDate" now)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "endDate" now)))
           'integer))
         (visual-url (cdr (assoc "contentUrl" image)))
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

(defun radio-f--ard-web-processor (data station)
  "Process JSON DATA provided by ARD Audiothek for Web STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "data" data)))
         (stream (cdr (assoc "permanentLivestream" root)))
         (media (cdr (assoc "mediaCollection" stream)))
         (meta (cdr (assoc "meta" media)))
         (images (cdr (assoc "images" meta)))
         (now (aref images 1))
         (title (cdr (assoc "title" meta)))
         (artist (plist-get station :name))
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

;; As always, this processor keeps breaking; SWR can't seem to
;; decide to place new tracks on the top of the list or the bottom.
;; If the former, it works; if the latter, new track info never
;; transistions.

(defun radio-f--swr1-show-processor (data station)
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "show" data)))
         (show (cdr (assoc "data" root)))
         (image (cdr (assoc "cover" show)))
         (artist (plist-get station :name))
         (title (cdr (assoc "title" show)))
         (start (cdr (assoc "starttime" show)))
         (end (cdr (assoc "endtime" show)))
         (visual-url (cdr (assoc "1x1" image)))
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

(provide 'radio-f-swr)
