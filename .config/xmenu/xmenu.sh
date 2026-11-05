#!/bin/sh

xmenu <<EOF | sh &
Change Wallpaper	wallpick
Color Picker	colorpicker
Sniper Text	sleep 1; snipertext
Screenshot
	Select Area	sleep 1; screenshot
	Fullscreen	sleep 1; flameshot full

Web Browser
	Brave	brave
	qutebrowser	qutebrowser
Games
	Steam	steam
Terminal
	st	st
	Kitty	kitty 
	Alacritty	alacritty
Text Editor
	Neovim	st -e nvim 
	Emacs	emacs

Edit config
	Suckless
		DWM	st -e nvim $HOME/.config/suckless/dwm/config.def.h
		ST	st -e nvim $HOME/.config/suckless/st/config.def.h
		DMENU	st -e nvim $HOME/.config/suckless/dmenu/config.def.h
		DWMBLOCKS	st -e nvim $HOME/.config/suckless/dwmblocks-async/config.c
	Terminal
		Alacritty	st -e nvim $HOME/.config/alacritty/alacritty.yml
		Kitty	st -e nvim $HOME/.config/kitty/kitty.conf
		st	st -e nvim $HOME/.config/suckless/st/config.def.h
	Text Editor
		Neovim
			init.lua	st -e nvim $HOME/.config/nvim/init.lua
			options	st -e nvim $HOME/.config/nvim/lua/aeon/options.lua	
			keymaps	st -e nvim $HOME/.config/nvim/lua/aeon/keymaps.lua
			plugins	st -e nvim $HOME/.config/nvim/lua/aeon/plugins.lua
		Emacs	st -e nvim $HOME/.config/emacs/init.el
	Cava	st -e nvim $HOME/.config/cava/config
	Cmus	st -e nvim $HOME/.config/cmus/autosave
	Dunst	st -e nvim $HOME/.config/dunst/dunstrc
	Flameshot	st -e nvim $HOME/.config/flameshot/flameshot.ini
	mpv
		input.conf	st -e nvim $HOME/.config/mpv/input.conf
		mpv.conf	st -e nvim $HOME/.config/mpv/mpv.conf
	Fastfetch	st -e nvim $HOME/.config/fastfetch/config.jsonc
	Picom	st -e nvim $HOME/.config/picom/picom.conf
	Ranger
		rc.conf	st -e nvim $HOME/.config/ranger/rc.conf
		rifle.conf	st -e nvim $HOME/.config/ranger/rifle.conf
		scope.sh	st -e nvim $HOME/.config/ranger/scope.sh
	Redshift	st -e nvim $HOME/.config/redshift/redshift.conf
	sxiv	st -e nvim $HOME/.config/sxiv/exec/key-handler
	xmenu	st -e nvim $HOME/.config/xmenu/xmenu.sh
	Zathura	st -e nvim $HOME/.config/zathura/zathurarc
	Zsh
		zprofile	st -e nvim $HOME/.config/zsh/.zprofile
		zshrc	st -e nvim $HOME/.config/zsh/.zshrc
Restart DWM	pkill dwm
Lock				slock
Shutdown		poweroff
Reboot			reboot
EOF
