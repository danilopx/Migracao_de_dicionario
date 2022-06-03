#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI008  บAutor  ณCarlos Torres       บ Data ณ  28/12/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo da reserva por al็ada                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI008()
	Local lOk_FATMI008 := .F.

	Public _cMarca := GetMark()

	Private oReservaPed
	Private cUserName	:= UsrFullName(RetCodUsr()) // Login do usuแrio logado
	Private cUsuLib := RetCodUsr()

	If U_CHECAFUNC(cUsuLib,"FATMI008")
		lOk_FATMI008 := .T.
	EndIf


	@ 200,001 TO 480,380 DIALOG oReservaPed TITLE OemToAnsi("Manuten็ใo da reserva por al็ada")
	@ 003,005 TO 085,187 PIXEL OF oReservaPed
	@ 010,018 Say "Este programa tem a finalidade de aprovar ou rejeitar " SIZE 150,010 PIXEL OF oReservaPed
	@ 020,018 Say "pedidos que estใo em solicita็ใo de reserva de estoque." SIZE 150,010 PIXEL OF oReservaPed
	If lOk_FATMI008
		@ 065,008 BUTTON "Continua  "  ACTION (Processa({||TFReserva()}),oReservaPed:End())PIXEL OF oReservaPed
	Else
		@ 040,018 Say "*** Usuแrio com acesso bloqueado a esta rotina ***" SIZE 150,010 PIXEL OF oReservaPed
	EndIf
	@ 100,008 BMPBUTTON TYPE 02 ACTION oReservaPed:End()

	Activate Dialog oReservaPed Centered
Return(.T.)


/* Monta tela com pedidos que estใo com controle de reserva pendente */
Static Function TFReserva()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oListBox
	Local nOpc		:= 0
	Local oBmp2, oBmp3


	Private aDados	:= {}
	Private oDlgPedidos
	Private cBloqI

	If Type("oReservaPed") <> "U"
		Close(oReservaPed)
	Endif

	aCampos      := {}
	Cursorwait()

//seleciona os pedidos
	cQuery := " SELECT " + ENTER
	cQuery += " 	C5_NUM AS PEDIDO" + ENTER
	cQuery += " 	,(CASE WHEN C5_CLIORI!='' THEN RTRIM(A1_SP.A1_NOME) ELSE RTRIM(A1_MG.A1_NOME) END) AS CLIENTE" + ENTER
	cQuery += " 	,C5_XITEMC AS LINHA" + ENTER
	cQuery += " 	,SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN) AS VALOR_RESERVA" + ENTER
	cQuery += " 	,(CASE WHEN C5_CLIORI!='' THEN A1_SP.A1_EST ELSE A1_MG.A1_EST END) AS UF_DESTINO" + ENTER
	cQuery += " 	,C5__RESERV" + ENTER
	cQuery += " FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)" + ENTER
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SA1")+" A1_MG WITH(NOLOCK) ON A1_MG.A1_COD = C5_CLIENTE AND A1_MG.A1_LOJA=C5_LOJACLI AND A1_MG.A1_FILIAL=C5_FILDES AND A1_MG.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SA1")+" A1_SP WITH(NOLOCK) ON A1_SP.A1_COD = C5_CLIORI AND A1_SP.A1_LOJA=C5_LOJORI AND A1_SP.A1_FILIAL=C5_FILDES AND A1_SP.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK) ON C6_NUM = C5_NUM  AND C6_FILIAL = C5_FILIAL AND SC6.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " WHERE " + ENTER
	cQuery += " 	C5.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
	cQuery += " AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += " AND C5_NOTA = ''" + ENTER
	cQuery += " AND C5_XITEMC IN ('TAIFF','PROART') " + ENTER
	cQuery += " AND C5__RESERV != '' " + ENTER
	cQuery += " AND C5__DTLIBF = '' " + ENTER
	cQuery += " GROUP BY C5_NUM, C5_CLIORI, C5_XITEMC, A1_SP.A1_NOME, A1_MG.A1_NOME,A1_SP.A1_EST, A1_MG.A1_EST,C5__RESERV " + ENTER
	cQuery += " ORDER BY C5_NUM" + ENTER

	//MemoWrite("FATMI008.SQL",cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
//TcSetField("TRB","C5_EMISSAO","D")

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem pedidos aguardando aprova็ใo de reserva!","Aten็ใo")
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
		// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - CLIENTE, 05 - LINHA, 06 - VALOR_RESERVA, 07 - UF_DESTINO,

		lNota := .F.
		aAdd(aDados,{fColor(),lNota,TRB->PEDIDO,SUBSTR(TRB->CLIENTE,1,30),TRB->LINHA, TRB->VALOR_RESERVA,	TRB->UF_DESTINO,	TRB->C5__RESERV})

		dbSelectArea("TRB")
		dbSkip()
	End
	lNota := .F.
	CursorArrow()

	If Len(aDados) == 0
		MsgStop("Nใo existem dados para aprova็ใo!","Aten็ใo")
		TRB->(dbCloseArea())
		Return
	EndIf



