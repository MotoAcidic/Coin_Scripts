# Installation guide for running the IPS VPS script
# Step 1
```    
wget -q https://raw.githubusercontent.com/MotoAcidic/guides/master/scripts/ips_install.sh

```
# Step 2
```
chmod +x ips_install.sh

```
# Step 3

```
./ips_install.sh install

```
# Step 4

```
watch ips-cli getinfo

```

# Step 5
```    
apt install upstart

```
# Step 6
```    
systemctl start Ips

systemctl status Ips

```
