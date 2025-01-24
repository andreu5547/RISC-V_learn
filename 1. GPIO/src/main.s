.equ PORTB_BASE,  0x40010C00
.equ PORTB_CRL,  (PORTB_BASE + 0x00) 
.equ PORTB_OUTDR,  (PORTB_BASE + 0x0C)
.equ LED, 2
.equ GPIOOUT, 0b0011
.equ RCC_BASE, 0x40021000
.equ RCC_PB2_CLK, (RCC_BASE + 0x18) #был не тот адрес
.equ RCC_PB2, (0b1<<3)

.global _start
.text
_start:
    #ok
    li t0, RCC_PB2_CLK
    lw t1, 0(t0)
    ori t1, t1, RCC_PB2
    sw t1, 0(t0)

    #ok
    li t0, PORTB_CRL
    lw t1, 0(t0)
    li t2, ~(0b1111 << (4*LED))
    and t1, t1, t2
    li t2, 0b0001 << (4*LED)
    or t1, t1, t2
    sw t1, 0(t0)

    
    
    #ok
    li t0, PORTB_OUTDR
    lw t1, 0(t0)
    ori t1, t1, 0b1 << LED
    sw t1, 0(t0)
    
MAIN_LOOP:
    li t0, PORTB_OUTDR
    lw t1, 0(t0)
    xori t1, t1, 1<<LED
    sw t1, 0(t0)

    li t2, 100000
    loop:
    addi t2, t2, -1
    bnez t2, loop

    j MAIN_LOOP
.end
