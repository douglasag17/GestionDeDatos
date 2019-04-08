-- ---------------------------------------------------UNIFICACION en countryMerge------------------------------------------------------------

use sakila;

-- CREANDO TABLA countryMerge paises comunes + countrySakila
create table if not exists countryMerge
select country.country_id, country.country, country1.alpha2Code, country1.alpha3Code, country1.altSpellings,
	country1.area, country1.borders, country1.callingCodes, country1.capital, country1.cioc, country1.currencies,
    country1.demonym, country1.flag, country1.gini, country1.languages, country1.latlng, country1.nativeName, 
    country1.numericCode, country1.population, country1.region, country1.regionalBlocs, country1.subregion,
    country1.timezones, country1.topLevelDomain, country1.translations
from country left join country1 on country.country = country1.name;

-- tabla de los que estan en country1, pero no en country
create table if not exists countryJson
select country1.country_id, country1.name as country, country1.alpha2Code, country1.alpha3Code, country1.altSpellings,
	country1.area, country1.borders, country1.callingCodes, country1.capital, country1.cioc, country1.currencies,
    country1.demonym, country1.flag, country1.gini, country1.languages, country1.latlng, country1.nativeName, 
    country1.numericCode, country1.population, country1.region, country1.regionalBlocs, country1.subregion,
    country1.timezones, country1.topLevelDomain, country1.translations
from country right join country1 on country.country = country1.name where country.country is null;

-- uniendo tablas countryMerge y countryJson
alter table countryMerge change country country varchar(52);

insert into countryMerge (country, alpha2Code, alpha3Code, altSpellings,
	area, borders, callingCodes, capital, cioc, currencies,
    demonym, flag, gini, languages, latlng, nativeName, 
    numericCode, population, region, regionalBlocs, subregion,
    timezones, topLevelDomain, translations)
select country, alpha2Code, alpha3Code, altSpellings,
	area, borders, callingCodes, capital, cioc, currencies,
    demonym, flag, gini, languages, latlng, nativeName, 
    numericCode, population, region, regionalBlocs, subregion,
    timezones, topLevelDomain, translations
from countryJson;




-- ---------------------------------------------------AGREGACIONES------------------------------------------------------------

-- cantidad de paises que comparten los mismos idiomas
SELECT COUNT(country) as cantidad, languages 
FROM countryMerge
GROUP BY languages
ORDER BY cantidad desc;

-- cantidad de paises por zona horaria
SELECT COUNT(country) as cantidad, timezones 
FROM countryMerge
GROUP BY timezones
ORDER BY cantidad desc;

-- cantidad de paises por region
SELECT COUNT(country), region 
FROM countryMerge
GROUP BY region;

-- cantidad de tiendas por pais (Australia y canada)
SELECT count(store.store_id) as cant, countryMerge.country
FROM store
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN countryMerge ON city.country_id = countryMerge.country_id
GROUP BY countryMerge.country;

-- cantidad de staff por pais
SELECT count(staff.staff_id) as cant, countryMerge.country, staff.first_name
FROM staff
INNER JOIN address ON staff.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN countryMerge ON city.country_id = countryMerge.country_id
GROUP BY countryMerge.country, staff.first_name
ORDER BY cant DESC;

-- cantidad de customer por pais
SELECT count(customer.customer_id) as cant, countryMerge.country
FROM customer
INNER JOIN sakila.address ON customer.address_id = address.address_id
INNER JOIN sakila.city ON address.city_id = city.city_id
INNER JOIN sakila.countryMerge ON city.country_id = countryMerge.country_id
GROUP BY countryMerge.country
ORDER BY cant ASC;

-- disponibilidad que hay de cada pelicula por pais
select count(f.title) as numero, cc.country, f.title from film f
inner join inventory i on f.film_id=i.film_id
inner join store s on i.store_id=s.store_id
inner join address a on s.address_id=a.address_id
inner join city c on a.city_id=c.city_id
inner join countryMerge cc on c.country_id=cc.country_id
group by i.store_id,f.title, cc.country 
order by f.title,s.store_id ASC;

-- cuando se alquila mas por año
SELECT count(year(rental.rental_date)) as canFecha
FROM rental
group BY year(rental.rental_date) desc;

-- Genero de pelicula mas rentado
select category.name, count(rental.rental_id) as c from category
inner join film_category on category.category_id = film_category.category_id
inner join film on film_category.film_id=film.film_id
inner join inventory on inventory.film_id= film.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
group by category.name
order by c DESC;

-- Genero de pelicula mas rentado agrupado por mes
select category.name,count(rental.rental_id)as d,month(rental.rental_date) as mes, year(rental.rental_date) as año 
from category
inner join film_category on category.category_id = film_category.category_id
inner join film on film_category.film_id=film.film_id
inner join inventory on inventory.film_id= film.film_id
inner join rental on inventory.inventory_id=rental.inventory_id
where month(rental.rental_date) between 1 and 12
group by category.name,year(rental.rental_date),month(rental.rental_date)
order by category.name DESC;



-- ---------------------------------------------------VISTAS------------------------------------------------------------

-- 10 peliculas mas alquiladas
CREATE OR REPLACE VIEW filmMasRentados AS 
SELECT film.title
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
GROUP BY film.title
ORDER BY count(film.film_id)  DESC
LIMIT 10;

-- ganancias por tienda en dolares
CREATE OR REPLACE VIEW gananciasPorTienda AS 
SELECT SUM(p.amount), s.store_id
FROM payment p 
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN staff s ON r.staff_id = s.staff_id
INNER JOIN store st ON s.store_id = st.store_id
GROUP BY s.store_id;

-- cantidad de peliculas por pais
CREATE OR REPLACE VIEW peliculasPorPais AS 
SELECT count(film.film_id) as cant, countryMerge.country
FROM sakila.film
INNER JOIN sakila.inventory ON film.film_id = inventory.film_id
INNER JOIN sakila.store ON store.store_id = inventory.store_id
INNER JOIN sakila.address ON address.address_id =  store.address_id
INNER JOIN sakila.city ON address.city_id = city.city_id
INNER JOIN sakila.countryMerge ON city.country_id = countryMerge.country_id
GROUP BY countryMerge.country;
