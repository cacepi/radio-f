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
;; ARD plugin for Radio F.
;; 3 stations form Deutschland Radio ATM.
;; "Dokumente und Debatten," the 4th station, is unavailable.
;;
;; Deutschland Radio has not one, not two, not three, not four,
;; but SIX different streams on offer.  SIX.  Two of them are
;; Opus streams(!). And they're listed right there on the web page:
;;
;; "Die Opus Audiokompression ist die Weiterentwicklung des
;; Vorbis-Formats. Opus ermöglicht bei besonders niedrigen
;; Datenraten Streams in akzeptabler bis guter Qualität. Das
;; lizenzfreie und offen dokumentierte Datenformat kann nativ
;; auf neueren Android Geräten (ab Android 5) und den meisten
;; Browsern problemlos abgespielt werden. Safari und der Internet
;; Explorer sind aktuell nicht in der Lage, Opus Dateien zu
;; verstehen. Passende Abspielsoftware gibt es für alle verbreiteten
;; Betriebssysteme wie Windows, macOS, und GNU/Linux."
;;
;; "Opus audio compression is a further development of the Vorbis
;; format. Opus enables streams of acceptable to good quality at
;; particularly low data rates. The royalty-free and openly
;; documented data format can be played natively on newer Android
;; devices (from Android 5 onwards) and most browsers without any
;; problems. Safari and Internet Explorer are currently unable to
;; understand Opus files. Suitable playback software is available
;; for all common operating systems such as Windows, macOS, and
;; GNU/Linux."
;;
;; How about that! Give to German Public Radio for being even
;; more punctilious than the BBC.
;;
;; Radio F only uses four out of the six streams available; any more
;; than that four would probably induce option anxiety.



;;; Code:

(defconst radio-f--dlf-api-url
  "https://www.deutschlandfunk.de/api/partials/CurrentBroadcast?dlrsearch:_ajax=1"
    "URL to AJAX data from Deutschlandfunk.")

(defconst radio-f--dlf-kultur-api-url
  "https://www.deutschlandfunkkultur.de/api/partials/CurrentBroadcast?dlrsearch:_ajax=1"
  "URL to AJAX data from Deutschlandfunk Kultur.")

(defconst radio-f--dlf-nova-api-url
  "https://static.deutschlandfunknova.de/actions/dradio/playlist/onair"
  "Template used to retrieve JSON data from Deutschlandfunk Nova.")

(defconst radio-f--dlf-url
  "https://www.deutschland[tag].de"
  "Template used to return the Deutschland Funk station URL on the Deutschland Radio web site.")

(defconst radio-f--dlf-kultur-url
  "https://www.deutschland[tag].de"
    "Template used to return the Deutschland Funk Kultur station URL on the Deutschland Radio web site.")

(defconst radio-f--dlf-nova-url
  "https://www.deutschland[tag].de"
  "Template used to return the Deutschland Funk Nova station URL on the Deutschland Radio web site.")

(defconst radio-f--dlf-visual-url
"https://thumb.wikimedia.org/wikipedia/commons/thumb/5/53/Deutschlandfunk_Logo_klein.png/500px-Deutschlandfunk_Logo_klein.png"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--dlf-kultur-visual-url
  "https://thumb.wikimedia.org/wikipedia/commons/thumb/3/3a/Deutschlandfunk_Kultur_Logo_klein.png/500px-Deutschlandfunk_Kultur_Logo_klein.png"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--br-api-url
  "https://brradio.br.de/radio/v4?query=query+broadcastService($stationSlug:String!){audioBroadcastService(slug:$stationSlug){...on+AudioBroadcastService{id+dvbServiceId+name+slug+fallbackTeaserImage{url}trackingInfos{pageVars+mediaVars}...on+MangoBroadcastService{webcamUrls...jumpMarkers}epg(slots:[CURRENT]){broadcastEvent{trackingInfos{pageVars+mediaVars}...eventStartEnd+items{...audioElement...on+NewsElement{author}...on+MusicElement{performer+composer}}excludedTimeRanges{start+end}publicationOf{...eventMetadata+defaultTeaserImage{url}...on+MangoProgramme{canonicalUrl+title+kicker}}}}description+url}}}fragment+eventMetadata+on+MangoCreativeWorkInterface{id+kicker+title+description}fragment+jumpMarkers+on+MangoBroadcastService{lastNewsDate+lastTrafficDate+lastWeatherDate}fragment+audioElement+on+AudioElement{guid+title+class+start+duration}fragment+eventStartEnd+on+MangoBroadcastEvent{id+start+end}&variables[stationSlug]=[id]"
  "Template used to retrieve JSON data from Bayerischen Rundfunks.")

(defconst radio-f--br-level-one ;; AAC, 192kbps
"https://br-radio.ard-mcdn.de/br/radio/[br-level-1-stream-id]/hls/master.m3u8"
  "Template used to return a level one audio stream for playback.")

(defconst radio-f--br-level-two ;; MP3, 128/256kbps
"https://dispatcher.rndfnk.com/br/[l2-stream-id]/live/mp3/[l2-bitrate]/stream.mp3"
  "Template used to return a level one audio stream for playback.")

(defconst radio-f--dlf-level-one ;; AAC, 192kbps
  "https://st[id].sslstream.dlf.de/dlf/[id]/high/aac/stream.aac"
  "Template used to return a level one audio stream for playback.")

(defconst radio-f--dlf-level-two ;; AAC, 96kbps
  "https://st[id].sslstream.dlf.de/dlf/[id]/mid/aac/stream.aac"
  "Template used to return a level two stream for playback.")

