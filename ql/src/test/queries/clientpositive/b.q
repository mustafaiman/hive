set hive.explain.user=false;
set hive.exec.dynamic.partition=true;
set hive.stats.autogather=false;
set hive.vectorized.execution.enabled=false;
CREATE TABLE src (key string COMMENT 'default') STORED AS TEXTFILE;

insert into src values ('23'), ('6');

create table ctas_part (key int) partitioned by (modkey bigint);


explain
insert overwrite table ctas_part partition (modkey)
select key, ceil(key / 100) from src order by key limit 3;

--set hive.vectorized.execution.enabled=true;
--explain vectorization detail
--insert overwrite table ctas_part partition (modkey)
--select key, ceil(key / 100) from src order by key limit 3;
--
--insert overwrite table ctas_part partition (modkey)
--select key, ceil(key / 100) from src order by key limit 3;
--
--select * from ctas_part;