#include "protheus.ch"
#include "RwMake.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/* Protheus.doc JURAT001
Manutenção de dados em ZA0-Indices Financeiros.

Author    pbindo
Version   11.3.2.201607211753
Since     23/09/2016
*/

user function JURAT001()
	//-- variáveis -------------------------------------------------------------------------

	//Trabalho/apoio
	//local aCampos := nil 
	//local cCampo := ""
	Local aCores := {}

	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	private cDelFunc := ".T." // Operacao: EXCLUSAO
	private cCadastro := "Indices Financeiros" //Título das operações

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
	{"Visualizar","AxVisual",0,2} ,; 
	{"Incluir","U_JUR01INC",0,3} ,;
	{"Alterar","U_JUR01INC",0,4} ,;	
	{"Excluir","U_JUR01INC",0,5}}

	Private lWizard := .F.
	Private cFilCal := xFilial("ZA0")
	
	chkFile("ZA0")
	dbSelectArea("ZA0")
	ZA0->(dbSetOrder(1))

	mBrowse(6,1,22,75,"ZA0",,,,,,aCores)


return

//------------------------------------------------------------------------------------------
/* Protheus.doc JUR01INC

INCLUSAO INDICES FINANCEIROS

Author    pbindo
Version   11.3.2.201607211753
Since     23/09/2016

*/


