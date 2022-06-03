#include "rwmake.ch"
#IFNDEF CRLF
	#DEFINE CRLF Chr(13) + Chr(10)
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RM460BNF  º Autor ³ Marcelo Cardoso    º Data ³  08/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao da Amarracao Pedido Normal x Pedido Bonificado   º±±
±±º          ³ na selecao dos Itens de Pedido de Venda a faturar          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function RM460BNF()

	Local _lRet      := .T.
	Local _aPVBon    := {}
	Local _aErrPVBon := {}
	Local _cOldAlias := Alias()
	Local _aOldAlias := GetArea()
	Local _aSC9Alias := SC9->(GetArea())
	Local _aSC5Alias := SC5->(GetArea())
	Local _aLbNotMrk := {}
	Local _lC5ClasPd := AllTrim(GetSx3Cache("C5_CLASPED", "X3_CAMPO")) == "C5_CLASPED"
	Local _lC5PVBon  := AllTrim(GetSx3Cache("C5_X_PVBON", "X3_CAMPO")) == "C5_X_PVBON"
	Local _lC5LiBon  := AllTrim(GetSx3Cache("C5_X_LIBON", "X3_CAMPO")) == "C5_X_LIBON"
	Local _lPosiciona:= .F.
	Local _nCall     := 1
	Local _nIx := 0

	If SM0->M0_CODIGO + SM0->M0_CODFIL $ GetMV("MV_X_BNFIL") 

		Do While !Empty(AllTrim(ProcName(_nCall)))

			If "FWPREEXECUTE" $ Upper(AllTrim(ProcName(_nCall))) .and. "DOCUMENTO DE SAIDA" $ Upper(AllTrim(ProcName(_nCall)))

				_lPosiciona := .T.
				Exit

			EndIf

			_nCall ++

		EndDo

		If _lPosiciona

			Pergunte("MT461A", .F.)

			_cPedDe  := mv_par05
			_cPedAte := mv_par06
			_cCliDe  := mv_par07
			_cCliAte := mv_par08
			_cLojDe  := mv_par09
			_cLojAte := mv_par10
			_cDLbDe  := DToS(mv_par11)
			_cDLbAte := DToS(mv_par12)

			_cQuery := "SELECT * FROM " + RetSQLName("SC9")   + "  "
			_cQuery += "WITH(NOLOCK) "
			_cQuery += "WHERE C9_FILIAL = '" + xFilial("SC9") + "' "
			_cQuery += "AND D_E_L_E_T_ <> '*'  "
			_cQuery += "AND C9_BLEST   <> '10' "
			_cQuery += "AND C9_BLCRED  <> '10' "
			_cQuery += "AND C9_PEDIDO  BETWEEN '" + _cPedDe + "' AND '" + _cPedAte + "' "
			_cQuery += "AND C9_CLIENTE BETWEEN '" + _cCliDe + "' AND '" + _cCliAte + "' "
			_cQuery += "AND C9_LOJA    BETWEEN '" + _cLojDe + "' AND '" + _cLojAte + "' "
			_cQuery += "AND C9_DATALIB BETWEEN '" + _cDLbDe + "' AND '" + _cDLbAte + "' "
			_cQuery += "ORDER BY C9_PEDIDO, C9_ITEM "

			Pergunte("MT460A", .F.)

			_cSC9Area := GetNextAlias()
			DbUseArea(.T., "TOPCONN", TcGenQry(,, _cQuery), _cSC9Area, .T., .T.)
			AEval(SC9->(DBStruct()), { |_e| IIf(_e[2] != "C", TCSetField(_cSC9Area, _e[1], _e[2], _e[3], _e[4]), Nil) } )
			DBSelectArea(_cSC9Area)

		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Manter o DBGoTop, pois o SC9 ja esta filtrado e eh preciso varre-lo por completo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cSC9Area := "SC9"
			DBSelectArea(_cSC9Area)
			DBGoTop()

		EndIf


		While !EOF()

			DBSelectArea(_cSC9Area)

			If SC5->C5_NUM <> (_cSC9Area)->C9_PEDIDO

				DBSelectArea("SC5")
				DBSetOrder(1)
				DBSeek(xFilial() + (_cSC9Area)->C9_PEDIDO)

			EndIf

			If _lPosiciona

				If (_cSC9Area)->R_E_C_N_O_ <> SC9->(Recno())

					DBSelectArea("SC9")
					DBGoTo((_cSC9Area)->R_E_C_N_O_)

				EndIf

			EndIf

			DBSelectArea(_cSC9Area)

			IF (( (_cSC9Area)->C9_OK != PARAMIXB[1] .And. PARAMIXB[2] .AND. !A460AVALIA()) .Or. ( (_cSC9Area)->C9_OK == PARAMIXB[1] .And. !PARAMIXB[2]))


				// Verifica se os campos de Controle de Bonificacao existem
				If _lC5ClasPd .and. _lC5PVBon //.and. Empty(AllTrim(SC5->C5_NUMOLD)) // Liberado para vinculo de pedidos do Portal

					// Verifica se ha algum tratamento de bonificacao
					If  (!Empty(AllTrim(SC5->C5_X_PVBON)) .and. Empty(AllTrim(SC5->C5_NUMOLD)) ) // .or. SC5->C5_CLASPED == "X"

						// Verifica se o numero de Pedido ja foi adicionado a lista de verificacao
						If AScan(_aPVBon,{|x| x[1] == (_cSC9Area)->C9_PEDIDO} ) == 0 // AScan(_aPVBon,{|x| x[1] == (_cSC9Area)->C9_PEDIDO} ) == 0

							AAdd(_aPVBon, {(_cSC9Area)->C9_PEDIDO, SC5->C5_CLASPED, SC5->C5_X_PVBON})

						EndIf

					EndIf

					//Caso o pedido NAO tenha vinculo e seja do Portal
					If Empty(AllTrim(SC5->C5_X_PVBON)) .and. !Empty(AllTrim(SC5->C5_NUMOLD))

						// Verifica se o numero de Pedido ja foi adicionado a lista de verificacao
						If AScan(_aPVBon,{|x| x[1] == (_cSC9Area)->C9_PEDIDO} ) == 0

							//Executo rotina para apurar vinculo do Portal
							//Estrutura do Retorno da Funcao ApuVPP
							//ApuVPP[1] - Tipo VENDA       - Numero do Pedido no Portal
							//ApuVPP[2] - Tipo VENDA       - Numero do Pedido no Protheus
							//ApuVPP[3] - Tipo VENDA       - Numero da Filial do Pedido no Protheus
							//ApuVPP[4] - Tipo BONIFICACAO - Numero do Pedido no Portal
							//ApuVPP[5] - Tipo BONIFICACAO - Numero do Pedido no Protheus
							//ApuVPP[6] - Tipo BONIFICACAO - Numero da Filial do Pedido no Protheus

							_aVinPor := ApuVPP(AllTrim(SC5->C5_NUMOLD))

							//Se o Pedido em questao tiver Vinculo no Portal como VENDA e for da mesma filial, adiciono a Lista
							If AllTrim(SC5->C5_NUMOLD) == _aVinPor[1] .and. SC5->C5_FILIAL == _aVinPor[3] //VENDA

								If !Empty(_aVinPor[5])

									AAdd(_aPVBon, {(_cSC9Area)->C9_PEDIDO, "V", _aVinPor[5] })

								EndIf

							EndIf

							//Se o Pedido em questao tiver Vinculo no Portal como BONIFICACAO e for da mesma filial, adiciono a Lista
							If AllTrim(SC5->C5_NUMOLD) == _aVinPor[4] .and. SC5->C5_FILIAL == _aVinPor[6]//Bonificacao

								If !Empty(_aVinPor[2])

									AAdd(_aPVBon, {(_cSC9Area)->C9_PEDIDO, SC5->C5_CLASPED, _aVinPor[2] })

								EndIf

							EndIf

						EndIf

					Else

						If SC5->C5_CLASPED == "X"

							// Verifica se o numero de Pedido ja foi adicionado a lista de verificacao
							If AScan(_aPVBon,{|x| x[1] == (_cSC9Area)->C9_PEDIDO} ) == 0 // AScan(_aPVBon,{|x| x[1] == (_cSC9Area)->C9_PEDIDO} ) == 0

								AAdd(_aPVBon, {(_cSC9Area)->C9_PEDIDO, SC5->C5_CLASPED, SC5->C5_X_PVBON})

							EndIf

						EndIf

					EndIf

				EndIf

			Else //Trata Itens de Pedido Liberados mas nao marcados

				If AScan(_aLbNotMrk, (_cSC9Area)->C9_PEDIDO) == 0 .and. (_cSC9Area)->C9_BLEST = "  " .and. (_cSC9Area)->C9_BLCRED = "  "

					If SC5->C5_NUM <> (_cSC9Area)->C9_PEDIDO

						DBSelectArea("SC5")
						DBSeek(xFilial() + (_cSC9Area)->C9_PEDIDO)

					EndIf

					If _lC5ClasPd .and. _lC5PVBon

						If SC5->C5_CLASPED == "X" .or. !Empty(AllTrim(SC5->C5_X_PVBON))

							AAdd(_aLbNotMrk, (_cSC9Area)->C9_PEDIDO)

						EndIf

					EndIf

				EndIf

			EndIf

			DBSelectArea(_cSC9Area)
			DBSkip()

		EndDo
		//Next

		If _lPosiciona

			DBSelectArea(_cSC9Area)
			DBCloseArea()

		EndIf


		_aItNotMrk := {}

		For _nIx := 1 To Len(_aPVBon)

			If AScan(_aLbNotMrk, _aPVBon[_nIx][1]) <> 0

				If AScan(_aItNotMrk, _aPVBon[_nIx][1]) == 0

					AAdd(_aItNotMrk, _aPVBon[_nIx][1])

				EndIf

				_lRet := .F.

			EndIf

			If AScan(_aLbNotMrk, _aPVBon[_nIx][3]) <> 0

				If AScan(_aItNotMrk, _aPVBon[_nIx][3]) == 0

					AAdd(_aItNotMrk, _aPVBon[_nIx][3])

				EndIf

				_lRet := .F.

			EndIf

		Next

		For _nIx := 1 To Len(_aPVBon)

			If AScan(_aPVBon,{|x| AllTrim(x[1]) $ AllTrim(_aPVBon[_nIx][3])} ) == 0 .or. Empty(AllTrim(_aPVBon[_nIx][3]))  // Tratamento de vinculos multiplos
