from flask import Flask, render_template, redirect, url_for, request, flash
from flask_login import LoginManager, login_user, current_user, logout_user, login_required, UserMixin
from passlib.hash import sha256_crypt
import pymysql

# Database Configuration
db_config = {
    'host': '127.0.0.2',
    'user': 'root',  # Use your MySQL username
    'password': 'avinash',  # Use your MySQL password
    'database': 'pharmacy_application'
}

# Flask App Setup
app = Flask(__name__)
app.config['SECRET_KEY'] = 'avinash14'

# Flask-Login Setup
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# User Class
class User(UserMixin):
    def __init__(self, id, username):
        self.id = id
        self.username = username

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        return str(self.id)

    @staticmethod
    def validate_login(password_hash, password):
        return sha256_crypt.verify(password, password_hash)

# User Loader
@login_manager.user_loader
def load_user(user_id):
    db = pymysql.connect(**db_config)
    cursor = db.cursor()
    cursor.execute("SELECT user_id, username FROM Users WHERE user_id=%s", (user_id,))
    result = cursor.fetchone()
    db.close()
    if result:
        return User(result[0], result[1])
    return None

@app.route('/')
@login_required
def home():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('home'))

    if request.method == 'POST':
        username = request.form['username']
        password_candidate = request.form['password']

        db = pymysql.connect(**db_config)
        cursor = db.cursor()
        result = cursor.execute("SELECT user_id, username, password FROM Users WHERE username = %s", (username,))
        if result > 0:
            data = cursor.fetchone()
            password_hash = data[2]  # Assuming password is stored at index 2

            if User.validate_login(password_hash, password_candidate):
                user_id = data[0]  # Assuming user_id is at index 0
                user = User(user_id, username)
                login_user(user)
                flash('Login successful', 'success')
                return redirect(url_for('home'))
            else:
                flash('Invalid credentials', 'danger')
        else:
            flash('Invalid credentials', 'danger')

        db.close()

    return render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('home'))

    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        hashed_password = sha256_crypt.encrypt(password)

        db = pymysql.connect(**db_config)
        cursor = db.cursor()
        try:
            cursor.execute("INSERT INTO Users (username, email, password) VALUES (%s, %s, %s)", (username, email, hashed_password))
            db.commit()
            flash('Registration successful. You can now log in', 'success')
            return redirect(url_for('login'))
        except pymysql.err.IntegrityError:
            flash('Username or email already exists', 'danger')
            db.rollback()

        db.close()

    return render_template('register.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
