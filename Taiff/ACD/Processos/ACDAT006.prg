#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'APVT100.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ACDV023    ³ Autor ³ Anderson Rodrigues  ³ Data ³ 27/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Apontamento Producao PCP Mod1 - Este programa tem por       ³±±
±±³          ³objetivo realizar os apontamentos de Producao/Perda e Hrs   ³±±
±±³          ³improdutivas baseados nas operac alocadas pela Carga Maquina³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/
User function ACDAT006()

	Local bkey05
	Local bkey09
	Local cOP      := Space(Len(CBH->CBH_OP))
	Local cOperacao:= Space(Len(CBH->CBH_OPERAC))
	Local cTransac := Space(Len(CBH->CBH_TRANSA))
	Local cRetPe   := ""
	Local lContinua:= .T.
	Private cOperador  := Space(15)
	Private cTM        := GetMV("MV_TMPAD")
	Private cProduto   := Space(Len(SC2->C2_PRODUTO))
	Private cLocPad    := Space(Len(SC2->C2_LOCAL))
	Private cRoteiro   := Space(Len(SH8->H8_ROTEIRO))
	Private cUltOper   := Space(Len(CBH->CBH_OPERAC))
	Private cPriOper   := Space(Len(CBH->CBH_OPERAC))
	Private cTipIni    := "1"
	Private cUltApont  := " "
	//Private cApontAnt  := " "
	Private nQTD       := 0
	Private nSldOPer   := 0
	Private nQtdH6	   := 0 	//QUANTIDADE SH6 - TAIFF
	Private nQtdOP     := 0
	Private aOperadores:= {}
	Private lConjunto  := .f.
	Private lFimIni    := .f.
	Private lAutAskUlt := .f.
	Private lVldOper   := .f.
	Private lRastro    := GetMV("MV_RASTRO")  == "S" // Verifica se utiliza controle de Lote
	Private lSGQTDOP   := GetMV("MV_SGQTDOP") == "1" // Sugere quantidade no inicio e no apontamento da producao
	Private lInfQeIni  := GetMV("MV_INFQEIN") == "1" // Verifica se deve informar a quantidade no inicio da Operacao
	Private lCBAtuemp  := GetMV("MV_CBATUD4") == "1" // Verifica se ajusta o empenho no inicio da producao
	Private lVldQtdOP  := GetMV("MV_CBVQEOP") == "1" // Valida no inicio da operacao a quantidade informada com o saldo a produzir da mesma
	Private lVldQtdIni := GetMV("MV_CBVLAPI") == "1" // Valida a quantidade do apontamento com a quantidade informada no inicio da Producao
	//Private lCfUltOper := GetMV("MV_VLDOPER") == "S" // Verifica se tem controle de operacoes
	Private lOperador  := GetMV("MV_SOLOPEA",,"2") == "1" // Solicita o codigo do operador no apontamento 1-sim 2-nao (default)
	Private lMod1      := .t.
	//Private lMsHelpAuto:= .f.
	Private lMSErroAuto:= .f.
	//Private lPerdInf   := .F.

	//CBChkTemplate()


	// -- Verifica se data do Protheus esta diferente da data do sistema.
	DLDataAtu()

	If IsTelnet()
		cOperador := CBRETOPE()
		If lContinua .And. Empty(cOperador)
			CBAlert("Operador nao cadastrado","Aviso",.T.,3000,2) //"Operador nao cadastrado"###"Aviso"
			lContinua := .f.
		EndIf
		If lContinua .And. VtModelo() == "RF"
			//bKey05 := VTSetKey(05,{|| CB023Encer()},"Encerrar")   // "Encerrar" CTRL+E
			bkey09 := VTSetKey(09,{|| U_AT06Hist(cOP)},"Informacoes") //"Informacoes" CTRL+I
		Endif
	Endif

	If lContinua .And. Empty(cTM)
		CBAlert("Informe o tipo de movimentacao padrao - MV_TMPAD","Aviso",.T.,3000,2) //"Informe o tipo de movimentacao padrao - MV_TMPAD"###"Aviso"
		lContinua := .f.
	EndIf

	If lContinua .And. !lRastro .and. lCBAtuemp
		CBAlert("O parametro MV_CBATUD4 so deve ser ativado quando o sistema controlar rastreabilidade","Aviso",.T.,4000,2) //"O parametro MV_CBATUD4 so deve ser ativado quando o sistema controlar rastreabilidade"###"Aviso"
		lContinua := .f.
	EndIf

	If lContinua .And. (lVldQtdOP .or. lVldQtdIni .or. lCBAtuemp) .and. !lInfQeIni
		CBAlert("O parametro MV_INFQEIN deve ser ativado","Aviso",.T.,3000,2) //"O parametro MV_INFQEIN deve ser ativado"###"Aviso"
		lContinua := .f.
	EndIf

	While lContinua
		If IsTelnet() .and. VtModelo() == "RF"
			VtClear()
			@ 0,00 VtSay "Producao PCP MOD1" //"Producao PCP MOD1"
			If lOperador
				cOperador  := Space(15)
				@ 1,00 VtSay "Operador:" VtGet cOperador Valid U_AT7CBVldOpe(cOperador) //"Operador:"
			EndIf
			@ 2,00 VtSay "OP: " //"OP: "
			@ 2,04 VtGet cOP pict '@!'  Valid U_AT06OP(cOP) F3 "SH8" When Empty(cOP)
			@ 4,00 VtSay "Operacao: " //"Operacao: "
			@ 4,10 VtGet cOperacao pict '@!' Valid U_AT06OPERAC(cOP,cOperacao)
			@ 7,00 VtSay "Transacao:" //"Transacao:"
			@ 7,11 VtGet cTransac pict '@!'  Valid U_AT06VTran(cOP,cOperacao,cOperador,cTransac,.T.) F3 "CBI"
			VtRead
			If VtLastKey() == 27
				Exit
			EndIf
		EndIf
		cOP       := Space(Len(CBH->CBH_OP))
		cOperacao := Space(Len(CBH->CBH_OPERAC))
		cTransac  := Space(Len(CBH->CBH_TRANSA))
		cUltOper  := Space(Len(CBH->CBH_OPERAC))
		cPriOper  := Space(Len(CBH->CBH_OPERAC))
		cProduto  := Space(Len(SC2->C2_PRODUTO))
		nQTD      := 0
	EndDo
	If lContinua
		If IsTelnet() .and. VtModelo() == "RF"
			vtsetkey(05,bkey05)
			vtsetkey(09,bkey09)
		Else
			TerIsQuit()
		EndIf
	EndIf
	SH8->(DbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  CB023OP   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida OP informada pelo usuario                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06OP(cOP)

	If Empty(cOP)
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(23))
			Else
				//TerConPad("??") // Pendencia
			EndIf
		EndIf
		Return .f.
	EndIf

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtClearBuffer()
		Else
			TercBuffer()
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se Existe e posiciona o registro             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SC2->(DbSetOrder(1))
	If ! SC2->(DbSeek(xFilial("SC2")+cOP))
		CBAlert("OP nao cadastrada","Aviso",.T.,3000,2,.t.) //"OP nao cadastrada"###"Aviso"
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		Return .f.
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se OP e do tipo Firme                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SC2->C2_TPOP # "F"
		CBAlert("Nao e permitida movimentacao com OPs Previstas","Aviso",.T.,3000,2,.t.) //"Nao e permitida movimentacao com OPs Previstas"###"Aviso"
		If	TerProtocolo() # "PROTHEUS"
			If	IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		Return .f.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se OP ja foi encerrada                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf !Empty(SC2->C2_DATRF)
		CBAlert("OP ja Encerrada","Aviso",.T.,3000,2,.t.) //"OP ja Encerrada"###"Aviso"
		If	TerProtocolo() # "PROTHEUS"
			If	IsTelnet() .And. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		Return .f.
	EndIf

	dbSelectArea("CB7")
	dbSetOrder(5)
	If dbSeek(xFilial()+cOP)
		If 1=2 //Empty(CB7__LCALI)
			CBAlert("Material sem BUFFER, avise Abastecedor","Aviso",.T.,3000,2,.t.) //"OP ja Encerrada"###"Aviso"
			If	TerProtocolo() # "PROTHEUS"
				If	IsTelnet() .And. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				EndIf
			EndIf
			Return .f.
		EndIf	
	EndIf

	cProduto := SC2->C2_PRODUTO
	cLocPad  := SC2->C2_LOCAL
	nQtdOP   := SC2->C2_QUANT
	nQtdH6	 := SC2->C2__QTDH6
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se O total produzido para a operacao superou o  ³
	//³ total da OP                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lMod1
		SH8->(DbSetOrder(1))
		If ! SH8->(DbSeek(xFilial("SH8")+cOP))
			CBAlert("OP nao alocada pela ultima Carga Maquina","Aviso",.T.,3000,2,.t.) //"OP nao alocada pela ultima Carga Maquina"###"Aviso"
			If TerProtocolo() # "PROTHEUS"
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				EndIf
			EndIf
			Return .f.
		EndIf
		cRoteiro := SH8->H8_ROTEIRO
	Else
		If ! Empty(SC2->C2_ROTEIRO)
			cRoteiro := SC2->C2_ROTEIRO
		Else
			SB1->(DbSetorder(1))
			If SB1->(DbSeek(xFilial('SB1')+cProduto)) .And. !Empty(SB1->B1_OPERPAD)
				cRoteiro := SB1->B1_OPERPAD
			Else
				cRoteiro := StrZero(1, Len(SG2->G2_CODIGO))
			EndIf
		EndIf
	EndIf

	CBH->(DbSetOrder(2))

	lVldOper:= U_AT06VOPER(cProduto) // Verifica se valida a sequencia de operacoes

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CB023OPERAC ³ Autor ³ Anderson Rodrigues  ³ Data ³ 04/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida o get da Operacao                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06OPERAC(cOP,cOperacao,cOperador)
	Local nRecSG2:= 0
	//Local cApontMax:=""
	//Local aOperac:= U_AT06ArrOp(cProduto,cRoteiro,cOP)
	//Local nMaxOper := 0

	If Empty(cOperacao)
		Return .f.
	Endif

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			@ 5,00 VtSay Space(20)
		EndIf
	EndIf


	SG2->(DbSetOrder(1))
	If ! SG2->(DbSeek(xFilial("SG2")+cProduto+cRoteiro+cOperacao))
		CBAlert("Operacao nao encontrada no roteiro ","Aviso"	,.T.,3000,2,.t.) //"Operacao nao encontrada no roteiro "###"Aviso"
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		Return .f.
	EndIf

	If lMod1
		SH8->(DbSetOrder(1))
		If ! SH8->(DbSeek(xFilial('SH8')+Padr(cOP,Len(SH8->H8_OP))+cOperacao))
			CBAlert("Operacao nao alocada na ultima Carga Maquina","Aviso",.T.,3000,2,.t.) //"Operacao nao alocada na ultima Carga Maquina"###"Aviso"
			If TerProtocolo() # "PROTHEUS"
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				EndIf
			EndIf
			Return .f.
		EndIf
	EndIf

	/*
	|---------------------------------------------------------------------------------
	|	Validação de Operação por Operador
	|
	|	Edson Hornberger - 10/02/2016
	|---------------------------------------------------------------------------------
	*/
	DBSELECTAREA("CB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("CB1") + COPERADOR)

		IF ALLTRIM(COPERACAO) != ALLTRIM(CB1->CB1_OPERA)

			CBAlert("Operacao incorreta","Aviso",.T.,3000,2,.t.) //"Sequencia de operacao incorreta"###"Aviso"
			RETURN .F.

		ENDIF

	ENDIF

	nRecSG2  := SG2->(RECNO())
	cUltOper := U_AT06UG2(cProduto,cRoteiro) // Retorna o codigo da ultima operacao do roteiro existente no SG2
	cPriOper := U_AT06PG2(cProduto,cRoteiro) // Retorna o codigo da primeira operacao do roteiro existente no SG2
	nSldOPer :=  U_AT06Sld(cOP,cProduto,cOperacao,.T.) // Retorna o Saldo disponivel considerando a quantidade ja apontada nas operacoes anteriores

	If	U_AT06PTot(cOP,cProduto,cOperacao,cOperador,.f.)
		CBAlert("Capacidade da operacao desta OP ja esta totalizada","Aviso",.T.,3000,2,.t.) //"Capacidade da operacao desta OP ja esta totalizada"###"Aviso"
		If	TerProtocolo() # "PROTHEUS"
			If	IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		Return .f.
	EndIf

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtClearGet("cTransac")
			VtClearBuffer()
		Else
			TerCBuffer()
		EndIf
	EndIf

	SG2->(DbGoto(nRecSG2))

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			@ 5,00 VtSay Left(SG2->G2_DESCRI,20)
		EndIf
	EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ChkOperadores ³ Autor ³ Anderson Rodrigues  ³ Data ³ 13/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alimenta o Array aOperadores com os operadores ativos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkOperadores(cOP,cOperacao,cOperador)
	Local aTamQtd  := TamSx3("CBH_QTD")
	CBH->(DbSetOrder(3))
	CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
		If !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			CBH->(DbSkip())
			Loop
		EndIf
		If Alltrim(CBH->CBH_OPERADOR) == Alltrim(cOperador)
			aadd(aOperadores,{"X",CBH->CBH_OPERADOR,Str(0,aTamQtd[1],aTamQtd[2])})
		Else
			aadd(aOperadores,{" ",CBH->CBH_OPERADOR,Str(0,aTamQtd[1],aTamQtd[2])})
		EndIf
		CBH->(DbSkip())
	EndDo
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Hist  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 04/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Consulta dos Status de Monitoramento da OP                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06Hist(cOP)
	Local nX
	Local aCab   := {"O.P","Transacao","Descricao","Operacao","Quantidade"} //"O.P"###"Transacao"###"Descricao"###"Operacao"###"Quantidade"
	Local aSize  := {11,09,30,08,12}
	Local aStatOP:= {}
	Local aSave  := {}

	If IsTelnet() .and. VtModelo() == "RF"
		aSave:= VtSave()
	Else
		aSave:= TerSave()
	EndIf

	If Empty(cOP)
		CBAlert("Informe a OP !!!","Aviso",.T.,3000,2,.t.) //"Informe a OP !!!"###"Aviso"
		Return .f.
	EndIf
	aStatOP:= aSort(CBRetMonit(cOP),,,{|x,y| x[1]+x[2]+x[4] < y[1]+y[2]+y[4]})
	If Empty(aStatOP)
		Conout("Erro na tabela CBH") //"Erro na tabela CBH"
	EndIf
	For nX := 1 to Len(aStatOP)
		aSize(aStatOP[nX],5)
	Next
	If IsTelnet() .and. VtModelo() == "RF"
		VtClear()
		VTaBrowse(0,0,7,19,aCab,aStatOP,aSize)
		VtRestore(,,,,aSave)
	Else
		TerCls()
		TeraBrowse(0,0,1,19,aCab,aStatOP,aSize)
		TerRestore(,,,,aSave)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023VTran ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida o get da Transacao do Apontamento da Prod PCP MOD 1 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06VTran(cOP,cOperacao,cOperador,cTransac,lMens)
	Local cTipAtu  := Space(Len(CBH->CBH_TIPO))
	Local cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
	Local lAchou   := .f.
	Local aTela    := {}
	//Local lACD023TR
	// -- Verifica se data do Protheus esta diferente da data do sistema.
	DLDataAtu()

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			aTela:= VtSave()
		Else
			aTela:= TerSave()
		EndIf
	EndIf

	If Empty(cTransac)
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(23))
			Else
				//TerConPad("??") // Pendencia
			EndIf
		EndIf
		Return .f.
	EndIf

	aOperadores:= {}
	lConjunto  := .f.
	lFimIni    := .f.
	lAutAskUlt := .f.

	CBI->(DbSetOrder(1))
	If ! CBI->(DbSeek(xFilial("CBI")+cTransac))
		CBAlert("Transacao de Monitoramento nao cadastrada","Aviso",.T.,3000,2,.t.) //"Transacao de Monitoramento nao cadastrada"###"Aviso"
		Return .f.
	EndIf
	IF ALLTRIM(CBI->CBI_OPERAC) != ALLTRIM(COPERACAO)
		CBAlert("Transacao de Monitoramento invalida","Aviso",.T.,3000,2,.t.) //"Transacao de Monitoramento nao cadastrada"###"Aviso"
		Return .f.
	ENDIF

	// Os tipos sao: 1- inicio
	//               2- pausa c/
	//               3- pausa s/
	//               4- producao
	//               5- perda

	cTipAtu := CBI->CBI_TIPO
	CBH->(DbSetOrder(3))
	If cTipAtu == "1" //Inicio
		If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador)) .and. (Empty(CBH->CBH_DTFIM) .OR. Empty(CBH->CBH_HRFIM))
			If lMens
				CBAlert("O.P+Operacao ja iniciada pelo Operador "+cOperador,"Aviso",.T.,3000,2,.t.) //"O.P+Operacao ja iniciada pelo Operador "###"Aviso"
			EndIf
			Return .f.
		EndIf
		CB1->(DbSetOrder(1))
		If CB1->(DbSeek(xFilial("CB1")+cOperador)) .and. CB1->CB1_ACAPSM # "1" .and. ! Empty(CB1->CB1_OP+CB1->CB1_OPERAC)
			CBAlert("Operador sem permissao para executar apontamentos simultaneos","Aviso",.T.,4000,4)  //"Operador sem permissao para executar apontamentos simultaneos"###"Aviso"
			CBAlert("A operacao "+CB1->CB1_OPERAC+" da O.P. "+CB1->CB1_OP+" esta em aberto","Aviso",.T.,4000,4,.t.)  //"A operacao "###" da O.P. "###" esta em aberto"###"Aviso"
			Return .f.
		EndIf
		If lVldQtdOP .and. ! U_AT06Seq(cOperacao,.T.) // --> se a sequencia estiver incorreta e porque nao tem saldo para produzir na operacao
			Return .f.
		EndIf

		//VALIDA SALDO INICIAL NO INICIO DA PRODUCAO
		If cOperacao  =="01" .And. cTransac == "01"
			nSldOPer:= U_AT06Sld(cOP,cProduto,cOperacao,.F.) // Retorna o Saldo disponivel considerando a quantidade ja apontada nas operacoes anteriores.
			If nSldOPer <= 0
				CBAlert("Capacidade da operacao desta OP ja esta totalizada","Aviso",.T.,3000,2,.t.)
				Return .F.
			EndIf
		EndIf

		If TerProtocolo() # "PROTHEUS"
			If ! ATGrvInicio(cOP,cOperacao,cOperador,cTransac,cTipAtu)
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				Else
					TerRestore(,,,,aTela)
				EndIf
				Return .f.
			EndIf
			Return .t.
		EndIf
	Else
		If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
			CBAlert("O.P+Operacao nao iniciada pelo Operador "+cOperador,"Aviso",.T.,3000,2,.t.) //"O.P+Operacao nao iniciada pelo Operador "###"Aviso"
			Return .f.
		Endif
		While CBH->(!EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC+CBH_OPERAD) == xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador
			If ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
				CBH->(DbSkip())
				Loop
			Else
				lAchou:= .t.
				Exit
			EndIf
		Enddo
		If !lAchou
			CBAlert("O.P+Operacao nao possui inicio em aberto para o operador "+cOperador,"Aviso",.T.,3000,2,.t.) //"O.P+Operacao nao possui inicio em aberto para o operador "###"Aviso"
			Return .f.
		EndIf
		If TerProtocolo() # "PROTHEUS"
			If ! U_AT06DTHR(cOP,cOperacao,cOperador,cDataHora) // --> Verifica se a Data e Hora atuais sao validas para permitir a transacao.
				CBAlert("Database + hora atual invalidas para o operador "+cOperador,"Aviso",.T.,3000,2,.t.) //"Database + hora atual invalidas para o operador "###"Aviso"
				Return .f.
			EndIf
		EndIf
		If cTipAtu $ "23" // 2 ou 3 pausa
			If ! ATGrvPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
				If TerProtocolo() # "PROTHEUS"
					If IsTelnet() .and. VtModelo() == "RF"
						VTKeyBoard(chr(20))
					EndIf
				EndIf
				Return .f.
			EndIf
		ElseIf cTipAtu $ "45" //--> Producao ou Perda
			If CBI->CBI_CFULOP == "1" .And. cOperacao # "04"
				CBAlert("Somente a operacao de EXPEDICAO pode baixar uma OP","Aviso",.T.,5000,2,.t.) //"Para utilizar o apontamento em conjunto devem ter no minimo dois operadores trabalhando na operacao"###"Aviso"
				Return .F.
			EndIf

			If CBI->CBI_TPAPON == "2" // Operacao em conjunto
				lConjunto:= .t.
			EndIf
			If CBI->CBI_FIMINI == "1" // Indica que finaliza o inicio da operacao no ato do apontamento da mesma independente de ter atingido o saldo ou nao
				lFimIni:= .t.
			EndIf
			If !lMod1 .and. CBI->CBI_CFULOP == "1" // No caso de ser PCP MOD2 e nao validar a sequencia de operacoes a transacao confirma o apontamento como ultima operacao
				lAutAskUlt:= .t.
			EndIf
			ChkOperadores(cOP,cOperacao,cOperador)
			If lConjunto .and. Len(aOperadores) < 2
				CBAlert("Para utilizar o apontamento em conjunto devem ter no minimo dois operadores trabalhando na operacao","Aviso",.T.,5000,2,.t.) //"Para utilizar o apontamento em conjunto devem ter no minimo dois operadores trabalhando na operacao"###"Aviso"
				aOperadores:= {}
				Return .f.
			EndIf
			If ! GrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
				If TerProtocolo() # "PROTHEUS"
					If IsTelnet() .and. VtModelo() == "RF"
						VTKeyBoard(chr(20))
					EndIf
				EndIf
				Return .f.
			EndIf
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023GRV   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 04/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza gravacao dos arquivos para apontar a Producao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid,dDtIni,cHrIni,dDtFim,cHrFim,lEstorna,aCpsUsu)
	//Local nTamSX1   := Len(SX1->X1_GRUPO)
	//Local cOP2      := Padr(cOP,Len(SH6->H6_OP))
	Local cCalend   := ""
	Local cTipo     := "" 
	Local nTempoPar,nTempoTra
	Local nPos
	Local nMinutos,nTempo1,nTempo2,cTempo2
	//Local nOpcao,nOrdem
	Default cHrIni  := ""
	Default cHrFim  := Left(Time(),5)
	Default dDtIni  := CTOD("  /  /    ")
	Default dDtFim  := dDataBase
	Default lEstorna:= .f.
	Default aCpsUsu	:= {}

	If ! lEstorna
		If  TerProtocolo() # "PROTHEUS" // So entra aqui se a rotina de origem nao for Monitoramento (ACDA080)

			CBH->(DbSetOrder(3))
			If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
				If Empty(DTOS(dDtIni)+cHrIni)
					CBAlert("OP inconsistente","Aviso",.T.,3000,2) //"OP inconsistente"###"Aviso"
					DisarmTransaction()
					Break
				EndIf
			ElseIf (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI) > (DTOS(dDtIni)+cHrIni)
				dDtIni:= CBH->CBH_DTINI
				cHrIni:= CBH->CBH_HRINI
			EndIf
			If dDtIni == dDtFim .and. cHrIni == cHrFim
				cHrFim:= Left(cHrFim,3)+StrZero(Val(Right(cHrFim,2))+1,2)
				If Right(cHrFim,2) == "60"
					cHrFim:= StrZero(Val(Left(cHrFim,2))+1,2)+":00"
					If Left(cHrFim,2)== "24"
						cHrFim:= "00:00"
						dDtFim++
					EndIf
				EndIf
			EndIf
		EndIf


		cCalend := GetMV("MV_CBCALEN") // Parametro onde e informado o calendario padrao que deve ser utilizado
		If Empty(cCalend)
			cCalend := Posicione("SH1",1,xFilial("SH1")+cRecurso,"H1_CALEND")
		EndIf
		nTempoPar := U_AT06Pausa(cOP,cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDtFim,cHrFim,lEstorna)
		nTempoTra := IF(SuperGetMV("MV_USACALE",.F.,.T.),PmsHrsItvl(dDtIni,cHrIni,dDtFim,cHrFim,cCalend,"",cRecurso,.T.),A680Tempo(dDtIni,cHrIni,dDtFim,cHrFim))
		nTempo1   := nTempoTra - nTempoPar
		nTempo2   := Int(nTempo1)
		nMinutos  := (nTempo1-nTempo2)*60
		If nMinutos == 60
			nTempo2++
			nMinutos:= 0
		EndIf
		cTempo2:= StrZero(nTempo2,3)+":"+StrZero(nMinutos,2)
	EndIf

	If !lEstorna
		U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDtIni,cHrIni,dDtFim,cHrFim,cTipAtu,"ACDV023",0,nQtd,cRecurso,aCpsUsu)
		U_AT06FIM(cOP,cProduto,cOperacao,cOperador,nQtd,dDtFim,cHrFim)
	ElseIf lEstorna
		U_AT06Pausa(cOP,cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDtFim,cHrFim,lEstorna)
	EndIf

	U_AT06HrImp(cOP,cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDtFim,cHrFim,lEstorna)
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023CBH ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza gravacao do monitoramento da producao (CBH)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06CBH(cOP,cOperacao,cOperador,cTransac,nRecno,dDtIni,cHrIni,dDtFim,cHrFim,cTipAtu,cRotina,nQePrev,nQeApont,cRecurso,aCpsUsu,cLote,cNumLote,dValid)
	Local nX		:= 0
	Default dDtFim  := CTOD(" ")
	Default cHrFim  := " "
	//Default cRecurso:= " "
	Default nRecno  := 0
	Default nQePrev := 0
	Default nQeApont:= 0
	Default aCpsUsu := {}
	Default dValid  := ctod('')
	Default cLote   := Space(TamSX3("B8_LOTECTL")[1])
	Default cNumLote:= Space(TamSX3("B8_NUMLOTE")[1])

	If Empty(nRecno) // Inclusao de todas as transacoes, ou seja, Inicio, Pausa e Apontamentos
		RecLock("CBH",.T.)
		CBH->CBH_FILIAL := xFilial("CBH")
		CBH->CBH_OPERAD := cOperador
		CBH->CBH_OP     := cOP
		CBH->CBH_TRANSA := cTransac
		CBH->CBH_TIPO   := cTipAtu
		CBH->CBH_QEPREV := nQePrev
		CBH->CBH_QTD    :=  nQeApont
		CBH->CBH_DTINI  := dDtIni
		CBH->CBH_DTINV  := Inverte(dDtIni)
		CBH->CBH_HRINI  := cHrIni
		CBH->CBH_HRINV  := Inverte(cHrIni)
		CBH->CBH_DTFIM  := dDtFim
		CBH->CBH_HRFIM  := cHrFim
		CBH->CBH_OPERAC := cOperacao
		CBH->CBH_HRIMAP := " "
		CBH->CBH_LOTCTL := cLote
		CBH->CBH_NUMLOT := cNumLote
		CBH->CBH_DVALID := dValid
		If ! Empty(cRecurso)
			CBH->CBH_RECUR:= cRecurso
		EndIf
		If lMod1
			CBH->CBH_OBS:= "Incluido em "+DTOS(dDataBase)+" "+cRotina //"Incluido em "
		Else
			cRotina :="ACDV025"
			CBH->CBH_OBS:= "Incluido em "+DTOS(dDataBase)+" "+cRotina //"Incluido em "
		EndIf
		For nX := 1 to Len(aCpsUsu)
			&("CBH->"+aCpsUsu[nX]) := &("M->"+aCpsUsu[nX])
		Next nX
		CBH->(MsUnlock())

	Else // Finalizacao das Pausas ou Finalizacao do inicio
		CBH->(DbGoTo(nRecno))
		If CBH->CBH_DTINI == dDtFim .and. CBH->CBH_HRINI == cHrFim
			cHrFim:= Left(cHrFim,3)+StrZero(Val(Right(cHrFim,2))+1,2)
			If Right(cHrFim,2) == "60"
				cHrFim:= StrZero(Val(Left(cHrFim,2))+1,2)+":00"
				If Left(cHrFim,2)== "24"
					cHrFim:= "00:00"
					dDtFim++
				EndIf
			EndIf
		EndIf
		RecLock("CBH",.F.)
		CBH->CBH_DTFIM  := dDtFim
		CBH->CBH_HRFIM  := cHrFim
		CBH->CBH_QTD    += nQeApont
		For nX := 1 to Len(aCpsUsu)
			&("CBH->"+aCpsUsu[nX]) := &("M->"+aCpsUsu[nX])
		Next nX
		CBH->(MsUnlock())
	EndIf
	U_AT06CB1(cOP,cOperacao,cOperador,cTipAtu,cTransac,dDtFim)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Pausa ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe Horas com Pausa tipo 2 e 3 calcula as    ³±±
