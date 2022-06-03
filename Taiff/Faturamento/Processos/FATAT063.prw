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
ฑฑบPrograma  ณFATAT063  บAutor  ณPaulo Bindo         บ Data ณ  11/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera NF baseada no pedido automaticamente                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATAT063()
	Local AAREASM0		:= SM0->(GETAREA())

	Public _cMarca := GetMark()

	Private cQueryCad 	:= ""
	Private cPergF     	:= "MT460A"
	Private cPerg		:= "FTAT63"
	Private cPedS     := CriaVar("C6_NUM")
	Private aPedS     := {}
	Private _lVerAglut:= .F.
	Private aFields   := {}
	Private _cIndex   := ''
	Private oGeraNf
	Private	cItemList 	:= "00"
	Private	nItem 	  	:= 0
	Private lNota 		:= .F.
	Private cForma
	Private nTipoNf		:= 0
	Private _cClienteCros:= ""
	Private _cLojaCros 	:= ""
	Private _cNfeSerie	:= GetNewPar("TF_SERIE","TAIFF=1|PROART=2")
	Private _nMaxItens	:= GetNewPar("TF_MAXITENS",1000)
	Private _nMarca		:= 0
	Private cUserName 	:= UsrFullName(RetCodUsr()) // Login do usuแrio logado
	Private cMailDest		:= ""
	Private cLaPerg 		:= "TFIMPCARGA"

	cSerie  := ''//GetMV('MV_SERIENF')+Space(3-Len(GetMV('MV_SERIENF')))

/*
Busca a clinte/loja do CD destino padrใo 
*/
	DBSELECTAREA("SM0")
	DBSETORDER(1)

	SM0->(DBSEEK("0301"))

	DBSELECTAREA("SA1")
	DBSETORDER(3)
	DBSEEK(XFILIAL("SA1")+SM0->M0_CGC)

	_cClienteCros	:=SA1->A1_COD
	_cLojaCros 	:=SA1->A1_LOJA

	RESTAREA(AAREASM0)

	cMailDest := TF063sx6()
	cMailDest += Iif( .not. Empty(cMailDest),";","") + Alltrim(UsrRetMail(RetCodUsr()))

	TCriaSx1Perg( cLaPerg )

	ValidPerg(cPerg)


	@ 200,001 TO 480,380 DIALOG oGeraNf TITLE OemToAnsi("Agrupamento de Pedidos")
	@ 003,005 TO 085,187 PIXEL OF oGeraNf
	@ 010,018 Say "Este programa tem a finalidade de selecionar pedidos que" SIZE 150,010 PIXEL OF oGeraNf
	@ 020,018 Say "serใo agrupados em nota fiscal de Cross Docking." SIZE 150,010 PIXEL OF oGeraNf
	@ 065,008 BUTTON "Continua  "  ACTION (Processa({||Fatura("F")}),oGeraNf:End())PIXEL OF oGeraNf
	@ 100,008 BMPBUTTON TYPE 02 ACTION oGeraNf:End()

	Activate Dialog oGeraNf Centered
Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMaRwProc  บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MaRwProc()
	Local cHtml := ""
	//Local c
	Local _nX	:= 0

	Private aNotas := {}
	Private aPvlNfs   := {}
	Private aSitPvlNfs:= {}

	lAdiciona := .T.
	_cNota    := ''
	_cNotaPri := ''

	cPedido := cPedS
	cPedS   := CriaVar("C6_NUM")
	cCli	:= CriaVar("C5_CLIENTE")
	If Len(aPedS) = 0
		AaDd(aPedS,{cPedido,cCli})
	Endif

/*
//PERGUNTA DA EMISSAO DA NF
	If! Pergunte(cPergF,.T.)
	Return
	EndIf
*/

	_lVerAglut := .T. //Iif(mv_par11 == 1,.T.,.F.)

	ProcRegua(Len(aPedS))

