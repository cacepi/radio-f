;;; radio-f-cbc.el --- CBC plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sun 1 Nov 26
;; Localewords: hypermedia, network, streaming, radio, Canada

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
;; CBC plugin for Radio F: 68 Stations.
;; Only English language ATM: the ICI stations have a different JSON scheme.
;; Still trying to figure out how it's organized.


;;; Code:

;; == STATION PLIST =====

(defconst radio-f--cbc-stations
  '((one-calgary ;; ALBERTA/MOUNTAIN
     :name "Radio One Calgary" :carrier cbc :station "1" :id "2041039"
     :l1-stream "ES_R1MCG" :l2-stream "CBR1FM_CBC" :locale "calgary"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-edmonton
     :name "Radio One Edmonton" :carrier cbc :station "1" :id "2041041"
     :l1-stream "ES_R1MED" :l2-stream "CBXAM_CBC" :locale "edmonton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-kamloops ;; BRITISH COLUMBIA/PACIFIC
     :name "Radio One Kamloops" :carrier cbc :station "1" :id "2041048"
     :l1-stream "ES_R1PKP" :l2-stream "CBYKFM_CBC" :locale "kamloops"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-kelowna
     :name "Radio One Kelowna" :carrier cbc :station "1" :id "2041047"
     :l1-stream "ES_R1PKE" :l2-stream "CBTKFM_CBC" :locale "kelowna"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-prince-george
     :name "Radio One Prince George" :carrier cbc :station "1" :id "2041049"
     :l1-stream "ES_R1PPR" :l2-stream "CBYGFM_CBC" :locale "prince_george"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-vancouver
     :name "Radio One Vancouver" :carrier cbc :station "1" :id "2041042"
     :l1-stream "ES_R1PVC" :l2-stream "CBU2FM_CBC" :locale "vancouver"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-victoria
     :name "Radio One Victoria" :carrier cbc :station "1" :id "2041051"
     :l1-stream "ES_R1PVI" :l2-stream "CBCVFM_CBC" :locale "victoria"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-winnipeg ;; MANITOBA/CENTRAL
     :name "Radio One Winnipeg" :carrier cbc :station "1" :id "2040991"
     :l1-stream "ES_R1CWP" :l2-stream "CBWAM_CBC" :locale "winnipeg"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-fredericton ;; NEW BRUNSWICK/ATLANTIC
     :name "Radio One Fredericton" :carrier cbc :station "1" :id "2040986"
     :l1-stream "ES_R1AFR" :l2-stream "CBZFFM_CBC" :locale "fredericton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-moncton
     :name "Radio One Moncton" :carrier cbc :station "1" :id "2040989"
     :l1-stream "ES_R1AMC" :l2-stream "CBAMFM_CBC" :locale "moncton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-saint-john
     :name "Radio One Saint John" :carrier cbc :station "1" :id "2040988"
     :l1-stream "ES_R1ASB" :l2-stream "CBDFM_CBC" :locale "saint_john"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-corner-brook ;; NEWFOUNDLAND AND LABRADOR/ATLANTIC
     :name "Radio One Corner Brook" :carrier cbc :station "1" :id "2041044"
     :l1-stream "ES_R1NCR" :l2-stream "CBYAM_CBC" :locale "corner_brook"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-goose-bay
     :name "Radio One Goose Bay" :carrier cbc :station "1" :id "2041045"
     :l1-stream "ES_R1NGN" :l2-stream "CFGB_CBC" :locale "labrador"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-grand-falls
     :name "Radio One Grand Falls" :carrier cbc :station "1" :id "2041046"
     :l1-stream "ES_R1NGN" :l2-stream "CBN2_CBC" :locale "grand_falls_gander"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-st-johns
     :name "Radio One St. John's" :carrier cbc :station "1" :id "2040987"
     :l1-stream "ES_R1NSN" :l2-stream "CBN1_CBC" :locale "st_johns"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-inuvik ;; NORTHWEST TERRITORIES/MOUNTAIN
     :name "Radio One Inuvik" :carrier cbc :station "1" :id "2041042"
     :l1-stream "ES_R1MNN" :l2-stream "CHAK_CBC" :locale "inuvik"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-yellowknife
     :name "Radio One Yellowknife" :carrier cbc :station "1" :id "2041043"
     :l1-stream "ES_R1MNS" :l2-stream "CFYKFM_CBC" :locale "yellow_knife"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-halifax ;; NOVA SCOTIA/ATLANTIC
     :name "Radio One Halifax" :carrier cbc :station "1" :id "2040987"
     :l1-stream "ES_R1AHF" :l2-stream "CBHA_CBC" :locale "halifax"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-sydney
     :name "Radio One Sidney" :carrier cbc :station "1" :id "2040990"
     :l1-stream "ES_R1ASY" :l2-stream "CBIS_CBC" :locale "sydney"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-iqaluit ;; NUNAVUT/MOUNTAIN
     :name "Radio One Iqaluit (Nunavut)" :carrier cbc :station "1" :id "2040993"
     :l1-stream "ES_R1EIQ" :l2-stream "CFFB_CBC" :locale "iqaluit"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-kenora ;; ONTARIO/CENTRAL
     :name "Radio One Kenora" :carrier cbc :station "1" :id "2097862"
     :l1-stream "ES_R1CKN" :l2-stream "CBTKFM_CBC" :locale "kenora"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-barrie ;; ONTARIO/EASTERN
     :name "Radio One Barrie" :carrier cbc :station "1" :id "2041032"
     :l1-stream "ES_R1ERI" :l2-stream "CBCOFM_CBC" :locale "barrie"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-kingston
     :name "Radio One Kingston" :carrier cbc :station "1" :id "2040994"
     :l1-stream "ES_R1EKI" :l2-stream "CBCKFM_CBC" :locale "kingston"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-kitchener-waterloo
     :name "Radio One Kitchener-Waterloo" :carrier cbc :station "1" :id "2040995"
     :l1-stream "ES_R1EKW" :l2-stream "CBLAFM2_CBC" :locale "kitchener_waterloo"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-london
     :name "Radio One London" :carrier cbc :station "1" :id "2041029"
     :l1-stream "ES_R1ELD" :l2-stream "CBCLFM_CBC" :locale "london"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-ottawa
     :name "Radio One Ottawa" :carrier cbc :station "1" :id "2041037"
     :l1-stream "ES_R1ETT" :l2-stream "CBOFM_CBC" :locale "ottawa"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-peterborough
     :name "Radio One Peterborough" :carrier cbc :station "1" :id "2041033"
     :l1-stream "ES_R1ERI1" :l2-stream "CBCPFM_CBC" :locale "peterborough"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-sudbury
     :name "Radio One Sudbury" :carrier cbc :station "1" :id "2041034"
     :l1-stream "ES_R1ESU" :l2-stream "CBCSFM_CBC" :locale "sudbury"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-thunder-bay
     :name "Radio One Thunder Bay" :carrier cbc :station "1" :id "2041035"
     :l1-stream "ES_R1ETH" :l2-stream "CBQTFM_CBC" :locale "thunderbay"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-toronto
     :name "Radio One Toronto" :carrier cbc :station "1" :id "2041036"
     :l1-stream "ES_R1ETR" :l2-stream "CBLAFM_CBC" :locale "toronto"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-windsor
     :name "Radio One Windsor" :carrier cbc :station "1" :id "2041038"
     :l1-stream "ES_R1EWD" :l2-stream "CBEWFM_CBC" :locale "windsor"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-charlottetown ;; PEI/Atlantic
     :name "Radio One Charlottetown" :carrier cbc :station "1" :id "2040985"
     :l1-stream "ES_R1ACH" :l2-stream "CBCRFM_CBC" :locale "charlottetown"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-montreal ;; QUEBEC/EASTERN
     :name "Radio One Montreal" :carrier cbc :station "1" :id "2041030"
     :l1-stream "ES_R1EMT" :l2-stream "CBMEFM_CBC" :locale "montreal"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-north-quebec
     :name "Radio One Nord Quebec" :carrier cbc :station "1" :id "2040992"
     :l1-stream "ES_R1ECB" :l2-stream "CBVEFM_CBC" :locale "nord_quebec"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-quebec-city
     :name "Radio One Quebec City" :carrier cbc :station "1" :id "2041031"
     :l1-stream "ES_R1EQQ" :l2-stream "CBVEFM_CBC" :locale "quebec_city"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-regina ;; SASKATCHEWAN/MOUNTAIN
     :name "Radio One Regina" :carrier cbc :station "1" :id "2041053"
     :l1-stream "ES_R1SRE" :l2-stream "CBKRFM_CBC" :locale "regina"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-saskatoon
     :name "Radio One Saskatoon" :carrier cbc :station "1" :id "2041054"
     :l1-stream "ES_R1SSA" :l2-stream "CBK1FM_CBC" :locale "kitchener_waterloo"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    (one-whitehorse ;; YUKON/MOUNTAIN
     :name "Radio One Whitehorse" :carrier cbc :station "1" :id "2041052"
     :l1-stream "ES_R1PWH" :l2-stream "CFWH_CBC" :locale "whitehorse"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-radio-one.png")
    ;; CBC MUSIC
    (cbc-music-calgary ;; ALBERTA/MOUNTAIN
     :name "CBC Music Calgary" :carrier cbc :station "2" :id "2041059"
     :l1-stream "ES_R2PVC" :l2-stream "CBR2FM_CBC" :locale "calgary"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-edmonton
     :name "CBC Music Edmonton" :carrier cbc :station "2" :id "2041041"
     :l1-stream "ES_R2MED" :l2-stream "CBXAM_CBC" :locale "edmonton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-kamloops ;; BRITISH COLUMBIA/PACIFIC
     :name "CBC Music Kamloops" :carrier cbc :station "2" :id "2041048"
     :l1-stream "ES_R2PKP" :l2-stream "CBYKFM_CBC" :locale "kamloops"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-kelowna
     :name "CBC Music Kelowna" :carrier cbc :station "2" :id "2041047"
     :l1-stream "ES_R2PKE" :l2-stream "CBTKFM_CBC" :locale "kelowna"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-prince-george
     :name "CBC Music Prince George" :carrier cbc :station "2" :id "2041049"
     :l1-stream "ES_R2PPR" :l2-stream "CBYGFM_CBC" :locale "prince_george"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-vancouver
     :name "CBC Music Vancouver" :carrier cbc :station "2" :id "2041050"
     :l1-stream "ES_R2PVC" :l2-stream "CBU2FM_CBC" :locale "vancouver"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-victoria
     :name "CBC Music Victoria" :carrier cbc :station "2" :id "2041051"
     :l1-stream "ES_R2PVI" :l2-stream "CBCVFM_CBC" :locale "victoria"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-winnipeg ;; MANITOBA/CENTRAL
     :name "CBC Music Winnipeg" :carrier cbc :station "2" :id "2040991"
     :l1-stream "ES_R2CWP" :l2-stream "CBWAM_CBC" :locale "winnipeg"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-fredericton ;; NEW BRUNSWICK/ATLANTIC
     :name "CBC Music Fredericton" :carrier cbc :station "2" :id "2040986"
     :l1-stream "ES_R2AFR" :l2-stream "CBZFFM_CBC" :locale "fredericton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-moncton
     :name "CBC Music Moncton" :carrier cbc :station "2" :id "2040989"
     :l1-stream "ES_R2AMC" :l2-stream "CBAMFM_CBC" :locale "moncton"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-saint-john
     :name "CBC Music Saint John" :carrier cbc :station "2" :id "2040988"
     :l1-stream "ES_R2ASB" :l2-stream "CBDFM_CBC" :locale "saint_john"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-corner-brook ;; NEWFOUNDLAND AND LABRADOR/ATLANTIC
     :name "CBC Music Corner Brook" :carrier cbc :station "2" :id "2041044"
     :l1-stream "ES_R2NCR" :l2-stream "CBYAM_CBC" :locale "corner_brook"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-goose-bay
     :name "CBC Music Goose Bay" :carrier cbc :station "2" :id "2041045"
     :l1-stream "ES_R2NGN" :l2-stream "CFGB_CBC" :locale "labrador"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-grand-falls
     :name "CBC Music Grand Falls" :carrier cbc :station "2" :id "2041046"
     :l1-stream "ES_R2NGN" :l2-stream "CBN2_CBC" :locale "grand_falls_gander"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-st-johns
     :name "CBC Music St. John's" :carrier cbc :station "2" :id "2040987"
     :l1-stream "ES_R2NSN" :l2-stream "CBN1_CBC" :locale "st_johns"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-inuvik ;; NORTHWEST TERRITORIES/MOUNTAIN
     :name "CBC Music Inuvik" :carrier cbc :station "2" :id "2041042"
     :l1-stream "ES_R2MNN" :l2-stream "CHAK_CBC" :locale "inuvik"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-yellowknife
     :name "CBC Music Yellowknife" :carrier cbc :station "2" :id "2041043"
     :l1-stream "ES_R2MNS" :l2-stream "CFYKFM_CBC" :locale "yellow_knife"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-halifax ;; NOVA SCOTIA/ATLANTIC
     :name "CBC Music Halifax" :carrier cbc :station "2" :id "2040987"
     :l1-stream "ES_R2AHF" :l2-stream "CBHA_CBC" :locale "halifax"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-sydney
     :name "CBC Music Sidney" :carrier cbc :station "2" :id "2040990"
     :l1-stream "ES_R2ASY" :l2-stream "CBIS_CBC" :locale "sydney"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-iqaluit ;; NUNAVUT/MOUNTAIN
     :name "CBC Music Iqaluit (Nunavut)" :carrier cbc :station "2" :id "2040993"
     :l1-stream "ES_R2EIQ" :l2-stream "CFFB_CBC" :locale "iqaluit"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-kenora ;; ONTARIO/CENTRAL
     :name "CBC Music Kenora" :carrier cbc :station "2" :id "2097862"
     :l1-stream "ES_R2CKN" :l2-stream "CBTKFM_CBC" :locale "kenora"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-barrie ;; ONTARIO/EASTERN
     :name "CBC Music Barrie" :carrier cbc :station "2" :id "2041032"
     :l1-stream "ES_R2ERI" :l2-stream "CBCOFM_CBC" :locale "barrie"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-kingston
     :name "CBC Music Kingston" :carrier cbc :station "2" :id "2040994"
     :l1-stream "ES_R2EKI" :l2-stream "CBCKFM_CBC" :locale "kingston"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-kitchener-waterloo
     :name "CBC Music Kitchener-Waterloo" :carrier cbc :station "2" :id "2040995"
     :l1-stream "ES_R2EKW" :l2-stream "CBLAFM2_CBC" :locale "kitchener_waterloo"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-london
     :name "CBC Music London" :carrier cbc :station "2" :id "2041029"
     :l1-stream "ES_R2ELD" :l2-stream "CBCLFM_CBC" :locale "london"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-ottawa
     :name "CBC Music Ottawa" :carrier cbc :station "2" :id "2041037"
     :l1-stream "ES_R2ETT" :l2-stream "CBOFM_CBC" :locale "ottawa"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-peterborough
     :name "CBC Music Peterborough" :carrier cbc :station "2" :id "2041033"
     :l1-stream "ES_R2ERI1" :l2-stream "CBCPFM_CBC" :locale "peterborough"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-sudbury
     :name "CBC Music Sudbury" :carrier cbc :station "2" :id "2041034"
     :l1-stream "ES_R2ESU" :l2-stream "CBCSFM_CBC" :locale "sudbury"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-thunder-bay
     :name "CBC Music Thunder Bay" :carrier cbc :station "2" :id "2041035"
     :l1-stream "ES_R2ETH" :l2-stream "CBQTFM_CBC" :locale "thunderbay"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-toronto
     :name "CBC Music Toronto" :carrier cbc :station "2" :id "2041036"
     :l1-stream "ES_R2ETR" :l2-stream "CBLAFM_CBC" :locale "toronto"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-windsor
     :name "CBC Music Windsor" :carrier cbc :station "2" :id "2041038"
     :l1-stream "ES_R2EWD" :l2-stream "CBEWFM_CBC" :locale "windsor"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-charlottetown ;; PEI/Atlantic
     :name "CBC Music Charlottetown" :carrier cbc :station "2" :id "2040985"
     :l1-stream "ES_R2ACH" :l2-stream "CBCRFM_CBC" :locale "charlottetown"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-montreal ;; QUEBEC/EASTERN
     :name "CBC Music Montreal" :carrier cbc :station "2" :id "2041030"
     :l1-stream "ES_R2EMT" :l2-stream "CBMEFM_CBC" :locale "montreal"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-north-quebec
     :name "CBC Music Nord Quebec" :carrier cbc :station "2" :id "2040992"
     :l1-stream "ES_R2ECB" :l2-stream "CBVEFM_CBC" :locale "nord_quebec"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-quebec-city
     :name "CBC Music Quebec City" :carrier cbc :station "2" :id "2041031"
     :l1-stream "ES_R2EQQ" :l2-stream "CBVEFM_CBC" :locale "quebec_city"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-regina ;; SASKATCHEWAN/MOUNTAIN
     :name "CBC Music Regina" :carrier cbc :station "2" :id "2041053"
     :l1-stream "ES_R2SRE" :l2-stream "CBKRFM_CBC" :locale "regina"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-saskatoon
     :name "CBC Music Saskatoon" :carrier cbc :station "2" :id "2041054"
     :l1-stream "ES_R2SSA" :l2-stream "CBK1FM_CBC" :locale "kitchener_waterloo"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png")
    (cbc-music-whitehorse ;; YUKON/MOUNTAIN
     :name "CBC Music Whitehorse" :carrier cbc :station "2" :id "2041052"
     :l1-stream "ES_R2PWH" :l2-stream "CFWH_CBC" :locale "whitehorse"
     :api radio-f--cbc-radio-api-url :processor radio-f--cbc-processor
     :visual "assets/cbc/cbc-music.png"))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")

;; == API URLS ==========

(defconst radio-f--cbc-api-url
  "https://www.cbc.ca/listen/api/v1/program-queue/<<station>>/<<locale>>?xcountry=INT"
  "Template to retrieve metadata for CBC Radio.")

;; == STREAM URLS =======

(defconst radio-f--cbc-level-one
  "https://cbcradiolive.akamaized.net/hls/live/<<id>>/<<l1-stream>>/master.m3u8"
  "Template used to return a Level One audio stream for playback.")
;;g https://cbcradiolive.akamaized.net/hls/live/2041059/ES_R2PVC/master.m3u8

(defconst radio-f--cbc-level-two
  "https://playerservices.streamtheworld.com/api/livestream-redirect/<<l2-stream>>.mp3"
  "Template used to return a Level Two audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--cbc-streams
  `((One     . ,radio-f--cbc-level-one)
    (Two     . ,radio-f--cbc-level-two)
    (_       . ,radio-f--cbc-level-one))
  "Audio stream templates provided by CBC.")


;; == PROCESSORS ================================

(defun radio-f--cbc-processor (data station)
  "Process CBC JSON DATA for STATION."
  (let* ((name (plist-get station :name))
         (data (cdr (assoc "data" data)))
         (now (aref data 0))
         (image (cdr (assoc "image" now)))
         (credits (cdr (assoc "title" now)))
         (artist (cdr (assoc "hostName" now)))
         (title (cdr (assoc "programTitle" now)))
         (start-time (cdr (assoc "epochStart" now)))
         (end-time (cdr (assoc "epochEnd" now)))
         (start (/ start-time 1000))
         (end (/ end-time 1000))
         (image (cdr (assoc "programImage" now)))
         (item-id (secure-hash
                   'sha3-224
                   (format "%s|%s" artist title start end))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end)
      (visual-url
       . ,(and image
               (replace-regexp-in-string
                "${width}" "600" image t t)
               (replace-regexp-in-string
                "${ratio}" "1x1" image t t))))))

(provide 'radio-f-cbc)
