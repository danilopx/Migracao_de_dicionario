#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TaPAgenC บ Autor ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Agendamento de Coleta de Transportadoras         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TaPAgenC()

	Local oBar			:= Nil
	Local aBtn 	    	:= Array(10)

	Private aCorChk		:= {}
	Private _cFileSF2   := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de cVariable dos componentesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _cMarca		:= GetMark()
	Private nOpc		:= GD_INSERT+GD_DELETE+GD_UPDATE
	Private aSemanas 	:= {}
	Private aObjects    := {},aPosObj  :={}
	Private aSize       := MsAdvSize()
	Private cInfo       := ""
	Private aHeader     := {}
	Private aCols       := {}
	Private _cPerg      := PADR("TaPAgenC",10)
	Private _cFileDZA
	Private _lInverte   := .F.
	Private oBrwDZA
	Private lSavPlan    := .F.

	Private _aCampos    := {}
	Private _aTitulos   := {}

//Variaveis do banco de Estoque do Planejamento
	Private _aColsAux    := {}
	Private _aColsEst    := {}
	Private _aHeadAux    := {}
	Private _aEstoque    := {}
	Private _aEstSB6     := {}
	Private _aEstHosp    := {}

	Private _nTotPed     := 0

	Private _dEmissIni  := dDatabase //FirstDay(dDatabase-30)
	Private _dEmissFim  := dDatabase //LastDay(dDatabase)
	Private _dAgendIni  := STOD("")
	Private _dAgendFim  := STOD("20491231")
	Private _dEmbarqIni := STOD("")
	Private _dEmbarqFim := STOD("20491231")
	Private _dRecebIni  := STOD("")
	Private _dRecebFim  := STOD("20491231")
	Private _dDtAgenda  := dDatabase
	Private _cTranspIni := Space(6)
	Private _cTranspFim := "ZZZZZZ"
	Private _cClientIni := Space(6)
	Private _cClientFim := "ZZZZZZ"
	Private _cLojaIni   := Space(2)
	Private _cLojaFim   := "ZZ"
	Private _cNumNFIni  := Space(9)
	Private _cNumNFFim  := "ZZZZZZZZZ"
	Private _oDtAgenda  := STOD("")
	Private _cObsM 		:= ""
	Private _lAltAgenda := .F.

	aCorChk	:=	{;
		{" !Empty(TSF2->F2_DTRECEB) ","BR_VERMELHO"},;
		{" !Empty(TSF2->F2_DTAGEND) ","BR_AZUL"},;
		{" Empty(TSF2->F2_DTRECEB) .AND. Empty(TSF2->F2_DTEMB) ","BR_VERDE"},;
		{" Empty(TSF2->F2_DTRECEB) .AND. !Empty(TSF2->F2_DTEMB) ","BR_AMARELO"};
		}

//Montando tela do Fluxo de Equipamentos
	aObjects	:= {}
	aAdd( aObjects, {100,090, .t., .F.})
	aAdd( aObjects, {100,100, .t., .T.})
	aInfo		:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj		:= MsObjSize( ainfo, aObjects )

	oDlgAge	:= MSDialog():New( 000,000,aSize[6],aSize[5],"Agendamento de Coletas",,,.F.,,,,,,.T.,,,.T. )
	oDlgAge:lMaximized := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta os Botoes da Barra Superior.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE BUTTONBAR oBar SIZE 25,25 3D OF oDlgAge

	DEFINE BUTTON aBtn[01] RESOURCE "pedido"		When .T. OF oBar TOOLTIP "Enviar Workflow de Agendamento"	ACTION EnviaWF()
	aBtn[01]:cTitle := "Enviar WF"

	DEFINE BUTTON aBtn[02] RESOURCE "impressao"	When .T. OF oBar TOOLTIP "Imprimir Relatorio"	ACTION u_TaPAgenR()
	aBtn[02]:cTitle := "Imprimir"

