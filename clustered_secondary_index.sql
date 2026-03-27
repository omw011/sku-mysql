create table cluster_tbl
(	user_id char(4),
	name varchar(10)
);

insert into cluster_tbl values('FFFF', '김선생');
insert into cluster_tbl values('IIII', '이선생');
insert into cluster_tbl values('CCCC', '박선생');
insert into cluster_tbl values('GGGG', '송선생');
insert into cluster_tbl values('JJJJ', '성선생');
insert into cluster_tbl values('AAAA', '임선생');
insert into cluster_tbl values('DDDD', '백선생');
insert into cluster_tbl values('HHHH', '조선생');
insert into cluster_tbl values('BBBB', '최선생');
insert into cluster_tbl values('EEEE', '라선생');

select * from cluster_tbl;

alter table cluster_tbl add constraint primary key (user_id);

select * from cluster_tbl;
show index from cluster_tbl;

-- ----------------------------------------------------------

create table secondary_tbl
(	user_id char(4),
	name varchar(10)
);

insert into secondary_tbl values('FFFF', '김선생');
insert into secondary_tbl values('IIII', '이선생');
insert into secondary_tbl values('CCCC', '박선생');
insert into secondary_tbl values('GGGG', '송선생');
insert into secondary_tbl values('JJJJ', '성선생');
insert into secondary_tbl values('AAAA', '임선생');
insert into secondary_tbl values('DDDD', '백선생');
insert into secondary_tbl values('HHHH', '조선생');
insert into secondary_tbl values('BBBB', '최선생');
insert into secondary_tbl values('EEEE', '라선생');

select * from secondary_tbl;

alter table secondary_tbl add constraint uk_user_id unique (user_id);

select * from secondary_tbl;

-- ----------------------------------------------------------

insert into cluster_tbl values('BBTT', '나조교');
insert into cluster_tbl values('DDSS', '박조교');

select * from cluster_tbl;

insert into secondary_tbl values('BBTT', '나조교');
insert into secondary_tbl values('DDSS', '박조교');

select * from secondary_tbl;

-- ----------------------------------------------------------

create table compound_tbl
(	user_id char(4),
	name varchar(10),
    user_addr varchar(30)
);


insert into compound_tbl values('FFFF', '김선생', '서울');
insert into compound_tbl values('IIII', '이선생', '포항');
insert into compound_tbl values('CCCC', '박선생', '광주');
insert into compound_tbl values('GGGG', '송선생', '수원');
insert into compound_tbl values('JJJJ', '성선생', '서울');
insert into compound_tbl values('AAAA', '임선생', '서울');
insert into compound_tbl values('DDDD', '백선생', '포항');
insert into compound_tbl values('HHHH', '조선생', '부산');
insert into compound_tbl values('BBBB', '최선생', '수원');
insert into compound_tbl values('EEEE', '라선생', '서울');

select * from compound_tbl;

alter table compound_tbl add constraint primary key (user_id);

select * from compound_tbl;

alter table compound_tbl add constraint uk_compound_id unique (name);

select * from compound_tbl;

show index from compound_tbl;

select user_addr from compound_tbl where name = '라선생';

select * from compound_tbl where user_id = 'DDDD';

select * from compound_tbl;

select name, user_id from compound_tbl;

-- ----------------------------------------------------------

show index from customer;
show table status like 'customer';

create index idx_customer_addr on customer (addr);
show index from customer;
show table status like 'customer';

analyze table customer;
show table status like 'customer';

-- ----------------------------------------------------------

show tables;
desc employees;

select count(*) from employees;

select * from employees limit 10;

create table employees_01 select * from employees.employees order by rand();
select count(*) from employees_01;
create table employees_02 select * from employees.employees order by rand();
create table employees_03 select * from employees.employees order by rand();

select * from employees_01 limit 5;
select * from employees_02 limit 5;
select * from employees_03 limit 5;

