from curses import meta
import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, MetaData, ForeignKey

engine= create_engine('sqlite:///database.db', echo=True)
metadata = MetaData()

user = Table('Users', metadata,
            Column('id', Integer, primary_key=True),
            Column('email', String),
            Column('pwd', String)
            )

metadata.create_all(engine)

conn = engine.connect()

x = conn.execute("DELETE FROM Users")

ins = "INSERT INTO Users VALUES (?, ?, ?)"
conn.execute(ins, '1', 'alice@gmail.com', 'love')
conn.execute(ins, '2', 'bob@gmail.com', 'milk')

user_list = conn.execute("SELECT * FROM Users")
for u in user_list:
    print(u)