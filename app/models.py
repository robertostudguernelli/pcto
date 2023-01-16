from app import db
from sqlalchemy import *

# connessione al database
class DB():
    engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'], echo = True)
    metadata = MetaData()
    users   = Table('user'  , metadata, autoload=True, autoload_with=engine)
    lessons = Table('lesson', metadata, autoload=True, autoload_with=engine)
