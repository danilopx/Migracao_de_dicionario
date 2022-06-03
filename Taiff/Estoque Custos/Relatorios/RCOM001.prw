#INCLUDE "MATR110.CH"
#INCLUDE "PROTHEUS.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOM001     º Autor ³ ABM by JAR      º Data ³  08/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Pedido de compras                                          º±±
±±º          ³ Conforme Lay-Out TAIFF                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RCOM001( cAlias, nReg, nOpcx )

	Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2        := "de acordo com os parametros informados pelo usuario."
	Local cDesc3        := "Pedido de Compras"
	//Local cPict         := ""
	Local titulo       	:= "Relatório de Pedido de Compras"
	//Local nLin         	:= 80
	Local aOrd 			:= {}
	Local J				:= 0
	Local I				:= 0
	Local P				:= 0
	//Local nDeslocX
	//Local nDeslocY

	Local aParam := { { "Instr Entrega 1", "mv_ch7", "MV_PAR07" },;
		{ "Instr Entrega 2", "mv_ch8", "MV_PAR08" },;
		{ "Instr Entrega 3", "mv_ch9", "MV_PAR09" },;
		{ "Instr Entrega 4", "mv_cha", "MV_PAR10" },;
		{ "Observaçoes 1"  , "mv_chb", "MV_PAR11" },;
		{ "Observaçoes 2"  , "mv_chc", "MV_PAR12" },;
		{ "Observaçoes 3"  , "mv_chd", "MV_PAR13" },;
		{ "Observaçoes 4"  , "mv_che", "MV_PAR14" }}


	Private nTotICMS, nTotIPI, nTotISS, nTotGeral
	Private aNatur := {}
	Private nPag := 1
// titulos do Quadros das colunas
	Private aTitulos := {"IT", "Cod Prod", "Rev", "Descrição", "UM", "Quantidade", "Vl Unit", "CFOP", "% ICMS", "Valor ICMS", "% IPI", "Valor IPI", "% ISS", "Valor ISS", "Sub Total", "Dt Entrega"}

// dimensões doa quadros do relatorio
// Total de 34 Quadros
//                   X1,    Y1,   X2,   Y2 em cm
	Private aQuadros := { { 0.0,  0.0,  1.1,  3.6},; // 1
	{ 0.0,  3.6,  1.1,  8.5},; // 2
	{ 0.0,  8.5,  1.1, 11.7},; // 3
	{ 0.0, 11.7,  1.1, 22.2},; // 4
	{ 0.0, 22.2,  1.1, 26.7},; // 5 primeira linha
	{ 1.1,  0.0,  2.2, 12.5},; // 6
	{ 1.1, 12.5,  2.2, 26.7},; // 7  segunda linha
	{ 2.2,  0.0, 14.5,  0.7},; // 8
	{ 2.2,  0.7, 14.5,  2.0},; // 9  inserir coluna 10  { 2.2,  2.0, 14.5,  3.5}
	{ 2.2,  3.5, 14.5,  4.2},; // 10
	{ 2.2,  4.2, 14.5, 10.4},; // 11
	{ 2.2, 10.4, 14.5, 11.1},; // 12
	{ 2.2, 11.1, 14.5, 12.8},; // 13
	{ 2.2, 12.8, 14.5, 14.6},; // 14
	{ 2.2, 14.6, 14.5, 15.7},; // 15
	{ 2.2, 15.7, 14.5, 16.6},; // 16
	{ 2.2, 16.6, 14.5, 18.2},; // 17
	{ 2.2, 18.2, 14.5, 19.0},; // 18
	{ 2.2, 19.0, 14.5, 20.6},; // 19
	{ 2.2, 20.6, 14.5, 21.4},; // 20
	{ 2.2, 21.4, 14.5, 23.0},; // 21
	{ 2.2, 23.0, 14.5, 25.0},; // 22
	{ 2.2, 25.0, 14.5, 26.7},; // 23 terceira linha
	{14.5,  0.0, 15.4,  9.7},; // 24
	{14.5,  9.7, 15.4, 12.5},; // 25
	{14.5, 12.5, 15.4, 15.0},; // 26
	{14.5, 15.0, 15.4, 17.4},; // 27
	{14.5, 17.4, 15.4, 20.2},; // 28
	{14.5, 20.2, 15.4, 24.2},; // 29
	{14.5, 24.2, 15.4, 26.7},; // 30
	{15.4,  0.0, 15.8, 12.9},; // 31
	{15.4, 12.9, 15.8, 26.7},; // 32
	{15.8,  0.0, 17.9,  9.3},; // 33
	{15.8,  9.3, 17.9, 26.7} } // 34

	PRIVATE lAuto		:= (FUNNAME() == "MATA121")
	Private tamanho     := "M"
	Private nomeprog    := "RCOM001"
	Private aPerg		:= {Avkey("RCOM001","X1_GRUPO"),Avkey("RCOM001A","X1_GRUPO")}
	Private cPerg       := aPerg[1]
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private cString 	:= "SC7"

