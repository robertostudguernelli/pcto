from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import *


# creazione dell'app
app = Flask(__name__)

# importazione dei parametri di configurazione
app.config.from_object(Config)

from app import routes

