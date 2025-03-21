

# Kernel

## Compile your own kernel

Download latest from https://www.kernel.org/

```
$ curl -LO https://git.kernel.org/torvalds/t/linux-6.14-rc7.tar.gz
$ tar xf linux-6.14-rc7.tar.gz
$ cd linux-6.14-rc7/
$ make -j8 nconfig
$ make -j8
```

## Use fedora's kernel

1. Go to https://copr.fedorainfracloud.org/coprs/g/kernel-vanilla/next/builds/

2. Click the latest successful build id. (e.g. `8738621`)

3. Click wanted chroot. (e.g. `fedora-41-x86_64`)

4. Download `kernel-core-*.rpm`. (e.g. `kernel-core-6.14.0-0.0.next.20250307.346.vanilla.fc41.x86_64.rpm`)

```
$ curl -LO https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-41-x86_64/08738621-next-next-all/kernel-core-6.14.0-0.0.next.20250307.346.vanilla.fc41.x86_64.rpm
```

5. Extract `lib/modules/*/vmlinuz` from rpm package. (e.g. `lib/modules/6.14.0-0.0.next.20250319.357.vanilla.fc41.x86_64/vmlinuz`)

```
$ tar xf kernel-core-6.14.0-0.0.next.20250307.346.vanilla.fc41.x86_64.rpm lib/modules/6.14.0-0.0.next.20250319.357.vanilla.fc41.x86_64/vmlinuz 
```

