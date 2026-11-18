;;; radio-f-lrt.el --- LRT plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Wed 18 Nov 26
;; Keywords: hypermedia, network, streaming, radio, Lithuania

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
;; LRT plugin for Radio F: 4 Stations. LRT has no regional stations.


;;; Code:
;;
;; == STATION PLIST =====

(defconst radio-f--lrt-stations
  '((llrt-radijas
     :name "LRT Radijas" :carrier lrt :id "radijas"
     :api radio-f--lrt-api-url :processor radio-f--lrt-processor)
    (lrt-klasika
     :name "LRT Klasika" :carrier lrt :id "klasika"
     :api radio-f--lrt-api-url :processor radio-f--lrt-processor)
    (lrt-opus
     :name "LRT Opus" :carrier lrt :id "opus"
     :api radio-f--lrt-api-url :processor radio-f--lrt-processor)
    (lrt-100
     :name "LRT 100" :carrier lrt :id "100"
     :api radio-f--lrt-api-url :processor radio-f--lrt-processor))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--lrt-api-url
  "https://www.lrt.lt/rest-api/live/lrt-<<id>>"
  "Template to retrieve metadata for LRT Radio.")

;; == WEB URLS ==========

(defconst radio-f--lrt-www-url
  "https://www.lrt.lt/mediateka/tiesiogiai/lrt-<<id>>"
  "URL Template for LRT station home pages.")

;; == STREAM URLS =======

(defconst radio-f--lrt-level-one
  ";; https://stream-live.lrt.lt/radio_<<id>>/lrt_<<id>>.m3u8"
  "Template used to return a Level One audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--lrt-streams
  `((One     . ,radio-f--lrt-level-one)
    (_       . ,radio-f--lrt-level-one))
  "Audio stream templates provided by LRT.")


;; == PROCESSORS ================================

(defun radio-f--lrt-processor (data station)
  "Process LRT JSON DATA for STATION."
  (let* ((name (plist-get station :name))
         (now (cdr (assoc "currentProgram" data)))
         (artist (cdr (assoc "channelTitle" now)))
         (title (cdr (assoc "title" now)))
         (start (cdr (assoc "timeStart" now)))
         (end   (cdr (assoc "timeEnd" now)))
         (visual-url (cdr (assoc "imageUrl" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title start end))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))


(provide 'radio-f-lrt)
