#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAI          AUTOR: RODRIGO BRITO    DATA: 29/07/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: tabela ZAI custo produto
//| 
//| OBSERVACAO: 
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAI()
	AxCadastro("ZAI","Custo Produto","U_EXCLZAI()","U_MUDAZAI()")
Return NIL



//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Inclus�o/Alter��o da tabela ZAI
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAI()
	Local lRetorno := .T.      
	If (INCLUI)
		If ZAI->(DbSeek( xFilial("ZAI") + M->ZAI_CODPRO))
			Alert("Produto j� cadastrado!","Inconsist�ncia")
			lRetorno := .F.
		Endif
	Endif  
Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Exclus�o da tabela ZAI
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAI()
	Local lRetorno := .T.
Return lRetorno


