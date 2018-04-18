#!/bin/bash

clear
echo " "
echo "==============================="
echo "==                           =="
echo "==  MadStu's Install Script  =="
echo "==      Compiling Race       =="
echo "==                           =="
echo "==============================="
echo " "
if [ -e RACEinstall.log ]
then
	echo "The script may be running already or it's already been run."
	echo "Please delete or rename RACEinstall.log if you wish to run script again."
	echo " "
	echo "If you've already run this script and it failed to complete, please contact MadStu on the Race Discord server with the log file so he can see what the problem is."
else
echo " "
echo "Please pick an install speed"
echo "Slow should work on all systems but takes a lot longer"
echo " "
select CONFIGOPTION in Fast Slow
do
	case $CONFIGOPTION in
	Fast|Slow)
		break
		;;
	*)
		echo "Invalid Selection"
		;;
	esac
done
echo "You have selected $CONFIGOPTION mode"
echo " "
echo "The script will begin 5 seconds..."
sleep 1
echo " "
echo "You may be asked for your password during the install..."
echo " "
sleep 5

LOGFILE=/$HOME/RACEinstall.log
echo "Updating..."
echo "   #01" >> $LOGFILE 2>&1

#01
sudo apt-get update -y >> $LOGFILE 2>&1

echo "Upgrading..."
echo "   #02" >> $LOGFILE 2>&1

#02
sudo apt-get upgrade -y >> $LOGFILE 2>&1

echo "..."
echo "   #03" >> $LOGFILE 2>&1

#03
sudo apt-get dist-upgrade -y >> $LOGFILE 2>&1

echo "Installing..."
echo "   #04" >> $LOGFILE 2>&1

#04
sudo apt-get install nano htop git -y >> $LOGFILE 2>&1

echo "..."
echo "   #05" >> $LOGFILE 2>&1

#05
sudo apt-get install build-essential jq libtool autotools-dev pwgen automake pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common libgmp3-dev -y >> $LOGFILE 2>&1
echo "Still Installing..."
echo "   #06" >> $LOGFILE 2>&1

#06
sudo apt-get install libboost-all-dev -y >> $LOGFILE 2>&1

echo "Adding new repository..."
echo "   #07" >> $LOGFILE 2>&1

#07
sudo add-apt-repository ppa:bitcoin/bitcoin -y >> $LOGFILE 2>&1

echo "..."
echo "   #08" >> $LOGFILE 2>&1

#08
sudo apt-get update -y >> $LOGFILE 2>&1

echo "Installing more stuff..."
echo "   #09" >> $LOGFILE 2>&1

#09
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y >> $LOGFILE 2>&1

echo "..."
echo "   #10" >> $LOGFILE 2>&1

#10
sudo apt-get install libminiupnpc-dev -y >> $LOGFILE 2>&1

echo "Downloading RACE files..."
echo "   #11" >> $LOGFILE 2>&1

#11
sudo mkdir $HOME/tempRACE >> $LOGFILE 2>&1
sudo chmod -R 777 $HOME/tempRACE >> $LOGFILE 2>&1
sudo git clone https://github.com/RaceCurrencyOfficial/racecoin-core $HOME/tempRACE >> $LOGFILE 2>&1

echo "Generating..."
echo "   #12" >> $LOGFILE 2>&1

#12
cd $HOME/tempRACE >> $LOGFILE 2>&1
sudo chmod 777 autogen.sh >> $LOGFILE 2>&1
sudo ./autogen.sh >> $LOGFILE 2>&1

echo "Configuring..."
echo "   #13" >> $LOGFILE 2>&1

#13
if [ $CONFIGOPTION == "Fast" ]
then
	sudo ./configure --without-gui >> $LOGFILE 2>&1
	echo "Now Making. This may take around 30 minutes. Leave it running, don't close your SSH session..."
	echo " "
else
	sudo ./configure --without-gui CXXFLAGS="--param ggc-min-expand=1 --param ggc-min-heapsize=32768" >> $LOGFILE 2>&1
	echo "Now Making. This may take up to 2 hours. Leave it running, don't close your SSH session..."
	echo " "
fi

echo "If you're running in a 'screen' press CTRL+A CTRL+D to leave the script running."
echo " "
echo "You can then return to this screen later to check progress by typing:"
echo "screen -r"
echo " "
echo "   #14  " >> $LOGFILE 2>&1

#14
sudo chmod +x share/genbuild.sh >> $LOGFILE 2>&1
sudo make >> $LOGFILE 2>&1

echo "Installing..."
echo "   #15" >> $LOGFILE 2>&1

#15
sudo make install >> $LOGFILE 2>&1

echo "Copying files..."
echo "   #16" >> $LOGFILE 2>&1

