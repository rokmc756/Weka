#!/usr/bin/expect -f
set timeout 3

        spawn /usr/bin/weka user passwd 

        expect  "^Current password for admin:*"
        send    "admin\r"

        expect  "^New password for admin:*"
        send    "Changeme12!@\r"

        expect  "^Password confirmation:*"
        send    "Changeme12!@\r"

        interact

exit