//QUANDO FOR AGLUTINAR COLOCA POR ORDEM DE CLIENTE
	If _lVerAglut
		ASort(aPedS,,,{|x,y|x[2]<y[2]})
		cCliAgl := aPedS[1][2]          //CLIENTE AGLUTINACAO
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+aPedS[1][1])
		cCondAgl 	:= SC5->C5_CONDPAG
		cTranspAgl	:= SC5->C5_TRANSP
	EndIf

	SA1->(DbSetOrder(1))
	DA1->(DbSetOrder(1))

	cNumCarga := Dtos(ddatabase) + substr(time(),1,2) + substr(time(),4,2)

	For _nX := 1 To Len(aPedS)

		IncProc("Processando Pedido "+AllTrim(Str(_nX))+" de "+AllTrim(Str(Len(aPedS))))
		ProcessMessages()
		cPedido := Upper( aPedS[_nX][1] )

		dbSelectArea("SC6")
		dbSetORder(1)
		If !dbSeek(xFilial("SC6")+cPedido)
			MsgStop('Pedido '+cPedido+' com problema, verifique !!!')
			U_FATAT063()
			Return(.T.)
		Endif

		dbSelectArea("SC6")
		While !Eof() .AND. C6_FILIAL+C6_NUM == xFilial("SC6")+cPedido

			dbSelectArea("SC9")
			dbSetORder(1)
			dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

			While !Eof() .AND. xFilial("SC9") == SC9->C9_FILIAL .AND. SC6->C6_NUM == SC9->C9_PEDIDO .AND. SC6->C6_ITEM = SC9->C9_ITEM

				If Empty(SC9->C9_NUMOF) .AND. SC9->C9_BLEST != "02"
					If SC9->(RecLock("SC9", .F.))
						SC9->C9_NUMOF := cNumCarga
						SC9->(MsUnLock())
					EndIf
				EndIf
				DbSkip()
			EndDo

			DbSelectArea('SC6')
			dbSkip()
		EndDo

		//QUANDO FOR AGLUTINACAO
		//VERIFICA SE EXISTE PROXIMO PEDIDO NO ARRAY, E CASO EXISTA COMPARA TRANSP E COND.PAG
		If Len(aPedS) > _nX .And. _lVerAglut
			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(xFilial("SC5")+aPedS[_nX+1][1])

			If !(SC5->C5_CLIENTE == aPedS[_nX][2] .And. cTranspAgl	 == SC5->C5_TRANSP)
				//EMITE NOTAS
				If  Len(aPvlNfs) > 0
					cNota := GeraNota("1")
					aAdd(aNotas,cNota)
				EndIf
				aPvlNfs := {}
			EndIf
		EndIf

		If !_lVerAglut .Or. Len(aPedS) == _nX

			//EMITE NOTAS
			If  Len(aPvlNfs) > 0
				cNota := GeraNota("1")
				aAdd(aNotas,cNota)
			EndIf
			aPvlNfs := {}
		Endif
		cCliAgl 	:= aPedS[_nX][2]
		cCondAgl 	:= SC5->C5_CONDPAG
		cTranspAgl	:= SC5->C5_TRANSP

	Next

	cMensagem := ""
	cMensagem += CHR_FONT_CAB_OPEN
	cMensagem += "Processo de Cross Docking" + CHR_ENTER
	cMensagem += CHR_FONT_CAB_CLOSE
	cMensagem += CHR_FONT_DET_OPEN
	cMensagem += "Este e-mail automatico refere-se ao processo de Cross Docking: Emissใo de nota fiscal de transferencia." + CHR_ENTER
	cMensagem += "O Sr.(a): " + Alltrim(cUserName) + " foi o responsavel pela sele็ใo de pedidos." + CHR_ENTER
	cMensagem += "Os produtos para faturamento sใo da marca " +  Iif(_nMarca=1,"TAIFF","PROART") + CHR_ENTER
	cMensagem += "C๓digo da Carga: " + AllTrim(cNumCarga) + CHR_ENTER
	cMensagem += "Pedidos selecionados: "
	For _nX := 1 To Len(aPedS)
		cMensagem += Upper( aPedS[_nX][1] )
		If _nX != Len(aPedS)
			cMensagem += ", "
		EndIf
	Next
	cMensagem += CHR_FONT_DET_CLOSE

	If ( "DESENV" $ Upper(Alltrim(GetEnvServer())) )  /* Nos ambientes DESENV a serie ้ diferente ao da PRODUCAO */
		cHtml := '<H1>Processo de Cross Docking - T E S T E</H1>'
	Else
		cHtml := '<H1>Processo de Cross Docking</H1>'
	EndIf
	SC9->(DBORDERNICKNAME("SC9_NUMOF"))
	SC9->(DbSeek( xFilial("SC9") + cNumCarga ))

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") + SC9->C9_PEDIDO))

	SA4->(DbSetorder(1))
	SA4->(Dbseek( xFilial("SA4") + SC5->C5_TRANSP ))

	If At("ATIVA",SA4->A4_NOME) != 0
		cHtml += '<H3>Transportadora: ATIVA</H3>'
	ElseIf  At("FRIBURGO",SA4->A4_NOME) != 0
		cHtml += '<H3>Transportadora: FRIBURGO</H3>'
	ELSE
		cHtml += '<H3>Transportadora: </H3>'
	EndIf

	cHtml += '<table border="1"><tr><th>Marca</th><th>Carga</th><th>Pedido MG</th><th>Cliente</th><th>Pedido SP</th></tr>'

	While SC9->(C9_FILIAL + C9_NUMOF) = xFilial("SC9") + cNumCarga .AND. !SC9->(Eof())

		cMarca := ""
		If SC9->C9_XITEM="1"
			cMarca := "TAIFF"
		ElseIf SC9->C9_XITEM="2"
			cMarca := "PROART"
		EndIf

		cHtml += '<tr><td>' + cMarca + '</td><td>' + SC9->C9_NUMOF + '</td><td>' + SC9->C9_PEDIDO + '</td><td>' + SC9->C9_NOMORI + '</td><td>' + SC9->C9_PEDORI + '</td></tr>'
		cNumPedido := SC9->C9_PEDIDO

		While SC9->(C9_FILIAL + C9_NUMOF + C9_PEDIDO) = xFilial("SC9") + cNumCarga + cNumPedido .AND. !SC9->(Eof())

			SC9->(DbSkip())
		End
	End
	SC9->(dbSetORder(1))

	cHtml += '</table>'
	Memowrite("Carga_Cross_Docking.HTML",cHtml)

	cMailDest := TF063sx6()
	//cMailDest += Iif( .not. Empty(cMailDest),";","") + Alltrim(UsrRetMail(RetCodUsr()))

	//cMailDest := "carlos.torres@taiffproart.com.br"

	U_2EnvMail("workflow@taiff.com.br",RTrim(cMailDest)	,'',cHtml	,"Pedidos do CD para faturamento" + Iif( At( "DESENV",GetEnvServer()) != 0," TESTE",""),'')

	cMensagem := "PROCESSO CONCLUIDO!" + ENTER
	cMensagem += "CODIGO DA CARGA: " + cNumCarga + ENTER
	cMensagem += "e-mail automแtico enviado ao FATURAMENTO " + ENTER


	MsgInfo(cMensagem)

	lNota := .F.
//U_FATAT063()
Return



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

	If Len(aPvlNfs)==0
		MsgBox ("Nao existem dados para gerar o agrupamento de pedidos. Verifique liberacoes","Aten็ao","ALERT")
		Close(oGeraNf)
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

Static Function Fatura(cFr)
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oListBox
	Local nOpc		:= 0
	Local oBmp2, oBmp3
	Local z			:= 0

	Private aDados	:= {}
	Private oDlgPedidos
	Private cBloqI
	cForma := cFr

	If Type("oGeraNf") <> "U"
		Close(oGeraNf)
	Endif

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif

/*
SX1->(DbsetOrder(1))
	If SX1->( Dbseek(PADR('FTAT63',Len(SX1->X1_GRUPO))+'09') )
	Reclock('SX1',.F.)
	SX1->X1_PRESEL := mv_par09
	SX1->(MsUnlock())
	EndIf
RestArea(aSx1area)
*/



/*
MV_PAR01 - DO Cliente
MV_PAR02 - ATE O CLIENTE
MV_PAR03 - DA DATA EMISSAO
MV_PAR04 - ATE A DATA EEMISSAO
MV_PAR05 - DA TRANSPORTADORA
MV_PAR06 - ATE A TRANSPORTADORA
MV_PAR07 - DO PEDIDO
MV_PAR08 - ATE O PEDIDO

MV_PAR11 - TIPO FAT PEDIDO/TROCAS/SERVICOS
*/

	INCLUI       := .F.

	aCampos      := {}
	_cPesqPed    := Space(6)
	_nTotal      := 0
	_nMarca		:= mv_par09
	Cursorwait()
