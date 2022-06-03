#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SimuFrete³ Autor ³ Anderson Messias      ³ Data ³ 04/06/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao que calcula o frete e apresenta no pedido de venda  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SimuFrete()

//Preparando dados para calcular Frete do Pedido
Local oDlgTot

local _cTpCalc  := 'N'
local _lTDE     := .F.
local _cCep	    := SA2->A2_CEP
local _cEst	    := SF2->F2_EST
local _nPesProd := 0
local _cTransp  := M->C5_TRANSP
local _dEmissao := M->C5_EMISSAO

Local nTotDes   := 0
Local nTotPed   := 0

Local nPosTotal := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosDesc  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})

Local nX     	:= 0
Local nY        := 0
Local nMaxFor	:= Len(aCols)
Local nDescCab  := 0
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])
                        
Local _nTabTra   := "000000"
Local _nPesoCub  := 0
Local _nFrCal    := 0 
Local _nGris     := 0
Local _nAdValor  := 0 
Local _nVlPes    := 0 
Local _nAdPes    := 0 
Local _nFrTol    := 0 
Local _nTDE      := 0 
Local _nTRT      := 0 
Local _nTaxaCto  := 0 
Local _nValPeda  := 0 
Local _nOtrTaxa  := 0 
Local _nVlAdPeso := 0

If M->C5_TIPO $ 'B/D'
	DbSelectArea("SA2")
	DbSetOrder(1)
	if DbSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI)
		_cCep	:= SA2->A2_CEP
		_cEst	:= SF2->F2_EST
	endif
Else
	DbSelectArea("SA1")
	DbSetOrder(1)
	if DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
		_cCep	:= SA1->A1_CEP
		_cEst	:= SA1->A1_EST
		_lTDE   := SA1->A1_FRETED == "S"
	endif
Endif

