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

