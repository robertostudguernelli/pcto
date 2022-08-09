#!/bin/sh

# clona il repository PCTO
# cambia l'ip del web server per adattarlo alla macchina debian
# crea venv, lo popola e lo attiva
# 14 luglio 2022

cd ~
rm -fR pcto
git clone https://github.com/robertostudguernelli/pcto
pip install --upgrade pip
cp pcto/documentation/clona.sh .
cd pcto/newpcto
rpl 202 203 '*/.flaskenv'
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