//seleciona os pedidos
	cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_TRANSP, C9_NUMOF, " + ENTER
	cQuery += " CASE C5_XITEMC WHEN 'PROART' THEN C5_VOLUME1 ELSE " + ENTER
	cQuery += " (SELECT dbo.RET_VOLUME_PEDIDO('03', '"+xFilial("SC9")+"', C5_NUM)) END AS C5_VOLUME1, " + ENTER
	cQuery += " (SELECT COUNT(C6_ITEM) FROM "+RetSqlName("SC6")+"  C6 WITH(NOLOCK) WHERE C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL AND C5_CLIENTE = C6_CLI AND C6.D_E_L_E_T_ <> '*') AS C6_ITEM," + ENTER
	cQuery += " SUM(C9_QTDLIB* ISNULL(DA1_PRCVEN,0)) AS C6_VALOR," + ENTER
	cQuery += " COUNT( DISTINCT(C9_ITEM)) AS C9_ITEM," + ENTER
	cQuery += " C5_NOMCLI AS A1_NOME, " + ENTER
	cQuery += " A4_NOME, " + ENTER
	cQuery += " C5_LOJACLI, " + ENTER
	cQuery += " CB7_STATUS " + ENTER
	cQuery += " ,CASE ISNULL(CB7.CB7_STATUS,'') WHEN '9' THEN '' WHEN '' THEN 'OS nใo iniciada' ELSE 'OS em andamento' END AS BLOQUEIO " + ENTER
	cQuery += " ,C5_XITEMC " + ENTER
	cQuery += " FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)" + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 WITH(NOLOCK) ON A1_COD = C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1_FILIAL=C5_FILIAL AND A1.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA4")+" A4 WITH(NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SC9")+" SC9 WITH(NOLOCK) ON C9_BLEST = '' AND C9_BLCRED = ''  AND C9_NFISCAL='' AND C9_PEDIDO = C5_NUM  AND C9_FILIAL = C5_FILIAL AND C5_CLIENTE = C9_CLIENTE AND SC9.D_E_L_E_T_ <> '*' AND C9_DATALIB>='" + Dtos(mv_par01) + "' AND C9_DATALIB<='" + Dtos(mv_par02) + "' " + ENTER
	cQuery += " LEFT OUTER JOIN "+RetSqlName("DA1") + " DA1 WITH(NOLOCK) ON DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB = A1_TABELA AND DA1.D_E_L_E_T_ <> '*' AND DA1_CODPRO=C9_PRODUTO " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("CB7") + " CB7 WITH(NOLOCK) ON CB7.D_E_L_E_T_='' AND C9_PEDIDO = CB7_PEDIDO  AND C9_FILIAL = CB7_FILIAL AND C5_CLIENTE = CB7_CLIENT AND CB7_ORDSEP = C9_ORDSEP "  + ENTER

	cQuery += " WHERE C5_CLIENTE = '"+_cClienteCros+"' AND C5_LOJACLI='"+_cLojaCros+"' " + ENTER
	cQuery += " AND C5_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'" + ENTER
	cQuery += " AND C5_TRANSP BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'" + ENTER
	cQuery += " AND C5_NUM BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'" + ENTER
	cQuery += " AND C5.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
	cQuery += " AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += " AND C5_NOTA = ''" + ENTER
	cQuery += " AND C5_XITEMC = '"+ Iif( mv_par09=1,"TAIFF",Iif(mv_par09=2,"PROART","CORP")) +"' " + ENTER
	cQuery += " AND C5_NUMOC = 'CROSS' " + ENTER
	If  mv_par10=1
		cQuery += " AND ISNULL(CB7.CB7_STATUS,'') = '9' " + ENTER
	EndIf

//cQuery += " AND C5_NUM IN (SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" SC9  WITH(NOLOCK) WHERE C9_NFISCAL='' AND C9_PEDIDO = C5_NUM  AND C9_FILIAL = C5_FILIAL AND C5_CLIENTE = C9_CLIENTE AND SC9.D_E_L_E_T_ <> '*' AND C9_DATALIB>='" + Dtos(mv_par01) + "' AND C9_DATALIB<='" + Dtos(mv_par02) + "' ) " + ENTER

	cQuery += " GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_TRANSP, C5_NOMCLI, A4_NOME, C5_LOJACLI, CB7_STATUS, C5_XITEMC, C5_YSTSEP, C5_VOLUME1, C9_NUMOF" + ENTER
	cQuery += " ORDER BY C5_NUM" + ENTER

	//MemoWrite("FATAT063.SQL",cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	TcSetField("TRB","C9_DATALIB","D")

	TcSetField("TRB","C5_EMISSAO","D")

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

		//VERIFICA SE PEDIDO ษ FILIAL 0302 E PROART E SE TEVE PESAGEM FINALIZADA //TRADE
		_fProc := .T.

		IF  cEmpAnt + cFilAnt = "0302" .AND. alltrim(TRB->C5_XITEMC) == "PROART"

			_cQuery := "SELECT ISNULL(COUNT(*),0) AS NPESPENDENTE " + ENTER
			_cQuery += "FROM "+RETSQLNAME("ZAR")+" ZAR " 		+ ENTER
			_cQuery += "JOIN "+RETSQLNAME("CB7")+" CB7 ON "     + ENTER
			_cQuery += "ZAR_FILIAL = CB7_FILIAL AND ZAR_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = '' " + ENTER
			_cQuery += "WHERE ZAR_FILIAL = '"+ XFILIAL("ZAR")+"' AND "	+ ENTER
			_cQuery += "CB7_PEDIDO = '"+TRB->C5_NUM+"' AND ZAR_STATUS <> 'F' "		+ ENTER
			_cQuery += "AND ZAR.D_E_L_E_T_ = ''

			//MemoWrite("FATAT063_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)
			IF  SELECT("TZAR")
				TZAR->(Dbclosearea())
			ENDIF
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TZAR',.F.,.T.)

			TZAR->(DbGoTop())

			IF TZAR->NPESPENDENTE > 0
				_fProc := .F.
			ENDIF
			TZAR->(Dbclosearea())
		ENDIF

		IF  _fProc //TRADE

			// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - BLOQUEIOS, 05 - COD CLI, 06 - RAZAO, 07 - COD TRANS, 08 - NOME TRANS, 09 - VALOR, 10 - VOLUME, 11 - ITEM PED, 12 - ITEM LIB, 13-NOTA, 14-PEDIDO PAI,15-SEQUENCIA PEDIDOS PARA FATURAR,16-LOJA DO CLIENTE DO PEDIDO
			//If (mv_par10== 1 .And. TRB->C6_ITEM == TRB->C9_ITEM) .Or. mv_par10 == 2
			lNota := .F.
			aAdd(aDados,{fColor(),lNota,TRB->C5_NUM,TRB->BLOQUEIO,TRB->C9_NUMOF, AllTrim(TRB->A1_NOME),	TRB->C5_TRANSP, AllTrim(TRB->A4_NOME),TRB->C6_VALOR,TRB->C5_VOLUME1, TRB->C6_ITEM,TRB->C9_ITEM, TRB->CB7_STATUS, '',''})
		ENDIF

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


	aTitCampos := {" "," ",OemToAnsi("Pedido"),OemToAnsi("Separa็ใo"),OemToAnsi("Num. Carga"),OemToAnsi("Cliente"),OemToAnsi("Cod.Transp."),OemToAnsi("Transportadora"),;
		OemToAnsi("Valor"), OemToAnsi("Volume"), OemToAnsi("Itens Pedido"),OemToAnsi("Itens Liberados"),OemToAnsi("Status OS"),OemToAnsi(""),OemToAnsi("Sequencia")}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],aDados[oListBox:nAT][10],aDados[oListBox:nAT][11],aDados[oListBox:nAT][12],aDados[oListBox:nAT][13],aDados[oListBox:nAT][14],aDados[oListBox:nAT][15],}"

	bLine := &( "{ || " + cLine + " }" )

	@ 100,005 TO 550,950 DIALOG oDlgPedidos TITLE "Pedidos"

	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}


	oListBox := TWBrowse():New( 17,4,400,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := Iif(aDados[oListBox:nAt,2]==.T.,.F.,Iif( At(aDados[oListBox:nAt,13], '9|G' ) = 0 .OR. .NOT. Empty(aDados[oListBox:nAt,5]),.F.,.T.))} //MarcaTodos(oListBox, .F., .T.,1,oListBox:nAt)) }
	oListBox:bLine := bLine

	@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgPedidos
	@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgPedidos

	@ 183,110 BUTTON "Agrupar"  	SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()}  PIXEL OF oDlgPedidos
	@ 183,160 BUTTON "Desagrupar "  SIZE 50,15 ACTION Desagrp(oListBox,oListBox:nAt)  PIXEL OF oDlgPedidos
	@ 183,260 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	@ 050,420 BUTTON "Consulta Volume"  SIZE 50,15 ACTION ConsVol(oListBox,oListBox:nAt)  PIXEL OF oDlgPedidos
	@ 070,420 BUTTON "Imprime Carga"  SIZE 50,15 ACTION ImprCarga(oListBox,oListBox:nAt)  PIXEL OF oDlgPedidos
	@ 090,420 BUTTON "Qtd. Selecionados"  SIZE 50,15 ACTION ConsSelecao(oListBox,oListBox:nAt)  PIXEL OF oDlgPedidos

	@ 210,065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,075 SAY "Apto a Agrupar" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL
	@ 210,115 BITMAP oBmp3 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,125 SAY "OS em andamento/nใo iniciada" OF oDlgPedidos Color CLR_RED,CLR_WHITE PIXEL
	@ 210,115+100 BITMAP oBmp2 ResName "BR_AZUL" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,125+100 SAY "Agrupado" OF oDlgPedidos Color CLR_BLUE,CLR_WHITE PIXEL

	ACTIVATE DIALOG oDlgPedidos CENTERED

	TRB->(dbCloseArea())

	If nOpc == 1
		nSomaTot := 0
		nQtdItens:= 0
		ASort(aDados,,,{|x,y|x[15]<y[15]})
		For z:= 1 To Len(aDados)
			If aDados[z][2]
				aAdd(aPeds,{aDados[z][3],aDados[z][5]})
				nSomaTot += aDados[z][9]
				nQtdItens+= aDados[z][12]
			EndIf
		Next

		If Len(aPeds) > 0
			If nQtdItens >  _nMaxItens
				MsgInfo("A quantidade de " + Alltrim(Str(nQtdItens)) + " itens selecionado que irใo compor a nota fiscal ultrapassa o limite de " + Alltrim(Str(_nMaxItens)) + " itens." + ENTER + "Refa็a a sele็ใo de pedidos.")
			Else
				MsgInfo("Total Pedidos selecionados: "+Str(nSomaTot,12,2))
				MaRwProc()
			EndIf
		EndIf
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
//DEVOLUCAO- "BR_BRANCO"
//FATURADO - "BR_VERMELHO"
//LIBERADO - "BR_VERDE"
//BLOQUEIO - "BR_AZUL"
//BLOQUEIO VOLUME - "BR_AMARELO"

