use shop;

select RANK() over (order by amount desc) as ranking, name, amount
from ( select CS.name, SUM(OD.price * OD.quantity) as amount
		from customer CS join order_main OM
		on CS.customer_id = OM.customer_id
		join order_detail OD
		on OM.order_id = OD.order_id
		group by CS.name) TOTAL_AMOUNT;
        
WITH TOTAL_AMOUNT as (
	select
		CS.name,
    SUM(OD.price * OD.quantity) as amount
	from
		customer CS
	join
		order_main OM on CS.customer_id = OM.customer_id
	join
		order_detail OD	on OM.order_id = OD.order_id
	group by
		CS.name
)
select RANK() over (order by amount desc) as ranking, name, amount
from TOTAL_AMOUNT;

create view total_amount as
select CS.name, SUM(OD.price * OD.quantity) as amount
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
group by CS.name;

select * from total_amount;

select RANK() over (order by amount desc) as ranking, name, amount
from total_amount;

select *
from information_schema.views
where table_schema = 'shop';
