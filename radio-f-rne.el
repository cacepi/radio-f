;;; radio-f-rne.el --- RNE plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Fri 13 Nov 26
;; Keywords: hypermedia, network, streaming, radio, Spain

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
;; Rne (Spain) plugin for Radio F: 83 Stations.
;;
;; Uses Radioplayer API for local stations, as the RNE API doesn't
;; support them.
;;
;; Rne Radio Exterior is the second most heard station on Earth, after
;; the BBC's World service.
;;
;; Also includes the station Radio Ukraine, as part of the Suspilne
;; program.

;; https://www.rtve.es/play/radio/colecciones/play-radio-informativos-territoriales-rne/258/
;; https://www.rtve.es/play/audios/andalucia-informativos/
;; https://www.rtve.es/play/audios/aragon-informativos/

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--rne-stations
  '((rne-national
     :name "Radio Nacional de España" :carrier rne :id "rne1"
     :station "R1" :online "rnenacional" :key "501" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-logo.png")
    (rne-clasica
     :name "Rne Radio Clásica" :carrier rne :id "rnerc"
     :station "R2" :online "rneclasica" :key "502"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-clasica-logo.png")
    (rne-radio-3
     :name "Rne Radio 3" :carrier rne :id "rner3"
     :station "R1" :online "rne3" :key "503"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-3-logo.png")
    (rne-radio-5
     :name "Rne Radio 5" :carrier rne :id "rne5"
     :station "R1" :online "rne5" :key "504"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-exterior
     :name "Rne Radio Exterior de España" :carrier rne :id "ree"
     :station "R6" :online "rneree" :key "505"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-exterior-logo.png")
    (rne-radio-1-madrid
     :name "Rne Madrid" :carrier rne :id "rne1"
     :station "R1" :online "rne1_madrid" :key "506" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-canarias
     :name "Rne Canarias" :carrier rne :id "cnr"
     :station "R1" :online "rne1_canarias" :key "508" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-baleares
     :name "Rne Baleares" :carrier rne :id "bal"
     :station "R1" :online "rne1_baleares" :key "510" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-galicia
     :name "Rne Galicia" :carrier rne :id "gal"
     :station "R1" :online "rne1_galicia" :key "512" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-asturias
     :name "Rne Asturias" :carrier rne :id "ast"
     :station "R1" :online "rne1_asturias" :key "514" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-cantabria
     :name "Rne Cantabria" :carrier rne :id "ctb"
     :station "R1" :online "rne1_cantabria" :key "516" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-pais-vasco
     :name "Rne País Vasco" :carrier rne :id "eus"
     :station "R1" :online "rne1_paisvasco" :key "517" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-cataluna
     :name "Rne Cataluña" :carrier rne :id "cat"
     :station "R1" :online "rne1_cataluna" :key "520" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-4
     :name "Rne Radio 4" :carrier rne :id "rner4"
     :station "R4" :online "rne4" :key "522" :l2 "rne_r4"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-navarra
     :name "Rne Cataluña" :carrier rne :id "nav"
     :station "R1" :online "rne1_navarra" :key "523" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-aragon
     :name "Rne Aragón" :carrier rne :id "ara"
     :station "R1" :online "rne1_aragon" :key "525" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-valencia
     :name "Rne Valencia" :carrier rne :id "val"
     :station "R1" :online "rne1_valencia" :key "527" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-castilla
     :name "Rne Castilla y León" :carrier rne :id "cyl"
     :station "R1" :online "rne1_castillaleon" :key "529" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-la-mancha
     :name "Rne Castilla La Mancha" :carrier rne :id "clm"
     :station "R1" :online "rne1_castillamancha" :key "531" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-extremadura
     :name "Rne Extremadura" :carrier rne :id "ext"
     :station "R1" :online "rne1_extremadura" :key "533" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-andalucia
     :name "Rne Andalucía" :carrier rne :id "and"
     :station "R1" :online "rne1_andalucia" :key "534" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-la-rioja
     :name "Rne La Rioja" :carrier rne :id "rio"
     :station "R1" :online "rne1_larioja" :key "536" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-murcia
     :name "Rne Murcia" :carrier rne :id "mur"
     :station "R1" :online "rne1_murcia" :key "538" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-ceuta
     :name "Rne Ceuta" :carrier rne :id "ceu"
     :station "R1" :online "rne1_ceuta" :key "579" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-1-melilla
     :name "Rne Melilla" :carrier rne :id "mel"
     :station "R1" :online "rne1_melilla" :key "580" :l2 "rne_r1"
     :l1-stream radio-f--rne-radio-1-stream-level-one
     :l2-stream radio-f--rne-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-radio-1-logo.png")
    (rne-radio-5-madrid
     :name "Rne Radio 5 Madrid" :carrier rne :id "mad"
     :station "R5" :online "rne5_madrid" :key "507" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-tenerife
     :name "Rne Radio 5 Tenerife" :carrier rne :id "ten"
     :station "R5" :online "rne5_tenerife" :key "509" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-palma
     :name "Rne Radio 5 Palma" :carrier rne :id "pmi"
     :station "R5" :online "rne5_palma" :key "511" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-coruna
     :name "Rne Radio 5 Coruna" :carrier rne :id "lcg"
     :station "R5" :online "rne5_coruna" :key "513" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-oviedo
     :name "Rne Radio 5 Ovieda" :carrier rne :id "ast"
     :station "R5" :online "rne5_ovieda" :key "515" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-santander
     :name "Rne Radio 5 Santander" :carrier rne :id "ctb"
     :station "R5" :online "rne5_santander" :key "517" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-vitoria
     :name "Rne Radio 5 Vitoria" :carrier rne :id "vit"
     :station "R5" :online "rne5_vitoria" :key "519" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-barcelona
     :name "Rne Radio 5 Barcelona" :carrier rne :id "bcn"
     :station "R5" :online "rne5_barcelona" :key "521" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-pamplona
     :name "Rne Radio 5 Pamplona" :carrier rne :id "nav"
     :station "R5" :online "rne5_pamplona" :key "524" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-zaragoza
     :name "Rne Radio 5 Zaragoza" :carrier rne :id "zgz"
     :station "R5" :online "rne5_zaragoza" :key "526" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-valencia
     :name "Rne Radio 5 Valencia" :carrier rne :id "vlc"
     :station "R5" :online "rne5_valencia" :key "528" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-valladolid
     :name "Rne Radio 5 Valladolid" :carrier rne :id "vll"
     :station "R5" :online "rne5_valladolid" :key "530" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-toledo
     :name "Rne Radio 5 Toledo" :carrier rne :id "tol"
     :station "R5" :online "rne5_toledo" :key "532" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-sevilla
     :name "Rne Radio 5 Sevilla" :carrier rne :id "sev"
     :station "R5" :online "rne5_sevilla" :key "535" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-legorno
     :name "Rne Radio 5 Logroño" :carrier rne :id "rio"
     :station "R5" :online "rne5_legrono" :key "537" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-murcia
     :name "Rne Radio 5 Murica" :carrier rne :id "mur"
     :station "R5" :online "rne5_murcia" :key "539" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-ceuta
     :name "Rne Radio 5 Ceuta" :carrier rne :id "ceu"
     :station "R5" :online "rne5_ceuta" :key "540" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-las-palmas
     :name "Rne Radio 5 Las Palmas" :carrier rne :id "lpa"
     :station "R5" :online "rne5_laspalmas" :key "541" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-santiago
     :name "Rne Radio 5 Santiago" :carrier rne :id "stg"
     :station "R5" :online "rne5_santiago" :key "542" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-lugo
     :name "Rne Radio 5 Lugo" :carrier rne :id "lug"
     :station "R5" :online "rne5_lugo" :key "543" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-ponte-vedra
     :name "Rne Radio 5 Ponte Vedra" :carrier rne :id "ptv"
     :station "R5" :online "rne5_pontevedra" :key "544" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-orense
     :name "Rne Radio 5 Orense" :carrier rne :id "ore"
     :station "R5" :online "rne5_orense" :key "545" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-vigo
     :name "Rne Radio 5 Vigo" :carrier rne :id "vig"
     :station "R5" :online "rne5_vigo" :key "546" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-san-sebastian
     :name "Rne Radio 5 San Sebastian" :carrier rne :id "don"
     :station "R5" :online "rne5_sansebastian" :key "547" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-bilbao
     :name "Rne Radio 5 Bilbao" :carrier rne :id "bil"
     :station "R5" :online "rne5_bilbao" :key "548" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-gerona
     :name "Rne Radio 5 Gerona" :carrier rne :id "ger"
     :station "R5" :online "rne5_gerona" :key "549" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-lerida
     :name "Rne Radio 5 Lerida" :carrier rne :id "ler"
     :station "R5" :online "rne5_lerida" :key "550" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-tarragona
     :name "Rne Radio 5 Tarragona" :carrier rne :id "tar"
     :station "R5" :online "rne5_tarragona" :key "551" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-teruel
     :name "Rne Radio 5 Teruel" :carrier rne :id "ter"
     :station "R5" :online "rne5_teruel" :key "552" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-huesca
     :name "Rne Radio 5 Huesca" :carrier rne :id "osc"
     :station "R5" :online "rne5_huesca" :key "553" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-castellon
     :name "Rne Radio 5 Castellon" :carrier rne :id "cas"
     :station "R5" :online "rne5_castellon" :key "554" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-alicante
     :name "Rne Radio 5 Alicante" :carrier rne :id "ali"
     :station "R5" :online "rne5_alicante" :key "555" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-leon
     :name "Rne Radio 5 Leon" :carrier rne :id "leo"
     :station "R5" :online "rne5_leon" :key "556" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-zamora
     :name "Rne Radio 5 Zamora" :carrier rne :id "zam"
     :station "R5" :online "rne5_zamora" :key "557" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-salamanca
     :name "Rne Radio 5 Salamanca" :carrier rne :id "sal"
     :station "R5" :online "rne5_salamanca" :key "558" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-ponferrada
     :name "Rne Radio 5 Ponferrada" :carrier rne :id "pfr"
     :station "R5" :online "rne5_ponferrada" :key "559" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-soria
     :name "Rne Radio 5 Soria" :carrier rne :id "sor"
     :station "R5" :online "rne5_soria" :key "560" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-avila
     :name "Rne Radio 5 Avila" :carrier rne :id "avi"
     :station "R5" :online "rne5_avila" :key "561" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-burgos
     :name "Rne Radio 5 Burgos" :carrier rne :id "bur"
     :station "R5" :online "rne5_burgos" :key "562" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-palencia
     :name "Rne Radio 5 Palencia" :carrier rne :id "pal"
     :station "R5" :online "rne5_palencia" :key "563" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-segovia
     :name "Rne Radio 5 Segovia" :carrier rne :id "seg"
     :station "R5" :online "rne5_segovia" :key "564" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-guadalajara
     :name "Rne Radio 5 Guadalajara" :carrier rne :id "gua"
     :station "R5" :online "rne5_guadalajara" :key "565" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-ciudad-real
     :name "Rne Radio 5 Ciudad Real" :carrier rne :id "cdr"
     :station "R5" :online "rne5_ciudadreal" :key "566" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-cuenca
     :name "Rne Radio 5 Cuenca" :carrier rne :id "cue"
     :station "R5" :online "rne5_cuenca" :key "567" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-albacete
     :name "Rne Radio 5 Albacete" :carrier rne :id "alb"
     :station "R5" :online "rne5_albacete" :key "568" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-caceres
     :name "Rne Radio 5 Caceres" :carrier rne :id "cce"
     :station "R5" :online "rne5_caceres" :key "569" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-gijon
     :name "Rne Radio 5 Gijon" :carrier rne :id "gij"
     :station "R5" :online "rne5_gijon" :key "570" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-badajoz
     :name "Rne Radio 5 Badajoz" :carrier rne :id "mer"
     :station "R5" :online "rne5_badajoz" :key "571" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-cordoba
     :name "Rne Radio 5 Cordóba" :carrier rne :id "cor"
     :station "R5" :online "rne5_cordoba" :key "572" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-jaen
     :name "Rne Radio 5 Jaen" :carrier rne :id "jae"
     :station "R5" :online "rne5_jaen" :key "573" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-huelva
     :name "Rne Radio 5 Huelva" :carrier rne :id "onu"
     :station "R5" :online "rne5_huelva" :key "574" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-cadiz
     :name "Rne Radio 5 Cadiz" :carrier rne :id "cad"
     :station "R5" :online "rne5_cadiz" :key "575" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-malaga
     :name "Rne Radio 5 Malaga" :carrier rne :id "mal"
     :station "R5" :online "rne5_malaga" :key "576" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-granada
     :name "Rne Radio 5 Granada" :carrier rne :id "gra"
     :station "R5" :online "rne5_granada" :key "577" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-almeria
     :name "Rne Radio 5 Almeria" :carrier rne :id "alm"
     :station "R5" :online "rne5_almeria" :key "578" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-melilla
     :name "Rne Radio 5 Melilla" :carrier rne :id "mel"
     :station "R5" :online "rne5_melilla" :key "581" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-5-cartagena
     :name "Rne Radio 5 Cartagena" :carrier rne :id "crt"
     :station "R5" :online "rne5_cartagena" :key "582" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-regional-api-url
     :processor radio-f--rne-regional-processor
     :visual "assets/rne/rne-radio-5-logo.png")
    (rne-radio-suspilne-ukraine
     :name "Rne Radio Suspilne Ukraine" :carrier rne :id "crt"
     :station "rukr" :online "rnerukr" :key "582" :l2 "rne_r5"
     :l1-stream radio-f--rne-radio-5-stream-level-one
     :l2-stream radio-f--rne-radio-5-stream-level-two
     :api radio-f--rne-api-url
     :processor radio-f--rne-processor
     :visual "assets/rne/rne-suspilne-logo.png"))
    "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")

;; Ukraine
;; https://rnelivestream.rtve.es/rneoca/oca5/master.m3u8
;; https://rnelivestream.rtve.es/rneoca/oca5/master.m3u8
;; https://www.rtve.es/servicios/programasRadio/rukr.json?emision=ahora-sig
;; https://radio.ukr.radio/ur1-aacplus-l
;; https://radio.ukr.radio/ur1-mp3
;; https://radio3.ukr.radio/ur1-mp3-m

;; == API URLS ==========

(defconst radio-f--rne-api-url
  "https://www.rtve.es/servicios/programasRadio/<<station>>.json?emision=ahora-sig"
  "Template to retrieve metadata for Rne streams")

(defconst radio-f--rne-regional-api-url
  "https://mapi.radioplayer.cloud/api/es/public/service/<<key>>"
  "Template to retrieve general Rne station metadata.")

(defconst radio-f--rne-www-url
 "https://www.rtve.es/radioplayer/emisoras/<<www>>/"
 "URL template for Rne station web pages".)


;; == STREAM URLS =======

(defconst radio-f--rne-radio-1-stream-level-one ;; AAC
  "https://dispatcher.rndfnk.com/crtve/rne1/<<id>>/aac/high?rp_source=1"
  "Template used to return a Rne Radio 1 Level One audio stream for playback.")

(defconst radio-f--rne-radio-5-stream-level-one ;; AAC
  "https://dispatcher.rndfnk.com/crtve/rne5/<<id>>/aac/high?rp_source=1"
  "Template used to return a Rne Radio 5 Level One audio stream for playback.")

(defconst radio-f--rne-radio-5-stream-level-one ;; MP3
  "https://rnelivestream.rtve.es/rne5/<<id>>/master.m3u8"
  "Template used to return a Rne Radio 5 Level Two audio stream for playback.")

(defconst radio-f-rne-radio-susilne-ukraine-level-one
  "https://rnelivestream.rtve.es/rneoca/oca5/master.m3u8"
  "Template used to return a Rne Radio Suspilne Ukraine Level one audio
stream for playback.")

(defconst radio-f--rne-stream-level-two ;; AAC
  "https://rnelivestream.rtve.es/revesec/rne/<<l2>>_main.m3u8"
  "Template used to return a Rne Level Two audio stream for playback.")


;; == HELPER FUNCTIONS ==========================

(defun radio-f--set-rne-stream-level-one ()
  (let* ((station (radio-f--get-current-station-data))
         (l1-stream (plist-get station :l1-stream)))
    (setq radio-f--rne-level-one
          (symbol-value l1-stream))))

(defun radio-f--set-rne-stream-level-two ()
  (let* ((station (radio-f--get-current-station-data))
         (l2-stream (plist-get station :l2-stream)))
    (setq radio-f--rne-level-two
          (symbol-value l2-stream))))


;; == STREAM LEVELS =====

(defvar radio-f--rne-streams
  `((One     . radio-f--set-rne-stream-level-one)
    (Two     . radio-f--set-rne-stream-level-two)
    (default . radio-f--set-rne-stream-level-one))
  "Audio stream templates provided by Norddeutscher Rundfunk.")


;; == PROCESSORS ================================

(defun radio-f--rne-regional-processor (data station)
  "Process RNE JSON DATA provided by ARD Audiothek for STATION."
  (let* ((name (plist-get station :name))
         (artist (cdr (assoc "serviceName" data)))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist visual-id))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      ;; (title      . ,title)
      ;; (start      . ,start)
      ;; (end        . ,end)
      (visual-id . ,visual-id))))

(defun radio-f--rne-processor (data station)
  "Process RNE JSON DATA provided by ARD Audiothek for STATION."
  (let* ((name (plist-get station :name))
         (data (cdr (assoc "emisiones" data)))
         (zero (cdr (assoc "0" data)))
         (programas (cdr (assoc "programas" 0)))
         (items (cdr (assoc "items" programas)))
         (now (aref items 0))
         (artist (plist-get station :name))
         (title (cdr (assoc "nombre" now)))
         (start (cdr (assoc "hora" now)))
         (end (cdr (assoc "horaFin" now)))
         (visual-id (plist-get station :visual))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" name visual-id))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,name)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url . ,visual-id))))


(provide 'radio-f-rne)
