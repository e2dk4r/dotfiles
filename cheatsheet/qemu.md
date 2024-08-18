# Connect usb device to VM

```
$ dmesg
...
[Aug18 13:41] usb 1-5.2: new full-speed USB device number 5 using xhci_hcd
[  +0.100706] usb 1-5.2: New USB device found, idVendor=3537, idProduct=1010, bcdDevice= 6.30
[  +0.000003] usb 1-5.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  +0.000002] usb 1-5.2: Product: GameSir-G7 SE Controller for Xbox
[  +0.000001] usb 1-5.2: Manufacturer: Guangzhou Chicken Run Network Technology Co., Ltd.
...
```

```
qemu-system-x86_64
...
-device usb-host,vendorid=0x3537,productid=0x1010
...
```

see https://www.qemu.org/docs/master/system/devices/usb.html#connecting-usb-devices