If ( nTotPed == 0 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Soma as variaveis do aCols                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nY := 1 To 2
		For nX := 1 To nMaxFor
			If ( (lTestaDel .And. !aCols[nX][nUsado+1]) .Or. !lTestaDel )
				If ( nPosDesc > 0 .And. nPPrUnit > 0 .And. nPPrcVen > 0 .And. nPQtdVen > 0)
					If ( aCols[nX][nPPrUnit]==0 )
						nTotDes	+= aCols[nX][nPosDesc ]
					Else
						nTotDes += A410Arred(aCols[nX][nPPrUnit]*aCols[nX][nPQtdVen],"C6_VALDESC")-;
						A410Arred(aCols[nX][nPPrcVen]*aCols[nX][nPQtdVen],"C6_VALDESC")
					EndIf
				EndIf
				If ( nPosTotal > 0 )
					nTotPed	+=	aCols[nX][nPosTotal]
				EndIf
				If ( nPosTotal > 0 )
					//Procuro produto para pegar o peso
					DBSelectArea("SB1")
					DBSetOrder(1)
					if DBSeek(xFilial("SB1")+aCols[nX][nPProduto])
						_nPesProd += aCols[nX][nPQtdVen]*SB1->B1_PESO
					endif
				EndIf
			EndIf
		Next nX
		nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
		nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
		nDescCab := M->C5_DESC4
		nTotPed  -= M->C5_DESCONT
		nTotDes  += M->C5_DESCONT
		If nY == 1
			If FtRegraDesc(3,nTotPed+nTotDes,@M->C5_DESC4) == nDescCab
				Exit
			Else
				nTotPed	:=	0
				nTotDes	:=	0
			EndIf
		EndIf
	Next nY
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Soma as variaveis da Enchoice                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotPed += M->C5_FRETE
nTotPed += M->C5_SEGURO
nTotPed += M->C5_DESPESA
nTotPed += M->C5_FRETAUT

_aCalTrans := U_SeleFrete(nTotPed,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,_dEmissao,_lTDE,.T.)
// Retorno desta Funcao
// _aCalTrans[1][1]  	  // Transportador
// _aCalTrans[1][2]  	  // Codigo do Contrato
// _aCalTrans[1][3][1]    // Taxa Por Conhecimento
// _aCalTrans[1][3][2]    // Valor do Pedagio
// _aCalTrans[1][3][3]    // Outras Taxas
// _aCalTrans[1][3][4]    // Valor do Gris
// _aCalTrans[1][3][5]    // Valor do AdValorem
// _aCalTrans[1][3][6]    // Valor do Frete Peso
// _aCalTrans[1][3][7]    // Valor do AdValorem Quando Exceder o Peso
// _aCalTrans[1][3][8]    // Valor da Taxa Quando Exceder o Peso
// _aCalTrans[1][3][9]    // Valor  Total do Frete
// _aCalTrans[1][3][10]   // Valor  Do Frete Por Tonelagem
// _aCalTrans[1][3][11]   // Valor do Frete de Reentrega
// _aCalTrans[1][3][12]   // Valor do Frete De Devolucao
// _aCalTrans[1][3][13]   // Valor do T.E.D ( Taxa de Dificuldade de Entrega )
// _aCalTrans[1][3][14]   // Valor do T.R.T ( Taxa de Restricao ao Transito )
// _aCalTrans[1][3][15]   // Peso Utilizado no calculo do Frete
// _aCalTrans[1][4]  	  // Sequencia do Contrato
// _aCalTrans[1][5]  	  // Prazo de entrega
// _aCalTrans[1][6]  	  // Reentrega
// _aCalTrans[1][7]  	  // Devolução
// _aCalTrans[1][8]  	  // Perc Ajuste Automatico

if Len(_aCalTrans) > 0
	_nTabTra   := _aCalTrans[1][2]
	_nPesoCub  := _aCalTrans[1][3][15]
	_nFrCal    := _aCalTrans[1][3][9]
	_nGris     := _aCalTrans[1][3][4] 
	_nAdValor  := _aCalTrans[1][3][5]
	_nVlPes    := _aCalTrans[1][3][6]
	_nAdPes    := _aCalTrans[1][3][7]
	_nFrTol    := _aCalTrans[1][3][10]
	_nTDE      := _aCalTrans[1][3][13]
	_nTRT      := _aCalTrans[1][3][14]
	_nTaxaCto  := _aCalTrans[1][3][1]
	_nValPeda  := _aCalTrans[1][3][2]
	_nOtrTaxa  := _aCalTrans[1][3][3]
endif

DEFINE MSDIALOG oDlgTot FROM 09,0 TO 19,77 TITLE "Resumo do Frete Calculado" OF oMainWnd

@ 002,005 SAY "** ABAIXO VALORES CALCULADOS ***********************************************************************"	 	SIZE 350,07          OF oDlgTot PIXEL

@ 010,005 SAY "Peso Cubagem" 	SIZE 055,07          OF oDlgTot PIXEL
@ 018,005 MSGET _nPesoCub      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

@ 010,065 SAY "Tab Transp." 	SIZE 055,07          OF oDlgTot PIXEL
@ 018,065 MSGET _nTabTra		SIZE 055,09 WHEN .F. OF oDlgTot PIXEL 

@ 010,125 SAY "Total Calc." 	SIZE 055,07          OF oDlgTot PIXEL
@ 018,125 MSGET _nFrCal      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 010,185 SAY "Valor Gris"	 	SIZE 055,07          OF oDlgTot PIXEL
@ 018,185 MSGET _nGris      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 010,245 SAY "Ad Valorem" 		SIZE 055,07          OF oDlgTot PIXEL
@ 018,245 MSGET _nAdValor      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 030,005 SAY "Frete Peso" 		SIZE 055,07          OF oDlgTot PIXEL
@ 038,005 MSGET _nVlPes      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

@ 030,065 SAY "Ad. Valor Peso" 	SIZE 055,07          OF oDlgTot PIXEL
@ 038,065 MSGET _nVlAdPeso		      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 030,125 SAY "Ad. Peso"  		SIZE 055,07          OF oDlgTot PIXEL
@ 038,125 MSGET _nAdPes      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 030,185 SAY "fr Tonelada"	 	SIZE 055,07          OF oDlgTot PIXEL
@ 038,185 MSGET _nFrTol      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 030,245 SAY "T.D.E."	 		SIZE 055,07          OF oDlgTot PIXEL
@ 038,245 MSGET _nTDE   	   	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 050,005 SAY "T.R.T" 			SIZE 055,07          OF oDlgTot PIXEL
@ 058,005 MSGET _nTRT 	     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

@ 050,065 SAY "Taxa Conhecimento" SIZE 055,07          OF oDlgTot PIXEL
@ 058,065 MSGET _nTaxaCto      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 050,125 SAY "Pedagio"  		SIZE 055,07          OF oDlgTot PIXEL
@ 058,125 MSGET _nValPeda      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 050,185 SAY "Outras Taxas" 	SIZE 055,07          OF oDlgTot PIXEL
@ 058,185 MSGET _nOtrTaxa      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

@ 058,245 BUTTON OemToAnsi("Sair") SIZE 50,12 FONT oDlgTot:oFont ACTION oDlgTot:End() OF oDlgTot PIXEL

ACTIVATE MSDIALOG oDlgTot

Return
