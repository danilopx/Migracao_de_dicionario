
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ TFFAT001 ณ Autor ณ Rodrigo Brito         ณ Data ณ 10/09/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cadastro de regras de comissใo                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Faturamento                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ GAP  ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRodrigo     ณ10/09/10ณ      ณ Implementa็ใo                            ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TFFAT001()
	Private cCadastro := "Cadastro de Regras de Comissใo"
	Private cPerg     := "TFFAT001" 
	Private aRotina   := MenuDef()
	
	DbSelectArea("ZAA")
	DbSetOrder(1)      // ZAA_FILIAL+ZAA_CLIENT+ZAA_LOJA+ZAA_SUBCAN+ZAA_VEND+ZAA_GER                                                                                                      
	mBrowse(06, 01, 22, 75, "ZAA")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณTFFAT01M  ณ Autor ณ Rodrigo Brito         ณ Data ณ 09/10/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณEfetua todas as manuten็๕es referentes ao cadastro de       ณฑฑ
ฑฑณ          ณcomiss๕es                                                   ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ TFFAT001                                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณProgramador ณ Data   ณ GAP  ณ  Motivo da Alteracao                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRodrigo     ณ10/09/10ณ      ณImplementar                               ณฑฑ
ฑฑณ            ณ        ณ      ณ                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TFFAT01M(cAlias, nReg, nOpc)
	Local cTitulo    := ""
	Local nGDOpcZAB  := GD_UPDATE+GD_INSERT+GD_DELETE
	Local nOpcE      := 0
	Local aTela      := {}
	Local aObjects   := {}
	Local aPanTotal  := {}
	Local aCampoZABN := {}
	
	Private oDlg, oMsmGetCab, oFolder1, oGDZAB
	Private nPosProd, nPosCateg, nPosDel

	nGDOpcZAB := Iif(nOpc == 2, 0, nGDOpcZAB)
	
	cTitulo := Iif(nOpc == 2, "Visualiza็ใo do layout", cTitulo)
	cTitulo := Iif(nOpc == 3, "Inclusใo de layout",     cTitulo)
	cTitulo := Iif(nOpc == 4, "Altera็ใo de layout",    cTitulo)
	cTitulo := Iif(nOpc == 5, "Exclusใo de layout",     cTitulo)
	
	aTela := MsAdvSize(.T.)  // Pega as coordenadas maximas da tela
	aTela := { aTela[1]+4, aTela[2]+13, aTela[5], aTela[6]-5}  // contem X1,Y1 e X2,Y2 descontando as margens para nao colocar nas bordas

	aAdd(aObjects, {"V", 020} )
	aAdd(aObjects, {"V", 080} )
	aPanTotal := DivideTela(aTela, aObjects)
	
	oDlg                := tDialog():New()
	oDlg:cName          := "oDlg"
	oDlg:cCaption       := cTitulo
	oDlg:nLeft          := aTela[1]
	oDlg:nTop           := aTela[2] 	
	oDlg:nWidth         := aTela[3] - aTela[1]		// Largura da Tela
	oDlg:nHeight        := aTela[4] - aTela[2] + 70 // Altura da Tela
	oDlg:nClrPane       := 16777215
	oDlg:nStyle         := -2134376320
	oDlg:bInit          := {|| EnchoiceBar(oDlg, {|| nOpcE := 1, Iif(GravaDados(nOpc), oDlg:End(), Nil)}, {|| nOpcE := 0, oDlg:End()}) }
	oDlg:lCentered      := .T.
	
	RegToMemory("ZAA", nOpc == 3)  // Cria as variแveis de mem๓ria para edi็ใo, sem essa fun็ใo a MsmGet nใo irแ funcionar

	oMsmGetCab := MsmGet():New("ZAA", nReg, nOpc, Nil, Nil, Nil, Nil, aPanTotal[1], Nil, Nil, Nil, Nil, Nil, oDlg)
	oMsmGetCab:oBox:nTop    := aPanTotal[1,2] + 18
	oMsmGetCab:oBox:nLeft   := aPanTotal[1,1]
	oMsmGetCab:oBox:nWidth  := aPanTotal[1,3] - aPanTotal[1,1]
	oMsmGetCab:oBox:nHeight := aPanTotal[1,4] - aPanTotal[1,2] + 15
	oMsmGetCab:lActive      := nOpc == 3 .Or. nOpc == 4 //S๓ estarแ habilitada se a opc็ใo for inclusใo ou altera็ใo
	//oMsmGetCab:aEntryCtrls[aScan(oMsmGetCab:aGets, {|x| "ZZI_TABELA" $ x})]:bValid := {|| LoadSx("SX3", M->ZZI_TABELA)}
	//oMsmGetCab:aEntryCtrls[aScan(oMsmGetCab:aGets, {|x| "ZZI_FILTRO" $ x})]:bF3 := {|| M->ZZI_FILTRO := PadR(Iif(!Empty(M->ZZI_TABELA), BuildExpr(M->ZZI_TABELA), M->ZZI_FILTRO), Len(M->ZZI_FILTRO))}

	oFolder1 := TFolder():New (0, 0, , , oDlg)
	oFolder1:nTop     := aPanTotal[2,2] + 33
	oFolder1:nLeft    := aPanTotal[2,1]
	oFolder1:nHeight  := aPanTotal[2,4] - aPanTotal[2,2] - 35
	oFolder1:nWidth   := aPanTotal[2,3] - aPanTotal[2,1] 	
	oFolder1:AddItem("Itens", .T. )
	//oFolder1:AddItem("Configura็ใo", .T. )
	oFolder1:SetOption(1)
	//oFolder1:bChange := {|| GeraItem() }
	
	aCampoZABN := {"ZAB_FILIAL","ZAB_CODIGO"}
	aHeaderZAB  := CriaHeader("ZAB", , aCampoZABN) 
	oGDZAB := MsNewGetDados():New(0, 0, 1, 1, nGDOpcZAB,,,,,,,,,, oFolder1:aDialogs[1], aHeaderZAB, {})
	//oGDZAB:aCols := {}
	oGDZAB:nMax  := 300
	oGDZAB:oBrowse:nTop       := 01
	oGDZAB:oBrowse:nLeft      := 01
	oGDZAB:oBrowse:nHeight    := aPanTotal[2,4] - aPanTotal[2,2] - 90
	oGDZAB:oBrowse:nWidth     := aPanTotal[2,3] - aPanTotal[2,1] - 15
	oGDZAB:bLinhaOk           := {|| VldLinha()}
	oGDZAB:oBrowse:lColDrag   := .T.
	oGDZAB:oBrowse:lAdjustColSize := .T.
	               
	
	nPosProd  := GdFieldPos("ZAB_PROD",  oGDZAB:aHeader)	
	nPosCateg := GdFieldPos("ZAB_CATEG", oGDZAB:aHeader)
	nPosDel   := GdFieldPos("GDDELETED", oGDZAB:aHeader)
	
	//oGDZAB:bLinhaOk := {|| VldLinha()}

	If nOpc <> 3         // <> de inclusใo
		LoadZAB(oGDZAB)
	EndIf
		
	oDlg:Activate()

