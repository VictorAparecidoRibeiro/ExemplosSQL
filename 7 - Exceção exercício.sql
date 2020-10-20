DROP TABLE CARRO_VENDA;

CREATE TABLE CARRO_VENDA(
    PLACA CHAR(7) PRIMARY KEY,
    DESCRITIVO VARCHAR2(120) NOT NULL,
    VALOR_COMPRA NUMBER (10,2) NOT NULL,
    VALOR_VENDA NUMBER (12,2) NOT NULL,
    VENDIDO CHAR(1) NOT NULL, 
    CONSTRAINT CK_VENDIDO_CV CHECK (VENDIDO IN ('S', 'N'))
);

INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VAlUES('AAA1111', 'GOL S', 12000, 0, 'N');
INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VALUES('BBB2222', 'CORSA', 22000, 33000, 'N');
INSERT INTO CARRO_VENDA (PLACA ,DESCRITIVO ,VALOR_COMPRA, VALOR_VENDA, VENDIDO)
VALUES('CCC3333', 'VARIANT', 10000, 15000, 'S');

COMMIT;

SELECT * FROM CARRO_VENDA;

----------------------------------------------------------------------------------------------

CREATE OR REPLACE 
FUNCTION CAR_LUC (PID IN CHAR, PPER IN NUMBER)
RETURN NUMBER
IS  
    QTD NUMBER := 0;
    VQTD NUMBER := 0;
    PERCF CARRO_VENDA.VALOR_VENDA%TYPE;
    RES NUMBER := 0;
    ERRO_PERC EXCEPTION;
    ERRO_EXIST EXCEPTION;
    ERRO_VEND EXCEPTION;
    VAL_V CARRO_VENDA.VALOR_VENDA%TYPE;
    VAL_C CARRO_VENDA.VALOR_COMPRA%TYPE;

BEGIN
    IF PPER > 0 AND PPER <= 15 THEN
        SELECT COUNT(PLACA), VALOR_VENDA, VALOR_COMPRA
        INTO QTD, VAL_V, VAL_C
        FROM CARRO_VENDA
        WHERE PLACA = PID;
        
        IF QTD <> 0 THEN
            SELECT COUNT(VENDIDO)
            INTO VQTD
            FROM CARRO_VENDA    
            WHERE PLACA = PID
            AND VENDIDO = 'N';    
            
            IF VQTD <> 0 THEN
                PERCF := ((PPER * VAL_C)/100);
                RES := PERCF + VAL_V;
                RETURN RES;
            ELSE
                RAISE ERRO_PERC;
                RES := -997;
            END IF;
        ELSE
            RAISE ERRO_EXIST; 
            RES := -999;
        END IF;
    ELSE
        RAISE ERRO_VEND;
        RES  := -998;
    END IF;

EXCEPTION
    WHEN ERRO_PERC THEN 
            DBMS_OUTPUT.PUT_LINE('Código do erro: '||RES);
            DBMS_OUTPUT.PUT_LINE('Percentual acima/abaixo do esperado!');
            ROLLBACK;
            RETURN RES;
    WHEN ERRO_EXIST THEN 
            DBMS_OUTPUT.PUT_LINE('Código do erro: '||RES);
            DBMS_OUTPUT.PUT_LINE('Placa não existe!');
            ROLLBACK;
            RETURN RES;
    WHEN ERRO_VEND THEN 
            DBMS_OUTPUT.PUT_LINE('Código do erro: '||RES);
            DBMS_OUTPUT.PUT_LINE('O carro já foi vendido!');
            ROLLBACK;
            RETURN RES;
    WHEN OTHERS THEN 
            DBMS_OUTPUT.PUT_LINE('Código do erro: '||RES);
            DBMS_OUTPUT.PUT_LINE('Descrição do erro: '||SQLERRM);
            ROLLBACK;
            RETURN RES;
END;