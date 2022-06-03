#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'
#DEFINE ENTER Chr(13)+Chr(10)


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

User Function TFAT063a()
	Local AAREASM0		:= SM0->(GETAREA())

	Public _cMarca		:= GetMark()
	Private cQueryCad 	:= ""
	Private cPergF     	:= "MT460A"
	Private cPerg			:= "FTAT63a"
	Private cPedS			:= CriaVar("C6_NUM")
	Private aPedS			:= {}
	Private _lVerAglut	:= .F.
	Private aFields		:= {}
	Private _cIndex		:= ''
	Private oGeraNf
	Private cItemList 	:= "00"
	Private nItem 	  	:= 0
	Private lNota 		:= .F.
	Private cForma
	Private nTipoNf		:= 0
	Private _cClienteCros:= ""
	Private _cLojaCros 	:= ""
	Private _cNfeSerie	:= GetNewPar("TF_SERIE","TAIFF=1|PROART=2")
	Private _cMarca		:= ""
	Private lErroNaAliquota := .F.
	Private _nTFaliq := 0

	cSerie	:= ''

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

	ValidPerg(cPerg)


	@ 200,001 TO 480,380 DIALOG oGeraNf TITLE OemToAnsi("Geracao de Nf Automatica")
	@ 003,005 TO 085,187 PIXEL OF oGeraNf
	@ 010,018 Say "Este programa ira gerar N.f. conforme pedidos agrupados." SIZE 150,010 PIXEL OF oGeraNf
	@ 065,008 BUTTON "Continua  "  ACTION (Processa({||Fatura("F")}),oGeraNf:End())PIXEL OF oGeraNf
	@ 100,008 BMPBUTTON TYPE 02 ACTION oGeraNf:End()

	Activate Dialog oGeraNf Centered
Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConfirmaProc บAutor  ณMicrosiga        บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfirmaProc()
	Local oObj
	If MsgYesNo('Confirma o Processamento ?','Gerar Notas','YESNO')
		oObj := MsNewProcess():New({|lEnd| MaRwProc(oObj, @lEnd)}, "", "", .T.)
		oObj :Activate()
	Endif
Return


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

Static Function MaRwProc(oObj,lEnd)
	Local _nProc2		:= 0
	Local _nX := 0

	Private aNotas := {}
	Private aPvlNfs   := {}
	Private aSitPvlNfs:= {}

	lAdiciona	:= .T.
	_cNota		:= ''
	_cNotaPri	:= ''
	_nTFaliq		:= 0

	cPedido	:= cPedS
	cPedS		:= CriaVar("C6_NUM")
	cCli		:= CriaVar("C5_CLIENTE")
	If Len(aPedS) = 0
		AaDd(aPedS,{cPedido,cCli})
	Endif

