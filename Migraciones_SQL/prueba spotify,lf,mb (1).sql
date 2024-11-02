
-- 02/11/2024 Maca y Fiona con la libreria SQLAlquemist:
	-- Elegir nombre para el schema que tenemos que tener todas el mismo
	-- 1. Usando el df de spotify -> crearemos 2 tablas en SQL, Artistas y Spotify, sin pasarle PK ni FK, eso lo haremos luego. 
		-- Pasaremos las columnas del df que necesitemos para cada una de las tablas
	-- 2. Cuando ya tengamos las tablas Artistas y Spotify en SQL 
		--  Artistas: tendra solo el nombre de los artistas duplicados -> hacemos DISTINCT y creamos una nueva tabla con los nombre unicos
			-- Cuando tengamos los nombres unicos, creamos artista_id en la tabla Artistas (artista_id sera unico tambien)
        -- Spotify : ANTES DE CREAR ESTA TABLA TENER YA TERMINADA LA TABLA ARTISTAS (valores unicos de id y nombre, y con la pk definida)
			-- Pasamos los datos tal cual, sin PK ni FK -> investigar como crear la columna artistas_id de tal forma que los nombres que tenemos en spotify esten
            -- relacionados con el id_artista que le corresponda (ej: si tenemos shakira en artistas con artista_id = 1, en spotify si tenemos a sharika tres veces, las tres veces tiene que tener artista_id =1)
            -- Al traer artista_id a spotify pensamos que si indicamos el es FK de artistas_id de artistas, deberia traerlo bien -> tenemos nombre artista en comun en ambas tablas
            -- Hacer comprobaciones de que ha traido los id correctamente
			-- Comprobar que estan bien las relaciones de PK y FK
	-- 3. Pasar los df de MB y LF tal cual, sin PK ni FK con sus valores y pasarle el artista_id en funcion del artista_id de la tabla Artistas (MB y LF no deberian tener artistas duplicados)
			-- Crear las PK y FK
            -- Pruebas de que esta okey
	-- Fiona esta metiendo en los jupyter de las extracciones los codigos para las extracciones a falta de tener definido el nombre del schema que usaremos todas			

-- 02/11/2024 - Fiona: he creado un Jupyter solo para las extracciones. Los ids de los artistas los estoy añadiendo a los df con códigos de python,
-- ya que he leído que SQL no te lo hace automáticamente aunque asignes FK. 
-- Voy a crear la tabla de Spotify a la que le he añadido en el df canción_id y artista_id. He hecho un mapeo de los ids de artistas para que se repitan
-- en el caso de que haya más de una canción para un artista. Voy a probar a migrar el df a la tabla Spotify.

-- NOMBRE DEL DATABASE QUE TODAS DEBEMOS CREAR: MusicStream_PR2_G2

USE MusicStream_PR2_G2;

CREATE TABLE Spotify (
    canción_id INT,
    nombre_cancion_album VARCHAR(200) NOT NULL,
    artista_id INT NOT NULL,
    tipo_album_cancion VARCHAR(50),
    año_lanzamiento VARCHAR(50),
    género VARCHAR(50),
    PRIMARY KEY (canción_id)
);

SELECT *
	FROM Spotify;

CREATE TABLE Artistas (
    artista_id INT,
    artista VARCHAR(50) NOT NULL,
    PRIMARY KEY (artista_id)
);

SELECT *
	FROM Artistas;

-- 02/11/2024 Estas son las tablas que había antes. He creado una nueva de Spoty arriba. 

-- Tabla Spotify con referencia a artista_id
CREATE TABLE Spotify (
    nombre_cancion_album VARCHAR(50) NOT NULL,
    artista_id INT NOT NULL,
    tipo_album_cancion VARCHAR(50),
    año_lanzamiento YEAR,
    género VARCHAR(50),
    PRIMARY KEY (nombre_cancion_album, artista_id),
    CONSTRAINT fk_spotify_artistas
		FOREIGN KEY (artista_id) 
        REFERENCES Artistas(artista_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Tabla MusicBrainz con referencia a artista_id
CREATE TABLE MusicBrainz (
    artista_id INT NOT NULL,
    pais_origen VARCHAR(50),
    area_origen VARCHAR(50),
    fecha_nacimiento VARCHAR(50),
    fecha_inicio_act VARCHAR(50),
    fecha_final_act VARCHAR(50),
    PRIMARY KEY (artista_id),
	CONSTRAINT fk_MB_artistas
		FOREIGN KEY (artista_id) 
		REFERENCES Artistas(artista_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Tabla LF con referencia a artista_id
CREATE TABLE LF (
    artista_nombre INT NOT NULL,
    artista_biografia_LF TEXT,
    listeners INT,
    playcount INT,
    artistas_similares VARCHAR(100),
    PRIMARY KEY (artista_id),
    CONSTRAINT fk_LF_artistas
		FOREIGN KEY (artista_id) 
		REFERENCES Artistas(artista_id)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);


 
 /*
 CREATE TABLE Spotify (
    nombre_cancion_album VARCHAR(50) NOT NULL,
    artista_nombre_spotify VARCHAR(50) NOT NULL,
    tipo_cancion_album VARCHAR(50),
    anio_lanzamiento YEAR,
    genero VARCHAR(50),
    PRIMARY KEY (nombre_cancion_album, artista_nombre_spotify)
    -- UNIQUE (artista_nombre_spotify) -- Índice único agregado
	);
 
  CREATE TABLE MusicBrainz (
    artista_nombre_MB VARCHAR(50) NOT NULL,
    pais_origen VARCHAR(50),
    area_origen VARCHAR(50),
	fecha_nacimiento VARCHAR(50),
    fecha_inicio_act VARCHAR(50),
    fecha_final_act VARCHAR(50),
    PRIMARY KEY (artista_nombre_MB),
	CONSTRAINT fk_mb_spotify
		FOREIGN KEY (artista_nombre_MB)
		REFERENCES Spotify(nombre_cancion_album, artista_nombre_spotify)
		ON DELETE CASCADE
        ON UPDATE CASCADE
	);
 
	CREATE TABLE LF (
    artista_nombre_LF VARCHAR(50) NOT NULL,
	artista_biografia_LF TEXT,
    listeners INT,
    playcount INT,
    artistas_similares VARCHAR(100),
    PRIMARY KEY (artista_nombre_LF),
        CONSTRAINT fk_lf_spotify
		FOREIGN KEY (artista_nombre_LF)
		REFERENCES Spotify(artista_nombre_spotify)
		ON DELETE CASCADE
        ON UPDATE CASCADE
	);
 
  */
    
SELECT * FROM spotify;

SELECT * FROM MusicBrainz;

SELECT * FROM LF