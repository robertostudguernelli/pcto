from app import app
from flask import render_template

title='PCTO Roberto Guernelli, 804513?'

@app.route('/')
@app.route('/index')

def index():
    user = {'username': app.config['SECRET_KEY']}
    return render_template('index.html', title=title, user=user)

@app.route('/login')
def login():
    return render_template('login.html')