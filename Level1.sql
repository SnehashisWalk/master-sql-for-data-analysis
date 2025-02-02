-- Chapter 1- 4

create database movies_db;

create schema netflix;
create schema imdb;

create table netflix.titles (
	title_id varchar(10) PRIMARY KEY,
	title varchar(200) NOT NULL,
	title_type varchar(5),
	description varchar(2000),
	release_year integer NOT NULL,
	age_certification varchar(10),
	runtime smallint, 
	genres varchar(30) ARRAY[10],
	production_countries varchar(10) ARRAY[10],
	seasons smallint,
	imdb_score decimal(2,1),
	imdb_votes integer
);


create table netflix.credits (
	person_id integer,
	title_id varchar(10) REFERENCES netflix.titles(title_id),
	name varchar(300),
	character varchar(300),
	role varchar(10)
);

ALTER TABLE netflix.titles
ALTER COLUMN production_countries TYPE varchar(10)[]
USING production_countries::varchar(10)[];

ALTER TABLE netflix.titles
ALTER COLUMN title DROP NOT NULL;

COPY netflix.titles (title_id, title, title_type, description, release_year, 
age_certification, runtime, genres, production_countries, seasons, imdb_score,imdb_votes)
FROM '/tmp/titles.csv'
DELIMITER ','
CSV HEADER;

select * from netflix.titles;

COPY netflix.credits(person_id, title_id, name, character, role)
FROM '/tmp/credits.csv'
DELIMITER ','
CSV HEADER;

select * from netflix.credits;

-- Chapter 5: SQL Querying Data

/*

FROM >> WHERE >> GROUP BY >> HAVING >> SELECT >> ORDER BY

*/

select title_type, release_year, max(imdb_score) as max_imdb_score
from netflix.titles
group by title_type, release_year
having max(imdb_score) IS NOT NULL
order by title_type, release_year ASC;

-- Data Dictionary

SELECT table_schema, table_name, table_type
from information_schema.tables
where table_schema = 'netflix'
order by 1;

SELECT * 
FROM information_schema.columns
WHERE table_schema = 'netflix' AND table_name = 'titles';

SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'netflix' AND table_name = 'titles';

SELECT *
FROM information_schema.tables;

SELECT *
FROM pg_catalog.pg_views
WHERE schemaname = 'information_schema';