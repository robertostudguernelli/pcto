from flask import *
app = Flask('__name__') # crea un oggetto di nome app di tipo Flask (è il costruttore)

@app.route('/')
def hello_world():
    return 'Hello, World!'

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

@app.route('/user/<username>')
def show_username_information(username):
    return 'Hello, ' + username

@app.route('/userbyindex/<username>')
def userbyindex(username):
    return render_template('index.html', user=username)

@app.route('/form')
def form():
    return render_template('form.html')