Static Function fColor()

//LIBERADO
	If TRB->CB7_STATUS $ '9|G' .AND. Empty(TRB->C9_NUMOF) //Empty(TRB->C5_NOTA) //.And. TRB->C5_VOLUME1 > 0
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	Endif

//BLOQUEIO
	If .NOT. TRB->CB7_STATUS $ '9|G'
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif

	If TRB->CB7_STATUS $ '9|G' .AND. .NOT. Empty(TRB->C9_NUMOF)
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	Endif
/*
//BLOQUEIO
	If TRB->C6_ITEM <> TRB->C9_ITEM  .And. .NOT. TRB->CB7_STATUS $ '9|G'
	Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	Endif
*/

/*
//FATURADO
	If !Empty(TRB->C5_NOTA)
	Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif
*/
/*
//VOLUME
	If  Empty(C5_NOTA) .And. TRB->C5_VOLUME1 == 0
Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	Endif
*/
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

//FATURADO - "BR_VERMELHO"
//LIBERADO - "BR_VERDE"
//BLOQUEIO - "BR_AZUL"
//BLOQUEIO VOLUME - "BR_AMARELO"

Static Function fColor2(oListBox,nLin)

//LIBERADO
	If oListbox:aArray[nLin,11] == oListbox:aArray[nLin,12] .And. Empty(oListbox:aArray[nLin,4]) .And. Empty(oListbox:aArray[nLin,13])// .And. oListbox:aArray[nLin,10] > 0
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	Endif

//BLOQUEIO
	If (oListbox:aArray[nLin,11] <> oListbox:aArray[nLin,12] .Or. !Empty(oListbox:aArray[nLin,4])) .And. Empty(oListbox:aArray[nLin,13])
		Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
	Endif

//FATURADO
	If !Empty(oListbox:aArray[nLin,13])
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif


	If .NOT. Empty(oListbox:aArray[nLin,5])
		Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	Endif

/*
//VOLUME
	If  Empty(oListbox:aArray[nLin,13]) .And. oListbox:aArray[nLin,10] == 0
Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
	Endif
*/
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
	Local xp := 0

	If lInverte
		oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
	Else
		If lMarca
			oListbox:aArray[nLin,2] := .T.
		Else
			oListbox:aArray[nLin,2] := .F.
		EndIf
	EndIf
// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - BLOQUEIOS, 05 - COD CLI, 06 - RAZAO, 07 - COD TRANS, 08 - NOME TRANS, 09 - VALOR, 10 - VOLUME, 11 - ITEM PED, 12 - ITEM LIB, 13-NOTA

	If lMarca .And. cForma <> "D"
	/*
	//BLOQUEIO
		If (!Empty(oListbox:aArray[nLin,4])) .And. Empty(oListbox:aArray[nLin,13])
	MsgStop("Este item pedido possui bloqueio ou nใo foi conferido!","Aten็ใo - FATAT063")
	oListbox:aArray[nLin,2] := .F.
		Endif
	*/
	/*
	//ITENS DO PEDIDO DIFERENTE DO LIBERADO
		If (oListbox:aArray[nLin,11] <> oListbox:aArray[nLin,12] )
		MsgStop("Este item pedido possui problema de Libera็โo, deve ser cancelado e gerado novamente!","Aten็ใo - FATAT063")
		oListbox:aArray[nLin,2] := .F.
		Endif
	*/

		If .NOT. oListbox:aArray[nLin,13] $ '9|G'
			oListbox:aArray[nLin,2] := .F.
		Endif

		If .NOT. Empty(oListbox:aArray[nLin,5])
			oListbox:aArray[nLin,2] := .F.
		Endif
	/*
	//FATURADO
		If !Empty(oListbox:aArray[nLin,13])
		MsgStop("Este item pedido jแ foi faturado!","Aten็ใo - FATAT063")
		oListbox:aArray[nLin,2] := .F.
		Endif
	*/
	/*
	//bloqueio volume
		If Empty(oListbox:aArray[nLin,13]) .And. oListbox:aArray[nLin,10] == 0
			If MsgYesNo("Volume nใo cadastrado! Deseja ALterar","Aten็ใo - FATAT063")
	AjustVol(oListBox,nLin)
			Else
	oListbox:aArray[nLin,2] := .F.
			EndIf
		Endif
	*/
	EndIf

