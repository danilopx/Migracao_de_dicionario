#INCLUDE "PROTHEUS.CH"
User Function REST910()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1    := "Este programa emitir  uma rela‡„o com as movimenta‡”es"
LOCAL cDesc2    := "dos produtos Selecionados,Ordenados por Dia."
LOCAL cDesc3    := ""
LOCAL titulo    := OemToAnsi("Kardex Fisico-Financeiro (DIA)")
LOCAL wnrel     := "REST910"
LOCAL Tamanho   := "G"
LOCAL cString   := "SB1"
LOCAL lRet		:= .T.
LOCAL nTamSX1   := Len(SX1->X1_GRUPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL aArea1	:= Getarea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lVEIC   := UPPER(GETMV("MV_VEICULO"))=="S"
PRIVATE aSB1Cod := {}
PRIVATE aSB1Ite := {}
PRIVATE nCOL1	:= 0

PRIVATE aOrd    := {"Codigo Produto", "Tipo do Produto"}
PRIVATE aReturn := {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   := "MTR910"
PRIVATE bBloco  := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
PRIVATE aDriver := ReadDriver()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lCusUnif := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta perguntas no SX1 a fim de preparar o relatorio p/     ³
//³ custo unificado por empresa                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusUnif
	MTR910CUnf(lCusUnif)
EndIf
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta perguntas no SX1 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Remove grupo de perguntas incluido                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR("MTR910",nTamSX1)+"22")
	RecLock("SX1",.F.)
	dbDelete()
	MsUnlock()
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSB1Cod	:= TAMSX3("B1_COD")
aSB1Ite	:= TAMSX3("B1_CODITE")

If lVEIC

	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(PADR(cPerg,nTamSX1))
	Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
				(SX1->X1_TAMANHO <> aSB1Ite[1] .Or. Upper(SX1->X1_F3) <> "VR4")

			RecLock("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Ite[1]
			SX1->X1_F3 := "VR4"
			dbCommit()
			msUnLock()

		EndIf
		dbSkip()
	EndDo
	dbCommitAll()
	RestArea(aArea1)
Else
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(PADR(cPerg,nTamSX1))
	Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. ;
				(SX1->X1_TAMANHO <> aSB1Cod[1] .Or. Upper(SX1->X1_F3) <> "SB1")

			RecLock("SX1",.F.)
			SX1->X1_TAMANHO := aSB1Cod[1]
			SX1->X1_F3 := "SB1"
			dbCommit()
			msUnLock()

		EndIf
		dbSkip()
	EndDo
	dbCommitAll()
	RestArea(aArea1)
EndIf

Pergunte("MTR910",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        // Do produto                                ³
//³ mv_par02        // Ate o produto                             ³
//³ mv_par03        // Do tipo                                   ³
//³ mv_par04        // Ate o tipo                                ³
//³ mv_par05        // Da data                                   ³
//³ mv_par06        // Ate a data                                ³
//³ mv_par07        // Lista produtos s/movim                    ³
//³ mv_par08        // Qual Local (almoxarifado)                 ³
//³ mv_par09        // (D)ocumento/(S)equencia                   ³
//³ mv_par10        // Saldo a considerar : Atual / Fechamento   ³
//³ mv_par11        // Moeda Selecionada (1 a 5)                 ³
//³ mv_par12        // Pagina Inicial                            ³
//³ mv_par13        // Qtd de Paginas                            ³
//³ mv_par14        // Nr do Livro                               ³
//³ mv_par15        // Livro/Livro+termos/Termos                 ³
//³ mv_par16        // Seq.de Digitacao /Calculo                 ³
//³ mv_par17        // Lista Transf Locali (Sim/Nao)             ³
//³ mv_par18        // Do Grupo                                  ³
//³ mv_par19        // Ate o Grupo                               ³
//³ mv_par20        // Prods com Saldo Zero - (Lista/Nao Lista)  ³
//³ mv_par21        // Prods com Saldo Neg. - (Lista/Nao Lista)  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	lRet := .F.
EndIf

If lRet

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbClearFilter()
		lRet := .F.
	EndIf
    
	If lRet
		RptStatus({|lEnd| R910Imp(@lEnd,wnRel,tamanho,titulo)},titulo)
	EndIf

EndIf		

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R910IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 16.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R910Imp(ExpL1,ExpC1,ExpC2,ExpC3)		                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = var. p/ controle de interrupcao pelo usuario 	  ³±±
±±³          ³ ExpC1 = codigo do relatorio                                ³±±
±±³          ³ ExpC2 = codigo ref. ao tamanho do relatorio (P/M/G)        ³±±
±±³          ³ ExpC3 = titulo do relatorio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R910Imp(lEnd,WnRel,tamanho,titulo)
Static lIxbConTes   := NIL
LOCAL aDadosTran:={},lContinua := .F.
LOCAL nTipo     := 0
LOCAL nTam      :=18
LOCAL cProdAnt  := ""
LOCAL cLocalAnt := ""
LOCAL nCusMed   := 0
LOCAL lFirst1   := .T.
LOCAL aSalAtu   := { 0,0,0,0,0,0,0 }
Local aSalAlmox := {}
LOCAL nEntrada  := 0, nSaida  :=0
LOCAL nCEntrada := 0, nCSaida :=0
LOCAL nGEntrada := 0, nGSaida :=0
LOCAL nRec1,nRec2,nRec3,nSavRec,dCntData
LOCAL cPicB2Qt  := PesqPictQt("B2_QATU" ,18)
LOCAL cPicB2Qt2 := PesqPictQt("B2_QTSEGUM" ,18)
LOCAL cPicD1Qt  := PesqPict("SD1","D1_QUANT" ,18)
LOCAL cPicD2Qt  := PesqPict("SD2","D2_QUANT" ,18)
LOCAL cPicD3Qt  := PesqPict("SD3","D3_QUANT" ,18)
LOCAL cPicB2Cust:= PesqPict("SB2","B2_CM"+Str(mv_par11,1),18)
LOCAL cPicD1Cust:= PesqPict("SD1","D1_CUSTO"+IIF(mv_par11 == 1 ,"",Str(mv_par11,1)),18)
LOCAL cPicD2Cust:= PesqPict("SD2","D2_CUSTO"+Str(mv_par11,1),18)
LOCAL cPicD3Cust:= PesqPict("SD3","D3_CUSTO"+Str(mv_par11,1),18)
LOCAL lDev  // Flag que indica se nota ‚ devolu‡ao (.T.) ou nao (.F.)
LOCAL cCusto, lImpLivro, lImpTermos, cCond1, cCond2
LOCAL nAcho,i,aGrupos:={},cAlias
LOCAL cTRBSD1	:= CriaTrab(,.f.)
LOCAL cTRBSD2	:= Subs(cTrbSD1,1,7)+"A"
LOCAL cTRBSD3	:= Subs(cTrbSD1,1,7)+"B"
LOCAL nInd,cIndice	:="",cCampo1,cCampo2,cCampo3,cCampo4
LOCAL cNumSeqTr := "" , nRegTr := 0
LOCAL cSeqIni 	:= Replicate("z",6)
LOCAL nTotRegs  := 0
// Indica se esta listando relatorio do almox. de processo
LOCAL lLocProc:= mv_par08 == GetMv("MV_LOCPROC")
// Indica se deve imprimir movimento invertido (almox. de processo)
LOCAL lInverteMov :=.F.

LOCAL lPriApropri :=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe ponto de entrada                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lTesNEst := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo do produto importado - NAO DEVE SER LISTADO           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cProdImp := GETMV("MV_PRODIMP")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cArq1 := ""
LOCAL nInd1 := 0

LOCAL cAliasTop:="KARDEXSQL"

LOCAL nRecTrf1 := 0
LOCAL nRecTrf2 := 0
LOCAL aRecTRF  := {}

LOCAL cQueryB1A:= "" 
LOCAL cQueryB1B:= "" 
LOCAL cQueryB1C:= "" 
LOCAL cQueryB1D:= "" 

LOCAL cProdMNT := GetMv("MV_PRODMNT")
LOCAL cProdTER := GetMv("MV_PRODTER")

cProdMNT := cProdMNT + Space(15-Len(cProdMNT))
cProdTER := cProdTER + Space(15-Len(cProdTER))

If	!lVEIC
	cQueryB1A:= " AND SB1.B1_COD >= '"+mv_par01+"' AND SB1.B1_COD <= '"+mv_par02+"'"
	cQueryB1B:= " AND SB1.B1_COD = SB1EXS.B1_COD"
	cQueryB1C:= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
	cQueryB1D:= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_COD >= '"+mv_par01+"' AND SB1EXS.B1_COD <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
Else
	cQueryB1A:= " AND SB1.B1_CODITE >= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+"'"
	cQueryB1B:= " AND SB1.B1_COD = SB1EXS.B1_COD"
	cQueryB1C:= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
	cQueryB1D:= " SB1EXS.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1EXS.B1_CODITE >= '"+mv_par01+"' AND SB1EXS.B1_CODITE <= '"+mv_par02+"' AND SB1EXS.B1_TIPO >= '"+mv_par03+"' AND SB1EXS.B1_TIPO <= '"+mv_par04+"' AND"
EndIf	

cQueryB1C      += " SB1.B1_GRUPO >= '"+mv_par18+"' AND SB1.B1_GRUPO <= '"+mv_par19+"' AND SB1.B1_COD <> '"+cProdimp+"' AND "
cQueryB1C      += " SB1.D_E_L_E_T_=' '"
cQueryB1D      += " SB1EXS.B1_GRUPO >= '"+mv_par18+"' AND SB1EXS.B1_GRUPO <= '"+mv_par19+"' AND SB1EXS.B1_COD <> '"+cProdimp+"' AND "
cQueryB1D      += " SB1EXS.D_E_L_E_T_=' '"

lIxbConTes := IF(lIxbConTes == NIL,ExistBlock("MTAAVLTES"),lIxbConTes)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por empresa              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lCusUnif:=lCusUnif .And. mv_par08 == "**"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cbtxt := SPACE(10)
PRIVATE cbcont:= 0
PRIVATE li    := 80
PRIVATE m_pag := mv_par12

PRIVATE cabec1  := "    OPERACAO      "+IIF(mv_par09 $ "Dd", "   DOCUMENTO   ","   SEQUENCIA   ") +iif(cPaisLoc<>"CHI"," |               E  N  T  R  A  D  A  S             |         CUSTO MEDIO   |                  S  A  I  D  A  S                |                   S   A   L   D   O             |P.V.,FOR,","")
PRIVATE cabec2  := IIF(cPaisLoc == "CHI","","")
titulo  := "KARDEX FISICO-FINANCEIRO (DIA) L O C A L : TODOS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("NewHead")#"U"
	NewHead += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par11))))+")"
Else
	Titulo  += " (Por "+AllTrim(aOrd[aReturn[8]])+" ,em "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par11))))+")"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona seq de impressao escolhida ao titulo do relatorio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo  +=IIf(mv_par16==1,OemToAnsi("(SEQUENCIA)"),OemToAnsi("(CALCULO)"))

