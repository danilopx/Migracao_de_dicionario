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
|| 		Ponto de Entrada, localizado na validação de Ajuste Empenho Mod. 2, 
|| 	utilizado para confirmar a gravação do Ajuste Empenho Modelo 2.
|| 		Chamado pela função A381TudoOk(Validações gerais do Empenho Mod.2), 
|| 	no início das validações, após a confirmação da tela.
|| 		Ira verificar se eh uma chamado da função TFCOMBNF. Se for avisa para 
||	utilizar o botão cancelar para sair da tela.
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
	MESSAGEBOX('Utilize o botão "FECHAR" para sair da tela!',"ATENÇÃO",64)
	LRET := .F.
ENDIF

/*
|---------------------------------------------------------------------------------
|	Este trecho de validação estava sendo utilizado no PE MT381LOK, mas não estava
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
		MSGSTOP("ESTA É UMA OP DE BENEFICIAMENTO E JÁ TEVE MATERIAL ENVIADO AO FORNECEDOR OU PEDIDO DE COMPRAS COLOCADO, A EXCLUSAO DE EMPENHO NÃO SERÁ PERMITIDA!","MT381VLD")
	ENDIF

ENDIF

/* Valida se a OP esté em processo de separação não permitindo a manutenção do empenho */
If LRET .AND. CB7->(FIELDPOS("CB7__PRESE")) > 0
	CB7->(DbSetOrder(5))
	If CB7->(DbSeek( xFilial("CB7") + cOp ))
		MsgStop("Alteração de empenho não permitida, uma vez que esta OP já está em processo separação atraves da ONDA: " + CB7->CB7__PRESE,"MT381VLD")
		LRET := .F.
	EndIf
EndIF

RestArea(aAreaCB7)	
	

RETURN(LRET)