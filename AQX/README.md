# Installation guide for running the AQX VPS install script
# Step 1 
  * Download the install script
```    
wget -q https://raw.githubusercontent.com/turbowrx03/Guides/master/VPS%20Install/AQX_Install.sh

```
# Step 2
  * Run the script and input the proper information during the prompts
```
chmod u+x AQX_Install.sh
./AQX_Install.sh

```

# Step 3
  * Start Aquila
```
./Aquilad -daemon

```
  * If you get a message asking to rebuild the database, please hit Ctr + C and run ./Aquilad -daemon -reindex
