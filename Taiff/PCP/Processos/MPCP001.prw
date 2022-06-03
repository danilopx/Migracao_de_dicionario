#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ MPCP001  ³ Autor ³ Carlos Alday			  ³ Data ³ 15/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Proriza as Ordens de Producao para impressao das			  ³±±
±±³			 ³ etiquetas. 																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MPCP001
	Local cAlias  := "ZB1"
	Local aCores  := {}
	Local cFiltra := ""

	Public dOPFiltro	:= GETNEWPAR("MV_IMPQUAD" , dDataBase )
	Public dOPAte		:= dDataBase+1

	Private cCadastro	:= "Cadastro de Priorização de OP"
	Private aRotina  	:= {}
	Private aIndexSA2	:= {}
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

	AADD(aRotina,{"Pesquisar"	,"PesqBrw"			,0,1})
	AADD(aRotina,{"Visualizar"	,"AxVisual"			,0,2})
	AADD(aRotina,{"Incluir"		,"U_BInclui"		,0,3})
	AADD(aRotina,{"Alterar"		,"U_BAltera"		,0,4})
	AADD(aRotina,{"Excluir"		,"U_BDeleta"		,0,5})
	AADD(aRotina,{"OP firmada"	,"U_OPfirme"		,0,3})
	AADD(aRotina,{"Data Firma" ,"U_PrevisaoFxa"	,0,3})
	AADD(aRotina,{"Legenda"		,"U_BLegenda"		,0,3})

/*
-- CORES DISPONIVEIS PARA LEGENDA --
BR_AMARELO
BR_AZUL
BR_BRANCO
BR_CINZA
BR_LARANJA
BR_MARRON
BR_VERDE
BR_VERMELHO
BR_PINK
BR_PRETO
*/

	AADD(aCores,{"Empty(ZB1_PRIOR)"	,"BR_VERDE"		})
	AADD(aCores,{"ZB1_PRIOR == '1'"	,"BR_AMARELO"	})
	AADD(aCores,{"ZB1_PRIOR == '2'"	,"BR_VERMELHO"	})
	AADD(aCores,{"ZB1_PRIOR == '0'"	,"BR_VERDE"		})

	dbSelectArea(cAlias)
	dbSetOrder(1)
	Eval(bFiltraBrw)

	dbSelectArea(cAlias)
	dbGoTop()
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)

//+------------------------------------------------
//| Deleta o filtro utilizado na função FilBrowse
//+------------------------------------------------
EndFilBrw(cAlias,aIndexSA2)

Return


//+---------------------------------------
//|Função: BInclui - Rotina de Inclusão
//+---------------------------------------
User Function BInclui(cAlias,nReg,nOpc)

	Local nOpcao := 0

	nOpcao := AxInclui(cAlias,nReg,nOpc)

	If nOpcao == 1
		//MsgInfo("Inclusão efetuada com sucesso!")

		U_UpPrioriza()

	Else
		//MsgInfo("Inclusão cancelada!")
	Endif

Return Nil

//+-----------------------------------------
//|Função: BAltera - Rotina de Alteração
//+-----------------------------------------
User Function BAltera(cAlias,nReg,nOpc)

	Local nOpcao := 0

	nOpcao := AxAltera(cAlias,nReg,nOpc)

	If nOpcao == 1
		//MsgInfo("Alteração efetuada com sucesso!")

		U_UpPrioriza()

	Else
		//MsgInfo("Alteração cancelada!")
	Endif

Return Nil

//+-----------------------------------------
//|Função: BDeleta - Rotina de Exclusão
//+-----------------------------------------
User Function BDeleta(cAlias,nReg,nOpc)

	Local nOpcao := 0

	nOpcao := AxDeleta(cAlias,nReg,nOpc)

	If nOpcao == 1
		//MsgInfo("Exclusão efetuada com sucesso!")
	Else
		//MsgInfo("Exclusão cancelada!")
	Endif

