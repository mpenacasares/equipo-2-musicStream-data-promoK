USE musicstream_pr2_g2;

-- Para desactivar el modo seguro de SQL
-- SET SQL_SAFE_UPDATES = 0;

-- Para activar el modo seguro de SQL
-- SET SQL_SAFE_UPDATES = 1;

-- Limpieza de None que venia de la importacion de JSON
/*

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

UPDATE estadisticas
	SET artistas_similares = NULL
	WHERE artistas_similares = 'none'

*/

 -- ---------------------------------LIMPIEZA DATOS ------------------ 
SELECT * FROM artistas LIMIT 10; -- Artistas esta OK
-- SELECT * FROM artistas WHERE artista = NULL

SELECT * FROM info_canciones LIMIT 10;
-- año_lanzamiento y genero estan ok, se hace DISTINCT y se comprueba que tienen los valores previstos sin NULL
-- tipo_album_cancion tiene album (2508), single(1446) y compilation (46) -- dejamos compilation como un tercer formato
-- nombre_cancion_album no tiene NULL

/*
	SELECT *
		FROM info_canciones
		WHERE artistas_similares = 'none'

	SELECT DISTINCT(género)
		FROM info_canciones
		WHERE nombre_cancion_album = 'compilation'
        
        
*/

SELECT * FROM estadisticas LIMIT 10;
-- Artistas similares tiene 50 NULL sobre muestra de 899 -> residual
-- Listeners (cantidad de gente que lo escucha). - ok
-- Playcount (cantidad de veces reproducido su música) - ok
/*
	SELECT *
		FROM estadisticas
		WHERE listeners IS NULL OR playcount IS NULL OR artistas_similares IS NULL OR artistas_similares IS NULL OR artista_id IS NULL;
        
	SELECT *
		FROM estadisticas
		WHERE artistas_similares = 'none'
*/

SELECT * FROM informacion_artista LIMIT 10;

-- No hay valores de NONE
	SELECT *
		FROM informacion_artista
		WHERE biografia = 'none' OR pais_de_origen = 'none' OR area_de_origen = 'none' OR fecha_nacimiento = 'none' OR fecha_inicio_actividad = 'none' OR fecha_fin_actividad = 'none';
        
-- No hay artista_id NULL
	SELECT *
		FROM informacion_artista
		WHERE artista_id IS NULL;
        
-- Añadimos mes enero dia 1 para las fechas de nacimiento en las que tenemos solo año y dia 1 de enero para las de anio y mes       
	SELECT fecha_nacimiento
		FROM informacion_artista
		WHERE LENGTH(fecha_nacimiento) = 4;

	UPDATE informacion_artista 
		SET fecha_nacimiento = CONCAT(fecha_nacimiento, "-01-01") 
		WHERE LENGTH(fecha_nacimiento) = 4;

	SELECT fecha_nacimiento
		FROM informacion_artista
		WHERE LENGTH(fecha_nacimiento) = 7;
        
	UPDATE informacion_artista 
		SET fecha_nacimiento = CONCAT(fecha_nacimiento, "-01") 
		WHERE LENGTH(fecha_nacimiento) = 7;
        
	SELECT fecha_nacimiento
			FROM informacion_artista
			WHERE fecha_nacimiento IS NULL;

-- fecha_inicio_actividad lo dejamos solo con el año

	SELECT (fecha_inicio_actividad)
		FROM informacion_artista;
		
	UPDATE informacion_artista 
		SET fecha_inicio_actividad = LEFT(fecha_inicio_actividad, 4); 
        
-- Cambiamos el formato de fechas a fecha_inicio_actividad y fecha_nacimiento
	ALTER TABLE informacion_artista
		MODIFY fecha_inicio_actividad YEAR;
        
	ALTER TABLE informacion_artista
		MODIFY fecha_nacimiento DATE;

-- fecha_fin_actividad tiene fechas completas, de año, actualidad, No activo        
SELECT DISTINCT(fecha_fin_actividad)
		FROM informacion_artista;
        
SELECT fecha_fin_actividad -- solo 1 valor tiene mes - anio
		FROM informacion_artista        
		WHERE LENGTH(fecha_fin_actividad) = 7;
-- Actualizamos anadiendo el dia para tener la fecha completa
        UPDATE informacion_artista 
			SET fecha_fin_actividad = CONCAT(fecha_fin_actividad, "-01") 
			WHERE LENGTH(fecha_fin_actividad) = 7;
        
