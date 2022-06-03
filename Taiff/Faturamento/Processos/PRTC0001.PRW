#include "protheus.ch"
#include "RWMAKE.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTC0001  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Calculo de Embalagens                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PRTC0001()

	Local cAliasBKP := Alias()
	Local aOrdBkp	:= SaveOrd({cAliasBKP,"ZZF","ZZG"})
	Local cFilZZF	:= xFilial("ZZF")
	Local cFilZZG	:= xFilial("ZZG")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variáveis Utilizadas na Montagem da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSize  	:= {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosObj	:= {}
	Local nOpcoes 	:= 0
	Local cTitulo 	:= "Consulta de Embalagens"
	Local _nx		:= 0

	Private aHeader	:= {}
	Private aCols	:= {}
	Private aHeaZZG	:= {}
	Private aColZZG	:= {}
	Private aGets   := {}
	Private aTela   := {}
	Private nUsado	:= 0
	Private nUsaZZG	:= 0
	Private oGetD
	Private oGet1

	nOpcoes := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZF"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZF"
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
	SX3->(DbSeek("ZZG"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZG"
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsaZZG++
			aAdd(aHeaZZG, { Alltrim(SX3->X3_DESCRIC),;
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

//nPosRecWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZF_REC_WT"})
//nPosAliWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZF_ALI_WT"})

//aDel(aHeader,nPosRecWt)
//aDel(aHeader,nPosAliWt)

//aSize(aHeader,len(aHeader) - 2)
	RegToMemory("ZZG",.F.)
	RegToMemory("ZZF",.F.)

	SX3->(DbSetOrder(2))

	ZZF->(DbSetOrder(3))
	ZZF->(DbSeek(cFilZZF + SC5->C5_NUM))

	While ZZF->(!Eof()) .AND. ZZF->ZZF_PEDIDO == SC5->C5_NUM
		aAdd(aCols,Array(nUsado + 1) )
		nLinha:=len(aCols)
		aCols[nLinha][nUsado + 1] := .F.

		For _nx := 1 to len(aHeader)
			If SX3->(DbSeek(aHeader[_nx][2]))
				CriaVar(aHeader[_nx][2],.T.)
				if aHeader[_nx][10] <> "V"
					M->&(aHeader[_nx][2]) := ZZF->&(aHeader[_nx][2])
					aCols[nLinha][_nx] := ZZF->&(aHeader[_nx][2])
				Else
					aCols[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
		ZZF->(DbSkip())
	EndDo

	ZZF->(DbSetOrder(3))
	ZZF->(DbSeek(cFilZZF + SC5->C5_NUM))

	ZZG->(DbSetOrder(2))
	ZZG->(DbSeek(cFilZZG + SC5->C5_NUM + ZZF->ZZF_DHCALC + ZZF->ZZF_SEQCX))

	While ZZG->(!Eof()) .AND. ZZG->ZZG_PEDIDO == SC5->C5_NUM .AND. ZZG->ZZG_DHCALC == ZZF->ZZF_DHCALC .AND. ZZG->ZZG_SEQCX == ZZF->ZZF_SEQCX
		aAdd(aColZZG,Array(nUsaZZG + 1) )
		nLinha:=len(aColZZG)
		aColZZG[nLinha][nUsaZZG + 1] := .F.

		For _nx := 1 to len(aHeaZZG)
			If SX3->(DbSeek(aHeaZZG[_nx][2]))
				CriaVar(aHeaZZG[_nx][2],.T.)
				if aHeaZZG[_nx][10] <> "V"
					M->&(aHeaZZG[_nx][2]) := ZZG->&(aHeaZZG[_nx][2])
					aColZZG[nLinha][_nx] := ZZG->&(aHeaZZG[_nx][2])
				Else
					aColZZG[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
		ZZG->(DbSkip())
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

	oGet1:BChange := {|| U_C001CHG()}

	oGetD := MSNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"AllwaysTrue()", "AllwaysTrue()","AllwaysTrue()",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeaZZG  ,@aColZZG )

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
±±ºPrograma  ³PRTC0001  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta de Calculo de Embalagens                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function C001CHG()

	Local nPosSeq  := GdFieldPos("ZZF_SEQCX",aHeader)
	Local nPosSeq2 := GdFieldPos("ZZF_DHCALC",aHeader)
	Local cFilZZG	:= xFilial("ZZG")
	Local cDtH	 := oGet1:aCols[oGet1:nAt][nPosSeq2]
	Local cSCx  := oGet1:aCols[oGet1:nAt][nPosSeq]
	Local _nx := 0

	aColZZG := {}

	ZZG->(DbSetOrder(2)) // Filial + Pedido + Data Hora do Cálculo + Sequência da Caixa
	ZZG->(DbSeek(cFilZZG + SC5->C5_NUM + cDtH + cSCx ))

	While ZZG->(!Eof()) .AND. ZZG->ZZG_PEDIDO == SC5->C5_NUM .AND. ZZG->ZZG_DHCALC == cDtH .AND. ZZG->ZZG_SEQCX == cSCx

		aAdd(aColZZG,Array(nUsaZZG + 1) )
		nLinha:=len(aColZZG)
		aColZZG[nLinha][nUsaZZG + 1] := .F.

		For _nx := 1 to len(aHeaZZG)
			SX3->(DbSeek(aHeaZZG[_nx][2]))
			CriaVar(aHeaZZG[_nx][2],.T.)
			if aHeaZZG[_nx][10] <> "V"
				M->&(aHeaZZG[_nx][2]) := ZZG->&(aHeaZZG[_nx][2])
				aColZZG[nLinha][_nx] := ZZG->&(aHeaZZG[_nx][2])
			Else
				If aHeaZZG[_nx][2] = "ZZG_NF"
					SC9->( dbGoTo( ZZG->&(aHeaZZG[20][2]) ) )
					aColZZG[nLinha][_nx] := SC9->C9_NFISCAL
				Else
					aColZZG[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			Endif
		Next
		ZZG->(DbSkip())
	EndDo

	oGetD:SetArray(aColZZG)
	oGetD:Refresh()

Return .T.



