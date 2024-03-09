#!/usr/bin/expect -f
set timeout 5

        spawn /usr/bin/weka user add jomoon s3

        expect  "^Password for*"
        send    "Changeme12!@\r"

        interact

exit
