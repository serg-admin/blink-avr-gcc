# makefile, written by guido socher
#MCU=at90s4433
MCU=atmega32u4
CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-g -mmcu=$(MCU) -Wall -Wstrict-prototypes -I /usr/lib/avr/include/
#-------------------
all: avrledtest.hex
#-------------------
avrledtest.hex : avrledtest.out
	$(OBJCOPY) -R .eeprom -O ihex avrledtest.out avrledtest.hex
avrledtest.out : avrledtest.o
	$(CC) $(CFLAGS) -o avrledtest.out -Wl,-Map,avrledtest.map avrledtest.o
avrledtest.o : avrledtest.c
	$(CC) $(CFLAGS) -Os -c avrledtest.c
# you need to erase first before loading the program.
# load (program) the software into the eeprom:
load: avrledtest.hex
	uisp -dlpt=/dev/parport0 --erase  -dprog=dapa
	uisp -dlpt=/dev/parport0 --upload if=avrledtest.hex -dprog=dapa  -v=3 --hash=32
# here is a pre-compiled version in case you have trouble with
# your development environment
load_pre: avrledtest_pre.hex
	uisp -dlpt=/dev/parport0 --erase  -dprog=dapa
	uisp -dlpt=/dev/parport0 --upload if=avrledtest_pre.hex -dprog=dapa -dno-poll -v=3 --hash=32
#-------------------
clean:
	rm -f *.o *.map *.out *.dmp *.hex
#-------------------
get_asm:
	avr-objdump -j .sec1 -d -m avr5 avrledtest.hex > avrledtest.asm.dmp
#-------------------