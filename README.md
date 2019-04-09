# GestionDeDatos - Proceso ETL

Realizado por:
- Douglas Ardila Garces
- Andres Felipe Avendaño
- Julian Andres Sanchez
- Sebastian Ospina Cabarcas

Documentacion proceso ETL sobre la base de datos relacional Sakila
![Screenshot](sakila.png)


# Extracción
Se tiene un archivo de formato JSON con datos semi-estructurados de diferentes paises, el objetivo es extraer los datos de este archivo y complementar la tabla country de sakila

Primero definimos el "que", que es lo que se va a hacer para poder "unificar" ambas estructuras.

1. Entender como funcionan las estructuras
2. Entender las fuentes
3. Extraerla
4. Transformar de json a una tabla
5. Comparar y complementarlas
6. Unificar
7. Agregar tabla a sakila

Para llevar a cabo lo anterior creamos un pequeño script en python utilizando la libreria pandas
- [extraccion.py](https://github.com/douglasag17/GestionDeDatos/blob/master/Extraccion/extraccion.py)

Consultas para unificar y crear una sola tabla country, consultas sobre agregaciones y vistas
- [extraccion.sql](https://github.com/douglasag17/GestionDeDatos/blob/master/Extraccion/extraccion.sql)

# Transformación

#### Preguntas del negocio:
1. ¿Cuál fue el cliente que más rentó por mes en el año 2006?
2. ¿Cuál fue el genero de pelicula mas rentado en los meses de octubre de cada año?
3. ¿Cual es el rental_rate de las películas top más rentadas en los últimos 2 años?
4. ¿Que películas son las que menos se han rentado en los últimos 2 años?
5. ¿En qué fechas del mes se realizan menos rentas de acuerdo a los últimos 3 años?
6. ¿Cual es la pelicula mas rentada por país en abril del 2005?
7. ¿Cual es el top 10 de clientes y cuales son los meses en que ellos menos rentan?
8. ¿Cuales clientes son los que más han rentado y en qué género?
9. ¿Qué tienda ha tenido el mayor número de rentas en el último año?
10. ¿Cual es el cliente más fiel (mayor número de rentas por mes)?

#### Reglas de transformacion
- 
-
-
-

# Carga

#### Modelo OLAP
![Screenshot](modeloOlap.jpg)
 
Creamos el esquema de la nueva base de datos sakilaOlap
- [Esquema](https://github.com/douglasag17/GestionDeDatos/blob/master/Carga/schemaOlap.sql)

Procedures para llenar las tablas de dimension y hechos
- [Procedures](https://github.com/douglasag17/GestionDeDatos/blob/master/Carga/fillTablesOlap.sql)
