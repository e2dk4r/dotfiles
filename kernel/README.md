# Compile
Compile kernel with

```
make LLVM=1 -j32
```

# Why a feature disabled?

| Config              | Description                     |
|---------------------|---------------------------------|
| `CONFIG_PREEMPT_RT` | Causes random OOM kills         |
