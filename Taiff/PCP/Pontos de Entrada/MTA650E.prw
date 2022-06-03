#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//----------------------------------------------------------------------------------------------------------------
// Função..: Ponto de entrada
// Objetivo: Atualiza campo na tabela de etiquetas que a OP foi excluida, desta forma os usuarios do modulo de
//           etiquetas fica sabendo que o PCP excluiu a OP.
// Autor...: Carlos Alday Torres                                                                 Data: 05/10/2010
//----------------------------------------------------------------------------------------------------------------
User Function MTA650E() 
	
	Local _cQuery  := ""
	Local lRetorno := .T.
	Local _xAlias	:= GetArea()
	Local _cTime	:= TIME()
	
	//QUANDO FOR OP PREVISTA NAO FAZ A VALIDACAO
	If M->C2_TPOP = "P"
		Return(lRetorno)
	EndIf	
	//valida se pode excluir uma op de beneficiamento
	cOp := M->C2_NUM+M->C2_ITEM+M->C2_SEQUEN
	
	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial()+cOp)
	While !Eof() .And. AllTrim(SD4->D4_OP) == cOp
		
		If SD4->D4__QTBNFC > 0 .Or. SD4->D4__QTPCBN >0
			lRetorno := .F.
		EndIf
		dbSkip()
	End
	
	If 	!lRetorno
		MsgStop("Esta é uma OP de beneficiamento e já teve material enviado ao fornecedor ou um pedido de compras colocado, a Exclusao de empenho não será permitida!","MTA650E")
	EndIf
	
	
	
	
	_cQuery := "SELECT TOP(1) ZA4_NLOTE "
	_cQuery += "  FROM " + RetSqlName("ZA4") + " "
	_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
	_cQuery += "   AND D_E_L_E_T_ != '*' "
	_cQuery += "   AND ZA4_COD = '" + SC2->C2_PRODUTO + "' "
	_cQuery += "   AND ZA4_NUMOP = '" + SC2->C2_NUM + "' "
	_cQuery += "   AND ZA4_OPITEM = '" + SC2->C2_ITEM + "' "
	_cQuery += "   AND ZA4_OPSEQ = '" + SC2->C2_SEQUEN + "' "
	_cQuery += "   AND IsNull(ZA4_DTIMP,'') != '' "
	TcQuery _cQuery NEW ALIAS ("APP")
	
	//
	// Validando a impressao das etiquetas da OP
	//
	If .NOT. (APP->(Eof()) .and. APP->(Bof()))
		APP->(DbCloseArea())
		//
		// As etiquetas são marcadas com a mensagem de "OP excluida", mas não as exclue, quem deve
		// excluir é a central de impressao de etiquetas
		//
		_cQuery := "UPDATE " + RetSqlName("ZA4") + " "
		_cQuery += " 	SET ZA4_DESTIN = 'OP excluida!' "
		_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
		_cQuery += "   AND D_E_L_E_T_ != '*' "
		_cQuery += "   AND ZA4_COD = '" + SC2->C2_PRODUTO + "' "
		_cQuery += "   AND ZA4_NUMOP = '" + SC2->C2_NUM + "' "
		_cQuery += "   AND ZA4_OPITEM = '" + SC2->C2_ITEM + "' "
		_cQuery += "   AND ZA4_OPSEQ = '" + SC2->C2_SEQUEN + "' "
		TCSQLExec( _cQuery )
		
		Aviso("Etiquetas já impressas para OP: " + SC2->(C2_NUM + C2_ITEM + C2_SEQUEN) +"!!!", "Comunique à central de impressão para recolher as etiquetas impressas.",	{"Ok"}, 	3)
		
	Else
		APP->(DbCloseArea())
		//
		// Exclue as etiquetas da OP selecionada
		//
		_cQuery := "UPDATE " + RetSqlName("ZA4") + " "
		_cQuery += " 	SET D_E_L_E_T_ = '*' ,"
		_cQuery += " 	    ZA4_DESTIN = '" + Dtos(dDataBase) + " delet" + "', "
		_cQuery += "  	 	 ZA4_PRTUSE = '" + Alltrim(cUSERNAME) + "',"
		_cQuery += " 		 ZA4_PRTHOR = '" + Substr(_cTime,1,5) + "' "
		_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
		_cQuery += "   AND D_E_L_E_T_ != '*' "
		_cQuery += "   AND ZA4_COD = '" + SC2->C2_PRODUTO + "' "
		_cQuery += "   AND ZA4_NUMOP = '" + SC2->C2_NUM + "' "
		_cQuery += "   AND ZA4_OPITEM = '" + SC2->C2_ITEM + "' "
		_cQuery += "   AND ZA4_OPSEQ = '" + SC2->C2_SEQUEN + "' "
		TCSQLExec( _cQuery )
	EndIf
	
	lRetorno := .T.
	
	//MJL 7-02-2011 Serve para impedir que OP's transf. para a fabrica sejam excluidas.
	If SM0->M0_CODIGO == "01" .and. lRetorno
		If SC2->C2_SEQUEN == "001"
			cQuery := "SELECT COUNT(*) AS TOTREG"
			cQuery += " FROM " + RetSqlName("SD3") + " SD3"
			cQuery += " WHERE D3_FILIAL = '" + xFilial("SD3") + "'"
			cQuery += "   AND SUBSTRING(D3_OPTRANS, 1, 8) = '" + SC2->(C2_NUM + C2_ITEM) + "'"
			cQuery += "   AND D3_ESTORNO <> 'S'"
			cQuery += "   AND SD3.D_E_L_E_T_ <> '*'"
			cQuery := ChangeQuery(cQuery)
			DbUseArea(.T., "TOPCONN", TCGenQry(,, cQuery), "TRB1", .F., .F. )
			TRB1->(DbGoTop())
			
			If TRB1->TOTREG >= 1
				If !l650Auto
					Aviso("Ja transferida!!!", "A ordem de producao: " + SC2->(C2_NUM + C2_ITEM + C2_SEQUEN) + ", ja foi movimentada. Favor providenciar o estorno dos movimento.", {"Ok"}, 3)
				EndIf
				lRetorno := .F.
			EndIf
			TRB1->(DbCloseArea())
		EndIf
	EndIf

	
	RestArea(_xAlias)
	
Return (lRetorno)
