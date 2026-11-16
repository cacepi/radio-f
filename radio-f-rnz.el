;;; radio-f-rnz.el --- RNZ plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Fri 13 Nov 26
;; Keywords: hypermedia, network, streaming, radio, New Zealand

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
;; RNZ (New Zealand) plugin for Radio F: 15 Stations.
;;

;; https://radionz.streamguys1.com/national/national/playlist.m3u8
;; https://rnz.streamguys1.com/concert/concert/playlist.m3u8
;; https://rnz.streamguys1.com/pacific/pacific/playlist.m3u8


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--rnz-stations
  '(
    (rnz-national
     :name "RNZ National" :carrier rnz :id "national"
     :www "national" :api radio-f--rnz-api-url :l1 "radionz"
     :l1-stream radio-f--rnz-stream-level-one
     :l2-stream radio-f--rnz-stream-level-two
     :processor radio-f--rnz-processor
     :visual "assets/rnz/rnz-logo.png")
    (rnz-concert
     :name "RNZ Concert" :carrier rnz :id "concert"
     :www "concert" :api radio-f--rnz-api-url :l1 "rnz"
     :l1-stream radio-f--rnz-stream-level-one
     :l2-stream radio-f--rnz-stream-level-two
     :processor radio-f--rnz-processor
     :visual "assets/rnz/rnz-logo.png")
    (rnz-pacific
     :name "RNZ National" :carrier rnz :id "pacific"
     :www "international" :api radio-f--rnz-api-url :l1 "rnz"
     :l1-stream radio-f--rnz-stream-level-one
     :l2-stream radio-f--rnz-stream-level-two
     :processor radio-f--rnz-processor
     :visual "assets/rnz/rnz-logo.png")
)
    "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--rnz-api-url
  "https://www.rnzplaysound.it/palinsesto/onAir.json"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--rnz-www-url
  "https://www.rnz.co.nz/<<www>>"
  "URL Template for RNZ Station Web presence.")


;; == STREAM URLS =======

(defconst radio-f--rnz-stream-level-one ;; AAC, 192kbps
  "https://<<l1>>.streamguys1.com/<<id>>/<<id>>/playlist.m3u8"
  "Template used to return a RNZ Level One audio stream for playback.")

(defconst radio-f--rnz-stream-level-two ;; MP3, 128kbps
  "https://icestreaming.rnz.it/<<id>>.mp3"
  "Template used to return a RNZ Level Two audio stream for playback.")

(defconst radio-f--rnz-sudtirol-stream-level-one ;; MP3, 128kbps
  "https://radiobzlive.rnz.it/RNZ_Suedtirol"
  "Template used to return a Rnz Radio Südtirol Level One stream
for playback.")

(defconst radio-f--rnz-regional-stream-level-one ;; MP3, 128kbps
  "https://<<hash>>.msvdn.net/<<id>>/hls/playlist_mo.m3u8"
  "Template used to return a regional Rnz Level One stream for playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-rnz-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--rnz-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-rnz-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--rnz-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--rnz-streams
  `((One     . radio-f--set-rnz-stream-level-one)
    (Two     . radio-f--set-rnz-stream-level-two)
    (default . radio-f--set-rnz-stream-level-one))
  "Audio stream templates provided by Norddeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--rnz-processor (data station)
  "Process RNZ JSON DATA provided by ARD Audiothek for STATION."
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


(provide 'radio-f-rnz)
