-- 获得产品信息
DELIMITER //
CREATE PROCEDURE show_products()
	BEGIN
		select * from products;
	END;
//
DELIMITER ;

-- 获得月报表（存储过程），根据年月分组，使用sum获得总价格，再除以qty的总和得到平均价格，日期格式使用FORMAT函数
DELIMITER //
CREATE PROCEDURE report_monthly_sale(IN PROD_ID varchar(4))
	BEGIN 
		select Pro.pname as ProductName, date_format(Pur.ptime,'%b-%Y') as MONTH, 
		sum(qty) as totalQuantity, sum(Pur.total_price) as totalDollar,
		Format(sum(Pur.total_price)/sum(Pur.qty),2) as avgDollar from products Pro, purchases Pur 
		where Pro.pid = PROD_ID and Pur.pid=PROD_ID GROUP BY  date_format(Pur.ptime, '%Y-%m') ;
	END
//
DELIMITER ;
			
-- 添加购买记录（存储过程） 先判断库存是否足够，不够则返回错误信息，够则插入			
DELIMITER //
CREATE PROCEDURE add_purchase(IN pur_no int,IN c_id varchar(4),IN e_id varchar(3),
	IN p_id varchar(4),IN pur_qty int) 
	BEGIN
		DECLARE totalPrice FLOAT DEFAULT 0;
		DECLARE q_oh INT DEFAULT 0;
		SELECT qoh into q_oh from products where pid=p_id;
		IF(q_oh < pur_qty)
		THEN
			SELECT "Insufficient quantity in stock" as "error message";
		ELSE
			SELECT pur_qty*original_price*(1-discnt_rate) INTO totalPrice 
				FROM products where pid=p_id;
			insert into purchases values(pur_no,c_id,e_id,p_id,pur_qty,now(),totalPrice);
		END IF;
	END
//
DELIMITER ;

-- 更新库存后的触发器
DELIMITER //
CREATE TRIGGER AfterUpdateQoh after update on products for each row
	BEGIN
	DECLARE userName varchar(30) DEFAULT 'jiumi';
	IF(old.qoh != new.qoh)			-- 判断库存是否更新
	THEN							-- 插入日志表
		SELECT user() into userName;
		insert into logs(who,time,table_name,operation,key_value) values(userName,now(),'products','update',NEW.pid);
	END IF;
	END
//
DELIMITER ;

-- 更新购买次数后的触发器
DELIMITER //
CREATE TRIGGER AfterUpdateVisits after update on customers  for each row
	BEGIN
	DECLARE userName varchar(30) DEFAULT 'jiumi';
	IF(old.visits_made != new.visits_made)			-- 判断是否更新了购买次数
	THEN											-- 插入日志表
		SELECT user() into userName;	
		insert into logs(who,time,table_name,operation,key_value) values(userName,now(),'customers','update',NEW.cid);
	END IF;
	END
//
DELIMITER ;

-- 插入购买记录后触发的触发器
DELIMITER //
CREATE TRIGGER AfterInsertToPur after insert on purchases for each row
	BEGIN
	DECLARE userName varchar(30) DEFAULT 'jiumi';
	DECLARE errorMess varchar(100) DEFAULT 'error';
	DECLARE q_oh int DEFAULT 0;
	DECLARE q_oh_threshold int DEFAULT 0;
	SELECT user() into userName;	-- 用户名
	insert into logs(who,time,table_name,operation,key_value) 
		values(userName,now(),'purchase','insert',NEW.pur);	-- 将新消息插入日志中
	-- 获取进货最低库存
	SELECT qoh_threshold into q_oh_threshold from products where pid=new.pid;		
	-- 更新products库存
	update products set qoh=qoh-new.qty where pid=new.pid;							
	-- 更新customers购买次数
	update customers set visits_made=visits_made+1,last_visit_time=now() where cid=new.cid;		
	-- 获取更新后的库存
	SELECT qoh into q_oh from products where pid=new.pid;							
	-- 判断是否需要进货
	IF(q_oh < q_oh_threshold) THEN													
		update products set qoh=2*(qoh+new.qty) where pid=new.pid;
		SELECT qoh into q_oh from products where pid=new.pid;					
		select concat("Before:",old_q_oh,"After:",q_oh) into errorMess;				
	END IF;
	END
//
DELIMITER ;

-- 得到所有产品销售情况的存储过程（题目无要求），使用游标遍历产品调用存储过程report_monthl_sale();
DELIMITER //
create procedure get_sale()
BEGIN
	DECLARE done int default 0;
	DECLARE now_pid varchar(5) default NULL;
	DECLARE cur CURSOR FOR 
				SELECT pid from products;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
	open cur;
	REPEAT
		FETCH cur into now_pid;
		IF NOT done THEN
			call report_monthly_sale(now_pid);
		END IF;
	UNTIL done END REPEAT;
	CLOSE cur;
