#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER 	CHR(13) + CHR(10)
#DEFINE TAB	 	CHR(9)

/*
=================================================================================
=================================================================================
||   Arquivo:	M440STTS.prw
=================================================================================
||   Funcao: 	M440STTS
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Este ponto de entrada ้ executado ap๓s o fechamento da transa็ใo de
||	libera็ใo do pedido de venda (manual).
||		O mesmo sera utilizado para deletar os registros da Tabela de Controle
|| 	de quantidades liberadas (CONTROLE_QTDLIB)
||
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	17/11/2015
=================================================================================
=================================================================================
*/

USER FUNCTION M440STTS()
	Local cProd
	Local cOp
	Local cPedido
	LOCAL CQUERY 		:= ""
	//LOCAL ADOC 		:= {}
	Local n := 0

	//QUANDO NAO FOR BENEFICIAMENTO OU COPIA DE PEDIDOS SAIR DA ROTINA OU NAO FOR ACTION
	/*
	If M->C5_TIPO # "B" .Or. IsInCallStack("A410COPIA") .Or. !(cEmpAnt == "04" .and. cFilAnt='02')
		Return
	EndIf
	*/
	
	//PARA PEDIDO DE BENEFICIAMENTO GRAVA A QUANTIDADE ENVIADA NA SD4
	If  IsInCallStack("MATA410") .AND. !IsInCallStack("A410COPIA") .AND. M->C5_TIPO = "B" .AND. (cEmpAnt == "04" .and. cFilAnt='02')
		nOld := n
		For n:= 1 To Len(aCOLS)
			cOp 	:= BuscaCols("C6__OPBNFC")
			cProd 	:= BuscaCols("C6_PRODUTO")
			cPedido := M->C5_NUM
			If !Empty(cOP)
				dbSelectArea("SD4")
				dbSetOrder(2)
				If dbSeek(xFilial()+cOp+cProd)
					RecLock("SD4",.F.)
					If INCLUI .And. !aCols[n][Len(aCols[n])]
						D4__QTBNFC := D4__QTBNFC+BuscaCols("C6_QTDVEN")
					ElseIf ALTERA
						If !aCols[n][Len(aCols[n])]
							D4__QTBNFC := U_CalcBnfc(cOp,cProd,cPedido,"V")+BuscaCols("C6_QTDVEN")
						Else
							D4__QTBNFC := D4__QTBNFC- BuscaCols("C6_QTDVEN")
						EndIf
					Else //EXCLUI
						D4__QTBNFC := D4__QTBNFC- BuscaCols("C6_QTDVEN")
					EndIf
					SD4->(MsUnlock())
				EndIf
			EndIf
			
		NEXT n
		n:= nOld
	EndIf
	
	IF (CEMPANT + CFILANT) = "0302"
		
		IF SC5->C5_FATPARC = "N"
			
			CQUERY := "SELECT" 														+ ENTER
			CQUERY += "	ISNULL(SUM(SC6.C6_QTDVEN),0) AS C6_QTDVEN," 			+ ENTER
			CQUERY += "	ISNULL(SUM(SC9.C9_QTDLIB),0) AS C9_QTDLIB" 			+ ENTER
			CQUERY += "FROM" 															+ ENTER
			CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 							+ ENTER
			CQUERY += "	LEFT OUTER JOIN " + RETSQLNAME("SC9") + " SC9 ON" 	+ ENTER
			CQUERY += "		SC9.C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 	+ ENTER
			CQUERY += "		SC9.C9_PEDIDO = SC6.C6_NUM AND" 					+ ENTER
			CQUERY += "		SC9.C9_ITEM = SC6.C6_ITEM AND" 						+ ENTER
			CQUERY += "		SC9.C9_PRODUTO = SC6.C6_PRODUTO AND" 				+ ENTER
			CQUERY += "		SC9.C9_DATALIB = '" + DTOS(DDATABASE) + "' AND" 	+ ENTER
			CQUERY += "		SC9.C9_NFISCAL = '' AND" 							+ ENTER
			CQUERY += "		SC9.D_E_L_E_T_ = ''" 								+ ENTER
			CQUERY += "WHERE" 														+ ENTER
			CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 		+ ENTER
			CQUERY += "	SC6.C6_NUM = '" + SC5->C5_NUM + "' AND" 				+ ENTER
			CQUERY += "	SC6.D_E_L_E_T_ = ''"
			
			IF SELECT("TMP") > 0
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
			ENDIF
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			
			IF (TMP->C6_QTDVEN - TMP->C9_QTDLIB) != 0
				
				MESSAGEBOX("Cliente nใo aceita Faturamento Parcial!" + ENTER + "Se necessแrio estorne a Libera็ใo", "ATENวรO", 48)
				
			ENDIF
			
		ENDIF
		
		/*
		|---------------------------------------------------------------------------------
		|	Gera Query com os Itens do Pedido de Venda para poder realizar a Exclusao
		|	do Controle de Libera็๕es!
		|---------------------------------------------------------------------------------
		*/
		CQUERY := "SELECT" 												+ ENTER
		CQUERY += "	C6_NUM," 											+ ENTER
		CQUERY += "	C6_ITEM," 											+ ENTER
		CQUERY += "	C6_PRODUTO" 										+ ENTER
		CQUERY += "FROM" 													+ ENTER
		CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 					+ ENTER
		CQUERY += "WHERE" 												+ ENTER
		CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER
		CQUERY += "	C6_NUM = '" + SC5->C5_NUM + "' AND" 			+ ENTER
		CQUERY += "	SC6.D_E_L_E_T_ = ''"
		
		IF SELECT("TRB") > 0
			DBSELECTAREA("TRB")
			DBCLOSEAREA()
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")
		DBGOTOP()
		
		WHILE TRB->(!EOF())
			
			IF !U_DELCONTROLE(TRB->C6_NUM,TRB->C6_ITEM,TRB->C6_PRODUTO)
				
				MSGALERT(OEMTOANSI(	"Erro ao tentar deletar Controle de Libera็๕es!")  + ENTER + ;
					"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
				
			ENDIF
			
			TRB->(DBSKIP())
			
		ENDDO
		
	ENDIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcBnfc  บ Autor ณ Paulo Bindo        บ Data ณ  19/12/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ CALCULA A QUANTIDADE ENVIADA POR OP                        บฑฑ
ฑฑบ          ณ EXP1: ORDEM PRODUCAO                                       บฑฑ
ฑฑบ          ณ EXP2: PRODUTO                                              บฑฑ
ฑฑบ          ณ EXP3: PEDIDO                                               บฑฑ
ฑฑบ          ณ EXP4: TIPO PEDIDO - COMPRA/VENDA                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CalcBnfc(cOp,cProd,cPedido,cTped)
	Local nQtdEmp := 0
	Local aArea	  := GetArea("SD4")
	If cTped == "V"
		cQuery := " SELECT SUM(C6_QTDVEN) C6_QTDVEN"
		cQuery += " FROM "+RetSqlName("SC6")+" WITH(NOLOCK)"
		cQuery += " WHERE C6__OPBNFC = '"+cOp+"'"
		cQuery += " AND C6_PRODUTO = '"+cProd+"'"
		cQuery += " AND C6_FILIAL = '"+cFilAnt+"'
		cQuery += " AND D_E_L_E_T_ <> '*'"
		cQuery += " AND C6_NUM <> '"+cPedido+"'
		
		//MemoWrite("M410STTSV.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBC5",.T.,.T.)
		
		dbSelectArea("TRBC5")
		nQtdEmp := TRBC5->C6_QTDVEN
		TRBC5->(dbCloseArea())
	Else
		cQuery := " SELECT SUM(C7_QUANT) C7_QUANT FROM "+RetSqlName("SC7")
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND C7_PRODUTO = '"+cProd+"'"
		cQuery += " AND C7__OPBNFC = '"+cOp+"'"
		cQuery += " AND C7_NUM <> '"+cPedido+"'
		cQuery += " AND C7_FILIAL = '"+cFilAnt+"'"
		//MemoWrite("M410STTSC.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBC5",.T.,.T.)
		
		dbSelectArea("TRBC5")
		nQtdEmp := TRBC5->C7_QUANT
		TRBC5->(dbCloseArea())
		
	EndIf
	RestArea(aArea)
Return(nQtdEmp)
