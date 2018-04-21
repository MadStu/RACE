# Step-by-Step guide to a RACE Masternode setup


## 1. Send 1000 coins to yourself.

If you haven't done so already, install the windows wallet from https://github.com/racecryptocoin/racecoin/releases 
Create a new receive address and call it something like MN1.
Then send 1000 Race coins to the address you just created. Make sure the address receives EXACTLY 1000 coins, so DO NOT tick the "Subtract fee from amount" option.
We now need to wait for 15 confirmations of the transaction so we'll get on with the remote VPS install.



## 2. VPS

Order a VPS. A VPS with 1GB RAM works great for me, although 1 user reports it working fine with 512MB and a swap file (Step 5). Choosing the Ubuntu 16.04 (server version without a desktop) operating system to install on it would be ideal.
A tried and tested place to get a VPS is from: https://goo.gl/hv2Hfc 



## 3. PuTTY Install

If you haven't got any SSH client installed already, please download and run PuTTY from https://www.putty.org/



## 4. New Server Setup

Your VPS provider will give you an IP address and a root password for your new server.
Login in to your server with PuTTY using the IP address. Your username will be "root" and the password is the root password.

Now, update your server and install some dependencies by copying the follwing code:

```
wget https://raw.githubusercontent.com/MadStu/RACE/master/newserver.sh
chmod 777 newserver.sh
sed -i -e 's/\r$//' newserver.sh
./newserver.sh
```

Paste into the putty window by right clicking with your mouse.

It may ask you some questions while installing the dependencies, if it asks to reinstall things which are already installed, just choose yes.

The script will create a new system user named **raceuser** and will generate a random password.
You'll be told the password when the script has finished.

The script will also create a 2GB swap file for you. This helps with a lower priced VPS.

Save your password and reboot the server by typing:

```
reboot
```



## 5. INSTALL

Now log back in using the same IP address, but with the username "raceuser" and the password that was generated for you.

Copy and paste the following into the command line. Enter your raceuser password if asked and let it run. It may take a while.

```
wget https://raw.githubusercontent.com/MadStu/RACE/master/newracemn.sh
chmod 777 newracemn.sh
sed -i -e 's/\r$//' newracemn.sh
./newracemn.sh
```

At the end it'll tell you your masternode key which you'll need to copy and paste into your windows wallet masternode configuration file.

While this is running it's a good idea to now follow step 6 below.



## 6. Configure Windows wallet

Once the 1000 coins you sent earlier has 15 confirmations, you can grab your Transaction ID and VOUT.
Go to the debug console and type:

```
masternode outputs
```

You'll see something like this:

```
"TX_ID": "VOUT"

"f5d4ec12b6ab68977eed84913255ea6685110e5f781e5e525a12bc2fd1c6b9d": "1"
```

The first part is your TX_ID - the second part is your VOUT.
Now open up the masternode configuration file by clicking Tools -> Open Masternode Configuration File Under all # put a new line which consists of the following data:

```
MN_NAME MN_PUBLIC_IP:8800 MN_KEY TX_ID VOUT
```

Save and close the file.
Make sure you have the masternode tab enabled in the settings by going to Settings->Options->Wallet->Show Masternode.
Close and restart the wallet.



## 7. Start your Masternode

On the VPS, type the command:

WAIT until the script has finished running. In the end you'll see AssetID: 999

After the script has finished running, you can verify this yourself by typing:

```
~/racecoin/race-cli mnsync status
```

Once you see it says AssetID: 999 THEN you can Start Alias on your windows wallet.

Start it by going to the masternode tab, right clicking on your masternode and choosing to "Start Alias".

It can take 30 minutes to an hour or more before you see the status change from WATCHDOG_EXPIRED to ENABLED.



***


# PROBLEMS



## Getting an "Unable to bind" error?


Try opening up race.conf using nano:

```
nano ~/.racecore/race.conf
```

Add the following line:

```
listen=0
```

Then restart the race daemon:

```
~/racecoin/race-cli stop
```

Wait 60 seconds...

```
~/racecoin/raced -daemon
```


## Fix WATCHDOG_EXPIRED

If after a couple of hours your masternode status hasn't changed to ENABLED, run the following command:

```
wget https://raw.githubusercontent.com/MadStu/RACE/master/newfixsentinel.sh
chmod 777 newfixsentinel.sh
sed -i -e 's/\r$//' newfixsentinel.sh
./newfixsentinel.sh
```

Use this command again and wait until it returns AssetID: 999

```
~/racecoin/race-cli mnsync status
```

Now Start Alias again in the windows wallet and wait another hour or so for the status to change. 




# Donations

Any donation is highly appreciated  

**RACE**: RLMi169KPSwxbF7DDgWCwwLrFDMQXkRQ5J 

**BTC**: 3MprejNeXAHVvNA4mfrMzymZakE7x2Efra 

**ETH**: 0x9B11A49423bb65936D03df9abB98d00B438b0010 

**LTC**: MC7HmFHhHPQg3pFbzeuTPPXXPe3SZWJJHE 



**Good luck!**