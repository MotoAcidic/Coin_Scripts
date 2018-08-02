# Installation guide for running the CCBC VPS install script
# Step 1 
  * Download the install script
```    
wget -q https://raw.githubusercontent.com/MotoAcidic/Coin_Scripts/master/CCBC/ccb_script.sh

```
# Step 2
  * Run the script and input the proper information during the prompts
```
chmod u+x ccb_script.sh
./ccb_script.sh

```

# Step 3
  * Start Aquila
```
./cryptocashbackd -daemon

```
  * If you get a message asking to rebuild the database, please hit Ctr + C and run ./cryptocashbackd -daemon -reindex