//VERIFICA SE ALGUM ITEM FICARม NEGATINO NO ESTOQUE
	aSldReserva:= {}
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek(xFilial("SC9")+oListbox:aArray[nLin,3])

	While !Eof() .AND. xFilial("SC9") == SC9->C9_FILIAL .AND. oListbox:aArray[nLin,3] == SC9->C9_PEDIDO

		If EMPTY(SC9->C9_NFISCAL)
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)

			dbSelectArea("SB2")
			dbSetOrder(1)
			MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)

			dbSelectArea("SF4")
			dbSetOrder(1)
			MsSeek(xFilial("SF4")+SC6->C6_TES)

			nSldReserva := Iif(SB2->B2_RESERVA-SC9->C9_QTDLIB<=0,0,SB2->B2_RESERVA-SC9->C9_QTDLIB)

			If SF4->F4_ESTOQUE == "S" .AND. SC9->C9_BLEST != "02"
				nAscan := Ascan(aSldReserva, {|e| e[1]== SC9->C9_PRODUTO })

				If nAscan == 0
					//01 - PRODUTO, 02- LIBERADO, 03- SALDO ATUAL
					aAdd(aSldReserva,{SC9->C9_PRODUTO,SC9->C9_QTDLIB,SB2->B2_QATU })
				Else
					aSldReserva[nAscan][2] += SC9->C9_QTDLIB
				EndIf

			EndIf
		EndIf
		DbSelectarea("SC9")
		DbSkip()
	EndDo

	cMensSld := ""
	For xp:=1 To Len(aSldReserva)

		If aSldReserva[xp][2] > aSldReserva[xp][3]
			cMensSld += aSldReserva[xp][1]+ENTER
			oListbox:aArray[nLin,2] := .F.
		EndIf
	Next

	If !Empty(cMensSld)
		MsgStop("O produto Ficarแ com estoque negativo, opera็ใo cancelada!" + ENTER + cMensSld ,"Aten็ใo - FATAT063")
	EndIf

	If nItem == 1
		If oListbox:aArray[nLin,2] == .F.
			Return(.F.)
		ElsE
			Return(.T.)
		EndIf
	Else
		aDados[nLin,2] := oListbox:aArray[nLin,2]
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
			nSomaTot += oListbox:aArray[nX,9]
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

	PutSx1(cPerg,"01"   ,"Da Data Liberacao   ?",""                    ,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Ate a Data Liberacao?",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,""    	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Da Data Emissao   	?",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Ate a Data Emissao	?",""                    ,""                    ,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    			,""    	,""         ,""   ,"mv_par04",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Da Transportadora	?",""                    ,""                    ,"mv_ch5","C"   ,06      ,0       ,0      , "G",""    			,"SA4" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Ate a TRansportadora?",""                    ,""                    ,"mv_ch6","C"   ,06      ,0       ,0      , "G",""    			,"SA4" 	,""         ,""   ,"mv_par06",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Do Pedido  			?",""                    ,""                    ,"mv_ch7","C"   ,06      ,0       ,0      , "G",""    			,"SC5" 	,""         ,""   ,"mv_par07",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Ate o Pedido   		?",""                    ,""                    ,"mv_ch8","C"   ,06      ,0       ,0      , "G",""    			,"SC5" 	,""         ,""   ,"mv_par08",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Marca			   		?",""                    ,""                    ,"mv_ch9","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par09","TAIFF"			 ,""      ,""      ,""    ,"PROART"	   	,""     ,""      ,"CORP"	     	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Status		   		?",""                    ,""                    ,"mv_ch0","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par10","Finalizados" 	 ,""      ,""      ,""    ,"Todos"	      	,""     ,""      ,""    	    	,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCaract บAutor  ณMicrosiga           บ Data ณ  04/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTirar caracteres dos campos de telefone                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetCaract(cTel)



	cTel	:= Strtran(cTel,"/","")
	cTel	:= Strtran(cTel,".","")
	cTel	:= Strtran(cTel,"-","")
	cTel	:= Strtran(cTel," ","")
	cTel	:= Strtran(cTel,"(","")
	cTel	:= Strtran(cTel,")","")
Return cTel


/*
------------------------------------------------------------------------------
Apresenta o volume da carga dos pedidos selecionados
------------------------------------------------------------------------------
*/
Static Function ConsVol(oListBox,nLin)
	Local nX := 0

	nOpc	:= 1

	nVolume := 0
	nValTot := 0

	For nX := 1 TO Len(oListbox:aArray)
		If oListbox:aArray[nX,2] = .T.
			nVolume += oListbox:aArray[nX,10]
			nValTot += oListbox:aArray[nX,09]
		EndIf
	Next

	DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "Volume da Carga" PIXEL
	@ 003,005 TO 060,105 PIXEL OF oLocal
	@ 013,007 SAY "Volume da Carga:" SIZE  60, 7 PIXEL OF oLocal
	@ 012,055 SAY nVolume SIZE  29, 9 Picture "99999" PIXEL OF oLocal

	@ 033,007 SAY "Custo da Carga:" SIZE  60, 7 PIXEL OF oLocal
	@ 032,055 SAY nValTot SIZE  59, 9 Picture "@R 99,999,999.99" PIXEL OF oLocal

	DEFINE SBUTTON FROM 065,010 TYPE 1 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
	ACTIVATE MSDIALOG oLocal CENTER

Return
/*
------------------------------------------------------------------------------
Apresenta o volume da carga dos pedidos selecionados
------------------------------------------------------------------------------
*/
Static Function Desagrp(oListBox,nLin)
	Local nOpc	:= 1
	Local cNumOf := ""
	Local lStatusNf := .T.
	Local cMensagem
	Local nX	:= 0

	cNumOf := oListbox:aArray[nLin,5]

	If .NOT. Empty(cNumOf)
		DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "Carga a Desagrupar" PIXEL
		@ 003,005 TO 060,105 PIXEL OF oLocal
		@ 014,007 SAY "Codigo da Carga:" SIZE  60, 7 PIXEL OF oLocal
		@ 013,055 SAY cNumOf SIZE  29, 9 Picture "@!" PIXEL OF oLocal


		DEFINE SBUTTON FROM 065,010 TYPE 1 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
		DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
		ACTIVATE MSDIALOG oLocal CENTER

		If nOpc == 1
			dbSelectArea("SC9")
			DBORDERNICKNAME("SC9_NUMOF") // C9_FILIAL C9_NUMOF C9_PEDIDO C9_ITEM C9_PRODUTO

			For nX := 1 TO Len(oListbox:aArray)
				If oListbox:aArray[nX,5] = cNumOf
					If dbSeek(xFilial("SC9")+cNumOf+oListbox:aArray[nLin,3]) .AND. lStatusNf  //ALTERADO PARA CHECAR ORDEM CARGA E PEDIDO, SENAO O PEDIDO PARCIAL APARECE
						lStatusNf := Empty( SC9->C9_NFISCAL )
					EndIf
				EndIf
			Next

			If .NOT. lStatusNf
				MsgStop("O estorno da carga em questใo nใo pode ser efetuada jแ que o pedido tem nota fiscal emitida!","Aten็ใo - FATAT063")
			Else
				cQuery := "SELECT COUNT(*) AS NREG " + ENTER
				cQuery += " FROM " + RetSQLName("SC9")+" SC9 " + ENTER
				cQuery += " WHERE " + ENTER
				cQuery += " C9_FILIAL = '"+xFilial("SC9")+"' " + ENTER
				cQuery += " AND C9_NUMOF = '" + cNumOf + "' "  + ENTER
				cQuery += " AND C9_XITEM = '" + Alltrim(Str(_nMarca)) + "' " + ENTER
				cQuery += " AND C9_NFISCAL != '' " + ENTER
				cQuery += " AND SC9.D_E_L_E_T_ = '' " + ENTER
				//MemoWrite("FATAT063_Desagrp_select_de_numof.SQL",cQuery)

				IF SELECT("AUX") > 0
					DBSELECTAREA("AUX")
					DBCLOSEAREA()
				ENDIF

				TCQUERY CQUERY NEW ALIAS "AUX"
				DBSELECTAREA("AUX")

				IF AUX->NREG > 0

					cMensagem := "PROCESSO NรO REALIZADO!" + ENTER
					cMensagem += "CODIGO DA CARGA: " + cNumOf + " NรO FOI ESTORNADA " + ENTER
					cMensagem += "A carga ainda estแ vinculada a nota fiscal!" + ENTER

				Else

					aResult := {}
					If TCSPExist("SP_ENVIA_EMAIL_CARGA_TAIFF")	
						aResult := TCSPEXEC( "SP_ENVIA_EMAIL_CARGA_TAIFF", cNumOf, Iif(_nMarca=1,"TAIFF","PROART"), xFilial("SC9"), cMailDest, 'Estorno de carga no CD' )
					Endif
					IF Empty(aResult)
						Final('Erro na execucao da Stored Procedure SP_ENVIA_EMAIL_CARGA_TAIFF: '+TcSqlError())
					EndIf

					cUpdate := " UPDATE SC9 SET " + ENTER
					cUpdate += " 		C9_NUMOF = '' " + ENTER
					cUpdate += " FROM " + RetSQLName("SC9")+" SC9 " + ENTER
					cUpdate += " WHERE " + ENTER
					cUpdate += " C9_FILIAL = '"+xFilial("SC9")+"' " + ENTER
					cUpdate += " AND C9_NUMOF = '" + cNumOf + "' "  + ENTER
					cUpdate += " AND C9_XITEM = '" + Alltrim(Str(_nMarca)) + "' " + ENTER
					cUpdate += " AND C9_NFISCAL = '' " + ENTER
					cUpdate += " AND SC9.D_E_L_E_T_ = '' " + ENTER

					//MemoWrite("FATAT063_Desagrp_update_de_numof.SQL",cUpdate)
					TcSqlExec(cUpdate)

					For nX := 1 TO Len(oListbox:aArray)
						If oListbox:aArray[nX,5] = cNumOf
							oListbox:aArray[nX,5] := ""
						EndIf
					Next

					cMensagem := ""
					cMensagem += CHR_FONT_CAB_OPEN
					cMensagem += "Processo de Cross Docking" + CHR_ENTER
					cMensagem += CHR_FONT_CAB_CLOSE
					cMensagem += CHR_FONT_DET_OPEN
					cMensagem += "A carga de c๓digo " + AllTrim(cNumOf) + " foi estornada - marca " +  Iif(_nMarca=1,"TAIFF","PROART") + CHR_ENTER
					cMensagem += "Para tanto desconsidere-a no processo de Cross Docking" + CHR_ENTER
					cMensagem += "O usuแrio: (" + cUserName + ") foi o responsแvel pela gera็ใo do processo."
					cMensagem += CHR_FONT_DET_CLOSE

					//U_EnvMail("workflow@taiff.com.br", cMailDest, "Pedidos do CD para faturamento", OemToAnsi(cMensagem))

					cMensagem := "PROCESSO CONCLUIDO!" + ENTER
					cMensagem += "CODIGO DA CARGA: " + cNumOf + " ESTORNADA " + ENTER
					cMensagem += "e-mail ENVIADO AO FATURAMENTO " + ENTER

				EndIf

				MsgInfo(cMensagem)
				dbSelectArea("SC9")

				//U_FATAT063()
			EndIF
		EndIf
	EndIf

Return

/*
------------------------------------------------------------------------------
Cria parametro com e-mail de usuario para workflow de carga de pedido 
------------------------------------------------------------------------------
*/
Static Function TF063sx6()
	Local aArea	:=	GetArea()
	Local cIdUser	:= ""
	Local nPosFim	:= 0
	Local nMaxFim	:= 0
	Local nPassagem:=0

	dbSelectArea( "SX6" )
	dbSetOrder(1)
	If !dbSeek( xFilial("SX6") + "TF_FATA063" )
		RecLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "TF_FATA063"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "e-mail do responsavel pelo faturamento dos pedidos agrupados"
		SX6->X6_DESC1	  := "no projeto do Cross Docking no fonte FATAT063"
		SX6->X6_CONTEUD := "000137;000912;001015;000095;001234;001399;001459;001458" // ;000348 (CT)
		SX6->X6_CONTSPA := "000137;000912;001015;000095;001234;001399;001459;001458"
		SX6->X6_CONTENG := "000137;000912;001015;000095;001234;001399;001459;001458"
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "S"
		MsUnlock()
	EndIf

	cIdUser	:= Alltrim(GetNewPar("TF_FATA063",""))
	nMaxFim	:= Len(cIdUser)
	cMailDest := ""

	nPassagem:=0
	While Len(cIdUser) > 0
		nPosFim := At(";",cIdUser)
		If nPosFim = 0
			nPosFim := Len(cIdUser)
		Else
			nPosFim -= 1
		EndIf

		cMailDest += 	UsrRetMail( Substr(cIdUser,1,nPosFim) ) + ";"


		If nPosFim = 0
			cIdUser := ""
		Else
			cIdUser := Substr(cIdUser,nPosFim+2,nMaxFim)
		EndIf

		nPassagem++
		IF nPassagem>1000
			cIdUser := ""
		ENDIF
	End

	RestArea(aArea)
Return (cMailDest)

/*
--------------------------------------------------------------------------------------------------------------
Impressใo da OS selecionada da ZC5
--------------------------------------------------------------------------------------------------------------
*/
Static Function ImprCarga(oListBox,nLin)
	Private oReport

	If 1=2
		cMensagem := ""
		cMensagem += CHR_FONT_CAB_OPEN
		cMensagem += "Processo de Cross Docking" + CHR_ENTER
		cMensagem += CHR_FONT_CAB_CLOSE
		cMensagem += CHR_FONT_DET_OPEN
		cMensagem += "Este e-mail automatico refere-se ao processo de Cross Docking: Emissใo de nota fiscal de transferencia." + CHR_ENTER
		cMensagem += "O Sr.(a): " + Alltrim(cUserName) + " foi o responsavel pela sele็ใo de pedidos." + CHR_ENTER
		cMensagem += "Os produtos para faturamento sใo da marca " +  Iif(_nMarca=1,"TAIFF","PROART") + CHR_ENTER
		cMensagem += "C๓digo da Carga: " + AllTrim(oListbox:aArray[nLin,5]) + CHR_ENTER
		cMensagem += "Pedidos selecionados: "
	/*
		For _nX := 1 To Len(aPedS)
		cMensagem += Upper( aPedS[_nX][1] ) 
			If _nX != Len(aPedS)
			cMensagem += ", "
			EndIf
		Next
	*/
		cMensagem += CHR_FONT_DET_CLOSE
		//cMailDest := "carlos.torres@taiffproart.com.br"
		//U_EnvMail("workflow@taiff.com.br", cMailDest, "Pedidos do CD para faturamento", OemToAnsi(cMensagem))
		//U_tEnvMail("carlos.torres@taiffproart.com.br", "carlos.torres@taiffproart.com.br", "Pedidos do CD para faturamento", OemToAnsi(cMensagem))

		cMensagem := "PROCESSO CONCLUIDO!" + ENTER
		cMensagem += "CODIGO DA CARGA: " + oListbox:aArray[nLin,5] + ENTER
		cMensagem += "e-mail automแtico enviado: " + cMailDest + ENTER

		MsgInfo(cMensagem)

		aResult := {}
		If TCSPExist("SP_ENVIA_EMAIL_CARGA_TAIFF")
			aResult := TCSPEXEC( "SP_ENVIA_EMAIL_CARGA_TAIFF", oListbox:aArray[nLin,5], Alltrim(Str(_nMarca)), xFilial("SC9"), cMailDest, 'Pedidos do CD para faturamento' )
		EndIf
		IF Empty(aResult)
			Final('Erro na execucao da Stored Procedure SP_ENVIA_EMAIL_CARGA_TAIFF: '+TcSqlError())
		EndIf

	EndIf

	cNumOf := oListbox:aArray[nLin,5]

	SX1->(DbSetOrder(1))
	If SX1->(DbSeek( cLaPerg + "01" ))
		SX1->(reclock("SX1",.F.))
		SX1->X1_CNT01 := cNumOf
		SX1->(MsUnlock())
	EndIf
	oReport := DReportDef( cNumOf )
	oReport:PrintDialog()

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a marca
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)

	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	Aadd( aHelpPor, "Informe a marca: TAIFF ou PROART" )
	Aadd( aHelpEng, "Informe a marca: TAIFF ou PROART" )
	Aadd( aHelpSpa, "Informe a marca: TAIFF ou PROART" )

	PutSx1(cPerg,"01"   ,"Marca ?","",""	,"mv_ch1","N",01,0,0,"C","","","","",;
		"mv_par01", "TAIFF","","","",;
		"PROART","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	RestArea(aAreaAnt)

Return()

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal
--------------------------------------------------------------------------------------------------------------
*/
Static Function TCriaSx1Perg(cPerg)

	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	Aadd( aHelpPor, "Informe o numero da carga" )
	Aadd( aHelpEng, "Informe o numero da carga" )
	Aadd( aHelpSpa, "Informe o numero da carga" )

	PutSx1(cPerg,"01"   ,"Numero da Carga a emitir ?","",""	,"mv_ch1","C",12,0,0,"C","","","","",;
		"mv_par01", "","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	RestArea(aAreaAnt)

Return()

/*
--------------------------------------------------------------------------------------------------------------
Fun็ใo Static de prepara็ใo dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef( __cNumOC )
	Local oReport
	Local cAliasQry := "TSQL"
	Local oOSTransf_1
	Local oOSTransf_2

	oReport := TReport():New("TFIMPCARGA","Lista dos Pedidos da Carga","TFIMPCARGA", {|oReport| DReportPrint(oReport,cAliasQry)},"")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
//oReport:nFontBody := 9

	oReport:cFontBody := 'Arial Narrow'
	oReport:nFontBody := 10
	oReport:SetColSpace(1,.T.)
	oReport:SetLineHeight(50)

	Pergunte(oReport:uParam,.F.)

	oOSTransf_1 := TRSection():New(oReport,"Lista dos pedidos da carga",{"SC9"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)

	TRCell():New(oOSTransf_1,"C9_NUMOF"		,"SC9"	,"No. da carga"	,PesqPict("SC9","C9_NUMOF")	,12							,/*lPixel*/,{|| (cAliasQry)->C9_NUMOF	})
	TRCell():New(oOSTransf_1,"FILNOM"		,"SD2"	,"Destino"			,PesqPict("SD2","D2_DESCR")	,TamSx3("D2_DESCR")[1]	,/*lPixel*/,{|| (cAliasQry)->FILNOM		})
	TRCell():New(oOSTransf_1,"C9_XITEM"		,"SC9"	,"Marca"			,PesqPict("SC9","C9_XITEM")	,TamSx3("C9_XITEM")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_XITEM	})

	oOSTransf_2 := TRSection():New(oReport,"Itens da Carga",{"SC9"},/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)

	TRCell():New(oOSTransf_2,"C9_PEDIDO"	,"SC9"	,"Pedido"			,PesqPict("Sc9","C9_PEDIDO")	,TamSx3("C9_PEDIDO")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_PEDIDO	})
	TRCell():New(oOSTransf_2,"C9_ITEM"		,"SC9"	,"Item"				,PesqPict("Sc9","C9_ITEM")	,TamSx3("C9_ITEM")[1]		,/*lPixel*/,{|| (cAliasQry)->C9_ITEM	})
	TRCell():New(oOSTransf_2,"C9_ORDSEP"	,"SC9"	,"Ordem Sep."		,PesqPict("SC9","C9_ORDSEP")	,TamSx3("C9_ORDSEP")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_ORDSEP	})
	TRCell():New(oOSTransf_2,"C9_PRODUTO"	,"SC9"	,"Produto"			,PesqPict("SC9","C9_PRODUTO"),TamSx3("C9_PRODUTO")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_PRODUTO	})
	TRCell():New(oOSTransf_2,"C9_QTDLIB"	,"SC9"	,"Quantidade"		,PesqPict("SC9","C9_QTDLIB")	,TamSx3("C9_QTDLIB")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_QTDLIB	},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"C9_DATALIB"	,"SC9"	,"Dt. Liberacao"	,PesqPict("SC9","C9_DATALIB"),TamSx3("C9_DATALIB")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_DATALIB	})
	TRCell():New(oOSTransf_2,"C5_NUMOLD"	,"SC5"	,"Pedido Portal"	,PesqPict("SC5","C5_NUMOLD")	,TamSx3("C5_NUMOLD")[1]	,/*lPixel*/,{|| (cAliasQry)->C5_NUMOLD	})
	TRCell():New(oOSTransf_2,"C9_NFISCAL"	,"SC5"	,"Nota Fiscal"		,PesqPict("SC9","C9_NFISCAL"),TamSx3("C9_NFISCAL")[1]	,/*lPixel*/,{|| (cAliasQry)->C9_NFISCAL	})