show table status;

alter table employees_01 add primary key(emp_no);
alter table employees_02 add index idx_emp_no(emp_no);

select * from employees_01 limit 5;
select * from employees_02 limit 5;
select * from employees_03 limit 5;

show index from employees_01;
show index from employees_02;
show index from employees_03;

analyze table employees_01, employees_02, employees_03;
show table status;
select (5783552 / (16 * 1024));

use index_db;
show global status like 'InnoDB_pages_read';
-- 1947
select * from employees_03 where emp_no = 100000;
show global status like 'InnoDB_pages_read';
-- 2372
select 2372 - 1947;
-- 425

use index_db;
show global status like 'InnoDB_pages_read';
-- 904
select * from employees_01 where emp_no = 100000;
show global status like 'InnoDB_pages_read';
-- 909
select 909 - 904;
-- 5

use index_db;
show global status like 'InnoDB_pages_read';
-- 845
select * from employees_02 where emp_no = 100000;
show global status like 'InnoDB_pages_read';
-- 852
select 852 - 845;
-- 7

use index_db;
show global status like 'InnoDB_pages_read';
-- 846
select * from employees_03 where emp_no < 11000;
show global status like 'InnoDB_pages_read';
-- 1906
select 1906 - 846;
-- 1060

use index_db;
show global status like 'InnoDB_pages_read';
-- 851
select * from employees_01 where emp_no < 11000;
show global status like 'InnoDB_pages_read';
-- 858
select 858 - 851;
-- 7

use index_db;
show global status like 'InnoDB_pages_read';
-- 853
select * from employees_01 where emp_no < 500000 limit 1000000;
show global status like 'InnoDB_pages_read';
-- 1743
select 1743 - 853;
-- 890

use index_db;
show global status like 'InnoDB_pages_read';
-- 842
select * from employees_01 limit 1000000;
show global status like 'InnoDB_pages_read';
-- 1732
select 1732 - 842;
-- 890

use index_db;
show global status like 'InnoDB_pages_read';
-- 845
select * from employees_02 where emp_no < 11000;
show global status like 'InnoDB_pages_read';
-- 1488
select 1488 - 845;
-- 643

use index_db;
show global status like 'InnoDB_pages_read';
-- 843
select * from employees_02 where emp_no < 400000 limit 500000;
show global status like 'InnoDB_pages_read';
-- 1915
select 1915 - 843;
-- 1072

use index_db;
show global status like 'InnoDB_pages_read';
-- 847
select * from employees_02 where emp_no < 50000 limit 500000;
show global status like 'InnoDB_pages_read';
-- 1896
select 1896 - 847;
-- 1049

-- 일반적으로 MySQL은 전체 데이터의 15% 이상을 스캔하는 경우에는 인덱스를 사용하지 않고 테이블을 스캔해버린다.
-- 기준이 되는 양은 상황에 따라 달라질 수 있다.
-- 즉, Secondary Index가 있음에도 사용하지 않는다.
-- 응용 프로그램에서 주로 많은 양의 조회를 사용한다면, 이런 인덱스는 안만드는게 좋다.
-- 인덱스는 만능이 아니다. 굳이 필요없는 Secondary Index는 오히려 시스템의 성능을 저하시킨다.

use index_db;
show global status like 'InnoDB_pages_read';
-- 845
select * from employees_01 where emp_no * 1 = 100000;
show global status like 'InnoDB_pages_read';
-- 1735
select 1735 - 845;
-- 890

select * from employees_03 limit 5;
select distinct gender from employees_03;
alter table employees_03 add index idx_gender (gender);
analyze table employees_03;
show index from employees_03;
show table status like 'employees_03';

use index_db;
show global status like 'InnoDB_pages_read';
-- 872
select * from employees_03 where gender = 'M' limit 500000;
show global status like 'InnoDB_pages_read';
-- 2118
select 2118 - 872;
-- 1246