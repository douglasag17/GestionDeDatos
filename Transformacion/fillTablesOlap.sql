use sakilaOlap;

-- Dimension Time
DROP PROCEDURE IF EXISTS fill_table_dimTime;
   delimiter //
   create procedure fill_table_dimTime() 
       BEGIN
           insert into dimTime
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
               select
				rental_date,
                year(rental_date),
                day(rental_date),
                month(rental_date),
                weekofyear(rental_date),
                dayofyear(rental_date),
                hour(rental_date),
                minute(rental_date),
                second(rental_date),
                month(rental_date)/6,
                month(rental_date)/2,
                quarter(rental_date)
				from sakila.rental;
       End//
       delimiter ;
       
call fill_table_dimTime();

-- Dimension Customer
DROP PROCEDURE IF EXISTS fill_table_dimCustomer;
delimiter //
  create procedure fill_table_dimCustomer()
      BEGIN
           insert into dimCustomer
               (
				   customer_id,
                   first_name,
                   last_name,
                   email,
                   address_cus,
				   city_cus,
				   country_cus,
				   district_cus
               )
               select distinct customer.customer_id, customer.first_name, customer.last_name, customer.email, 
					city, country, district, sakila.address.address from sakila.country
               INNER JOIN sakila.city ON country.country_id = city.country_id
               INNER JOIN sakila.address ON city.city_id = address.city_id
               INNER JOIN sakila.customer ON address.address_id = customer.address_id
               INNER JOIN sakila.rental ON customer.customer_id = rental.customer_id;
       END//
   delimiter ;

call fill_table_dimCustomer();

-- Dimension Store
DROP PROCEDURE IF EXISTS fill_table_dimStore;
delimiter //
  create procedure fill_table_dimStore()
      BEGIN
            insert into dimStore	
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
                INNER JOIN sakila.rental ON rental.inventory_id = inventory.inventory_id;
       END//
   delimiter ;
       
call fill_table_dimStore();

-- Dimension Film
DROP PROCEDURE IF EXISTS fill_table_dimFilm;
delimiter //
  create procedure fill_table_dimFilm()
      BEGIN
            insert into dimFilm
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
                INNER JOIN sakila.rental ON inventory.inventory_id = rental.inventory_id;
        END//
   delimiter ;

       
call fill_table_dimFilm();

-- Hecho Rental
DROP PROCEDURE IF EXISTS fill_table_factRental;
delimiter //
  create procedure fill_table_factRental()
      BEGIN
            insert into factRental	
                (
					rental_id,
                    customer_id,
                    tiempo_id,
                    film_id,
                    store_id,
                    cantidad_rentas_dia,
                    cantidad_rentas_mes
                )
                
                ;
                
       END//
   delimiter ;
       
call fill_table_factRental();
