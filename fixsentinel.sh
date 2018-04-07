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
sleep 60
race-cli getinfo
cd ~/sentinel
venv/bin/python bin/sentinel.py
race-cli stop
sleep 8
raced -daemon 
sleep 60
race-cli mnsync status
sleep 10
echo "Waiting again..."
race-cli stop
sleep 8
raced -daemon
sleep 5
race-cli mnsync status
sleep 2
echo "Copy the following command:"
echo "race-cli mnsync status"
sleep 8
echo "When you see AssetID: 999, you can Start Alias on your windows wallet."