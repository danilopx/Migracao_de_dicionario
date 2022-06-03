#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TRYEXCEPTION.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	VINCMANUAL.prw
=================================================================================
||   Funcao: 	VINCMANUAL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para preenchimento do campo de Vinculo de Pedidos Bonificados
||	para os Pedidos incluidos manualmente.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	11/12/2015
=================================================================================
=================================================================================
*/

USER FUNCTION VINCMANUAL(CMARCA)
	
LOCAL CQUERY 	:= ""
LOCAL BERROR	:= { |OERROR| SHOWERROR(OERROR) }
LOCAL OERROR

DEFAULT CMARCA := "TAIFF"

CURSORWAIT()
	
TRYEXCEPTION USING BERROR

	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP")
		DBCLOSEAREA()
		
	ENDIF 
	
	/*
	|---------------------------------------------------------------------------------
	|	QUERY COM TODOS OS PEDIDOS EM ABERTO QUE TENHAM VINCULO PELO PORTAL
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 															+ ENTER 
	CQUERY += "	C5_X_PVBON," 													+ ENTER 	
	CQUERY += "	C5_NUM," 															+ ENTER 	
	CQUERY += "	C5_NUMOLD," 														+ ENTER
	CQUERY += "	(" 																	+ ENTER 	
	CQUERY += "		SELECT" 														+ ENTER  
	CQUERY += "			C5_NUMOLD" 												+ ENTER  
	CQUERY += "		FROM" 															+ ENTER  
	CQUERY += "			" + RETSQLNAME("SC5") + " TMP" 						+ ENTER  
	CQUERY += "		WHERE" 														+ ENTER  
	CQUERY += "			C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 		+ ENTER  
	CQUERY += "			C5_NUM = RTRIM(SC5.C5_X_PVBON) AND" 				+ ENTER  
	CQUERY += "			D_E_L_E_T_ = ''" 										+ ENTER 
	CQUERY += "	) AS 'OLDVEN'"													+ ENTER 
	CQUERY += "FROM" 																+ ENTER  
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 								+ ENTER 
	CQUERY += "WHERE" 																+ ENTER  
	CQUERY += "	C5_FILIAL		= '" + XFILIAL("SC5") + "'			AND" 	+ ENTER 
	CQUERY += "	C5_X_PVBON	!= ''			AND" 								+ ENTER  
	CQUERY += "	C5_BLQ			= ''			AND" 								+ ENTER  
	CQUERY += "	C5_CLASPED	= 'X'			AND" 								+ ENTER  
	CQUERY += "	C5_NOTA		= ''			AND" 								+ ENTER  
	CQUERY += "	C5_NUMOLD		!= ''			AND" 								+ ENTER  
	CQUERY += "	C5_XITEMC		= '" + CMARCA + "'		AND" 					+ ENTER 
	CQUERY += "	C5_NUMOLD		LIKE '%MAN%'	AND " 								+ ENTER 
	CQUERY += "	D_E_L_E_T_	= ''" 												+ ENTER 
	CQUERY += "ORDER BY" 															+ ENTER 
	CQUERY += "	C5_X_PVBON"
	
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	
	WHILE TMP->(!EOF())
			
		DBSELECTAREA("SC5")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SC5") + TMP->C5_NUM)
			
			IF RECLOCK("SC5",.F.)
				
				SC5->C5_X_PVBON := TMP->OLDVEN
				MSUNLOCK()
				
			ENDIF
			
		ENDIF
		
		DBSELECTAREA("SC5")
		DBORDERNICKNAME("SC5NUMOLD")
		IF DBSEEK(XFILIAL("SC5") + TMP->OLDVEN)
			
			IF RECLOCK("SC5",.F.)
				
				SC5->C5_X_PVBON := IIF(EMPTY(ALLTRIM(SC5->C5_X_PVBON)), ALLTRIM(TMP->C5_NUMOLD), ALLTRIM(SC5->C5_X_PVBON) + "/" + ALLTRIM(TMP->C5_NUMOLD))				
				MSUNLOCK()
				
			ENDIF 
			
		ENDIF 
		
		TMP->(DBSKIP()) 
		
	ENDDO
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
	MSGINFO("Processo Finalizado!")	

CATCHEXCEPTION USING OERROR
		
	APMSGINFO("Houve um erro de Execução conforme mensagem anterior." + ENTER + "Tente novamente ou entre com os dados manualmente!", "Error Captured")
	
ENDEXCEPTION

CURSORARROW()
		
RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	VINCMANUAL.prw
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION SHOWERROR(OERROR)
	
	APMSGSTOP( OERROR:DESCRIPTION, "Error Captured" )
	CURSORARROW()
	BREAK
	
RETURN

