#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "TopConn.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱﾉﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｻｱｱ
ｱｱｺPrograma  ｳPRTA0001  ｺAutor  ｳBruno Roberto       ｺ Data ｳ  11/07/11   ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺDesc.     ｳ Realiza a gera鈬o do pedido de venda com base nas regras   ｺｱｱ
ｱｱｺ          ｳ de cr馘ito determinadas.                                    ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺUso       ｳ AP                                                        ｺｱｱ
ｱｱﾈﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍnﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｼｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟ
*/
User Function PRTA0001()

	Local cAlias := "ZZD"
	Private cCadastro  := "Manuten鈬o de Embalagens"
	Private aRotina:= MenuDef()
	Private aPedCab := {}
	Private aPedIt  := {}
	Private nOpc := 0

//ﾚﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄｿ
//ｳ Endereca a funcao de BROWSE                                  ｳ
//ﾀﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾙ
	dbSelectArea("ZZD")
	dbSetOrder(1)

	mBrowse( 6, 1,22,75,cAlias,,,,,,)

Return

/*
ﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱﾉﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｻｱｱ
ｱｱｺPrograma  ｳPRTA0001  ｺAutor  ｳMicrosiga           ｺ Data ｳ  09/11/11   ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺDesc.     ｳ                                                            ｺｱｱ
ｱｱｺ          ｳ                                                            ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺUso       ｳ AP                                                        ｺｱｱ
ｱｱﾈﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｼｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟ
*/
User Function PRTA001(cAlias,nReg,nOpc)


/*ﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾙｱｱ
ｱｱ Declara鈬o de cVariable dos componentes                                 ｱｱ
ﾙｱｱﾀﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄ*/

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

/*ﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾙｱｱ
ｱｱ Declara鈬o de Variaveis Private dos Objetos                             ｱｱ
ﾙｱｱﾀﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄ*/
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

/*ﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾙｱｱ
ｱｱ Definicao do Dialog e todos os seus componentes.                        ｱｱ
ﾙｱｱﾀﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾁﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄﾄ*/
aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 200, 100, .T., .T. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

                                                                  
DEFINE MSDIALOG oDlg1 TITLE "Cadastro de Embalagens" FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL

Enchoice( "ZZD", ZZD->(Recno()), nOpc, , , , , {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]}, , 1, , ,"AllwaysTrue()", oDlg1, .F.,  .T., .F., , .F., .F.)

oBrw1 := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"U_PRTALOK()",'AllwaysTrue()',cIniPos,,0,99999,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1 )

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1, { || IIF(Obrigatorio(aGets,aTela) .and. U_PRTALOK(.T.),(Grava(nOpc),oDlg1:End()),.F.) }, { || RollBackSX8(),oDlg1:End() })

Return


