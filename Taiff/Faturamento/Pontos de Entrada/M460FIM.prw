#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³M460FIM   º Autor ³Richard N. Cabral   º Data ³  27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para geração das NCCs de Bonificacoes     º±±
±±º          ³ Financeiras por Verba Promocional                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM

	Local cEmail	:= "grp_sistemas@taiff.com.br;rose.araujo@taiff.com.br;douglas.fornazier@taiff.com.br"
	Local cCabMens 	:= ""
	Local cItemMens	:= ""
	Local aAlias	:= GetArea()
	Local aAliasSE1 := SE1->(GetArea()) //"SE1")
	Local aAliasSD2 := SD2->(GetArea()) //"SD2")
	Local aAliasSC6 := SC6->(GetArea())
	Local aBonif 	:= {}
	Local cMsgAliquota:=""
	Local lValidada := .T.
	Local lVerFECPrj:= .T.
	Local cTpVerbaTT:= GetMV("MV__FINVTT",.F.,"02") // Tipo de verba: 02 - Verba Tática ou 03 - Verba Bonificação
	LOCAL cUpdate	:= ""

	//----------------------------------------------------------------------------------------------------------------------------
	// Variaveis: TOTVS
	//----------------------------------------------------------------------------------------------------------------------------
	Local cDoc			:= ''
	Local aAliasSE2 	:= SE2->(GetArea())
	Local lUnidNeg		:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)

	//----------------------------------------------------------------------------------------------------------------------------
	// Ponto de Validação: TOTVS
	// Descrição: Validar unidade de negocio no produto
	// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
	//----------------------------------------------------------------------------------------------------------------------------
	/*
	|---------------------------------------------------------------------------------
	|	Verificacao do posicionamento do SF2 no momento.
	|---------------------------------------------------------------------------------
	*/

	If SC5->(FIELDPOS("C5_XITEMC")) != 0 .And. lUnidNeg
		If SF2->F2_TIPO == 'D'
			cDoc := SD2->(D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC)
			SE2->(DbSetOrder(6))

			If SE2->(DbSeek(cDoc))

				Do While cDoc == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
					RecLock("SE2",.F.)
					SE2->E2_ITEMC := SC5->C5_XITEMC  	//-- Gravacao unidade de negocios para todas a parcelas geradas no
					SE2->(MsUnlock())						//-- financeiro

					SE2->(DbSkip())
				EndDo

			EndIf

			SE2->(RestArea(aAliasSE2))

		EndIf

		cDoc := SD2->(D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC)
		SE1->(DbSetOrder(2))

		If SE1->(DbSeek(cDoc))

			Do While cDoc == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
				RecLock("SE1",.F.)
				SE1->E1_ITEMC := SC5->C5_XITEMC  	//-- Gravacao unidade de negocios para todas a parcelas geradas no
				SE1->(MsUnlock())						//-- financeiro

				SE1->(DbSkip())
			EndDo

		EndIf

		SE1->(RestArea(aAliasSE1))
	EndIf
	//------------------------------[ Fim Ponto de Validação: TOTVS ]-------------------------------------------------------------

	/* Limpa campo de controle de liberação em Lote */
	If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->(FIELDPOS("C5__DTLIBF")) > 0
		If SC5->(RecLock("SC5",.F.))
			SC5->C5__DTLIBF 	:= CTOD("  /  /  ")
			SC5->C5__LIBM		:= ""
			SC5->C5_HIST5		:= ""
			SC5->(MsUnlock())
		EndIf
	EndIf

	//--- Veti - início - grava historico de separação - Arlete - 03/maio/2013

	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") .AND. ALLTRIM(SF2->F2_TIPO) = 'N'
		SC5->(DbSetOrder(1))
		SD2->(DbSetOrder(3))
		SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		Do While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .And. ! SD2->(Eof())
			If SC5->(DbSeek( xFilial("SC5") + SD2->D2_PEDIDO))
				IF alltrim(SC5->C5_YSTSEP) <> "G"
					SC5->(RecLock("SC5",.F.))
					SC5->C5_YFMES := "S"
					SC5->(MsUnlock())
				EndIf

				//Grava log
				_cAlias		:= "SC5"
				_cChave		:= xFilial("SC5")+SC5->C5_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= UPPER("20 - Faturamento sem separação.")
				_cFuncao	:= "U_M460FIM"
				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
				//
			EndIf
			SD2->(DbSkip())
		EndDo
	Endif

	//--- Veti - fim - grava historico de separação - Arlete - 03/maio/2013

	//valida se ficou com custo zero ou com variacao de 30% do custo do fechamento
	If (cEmpAnt+cFilAnt) # "0401"
		dDataAnt := GetMV("MV_ULMES")
		cCabMens := ""
		cItemMens:=""
		dbSelectArea("SD2")
		DbSetOrder(3)
		DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA = SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .And. !Eof()
			cEstoque := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ESTOQUE")
			If cEstoque == "S" .And. SD2->D2_TIPO $ "N|D|"
				nCustoSD2	:= SD2->D2_CUSTO1/SD2->D2_QUANT
				nCusSB9 	:= Posicione("SB9",1,xFilial("SB9")+SD2->D2_COD+SD2->D2_LOCAL+Dtos(dDataAnt),"B9_CM1")
				If (nCustoSD2 == 0 .Or. nCustoSD2>(nCusSB9*1.3) .Or. nCustoSD2<(nCusSB9*0.7)) .And. nCusSB9> 0
					cItemMens += "Item            "+SD2->D2_ITEM+ENTER
					cItemMens += "Produto         "+SD2->D2_COD+" Descricao"+Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")+ENTER
					cItemMens += "Quantidade      "+Transform(SD2->D2_QUANT,"@E 999999999")+ENTER
					cItemMens += "Local           "+SD2->D2_LOCAL+ENTER
					cItemMens += "Valor Unit      "+Transform(SD2->D2_PRCVEN,"@E 999,999,999.99")+ENTER
					cItemMens += "Custo SD2       "+Transform(nCustoSD2,"@E 999,999,999.99")+ENTER
					cItemMens += "Custo SB2       "+Transform(Posicione("SB2",1,xFilial("SB2")+SD2->D2_COD+SD2->D2_LOCAL,"B2_CM1"),"@E 999,999,999.99")+ENTER
					cItemMens += "Custo SB9       "+Transform(nCusSB9,"@E 999,999,999.99")+ENTER
					cItemMens += "Poder Terceiros "+Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_PODER3")+ENTER
					cItemMens += "Movim.Estoque   "+Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ESTOQUE")+ENTER
					If !Empty(SD2->D2_NFORI)
						cItemMens += "Nota Entrada    "+SD2->D2_NFORI+" Serie "+SD2->D2_SERIORI+ENTER
					EndIf
					cItemMens += "********************************************************************************************************"+ENTER
				EndIf
			EndIf
			dbSelectArea("SD2")
			DbSkip()
		End
		//MONTA O CABECALHO DA MENSAGEM
		If !Empty(cItemMens)
			cCabMens +="Esta nota fiscal de saida possui itens com custo zero ou com divergencia de 30% do custo de fechamento"+ENTER
			cCabMens += "Empresa     "+cEmpAnt+ENTER
			cCabMens += "Filial      "+cFilAnt+ENTER
			cCabMens += "Nota Fiscal "+SF2->F2_DOC+" Serie "+SF2->F2_SERIE+ENTER
			cCabMens += "Emissao	 "+Dtoc(SF2->F2_EMISSAO)+ENTER
			cCabMens += "Cliente	 "+SF2->F2_CLIENTE+" "+Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME")+ENTER
			cCabMens += "Usuario     "+Substr(cUsuario,7,15)+ENTER

			//MsgAlert(cCabMens+ENTER+cItemMens,"M460FIM")
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cCabMens+ENTER+cItemMens	,'Nota fiscal de saida com problema de custo - Nota Fiscal '+SF2->F2_DOC+' Serie '+SF2->F2_SERIE	,'')
		EndIf
	EndIf
	//
	// Gera a Verba de Bonificação de Cliente
	//
	If SF2->F2_SERIE != "TRF" .AND. SC5->C5_CLASPED != "A"
		ZA6->(DbSetOrder(1))
		ZA6->(DbSeek(xFilial("ZA6")+SF2->(F2_CLIENTE+F2_LOJA)))

		Do While ZA6->ZA6_FILIAL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA = xFilial("ZA6")+SF2->(F2_CLIENTE+F2_LOJA) .And. ! ZA6->(Eof())
			If ZA6->ZA6_ITEMC = SC5->C5_XITEMC .OR. Empty(ZA6->ZA6_ITEMC)
				IF ZA6->ZA6_PERC != 0
					Aadd(aBonif, {ZA6->ZA6_TPBON, ZA6->ZA6_PERC, ZA6->ZA6_ABIMP})
				ENDIF
			EndIf
			ZA6->(DbSkip())
		EndDo

		If ! Empty(aBonif)
			Processa({|| GeraNCC(aBonif)},"Gerando NCCs " + SF2->F2_CLIENTE + "-" + SF2->F2_LOJA + "-" + Alltrim(Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),"A1_NOME")) + "...")
		EndIf
	EndIf

	/* Para atender o chamado interno 3905 referente à contabilização exata da OP na entrada de nota fiscal de beneficiamento */
	If ALLTRIM(SF2->F2_TIPO) = "B" .AND. SD2->(FIELDPOS("D2__OP")) != 0
		dbSelectArea("SB6")
		DbSetOrder(1) // B6_FILIAL, B6_PRODUTO, B6_CLIFOR, B6_LOJA, B6_IDENT, R_E_C_N_O_, D_E_L_E_T_

		dbSelectArea("SC6")
		DbSetOrder(1) // C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

		dbSelectArea("SD2")
		DbSetOrder(3)
		DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA = SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .And. !SD2->(Eof())
			SC6->(DbSeek( SD2->(D2_FILIAL + D2_PEDIDO + D2_ITEMPV + D2_COD)  ))
			If SC6->(Found()) .AND. !Empty(SC6->C6__OPBNFC)
				SD2->(RecLock("SD2", .F.))
				SD2->D2__OP := SC6->C6__OPBNFC
				SD2->(MsUnlock())
			EndIf
			If SB6->(FIELDPOS("B6__OP")) != 0
				SB6->(DbSeek( xFilial("SB6") + SD2->(D2_COD+D2_CLIENTE+D2_LOJA+D2_IDENTB6) ))
				While SD2->(D2_FILIAL+D2_COD+D2_CLIENTE+D2_LOJA+D2_IDENTB6) = SB6->(B6_FILIAL+B6_PRODUTO+B6_CLIFOR+B6_LOJA+B6_IDENT) .AND. !SB6->(Eof())
					If SB6->B6_DOC = SD2->D2_DOC .AND. SB6->B6_SERIE = SD2->D2_SERIE .AND. Empty(SB6->B6__OP)
						SB6->(RecLock("SB6", .F.))
						SB6->B6__OP := SC6->C6__OPBNFC
						SB6->(MsUnlock())
					EndIf
					SB6->(DbSkip())
				End
			EndIf
			SD2->(DbSkip())
		End
	EndIf

	/* Verificação dos calculos de impostos */
	cMsgAliquota:=""
	lValidada := .T.
	lVerFECPrj:= .T. // Valida a FECP do RJ para NFe de EXTREMA

	dbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA = SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .And. !SD2->(Eof())
		If SD2->D2_EST = "SP" .AND. SD2->D2_PICM != 18 .AND. .NOT. SD2->D2_CF $ "5916|5915" .AND. CEMPANT = "01" .AND. lValidada
			cMsgAliquota += "Verifique a Nota fiscal " + SD2->D2_DOC + "/" + SD2->D2_SERIE
			cMsgAliquota += " Alíquota de ICM inválida para UF de " + SD2->D2_EST + " empresa " + CEMPANT
			lValidada := .F.
		EndIf
		If SD2->D2_EST = "RJ" .AND. SD2->D2_ALIQSOL = 18 .AND. Alltrim(SD2->D2_CF) = "6403" .AND. CEMPANT = "03" .AND. CFILANT = "02" .AND. lVerFECPrj
			cMsgAliquota += "Verifique a Nota fiscal " + SD2->D2_DOC + "/" + SD2->D2_SERIE
			cMsgAliquota += " Alíquota solidária inválida para UF de " + SD2->D2_EST + " empresa " + CEMPANT
			lValidada := .F.
		EndIf
		SD2->(DbSkip())
	End
	If !Empty(cMsgAliquota)
		MsgAlert( cMsgAliquota ,PROCNAME() )
	EndIf
	/* fim das validações dos calculos de impostos */

	/* Gera título no financeiro quando verba tática */
	If SC5->(FIELDPOS("C5_DESCTAT")) > 0
		If ALLTRIM(SC5->C5_DESCTAT) == cTpVerbaTT .AND. SC5->C5_PERCTAT > 0
			Processa({|| GeraVTT( SC5->C5_PERCTAT )},"Gerando Verba Tática ...")
		EndIf
	EndIf
	/* Fim do processamento de verba tática */

	/* Atualiza o status de separação no CD de Extrema para produtos PROART quando a nota do cliente é faturada */
	/* Data: 16/06/2020                        Autor: Carlos Torres */
	/* ID: 001-M460FM                                               */
	IF CEMPANT = "03" .AND. ALLTRIM(SC5->C5_XITEMC) = "PROART" .AND. SC5->C5_TIPO="N" .AND. SC5->C5_CLASPED $ "V|X"
		cUpdate := " UPDATE SC5_MG SET" + ENTER
		cUpdate += " 	C5_YSTSEP='' " + ENTER
		cUpdate += " FROM " + RetSQLName("SC5") + " SC5_MG"  + ENTER
		cUpdate += " WHERE SC5_MG.D_E_L_E_T_='' " + ENTER
		cUpdate += " AND SC5_MG.C5_FILIAL='02' " + ENTER
		cUpdate += " AND RTRIM(SC5_MG.C5_XITEMC) ='PROART' " + ENTER
		IF CFILANT = "01"
			cUpdate += " AND SC5_MG.C5_NUMORI ='" + SC5->C5_NUM + "' " + ENTER
		ELSEIF CFILANT = "02"
			cUpdate += " AND SC5_MG.C5_NUM ='" + SC5->C5_NUM + "' " + ENTER
		ENDIF
		//MemoWrite("M460FIM_update_C5_YSTSEP.SQL",cUpdate)
		TcSqlExec(cUpdate)
	ENDIF
	/* Fim do 001-M460FM */

	SD2->(RestArea(aAliasSD2))
	SE1->(RestArea(aAliasSE1))
	SC6->(RestArea(aAliasSC6))
	RestArea(aAlias)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GeraNCC   º Autor ³Richard N. Cabral   º Data ³  27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gravação das NCCs de Bonificacoes Financeiras por Verba    º±±
