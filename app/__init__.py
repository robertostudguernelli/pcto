from flask import Flask
from flask_sqlalchemy import *
from flask_migrate import Migrate
from flask_login import LoginManager
from config import Config

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)
metadata = MetaData()
login = LoginManager(app)
login.login_view = 'login'

from app import routes, models