//PERGUNTA DA EMISSAO DA NF
	If! Pergunte(cPergF,.T.)
		Return
	EndIf

	_lVerAglut := .T. //Iif(mv_par11 == 1,.T.,.F.)

	oObj:SetRegua1( Len(aPedS) )


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

	U_TF063asx6(_cMarca,_cMarca)

	SA1->(DbSetOrder(1))
	DA1->(DbSetOrder(1))

	For _nX := 1 To Len(aPedS)


		oObj:IncRegua1("Processando pedido "+Alltrim(Str(_nX))+ " de " + Alltrim(Str(Len(aPedS))) + " encontrados.")

		//ProcessMessages()
		cPedido := Upper( aPedS[_nX][1] )


		dbSelectArea("SC6")
		dbSetORder(1)
		If !dbSeek(xFilial("SC6")+cPedido)
			MsgStop('Pedido '+cPedido+' com problema, verifique !!!')
			//U_FATAT063a()
			Return(.T.)
		Endif

		_cQuery := "SELECT" 												+ ENTER
		_cQuery += "	C6_ITEM AS ITEM "									+ ENTER
		_cQuery += "FROM" 													+ ENTER
		_cQuery += "	" + RetSQLName("SC6")+ " SC6" 		+ ENTER
		_cQuery += "WHERE" 													+ ENTER
		_cQuery += "	C6_NUM = '" + cPedido + "' " 	+ ENTER
		_cQuery += "	AND C6_FILIAL = '" + xFilial("SC6") + "' " 	+ ENTER
		_cQuery += "	AND D_E_L_E_T_='' "

		IF SELECT("AUXSC6") > 0
			DBSELECTAREA("AUXSC6")
			DBCLOSEAREA()
		ENDIF

		TCQUERY _cQuery NEW ALIAS "AUXSC6"
		DBSELECTAREA("AUXSC6")
		DBGOTOP()

		COUNT TO _nRec2

		AUXSC6->(DBCLOSEAREA())

		dbSelectArea("SC6")

		oObj:SetRegua2(_nRec2)
		_nProc2		:= 1

		dbSelectArea("SC6")
		While !Eof() .AND. C6_FILIAL+C6_NUM == xFilial("SC6")+cPedido

			oObj:IncRegua2("Processando item "+Alltrim(Str(_nProc2))+ " de " + Alltrim(Str(_nRec2)) + " itens.")

			If SC6->C6_XITEMC = "TAIFF"
				cUpdate := " UPDATE SC5 SET "
				cUpdate += " 		C5_VOLUME1 = (SELECT dbo.RET_VOLUME_PEDIDO('03', '"+xFilial("SC9")+"', C5_NUM)) "
				cUpdate += " FROM " + RetSQLName("SC5")+" SC5 "
				cUpdate += " WHERE "
				cUpdate += " C5_FILIAL = '"+xFilial("SC5")+"' "
				cUpdate += " AND C5_NUM = '" + SC6->C6_NUM + "' "
				cUpdate += " AND SC5.D_E_L_E_T_ = '' "
				cUpdate += " AND C5_XITEMC = '" + SC6->C6_XITEMC + "' "
				//MemoWrite("FATAT063A_MaRwProc_update_de_volume.SQL",cUpdate)
				TcSqlExec(cUpdate)
			ElseIf SC6->C6_XITEMC = "PROART"
				cUpdate := " UPDATE SC5_SP SET"
				cUpdate += " 	C5_VOLUME1=SC5_MG.C5_VOLUME1"
				cUpdate += " 	,C5_PESOL=SC5_MG.C5_PESOL"
				cUpdate += " 	,C5_PBRUTO=SC5_MG.C5_PBRUTO"
				cUpdate += " FROM " + RetSQLName("SC5") + " SC5_SP"
				cUpdate += " INNER JOIN " + RetSQLName("SC5") + " SC5_MG"
				cUpdate += " 	ON SC5_MG.C5_FILIAL='02'"
				cUpdate += " 	AND SC5_MG.D_E_L_E_T_=''"
				cUpdate += " 	AND SC5_MG.C5_NUM ='" + SC6->C6_NUM + "' "
				cUpdate += " 	AND SC5_MG.C5_NUMORI=SC5_SP.C5_NUM"
				cUpdate += " 	AND SC5_MG.C5_XITEMC='PROART'"
				cUpdate += " WHERE SC5_SP.D_E_L_E_T_='' "
				cUpdate += " AND SC5_SP.C5_FILIAL='01'"
				cUpdate += " AND SC5_SP.C5_XITEMC='PROART'"
				//MemoWrite("FATAT063A_MaRwProc_update_de_volume.SQL",cUpdate)
				TcSqlExec(cUpdate)
			EndIF

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
					nPrcVen := SC9->C9_PRCVEN
				/*
				Busca tabela de pre็o de transferencia
				*/
					If SA1->(DbSeek( xFilial("SA1") + SC9->C9_CLIENTE + SC9->C9_LOJA ))
						If DA1->(DbSeek( xFilial("DA1") + SA1->A1_TABELA + SC9->C9_PRODUTO ))
							nPrcVen := DA1->DA1_PRCVEN

							cUpdate := " UPDATE SC9 SET "
							cUpdate += " 	C9_PRCVEN = " + ALLTRIM(STR(DA1->DA1_PRCVEN))
							cUpdate += " FROM " + RetSQLName("SC9")+" SC9 "
							cUpdate += " WHERE "
							cUpdate += " R_E_C_N_O_ = " + Alltrim(Str( SC9->(Recno()) ))

							TcSqlExec(cUpdate)

							cUpdate := " UPDATE SC6 SET "
							cUpdate += " 	C6_PRUNIT = " + ALLTRIM(STR(DA1->DA1_PRCVEN))
							cUpdate += " FROM " + RetSQLName("SC6")+" SC6 "
							cUpdate += " WHERE "
							cUpdate += " R_E_C_N_O_ = " + Alltrim(Str( SC6->(Recno()) ))

							TcSqlExec(cUpdate)
						Else

							MsgStop("Aten็ใo, produto " + SC9->C9_PRODUTO + " sem pre็o na tabela " + SA1->A1_TABELA + " de transferencia!" + ENTER + "Solicite interven็ใo da controladoria." + ENTER + "Processo serแ interrompido." )

							Return

						EndIf
					EndIf

					If ( SC5->C5_MOEDA != 1 )
						nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
					EndIf

					_cCli := SC9->C9_CLIENTE
					_nTFaliq := AliqIcms(SC5->C5_TIPO,'S',SC5->C5_TIPOCLI)
					If (_nTFaliq = 18) .AND. .NOT. lErroNaAliquota // Fun็ใo padrใo da TOTVS (fisxfun)
						lErroNaAliquota := .T.
						Memowrite("FATAT063A_pedido_aliquota_icm_errada.TXT","Pedido: " + SC5->C5_NUM + ENTER + " Produto: " + SC9->C9_PRODUTO + ENTER + "Aliquota calculada: " + Alltrim(Str(_nTFaliq)))
					EndIf

					aadd(aPvlNfs,{ C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_QTDLIB,nPrcVen,C9_PRODUTO,If(lQuery,SF4->F4_ISS=="S",SF4->F4_ISS=="S"),	SC9->(RecNo()),	SC5->(RecNo()),	SC6->(RecNo()),SE4->(RecNo()),SB1->(RecNo()),SB2->(RecNo()),SF4->(RecNo()),C9_LOCAL,0})
				EndIf
				DbSelectarea("SC9")
				DbSkip()
			EndDo
			_nProc2 ++

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

	U_TF063asx6(_cMarca,"")

	c1Nota := Iif(Empty(aNotas[1]),'',aNotas[1])
	cMensagem := "FATURAMENTO CONCLUIDO!"+ENTER
	cMensagem += "Primeira Nota: "+c1Nota+ENTER
	cMensagem += "Ultima Nota  : "+ Iif(Empty(aNotas[Len(aNotas)]),'',aNotas[Len(aNotas)])
	MsgInfo(cMensagem)

	lNota := .F.
