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
sudo apt update
sudo apt-get -y upgrade
sudo apt-get install git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y
sudo apt-get install libqt4-dev libprotobuf-dev protobuf-compiler -y

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  News24-cli stop
  wget https://github.com/MotoAcidic/Coin_Scripts/releases/download/news24/NEWS-linux.tar.gaz
  tar -xvf NEWS-linux.tar.gz
  chmod +x News24d
  chmod +x News24-cli
  chmod +x News24-tx
  sudo mv  News24d /usr/local/bin/
  sudo mv  News24-cli /usr/local/bin/
  sudo mv  News24-tx /usr/local/bin/
  rm -rf NEWS-linux.tar.gz

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
  echo '#!/bin/bash' > ~/bin/News24d_$ALIAS.sh
  echo "News24d -daemon -conf=$CONF_DIR/News24.conf -datadir=$CONF_DIR "'$*' >> ~/bin/News24d_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/News24-cli_$ALIAS.sh
  echo "News24-cli -conf=$CONF_DIR/News24.conf -datadir=$CONF_DIR "'$*' >> ~/bin/News24-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/News24-tx_$ALIAS.sh
  echo "News24-tx -conf=$CONF_DIR/News24.conf -datadir=$CONF_DIR "'$*' >> ~/bin/News24-tx_$ALIAS.sh 
  chmod 755 ~/bin/News24*.sh

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

  mv News24.conf_TEMP $CONF_DIR/News24.conf
  
  sh ~/bin/News24d_$ALIAS.sh
done