//DEFINE BUTTON aBtn[03] RESOURCE "bmpdel"		When .T. OF oBar TOOLTIP "Cancelar Pedido"	ACTION u_CVALM08E(2)
//aBtn[03]:cTitle := "Cancelar"

//DEFINE BUTTON aBtn[04] RESOURCE "btcalend"		When .T. OF oBar TOOLTIP "Complementos"		ACTION u_CVALM08A()
//aBtn[04]:cTitle := "Complem."

	DEFINE BUTTON aBtn[10] RESOURCE "FINAL_MDI" 	When .T. OF oBar TOOLTIP "Sair"		   		ACTION oDlgAge:End()
	aBtn[10]:cTitle := "Sair"

	oGrp1       := TGroup():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],/*aPosObj[1,4]*/170,"Sele็ใo de Dados",oDlgAge,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrp3       := TGroup():New( aPosObj[1,1],/*aPosObj[1,2]*/ 175,aPosObj[1,3],aPosObj[1,4],"Dados do Agendamento",oDlgAge,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oGrp2       := TGroup():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3]+10,aPosObj[2,4],"Documento de Saํda",oDlgAge,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oFld1       := TFolder():New( aPosObj[2,1]+10,aPosObj[2,2]+5,{"Documentos de Saํda"},{},oGrp2,,,,.T.,.F.,aPosObj[2,4]-15,(aPosObj[2,3]-aPosObj[2,1])-20,)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o aHeader com base no SX3 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SC6"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SC6"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_CONTEXT <> "V"
			Aadd(aHeader,{AllTrim(X3Titulo()),;
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
				SX3->X3_RELACAO,;
				SX3->X3_WHEN,;
				SX3->X3_VISUAL,;
				SX3->X3_VLDUSER	,;
				SX3->X3_PICTVAR,;
				SX3->X3_OBRIGAT})
		EndIf

		SX3->(dbSkip())
	EndDo

//Selecionando documentos
	MsgRun("Selecionando Documentos de Saida, Aguarde..."  ,,{|| GetAgendas() })

//Preenchimento dos dados de pesquisa
	_nCol := 8
	_nLin := 8
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Emissao" 		OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	_nCol := 8
	_nLin += 12
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Agendamento" 	OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	_nCol := 8
	_nLin += 12
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Transportad." OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	_nCol := 8
	_nLin += 12
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Cliente" 		OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	_nCol := 8
	_nLin += 12
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Loja" 		  OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			  OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	_nCol := 8
	_nLin += 12
	@ aPosObj[1,1]+_nLin ,_nCol		 SAY "Nota Fiscal"	  OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin ,_nCol+=93 SAY "Ate" 			  OF oGrp1 Color CLR_BLACK,CLR_WHITE PIXEL

	_nCol := 45
	_nLin := 8
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oEmissIni  VAR _dEmissIni  SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oEmissFim  VAR _dEmissFim  SIZE 050,07 OF oGrp1 PIXEL
	_nCol := 45
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oAgendIni  VAR _dAgendIni  SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oAgendFim  VAR _dAgendFim  SIZE 050,07 OF oGrp1 PIXEL
	_nCol := 45
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oTranspIni  VAR _cTranspIni F3 "SA4" SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oTranspFim  VAR _cTranspFim F3 "SA4" SIZE 050,07 OF oGrp1 PIXEL
	_nCol := 45
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oClientIni  VAR _cClientIni F3 "SA1" SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oClientFim  VAR _cClientFim F3 "SA1" SIZE 050,07 OF oGrp1 PIXEL
	_nCol := 45
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oLojaIni  VAR _cLojaIni SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oLojaFim  VAR _cLojaFim SIZE 050,07 OF oGrp1 PIXEL
	_nCol := 45
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol		MSGET _oNumNFIni  VAR _cNumNFIni F3 "SF2" SIZE 050,07 OF oGrp1 PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=70	MSGET _oNumNFFim  VAR _cNumNFFim F3 "SF2" SIZE 050,07 OF oGrp1 PIXEL

	_nCol := 45
	_nLin += 12
	oBtn := TButton():New( aPosObj[1,1]+_nLin,_nCol,"Pesquisar...",oGrp1,{|| MsgRun("Selecionando Documentos de Saida, Aguarde..."  ,,{|| GetAgendas() }) },050,010,,,,.T.,,"Pesquisar",,,,.F. )

