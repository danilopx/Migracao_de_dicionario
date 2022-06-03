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
ฑฑบPrograma  ณFATMI016  บAutor  ณ Carlos Torres      บ Data ณ 06/09/2021  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo do agrupamento da ordem de servi็o da ASTEC     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI016()
	Local lOk_FATMI016 := .F.

	Public _cMarca := GetMark()

	Private oReservaPed
	Private cUserName	:= UsrFullName(RetCodUsr()) // Login do usu?rio logado
	Private cUsuLib 	:= RetCodUsr()
	Private cPerg		:= "FATMI016A"
	Private cLaPerg 	:= "TFIMPCARGA"
	Private cTranspAgl	:= ""
	Private aPvlNfs   	:= {}
	PRIVATE cCadastro	:= "Ordem de Servi็o"

	// AxCadastro("ZAW","Concess?o R.E.",".F.",".F.")
	
	If U_CHECAFUNC(cUsuLib,"FATMI016")
		lOk_FATMI016 := .T.
	EndIf

	@ 200,001 TO 480,380 DIALOG oReservaPed TITLE OemToAnsi(cCadastro)
	@ 003,005 TO 085,187 PIXEL OF oReservaPed
	@ 010,018 Say "Este programa tem a finalidade da gestใo de  " SIZE 150,010 PIXEL OF oReservaPed
	@ 020,018 Say "pedidos que estใo agrupados por ordem de servi็o." SIZE 150,010 PIXEL OF oReservaPed
	IF .NOT. (CEMPANT="03" .AND. CFILANT="01")
		@ 040,018 Say "*** Acesso nใo permitido por esta empresa/filial ***" SIZE 150,010 PIXEL OF oReservaPed
	ELSEIf lOk_FATMI016
		@ 065,008 BUTTON "Continua  "  ACTION (Processa({||TFORDENS()}),oReservaPed:End())PIXEL OF oReservaPed
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
ฑฑบPrograma  ณGeraNota  บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraNota(cOpcao)

	_cNotaG := ''
	cSerie := "3"

	If Len( aPvlNfs ) > 0 .And. cOpcao == "1"
		/*
		//mostra a tela de serie
			If !lNota
			Sx5NumNota()
			lNota := .T.
			EndIf
		//QUANDO ESTIVER EM BRANCO SAI DA ROTINA
			If Empty(cSerie)
			lNota := .F.
			Return
			EndIf
		*/

		Pergunte("MT460A    ",.F.)

		_cNotaG := MaPvlNfs(aPvlNfs,cSerie,mv_par01 == 1	,mv_par02==1	,mv_par03==1	,mv_par04==1	,mv_par05==1	,mv_par07	,mv_par08		,mv_par15 == 1	,mv_par16==2)

	EndIf

	If Len(aPvlNfs)==0
		MsgBox ("Nao existem dados para ser gerada Nota Fiscal. Verifique liberacoes","Aten็ใo","ALERT")
	EndIf


Return(_cNotaG)

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

Static Function TFORDENS()
	Local oListBox
	//Local nOpc		:= 0
	//Local oBmp2, oBmp3
	Local aButtons := {} 
	Local aAdvSize := MsAdvSize( NIL , .F. ) 
	Local bSet15 := { || oDlgPedidos:End() } 
	Local bSet24 := { || oDlgPedidos:End() } 
	Local bInitDlg := { || EnchoiceBar( @oDlgPedidos , @bSet15 , @bSet24 , NIL , @aButtons ) } 
	Local oBtnPadrao 
	Local aPosObj := {}

	//Private cAcesso := "" //humpf... EnchoiceBar() necessita Disso... 

	Private aDados	:= {}
	Private oDlgPedidos
	PRIVATE oOk		:= LoadBitMap(GetResources(), "LBOK")
	PRIVATE oNo		:= LoadBitMap(GetResources(), "LBNO")

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif

	Aadd( aButtons, {"Legenda", {|| TFLEGENDA()}, "Legenda...", "Legenda" , {|| .T.}} )     		
	Aadd( aButtons, {"Importa OS's", {|| TFINTEGRA()}, "Integra OS's...", "Importa OS's" , {|| .T.}} )     		
	Aadd( aButtons, {"Transmite e-mail", {|| TFRETRANSMITE()}, "Transmite...", "Transmite e-mail" , {|| .T.}} )     		

	aCampos      := {}

	Cursorwait()
