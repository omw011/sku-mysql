use shop;


create user omw@localhost identified by '1234';
grant all privileges on shop.* to omw@localhost;
grant all privileges on sakila.* to omw@localhost;

create database book_db default character set utf8mb4;
grant all privileges on book_db.* to omw@localhost;

show variables like '%log_bin_trust_function%';
set global log_bin_trust_function_creators = 1;

grant all privileges on employees.* to omw@localhost;

create database index_db default character set utf8mb4;
grant all privileges on index_db.* to omw@localhost;

create database board_react default character set utf8mb4;
grant all privileges on board_react.* to omw@localhost;

create database board_jpa default character set utf8mb4;
grant all privileges on board_jpa.* to omw@localhost;