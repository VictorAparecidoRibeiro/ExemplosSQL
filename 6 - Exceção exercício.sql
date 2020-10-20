--- ENUNCIADO


Desenvolver uma funça que receba o código do funcionário e o percentual de aumento que deve ser aplicado. 
O percentual de aumento deve ser maior que zero e menor ou igual a 15 (
valor que prepresentaria o percentual). Antes de aplicar o aumento verificar se o f
uncionário existe dentro da empresa e ver se aplicando o aumento o salário passa 
de R$4000,00, pois o teto de salário da empresa é de R$4000,00. 
Caso o saLário passe desse valor fixar o salário neste valor.

 

(Pense se não existem outras questões ou restrições, pois nem sempre o requisito vem com todos os detalhes)

 

FUN_AUMFUNCSAL - NOME DA FUNÇÃO
PCOD ; PPERC - PARÂMETROS
TRATAMENTOS DE ERROS DEVEM SER FEITOS POR EXCEPTIONS
-999 - FUNCIONARIO NAO EXISTE
-998 - PERCENTUAL FORA DA FAIXA
-997 - FUNCIONARIO EXISTE MAS FOI DEMITIDO
-996 - ID FORA DE FAIXA

 

 
-------------------------------------------
 
 
....
SELECT COUNT(*) INTO QTDE FROM PESSOA
                    WHERE ID = PID; --QUANTIDADE DE REGISTROS COM ESSE ID

 

....
IS
   V_NOME     FUNCIONARIO_SALARIO.NOME%TYPE;             
BEGIN
...
    SELECT NOME INTO VNOME FROM FUNCIONARIO_SALARIO WHERE IDENTIFICACAO = PCOD;

 


CREATE TABLE FUNCIONARIO_SALARIO(
    IDENTIFICACAO NUMBER(6) PRIMARY KEY,
    NOME VARCHAR2(120) NOT NULL,
    DATA_CONTRATACAO DATE NOT NULL,
    DATA_DEMISSAO DATE NULL,
    SALARIO_BRUTO_ATUAL NUMBER (10,2) NOT NULL
);

 

INSERT INTO FUNCIONARIO_SALARIO(IDENTIFICACAO ,NOME,DATA_CONTRATACAO,DATA_DEMISSAO,SALARIO_BRUTO_ATUAL)
VALUES (1, 'JOÃO SILVA', TO_DATE('20/04/2000','DD/MM/YYYY'), NULL, 1000);
INSERT INTO FUNCIONARIO_SALARIO(IDENTIFICACAO ,NOME,DATA_CONTRATACAO,DATA_DEMISSAO,SALARIO_BRUTO_ATUAL)
VALUES (2, 'MARIA CARDOSO', TO_DATE('12/01/1980','DD/MM/YYYY'), NULL, 2000);
INSERT INTO FUNCIONARIO_SALARIO(IDENTIFICACAO ,NOME,DATA_CONTRATACAO,DATA_DEMISSAO,SALARIO_BRUTO_ATUAL)
VALUES (3, 'PEDRO SOUZA', TO_DATE('28/03/2019','DD/MM/YYYY'), TO_DATE('28/03/2020','DD/MM/YYYY'), 750);
INSERT INTO FUNCIONARIO_SALARIO(IDENTIFICACAO ,NOME,DATA_CONTRATACAO,DATA_DEMISSAO,SALARIO_BRUTO_ATUAL)
VALUES (4, 'CLAUDIA AZEVEDO', TO_DATE('07/09/2000','DD/MM/YYYY'), NULL, 3500);
INSERT INTO FUNCIONARIO_SALARIO(IDENTIFICACAO ,NOME,DATA_CONTRATACAO,DATA_DEMISSAO,SALARIO_BRUTO_ATUAL)
VALUES (5, 'PAULO ROCHA,' TO_DATE('07/07/2000','DD/MM/YYYY'), NULL, 4200);

 

COMMIT;


SELECT * FROM FUNCIONARIO_SALARIO;

DECLARE
    X NUMBER(3);
BEGIN
    X := FUNC_CADPESSOA(1, 'LUIS');
    DBMS_OUTPUT.PUT_LINE('RESULTADO DA EXECUCAO: ' || X);
END;


------------------------------------------------------------------------- Daqui pra baixo o exercicio feito