Return

Static Function HeaderClick(oBrw, nCol, aDim)
	Local nPosChk01 := 0
	
	Static lExec   := .T.	
	
	If lExec
		nPosChk01 := GdFieldPos("_CHK01", oGdSx3:aHeader)
		If nCol == nPosChk01
			MarcaTodos()
		ElseIf nCol > 2
			aSort(oGdSx3:aCols, , , {|x,y| x[nCol] < y[nCol]})
			oGdSx3:oBrowse:Refresh()
		EndIf
	EndIf
	lExec := !lExec
Return

Static Procedure MarcaTodos()
	Static lSelect := .T.
	
	aEval(oGDSx3:aCols, {|aItem, nIndex| aItem[1] := Iif(aItem[2] == 'BR_VERMELHO' .Or. lSelect, 'LBTIK', 'LBNO')})
	oGDSx3:oBrowse:Refresh()
	lSelect := !lSelect
	
Return

Static Function VldLinha()
	Local lRet      := .T.
	Local lExiste   := .F.	
	
	aEval(oGDZAB:aCols, {|aItem, nIndex| lExiste := (!aItem[nPosDel] .And. nIndex <> oGDZAB:nAt .And. aItem[nPosProd]+aItem[nPosCateg] == oGDZAB:aCols[oGDZAB:nAt,nPosProd] + oGDZAB:aCols[oGDZAB:nAt,nPosCateg]) .Or. lExiste}) // Verifica se o item jแ existe
	
	/* Pode substituir a fun็ใo aEval
	For i := 1 To Len(oGDZAB:aCols)
		If i <> oGDZAB:nAt
			lExiste := (!oGDZAB:aCols[i,nPosDel] .And. oGDZAB:aCols[i,nPosProd] == oGDZAB:aCols[oGDZAB:nAt,nPosProd]) .Or. lExiste
		EndIf
	Next
	*/
	lRet := !lExiste
	If lExiste
		MsgAlert("Linha jแ cadastrada", "Cadastro de Regras de Comissใo")
	EndIf
	
Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณLoadZAB   บAutor  ณRodrigo Brito       บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o grid com os itens de comissใo.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  oGetDados: Objeto NewGetDados que irแ receber os resgitrosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   Nil                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LoadZAB(oGetDados)
	Local cSql    := ""
	Local cCampos := ""
	
	aEval(oGetDados:aHeader, {|aItem| cCampos += Iif(Left(aItem[2],4) $ "_CHK/_LEG", "", aItem[2] + ", ")}, 1, Len(oGetDados:aHeader) - 1) // gera a lista de campos da select
	cCampos += aTail(oGetDados:aHeader)[2]
	cSql := "SELECT "
	cSql += "  " + cCampos + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("ZAB") + " "
	cSql += "WHERE "
	cSql += "  D_E_L_E_T_ = ' ' "
	cSql += "  AND ZAB_FILIAL  = '" + xFilial("ZAB") + "' "
	cSql += "  AND ZAB_CODIGO  = '" + ZAA->ZAA_CODIGO + "' "
	Load_Grid(cSql, oGetDados)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGravaDadosบAutor  ณRodrigo Brito       บ Data ณ  10/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados nas tabelas ZAA e ZAB.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   .........:                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIN002M                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GravaDados(nOpc)
	
	If nOpc <> 2  // Se nใo for visualizar	  
	  If INCLUI .Or. ALTERA
		  If !Obrigatorio(oMsmGetCab:aGets, oMsmGetCab:aTela)
		  	Return .F.
		  ElseIf !Existchav("ZAA", M->ZAA_CLIENT + M->ZAA_LOJA + M->ZAA_GRPCLI + M->ZAA_SUBCAN + M->ZAA_VEND + M->ZAA_GER, 1)  
				Return .F.
		  EndIf
		EndIf
		Begin Transaction
			GrvEnch(oMsmGetCab, 1, M->ZAA_CLIENT + M->ZAA_LOJA + M->ZAA_GRPCLI + M->ZAA_SUBCAN + M->ZAA_VEND + M->ZAA_GER)
			//GeraItem()
			//GravaItem()
			GrvGetD(oGDZAB, "ZAB", {"ZAB_FILIAL", "ZAB_CODIGO", "ZAB_PROD", "ZAB_CATEG", "ZAB_PERC"})
			ConfirmSX8()
		End Transaction
	EndIf		
