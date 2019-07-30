#!/bin/bash

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
avrdude -p m128 -c usbasp -V -U eeprom:w:${sources}/eeprom_empty_image.bin:r
status=$?

if [ $status = 0 ]
then
    nice_echo UPLOAD BOOTLOADER AND CONFIG TOOL
    avrdude -p m128 -c usbasp -V -U flash:w:${sources}/emubt_bootloader_and_configurator.bin:r
fi
status=$?

if [ $status = 0 ]
then
    tim=5
    nice_echo RESET
    sleep 1
    avrdude -p m128 -c usbasp
    nice_echo WAIT ${tim}s
    sleep $tim
    nice_echo CHECK RESULT
    avrdude -p m128 -c usbasp -V -U eeprom:r:${results}/eeprom.bin:r
    nice_echo RESULT OUTPUT
    nice_echo eeprom.bin:
    cat ${results}/eeprom.bin
    nice_echo grep for ADDR
    grep -a 'ADDR:' ${results}/eeprom.bin
    exit_status=$?
    echo exit status $exit_status
fi

exit $exit_status