//cria margens
	for I := 1 to len( aQuadros )
		for J := 1 to 4
			aQuadros[I,J] := aQuadros[I,J] + 0.5
		next
	next

// DECLARACAO DE TIPOS DE FONTES
	oFont07  := TFont():New( "Arial          ",,07,,.f.,,,,.f.,.f. )
	oFont07b := TFont():New( "Arial          ",,07,,.T.,,,,.f.,.f. )
	oFont08  := TFont():New( "Arial          ",,08,,.F.,,,,.f.,.f. )
	oFont08b := TFont():New( "Arial          ",,08,,.t.,,,,.f.,.f. )
	oFont09  := TFont():New( "Arial          ",,09,,.f.,,,,.f.,.f. )
	oFont09b := TFont():New( "Arial          ",,09,,.t.,,,,.f.,.f. )
	oFont09bi:= TFont():New( "Arial          ",,09,,.t.,,,,.t.,.f. )
	oFont10  := TFont():New( "Arial          ",,10,,.f.,,,,.f.,.f. )
	oFont10b := TFont():New( "Arial          ",,10,,.t.,,,,.f.,.f. )
	oFont12  := TFont():New( "Arial          ",,12,,.f.,,,,.f.,.f. )
	oFont14b := TFont():New( "Arial          ",,14,,.t.,,,,.f.,.f. )
	oFont16b := TFont():New( "Arial          ",,16,,.t.,,,,.f.,.f. )

	dbSelectArea("SC7")
	dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par06               Pedidos ? Liberados Bloqueados Ambos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


//Carrega Perguntas
//Pergunta 01
	aHelpPor := {}
	aAdd( aHelpPor, "Informe o numero do Pedido inicial" )
	aAdd( aHelpPor, "a ser impressa" )
//PutSX1( < cGrupo>, < cOrdem>, < cPergunt>, < cPergSpa>, < cPergEng>, < cVar>, < cTipo>, < nTamanho>, [ nDecimal], [ nPreSel], < cGSC>, [ cValid], [ cF3], [ cGrpSXG], [ cPyme], < cVar01>, [ cDef01], [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02], [ cDefSpa2], [ cDefEng2], [ cDef03], [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
	PutSX1( cPerg, "01", "Pedido Inicial", "Pedido Inicial", "Pedido Inicial", "mv_ch1", "C", 06, 0, 0, "G", "", "SC7", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor, "" )

//Pergunta 02
	aHelpPor := {}
	aAdd( aHelpPor, "Informe o numero do Pedido final" )
	aAdd( aHelpPor, "a ser impresso" )
	PutSX1( cPerg, "02", "Pedido Final", "Pedido Final", "Pedido Final", "mv_ch2", "C", 06, 0, 0, "G", "", "SC7", "", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor, "" )

//Pergunta 03
	aHelpPor := {}
	aAdd( aHelpPor, "Informe a data de emissão inicial" )
	PutSx1(cPerg, "03", "Dt Emissao Inicial", "Dt Emissao Inicial", "Dt Emissao Inicial", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)

//Pergunta 04
	aHelpPor := {}
	aAdd( aHelpPor, "Informe a data de emissão Final" )
	PutSx1(cPerg, "04", "Dt Emissao Final", "Dt Emissao Final", "Dt Emissao Final", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)