Return .T.    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetComis  บAutor  ณRodrigo Brito       บ Data ณ  15/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna percentual de comissใo com base nos dados do pedido บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   .........:                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetComis(cCodCli, cLoja, cVend, cProdut)
	Local cSql    := ""
	Local nPerc   := 0                            
	Local cCateg  := ""
	Local cAlias  := Alias()
	Local aAreaC6 := SC6->(GetArea())
	Local lOkComissao := .T.
	
	Default cCodCli := CriaVar("C5_CLIENT",.F.)
	Default cLoja   := CriaVar("C5_LOJACLI",.F.)
	Default cVend   := CriaVar("C5_VEND1",.F.)	
	Default cProdut := CriaVar("C6_PRODUTO",.F.)	          

	If SC5->(FieldPos("C5_XITEMC"))!=0
		If Alltrim(M->C5_XITEMC) != 'TAIFF'
			lOkComissao := .F.
		EndIf
	EndIf
	If lOkComissao
	
		  	ACV->(DbSetOrder(5))
	  		ACV->(DbSeek(xFilial("ACV") + cProdut))
	  		//ACV->(DbSeek(cProdut))
//				cCodCli := M->C5_CLIENT
//				cLoja   := M->C5_LOJACLI
//				cVend   := M->C5_VEND1 
//				cProdut := M->C6_PRODUTO
				cCateg  := ACV->ACV_CATEGO
	
				cSql := "SELECT '01' TPREG, ZAA_CODIGO, ZAA_PERC "
				cSql += "FROM ZAA010 " // + RetSqlName("ZAA") + "  "
				cSql += "WHERE "
				cSql += "  D_E_L_E_T_ = ' ' "
//				cSql += "  AND ZAA_FILIAL = '" + xFilial("ZAA") + "' " 
				cSql += "  AND ZAA_CLIENT = '" + cCodCli + "' "
				cSql += "  AND ZAA_LOJA   = '" + cLoja + "' "
			
//				cSql += "UNION ALL "
			
//				cSql += "SELECT '02' TPREG, ZAA_CODIGO, ZAA_PERC "
//				cSql += "FROM "
//				cSql += "  " + RetSqlName("ZAA") + " ZAA JOIN " + RetSqlName("SA1") + " SA1 ON  "
//				cSql += "    ZAA.D_E_L_E_T_ = ' ' AND "
//				cSql += "    SA1.D_E_L_E_T_ = ' ' AND "
//				cSql += "    ZAA.ZAA_FILIAL = '" + xFilial("ZAA") + "' AND " 
//				cSql += "    SA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND " 
//				cSql += "    ZAA_GRPCLI     = A1_GRPVEN "
//				cSql += "WHERE "
//				cSql += "  A1_COD      = '" + cCodCli + "' "
//				cSql += "  AND A1_LOJA = '" + cLoja   + "' "                 
			
