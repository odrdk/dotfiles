#!/usr/bin/env bash
# Tema "cohle" do GRUB: menu à esquerda, Rust Cohle (arte do dashboard do Neovim) em ASCII ao fundo.
# Uso: sudo bash tema-boot.sh
set -euo pipefail
[[ $EUID -eq 0 ]] || { echo "Rode com sudo: sudo bash tema-boot.sh"; exit 1; }

TEMA=/boot/grub/themes/cohle
NOME=${NOME:-Arthos}

pacman -S --needed --noconfirm grub freetype2 fontconfig imagemagick python os-prober >/dev/null

# Comfortaa é a fonte do exemplo; sem ela, Noto Sans. A arte sempre em mono.
texto=$(fc-list : file family | grep -i -m1 'comfortaa' | cut -d: -f1 || true)
[[ -n $texto ]] || texto=$(fc-match -f '%{file}' 'Noto Sans:style=Regular')
mono=$(fc-match -f '%{file}' 'JetBrainsMono Nerd Font Mono:style=Regular')
echo ">> Fonte do menu: $texto"

rm -rf "$TEMA"; mkdir -p "$TEMA"
grub-mkfont -s 28 -o "$TEMA/titulo.pf2" "$texto"
grub-mkfont -s 19 -o "$TEMA/menu.pf2" "$texto"
grub-mkfont -s 14 -o "$TEMA/rodape.pf2" "$texto"

nome_pf2() { python3 - "$1" <<'PY'
import sys, struct
d = open(sys.argv[1], 'rb').read()
i = d.index(b'NAME') + 4
n = struct.unpack('>I', d[i:i+4])[0]
print(d[i+4:i+4+n].rstrip(b'\0').decode())
PY
}
ft=$(nome_pf2 "$TEMA/titulo.pf2"); fm=$(nome_pf2 "$TEMA/menu.pf2"); fr=$(nome_pf2 "$TEMA/rodape.pf2")

