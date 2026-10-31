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
     :name "Antenne Brandenburg" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "antennebrandenburg" :l2-id "live" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "be8ca9fe99dc2115"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
;; https://antbrb-frankfurt.akamaized.net/hls/live/2017000/rbb_antbrb-frankfurt/master.m3u8
;; https://dispatcher.rndfnk.com/rbb/antennebrandenburg/frankfurt/mp3/mid
(antenne-frankfurt
     :name "Antenne Brandenburg Frankfurt" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "antennebrandenburg" :l2-id "frankfurt" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "515286f56605f097"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
;; https://antbrb-perleberg.akamaized.net/hls/live/2017001/rbb_antbrb-perleberg/master.m3u8
;; https://dispatcher.rndfnk.com/rbb/antennebrandenburg/perleberg/mp3/mid
(antenne-perleberg
     :name "Antenne Brandenburg Perleberg" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "antennebrandenburg" :l2-id "perleberg" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "3034b06553bfcedf"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
;; https://antbrb-prenzlau.akamaized.net/hls/live/2017002/rbb_antbrb-prenzlau/master.m3u8
;; https://dispatcher.rndfnk.com/rbb/antennebrandenburg/prenzlau/mp3/mid
    (antenne-prenzlau
     :name "Antenne Brandenburg Prenzlau" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "antennebrandenburg" :l2-id "prenzlau" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "57dd43ef3160b03c"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://antbrb-cottbus.akamaized.net/hls/live/2016999/rbb_antbrb-cottbus/master.m3u8
    ;; https://dispatcher.rndfnk.com/rbb/antennebrandenburg/cottbus/mp3/mid
    (antenne-cottbus
     :name "Antenne Brandenburg Cottbus" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "antennebrandenburg" :l2-id "cottbus" :bitrate "mid"
     :publisher "1b6ae8b401a077fd" :livestream "328f0b31e0ff512c"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/rbb888/live/mp3/mid
    ;; https://rbb888.akamaized.net/hls/live/2017003/rbb_rbb888/master.m3u8
    (rbb-888
     :name "RBB 88.8" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "888" :l2-id "live" :bitrate "mid"
     :publisher "599a095fa84a416e" :livestream "b9686d01b5ebc136"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/radioeins/live/mp3/mid
    ;; https://radioeins.akamaized.net/hls/live/2016930/rbb_radioeins/master.m3u8
    (rbb-radioeins
     :name "RBB Radio Eins" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "radioeins" :l2-id "live" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "b10db8e5de2aab87"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/radioeins/frankfurt/mp3/mid
    ;; https://radioeins-frankfurt.akamaized.net/hls/live/2016996/rbb_radioeins-frankfurt/master.m3u8
    (rbb-radioeins-frankfurt
     :name "RBB Radioeins Frankfurt" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "radioeins" :l2-id "frankfurt" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "02d1c474fb9aa37a"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/radioeins/cottbus/mp3/mid
    ;; https://radioeins-cottbus.akamaized.net/hls/live/2016995/rbb_radioeins-cottbus/master.m3u8
    (rbb-radioeins-cottbus
     :name "RBB Radioeins Cottbus" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "radioeins" :l2-id "cottbus" :bitrate "mid"
     :publisher "6fd2ea6b797a605b" :livestream "99b9c3e67c4f49ac"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/inforadio/live/mp3/mid
    ;; https://inforadio.akamaized.net/hls/live/2017004/rbb_inforadio/master.m3u8
    (rbb-inforadio
     :name "RBB Inforadio" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "inforadio" :l2-id "live" :bitrate "mid"
     :publisher "d7b84d265c36f604" :livestream "cb6df5483c778969"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/inforadio/sorb/mp3/mid
    ;; https://inforadio-sorb.akamaized.net/hls/live/2017005/rbb_inforadio-sorb/master.m3u8
    (rbb-inforadio-sorbisch
     :name "RBB Inforadio Sorbisch" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "inforadio" :l2-id "sorb" :bitrate "mid"
     :publisher "d7b84d265c36f604" :livestream "36c444681c987527"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/rbbkultur/live/mp3/mid
    ;; https://rbbkultur.akamaized.net/hls/live/2017006/rbb_rbbkultur/master.m3u8
    (rbb-radio3
     :name "RBB Radio 3" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
     :station "rbbkultur" :l2-id "live" :bitrate "mid"
     :publisher "9548accdf5dcc097" :livestream "59d7ea9aff468b01"
     :api radio-f--rbb-ard-radio-api-url
     :processor radio-f--rbb-ard-radio-processor
     :l1-stream radio-f--rbb-radio-stream-level-one
     :l2-stream radio-f--rbb-radio-stream-level-two)
    ;; https://dispatcher.rndfnk.com/rbb/fritz/live/mp3/mid
    ;; https://fritz.akamaized.net/hls/live/2016997/rbb_fritz/master.m3u8
    (rbb-fritz
     :name "RBB Fritz" :carrier rbb :id "2016998" :l1-id "rbb_antbrb"
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

;; https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:ce6aa75693f78329?pastHours=0.2
;; https://www.rbb.de/public/radioplaylists/rbb903.json
;; https://www.rbb.de/public/radioplaylists/rbb2.json
;; https://www.rbb.de/public/radioplaylists/rbb1niedersachsen.json
;; https://www.rbb.de/public/radioplaylists/rbb1radiomv.json
;; https://www.rbb.de/public/radioplaylists/rbb1wellenord.json
;; https://www.rbb.de/public/radioplaylists/njoy.json

(defconst radio-f--rbb-radio-api-url
  "https://www.rbb.de/public/radioplaylists/<<id>>.json"
  "Template to retrieve metadata for RBB Schlager.")

(defconst radio-f--rbb-url
  "https://www1.rbb.de/radio/<<rbb-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--rbb-radio-stream-level-one ;; AAC, 192kbps
  "https://antbrb.akamaized.net/hls/live/<<id>/<<l1-id>>/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--rbb-radio-stream-level-two ;; MP3, 128kbps
  "https://dispatcher.rndfnk.com/rbb/<<station>>/<<l2-id>>/mp3/<<bitrate>>"
;;  "http://streaming01.rbb-online.de/<<id>>_2.m3u"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--rbb-icecast-stream-level-two ;; MP3, 128
  "https://icecast.rbb.de/rbb/<<station>>/<<l2-id>>/mp3/<<bitrate>>/stream.mp3"
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
                     "https://www.rbb.de/public/radioplaylists/coverimages/%s_600x600.jpg"
                     (cdr (assoc "song_now_cover" now)))))))

(provide 'radio-f-rbb)
