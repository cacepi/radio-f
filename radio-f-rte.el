;; radio-f-rte.el --- RTÈ plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sat 22 Aug 26
;; Keywords: hypermedia, network, streaming, radio, RTÉ

;; This file is NOT part of Emacs.

;;; Commentary:

;; RTÈ plugin for Radio F.
;; 5 stations.

;;; Code:

(defconst radio-f--rte-hls "https://www.rte.ie/manifests/[id].m3u8"
     "Template used to return a level one stream for playback.")

(defconst radio-f--rte-aac "https://icecast1.rte.ie/[id]"
    "Template used to return a level two stream for playback.")

(defconst radio-f--rte-api-url
  "https://www.rte.ie/feeds/livelistings/playlist/?source=rte.ie&platform=iphone&channelid=[channel]"
  "Template used to retrieve live listings JSON from RTÉ.")

(defconst radio-f--rte-url "https://www.rte.ie/radio/[www]/"
  "Template used to return a station's URL on the RTÉ web site.")

;; (defconst radio-f-rte-api-url "https://onair.radioapi.io/rte/[tag]/onair.json"
;;   "Template used to retrieve JSON data from RTÉ.")

;; (defconst ratio-f--rte-schedule-url "https://www.rte.ie/radio/[id]/schedule/[yyyymmdd]/"
;;   "Template used to retrieve daily schedule JSON data from RTÉ.")

(defconst radio-f--rte-streams
  `((one     . ,radio-f--rte-hls)
    (two     . ,radio-f--rte-aac)
    (default . ,radio-f--rte-hls))
  "Audio stream templates provided by RTÉ.")

(defconst radio-f--rte-stations
  '((radio1
     :name "RTÉ Radio 1" :provider rte :metadata rte
     :id "radio1" :tag "rteradio1" :channel "9"
     :www "radio1")
    (2fm
     :name "RTÉ 2FM" :provider rte :metadata rte
     :id "2fm" :tag "rte2fm" :channel "1" :www "2fm")
    (rnag
     :name "RTÉ Raidió na Gaeltachta" :provider rte
     :metadata rte :id "rnag" :tag "rteraidionagaeltachta"
     :channel "17" :www "rnag")
    (lyricfm
     :name "RTÉ Lyric FM" :provider rte :metadata rte
     :id "lyric" :tag "rtelyricfm" :channel "16"
     :www "lyricfm")
    (gold
     :name "RTÉ Gold" :provider rte :metadata rte
     :id "gold" :tag "rtegold" :channel "22"
     :www "gold"))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

(provide 'radio-f-rte)

;;; radio-f-rte.el ends here
