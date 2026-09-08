;;; radio-f-br.el --- Bayerischer Rundfunks plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 06 Sep 26
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
;; Bayerischer Rundfunks plugin for Radio F: 11 Stations.
;;
;; Bayerischer Rundfunks was finished before I discovered the ARD Mediathek
;; API, so this carrier uses the home-grown BR API.  Witness the nightmare
;; that is GraphQL queries.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--br-stations
  '((b1obb
     :name "Bayern 1 Oberbayern"
     :carrier br :metadata br :stream br
     :id "bayern1" :br-level-1-stream-id "b1obb"
     :l2-stream-id "br1/obb" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (b1schw
     :name "Bayern 1 Schwaben"
     :carrier br :metadata br :stream br
     :id "bayern1" :br-level-1-stream-id "b1schw"
     :l2-stream-id "br1/schwaben" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (b1franken
     :name "Bayern 1 Franken"
     :carrier br :metadata br :stream br
     :id "bayern1" :br-level-1-stream-id "b1franken"
     :l2-stream-id "br1/franken" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (b1main
     :name "Bayern 1 Mainfranken"
     :carrier br :metadata br :stream br
     :id "bayern1" :br-level-1-stream-id "b1main"
     :l2-stream-id "br1/mainfranken" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (b1nbopf
     :name "Bayern 1 Niederbayern/Oberpfalz"
     :carrier br :metadata br :stream br
     :id "bayern1" :br-level-1-stream-id "b1nbopf"
     :l2-stream-id "br1/nbopf" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (bayern2
     :name "Bayern 2"
     :carrier br :metadata br :stream br
     :id "bayern2" :br-level-1-stream-id "b2"
     :l2-stream-id "br2" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (bayern3
     :name "Bayern 3"
     :carrier br :metadata br :stream br
     :id "bayern3" :br-level-1-stream-id "b3"
     :l2-stream-id "br3" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br24
     :name "BR 24" :carrier br :metadata br :stream br
     :id "br24" :br-level-1-stream-id "br24"
     :l2-stream-id "br24" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-klassik
     :name "Bayern Klassik" :carrier br :metadata br :stream br
     :id "br-klassik" :br-level-1-stream-id "brklassik"
     :l2-stream-id "brklassik" :l2-bitrate "256"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-schlager
     :name "Bayern Schlager" :carrier br :metadata br :stream br
     :id "br-schlager" :br-level-1-stream-id "brschlager"
     :l2-stream-id "brschlager" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-heimat
     :name "Bayern Heimat" :carrier br :metadata br :stream br
     :id "br-heimat" :br-level-1-stream-id "brheimat"
     :l2-stream-id "brheimat" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for development purposes.")

(defconst radio-f--br-api-url
  "https://brradio.br.de/radio/v4?query=query+broadcastService($stationSlug:String!){audioBroadcastService(slug:$stationSlug){...on+AudioBroadcastService{id+dvbServiceId+name+slug+fallbackTeaserImage{url}trackingInfos{pageVars+mediaVars}...on+MangoBroadcastService{webcamUrls...jumpMarkers}epg(slots:[CURRENT]){broadcastEvent{trackingInfos{pageVars+mediaVars}...eventStartEnd+items{...audioElement...on+NewsElement{author}...on+MusicElement{performer+composer}}excludedTimeRanges{start+end}publicationOf{...eventMetadata+defaultTeaserImage{url}...on+MangoProgramme{canonicalUrl+title+kicker}}}}description+url}}}fragment+eventMetadata+on+MangoCreativeWorkInterface{id+kicker+title+description}fragment+jumpMarkers+on+MangoBroadcastService{lastNewsDate+lastTrafficDate+lastWeatherDate}fragment+audioElement+on+AudioElement{guid+title+class+start+duration}fragment+eventStartEnd+on+MangoBroadcastEvent{id+start+end}&variables[stationSlug]=<<id>>"
  "Template used to retrieve JSON data from Bayerischen Rundfunks.")


;; == WEB URLS ==========

(defconst radio-f--br-www-url "https://br.de/radio/<<id>>")


;; == STREAM URLS =======

(defconst radio-f--br-level-one ;; AAC, 192kbps
"https://br-radio.ard-mcdn.de/br/radio/<<br-level-1-stream-id>>/hls/master.m3u8"
"Template used to return a level one audio stream for playback.")

(defconst radio-f--br-level-two ;; MP3, 128/256kbps
  "https://dispatcher.rndfnk.com/br/<<l2-stream-id>>/live/mp3/<<l2-bitrate>>/stream.mp3"
"Template used to return a level one audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--br-streams
  `((One     . ,radio-f--br-level-one)
    (Two     . ,radio-f--br-level-two)
    (default . ,radio-f--br-level-one))
  "Audio stream templates provided by Bayerischer Rundfunks.")


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

(defun radio-f--br-processor (data station)
  "Process Bayerischer Rundfunks DATA for STATION."
  ;; Hold on, we got a long way to go...
  (let* ((current-time (float-time))
         (data (cdr (assoc "data" data)))
         (service (cdr (assoc "audioBroadcastService" data)))
         (epg (cdr (assoc "epg" service)))
         (good-stuff (aref epg 0))
         (broadcast (cdr (assoc "broadcastEvent" good-stuff)))
         (tracking (cdr (assoc "trackingInfos" broadcast)))
         (now (cdr (assoc "pageVars" tracking)))
         (item-id (cdr (assoc "generic_id" now)))
         (artist (cdr (assoc "broadcast_service" now)))
         (title (cdr (assoc "title" now)))
         (start-string (cdr (assoc "start" broadcast)))
         (end-string (cdr (assoc "end" broadcast)))
         (start (time-convert
                 (date-to-time start-string) 'integer))
         (end (time-convert
               (date-to-time end-string) 'integer))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "start" broadcast)))
           'integer))
         (end
          (time-convert
           (date-to-time
            (cdr (assoc "end" broadcast)))
           'integer))
         ;; Like its sister stations, DLF Nova has no UUID
         ;; for JSON objects. Use the same fix as the others.
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end)))
         ;; DLF Nova only provides artwork for programs,
         ;; and "cover" is empty otherwise. Do the DLF trick.
         (publication (cdr (assoc "publicationOf" broadcast)))
         (image (cdr (assoc "defaultTeaserImage" publication)))
         (visual-url (cdr (assoc "url" image))))
    ;; Fill in the returned values.  Postmaster takes it from there.
    `((item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))


(provide 'radio-f-br)

;;; radio-f-br.el ends here
