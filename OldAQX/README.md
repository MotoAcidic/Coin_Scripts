Installation guide for running the AQX VPS install script

Step 1 - Download the install script
```
wget -q https://raw.githubusercontent.com/MotoAcidic/Coin_Scripts/master/OldAQX/aqx_install.sh
```

Step 2 - Run the script
```
chmod u+x aqx_install.sh
```
```
./AQX_Install.sh
```
Step 3 - Start Aquila
```
./Aquilad -daemon
```
If you get a message asking to rebuild the database, please hit Ctr + C and run ./Aquilad -daemon -reindex
