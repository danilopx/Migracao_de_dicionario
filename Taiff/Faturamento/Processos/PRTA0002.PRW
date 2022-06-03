#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTA0002  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cadastro de Grupos de Aprovacao x Grupos de Produtos        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PRTA0002()

	Local aCores 	:= {{ ".T.", "BR_VERDE"}}

	Private cCadastro	:= OemToAnsi("Grupos de Aprovação x Grupos de Produtos")
	Private aRotina 	:= MenuDef()

	mBrowse(6,1  ,22,75,"ZZH" ,,    ,     ,    ,        ,aCores  ,       ,       ,        ,         ,          ,        ,       ,)

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

	Private aRotina := {	{ OemtoAnsi( "Pesquisar"  		),	'PesqBrw',		0, 1,	0,	.F. },;
		{ OemtoAnsi( "Visualizar"  		),	'U_A0002MAN(2)',	0, 2,	0,	NIL },;
		{ OemtoAnsi( "Incluir"    		),	'U_A0002MAN(3)',	0, 3,	0,	NIL },;
		{ OemtoAnsi( "Alterar"    		),	'U_A0002MAN(4)',	0, 4,	0,	NIL },;
		{ OemtoAnsi( "Excluir" 	   		),	'U_A0002MAN(5)',	0, 5,	0,	NIL }}

Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTA0002  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a manutencao do cadastro                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A0002MAN(nOpcao)

	Local cFilZZI	:= xFilial("ZZI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variáveis Utilizadas na Montagem da Tela³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aSize  	:= {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosObj	:= {}
	Local nOpcoes 	:= 0
	Local cTitulo 	:= "Grupos de Aprovação x Grupos de Produtos"
	Local lOk		:= .F.
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
	SX3->(DbSeek("ZZI"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZI"
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

//FillGetDados(3,"ZZI",1,/*cSeek*/,/*{|| &cWhile }*/,/*{{bCond,bAction1,bAction2}}*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeader,aCols,/*bMountFile*/,/*bAfterCols*/)

	aCols := {}

	nUsado:=Len(aHeader)

//nPosRecWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZI_REC_WT"})
//nPosAliWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZI_ALI_WT"})

//aDel(aHeader,nPosRecWt)	
//aDel(aHeader,nPosAliWt)	

//aSize(aHeader,len(aHeader) - 2)
	RegToMemory("ZZH",INCLUI)
	RegToMemory("ZZI",.F.)

	SX3->(DbSetOrder(2))

	If nOpcao == 3
		aAdd(aCols,Array(nUsado + 1) )
		nLinha:=len(aCols)
		aCols[nLinha][nUsado + 1] := .F.

		For _nx := 1 to len(aHeader)
			If SX3->(DbSeek(aHeader[_nx][2]))
				CriaVar(aHeader[_nx][2],.T.)
				If Alltrim(SX3->X3_CAMPO) == "ZZI_ITEM"
					aCols[len(aCols)][_nx] := SomaIt(StrZero(0,len(M->ZZI_ITEM)))
				Else
					aCols[len(aCols)][_nx] := CriaVar(aHeader[_nx][2],.T.)
				EndIf
			EndIf
		Next
	Else

		ZZI->(DbSetOrder(1))
		ZZI->(DbSeek(cFilZZI + ZZH->ZZH_CODGRP))

		While ZZI->(!Eof()) .AND. ZZI->ZZI_CODGRP == ZZH->ZZH_CODGRP
			aAdd(aCols,Array(nUsado + 1) )
			nLinha:=len(aCols)
			aCols[nLinha][nUsado + 1] := .F.

			For _nx := 1 to len(aHeader)
				If SX3->(DbSeek(aHeader[_nx][2]))
					CriaVar(aHeader[_nx][2],.T.)
					if aHeader[_nx][10] <> "V"
						M->&(aHeader[_nx][2]) := ZZI->&(aHeader[_nx][2])
						aCols[nLinha][_nx] := ZZI->&(aHeader[_nx][2])
					Else
						aCols[nLinha][_nx] := &(SX3->X3_RELACAO)
					Endif
				EndIf
			Next
			ZZI->(DbSkip())
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
	Enchoice( "ZZH", ZZH->(Recno()), nOpcao, , , , , {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]}, , 1, , ,"AllwaysTrue()", oDlg, .F.,  .T., .F., , .F., .F.)
	//New ( nTop        ,nLeft        ,nBottom     ,nRight       ,nStyle ,uLinhaOk      ,uTudoOk        ,cIniCpos   ,aAlter,nFreeze,nMax  ,cFieldOk     ,uSuperDel,uDelOk          ,oWnd,aParHeader,aParCols,uChange) CLASS MsNewGetDados
	oGetD := MSNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"U_A0002LOK()", "U_A0002TOK()","+ZZI_ITEM",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeader  ,@aCols )

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio(aGets,aTela) .and. U_A0002TOK(),(oDlg:End()          ,lOk := .T.),.F.)},{||oDlg:End()}            ,,)


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
±±ºPrograma  ³A0002LOK  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de Validação de Linha (LinhaOK) na getdados          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A0002LOK()

	Local cAliasBKP	:= Alias()
	Local aOrdBKP   := SaveOrd({cAliasBKP,"ZZI"})
	Local nPosCod 	:= GdFieldPos("ZZI_GRPPRD",oGetD:aHeader)
	Local nPosFim 	:= GdFieldPos("ZZI_GRPFIM",oGetD:aHeader)
	Local nPosItem 	:= GdFieldPos("ZZI_ITEM",oGetD:aHeader)
	Local lRet 	  	:= .T.
	Local cQuery	:= ""
	Local cAliasTRB	:= GetNextAlias()
	Local cNameZZI	:= RetSQLName("ZZI")
	Local cFilZZI	:= xFilial("ZZI")
	Local cGrpErr	:= ""
	Local _nx		:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso o registro esteja deletado, não realiza a validação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oGetD:aCols[oGetD:nAt][nUsado + 1]
		Return .T.
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o campo código está preenchido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(oGetD:aCols[oGetD:nAt][nPosCod])
		Aviso("A0002LOK","Campo Grupo de Produtos Obrigatorio",{"Ok"})
		Return .F.
	EndIf

	If Empty(oGetD:aCols[oGetD:nAt][nPosFim])
		Aviso("A0002LOK","Campo Grupo de Produtos Final Obrigatorio",{"Ok"})
		Return .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Grupo Inicial é menor ou igual ao grupo Final³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If oGetD:aCols[oGetD:nAt][nPosCod] > oGetD:aCols[oGetD:nAt][nPosFim]
		Aviso("A0002LOK","Grupo Inicial não pode ser maior que o grupo final.",{"Ok"})
		Return .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o registro já existe na GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nx := 1 to len(oGetD:aCols)
		If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
		ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
				Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
				(Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
				Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  )
			Aviso("A0002LOK","Range de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})
			Return .F.
		Endif
	Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o range de grupos de produtos já foi utilizado para outro aprovador.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT ZZI_CODGRP, ZZI_ITEM FROM " + cNameZZI + " ZZI "
	cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosCod] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM "
	cQuery += "OR '" + oGetD:aCols[oGetD:nAt][nPosFim] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM ) "
	cQuery += "AND ZZI_CODGRP <> '" + M->ZZH_CODGRP + "' "
	cQuery += "AND ZZI_FILIAL = '" + cFilZZI + "' "
	cQuery += "AND ZZI.D_E_L_E_T_ <> '*' "

	TcQuery cQuery ALIAS &(cAliasTRB) NEW

	While (cAliasTRB)->(!Eof())
		cGrpErr += "Grupo: " + (cAliasTRB)->ZZI_CODGRP + " - Item: " + (cAliasTRB)->ZZI_ITEM + Chr(13) + Chr(10)
		(cAliasTRB)->(DbSkip())
	EndDo

	(cAliasTRB)->(DbCloseArea())

	If !Empty(cGrpErr)
		Aviso("A0002LOK","Esse range de grupo de produtos conflita com o range dos seguintes grupos de aprovacao: " + ;
			Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)
		lRet := .F.
	EndIf


