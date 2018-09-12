# Linux VPS Xavander Daemon Installation Guide

## Connect to your Linux VPS over SSH

  * Use your favorite terminal application on Linux or Putty/Bitvise clients on Windows
  * Connect to a terminal session with the Linux VPS
  
## Update your system to the latest

  * From the terminal session, run the following commands
  ```
  sudo apt-get update
  sudo apt-get upgrade
  ```
  
## Download the Xavander Linux Daemon

  * From the terminal session, run the following command
  ```
  wget https://github.com/MotoAcidic/Xavander-Core/releases/download/v1.0.0.1/Xavander-Linux.tar.gz
  ```
  * From the terminal session, run the following command
  ```
  tar -xvf Xavander-Linux.tar.gz
  ```
  
## Install Xavander Linux Daemon Runtime Dependencies

  * From the terminal session, run the following commands
  ```
  sudo apt autoremove -y && sudo apt-get update
  sudo apt-get install -y libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev
  sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config
  sudo apt-get install -y bsdmainutils software-properties-common
  sudo apt-get install -y libboost-all-dev
  sudo add-apt-repository ppa:bitcoin/bitcoin -y
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
  ```
  
## Create your Xavander Linux Daemon configuration file

* From the terminal session, run the following commands
```
mkdir -p ~/.xavander
nano ~/.xavander/xavander.conf
```

* Now add the following lines to this file, replacing any < > field with your information
  * Note: If your setting up a Linux Hot/Cold Wallet, comment out the masternode entries
```
rpcuser=<rpcusername>
rpcpassword=<rpcpassword>
rpcport=35551
listen=1
server=1
daemon=1
staking=0
rpcallowip=127.0.0.1
logtimestamps=1
masternode=1
port=35550
externalip=<externalip>:35550
masternodeprivkey=<masternode private key>
addnode=23.94.183.5
addnode=107.172.249.143
addnode=172.245.6.154
addnode=107.174.66.241
```

* Get the latest node seeds from 
* Copy and paste the addnode lines into the bottom of this file
* Save and Exit

## Start the Xavander Linux Daemon

```
./xavanderd
```

## Wait for the Xavander Linux Daemon to sync

* From the terminal session, run the following commands
```
watch ./xavander-cli getinfo
```

