# Compile
Compile kernel with

```
make LLVM=1 KCFLAGS='-O3 -march=native -pipe -funroll-loops -fomit-frame-pointer' -j32
```
