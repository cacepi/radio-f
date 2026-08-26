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

(defconst radio-f--radio-france-url
  "https://www.radiofrance.fr/[www]/[www-suffix]"
  "Template used to return a station's URL on the Radio France web site.")

(defconst radio-f--radio-france-hls
  "https://stream.radiofrance.fr/[tag]/[tag].m3u8?id=radiofrance"
  "Template used to return an HLS audio stream for playback.")

(defconst radio-f--radio-france-aac
  "https://icecast.radiofrance.fr/[tag]-hifi.aac?id=radiofrance"
  "Template used to return an AAC audio stream for playback.")

(defconst radio-f--radio-france-mp3
  "http://[mp3-prefix].[mp3-domain].fr/live/[tag]-midfi.mp3"
  "Template used to return an MP3 audio stream for playback.")

(defconst radio-f--radio-france-visual-url
  "https://www.radiofrance.fr/pikapi/images/[cover]/400x400"
  "Template used to retrieve the artwork image for the presentation views.")

(defconst radio-f--radio-france-streams
  `((hls     . ,radio-f--radio-france-hls)
    (aac     . ,radio-f--radio-france-aac)
    (mp3     . ,radio-f--radio-france-mp3)
    (default . ,radio-f--radio-france-hls))
  "Audio stream templates provided by Radio France.")

(defconst radio-f--radio-france-stations
  '((fip
     :name "FIP" :provider radio-france :id "7"
     :endpoint "new_apprf_fip" :www "fip"
     :tag "fip" :www-suffix "titres-diffuses"
     :metadata inter :mp3-prefix icecast :mp3-domain radiofrance)
    (franceinter
     :name "France Inter" :provider radio-france :id "1"
     :endpoint "new_apprf_inter" :www "franceinter"
     :tag "franceinter" :www-suffix "grille-programmes"
     :metadata info :mp3-prefix icecast :mp3-domain radiofrance)
    (franceinfo
     :name "France Info" :provider radio-france :id "2"
     :endpoint "new_apprf_info" :www "franceinfo"
     :tag "franceinfo" :www-suffix "titre-diffuses"
     :metadata info :mp3-prefix icecast :mp3-domain radiofrance)
    (francemusique
     :name "France Musique" :provider radio-france :id "4"
     :endpoint "new_apprf_musique" :www "francemusique"
     :tag "francemusique" :www-suffix "grille-programmes"
     :metadata inter :mp3-prefix icecast :mp3-domain radiofrance)
    (franceculture
     :name "France Culture" :provider radio-france :id "5"
     :endpoint "new_apprf_culture" :www "franceculture"
     :tag "franceculture" :www-suffix "grille-programmes\#live"
     :metadata inter :mp3-prefix icecast :mp3-domain radiofrance)
    (mouv
     :name "Mouv'" :provider radio-france :id "6"
     :endpoint "new_apprf_mouv" :www "mouv"
     :tag "mouv" :www-suffix "titres-diffuses"
     :metadata inter :mp3-prefix icecast
     :mp3-domain radiofrance)
    (fiprock
     :name "FIP Rock" :provider radio-france :id "64"
     :endpoint "new_apprf_fip" :www "fip" :tag "fiprock"
     :www-suffix "radio-rock" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipjazz
     :name "FIP Jazz" :provider radio-france :id "65"
     :endpoint "new_apprf_fip" :www "fip" :tag: "fipjazz"
     :www-suffix "radio-jazz" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipgroove
     :name "FIP Groove" :provider radio-france :id "66"
     :endpoint "new_apprf_fip" :www "fip"
     :tag: "fipgroove" :www-suffix "radio-groove"
     :metadata inter :mp3-prefix icecast
     :mp3-domain radiofrance)
    (fipmonde
     :name "FIP Monde" :provider radio-france :id "69"
     :endpoint "new_apprf_fip" :www "fip"
     :tag: "fipmonde" :www-suffix "radio-monde"
     :metadata inter :mp3-prefix icecast
     :mp3-domain radiofrance)
    (fipnouveautes
     :name "FIP Nouveautés" :provider radio-france :id "70"
     :endpoint "new_apprf_fip" :www "fip" :tag "fipnouveautes"
     :www-suffix "radio-nouveautes" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipreggae
     :name "FIP Reggae" :provider radio-france :id "71"
     :endpoint "new_apprf_fip" :www "fip" :tag "fipreggae"
     :www-suffix "radio-reggae" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipelectro
     :name "FIP Electro" :provider radio-france :id "74"
     :endpoint "new_apprf_fip" :www "fip" :tag "fipelectro"
     :www-suffix "radio-electro" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipmetal
     :name "FIP Metal" :provider radio-france :id "77"
     :endpoint "new_apprf_fip" :www "fip" :tag "fipmetal"
     :www-suffix "radio-metal" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fippop
     :name "FIP Pop" :provider radio-france :id "78"
     :endpoint "new_apprf_fip" :www "fip" :tag "fippop"
     :www-suffix "radio-pop" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fiphiphop
     :name "FIP Hip-Hop" :provider radio-france :id "95"
     :endpoint "new_apprf_fip" :www "fip" :tag "hiphop"
     :www-suffix "radio-hip-hop" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipsacre
     :name "FIP Sacré Français!" :provider radio-france :id "96"
     :endpoint "new_apprf_fip" :www "fip" :tag "sacrefrancais"
     :www-suffix "radio-sacre-francais" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fipcultes
     :name "FIP Cultes" :provider radio-france :id "709"
     :endpoint "new_apprf_fip" :www "fip" :tag "fipcultes"
     :www-suffix "radio-cultes" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    ;; The ici stations have their home page set by a cookie,
    ;; so it's not possible to browse to them directly.  Send
    ;; the user to /francebleu so they may select their
    ;; preferred station.
    (rcfm ;; Corsica.  You just know Napoleon would never have used vi.
     :name "ici RCFM" :provider radio-france :id "11"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbfrequenzamora" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (alsace
     :name "ici Alsace" :provider radio-france :id "12"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbalsace" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (armorique
     :name "ici Armorique" :provider radio-france :id "13"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbarmorique" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (auxerre
     :name "ici Auxerre" :provider radio-france :id "14"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbauxerre" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (bearn
     :name "ici Bearn" :provider radio-france :id "15"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbearn" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (belfort
     :name "ici Belfort-Montbéliard" :provider radio-france
     :id "16" :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbelfort" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (berry
     :name "ici Berry" :provider radio-france
     :id "17" :endpoint "new_apprf_bleu"
     :www "francebleu" :tag "fbberry" :www-suffix nil
     :metadata ici :mp3-prefix direct
     :mp3-domain francebleu)
    (besancon
     :name "ici Besançon" :provider radio-france :id "18"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbsancom" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (beourgogne
     :name "ici Bourgogne" :provider radio-france :id "19"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbesancon" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (breizh
     :name "ici Breizh Izel" :provider radio-france :id "20"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbreizizel" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (champagne
     :name "ici Champagne-Ardenne" :provider radio-france
     :id "21" :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbchampagne" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (lowernormandy
     :name "ici Normandie (Calvados - Orne)"
     :provider radio-france :id "22"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbbassenormandie" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (creuse
     :name "ici Creuse" :provider radio-france :id "23"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbcreuse" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (drome
     :name "ici Drôme Ardèche" :provider radio-france :id "24"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbdromeardeche" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (gardlozere
     :name "ici Gard Lozère" :provider radio-france :id "25"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbgardlozere" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (gascogne
     :name "ici Gascogne" :provider radio-france :id "26"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbgascogne" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (gironde
     :name "ici Gironde" :provider radio-france :id "27"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbgironde" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (herault
     :name "ici Hérault" :provider radio-france :id "28"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbherault" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (isere
     :name "ici Isère" :provider radio-france :id "29"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbisere" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (larochelle
     :name "ici La Rochelle" :provider radio-france :id "30"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fblarochelle" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (limousin
     :name "ici Limousin" :provider radio-france :id "31"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fblimousin" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (loireocean
     :name "ici Loire Océan" :provider radio-france :id "32"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbloireocean" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (southlorraine
     :name "ici Lorraine \(Meurthe-et-Moselle et Vosges\)"
     :provider radio-france :id "33"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbsudlorraine" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (mayenne
     :name "ici Mayenne" :provider radio-france :id "34"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbmayenne" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (north
     :name "ici Nord" :provider radio-france :id "36"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbnord" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (cotentin
     :name "ici Cotentin" :provider radio-france :id "37"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbcotentin" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (uppernormandy
     :name "ici Normandie \(Seine-Maritime - Eure\)"
     :provider radio-france :id "38" :endpoint "new_apprf_bleu"
     :www "francebleu" :tag "fbhautenormandie" :www-suffix nil
     :metadata ici :mp3-prefix direct :mp3-domain francebleu)
    (orleans
     :name "ici Orléans" :provider radio-france :id "39"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fborleans" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (regionauvergne
     :name "ici Pays d'Auvergne" :provider radio-france :id "40"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbpaysdauvergne" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (regionbasque
     :name "ici Pays Basque" :provider radio-france :id "41"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbpaysbasque" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (paysdesavoie
     :name "ici Pays de Savoie" :provider radio-france :id "42"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbpaysdesavoie"
     :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (perigord
     :name "ici Périgord" :provider radio-france :id "43"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbperigord" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (picardie
     :name "ici Picardie" :provider radio-france :id "44"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbpicardie" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (provence
     :name "ici Provence" :provider radio-france :id "45"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbprovence" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (roussillon
     :name "ici Roussillon" :provider radio-france :id "46"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbroussillon" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (touraine
     :name "ici Touraine" :provider radio-france :id "47"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbtouraine" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (vaucluse
     :name "ici Vaucluse" :provider radio-france :id "48"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbvaucluse" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (azur
     :name "ici Azur" :provider radio-france :id "49"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbazur" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (northlorraine
     :name "ici Lorraine \(Moselle et Pays Haut\)"
     :provider radio-france :id "50"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fblorrainenord" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (poitou
     :name "ici Poitou" :provider radio-france :id "54"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbpoitou" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (paris
     :name "ici Paris Île-de-France" :provider radio-france
     :id "68" :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fb1071" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (elsass ;; Elsass is a web-only version of Alsace.
     :name "ici Elsass" :provider radio-france :id "90"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbelsass" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (maine
     :name "ici Maine" :provider radio-france :id "91"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbmaine" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (toulouse
     :name "ici Occitanie" :provider radio-france :id "92"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbtoulouse" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (saintetienne
     :name "ici Saint-Étienne Loire" :provider radio-france :id "93"
     :endpoint "new_apprf_bleu" :www "francebleu"
     :tag "fbsaintetienneloire" :www-suffix nil :metadata ici
     :mp3-prefix direct :mp3-domain francebleu)
    (fmceasy
     :name "France Musique Classique Easy" :provider radio-france
     :id "401" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiqueeasyclassique"
     :www-suffix "radio-classique-easy" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmcplus
     :name "France Classique Plus" :provider radio-france :id "402"
     :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiqueclassiqueplus"
     :www-suffix "radio-classique-plus" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmconcerts
     :name "France Musique Concerts" :provider radio-france :id "403"
     :endpoint "new_apprf_webradio_common_layout" :www "francemusique"
     :tag "francemusiqueconcertsradiofrance"
     :www-suffix "grille-programmes" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmworld
     :name "Ocora Musiques du Monde" :provider radio-france
     :id "404" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiqueocoramonde"
     :www-suffix "radio-ocora" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmlajazz
     :name "France Musique La Jazz" :provider radio-france :id "405"
     :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiquelajazz"
     :www-suffix "radio-jazz" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmcontemporary
     :name "France Musique La Contemporaine" :provider radio-france
     :id "406" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiquelacontemporaine"
     :www-suffix "radio-musiques-contemporaine" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmfilm
     :name "Musique de Films" :provider radio-france :id "407"
     :endpoint "new_apprf_webradio_common_layout" :www "francemusique"
     :tag "francemusiquelabo" :www-suffix "radio-musiques-films"
     :metadata inter :mp3-prefix icecast :mp3-domain radiofrance)
    (fmbaroque
     :name "France Musique La Baroque" :provider radio-france
     :id "408" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiquebaroque"
     :www-suffix "radio-musiques-baroque" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmopera
     :name "France Musique Opéra" :provider radio-france
     :id "409" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiqueopera"
     :www-suffix "radio-opera" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmpianozen
     :name "France Musique Piano Zen" :provider radio-france
     :id "410" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiquepianozen"
     :www-suffix "radio-musiques-baroque" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (fmclove
     :name "France Musique Classique Love" :provider radio-france
     :id "411" :endpoint "new_apprf_webradio_common_layout"
     :www "francemusique" :tag "francemusiqueclassiquelove"
     :www-suffix "radio-classique-love" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (intermusic
     :name "La musique d\'Inter" :provider radio-france
     :id "1101" :endpoint "new_apprf_webradio_common_layout"
     :www "franceinter" :tag "franceinterlamusiqueinter"
     :www-suffix "la-musique-inter" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (interkids
     :name "Mon petit France Inter" :provider radio-france
     :id "1102" :endpoint "new_apprf_webradio_common_layout"
     :www "podcasts" :tag "monpetitfranceinter"
     :www-suffix "enfants" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (intertoddlers
     :name "Mon tout petit France Inter" :provider radio-france
     :id "1103" :endpoint "new_apprf_webradio_common_layout"
     :www "podcasts" :tag "montoutpetitfranceinter"
     :www-suffix "enfants" :metadata inter :mp3-prefix
     icecast :mp3-domain radiofrance)
    (inter100french
     :name "100% Chanson Française" :provider radio-france
     :id "5601" :endpoint "transistor_musical_player"
     :www "francebleu" :tag "fbchansonfrancaise"
     :www-suffix "grille-programmes" :metadata inter
     :mp3-prefix icecast :mp3-domain radiofrance)
    (intereighties
     :name "100% années 80" :provider radio-france :id "5602"
     :endpoint "transistor_musical_player" :www "francebleu"
     :tag "fb100pour100annees80" :www-suffix "chansons-annees-80"
     :metadata inter :mp3-prefix icecast :mp3-domain radiofrance))
  "Input data used by the URL templates to retrieve metadata, stream types, and web
links for the presentation views.")



(provide 'radio-f-radio-france)

;;; radio-f-radio-france.el ends here
