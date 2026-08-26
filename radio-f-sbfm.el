;; radio-f-sbfm.el --- Shonan Beach FM plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Mon 24 Aug 26
;; Keywords: hypermedia, network, streaming, radio, Japan

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
;; Shonan Beach FM is a small, community owned Japanese station
;; in Kanagawa Prefecture.  Jazz format (thumbs up) with a
;; text-to-speech news reader.  As a small station, it has a
;; "seat of the pants" feel to it that I just love.  I imagine
;; pirate radio from a ship in the North Sea during the '60s
;; sounded like this.  Single mp3 stream.



;;; Code:

(defconst radio-f--sbfm-mp3 "https://shonanbeachfm.out.airtime.pro:8000/shonanbeachfm_a"
    "Template used to generate the URL for Shonan Beach FM audio streaming.")

(defconst radio-f--sbfm-api-url
  "https://www.beachfm.co.jp/wp-content/uploads/now_play.json"
  "Template used to retrieve live listings JSON from Shonan Beach FM.")

(defconst radio-f--sbfm-url "https://www.beachfm.co.jp/"
  "Template used to return a station's URL on the Shonan Beach FM web site.")

(defconst radio-f--sbfm-streams
  `((mp3     . ,radio-f--sbfm-mp3)
    (default . ,radio-f--sbfm-mp3))
  "Audio stream templates provided by Shonan Beach FM.")

(defconst radio-f--sbfm-stations
  '((sbfm
     :name "Shonan Beach FM" :provider sbfm :metadata sbfm))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

(provide 'radio-f-sbfm)

;;; radio-f-sbfm.el ends here