±±³          ³ mesmas e retorna o total                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06Pausa(cOP,cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDtFim,cHrFim,lEstorna)
	Local nHrsPausa := 0
	Local nTotPausa := 0
	Local nX        := 0
	Local aRecnos   := {}
	Default lEstorna:= .f.

	CBH->(DBSetOrder(5))
	CBH->(DBGoTop())
	If ! CBH->(DBSeek(xFilial("CBH")+cOP+cOperacao+cOperador))
		Return(nTotPausa)
	EndIf

	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_OPERAC+CBH_OPERADOR) == xFilial("CBH")+cOP+cOperacao+cOperador
		If CBH->CBH_TIPO $ "145" // Se nao for Pausa desconsidera
			CBH->(DbSkip())
			Loop
		EndIf
		If Empty(CBH->CBH_OPERAC)
			If !lEstorna
				CBAlert("Operacao nao informada para o registro "+CBH->(Recno()),"Aviso",.T.,3000,2,Nil) //"Operacao nao informada para o registro "###"Aviso"
			EndIf
			Return
		EndIf
		If (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI < DTOS(dDtIni)+cHrIni)
			CBH->(DBSkip()) // indica que esta fora do range de pausas
			Loop
		EndIf
		If (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM > DTOS(dDtFim)+cHrFim)
			CBH->(DBSkip()) // indica que esta fora do range de pausas
			Loop
		EndIf
		If lEstorna
			If Empty(CBH->CBH_HRIMAP)
				CBH->( DBSkip() )
				Loop
			EndIf
		Else
			If ! Empty(CBH->CBH_HRIMAP)
				CBH->( DBSkip() )
				Loop
			Endif
			If Empty(CBH->CBH_DTFIM)
				CBH->( DBSkip() )
				Loop
			EndIf
		EndIf
		cCalend   := GetMV("MV_CBCALEN") // Parametro onde e informado o calendario padrao que deve ser utilizado
		If Empty(cCalend)
			cCalend:= Posicione("SH1",1,xFilial("SH1")+cRecurso,"H1_CALEND")
		EndIf
		nHrsPausa:= IF(SuperGetMV("MV_USACALE",.F.,.T.),CBH->(PmsHrsItvl(CBH_DTINI,CBH_HRINI,CBH_DTFIM,CBH_HRFIM,cCalend,"",cRecurso,.T.)),CBH->(A680Tempo(CBH_DTINI,CBH_HRINI,CBH_DTFIM,CBH_HRFIM)))
		nTotPausa += nHrsPausa
		If CBH->CBH_TIPO == "3" // aqui deve guardar para flegar somente o tipo 3, pois o Tipo 2 deve ser flegado somente no apontamento de horas improdutivas
			aadd(aRecnos,CBH->(Recno()))
		EndIf
		CBH->(DBSkip())
	EndDo
	If !Empty(aRecnos)
		For nX := 1 to Len(aRecnos)
			CBH->(DbGoTo(aRecnos[nX]))
			RecLock("CBH",.F.)
			If lEstorna
				CBH->CBH_HRIMAP := " "
			Else
				CBH->CBH_HRIMAP := "1"
			EndIf
			CBH->(MsUnlock())
		Next
	EndIf
