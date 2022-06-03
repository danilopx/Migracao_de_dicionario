#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_FUNCONT.prw
=================================================================================
||   Funcao: 	INSCONTROLE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para Inserir registro de Controle de quantidades Liberadas na 
|| 	Tabela CONTROLE_QTDLIB.
|| 		Sera utilizada no PE MT440GR e M440TTS no processo de CrossDocking. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	17/11/2015
=================================================================================
=================================================================================
*/

USER FUNCTION INSCONTROLE(CPEDIDO,CITEM,CPRODUTO,NQTDLIB)

LOCAL CQUERY 	:= ""
LOCAL LRET		:= .T.

CQUERY := "INSERT" 				+ ENTER 
CQUERY += "INTO" 				+ ENTER 
CQUERY += "	CONTROLE_QTDLIB" 	+ ENTER 
CQUERY += "		VALUES ('" + CPEDIDO + "','" + CITEM + "','" + CPRODUTO + "'," + ALLTRIM(STR(NQTDLIB)) +",'')"

IF TCSQLEXEC(CQUERY) != 0 
	
	MSGALERT(OEMTOANSI(	"Erro ao tentar gerar Controle de Liberações!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
	LRET := .F.
	
ENDIF 

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_FUNCONT.prw
=================================================================================
||   Funcao: 	UPDCONTROLE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para Alterar registro de Controle de quantidades Liberadas na 
|| 	Tabela CONTROLE_QTDLIB.
|| 		Sera utilizada no PE MT440GR e M440TTS no processo de CrossDocking.
|| 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	17/11/2015
=================================================================================
=================================================================================
*/

USER FUNCTION UPDCONTROLE(CPEDIDO,CITEM,CPRODUTO,NQTDLIB)

LOCAL CQUERY 	:= ""
LOCAL LRET		:= .T.

CQUERY := "UPDATE" 								+ ENTER  
CQUERY += "	CONTROLE_QTDLIB" 					+ ENTER 
CQUERY += "SET" 								+ ENTER  
CQUERY += "	QTDLIB = " + ALLTRIM(STR(NQTDLIB))	+ ENTER 
CQUERY += "WHERE" 								+ ENTER  
CQUERY += "	PEDIDO	= '" + CPEDIDO + "' AND" 	+ ENTER  
CQUERY += "	ITEM = '" + CITEM + "' AND" 		+ ENTER 
CQUERY += "	PRODUTO = '" + CPRODUTO + "' AND"	+ ENTER
CQUERY += " D_E_L_E_T_ = ''"

IF TCSQLEXEC(CQUERY) != 0 
	
	MSGALERT(OEMTOANSI(	"Erro ao tentar alterar Controle de Liberações!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
	LRET := .F.
	
ENDIF 

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_FUNCONT.prw
=================================================================================
||   Funcao: 	DELCONTROLE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para Excluir registro de Controle de quantidades Liberadas na 
|| 	Tabela CONTROLE_QTDLIB.
|| 		Sera utilizada no PE MT440GR e M440TTS no processo de CrossDocking. 
|| 		Somente altera o campo D_E_L_E_T_ = '*' 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	17/11/2015
=================================================================================
=================================================================================
*/

USER FUNCTION DELCONTROLE(CPEDIDO,CITEM,CPRODUTO)

LOCAL CQUERY 	:= ""
LOCAL LRET		:= .T.

CQUERY := "UPDATE" 								+ ENTER  
CQUERY += "	CONTROLE_QTDLIB" 					+ ENTER 
CQUERY += "SET" 								+ ENTER  
CQUERY += "	D_E_L_E_T_ = '*'"					+ ENTER 
CQUERY += "WHERE" 								+ ENTER  
CQUERY += "	PEDIDO	= '" + CPEDIDO + "' AND" 	+ ENTER  
CQUERY += "	ITEM = '" + CITEM + "' AND" 		+ ENTER 
CQUERY += "	PRODUTO = '" + CPRODUTO + "' AND"	+ ENTER 
CQUERY += " D_E_L_E_T_ = ''"

IF TCSQLEXEC(CQUERY) != 0 
	
	MSGALERT(OEMTOANSI(	"Erro ao tentar deletar Controle de Liberações!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
	LRET := .F.
	
ENDIF 

RETURN(LRET)