from app import app, db
from app.models import User, Post


@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'metadata': metadata, 'User': User, 'Post': Post, 'Person': Person}
