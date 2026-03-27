use sakila;

select CS.customer_id 고객ID, sum(PM.amount) 금액
from customer CS join payment PM
on CS.customer_id = PM.customer_id
group by CS.customer_id;

-- select customer_id, sum(amount)
-- from payment
-- group by customer_id;

-- ---------------------------------------------

select concat(CS.first_name, ' ', CS.last_name) 이름, sum(PM.amount) 금액
from customer CS join payment PM
on CS.customer_id = PM.customer_id
group by 이름;

-- ---------------------------------------------

select customer_id, count(rental_id)
from rental
group by customer_id
order by count(rental_id) desc;

-- ---------------------------------------------

select concat(CS.first_name, ' ', CS.last_name) 이름, count(RT.rental_id)
from customer CS join rental RT
on CS.customer_id = RT.customer_id
group by 이름
order by count(RT.rental_id) desc;

-- ---------------------------------------------

select FL.film_id, FL.title, FL.description, CG.name, FL.release_year, LG.name
from film FL join film_category FC
on FL.film_id = FC.film_id
join category CG
on FC.category_id = CG.category_id
join language LG
on FL.language_id = LG.language_id
where CG.name = 'action';

-- ---------------------------------------------

select AT.actor_id, AT.first_name, AT.last_name, count(FA.film_id) 작품수
from actor AT join film_actor FA
on AT.actor_id = FA.actor_id
group by AT.actor_id, AT.first_name, AT.last_name
order by 작품수 desc;

-- ---------------------------------------------

select AT.first_name, AT.last_name, count(FA.film_id) 작품수
from actor AT join film_actor FA
on AT.actor_id = FA.actor_id
group by AT.first_name, AT.last_name
order by 작품수 desc;

-- ---------------------------------------------

select count(distinct concat(first_name, ' ', last_name)) from actor;

select concat(first_name, ' ', last_name) 동명이인, count(*) cnt
from actor
group by 동명이인
having count(동명이인) >= 2;

-- ---------------------------------------------

select AT.first_name, AT.last_name, FL.title, FL.release_year, FL.rental_rate
from film FL join film_actor FA
on FL.film_id = FA.film_id
join actor AT
on FA.actor_id = AT.actor_id
where AT.first_name = 'MARY' and AT.last_name = 'KEITEL'
order by FL.title;

-- ---------------------------------------------

select AT.actor_id, AT.first_name, AT.last_name, count(FL.rating) 'R등급 작품수'
from film FL join film_actor FA
on FL.film_id = FA.film_id
join actor AT
on FA.actor_id = AT.actor_id
where FL.rating = 'R'
group by AT.actor_id, AT.first_name, AT.last_name
order by count(FL.rating) desc;

-- ---------------------------------------------

select AT.first_name, AT.last_name, FL.title, FL.release_year
from film FL join film_actor FA
on FL.film_id = FA.film_id
join actor AT
on FA.actor_id = AT.actor_id
where FA.actor_id not in (select FA.actor_id
						from film FL join film_actor FA
						on FL.film_id = FA.film_id
                        where FL.rating ='R'
                        group by FA.actor_id
						order by FA.actor_id)
order by FL.title;

select FA.actor_id
from film FL join film_actor FA
on FL.film_id = FA.film_id
where FL.rating ='R'
group by FA.actor_id
order by FA.actor_id;

select actor_id
from actor
where first_name = 'JANE' and last_name = 'JACKMAN';

-- ---------------------------------------------

select FL.title, ST.store_id, SF.first_name, SF.last_name, AD.address, AD.district, CT.city, CN.country, count(FL.title)
from film FL join inventory IV on FL.film_id = IV.film_id
join store ST on IV.store_id = ST.store_id
join staff SF on ST.manager_staff_id = SF.staff_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CN on CT.country_id = CN.country_id
where FL.title = 'AGENT TRUMAN'
group by FL.title, ST.store_id, SF.first_name, SF.last_name, AD.address, AD.district, CT.city, CN.country;

-- ---------------------------------------------

select FL.title, ST.store_id, IV.inventory_id, AD.address, AD.district, CT.city, CN.country, RT.rental_date, RT.return_date, CS.first_name, CS.last_name
from film FL join inventory IV on FL.film_id = IV.film_id
join store ST on IV.store_id = ST.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CN on CT.country_id = CN.country_id
join rental RT on IV.inventory_id = RT.inventory_id
join customer CS on RT.customer_id = CS.customer_id
where FL.title = 'ALI FOREVER';

-- ---------------------------------------------

select FL.title, sum(rental_info.rental_cnt)
from inventory IV join (select inventory_id, count(rental_id) rental_cnt
						from rental
                        group by inventory_id) rental_info
