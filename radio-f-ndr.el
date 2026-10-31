;;; radio-f-ndr.el --- NDR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sat 3 Oct 26
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
;; Norddeutscher Rundfunk plugin for Radio F: 5 Stations.
;;
;; Uses the ARD Audiothek API for JSON metadata.


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--ndr-stations
  '((ndr-joy
     :name "NDR Joy" :carrier ndr :id "njoy"
     :station "njoy" :l2-id "live" :bitrate "128"
     :api radio-f--ndr-radio-api-url
     :processor radio-f--ndr-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-niedersachsen
     :name "NDR 1 Niedersachsen" :carrier ndr :id "ndsh"
     :station "ndr1" :l2-id "niedersachsen/hannover" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "35d58c92414a0bdf"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-lueneburg
     :name "NDR 1 ND Lüneburg" :carrier ndr :id "ndslg"
     :station "ndr1" :l2-id "niedersachsen/lueneburg" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "cdfb629e6d74d6b9"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-braunschweig
     :name "NDR 1 ND Braunschweig" :carrier ndr :id "ndsbs"
     :station "ndr1" :l2-id "niedersachsen/braunschweig" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "309a63d8eb8db7c4"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-lueneburg
     :name "NDR 1 ND Lüneburg" :carrier ndr :id "ndslg"
     :station "ndr1" :l2-id "niedersachsen/lueneburg" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "cdfb629e6d74d6b9"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-oldenburg
     :name "NDR 1 ND Oldenburg" :carrier ndr :id "ndsol"
     :station "ndr1" :l2-id "niedersachsen/oldenburg" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "acffae8b251926bc"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-osnabrueck
     :name "NDR 1 ND Osnabrück" :carrier ndr :id "ndsos"
     :station "ndr1" :l2-id "niedersachsen/osnabrueck" :bitrate "128"
     :publisher "b46fc2df522ea8f4" :livestream "4d5f7532bafe061e"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-mv
     :name "NDR 1 MV Radio" :carrier ndr :id "ndr1mvsn"
     :station "ndr1" :l2-id "radiomv/schwerin" :bitrate "128"
     :publisher "3a4d86a6a6521f9e" :livestream "c1cd0fe5ce98f4c5"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-mv-neu
     :name "NDR 1 MV Neubrandenburg" :carrier ndr :id "ndr1mvneu"
     :station "ndr1radiomv" :l2-id "neubrandenburg" :bitrate "128"
     :publisher "3a4d86a6a6521f9e" :livestream "c8520f77efc57e7c"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-mv-schwerin
     :name "NDR 1 MV Schwerin" :carrier ndr :id "ndr1mvsn"
     :station "ndr1radiomv" :l2-id "schwerin" :bitrate "128"
     :publisher "3a4d86a6a6521f9e" :livestream "d1d237658975e8e0"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-mv-greifswald
     :name "NDR 1 MV Greifswald" :carrier ndr :id "ndr1mvhgw"
     :station "ndr1radiomv" :l2-id "greifswald" :bitrate "128"
     :publisher "3a4d86a6a6521f9e" :livestream "f6cbbe4ddcb7e8f0"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-mv-rostok
     :name "NDR 1 MV Neubrandenburg" :carrier ndr :id "ndr1mvhro"
     :station "ndr1radiomv" :l2-id "neubrandenburg" :bitrate "128"
     :publisher "3a4d86a6a6521f9e" :livestream "52918ccca3515d06"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn
     :name "NDR 1 Welle Nord" :carrier ndr :id "ndr1wnki"
     :station "ndr1wellenord" :l2-id "kiel" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "bd09114d50ce6b4a"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn-norderstedt
     :name "NDR 1 WN Norderstedt" :carrier ndr :id "ndr1wnno"
     :station "ndr1wellenord" :l2-id "norderstedt" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "e98adaf7509fbeb7"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn-heide
     :name "NDR 1 WN Heide" :carrier ndr :id "ndr1wnhei"
     :station "ndr1wellenord" :l2-id "heide" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "dd6cf17c0b068270"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn-luebeck
     :name "NDR 1 WN Lübeck" :carrier ndr :id "ndr1wnhl"
     :station "ndr1wellenord" :l2-id "luebeck" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "6a5a2154312ea332"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn-kiel
     :name "NDR 1 WN Kiel" :carrier ndr :id "ndr1wnki"
     :station "ndr1wellenord" :l2-id "kiel" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "e47906b4a27aa0d6"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr1-wn-flensburg
     :name "NDR 1 WN Flensburg" :carrier ndr :id "ndr1wnfl"
     :station "ndr1wellenord" :l2-id "flensburg" :bitrate "128"
     :publisher "78bd674d0fb8290d" :livestream "5457f371b860dfee"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-903
     :name "NDR 90.3" :carrier ndr :id "ndr903"
     :station "ndr903" :l2-id "hamburg" :bitrate "128"
     :publisher "bfac4571f58672b8" :livestream "ce6aa75693f78329"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr2
     :name "NDR 2" :carrier ndr :id "ndr2nds"
     :station "ndr2" :l2-id "niedersachsen" :bitrate "128"
     :publisher "f97415cfe886b5cb" :livestream "46e18472bad358fe"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr2-mecklenburg
     :name "NDR 2 Mecklenburg-Vorpommern" :carrier ndr :id "ndr3mv"
     :station "ndr2" :l2-id "mecklenburgvorpommern" :bitrate "128"
     :publisher "f97415cfe886b5cb" :livestream "c2385aaccb2e88bc"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr2-hamburg
     :name "NDR 2 Hamburg" :carrier ndr :id "ndr2hhh"
     :station "ndr2" :l2-id "hamburg" :bitrate "128"
     :publisher "f97415cfe886b5cb" :livestream "56d71679a77b2ca9"
     :api radio-f--ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr2-niedersachsen
     :name "NDR 2 Niedersachsen" :carrier ndr :id "ndr2nds"
     :station "ndr2" :l2-id "niedersachsen" :bitrate "128"
     :publisher "f97415cfe886b5cb" :livestream "4a43e59ecf66f121"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr2-schleswig
     :name "NDR 2 Schleswig-Holstein" :carrier ndr :id "ndr2sh"
     :station "ndr2" :l2-id "schleswigholstein" :bitrate "128"
     :publisher "f97415cfe886b5cb" :livestream "36789bfc00f26ddb"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-info
     :name "NDR Info" :carrier ndr :id "ndr1wnki"
     :station "ndrinfo" :l2-id "live" :bitrate "128"
     :publisher "a7c07cd7a995ed8c" :livestream "c98844993c223701"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-info-spezial
     :name "NDR Info Spezial" :carrier ndr :id "ndr1wnki"
     :station "ndrinfospezial" :l2-id "live" :bitrate "128"
     :publisher "a7c07cd7a995ed8c" :livestream "eab4bb45b27304de"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-schlager
     :name "NDR Schlager" :carrier ndr :id "ndrschlager"
     :station "ndrschlager" :l2-id "live" :bitrate "128"
     :api radio-f--ndr-radio-api-url
     :processor radio-f--ndr-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-kultur
     :name "NDR Kultur" :carrier ndr :id "ndr1wnki"
     :station "ndrkultur" :l2-id "live" :bitrate "256"
     :publisher "e5309d3c007fdb1f" :livestream "f342bfa63207cc0b"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two)
    (ndr-blue
     :name "NDR Blue" :carrier ndr :id "ndr1wnki"
     :station "ndrblue" :l2-id "live" :bitrate "128"
     :publisher "318e010801fac5d2" :livestream "a9272427b14514f5"
     :api radio-f--ndr-ard-radio-api-url
     :processor radio-f--ndr-ard-radio-processor
     :l1-stream radio-f--ndr-radio-stream-level-one
     :l2-stream radio-f--ndr-radio-stream-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all NDR stations.  Used for
development purposes.")

(defconst radio-f--ndr-ard-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.2"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--ndr-radio-api-url
  "https://www.ndr.de/public/radioplaylists/<<id>>.json"
  "Template to retrieve metadata for NDR Schlager.")

(defconst radio-f--ndr-url
  "https://www1.ndr.de/radio/<<ndr-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--ndr-radio-stream-level-one ;; MP3, 128kbps
  "https://ndr-radio.ard-mcdn.de/ndr/radio/<<id>>/hls/master.m3u8"
;;  "http://streaming01.ndr-online.de/<<id>>_2.m3u"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--ndr-icecast-stream-level-two ;; MP3, 128
  "https://icecast.ndr.de/ndr/<<station>>/<<l2-id>>/mp3/<<bitrate>>/stream.mp3"
  "Template used to return a Level Two audio stream for playback.")

(defconst radio-f--ndr-dasding-radio-stream-level-one
  "https://ndr-radio.ard-mcdn.de/ndr/radio/<<station>><<id>>/hls/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-ndr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--ndr-api-url
          (symbol-value api))))

(defun radio-f--set-ndr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--ndr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-ndr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--ndr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--ndr-streams
  `((One     . radio-f--set-ndr-stream-level-one)
    (Two     . radio-f--set-ndr-stream-level-two)
    (default . radio-f--set-ndr-stream-level-one))
  "Audio stream templates provided by Norddeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--ndr-ard-radio-processor (data station)
  "Process NDR JSON DATA provided by ARD Audiothek for STATION."
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

(defun radio-f--ndr-radio-processor (data station)
  "Process NDR JSON DATA provided by ARD Audiothek for STATION."
  (let* ((name (plist-get station :name))
         (now data)
         (item-id (cdr (assoc "song_now_cover" now)))
         (artist (cdr (assoc "song_now_interpret" now)))
         (title (cdr (assoc "song_now_title" now)))
         (start (floor (float-time)))
         (end (floor (float-time))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,(format
                     "https://www.ndr.de/public/radioplaylists/coverimages/%s_600x600.jpg"
                     (cdr (assoc "song_now_cover" now)))))))

(provide 'radio-f-ndr)
