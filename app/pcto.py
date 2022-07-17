from flask import Flask
from flask import render_template
from flask import request, redirect, url_for, make_response

# from sqlalchemy import create_engine
from sqlalchemy import *


from flask_login import LoginManager, UserMixin, login_user, login_required, current_user, logout_user

app = Flask( __name__ )
#engine= create_engine('sqlite:///database.db', echo=True)
engine = create_engine('postgresql://postgres:password@192.168.0.202:5432/pcto', echo = True)
metadata = MetaData()
Person = Table('person', metadata, autoload=True, autoload_with=engine)
app. config ['SECRET_KEY'] = 'secretKey'

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
    return Person(person.id , person.email , person.pwd)

@app.route('/')
def home():
    if current_user.is_authenticated:
        return redirect(url_for('private'))
    return render_template("base.html")

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        conn = engine.connect()
#        rs = conn.execute('SELECT * FROM Person WhERE email = ?', [request.form['username']])
        rs = conn.execute("SELECT * FROM Person WhERE email = 'rguernelli@libero.it'")
        real_pwd = rs.fetchone()
        conn.close()

        if (real_pwd is not None):
            if (request.form['password'] == real_pwd['password']):
                person = get_user_by_email(request.form['password'])
                login_user(person)
                return redirect(url_for('private'))
            else:
                return redirect(url_for('home'))
        else:
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
