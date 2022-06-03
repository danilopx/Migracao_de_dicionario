#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FR650FIL º Autor ³ Otacilio A. Junior º Data ³ 20/03/2014  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para tratamento das variaveis do Cnab a   º±±
±±º          ³ pagar.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FR650FIL()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _aParam  := PARAMIXB[1]

//Local _cOldArea := Alias()
//Local _aOldArea := GetArea()
//Local _aSE2Area := SE2->(GetArea())
Local _aSA2Area := SA2->(GetArea())

Local _cNumTit   := cNumTit
//Local _dBaixa    := dBaixa
//Local _cTipo     := cTipo
Local _nValPgto  := nValRec
Local _cCGC      := IIF(Substr(_aParam[14],2,1)=='2',Substr(_aParam[14],4,14),Substr(_aParam[14],4,9)+Substr(_aParam[14],16,2))
Local _lAchou    := .F.
Local _cVencto	 := Substr(_aParam[14],166,8)
Local _cChave	 := ''
Local _lNewIndice:= .F.


If SM0->M0_CODIGO <> "04" .and. Empty(_cNumTit) .AND. mv_par07==2
	
	//_cRejeicao := cRejeicao // Disponivel apenas na Versao 11
	//_xBuffer   := xBuffer   // Disponivel apenas na Versao 11
	
	_lNewIndice := FaVerInd()
	
	If _lNewIndice .and. !Empty(xFilial(IIF(mv_par07==1,"SE1","SE2")))
		//Busca por IDCNAB sem filial no indice
		dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
		dbSetOrder(IIF(mv_par07==1,19,13))
		_cChave := Substr(_cNumTit,1,10)
	Else
		//Busca por IDCNAB com filial no indice
		dbSelectArea(IIF(mv_par07==1,"SE1","SE2"))
		dbSetOrder(IIF(mv_par07==1,16,11))
		_cChave := xFilial(IIF(mv_par07==1,"SE1","SE2"))+Substr(_cNumTit,1,10)
	Endif
	
	// Busca pelo IdCnab
	If !Empty(_cNumTit) .And. MsSeek(_cChave)
		_lAchou := .T.
	Endif
	If !_lAchou
		SA2->(DbSetOrder(03))
		SA2->(DbSeek(xFilial("SA2")+_cCGC))
		//	cForne:= SA2->A2_COD
		
		cQuery:= " SELECT * "
		cQuery+= " FROM "+RetSqlName("SE2")
		cQuery+= " Where E2_FILIAL = '"+xFilial("SE2")+"'"
		cQuery+= "   AND E2_FORNECE+E2_LOJA = '"+SA2->(A2_COD+A2_LOJA)+"'"
		cQuery+= "   AND E2_VALOR = "+alltrim(Str(_nValPgto))+""
		cQuery+= "   AND E2_VENCREA = '"+_cVencto+"'"
		cQuery+= "   AND E2_BAIXA = '"+DTOS(CTOD("  /  /  "))+"'"
		cQuery+= "   AND D_E_L_E_T_ = ' '"
		cQuery:= ChangeQuery(cQuery)
		
		DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB1", .F., .F.)
		
		TRB1->(DbGoTop())
		If TRB1->(!Eof()) .And. TRB1->(!Bof())
			While TRB1->(!Eof())
				cNumTit	:= TRB1->(E2_PREFIXO+E2_NUM+E2_PARCELA)
				TRB1->(DbSkip())
			End
		EndIf
		
		// Se processa todas as filiais, tem o novo indice somente por IDCNAB e a filial da SE2 estah preenchida.
		DBSelectArea("SE2")
		DBSetOrder(01) // Filial+Prefixo+Numero+Parcela
		If DBSeek(xFilial("SE2")+cNumTit)
			
			_lAchou := .T.
			
		EndIf
		
		
		TRB1->(DbCloseArea())
		
		// DBSelectArea("SE2")
		// RestArea(_aSE2Area)
		
		DBSelectArea("SA2")
		RestArea(_aSA2Area)
		
		//DBSelectArea(_cOldArea)
		//RestArea(_aOldArea)
	EndIf
Else
	_lAchou:=.T.
EndIf

Return(_lAchou)
