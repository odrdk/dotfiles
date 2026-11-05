#!/bin/sh
# Sessão dwm. O systemd já entrega o barramento dbus do usuário.

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

[ -f /etc/X11/xinit/Xresources ] && xrdb -merge /etc/X11/xinit/Xresources
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

setxkbmap br
numlockx on

# Layout de monitor externo é por máquina e fica fora do repositório.
if [ -x "$HOME/.screenlayout/hdmi.sh" ] && xrandr | grep -q '^HDMI-[0-9]* connected'; then
  "$HOME/.screenlayout/hdmi.sh"
fi

wal -R &
picom &
dunst &
dwmblocks &
clipmenud &
udiskie &
xsettingsd &
mpd &

# dwm reinicia sozinho: dwall e Super+Shift+R dependem deste laço.
while :; do
  ssh-agent dwm
done