#16
cd $HOME >> $LOGFILE 2>&1
sudo mkdir $HOME/racecoin >> $LOGFILE 2>&1
sudo mkdir $HOME/.racecore >> $LOGFILE 2>&1
cp $HOME/tempRACE/src/raced $HOME/racecoin >> $LOGFILE 2>&1
cp $HOME/tempRACE/src/race-cli $HOME/racecoin >> $LOGFILE 2>&1
sudo chmod -R 777 $HOME/racecoin >> $LOGFILE 2>&1
sudo chmod -R 777 $HOME/.racecore >> $LOGFILE 2>&1

echo "Writing configuration file..."
echo "   #17" >> $LOGFILE 2>&1

#17
RPCU=$(pwgen -1 4 -n) >> $LOGFILE 2>&1
PASS=$(pwgen -1 14 -n) >> $LOGFILE 2>&1
EXIP=$(curl ipinfo.io/ip) >> $LOGFILE 2>&1
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=8801\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:8800\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=54.38.79.148:8800\naddnode=77.68.76.112:8800\naddnode=77.68.95.52:8800\naddnode=77.68.76.112\naddnode=207.246.112.32:8800\naddnode=101.132.172.55\naddnode=103.69.195.185\naddnode=103.82.248.2\naddnode=104.168.52.134\n\n" > /$HOME/.racecore/race.conf

echo "Starting RACE daemon..."
echo "   #18" >> $LOGFILE 2>&1

#18
raced -daemon >> $LOGFILE 2>&1
sleep 2
echo "Running for 30 seconds then stopping..."
echo "   #19" >> $LOGFILE 2>&1

#19
sleep 30
MKEY=$(race-cli masternode genkey) >> $LOGFILE 2>&1
race-cli stop >> $LOGFILE 2>&1

echo "Inserting masternodeprivkey into config file..."
echo "   #20" >> $LOGFILE 2>&1

#20
sleep 2
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> /$HOME/.racecore/race.conf
sleep 10

echo "Starting race daemon again..."
echo "   #21" >> $LOGFILE 2>&1

#21
raced -daemon >> $LOGFILE 2>&1
sleep 1

echo "Installing more dependencies..."
echo "   #22" >> $LOGFILE 2>&1

#22
sudo apt-get -y install virtualenv python-virtualenv >> $LOGFILE 2>&1

echo "Downloading Sentinel..."
echo "   #23" >> $LOGFILE 2>&1

#23
git clone https://github.com/RaceCurrencyOfficial/sentinel.git && cd sentinel >> $LOGFILE 2>&1
sleep 5

echo "Installing Sentinel..."
echo "   #24" >> $LOGFILE 2>&1

#24
virtualenv ./venv >> $LOGFILE 2>&1
sleep 2
./venv/bin/pip install -r requirements.txt >> $LOGFILE 2>&1
sleep 2

echo "Inserting cron entry..."
echo "   #25" >> $LOGFILE 2>&1

#25
crontab -l > mycron
echo "* * * * * cd /home/$USER/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
crontab mycron >> $LOGFILE 2>&1
rm mycron >> $LOGFILE 2>&1
sleep 10
cd ~/sentinel >> $LOGFILE 2>&1

echo "Testing Sentinel, all tests should pass..."
echo "   #26" >> $LOGFILE 2>&1

#26
./venv/bin/py.test ./test
sleep 1
./venv/bin/py.test ./test >> $LOGFILE 2>&1
sleep 2

echo "Stopping RACE daemon..."
echo "   #27" >> $LOGFILE 2>&1

#27
sleep 1
race-cli stop >> $LOGFILE 2>&1

echo "Reindexing blockchain..."






wget https://raw.githubusercontent.com/MadStu/RACE/master/fixsentinel.sh
chmod 777 fixsentinel.sh
sed -i -e 's/\r$//' fixsentinel.sh
./fixsentinel.sh




echo "   #28" >> $LOGFILE 2>&1

#28
sleep 1




echo "Deleting temp folder..."
echo "   #32" >> $LOGFILE 2>&1

#32
sudo rm -rf $HOME/tempRACE >> $LOGFILE 2>&1
sleep 3 
echo " "
echo " "
echo "Now would be a good time to setup your Transaction ID and VOUT from your windows wallet"
echo " "
sleep 3
echo "You'll need the Masternode Key which is:"
echo "$MKEY"
echo " "
sleep 3
echo "You'll also need your server IP which is:"
echo "$EXIP"
echo " "
echo "=================================="
echo " "
sleep 2
echo "So your masternode.conf should start with:"
echo " "
THISHOST=$(hostname -f)
echo "$THISHOST $EXIP:10000 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
sleep 3
race-cli mnsync status >> $LOGFILE 2>&1
echo "Good luck! You got this!!"
rm fixsentinel.sh
echo " --END--" >> $LOGFILE 2>&1
fi