  sudo apt-get update
  sudo apt-get upgrade
  sudo apt autoremove -y && sudo apt-get update
  sudo apt-get install -y libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev
  sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config
  sudo apt-get install -y bsdmainutils software-properties-common
  sudo apt-get install -y libboost-all-dev
  sudo add-apt-repository ppa:bitcoin/bitcoin -y
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
  rm -rf depends.sh
