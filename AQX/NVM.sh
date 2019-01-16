#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="CCBC Masternode Setup Wizard"
TITLE="CCBC VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Update to new version VPS Server"
         3 "Start CCBC Masternode"
	 4 "Stop CCBC Masternode"
	 5 "CCBC Server Status"
	 6 "Rebuild CCBC Masternode Index")


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
sudo ufw allow 5667 
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo Downloading CCBC install files.
wget https://github.com/Test-Coin/Testing/releases/download/1.0.0.0/sexycam-linux.tar.gz
echo Download complete.

echo Installing CCBC.
tar -xvf sexycam-linux.tar.gz
chmod 775 ./sexycamd
chmod 775 ./sexy-cli
echo CCBC install complete. 
sudo rm -rf sexycam-linux.tar.gz
clear

echo Now ready to setup CCBC configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
EXTIP=`curl -s4 icanhazip.com`
echo Please input your private key.
read GENKEY

mkdir -p /root/.sexycam && touch /root/.sexycam/sexycam.conf

cat << EOF > /root/.sexycam/sexycam.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
staking=1
rpcallowip=127.0.0.1
rpcport=5567
port=5667
prune=500
addnode=149.248.53.119:5667
adnode=8.9.36.49:5667
addnode=45.77.200.8:5667
addnode=144.202.29.181:5567
logtimestamps=1
maxconnections=256
masternode=1
externalip=$EXTIP
masternodeprivkey=$GENKEY
EOF
clear
./sexycamd -daemon
./sexycam-cli stop
./sexycamd -daemon
clear
echo CCBC configuration file created successfully. 
echo CCBC Server Started Successfully using the command ./ccbcd -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./ccbcd -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
	    
    
        2)
sudo ./ccbc-cli -daemon stop
echo "! Stopping CCBC Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 5520
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo "! Removing Concierge !"
sudo rm -rf CCBC-linux.tar.gz


wget https://github.com/CryptoCashBack-Hub/CCBC/releases/download/v1.1.0.1/CCBC-linux.tar.gz
echo Download complete.
echo Installing CCBC.
tar -xvf CCBC-linux.tar.gz
chmod 775 ./ccbcd
chmod 775 ./ccbc-cli
sudo rm -rf CCBC-linux.tar.gz
./ccbcd -daemon
echo CCBC install complete. 


            ;;
        3)
            ./ccbcd -daemon
		echo "If you get a message asking to rebuild the database, please hit Ctr + C and rebuild CCBC Index. (Option 6)"
            ;;
	4)
            ./ccbc-cli stop
            ;;
	5)
	    ./ccbc-cli getinfo
	    ;;
        6)
	     ./ccbcd -daemon -reindex
            ;;
esac
