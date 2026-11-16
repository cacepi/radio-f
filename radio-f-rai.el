;;; radio-f-rai.el --- Rai plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Wed 11 Nov 26
;; Keywords: hypermedia, network, streaming, radio, Italy

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
;; Rai (Italy) plugin for Radio F: 15 Stations.
;;
;; I think Rai's classical stations either still use vinyl records or they've
;; converted their vinyl collection to digital, as I can hear from time
;; to time telltale 33 1/3 RPM scratches on some of the pieces they play.
;;
;; I oddly find that comforting.
;;
;; https://www.raiplaysound.it/palinsesto/onAir.json
;; https://www.raiplaysound.it/dirette.json
;; https://www.raiplaysound.it/generi/Audiolibri-bb15c098-6692-48f6-b7be-94afb06399ff.json

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--rai-stations
  '((rai-1
     :name "Rai Radio 1" :carrier rai :id "1"
     :www "radio1" :api radio-f--rai-api-url
     :l1 "radiounoest" :key "2032586"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-1-sport
     :name "Rai Radio 1 Sport" :carrier rai :id "13"
     :www "radio1sport" :api radio-f--rai-api-url
     :l1 "radiounosportest" :key "2032591"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-2
     :name "Rai Radio 2" :carrier rai :id "2"
     :www "radio2" :api radio-f--rai-api-url
     :l1 "radiodue" :key "2032592"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-noname
     :name "No Name Radio" :carrier rai :id "15"
     :www "nonameradio" :api radio-f--rai-api-url
     :l1 "radiodueindie" :key "20312593"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-3
     :name "Rai Radio 3" :carrier rai :id "3"
     :www "radio3" :api radio-f--rai-api-url
     :l1 "radiotre" :key "2032594"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-3-classica
     :name "Rai Radio 3 Classica" :carrier rai :id "5"
     :www "radio3classica" :api radio-f--rai-api-url
     :l1 "radiotreclassica" :key "2032595"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-tutta-italiana
     :name "Rai Tutta Italiana" :carrier rai :id "4"
     :www "radiotuttaitaliana" :api radio-f--rai-api-url
     :l1 "radiotuttaitaliana" :key "2032596"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-gr-parliament
     :name "Rai Gr Parlamento" :carrier rai :id "7"
     :www "grparlamento" :api radio-f--rai-api-url
     :l1 "radioparlamento" :key "2032597"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-techete
     :name "Rai Radio Techetè" :carrier rai :id "9"
     :www "radiotechete" :api radio-f--rai-api-url
     :l1 "radiotechete" :key "2032598"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-napoli
     :name "Rai Radio Live Napoli" :carrier rai :id "10"
     :www "radiolivenapoli" :api radio-f--rai-api-url
     :l1 "radiolive" :key "2032599"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-kids
     :name "Rai Radio Kids" :carrier rai :id "11"
     :www "radiokids" :api radio-f--rai-api-url
     :l1 "radiokids" :key "2032600"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-iso
     :name "Rai Isoradio" :carrier rai :id "6"
     :www "isoradio" :api radio-f--rai-api-url
     :l1 "isoradioest" :key "2032602"
     :l1-stream radio-f--rai-stream-level-one
     :l2-stream radio-f--rai-stream-level-two
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-sudtirol
     :name "Rai Radio Südtirol" :carrier rai :id "6"
     :www "radiosuedtirol" :api radio-f--rai-api-url
     :l1-stream radio-f--rai-sudtirol-stream-level-one
     :l2-stream nil
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-trst-a
     :name "Rai Radio Trst A" :carrier rai :id "friuliaudio1"
     :www "radiotrsta" :api radio-f--rai-api-url
     :hash "8e7439fdb1694c8da3a0fd63e4dda518"
     :l1-stream radio-f--rai-regional-stream-level-one
     :l2-stream nil
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png")
    (rai-san-morino
     :name "Rai San Morino" :carrier rai :id "radiosanmarino1"
     :www "radio1" :api radio-f--rai-api-url
     :hash "8e7439fdb1694c8da3a0fd63e4dda518"
     :l1-stream radio-f--rai-regional-stream-level-one
     :l2-stream nil
     :processor radio-f--rai-processor
     :visual "assets/rai/rai-logo.png"))
    "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--rai-api-url
  "https://www.raiplaysound.it/palinsesto/onAir.json"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--rai-www-url
  "https://www.raiplaysound.it/<<www>>"
  "URL Template for RAI Station Web presence.")


;; == STREAM URLS =======

(defconst radio-f--rai-stream-level-one ;; AAC, 192kbps
  "https://<<l1>>-live.akamaized.net/hls/live/<<key>>/<<l1>>/<<l1>>/playlist.m3u8"
  "Template used to return a RAI Level One audio stream for playback.")

(defconst radio-f--rai-stream-level-two ;; MP3, 128kbps
  "https://icestreaming.rai.it/<<id>>.mp3"
  "Template used to return a RAI Level Two audio stream for playback.")

(defconst radio-f--rai-sudtirol-stream-level-one ;; MP3, 128kbps
  "https://radiobzlive.rai.it/RAI_Suedtirol"
  "Template used to return a Rai Radio Südtirol Level One stream
for playback.")

(defconst radio-f--rai-regional-stream-level-one ;; MP3, 128kbps
  "https://<<hash>>.msvdn.net/<<id>>/hls/playlist_mo.m3u8"
  "Template used to return a regional Rai Level One stream for playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-rai-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--rai-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-rai-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--rai-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--rai-streams
  `((One     . radio-f--set-rai-stream-level-one)
    (Two     . radio-f--set-rai-stream-level-two)
    (default . radio-f--set-rai-stream-level-one))
  "Audio stream templates provided by Norddeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--rai-processor (data station)
  "Process RAI JSON DATA provided by ARD Audiothek for STATION."
  (let* ((name (plist-get station :name))
         ;; (data (cdr (assoc "on_air" data)))
         ;; (now (aref data 0))
         ;; (artist (plist-get station :name))
         ;; (title (cdr (assoc "subTitle" credits)))
         ;; (start
         ;;  (time-convert
         ;;   (date-to-time
         ;;    (cdr (assoc "startDate" now)))
         ;;   'integer))
         ;; (end
         ;;  (time-convert
         ;;   (date-to-time
         ;;    (cdr (assoc "endDate" now)))
         ;;   'integer))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" name visual-id))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,name)
      ;; (title      . ,title)
      ;; (start      . ,start)
      ;; (end        . ,end)
      (visual-id . ,visual-id))))


(provide 'radio-f-rai)
