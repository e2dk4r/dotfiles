# Capturing TLS traffic on Android/Linux using ebpf

To capture traffic from android use
[ecapture](https://github.com/gojue/ecapture/releases). 

| Platform              | Requirement   |
|-----------------------|---------------|
| Linux/Android x86_64  | kernel >=4.18 |
| Linux/Android aarch64 | kernel >=5.5  |

```
$ adb root
$ adb push ecapture-v1.3.1-android-arm64/ecapture /tmp/ecapture
$ adb shell chmod 755 /tmp/ecapture
$ # open
$ adb shell /tmp/ecapture tls -m keylog -k /tmp/capture.keylog
^C
$ adb shell /tmp/ecapture tls -m pcap -w /tmp/capture.pcapng
^C
$ adb pull /tmp/capture.pcapng /tmp/capture.keylog ./
```

# View captured pcap file

You can view pcap file with `wireshark`, `tshark`, or `termshark`

```
SSLKEYLOGFILE=capture.keylog termshark -r capture.pcapng
```
