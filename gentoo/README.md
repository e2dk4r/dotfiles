# gentoo

This is my gentoo configuration. 

# emerge

Sometimes `mold` fails with below message.

```
$ less -R /var/tmp/portage/app-emulation/qemu-9.2.2/temp/build.log
mold: fatal: opening subprojects/libvhost-user/libvhost-user-glib.a failed: Too many open files
```

Fix is increasing open files limit.

```
ulimit -n 409600
```
