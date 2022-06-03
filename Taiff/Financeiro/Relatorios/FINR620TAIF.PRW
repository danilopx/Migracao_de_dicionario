#Include "FINR620.CH"
#Include "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ FINR620	³ Autor ³ Wagner Xavier 	  	  ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 		  						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR620(void)															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												    			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FINR620TAI()

	Local oReport
	Local aAreaR4	:= GetArea()

	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		Return FinR620R3T() // Executa versão anterior do fonte
	Endif

	RestArea(aAreaR4)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Marcio Menon		   º Data ³  07/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 											      			           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

	Local oReport
	Local oSection1
	Local oSection2
	Local oSection3
	Local cReport 	:= "FINR620(CUSTOM)" 		// Nome do relatorio
	Local cDescri 	:= "Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria" +;		//"Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria"
	"de acordo com os parametros definidos pelo usuario. Poder  ser" +;	//"de acordo com os parametros definidos pelo usuario. Poder  ser"
	"impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."		//"impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."
	Local cTitulo 	:= "Relacao da Movimentacao Bancaria" 			//"Relacao da Movimentacao Bancaria"
	Local cPerg		:= "FIN620TAIF"			// Nome do grupo de perguntas
	Local aOrdem	:= {OemToAnsi("Por Dt.Dispo"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Dt.Digitacao"),OemToAnsi("Por Dt. Movimentacao")}  //"Por Dt.Dispo"###"Por Banco"###"Por Natureza"###"Dt.Digitacao"###"Por Dt. Movimentacao"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("FIN620TAIF",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri)

	If mv_par11 == 1			//Analitico
		oReport:SetLandscape()	//Imprime o relatorio no formato paisagem
	Else                 		//Sintetico
		oReport:SetPortrait()	//Imprime o relatorio no formato retrato
	EndIf

	oReport:HideParamPage(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1 := TRSection():New(oReport, "Saldo anterior dos bancos", /*"SE5"*/, aOrdem) //"Saldo anterior dos bancos"
	DbSelectArea('SX3')
	DbSetOrder(2)
	DbSeek('E5_BANCO')
	cDescBanco	:=	 X3Titulo("E5_BANCO")
	DbSeek('E5_AGENCIA')
	cDescAge		:=	 X3Titulo("E5_AGENCIA")
	DbSeek('E5_CONTA')
	cDescConta	:=	 X3Titulo("E5_CONTA")
	DbSeek('E5_NATUREZ')
	cDescNat  	:=	 X3Titulo("E5_NATUREZ")
	DbSeek('E5_DOCUMEN')
	cDescDoc		:=	 X3Titulo("E5_DOCUMEN")
	DbSeek('E5_HISTOR')
	cDescHist 	:=	 X3Titulo("E5_HISTOR")


	TRCell():New(oSection1, "TXTSALDO"     , "" , "Saldo anterior a " , , 17 ,/*lPixel*/,{ || "Saldo anterior a " } )	//"Saldo anterior a "
	TRCell():New(oSection1, "DATA"   		, "" , "DATA" , PesqPict("SE5","E5_DATA") , TamSX3("E5_DATA")[1] ,/*lPixel*/,/*CodeBlock*/)	//"DATA"
	TRCell():New(oSection1, "TODOSBCO"     , "" , " (Todos os bancos): " 	, , 22 ,/*lPixel*/,{ || " (Todos os bancos): " })		//" (Todos os bancos): "
	TRCell():New(oSection1, "BANCO"   		, "" , cDescBanco , PesqPict("SE5","E5_BANCO")   , TamSX3("E5_BANCO")[1]   	,/*lPixel*/,/*CodeBlock*/)	//"BCO"
	TRCell():New(oSection1, "AGENCIA"		, "" , cDescAGE	, PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1] ,/*lPixel*/,/*CodeBlock*/)	//"AGENCIA"
	TRCell():New(oSection1, "CONTA"    		, "" , cDescCONTA , PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]	   ,/*lPixel*/,/*CodeBlock*/)	//"CONTA"
	TRCell():New(oSection1, "SALDOANTERIOR", "" , "Saldo anterior" , PesqPict("SE8","E8_SALANT")	, TamSX3("E8_SALANT")[1]	 ,/*lPixel*/,/*CodeBlock*/)

	oSection1:Cell("TODOSBCO"):Disable()
	oSection1:Cell("SALDOANTERIOR"):SetHeaderAlign("RIGHT")
	oSection1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2 := TRSection():New(oReport, "Movimentacao Bancaria", {"SE5","SA6","SED"}, aOrdem) //"Movimentacao Bancaria"
	TRCell():New(oSection2, "DATA"			, "SE5" , "DATA" 	, PesqPict("SE5","E5_DTDISPO")	, TamSX3("E5_DTDISPO")[1]	,/*lPixel*/,/*CodeBlock*/)	//"DATA"
	TRCell():New(oSection2, "BANCO"   		, "SE5" , cDescBANCO	, PesqPict("SE5","E5_BANCO")    , TamSX3("E5_BANCO")[1]  	,/*lPixel*/,{|| SE5->E5_BANCO}/*CodeBlock*/)	//"BCO"
	TRCell():New(oSection2, "AGENCIA"		, "SE5" , cDescAGE	, PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1]	,/*lPixel*/,{|| SE5->E5_AGENCIA}/*CodeBlock*/)	//"AGENCIA"
	TRCell():New(oSection2, "CONTA"    		, "SE5" , cDescCONTA	, PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]		,/*lPixel*/,{|| SE5->E5_CONTA}/*CodeBlock*/)	//"CONTA"
	TRCell():New(oSection2, "NATUREZA"		, "SE5" , cDescNAT 	, PesqPict("SE5","E5_NATUREZ")	, TamSX3("E5_NATUREZ")[1]	,/*lPixel*/,{|| SE5->E5_NATUREZ}/*CodeBlock*/)	//"NATUREZA"
	TRCell():New(oSection2, "DOCUMENTO" 	, "SE5" , cDescDOC 	, PesqPict("SE5","E5_NUMCHEQ")  , TamSX3("E5_NUMCHEQ")[1] 	,/*lPixel*/,{|| SE5->E5_NUMCHEQ}/*CodeBlock*/)	//"DOCUMENTO"
	TRCell():New(oSection2, "ENTRADA"		, "" 	  , "ENTRADA" 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]   ,/*lPixel*/,/*CodeBlock*/)	//"ENTRADA"
	TRCell():New(oSection2, "SAIDA"    		, ""    , "SAIDA" 	, PesqPict("SE5","E5_VALOR")    , TamSX3("E5_VALOR")[1]  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
	TRCell():New(oSection2, "SALDOATUAL"	, "" 	  , "SALDO ATUAL" 	, PesqPict("SE8","E8_SALANT")  	, TamSX3("E8_SALANT")[1] 	,/*lPixel*/,/*CodeBlock*/)	//"SALDO ATUAL"
	TRCell():New(oSection2, "SEPARADOR"		, ""	  , ""		 	, ,2,/*lPixel*/,/*CodeBlock*/)
	TRCell():New(oSection2, "HISTORICO"		, ""	  , cDescHIST 	, PesqPict("SE5","E5_HISTOR")   , TamSX3("E5_HISTOR")[1]	,/*lPixel*/,{|| SE5->E5_HISTOR}/*CodeBlock*/)	//"HISTORICO"

	TrPosition():New(oSection2,'SA6',1,{|| xFilial('SA6')+ SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA })
	TrPosition():New(oSection2,'SED',1,{|| xFilial('SED')+ SE5->E5_NATUREZ })

//Faz o alinhamento do texto da celula
	oSection2:Cell("ENTRADA"   ):SetHeaderAlign("RIGHT")
	oSection2:Cell("SAIDA"     ):SetHeaderAlign("RIGHT")
	oSection2:Cell("SALDOATUAL"):SetHeaderAlign("RIGHT")

	oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 03                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection3 := TRSection():New(oReport, "Totais", /*a/cAlias*/, aOrdem) //"Totais"

	TRCell():New(oSection3, "TXTTOTAL"     , "" , "Total : " 	, , 08 ,/*lPixel*/,{ || "Total : " } )	//"Total : "
	TRCell():New(oSection3, "DATA"   	   , "" , "DATA"		, PesqPict("SE5","E5_DATA")  		, TamSX3("E5_DATA")[1] 		,/*lPixel*/,/*CodeBlock*/)	//"DATA"
	TRCell():New(oSection3, "BANCO"   		, "" , cDescBanco , PesqPict("SE5","E5_BANCO")    	, TamSX3("E5_BANCO")[1]   	,/*lPixel*/,/*CodeBlock*/)	//"BCO"
	TRCell():New(oSection3, "AGENCIA"		, "" , cDescAGE   , PesqPict("SE5","E5_AGENCIA")	, TamSX3("E5_AGENCIA")[1]	,/*lPixel*/,/*CodeBlock*/)	//"AGENCIA"
	TRCell():New(oSection3, "CONTA"    		, "" , cDescConta , PesqPict("SE5","E5_CONTA")  	, TamSX3("E5_CONTA")[1]		,/*lPixel*/,/*CodeBlock*/)	//"CONTA"
	TRCell():New(oSection3, "NATUREZA"		, "" , cDescNat	, PesqPict("SE5","E5_NATUREZ")	, 17	,/*lPixel*/,/*CodeBlock*/)	//"NATUREZA", 40 ,/*lPixel*/,/*CodeBlock*/)	//"NATUREZA"
	TRCell():New(oSection3, "ENTRADA"		, "" , "ENTRADA" , PesqPict("SE5","E5_VALOR")    	, TamSX3("E5_VALOR")[1]   ,/*lPixel*/,/*CodeBlock*/)	//"ENTRADA"
	TRCell():New(oSection3, "SAIDA"    		, "" , "SAIDA" , PesqPict("SE5","E5_VALOR")    	, TamSX3("E5_VALOR")[1]  	,/*lPixel*/,/*CodeBlock*/)	//"SAIDA"
	TRCell():New(oSection3, "SALDOATUAL"	, "" , "SALDO ATUAL" , PesqPict("SE8","E8_SALANT")  	, TamSX3("E8_SALANT")[1] 	,/*lPixel*/,/*CodeBlock*/)	//"SALDO ATUAL"

//Oculta as colunas

	oSection3:Cell("DATA"    ):Hide()
	oSection3:Cell("BANCO"   ):Hide()
	oSection3:Cell("AGENCIA" ):Hide()
	oSection3:Cell("CONTA"   ):Hide()
	oSection3:Cell("NATUREZA"):Hide()
	oSection3:Cell("SALDOATUAL"):Hide()

	oSection3:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor³ Marcio Menon       º Data ³  07/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o objeto oReport definido na funcao ReportDef.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPO1 - Objeto TReport do relatorio                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport, cTitulo)

	Local oSection1 	:= oReport:Section(1)
	Local oSection2 	:= oReport:Section(2)
	Local oSection3 	:= oReport:Section(3)
	Local nOrdem		:= oReport:Section(1):GetOrder()

	//Local CbCont
	//Local CbTxt
	Local nTotEnt := 0
	Local nTotSai := 0
	Local nGerEnt := 0
	Local nGerSai := 0
	//Local nColuna := 0
	Local lContinua := .T.
	Local nValor,cDoc
	Local lVazio  := .T.
	Local nMoeda

	#IFDEF TOP
		Local ni
		Local aStru 	:= SE5->(dbStruct())
		Local cIndice	:= SE5->(IndexKey())
	#ELSE
		Local nOrdSE5 	:=SE5->(IndexOrd())
		Local cChave
	#ENDIF

	Local cIndex
	Local cHistor
	Local cChaveSe5
	Local nTxMoeda		:=0
	Local nMoedaBco	:=	1
	Local nCasas		:= GetMv("MV_CENT"+(IIF(mv_par09 > 1 , STR(mv_par09,1),"")))
	Local bWhile   	:= { || IF( mv_par12 == 1, .T., SE5->E5_FILIAL == xFilial("SE5") ) }
	Local nTotSaldo 	:= 0
	Local aSaldo
	Local nGerSaldo 	:= 0
	Local nSaldoAtual := 0
	Local lFirst 		:= .T.
	Local nTxMoedBc	:= 0
	Local cPict 		:= ""
	Local nA				:= 0
	Local cFilterUser := ""
	Local lF620Qry 	:= ExistBlock("F620QRY")
	Local cQueryAdd 	:= ""
	Local nSaldoAnt 	:= 0
	Local lImpSaldo 	:= .F.
	Local nAscan 		:= 0
	Local cAnterior 	:= ""
	Local nBancos 		:= 0
	Local cCond2 		:= ""
	Local cCond3 		:= ""
	Local cMoeda		:= ""
	Local cFilterSA6	:=	oSection2:GetAdvplExp('SA6')
	Local cFilterSE5	:=	oSection2:GetAdvplExp('SE5')
	Local cFilterSED	:=	oSection2:GetAdvplExp('SED')

	cIndex := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso so'exista uma empresa/filial ou o SE5 seja compartilhado³