User Function JUR01INC(cAlias,nReg,nOpc)
	Local cVar := ""
	Local nB := 0
	Local nI := 0
	Local nA
	Local oDlg
	//Local oCalendCTB
	Local oGet
	Local dData
	Local cExerc	:= Str(Year(dDataBase),4)
	Local nOpca 	:= 0
	Local cTab 		

	Private aTELA[0][0],aGETS[0],aHeader[0]
	Private aCols	:= {}
	Private nUsado := 0
	Private cNome
	Private oNome
	
	If nOpc == 3 //INCLUIR
		cExerc	:= CriaVar("ZA0_EXERC")
		cNome	:= CriaVar("ZA0_NOME")
		cTab	:= CriaVar("ZA0_CODTAB")
		
	Else
		cExerc		:= ZA0->ZA0_EXERC
		cNome		:= ZA0->ZA0_NOME
		cTab		:= ZA0->ZA0_CODTAB
	EndIf

	JURAhead()
	JURAcols(nOpc,cExerc,cTab)

	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Cadastro Indices") FROM 9,0 TO 23,80 OF oMainWnd 

	@ 005,010 Say OemToAnsi("Tabela") OF oDlg PIXEL
	@ 005,035 MSGET cTab F3 "ZE" When nOpc == 3 Valid NaoVazio(cTab)  .And. FreeForUse("ZA0",cTab) .And. JURCNOME(cTab) SIZE 020,08 OF oDlg PIXEL

	@ 005,075 Say OemToAnsi("Indice") OF oDlg PIXEL
	@ 005,090 MSGET oNome Var cNome When .F. SIZE 060,08 OF oDlg PIXEL

	@ 005,150 Say OemToAnsi("Exercicio") OF oDlg PIXEL
	@ 005,185 MSGET cExerc When nOpc == 3 Valid NaoVazio(cExerc) SIZE 035,08 OF oDlg PIXEL
	//@ 005,150 MSGET cExerc  Valid NaoVazio(cExerc) SIZE 035,08 OF oDlg PIXEL

	oCalend:=MsCalend():New(20,0,oDlg)

	oCalend:bChange := {|| JURAt010ChgDia(@oCalend,@oGet,@dData), oDlg:Refresh()}
	//oGet := MSGetDados():New(020,140,86,314,nOpc,"Ct010LinOK","Ct010TudOK","+ZA0_PERIOD",.T.)					
	oGet := MSGetDados():New(020,140,86,314,nOpc,"U_JurLinOK()","AllwaysTrue","+ZA0_PERIOD",.T.)

	//DEFINE SBUTTON FROM 090, 260 TYPE 1 ACTION (nOpca:=1,Iif(Ct010TudOk(nOpc),oDlg:End(),nOpca:=0)) ENABLE Of oDlg
	DEFINE SBUTTON FROM 090, 260 TYPE 1 ACTION (nOpca:=1,oDlg:End()) ENABLE Of oDlg

	DEFINE SBUTTON FROM 090, 290 TYPE 2 ACTION oDlg:End() ENABLE Of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	nA := 0

	If nOpca == 1

		If nOpc == 3 //INCLUSAO
			For nA:=1 To Len(aCols)
				If !( aCols[nA][Len(aHeader)+1] )
					nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZA0_PERIOD" })
					If  !Empty(aCols[nA,nI])
						RecLock("ZA0",.T.)
						ZA0_CODTAB:= cTab
						ZA0_NOME  := cNome 
						ZA0_EXERC := cExerc
						For nB:=1 To Len(aHeader)
							cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
							xConteudo := aCols[ nA, cVar ]
							cCampo := AllTrim(aHeader[nB][2])
							Replace &cCampo With xConteudo
						Next
						ZA0->(MsUnlock())
					EndIf
				EndIf
			Next	
		ElseIf nOpc == 4 //ALTERACAO
			nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZA0_PERIOD" })
			cItem := aCols[1,nI]
			dbSelectArea("ZA0")
			dbSetOrder(1)
			dbSeek(xFILIAL()+cTab+cExerc+cItem)
			While !EOF() .And. ZA0_CODTAB == cTab .And. cExerc == ZA0->ZA0_EXERC
				For nA:=1 To Len(aCols)
					nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZA0_PERIOD" })
					If  !Empty(aCols[nA,nI])
						//nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZA0_PERIOD" })
						If aCols[nA,nI] == ZA0->ZA0_PERIOD
							If !( aCols[nA][Len(aHeader)+1] )	//GRAVA OS CAMPOS DA LINHA
								RecLock("ZA0",.F.)
								For nB:=1 To Len(aHeader)
									cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
									xConteudo := aCols[ nA, cVar ]
									cCampo := AllTrim(aHeader[nB][2])
									Replace &cCampo With xConteudo
								Next
								ZA0->(MsUnlock())
							EndIf
							dbSkip()
							Loop
						Else	//INCLUI O NOVO REGISTRO
							RecLock("ZA0",.T.)
							ZA0_CODTAB:= cTab
							ZA0_NOME  := cNome 
							ZA0_EXERC := cExerc
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
							ZA0->(MsUnlock())
							dbSkip()
							Loop
						EndIf
					EndIf

				Next
			End		
		ElseIf nOpc == 5 //EXCLUSAO
			dbSelectArea("ZA0")
			dbSetOrder(1)
			If dbSeek(xFILIAL()+cTab+cExerc)
				While !Eof() .And. ZA0_CODTAB == cTab .And. cExerc == ZA0->ZA0_EXERC
					RecLock("ZA0",.F.)
					dbDelete()
					ZA0->(MsUnLock())
					dbSkip()
				End
			EndIf

		EndIf
	EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³At010ChgDi³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 17.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastrar cotacoes no dia escolhido                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³At010ChgDi(oCalend,oGet,dData)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto Calendario                                  ³±±
