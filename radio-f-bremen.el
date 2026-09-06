;;; radio-f-bremen.el --- Radio Bremen plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 06 Sep 26
;; Keywords: hypermedia, network, streaming, radio, Radio France

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
;; Radio Bremen plugin for Radio F: six stations.
;;
;; Radio Bremen doesn't always supply artwork for it programming,
;; and none for individual tracks.  Radio F has to supply its own.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--rb-stations
  '((bremen-eins
     :name "Bremen Eins" :carrier breman :metadata bremen
     :id "bremeneins" :api-tag "startseite-bremen-eins-"
     :publisher "6f3a681040e99d95" :livestream "43b952d7b301bc4b"
     :float "0.1"
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-eins-visual-url)
    (bremen-zwei
     :name "Bremen Zwei" :carrier breman :metadata bremen
     :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (bremen-vier
     :name "Bremen Vier" :carrier breman :metadata bremen
     :id "bremenvier" :api-tag "bremenvier-startseite"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (bremen-next
     :name "Bremen Next" :carrier breman :metadata bremen
     :id "bremennext" :api-tag "bremennext-startseite"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for development purposes.")

(defconst radio-f--ard-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=<<float>>"
  "Template to retrieve metadata from all supported carriers through the ARD Audiothek API.")

(defconst radio-f--bremen-api-url
  "https://www.<<id>>.de/<<api-tag>>100~ajax_ajaxType-epg.json"
  "Template used to retrieve JSON data from Radio Bremen.")

;; == WEB URLS ==========

(defconst radio-f--bremen-www-url "https://<<id>>.de/")


;; == ARTWORK URLS ==========

(defconst radio-f--bremen-eins-visual-url
 "https://www.radiobremen-brandportal.de/sites/default/files/styles/half_width/public/2020-10/Gruppe%20746.png"
  "Template used to retrieve the artwork image for the presentation views.")

;; == STREAM URLS =======

(defconst radio-f--bremen-level-one ;; AAC, 192kbps
  "https://rb-radio.ard-mcdn.de/rb/radio/<<id>>/hls/master.m3u8"
 "Template to return a level One radio stream for Radio Bremen.")

(defconst radio-f--bremen-level-two ;; MP3, 128kbps
  "https://dispatcher.rndfnk.com/ard/rb/<<id>>/live/mp3/128/stream.mp3"
"Template to return a level Two radio stream for Radio Bremen.")

;; == STREAM LEVELS =====

(defconst radio-f--bremen-streams
  `((One     . ,radio-f--bremen-level-one)
    (Two     . ,radio-f--bremen-level-two)
    (default . ,radio-f--bremen-level-one))
  "Audio stream templates provided by Radio Bremen.")

;; == PROCESSORS ================================

(defun radio-f--ard-processor (data station)
  (let* ((events (cdr (assoc "events" data)))
         (object (aref events 0))
         (track-info (cdr (assoc "title" object)))
         (image  (cdr (assoc "image" object)))
         (artist (cdr (assoc "short" track-info)))
         (title (cdr (assoc "subTitle" track-info)))
         (start-string (cdr (assoc "startDate" object)))
         (end-string (cdr (assoc "endDate" object)))
         (start (time-convert
                 (date-to-time start-string) 'integer))
         (end (time-convert
               (date-to-time end-string) 'integer))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startDate" object)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "endDate" object)))
           'integer))
         (visual-url (cdr (assoc "contentUrl" image)))
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--bremen-processor (data station)
  "Process Bayerischer Rundfunks DATA for STATION."
  (let* ((now (cdr (assoc "currentBroadcast" data)))
         (item-id (cdr (assoc "id" now)))
         (artist (cdr (assoc "title" now)))
         (title (cdr (assoc "titleAddon" now)))
         ;;         (start (cdr (assoc "start" broadcast)))
         ;;         (end (cdr (assoc "end" broadcast)))
         ;; DLF Nova only provides artwork for programs,
         ;; and "cover" is empty otherwise. Do the DLF trick.
         (visual-url (symbol-value (plist-get station :visual))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      ;;        (start      . ,start)
      ;;        (end        . ,end)
      (visual-url . ,visual-url))))

(provide 'radio-f-bremen)

;;; radio-f-bremen.el ends here
