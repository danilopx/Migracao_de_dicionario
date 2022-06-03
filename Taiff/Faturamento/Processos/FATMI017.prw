#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'
#DEFINE ENTER Chr(13)+Chr(10)

#DEFINE CHR_ENTER				'<br>'
#DEFINE CHR_FONT_CAB_OPEN 	'<font face="arial" size="5">'
#DEFINE CHR_FONT_CAB_CLOSE	'</font>'
#DEFINE CHR_FONT_DET_OPEN	'<font face="Courier New" size="2">'
#DEFINE CHR_FONT_DET_CLOSE	'</font>'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI017  บAutor  ณ Carlos Torres      บ Data ณ 06/09/2021  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo da vista explodida da ASTEC 					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI017()
	Local lOk_FATMI016 := .F.

	Public _cMarca := GetMark()

	Private oReservaPed
	Private cUserName	:= UsrFullName(RetCodUsr()) // Login do usu?rio logado
	Private cUsuLib 	:= RetCodUsr()
	Private cPerg		:= "FATMI017A"
	PRIVATE cCadastro	:= "Vista Explodida"

	If U_CHECAFUNC(cUsuLib,"FATMI017")
		lOk_FATMI016 := .T.
	EndIf

	@ 200,001 TO 480,380 DIALOG oReservaPed TITLE OemToAnsi(cCadastro)
	@ 003,005 TO 085,187 PIXEL OF oReservaPed
	@ 010,018 Say "Este programa tem a finalidade da gestใo de  " SIZE 150,010 PIXEL OF oReservaPed
	@ 020,018 Say "da vista explodida da assist๊ncia t้cnica." SIZE 150,010 PIXEL OF oReservaPed
	IF .NOT. (CEMPANT="03" .AND. CFILANT="01")
		@ 040,018 Say "*** Acesso nใo permitido por esta empresa/filial ***" SIZE 150,010 PIXEL OF oReservaPed
	ELSEIf lOk_FATMI016
		@ 065,008 BUTTON "Continua  "  ACTION (Processa({||TFVISTAEX()}),oReservaPed:End())PIXEL OF oReservaPed
	Else
		@ 040,018 Say "*** Usuแrio sem acesso a esta rotina ***" SIZE 150,010 PIXEL OF oReservaPed
	EndIf
	@ 100,008 BMPBUTTON TYPE 02 ACTION oReservaPed:End()

	Activate Dialog oReservaPed Centered

Return(.T.)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFatura    บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TFVISTAEX()
	Local oListBox
	//Local nOpc		:= 0
	//Local oBmp2, oBmp3
	Local aButtons := {} 
	Local aAdvSize := MsAdvSize( NIL , .F. ) 
	Local aInfoAdvSize := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 } 
	Local aObjCoords := { { 000 , 000 , .T. , .T. } } 
	Local aMsObjSize := MsObjSize( aInfoAdvSize , aObjCoords ) 
	Local bSet15 := { || oDlgPedidos:End() } 
	Local bSet24 := { || oDlgPedidos:End() } 
	Local bInitDlg := { || EnchoiceBar( @oDlgPedidos , @bSet15 , @bSet24 , NIL , @aButtons ) } 
	Local oBtnPadrao 

	//Private cAcesso := "" //humpf... EnchoiceBar() necessita Disso... 

	Private aDados	:= {}
	Private oDlgPedidos
	PRIVATE oOk		:= LoadBitMap(GetResources(), "LBOK")
	PRIVATE oNo		:= LoadBitMap(GetResources(), "LBNO")
	PRIVATE _sNomeBanco	 := GetMV("MV_BDASSTE") // Banco de Dados do Portal da Assistencia (PORTAL_ASSTEC)

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif

	Aadd( aButtons, {"Legenda", {|| TFLEGENDA()}, "Legenda...", "Legenda" , {|| .T.}} )     		

	aCampos      := {}

	Cursorwait()
