start transaction;

update product set dis_rate = 0.2
where supplier ='롯데';

select * from product where supplier = '롯데';

rollback;

-- ----------------------------------------------

start transaction;

update product set dis_rate = 0.2
where supplier ='롯데';

select * from product where supplier = '롯데';

commit;

-- ----------------------------------------------

show variables where variable_name = 'autocommit';

set autocommit = 0;

select * from product where supplier = '롯데';

update product set dis_rate = 0.1
where supplier ='롯데';

rollback;

-- ----------------------------------------------

update product set dis_rate = 0.1
where supplier ='롯데';

select * from product where supplier = '롯데';

commit;

set autocommit = 1;

-- ----------------------------------------------

