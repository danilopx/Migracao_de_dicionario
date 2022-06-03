// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MT120F
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor paulo bindo | Descricao - PE apos a gravacao do pedido de compras
// ---------+-------------------+-----------------------------------------------------------
// 16/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
user function MT120F()

	Local aArea  := GetArea()
	
	//ATUALIZA O CAMPO DE QUANTIDADE MO DE BENEFICIAMENTO NA SD4
	cPedCo := SC7->C7_NUM
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+cPedCo)
	While !Eof() .And. SC7->C7_NUM == cPedCo .And. SC7->C7_FILIAL == cFilAnt
		cOp 	:= SC7->C7__OPBNFC
		cProd 	:= SC7->C7_PRODUTO
		cPedido := SC7->C7_NUM
		If !Empty(cOP)
			dbSelectArea("SD4")
			dbSetOrder(2)
			If dbSeek(xFilial()+cOp+cProd)
				RecLock("SD4",.F.)
				D4__QTPCBN := U_CalcBnfc(cOp,cProd,cPedido,"C")+SC7->C7_QUANT
				SD4->(MsUnlock())
			EndIf
		EndIf
		dbSelectArea("SC7")
		dbSkip()
	End

	RestArea(aArea)
return
