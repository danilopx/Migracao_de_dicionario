#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2460I  ºAutor  ³ Fernando Salvatori º Data ³  09/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado apos a gravacao da tabela SF2   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºModifica  ³ Executa PROCEDURE para atualizar forma de pagamento na BF  º±±
±±ºAutor	 ³ Carlos Torres					ºData: ³	26/04/2011	  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I
	Local aArea  := GetArea()
	Local cQuery := ""
	//Local __aRet

	LOCAL NREGS			:= 0
	//LOCAL APRODUTOS 	:= {}
	//LOCAL LINTERC		:= .F.

// Atualiza a Ordem Carga do Pedido na Nota Fiscal
// Manter a atualização deste campo
// Usado pelo processo de Intercompany + Recebimento (Cross Docking) 
	If !SF2->(Eof())
		If SF2->( RecLock("SF2",.F.) )
			If SC5->(FIELDpos("C5_NUMOC")) != 0
				SF2->F2_NUMRM	:= SC5->C5_NUMOC
			EndIf
			SF2->( MsUnlock() )
		EndIf
	EndIf

	cQuery := "SELECT D2_META  "
	cQuery += "  FROM " + RetSQLName("SD2")
	cQuery += " WHERE D2_FILIAL  = '"+xFilial("SD2")+"' "
	cQuery += "   AND D2_DOC     = '"+SF2->F2_DOC+"' "
	cQuery += "   AND D2_SERIE   = '"+SF2->F2_SERIE+"' "
	cQuery += "   AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
	cQuery += "   AND D2_LOJA    = '"+SF2->F2_LOJA+"' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "

	cQuery := ChangeQuery(cQuery)

	If Select("TSD2") > 0
		TSD2->( dbCloseArea() )
	Endif

	TCQUERY cQuery ALIAS "TSD2" NEW

	If TSD2->D2_META $ ("001|003") .And. SF2->F2_TPFRETE <> "F"
		U_TFAtuFre()
	Endif

	TSD2->( dbCloseArea() )

	U_TFAtuSB1()

