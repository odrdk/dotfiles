#!/usr/bin/env bash
# Arch com criptografia total no esquema do vídeo da Belli Labs: /boot e / em volumes LUKS separados.
#   p1 EFI em /efi (aberta)  p2 /boot LUKS2-PBKDF2, aberto pelo GRUB  p3 / LUKS2-Argon2id, aberto pelo initramfs
# No boot são duas senhas: a do /boot no GRUB (layout US!) e a do / no initramfs (ABNT2).
# No fim instala a build dwm (DOTFILES_REPO, com o install.sh dela); DOTFILES_REPO= vazio pula essa parte.
# Uso, no live ISO: bash instalar-arch-luks.sh /dev/sdX   (APAGA o disco inteiro)
set -euo pipefail

NOME_MAQUINA=${NOME_MAQUINA:-arthos}
USUARIO=${USUARIO:-arthos}
KERNEL_EXTRA=${KERNEL_EXTRA:-} # teste em VM: KERNEL_EXTRA=console=ttyS0
DOTFILES_REPO=${DOTFILES_REPO-https://github.com/odrdk/dotfiles}
FUSO=America/Sao_Paulo
TECLADO=br-abnt2
CHAVE_BOOT=/etc/cryptsetup-keys.d/cryptboot.key

erro() { echo "ERRO: $*" >&2; exit 1; }
part() { [[ $1 =~ [0-9]$ ]] && echo "${1}p$2" || echo "$1$2"; } # nvme0n1p1 x sda1

fase_live() {
  local disco=${1:-}
  [[ $EUID -eq 0 ]] || erro "rode como root"
  [[ -d /sys/firmware/efi ]] || erro "não iniciou em UEFI"
  [[ -b $disco && $(lsblk -dno TYPE "$disco") == disk ]] || erro "informe o disco inteiro, ex.: /dev/sda"
  lsblk -no MOUNTPOINTS "$disco" | grep -q . && erro "$disco tem partição montada"
  ping -c1 -W3 archlinux.org >/dev/null || erro "sem internet (Wi-Fi: iwctl station wlan0 connect \"REDE\")"

  loadkeys "$TECLADO"
  timedatectl set-ntp true
  # Logo após o boot o live ainda monta o chaveiro; antes disso todo pacote falha na assinatura PGP.
  echo ">> Aguardando o chaveiro do pacman (pacman-init)"
  while :; do
    case $(systemctl show -p ActiveState --value pacman-init.service) in
      active) break ;;
      failed) erro "pacman-init falhou: systemctl restart pacman-init" ;;
    esac
    sleep 2
  done

  lsblk -o NAME,SIZE,MODEL,TRAN "$disco"
  echo
  echo "TUDO em $disco ($(lsblk -dno MODEL "$disco")) será apagado, sem volta."
  read -rp "Digite o nome do disco para confirmar ($(basename "$disco")): " ok
  [[ $ok == "$(basename "$disco")" ]] || erro "cancelado"

  local esp boot raiz
  esp=$(part "$disco" 1); boot=$(part "$disco" 2); raiz=$(part "$disco" 3)
  wipefs -af "$disco"
  sgdisk --zap-all "$disco"
  # /boot com 1 GiB, não 512 MiB: kernel + initramfs de fallback já passam de 200 MiB.
  sgdisk -n1:0:+256MiB -t1:ef00 -c1:EFI \
         -n2:0:+1GiB   -t2:8309 -c2:cryptboot \
         -n3:0:0       -t3:8309 -c3:cryptroot "$disco"
  partprobe "$disco"; udevadm settle

  # O vídeo usou LUKS1 no /boot porque o GRUB ainda não abria LUKS2; hoje abre, desde que seja PBKDF2.
  echo ">> Senha do /boot (pedida pelo GRUB, que digita em layout US: evite ç, acento e símbolo)"
  cryptsetup luksFormat -q --verify-passphrase --type luks2 --pbkdf pbkdf2 --iter-time 2000 "$boot"
  echo ">> Senha do / (pedida depois, já com teclado ABNT2)"
  cryptsetup luksFormat -q --verify-passphrase --type luks2 "$raiz"
  cryptsetup open "$boot" cryptboot
  cryptsetup open "$raiz" cryptroot

  mkfs.fat -F32 -n EFI "$esp"
  mkfs.ext4 -L boot /dev/mapper/cryptboot
  mkfs.ext4 -L arch /dev/mapper/cryptroot
  mount /dev/mapper/cryptroot /mnt
  mount --mkdir /dev/mapper/cryptboot /mnt/boot
  mount --mkdir "$esp" /mnt/efi

  reflector --country Brazil --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist || echo "reflector falhou, seguindo com a lista padrão"
  pacman -Syy --noconfirm archlinux-keyring
  pacstrap -K /mnt base base-devel linux linux-headers linux-firmware intel-ucode cryptsetup \
    grub efibootmgr networkmanager sudo nano neovim git man-db zram-generator ntfs-3g \
    mesa vulkan-intel intel-media-driver sof-firmware
  genfstab -U -p /mnt >> /mnt/etc/fstab

  install -m700 "$0" /mnt/root/instalar.sh
  arch-chroot /mnt env NOME_MAQUINA="$NOME_MAQUINA" USUARIO="$USUARIO" KERNEL_EXTRA="$KERNEL_EXTRA" DOTFILES_REPO="$DOTFILES_REPO" bash /root/instalar.sh --chroot "$boot" "$raiz"
  rm -f /mnt/root/instalar.sh

  umount -R /mnt
  cryptsetup close cryptboot
  cryptsetup close cryptroot
  echo "Pronto. Tire o pen drive e rode: reboot"
}

