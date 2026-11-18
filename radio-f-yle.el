;;; radio-f-yle.el --- YLE plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 27 Sep 26
;; Keywords: hypermedia, network, streaming, radio, Finland

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
;; Yle (Finland), 29 stations.
;;
;; Also includes a stream for the Ålands Radio Live. As this station is in
;; the Ålands semiautonomous region it legally it is not part of Yle. But
;; since 1) it is a public station "within" Finland, and 2) I don't want
;; to add another single station carrier, it goes here.
;;

;;; Code:


;; == STATION PLIST =====

(defconst radio-f--yle-stations
  '((yle-radio-1
     :name "Yle Radio 1" :carrier yle :id "yleradio1"
     :key "869" :l3 "YleRadio1" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-1.png")
    (yle-radio-suomi
     :name "Yle Radio Suomi" :carrier yle :id "ylers"
     :key "871" :l3 "YleRS" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi.png")
    (yle-radio-suomi-hameenlinna
     :name "Yle Radio Suomi Hämeenlinna" :carrier yle :id "ylers-hml"
     :key "879" :l3 "YleHML" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-hameenlinna.png")
    (yle-radio-suomi-joensuu
     :name "Yle Radio Suomi Joensuu" :carrier yle :id "ylers-joensuu"
     :key "880" :l3 "YleJoensuu"
     :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-joensuu.png")
    (yle-radio-suomi-jyvaskyla
     :name "Yle Radio Suomi Jyväskylä" :carrier yle :id "ylers-jkl"
     :key "881" :l3 "YleJKL" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-jyvaskyla.png")
    (yle-radio-suomi-kajaani
     :name "Yle Radio Suomi Kajaani" :carrier yle :id "yle-kajaani"
     :key "882" :l3 "YleKajaani" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-kajaani.png")
    (yle-radio-suomi-kokkola
     :name "Yle Radio Suomi Kokkola" :carrier yle :id "ylers-kokkola"
     :key "884" :l3 "YleKokkola" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-kokkola.png")
    (yle-radio-suomi-kotka
     :name "Yle Radio Suomi Kotka" :carrier yle :id "ylers-kotka"
     :key "885" :l3 "YleKotka" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-kotka.png")
    (yle-radio-suomi-kuopio
     :name "Yle Radio Suomi Kuopio" :carrier yle :id "ylers-kuopio"
     :key "886" :l3 "YleKuopio" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-kuopio.png")
    (yle-radio-suomi-lahti
     :name "Yle Radio Suomi Lahti" :carrier yle :id "yle-lahti"
     :key "887" :l3 "YleLahti" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-lahti.png")
    (yle-radio-suomi-lappeenranta
     :name "Yle Radio Suomi Lappeenranta" :carrier yle :id "yle-lpr"
     :key "888" :l3 "YleLpr" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-lappeenranta.png")
    (yle-radio-suomi-mikkeli
     :name "Yle Radio Suomi Mikkeli" :carrier yle :id "yle-mikkeli"
     :key "889" :l3 "YleMikkeli" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-mikkeli.png")
    (yle-radio-suomi-oulu
     :name "Yle Radio Suomi Oulu" :carrier yle :id "yle-oulu"
     :key "890" :l3 "YleOulu" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-oulu.png")
    (yle-radio-suomi-pori
     :name "Yle Radio Suomi Pori" :carrier yle :id "yle-pori"
     :key "891" :l3 "YlePori" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-pori.png")
    (yle-radio-suomi-rovaniemi
     :name "Yle Radio Suomi Rovaniemi" :carrier yle :id "yle-rovaniemi"
     :key "892" :l3 "YleRovaniemi" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-rovaniemi.png")
    (yle-radio-suomi-seinajoki
     :name "Yle Radio Suomi Seinäjoki" :carrier yle :id "yle-skl"
     :key "900" :l3 "YleSeinajoki" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-seinajoki.png")
    (yle-radio-suomi-tampere
     :name "Yle Radio Suomi Tampere" :carrier yle :id "yle-tampere"
     :key "893" :l3 "YleTampere" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-tampere.png")
    (yle-radio-suomi-turku
     :name "Yle Radio Suomi Turku" :carrier yle :id "yle-turku"
     :key "894" :l3 "YleTurku" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-tirku.png")
    (yle-radio-suomi-vaasa
     :name "Yle Radio Suomi Vaasa" :carrier yle :id "yle-vaasa"
     :key "901" :l3 "YleVaasa" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-radio-suomi-vaasa.png")
    (yle-ylex
     :name "Yle YleX" :carrier yle :id "ylex"
     :key "870" :l3 "YleX" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-ylex.png")
    (yle-klassinen
     :name "Yle Radio 1" :carrier yle :id "yleklassinen"
     :key "872" :l3 "YleKlassinen" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-klassinen.png")
    (yle-x3m
     :name "Yle X3M" :carrier yle :id "ylex3m"
     :key "877" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-x3m.png")
    (yle-vega-helsinki
     :name "Yle VEGA Huvudstadsregionen" :carrier yle :id "ylevega"
     :key "878" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-vega.png")
    (yle-vega-vastnyland
     :name "Yle VEGA Västnyland" :carrier yle :id "ylevega-vastnyland"
     :key "896" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-vega.png")
    (yle-vega-alboland
     :name "Yle VEGA Ålboland" :carrier yle :id "ylevega-alboland"
     :key "898" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-vega.png")
    (yle-vega-osterbotten
     :name "Yle VEGA Österbotten" :carrier yle :id "ylevega-osterbotten"
     :key "897" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-vega.png")
    (yle-vega-ostnyland
     :name "Yle VEGA Östnyland" :carrier yle :id "ylevega-ostnyland"
     :key "895" :l3 "YleX3M" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-vega.png")
    (yle-sami
     :name "Yle Sämi" :carrier yle :id "ylesami"
     :key "899" :l3 "YleSami" :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-stream-level-one
     :l2-stream radio-f--yle-stream-level-two
     :l3-stream radio-f--yle-stream-level-three
     :processor radio-f--yle-radio-processor
     :visual "assets/yle/yle-sami-radio.jpg")
    (yle-alands-radio-live
     :name "Ålands Radio Live" :carrier yle
     :api radio-f--yle-radio-api-url
     :l1-stream radio-f--yle-alands-stream-level-one
     :l2-stream nil :l3-stream nil :processor nil
     :visual "assets/yle/alands-radio-live.png"))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--yle-radio-api-url
  "https://areena.api.yle.fi/v1/ui/players/yle-radio-1.json?language=fi&client=yle-areena-web&v=10&country=US&areenaAb=aa0&app_id=areena-web-items&app_key=wlTs5D9OjIdeS9krPzRQR4I1PYVzoazN"
  "Template to retrieve metadata for Yle streams")

(defconst radio-f--yle-www-url
  "https://www.yle.be/radio/<<id>>"
  "URL template for Yle station home pages.")


;; == STREAM URLS =======

(defconst radio-f--yle-stream-level-one ;; AAC, 256kbps
  "https://yleradiolive5.akamaized.net/hls/live/20000<<key>>/<<id>>/master.m3u8"
  "Template used for VERT Level One audio stream playback.")

(defconst radio-f--yle-stream-level-two ;; AAC, 256kpbs
  "https://yleradiolive5.akamaized.net/hls/live/20000<<key>>/<<id>>/256/variant.m3u8"
  "Template for Yle Level Two audio stream playback.")

(defconst radio-f--yle-stream-level-three ;; MP3, 128kpbs
  "https://icecast.live.yle.fi/radio/<<l3>>/icecast.audio"
  "Template for Yle Level Two audio stream playback.")

(defconst radio-f--yle-alands-stream-level-one ;; Ogg Vorbis
  "https://stream.alandsradio.ax/stream.ogg"
  "Template for an Ålands Radio Live Level One audio stream playback.")

;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-yle-api-url ()
  (let* ((station (radio-f--get-current-station-data))
         (api (plist-get station :api)))
    (setq radio-f--yle-api-url
          (symbol-value api))))

(defun radio-f--set-yle-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--yle-stream-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-yle-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--yle-stream-level-two
          (symbol-value l2-stream))))

(defun radio-f--set-yle-stream-level-three ()
  (let* ((station (radio-f--get-current-station-data))
         (l3-stream (plist-get station :l3-stream)))
    (setq radio-f--yle-stream-level-three
          (symbol-value l3-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--yle-streams
  `((One     . radio-f--set-yle-stream-level-one)
    (Two     . radio-f--set-yle-stream-level-two)
    (Three   . radio-f--set-yle-stream-level-three)
    (_       . radio-f--set-yle-stream-level-one))
  "Audio stream templates provided by Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--yle-radio-processor (data station)
  "Process Yle Radio DATA for STATION."
  (let* ((name (plist-get station :name))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" visual-id name))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,name)
      ;; (title      . ,title)
      ;; (start      . ,start)
      ;; (end        . ,end)
      (visual-id . ,visual-id))))

(defun radio-f--yle-web-processor (data station)
  "Process Yle Web DATA for STATION."
  (let* ((name (plist-get station :name))
         (data (cdr (assoc "data" data)))
         (now (aref data 0))
         (artist (cdr (assoc "artist" now)))
         (title (cdr (assoc "title" now)))
         (start
          (time-convert
           (date-to-time
            (cdr (assoc "startStamp" now)))
           'integer))
         (duration (cdr (assoc "duration" now)))
         (length (/ 1000 duration))
         (end (+ length start))
         (visual-url (cdr (assoc "image" now)))
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

(provide 'radio-f-yle)
