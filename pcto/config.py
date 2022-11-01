import os
from dotenv import load_dotenv

basedir = os.path.abspath(os.path.dirname(__file__))
load_dotenv(os.path.join(basedir, '.env'))


class Config(object):
    SECRET_KEY = 'you-will-never-guess'
    
    # my DATABASE
    # SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://postgres:password@192.168.0.202:5432/pcto'
    
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    MAIL_SERVER = 'smtp.libero.it'
    MAIL_PORT = int(25)
    MAIL_USE_TLS = False
    MAIL_USERNAME = 'pcto.rguernelli@libero.it'
    MAIL_PASSWORD = '!Pass1word$'
    ADMINS = ['pcto.rguernelli@libero.it']
    LANGUAGES = ['en', 'es', 'it']
    MS_TRANSLATOR_KEY = os.environ.get('MS_TRANSLATOR_KEY')
    POSTS_PER_PAGE = 25
