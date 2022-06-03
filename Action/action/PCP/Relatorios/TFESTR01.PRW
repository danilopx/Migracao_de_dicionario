#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TFESTR01 ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 18/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de empenhos pendentes                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³                HISTORICO DE ATUALIZACOES DA ROTINA                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³Solic.³ Descricao                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabricio    ³18/10/10³      ³ Implementacao                            ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFESTR01()
	Private cString     := "TFESTR01"
	Private cTitulo     := ""
	Private cPerg       := PadR("TFESTR01", Len(SX1->X1_GRUPO))
	Private Wnrel       := "TFESTR01"
	Private cDesc1  	:= ""
	Private cDesc2  	:= ""
	Private cDesc3  	:= ""
	Private lHabilDict  := .F.    // habilita dicionario
	Private aOrdemIndex := Nil    // array ordem de indexacao
	Private lHabilCompr := .F.    // habilita compressao
	Private cTamRelato  := "P"    // "P"=80, "M"=132, "G"=220
	Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private m_pag       := 1
	Private Li          := 80

	GeraX1()
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	//                      1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0
	//            012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//              XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999,999.99 XXXXXXXXXX
	cCabec1		:= "Ordem Produção - Codigo        - Produto"
//	cCabec2		:= "  Codigo          Descrição                                    Qtd OP   Qtd Paga"
	cCabec2     := "    Codigo    Descricao                                    Qtd.OP  Qtd.Paga  Lote"
	NomeProg	:= "TFESTR01"
	cString     := "SD4"
	cTitulo     := "Ordem de produção"
	cDesc1  	:= "Emite relatorio " + cTitulo
	cDesc2  	:= ""
	cDesc3  	:= ""
	nTipo       := 15
	m_pag       := 1
	      
	WNREL := SetPrint(cString, NomeProg, cPerg, @cTitulo, cDesc1, cDesc2, cDesc3, lHabilDict, aOrdemIndex, lHabilCompr, cTamRelato, ,.F.)
	
	If LastKey() <> 27
		SetDefault(aReturn, cString)
		
		nTipo := If(aReturn[4] == 1, 15, 18)
		
		RptStatus({|| Imp_Rel()}, cTitulo, "Imprimindo...")
	EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Imp_Rel  ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 18/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Imp_Rel()
	Local aArea	:= GetArea()
	Local cOpImp	:= ""
	Local cOpIni	:= ""
	Local cOpFim	:= ""
	Local lImpZero	:= .F.

	cOpIni   := MV_PAR01
	cOpFim   := MV_PAR02
	lImpZero := MV_PAR03 == 1

	cSql := "SELECT "
	cSql += "  D4_OP, D4_QUANT, D4_COD, D4_QTDPG, B1_DESC, B1_CODANT "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SD4") + " SD4 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "    SB1.B1_FILIAL  = '" + xFilial("SB1") + "'       AND "
	cSql += "    SD4.D4_FILIAL  = '" + xFilial("SD4") + "'       AND "
	cSql += "    SD4.D4_COD     = SB1.B1_COD "
	cSql += "WHERE "
	cSql += "  SD4.D_E_L_E_T_ = ' ' "
	cSql += "  AND SB1.D_E_L_E_T_ = ' ' "
	cSql += "  AND LEFT(SD4.D4_OP, " + Str(Len(cOpIni),2) + ")      >= '" + cOpIni + "' "
	cSql += "  AND LEFT(SD4.D4_OP, " + Str(Len(cOpFim),2) + ")      <= '" + cOpFim + "' "
	If !lImpZero
		cSql += "  AND SD4.D4_QUANT > 0"
	EndIf
	cSql += "ORDER BY "
	cSql += "  D4_OP, D4_COD, D4_LOCAL "
	
	//MEMOWRITE("TFESTR01.SQL",cSql)
	
	TcQuery cSql New Alias "TMPD4"
	
	SetRegua(0)	
	
	TMPD4->(DbSkip())
	TMPD4->(DbGoTop())

	SC2->(DbSetOrder(1))
	SC2->(DbSeek(xFilial("SC2") + TMPD4->D4_OP, .F.))
	cNumOP := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
	cCodProd := SC2->C2_PRODUTO
	
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + SC2->C2_PRODUTO, .F.))
	cDesProd := SB1->B1_DESC
	
	nPagina := 0
	
	While !TMPD4->(Eof())		
		IncRegua()
		
		//Verifica se o item esta classificado como RT/IB/ET/MO/MN/PI
		SB1->(DbSeek(xFilial("SB1") + TMPD4->D4_COD, .F.))
		If SB1->B1_TIPO $ "RT|IB|ET|MO|MN|"
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

		If Li > 66 .OR. cOPImp <> Left(TMPD4->D4_OP, Len(cOpIni))
			If cOPImp <> Left(TMPD4->D4_OP, Len(cOpIni)) .AND. .NOT. EMPTY(cOPImp) 
				Li += 2
				@ Li, 0 Psay "Nome legível " + Replicate("_", 40) + "  " + "Data ____/____/________"
				Li += 2
				@ Li, 0 Psay "SG1-01-FRM-010 / Rev. " + SC2->C2_REVISAO
				If  ((nPagina / 2) - INT(nPagina / 2)) > 0 
					Cabec(cTitulo, cCabec1, cCabec2, NomeProg, cTamRelato, nTipo)
				EndIf
				nPagina := 0
			EndIf
			Cabec(cTitulo, cCabec1, cCabec2, NomeProg, cTamRelato, nTipo)
			cOPImp := Left(TMPD4->D4_OP, Len(cOpIni))
			@ Li, 000 PSAY TMPD4->D4_OP + " - " + SC2->C2_PRODUTO + " - " + SB1->B1_DESC  
			Li+= 2
			nPagina += 1
		EndIf

		SB1->(DbSeek(xFilial("SB1") + TMPD4->D4_COD, .F.))
		If SB1->B1_ITEMSEG == "1"
			@ Li, 0 Psay "(IR)*"
		EndIf

		// Alterado em 27-Maio-2021 por Ronald Piscioneri:
		// O codigo do produto deve ser impresso com 15 caracteres, pois ha' novos codigos
		// que ocupam as 15 posicoes

		@ Li, 6  Psay SubStr(TMPD4->D4_COD, 1, 15) Picture "@!"
		@ Li, 22 Psay Left(TMPD4->B1_DESC, 32) Picture "@!"
		@ Li, 55 Psay TMPD4->(D4_QUANT - D4_QTDPG) Picture "@E 999,999.99"
		@ Li, 65 Psay "|______||______|"
		Li++
		@ Li, 0 Psay __PrtThinLine()
		Li++ 
		
		If Li > 65
			@ Li, 0 Psay "SG1-01-FRM-010 / Rev. " + SC2->C2_REVISAO
			Li += 2
		EndIf
		
		TMPD4->(DbSkip())
	EndDo
	Li += 2
	@ Li, 0 Psay "Nome legível " + Replicate("_", 40) + "  " + "Data ____/____/________"
	Li += 2
	@ Li, 0 Psay "SG1-01-FRM-010 / Rev. " + SC2->C2_REVISAO
		
	TMPD4->(DbCloseArea())
	RestArea(aArea)
	
	Set Device To Screen
	If aReturn[5] == 1
		Set Printer To
		OurSpool(wnrel)
	EndIf
	
	MS_FLUSH()
	
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
Static Function GeraX1()
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}
	Local i, j
	
	AADD(aRegs, {cPerg, "01","Ordem de Produçao ?   ","","","mv_ch1","C",06,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@!",""})
	AADD(aRegs, {cPerg, "02","OP Final ?            ","","","mv_ch2","C",06,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@!",""})
	AADD(aRegs, {cPerg, "03","Imp. Emp. Zerado ?    ","","","mv_ch3","N",01,00,00,"C","","mv_par03","1=Sim","","","","","2=Nao","","","","","","","","","","","","","","","","","","","","","","","","" } )	
	
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
				aAdd(aHelpPor, "Ordem de produção inicial.             ")
			ElseIf i == 2
				aAdd(aHelpPor, "Ordem de produção final.             ")
			ElseIf i == 3
				aAdd(aHelpPor, "Imprime empenho zerado?                ")
			EndIf		
			PutSX1Help("P." + cPerg + StrZero(i,2) + ".", aHelpPor, aHelpEng, aHelpSpa, .T.)
		Endif
	Next
	RestArea(aArea)
Return