dbSelectArea("SB2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termo / Livro                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case mv_par15==1 ; lImpLivro:=.t. ; lImpTermos:=.f.
	Case mv_par15==2 ; lImpLivro:=.t. ; lImpTermos:=.t.
	Case mv_par15==3 ; lImpLivro:=.f. ; lImpTermos:=.t.
EndCase

#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		If lImpLivro

			dbSelectArea("SD1")           // Itens de Entrada
			nTotRegs += LastRec()
	
			dbSelectArea("SD2")           // Itens de Saida
			nTotRegs += LastRec()

			dbSelectArea("SD3")           // movimentacoes internas (producao/requisicao/devolucao)
			nTotRegs += LastRec()

			dbSelectArea("SB2")			  // Saldos em estoque
			dbSetOrder(1)
			nTotRegs += LastRec()

			//                            1,                 2,               3,        4,           5,          6,            7,                 8,              9,        10,      11,                 12,              13,            14,                 15,                 16,              17,   18,   19                    20,          21,       22,            23,      24
			// cQueryD1:= "SELECT 'SD1' ARQ,SB1.B1_COD PRODUTO,SB1.B1_TIPO TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,SB1.B1_POSIPI,D1_SEQCALC SEQCALC,D1_DTDIGIT DATA,D1_TES TES,D1_CF CF,D1_NUMSEQ SEQUENCIA,D1_DOC DOCUMENTO,D1_SERIE SERIE,D1_QUANT QUANTIDADE,D1_QTSEGUM QUANT2UM,D1_LOCAL ARMAZEM,'' PROJETO,'' OP,'' CC,D1_FORNECE FORNECEDOR,D1_LOJA LOJA,'' PEDIDO,D1_TIPO TIPONF,D1_CUSTO"

			cQuerySub:= "SELECT 1 "

			cQueryD1P := "SELECT 'SD1' ARQ"				// 01
			cQueryD1P += ", SB1.B1_COD PRODUTO"			// 02
			cQueryD1P += ", SB1.B1_TIPO TIPO"			// 03
			cQueryD1P += ", SB1.B1_UM"					// 04
			cQueryD1P += ", SB1.B1_GRUPO"				// 05
			cQueryD1P += ", SB1.B1_DESC"				// 06
			cQueryD1P += ", SB1.B1_POSIPI"				// 07
			cQueryD1P += ", D1_SEQCALC SEQCALC"			// 08
			cQueryD1P += ", D1_DTDIGIT DATA"			// 09
			cQueryD1P += ", D1_TES TES"					// 10
			cQueryD1P += ", D1_CF CF"					// 11
			cQueryD1P += ", D1_NUMSEQ SEQUENCIA"		// 12
			cQueryD1P += ", D1_DOC DOCUMENTO"			// 13
			cQueryD1P += ", D1_SERIE SERIE"				// 14
			cQueryD1P += ", D1_QUANT QUANTIDADE"		// 15
			cQueryD1P += ", D1_QTSEGUM QUANT2UM"		// 16
			cQueryD1P += ", D1_LOCAL ARMAZEM"			// 17
			cQueryD1P += ", '' PROJETO"					// 18
			cQueryD1P += ", '' OP"						// 19
			cQueryD1P += ", '' CC"						// 20
			cQueryD1P += ", D1_FORNECE FORNECEDOR"		// 21
			cQueryD1P += ", D1_LOJA LOJA"				// 22
			cQueryD1P += ", '' PEDIDO"					// 23
			cQueryD1P += ", D1_TIPO TIPONF"				// 24
			cQueryD1P += ", D1_CUSTO"					// 25
			// COLOCA A MOEDA DO CUSTO
			If mv_par11 > 1
				cQueryD1P += Str(mv_par11,1,0)			// 25
			EndIf
			cQueryD1P += " CUSTO"
			cQueryD1P += ", '' TRT" 					// 26
			IF lVEIC
				cQueryD1P += ", SB1.B1_CODITE B1_CODITE"	// 27
			ENDIF
			cQueryD1P += ", D1_LOTECTL LOTE"	    	// 28
			cQueryD1P += ", SD1.R_E_C_N_O_ NRECNO"		// 29

			cQueryD1 := " FROM "
			// cQueryD1 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD1")+ " SD1 , "+ RetSqlName("SF4")+" SF4 "
			cQueryD1 += RetSqlName("SB1") + " SB1"
			cQueryD1 += (", " + RetSqlName("SD1")+ " SD1 ")
			cQueryD1 += (", " + RetSqlName("SF4")+ " SF4 ")
			cQueryD1 += " WHERE SB1.B1_COD = D1_COD"
			cQueryD1 += (" AND D1_FILIAL = '"+xFilial("SD1")+"'")
			// cQueryD1 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
			cQueryD1 += (" AND F4_FILIAL = '" + xFilial("SF4") + "'")
			cQueryD1 += (" AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'")
			// cQueryD1 += " AND D1_DTDIGIT >= '"+DTOS(mv_par05)+"' AND D1_DTDIGIT <= '"+DTOS(mv_par06)+"'"
			cQueryD1 += (" AND D1_DTDIGIT >= '" + DTOS(mv_par05) + "'")
			cQueryD1 += (" AND D1_DTDIGIT <= '" + DTOS(mv_par06) + "'")
			cQueryD1 +=  " AND D1_ORIGLAN <> 'LF'"
			If !lCusUnif
				cQueryD1 += " AND D1_LOCAL = '" + mv_par08 + "'"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Não imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MTR910IsMNT() 
				cQueryD1 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
				cQueryD1 += " AND SB1.B1_COD <> '" + cProdTER + "'"
			EndIf	
			cQueryD1 += " AND SD1.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

			// cQueryD2 := " SELECT 'SD2',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,SB1.B1_POSIPI,D2_SEQCALC,D2_EMISSAO,D2_TES,D2_CF,D2_NUMSEQ,D2_DOC,D2_SERIE,D2_QUANT,D2_QTSEGUM,D2_LOCAL,'','',D2_CLIENTE,D2_LOJA,D2_PEDIDO,D2_TIPO,D2_CUSTO"
			cQueryD2P := " SELECT 'SD2'"
			cQueryD2P += ", SB1.B1_COD"
			cQueryD2P += ", SB1.B1_TIPO"
			cQueryD2P += ", SB1.B1_UM"
			cQueryD2P += ", SB1.B1_GRUPO"
			cQueryD2P += ", SB1.B1_DESC"
			cQueryD2P += ", SB1.B1_POSIPI"
			cQueryD2P += ", D2_SEQCALC"
			cQueryD2P += ", D2_EMISSAO"
			cQueryD2P += ", D2_TES"
			cQueryD2P += ", D2_CF"
			cQueryD2P += ", D2_NUMSEQ"
			cQueryD2P += ", D2_DOC"
			cQueryD2P += ", D2_SERIE"
			cQueryD2P += ", D2_QUANT"
			cQueryD2P += ", D2_QTSEGUM"
			cQueryD2P += ", D2_LOCAL"
			cQueryD2P += ", ''"
			cQueryD2P += ", ''"
			cQueryD2P += ", ''"
			cQueryD2P += ", D2_CLIENTE"
			cQueryD2P += ", D2_LOJA"
			cQueryD2P += ", D2_PEDIDO"
			cQueryD2P += ", D2_TIPO"
			cQueryD2P += ", D2_CUSTO"
			// COLOCA A MOEDA DO CUSTO
			cQueryD2P += Str(mv_par11,1,0)
			cQueryD2P += ", ''"
			If lVEIC
				cQueryD2P += ", SB1.B1_CODITE"	
			EndIf
			cQueryD2P += ", D2_LOTECTL"	
			cQueryD2P += ", SD2.R_E_C_N_O_ SD2RECNO"	// 29

			cQueryD2 := " FROM "
			cQueryD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
			cQueryD2 += " WHERE SB1.B1_COD = D2_COD AND D2_FILIAL = '"+xFilial("SD2")+"'"
			cQueryD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
			cQueryD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par05)+"' AND D2_EMISSAO <= '"+DTOS(mv_par06)+"'"
			cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
			If !lCusUnif
				cQueryD2 += " AND D2_LOCAL = '"+mv_par08+"'"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Não imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MTR910IsMNT() 
				cQueryD2 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
				cQueryD2 += " AND SB1.B1_COD <> '" + cProdTER + "'"
			EndIf	
			cQueryD2 += " AND SD2.D_E_L_E_T_=' ' AND SF4.D_E_L_E_T_=' '"

			// cQueryD3 := " SELECT 'SD3',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,SB1.B1_POSIPI,D3_SEQCALC,D3_EMISSAO,D3_TM,D3_CF,D3_NUMSEQ,D3_DOC,'',D3_QUANT,D3_QTSEGUM,D3_LOCAL,D3_OP,D3_CC,'','','','',D3_CUSTO"
			cQueryD3P := " SELECT 'SD3'"
			cQueryD3P += ", SB1.B1_COD"
			cQueryD3P += ", SB1.B1_TIPO"
			cQueryD3P += ", SB1.B1_UM"
			cQueryD3P += ", SB1.B1_GRUPO"
			cQueryD3P += ", SB1.B1_DESC"
			cQueryD3P += ", SB1.B1_POSIPI"
			cQueryD3P += ", D3_SEQCALC"
			cQueryD3P += ", D3_EMISSAO"
			cQueryD3P += ", D3_TM"
			cQueryD3P += ", D3_CF"
			cQueryD3P += ", D3_NUMSEQ"
			cQueryD3P += ", D3_DOC"
			cQueryD3P += ", ''"
			cQueryD3P += ", D3_QUANT"
			cQueryD3P += ", D3_QTSEGUM"
			cQueryD3P += ", D3_LOCAL"
			cQueryD3P += ", D3_PROJPMS"
			cQueryD3P += ", D3_OP"
			cQueryD3P += ", D3_CC"
			cQueryD3P += ", ''"
			cQueryD3P += ", ''"
			cQueryD3P += ", ''"
			cQueryD3P += ", ''"
			cQueryD3P += ", D3_CUSTO"
			// COLOCA A MOEDA DO CUSTO
			cQueryD3P += Str(mv_par11,1,0)
			cQueryD3P += ", D3_TRT"
			If lVEIC
				cQueryD3P += ", SB1.B1_CODITE"	
			EndIf
			cQueryD3P += ", D3_LOTECTL"	
			cQueryD3P += ", SD3.R_E_C_N_O_ SD3RECNO"		// 29

			cQueryD3 := " FROM "
			cQueryD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
			cQueryD3 += " WHERE SB1.B1_COD = D3_COD AND D3_FILIAL = '"+xFilial("SD3")+"' "
			cQueryD3 += " AND D3_EMISSAO >= '"+DTOS(mv_par05)+"' AND D3_EMISSAO <= '"+DTOS(mv_par06)+"'"
			If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
				cQueryD3 += " AND D3_ESTORNO <> 'S'"
			EndIf
			If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
				cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
				cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
			EndIf					
			If !lCusUnif .And. !lLocProc
				cQueryD3 += " AND D3_LOCAL = '"+mv_par08+"'"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Não imprimir o produto MANUTENCAO (MV_PRDMNT) qdo integrado com MNT.       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MTR910IsMNT() 
				cQueryD3 += " AND SB1.B1_COD <> '" + cProdMNT + "'"
				cQueryD3 += " AND SB1.B1_COD <> '" + cProdTER + "'"
			EndIf	
			cQueryD3 += " AND SD3.D_E_L_E_T_=' '"

			// cQuery := cQueryD1 + cQueryB1A + " AND " + cQueryB1C + " UNION " + cQueryD2 + cQueryB1A + " AND " + cQueryB1C+" UNION "+cQueryD3+cQueryB1A+" AND "+cQueryB1C
			cQuery := cQueryD1P + cQueryD1
			cQuery += cQueryB1A
			cQuery += " AND "
			cQuery += cQueryB1C
			cQuery += " UNION "
			cQuery += cQueryD2P + cQueryD2
			cQuery += cQueryB1A
			cQuery += " AND "
			cQuery += cQueryB1C
			cQuery += " UNION "
			cQuery += cQueryD3P + cQueryD3
			cQuery += cQueryB1A
			cQuery += " AND "
			cQuery += cQueryB1C
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ So inclui as condicoes a seguir qdo lista produtos sem ³
			//³ movimento                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par07 == 1
				// cQuery2:= cQueryD1+cQueryB1B+" AND "+cQueryB1C+" UNION "+cQueryD2+cQueryB1B+" AND "+cQueryB1C+" UNION "+cQueryD3+cQueryB1B+" AND "+cQueryB1C
				cQuery2 := " AND NOT EXISTS (" + cQuerySub + cQueryD1
				cQuery2 += cQueryB1B
				cQuery2 += " AND "
				cQuery2 += cQueryB1C
				cQuery2 += ") AND NOT EXISTS ("
				cQuery2 += cQuerySub + cQueryD2
				cQuery2 += cQueryB1B
				cQuery2 += " AND "
				cQuery2 += cQueryB1C
				cQuery2 += ") AND NOT EXISTS ("
				cQuery2 += cQuerySub + cQueryD3
				cQuery2 += cQueryB1B
				cQuery2 += " AND "
				cQuery2 += cQueryB1C + ")"
				//                                       1,            2,             3,           4,              5,             6,               7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
				// cQuery += " UNION SELECT 'SB1',SB1EXS.B1_COD,SB1EXS.B1_TIPO,SB1EXS.B1_UM,SB1EXS.B1_GRUPO,SB1EXS.B1_DESC,SB1EXS.B1_POSIPI,'','','','','','','',0 , 0,'','','','','','','',0 "
				cQuery += " UNION SELECT 'SB1'"		// 01
				cQuery += ", SB1EXS.B1_COD"			// 02
				cQuery += ", SB1EXS.B1_TIPO"		// 03
				cQuery += ", SB1EXS.B1_UM"			// 04
				cQuery += ", SB1EXS.B1_GRUPO"		// 05
				cQuery += ", SB1EXS.B1_DESC"		// 06
				cQuery += ", SB1EXS.B1_POSIPI"		// 07
				cQuery += ", ''"					// 08
				cQuery += ", ''"					// 09
				cQuery += ", ''"					// 10
				cQuery += ", ''"					// 11
				cQuery += ", ''"					// 12
				cQuery += ", ''"					// 13
				cQuery += ", ''"					// 14
				cQuery += ", 0"						// 15
				cQuery += ", 0"						// 16
				cQuery += ", ''"					// 17
				cQuery += ", ''"					// 18
				cQuery += ", ''"					// 19
				cQuery += ", ''"					// 20
				cQuery += ", ''"					// 21
				cQuery += ", ''"					// 22
				cQuery += ", ''"					// 23
				cQuery += ", ''"					// 24
				cQuery += ", 0"						// 25
				cQuery += ", ''"					// 26
				If lVEIC
					cQuery += ", SB1EXS.B1_CODITE CODITE"	// 27
				EndIf
				cQuery += ", ''"					// 28
				cQuery += ", 0"						// 29

				cQuery += " FROM "+RetSqlName("SB1") + " SB1EXS WHERE"
				cQuery += cQueryB1D
				cQuery += cQuery2
			EndIf
			If aReturn[8]==1
				If ! lVEIC
					cQuery += " ORDER BY 2,9,"
				Else
					cQuery += " ORDER BY 27, 9,"
				EndIf	
			ElseIf aReturn[8] == 2
				If ! lVEIC
					cQUery += " ORDER BY 3,2,9,"
				Else
					cQuery += " ORDER BY 3, 27, 9,"
				EndIf	
			EndIf
			If mv_par16 == 1
				cQuery += "17,12"
			Else
				If lCusUnif
					cQuery+="8,12"
				Else
					cQuery+="17,8,12"
				EndIf
			EndIf
			cQuery:=ChangeQuery(cQuery)
			MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTOP,.F.,.T.)},"Selecionando...")
			dbSelectArea(cAliasTop)
			SetRegua(nTotRegs)
			While !Eof()
				If lEnd
					@PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
					Exit
				EndIf
				IncRegua()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se nao encontrar no arquivo de saldos ,nao lista ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB2")
				If !dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusUnif,"",mv_par08))
					dbSelectArea(cAliasTop)
					dbSkip()
					Loop
				EndIf
				// Nao lista de saldo for igual a zero
				If mv_par20 == 2 .And. SB2->B2_QATU == 0
					dbSelectArea(cAliasTop)
					dbSkip()
					Loop
				EndIf
				// Nao lista de saldo for negativo
				If mv_par21 == 2 .And. SB2->B2_QATU < 0
					dbSelectArea(cAliasTop)
					dbSkip()
					Loop
				EndIf

				dbSelectArea(cAliasTop)
				cProdAnt  := (cAliasTop)->PRODUTO
				cLocalAnt := SB2->B2_LOCAL
				nEntrada:=nSaida:=0
				nCEntrada:=nCSaida:=0
				lFirst:=.F.

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(aReturn[7])
					dbSelectArea("SB1")
					If dbSeek(xFilial("SB1")+alltrim(cProdAnt))
						If !&(aReturn[7])
							dbSelectArea(cAliasTop)
							dbSkip()
							Loop
						EndIf
					Else
						dbSelectArea(cAliasTop)
						dbSkip()
						Loop
					EndIf
					dbSelectArea(cAliasTop)
				EndIf

				If li > 58
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Saldo Inicial do Produto             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusUnif
					aArea:=GetArea()
					aSalAtu  := { 0,0,0,0,0,0,0 }
					dbSelectArea("SB2")
					dbSetOrder(1)
					dbSeek(cSeek:=xFilial("SB2")+(cAliasTOP)->PRODUTO)
					While !Eof() .And. B2_FILIAL+B2_COD == cSeek
						aSalAlmox := CalcEst((cAliasTOP)->PRODUTO,SB2->B2_LOCAL,mv_par05)
						For i:=1 to Len(aSalAtu)
							aSalAtu[i] += aSalAlmox[i]
						Next i
						dbSkip()
					End
					RestArea(aArea)
				Else
					aSalAtu := CalcEst((cAliasTOP)->PRODUTO,mv_par08,mv_par05)
				EndIf

				If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
					aGrupos[nAcho][4] += aSalAtu[mv_par11+1]
				Else
					AADD(aGrupos,{(cAliasTOP)->TIPO,0,0,aSalAtu[mv_par11+1]})
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Custo Medio do Produto               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AsalAtu[1] > 0
					nCusmed := aSalAtu[mv_par11+1]/aSalAtu[1]
				ElseIf AsalAtu[1] == 0 .and. AsalAtu[mv_par11+1] == 0
					nCusMed := 0
				Else
					SB2->(dbSeek(xFilial("SB2") + (cAliasTOP)->PRODUTO + (cAliasTOP)->ARMAZEM))
					nCusmed := &("SB2->B2_CM" + Str(mv_par11,1))
				EndIf
				MR910ImpCb(aSalAtu,nCusMed,@Li,cPicB2Qt,cPicB2Cust, cAliasTop)
				lFirst1 := .F.

				While !Eof() .And. (cAliasTop)->PRODUTO = cProdAnt
					IncRegua()
					lContinua := .F.
					If Alltrim((cAliasTop)->ARQ) $ "SD1/SD2"
						lFirst:=.T.
						SF4->(dbSeek(xFilial("SF4")+(cAliasTop)->TES))
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Executa ponto de entrada para verificar se considera TES que ³
						//³ NAO ATUALIZA saldos em estoque.                              ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
							lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
							lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
						EndIf
						If SF4->F4_ESTOQUE != "S" .And. !lTesNEst
							dbSkip()
							Loop
						EndIf
					ElseIf Alltrim((cAliasTop)->ARQ) == "SD3"
						lFirst:=.T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Quando movimento ref apropr. indireta, so considera os         ³
						//³ movimentos com destino ao almoxarifado de apropriacao indireta.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lInverteMov:=.F.
						If (cAliasTop)->ARMAZEM != cLocalAnt .Or. lCusUnif
							If !(Substr((cAliasTop)->CF,3,1) == "3")
								If !lCusUnif
									dbSkip()
									Loop
								EndIf
							ElseIf lPriApropri
								lInverteMov:=.T.
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Caso seja uma transferencia de localizacao verifica se lista   ³
						//³ o movimento ou nao                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par17 == 2 .And. Substr((cAliasTop)->CF,3,1) == "4"
							cNumSeqTr := (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM)
							aDadosTran:={(cAliasTOP)->TES,(cAliasTOP)->QUANTIDADE,(cAliasTOP)->CUSTO,(cAliasTOP)->QUANT2UM,(cAliasTOP)->TIPO,;
								(cAliasTOP)->DATA,(cAliasTOP)->CF,(cAliasTOP)->SEQUENCIA,(cAliasTOP)->DOCUMENTO,(cAliasTOP)->PRODUTO,;
								(cAliasTOP)->OP,(cAliasTOP)->PROJETO,(cAliasTOP)->CC,(cAliasTOP)->ARQ}
							dbSkip()
							If (cAliasTOP)->(PRODUTO+SEQUENCIA+ARMAZEM) == cNumSeqTr
								dbSkip()
								Loop
							Else
								lContinua := .T.
								If li > 58
									cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
								EndIf
								If lFirst
									@Li ,000 PSay STOD(aDadosTran[6])
									@Li ,011 PSay aDadosTran[1]
									If ( cPaisLoc=="BRA" )
										@Li ,015 PSay allTrim(aDadosTran[7])
										If	lInverteMov
											@Li , 018 PSay "*"
										EndIf
									EndIf
									@Li , 020 PSay PadR(IIf(mv_par09 $ "Ss",aDadosTran[8],aDadosTran[9]),12)+" |"
								EndIf
								If aDadosTran[1] <= "500"
									@Li ,038 PSay aDadosTran[2] Picture cPicD3Qt
									@Li ,062 PSay aDadosTran[3] Picture cPicD3Cust
									@Li ,083 PSay "|"
									@Li ,085 PSay aDadosTran[3] / aDadosTran[2] Picture cPicB2Cust
									@Li ,104 PSay "|"
									nEntrada	  += aDadosTran[2]
									aSalAtu[1] += aDadosTran[2]
									nCEntrada  += aDadosTran[3]
									aSalAtu[mv_par11+1] += aDadosTran[3]
									aSalAtu[7] += aDadosTran[4]
									If (nAcho := ASCAN(aGrupos,{|x| aDadosTran[5] == x[1]})) > 0
										aGrupos[nAcho][2]+=aDadosTran[3]
										aGrupos[nAcho][4]+=aDadosTran[3]
									Else
										AADD(aGrupos,{aDadosTran[5],aDadosTran[3],0,aSalAtu[mv_par11+1]})
									EndIf
								Else
									@Li ,083 PSay "|"
									@Li ,085 PSay aDadosTran[3] / aDadosTran[2] Picture cPicB2Cust
									@Li ,104 PSay "|"
									@Li ,108 PSay aDadosTran[2] Picture cPicD3Qt
									@Li ,132 PSay aDadosTran[3] Picture cPicD3Cust
									nSaida	  += aDadosTran[2]
									aSalAtu[1] -= aDadosTran[2]
									nCSaida	  += aDadosTran[3]
									aSalAtu[mv_par11+1] -= aDadosTran[3]
									aSalAtu[7] -= aDadosTran[4]
									If (nAcho := ASCAN(aGrupos,{|x| aDadosTran[5] == x[1]})) > 0
										aGrupos[nAcho][3]+=aDadosTran[3]
										aGrupos[nAcho][4]-=aDadosTran[3]
									Else
										AADD(aGrupos,{aDadosTran[5],0,aDadosTran[3],-(aSalAtu[mv_par11+1])})
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf	
					If li > 58 .And. !lContinua
						cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					EndIf
					If lFirst .And. !lContinua
						@Li ,000 PSay STOD(DATA)
						@Li ,011 PSay TES
						If ( cPaisLoc=="BRA" )
							@Li ,015 PSay allTrim(CF)
							If	lInverteMov
								@Li , 018 PSay "*"
							EndIf
						EndIf
						@Li , 020 PSay PadR(IIF(mv_par09 $ "Ss",SEQUENCIA,DOCUMENTO),12)+" |"
					EndIf

					Do Case
						Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua
							lDev:=MTR910Dev(cAliasTop)
							If (cAliasTOP)->TES <= "500" .And. !lDev
								@Li ,038 PSay (cAliasTOP)->QUANTIDADE Picture cPicD1Qt
								@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD1Cust
								@Li ,083 PSay "|"
								If (cAliasTOP)->TIPONF != "C"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
								EndIf
								@Li ,104 PSay "|"
								nEntrada   += (cAliasTOP)->QUANTIDADE
								aSalAtu[1] += (cAliasTOP)->QUANTIDADE
								nCEntrada  += (cAliasTOP)->CUSTO
								aSalAtu[mv_par11+1] += (cAliasTOP)->CUSTO
								aSalAtu[7] += (cAliasTOP)->QUANT2UM
								If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
									aGrupos[nAcho][2]+=(cAliasTOP)->CUSTO
									aGrupos[nAcho][4]+=(cAliasTOP)->CUSTO
								Else
									AADD(aGrupos,{(cAliasTOP)->TIPO,(cAliasTOP)->CUSTO,0,aSalAtu[mv_par11+1]})
								EndIf
							Else
								@Li ,083 PSay "|"
								If (cAliasTOP)->TIPONF != "C"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
								EndIf
								@Li ,104 PSay "|"
								If lDev
									@Li ,108 PSay Space((nTam-1)-Len(Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD1Qt))))+"("+Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD1Qt))+")"
									cCusto:=Transform((cAliasTOP)->CUSTO,cPicD1Cust)
									@Li ,132 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
									nSaida 	  -= (cAliasTOP)->QUANTIDADE
									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									nCSaida	  -=(cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][3]-=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]+=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,0,-((cAliasTOP)->CUSTO),aSalAtu[mv_par11+1]})
									EndIf
								Else
									@Li	,108 PSay (cAliasTOP)->QUANTIDADE Picture cPicD1Qt
									@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD1Cust
									nSaida 	  += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
									nCSaida	  +=(cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] -= (cAliasTOP)->CUSTO
									aSalAtu[7] -= (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][3]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]-=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,0,(cAliasTOP)->CUSTO,-(aSalAtu[mv_par11+1])})
									EndIf
								EndIf
							EndIf
						Case Alltrim((cAliasTop)->ARQ) = "SD2" .And. !lContinua
							lDev:=MTR910Dev(cAliasTop)
							If (cAliasTOP)->TES <= "500" .Or. lDev
								If lDev
									@Li ,038 PSay Space((nTam-1)-Len(Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD2Qt))))+"("+Alltrim(Transform((cAliasTOP)->QUANTIDADE,cPicD2Qt))+")"
									cCusto:=Transform((cAliasTOP)->CUSTO,cPicD2Cust)
									@Li ,062 PSay Space((nTam-1)-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
									nEntrada   -= (cAliasTOP)->QUANTIDADE
									aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
									nCEntrada  -= (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] -= (cAliasTOP)->CUSTO
									aSalAtu[7] -= (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][2]-=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]-=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,-((cAliasTOP)->CUSTO),0,-(aSalAtu[mv_par11+1])})
									EndIf
								Else
									@Li ,038 PSay (cAliasTOP)->QUANTIDADE Picture cPicD2Qt
									@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD2Cust
									nEntrada   += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									nCEntrada  += (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][2]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]+=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,(cAliasTOP)->CUSTO,0,aSalAtu[mv_par11+1]})
									EndIf
								EndIf
								@Li ,083 PSay "|"
								If (cAliasTOP)->TIPONF != "C"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
								EndIf
								@Li ,104 PSay "|"
							Else
								@Li ,083 PSay "|"
								If (cAliasTOP)->TIPONF != "C"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
								EndIf
								@Li ,104 PSay "|"
								@Li ,108 PSay (cAliasTOP)->QUANTIDADE Picture cPicD2Qt
								@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD2Cust
								nSaida     += (cAliasTOP)->QUANTIDADE
								aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
								nCSaida	  +=  (cAliasTOP)->CUSTO
								aSalAtu[mv_par11+1] -= (cAliasTOP)->CUSTO
								aSalAtu[7] -= (cAliasTOP)->QUANT2UM
								If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
									aGrupos[nAcho][3]+=(cAliasTOP)->CUSTO
									aGrupos[nAcho][4]-=(cAliasTOP)->CUSTO
								Else
									AADD(aGrupos,{(cAliasTOP)->TIPO,0,(cAliasTOP)->CUSTO,-(aSalAtu[mv_par11+1])})
								EndIf
							EndIf
						Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua
							If	lInverteMov
								If (cAliasTOP)->TES > "500"
									@Li ,038 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
									@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
									@Li ,083 PSay "|"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
									@Li ,104 PSay "|"
									nEntrada  += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									nCEntrada  +=  (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][2]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]+=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,(cAliasTOP)->CUSTO,0,aSalAtu[mv_par11+1]})
									EndIf
								Else
									@Li ,083 PSay "|"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
									@Li ,104 PSay "|"
									@Li ,108 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
									@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
									nSaida	  += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
									nCSaida	  += (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] -= (cAliasTOP)->CUSTO
									aSalAtu[7] -= (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][3]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]-=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,0,(cAliasTOP)->CUSTO,-(aSalAtu[mv_par11+1])})
									EndIf
								EndIf 
								If lCusUnif
									lPriApropri:=.F.
								EndIf
							Else
								If (cAliasTOP)->TES <= "500"
									@Li ,038 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
									@Li ,062 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
									@Li ,083 PSay "|"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
									@Li ,104 PSay "|"
									nEntrada	  += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] += (cAliasTOP)->QUANTIDADE
									nCEntrada  +=  (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] += (cAliasTOP)->CUSTO
									aSalAtu[7] += (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][2]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]+=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,(cAliasTOP)->CUSTO,0,aSalAtu[mv_par11+1]})
									EndIf
								Else
									@Li ,083 PSay "|"
									@Li ,085 PSay (cAliasTOP)->CUSTO / (cAliasTOP)->QUANTIDADE Picture cPicB2Cust
									@Li ,104 PSay "|"
									@Li ,108 PSay (cAliasTOP)->QUANTIDADE Picture cPicD3Qt
									@Li ,132 PSay (cAliasTOP)->CUSTO Picture cPicD3Cust
									nSaida	  += (cAliasTOP)->QUANTIDADE
									aSalAtu[1] -= (cAliasTOP)->QUANTIDADE
									nCSaida	  += (cAliasTOP)->CUSTO
									aSalAtu[mv_par11+1] -= (cAliasTOP)->CUSTO
									aSalAtu[7] -= (cAliasTOP)->QUANT2UM
									If (nAcho := ASCAN(aGrupos,{|x| (cAliasTOP)->TIPO == x[1]})) > 0
										aGrupos[nAcho][3]+=(cAliasTOP)->CUSTO
										aGrupos[nAcho][4]-=(cAliasTOP)->CUSTO
									Else
										AADD(aGrupos,{(cAliasTOP)->TIPO,0,(cAliasTOP)->CUSTO,-(aSalAtu[mv_par11+1])})
									EndIf
								EndIf
								If lCusUnif
									lPriApropri:=.T.
								EndIf
							EndIf
					EndCase
					If lFirst
						@ Li,153 PSay "|"
						@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
						@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
						@ Li,195 PSay "|"
					EndIf
					Do Case
						Case Alltrim((cAliasTop)->ARQ) == "SD3" .And. !lContinua
							If Empty((cAliasTOP)->OP) .And. Empty((cAliasTOP)->PROJETO)
								@ LI,197 PSay 'CC'+(cAliasTOP)->CC
							ElseIf !Empty((cAliasTOP)->PROJETO)
								@ LI,197 PSay 'PJ'+(cAliasTOP)->PROJETO
							ElseIf !Empty((cAliasTOP)->OP)
								@ LI,207 PSay 'OP'+(cAliasTOP)->OP
							EndIf
						Case Alltrim((cAliasTop)->ARQ) == "SD1" .And. !lContinua
							@ LI,207 PSay 'F-'+(cAliasTOP)->FORNECEDOR
						Case Alltrim((cAliasTop)->ARQ) == "SD2" .And. !lContinua
							@ LI,207 PSay 'P-'+(cAliasTOP)->PEDIDO
						Case lContinua .And. aDadosTran[14] == "SD3"
							If Empty(aDadosTran[11]) .And. Empty(aDadosTran[12])
								@ LI,197 PSay 'CC'+aDadosTran[13]
							ElseIf !Empty(aDadosTran[12])
								@ LI,197 PSay 'PJ'+aDadosTran[12]
							ElseIf !Empty(aDadosTran[11])
								@ LI,207 PSay 'OP'+aDadosTran[11]
							EndIf
					EndCase
					Li++

					If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
						If !lContinua //Acerto para utilizar o Array aDadosTran[]
							dbSkip()
						EndIf
					EndIf
				EndDo

				If lFirst
					Li ++
					@ li,000 PSay "T O T A I S  :"
					@ Li,038 PSay nEntrada	Picture cPicD1Qt
					@ Li,062 PSay nCEntrada	Picture cPicD1Cust
					@ Li,108 PSay nSaida	Picture cPicD2Qt
					@ Li,132 PSay nCSaida	Picture cPicD2Cust
					@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
					@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
					Li++
					@ Li,135 PSay "QTD. NA SEGUNDA UM: "
					@ Li,157 PSay aSalAtu[7] Picture cPicB2Qt2
					Li++
					@Li ,  0 PSay __PrtThinLine()
					Li++
				Else
					If !MTR910IsMNT() .Or. (MTR910IsMNT() .and. SB1->B1_COD <> cProdMNT .and. SB1->B1_COD <> cProdTER)
						Li--
						@Li ,  0 PSay "NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
						Li++
						@Li ,  0 PSay __PrtThinLine()
						Li++
					EndIf	
				EndIf
			EndDo
			dbSelectArea(cAliasTop)
			dbCloseArea()

			If !Empty(aGrupos)
				Li++
				@ Li,005 PSay "R E S U M O"
				Li++
				Li++
				dbSelectArea("SX5")
				For i:=1 to Len(aGrupos)
					If li > 53
						cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					EndIf
					dbSeek(xFilial("SX5")+"02"+aGrupos[i][1])
					@ Li,000 PSay X5Descri()
					@ Li,063 PSay aGrupos[i][2] Picture cPicD1Cust
					@ Li,132 PSay aGrupos[i][3] Picture cPicD2Cust
					@ Li,177 PSay aGrupos[i][4] Picture cPicB2Cust
					Li++
				Next i
			EndIf
		EndIf // lImpLivro
	Else
