use board_react;

CREATE TABLE board
(	article_no	INT auto_increment primary key,
	title		VARCHAR(100),
	content	VARCHAR(2000),
	write_date	timestamp DEFAULT current_timestamp,
	write_id		VARCHAR(50)
);

insert into board (title, content, write_date, write_id)
values ('hi', 'hello world', default, 'kim');

insert into board (title, content, write_date, write_id)
values ('안녕하세요', '반갑습니다', default, 'lee');

insert into board (title, content, write_date, write_id)
values ('test', '테스트', default, 'park');

select * from board;
delete from board;
ALTER TABLE board AUTO_INCREMENT = 1;