fase_chroot() {
  local boot=$1 raiz=$2 uuid_boot uuid_raiz
  uuid_boot=$(blkid -s UUID -o value "$boot")
  uuid_raiz=$(blkid -s UUID -o value "$raiz")

  echo "$NOME_MAQUINA" > /etc/hostname
  printf '127.0.0.1 localhost\n::1 localhost\n127.0.1.1 %s\n' "$NOME_MAQUINA" > /etc/hosts
  sed -i 's/^#\(pt_BR.UTF-8 UTF-8\)/\1/; s/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
  locale-gen
  echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
  echo "KEYMAP=$TECLADO" > /etc/vconsole.conf
  ln -sf "/usr/share/zoneinfo/$FUSO" /etc/localtime
  hwclock --systohc --utc # sem Windows na máquina, BIOS em UTC

  # O vídeo cria senha de root; aqui o root fica travado e a administração é pelo sudo do wheel.
  useradd -m -G wheel,storage,power -s /bin/bash "$USUARIO"
  echo ">> Senha do usuário $USUARIO"
  until passwd "$USUARIO"; do :; done
  passwd -l root
  echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/10-wheel
  chmod 440 /etc/sudoers.d/10-wheel
  visudo -cf /etc/sudoers.d/10-wheel

  printf '[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd\n' > /etc/systemd/zram-generator.conf
  systemctl enable NetworkManager systemd-timesyncd

  # Initramfs padrão hoje é o do systemd (o vídeo usava o busybox com encrypt/cryptdevice=).
  sed -i 's|^HOOKS=.*|HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)|' /etc/mkinitcpio.conf
  mkinitcpio -P

  sed -i "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"rd.luks.name=$uuid_raiz=cryptroot root=/dev/mapper/cryptroot${KERNEL_EXTRA:+ $KERNEL_EXTRA}\"|" /etc/default/grub
  if grep -q '^#\?GRUB_ENABLE_CRYPTODISK' /etc/default/grub; then
    sed -i 's/^#\?GRUB_ENABLE_CRYPTODISK=.*/GRUB_ENABLE_CRYPTODISK=y/' /etc/default/grub
  else
    echo 'GRUB_ENABLE_CRYPTODISK=y' >> /etc/default/grub
  fi
  grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck
  grub-install --target=x86_64-efi --efi-directory=/efi --removable # firmware que esquece a entrada ainda acha o GRUB
  grub-mkconfig -o /boot/grub/grub.cfg

  # Chave do /boot guardada no / cifrado: o sistema reabre o /boot sozinho sem pedir a terceira senha.
  install -d -m700 /etc/cryptsetup-keys.d
  dd bs=512 count=8 if=/dev/random of="$CHAVE_BOOT" iflag=fullblock status=none
  chmod 600 "$CHAVE_BOOT"
  echo ">> Senha do /boot de novo (para registrar a chave)"
  cryptsetup luksAddKey "$boot" "$CHAVE_BOOT"
  echo "cryptboot UUID=$uuid_boot $CHAVE_BOOT luks" >> /etc/crypttab

  instalar_build
}

instalar_build() {
  [[ -n $DOTFILES_REPO ]] || return 0
  echo ">> Build dwm: $DOTFILES_REPO (demora: ~130 pacotes, parte compilada do AUR)"
  # O install.sh da build roda como usuário e chama sudo/yay muitas vezes, com a saída escondida:
  # sem sudo livre ele travaria esperando senha sem mostrar nada. Liberado só durante a instalação.
  echo "$USUARIO ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-instalacao
  chmod 440 /etc/sudoers.d/99-instalacao
  # yay antes: o install.sh compila o yay com makepkg interativo, que roubaria as respostas abaixo.
  su - "$USUARIO" -c 'cd /tmp && git clone -q https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si --noconfirm' \
    || echo "AVISO: yay não instalou; o install.sh vai tentar de novo"
  # Respostas do install.sh: Oh-My-Zsh já instalado? n (instala) | baixar wallpapers? y
  su - "$USUARIO" -c "mkdir -p ~/Documents && git clone -q '$DOTFILES_REPO' ~/Documents/dotfiles \
    && cd ~/Documents/dotfiles && printf 'n\ny\n' | ./install.sh > ~/instalacao-build.log 2>&1" \
    || echo "AVISO: install.sh da build terminou com erro; veja ~/instalacao-build.log"
  rm -f /etc/sudoers.d/99-instalacao
  chsh -s /usr/bin/zsh "$USUARIO" # o chsh do install.sh pede senha e falha sem terminal
}

if [[ ${1:-} == --chroot ]]; then fase_chroot "$2" "$3"; else fase_live "${1:-}"; fi
