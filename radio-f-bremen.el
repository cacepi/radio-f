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
;; Radio F is using the Mediathek API for this carrier, which
;; exposes more streams than currently advertised on the Radio
;; Bremen web site.  Those streams are currently disabled until
;; I can integrate them into a system Radio F can ingest.
;;
;; Radio Bremen doesn't always supply artwork for it programming,
;; and none for individual tracks.  Radio F has to supply its own.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--bremen-stations
  '((bremen-eins
     :name "Bremen Eins" :carrier bremen :metadata bremen
     :id "bremeneins" :api-tag "startseite-bremen-eins-"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-eins-visual)
    (bremen-zwei
     :name "Bremen Zwei" :carrier bremen :metadata bremen
     :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
     :publisher "2dca89fbe903ab06" :livestream "f26c840eca9f7990"
     :float "0.1"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-zwei-visual)
    ;; These channels have no metadata available, and just a single audio
    ;; stream. Disabled for the moment.
    ;; (bremen-zwei-herz
    ;;  :name "Bremen Zwei Herzstücke" :carrier bremen :metadata bremen
    ;;  :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
    ;;  :publisher "2dca89fbe903ab06" :livestream "5cd4b678f6c9b3ba"
    ;;  :float "0.1"
    ;;  :api radio-f--bremen-api-url :processor radio-f--bremen-processor
    ;;  :visual radio-f--bremen-visual-url)
    ;; (bremen-zwei-sounds
    ;;  :name "Bremen Zwei Sounds" :carrier bremen :metadata bremen
    ;;  :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
    ;;  :publisher "2dca89fbe903ab06" :livestream "b4884322d2c878c0"
    ;;  :float "0.1"
    ;;  :api radio-f--bremen-api-url :processor radio-f--bremen-processor
    ;;  :visual radio-f--bremen-visual-url)
    (bremen-vier
     :name "Bremen Vier" :carrier bremen :metadata bremen
     :id "bremenvier" :api-tag "bremenvier-startseite"
     :publisher "2dca89fbe903ab06" :livestream "a081291373972e5a"
     :float "0.1"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-vier-visual)
    ;; These channels have no metadata available, and just a single audio
    ;; stream. Disabled for the moment.
    ;; (bremen-vier-festival
    ;;  :name "Bremen Vier Festival-Channel" :carrier bremen :metadata bremen
    ;;  :id "bremenvier" :api-tag "bremenvier-startseite"
    ;;  :publisher "2dca89fbe903ab06" :livestream "b77402449ddba998"
    ;;  :float "0.1"
    ;;  :api radio-f--bremen-api-url :processor radio-f--bremen-processor
    ;;  :visual radio-f--bremen-visual-url)
    ;; (bremen-vier-dance
    ;;  :name "Bremen Vier Tanzt!" :carrier bremen :metadata bremen
    ;;  :id "bremenvier" :api-tag "bremenvier-startseite"
    ;;  :publisher "2dca89fbe903ab06" :livestream "ef0edf0b4532afca"
    ;;  :float "0.1"
    ;;  :api radio-f--bremen-api-url :processor radio-f--bremen-processor
    ;;  :visual radio-f--bremen-visual-url)
    ;; (bremen-zebra-vier
    ;;  :name "Bremen Zebra Vier" :carrier bremen :metadata bremen
    ;;  :id "bremenvier" :api-tag "bremenvier-startseite"
    ;;  :publisher "2dca89fbe903ab06" :livestream "917956f8917024f9"
    ;;  :float "0.1"
    ;;  :api radio-f--bremen-api-url :processor radio-f--bremen-processor
    ;;  :visual radio-f--bremen-visual-url)
    (bremen-next
     :name "Bremen Next" :carrier bremen :metadata bremen
     :id "bremennext" :api-tag "bremennext-startseite"
     :publisher "2dca89fbe903ab06" :livestream "31a01c8edf6870b0"
     :float "0.1"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-next-visual))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for development purposes.")

(defconst radio-f--bmen-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=<<float>>"
  "Template to retrieve metadata from all supported carriers through the ARD Audiothek API.")

(defconst radio-f--bremen-api-url
  "https://www.<<id>>.de/<<api-tag>>100~ajax_ajaxType-epg.json"
  "Template used to retrieve JSON data from Radio Bremen.")

(defconst radio-f--bremen-eins-visual-url
  "https://www.radiobremen-brandportal.de/sites/default/files/styles/half_width/public/2020-10/Gru.png"
  "Template used to retrieve the artwork image for the presentation views.")

;; == WEB URLS ==========

(defconst radio-f--bremen-www-url "https://<<id>>.de/")


;; == FALLBACK ARTWORK ==========

(defconst radio-f--bremen-eins-visual
  "assets/bremen/bremen-eins.png"
  "Fallback artwork image for Bremen Eins.")

(defconst radio-f--bremen-zwei-visual
  "assets/bremen/bremen-zwei.png"
  "Fallback artwork image for Bremen Zwei.")

(defconst radio-f--bremen-vier-visual
  "assets/bremen/bremen-vier.png"
  "Fallback artwork image for Bremen Vier.")

(defconst radio-f--bremen-next-visual
  "assets/bremen/bremen-next.png"
  "Fallback artwork image for Bremen Vier.")

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

(defun radio-f--bmen-processor (data station)
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
  "Process Radio Bremen DATA for STATION."
  (let* ((now (cdr (assoc "currentBroadcast" data)))
         (item-id (cdr (assoc "id" now)))
         (artist (cdr (assoc "title" now)))
         (title (cdr (assoc "titleAddon" now)))
         ;;         (start (cdr (assoc "start" broadcast)))
         ;;         (end (cdr (assoc "end" broadcast)))
         ;; DLF Nova only provides artwork for programs,
         ;; and "cover" is empty otherwise. Do the DLF trick.
         (visual-url (symbol-value (plist-get station :visual-url))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      ;;        (start      . ,start)
      ;;        (end        . ,end)
      (visual-url . ,visual-url))))

(provide 'radio-f-bremen)

;;; radio-f-bremen.el ends here
