/*Homework*/

create database SalesAndProd;
use SalesAndProd;

Create table If Not Exists Sales (
saleid int, 
productid int, 
serid int, 
quantity int);
Create table If Not Exists Product (
productid int, 
price int);


insert into Sales (saleid, productid, serid, quantity) values ('1', '1', '101', '10');
insert into Sales (saleid, productid, serid, quantity) values ('2', '2', '101', '1');
insert into Sales (saleid, productid, serid, quantity) values ('3', '3', '102', '3');
insert into Sales (saleid, productid, serid, quantity) values ('4', '3', '102', '2');
insert into Sales (saleid, productid, serid, quantity) values ('5', '2', '103', '3');


insert into Product (productid, price) values ('1', '10');
insert into Product (productid, price) values ('2', '25');
insert into Product (productid, price) values ('3', '15');

select * from Sales;
select * from Product;

/*Задание 1. Вывести данные о том, какой пользователь userid сколько потратил в общем*/

/*Сколько потратил на определенный продукт каждый из покупателей - TOTAL_PRICE*/
select t1.saleid, t1.productid, t1.serid, t1.quantity, t2.price, (t1.quantity*t2.price) TOTAL_PRICE
from Sales t1
left join Product t2
on t1.productid = t2.productid;

/*Теперь нам нужно сгруппировать полученные результаты для каждого покупателя без лишних полей*/

select t1.serid, sum(t1.quantity*t2.price) TOTAL_PRICE
from Sales t1
left join Product t2
on t1.productid = t2.productid
group by t1.serid;

/*Задание 2. Найти среднюю цену продаж для каждого product_id*/

Create table If Not Exists Prices (
productid int, 
startdate date, 
enddate date, 
price int);
Create table If Not Exists UnitsSold (productid int, 
purchase_date date, 
units int);


insert into Prices (productid, startdate, enddate, price) values ('1', '2019-02-17', '2019-02-28', '5');
insert into Prices (productid, startdate, enddate, price) values ('1', '2019-03-01', '2019-03-22', '20');
insert into Prices (productid, startdate, enddate, price) values ('2', '2019-02-01', '2019-02-20', '15');
insert into Prices (productid, startdate, enddate, price) values ('2', '2019-02-21', '2019-03-31', '30');


insert into UnitsSold (productid, purchase_date, units) values ('1', '2019-02-25', '100');
insert into UnitsSold (productid, purchase_date, units) values ('1', '2019-03-01', '15');
insert into UnitsSold (productid, purchase_date, units) values ('2', '2019-02-10', '200');
insert into UnitsSold (productid, purchase_date, units) values ('2', '2019-03-22', '30');

select * from Prices;
select * from UnitsSold;

/*средняя цена для каждого продукта, в теории, это просто усредненная по времени, без учетаalter
количества проданных единиц*/
select productid, avg(price)
from Prices
group by productid;

/*Если мы говорим о среднем доходе или средней цене на 1 единицу товара, то он будет зависеть уже от числа проданных товаров в определенный период*/
/*Сортируем по дате, чтобы она попала в пределы с установленной ценой*/
select t2.productid, t1.purchase_date, t1.units, t2.startdate, t2.enddate, t2.price
from UnitsSold t1
left join Prices t2
on t1.productid = t2.productid 
where t1.purchase_date between t2.startdate and t2.enddate;

/*Определяем общую сумму за все проданные предметы*/

select t2.productid, sum(t1.units * t2.price) as Sum_of_profit
from UnitsSold t1
left join Prices t2
on t1.productid = t2.productid 
where t1.purchase_date between t2.startdate and t2.enddate
group by t2.productid;

/*Определяем общее число проданных единиц*/
select t2.productid, sum(t1.units) as Units
from UnitsSold t1
left join Prices t2
on t1.productid = t2.productid 
where t1.purchase_date between t2.startdate and t2.enddate
group by t2.productid;

/*И находим среднее с использованием подзапросов*/
Select t3.productid, (t3.Sum_of_profit/t4.Units) as average_price
from (select 
	t2.productid, sum(t1.units * t2.price) as Sum_of_profit
	from UnitsSold t1
	left join Prices t2
	on t1.productid = t2.productid 
	where t1.purchase_date between t2.startdate and t2.enddate
	group by t2.productid) t3
inner join (
	select t6.productid, sum(t5.units) as Units
	from UnitsSold t5
	left join Prices t6
	on t5.productid = t6.productid 
	where t5.purchase_date between t6.startdate and t6.enddate
	group by t6.productid) t4
on t3.productid = t4.productid;

/*Задание 3. Дано автобусы и пассажиры, определить количество пассажиров уезжающих в каждом автобусе.*/

Create table If Not Exists Buses (
busid int, 
arrivaltime int);
Create table If Not Exists Passengers (
passengerid int, 
arrivaltime int);


insert into Buses (busid, arrivaltime) values ('1', '2');
insert into Buses (busid, arrivaltime) values ('2', '4');
insert into Buses (busid, arrivaltime) values ('3', '7');


insert into Passengers (passengerid, arrivaltime) values ('11', '1');
insert into Passengers (passengerid, arrivaltime) values ('12', '5');
insert into Passengers (passengerid, arrivaltime) values ('13', '6');
insert into Passengers (passengerid, arrivaltime) values ('14', '7');

select * from Buses;
select * from Passengers;

/*Выбираем пассажира с его прибытием, а также всю выборку автобусов, на которых он может уехать*/
Select t1.passengerid,t1.arrivaltime as passenger_arrival, t2.arrivaltime as bus_arrival
from Passengers t1
left join Buses t2
on t1.arrivaltime <= t2.arrivaltime;

/*А теперь остается из всех вариантов выбрать самый близкий вариант автобуса к моменту прибытия пассажира, 
чтобы он ждал как можно меньше*/
Select t1.passengerid, min(t2.arrivaltime) as time_of_departure
from Passengers t1
left join Buses t2
on t1.arrivaltime <= t2.arrivaltime
group by t1.passengerid;

/*И каким автобусом уехали эти пассажиры*/
Select t4.passengerid, t3.busid
from Buses t3
right join (
	Select t1.passengerid, min(t2.arrivaltime) as time_of_departure
	from Passengers t1
	left join Buses t2
	on t1.arrivaltime <= t2.arrivaltime
	group by t1.passengerid) t4
on t3.arrivaltime = t4.time_of_departure;