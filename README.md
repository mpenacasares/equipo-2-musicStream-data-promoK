# Proyecto MusicStream: Análisis de Popularidad de Canciones en la Era Digital

Este proyecto ha sido desarrollado por el Equipo "FM-AMY Waves" del bootcamp de **Data Analytics de Adalab** como parte del módulo 2. El equipo de desarrollo está formado por:

- **Ariana Papantonio**
- **Fiona Sánchez**
- **Macarena Peña**
- **Marta Gamarra**
- **Yolanda Serrano**

## Descripción del Proyecto ✨

**Proyecto MusicStream: "Análisis de Popularidad de Canciones en la Era Digital"** es una iniciativa centrada en analizar la popularidad de canciones y álbumes en la plataforma ficticia _MusicStream_. Aprovechando técnicas avanzadas de extracción y análisis de datos, el proyecto pretende responder a preguntas clave sobre el consumo de música en la era digital.

## Objetivo ✨

El objetivo principal es identificar las canciones y álbumes más populares en _MusicStream_, usando para ello diversas fuentes de datos, como:

- **API de Spotify**: Para obtener información detallada sobre canciones, álbumes y artistas.
- **API de MusicBrainz**: Para complementar la información de canciones y discos.
- **API de last.fm**: Para datos adicionales de popularidad y tendencias musicales.

Toda la información extraída es almacenada en una base de datos relacional en **MySQL**, desde donde realizamos consultas para extraer insights clave sobre la popularidad de la música.

## Tecnologías Utilizadas ✨

Para desarrollar este proyecto, hemos utilizado las siguientes herramientas y tecnologías:

- **Lenguaje de Programación**: Python
- **Bases de Datos**: MySQL
- **APIs**: Spotify, MusicBrainz y last.fm
- **Entorno de Desarrollo**: VS Code
- **Análisis y Transformación de Datos**: Librerías de Python como Pandas y SQLAlchemy

## Estructura del Proyecto ✨

El proyecto está estructurado de la siguiente manera:

- `consultas/`: Contiene los resultados de las consultas en formato JSON.
- `data/`: Carpeta donde se almacenan los dataframes con los datos extraidos.
- `notebooks/`: Incluye notebooks de Jupyter con la extracción de datos de cada API.
- `migraciones_SQL/`: Contiene los archivos con los scripts para la estructura de las tablas en SQL, el código utilizado para migrar los dataframes a SQL, la información de las tablas en formato JSON y la estructura de la BBDD.
- `README.md`: Archivo que proporciona una descripción general del proyecto.

## Instalación y Ejecución ✨

1. **Clonar el Repositorio**

   ```bash
   git clone <https://github.com/mpenacasares/equipo-2-musicStream-data-promoK.git>

   ```

2. **Instalar Dependencias**

   Asegúrate de tener Python y MySQL instalados en tu sistema. Luego, instala las librerías de Python requeridas. Podrás encontrar las librerías en los jupyter de las carpetas 'Notebooks' y 'Migraciones SQL'.

3. **Configurar Acceso a las APIs**

   Regístrate en las plataformas de Spotify, MusicBrainz y last.fm para obtener las claves de API necesarias. Luego, crea un archivo .env en la raíz del proyecto y agrega las claves de acceso

4. **Ejecuta el proyecto**

   1. Ejecuta los archivos jupyter de extracción de datos que se encuentran en la carpeta 'Notebooks'.
   2. Crea las tablas en SQL por medio del script incluido en el archivo 'Creación_tablas_SQL' en la carpeta 'Migraciones_SQL'.
   3. Ejecuta el archivo 'Migración_python_SQL' para pasar los datos de Python a las tablas en la base de datos de SQL.
   4. Sigue los pasos del archivo 'Consultas_SQL' para limpiar los datos y lanzar las consultas.

## Análisis Realizado ✨

A través de consultas y análisis sobre la base de datos creada, hemos logrado identificar:

- El género con el promedio más alto de reproducciones
- Los artistas con más listeners por género y sus cantantes similares
- La cantidad de artistas pertenecientes a cada género y el género con mayor cantidad de artistas
- Los cinco artistas menos escuchados
- Los países con mayor cantidad de artistas
- Los artistas que sacaron más canciones por género

Estas consultas son las que ha realizado nuestro equipo, pero tu puedes hacer las consultas que quieras! 🎉
