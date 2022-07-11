#!/bin/sh
# dump PCTO database in ASCII SQL format
pg_dump -U pcto -W -d pcto -h 192.168.0.202 -Fp  > pctoDatabase.sql