/* U_TFAtuCNAB() Função comentada em 10/06/2015 por CT implementada TRIGGER de banco SE1030_INS_TAIFF para atualizar o E1_IDCNAB */

	U_TFAtuSF2()

	U_TFAtuSF6()

	U_TFprorro()

	U_TFmsgnfe() // Função para atribuir o codigo de mensagem do item da nota impresso no XML (Base exceção fiscal)

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Processo de alteração de Status dos Pedidos de Vendas no Processo de 
|	CrossDocking
|=================================================================================
*/
/*
|---------------------------------------------------------------------------------
|	Realiza a validacao do Cliente verificando se eh do Grupo.
|---------------------------------------------------------------------------------
*/

	IF (CEMPANT + CFILANT) = "0302" .AND. .NOT. EMPTY(SC5->C5_NUMOC)

		CQUERY := "SELECT" 												+ ENTER
		CQUERY += "	SC5.C5_NUMORI" 										+ ENTER
		CQUERY += "FROM" 												+ ENTER
		CQUERY += "	" + RETSQLNAME("SD2") + " SD2" 						+ ENTER
		CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 		+ ENTER
		CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 	+ ENTER
		CQUERY += "		SC5.C5_NUM = SD2.D2_PEDIDO AND" 				+ ENTER
		CQUERY += "		SC5.C5_NUMORI != '' AND" 						+ ENTER
		CQUERY += "		SC5.C5_FILDES = '01' AND" 						+ ENTER
		CQUERY += "		SC5.D_E_L_E_T_ = ''" 							+ ENTER
		CQUERY += "WHERE" 												+ ENTER
		CQUERY += "	SD2.D2_FILIAL = '" + XFILIAL("SD2") + "' AND" 		+ ENTER
		CQUERY += "	SD2.D2_DOC = '" + SF2->F2_DOC + "' AND" 				+ ENTER
		CQUERY += "	SD2.D2_SERIE = '" + SF2->F2_SERIE + "' AND" 			+ ENTER
		CQUERY += "	SD2.D_E_L_E_T_ = ''" 								+ ENTER
		CQUERY += "GROUP BY" 											+ ENTER
		CQUERY += "	SD2.D2_PEDIDO, SC5.C5_NUMORI"

		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		COUNT TO NREGS

		IF NREGS > 0

			TMP->(DBGOTOP())
			WHILE TMP->(!EOF())

				CQUERY := "UPDATE" 									+ ENTER
				CQUERY += "	SC5" 									+ ENTER
				CQUERY += "SET" 									+ ENTER
				CQUERY += "	C5_STCROSS = 'EMTRAN' " 					+ ENTER
				CQUERY += "FROM" 									+ ENTER
				CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 			+ ENTER
				CQUERY += "WHERE" 									+ ENTER
				CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER
				CQUERY += "	C5_NUM = '" + TMP->C5_NUMORI + "' AND" 	+ ENTER
				CQUERY += "	D_E_L_E_T_ = ''"

				TCSQLEXEC(CQUERY)
				TMP->(DBSKIP())

			ENDDO

		ENDIF

	ELSEIF (CEMPANT + CFILANT) = "0301" .AND. .NOT. EMPTY(SD2->D2_PEDIDO) .AND. SF2->F2_TIPO = "N"
		//
		// Verifica se é pedido de CROSS DOCKING, isto é, se existe copia do pedido em EXTREMA, caso seja deve atualizar campo C5_STCROSS
		//
		CQUERY := "SELECT" 											+ ENTER
		CQUERY += "	COUNT(*) AS CONTA_CROSS "						+ ENTER
		CQUERY += "FROM" 												+ ENTER
		CQUERY += " " + RETSQLNAME("SC5") + " SC5 WITH(NOLOCK) "	+ ENTER
		CQUERY += "WHERE" 											+ ENTER
		CQUERY += "	C5_FILIAL = '02' " 							+ ENTER
		CQUERY += "	AND SC5.D_E_L_E_T_ = ''" 						+ ENTER
		CQUERY += "	AND C5_NUMORI = '" + SD2->D2_PEDIDO + "'"	+ ENTER
		CQUERY += "	AND C5_NUMOC='CROSS'"							+ ENTER
		//MEMOWRITE("SF2460I_query_pedido_cross_sp.SQL",CQUERY)

		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()

		If TMP->CONTA_CROSS > 0
			CQUERY := "SELECT" 																	+ ENTER
			CQUERY += "	(SUM(SC6.C6_QTDVEN) - SUM(SC6.C6_QTDENT)) AS SALDOQTD " 	+ ENTER
			CQUERY += "FROM " + RETSQLNAME("SC6") + " SC6 WITH(NOLOCK)" 						+ ENTER
			CQUERY += "WHERE" 																	+ ENTER
			CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 						+ ENTER
			CQUERY += "	SC6.C6_NUM = '" + SD2->D2_PEDIDO + "' AND" 							+ ENTER
			CQUERY += "	SC6.D_E_L_E_T_ = ''"

			//MEMOWRITE("SF2460I_query_SALDO_pedido_cross_sp.SQL",CQUERY)

			IF SELECT("TMP") > 0

				DBSELECTAREA("TMP")
				DBCLOSEAREA()

			ENDIF

			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()

			IF TMP->SALDOQTD != 0

				DBSELECTAREA("SC5")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SC5") + SD2->D2_PEDIDO)
					If ALLTRIM(SC5->C5_CLASPED) $ "V|X"
						RECLOCK("SC5",.F.)
						SC5->C5_STCROSS := "ATPARC"
						SC5->(MSUNLOCK())
					EndIf
				ENDIF

			ELSE

				DBSELECTAREA("SC5")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SC5") + SD2->D2_PEDIDO)
					If ALLTRIM(SC5->C5_CLASPED) $ "V|X"
						RECLOCK("SC5",.F.)
						SC5->C5_STCROSS := "FINALI"
						SC5->(MSUNLOCK())
					EndIf
				ENDIF

			ENDIF
		EndIf
	ENDIF

	TFAtuCMP()

	RestArea(aArea)

