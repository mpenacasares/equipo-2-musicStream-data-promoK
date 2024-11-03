/* En Python (continuando prueba de Fiona): 

##Musicbrainz: crear tabla por medio del dataframe

dataframe_mb_csv = pd.read_csv('../data/dataframe_MB.csv')
dataframe_mb_csv.to_sql(name='musicbrainz', con=engine, if_exists='append', index=False)

##Lastfm: crear tabla por medio del dataframe

dataframe_lastfm_csv = pd.read_csv('../data/df_lastfm.csv')
dataframe_lastfm_csv.to_sql(name='lastfm', con=engine, if_exists='append', index=False)

*/

-- Comprobar como se creó cada tabla
SHOW CREATE TABLE artistas; -- artista id es BIGINT DEFAULT NULL
SHOW CREATE TABLE musicbrainz; -- falta añadir artista id
SHOW CREATE TABLE spotify; -- artista id es BIGINT DEFAULT NULL
SHOW CREATE TABLE lastfm; -- falta añadir artista id

-- Añadir primary key a tabla artistas: 
ALTER TABLE artistas 
ADD PRIMARY KEY (artista_id);

-- Añadir columna artista ID a la tabla de musicbrainz (con los mismos valores que el artist id de la tabla artistas)
ALTER TABLE musicbrainz1
ADD COLUMN artista_id INT; 

-- Añadir foreign key a la tabla de musicbrainz
ALTER TABLE musicbrainz1
ADD FOREIGN KEY (artista_id) 
REFERENCES artistas(artista_id);

-- Añadir foreign key a la tabla de musicbrainz_sin_null
ALTER TABLE musicbrainz_sin_null
ADD FOREIGN KEY (artista_id) 
REFERENCES artistas(artista_id);

-- Añadir columna artista ID a la tabla de musicbrainz (con los mismos valores que el artist id de la tabla artistas)
ALTER TABLE lastfm 
ADD COLUMN artista_id INT;

-- Añadir foreign key a la tabla de lastfm
ALTER TABLE lastfm 
ADD FOREIGN KEY (artista_id) 
REFERENCES artistas(artista_id);

-- Añadir foreign key a la tabla de spoti
ALTER TABLE spotify 
ADD FOREIGN KEY (artista_id) 
REFERENCES artistas(artista_id);

-- Actualizar columna artista ID en musicbrainz: 
UPDATE lastfm 
SET artista_id = ( -- asigna nuevo valor por medio de subconsulta que selecciona el artista ID que coincida con el de artistas)
    SELECT a.artista_id 
    FROM artistas AS a 
    WHERE a.artista = lastfm.artista 
);

-- Actualizar columna artista ID en musicbrainz: 
UPDATE musicbrainz1
SET artista_id = ( -- asigna nuevo valor por medio de subconsulta que selecciona el artista ID que coincida (lo mas cercano posible al de artistas). En el caso de musicbrainz muchos nombres no eran exactamente igual al nombre artista de spoti
    SELECT a.artista_id 
    FROM artistas AS a 
    WHERE a.artista LIKE musicbrainz1.artista
);

-- 04/11: 

/* Crear tabla para MB sin nulos
CREATE TABLE musicbrainz_sin_null AS
SELECT *
FROM musicbrainz1;

*/

-- Eliminar columna artista name de tablas lastfm y MB: 

ALTER TABLE lastfm
DROP COLUMN artista; 

ALTER TABLE musicbrainz_sin_null
DROP COLUMN artista; 

-- Renombrar tablas: 

CREATE TABLE informacion_artista AS
SELECT *
FROM musicbrainz_sin_null;

CREATE TABLE estadisticas AS
SELECT *
FROM lastfm;

CREATE TABLE info_canciones AS
SELECT *
FROM spotify;

-- Cambiar columna de bio artista de estadistica a info_canciones: 

ALTER TABLE informacion_artista 
ADD COLUMN biografia TEXT;

UPDATE informacion_artista
SET biografia = ( -- asigna nuevo valor por medio de subconsulta que selecciona el artista ID que coincida (lo mas cercano posible al de artistas). En el caso de musicbrainz muchos nombres no eran exactamente igual al nombre artista de spoti
    SELECT biografía 
    FROM estadisticas AS e
    WHERE e.artista_id LIKE informacion_artista.artista_id);

-- Eliminar biografia artista de estadisticas: 

ALTER TABLE estadisticas
DROP COLUMN biografía; 

-- Modificar orden de las columnas: 

ALTER TABLE artistas
MODIFY COLUMN artista_id INT FIRST;

ALTER TABLE estadisticas
MODIFY COLUMN artista_id INT FIRST;

ALTER TABLE info_canciones
MODIFY COLUMN artista_id INT FIRST;

ALTER TABLE informacion_artista
MODIFY COLUMN artista_id INT FIRST;

ALTER TABLE informacion_artista
MODIFY COLUMN biografia TEXT AFTER artista_id; 

-- Luego de modificar tuve que añadir nuevamente las foreign keys (desde el diagrama). 

/* Resumen de lo hecho: 

- Eliminamos la columna 'artista' de todas las tablas menos de la de artistas
- Renombramos las tablas (spotify a info_canciones, lastfm a estadisticas, y musicbrainz a información_artista). 
- Cambiamos la columna biografía a la tabla información_artista
- Modificamos el orden de las columnas para que artista ID aparezca primero
- Dejamos la tabla musibrainz1 que contiene los nulos (si no podemos resolverlo, se elimina esa tabla). 

*/

-- Prueba con consulta de ejemplo: 

-- ¿Cuántos artistas tienen menos de 100,000 reproducciones?

SELECT COUNT(artista_id) AS total_artistas
FROM estadisticas
WHERE playcount < 100000;

-- ¿Qué país tiene mas artistas? (ordenar por cantidad)

SELECT ic.pais_de_origen AS pais, COUNT(a.artista_id) AS total_artistas
FROM artistas AS a
JOIN informacion_artista AS ic
USING (artista_id)
GROUP BY pais
ORDER BY total_artistas DESC; 