END
//
DELIMITER ;

-- 建表语句
create table employees
(eid varchar(3) not null, //change all eid, cid, pid, pur, key_value to int types in the future
 ename varchar(15),
 city varchar(15),
 primary key(eid));
      
create table customers
(cid varchar(4) not null,
 cname varchar(15),
 city varchar(15),
 visits_made int(5),
 last_visit_time datetime,
 primary key(cid));

create table suppliers
(sid varchar(2) not null,
sname varchar(15) not null,
city varchar(15),
telephone_no char(10),
 primary key(sid),
 unique(sname));

create table products
(pid varchar(4) not null,
 pname varchar(15) not null,
 qoh int(5) not null,
 qoh_threshold int(5),
 original_price decimal(6,2),
 discnt_rate decimal(3,2),
 sid varchar(2),
 primary key(pid),
 foreign key (sid) references suppliers (sid));

create table purchases
(pur  int not null,
 cid varchar(4) not null,
 eid varchar(3) not null,
 pid varchar(4) not null,
 qty int(5),
 ptime datetime,
 total_price decimal(7,2),
 primary key (pur),
 foreign key (cid) references customers(cid),
 foreign key (eid) references employees(eid),
 foreign key (pid) references products(pid));

create table logs
(logid int(5) not null auto_incrment,
who varchar(10) not null,
time datetime not null,
table_name varchar(20) not null,
operation varchar(6) not null,
key_value varchar(4),
 primary key (logid)); 



-- 数据插入指令
insert into employees values ('e00', 'Amy', 'Vestal');
insert into employees values ('e01', 'Bob', 'Binghamton');
insert into employees values ('e02', 'John', 'Binghamton');
insert into employees values ('e03', 'Lisa', 'Binghamton');
insert into employees values ('e04', 'Matt', 'Vestal');

insert into suppliers values ('s0', 'Supplier 1', 'Binghamton', '6075555431');
insert into suppliers values ('s1', 'Supplier 2', 'NYC', '6075555432');

-- produces表需新增pics属性存储图片位置
insert into products values ('pr00', 'Milk', 12, 10, 2.40, 0.1, 's0',NULL);
insert into products values ('pr01', 'Egg', 20, 10, 1.50, 0.2, 's1',NULL);
insert into products values ('pr02', 'Bread', 15, 10, 1.20, 0.1, 's0',NULL);
insert into products values ('pr03', 'Pineapple', 6, 5, 2.00, 0.3, 's0',NULL);
insert into products values ('pr04', 'Knife', 10, 8, 2.50, 0.2, 's1',NULL);
insert into products values ('pr05', 'Shovel', 5, 5, 7.99, 0.1, 's0',NULL);

insert into customers values ('c000', 'Kathy', 'Vestal', 2, '2019-1-28 10:25:32'); 
insert into customers values ('c001', 'Brown', 'Binghamton', 1, '2019-2-05 09:12:30'); 
insert into customers values ('c002', 'Anne', 'Vestal', 1, '2019-1-29 14:30:00'); 
insert into customers values ('c003', 'Jack', 'Vestal', 1, '2019-3-04 16:48:02'); 
insert into customers values ('c004', 'Mike', 'Binghamton', 1, '2019-3-30 11:52:16'); 
    
insert into purchases values (1, 'c000', 'e00', 'pr00', 1, '2019-1-26 12:34:22', 2.16);
insert into purchases values (2, 'c001', 'e03', 'pr03', 2, '2019-2-05 09:12:30', 2.80);
insert into purchases values (3, 'c002', 'e03', 'pr00', 1, '2019-1-29 14:30:00', 2.16);
insert into purchases values (4, 'c000', 'e01', 'pr01', 5, '2019-1-28 10:25:32', 6.00);
insert into purchases values (5, 'c004', 'e04', 'pr02', 3, '2019-1-30 11:52:16', 3.24);
insert into purchases values (6, 'c003', 'e02', 'pr05', 1, '2019-2-04 16:48:02', 7.19);


update products set pics="/static/milk.jpg" where pid="pr00";
update products set pics='/static/egg.jpg' where pid="pr01";
update products set pics='/static/bread.jpg' where pid="pr02";
update products set pics='/static/pineapple.jpg' where pid="pr03";
update products set pics='/static/knife.jpg' where pid="pr04";
update products set pics='/static/shovel.jpg' where pid="pr05";

	