Return Nil

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuCNAB 		                             AUTOR: CARLOS ALDAY TORRES           DATA: 13/04/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza o campo ID_CNAB para a empresa PROART
//+--------------------------------------------------------------------------------------------------------------
User Function TFAtuCNAB
	Local	__cId_CNAB	:= ""
	Local xSe1Alias	:= SE1->(GetArea())
	Local aArea 		:= GetArea()

	If SM0->M0_CODIGO='03' .AND. CFILANT='01'
		__cId_CNAB := ""
		SE1->(DbSetOrder(1))
		SE1->(DbSeek( xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC ))
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM = xFilial("SE1") + SF2->F2_SERIE + SF2->F2_DOC .and. !SE1->(EOF())
			If Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					__cId_CNAB := Substr(SE1->E1_NUM,2,8) + "A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					__cId_CNAB := Substr(SE1->E1_NUM,2,8) + Alltrim(SE1->E1_PARCELA)
				Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
					__cId_CNAB := Substr(SE1->E1_NUM,2,8) + Chr(Asc(  Alltrim(Str(Val(SE1->E1_PARCELA)))  )+16)
				EndCase
				SE1->(RecLock("SE1",.F.))
				SE1->E1_IDCNAB := __cId_CNAB
				SE1->(MsUnLock())
			Endif
			SE1->(DbSkip())
		EndDo
	EndIf
	RestArea(xSe1Alias)
	RestArea(aArea)

Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuSF2 		                             AUTOR: CARLOS ALDAY TORRES               DATA: 14/07/2011
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza campos da tabela SD2 e SF2
//+--------------------------------------------------------------------------------------------------------------
User Function TFAtuSF2
	Local xSd2Alias	:= SD2->(GetArea())
	Local xSc5Alias	:= SC5->(GetArea())
	Local xSc6Alias	:= SC6->(GetArea())
	Local _nC5_VBPRPED:= 0

	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	SD2->(DbSetOrder(3))

	SD2->(DbSeek( xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)  ))
	While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .AND. !SD2->(Eof())

		SC6->(DbSeek( xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV + SD2->D2_COD ))

		If SC5->(DbSeek( xFilial("SC5") + SD2->D2_PEDIDO ))
			_nC5_VBPRPED := SC5->C5_VBPRPED

			SD2->( RecLock("SD2",.F.) )
			SD2->D2_PCBOPED := SC5->C5_PCBOPED
			SD2->D2_PCFRETE := SC5->C5_PCFRETE
			SD2->D2_PCVBCTR := SC5->C5_PCVBCTR
			SD2->D2_CUSTPRO := SC6->C6_CUSTPRO
			SD2->D2_DESPFIN := SC6->C6_DESPFIN
			SD2->D2_VLTSIPI := SC6->C6_VLTSIPI
			SD2->( MsUnlock() )
		EndIf
		SD2->(DbSkip())

	End

	RestArea(xSd2Alias)
	RestArea(xSc5Alias)
	RestArea(xSc6Alias)

Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuSF6 		                             AUTOR: CARLOS ALDAY TORRES               DATA: 01/12/2011
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza campos da tabela SF6 - vencimento da guia de recolhimento
//| OBSERVACAO: A guia de recolhimento é criada em SF6 pela resposta positiva da pergunta "Gera Guia" ao faturar NF
//+--------------------------------------------------------------------------------------------------------------
User Function TFAtuSF6
	Local xSf6Alias		:= SF6->(GetArea())
	Local nDiasVen		:= GETNEWPAR("MV_TFDIAGN", 0 )
	Local cF6OPERNF		:= "2" // 1-Entrada e 2-Saida
	Local cF6TIPODOC	:= "N"
	Local nProdGNRE		:= 0
	Local cGNREbco		:= GETNEWPAR("TF_GNREBCO", "237" )
	Local cGNREage		:= GETNEWPAR("TF_GNREAGE", "33928" )
	Local _cConvenio	:= ""
	Local aRet 		:= TamSX3("F6_TIPODOC")

/* Na atualização do release 12.1.17 o tamano do campo F6_TIPODOC mudou de 1 para 2 impactando na pesquisa da tabela SF6 */
	cF6TIPODOC	:= PADR(cF6TIPODOC , aRet[1] )

