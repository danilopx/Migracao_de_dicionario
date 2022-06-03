
#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³PROGRAMA  ³LP_PCO_TAIFF³Autor  ³TOTVS S/A            ³Data  ³ 01.Set.10³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³Regra para atender a integracao - PCO                       ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³ Uso      ³Especifico: TAIFF                                           ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//--Pedido de Compra:
//-- Estoque			= BM_EST
//-- Estoque de Revenda	= BM_REV
//-- Despesa ADM 		= BM_DADM
//-- Investimento 		= BM_INVEST

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_pcoped                                                    ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³Regra para atender a contabilização do movimento empenhado   ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_pcoped()
Local cClasCon := ''
Local cConta   := ''
Local cProduto := ''
Local cRet     := ''
Local aArea	   := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSBM := SBM->(GetArea())

If IsInCallStack('MATA120')
	//--Caso o lancto. esteja sendo acionado
	//--atraves da inclusao do pedido de compras
	//--extrai a informacao da MsGetDados()
	cClasCon := GdFieldGet("C7_CLASCON")
	cConta   := GdFieldGet("C7_CONTA")
	cProduto := GdFieldGet("C7_PRODUTO")
Else
	//--Caso o lancto. esteja sendo acionado
	//--a partir de outra rotina (Reprocessamento, 
	//--por exemplo), obtem a informacao diretamente
	//--da tabela de pedidos:
	cClasCon := SC7->C7_CLASCON
	cConta   := SC7->C7_CONTA
	cProduto := SC7->C7_PRODUTO
EndIf

//--Posiciona no produto:
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1') + cProduto))

//--Posiciona no grupo:	
SBM->(DbSetOrder(1))
SBM->(DbSeek(xFilial('SBM')+SB1->B1_GRUPO))

If Empty(cConta)
	//--Regra de integração do PCO, para atender o grupo produto.
	If cClasCon == "1" 
		cRet := SBM->BM_EST
	ElseIf cClasCon == "2"
		cRet := SBM->BM_REV
	ElseIf cClasCon == "3"
		cRet := SBM->BM_DADM
	ElseIf cClasCon == "4"
		cRet := SBM->BM_INVEST
	EndIf
Else
	//--Regra de integração do PCO, para atender a conta do produto.
	If cClasCon $ '|1|2|3|4|'	
		cRet := cConta
	EndIf
Endif

//--Restaura o ambiente:
RestArea(aArea)
RestArea(aAreaSB1)
RestArea(aAreaSBM)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_pcocomp                                                   ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³Regra para contabilizar o valor do movimento do saldo        ³¹¹
¹¹³          ³realizado no planejamento orçamentario                       ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_pcocomp()
Local cClasCon := ''
Local cConta   := ''
Local cProduto := ''
Local cRet     := ''
Local aArea    := GetArea()
//Local aAreaSB1 := SB1->(GetArea())
//Local aAreaSBM := SBM->(GetArea())

If IsInCallStack('MATA103')
	//--Caso o lancto. esteja sendo acionado
	//--atraves da inclusao da nota fiscal 
	//--de entrada extrai a informacao da 
	//--MsGetDados()
	cClasCon := GdFieldGet("D1_CLASCON")
	//--cConta   := GdFieldGet("D1_CONTA")
	cProduto := GdFieldGet("D1_COD")
Else
	//--Caso o lancto. esteja sendo acionado
	//--a partir de outra rotina (Reprocessamento, 
	//--por exemplo), obtem a informacao diretamente
	//--da tabela de pedidos:
	cClasCon := SD1->D1_CLASCON
	//--cConta   := SD1->D1_CONTA
	cProduto := SD1->D1_COD
EndIf

//--Posiciona no produto:
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1') + cProduto))

//--Posiciona no grupo:	
SBM->(DbSetOrder(1))
SBM->(DbSeek(xFilial('SBM')+SB1->B1_GRUPO))

If Empty(cConta)
	If cClasCon == '1'
		cRet := if(!empty(SBM->BM_EST),SBM->BM_EST,"8101010001")
	ElseIf cClasCon == '2'
		cRet := if(!empty(SBM->BM_REV),SBM->BM_REV,"8101010001")
	ElseIf cClasCon == '3'
		cRet := if(!empty(SBM->BM_DADM),SBM->BM_DADM,"8101010001")
	ElseIf cClasCon == '4'
		cRet := if(!empty(SBM->BM_INVEST),SBM->BM_INVEST,"8101010001")
   Else
      cRet := "8101010001"
	EndIf
