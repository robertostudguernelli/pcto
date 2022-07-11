import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    SECRET_KEY = 'you-will-never-guess'
    
    SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_DATABASE_URI = 'DATABASE_URL = postgresql://pcto:password@192.168.0.202:5432/pcto'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    DBMS_USERNAME = 'postgres'
    DBMS_PASSWORD = 'password'
    DBMS_HOST     = '192.168.0.202'
    DBMS_DB       = 'pcto'
