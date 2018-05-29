#!/bin/bash
# MadStu's Small Install Script
cd ~
wget https://raw.githubusercontent.com/MadStu/RACE/master/newracemn.sh
chmod 777 newracemn.sh
sed -i -e 's/\r$//' newracemn.sh
./newracemn.sh
