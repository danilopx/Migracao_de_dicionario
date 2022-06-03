#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#DEFINE ENTER CHAR(13) + CHAR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AENDVFIN02  ºAutor  ³Jackson Santos     º Data ³  22/08/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Liberação do Congtrato para o Financeiro.	     º±±
±±º          ³ 			                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ADGFIN02 - Controle de Emprestimos 				              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      

User Function AENDVF02(cAliasLib,nRecnoLib,nOpcLib,cNumContr,cRevContr,cChvPesq,lMovBco,cNumRefCtr)
	Local lRetLib := .F.
	Local cQuery  := ""
	//Local cNaturTac := SuperGetMV("DG_ENATTAC",.f.,"TAC") //Nat Tac
	//Local cNaturIOF := ""
	Local aParcelas := {}
	Local nX := 0

	Private lBxVendor := .F.
	Private cPreEmpE2 := ""
	Private cNumEmpE2 := ""
	PRIVATE lMsErroAuto := .F.
	PRIVATE lTemMovBco := (Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_MOVBANC")=="S")
	Private cCustoDeb  := Iif(SZW->(FieldPos("ZW_CCD")) > 0 ,Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_CCD"),"")

	Default cAliasLib := ""
	Default nRecnoLib := 0
	Default nOpcLib	  := 0
	Default cNumContr := ""
	Default cRevContr := ""
	Default lMovBco   := .F.
	Default cNumRefCtr := ""
	If nOpcLib == 3 .And. SZY->ZY_STATFIN $ " /0"//Inclusão
		cQuery := " SELECT "
		cQuery += ENTER + " ZW_TIPOTIT E2_PREFIXO,ZZ_CODSEQ E2_NUM,ZY_CODCONT, "
		cQuery += ENTER + " ZZ_NPARSE2  E2_PARCELA,ZW_TIPOTIT E2_TIPO,ZZ_PARAPAG E2_VALOR,ZZ_VLRPRIN,ZZ_VLRJUR E2_XJURCTR,ZZ_VJURVAR E2_XJURVAR, "
		cQuery += ENTER + " ZY_DTCONTR E2_EMISSAO,ZZ_DTVENC E2_VENCTO,ZW_FORNECE E2_FORNECE, "
		cQuery += ENTER + " ZW_LOJA E2_LOJA,'CONTRATO:' + ZY_CODCONT E2_HIST,ZW_NATUREZ E2_NATUREZ "
		cQuery += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
		cQuery += ENTER + " JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = SZZ.ZZ_FILIAL AND SZY.ZY_CODSEQ = SZZ.ZZ_CODSEQ AND SZY.ZY_REVISAO = SZZ.ZZ_REVISAO "
		cQuery += ENTER + " JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
		cQuery += ENTER + " WHERE SZZ.D_E_L_E_T_ <> '*' AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' "
		cQuery += ENTER + " AND SZZ.ZZ_NPARSE2 <> '' AND LTRIM(RTRIM(SZZ.ZZ_DTPGPAR)) = '' "
		cQuery += ENTER + " AND SZY.ZY_CODSEQ = '" + cNumContr +"' "
		cQuery += ENTER + " AND SZY.ZY_REVISAO = '" + cRevContr + "' "
		cQuery += ENTER + "	UNION ALL  "
		cQuery += ENTER + "	SELECT "
		cQuery += ENTER + "	'IOF' E2_PREFIXO,ZY_CODSEQ  E2_NUM,ZY_CODCONT, "
		cQuery += ENTER + "	''  E2_PARCELA,ZW_TIPOTIT E2_TIPO,ZY_VRIOFCT E2_VALOR,0 E2_XJURCTR,0 ZZ_VLRPRIN,0 E2_XJURVAR, "
		cQuery += ENTER + "	ZY_DTCONTR E2_EMISSAO,ZY_DTCONTR E2_VENCTO,ZW_FORNECE E2_FORNECE, "
		cQuery += ENTER + "	ZW_LOJA E2_LOJA,'IOF-CONTR:' + ZY_CODCONT E2_HIST,CASE WHEN LTRIM(RTRIM(ZW_NATUIOF)) <> '' THEN ZW_NATUIOF ELSE ZW_NATUREZ END E2_NATUREZ "
		cQuery += ENTER + "	FROM " + RetSqlName("SZY") + " SZY "
		cQuery += ENTER + "	JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
		cQuery += ENTER + "	WHERE  SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' "
		cQuery += ENTER + "	AND SZY.ZY_CODSEQ = '" + cNumContr +"' "
		cQuery += ENTER + "	AND SZY.ZY_REVISAO = '" + cRevContr + "' "
		cQuery += ENTER + "	AND SZY.ZY_TIPOIOF = '2' "
		cQuery += ENTER + "	UNION ALL "
		cQuery += ENTER + "	SELECT "
		cQuery += ENTER + "	'TAC' E2_PREFIXO,ZY_CODSEQ  E2_NUM,ZY_CODCONT, "
		cQuery += ENTER + "	''  E2_PARCELA,ZW_TIPOTIT E2_TIPO,ZY_VLRTAC E2_VALOR,0 ZZ_VLRPRIN,0 E2_XJURCTR,0 E2_XJURVAR, "
		cQuery += ENTER + "	ZY_DTCONTR E2_EMISSAO,ZY_DTCONTR E2_VENCTO,ZW_FORNECE E2_FORNECE, "
		//If !Empty(cNaturTac)
		//	cQuery += ENTER + "	ZW_LOJA E2_LOJA,'TAC-CONTR:' + ZY_CODCONT E2_HIST,'" + cNaturTac + "' E2_NATUREZ "
		//Else
		cQuery += ENTER + "	ZW_LOJA E2_LOJA,'TAC-CONTR:' + ZY_CODCONT E2_HIST,CASE WHEN LTRIM(RTRIM(ZW_NATUTAC)) <> '' THEN ZW_NATUTAC ELSE ZW_NATUREZ END E2_NATUREZ "
		//EndIf
		cQuery += ENTER + "	FROM " + RetSqlName("SZY") + " SZY "
		cQuery += ENTER + "	JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
		cQuery += ENTER + "	WHERE  SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' "
		cQuery += ENTER + "	AND SZY.ZY_CODSEQ = '" + cNumContr +"' "
		cQuery += ENTER + "	AND SZY.ZY_REVISAO = '" + cRevContr + "' "
		cQuery += ENTER + "	AND SZY.ZY_TIPOTAC = '1' "

		If Select("TBSE2") > 0
			TBSE2->(DbCloseArea())
		EndIf

		//MemoWrite( "\DATA\QRYENDVIDAMENTO.SQL", cQuery )
		TCQUERY cQuery NEW ALIAS "TBSE2"
		cE2_PARCELA := "00"
		While TBSE2->(!EOF())
			cE2_PREFIXO := TBSE2->E2_PREFIXO //Space(03)
			cE2_NUM     := TBSE2->E2_NUM //Space(09)
			//If Empty(Alltrim(TBSE2->E2_PARCELA))
			cE2_PARCELA := TBSE2->E2_PARCELA //Space(02)
			//Else
			//	cE2_PARCELA := Soma1(cE2_PARCELA)
			//EndIf
			cE2_TIPO  	:= TBSE2->E2_TIPO  //Space(03)
			cE2_NATUREZ := TBSE2->E2_NATUREZ //Space(10)
			cE2_FORNECE := TBSE2->E2_FORNECE //Space(06)
			cE2_LOJA		:= TBSE2->E2_LOJA //Space(02)
			dE2_EMISSAO := STOD(TBSE2->E2_EMISSAO) //CTOD("  /  /  ")
			dE2_VENCTO	:= STOD(TBSE2->E2_VENCTO) //CTOD("  /  /  ")
			dE2_VENCREA := DataValida(dE2_VENCTO,.T.)
			nE2_VALOR	:= TBSE2->ZZ_VLRPRIN //TBSE2->E2_VALOR
			nE2_ACRESC  := TBSE2->E2_XJURCTR
			nE2_XJURCTR := TBSE2->E2_XJURCTR
			nE2_XJURVAR := TBSE2->E2_XJURVAR
			cE2_PORTADO := SZY->ZY_CODBCO
			cE2_XRFENDV := Alltrim(TBSE2->ZY_CODCONT)
			AaDd(aParcelas,{{ "E2_PREFIXO" , cE2_PREFIXO , NIL },;
				{ "E2_NUM"      , cE2_NUM     , NIL },;
				{ "E2_TIPO"     , cE2_TIPO    , NIL },;
				{ "E2_PARCELA"	 , cE2_PARCELA	, NIL },;
				{ "E2_NATUREZ"  , cE2_NATUREZ , NIL },;
				{ "E2_FORNECE"  , cE2_FORNECE , NIL },;
				{ "E2_XNUMCTR"	,cE2_XRFENDV,NIL} /*IIF(SE2->(FieldPos("E2_XNUMCTR")) > 0,{"E2_XNUMCTR"		,cE2_XRFENDV,NIL},)*/,;
				{ "E2_LOJA"		, cE2_LOJA		, NIL },;
				{ "E2_EMISSAO"  , dE2_EMISSAO	, NIL },;
				{ "E2_VENCTO"   , dE2_VENCTO	, NIL },;
				{ "E2_VENCREA"  , dE2_VENCREA	, NIL },;
				{ "E2_ORIGEM"   , "AENDVF02"	, NIL },;
				{ "E2_PORTADO"  , cE2_PORTADO	, NIL },;
				{ "E2_ACRESC"  	, nE2_XJURCTR	, NIL },;
				{ "E2_XJURCTR"  , nE2_XJURCTR	, NIL },;
				{ "E2_XJURVAR"  , nE2_XJURVAR	, NIL },;
				{ "E2_XRFENDV"  , cE2_XRFENDV	, NIL },;
				{ "E2_VALJUR"   , nE2_XJURVAR	, NIL },;
				{ "E2_XENDVDG"  , "S"			, NIL },;
				{ "E2_CCD"  	, cCustoDeb		, NIL },;
				{ "E2_FILORIG"	, cFilAnt       , NIL },;
				{ "E2_VALOR"    , nE2_VALOR   	, NIL }})

			cPreEmpE2 := TBSE2->E2_PREFIXO
			cNumEmpE2 := TBSE2->E2_NUM

			TBSE2->(DbSkip())
		EndDo
		cDocumEmp := cPreEmpE2 + cNumEmpE2
		cCodBcoEmp := SZY->ZY_CODBCO
		cCodAgeEmp := SZY->ZY_BCOAGEN
		cCodCtaEmp := SZY->ZY_BCOCONT
		nVlrCruzEmp := SZY->ZY_VLRCONT
		cNaturEmp   := Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_NATUREZ")
		nRecNoSZY   := SZY->(recno())
		If SZW->(FieldPos("ZW_BXVENDO")) > 0
			lBxVendor := Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_BXVENDO") == "1"
		Else
			lBxVendor := .F.
		EndIf

		dDtCredEmp 	:= SZY->ZY_DTCRED
		IIF(!lMovBco,lMovBco := lTemMovBco,)
		IF lTemMovBco .And. Empty(Alltrim(DtoS(dDtCredEmp)))
			//MsgStop("Modalidade Possui movimentação bancária e a data do crédito não está preenchida","Erro Data De Crédito")
			dDtCredEmp := DDataBase
		EndIf
	ElseIf nOpcLib == 4 //Alteração
		If cAlias == "SZZ"
			aAreaSe2 := SE2->(GetArea())
			DbSelectArea("SE2")
			SE2->(DbGoTo(nRenoLib))
			//If SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_
			RestArea(aAreaSe2)
		Else
			MsgStop("Só é possivel alterar as parcelas do Contrato no Financeiro","Erro Alteração")
			lRetLib := .F.
		EndIf
	ElseIf	nOpcLib == 5 //Eclusão
		IF SZY->ZY_STATFIN $ "1" //Somente o status de liberado permitirá o storno.
			nQtdParc := 0
			nQtdEmAb := 0
			For nX := 1 to 2
				If nX == 1
					cQuery := "	SELECT SZY.ZY_QTDPARC QTDPARC,COUNT(*) QTDEMABERT "
				Else
					cQuery := " SELECT "
					cQuery += ENTER + "	E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,SE2.R_E_C_N_O_ RECNOS  "
				EndIf
				cQuery += ENTER + "	FROM " + RetSqlName("SE2") + " SE2 "
				cQuery += ENTER + "	JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' AND SZY.ZY_CODSEQ = '" + cNumContr + "' "
				cQuery += ENTER + "	JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
				cQuery += ENTER + "	WHERE SE2.D_E_L_E_T_ <> '*' AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
				cQuery += ENTER + "	AND E2_SALDO = E2_VALOR "
				cQuery += ENTER + "	AND E2_XENDVDG = 'S'  "
				cQuery += ENTER + "	AND E2_TIPO = SZW.ZW_TIPOTIT "
				cQuery += ENTER + "	AND E2_BAIXA = '' "
				cQuery += ENTER + "	AND (E2_NUM = '" + cNumContr + "' OR E2_XRFENDV = '" + cNumContr + "') " //+  cRevContr + "' "
				If nX == 1
					cQuery += ENTER + "	AND E2_PREFIXO NOT IN ('TAC','IOF') "
					cQuery += ENTER + "	GROUP BY SZY.ZY_QTDPARC "
				EndIf

				If Select("TBSE2") > 0
					TBSE2->(DbCloseArea())
				EndIf
				//MemoWrite( "\DATA\QRYENDESTORN.SQL", cQuery )
				TCQUERY cQuery NEW ALIAS "TBSE2"
				If Nx == 1
					nQtdParc := TBSE2->QTDPARC
					nQtdEmAb := TBSE2->QTDEMABERT
				EndIf
			Next nX
			If nQtdParc <> nQtdEmAb
				MsgStop("Este Contrato já possiu parcelas baixadas, não é possível estornar","Erro Estorno")
			Else
				While TBSE2->(!EOF())
					AaDd(aParcelas,{{ "E2_FILIAL" 	, xFilial("SE2")    , NIL },;
						{ "E2_PREFIXO"  , TBSE2->E2_PREFIXO , NIL },;
						{ "E2_NUM"      , TBSE2->E2_NUM		, NIL },;
						{ "E2_PARCELA"	, TBSE2->E2_PARCELA	, NIL },;
						{ "E2_TIPO"     , TBSE2->E2_TIPO    , NIL },;
						{ "E2_FORNECE"  , TBSE2->E2_FORNECE , NIL },;
						{ "E2_LOJA"		, TBSE2->E2_LOJA	, NIL },;
						TBSE2->RECNOS})
					cPreEmpE2 := TBSE2->E2_PREFIXO
					cNumEmpE2 := TBSE2->E2_NUM


					TBSE2->(DbSkip())
				EndDo

				lRetLib :=.T.
				cDocumEmp := cPreEmpE2 + cNumEmpE2
				cCodBcoEmp := SZY->ZY_CODBCO
				cCodAgeEmp := SZY->ZY_BCOAGEN
				cCodCtaEmp := SZY->ZY_BCOCONT
				nVlrCruzEmp := SZY->ZY_VLRCONT
				cNaturEmp   := Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_NATUREZ")
				dDtCredEmp 	:= SZY->ZY_DTCRED
				nRecNoSZY   := SZY->(recno())
				If SZW->(FieldPos("ZW_BXVENDO")) > 0
					lBxVendor := Posicione("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_BXVENDO") == "1"
				Else
					lBxVendor := .F.
				EndIf
				IIF(!lMovBco,lMovBco := lTemMovBco,)
				IF lTemMovBco .And. Empty(Alltrim(DtoS(dDtCredEmp)))
					//MsgStop("Modalidade Possui movimentação bancária e a data do crédito não está preenchida","Erro Data De Crédito")
					dDtCredEmp := DDataBase
				EndIf
			EndIf
		Else
			MsgStop("O Status do Contrato não permite Estorno/Exclusão das parcelas geradas.","Erro Estorno")
			lRetLib := .F.
		EndIf
	Else
		MsgStop("O Contrato já foi liberado para o financeiro","Erro Liberação.")
	Endif


	If Len(aParcelas) > 0 .And. nOpcLib > 0
		lRetLib := ADGGERAFIN(aParcelas,nOpcLib,lMovBco,lBxVendor,nRecNoSZY)
		If lRetLib
			aAreaSZY := SZY->(GetArea())
			If SZY->ZY_CODSEQ + SZY->ZY_REVISAO == cNumContr + cRevContr
				RecLock("SZY",.F.)
				SZY->ZY_STATFIN  := IIF(nOpcLib==5,"0","1") //Liberado para o Financeiro
			Else
				SZY->(DbSeek(xFilial("SZY") + cNumContr + cRevContr))
				RecLock("SZY",.F.)
				SZY->ZY_STATFIN  :=  IIF(nOpcLib==5,"0","1") //Liberado para o Financeiro
			EndIf
			SZY->(MsUnlock())
			RestArea(aAreaSZY)
		Else
			MsgStop("Ecorreram erros ao processar a requisição.","Erro")
		EndIf
	Else
		MsgStop("Não Existem parcelas a ser " + iif(nOpcLib==3,"gerada",iif(nOpcLib==4,"alterada","excluida")) + " para o contrato selecionado.","Erro Liberação")
		lRetLib := .F.
	EndIf

	If Select("TBSE2") > 0
		TBSE2->(DbCloseArea())
	EndIf
Return lRetLib




STATIC FUNCTION ADGGERAFIN(aParcelas,nOpcg,lMovBco,lBxVendor,nRecNoSZY)
	LOCAL aArray := {}
	Local lRet	 := .F.
	Local lDisarm := .F.
	Local aAreaSe2 := SE2->(GetArea())
	Local nP := 0
	Local nR := 0

	Default lMovBco := .F.
	Default lBxVendor := .F.
	Default nRecNoSZY := 0
	Begin Transaction
		For nP := 1 to Len(aParcelas)
			if nOpcg == 3
				aArray := aParcelas[nP]
				//Se for finame Então baixa o título da nota fiscal como FIN - Especifico STR
				If lBxVendor .And. nP == 1 .And. nRecNoSZY > 0
					SZY->(DbGoTo(nRecNoSZY))
					cQryBxFin := "SELECT E2_FILIAL,R_E_C_N_O_ RECNOSE2 FROM " + RetSqlname("SE2") + " SE2 "
					cQryBxFin += " WHERE SE2.D_E_L_E_T_ <> '*'  AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
					cQryBxFin += " AND SE2.E2_NUM = '" + SZY->ZY_NUMNFE +  "' "
					cQryBxFin += " AND SE2.E2_PREFIXO = '" + SZY->ZY_SERNFE  + "' "
					cQryBxFin += " AND SE2.E2_FORNECE ='" + SZY->ZY_CODFORN + "' "
					cQryBxFin += " AND SE2.E2_LOJA = '" + SZY->ZY_LOJFORN + "' "
					cQryBxFin += " AND SE2.E2_SALDO = SE2.E2_VALOR "
					cQryBxFin += " AND SE2.E2_VALOR = '" + Alltrim(STR(SZY->ZY_VLRCONT))+ "' "

					If Select("TBXF") > 0
						TBXF->(DbCloseArea())
					EndIf

					TCQUERY cQryBxFin NEW ALIAS "TBXF"
					If TBXF->(!EOF())
						SE2->(DbGoTo(TBXF->RECNOSE2))
						IF SE2->(FieldPos("E2_XNUMCTR")) > 0
							RecLock("SE2",.F.)
							SE2->E2_XNUMCTR := Alltrim(SZY->ZY_CODCONT)
							SE2->(MsUnlock())
						Endif
						_aCabec := {}
						nTotAbat		:= SumAbatPag( SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_FORNECE, SE2->E2_MOEDA, "S", dDataBase, SE2->E2_LOJA )
						Aadd(_aCabec, {"E2_PREFIXO" 	, SE2->E2_PREFIXO	, Nil})
						Aadd(_aCabec, {"E2_NUM"		 	, SE2->E2_NUM		, Nil})
						Aadd(_aCabec, {"E2_PARCELA" 	, SE2->E2_PARCELA	, Nil})
						Aadd(_aCabec, {"E2_TIPO" 		, SE2->E2_TIPO		, Nil})
						Aadd(_aCabec, {"E2_FORNECE"		, SE2->E2_FORNECE	, Nil})
						Aadd(_aCabec, {"E2_LOJA"   		, SE2->E2_LOJA 		, Nil})
						Aadd(_aCabec, {"AUTMOTBX" 		, "FIN"	  			, Nil})
						AADD(_aCabec, {"AUTDESCONT"   , 0                  	, Nil})
						AADD(_aCabec, {"AUTMULTA"     , 0                  	, Nil})
						AADD(_aCabec, {"AUTJUROS"     , 0                  	, Nil})
						Aadd(_aCabec, {"AUTVLRPG"		, SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-nTotAbat , nil})
						AADD(_aCabec, {"AUTVLRME"     , 0                  	, Nil})
						Aadd(_aCabec, {"AUTDTBAIXA" 	, dDataBase			, Nil})
						Aadd(_aCabec, {"AUTDTCREDITO"	, dDataBase			, Nil})
						Aadd(_aCabec, {"AUTHIST"		, 'Bxa.Automatica Vendor '+SE2->E2_NUM , Nil})
						//Aadd(aTitulo, {"AUTVLRPG"  	, SE2->E2_SALDO     	, Nil})
						//lMsErroAuto := .F.
						MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,_aCabec,3,,,.F.,.F.) //3 para baixar ou 5 para cancelar a baixa.
						IF lMsErroAuto
							lRet := .F.
							Exit
							//DisarmTransaction()
							//Exit

						Else
							lRet := .T.
						EndIf
					Else
						MsgStop("Contrato Finame com baixa de vendor, porém não foi possível encontrar o título da nota fiscal, verifique!","Erro Baixa Vendor")
						lRet := .F.
						Exit
					EndIF
					If Select("TBXF") > 0
						TBXF->(DbCloseArea())
					EndIf
				ElseIf lBxVendor .And.  nRecNoSZY == 0
					MsgStop("Contrato Finame com baixa de vendor, porém não foi possível encontrar o título da nota fiscal, verifique!","Erro Baixa Vendor")
					lRet := .F.
					Exit
				EndIf
			Else
				//Se for finame Então baixa o título da nota fiscal como FIN - Especifico STR
				If lBxVendor .And. nP == 1 .And. nRecNoSZY > 0
					SZY->(DbGoTo(nRecNoSZY))
					cQryBxFin := "SELECT E2_FILIAL,R_E_C_N_O_ RECNOSE2 FROM " + RetSqlname("SE2") + " SE2 "
					cQryBxFin += " WHERE SE2.D_E_L_E_T_ <> '*'  AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
					cQryBxFin += " AND SE2.E2_NUM = '" + SZY->ZY_NUMNFE +  "' "
					cQryBxFin += " AND SE2.E2_PREFIXO = '" + SZY->ZY_SERNFE  + "' "
					cQryBxFin += " AND SE2.E2_FORNECE ='" + SZY->ZY_CODFORN + "' "
					cQryBxFin += " AND SE2.E2_LOJA = '" + SZY->ZY_LOJFORN + "' "
					cQryBxFin += " AND SE2.E2_BAIXA <> ''
					cQryBxFin += " AND SE2.E2_SALDO = 0 "
					cQryBxFin += " AND SE2.E2_VALOR = '" + Alltrim(STR(SZY->ZY_VLRCONT))+ "' "

					If Select("TBXF") > 0
						TBXF->(DbCloseArea())
					EndIf

					TCQUERY cQryBxFin NEW ALIAS "TBXF"
					If TBXF->(!EOF())
						SE2->(DbGoTo(TBXF->RECNOSE2))
						_aCabec := {}
						//nTotAbat		:= SumAbatPag( SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_FORNECE, SE2->E2_MOEDA, "S", dDataBase, SE2->E2_LOJA )
						Aadd(_aCabec, {"E2_PREFIXO" 	, SE2->E2_PREFIXO	, Nil})
						Aadd(_aCabec, {"E2_NUM"		 	, SE2->E2_NUM		, Nil})
						Aadd(_aCabec, {"E2_PARCELA" 	, SE2->E2_PARCELA	, Nil})
						Aadd(_aCabec, {"E2_TIPO" 		, SE2->E2_TIPO		, Nil})
						Aadd(_aCabec, {"E2_FORNECE"		, SE2->E2_FORNECE	, Nil})
						Aadd(_aCabec, {"E2_LOJA"   		, SE2->E2_LOJA 		, Nil})
						//Aadd(_aCabec, {"AUTMOTBX" 		, "FIN"	  			, Nil})
						//AADD(_aCabec, {"AUTDESCONT"   , 0                  	, Nil})
						//AADD(_aCabec, {"AUTMULTA"     , 0                  	, Nil})
						//AADD(_aCabec, {"AUTJUROS"     , 0                  	, Nil})
						//Aadd(_aCabec, {"AUTVLRPG"		, SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-nTotAbat , nil})
						//AADD(_aCabec, {"AUTVLRME"     , 0                  	, Nil})
						//Aadd(_aCabec, {"AUTDTBAIXA" 	, dDataBase			, Nil})
						//Aadd(_aCabec, {"AUTDTCREDITO"	, dDataBase			, Nil})
						//Aadd(_aCabec, {"AUTHIST"		, 'Bxa.Automatica Vendor '+SE2->E2_NUM , Nil})
						//Aadd(aTitulo, {"AUTVLRPG"  	, SE2->E2_SALDO     	, Nil})
						//lMsErroAuto := .F.
						MSExecAuto({| a,b,c,d,e,f | FINA080(a,b,c,d,e,f)} ,_aCabec,5,,,.F.,.F.) //3 para baixar ou 5 para cancelar a baixa.
						IF lMsErroAuto
							lRet := .F.
							DisarmTransaction()
							lDisarm := .T.
							Exit

						Else
							lRet := .T.
						EndIf
					Else
						MsgStop("Contrato Finame com baixa de vendor, porém não foi possível encontrar o título da nota fiscal, verifique!","Erro Baixa Vendor")
						lRet := .F.
						Exit
					EndIF
					If Select("TBXF") > 0
						TBXF->(DbCloseArea())
					EndIf
				ElseIf lBxVendor .And.  nRecNoSZY == 0
					MsgStop("Contrato Finame com baixa de vendor, porém não foi possível encontrar o título da nota fiscal, verifique!","Erro Baixa Vendor")
					lRet := .F.
					Exit
				EndIf
				//Desconsiderar a última posição do Arra pois é o recno.
				aArray := {}
				For nR := 1 To Len(aParcelas[nP]) - 1
					AaDd(aArray,aParcelas[nP][nR])
				Next nR

				nRecExc := aParcelas[nP][Len(aParcelas[nP])]
				DbSelectArea("SE2")
				SE2->(DbGoTop())
				SE2->(DbGoTo(nRecExc))
			EndIf
			//lMsErroAuto := .F.
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, nOpcg)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		Next nP
		If lMsErroAuto
			MostraErro()
			lRet := .F.
			DisarmTransaction()
			lDisarm := .T.
		Else
			If nOpcg == 3 .or. nOpcg == 5
				if lMovBco
					lRet := ADGFINMOVBCO(nOpcg,lMovBco,cDocumEmp,cCodBcoEmp,cCodAgeEmp,cCodCtaEmp,nVlrCruzEmp,cNaturEmp,dDtCredEmp)
				Else
					IF !lMsErroAuto
						lRet := .T.
					Else
						lRet := .F.
					EndIf
				EndIf
			Else
				If !lMsErroAuto
					lRet := .T.
				Else
					lRet := .F.
				EndIf
			EndIf
			If !lRet .And. lMovBco
				MsgStop("Erro ao incluir a movimentação financeira do Contrato","Erro Mvmto.Bancário")
				DisarmTransaction()
				lDisarm := .T.
			ElseIf !lRet .And. lMovBco
				IF !lDisarm
					DisarmTransaction()
				EndIf
			EndIf
		Endif
	End Transaction

	IIF(lRet,MsgAlert("Títulos " + IIf(nOpcg==3,"incluídos",IIF(nOpcg==4,"alterados","excluídos")) + " com sucesso!", ""),)
	RestArea(aAreaSE2)
