#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	A100CABE.prw
=================================================================================
||   Funcao: 	A100CABE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		No momento da gera��o do cabe�alho da ordem de separa��o, permite  
|| 	gravar campos espec�ficos no cabe�alho da ordem de separa��o.
||		Sera utilizado para preenchimento de campos referentes ao novo Processo 
|| 	de CrossDocking.
||-------------------------------------------------------------------------------
||	VARIAVEIS
||-------------------------------------------------------------------------------
||		nOrigExp = Ordem de Separa��o ser� gerada por: 
||					1 - Pedido de Venda
||					2 - Nota Fiscal
||					3 - Ordem de Produ��o
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	25/09/2015
=================================================================================
=================================================================================
*/

USER FUNCTION A100CABE()

LOCAL CQUERY := ""

IF NORIGEXP = 1 .AND. CEMPANT + CFILANT = "0302"
	If SC9->C9_XFIL != CFILANT 
		CB7->CB7_PEDORI := SC9->C9_PEDORI
		CB7->CB7_CLIORI := SC9->C9_CLIORI
		CB7->CB7_LOJORI := SC9->C9_LOJORI
		
		/*
		|---------------------------------------------------------------------------------
		|	Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz
		|---------------------------------------------------------------------------------
		*/
		CQUERY := "UPDATE SC5 SET" + ENTER
		CQUERY += "	C5_STCROSS = 'PROSEP' " + ENTER 
		CQUERY += "FROM" + ENTER 
		CQUERY += "	" + RETSQLNAME("SC5") + " SC5"			+ ENTER 
		CQUERY += "WHERE" 									+ ENTER 
		CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER 
		CQUERY += "	C5_NUM = '" + SC9->C9_PEDORI + "' AND" 	+ ENTER
		CQUERY += "	C5_CLIENT = '" + SC9->C9_CLIORI + "' AND" 	+ ENTER
		CQUERY += "	D_E_L_E_T_ = ''"
		
		MEMOWRITE("A100CABE_update_sc5_crossdocking.sql",CQUERY)
		
		IF TCSQLEXEC(CQUERY) != 0 
			
			MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
								"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
			
		ENDIF 
	EndIf	
ENDIF
	
RETURN