//
//
// Order 3 do SF6
// F6_FILIAL, F6_OPERNF, F6_TIPODOC, F6_DOC, F6_SERIE, F6_CLIFOR, F6_LOJA, R_E_C_N_O_, D_E_L_E_T_
//

	SF6->(DbSetOrder(3))
	If SF6->(DbSeek( xFilial("SF6") + cF6OPERNF + cF6TIPODOC + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)  ))

		nProdGNRE	:= GETNEWPAR("TF_PROGN" + SF6->F6_EST, 0 )
		_cConvenio	:= GetNewPar("TF_CONVE" + SF6->F6_EST,"")

		SF6->( RecLock("SF6",.F.) )
		SF6->F6_DTVENC := DataValida(dDataBase + nDiasVen,.T.)
		SF6->F6_CODPROD:=	nProdGNRE
		SF6->F6_NUMCONV:= _cConvenio
		SF6->F6_BANCO	:= cGNREbco
		SF6->F6_AGENCIA:= cGNREage

		SF6->( MsUnlock() )

	EndIf

	RestArea(xSf6Alias)
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuFre 		                             AUTOR: CARLOS ALDAY TORRES           DATA: 14/06/2012   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza rotina do frete
//| SOLICITANTE: Brito
//| OBSERVACAO: Rotina disparada no PE SF2460I
//+--------------------------------------------------------------------------------------------------------------
User Function TFAtuFre()
	local _nValBrut := SF2->F2_VALBRUT   // Total da Nota
	local _nPesProd := SF2->F2_PBRUTO  	// Total do Peso Liquido
	local _cEst	    := SF2->F2_EST
	local _cCep	    := ""
	local _cTpCalc  := 'N'
	local _cTransp  := SF2->F2_TRANSP
	local _dEmissao := SF2->F2_EMISSAO
	local _lTDE     := .F.
	Local _cPrevDeFr:= GETNEWPAR("TF_PRVFRE", "N" ) // Calcula (S ou N) previsao de frete

	If _cPrevDeFr = "S"
		If SF2->F2_TIPO $ 'B/D'
			DbSelectArea("SA2")
			DbSetOrder(1)
			if DbSeek( xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA )
				_cCep	:= SA2->A2_CEP
				_cEst	:= SF2->F2_EST
			endif
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			if DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA )
				_cCep	:= SA1->A1_CEP
				_cEst	:= SA1->A1_EST
				_lTDE	:= SA1->A1_FRETED == "S"
			endif
		Endif

		_aCalTrans := U_SeleFrete(_nValBrut ,_nPesProd , _cEst,_cCep,_cTpCalc,_cTransp,_dEmissao,_lTDE,.T.)

		If len(_aCalTrans) > 0
			If !SF2->(Eof())
				SF2->( RecLock("SF2",.F.) )
				SF2->F2_PESOPRE 	:= _aCalTrans[1][3][6]  // Valor do Frete Peso
				SF2->F2_PRVFRE 	:= _aCalTrans[1][3][9]  // Valor  Total do Frete
				SF2->( MsUnlock() )
			EndIf
		EndIf
	EndIf

Return NIL