//				cSql += "UNION ALL "
			
//				cSql += "SELECT '03' TPREG, ZAA_CODIGO, ZAA_PERC "
//				cSql += "FROM "
//				cSql += "  " + RetSqlName("ZAA") + " ZAA JOIN " + RetSqlName("SA1") + " SA1 ON  "
//				cSql += "    ZAA.D_E_L_E_T_ = ' ' AND "
//				cSql += "    SA1.D_E_L_E_T_ = ' ' AND "
//				cSql += "    ZAA.ZAA_FILIAL = '" + xFilial("ZAA") + "' AND " 
//				cSql += "    SA1.A1_FILIAL  = '" + xFilial("SA1") + "' AND " 
//				cSql += "    ZAA.ZAA_SUBCAN = A1_SUBCAN "
//				cSql += "WHERE "
//				cSql += "  A1_COD      = '" + cCodCli + "' "
//				cSql += "  AND A1_LOJA = '" + cLoja   + "' "
			
				cSql += "UNION ALL "
			
				cSql += "SELECT '04' TPREG, ZAA_CODIGO, ZAA_PERC "
				cSql += "FROM ZAA010 " // + RetSqlName("ZAA") + "  "
				cSql += "WHERE "
				cSql += "  D_E_L_E_T_     = ' ' "
				//cSql += "  AND ZAA_FILIAL = '" + xFilial("ZAA") + "' " 
				cSql += "  AND ZAA_VEND   = '" + cVend + "' "
				
//	  		cSql += "UNION ALL "
			
//				cSql += "SELECT '05' TPREG, ZAA_CODIGO, ZAA_PERC "
//				cSql += "FROM "
//				cSql += "  " + RetSqlName("ZAA") + " ZAA JOIN " + RetSqlName("SA3") + " SA3 ON  " 
//				cSql += "    ZAA.D_E_L_E_T_ = ' ' AND "
//				cSql += "    SA3.D_E_L_E_T_ = ' ' AND "
//				cSql += "    ZAA.ZAA_FILIAL = '" + xFilial("ZAA") + "' AND " 
//				cSql += "    SA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND " 
//				cSql += "    ZAA.ZAA_GER    = SA3.A3_GEREN "
//				cSql += "WHERE "
//				cSql += "  A3_COD = '" + cVend + "' "	
//				cSql += "ORDER BY TPREG "
			  If Select("TMPZAA")>0
				   TMPZAA->(DbCloseArea())
			  EndIf
				TCQuery cSql NEW ALIAS "TMPZAA"
				
				If !TMPZAA->(EOF()) .And. !TMPZAA->(BOF())
					nPerc := TMPZAA->ZAA_PERC
					cSql := "SELECT '01' TPREG, ZAB_PERC, 0 NIVEL "
					cSql += "FROM ZAB010 ZAB " 
				 //	cSql += "  " + RetSqlName("ZAB") + " ZAB "
					cSql += "WHERE "
					cSql += "  ZAB.D_E_L_E_T_     = ' ' "
				//	cSql += "  AND ZAB.ZAB_FILIAL = '" + xFilial("ZAB") + "' "
					cSql += "  AND ZAB_PROD       = '" + cProdut + "' "
					cSql += "  AND ZAB_CODIGO     = '" + TMPZAA->ZAA_CODIGO + "' "
					cSql += "UNION ALL "
					cSql += "SELECT '02' TPREG, ZAB_PERC, ACU.NIVEL "
					cSql += "FROM ZAB010 ZAB JOIN "
//					cSql += "  " + RetSqlName("ZAB") + " ZAB JOIN"   
					If AllTrim(cCateg) == ""
						cSql += " RET_ACU('0') ACU ON "		
					Else
						cSql += " RET_ACU('" + cCateg + "') ACU ON "
					EndIf
					cSql += "    ZAB.D_E_L_E_T_     = ' ' "
				 //	cSql += "    AND ZAB.ZAB_FILIAL = '" + xFilial("ZAB") + "' "
					cSql += "    AND ACU.ACU_COD    = ZAB.ZAB_CATEG "
					cSql += "WHERE "
					cSql += "  ZAB_CODIGO     = '" + TMPZAA->ZAA_CODIGO + "' "
					cSql += "ORDER BY " 
					cSql += "  TPREG, NIVEL "
				   
				
				  If Select("TMPZAB")>0
				   TMPZAB->(DbCloseArea())                           
			    EndIf
					TCQuery cSql NEW ALIAS "TMPZAB"
					If !TMPZAB->(EOF()) .And. !TMPZAB->(BOF())
						nPerc := TMPZAB->ZAB_PERC
					EndIf
				EndIf
				
	EndIf   
