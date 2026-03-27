use shop;

select * from customer;
select customer_id, name, addr from customer;

select distinct addr from customer;

desc order_detail;
select price as 단가, quantity as 수량, price * quantity as "총  금액"
from order_detail;

select name, phone from customer where addr = '서울';
select name, phone from customer where addr <> '서울';
select name, phone from customer where addr != '서울';

select product_id, price from order_detail where price <= 1000;

select name, phone, addr from customer where addr in ('서울', '경기');

select name, phone, reg_date from customer
where reg_date between '2018-01-01' and '2018-12-31';

select name, addr from customer where name like '김%';
select name, supplier from product where name like '%파_';

select * from product;

select name, supplier from product where dis_rate is null;
select name, supplier from product where dis_rate is not null;

select name, addr, reg_date from customer
where reg_date >= '2018-01-01' and reg_date <= '2018-12-31';

select name, phone, addr from customer
where addr = '서울' or addr = '경기';

select name, phone, addr from customer
where not (addr = '서울' or addr = '경기');

select name, reg_date from customer order by reg_date;
select name, reg_date from customer order by reg_date desc;
select name, reg_date from customer order by 2;

select name, reg_date 등록일 from customer order by 등록일;

select * from order_detail limit 10;
desc customer;
-- ---------------------------------------------------------
select price * -1,  ABS(price) from product;

select price / 7, ROUND(price / 7) from product;
select price / 7, ROUND(price / 7, 1) from product;

select price, MOD(price, 7) from product;

select price / 7, CEILING(price / 7) from product;
select price / 7, FLOOR(price / 7) from product;

select price / 7, TRUNCATE(price / 7, 0) from product;
select price / 7, TRUNCATE(price / 7, 1) from product;
select price / 7, TRUNCATE(price / 7, -1) from product;

select price, POW(price, 2) from product;

select GREATEST(1, 2, 3);
select LEAST(1, 2, 3);
select INTERVAL(21, 1, 10, 20, 30, 100);


-- INTERVAL(N,N1,N2,N3,...)
-- It returns 0 if 1st number is less than the 2nd number and 1 if 1st number is less than the 3rd number 
-- and so on or -1 if 1st number is NULL

select CONCAT(name, '-', supplier) from product;
select REPLACE(phone, '010',  '+82-010') from customer;
select REVERSE(name) from product;
select RIGHT(name, 2) from product;
select name, SUBSTRING(name, 2, 2) from product;
select TRIM('   cafe beverage   ');
select RTRIM('   cafe beverage   ');
select LTRIM('   cafe beverage   ');

select NOW();
select CURDATE();
select CURTIME();
select MAKEDATE(2024, 100); -- // 2024년 100번째 날
select DATE_ADD(CURDATE(), INTERVAL 1 WEEK);
select DATE_SUB(CURDATE(), INTERVAL 1 WEEK);
select DATE_FORMAT(CURDATE(), '%m');
select DATEDIFF(CURDATE(), '1975-03-28');
select TRUNCATE(DATEDIFF(CURDATE(), '2002-04-04') / 365, 0) as 나이;

select name, ifnull(dis_rate, 0) from product;
select name, ifnull(dis_rate, 0), if(dis_rate is not null, '세일 중', '정가 판매 중') from product;

select name, price, case when price < 1000 then 'A'
						when price < 1500 then 'B'
                        else 'C'
                        end 가격등급
from product;

select name, price, case price when 500  then 'A'
					when 800 then 'B'
                    when 1000 then 'C'
                    when 1500 then 'D'
                    else 'E'
                    end 가격등급
from product;

select * from customer;
select * from order_main;
select * from customer cross join order_main;

select CS.name, OM.order_date
from customer CS inner join order_main OM
on CS.customer_id =  OM.customer_id
where CS.name = '홍길동';

select CS.name, OM.order_date, PD.name, OD.price, OD.quantity
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
join product PD
on OD.product_id = PD.product_id
where CS.name = '홍길동';

select CS.name, OM.order_date, PD.name, OD.price, OD.quantity
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
join product PD
on OD.product_id = PD.product_id
where OD.price < 1000;

select CS.name, ifnull(OM.order_date, 'N/A') 구매일자
from customer CS left outer join order_main OM
on CS.customer_id = OM.customer_id;

select count(product_id) from product;
select count(dis_rate) from product;
select count(*) from product;

select count(distinct price) from product;

select AVG(price) from product;
select ROUND(AVG(price), 1) from product;