//-------------------------------------------------------------------------------------------------------
// ROTINA: TFprorro 		                        AUTOR: CARLOS ALDAY TORRES           DATA: 21/01/2012
//-------------------------------------------------------------------------------------------------------
// DESCRICAO: Prorroga vencimentos dos titulos no financeiro conforme regra de negocios
// SOLICITANTE: João Batista (Ger. Financeiro)
// OBSERVACAO: Pela regra inicial segue:
// 				a)	Para CD de Barueri, acrescer à data de vcto 02 dias;
//				b)	Para CD de Itumbiara, acrescer à data de vcto 05 dias.
//-------------------------------------------------------------------------------------------------------
User Function TFprorro()
	Local xSe1Alias	:= SE1->(GetArea())
	Local _cCdProrro	:= GETNEWPAR("TF_CDPROR", "0201|0202|0303" ) // Parametro que contem o CD a prorrogar
	Local _nDias		:= GETNEWPAR("TF_CDDIAS", 0 ) // Criar parametro para os CD's que prorrogam
	Local _cSqlE1		:= ""
	//Local aTitulos		:= {}
	Local aFin040		:= {}
	Local cNumTit		:= ""
	//Local cErroAuto	:= ""
	Local nNumPar		:= 0
	Local aPgto			:= {} // array dos vencimentos e valores das parcelas a serem geradas
	Local nErros		:= 0
	Local i				:= 0

	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.
	Private aTitulos    := {}

	If At( cEmpAnt + cFilAnt , _cCdProrro ) != 0 .and. _nDias != 0

		_cSqlE1 := "SELECT "
		_cSqlE1 += "  E1_PREFIXO, E1_NUM,   E1_PARCELA, E1_TIPO,    E1_VENCTO, E1_VENCREA, "
		_cSqlE1 += "  E1_SERIE, E1_NATUREZ, E1_EMISSAO "
		_cSqlE1 += "FROM " + RetSQLName("SE1") + " SE1 WITH(NOLOCK) "
		_cSqlE1 += "WHERE "
		_cSqlE1 += "  SE1.D_E_L_E_T_ = ' ' "
		_cSqlE1 += "  AND SE1.E1_TIPO    =  'NF ' "
		_cSqlE1 += "  AND SE1.E1_FILIAL  = '" + xFilial("SE1") + "' "
		_cSqlE1 += "  AND SE1.E1_PREFIXO = '" + SF2->F2_SERIE + "' "
		_cSqlE1 += "  AND SE1.E1_NUM		= '" + SF2->F2_DOC + "' "
		_cSqlE1 += "  AND SE1.E1_CLIENTE = '" + SF2->F2_CLIENTE + "' "
		_cSqlE1 += "  AND SE1.E1_LOJA		= '" + SF2->F2_LOJA + "' "
		_cSqlE1 += "  AND NOT EXISTS "
		_cSqlE1 += "  ( "
		_cSqlE1 += "     SELECT 'X' "
		_cSqlE1 += "     FROM " + RetSQLName("SE1") + " SE1X WITH(NOLOCK) "
		_cSqlE1 += "     WHERE "
		_cSqlE1 += "       SE1X.D_E_L_E_T_ = ' ' "
		_cSqlE1 += "       AND SE1X.E1_FILIAL  = '" + xFilial("SE1") + "' "
		_cSqlE1 += "       AND SE1X.E1_PREFIXO = SE1.E1_PREFIXO "
		_cSqlE1 += "       AND SE1X.E1_NUM     = SE1.E1_NUM "
		_cSqlE1 += "       AND SE1X.E1_TIPO    = SE1.E1_TIPO "
		_cSqlE1 += "  		 AND SE1X.E1_CLIENTE = SE1.E1_CLIENTE "
		_cSqlE1 += "  		 AND SE1X.E1_LOJA		= SE1.E1_LOJA "
		_cSqlE1 += "       AND (SE1X.E1_NUMBOR  <> '" + Space(TamSx3("E1_NUMBOR")[1]) + "' "
		_cSqlE1 += "       OR SE1X.E1_BAIXA   <> '" + Space(TamSx3("E1_BAIXA")[1]) + "' "
		_cSqlE1 += "       OR SE1X.E1_PORTADO <> '" + Space(TamSx3("E1_PORTADO")[1]) + "') "
		_cSqlE1 += "  ) "
		_cSqlE1 += " ORDER BY "
		_cSqlE1 += "  SE1.E1_NUM, SE1.E1_SERIE, SE1.E1_TIPO, SE1.E1_PARCELA "

		If Select("SQLE1") # 0
			SQLE1->(DbCloseArea())
		EndIf

		TcQuery _cSqlE1 New Alias "SQLE1"

		TcSetField("SQLE1", "E1_EMISSAO", "D")
		TcSetField("SQLE1", "E1_VENCTO", "D")

		_cTexto := "Empresa/Filial: "+cEmpAnt +"/"+ cFilAnt + chr(13)+chr(10)
		_cTexto += "Documento prorrogado: " + SF2->F2_DOC + "/" + SF2->F2_SERIE + chr(13)+chr(10)
		_cTexto += "Cliente/Loja: "+SF2->F2_CLIENTE+"/"+SF2->F2_LOJA+ chr(13)+chr(10)


		While !SQLE1->(Eof())
			If cNumTit <> SQLE1->E1_NUM + SQLE1->E1_SERIE + SQLE1->E1_TIPO
				aPgto   := Condicao(10, SF2->F2_COND, , SQLE1->E1_EMISSAO + _nDias) // Total para o calculo, cod. cond.pgto,data base
				cNumTit := SQLE1->E1_NUM + SQLE1->E1_SERIE + SQLE1->E1_TIPO
				nNumPar := 0
			EndIf

			aAdd(aFin040, {})
			nNumPar++

			_cTexto += "Parcela: "+SQLE1->E1_PARCELA+" prorrogada de "+dtoc(SQLE1->E1_VENCTO)+ " para " + dtoc(aPgto[nNumPar,1]) + chr(13)+chr(10)

			aAdd(aFin040[Len(aFIN040)], {"E1_PREFIXO", SQLE1->E1_PREFIXO , nil})
			aAdd(aFin040[Len(aFIN040)], {"E1_NUM"    , SQLE1->E1_NUM     , nil})
			aAdd(aFin040[Len(aFIN040)], {"E1_PARCELA", SQLE1->E1_PARCELA , nil})
			aAdd(aFin040[Len(aFIN040)], {"E1_TIPO"   , SQLE1->E1_TIPO    , nil})
			aAdd(aFin040[Len(aFIN040)], {"E1_VENCTO" , aPgto[nNumPar,1], nil})
			aAdd(aFin040[Len(aFIN040)], {"E1_VENCREA", aPgto[nNumPar,1], nil})
			SQLE1->(DbSkip())
		End

		For i := 1 To Len(aFin040)
			lMsErroAuto := .F. // variavel interna da rotina automatica
			lMsHelpAuto := .F.
			Begin Transaction
				MSExecAuto({|x,y| FINA040(x,y)}, aFIN040[i], 4)
				If lMsErroAuto
					nErros++
					DisarmTransaction()
				Endif
			End Transaction
		Next
		//MemoWrite( "TitProrrogado.TXT" , _cTexto )
	EndIf
	RestArea(xSe1Alias)