±±³          ³ ExpO2 = Objeto Getdados                                    ³±±
±±³          ³ ExpD1 = Data Selecionada                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function JURAt010ChgDia(oCalend,oGet,dData)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³   JURAhea³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 17.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera matriz Aheader - para montagem posterior da acols     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³JURAhea()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function JURAhead()

	Local aSaveArea := GetArea()

	Default lWizard := .F.

	dbSelectArea("Sx3")
	dbSetOrder(1)

	dbseek("ZA0")
	While !EOF() .And. (x3_arquivo == "ZA0")
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(X3_CAMPO) != "ZA0_EXERC" .And. Trim(X3_CAMPO) != "ZA0_NOME" .And. Trim(X3_CAMPO) != "ZA0_CODTAB"  
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
			x3_tamanho, x3_decimal, x3_valid,;
			x3_usado, x3_tipo, x3_arquivo } )
		EndIf
		DbSkip()
	EndDO

	RestArea(aSaveArea)

	If lWizard
		aHeaderSv[1] := aClone(aHeader)
	EndIf
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³JURAcol   ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 17.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera matriz ACOLS para preenchimento das cotacoes          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  JURAcol(nOpc,cExerc,cCalendCTB)  	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum		                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Opcao escolhida do menu (Inclusao / Alteracao..)   ³±±
±±³          ³ ExpC1 = Exercicio Contabil -> Ano                          ³±±
±±³          ³ ExpC2 = Calendario Contabil escolhido                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function JURAcols(nOpc,cExerc,cTab)

	Local nCont := 1
	Local cFilZA0	:= ""
	Local aSaveArea := GetArea() 

	Default cFilCal := xFilial("ZA0")
	Default lWizard := .F.

	If lWizard
		aCols			:= aClone(aColsSv[1])
	EndIf

	cFilZA0 := xFilial("ZA0",cFilCal)  

	aCols := {}

	nPosIndice	:= Ascan(aHeader,{|x|Alltrim(x[2]) = "ZA0_INDICE"})

	dbSelectArea("ZA0")
	dbSetOrder(1)
	If (nOpc == 2 .Or. nOpc == 4 .Or. nOpc == 5)  // Visualiza / Altera / Exclui
		dbSeek(cFilZA0+cTab+cExerc)
		While !Eof() .And. cFilZA0 == ZA0->ZA0_FILIAL .And.	ZA0->ZA0_EXERC == cExerc .And.	ZA0->ZA0_CODTAB == cTab 

			AADD(aCols,Array(nUsado+1))     
			aCols[nCont][1]			:= ZA0->ZA0_PERIOD
			aCols[nCont][nPosIndice]:= ZA0->ZA0_INDICE
			aCols[nCont][nUsado+1]	:= .F.

			nCont++	
			dbSkip()

		EndDo	
	ElseIf nOpc == 3				// Inclusao
		AADD(aCols,Array(nUsado+1))     
		dbSelectArea("Sx3")
		dbSetOrder(1)
		dbSeek("ZA0")
		nUsado:=0
		While !EOF() .And. (x3_arquivo == "ZA0")
			IF X3USO(x3_usado) .and. cNivel >= x3_nivel
				If Trim(X3_CAMPO) != "ZA0_EXERC" .And. Trim(X3_CAMPO) != "ZA0_NOME" .And. Trim(X3_CAMPO) != "ZA0_CODTAB"   
					nUsado++
					IF x3_tipo == "C"
						IF ExistIni(X3_CAMPO)
							aCOLS[1][nUsado]:=InitPad(SX3->X3_RELACAO)
						ELSE
							aCOLS[1][nUsado]:=SPACE(x3_tamanho)
						EndIF
					ELSEIF x3_tipo == "N"
						aCOLS[1][nUsado] := 0
					ELSEIF x3_tipo == "D"
						aCOLS[1][nUsado] := CTOD("  /  /  ")
					ELSEIF x3_tipo == "M"
						aCOLS[1][nUsado] := ""
					ELSE
						aCOLS[1][nUsado] := .F.
					ENDIF
					If x3_context == "V"
						aCols[1][nUsado] := CriaVar(allTrim(x3_campo))
					Endif	
				ENDIF
			EndIf	
			dbSkip()
		EndDo
		aCols[1][nUsado+1]	:= .F.
		aCols[1][1]			:= "01"
	EndIf

	RestArea(aSaveArea)
	If lWizard
		aColsSv[1] 	:= aClone(aCols)
	EndIf
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³JURLinOK³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 17.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida a linha da getdados                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct010LinOk()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.  		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function JurLinOK()

	Local lRet := .T.
	Local nCount := 0
	Local kk	 := 0

	For kk:=1 To Len(aCols)	
		If !(aCols[kk][Len(aHeader)+1])
			nCount ++
		EndIf		
	Next


	If nCount > 12 	
		MsgStop("Um ano só possui 12 meses","JURAT001")
		lRet := .F.
	EndIf

