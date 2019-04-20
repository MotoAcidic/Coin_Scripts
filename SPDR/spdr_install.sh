
#!/bin/bash

HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=6
BACKTITLE="SPDR Masternode Setup Wizard"
TITLE="SPDR VPS Setup"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install New VPS Server"
         2 "Update to new version VPS Server"
         3 "Update and delete blocks / chainstate"
	 4 "Stop SPDR Masternode"
	 5 "SPDR Server Status"
	 6 "Rebuild SPDR Masternode Index")


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
sudo ufw allow 53617
sudo ufw allow 53617/tcp
sudo ufw allow 53617/udp
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 53616
sudo ufw allow 53616/tcp
sudo ufw allow 53616/udp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.

echo Downloading SPDR install files.
wget https://github.com/SPDR-Core/spdr/releases/download/1.1.1.0/Spider-Ubuntu_Daemon.tar.gz
echo Download complete.

echo Installing SPDR.
tar -xvf Spider-Ubuntu_Daemon.tar.gz
chmod 775 ./spdrd
chmod 775 ./spdr-cli
echo TRTT install complete. 
sudo rm -rf Spider-Ubuntu_Daemon.tar.gz
clear


echo Now ready to setup SPDR configuration file.

RPCUSER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
RPCPASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
EXTIP=`curl -s4 icanhazip.com`
echo Please input your private key.
read GENKEY

mkdir -p /root/.spdr && touch /root/.spdr/spdr.conf

cat << EOF > /root/.spdr/spdr.conf
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
listen=1
server=1
daemon=1
rpcallowip=127.0.0.1
rpcport=53616
port=53617
externalip=$EXTIP
masternodeprivkey=$GENKEY
addnode=83.27.253.158
addnode=103.127.86.22
addnode=108.61.188.68
addnode=176.62.91.240
addnode=83.27.79.119
addnode=83.29.177.124
addnode=46.39.54.154
addnode=88.230.169.127
addnode=223.73.136.171
addnode=188.43.112.104
addnode=85.8.76.150
addnode=76.95.94.248
addnode=184.22.40.151
addnode=178.129.9.148
addnode=77.236.65.15
addnode=176.50.174.176
addnode=179.108.12.234
addnode=134.249.111.135
addnode=87.116.179.182
addnode=71.178.50.80
addnode=167.86.89.10
addnode=100.35.175.218
addnode=37.139.101.123
addnode=109.219.133.247
addnode=207.180.235.82
addnode=134.101.163.203
addnode=171.239.41.210
addnode=176.36.16.15
addnode=104.129.6.156
addnode=173.212.199.127
addnode=176.14.138.46
addnode=108.61.221.55
addnode=167.86.84.156
addnode=92.63.57.102
addnode=109.83.98.42
addnode=37.21.251.27
addnode=118.38.99.125
addnode=72.192.244.98
addnode=43.231.28.138
addnode=188.233.37.174
addnode=217.163.28.201
addnode=184.22.38.118
addnode=194.54.160.100
addnode=104.238.177.79
addnode=139.192.250.94
addnode=134.249.105.100
addnode=176.122.117.137
addnode=194.67.213.131
addnode=212.54.222.155
addnode=103.112.61.250
addnode=109.110.74.117
addnode=178.121.2.224
addnode=5.145.236.23
addnode=192.99.2.126
addnode=75.175.149.158
addnode=81.150.111.194
addnode=157.230.232.195
addnode=217.13.219.173
addnode=93.77.220.103
addnode=37.78.81.191
addnode=171.231.147.10
addnode=207.246.84.198
addnode=209.250.239.38
addnode=188.83.84.8
addnode=79.160.152.186
addnode=94.137.30.240
addnode=80.240.60.222
addnode=46.59.58.242
addnode=14.250.151.72
addnode=95.102.56.218
addnode=182.52.33.238
addnode=62.76.20.89
addnode=79.27.66.221
addnode=123.22.25.22
addnode=45.32.124.196
addnode=82.102.27.238
addnode=185.236.152.157
addnode=223.206.116.253
addnode=157.230.109.152
addnode=68.183.37.118
addnode=134.209.100.191
addnode=185.144.157.62
addnode=185.247.116.181
addnode=185.227.111.46
addnode=108.225.195.192
EOF
clear

./spdrd -daemon
./spdr-cli stop
sleep 10s # Waits 10 seconds
./spdr -daemon
clear
echo SPDR configuration file created successfully. 
echo SPDR Server Started Successfully using the command ./altbetd -daemon
echo If you get a message asking to rebuild the database, please hit Ctr + C and run ./altbetd -daemon -reindex
echo If you still have further issues please reach out to support in our Discord channel. 
echo Please use the following Private Key when setting up your wallet: $GENKEY
            ;;
	    
    
        2)
killall -9 spdrd
echo "! Stopping SPDR Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 53617
sudo ufw allow 53617/tcp
sudo ufw allow 53617/udp
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 53616
sudo ufw allow 53616/tcp
sudo ufw allow 53616/udp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.
rm -rf spdrd
rm -rf spdr-cli

wget https://github.com/SPDR-Core/spdr/releases/download/1.1.1.0/Spider-Ubuntu_Daemon.tar.gz
echo Download complete.
echo Installing SPDR.
tar -xvf Spider-Ubuntu_Daemon.tar.gz
chmod 775 ./spdrd
chmod 775 ./spdr-cli
sudo rm -rf Spider-Ubuntu_Daemon.tar.gz
./spdrd -daemon
cd
echo SPDR install complete. 


            ;;
        3)
            killall -9 spdrd
echo "! Stopping SPDR Daemon !"

echo Configuring server firewall.
sudo apt-get install -y ufw
sudo ufw allow 53617
sudo ufw allow 53617/tcp
sudo ufw allow 53617/udp
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 53616
sudo ufw allow 53616/tcp
sudo ufw allow 53616/udp
sudo ufw logging on
echo "y" | sudo ufw enable
sudo ufw status
echo Server firewall configuration completed.
rm -rf spdrd
rm -rf spdr-cli

wget https://github.com/SPDR-Core/spdr/releases/download/1.1.1.0/Spider-Ubuntu_Daemon.tar.gz
echo Download complete.
echo Installing SPDR.
tar -xvf Spider-Ubuntu_Daemon.tar.gz
chmod 775 ./spdrd
chmod 775 ./spdr-cli
sudo rm -rf Spider-Ubuntu_Daemon.tar.gz

cd /root/.spdr

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
./spdrd -daemon
cd
echo SPDR install complete.             ;;
	4)
            ./spdr-cli stop
            ;;
	5)
	    ./spdr-cli getinfo
	    ;;
        6)
	     ./spdrd -daemon -reindex
            ;;
esac
