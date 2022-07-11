#!/bin/sh
# dump PCTO database in RAW format
pg_dump -U pcto -W -d pcto -h 192.168.0.202 -Fc  > pctoDatabase.tar
