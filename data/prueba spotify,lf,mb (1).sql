-- DUDA: CrearBBDD para el grupo ?
 CREATE TABLE MusicBrainz (
    artista_nombre_MB VARCHAR(50) NOT NULL,
    pais_origen VARCHAR(50),
    area_origen VARCHAR(50),
    -- DUDA: Tenemos diferentes formatos en las fechas: texto, null, fechas completas y fechas de solo anio
	fecha_nacimiento VARCHAR(50),
    fecha_inicio_act VARCHAR(50),
    fecha_final_act VARCHAR(50),
    PRIMARY KEY (artista_nombre_MB)
	);
    
     CREATE TABLE LF (
    artista_nombre_LF VARCHAR(50) NOT NULL,
	artista_biografia_LF TEXT,
    listeners INT,
    playcount INT,
    artistas_similares VARCHAR(100),
    PRIMARY KEY (artista_nombre_LF)
	);

 CREATE TABLE Spotify (
	cancion_id  INT NOT NULL AUTO_INCREMENT,
    nombre_cancion_album VARCHAR(50),
    artista_nombre_spoty VARCHAR(50),
    artista_nombre_LF VARCHAR(50),
    tipo_cancion_album VARCHAR(50),
    anio_lanzamiento YEAR,
    genero VARCHAR(50),
    PRIMARY KEY (cancion_id),
    -- DUDA: artista_nombre_spoty hace referencia a 2 PRIMARY KEY
    CONSTRAINT fk_spotify_mb
		FOREIGN KEY (artista_nombre_spoty)
		REFERENCES MusicBrainz(artista_nombre_MB)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_spotify_lastfm
		FOREIGN KEY (artista_nombre_spoty)
		REFERENCES LF(artista_nombre_LF)
		ON DELETE CASCADE
		ON UPDATE CASCADE
	);
    
SELECT * FROM spotify;

SELECT * FROM MusicBrainz;

SELECT * FROM LF