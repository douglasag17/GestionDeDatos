use sakila;

DROP TABLE IF EXISTS sakila.dimTimeQuiz;
CREATE TABLE sakila.dimTimeQuiz (
	time_id int PRIMARY KEY AUTO_INCREMENT,
	año int,
    mes int,
	dia int
);

DROP TABLE IF EXISTS sakila.factPayment;
CREATE TABLE sakila.factPayment (
	time_id int,
    pagos_dia int,
	foreign key(time_id) references dimTimeQuiz(time_id)
);
