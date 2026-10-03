;;; radio-f-wdr.el --- WDR plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Fri 18 Sep 26
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
;; WDR plugin for Radio F: 41 Stations.
;;
;; Uses the ARD Audiothek API for JSON.


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--wdr-stations
  '((wdrcosmo
     :name "COSMO" :carrier wdr :id "cosmo" :bitrate "128"
     :publisher "4560bc62a6bdc9ef" :livestream "d96db4783260aa14"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (cosmosoul
     :name "COSMO Soulfood Web" :carrier wdr :bitrate "128"
     :station "cosmo" :id "italia"
     :livestream "53ab366cbfca9e9a"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmoafro
     :name "COSMO Afrobeats Web" :carrier wdr :bitrate "128"
     :station "cosmo" :id "afrobeat"
     :livestream "49a74388e5905a36"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmochill
     :name "COSMO Chill Web" :carrier wdr :bitrate "128"
     :livestream "b4b07e7a617182de"
     :station "cosmo" :id "chillout"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmotrap
     :name "COSMO fem:power Web" :carrier wdr :bitrate "128"
     :livestream "9a3060a98c820d21"
     :station "cosmo" :id "trap"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmoneu
     :name "Neu in COSMO Web" :carrier wdr :bitrate "128"
     :livestream "7c7648c14805a116"
     :station "cosmo" :id "neuincosmo"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmosummer
     :name "COSMO Summer Vibes Web" :carrier wdr :bitrate "128"
     :livestream "52e166c9367de0a4"
     :station "cosmo" :id "special"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmodance
     :name "COSMO Dance Web" :carrier wdr :bitrate "128"
     :livestream "0da28eb95856846f"
     :station "cosmo" :id "dance"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (cosmokonzerte
     :name "COSMO Konzerte Web" :carrier wdr :bitrate "128"
     :livestream "852552af4beaa862"
     :station "cosmo" :id "coslive"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr1live
     :name "WDR 1LIVE" :carrier wdr :id "1live" :l2-id "1live" :bitrate "128"
     :publisher "4560bc62a6bdc9ef" :livestream "52ab46cdf0baac57"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr1livediggi
     :name "WDR 1LIVE Diggi Web" :carrier wdr :id "1livediggi" :bitrate "128"
     :livestream "4c43fede80d6b508"
     :station "1live" :l2-id "diggi"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-one)
    (wdrdancehits
     :name "WDR 1LIVE Dance Hits Web" :carrier wdr :bitrate "128"
     :livestream "1ee2cfe6e2f61063"
     :station "1live" :id "dancehits"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdroriginale
     :name "WDR 1LIVE Originale Web" :carrier wdr :bitrate "128"
     :livestream "7bc3ff29640bebe7"
     :web-l2-domain "icecast" :station "1live" :id "originale"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdrtophits
     :name "WDR 1LIVE Top Hits Web" :carrier wdr :bitrate "128"
     :livestream "f78f4dfde4b1b205"
     :station "1live" :id "tophits"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdrhiphoprnb
     :name "WDR 1LIVE R&B & Hip Hop Web" :carrier wdr :bitrate "128"
     :livestream "ad2854227a24cd97"
     :station "1live" :id "hiphoprnb"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdrchillout
     :name "WDR 1LIVE Chillout Web" :carrier wdr :bitrate "128"
     :livestream "6ed1aebe18d6b705"
     :station "1live" :id "chillout"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr1liverockhits
     :name "WDR 1LIVE Rock Hits Web" :carrier wdr :bitrate "128"
     :livestream "d5193e79f7d2c519"
     :station "1live" :id "rockhits"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr2-rheinland
     :name "WDR 2 Rheinland" :carrier wdr :station "wdr2" :id "wdr2rhld"
     :locale "rheinland" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "8b939df5fa39be0b"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-aachen
     :name "WDR 2 Aachen und Region" :carrier wdr :station "wdr2" :id "wdr2ac"
     :locale "aachenundregion" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "ee9a086f00147c5d"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-sudwestfalen
     :name "WDR 2 Südwestfalen" :carrier wdr :station "wdr2" :id "wdr2swf"
     :locale "suedwestfalen" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "d78a727b7282dc94"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-lippe
     :name "WDR 2 Ostwestfalen Lippe" :carrier wdr :station "wdr2" :id "wdr2owl"
     :locale "ostwestfalenlippe" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "9c0af28790c681fa"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-rheinruhr
     :name "WDR 2 Rhein und Ruhr" :carrier wdr
     :station "wdr2" :id "wdr2rr"
     :locale "rheinruhr" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "8966dec50d3692a4"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-ruhrgebiet
     :name "WDR 2 Ruhrgebiet" :carrier wdr
     :station "wdr2" :id "wdr2ruhrgb"
     :locale "ruhrgebiet"
     :publisher "82719e5e5c83925a" :livestream "84d92a896d3cbcca"
     :api radio-f--wdr-web-api-url :bitrate "128"
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-bergisches-land
     :name "WDR 2 Bergisches Land" :carrier wdr
     :station "wdr2" :id "wdr2bld"
     :locale "bergischesland" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "eaca8e08741608dc"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr2-munsterland
     :name "WDR 2 Münsterland" :carrier wdr
     :station "wdr2" :id "wdr2mld"
     :locale "muensterland" :bitrate "128"
     :publisher "82719e5e5c83925a" :livestream "36be5febc15a6bcd"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr3
     :name "WDR 3" :carrier wdr :id "wdr3"
     :station "live" :bitrate "256"
     :publisher "c0817fb5f569a4c9" :livestream "4e78bd44bd9d8b36"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr3-radio-level-two)
    (wdr3-world
     :name "WDR 3 World Web" :carrier wdr :id "world"
     :station "wdr3" :bitrate "128"
     :livestream "cff3461f36492336"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr3-jazz
     :name "WDR 3 Jazz Web" :carrier wdr :bitrate "128"
     :station "wdr3" :id "jazz"
     :livestream "5486e3a7f3a31f44"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr3-klassik
     :name "WDR 3 Klassik Web" :carrier wdr :id "klassik"
     :station "wdr3" :bitrate "128"
     :livestream "714aaa4f64f47985"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two)
    (wdr4-dream
     :name "WDR 4 Musik zum Träumen Web" :carrier wdr :station "wdr4"
     :locale "musikzumtraeumen"
     :livestream "f695e1efa2ba7455"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-web-processor
     :l1-stream radio-f--wdr-web-level-two
     :l2-stream radio-f--wdr-web-level-two :bitrate "128")
    (wdr4-ruhrgebiet
     :name "WDR 4 Ruhrgebiet" :carrier wdr
     :id "wdr4ruhrgb" :station "wdr4"
     :locale "ruhrgebiet" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "65999aca80fc92de"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-rheinland
     :name "WDR 4 Rheinland" :carrier wdr
     :station "wdr4" :id "wdr4rhld"
     :locale "rheinland" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "f54ba081d852129a"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-aachenundregion
     :name "WDR 4 Aachen und Region" :carrier wdr
     :station "wdr4" :id "wdr4ac"
     :locale "aachenundregion" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "a06af602ef34959e"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-sudwestfalen
     :name "WDR 4 Südwestfalen" :carrier wdr
     :id "wdr4swf" :station "wdr4"
     :locale "suedwestfalen" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "84433d0678701750"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two :bitrate "128")
    (wdr4-lippe
     :name "WDR 4 Ostwestfalen Lippe" :carrier wdr :id "wdr4owl" :station "wdr4"
     :locale "ostwestfalenlippe"
     :publisher "dcc5f7461d90ca1d" :livestream "24d83f91c79a3c93"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-rheinruhr
     :name "WDR 4 Rhein und Ruhr" :carrier wdr
     :id "wdr4rr" :station "wdr4"
     :locale "rheinruhr" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "8966dec50d3692a4"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-bergisches-land
     :name "WDR 4 Bergisches Land" :carrier wdr
     :id "wdr4bld" :station "wdr4"
     :locale "bergischesland" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "eaca8e08741608dc"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr4-muensterland
     :name "WDR 4 Münsterland" :carrier wdr
     :id "wdr4mld" :station "wdr4"
     :locale "muensterland" :bitrate "128"
     :publisher "dcc5f7461d90ca1d" :livestream "26ca0ca86f487797"
     :api radio-f--wdr-web-api-url
     :processor radio-f--wdr-regional-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdr5
     :name "WDR 5" :carrier wdr
     :id "wdr5" :locale "live" :bitrate "128"
     :publisher "9e3516adb47afc8e" :livestream "0fa94ef0c09df1df"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    (wdrmaus
     :name "WDR Maus" :carrier wdr
     :id "diemaus" :locale "live" :bitrate "128"
     :publisher "32a2d9c329891a0b" :livestream "767b059329029e26"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two)
    ;; There's an entry for this station in the ARD Audiothek, but
    ;; the audio stream is silence, and the only information found in
    ;; the JSON is "Derzeit keine Übertragung." (No transmission at
    ;; the moment.)  I believe it's a "we interrupt this broadcast
    ;; with a special report" kind of channel, and is only activated
    ;; when needed.  In any case, the Audiothek API includes it, so we
    ;; include it too.  Just know that this station is, at the moment,
    ;; broken.
  (wdr-event
     :name "WDR Event" :carrier wdr
     :id "wdr" :locale "event" :bitrate "128"
     :publisher "d7a027a68167aa6f" :livestream "a6368f8093717313"
     :api radio-f--wdr-radio-api-url
     :processor radio-f--wdr-radio-processor
     :l1-stream radio-f--wdr-radio-level-one
     :l2-stream radio-f--wdr-radio-level-two))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--ard-organizations
  "https://api.ardaudiothek.de/organizations"
  "URL providing JSON metadata for all ARD stations.  Used for
development purposes.")

(defconst radio-f--wdr-radio-api-url
  "https://programm-api.ard.de/radio/api/channel/urn:ard:permanent-livestream:<<livestream>>?pastHours=0.1"
  "Template to retrieve metadata from all supported carriers through
the ARD Audiothek API.")

(defconst radio-f--wdr-web-api-url
  "https://api.ardaudiothek.de/graphql?query=query%20MediaCollectionPermanentLivestreamsQuery(%24id%3AString!)%7BpermanentLivestream(id%3A%24id)%7BmediaCollection(v%3AV6A)%7D%7D&variables=%7B%22id%22%3A%22urn%3Aard%3Apermanent-livestream%3A<<livestream>>%22%7D"
  "Template to retrieve metadata for WDR web streams")

(defconst radio-f--wdr-url
  "https://www1.wdr.de/radio/<<ard-id>>/index.html"
  "URL.")

;; == STREAM URLS =======

(defconst radio-f--wdr-radio-level-one ;; AAC, 192kbps
  "https://wdr-radio.ard-mcdn.de/wdr/radio/<<id>>/hls/master.m3u8"
  "Template used to return a Level One audio stream for playback.")

(defconst radio-f--wdr-radio-level-two ;; MP3
  "https://wdr-<<id>>-<<locale>>.icecastssl.wdr.de/wdr/<<id>>/<<locale>>/mp3/<<bitrate>>/stream.mp3"
  "Template used to return a Level Two audio stream for playback.")

(defconst radio-f--wdr2-radio-level-two
  "https://dispatcher.rndfnk.com/wdr/<<station>>/<<locale>>/mp3/<<bitrate>>/stream.mp3"
  "Stream template for level Two stream on WDR2.")

(defconst radio-f--wdr3-radio-level-two
  "https://wdr-wdr3-live.icecastssl.wdr.de/wdr/<<id>>/<<station>>/mp3/<<bitrate>>/stream.mp3"
  "Stream template for level Two stream on WDR3.")

(defconst radio-f--wdr-web-level-two
  "https://dispatcher.rndfnk.com/wdr/<<station>>/<<id>>/mp3/<<bitrate>>/stream.mp3")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-wdr-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--wdr-api-url
          (symbol-value api))))

(defun radio-f--set-wdr-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--wdr-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-wdr-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--wdr-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--wdr-streams
  `((One     . radio-f--set-wdr-stream-level-one)
    (Two     . radio-f--set-wdr-stream-level-two)
    (default . radio-f--set-wdr-stream-level-one))
  "Audio stream templates provided by Westdeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--wdr-web-processor (data station)
  "Process WDR Web DATA for STATION."
  (let* ((name (plist-get station :name))
         (root (cdr (assoc "data" data)))
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
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-url))))

(defun radio-f--wdr-radio-processor (data station)
  (let* ((name (plist-get station :name))
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

(defun radio-f--wdr-regional-processor (data station)
  (let* ((name (plist-get station :name))
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

(provide 'radio-f-wdr)
