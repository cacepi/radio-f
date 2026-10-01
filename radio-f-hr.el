;;; radio-f-hr.el --- HR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Wed 30 Sep 26
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
;; Hessischer Rundfunk carrier for Radio F: 18 Stations.
;;
;; Uses the ARD Audiothek API for JSON.


;;; Code:

;; == STATION PLIST =====


;; https://dispatcher.rndfnk.com/hr/<<station>>/<<id>>/mp3/128/stream.mp3
;; https://hr-radio.ard-mcdn.de/hr/radio/hr1oh/hls/master.m3u8
;; https://hr-radio.ard-mcdn.de/hr/radio/hr2/hls/master.m3u8

(defconst radio-f--hr-stations
  '((hr1-rhein-main
     :name "HR 1 Rhein-Main" :carrier hr :station "hr1"
     :id "hr1rm" :l2-id "rheinmain" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "02c8711701430a34"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr1-south-hessen
     :name "HR 1 Südhessen" :carrier hr :station "hr1"
     :id "hr1sh" :l2-id "suedhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "ec03b7c77866742c"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr1-east-hessen
     :name "HR 1 Osthessen" :carrier hr :station "hr1"
     :id "hr1oh" :l2-id "osthessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "a7b5fc4a7ee0e948"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr1-north-hessen
     :name "HR 1 Nordhessen" :carrier hr :station "hr1"
     :id "hr1nh" :l2-id "nordhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "fbbbdf64f82006c1"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr1-middle-hessen
     :name "HR 1 Mittelhessen" :carrier hr :station "hr1"
     :id "hr1mh" :l2-id "mittelhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "2675995635e59225"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr2-kultur
     :name "HR 2 Kultur" :carrier hr :station "hr2"
     :id "hr2" :l2-id "live" :bitrate "medium"
     :publisher "bb3ac9eaa762650d" :livestream "b137ee415c3a5dbc"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr3-rhein-main
     :name "HR 3 Rhein-Main" :carrier hr :station "hr3"
      :id "hr3rm" :id "rheinmain" :bitrate "high"
      :publisher "bb3ac9eaa762650d" :livestream "1e32c42a0fb482b5"
      :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr3-south-hessen
     :name "HR 3 Südhessen" :carrier hr :station "hr3"
     :id "hr3sh" :l2-id "suedhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "cc89ca8be6e1e4bd"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr3-east-hessen
     :name "HR 3 Osthessen" :carrier hr :station "hr3"
     :id "hr3eh" :l2-id "osthessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "c56beac1f68791c3"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr3-north-hessen
     :name "HR 3 Nordhessen" :carrier hr :station "hr3"
     :id "hr3nh" :l2-id "nordhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "848503a0d4395b3b"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr3-middle-hessen
     :name "HR 3 Mittelhessen" :carrier hr :station "hr3"
     :id "hr3mh" :l2-id "mittelhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "933d6b03547f29d6"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr4-rhein-main
     :name "HR 4 Rhein-Main" :carrier hr :station "hr4"
      :id "hr4rm" :id "rheinmain" :bitrate "high"
      :publisher "bb3ac9eaa762650d" :livestream "943831064f22c43f"
      :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr4-south-hessen
     :name "HR 4 Südhessen" :carrier hr :station "hr4"
     :id "hr4sh" :l2-id "suedhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "2de1602d36586125"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr4-east-hessen
     :name "HR 4 Osthessen" :carrier hr :station "hr4"
     :id "hr4eh" :l2-id "osthessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "5f5a02ee84420daa"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr4-north-hessen
     :name "HR 4 Nordhessen" :carrier hr :station "hr4"
     :id "hr4nh" :l2-id "nordhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "009bd9c1603de6ac"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr4-middle-hessen
     :name "HR 4 Mittelhessen" :carrier hr :station "hr4"
     :id "hr4mh" :l2-id "mittelhessen" :bitrate "high"
     :publisher "bb3ac9eaa762650d" :livestream "d336a659fb7aa289"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr-info
     :name "HR iNFO" :carrier hr :station "hrinfo"
     :id "hrinfo" :l2-id "live" :bitrate "high"
     :publisher "32a2d9c329891a0b" :livestream "3234916d9fbf2a76"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--hr-radio-level-two)
    (hr-dasding
     :name "DASDING (You FM)" :carrier hr :station "dasding"
     :id "dasding" :l2-id "mp3" :bitrate "128"
     :publisher "32a2d9c329891a0b" :livestream "a881787b1fcc4085"
     :api radio-f--hr-web-api-url
     :processor radio-f--hr-web-processor
     :l1-stream radio-f--hr-radio-level-one
     :l2-stream radio-f--dasding-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for
development purposes.")

(defconst radio-f--hr-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.1"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--hr-web-api-url
;;    "https://api.ardaudiothek.de/graphql?query=query+MediaCollectionPermanentLivestreamsQuery($id:String!){permanentLivestream(id:$id){mediaCollection(v:V6A)}}&variables={\"id\":\"urn:ard:permanent-livestream:<<livestream>>\"}"
;;  "https://api.ardaudiothek.de/graphql?query=query+MediaCollectionPermanentLivestreamsQuery($id:String!){permanentLivestream(id:$id){mediaCollection(v:V6A)}}&variables={\"id\":\"urn:ard:permanent-livestream:<<livestream>>\"}"
  "https://api.ardaudiothek.de/graphql?query=query%20MediaCollectionPermanentLivestreamsQuery(%24id%3AString!)%7BpermanentLivestream(id%3A%24id)%7BmediaCollection(v%3AV6A)%7D%7D&variables=%7B%22id%22%3A%22urn%3Aard%3Apermanent-livestream%3A<<livestream>>%22%7D"
  "Template to retrieve metadata for HR web streams")

(defconst radio-f--hr-url
  "https://www1.hr.de/radio/<<ard-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--hr-radio-level-one ;; AAC, 192kbps
  "https://hr-radio.ard-mcdn.de/hr/radio/<<id>>/hls/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--hr-radio-level-two ;; MP3
;;  "https://hr-<<l2-id>>-<<locale>>.icecastssl.hr.de/hr/<<l2-id>>/<<locale>>/mp3/<<bitrate>>/stream.mp3"
  "https://dispatcher.rndfnk.com/hr/<<station>>/<<l2-id>>/<<bitrate>>"
  "Template used to return a Level Two audio stream for playback.")

(defconst radio-f--dasding-level-two
  "https://dispatcher.rndfnk.com/hr/<<station>>/<<l2-id>>/mp3/<<bitrate>>/stream.mp3"
  "Stream template for level Two stream on HR2.")

;; (defconst radio-f--hr-web-level-two
;;   "https://dispatcher.rndfnk.com/hr/<<station>>/<<id>>/mp3/<<bitrate>>/stream.mp3")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-hr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--hr-api-url
          (symbol-value api))))

