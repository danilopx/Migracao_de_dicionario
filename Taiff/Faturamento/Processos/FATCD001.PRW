#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "TopConn.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³FATCD001  ºAutor  ³Thiago Comelli      º Data ³  23/01/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Manutencao do cadastro de embalagens						    º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP 10                                                      º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝnÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATCD001()

	Local cAlias := "ZZD"
	Private cCadastro  := "Manutenção de Embalagens"
	Private aRotina:= MenuDef()
	Private aPedCab := {}
	Private aPedIt  := {}
	Private nOpc := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZZD")
	dbSetOrder(1)

	mBrowse( 6, 1,22,75,cAlias,,,,,,)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³FATCD1  ºAutor  ³Microsiga           º Data ³  09/11/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATCD1(cAlias,nReg,nOpc)


/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Local cIniPos    := "+ZZE_ITEM"                                                                                                                           	
Local cAliasE    := "ZZD"  //Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local cAliasI    := "ZZE" 
Local aObjects  := {}                  // dimensiona a tela
Local aPosObj   := {}                  // dimenisona a tela    
Local aCoBrw1 := {}
Local aHoBrw1 := {}
Local nOpcoes 	:= 0
Local nLinha := 0
Local _nx := 0

Private INCLUI	:= IIF(nOpc == 3,.T.,.F.)
Private aGets   := {}
Private aTela   := {} 
Private noBrw1	:= 0

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oPanel1","oBrw1")


nOpcoes := Iif(nOpc == 3 .or. nOpc == 4,GD_INSERT + GD_DELETE + GD_UPDATE,0)

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("ZZE")
	While !Eof() .and. SX3->X3_ARQUIVO == "ZZE"
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
      noBrw1++
      Aadd(aHoBrw1,{Trim(X3Titulo()),;
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
		EndIf
   DbSkip()
	End

RegToMemory(cAliasE, INCLUI)
RegToMemory(cAliasI, .F.)
SX3->(DbSetOrder(2))

ZZE->(DbSetOrder(1))
ZZE->(DbSeek(xFilial("ZZE") + M->ZZD_CODIGO))
    
	While ZZE->(!Eof()) .AND. M->ZZD_CODIGO == ZZE->ZZE_CODIGO

	Aadd(aCoBrw1,Array(noBrw1+1))
	nLinha:=len(aCoBrw1)
	aCoBrw1[nLinha][noBrw1 + 1] := .F.

		For _nx := 1 to len(aHoBrw1)
			If SX3->(DbSeek(aHoBrw1[_nx][2]))
			CriaVar(aHoBrw1[_nx][2],.T.) 
				if aHoBrw1[_nx][10] <> "V"
				M->&(aHoBrw1[_nx][2]) := ZZE->&(aHoBrw1[_nx][2])			
				aCoBrw1[nLinha][_nx] := ZZE->&(aHoBrw1[_nx][2])
				Else
				aCoBrw1[nLinha][_nx] := &(SX3->X3_RELACAO)
				Endif
			EndIf
		Next
	ZZE->(DbSkip())
	EndDo

	If Empty(aCoBrw1)
	Aadd(aCoBrw1,Array(noBrw1+1)) 
	
		For _nx := 1 to len(aHoBrw1)
			If SX3->(DbSeek(aHoBrw1[_nx][2]))
			CriaVar(aHoBrw1[_nx][2],.T.) 			
				If Alltrim(SX3->X3_CAMPO) == "ZZE_ITEM"
				aCoBrw1[len(aCoBrw1)][_nx] := SomaIt(StrZero(0,len(M->ZZE_ITEM)))
				Else
				aCoBrw1[len(aCoBrw1)][_nx] := CriaVar(aHoBrw1[_nx][2],.T.) 
				EndIf
			EndIf
		Next

	aCoBrw1[1][noBrw1+1] := .F.

	EndIf

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 200, 100, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

                                                                  
DEFINE MSDIALOG oDlg1 TITLE "Cadastro de Embalagens" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

Enchoice( "ZZD", ZZD->(Recno()), nOpc, , , , , {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]}, , 1, , ,"AllwaysTrue()", oDlg1, .F.,  .T., .F., , .F., .F.)

oBrw1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"U_FATCD1LOK()",'AllwaysTrue()',cIniPos,,0,99999,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1, { || IIF(Obrigatorio(aGets,aTela) .and. U_FATCD1LOK(.T.),(Grava(nOpc),oDlg1:End()),.F.) }, { || RollBackSX8(),oDlg1:End() })

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³Grava     ºAutor  ³Microsiga           º Data ³  08/09/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Grava o cabecalho e os Itens do Cadastro Embalagens        º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Grava(nOpc)

	Local cFilZZD	:= xFilial("ZZD")
	Local cFilZZE	:= xFilial("ZZE")
	Local lInclui	:= .F.
	Local nPosItem	:= GdFieldPos("ZZE_ITEM",oBrw1:aHeader)
	Local nPosCod 	:= GdFieldPos("ZZE_GRUPO",oBrw1:aHeader)
	Local nFieldAtu := 0
	Local _nx := 0
	Local _ny := 0

	If nOpc == 3 .or. nOpc == 4

		Begin Transaction

			DbSelectArea("ZZD")
			ZZD->(DbSetOrder(1))
			lInclui := !ZZD->(DbSeek(cFilZZD + M->ZZD_CODIGO))
			M->ZZD_CUBAGE := M->ZZD_COMP * M->ZZD_LARG * M->ZZD_ALT

			///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//=Efetua a GravaÝ„o do CabeÝalho 			 =
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			If RecLock("ZZD",lInclui)

				If Inclui
					ZZD->ZZD_FILIAL := cFilZZD
				Endif

				For _nx := 1 to ZZD->(Fcount())
					If Alltrim(ZZD->(FieldName(_nx))) <> "ZZD_FILIAL"
						ZZD->&(FieldName(_nx)) := M->&(FieldName(_nx))
					Endif

				Next
				ZZD->(MsUnLock())
				ConfirmSX8()
			Endif

			///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
			//=Efetua a GravaÝ„o dos Itens 				 =
			//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

			DbSelectArea("ZZE")
			ZZE->(DbSetOrder(1))
			For _ny := 1 to len(oBrw1:aCols)

				///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
				//=Se a linha n„o estiver excluida, prossegue com a Inclus„o=
				//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

				If !oBrw1:aCols[_ny][noBrw1 + 1] .and. !Empty(oBrw1:aCols[_ny][nPosCod])

					lInclui := !ZZE->(DbSeek(cFilZZE + M->ZZD_CODIGO + oBrw1:aCols[_ny][nPosItem]))

					If RecLock("ZZE",lInclui)

						If lInclui
							ZZE->ZZE_FILIAL := cFilZZE
							ZZE->ZZE_CODIGO	:= M->ZZD_CODIGO
						Endif

						For _nx := 1 to ZZE->(Fcount())
							If !Alltrim(ZZE->(FieldName(_nx))) $ "ZZE_FILIAL|ZZE_CODIGO"

								nFieldAtu := GdFieldPos(Alltrim(ZZE->(FieldName(_nx))),oBrw1:aHeader)

								If nFieldAtu <> 0

									ZZE->&(FieldName(_nx)) := oBrw1:aCols[_ny][nFieldAtu]

								Endif

							Endif

						Next

						ZZE->(MsUnLock())

					EndIf

				Else

					///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
					//=Se o registro estiver deletado na GetDados e existir na base, efetua a exclus„o=
					//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

					If ZZE->(DbSeek(cFilZZE + M->ZZD_CODIGO + oBrw1:aCols[_ny][nPosItem]))
						If RecLock("ZZE",.F.)
							ZZE->(DbDelete())
							ZZE->(MsUnLock())
						EndIf
					Endif

				Endif
			Next

		End Transaction

	Elseif nOpc == 5

		///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//=Exclui o cabeÝalho do cadastro(Aprovador)=
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		ZZD->(DbSetOrder(1))

		If ZZD->(DbSeek(cFilZZD + M->ZZD_CODIGO))
			If RecLock("ZZD",.F.)
				ZZD->(DbDelete())
				ZZD->(MsUnLock())
			EndIf
		Endif

		///ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//=Exclui os itens do cadastro (Solicitante)=
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		ZZE->(DbSetOrder(1))
		ZZE->(DbSeek(cFilZZE + M->ZZD_CODIGO))

		While ZZE->(!Eof()) .AND. ZZE->ZZE_FILIAL = cFilZZE .AND. Alltrim(ZZE->ZZE_CODIGO) == Alltrim(M->ZZD_CODIGO)
			If RecLock("ZZE",.F.)
				ZZE->(DbDelete())
				ZZE->(MsUnLock())
			Endif
			ZZE->(DbSkip())
		EndDo

	Endif

