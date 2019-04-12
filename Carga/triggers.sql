use sakila;

DROP TRIGGER IF EXISTS fill_table_dimTime;

DELIMITER //
CREATE TRIGGER fill_table_dimTime AFTER INSERT ON rental
for each row
BEGIN
    insert into sakilaOLap.dimTime
                (
                fecha,
                año,
                dia,
                mes,
                semana_del_año,
                dia_del_años,
                hora,
                minuto,
                segundo,
                semestre,
                bimestre,
                trimestre)
                values
                (
                    new.rental_date,
                    year(new.rental_date),
                    day(new.rental_date),
                    month(new.rental_date),
                    weekofyear(new.rental_date),
                    dayofyear(new.rental_date),
                    hour(new.rental_date),
                    minute(new.rental_date),
                    second(new.rental_date),
                    month(new.rental_date)/6,
                    month(new.rental_date)/2,
                    quarter(new.rental_date)   
                );
END//
DELIMITER ;



DROP TRIGGER IF EXISTS fill_table_dimCustomer;

DELIMITER //
CREATE TRIGGER fill_table_dimCustomer AFTER INSERT ON customer
for each row
BEGIN
    INSERT INTO sakilaOLap.dimCustomer
                (
                customer_id,
                first_name,
                last_name,
                email,
                address_cus,
				city_cus,
				country_cus,
				district_cus)
                select distinct customer.customer_id, customer.first_name, customer.last_name, customer.email, 
					city, country, district, sakila.address.address from sakila.country
               INNER JOIN sakila.city ON country.country_id = city.country_id
               INNER JOIN sakila.address ON city.city_id = address.city_id
               INNER JOIN sakila.customer ON address.address_id = customer.address_id
               INNER JOIN sakila.rental ON customer.customer_id = rental.customer_id
               WHERE rental.customer_id = new.customer_id;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS fill_table_dimStore;

DELIMITER //
CREATE TRIGGER fill_table_dimStore AFTER INSERT ON store
for each row
BEGIN
    INSERT INTO sakilaOLap.dimStore	
                (
					store_id,
                    city_store,
                    country_store,
                    district_store,
                    address_store
                )
                select distinct store.store_id, city, country, district, address from sakila.country
                INNER JOIN sakila.city ON country.country_id = city.country_id
                INNER JOIN sakila.address ON city.city_id = address.city_id                
                INNER JOIN sakila.store ON address.address_id = store.address_id
                INNER JOIN sakila.inventory ON store.store_id = inventory.store_id
                INNER JOIN sakila.rental ON rental.inventory_id = inventory.inventory_id
                WHERE store.store_id = new.store_id;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS fill_table_dimFilm;

DELIMITER //
CREATE TRIGGER fill_table_dimFilm AFTER INSERT ON film
for each row
BEGIN
    INSERT INTO sakilaOLap.dimFilm
                (
					film_id,
                    title,
                    rental_rate,
                    name_language,
                    name_category
                )
                select distinct film.film_id, title, rental_rate, language.name, category.name 
                from sakila.category
                INNER JOIN sakila.film_category ON category.category_id = film_category.category_id
                INNER JOIN sakila.film ON film_category.film_id = film.film_id
                INNER JOIN sakila.language ON film.language_id = language.language_id
                INNER JOIN sakila.inventory ON film.film_id = inventory.film_id
                INNER JOIN sakila.rental ON inventory.inventory_id = rental.inventory_id
                WHERE film.film_id = new.film_id;
END//
DELIMITER ;

