clear
sleep 1
if [ -e getraceinfo.json ]
then
	echo " "
	echo "Script running already?"
	echo " "

else
echo "blah" > getraceinfo.json

sudo apt-get install jq pwgen -y

#killall raced
#rm -rf race*
#rm -rf .race*

wget https://github.com/racecrypto/racecoin/releases/download/v0.12.2.3/racecore-0.12.2-linux64.tar.bz2
tar xf racecore-0.12.2-linux64.tar.bz2
mv racecore-0.12.2.3-linux64 ~/racecoin
rm racecore-0.12.2-linux64.tar.bz2

mkdir ~/.racecore
RPCU=$(pwgen -1 4 -n)
PASS=$(pwgen -1 14 -n)
EXIP=$(curl ipinfo.io/ip)
printf "rpcuser=rpc$RPCU\nrpcpassword=$PASS\nrpcport=8801\nrpcthreads=8\nrpcallowip=127.0.0.1\nbind=$EXIP:8800\nmaxconnections=128\ngen=0\nexternalip=$EXIP\ndaemon=1\n\naddnode=54.38.79.148:8800\naddnode=77.68.76.112:8800\naddnode=77.68.95.52:8800\naddnode=77.68.76.112\naddnode=207.246.112.32:8800\naddnode=101.132.172.55\naddnode=103.69.195.185\naddnode=103.82.248.2\naddnode=104.168.52.134\n\n" > ~/.racecore/race.conf

~/racecoin/raced -daemon
sleep 10
MKEY=$(~/racecoin/race-cli masternode genkey)
~/racecoin/race-cli stop
echo -e "masternode=1\nmasternodeprivkey=$MKEY\n\n" >> ~/.racecore/race.conf
sleep 10
~/racecoin/raced -daemon

###########################################################################









echo "Installing more dependencies..."

#22
sudo apt-get -y install virtualenv python-virtualenv

echo "Downloading Sentinel..."

#23
git clone https://github.com/RaceCurrencyOfficial/sentinel.git && cd sentinel
sleep 5

echo "Installing Sentinel..."

#24
virtualenv ./venv
sleep 2
./venv/bin/pip install -r requirements.txt
sleep 2

echo "Inserting cron entry..."

#25
crontab -l > mycron
echo "* * * * * cd /home/$USER/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
sleep 10
cd ~/sentinel

echo "Testing Sentinel, all tests should pass..."

#26
./venv/bin/py.test ./test
sleep 1

echo "Stopping RACE daemon..."

#27
sleep 1

echo "Reindexing blockchain..."

~/racecoin/race-cli stop
sleep 5
rm ~/.racecore/mncache.dat
rm ~/.racecore/mnpayments.dat
~/racecoin/raced -daemon -reindex
sleep 2

################################################################################

sleep 10
ARRAY=$(~/racecoin/race-cli getinfo)
echo "$ARRAY" > getraceinfo.json
BLOCKCOUNT=$(curl http://explorer.racecurrency.com/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getraceinfo.json)
while [ "$menu" != 1 ]; do
	case "$WALLETBLOCKS" in
		"$BLOCKCOUNT" )      
			echo "Complete!"
			menu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting..."
			echo " "
			echo "  Blocks required: $BLOCKCOUNT"
			echo "    Blocks so far: $WALLETBLOCKS"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors or 'Blocks required' is blank,"
			echo "    you are safe to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the block"
			echo "    sync will then continue in the background."
			sleep 20
			BLOCKCOUNT=$(curl http://explorer.racecurrency.com/api/getblockcount)
			ARRAY=$(~/racecoin/race-cli getinfo)
			echo "$ARRAY" > getraceinfo.json
			WALLETBLOCKS=$(jq '.blocks' getraceinfo.json)
			;;
	esac
done
#echo "Now wait for AssetID: 999..."
sleep 1
MNSYNC=$(~/racecoin/race-cli mnsync status)
echo "$MNSYNC" > mnracesync.json
ASSETID=$(jq '.AssetID' mnracesync.json)
echo "Current Asset ID: $ASSETID"
ASSETTARGET=999
while [ "$meanu" != 1 ]; do
	case "$ASSETID" in
		"$ASSETTARGET" )      
			clear
			echo " "
			echo " "
			echo "  No more waiting :) "
			echo " "
			echo "  AssetID: $ASSETID"
			sleep 2
			meanu=1
			break
			;;
		* )
			clear
			echo " "
			echo " "
			echo "  Keep waiting... "
			echo " "
			echo "  Looking for: 999"
			echo "      AssetID: $ASSETID"
			echo " "
			echo " "
			echo " "
			echo "  - If you see any errors, you are safe"
			echo "    to exit from this screen by holding:"
			echo "    CTRL + C"
			echo " "
			echo "  - Holding CTRL + C will exit this script and the"
			echo "    block sync will then continue in the background."
			sleep 5
			MNSYNC=$(~/racecoin/race-cli mnsync status)
			echo "$MNSYNC" > mnracesync.json
			ASSETID=$(jq '.AssetID' mnracesync.json)
			;;
	esac
done
rm mnracesync.json
echo " "
echo " "
~/racecoin/race-cli mnsync status
echo " "


THISHOST=$(hostname -f)
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
sleep 2
echo "=================================="
echo " "
echo "So your masternode.conf should start with:"
echo " "
echo "$THISHOST $EXIP:8800 $MKEY TXID VOUT"
echo " "
echo "=================================="
echo " "
echo "Your server hostname is $THISHOST and you can change it to MN1 or MN2 or whatever you like"
echo " "
sleep 3
echo " "
echo "  - You can now Start Alias in the windows wallet!"
echo " "
echo "       Thanks for using MadStu's Install Script"
echo " "

rm getraceinfo.json

fi