(defun radio-f--set-hr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--hr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-hr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--hr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--hr-streams
  `((One     . radio-f--set-hr-stream-level-one)
    (Two     . radio-f--set-hr-stream-level-two)
    (default . radio-f--set-hr-stream-level-one))
  "Audio stream templates provided by Westdeutscher Rundfunk.")

;; (defun radio-f--set-hr-streams ()
;;   (let* ((station (radio-f--get-current-station-data))
;;          (stream (plist-get station :stream))
;;          (streams-symbol
;;           (cdr (assq stream radio-f--ard-stream-providers))))
;;     (setq radio-f--hr-streams
;;           (symbol-value streams-symbol))))


;; == PROCESSORS ================================

(defun radio-f--hr-web-processor (data station)
  "Process HR Web DATA for STATION."
  (let* ((station (radio-f--get-current-station-data))
         (name (plist-get station :name))
         (root (cdr (assoc "data" data)))
         (stream (cdr (assoc "permanentLivestream" root)))
         (media (cdr (assoc "mediaCollection" stream)))
         (meta (cdr (assoc "meta" media)))
         (images (cdr (assoc "images" meta)))
         (now (aref images 1))
         (artist (cdr (assoc "title" meta)))
         (title (cdr (assoc "clipSourceName" meta)))
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

(defun radio-f--hr-radio-processor (data station)
  (let* ((station (radio-f--get-current-station-data))
         (name (plist-get station :name))
         (events (cdr (assoc "events" data)))
         (events (aref events 0))
         (clips (cdr (assoc "clips" events)))
         (now (aref clips 0))
         (image  (cdr (assoc "image" now)))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "start" now)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "end" now)))
           'integer))
         (visual-url (cdr (assoc "url" image)))
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--hr-regional-processor (data station)
  (let* ((station (radio-f--get-current-station-data))
         (name (plist-get station :name))
         (root (cdr (assoc "data" data)))
         (stream (cdr (assoc "permanentLivestream" root)))
         (media (cdr (assoc "mediaCollection" stream)))
         (now (cdr (assoc "meta" media)))
         (image-array (cdr (assoc "images" now)))
         (images (aref image-array 1))
         (artist (cdr (assoc "title" now)))
         (title (cdr (assoc "title" images)))
         (start (floor (float-time)))
         (end (floor (float-time)))
         (visual-url (cdr (assoc "url" images)))
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

(provide 'radio-f-hr)

;;; radio-f-hr.el ends here
