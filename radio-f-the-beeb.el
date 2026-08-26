;; radio-f-the-beeb.el --- BBC plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Thu 20 Aug 26
;; Keywords: hypermedia, network, streaming, radio, BBC

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
;; BBC Plugin for Radio F.
;; 71 stations.  God Save The King.



;;; Code:

(defconst radio-f--the-beeb-api-url "https://rms.api.bbc.co.uk/v2/broadcasts/poll/[id]"
  "Recipe used to retrieve JSON data from the BBC.")

(defconst radio-f--the-beeb-high "https://lsn.lv/bbcradio.m3u8?station=[id]&bitrate=320000"
  "Template used to generate the URL for BBC high bitrate audio streaming.")

(defconst radio-f--the-beeb-low "https://lsn.lv/bbcradio.m3u8?station=[id]&bitrate=96000"
  "Template used to generate the URL for BBC low bitrate audio streaming.")

(defconst radio-f--the-beeb-url "https://www.bbc.co.uk/sounds/play/live/[id]/"
  "Template used to generate the URL for BBC station home pages.")

(defconst radio-f--the-beeb-streams
  `((hls     . ,radio-f--the-beeb-high)
    (aac     . ,radio-f--the-beeb-low)
    (default . ,radio-f--the-beeb-low))
  "Audio stream templates provided by the BBC.")

;; A little commentary here:
;; Look at this plist.  The *only* value the BBC needs to find
;; *every single thing* across several JSON schema, audio streams,
;; and its web pages for individual stations is thar :id key.  Need
;; the web site for a station?  Put :id here.  Need the low bitrate
;; stream?  Put :id there.  That's how you build ana API. Very
;; simple, very efficient, very... actually, I don't know if The Beeb
;; does "demure."

(defconst radio-f--the-beeb-stations
  '((radio-one
     :name "BBC Radio One" :id "bbc_radio_one" :provider bbc :metadata bbc)
    (radio-one-anthems
     :name "BBC Radio One Anthems" :id "bbc_radio_one_anthems" :provider bbc :metadata bbc)
    (radio-one-dance
     :name "BBC Radio One Dance" :id "bbc_radio_one_dance" :provider bbc :metadata bbc)
    (radio-one-extra
     :name "BBC Radio One Extra" :id "bbc_1xtra" :provider bbc :metadata bbc)
    (radio-two
     :name "BBC Radio Two" :id "bbc_radio_two" :provider bbc :metadata bbc)
    (radio-three
     :name "BBC Radio Three" :id "bbc_radio_three" :provider bbc :metadata bbc)
    (three-unwind
     :name "BBC Radio Three Unwind" :id "bbc_radio_three_unwind" :provider bbc :metadata bbc)
    (four-fm
     :name "BBC Radio Four FM" :id "bbc_radio_fourfm" :provider bbc :metadata bbc)
    (four-extra
     :name "BBC Radio Four Extra" :id "bbc_radio_four_extra" :provider bbc :metadata bbc)
    (five-live
     :name "BBC Radio Five Live" :id "bbc_radio_five_live" :provider bbc :metadata bbc)
    (six-music
     :name "BBC Radio Six Music" :id "bbc_6music" :provider bbc :metadata bbc)
    (asian-network
     :name "BBC Asian Network" :id "bbc_asian_network" :provider bbc :metadata bbc)
    (world-service
     :name "BBC World Service" :id "bbc_world_service" :provider bbc :metadata bbc)
    (radio-scotland
     :name "BBC Radio Scotland" :id "bbc_radio_scotland_fm" :provider bbc :metadata bbc)
    (radio-scotland-extra
     :name "BBC Radio Scotland Extra" :id "bbc_radio_scotland_mw" :provider bbc :metadata bbc)
    (orkney
     :name "BBC Orkney" :id "bbc_radio_orkney" :provider bbc :metadata bbc)
    (shetland
     :name "BBC Shetland" :id "bbc_radio_shetland" :provider bbc :metadata bbc)
    (foyle
     :name "BBC Foyle" :id "bbc_radio_foyle" :provider bbc :metadata bbc)
    (ulster
     :name "BBC Ulster" :id "bbc_radio_ulster" :provider bbc :metadata bbc)
    (nan-gaidheal
     :name "BBC Radio nan Gàidheal" :id "bbc_radio_nan_gaidheal" :provider bbc :metadata bbc)
    ;; UK exclusive stations.
    (sports-extra
     :name "BBC Radio Five Live Sports Extra" :id "bbc_radio_five_live_sports_extra" :provider bbc :metadata bbc)
    (sports-extra-2
     :name "BBC Radio Five Sports Extra 2" :id "bbc_radio_five_sports_extra_2" :provider bbc :metadata bbc)
    (sports-extra-3
     :name "BBC Radio Five Sports Extra 3" :id "bbc_radio_five_sports_extra_3" :provider bbc :metadata bbc)
    (cbeebies-radio
     :name "CBeebies Radio" :id "cbeebies_radio" :provider bbc :metadata bbc)
    (six-indie-forever
     :name "BBC Radio Six Indie Forever" :id "bbc_six_indie_forever" :provider bbc :metadata bbc)
    (sounds-news
     :name "BBC Sounds News" :id "bbc_sounds_news" :provider bbc :metadata bbc)
    ;; The BBC doesn't want the world to learn Welsh.
    (wales-extra
     :name "BBC Radio Wales Extra" :id "bbc_radio_wales_am" :provider bbc :metadata bbc)
    (radio-wales
     :name "BBC Radio Wales" :id "bbc_radio_wales_fm" :provider bbc :metadata bbc)
    (cymru
     :name "BBC Cymru" :id "bbc_radio_cymru" :provider bbc :metadata bbc)
    (cymru-2
     :name "BBC Cymru 2" :id "bbc_radio_cymru_2" :provider bbc :metadata bbc)
    ;; Local stations
    (berkshire
     :name "BBC Berkshire" :id "bbc_radio_berkshire" :provider bbc :metadata bbc)
    (bristol
     :name "BBC Bristol" :id "bbc_radio_bristol" :provider bbc :metadata bbc)
    (cambridge
     :name "BBC Cambridge" :id "bbc_radio_cambridge" :provider bbc :metadata bbc)
    (cornwall
     :name "BBC Cornwall" :id "bbc_radio_cornwall" :provider bbc :metadata bbc)
    (coventry
     :name "BBC Coventry Warwickshire" :id "bbc_radio_coventry_warwickshire" :provider bbc :metadata bbc)
    (cumbria
     :name "BBC Cumbria" :id "bbc_radio_cumbria" :provider bbc :metadata bbc)
    (derby
     :name "BBC Derby" :id "bbc_radio_derby" :provider bbc :metadata bbc)
    (devon
     :name "BBC Devon" :id "bbc_radio_devon" :provider bbc :metadata bbc)
    (essex
     :name "BBC Essex" :id "bbc_radio_essex" :provider bbc :metadata bbc)
    (gloucester
     :name "BBC Gloucestershire" :id "bbc_radio_gloucestershire" :provider bbc :metadata bbc)
    (guernsey
     :name "BBC Guernsey" :id "bbc_radio_guernsey" :provider bbc :metadata bbc)
    (hereford
     :name "BBC Hereford Worcester" :id "bbc_radio_hereford_worcester" :provider bbc :metadata bbc)
    (humberside
     :name "BBC Humberside" :id "bbc_radio_humberside" :provider bbc :metadata bbc)
    (jersey
     :name "BBC Jersey" :id "bbc_radio_jersey" :provider bbc :metadata bbc)
    (kent
     :name "BBC Kent" :id "bbc_radio_kent" :provider bbc :metadata bbc)
    (lancashire
     :name "BBC Lancashire" :id "bbc_radio_lancashire" :provider bbc :metadata bbc)
    (leeds
     :name "BBC Leeds" :id "bbc_radio_leeds" :provider bbc :metadata bbc)
    (leicester
     :name "BBC Leicster" :id "bbc_radio_leicester" :provider bbc :metadata bbc)
    (lincolnshire
     :name "BBC Lincolnshire" :id "bbc_radio_lincolnshire" :provider bbc :metadata bbc)
    (london
     :name "BBC London" :id "bbc_london" :provider bbc :metadata bbc)
    (manchester
     :name "BBC Manchester" :id "bbc_radio_manchester" :provider bbc :metadata bbc)
    (merseyside
     :name "BBC Merseyside" :id "bbc_radio_merseyside" :provider bbc :metadata bbc)
    (newcastle
     :name "BBC Newcastle" :id "bbc_radio_newcastle" :provider bbc :metadata bbc)
    (norfolk
     :name "BBC Norfolk" :id "bbc_radio_norfolk" :provider bbc :metadata bbc)
    (northampton
     :name "BBC Northampton" :id "bbc_radio_northampton" :provider bbc :metadata bbc)
    (nottingham
     :name "BBC Nottingham" :id "bbc_radio_nottingham" :provider bbc :metadata bbc)
    (oxford
     :name "BBC Oxford" :id "bbc_radio_oxford" :provider bbc :metadata bbc)
    (sheffield
     :name "BBC Sheffield" :id "bbc_radio_sheffield" :provider bbc :metadata bbc)
    (shropshire
     :name "BBC Shropshire" :id "bbc_radio_shropshire" :provider bbc :metadata bbc)
    (solent
     :name "BBC Solent" :id "bbc_radio_solent" :provider bbc :metadata bbc)
    (solent-west-dorset
     :name "BBC Solent West Dorset" :id "bbc_radio_solent_west_dorset" :provider bbc :metadata bbc)
    (somerset-sound
     :name "BBC Somerset Sound" :id "bbc_radio_somerset_sound" :provider bbc :metadata bbc)
    (stoke
     :name "BBC Stoke" :id "bbc_radio_stoke" :provider bbc :metadata bbc)
    (suffolk
     :name "BBC Suffolk" :id "bbc_radio_suffolk" :provider bbc :metadata bbc)
    (surrey
     :name "BBC Surrey" :id "bbc_radio_surrey" :provider bbc :metadata bbc)
    (sussex
     :name "BBC Sussex" :id "bbc_radio_sussex" :provider bbc :metadata bbc)
    (tees
     :name "BBC Tees" :id "bbc_tees" :provider bbc :metadata bbc)
    (three-counties
     :name "BBC Three Counties Radio" :id "bbc_three_counties_radio" :provider bbc :metadata bbc)
    (wiltshire
     :name "BBC Wiltshire" :id "bbc_radio_wiltshire" :provider bbc :metadata bbc)
    (bbc-wm
     :name "BBC WM" :id "bbc_wm" :provider bbc :metadata bbc)
    (york
     :name "BBC York" :id "bbc_radio_york" :provider bbc :metadata bbc)))

(provide 'radio-f-the-beeb)
