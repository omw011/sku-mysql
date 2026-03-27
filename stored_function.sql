select sum(PM.amount)
from customer CS join payment PM
on CS.customer_id = PM.customer_id
where CS.customer_id = 1;

drop function if exists fn_amount_customer;
delimiter $$
create function fn_amount_customer(in_customer_id smallint) returns float
deterministic
begin
	declare v_total_amount float default 0;
    
    select sum(PM.amount)
    into v_total_amount
	from customer CS join payment PM
	on CS.customer_id = PM.customer_id
	where CS.customer_id = in_customer_id;
    
    return v_total_amount;
end$$
delimiter ;

select concat(first_name, ' ', last_name) as name
	, fn_amount_customer(customer_id) as total_amount
from customer
where customer_id = 2;

-- ------------------------------------------------------

select CS.customer_id, sum(OD.price * OD.quantity)
from customer CS join order_main OM
on CS.customer_id = OM.customer_id
join order_detail OD
on OM.order_id = OD.order_id
where CS.name = '홍길동'
group by CS.customer_id;

drop procedure if exists sp_customer_amount;
delimiter $$
create procedure sp_customer_amount (
	IN i_name varchar(20), OUT o_id int, OUT o_amount int
)
deterministic
begin
	select CS.customer_id, sum(OD.price * OD.quantity)
    into o_id, o_amount
	from customer CS join order_main OM
	on CS.customer_id = OM.customer_id
	join order_detail OD
	on OM.order_id = OD.order_id
	where CS.name = i_name
	group by CS.customer_id;
end$$
delimiter ;

set @id:=0;
set @amount:=0;
call sp_customer_amount('김철수', @id, @amount);
select @id, @amount;

call sp_customer_amount('하하하', @id, @amount);
select @id, @amount;

drop procedure if exists sp_customer_amount;
delimiter $$
create procedure sp_customer_amount (
	IN i_name varchar(20), OUT o_id int, OUT o_amount int
)
deterministic
begin
	declare continue handler for not found set o_id=0, o_amount=0;
	select CS.customer_id, sum(OD.price * OD.quantity)
    into o_id, o_amount
	from customer CS join order_main OM
	on CS.customer_id = OM.customer_id
	join order_detail OD
	on OM.order_id = OD.order_id
	where CS.name = i_name
	group by CS.customer_id;
end$$
delimiter ;

call sp_customer_amount('하하하', @id, @amount);
select @id, @amount;

drop procedure if exists sp_customer_amount_to_screen;
delimiter $$
create procedure sp_customer_amount_to_screen (
	IN i_name varchar(20)
)
deterministic
begin
	select CS.customer_id, sum(OD.price * OD.quantity)
	from customer CS join order_main OM
	on CS.customer_id = OM.customer_id
	join order_detail OD
	on OM.order_id = OD.order_id
	where CS.name = i_name
	group by CS.customer_id;
end$$
delimiter ;

call sp_customer_amount_to_screen('김철수');

-- ------------------------------------------------------

delimiter $$
CREATE PROCEDURE SP_GET_STORE
(
	IN p_in_title TEXT
)
DETERMINISTIC
BEGIN
		select FL.title, ST.store_id, SF.first_name, SF.last_name,
			concat(AD.address, ' ', AD.district, ' ', CT.city, ' ', CU.country) address,
			count(FL.title) cnt
		from film FL join inventory IV on FL.film_id = IV.film_id
			join store ST on IV.store_id = ST.store_id
			join staff SF on ST.store_id = SF.store_id
			join address AD on ST.address_id = AD.address_id
			join city CT on AD.city_id = CT.city_id
			join country CU on CT.country_id = CU.country_id
		where FL.title = p_in_title
		group by FL.title, ST.store_id, SF.first_name, SF.last_name, AD.address
		, AD.district, CT.city, CU.country;
END $$
delimiter ;

call SP_GET_STORE('AGENT TRUMAN');

-- ------------------------------------------------------