#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seta ordens dos arquivos de movimentos e monta IndRegua      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par16 == 1
		If lCusUnif
			dbSelectArea("SD1")
			cIndice:="D1_FILIAL+D1_COD+DTOS(D1_DTDIGIT)+D1_NUMSEQ"
			IndRegua("SD1",cTrbSD1,cIndice,,DBFilter())
			nInd := RetIndex("SD1")
			#IFNDEF TOP
				dbSetIndex(cTrbSD1+OrdBagExt())
			#ENDIF
			dbSetOrder(nInd+1)

			dbSelectArea("SD2")
			cIndice:="D2_FILIAL+D2_COD+DTOS(D2_EMISSAO)+D2_NUMSEQ"
			IndRegua("SD2",cTrbSD2,cIndice,,DBFilter())
			nInd := RetIndex("SD2")
			#IFNDEF TOP
				dbSetIndex(cTrbSD2+OrdBagExt())
			#ENDIF
			dbSetOrder(nInd+1)

			dbSelectArea("SD3")
			cIndice:="D3_FILIAL+D3_COD+DTOS(D3_EMISSAO)+D3_NUMSEQ"
			IndRegua("SD3",cTrbSD3,cIndice,,DBFilter())
			nInd := RetIndex("SD3")
			#IFNDEF TOP
				dbSetIndex(cTrbSD3+OrdBagExt())
			#ENDIF
			dbSetOrder(nInd+1)
		Else
			dbSelectArea("SD1")
			dbSetOrder(7)
			dbSelectArea("SD2")
			dbSetOrder(6)
			dbSelectArea("SD3")
			dbSetOrder(7)
			If lLocProc
				cIndice:="D3_FILIAL+D3_COD+DTOS(D3_EMISSAO)+D3_NUMSEQ"
				IndRegua("SD3",cTrbSD3,cIndice,,DBFilter(),"Selecionando Registros")
				nInd := RetIndex("SD3")
				#IFNDEF TOP
					dbSetIndex(cTrbSD3+OrdBagExt())
				#ENDIF
				dbSetOrder(nInd+1)
			EndIf
		EndIf
	Else
		dbSelectArea("SD1")
		If lCusUnif
			cIndice:="D1_FILIAL+D1_COD+DTOS(D1_DTDIGIT)+D1_SEQCALC+D1_NUMSEQ"
		Else
			cIndice:="D1_FILIAL+D1_COD+D1_LOCAL+DTOS(D1_DTDIGIT)+D1_SEQCALC+D1_NUMSEQ"
		EndIf
		IndRegua("SD1",cTrbSD1,cIndice,,DBFilter(),"Selecionando Registros")
		nInd := RetIndex("SD1")
		#IFNDEF TOP
			dbSetIndex(cTrbSD1+OrdBagExt())
		#ENDIF
		dbSetOrder(nInd+1)

		dbSelectArea("SD2")
		If lCusUnif
			cIndice:="D2_FILIAL+D2_COD+DTOS(D2_EMISSAO)+D2_SEQCALC+D2_NUMSEQ"
		Else
			cIndice:="D2_FILIAL+D2_COD+D2_LOCAL+DTOS(D2_EMISSAO)+D2_SEQCALC+D2_NUMSEQ"
		EndIf
		IndRegua("SD2",cTrbSD2,cIndice,,DBFilter(),"Selecionando Registros")
		nInd := RetIndex("SD2")
		#IFNDEF TOP
			dbSetIndex(cTrbSD2+OrdBagExt())
		#ENDIF
		dbSetOrder(nInd+1)

		dbSelectArea("SD3")
		If lCusUnif
			cIndice:="D3_FILIAL+D3_COD+DTOS(D3_EMISSAO)+D3_SEQCALC+D3_NUMSEQ"
		Else
			If lLocProc
				cIndice:="D3_FILIAL+D3_COD+DTOS(D3_EMISSAO)+D3_SEQCALC+D3_NUMSEQ"
			Else
				cIndice:="D3_FILIAL+D3_COD+D3_LOCAL+DTOS(D3_EMISSAO)+D3_SEQCALC+D3_NUMSEQ"
			EndIf
		EndIf
		IndRegua("SD3",cTrbSD3,cIndice,,DBFilter(),"Selecionando Registros")
		nInd := RetIndex("SD3")
		#IFNDEF TOP
			dbSetIndex(cTrbSD3+OrdBagExt())
		#ENDIF
		dbSetOrder(nInd+1)
	EndIf

	dbSelectArea("SB1")
	If ! lVEIC

		If aReturn[8]==1
			dbSetOrder(1)
			dbseek(xFilial("SB1")+mv_par01,.T.)
			cCond1:="B1_COD"
			cCond2:="mv_par02"
		ElseIf aReturn[8] == 2
			dbSetOrder(2)
			dbseek(xFilial("SB1")+mv_par03,.T.)
			cCond1:="B1_TIPO"
			cCond2:="mv_par04"
		EndIf
	Else
		cArq1	:= CriaTrab( nil,.F. )
		If aReturn[8]==1
			IndRegua('SB1',cArq1,"B1_FILIAL+B1_CODITE")
			nInd1	:= RetIndex('SB1')
			#IFNDEF TOP
				dbSetIndex(cArq1 + OrdBagExt())
			#ENDIF
			dbSetOrder(nInd1 + 1)
			dbseek(xFilial("SB1")+mv_par01,.T.)
			cCond1:="B1_CODITE"
			cCond2:="mv_par02"
		ElseIf aReturn[8] == 2
			IndRegua('SB1',cArq1,"B1_FILIAL+B1_TIPO+B1_CODITE")
			nInd1	:= RetIndex('SB1')
			#IFNDEF TOP
				dbSetIndex(cArq1 + OrdBagExt())
			#ENDIF
			dbSetOrder(nInd1 + 1)
			dbseek(xFilial("SB1")+mv_par03,.T.)
			cCond1:="B1_TIPO"
			cCond2:="mv_par04"
		EndIf	
	EndIf	
	SetRegua(Lastrec()) // Cria Regua

	While !Eof() .and. B1_FILIAL == xFilial("SB1") .and. &cCond1 <= &cCond2 .And. lImpLivro

		If lEnd
			@PROW()+1,001 PSay "CANCELADO PELO OPERADOR"
			EXIT
		EndIf

		IncRegua()

		// Filtra por Tipo
		If B1_TIPO < mv_par03 .or. B1_TIPO > mv_par04
			dbSkip()
			Loop
		Endif

		If ! lVEIC
			If B1_COD < mv_par01 .or. B1_COD > mv_par02
				dbSkip()
				Loop
			EndIf
		Else
			If B1_CODITE < mv_par01 .or. B1_CODITE > mv_par02
				dbSkip()
				Loop
			EndIf
		EndIf	

		// Nao lista produto de importacao
		If B1_COD == Substr(cProdImp,1,Len(B1_COD))
			dbSkip()
			Loop
		EndIf

		// Filtra por Grupo
		If B1_GRUPO < mv_par18 .or. B1_GRUPO > mv_par19
			dbSkip()
			Loop
		EndIf

		dbSelectArea("SB2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se nao encontrar no arquivo de saldos ,nao lista ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !dbSeek(xFilial("SB2")+SB1->B1_COD+IF(lCusUnif,"",mv_par08))
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf

		// Nao lista de saldo for igual a zero
		If mv_par20 == 2 .And. SB2->B2_QATU == 0
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf

		// Nao lista de saldo for negativo
		If mv_par21 == 2 .And. SB2->B2_QATU < 0
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf

		nEntrada:=nSaida:=0
		nCEntrada:=nCSaida:=0
		aSalAtu   := { 0,0,0,0,0,0,0 }

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Saldo Inicial do Produto             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lCusUnif
			aArea:=GetArea()
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial("SB2")+SB1->B1_COD)
			While !Eof() .And. B2_FILIAL+B2_COD == xFilial("SB2")+SB1->B1_COD
				aSalAlmox := CalcEst(SB1->B1_COD,SB2->B2_LOCAL,mv_par05)
				For i:=1 to Len(aSalAtu)
					aSalAtu[i] += aSalAlmox[i]
				Next i
				dbSkip()
			End
			RestArea(aArea)
		Else
			aSalAtu := CalcEst(SB1->B1_COD,mv_par08,mv_par05)
		EndIf

		cProdAnt  := SB1->B1_COD
		cLocalAnt := mv_par08
		dCntData  := mv_par05
		nRec1 := nRec2 := nRec3 := 0
		nCusMed   := 0
		lFirst1   := .T.

		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSelectArea("SF2")
		dbSetOrder(1)
		dbSelectArea("SD1")
		dbSeek(xFilial("SD1")+SB1->B1_COD+If(lCusUnif,"",mv_par08)+dtos(dcntData),.T.)
		dbSelectArea("SD2")
		dbSeek(xFilial("SD2")+SB1->B1_COD+If(lCusUnif,"",mv_par08)+dtos(dcntData),.T.)
		dbSelectArea("SD3")
		dbSeek(xFilial("SD3")+SB1->B1_COD+If(lCusUnif.Or.lLocProc,"",mv_par08)+dtos(dcntData),.T.)

		While .T.
			dbSelectArea("SD1")

			If !Eof() .And. D1_FILIAL == xFilial("SD1") .And. D1_DTDIGIT == dCntData .And. D1_COD == cProdAnt .And. If(lCusUnif,.T.,D1_LOCAL == cLocalAnt)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If D1_ORIGLAN $ "LF"
					dbSkip()
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o TES atualiza estoque             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SF4")
				dbSeek(xFilial("SF4")+SD1->D1_TES)
				dbSelectArea("SD1")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa ponto de entrada para verificar se considera TES que ³
				//³ NAO ATUALIZA saldos em estoque.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
					lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
					lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
				EndIf
				If (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
					dbSkip()
					Loop
				EndIf
				cSeqIni := IIF(mv_par16==1,D1_NUMSEQ,D1_SEQCALC+D1_NUMSEQ)
				cAlias := Alias()
			EndIf

			dbSelectArea("SD3")
			If !Eof() .And. D3_FILIAL == xFilial("SD3") .And. D3_EMISSAO == dCntData .And. D3_COD == cProdAnt .And. If(lCusUnif.Or.lLocProc,.T.,D3_LOCAL == cLocalAnt)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Quando movimento ref apropr. indireta, so considera os         ³
				//³ movimentos com destino ao almoxarifado de apropriacao indireta.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lInverteMov:=.F.
				If !D3Valido()
					dbSkip()
					Loop
				EndIf
				If D3_LOCAL != cLocalAnt .Or. lCusUnif
					If !(Substr(D3_CF,3,1) == "3")
						If !lCusUnif
							dbSkip()
							Loop
						EndIf
					ElseIf lPriApropri
						lInverteMov:=.T.
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso seja uma transferencia de localizacao verifica se lista   ³
				//³ o movimento ou nao                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRecTrf1 := 0
				nRecTrf2 := 0
				If mv_par17 == 2 .And. Substr(D3_CF,3,1) == "4"
					If Len(aRecTRF)>0 .And. (aScan(aRecTRF, SD3->(Recno()))>0)
						SD3->(dbSkip())
						Loop
					EndIf
					cNumSeqTr := SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL//"E9"
					nRegTr    := Recno()
					aAreaSD3  := GetArea()
					SD3->(dbSetOrder(4))
					SD3->(dbGoTo(nRegTr))
					nRecTrf1 := SD3->(Recno())
					dbSkip()
					If SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL == cNumSeqTr//SD3->D3_CHAVE == cNumSeqTr
						nRecTrf2 := SD3->(Recno())
						aAdd(aRecTRF, nRecTrf1)
						aAdd(aRecTRF, nRecTrf2)
						RestArea(aAreaSD3)
						Loop
					Else
						RestArea(aAreaSD3)
					EndIf
				EndIf
				If mv_par16 == 1
					If D3_NUMSEQ < cSeqIni
						cSeqIni := D3_NUMSEQ
						cAlias := Alias()
					EndIf
				Else
					If D3_SEQCALC+D3_NUMSEQ < cSeqIni
						cSeqIni := D3_SEQCALC+D3_NUMSEQ
						cAlias := Alias()
					EndIf
				EndIf
			EndIf

			dbSelectArea("SD2")
			If !Eof() .And. D2_FILIAL == xFilial("SD2") .And. D2_EMISSAO == dCntData .And. D2_COD == cProdAnt .And. If(lCusUnif,.T.,D2_LOCAL == cLocalAnt)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If D2_ORIGLAN == "LF"
					dbSkip()
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o TES atualiza estoque             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SF4")
				dbSeek(xFilial("SF4")+SD2->D2_TES)
				dbSelectArea("SD2")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Executa ponto de entrada para verificar se considera TES que ³
				//³ NAO ATUALIZA saldos em estoque.                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lIxbConTes .And. SF4->F4_ESTOQUE != "S"
					lTesNEst := ExecBlock("MTAAVLTES",.F.,.F.)
					lTesNEst := If(ValType(lTesNEst) # "L",.F.,lTesNEst)
				EndIf
				If (SF4->F4_ESTOQUE != "S" .And. !lTesNEst)
					dbSkip()
					Loop
				EndIf
				If mv_par16 == 1
					If D2_NUMSEQ < cSeqIni
						cSeqIni := D2_NUMSEQ
						cAlias := Alias()
					EndIf
				Else
					If D2_SEQCALC+D2_NUMSEQ < cSeqIni
						cSeqIni := D2_SEQCALC+D2_NUMSEQ
						cAlias := Alias()
					EndIf
				EndIf
			EndIf


			If !Empty(cAlias)
				dbSelectArea(cAlias)
				cCampo1 := Subs(cAlias,2,2)+IIF(cAlias=="SD1","_DTDIGIT","_EMISSAO")
				cCampo2 := Subs(cAlias,2,2)+"_TES"
				cCampo3 := Subs(cAlias,2,2)+"_CF"
				cCampo4 := Subs(cAlias,2,2)+IIF(mv_par09 $ "Ss","_NUMSEQ","_DOC" )

				If li > 53
					cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf

				If lFirst1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula o Custo Medio do Produto               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If aSalAtu[1] > 0 .And. aSalAtu[mv_par11+1] > 0
						nCusMed := aSalAtu[mv_par11+1]/aSalAtu[1]
					ElseIf aSalAtu[1] == 0 .And. aSalAtu[mv_par11+1] == 0
						nCusMed := 0
					Else
						nCusMed := &(Eval(bBloco,"SB2->B2_CM",mv_par11))
					EndIf
					MR910ImpCb(aSalAtu,nCusMed,@Li,cPicB2Qt,cPicB2Cust)
					lFirst1 := .F.
				EndIf

				@Li ,   0 PSay &cCampo1
				If cAlias == "SD3"
					@Li ,011 PSay D3_TM
				Else
					@Li ,011 PSay &cCampo2
				EndIf
				If ( cPaisLoc=="BRA" )
					@Li , 015 PSay &cCampo3
					If	lInverteMov
						@Li , 018 PSay "*"
					EndIf
				EndIf
				@Li , 020 PSay PadR(&cCampo4,12)+" |"
				Do Case
					Case cAlias = "SD1"
						lDev:=MTR910Dev(cAliasTop)
						If D1_TES <= "500" .And. !lDev
							@ Li,038 PSay D1_QUANT Picture cPicD1Qt
							@ Li,062 PSay &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11))) Picture cPicD1Cust
							@ Li,083 PSay "|"
							If SF1->F1_TIPO != "C"
								@ Li,085 PSay (&(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11))) / D1_QUANT) Picture cPicB2Cust
							EndIf
							@ Li,104 PSay "|"
							nEntrada	+= D1_QUANT
							aSalAtu[1] += D1_QUANT
							nCEntrada += &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
							nGEntrada += &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
							aSalAtu[mv_par11+1] += &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
							aSalAtu[7] += D1_QTSEGUM
						Else
							@ Li,083 PSay "|"
							If SF1->F1_TIPO != "C"
								@ Li,085 PSay (&(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11))) / D1_QUANT) Picture cPicB2Cust
							EndIf
							@ Li,104 PSay "|"
							If lDev
								@ Li,108 PSay Space(17-Len(Alltrim(Transform(D1_QUANT,cPicD1Qt))))+"("+Alltrim(Transform(D1_QUANT,cPicD1Qt))+")"
								cCusto:=Transform(&(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11))),cPicD1Cust)
								@ Li,132 PSay Space(17-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
							Else
								@ Li,108 PSay D1_QUANT Picture cPicD1Qt
								@ Li,132 PSay &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11))) Picture cPicD1Cust
							EndIf
							If !lDev
								nSaida+= D1_QUANT
								aSalAtu[1] -= D1_QUANT
								nCSaida+= &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								nGSaida+= &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								aSalAtu[mv_par11+1] -= &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								aSalAtu[7] -= D1_QTSEGUM
							Else
								nSaida-= D1_QUANT
								aSalAtu[1] += D1_QUANT
								nCSaida-= &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								nGSaida-= &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								aSalAtu[mv_par11+1] += &(Eval(bBloco,"D1_CUSTO",iif(mv_par11==1," ",mv_par11)))
								aSalAtu[7] += D1_QTSEGUM
							EndIf
						EndIf
						nRec1++
					
					Case cAlias = "SD2"
						lDev:=MTR910Dev(cAliasTop)
						If D2_TES <= "500" .Or. lDev
							If lDev
								@ Li,038 PSay Space(17-Len(Alltrim(Transform(D2_QUANT,cPicD2Qt))))+"("+Alltrim(Transform(D2_QUANT,cPicD2Qt))+")"
								cCusto:=Transform(&(Eval(bBloco,"D2_CUSTO",mv_par11)),cPicD2Cust)
								@ Li,062 PSay Space(17-Len(Alltrim(cCusto)))+"("+Alltrim(cCusto)+")"
							Else
								@ Li,038 PSay D2_QUANT Picture cPicD2Qt
								@ Li,062 PSay &(Eval(bBloco,"D2_CUSTO",mv_par11)) Picture cPicD2Cust
							EndIf
							@ Li,083 PSay "|"
							If SF2->F2_TIPO != "C"
								@ Li,085 PSay (&(Eval(bBloco,"D2_CUSTO",mv_par11)) / D2_QUANT) Picture cPicB2Cust
							EndIf
							@ Li,104 PSay "|"
							If !lDev
								nEntrada+= D2_QUANT
								aSalAtu[1] += D2_QUANT
								nCEntrada+= &(Eval(bBloco,"D2_CUSTO",mv_par11))
								nGEntrada+= &(Eval(bBloco,"D2_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] += &(Eval(bBloco,"D2_CUSTO",mv_par11))
								aSalAtu[7] += D2_QTSEGUM
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Se for devolucao, subtrai nos valores de entrada³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nEntrada-= D2_QUANT
								aSalAtu[1] -= D2_QUANT
								nCEntrada-= &(Eval(bBloco,"D2_CUSTO",mv_par11))
								nGEntrada-= &(Eval(bBloco,"D2_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
								aSalAtu[7] -= D2_QTSEGUM
							EndIf
						Else
							@ Li,083 PSay "|"
							If SF2->F2_TIPO != "C"
								@ Li,085 PSay (&(Eval(bBloco,"D2_CUSTO",mv_par11)) / D2_QUANT) Picture cPicB2Cust
							EndIf
							@ Li,104 PSay "|"
							@ Li,108 PSay D2_QUANT Picture cPicD2Qt
							@ Li,132 PSay &(Eval(bBloco,"D2_CUSTO",mv_par11)) Picture cPicD2Cust
							nSaida+= D2_QUANT
							aSalAtu[1] -= D2_QUANT
							nCSaida+=  &(Eval(bBloco,"D2_CUSTO",mv_par11))
							nGSaida+=  &(Eval(bBloco,"D2_CUSTO",mv_par11))
							aSalAtu[mv_par11+1] -= &(Eval(bBloco,"D2_CUSTO",mv_par11))
							aSalAtu[7] -= D2_QTSEGUM
						EndIf
						nRec2++

					Otherwise
						If !D3Valido()
							dbSkip()
							Loop
						EndIf
   	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Caso seja uma transferencia de localizacao verifica se lista   ³
						//³ o movimento ou nao                                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par17 == 2 .And. Substr(D3_CF,3,1) == "4"
							cNumSeqTr := SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL
							nRegTr    := Recno()
							dbSkip()
							If SD3->D3_COD+SD3->D3_NUMSEQ+SD3->D3_LOCAL == cNumSeqTr
								dbSkip()
								Loop
							Else
								dbGoto(nRegTr)
							EndIf
						EndIf

						If	lInverteMov
							If D3_TM > "500"
								@Li ,038 PSay D3_QUANT Picture cPicD3Qt
								@Li ,062 PSay &(Eval(bBloco,"D3_CUSTO",mv_par11)) Picture cPicD3Cust
								@Li ,083 PSay "|"
								@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par11)) / D3_QUANT) Picture cPicB2Cust
								@Li ,104 PSay "|"
								nEntrada	  += D3_QUANT
								aSalAtu[1] += D3_QUANT
								nCEntrada  += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								nGEntrada  += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[7] += D3_QTSEGUM
							Else	
								@Li ,083 PSay "|"
								@Li ,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par11)) / D3_QUANT) Picture cPicB2Cust
								@Li ,104 PSay "|"
								@Li ,108 PSay D3_QUANT Picture cPicD3Qt
								@Li ,132 PSay &(Eval(bBloco,"D3_CUSTO",mv_par11)) Picture cPicD3Cust
								nSaida	  += D3_QUANT
								aSalAtu[1] -= D3_QUANT
								nCSaida	  += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								nGSaida	  += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[7] -= D3_QTSEGUM
							EndIf
							If lCusUnif
								lPriApropri:=.F.
							EndIf
						Else
							If D3_TM <= "500"
								@ Li,038 PSay D3_QUANT  Picture cPicD3Qt
								@ Li,062 PSay &(Eval(bBloco,"D3_CUSTO",mv_par11)) Picture cPicD3Cust
								@ Li,083 PSay "|"
								@ Li,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par11)) / D3_QUANT) Picture cPicB2Cust
								@ Li,104 PSay "|"
								nEntrada+= D3_QUANT
								aSalAtu[1] += D3_QUANT
								nCEntrada+= &(Eval(bBloco,"D3_CUSTO",mv_par11))
								nGEntrada+= &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] += &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[7] += D3_QTSEGUM
							Else
								@ Li,083 PSay "|"
								@ Li,085 PSay (&(Eval(bBloco,"D3_CUSTO",mv_par11)) / D3_QUANT) Picture cPicB2Cust
								@ Li,104 PSay "|"
								@ Li,108 PSay D3_QUANT  Picture cPicD3Qt
								@ Li,132 PSay &(Eval(bBloco,"D3_CUSTO",mv_par11)) Picture cPicD3Cust
								nSaida+= D3_QUANT
								aSalAtu[1] -= D3_QUANT
								nCSaida+=  &(Eval(bBloco,"D3_CUSTO",mv_par11))
								nGSaida+=  &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[mv_par11+1] -= &(Eval(bBloco,"D3_CUSTO",mv_par11))
								aSalAtu[7] -= D3_QTSEGUM
							EndIf
							If lCusUnif
								lPriApropri:=.T.
							EndIf
						EndIf
						nRec3++
				EndCase
				@ Li,153 PSay "|"
				@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
				@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
				@ Li,195 PSay "|"
				If cPaisLoc <> "CHI"
					Do Case
						Case cAlias = "SD3"  && movimentos (SD3)
							If Empty(D3_OP) .And. Empty(D3_PROJPMS)
								@ LI,197 PSay 'CC'+D3_CC
							ElseIf !Empty(D3_PROJPMS)
								@ LI,197 PSay 'PJ'+D3_PROJPMS
							ElseIf !Empty(D3_OP)
								@ LI,207 PSay 'OP'+D3_OP
							EndIf
						Case cAlias = "SD1"  && compras    (SD1)
							@ LI,207 PSay 'F-'+D1_FORNECE
						Case cAlias = "SD2"  && vendas     (SD2)
							If D2_TIPO == "B"
								@ LI,207 PSay 'F-'+D2_CLIENTE
							Else
								@ LI,207 PSay 'C-'+D2_CLIENTE
							EndIf
					EndCase
				EndIf
				Li++
				cSeqIni := Replicate("z",6)
				cAlias := ""
				If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
					dbSkip()
				EndIf
			Else
				dCntData++
			EndIf

			nAcho:=ASCAN(aGrupos,{|x| SB1->B1_TIPO == x[1]})
			If nAcho > 0
				aGrupos[nAcho][2]+=nGEntrada
				aGrupos[nAcho][3]+=nGSaida
			Else
				AADD(aGrupos,{SB1->B1_TIPO,nGEntrada,nGSaida,0})
				nAcho := Len(aGrupos)
			EndIf

			nGEntrada := 0
			nGSaida   := 0

			If dCntData > mv_par06
				If nRec1 > 0 .or. nRec2 > 0 .or. nRec3 > 0
					nAcho:=ASCAN(aGrupos,{|x| SB1->B1_TIPO == x[1]})
					If nAcho > 0
						aGrupos[nAcho][4]+=aSalAtu[mv_par11+1]
					Else
						AADD(aGrupos,{SB1->B1_TIPO,0,0,aSalAtu[mv_par11+1]})
						nAcho := Len(aGrupos)
					EndIf
					Li ++
					@ li,000 PSay "T O T A I S  :"
					@ Li,038 PSay nEntrada  Picture cPicD1Qt
					@ Li,062 PSay nCEntrada Picture cPicD1Cust
					@ Li,108 PSay nSaida    Picture cPicD2Qt
					@ Li,132 PSay nCSaida   Picture cPicD2Cust
					@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
					@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
					Li++
					@ Li,135 PSay "QTD. NA SEGUNDA UM: "
					@ Li,157 PSay aSalAtu[7] Picture cPicB2Qt2
					Li++
					@ Li,000 PSay __PrtThinLine()
					Li++
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se deve ou nao listar os produtos s/movimento ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If mv_par07 == 1
						nAcho:=ASCAN(aGrupos,{|x| SB1->B1_TIPO == x[1]})
						If nAcho > 0
							aGrupos[nAcho][4]+=aSalAtu[mv_par11+1]
						Else
							AADD(aGrupos,{SB1->B1_TIPO,0,0,aSalAtu[mv_par11+1]})
							nAcho := Len(aGrupos)
						EndIf
						If li > 53
							cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Calcula o Custo Medio do Produto               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If aSalAtu[1] > 0 .And. aSalAtu[mv_par11+1] > 0
							nCusMed := aSalAtu[mv_par11+1]/aSalAtu[1]
						ElseIf aSalAtu[1] == 0 .And. aSalAtu[mv_par11+1] == 0
							nCusMed := 0
						Else
							nCusMed := &(Eval(bBloco,"SB2->B2_CM",mv_par11))
						EndIf
						MR910ImpCb(aSalAtu,nCusMed,@Li,cPicB2Qt,cPicB2Cust)

						If !MTR910IsMNT() .Or. (MTR910IsMNT() .and. SB1->B1_COD <> cProdMNT .and. SB1->B1_COD <> cProdTER)
							@Li ,  0 PSay "NAO HOUVE MOVIMENTACAO PARA ESTE PRODUTO"
							Li++
							@Li ,  0 PSay __PrtThinLine()
							Li++
						EndIf	
					EndIf
				EndIf
				Exit
			EndIf

		EndDo

		dbSelectArea("SB1")
		dbSkip()

	EndDo

	If !Empty(aGrupos)
		Li++
		@ Li,005 PSay "R E S U M O"
		Li++
		Li++
		cAlias:=Alias()
		dbSelectArea("SX5")
		For i:=1 to Len(aGrupos)
			If li > 53
				cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			dbSeek(xFilial("SX5")+"02"+aGrupos[i][1])
			@ Li,000 PSay X5Descri()
			@ Li,063 PSay aGrupos[i][2] Picture cPicD1Cust
			@ Li,132 PSay aGrupos[i][3] Picture cPicD2Cust
			@ Li,177 PSay aGrupos[i][4] Picture cPicB2Cust
			Li++
		Next i
		dbSelectArea(cAlias)
	EndIf

	#IFDEF TOP
	EndIf	
	#ENDIF

