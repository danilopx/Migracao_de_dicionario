#include "Protheus.ch"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFAT010  ³ Autor ³ Richard Nahas Cabral  ³ Data ³24/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Relatorio de metas de vendas x realizado                   ³±±
±±³          ³ Customizado Taiff                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT010()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cPerg    := "RFT010"  // Pergunta do Relatorio

	If ! Pergunte(cPerg,.T.)
		Return
	EndIf

	Processa({||Planilha()})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ Planilha ³ Autor ³ Richard Nahas Cabral  ³ Data ³30/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Gera planilha Excel                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Planilha()

	Local aVendas     := { 0, 0, 0 }
	Local aDevol      := { 0, 0, 0 }

	Local bWhile      := { || .T. }

	Local cString     := "SCT"  // Alias utilizado na Filtragem
	Local cQuery      := ""
	Local cEstoq 	  := If( (MV_PAR18 == 1),"'S'",If( (MV_PAR18 == 2),"'N'","'S','N'" ) )
	Local cDupli 	  := If( (MV_PAR17 == 1),"'S'",If( (MV_PAR17 == 2),"'N'","'S','N'" ) )

	Local nValor      := 0
	Local nValReal    := 0
	Local nValMeta    := 0
	Local nQtdReal    := 0
	Local nLoop		  := 0
	Local nX		  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³                                                          ³