±±º          ³ Promocional                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraNCC(aBonif)

	Local aFIN040
	Local cChaveSE1
	Local cNatureza := GetMv("MV_NCCBON",,"NCCVC")
	Local cTipo		:= "NCC"
	Local nValor

	Local nValBrut	:= 0
	Local nIcmsRet	:= 0
	Local nValIcm	:= 0
	Local nValIpi	:= 0
	Local nPercLiq	:= 0
	Local nX		:= 0
	Local n 		:= 0

	Private aGets, aTela            //Variaveis auxiliares da Enchoice
	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.

	SD2->(DbSetOrder(3))
	SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
	Do While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .And. ! SD2->(Eof())

		nValBrut	+= SD2->D2_VALBRUT
		nIcmsRet	+= SD2->D2_ICMSRET
		nValIcm		+= SD2->D2_VALICM
		nValIpi		+= SD2->D2_VALIPI

		SD2->(DbSkip())
	EndDo

	nPercLiq := 1 - ( ( nIcmsRet + nValIcm + nValIpi ) / nValBrut )

	//
	// Forçar o posicionamento da SE1 - C. TORRES 02/07/2012
	//
	// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	SE1->(DbSetOrder(2))
	SE1->(DbSeek( xFilial('SE1') + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ))
	//
	//---------------------------------[ termino ]----------------------------------------------------------------------
	//

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Encontra quantas parcelas foram geradas no financeiro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSqlE1 := "SELECT count(*) as REG FROM " + RetSQLName("SE1") + " SE1 "
	cSqlE1 += "WHERE SE1.E1_FILIAL = '"		+ xFilial('SE1')
	cSqlE1 += "' AND SE1.E1_CLIENTE = '"	+ SE1->E1_CLIENTE
	cSqlE1 += "' AND SE1.E1_LOJA = '"		+ SE1->E1_LOJA
	cSqlE1 += "' AND SE1.E1_PREFIXO = '"	+ SE1->E1_PREFIXO
	cSqlE1 += "' AND SE1.E1_NUM = '" 		+ SE1->E1_NUM
	cSqlE1 += "' AND SE1.D_E_L_E_T_ = '' "

	If Select("SQLE1") > 0
		SQLE1->( dbCloseArea() )
	EndIf

	dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,cSqlE1),"SQLE1", .F., .T.)

	SQLE1->(DbGotop())

	ProcRegua(SQLE1->REG * Len(aBonif))

	SQLE1->( dbCloseArea() )

	aFin040 := {}

	cChaveSE1 := SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)

	SE1->(DbSetOrder(2))
	SE1->(DbSeek(cChaveSE1))

	Do While SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) = cChaveSE1 .And. ! SE1->(Eof())

		RegToMemory( "SE1", .F. )

		M->E1_NATUREZ	:= cNatureza
		M->E1_TIPO		:= cTipo
		nValor			:= M->E1_VALOR

		For nX := 1 to Len(aBonif)

			IncProc("Gerando NCCs da parcela " + SE1->E1_PARCELA + " - Bonificação " + Alltrim(Posicione("SX5",1,xFilial("SX5")+"ZC"+aBonif[nX,1],"X5_DESCRI")))

			M->E1_PREFIXO	:= aBonif[nx,1]

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se abate impostos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			M->E1_VALOR		:= nValor * aBonif[nx,2] / 100 * If(aBonif[nX,3] = "1",nPercLiq,1)
			M->E1_HIST		:= "Bonificação " + Posicione("SX5",1,xFilial("SX5")+"ZC"+aBonif[nX,1],"X5_DESCRI")

			AADD(aFIN040,{ {"E1_PREFIXO"	,	M->E1_PREFIXO	,nil},;
				{"E1_NUM"		,	M->E1_NUM		,nil},;
				{"E1_PARCELA"	,	M->E1_PARCELA	,nil},;
				{"E1_TIPO"		,	M->E1_TIPO		,nil},;
				{"E1_NATUREZ"	,	M->E1_NATUREZ	,nil},;
				{"E1_CLIENTE"	,	M->E1_CLIENTE	,nil},;
				{"E1_LOJA"		,	M->E1_LOJA		,nil},;
				{"E1_NOMCLI"	,	M->E1_NOMCLI	,nil},;
				{"E1_EMISSAO"	,	M->E1_EMISSAO	,nil},;
				{"E1_VENCTO"	,	M->E1_VENCTO	,nil},;
				{"E1_VENCREA"	,	M->E1_VENCREA	,nil},;
				{"E1_VALOR"		,	M->E1_VALOR		,nil},;
				{"E1_HIST"		,	M->E1_HIST		,nil},;
				{"E1_PEDIDO"	,	M->E1_PEDIDO	,nil},;
				{"E1_ITEMC"		,	M->E1_ITEMC 	,nil}	 })

		Next nX

		SE1->(DbSkip())

	EndDo

	Begin Transaction

		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.

		For n := 1 to len(aFIN040)
			MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],3)
			If LMsErroAuto
				MostraErro()
				DisarmTransaction()
				Break
			Endif
		Next

	End Transaction

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GerNCCRetrº Autor ³Richard N. Cabral   º Data ³  27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gravação das NCCs de Bonificacoes Financeiras por Verba    º±±
±±º          ³ Promocional - Geração dos titulos ja gerados               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GerNCCRetr

	Processa({|| GerNCCRetr()},"Gerando NCCs Retroativas" )

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GerNCCRetrº Autor ³Richard N. Cabral   º Data ³  27/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gravação das NCCs de Bonificacoes Financeiras por Verba    º±±
±±º          ³ Promocional - Geração dos titulos ja gerados               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GerNCCRetr

	Local aParamBox := {}
	Local aRet		:= {}
	Local cTipoOri	:= "NF"
	Local aFIN040	:= {}
	Local cNatureza := GetMv("MV_NCCBON",,"NCCVC")
	Local cTipo		:= "NCC"
	Local nValor
	Local dFirstDay
	Local aBonif 	:= {}
	Local nValBonif

	Local nValBrut	:= 0
	Local nIcmsRet	:= 0
	Local nValIcm	:= 0
	Local nValIpi	:= 0
	Local nPercLiq	:= 0
	Local n			:= 0
	Local nX		:= 0

	Local dLastDay

	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.

	dFirstDay := CtoD("01/01/"+strzero(year(dDataBase),4))
	dLastDay := CtoD("01/01/"+strzero(year(dDataBase),4))

	Aadd(aParamBox,{1,"Data Inicial" ,dFirstDay ,"99/99/99","","","",050,.T.})
	//--------------------------------------------------------------------------------------------------------//
	//Descrição: Adequação no programa, incluindo a Data Final do intervalo												 //
	//--------------------------------------------------------------------------------------------------------//
	//Autor: Carlos Alday                                                                 Data: 12/11/2010    //
	//--------------------------------------------------------------------------------------------------------//
	Aadd(aParamBox,{1,"Data Final" ,dLastDay ,"99/99/99","","","",050,.T.})

	IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
		Return(.F.)
	Endif

	cSqlE1 := " SELECT * FROM " + RetSQLName("SE1") + " SE1 "
	cSqlE1 += " WHERE SE1.E1_FILIAL = '"		+ xFilial('SE1')
	cSqlE1 += "' AND SE1.E1_EMISSAO >= '"	+ Dtos(aRet[1])
	cSqlE1 += "' AND SE1.E1_EMISSAO <= '"	+ Dtos(aRet[2])
	cSqlE1 += "' AND SE1.E1_TIPO = '"		+ cTipoOri
	cSqlE1 += "' AND SE1.D_E_L_E_T_ = ' ' "
	cSqlE1 += "  ORDER BY E1_NUM"

	If Select("SQLE1") > 0
		SQLE1->( dbCloseArea() )
	EndIf

	dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,cSqlE1),"SQLE1", .F., .T.)
	TCSetField("SQLE1","E1_EMISSAO","D",8,0)
	TCSetField("SQLE1","E1_VENCTO","D",8,0)
	TCSetField("SQLE1","E1_VENCREA","D",8,0)

	SQLE1->(DbGotop())

	Do While ! SQLE1->(Eof())

		aBonif 	:= {}

		ZA6->(DbSeek(xFilial("ZA6")+SQLE1->(E1_CLIENTE+E1_LOJA)))

		Do While ZA6->ZA6_FILIAL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA = xFilial("ZA6")+SQLE1->(E1_CLIENTE+E1_LOJA) .And. ! ZA6->(Eof())
			IF ZA6->ZA6_PERC != 0
				Aadd(aBonif, {ZA6->ZA6_TPBON, ZA6->ZA6_PERC, ZA6->ZA6_ABIMP})
			ENDIF
			ZA6->(DbSkip())
		EndDo

		If Empty(aBonif)
			SQLE1->(DbSkip())
			Loop
		EndIf

		nValBrut	:= 0
		nIcmsRet	:= 0
		nValIcm		:= 0
		nValIpi		:= 0
		nPercLiq	:= 0

		SF2->(DbSetOrder(1))
		SF2->(DbSeek(xFilial("SF2")+SQLE1->(E1_NUM+E1_PREFIXO+E1_CLIENTE+E1_LOJA)))

		SD2->(DbSetOrder(3))
		SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
		Do While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .And. ! SD2->(Eof())

			nValBrut	+= SD2->D2_VALBRUT
			nIcmsRet	+= SD2->D2_ICMSRET
			nValIcm		+= SD2->D2_VALICM
			nValIpi		+= SD2->D2_VALIPI

			SD2->(DbSkip())
		EndDo

		nPercLiq := 1 - ( ( nIcmsRet + nValIcm + nValIpi ) / nValBrut )

		nValor			:= SQLE1->E1_VALOR

		For nX := 1 to Len(aBonif)

			cHist := "Bonificação " + Posicione("SX5",1,xFilial("SX5")+"ZC"+aBonif[nX,1],"X5_DESCRI")

			nValBonif := nValor * aBonif[nx,2] / 100 * If(aBonif[nX,3] = "1",nPercLiq,1)

			//--------------------------------------------------------------------------------------------------------//
			//Descrição: Adequação no programa, para verificar se a NCC já existe na tabela SE1, caso já exista não   //
			//           prossegue com a inclusão										                                        //
			//--------------------------------------------------------------------------------------------------------//
			//Autor: Carlos Alday                                                                 Data: 04/11/2010    //
			//--------------------------------------------------------------------------------------------------------//

			SE1->(DbSetOrder(1))
			SE1->(DbSeek( xFilial("SE1")+  Alltrim(aBonif[nx,1])+space(3-Len(Alltrim(aBonif[nx,1])))  + SQLE1->E1_NUM+SQLE1->E1_PARCELA+cTipo ))
			If !SE1->(FOUND())

				AADD(aFIN040,{ {"E1_PREFIXO"	,	aBonif[nx,1]		,nil},;
					{"E1_NUM"		,	SQLE1->E1_NUM		,nil},;
					{"E1_PARCELA"	,	SQLE1->E1_PARCELA	,nil},;
					{"E1_TIPO"		,	cTipo				,nil},;
					{"E1_NATUREZ"	,	cNatureza			,nil},;
					{"E1_CLIENTE"	,	SQLE1->E1_CLIENTE	,nil},;
					{"E1_LOJA"		,	SQLE1->E1_LOJA		,nil},;
					{"E1_NOMCLI"	,	SQLE1->E1_NOMCLI	,nil},;
					{"E1_EMISSAO"	,	SQLE1->E1_EMISSAO	,nil},;
					{"E1_VENCTO"	,	SQLE1->E1_VENCTO	,nil},;
					{"E1_VENCREA"	,	SQLE1->E1_VENCREA	,nil},;
					{"E1_VALOR"		,	nValBonif			,nil},;
					{"E1_ITEMC"		,	SQLE1->E1_ITEMC 	,nil},;
					{"E1_HIST"		,	cHist				,nil},;
					{"E1_PEDIDO"	,	SQLE1->E1_PEDIDO	,nil} })
			EndIf

		Next nX

		SQLE1->(DbSkip())

	EndDo

	SQLE1->( dbCloseArea() )

	ProcRegua(Len(aFIN040))

	Begin Transaction

		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.

		For n := 1 to len(aFIN040)

			IncProc("Gerando NCCs Retroativas")

			MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],3)
			If LMsErroAuto
				MostraErro()
				DisarmTransaction()
				Break
			Endif
		Next

	End Transaction

