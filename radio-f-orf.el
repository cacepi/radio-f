;;; radio-f-orf.el --- ORF plugin for Radio F -*- lexical-binding: t; -*-

;; Author: Jason Martens
;; URL: https://github.com/cacepi/radio-f
;; Created: Mon 9 Nov 26
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
;; ORF plugin for Radio F: 14 Stations.
;; Artwork retrieval currently broken.

;;; Code:

;; == STATION PLIST =====

(defconst radio-f--orf-stations
  '((hitradio-O3
     :name "ORF Hitradio Ö3" :carrier orf :id "oe3"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/hitradio-0e3.png")
    (orf-radio-01
     :name "ORF Radio Ö1" :carrier orf :id "oe1"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-oe1.png")
    (orf-fm4
     :name "ORF FM4" :carrier orf :id "fm4"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/fm4-logo.png")
    (orf-salzburg
     :name "ORF Radio Salzburg" :carrier orf :id "sbg"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-salzburg.png")
    (orf-steiermark
     :name "ORF Radio Steiermark" :carrier orf :id "stm"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-steiermark.png")
    (orf-voralberg
     :name "ORF Radio Vorarlberg" :carrier orf :id "vbg"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-veralberg.png")
    (orf-oberosterreich
     :name "ORF Radio Oberösterreich" :carrier orf :id "ooe"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-oberosterreich.png")
    (orf-wien
     :name "ORF Radio Wien" :carrier orf :id "wie"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-wien.png")
    (orf-niederosterreich
     :name "ORF Radio Niederösterreich" :carrier orf :id "noe"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-noe.png")
    (orf-tirol
     :name "ORF Radio Tirol" :carrier orf :id "tir"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-tirol.png")
    (orf-karnten
     :name "ORF Radio Kärnten" :carrier orf :id "ktn"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-karnten.png")
    (orf-burgenland
     :name "ORF Radio Burgenland" :carrier orf :id "bgl"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-music.png")
    (orf-slovenski
     :name "ORF Radio Slovenski Spored" :carrier orf :id "slo"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-oe1.png")
    (orf-oo1-campus
     :name "ORF Radio Ö1 Campus" :carrier orf :id "campus"
     :api radio-f--orf-api-url :processor radio-f--orf-processor
     :visual "assets/orf/orf-oe1.png"))
  "Input data used by the URL templates to retrieve metadata, stream types,
and web links for the presentation views.")


;; == API URLS ==========

(defconst radio-f--orf-api-url
  "https://audioapi.orf.at/<<id>>/api/json/5.0/broadcast/onair"
  "Template to retrieve metadata for ORF Radio.")


;; == STREAM URLS =======

(defconst radio-f--orf-level-one
  "https://orf-live.ors-shoutcast.at/<<id>>-q2a"
  "Template used to return a Level One audio stream for playback.")


;; == STREAM LEVELS =====

(defconst radio-f--orf-streams
  `((One     . ,radio-f--orf-level-one)
    (_       . ,radio-f--orf-level-one))
  "Audio stream templates provided by ORF.")


;; == PROCESSORS ================================

(defun radio-f--orf-processor (data station)
  "Process ORF JSON DATA for STATION."
  (let* ((name (plist-get station :name))
         (payload (cdr (assoc "payload" data)))
         (now (cdr (assoc "item" payload)))
         (images (cdr (assoc "images" now)))
         ;; (zero (cdr (assoc "0" images)))
         ;; (img-versions (cdr (assoc "versions" zero)))
         ;; (img (aref img-versions 0))
         (artist (cdr (assoc "interpreter" now)))
         (title (cdr (assoc "title" now)))
         (start (time-convert
                 (date-to-time
                  (cdr (assoc "start" now)))
                 'integer))
         (end (time-convert
               (date-to-time
                (cdr (assoc "end" now)))
               'integer))
  ;;       (visual-url (cdr (assoc "path" img)))
         (item-id (cdr (assoc "id" now))))
    `((name       . ,name)
      (item-id    . ,item-id)
      (artist     . ,artist)
      (title      . ,title)
      (start      . ,start)
      (end        . ,end))))
;;      (visual-url . ,visual-url))))


(provide 'radio-f-orf)
