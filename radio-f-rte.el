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

(defconst radio-f--rte-level-one "https://www.rte.ie/manifests/[id].m3u8"
     "Template used to return a level one stream for playback.")

(defconst radio-f--rte-level-two "https://icecast1.rte.ie/[id]"
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
  `((One     . ,radio-f--rte-level-one)
    (Two     . ,radio-f--rte-level-two)
    (default . ,radio-f--rte-level-two))
  "Audio stream templates provided by RTÉ.")

(defconst radio-f--rte-stations
  '((radio1
     :name "RTÉ Radio 1" :id "radio1" :tag "rteradio1"
     :channel "9" :www "radio1"
     :plugin rte :metadata rte
     :processor radio-f--rte-processor)
    (2fm
     :name "RTÉ 2FM" :id "2fm" :tag "rte2fm"
     :channel "1" :www "2fm"
     :plugin rte :metadata rte
     :processor radio-f--rte-processor)
    (rnag
     :name "RTÉ Raidió na Gaeltachta" :id "rnag" :tag "rteraidionagaeltachta"
     :channel "17" :www "rnag"
     :plugin rte :metadata rte
     :processor radio-f--rte-processor)
    (lyricfm
     :name "RTÉ Lyric FM" :id "lyric" :tag "rtelyricfm"
     :channel "16" :www "lyricfm"
     :plugin rte :metadata rte
     :processor radio-f--rte-processor)
    (gold
     :name "RTÉ Gold" :id "gold" :tag "rtegold"
     :channel "22" :www "gold"
     :plugin rte :metadata rte
     :processor radio-f--rte-processor))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")



(defun radio-f--rte-processor (data station)
  (let* ((now (aref data 0)))
    `((item-id    . ,(cdr (assoc "listingId" now)))
      (artist     . ,(cdr (assoc "channel" now)))
      (title      . ,(cdr (assoc "progName" now)))
      (start      . ,(float-time
                      (date-to-time (cdr (assoc "progDate" now)))))
      (end        . ,(cdr (assoc "endDate_ts" now)))
      (visual-url . ,(cdr (assoc "thumbnail" now))))))



(provide 'radio-f-rte)

;;; radio-f-rte.el ends here
