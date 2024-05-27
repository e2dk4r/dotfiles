# scan

- Scan colored A4 file at 600dpi
```
hp-scan --logging=none --mode=color --resolution=600 --size=a4 --compression=jpeg --output=page01.jpg
```
| hp-scan properties | values               |
|--------------------|----------------------|
| --mode=            | gray, color, lineart |
| --resolution=<dpi> | 300, 600, 1200       |

- Scan gray cycle 10x50mm file at 1200dpi
```
hp-scan --logging=none --mode=color --resolution=1200 --units=mm --box=0,0,10,50 --compression=jpeg --output=page02.jpg
```

# convert

In Linux, "convert" typically refers to the "convert" command-line tool provided by the ImageMagick software suite.
ImageMagick is a powerful collection of tools and libraries for image manipulation, capable of performing a wide
range of tasks such as image conversion, resizing, cropping, and more.

# Convert all jpeg files to pdf

1. make sure they are in right format
```
for i in $(ls page*.jpg); do convert $i -format jpg -density 0x0 -compress JPEG -quality 80 -resize 40% ../resized/$i; done
```

2. convert
```
convert resized/*.jpg output.pdf
```