Return NIL

//+------------------------------------------------------------------------------------------------------------------------------------
//| ROTINA: TFmsgnfe 		                             AUTOR: CT           					DATA: 22/09/2014
//+------------------------------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza em campo customizado na tabela SD2 o codigo da mensagem impressa no DANFE base exceção fiscal 
//+------------------------------------------------------------------------------------------------------------------------------------
User Function TFmsgnfe
	Local aAreaSF7	:= SF7->(GetArea())
	Local xSd2Alias	:= SD2->(GetArea())
	Local xSA1Alias	:= SA1->(GetArea())
	Local xSB1Alias	:= SB1->(GetArea())
	Local lMsgOk 		:= .T.
	Local lBonifIVA	:= GetNewPar("TF_IVABONI",.F.)
	Local cMV_ESTADO	:= GetMv('MV_ESTADO')

	If SD2->(FieldPos("D2_XMENSNF")) != 0
		SF7->(DbSetOrder(1))
		SA1->(DbSetOrder(1))
		SB1->(DbSetOrder(1))
		SD2->(DbSetOrder(3))
		SD2->(DbSeek( xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)  ))
		While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .AND. !SD2->(Eof())
			lMsgOk := .T.
			If SA1->(DbSeek( xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA )) .AND. SB1->(DbSeek( xFilial("SB1")+SD2->D2_COD))
				If !Empty(SA1->A1_GRPTRIB) .AND. !Empty(SB1->B1_GRTRIB) .AND. SF7->(dbSeek(xFilial("SF7") + SB1->B1_GRTRIB + SA1->A1_GRPTRIB ) )
					While SF7->(F7_FILIAL+F7_GRTRIB+F7_GRPCLI) == (xFilial("SF7") + SB1->B1_GRTRIB + SA1->A1_GRPTRIB) .AND. !SF7->(Eof())
						If (SF7->F7_TIPOCLI == "*" .OR. SF7->F7_TIPOCLI == SA1->A1_TIPO) .AND. (SA1->A1_EST == SF7->F7_EST .Or. SF7->F7_EST == "**") .AND. (Substr(SD2->D2_CLASFIS,2,2) == SF7->F7_SITTRIB .Or. Empty(SF7->F7_SITTRIB))
						/* Bonificação com regime especial em EXTREMA - MG não pode levar a mensagem da exceção fiscal uma vez que a aliquota é de 18% e a exceção trata 12% e a mensagem é para 12%*/
							If CEMPANT = '03' .AND. CFILANT = '02' .AND. SC5->C5_CLASPED $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO
								If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. SC5->C5_TIPO = "N" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA
									lMsgOk := .F.
								EndIf
							EndIf
							If lMsgOk
								SD2->( RecLock("SD2",.F.) )
								SD2->D2_XMENSNF := SF7->F7_XMENSNF
								SD2->( MsUnlock() )
							EndIf
						EndIf
						SF7->(DbSkip())
					End
				EndIf
			EndIf
			SD2->(DbSkip())
		End

		RestArea(xSA1Alias)
		RestArea(xSB1Alias)
		RestArea(xSd2Alias)
		RestArea(aAreaSF7)
	EndIf
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuSB1 		                             AUTOR: CARLOS ALDAY TORRES           DATA: 15/05/2013   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza o campo da descrição do produto
//*---------------------------------------------------------[ ALTERACOES ]---------------------------------------  
//* DATA       AUTOR       OBJETIVO											  
//*----------- ----------- --------------------------------------------------------------------------------------  
//*	11/03/2015  CT          Função recuperada para atender demanda da área de vendas 																		  
//+--------------------------------------------------------------------------------------------------------------
User Function TFAtuSB1()
	Local _cQuery

	_cQuery := "UPDATE SD2 SET "
	_cQuery += " 	SD2.D2_DESCR  	= LEFT(SB1.B1_DESC,30) "
	_cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	If SM0->M0_CODIGO='03'
		_cQuery += "	INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=D2_COD AND B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ != '*' "
	Else
		_cQuery += "	INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD=D2_COD AND SB1.D_E_L_E_T_ != '*' "
	Endif
	_cQuery += " WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
	_cQuery += "   AND SD2.D_E_L_E_T_ != '*' "
	_cQuery += "   AND SD2.D2_DOC     = '"+SF2->F2_DOC+"' "
	_cQuery += "   AND SD2.D2_SERIE   = '"+SF2->F2_SERIE+"' "
	_cQuery += "   AND SD2.D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
	_cQuery += "   AND SD2.D2_LOJA    = '"+SF2->F2_LOJA+"' "

	TCSQLExec( _cQuery )


