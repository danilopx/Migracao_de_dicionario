#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

//--------------------------------------------------------------------------------------------------------------
//ROTINA...: ACD100VE                                        
//DESCRICAO: PE para o projeto Cross Docking dos produtos da linha TAIFF acionado no estorno de OS no ínício da 
//           função, após checagem de existência de dados no arquivo de itens.
//DATA.....: 02/03/2015
//AUTOR....: CARLOS ALDAY TORRES               
//--------------------------------------------------------------------------------------------------------------
 
USER FUNCTION ACD100VE
Local lRetorno := .T.         
//Local _cAlias
LOCAL NTOTSC6	:= 0
LOCAL NTOTSC9	:= 0


IF CEMPANT + CFILANT = "0302"
		
	/*
	|---------------------------------------------------------------------------------
	|	Calcula a quantidade Vendida
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 										+ ENTER
	CQUERY += "	SUM(C6_QTDVEN) AS QTDVEN" 					+ ENTER 
	CQUERY += "FROM" 										+ ENTER 
	CQUERY += "	" + RETSQLNAME("SC6") 						+ ENTER
	CQUERY += "WHERE" 										+ ENTER
	CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER
	CQUERY += "	C6_NUM = '" + CB7->CB7_PEDIDO + "' AND" 		+ ENTER
	CQUERY += "	D_E_L_E_T_ = ''"							+ ENTER 
	CQUERY += "GROUP BY" 									+ ENTER 
	CQUERY += "	C6_NUM"
	
	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP")
		DBCLOSEAREA()
		
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()
	
	NTOTSC6 := TMP->QTDVEN
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
					
	/*
	|---------------------------------------------------------------------------------
	|	Calcula a quantidade Liberada
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 										+ ENTER
	CQUERY += "	SUM(C9_QTDLIB) AS QTDLIB" 					+ ENTER 
	CQUERY += "FROM" 										+ ENTER 
	CQUERY += "	" + RETSQLNAME("SC9") 						+ ENTER
	CQUERY += "WHERE" 										+ ENTER
	CQUERY += "	C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 	+ ENTER
	CQUERY += "	C9_PEDIDO = '" + CB7->CB7_PEDIDO + "' AND" 		+ ENTER
	CQUERY += "	C9_NFISCAL = '' AND" 						+ ENTER
	CQUERY += "	D_E_L_E_T_ = ''"							+ ENTER 
	CQUERY += "GROUP BY" 									+ ENTER 
	CQUERY += "	C9_PEDIDO"

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()
	
	NTOTSC9 := TMP->QTDLIB		
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()	
	
	/*
	|---------------------------------------------------------------------------------
	|	Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "UPDATE SC5 SET" + ENTER
	IF (NTOTSC6 - NTOTSC9) != 0  
		CQUERY += "	C5_STCROSS = 'LIBPAR'" 					+ ENTER 
	ELSE
		CQUERY += "	C5_STCROSS = 'LIBTOT'" 					+ ENTER
	ENDIF
	CQUERY += "FROM" + ENTER 
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5"			+ ENTER 
	CQUERY += "WHERE" 									+ ENTER 
	CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER 
	CQUERY += "	C5_NUM = '" + CB7->CB7_PEDORI + "' AND" 	+ ENTER
	CQUERY += "	C5_CLIENT = '" + CB7->CB7_CLIORI + "' AND" 	+ ENTER
	CQUERY += "	D_E_L_E_T_ = ''"
	
	MEMOWRITE("ACD100VE_update_sc5_crossdocking.sql",CQUERY)
	
	IF TCSQLEXEC(CQUERY) != 0 
		
		MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
							"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
		
	ENDIF 
	
ENDIF

Return (lRetorno)
