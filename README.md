# Radio F

Radio F is a streaming library for stations under the Radio France banner.

<img src="https://raw.githubusercontent.com/cacepi/radio-f/refs/heads/main/img/dark-mode.jpg" width="635" height="529" alt="Image of Radio F interface.">

## Features
* Supports all Radio France stations and web streams.
* Customizable information display, with artwork, track data, selectable view style, and more.
* Uses your choice of [mpv](https://mpv.io/), [VLC](https://www.videolan.org/), and [EMMS](https://www.gnu.org/software/emms/) as audio backends, with access to a selection of most commonly accessed controls: volume up/down, mute/unmute, pause, play, etc.

Radio F is licensed under the GNU General Public License, Version 3. See [LICENSE](https://github.com/cacepi/radio-f/blob/main/LICENSE) for details.

## Installation
* Requires a working version of [mpv](https://mpv.io/), [VLC](https://www.videolan.org/), or [EMMS](https://www.gnu.org/software/emms/).
* Use the following `use-package` definition to grab the latest revision of the Radio F source:

<a id="use-package"></a>
```elisp
(use-package radio-f
      :vc (:url "https://github.com/cacepi/radio-f" :rev :newest)
      :load-path "~/.emacs.d/elpa/radio-f")
 ```

This will install Radio F in the packages subdirectory of `emacs-user-directory`.  Adjust this accordingly if your local packages lie elsewhere.

<!-- * Or, if you use [straight.el](https://github.com/radian-software/straight.el) for package management:
<a id="straight.el"></a>

<a id="straight"></a>
```
(use-package radio-f
  :straight (radio-f :type git :host github :repo "cacepi/radio-f"))
``` -->

## Commands
<a id="radio-f"></a> **`radio-f`**:
Starts playback of the station you've set in `radio-f-default-station`. A "Now Playing" buffer showing the currently playing song or program will open in a new window or child frame, depending on the value of [`radio-f-view-style`](#view-styles).

This function can be run non-interactively with optional argument for a specific station. For example, `(radio-f "FIP Reggae")` will start Radio F tuned to FIP's Reggae station instead of your default.

Consult the [station list](#stations) for available stations.

<a id="change-station"></a> **`radio-f-change-station`**:
Select a different station in your favorites list to play.  Refer to [the favorites setting](#radio-f-favorite-stations) to see how to make your own favorites list.

<a id="change-station"></a> **`radio-f-change-to-any-station`**:
A variant of the above, except it bypasses your favorites and shows all stations supported by Radio F  Like `radio-f`, this function also accepts a station argument.

<a id="play-default-station"></a> **`radio-f-play-default-station`**:
Returns you to the [default station](#radio-f-default-station).

**`radio-f-surprise-me`**:
Plays a random station.

<a id="dark-mode"></a>**`radio-f-dark-mode`**:
Start Radio F with no view.  See the [View Styles](#view-styles) section for more details.

**`radio-f-down`**:
Exits Radio F.

## Helper Functions
<a id="resize-window-view"></a>**`radio-f-resize-window-view`**:

Sometimes window view can get fail to properly size itself after changing the station.  This function resizes the view to the smallest it needs to be to display all the information that's inside the buffer.

This function is bound to `C-c f '` by default.

<a id="browse-station-page"></a>**`radio-f-browse-station-page`**:

Opens your browser for the page of the currently playing station.

This function is bound to `C-c f w` by default.

**Note**: Radio France sets the page for local stations via a cookie, so you can't visit local stations directly.  Instead, this function will go to Radio France's local station portal, where you must pick the station page you want to see. Click the button labelled "Choisir une locale" for your choice.


<a id="view-styles"></a>
## View Styles:

Radio F has two different views for displaying track metadata: `'window`, and `'frame`:

* Frame view shows track metadata and accompanying artwork in a child frame attached to the calling parent. It will stay at the same position relative to its parent whenever the parent is resized.

* Window view shows the same information as frame view by default, except the display is in a normal window at the bottom the Emacs frame.  This view is intended for TUI Emacs users, and tries to provide the most compact view possible to preserve precious screen space.  In TUI Emacs sessions, artwork display and the track timeline are disabled.

<img src="https://raw.githubusercontent.com/cacepi/radio-f/refs/heads/main/img/radio-f-tui.png" width="656" height="646" alt="Image of Radio F in window view style.">

* A third, pseudo "no view" mode can be enabled by starting Radio F with `radio-f-dark-mode`.  JSON fetch still occurs as normal, artwork is still downloaded and inserted into both views, but the view is not displayed until you call `radio-f-toggle-view` (bound to `C-c f v` by default).

* The view toggle is also available in both normal window and frame views.

A word of caution: the view toggle works by running `make-frame-visible` and `make-frame-invisible` on the frame view, which might cause display issues with the child frame if you toggle too quickly.  Give it a second or two after toggling before running again.


## Custom Variables

<a id="radio-f-player-program"></a>**`radio-f-player-program`**: preferred player program. Accepted values are:

* `emms`- [Emacs Multimedia System](https://www.gnu.org/software/emms/)
* `vlc` - [VLC Media Player](https://www.videolan.org/vlc/)
* `mpv` - [mpv](https://mpv.io)\*

`vlc` and `mpv` must be in a directory contained in the Emacs `exec-path`.  If you've installed them with a package manager like Homebrew or your distro's package installer, you should have no problems.  If you're installed them into a non-standard directory location, you'll need to add it to the Emacs `exec-path`:

```elisp
  (add-to-list 'exec-path
               (expand-file-name "/directory/to/mpv/or/vlc") t nil)
```

\* Graphical shells for mpv that utilize `libmpv` for playback (IINA, mpvnet, Baka Mplayer, Celluloid, etc.) are not supported.

The default is `vlc`.


<a id="radio-f-stream-type"></a>**`radio-f-stream-type`**: choice of audio stream.

* `'hls` plays a variable bitrate AAC encoded HLS stream.
* `'aac` plays a fixed bitrate AAC encoded stream at 192kbps.
*  `'mp3` plays a fixed bitrate MP3 encoded stream at 128kbps.

The default is `'hls`.

<a id="radio-f-view-style"></a>**`radio-f-view-style`**: Sets the preferred view Style. Can be either `'frame` or `'window`. Refer to the [View Styles section](#view-styles) for more details.

The default is `'frame`.

<a id="radio-f-favorite-stations"></a>**`radio-f-favorite-stations`**: list favorite stations for completion.  A nil value shows all stations.

Radio F currently supports 79 stations.  Scrolling through that list to change stations is... well, it's not fun. So, instead:

`customize-option [RETURN] radio-f-favorite-stations [RETURN]` presents you with a checkbox list to select only those stations that you want to see.

Or if you really hate to use Custom - and who doesn't? - you can copy the stations you want from the [station list](#station-list) and place them in your `use-package` definition for Radio F.  For example:

```elisp
:init  ;; Can be in :config instead if you want.
(setq radio-f-favorite-stations
    "ici Bearn" "FIP" "FIP Rock" "FIP Jazz" "FIP Groove" "FIP Monde"
    "FIP Nouveautés" "FIP Reggae" "FIP Electro" "FIP Metal" "FIP Pop"
    "FIP Hip-Hop" "FIP Sacré Français!" "FIP Cultes")
```

will only show those 14 stations when you run `radio-f-change-station` instead of all 79.

<a id="radio-f-artwork-size"></a>**`radio-f-artwork-size`**:

The size, in pixels, of the artwork image's height and width.

The default is `240`.

<a id="radio-f-show-artwork"></a>**`radio-f-show-artwork`**:

Show artwork in either frame of window view: `t` shows artwork, `nil` disables it.

The default is `t`.

<a id="radio-f-show-track-info"></a>**`radio-f-show-track-info`**:

Show track info in either frame of window view: `t` shows track info, `nil` disables it.

The default is `t`.

<a id="radio-f-show-track-timeline"></a>**`radio-f-show-track-timeline`**:

Display a timer showing the playing time of the current track: `t` shows the timer, `nil` shows no timer.

The default is `t`.

<a id="radio-f-artwork-border-width"></a>**`radio-f-frame-artwork-border-width`**:

Width of the border, in pixels, that's around the artwork image. Set this to `0` if you don't want a border.

The default is `2`.

<a id="radio-f-artwork-radius"></a>**`radio-f-artwork-radius`**:

Radius in pixels of the artwork's rounded corners in both frame and window view.  Set this to `0` if you don't want to round off the corners.

The default is `16`.

<a id="radio-f-default-volume"></a>**`radio-f-default-volume`**:

Set the initial volume level for station playback.  The same level is used for both mpv and VLC.

This setting is not available in EMMS.

The default is `70`.

<a id="radio-f-default-station"></a> **`radio-f-default-station`**:

The station played when Radio F starts.

Refer to the [station list](#stations) for all the stations supported under Radio F.

The default is `"FIP"`.

## Faces:

<a id="radio-f-default-face"></a>**`radio-f-default`**:

Define the underlying base face applied to the text in the track info buffer.  This face is used in both frame and window view.

The default is `:inherit (variable-pitch)`.

<a id="radio-f-bold-face"></a>**`radio-f-bold`**:

Face used for the artist of the playing track.  This face is used in both frame and window view.

The default is `:inherit (radio-f-default) :weight bold`.

<a id="radio-f-timer-face"></a>**`radio-f-timer`**:

Face used for the track timeline.  This face is used in both frame and window view.

The default is `:inherit (default) :height 0.9 :weight bold`.

## Keybindings:

<a id="keybinds"></a> Keybinds are defined in the minor mode `radio-f-control-mode-keymap`:

```elisp
  "C-c f r"   #'radio-f
  "C-c f a"   #'radio-f-change-to-any-station
  "C-c f c"   #'radio-f-change-station
  "C-c f d"   #'radio-f-play-default-station
  "C-c f m"   #'radio-f-dark-mode
  "C-c f o"   #'radio-f-down
  "C-c f v"   #'radio-f-toggle-view
  "C-c f w"   #'radio-f-browse-station-page
  "C-c f ?"   #'radio-f-surprise-me
  "C-c f '"   #'radio-f-resize-window-view
  "<f7>"      #'radio-f-play-default-station
  "<f8>"      #'radio-f-pause-audio    ;; hit again to unpause
  "<f9>"      #'radio-f-change-station
  "<f10>"     #'radio-f-mute-audio     ;; hit again to unmute
  "<f11>"     #'radio-f-volume-down
  "<f12>"     #'radio-f-volume-up)
  ```

You can also change volume with the mouse wheel while the mouse cursor is inside a view;  wheel up to increase volume, wheel down to decrease.

## Tips:

* You can remove the minor mode lighters that Radio F installs in the modeline by including a `:delight` clause in your `use-package` definition like so:
```
:ensure delight ; installs the delight package: does nothing if already installed
:delight
(radio-f-control-mode) ; if using 'frame view
(buffer-face-mode) ; if using 'window view
```

* Did I mentions the favorites list? Only like 11 times already?  Let's make it an even dozen: go to the [station list](#stations) to learn how to build your list.  Your `n` and `p` keys - or arrow keys if you swing that way - will thank you.

* The VLC remote interface is over a network connection, and you can control it directly via telnet:

```
telnet localhost 1971
```

Have fun!

## Future Plans:

- Support for more stations, such the BBC, RTE, etc.

- A record of the songs played during a listening session.

You can do this already by visiting Radio France's website with the function `radio-f-browse-station-page`, but that only works with select stations.  I think a more personalized version can made by constructing a track log and generate a PDF file or similar upon exiting Radio F.

## Not Future Plans:

- More audio backends.  Playback has three player choices, one of which itself supports several, several, _several_ various playback engines.  Those three should cover 99%+ of people who would be interested in this project.

- Ability to add stations through Custom. This will potentially absolutely almost probably certainly never happen.

## Stations Supported in Radio F

How to make a favorites list again:  copy the stations you want from the station list and place them in your `use-package` definition for Radio F.  For example:

```elisp
:init  ;; Can be in :config instead if you want.
(setq radio-f-favorite-stations
    "ici Bearn" "FIP" "FIP Rock" "FIP Jazz" "FIP Groove" "FIP Monde"
    "FIP Nouveautés" "FIP Reggae" "FIP Electro" "FIP Metal" "FIP Pop"
    "FIP Hip-Hop" "FIP Sacré Français!" "FIP Cultes")
```

will only show those 14 stations when you run `radio-f-change-station` instead of all 79.

<pre>
"FIP"
"France Inter"
"France Info"
"France Musique"
"France Culture"
"Mouv'"
"FIP Rock"
"FIP Jazz"
"FIP Groove"
"FIP Monde"
"FIP Nouveautés"
"FIP Reggae"
"FIP Electro"
"FIP Metal"
"FIP Pop"
"FIP Hip-Hop"
"FIP Sacré Français!"
"FIP Cultes"
"ici RCFM"
"ici Alsace"
"ici Armorique"
"ici Auxerre"
"ici Bearn"
"ici Belfort-Montbéliard"
"ici Berry"
"ici Besançon"
"ici Bourgogne"
"ici Breizh Izel"
"ici Champagne-Ardenne"
"ici Normandie (Calvados - Orne)"
"ici Creuse"
"ici Drôme Ardèche"
"ici Gard Lozère"
"ici Gascogne"
"ici Gironde"
"ici Hérault"
"ici Isère"
"ici La Rochelle"
"ici Limousin"
"ici Loire Océan"
"ici Lorraine (Meurthe-et-Moselle et Vosges)"
"ici Mayenne"
"ici Nord"
"ici Cotentin"
"ici Normandie (Seine-Maritime - Eure)"
"ici Orléans"
"ici Pays d'Auvergne"
"ici Pays Basque"
"ici Pays de Savoie"
"ici Périgord"
"ici Picardie"
"ici Provence"
"ici Roussillon"
"ici Touraine"
"ici Vaucluse"
"ici Azur"
"ici Lorraine (Moselle et Pays Haut)"
"ici Poitou"
"ici Paris Île-de-France"
"ici Elsass"
"ici Maine"
"ici Occitanie"
"ici Saint-Étienne Loire"
"France Musique Classique Easy"
"France Classique Plus"
"France Musique Concerts"
"Ocora Musiques du Monde"
"France Musique La Jazz"
"France Musique La Contemporaine"
"Musique de Films"
"France Musique La Baroque"
"France Musique Opéra"
"France Musique Piano Zen"
"France Musique Classique Love"
"La musique d'Inter"
"Mon petit France Inter"
"Mon tout petit France Inter"
"100% Chanson Française"
"100% années 80"
</pre>


## Items to Note:

### SVG support encouraged, but no required.

Radio F uses the Emacs `svg` library to generate the rounded corners for the view artwork. The program will work without it; you just won't see those oh-so-sexy RoundRects in the artwork image:

<img src="https://raw.githubusercontent.com/cacepi/radio-f/refs/heads/main/img/square-vs-rounded.png" width="600" height="470" alt="Display differences between an Emacs with SVG support and one without.">

### Radio F est en direct.

Radio F plays back live radio, and the JSON feed can go sideways from time to time, mainly due to station breaks or interruptions of regularly scheduled programming with live coverage. In those cases, the metadata usually contains a single value, "Le direct" ("live coverage" in French) and has no other useful information.

<!-- La radio la plus éclectique du monde -->

This means a user can start Radio F when the JSON feed is in a "Le direct" state, and no track info will appear on startup.  This is intentional: if there's nothing to show... well, you know the rest.

_C'est la vie, mon ami._
