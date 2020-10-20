15-SELECT *  FROM veterinario;
16-SELECT nome  FROM veterinario WHERE nome LIKE'%b%';
17-SELECT idvet,nome   FROM veterinario ORDER by nome, crmv ;
18-SELECT nome,telefone   FROM veterinario WHERE  anonasc < 1985  ;
19-SELECT nome,anonasc   FROM veterinario WHERE  anonasc > 1980 AND anonasc < 2010  ;
20-SELECT nome, crmv   FROM veterinario WHERE  crmv = '123' ; 
21-SELECT nome, telefone   FROM veterinario WHERE  nome LIKE 'C%' ORDER BY nome ; 
22-SELECT * FROM animal;
23-SELECT * FROM animal WHERE tipo ='Comprado' AND valorpago > 500.00;
24-select * from animal where extract(year from age(animal.datanasc)) <= 2
25-SELECT * FROM animal WHERE extract('month' from datanasc ) = 8;
26-SELECT * FROM animal WHERE extract('day' from datanasc ) >1 AND extract('day' from datanasc ) <10 ;
27-SELECT nome FROM animal WHERE tipo ='Doado' AND nome LIKE 'R%' ;
28-SELECT * FROM animal WHERE propid ='2';
29-select * from animal ORDER BY propid ,nome;
30-select * from animal WHERE tipo='Comprado' AND valorpago >=300 AND valorpago <=600 ;
31-select * from animal WHERE tipo='Doado' AND raca='POODLE' ;
32-select * from animal WHERE tipo='Comprado' AND raca='BEAGLE' AND valorpago > 1000.00 ;
33-select count(animal) from animal  ;
34-select count(animal) from animal WHERE tipo='Doado' ;
35-select count(animal) from animal WHERE tipo='Comprado' ;
36-select count(animal) from animal WHERE propid=1 ;
37-SELECT propid , count(animal) FROM animal GROUP BY propid;
38-SELECT  count(animal) FROM animal WHERE EXTRACT('year' FROM datanasc) < 2005 AND tipo='Doado' GROUP BY propid;
39-SELECT  count(proprietario) FROM proprietario GROUP BY estado;
40-SELECT  count(proprietario), estado FROM proprietario GROUP BY estado;
41-SELECT SUM(valorpago) FROM animal WHERE tipo='Comprado';
42-SELECT propid,SUM(valorpago) FROM animal GROUP BY propid HAVING SUM(valorpago)> 500.00;
43-SELECT AVG(valorpago) FROM animal WHERE tipo='Comprado';
44-SELECT AVG(extract(year from (animal.datanasc))) FROM animal ;
45-SELECT AVG(extract(year from age(animal.datanasc))) FROM animal ;
46-SELECT AVG(valorpago) FROM animal WHERE valorpago >150.00 AND valorpago < 500.00 ;
47-SELECT AVG(valorpago) AS média FROM animal  ;
48-SELECT MIN(valorpago) FROM animal  ;
49-SELECT MAX(valorpago) AS valor_maximo FROM animal  ;
50-SELECT animal.nome as "NOME ANIMAL",
proprietario.nome as "NOME PROPRIETARIO" FROM animal 
INNER JOIN proprietario ON (proprietario.idprop = animal.propid)
51-SELECT proprietario.nome, proprietario.cidade,animal.tipo FROM proprietario, animal WHERE proprietario.idprop = animal.propid AND tipo='Comprado';
52-SELECT animal.nome FROM proprietario, animal WHERE proprietario.idprop = animal.propid AND estado='SP';
53-


59-SELECT animal.nome as "NOME ANIMAL",
proprietario.nome as "NOME PROPRIETARIO",
atendimento.dataatend as "DATA",
veterinario.nome as "NOME VETERINARIO" FROM atendimento
INNER JOIN animal ON (animal.idpet = atendimento.petid)
INNER JOIN proprietario ON (proprietario.idprop = animal.propid)
INNER JOIN veterinario ON (veterinario.idvet = atendimento.vetid)
ORDER BY animal.nome;
60-SELECT animal.nome as "NOME ANIMAL",
atendimento.dataatend as "DATA",
veterinario.nome as "NOME VETERINARIO" FROM atendimento
INNER JOIN animal ON (animal.idpet = atendimento.petid)
INNER JOIN veterinario ON (veterinario.idvet = atendimento.vetid)
ORDER BY atendimento.dataatend;