Return(nTotPausa)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023HrImp ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se existe Horas improdutivas para serem gravadas  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06HrImp(cOP,cOperacao,cRecurso,cOperador,dDataDe,cHoraDe,dDataAte,cHoraAte,lEstorna)
	Local lInicio
	Local dDtini,dData1,dData2
	Local cHrini,cHora1,cHora2
	Local nHrsImp,nTotHrImp1
	Local cTransac,cCalend
	Local cTipo
	Local nRecCBH,nX,nMinutos
	Local aRecnos  := {}
	Default lEstorna:= .f.

	cTipo := "2" // -> Totaliza todas as pausas do tipo 2 para realizar o apontamento das horas improdutivas.
	nTotHrImp1 := 0

	CBH->(DBSetOrder(3))
	If ! CBH->(DBSeek(xFilial("CBH")+cOP+cTipo+cOperacao+cOperador))
		Return
	EndIf

	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC+CBH_OPERADOR) == xFilial("CBH")+cOP+cTipo+cOperacao+cOperador

		lInicio := .t.
		cTransac:= CBH->CBH_TRANSA
		While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC+CBH_TRANSA) ==;
		xFilial("CBH")+cOP+cTipo+cOperacao+cTransac
			If lEstorna
				If Empty(CBH->CBH_OPERAC)
					MsgAlert("Operacao nao informada para o registro "+CBH->(Recno())) //"Operacao nao informada para o registro "
					Return
				EndIf
			Else
				If Empty(CBH->CBH_OPERAC)
					CBAlert("Operacao nao informada para o registro "+CBH->(Recno()),"Aviso",.T.,3000,2,Nil) //"Operacao nao informada para o registro "###"Aviso"
					Return
				EndIf
			EndIf
			If (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI < DTOS(dDataDe)+cHoraDe)
				CBH->(DBSkip()) // indica que esta fora do range para o apontamento das horas improdutivas
				Loop
			Endif
			If (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM > DTOS(dDataAte)+cHoraAte)
				CBH->(DBSkip()) // indica que esta fora do range para o apontamento das horas improdutivas
				Loop
			EndIf
			If lEstorna
				If Empty(CBH->CBH_HRIMAP)
					CBH->( DBSkip() )
					Loop
				EndIf
			Else
				If ! Empty(CBH->CBH_HRIMAP)
					CBH->(DBSkip())
					Loop
				EndIf
				If Empty(CBH->CBH_DTFIM)
					CBH->(DBSkip())
					Loop
				EndIf
			EndIf
			If lInicio
				lInicio:= .f.
				dDtini := CBH->CBH_DTINI
				cHrini := CBH->CBH_HRINI
			EndIf
			dDtini    := If(CBH->CBH_DTINI < dDtini,CBH->CBH_DTINI,dDtini)
			cHrini    := If(CBH->CBH_HRINI < cHrini,CBH->CBH_HRINI,cHrini)
			dData1    := CBH->CBH_DTINI
			cHora1    := CBH->CBH_HRINI
			dData2    := CBH->CBH_DTFIM
			cHora2    := CBH->CBH_HRFIM
			cCalend   := GetMV("MV_CBCALEN") // Parametro onde e informado o calendario padrao que deve ser utilizado
			If Empty(cCalend)
				cCalend:= Posicione("SH1",1,xFilial("SH1")+cRecurso,"H1_CALEND")
			EndIf
			nHrsImp   := IF(SuperGetMV("MV_USACALE",.F.,.T.),PmsHrsItvl(dData1,cHora1,dData2,cHora2,cCalend,"",cRecurso,.T.),A680Tempo(dData1,cHora1,dData2,cHora2))
			nTotHrImp1:= nTotHrImp1 + nHrsImp
			aadd(aRecnos,CBH->(Recno()))
			CBH->(DBSkip())
			nRecCBH   := CBH->(Recno())
		EndDo
		CBH->(DBSkip())
	Enddo
	If !Empty(aRecnos)
		For nX := 1 to Len(aRecnos)
			CBH->(DbGoTo(aRecnos[nX]))
			RecLock("CBH",.F.)
			If lEstorna
				CBH->CBH_HRIMAP := " "
			Else
				CBH->CBH_HRIMAP := "1"
			EndIf
			CBH->(MsUnlock())
		Next
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CB023PTot  ³ Autor ³ Anderson Rodrigues    ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se a Producao para a Operacao ja foi totalizada     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAACD                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06PTot(cOP,cProduto,cOperacao,cOperad2,lAponta)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MV_GANHOPR - Parametro utilizado para verificar se NAO permite o conceito   ³
	//|              de "Ganho de Producao" na inclusao do apontamento de Producao. |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lGanhoProd:= SuperGetMV("MV_GANHOPR",.F.,.T.)
	Local nPos      := 0
	Default lAponta := .t.

	If lFimIni .And. lAponta
		CBH->(DbSetOrder(3))
		If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperad2)) .or. ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			Return .f.
		Else
			If cOperador == cOperad2
				Return .t.
			EndIf
			VtClear()
			VtSay(2,0,"Aguarde AT06SLD...")

			nSldOPer:= U_AT06Sld(cOP,cProduto,cOperacao,.T.) // Retorna o Saldo disponivel considerando a quantidade ja apontada nas operacoes anteriores.
			If nSldOPer <= 0
				Return .t.
			Else
				Return .f.
			EndIf
		EndIf
	EndIf

	If lAponta // Se ja apontou atualiza o saldo disponivel
		VtClear()
		VtSay(2,0,"Aguarde AT06SLD...") 

		nSldOPer:= U_AT06Sld(cOP,cProduto,cOperacao,.T.) // Retorna o Saldo disponivel considerando a quantidade ja apontada nas operacoes anteriores
	Endif

	If nSldOPer <= 0
		If	lGanhoProd
			If	lAponta
				Return .f.
			Else
				CBAlert("Capacidade da operacao desta OP ja esta totalizada","Aviso",.T.,3000,2,.t.) //"Capacidade da operacao desta OP ja esta totalizada"###"Aviso"
				If VTYesNo("Continua apontamento da producao?","Aviso",.T.)
					Return .f.
				EndIf
			EndIf
		EndIf
		Return .t.
	EndIf

	If lInfQeIni .And. lAponta
		CBH->(DbSetOrder(3))
		If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperad2)) .or. ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			Return .f.
		ElseIf (CBH->CBH_QTD > 0 .and. CBH->CBH_QTD >= CBH->CBH_QEPREV)
			Return .t.
		ElseIf lConjunto
			nPos:= Ascan(aOperadores,{|x| x[2] == cOperad2})
			If nPos > 0 .and. ! Empty(aOperadores[nPos,1]) .and. (CBH->CBH_QTD == 0 .and. CBH->CBH_QEPREV == 0)
				Return .t.
			EndIf
		ElseIf (CBH->CBH_QTD == 0 .and. CBH->CBH_QEPREV == 0 .and. CBH->CBH_OPERAD == cOperador) // aqui verifica o operador que esta logado
			Return .t.
		EndIf
	EndIf
