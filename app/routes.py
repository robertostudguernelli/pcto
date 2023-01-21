from flask import render_template, flash, redirect, url_for
from app import app
from flask import render_template
from sqlalchemy import *

from app.forms import LoginForm

title='PCTO Roberto Guernelli, 804513?'

engine = create_engine(app.config['SQLALCHEMY_DATABASE_URI'], echo = True)
metadata = MetaData()
users   = Table('user'  , metadata, autoload=True, autoload_with=engine)
lessons = Table('lesson', metadata, autoload=True, autoload_with=engine)

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'da togliere'}
    return render_template('index.html', title=app.config['WEB_PAGE_TITLE'], user=user)

@app.route('/login', methods=['GET', 'POST'])
def login():
    form=LoginForm()
    if form.validate_on_submit():
        flash('Login richiesto per l\'utente {}, remember_me={}'.format(
            form.username.data, form.remember_me.data))
        userLogin(form)
        return redirect(url_for('logged'))
    return render_template('login.html', title='login' + app.config['WEB_PAGE_TITLE'], form=form)

def userLogin(form):
    cond=and_(users.c.username=='studente1@unive.it', users.c.password=='studente1')
    cond.compile().params
    conn=engine.connect()
    s=select([users]).where(cond)
    result=conn.execute(s)
    row=result.fetchone()
    user = {'username': row['email']}
    return render_template('index.html', title=app.config['WEB_PAGE_TITLE'], user=user)
