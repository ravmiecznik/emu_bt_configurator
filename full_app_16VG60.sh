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


full_app_eeprom_image=${sources}/full_app_16VG60_eeprom.bin
nice_echo WRITING EEPROM with ${full_app_eeprom_image}
avrdude -p m128 -c usbasp -V -U eeprom:w:${full_app_eeprom_image}

sleep 2 

full_app_16VG60=${sources}/full_app_16VG60.bin

nice_echo UPLOAD
avrdude -p m128 -c usbasp -V -U flash:w:${full_app_16VG60}:r
status=$?

exit $exit_status