//seleciona os pedidos
	cQuery := " SELECT SB1_COD_PA,SB1_COD_COMP,B1_DESC AS DESC_COMP,EVE_ATIVO " + ENTER
	cQuery += " FROM " + _sNomeBanco + " ESTRUTURA_VISTA_EXPLODIDA VEX WITH(NOLOCK)" + ENTER
	cQuery += " INNER JOIN SB1030 SB1 WITH(NOLOCK)" + ENTER
	cQuery += " ON SB1.B1_FILIAL='01'" + ENTER
	cQuery += " AND VEX.SB1_COD_COMP=B1_COD" + ENTER
	cQuery += " AND SB1.D_E_L_E_T_=''" + ENTER
	cQuery += " WHERE SB1_COD_PA = '" + mv_par01 + "'" + ENTER
	cQuery += " AND VEX.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " ORDER BY SB1_COD_COMP" + ENTER

	MemoWrite("FATMI017.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	//TcSetField("TRB","C5_EMISSAO","D")

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta sele็ใo de dados!","Aten็ใo")
		CursorArrow()
		TRB->(dbCloseArea())
		Return
	EndIf


	dbSelectArea("TRB")
	ProcRegua(nRec1)
	dbGotop()

	aDados	 := {}
	While !Eof()

		IncProc("Montando os itens a serem selecionados")
 
		lNota := .F.
		aAdd(aDados,{fColor(),lNota ,TRB->SB1_COD_PA, TRB->SB1_COD_COMP, AllTrim(TRB->DESC_COMP), TRB->EVE_ATIVO})

		dbSelectArea("TRB")
		dbSkip()
	End
	lNota := .F.
	CursorArrow()

	If Len(aDados) == 0
		MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		TRB->(dbCloseArea())
		Return
	EndIf

//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0


	aTitCampos := {" "," ",OemToAnsi("Produto PA"),OemToAnsi("Componente"),OemToAnsi("Descri็ใo do Componente"),OemToAnsi("Ativo"),}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],aDados[oListBox:nAT][6],}"

	bLine := &( "{ || " + cLine + " }" )


	DEFINE MSDIALOG oDlgPedidos TITLE "Vista Explodida" FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5]/1.3 OF GetWndDefault() PIXEL 
	@ 0,0 BITMAP oBmpPandora RESNAME "Vista Explodida" OF oDlgPedidos SIZE 0,0 NOBORDER WHEN .F. PIXEL 

	oBmpPandora:lAutoSize := .T. 
	oBmpPandora:lStretch := .T. 
	oBmpPandora:Align := CONTROL_ALIGN_ALLCLIENT 


	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}

	oListBox := TWBrowse():New( (aMsObjSize[1,1] ) + 025 ,( aMsObjSize[1,2] ) + 10 ,( aMsObjSize[1,3] + 270 ) ,( aMsObjSize[1,4] - 600),,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := Iif(aDados[oListBox:nAt,2]==.T.,.F.,.T.)} //MarcaTodos(oListBox, .F., .T.,1,oListBox:nAt)) }
	oListBox:bLine := bLine

	@ ( aMsObjSize[1,1] ) + 005 , ( aMsObjSize[1,2] + 010 ) BUTTON oBtnPadrao PROMPT OemToAnsi( "Marca Tudo" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (MarcaTodos(oListBox, .F., .T.,0)) 
	@ ( aMsObjSize[1,1] ) + 005 , ( aMsObjSize[1,2] + 060 ) BUTTON oBtnPadrao PROMPT OemToAnsi( "Desm. Tudo" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (MarcaTodos(oListBox, .F., .F.,0)) 

	ACTIVATE DIALOG oDlgPedidos CENTERED ON INIT Eval( bInitDlg )

	TRB->(dbCloseArea())

Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCOLOR    บAutor  ณMicrosiga           บ Data ณ  09/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RETORNA O STATUS DO PEDIDO                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fColor()

//Sem agrupamento
	If TRB->EVE_ATIVO = "S"
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	Endif

//Agrupada e SEM SC9 
	If TRB->EVE_ATIVO != "S"
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInverteSelบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInverte Selecao do list box - totalizadores                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca,nItem)

	If lInverte
		oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
	Else
		If lMarca
			oListbox:aArray[nLin,2] := .T.
		Else
			oListbox:aArray[nLin,2] := .F.
		EndIf
	EndIf

	If lMarca 

		If oListbox:aArray[nLin,10] = "F"
			oListbox:aArray[nLin,2] := .F.
		Endif

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaTodosบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca todos as opcoes do list box - totalizadores           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca,nItem,nPos)
	Local nX

	If nItem = 0
		For nX := 1 TO Len(oListbox:aArray)
			InverteSel(oListBox,nX, lInverte, lMarca,0)
		Next
	Else
		lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
		Return(lRet)
	EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG(cPerg)

	PutSx1(cPerg,"01"   ,"Produto PA da estrutura?"			,"","","mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SB1" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

Return


//
// Monta browse de cores das legendas
//
STATIC FUNCTION TFLEGENDA
Local aCores     := {}
aAdd(aCores,{"BR_VERDE"		,"Ativo"})
aAdd(aCores,{"BR_VERMELHO"	,"Nใo ativo"})

BrwLegenda(cCadastro,"Legenda",aCores)

RETURN(NIL)
