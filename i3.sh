#!/bin/bash

# variaveis
__A=$(echo -e "\e[34;1m");__O=$(echo -e "\e[m");_g="\e[32;1m";_o="\e[m";_w="\e[37;1m";

echo -en "\n${_g}Você está instalando em um notebook?${_o} (Digite a letra ${_g}s${_o} para sim ou ${_g}n${_o} para não):${_w} "
read  _notebook

if [[ "$_notebook" == @(S|s) ]]; then
	_notebook="s"
	export _notebook
fi

echo

echo -en "\n${_g}Você está instalando em uma VM?${_o} (Digite a letra ${_g}s${_o} para sim ou ${_g}n${_o} para não):${_w} "
read  _vm

if [[ "$_vm" == @(S|s) ]]; then
	_vm="s"
	export _vm
fi

tput reset

cat <<STI
${__A}=========================
Iniciando a Instalação i3
=========================${__O}
STI

echo -e "${_g}===> Instando xorg${_o}"; sleep 1
pacman -S xorg-xinit xorg-server xorg-drivers --noconfirm

# virtualbox
if [ "$_vm" == "s" ]; then
	echo -e "${_g}===> Guest Utils Virtuabox${_o}"; sleep 1
	pacman -S virtualbox-guest-utils --noconfirm
fi

# notebook
if [ "$_notebook" == "s" ]; then
	echo -e "${_g}===> Instando drivers para notebook${_o}"; sleep 1
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm
fi

echo -e "${_g}===> Instalando i3${_o}"; sleep 1
pacman -S i3 --noconfirm

echo -e "${_g}===> Instalando fontes e terminal${_o}"; sleep 1 # mude de acordo com suas necessidades
pacman -S terminus-font ttf-dejavu termite --noconfirm

# firefox
echo -e "${_g}===> Instalando firefox${_o}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm

# audio
echo -e "${_g}===> Instalando audio${_o}"; sleep 1
pacman -S alsa-utils pulseaudio pavucontrol paprefs --noconfirm

# network
echo -e "${_g}===> Instalando utilitários de rede${_o}"; sleep 1
pacman -S networkmanager network-manager-applet --noconfirm

# iniciar i3
echo -e "${_g}===> Configurando pra iniciar o i3${_o}"; sleep 1
echo 'exec i3' > ~/.xinitrc

# fix keyboard X11 br abnt2
echo -e "${_g}===>locale X11 abnt2${_o}"
localectl set-x11-keymap br abnt2

# lightdm
echo -e "${_g}===> Instalando e configurando gerenciador de login lightdm${_o}"; sleep 1
pacman -S lightdm lightdm-gtk-greeter --noconfirm
sed -i 's/^#greeter-session.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
sed -i '/^#greeter-hide-user=/s/#//' /etc/lightdm/lightdm.conf
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/bg-lightdm.jpg" -O /usr/share/pixmaps/bg-lightdm.jpg 2>/dev/null
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/keyboard" -O /etc/X11/xorg.conf.d/10-evdev.conf 2>/dev/null
echo -e "[greeter]\nbackground=/usr/share/pixmaps/bg-lightdm.jpg" > /etc/lightdm/lightdm-gtk-greeter.conf

# enable services
echo -e "${_g}===> Habilitando serviços para serem iniciados com o sistema${_o}"
systemctl enable lightdm
systemctl enable NetworkManager