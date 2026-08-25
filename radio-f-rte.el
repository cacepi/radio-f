;; radio-f-rte.el --- RTÈ plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sat 22 Aug 26
;; Keywords: streaming, radio, Ireland

;; This file is NOT part of Emacs.

;;; Commentary:

;; RTÈ Plugin for Radio F. 5 stations.

;;; Code:

(defconst radio-f--rte-hls "https://www.rte.ie/manifests/[id].m3u8"
     "Template used to generate the URL for RTÉ audio streaming.")

(defconst radio-f--rte-aac "https://icecast1.rte.ie/[id]"
    "Template used to generate the URL for RTÉ audio streaming.")

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
  `((hls     . ,radio-f--rte-hls)
    (aac     . ,radio-f--rte-aac)
    (default . ,radio-f--rte-hls))
  "Audio stream templates provided by RTÉ.")

(defconst radio-f--rte-stations
  '((radio1
     :name "RTE Radio 1" :provider rte :id "radio1"
     :tag "rteradio1" :channel "9" :www "radio1")
    (2fm
     :name "RTE 2FM" :provider rte :metadata rte :id "2fm"
     :tag "rte2fm" :channel "1" :www "2fm")
    (rnag
     :name "RTE Raidió na Gaeltachta" :provider rte :metadata rte :id "rnag"
     :tag "rteraidionagaeltachta" :channel "17" :www "rnag")
    (lyricfm
     :name "RTE Lyric FM" :provider rte :metadata rte :id "lyric"
     :tag "rtelyricfm" :channel "16" :www "lyricfm")
    (gold
     :name "RTE Gold" :provider rte :metadata rte :id "gold"
     :tag "rtegold" :channel "22" :www "gold"))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

(provide 'radio-f-rte)
