#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT120GRV.prw
=================================================================================
||   Funcao: 	MT120GRV
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Rotina de Inclusão, Alteração, Exclusão e Consulta dos Pedidos de Compras 
|| 	e Autorizações de Entrega
||		PARAMIXB[1] = Número do pedido 
||		PARAMIXB[2] = Controla a inclusão
||		PARAMIXB[3] = Controla a alteração
||		PARAMIXB[4] = Controla a exclusão
||
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:		17/02/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MT120GRV()

LOCAL CVARGLB		:= "A" + ALLTRIM(UsrRetName()) + cValtoChar(THREADID())
LOCAL AREGSC7		:= {}
LOCAL CQUERY 		:= ""
LOCAL NREG			:= 0 

IF PARAMIXB[4] 
	
	CQUERY := "SELECT C7_NUM, C7_PRODUTO, SUM(C7_QUANT) AS C7_QUANT, C7__OPBNFC FROM " + RETSQLNAME("SC7") + " WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' AND C7_NUM = '" + PARAMIXB[1] + "' AND C7__OPBNFC != '' AND D_E_L_E_T_ = '' GROUP BY C7_NUM, C7_PRODUTO, C7__OPBNFC"
	
	IF SELECT("BNF") > 0 
		DBSELECTAREA("BNF")
		DBCLOSEAREA()
	ENDIF 	
	TCQUERY CQUERY NEW ALIAS "BNF"
	DBSELECTAREA("BNF")
	DBGOTOP()
	COUNT TO NREG
	DBGOTOP()
	
	IF NREG <= 0 
		
		RETURN .T.
		
	ENDIF 
	
	WHILE BNF->(!EOF())
		
		AADD(AREGSC7,{BNF->C7_NUM, BNF->C7_PRODUTO, BNF->C7_QUANT, BNF->C7__OPBNFC})
		BNF->(DBSKIP())
		
	ENDDO
	
	PUTGLBVARS(CVARGLB,AREGSC7)
	
ENDIF 

RETURN .T.