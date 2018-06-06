#!/bin/bash

-cd ~
-echo "****************************************************************************"
-echo "****************************************************************************"
-echo "*****************************IPSUM Community Script*************************"
-echo "****************************************************************************"
-echo "****************************************************************************"
-echo "********************This script was forked from XeZZoR**********************"
-echo "****************************************************************************"
-echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
-echo "*                                                                          *"
-echo "* This script will install and configure your IPSUM Coin Masternode.       *"
-echo "****************************************************************************"
-echo && echo && echo
-echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
-echo "!                                                 !"
-echo "! Make sure you double check before hitting enter !"
-echo "! This will install version 3.1.0                 !"
-echo "!                                                 !"
-echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
-echo && echo && echo
-
-echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
-read DOSETUP


TMP_FOLDER=$(mktemp -d)
CONFIG_FILE='ips.conf'
CONFIGFOLDER='/root/.ips'
COIN_DAEMON='ipsd'
COIN_CLI='ips-cli'
COIN_PATH='/usr/local/bin/'
COIN_TGZ='https://github.com/ipsum-network/ips/releases/download/v3.1.0.0/ips-3.1.0-linux.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')
COIN_NAME='Ips'
COIN_PORT=22331
RPC_PORT=22332

NODEIP=$(curl -s4 icanhazip.com)


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


function download_node() {
  echo -e "Prepare to download ${GREEN}$COIN_NAME${NC}."
  cd $TMP_FOLDER >/dev/null 2>&1
  wget -q $COIN_TGZ
  compile_error
  tar xvzf $COIN_ZIP --strip 1 >/dev/null 2>&1
  compile_error
  cp bin/$COIN_DAEMON bin/$COIN_CLI $COIN_PATH
  cd - >/dev/null 2>&1
  rm -rf $TMP_FOLDER >/dev/null 2>&1
clear
}


function configure_systemd() {
  cat << EOF > /etc/systemd/system/$COIN_NAME.service
[Unit]
Description=$COIN_NAME service
After=network.target

[Service]
User=root
Group=root

Type=forking
#PIDFile=$CONFIGFOLDER/$COIN_NAME.pid

ExecStart=$COIN_PATH$COIN_DAEMON -daemon -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER
ExecStop=-$COIN_PATH$COIN_CLI -conf=$CONFIGFOLDER/$CONFIG_FILE -datadir=$CONFIGFOLDER stop

Restart=always
PrivateTmp=true
TimeoutStopSec=60s
TimeoutStartSec=10s
StartLimitInterval=120s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  sleep 3
  systemctl start $COIN_NAME.service
  systemctl enable $COIN_NAME.service >/dev/null 2>&1

  if [[ -z "$(ps axo cmd:100 | egrep $COIN_DAEMON)" ]]; then
    echo -e "${RED}$COIN_NAME is not running${NC}, please investigate. You should start by running the following commands as root:"
    echo -e "${GREEN}systemctl start $COIN_NAME.service"
    echo -e "systemctl status $COIN_NAME.service"
    echo -e "less /var/log/syslog${NC}"
    exit 1
  fi
}


function create_config() {
  mkdir $CONFIGFOLDER >/dev/null 2>&1
  RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
  RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
  cat << EOF > $CONFIGFOLDER/$CONFIG_FILE
rpcuser=$RPCUSER
rpcpassword=$RPCPASSWORD
rpcport=$RPC_PORT
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
port=$COIN_PORT
EOF
}