If li != 80 .and. lImpLivro
	roda(cbcont,cbtxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao de Termos Abertura e Encerramento                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lImpTermos // Impressao dos Termos

	cArqAbert:=GetMv("MV_LMOD3AB")
	cArqEncer:=GetMv("MV_LMOD3EN")

	dbSelectArea("SM0")
	aVariaveis:={}

	For i:=1 to FCount()
		If FieldName(i)=="M0_CGC"
			AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
		Else
			If FieldName(i)=="M0_NOME"
				Loop
			EndIf
			AADD(aVariaveis,{FieldName(i),FieldGet(i)})
		EndIf
	Next

	dbSelectArea("SX1")
	dbSeek(PADR("MTR910",nTamSX1)+"01")

	While SX1->X1_GRUPO==PADR("MTR910",nTamSX1)
		AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
		dbSkip()
	EndDo

	If !File(cArqAbert)
		aSavSet:=__SetSets()
		//Editor de Termos de Livros
		cArqAbert:=CFGX024(,OemToAnsi(" Edi‡„o do Termo de Abertura "))
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	EndIf

	If !File(cArqEncer)
		aSavSet:=__SetSets()
		// Editor de Termos de Livros
		cArqEncer:=CFGX024(,OemToAnsi(" Edi‡„o do Termo de Abertura "))
		__SetSets(aSavSet)
		Set(24,Set(24),.t.)
	EndIf

	cDriver:=aDriver[4]
	If cArqAbert#NIL
		ImpTerm(cArqAbert,aVariaveis,&cDriver)
	EndIf

	If cArqEncer#NIL
		ImpTerm(cArqEncer,aVariaveis,&cDriver)
	EndIf

EndIf

dbSelectArea("SB1")
dbClearFilter()
If !Empty(cArq1) .AND. File(cArq1 + OrdBagExt())
	RetIndex('SB1')
	FERASE(cArq1 + OrdBagExt())
EndIf
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(1)

dbSelectArea("SD1")
If mv_par16 == 2 .Or. lCusUnif
	RetIndex("SD1")
	Ferase(cTrbSD1+OrdBagExt())
EndIf
dbSetOrder(1)

dbSelectArea("SD2")
If mv_par16 == 2 .Or. lCusUnif
	RetIndex("SD2")
	Ferase(cTrbSD2+OrdBagExt())
EndIf
dbSetOrder(1)

dbSelectArea("SD3")
If mv_par16 == 2 .Or. lCusUnif
	RetIndex("SD3")
	Ferase(cTrbSD3+OrdBagExt())
EndIf
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
EndIf

MS_FLUSH()
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR910ImpCb³ Autor ³ Eveli Morasco         ³ Data ³ 28/11/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do item                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR910ImpCb(ExpA1,ExpN1,@ExpN2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do saldo inicial do item     ³±±
±±³          ³   [1] = Saldo inicial em quantidade                        ³±±
±±³          ³   [2] = Saldo inicial em valor                             ³±±
±±³          ³   [3] = Saldo inicial na 2a unidade de medida              ³±±
±±³          ³ ExpN1 = Custo medio do item                                ³±±
±±³          ³ ExpN2 = Numero da linha corrente de impressao              ³±±
±±³          ³ ExpN3 = Picture Do Campo                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR910ImpCb(aSalAtu,nCusMed,Li,cPicB2Qt,cPicB2Cust, cAliasTop)

#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		If ! lVEIC
			@ Li,000 PSay (cAliasTop)->PRODUTO
			@ Li,019 PSay SubStr((cAliasTop)->B1_DESC,1,30)
			@ Li,056 PSay "UM : "+(cAliasTop)->B1_UM
			@ Li,068 PSay "TIPO : "+(cAliasTop)->TIPO
			@ Li,083 PSay "GRUPO : "+(cAliasTop)->B1_GRUPO
			@ Li,115 PSay "Custo Medio : "
			@ Li,132 PSay nCusMed	Picture cPicB2Cust
			@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
			@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
			Li++
			If cPaisLoc<>"CHI"
				@ Li,000 PSay "Posicao IPI : "
				@ Li,015 PSay (cAliasTop)->B1_POSIPI Picture "@R 9999.9999.99"
			EndIf

			dbSelectArea("SB2")
			dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusUnif,"",mv_par08))
			@ Li,035 PSay "Localizacao : "+ If(lCusUnif , MV_PAR08 , SB2->B2_LOCALIZ)
		Else
			@ Li,000 PSay (cAliasTop)->B1_CODITE
			@ Li,PCOL() + 2 PSay SubStr((cAliasTop)->B1_DESC,1,30)	// SB1->B1_DESC
			@ Li,115 PSay "Custo Medio : "
			@ Li,132 PSay nCusMed	Picture cPicB2Cust
			@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
			@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
			Li++
			@ Li,000 PSay (cAliasTop)->PRODUTO // SB1->B1_COD
			@ Li,PCOL() + 2 PSay "UM : " + (cAliasTop)->B1_UM	 	// SB1->B1_UM			//
			@ Li,PCOL() + 2 PSay "TIPO : " + (cAliasTop)->TIPO     	// SB1->B1_TIPO			//
			@ Li,PCOL() + 2 PSay "GRUPO : " + (cAliasTop)->B1_GRUPO 	// SB1->B1_GRUPO		//
			If cPaisLoc<>"CHI"
				@ Li,PCOL() + 2 PSay "Posicao IPI : "
				@ Li,PCOL() + 2 PSay (cAliasTop)->B1_POSIPI /* SB1->B1_POSIPI */ Picture "@R 9999.9999.99"
			EndIf
			@ Li,PCOL() + 2 PSay "Localizacao : " + If(lCusUnif , MV_PAR08 , SB2->B2_LOCALIZ) //
		EndIf

		dbSelectArea(cAliasTop)
	Else	