//Preenchimento dos dados do agendamento
	_nCol := 180
	_nLin := 8
	@ aPosObj[1,1]+_nLin,_nCol SAY "Data Agendamento" OF oGrp3 PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=50 MSGET _oDtAgenda VAR _dDtAgenda PIXEL SIZE 60,07 OF oGrp3 PIXEL
	_nCol := 180
	_nLin += 12
	@ aPosObj[1,1]+_nLin,_nCol SAY "Observacao" OF oGrp3 PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[1,1]+_nLin,_nCol+=50 GET _oObsM	VAR _cObsM MEMO PIXEL SIZE 200,50 OF oGrp3

	_nCol := 180+50
	_nLin += 52
	DEFINE SBUTTON FROM aPosObj[1,1]+_nLin,_nCol TYPE 1 ACTION (GravaAgenda()) ENABLE OF oGrp3 PIXEL When _lAltAgenda
	DEFINE SBUTTON FROM aPosObj[1,1]+_nLin,_nCol+=35 TYPE 3 ACTION (CancAgenda()) ENABLE OF oGrp3 PIXEL When _lAltAgenda

	oBrwSF2 := MsSelect():New( "TSF2",/*"C5_OK"*/,,_aTitulos,@_lInverte,@_cMarca,{aPosObj[2,1]+10,aPosObj[2,2]+5,aPosObj[2,3]-10,aPosObj[2,4]-5},,,oGrp2,,aCorChk)
	oBrwSF2:oBrowse:bChange := {|| GetDadosAgenda() }
//oBrwSF2:oBrowse:lHasMark	:= .T.
//oBrwSF2:oBrowse:lCanAllMark	:= .T.

	nCol := 10
	@ aPosObj[2,3]-5 ,nCol BITMAP Leg1 RESNAME "BR_VERMELHO" OF oGrp2 Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2,3]-5 ,nCol+=10 SAY "Entregue" OF oGrp2 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[2,3]-5 ,nCol+=35 BITMAP Leg1 RESNAME "BR_VERDE" OF oGrp2 Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2,3]-5 ,nCol+=10 SAY "Pendente Agenda" OF oGrp2 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[2,3]-5 ,nCol+=45 BITMAP Leg1 RESNAME "BR_AZUL" OF oGrp2 Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2,3]-5 ,nCol+=10 SAY "Agendado" OF oGrp2 Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[2,3]-5 ,nCol+=35 BITMAP Leg1 RESNAME "BR_AMARELO" OF oGrp2 Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2,3]-5 ,nCol+=10 SAY "Em Transito" OF oGrp2 Color CLR_BLACK,CLR_WHITE PIXEL

	oDlgAge:Activate(,,,)

	DBSelectArea("TSF2")
	DBCloseArea()
	DeletaTSF2()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetAgendasบAutor  ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que busca as notas a serem agendadas                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetAgendas()

	Local _aCposSF2 := {"F2_SERIE","F2_DOC","F2_CLIENTE","F2_LOJA","F2_VALBRUT","A1_NOME","F2_EST","F2_EMISSAO","F2_DTAGEND","F2_DTEMB","F2_DTRECEB","F2_TRANSP","A4_NOME"}
	Local _nI := 0
	Local nI  := 0

