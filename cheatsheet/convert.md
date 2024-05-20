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
convert resized/*.jpg output.pdf