#ENDIF

	If ! lVEIC
		@ Li,000 PSay SB1->B1_COD
		@ Li,019 PSay SubStr(SB1->B1_DESC,1,30)
		@ Li,056 PSay "UM : "+SB1->B1_UM			//
		@ Li,068 PSay "TIPO : "+SB1->B1_TIPO			//
		@ Li,083 PSay "GRUPO : "+SB1->B1_GRUPO			//
		@ Li,115 PSay "Custo Medio : "
		@ Li,132 PSay nCusMed	Picture cPicB2Cust
		@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
		@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
		Li++
		If cPaisLoc<>"CHI"
			@ Li,000 PSay "Posicao IPI : "
			@ Li,015 PSay SB1->B1_POSIPI Picture "@R 9999.9999.99"
		EndIf
		@ Li,035 PSay "Localizacao : " + If(lCusUnif , MV_PAR08 , SB2->B2_LOCALIZ) //
	Else
		@ Li,000 PSay SB1->B1_CODITE
		@ Li,PCOL() + 2 PSay SB1->B1_DESC
		@ Li,115 PSay "Custo Medio : "
		@ Li,132 PSay nCusMed	Picture cPicB2Cust
		@ Li,157 PSay aSalAtu[1] Picture cPicB2Qt
		@ Li,177 PSay aSalAtu[mv_par11+1] Picture cPicB2Cust
		Li++
		@ Li,000 PSay SB1->B1_COD
		@ Li,PCOL() + 2 PSay "UM : "+SB1->B1_UM			//
		@ Li,PCOL() + 2  PSay "TIPO : "+SB1->B1_TIPO			//
		@ Li,PCOL() + 2  PSay "GRUPO : "+SB1->B1_GRUPO		//
		If cPaisLoc<>"CHI"
			@ Li,PCOL() + 2 PSay "Posicao IPI : "
			@ Li,PCOL() + 2 PSay SB1->B1_POSIPI Picture "@R 9999.9999.99"
		EndIf
		@ Li,PCOL() + 2 PSay "Localizacao : " + If(lCusUnif , MV_PAR08 , SB2->B2_LOCALIZ) //
	EndIf

	#IFDEF TOP
	EndIf
	#ENDIF

