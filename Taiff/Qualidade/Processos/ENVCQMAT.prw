/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ENVCQMAT  ºAutor  ³Marcos J.           º Data ³  03/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para enviar ou nao o material para o controle de    º±±
±±º          ³qualidade.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ENVCQMAT()
	Local cAlias := Alias()
	Local _aArea := GetArea()
	Local _arSF4 := SF4->(GetArea())
	Local lRet   := Nil

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Conforme email do Sr. Gustavo (22/04/2015) nenhum produto na Emrpesa Daihatsu 
	|	ira entrar no controle de qualidade.
	|
	|	Edson Hornberger - 22/04/2015
	|=================================================================================
	*/
	If (SM0->M0_CODIGO = "04" .AND. cFilAnt="02")
		If !Empty(SD1->D1_TES)	
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES, .F.))
			If SF4->F4_ENVCQ == "S"
				lRet := .T.
			ElseIf SF4->F4_ENVCQ == "N"
				lRet := .F.
			ElseIf SF4->F4_ENVCQ == "I"
				lRet := Nil
			EndIf
		EndIf
	EndIf
	
	DbSelectArea(cAlias)
	
	RestArea(_arSF4)
	RestArea(_aArea)
	
Return(lRet)	
