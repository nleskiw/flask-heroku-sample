import os
from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

DATABASE_URL = os.environ.get('DATABASE_URL', 'sqlite:////tmp/flask_app.db')
app.config['SQLALCHEMY_DATABASE_URI'] = DATABASE_URL
db = SQLAlchemy(app)

# models
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    email = db.Column(db.String(100))

    def __init__(self, name, email):
        self.name = name
        self.email = email


# routes
@app.route('/', methods=['GET'])
def index():
    return render_template('index.html', users=User.query.all())

@app.route('/health', methods=['GET'])
def health():
    return "ok", 200

@app.route('/user', methods=['POST'])
def user():
    u = User(request.form['name'], request.form['email'])
    db.session.add(u)
    db.session.commit()
    return redirect(url_for('index'))


# helpers
def init_db():
    """create database tables"""
    with app.app_context():
        db.create_all()
        print("Database initialized ", DATABASE_URL)


# entrypoint
if __name__ == '__main__':
    init_db()
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)