Li += 2
RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR910val³ Autor ³ Paulo Boschetti       ³ Data ³ 22.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Mtr910val()
Local lRet := .T.

If mv_par09 $ "dsDS"
	lRet := .T.
Else
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MTR910Dev³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 25.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Avalia se item pertence a uma nota de devolu‡ao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR910Dev(cAliasTop)
Static lListaDev := NIL
LOCAL lRet:=.F.
LOCAL cAlias:=Alias()


// Identifica se lista dev. na mesma coluna
lListaDev := If(ValType(lListaDev)#"L",GetMV("MV_LISTDEV"),lListaDev)


#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		If lListaDev .And. (cAliasTop)->ARQ == "SD1"
			dbSelectArea("SF1")
			If dbSeek(xFilial("SF1")+(cAliasTop)->DOCUMENTO+(cAliasTop)->SERIE+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA) .And. (cAliasTop)->TIPONF == "D"
				lRet:=.T.
			EndIf
		ElseIf lListaDev .And. (cAliasTop)->ARQ == "SD2"
			dbSelectArea("SF2")
			If dbSeek(xFilial("SF2")+(cAliasTop)->DOCUMENTO+(cAliasTop)->SERIE+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA) .And. (cAliasTop)->TIPONF == "D"
				lRet:=.T.
			EndIf
		EndIf
		dbSelectArea(cAliasTop)
	Else	
#ENDIF
	If lListaDev .And. cAlias == "SD1"
		dbSelectArea("SF1")
		If dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA) .And. SF1->F1_TIPO == "D"
			lRet:=.T.
		EndIf
	ElseIf lListaDev .And. cAlias == "SD2"
		dbSelectArea("SF2")
		If dbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA) .And. SF2->F2_TIPO == "D"
			lRet:=.T.
		EndIf
	EndIf
	dbSelectArea(cAlias)

	#IFDEF TOP
	EndIf
	#ENDIF

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR910CUnf ³ Autor ³Rodrigo de A. Sartorio ³ Data ³26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ajusta grupo de perguntas p/ Custo Unificado                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTR910Cunf(ExpL1)					                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Custo Unificado								 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR910CUnf(lCusUnif)
Local aSvAlias:=GetArea()
Local nTamSX1 :=Len(SX1->X1_GRUPO)
dbSelectArea("SX1")
If dbSeek(PADR("MTR910",nTamSX1)+"08",.F.)
	If !("MTR910VAlm" $ X1_VALID)
		RecLock("SX1",.F.)
		If Empty(X1_VALID)
			Replace X1_VALID With "MTR910VAlm"
		Else
			Replace X1_VALID With X1_VALID+".And.MTR910VAlm"
		EndIf
		MsUnlock()
	EndIf
	If lCusUnif .And. X1_CNT01 != "**"
		RecLock("SX1",.F.)
		Replace X1_CNT01 With "**"
		MsUnlock()
	EndIf
