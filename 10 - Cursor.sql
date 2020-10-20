------------------------CURSOR----------

 

SELECT * FROM HR.EMPLOYEES;
SELECT FIRST_NAME, EMAIL FROM HR.EMPLOYEES  WHERE DEPARTMENT_ID = 60;

 

-- CRIA UMA CÓPIA DA TABELA A PARTIR DO RESULTADO DE COLUNAS E LINHAS DO SELECT UTILIZADO
CREATE TABLE FUNCIONARIO AS SELECT * FROM HR.EMPLOYEES;

 

SELECT * FROM FUNCIONARIO;

 

------------------------------------------------------------------------------------

 

DECLARE
    var_first_name FUNCIONARIO.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME INTO var_first_name FROM FUNCIONARIO WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('NOME: ' || var_first_name);
    
    --RECORD SET
    -- CURSOR
    FOR RS IN (SELECT FIRST_NAME, EMAIL, SALARY AS SALARIO FROM FUNCIONARIO)
    LOOP
        DBMS_OUTPUT.PUT_LINE('NOME CURSOR: ' || RS.FIRST_NAME);
        DBMS_OUTPUT.PUT_LINE('EMAIL CURSOR: ' || RS.EMAIL);
        DBMS_OUTPUT.PUT_LINE('SALARIO CURSOR: ' || RS.SALARIO);
        
        IF RS.SALARIO > 5000 THEN
            DBMS_OUTPUT.PUT_LINE('SALARIO MAIOR QUE 5000 XXXXXXXXXXXXXXXX');
        END IF;
    END LOOP;
    
END;

 

 


CREATE OR REPLACE FUNCTION FUNC_AUMSALTODOS(P_PERC IN NUMBER)
RETURN NUMBER
IS
    V_NOVOSALARIO FUNCIONARIO.SALARY%TYPE;
BEGIN
    
    FOR RS IN (SELECT EMPLOYEE_ID, SALARY, DEPARTMENT_ID FROM FUNCIONARIO)
    LOOP

 

        V_NOVOSALARIO := RS.SALARY + (RS.SALARY * (P_PERC/100));
        IF V_NOVOSALARIO > 25000 THEN 
            V_NOVOSALARIO := 25000;
        END IF;
        UPDATE FUNCIONARIO SET SALARY = V_NOVOSALARIO 
              WHERE EMPLOYEE_ID = RS.EMPLOYEE_ID;

 

    END LOOP;
        COMMIT;
        RETURN 0;
END;

 

SELECT * FROM FUNCIONARIO;

 

DECLARE
    X NUMBER;
BEGIN
    X := FUNC_AUMSALTODOS(10);
    DBMS_OUTPUT.PUT_LINE('X = ' || X);
END;