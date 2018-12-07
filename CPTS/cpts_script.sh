#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="CPTS Masternode Setup Wizard"
TITLE="CPTS VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Update to new version VPS Server"
         3 "Start CPTS Masternode"
	 4 "Stop CPTS Masternode"
	 5 "CPTS Server Status"
	 6 "Rebuild CPTS Masternode Index")


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
sudo ufw allow 44331
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo Downloading AquilaX install files.
wget https://crypto-points.io/w/cpts-linux.tgz
echo Download complete.

echo Installing CPTS.
tar -xvf cpts-linux.tgz
chmod 775 ./cptsd
chmod 775 ./cpts-cli
echo cpts install complete. 
sudo rm -rf cpts-linux.tgz
clear

echo Now ready to setup CCBC configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
VPSIP=$(curl -s4 icanhazip.com)
echo Please input your private key.
read GENKEY

mkdir -p /root/.cpts && touch /root/.cpts/cpts.conf

cat << EOF > /root/.cpts/cpts.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
staking=1
rpcallowip=127.0.0.1
rpcport=44332
port=44331
logtimestamps=1
maxconnections=256
masternode=1
externalip=$VPSIP
masternodeprivkey=$GENKEY
addnode=140.82.34.79:44331
addnode=45.77.141.198:44331
addnode=199.247.5.185:44331
addnode=45.77.55.81:44331
EOF
clear
./cptsd -daemon
./cpts-cli stop
./cptsd -daemon
clear
echo cpts configuration file created successfully. 
echo cpts Server Started Successfully using the command ./cptsd -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./cptsd -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
	    
    
        2)
sudo ./cptsd-cli -daemon stop
echo "! Stopping CCB Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 44331
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo "! Removing CPTS !"
sudo rm -rf cpts_script.sh
sudo rm -rf cptsd
sudo rm -rf cpts-cli
sudo rm -rf cpts-qt



wget https://crypto-points.io/w/cpts-linux.tgz
echo Download complete.
echo Installing cpts.
tar -xvf cpts-linux.tgz
chmod 775 ./cptsd
chmod 775 ./cpts-cli
echo cpts install complete. 
sudo rm -rf cpts-linux.tgz

            ;;
        3)
            ./cptsd -daemon
		echo "If you get a message asking to rebuild the database, please hit Ctr + C and rebuild cpts Index. (Option 6)"
            ;;
	4)
            ./cpts-cli stop
            ;;
	5)
	    ./cpts-cli getinfo
	    ;;
        6)
	     ./cptsd -daemon -reindex
            ;;
esac
