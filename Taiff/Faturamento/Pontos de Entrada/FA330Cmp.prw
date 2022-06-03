#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//----------------------------------------------------------------------------------------------------------------
// PROGRAMA: FA330Cmp	                                     AUTOR: CARLOS TORRES                 DATA: 25/08/2011
// DESCRICAO: PE para não gerar a comissao da NCC conforme campo regulamentador da natureza financeira SED
//----------------------------------------------------------------------------------------------------------------
User Function FA330Cmp
	Local xSedAlias	:= SED->(GetArea())
	Local xSe1Alias	:= SE1->(GetArea())
	Local __cPagaNCC	:= ""
	Local __cNaoPagNCC:= ""
	Local _nLoop := 0

	If Type("aTitulos") != "U"
		//
		// Os titulos marcados para compensação são armazenados na matriz aTitulos
		//
		SE1->(DbSetOrder(1))
		For _nLoop := 1 to Len( aTitulos )
			If ValType(aTitulos[ _nLoop,8 ]) = "L"
				If aTitulos[ _nLoop,8 ]
					// E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					__cChave := xFilial( "SE1" )
					__cChave += aTitulos[_nLoop,1] // Prefixo
					__cChave += aTitulos[_nLoop,2] // Numero titulo
					__cChave += aTitulos[_nLoop,3] // Parcela
					__cChave += aTitulos[_nLoop,4] // Tipo

					If SE1->(DbSeek( __cChave ))
						SED->(DbSeek( xFilial("SED") + Alltrim( SE1->E1_NATUREZ ) ))
						If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .and. SE1->E1_TIPO='NCC'
							__cNaoPagNCC := aTitulos[_nLoop,1] // Prefixo
							__cNaoPagNCC += aTitulos[_nLoop,2] // Numero titulo
							__cNaoPagNCC += aTitulos[_nLoop,3] // Parcela
							__cNaoPagNCC += aTitulos[_nLoop,4] // Tipo
							__cNaoPagNCC += " natureza: " + SE1->E1_NATUREZ
						Else
							__cPagaNCC := aTitulos[_nLoop,1] // Prefixo
							__cPagaNCC += aTitulos[_nLoop,2] // Numero titulo
							__cPagaNCC += aTitulos[_nLoop,3] // Parcela
							__cPagaNCC += aTitulos[_nLoop,4] // Tipo
							__cPagaNCC += " natureza: " + SE1->E1_NATUREZ
						EndIf
					EndIf
				EndIf
			EndIf
			If ValType(aTitulos[ _nLoop,11 ]) = "L"
				If aTitulos[ _nLoop,11 ]
					__cChave := xFilial( "SE1" )
					__cChave += aTitulos[_nLoop,7] // Prefixo + Numero titulo + Parcela
					__cChave += "NCC"

					If SE1->(DbSeek( __cChave ))
						SED->(DbSeek( xFilial("SED") + Alltrim( SE1->E1_NATUREZ ) ))
						If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .and. SE1->E1_TIPO='NCC'
							__cNaoPagNCC := aTitulos[_nLoop,7]
							__cNaoPagNCC += " natureza: " + SE1->E1_NATUREZ
						Else
							__cPagaNCC := aTitulos[_nLoop,7]
							__cPagaNCC += " natureza: " + SE1->E1_NATUREZ
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		If !Empty( __cPagaNCC ) .and. !Empty(__cNaoPagNCC )
			Aviso("Titulos com Naturezas incompatíveis", "Selecione titulos com naturezas comuns, neste caso para pagamento de comissão. Titulos " + __cNaoPagNCC + " e " + __cPagaNCC ,	{"Ok"}, 	3)
			For _nLoop := 1 to Len( aTitulos )
				If ValType(aTitulos[ _nLoop,8 ]) = "L"
					aTitulos[ _nLoop,8 ] := .F.
				EndIf
			Next
		EndIf
	EndIf
	RestArea(xSe1Alias)
	RestArea(xSedAlias)
Return NIL