//U_FATAT063a()
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
	Local nLoop	:= 0
	_cNotaG := ''
//EMITE NOTAS
	If _cMarca = "PROART"
		cSerie := Substr( _cNfeSerie , At( "PROART=" , _cNfeSerie ) + 7 ,1)
	Else
		cSerie := Substr( _cNfeSerie , At( "TAIFF=" , _cNfeSerie ) + 6 ,1)
	EndIf

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

		If Type("oGeraNf") <> "U"
			Close(oGeraNf)
		Endif

	EndIf

//EMITE NOTAS COM REGIME DE SUBSTITUICAO TRIBUTARIA ESPECIAL
	If Len( aSitPvlNfs ) > 0 .And. cOpcao == "2"
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
		_cNotaG := MaPvlNfs(aSitPvlNfs,cSerie,mv_par01 == 1	,mv_par02==1	,mv_par03==1	,mv_par04==1	,mv_par05==1	,mv_par07	,mv_par08		,mv_par15 == 1	,mv_par16==2)

		If Type("oGeraNf") <> "U"
			Close(oGeraNf)
		Endif

	EndIf
	If Len(aSitPvlNfs) == 0 .And. Len(aPvlNfs)==0
		MsgBox ("Nao existe dados para ser gerado Nota Fiscal. Verifique liberacoes","Aten็ao","ALERT")
		Close(oGeraNf)
	EndIf

/* Limpa campo de controle de libera็ใo em Lote */
	If SC5->(FIELDPOS("C5__DTLIBF")) > 0
		dbSelectArea("SC5")
		dbSetOrder(1)
		For nLoop := 1 to Len(aPvlNfs)
			If SC5->(DbSeek( xFilial("SC5") + ALLTRIM(aPvlNfs[nLoop][1]) ))
				If SC5->(RecLock("SC5",.F.))
					SC5->C5__DTLIBF 	:= CTOD("  /  /  ")
					SC5->C5__LIBM		:= ""
					SC5->(MsUnlock())
				EndIf
			EndIf
		Next nLoop
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
	Local oBmp2
	Local z := 0

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
MV_PAR01 - C๓digo da carga
*/

	INCLUI		:= .F.

	aCampos	:= {}
	_cPesqPed	:= Space(6)
	_nTotal	:= 0
	_cMarca	:= ""
	Cursorwait()
