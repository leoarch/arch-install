#!/bin/bash

### INSTALANDO XFCE4 ###

__A=$(echo -e "\e[34;1m");__O=$(echo -e "\e[m");_g="\e[32;1m";_o="\e[m";

echo -en "\n${_g}Você está instalando em um notebook?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "
read  _notebook

if [[ "$_notebook" == @(S|s) ]]; then
	_notebook="s"
	export _notebook
fi

echo

echo -en "\n${_g}Você está instalando em uma VM?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "
read  _vm

if [[ "$_vm" == @(S|s) ]]; then
	_vm="s"
	export _vm
fi

echo -en "\n${_g}Gostaria de instalar o gnome-extras?${_o} (Digite a letra 's' para sim ou 'n' para não):${_w} "
read  _gextra

if [[ "$_gextra" == @(S|s) ]]; then
	_gextra="s"
	export _gextra
fi

echo
echo

cat <<STI
${__A}============================
Iniciando a Instalação GNOME
============================${__O}
STI

# xorg
echo -e "${_g}===> Instando XORG${_o}"; sleep 1
pacman -S xorg-xinit xorg-server xorg-drivers --noconfirm

# notebook
if [[ "$_notebook" == @(s|S) ]]; then
	echo -e "${_g}===> Instando drivers para notebook${_o}"; sleep 1
	pacman -S xf86-input-synaptics xf86-input-libinput wireless_tools wpa_supplicant wpa_actiond acpi acpid --noconfirm
fi

# vm
if [[ "$_vm" == "s" ]]; then
	echo -e '${_g}===> Guest Utils para Virtuabox${_o}'; sleep 1
	pacman -S  virtualbox-guest-utils --noconfirm
fi

# gnome
echo -e "${_g}===> Instalando básico GNOME${_o}"; sleep 1 
pacman -S gnome-shell nautilus gnome-terminal gnome-tweak-tool gnome-control-center gdm --noconfirm # se necessário, altere como desejar

# gnome-extra
if [[ "$_gextra" == "s" ]]; then
	echo -e "${_g}===> Instalando Gnome Extras${_o}"; sleep 1
	pacman -S gnome-extra --noconfirm
fi

# firefox
echo -e "${_g}===> Instalando firefox${_o}"; sleep 1
pacman -S firefox firefox-i18n-pt-br flashplugin --noconfirm

# rede
echo -e "${_g}===> Instalando utilitários de rede${_o}"; sleep 1
pacman -S networkmanager network-manager-applet dialog --noconfirm

# mudar dhcpcd para dhclient (em um caso particular, meu roteador só funcionou com dhclient)
# echo -e "${_g}===> Configurando dhcp para dhclient${_o}"; sleep 1
# echo -e "[main]\ndhcp=dhclient" > /etc/NetworkManager/conf.d/dhclient.conf

# set keymap br
localectl set-x11-keymap br abnt2

# enable services
echo -e "${_g}===> Habilitando NetworkManager e GDM${_o}"; sleep 1
systemctl enable NetworkManager && systemctl enable gdm1

cat <<EOI

${__A}=============
     FIM!    
=============${__O}
EOI