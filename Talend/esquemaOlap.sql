use sakila;

DROP TABLE IF EXISTS sakila.dimTime;
CREATE TABLE sakila.dimTime (
	tiempo_id int PRIMARY KEY AUTO_INCREMENT,
	fecha DATETIME,
	año int,
	dia int,
	mes int,
	semana_del_año int,
	dia_del_años int,
	hora int,
	minuto int,
	segundo int,
	semestre int,
	bimestre int,
	trimestre int
);

DROP TABLE IF EXISTS sakila.dimCustomer;
CREATE TABLE sakila.dimCustomer  (
	customer_id int PRIMARY KEY,
	first_name varchar(45),
	last_name varchar(45),
	email varchar(50),
	address_cus varchar(50),
	city_cus varchar(50),
	country_cus varchar(50),
	district_cus varchar(50)
);

DROP TABLE IF EXISTS sakila.dimFilm;
CREATE TABLE sakila.dimFilm (
	film_id int primary key,
    title varchar(255),
    rental_rate decimal(4,2),
    name_language char(20),
    name_category varchar(25)
);

DROP TABLE IF EXISTS sakila.dimStore;
CREATE TABLE sakila.dimStore (
	store_id int primary key,
    city_store varchar(50),
    country_store varchar(50),
    district_store varchar(20),
    address_store varchar(50)
);

DROP TABLE IF EXISTS sakila.factRental;
CREATE TABLE sakila.factRental (
	rental_id int not null AUTO_INCREMENT,
    customer_id int,
	tiempo_id int,
	film_id int,
    store_id int,
    cantidad_rentas_dia int,
    cantidad_rentas_mes int,
    primary key (rental_id),
	foreign key(tiempo_id) references dimTime(tiempo_id),
	foreign key(customer_id)references dimCustomer(customer_id),
	foreign key(film_id) references dimFilm(film_id),
    foreign key(store_id) references dimStore(store_id)
);
