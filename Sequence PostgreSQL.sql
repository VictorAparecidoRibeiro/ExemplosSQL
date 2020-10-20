DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS clienteespecial;
DROP SEQUENCE IF EXISTS numerodocliente;

CREATE SEQUENCE numerodocliente
INCREMENT 1
MINVALUE 1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

ALTER TABLE numerodocliente
  OWNER TO postgres;

CREATE TABLE cliente
(
	id INTEGER NOT NULL DEFAULT nextval('numerodocliente') PRIMARY KEY,
	nome VARCHAR(50)
);

CREATE TABLE clienteespecial
(
	id INTEGER NOT NULL PRIMARY KEY,
	nome VARCHAR(50)
);

SELECT * FROM cliente;
SELECT * FROM clienteespecial;

SELECT last_value FROM numerodocliente;

INSERT INTO cliente (nome) VALUES ('Luzildo');
INSERT INTO cliente (nome) VALUES ('Luzilda');
INSERT INTO cliente (nome) VALUES ('Tania');

SELECT last_value FROM numerodocliente;

SELECT * FROM cliente;

SELECT currval('numerodocliente');

SELECT setval('numerodocliente',10);

SELECT nextval('numerodocliente');

SELECT * FROM clienteespecial;

select last_value from numerodocliente;

INSERT INTO clienteespecial VALUES ((SELECT last_value FROM numerodocliente), 'Tania');



