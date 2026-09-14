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
;; Radio Bremen plugin for Radio F: four stations and five web streams.
;;
;; Radio F uses Audiothek API for the web streams to this carrier,
;; as Radio Bremen's API doesn't provide information for those
;; streams.
;;
;; Radio Bremen also doesn't always supply artwork for it programming,
;; and virtually none for individual tracks.  Rather than having
;; intermittent artwork, Radio F supplies its own, so don't delete the
;; artwork files or you'll put the juju on the whole carrier.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--bremen-stations
  '((bremen-eins
     :name "Bremen Eins" :carrier bremen
     :id "bremeneins" :api-tag "startseite-bremen-eins-"
     :publisher "6f3a681040e99d95" :livestream "f26c840eca9f7990"
     :www "https://www.bremeneins.de"
     :l1-stream radio-f--bremen-radio-level-one
     :l2-stream radio-f--bremen-radio-level-two
     :api radio-f--ajax-bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-eins-visual)
    (bremen-zwei
     :name "Bremen Zwei" :carrier bremen
     :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
     :publisher "2dca89fbe903ab06" :livestream "f26c840eca9f7990"
     :www "https://www.bremenzwei.de"
     :l1-stream radio-f--bremen-radio-level-one
     :l2-stream radio-f--bremen-radio-level-two
     :api radio-f--ajax-bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-zwei-visual)
    (bremen-vier
     :name "Bremen Vier" :carrier bremen
     :id "bremenvier" :api-tag "bremenvier-startseite"
     :publisher "52598ef10fe29b22" :livestream "a081291373972e5a"
     :www "https://www.bremevier.de"
     :l1-stream radio-f--bremen-radio-level-one
     :l2-stream radio-f--bremen-radio-level-two
     :api radio-f--ajax-bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-vier-visual)
    (bremen-next
     :name "Bremen Next" :carrier bremen
     :id "bremennext" :api-tag "bremennext-startseite"
     :publisher "fa5a5a1d13706f96" :livestream "31a01c8edf6870b0"
     :www "https://www.bremennext.de"
     :l1-stream radio-f--bremen-radio-level-one
     :l2-stream radio-f--bremen-radio-level-two
     :api radio-f--ajax-bremen-api-url :processor radio-f--bremen-processor
     :visual-url nil :visual radio-f--bremen-next-visual)
    ;; These are web-only streams, so they use a different API template
    ;; and processor.
    (bremen-zwei-herz
     :name "Bremen Zwei Herzstücke Web" :carrier bremen
     :id "webchannel4" :livestream "5cd4b678f6c9b3ba"
     :l1-stream radio-f--bremen-web-level-two
     :l2-stream radio-f--bremen-web-level-two
     :api radio-f--ard-bremen-api-url
     :processor radio-f--ard-bremen-processor
     :visual radio-f--bremen-zwei-visual)
    (bremen-zwei-sounds
     :name "Bremen Zwei Sounds Web" :carrier bremen
     :id "webchannel7" :livestream "b4884322d2c878c0"
     :l1-stream radio-f--bremen-web-level-two
     :l2-stream radio-f--bremen-web-level-two
     :api radio-f--ard-bremen-api-url
     :processor radio-f--ard-bremen-processor
     :visual radio-f--bremen-zwei-visual)
    (bremen-vier-festival
     :name "Bremen Vier Festival-Channel Web" :carrier bremen
     :id "webchannel2" :livestream "b77402449ddba998"
     :l1-stream radio-f--bremen-web-level-two
     :l2-stream radio-f--bremen-web-level-two
     :api radio-f--ard-bremen-api-url
     :processor radio-f--ard-bremen-processor
     :visual radio-f--bremen-vier-visual)
    (bremen-vier-dance
     :name "Bremen Vier Tanzt! Web" :carrier bremen
     :id "webchannel3" :livestream "ef0edf0b4532afca"
     :l1-stream radio-f--bremen-web-level-two
     :l2-stream radio-f--bremen-web-level-two
     :api radio-f--ard-bremen-api-url
     :processor radio-f--ard-bremen-processor
     :visual radio-f--bremen-vier-visual)
    (bremen-vier-zebra
     :name "Bremen Vier Zebra Web" :carrier bremen
     :id "webchannel8" :livestream "917956f8917024f9"
     :l1-stream radio-f--bremen-web-level-two
     :l2-stream radio-f--bremen-web-level-two
     :api radio-f--ard-bremen-api-url
     :processor radio-f--ard-bremen-processor
     :visual radio-f--bremen-vier-visual))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for development purposes.")