Return .T.

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±?Programa  =LinhaOK   ?Autor  =Microsiga           ? Data =  08/09/11   ?±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕp±±
±±?Desc.     = Valida se o grupo produtos ja foi digitado em outra linha  ?±±
±±?          =                                                            ?±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕp±±
±±?Uso       = AP                                                        ?±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
?????????????????????????????????????????????????????????????????????????????
*/

User Function FATCD1LOK(lBtOk)

	Local nPosCod 	:= GdFieldPos("ZZE_GRUPO",oBrw1:aHeader)
	Local _nx := 0

	Default lBtOk := .F.

	If !lBtOk
		If Empty(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Aviso("FATCD1LOK","Codigo do grupo de produtos em branco",{"Ok"})
			Return .F.
		Endif
	Else
		If Len(oBrw1:aCols) <> 1 .and. Empty(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Aviso("FATCD1LOK","Codigo do grupo de produtos em branco",{"Ok"})
			Return .F.
		Endif
	Endif

	For _nx := 1 to len(oBrw1:aCols)
		If _nx == oBrw1:nAt .or. oBrw1:aCols[_nx][noBrw1 + 1] .or. Alltrim(oBrw1:aCols[_nx][nPosCod]) <> Alltrim(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Loop
		Else
			Aviso("FATCD1LOK","Código do Grupo de Produtos já Informado!",{"Ok"})
			Return .F.
		Endif
	Next

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³MenuDef  ºAutor  ³Microsiga           º Data ³  09/11/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()

	Private aRotina:= {{"Pesquisar" ,"AxPesqui"    ,0,1},;
		{"Visualizar" ,"U_FATCD1",0,2},;
		{"Incluir"  ,"U_FATCD1",0,3},;
		{"Alterar"   ,"U_FATCD1",0,4},;
		{"Excluir"   ,"U_FATCD1",0,5}}

Return(aRotina)