DROP PROCEDURE IF EXISTS SP_VARIABLES_TEST;
delimiter $$
CREATE PROCEDURE SP_VARIABLES_TEST(
	IN i_name VARCHAR(20)
    , OUT o_greeting_result VARCHAR(100)
)
DETERMINISTIC
BEGIN
	DECLARE v_greeting VARCHAR(20) DEFAULT 'Hello, ';
	IF i_name = 'kim' THEN
		SET v_greeting = CONCAT(v_greeting, i_name);
	ELSEIF i_name = 'park' THEN
    	SET v_greeting = CONCAT('Good morning, ', i_name);
	ELSE
		SET v_greeting = 'Hi!';
	END IF;
    SET o_greeting_result = v_greeting;
END $$ 
delimiter ;

set @result='';

call SP_VARIABLES_TEST('kim', @result);
select @result;

call SP_VARIABLES_TEST('park', @result);
select @result;

call SP_VARIABLES_TEST('song', @result);
select @result;

-- ------------------------------------------------------

DROP PROCEDURE IF EXISTS SP_CUSTOMER_AMOUNT_RATE;
delimiter $$
CREATE PROCEDURE SP_CUSTOMER_AMOUNT_RATE(
	IN i_name VARCHAR(20)
    , OUT o_id INT
    , OUT o_amount INT
    , OUT o_rate VARCHAR(10)
)
DETERMINISTIC
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET o_id=0, o_amount=0;
	SELECT CS.customer_id, SUM(OD.price * OD.quantity)
	INTO o_id, o_amount
	FROM customer CS JOIN order_main OM
	ON CS.customer_id = OM.customer_id
	JOIN order_detail OD
	ON OM.order_id = OD.order_id
	WHERE CS.name = i_name
	GROUP BY CS.customer_id;
	
	CASE
		WHEN o_amount > 100000 THEN SET o_rate='VIP';
		WHEN o_amount > 50000 THEN SET o_rate='GOOD';
		WHEN o_amount > 10000 THEN SET o_rate='BASIC';
		ELSE SET o_rate='WELCOME';
	END CASE;
END $$
delimiter ;

set @id=0;
set @amount=0;
set @rate='';
call SP_CUSTOMER_AMOUNT_RATE('김철수', @id, @amount, @rate);
select @id, @amount, @rate;

-- ------------------------------------------------------

DROP PROCEDURE IF EXISTS SP_ISSUE_COUPON;
delimiter $$
CREATE PROCEDURE SP_ISSUE_COUPON(
	IN i_name VARCHAR(20)
    , OUT o_id INT
    , OUT o_amount INT
    , OUT o_coupon VARCHAR(50)
)
DETERMINISTIC
BEGIN
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET o_id=0, o_amount=0;
	SELECT CS.customer_id, SUM(OD.price * OD.quantity)
	INTO o_id, o_amount
	FROM customer CS JOIN order_main OM
	ON CS.customer_id = OM.customer_id
	JOIN order_detail OD
	ON OM.order_id = OD.order_id
	WHERE CS.name = i_name
	GROUP BY CS.customer_id;
	
	CASE o_amount
		WHEN 0 THEN SET o_coupon='welcome-coupon';
		ELSE SET o_coupon='discount-coupon';
	END CASE;
END $$
delimiter ;

set @id=0;
set @amount=0;
set @coupon='';
call SP_ISSUE_COUPON('나대로', @id, @amount, @coupon);
select @id, @amount, @coupon;

-- ------------------------------------------------------

DROP FUNCTION if exists FN_CUMSUM_LOOP;
delimiter $$
CREATE FUNCTION FN_CUMSUM_LOOP(p_number smallint)
returns BIGINT
DETERMINISTIC
BEGIN
    DECLARE v_cumsum BIGINT DEFAULT 0;
    DECLARE v_number smallint;
    SET v_number = p_number;
    
	cumsum_loop : LOOP
		SET v_cumsum = v_cumsum + v_number;
		SET v_number = v_number - 1;
		IF v_number < 1 THEN
				LEAVE cumsum_loop;
		END IF;
    END LOOP;
    
    RETURN v_cumsum;