//seleciona os pedidos
	cQuery := " SELECT C5_NUM, C5_CLIENTE, C5_TRANSP " + ENTER
	cQuery += " ,CASE C5_XITEMC WHEN 'PROART' THEN C5_VOLUME1 ELSE " + ENTER
	cQuery += " (SELECT dbo.RET_VOLUME_PEDIDO('03', '"+xFilial("SC9")+"', C5_NUM)) END AS C5_VOLUME1 " + ENTER
	cQuery += " ,(SELECT COUNT(C6_ITEM) FROM "+RetSqlName("SC6")+"  C6 WITH(NOLOCK) WHERE C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL AND C5_CLIENTE = C6_CLI AND C6.D_E_L_E_T_ <> '*') AS C6_ITEM" + ENTER
	cQuery += " ,SUM(C9_QTDLIB*C9_PRCVEN) AS C6_VALOR" + ENTER
	cQuery += " ,COUNT( DISTINCT(C9_ITEM)) AS C9_ITEM" + ENTER
	cQuery += " ,C5_NOMCLI AS A1_NOME " + ENTER
	cQuery += " ,A4_NOME " + ENTER
	cQuery += " ,C5_LOJACLI " + ENTER
	cQuery += " ,C5_XITEMC " + ENTER
	cQuery += " FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)" + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 WITH(NOLOCK) ON A1_COD = C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1_FILIAL=C5_FILIAL AND SA1.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA4")+" A4 WITH(NOLOCK) ON A4_COD = C5_TRANSP AND A4.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SC9")+" SC9 WITH(NOLOCK) ON C9_BLEST = '' AND C9_BLCRED = ''  AND C9_NFISCAL='' AND C9_PEDIDO = C5_NUM  AND C9_FILIAL = C5_FILIAL AND C5_CLIENTE = C9_CLIENTE AND SC9.D_E_L_E_T_ <> '*' AND C9_NUMOF = '" + mv_par01 + "' " + ENTER
	cQuery += " WHERE C5_CLIENTE = '"+_cClienteCros+"' AND C5_LOJACLI='"+_cLojaCros+"' " + ENTER
	cQuery += " AND C5.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
	cQuery += " AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += " AND C5_NOTA = ''" + ENTER
	cQuery += " AND C5_NUMOC = 'CROSS' " + ENTER
	cQuery += " GROUP BY C5_FILIAL, C5_NUM, C5_CLIENTE, C5_TRANSP, A1_NOME, C5_LOJACLI, C5_XITEMC, C5_YSTSEP, C5_VOLUME1, C5_NOMCLI, A4_NOME" + ENTER
	cQuery += " ORDER BY C5_NUM" + ENTER

	//MemoWrite("FATAT063A_lista_pedidos_cross.SQL",cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		CursorArrow()
		TRB->(dbCloseArea())
		Return
	EndIf


	dbSelectArea("TRB")
	ProcRegua(nRec1)
	dbGotop()
	_cMarca	:= TRB->C5_XITEMC

	aDados	 := {}
	While !Eof()


		IncProc("Montando os itens a serem selecionados")
		// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - BLOQUEIOS, 05 - COD CLI, 06 - RAZAO, 07 - COD TRANS, 08 - NOME TRANS, 09 - VALOR, 10 - VOLUME, 11 - ITEM PED, 12 - ITEM LIB, 13-NOTA, 14-PEDIDO PAI,15-SEQUENCIA PEDIDOS PARA FATURAR,16-LOJA DO CLIENTE DO PEDIDO

		//If (mv_par10== 1 .And. TRB->C6_ITEM == TRB->C9_ITEM) .Or. mv_par10 == 2
		lNota := .F.
		aAdd(aDados,{fColor(), lNota, TRB->C5_NUM, mv_par01 ,TRB->C5_CLIENTE, AllTrim(TRB->A1_NOME), TRB->C5_TRANSP, AllTrim(TRB->A4_NOME),TRB->C6_VALOR,TRB->C5_VOLUME1, TRB->C6_ITEM,TRB->C9_ITEM, '', '',''})

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


	aTitCampos := {" "," ",OemToAnsi("Pedido"),OemToAnsi("Cod.Carga"),OemToAnsi("Cod.Cli"),OemToAnsi("Cliente"),OemToAnsi("Cod.Transp."),OemToAnsi("Transportadora"),;
		OemToAnsi("Valor"), OemToAnsi("Volume"), OemToAnsi("Itens Pedido"),OemToAnsi("Itens Liberados"),OemToAnsi(""),OemToAnsi(""),OemToAnsi("Sequencia")}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],aDados[oListBox:nAT][10],aDados[oListBox:nAT][11],aDados[oListBox:nAT][12],aDados[oListBox:nAT][13],aDados[oListBox:nAT][14],aDados[oListBox:nAT][15],}"

	bLine := &( "{ || " + cLine + " }" )

	@ 100,005 TO 550,950 DIALOG oDlgPedidos TITLE "Pedidos"

	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}


	oListBox := TWBrowse():New( 17,4,460,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := Iif(aDados[oListBox:nAt,2]==.T.,.F.,.T.)} //MarcaTodos(oListBox, .F., .T.,1,oListBox:nAt)) }
	oListBox:bLine := bLine

	@ 183,010 BUTTON "Faturar"  	SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()}  PIXEL OF oDlgPedidos
	@ 183,060 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	@ 210,065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 210,075 SAY "Apto a Faturar" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL

	ACTIVATE DIALOG oDlgPedidos CENTERED

	TRB->(dbCloseArea())

	If nOpc == 1
		nSomaTot := 0
		ASort(aDados,,,{|x,y|x[15]<y[15]})
		For z:= 1 To Len(aDados)
			aAdd(aPeds,{aDados[z][3],aDados[z][5]})
			nSomaTot += aDados[z][9]
		Next


		If Len(aPeds) > 0
			MsgInfo("Total Pedidos selecionados: "+Str(nSomaTot,12,2))
			//MaRwProc()
			oObj := MsNewProcess():New({|lEnd| MaRwProc(oObj, @lEnd)}, "", "", .T.)
			oObj :Activate()
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
//LIBERADO - "BR_VERDE"

