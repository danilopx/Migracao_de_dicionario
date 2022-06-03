#INCLUDE 'PROTHEUS.CH'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA  ³MFis0001    ³Autor  ³V.RASPA              ³Data  ³ 21.Jan.11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta padrao especifica (SA1SA2) amarrada ao campo       ³±±
±±³          ³F3_CLIEFOR                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Especifico: TAIFF                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MFis0001()
Local xRet := NIL

If INCLUI
	If !Empty(M->F3_CFO)
		If M->F3_CFO < '500'
			If !(M->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"FOR")
			Else
				xRet := ConPad1(,,,"SA1")
			EndIf
		Else
			If !(M->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"SA1")
			Else
				xRet := ConPad1(,,,"FOR")
			EndIf
    	EndIf
	Else
		xRet := .F.
		Aviso('Atenção', 'Informe o CFOP deste documento', {'OK'})
	EndIf   
Else
	If !Empty(SF3->F3_CFO) 
		If SF3->F3_CFO < '500'
			If !(SF3->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"FOR")
			Else
				xRet := ConPad1(,,,"SA1")
			EndIf
		ElseIf SF3->F3_CFO >= '500'
			If !(SF3->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"SA1")
			Else
				xRet := ConPad1(,,,"FOR")
			EndIf
		EndIf
	EndIf
EndIf

Return(xRet)