Return Nil

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function BLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		,"Prioridade Padrão"	})
	AADD(aLegenda,{"BR_AMARELO"	,"Crítica"				})
	AADD(aLegenda,{"BR_VERMELHO"	,"Não Crítica"			})

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
User Function UpPrioriza()
	dbSelectArea("SC2")
	DbSetOrder(1)
	SC2->( dbSeek(xFilial("SC2")+ZB1->ZB1_OP) )

	dbSelectArea("ZB1")
	ZB1->(RecLock("ZB1",.f.))
	ZB1->ZB1_OPERA := Alltrim(cUSERNAME)
	ZB1->ZB1_DTGRAV:= Date()
	ZB1->ZB1_HRGRAV:= Time()
	ZB1->ZB1_NUMOP	:= Substr(ZB1->ZB1_OP ,01,06)
	ZB1->ZB1_OPITEM:= Substr(ZB1->ZB1_OP ,07,02)
	ZB1->ZB1_OPSEQ := Substr(ZB1->ZB1_OP ,09,03)
	ZB1->ZB1_DTFAB	:=	SC2->C2_DATPRI
	ZB1->ZB1_COD	:=	SC2->C2_PRODUTO
	ZB1->(MsUnlock())
Return NIL

//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
User Function OPfirme()
	Local xAlias	 	:= GetArea()
	Local cQuery		:= ""
	Local _nOpcao 		:= 0
	Local cMovtoZB1 	:= "A"

	Public lNoFiltro	:= .T.

	Private cString := ""

	While lNoFiltro

		cQuery := "SELECT ZB1.ZB1_PRIOR, SC2.C2_DATPRI, SB1.B1_DESC, SC2.C2_QUANT, SC2.C2_NUM"
		cQuery += "       , SC2.C2_ITEM, SC2.C2_SEQUEN, ZB1.ZB1_OPERA, ZB1.ZB1_DTGRAV, ZB1.ZB1_HRGRAV "
		cQuery += "       , SC2.C2_PRODUTO, SC2.C2_EMISSAO, SC2.C2_OBS  "
		cQuery += " FROM " + RetSqlName("SC2") + " SC2 "
		cQuery += "  INNER JOIN " + RetSqlName("SB1") + " SB1 "
		cQuery += "     ON SC2.C2_PRODUTO=SB1.B1_COD AND SB1.D_E_L_E_T_ != '*' AND B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += "  LEFT OUTER JOIN " + RetSqlName("ZB1") + " ZB1 "
		cQuery += "     ON ZB1_FILIAL = '" + xFilial("ZB1") + "' AND SC2.C2_NUM=ZB1.ZB1_NUMOP "
		cQuery += "     	AND SC2.C2_SEQUEN=ZB1.ZB1_OPSEQ AND SC2.C2_ITEM=ZB1.ZB1_OPITEM "
		cQuery += "     	AND SC2.C2_PRODUTO=ZB1.ZB1_COD AND ZB1.D_E_L_E_T_ != '*'"
		cQuery += " WHERE SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		cQuery += "   AND	SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += "   AND SB1.B1_TIPO='PE' "
		cQuery += "   AND SC2.D_E_L_E_T_ != '*' "
		cQuery += "   AND SC2.C2_TPOP='F' "
		cQuery += "   AND SC2.C2_DATPRI >= '" +DTOS(dOPFiltro)+ "'"
		cQuery += "   AND SC2.C2_DATPRI <= '" +DTOS(dOPAte)+ "'"
		cQuery += "   AND EXISTS "
		cQuery += "   ( SELECT 'X' "
		cQuery += "     FROM " + RetSqlName("ZA4") + " ZA4 "
		cQuery += " 	 WHERE ZA4.ZA4_FILIAL = '" + xFilial("ZA4") + "' "
		cQuery += "   		AND ZA4.D_E_L_E_T_ != '*' "
		cQuery += "   		AND ZA4.ZA4_COD    = SC2.C2_PRODUTO "
		cQuery += "   		AND ZA4.ZA4_NUMOP  = SC2.C2_NUM "
		cQuery += "   		AND ZA4.ZA4_OPITEM = SC2.C2_ITEM "
		cQuery += "   		AND ZA4.ZA4_OPSEQ  = SC2.C2_SEQUEN "
		cQuery += "   		AND ZA4.ZA4_DTIMP = '' "
		cQuery += "   ) "
		cQuery += " ORDER BY SC2.C2_DATPRI DESC, SC2.C2_QUANT DESC  "

		If Select("TMPPRI") > 0
			TMPPRI->(DbCloseArea())
		Endif

		TcQuery cQuery NEW ALIAS ("TMPPRI")

		DbSelectArea("TMPPRI")

		If TMPPRI->(Eof()) .and. TMPPRI->(Bof())
			Alert("Não há dados a consultar para os parâmetros: de "+dtoc(dOPFiltro)+" até "+dtoc(dOPAte),"Parâmetros de consulta")
			//U_PrevisaoFxa()
			lNoFiltro	:= .F.
		Else
			_cOpLin	:= ""
			_cItLin	:= ""
			_cSqLin 	:= ""
			_cPrLin 	:= ""

			_nOpcao := PriorQry("TMPPRI", "PRIORIZA IMPRESSAO DE OP's FIRMADAS COM BASE NA DATA DE INICIO DE PRODUÇÃO")

			If !Empty(_cOpLin)

				ZB1->(DbSetOrder(1))
				If ZB1->( dbSeek(xFilial("ZB1") + _cOpLin + _cItLin + _cSqLin + _cPrLin ) )
					cMovtoZB1 := "A"
				Else
					cMovtoZB1 := "I"
				EndIf

				dbSelectArea("SC2")
				DbSetOrder(1)
				SC2->( dbSeek(xFilial("SC2") + _cOpLin + _cItLin + _cSqLin) )
				dbSelectArea("ZB1")
				If	cMovtoZB1 = "A"
					nReg := ZB1->(Recno())
					If (nOpcao := AxAltera("ZB1",nReg,4))=1
						U_UpPrioriza()
					Endif
				Else
					If (nOpcao := AxInclui("ZB1",0,3))=1
						U_UpPrioriza()
					Endif
				EndIf

			EndIf
		EndIf
	End
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
Static Function PriorQry(cAlias, cTitulo)
	Local bAddDados := ""
	Local nOpcA     := 0
	Local aCampoS   := {}
	Local oDlg1, oGDLst
	Local aButtons 	:= {}

	Local nPosOP		:= ""
	Local nPosOPitem	:= ""
	Local nPosOPSeq	:= ""
	Local nPosOPPro	:= ""
	Local i := 0

	_cOpLin := ""
	_cItLin := ""
	_cSqLin := ""
	_cPrLin 	:= ""


	AADD( aButtons, {"HISTORIC", {|| U_PrevisaoFxa() , nOpcA := 2, oDlg1:End() }, "Previsão de Início de Produção","Previsão",{|| .T.}} )
	//AADD( aButtons, {"PAP06", {|| nOpcA := 3, oDlg1:End() }, "Parâmetros para elaborar consulta","Parâmetros",{|| .T.}} )

	oDlg1                := tDialog():New()
	oDlg1:cName          := "oDlg1"
	oDlg1:cCaption       := cTitulo
	oDlg1:nLeft          := 001
	oDlg1:nTop           := 001
	oDlg1:nWidth         := 800 // 550
	oDlg1:nHeight        := 320
	oDlg1:nClrPane       := 16777215
	oDlg1:nStyle         := -2134376320
	oDlg1:bInit          := {|| EnchoiceBar(oDlg1, {|| _cOpLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOP], _cItLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpItem], _cSqLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpSeq], _cPrLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpPro], lNoFiltro	:= .F., nOpcA := 1, oDlg1:End() }, {|| _cOpeBrow := "", lNoFiltro	:= .F. , nOpcA := 0, oDlg1:End()},,@aButtons )}
	oDlg1:lCentered      := .T.

	aHeader := MPriorHeader(cAlias, aCampoS)
	oGDLst  := MsNewGetDados():New(0, 0, 1, 1, ,,,,,,,,,, oDlg1, aHeader, {})
	oGDLst:aCols := {}
	//oGDLst:oBrowse:nLeft      := 02
	//oGDLst:oBrowse:nTop       := 25
	//oGDLst:oBrowse:nWidth     := 545
	//oGDLst:oBrowse:nHeight    := 270
	oGDLst:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oGDLst:oBrowse:lAdjustColSize := .T.

	oGDLst:oBrowse:bLDblClick := {|z,x| _cOpLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOP], _cItLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpItem],	_cSqLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpSeq], _cPrLin := oGDLst:aCols[oGDLst:oBrowse:nAt][nPosOpPro], lNoFiltro	:= .F., nOpcA := 1, oDlg1:End() }

	nPosOP		:= aScan(aHeader,{|x| AllTrim(x[2])=="C2_NUM"})
	nPosOPitem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C2_ITEM"})
	nPosOPSeq	:= aScan(aHeader,{|x| AllTrim(x[2])=="C2_SEQUEN"})
	nPosOPPro	:= aScan(aHeader,{|x| AllTrim(x[2])=="C2_PRODUTO"})

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

	(cAlias)->(DbClosearea())

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
Static Function MPriorHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
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
