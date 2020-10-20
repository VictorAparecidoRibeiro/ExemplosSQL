DROP LOG_CARRO_VENDA;
DROP TABLE CARRO_VENDA;
DROP SEQUENCE SEQ_LOGCARROVENDA;

---------------------------------------------------------------------------------------

CREATE TABLE CARRO_VENDA(
    PLACA CHAR(7) PRIMARY KEY,
    DESCRITIVO VARCHAR2(120) NOT NULL,
    VALOR_COMPRA NUMBER (10,2) NOT NULL,
    VALOR_VENDA NUMBER (12,2) NOT NULL,
    VENDIDO CHAR(1) NOT NULL, 
    CONSTRAINT CK_VENDIDI_CV CHECK (VENDIDO IN ('S', 'N'))
);

---------------------------------------------------------------------------------------
 
CREATE TABLE LOG_CARRO_VENDA(
ID_LOG NUMBER(12) PRIMARY KEY,
PLACA CHAR(7) NOT NULL,
VALOR_VENDA_OLD NUMBER (12,2) NOT NULL,
VALOR_VENDA_NEW NUMBER (12,2) NOT NULL,
DATA_REGISTRO DATE NOT NULL,
USUARIO VARCHAR2(120) NOT NULL,
CONSTRAINT FK_LOG_CARRO_VENDA FOREIGN KEY (PLACA)
            REFERENCES CARRO_VENDA(PLACA)
);

---------------------------------------------------------------------------------------

CREATE SEQUENCE SEQ_LOGCARROVENDA
START WITH 1
INCREMENT BY 1
MAXVALUE 999999999999
NOCYCLE
NOCACHE;

---------------------------------------------------------------------------------------
 
INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VAlUES('AAA1111', 'GOL S', 12000, 0, 'N');
INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VALUES('BBB2222', 'CORSA', 22000, 33000, 'N');
INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VALUES('CCC3333', 'VARIANT', 10000, 15000, 'S');

COMMIT; 

SELECT * FROM CARRO_VENDA;

SELECT ID_LOG,PLACA,VALOR_VENDA_OLD,VALOR_VENDA_NEW,
TO_CHAR(DATA_REGISTRO, 'DD/MM/YYYY HH24:MI:SS') AS DATA_REGISTRO, USUARIO FROM LOG_CARRO_VENDA;

---------------------------------------------------------------------------------------

CREATE TABLE LOG_GERALEXEC (
    ID_LOG NUMBER(12) PRIMARY KEY,
    NOME_PROGRAMACAO VARCHAR(30) NOT NULL,
    DATA_REGISTRO DATE NOT NULL,
    USUARIO VARCHAR(30) NOT NULL,
    COD_ERR NUMBER(4) NOT NULL,
    DESCRICAO VARCHAR(512) NOT NULL,
    LINHA VARCHAR(512) NULL
);

---------------------------------------------------------------------------------------

CREATE OR REPLACE
FUNCTION FUN_PERCVENDA(PPLACA IN CHAR , PPERC IN NUMBER)
RETURN NUMBER
IS
    RET NUMBER := 0;
    QTDE NUMBER(1);
    ERRO_PERCENTUAL EXCEPTION;
    ERRO_PLACA_INEXISTE EXCEPTION;
    ERRO_VENDIDO EXCEPTION;
    V_VALOR_COMPRA CARRO_VENDA.VALOR_COMPRA%TYPE;
    V_VENDIDO CARRO_VENDA.VENDIDO%TYPE;
    V_VALORVENDA CARRO_VENDA.VALOR_VENDA%TYPE;
    V_VALOR_VENDA_ORIGINAL CARRO_VENDA.VALOR_VENDA%TYPE;
