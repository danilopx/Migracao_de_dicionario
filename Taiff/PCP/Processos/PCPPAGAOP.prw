#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: PCPPAGOP                                    AUTOR: CARLOS ALDAY TORRES           DATA: 13/12/2010   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para apontar as OP's das etiquetas
//| SOLICITANTE: Humberto 
//+--------------------------------------------------------------------------------------------------------------
User Function PCPPAGOP()
	Local xSe1Alias	:= SC2->(GetArea())
	Local cAlias  := "SC2"
	Local cFiltra := "C2_FILIAL == '"+xFilial('SC2')+"' .And. C2_TPOP == 'F' .and. C2_SEQUEN='001' "

	Private cCadastro	:= "Apontamento de OP"
	Private aRotina  	:= {}
	Private aIndexSA2	:= {}
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

	AADD(aRotina,{"Pesquisar"		,"PesqBrw"			,0,1})
	AADD(aRotina,{"Legenda"			,"U_PCPLegenda"	,0,3})
	AADD(aRotina,{"Apontamento"	,"U_PCPFilhos"		,0,6})

	dbSelectArea(cAlias)

	dbSetOrder(1)
	Eval(bFiltraBrw)

	mBrowse(6,1,22,75,cAlias,,,,,,U_APCLegenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xSe1Alias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function APCLegenda(cAlias)

	Local aLegenda := { 	{"BR_VERDE"		, 	"OP não paga" 		},;
		{"BR_VERMELHO"	, 	"OP paga"	 		},;
		{"BR_CINZA"		,	"OP paga parcial"	}}
	Local uRetorno := .T.

	uRetorno := {}

	Aadd(uRetorno, { ' U_TotsDaOP(SC2->C2_NUM) = 1 ', aLegenda[3][1] } )
	Aadd(uRetorno, { ' U_TotsDaOP(SC2->C2_NUM) = 0 ', aLegenda[2][1] } )
	Aadd(uRetorno, { '.T.', aLegenda[1][1] } )

Return uRetorno

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function PCPLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		, 	"OP não paga" 		})
	AADD(aLegenda,{"BR_VERMELHO"	,	"OP paga" 			})
	AADD(aLegenda,{"BR_CINZA"		,	"OP paga parcial" })

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

