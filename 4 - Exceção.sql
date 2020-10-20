--Parte 1 

CREATE TABLE PESSOA(
    ID NUMBER(3) PRIMARY KEY,
    NOME VARCHAR2(120) NOT NULL
);

 

SELECT * FROM PESSOA;

 

CREATE OR REPLACE 
FUNCTION FUNC_CADPESSOA(PID IN NUMBER, PNOME IN VARCHAR2)
RETURN NUMBER
IS
    RET NUMBER := 0;
    QTDE NUMBER(1);
BEGIN
    IF PID > 0 AND PID <= 999 THEN
        IF LENGTH(PNOME) <= 120 AND PNOME IS NOT NULL THEN
            SELECT COUNT(*) INTO QTDE FROM PESSOA
                    WHERE ID = PID;
            IF QTDE = 0 THEN
                INSERT INTO PESSOA (ID, NOME)
                    VALUES (PID, PNOME);
				
            ELSE
                RET := -997;
            END IF;
        ELSE
            RET := -998;
        END IF;
    ELSE
        RET := -999;
    END IF;
    COMMIT;
    RETURN RET;
	
	EXCEPTION
				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE('código erro: ' || SQLCODE);
					DBMS_OUTPUT.PUT_LINE('descrição erro: ' || SQLERRM);
					ROLLBACK;
					RETURN SQLCODE;
END;

 

 


DECLARE
    X NUMBER(3);
BEGIN
    X := FUNC_CADPESSOA(1, 'LUIS');
    DBMS_OUTPUT.PUT_LINE('RESULTADO DA EXECUCAO: ' || X);
END;

--Parte 2

DROP TABLE PESSOA;

 

CREATE TABLE PESSOA(
    ID NUMBER(3) PRIMARY KEY,
    NOME VARCHAR2(120) NOT NULL
);

 

SELECT * FROM PESSOA;
SELECT NOME FROM PESSOA

 

CREATE OR REPLACE 
FUNCTION FUNC_CADPESSOA(PID IN NUMBER, PNOME IN VARCHAR2)
RETURN NUMBER
IS
    RET NUMBER := 0;
    QTDE NUMBER(1);
    VNOME VARCHAR2(120);
BEGIN
    --SELECT NOME INTO VNOME FROM PESSOA;
    QTDE := 1/0;
    IF PID > 0 AND PID <= 999 THEN
        IF LENGTH(PNOME) <= 120 AND PNOME IS NOT NULL THEN
            SELECT COUNT(*) INTO QTDE FROM PESSOA
                    WHERE ID = PID;
            IF QTDE = 0 THEN
                INSERT INTO PESSOA (ID, NOME)
                    VALUES (PID, PNOME);
            ELSE
                RET := -997;
            END IF;
        ELSE
            RET := -998;
        END IF;
    ELSE
        RET := -999;
    END IF;
    COMMIT;
    RETURN RET;
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('código erro: ' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE('descrição erro: ' || SQLERRM);
      ROLLBACK;
      RETURN SQLCODE;
END;

 

 


DECLARE
    X NUMBER(4);
BEGIN
    X := FUNC_CADPESSOA(2, 'LUIS');
    DBMS_OUTPUT.PUT_LINE('RESULTADO DA EXECUCAO: ' || X);
END;
 