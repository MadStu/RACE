#!/bin/bash

echo "Please enter the password for your new user account when asked..."
sleep 3
sudo apt-get update -y
sudo apt-get install -y pwgen
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
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCUuser\nrpcpassword=$PASS\nbind=$EXIP:8800\nexternalip=$EXIP:8800\ndaemon=1\n\naddnode=77.68.76.112\naddnode=104.238.146.103:8800\naddnode=144.217.73.112:8800\naddnode=178.62.68.57:58012\naddnode=18.219.24.113:43852\naddnode=185.50.24.206:43724\naddnode=199.247.1.129:8800\naddnode=207.148.13.195:8800\naddnode=207.246.112.32:8800\naddnode=45.32.125.221:8800\naddnode=45.77.24.41:8800\naddnode=91.121.90.78:8800\naddnode=101.132.172.55\naddnode=103.208.27.24\naddnode=103.69.195.185\naddnode=103.82.248.2\naddnode=104.168.52.134\naddnode=104.238.149.146\naddnode=107.191.36.247\naddnode=17.191.36.247\n\n" > /$HOME/.racecore/race.conf
raced -daemon
sleep 10
MKEY=$(race-cli masternode genkey)
race-cli stop
sleep 10
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.racecore/race.conf
sleep 10
raced -daemon
sleep 1
sudo apt-get -y install virtualenv python-virtualenv
sleep 1
git clone https://github.com/racecrypto/sentinel.git && cd sentinel
sleep 1
virtualenv ./venv
sleep 10
./venv/bin/pip install -r requirements.txt
sleep 10
crontab -l > mycron
echo "* * * * * cd /home/raceuser/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
sleep 10
cd ~/sentinel
./venv/bin/py.test ./test
sleep 10
race-cli stop
sleep 1
cd ~/.racecore
rm mncache.dat
rm mnpayments.dat
raced -daemon -reindex
sleep 2
echo "Waiting for reindex to complete..."
sleep 10
echo "Keep waiting..."
sleep 20
echo "Just about there..."
sleep 30
race-cli getblockchaininfo
sleep 5
race-cli getinfo
cd ~/sentinel
venv/bin/python bin/sentinel.py
race-cli stop
sleep 5
raced -daemon 
sleep 5
race-cli mnsync status
sleep 10
echo "Waiting again..."
sleep 4
sudo rm -rf $HOME/tempRACE
race-cli mnsync status
sleep 3 
echo "Keep checking the masternode sync status by typing: race-cli mnsync status"
sleep 3
echo "When you see AssetID: 999 then you can Start Alias on your windows wallet..."
sleep 3
echo "Now would be a good time to setup your Transaction ID and VOUT from your windows wallet"
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP"
sleep 3
echo "Good luck! You got this!!"