//seleciona os pedidos
	cQuery := " SELECT C5_NUM ,C5_CLIENTE ,C6_XNUMOS ,C5_EMISSAO ,C6_PRODUTO ,C6_QTDVEN ,C6_QTDENT ,C5_NOMCLI, C6_ITEM, ' ' AS C9_NFISCAL " + ENTER
	cQuery += ",CASE WHEN C9_NFISCAL='' THEN 'L' ELSE 'A' END OS_STATUS,C5_LOJACLI ,C6_DESCRI " + ENTER
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 WITH(NOLOCK)" + ENTER
	cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 WITH(NOLOCK) " + ENTER
	cQuery += " ON C6_FILIAL=C5_FILIAL " + ENTER
	cQuery += " AND C6_NUM=C5_NUM " + ENTER
	cQuery += " AND C6_LOCAL='51' " + ENTER
	cQuery += " AND C6_BLQ='' " + ENTER
	cQuery += " AND C6_QTDENT < C6_QTDVEN " + ENTER
	cQuery += " AND SC6.D_E_L_E_T_ <> '*'" + ENTER
 	cQuery += " LEFT OUTER JOIN SC9030 SC9 (NOLOCK) " + ENTER
 	cQuery += " ON C9_FILIAL	=C5_FILIAL " + ENTER
 	cQuery += " AND C9_PEDIDO	=C5_NUM  " + ENTER
 	cQuery += " AND C9_ITEM	=C6_ITEM" + ENTER
 	cQuery += " AND C9_PRODUTO = C6_PRODUTO" + ENTER
 	cQuery += " AND C9_NFISCAL	=''" + ENTER
 	cQuery += " AND SC9.D_E_L_E_T_=''" + ENTER
 	cQuery += " AND SC9.C9_BLEST != '02'" + ENTER
	cQuery += " WHERE C5_EMISSAO BETWEEN '" + Dtos(mv_par01) + "' AND '" + Dtos(mv_par02) + "'" + ENTER
	cQuery += " AND SC5.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
	cQuery += " AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += " AND C5_NOTA = ''" + ENTER
	cQuery += " AND C5_XITEMC = 'TAIFF' " + ENTER
	cQuery += " AND C5_CLASPED = 'A' " + ENTER
	cQuery += " AND C5_NUMOLD LIKE '%OS' " + ENTER
	cQuery += " AND C6_XNUMOS != '' " + ENTER
	IF .NOT. EMPTY(MV_PAR03)
		cQuery += " AND C5_CLIENTE = '" + mv_par03 + "'" + ENTER
	ENDIF
	cQuery += " ORDER BY C5_NUM" + ENTER

	//MemoWrite("FATMI016.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	TcSetField("TRB","C5_EMISSAO","D")

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta sele็ใo de dados!","Aten็ใo")
		//CursorArrow()
		//TRB->(dbCloseArea())
		//Return
	EndIf


	dbSelectArea("TRB")
	ProcRegua(nRec1)
	dbGotop()

	aDados	 := {}
	While !Eof()

		IncProc("Montando os itens a serem selecionados")
 
		lNota := .F.
		aAdd(aDados,{fColor(),lNota ,TRB->C5_NUM, TRB->C6_XNUMOS, AllTrim(TRB->C5_NOMCLI), TRB->C6_PRODUTO, TRB->C6_QTDVEN - TRB->C6_QTDENT, TRB->C6_ITEM, TRB->C9_NFISCAL, TRB->OS_STATUS,TRB->C5_EMISSAO,TRB->C5_LOJACLI,TRB->C5_CLIENTE,TRB->C6_DESCRI})

		dbSelectArea("TRB")
		dbSkip()
	End
	lNota := .F.
	CursorArrow()

	If Len(aDados) == 0
		//	MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		//	TRB->(dbCloseArea())
		//	Return
		aAdd(aDados,{fColor(),lNota ,SPACE(06), SPACE(10), SPACE(40), SPACE(15), 0, SPACE(03), SPACE(09), SPACE(01),CTOD("  /  /  "),SPACE(02),SPACE(06),SPACE(40)})
	EndIf