//aadd(_aTitulos,{"DZA_OK",    , "", "@!"})
//aadd(_aCampos ,{"DZA_OK", "C", 02, 0   })

	_aTitulos := {}
	_aCampos  := {}

	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For _nI := 1 to len(_aCposSF2)
		SX3->(dbSeek(_aCposSF2[_nI]))
		aadd(_aTitulos,{Alltrim(SX3->X3_CAMPO),,SX3->X3_TITULO,SX3->X3_PICTURE})
		aadd(_aCampos ,{Alltrim(SX3->X3_CAMPO),SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	Next

	_cQuery := "SELECT "+CRLF
	For nI := 1 to len(_aCampos)
		if alltrim(_aCampos[nI][1]) $ "SF2_RECNO#"
			Loop
		endif
		if alltrim(_aCampos[nI][1]) == "A1_NOME"
			_cQuery += "CASE WHEN F2_TIPO IN ('D','B') THEN A2_NOME ELSE A1_NOME END AS A1_NOME,"+CRLF
		else
			_cQuery += _aCampos[nI][1]+","+CRLF
		endif
	Next
	_cQuery += " SF2.R_E_C_N_O_ AS SF2_RECNO "+CRLF
	_cQuery += " FROM "+RetSQLName("SF2")+" SF2 "+CRLF
	_cQuery += " LEFT JOIN "+RetSQLName("SA1")+" SA1 ON A1_FILIAL='"+XFILIAL("SA1")+"' AND A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND SA1.D_E_L_E_T_='' "+CRLF
	_cQuery += " LEFT JOIN "+RetSQLName("SA2")+" SA2 ON A2_FILIAL='"+XFILIAL("SA2")+"' AND A2_COD=F2_CLIENTE AND A2_LOJA=F2_LOJA AND SA2.D_E_L_E_T_='' "+CRLF
	_cQuery += " LEFT JOIN "+RetSQLName("SA4")+" SA4 ON A4_FILIAL='"+XFILIAL("SA4")+"' AND A4_COD=F2_TRANSP AND SA4.D_E_L_E_T_='' "+CRLF
	_cQuery += " WHERE SF2.D_E_L_E_T_='' "+CRLF
	_cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"' "+CRLF
	_cQuery += " AND F2_DOC BETWEEN '"+_cNumNFIni+"' AND '"+_cNumNFFim+"' "+CRLF
	_cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(_dEmissIni)+"' AND '"+DTOS(_dEmissFim)+"' "+CRLF
	_cQuery += " AND F2_DTAGEND BETWEEN '"+DTOS(_dAgendIni)+"' AND '"+DTOS(_dAgendFim)+"' "+CRLF
	_cQuery += " AND F2_TRANSP BETWEEN '"+_cTranspIni+"' AND '"+_cTranspFim+"' "+CRLF
	_cQuery += " AND F2_CLIENTE BETWEEN '"+_cClientIni+"' AND '"+_cClientFim+"' "+CRLF
	_cQuery += " AND F2_LOJA BETWEEN '"+_cLojaIni+"' AND '"+_cLojaFim+"' "+CRLF
	_cQuery += " ORDER BY F2_SERIE, F2_DOC "+CRLF
//Aviso("Query",_cQuery,{"OK"},3)

	if Select("TSQL")>0
		DBSelectArea("TSQL")
		DBCloseArea()
	endif

	TcQuery _cQuery New Alias "TSQL"
	TcSetField("TSQL", "F2_EMISSAO", "D")
	TcSetField("TSQL", "F2_DTAGEND", "D")
	TcSetField("TSQL", "F2_DTEMB", "D")
	TcSetField("TSQL", "F2_DTRECEB", "D")

	If Select("TSF2") > 0
		DBSelectArea("TSF2")
		DBCloseArea()
		DeletaTSF2()
	Endif

	DBSelectArea("TSQL")
	CriaTSF2()

	DbSelectArea("TSF2")
	TSF2->(DbGoTop())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaTSF2 บAutor  ณ Anderson Messias   บ Data ณ  29/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que seleciona os pedidos do vale                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CriaTSF2()

	If Select("TSF2") > 0
	Return .T.
	EndIf

_cFileSF2 := CriaTrab(nil,.F.)
Copy To &(_cFileSF2)

dbUseArea(.T.,,_cFileSF2,"TSF2",.F.,.F.)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDeletaTSF2บAutor  ณ Anderson Messias   บ Data ณ  29/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que deleta tabela temporaria                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function DeletaTSF2()

fErase(_cFileSF2+OrdBagExt())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetDadosAgบAutor  ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que busca os dados do agendamento                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetDadosAgenda()

DBSelectArea("SF2")
DBSetOrder(1)
DBGoTo(TSF2->SF2_RECNO)
_dDtAgenda := SF2->F2_DTAGEND
_cObsM     := SF2->F2_OBSAGEN

_lAltAgenda := AlteraAgenda()

DBSelectArea("TSF2")
_oDtAgenda:Refresh()
_oObsM:Refresh(.T.)
oDlgAge:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaAgendบAutor  ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que grava os dados da agenda na nota                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GravaAgenda()

DBSelectArea("SF2")
DBSetOrder(1)
DBGoTo(TSF2->SF2_RECNO)
RecLock("SF2",.F.)
SF2->F2_DTAGEND := _dDtAgenda
SF2->F2_OBSAGEN := _cObsM
MsUnlock()

DBSelectArea("TSF2")
RecLock("TSF2",.F.)
TSF2->F2_DTAGEND := _dDtAgenda
MsUnlock()

_oDtAgenda:Refresh()
_oObsM:Refresh(.T.)
oDlgAge:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancAgendaบAutor  ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que cancela os dados da agenda na nota              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function CancAgenda()

	if MsgYESNO("Confirma cancelamento da agenda deste documento de saida?")
	
	_dDtAgenda := STOD("")
	_cObsM := ""
	
	DBSelectArea("SF2")
	DBSetOrder(1)
	DBGoTo(TSF2->SF2_RECNO)
	RecLock("SF2",.F.)
	SF2->F2_DTAGEND := _dDtAgenda
	SF2->F2_OBSAGEN := _cObsM
	MsUnlock()
	
	DBSelectArea("TSF2")
	RecLock("TSF2",.F.)
	TSF2->F2_DTAGEND := _dDtAgenda
	MsUnlock()
	
	DBSelectArea("TSF2")
	_oDtAgenda:Refresh()
	_oObsM:Refresh(.T.)
	oDlgAge:Refresh()
	endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAlteraAgenบAutor  ณ Anderson Messias   บ Data ณ  16/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que verifica se permite altera็ใo da agenda         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function AlteraAgenda()

Local lRet := .T.

//if !Empty(TSF2->F2_DTEMB)
//	lRet := .F.
//endif

	if !Empty(TSF2->F2_DTRECEB)
	lRet := .F.
	endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TaPAgenW บAutor  ณ Anderson Messias   บ Data ณ  15/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de Workflow de aviso de agendamento                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TaPAgenW(_cEmailEDI)

	local _aTransp:= {}
	local _aCliente:={}

	DEFAULT _cEmailEDI := ""

	if !MsgYESNO("Confirma o envio do email de aviso de agendamento?")
		Return
	endif

	_aTransp := GetAdvFVal("SA4",{"A4_NOME","A4_EMAIL","A4_XMAILED"},xFilial("SA4")+SF2->F2_TRANSP,1)
	if SF2->F2_TIPO $ "D/B"
		_aCliente := GetAdvFVal("SA2",{"A2_NOME","A2_EST","A2_MUN"},xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,1)
	else
		_aCliente := GetAdvFVal("SA1",{"A1_NOME","A1_EST","A1_MUN"},xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,1)
	endif
	_cEmailTrans := iif(Len(alltrim(_aTransp[3]))>0,_aTransp[3],_aTransp[2])
	if Len(alltrim(_cEmailTrans)) > 0
		if Len(alltrim(_cEmailEDI)) > 0
			_cEmailTrans += ";"+_cEmailEDI
		endif
	endif
	if Len(alltrim(_cEmailTrans)) > 0

		_cTitulo := "Workflow - Aviso de Agendamento de Entrega"
		oProcess := TWFProcess():New( "WFEDITRA", _cTitulo )
		oProcess:NewTask( "WFCOLETRANS", "\WORKFLOW\WFEDIPROC2.HTM" )
		oHTML := oProcess:oHTML
		oHtml:ValByName("TITULO",_cTitulo)
		loProcess := .T.

		_cLinha := ''
		_cLinha += '<table width="100%">'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Transportadora</b> : '+SF2->F2_TRANSP+" - "+_aTransp[1]+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Email</b> : '+_cEmailTrans+'</td>'
		_cLinha += '	</tr>'
		if Len(Alltrim(_cEmailEDI)) > 0
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Email Adicional</b> : '+_cEmailEDI+'</td>'
			_cLinha += '	</tr>'
		endif
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Enviado</b> : '+DTOC(Date())+' - '+Time()+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '</table>'
		_cLinha += '<table width="100%">'
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_titulo">Empresa</td>'
		_cLinha += '		<td class="grid_titulo">Serie</td>'
		_cLinha += '		<td class="grid_titulo">Documento</td>'
		_cLinha += '		<td class="grid_titulo">Cliente</td>'
		_cLinha += '		<td class="grid_titulo">Nome</td>'
		_cLinha += '		<td class="grid_titulo">Estado</td>'
		_cLinha += '		<td class="grid_titulo">Municipio</td>'
		_cLinha += '		<td class="grid_titulo">Dt. Agendamento</td>'
		_cLinha += '	</tr>'
		lImpr := .F.
		lFirst:= .F.

		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par">'+SM0->M0_NOME+'</td>'
		_cLinha += '		<td class="grid_par">'+SF2->F2_SERIE+'</td>'
		_cLinha += '		<td class="grid_par">'+SF2->F2_DOC+'</td>'
		_cLinha += '		<td class="grid_par">'+SF2->F2_CLIENTE+"/"+SF2->F2_LOJA+'</td>'
		_cLinha += '		<td class="grid_par">'+_aCliente[1]+'</td>'
		_cLinha += '		<td class="grid_par">'+_aCliente[2]+'</td>'
		_cLinha += '		<td class="grid_par">'+_aCliente[3]+'</td>'
		_cLinha += '		<td class="grid_par">'+DTOC(SF2->F2_DTAGEND)+'</td>'
		_cLinha += '	</tr>'

		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par"><b>Observa็๕es do Agendamento</b></td>'
		_cLinha += '		<td class="grid_par" Colspan="7"><b>'+StrTran(SF2->F2_OBSAGEN,CHR(13),"<br>")+'</b></td>'
		_cLinha += '	</tr>'

		_cLinha += '</table>'
		_cLinha += '&nbsp;'
		aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		oProcess:ClientName( Subs(cUsuario,7,15) )
		eMail := SuperGetMv("MV_XMAILED",,"amessias@deltadecisao.com.br")
		oProcess:cSubject 	:= _cTitulo
		oProcess:cTo 		:= eMail
		oProcess:cBCC 		:= _cEmailTrans
		if Len(alltrim(_cEmailEDI)) > 0
			oProcess:cBcc 		:= _cEmailEDI
		endif
		oProcess:UserSiga	:= __CUSERID
		oProcess:Start()
		oProcess:Free()
		Aviso("Envio de Workflow","Aviso de agendamento enviado com sucesso!",{"OK"},3)

	else
		Aviso("Envio de Workflow","Transportadora sem email cadastrado, nใo ้ possํvel enviar o email!",{"OK"},3)
	endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TaPAgenR บAutor  ณ Anderson Messias   บ Data ณ  15/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de Workflow de aviso de agendamento                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TaPAgenR()

	Local oReport
	Local cRotina  := "TaPAgenR"
	Local aSavATU  := GetArea()
	Local aSavTSF2 := TSF2->(GetArea())

//private cPerg := PADR("TaPAgenR",10)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//|verifica se relatorios personalizaveis esta disponivel|
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport := ReportDef(cRotina)
//oReport:SetTotalInLine(.F.)
//oReport:SetTotalText ("Totais de Debito e Credito do Periodo")
	oReport:PrintDialog()

	RestArea(aSavTSF2)
	RestArea(aSavATU)

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณDescri…o ณ Impressao do relat๓rio personalizavel		              |ฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณUso       ณ TAIFF     			                                      ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ReportDef(cRotina)

	Local oReport
//Local oSection

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime relatorio  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oReport := TReport():New(cRotina,"Relatorio de Agendamentos",/*cPerg*/,{|oReport| PrintReport(oReport,cRotina)},"Este relatorio ira imprimir os agendamentos de coleta")
	oReport:SetLandScape(.T.)

	oSection1 := TRSection():New(oReport,OemToAnsi("Agendamentos"),)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine as colunas a serem mostradas na SECAO 2 - Dados do pedido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	TRCell():New(oSection1,"F2_SERIE","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_DOC","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_CLIENTE","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_LOJA","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"A1_NOME","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_EMISSAO","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_DTAGEND","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_DTEMB","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_DTRECEB","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_TRANSP","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"A4_NOME","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_VALBRUT","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)
	TRCell():New(oSection1,"F2_EST","TSF2",,/*"@E 9999.99"*/,,,/*{|| _aEstSaldo[_nI][1] }*/)

//oBreak := TRBreak():New(oSection1,oSection1:Cell("CT2_DOC"),"Total do Lancamento")
//TRFunction():New(oSection1:Cell("DEBITO"),NIL,"SUM",/*oBreak*/,,,,.F.,.T.)
//TRFunction():New(oSection1:Cell("CREDIT"),NIL,"SUM",/*oBreak*/,,,,.F.,.T.)

Return oReport

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณDescri…o ณ Impressao do relat๓rio personalizavel		              |ฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณUso       ณ GLASSEC	 			                                      ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function PrintReport(oReport,cRotina)

	Local oSection1 := oReport:Section(1)
	oSection1:SetTotalInLine(.T.)
//oReport:OnPageBreak(,.T.)

	DbSelectArea("TSF2")
	DbGoTop()
	nTotal := 0
	dbEval( {|| nTotal++ } )

	_aEstSaldo := {}
	DbSelectArea("TSF2")
	DBGoTop()
	oSection1:Init()
	While !TSF2->(Eof())

		If oReport:Cancel()
			Exit
		EndIf

		oSection1:PrintLine()

		TSF2->(DBSkip())
		oReport:IncMeter()
	EndDo
	oSection1:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EnviaWF  บAutor  ณ Anderson Messias   บ Data ณ  19/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que monta tela para envio do Workflow de Aviso      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnviaWF()

	Local _cEmailEDI := Space(100)

	DEFINE MSDIALOG oDlgWF FROM 0,0 TO 100,360 TITLE "Ajuste do conhecimento" PIXEL

	@ 10,003 SAY "Email Adicional" OF oDlgWF PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ 10,045 MSGET oEmailEDI VAR _cEmailEDI PIXEL SIZE 130,10 OF oDlgWF PIXEL

	DEFINE SBUTTON FROM 30,080 TYPE 1 ACTION (nOk := 1,oDlgWF:End()) ENABLE OF oDlgWF
	DEFINE SBUTTON FROM 30,110 TYPE 2 ACTION (nOk := 0,oDlgWF:End()) ENABLE OF oDlgWF

	ACTIVATE MSDIALOG oDlgWF CENTERED

	if nOk == 1
		u_TaPAgenW(_cEmailEDI)
	endif

Return
