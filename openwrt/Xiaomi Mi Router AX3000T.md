
# Firmware

Build your custom openwrt firmware with [firmware selector](https://firmware-selector.openwrt.org/?version=SNAPSHOT&target=mediatek%2Ffilogic&id=xiaomi_mi-router-ax3000t).

# Installed Packages

My defaults are:

```
base-files
ca-bundle
dnsmasq
openssh-server
openssh-sftp-server
firewall4
fitblk
fstools
kmod-crypto-hw-safexcel
kmod-gpio-button-hotplug
kmod-leds-gpio
kmod-nft-offload
libc
libgcc
logd
mtd
netifd
nftables
odhcp6c
odhcpd-ipv6only
ppp
ppp-mod-pppoe
procd-ujail
uboot-envtools
urandom-seed
urngd
wpad-basic-wolfssl
kmod-mt7915e
kmod-mt7981-firmware
mt7981-wo-firmware
sqm-scripts
```

Diff from default:

```diff
--- a/installed_packages
+++ b/installed_packages
@@ -1,8 +1,8 @@
-apk-mbedtls
 base-files
 ca-bundle
 dnsmasq
-dropbear
+openssh-server
+openssh-sftp-server
 firewall4
 fitblk
 fstools
@@ -12,7 +12,6 @@
 kmod-nft-offload
 libc
 libgcc
-libustream-mbedtls
 logd
 mtd
 netifd
@@ -23,12 +22,11 @@
 ppp-mod-pppoe
 procd-ujail
 uboot-envtools
-uci
-uclient-fetch
 urandom-seed
 urngd
-wpad-basic-mbedtls
+wpad-basic-wolfssl
 kmod-mt7915e
 kmod-mt7981-firmware
 mt7981-wo-firmware
-luci
+sqm-scripts
```

# After Install

You can use [my /etc/config/...](./etc/config/) templates.
Quick grep with query `<[A-Z_]+>` show variable that you can change
