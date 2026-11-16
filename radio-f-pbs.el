;;; radio-f-pbs.el --- PBS plugin for Radio F -*- lexical-binding: t; -*-

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
;; PBS (Malta) plugin for Radio F: 3 Stations.
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

;; API
;; https://www.pbs.is/gql/?operationName=getOnAir&variables=%7B%22channel%22%3A%22ras1%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%22089156c3ee547a6a6b6703cfa646d141a4782426c29589e85cb5780ca49911f8%22%7D%7D
;; https://www.pbs.is/gql/?operationName=getOnAir&variables={"channel":"ras1"}&extensions={"persistedQuery":{"version":1,"sha256Hash":"089156c3ee547a6a6b6703cfa646d141a4782426c29589e85cb5780ca49911f8"}}
;; HLS
;; https://pbs-radio-live.akamaized.net/streymi/ras1/ras1.m3u8

;; HLS
;; https://s46.myradiostream.com/6076/listen.mp3
;; API
;; https://s46.myradiostream.com/6076/stats?sid=1&json=1

;; STREAM
;; https://s38.myradiostream.com/6982/listen.mp3
;; https://s38.myradiostream.com/6982/stats?sid=1&json=1

;; https://s11.myradiostream.com/4954/listen.mp3
;; https://s11.myradiostream.com/4954/stats?sid=1&json=1

;; == STATION PLIST =====

(defconst radio-f--pbs-stations
  '((pbs-magic
     :name "PBS Magic" :carrier pbs :id "6076" :server "s46"
     :api radio-f--pbs-api-url :l1-stream radio-f--pbs-ras1-stream-level-one
     :processor radio-f--pbs-processor :visual "assets/pbs/pbs.png")
    (pbs-radju
     :name "PBS Radju Malta" :carrier pbs :id "6982" :server "s38"
     :api nil :l1-stream radio-f--pbs-ras2-stream-level-one
     :processor radio-f--pbs-processor :visual "assets/pbs/pbs.jpg")
    (pbs-radju-2
     :name "PBS Radju Malta 2" :carrier pbs :id "4954" :server "s11"
     :api nil :l1-stream radio-f--pbs-ras-rondo-stream-level-one
     :processor radio-f--pbs-processor :visual "assets/pbs/pbs.png"))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--pbs-api-url
  "https://api.pbs.is/api/analytics/live/<<id>>"
  "Template to retrieve metadata for PBS stations.")

(defconst radio-f--pbs-magic-api-url
  "https://s46.myradiostream.com:6076/stats?sid=1&json=1"
  "Template to retrieve metadata for PBS Magic.")

(defconst radio-f--pbs-url
  "https://eestiraadio.pbs.ee/<<id>>"
  "Template to retrieve a URL for an PBS station.")


;; == STREAM URL ========

(defconst radio-f--pbs-ras1-stream-level-one
  "https://pbs-radio-live.akamaized.net/streymi/ras1/ras1.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--pbs-ras2-stream-level-one
  "https://pbs-radio-live.akamaized.net/streymi/ras2/ras2.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--pbs-ras-rondo-stream-level-one
  "https://pbs-radio-live.akamaized.net/streymi/rondo/rondo/rondo.m3u8"
  "Template used to return a Level One audio stream for playback.")


;; HELPERS

(defun radio-f--set-pbs-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--pbs-stream-level-one
          (symbol-value l1-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--pbs-streams
  `((One     . radio-f--set-pbs-stream-level-one)
    (_       . radio-f--set-pbs-stream-level-one))
  "Audio stream templates provided by PBS.")


;; == PROCESSORS ================================

;; PBS has no usable JSON feed.

(defun radio-f--pbs-processor (data station)
  "Process PBS JSON DATA for STATION."
  (let* ((name (plist-get station :name))
         (artist (plist-get station :name))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist visual-id))))
    `((name       . ,name)
      (artist     . ,artist)
      (visual-id  . ,visual-id)
      (item-id    . ,item-id))))

(provide 'radio-f-pbs)
