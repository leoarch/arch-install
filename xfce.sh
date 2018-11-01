#!/bin/bash

### INSTALANDO XFCE ###

__A=$(echo -e "\e[34;1m");__O=$(echo -e "\e[m");_g="\e[32;1m";_o="\e[m";

custom="n"

echo -en "\n${_g}Você está instalando em um notebook?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "
read  _vm

if [[ "$_notebook" == @(S|s) ]]; then
	_notebook="s"
	export _notebook
fi

echo

echo -en "\n${_g}Você está instalando em uma VM?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "
read  _vm

if [[ "$_vm" == @(S|s) ]]; then
	virtualbox="s"
	export virtualbox
fi

tput reset

cat <<STI
${__A}===========================
Iniciando a Instalação xfce
===========================${__O}
STI

# xorg
echo -e "${_g}===> Instalando xorg${_o}"; sleep 1
pacman -S xorg-xinit xorg-server xorg-drivers --noconfirm

# xfce
echo -e "${_g}===> Instalando xfce${_o}"; sleep 1
pacman -S xfce4 xfce4-goodies --noconfirm

# firefox
echo -e "${_g}===> Instalando firefox${_o}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm

# lightdm
echo -e "${_g}===> Instalando e configurando gerenciador de login lightdm${_o}"; sleep 1
pacman -S lightdm lightdm-gtk-greeter --noconfirm
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/bg-lightdm.jpg" -O /usr/share/pixmaps/bg-lightdm.jpg 2>/dev/null
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/keyboard" -O /etc/X11/xorg.conf.d/10-evdev.conf 2>/dev/null
echo -e "[greeter]\nbackground=/usr/share/pixmaps/bg-lightdm.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

# notebook
if [[ "$_notebook" == "s" ]]; then
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm; sleep 1
fi

# audio
echo -e "${_g}===> Instalando audio${_o}"; sleep 1
pacman -S alsa-utils pulseaudio paprefs pavucontrol --noconfirm

# network
echo -e "${_g}===> Instalando utilitários de rede${_o}"; sleep 1
pacman -S networkmanager network-manager-applet dialog --noconfirm

# essenciais
echo -e "${_g}===> Instalando fonte xterm lixeira${_o}"; sleep 1
pacman -S sudo xterm ttf-dejavu gvfs --noconfirm # gvfs = lixeira

# virtualbox
if [[ "$virtualbox" == "s" ]]; then
	echo -e "${_g}===> Guest Utils Virtuabox${_o}"; sleep 1
	pacman -S virtualbox-guest-utils --noconfirm
fi

if [[ "$custom" == "s" ]]; then
	echo -e "${_g}===> Instalando programas pessoais${_o}"; sleep 1
	pacman -S  --noconfirm
fi

echo -e "${_g}===> Configurando pra iniciar o xfce${_o}"; sleep 1

# startx xfce4
cp /etc/X11/xinit/xinitrc ~/.xinitrc

# comentando a linha exec xterm
sed -i 's/exec xterm \-geometry 80x66+0+0 \-name login/\#exec xterm \-geometry 80x66+0+0 \-name login/' ~/.xinitrc

# inserindo exec startxfce4
echo 'exec startxfce4' >> ~/.xinitrc; sleep 1

# fix keyboard X11 br abnt2
localectl set-x11-keymap br abnt2

# tema opcional
# pacman -S numix-gtk-theme papirus-icon-theme --noconfirm

# enable services
echo -e "${_g}===> Habilitando serviços para serem iniciados com o sistema${_o}"; sleep 1
systemctl enable lightdm
systemctl enable NetworkManager

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI

# opcional
#echo -e "${_g}===> Dando reboot${_o}"; sleep 1