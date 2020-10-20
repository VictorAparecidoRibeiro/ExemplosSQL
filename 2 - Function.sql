-- Criando a função

create or replace 
FUNCTION FUNC_RETORNADEPT(P_IDDEPT IN NUMBER)
RETURN VARCHAR2
IS
  QTDE DEPARTMENTS.DEPARTMENT_ID%TYPE;
  RETORNO DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN

RETORNO := 'Falha na execução';

    IF P_IDDEPT IS NOT NULL AND P_IDDEPT > 0 AND P_IDDEPT <=9999 THEN
        SELECT COUNT(*) INTO QTDE 
          FROM DEPARTMENTS 
            WHERE DEPARTMENT_ID = P_IDDEPT;
            
         IF QTDE = 1 THEN
            SELECT DEPARTMENT_NAME INTO RETORNO
                  FROM DEPARTMENTS 
                        WHERE DEPARTMENT_ID = P_IDDEPT;
         ELSE
              RETORNO := 'ID não existe';
         END IF;
            
    ELSE 
        RETORNO := 'Valor do ID fora do padrão';
    END IF;
    
    RETURN RETORNO;
END; 

-- Chamando a função

DECLARE
	X DEPARTMENTS.DEPARTMENT_NAME%TYPE;
	
	BEGIN
		X := FUNC_RETORNADEPT(10);
		dbms_output.put_line('Retorno = '||X);
	END;

	-- CRIANDO FUNÇÃO
	
	create or replace 
FUNCTION FUNC_RETMAXSALARYSOB(P_IDJOB IN VARCHAR2)
RETURN NUMBER
IS
  QTDE NUMBER;
  RETORNO EMPLOYEES.SALARY%TYPE;
BEGIN
RETORNO := -997;
    IF P_IDJOB IS NOT NULL THEN
        SELECT COUNT(*) INTO QTDE 
          FROM JOBS 
            WHERE JOB_ID = P_IDJOB;
            
         IF QTDE = 1 THEN
            SELECT MAX(SALARY) INTO RETORNO
                  FROM EMPLOYEES 
                        WHERE JOB_ID = P_IDJOB;
         ELSE
              RETORNO := 997;
         END IF;
            
    ELSE 
        RETORNO := 997;
    END IF;
    
    RETURN RETORNO;
END; 


// CHAMANDO FUNCAO
DECLARE
	X EMPLOYEES.SALARY%TYPE;
	
	BEGIN
		X := FUNC_RETMAXSALARYSOB('AD_PRES');
    
    
       dbms_output.put_line(X);   
		
	END;

