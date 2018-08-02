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
#rm smrtc-linux.tar.gz
wget https://github.com/CryptoCashBack-Hub/CCBC/releases/download/V1.0.0.0/CCBC-linux.tar.gz
tar -xvf CCBC-linux.tar.gz
rm CCBC-linux.tar.gz
chmod +x cryptocashback*
cp cryptocashback* /usr/local/bin
rm ccb_script.sh
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

printf "addnode=144.202.54.65:5520\naddnode=45.32.200.48:5520\naddnode=140.82.43.229:5520\naddnode=104.238.131.253:5520\n\nrpcuser=ccbcuser$USER\nrpcpassword=$PASSW\nrpcport=5522\nrpcallowip=127.0.0.1\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=54\nexternalip=$EXTIP\nbind=$EXTIP:5520\nmasternode=1\nmasternodeprivkey=$MNKEY" >  $HOME/.cryptocashback/cryptocashback.conf
cryptocashbackd
watch cryptocashback-cli getinfo
