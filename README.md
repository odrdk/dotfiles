<div align="center">

![](/img/raven.png)
## /home/emnesty/dotfiles


[![](https://img.shields.io/github/stars/emnesty1/dotfiles?color=grey&logo=apachespark&logoColor=white&style=for-the-badge&labelColor=black)](https://github.com/emnesty1/dotfiles/stargazers)
[![](https://img.shields.io/github/last-commit/emnesty1/dotfiles?&logo=github&style=for-the-badge&color=grey&logoColor=white&labelColor=black)](https://github.com/emnesty1/dotfiles/commits)
[![](https://img.shields.io/github/repo-size/emnesty1/dotfiles?color=grey&logo=hackthebox&logoColor=white&style=for-the-badge&labelColor=black)](https://github.com/emnesty1/dotfiles)

![](/img/1.png)
![](/img/2.png)
![](/img/3.png)
![](/img/pywal.gif)


</div>

<div align="center">

```
Setup / DWM
```

</div>

```
Distro          -> Arch Linux
Editor          -> NeoVim
Browser         -> Firefox 
Shell           -> zsh
Process Viewer  -> btop

Music Player    -> cmus
Compositor      -> picom
Notifications   -> dunst
Media Player    -> mpv
File Manager    -> ranger

WM              -> dwm
Terminal        -> st
App Laucher     -> dmenu
Theme           -> pywal
Font            -> JetBrainsMono NF
```

<div align="center">

```
Installation
```

</div>

<details>
  <summary><b>Manual</b></summary>

<br>

> Assuming your <b>AUR Helper</b> is [yay](https://github.com/Jguer/yay). 
```
yay -S cava slop devour exa tty-clock-git picom-jonaburg-git cmatrix-git pipes.sh checkupdates+aur libnotify wal-telegram-git poppler npm p7zip epub-thumbailer-git python-pdftotext python-pywalfox tesseract-data-eng tesseract-data-por arandr clipmenu zsh playerctl dbus simple-mtpfs dunst feh ffmpeg ffmpegthumbnailer firefox flameshot fzf git gnu-free-fonts go htop imagemagick mpv neofetch neovim noto-fonts noto-fonts-cjk noto-fonts-emoji numlockx obs-studio openssh perl pulseaudio pulsemixer python-pip python-pywal ranger syncthing sxiv telegram-desktop tmux tree ttf-jetbrains-mono-nerd ttf-font-awesome gpick ueberzug redshift unzip vim webkit2gtk xclip yt-dlp zathura zathura-djvu zathura-pdf-mupdf zip xorg-server xorg-xinit libx11 libxinerama libxft base base-devel
```

```
git clone https://github.com/emnesty1/dotfiles.git
```
> Create [symbolic links](https://www.freecodecamp.org/news/linux-ln-how-to-create-a-symbolic-link-in-linux-example-bash-command/) to the files/directories you need.
</details>

<details>
  <summary><b>Automatic</b></summary>

<br>

> Install [git](https://github.com/git/git)

```
sudo pacman -Syu git
```

> Clone this repo 

```
git clone https://github.com/emnesty1/dotfiles.git
```

> Go to folder

```
cd dotfiles/
```

> Give permission to the script

```
chmod +x install
```

> Execute the script

```
./install
```

</details>

<div align="center">

```
Suckless Build
```

</div>

<details>
  <summary><b>DWM Patches</b></summary>

<br>

|                     |                     |    
| ------------------- | ------------------- |
| cfacts              | exitmenu            |
| hidevacanttags      | movestack           |
| noborderfloatingfix | pertag              |
| preserveonrestart   | resizecorners       |
| scratchpads         | statuscmd           |
| steam               | swallow             |
| truecenteredtitle   | vanitygapscombo     |
| xresources          |                     |
|                     |                     | 

> All patches and their information can be found at this [link](https://dwm.suckless.org/patches/).

</details>

<details>
  <summary><b>ST Patches</b></summary>

<br>

|                   |                     |
| ----------------- | ------------------- |
| alpha             | anysize             |
| boxdraw           | patch_column        |
| scrollback-mouse  | scrollback          |
| workingdir        | xresources          |
|                   |                     |  

> All patches and their information can be found at this [link](https://st.suckless.org/patches/).

</details>

<details>
  <summary><b>DMENU Patches</b></summary>

<br>

|                   |                     | 
| ----------------- | ------------------- |
| alpha             | border              |
| caseinsensitive   | center              |
| highlight         | numbers             |
| password          | xresources          |
|                   |                     |

> All patches and their information can be found at this [link](https://tools.suckless.org/dmenu/patches/).

</details>

<details>
  <summary><b>Keybinds</b></summary>

<br>

- `Super` + `Enter` = <i>Create a new terminal.</i>
- `Super` + `Shift` + `Q` = <i>Close a window.</i>
- `Super` + `Shift` + `R` = <i>Restart DWM.</i>
- `Super` + `LeftArrow`, `RightArrow` = <i>Move to another window.</i>
- `Super` + `M` = <i>Monocle layout.</i>
- `Super` + `T` = <i>Tiled layout.</i>
- `Super` + `F` = <i>Spiral layout.</i>
- `Super` + `U` = <i>Centered master layout.</i>
- `Super` + `O` = <i>Grid layout.</i>
- `Super` + `B` = <i>Toggle the top bar.</i>
- `Super` + `Shift` + 1/5 = <i>Move a window to another tag.</i>
- `Super` + `1/5` = <i>Switch to another tag.</i>
- `Super` + `I` = <i>Increment master.</i>
- `Super` + `D` = <i>Decrement master.</i>
- `Super` + `H` = <i>Move mfact to the left.</i>
- `Super` + `L` = <i>Move mfact to the right.</i>
- `Super` + `K` = <i>Move cfact down.</i>
- `Super` + `J` = <i>Move cfact up.</i>
- `Super` + `Space` = <i>Toggle last layout.</i>
- `Super` + `Shift` + Space = <i>Toggle floating window.</i>
- `Super` + ``=`` = <i>Increment gaps.</i>
- `Super` + ``-`` = <i>Decrement gaps.</i>
- `Super` + `Alt` + 0 = <i>Restore gaps.</i>
- `Super` + `Shift` + = = <i>Increment vertical gaps.</i>
- `Super` + `Shift` + - = <i>Decrement vertical gaps.</i>
- `Super` + `Control` + = = <i>Increment horizontal gaps.</i>
- `Super` + `Control` + - = <i>Decrement horizontal gaps.</i>
- `Super` + `Alt` + ``=`` = <i>Increment inside gaps.</i>
- `Super` + `Alt` + ``-`` = <i>Decrement inside gaps.</i>
- `Super` + `F1` = <i>Open file manager.</i>
- `Super` + `F2` = <i>Open browser.</i>
- `Super` + `F3` = <i>Open messaging application.</i>
- `Super` + `F4` = <i>Open music player.</i>
- `Super` + `F5` = <i>Open code editor.</i>
- `Super` + `F6` = <i>Open audio manager.</i>
- `Super` + `F7` = <i>Open screen recorder.</i>
- `Super` + `F11` = <i>Lockscreen.</i>
- `Super` + `F12` = <i>Open calculator.</i>
- `Super` + `Shift` + N = <i>Toggle nightmode.</i>
- `Super` + `Shift` + E = <i>Theme selector.</i>
- `Super` + `Control` + E = <i>Emoji selector.</i>
- `Super` + `Shift` + S = <i>Manage dotfiles.</i>
- `Super` + `Shift` + Y = <i>Manage clipboard.</i>
- `Super` + `PrtSc` = <i>Fullscreen screenshot.</i>
- `PrtSc` = <i>Screenshot of the selected area.</i>
- `AudioLowerVolume` = <i>Volume control down.</i>
- `AudioRaiseVolume` = <i>Volume control up.</i>
- `AudioMute` = <i>Toggle mute.</i>
- `Alt` + `Z` = <i>Toggle mute mic.</i>
- `MonBrightnessUp` = <i>Increment brightness.</i>
- `MonBrightnessDown` = <i>Decrement brightness.</i>
- `Super` + `Shift` + `P` = <i>Power Menu.</i>
- `Super` + `P` = <i>Open DMENU.</i>

</details>

