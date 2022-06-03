/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTC0005  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³historico de Consulta de Calculo de Embalagens              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PRTC0005()

	Local cAliasBKP := Alias()
	Local aOrdBkp	:= SaveOrd({cAliasBKP,"ZZM","ZZN"})
	Local cFilZZM	:= xFilial("ZZM")
	Local cFilZZN	:= xFilial("ZZN")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variáveis Utilizadas na Montagem da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSize  	:= {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosObj	:= {}
	Local nOpcoes 	:= 0
	Local cTitulo 	:= "Consulta de Historico"
	Local _nx		:= 0

	Private aHeader	:= {}
	Private aCols	:= {}
	Private aHeaZZN	:= {}
	Private aColZZN	:= {}
	Private aGets   := {}
	Private aTela   := {}
	Private nUsado	:= 0
	Private	nUsaZZN	:= 0
	Private oGetD
	Private oGet1

	nOpcoes := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZM"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZM"
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsado++
			aAdd(aHeader, { Alltrim(SX3->X3_DESCRIC),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO})
		Endif
		SX3->(DbSkip())
	EndDo

	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZN"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZN"
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsaZZN++
			aAdd(aHeaZZN, { Alltrim(SX3->X3_DESCRIC),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO})
		Endif
		SX3->(DbSkip())
	EndDo

	aCols := {}

	nUsado:=Len(aHeader)

//nPosRecWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZM_REC_WT"})
//nPosAliWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZM_ALI_WT"})

//aDel(aHeader,nPosRecWt)	
//aDel(aHeader,nPosAliWt)	

//aSize(aHeader,len(aHeader) - 2)
	RegToMemory("ZZN",.F.)
	RegToMemory("ZZM",.F.)

	SX3->(DbSetOrder(2))


	ZZM->(DbSetOrder(1))
	ZZM->(DbSeek(cFilZZM + SC5->C5_NUM))

	While ZZM->(!Eof()) .AND. ZZM->ZZM_PEDIDO == SC5->C5_NUM
		aAdd(aCols,Array(nUsado + 1) )
		nLinha:=len(aCols)
		aCols[nLinha][nUsado + 1] := .F.

		For _nx := 1 to len(aHeader)
			If SX3->(DbSeek(aHeader[_nx][2]))
				CriaVar(aHeader[_nx][2],.T.)
				if aHeader[_nx][10] <> "V"
					M->&(aHeader[_nx][2]) := ZZM->&(aHeader[_nx][2])
					aCols[nLinha][_nx] := ZZM->&(aHeader[_nx][2])
				Else
					aCols[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
		ZZM->(DbSkip())
	EndDo

	ZZM->(DbSetOrder(1))
	ZZM->(DbSeek(cFilZZM + SC5->C5_NUM))

	ZZN->(DbSetOrder(1))
	ZZN->(DbSeek(cFilZZN + SC5->C5_NUM + ZZM->ZZM_SEQCX))

	While ZZN->(!Eof()) .AND. ZZN->ZZN_PEDIDO == SC5->C5_NUM .AND. ZZN->ZZN_SEQCX == ZZM->ZZM_SEQCX
		aAdd(aColZZN,Array(nUsaZZN + 1) )
		nLinha:=len(aColZZN)
		aColZZN[nLinha][nUsaZZN + 1] := .F.

		For _nx := 1 to len(aHeaZZN)
			If SX3->(DbSeek(aHeaZZN[_nx][2]))
				CriaVar(aHeaZZN[_nx][2],.T.)
				if aHeaZZN[_nx][10] <> "V"
					M->&(aHeaZZN[_nx][2]) := ZZN->&(aHeaZZN[_nx][2])
					aColZZN[nLinha][_nx] := ZZN->&(aHeaZZN[_nx][2])
				Else
					aColZZN[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
		ZZN->(DbSkip())
	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize(.T.,.F.)
	aObjects := {}

//                  C    L    C    L
	AAdd( aObjects, {   1  ,  120, .T., .T. } )
	AAdd( aObjects, {   1  ,  120, .T., .T. } )


	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

	oGet1 := MSNewGetDados():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcoes,"AllwaysTrue()", "AllwaysTrue()","AllwaysTrue()",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeader  ,@aCols )
	oGet1:BChange := {|| U_C005CHG()}
	oGetD := MSNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"AllwaysTrue()", "AllwaysTrue()","AllwaysTrue()",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeaZZN  ,@aColZZN )

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()}            ,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTC0005  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Calculo de Embalagens                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C005CHG()

	Local nPosSeq := GdFieldPos("ZZM_SEQCX",aHeader)
	Local cFilZZN	:= xFilial("ZZN")
	Local _nx := 0

	aColZZN := {}

	ZZN->(DbSetOrder(1))
	ZZN->(DbSeek(cFilZZN + SC5->C5_NUM + oGet1:aCols[oGet1:nAt][nPosSeq]))

	While ZZN->(!Eof()) .AND. ZZN->ZZN_PEDIDO == SC5->C5_NUM .AND. ZZN->ZZN_SEQCX == oGet1:aCols[oGet1:nAt][nPosSeq]
		aAdd(aColZZN,Array(nUsaZZN + 1) )
		nLinha:=len(aColZZN)
		aColZZN[nLinha][nUsaZZN + 1] := .F.

		For _nx := 1 to len(aHeaZZN)
			If SX3->(DbSeek(aHeaZZN[_nx][2]))
				CriaVar(aHeaZZN[_nx][2],.T.)
				if aHeaZZN[_nx][10] <> "V"
					M->&(aHeaZZN[_nx][2]) := ZZN->&(aHeaZZN[_nx][2])
					aColZZN[nLinha][_nx] := ZZN->&(aHeaZZN[_nx][2])
				Else
					aColZZN[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
		ZZN->(DbSkip())
	EndDo

	oGetD:SetArray(aColZZN)
	oGetD:Refresh()

Return .T.