Return lRet

Static Function ADGFINMOVBCO(nOpc,lMovBco,cDocumEmp,cCodBcoEmp,cCodAgeEmp,cCodCtaEmp,nVlrCruzEmp,cNaturEmp,dDtCredEmp)
	Local lRet := .F.
	Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
	Local lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
	Local nCtbEhOnLine := 0
	Local cHistorico  := ""

	Default nOpc := 0
	Default lMovBco := .F.
	Default cCodBcoEMP := ""
	Default cCodAgeEMP := ""
	Default cCodCtaEMP := ""
	Default cNaturEmp  := ""
	Default cDocumEmp  := ""
	Default nVlrCruzEmp := 0
	Default dDtCredEmp	:= CTOD("  /  /  ")

	IF lMovBco .And. Empty(Alltrim(DtoS(dDtCredEmp)))
		//MsgStop("Modalidade Possui movimentação bancária e a data do crédito não está preenchida","Erro Data De Crédito")
		dDtCredEmp := DDataBase
	EndIf

	If lMovBco .And. !Empty(cDocumEmp) .And. nVlrCruzEmp > 0

		If nOpc == 3 //Inclusão
			cHistorico := "Inclusão Emprestimo" + cDocumEmp
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gera movimentacao bancaria - Aplicacao                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Reclock("SE5",.T.)
			SE5->E5_FILIAL  := cFilial
			SE5->E5_BANCO   := cCodBcoEmp
			SE5->E5_DATA    := dDtCredEmp
			SE5->E5_CONTA   := cCodCtaEmp
			SE5->E5_AGENCIA := cCodAgeEmp
			SE5->E5_VALOR   := nVlrCruzEmp
			SE5->E5_VLMOED2 := xMoeda(SE5->E5_VALOR,1,1)
			SE5->E5_RECPAG  := "R"
			SE5->E5_TIPODOC := "EP"
			SE5->E5_HISTOR  := cHistorico
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_MOEDA	 := "01" //PADL(nBcoMoeda,TamSX3("CTO_MOEDA")[1],"0")
			SE5->E5_FILORIG := cFilial
			If ! lUsaFlag .and. (nCtbEhOnLine == 1 )
				SE5-> E5_LA      := "S"
			Endif
			SE5->E5_DOCUMEN := cDocumEmp
			SE5->E5_NATUREZ := cNaturEmp

			AtuSalBco(;
				SE5->E5_BANCO,;
				SE5->E5_AGENCIA,;
				SE5->E5_CONTA,;
				SE5->E5_DATA,;
				SE5->E5_VALOR,;
				Iif( SE5->E5_RECPAG=="R", "+", "-");
				)
			SE5->( MSUNLOCK() )

			If lAtuSldNat
				/*
				 * Atualiza os saldos do fluxo de caixa por natureza financeira - AtuSldNat()
				 */
				AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, SE5->E5_MOEDA, "3", "R", nVlrCruzEmp, 0, "+",,FunName(),"SE5", SE5->(Recno()),0)
			EndIf
			lRet := .T.

		Else
			cHistorico := "Exclusão Emprestimo" + cDocumEmp
			//Exclusão
			//Begin Transaction
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Estorna Movimento Bancario                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SE5",.T.)
			SE5->E5_FILIAL  := cFilial
			SE5->E5_BANCO   := cCodBcoEMP
			SE5->E5_AGENCIA := cCodAgeEMP
			SE5->E5_CONTA   := cCodCtaEMP
			SE5->E5_DATA    := dDataBase
			SE5->E5_VALOR   := nVlrCruzEmp
			SE5->E5_VLMOED2 := xMoeda(SE5->E5_VALOR,1,1)
			SE5->E5_RECPAG  := "P"
			SE5->E5_TIPODOC := "EP"
			SE5->E5_HISTOR  := cHistorico
			SE5->E5_DTDIGIT := SE5->E5_DATA
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_MOEDA	 := "01" //PADL(SEH->EH_MOEDA,TamSX3("CTO_MOEDA")[1],"0")
			SE5->E5_FILORIG := cFilial
			If lUsaFlag .and. (nCtbEhOnLine == 1 )
				SE5-> E5_LA := "S"
			Endif
			SE5->E5_DOCUMEN := cDocumEmp
			SE5->E5_NATUREZ := cNaturEmp
			AtuSalBco(;
				SE5->E5_BANCO,;
				SE5->E5_AGENCIA,;
				SE5->E5_CONTA,;
				SE5->E5_DATA,;
				SE5->E5_VALOR,;
				IIf(SE5->E5_RECPAG == "R", "+", "-");
				)

			SE5->( MSUNLOCK() )

				/*
				 * Atualiza os saldos do fluxo de caixa por natureza financeira - AtuSldNat()
				 */
			If lAtuSldNat
				AtuSldNat(SE5->E5_NATUREZ, SE5->E5_DATA, SE5->E5_MOEDA, "3", "P", nVlrCruzEmp, 0, "-",,FunName(),"SE5", SE5->(Recno()),0)
			EndIf
			lRet := .T.
			//End Transaction


		EndIf
	EndIf

