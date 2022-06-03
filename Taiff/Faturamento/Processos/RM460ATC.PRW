#include "rwmake.ch"
#IFNDEF CRLF
	#DEFINE CRLF Chr(13) + Chr(10)
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RM460ATC  º Autor ³ Marcelo Cardoso    º Data ³  08/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao da Selecao de Itens de Pedidos da Assistencia    º±±
±±º          ³ Tecnica                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function RM460ATC()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis e salva os alias que serao movimentados                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _lRet      := .T.
	Local _cOldAlias := Alias()
	Local _aOldAlias := GetArea()
	Local _aSC9Alias := SC9->(GetArea())
	Local _aSC5Alias := SC5->(GetArea())
	Local _aLbNotMrk := {}
	Local _aItNotMrk := {}
	Local _aPVATec   := {}
	Local _nCall     := 1
	Local _lPosiciona:= .F.
	Local _nIx := 0

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

		IF ((  (_cSC9Area)->C9_OK != PARAMIXB[1] .And. PARAMIXB[2] .AND. !A460AVALIA()) .or. (  (_cSC9Area)->C9_OK == PARAMIXB[1] .And. !PARAMIXB[2]))


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o Pedido eh de Assistencia Tecnica e se esta apto a ser faturado    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SC5->C5_CLASPED == "A" .and. (_cSC9Area)->C9_BLEST = "  " .and. (_cSC9Area)->C9_BLCRED = "  "

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o numero de Pedido ja foi adicionado a lista de verificacao         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AScan(_aPVATec, (_cSC9Area)->C9_PEDIDO ) == 0

					AAdd(_aPVATec, (_cSC9Area)->C9_PEDIDO )

				EndIf

			EndIf

		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Trata Itens de Pedido Liberados mas nao marcados                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If AScan(_aLbNotMrk, {|x| x[1] == (_cSC9Area)->C9_PEDIDO .and. x[2] == (_cSC9Area)->C9_ITEM } ) == 0 .and. (_cSC9Area)->C9_BLEST == "  " .and. (_cSC9Area)->C9_BLCRED == "  "

				If SC5->C5_NUM <> (_cSC9Area)->C9_PEDIDO

					DBSelectArea("SC5")
					DBSeek(xFilial() + (_cSC9Area)->C9_PEDIDO)

				EndIf

				If SC5->C5_CLASPED == "A"

					AAdd(_aLbNotMrk, {(_cSC9Area)->C9_PEDIDO, (_cSC9Area)->C9_ITEM } )

				EndIf


			EndIf

		EndIf

		DBSelectArea(_cSC9Area)
		DBSkip()

	EndDo

	If _lPosiciona

		DBSelectArea(_cSC9Area)
		DBCloseArea()

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica atraves do array _aItNotMrk os Pedidos + Itens nao selecionados      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nIx := 1 To Len(_aLbNotMrk)

		If AScan(_aPVATec, _aLbNotMrk[_nIx][1] ) <> 0

			AAdd(_aItNotMrk, {_aLbNotMrk[_nIx][1], _aLbNotMrk[_nIx][2] } )

			_lRet := .F.

		EndIf

	Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta janela com alerta para o usuario com base nos itens nao selecionados      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet == .F.

		_cProble := ""
		_cTitulo := "Pedidos da Assistencia Tecnica"

		If Len(_aItNotMrk) > 0

			For _nIx := 1 To Len(_aItNotMrk)

				_cProble += "Pedido " + _aItNotMrk[_nIx][1] + " Item " + _aItNotMrk[_nIx][2] + " nao selecionado." + CRLF

			Next

			_cSoluc := "Selecione todos os itens acima e prossiga com o faturamento." + CRLF
			_cSoluc += "Para mais informacoes contacte o Departamento de Assistencia Tecnica."

			xMagHelpFis(_cTitulo, _cProble, _cSoluc)

		EndIf

	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os alias que foram movimentados para as situacoes originais            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DBSelectArea("SC9")
	RestArea(_aSC9Alias)

	DBSelectArea("SC5")
	RestArea(_aSC5Alias)

	DBSelectArea(_cOldAlias)
	RestArea(_aOldAlias)

Return _lRet
