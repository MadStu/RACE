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



## 4. New User

Your VPS provider will give you an IP address and a root password for your new server.
Login in to your server with PuTTY using the IP address. Your username will be "root" and the password is the root password.
For this guide I'll use the username "raceuser", you can use whatever username you like. Create a strong password for this user and you can skip past the options asking for your name etc. Type on the command line:

```
adduser raceuser
```

Then make the user a sudoer so he can do root things.

```
usermod -aG sudo raceuser
```



## 5. Create Swap file

Some people have needed more RAM to complete compiling the required software. If you don't need this, skip this step. If you need it, paste the following in to the command line. And then reboot your server.

```
dd if=/dev/zero of=/mnt/myswap.swap bs=1M count=2000
mkswap /mnt/myswap.swap
chmod 600 /mnt/myswap.swap
swapon /mnt/myswap.swap
echo -e "/mnt/myswap.swap none swap sw 0 0 \n" >> /etc/fstab

reboot
```

Now log back in using the same IP address, but with the username "raceuser" and the password you chose.



## 6. SETUP

As it takes a while to install, we first need to increase the time that a user can have sudo (root) rights. So type the following:

```
sudo visudo
```

Go down to the line which looks like:

```
Defaults      env_reset
```

And add the following at the end to change it to this:

```
Defaults      env_reset,timestamp_timeout=240
```

Then save and exit by pressing **CTRL-X**, **Y** and then hitting ENTER.

Now open a screen session by typing:

```
screen
```
Press Enter on your keyboard a couple of times and then copy and paste the following into the command line. Enter your password if asked and let it run. It will take a long time.

```
wget https://raw.githubusercontent.com/MadStu/RACE/master/RACEinstall.sh
chmod 777 RACEinstall.sh
sed -i -e 's/\r$//' RACEinstall.sh
./RACEinstall.sh
```

It may ask you stuff during the process, if it asks to reinstall things which are already installed, just choose yes. And it may also occasionally ask for your password as you'll be sudoing some tasks (which means running with root permissions).
At the end it'll tell you your masternode key which you'll need to copy and paste into your windows wallet masternode configuration file.

When the script says it's "**Making...**" You can exit the screen session and let it run by itself by pressing on your keyboard **CTRL+A** then **CTRL+D**.

It will take around **1 hour 30 minutes** to complete! You can follow what the script is doing by typing

```
tail -f RACEinstall.log
```

This should assure you that it is still installing and hasn't got stuck. When the script has finished, press **CTRL+C** to stop following the log file, then type

```
screen -r
```

This will return you to the screen where you'll see your masternode key which you'll need to configure the windows wallet with in the next step.


## 7. Configure Windows wallet

Once the 1000 coins you sent earlier has 15 confirmations, you can grab your Transaction ID and VOUT.
Go to the debug console and type:

```
masternode outputs
```

You'll see something like this:

```
"f5d4ec12b6ab68977eed84913255ea6685110e5f781e5e525a12bc2fd1c6b9d": "1"
```

The first part is your TRANSACTION ID - the second part is your VOUT.
Now open up the masternode configuration file by clicking Tools -> Open Masternode Configuration File Under all # put a new line which consists of the following data from your skeletion:

```
MN1 MASTERNODE_PUBLIC_IP:8800 MASTERNODE_KEY TRANSACTION_ID VOUT
```

Save and close the file.
Make sure you have the masternode tab enabled in the settings by going to Settings->Options->Wallet->Show Masternode.
Close and restart the wallet.



## 8. Start your Masternode

On the VPS, type the command:

```
race-cli mnsync status
```

You will see an AssetID number. If the number is NOT 999, then you must wait.

Every 1 or 2 minutes, type the race-cli mnsync status command.

Once you see it says AssetID: 999 THEN you can Start Alias on your windows wallet.

Start it by going to the masternode tab, right clicking on your masternode and choosing to "Start Alias".

It can take 30 minutes to an hour or more before you see the status change from WATCHDOG_EXPIRED to ENABLED.



## 9. Fix WATCHDOG_EXPIRED

If after a couple of hours your masternode status hasn't changed to ENABLED, run the following command:

```
wget https://raw.githubusercontent.com/MadStu/RACE/master/fixsentinel.sh
chmod 777 fixsentinel.sh
sed -i -e 's/\r$//' fixsentinel.sh
./fixsentinel.sh
```

Use this command again and wait until it returns AssetID: 999

```
race-cli mnsync status
```

Now Start Alias again in the windows wallet and wait another hour or so for the status to change. 


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
race-cli stop
```

Wait 60 seconds...

```
raced
```


# Donations

Any donation is highly appreciated  

**RACE**: RLMi169KPSwxbF7DDgWCwwLrFDMQXkRQ5J 

**BTC**: 3MprejNeXAHVvNA4mfrMzymZakE7x2Efra 

**ETH**: 0x9B11A49423bb65936D03df9abB98d00B438b0010 

**LTC**: MC7HmFHhHPQg3pFbzeuTPPXXPe3SZWJJHE 



**Good luck!**