Return .f.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023UG2   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a ultima operacao do roteiro de operacoes - SG2    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06UG2(cProduto,cRoteiro)
	Local cOperac:= " "

	SG2->(DbSetOrder(1))
	If SG2->(DbSeek(xFilial("SG2")+cProduto+cRoteiro))
		While ! SG2->(Eof()) .and. SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO) == xFilial("SG2")+cProduto+cRoteiro
			cOperac := SG2->G2_OPERAC
			SG2->(DbSkip())
		Enddo
	EndIf
Return cOperac



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Sld   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o saldo para validacao da qtd do apontamento       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06Sld(cOP,cProduto,cOperacao,lApont)
	Local nSaldo     := 0
	//Local nSldComp	:= 0

	l4Pecas := .F.
	nRest4	:= 0
	//TAIFF - NA PRIMEIRA OPERACAO RETORNA SEMPRE O SALDP DA OP - 1 PECA
	If !lApont //INICIO OPERACAO
		nSaldo:= (nQtdOP- nQtdH6) 
	Else
		nSaldo:= 1
	EndIf

	If (nQtdOP- nQtdH6) <= 4	//.And. lApont				
		l4Pecas := .T.
		nRest4	:= (nQtdOP- nQtdH6)
	Endif		
Return(nSaldo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³  CB023AUX  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 12/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao auxiliar chamada pela Funcao GrvConjunto()          ³±±
±±³          ³ Marcacao dos operadores que devem ter apontamento feito    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06AUX(modo,nElem,nElemW)

	If modo == 1
	Elseif modo == 2
	Else
		If VTLastkey() == 27
			Return 0
		ElseIf VTLastkey() == 13
			If aOperadores[nElem,1] == " "
				CBH->(DbSetOrder(3))
				CBH->(DbSeek(xFilial("CBH")+cOP+"2"+cOperacao+aOperadores[nElem,2],.t.))
				While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP
					If CBH->CBH_OPERADOR # aOperadores[nElem,2]
						CBH->(DbSkip())
						Loop
					EndIf
					If CBH->CBH_OPERAC == cOperacao .and. CBH->CBH_TIPO $ "23" .and. Empty(CBH->CBH_DTFIM)
						CBAlert("Operacao em pausa para o operador, Verifique !!!","Aviso",.T.,3000,2) //"Operacao em pausa para o operador, Verifique !!!"###"Aviso"
						Return 2
					EndIf
					CBH->(DbSkip())
				Enddo
				aOperadores[nElem,1] :="X" // Se passou pela validacao pode selecionar
			Else
				If aOperadores[nElem,2] # cOperador
					aOperadores[nElem,1] := " "
				EndIf
			EndIf
			If IsTelnet() .and. VtModelo() == "RF"
				VTaBrwRefresh()
			Else
				TeraBrwRefresh()
			EndIf
			Return 2
		EndIf
	EndIf
Return 2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Rec   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida se o Recurso informado existe no roteiro de operacoes ³±±
±±³          ³	Obs: Funcao utilizada no RF, Microterminal e Protheus       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06Rec(cOP,cOperacao,cRecurso,cTipo)
	//Local nACD023QE:= 0
	Local aTela    := {}
	Local lRet     := .t.

	If Empty(cRecurso)
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(23))
			Else
				//TerConPad("??") // Pendencia
			EndIf
		EndIf
		Return .f.
	EndIf

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			aTela:= VtSave()
		Else
			aTela:= TerSave()
		EndIf
	EndIf

	SH1->(DbSetOrder(1))
	If ! SH1->(DbSeek(xFilial("SH1")+cRecurso))
		CBAlert("Recurso nao cadastrado","Aviso",.T.,3000,2,.t.) //"Recurso nao cadastrado"###"Aviso"
		Return .f.
	EndIf


	/*
	If ExistBlock("ACD023RC")
	lACD023RC := ExecBlock('ACD023RC',.F.,.F.,{cOp,cOperacao,cOperador,cRecurso,lRet})  //Retorno .F. para nao validar o recurso informado
	If ValType(lACD023RC)== "L"
	lRet := lACD023RC
	EndIf
	EndIf
	*/
	If ! lRet
		CBAlert("Recurso Invalido","Aviso",.T.,3000,2,.t.) //"Recurso Invalido"###"Aviso"
		Return .f.
	EndIf

	If cTipo $ "23" // Tratamento para Pausas
		If TerProtocolo() == "PROTHEUS"
			Return .t.
		Else
			If CBYesNo("Confirma o recurso"+chr(13)+cRecurso+" - "+Left(SH1->H1_DESCRI,20),"ATENCAO",.T.) //"Confirma o recurso"#"ATENCAO"
				Return .t.
			EndIf
			If IsTelnet() .and. VtModelo() == "RF"
				VtRestore(,,,,aTela)
			Else
				TerRestore(,,,,aTela)
			EndIf
			Return .f.
		EndIf
	EndIf

	If !lSGQTDOP
		Return .t.
	Endif
	/*
	If ExistBlock("ACD023QE") // Ponto de Entrada para inicializacao da quantidade a ser apontada
	If TerProtocolo() # "PROTHEUS"
	nACD023QE:= ExecBlock("ACD023QE",.F.,.F.,{cOp,cOperacao,cRecurso,cOperador,nQtd})
	nQtd:= nACD023QE
	Else
	nACD023QE:= ExecBlock("ACD023QE",.F.,.F.,{M->CBH_OP,M->CBH_OPERAC,M->CBH_RECUR,M->CBH_OPERAD,M->CBH_QTD})
	M->CBH_QTD:= nACD023QE
	EndIf
	Else // Se nao existir o Ponto de Entrada para iniciar a quantidade a mesma e iniciada com o saldo da operacao
	*/
	If TerProtocolo() # "PROTHEUS"
		nQtd:= nSldOper
		//TAIFF
		If nQtd > 0 .And. cOperacao == "01"
			nQtd:= 1
		EndIf
	Else
		M->CBH_QTD:= nSldOper
	EndIf
	//EndIf
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtRestore(,,,,aTela)
			VtClearBuffer()
		Else
			TerRestore(,,,,aTela)
			TerCBuffer()
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Seq   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a sequencia das operacoes de acordo com o roteiro   ³±±
±±³          ³	informado na O.P                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06Seq(cOperacao,lInicio)
	Default lInicio := .f.
	If Empty(cUltApont)
		If cOperacao # cPriOper .and. ! lInicio
			CBAlert("Sequencia de operacao incorreta","Aviso",.T.,3000,2,.t.) //"Sequencia de operacao incorreta"###"Aviso"
			Return .f.
		Else
			Return .t.
		EndIf
	EndIf
	If cUltApont # cUltOper
		SG2->(DbSetOrder(1))
		If SG2->(DbSeek(xFilial("SG2")+cProduto+cRoteiro+cUltApont))
			SG2->(DbSkip())
			If SG2->G2_FILIAL+SG2->G2_PRODUTO+SG2->G2_CODIGO # xFilial("SG2")+cProduto+cRoteiro
				CBAlert("Operacao invalida para esta OP","Aviso",.T.,3000,2,.t.) //"Operacao invalida para esta OP"###"Aviso"
				Return .f.
			EndIf
			If cOperacao > SG2->G2_OPERAC
				CBAlert("Sequencia de operacao incorreta","Aviso",.T.,3000,2,.t.) //"Sequencia de operacao incorreta"###"Aviso"
				Return .f.
			EndIf
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Qtd   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida as quantidades requisitadas x quantidade a ser apontada³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06Qtd(cOP,cOperacao,cOperador,nQTD,lInicio)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ MV_GANHOPR - Parametro utilizado para verificar se NAO permite o conceito   ³
	//|              de "Ganho de Producao" na inclusao do apontamento de Producao. |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local lGanhoProd:= SuperGetMV("MV_GANHOPR",.F.,.T.)
	//Local lACD023VQ := ExistBlock("ACD023VQ")
	//Local lRetBkp
	Local lRet      := .T.
	Default lInicio := .F.

	If lInicio .and. ! lVldQtdOP // Nao valida a quantidade a ser produzida com a quantidade da OP no inicio da OP+Operacao
		lRet := .T.
	Else
		If	lGanhoProd
			lRet := .T.
		ElseIf lInicio // --> Indica que a transacao e do tipo 1 --> Inicio da OP+Operacao
			If ! VldQtdOP(cOP,cOperacao,nQtd) // Valida a quantidade a ser iniciada com a OP e o Saldo da Producao
				lRet := .F.
			EndIf
		ElseIf lVldQtdIni // --> Validacao quando a transacao for do tipo 4 ou 5 --> Apontamento de Producao e/ou Perda
			If ! VldQeComIni(cOP,cOperacao,cOperador,nQtd,lInicio)
				lRet := .F.
			EndIf
		EndIf
		/*
		If lRet .And. (nQtd >= nSldOPer) .and. (Len(aOperadores) > 1) .and. ! lConjunto
		CBAlert("Existem outros operadores em andamento nesta operacao, a quantidade informada finaliza o saldo da operacao","Aviso",.T.,Nil,2,Nil) //"Existem outros operadores em andamento nesta operacao, a quantidade informada finaliza o saldo da operacao"###"Aviso"
		lRet := .F.
		Endif
		*/
	EndIf
	/*
	If lRet .And. lACD023VQ
	lRetBkp := lRet
	lRet := ExecBlock('ACD023VQ',.F.,.F.,{cOP,cOperacao,cOperador,nQTD,lInicio})  //Retorno .F. para nao validar a quantidade informada
	If ValType(lRet)!= "L"
	lRet := lRetBkp
	EndIf
	Endif
	*/
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldQtdOP   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 10/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a quantidade a ser iniciada com o saldo da Operacao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldQtdOP(cOP,cOperacao,nQtd)
	Local nSldCBH := 0
	Local nSaldo  := 0

	//Valida quantidade zerada
	If nQtd = 0
		If TerProtocolo() == "PROTHEUS"
			MsgAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao"+". "+"O saldo disponivel e  ---> "+Str(nSldOper,16,2))
		Else
			CBAlert("Quantidade 0 informada para o inicio da operacao","Aviso",.T.,4000,2,Nil) //"Quantidade maior do que o saldo disponivel para o inicio da operacao"###"Aviso"
			CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,4000,Nil,Nil) //"O saldo disponivel e  ---> "###"Aviso"
		EndIf
		Return .f.
	Endif

	If nQtd > nSldOPer
		If TerProtocolo() == "PROTHEUS"
			MsgAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao"+". "+"O saldo disponivel e  ---> "+Str(nSldOper,16,2))
		Else
			CBAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao","Aviso",.T.,4000,2,Nil) //"Quantidade maior do que o saldo disponivel para o inicio da operacao"###"Aviso"
			CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,4000,Nil,Nil) //"O saldo disponivel e  ---> "###"Aviso"
		EndIf
		Return .f.
	EndIf

	nSldCBH:= CBSldCBH(cOP,cOperacao) // Retorna a quantidade de producao iniciada para a operacao anterior a atual

	If nSldCBH > 0 .and. nQtd > nSldCBH
		nSaldo:= (nSldCBH	- nQtd)
		If nSaldo < 0
			nSaldo:= 0
		EndIf
		If nSaldo == 0 .and. nQtd == 0
			Return .t.
		EndIf
		If TerProtocolo() == "PROTHEUS"
			MsgAlert("Quantidade a ser iniciada e maior do que a quantidade do inicio da Operacao anterior"+". "+"O saldo disponivel e  ---> "+Str(nSaldo,16,2))
		Else
			CBAlert("Quantidade a ser iniciada e maior do que a quantidade do inicio da Operacao anterior","Aviso",.T.,4000,2,Nil) //"Quantidade a ser iniciada e maior do que a quantidade do inicio da Operacao anterior"###"Aviso"
			CBAlert("O saldo disponivel e  ---> "+Str(nSaldo,16,2),"Aviso",.t.,4000,Nil,Nil) //"O saldo disponivel e  ---> "###"Aviso"
		EndIf
		Return .f.
	EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldQeComIni³ Autor ³ Anderson Rodrigues  ³ Data ³ 10/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a quantidade do apontamento com a quantidade 		  ³±±