-- esta ok porque tiene fecha completa  
SELECT fecha_fin_actividad -- 18 valores con fecha completa -> ahora son 19 anadiendo el del mes -> ahora 28 anadiendo mes y dia
		FROM informacion_artista        
		WHERE LENGTH(fecha_fin_actividad) = 10 AND fecha_fin_actividad NOT LIKE '%Actualidad%';

SELECT fecha_fin_actividad -- 9 valores con fecha completa
		FROM informacion_artista        
		WHERE LENGTH(fecha_fin_actividad) = 4;
        
       -- Actualizamos anadiendo el dia y mes para tener la fecha completa     
        UPDATE informacion_artista
			SET fecha_fin_actividad = CONCAT(fecha_fin_actividad, "-01-01")
			WHERE LENGTH(fecha_fin_actividad) = 4; 
    
-- Solo tenemos 1 valor con  fecha_fin_actividad = 'No activo' para artista_id = 824 que es Queen, modificamos por una fecha
		UPDATE informacion_artista
			SET fecha_fin_actividad = "1991-11-24"
            WHERE artista_id = 842;
            
	SELECT artista_id,pais_de_origen,area_de_origen
		 FROM informacion_artista;	
	
	
-- Creamos copia de informacion_artista 
/*
CREATE TABLE informacion_artista_copy AS
	SELECT *
	FROM informacion_artista
*/