EndIf
RestArea(aSvAlias)
Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR910VAlm ³ Autor ³Rodrigo de A. Sartorio ³ Data ³26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Almoxarifado do KARDEX com relacao a custo unificado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR910VAlm()
LOCAL lRet:=.T.
LOCAL cConteudo:=&(ReadVar())
LOCAL nOpc:=2
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por Empresa/Filial       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetMV("MV_CUSFIL",.F.))
If lCusUnif .And. cConteudo != "**"
	nOpc := Aviso("Aten‡„o","Ao alterar o almoxarifado o custo medio unificado sera desconsiderado.",{"Confirma","Abandona"})
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AjustaSX1³ Autor ³ Marcos V. Ferreira    ³ Data ³29/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera descricao da pergunta no SX1                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aArea := { Alias(), IndexOrd() } , aPerg:={}
Local cPerg := "MTR910"        
Local nTamSX1 := Len(SX1->X1_GRUPO)

Aadd(aPerg,{"So Livro","Solo Libro","Only Book"})
Aadd(aPerg,{"So Termos","Solo Actas","Terms Only"})

dbSelectArea("SX1")
dbSetOrder(1)
If dbSeek(PADR(cPerg,nTamSX1)+"15")
	RecLock("SX1",.F.)
	Replace X1_DEF01 	with aPerg[1][1]
	Replace X1_DEFSPA1	with aPerg[1][2]
	Replace X1_DEFENG1 	with aPerg[1][3]
	Replace X1_DEF03 	with aPerg[2][1]
	Replace X1_DEFSPA3	with aPerg[2][2]
	Replace X1_DEFENG3 	with aPerg[2][3]
	MsUnLock()
