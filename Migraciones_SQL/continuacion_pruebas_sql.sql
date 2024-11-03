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
ALTER TABLE musicbrainz 
ADD COLUMN artista_id BIGINT DEFAULT NULL;

-- Añadir foreign key a la tabla de musicbrainz
ALTER TABLE musicbrainz 
ADD FOREIGN KEY (artista_id) 
REFERENCES artistas(artista_id);

-- Añadir columna artista ID a la tabla de musicbrainz (con los mismos valores que el artist id de la tabla artistas)
ALTER TABLE lastfm 
ADD COLUMN artista_id BIGINT DEFAULT NULL;

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
UPDATE musicbrainz 
SET artista_id = ( -- asigna nuevo valor por medio de subconsulta que selecciona el artista ID que coincida (lo mas cercano posible al de artistas). En el caso de musicbrainz muchos nombres no eran exactamente igual al nombre artista de spoti
    SELECT a.artista_id 
    FROM artistas AS a 
    WHERE a.artista LIKE musicbrainz.artista
);

/*



