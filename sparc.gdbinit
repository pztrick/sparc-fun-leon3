set mem inaccessible-by-default off
set auto-solib-add on

set remote interrupt-on-connect off
set confirm off
set history expansion
set history save on
set history filename ~/.gdb-history-sparc
set history size 1000
set pagination off

target extended-remote localhost:1234

file main.elf

info file
info mem

set print pretty on
