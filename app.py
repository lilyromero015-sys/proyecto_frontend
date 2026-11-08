import os
import re

from dotenv import load_dotenv
from flask import Flask, jsonify, render_template, request
from flask_sqlalchemy import SQLAlchemy

load_dotenv()

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)


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




class PlagaEnfermedad(db.Model):
    __tablename__ = "plagas_enfermedades"

    id_plaga = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    nombre_cientifico = db.Column(db.String(150))
    tipo = db.Column(db.String(20), nullable=False)
    descripcion = db.Column(db.Text, nullable=False)
    imagen_url = db.Column(db.String(255))

    def to_dict(self):
        return {
            "nombre": self.nombre,
            "nombre_cientifico": self.nombre_cientifico,
            "tipo": self.tipo,
            "descripcion": self.descripcion,
            "imagen_url": self.imagen_url,
        }


# Solo letras (con tildes y ñ) y espacios
PATRON_BUSQUEDA = re.compile(r"^[A-Za-zÁÉÍÓÚáéíóúÑñÜü ]+$")


@app.route("/api/salud")
def salud():
    db.session.execute(db.text("SELECT 1"))
    return jsonify({"mensaje": "Conexión con la base de datos correcta"})


@app.route("/api/plagas/buscar")
def buscar_plaga():
    texto = request.args.get("q", "").strip()

    # RF-01: validar el campo de búsqueda
    if not texto:
        return jsonify({"error": "Escribe el nombre de una plaga o enfermedad."}), 400
    if len(texto) > 100:
        return jsonify({"error": "El texto es muy largo. Usa máximo 100 letras."}), 400
    if not PATRON_BUSQUEDA.match(texto):
        return jsonify({"error": "Escribe solo letras, sin números ni símbolos."}), 400

    resultados = PlagaEnfermedad.query.filter(
        PlagaEnfermedad.nombre.ilike(f"%{texto}%")
    ).all()

    # RF-03: sin resultados
    if not resultados:
        return jsonify({"mensaje": "No encontramos resultados para tu búsqueda."}), 404

    # RF-02: tarjetas con los datos
    return jsonify({"resultados": [r.to_dict() for r in resultados]})



if __name__ == '__main__':
    app.run(debug=True)