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

## Prerequisites

To use `magick` from `imagemagick` project, make sure it is compiled with `--with-jpeg`.

To use `pdftoppm` from `poppler` project, make sure it is compiled with `-DENABLE_DCTDECODER=libjpeg`.

## Convert pdf to jpeg files

### with imagemagick

```
magic -density 300 input.pdf -quality 80 page_%02d.jpg
```
This creates `page_00.jpg`, `page_01.jpg`, etc.

### with poppler (faster)

```
pdftoppm -jpeg -r 300 input.pdf page
```

This creates `page-1.jpg`, `page-2.jpg`, etc.

## Convert all jpeg files to pdf

1. make sure they are in right format
```
for i in $(ls page*.jpg); do magick $i -format jpg -density 0x0 -compress JPEG -quality 80 -resize 40% ../resized/$i; done
```

2. convert
```
magick resized/*.jpg output.pdf
```

# postprocess

## edit pdf metadata

We can edit metadata of PDF using `pdfmarks`. This is in [ghostscript](https://ghostscript.com/) package.

See [Cooking up Enhanced PDF with pdfmark Recipes](http://www.meadowmead.com/wp-content/uploads/2011/04/PDFMarkRecipes.pdf) for more.

```sh
$ # create pdfmarks file
$ cat > pdfmarks.txt <<EOF
[
/Title (My Test Document)
/Author (John Doe)
/Subject (pdfmark 3.0)
/Keywords (pdfmark, example, test)
/Creator (Hand Programmed)
/Producer (Jaws PDFCreator)
/CreationDate (D:19940912205731)
/ModDate (D:19940912205731)
/DOCINFO pdfmark
EOF

$ # change metadata of input.pdf
$ gs -dBATCH -dNOPAUSE -dSAFER \
   -sDEVICE=pdfwrite           \
   -sOutputFile=output.pdf     \
   input.pdf pdfmarks.txt

$ # print metadata
$ pdfinfo output.pdf
Title:           My Test Document
Subject:         pdfmark 3.0
Keywords:        pdfmark, example, test
Author:          John Doe
Creator:         Hand Programmed
Producer:        GPL Ghostscript 10.03.1
CreationDate:    Mon Sep 12 23:57:31 1994 EEST
ModDate:         Mon Sep 12 23:57:31 1994 EEST
Custom Metadata: no
Metadata Stream: yes
Tagged:          no
UserProperties:  no
Suspects:        no
Form:            none
JavaScript:      no
Pages:           27
Encrypted:       no
Page size:       595.2 x 841.68 pts (A4)
Page rot:        0
File size:       19121583 bytes
Optimized:       no
PDF version:     1.7
```