Return lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³JUR01CALC ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 17.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ CALCULA A RESCISAO DO REPRESENTANTE                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct010LinOk()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.  		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function JURCALC()

	Local cPerg 	:= "JUAT01"
	//Local cCount	:= 0
	Local nVezes	:= 0
	Local aTaxa		:= {}
	Local aTam 		:=  0
	Local n			:= 0
	Local nCalculo	:= 0
	Local nPos		:= 0
	Local x			:= 0
	Local aTotal	:= {}
	Local nTotal	:= 0
	Local nMedia	:= 0
	Local nIR		:= 0
	Local nLiquido	:= 0
	Local nTComis	:= 0
	Local nTBase	:= 0
	Local nTCalc	:= 0
	
	Private cArqTxt := "C:\EXCEL\JURAT001-"+mv_par03+".CSV"
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"
	MakeDir("C:\EXCEL\")

	ValidPerg(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf	



	cQuery := " SELECT A3_COD, A3_NOME, SUBSTRING(E3_EMISSAO,5,2)+'/'+LEFT(E3_EMISSAO,4) E3_EMISSAO, SUM(E3_BASE) E3_BASE, SUM(E3_COMIS) E3_COMIS FROM "+RetSqlName("SE3")+" E3"
	cQuery += " INNER JOIN "+RetSqlName("SA3")+" A3 ON A3_COD = E3_VEND "+ Iif (cEmpAnt == "03"," AND A3_FILIAL = E3_FILIAL","" )
	cQuery += " WHERE "
	cQuery += " E3_EMISSAO BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"'"
	cQuery += " AND E3_VEND = '"+mv_par03+"'"
	cQuery += " AND A3.D_E_L_E_T_ <> '*' AND E3.D_E_L_E_T_ <> '*'"
	cQuery += " AND E3_FILIAL BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
	If mv_par07 # 1
		cQuery += " AND E3_FILIAL+E3_NUM+E3_PREFIXO+E3_PARCELA IN (SELECT E1_FILIAL+E1_NUM+E1_PREFIXO+E1_PARCELA FROM "+RetSqlName("SE1")+" 
		cQuery += " WHERE E3_FILIAL+E3_NUM+E3_PREFIXO +E3_PARCELA = E1_FILIAL+E1_NUM+E1_PREFIXO+E1_PARCELA AND D_E_L_E_T_ <> '*' 
		cQuery += " AND E1_ITEMC = '"+ Iif(mv_par07==2,"TAIFF","PROART")+"')
	EndIf
	cQuery += "  GROUP BY A3_COD, A3_NOME, (SUBSTRING(E3_EMISSAO,5,2)+'/'+LEFT(E3_EMISSAO,4) ),LEFT(E3_EMISSAO,6)"
	cQuery += " ORDER BY LEFT(E3_EMISSAO,6)"

	MemoWrite("JURAT001.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBJUR",.T.,.T.)

	Count To nCount

	If nCount == 0
		MsgStop("Naõ existem dados para esta consulta","JURAT001")
		TRBJUR->(dbCloseArea())	 	
		Return
	EndIf

	dbselectArea("TRBJUR")
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		TRBJUR->(dbCloseArea())
		Return
	Endif

	cLin    := ''
	dbSelectArea("SM0")
	//NOME DO REPRESENTANTE E EMPRESA
	cLin 	+= 'Cálculos de Rescisão do Representante :'+AllTrim(TRBJUR->A3_NOME)+' – Empresa :'+AllTrim(SM0->M0_NOME)+' - Area Negócio :'+Iif(mv_par07==1,"TAIFF E PROART",Iif(mv_par07==2,"TAIFF","PROART"))
	cLin 	+= cEOL
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	dbselectArea("TRBJUR")
	For n := 1 to FCount()
		aTam := TamSX3(FieldName(n))
		If !Empty(aTam) .and. aTam[3] $ "N/D" .And. FieldName(n) # "E3_EMISSAO"
			TCSETFIELD('TRBJUR',FieldName(n),aTam[3],aTam[1],aTam[2])
		EndIf
	Next

		
	cLin    := ''
	For n := 1 to FCount()

		If !FieldName(n) $ "R_E_C_N_O_|R_E_C_D_E_L_"
			cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
			cLin += ';'
		EndIf

	Next
	//ADICIONA CAMPOS DE FORA DA QUERY
	cLin += ''
	cLin += ';'
	cLin += ''
	cLin += ';'
	cLin += AllTrim("")
	cLin += ';'
	cLin += AllTrim("Total")
	cLin += cEOL //ULTIMO ITEM


	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif





	//PRECISA PEGAR A TAXA DO MES ANTERIOR
//	dDataMin := stod(TRBJUR->E3_EMISSAO+"01") //FORMA O PRIMEIRO DIA DO MES
//	dDataMin := dDataMin-1 //VOLTA AO MES ANTERIOR
//	cDataAnt := Left(Dtos(dDataMin),6)	

	//armazena as taxas em um array	
	dbSelectArea("ZA0")
	dbSetOrder(1)
	If dbSeek(xFilial("ZA0")+ mv_par04+SubStr(TRBJUR->E3_EMISSAO,4,4)+SubStr(TRBJUR->E3_EMISSAO,1,2))
		While !Eof() .And. ZA0_CODTAB == mv_par04 //.And.  ZA0_EXERC+ZA0_PERIOD <= TRBJUR->E3_EMISSAO
			aAdd(aTaxa,{ZA0_EXERC+ZA0_PERIOD,ZA0_INDICE})		
			dbSkip()
		End
	EndIf
	
	dbselectArea("TRBJUR")
	dbGoTop()
	While !Eof()
		
		nCalculo := 0

		//PRECISA PEGAR A TAXA DO MES ANTERIOR
//		dDataMin := stod(TRBJUR->E3_EMISSAO+"01") //FORMA O PRIMEIRO DIA DO MES
//		dDataMin := dDataMin-1 //VOLTA AO MES ANTERIOR
//		cDataAnt := Left(Dtos(dDataMin),6)	

		nPos := Ascan(aTaxa, {|e| e[1]== SubStr(TRBJUR->E3_EMISSAO,4,4)+SubStr(TRBJUR->E3_EMISSAO,1,2)})
		nVezes := 0
		If Len(aTaxa)>0 .And. nPos > 0
			nCalculo := TRBJUR->E3_COMIS
			For x := nPos To Len(aTaxa)	
				nVezes ++		
				nCalculo := Iif(nVezes == 1,nCalculo,((nCalculo/aTaxa[x-1][2])*aTaxa[x][2]))
			Next 
		EndIf
		aAdd(aTotal,{nCalculo,TRBJUR->E3_EMISSAO})
		
		nTBase 	+= TRBJUR->E3_BASE
		nTComis	+= TRBJUR->E3_COMIS
		nTCalc 	+= nCalculo
		
		cLin    := ''
		For n := 1 to FCount()
			If !FieldName(n) $ "R_E_C_N_O_|R_E_C_D_E_L_"
				If Empty(Posicione("SX3",2,FieldName(n),"X3_CBOX"))
					//TIRA PONTO E VIRGULA
					cValor := AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
					cLin += StrTran(cValor,";",",")
				Else
					cBox := Posicione("SX3",2,FieldName(n),"X3_CBOX")
					cVar := AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))+"="
					cConteudo := SubStr(cBox,At(cVar,cBox),Len(cBox))
					cConteudo := SubStr(cConteudo,Len(cVar)+1,At(";",cConteudo)-3)
					cLin += cConteudo
				EndIf
				cLin += ';'
			EndIf

		Next
		
		
		cLin += ';'+';'+';'+AllTrim(Transform(nCalculo,PesqPict("SE3","E3_COMIS")))

		cLin += cEOL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRBJUR->(dbCloseArea())
			fClose(nHdl)
			Return
		Endif


		dbSelectArea("TRBJUR")
		dbSkip()
	End
	TRBJUR->(dbCloseArea())	 	
	//IMPRIME CALCULOS MENSAIS
		cLin 	:= ';'+';'+';'+AllTrim(Transform(nTBase,PesqPict("SE3","E3_BASE")))+';'+AllTrim(Transform(nTComis,PesqPict("SE3","E3_COMIS")))+';'+';'+';'+';'+AllTrim(Transform(nTCalc,PesqPict("SE3","E3_COMIS")))

		cLin += cEOL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRBJUR->(dbCloseArea())
			fClose(nHdl)
			Return
		Endif


	//CALCULOS FINAIS
	For x:=1 To Len(aTotal)
		nTotal += aTotal[x][1]
		//
		If Len(aTotal)-X < 3 .And. LastDay(Stod(aTotal[x][2]+"01"))>= LastDay(mv_par02-93)
			nMedia += aTotal[x][1]
		EndIf 
	Next

		nTotal 	:= nTotal/12
		nMedia 	:=  Iif(mv_par08 == 1,nMedia/3,0)
		nIR		:= (nTotal+nMedia)*0.15
		nLiquido:= (nTotal+nMedia)-nIR 
		
		//faz as totalizacoes
		cLin    := ''
		cLin += cEOL
		cLin += ';'+';'+';'+';'+';'+';'+';'+'Indenizacao'+';'+ AllTrim(Transform(nTotal,PesqPict("SE3","E3_COMIS"))) 
		cLin += cEOL
		
		//CALCULA AVISO PREVIO
		If mv_par08 == 1
			cLin += ';'+';'+';'+';'+';'+';'+';'+'Aviso Previo'+';'+ AllTrim(Transform(nMedia,PesqPict("SE3","E3_COMIS"))) 
			cLin += cEOL
		EndIf
		cLin += ';'+';'+';'+';'+';'+';'+';'+'Imposto de Renda'+';'+ AllTrim(Transform(nIR,PesqPict("SE3","E3_COMIS"))) 
		cLin += cEOL
		cLin += cEOL
		cLin += ';'+';'+';'+';'+';'+';'+';'+'Valor Liquido Devido'+';'+ AllTrim(Transform(nLiquido,PesqPict("SE3","E3_COMIS"))) 

		cLin += cEOL
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRBJUR->(dbCloseArea())
			fClose(nHdl)
			Return
		Endif

	fClose(nHdl)
	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cArqTxt,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKRL011  ºAutor  ³Microsiga           º Data ³  04/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)
	// Local cKey := ""
	// Local aHelpEng := {}
	// Local aHelpPor := {}
	// Local aHelpSpa := {}

	//PutSx1(cGrupo,cOrdem,cPergunt             ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01    		 ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Da Data?"				,""                   	,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Até a Data?"			,""                  	,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Do Vendedor?"			,""                  	,""                    ,"mv_ch3","C"   ,06      ,0       ,0      , "G",""    			,"SA3" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Tabela?"				,""                  	,""                    ,"mv_ch4","C"   ,06      ,0       ,0      , "G",""    			,"ZE" 	,""         ,""   ,"mv_par04",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Da Filial?"			,""                  	,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Ate a Filial?"		,""                  	,""                    ,"mv_ch6","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par06",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Area Negocio?"		,""                  	,""                    ,"mv_ch7","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par07","Todas"	   	 ,""      ,""      ,""    ,"TAIFF"        	,""     ,""      ,"PROART" 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Calc.Aviso Previo?"	,""                  	,""                    ,"mv_ch8","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par08","Sim"		   	 ,""      ,""      ,""    ,"Não"        	,""     ,""      ,""	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	
	/*
	cKey     := "P.TKRL1201."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Data de ")
	aAdd(aHelpPor,"Faturamento inicio")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1202."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Data de ")
	aAdd(aHelpPor,"Faturamento Final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.TKRL1203."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Data inicio que ")
	aAdd(aHelpPor,"irá apresentar a Base de Clientes")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1204."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Data Final que ")
	aAdd(aHelpPor,"irá apresentar a Base de Clientes")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1205."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Marca")
	aAdd(aHelpPor,"do Produto ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1206."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Produto inicial ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1207."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o porduto Final ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.TKRL1208."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Vendedor")
	aAdd(aHelpPor,"inicial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.TKRL1209."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Vendedor")
	aAdd(aHelpPor,"final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1210."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o grupo")
	aAdd(aHelpPor,"de vendas ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.TKRL1211."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe se a marca")
	aAdd(aHelpPor,"irá ser utilizada para formar")
	aAdd(aHelpPor,"o Status do cliente como Ativo,Inativo ou Novo")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JURCNOME  ºAutor  ³Microsiga           º Data ³  04/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function JURCNOME(cTab)
cNome := Posicione("SX5",1,xFilial("SX5")+"ZE"+cTab,"X5_DESCRI")
oNome:Refresh()

Return(.T.)