±±³			 ³ informada no inicio da Producao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldQeComIni(cOP,cOperacao,cOperador,nQtd,lInicio)
	Local nQtdPrev:= 0

	CBH->(DBSetOrder(3))
	If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
		nQtdPrev:= (CBH->CBH_QEPREV-CBH->CBH_QTD)
		If (Empty(DTOS(CBH->CBH_DTFIM)+(CBH->CBH_HRFIM))) .and. (nQtd > nQtdPrev) // Quantidade Prevista
			If TerProtocolo() == "PROTHEUS"
				MsgAlert("Quantidade maior do que o saldo previsto no inicio da operacao"+". "+"O saldo disponivel e  ---> "+Str(nQtdPrev,16,2))
			Else
				CBAlert("Quantidade maior do que o saldo previsto no inicio da operacao","Aviso",.T.,4000,2,Nil) //"Quantidade maior do que o saldo previsto no inicio da operacao"###"Aviso"
				CBAlert("O saldo disponivel e  ---> "+Str(nQtdPrev,16,2),"Aviso",.t.,4000,Nil,Nil) //"O saldo disponivel e  ---> "###"Aviso"
			EndIf
			Return .f.
		EndIf
	EndIf
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Apont ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna as quantidades de apontamentos iniciados que estao ³±±
±±³          ³ em aberto para a Operacao atual                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06Apont(cOP,cOperacao)	// --> O parametro lFim determina se ira considerar os inicios ja encerrados e
	Local nQtdIni := 0							//     as quantidades ja apontadas para cada inicio em aberto
	Local nTotIni := 0

	CBH->(DbSetOrder(3))

	If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
		Return(nTotIni)
	EndIf

	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
		If ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			CBH->(DbSkip())
			Loop
		EndIf
		nQtdIni+= (CBH->CBH_QEPREV - CBH->CBH_QTD)
		If	nQtdIni < 0  // deve ser feita esta verificacao, pois no caso de nao validar a qtd apontada com a iniciada a
			nQtdIni := 0 // qtd apontada pode ser maior e neste caso o nQtdIni ficara negativo
		EndIf
		nTotIni += nQtdIni
		CBH->(DbSkip())
	Enddo
Return(nTotIni)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CBSldCBH   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 28/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a quantidade de producao iniciada e que esta em    ³±±
±±³          ³ aberto para a operacao atual                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CBSldCBH(cOP,cOperacao)
	Local nSldPar:= 0
	Local nSldTot:= 0

	CBH->(DbSetOrder(3)) // Filial+OP+Tipo+Operacao
	If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
		Return(nSldTot)
	EndIf
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
		nSldPar:= (CBH->CBH_QEPREV - CBH->CBH_QTD)
		If nSldPar < 0
			nSldPar:= 0
		EndIf
		nSldTot+= nSldPar
		CBH->(DbSkip())
	Enddo
