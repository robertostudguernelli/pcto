from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
from flask import url_for

app = Flask('__name__')

@app.route('/')
def hello_world():
    return render_template('index.html')

@app.route('/users/<username>')
def show_profile(username):
    users = ['alice', 'bob', 'charlie']
    if username in users:
        return render_template('profile.html', user=username)
    else:
        return render_template('profile.html', rigistered_users=users)

@app.route('/login', methods=['GET', 'POST'])
def login():
    user = request.form["user"]
    return redirect(url_for('show_profile', username=user))

# prove libere

@app.route('/pippo')
def hello_pippo():
    return 'Hello, Pippo!'

@app.route('/appname')
def appname():
    return '__name__ -> ' + format(__name__)

@app.route('/divbyzero')
def divbyzero():
    num = 8
    den = 0
    return num/den

@app.route('/userbyindex/<username>')
def userbyindex(username):
    return render_template('index.html', user=username)

# XSS vulnerability
@app.route('/unsafe')
def unsafe():
    u = request.args.get('user')
    return "Welcome " + u

@app.route('/safe')
def safe():
    u = request.args.get('user')
    return render_template('safe.html', user = u)

    