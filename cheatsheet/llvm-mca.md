# Gotchas

1. Do not have assertions in code that you want to analyze. Because compiler cannot see the end marker.

# Marking

Example usage for c/c++:
```
__asm volatile("# LLVM-MCA-BEGIN foo");
... analyzed code
__asm volatile("# LLVM-MCA-END");
```

# Turn to assembly

```
clang -O3 -march=znver3 -S -o build/critical.s src/critical.c
```

# Analyze

```
llvm-mca -mcpu=znver3 build/critical.s
```

Or you can combine turning into assembly and analyzing

```
clang -O3 -march=znver3 -S -o - src/critical.c | llvm-mca -mcpu=znver3 
```

# References

- [2018 LLVM Developers’ Meeting: A. Biagio & M. Davis “Understanding the performance of code using...”](https://www.youtube.com/embed/Ku2D8bjEGXk)
