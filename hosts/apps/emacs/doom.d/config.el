;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "David Beley"
      user-mail-address "dddd@netc.fr")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; :family "Iosevka Nerd Font"
;; :weight 'normal
;; :width 'normal
;; :height 110
;; :slant 'italic
;; )
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 13 :weight 'normal :height 110)
      doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-rouge)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Nextcloud/03_org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! counsel
  (setq counsel-rg-base-command
        "rg -M 240 --hidden --with-filename --no-heading --line-number --color never %s"))

(use-package! ox-hugo
  :ensure t
  :after ox)

(use-package! ox-reveal
  :ensure t
  :after ox)

(use-package! ox-twbs
  :ensure t
  :after ox)

(setq org-html-indent 'nil)

(after! org (setq org-capture-templates
                  '(
                    ;; idées : sport, calendrier, achats, journal
                    ;;
                    ("t" "TODO          (t) Todo" entry (file+olp "Journal.org" "Tâches")
                     "* [ ] [%t] %?")
                    ("n" "NOTES         (n) Notes" entry (file+olp+datetree "Journal.org" "Notes")
                     "* [%t] %?")
                    ("s" "SPORT         (s) Sport" entry (file+olp+datetree "Journal.org" "Sport")
                     "* [%t] %?")
                    ("b" "BEETS         (b) Beets (music to download)" entry (file+olp "Musique.org" "Beets")
                     "* [ ] [%t] %?")
                    )
                  )
  )
