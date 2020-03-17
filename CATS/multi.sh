#/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your catsthis  masternodes.       *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [ $DOSETUP = "y" ]  
then
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get update
  sudo apt-get install -y zip unzip

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  cats-cli stop
  wget https://github.com/MotoAcidic/Coin_Scripts/releases/download/cat/CATS-linux.tar.gz
  tar -xvf CATS-linux.tar.gz
  chmod +x catsd
  chmod +x cats-cli
  sudo mv  catsd /usr/local/bin/linux
  sudo mv  cats-cli /usr/local/bin/linux
  sudo mv  cats-tx /usr/local/bin/linux
  rm -rf CATS-linux.tar.gz

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
echo ""
echo "Configure your masternodes now!"
echo "Type the IP of this server, followed by [ENTER]:"
read IP

echo ""
echo "How many nodes do you want to create on this server? [min:1 Max:20]  followed by [ENTER]:"
read MNCOUNT


for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  

  echo ""
  echo "Enter port for node $ALIAS"
  read PORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  echo ""
  echo "Enter RPC Port"
  read RPCPORT

  ALIAS=${ALIAS}
  CONF_DIR=~/.cats_$ALIAS

  # Create scripts
  echo '#!/bin/bash' > ~/bin/catsd_$ALIAS.sh
  echo "catsd -daemon -conf=$CONF_DIR/cats.conf -datadir=$CONF_DIR "'$*' >> ~/bin/catsd_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/cats-cli_$ALIAS.sh
  echo "cats-cli -conf=$CONF_DIR/cats.conf -datadir=$CONF_DIR "'$*' >> ~/bin/cats-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/cats-tx_$ALIAS.sh
  echo "cats-tx -conf=$CONF_DIR/cats.conf -datadir=$CONF_DIR "'$*' >> ~/bin/cats-tx_$ALIAS.sh 
  chmod 755 ~/bin/cats*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> cats.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> cats.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> cats.conf_TEMP
  echo "rpcport=$RPCPORT" >> cats.conf_TEMP
  echo "listen=1" >> cats.conf_TEMP
  echo "server=1" >> cats.conf_TEMP
  echo "daemon=1" >> cats.conf_TEMP
  echo "logtimestamps=1" >> cats.conf_TEMP
  echo "maxconnections=256" >> cats.conf_TEMP
  echo "masternode=1" >> cats.conf_TEMP
  echo "" >> cats.conf_TEMP

  echo "" >> cats.conf_TEMP
  echo "port=$PORT" >> cats.conf_TEMP
  echo "masternodeaddr=$IP:$PORT" >> cats.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> cats.conf_TEMP
  sudo ufw allow $PORT/tcp

  mv cats.conf_TEMP $CONF_DIR/cats.conf
  
  sh ~/bin/catsd_$ALIAS.sh
done