//		If AScan(_aPVBon,{|x| x[1] == _aPVBon[_nIx][3]} ) == 0 .or. Empty(AllTrim(_aPVBon[_nIx][3]))     // Conteudo antigo

				//Caso o pedido em questao Nao seja de Venda
				If Upper(_aPVBon[_nIx][2]) <> "V"

					//Se existir o campo de Liberacao de Bonificacao
					If _lC5LiBon

						//Verifica se o campo Liberacao de Bonificacao NAO esta liberado
						If SC5->C5_X_LIBON <> "L"

							//Nao estando liberado, adiciona o Pedido na lista de Bloqueio
							AAdd(_aErrPVBon, {_aPVBon[_nIx][1], _aPVBon[_nIx][2], _aPVBon[_nIx][3]})

							_lRet := .F.

						EndIf

					Else // Caso NAO exista o campo de Liberacao de Bonificacao, adiciona na lista de Bloqueio

						AAdd(_aErrPVBon, {_aPVBon[_nIx][1], _aPVBon[_nIx][2], _aPVBon[_nIx][3]})

						_lRet := .F.

					EndIf

				EndIf

			EndIf

		Next

		If _lRet == .F.

			_cProble := ""
			_cTitulo := "Pedidos Bonificados"

			If Len(_aErrPVBon) > 0

				For _nIx := 1 To Len(_aErrPVBon)

					_cProble += "Pedido " + _aErrPVBon[_nIx][1] + " vinculado ao Pedido " + _aErrPVBon[_nIx][3] + CRLF

				Next

			EndIf

			If Len(_aItNotMrk) > 0

				For _nIx := 1 To Len(_aItNotMrk)

					_cProble += "Pedido " + _aItNotMrk[_nIx] + " com itens liberados e nao selecionados."  + CRLF

				Next

			EndIf

			_cSoluc := "Pedidos vinculados por bonificacao devem estar ambos obrigatoriamente liberados e selecionados para faturamento."

			xMagHelpFis(_cTitulo, _cProble, _cSoluc)

		EndIf

	EndIf

	DBSelectArea("SC9")
	RestArea(_aSC9Alias)

	DBSelectArea("SC5")
	RestArea(_aSC5Alias)

	DBSelectArea(_cOldAlias)
	RestArea(_aOldAlias)