DbSelectArea(cAlias)
SC6->(RestArea(aAreaC6))
Return nPerc

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProcedure ณLoad_Grid บAutor  ณFabricio E. da Costaบ Data ณ  11/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega o grid passado em oGetDados, com os registros       บฑฑ
ฑฑบ          ณretornados pela query passada em cSql.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  cSql.....: Query que retorna os registros para o grid     บฑฑ
ฑฑบ          ณ  oGetDados: Objeto NewGetDados que ira receber os resgitrosบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   Nil                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Procedure Load_Grid(cSql, oGetDados, aCheck, aLegenda)
	Local cAction   := ""
	Local cMultSel  := ""
	Local cSingSel  := ""
	Local cCont     := ""
	Local cSx       := ""
	Local cAlias    := ""
	Local bAddDados := "{|| AAdd(oGetDados:aCols, {"
	Local lIsSx     := .F.
	Local nPosChk   := 0
	Local i
	
	Default aCheck   := {}
	Default aLegenda := {}
	
	lIsSx  := Left(cSql,2) == "SX"
	cSx    := Left(cSql,3)
	cAlias := SubStr(cSql, 5, 3)
	
	If !lIsSx
		TCQuery cSql NEW ALIAS "TMP1"
	EndIf
	
	For i := 1 To Len(oGetDados:aHeader)
		If "_CHK" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aCheck[nPosChk, 2] + ", "
		ElseIf "_LEG" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "
		Else
			If !lIsSx .And. oGetDados:aHeader[i,8] $ "N/D" // Acerta campos numericos e datas na query
				TCSetField("TMP1", oGetDados:aHeader[i,2], oGetDados:aHeader[i,8], oGetDados:aHeader[i,4],oGetDados:aHeader[i,5])
			EndIf
			bAddDados += oGetDados:aHeader[i,2] + ", "
		EndIf
	Next	
	bAddDados += ".F.})}"
	                                        
	If lIsSx
		bAddDados := &bAddDados.
		oGetDados:aCols := {}	
		(cSx)->(DbEval(bAddDados, {|| X3_ARQUIVO == cAlias .And. X3Uso(X3_USADO) .And. X3_CONTEXT <> "V" }))
	Else
		bAddDados := &bAddDados.
		oGetDados:aCols := {}	
		TMP1->(DbEval(bAddDados))
		TMP1->(DbCloseArea())
	EndIf

	// Define a a็ใo lDblClick da getdados para marcar e desmarcar os checkboxs
	For i := 1 To Len(aCheck)
		nPosChk  := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
		cMultSel += Iif(aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
		cSingSel += Iif(!aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
	Next
	cMultSel := Iif(Empty(cMultSel), "*", cMultSel)
	cSingSel := Iif(Empty(cSingSel), "*", cSingSel)
	
	cBloco  := "{|aItem| oGetDados:aCols[nItem,oGetDados:oBrowse:nColPos] := Iif(nItem == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO'), nItem++}"
	cInicio := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1)"
	cCont   := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', 1, Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cSingSel + "', Len(oGetDados:aCols), 0))"
	cAction := "nItem := Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1), aEval(oGetDados:aCols, " + cBloco + ", " + cInicio + ", " + cCont + "), oGetDados:oBrowse:Refresh()"
	
	//cAction := "oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] := Iif('_CHK' $ oGetDados:aHeader[oGetDados:oBrowse:nColPos,2], Iif(oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'),oGetDados:aCols[oGetDados:nAt,oGetDados:oBrowse:nColPos])"
	If Len(aCheck) > 0 .And. Len(oGetDados:aCols) > 0 .And. At(Upper(cAction), GetCbSource(oGetDados:oBrowse:bLDblClick)) == 0
		oGetDados:oBrowse:bLDblClick := &(BAddExp(oGetDados:oBrowse:bLDblClick, cAction, 0))
	EndIf
	oGetDados:oBrowse:Refresh()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGrvEnch   บAutor  ณFabricio E. da Costaบ Data ณ  09/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os campos da MsmGet na tabela referente.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ   oMsmGet..: Objeto MsmGet a ser gravado.                  บฑฑ
