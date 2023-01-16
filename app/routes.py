from flask import render_template, flash, redirect, url_for
from app import app
from flask import render_template

from app.forms import LoginForm

title='PCTO Roberto Guernelli, 804513?'

@app.route('/')
@app.route('/index')

def index():
    user = {'username': 'prova prova prova prova prova'}
    return render_template('index.html', title=app.config['WEB_PAGE_TITLE'], user=user)

@app.route('/login', methods=['GET', 'POST'])
def login():
    form=LoginForm()
    if form.validate_on_submit():
        flash('Login richiesto per l\'utente {}, remember_me={}'.format(
            form.username.data, form.remember_me.data))
        return redirect(url_for('index'))
    return render_template('login.html', title='login' + app.config['WEB_PAGE_TITLE'], form=form)