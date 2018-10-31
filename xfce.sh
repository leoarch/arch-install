#!/bin/bash

### INSTALANDO XFCE4 ###

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
echo -e "${_g}===> Instando xorg${_o}"; sleep 1
pacman -S xorg-xinit xorg-server xorg-drivers --noconfirm; sleep 1

# xfce
echo -e "${_g}===> Instalando xfce${_o}"; sleep 1
pacman -S xfce4 xfce4-goodies --noconfirm; sleep 1

# firefox
echo -e "${_g}===> Instalando firefox${_o}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm; sleep 1

# lightdm
echo -e "${_g}===> Instalando e configurando gerenciador de login lightdm${_o}"; sleep 1
pacman -S lightdm lightdm-gtk-greeter --noconfirm; sleep 1
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf; sleep 1
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf; sleep 1
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/lightd-arch.jpg" -O /usr/share/pixmaps/lightd-arch.jpg 2>/dev/null; sleep 1
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/keyboard" -O /etc/X11/xorg.conf.d/10-evdev.conf 2>/dev/null; sleep 1
echo -e "[greeter]\nbackground=/usr/share/pixmaps/lightd-arch.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf; sleep 1

# notebook
if [[ "$_notebook" == "s" ]]; then
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm; sleep 1
fi

# audio
echo -e "${_g}===> Instalando audio${_o}"; sleep 1
pacman -S alsa-utils pulseaudio paprefs pavucontrol --noconfirm; sleep 1

# network
echo -e "${_g}===> Instalando utilitários de rede${_o}"; sleep 1
pacman -S networkmanager network-manager-applet dialog --noconfirm; sleep 1

# essenciais
pacman -S sudo xterm ttf-dejavu gvfs --noconfirm; sleep 1

# virtualbox
if [[ "$virtualbox" == "s" ]]; then
	echo -e "${_g}===> Guest Utils Virtuabox${_o}"; sleep 1
	pacman -S virtualbox-guest-utils --noconfirm; sleep 1
fi

if [[ "$custom" == "s" ]]; then
	echo -e "${_g}===> Instalando programas pessoais${_o}"; sleep 1
	pacman -S  --noconfirm; sleep 1
fi

echo -e "${_g}===> Configurando pra iniciar o xfce${_o}"; sleep 1

# startx xfce4
cp /etc/X11/xinit/xinitrc ~/.xinitrc; sleep 1

# comentando a linha exec xterm
sed -i 's/exec xterm \-geometry 80x66+0+0 \-name login/\#exec xterm \-geometry 80x66+0+0 \-name login/' ~/.xinitrc; sleep 1

# inserindo exec startxfce4
echo 'exec startxfce4' >> ~/.xinitrc; sleep 1

# fix keyboard X11 br abnt2
localectl set-x11-keymap br abnt2

# theme
pacman -S numix-gtk-theme papirus-icon-theme --noconfirm; sleep 1

# enable services
echo -e "${_g}===> Habilitando serviços para serem iniciados com o sistema${_o}"; sleep 1
systemctl enable lightdm; sleep 1
systemctl enable NetworkManager; sleep 1

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI

echo -e "${_g}===> Dando reboot${_o}"; sleep 1

#echo -e "${_g}===> FIM!${_o}"; sleep 1

# OBS: Se der algum problema durante o carregamento do sistema, use Ctrl + Alt + F2