#!/usr/bin/env bash

# Normal
color00="fd/f6/e3" # Black
color01="dc/32/2f" # Red
color02="85/99/00" # Green
color03="b5/89/00" # Yellow
color04="26/8b/d2" # Blue
color05="6c/71/c4" # Magenta
color06="2a/a1/98" # Cyan
color07="58/6e/75" # White

# Bright
color08="83/94/96" # Bright Black
color09="dc/32/2f" # Red
color10="85/99/00" # Green
color11="b5/89/00" # Yellow
color12="26/8b/d2" # Blue
color13="6c/71/c4" # Magenta
color14="2a/a1/98" # Cyan
color15="00/2b/36" # Bright White

# 256 color
color16="cb/4b/16" # Orange
color17="d3/36/82" # OrangeRed
color18="ee/e8/d5" # Black5%
color19="93/a1/d5" # Black10%
color20="65/7b/a1" # White5%
color21="07/36/42" # White10%

# Base
color_background="fd/f6/e3" # Black
color_foreground="58/6e/75" # White

if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() {
    printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' "$@"
  }
  put_template_var() {
    printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' "$@"
  }
  put_template_custom() {
    printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' "$@"
  }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() {
    printf '\033P\033]4;%d;rgb:%s\007\033\\' "$@"
  }
  put_template_var() {
    printf '\033P\033]%d;rgb:%s\007\033\\' "$@"
  }
  put_template_custom() {
    printf '\033P\033]%s%s\007\033\\' "$@"
  }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() {
    [ "$1" -lt 16 ] && printf "\e]P%x%s" "$1" "$(echo "$2" | sed 's/\///g')"
  }
  put_template_var() {
    true
  }
  put_template_custom() {
    true
  }
else
  put_template() {
    printf '\033]4;%d;rgb:%s\033\\' "$@"
  }
  put_template_var() {
    printf '\033]%d;rgb:%s\033\\' "$@"
  }
  put_template_custom() {
    printf '\033]%s%s\033\\' "$@"
  }
fi

# 16 color space
put_template 0 $color00
put_template 1 $color01
put_template 2 $color02
put_template 3 $color03
put_template 4 $color04
put_template 5 $color05
put_template 6 $color06
put_template 7 $color07
put_template 8 $color08
put_template 9 $color09
put_template 10 $color10
put_template 11 $color11
put_template 12 $color12
put_template 13 $color13
put_template 14 $color14
put_template 15 $color15

# 256 color space
put_template 16 $color16
put_template 17 $color17
put_template 18 $color18
put_template 19 $color19
put_template 20 $color20
put_template 21 $color21

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg 586e75 # foreground
  put_template_custom Ph fdf6e3 # background
  put_template_custom Pi 002b36     # bold color
  put_template_custom Pj fdf6e3 # selection color
  put_template_custom Pk b58900     # selected text color
  put_template_custom Pl 586e75 # cursor
  put_template_custom Pm fdf6e3 # cursor text
else
  put_template_var 10 $color_foreground
  if [ "$WALH_SHELL_SET_BACKGROUND" != false ]; then
    put_template_var 11 $color_background
    if [ "${TERM%%-*}" = "rxvt" ]; then
      put_template_var 708 $color_background # internal border (rxvt)
    fi
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color16
unset color17
unset color18
unset color19
unset color20
unset color21
unset color_foreground
unset color_background