//³ mv_par01            // Dt. emissao de ?                  ³
//³ mv_par02            // Dt. emissao ate ?                 ³
//³ mv_par03            // Vendedor de ?                     ³
//³ mv_par04            // Vendedor ate ?                    ³
//³ mv_par05            // Tipo de ?                         ³
//³ mv_par06            // Tipo ate ?                        ³
//³ mv_par07            // Grupo de ?                        ³
//³ mv_par08            // Grupo ate ?                       ³
//³ mv_par09            // Considera devolucao Sim/Nao       ³
//³ mv_par10            // Dt. emissao de ?                  ³
//³ mv_par11            // Dt. emissao ate ?                 ³
//³ MV_PAR16            // Moeda ?                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea(cString)
	ProcRegua(LastRec())
	dbSetOrder(1)
	dbSeek(xFilial())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Logica para SQL                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAliasSCT := GetNextAlias()

	aStruSCT := SCT->( dbStruct() )

	lQuery := .T.

	cQuery := "SELECT CT_DOC,CT_SEQUEN,CT_TIPO,CT_GRUPO,CT_CATEGO,CT_PRODUTO,CT_GERENTE,CT_VEND,CT_REGIAO,CT_MOEDA,CT_DESCRI,CT_GRPVEN,CT_CLIENTE,CT_LOJA,CT_PRMED,CT_CSTMED,CT_DATA,CT_VALOR,CT_QUANT "
	cQuery += "FROM "
	cQuery += RetSQLName("SCT")+" SCT "
	cQuery += "WHERE CT_FILIAL = '" + xFilial("SCT") + "' AND "
	cQuery += "CT_VEND   >= '" + MV_PAR03 + "' AND "
	cQuery += "CT_VEND   <= '" + MV_PAR04 + "' AND "
	cQuery += "CT_TIPO   >= '" + MV_PAR05 + "' AND "
	cQuery += "CT_TIPO   <= '" + MV_PAR06 + "' AND "
	cQuery += "CT_GRUPO  >= '" + MV_PAR07 + "' AND "
	cQuery += "CT_GRUPO  <= '" + MV_PAR08 + "' AND "
	cQuery += "CT_GERENTE>= '" + MV_PAR12 + "' AND "
	cQuery += "CT_GERENTE<= '" + MV_PAR13 + "' AND "
	cQuery += "CT_DOC    >= '" + MV_PAR14 + "' AND "
	cQuery += "CT_DOC    <= '" + MV_PAR15 + "' AND "
	cQuery += "CT_DATA   >= '" + DToS(MV_PAR10) + "' AND "
	cQuery += "CT_DATA   <= '" + DToS(MV_PAR11) + "' AND "
	cQuery += "SCT.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CT_FILIAL, CT_DOC, CT_SEQUEN"

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCT,.T.,.T.)

	For nLoop := 1 To Len( aStruSCT )
		If aStruSCT[ nLoop, 2 ] <> "C" .And. !Empty( ( cAliasSCT )->( FieldPos( aStruSCT[ nLoop, 1 ] ) ) )
			TcSetField(cAliasSCT,aStruSCT[ nLoop, 1 ],aStruSCT[ nLoop, 2 ],aStruSCT[ nLoop, 3 ],aStruSCT[ nLoop, 4 ] )
		EndIf
	Next nLoop

	bWhile := { || !( cAliasSCT )->( Eof() ) }

	nValor := 0
	nQuant := 0


	aDetalhes := {}

	Do While Eval( bWhile )


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chama a funcao de calculo das vendas                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aVendas := TaiffNfVendas(4,(cAliasSCT)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasSCT)->CT_REGIAO,(cAliasSCT)->CT_TIPO,(cAliasSCT)->CT_GRUPO,(cAliasSCT)->CT_PRODUTO,MV_PAR16,(cAliasSCT)->CT_CLIENTE,(cAliasSCT)->CT_LOJA,"",,cDupli,cEstoq,(cAliasSCT)->CT_GRPVEN,(cAliasSCT)->CT_CATEGO,(cAliasSCT)->CT_GERENTE)

		aDevol := { 0,0,0 }

		If MV_PAR09 == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Chama a funcao de calculo das devolucoes de venda            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aDevol := TaiffDevol(4,(cAliasSCT)->CT_VEND,MV_PAR01,MV_PAR02,(cAliasSCT)->CT_REGIAO,(cAliasSCT)->CT_TIPO,(cAliasSCT)->CT_GRUPO,(cAliasSCT)->CT_PRODUTO,MV_PAR16,(cAliasSCT)->CT_CLIENTE,(cAliasSCT)->CT_LOJA,,cDupli,cEstoq,(cAliasSCT)->CT_GRPVEN,(cAliasSCT)->CT_CATEGO,(cAliasSCT)->CT_GERENTE)
		EndIf

		nValMeta := xMoeda( ( cAliasSCT )->CT_VALOR, ( cAliasSCT )->CT_MOEDA, MV_PAR16, ( cAliasSCT )->CT_DATA )

		Aadd(aDetalhes,Array(23))

		nValReal := aVendas[ 1 ] - aDevol[ 1 ]
		nQtdReal := aVendas[ 2 ] - aDevol[ 2 ]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Jogando em Arrays para computar o valor total e pegar o % de valor vendido pelo total³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aDetalhes[Len(aDetalhes),01] := ( cAliasSCT )->CT_DOC + " - " + ( cAliasSCT )->CT_DESCRI
		aDetalhes[Len(aDetalhes),02] := ( cAliasSCT )->CT_SEQUEN
		aDetalhes[Len(aDetalhes),03] := {( cAliasSCT )->CT_VEND,If(!Empty(( cAliasSCT )->CT_VEND),Posicione("SA3",1,xFilial("SA3")+( cAliasSCT )->CT_VEND,"A3_NOME"),"")}
		aDetalhes[Len(aDetalhes),04] := {( cAliasSCT )->CT_GRPVEN,If(!Empty(( cAliasSCT )->CT_GRPVEN),Posicione("ACY",1,xFilial("ACY")+( cAliasSCT )->CT_GRPVEN,"ACY_DESCRI"),"")}
		aDetalhes[Len(aDetalhes),05] := {( cAliasSCT )->CT_CATEGO,If(!Empty(( cAliasSCT )->CT_CATEGO),Posicione("ACU",1,xFilial("ACU")+( cAliasSCT )->CT_CATEGO,"ACU_DESC")  ,"")}
		aDetalhes[Len(aDetalhes),06] := ( cAliasSCT )->CT_GRUPO
		aDetalhes[Len(aDetalhes),07] := ( cAliasSCT )->CT_CSTMED
		aDetalhes[Len(aDetalhes),08] := ( cAliasSCT )->CT_QUANT
		aDetalhes[Len(aDetalhes),09] := nQtdReal
		aDetalhes[Len(aDetalhes),10] := nQtdReal / ( cAliasSCT )->CT_QUANT * 100
		aDetalhes[Len(aDetalhes),11] := nValMeta
		aDetalhes[Len(aDetalhes),12] := nValReal
		aDetalhes[Len(aDetalhes),13] := nValReal / nValMeta * 100
		aDetalhes[Len(aDetalhes),14] := 0
		aDetalhes[Len(aDetalhes),15] := ( cAliasSCT )->CT_DATA
		aDetalhes[Len(aDetalhes),16] := ( cAliasSCT )->CT_REGIAO
		aDetalhes[Len(aDetalhes),17] := {( cAliasSCT )->CT_CLIENTE	+ ( cAliasSCT )->CT_LOJA,If(!Empty(( cAliasSCT )->CT_CLIENTE),Posicione("SA1",1,xFilial("SA1")+( cAliasSCT )->CT_CLIENTE+( cAliasSCT )->CT_LOJA,"A1_NOME"),"")}
		aDetalhes[Len(aDetalhes),18] := {( cAliasSCT )->CT_PRODUTO,If(!Empty(( cAliasSCT )->CT_PRODUTO),Posicione("SB1",1,xFilial("SB1")+( cAliasSCT )->CT_PRODUTO,"B1_DESC"),"")}
		aDetalhes[Len(aDetalhes),19] := ( cAliasSCT )->CT_TIPO
		aDetalhes[Len(aDetalhes),20] := ( cAliasSCT )->CT_PRMED
		aDetalhes[Len(aDetalhes),21] := nValReal / nQtdReal
		aDetalhes[Len(aDetalhes),22] := (nValReal / nQtdReal) / ( cAliasSCT )->CT_PRMED * 100
		aDetalhes[Len(aDetalhes),23] := {( cAliasSCT )->CT_GERENTE	,If(!Empty(( cAliasSCT )->CT_GERENTE),Posicione("SA3",1,xFilial("SA3")+( cAliasSCT )->CT_GERENTE,"A3_NOME"),"")}

		( cAliasSCT )->( dbSkip() )

	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Classificar por valor realizado conforme planilha enviada por JA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//nValorInv := 999999999999999