arte=$(cat <<'ARTE'
/#######,%%%%,,%%  %%%%(%%%**%%%%%%#%%%%/(%##(#%#%*%%%%%(%%%%#%%,#%(  /%# ###%&@
#( .*##.#%%%%%%%%%%%%%%#*,(#%(#%%/(%%.,%%#(,#/.%((%%%%,%%%%%%%%%%%%%*.(#%%%&@@@@
###/%.%%%%%%%%%%/(%%#%%%%%%%%%*./ #.%%%( .,%/./#*,(%#%#   ,%%%%%%%%%%#((%&@**&@@
(%#%%%%%%%%%%%&&%%&%%%%( .%  /( #%###%%%%#. # %* ,,#%.#*/%#/%%%%%%%%%%%&@%%&&##&
%#%%%%%%%##%%&&&&%/ %%%%%%//*#((#*%%#%.#%%%#%%%%%%/#,/**,,%.%%%%%%%#&&@#@@@@&&&&
%%%%%%%/%%#%%%&&&(*##    #(#(#(#.. . .   .%((%%%%%%%/%%*,/// %%%%&#&%&@@@@&&%%/#
% %%%%%%%%%(,&&&&/#,(%/  ./#*....,*/.,.,..... *#%%/%%./,/,  .#%%&&(*&&&&&&%%&&&@
%%%%%%%%%%%%%% *&*(% % *,,/ .,.      . ..    ...,, .%/%,# **#%&&&&&&&&&&&&@@@@#/
%&%%%%%%%%%%%%& %&.# #*%% .  ...,(((#((###(((* ., .. ,#%%/ .%%&&&@,@%&@@,@@@@( @
&@ %%%&% % #%%( %%%.*#(.( .,  *(#((..%##,*#(//(/ ,   .%%,&#&%&&&&& (@&(@&@@@@@@#
@@@@@@%%%%*. ,,%,&.   /&& .. .(#//( %### &./##(/, ,  ., %. &&&&&%#&,&%&&&@@&&@@@
@@@@@%% %%%#,%( &&* & %&&*,. *///(((.  .,%#%#(,/,*   . //%%#&&&&&&###(%@@@@@@@@@
@@@&@@%%%%%.%(%&%.&/.#&(%*  ,/.      .***,.    ..**  /%%.*,%&/ & % &&&&@@@@&@&.(
@@%&@&&% %, *%@&& %@@ /##.  */        .#(.,..   *,* *  %%%%*%,%%#%&,&&&&&&&%@@@@
@@@@@&&&**% &&&&@@*.@(&#/.. /*/#*((/*(*#(*(#,*(##/*. .#%%%/ ,%&#/ .%&&@&@@%(@@@@
@@&&%@(&%*&&&%@@@@,@@../.%,.*(,**##((./#(/,((/*(,.*.,,%#*%#(%&&%%%%%%@@@@&@@@..@
@#&&&&&//&&&%@@@@@ &/ .  *%..*.. ,**/      &/*,..,, .%.&%%%  //%%%%%@@@@@@@@@@@@
&&&@@ @@@ @@@@@@@@&,&@&.%*.*%&,..,,((... ,*(/*,,,,,%.%,  %#* *##%&&@@@@@@@&@@@@@
&#,@@@@@@ @@@@@@@@&&@&&&# %% %*,*/,.   ***   .,.../%/  &&#%%%&&@@@@@@&@@@@&@@@@@
@@#*@@@/@,@ @@@%@&&&&%&&.#%%,& ,,,             .,.#( &&%& %%%@@@@@@@@@@@@@@@@@@@
@@@@@@*@@ &@@@&&@&&@@&@(%%%%&%/.   . ,///**,.  . ,.% *&%,.(@@/ @@@@@@@@@@%@@. &@
@@@@@@&@#@@@@&  #&@&@@&%%%%%%%/,   .           ..,,.  ,(&@ @@*@@@@@//(@@@@@@@@ @
/%@@/@@*/@@ @.%%&@@%@&(%%%/@. /..    ..       .... ,   @@@@@* #@@@@@@@@ *@@%@//%
@@@%,/,@@@@@@ &&@@@&@&@&&     .*.     ..       .  *,       *@@@@@.&@@%@@@@@@@@@@
@@@@@@@@@@@@,@(@@& &@          /(                **,            @@@@@&@@@@@@@@@@
@@*#@@@ .@@@,//%%&             .(#              */*.                /@@@@@@@@@@@
@&@@@@@@@@@@&,                  */(#          ,****.                    @@@@@@@@
@@@@@@@@,                       ***//%       /***,,.                       @@@@@
@/@@.&@@@                       ,///(  /(  ,(     ..                         @@@
&@@%@@@                          *.  .   ./                                  @@@
@@@@@@                                ,.                                     @@@
@@@@@@                              .  .                                     @@@
@@@@@@                              ., .        .                            @@@
@@@@@%                               ,..       .                              @@
@@@@@                                .,                                       &@
@@@@*                                 .                                       .@
@@@@                                  .                                        @
&&@,                                                                           ,
%%@                                                                             
ARTE
)

# Fundo 1920x1080 (o GRUB estica para a tela). Arte em dois tons: @&%# claros, o resto escuro,
# sumindo na borda esquerda e no pé para se misturar ao fundo.
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
desenha() { magick -background none -font "$mono" -pointsize 18 -interline-spacing 3 -fill "$1" label:"$2" "$3"; }
desenha '#3e3e44' "$(sed 's/[@&%#]/ /g' <<< "$arte")" "$tmp/claro.png"
desenha '#85858d' "$(sed 's/[^@&%#]/ /g' <<< "$arte")" "$tmp/denso.png"
magick "$tmp/claro.png" "$tmp/denso.png" -background none -layers merge "$tmp/arte.png"
read -r w h < <(magick identify -format '%w %h' "$tmp/arte.png")
magick -size "${w}x${h}" -define gradient:vector=0,0,$(( w * 35 / 100 )),0 gradient:black-white   \( -size "${w}x${h}" -define gradient:vector=0,$h,0,$(( h * 78 / 100 )) gradient:black-white \)   -compose multiply -composite "$tmp/mascara.png"
magick "$tmp/arte.png" \( +clone -alpha extract "$tmp/mascara.png" -compose multiply -composite \)   -alpha off -compose CopyOpacity -composite "$tmp/arte.png"
magick -size 1920x1080 radial-gradient:'#1b1b1e'-'#09090a' "$tmp/arte.png"   -gravity east -geometry +110+0 -compose over -composite "$TEMA/fundo.png"

# Caixa arredondada da seleção, fatiada em 9 pedaços.
magick -size 24x24 xc:none -fill '#ffffff12' -stroke '#7a7a80' -strokewidth 1.5 \
  -draw 'roundrectangle 1,1 22,22 6,6' "$TEMA/caixa.png"
for p in nw:6x6+0+0 n:12x6+6+0 ne:6x6+18+0 w:6x12+0+6 c:12x12+6+6 e:6x12+18+6 sw:6x6+0+18 s:12x6+6+18 se:6x6+18+18; do
  magick "$TEMA/caixa.png" -crop "${p#*:}" +repage "$TEMA/select_${p%%:*}.png"
done
rm "$TEMA/caixa.png"

cat > "$TEMA/theme.txt" <<TEMA
title-text: ""
desktop-image: "fundo.png"
desktop-color: "#09090a"
terminal-font: "$fm"
message-font: "$fm"
message-color: "#c8c8cc"

+ label { left = 7% top = 7% width = 40% height = 40 font = "$ft" color = "#e6e6e8" text = "Bem-vindo de volta, $NOME . . ." }

+ boot_menu {
  left = 7%-12 top = 18% width = 34% height = 50%
  item_font = "$fm" item_color = "#8e8e94"
  selected_item_font = "$fm" selected_item_color = "#ffffff"
  selected_item_pixmap_style = "select_*.png"
  item_height = 36 item_padding = 12 item_spacing = 10
  icon_width = 0 icon_height = 0 item_icon_space = 0
  scrollbar = false
}

+ label { left = 7% top = 100%-84 width = 40% height = 20 font = "$fr" color = "#8e8e94" text = "[E] Editar entrada   [C] Linha de comando" }
+ label { id = "__timeout__" left = 7% top = 100%-52 width = 40% height = 20 font = "$fr" color = "#c8c8cc" text = "Iniciando em %d segundos..." }
TEMA

def() { # troca ou acrescenta uma chave do /etc/default/grub
  if grep -q "^#\?$1=" /etc/default/grub; then sed -i "s|^#\?$1=.*|$1=$2|" /etc/default/grub
  else echo "$1=$2" >> /etc/default/grub; fi
}
def GRUB_THEME "\"$TEMA/theme.txt\""
def GRUB_GFXMODE auto
def GRUB_TIMEOUT 5
def GRUB_DISABLE_OS_PROBER false   # entrada do Windows (Kingston) no menu
sed -i 's|^GRUB_TERMINAL_OUTPUT=console|#GRUB_TERMINAL_OUTPUT=console|' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
echo ">> Pronto. Reinicie para ver."