//+-------------------------------------------
//|Função: Mostra as OP etiquetas da OP pai
//+-------------------------------------------
User Function PCPFilhos()
	Local xAlias	 	:= GetArea()
	Local nQtdABaixar	:= 0
	Local aParamBox	:= {}
	Local aRet			:= {}
	Local _nBxPercent	:= 0

	Private cCadastro := "Quantidade a pagar"

	If U_TotsDaOP( SC2->C2_NUM )=0
		Alert("Não há saldo disponivel para apontar!","Parâmetros de consulta")
	Else
		cQuery := "SELECT SC2.C2_DATPRI, SB1.B1_DESC, SC2.C2_QUANT "

		cQuery += "       ,  ("
		cQuery += "SELECT SUM(SD3.D3_QUANT) "
		cQuery += " FROM " + RetSqlName("SD3") + " SD3 "
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQuery += "     ON SD3.D3_COD=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
		cQuery += "   AND SB1.B1_TIPO = 'ET' "
		cQuery += "   AND SD3.D_E_L_E_T_ != '*' "
		cQuery += "   AND SD3.D3_TM IN ('03','01') "
		cQuery += "   AND SD3.D3_ESTORNO != 'S' "
		cQuery += "   AND SD3.D3_OP= SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN "
		cQuery += "       ) AS D3_QUANT "

		cQuery += "       	, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, "
		cQuery += "       SC2.C2_PRODUTO, SC2.C2_EMISSAO, SC2.C2_OBS  "
		cQuery += " FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQuery += "     ON SC2.C2_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += " WHERE SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		cQuery += "   AND SB1.B1_TIPO = 'ET' "
		cQuery += "   AND SC2.D_E_L_E_T_ != '*' "
		cQuery += "   AND SC2.C2_NUM='"+SC2->C2_NUM+"'"
		cQuery += " ORDER BY SC2.C2_QUANT DESC  "

		If Select("TMPOPS") > 0
			TMPOPS->(DbCloseArea())
		Endif

		TcQuery cQuery NEW ALIAS ("TMPOPS")

		DbSelectArea("TMPOPS")

		If TMPOPS->(Eof()) .and. TMPOPS->(Bof())
			Alert("Não há dados a consultar para os parâmetros !","Parâmetros de consulta")

		Else

			If ListaOps("TMPOPS", "LISTA OP's FIRMADAS") = 1

				TMPOPS->(DbGoTop())

				nQtdABaixar	:= U_Qt_a_Baixar( SC2->C2_NUM , SC2->C2_QUANT )

				Aadd(aParamBox,{1,"Quantidade"	,nQtdABaixar,"@R 999,999.99","","","",50,.T.})

				IF ParamBox(aParamBox,"Informe os Parametros",@aRet)

					If aRet[1] > TMPOPS->C2_QUANT .or. aRet[1] = 0
						Alert("Quantidade invalida!","Parâmetros de consulta")
					Else
						If aRet[1] < TMPOPS->C2_QUANT
							_nBxPercent := (aRet[1]*100)/TMPOPS->C2_QUANT
						Else
							_nBxPercent := 100
						Endif

						U_GrvAponta( SC2->C2_NUM , _nBxPercent/100 )
					Endif
				EndIf
			EndIf

		EndIf
	EndIf
	RestArea(xAlias)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ ListQry  ºAutor  ³Fabricio E. da Costaº Data ³  21/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibe tela com os registros da query.                       º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³   cQuery...: Instrução SQL a ser listada                   º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³   .........:                                               º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ListaOps(cAlias, cTitulo)
	Local bAddDados := ""
	Local nOpcA     := 0
	Local aCampoS   := {}
	Local oDlg1, oGDLst
	Local aButtons := {}
	Local i := 0

	//AADD( aButtons, {"PAP06", {|| nOpcA := 3, oDlg1:End() }, "Baixa das etiquetas da OP","Pagamento",{|| .T.}} )

	oDlg1                := tDialog():New()
	oDlg1:cName          := "oDlg1"
	oDlg1:cCaption       := cTitulo
	oDlg1:nLeft          := 001
	oDlg1:nTop           := 001
	oDlg1:nWidth         := 800 // 550
	oDlg1:nHeight        := 320
	oDlg1:nClrPane       := 16777215
	oDlg1:nStyle         := -2134376320
	oDlg1:bInit          := {|| EnchoiceBar(oDlg1, {|| nOpcA := 1, oDlg1:End() }, {|| nOpcA := 0, oDlg1:End()},,@aButtons )}
	oDlg1:lCentered      := .T.

	aHeader := MCriaHeader(cAlias, aCampoS)
	oGDLst  := MsNewGetDados():New(0, 0, 1, 1, ,,,,,,,,,, oDlg1, aHeader, {})
	oGDLst:aCols := {}
	oGDLst:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oGDLst:oBrowse:lAdjustColSize := .T.

	oGDLst:oBrowse:bLDblClick := {|z,x| , nOpcA := 1, oDlg1:End() }

	bAddDados := "{|| AAdd(oGDLst:aCols, {"
	For i := 1 To Len(oGDLst:aHeader)
		If oGDLst:aHeader[i,8] $ "N/D" //Acerta campos numericos e datas na query
			TCSetField(cAlias, oGDLst:aHeader[i,2], oGDLst:aHeader[i,8], oGDLst:aHeader[i,4],oGDLst:aHeader[i,5])
		EndIf
		bAddDados += oGDLst:aHeader[i,2] + ", "
	Next
	bAddDados += ".F.})}"

	bAddDados := &bAddDados.
	oGDLst:aCols := {}
	(cAlias)->(DbEval(bAddDados))

	oDlg1:Refresh()
	oDlg1:Activate()

	//(cAlias)->(DbClosearea())

