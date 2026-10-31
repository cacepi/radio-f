;;; radio-f-sr.el --- SR plugin for Radio F -*- lexical-binding: t; -*-

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
;; Saarländischer Rundfunk plugin for Radio F: 5 Stations.
;;
;; Uses the ARD Audiothek API for JSON metadata.


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--sr-stations
  '((sr1
     :name "SR1" :carrier sr :id "sr1" :bitrate "128"
     :publisher "a356f04cfb71fa39" :livestream "cdfb629e6d74d6b9"
     :api radio-f--sr-ard-radio-api-url
     :processor radio-f--sr-ard-radio-processor
     :l1-stream radio-f--sr-radio-stream-level-one
     :l2-stream radio-f--sr-radio-stream-level-one)
    (sr2-kultur
     :name "SR Kultur" :carrier sr :id "sr2" :bitrate "256"
     :publisher "6447d270014fa18c" :livestream "52bf2bc463ac2d9e"
     :api radio-f--sr-ard-radio-api-url
     :processor radio-f--sr-ard-radio-processor
     :l1-stream radio-f--sr-radio-stream-level-one
     :l2-stream radio-f--sr-radio-stream-level-one)
    (sr3
     :name "SR3" :carrier sr :id "sr3" :bitrate "128"
     :publisher "26b7339ba8a5971f" :livestream "5e122c7ec0fff216"
     :api radio-f--sr-ard-radio-api-url
     :processor radio-f--sr-ard-radio-processor
     :l1-stream radio-f--sr-radio-stream-level-one
     :l2-stream radio-f--sr-radio-stream-level-one)
    (sr-antenne-saar
     :name "SR AntenneSaar" :carrier sr :id "antennesaar" :bitrate "128"
     :publisher "e1f0ae128d06d731" :livestream "04614d75c1e32de8"
     :api radio-f--sr-ard-radio-api-url
     :processor radio-f--sr-ard-radio-processor
     :l1-stream radio-f--sr-radio-stream-level-one
     :l2-stream radio-f--sr-radio-stream-level-one)
    (sr-dasding
     :name "DASDING vom SR" :carrier sr :id "ud" :bitrate "128" :l1 "dasding"
     :publisher "8b44e3ee32398edd" :livestream "639c5e8d1e3fdbca"
     :api radio-f--sr-ard-radio-api-url
     :processor radio-f--sr-ard-radio-processor
     :l1-stream radio-f--sr-dasding-radio-stream-level-one
     :l2-stream radio-f--sr-radio-stream-level-one))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all SR stations.  Used for
development purposes.")

(defconst radio-f--sr-ard-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.2"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--sr-url
  "https://www1.sr.de/radio/<<sr-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--sr-radio-stream-level-one ;; MP3, 128kbps
  "http://streaming01.sr-online.de/<<id>>_2.m3u"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--sr-radio-stream-level-two ;; MP3, 56kbps
    "http://streaming01.sr-online.de/<<id>>_1.m3u"
    "Template used to return a Level One audio stream for playback.")

(defconst radio-f--sr-dasding-radio-stream-level-one
  "https://sr-radio.ard-mcdn.de/sr/radio/<<l1>>/hls/master.m3u8"
    "Template used to return a Level One audio stream for playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-sr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--sr-api-url
          (symbol-value api))))

(defun radio-f--set-sr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--sr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-sr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--sr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--sr-streams
  `((One     . radio-f--set-sr-stream-level-one)
    (Two     . radio-f--set-sr-stream-level-two)
    (default . radio-f--set-sr-stream-level-one))
  "Audio stream templates provided by Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--sr-ard-radio-processor (data station)
  "Process SR JSON DATA provided by ARD Audiothek for STATION."
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

(provide 'radio-f-sr)
