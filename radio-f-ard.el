;;; radio-f-ard.el --- ARD plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Mon 31 Aug 26
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
;; ARD plugin for Radio F: 83 Stations.
;; Three stations from Deutschland Radio.
;; 11 Stations from Bayerischer Rundfunks.
;; Six stations from Radio Bremen
;;
;; ARD might be even better organized than the BBC. A single, unified
;; URL template to retrieve metadata for every ARD station, complete
;; with multiple streams for each carrier defined in the master
;; JSON list. Give it to German public radio for being even more
;; punctilious than the BBC.
;;
;; All's not love and roses, as Deutschlandradio refuses to play ball
;; with the other carriers, so little to no proper artwork for their
;; regular programming.  Radio F has to supply its own, instead.
;;
;; Their old api-url defconst for BR is preserved to remind me of the
;; nightmare that is GraphQL queries.


;;; Code:


;; == STATION PLIST =====

(defconst radio-f--ard-stations
  '((bremen-eins
     :name "Bremen Eins" :plugin ard :metadata ard :stream bremen
     :id "bremeneins" :api-tag "startseite-bremen-eins-"
     :publisher "6f3a681040e99d95" :livestream "43b952d7b301bc4b"
     :float "0.1"
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-eins-visual-url)
    (bremen-zwei
     :name "Bremen Zwei" :plugin ard :metadata bremen :stream bremen
     :id "bremenzwei" :api-tag "startseite-bremen-zwei-"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (bremen-vier
     :name "Bremen Vier" :plugin ard :metadata bremen :stream bremen
     :id "bremenvier" :api-tag "bremenvier-startseite"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (bremen-next
     :name "Bremen Next" :plugin ard :metadata bremen :stream bremen
     :id "bremennext" :api-tag "bremennext-startseite"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (wdr-cosmo
     :name "COSMO" :plugin ard :metadata wdr :stream wdr
     :id "cosmo" :api-tag "bremen-cosmo"
     :api radio-f--bremen-api-url :processor radio-f--bremen-processor
     :visual radio-f--bremen-visual-url)
    (wdr-1live
     :name "WDR 1LIVE" :plugin ard :metadata ard :stream wdr
     :publisher 4560bc62a6bdc9ef :livestream 52ab46cdf0baac57
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-rheinland
     :name "WDR 2 Rheinland" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream 8b939df5fa39be0b
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-aachen
     :name "WDR 2 Aachen und Region" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream ee9a086f00147c5d
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-sudwestfalen
     :name "WDR 2 Südwestfalen" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream d78a727b7282dc94
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-lippe
     :name "WDR 2 Ostwestfalen Lippe" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream 9c0af28790c681fa
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-rhein-ruhr
     :name "WDR 2 Rhein und Ruhr" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream 8966dec50d3692a4
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-ruhr-gebiet
     :name "WDR 2 Ruhrgebiet" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream 84d92a896d3cbcca
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-bergisches-land
     :name "WDR 2 Bergisches Land" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream eaca8e08741608dc
     :api radio-f--ard-api-url :processor radio-f--ard-processor
     :visual radio-f--bremen-visual-url)
    (wdr-2-munsterland
     :name "WDR 2 Münsterland" :plugin ard :metadata ard :stream wdr
     :publisher 82719e5e5c83925a :livestream 36be5febc15a6bcd
     :api radio-f--ard-api-url :processor radio-f--ard-processor
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

(defconst radio-f--wdr-api-url
  "https://www1.wdr.de/radio/player/streams/audiostream-live-100.assetjsonp"
  "Template used to retrieve JSON data from Westdeutscher Rundfunk.")

;; == WEB URLS ==========

(defconst radio-f--bremen-www-url "https://<<id>>.de/")

(defconst radio-f--dlf-www-url
  "https://www.deutschland[tag].de"
  "Template used to return the web URL for Deutschland Radio stations.")


;; == ARTWORK URLS ==========

(defconst radio-f--dlf-visual-url
;;  "assets/dlf/dlf.png"
  "https://thumb.wikimedia.org/wikipedia/commons/thumb/5/53/Deutschlandfunk_Logo_klein.png/500px-Deutschlandfunk_Logo_klein.png"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--dlf-kultur-visual-url
  "https://thumb.wikimedia.org/wikipedia/commons/thumb/3/3a/Deutschlandfunk_Kultur_Logo_klein.png/500px-Deutschlandfunk_Kultur_Logo_klein.png"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--dlf-nova-visual-url
  "https://thumb.wikimedia.org/wikipedia/commons/thumb/6/6f/Deutschlandfunk_Nova_Logo_klein.png/500px-Deutschlandfunk_Nova_Logo_klein.png"
  "Template used to retrieve the artwork image for the presentation views.")

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

(defconst radio-f--wdr-level-one ;; AAC, 192kbps
  "https://wdr-radio.ard-mcdn.de/wdr/radio/<<id>>/hls/master.m3u8"
  "Template used to return a level four audio stream for playback.")

(defconst radio-f--wdr-level-two ;; Opus, 24kbps
  "https://wdr-<<id>>-live.icecast.wdr.de/wdr/<<id>>/live/mp3/128/stream.mp3"
  "Template used to return a level four audio stream for playback.")

;; https://wdr-wdr3-live.icecastssl.wdr.de/wdr/wdr3/live/mp3/256/stream.mp3

;; == STREAM LEVELS =====

(defconst radio-f--bremen-streams
  `((One     . ,radio-f--bremen-level-one)
    (Two     . ,radio-f--bremen-level-two)
    (default . ,radio-f--bremen-level-one))
  "Audio stream templates provided by Radio Bremen.")

(defconst radio-f--wdr-streams
  `((One     . ,radio-f--wdr-level-one)
    (Two     . ,radio-f--wdr-level-two)
    (default . ,radio-f--wdr-level-one))
  "Audio stream templates provided by Westdeutscher Rundfunk.")

(defconst radio-f--ard-stream-providers
  '((bremen . radio-f--bremen-streams)
    (wdr    . radio-f--wdr-streams)))

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-ard-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--ard-api-url
          (symbol-value api))))

(defun radio-f--set-ard-streams ()
  (let* ((station (radio-f--get-current-station-data))
         (stream (plist-get station :stream))
         (streams-symbol
          (cdr (assq stream radio-f--ard-stream-providers))))
    (setq radio-f--ard-streams
          (symbol-value streams-symbol))))

(defun radio-f--extract-dlf-json (data)
  "Extract Deutschlandfunk JSON from HTML DATA."
  (when (string-match
         "class=\"js-client-queries\"[^>]+data-json=\"\\([^\"]+\\)\""
         data)
    (replace-regexp-in-string
     "&quot;" "\""
     (match-string 1 data))))


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

(provide 'radio-f-ard)

;;; radio-f-ard.el ends here