-- Script para corregir valores area - pais
/*
  -- Paso 1: Crear una tabla temporal para almacenar los cambios
CREATE TEMPORARY TABLE temp_correcciones AS
SELECT artista_id,
       CASE 
           -- Casos específicos donde pais_de_origen no es un país y lo cambiamos por el país correspondiente
           WHEN pais_de_origen = 'New York' THEN 'United States'
           WHEN pais_de_origen = 'North Carolina' THEN 'United States'
           WHEN pais_de_origen = 'West Yorkshire' THEN 'United Kingdom'
           WHEN pais_de_origen = 'Los Angeles' THEN 'United States'
           WHEN pais_de_origen = 'Madrid' THEN 'Spain'
           WHEN pais_de_origen = 'Burgos' THEN 'Spain'
           WHEN pais_de_origen = 'Comunidad Valenciana' THEN 'Spain'
           WHEN pais_de_origen = 'Chicago' THEN 'United States'
           WHEN pais_de_origen = 'Florida' THEN 'United States'
           WHEN pais_de_origen = 'Pittsburgh' THEN 'United States'
           WHEN pais_de_origen = 'Brighton' THEN 'United Kingdom'
           WHEN pais_de_origen = 'Sevilla' THEN 'Spain'
           WHEN pais_de_origen = 'Venezia' THEN 'Italy'
           WHEN pais_de_origen = 'Elche' THEN 'Spain'
           WHEN pais_de_origen = 'Santiago' THEN 'Chile'
           WHEN pais_de_origen = 'Kentucky' THEN 'United States'
           WHEN pais_de_origen = 'Asheville' THEN 'United States'
           WHEN pais_de_origen = 'Athens' THEN 'Greece'
           -- Añade otros casos según sea necesario
           ELSE pais_de_origen
       END AS nuevo_pais_de_origen,
       -- Si el valor original en pais_de_origen no era un país válido, lo asignamos a area_de_origen
       CASE 
           WHEN pais_de_origen IN ('New York', 'North Carolina', 'West Yorkshire', 'Los Angeles', 'Madrid', 'Burgos', 
                                   'Comunidad Valenciana', 'Chicago', 'Florida', 'Pittsburgh', 'Brighton', 'Sevilla', 
                                   'Venezia', 'Elche', 'Santiago', 'Kentucky', 'Asheville', 'Athens') 
           THEN COALESCE(area_de_origen, pais_de_origen)
           ELSE area_de_origen
       END AS nuevo_area_de_origen
FROM informacion_artista;

-- Paso 2: Aplicar las correcciones en la tabla original usando la tabla temporal
UPDATE informacion_artista AS ia
JOIN temp_correcciones AS tc ON ia.artista_id = tc.artista_id
SET ia.pais_de_origen = tc.nuevo_pais_de_origen,
    ia.area_de_origen = tc.nuevo_area_de_origen;

-- Paso 3: Limpiar la tabla temporal
DROP TEMPORARY TABLE temp_correcciones;

-- Consulta de verificación (opcional): verificar los cambios realizados
SELECT * FROM informacion_artista WHERE artista_id IN (747, 744, 159, 426, 631, 845, 28, 334, 734, 653, 119);
      
        
    -- -----------------    
-- Crear una copia de seguridad de la tabla original
CREATE TABLE informacion_artista_backup AS SELECT * FROM informacion_artista;

-- Actualizar registros que contienen ciudades o regiones en `pais_de_origen` y mover esos valores a `area_de_origen`
UPDATE informacion_artista
SET 
    area_de_origen = CASE
        WHEN pais_de_origen IN ('New York', 'Wasilla', 'Stockholm', 'Alcalá de Henares', 'San Francisco', 'Hermosillo', 'Berlin', 'North Carolina', 'Medellín', 'Río Piedras', 'Paris', 'Doncaster', 'Columbus', 'Philadelphia', 'Burgin', 'Santa Cruz de Tenerife', 'Helsinki', 'Bray', 'Madrid', 'Sacramento', 'Morón', 'Sevilla', 'San Juan', 'Zaragoza', 'Los Angeles', 'Oklahoma City', 'Comunidad Valenciana', 'Burgos', 'Corozal', 'London', 'Leeds', 'Jefferson', 'Putney', 'Boston', 'Cambridge', 'Brighton', 'Peckham', 'Birmingham', 'Totnes', 'Belfast', 'Liverpool', 'Manchester', 'Bristol', 'Oxford') 
            THEN pais_de_origen
        ELSE area_de_origen
    END,
    pais_de_origen = CASE
        WHEN pais_de_origen IN ('New York', 'Wasilla', 'Stockholm', 'Alcalá de Henares', 'San Francisco', 'Hermosillo', 'Berlin', 'North Carolina', 'Medellín', 'Río Piedras', 'Paris', 'Doncaster', 'Columbus', 'Philadelphia', 'Burgin', 'Santa Cruz de Tenerife', 'Helsinki', 'Bray', 'Madrid', 'Sacramento', 'Morón', 'Sevilla', 'San Juan', 'Zaragoza', 'Los Angeles', 'Oklahoma City', 'Comunidad Valenciana', 'Burgos', 'Corozal', 'London', 'Leeds', 'Jefferson', 'Putney', 'Boston', 'Cambridge', 'Brighton', 'Peckham', 'Birmingham', 'Totnes', 'Belfast', 'Liverpool', 'Manchester', 'Bristol', 'Oxford') 
            THEN CASE
                WHEN pais_de_origen = 'New York' OR pais_de_origen = 'Los Angeles' OR pais_de_origen = 'San Francisco' THEN 'United States'
                WHEN pais_de_origen = 'Berlin' THEN 'Germany'
                WHEN pais_de_origen = 'Stockholm' OR pais_de_origen = 'Helsinki' THEN 'Sweden'
                WHEN pais_de_origen = 'Paris' THEN 'France'
                WHEN pais_de_origen = 'Madrid' OR pais_de_origen = 'Barcelona' THEN 'Spain'
                WHEN pais_de_origen = 'London' OR pais_de_origen = 'Manchester' THEN 'United Kingdom'
                WHEN pais_de_origen = 'Belfast' THEN 'Northern Ireland'
                WHEN pais_de_origen = 'Toronto' THEN 'Canada'
                WHEN pais_de_origen = 'Rio de Janeiro' THEN 'Brazil'
                ELSE pais_de_origen
            END
        ELSE pais_de_origen
    END;

-- Confirmar cambios realizados
SELECT * FROM informacion_artista
WHERE pais_de_origen IN ('New York', 'Wasilla', 'Stockholm', 'Alcalá de Henares', 'San Francisco', 'Hermosillo', 'Berlin', 'North Carolina', 'Medellín', 'Río Piedras', 'Paris', 'Doncaster', 'Columbus', 'Philadelphia', 'Burgin', 'Santa Cruz de Tenerife', 'Helsinki', 'Bray', 'Madrid', 'Sacramento', 'Morón', 'Sevilla', 'San Juan', 'Zaragoza', 'Los Angeles', 'Oklahoma City', 'Comunidad Valenciana', 'Burgos', 'Corozal', 'London', 'Leeds', 'Jefferson', 'Putney', 'Boston', 'Cambridge', 'Brighton', 'Peckham', 'Birmingham', 'Totnes', 'Belfast', 'Liverpool', 'Manchester', 'Bristol', 'Oxford');

*/
-- ---------
SELECT DISTINCT(pais_de_origen) 
		 FROM informacion_artista;	
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
         