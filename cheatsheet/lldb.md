# step in:
(lldb) step
(lldb) s

# step over:
(lldb) next
(lldb) n

# step out:
(lldb) finish
(lldb) f

# print
(lldb) p $rip

## print in hexadecimal
(lldb) p/x $rip
(unsigned long) 0x00007ffff7fc071b

## print in decimal
(lldb) p/d $rip
(unsigned long) 140737353877275

## print in binary
(lldb) p/t alpha
(u32) 0b00000000000000000000000010000010

https://sourceware.org/gdb/current/onlinedocs/gdb.html/Output-Formats.html

# print at every stop
(lldb) display <exp>
(lldb) display value
(lldb) target stop-hook add -o 'p value'

# memory

'x' is an abbreviation for 'memory read'

```
(lldb) x (u8*)string.value
```

Write contents of string.value to file

```
(lldb) memory read --force --binary --count 102400 -o /tmp/test (u8*)string.value
```

# breakpoint:
break
(lldb) b

break at line 32
(lldb) b 32 

break at main symbol
(lldb) b main

break with quickfix syntax
(lldb) b main.c:5
(lldb) b main.c:5:2

disable breakpoints
(lldb) b di

# temporary brakpoint:
thread until <line>

eg. step out of loop. loop ends at line 98
(lldb) thread until 98

# conditional breakpoint
break at current line when alpha variable bigger than 128
(lldb) b -a $rip -c 'alpha > 128'

# backtrace
(lldb) thread backtrace
(lldb) bt

go up on thread index
(lldb) up
go down on thread index
(lldb) down

go to specified thread index
(lldb) t <index>

# show source code
show where cpu executing in source code
(lldb) source list -a $rip -c 5
(lldb) f

# disasembly
show 5 instructions after rip
(lldb) dis -p -c 5
