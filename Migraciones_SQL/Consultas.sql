USE musicstream_pr2_g2;

-- Para desactivar el modo seguro de SQL
SET SQL_SAFE_UPDATES = 0;

-- Para activar el modo seguro de SQL
SET SQL_SAFE_UPDATES = 1;



SELECT * FROM artistas LIMIT 10;

SELECT * FROM info_canciones LIMIT 10;

-- Limpieza de None que venia de la importacion de JSON
SELECT * FROM informacion_artista LIMIT 10;

UPDATE informacion_artista
	SET biografia = NULL
	WHERE biografia = 'none';

UPDATE informacion_artista
	SET pais_de_origen = NULL
	WHERE pais_de_origen = 'none';

UPDATE informacion_artista
	SET area_de_origen = NULL
	WHERE area_de_origen = 'none';

UPDATE informacion_artista
	SET fecha_nacimiento = NULL
	WHERE fecha_nacimiento = 'none';

UPDATE informacion_artista
	SET fecha_inicio_actividad = NULL
	WHERE fecha_inicio_actividad = 'none';
    
UPDATE informacion_artista
	SET fecha_fin_actividad = NULL
	WHERE fecha_fin_actividad = 'none';

SELECT * FROM estadisticas LIMIT 10;

-- Limpieza de None que venia de la importacion de JSON
UPDATE estadisticas
	SET artistas_similares = NULL
	WHERE artistas_similares = 'none'



