## sparc-fun-leon3

Basic qemu + gdb demonstration of viewing `leon3_generic` `sparc32` registers.

### Toolchain

Download the pre-built Zephyr `sparc32` toolchain and, when asked, install to path `/opt/zephyr-sdk`.

```
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.12.4/zephyr-toolchain-sparc-0.12.4-x86_64-linux-setup.run

chmod +x ./zephyr-toolchain-sparc-0.12.4-x86_64-linux-setup.run

./zephyr-toolchain-sparc-0.12.4-x86_64-linux-setup.run
```

Add `sparc-zephyr-elf` to your `$PATH`.

```
# .envrc
path_add PATH /opt/zephyr-sdk/sparc-zephyr-elf/bin

# or manually
export PATH=/opt/zephyr-sdk/sparc-zephyr-elf/bin:$PATH
```

### Compile `main.S`

This is a super simple assembly file provided as a jumping-off point.

```
# compile
sparc-zephyr-elf-as -g -o main.o main.S

# link
sparc-zephyr-elf-ld -g -T sparc.ld -o main.elf main.o
```

The sample code just puts the values `4` and `4` into registers `g1` and `g2` and sums them in register `g3`.

```
! main.S - super simple code to step thru

.global _start

_start:
    mov 4, %g1
    mov 4, %g2
    add %g1, %g2, %g3
    nop
```

The linker script `sparc.ld` simply identifies the symbol `_start` as the entry point for the executable.

```
ENTRY(_start)
```

### Start QEMU

```
qemu-system-sparc --machine leon3_generic --nographic -kernel main.elf -s -S
```

The `-s -S` flags will halt the CPU before running. Step through execution in gdb next.

You need to input `<Ctrl> + A` then `X` to terminate QEMU.

### Start `gdb`

```
sparc-zephyr-elf-gdb -x sparc.gdbinit
```

Sample output from gdb:

```
Local exec file:
    `/opt/sparc/sparc-fun-leon3/main.elf', file type elf32-sparc.
    Entry point: 0x0
    0x00000000 - 0x00000018 is .text
Using memory regions provided by the target.
There are no memory regions defined.
(gdb) frame
#0  _start () at main.S:6
6       mov 4, %g1
(gdb) info reg g1
g1             0x0                 0
(gdb) info reg g2
g2             0x0                 0
(gdb) info reg g3
g3             0x0                 0
(gdb) step
7       mov 4, %g2
(gdb) step
8       add %g1, %g2, %g3
(gdb) step
9       nop
(gdb) info reg g1
g1             0x4                 4
(gdb) info reg g2
g2             0x4                 4
(gdb) info reg g3
g3             0x8                 8
(gdb) info registers
g0             0x0                 0
g1             0x4                 4
g2             0x4                 4
g3             0x8                 8
g4             0x0                 0
g5             0x0                 0
g6             0x0                 0
g7             0x0                 0
o0             0x0                 0
o1             0x0                 0
o2             0x0                 0
o3             0x0                 0
o4             0x0                 0
o5             0x0                 0
sp             0x48000000          0x48000000
o7             0x0                 0
l0             0x0                 0
l1             0x0                 0
l2             0x0                 0
l3             0x0                 0
l4             0x0                 0
l5             0x0                 0
l6             0x0                 0
l7             0x0                 0
i0             0x0                 0
i1             0x0                 0
i2             0x0                 0
i3             0x0                 0
i4             0x0                 0
i5             0x0                 0
fp             0x0                 0x0 <_start>
i7             0x0                 0
y              0x0                 0
psr            0xf30000c0          [ PS S ]
wim            0x1                 1
tbr            0x0                 0
pc             0xc                 0xc <_start+12>
npc            0x10                0x10 <_start+16>
fsr            0x0                 [ ]
csr            0x0                 0
```