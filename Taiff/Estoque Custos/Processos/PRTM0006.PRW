#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0006  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Minutas                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PRTM0006()

	Local aCores 	:= {{ "ZZL_IMPR == 'S' ", "BR_VERDE"},;
		{ "ZZL_IMPR == 'N' ", "BR_VERMELHO"}}

	Private cCadastro	:= OemToAnsi("Minutas de Saída")
	Private aRotina 	:= MenuDef()

	mBrowse(6,1  ,22,75,"ZZL" ,,    ,     ,    ,        ,aCores  ,       ,       ,        ,         ,          ,        ,       ,)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef   ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Define as rotinas do mbrowse                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef()

	Private aRotina := {	{ OemtoAnsi( "Pesquisar"  		),	'PesqBrw'		,0, 1,	0,	.F. },;
		{ OemtoAnsi( "Visualizar"  		),	'U_M0006MAN(2)'	,0, 5,	0,	NIL },;
		{ OemtoAnsi( "Gerar Minuta"		),	'U_M0006MIN'	,0, 3,	0,	NIL },;
		{ OemtoAnsi( "Imprimir"  		),	'U_PRTR0001'	,0, 5,	0,	NIL },;
		{ OemtoAnsi( "Embarque"			),	'U_ALTEMB'		,0, 5,	0,	NIL },;
		{ OemtoAnsi( "Excluir"  		),	'U_M0006MAN(5)'	,0, 5,	0,	NIL },;
		{ OemtoAnsi( "Legenda"  		),	'U_M0006LEG'	,0, 5,	0,	NIL }}

Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0006  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a manutencao do cadastro                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M0006MAN(nOpcao)

	//Local cAliasBKP := Alias()
	//Local aOrdBkp	:= SaveOrd({cAliasBKP,"ZZL","SF2","SD2"})
	Local cFilZZL	:= xFilial("ZZL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variáveis Utilizadas na Montagem da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Local nGetLin	:= 0
	Local aSize  	:= {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosObj	:= {}
	Local nOpcoes 	:= 0
	Local cTitulo 	:= "Minuta de Saída"
	Local lOk		:= .F.
	Local aCpos		:= {"ZZL_MINUTA","ZZL_TRANSP","ZZL_NOMTRA","ZZL_DTGER","ZZL_HRGER"}
	Local _nx		:= 0

	Private aHeader	:= {}
	Private aCols	:= {}
	Private aGets   := {}
	Private aTela   := {}
	Private nUsado	:= 0
	Private INCLUI	:= IIF(nOpcao == 3,.T.,.F.)
	Private oGetD

	Default nOpcao := 1

	nOpcoes := Iif(nOpcao == 3 .or. nOpcao == 4,GD_INSERT + GD_DELETE + GD_UPDATE,0)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZL"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZL"
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

//FillGetDados(3,"ZZL",1,/*cSeek*/,/*{|| &cWhile }*/,/*{{bCond,bAction1,bAction2}}*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeader,aCols,/*bMountFile*/,/*bAfterCols*/)

	aCols := {}

	nUsado:=Len(aHeader)

//nPosRecWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZL_REC_WT"})
//nPosAliWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZL_ALI_WT"})

//aDel(aHeader,nPosRecWt)
//aDel(aHeader,nPosAliWt)

//aSize(aHeader,len(aHeader) - 2)
	RegToMemory("ZZL",INCLUI)

	SX3->(DbSetOrder(2))

	If nOpcao == 3
		aAdd(aCols,Array(nUsado + 1) )
		nLinha:=len(aCols)
		aCols[nLinha][nUsado + 1] := .F.

		For _nx := 1 to len(aHeader)
			If SX3->(DbSeek(aHeader[_nx][2]))
				CriaVar(aHeader[_nx][2],.T.)
				If Alltrim(SX3->X3_CAMPO) == "ZZL_ITEM"
					aCols[len(aCols)][_nx] := SomaIt(StrZero(0,len(M->ZZL_ITEM)))
				Else
					aCols[len(aCols)][_nx] := CriaVar(aHeader[_nx][2],.T.)
				EndIf
			EndIf
		Next
	Else

		ZZL->(DbSetOrder(1))
		ZZL->(DbSeek(cFilZZL + ZZL->ZZL_MINUTA))

		While ZZL->(!Eof()) .AND. ZZL->ZZL_FILIAL=cFilZZL .AND. M->ZZL_MINUTA == ZZL->ZZL_MINUTA
			aAdd(aCols,Array(nUsado + 1) )
			nLinha:=len(aCols)
			aCols[nLinha][nUsado + 1] := .F.

			For _nx := 1 to len(aHeader)
				If SX3->(DbSeek(aHeader[_nx][2]))
					CriaVar(aHeader[_nx][2],.T.)
					if aHeader[_nx][10] <> "V"
						M->&(aHeader[_nx][2]) := ZZL->&(aHeader[_nx][2])
						aCols[nLinha][_nx] := ZZL->&(aHeader[_nx][2])
					Else
						aCols[nLinha][_nx] := &(SX3->X3_RELACAO)
					Endif
				EndIf
			Next
			ZZL->(DbSkip())
		EndDo
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o calculo automatico de dimensoes de objetos     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize(.T.,.F.)
	aObjects := {}
	`
//                  C    L    C    L
	AAdd( aObjects, {   1  ,  120, .T., .T. } )
	AAdd( aObjects, {   1  ,  120, .T., .T. } )


	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a Enchoice superior com os Dados da Carga³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//EnChoice(cAlias, nReg,           nOpc, aCRA, cLetras, cTexto, aACho, aPos, aCpos, nModelo, nColMens, cMensagem, cTudoOk, lMemoria)
	Enchoice( "ZZL", ZZL->(Recno()), nOpcao,     ,        ,       ,      , {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},aCpos, 1, , ,"AllwaysTrue()", oDlg, .F.,  .T., .F., , .F., .F.)
//New                ( nTop        ,nLeft        ,nBottom     ,nRight       ,nStyle ,uLinhaOk      ,uTudoOk        ,cIniCpos   ,aAlter,nFreeze,nMax  ,cFieldOk     ,uSuperDel,uDelOk          ,oWnd,aParHeader,aParCols,uChange) CLASS MsNewGetDados
	oGetD := MSNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"AllwaysTrue()", "AllwaysTrue()",,      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeader  ,@aCols )

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End(),lOk := .T.},{||oDlg:End()}            ,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso tenha confirmado, efetua a gravação do cadastro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lOk .and. nOpcao >= 3 .and. nOpcao <= 5
		Begin Transaction

			GravaCad(nOpcao)

		End Transaction
	Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GravaCad  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a Gravação do Cadastro, conforme a opção informada   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaCad(nOption)

	Local cAliasBKP	:= Alias()
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZL","ZZL"})
	Local cFilZZL	:= xFilial("ZZL")
	// Local cNameSC1	:= RetSQLName("SC1")
	// Local cFilSC1	:= xFilial("SC1")
	// Local cAliasTRB	:= GetNextAlias()
	// Local lInclui	:= .F.
	// Local nPosItem	:= GdFieldPos("ZZL_ITEM",oGetD:aHeader)
	// Local cSCApr	:= ""
	Local cNota		:= ""
	Local cSerie	:= ""

	Default nOption	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se a Opçao foi informada corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption <= 2 .or. nOption >= 6
		Aviso("PRTM0006 - GravaCad","Opção de gravação não Informada corretamente!",{"Ok"})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura a Ordem Original dos Arquivos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

	ZZL->(DbSetOrder(1))
	ZZL->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Em caso de Inclusão, verifica se o registro já existe nas tabelas. Se existir, aborta a rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption == 3 .AND. (ZZL->(DbSeek(cFilZZL + M->ZZL_MINUTA)) .OR. ZZL->(DbSeek(cFilZZL + M->ZZL_MINUTA)))
		Aviso("PRTM0006 - GravaCad","Registro já existente. Entre em contato com Administrador!",{"Ok"})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura a Ordem Original dos Arquivos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia a Gravação dos arquivos conforme a Opção Informada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente em Caso de Exclusão das rotinas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption == 5
		ZZL->(DbSetOrder(1))
		ZZL->(DbSeek(cFilZZL + M->ZZL_MINUTA))
		cNota	:=	ZZL->ZZL_DOC
		cSerie	:=	ZZL->ZZL_SERIE
		While ZZL->(!Eof()) .AND. ZZL->ZZL_FILIAL = cFilZZL .AND. Alltrim(ZZL->ZZL_MINUTA) == Alltrim(M->ZZL_MINUTA)
			If RecLock("ZZL",.F.)
				ZZL->(DbDelete())
				ZZL->(MsUnLock())
			Endif
			CancEmb(cNota,cSerie)
			ZZL->(DbSkip())
		EndDo

		DbSelectArea("SF2")
		DbSetOrder(1)

	Else
		Aviso("PRTM0006 - GravaCad","Opção de gravação não Informada corretamente!",{"Ok"})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura a Ordem Original dos Arquivos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos Arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0006  ºAutor  ³Veti FSW            º Data ³  10/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Geração de Minutas                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M0006MIN()

	Local cPerg		:= Padr("PRTM0006",Len(SX1->X1_GRUPO))

	AjustSX1(cPerg)

	If !Pergunte(cPerg,.T.)
		Return .T.
	EndIf

	MostraNfs()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0006  ºAutor  ³Veti FSW            º Data ³  10/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mostra a tela de documentos para a geração da Minuta        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MostraNfs()

	Local cNameSF2 := RetSQLName("SF2")
	Local cNameZZL := RetSQLName("ZZL")
	Local cAliasTRB	:= GetNextAlias()
	Local cQuery 	:= ""
	Local aStruct	:= {}
	Local aCposStru	:= {}
	Local cAliasNF	:= GetNextAlias()
	Local cMarca	:= GetMark()
	Local aSize 	:= {}
	Local aObjects 	:= {}
	Local aInfo 	:= {}
	Local aPosObj 	:= {}
	Local lOk		:= .F.
	Local cMinuta	:= ""
	Local cArqTrab
	Local oDlgPend
	Local cItem		:=	""
	Local i			:=	0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra os documentos sem minuta, conforme parametro.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT F2_TRANSP, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA FROM " + cNameSF2 + " SF2 "
	cQuery += "WHERE F2_TRANSP = '"  + mv_par01 + "' "
	cQuery += "AND F2_FILIAL = '" + xFilial("SF2") + "' "
	cQuery += "AND F2_DOC >= '" + mv_par02 + "' "
	cQuery += "AND F2_DOC <= '" + mv_par03 + "' "
	cQuery += "AND F2_SERIE >= '" + mv_par04 + "' "
	cQuery += "AND F2_SERIE <= '" + mv_par05 + "' "
	cQuery += "AND F2_EMISSAO >= '" + DtoS(mv_par06) + "' "
	cQuery += "AND F2_EMISSAO <= '" + DtoS(mv_par07) + "' "
	cQuery += "AND F2_DOC + F2_SERIE NOT IN ( SELECT ZZL_DOC + ZZL_SERIE NOTA FROM " + cNameZZL + " ZZL WHERE ZZL.D_E_L_E_T_ <> '*' AND ZZL_FILIAL='"+xFilial("ZZL")+"') "
	cQuery += "AND SF2.D_E_L_E_T_ <> '*' "

	TcQuery cQuery ALIAS &(cAliasTRB) NEW

	If (cAliasTRB)->(!Eof()) .and. (cAliasTRB)->(!Bof())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria a estrutura do arquivo de trabalho para o MarkBrowse³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aStruct, {"WK1MARCA"		,"C",2						,0})
		Aadd(aStruct, {"ZZL_TRANSP"	 	,"C",6						,0})
		Aadd(aStruct, {"ZZL_DOC"	 	,"C",9						,0})
		Aadd(aStruct, {"ZZL_SERIE"	 	,"C",3						,0})
		Aadd(aStruct, {"ZZL_CLIENT" 	,"C",6						,0})
		Aadd(aStruct, {"ZZL_LOJA"	 	,"C",2						,0})
		Aadd(aStruct, {"ZZL_NOMCLI"	 	,"C",50						,0})

		Aadd(aCposStru, {"WK1MARCA"	,," "})
		Aadd(aCposStru, {"ZZL_TRANSP" 	,,"Transportadora"			})
		Aadd(aCposStru, {"ZZL_DOC" 		,,"Documento"	 			})
		Aadd(aCposStru, {"ZZL_SERIE" 	,,"Serie"					})
		Aadd(aCposStru, {"ZZL_CLIENT" 	,,"Cliente"					})
		Aadd(aCposStru, {"ZZL_LOJA" 	,,"Loja"					})
		Aadd(aCposStru, {"ZZL_NOMCLI" 	,,"Nome Cliente"			})

		cArqTrab  := CriaTrab(aStruct)

		dbUseArea(.T.,,cArqTrab,cAliasNF,.T.,.F.)

		While (cAliasTRB)->(!Eof())
			If RecLock(cAliasNF,.T.)
				(cAliasNF)->WK1MARCA		:= cMarca
				(cAliasNF)->ZZL_TRANSP		:= (cAliasTRB)->F2_TRANSP
				(cAliasNF)->ZZL_DOC			:= (cAliasTRB)->F2_DOC
				(cAliasNF)->ZZL_SERIE		:= (cAliasTRB)->F2_SERIE
				(cAliasNF)->ZZL_CLIENT		:= (cAliasTRB)->F2_CLIENTE
				(cAliasNF)->ZZL_LOJA		:= (cAliasTRB)->F2_LOJA
				(cAliasNF)->ZZL_NOMCLI		:= Posicione("SA1",1,xFilial("SA1") + (cAliasTRB)->F2_CLIENTE + (cAliasTRB)->F2_LOJA,"A1_NOME")
				(cAliasNF)->(MsUnLock())
			Endif
			(cAliasTRB)->(DbSkip())
		EndDo

		(cAliasNF)->(DbGoTop())

		aSize := MsAdvSize(.F.,.T.)
		aObjects := {}
		AAdd( aObjects, {   1,  120, .T., .F. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		nOpcoes := 0

		DEFINE MSDIALOG oDlgPend TITLE OemToAnsi("Geração de Minutas") From aSize[7],0 to aSize[6] + 50,aSize[5]+100 OF oMainWnd PIXEL

		oMark:= MsSelect():New(cAliasNF,"WK1MARCA",,aCposStru,,@cMarca,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]+55})
		oMark:oBrowse:lHasMark := .T.
		oMark:oBrowse:lCanAllMark:=.T.
		oMark:oBrowse:bAllMark := {|| MarkAll (cAliasNF, cMarca)}
		oMark:bAval := {|| ChkMarca(cAliasNF, cMarca) }

		nGetLin := aPosObj[1,3] + 20

		@ nGetLin,aPosObj[1,4] - 60		BMPBUTTON TYPE 1 ACTION Eval( { || Close(oDlgPend), lOK := .T. } )
		@ nGetLin,aPosObj[1,4] - 30		BMPBUTTON TYPE 2 ACTION Eval( { || Close(oDlgPend), lOK := .F. } )

		ACTIVATE MSDIALOG oDlgPend CENTERED

		If lOk
			(cAliasNF)->(DbGoTop())

			//If Aviso("PRTM0006","Confirma a geração da Minuta?",{"Sim","Não"} ) == 1

			Begin Transaction

				cMinuta := GetSX8Num("ZZL","ZZL_MINUTA")

				While (cAliasNF)->(!Eof())

					If !Empty((cAliasNF)->WK1MARCA) .and. RecLock("ZZL",.T.)
						i++
						cItem:=StrZero(i,len(ZZL->ZZL_ITEM))
						ZZL->ZZL_FILIAL := xFilial("ZZL")
						ZZL->ZZL_MINUTA	:= cMinuta
						ZZL->ZZL_ITEM	:= cItem
						ZZL->ZZL_TRANSP	:= (cAliasNF)->ZZL_TRANSP
						ZZL->ZZL_DOC	:= (cAliasNF)->ZZL_DOC
						ZZL->ZZL_SERIE	:= (cAliasNF)->ZZL_SERIE
						ZZL->ZZL_CLIENT	:= (cAliasNF)->ZZL_CLIENT
						ZZL->ZZL_LOJA	:= (cAliasNF)->ZZL_LOJA
						ZZL->ZZL_USER	:= UsrFullName(RetCodUsr())
						ZZL->ZZL_DTGER	:= Date()
						ZZL->ZZL_HRGER	:= Time()
						ZZL->ZZL_IMPR	:= "N"
						ZZL->(MsUnLock())
					EndIf
					(cAliasNF)->(Dbskip())
				EndDo

				ConfirmSX8()

			End Transaction

			//Aviso("PRTM0006","Minuta Gerada com Sucesso sob o código: " + cMinuta,{"Ok"})

			//EndIf
		EndIf

		(cAliasNF)->(DbCloseArea())

	EndIf

	(cAliasTRB)->(DbCloseArea())

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0006  ºAutor  ³Veti FSW            º Data ³  10/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta as perguntas                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustSX1(cPerg)

	PutSx1(cPerg,"01","Transportadora ?              ","Transportadora ?              ","Transportadora ?              ","MV_CH1","C",6,0,0,"G","                                                            ","SA4   ","   "," ","MV_PAR01","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"02","Do Documento                  ","Do Documento                  ","Do Documento                  ","MV_CH2","C",9,0,0,"G","                                                            ","      ","   "," ","MV_PAR02","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"03","Ao Documento                  ","Ao Documento                  ","Ao Documento                  ","MV_CH3","C",9,0,0,"G","                                                            ","      ","   "," ","MV_PAR03","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"04","Da Serie                      ","Da Serie                      ","Da Serie                      ","MV_CH4","C",3,0,0,"G","                                                            ","      ","   "," ","MV_PAR04","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"05","Ate a Serie                   ","Ate a Serie                   ","Ate a Serie                   ","MV_CH5","C",3,0,0,"G","                                                            ","      ","   "," ","MV_PAR05","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"06","Da Emissao                    ","Da Emissao                    ","Da Emissao                    ","MV_CH6","D",8,0,0,"G","                                                            ","      ","   "," ","MV_PAR06","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")
	PutSx1(cPerg,"07","Ate a Emissao                 ","Ate a Emissao                 ","Ate a Emissao                 ","MV_CH7","D",8,0,0,"G","                                                            ","      ","   "," ","MV_PAR07","               ","               ","               ","                                                            ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","               ","          ","","","","")

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ChkMarca  ºAutor  ³Veti FSW	         º Data ³  23/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que marca e desmarca os itens da markbrowse          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChkMarca(cAliasMRK,cMarca)

	If RecLock(cAliasMRK,.F.)
		If Empty((cAliasMRK)->WK1MARCA)
			(cAliasMRK)->WK1MARCA := cMarca
		Else
			(cAliasMRK)->WK1MARCA := " "
		Endif
		(cAliasMRK)->(MsUnLock())
	Endif

	oMark:oBrowse:Refresh()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarkAll   ºAutor  ³Veti FSW		     º Data ³  23/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que marca ou desmarca todos os itens                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarkAll(cAliasMRK,cMarca)

	(cAliasMRK)->(DbGoTop())

	While (cAliasMRK)->(!EoF())
		ChkMarca(cAliasMRK,cMarca)
		(cAliasMRK)->(DbSkip())
	EndDo

	(cAliasMRK)->(DbGoTop())

	oMark:oBrowse:Refresh()

Return .T.

User Function M0006LEG()

	Local aCor:={}

	aCor := {{'DISABLE',"Minuta Não Impressa" },;
		{ 'ENABLE',"Minuta Impressa"}}

	BrwLegenda("Minuta","Legenda",aCor)
Return(.T.)

User Function ALTEMB()

	Local cMinuta	:=""
	Local cNota		:=""
	Local cSerie	:=""
	Local dDtEmb	:=ctod("  /  /  ")
	Local dDt:=Date()

	cMinuta	:=	ZZL->ZZL_MINUTA
	cNota	:=	ZZL->ZZL_DOC
	cSerie	:=	ZZL->ZZL_SERIE
	dDtEmb:=Posicione("SF2",1,xFilial("SF2")+cNota+cSerie,"F2_DTEMB")

	If Aviso(" Minuta: "+cMinuta,"Data Embarque: " +dtoc(dDt) +chr(10)+chr(13)+;
			"Confirma Data de Embarque?",{"Sim","Não"} ) == 1

		DbSelectArea("ZZL")
		DbSetOrder(1)
		DbSeek(xFilial("ZZL")+cMinuta)
		While !EOF() .AND. ZZL->ZZL_FILIAL=xFilial("ZZL") .AND. ZZL->ZZL_MINUTA = cMinuta
			cNota	:=	ZZL->ZZL_DOC
			cSerie	:=	ZZL->ZZL_SERIE
			AtuDTEmb(cNota,cSerie)
			DbSkip()
		End

	Endif
Return(.T.)

Static Function AtuDTEmb(cNota,cSerie)

	Local dDt:=Date()
	_cQuery   := "UPDATE " + RetSqlName("SF2") + " SET "
	_cQuery   += "	F2_DTEMB ='"+dtos(dDt)+"'"
	_cQuery   += " WHERE F2_FILIAL = '"+xFilial("SF2")+"'"
	_cQuery   += " AND F2_DOC = '" + cNota + "'
	_cQuery   += " AND F2_SERIE = '" + cSerie + "'
	_cQuery	  += " AND D_E_L_E_T_ <> '*' "

	TCSQLExec(_cQuery)
Return.T.

Static Function CancEmb(cNota,cSerie)

	_cQuery   := "UPDATE " + RetSqlName("SF2") + " SET "
	_cQuery   += "	F2_DTEMB ='        '"
	_cQuery   += " WHERE F2_FILIAL = '"+xFilial("SF2")+"'"
	_cQuery   += " AND F2_DOC = '" + cNota + "'
	_cQuery   += " AND F2_SERIE = '" + cSerie + "'
	_cQuery	  += " AND D_E_L_E_T_ <> '*' "

	TCSQLExec(_cQuery)
Return.T.
