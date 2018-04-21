#!/bin/bash
cd ~/sentinel
clear
echo "==============================="
echo "==                           =="
echo "==  MadStu's Reindex Script  =="
echo "==      Fixing Sentinel      =="
echo "==                           =="
echo "==============================="
echo " "
if [ -e getinfo.json ]
then
	echo "Script running already"
else
echo "blah" > getinfo.json
~/racecoin/race-cli stop
sleep 5
cd ~/.racecore
rm mncache.dat
rm mnpayments.dat
~/racecoin/raced -daemon -reindex
sleep 2
ARRAY=$(~/racecoin/race-cli getinfo)
echo "$ARRAY" > getinfo.json
BLOCKCOUNT=$(curl http://explorer.racecurrency.com/api/getblockcount)
WALLETBLOCKS=$(jq '.blocks' getinfo.json)
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
			sleep 60
			BLOCKCOUNT=$(curl http://explorer.racecurrency.com/api/getblockcount)
			ARRAY=$(~/racecoin/race-cli getinfo)
			echo "$ARRAY" > getinfo.json
			WALLETBLOCKS=$(jq '.blocks' getinfo.json)
			;;
	esac
done
cd ~/sentinel
venv/bin/python bin/sentinel.py
~/racecoin/race-cli stop
sleep 8
~/racecoin/raced -daemon 
sleep 2
echo "Waiting again..."
sleep 60
~/racecoin/race-cli stop
sleep 8
~/racecoin/raced -daemon
sleep 5
echo "Now wait for AssetID: 999..."
sleep 8
MNSYNC=$(~/racecoin/race-cli mnsync status)
echo "$MNSYNC" > mnsync.json
ASSETID=$(jq '.AssetID' mnsync.json)
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
			echo "  AssetID: $ASSETID"
			sleep 10
			MNSYNC=$(~/racecoin/race-cli mnsync status)
			echo "$MNSYNC" > mnsync.json
			ASSETID=$(jq '.AssetID' mnsync.json)
			;;
	esac
done
rm mnsync.json
echo " "
echo " "
~/racecoin/race-cli mnsync status
echo " "
echo " "
echo "  You can now Start Alias in the windows wallet!"
rm getinfo.json
fi