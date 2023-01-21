import os

basedir = os.path.abspath(os.path.dirname(__file__))

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'chiave segreta'
    WEB_PAGE_TITLE = 'UNIVE - CT009 - PCTO - Roberto Guernelli, 804513'
    # SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg2://postgres:password@192.168.1.202:5432/pcto'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
