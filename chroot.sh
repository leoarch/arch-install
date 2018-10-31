#!/bin/bash

###################################################
#												  #
# ==> Autor: leo.arch                             #
# ==> Email: leo.arch@bol.com.br                  #
# ==> Script: chroot.sh v1.0                      #
# ==> Descrição: executa arch-chroot              #
#												  #
###################################################

# variables user and pass root/user
_user="arch"
_proot="123"
_puser="123"

# cores
_r="\e[31;1m";_w="\e[37;1m";_g="\e[32;1m";_o="\e[m";

# start script

# language, keyboard, hour, hostname, hosts, multilib ...
echo -e "${_g}===> Idioma, Teclado, Hora, Hostname, Hosts, Multilib, Sudoers${_o}"

echo -e "${_g}===> Inserindo pt_BR.UTF-8 em locale.gen${_o}"
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen

echo -e "${_g}===> Inserindo pt_BR.UTF-8 em /etc/locale.conf${_o}"
echo LANG=pt_BR.UTF-8 > /etc/locale.conf

echo -e "${_g}===> Exportando LANG=pt_BR.UTF-8${_o}"
export LANG=pt_BR.UTF-8

echo -e "${_g}===> Inserindo KEYMAP=br-abnt2 em /etc/vconsole.conf${_o}"
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

echo -e "${_g}===> Configurando Horário America/Sao_Paulo${_o}"
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && hwclock --systohc --utc

echo -e "${_g}===> Inserindo hostname arch em /etc/hostname${_o}"
echo "arch" > /etc/hostname

echo -e "${_g}===> Inserindo dados em /etc/hosts${_o}"
echo -e "127.0.0.1\tlocalhost.localdomain\tlocalhost\n::1\tlocalhost.localdomain\tlocalhost\n127.0.1.1\tarch.localdomain\tarch\n" > /etc/hosts

echo -e "${_g}===> Habilitando Multilib${_o}"
echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /etc/pacman.conf

echo -e "%wheel ALL=(ALL) ALL\n" >> /etc/sudoers

echo -e "${_g}===> Gerando Locale${_o}"
locale-gen

echo -e "${_g}===> Sincronizando a base de dados de pacotes${_o}"
pacman -Syu

# no meu caso, o dhclient funciona pro meu roteador e dhcpcd não (altere a vontade)
echo -e "${_g}===> Instalando dhclient${_o}"
pacman -S dhclient dhcpcd --noconfirm

# grub configuration
if [ "$_efi" != "" ]; then
	echo -e "${_g}===> bootctl UEFI mode${_o}"
	bootctl --path=/boot install
	echo -e "default arch\ntimeout 5\n" > /boot/loader/loader.conf
	echo -e "title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\noptions root=${_root} rw\n" > /boot/loader/entries/arch.conf
else
	echo -e "${_g}===> Instalando e Configurando o GRUB${_o}".5
	pacman -S grub --noconfirm
	grub-install --target=i386-pc --recheck /dev/sda
	cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
	grub-mkconfig -o /boot/grub/grub.cfg
fi

# password
echo -e "${_g}===> Criando senha root${_o}"
passwd << EOF
$_proot
$_proot
EOF
sleep 0.5

echo -e "${_g}===> Criando senha user${_o}"
useradd -m -g users -G wheel -s /bin/bash $_user
passwd $_user << EOF
$_puser
$_puser
EOF
sleep 0.5

echo -e "${_g}===> mkinitcpio${_o}"
mkinitcpio -p linux

echo -e "${_g}===> Fim do script chroot.sh${_o}"

exit