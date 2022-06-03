#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRD001 บAutor  ณPAULO BINDO          บ Data ณ  24/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ABRE TELA PARA INCLUIR AMARRACAO PRODUTO X FORNECEDOR      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COMRD001()
cCampo :=  AllTrim(ReadVar())
cConteudo := &(ReadVar())
aArea	  := GetArea()
	If IsInCallStack("CNTA120") 
		// NรO VALIDA INCLUSรO EM SA5
	Else 
	//PRODUTO SEM CADASTRO NA SA5
		cQuery := " SELECT" 
		cQuery += " B1_COD, B1_DESC
		cQuery += " FROM "+RetSqlName("SB1")+" SB1  WITH(NOLOCK)
		cQuery += " WHERE 
		cQuery += " B1_COD = '"+ cConteudo +"' "
		cQuery += " AND SB1.D_E_L_E_T_ <> '*'
		cQuery += " AND B1_FILIAL = '"+cFilAnt+"'"	
		cQuery += " AND B1_COD NOT IN (SELECT A5_PRODUTO  FROM "+RetSqlName("SA5")+"  WITH(NOLOCK) "
		cQuery += " WHERE A5_FILIAL  = B1_FILIAL AND  B1_COD = A5_PRODUTO  AND  A5_FORNECE = '"+ cA120Forn +"' AND A5_LOJA = '" + cA120Loj + "' AND D_E_L_E_T_ <> '*' )
	
	
		MemoWrite("COMRD001.SQL",cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBSA5", .F., .T.)
	
		Count To nRec			
	
		dbSelectArea("TRBSA5")
		dbGoTop()
	
		If nRec > 0
			While !Eof()
				MsgStop("Produto sem amarraco Produto X Fornecedor")
				nOpcA:=  AxInclui("SA5",Recno(),3,/*aAcho*/,,/*aCpos*/,"A060Valid() .And. MA060TUDOK().and.A060FABR()",/*lF3*/,/*cTransact*/,/*aButtons*/,/*aParam*/,Nil,.T.)
	
				dbSelectArea("TRBSA5")
				dbSkip()
			End
		EndIf
		TRBSA5->(dbCloseArea())
	
	
	
		//PRODUTO COM CADASTRO INCOMPLETO NA SA5
		cQuery := " SELECT B1_COD, B1_DESC,A5_QTDEMB,A5_LOTEMIN,A5_QENTMIN
		cQuery += " FROM "+RetSqlName("SB1")+" B1 WITH(NOLOCK)" 
		cQuery += " INNER JOIN "+RetSqlName("SA5")+" A5 WITH(NOLOCK) ON A5_FILIAL  = B1_FILIAL AND  B1_COD = A5_PRODUTO"
		cQuery += " WHERE" 
		cQuery += " B1_COD = '"+ cConteudo +"' "
		cQuery += " AND B1.D_E_L_E_T_ <> '*'"
		cQuery += " AND B1_FILIAL = '"+cFilAnt+"'"
		cQuery += " AND  A5_FORNECE = '"+ cA120Forn +"'"
		cQuery += " AND A5_LOJA = '" + cA120Loj + "' AND A5.D_E_L_E_T_ <> '*' AND (A5_QTDEMB=0 OR A5_LOTEMIN=0 OR A5_QENTMIN=0) "
	
		MemoWrite("COMRD001A.SQL",cQuery)
	
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBSA5", .F., .T.)
	
		Count To nRec			
	
		dbSelectArea("TRBSA5")
		dbGoTop()
	
		If nRec > 0
			While !Eof()
				MsgStop("Produto com amarraco Produto X Fornecedor incompleta")
				nQtdEmb 	:= TRBSA5->A5_QTDEMB					
				nLotemin 	:= TRBSA5->A5_LOTEMIN
				nEntreMin	:= TRBSA5->A5_QENTMIN
	
				While nQtdEmb == 0 .Or.  nLotemin = 0 .Or. nEntreMin == 0
					@ 65,193 To 380,435 Dialog oDlg Title OemToAnsi("Produto x Fornecedor")
	
					@ 05,9 Say "Fornecedor: "+AllTrim(Posicione("SA2",1,xFilial("SA2")+cA120Forn+cA120Loj,"A2_NOME")) Size 199,8 Pixel Of oDlg
					@ 20,9 Say "Produto: "+AllTrim(TRBSA5->B1_COD)+" - "+TRBSA5->B1_DESC Size 199,8 Pixel Of oDlg
	
					@ 45,9 Say OemToAnsi(TitSX3("A5_QTDEMB")[1]) Size 99,8 Pixel Of oDlg
					@ 45,42 MsGet nQtdEmb Valid nQtdEmb > 0 PICTURE PesqPict("SA5","A5_QTDEMB") Size 30,10 Pixel Of oDlg
	
					@ 60,9 Say OemToAnsi(TitSX3("A5_LOTEMIN")[1]) Size 99,8 Pixel Of oDlg
					@ 60,42 MsGet nLotemin Valid nLotemin > 0 PICTURE PesqPict("SA5","A5_LOTEMIN") Size 30,10 Pixel Of oDlg
	
					@ 75,9 Say OemToAnsi(TitSX3("A5_QENTMIN")[1]) Size 99,8 Pixel Of oDlg
					@ 75,42 MsGet nEntreMin  Valid nEntreMin > 0 PICTURE PesqPict("SA5","A5_QENTMIN") Size 30,10 Pixel Of oDlg
	
	
					@ 136,95 BMPBUTTON TYPE 1 ACTION Close(oDlg)
					Activate Dialog oDlg Centered
	
				End	
	
				dbSelectArea("SA5")
				dbSetOrder(1)
				If dbSeek(xFilial()+cA120Forn+cA120Loj+TRBSA5->B1_COD)
					RecLock("SA5",.F.)
					A5_QTDEMB	:= nQtdEmb 
					A5_LOTEMIN	:= nLotemin 
					A5_QENTMIN	:= nEntreMin						
					SA5->(MsUnlock())
				EndIf
	
				dbSelectArea("TRBSA5")
				dbSkip()
			End
		EndIf
		TRBSA5->(dbCloseArea())
	ENDIF
RestArea(aArea)
Return(cConteudo)
