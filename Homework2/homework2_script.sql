create database shop;

create table goods(
id int auto_increment unique not null,
title varchar (100),
quantity int check (quantity between 0 and 10)
);

insert into goods ( title, quantity) values( 'велосипед', 4);
insert into goods ( title, quantity) values( 'лыжи',  5);
insert into goods ( title, quantity) values( 'коньки',  7);
insert into goods ( title, quantity) values( 'скейт', 2);

alter table goods
add price int default 0;

select * from goods;

alter table goods
modify column price numeric(8,2);

set sql_safe_updates = 0;

update goods
set price = 4.6 
where title like 'велосипед';

update goods
set price = 5.3
where title like 'лыжи';

update goods
set price = 2.3
where title like 'коньки';

update goods
set price = 5.3
where title like 'скейт';

select * from goods;

alter table goods
modify column price int;

select * from goods;

alter table goods
change price item_price int;

alter table goods
drop item_price;

create view v_goods as
select * from goods
where quantity < 5;

select * from v_goods;

/*
Из работы на уроке
*/

use university;

create table if not exists bachelors (
f_name varchar(255) not null,
surname varchar(255) not null,
avg_rate int check(avg_rate between 0 and 5),
gender varchar(100) check (gender in ("M", "F"))
);

select * from bachelors;



insert into bachelors values ('first', 'one', 4, "M");
insert into bachelors values ('second', 'two', 3, "M");
insert into bachelors values ('third', 'three', 4, "F");
insert into bachelors values ('fourth', 'four', 3, "M");
insert into bachelors values ('fifth', 'five', 2, "F");

alter table bachelors
add id int primary key auto_increment;


alter table bachelors
modify column gender varchar(1);

alter table bachelors
change f_name first_name varchar(255);

select * from bachelors
where avg_rate >= 4;

select * from bachelors
where avg_rate = 2 or avg_rate = 3;

select * from bachelors
where gender = "F";

select * from bachelors
where avg_rate in (2,3,4);

create view v_new_bachelors as
select * from bachelors
where gender = "F";

select * from v_new_bachelors;

select distinct avg_rate from bachelors;

update bachelors
set avg_rate = avg_rate - 1;

