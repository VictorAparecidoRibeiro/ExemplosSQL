DROP TABLE IF EXISTS venda;

/*
A tabela armazena quantidades de itens vendidos. 
Por exemplo, a venda de id = 1 é composta pelos itens 1, 3 e 10 e suas respectivas quantidades, assim
Obs. itens são os códigos dos produtos vendidos.
*/

CREATE TABLE venda
(
idvenda	INTEGER NOT NULL,
item		INTEGER NOT NULL,
qtde		INTEGER NOT NULL,
CONSTRAINT pkvendas PRIMARY KEY (idvenda, item)
);

/* Simulação de duas vendas, compostas pelos itens 1, 3 e 10, com quantidades diferentes. */

INSERT INTO venda VALUES (01,01,02);
INSERT INTO venda VALUES (01,03,05);
INSERT INTO venda VALUES (01,10,25);
INSERT INTO venda VALUES (02,01,03);
INSERT INTO venda VALUES (02,03,01);
INSERT INTO venda VALUES (02,10,03);

/* Participação nas vendas por produto */

SELECT item, qtdeporproduto, qtdetotal, ROUND((qtdeporproduto * 100)/qtdetotal) AS qtdeporcent 
	FROM 
		(SELECT item, sum(venda.qtde) as qtdeporproduto, (SELECT SUM(qtde) FROM venda) AS qtdetotal
			FROM venda GROUP BY item) AS total;

/* Participação nas vendas por venda */

SELECT idvenda, qtdeporproduto, qtdetotal, ((qtdeporproduto * 100)/qtdetotal) AS qtdeporcent 
	FROM 
		(SELECT idvenda, sum(venda.qtde) as qtdeporproduto, (SELECT SUM(qtde) FROM venda) AS qtdetotal
			FROM venda GROUP BY idvenda) AS total;