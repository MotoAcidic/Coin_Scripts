
# Linux VPS ABA Testnet Daemon Installation Guide

## Connect to your Linux VPS over SSH

  * Use your favorite terminal application on Linux or Putty/Bitvise clients on Windows
  * Connect to a terminal session with the Linux VPS
  
## Install ABA Testnet Linux Daemon Runtime Dependencies

  * From the terminal session, run the following commands
  ```
cd &&  bash -c "$(wget -O - https://github.com/MotoAcidic/Coin_Scripts/raw/master/Script/depends.sh)"

  ```
  
## Download the ABA Testnet Linux Daemon

  * From the terminal session, run the following command
  ```
  wget https://github.com/AbacusCoin/Abacus/releases/download/v1.0.0.1/ABA-linux.tar.gz
  ```
  * From the terminal session, run the following command
  ```
  tar -xvf ABA-linux.tar.gz
  ```
  
## Create your ABA Testnet Linux Daemon configuration file

* From the terminal session, run the following commands
```
mkdir -p ~/.aba
nano ~/.aba/aba.conf
```

* Now add the following lines to this file, replacing any < > field with your information
  * Note: If your setting up a Linux Hot/Cold Wallet, comment out the masternode entries
```
rpcuser=<rpcusername>
rpcpassword=<rpcpassword>
rpcport=33556
listen=1
server=1
daemon=1
staking=0
rpcallowip=127.0.0.1
logtimestamps=1
masternode=1
port=3355
externalip=<externalip>:3355
masternodeprivkey=<masternode private key>
addnode=8.12.17.12
addnode=45.32.1.34
addnode=208.167.253.34
addnode=45.76.9.47
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

