// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : M265VEST
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor paulo bindo | Descricao ponto de entrada que valida o estorno do enderecamento
// ---------+-------------------+-----------------------------------------------------------
// 30/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"


user function M265VEST()
	local nRet := ParamIXB[1]
	Local lOk := .F.
	Local aSD3Alias	:= SD3->(GetArea()) 
	Local aSD4Alias	:= SD4->(GetArea()) 
	Local aSC2Alias	:= SC2->(GetArea()) 
	
	Local aSDBalias	:= SDB->(GetArea()) 
	Local aSBFalias	:= SBF->(GetArea()) 

//VALIDA SE O MATERIAL VEIO DE UM BENEFICIAMENTO E SE NAO TEM OP BAIXADA PARA ESTE ITEM
	dbSelectArea("SD3")
	dbSetOrder(15)
	If dbSeek(xFilial()+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_PRODUTO)
		lOk := .F.
		//SOMENTE QUANDO FOR MOVIMENTACAO POR NOTA DE ENTRADA AMARRADA A UMA OP
		While !SD3->(Eof()) .AND.	 SD3->(D3_FILIAL + D3__NFEBN + D3__SNFEBN + D3__FORNEC + D3_COD) =(xFilial()+SDA->DA_DOC+SDA->DA_SERIE+SDA->DA_CLIFOR+SDA->DA_PRODUTO)
			If SD3->D3_CF == "RE5" .AND. SD3->D3_NUMSEQ=SDA->DA_NUMSEQ
				lOk := .T.
				Exit
			EndIf
			SD3->(DbSkip())
		End
		
		If lOk
		//VERIFICA A QUANTIDADE EMPENHADA NA OP
			dbSelectArea("SD4")
			dbSetOrder(2)
			If dbSeek(xFilial()+SD3->D3_OP+SD3->D3_COD)
				nQtdEmp := SD4->D4_QUANT
			EndIf
						//VERIFICA A QUANTIDADE PRODUZIDA DA OP
			dbSelectArea("SC2")
			dbSetOrder(1)
			If dbSeek(xFilial()+SD3->D3_OP)
				nQtdProd := SC2->C2_QUJE+SC2->C2_PERDA
				nPropor  := SD4->D4_QTDEORI/SC2->C2_QUANT //PROPORCAO ITEM X PA
				nQtdReal := nQtdProd/nPropor
				
							//VERIFICA SE A OP FOI BAIXADA POR ESTA NOTA
				If   ((SD4->D4_QTDEORI-SD4->D4_QUANT-SD3->D3_QUANT)/nPropor) < nQtdReal
					nRet := 2
				EndIf
			EndIf
		EndIf
	EndIf

	If nRet == 2
		MsgStop("Este endereçamento esta relacionado a uma OP BAIXADA, estorne a baixa da OP primeiro","M265VEST")
	EndIf

SD3->(RestArea(aSD3Alias))
SD4->(RestArea(aSD4Alias))
SC2->(RestArea(aSC2Alias))

SDB->(RestArea(aSDBalias))
SBF->(RestArea(aSBFalias))

return(nRet)

