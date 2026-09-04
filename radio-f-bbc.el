;; radio-f-bbc.el --- BBC plugin for Radio F -*- lexical-binding: t; -*-

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

(defconst radio-f--bbc-api-url "https://rms.api.bbc.co.uk/v2/broadcasts/poll/[id]"
  "Recipe used to retrieve JSON data from the BBC.")

(defconst radio-f--bbc-level-one "https://lsn.lv/bbcradio.m3u8?station=[id]&bitrate=320000"
  "Template used to return a level one stream for playback.")

(defconst radio-f--bbc-level-two "https://lsn.lv/bbcradio.m3u8?station=[id]&bitrate=96000"
  "Template used to return a level two stream for playback.")

(defconst radio-f--bbc-url "https://www.bbc.co.uk/sounds/play/live/[id]/"
  "Template used to generate the URL for BBC station home pages.")

(defconst radio-f--bbc-streams
  `((One     . ,radio-f--bbc-level-one)
    (Two     . ,radio-f--bbc-level-two)
    (Default . ,radio-f--bbc-level-one))
  "Audio stream templates provided by the BBC.")

;; A little commentary here:
;; Look at this plist.  The *only* value the BBC needs to find
;; *every single thing* across several JSON schema, audio streams,
;; and its web pages for individual stations is thar :id key.  Need
;; the web site for a station?  Put :id here.  Need the low bitrate
;; stream?  Put :id there.  That's how you build an API. Very
;; simple, very efficient, very... actually, I don't know if The Beeb
;; does "demure."

(defconst radio-f--bbc-stations
  '((radio-one
     :name "BBC Radio One" :id "bbc_radio_one"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-one-anthems
     :name "BBC Radio One Anthems" :id "bbc_radio_one_anthems"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-one-dance
     :name "BBC Radio One Dance" :id "bbc_radio_one_dance"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-one-extra
     :name "BBC Radio One Extra" :id "bbc_1xtra"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-two
     :name "BBC Radio Two" :id "bbc_radio_two"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-three
     :name "BBC Radio Three" :id "bbc_radio_three"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (three-unwind
     :name "BBC Radio Three Unwind" :id "bbc_radio_three_unwind"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (four-fm
     :name "BBC Radio Four FM" :id "bbc_radio_fourfm"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (four-extra
     :name "BBC Radio Four Extra" :id "bbc_radio_four_extra"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (five-live
     :name "BBC Radio Five Live" :id "bbc_radio_five_live"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (six-music
     :name "BBC Radio Six Music" :id "bbc_6music"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (asian-network
     :name "BBC Asian Network" :id "bbc_asian_network"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (world-service
     :name "BBC World Service" :id "bbc_world_service"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-scotland
     :name "BBC Radio Scotland" :id "bbc_radio_scotland_fm"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-scotland-extra
     :name "BBC Radio Scotland Extra" :id "bbc_radio_scotland_mw"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (orkney
     :name "BBC Orkney" :id "bbc_radio_orkney"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (shetland
     :name "BBC Shetland" :id "bbc_radio_shetland"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (foyle
     :name "BBC Foyle" :id "bbc_radio_foyle"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (ulster
     :name "BBC Ulster" :id "bbc_radio_ulster"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (nan-gaidheal
     :name "BBC Radio nan Gàidheal" :id "bbc_radio_nan_gaidheal"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    ;; UK exclusive stations.
    (sports-extra
     :name "BBC Radio Five Live Sports Extra"
     :id "bbc_radio_five_live_sports_extra"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (sports-extra-2
     :name "BBC Radio Five Sports Extra 2"
     :id "bbc_radio_five_sports_extra_2"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (sports-extra-3
     :name "BBC Radio Five Sports Extra 3"
     :id "bbc_radio_five_sports_extra_3"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cbeebies-radio
     :name "CBeebies Radio" :id "cbeebies_radio"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (six-indie-forever
     :name "BBC Radio Six Indie Forever" :id "bbc_six_indie_forever"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (sounds-news
     :name "BBC Sounds News" :id "bbc_sounds_news"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    ;; The BBC doesn't want the world to learn Welsh.
    (wales-extra
     :name "BBC Radio Wales Extra" :id "bbc_radio_wales_am"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (radio-wales
     :name "BBC Radio Wales" :id "bbc_radio_wales_fm"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cymru
     :name "BBC Cymru" :id "bbc_radio_cymru"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cymru-2
     :name "BBC Cymru 2" :id "bbc_radio_cymru_2"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    ;; Local stations
    (berkshire
     :name "BBC Berkshire" :id "bbc_radio_berkshire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (bristol
     :name "BBC Bristol" :id "bbc_radio_bristol"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cambridge
     :name "BBC Cambridge" :id "bbc_radio_cambridge"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cornwall
     :name "BBC Cornwall" :id "bbc_radio_cornwall"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (coventry
     :name "BBC Coventry Warwickshire"
     :id "bbc_radio_coventry_warwickshire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (cumbria
     :name "BBC Cumbria" :id "bbc_radio_cumbria"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (derby
     :name "BBC Derby" :id "bbc_radio_derby"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (devon
     :name "BBC Devon" :id "bbc_radio_devon"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (essex
     :name "BBC Essex" :id "bbc_radio_essex"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (gloucester
     :name "BBC Gloucestershire" :id "bbc_radio_gloucestershire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (guernsey
     :name "BBC Guernsey" :id "bbc_radio_guernsey"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (hereford
     :name "BBC Hereford Worcester"
     :id "bbc_radio_hereford_worcester"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (humberside
     :name "BBC Humberside" :id "bbc_radio_humberside"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (jersey
     :name "BBC Jersey" :id "bbc_radio_jersey"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (kent
     :name "BBC Kent" :id "bbc_radio_kent"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (lancashire
     :name "BBC Lancashire" :id "bbc_radio_lancashire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (leeds
     :name "BBC Leeds" :id "bbc_radio_leeds"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (leicester
     :name "BBC Leicster" :id "bbc_radio_leicester"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (lincolnshire
     :name "BBC Lincolnshire" :id "bbc_radio_lincolnshire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (london
     :name "BBC London" :id "bbc_london"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (manchester
     :name "BBC Manchester" :id "bbc_radio_manchester"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (merseyside
     :name "BBC Merseyside" :id "bbc_radio_merseyside"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (newcastle
     :name "BBC Newcastle" :id "bbc_radio_newcastle"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (norfolk
     :name "BBC Norfolk" :id "bbc_radio_norfolk"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (northampton
     :name "BBC Northampton" :id "bbc_radio_northampton"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (nottingham
     :name "BBC Nottingham" :id "bbc_radio_nottingham"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (oxford
     :name "BBC Oxford" :id "bbc_radio_oxford"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (sheffield
     :name "BBC Sheffield" :id "bbc_radio_sheffield"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (shropshire
     :name "BBC Shropshire" :id "bbc_radio_shropshire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (solent
     :name "BBC Solent" :id "bbc_radio_solent"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (solent-west-dorset
     :name "BBC Solent West Dorset" :id "bbc_radio_solent_west_dorset"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (somerset-sound
     :name "BBC Somerset Sound" :id "bbc_radio_somerset_sound"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (stoke
     :name "BBC Stoke" :id "bbc_radio_stoke"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (suffolk
     :name "BBC Suffolk" :id "bbc_radio_suffolk"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (surrey
     :name "BBC Surrey" :id "bbc_radio_surrey"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (sussex
     :name "BBC Sussex" :id "bbc_radio_sussex"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (tees
     :name "BBC Tees" :id "bbc_tees"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (three-counties
     :name "BBC Three Counties Radio" :id "bbc_three_counties_radio"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (wiltshire
     :name "BBC Wiltshire" :id "bbc_radio_wiltshire"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (bbc-wm
     :name "BBC WM" :id "bbc_wm"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)
    (york
     :name "BBC York" :id "bbc_radio_york"
     :plugin bbc :metadata bbc
     :processor radio-f--bbc-processor)))

;; All processing for the Postmaster goes here.

(defun radio-f--bbc-processor (data station)
  (let* ((broadcasts (cdr (assoc "data" data)))
         (current-time (float-time))
         (now
          (seq-find
           (lambda (broadcast)
             (let ((start
                    (float-time
                     (date-to-time
                      (cdr (assoc "start" broadcast)))))
                   (end
                    (float-time
                     (date-to-time
                      (cdr (assoc "end" broadcast))))))
               (and (<= start current-time)
                    (< current-time end))))
           broadcasts))
         (network (cdr (assoc "network" now)))
         (titles (cdr (assoc "titles" now)))
         (image-url (cdr (assoc "image_url" now))))
    `((item-id . ,(cdr (assoc "id" now)))
      (artist . ,(cdr (assoc "short_title" network)))
      (title . ,(cdr (assoc "primary" titles)))
      (start . ,(float-time
                  (date-to-time
                   (cdr (assoc "start" now)))))
      (end . ,(float-time
                (date-to-time
                 (cdr (assoc "end" now)))))
      (visual-url
       . ,(and image-url
               (replace-regexp-in-string
                "{recipe}" "400x400" image-url t t))))))


(provide 'radio-f-bbc)