//aSort(aDetalhes,,,{ |x,y| x[1]+Strzero(nValorInv-(x[12]*100),15)+X[2] < y[1]+Strzero(nValorInv-(y[12]*100),15)+y[2] })

	aTotDoc := {}
	For nX := 1 to Len(aDetalhes)

		nPosTotDoc := Ascan(aTotDoc,{|x|x[1] = aDetalhes[nX,1]})

		If Empty(nPosTotDoc)
			Aadd(aTotDoc, {aDetalhes[nX,1],0,0,0,0,0,0,0,0})
			nPosTotDoc := Len(aTotDoc)
		Endif
		aTotDoc[nPosTotDoc,2] += aDetalhes[nX,08]
		aTotDoc[nPosTotDoc,3] += aDetalhes[nX,09]
		aTotDoc[nPosTotDoc,4] += aDetalhes[nX,11]
		aTotDoc[nPosTotDoc,5] += aDetalhes[nX,12]
		aTotDoc[nPosTotDoc,6] += aDetalhes[nX,20]
		aTotDoc[nPosTotDoc,7] += aDetalhes[nX,21]
		aTotDoc[nPosTotDoc,8] += If(Empty(aDetalhes[nX,05,01]),0,1)
		aTotDoc[nPosTotDoc,9] += If(Empty(aDetalhes[nX,18,01]),0,1)

	Next

	cDoc := ""

	cArquivo := GetMv("MV_PATHPLA",,"C:\Planilha\")+GetMv("MV_PLANMET",,"MetasVendas.csv")
	IF FILE( cArquivo )
		FERASE( cArquivo )
	EndIf
	AcaLog(cArquivo,"Metas Gerais;Data: "+DtoC(dDataBase)+" "+Substr(Time(),5))
	AcaLog(cArquivo,"Filtro de Pesquisa - Periodo: "+DtoC(MV_PAR10)+" a "+DtoC(MV_PAR11))

	For nX := 1 to Len(aDetalhes)

		If aDetalhes[nX,1] <> cDoc

			cDoc := aDetalhes[nX,1]

			nPosDoc := Ascan(aTotDoc,{|x| x[1] = cDoc })

			lTotaliza := ! ( aTotDoc[nPosDoc,8] > 0 .And. aTotDoc[nPosDoc,9] > 0 .And. aTotDoc[nPosDoc,8] > aTotDoc[nPosDoc,9] )

			AcaLog(cArquivo,"")
			cString := "Totais: "+cDoc+";;;;;;;;;;;;;;;;;;;"

			If lTotaliza
				cString += transform(aTotDoc[nPosDoc,2],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,3],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,3]/aTotDoc[nPosDoc,2]*100,"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,6],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,7],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,7]/aTotDoc[nPosDoc,6]*100,"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,4],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,5],"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,5]/aTotDoc[nPosDoc,4]*100,"@E 999,999,999.99") + ";"
			Else
				cString += transform(aTotDoc[nPosDoc,2],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,9],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,9]/aTotDoc[nPosDoc,2]*100,"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,20],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,21],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,21]/aDetalhes[nX,20]*100,"@E 999,999,999.99") + ";"
				cString += transform(aTotDoc[nPosDoc,4],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,12],"@E 999,999,999.99") + ";"
				cString += transform(aDetalhes[nX,12]/aTotDoc[nPosDoc,4]*100,"@E 999,999,999.99") + ";"
			EndIf
			cString += transform(100,"@E 999,999,999.99")

			nTotFat := aDetalhes[nX,12]

			AcaLog(cArquivo,cString)

			cString := "Documento; "
			cString += "Data; "
			cString += "Sequencia; "
			cString += "Gerente; Nome Gerente; "
			cString += "Vendedor; Nome Vendedor; "
			cString += "Regiao; "
			cString += "Código Grupo; Grupo de Clientes; "
			cString += "Cliente; Nome Cliente; "
			cString += "Código Categoria; Categoria Produto; "
			cString += "Produto; Descrição Produto; "
			cString += "Grupo; "
			cString += "Tipo; "
			cString += "Custo Medio; "
			cString += "Qtde/Meta; "
			cString += "Qtde/Real; "
			cString += "% Qt/Real; "
			cString += "Preco Medio/Meta; "
			cString += "Preco Medio/Real ; "
			cString += "% Pr.Medio/Real; "
			cString += "Valor/Meta; "
			cString += "Valor/Real ; "
			cString += "% Valor/Real; "
			cString += "% Faturamento"

			AcaLog(cArquivo,cString)

		Endif

		cVendedor	:= IncPipe(aDetalhes[nX,03,1],aDetalhes[nX,03,2])
		cGrupo		:= IncPipe(aDetalhes[nX,04,1],aDetalhes[nX,04,2])
		cCategoria	:= IncPipe(aDetalhes[nX,05,1],aDetalhes[nX,05,2])
		cCliente	:= IncPipe(aDetalhes[nX,17,1],aDetalhes[nX,17,2])
		cProduto	:= IncPipe(aDetalhes[nX,18,1],aDetalhes[nX,18,2])
		cGerente	:= IncPipe(aDetalhes[nX,23,1],aDetalhes[nX,23,2])

		cString := aDetalhes[nX,01]																+ ";"					// "Documento; "
		cString += DtoC(aDetalhes[nX,15])														+ ";"					// "Data; "
		cString += aDetalhes[nX,02]																+ ";"					// Sequencia; "
		cString += cGerente																		+ ";"					// "Gerente; "
		cString += cVendedor																	+ ";"					// "Vendedor; "
		cString += aDetalhes[nX,16]																+ ";"					// "Regiao; "
		cString += cGrupo																		+ ";" 					// "Grupo de Clientes; "
		cString += cCliente																		+ ";"					// "Cliente; "
		cString += cCategoria																	+ ";"					// "Categoria Produto; "
		cString += cProduto																		+ ";"					// "Produto; "
		cString += aDetalhes[nX,06] 															+ ";"					// "Grupo; "
		cString += aDetalhes[nX,19]																+ ";"					// "Tipo; "
		cString += transform(aDetalhes[nX,07],"@E 999,999,999.99")								+ ";"					// "Custo Medio; "
		cString += transform(aDetalhes[nX,08],"@E 999,999,999.99")								+ ";"					// "Qtde/Meta; "
		cString += transform(aDetalhes[nX,09],"@E 999,999,999.99")								+ ";"					// "Qtde/Real; "
		cString += transform(aDetalhes[nX,10],"@E 999,999,999.99")								+ ";"					// "% Qt/Real; "
		cString += transform(aDetalhes[nX,20],"@E 999,999,999,999.99")							+ ";"					// "Preco Medio/Meta; "
		cString += transform(aDetalhes[nX,21],"@E 999,999,999,999.99")							+ ";"					// "Preco Medio/Real ; "
		cString += transform(aDetalhes[nX,22],"@E 999,999,999.99")								+ ";"					// "% Pr.Medio/Real; "
		cString += transform(aDetalhes[nX,11],"@E 999,999,999,999.99")							+ ";"					// "Valor/Meta; "
		cString += transform(aDetalhes[nX,12],"@E 999,999,999,999.99")							+ ";"					// "Valor/Real ; "
		cString += transform(aDetalhes[nX,13],"@E 999,999,999.99")								+ ";"					// "% Valor/Real; "

