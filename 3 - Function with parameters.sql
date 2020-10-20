create or replace
FUNCTION FUNC_INSERIR_CORVIC(

P_IDCOR IN NUMBER, 
P_NOMECOR COR_VIC.NOME%TYPE, 
P_HEXACOR COR_VIC.COD_COR_HEXA%TYPE

)

RETURN VARCHAR2
IS
  QTDE COR_VIC.ID%TYPE;
  RETORNO VARCHAR2(120);
BEGIN
 
 IF P_IDCOR < 0 OR P_IDCOR > 9999999 THEN
		RETORNO := 'Range de ID Inválido ' || P_IDCOR;
 ELSE 
    SELECT COUNT(*) INTO QTDE FROM COR_VIC WHERE ID = P_IDCOR;
    IF QTDE >= 1 THEN
		QTDE :=0;
		RETORNO := 'ID Já existente ' || P_IDCOR;
    END IF;
 END IF;
 
    IF LENGTH(P_NOMECOR) > 120 OR P_NOMECOR IS NULL  THEN
		RETORNO := 'Tamanho da cor ultrapassa 120 caracteres ou está nulo ';
    ELSE  
      SELECT COUNT(*) INTO QTDE FROM COR_VIC WHERE NOME = P_NOMECOR;
     
      IF QTDE >= 1 THEN 
		QTDE :=0;
		RETORNO := 'Nome da cor já cadastrada ' || P_NOMECOR;
      END IF;
      
    END IF;
      
      IF LENGTH(P_HEXACOR) > 7 OR P_HEXACOR IS NULL  THEN
	    RETORNO := 'HEXA da cor ultrapassa 7 caracteres ou está nulo ';
  
    ELSE  
      SELECT COUNT(*) INTO QTDE FROM COR_VIC WHERE COD_COR_HEXA = P_HEXACOR;
      
      IF QTDE >= 1 THEN
		QTDE :=0;
		RETORNO := 'HEXA da cor já cadastrada ' || P_HEXACOR;
      END IF;
      
    END IF;

    IF RETORNO IS NULL THEN
      INSERT INTO COR_VIC VALUES(P_IDCOR, P_NOMECOR, P_HEXACOR);
    END IF;
     
    COMMIT; 
     
    RETURN RETORNO;
END; 
      
DECLARE
	X VARCHAR2(120);     
BEGIN
    X := FUNC_INSERIR_CORVIC(1, 'null', '222');
    dbms_output.put_line('Retorno = '||X);
END;
   
   