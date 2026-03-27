use book_db;

create table book (
	book_id 	int,
    title 		varchar(50),
    author 		varchar(50),
    pub_date 	date
);

insert into book values (1, 'Doctor Sleep', 'Stephen King', '2014-09-24');
insert into book values (1, 'The Da Vinch Code', 'Dan Brown', '2017-06-27');

delete from book;

alter table book add constraint primary key(book_id);

select *
from information_schema.table_constraints
where table_name = 'book';

insert into book values (1, 'Doctor Sleep', 'Stephen King', '2014-09-24');
insert into book values (2, 'The Da Vinch Code', 'Dan Brown', '2017-06-27');

alter table book add pubs varchar(50);
alter table book modify title varchar(100);

update book set pubs = 'Gallery Books' where book_id = 1;
update book set pubs = 'Doubleday' where book_id = 2;

create table author (
	author_id	int		primary key,
    author_name varchar(100)	not null,
    author_desc varchar(500)
);

alter table book drop author;
alter table book add author_id int;

insert into author values(100, 'Stephen King', '미국 대표 소설가');
insert into author values(200, 'Dan Brown', '미국 작가');

update book set author_id = 100 where book_id = 1;
update book set author_id = 200 where book_id = 2;

alter table book add constraint fk_book_author foreign key (author_id) references author (author_id);

select *
from information_schema.key_column_usage
where table_name = 'book';

desc book;
desc author;
select * from book;
select * from author;