Return(.T.)


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ AjustVol º Autor ³ Marcelo Cardoso    º Data ³  08/03/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Ponto de Entrada final da geracao da Nota Fiscal de Saida  º±±
	±±º          ³ Redundancia de verificacao do Volume da Nota Fiscal        º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Especifico Taiff                                           º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºObservacao³ Definido pela area fiscal quando TES 676 e ACTION VARGINHA º±±
	±±º          ³ nao ocorre calculo do volume                               º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AJUSTVOL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _cOldAlias := Alias()
	Local _aOldAlias := GetArea()
	Local _aSB1Alias := SB1->(GetArea())
	Local _aSB5Alias := SB5->(GetArea())
	Local _aSD2Alias := SD2->(GetArea())
	Local _aErro     := {}
	Local _aQtdEmb   := {}
	Local _nQtdEmb   := 0
	Local _nPosEmb   := 0
	Local _nPesoLiq  := 0
	Local _nPesoBru  := 0
	Local _nVol      := 0
	Local _nVolFim   := 0
	Local _cQuery    := ""
	Local lTesCalcula:= .T.
	Local _nIx		 := 0

	DBSelectArea("SB1")
	DBSetOrder(1)

	DBSelectArea("SB5")
	DBSetOrder(1)

	DBSelectArea("SF2")

	If SF2->F2_VOLUME1 == 0

		DBSelectArea("SD2")
		DBSetOrder(3)
		If DBSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)

			While !EOF() .and.	SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA == ;
					SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA


				If SD2->D2_TES = '676' .AND. cEmpAnt='04' .and. cFilAnt='02'
					lTesCalcula := .F.
				EndIF


				DBSelectArea("SB1")
				DBSeek(xFilial() + SD2->D2_COD)

				DBSelectArea("SB5")
				If DBSeek(xFilial() + SD2->D2_COD)

					If SB5->B5_QE1 <> 0

						_nQtdEmb := SB5->B5_QE1 * IIf("SEC.COLUNA" $ SB1->B1_DESC, 0.5, 1)

						_nPosEmb := Ascan(_aQtdEmb,{ |x| x[1] = _nQtdEmb })

						If _nPosEmb == 0

							AAdd(_aQtdEmb, {_nQtdEmb, 0} )

							_nPosEmb := Len(_aQtdEmb)

						EndIf

						_aQtdEmb[_nPosEmb, 2] += SD2->D2_QUANT

					Else

						_cErro := "CAMPO B5_QE1 NAO CADASTRADO"
						AAdd(_aErro, {SM0->M0_CODIGO, SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SD2->D2_COD, DToS(dDataBase), Time(), _cErro, __cUserID } )

					EndIf

				Else

					_cErro := "PRODUTO SEM SB5 CADASTRADO"
					AAdd(_aErro, {SM0->M0_CODIGO, SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SD2->D2_COD, DToS(dDataBase), Time(), _cErro, __cUserID } )

				EndIf

				If SB1->B1_PESO <> 0

					_nPesoLiq  += SD2->D2_QUANT * SB1->B1_PESO

				Else

					_cErro := "PRODUTO SEM PESO LIQUIDO CADASTRADO"
					AAdd(_aErro, {SM0->M0_CODIGO, SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SD2->D2_COD, DToS(dDataBase), Time(), _cErro, __cUserID } )

				EndIf

				If SB1->B1_PESBRU <> 0

					_nPesoBru  += SD2->D2_QUANT * SB1->B1_PESBRU

				Else

					_cErro := "PRODUTO SEM PESO BRUTO CADASTRADO"
					AAdd(_aErro, {SM0->M0_CODIGO, SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SD2->D2_COD, DToS(dDataBase), Time(), _cErro, __cUserID } )

				EndIf

				DBSelectArea("SD2")
				DBSkip()

			End

			_nVol    := 0
			_nVolFim := 0

			If Len(_aQtdEmb) > 0

				For _nIx := 1 To Len(_aQtdEmb)

					_nVol    := ( _aQtdEmb[_nIx, 2] / _aQtdEmb[_nIx, 1] )
					_nVolFim += ( Int(_nVol) + IIf(_nVol > Int(_nVol),  1, 0) )

				Next _nIx

			EndIf

			RecLock("SF2", .F.)

			If lTesCalcula
				SF2->F2_VOLUME1 := _nVolFim
			EndIf

			If SF2->F2_PLIQUI == 0

				SF2->F2_PLIQUI	:= _nPesoLiq

			EndIf

			If SF2->F2_PBRUTO == 0

				SF2->F2_PBRUTO	:= _nPesoBru

			EndIf

			SF2->(MSUnLock())

		EndIf

	EndIf

	If Len(_aErro) > 0

		If !TCCanOpen("TABERRVOL")

			_cQuery := "CREATE TABLE TABERRVOL ( "
			_cQuery += "TEV_EMP VARCHAR(2), "
			_cQuery += "TEV_FIL VARCHAR(2), "
			_cQuery += "TEV_DOC VARCHAR(9), "
			_cQuery += "TEV_SER VARCHAR(3), "
			_cQuery += "TEV_COD VARCHAR(15), "
			_cQuery += "TEV_ERR VARCHAR(45), "
			_cQuery += "TEV_DAT VARCHAR(8), "
			_cQuery += "TEV_HOR VARCHAR(8), "
			_cQuery += "TEV_USU VARCHAR(6)  "
			_cQuery += ")  "

			TCSQLExec(_cQuery)

		EndIf

		For _nIx := 1 To Len(_aErro)

			_cQuery := "INSERT INTO TABERRVOL ( TEV_EMP, TEV_FIL, TEV_DOC, TEV_SER, TEV_COD, TEV_ERR, TEV_DAT, TEV_HOR, TEV_USU) "
			_cQuery += "VALUES ( "
			_cQuery += "'" + SubStr(_aErro[_nIx, 1], 01, 02) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 2], 01, 02) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 3], 01, 09) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 4], 01, 03) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 5], 01, 15) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 6], 01, 45) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 7], 01, 08) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 8], 01, 08) + "',"
			_cQuery += "'" + SubStr(_aErro[_nIx, 9], 01, 06) + "' "
			_cQuery += ") "

			TCSQLExec(_cQuery)

		Next


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Emitirá aviso se for pedido normal com volume zerado                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cQuery := "SELECT ISNULL(C5_TIPO,'') AS C5_TIPO "
		_cQuery += "FROM " + RetSQLName("SC5") + " SC5 WITH(NOLOCK) "
		_cQuery += "WHERE SC5.C5_FILIAL = '"+ xFilial('SC5') +" WITH(NOLOCK) "
		_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
		_cQuery += " AND SC5.C5_NUM = "
		_cQuery += " ISNULL(( "
		_cQuery += "	SELECT TOP(1) D2_PEDIDO  "
		_cQuery += "	FROM " + RetSQLName("SD2") + " SD2 WITH(NOLOCK) "
		_cQuery += "	WHERE SD2.D2_FILIAL = '"+ xFilial('SD2') + "'"
		_cQuery += " 	AND SD2.D_E_L_E_T_	= ' ' "
		_cQuery += " 	AND SD2.D2_DOC			= '" + SF2->F2_DOC + "'"
		_cQuery += " 	AND SD2.D2_SERIE		= '" + SF2->F2_SERIE + "'"
		_cQuery += " 	AND SD2.D2_CLIENTE	= '" + SF2->F2_CLIENTE + "'"
		_cQuery += " 	AND SD2.D2_LOJA		= '" + SF2->F2_LOJA	+ "'"
		_cQuery += " ),'') "

		//MemoWrite("SCP_VOLZERO.SQL",_cQuery)

		If Select("SQLC5") > 0
			SQLC5->( dbCloseArea() )
		EndIf

		dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,_cQuery),"SQLC5", .F., .T.)

		If SQLC5->C5_TIPO='N' .AND. lTesCalcula .AND. SF2->F2_VOLUME1=0
			Aviso("Erro ao calcular o volume da Nfe", "Ocorreu erro ao calcular o volume da Nfe: "+SF2->F2_DOC+"/"+ SF2->F2_SERIE+"!!!" + chr(10)+chr(13) + "Comunique à TI para consultar a tabela de log TABERRVOL."+ chr(10)+chr(13) + _cErro,	{"Ok"}, 	3)
		EndIf

		SQLC5->( dbCloseArea() )

	EndIf

	DBSelectArea("SD2")
	RestArea(_aSD2Alias)

	DBSelectArea("SB5")
	RestArea(_aSB5Alias)

	DBSelectArea("SB1")
	RestArea(_aSB1Alias)

	DBSelectArea(_cOldAlias)
	RestArea(_aOldAlias)

