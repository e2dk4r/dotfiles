# Compile
Compile kernel with

```
make LLVM=1 -j32
```

# Feature table

| Config                    | Description                                                       |
|---------------------------|-------------------------------------------------------------------|
| `CONFIG_V4L2_LOOPBACK`    | Used with scrcpy for using Android device like webcam. see [1]    |
| `CONFIG_PREEMPT_RT`       | Disabled because of random OOM kills                              |

[1]: https://github.com/Genymobile/scrcpy/blob/master/doc/v4l2.md
