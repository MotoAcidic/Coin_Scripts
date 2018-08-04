#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="CCB Masternode Setup Wizard"
TITLE="CCB VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Update to new version VPS Server"
         3 "Start CCB Masternode"
	 4 "Stop CCB Masternode"
	 5 "CCB Server Status"
	 6 "Rebuild CCB Masternode Index")


CHOICE=$(whiptail --clear\
		--backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo Starting the install process.
echo Checking and installing VPS server prerequisites. Please wait.
echo -e "Checking if swap space is needed."
PHYMEM=$(free -g|awk '/^Mem:/{print $2}')
SWAP=$(swapon -s)
if [[ "$PHYMEM" -lt "2" && -z "$SWAP" ]];
  then
    echo -e "${GREEN}Server is running with less than 2G of RAM, creating 2G swap file.${NC}"
    dd if=/dev/zero of=/swapfile bs=1024 count=2M
    chmod 600 /swapfile
    mkswap /swapfile
    swapon -a /swapfile
else
  echo -e "${GREEN}The server running with at least 2G of RAM, or SWAP exists.${NC}"
fi
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi
clear
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
clear
echo VPS Server prerequisites installed.


echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 19551
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo Downloading AquilaX install files.
wget https://github.com/CryptoCashBack-Hub/CCB/releases/download/V1.0.0.0/CCB-linux.tar.gz
echo Download complete.

echo Installing CCB.
tar -xvf CCB-linux.tar.gz
chmod 775 ./cryptocashbackd
chmod 775 ./cryptocashback-cli
echo cryptocashback install complete. 
sudo rm -rf CCB-linux.tar.gz
clear

echo Now ready to setup AquilaX configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
VPSIP=$(curl -s4 icanhazip.com)
echo Please input your private key.
read GENKEY

mkdir -p /root/.cryptocashback && touch /root/.cryptocashback/cryptocashback.conf

cat << EOF > /root/.cryptocashback/cryptocashback.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
staking=1
rpcallowip=127.0.0.1
rpcport=5522
port=5520
logtimestamps=1
maxconnections=256
masternode=1
externalip=$VPSIP
masternodeprivkey=$GENKEY
addnode=108.224.49.202:5520
addnode=107.172.249.143:5520
addnode=23.94.183.5:5520
addnode=172.245.6.154:5520

EOF
clear
./cryptocashbackd -daemon
./cryptocashback-cli stop
./cryptocashbackd -daemon
clear
echo cryptocashback configuration file created successfully. 
echo cryptocashback Server Started Successfully using the command ./Aquilad -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./cryptocashbackd -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
	    
    
        2)
sudo ./cryptocashback-cli -daemon stop
echo "! Stopping CCB Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 5520
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo "! Removing CCB !"
sudo rm -rf CCB_install.sh
sudo rm -rf cryptocashbackd
sudo rm -rf cryptocashback-cli
sudo rm -rf cryptocashback-qt



wget https://github.com/CryptoCashBack-Hub/CCB/releases/download/V1.0.0.0/CCB-linux.tar.gz
echo Download complete.
echo Installing CCB.
tar -xvf CCB-linux.tar.gz
chmod 775 ./cryptocashbackd
chmod 775 ./cryptocashback-cli
echo AquilaX install complete. 
sudo rm -rf CCB-linux.tar.gz

            ;;
        3)
            ./cryptocashbackd -daemon
		echo "If you get a message asking to rebuild the database, please hit Ctr + C and rebuild Aquila Index. (Option 6)"
            ;;
	4)
            ./cryptocashback-cli stop
            ;;
	5)
	    ./cryptocashback-cli getinfo
	    ;;
        6)
	     ./cryptocashbackd -daemon -reindex
            ;;
esac
