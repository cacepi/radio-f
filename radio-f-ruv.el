;;; radio-f-ruv.el --- RUV plugin for Radio F -*- lexical-binding: t; -*-

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
;; RUV (Iceland) plugin for Radio F: 3 Stations.
;;

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--ruv-stations
  '((ruv-ras1
     :name "RUV RÁS 1" :carrier ruv :id "ras1"
     :api nil :l1-stream radio-f--ruv-ras1-stream-level-one
     :processor radio-f--ruv-processor :visual "assets/ruv/ras1.png")
    (ruv-ras2
     :name "RUV RÁS 2" :carrier ruv :id "ras2"
     :api nil :l1-stream radio-f--ruv-ras2-stream-level-one
     :processor radio-f--ruv-processor :visual "assets/ruv/ras2.jpg")
    (ruv-rondo
     :name "RUV RÁS RONDÓ" :carrier ruv :id "rondo"
     :api nil :l1-stream radio-f--ruv-ras-rondo-stream-level-one
     :processor radio-f--ruv-processor :visual "assets/ruv/rondo.png"))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ruv-api-url
  "https://api.ruv.is/api/analytics/live/<<id>>"
  "Template to retrieve metadata for RUV stations.")

(defconst radio-f--ruv-www-url
  "https://www.ruv.is/<<id>>"
  "URL Template for RUV station home pages.")


;; == STREAM URL ========

(defconst radio-f--ruv-ras1-stream-level-one
  "https://ruv-radio-live.akamaized.net/streymi/ras1/ras1.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--ruv-ras2-stream-level-one
  "https://ruv-radio-live.akamaized.net/streymi/ras2/ras2.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--ruv-ras-rondo-stream-level-one
  "https://ruv-radio-live.akamaized.net/streymi/rondo/rondo/rondo.m3u8"
  "Template used to return a Level One audio stream for playback.")


;; HELPERS

(defun radio-f--set-ruv-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--ruv-stream-level-one
          (symbol-value l1-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--ruv-streams
  `((One     . radio-f--set-ruv-stream-level-one)
    (_       . radio-f--set-ruv-stream-level-one))
  "Audio stream templates provided by RUV.")


;; == PROCESSORS ================================

;; RUV has no usable JSON feed, but Radio F expects one. Instead,
;; return the statistics page.  It has nothing useful, but
;; refactoring the whole program for three stations wouldn't be
;; much fun.
;;
;; Oh, well...

(defun radio-f--ruv-processor (data station)
  "Process RUV DATA for STATION."
  (let* ((name (plist-get station :name))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" name visual-id))))
    `((name       . ,name)
      (artist     . ,name)
      (visual-id  . ,visual-id)
      (item-id    . ,item-id))))

(provide 'radio-f-ruv)