//³ nao ha' necessidade de ser processado por filiais            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par12 := Iif(SM0->(Reccount()) == 1 .or. Empty(xFilial("SE5")),2,mv_par12)
	aSaldo := GetSaldos( MV_PAR12 == 1, nMoeda, If(mv_par12==1,mv_par13,xFilial("SA6")), If(mv_par12==1,mv_par14,xFilial("SA6")), mv_par01, mv_par03, mv_par04, mv_par17, mv_par18, mv_par19, mv_par20)

	cMoeda := Str(mv_par09,1,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos												  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1
		cTitulo := "Relacao da Movimentacao Bancaria em "
		If nOrdem == 3 .And. mv_par15 == 1 // Ordem de natureza nao sera impresso os saldos
			oSection2:Cell("SALDOATUAL"):Disable()
		Else
			oSection2:Cell("SALDOATUAL"):Enable()
		Endif
	Else
		cTitulo := "Movimentação Bancária em "
		oSection2:Cell("DATA"):Hide()
		oSection2:Cell("DATA"):SetTitle("")
		oSection2:Cell("BANCO"):Hide()
		oSection2:Cell("BANCO"):SetTitle("")
		oSection2:Cell("AGENCIA"):Hide()
		oSection2:Cell("AGENCIA"):SetTitle("")
		oSection2:Cell("CONTA"):Hide()
		oSection2:Cell("CONTA"):SetTitle("")
		oSection2:Cell("NATUREZA"):Hide()
		oSection2:Cell("NATUREZA"):SetTitle("")
		oSection2:Cell("DOCUMENTO"):Hide()
		oSection2:Cell("DOCUMENTO"):SetTitle("")
		oSection2:Cell("HISTORICO"):Disable()
		oSection2:Cell("HISTORICO"):SetTitle("")
		If mv_par15 == 1
			oSection2:Cell("SALDOATUAL"):Enable()
		Else
			oSection2:Cell("SALDOATUAL"):Disable()
		EndIF
	Endif

	nMoeda	:= mv_par09
	cTitulo  += GetMv("MV_MOEDA"+Str(nMoeda,1)) + " - " + If(mv_par11==1, "Analitico", "Sintetico") + " - " //" - "###"Analitico"###"Sintetico"###" - "

	dbSelectArea("SE5")

	#IFDEF TOP
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5")
		IF mv_par12 == 1
			cQuery += " WHERE E5_FILIAL BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "'"
		ELSE
			cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
		ENDIF
		cQuery += " AND D_E_L_E_T_ <> '*' "
	#ENDIF

	If nOrdem == 1
		cTitulo += OemToAnsi(" por data")  //" por data"
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2 		:= "E5_DTDISPO"
			IF mv_par12 == 1
				cOrder		:= "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
			ELSE
				cOrder		:= "E5_FILIAL+E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
			ENDIF
		#ELSE
			cCondicao 	:= "DTOS(E5_DTDISPO) >= DTOS(mv_par01) .and. DTOS(E5_DTDISPO) <= DTOS(mv_par02)"
			cCond2 		:= "E5_DTDISPO"
			dbSelectArea("SE5")
			dbSetOrder(nOrdSE5)
			cIndex	:= CriaTrab(nil,.f.)
			IF mv_par12 == 1
				cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
			ELSE
				cChave	:= "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,,;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
			ENDIF
			nIndex	 := RetIndex("SE5")
			dbSelectArea("SE5")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			IF mv_par12 == 1
				dbSeek(DtoS(mv_par01),.T.)
			ELSE
				dbSeek(xFilial()+DtoS(mv_par01),.T.)
			ENDIF
		#ENDIF
	Elseif nOrdem == 2
		cTitulo += OemToAnsi(" por Banco")  //" por Banco"
		SE5->(dbSetOrder(3))
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
			cIndice := SE5->(IndexKey())
			IF mv_par12 == 1
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1)) + "+E5_FILIAL"
			ENDIF
			cOrder := cIndice
		#ELSE
			cCondicao := "E5_BANCO >= '"+mv_par03 +"'.and. E5_BANCO <= '"+mv_par04+"'"
			cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
			IF mv_par12 == 1
				cIndex	:= CriaTrab(nil,.f.)
				cChave	:= SE5->(INDEXKEY())
				cChave   := ALLTRIM(SUBSTR(cChave, AT("+",cChave)+1)) + "+E5_FILIAL"
				IndRegua("SE5" ,;
					cIndex,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(DBSEEK(mv_par03,.T. ))
			ELSE
				SE5->(dbSetOrder(3))
				SE5->(dbSeek(xFilial("SE5")+mv_par03,.T.))
			ENDIF
		#ENDIF
	Elseif nOrdem == 3
		cTitulo += OemToAnsi(" por Natureza")  //" por Natureza"
		SE5->(dbSetOrder(4))
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2		:= "E5_NATUREZ"
			cIndice := SE5->(IndexKey())
			IF mv_par12 == 1
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1))+"+E5_FILIAL"
			ENDIF
			cOrder := cIndice
		#ELSE
			cCondicao := "E5_NATUREZ >='"+ mv_par05 +"'.and. E5_NATUREZ <= '"+mv_par06+"'"
			cCond2	 := "E5_NATUREZ"
			IF mv_par12 == 1
				cIndex := CriaTrab(NIL,.F.)
				cChave := SE5->(INDEXKEY())
				cChave := ALLTRIM(SUBSTR(cChave,AT("+",cChave)+1))+"+E5_FILIAL"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(DBSEEK(mv_par05,.T.))
			ELSE
				SE5->(dbSeek(xFilial("SE5")+mv_par05,.T.))
			ENDIF
		#ENDIF
	Elseif nOrdem == 4 // Digitacao
		IF mv_par12 == 1
			cOrder	 := "DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
		ELSE
			cOrder	 := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
		ENDIF
		cCond2	  := "E5_DTDIGIT"

		#IFDEF TOP
			cCondicao 	:= ".T."
		#ELSE
			cCondicao := "E5_DTDIGIT >= mv_par07 .and. E5_DTDIGIT <= mv_par08"
			cTitulo += OemToAnsi("  Por Data de Digitacao")  //"  Por Data de Digitacao"
			cIndex:=CriaTrab("",.F.)
			dbSelectArea("SE5")
			IF mv_par12 == 1
				IndRegua("SE5",;
					cIndex ,;
					cOrder,,;
					"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(DTOS(mv_par07),.T.))
			ELSE
				IndRegua("SE5",cIndex,cOrder,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par07),.T.))
			ENDIF
		#ENDIF
	ElseIf nOrdem >= 5 // Data da Movimentacao
		If mv_par12 == 1
			cOrder := "DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
		Else
			cOrder := "E5_FILIAL+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
		Endif
		cCond2 := "E5_DATA"

		#IFDEF TOP
			cCondicao 	:= ".T."
		#ELSE
			cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
			cTitulo    += OemToAnsi("Por Dt. Movimentacao") // "Por Dt. Movimentacao"
			cIndex    := CriaTrab("",.F.)
			dbSelectArea("SE5")
			If mv_par12 == 1
				IndRegua("SE5", cIndex, cOrder,,;
					"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(DTOS(mv_par01),.T.))
			Else
				IndRegua("SE5",cIndex,cOrder,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par01),.T.))
			Endif
		#ENDIF
	EndIF

	#IFDEF TOP
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_NUMCHEQ <> '%*'"
		cQuery += " AND E5_VENCTO <= E5_DATA "
		cQuery += " AND E5_DTDISPO BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02) + "'"
		cQuery += " AND E5_BANCO BETWEEN   '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND E5_AGENCIA BETWEEN   '" + Alltrim(mv_par17) + "' AND '" + Alltrim(mv_par18) + "'"
		cQuery += " AND E5_CONTA BETWEEN   '" + Alltrim(mv_par19) + "' AND '" + Alltrim(mv_par20) + "'"
		If !Empty(oSection2:GetSqlExp('SE5'))
			cQuery += " AND (" +oSection2:GetSqlExp('SE5')+")"
		Endif
		cQuery += " AND E5_BANCO <> '   ' "
		cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par05        + "' AND '" + mv_par06       + "'"
		cQuery += " AND E5_DTDIGIT BETWEEN '" + DTOS(mv_par07)        + "' AND '" + DTOS(mv_par08)       + "'"
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL') "
		If lF620Qry
			cQueryAdd := ExecBlock("F620QRY", .F., .F.)
			If ValType(cQueryAdd) == "C"
				cQuery += " AND ( " + cQueryAdd + ")"
			EndIf
		EndIf
		cQuery += " ORDER BY " + SqlOrder(cOrder)

		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)

		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next

	#ENDIF

	oReport:SetMeter(Len(aSaldo))
	oReport:SetTitle(cTitulo)	//Altera o Titulo do relatorio

	For nBancos := 1 To IIf(nOrdem == 2, Len(aSaldo), 1)

		nTotEnt:=0
		nTotSai:=0
		nTotSaldo := 0
		lImpSaldo := (lFirst .And. nOrdem != 3) // Indica se o saldo anterior deve ser impresso

		If nOrdem == 2
			nSaldoAtual := 0
		Endif
		nSaldoAnt := 0

		// Pesquisa o saldo bancario
		If (Empty(cFilterUser) .And. nOrdem == 2) .Or. nOrdem <> 2
			If mv_par15 == 1 .And. lImpSaldo
				nSaldoAnt := 0
				If nOrdem == 2 // Ordem de banco
					If (!Empty(aSaldo[nBancos][2]) .And. !Empty(aSaldo[nBancos][3]) .And. !Empty(aSaldo[nBancos][4]))
						cCond3:=aSaldo[nBancos][2]+aSaldo[nBancos][3]+aSaldo[nBancos][4]
					Else
						cCond3 := "EOF"
					EndIf
					nAscan := Ascan(aSaldo, {|e| e[2]+e[3]+e[4] == cCond3 } )
					If nAscan > 0
						nSaldoAnt := Round(xMoeda(aSaldo[nAscan][6],nMoedaBco,mv_par09,IIf(SE5->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
					Else
						nSaldoAnd := 0
					Endif
					lFirst := .T.
				Else
					// Na primeira vez, soma todos os saldos de todos os bancos
					If lFirst
						// Soma os saldos de todos os bancos
						For nA := 1 To Len(aSaldo)
							nSaldoAnt += Round(xMoeda(aSaldo[nA][6],MoedaBco(aSaldo[nA][2],aSaldo[nA][3],aSaldo[nA][4]),mv_par09,IIf(SE5->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
						Next
						lFirst := .F.
					Else
						// Apos a impressao da primeira linha, o saldo Anterior sera igual ao
						// saldo atual, impresso na ultima linha, antes da quebra de data
						If ( cPaisLoc == "BRA" )
							nSaldoAnt := nSaldoAtual
						Else
							nSaldoAnt := Round(xMoeda(nSaldoAtual,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
						Endif
					Endif
				Endif

				cPict := tm(nSaldoAnt,18,nCasas)

				oSection1:Cell("DATA"   ):SetBlock( { || DTOC(mv_par01) } )
				oSection1:Cell("BANCO"  ):Disable()
				oSection1:Cell("AGENCIA"):Disable()
				oSection1:Cell("CONTA"  ):SetSize(11)

				If nOrdem == 2
					oSection1:Cell("TODOSBCO"):Disable()
					oSection1:Cell("BANCO"   ):Enable()
					oSection1:Cell("BANCO"   ):SetBlock( { || aSaldo[nBancos][2] } )
					oSection1:Cell("AGENCIA" ):Enable()
					oSection1:Cell("AGENCIA" ):SetBlock( { || aSaldo[nBancos][3] } )
					oSection1:Cell("CONTA"   ):Enable()
					oSection1:Cell("CONTA"   ):SetSize(20)
					oSection1:Cell("CONTA"   ):SetBlock( { || aSaldo[nBancos][4] } )
				Else
					oSection1:Cell("TODOSBCO"):Enable()
				EndIf
				oSection1:Cell("SALDOANTERIOR"):SetBlock( { || nSaldoAnt } )
				oSection1:Cell("SALDOANTERIOR"):Picture( cPict )
				nSaldoAtual := nSaldoAnt
			Else
				oSection1:Disable()	 //Desabilita a secao dos saldos
			Endif

			oSection1:Init()
			oSection1:PrintLine()
			oSection1:Finish()

		EndIf

		While SE5->(!Eof()) .And. EVAL(bWhile) .And. &cCondicao .and. lContinua

			#IFNDEF TOP
				If !Fr620Skip1()
					SE5->(dbSkip())
					Loop
				EndIf
			#ENDIF

			oReport:IncMeter()

			IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
				SE5->(dbSkip())
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Na transferencia somente considera nestes numerarios 		  ³
			//³ No Fina100 ‚ tratado desta forma.                    		  ³
			//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
			//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
			//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
			//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
			//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
				If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
					SE5->(dbSkip())
					Loop
				Endif
			Endif

			If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
					.or. Substr(E5_DOCUMEN,1,1) == "*" )
				SE5->(dbSkip())
				Loop
			Endif

			If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		//Sangria
				SE5->(dbSkip())
				Loop
			Endif

			cAnterior := &cCond2
			nTotEnt	 := 0
			nTotSai	 := 0
			nTotSaldo := 0

			If nOrdem == 2
				lImpSaldo 	:= (lFirst .And. nOrdem != 3) // Indica se o saldo anterior deve ser impresso
				//nSaldoAtual 	:= 0
				//nSaldoAnt 	:= 0
			EndIf

			If nOrdem == 2
				cCond3:="E5_BANCO=='"+aSaldo[nBancos][2]+"' .And. E5_AGENCIA=='"+aSaldo[nBancos][3]+"' .And. E5_CONTA=='"+aSaldo[nBancos][4]+"'"
			Else
				cCond3:=".T."
			Endif

			While SE5->(!EOF()) .and. &cCond2 = cAnterior .and. EVAL(bWhile) .and. lContinua .And. &cCond3

				IF Empty(E5_BANCO)
					SE5->(dbSkip())
					Loop
				Endif

				oReport:IncMeter()

				IF E5_SITUACA == "C"
					SE5->(dbSkip())
					Loop
				EndIF

				IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
					SE5->(dbSkip())
					Loop
				EndIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Na transferencia somente considera nestes numerarios 		  ³
				//³ No Fina100 ‚ tratado desta forma.                    		  ³
				//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
				//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
				//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
				//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
				//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
					If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
						SE5->(dbSkip())
						Loop
					Endif
				Endif

				If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
						.or. Substr(E5_DOCUMEN,1,1) == "*" )
					SE5->(dbSkip())
					Loop
				Endif

				If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
					SE5->(dbSkip())
					Loop
				Endif

				IF E5_VENCTO > E5_DATA
					SE5->(dbSkip())
					Loop
				EndIF

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se esta' FORA dos parametros                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				IF (E5_DTDISPO < mv_par01) .or. (E5_DTDISPO > mv_par02)
					SE5->(dbSkip())
					Loop
				Endif

				IF (E5_BANCO	< mv_par03) .or. (E5_BANCO  > mv_par04)
					SE5->(dbSkip())
					Loop
				EndIf

				IF (E5_NATUREZ < mv_par05) .or. (E5_NATUREZ > mv_par06)
					SE5->(dbSkip())
					Loop
				EndIF

				IF (E5_DTDIGIT < mv_par07) .or. (E5_DTDIGIT > mv_par08)
					SE5->(dbSkip())
					Loop
				EndIF

				IF E5_TIPODOC $ "DCüJRüMTüBAüMTüCMüD2/J2/M2/C2/V2/CX/CP/TL"
					SE5->(dbSkip())
					Loop
				Endif

				//  Para o Sigaloja, quando for sangria e nao for R$, nÆo listar nos
				// movimentos bancarios

				If (E5_TIPODOC == "SG") .And. (!E5_MOEDA $ "R$"+IIf(cPaisLoc=="BRA","","/$ ")) //Sangria com moeda <> R$
					SE5->(dbSkip())
					Loop
				EndIf

				If SubStr(E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
					SE5->(dbSkip())
					Loop
				Endif

				If !Empty( E5_MOTBX )
					If !MovBcoBx(E5_MOTBX)
						SE5->(dbSkip())
						Loop
					Endif
				Endif

				If !Empty(cFilterSE5) .And. !SE5->(&(cFilterSE5))
					SE5->(dbSkip())
					Loop
				Endif
				If !Empty(cFilterSA6)
					SA6->(DbSetOrder(1))
					SA6->(MsSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
					If !SA6->(&(cFilterSA6))
						SE5->(dbSkip())
						Loop
					Endif
				Endif
				If !Empty(cFilterSED)
					SED->(DbSetOrder(1))
					SED->(MsSeek(xFilial()+SE5->E5_NATUREZ))
					If !SED->(&(cFilterSED))
						SE5->(dbSkip())
						Loop
					Endif
				Endif
				If cPaisLoc	# "BRA"
					SA6->(DbSetOrder(1))
					SA6->(MsSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
					nMoedaBco := Max(SA6->A6_MOEDA,1)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SE5->(FieldPos('E5_TXMOEDA')) > 0
						nTxMoedBc := SE5->E5_TXMOEDA
					Else
						nTxMoedBc := 0
					Endif
					If mv_par09 > 1 .and. !Empty(E5_VLMOED2)
						nTxMoeda := RecMoeda(E5_DTDISPO,mv_par09)
						nTxMoeda := if(nTxMoeda=0,1,nTxMoeda)
						nValor 	:= Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,,nCasas+1,nTxMoedBc,nTxMoeda),nCasas)
					Else
						nValor 	:= Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
					Endif
				Else
					nValor := xMoeda(E5_VALOR,1,mv_par09,E5_DATA)
				Endif
				lVazio := .F.
				// Calcula saldo atual
				nSaldoAtual := If(E5_RECPAG = "R",nSaldoAtual+nValor,nSaldoAtual-nValor)

				If mv_par11 == 1	//Analitico

					oSection2:Cell("DATA"):SetBlock( { || If(nOrdem != 5, SE5->E5_DTDISPO, SE5->E5_DATA) } )

					If Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 14
						cDoc := Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ )
					Endif

					If Empty(cDoc)
						cDoc := Alltrim(E5_PREFIXO)+if(!empty(E5_PREFIXO),"-","")+;
							Alltrim(E5_NUMERO )+if(!empty(E5_PARCELA),"-"+E5_PARCELA,"")
					Endif

					If Substr( cDoc,1,1 ) == "*"
						SE5->(dbSkip())
						Loop
					Endif

					oSection2:Cell("DOCUMENTO"):SetBlock( { || cDoc } )

					If E5_RECPAG = "R"
						oSection2:Cell("ENTRADA"):SetBlock  ( { || nValor } )
						oSection2:Cell("ENTRADA"):SetPicture( Tm(nValor,16,MsDecimais(mv_par09)) )
						oSection2:Cell("SAIDA"  ):SetBlock  ( { ||  } )
					Else
						oSection2:Cell("SAIDA"  ):SetBlock  ( { || nValor } )
						oSection2:Cell("SAIDA"  ):SetPicture( Tm(nValor,16,MsDecimais(mv_par09)) )
						oSection2:Cell("ENTRADA"):SetBlock  ( { ||  } )
					EndIF

					If nOrdem != 3 .And. mv_par15 == 1
						oSection2:Cell("SALDOATUAL"):SetBlock( { || nSaldoAtual } )
						oSection2:Cell("SALDOATUAL"):SetPicture( Tm(nSaldoAtual,18,MsDecimais(mv_par09)) )
					Else
						oSection2:Cell("SALDOATUAL"):Disable()
					EndIf
				Else
					oSection2:Disable()
				EndIf

				If E5_RECPAG = "R"
					nTotEnt += nValor
				Else
					nTotSai += nValor
				EndIf

				nTotSaldo += nSaldoAtual

				If mv_par11 == 1
					If mv_par10 == 1	// Imprime normalmente
						oSection2:Cell("HISTORICO"):SetBlock( { || SE5->E5_HISTOR } )
					Else					// Busca historico do titulo
						If E5_RECPAG == "R"
							cHistor		:= E5_HISTOR
							cChaveSe5	:=xFilial("SE1") + E5_PREFIXO + ;
								E5_NUMERO + E5_PARCELA + ;
								E5_TIPO
							dbSelectArea("SE1")
							DbSetOrder(1)
							dbSeek( cChaveSe5 )
							oSection2:Cell("HISTORICO"):SetBlock( { || If(Empty(SE1->E1_HIST), cHistor, SE1->E1_HIST) } )
						Else
							cHistor		:= E5_HISTOR
							cChaveSe5	:= xFilial("SE2") + E5_PREFIXO + ;
								E5_NUMERO + E5_PARCELA + ;
								E5_TIPO	 + E5_CLIFOR
							dbSelectArea("SE2")
							DbSetOrder(1)
							dbSeek( cChaveSe5 )
							oSection2:Cell("HISTORICO"):SetBlock( { || If(Empty(SE2->E2_HIST), cHistor, SE2->E2_HIST) } )
						Endif
					Endif
				Endif
				oSection2:Init()
				oSection2:PrintLine()
				dbSelectArea("SE5")
				dbSkip()
			Enddo

			oSection2:Finish()

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao dos totais das secoes.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( nTotEnt + nTotSai ) != 0

				IF nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5		//Data Dispo. # Digitacao # Data Movimentacao
					oSection2:Enable()
					oSection3:Cell("DATA"):Show()
					oSection3:Cell("DATA"):SetBlock( { || DTOC(cAnterior) } )
				Elseif nOrdem == 2 	//Banco
					oSection3:Cell("DATA"   ):Disable()
					oSection3:Cell("BANCO"  ):Show()
					oSection3:Cell("AGENCIA"):Show()
					oSection3:Cell("CONTA"  ):Show()
					oSection3:Cell("BANCO"  ):SetBlock( { || Substr(cAnterior,1,3)  } )
					oSection3:Cell("AGENCIA"):SetBlock( { || Substr(cAnterior,4,5)  } )
					oSection3:Cell("CONTA"  ):SetBlock( { || Substr(cAnterior,9,10) } )
					oSection3:Cell("NATUREZA"):SetSize(28)
					oSection3:Cell("NATUREZA"):Hide()
				Elseif nOrdem == 3	//Natureza
					oSection2:Enable()
					oSection2:Cell("SALDOATUAL"):SetTitle("")
					oSection3:Cell("DATA"   ):Disable()
					oSection3:Cell("BANCO"  ):Disable()
					oSection3:Cell("AGENCIA"):Disable()
					oSection3:Cell("CONTA"  ):Disable()
					dbSelectArea("SED")
					dbSeek(xFilial("SED")+cAnterior)
					oSection3:Cell("NATUREZA"):SetSize(53)
					oSection3:Cell("NATUREZA"):Show()
					oSection3:Cell("NATUREZA"):SetBlock( { || AllTrim(cAnterior) + " - " + Substr(SED->ED_DESCRIC,1,30) } )
				EndIF

				oSection3:Cell("ENTRADA"):SetBlock  ( { || nTotEnt } )
				oSection3:Cell("ENTRADA"):SetPicture( Tm(nTotEnt,16,MsDecimais(mv_par09)) )
				oSection3:Cell("SAIDA"  ):SetBlock  ( { || nTotSai } )
				oSection3:Cell("SAIDA"  ):SetPicture( Tm(nTotSai,16,MsDecimais(mv_par09)) )

				If nOrdem != 3 .And. mv_par15 == 1
					oSection3:Cell("SALDOATUAL"):Show()
					oSection3:Cell("SALDOATUAL"):SetBlock( { || nSaldoAtual } )
					oSection3:Cell("SALDOATUAL"):SetPicture( Tm(nSaldoAtual,18,MsDecimais(mv_par09)) )
				Else
					oSection3:Cell("SALDOATUAL"):Disable()
				Endif

				oSection3:Init()
				oSection3:PrintLine()
				oSection3:Finish()

				nGerEnt 	 += nTotEnt
				nGerSai 	 += nTotSai
				nGerSaldo += (nSaldoAnt + nTotEnt - nTotSai)
				nSaldoAnt := 0
				nTotSaldo := 0
				nTotEnt   := 0
				nTotSai   := 0

			Endif
			dbSelectArea("SE5")
			If nOrdem == 2
				Exit
			EndIf
		EndDo
	Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do total geral.		                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nGerEnt+nGerSai) != 0
		oSection3:Cell("TXTTOTAL"):SetSize(18)
		oSection3:Cell("TXTTOTAL"):SetBlock ( { || "Total Geral : " } )	//"Total Geral : "
		oSection3:Cell("DATA"    ):Disable()
		oSection3:Cell("BANCO"   ):Hide()
		oSection3:Cell("AGENCIA" ):Hide()
		oSection3:Cell("CONTA"   ):Hide()
		If nOrdem == 3
			oSection3:Cell("NATUREZA"):SetSize(43)
		Else
			oSection3:Cell("NATUREZA"):SetSize(16)
		EndIf
		oSection3:Cell("NATUREZA"):Hide()
		oSection3:Cell("ENTRADA" ):SetBlock  ( { || nGerEnt } )
		oSection3:Cell("ENTRADA" ):SetPicture( Tm(nGerEnt,16,MsDecimais(mv_par09)) )
		oSection3:Cell("SAIDA"   ):SetBlock  ( { || nGerSai } )
		oSection3:Cell("SAIDA"   ):SetPicture( Tm(nGerSai,16,MsDecimais(mv_par09)) )
		oSection3:Cell("SALDOATUAL"):SetBlock( { || nGerSaldo } )
		oSection3:Cell("SALDOATUAL"):SetPicture( Tm(nGerSaldo,18,MsDecimais(mv_par09)) )
	EndIf

	oSection3:Init()
	oSection3:PrintLine()
	oSection3:Finish()

	If lVazio
		oReport:SkipLine()
		oReport:PrintText("***** " + "Nao existem lancamentos neste periodo" + " *****")	//"Nao existem lancamentos neste periodo"
	EndIf

	#IFDEF TOP
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	#ELSE
		dbSelectArea("SE5")
		dbClearFil()
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	#ENDIF

Return

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³ FINR620	³ Autor ³ Wagner Xavier 		³ Data ³ 05.10.92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ FINR620(void)											  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 												  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinR620R3T()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 										     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL wnrel
	LOCAL cDesc1 := "Este programa ir  emitir a rela‡„o da movimenta‡„o banc ria"
	LOCAL cDesc2 := "de acordo com os parametros definidos pelo usuario. Poder  ser"
	LOCAL cDesc3 := "impresso em ordem de data disponivel,banco,natureza ou dt.digita‡„o."
	LOCAL cString := "SE5"
	LOCAL aOrd := {OemToAnsi("Por Dt.Dispo"),OemToAnsi("Por Banco"),OemToAnsi("Por Natureza"),OemToAnsi("Dt.Digitacao"),OemToAnsi("Por Dt. Movimentacao")}  //"Por Dt.Dispo"###"Por Banco"###"Por Natureza"###"Dt.Digitacao"###"Por Dt. Movimentacao"
	Local cTamanho

	PRIVATE titulo
	PRIVATE cabec1	:= ""
	PRIVATE cabec2 := ""
	PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
	PRIVATE nomeprog:="FINR620"
	PRIVATE nLastKey := 0
	PRIVATE cPerg	 :="FIN620TAIF"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 						    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	pergunte("FIN620TAIF",.T.)

	mv_par11 := Iif(Empty(mv_par11),1,mv_par11)
	titulo := "Relacao da Movimentacao Bancaria" + If(mv_par11==1, " Analitico", " Sintetico") //" Analitico"###" Sintetico"
// Seta o tamanho do relatorio, G - Analitico e ordem <> 3 e M - Caso contrario.
	cTamanho :=	If(mv_par11==1 .And. aReturn[8] != 3,"G","M")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						 ³
//³ mv_par01				// da data							 ³
//³ mv_par02				// ate a data						 ³
//³ mv_par03				// do banco 						 ³
//³ mv_par04				// ate o banco 						 ³
//³ mv_par05				// da natureza 						 ³
//³ mv_par06				// ate a natureza 					 ³
//³ mv_par07				// da data de digitacao 			 ³
//³ mv_par08				// ate a data de digitacao 			 ³
//³ mv_par09				// qual moeda						 ³
//³ mv_par10				// tipo de historico 				 ³
//³ mv_par11				// Analitico / Sintetico			 ³
//³ mv_par12				// Considera filiais      			 ³
//³ mv_par13				// Filial De					 	 ³
//³ mv_par14				// Filial Ate			   			 ³
//³ mv_par15				// Imprime saldos		   			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := "FINR620(CUSTOM)"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,cTamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

// Muda titulo do relatorio conforme impressao (analitico ou sintetico).
	titulo := "Relacao da Movimentacao Bancaria" + If(mv_par11==1, " Analitico", " Sintetico")
// Seta o tamanho do relatorio, G - Analitico e ordem <> 3 e M - Caso contrario.
	cTamanho :=	If(mv_par11==1 .And. aReturn[8] != 3,"G","M")

	RptStatus({|lEnd| Fa620Imp(@lEnd,wnRel,cString,cTamanho)},Titulo)
Return

/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o	 ³ FA620Imp ³ Autor ³ Wagner Xavier 		³ Data ³ 05.10.92 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Relacao da Movimentacao Bancaria 						  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Sintaxe e ³ FA620Imp(lEnd,wnRel,Cstring)								  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ lEnd	  - A‡Æo do Codeblock								  ³±±
	±±³			 ³ wnRel   - T¡tulo do relat¢rio 							  ³±±
	±±³			 ³ cString - Mensagem										  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso		 ³ Generico 												  ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA620Imp(lEnd,wnRel,cString,cTamanho)

	LOCAL CbCont,CbTxt
	LOCAL nTotEnt := 0,nTotSai := 0,nGerEnt := 0,nGerSai := 0,nColuna := 0,lContinua := .T.
	LOCAL nValor,cDoc
	LOCAL lVazio  := .T.
	LOCAL nMoeda, cTexto
	#IFDEF TOP
		Local ni
		Local aStru 	:= SE5->(dbStruct())
		Local cIndice	:= SE5->(IndexKey())
	#ELSE
		LOCAL nOrdSE5 :=SE5->(IndexOrd())
		LOCAL cChave
	#ENDIF

	LOCAL cIndex
	LOCAL cHistor
	LOCAL cChaveSe5
	Local nTxMoeda:=0
	Local cFilterUser := aReturn[7]
	Local nMoedaBco	:=	1
	Local nCasas		:= GetMv("MV_CENT"+(IIF(mv_par09 > 1 , STR(mv_par09,1),"")))
	LOCAL bWhile   := { || IF( mv_par12 == 1, .T., SE5->E5_FILIAL == xFilial("SE5") ) }
	Local nTotSaldo := 0
	Local aSaldo
	Local nGerSaldo := 0
	Local nSaldoAtual := 0
	Local lFirst := .T.
	Local nTxMoedBc	:= 0
	Local cPict := ""
	Local nA	:= 0
	Local lF620Qry := ExistBlock("F620QRY")
	Local cQueryAdd := ""
	Local nSaldoAnt := 0
	Local lImpSaldo := .F.
	Local nAscan := 0
	Local cAnterior := ""
	Local nBancos := 0
	Local cCond2 := ""
	Local cCond3 := ""


	cIndex := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso so'exista uma empresa/filial ou o SE5 seja compartilhado³
//³ nao ha' necessidade de ser processado por filiais            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mv_par12 := Iif(SM0->(Reccount()) == 1 .or. Empty(xFilial("SE5")),2,mv_par12)
	aSaldo := GetSaldos( MV_PAR12 == 1, nMoeda, If(mv_par12==1,mv_par13,xFilial("SA6")), If(mv_par12==1,mv_par14,xFilial("SA6")), mv_par01, mv_par03, mv_par04, mv_par17, mv_par18, mv_par19, mv_par20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt 	:= SPACE(10)
	cbcont	:= 0
	li 		:= 80
	m_pag 	:= 1

	cMoeda := Str(mv_par09,1,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos							    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par11 == 1
		titulo := "Relacao da Movimentacao Bancaria em "
		If aReturn[8] != 3 .And. mv_par15 == 1 // Ordem de natureza nao sera impresso os saldos
			cabec1 := "DATA       BCO AGENCIA  CONTA      NATUREZA    DOCUMENTO                              VALOR                               HISTORICO"
			cabec2 := "                                                                           ENTRADA             SAIDA        SALDO ATUAL"
		Else
			cabec1 := "  DATA   BCO AGENCIA  CONTA    NATUREZA      DOCUMENTO                            VALOR             HISTORICO"
			cabec2 := "                                                                        ENTRADA             SAIDA            "
		Endif
	Else
		titulo := "Movimentação Bancária em "
		cabec1 := If(	mv_par15 == 1,  "                                                                  ENTRADA         SAIDA         SALDO ATUAL",;
			StrTran(StrTran(StrTran( "                                                                  ENTRADA         SAIDA         SALDO ATUAL","SALDO ATUAL",""),"SALDO ACTUAL",""),"CURR. BALN.","")) //"                                    ENTRADA             SAIDA        SALDO ATUAL"
	Endif


	nMoeda	:= mv_par09
	cTexto	:= GetMv("MV_MOEDA"+Str(nMoeda,1))
	Titulo	+= cTexto
	titulo   += " - " + If(mv_par11==1, "Analitico", "Sintetico") + " - " //" - "###"Analitico"###"Sintetico"###" - "
	dbSelectArea("SE5")

	#IFDEF TOP
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5")
		IF mv_par12 == 1
			cQuery += " WHERE E5_FILIAL BETWEEN '" + mv_par13 + "' AND '" + mv_par14 + "'"
		ELSE
			cQuery += " WHERE E5_FILIAL = '" + xFilial("SE5") + "'"
		ENDIF
		cQuery += " AND D_E_L_E_T_ <> '*' "
	#ENDIF

	If aReturn[8] == 1
		titulo += OemToAnsi(" por data")  //" por data"
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2 		:= "E5_DTDISPO"
			IF mv_par12 == 1
				cOrder		:= "E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
			ELSE
				cOrder		:= "E5_FILIAL+E5_DTDISPO+E5_BANCO+E5_AGENCIA+E5_CONTA"
			ENDIF
		#ELSE
			cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
			cCond2 := "E5_DTDISPO"
			dbSelectArea("SE5")
			dbSetOrder(nOrdSE5)
			cIndex	:= CriaTrab(nil,.f.)
			IF mv_par12 == 1
				cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_FILIAL"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
			ELSE
				cChave	:= "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,,;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
			ENDIF
			nIndex	 := RetIndex("SE5")
			dbSelectArea("SE5")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
			IF mv_par12 == 1
				dbSeek(DtoS(mv_par01),.T.)
			ELSE
				dbSeek(xFilial()+DtoS(mv_par01),.T.)
			ENDIF
		#ENDIF
	Elseif aReturn[8] == 2
		titulo += OemToAnsi(" por Banco")  //" por Banco"
		SE5->(dbSetOrder(3))
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
			cIndice := SE5->(IndexKey())
			IF mv_par12 == 1
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1)) + "+E5_FILIAL"
			ENDIF
			cOrder := cIndice
		#ELSE
			cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
			cCond2 := "E5_BANCO+E5_AGENCIA+E5_CONTA"
			IF mv_par12 == 1
				cIndex	:= CriaTrab(nil,.f.)
				cChave	:= SE5->(INDEXKEY())
				cChave   := ALLTRIM(SUBSTR(cChave, AT("+",cChave)+1)) + "+E5_FILIAL"
				IndRegua("SE5" ,;
					cIndex,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(DBSEEK(mv_par03,.T. ))
			ELSE
				SE5->(dbSetOrder(3))
				SE5->(dbSeek(xFilial("SE5")+mv_par03,.T.))
			ENDIF
		#ENDIF
	Elseif aReturn[8] == 3
		titulo += OemToAnsi(" por Natureza")  //" por Natureza"
		SE5->(dbSetOrder(4))
		#IFDEF TOP
			cCondicao 	:= ".T."
			cCond2		:= "E5_NATUREZ"
			cIndice := SE5->(IndexKey())
			IF mv_par12 == 1
				cIndice := ALLTRIM(SUBSTR(cIndice,AT("+",cIndice)+1))+"+E5_FILIAL"
			ENDIF
			cOrder := cIndice
		#ELSE
			cCondicao := "E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06"
			cCond2	  := "E5_NATUREZ"
			IF mv_par12 == 1
				cIndex := CriaTrab(NIL,.F.)
				cChave := SE5->(INDEXKEY())
				cChave := ALLTRIM(SUBSTR(cChave,AT("+",cChave)+1))+"+E5_FILIAL"
				IndRegua("SE5"  ,;
					cIndex ,;
					cChave,,;
					"E5_FILIAL >= '"+mv_par13+"' .AND. E5_FILIAL <= '"+mv_par14+"'",;
					OemToAnsi("Selecionando Registros..."))
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(DBSEEK(mv_par05,.T.))
			ELSE
				SE5->(dbSeek(xFilial("SE5")+mv_par05,.T.))
			ENDIF
		#ENDIF
	Elseif aReturn[8] == 4 // Digitacao
		IF mv_par12 == 1
			cOrder	 := "DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
		ELSE
			cOrder	 := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
		ENDIF
		cCond2	  := "E5_DTDIGIT"

		#IFDEF TOP
			cCondicao 	:= ".T."
		#ELSE
			cCondicao := "E5_DTDIGIT >= mv_par07 .and. E5_DTDIGIT <= mv_par08"
			titulo += OemToAnsi("  Por Data de Digitacao")  //"  Por Data de Digitacao"
			cIndex:=CriaTrab("",.F.)
			dbSelectArea("SE5")
			IF mv_par12 == 1
				IndRegua("SE5",;
					cIndex ,;
					cOrder,,;
					"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(DTOS(mv_par07),.T.))
			ELSE
				IndRegua("SE5",cIndex,cOrder,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex	 := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par07),.T.))
			ENDIF
		#ENDIF
	ElseIf aReturn[8] >= 5 // Data da Movimentacao
		If mv_par12 == 1
			cOrder := "DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_FILIAL"
		Else
			cOrder := "E5_FILIAL+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
		Endif
		cCond2 := "E5_DATA"

		#IFDEF TOP
			cCondicao 	:= ".T."
		#ELSE
			cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
			titulo    += OemToAnsi("Por Dt. Movimentacao") // "Por Dt. Movimentacao"
			cIndex    := CriaTrab("",.F.)
			dbSelectArea("SE5")
			If mv_par12 == 1
				IndRegua("SE5", cIndex, cOrder,,;
					"E5_FILIAL >= '" + mv_par13 + "' .AND. E5_FILIAL <= '" + mv_par14 + "'",;
					OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(DTOS(mv_par01),.T.))
			Else
				IndRegua("SE5",cIndex,cOrder,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
				nIndex := RetIndex("SE5")
				SE5->(dbSetIndex(cIndex+OrdBagExt()))
				SE5->(dbSetOrder(nIndex+1))
				SE5->(dbSeek(xFilial("SE5")+DTOS(mv_par01),.T.))
			Endif
		#ENDIF
	EndIF
	cFilterUser:=aReturn[7]

	#IFDEF TOP
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_NUMCHEQ <> '%*'"
		cQuery += " AND E5_VENCTO <= E5_DATA "
		cQuery += " AND E5_DTDISPO BETWEEN '" + DTOS(mv_par01)  + "' AND '" + DTOS(mv_par02)       + "'"
		cQuery += " AND E5_BANCO BETWEEN   '" + mv_par03        + "' AND '" + mv_par04       + "'"
		cQuery += " AND E5_AGENCIA BETWEEN   '" + Alltrim(mv_par17) + "' AND '" + Alltrim(mv_par18)       + "'"
		cQuery += " AND E5_CONTA BETWEEN   '" + Alltrim(mv_par19)   + "' AND '" + Alltrim(mv_par20)       + "'"
		cQuery += " AND E5_BANCO <> '   ' "
		cQuery += " AND E5_NATUREZ BETWEEN '" + mv_par05        + "' AND '" + mv_par06       + "'"
		cQuery += " AND E5_DTDIGIT BETWEEN '" + DTOS(mv_par07)        + "' AND '" + DTOS(mv_par08)       + "'"
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL') "
		If lF620Qry
			cQueryAdd := ExecBlock("F620QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND ( " + cQueryAdd + ")"
			EndIf
		EndIf
		cQuery += " ORDER BY " + SqlOrder(cOrder)

		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)

		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	#ENDIF

	Set Softseek Off
	SetRegua(RecCount())

	For nBancos := 1 To IIf(aReturn[8]==2,Len(aSaldo),1)

		nTotEnt:=0
		nTotSai:=0
		nTotSaldo := 0
		lImpSaldo := (lFirst .And. aReturn[8] != 3) // Indica se o saldo anterior deve ser impresso
		If aReturn[8] == 2
			nSaldoAtual := 0
		Endif
		nSaldoAnt := 0

		// Pesquisa o saldo bancario
		If (Empty(cFilterUser) .And. aReturn[8] == 2) .Or. aReturn[8] <> 2
			If mv_par15 == 1 .And. lImpSaldo
				nSaldoAnt := 0
				If aReturn[8] == 2 // Ordem de banco
					If (!Empty(aSaldo[nBancos][2]) .And. !Empty(aSaldo[nBancos][3]) .And. !Empty(aSaldo[nBancos][4]))
						cCond3:=aSaldo[nBancos][2]+aSaldo[nBancos][3]+aSaldo[nBancos][4]
					Else
						cCond3 := "EOF"
					EndIf
					nAscan := Ascan(aSaldo, {|e| e[2]+e[3]+e[4] == cCond3 } )
					If nAscan > 0
						nSaldoAnt := Round(xMoeda(aSaldo[nAscan][6],nMoedaBco,mv_par09,IIf(SE5->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
					Else
						nSaldoAnd := 0
					Endif
					lFirst := .T.
				Else
					// Na primeira vez, soma todos os saldos de todos os bancos
					If lFirst
						// Soma os saldos de todos os bancos
						For nA := 1 To Len(aSaldo)
							nSaldoAnt += Round(xMoeda(aSaldo[nA][6],MoedaBco(aSaldo[nA][2],aSaldo[nA][3],aSaldo[nA][4]),mv_par09,IIf(SE5->(EOF()),dDataBase,E5_DTDISPO),nCasas+1,nTxMoedBc),nCasas)
						Next
						lFirst := .F.
					Else
						// Apos a impressao da primeira linha, o saldo Anterior sera igual ao
						// saldo atual, impresso na ultima linha, antes da quebra de data
						If ( cPaisLoc == "BRA" )
							nSaldoAnt := nSaldoAtual
						Else
							nSaldoAnt := Round(xMoeda(nSaldoAtual,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
						Endif
					Endif
				Endif

				cPict := tm(nSaldoAnt,18,nCasas)

				IF li > 58
					cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
				Endif

				// Imprime o saldo anterior
				@li,000 PSAY "Saldo anterior a " + DTOC(mv_par01)+ ; //"Saldo anterior a "
				If( aReturn[8] == 2, " : " + aSaldo[nBancos][2]+" "+aSaldo[nBancos][3]+" "+aSaldo[nBancos][4]," (Todos os bancos): ")+; //" (Todos os bancos): "
					Transform(nSaldoAnt,cPict)
					li++
					li++
					nSaldoAtual := nSaldoAnt
				Endif
			EndIf

			While !Eof() .And. EVAL(bWhile) .And. &cCondicao .and. lContinua

				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
					lContinua:=.F.
					Exit
				End

				#IFNDEF TOP
					If !Fr620Skip1()
						dbSkip()
						Loop
					EndIf
				#ENDIF

				IncRegua()

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Considera filtro do usuario                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(cFilterUser).and.!(&cFilterUser)
					dbSkip()
					Loop
				Endif

				IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
					dbSkip()
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Na transferencia somente considera nestes numerarios 		  ³
				//³ No Fina100 ‚ tratado desta forma.                    		  ³
				//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
				//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
				//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
				//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
				//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
					If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
						dbSkip()
						Loop
					Endif
				Endif

				If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
						.or. Substr(E5_DOCUMEN,1,1) == "*" )
					dbSkip()
					Loop
				Endif

				If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		//Sangria
					dbSkip()
					Loop
				Endif

				cAnterior:=&cCond2
				nTotEnt:=0
				nTotSai:=0
				nTotSaldo := 0
				If !Empty(cFilterUser)  .and. aReturn[8] == 2
					lImpSaldo := (lFirst .And. aReturn[8] != 3) // Indica se o saldo anterior deve ser impresso
					nSaldoAtual := 0
					nSaldoAnt := 0
				EndIf


				If aReturn[8] == 2
					cCond3:="E5_BANCO=='"+aSaldo[nBancos][2]+"' .And. E5_AGENCIA=='"+aSaldo[nBancos][3]+"' .And. E5_CONTA=='"+aSaldo[nBancos][4]+"'"
				Else
					cCond3:=".T."
				Endif

				While !EOF() .and. &cCond2 = cAnterior .and. EVAL(bWhile) .and. lContinua .And. &cCond3

					IF lEnd
						@PROW()+1,001 PSAY OemToAnsi("CANCELADO PELO OPERADOR")  //"CANCELADO PELO OPERADOR"
						lContinua:=.F.
						Exit
					EndIF

					IF Empty(E5_BANCO)
						dbSkip()
						Loop
					Endif

					IncRegua()

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Considera filtro do usuario                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cFilterUser).and.!(&cFilterUser)
						dbSkip()
						Loop
					Endif

					IF E5_SITUACA == "C"
						dbSkip()
						Loop
					EndIF

					IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
						dbSkip()
						Loop
					EndIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Na transferencia somente considera nestes numerarios 		  ³
					//³ No Fina100 ‚ tratado desta forma.                    		  ³
					//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
					//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
					//³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
					//³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
					//³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
						If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
							dbSkip()
							Loop
						Endif
					Endif

					If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
							.or. Substr(E5_DOCUMEN,1,1) == "*" )
						dbSkip()
						Loop
					Endif


					If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
						dbSkip()
						Loop
					Endif

					IF E5_VENCTO > E5_DATA
						dbSkip()
						Loop
					EndIF

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se esta' FORA dos parametros                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					IF (E5_DTDISPO < mv_par01) .or. (E5_DTDISPO > mv_par02)
						dbSkip()
						Loop
					Endif

					IF (E5_BANCO	< mv_par03) .or. (E5_BANCO  > mv_par04)
						dbSkip()
						Loop
					EndIf

					IF (E5_NATUREZ < mv_par05) .or. (E5_NATUREZ > mv_par06)
						dbSkip()
						Loop
					EndIF

					IF (E5_DTDIGIT < mv_par07) .or. (E5_DTDIGIT > mv_par08)
						dbSkip()
						Loop
					EndIF

					IF E5_TIPODOC $ "DCüJRüMTüBAüMTüCMüD2/J2/M2/C2/V2/CX/CP/TL"
						dbSkip()
						Loop
					Endif

					//  Para o Sigaloja, quando for sangria e nao for R$, nÆo listar nos
					// movimentos bancarios

					If (E5_TIPODOC == "SG") .And. (!E5_MOEDA $ "R$"+IIf(cPaisLoc=="BRA","","/$ ")) //Sangria com moeda <> R$
						dbSkip()
						Loop
					EndIf

					dbSelectArea("SE5")

					If SubStr(E5_NUMCHEQ,1,1)=="*"      //cheque para juntar (PA)
						dbSkip()
						Loop
					Endif

					If !Empty( E5_MOTBX )
						If !MovBcoBx(E5_MOTBX)
							dbSkip()
							Loop
						Endif
					Endif

					IF li > 58
						cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
					Endif

					If cPaisLoc	# "BRA"
						SA6->(DbSetOrder(1))
						SA6->(DbSeek(xFilial()+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If SE5->(FieldPos('E5_TXMOEDA')) > 0
							nTxMoedBc := SE5->E5_TXMOEDA
						Else
							nTxMoedBc := 0
						Endif
						If mv_par09 > 1 .and. !Empty(E5_VLMOED2)
							nTxMoeda := RecMoeda(E5_DTDISPO,mv_par09)
							nTxMoeda :=if(nTxMoeda=0,1,nTxMoeda)
							nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,,nCasas+1,nTxMoedBc,nTxMoeda),nCasas)
						Else
							nValor := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
						Endif
					Else
						nValor := xMoeda(E5_VALOR,1,mv_par09,E5_DATA)
					Endif

					lVazio := .F.

					// Pesquisa o saldo bancario
					If  !Empty(cFilterUser)  .And. lImpSaldo .And. mv_par15 == 1  .and. aReturn[8] == 2
						nSaldoAnt := 0
						If aReturn[8] == 2 // Ordem de banco
							nAscan := Ascan(aSaldo, {|e| e[2]+e[3]+e[4] == E5_BANCO+E5_AGENCIA+E5_CONTA } )
							If nAscan > 0
								If ( cPaisLoc == "BRA" )
									nSaldoAnt := aSaldo[nAscan][6]
								Else
									nSaldoAnt := Round(xMoeda(aSaldo[nAscan][6],nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
								Endif
							Endif
						Else
							// Na primeira vez, soma todos os saldos de todos os bancos
							If lFirst
								// Soma os saldos de todos os bancos
								For nA := 1 To Len(aSaldo)
									If ( cPaisLoc <> "BRA" )
										nSaldoAnt += Round(xMoeda(aSaldo[nA][6],MoedaBco(aSaldo[nA][2],aSaldo[nA][3],aSaldo[nA][4]),mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
									Else
										nSaldoAnt += aSaldo[nA][6]
									Endif
								Next
								lFirst := .F.
							Else
								// Apos a impressao da primeira linha, o saldo Anterior sera igual ao
								// saldo atual, impresso na ultima linha, antes da quebra de data
								If ( cPaisLoc == "BRA" )
									nSaldoAnt := nSaldoAtual
								Else
									nSaldoAnt := Round(xMoeda(nSaldoAtual,nMoedaBco,mv_par09,E5_DTDISPO,nCasas+1,nTxMoedBc),nCasas)
								Endif
							Endif
						Endif
						If ( cPaisLoc == "BRA" )
							cPict := "@E 999,999,999.99"
						Else
							cPict := PesqPict( "SE5", "E5_VALOR", 18, mv_par09 )
						Endif
						// Imprime o saldo anterior
						@li,000 PSAY "Saldo anterior a " + DTOC(mv_par01)+ ; //"Saldo anterior a "
						If( aReturn[8] == 2, " : " + Substr(cAnterior,1,3)+" "+Substr(cAnterior,4,5)+" "+Substr(cAnterior,9,10)," (Todos os bancos): ")+; //" (Todos os bancos): "
							Transform(nSaldoAnt,cPict)
							li++
							li++
							lImpSaldo := .F.
							nSaldoAtual := nSaldoAnt
						Endif
						// Calcula saldo atual
						nSaldoAtual := If(E5_RECPAG = "R",nSaldoAtual+nValor,nSaldoAtual-nValor)

						If mv_par11 == 1
							@li,000 PSAY If( aReturn[8]!=5, E5_DTDISPO, E5_DATA )
							@li,011 PSAY E5_BANCO
							@li,015 PSAY E5_AGENCIA
							@li,024 PSAY E5_CONTA
							@li,035 PSAY E5_NATUREZ
							cDoc := E5_NUMCHEQ
							If Empty( cDoc )
								cDoc := E5_DOCUMEN
							Endif

							IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 14
								cDoc := Alltrim(E5_DOCUMEN) + if(!empty(E5_DOCUMEN).and. !empty(E5_NUMCHEQ),"-","") + Alltrim(E5_NUMCHEQ )
							Endif

							If Empty(cDoc)
								cDoc := Alltrim(E5_PREFIXO)+if(!empty(E5_PREFIXO),"-","")+;
									Alltrim(E5_NUMERO )+if(!empty(E5_PARCELA),"-"+E5_PARCELA,"")
							Endif

							If Substr( cDoc,1,1 ) == "*"
								dbSkip()
								Loop
							Endif
							// ajusta otamanho do documento para nao desposicionar o relatorio
							cDoc := If(Len(cDoc)==0,Space(1),cDoc)
							@li,47 PSAY cDoc
							nColuna := IIF(E5_RECPAG = "R" ,67, 85)

							@li,nColuna	PSAY nValor PicTure tm(nValor,16,MsDecimais(mv_par09))
							If aReturn[8] != 3 .And. mv_par15 == 1
								@li,102		PSAY nSaldoAtual PicTure tm(nSaldoAtual,18,MsDecimais(mv_par09))
							Endif
						Endif

						IF E5_RECPAG = "R"
							nTotEnt += nValor
						Else
							nTotSai += nValor
						Endif
						nTotSaldo += nSaldoAtual
						If mv_par11 == 1
							nColuna := If(aReturn[8] != 3 .And. mv_par15 == 1, 122, 105)
							If mv_par10 == 1	// Imprime normalmente
								@li,nColuna PSAY SUBSTR(E5_HISTOR,1,25)
							Else					// Busca historico do titulo
								If E5_RECPAG == "R"
									cHistor		:= E5_HISTOR
									cChaveSe5	:= xFilial("SE1") + E5_PREFIXO + ;
										E5_NUMERO + E5_PARCELA + ;
										E5_TIPO
									dbSelectArea("SE1")
									DbSetOrder(1)
									dbSeek( cChaveSe5 )
									@li,nColuna PSAY Left( iif( Empty(SE1->E1_HIST), cHistor, SE1->E1_HIST) , 25 )
								Else
									cHistor		:= E5_HISTOR
									cChaveSe5	:= xFilial("SE2") + E5_PREFIXO + ;
										E5_NUMERO + E5_PARCELA + ;
										E5_TIPO	 + E5_CLIFOR
									dbSelectArea("SE2")
									DbSetOrder(1)
									dbSeek( cChaveSe5 )
									@li,nColuna PSAY Left( iif( Empty(SE2->E2_HIST), cHistor, SE2->E2_HIST) , 25 )
								Endif
							Endif
							li++
						Endif
						dbSelectArea("SE5")
						dbSkip()
					Enddo

					If ( nTotEnt + nTotSai ) != 0
						li++
						IF aReturn[8] == 1 .or. aReturn[8] == 4 .or. aReturn[8] == 5
							@li, 0 PSAY "Total : " + DTOC(cAnterior) //"Total : "
						Elseif aReturn[8] == 2
							// Banco+Agencia+Conta
							@li, 0 PSAY "Total : " + Substr(cAnterior,1,3)+" "+Substr(cAnterior,4,5)+" "+Substr(cAnterior,9,10) //"Total : "
						Elseif aReturn[8] == 3
							dbSelectArea("SED")
							dbSeek(cFilial+cAnterior)
							@li, 0 PSAY "Total : " + cAnterior + " "+Substr(ED_DESCRIC,1,30) //"Total : "
						EndIF
						If mv_par11 != 1 // Sintetico
							@li, 55 PSAY nTotEnt	  PicTure tm(nTotEnt,16,MsDecimais(mv_par09))
							@li, 73 PSAY nTotSai	  PicTure tm(nTotSai,16,MsDecimais(mv_par09))
						Else
							@li, 67 PSAY nTotEnt	  PicTure tm(nTotEnt,16,MsDecimais(mv_par09))
							@li, 85 PSAY nTotSai	  PicTure tm(nTotSai,16,MsDecimais(mv_par09))
						Endif

						If aReturn[8] != 3 .And. mv_par15 == 1
							@li,If(mv_par11==1,102,89) PSAY nSaldoAtual PicTure tm(nTotSaldo,18,MsDecimais(mv_par09))
						Endif
						nGerEnt += nTotEnt
						nGerSai += nTotSai
						nGerSaldo += (nSaldoAnt + nTotEnt - nTotSai)
						nSaldoAnt := 0
						nTotSaldo := 0
						nTotEnt := 0
						nTotSai := 0
						li+=2
					Endif
					dbSelectArea("SE5")
					If aReturn[8]==2
						Exit
					EndIf
				EndDo
			Next

			IF (nGerEnt+nGerSai) != 0
				IF li+2 > 58
					cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
				Endif
				li++
				@li,	0 PSAY OemToAnsi("Total Geral : ")  //"Total Geral : "
				If mv_par11 != 1 // Sintetico
					@li, 55 PSAY nGerEnt 	PicTure tm(nGerEnt,16,MsDecimais(mv_par09))
					@li, 73 PSAY nGerSai 	PicTure tm(nGerSai,16,MsDecimais(mv_par09))
				Else
					@li, 67 PSAY nGerEnt 	PicTure tm(nGerEnt,16,MsDecimais(mv_par09))
					@li, 85 PSAY nGerSai 	PicTure tm(nGerSai,16,MsDecimais(mv_par09))
				Endif
				If aReturn[8] != 3 .And. mv_par15 == 1
					@li,If(mv_par11==1,102,89) PSAY nGerSaldo PicTure tm(nTotSaldo,18,MsDecimais(mv_par09))
				Endif
				li++
				roda(cbcont,cbtxt,cTamanho)
			End

			If lVazio
				IF li > 58
					cabec(@titulo,cabec1,cabec2,nomeprog,cTamanho,IIF(aReturn[4]==1,15,18))
				End
				@li, 0 PSAY OemToAnsi("Nao existem lancamentos neste periodo")  //"Nao existem lancamentos neste periodo"
				li++
				roda(cbcont,cbtxt,cTamanho)
			End


			Set Device To Screen

			#IFDEF TOP
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			#ELSE
				dbSelectArea("SE5")
				dbClearFil()
				RetIndex( "SE5" )
				If !Empty(cIndex)
					FErase (cIndex+OrdBagExt())
				Endif
				dbSetOrder(1)
			#ENDIF


			If aReturn[5] = 1
				Set Printer to
				dbCommit()
				OurSpool(wnrel)
			End
			MS_FLUSH()
Return

/*/
			ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
			±±³Fun‡„o	 ³Fr620Skip1³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 13.10.99 ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³ Uso		 ³ FINR620.PRX																  ³±±
			±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
			±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
			ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#IFNDEF TOP

	Static Function Fr620Skip1()

		Local lRet := .T.

		If Empty(E5_BANCO)
			lRet := .F.
		ElseIf E5_SITUACA == "C"
			lRet := .F.
		ElseIf E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
			lRet := .F.
		ElseIf E5_VENCTO > E5_DATA
			lRet := .F.
		Endif

	Return lRet

#ENDIF


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetSaldos ºAutor  ³Claudio D. de Souza º Data ³  30/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter os saldos dos bancos do SA6                          º±±
±±º          ³ Parametros:                                                º±±
±±º          ³ lConsFil    -> Considera filiais                           º±±
±±º          ³ nMoeda      -> Codigo da moeda                             º±±
±±º          ³ Retorno:                                                   º±±
±±º          ³ aRet[n] = .F.,Banco,Agencia,Conta,Nome,Saldo               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracao ³ Inclusos novos parametros de Agencia e Conta               º±±
±±ºData      ³ 22/03/2010                                                 º±±
±±ºResponsav.³ Carlos Alday Torres                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR140                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSaldos( lConsFil, nMoeda, cFilDe, cFilAte, dDataSaldo, cBancoDe, cBancoAte, cAgenciaDe, cAgenciaAte, cContaDe, cContaAte )
	Local aRet     := {},;
		aArea    := GetArea(),;
		aAreaSa6 := Sa6->(GetArea()),;
		aAreaSe8 := Se8->(GetArea()),;
		cTrbBanco                   ,;
		cTrbAgencia                 ,;
		cTrbConta                   ,;
		cTrbNome                    ,;
		nTrbSaldo                   ,;
		cIndSE8  := ""					 ,;
		cSavFil  := cFilAnt			 ,;
		aAreaSm0 :=	SM0->(GetArea()),;
		nAscan

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lConsFil
		cFilDe  := cFilAnt
		cFilAte := cFilAnt
	Endif

	dbSelectArea("SM0")
	dbSeek(cEmpAnt+cFilDe,.T.)

	While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte
		cFilAnt := SM0->M0_CODFIL

		DbSelectArea("SA6")
		MsSeek( xFilial("SA6") )

		While SA6->(!Eof()) .And. A6_FILIAL == xFilial("SA6")
			//If !(SA6->A6_COD >= cBancoDe .And. SA6->A6_COD <= cBancoAte) .AND. !(SA6->A6_AGENCIA >= cAgenciaDe .And. SA6->A6_AGENCIA <= cAgenciaAte) .AND. !(SA6->A6_NUMCON >= cContaDe .And. SA6->A6_NUMCON <= cContaAte)
			If !((SA6->A6_COD >= cBancoDe .And. SA6->A6_COD <= cBancoAte) .AND. (SA6->A6_AGENCIA >= cAgenciaDe .And. SA6->A6_AGENCIA <= cAgenciaAte) .AND. (SA6->A6_NUMCON >= cContaDe .And. SA6->A6_NUMCON <= cContaAte))
				SA6->(DBSkip())
				Loop
			EndIf
			If SA6->A6_FLUXCAI $ "S "
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica banco a banco a disponibilidade imediata    		  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SE8")
				cTrbBanco  := SA6->A6_COD
				cTrbAgencia:= SA6->A6_AGENCIA
				cTrbConta  := SA6->A6_NUMCON
				cTrbNome   := SA6->A6_NREDUZ
				Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,0,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par09)})
				// Pesquiso o saldo na data anterior a data solicitada
				If MsSeek(xFilial("SE8")+SA6->(A6_COD+A6_AGENCIA+A6_NUMCON), .T.)
					While !EOF() 										.And.;
							SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	;
							SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
							xFilial("SE8") == SE8->E8_FILIAL
						dbSkip()
					End
					DbSkip(-1)
					While !Bof() 										.And.;
							SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) ==	;
							SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
							xFilial("SE8") == SE8->E8_FILIAL		.And.;
							SE8->E8_DTSALAT >= dDataSaldo
						dbSkip( -1 )
					End
				EndIf
				While !Eof()										.And.;
						SA6->(A6_COD+A6_AGENCIA+A6_NUMCON) == ;
						SE8->(E8_BANCO+E8_AGENCIA+E8_CONTA)	.And.;
						xFilial("SE8") == SE8->E8_FILIAL		.And.;
						SE8->E8_DTSALAT < dDataSaldo
					nTrbSaldo := xMoeda(SE8->E8_SALATUA,1,nMoeda)
					// Pesquisa banco+agencia+conta, para nao exibir saldos duplicados.
					nAscan := Ascan(aRet, {|e| e[2]+e[3]+e[4] == cTrbBanco+cTrbAgencia+cTrbConta})
					If nAscan > 0
						aRet[nAscan][6] := aRet[nAscan][6] + nTrbSaldo
					Else
						Aadd(aRet,{.F.,cTrbBanco,cTrbAgencia,cTrbConta,cTrbNome,nTrbSaldo,nMoeda, xMoeda(SA6->A6_LIMCRED,If(cPaisLoc=="BRA",1,Max(SA6->A6_MOEDA,1)),mv_par09)})
					Endif
					DbSkip()
				EndDo
			Endif
			dbSelectArea("SA6")
			dbSkip()
		End
		If Empty(xFilial("SA6")) .And.;
				Empty(xFilial("SE8"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
	EndDo

	cFilAnt := cSavFil
	SM0->(RestArea(aAreaSM0))

	If ( !Empty(cIndSE8) )
		dbSelectArea("SE8")
		RetIndex("SE8")
		dbClearFilter()
		Ferase(cIndSE8+OrdBagExt())
	EndIf

	Sa6->(RestArea(aAreaSa6))
	Se8->(RestArea(aAreaSe8))
	RestArea(aArea)

Return aRet
