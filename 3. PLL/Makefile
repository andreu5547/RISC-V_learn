all: main.bin

main.bin: main.elf
	riscv64-unknown-linux-gnu-objcopy -O binary main.elf main.bin

main.elf: main.s
	riscv64-unknown-linux-gnu-gcc -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib main.s -o main.elf

clean:
	rm -rf *.elf *.bin