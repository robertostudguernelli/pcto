from flask import Flask
from flask import render_template
from flask import request, redirect, url_for, make_response

# from sqlalchemy import create_engine
from sqlalchemy import *


from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user

import logging

app = Flask( __name__ )

app.config['SECRET_KEY'] = 'secretKey'
app.config['DBMS'] = 'postgresql+psycopg2://postgres:password@192.168.0.202:5432/pcto'

logging.basicConfig(level=logging.INFO, filename='pcto.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s')
logging.info('- - - start LOGGING')
logging.getLogger('sqlalchemy.engine').setLevel(logging.ERROR)

engine = create_engine(app.config['DBMS'], echo = False)
metadata = MetaData()
Person = Table('person', metadata, autoload=True, autoload_with=engine)
def get_id(self):
    return self.email
Person.get_id = get_id
Person.is_authenticated = True
Person.is_active = True
Person.is_anonymous = True

login_manager = LoginManager()
login_manager.init_app(app)

def get_user_by_email(email):
    conn = engine.connect()
    rs = conn.execute('SELECT * FROM Person WHERE email = ?', email)
    person = rs.fetchone()
    conn.close()
    return Person(person.id , person.email , person.password)

@login_manager.user_loader
def load_user(id):
    conn = engine.connect()
    rs = conn.execute('SELECT * FROM Person WHERE id = ?', id )
    person = rs.fetchone()
    conn.close()
    return Person(person.id , person.email , person.password)

@app.route('/')
def home():
    if current_user.is_authenticated:
        return redirect(url_for('private'))
    else:
        return render_template('base.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        conn = engine.connect()
        proj = [Person.c.email, Person.c.password]
        cond = and_(Person.c.email==request.form['email'], Person.c.password==request.form['password'])
        cond.compile().params
        query = select(proj).where(cond)
        result = conn.execute(query)
        conn.close()
        if (result.rowcount==1):
            logging.info('loggato')
            person = result.fetchone()
            logging.info(person)
            login_user(person)
            return redirect(url_for('private'))
        else:
            logging.info('NON loggato')
            return redirect(url_for('home'))

@app.route('/private')
@login_required
def private():
    conn = engine.connect()
    persons = conn.execute('SELECT * FROM person')
    resp = make_response(render_template("private.html", persons=persons))
    conn.close()
    return resp

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))
