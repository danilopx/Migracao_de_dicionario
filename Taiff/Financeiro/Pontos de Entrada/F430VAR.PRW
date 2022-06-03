#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F430VAR  º Autor ³ Marcelo Cardoso    º Data ³  09/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para tratamento das variaveis do Cnab a   º±±
±±º          ³ pagar. Em especial a de Desconto.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F430VAR

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _aParam

Local _cOldArea := Alias()
Local _aOldArea := GetArea()
Local _aSE2Area := SE2->(GetArea())
Local _aSA2Area := SA2->(GetArea())

Local _cNumTit
Local _dBaixa
Local _cTipo
Local _cNsNum
Local _nDespes
Local _nDescont
Local _nAbatim
Local _nValPgto
Local _nJuros
Local _nMulta
Local _cForne
Local _cOcorr
Local _cCGC
Local _nCM
Local _lAchou

_aParam    := PARAMIXB
_cNumTit   := cNumTit
_dBaixa    := dBaixa
_cTipo     := cTipo
_cNsNum    := cNsNum
_nDespes   := nDespes
_nDescont  := nDescont
_nAbatim   := nAbatim
_nValPgto  := nValPgto
_nJuros    := nJuros
_nMulta    := nMulta
_cForne    := cForne
_cOcorr    := cOcorr
_cCGC      := cCGC
_nCM       := nCM				

/*
Implementada o acesso da empresa 03 para permitir atribuição do desconto no caso de frete.
Autor: CT
Data: 19/01/2015 
*/                        
If SM0->M0_CODIGO == "04" .OR. SM0->M0_CODIGO == "03" 

	//_cRejeicao := cRejeicao // Disponivel apenas na Versao 11
	//_xBuffer   := xBuffer   // Disponivel apenas na Versao 11
	
	_lNewIndice := FaVerInd()
	
	// Se processa todas as filiais, tem o novo indice somente por IDCNAB e a filial da SE2 estah preenchida.
	DBSelectArea("SE2")
	If (mv_par11 == 2 .And. _lNewIndice) .and. !Empty(xFilial("SE2"))
		
		//Busca por IdCnab (sem filial)
		DBSetOrder(13) // IdCnab
		If DBSeek(Substr(cNumTit, 01, 10))
		
			_lAchou := .T.
		
		EndIf
		
	Else
		
		//Busca por IdCnab
		DBSetOrder(11) // Filial+IdCnab
		If DBSeek(xFilial("SE2")+	Substr(cNumTit, 01, 10))
		
			_lAchou := .T.	
		
		EndIf
		
	Endif
	
	If _lAchou 
	
		If !Empty(SE2->E2_CODBAR)
		
			If SE2->E2_VALOR - (Val(SubStr(Alltrim(SE2->E2_CODBAR), 10, 10)) / 100) == SE2->E2_DECRESC .and. nDescont == 0
			
			    If nValPgto + SE2->E2_DECRESC == SE2->E2_VALOR   
			    
					nDescont 		:= SE2->E2_DECRESC
					PARAMIXB[1][6] 	:= SE2->E2_DECRESC
				    
				EndIf
				
			EndIf        
		
		EndIf

		If SE2->E2_MULTA <> 0 .and. nMulta == 0
		
			nMulta := SE2->E2_MULTA
		
		EndIf
		
		If SE2->E2_JUROS + SE2->E2_CORREC + SE2->E2_ACRESC <> 0 .and. nJuros == 0
		
			nJuros := SE2->E2_JUROS + SE2->E2_CORREC + SE2->E2_ACRESC
		
		EndIf
		
	EndIf     
		
	DBSelectArea("SE2")
	RestArea(_aSE2Area)
	
	DBSelectArea("SA2")
	RestArea(_aSA2Area)
	
	DBSelectArea(_cOldArea)
	RestArea(_aOldArea)    
	
EndIf

Return
