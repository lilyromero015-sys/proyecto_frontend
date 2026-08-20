from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/plagas')
def plagas():
    return render_template('plagas.html')

@app.route('/foro')
def foro():
    return render_template('foro.html')

@app.route('/tratamientos')
def tratamientos():
    return render_template('tratamientos.html')



















if __name__ == '__main__':
    app.run(debug=True)