/*
ﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱﾉﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｻｱｱ
ｱｱｺPrograma  ｳGrava     ｺAutor  ｳMicrosiga           ｺ Data ｳ  08/09/11   ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺDesc.     ｳ Grava o cabecalho e os Itens do Cadastro Embalagens        ｺｱｱ
ｱｱｺ          ｳ                                                            ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺUso       ｳ AP                                                        ｺｱｱ
ｱｱﾈﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｼｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟ
*/
Static Function Grava(nOpc)

	Local cFilZZD	:= xFilial("ZZD")
	Local cFilZZE	:= xFilial("ZZE")
	Local lInclui	:= .F.
	Local nPosItem	:= GdFieldPos("ZZE_ITEM",oBrw1:aHeader)
	Local nPosCod 	:= GdFieldPos("ZZE_GRUPO",oBrw1:aHeader)
	Local nFieldAtu := 0
	Local _nx 		:= 0
	Local _ny		:= 0

	If nOpc == 3 .or. nOpc == 4

		Begin Transaction

			DbSelectArea("ZZD")
			ZZD->(DbSetOrder(1))
			lInclui := !ZZD->(DbSeek(cFilZZD + M->ZZD_CODIGO))
			M->ZZD_CUBAGE := M->ZZD_COMP * M->ZZD_LARG * M->ZZD_ALT

			///ャャャャャャャャャャャャャャャャャャャャャ�
			//=Efetua a Gravaﾁ�o do Cabeﾁalho 			 =
			//ｿャャャャャャャャャャャャャャャャャャャャャ�

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

			///ャャャャャャャャャャャャャャャャャャャャャ�
			//=Efetua a Gravaﾁ�o dos Itens 				 =
			//ｿャャャャャャャャャャャャャャャャャャャャャ�

			DbSelectArea("ZZE")
			ZZE->(DbSetOrder(1))
			For _ny := 1 to len(oBrw1:aCols)

				///ャャャャャャャャャャャャャャャャャャャャャャャャャャャャ��
				//=Se a linha n�o estiver excluida, prossegue com a Inclus�o=
				//ｿャャャャャャャャャャャャャャャャャャャャャャャャャャャャ��

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

					///ャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャ��
					//=Se o registro estiver deletado na GetDados e existir na base, efetua a exclus�o=
					//ｿャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャャΑ

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

		///ャャャャャャャャャャャャャャャャャャャャ��
		//=Exclui o cabeﾁalho do cadastro(Aprovador)=
		//ｿャャャャャャャャャャャャャャャャャャャャΑ
		ZZD->(DbSetOrder(1))

		If ZZD->(DbSeek(cFilZZD + M->ZZD_CODIGO))
			If RecLock("ZZD",.F.)
				ZZD->(DbDelete())
				ZZD->(MsUnLock())
			EndIf
		Endif

		///ャャャャャャャャャャャャャャャャャャャャ��
		//=Exclui os itens do cadastro (Solicitante)=
		//ｿャャャャャャャャャャャャャャャャャャャャΑ
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
給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給給�
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱ�ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ臨ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾀﾕﾕﾕﾕﾕﾕﾕ臨ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾀﾕﾕﾕﾕﾕﾕ臨ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕｪｱｱ
ｱｱ?Programa  =LinhaOK   ?Autor  =Microsiga           ? Data =  08/09/11   ?ｱｱ
ｱｱﾃﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ�ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ�ﾕﾕﾕﾕﾕﾕﾕ慝ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ�ﾕﾕﾕﾕﾕﾕ慝ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕpｱｱ
ｱｱ?Desc.     = Valida se o grupo produtos ja foi digitado em outra linha  ?ｱｱ
ｱｱ?          =                                                            ?ｱｱ
ｱｱﾃﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ�ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕpｱｱ
ｱｱ?Uso       = AP                                                        ?ｱｱ
ｱｱｻﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕ慝ﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕﾕｺｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
?????????????????????????????????????????????????????????????????????????????
*/

User Function PRTALOK(lBtOk)

	Local nPosCod 	:= GdFieldPos("ZZE_GRUPO",oBrw1:aHeader)
	Local _nx := 0

	Default lBtOk := .F.

	If !lBtOk
		If Empty(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Aviso("PRTALOK","Codigo do grupo de produtos em branco",{"Ok"})
			Return .F.
		Endif
	Else
		If Len(oBrw1:aCols) <> 1 .and. Empty(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Aviso("PRTALOK","Codigo do grupo de produtos em branco",{"Ok"})
			Return .F.
		Endif
	Endif

	For _nx := 1 to len(oBrw1:aCols)
		If _nx == oBrw1:nAt .or. oBrw1:aCols[_nx][noBrw1 + 1] .or. Alltrim(oBrw1:aCols[_nx][nPosCod]) <> Alltrim(oBrw1:aCols[oBrw1:nAt][nPosCod])
			Loop
		Else
			Aviso("PRTALOK","C�digo do Grupo de Produtos j� Informado!",{"Ok"})
			Return .F.
		Endif
	Next

Return .T.



/*
ﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜﾜ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ｱｱﾉﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾋﾍﾍﾍﾍﾍﾍﾑﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｻｱｱ
ｱｱｺPrograma  ｳPRTA0001  ｺAutor  ｳMicrosiga           ｺ Data ｳ  09/11/11   ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾊﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺDesc.     ｳ                                                            ｺｱｱ
ｱｱｺ          ｳ                                                            ｺｱｱ
ｱｱﾌﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾘﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｹｱｱ
ｱｱｺUso       ｳ AP                                                        ｺｱｱ
ｱｱﾈﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾏﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍﾍｼｱｱ
ｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱｱ
ﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟﾟ
*/
Static Function MenuDef()

	Private aRotina:= {{"Pesquisar" ,"AxPesqui"    ,0,1},;
		{"Visualizar" ,"U_PRTA001",0,2},;
		{"Incluir"  ,"U_PRTA001",0,3},;
		{"Alterar"   ,"U_PRTA001",0,4},;
		{"Excluir"   ,"U_PRTA001",0,5}}

Return(aRotina)