EndIf

aPerg := {}
Aadd(aPerg,{"Digitacao","Digitacion","Typing"})
Aadd(aPerg,{"Calculo","Calculo","Calculation"})

dbSelectArea("SX1")
dbSetOrder(1)

If dbSeek(PADR(cPerg,nTamSX1)+"07") .And. SX1->X1_TIPO == "C"
	RecLock("SX1",.F.)
	Replace X1_TIPO     with "N"
	Replace X1_PRESEL   with 1
	Replace X1_GSC   	with "C"
	Replace X1_DEF01    with "Sim"
	Replace X1_DEFSPA1  with "Si"
	Replace X1_DEFENG1  with "Yes"
	Replace X1_DEF02    with "Nao"
	Replace X1_DEFSPA2  with "No"
	Replace X1_DEFENG2  with "No"
	Replace X1_CNT01    with " "
	MsUnLock()
EndIf

If dbSeek(PADR(cPerg,nTamSX1)+"16")
	RecLock("SX1",.F.)
	Replace X1_DEF01 	with aPerg[1][1]
	Replace X1_DEFSPA1	with aPerg[1][2]
	Replace X1_DEFENG1 	with aPerg[1][3]
	Replace X1_DEF02 	with aPerg[2][1]
	Replace X1_DEFSPA2	with aPerg[2][2]
	Replace X1_DEFENG2 	with aPerg[2][3]
	MsUnLock()
EndIf

dbSelectArea( aArea[1] )
dbSetOrder( aArea[2] )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR910ImpS1³ Autor ³ Nereu Humberto Junior ³ Data ³ 12/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime secoes 1 e 2 (Dados do produto)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR910ImpS1(ExpA1,ExpN1,ExpC1,ExpL1,ExpL2,ExpO1,ExpO2)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do saldo inicial do item     ³±±
±±³          ³   [1] = Saldo inicial em quantidade                        ³±±
±±³          ³   [2] = Saldo inicial em valor                             ³±±
±±³          ³   [3] = Saldo inicial na 2a unidade de medida              ³±±
±±³          ³ ExpN1 = Custo medio do item                                ³±±
±±³          ³ ExpC1 = Alias                                              ³±±
±±³          ³ ExpL1 = Veiculo                                            ³±±
±±³          ³ ExpL2 = Custo Unificado                                    ³±±
±±³          ³ ExpO1 = Secao 1                                            ³±±
±±³          ³ ExpO2 = Secao 2                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MR910ImpS1(aSalAtu,nCusMed,cAliasTop,lVEIC,lCusUnif,oSection1,oSection2)

Local aArea := GetArea()

oSection1:Init()
oSection2:Init()

oSection1:Cell("nCusMed"):SetValue(nCusMed)
oSection1:Cell("nQtdSal"):SetValue(aSalAtu[1])
oSection1:Cell("nVlrSal"):SetValue(aSalAtu[mv_par11+1])			

#IFDEF TOP
	oSection1:Cell("cProduto"):SetValue((cAliasTop)->PRODUTO)			
	oSection1:Cell("cTipo"):SetValue((cAliasTop)->TIPO	)
	If lVEIC
		oSection2:Cell("cProduto"):SetValue((cAliasTop)->PRODUTO)			
		oSection2:Cell("cTipo"):SetValue((cAliasTop)->TIPO	)
	Endif
	
	dbSelectArea("SB2")
	dbSeek(xFilial("SB2")+(cAliasTop)->PRODUTO+If(lCusUnif,"",mv_par08))
#ELSE 
	oSection1:Cell("cProduto"):SetValue(SB1->B1_COD)			
	oSection1:Cell("cTipo"):SetValue(SB1->B1_TIPO)
	If lVEIC
		oSection2:Cell("cProduto"):SetValue(SB1->B1_COD)			
		oSection2:Cell("cTipo"):SetValue(SB1->B1_TIPO)
	Endif
#ENDIF

oSection1:PrintLine()
oSection2:PrintLine()

RestArea(aArea)

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR910IsMNT³ Autor ³ Lucas                ³ Data ³ 03.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se há integração com o modulo SigaMNT/NG          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR910                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTR910IsMNT()
Local aArea
Local aAreaSB1
Local cProdMNT	 := GetMv("MV_PRODMNT")
Local lIntegrMNT := .F.

cProdMNT := cProdMNT + Space(15-Len(cProdMNT))

If !Empty(cProdMNT)
	aArea	 := GetArea()
	aAreaSB1 := SB1->(GetArea())
	SB1->(dbSelectArea( "SB1" ))
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek( xFilial('SB1') + cProdMNT ))
		lIntegrMNT := .T.
	EndIf 
	RestArea(aAreaSB1)
	RestArea(aArea)
EndIf 
Return( lIntegrMNT )