Return (nOpcA)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CriaHeaderºAutor  ³Fabricio E. da Costaº Data ³  12/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria o aHeader que será utilizado pela NewGetDados.         º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³  cAlias...: Alias que sera criado o aHeader                º±±
±±º          ³  aCamposS.: Array contendo os campos do Alias a serem      º±±
±±º          ³             exibidos.                                      º±±
±±º          ³  aCamposN.: Array contendo os campos do Alias a serem      º±±
±±º          ³             suprimidos do Alias.                           º±±
±±º          ³  lCheck...: Indica se o grid terá checkbox (.T.Sim/.F.Não).º±±
±±º          ³  lRecno...: Indica se o grid terá Recno dos registros      º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³  aHeader..: aHeader contendo os campos do Alias            º±±
±±º          ³             especificado.                                  º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MCriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local aHeader := {}
	Local aCampos := {}
	Local i

	Default aCamposS := {}
	Default aCamposN := {}
	Default aCheck   := {}
	Default lRecno   := .F.

	For i := 1 To Len(aCheck)
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader), 01] := AllTrim(aCheck[i,1])
		aHeader[Len(aHeader), 02] := AllTrim(aCheck[i,2])
		aHeader[Len(aHeader), 03] := "@BMP"
		aHeader[Len(aHeader), 04] := 03
		aHeader[Len(aHeader), 05] := 00
		aHeader[Len(aHeader), 08] := "C"
		aHeader[Len(aHeader), 10] := "V"
		aHeader[Len(aHeader), 14] := "V"
	Next
	SX3->(DbSetOrder(2))
	//SX3->(DbSeek(cAlias))
	aCampos := (cAlias)->(DbStruct())
	For i := 1 To Len(aCampos)
		SX3->(DbSeek(aCampos[i,1]))
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. (aScan(aCamposS, AllTrim(SX3->X3_CAMPO)) > 0 .Or. Len(aCamposS) == 0) .And. (aScan(aCamposN, AllTrim(SX3->X3_CAMPO)) == 0 .Or. Len(aCamposN) == 0)
			Aadd(aHeader, {})
			If i=4
				Aadd(aHeader[Len(aHeader)], "Qtd.Apontada")
			Else
				Aadd(aHeader[Len(aHeader)], AllTrim(SX3->X3_TITULO))
			Endif
			Aadd(aHeader[Len(aHeader)], AllTrim(SX3->X3_CAMPO))
			Aadd(aHeader[Len(aHeader)], SX3->X3_PICTURE)
			Aadd(aHeader[Len(aHeader)], SX3->X3_TAMANHO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_DECIMAL)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VALID)
			Aadd(aHeader[Len(aHeader)], SX3->X3_USADO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_TIPO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_F3)
			Aadd(aHeader[Len(aHeader)], SX3->X3_CONTEXT)
			Aadd(aHeader[Len(aHeader)], SX3->X3_CBOX)
			Aadd(aHeader[Len(aHeader)], SX3->X3_RELACAO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_WHEN)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VISUAL)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VLDUSER)
			Aadd(aHeader[Len(aHeader)], SX3->X3_PICTVAR)
			Aadd(aHeader[Len(aHeader)], X3Obrigat(SX3->X3_CAMPO))
		EndIf
		//SX3->(DbSkip())
	Next
	If lRecno
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader),01] := "RECNO"
		aHeader[Len(aHeader),02] := "R_E_C_N_O_"
		aHeader[Len(aHeader),03] := "99999999999"
		aHeader[Len(aHeader),04] := 10
		aHeader[Len(aHeader),05] := 00
		aHeader[Len(aHeader),08] := "N"
		aHeader[Len(aHeader),10] := "V"
		aHeader[Len(aHeader),14] := "V"
	EndIf