Return _lRet


Static Function ApuVPP(_cNumOld)

	_cAntAlias := Alias()
	_aAntAlias := GetArea()
	_cTam      := AllTrim(Str(TamSX3("C5_NUMOLD")[1]))
	_cPed      := AllTrim(_cNumOld)
	_cNxtAlias := GetNextAlias()

	_cRptQry := " AND D_E_L_E_T_ <> '*' AND C5_FILIAL = '" + xFilial("SC5") + "' "

	_cQuery := ""
	_cQuery += "SELECT "
	_cQuery += "PA.C5_NUMPRE_VENDAS AS VENDA, "
	_cQuery += "( "
	_cQuery += "SELECT C5_NUM "
	_cQuery += "FROM " + RetSQLName("SC5") + " "
	_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_VENDAS AS VARCHAR(" + _cTam + ")) "
	_cQuery += _cRptQry
	_cQuery += ") AS PV_VEN_PRO, "
	_cQuery += "( "
	_cQuery += "SELECT C5_FILIAL "
	_cQuery += "FROM " + RetSQLName("SC5") + " "
	_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_VENDAS AS VARCHAR(" + _cTam + ")) "
	_cQuery += _cRptQry
	_cQuery += ") AS FL_VEN_PRO, "
	_cQuery += "PA.C5_NUMPRE_BONIFICACAO AS BONIF, "
	_cQuery += "( "
	_cQuery += "SELECT C5_NUM "
	_cQuery += "FROM " + RetSQLName("SC5") + " "
	_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) "
	_cQuery += _cRptQry
	_cQuery += ") AS PV_BON_PRO, "
	_cQuery += "( "
	_cQuery += "SELECT C5_FILIAL "
	_cQuery += "FROM " + RetSQLName("SC5") + " "
	_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) "
	_cQuery += _cRptQry
	_cQuery += ") AS FL_BON_PRO "
	_cQuery += "FROM PORTAL_TAIFFPROART..TBL_PEDIDOS_ASSOCIADOS PA  WITH(NOLOCK) "
	_cQuery += "WHERE "
	_cQuery += "CAST(C5_NUMPRE_VENDAS      AS VARCHAR(" + _cTam + ")) = '" + _cPed + "' "
	_cQuery += "OR "
	_cQuery += "CAST(C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) = '" + _cPed + "' "

	DBUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), _cNxtAlias , .F., .T.)

	DBSelectArea(_cNxtAlias)

	_aRetPVV    := {"", "", "", "", "", ""}

	_aRetPVV[1] := AllTrim(Str((_cNxtAlias)->VENDA))
	_aRetPVV[2] := AllTrim((_cNxtAlias)->PV_VEN_PRO)
	_aRetPVV[3] := AllTrim((_cNxtAlias)->FL_VEN_PRO)

	_aRetPVV[4] := AllTrim(Str((_cNxtAlias)->BONIF))
	_aRetPVV[5] := AllTrim((_cNxtAlias)->PV_BON_PRO)
	_aRetPVV[6] := AllTrim((_cNxtAlias)->FL_BON_PRO)

	DBSelectArea(_cNxtAlias)
	DBCloseArea()

	DBSelectArea(_cAntAlias)
	RestArea(_aAntAlias)

Return(_aRetPVV)