Return


/* Função para gerar a Verba Tática no financeiro */
Static Function GeraVTT(nC5PERCTAT)

	Local aFIN040	:= {}
	Local cChaveSE1	:= ""
	Local nValor	:= 0
	Local cE1PARCELA:= ""
	LOCAL lPermite	:= .T.
	Local n 		:= 0

	Private aGets, aTela            //Variaveis auxiliares da Enchoice
	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.

	lPermite := Iif(SA1->A1_BCO1 = "999" , .F. , lPermite)
	lPermite := Iif(SC5->C5_CONDPAG $ "N01|N02|" , .F. , lPermite)

	If lPermite
		//
		// Forçar o posicionamento da SE1 - C. TORRES 02/07/2012
		//
		// E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		SE1->(DbSetOrder(2))
		SE1->(DbSeek( xFilial('SE1') + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ))
		//
		//---------------------------------[ termino ]----------------------------------------------------------------------
		//

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Encontra a menor parcela do título no financeiro     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSqlE1 := "SELECT ISNULL(MIN(E1_PARCELA),'') AS E1_MINPARC FROM " + RetSQLName("SE1") + " SE1 "
		cSqlE1 += "WHERE SE1.E1_FILIAL = '"		+ xFilial('SE1')
		cSqlE1 += "' AND SE1.E1_CLIENTE = '"	+ SE1->E1_CLIENTE
		cSqlE1 += "' AND SE1.E1_LOJA = '"		+ SE1->E1_LOJA
		cSqlE1 += "' AND SE1.E1_PREFIXO = '"	+ SE1->E1_PREFIXO
		cSqlE1 += "' AND SE1.E1_NUM = '" 		+ SE1->E1_NUM
		cSqlE1 += "' AND SE1.D_E_L_E_T_ = '' "

		//MEMOWRITE("M460FIM_TITULO_PRINCIPAL_VTT.SQL",cSqlE1)

		If Select("SQLE1") > 0
			SQLE1->( dbCloseArea() )
		EndIf

		dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,cSqlE1),"SQLE1", .F., .T.)

		SQLE1->(DbGotop())

		cE1PARCELA := SQLE1->E1_MINPARC

		SQLE1->( dbCloseArea() )

		aFin040 := {}

		cChaveSE1 := SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)

		SE1->(DbSetOrder(2))
		SE1->(DbSeek(cChaveSE1))

		Do While SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) = cChaveSE1 .And. ! SE1->(Eof())

			If SE1->E1_PARCELA = cE1PARCELA .AND. SE1->E1_VALOR > 0
				RegToMemory( "SE1", .F. )

				nValor			:= M->E1_VALOR

				IncProc("Gerando Verba Tática da parcela " + M->E1_PARCELA )

				M->E1_TIPO		:= "AB-"
				M->E1_VALOR		:= nValor * ( nC5PERCTAT/100 )
				M->E1_HIST		:= "Verba Tática"

				AADD(aFIN040,{ {"E1_PREFIXO"	,	M->E1_PREFIXO	,nil},;
					{"E1_NUM"		,	M->E1_NUM		,nil},;
					{"E1_PARCELA"	,	M->E1_PARCELA	,nil},;
					{"E1_TIPO"		,	M->E1_TIPO		,nil},;
					{"E1_NATUREZ"	,	M->E1_NATUREZ	,nil},;
					{"E1_CLIENTE"	,	M->E1_CLIENTE	,nil},;
					{"E1_LOJA"		,	M->E1_LOJA		,nil},;
					{"E1_NOMCLI"	,	M->E1_NOMCLI	,nil},;
					{"E1_EMISSAO"	,	M->E1_EMISSAO	,nil},;
					{"E1_VENCTO"	,	M->E1_VENCTO	,nil},;
					{"E1_VENCREA"	,	M->E1_VENCREA	,nil},;
					{"E1_VALOR"		,	M->E1_VALOR		,nil},;
					{"E1_HIST"		,	M->E1_HIST		,nil},;
					{"E1_PEDIDO"	,	M->E1_PEDIDO	,nil},;
					{"E1_ITEMC"		,	M->E1_ITEMC 	,nil}	 })

			EndIf
			SE1->(DbSkip())

		EndDo

		Begin Transaction

			lMsErroAuto := .F. // variavel interna da rotina automatica
			lMsHelpAuto := .F.

			For n := 1 to len(aFIN040)
				MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],3)
				If LMsErroAuto
					MostraErro()
					DisarmTransaction()
					Break
				Endif
			Next

		End Transaction
	EndIf
Return(.t.)