(defconst radio-f--ard-bremen-api-url
  "https://api.ardaudiothek.de/graphql?query=query+MediaCollectionPermanentLivestreamsQuery($id:String!){permanentLivestream(id:$id){mediaCollection(v:V6A)}}&variables={\"id\":\"urn:ard:permanent-livestream:<<livestream>>\"}"
;; "https://api.ardaudiothek.de/graphql?query=query%20MediaCollectionPermanentLivestreamsQuery(%24id%3AString!)%7BpermanentLivestream(id%3A%24id)%7BmediaCollection(v%3AV6A)%7D%7D&variables=%7B%22id%22%3A%22urn%3Aard%3Apermanent-livestream%3A<<livestream>>%22%7D"
  "Template to retrieve metadata from all supported carriers through the ARD Audiothek API.")

(defconst radio-f--ajax-bremen-api-url
  "https://www.<<id>>.de/<<api-tag>>100~ajax_ajaxType-epg.json"
  "Template used to retrieve JSON data from Radio Bremen.")


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

(defconst radio-f--bremen-radio-level-one ;; AAC, 192kbps
  "https://rb-radio.ard-mcdn.de/rb/radio/<<id>>/hls/master.m3u8"
 "Template to return a level One radio stream for Radio Bremen.")

(defconst radio-f--bremen-radio-level-two ;; MP3, 128kbps
  "https://dispatcher.rndfnk.com/ard/rb/<<id>>/live/mp3/128/stream.mp3"
"Template to return a level Two radio stream for Radio Bremen.")

;; Web streams have only a level Two stream: no HLS.
(defconst radio-f--bremen-web-level-two ;; MP3, 128kbps
  "https://icecast.radiobremen.de/rb/<<id>>/mp3/128/stream.mp3"
  "Template to return a web-only level Two stream for Radion Bremen.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-bremen-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--bremen-api-url
          (symbol-value api))))

(defun radio-f--set-bremen-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--bremen-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-bremen-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--bremen-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--bremen-streams
  `((One     . radio-f--set-bremen-stream-level-one)
    (Two     . radio-f--set-bremen-stream-level-two)
    (default . radio-f--set-bremen-stream-level-one))
  "Audio stream templates provided by Radio Bremen.")


;; == PROCESSORS ================================

(defun radio-f--bremen-processor (data station)
  "Process Radio Bremen DATA for STATION."
  (let* ((now (cdr (assoc "currentTitle" data)))
         (tracking (cdr (assoc "trackingData" data)))
         (broadcast (cdr (assoc "currentBroadcast" data)))
         (image (cdr (assoc "image" broadcast)))
         (www (plist-get station :www))
         (item-id (cdr (assoc "id" now)))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "song" now)))
         (start (cdr (assoc "publicationDate" tracking)))
         (end (cdr (assoc "time" now)))
         ;; The "image" key value is a relative path, not
         ;; a fully-formed URL.
         (visual-url (format "%s%s" www image))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s|%s|%s" artist title start end))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--ard-bremen-processor (data station)
  "Process Radio Bremen DATA for STATION."
  (let* ((root (cdr (assoc "data" data)))
         (stream (cdr (assoc "permanentLivestream" root)))
         (media (cdr (assoc "mediaCollection" stream)))
         (meta (cdr (assoc "meta" media)))
         (images (cdr (assoc "images" meta)))
         (now (aref images 1))
         (artist (cdr (assoc "title" now)))
         (title (cdr (assoc "clipSourceName" meta)))
         (start (floor (float-time)))
         (end (floor (float-time)))
         (visual-url (cdr (assoc "url" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--bremen-web-processor (data station)
  "Process Radio Bremen DATA for STATION."
  (let* ((station (radio-f--get-current-station-data))
         (artist (plist-get station :artist))
         (title (plist-get station :name))
         ;; Web streams have no JSON, so they have no need for "start" or
         ;; "end" values. The JSON timer is turned off for these streams.
         (visual-url (symbol-value (plist-get station :visual-url)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s|%s|%s" artist title))))
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (visual-url . ,visual-url))))

(provide 'radio-f-bremen)

;;; radio-f-bremen.el ends here