Static Function fColor()

Return(LoadBitMap(GetResources(),"BR_VERDE"   ))

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
			//MsgStop("A Ordem de Separa็ใo deste item pedido estแ em andamento!","Aten็ใo - FATAT063")
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
		MsgStop("O produto Ficarแ com estoque negativo, opera็ใo cancelada!"+ENTER+cMensSld,"Aten็ใo - FATAT063")
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
	Local cKey 		:= ""
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}

	PutSx1(cPerg,"01"   ,"C๓digo da Carga?",""                    ,""                    ,"mv_ch1","C"   ,12      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P.FTAT63a01."
	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}
	aAdd(aHelpPor,"Informe o c๓digo da carga ")
	aAdd(aHelpPor,"encaminhado por e-mail (workflow)")
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return

/*
------------------------------------------------------------------------------
Cria parametro com e-mail de usuario para workflow de carga de pedido 
------------------------------------------------------------------------------
*/
User Function TF063asx6( cMarca , cTipoMov )
	Local aArea	:=	GetArea()

	dbSelectArea( "SX6" )
	dbSetOrder(1)
	If cMarca='TAIFF'
		If !dbSeek( xFilial("SX6") + "TF_TAICROS" )
			RecLock("SX6", .T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "TF_TAICROS"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Sigla que indica qual ้ a marca que estแ em andamento na    "
			SX6->X6_DESC1	  := "gera็ใo da Nfe do Cross Docking no fonte FATAT063           "
			SX6->X6_CONTEUD := ""
			SX6->X6_CONTSPA := ""
			SX6->X6_CONTENG := ""
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "S"
			MsUnlock()
		EndIf
		RecLock("SX6", .F.)
		SX6->X6_CONTEUD := cTipoMov
		SX6->X6_CONTSPA := cTipoMov
		SX6->X6_CONTENG := cTipoMov
		MsUnlock()
	ElseIf cMarca='PROART'
		If !dbSeek( xFilial("SX6") + "TF_PROCROS" )
			RecLock("SX6", .T.)
			SX6->X6_FIL     := xFilial("SX6")
			SX6->X6_VAR     := "TF_PROCROS"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "Sigla que indica qual ้ a marca que estแ em andamento na    "
			SX6->X6_DESC1	  := "gera็ใo da Nfe do Cross Docking no fonte FATAT063           "
			SX6->X6_CONTEUD := ""
			SX6->X6_CONTSPA := ""
			SX6->X6_CONTENG := ""
			SX6->X6_PROPRI  := "U"
			SX6->X6_PYME    := "S"
			MsUnlock()
		EndIf
		RecLock("SX6", .F.)
		SX6->X6_CONTEUD := cTipoMov
		SX6->X6_CONTSPA := cTipoMov
		SX6->X6_CONTENG := cTipoMov
		MsUnlock()
	EndIf
	RestArea(aArea)
Return NIL
