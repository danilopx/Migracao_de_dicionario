#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: SD3250I                                       AUTOR: CARLOS TORRES                 DATA: 17/09/2010
// DESCRICAO: PE executado após a atualização de tabelas no apontamento de produção
//--------------------------------------------------------------------------------------------------------------
User Function SD3250I()
	Local _cQuery  := ""
	Local xSb1Alias	:= SB1->(GetArea())
	Local cAliasSD3
	
	//MsgAlert("Na rotina " + M->D3_OP,"SD3250I")
	SB1->(DbSetOrder(1))
	If IsInCallStack('MATA681') .Or. IsInCallStack('U_ACDAT002')
		SB1->(DbSeek( xFilial("SB1") +  Alltrim(SD3->D3_COD) ))
		cAliasSD3 := 'SD3'
	Else
		SB1->(DbSeek( xFilial("SB1") +  Alltrim(M->D3_COD) ))
		cAliasSD3 := 'M'
	EndIf
	If SB1->(Found()) .And. SB1->B1_RASTRO = 'S'
		//
		// Quando controla RASTRO deve apontar para o campo PADRÃO do LOTE
		//
		_cQuery := "UPDATE TOP("+Alltrim( Str(&(cAliasSD3+'->D3_QUANT')) )+") " + RetSqlName("ZA4") + " "
		_cQuery += "	SET ZA4_APONTA = 'S' "
		_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
		_cQuery += "   AND D_E_L_E_T_ != '*' "
		_cQuery += "   AND ZA4_COD = '" + Alltrim(&(cAliasSD3+'->D3_COD')) + "' "
		_cQuery += "   AND ZA4_NLOTE = '" + Alltrim(&(cAliasSD3+'->D3_LOTECTL')) + "' "
		_cQuery += "   AND ZA4_NUMOP = '" + Substr(&(cAliasSD3+'->D3_OP'),1,6) + "' "
		_cQuery += "   AND RIGHT(ZA4_DTFAB,4) = '" + Strzero(Year(&(cAliasSD3+'->D3_EMISSAO')),4) + "'" // ZA4_DTFAB campo tipo caracter formato de gravacao 04/10/2010
		_cQuery += "	AND (ZA4_APONTA = ' ' OR ZA4_APONTA = 'N' ) "
		
		TCSQLExec( _cQuery )
		
	Else
		If SD3->(FieldPos("D3_LOTEINT")) > 0
			//
			// Quando NÃO controla RASTRO deve apontar para o campo CUSTOMIZADO do LOTE
			//
			_cQuery := "UPDATE TOP("+Alltrim( Str(&(cAliasSD3+'->D3_QUANT')) )+") " + RetSqlName("ZA4") + " "
			_cQuery += "	SET ZA4_APONTA = 'S' "
			_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			_cQuery += "   AND D_E_L_E_T_ != '*' "
			_cQuery += "   AND ZA4_COD = '" + Alltrim(&(cAliasSD3+'->D3_COD')) + "' "
			_cQuery += "   AND ZA4_NLOTE = '" + Alltrim(&(cAliasSD3+'->D3_LOTEINT')) + "' "
			_cQuery += "   AND ZA4_NUMOP = '" + Substr(&(cAliasSD3+'->D3_OP'),1,6) + "' "
			_cQuery += "   AND RIGHT(ZA4_DTFAB,4) = '" + Strzero(Year(&(cAliasSD3+'->D3_EMISSAO')),4) + "'"
			_cQuery += "	AND (ZA4_APONTA = ' ' OR ZA4_APONTA = 'N' ) "
			
			TCSQLExec( _cQuery )
			
		EndIf
	EndIf
	
	RestArea(xSb1Alias)
	
Return NIL