/*ZZI->(DbSetOrder(2))        
ZZI->(DbSeek(cFilZZI + oGetD:aCols[oGetD:nAt][nPosCod]))

	While ZZI->(!Eof()) .AND. ZZI->ZZI_GRPPRD == oGetD:aCols[oGetD:nAt][nPosCod]
		If ZZI->ZZI_CODGRP <> M->ZZH_CODGRP
		Aviso("A0002LOK","Esse grupo de produtos ja esta cadastrado para o grupo de aprovacao " + ZZI->ZZI_CODGRP,{"Ok"})
		lRet := .F.
		Exit
		EndIf
	ZZI->(DbSkip())		
	EndDo                       */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos Arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestOrd(aOrdBKP)                     
DbSelectArea(cAliasBKP)

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A0002TOK  ºAutor  ³Veti FSW            º Data ³  16/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de Validação de GetDados (tudoOk)                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A0002TOK()

	Local lRet 		:= .T.
	Local cAliasBKP	:= Alias()
	Local aOrdBKP   := SaveOrd({"ZZI"})
	Local nPosCod 	:= GdFieldPos("ZZI_GRPPRD",oGetD:aHeader)
	Local nPosFim 	:= GdFieldPos("ZZI_GRPFIM",oGetD:aHeader)
	Local nPosItem 	:= GdFieldPos("ZZI_ITEM",oGetD:aHeader)
	Local _nx 		:= 0
	Local _ny		:= 0
	Local cQuery	:= ""
	Local cAliasTRB	:= GetNextAlias()
	Local cNameZZI	:= RetSQLName("ZZI")
	Local cFilZZI	:= xFilial("ZZI")
	Local cGrpErr	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se já existe o range de grupos cadastrados para cada linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nx := 1 to len(oGetD:aCols)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o Registro estiver deletado, não realiza a validação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oGetD:aCols[_nx][nUsado+1]
			Loop
		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o campo código está preenchido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(oGetD:aCols[_nx][nPosCod])
			Aviso("A0002TOK","Campo Grupo de Produtos Obrigatorio no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf

		If Empty(oGetD:aCols[_nx][nPosFim])
			Aviso("A0002TOK","Campo Grupo de Produtos Final Obrigatorio no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o Grupo Inicial é menor ou igual ao grupo Final³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oGetD:aCols[_nx][nPosCod] > oGetD:aCols[_nx][nPosFim]
			Aviso("A0002TOK","Grupo Inicial não pode ser maior que o grupo final no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o registro já existe na GetDados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _ny := 1 to len(oGetD:aCols)
			If _ny == _nx .or. oGetD:aCols[_ny][nUsado + 1]
				Loop
			ElseIf (Alltrim(oGetD:aCols[_nx][nPosCod]) >= Alltrim(oGetD:aCols[_ny][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[_nx][nPosCod]) <= Alltrim(oGetD:aCols[_ny][nPosFim])  ) .or. ;
					(Alltrim(oGetD:aCols[_nx][nPosFim]) >= Alltrim(oGetD:aCols[_ny][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[_nx][nPosFim]) <= Alltrim(oGetD:aCols[_ny][nPosFim])  )
				Aviso("A0002TOK","Range de Produtos em duplicidade nos  itens " + Alltrim(oGetD:aCols[_ny][nPosItem]) + " e " +;
					Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Restaura a Ordem Original dos Arquivos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RestOrd(aOrdBKP)
				DbSelectArea(cAliasBKP)

				Return .F.
			Endif
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o range de grupos de produtos já foi utilizado para outro aprovador.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT ZZI_CODGRP, ZZI_ITEM FROM " + cNameZZI + " ZZI "
		cQuery += "WHERE ( '" + oGetD:aCols[_nx][nPosCod] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM "
		cQuery += "OR '" + oGetD:aCols[_nx][nPosFim] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM ) "
		cQuery += "AND ZZI_CODGRP <> '" + M->ZZH_CODGRP + "' "
		cQuery += "AND ZZI_FILIAL = '" + cFilZZI + "' "
		cQuery += "AND ZZI.D_E_L_E_T_ <> '*' "

		TcQuery cQuery ALIAS &(cAliasTRB) NEW

		While (cAliasTRB)->(!Eof())
			cGrpErr += cGrpErr += "Grupo: " + (cAliasTRB)->ZZI_CODGRP + " - Item: " + (cAliasTRB)->ZZI_ITEM + Chr(13) + Chr(10)
			(cAliasTRB)->(DbSkip())
		EndDo

		(cAliasTRB)->(DbCloseArea())

		If !Empty(cGrpErr)
			Aviso("A0002TOK","O range de grupo de produtos do item " + Alltrim(oGetD:aCols[_nx][nPosItem]) + ;
				" conflita com o range dos seguintes grupos de aprovacao: " + ;
				Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf
	Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos Arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A0002FOK  ºAutor  ³Veti FSW            º Data ³  16/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de Validação de Campos(FieldOk)                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³UAM                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*                      
User Function A0002FOK()

Local lRet		:= .T.        
Local cAliasBKP	:= Alias()    
Local aOrdBKP   := SaveOrd({"ZZI"})
Local cFilZZI	:= xFilial("ZZI")
Local nPosCod 	:= GdFieldPos("ZZI_GRPPRD",oGetD:aHeader)
Local nPosFim 	:= GdFieldPos("ZZI_GRPFIM",oGetD:aHeader)
Local nPosItem 	:= GdFieldPos("ZZI_ITEM",oGetD:aHeader)
Local nLinCod 	:= 0
Local cQuery	:= ""
Local cAliasTRB	:= GetNextAlias()
Local cNameZZI	:= RetSQLName("ZZI")
Local cFilZZI	:= xFilial("ZZI")
Local cGrpErr	:= ""


	If Alltrim(ReadVar()) == "M->ZZI_GRPPRD" .and. !oGetD:aCols[oGetD:nAt][nUsado + 1] .and. !Empty(Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o registro já existe na GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nx := 1 to len(oGetD:aCols)
			If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
			ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
			Aviso("A0002FOK","Grupo de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)
			Return .F.
				Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o range de grupos de produtos já foi utilizado para outro aprovador.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT ZZI_CODGRP FROM " + cNameZZI + " ZZI "
		cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosCod] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM )"
		cQuery += "AND ZZI_CODGRP <> '" + M->ZZH_CODGRP + "' "
		cQuery += "AND ZZI_FILIAL = '" + cFilZZI + "' "
		cQuery += "AND ZZI.D_E_L_E_T_ <> '*' "         
		
		TcQuery cQuery ALIAS &(cAliasTRB) NEW
		
			While (cAliasTRB)->(!Eof())
			cGrpErr += (cAliasTRB)->ZZI_CODGRP + Chr(13) + Chr(10)
			(cAliasTRB)->(DbSkip())	
			EndDo
		
		(cAliasTRB)->(DbCloseArea())
		
			If !Empty(cGrpErr)
			Aviso("A0002FOK","Esse range de grupo de produtos conflita com o range dos seguintes grupos de aprovacao: " + ;
							Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)

			Return .F.
			EndIf
		Next
	EndIf

	If Alltrim(ReadVar()) == "M->ZZI_GRPFIM" .and. !oGetD:aCols[oGetD:nAt][nUsado + 1] .and. !Empty(Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o registro já existe na GetDados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nx := 1 to len(oGetD:aCols)
			If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
			ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
			Aviso("A0002FOK","Grupo de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)
						
			Return .F.
				Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o range de grupos de produtos já foi utilizado para outro aprovador.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "SELECT ZZI_CODGRP FROM " + cNameZZI + " ZZI "
		cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosFim] + "'  BETWEEN ZZI_GRPPRD AND ZZI_GRPFIM) "
		cQuery += "AND ZZI_CODGRP <> '" + M->ZZH_CODGRP + "' "
		cQuery += "AND ZZI_FILIAL = '" + cFilZZI + "' "
		cQuery += "AND ZZI.D_E_L_E_T_ <> '*' "         
		
		TcQuery cQuery ALIAS &(cAliasTRB) NEW
		
			While (cAliasTRB)->(!Eof())
			cGrpErr += (cAliasTRB)->ZZI_CODGRP + Chr(13) + Chr(10)
			(cAliasTRB)->(DbSkip())	
			EndDo
		
		(cAliasTRB)->(DbCloseArea())
		
			If !Empty(cGrpErr)
			Aviso("A0002FOK","Esse range de grupo de produtos conflita com o range dos seguintes grupos de aprovacao: " + ;
							Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Restaura a Ordem Original dos Arquivos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)							
			Return .F.
			EndIf
		          
		Next
	EndIf


RestOrd(aOrdBKP)
                                                      
Return lRet
                                                      */

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
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZH","ZZI"})
	Local cFilZZH	:= xFilial("ZZH")
	Local cFilZZI	:= xFilial("ZZI")
	Local lInclui	:= .F.
	Local nPosItem	:= GdFieldPos("ZZI_ITEM",oGetD:aHeader)
	Local _nx		:= 0
	Local _ny		:= 0

	Default nOption	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se a Opçao foi informada corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption <= 2 .or. nOption >= 6
		Aviso("PRTA0002 - GravaCad","Opção de gravação não Informada corretamente!",{"Ok"})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura a Ordem Original dos Arquivos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

	ZZH->(DbSetOrder(1))
	ZZI->(DbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Em caso de Inclusão, verifica se o registro já existe nas tabelas. Se existir, aborta a rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption == 3 .AND. (ZZH->(DbSeek(cFilZZH + M->ZZH_CODGRP)) .OR. ZZI->(DbSeek(cFilZZI + M->ZZH_CODGRP)))
		Aviso("PRTA0002 - GravaCad","Registro já existente. Entre em contato com Administrador!",{"Ok"})

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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Em caso de Inclusão ou Alteração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOption == 3 .or. nOption == 4

		DbSelectArea("ZZH")
		ZZH->(DbSetOrder(1))
		lInclui := !ZZH->(DbSeek(cFilZZH + M->ZZH_CODGRP))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a Gravação do Cabeçalho (Aprovador)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If RecLock("ZZH",lInclui)
			If Inclui
				ZZH->ZZH_FILIAL := cFilZZH
			Endif

			For _nx := 1 to ZZH->(Fcount())
				If Alltrim(ZZH->(FieldName(_nx))) <> "ZZH_FILIAL"
					ZZH->&(FieldName(_nx)) := M->&(FieldName(_nx))
				Endif
			Next
			ZZH->(MsUnLock())
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Efetua a Gravação dos Itens (Solicitantes)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("ZZI")
		ZZI->(DbSetOrder(1))
		For _ny := 1 to len(oGetD:aCols)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se a linha não estiver excluida, prossegue com a Inclusão³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !oGetD:aCols[_ny][nUsado + 1]

				lInclui := !ZZI->(DbSeek(cFilZZI + M->ZZH_CODGRP + oGetD:aCols[_ny][nPosItem]))

				If RecLock("ZZI",lInclui)
					If lInclui
						ZZI->ZZI_FILIAL := cFilZZI
						ZZI->ZZI_CODGRP	:= M->ZZH_CODGRP
					Endif

					For _nx := 1 to ZZI->(Fcount())
						If !Alltrim(ZZI->(FieldName(_nx))) $ "ZZI_FILIAL|ZZI_CODGRP"
							nFieldAtu := GdFieldPos(Alltrim(ZZI->(FieldName(_nx))),oGetD:aHeader)
							If nFieldAtu <> 0
								ZZI->&(FieldName(_nx)) := oGetD:aCols[_ny][nFieldAtu]
							Endif
						Endif
					Next
					ZZI->(MsUnLock())
				EndIf
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Se o registro estiver deletado na GetDados e existir na base, efetua a exclusão³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ZZI->(DbSeek(cFilZZI + M->ZZH_CODGRP + oGetD:aCols[_ny][nPosItem]))
					If RecLock("ZZI",.F.)
						ZZI->(DbDelete())
						ZZI->(MsUnLock())
					EndIf
				Endif

			Endif
		Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente em Caso de Exclusão das rotinas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf nOption == 5

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exclui o cabeçalho do cadastro(Aprovador)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ZZH->(DbSetOrder(1))

		If ZZH->(DbSeek(cFilZZH + M->ZZH_CODGRP))
			If RecLock("ZZH",.F.)
				ZZH->(DbDelete())
				ZZH->(MsUnLock())
			EndIf
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Exclui os itens do cadastro (Solicitante)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ZZI->(DbSetOrder(1))
		ZZI->(DbSeek(cFilZZI + M->ZZH_CODGRP))
		While ZZI->(!Eof()) .AND. ZZI->ZZI_FILIAL = cFilZZI .AND. Alltrim(ZZI->ZZI_CODGRP) == Alltrim(M->ZZH_CODGRP)
			If RecLock("ZZI",.F.)
				ZZI->(DbDelete())
				ZZI->(MsUnLock())
			Endif
			ZZI->(DbSkip())
		EndDo
	Else
		Aviso("PRTA0002 - GravaCad","Opção de gravação não Informada corretamente!",{"Ok"})

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
