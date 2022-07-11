#!/bin/sh
# resore PCTO database from RAW format
pg_dump -U pcto -W -d pcto -h 192.168.0.203  -c  < pctoDatabase.tar