Return Nil

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFAtuCMP 		                             AUTOR: CARLOS ALDAY TORRES           DATA: 08/02/2017   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Encaminha e-mail ao comprador com aviso de devolução de compra
//*---------------------------------------------------------[ ALTERACOES ]---------------------------------------  
//* DATA       AUTOR       OBJETIVO											  
//*----------- ----------- --------------------------------------------------------------------------------------  
//*																	  
//+--------------------------------------------------------------------------------------------------------------
Static Function TFAtuCMP
	Local xSd2Alias	:= SD2->(GetArea())
	Local xSd1Alias	:= SD1->(GetArea())
	Local xSb1Alias	:= SB1->(GetArea())
	Local cHtml := ""
	Local lOkArquivo := .F.

	If !SF2->(Eof()) .AND. SF2->F2_TIPO = "D"
		cHtml := '<H1>Processo de Devolucao de Compras</H1>'
		cHtml += '<table border="1"><tr><th>Marca</th><th>Pedido</th><th>Item Pedido</th><th>Produto</th><th>Descricao</th></tr>'

		SB1->(DbSetOrder(1)) /*D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_*/
		SD1->(DbSetOrder(1)) /*D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_*/
		SD2->(DbSetOrder(3))
		SD2->(DbSeek( xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA)  ))
		While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) .AND. !SD2->(Eof())
			If SD2->D2_TIPO="D" .AND. ALLTRIM(SD2->D2_ITEMCC) != "CORP"
				If SD1->(DbSeek( SD2->(D2_FILIAL+D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEMORI) ))
					If .NOT. Empty(SD1->D1_PEDIDO)
						SB1->(DbSeek( xFilial("SB1") + SD1->D1_COD ))
						cHtml += '<tr><td>' + SD2->D2_ITEMCC + '</td><td>' + SD1->D1_PEDIDO + '</td><td>' + SD1->D1_ITEM + '</td><td>' + SD1->D1_COD + '</td><td>' + SB1->B1_DESC + '</td></tr>'
						lOkArquivo := .T.
					EndIf
				EndIf
			EndIf
			SD2->(DbSkip())
		End
		cHtml += '</table>'
	EndIf
	If lOkArquivo

		cMailDest := "grp_compras@taiff.com.br"
		//cMailDest += Iif( .not. Empty(cMailDest),";","") + Alltrim(UsrRetMail(RetCodUsr()))

		//cMailDest := "carlos.torres@taiffproart.com.br"

		U_2EnvMail("workflow@taiff.com.br",RTrim(cMailDest)	,'',cHtml	,"Devolucao de Compras",'')

	EndIf

	RestArea(xSb1Alias)
	RestArea(xSd1Alias)
	RestArea(xSd2Alias)

Return Nil