Return aClone(aHeader)

//+-------------------------------------------
//|Função: Verique flag de se já apontou total ou parcial
//+-------------------------------------------
User Function TotsDaOP( _cNumDaOP )
	Local nRetorno		:= 0
	Local nQtdTotOP	:= 0
	Local nApoTotOP	:= 0

	cQuery := "SELECT SUM(SC2.C2_QUANT) AS TOT_QUANT "
	cQuery += " FROM " + RetSqlName("SC2") + " SC2 "
	cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "     ON SC2.C2_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " WHERE SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
	cQuery += "   AND SB1.B1_TIPO = 'ET' "
	cQuery += "   AND SC2.D_E_L_E_T_ != '*' "
	cQuery += "   AND SC2.C2_NUM='"+_cNumDaOP+"'"

	If Select("TMPOPS") > 0
		TMPOPS->(DbCloseArea())
	Endif

	TcQuery cQuery NEW ALIAS ("TMPOPS")

	DbSelectArea("TMPOPS")

	If TMPOPS->(Eof()) .and. TMPOPS->(Bof())
		nQtdTotOP := 0
	Else
		nQtdTotOP := TMPOPS->TOT_QUANT
	Endif


	cQuery := "SELECT SUM(SD3.D3_QUANT) AS APO_QUANT "
	cQuery += " FROM " + RetSqlName("SD3") + " SD3 "
	cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "     ON SD3.D3_COD=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
	cQuery += "   AND SB1.B1_TIPO = 'ET' "
	cQuery += "   AND SD3.D_E_L_E_T_ != '*' "
	cQuery += "   AND SD3.D3_TM IN ('03','01') "
	cQuery += "   AND SD3.D3_ESTORNO != 'S' "
	cQuery += "   AND LEFT(SD3.D3_OP,6)='"+_cNumDaOP+"'"

	If Select("TMPOPS") > 0
		TMPOPS->(DbCloseArea())
	Endif

	TcQuery cQuery NEW ALIAS ("TMPOPS")

	DbSelectArea("TMPOPS")

	If TMPOPS->(Eof()) .and. TMPOPS->(Bof())
		nApoTotOP	:= 0
	Else
		nApoTotOP	:= TMPOPS->APO_QUANT
	Endif

	TMPOPS->(DbCloseArea())
	If nQtdTotOP=nApoTotOP .and. nApoTotOP!=0
		nRetorno := 0 // Pagamento total
	ElseIf nQtdTotOP > nApoTotOP .and. nApoTotOP!=0
		nRetorno := 1 // Pagamento parcial
	Else
		nRetorno := 3 // OP nao firmada
	Endif
Return (nRetorno)

//+-------------------------------------------
//|Função: Grava o apontamento na SD3
//+-------------------------------------------
User Function GrvAponta( _cOP_Pai , _nPerBase )
	Local aDados 		:= {}
	Local _cOp_Filho	:= ""
	Local xSc2Alias	:= SC2->(GetArea())
	Local cQuery		:= ""

EndFilBrw("SC2",aIndexSA2)

cQuery := "SELECT SC2.C2_QUANT, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, "
cQuery += "       SC2.C2_PRODUTO  "
cQuery += " FROM " + RetSqlName("SC2") + " SC2 "
cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
cQuery += "     ON SC2.C2_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += " WHERE SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
cQuery += "   AND SB1.B1_TIPO = 'ET' "
cQuery += "   AND SC2.D_E_L_E_T_ != '*' "
cQuery += "   AND SC2.C2_NUM='"+_cOP_Pai+"'"

If Select("PAGOPS") > 0
	PAGOPS->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("PAGOPS")

DbSelectArea("PAGOPS")

SC2->(DbSetOrder(1))