//If lTotaliza
		nPosTotDoc := Ascan(aTotDoc,{|x|x[1] = aDetalhes[nX,1]})
		cString += transform(aDetalhes[nX,12] / aTotDoc[nPosTotDoc,05] * 100 ,"@E 999,999.99")						// "% Faturamento; "
//	Else
//		cString += transform(aDetalhes[nX,12] / nTotFat * 100 ,"@E 999,999,999.99")								// "% Faturamento; "
//	EndIf

		AcaLog(cArquivo,cString)

	Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da rotina                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	( cAliasSCT )->( dbCloseArea() )

	dbSelectArea( "SCT" )
	RetIndex("SCT")

	If MsgYesNo("Deseja abrir Planilha no Excel ?")

		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' ) //'MsExcel nao instalado'
			Return Nil
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArquivo ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)

	EndIf

Return(.T.)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³TaiffNfVendas³ Autor ³Eduardo Riera          ³ Data ³12.12.2000 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Calcula o Valor das Vendas com base nas notas fiscais de     ³±±
	±±³          ³saida para intergracao com MsOffice.                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ³±±
	±±³          ³                     (2-Numerico-Quantidade )                ³±±
	±±³          ³                     (3-Numerico-Valor bruto + desconto )    ³±±
	±±³          ³                     (4-Array-contendo todos os valores acima³±±
	±±³          ³                     (5-Array-contendo todos os valores acima³±±
	±±³          ³                      por produto                            ³±±
	±±³          ³ExpC2: cCodVend                                              ³±±
	±±³          ³ExpD3: Data de Inicio                                        ³±±
	±±³          ³ExpD4: Data de Termino                                       ³±±
	±±³          ³ExpC5: Regiao de Vendas.                                     ³±±
	±±³          ³ExpC6: Tipo de Produto                                       ³±±
	±±³          ³ExpC7: Grupo de Produto                                      ³±±
	±±³          ³ExpC8: Codigo do Produto                                     ³±±
	±±³          ³ExpN9: Moeda para conversao                                  ³±±
	±±³          ³ExpCA: Cliente                                               ³±±
	±±³          ³ExpCB: Loja                                                  ³±±
	±±³          ³ExpCC: Expressao a ser adicionada na Query ou Filtro para    ³±±
	±±³          ³       SGBD ISAM                                             ³±±
	±±³          ³ExpCD: Determina se devem ser consideradas Notas fiscais (1) ³±±
	±±³          ³       REMITOS (2) ou ambos tipos de documento (3)           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpX1: Valor / Array conforme tipo da Meta                   ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Calcula o Valor das Vendas com base nas notas fiscais de     ³±±
	±±³          ³saida                                                        ³±±
	±±³          ³                                                             ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³Materiais                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TaiffNfVendas(nTpMeta,cCodVend,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cQueryAdd,cTipoDoc,cDupli,cEstoq,cGrpVen,cCatego,cGerente)

	Local aArea   := GetArea()
	Local aAreaSA3:= SA3->(GetArea())
	Local aAreaSF4:= SF4->(GetArea())
	Local aAreaSD2:= SD2->(GetArea())
	Local aAreaSF2:= SF2->(GetArea())
	Local cQuery  := ""
	Local cArqQry := "TaiffNfVendas"
	Local xRetorno := 0
	Local nX      := 0

	DEFAULT nTpMeta := 1
	DEFAULT cCodVend := ""
	DEFAULT dDataIni:= dDataBase
	DEFAULT dDataFim:= dDataBase
	DEFAULT cRegiao := ""
	DEFAULT cTipo   := ""
	DEFAULT cGrupo  := ""
	DEFAULT cCatego := ""
	DEFAULT cGerente:= ""
	DEFAULT cProduto:= ""
	DEFAULT nMoeda  := 0
	DEFAULT cGrpVen := ""
	DEFAULT cCliente:= ""
	DEFAULT cLoja   := ""
	DEFAULT cTipoDoc:= '3'
	DEFAULT cDupli	:= "'S'"
	DEFAULT cEstoq	:= "'S'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerta o Tamanho da Variaveis                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodVend:= PadR(cCodVend,Len(SA3->A3_COD))
	cGerente:= PadR(cGerente,Len(SA3->A3_COD))
	cRegiao := PadR(cRegiao,Len(SF2->F2_REGIAO))
	cTipo   := PadR(cTipo,Len(SD2->D2_TP))
	cGrupo  := PadR(cGrupo,Len(SD2->D2_GRUPO))
	cProduto:= PadR(cProduto,Len(SD2->D2_COD))

	If nTpMeta == 4
		xRetorno := { 0, 0, 0 }
	EndIf
	If nTpMeta == 5
		xRetorno := {}
	EndIf

	Do Case
	Case ( nTpMeta == 1 )
		cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL "
	Case ( nTpMeta == 2 )
		cQuery := "SELECT SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD2.D2_QUANT ELSE 0 END) D2_QUANT "
	Case ( nTpMeta == 3 )
		cQuery := "SELECT SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTAL "
	Case ( nTpMeta == 4 )
		cQuery := "SELECT SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD2.D2_QUANT ELSE 0 END) D2_QUANT "
	OtherWise
		cQuery := "SELECT D2_COD,SUM(SD2.D2_TOTAL) D2_TOTAL, SUM(SD2.D2_TOTAL+SD2.D2_DESCON) D2_TOTDESC,SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD2.D2_QUANT ELSE 0 END) D2_QUANT "
	EndCase

	If !Empty( nMoeda )
		cQuery += ",F2_MOEDA,D2_EMISSAO "
	EndIf

	cQuery += "FROM "

	cQuery += RetSqlName("SF4")+" SF4, "

	If ( !Empty(cCodVend) .or. !Empty(cGerente) )
		cQuery += RetSqlName("SF2")+" SF2 "
		cQuery += " LEFT OUTER JOIN " + RetSqlName("SA3") + " SA3 ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' ', "
	Else
		cQuery += RetSqlName("SF2")+" SF2, "
	EndIf

	cQuery += RetSqlName("SD2")+" SD2 "

	If ( !Empty(cGrpVen) )
		cQuery += " LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	EndIf

	If ( !Empty(cCatego) )
		cQuery += " LEFT OUTER JOIN " + RetSqlName("ACV") + " ACV ON D2_COD = ACV_CODPRO AND ACV.D_E_L_E_T_ = ' ' "
	EndIf

	cQuery += "WHERE "
	cQuery += "SF2.F2_TIPO='N' AND "

	If ( !Empty(dDataIni) )
		cQuery += "SF2.F2_EMISSAO>='"+Dtos(dDataIni)+"' AND "
	EndIf

	If ( !Empty(dDataFim) )
		cQuery += "SF2.F2_EMISSAO<='"+Dtos(dDataFim)+"' AND "
	EndIf

	If ( !Empty(cRegiao) )
		If cPaisLoc == "BRA"
			cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "
		Else
			cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
			cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
			cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
			cQuery += "SA1.D_E_L_E_T_<>'*') AND "
		Endif
	Endif

	If ( !Empty(cCliente) )
		cQuery += "SF2.F2_CLIENTE='"+cCliente+"' AND "
	EndIf

	If ( !Empty(cLoja) )
		cQuery += "SF2.F2_LOJA='"+cLoja+"' AND "
	EndIf

	If ( !Empty(cGrpVen) )
		cQuery += "SA1.A1_GRPVEN = '" + cGrpVen + "' AND "
	EndIf

	If ( !Empty(cCatego) )
		cQuery += "ACV.ACV_CATEGO LIKE '" + Alltrim(cCatego) + "%' AND "
	EndIf

	If ( !Empty(cCodVend) )
		cQuery += "SA3.A3_COD = '" + cCodVend + "' AND "
	EndIf

	If ( !Empty(cGerente) )
		cQuery += "SA3.A3_GEREN = '" + cGerente + "' AND "
	EndIf

	If cTipoDoc == '1' .Or. cTipoDoc == '3'
		cQuery += " NOT ("+IsRemito(3,'SF2.F2_TIPODOC')+") AND "
	ElseIf cTipoDoc == '2'
		cQuery += IsRemito(3,'SF2.F2_TIPODOC')+" AND "
	Endif
	cQuery += "SF2.D_E_L_E_T_ <> '*' AND "
	cQuery += "SD2.D2_FILIAL = SF2.F2_FILIAL AND "
	cQuery += "SD2.D2_SERIE  = SF2.F2_SERIE AND "
	cQuery += "SD2.D2_DOC    = SF2.F2_DOC AND "
	cQuery += "SD2.D2_CLIENTE= SF2.F2_CLIENTE AND "
	cQuery += "SD2.D2_LOJA   = SF2.F2_LOJA AND "
	If ( !Empty(cTipo) )
		cQuery += "SD2.D2_TP='"+cTipo+"' AND "
	EndIf
	If ( !Empty(cGrupo) )
		cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
	EndIf
	If ( !Empty(cProduto) )
		cQuery += "SD2.D2_COD='"+cProduto+"' AND "
	EndIf
	cQuery += "SD2.D_E_L_E_T_<>'*' AND "

	cQuery += "SF4.F4_FILIAL = SD2.D2_FILIAL AND "
	cQuery += "SF4.F4_CODIGO = SD2.D2_TES AND "

	If SF4->(FieldPos("F4_META")) > 0
		cQuery += "SF4.F4_META = 'S' AND "
	Endif

	cQuery += "SF4.F4_DUPLIC = 'S' AND "

	cQuery += "SF4.D_E_L_E_T_<>'*' "
	If !Empty(cQueryAdd)
		cQuery += " AND "+cQueryAdd
	EndIf
	If nTpMeta <> 5
		If !Empty( nMoeda )
			cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO"
		EndIf
	Else
		If !Empty( nMoeda )
			cQuery += "GROUP BY F2_MOEDA,D2_EMISSAO,D2_COD"
		Else
			cQuery += "GROUP BY D2_COD "
		EndIf
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
	If ( nTpMeta == 1 .Or. nTpMeta == 3 )
		TcSetField(cArqQry,"D2_TOTAL","N",18,2)
	ElseIf nTpMeta == 2
		TcSetField(cArqQry,"D2_QUANT","N",18,2)
	Else
		TcSetField(cArqQry,"D2_QUANT"  ,"N",18,2)
		TcSetField(cArqQry,"D2_TOTAL"  ,"N",18,2)
		TcSetField(cArqQry,"D2_TOTDESC","N",18,2)
	EndIf

	If !Empty( nMoeda )
		TcSetField(cArqQry,"F2_MOEDA"  ,"N",2,0)
		TcSetField(cArqQry,"D2_EMISSAO","D",8,0)
	EndIf                                                               /

	While ( !Eof() )
		Do Case
		Case ( nTpMeta == 1 .Or. nTpMeta == 3 )
			xRetorno += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
		Case nTpMeta == 2
			xRetorno += D2_QUANT
		Case nTpMeta == 4
			xRetorno[ 1 ] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
			xRetorno[ 2 ] += D2_QUANT
			xRetorno[ 3 ] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
		OtherWise
			nX := aScan(xRetorno,{|x| x[1] == D2_COD})
			If nX == 0
				aadd(xRetorno,{D2_COD,0,0,0})
				nX := Len(xRetorno)
			EndIf
			xRetorno[nX][2] += If( Empty( nMoeda ), D2_TOTAL, xMoeda( D2_TOTAL, F2_MOEDA, nMoeda, D2_EMISSAO ) )
			xRetorno[nX][3] += D2_QUANT
			xRetorno[nX][4] += If( Empty( nMoeda ), D2_TOTDESC, xMoeda( D2_TOTDESC, F2_MOEDA, nMoeda, D2_EMISSAO ) )
		EndCase
		dbSelectArea(cArqQry)
		dbSkip()
	EndDo
	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SD2")


	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aAreaSF4)
	RestArea(aAreaSA3)
	RestArea(aArea)
Return(xRetorno)
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Funcao    ³TaiffDevol ³ Autor ³Eduardo Riera          ³ Data ³12.12.2000 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³Calcula o Valor das Devolucoes com base nas notas fiscais de ³±±
	±±³          ³entrada pra integracao com MsOffice.                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpN1: Tipo de Meta :(1-Numerico-Valor liquido - desconto )  ³±±
	±±³          ³                     (2-Numerico-Quantidade )                ³±±
	±±³          ³                     (3-Numerico-Valor bruto + desconto )    ³±±
	±±³          ³                     (4-Array-contendo todos os valores acima³±±
	±±³          ³                     (5-Array-contendo todos os valores acima³±±
	±±³          ³                      por produto                            ³±±
	±±³          ³ExpC2: cCodVend                                              ³±±
	±±³          ³ExpD3: Data de Inicio                                        ³±±
	±±³          ³ExpD4: Data de Termino                                       ³±±
	±±³          ³ExpC5: Regiao de Vendas.                                     ³±±
	±±³          ³ExpC6: Tipo de Produto                                       ³±±
	±±³          ³ExpC7: Grupo de Produto                                      ³±±
	±±³          ³ExpC8: Codigo do Produto                                     ³±±
	±±³          ³ExpN9: Moeda para conversao                                  ³±±
	±±³          ³ExpCA: Cliente                                               ³±±
	±±³          ³ExpCB: Loja                                                  ³±±
	±±³          ³ExpCC: Determina se devem ser consideradas Notas fiscais (1) ³±±
	±±³          ³       REMITOS (2) ou ambos tipos de documento (3)           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³ExpX1: Valor conforme tipo da Meta                           ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³Calcula o Valor das Devolucoes com base nas notas fiscais de ³±±
	±±³          ³entrada considerando apenas as datas de entrada e nao as     ³±±
	±±³          ³notas de origem                                              ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³Materiais                                                    ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TaiffDevol(nTpMeta,cCodVend,dDataIni,dDataFim,cRegiao,cTipo,cGrupo,cProduto,nMoeda,cCliente,cLoja,cTipoDoc,cDupli,cEstoq,cGrpVen,cCatego,cGerente)

	Local aArea   := GetArea()
	Local aAreaSD1:= SD1->(GetArea())
	Local aAreaSD2:= SD2->(GetArea())
	Local aAreaSF2:= SF2->(GetArea())
	Local aAreaSF4:= SF4->(GetArea())
	Local aAreaSA3:= SA3->(GetArea())
	Local cQuery  := ""
	Local cArqQry := "TaiffDevol"
	Local xRetorno:= 0
	Local nX      := 0

	DEFAULT nTpMeta := 1
	DEFAULT cCodVend := ""
	DEFAULT dDataIni:= dDataBase
	DEFAULT dDataFim:= dDataBase
	DEFAULT cRegiao := ""
	DEFAULT cTipo   := ""
	DEFAULT cGrupo  := ""
	DEFAULT cCatego := ""
	DEFAULT cGerente:= ""
	DEFAULT cProduto:= ""
	DEFAULT nMoeda  := 0
	DEFAULT cGrpVen := ""
	DEFAULT cCliente:= ""
	DEFAULT cLoja   := ""
	DEFAULT cTipoDoc:= '3'
	DEFAULT cDupli	:= "'S'"
	DEFAULT cEstoq	:= "'S'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerta o Tamanho da Variaveis                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCodVend:= PadR(cCodVend,Len(SA3->A3_COD))
	cGerente:= PadR(cGerente,Len(SA3->A3_COD))
	cRegiao := PadR(cRegiao,Len(SF2->F2_REGIAO))
	cTipo   := PadR(cTipo,Len(SD2->D2_TP))
	cGrupo  := PadR(cGrupo,Len(SD2->D2_GRUPO))
	cProduto:= PadR(cProduto,Len(SD2->D2_COD))

	If nTpMeta == 4
		xRetorno := { 0, 0, 0 }
	EndIf
	If nTpMeta == 5
		xRetorno := {}
	EndIf

	Do Case
	Case ( nTpMeta == 1 )
		cQuery := "SELECT SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL "
	Case ( nTpMeta == 2 )
		cQuery := "SELECT SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD1.D1_QUANT ELSE 0 END) D1_QUANT "
	Case ( nTpMeta == 3 )
		cQuery := "SELECT SUM(SD1.D1_TOTAL) D1_TOTAL "
	Case ( nTpMeta == 4 )
		cQuery := "SELECT SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL,SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD1.D1_QUANT ELSE 0 END) D1_QUANT,SUM(SD1.D1_TOTAL) D1_TOTDESC "
	OtherWise
		cQuery := "SELECT D1_COD,SUM(SD1.D1_TOTAL-SD1.D1_VALDESC) D1_TOTAL,SUM(CASE SF4.F4_ESTOQUE WHEN 'S' THEN SD1.D1_QUANT ELSE 0 END) D1_QUANT,SUM(SD1.D1_TOTAL) D1_TOTDESC "
	EndCase

	If !Empty( nMoeda )
		cQuery += ",D1_DTDIGIT,F2_MOEDA "
	EndIf

	cQuery += "FROM "
	cQuery += RetSqlName("SD1")+" SD1, "
	cQuery += RetSqlName("SF4")+" SF4, "

	If ( !Empty(cCodVend) .or. !Empty(cGerente) )
		cQuery += RetSqlName("SF2")+" SF2 "
		cQuery += " LEFT OUTER JOIN " + RetSqlName("SA3") + " SA3 ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' ', "
	Else
		cQuery += RetSqlName("SF2")+" SF2, "
	EndIf

	cQuery += RetSqlName("SD2")+" SD2 "

	If ( !Empty(cGrpVen) )
		cQuery += " LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	EndIf

	If ( !Empty(cCatego) )
		cQuery += " LEFT OUTER JOIN " + RetSqlName("ACV") + " ACV ON D2_COD = ACV_CODPRO AND ACV.D_E_L_E_T_ = ' ' "
	EndIf

	cQuery += "WHERE "

	cQuery += "SD1.D1_TIPO='D' AND "

	If ( !Empty(dDataIni) )
		cQuery += "SD1.D1_DTDIGIT>='"+Dtos(dDataIni)+"' AND "
	EndIf
	If ( !Empty(dDataFim) )
		cQuery += "SD1.D1_DTDIGIT<='"+Dtos(dDataFim)+"' AND "
	EndIf
	If ( !Empty(cCliente) )
		cQuery += "SD1.D1_FORNECE='"+cCliente+"' AND "
	EndIf
	If ( !Empty(cLoja) )
		cQuery += "SD1.D1_LOJA='"+cLoja+"' AND "
	EndIf

	If ( !Empty(cGrpVen) )
		cQuery += "SA1.A1_GRPVEN = '" + cGrpVen + "' AND "
	EndIf

	If ( !Empty(cCatego) )
		cQuery += "ACV.ACV_CATEGO LIKE '" + Alltrim(cCatego) + "%' AND "
	EndIf

	If ( !Empty(cCodVend) )
		cQuery += "SA3.A3_COD = '" + cCodVend + "' AND "
	EndIf

	If ( !Empty(cGerente) )
		cQuery += "SA3.A3_GEREN = '" + cGerente + "' AND "
	EndIf

	If cTipoDoc == '1' .Or. cTipoDoc == '3'
		cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+") AND "
	ElseIf cTipoDoc == '2'
		cQuery += IsRemito(3,'SD1.D1_TIPODOC')+" AND "
	Endif
	cQuery += "SD1.D_E_L_E_T_<>'*' AND "
	cQuery += "SD2.D2_DOC=SD1.D1_NFORI AND "
	cQuery += "SD2.D2_SERIE=SD1.D1_SERIORI AND "
	cQuery += "SD2.D2_ITEM=SubString(SD1.D1_ITEMORI,1,2) AND "
	If ( !Empty(cTipo) )
		cQuery += "SD2.D2_TP='"+cTipo+"' AND "
	EndIf
	If ( !Empty(cGrupo) )
		cQuery += "SD2.D2_GRUPO='"+cGrupo+"' AND "
	EndIf
	If ( !Empty(cProduto) )
		cQuery += "SD2.D2_COD='"+cProduto+"' AND "
	EndIf
	cQuery += "SF2.D_E_L_E_T_ <> '*' AND "
	cQuery += "SD2.D2_FILIAL = SF2.F2_FILIAL AND "
	cQuery += "SD2.D2_SERIE  = SF2.F2_SERIE AND "
	cQuery += "SD2.D2_DOC    = SF2.F2_DOC AND "
	cQuery += "SD2.D2_CLIENTE= SF2.F2_CLIENTE AND "
	cQuery += "SD2.D2_LOJA   = SF2.F2_LOJA AND "

	If ( !Empty(cRegiao) )
		If cPaisLoc == "BRA"
			cQuery += "SF2.F2_REGIAO='"+cRegiao+"' AND "
		Else
			cQuery += "EXISTS ( SELECT A1_REGIAO FROM " + RetSqlName( "SA1" ) + " SA1 WHERE "
			cQuery += "SA1.A1_COD=SD2.D2_CLIENTE AND SA1.A1_LOJA=SD2.D2_LOJA AND "
			cQuery += "SA1.A1_REGIAO='" + cRegiao + "' AND "
			cQuery += "SA1.D_E_L_E_T_<>'*') AND "
		EndIf
	Endif

	cQuery += "SF2.D_E_L_E_T_<>'*' AND "

	cQuery += "SF4.F4_FILIAL = SD2.D2_FILIAL AND "
	cQuery += "SF4.F4_CODIGO = SD2.D2_TES AND "

	If SF4->(FieldPos("F4_META")) > 0
		cQuery += "SF4.F4_META = 'S' AND "
	Endif

	cQuery += "SF4.F4_DUPLIC = 'S' AND "

	cQuery += "SF4.D_E_L_E_T_<>'*' "

	If nTpMeta <> 5
		If !Empty( nMoeda )
			cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT "
		EndIf
	Else
		If !Empty( nMoeda )
			cQuery += "GROUP BY F2_MOEDA,D1_DTDIGIT,D1_COD "
		Else
			cQuery += "GROUP BY D1_COD "
		EndIf
	EndIf

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
	If ( nTpMeta == 1 .Or. nTpMeta == 3 )
		TcSetField(cArqQry,"D1_TOTAL","N",18,2)
	ElseIf nTpMeta == 2
		TcSetField(cArqQry,"D1_QUANT","N",18,2)
	Else
		TcSetField(cArqQry,"D1_QUANT"  ,"N",18,2)
		TcSetField(cArqQry,"D1_TOTAL"  ,"N",18,2)
		TcSetField(cArqQry,"D1_TOTDESC","N",18,2)
	EndIf

	If !Empty( nMoeda )
		TcSetField(cArqQry,"F2_MOEDA"  ,"N",2,0)
		TcSetField(cArqQry,"D1_DTDIGIT","D",8,0)
	EndIf

	While ( !Eof() )
		Do Case
		Case ( nTpMeta == 1 .Or. nTpMeta == 3 )
			xRetorno += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
		Case nTpMeta == 2
			xRetorno += D1_QUANT
		Case nTpMeta == 4
			xRetorno[ 1 ] += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
			xRetorno[ 2 ] += D1_QUANT
			xRetorno[ 3 ] += If( Empty( nMoeda ), D1_TOTDESC, xMoeda( D1_TOTDESC, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
		OtherWise
			nX := aScan(xRetorno,{|x| x[1] == D1_COD})
			If nX == 0
				aadd(xRetorno,{D1_COD,0,0,0})
				nX := Len(xRetorno)
			EndIf
			xRetorno[nX][2] += If( Empty( nMoeda ), D1_TOTAL, xMoeda( D1_TOTAL, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
			xRetorno[nX][3] += D1_QUANT
			xRetorno[nX][4] += If( Empty( nMoeda ), D1_TOTDESC, xMoeda( D1_TOTDESC, F2_MOEDA, nMoeda, D1_DTDIGIT ) )
		EndCase

		dbSelectArea(cArqQry)
		dbSkip()
	EndDo
	dbSelectArea(cArqQry)
	dbCloseArea()
	dbSelectArea("SD1")
	RestArea(aAreaSD1)
	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aAreaSF4)
	RestArea(aAreaSA3)
	RestArea(aArea)

Return(xRetorno)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncPipe   ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui Pipe para o Excel abrir com zeros a esquerda        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncPipe(cCodigo,cDescricao)

Return If(!Empty(cCodigo) ,"|", "") + cCodigo + ";" + cDescricao
