#!/bin/bash

path=/usr/local/src

if [[ $EUID -ne 0 ]]; then
  echo "Please enter the root password"
  exec sudo /usr/bin/bash "$0" "$@"
  exit 0
fi

if [ $(dpkg-query -W -f='${Status}' build-essential 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
	echo "Installer les outils pour compiler avec la commande 'sudo apt install build-essential'"
	# apt install build-essential
	exit 1
fi

if [[ -f "$path/asterisk.tar.gz" ]]; then
  echo "Il semble qu'il y ait deja des sources pour asterisk dans /usr/local/src/"
  echo "Essayer de taper la commande 'sudo rm -r /usr/local/src/asterisk*' pour supprimer les précédentes sources"
  exit 1
fi

wget -O $path/asterisk.tar.gz https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
tar -zxf $path/asterisk.tar.gz -C $path/

cd $path/asterisk-*/
./contrib/scripts/install_prereq install
./contrib/scripts/install_prereq install-unpackaged
./configure
wget https://gist.githubusercontent.com/xXDrkLeoXx/c7d1fb7715d873879f8217b13a6c54b1/raw/ed26185e518d6064453ed025bd310583615f41a8/menuselect-tree
wget https://gist.githubusercontent.com/xXDrkLeoXx/c7d1fb7715d873879f8217b13a6c54b1/raw/ed26185e518d6064453ed025bd310583615f41a8/menuselect.makeopts
wget https://gist.githubusercontent.com/xXDrkLeoXx/c7d1fb7715d873879f8217b13a6c54b1/raw/ed26185e518d6064453ed025bd310583615f41a8/menuselect.makedeps

