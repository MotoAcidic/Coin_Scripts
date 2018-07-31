#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install git -y
sudo apt-get install nano -y
sudo apt-get install curl -y
sudo apt-get install pwgen -y
sudo apt-get install wget -y
sudo apt-get install build-essential libtool automake autoconf -y
sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -y
sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -y
sudo apt-get install libzmq3-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
#get ip lib
sudo apt install libwww-perl -y

cd
#get wallet files
#rm ccbc-linux.tar.gz
wget 
tar -xvf ccbc-linux.tar.gz
rm smrtc-linux.tar.gz
chmod +x cryptocashback*
cp smrtc* /usr/local/bin
rm ccbc_auto.sh
rm cryptocashback*
ufw allow 5520/tcp

#masternode input

echo -e "${GREEN}Now paste your Masternode key by using right mouse click ${NONE}";
read MNKEY

EXTIP=`lwp-request -o text checkip.dyndns.org | awk '{ print $NF }'`
USER=`pwgen -1 20 -n`
PASSW=`pwgen -1 20 -n`

echo -e "${GREEN}Preparing config file ${NONE}";
sudo mkdir $HOME/.cryptocashback

printf "addnode=220.233.78.249:5520\naddnode=108.224.49.202:5520\naddnode=139.99.197.135:5520\n\nrpcuser=smartcuser$USER\nrpcpassword=$PASSW\nrpcport=5522\nrpcallowip=127.0.0.1\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=54\nexternalip=$EXTIP\nbind=$EXTIP:5520\nmasternode=1\nmasternodeprivkey=$MNKEY" >  $HOME/.cryptocashback/cryptocashback.conf
smrtcd
watch smrtc-cli getinfo
