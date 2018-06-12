# Installation guide for running the IPS VPS script
# Step 1
  * This will download the auto install script to your VPS.
```    
wget -q https://github.com/MotoAcidic/IPS_Scripts/raw/master/ips_install.sh

```
# Step 2
  * This will mount the script 
```
chmod +x ips_install.sh

```
# Step 3
  * This installs the script
```
./ips_install.sh install

```
# Step 4
  * Watch the block number until it gets to the current block height
```
watch ips-cli getinfo

```

# Step 5
  * Install upstart so you can use systemctl commands
```    
apt install upstart

```
# Step 6
  * These are the commands you are able to use
```    
systemctl start Ips

systemctl status Ips

systemctl stop Ips

```