function create_key() {
  echo -e "Enter your ${RED}$COIN_NAME Masternode Private Key${NC}. Leave it blank to generate a new ${RED}Masternode Private Key${NC} for you:"
  read -e COINKEY
  if [[ -z "$COINKEY" ]]; then
  $COIN_PATH$COIN_DAEMON -daemon
  sleep 30
  if [ -z "$(ps axo cmd:100 | grep $COIN_DAEMON)" ]; then
   echo -e "${RED}$COIN_NAME server couldn not start. Check /var/log/syslog for errors.{$NC}"
   exit 1
  fi
  COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  if [ "$?" -gt "0" ];
    then
    echo -e "${RED}Wallet not fully loaded. Let us wait and try again to generate the Private Key${NC}"
    sleep 30
    COINKEY=$($COIN_PATH$COIN_CLI masternode genkey)
  fi
  $COIN_PATH$COIN_CLI stop
fi
clear
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
logintimestamps=1
maxconnections=256
#bind=$NODEIP
masternode=1
externalip=$NODEIP:$COIN_PORT
masternodeprivkey=$COINKEY
addnode=167.99.234.180
addnode=198.199.96.58
addnode=159.65.67.167
addnode=167.99.155.35
addnode=185.121.139.157
addnode=194.67.195.147
addnode=94.177.201.230
addnode=45.77.23.168
addnode=144.76.186.55
addnode=144.76.186.56
addnode=139.99.113.246
addnode=139.99.113.247
addnode=139.99.98.157
addnode=139.99.38.114
addnode=144.202.57.180
addnode=173.212.225.221
addnode=185.220.121.247
addnode=35.185.2.50
addnode=188.166.118.9
addnode=51.15.232.225
addnode=51.15.225.60
addnode=188.25.103.55
addnode=198.13.62.116
addnode=194.182.82.178
addnode=45.76.166.121
addnode=144.168.44.229
addnode=45.76.33.250
addnode=149.28.96.193
addnode=35.196.130.190
addnode=159.89.116.47
addnode=46.166.139.73
addnode=46.166.139.95
addnode=45.32.21.74
addnode=149.28.27.230
addnode=149.28.23.219
addnode=140.82.43.191
addnode=40.121.194.132
addnode=138.91.121.171
addnode=45.32.221.232
addnode=149.28.173.153
addnode=107.191.50.171
addnode=185.121.139.157
addnode=45.22.221.131
addnode=144.202.28.53
addnode=45.76.253.201
addnode=144.202.28.144
addnode=149.28.102.150
addnode=144.202.23.78
addnode=144.202.22.172
addnode=144.202.23.187
addnode=149.28.121.45
addnode=217.69.0.88
addnode=217.69.0.114
addnode=159.65.135.91
addnode=207.148.77.233
addnode=108.61.162.217
addnode=207.148.97.65
addnode=207.148.122.106
addnode=245.77.177.38
addnode=104.238.183.17
addnode=207.148.116.69
addnode=45.76.220.103
addnode=45.32.242.137
addnode=199.247.1.16
addnode=149.28.37.122
addnode=63.209.33.175
addnode=45.77.223.47
addnode=45.77.136.185
addnode=217.69.0.111
addnode=68.114.79.172
addnode=108.61.198.246
addnode=165.227.171.94
addnode=178.62.103.151
addnode=167.99.217.240
addnode=159.89.158.211
addnode=45.76.46.69
addnode=45.32.187.55
addnode=45.76.46.69
addnode=45.32.187.55
addnode=149.28.141.194
addnode=149.28.135.209
addnode=128.199.112.233
addnode=40.121.194.132
addnode=138.91.121.171
addnode=195.252.93.101
addnode=207.246.95.107
addnode=206.189.154.226
addnode=104.236.113.239
addnode=108.160.141.190
addnode=85.255.10.10
addnode=107.175.144.2
addnode=185.121.139.157
addnode=51.38.176.68
addnode=79.137.83.22
addnode=139.99.98.35
addnode=139.99.98.88
addnode=139.99.98.89
addnode=149.28.173.153
addnode=207.148.81.143
addnode=149.28.173.225
addnode=107.175.115.253
addnode=107.175.115.76
addnode=140.82.46.194
addnode=108.61.173.213
addnode=149.28.113.128
addnode=202.182.111.23
addnode=45.76.228.111
addnode=149.28.48.110
addnode=149.28.102.131
addnode=149.28.61.66
addnode=45.77.93.168
addnode=149.28.62.28
addnode=165.227.2.20
addnode=95.179.135.141
addnode=185.159.129.31
addnode=185.233.104.186
addnode=173.249.2.199
addnode=45.77.150.255
addnode=202.182.111.23
addnode=164.132.91.234
addnode=45.76.5.103
addnode=207.148.22.17
addnode=207.148.11.188
addnode=52.42.26.22
addnode=207.246.122.108
addnode=144.202.70.85
addnode=149.28.36.121
addnode=95.179.134.171
addnode=198.13.52.197
addnode=108.61.198.204
addnode=149.28.123.41
addnode=45.77.194.182
addnode=209.250.229.171
addnode=45.32.159.125
addnode=199.247.23.239
addnode=144.202.46.190
addnode=45.77.55.119
addnode=209.250.232.8
addnode=198.13.47.151
addnode=45.76.43.150
addnode=45.76.238.185
addnode=80.240.20.252
addnode=149.28.129.206
addnode=144.202.77.213
addnode=149.28.112.105
addnode=202.182.96.5
addnode=207.148.5.89
addnode=207.148.0.99
addnode=107.191.45.235
addnode=95.179.135.21
addnode=45.77.116.205
addnode=149.28.115.19
addnode=144.202.61.178
addnode=128.199.98.0
addnode=149.28.62.165
addnode=45.76.225.104
addnode=207.246.77.141
addnode=149.28.108.49
addnode=140.82.57.6
addnode=95.179.140.207
addnode=47.77.115.73
addnode=199.247.1.131
addnode=159.69.6.115
addnode=23.94.54.125
addnode=107.175.115.94
addnode=107.175.115.97
addnode=107.172.27.87
addnode=50.3.70.40
addnode=107.174.59.154
EOF
}

function update_config() {
  sed -i 's/daemon=1/daemon=0/' $CONFIGFOLDER/$CONFIG_FILE
  cat << EOF >> $CONFIGFOLDER/$CONFIG_FILE
wget https://github.com/ipsum-network/seeds/blob/master/README.md

sed -ni 's/.*\(addnode=\)/\1/p' README.md

cat README.md >> .ips/ips.conf
EOF
}