(defconst radio-f--dlf-level-three ;; Opus, 64kbps
  "https://st[id].sslstream.dlf.de/dlf/[id]/high/opus/stream.opus"
  "Template used to return a level three audio stream for playback.")

(defconst radio-f--dlf-level-four ;; Opus, 24kbps
  "https://st[id].sslstream.dlf.de/dlf/[id]/low/opus/stream.opus"
  "Template used to return a level four audio stream for playback.")

(defconst radio-f--br-streams
  `((One . ,radio-f--br-level-one)
    (Two . ,radio-f--br-level-two)
    (default . ,radio-f--br-level-one))
  "Audio stream templates provided by Bayerischer Rundfunks.")

(defconst radio-f--dlf-streams
  `((One     . ,radio-f--dlf-level-one)
    (Two     . ,radio-f--dlf-level-two)
    (Three   . ,radio-f--dlf-level-three)
    (Four    . ,radio-f--dlf-level-four)
    (default . ,radio-f--dlf-level-one))
  "Audio stream templates provided by Deutschland Radio.")

(defconst radio-f--ard-stream-providers
  '((br  . radio-f--br-streams)
    (dlf . radio-f--dlf-streams)))

(defconst radio-f--ard-stations
  '((dlf
     :name "Deutschlandfunk" :plugin ard :metadata dlf :id "01"
     :stream dlf :tag "funk" :raw t
     :api radio-f--dlf-api-url
     :processor radio-f--dlf-processor
     :www radio-f--dlf-url
     :visual radio-f--dlf-visual-url)
    (dlf-kultur
     :name "Deutschlandfunk Kultur" :plugin ard :metadata dlf-kultur :id "02"
     :stream dlf :tag "funkkultur" :raw t
     :api radio-f--dlf-kultur-api-url
     :processor radio-f--dlf-processor
     :www radio-f--dlf-kultur-url
     :visual radio-f--dlf-kultur-visual-url)
    (dlf-nova
     :name "Deutschlandfunk Nova" :plugin ard :metadata dlf-nova :id "03"
     :stream dlf :tag "funknova" :api radio-f--dlf-nova-api-url
     :processor radio-f--dlf-nova-processor
     :www radio-f--dlf-nova-url)
    (bayern1 ;; b1schw, b1franken, b1nbopf, b1main
     :name "Bayern 1" :plugin ard :metadata br :id "bayern1" :stream br
     :br-level-1-stream-id "b1obb" :l2-stream-id "br1/obb" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (bayern2
     :name "Bayern 2" :plugin ard :metadata br :id "bayern2" :stream br
     :br-level-1-stream-id "b2" :l2-stream-id "br2" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (bayern3
     :name "Bayern 3" :plugin ard :metadata br :id "bayern3" :stream br
     :br-level-1-stream-id "b3" :l2-stream-id "br3" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br24
     :name "BR 24" :plugin ard :metadata br :id "br24" :stream br
     :br-level-1-stream-id "b24" :l2-stream-id "br24" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-klassik
     :name "Bayern Klassik" :plugin ard :metadata br :id "br-klassik" :stream br
     :br-level-1-stream-id "brklassik" :l2-stream-id "brklassik" :l2-bitrate "256"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-schlager
     :name "Bayern Schlager" :plugin ard :metadata br :id "br-schlager" :stream br
     :br-level-1-stream-id "brschlager" :l2-stream-id "brschlager" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor)
    (br-heimat
     :name "Bayern Heimat" :plugin ard :metadata br :id "br-heimat" :stream br
     :br-level-1-stream-id "brheimat" :l2-stream-id "brheimat" :l2-bitrate "128"
     :api radio-f--br-api-url :processor radio-f--br-processor))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

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

(defun radio-f--dlf-processor (data station)
  "Process Deutschlandfunk DATA for STATION."
  (let* ((json-object-type 'alist)
         (json-key-type 'string)
         (json-string (radio-f--extract-dlf-json data))
         (json (json-read-from-string json-string))
         (key (cdr (assoc "key" json)))
         (value (cdr (assoc "value" json)))
         (payload (cdr (assoc "data" value)))
         (now (cdr (assoc "currentBroadcast" payload)))
         (visual-url
          (symbol-value (plist-get station :visual)))
         (artist (cdr (assoc "producer" now)))
         (title (cdr (assoc "title" now)))
         (start (cdr (assoc "startTime" now)))
         (end (cdr (assoc "endTime" now)))
         ;; Deutschland Radio has no UUID for track/program
         ;; info, so we have to make our own.
         ;;
         ;; But don't worry, it's secure!
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

(defun radio-f--dlf-nova-processor (data station)
  "Process Deutschlandfunk Nova DATA for STATION."
  (let* ((now (cdr (assoc "PlaylistItem" data)))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start (cdr (assoc "startTime" now)))
         (end (cdr (assoc "endTime" now)))
         (visual-url (cdr (assoc "cover" now)))
         ;; Deutschland Radio does not have a UUID for JSON objects,
         ;; so we have to make our own.
         ;;
         ;; Don't worry, it's secure!
         (item-id
          (secure-hash
           'sha3-224
           (format "%s|%s|%s|%s" artist title start end))))
      ;; Fill in the returned values.  Postmaster takes it from there.
      `((item-id    . ,item-id)
        (artist     . ,artist)
        (title      . ,title)
        (start      . ,start)
        (end        . ,end)
        (visual-url . ,visual-url))))

(provide 'radio-f-ard)

;;; radio-f-ard.el ends here
