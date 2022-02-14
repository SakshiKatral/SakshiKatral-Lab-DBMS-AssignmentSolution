create database Ecommerce;
use Ecommerce;

create table Supplier(
Supp_ID int primary key,
Supp_Name varchar(25),
Supp_City varchar(15),
Supp_Phone long
);

create table Customer(
Cus_ID int primary key,
Cus_Name varchar(25),
Cus_Phone long,
Cus_City varchar(20),
Cus_Gender varchar(10)
);

create table Category(
Cat_ID int Primary key,
Cat_Name varchar(20)
);

create table Product(
Pro_ID int Primary key,
Pro_Name varchar(20),
Pro_Desc varchar(50),
Cat_ID int, 
FOREIGN KEY(Cat_ID) REFERENCES Category(Cat_ID)
);

create table ProductDetails(
Prod_ID int Primary key,
Pro_ID int,
Supp_ID int,
Price double,
FOREIGN KEY (Pro_ID) REFERENCES Product(Pro_ID), 
FOREIGN KEY (Supp_ID) REFERENCES Supplier(Supp_ID)
);

create table Orders(
Ord_ID int Primary key,
Ord_Amount double,
Ord_Date Date,
Cus_ID int, 
Prod_ID int,
FOREIGN KEY (Cus_ID) REFERENCES Customer(Cus_ID), 
FOREIGN KEY (Prod_ID) REFERENCES ProductDetails(Prod_ID)
);

create table Rating(
Rat_ID int Primary key,
Cus_ID int,
Supp_ID int,
Rat_Ratstars int,
FOREIGN KEY (Cus_ID) REFERENCES Customer(Cus_ID),
FOREIGN KEY (Supp_ID) REFERENCES Supplier(Supp_ID));

show tables;

insert into supplier values(1, "Rajesh Retails", "Delhi", 1234567890);
insert into supplier values(2, "Appario Ltd.", "Mumbai", 2589631470);
insert into supplier values(3, "Knome products", "Banglore", 9785462315);
insert into supplier values(4, "Bansal Retails", "Kochi", 8975463285);
insert into supplier values(5, "Mittal Ltd.", "Lucknow", 7898456532);

insert into Customer values(1, "Aakash",9999999999, "Delhi", "M");
insert into Customer values(2, "Aman",9785463215, "Noida", "M");
insert into Customer values(3, "Neha",9999999999, "Mumbai", "F");
insert into Customer values(4, "Megha",9994562399, "Kolkatt", "F");
insert into Customer values(5, "Pulkit",7895999999, "Lucknow", "M");

insert into Category values(1, "Books");
insert into Category values(2, "Game");
insert into Category values(3, "Groceries");
insert into Category values(4, "Electronics");
insert into Category values(5, "Clothes");

insert into Product values(1, "GTA V", "DFJDJFDJFDJFDJFJF", 2);
insert into Product values(2, "TSHIRT", "DFDFJDFJDKFD", 5);
insert into Product values(3, "ROG LAPTOP", "DFNTTNTNTERND", 4);
insert into Product values(4, "OATS ", "REURENTBTOTH", 3);
insert into Product values(5, "HARRY POTTER", "NBEMCTHTJTH", 1);

insert into Productdetails values(1, 1, 2, 1500);
insert into Productdetails values(2, 3, 5, 30000);
insert into Productdetails values(3, 5, 1, 3000);
insert into Productdetails values(4, 2, 3, 2500);
insert into Productdetails values(5, 4, 1, 100);

insert into Orders values(20, 1500, '2021-10-12', 3, 5);
insert into Orders values(25, 30500, '2021-09-16', 5, 2);
insert into Orders values(26, 2000, '2021-10-05', 1, 1);
insert into Orders values(30, 3500, '2021-08-16', 4, 3);
insert into Orders values(50, 2000, '2021-10-06', 2, 1);

insert into  Rating values(1, 2, 2, 4);
insert into  Rating values(2, 3, 4, 3);
insert into  Rating values(3, 5, 1, 5);
insert into  Rating values(4, 1, 3, 2);
insert into  Rating values(5, 4, 5, 4);


select cus_gender, count(*) as count 
from customer  as c inner join orders as o 
on c.cus_id = o.cus_id 
where o.ord_amount >= 3000 
group by (c.cus_gender);

select o.*, p.pro_name 
from orders o, product p, productdetails pd 
where o.cus_id = 2 
and pd.prod_id = o.prod_id 
and pd.pro_id= p.pro_id;

select s.* 
from supplier s, productdetails pd 
where s.supp_id 
in 
(select pd.supp_id 
from productdetails pd 
group by pd.supp_id 
having count(pd.pro_id)>1) 
group by s.supp_id;

select c.* 
from category c, productdetails pd, product p, orders o
where pd.prod_id = o.prod_id 
and pd.pro_id = p.pro_id
and p.cat_id = c.cat_id
having min(o.ord_amount);

select p.pro_id, p.pro_name 
from product p, orders o,productdetails pd
where o.prod_id = pd.prod_id 
and pd.pro_id = p.pro_id
and o.ord_date > '2021-10-05';

select c.cus_name, c.cus_gender 
from customer c
where upper(c.cus_name)
like '%A'
or upper(c.cus_name) like 'A%';

DELIMITER &&
create procedure myproc()
begin
select * from  (select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
case
when rating.rat_ratstars > 4 then 'Genuine Supplier' 
when rating.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict 
from rating 
inner join supplier
on supplier.supp_id = rating.supp_id) as s
ORDER BY supplier.supp_id asc;
end&&
DELIMITER ;

call myproc();