#!/bin/sh

pip install --upgrade pip

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
#pip freeze > requirements.txt

flask run

flask db init
flask db migrate -m "users table"
flask db upgrade
flask db migrate -m "posts table"
flask db upgrade