select supplier, ROUND(AVG(price), 1)
from product
group by supplier;

select CS.name, OM.order_date, sum(OD.price * OD.quantity) 구매금액
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
group by CS.name, OM.order_date
order by 구매금액 desc;

select CS.name, ROUND(avg(OD.price * OD.quantity), 1) 평균금액
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
group by CS.name
order by 평균금액 desc;

select CS.name, OM.order_date, sum(OD.price * OD.quantity) 구매금액
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
group by CS.name, OM.order_date
having 구매금액 >= 10000
order by 구매금액 desc;

select supplier, max(price) 최고가
from product
group by supplier
having max(price) > 1000;

select CS.name 고객명, count(OM.order_id) 구매수
from customer CS left outer join order_main OM
on CS.customer_id = OM.customer_id
group by CS.name;

select price from product where name = '콘칲';

select name, price
from product
where price > (select price from product where name = '콘칲');

select name, price
from product
where price = (select min(price) from product);

select name, price
from product
where price < (select avg(price) from product);

select supplier, max(price)
from product
group by supplier;

select name, price, supplier
from product
where (supplier, price) in (select supplier, max(price)
							from product
							group by supplier);
                            
select name, price, supplier
from product
where (supplier, price) = any (select supplier, max(price)
							from product
							group by supplier);
                            
select PD.name, PD.price, PD.supplier
from product PD join (select supplier, MAX(price) as MAX_PRICE
						from product
                        group by supplier) MP
on PD.supplier = MP.supplier and PD.price = MP.MAX_PRICE;

select PD.name, PD.price, PD.supplier
from product PD
where PD.price > (select AVG(price) from product where supplier = PD.supplier);

select PD.name, PD.price, PD.supplier
from product PD
where PD.price = (select max(price) from product where supplier = PD.supplier);

select name, price, ROW_NUMBER() over (order by price desc) as ranking
from product;

select supplier, name, price,
ROW_NUMBER() over (partition by supplier order by price desc) as ranking
from product;

select name, price, RANK() over (order by price desc) as ranking
from product;

select supplier, name, price,
RANK() over (partition by supplier order by price desc) as ranking
from product;

select name, price, DENSE_RANK() over (order by price desc) as ranking
from product;

select supplier, name, price,
DENSE_RANK() over (partition by supplier order by price desc) as ranking
from product;

select CS.name, sum(OD.price * OD.quantity) amount,
RANK() over (order by sum(OD.price * OD.quantity) desc) as ranking
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
group by CS.name;

select RANK() over (order by amount desc) as ranking, name, amount
from (select CS.name, sum(OD.price * OD.quantity) as amount
		from customer CS join order_main OM
		on CS.customer_id = OM.customer_id
		join order_detail OD
		on OM.order_id = OD.order_id
		group by CS.name) TOTAL_AMOUNT;
        
-- FIRST_VALUE(), LAST_VALUE(), NTH_VALUE()
select OD.order_detail_id, PD.name, OD.price, OD.quantity,
		FIRST_VALUE(PD.name) over w as 'first',
        LAST_VALUE(PD.name) over w as 'last',
        NTH_VALUE(PD.name, 4) over w as '4th'
from order_detail OD join product PD
on OD.product_id = PD.product_id
window w as (order by order_detail_id);

select PD.name, PD.price, PD.supplier
from product PD join (select supplier, MAX(price) as MAX_PRICE
						from product group by supplier) MP
on PD.supplier = MP.supplier
where price = MP.MAX_PRICE;

with MAX_CTE as (
	select
		supplier,
        MAX(price) as MAX_PRICE
	from
		product
	group by
		supplier
)
select PD.name, PD.price, PD.supplier
from product PD join MAX_CTE MP
on PD.supplier = MP.supplier and price = MP.MAX_PRICE;

select RANK() over (order by amount desc) as ranking, name, amount
from (select CS.name, sum(OD.price * OD.quantity) as amount
		from customer CS join order_main OM
		on CS.customer_id = OM.customer_id
		join order_detail OD
		on OM.order_id = OD.order_id
		group by CS.name) TOTAL_AMOUNT;
        
with TOTAL_AMOUNT as (
	select
		CS.name,
		sum(OD.price * OD.quantity) as amount
	from
		customer CS join order_main OM
        on CS.customer_id = OM.customer_id
        join order_detail OD
        on OM.order_id = OD.order_id
	group by
		CS.name
)
select RANK() over (order by amount desc) as ranking, name, amount
from TOTAL_AMOUNT;