//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0


	aTitCampos := {" "," ",OemToAnsi("Num. Pedido"),OemToAnsi("Num. OS"),OemToAnsi("Cliente"),OemToAnsi("Cod.Produto."),OemToAnsi("Qt. Venda"),;
		OemToAnsi("Itens Pedido"),OemToAnsi("Nota fiscal"),OemToAnsi("Status_OS"),OemToAnsi("Emissao"),OemToAnsi("Loja"),OemToAnsi("Cod.Cliente"),OemToAnsi("Produto"),}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],aDados[oListBox:nAT][6],aDados[oListBox:nAT][7]"
	cLine += " ,aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],aDados[oListBox:nAT][10],aDados[oListBox:nAT][11],aDados[oListBox:nAT][12],aDados[oListBox:nAT][13],aDados[oListBox:nAT][14],}"

	bLine := &( "{ || " + cLine + " }" )


	DEFINE MSDIALOG oDlgPedidos TITLE "Ordens de Servi็o" FROM aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5]/1.3 OF GetWndDefault() PIXEL 
	@ 0,0 BITMAP oBmpServicos RESNAME "Ordens de Servi็o" OF oDlgPedidos SIZE 0,0 NOBORDER WHEN .F. PIXEL 

	oBmpServicos:lAutoSize := .T. 
	oBmpServicos:lStretch := .T. 
	oBmpServicos:Align := CONTROL_ALIGN_ALLCLIENT 


	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}

	oSize := FwDefSize():New(.T.,,,oDlgPedidos)             

	oSize:AddObject('GRID'  ,100,80,.T.,.T.)
	oSize:AddObject('FOOT'  ,100,40 ,.T.,.F.)	

	oSize:lProp 		:= .T. // Proporcional             
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
	
	oSize:Process() 	   // Dispara os calculos   

	aAdd(aPosObj,{oSize:GetDimension('GRID'  , 'LININI'),oSize:GetDimension('GRID'  , 'COLINI'),oSize:GetDimension('GRID'  , 'XSIZE')-15,oSize:GetDimension('GRID'  , 'YSIZE')})
	aAdd(aPosObj,{oSize:GetDimension('FOOT'  , 'LININI'),oSize:GetDimension('FOOT'  , 'COLINI'),oSize:GetDimension('FOOT'  , 'LINEND'),oSize:GetDimension('FOOT'  , 'COLEND')})

	oListBox := TWBrowse():New( aPosObj[1][1],aPosObj[1][2] + 005,aPosObj[1][3],aPosObj[1][4],,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := Iif(aDados[oListBox:nAt,2]==.T.,.F.,.T.)} //MarcaTodos(oListBox, .F., .T.,1,oListBox:nAt)) }
	oListBox:bLine := bLine

	@ aPosObj[2][1],aPosObj[2][2]+010 BUTTON oBtnPadrao PROMPT OemToAnsi( "Marca Tudo" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (MarcaTodos(oListBox, .F., .T.,0)) 
	@ aPosObj[2][1],aPosObj[2][2]+060 BUTTON oBtnPadrao PROMPT OemToAnsi( "Desm. Tudo" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (MarcaTodos(oListBox, .F., .F.,0)) 
	@ aPosObj[2][1],aPosObj[2][2]+110 BUTTON oBtnPadrao PROMPT OemToAnsi( "Imprime OS's" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (ImprCarga(oListBox,oListBox:nAt) ) 
	@ aPosObj[2][1],aPosObj[2][2]+160 BUTTON oBtnPadrao PROMPT OemToAnsi( "Fatura OS's" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (AjustVol(oListBox,oListBox:nAt)) 

	//@ aPosObj[2][1],aPosObj[2][2]+210 BUTTON oBtnPadrao PROMPT OemToAnsi( "Agrupar" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (MarcaTodos(oListBox, .F., .F.,0)) 
	//@ aPosObj[2][1],aPosObj[2][2]+260 BUTTON oBtnPadrao PROMPT OemToAnsi( "Desagrupar" ) OF oDlgPedidos SIZE 40,15 PIXEL ACTION (Desagrp(oListBox,oListBox:nAt)) 


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
	If TRB->OS_STATUS = "S"
		Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	Endif

//Agrupada e SEM SC9 
	If TRB->OS_STATUS = "A"
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	Endif

//Agrupada com SC9 sem faturar
	If TRB->OS_STATUS = "L"
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	Endif

//OS faturada
	If TRB->OS_STATUS = "F"
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
ฑฑบPrograma  ณFATAT063  บAutor  ณMicrosiga           บ Data ณ  03/16/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjustVol(oListBox,nLin)
Local Tahoma10   := TFont():New( "Tahoma",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

LOCAL cTGet1 := "Volume"
LOCAL cTGet2 := "Peso Bruto"
LOCAL cTGet3 := "Transportadora"
LOCAL oGet1 
LOCAL oGet2 
LOCAL oGet3
Local oProcess
LOCAL nX		:= 0
LOCAL NVALIDA	:= 0

PRIVATE aNotas := {}
PRIVATE cNota	:= ""
PRIVATE aPEDFATUR	:= {}
PRIVATE lOkValida := .F.

IF oListbox:aArray[nLin,2] = .T.
	nVolume := 0 
	nOpc	:= 1
	nPesoB  := 0
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSeek(xFilial("SC5")+oListbox:aArray[nLin,3])
	nPesoB  := C5_PBRUTO
	nPesoL	:= C5_PESOL
	cTranspAgl := C5_TRANSP
	nVolume := C5_VOLUME1 

	DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "Dados da nota" PIXEL
	
	oSay1	:= TSay():New( 013,007,{||cTGet1},oLocal,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet1	:= TGet():New( 012,055,{|u| If(PCount()>0,nVolume:=u,nVolume)},oLocal,013,007,"@E 9999",{|LRETORNO| VLDVOLUME(nVolume,cTGet1)},CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay2	:= TSay():New( 023,007,{||cTGet2},oLocal,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet2	:= TGet():New( 022,055,{|u| If(PCount()>0,nPesoB:=u,nPesoB)},oLocal,023,007,"@E 99,999.99",{|LRETORNO| VLDVOLUME(nPesoB,cTGet2)},CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay3	:= TSay():New( 033,007,{||cTGet3},oLocal,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet3	:= TGet():New( 032,055,{|u| If(PCount()>0,cTranspAgl:=u,cTranspAgl)},oLocal,033,007,'@E',,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA4",cTranspAgl,,)

	DEFINE SBUTTON FROM 065,010 TYPE 13 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,070 TYPE 21 ACTION (nOpc := 2,oLocal:End())  ENABLE OF oLocal
	ACTIVATE MSDIALOG oLocal CENTER

//ALTERA O VOLUME
	If nOpc == 1 
		If MsgYesNo("Deseja realmente atualizar volume nos pedidos selecionados?","Aten็ใo - FATMI016")
			For nX := 1 TO Len(oListbox:aArray)
				If oListbox:aArray[nX,2] = .T. 
					dbSelectArea("SC5")
					dbSetOrder(1)
					IF dbSeek(xFilial("SC5")+oListbox:aArray[nX,3])
						RecLock("SC5",.F.)
						C5_VOLUME1 	:= nVolume
						C5_PESOL	:= nPesoB
						C5_PBRUTO   := nPesoB
						SC5->(MsUnlock())
					Endif
				Endif
			Next nX
		Endif
	EndIf
	IF nOpc == 2
		cMensagem	:= ""
		aPEDFATUR	:= {}
		For nX := 1 TO Len(oListbox:aArray)
			If oListbox:aArray[nX,2] = .T. 
				IF oListbox:aArray[nX,10] != "L"
					cMensagem += "Pedido " + oListbox:aArray[nX,3] + " nใo LIBERADO!" + ENTER
				ELSE
					dbSelectArea("SC5")
					dbSetOrder(1)
					IF dbSeek(xFilial("SC5")+oListbox:aArray[nX,3])
						IF EMPTY(SC5->C5_VOLUME1)
							cMensagem += "Pedido " + oListbox:aArray[nX,3] + " sem volume" + ENTER
						ELSE
							lOkValida := .F.
							FOR NVALIDA := 1 TO LEN(aPEDFATUR)
								IF aPEDFATUR[NVALIDA,1] = oListbox:aArray[nX,3]
									lOkValida := .T.
								ENDIF
							NEXT NVALIDA
							IF .NOT. lOkValida
								AADD(aPEDFATUR,{ oListbox:aArray[nX,3] , oListbox:aArray[nX,13],"" } ) // { pedido , codigo cliente, numero da nota}
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		Next nX
		IF .NOT. EMPTY(cMensagem)
			MsgStop("Hแ inconsist๊ncia no(s) Pedido(s) selecionado(s) que impede faturamento, verifique:" + ENTER + cMensagem,"Aten็ใo - FATMI016")
		ELSE
			If MsgYesNo("Deseja realmente dar continuidade com a gera็ใo do documento de saํda?","Aten็ใo - FATMI016")
				oProcess := MsNewProcess():New({|lEnd| TFFATORDENS(@oProcess, @lEnd,oListBox) },"Faturamento de OS","Lendo as Ordens de servi็o a faturar",.T.) 
				oProcess:Activate()
			EndIf
		ENDIF
		IF LEN(aNotas) > 0
			FOR NVALIDA := 1 TO LEN(aNotas)
				TFOSEMAIL( aNotas[NVALIDA] )
			NEXT NVALIDA

			For nX := 1 TO Len(oListbox:aArray)
				If oListbox:aArray[nX,2] = .T. 
					oListbox:aArray[nX,2] := .F.
					oListbox:aArray[nX,10] := "F"
					oListbox:aArray[nX,1] := fcolor2(oListBox,nX)				
					FOR NVALIDA := 1 TO LEN(aPEDFATUR)
						IF aPEDFATUR[NVALIDA,1] = oListbox:aArray[nX,3]
							oListbox:aArray[nX,9] := aPEDFATUR[NVALIDA,3]
						ENDIF
					NEXT NVALIDA
				ENDIF
			Next nX


			c1Nota := Iif(Empty(aNotas[1]),'',aNotas[1])
			cMensagem := "FATURAMENTO CONCLUIDO!"+ENTER
			cMensagem += "E-MAIL ENVIADO PARA TRANSMISSAO AO SEFAZ"+c1Nota+ENTER
			cMensagem += "Primeira Nota: "+c1Nota+ENTER
			cMensagem += "Ultima Nota  : "+ Iif(Empty(aNotas[Len(aNotas)]),'',aNotas[Len(aNotas)])
			MsgInfo(cMensagem)
		ENDIF
	ENDIF
ENDIF
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

	PutSx1(cPerg,"01"   ,"Da Data Emissao   ?"	,"","","mv_ch1","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Ate a Data Emissao?"	,"","","mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,""    	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Do posto	?"			,"","","mv_ch3","C"   ,06      ,0       ,0      , "G",""    			,"SA1" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

Return





/*
------------------------------------------------------------------------------
Apresenta o volume da carga dos pedidos selecionados
------------------------------------------------------------------------------
*/
/*
Static Function Desagrp(oListBox,nLin)
	Local nOpc	:= 1
	Local lStatusNf := .T.
	Local nX	:= 0
	LOCAL NPONZAW	:= 0

	DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "OS a Desagrupar" PIXEL
	@ 003,005 TO 060,105 PIXEL OF oLocal
	@ 014,007 SAY "Todas as OS's  " SIZE  60, 7 PIXEL OF oLocal
	@ 024,007 SAY "  selecionadas   " SIZE  60, 7 PIXEL OF oLocal
	@ 034,007 SAY "   serใo desagrupadas!!!   " SIZE  60, 7 PIXEL OF oLocal

	DEFINE SBUTTON FROM 065,010 TYPE 1 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
	ACTIVATE MSDIALOG oLocal CENTER

	If nOpc == 1
		For nX := 1 TO Len(oListbox:aArray)
			If oListbox:aArray[nX,2] = .T. .AND. lStatusNf 
				cQuery := "SELECT COUNT(*) AS NREG " + ENTER
				cQuery += " FROM " + RetSQLName("SC9")+" SC9 " + ENTER
				cQuery += " WHERE " + ENTER
				cQuery += " C9_FILIAL = '"+xFilial("SC9")+"' " + ENTER
				cQuery += " AND C9_NFISCAL != '' " + ENTER
				cQuery += " AND SC9.D_E_L_E_T_ = '' " + ENTER
				cQuery += " AND C9_PEDIDO='" + oListbox:aArray[nX,3] + "' " + ENTER
				cQuery += " AND C9_PRODUTO='" + oListbox:aArray[nX,6] + "' " + ENTER
				cQuery += " AND C9_ITEM='" + oListbox:aArray[nX,8] + "' " + ENTER
				
				//MemoWrite("fatmi016.SQL",cQuery)

				IF SELECT("AUX") > 0
					DBSELECTAREA("AUX")
					DBCLOSEAREA()
				ENDIF

				TCQUERY CQUERY NEW ALIAS "AUX"
				DBSELECTAREA("AUX")

				IF AUX->NREG > 0
					lStatusNf := .F.
				EndIf

				If .NOT. lStatusNf
					MsgStop("O estorno do agrupamento nใo pode ser efetuada uma vez que o pedido tem nota fiscal emitida!","Aten็ใo - FATMI016")
				Endif
			EndIf
		Next
		IF lStatusNf 
			For nX := 1 TO Len(oListbox:aArray)
				cQuery := "SELECT MAX(R_E_C_N_O_) AS NREG " + ENTER
				cQuery += " FROM ZAW030 " + ENTER

				IF SELECT("AUX") > 0
					DBSELECTAREA("AUX")
					DBCLOSEAREA()
				ENDIF

				TCQUERY CQUERY NEW ALIAS "AUX"
				DBSELECTAREA("AUX")

				IF AUX->NREG > 0
					NPONZAW	:= AUX->NREG + 1
				ELSE
					NPONZAW	:= 1
				EndIf

				If oListbox:aArray[nX,2] = .T. 
					ZAW->(DBSETORDER(1))
					IF .NOT. ZAW->(DBSEEK( XFILIAL("ZAW") + oListbox:aArray[nX,4] + oListbox:aArray[nX,6]))

						_cQuery := "INSERT INTO ZAW030 "
						_cQuery += " ( ZAW_FILIAL ,ZAW_PEDIDO ,ZAW_XNUMOS ,ZAW_CODCLI ,ZAW_COD ,ZAW_QTDVEN ,ZAW_ITEM ,ZAW_EMISSA , ZAW_LOJA, D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_ ) "
						_cQuery += " VALUES "
						_cQuery += " ( '" + xFilial("ZAW") + "','" 
						_cQuery += oListbox:aArray[nX,3] + "','"
						_cQuery += oListbox:aArray[nX,4] + "','"
						_cQuery += oListbox:aArray[nX,13] + "','"
						_cQuery += oListbox:aArray[nX,6] + "','"
						_cQuery += ALLTRIM(STR( oListbox:aArray[nX,7] )) + "','"
						_cQuery += oListbox:aArray[nX,9] + "','"
						_cQuery += DTOS(oListbox:aArray[nX,11]) + "','"
						_cQuery += oListbox:aArray[nX,12] + "',"
						_cQuery += " '',"
						_cQuery += " " + ALLTRIM(STR(NPONZAW)) + ","
						_cQuery += " 0"
						_cQuery += ") "

						MemoWrite("FATMI016.SQL",_cQuery)
						
						TCSQLExec(_cQuery)

						oListbox:aArray[nX,2] := .F.
						oListbox:aArray[nX,3] := "      "
//
// PENDENTE REMOVER DO PEDIDO DE VENDA
//
						NPONZAW	+= 1
					ENDIF
				ENDIF
			Next
		ENDIF
	EndIf
	dbSelectArea("TRB")
Return
*/

/*
--------------------------------------------------------------------------------------------------------------
Impressใo da OS selecionada da ZC5
--------------------------------------------------------------------------------------------------------------
*/
Static Function ImprCarga(oListBox,nLin)
	LOCAL nX
	LOCAL APEDIMPRIME := {}

	Private oReport

	cNumOf := ""
	For nX := 1 TO Len(oListbox:aArray)
		If oListbox:aArray[nX,2] = .T.
			IF ASCAN(APEDIMPRIME,oListbox:aArray[nX,3]) = 0
				AADD(APEDIMPRIME,oListbox:aArray[nX,3])
			ENDIF
			oListbox:aArray[nX,2] = .F.
		ENDIF
	NEXT
	For nX := 1 TO Len(APEDIMPRIME)
		cNumOf := APEDIMPRIME[nX]
		SX1->(DbSetOrder(1))
		If SX1->(DbSeek( cLaPerg + "01" ))
			SX1->(reclock("SX1",.F.))
			SX1->X1_CNT01 := cNumOf
			SX1->(MsUnlock())
		EndIf
		oReport := DReportDef( cNumOf )
		oReport:PrintDialog()
	Next
	dbSelectArea("TRB")

Return Nil


/*
--------------------------------------------------------------------------------------------------------------
Fun็ใo Static de prepara็ใo dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef( __cNumOC )
	//Local oReport
	Local cAliasQry := "TRB"
	Local oOSTransf_1
	Local oOSTransf_2

	oReport := TReport():New("TFIMPCARGA","Pedido a Separar","TFIMPCARGA", {|oReport| DReportPrint(oReport,cAliasQry,__cNumOC)},"")
	oReport:SetLandScape()
	oReport:SetTotalInLine(.F.)
	oReport:cFontBody := "Arial" //'Arial Narrow'
	oReport:nFontBody :=  8 //10
	oReport:SetColSpace(0,.T.)
	oReport:SetLineHeight(50)
	oReport:lParamPage := .F.
	oReport:lParamReadOnly := .F.

	Pergunte(oReport:uParam,.F.)

	oOSTransf_1 := TRSection():New(oReport,"Lista das OS's agrupadas",{"SC5"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)

	TRCell():New(oOSTransf_1,"C5_NUM"		,"SC5"	,"No. Agrupamento"	,PesqPict("SC5","C5_NUM")	 ,30						,/*lPixel*/,{|| (cAliasQry)->C5_NUM	})
	TRCell():New(oOSTransf_1,"C5_NOMCLI"	,"SC5"	,"Posto"			,PesqPict("SC5","C5_NOMCLI") ,TamSx3("C5_NOMCLI")[1]	,/*lPixel*/,{|| (cAliasQry)->C5_NOMCLI	})

	oOSTransf_2 := TRSection():New(oReport,"Itens da Carga",{"SC6"},/*<aOrder>*/,/*Campos do SX3*/,/*Campos do SIX*/)
                 //TRSection():New( <oParent> 	, <cTitle> 			, <uTable> 	, <aOrder> 		, <lLoadCells> 		, <lLoadOrder> 		, <uTotalText> , <lTotalInLine> , <lHeaderPage> , <lHeaderBreak> , <lPageBreak> , <lLineBreak> , <nLeftMargin> , <lLineStyle> , <nColSpace> , <lAutoSize> , <cCharSeparator> , <nLinesBefore> , <nCols> , <nClrBack> , <nClrFore> , <nPercentage> 
	//TRCell():New(oOSTransf_2,"C6_XNUMOS"	,"SC6"	,"Ordem Servico"	,PesqPict("SC6","C6_XNUMOS")	,TamSx3("C6_XNUMOS")[1]		,/*lPixel*/,{|| (cAliasQry)->C6_XNUMOS	})
	TRCell():New(oOSTransf_2,"C6_ITEM"		,"SC6"	,"Item"				,PesqPict("Sc6","C6_ITEM")		,TamSx3("C6_ITEM")[1]		,/*lPixel*/,{|| (cAliasQry)->C6_ITEM	})
	TRCell():New(oOSTransf_2,"C6_PRODUTO"	,"SC6"	,"Produto"			,PesqPict("SC6","C6_PRODUTO")	,TamSx3("C6_PRODUTO")[1]	,/*lPixel*/,{|| (cAliasQry)->C6_PRODUTO	})
	TRCell():New(oOSTransf_2,"C6_DESCRI"	,"SC6"	,"Nome Produto"		,PesqPict("SC6","C6_DESCRI")	,TamSx3("C6_DESCRI")[1]		,/*lPixel*/,{|| (cAliasQry)->C6_DESCRI	})
	TRCell():New(oOSTransf_2,'cLocais'   	,'   '	,"Endereco"  		,"@!"							,05							,/*lPixel*/,{|| cLocais	})
	TRCell():New(oOSTransf_2,"C6_QTDVEN"	,"SC6"	,"Qt.Pedido" 		,"@R 999.99"					,TamSx3("C6_QTDVEN")[1]		,/*lPixel*/,{|| ((cAliasQry)->C6_QTDVEN - (cAliasQry)->C6_QTDENT)	},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,'cTrazeja'  	,'   '	,"Atendido"  		,"@!"							,10							,/*lPixel*/,{|| cTrazeja })
	TRCell():New(oOSTransf_2,'cSimilar'  	,'   '	,"Similar"  		,"@!"							,TamSx3("C6_PRODUTO")[1]	,/*lPixel*/,{|| cSimilar })
	TRCell():New(oOSTransf_2,'cTrazej2'  	,'   '	,"Atendido"  		,"@!"							,10							,/*lPixel*/,{|| cTrazej2 })

//////TRFunction():New(oOSTransf_2:Cell("VOLUME_TOTAL")	,NIL,"ONPRINT"	,/*oBreak*/,"",PesqPict("ZC5","ZC5_QTDLIB"),{|| oOSTransf_2:Cell("VOLUME_TOTAL"):GetValue(.T.) },.T.,.F.)

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Fun็ใo Static de execu็ใo do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry,__cNumOC)
	Local __QuebraOC
	LOCAL _cLocais	:= ""

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)

	MakeSqlExpr(oReport:uParam)

	cAliasQry := "TRB"

	oReport:Section(1):BeginQuery()
	dbSelectArea(cAliasQry)
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicio da impressao do fluxo do relat๓rio                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)
	dbGoTop()
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())
		IF (cAliasQry)->C5_NUM != __cNumOC
			dbSkip()
		ELSE
			__QuebraOC := (cAliasQry)->C5_NUM
			_nTotalVolumes := 0
			oReport:Section(1):Init()
			oReport:Section(1):PrintLine()
			oReport:Section(2):Init()
			While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->C5_NUM = __QuebraOC

				SBF->(DBSETORDER(2))
				SBF->( dbSeek(xFilial("SBF")+(cAliasQry)->C6_PRODUTO ))
				_cLocais := ""
				While !(SBF->(Eof())) .and. (cAliasQry)->C6_PRODUTO = SBF->BF_PRODUTO
					If SBF->BF_QUANT > 0 .AND. SBF->BF_LOCAL="51" .AND. EMPTY(_cLocais)
						If At( Alltrim(SBF->BF_LOCALIZ) , _cLocais ) = 0 
							_cLocais := Alltrim(SBF->BF_LOCALIZ) 
						Endif
					Endif    
					SBF->(DbSkip())
				End

				oReport:Section(2):Cell("cLocais"):SetValue( _cLocais )
				oReport:Section(2):Cell("cTrazeja"):SetValue( "|" + SPACE(06) )
				
				SGI->(DBSETORDER(1))
				SGI->( dbSeek(xFilial("SGI")+(cAliasQry)->C6_PRODUTO ))
				oReport:Section(2):Cell("cSimilar"):SetValue( "|" + IIF( SGI->(FOUND()),SGI->GI_PRODALT,SPAC(15)) )

				oReport:Section(2):Cell("cTrazej2"):SetValue( "|" + SPACE(06) )

				oReport:Section(2):PrintLine()
				oReport:ThinLine()

				dbSkip()
				oReport:IncMeter()
			End
			oReport:Section(2):Finish()
			oReport:Section(1):Finish()
			oReport:SkipLine(1)
			oReport:PrintText("Peso: __________________________  Volume: ________________________")
			oReport:SkipLine(1)
			oReport:PrintText("Separador: ________________________________________       Data: __________/__________/__________")
			oReport:ThinLine()

			oReport:ThinLine()
			oReport:Section(1):SetPageBreak(.T.)
		ENDIF
	End
	
Return

/*
Valida fun็ใo do conte๚do de campo do Volume da Nfe e Peso liquido
*/
STATIC FUNCTION VLDVOLUME(NQTVOLUME,CMENSGET)
LOCAL LRETORNO := .T.

IF NQTVOLUME=0
	MsgStop("Conte๚do nใo vแlido para " +CMENSGET+ ", informe conte๚do superior que zero!","Aten็ใo - FATMI016")
	LRETORNO := .F.
ENDIF

Return (LRETORNO)

//
// Carga matriz aPvlNfs com pedidos liberados com base na SC9
//
STATIC FUNCTION CARGSC9(cOSPedido)

	dbSelectArea("SC6")
	dbSetORder(1)
	dbSeek( xFilial("SC6") + cOSPedido)
	While !Eof() .AND. C6_FILIAL+C6_NUM == xFilial("SC6") + cOSPedido

		dbSelectArea("SC9")
		dbSetORder(1)
		dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

		While !Eof() .AND. xFilial("SC9") == SC9->C9_FILIAL .AND. SC6->C6_NUM == SC9->C9_PEDIDO .AND. SC6->C6_ITEM = SC9->C9_ITEM
			If EMPTY(SC9->C9_NFISCAL) .AND. SC9->C9_BLEST != "02"
				dbSelectArea("SB1")
				dbSetOrder(1)
				MsSeek(xFilial("SB1")+SC9->C9_PRODUTO)

				dbSelectArea("SC5")
				dbSetOrder(1)
				MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)

				dbSelectArea("SC6")
				dbSetOrder(1)
				MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

				dbSelectArea("SB2")
				dbSetOrder(1)
				MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)

				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(xFilial("SF4")+SC6->C6_TES)

				dbSelectArea("SE4")
				dbSetOrder(1)
				MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)

				dbSelectarea("SC9")

				aadd(aPvlNfs,{ SC9->C9_PEDIDO ,SC9->C9_ITEM ,SC9->C9_SEQUEN ,SC9->C9_QTDLIB ,SC9->C9_PRCVEN ,SC9->C9_PRODUTO ,SF4->F4_ISS=="S" ,SC9->(RecNo()) ,SC5->(RecNo()) ,SC6->(RecNo()) ,SE4->(RecNo()) ,SB1->(RecNo()) ,SB2->(RecNo()) ,SF4->(RecNo()) ,SC9->C9_LOCAL ,0})
			EndIf
			DbSelectarea("SC9")
			DbSkip()
		EndDo
		DbSelectarea("SC6")
		DbSkip()
	EndDo
RETURN

//
// Monta browse de cores das legendas
//
STATIC FUNCTION TFLEGENDA
Local aCores     := {}
aAdd(aCores,{"BR_AMARELO"	,"Apto a Agrupar"})
aAdd(aCores,{"BR_VERDE"		,"Apto a Liberar"})
aAdd(aCores,{"BR_AZUL"		,"Apto a Faturar"})
aAdd(aCores,{"BR_VERMELHO"	,"OS em andamento"})

BrwLegenda(cCadastro,"Legenda",aCores)

RETURN(NIL)

//
// ATUALIZA AS CORES APำS FATURAMENTO OU AวรO NO PEDIDO
//
Static Function fColor2(oListBox,nLin)

	If oListbox:aArray[nLin,10]="S"
		Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	ElseIf oListbox:aArray[nLin,10]="A"
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	ElseIf oListbox:aArray[nLin,10]="L"
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	ElseIf oListbox:aArray[nLin,10]="F"
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif

Return

//
// FATURA AS ORDENS DE SERVIวOS DOS PEDIDOS SELECIONADOS
//
static Function TFFATORDENS(oProcess, lEnd,oListBox)   
	LOCAL NNFELOOP	:= 0
	LOCAL NINIPOSTO	:= 0
	LOCAL NFIMPOSTO	:= 0
	LOCAL CIDPOSTO	:= ""
	LOCAL NCTAFAT	:= 0
	LOCAL NQTDFAT	:= 0
	LOCAL NQTPOSTOS	:= 0
	LOCAL _nRec2 	:= 0
	LOCAL nX		:= 0

	Default lEnd := .F.

	ASORT(aPEDFATUR, , , { | x,y | x[2] > y[2] } ) // Ordena pelo posto

	CIDPOSTO:= ""
	FOR NNFELOOP := 1 TO LEN(aPEDFATUR)
		IF CIDPOSTO != aPEDFATUR[NNFELOOP,2]
			CIDPOSTO	:= aPEDFATUR[NNFELOOP,2]
			NQTPOSTOS	+= 1
		ENDIF
	END

	CIDPOSTO:= ""
	NCTAFAT	:= 1
	NQTDFAT := LEN(aPEDFATUR)
	oProcess:SetRegua1(NQTPOSTOS)
	WHILE .T.
		oProcess:IncRegua1("Lendo as OS do posto: " + aPEDFATUR[NCTAFAT,2]) 
		CIDPOSTO := aPEDFATUR[NCTAFAT,2]
		NINIPOSTO := NCTAFAT
		
		// conta os itens dos pedidos do posto
		_nRec2 := 0
		For nX := 1 TO Len(oListbox:aArray)
			If oListbox:aArray[nX,2] = .T.  .AND. aPEDFATUR[NCTAFAT,2] = oListbox:aArray[nX,13] 
				_nRec2 += 1
			ENDIF
		NEXT
		oProcess:SetRegua2(_nRec2)

		WHILE CIDPOSTO = aPEDFATUR[NCTAFAT,2]
			oProcess:IncRegua2("Lendo Itens da OS do Pedido de Venda: " + aPEDFATUR[NCTAFAT,1]) 
			CARGSC9(aPEDFATUR[NCTAFAT,1])
			NFIMPOSTO := NCTAFAT
			NCTAFAT	+= 1
			IF NCTAFAT > NQTDFAT
				EXIT
			ENDIF
		END
		cNota := GeraNota("1")
		aPvlNfs := {}
		aAdd(aNotas,cNota)
		
		FOR NNFELOOP := NINIPOSTO TO NFIMPOSTO
			aPEDFATUR[NNFELOOP,3] := cNota
		NEXT NNFELOOP

		IF NCTAFAT > NQTDFAT
			EXIT
		ENDIF
	END
RETURN(NIL)


//
// ACIONA A ROTINA DE INTEGRAวรO DE ORDENS DE SERVIวO
//
STATIC FUNCTION TFINTEGRA()
IF MsgYesNo("Deseja realmente acionar a integra็ใo de ordens de servi็o colocadas no portal?","Aten็ใo - FATMI016")
	U_IMPORDEM()
ENDIF

RETURN(NIL)

//
// retransmite o e-mail da nota fiscal gerada
//
STATIC FUNCTION TFRETRANSMITE
LOCAL CNOTAFISCAL	:= SPAC(09)
Local Tahoma10		:= TFont():New( "Tahoma",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
LOCAL cTGet1		:= "Informe a Nota Fiscal: "
LOCAL oGet1 
LOCAL oSay1
LOCAL oLocal

	DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "Retransmite e-mail da Nfe" PIXEL
	
	oSay1	:= TSay():New( 013,007,{||cTGet1},oLocal,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet1	:= TGet():New( 012,055,{|u| If(PCount()>0,CNOTAFISCAL:=u,CNOTAFISCAL)},oLocal,013,007,"@!",{|LRETORNO| VLDOSDANFE(CNOTAFISCAL)},CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	DEFINE SBUTTON FROM 065,010 TYPE 1 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
	ACTIVATE MSDIALOG oLocal CENTER

	IF nOpc == 1 
		TFOSEMAIL(CNOTAFISCAL)
	ENDIF

RETURN(NIL)

//
// valida exist๊ncia da nota fiscal 
//
STATIC FUNCTION VLDOSDANFE(CNOTAFISCAL)
LOCAL LRETURN := .T.
SF2->(DBSETORDER(1))
IF .NOT. SF2->(DBSEEK( XFILIAL("SF2") + CNOTAFISCAL + "3"))
	MsgStop("Nota fiscal " +CNOTAFISCAL+ "/3, nใo localizada!","Aten็ใo - FATMI016")
	LRETURN := .F.
ENDIF
RETURN(LRETURN)

//
// gera e-mail da nota 
//
STATIC FUNCTION TFOSEMAIL(CNOTAFISCAL)
LOCAL AOSITEEMAIL	:= {}
LOCAL AOSCABEMAIL	:= {}
LOCAL cHtml			:= ""
LOCAL NVALIDA		:= 0
LOCAL cMensagem		:= ""

	AOSITEEMAIL := {}
	AOSCABEMAIL	:= {}
	dbSelectArea("SC9")
	dbSetORder(6)
	dbSeek(xFilial("SC9") + "3  " + CNOTAFISCAL )

	While !Eof() .AND. xFilial("SC9") == SC9->C9_FILIAL .AND. SC9->C9_NFISCAL=CNOTAFISCAL .AND. SC9->C9_SERIENF="3  "
		If  SC9->C9_BLEST != "02"
			IF Ascan(AOSCABEMAIL, { | x | x[1] = SC9->C9_PEDIDO .and. x[3] = SC9->C9_NFISCAL } ) = 0
				AADD(AOSCABEMAIL,{SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_NFISCAL})
			ENDIF
			dbSelectArea("SC6")
			dbSetOrder(1)
			IF MsSeek(xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO)
				IF Ascan(AOSITEEMAIL, { | x | x[1] = SC9->C9_PEDIDO .and. x[2] = SC6->C6_XNUMOS } ) = 0
					AADD(AOSITEEMAIL,{SC9->C9_PEDIDO,SC6->C6_XNUMOS,SC9->C9_NFISCAL})
				ENDIF
			ENDIF
		ENDIF
		SC9->(DBSKIP())
	END

	If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie ้ diferente ao da PRODUCAO */
		cHtml := '<H2>Notas fiscais geradas em T E S T E em ' + ALLTRIM(GetEnvServer()) + ' para envio ao SEFAZ</H2>'
	Else
		cHtml := '<H1>Notas fiscais geradas para envio ao SEFAZ</H1>'
	EndIf
	cHtml += '<table border="1"><tr><th>Pedido</th><th>Posto</th><th>Nota fiscal</th><th>Serie</th><th>Filial</th></tr>'

	FOR NVALIDA := 1 TO LEN(AOSCABEMAIL)
		cHtml += '<tr><td>' + AOSCABEMAIL[NVALIDA,1] + '</td><td>' + AOSCABEMAIL[NVALIDA,2] + '</td><td>' + AOSCABEMAIL[NVALIDA,3] + '</td><td>3</td><td>TAIFF - MATRIZ</td></tr>'
	NEXT NVALIDA

	cHtml += '</table>'

	cHtml += '<H1>Detalhes das Ordens de Servico</H1>'
	cHtml += '<table border="1"><tr><th>Pedido</th><th>Ordem de Servico</th><th>Nota fiscal</th><th>Serie</th></tr>'

	FOR NVALIDA := 1 TO LEN(AOSITEEMAIL)
		cHtml += '<tr><td>' + AOSITEEMAIL[NVALIDA,1] + '</td><td>' + AOSITEEMAIL[NVALIDA,2] + '</td><td>' + AOSITEEMAIL[NVALIDA,3] + '</td><td>3</td></tr>'
	NEXT NVALIDA

	cHtml += '</table>'

	Memowrite("Ordem_de_servico_ASTEC.HTML",cHtml)

	cMailDest := "carlos.torres@taiff.com.br;marta.sakamoto@taiff.com.br"
		
	U_2EnvMail("workflow@taiff.com.br",RTrim(cMailDest)	,'',cHtml	,"Notas fiscais para transmissao" + Iif( At( "DESENV",GetEnvServer()) != 0," TESTE","") + " em " + dtoc(date()),'')

	cMensagem := "***** E-MAIL ENVIADO!! ******" 
	MsgInfo(cMensagem)

RETURN(NIL)
