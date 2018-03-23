#!/bin/bash
EXIP=YOUR.IP.ADDRESS.HERE
PASS=RANDOMPASSWORD
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get install nano htop git -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y
sudo apt-get install libboost-all-dev -y
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libminiupnpc-dev -y
sudo mkdir $HOME/tempRACE
sudo chmod -R 777 $HOME/tempRACE
sudo git clone https://github.com/racecrypto/racecoin $HOME/tempRACE
cd $HOME/tempRACE
sudo chmod 777 autogen.sh
sudo ./autogen.sh
sudo ./configure
sudo chmod +x share/genbuild.sh
sudo make
sudo make install
cd $HOME
sudo mkdir $HOME/racecoin
sudo mkdir $HOME/.racecore
cp $HOME/tempRACE/src/raced $HOME/racecoin
cp $HOME/tempRACE/src/race-cli $HOME/racecoin
sudo chmod -R 777 $HOME/racecoin
sudo chmod -R 777 $HOME/.racecore
printf "rpcuser=racerpcuser\nrpcpassword=$PASS\nrpcport=8801\ndaemon=1\nlisten=1\nserver=1\nmaxconnections=256\nrpcallowip=127.0.0.1\nexternalip=$EXIP:8800\naddnode=77.68.76.112\n\n" > /$HOME/.racecore/race.conf