//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0


	aTitCampos := {" "," ",OemToAnsi("Pedido"),OemToAnsi("Cliente"),OemToAnsi("Linha"),OemToAnsi("Vl. Reserva"),OemToAnsi("Uf destino"),OemToAnsi("Status")}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8]}"

	bLine := &( "{ || " + cLine + " }" )

	@ 100,005 TO 550,950 DIALOG oDlgPedidos TITLE "Pedidos com solicita็ใo de reserva"

	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}


	oListBox := TWBrowse():New( 17,4,400,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := Iif(aDados[oListBox:nAt,2]==.T.,.F.,.T.)} //MarcaTodos(oListBox, .F., .T.,1,oListBox:nAt)) }
	oListBox:bLine := bLine

	@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgPedidos
	@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgPedidos

	@ 183,110 BUTTON "Bloquear"  	SIZE 40,15 ACTION BlqRereserva(oListBox,oListBox:nAt,"B")  PIXEL OF oDlgPedidos
	@ 183,160 BUTTON "Desbloquear"  SIZE 50,15 ACTION BlqRereserva(oListBox,oListBox:nAt,"L")  PIXEL OF oDlgPedidos
	@ 183,260 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	@ 050,420 BUTTON "Consulta Pedido"  SIZE 50,15 ACTION ConsPed(oListBox,oListBox:nAt)  PIXEL OF oDlgPedidos

	@ 210,065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,075 SAY "Em espera" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL
	@ 210,115 BITMAP oBmp3 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,125 SAY "Bloqueado" OF oDlgPedidos Color CLR_RED,CLR_WHITE PIXEL
	@ 210,215 BITMAP oBmp2 ResName "BR_AZUL" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,225 SAY "Liberado" OF oDlgPedidos Color CLR_BLUE,CLR_WHITE PIXEL



	ACTIVATE DIALOG oDlgPedidos CENTERED

	TRB->(dbCloseArea())

	If nOpc == 1
	EndIf

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
//BLOQUEADO - "BR_VERMELHO"
//EM ESPERA - "BR_VERDE"
//LIBERADO - "BR_AZUL"

Static Function fColor()

	If TRB->C5__RESERV $ 'R'
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	ElseIf TRB->C5__RESERV $ 'B'
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	ElseIf TRB->C5__RESERV $ 'L'
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	Endif

Return

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



Static Function fColor2(oListBox,nLin)

	If oListbox:aArray[nLin,8]="R"
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	ElseIf oListbox:aArray[nLin,8]="L"
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	ElseIf oListbox:aArray[nLin,8]="B"
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

		If .NOT. oListbox:aArray[nLin,8] $ 'L|B'
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
	nSomaTot := 0

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
------------------------------------------------------------------------------
Apresenta o volume da carga dos pedidos selecionados
------------------------------------------------------------------------------
*/
Static Function ConsPed(oListBox,nLin)
	Local aArea := GetArea()

	PRIVATE lOnUpdate := .T.
	PRIVATE l410Auto := .F.
	PRIVATE aAutoCab := {}
	PRIVATE aAutoItens := {}
	PRIVATE aRotina := MenuDef()
	PRIVATE cCadastro := "Visualiza็ใo de Pedidos de Venda"

	INCLUI := .F.
	ALTERA := .F.

	SC5->(DbSetOrder(1))
	If SC5->(DbSeek( xFilial("SC5") + oListbox:aArray[nLin,3]))
		MsAguarde({||A410Visual("SC5",SC5->(RECNO()),2)})
	EndIf

	RestArea(aArea)
Return

/*
------------------------------------------------------------------------------
Manuten็ใo no campo de bloqueio/desbloqueio da reserva
------------------------------------------------------------------------------
*/
Static Function BlqRereserva(oListBox,nLin,cAcao)

	Local nX := 0

	For nX := 1 TO Len(oListbox:aArray)
		If oListbox:aArray[nX,2] = .T.
			oListbox:aArray[nX,8] := cAcao

			SC5->(DbSetOrder(1))
			If SC5->(DbSeek( xFilial("SC5") + oListbox:aArray[nX,3]))
				If SC5->(RecLock("SC5",.F.))
					SC5->C5__RESERV := cAcao
					SC5->C5__LOGRES := SUBSTR(Upper(Rtrim(CUSERNAME)),1,10) + " " + DTOC(dDatabase) + " " + Time()
					SC5->(msUnlock())
					oListbox:aArray[nX,1] := fcolor2(oListBox,nLin)
				EndIf
			EndIf
		EndIf
	Next

Return

