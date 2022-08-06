#!/bin/sh

pip install --upgrade pip

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

flask run