While !PAGOPS->(EOF())
	// A begin transaction foi comentada para que o ponto de entrada A250ETRAN() seja executado sem interferencia
	//Begin Transaction
	_cOp_Filho := Alltrim(PAGOPS->C2_NUM + PAGOPS->C2_ITEM + PAGOPS->C2_SEQUEN)

	lMsErroAuto := .F.
	aDados := {	{"D3_TM"			, "03"								, Nil},;
		{"D3_OP"			, _cOp_Filho						, Nil},;
		{"D3_COD"		, PAGOPS->C2_PRODUTO				, Nil},;
		{"D3_QUANT"		, PAGOPS->C2_QUANT*_nPerBase	, Nil},;
		{"D3_EMISSAO"	, dDatabase							, Nil}}
	MsExecAuto({|X,Y| MATA250(X,Y)}, aDados, 3)
	If lMsErroAuto
		MostraErro()
	Endif
	//End Transaction
	PAGOPS->(DbSkip())
End
SC2->(RestArea(xSc2Alias))
Eval(bFiltraBrw)
Return

//+-------------------------------------------
//|Função: Busca saldo a baixar da OP das etiquetas
//+-------------------------------------------
User Function Qt_a_Baixar( _cOP_Pai , _nQt_Pai )
	Local cQuery		:= ""
	Local _cOp_Filho	:= ""
	Local _nSld_Op		:= 000

//
// Query para buscar as OP's filho que tenham a mesma quantidade de produção
// Pelo menos uma das etiquetas, haverá sempre a mesma proporção de etiqueta e produto a produzir
//
	cQuery := "SELECT SC2.C2_QUANT, SC2.C2_NUM, SC2.C2_ITEM, SC2.C2_SEQUEN, "
	cQuery += "       SC2.C2_PRODUTO  "
	cQuery += " FROM " + RetSqlName("SC2") + " SC2 "
	cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
	cQuery += "     ON SC2.C2_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " WHERE SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
	cQuery += "   AND SB1.B1_TIPO = 'ET' "
	cQuery += "   AND SC2.D_E_L_E_T_ != '*' "
	cQuery += "   AND SC2.C2_NUM='"+_cOP_Pai+"'"
	cQuery += "   AND SC2.C2_QUANT= '"+Alltrim(Str(_nQt_Pai))+"'"

	If Select("SUNOPS") > 0
		SUNOPS->(DbCloseArea())
	Endif

	TcQuery cQuery NEW ALIAS ("SUNOPS")

	DbSelectArea("SUNOPS")

	If SUNOPS->(Eof()) .and. SUNOPS->(Bof())
		_nSld_Op := 000
	Else
		_cOP_Filho	:= SUNOPS->(C2_NUM + C2_ITEM + C2_SEQUEN)

		//
		// Query para verificar quanto foi apontado para a OP filho
		//
		cQuery := "SELECT SUM(SD3.D3_QUANT) AS APO_QUANT "
		cQuery += " FROM " + RetSqlName("SD3") + " SD3 "
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQuery += "     ON SD3.D3_COD=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
		cQuery += "   AND SB1.B1_TIPO = 'ET' "
		cQuery += "   AND SD3.D_E_L_E_T_ != '*' "
		cQuery += "   AND SD3.D3_TM IN ('03','01') "
		cQuery += "   AND SD3.D3_ESTORNO != 'S' "
		cQuery += "   AND SD3.D3_OP='"+_cOP_Filho+"'"

		If Select("SUNAPO") > 0
			SUNAPO->(DbCloseArea())
		Endif

		TcQuery cQuery NEW ALIAS ("SUNAPO")

		DbSelectArea("SUNAPO")

		_nSld_Op:= SUNOPS->C2_QUANT - SUNAPO->APO_QUANT

		SUNAPO->(DbCloseArea())
	Endif
	SUNOPS->(DbCloseArea())

Return ( _nSld_Op )
