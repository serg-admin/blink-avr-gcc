# makefile, written by guido socher
#MCU=at90s4433
MCU=atmega32u4
CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-g -mmcu=$(MCU) -Wall -Wstrict-prototypes -I /usr/lib/avr/include/
#-------------------
all: blink.hex
#-------------------
blink.hex : blink.out
	$(OBJCOPY) -R .eeprom -O ihex blink.out blink.hex
blink.out : blink.o
	$(CC) $(CFLAGS) -o blink.out -Wl,-Map,blink.map blink.o
blink.o : blink.c
	$(CC) $(CFLAGS) -Os -c blink.c
# you need to erase first before loading the program.
# load (program) the software into the eeprom:
load: blink.hex
	uisp -dlpt=/dev/parport0 --erase  -dprog=dapa
	uisp -dlpt=/dev/parport0 --upload if=blink.hex -dprog=dapa  -v=3 --hash=32
# here is a pre-compiled version in case you have trouble with
# your development environment
load_pre: blink_pre.hex
	uisp -dlpt=/dev/parport0 --erase  -dprog=dapa
	uisp -dlpt=/dev/parport0 --upload if=blink_pre.hex -dprog=dapa -dno-poll -v=3 --hash=32
#-------------------
clean:
	rm -f *.o *.map *.out *.lst *.hex
#-------------------
get_asm:
	$(CC) $(CFLAGS) -Os -c blink.c
	$(CC) $(CFLAGS) -o blink.elf blink.o
	avr-objdump -h -S blink.elf  > blink.lst
#-------------------