ฑฑบ          ณ   nOrdem...: Ordem a ser verificada a exist๊ncia do resgitroฑฑ
ฑฑบ          ณ   cChave...: Valor chave a ser verificado.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   .........:                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Procedure GrvEnch(oMsmGet, nOrdem, cChave)
	Local cCpoFil  := ""
	Local i        := 0
	Local lAchou   := .F.
	Local aArea   := GetArea()
	Local bcampo := {|nfield| field(nfield) } 
	
	cCpoFil := Right(oMsmGet:cAlias, Iif(Left(oMsmGet:cAlias,1) == "S", 2, 3)) + "_FILIAL"
	DbSelectArea(oMsmGet:cAlias)
	DbSetOrder(nOrdem)
	
	lAchou := DbSeek(xFilial(oMsmGet:cAlias) + cChave)
	Begin Transaction
		RecLock(oMsmGet:cAlias, !lAchou)
		If Inclui .Or. Altera
			For i := 1 To Len(oMsmGet:aGets) + 1
				if "FILIAL" $ fieldname(i)
 					Fieldput(i,xfilial(oMsmGet:cAlias))
 				else
					Fieldput(i,M->&(EVAL(BCAMPO,i)))
				EndIf
			Next
		Else  // exclusao
			DbDelete()
		EndIf
		MsUnlock()
	End Transaction
	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGrvGetD   บAutor  ณFabricio E. da Costaบ Data ณ  15/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os campos da MsmGet na tabela referente.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ   oGetDados: Objeto MsmGet a ser gravado.                  บฑฑ
ฑฑบ          ณ   cAlias...: Alias a ser gravado os dados do grid          บฑฑ
ฑฑบ          ณ   aChave...: Array com os campos chave para o alias a ser  บฑฑ
ฑฑบ          ณ              gravado.                                      บฑฑ
ฑฑบ          ณ   aCamposN.: Campos que nใo serใo gravados                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ   .........:                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvGetD(oGetDados, cAlias, aChave, aCamposN)
	Local bChave   := ""
	Local lAchou   := .F.
	Local nPosCol  := 0
	Local nPosCpo  := 0
	Local nPosDel  := 0
	Local aArea    := GetArea()
	Local i, j
	
	Default aCamposN := {}
	
	nPosDel := GdFieldPos("GDDELETED", oGetDados:aHeader)
	// Cria codeblock com os campos chave a serem pesquisados na grava็ใo de cada linha do grid
	bChave  := "{|| {"
	If Right(aChave[1], 6) <> "FILIAL"
		nPosCol := aScan(oGetDados:aHeader, {|aItem| AllTrim(aItem[2]) == aChave[1]})
		bChave += Iif(nPosCol > 0, "oGetDados:aCols[i," + StrZero(nPosCol,3) + "]", "CriaVar('" + aChave[1] + "', .T.)")
	Else
		bChave += "xFilial('" + cAlias + "')"
	EndIf
	For i := 2 To Len(aChave)
		nPosCol := aScan(oGetDados:aHeader, {|aItem| AllTrim(aItem[2]) == aChave[i]})
		bChave  += Iif(nPosCol > 0, ", oGetDados:aCols[i," + StrZero(nPosCol,3) + "]", ", CriaVar('" + aChave[i] + "', .T.)")
	Next
	bChave += "} }"
	bChave := &bChave.

	DbSelectArea(cAlias)
	Begin Transaction
		For i := 1 To Len(oGetDados:aCols)
			lAchou := SeekChave(cAlias, aChave, Eval(bChave))
			If !oGetDados:aCols[i, nPosDel] .Or. lAchou
				RecLock(cAlias, !lAchou)
				If (Inclui .Or. Altera) .And. !oGetDados:aCols[i, nPosDel]
					For j := 1 To Fcount()
						cNomeCpo := AllTrim(FieldName(j))
						nPosCpo  := GdFieldPos(cNomeCpo, oGetDados:aHeader)
						If aScan(aCamposN, AllTrim(cNomeCpo)) == 0
							If Right(cNomeCpo,6) <> "FILIAL"
								If nPosCpo > 0
									If Empty(oGetDados:aHeader[nPosCpo,11]) //Testa se eh combo
										FieldPut(j, oGetDados:aCols[i,nPosCpo])
									Else
										FieldPut(j, Left(oGetDados:aCols[i,nPosCpo],1))
									EndIf
								Else
									FieldPut(j, CriaVar(cNomeCpo, .T.))
								EndIf
							Else
								FieldPut(j, xFilial(cAlias))
							EndIf
						EndIf
					Next
				Else  // exclusao
					DbDelete()
				EndIf
				MsUnlock()
			EndIf
		Next
	End Transaction
	RestArea(aArea)
	
Return Nil