BEGIN
    IF PPERC >= 15 THEN
        SELECT COUNT(*) 
        INTO QTDE 
        FROM CARRO_VENDA 
        WHERE PLACA = PPLACA;
        
        IF QTDE = 1 THEN
            SELECT VALOR_COMPRA, VENDIDO, VALOR_VENDA 
            INTO V_VALOR_COMPRA, V_VENDIDO, V_VALOR_VENDA_ORIGINAL
            FROM CARRO_VENDA 
            WHERE PLACA = PPLACA;
            
            IF V_VENDIDO = 'N' THEN
                V_VALORVENDA := V_VALOR_COMPRA+(V_VALOR_COMPRA * (PPERC/100));
                UPDATE CARRO_VENDA 
                SET VALOR_VENDA = V_VALORVENDA
                WHERE PLACA = PPLACA;
                INSERT INTO LOG_CARRO_VENDA (ID_LOG, PLACA,VALOR_VENDA_OLD,
                            VALOR_VENDA_NEW, DATA_REGISTRO, USUARIO)
                VALUES(SEQ_LOGCARROVENDA.NEXTVAL, PPLACA,
                        V_VALOR_VENDA_ORIGINAL, V_VALORVENDA, SYSDATE, USER);
            ELSE
                RAISE ERRO_VENDIDO;
            END IF;
        ELSE
            RAISE ERRO_PLACA_INEXISTE;
        END IF;
    ELSE
        RAISE ERRO_PERCENTUAL;
    END IF;
    COMMIT;
    RETURN RET;

---------------------------------------------------------------------------------------

EXCEPTION
    WHEN ERRO_VENDIDO THEN
        ROLLBACK;
        INSERT INTO LOG_GERALEXEC(ID_LOG, NOME_PROGRAMACAO, 
                    DATA_REGISTRO, USUARIO, COD_ERR, DESCRICAO, LINHA)
        VALUES(SEQ_LOGERALEXEC.NEXTVAL, 'FUN_PERCVENDA', SYSDATE,
        USER, -997, 'CARRO JÁ FOI VENDIDO, NÃO PODE ALTERAR VALOR DA VENDA')
        RETURN -997;
    WHEN ERRO_PLACA_INEXISTE THEN
        ROLLBACK;
        INSERT INTO LOG_GERALEXEC(ID_LOG, NOME_PROGRAMACAO, 
                    DATA_REGISTRO, USUARIO, COD_ERR, DESCRICAO, LINHA)
        VALUES(SEQ_LOGERALEXEC.NEXTVAL, 'FUN_PERCVENDA', SYSDATE,
        USER, -998, 'PLACA NÃO EXISTE')
        RETURN -998;
    WHEN ERRO_PERCENTUAL THEN
        ROLLBACK;
        INSERT INTO LOG_GERALEXEC(ID_LOG, NOME_PROGRAMACAO, 
                    DATA_REGISTRO, USUARIO, COD_ERR, DESCRICAO, LINHA)
        VALUES(SEQ_LOGERALEXEC.NEXTVAL, 'FUN_PERCVENDA', SYSDATE,
        USER, -999, 'PERCENTUAL ACIMA/ABAIXO DO ESPERADO')
        RETURN -999;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('código erro: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('descrição erro: ' || SQLERRM);
        ROLLBACK;
        V_ERRO := SQLCODE;
        V_DESCRICAO := SQLERRM;
        INSERT INTO LOG_GERALEXECUCAOPROG(ID_LOG, NOME_PROGRAMACAO, DATA_REGISTRO,
                    USUARIO, CODDIGO, DESCRICAO, LINHA)
        VALUES(SEQ_LOGGERALEXEC.NEXTVAL, 'FUN_PERCVENDA', SYSDATE, 
        USER, V_ERRO, V_DESCRICAO, 0); --PESQUISA PARA DESCOBRIR A LINHA DO ERRO
        RETURN SQLCODE;
END;

---------------------------------------------------------------------------------------

DECLARE
    X NUMBER;
BEGIN
    X := FUN_PERCVENDA('BBB2222', 90);
    DBMS_OUTPUT.PUT_LINE('RESULTADO EXECUCAO: ' || X);
END;

UPDATE CARRO_VENDA SET VALOR_VENDA = 95600 WHERE PLACA = 'BBB2222';
-- FAZER ALTERAÇÃO DE VALOR FORA DA FUNÇÃO NÃO ESTÁ REGISTRANDO LOG DE REGISTRO
--COMO RESOLVER ISSO????? TRIGGER!!!!!!!!!!!!!!!! -> APÓS A AVALIAÇÃO 1.
