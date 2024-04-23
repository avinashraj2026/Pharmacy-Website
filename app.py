from flask import Flask, render_template, redirect, url_for, request, flash
from flask_login import LoginManager, login_user, current_user, logout_user, login_required
from passlib.hash import sha256_crypt
import pymysql

# Database Configuration
db_config = {
    'host': 'Avinash',
    'user': 'root',
    'password': 'avinash',
    'database': 'pharmacy_database'
}

# Flask App Setup
app = Flask(__name__)
app.config['SECRET_KEY'] = 'avinash14'

# Flask-Login Setup
login_manager = LoginManager(app)

# User Class
class User:
    def __init__(self, id, username, active=True):
        self.id = id
        self.username = username
        self.active = active

    def is_authenticated(self):
        return True

    def is_active(self):
        return self.active

    def is_anonymous(self):
        return False

    def get_id(self):
        return str(self.id)

# User Loader
@login_manager.user_loader
def load_user(user_id):
    db = pymysql.connect(**db_config)
    cursor = db.cursor()
    cursor.execute("SELECT user_id, username FROM Users WHERE user_id=%s", (user_id))
    result = cursor.fetchone()
    db.close()
    if result:
        return User(result[0], result[1])
    return None

# Routes
@app.route('/')
@login_required
def index():
    return render_template('login.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))

    if request.method == 'POST':
        username = request.form['username']
        password_candidate = request.form['password']

        # Database query: fetch the user and their hashed password
        db = pymysql.connect(**db_config)
        print("Connection successful")
        cursor = db.cursor()
        result = cursor.execute("SELECT * FROM Users WHERE username = %s", (username))

        if result > 0:
            data = cursor.fetchone()
            password = data['password']

            # Compare passwords (the entered one, and the hashed one from the database)
            if sha256_crypt.verify(password_candidate, password):
                user = User(data['user_id'], username)
                login_user(user)
                flash('Login successful', 'success')
                return redirect(url_for('index'))
            else:
                flash('Invalid credentials', 'danger')
                return render_template('login.html')
        else:
            flash('Invalid credentials', 'danger')
            return render_template('login.html')

    return render_template('login.html')  # If 'GET' request

@app.route('/register', methods=['GET', 'POST'])
def register():
    # Very similar to login, but insert into database instead
    if current_user.is_authenticated:
        return redirect(url_for('index'))

    if request.method == 'POST':
        # Get form fields
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        # Hash the password
        hashed_password = sha256_crypt.encrypt(password)

        # Database insertion: execute INSERT query
        db = pymysql.connect(**db_config)
        cursor = db.cursor()
        try:
           cursor.execute("INSERT INTO Users (username, email, password) VALUES (%s, %s, %s)", (username, email, hashed_password))
           db.commit()
           flash('Registration successful. You can now log in', 'success')
           return redirect(url_for('login'))
        except pymysql.err.IntegrityError:
           flash('Username or email already exists', 'danger')
           return render_template('register.html')

    return render_template('register.html')  # If 'GET' request

# ... (Other routes like 'index', 'logout' etc.) ...

if __name__ == '__main__':
    app.run(debug=True)
