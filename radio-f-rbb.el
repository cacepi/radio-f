;;; radio-f-rbb.el --- RBB plugin for Radio F -*- lexical-binding: t; -*-

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
;; Rundfunk Berlin-Brandenburg plugin for Radio F: 13 Stations.
;;
;; Uses the ARD Audiothek API for JSON metadata.


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--rbb-stations
  '((antenne-brandenburg
     :name "Antenne Brandenburg" :carrier rbb :id "2016998"
     :station "antbrb" :l2-carrier "antennebrandenburg"
     :l2-id "live" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "be8ca9fe99dc2115"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (antenne-frankfurt
     :name "Antenne Brandenburg Frankfurt" :carrier rbb :id "2017000"
     :station "antbrb-frankfurt" :l2-carrier "antennebrandenburg"
     :l2-id "frankfurt" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "515286f56605f097"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (antenne-perleberg
     :name "Antenne Brandenburg Perleberg" :carrier rbb :id "2017001"
     :station "antbrb-perleberg" :l2-carrier "antennebrandenburg"
     :l2-id "perleberg" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "3034b06553bfcedf"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (antenne-prenzlau
     :name "Antenne Brandenburg Prenzlau" :carrier rbb :id "2017002"
     :station "antbrb-prenzlau" :l2-carrier "antennebrandenburg"
     :l2-id "prenzlau" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "57dd43ef3160b03c"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (antenne-cottbus
     :name "Antenne Brandenburg Cottbus" :carrier rbb :id "2016999"
     :station "antbrb-cottbus" :l2-carrier "antennebrandenburg"
     :l2-id "cottbus" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "328f0b31e0ff512c"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-888
     :name "RBB 88.8" :carrier rbb :id "2017003"
     :station "rbb888" :l2-carrier "rbb888"
     :l2-id "live" :bitrate "mid"
     :publisher "599a095fa84a416e" :livestream "b9686d01b5ebc136"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-radioeins
     :name "RBB Radio Eins" :carrier rbb :id "2016930"
     :station "radioeins" :l2-carrier "radioeins"
     :l2-id "live" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "b10db8e5de2aab87"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-radioeins-frankfurt
     :name "RBB Radioeins Frankfurt" :carrier rbb :id "2016996"
     :station "radioeins-frankfurt" :l2-carrier "radioeins"
     :l2-id "frankfurt" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "02d1c474fb9aa37a"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-radioeins-cottbus
     :name "RBB Radioeins Cottbus" :carrier rbb :id "2016995"
     :station "radioeins-cottbus" :l2-carrier "radioeins"
     :l2-id "cottbus" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "99b9c3e67c4f49ac"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-inforadio
     :name "RBB Inforadio" :carrier rbb :id "2017004"
     :station "inforadio" :l2-id "live" :bitrate "mid"
     :publisher "d7b84d265c36f604" :livestream "cb6df5483c778969"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://inforadio-sorb.akamaized.net/hls/live/2017005/rbb_inforadio-sorb/master.m3u8
    ;; https://dispatcher.rndfnk.com/rbb/inforadio/sorb/mp3/mid
    (rbb-inforadio-sorbisch
     :name "RBB Inforadio Sorbisch" :carrier rbb :id "2017005"
     :station "inforadio-sorb" :l2-id "sorb" :bitrate "mid"
     :publisher "d7b84d265c36f604" :livestream "36c444681c987527"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-radio3
     :name "RBB Radio 3" :carrier rbb :id "2017006"
     :station "rbbkultur" :l2-id "live" :bitrate "mid"
     :publisher "9548accdf5dcc097" :livestream "59d7ea9aff468b01"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    (rbb-fritz
     :name "RBB Fritz" :carrier rbb :id "2016997"
     :station "fritz" :l2-id "live" :bitrate "mid"
     :publisher "c03f427b1367429c" :livestream "073b7c4a843982f4"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--rbb-ard-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.2"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--rbb-radio-api-url
  "https://www.rbb-online.de/public/radioplaylists/<<id>>.json"
  "Template to retrieve metadata for RBB.")

(defconst radio-f--rbb-www-url
  "https://www1.rbb.de/radio/<<rbb-id>>/index.html"
  "URL template for RBB station home pages.")

;; == STREAM URLS =======

(defconst radio-f--rbb-radio-stream-level-one ;; AAC, 192kbps
  "https://<<station>>.akamaized.net/hls/live/<<id>>/rbb_<<station>>/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--rbb-radio-stream-level-two ;; MP3, 128kbps
  "https://dispatcher.rndfnk.com/rbb/<<l2-carrier>>/<<l2-id>>/mp3/<<bitrate>>"
;;  "http://streaming01.rbb-online.de/<<id>>_2.m3u"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--rbb-icecast-stream-level-two ;; MP3, 128
  "https://icecast.rbb.de/rbb/<<l2-carrier>>/<<l2-id>>/mp3/<<bitrate>>/stream.mp3"
  "Template used to return a Level Two audio stream for playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-rbb-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--rbb-api-url
          (symbol-value api))))

(defun radio-f--set-rbb-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--rbb-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-rbb-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--rbb-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--rbb-streams
  `((One     . radio-f--set-rbb-stream-level-one)
    (Two     . radio-f--set-rbb-stream-level-two)
    (default . radio-f--set-rbb-stream-level-one))
  "Audio stream templates provided by Norddeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--rbb-ard-radio-processor (data station)
  "Process RBB JSON DATA provided by ARD Audiothek for STATION."
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

(defun radio-f--rbb-radio-processor (data station)
  "Process RBB JSON DATA provided by ARD Audiothek for STATION."
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
                     "https://www.rbb-online.de/public/radioplaylists/coverimages/%s_600x600.jpg"
                     (cdr (assoc "song_now_cover" now)))))))

(provide 'radio-f-rbb)
