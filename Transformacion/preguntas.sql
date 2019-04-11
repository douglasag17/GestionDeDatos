-- 1. ¿Cuál fue el cliente que más rentó por mes en el año 2006?

-- 2. ¿Cuál fue el genero de pelicula mas rentado en los meses de octubre de cada año?
SELECT f.name_category, COUNT(r.rental_id) as cantidasRentadas, t.año as year, t.mes AS month
FROM sakilaOlap.factRental r
JOIN sakilaOlap.dimFilm f ON f.film_id = r.film_id
JOIN sakilaOlap.dimTime t ON t.tiempo_id = r.tiempo_id
GROUP BY f.name_category, year, month
ORDER BY cantidasRentadas DESC;

-- 3. ¿Cual es el rental_rate de las películas top más rentadas en los últimos 2 años?

-- 4. ¿Que películas son las que menos se han rentado en los últimos 2 años?

-- 5. ¿En qué fechas del mes se realizan menos rentas de acuerdo a los últimos 3 años?

-- 6. ¿Cual es la pelicula mas rentada por país en abril del 2005?

-- 7. ¿Cual es el top 10 de clientes y cuales son los meses en que ellos menos rentan?

-- 8. ¿Cuales clientes son los que más han rentado y en qué género?

-- 9. ¿Qué tienda ha tenido el mayor número de rentas en el último año?
SELECT COUNT(r.rental_id) AS totalRentas, r.store_id, t.año
FROM sakilaOlap.factRental r
JOIN sakilaOlap.dimStore s ON r.store_id = s.store_id
JOIN sakilaOlap.dimTime t ON t.tiempo_id = r.tiempo_id
GROUP BY r.store_id, t.año
ORDER BY totalRentas DESC;

-- 10. ¿Cual es el cliente más fiel (mayor número de rentas por mes)?
