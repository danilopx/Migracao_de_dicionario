#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//---------------------------------------------------------------------------------------------------------
// Ponto de entrada                                   Autor: Carlos Alday Torres        Data: 15/12/2010
// Estornar lote das etiquetas apontadas, desta forma permite-se que seja apontada novamente o lote
//---------------------------------------------------------------------------------------------------------
/*
|---------------------------------------------------------------------------------
|	Incluido variavel array aAreaAtual para guardar a Area Atual que esta sendo 
| utilizada antes de realizar qualquer processo no PE.
|	Edson Hornberger - 24/06/2014
|---------------------------------------------------------------------------------
*/
User Function MT250EST()
Local _cQuery  := ""
Local aAreaAtual := GetArea()
Local xSb1Alias	:= SB1->(GetArea())

//MsgAlert("Na rotina " + M->D3_OP,"SD3250I")
SB1->(DbSetOrder(1))
SB1->(DbSeek( xFilial("SB1") +  Alltrim(SD3->D3_COD) ))

If SB1->B1_RASTRO = 'S'
	//
	// Quando controla RASTRO deve apontar para o campo PADRÃO do LOTE
	//	
	_cQuery := "UPDATE TOP("+Alltrim( Str(SD3->D3_QUANT) )+") " + RetSqlName("ZA4") + " " 
	_cQuery += "	SET ZA4_APONTA = 'N' "
	_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
	_cQuery += "   AND D_E_L_E_T_ != '*' "    
	_cQuery += "   AND ZA4_COD = '" + Alltrim(SD3->D3_COD) + "' "
	_cQuery += "   AND ZA4_NLOTE = '" + Alltrim(SD3->D3_LOTECTL) + "' "
	_cQuery += "   AND ZA4_NUMOP = '" + Substr(SD3->D3_OP,1,6) + "' "  
	_cQuery += "   AND RIGHT(ZA4_DTFAB,4) = '" + Strzero(Year(SD3->D3_EMISSAO),4) + "'" // ZA4_DTFAB campo tipo caracter formato de gravacao 04/10/2010
	_cQuery += "	AND ZA4_APONTA = 'S' "
		
	TCSQLExec( _cQuery )    

Else
	_cQuery := "UPDATE TOP("+Alltrim( Str(SD3->D3_QUANT) )+") " + RetSqlName("ZA4") + " " 
	_cQuery += "	SET ZA4_APONTA = 'N' "
	_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
	_cQuery += "   AND D_E_L_E_T_ != '*' "    
	_cQuery += "   AND ZA4_COD = '" + Alltrim(SD3->D3_COD) + "' "
	_cQuery += "   AND ZA4_NLOTE = '" + Alltrim(SD3->D3_LOTECTL) + "' "
	_cQuery += "   AND ZA4_NUMOP = '" + Substr(SD3->D3_OP,1,6) + "' "  
	_cQuery += "   AND RIGHT(ZA4_DTFAB,4) = '" + Strzero(Year(SD3->D3_EMISSAO),4) + "'" // ZA4_DTFAB campo tipo caracter formato de gravacao 04/10/2010
	_cQuery += "	AND ZA4_APONTA = 'S' "
		
	TCSQLExec( _cQuery )    
EndIf

RestArea(xSb1Alias)
RestArea(aAreaAtual)

Return .T.