Static Function SeekChave(cAlias, aChave, aValores, lPosiciona)
	Local aInfCpo := {}
	Local cSql    := "" 
	Local lAchou  := .F.
	Local i
	
	Default lPosiciona := .T.
	
	cSql := "SELECT R_E_C_N_O_ NRECNO "
	cSql += "FROM " + RetSqlName(cAlias) + " "
	cSql += "WHERE "
	If Set(11)
		cSql += "  D_E_L_E_T_ = ' ' AND "
	EndIf
	For i := 1 To Len(aChave)
		cSql += aChave[i] + " = "
		aInfCpo := TamSX3(aChave[i])
		If aInfCpo[3] $ "C/D"
			cSql += "'" + aValores[i] + "'"
		Else
			cSql += Str(aValores[i], aInfCpo[1], aInfCpo[2])
		EndIf
		cSql += Iif(i < Len(aChave), " AND ", "")
	Next
	TcQuery cSql New Alias "TMPSEEK"
	
	lAchou := !TMPSEEK->(Eof())
	If lAchou .And. lPosiciona
		(cAlias)->(DbGoTo(TMPSEEK->NRECNO))
	EndIf
	TMPSEEK->(DbCloseArea())
	
Return lAchou


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCriaHeaderบAutor  ณFabricio E. da Costaบ Data ณ  12/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o aHeader que serแ utilizado pela NewGetDados.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  cAlias...: Alias que sera criado o aHeader                บฑฑ
ฑฑบ          ณ  aCamposS.: Array contendo os campos do Alias a serem      บฑฑ
ฑฑบ          ณ             exibidos.                                      บฑฑ
ฑฑบ          ณ  aCamposN.: Array contendo os campos do Alias a serem      บฑฑ
ฑฑบ          ณ             suprimidos do Alias.                           บฑฑ
ฑฑบ          ณ  lCheck...: Indica se o grid terแ checkbox (.T.Sim/.F.Nใo).บฑฑ
ฑฑบ          ณ  lRecno...: Indica se o grid terแ Recno dos registros      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ  aHeader..: aHeader contendo os campos do Alias            บฑฑ
ฑฑบ          ณ             especificado.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local aHeader := {}
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
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(cAlias))
	While !SX3->(Eof()) .And. SX3->X3_ARQUIVO == cAlias
		If X3Uso(SX3->X3_USADO) .And. SX3->X3_TIPO <> "M" .And. SX3->X3_CONTEXT <> "V" .And. cNivel >= SX3->X3_NIVEL .And. (aScan(aCamposS, AllTrim(SX3->X3_CAMPO)) > 0 .Or. Len(aCamposS) == 0) .And. (aScan(aCamposN, AllTrim(SX3->X3_CAMPO)) == 0 .Or. Len(aCamposN) == 0)
			Aadd(aHeader, {})
			Aadd(aHeader[Len(aHeader)], AllTrim(SX3->X3_TITULO))
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
		SX3->(DbSkip())
	End
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณDivideTelaบAutor  ณFabricio E. da Costaบ Data ณ  03/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDevide as coordenadas passadas em aDesktop(que pode ser a   บฑฑ
ฑฑบ          ณtela ou parte dela) conforme o n๚mero de itens e seus       บฑฑ
ฑฑบ          ณe os percentuais definidos em aItens.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  aDesktop.: Dimens๕es da tela ou do trecho a ser dividido  บฑฑ
ฑฑบ          ณ             Ex: {X1,X2,Y1,Y2}                              บฑฑ
ฑฑบ          ณ  aItens...: Itens em que a tela serแ dividida. Conteudo:   บฑฑ
ฑฑบ          ณ             [n,1] - Eixo da divisใo V-Vertical H-Horizontalบฑฑ
ฑฑบ          ณ             [n,2] - Percentual do item                     บฑฑ
ฑฑบ          ณ             Ex: {{"V",70},{"V",30} - Este aItens dividira, บฑฑ
ฑฑบ          ณ             verticalmente, as dimens๕es de aDesktop em duasบฑฑ
ฑฑบ          ณ             partes, 70% e 30% respectivamente.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ  aObjects.: Array contendo as dimens๕es dos itens passados บฑฑ
ฑฑบ          ณ             em aItens.                                     บฑฑ
ฑฑบ          ณ             aObjects[1] = {X1,X2,Y1,Y2}                    บฑฑ
ฑฑบ          ณ             aObjects[2] = {X1,X2,Y1,Y2}                    บฑฑ
ฑฑบ          ณ             aObjects[n] = {X1,X2,Y1,Y2}                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DivideTela(aDesktop, aItens)
	Local i
	Local aObjects := {}
	Local nEixoX  := aDesktop[3] - aDesktop[1]
	Local nEixoY  := aDesktop[4] - aDesktop[2]
	Local nObjX1  := 0
	Local nObjX2  := aDesktop[1]
	Local nObjY1  := 0
	Local nObjY2  := aDesktop[2]

	For i := 1 To Len(aItens)
		nObjX1 := Iif(aItens[i,1] == "H", nObjX2, aDesktop[1])
		nObjX2 := nObjX1 + Iif(aItens[i,1] == "H", Int(nEixoX * (aItens[i,2]/100)), nEixoX)
		nObjY1 := Iif(aItens[i,1] == "V", nObjY2, aDesktop[2])
		nObjY2 := nObjY1 + Iif(aItens[i,1] == "V", Int(nEixoY * (aItens[i,2]/100)), nEixoY)
		aAdd(aObjects, {nObjX1, nObjY1, nObjX2, nObjY2} )
		nEixoX += Iif(aItens[i,1] == "H",-1,0)
		nEixoY += Iif(aItens[i,1] == "V",-1,0)
		nObjX2 += 1
		nObjY2 += 1
	Next

Return aObjects

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบProcedure ณLimpaGrid บ Autor ณFabricio E. da Costaบ Data ณ  10/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Limpa os grids de faturamento e reposicao de estoque e     บฑฑ
ฑฑบ          ณ posiciona o cursor no get cliente.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EMREM01                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Procedure LimpaGrid(oGetDados)
	oGetDados:aCols := {}
	oGetDados:oBrowse:Refresh()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBAddExp   บAutor  ณFabricio E. da Costaบ Data ณ  17/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona uma expressใo a lista de um codeblock.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  bVal.....: Codeblock que serแ inserida a expressao.       บฑฑ
ฑฑบ          ณ  cExp.....: Expressใo a ser inserida no codeblock.         บฑฑ
ฑฑบ          ณ  nLocal...: Local em que serแ inserida a expressao         บฑฑ
ฑฑบ          ณ             0-Inicio 1-Final                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ  cRet.....: Indica se a lista de express๕es do codeblock   บฑฑ
ฑฑบ          ณ             esta vazia(.T.) ou nใo (.F.)                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ  O valor retornado ้ uma string, pois codeblocks nใo podem บฑฑ
ฑฑบ          ณser utilizados como retorno de fun็ใo.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BAddExp(bVal, cExp, nLocal)
	Local cBlock  := ""
	Local nPos    := 0
	
	Default nLocal := 1
	
	cBlock := GetCbSource(bVal)
	nPos   := Iif(nLocal = 0, Rat("|", cBlock) + 1, Rat("}", cBlock))
	If !BEmpty(bVal)
		cBlock := Stuff(cBlock, nPos, 0, Iif(nLocal = 0, cExp + ", ", ", " + cExp))
	Else
		cBlock := Stuff(cBlock, nPos, 0, cExp)
	EndIf
	
Return cBlock

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBEmpty    บAutor  ณFabricio E. da Costaบ Data ณ  17/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAvalia se a lista de express๕es de um code block esta vazia บฑฑ
ฑฑบ          ณou nใo.                                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณParametros:                                                 บฑฑ
ฑฑบ          ณ  bVal.....: Codeblock a ser avaliado.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณRetorno:                                                    บฑฑ
ฑฑบ          ณ  lRet.....: Indica se a lista de express๕es do codeblock   บฑฑ
ฑฑบ          ณ             esta vazia(.T.) ou nใo (.F.)                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณObservacao:                                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GERAL                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BEmpty(bVal)
	Local cLista  := ""
	Local nInicio := 0
	Local nFinal  := 0
	
	cLista  := GetCbSource(bVal)
	If !Empty(cLista)
		nInicio := Rat("|", cLista) + 1
		nFinal  := Rat("}", cLista) - 1
		cLista  := SubStr(cLista, nInicio, Len(cLista) - nInicio - 1)
	EndIf
	
Return Empty(cLista)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ MenuDef  ณ Autor ณ Fabricio E. da Costa  ณ Data ณ 06/06/07 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Defini็ใo do aRotina (Menu funcional)                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ MenuDef()                                                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()
	Local aRotina :=	{} 
	             	
	Aadd(aRotina, {"Pesquisar",       "axPesqui"  , 0, 1, 0, Nil})
	Aadd(aRotina, {"Visualizar",      "U_TFFAT01M", 0, 2, 0, Nil})
	Aadd(aRotina, {"Incluir",         "U_TFFAT01M", 0, 3, 0, Nil})
	Aadd(aRotina, {"Alterar",         "U_TFFAT01M", 0, 4, 0, Nil})
	Aadd(aRotina, {"Excluir",         "U_TFFAT01M", 0, 5, 0, Nil})
	
Return aRotina