//TRFunction():New(oOSTransf_2:Cell("VOLUME_TOTAL")	,NIL,"ONPRINT"	,/*oBreak*/,"",PesqPict("ZC5","ZC5_QTDLIB"),{|| oOSTransf_2:Cell("VOLUME_TOTAL"):GetValue(.T.) },.T.,.F.)

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Fun็ใo Static de execu็ใo do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)
	Local __QuebraOC

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)

	MakeSqlExpr(oReport:uParam)

	aResult := {}
	If TCSPExist("SP_REL_NUMERO_DE_CARGA_TAIFF")	
		aResult := TCSPEXEC("SP_REL_NUMERO_DE_CARGA_TAIFF", cNumOf, Alltrim(Str(_nMarca)), xFilial("SC9"), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	Endif
	IF !Empty(aResult)
		If Select(cAliasQry) > 0
			dbSelectArea(cAliasQry)
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS cAliasQry
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_NUMERO_DE_CARGA_TAIFF: '+TcSqlError())
	EndIf

	oReport:Section(1):BeginQuery()
	dbSelectArea(cAliasQry)
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicio da impressao do fluxo do relat๓rio                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		__QuebraOC := (cAliasQry)->C9_NUMOF
		_nTotalVolumes := 0
		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(2):Init()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->C9_NUMOF = __QuebraOC

			oReport:Section(2):PrintLine()
			//_nTotalVolumes += (cAliasQry)->VOLUME_PEDIDO

			dbSkip()
			oReport:IncMeter()
		End
		//oReport:Section(2):Cell("VOLUME_TOTAL"):SetValue(_nTotalVolumes)
		oReport:Section(2):Finish()
		oReport:Section(1):Finish()
		oReport:SkipLine(1)
		oReport:ThinLine()

		oReport:ThinLine()
		oReport:Section(1):SetPageBreak(.T.)
	End

	//Fecha Alias Temporario
	If Select(cAliasQry)
		(cAliasQry)->(dbCloseArea())
	EndIf
	//Exclui a tabela temporaria do Banco de Dados
	If TcCanOpen(aResult[1])
		TcSqlExec("DROP TABLE "+aResult[1])
	EndIf

Return

Static Function ValBonificacao()
	Local lRetorno := .T.

Return (lRetorno)

/*
------------------------------------------------------------------------------
Apresenta a quantidade de itens selecionados 
------------------------------------------------------------------------------
*/
Static Function ConsSelecao(oListBox,nLin)
	Local nX := 0

	nOpc	:= 1

	nVolume := 0

	For nX := 1 TO Len(oListbox:aArray)
		If oListbox:aArray[nX,2] = .T.
			nVolume += oListbox:aArray[nX,12]
		EndIf
	Next

	DEFINE MSDIALOG oLocal FROM 63,181 TO 220,390 TITLE "Itens Selecionados" PIXEL
	@ 003,005 TO 060,105 PIXEL OF oLocal
	@ 013,007 SAY "Qtd. de Itens Selecionados:" SIZE  60, 7 PIXEL OF oLocal
	@ 012,055 SAY nVolume SIZE  29, 9 Picture "99999" PIXEL OF oLocal

	@ 033,007 SAY "Qtd. Maxima de Itens:" SIZE  60, 7 PIXEL OF oLocal
	@ 033,065 SAY _nMaxItens SIZE  59, 9 Picture "99999" PIXEL OF oLocal

	DEFINE SBUTTON FROM 065,010 TYPE 1 ACTION (nOpc := 1,oLocal:End())  ENABLE OF oLocal
	DEFINE SBUTTON FROM 065,040 TYPE 2 ACTION (nOpc := 0,oLocal:End())  ENABLE OF oLocal
	ACTIVATE MSDIALOG oLocal CENTER

Return
