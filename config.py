import os
basedir = os.path.abspath(os.path.dirname(__file__))


class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'you-will-never-guess'
    
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'sqlite:///' + os.path.join(basedir, 'app.db')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
        DBMS_USERNAME = os.environ.get('DBMS_USERNAME') or 'postgres'
    DBMS_PASSWORD = os.environ.get('DBMS_PASSWORD') or 'password'
    DBMS_HOST     = os.environ.get('DBMS_HOST')     or '192.168.0.202'
    DBMS_DB       = os.environ.get('DBMS_DB')       or 'pcto'
