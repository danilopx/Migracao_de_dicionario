// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : A250ENOK
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 24/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"


user function A250ENOK()
	Local lRet250 	:= .T. //VARIAVEL RETORNO
	Local lTRet250	:= .T. //VARIAVEL MATERIAL OU PEDIDO DE COMPRAS ENVIADO 100%
	Local lPCRet250	:= .T. //VARIAVEL PEDIDO DE COMPRAS PENDENTE
	Local lPVRet250	:= .T. //VARIAVEL PEDIDO DE VENDAS PENDENTE
	Local aArea		:=GetArea("SD4")

	cOp := SD3->D3_OP

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial()+cOp)
	While !Eof() .And. AllTrim(SD4->D4_OP) == AllTrim(cOp)

		If SD4->D4__QTBNFC == SD4->D4_QTDEORI .Or. SD4->D4__QTPCBN == SD4->D4_QTDEORI
			lTRet250 	:= .F.
			lRet250  	:= .F.
		ElseIf SD4->D4__QTBNFC > (SD4->D4_QTDEORI-SD4->D4_QUANT)
			lPVRet250	:= .F.
			lRet250  	:= .F.
		ElseIf SD4->D4__QTPCBN > (SD4->D4_QTDEORI-SD4->D4_QUANT)
			lPCRet250	:= .F.
			lRet250  	:= .F.
		EndIf
		dbSkip()
	End

	If 	!lRet250
		If !lTRet250
			MsgStop("Esta é uma OP de beneficiamento e já teve material enviado ao fornecedor ou um pedido de compras colocado, o encerramento não será permitido!","A250ENOK")
		ElseIf !lPVRet250
			MsgStop("Esta é uma OP de beneficiamento e já teve material enviado ao fornecedor , o encerramento não será permitido!","A250ENOK")
		ElseIf !lPCRet250
			MsgStop("Esta é uma OP de beneficiamento e já teve um pedido de compras colocado , o encerramento não será permitido!","A250ENOK")
		EndIf
	EndIf

	RestArea(aArea)
Return(lRet250)