on IV.inventory_id = rental_info.inventory_id
join film FL on IV.film_id = FL.film_id
group by FL.title
order by sum(rental_info.rental_cnt) desc;

-- ---------------------------------------------

select CS.customer_id, CS.first_name, CS.last_name, sum(PM.amount), AD.address, AD.district, CT.city, CN.country
from customer CS join payment PM on CS.customer_id = PM.customer_id
join address AD on CS.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CN on CT.country_id = CN.country_id
group by CS.customer_id, CS.first_name, CS.last_name, AD.address, AD.district, CT.city, CN.country
order by sum(PM.amount) desc;

-- ---------------------------------------------

select CS.customer_id, CS.first_name, CS.last_name, sum(PM.amount), case when (sum(PM.amount) >= 200) then 'A'
																		when (sum(PM.amount) >= 100 and sum(PM.amount) < 200) then 'B'
																		else 'C'
																		end 등급
from customer CS join payment PM on CS.customer_id = PM.customer_id
group by CS.customer_id, CS.first_name, CS.last_name
order by sum(PM.amount) desc;

-- ---------------------------------------------

select FL.title, IV.inventory_id, IV.store_id, CS.first_name, CS.last_name, RT.rental_date
from film FL join inventory IV on FL.film_id = IV.film_id
join rental RT on IV.inventory_id = RT.inventory_id
join customer CS on RT.customer_id = CS.customer_id
where RT.return_date is null;

-- ---------------------------------------------

select RT.rental_date, FL.title, IV.inventory_id, ST.store_id, concat(AD.address, ' ', CN.country, ' ', CT.city, ' ', AD.district)
from rental RT join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on FL.film_id = IV.film_id
join store ST on ST.store_id = IV.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CN on CT.country_id = CN.country_id
where rental_date between '2005-08-01' and '2005-08-15'
and CN.country = 'Canada' and AD.district = 'Alberta';

-- ---------------------------------------------

select CT.city, count(FL.title)
from film FL join film_category FC on FL.film_id = FC.film_id
join category CG on CG.category_id = FC.category_id
join inventory IV on FL.film_id = IV.film_id
join rental RT on RT.inventory_id = IV.inventory_id
join customer CS on RT.customer_id = CS.customer_id
join address AD on CS.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CN on CT.country_id = CN.country_id
where CG.name = 'Horror'
group by CT.city
order by count(FL.title) desc, CT.city;

-- ---------------------------------------------

select ST.store_id, sum(PM.amount) '총 대여금액'
from store ST join inventory IV on ST.store_id = IV.store_id
join rental RT on RT.inventory_id = IV.inventory_id
join payment PM on PM.rental_id = RT.rental_id
group by ST.store_id;

-- ---------------------------------------------

select FL.title, IV.inventory_id, RT.rental_date '대여일', RT.return_date '반납일', FL.rental_duration, ifnull(datediff(RT.return_date, RT.rental_date), 'Unknown') '실 대여기간'
from film FL join inventory IV on FL.film_id = IV.film_id
join rental RT on RT.inventory_id = IV.inventory_id
where datediff(ifnull(RT.return_date, curdate()), RT.rental_date) > FL.rental_duration;

-- ---------------------------------------------

select CS.first_name, CS.last_name, count(RT.rental_id)'연체건수'
from rental RT join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on IV.film_id = FL.film_id
join customer CS on RT.customer_id = CS.customer_id
where datediff(ifnull(RT.return_date, curdate()), RT.rental_date) > FL.rental_duration
group by CS.first_name, CS.last_name
order by count(RT.rental_id) desc;

-- ---------------------------------------------

select concat(CS.first_name, ' ', CS.last_name) as name, FL.title, top5.tot_cnt
from (select customer_id, count(rental_id) as tot_cnt
		from rental
        group by customer_id
        order by count(rental_id) desc
        limit 5) as top5 join rental RT on top5.customer_id = RT.customer_id
join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on IV.film_id = FL.film_id
join customer CS on top5.customer_id = CS.customer_id
order by top5.tot_cnt desc, name, FL.title;

-- ---------------------------------------------

select id, famous_actor.f_name, famous_actor.l_name, FL.title, FL.release_year
from (select AC.actor_id as id, AC.first_name as f_name, AC.last_name as l_name,
		count(film_id) as cnt
        from actor AC join film_actor FA on AC.actor_id = FA.actor_id
        group by id, f_name, l_name
        having cnt > (select count(film_id)
					from actor AC join film_actor FA on AC.actor_id = FA.actor_id
                    where AC.first_name = 'WALTER'
                    and AC.last_name = 'TORN')) as famous_actor
join film_actor FA on famous_actor.id = FA.actor_id
join film FL on FA.film_id = FL.film_id
order by id, FL.title, FL.release_year;