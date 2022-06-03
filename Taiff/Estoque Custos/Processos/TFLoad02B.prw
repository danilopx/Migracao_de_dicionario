#include "Totvs.ch"
#include "TopConn.ch"

//---------------------------------------------------------------------------------------------------------
// Função...: TFLoad02B
// Descrição: Empenha OP do armazem 02-buffer para 11-produção
// Autor....: Carlos Alday Torres																		    Data: 20/01/2012
// Requisitante: Cesar Rosa de Souza
//---------------------------------------------------------------------------------------------------------
User Function TFLoad02B()
	Local cSql    := ""
	Local aLinha  := ""
	Local cArmOri := ""
	Local cPerg   := ""
	Local cAlias  := Alias()
	Local aGetArea:= GetArea()
	
	cPerg := "TFLOAD02B"	
	GeraX1(cPerg)
	
	cArmOri := GetMv("MV_TFARORI", , "11")
	If Empty(cArmOri)
		MsgAlert("Parametro MV_TFARORI não criado ou não preenchido.")
		Return
	EndIf
	
	If Pergunte(cPerg) .And. !Empty(MV_PAR01)
		cSql := "SELECT "
		cSql += "  D4_COD, D4_LOCAL, D4_QUANT, D4_OP, D4_QTDPG, D4_QTDEORI "
		cSql += "FROM "
		cSql += "  " + RetSqlName("SD4") + " SD4 "
		cSql += "WHERE"
		cSql += "  D_E_L_E_T_ = ' ' "
		cSql += "  AND D4_FILIAL = '" + xFilial("SD4") + "' "
		cSql += "  AND D4_QUANT  > 0 "
		cSql += "  AND LEFT(D4_OP, " + Str(Len(MV_PAR01), 2) + ")      = '" + MV_PAR01 + "' "
		cSql += "ORDER BY "
		cSql += "  D4_OP, D4_COD, D4_LOCAL "
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cSql), "TMPD4", .T., .T.)
		
		aLinha := aClone(aCols[1])

		SB1->(DbSetOrder(1))
		SC2->(DbSetOrder(1))
		While !TMPD4->(Eof())

			//Verifica se o item esta classificado como RT/IB/ET/PI/MO
			SB1->(DbSeek(xFilial("SB1") + TMPD4->D4_COD, .F.))
			If SB1->B1_TIPO $ "RT|IB|ET|PI|MO|MN"
				TMPD4->(DbSkip())
				Loop
			EndIf

			//Verifica se o item PAI da OP está classificado como FB/IB/PB/ET
			SC2->(Dbseek(xFilial("SC2") + TMPD4->D4_OP, .F.))
			SB1->(DbSeek(xFilial("SB1") + SC2->C2_PRODUTO, .F.))
			If SB1->B1_TIPO $ "FB|IB|PB|ET"
				TMPD4->(DbSkip())
				Loop
			EndIf
			
			If (TMPD4->D4_QTDEORI - TMPD4->D4_QTDPG) <= 0
				TMPD4->(DbSkip())
				Loop
			EndIf			
			SB1->(DbSeek(xFilial("SB1") + TMPD4->D4_COD, .F.))				
			aTail(aCols)[1]  := TMPD4->D4_COD
			aTail(aCols)[4]  := cArmOri
			aTail(aCols)[6]  := TMPD4->D4_COD
			aTail(aCols)[9]  := TMPD4->D4_LOCAL
			aTail(aCols)[16] := (TMPD4->D4_QTDEORI - TMPD4->D4_QTDPG)
			aTail(aCols)[5]  := "BUFFER"
			aTail(aCols)[10] := "PROD"
			aTail(aCols)[2]  := SB1->B1_DESC
			aTail(aCols)[3]  := SB1->B1_UM
			aTail(aCols)[7]  := SB1->B1_DESC
			aTail(aCols)[8]  := SB1->B1_UM
			
			If SD3->(GDFieldPos("D3_OPTRANS")) > 0
				aTail(aCols)[GDFieldPos("D3_OPTRANS")] := TMPD4->D4_OP  	
			EndIf

			aAdd(aCols, aClone(aLinha))
			TMPD4->(DbSkip())
		End
		TMPD4->(DbCloseArea())
	EndIf
	RestArea(aGetArea)
	DbSelectArea(cAlias)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GeraX1   ³ Autor ³ Microsiga             ³ Data ³ 27/12/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Uso Generico.                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraX1(cPerg)
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}
	Local i, j
	
	cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
	AADD(aRegs, {cPerg, "01","Número da OP ?   ","","","mv_ch0","C", 08,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@!",""})
	
	SX1->(DbSetOrder(1))
	For i := 1 To Len(aRegs)
		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					SX1->(FieldPut(j, aRegs[i,j]))
				Endif
			Next
			SX1->(MsUnlock())
			
			aHelpPor := {}
			aHelpSpa := {}
			aHelpEng := {}	
			If i == 1
				aAdd(aHelpPor, "Digite o número da ordem de produção.")
			EndIf		
			PutSX1Help("P." + cPerg + StrZero(i,2) + ".", aHelpPor, aHelpEng, aHelpSpa, .T.)
		Endif
	Next
	RestArea(aArea)
Return