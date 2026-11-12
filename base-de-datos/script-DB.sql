CREATE DATABASE smartcafe;


CREATE TABLE usuarios (
 id_usuario         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 nombre             VARCHAR(100) NOT NULL,
 correo             VARCHAR(150) NOT NULL UNIQUE,
 contrasena_hash    VARCHAR(255) NOT NULL,
 fecha_registro     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE plagas_enfermedades (
 id_plaga          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 nombre            VARCHAR(100) NOT NULL UNIQUE,
 nombre_cientifico VARCHAR(150),
 tipo              VARCHAR(20) NOT NULL
 CHECK (tipo IN ('plaga', 'enfermedad')),
 descripcion       TEXT NOT NULL,
 imagen_url        VARCHAR(255)
);

CREATE TABLE recomendaciones (
 id_recomendacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 id_plaga         INT,
 tipo             VARCHAR(20) NOT NULL
 CHECK (tipo IN ('prevencion', 'tratamiento')),
 titulo           VARCHAR(150) NOT NULL,
 descripcion      TEXT NOT NULL,
 imagen_url       VARCHAR(255),
 CONSTRAINT fk_recomendacion_plaga
 FOREIGN KEY (id_plaga) REFERENCES plagas_enfermedades (id_plaga)
 ON DELETE SET NULL
);

CREATE TABLE busquedas (
 id_busqueda INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 id_usuario  INT NOT NULL,
 id_plaga    INT,
 termino     VARCHAR(100) NOT NULL,
 fecha       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_busqueda_usuario
 FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
 ON DELETE CASCADE,
 CONSTRAINT fk_busqueda_plaga  FOREIGN KEY (id_plaga) REFERENCES plagas_enfermedades (id_plaga)
        ON DELETE SET NULL
);

CREATE TABLE diagnosticos (
    id_diagnostico    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario        INT NOT NULL,
    id_plaga          INT,
    imagen_subida_url VARCHAR(255) NOT NULL,
    imagen_sana_url   VARCHAR(255),
    resultado         TEXT,
    fecha             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_diagnostico_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
        ON DELETE CASCADE,
    CONSTRAINT fk_diagnostico_plaga
        FOREIGN KEY (id_plaga) REFERENCES plagas_enfermedades (id_plaga)
        ON DELETE SET NULL
);

CREATE TABLE publicaciones (
    id_publicacion INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario     INT NOT NULL,
    titulo         VARCHAR(150) NOT NULL,
    contenido      TEXT NOT NULL,
    fecha          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE respuestas (
    id_respuesta   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_publicacion INT NOT NULL,
    id_usuario     INT NOT NULL,
    contenido      TEXT NOT NULL,
    fecha          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_respuesta_publicacion
        FOREIGN KEY (id_publicacion) REFERENCES publicaciones (id_publicacion)
        ON DELETE CASCADE,
    CONSTRAINT fk_respuesta_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario)
        ON DELETE CASCADE
);

