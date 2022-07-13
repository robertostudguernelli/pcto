from asyncio.log import logger
from flask import Flask
from flask_sqlalchemy import *
from flask_login import LoginManager
from config import Config

import logging
logging.basicConfig(filename='record.log', level=logging.DEBUG, format=f'%(asctime)s %(levelname)s : %(message)s')

app = Flask(__name__)
app.config.from_object(Config)
engine = create_engine('postgresql://postgres:password@192.168.0.202:5432/pcto', echo = True)

login = LoginManager(app)
login.login_view = 'login'

from app import routes, models