Return lRet

User Function ADGBXTIT(nOpcBx)
	Local aAreaSE2 := SE2->(GetArea())
	Local aAreaSZZ := SZZ->(GetArea())
	Local cQry1		:= ""
	Local cDtCorteEndv := SuperGetMV("DG_DTCENDV",.f.,"20150601")

	Default nOpcBx := 3

	cFilCtr := cFilAnt
	cFilTab := xFilial("SZZ")

	cQry1 := " SELECT R_E_C_N_O_ RECNOSZZ "
	cQry1 += " FROM " + RetSqlName("SZZ") + " SZZ "
	cQry1 += " WHERE SZZ.D_E_L_E_T_ <> '*' AND SZZ.ZZ_FILIAL = '" +xFilial("SZZ") +  "' "
	cQry1 += " AND SZZ.ZZ_NPARSE2 = '" + SE2->E2_PARCELA +"' AND LEFT(SZZ.ZZ_DTVENC,6) = " + Left(DTOS(SE2->E2_VENCREA),6)
	cQry1 += " AND (SZZ.ZZ_CODSEQ  = '" + SE2->E2_NUM + "' OR  SZZ.ZZ_CODSEQ  = '" + SE2->E2_XRFENDV + "') "
	cQry1 += " AND ZZ_DTVENC > '" + cDtCorteEndv + "' " //Dt Corte Rotina Endividamento.

	If Select("TSZZ") > 0
		TSZZ->(DbCloseArea())
	EndIf
	TCQUERY cQry1 NEW ALIAS "TSZZ"
	If TSZZ->(!EOF())
		DbSelectArea("SZZ")
		SZZ->(DBSetOrder(1))
		SZZ->(DbGoTo(TSZZ->RECNOSZZ))

		If nOpcBx == 3
			nVjurVar :=  SE5->E5_VALOR - (SE2->E2_VALOR + SE2->E2_ACRESC)
			If RecLock("SZZ",.F.)
				SZZ->ZZ_DTPGPAR := SE2->E2_BAIXA
				SZZ->ZZ_VRPGPAR := SE5->E5_VALOR //SE2->E2_VALOR - SE2->E2_SALDO
				If nVjurVar > 0
					SZZ->ZZ_VJURVAR := nVjurVar
					SZZ->ZZ_PARAPAG := SE5->E5_VALOR
				EndIf
				SZZ->ZZ_STATPAR := IIF(SE2->E2_SALDO > 0 ,"1","2")
				SZZ->(MsUnLock())
			EndIf
		Else

			If RecLock("SZZ",.F.)
				SZZ->ZZ_DTPGPAR := CTOD("  /  /  ")
				SZZ->ZZ_VRPGPAR := 0 //SE5->E5_VALOR //SE2->E2_VALOR - SE2->E2_SALDO
				SZZ->ZZ_STATPAR := IIF(SE2->E2_VALOR == SE2->E2_SALDO ,"0","1")
				SZZ->(MsUnLock())
			EndIf
		EndIf
	EndIf
	RestArea(aAreaSE2)
	RestArea(aAreaSZZ)