//Pergunta 05
	aHelpPor := {}
	aAdd( aHelpPor, "Informe a unidade de medida" )
	PutSx1(cPerg, "05", "Unid Medida", "Unid Medida", "Unid Medida", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR05", "Primaria", "Primaria", "Primaria", "", "Secundaria", "Secundaria", "Secundaria", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)

//Pergunta 06
	aHelpPor := {}
	aAdd( aHelpPor, "Tipo do pedido" )
//PutSX1( < cGrupo>, < cOrdem>, < cPergunt>, < cPergSpa>, < cPergEng>, < cVar>, < cTipo>, < nTamanho>, [ nDecimal], [ nPreSel], < cGSC>, [ cValid], [ cF3], [ cGrpSXG], [ cPyme], < cVar01>, [ cDef01], [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02], [ cDefSpa2], [ cDefEng2], [ cDef03], [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
	PutSX1(cPerg, "06", "Pedidos", "Pedidos", "Pedidos", "mv_ch6", "N", 01, 0, 1, "C", "", "", "", "", "mv_par06", "Liberados", "Liberados", "Liberados", "", "Bloqueados", "Bloqueados", "Bloqueados", "Ambos", "Ambos", "Ambos", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor, "")

	for P := 1 to 2
		cPerg := aPerg[P]
		for I := 1 to len( aParam )
			//Perguntas de 08 até 14
			aHelpPor := {}
			aAdd( aHelpPor, aParam[I,1] )
			//PutSX1( < cGrupo>, < cOrdem>, < cPergunt>, < cPergSpa>, < cPergEng>, < cVar>, < cTipo>, < nTamanho>, [ nDecimal], [ nPreSel], < cGSC>, [ cValid], [ cF3], [ cGrpSXG], [ cPyme], < cVar01>, [ cDef01], [ cDefSpa1], [ cDefEng1], [ cCnt01], [ cDef02], [ cDefSpa2], [ cDefEng2], [ cDef03], [ cDefSpa3], [ cDefEng3], [ cDef04], [ cDefSpa4], [ cDefEng4], [ cDef05], [ cDefSpa5], [ cDefEng5], [ aHelpPor], [ aHelpEng], [ aHelpSpa], [ cHelp] )
			PutSX1( cPerg, strzero(I+6,2), aParam[I,1], aParam[I,1], aParam[I,1], aParam[I,2], "C", 99, 0, 0, "G", "", "", "", "", aParam[I,3], "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor )
		next
	next

	cPerg := iif(lAuto, aPerg[2], aPerg[1])
	Pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,!lAuto)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	if lAuto
		SC7->( dbGoto(ParamIXB[2]) )

		mv_par01 := SC7->C7_NUM
		mv_par02 := SC7->C7_NUM
		mv_par03 := SC7->C7_EMISSAO
		mv_par04 := SC7->C7_EMISSAO
		mv_par06 := 2
	endif

	RptStatus({|| RunReport() }, "Pedido de Compra")

Return

//--------------------------------------------------------------------------
// Impressão do relatório
//--------------------------------------------------------------------------

Static function RunReport()

	Local cQuery
	Local nPosX
	Local nPosY
	Local nPosX1
	Local nPosY1
	Local nLin

	Local aLinhaDet := {}
	//Local aTmp := {}
	Local cTmp
	Local cPedAtual
	Local cProdAtual
	//Local cSubData
	Local nSubQtd
	Local nSubTot
	Local aQrdSubs := {11, 13, 22}
	Local I := 0
	Local K := 0

// Coleta de Dados

	cQuery := "Select "
	cQuery := cQuery + "SC7.C7_NUM, "
	cQuery := cQuery + "SC7.C7_ITEM, "
	cQuery := cQuery + "SC7.C7_Emissao, "
	cQuery := cQuery + "SC7.C7_FORNECE, "
	cQuery := cQuery + "SC7.C7_LOJA, "
	cQuery := cQuery + "SC7.C7_PRODUTO, "
	cQuery := cQuery + "SC7.C7_DESCRI, "
	cQuery := cQuery + "SC7.C7_UM, "
	cQuery := cQuery + "SC7.C7_QUANT, "
	cQuery := cQuery + "SC7.C7_PRECO, "
	cQuery := cQuery + "SC7.C7_PICM, "
	cQuery := cQuery + "SC7.C7_VALICM, "
	cQuery := cQuery + "SC7.C7_IPI, "
	cQuery := cQuery + "SC7.C7_TES, "
	cQuery := cQuery + "SC7.C7_VALIPI, "
	cQuery := cQuery + "SC7.C7_TOTAL, "
	cQuery := cQuery + "SC7.C7_DATPRF, "
	cQuery := cQuery + "SC7.C7_COND, "
	cQuery := cQuery + "SC7.C7_USER, "
	cQuery := cQuery + "SC7.C7_CONAPRO, "
	cQuery := cQuery + "SC7.C7_MSG "
//cQuery := cQuery + "SC7.
//cQuery := cQuery + "SC7.
//cQuery := cQuery + "SC7.

	cQuery := cQuery + "From " + RetSqlname("SC7") + " SC7 "
	cQuery := cQuery + "Where SC7.C7_NUM >= '" + mv_par01 + "' and SC7.C7_NUM <= '" + 	mv_par02 + "' and "
	cQuery := cQuery + "SC7.C7_EMISSAO >= '" + dtos(mv_par03) + "' and SC7.C7_EMISSAO <= '" + dtos(mv_par04) + "' and "

	if !lAuto
		if mv_par06 == 1
			cQuery := cQuery + "SC7.C7_CONAPRO = 'B' and "
		ElseIf mv_par06 == 2
			cQuery := cQuery + "SC7.C7_CONAPRO <> 'B' and "
		endif
	endif

	cQuery := cQuery + "SC7.D_E_L_E_T_ <> '*' "
	cQuery := cQuery + "Order by SC7.C7_NUM, SC7.C7_PRODUTO, SC7.C7_DATPRF, SC7.C7_ITEM"

	dbUseArea( .T., "TOPCONN" , TCGENQRY(,,cQuery),"TMP", .F., .T.)

	if !TMP->( Eof() )

		// Monta objeto para impressão
		oPrint := TMSPrinter():New("PROTHEUS - PEDIDO DE COMPRA")
		oPrint:SetPage( 9 ) // papel A4
		oPrint:SetLandScape()
		oPrint:Setup()

		nPosY := 0.5
		nPosX := 0.5

		oPrint:Cmtr2Pix( nPosY, nPosX )
		oPrint:SetPos( nPosY, nPosX )

//	oPrint:StartPage()

		GeraForm()

		TMP->( DBGotop() )
		cPedAtual := TMP->C7_NUM

		nTotICMS := 0
		nTotIPI := 0
		nTotISS := 0
		nTotGeral := 0

		nLin := aQuadros[ 8,1 ] + 0.7
		nPosX1 := aQuadros[ 8,3 ] + 0.7

		cProdAtual := TMP->C7_PRODUTO
		nSubQtd := 0
		nSubTot := 0
		while !TMP->( eof() )

			if cPedAtual <> TMP->C7_NUM

				ImpTotais()
				oPrint:EndPage()
				GeraForm()

				cProdAtual := TMP->C7_PRODUTO
				nTotICMS := 0
				nTotIPI := 0
				nTotISS := 0
				nTotGeral := 0

				nSubDtQtd := 0
				nSubDtTot := 0

				nLin := aQuadros[ 8,1 ] + 0.7
				nPosX1 := aQuadros[ 8,3 ] + 0.7

				cPedAtual := TMP->C7_NUM
			endif

			// Pesquisa a natureza de operação
			SF4->( DbSetOrder(1) )
			SF4->( DbSeek( xFilial("SF4")+TMP->C7_TES ) )
			if ascan( aNatur, SF4->F4_TEXTO ) == 0
				aadd( aNatur, SF4->F4_TEXTO )
			endif

			aLinhaDet := {}
			aadd( aLinhaDet, TMP->C7_ITEM ) // 1
			aadd( aLinhaDet, TMP->C7_PRODUTO ) // 2
			aadd( aLinhaDet, "" ) // 3
			aadd( aLinhaDet, TMP->C7_DESCRI ) // 4
			aadd( aLinhaDet, TMP->C7_UM ) // 5
			aadd( aLinhaDet, Transform(TMP->C7_QUANT, PesqPict("SC7","C7_QUANT")) ) // 6
			aadd( aLinhaDet, Transform(TMP->C7_PRECO, PesqPict("SC7","C7_PRECO")) ) // 7
			aadd( aLinhaDet, SF4->F4_CF ) // 8
			aadd( aLinhaDet, Transform(TMP->C7_PICM,PesqPict("SC7","C7_PICM")) ) // 9
			aadd( aLinhaDet, Transform(TMP->C7_VALICM,PesqPict("SC7","C7_VALICM")) ) // 10
			aadd( aLinhaDet, Transform(TMP->C7_IPI,PesqPict("SC7","C7_IPI")) ) // 11
			aadd( aLinhaDet, Transform(TMP->C7_VALIPI,PesqPict("SC7","C7_VALIPI")) ) // 12
			aadd( aLinhaDet, "" ) // 13
			aadd( aLinhaDet, "" ) // 14
			aadd( aLinhaDet, Transform(TMP->C7_TOTAL,PesqPict("SC7","C7_TOTAL")) ) // 15
			aadd( aLinhaDet, DtoC(StoD(TMP->C7_DATPRF)) ) // 16

			nSubQtd 	:= nSubQtd + TMP->C7_QUANT
			nSubTot 	:= nSubTot + TMP->C7_TOTAL
			nTotICMS 	:= nTotICMS + TMP->C7_VALICM
			nTotIPI 	:= nTotIPI + TMP->C7_VALIPI
			nTotISS 	:= nTotISS + 0
			nTotGeral 	:= nTotGeral + TMP->C7_TOTAL

// 		impressão das colunas 8 até 23
			for I := 8 to 23

				nPosX := nLin
// 			nPosX := aQuadros[ I,1 ]
				nPosY := aQuadros[ I,2 ]
				nPosX1 := nLin + 50
//		   	nPosX1 := aQuadros[ I,3 ]
				nPosY1 := aQuadros[ I,4 ]

				oPrint:Cmtr2Pix( nPosY, nPosX )
				oPrint:Cmtr2Pix( nPosY1, nPosX1 )

				oPrint:Say(nPosX, nPosY+5, aLinhaDet[I-7], oFont07, nPosX1-nPosX )
			next

			nLin := nLin + 0.3
			if nLin > 13.5
				GeraForm()

				nLin := aQuadros[ 8,1 ] + 0.7
				nPosX1 := aQuadros[ 8,3 ] + 0.7
			endif

			TMP->( DbSkip() )

			if 	cProdAtual <> TMP->C7_PRODUTO
				//sub total por produto == ordem: data de entrega
				for K := 1 to len( aQrdSubs )

					nPosX := nLin
					nPosY := aQuadros[ aQrdSubs[K],2 ]
					nPosX1 := nLin + 50
					nPosY1 := aQuadros[ aQrdSubs[K],4 ]

					oPrint:Cmtr2Pix( nPosY, nPosX )
					oPrint:Cmtr2Pix( nPosY1, nPosX1 )

					if K == 1
						cTmp := "------ " + trim(cProdAtual) + "                 Sub-Total:  "
					elseif K == 2
						cTmp := Transform(nSubQtd, PesqPict("SC7","C7_QUANT"))
					elseif K == 3
						cTmp := Transform(nSubTot, PesqPict("SC7","C7_TOTAL"))
					endif

					oPrint:Say(nPosX, nPosY+5, cTmp, oFont07b, nPosX1-nPosX )

				next

				nLin := nLin + 0.6 //duas linhas
				if nLin > 13.5
					GeraForm()

					nLin := aQuadros[ 8,1 ] + 0.7
					nPosX1 := aQuadros[ 8,3 ] + 0.7
				endif

				cProdAtual := TMP->C7_PRODUTO
				nSubQtd := 0
				nSubTot := 0
			endif


		enddo

		//Imprime os quadros de totais
		ImpTotais()

		// Visualiza a impressão
		oPrint:EndPage()
		oPrint:Preview()
		oPrint:End()
		ms_flush()
	endif

	TMP->( DbCloseArea() )

Return

//---------------------------------
//função para imprimir em um quadro
//---------------------------------
Static function ImpQuadro(nPY, nPX, nPY1, nPX1, cTit, aTxt)
	Local nH1, nW1, nCY
	Local I := 0

	cTit := alltrim( cTit )
	nPX := nPx
	nPY := nPY
	oPrint:Cmtr2Pix( nPY, nPX )

	nPX1 := nPX1
	nPY1 := nPY1
	oPrint:Cmtr2Pix( nPY1, nPX1 )

	nW1 := oPrint:GetTextWidth( cTit, oFont08b )
	nCY := nPY + ((nPY1-nPY) - nW1)/2

	oPrint:Say(nPX, nCY, cTit, oFont08b )

	nH1 := oPrint:GetTextHeight( aTXT[1], oFont08 )
	nPH := nH1 + 5
	for I := 1 to len( aTXT )
		oPrint:Say(nPX1-nPH, nPY+15, aTXT[I], oFont08 )
		nPH := nPH + nH1 + 3
	next
Return

//----------------------------------------
//função para imprimir um quadro de titulo
//----------------------------------------
Static function ImpTitulo( nPY, nPX, nPY1, nPX1, cTit )
	Local nH1
	Local nW1
	//Local nPH

	cTit := alltrim( cTit )
	nPX := nPx
	nPY := nPY
	oPrint:Cmtr2Pix( nPY, nPX )

	nPX1 := nPX1
	nPY1 := nPY1
	oPrint:Cmtr2Pix( nPY1, nPX1 )

	nW1 := oPrint:GetTextWidth( cTit, oFont14b )
	nPY := nPY + ((nPY1-nPY) - nW1)/2

	nH1 := oPrint:GetTextHeight( cTit, oFont14b )
	nPX := nPX + ((nPX1-nPX) - nH1)/2

	oPrint:Say(nPX, nPY, cTit, oFont14b )

Return

//------------------------------------------
//função para imprimir o quadro de mensagems
//------------------------------------------
Static function ImpMSG(nPY, nPX, nPY1, nPX1, cTit, aTxt)
	Local nH1, nW1, nCY
	Local I := 0

	cTit := alltrim( cTit )
	nPX := nPx
	nPY := nPY
	oPrint:Cmtr2Pix( nPY, nPX )

	nPX1 := nPX1
	nPY1 := nPY1
	oPrint:Cmtr2Pix( nPY1, nPX1 )

	nW1 := oPrint:GetTextWidth( cTit, oFont10b )
	nCY := nPY + ((nPY1-nPY) - nW1)/2

	oPrint:Say(nPX, nCY, cTit, oFont10b )

	nH1 := oPrint:GetTextHeight( aTXT[1], oFont09 )
	nPH := nH1 + 5
	for I := 1 to len( aTXT )
		oPrint:Say(nPX1-nPH, nPY + 15, trim( aTXT[I] ), oFont09 )
		nPH := nPH + nH1 + 3
	next
Return

//---------------------------------
//função para imprimir o formulario
//---------------------------------
Static Function GeraForm( nP )
	Local cMensagem, cFileLogo
	Local aTmp
	Local cTmp
	Local I := 0
	Local nX1
	Local nY1
	Local nX2
	Local nY2

	oPrint:StartPage()

	//Impressão dos quadros
	for I := 1 to len( aQuadros )
		// transformando em pixels
		nX1 := aQuadros[ I,1 ]
		nY1 := aQuadros[ I,2 ]
		nX2 := aQuadros[ I,3 ]
		nY2 := aQuadros[ I,4 ]

		// transformar medidas em pixels
		oPrint:Cmtr2Pix( nY1, nX1 )
		oPrint:Cmtr2Pix( nY2, nX2 )

		oPrint:Box( nX1, nY1, nX2, nY2 )
	next

	// imprime a linha dos titulos das colunas
	nX1 := aQuadros[ 8,1 ] + 0.7
	nY1 := aQuadros[ 8,2 ]
	nX2 := aQuadros[ 8,3 ]
	nY2 := aQuadros[ 23,4 ]

	oPrint:Cmtr2Pix( nY1, nX1 )
	oPrint:Cmtr2Pix( nY2, nX2 )

	oPrint:Line( nX1, nY1, nX1, nY2 )

	// imprime os titulos das colunas
	for I := 8 to 23

		nPosX := aQuadros[ I,1 ]
		nPosY := aQuadros[ I,2 ]
		nPosX1 := aQuadros[ I,3 ]
		nPosY1 := aQuadros[ I,4 ]

		oPrint:Cmtr2Pix( nPosY, nPosX )
		oPrint:Cmtr2Pix( nPosY1, nPosX1 )

		oPrint:Say(nPosX+5, nPosY+5, aTitulos[I-7], oFont08, nPosX1-nPosX )
	next

	//titulo da coluna provisoria -- não listada nos quadros - entre as colunas 9 e 10
	// { 2.2,  2.0, 14.5,  3.5}
	nPosX := 2.2 + 0.5
	nPosY := 2.0 + 0.5
	nPosX1 := 14.5 + 0.5
	nPosY1 := 3.5 + 0.5

	oPrint:Cmtr2Pix( nPosY, nPosX )
	oPrint:Cmtr2Pix( nPosY1, nPosX1 )

	oPrint:Say(nPosX+5, nPosY+5, "Desenho", oFont08, nPosX1-nPosX )


	//Quadro 01 - Figura
	nPosX := aQuadros[ 1,1 ]
	nPosY := aQuadros[ 1,2 ]
	nPosX1 := aQuadros[ 1,3 ]
	nPosY1 := aQuadros[ 1,4 ]

	oPrint:Cmtr2Pix( nPosY, nPosX )
	oPrint:Cmtr2Pix( nPosY1, nPosX1 )

	//cFileLogo  := GetSrvProfString('Startpath','') + 'lgrl01_h' + '.BMP'
	cFileLogo  := GetSrvProfString('Startpath','') + IF(CEMPANT='04','lgrl04_h','lgrl01_h') + '.BMP'
	oPrint:SayBitmap( nPosX, nPosY, cFileLogo, (nPosY1-nPosY), (nPosX1-nPosX) )

	//Quadro 02
	ImpTitulo(aQuadros[2,2], aQuadros[2,1], aQuadros[2,4], aQuadros[2,3], "PEDIDO DE COMPRA" )

	//Quadro 03
	ImpQuadro(aQuadros[3,2], aQuadros[3,1], aQuadros[3,4], aQuadros[3,3], "Numero    Revisão", {TMP->C7_NUM})

	//Quadro 04
	aTmp := {}
	aadd( aTmp, "e documentos relacionados a este pedido" )
	aadd( aTmp, "O numero deste pedido deve constar em todas as embalagens " )
	ImpQuadro(aQuadros[4,2], aQuadros[4,1], aQuadros[4,4], aQuadros[4,3], "", aTmp)

	//Quadro 05
	aTmp := {}
	aadd( aTmp, DtoC(StoD(TMP->C7_Emissao)) + "  pag: " + str(nPag,3) )
	ImpQuadro(aQuadros[5,2], aQuadros[5,1], aQuadros[5,4], aQuadros[5,3], "Data Emissão", aTmp)


	//Quadro 06
	aTmp := {}
	aadd( aTmp, "Tel: " + transform(SM0->M0_TEL,PesqPict("SA2","A2_CEP")) )
	aadd( aTmp, Substr(SM0->M0_ENDENT,1,35) + " CEP: " + Transform(SM0->M0_CEPENT, PesqPict("SA2","A2_CEP"))  )
	aadd( aTmp, Substr(SM0->M0_NOMECOM,1,35) + " CNPJ: " + Transform(SM0->M0_CGC, PesqPict("SA2","A2_CGC")) + "  IE: " + InscrEst()  )
	ImpQuadro(aQuadros[6,2], aQuadros[6,1], aQuadros[6,4], aQuadros[6,3], "", aTmp )

	//Quadro 07 --- Dados do Fornecedor
	SA2->( DbSelectArea(1) )
	SA2->( DbSeek( xFilial("SA2")+TMP->C7_FORNECE+TMP->C7_LOJA  ) )

	aTmp := {}
	aadd( aTmp, "Tel: (" + trim( SA2->A2_DDD ) + ") " + transform(SA2->A2_Tel, PesqPict("SA2","A2_TEL")) + "    Contato:  " + trim( SA2->A2_CONTATO ) )
	aadd( aTmp, trim( SA2->A2_LOGR ) + " " + Trim(substr( SA2->A2_END, 1, 35)) + ", " + SA2->A2_NR_END + " - " + Trim( SA2->A2_Bairro ) + "  " + trim( SA2->A2_MUN ) + "-" + SA2->A2_EST + "  CEP: " + transform(SA2->A2_CEP,PesqPict("SA2","A2_CEP")) )
	aadd( aTmp, Substr( SA2->A2_NREDUZ, 1, 35 ) + " CNPJ: " + SA2->A2_CGC + " IE: " + SA2->A2_INSCR )
	ImpQuadro(aQuadros[7,2], aQuadros[7,1], aQuadros[7,4], aQuadros[7,3], "", aTmp)

	//Quadro 29
	SE4->( DbSetOrder(1) )
	SE4->( DbSeek( xFilial("SE4") + TMP->C7_COND ) )
	ImpQuadro(aQuadros[29,2], aQuadros[29,1], aQuadros[29,4], aQuadros[29,3], "Condição Pagamento", {SE4->E4_DESCRI})

	//Quadro 30
	ImpQuadro(aQuadros[30,2], aQuadros[30,1], aQuadros[30,4], aQuadros[30,3], "Comprador", {UsrFullName( TMP->C7_USER )})

	//Quadro 31
	cTmp := "Local de entrega: " + trim(SM0->M0_ENDENT) + "  " + trim(SM0->M0_CIDENT) + "  " + trim(SM0->M0_ESTENT) + "  " + Trans(Alltrim(SM0->M0_CEPENT),"@R 99999-999")
	ImpQuadro(aQuadros[31,2], aQuadros[31,1], aQuadros[31,4], aQuadros[31,3], cTmp, {""})

	//Quadro 32
	cTmp := "Local de cobrança: " + trim(SM0->M0_ENDCOB) + "  " + trim(SM0->M0_CIDCOB) + "  " + trim(SM0->M0_ESTCOB) + "  " + Trans(trim(SM0->M0_CEPCOB),"@R 99999-999")
	ImpQuadro(aQuadros[32,2], aQuadros[32,1], aQuadros[32,4], aQuadros[32,3], cTmp, {""})

	//Quadro 33
	aTmp := {}
//	aadd( aTmp, "Entrega no Predio B - Area de Assistencia Tecnica" )
//	aadd( aTmp, "6a feira, das 7:30hs as 11:45hs e 13:00hs as 15:00hs" )
//	aadd( aTmp, "2a a 5a feira, das 7:30hs as 11:45hs e 13:00hs as 16:00hs" )
	aadd( aTmp, mv_par10 )
	aadd( aTmp, mv_par09 )
	aadd( aTmp, mv_par08 )
	aadd( aTmp, mv_par07 )
	ImpMSG(aQuadros[33,2], aQuadros[33,1], aQuadros[33,4], aQuadros[33,3], "Instrução de Entrega", aTmp )

	//Quadro 34
	aTmp := {}
	cMensagem := Formula(TMP->C7_MSG)
//	aadd( aTmp, " " )
//	aadd( aTmp, "Cada nota fiscal não deverá conter itens de pedidos de compras diferentes" )
//	aadd( aTmp, "Cada embalagem do lote a ser entregue deverá constar o respectivo número da nota fiscal" )
//	aadd( aTmp, "A QUANTIDADE FORNECIDA NÃO PODERA EXCEDER A QUANTIDADE DO PEDIDO DE COMPRA" )
	aadd( aTmp, mv_par14 )
	aadd( aTmp, mv_par13 )
	aadd( aTmp, mv_par12 )
	aadd( aTmp, mv_par11 )
	aadd( aTmp, iif(Empty(cMensagem), "", cMensagem ))
	ImpMSG(aQuadros[34,2], aQuadros[34,1], aQuadros[34,4], aQuadros[34,3], "Observações", aTmp )

	nPag :=  + 1

return( .t. )

//----------------------------------------
//função para imprimir os totais do pedido
//----------------------------------------
Static Function ImpTotais()
	//Local aTmp
	Local cTmp
	Local I := 0

	//Quadro 25
	ImpQuadro(aQuadros[25,2], aQuadros[25,1], aQuadros[25,4], aQuadros[25,3], "Total ICMS", {Transform(nTotICMS,PesqPict("SC7","C7_VALICM"))})

	//Quadro 26
	ImpQuadro(aQuadros[26,2], aQuadros[26,1], aQuadros[26,4], aQuadros[26,3], "Total IPI", {Transform(nTotIPI,PesqPict("SC7","C7_VALICM"))})

	//Quadro 27
	ImpQuadro(aQuadros[27,2], aQuadros[27,1], aQuadros[27,4], aQuadros[27,3], "Total ISS", {Transform(nTotISS,PesqPict("SC7","C7_VALICM"))})

	//Quadro 28
	ImpQuadro(aQuadros[28,2], aQuadros[28,1], aQuadros[28,4], aQuadros[28,3], "Total Geral", {Transform(nTotGeral,PesqPict("SC7","C7_VALICM"))})

	//Quadro 24 --- Natureza da operação
	cTmp := ""
	for I := 1 to len( aNatur )
		cTmp := cTmp + trim( aNatur[I] ) + " == "
	next
	ImpQuadro(aQuadros[24,2], aQuadros[24,1], aQuadros[24,4], aQuadros[24,3], "Natureza Operação", {cTmp})

return
