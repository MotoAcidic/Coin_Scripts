
# Linux VPS ADD Testnet Daemon Installation Guide

## Connect to your Linux VPS over SSH

  * Use your favorite terminal application on Linux or Putty/Bitvise clients on Windows
  * Connect to a terminal session with the Linux VPS
  
## Install ADD Testnet Linux Daemon Runtime Dependencies

  * From the terminal session, run the following commands
  ```
cd &&  bash -c "$(wget -O - https://github.com/MotoAcidic/Coin_Scripts/raw/master/Script/depends.sh)"

  ```
  
## Download the ADD Testnet Linux Daemon

  * From the terminal session, run the following command
  ```
  wget https://github.com/AD-Node/AdNode/releases/download/v1.0.0.0/ADD-linux.tar.gz
  ```
  * From the terminal session, run the following command
  ```
  tar -xvf ADD-linux.tar.gz
  ```
  
## Create your ADD Testnet Linux Daemon configuration file

* From the terminal session, run the following commands
```
mkdir -p ~/.add
nano ~/.add/add.conf
```

* Now add the following lines to this file, replacing any < > field with your information
  * Note: If your setting up a Linux Hot/Cold Wallet, comment out the masternode entries
```
rpcuser=<rpcusername>
rpcpassword=<rpcpassword>
rpcport=12152
listen=1
server=1
daemon=1
staking=0
rpcallowip=127.0.0.1
logtimestamps=1
masternode=1
port=2152
externalip=<externalip>:2152
masternodeprivkey=<masternode private key>
addnode=45.63.8.76
addnode=149.28.229.71
addnode=149.28.59.78
addnode=45.76.14.241
```

* Get the latest node seeds from 
* Copy and paste the addnode lines into the bottom of this file
* Save and Exit

## Start the ABA Linux Daemon

```
./abad 
```

## Wait for the MIT Linux Daemon to sync

* From the terminal session, run the following commands
```
watch ./aba-cli getinfo
```

