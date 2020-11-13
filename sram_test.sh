#!/bin/bash

# Tests sram for errors.
# At bank1 address there is random data written and loaded to SRAM
# Binary compares bank1 to SRAM data, if there is any error red led will turn ON


sources='config_bins'
results='result'
exit_status=1

if [ ! -d ${results} ]
then
    mkdir ${results}
fi

function nice_echo {
    echo
    echo
    echo --------------------------------
    echo $*
    echo --------------------------------
    echo
}

nice_echo ERASING EEPROM MEMORY
avrdude -p m128 -c usbasp -V -U flash:w:${sources}/eeprom_wiper.hex
status=$?
sleep 2 

if [ $status = 0 ]
then
    nice_echo UPLOAD SRAM TEST
    avrdude -p m128 -c usbasp -V -U flash:w:${sources}/sram_test.bin:r
fi
status=$?

if [ $status = 0 ]
then
    tim=5
    sleep $tim
    #nice_echo WAIT ${tim}s
    nice_echo CHECK RESULT
    #avrdude -p m128 -c usbasp -V -U eeprom:r:${results}/eeprom.bin:r
    #nice_echo RESULT OUTPUT
    #nice_echo eeprom.bin:
    #cat ${results}/eeprom.bin
    #nice_echo grep for ADDR
    #grep -a 'ADDR:' ${results}/eeprom.bin
    #exit_status=$?
    #echo exit status $exit_status
fi

avrdude -p m128 -c usbasp

exit $exit_status

