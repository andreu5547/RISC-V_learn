.equ PORTA_BASE,  0x40010800 # Базовый адрес GPIO_A
.equ PORTA_CRL,  (PORTA_BASE + 0x00) # Адрес регистра конфигурации 0-7 пинов GPIO_A
.equ PORTA_CRH,  (PORTA_BASE + 0x04) # Адрес регистра конфигурации 8-15 пинов GPIO_A
.equ PORTA_OUTDR,  (PORTA_BASE + 0x0C) # Адрес регистра конфигурации состояния выхода пинов GPIO_A
.equ PORT8, 8 # Номер порта PA8 с альтернативной функцией вывода MCO
.equ GPIOOUT, 0b1011 # Конфиг порта, 10 - альтернативная функция push-pull, 01 - скорость 10 МГц, 11 - 50 VHz
.equ RCC_BASE, 0x40021000 # Базовый адрес регистров тактирования
.equ RCC_CTRL_CLK, (RCC_BASE + 0x00) # Адрес регистра контроля тактирования
.equ RCC_PB2_CLK, (RCC_BASE + 0x18) # Адрес регистра включения тактирования модулей, входящих в состав PB2
.equ RCC_CONF_CLK, (RCC_BASE + 0x04) # Адрес регистра конфигурации тактирования
.equ RCC_PB2_GPIOA, (0b1<<2) # Бит включения GPIOA на шине PB2
.equ RCC_HSE, (0b1<<16) # Бит включения HSE
.equ PLL_SRC, (0b1<<16) # Бит конфигурации мультиплексора PLL_SRC, который выбирает источник тактирования HSE (HSE or HSI)
.equ PLL_XTPRE, (0b1<<17) # Бит конфигурации мультиплексора PLL_XTPRE, который выбирает деление или неделение на 2 сигнала от HSE
.equ PLL_MUL, (0b0110<<18) # Бит конфигурации умножителя
.equ MCO_CONF, 0b0111 # Биты конфигурации MCO 0100 - SYSCLK
.equ SW_CONF, 0b10 # Биты конфигурации мультиплексора SW 10 - PLL вход на SYSCLK
.equ PLL_CONF, (0b1 << 24) # Биты конфигурации PLL, это 24й бит, 1 - включен, 0 - выключен


.global _start
.text
_start:

    # Выбор конфигурации мультиплексора PLL_XTPRE
    li t0, RCC_CONF_CLK
    lw t1, 0(t0)
    li t3, PLL_XTPRE
    or t1, t1, t3
    sw t1, 0(t0)
    
    # Выбор конфигурации мультиплексора PLL_SRC
    li t0, RCC_CONF_CLK
    lw t1, 0(t0)
    li t3, PLL_SRC
    or t1, t1, t3
    sw t1, 0(t0)

    
    # Выбор конфигурации мультиплексора PLL_MUL
    li t0, RCC_CONF_CLK
    lw t1, 0(t0)
    li t3, PLL_MUL
    or t1, t1, t3
    sw t1, 0(t0)


    # Настройка мультиплексора SW
    li t0, RCC_CONF_CLK
    lw t1, 0(t0)
    ori t1, t1, SW_CONF
    sw t1, 0(t0)

    # Включение тактирования HSE
    li t0, RCC_CTRL_CLK
    lw t1, 0(t0)
    li t3, RCC_HSE
    or t1, t1, t3
    sw t1, 0(t0)

    # Включение PLL
    li t0, RCC_CTRL_CLK
    lw t1, 0(t0)
    li t3, PLL_CONF
    or t1, t1, t3
    sw t1, 0(t0)

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