Return(nSldTot)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvPausa   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 03/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao das Paradas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ATGrvPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
	//Local cRecurso:= Space(Len(CBH->CBH_RECUR))
	Local aTela   := {}
	// analisando a pausa em aberto
	CBH->(DbSetOrder(3))
	CBH->(DbSeek(xFilial("CBH")+cOP+"2",.t.))
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP .and. CBH->CBH_TIPO $ "23"
		If ! Empty(CBH->CBH_DTFIM)  //pausa nao esta ativa, nao me enteressa
			CBH->(DbSkip())
			Loop
		EndIf
		If cOperador # CBH->CBH_OPERADOR
			CBH->(DbSkip())
			Loop
		EndIf
		If cOperacao # CBH->CBH_OPERAC
			CBH->(DbSkip())
			Loop
		EndIf
		If TerProtocolo() # "PROTHEUS" // Se for RF e Microterminal so reclama se a transacao for diferente
			If CBH->CBH_TRANSA # cTransac
				CBAlert("Operacao ja encontra-se pausada pela transacao "+CBH->CBH_TRANSA,"Aviso",.T.,4000,2) //"Operacao ja encontra-se pausada pela transacao "###"Aviso"
				Return .f.
			EndIf
		Else // se for Protheus nao permite nova pausa se qualquer outra estiver em aberto, pois a mesma deve ser finaliada atraves da opcao de alteracao do Monitoramento
			CBAlert("Operacao ja encontra-se pausada pela transacao "+CBH->CBH_TRANSA,"Aviso",.T.,4000,2) //"Operacao ja encontra-se pausada pela transacao "###"Aviso"
			Return .f.
		EndIf
		CBH->(DbSkip())
	Enddo

	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			aTela := VtSave()
		Else
			aTela := TerSave()
		EndIf
	EndIf

	CBH->(DbSetOrder(1))
	If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTransac+cTipAtu+cOperacao+cOperador)) .OR. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VtClear()
				@ 0,00 VtSay "Inicio da Pausa" //"Inicio da Pausa"
			EndIf
		EndIf
	Else
		CB1->(DbSetOrder(1))
		If CB1->(DbSeek(xFilial("CB1")+cOperador)) .and. CB1->CB1_ACAPSM # "1" .and. ! Empty(CB1->CB1_OP+CB1->CB1_OPERAC)
			If (cOP+cOperacao) # (CB1->CB1_OP+CB1->CB1_OPERAC)
				CBAlert("Operador sem permissao para executar apontamentos simultaneos","Aviso",.T.,4000,4)  //"Operador sem permissao para executar apontamentos simultaneos"###"Aviso"
				CBAlert("A operacao "+CB1->CB1_OPERAC+" da O.P. "+CB1->CB1_OP+" esta em aberto","Aviso",.T.,4000,4,.t.)  //"A operacao "###" da O.P. "###" esta em aberto"###"Aviso"
				Return .f.
			EndIf
		EndIf
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VtClear()
				@ 0,00 VtSay "Termino da Pausa" //"Termino da Pausa"
			EndIf
		EndIf
	EndIf

	If TerProtocolo() == "PROTHEUS"
		Return .t. // Se for Protheus nao faz o bloco abaixo
	EndIf

	SH8->(DbSetOrder(1))
	If lMod1 .And. SH8->(DbSeeK(xFilial("SH8")+padr(cOP,TAMSX3("H8_OP")[1])+cOperacao))
		cRecurso := SH8->H8_RECURSO
	EndIf

	If IsTelnet() .and. VtModelo() == "RF" .And. Empty(cRecurso)

		@ 2,00 VtSay "Recurso3: " //"Recurso: "
		@ 2,10 VtGet cRecurso  pict '@!' Valid U_AT06Rec(cOP,cOperacao,@cRecurso,cTipAtu)  F3 "SH1"
		VtRead
		VtRestore(,,,,aTela)
		If VtLastKey() == 27
			Return .f.
		EndIf
	EndIf

	CBH->(DbSetOrder(1))
	If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTransac+cTipAtu+cOperacao+cOperador))
		U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",Nil,Nil,cRecurso)
	ElseIf ! EMPTY(CBH->CBH_DTINI) .and. EMPTY(CBH->CBH_DTFIM) .and. (CBH->CBH_TRANSA == cTransac) .and. (CBH->CBH_OPERAC == cOperacao) .and. (CBH->CBH_OPERADOR == cOperador)
		U_AT06CBH(cOP,cOperacao,cOperador,cTransac,CBH->(Recno()),CBH->CBH_DTINI,CBH->CBH_HRINI,dDataBase,Left(Time(),5),cTipAtu,"ACDV023",Nil,Nil,cRecurso)
	Else
		U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",Nil,Nil,cRecurso)
	EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvPRPD    ³ Autor ³ Anderson Rodrigues  ³ Data ³ 03/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa se faz apontamento de perda ou de producao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)

	If lVldOper
		If ! U_AT06Seq(cOperacao)
			Return .f.
		EndIf
	EndIf

	CBH->(DbSetOrder(3))
	CBH->(DbSeek(xFilial("CBH")+cOP+"2"+cOperacao+cOperador,.t.))
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP
		If CBH->CBH_OPERADOR # cOperador
			CBH->(DbSkip())
			Loop
		EndIf
		If CBH->CBH_OPERAC == cOperacao .and. CBH->CBH_TIPO $ "23" .and. Empty(CBH->CBH_DTFIM)
			CBAlert("Operacao em pausa","Aviso",.T.,3000,2) //"Operacao em pausa"###"Aviso"
			If TerProtocolo() # "PROTHEUS"
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				EndIf
			EndIf
			Return .f.
		EndIf
		CBH->(DbSkip())
	Enddo

	If TerProtocolo() == "PROTHEUS"
		Return .t. // Se for Protheus nao executa o bloco abaixo
	EndIf

	If cTipAtu == "4"
		If ! ATGrvProd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	Else
		If ! GrvPerda(cOP,cOperacao,cOperador,cTransac,cTipAtu)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvProd    ³ Autor ³ Anderson Rodrigues  ³ Data ³ 03/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao do apontamento da Producao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ATGrvProd(cOP,cOperacao,cOperador,cTransac,cTipAtu)

	Local aTela   := {}
	//Local cRecurso:= Space(Len(CBH->CBH_RECUR))
	Local cPictQtd:= PesqPict("CBH","CBH_QTD")
	Local cLote    := Space(TamSX3("CBH_LOTCTL")[1])
	Local dValid   := ctod('')
	Local lVolta  	:= .f.
	Local lMens 	:= .T. //MOSTRA MENSAGEM DE CONFIRMACAO
	Local lContinua	:= .T. //OPCAO PARA OS CASOS DE CONFIRMACAO DA MENSAGEM

	If IsTelnet() .and. VtModelo() == "RF"
		aTela:= VtSave()
	Else
		aTela:= TerSave()
	EndIf
	nQtd:= 0
	SH8->(DbSetOrder(1))
	While .t.
		If IsTelnet() .and. VtModelo() == "RF" .And. Empty(CRECURSO)
			VtClear()
			VtClearBuffer()
			CRECURSO := SPACE(5)
			If lMod1 .And. SH8->(DbSeeK(xFilial("SH8")+padr(cOP,TAMSX3("H8_OP")[1])+cOperacao))
				cRecurso := SH8->H8_RECURSO
			EndIf
			@ 0,00 VtSay "Apontamento Producao" //"Apontamento Producao"
			@ 2,00 VtSay "Recurso1: " //"Recurso: "
			@ 2,10 VtGet cRecurso  pict 'XXXXX' Valid U_AT06Rec(cOP,cOperacao,@cRecurso,cTipAtu,nQtd) F3 "SH1" //When Empty(cRecurso)
			VtRead
			If VtLastKey() == 27
				Exit
			EndIf
		EndIf
		If !Empty(cRecurso) .AND. COPERACAO != "01"
			If IsTelnet() .and. VtModelo() == "RF"
				VtClearBuffer()
				@ 5,00 VtSay "Quantidade: " //"Quantidade: "
				@ 6,00 VtGet nQTD Pict cPictQtd Valid U_AT06Qtd(cOP,cOperacao,cOperador,nQTD)
				VtRead
			EndIf
		ELSEIF !Empty(cRecurso) .AND. COPERACAO = "01"

			nQTD := 1
			U_AT06Qtd(cOP,cOperacao,cOperador,nQTD,.T.)

		EndIf
		If IsTelnet() .and. VtModelo() == "RF"
			If VtLastKey() == 27
				Exit
			EndIf
		EndIf
		Geralote(@cLote,@dValid,@lVolta)
		If lVolta
			nQTD := 0
			VtClearGet("nQTD")
			lVolta := .f.
			Loop
		EndIf
		/*
		If ExistBlock("ACD023PR")        // Validacao antes da confirmacao do apontamento da producao
		If ! ExecBlock("ACD023PR",.F.,.F.,{cOp,cOperacao,cRecurso,cOperador,nQtd,cTransac,cLote})
		Loop
		EndIf
		EndIf
		*/
		//PARA A TRANSACAO 01 NAO MOSTRA PERGUNTAS
		If cOperacao == "01"
			lMens 		:= .F.
			lContinua 	:= .T.
		EndIf	

		//PARA OS CASOS QUE MOSTRA A MENSAGEM
		If lMens			
			If CBYesNo("Confirma o Apontamento de Producao da OP?","ATENCAO",.T.)
				lContinua 	:= .T.
			Else
				lContinua 	:= .F.
			EndIf			
		EndIf 	


		If lContinua
			Begin transaction
				If lConjunto
					If ! GrvConjunto(cOP,cOperacao,cOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
						lVolta := .t.
					EndIf
				Else
					If lMod1
						If ! U_AT06GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
							lVolta := .t.
						Endif
					Else
						If ! U_ATCB065GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
							lVolta := .t.
						EndIf
					EndIf
				EndIf
			End Transaction
			If lVolta
				nQTD := 0
				VtClearGet("nQTD")
				lVolta := .f.
				Loop
			EndIf
			If lMSErroAuto
				VTDispFile(NomeAutoLog(),.t.)
			EndIf
		Else
			nQTD := 0
			VtClearGet("nQTD")
			Loop
		EndIf
		Exit
	Enddo
	If IsTelnet() .and. VtModelo() == "RF"
		If VtLastKey() == 27
			VtRestore(,,,,aTela)
			Return .f.
		EndIf
	Else
		If TerEsc()
			TerRestore(,,,,aTela)
			Return .f.
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvPerda   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 03/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao do apontamento de Perda                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvPerda(cOP,cOperacao,cOperador,cTransac,cTipAtu)
	Local aTela   := {}
	//Local cRecurso:= Space(Len(CBH->CBH_RECUR))
	Local cPictQtd:= PesqPict("CBH","CBH_QTD")
	Local cLote    := Space(10)
	Local dValid   := ctod('')
	Local lVolta  := .f.

	If IsTelnet() .and. VtModelo() == "RF"
		aTela:= VtSave()
	Else
		aTela:= TerSave()
	EndIf
	nQtd     := 0
	SH8->(DbSetOrder(1))
	While .t.
		If IsTelnet() .and. VtModelo() == "RF" .And. Empty(cRecurso)
			VtClear()
			VtClearBuffer()
			If lMod1 .And. SH8->(DbSeeK(xFilial("SH8")+padr(cOP,TAMSX3("H8_OP")[1])+cOperacao))
				cRecurso := SH8->H8_RECURSO
			EndIf
			@ 0,00 VtSay "Apontamento Perda" //"Apontamento Perda"
			@ 2,00 VtSay "Recurso2: " //"Recurso: "
			@ 2,10 VtGet cRecurso  pict '@!' Valid U_AT06Rec(cOP,cOperacao,cRecurso,cTipAtu,nQtd) F3 "SH1" //When Empty(cRecurso)
			VtRead
			If VtLastKey() == 27
				Exit
			EndIf
		EndIf
		If !Empty(cRecurso)
			If IsTelnet() .and. VtModelo() == "RF"
				VtClearBuffer()
				@ 5,00 VtSay "Quantidade: " //"Quantidade: "
				@ 6,00 VtGet nQTD Pict cPictQtd Valid U_AT06Seq(cOP,cOperacao,cOperador,nQTD)
				VtRead()
			EndIf
		EndIf
		If IsTelnet() .and. VtModelo() == "RF"
			If VtLastKey() == 27
				Exit
			EndIf
		EndIf
		Geralote(@cLote,@dValid,@lVolta)
		If lVolta
			nQTD := 0
			VtClearGet("nQTD")
			lVolta := .f.
			Loop
		EndIf
		/*
		If ExistBlock("ACD023PR")        // Validacao antes da confirmacao do apontamento da producao
		If ! ExecBlock("ACD023PR",.F.,.F.,{cOp,cOperacao,cRecurso,cOperador,nQtd,cTransac,cLote})
		Loop
		EndIf
		EndIf
		*/
		If CBYesNo("Confirma o Apontamento de Perda da OP?","ATENCAO",.T.) //"Confirma o Apontamento de Perda da OP?"###"ATENCAO"
			Begin transaction
				If lConjunto
					If ! GrvConjunto(cOP,cOperacao,cOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
						lVolta := .t.
					EndIf
				Else
					If lMod1
						If ! U_AT06GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
							lVolta := .t.
						EndIf
					Else
						If ! U_ATCB065GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
							lVolta := .t.
						EndIf
					EndIf
				EndIf
			End Transaction
			If lVolta
				lVolta := .f.
				Loop
			EndIf
			If lMSErroAuto
				VTDispFile(NomeAutoLog(),.t.)
			EndIf
		Else
			Loop
		Endif
		Exit
	Enddo
	If IsTelnet() .and. VtModelo() == "RF"
		If VtLastKey() == 27
			VtRestore(,,,,aTela)
			Return .f.
		EndIf
	Else
		If TerEsc()
			TerRestore(,,,,aTela)
			Return .f.
		EndIf
	EndIf
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvConjunto³ Autor ³ Anderson Rodrigues  ³ Data ³ 04/04/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa os operadores em aberto para fazer o apontamento   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvConjunto(xOP,xOperacao,xOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
	Local aCab     := {"Ok","Operador","Quantidade"} //"Operador"###"Quantidade"
	Local aTamQtd  := TamSx3("CBH_QTD")
	Local aSize    := {2,8,aTamQtd[1]}
	Local nX       := 0
	Local nPos     := 0
	Local nMarcados:= 0
	//Local lErro    := .f.
	Private cOP       := xOP
	Private cOperacao := xOperacao
	Private cOperador := xOperador

	nPos:= Ascan(aOperadores,{|x| x[2] == cOperador})
	If nPos > 0
		aOperadores[nPos,3]:= Str(nQtd,aTamQtd[1],aTamQtd[2])
	Endif

	aOperadores:= aSort(aOperadores,,,{|x,y| x[3] < y[3]})

	While .t.
		nMarcados:= 0
		If IsTelnet() .and. VtModelo() == "RF"
			VtClearBuffer()
			VtClear()
			VtaBrowse(0,0,7,19,aCab,aOperadores,aSize,'U_AT06AUX')
		Else
			TerIsQuit()
			TerCBuffer()
			TerCls()
			TeraBrowse(0,0,1,19,aCab,aOperadores,aSize,'U_AT06AUX')
		EndIf
		For nX:= 1 to Len(aOperadores)
			If Empty(aOperadores[nX,1])
				Loop
			EndIf
			nMarcados++
		Next

		If nMarcados < 2
			CBAlert("Para utilizar o apontamento em conjunto devem ser selecionados no minimo dois operadores","Aviso",.T.,5000,2) //"Para utilizar o apontamento em conjunto devem ser selecionados no minimo dois operadores"###"Aviso"
			If CBYesNo("Continua ?","ATENCAO",.T.) //"Continua ?"###"ATENCAO"
				Loop
			Else
				Return .f.
			EndIf
		EndIf

		If (nQTD >= nSldOPer) .and. nMarcados < Len(aOperadores) // Nao selecionou todos os operadores
			CBAlert("A quantidade informada finaliza o saldo da operacao, neste caso e necessario selecionar todos os operadores","Aviso",.T.,nil,2) //"A quantidade informada finaliza o saldo da operacao, neste caso e necessario selecionar todos os operadores"###"Aviso"
			If CBYesNo("Continua ?","ATENCAO",.T.) //"Continua ?"###"ATENCAO"
				Loop
			Else
				Return .f.
			EndIf
		EndIf

		If CBYesNo("Confirma os itens selecionados","ATENCAO",.T.) //"Confirma os itens selecionados"###"ATENCAO"
			For nX:= 1 to Len(aOperadores)
				If Empty(aOperadores[nX,1])
					Loop
				EndIf
				If lMod1
					If ! U_AT06GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,aOperadores[nX,2],cTipAtu,Val(aOperadores[nX,3]),cLote,dValid)
						Return .f.
					EndIf
				Else
					If ! U_ATCB065GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,aOperadores[nX,2],cTipAtu,Val(aOperadores[nX,3]),cLote,dValid)
						Return .f.
					EndIf
				EndIf
			Next
			Exit
		Else
			Return .f.
		EndIf
	Enddo
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvInicio  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 03/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao do Inicio                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ATGrvInicio(cOP,cOperacao,cOperador,cTransac,cTipAtu)
	Local nQuant    := 0
	//Local nQtdeCBH  := 0
	Local nEmAberto := U_AT06Apont(cOP,cOperacao) // Retorna a quantidade total de inicio em aberto para esta operacao
	Local cPictQtd  := PesqPict("CBH","CBH_QTD")
	Local lRet	    := .t.
	Local aTela     := {}
	Local lMens 	:= .T. //MOSTRA MENSAGEM DE CONFIRMACAO
	Local lContinua	:= .T. //OPCAO PARA OS CASOS DE CONFIRMACAO DA MENSAGEM

	If IsTelnet() .and. VtModelo() == "RF"
		aTela:= VtSave()
	Else
		aTela:= TerSave()
	EndIf

	nSldOPer -= nEmAberto // Atualiza o Saldo da operacao considerando as quantidades de inicio que estao em aberto

	If nSldOPer < 0  // --> Se apos a atualizacao o Saldo ficar negativo deixar como zero.
		nSldOPer:= 0
	ElseIf nSldOPer >= 0 .And. cOperacao == "01" // A TAIFF APONTA 1 A 1
		nSldOPer:= 1
	EndIf

	If !lInfQeIni

		//PARA A TRANSACAO 01 NAO MOSTRA PERGUNTAS
		If cOperacao == "01"
			lMens 		:= .F.
			lContinua 	:= .T.
		EndIf	

		//PARA OS CASOS QUE MOSTRA A MENSAGEM
		If lMens			
			If CBYesNo("Confirma o Inicio da Producao da OP?","ATENCAO",.T.)
				lContinua 	:= .T.
			Else
				lContinua 	:= .F.
			EndIf			
		EndIf 	


		If lContinua
			U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
			Return .t.
			//		ELSEIF COPERACAO = '01'
			//			U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
			//			Return .t.
		Else
			If Istelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
			Return .f.
		EndIf
	EndIf

	If lSGQTDOP
		nQuant:= nSldOPer
	EndIf

	While .t.
		If IsTelnet() .and. VtModelo() == "RF" .AND. COPERACAO != "01"
			VtClear()
			VtClearBuffer()
			@ 1,00 VtSay "Inicio da Operacao:" //"Inicio da Operacao:"
			@ 3,00 VtSay "Quantidade: " //"Quantidade: "
			@ 4,00 VtGet nQuant Pict cPictQtd Valid U_AT06Qtd(cOP,cOperacao,cOperador,nQuant,.T.)
			VtRead
			If VtLastKey() == 27
				nSldOPer+= nEmAberto
				lRet:= .f.
				Exit
			EndIf
		EndIf

		/*
		|---------------------------------------------------------------------------------
		|	Validação de Operações em atraso na finalização
		|---------------------------------------------------------------------------------
		*/

		//PARA A TRANSACAO 01 NAO MOSTRA PERGUNTAS
		If cOperacao == "01"
			lMens 		:= .F.
			lContinua 	:= .T.
		EndIf	

		//PARA OS CASOS QUE MOSTRA A MENSAGEM
		If lMens			
			If CBYesNo("Confirma o Inicio da Producao da OP?","ATENCAO",.T.)
				lContinua 	:= .T.
			Else
				lContinua 	:= .F.
			EndIf			
		EndIf 	


		If lContinua
			Begin transaction
				U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
			End Transaction
			If lMSErroAuto
				lRet:= .f.
				If IsTelnet() .and. VtModelo() == "RF"
					VtDispFile(NomeAutoLog(),.t.)
				Else
					TerDispFile(NomeAutoLog(),.t.)
				EndIf
			EndIf
		ELSEIF COPERACAO = '01'
			Begin transaction
				U_AT06CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
			End Transaction
			If lMSErroAuto
				lRet:= .f.
				If IsTelnet() .and. VtModelo() == "RF"
					VtDispFile(NomeAutoLog(),.t.)
				Else
					TerDispFile(NomeAutoLog(),.t.)
				EndIf
			EndIf
		Else
			Loop
		EndIf
		Exit
	Enddo
	If IsTelnet() .and. VtModelo() == "RF"
		VtRestore(,,,,aTela)
	EndIf
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³  CB023FIM  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 29/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa e finaliza os inicios da producao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT06FIM(cOP,cProduto,cOperacao,cOperador,nQtd,dDtFim,cHrFim)
	Local nRecCBH

	// ---> Aqui ira finalizar somente os operadores que fizeram parte do apontamento

	CBH->(DbSetOrder(3))
	If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
		RecLock("CBH",.F.)
		VtClear()
		VtSay(2,0,"Aguarde AT06PTOT...")
		If U_AT06PTot(cOP,cProduto,cOperacao,cOperador)
			CBH->CBH_DTFIM:= dDtFim
			CBH->CBH_HRFIM:= cHrFim
			CBH->CBH_QTD  += nQtd
		Else
			CBH->CBH_QTD  += nQtd
		EndIf
		CBH->(MsUnlock())
		VtClear()
		VtSay(2,0,"Aguarde AT06CB1...")
		U_AT06CB1(cOP,cOperacao,cOperador,CBH->CBH_TIPO,CBH->CBH_TRANSA,dDtFim)
	EndIf

	// ---> Aqui analisa os demais operadores que nao fizeram parte do apontamento, pois mesmo assim devem ter
	// seus inicios finalizados caso a operacao tenha sido finalizada

	CBH->(DbSetOrder(3))
	CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
		nRecCBH:= CBH->(RECNO())
		VtClear()
		VtSay(2,0,"Aguarde AT06PTOT...")
		If U_AT06PTot(cOP,cProduto,cOperacao,CBH->CBH_OPERADOR)
			CBH->(DbGoto(nRecCBH))
			If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+CBH->CBH_OPERADOR))
				RecLock("CBH",.F.)
				CBH->CBH_DTFIM  := dDtFim
				CBH->CBH_HRFIM  := cHrFim
				CBH->(MsUnlock())
				VtClear()
				VtSay(2,0,"Aguarde AT06CB1...")
				U_AT06CB1(cOP,cOperacao,CBH->CBH_OPERADOR,CBH->CBH_TIPO,CBH->CBH_TRANSA,dDtFim)
			EndIf
		EndIf
		CBH->(DbGoto(nRecCBH))
		CBH->(DbSkip())
	Enddo
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023CB1   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 19/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza os Dados no cadastro do operador                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06CB1(cOP,cOperacao,cOperador,cTipAtu,cTransac,dDtFim,lLimpa)
	Default lLimpa:= .f.

	CB1->(DbSetOrder(1))
	If ! CB1->(DbSeek(xFilial("CB1")+cOperador))
		Return
	EndIf

	RecLock('CB1',.f.)

	If lLimpa
		CB1->CB1_OP    := Space(13)
		CB1->CB1_OPERAC:= Space(02)
	ElseIf cTipAtu == "1"  // inicio
		If Empty(dDtFim)
			CB1->CB1_OP    := cOP
			CB1->CB1_OPERAC:= cOperacao
		Else
			If (CB1->CB1_OP+CB1->CB1_OPERAC) == (cOP+cOperacao) // so tira pausa
				CB1->CB1_OP    := Space(13)                                                      // se OP e operacao for
				CB1->CB1_OPERAC:= Space(02)                                                      // igual
			EndIf
		EndIf
	ElseIf cTipAtu $"23" // pausa
		CBI->(DbSetOrder(1))
		If ! CBI->(DbSeek(xFilial("CBI")+cTransac))
			Return
		EndIf
		If ! Empty(dDtFim) .or.  CBI->CBI_BLQASM == "1" // Pausa nao permite o inicio de outra tarefa pelo operador
			CB1->CB1_OP    := cOP
			CB1->CB1_OPERAC:= cOperacao
		Else
			CB1->CB1_OP    := Space(13)
			CB1->CB1_OPERAC:= Space(02)
		EndIf
	EndIf
	CB1->(MsUnLock())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023DTHR  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 06/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa se a DataBase e Hora atual sao validas             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06DTHR(cOP,cOperacao,cOperador,cDataHora)
	Local lRet:= .t.

	CBH->(DbSetOrder(5))
	If ! CBH->(DbSeek(xFilial("CBH")+cOP+cOperacao))
		lRet:= .f.
	EndIf

	While lRet .And. !CBH->(EOF()) .And. CBH->(CBH_FILIAL+CBH_OP+CBH_OPERAC) == xFilial("CBH")+cOP+cOperacao
		If CBH->CBH_OPERAD # cOperador
			CBH->(DbSkip())
			Loop
		EndIf
		If CBH->CBH_TIPO == "1" .and. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			CBH->(DbSkip())
			Loop
		EndIf
		If CBH->CBH_TIPO == "1" .and. Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			If  cDataHora < (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI)
				lRet:= .f.
				Exit
			EndIf
		EndIf
		If CBH->CBH_TIPO $ "23" .and. Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			If cDataHora < (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI)
				lRet:= .f.
				Exit
			EndIf
		EndIf
		If CBH->CBH_TIPO $ "23" .and. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			If cDataHora < (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
				lRet:= .f.
				Exit
			EndIf
		EndIf
		If CBH->CBH_TIPO $ "45" .and. cDataHora < (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			lRet:= .f.
			Exit
		EndIf
		CBH->(DbSkip())
	Enddo
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023VOPER ³ Autor ³ Anderson Rodrigues  ³ Data ³ 22/04/04   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se valida a sequencia de operacoes                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06VOPER(cProduto)
	Local lRet:= .f.

	If lMod1
		lRet:= .t. // Para a Producao PCP MOD1 e obrigatoria a validacao da sequencia de operacoes
	ElseIf GetMV("MV_VLDOPER") == "S" // Valida a sequencia de Operacoes no apontamento da producao PCP MOD2
		lRet:= .t.
	Else
		SB5->(DbSetOrder(1)) // Este bloco so e verificado se for Producao PCP MOD2 e o parametro MV_VLDOPER for N.
		If SB5->(DbSeek(xFilial("SB5")+cProduto))
			If SB5->B5_VLDOPER == "1"
				lRet:= .t.
			ElseIf SB5->B5_VLDOPER == "2"
				lRet:= .f.
			EndIf
		EndIf
	EndIf
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ CB023IOPE º Autor ³ Anderson Rodrigues º Data ³ 13/04/04  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Informacao do Operador quando utilizar a rotina em        º±±
±±º          ³	Microterminal com Porta Paralela                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAACD                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AT06IOPE()
	Local cCodOpe   := Space(06)
	Local cRetPe    := ""
	Local lU_AT06IOPE:= ExistBlock("U_AT06IOPE") // Ponto de entrada para personalizar a informacao do operador para Microterminal com porta paralela

	While .t.
		If lU_AT06IOPE
			cRetPe := ExecBlock("U_AT06IOPE",.F.,.F.,{cCodOpe})
			If ValType(cRetPe)=="C"
				cCodOpe := cRetPe
				If ! U_AT7CBVldOpe(cCodOpe)
					Loop
				EndIf
			EndIf
		EndIf
		Exit
	Enddo
Return(cCodOpe)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023PG2   ³ Autor ³ André Anjos		    ³ Data ³ 16/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a primeira operacao do roteiro de operacoes - SG2  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06PG2(cProduto,cRoteiro)
	Local cOperac:= " "

	SG2->(DbSetOrder(1))
	If SG2->(DbSeek(xFilial("SG2")+cProduto+cRoteiro))
		cOperac := SG2->G2_OPERAC
	EndIf
Return cOperac

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CB023ArrOp  ³ Autor ³ André Anjos			³ Data ³ 16/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna array com operacoes para a op apontada			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AT06ArrOp(cProduto,cRoteiro,cOP)
	Local aOP 		:= {}
	//Local nTemp 	:= 0
	//Local cPictemp	:= PesqPict("SG2","G2_TEMPAD")
	Local lRet		:= .T.
	Local aTela    := {}

	If FunName() == "ACDV023"
		//monta sequencia de operacoes pelo SH8 - Carga Maq.
		dbSelectArea('SH8')
		dbSetOrder(1)
		dbSeek(xFilial('SH8')+cOP)
		While !EOF() .And. (SH8->H8_FILIAL+SH8->H8_OP == xFilial("SH8")+cOP)
			If aScan(aOP,{|aX| aX==SH8->H8_OPER}) == 0
				aAdd(aOP,SH8->H8_OPER)
			EndIf
			dbSkip()
		End
	Else
		//monta sequencia de operacoes pelo SG2 - Roteiro
		dbSelectArea('SG2')
		dbSetOrder(1)
		If dbSeek(xFilial('SG2')+cProduto+cRoteiro)
			While !EOF() .And. (SG2->(G2_FILIAL+G2_PRODUTO+G2_CODIGO) == xFilial("SG2")+cProduto+cRoteiro)
				aAdd(aOP,SG2->G2_OPERAC)
				dbSkip()
			End
			/*
			Else //CRIA ROTEIRO PADRAO

			If IsTelnet() .and. VtModelo() == "RF"
			aTela := VtSave()
			Else
			aTela := TerSave()
			EndIf

			VtClear()
			//VtClearBuffer()
			@ 1,00 VtSay "Cadastro da Operacao:" //"Inicio da Operacao:"
			@ 3,00 VtSay "Tempo Padrão Minutos: " //"Quantidade: "
			@ 4,00 VtGet nTemp Pict cPictemp Valid nTemp > 0
			VtRead
			If VtLastKey() == 27
			lRet:= .f.
			EndIf
			VtRestore(,,,,aTela)
			If lRet
			dbSelectArea('SG2')
			RecLock("SG2",.T.)
			G2_FILIAL 	:= xFilial('SG2')
			G2_CODIGO	:= "01"
			G2_PRODUTO	:= cProduto
			G2_OPERAC	:= "01"
			G2_TPLINHA	:= "I"
			G2_MAOOBRA	:= 1
			G2_SETUP	:= 1
			G2_LOTEPAD	:= 1
			G2_TPOPER	:= "1"
			G2_TEMPAD	:= nTemp/100
			G2_OPE_OBR	:= "S"
			G2_SEQ_OBR	:= "S"
			G2_LAU_OBR	:= "S"
			SG2->(MsUnlock())
			EndIf
			aAdd(aOP,SG2->G2_OPERAC)
			*/
		EndIf

	EndIf

Return aOP
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³GeraLote    ³ Autor ³ Aécio Ferreira Gomes³ Data ³ 28/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Responsável pela chamada da função CBRASTRO()que verifica  ³±±
±±³          ³ se o produto controla lote e possibilita a digitação dos   ³±±
±±³          ³ Gets lote e data de valida. 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD (RF)                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraLote(cLote,dValid,lVolta)

	cProduto := SC2->C2_PRODUTO
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+cProduto))

	// Gera No.Lote ao apontar a ultima operacao na finalizacao da transacao
	If (CBI->CBI_TIPO == "4" .And. SG2->G2_OPERAC == cUltOper) .Or. CBI->CBI_CFULOP == "1"
		If Empty(SB1->B1_FORMLOT)
			If !Empty(SuperGetMV("MV_FORMLOT",.F.,""))
				cLote := Formula(SuperGetMV("MV_FORMLOT",.F.,""))
			EndIf
		Else
			cLote := Formula(SB1->B1_FORMLOT)
		EndIf
		dValid   := dDataBase+SB1->B1_PRVALID

		If ! CBRastro(cProduto,@cLote,,@dValid,,.T.,@lVolta)
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
			Return .f.
		EndIf

	EndIf
Return


