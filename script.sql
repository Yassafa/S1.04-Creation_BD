DROP TABLE IF EXISTS freedom;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS data;

CREATE TABLE data (
	country VARCHAR,
	year INT,
	cl INT,
	pr INT,
	status VARCHAR,
	region_code INT,
	region_name VARCHAR,
	is_ldc INT
);

\copy data FROM freedom.csv WITH CSV DELIMITER ',';

CREATE TABLE region (
  region_code INT PRIMARY KEY,
  region_name VARCHAR
);

CREATE TABLE status (
	status VARCHAR PRIMARY KEY
);

CREATE TABLE country (
	id_country SERIAL PRIMARY KEY,
	country_name VARCHAR,
	region_code INT REFERENCES region(region_code),
	is_ldc INT
);

CREATE TABLE freedom (
	id_country INT REFERENCES country(id_country),
	year INT,
	civil_liberties INT,
	political_rights INT,
	status VARCHAR REFERENCES status(status),
	PRIMARY KEY (id_country,year)
);

INSERT INTO region SELECT DISTINCT region_code,region_name FROM data;
INSERT INTO status SELECT DISTINCT status FROM data;
INSERT INTO country (country_name,region_code,is_ldc) SELECT DISTINCT country,region_code,is_ldc FROM data;
INSERT INTO freedom SELECT DISTINCT id_country,year,cl,pr,status FROM data JOIN country ON data.country = country.country_name;

DROP TABLE data;