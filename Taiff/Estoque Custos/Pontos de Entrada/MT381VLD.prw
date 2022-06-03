#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	MT381VLD.prw
=================================================================================
||   Funcao: 	MT381VLD
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de Entrada, localizado na valida��o de Ajuste Empenho Mod. 2, 
|| 	utilizado para confirmar a grava��o do Ajuste Empenho Modelo 2.
|| 		Chamado pela fun��o A381TudoOk(Valida��es gerais do Empenho Mod.2), 
|| 	no in�cio das valida��es, ap�s a confirma��o da tela.
|| 		Ira verificar se eh uma chamado da fun��o TFCOMBNF. Se for avisa para 
||	utilizar o bot�o cancelar para sair da tela.
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

USER FUNCTION MT381VLD()

LOCAL LRET 	:= .T.
LOCAL L31	:= .T.
LOCAL N		:= 0
Local aAreaCB7	:= CB7->(GetArea())

IF ISINCALLSTACK("U_TFCOMBNF")
	MESSAGEBOX('Utilize o bot�o "FECHAR" para sair da tela!',"ATEN��O",64)
	LRET := .F.
ENDIF

/*
|---------------------------------------------------------------------------------
|	Este trecho de valida��o estava sendo utilizado no PE MT381LOK, mas n�o estava
|	funcional no mesmo.
|	Edson Hornberger - 15/04/2016
|---------------------------------------------------------------------------------
*/
IF ALTERA
	
	FOR N:=1 TO LEN(ACOLS)
		DBSELECTAREA("SD4")
		DBSETORDER(2)
		IF DBSEEK(XFILIAL("SD4") + SD4->D4_OP + BUSCACOLS("D4_COD"))
			L31 := !(SD4->D4_LOCAL  == "11")
		ENDIF 
		IF BUSCACOLS("D4__QTBNFC") > 0 .OR. BUSCACOLS("D4__QTPCBN") > 0 .AND. L31  
			LRET := .F.
		ENDIF
	NEXT N 

	IF !LRET
		MSGSTOP("ESTA � UMA OP DE BENEFICIAMENTO E J� TEVE MATERIAL ENVIADO AO FORNECEDOR OU PEDIDO DE COMPRAS COLOCADO, A EXCLUSAO DE EMPENHO N�O SER� PERMITIDA!","MT381VLD")
	ENDIF

ENDIF

/* Valida se a OP est� em processo de separa��o n�o permitindo a manuten��o do empenho */
If LRET .AND. CB7->(FIELDPOS("CB7__PRESE")) > 0
	CB7->(DbSetOrder(5))
	If CB7->(DbSeek( xFilial("CB7") + cOp ))
		MsgStop("Altera��o de empenho n�o permitida, uma vez que esta OP j� est� em processo separa��o atraves da ONDA: " + CB7->CB7__PRESE,"MT381VLD")
		LRET := .F.
	EndIf
EndIF

RestArea(aAreaCB7)	
	

RETURN(LRET)