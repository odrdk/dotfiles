# ==============================================================
# XINITRC - DWM startup configuration (Arch Linux)
# ==============================================================

export XDG_CURRENT_DESKTOP=dwm
export XDG_SESSION_DESKTOP=dwm

systemctl --user import-environment DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP

# Paths for system and user Xresources files
sysresources=/etc/X11/xinit/Xresources
userresources=$HOME/.Xresources

# ------------------------------
# Qt theme settings
# ------------------------------

# Use qt5ct/qt6ct as the platform theme to read configuration files.
export QT_QPA_PLATFORMTHEME=qt5ct
export QT6_QPA_PLATFORMTHEME=qt6ct

# Force the cursor theme, necessary for Qt6 apps in lightweight WMs.
export QT_CURSOR_THEME=Bibata-Modern-Classic

# Set the icon theme globally (optional, as qt*ct files also set this).
export QT_QPA_PLATFORM_PLUGIN_NAME=Archdroid-Grey

# Enable scaling for HiDPI monitors (keep this if you need scaling).
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Define the GTK theme for GTK applications
export XCURSOR_THEME=Bibata-Modern-Classic
export XCURSOR_SIZE=20

# ------------------------------
# Startup applications and daemons
# ------------------------------
# Restore wallpaper (pywal)
monitores  # resolução antes do wallpaper
wal -R &

# Compositor with experimental backends (transparency, blur)
if [ -e /dev/dri/renderD128 ]; then picom & else picom --config ~/.config/picom/picom-vm.conf & fi  # sem GPU (VM sem 3D) o glx congela a tela

# Notification daemon
dunst &

# Fix reverse scroll
fixscroll &

# Status bar
dwmblocks &

# Clipboard manager
clipmenud &

# Enable numlock
numlockx on &

# Mount helper for removable devices
udiskie &

# XSettings daemon (GTK theme, icons, etc.)
xsettingsd &

# Keyboard layout: ABNT2 adaptado ao K86 (~/.local/bin/teclado)
teclado &

# Screen locker daemon
alwayslock &

# Package update notifier
updnotify &

# Polkit authentication agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# ------------------------------
# Load X resources (colors, fonts)
# ------------------------------
[ -f "$sysresources" ] && xrdb -merge "$sysresources"
[ -f "$userresources" ] && xrdb -merge "$userresources"

# ------------------------------
# Display configuration
# ------------------------------
# Configure dual-monitor setup

# ------------------------------
# Launch dwm with ssh-agent
# ------------------------------
while :; do
  ssh-agent dwm
done

# ------------------------------
# Execute wm
# ------------------------------
exec dbus-launch --sh-syntax --exit-with-session dwm