Return .T.


User Function AENDVSLD(cCodContr,cRefEndv,cParcela,dDatBaixa)
	Local nVlrSaldo := 0
	Default cCodContr := ""
	Default cRefEndv := ""
	Default cParcela := ""
	Default dDatBaixa := CTOD("  /  /  ")

	cQry1 := " SELECT ZZ_SLDDEVP "
	cQry1 += " FROM " + RetSqlName("SZZ") + " SZZ "
	cQry1 += " WHERE SZZ.D_E_L_E_T_ <> '*' AND SZZ.ZZ_FILIAL = '" +xFilial("SZZ") +  "' "
	cQry1 += " AND SZZ.ZZ_NPARSE2 = '" + SE2->E2_PARCELA +"' AND LEFT(SZZ.ZZ_DTVENC,6) = " + Left(DTOS(SE2->E2_VENCREA),6)
	cQry1 += " AND (SZZ.ZZ_CODSEQ  = '" + SE2->E2_NUM + "' OR  SZZ.ZZ_CODSEQ  = '" + SE2->E2_XRFENDV + "') "
//cQry1 += " AND ZZ_DTVENC > '" + cDtCorteEndv + "' " //Dt Corte Rotina Endividamento.

	If Select("TSZZ") > 0
		TSZZ->(DbCloseArea())
	EndIf
	TCQUERY cQry1 NEW ALIAS "TSZZ"
	If TSZZ->(!EOF())
		nVlrSaldo := TSZZ->ZZ_SLDDEVP
	EndIf

Return nVlrSaldo
