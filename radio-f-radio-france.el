;;; radio-f-radio-france.el --- Radio France plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Sat 22 Aug 26
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
;; Radio France plugin for Radio F.
;; 79 stations.


;;; Code:

(defconst radio-f--radio-france-api-url
  "https://api.radiofrance.fr/livemeta/live/[id]/[endpoint]"
  "Template used to retrieve JSON data from Radio France")

(defconst radio-f--radio-france-level-one
  "https://stream.radiofrance.fr/[tag]/[tag]_hifi.m3u8?id=radiofrance"
  "Template used to return a level one audio stream for playback.")

(defconst radio-f--radio-france-level-two
  "https://icecast.radiofrance.fr/[tag]-hifi.aac?id=radiofrance"
  "Template used to return a level two stream for playback.")

(defconst radio-f--radio-france-level-three
  "https://[mp3-prefix].[mp3-domain].fr/live/[tag]-midfi.mp3"
  "Template used to return a level three audio stream for playback.")

(defconst radio-f--radio-france-visual-url
  "https://www.radiofrance.fr/pikapi/images/[cover]/400x400"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--radio-france-url
  "https://www.radiofrance.fr/[www]/[www-suffix]"
  "Template used to return a station's URL on the Radio France web site.")

(defconst radio-f--radio-france-streams
  `((One     . ,radio-f--radio-france-level-one)
    (Two     . ,radio-f--radio-france-level-two)
    (Three   . ,radio-f--radio-france-level-three)
    (_       . ,radio-f--radio-france-level-three))
  "Audio stream templates provided by Radio France.")

(defconst radio-f--radio-france-stations
  '((fip ;; Fip runs programs that aren't recognized in the new_apprf_fip endpoint.
     :name "FIP" :id "7"
     :endpoint "apprf_fip_player" :tag "fip"
     :www "fip" :www-suffix "titres-diffuses"
     :mp3-prefix "direct"
     :mp3-domain "radiofrance"
     :plugin radio-france :metadata fip
     :processor radio-f--radio-france-processor)
    (franceinter
     :name "France Inter" :id "1"
     :endpoint "new_apprf_inter" :tag "franceinter"
     :www "franceinter" :www-suffix "grille-programmes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata info
     :processor radio-f--radio-france-processor)
    (franceinfo
     :name "France Info" :id "2"
     :endpoint "new_apprf_info" :tag "franceinfo"
     :www "franceinfo" :www-suffix "titre-diffuses"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata info
     :processor radio-f--radio-france-processor)
    (francemusique
     :name "France Musique" :id "4"
     :endpoint "new_apprf_musique" :tag "francemusique"
     :www "francemusique" :www-suffix "grille-programmes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (franceculture
     :name "France Culture" :id "5"
     :endpoint "new_apprf_culture" :tag "franceculture"
     :www "franceculture" :www-suffix "grille-programmes\#live"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (mouv
     :name "Mouv'" :id "6"
     :endpoint "new_apprf_mouv" :tag "mouv"
     :www "mouv" :www-suffix "titres-diffuses"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fiprock
     :name "FIP Rock" :id "64"
     :endpoint "new_apprf_fip" :tag "fiprock"
     :www "fip" :www-suffix "radio-rock"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipjazz
     :name "FIP Jazz" :id "65"
     :endpoint "new_apprf_fip" :tag "fipjazz"
     :www "fip" :www-suffix "radio-jazz"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipgroove
     :name "FIP Groove" :id "66"
     :endpoint "new_apprf_fip" :tag "fipgroove"
     :www "fipg" :www-suffix "radio-groove"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipmonde
     :name "FIP Monde" :id "69"
     :endpoint "new_apprf_fip" :tag "fipworld"
     :www "fip" :www-suffix "radio-monde"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipnouveautes
     :name "FIP Nouveautés" :id "70"
     :endpoint "new_apprf_fip" :tag "fipnouveautes"
     :www "fip" :www-suffix "radio-nouveautes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipreggae
     :name "FIP Reggae" :id "71"
     :endpoint "new_apprf_fip" :tag "fipreggae"
     :www "fip" :www-suffix "radio-reggae"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipelectro
     :name "FIP Electro" :id "74"
     :endpoint "new_apprf_fip" :tag "fipelectro"
     :www "fip" :www-suffix "radio-electro"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipmetal
     :name "FIP Metal" :id "77"
     :endpoint "new_apprf_fip" :tag "fipmetal"
     :www "fip" :www-suffix "radio-metal"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fippop
     :name "FIP Pop" :id "78"
     :endpoint "new_apprf_fip" :tag "fippop"
     :www "fip" :www-suffix "radio-pop"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fiphiphop
     :name "FIP Hip-Hop" :id "95"
     :endpoint "new_apprf_fip" :tag "fiphiphop"
     :www "fip" :www-suffix "radio-hip-hop"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipsacre
     :name "FIP Sacré Français!" :id "96"
     :endpoint "new_apprf_fip" :tag "fipsacrefrancais"
     :www "fip" :www-suffix "radio-sacre-francais"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fipcultes
     :name "FIP Cultes" :id "709"
     :endpoint "new_apprf_fip" :tag "fipcultes"
     :www "fip" :www-suffix "radio-cultes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    ;; The ici stations have their home page set by a cookie,
    ;; so it's not possible to browse to them directly.  Send
    ;; the user to /francebleu so they may select their
    ;; preferred station.
    (rcfm ;; Corsica.  You just know Napoleon would never have used vi.
     :name "ici RCFM" :id "11"
     :endpoint "new_apprf_bleu" :tag "fbfrequenzamora"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (alsace
     :name "ici Alsace" :id "12"
     :endpoint "new_apprf_bleu" :tag "fbalsace"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (armorique
     :name "ici Armorique" :id "13"
     :endpoint "new_apprf_bleu" :tag "fbarmorique"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (auxerre
     :name "ici Auxerre" :id "14"
     :endpoint "new_apprf_bleu" :tag "fbauxerre"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (bearn
     :name "ici Bearn" :id "15"
     :endpoint "new_apprf_bleu" :tag "fbbearn"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (belfort
     :name "ici Belfort-Montbéliard" :id "16"
     :endpoint "new_apprf_bleu" :tag "fbbelfort"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (berry
     :name "ici Berry" :id "17"
     :endpoint "new_apprf_bleu" :tag "fbberry"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (besancon
     :name "ici Besançon" :id "18"
     :endpoint "new_apprf_bleu" :tag "fbbsancom"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (beourgogne
     :name "ici Bourgogne" :id "19"
     :endpoint "new_apprf_bleu" :tag "fbbesancon"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (breizh
     :name "ici Breizh Izel" :id "20"
     :endpoint "new_apprf_bleu" :tag "fbbreizizel"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (champagne
     :name "ici Champagne-Ardenne" :id "21"
     :endpoint "new_apprf_bleu" :tag "fbchampagne"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (lowernormandy
     :name "ici Normandie (Calvados - Orne)" :id "22"
     :endpoint "new_apprf_bleu" :tag "fbbassenormandie"
     :www "francebleu":www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (creuse
     :name "ici Creuse" :id "23"
     :endpoint "new_apprf_bleu" :tag "fbcreuse"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (drome
     :name "ici Drôme Ardèche" :id "24"
     :endpoint "new_apprf_bleu" :tag "fbdromeardeche"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (gardlozere
     :name "ici Gard Lozère" :id "25"
     :endpoint "new_apprf_bleu" :tag "fbgardlozere"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (gascogne
     :name "ici Gascogne" :id "26"
     :endpoint "new_apprf_bleu" :tag "fbgascogne"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (gironde
     :name "ici Gironde" :id "27"
     :endpoint "new_apprf_bleu" :tag "fbgironde"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (herault
     :name "ici Hérault" :id "28"
     :endpoint "new_apprf_bleu" :tag "fbherault"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (isere
     :name "ici Isère" :id "29"
     :endpoint "new_apprf_bleu" :tag "fbisere"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (larochelle
     :name "ici La Rochelle" :id "30"
     :endpoint "new_apprf_bleu" :tag "fblarochelle"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (limousin
     :name "ici Limousin" :id "31"
     :endpoint "new_apprf_bleu" :tag "fblimousin"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (loireocean
     :name "ici Loire Océan" :id "32"
     :endpoint "new_apprf_bleu" :tag "fbloireocean"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (southlorraine
     :name "ici Lorraine \(Meurthe-et-Moselle et Vosges\)" :id "33"
     :endpoint "new_apprf_bleu" :tag "fbsudlorraine"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (mayenne
     :name "ici Mayenne" :id "34"
     :endpoint "new_apprf_bleu" :tag "fbmayenne"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (north
     :name "ici Nord" :id "36"
     :endpoint "new_apprf_bleu" :tag "fbnord"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (cotentin
     :name "ici Cotentin" :id "37"
     :endpoint "new_apprf_bleu" :tag "fbcotentin"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (uppernormandy
     :name "ici Normandie \(Seine-Maritime - Eure\)" :id "38"
     :endpoint "new_apprf_bleu" :tag "fbhautenormandie"
     :www "francebleu" :www-suffix nil
     :metadata ici :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (orleans
     :name "ici Orléans" :id "39"
     :endpoint "new_apprf_bleu" :tag "fborleans"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (regionauvergne
     :name "ici Pays d'Auvergne" :id "40"
     :endpoint "new_apprf_bleu" :tag "fbpaysdauvergne"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (regionbasque
     :name "ici Pays Basque" :id "41"
     :endpoint "new_apprf_bleu" :tag "fbpaysbasque"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (paysdesavoie
     :name "ici Pays de Savoie" :id "42"
     :endpoint "new_apprf_bleu" :tag "fbpaysdesavoie"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (perigord
     :name "ici Périgord" :id "43"
     :endpoint "new_apprf_bleu" :tag "fbperigord"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (picardie
     :name "ici Picardie" :id "44"
     :endpoint "new_apprf_bleu" :tag "fbpicardie"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (provence
     :name "ici Provence" :id "45"
     :endpoint "new_apprf_bleu" :tag "fbprovence"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (roussillon
     :name "ici Roussillon" :id "46"
     :endpoint "new_apprf_bleu" :tag "fbroussillon"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (touraine
     :name "ici Touraine" :id "47"
     :endpoint "new_apprf_bleu" :tag "fbtouraine"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (vaucluse
     :name "ici Vaucluse" :id "48"
     :endpoint "new_apprf_bleu" :tag "fbvaucluse"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (azur
     :name "ici Azur" :id "49"
     :endpoint "new_apprf_bleu" :tag "fbazur"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (northlorraine
     :name "ici Lorraine \(Moselle et Pays Haut\)" :id "50"
     :endpoint "new_apprf_bleu" :tag "fblorrainenord"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (poitou
     :name "ici Poitou" :id "54"
     :endpoint "new_apprf_bleu" :tag "fbpoitou"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (paris
     :name "ici Paris Île-de-France" :id "68"
     :endpoint "new_apprf_bleu" :tag "fb1071"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (elsass ;; Elsass is a web-only version of Alsace.
     :name "ici Elsass" :id "90"
     :endpoint "new_apprf_bleu" :tag "fbelsass"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (maine
     :name "ici Maine" :id "91"
     :endpoint "new_apprf_bleu" :tag "fbmaine"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (toulouse
     :name "ici Occitanie" :id "92" :endpoint "new_apprf_bleu" :tag "fbtoulouse"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (saintetienne
     :name "ici Saint-Étienne Loire" :id "93"
     :endpoint "new_apprf_bleu" :tag "fbsaintetienneloire"
     :www "francebleu" :www-suffix nil
     :mp3-prefix "direct" :mp3-domain "francebleu"
     :plugin radio-france :metadata ici
     :processor radio-f--radio-france-processor)
    (fmceasy
     :name "France Musique Classique Easy" :id "401"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueeasyclassique"
     :www "francemusique" :www-suffix "radio-classique-easy"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmcplus
     :name "France Classique Plus" :id "402"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueclassiqueplus"
     :www "francemusique" :www-suffix "radio-classique-plus"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmconcerts
     :name "France Musique Concerts" :id "403"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueconcertsradiofrance"
     :www "francemusique" :www-suffix "grille-programmes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmworld
     :name "Ocora Musiques du Monde" :id "404"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueocoramonde"
     :www "francemusique" :www-suffix "radio-ocora"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmlajazz
     :name "France Musique La Jazz" :id "405"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiquelajazz"
     :www "francemusique" :www-suffix "radio-jazz"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmcontemporary
     :name "France Musique La Contemporaine" :id "406"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiquelacontemporaine"
     :www "francemusique" :www-suffix "radio-musiques-contemporaine"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmfilm
     :name "Musique de Films" :id "407"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiquelabo"
     :www "francemusique" :www-suffix "radio-musiques-films"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmbaroque
     :name "France Musique La Baroque" :id "408"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiquebaroque"
     :www "francemusique" :www-suffix "radio-musiques-baroque"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmopera
     :name "France Musique Opéra" :id "409"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueopera"
     :www "francemusique" :www-suffix "radio-opera"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmpianozen
     :name "France Musique Piano Zen" :id "410"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiquepianozen"
     :www "francemusique" :www-suffix "radio-musiques-baroque"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (fmclove
     :name "France Musique Classique Love" :plugin radio-france :id "411"
     :endpoint "new_apprf_webradio_common_layout" :tag "francemusiqueclassiquelove"
     :www "francemusique" :www-suffix "radio-classique-love"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (intermusic
     :name "La musique d\'Inter" :id "1101"
     :endpoint "new_apprf_webradio_common_layout" :tag "franceinterlamusiqueinter"
     :www "francemusique" :www-suffix "la-musique-inter"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (interkids
     :name "Mon petit France Inter" :plugin radio-france :id "1102"
     :endpoint "new_apprf_webradio_common_layout" :tag "monpetitfranceinter"
     :www "podcasts" :www-suffix "enfants"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (intertoddlers
     :name "Mon tout petit France Inter" :id "1103"
     :endpoint "new_apprf_webradio_common_layout" :tag "montoutpetitfranceinter"
     :www "podcasts" :www-suffix "enfants"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (inter100french
     :name "100% Chanson Française" :id "5601"
     :endpoint "transistor_musical_player" :tag "fbchansonfrancaise"
     :www "francebleu" :www-suffix "grille-programmes"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor)
    (intereighties
     :name "100% années 80" :id "5602"
     :endpoint "transistor_musical_player" :tag "fb100pour100annees80"
     :www "francebleu" :www-suffix "chansons-annees-80"
     :mp3-prefix "icecast" :mp3-domain "radiofrance"
     :plugin radio-france :metadata inter
     :processor radio-f--radio-france-processor))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")


;; == Processing ================================

;; Radio France loves to send out "trash" JSON objects, sometimes *during
;; a playing track*, where the values have placeholder info like "Le
;; direct" or the UUID for the Fip logo.  Throw away the whole object.

(defun radio-f--ordures-p (object)
  "Return non-nil when OBJECT contains unusable metadata.

OBJECT refers to a JSON object or vector of objects."
  (seq-some
   (lambda (entry)
     (member (cdr entry)
             '("Le direct"
               "34e98566-058b-428f-a39e-d74bdef1cf77")))
   object))

(defun radio-f--radio-france-processor (data station)
    "Process Radio France DATA for STATION."
  (let* ((now (cdr (assoc "now" data)))
         ;; First, make an empty alist that looks like this:
         (metadata (plist-get station :metadata))
         artist
         title
         visual-url)
    ;; Throw out the entire object should it contain the no-no words.
    (unless (radio-f--ordures-p now)
      ;; Account for all the values that differ from schema to schema.
      (setq artist (cdr (assoc "firstLine" now))
            title  (cdr (assoc "secondLine" now))
            start  (cdr (assoc "startTime" now))
            end    (cdr (assoc "endTime" now)))
      (cond
       ((memq metadata '(inter info ici))
        (setq visual-url
              (format
               "https://www.radiofrance.fr/pikapi/images/%s/400x400"
               (cdr (assoc "cover" now)))
              item-id
              (cdr (assoc "stepId" now))))
       ((eq metadata 'fip)
        (setq visual-url
              (format
               "https://www.radiofrance.fr/pikapi/images/%s/400x400"
               (cdr (assoc "cover" now)))
              item-id
              (cdr (assoc "firstLineSongUuid" now))))
       ((eq metadata 'info)
        (setq visual-url
              (format
               "https://www.radiofrance.fr/pikapi/images/%s/400x400"
               (cdr (assoc "cover_square" now))))))
      ;; Fill in the returned values.  Postmaster takes it from there.
      `((item-id    . ,item-id)
        (artist     . ,artist)
        (title      . ,title)
        (start      . ,start)
        (end        . ,end)
        (visual-url . ,visual-url)))))

(provide 'radio-f-radio-france)

;;; radio-f-radio-france.el ends here
