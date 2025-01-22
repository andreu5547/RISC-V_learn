.equ PORTA_BASE,  0x40010800
.equ PORTA_CRL,  (PORTA_BASE + 0x00) 
.equ PORTA_CRH,  (PORTA_BASE + 0x04) 
.equ PORTA_OUTDR,  (PORTA_BASE + 0x0C)
.equ PORT8, 8
.equ GPIOOUT, 0b1001
.equ RCC_BASE, 0x40021000
.equ RCC_PB2_CLK, (RCC_BASE + 0x18) #был не тот адрес
.equ RCC_CONF_CLK, (RCC_BASE + 0x04) # Регистр конфигурации тактирования
.equ RCC_PB2_GPIOA, (0b1<<2)
.equ MCO_CONF, 0b0100

.global _start
.text
_start:
    # Включение тактирования на шину PB2
    li t0, RCC_PB2_CLK
    lw t1, 0(t0)
    ori t1, t1, RCC_PB2_GPIOA
    sw t1, 0(t0)

    # GPIO конфиг CNF и мод MODE
    li t0, PORTA_CRH
    lw t1, 0(t0)
    li t2, ~(0b1111 << (4*(PORT8 - 8)))
    and t1, t1, t2
    li t2, GPIOOUT << (4*(PORT8 - 8))
    or t1, t1, t2
    sw t1, 0(t0)

    # Конфигурация MCO 8 MHz 
    li t0, RCC_CONF_CLK
    lw t1, 0(t0)
    li t2, ~(0b1111 << (24))
    and t1, t1, t2
    li t2, MCO_CONF << (24)
    or t1, t1, t2
    sw t1, 0(t0)
    
    
    #ok
    #li t0, PORTA_OUTDR
    #lw t1, 0(t0)
    #ori t1, t1, 0b1 << PORT8
    #sw t1, 0(t0)
    
MAIN_LOOP:
    #li t0, PORTA_OUTDR
    #lw t1, 0(t0)
    #xori t1, t1, 1<<(PORT8)
    #sw t1, 0(t0)

    #li t2, 10000000
    #loop:
    #addi t2, t2, -1
    #bnez t2, loop

    j MAIN_LOOP
.end
