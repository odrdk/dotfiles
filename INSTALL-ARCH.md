# Instalação do Arch no SSD

Máquina: Lenovo 81FE. Usuário `odrdk`, hostname `odrdk`, kernel `linux-zen`.
Disco: LVM sobre LUKS1 com `/boot` criptografado (GRUB), seguindo o guia
[Trigus42](https://gist.github.com/Trigus42/dfb40fe12407d4f29e30d26ca11495f6).

> **Antes de tudo:** desligue o PC, **tire o HD** e coloque o SSD Kingston.
> O HD é a única cópia do Windows. O instalador se recusa a rodar com ele conectado.

## Instalar

1. Grave a ISO do Arch no pen drive com o Rufus (GPT, UEFI).
2. Desligue o Secure Boot na BIOS e dê boot pelo pen drive.
3. Use cabo de rede, ou conecte o Wi-Fi com `iwctl`.

```bash
loadkeys br-abnt2
```

```bash
curl -fsSL https://raw.githubusercontent.com/odrdk/dotfiles/arch-install/arch-install -o i && bash i
```

4. Digite `APAGAR`, escolha o usuário (Enter usa `odrdk`) e crie as duas senhas.
5. Ao terminar, tire o pen drive e rode `reboot`.

**Senha do disco:** só letras e números, 12 ou mais caracteres. O GRUB lê em
teclado americano, então símbolo e acento saem diferentes do ABNT2.
Guarde fora do PC: sem ela, o SSD fica inacessível.

## Primeiro boot

O GRUB pede a senha do disco e demora alguns segundos para abrir. Entre como
`odrdk`: o primeiro login instala tudo e abre o dwm.

## Trazer os dados

Desligue, conecte o HD, ligue e rode:

```bash
trazer-dados
```

```bash
cd ~/Documents/Arthur-OS && claude
```

## Fora do script

A parte de Secure Boot com chaves próprias (Evil Maid) fica para depois: depende
de telas da BIOS e de assinar kernel e GRUB a cada atualização.
