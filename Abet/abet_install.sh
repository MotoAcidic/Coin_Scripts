
#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="ABET Masternode Setup Wizard"
TITLE="ABET VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Update to new version VPS Server"
         3 "Update and delete blocks / chainstate"	 
		 4 "Stop Abet Masternode"
		 5 "Abet Server Status"
		 6 "Rebuild Abet Masternode Index"
	 )


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
sudo ufw allow 9322
sudo ufw allow 8322
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo Downloading Abet install files.
wget https://github.com/CoinStaging/abet/releases/download/v.2.0.0.0/ABET-linux.tar.gz
echo Download complete.

echo Installing altbet.
tar -xvf ABET-linux.tar.gz
chmod 775 ./abet
chmod 775 ./abet-cli
echo TRTT install complete.
clear


echo Now ready to setup Abet configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
EXTIP=`curl -s4 icanhazip.com`
echo Please input your private key.
read GENKEY

mkdir -p /root/.abet && touch /root/.abet/abet.conf

cat << EOF > /root/.abet/abet.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcallowip=127.0.0.1
server=1
listen=1
daemon=1
#staking=1
rpcallowip=127.0.0.1
rpcport=9322
port=8322
logtimestamps=1
maxconnections=256
masternode=1
externalip=$EXTIP
masternodeprivkey=$GENKEY
addnode=63.209.32.202
addnode=173.199.118.20
addnode=108.224.49.202
addnode=144.202.2.218

EOF
clear

./abetd -daemon
./abet-cli stop
sleep 10s # Waits 10 seconds
./abet -daemon
clear
echo Abet configuration file created successfully. 
echo Abet Server Started Successfully using the command ./abetd -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./altbetd -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
	    
    
        2)
killall -9 abetd
echo "! Stopping ABET Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 2238
sudo ufw allow 2238/tcp
sudo ufw allow 2238/udp
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.
rm -rf altbetd
rm -rf altbet-cli

wget https://github.com/MotoAcidic/Coin_Scripts/releases/download/Abet/ALTBET-linux.tar.gz
echo Download complete.
echo Installing ABET.
tar -xvf ABET-linux.tar.gz
chmod 775 ./altbetd
chmod 775 ./altbet-cli
./altbetd -daemon
cd
echo ABET install complete. 


            ;;
        3)
            killall -9 altbetd
echo "! Stopping ABET Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 2238
sudo ufw allow 2238/tcp
sudo ufw allow 2238/udp
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.
rm -rf altbetd
rm -rf altbet-cli

wget https://github.com/MotoAcidic/Coin_Scripts/releases/download/Abet/ALTBET-linux.tar.gz
echo Download complete.
echo Installing ABET.
tar -xvf ALTBET-linux.tar.gz
chmod 775 ./abetd
chmod 775 ./abet-cli
sudo rm -rf ABET-linux.tar.gz

cd /root/.abet

rm -rf blocks
rm -rf chainstate
rm -rf backups
rm -rf db.log
rm -rf budget.dat
rm -rf debug.log
rm -rf fee_estimates.dat
rm -rf peers.dat
rm -rf mnpayments.dat
rm -rf mncache.dat
cd
./abetd -daemon
cd
echo ABET install complete.             ;;
	
	
        4)    ./abet-cli stop
            ;;
		5)
	    ./abet-cli getinfo
	    ;;
        6)
	     ./abetd -daemon -reindex
            ;;

esac