Else
	If cClasCon $ '|1|2|3|4|'
		cRet := cConta
	EndIf
EndIf
	
//--Restaura o ambiente:
RestArea(aArea)
//RestArea(aAreaSB1)
//RestArea(aAreaSBM)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_ppemp                                                     ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³Regra de integração do PCO, para atender a contabilizacao do ³¹¹
¹¹³          ³empenhado.                                                   ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_ppemp()
Local cClasCon := ''
Local cConta   := ''
Local cProduto := ''
Local cRet     := ''
Local aArea	   := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSBM := SBM->(GetArea())

If IsInCallStack('MATA120')
	//--Caso o lancto. esteja sendo acionado
	//--atraves da inclusao do pedido de compras
	//--extrai a informacao da MsGetDados()
	cClasCon := GdFieldGet("C7_CLASCON")
	cConta   := GdFieldGet("C7_CONTA")
	cProduto := GdFieldGet("C7_PRODUTO")
Else
	//--Caso o lancto. esteja sendo acionado
	//--a partir de outra rotina (Reprocessamento, 
	//--por exemplo), obtem a informacao diretamente
	//--da tabela de pedidos:
	cClasCon := SC7->C7_CLASCON
	cConta   := SC7->C7_CONTA
	cProduto := SC7->C7_PRODUTO
EndIf

//--Posiciona no produto:
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1') + cProduto))

//--Posiciona no grupo:	
SBM->(DbSetOrder(1))
SBM->(DbSeek(xFilial('SBM')+SB1->B1_GRUPO))

If Empty(cConta)
	If cClasCon == '1'
		cRet := SBM->BM_EST
	ElseIf cClasCon == '2'
		cRet := SBM->BM_REV
	ElseIf cClasCon == '3'
		cRet := SBM->BM_DADM
	ElseIf cClasCon == '4'
		cRet := SBM->BM_INVEST
	EndIf
Else
	If cClasCon $ '|1|2|3|4|'
		cRet := cConta
	EndIf
EndIf

//--Restaura ambiente:
RestArea(aArea)
RestArea(aAreaSB1)
RestArea(aAreaSBM)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_pcoPV                                                     ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³Pedido de venda                                              ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_pcoPV()
Local cProduto := ''
Local cRet     := ''
Local aArea    := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSBM := SBM->(GetArea())

If IsInCallStack('MATA410')
	cProduto := GDFieldGet('C6_PRODUTO')
Else
	cProduto := SC6->C6_PRODUTO
EndIf

SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial('SB1')+cProduto))

SBM->(DbSetOrder(1))
SBM->(DbSeek(xFilial('SBM')+SB1->B1_GRUPO))

cRet := SBM->BM_REC

//--Restaura ambiente:
RestArea(aArea)
RestArea(aAreaSB1)
RestArea(aAreaSBM)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_pcoFIPG                                                     ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³FINA050                                              ³¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_pcoFIPG
Local lRet     := .F.
Local aArea    := GetArea()
Local cPrefixos:= '|ST|RD|FIN|ND|MAN|'
Local cPre     := SE2->E2_PREFIXO

If cPre $ cPrefixos
   lRet := .T.
Else
   lRet := .F.
Endif   

//--Restaura ambiente:
RestArea(aArea)

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
¹¹ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿¹¹
¹¹³Fun??o    ³LP_PCOSRD                                                    ³¹¹
¹¹ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´¹¹
¹¹³Descri??o ³FINA050 - Retorna a Conta Orçamentária da tabela SRD (RV_DEBP)¹¹
¹¹ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ¹¹
¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹¹
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function LP_PCOSRD
Local cRet     := ''
Local aArea    := GetArea()

cRet = posicione("SRV", 1, xFilial("SRV")+SRD->RD_PD,"RV_DEBP")

If empty(cRet)
   cRet = "8101010001"
Endif

//--Restaura ambiente:
RestArea(aArea)

Return(cRet)




