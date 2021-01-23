set hive.explain.user=false;
set hive.exec.dynamic.partition=true;
set hive.stats.autogather=false;
set hive.vectorized.execution.enabled=false;
CREATE TABLE src (key string COMMENT 'default') STORED AS TEXTFILE;

insert into src values ('2000'), ('60'), ('100'), ('5');

create table ctas_part (key int) partitioned by (modkey bigint);

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       n       |          y             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key limit 10;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       y       |          y             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int) limit 10;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int) limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       n       |          y             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       y       |          y             |   n
truncate table ctas_part;
--- problem order
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int);

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int);

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       n       |          n             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by key limit 10;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by key limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       y       |          n             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int) limit 10;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int) limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       n       |          n             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by key;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by key;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     n      |       y       |          n             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int);

insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int);

select * from ctas_part;

set hive.vectorized.execution.enabled=true;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       n       |          y             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key limit 10;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       y       |          y             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int) limit 10;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int) limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       n       |          y             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       y       |          y             |   n
--problem order
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int);

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by cast(key as int);

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       n       |          n             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by key limit 10;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by key limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       y       |          n             |   y
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int) limit 10;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int) limit 10;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       n       |          n             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by key;

insert overwrite table ctas_part partition (modkey)
select key, key from src order by key;

select * from ctas_part;

-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       y       |          n             |   n
truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int);

insert overwrite table ctas_part partition (modkey)
select key, key from src order by cast(key as int);

select * from ctas_part;


-- extra field in source, no limit
-- vectorized | order by cast | dynamic partition cast | limit
--     y      |       n       |          y             |   y
DROP TABLE src;
CREATE TABLE src (key string, dummy double) STORED AS TEXTFILE;

insert into src values ('2000', 0.1), ('60', 0.2), ('100', 0.3), ('5', 0.4);


truncate table ctas_part;
explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key;

select * from ctas_part;