CREATE OR REPLACE
FUNCTION FUNC_CADPESSOA(PID IN NUMBER, PPERCENTUAL IN NUMBER)
RETURN NUMBER
IS
    RET NUMBER := 0;
    QTDE NUMBER(1);
    V_DATA_DEMISSAO FUNCIONARIO_SALARIO.DATA_DEMISSAO%TYPE;  
    V_SALARIO_BRUTO FUNCIONARIO_SALARIO.SALARIO_BRUTO_ATUAL%TYPE;
    V_AUX_CALCULO NUMBER;
    V_SALARIO_REAJUSTADO FUNCIONARIO_SALARIO.SALARIO_BRUTO_ATUAL%TYPE;
    VALIDA_FUNC_NAO_EXISTE EXCEPTION;
    VALIDA_ID_FORA_FAIXA EXCEPTION;
    VALIDA_PERCENTUAL_FORA_FAIXA EXCEPTION;
    VALIDA_FUNC_DEMITIDO EXCEPTION;
BEGIN
    IF PID > 0 AND PID <= 6 THEN
    
        IF PPERCENTUAL > 0 AND PPERCENTUAL <= 15 THEN
        
            SELECT COUNT(*)
            INTO QTDE FROM FUNCIONARIO_SALARIO
                    WHERE IDENTIFICACAO = PID;
                    
            IF QTDE > 0 THEN
                
                 SELECT DATA_DEMISSAO INTO V_DATA_DEMISSAO FROM FUNCIONARIO_SALARIO
                    WHERE IDENTIFICACAO = PID;
                
                IF V_DATA_DEMISSAO IS NULL THEN
                    
                SELECT SALARIO_BRUTO_ATUAL 
					INTO V_SALARIO_BRUTO FROM FUNCIONARIO_SALARIO WHERE IDENTIFICACAO = PID;
                
                    V_AUX_CALCULO := PPERCENTUAL/100;
                    V_SALARIO_REAJUSTADO := (V_AUX_CALCULO*V_SALARIO_BRUTO) + V_SALARIO_BRUTO;
                    
                    IF V_SALARIO_BRUTO > 4000 THEN
                    
                        UPDATE FUNCIONARIO_SALARIO
                            SET SALARIO_BRUTO_ATUAL = V_SALARIO_REAJUSTADO
                                WHERE IDENTIFICACAO = PID;
                        COMMIT;
                    ELSE
                        
                        IF V_SALARIO_BRUTO < 4000 AND V_SALARIO_REAJUSTADO > 4000 THEN 
                            UPDATE FUNCIONARIO_SALARIO
                            SET SALARIO_BRUTO_ATUAL = 4000
                                WHERE IDENTIFICACAO = PID;
                        COMMIT;
                        ELSE 
                             UPDATE FUNCIONARIO_SALARIO
                            SET SALARIO_BRUTO_ATUAL = V_SALARIO_REAJUSTADO
                                WHERE IDENTIFICACAO = PID;
                        END IF;
                    
                    END IF;
                    
                ELSE
                    RAISE VALIDA_FUNC_DEMITIDO;
                END IF;
                
            ELSE
                RAISE VALIDA_FUNC_NAO_EXISTE;
            END IF;
        ELSE
            RAISE VALIDA_PERCENTUAL_FORA_FAIXA;
        END IF;
    ELSE
        RAISE VALIDA_ID_FORA_FAIXA;
    END IF;
    COMMIT;
    RETURN RET;
EXCEPTION
   WHEN VALIDA_FUNC_NAO_EXISTE THEN
      DBMS_OUTPUT.PUT_LINE('Funcionário não existe');
      ROLLBACK;
      RETURN -999;
    WHEN VALIDA_PERCENTUAL_FORA_FAIXA THEN
      DBMS_OUTPUT.PUT_LINE('Percentual fora de faixa');
      ROLLBACK;
      RETURN -998;
   WHEN VALIDA_FUNC_DEMITIDO THEN
      DBMS_OUTPUT.PUT_LINE('Funcionário existe mas foi demitido');
      ROLLBACK;
      RETURN -997;
   WHEN VALIDA_ID_FORA_FAIXA THEN
      DBMS_OUTPUT.PUT_LINE('ID fora de faixa');
      ROLLBACK;
      RETURN -996;
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('código erro: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('descrição erro: ' || SQLERRM);
      ROLLBACK;
      RETURN SQLCODE;
END;


DECLARE
    X NUMBER(4);
BEGIN
    X := FUNC_CADPESSOA(5, 15);
    DBMS_OUTPUT.PUT_LINE('RESULTADO DA EXECUCAO: ' || X);
END;