END$$
delimiter ;

select FN_CUMSUM_LOOP(100);

-- ------------------------------------------------------

DROP FUNCTION if exists FN_CUMSUM_REPEAT;
delimiter $$
CREATE FUNCTION FN_CUMSUM_REPEAT(p_number smallint)
returns BIGINT
DETERMINISTIC
BEGIN
    DECLARE v_cumsum BIGINT DEFAULT 0;
    DECLARE v_number smallint;
    SET v_number = p_number;
    
    REPEAT
		SET v_cumsum = v_cumsum + v_number;
        SET v_number = v_number - 1;
    /* UNTIL 조건이 TRUE 이면 반복문 탈출 */
    UNTIL v_number < 1
    END REPEAT;
    
    RETURN v_cumsum;
END$$
delimiter ;

select FN_CUMSUM_REPEAT(100);

-- ------------------------------------------------------

DROP FUNCTION if exists FN_CUMSUM_WHILE;
delimiter $$
CREATE FUNCTION FN_CUMSUM_WHILE(p_number smallint)
returns BIGINT
DETERMINISTIC
BEGIN
    DECLARE v_cumsum BIGINT DEFAULT 0;
    DECLARE v_number smallint;
    SET v_number = p_number;
    
    WHILE v_number > 0 DO
		SET v_cumsum = v_cumsum + v_number;
        SET v_number = v_number - 1;
    END WHILE;
    
    RETURN v_cumsum;
END$$
delimiter ;

select FN_CUMSUM_WHILE(100);

-- ------------------------------------------------------

DROP PROCEDURE if exists sp_avg_rate;
delimiter $$
CREATE PROCEDURE sp_avg_rate(
	IN i_rating TINYTEXT
    , OUT o_count SMALLINT
    , OUT o_avg_rate FLOAT
)
DETERMINISTIC
BEGIN
	/* rental_rate을 누적하기 위한 변수 */
    DECLARE v_total_rate FLOAT DEFAULT 0.0;
    /* count를 누적하기 위한 변수 */
    DECLARE v_count INT DEFAULT 0;
    /* 커서에 더 읽어야 할 레코드가 남아 있는지 여부를 위한 플래그 변수 */
    DECLARE v_no_more_data TINYINT DEFAULT 0;
    /* film의 rental_rate을 임시로 담아 둘 변수 */
    DECLARE v_tmp_rate FLOAT;
	/* film의 rental_duration을 임시로 담아 둘 변수 */
    DECLARE v_tmp_duration TINYINT;
    
    /* 커서 정의 */
    DECLARE v_film_list CURSOR FOR
		SELECT rental_duration, rental_rate
        FROM film
        WHERE rating=i_rating;
        
	/*  커서로부터 더 읽을 데이터가 있는지를 나타내는 플래그 변경을 위한 핸들러 */
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_more_data = 1;
    
    /* 정의된 v_film_list 커서 오픈 */
    OPEN v_film_list;
    REPEAT
		/* 커서로부터 레코드를 한 개씩 읽어서 변수에 저장 */
		FETCH v_film_list
		INTO v_tmp_duration, v_tmp_rate;
		IF v_tmp_duration > 4 THEN
			SET v_total_rate = v_total_rate + v_tmp_rate;
			SET v_count = v_count + 1;
		END IF;
		UNTIL v_no_more_data
	END REPEAT;
    /* 커서를 닫고 관련 자원을 반납 */
    CLOSE v_film_list;
    
    SET o_count = v_count;
    IF v_count = 0 THEN
		SET o_avg_rate = 0.0;
	ELSE
		SET o_avg_rate = v_total_rate / v_count;
	END IF;
END$$
delimiter ;

set @rating:='pg';
set @count:=0;
set @rate:=0.0;
call sp_avg_rate(@rating, @count, @rate);
select @rating, @count, round(@rate, 2);