function enable_firewall() {
  echo -e "Installing and setting up firewall to allow ingress on port ${GREEN}$COIN_PORT${NC}"
  ufw allow $COIN_PORT/tcp comment "$COIN_NAME MN port" >/dev/null
  ufw allow $RPC_PORT/tcp comment "$COIN_NAME RPC port" >/dev/null
  ufw allow ssh comment "SSH" >/dev/null 2>&1
  ufw limit ssh/tcp >/dev/null 2>&1
  ufw default allow outgoing >/dev/null 2>&1
  echo "y" | ufw enable >/dev/null 2>&1
}


function get_ip() {
  declare -a NODE_IPS
  for ips in $(netstat -i | awk '!/Kernel|Iface|lo/ {print $1," "}')
  do
    NODE_IPS+=($(curl --interface $ips --connect-timeout 2 -s4 icanhazip.com))
  done

  if [ ${#NODE_IPS[@]} -gt 1 ]
    then
      echo -e "${GREEN}More than one IP. Please type 0 to use the first IP, 1 for the second and so on...${NC}"
      INDEX=0
      for ip in "${NODE_IPS[@]}"
      do
        echo ${INDEX} $ip
        let INDEX=${INDEX}+1
      done
      read -e choose_ip
      NODEIP=${NODE_IPS[$choose_ip]}
  else
    NODEIP=${NODE_IPS[0]}
  fi
}


function compile_error() {
if [ "$?" -gt "0" ];
 then
  echo -e "${RED}Failed to compile $COIN_NAME. Please investigate.${NC}"
  exit 1
fi
}


function checks() {
if [[ $(lsb_release -d) != *16.04* ]]; then
  echo -e "${RED}You are not running Ubuntu 16.04. Installation is cancelled.${NC}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}$0 must be run as root.${NC}"
   exit 1
fi

if [ -n "$(pidof $COIN_DAEMON)" ] || [ -e "$COIN_DAEMOM" ] ; then
  echo -e "${RED}$COIN_NAME is already installed.${NC}"
  exit 1
fi
}

function prepare_system() {
echo -e "Prepare the system to install ${GREEN}$COIN_NAME${NC} master node."
apt-get update >/dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -y -qq upgrade >/dev/null 2>&1
apt install -y software-properties-common >/dev/null 2>&1
echo -e "${GREEN}Adding bitcoin PPA repository"
apt-add-repository -y ppa:bitcoin/bitcoin >/dev/null 2>&1
echo -e "Installing required packages, it may take some time to finish.${NC}"
apt-get update >/dev/null 2>&1
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" make software-properties-common \
build-essential libtool autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev \
libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git wget curl libdb4.8-dev bsdmainutils libdb4.8++-dev \
libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev  libdb5.3++ unzip libzmq5 >/dev/null 2>&1
if [ "$?" -gt "0" ];
  then
    echo -e "${RED}Not all required packages were installed properly. Try to install them manually by running the following commands:${NC}\n"
    echo "apt-get update"
    echo "apt -y install software-properties-common"
    echo "apt-add-repository -y ppa:bitcoin/bitcoin"
    echo "apt-get update"
    echo "apt install -y make build-essential libtool software-properties-common autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev \
libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev sudo automake git curl libdb4.8-dev \
bsdmainutils libdb4.8++-dev libminiupnpc-dev libgmp3-dev ufw pkg-config libevent-dev libdb5.3++ unzip libzmq5"
 exit 1
fi
clear
}

function important_information() {
 echo -e "================================================================================================================================"
 echo -e "$COIN_NAME Masternode is up and running listening on port ${RED}$COIN_PORT${NC}."
 echo -e "Configuration file is: ${RED}$CONFIGFOLDER/$CONFIG_FILE${NC}"
 echo -e "Start: ${RED}systemctl start $COIN_NAME.service${NC}"
 echo -e "Stop: ${RED}systemctl stop $COIN_NAME.service${NC}"
 echo -e "VPS_IP:PORT ${RED}$NODEIP:$COIN_PORT${NC}"
 echo -e "MASTERNODE PRIVATEKEY is: ${RED}$COINKEY${NC}"
 echo -e "Please check ${RED}$COIN_NAME${NC} daemon is running with the following command: ${RED}systemctl status $COIN_NAME.service${NC}"
 echo -e "Use ${RED}$COIN_CLI masternode status${NC} to check your MN."
 if [[ -n $SENTINEL_REPO  ]]; then
  echo -e "${RED}Sentinel${NC} is installed in ${RED}$CONFIGFOLDER/sentinel${NC}"
  echo -e "Sentinel logs is: ${RED}$CONFIGFOLDER/sentinel.log${NC}"
 fi
 echo -e "================================================================================================================================"
}

function setup_node() {
  get_ip
  create_config
  create_key
  update_config
  enable_firewall
  important_information
  configure_systemd
}


##### Main #####
clear

checks
prepare_system
download_node
setup_node

