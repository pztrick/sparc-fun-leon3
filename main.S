! main.S - super simple code to step thru

.global _start

_start:
    mov 4, %g1
    mov 4, %g2
    add %g1, %g2, %g3
    nop
