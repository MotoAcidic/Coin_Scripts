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

cd
#remove old files
rm smrtc*

#get wallet files
#rm smrtc-linux.tar.gz
wget https://github.com/CryptoCashBack-Hub/CCBC/releases/download/V1.0.0.0/CCBC-linux.tar.gz
tar -xvf CCBC-linux.tar.gz
rm CCBC-linux.tar.gz
chmod +x cryptocashback*
chmod +x ccbc*
#cp smrtc* /usr/local/bin
rm newccbc_script.sh
#rm smrtc*
ufw allow 5520/tcp

#masternode input

echo -e "${GREEN}Now paste your Masternode key by using right mouse click ${NONE}";
read MNKEY

EXTIP=`curl -s4 icanhazip.com`
USER=`pwgen -1 20 -n`
PASSW=`pwgen -1 20 -n`

echo -e "${GREEN}Preparing config file ${NONE}";
sudo mkdir $HOME/.cryptocashback

printf "addnode=139.99.197.135\n
addnode=108.224.49.202\n
addnode=107.172.249.143\n
addnode=23.94.183.5\n
addnode=172.245.6.154\n
\nrpcuser=ccbcuser$USER\nrpcpassword=$PASSW\ndaemon=1\nlisten=1" >  $HOME/.cryptocashback/cryptocashback.conf

./cryptocashbackd
watch ./cryptocashback-cli getinfo
