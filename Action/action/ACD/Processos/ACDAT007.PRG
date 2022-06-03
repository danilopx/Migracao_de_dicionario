#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'APVT100.CH'
#INCLUDE "AcdXFun.ch" 
#DEFINE ENTER ( chr(13)+chr(10) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ACDAT001   ³ Autor ³ PAULO BINDO         ³ Data ³ 15/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Apontamento Producao PCP Mod2 - Este programa tem por       ³±±
±±³          ³objetivo realizar os apontamentos de Producao/Perda e Hrs   ³±±
±±³          ³improdutivas baseados no roteiro de operacoes               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

=============================================================================
|| Data: 19/01/2021                                                        ||
|| Editado por: Renan Bruniera                                             ||
|| Descrição: Remoção das rotinas de validação da pulseira RFID e          ||
||			  alteração do tratamento da input do código de operador,      ||
||            sendo removida a limitação de 3 caracteres.                  ||
=============================================================================
*/              
User function ACDAT007()

	Local bkey05
	Local bkey09
	Local cOP      := Space(Len(CBH->CBH_OP))
	Local cOperacao:= Space(Len(CBH->CBH_OPERAC))
	Local cTransac := Space(Len(CBH->CBH_TRANSA))
	//Local cRetPe   := ""    
	//Local cMensagem:= ""
	Local lContinua:= .T.
	Local lMens 	:= .F. //MOSTRA MENSAGEM DE CONFIRMACAO
	Local lMContinua:= .T. //OPCAO PARA OS CASOS DE CONFIRMACAO DA MENSAGEM
	Local lAchou	:= .T.
	Private nRest4 	:= 0
	Private cOperador  := Space(15)
	//Private c2Operador := Space(15)
	Private cTM        := GetMV("MV_TMPAD")
	Private cRoteiro   := Space(Len(SC2->C2_ROTEIRO))
	Private cProduto   := Space(Len(SC2->C2_PRODUTO))
	//Private cLocPad    := Space(Len(SC2->C2_LOCAL))
	Private cUltOper   := Space(Len(CBH->CBH_OPERAC))
	Private cPriOper   := Space(Len(CBH->CBH_OPERAC))
	Private cRecurso   := Space(Len(CBH->CBH_RECUR))
	Private cTipIni    := "1"
	Private cUltApont  := " "
	//Private cApontAnt  := " "
	Private nSldOPer   := 0
	Private nQtdOP     := 0
	Private nQtdH6	   := 0 	//QUANTIDADE SH6 - TAIFF	
	//Private aOperadores:= {}
	//Private lConjunto  := .f.
	Private lFimIni    := .f.
	//Private lAutAskUlt := .f.
	Private lVldOper   := .f.
	Private lRastro    := GetMV("MV_RASTRO")  == "S" // Verifica se utiliza controle de Lote
	Private lSGQTDOP   := GetMV("MV_SGQTDOP") == "1" // Sugere quantidade no inicio e no apontamento da producao
	Private lInfQeIni  := GetMV("MV_INFQEIN") == "1" // Verifica se deve informar a quantidade no inicio da Operacao
	Private lCBAtuemp  := GetMV("MV_CBATUD4") == "1" // Verifica se ajusta o empenho no inicio da producao
	Private lVldQtdOP  := GetMV("MV_CBVQEOP") == "1" // Valida no inicio da operacao a quantidade informada com o saldo a produzir da mesma
	Private lVldQtdIni := GetMV("MV_CBVLAPI") == "1" // Valida a quantidade do apontamento com a quantidade informada no inicio da Producao
	//Private lCfUltOper := GetMV("MV_VLDOPER") == "S" // Verifica se tem controle de operacoes
	Private lOperador  := GetMV("MV_SOLOPEA",,"2") == "1" // Solicita o codigo do operador no apontamento 1-sim 2-nao (default)
	Private lMod1      := .f.
	//Private lMsHelpAuto:= .f.
	Private lMSErroAuto:= .f.
	//Private lPerdInf    := .F.
	//Private aRFID		:= {} //01-RFID, 02-OPERADOR
	Private l4Pecas		:= .F.
	//CBChkTemplate()

	// -- Verifica se data do Protheus esta diferente da data do sistema.
	DLDataAtu()

	If IsTelnet()
		cOperador := CBRETOPE()
		If lContinua .And. Empty(cOperador)
			CBALERT("Operador nao cadastrado, entre em contato com o PCP.","Aviso",.T.,3000,2)  //"Operador nao cadastrado"###"Aviso"
			lContinua := .f.
		EndIf
		If lContinua .And. VtModelo() == "RF"
			//bkey05   := VTSetKey(05,{|| AT01Encer()},"Encerrar")       //"Encerrar"
			bkey09   := VTSetKey(09,{|| U_AT06Hist(Padr(cOP,Len(CBH->CBH_OP)))},"Informacoes")       //"Informacoes"
		EndIf
	EndIf

	If lContinua .And. Empty(cTM)
		CBALERT("Informe o tipo de movimentacao padrao - MV_TMPAD","Aviso",.T.,3000,2) //"Informe o tipo de movimentacao padrao - MV_TMPAD"###"Aviso"
		lContinua := .f.
	EndIf

	If lContinua .And. !lRastro .and. lCBAtuemp
		CBALERT("O parametro MV_CBATUD4 so deve ser ativado quando o sistema controlar rastreabilidade","Aviso",.T.,4000,2) //"O parametro MV_CBATUD4 so deve ser ativado quando o sistema controlar rastreabilidade"###"Aviso"
		lContinua := .f.
	EndIf

	If lContinua .And. (lVldQtdOP .or. lVldQtdIni .or. lCBAtuemp) .and. !lInfQeIni
		CBALERT("O parametro MV_INFQEIN deve ser ativado","Aviso",.T.,3000,2) //"O parametro MV_INFQEIN deve ser ativado"###"Aviso"
		lContinua := .f.
	EndIf

	While lContinua
		VtClear()
		//cOP := Space(11)			
		@ 0,00 VTSAY "Producao PCP MOD2" //"Producao PCP MOD2"
		If lOperador
			cOperador  := Space(15)
			@ 1,00 VtSay "Operador:" VtGet cOperador pict "@R 999999999999999" Valid U_AT7CBVldOpe(@cOperador,@cOperacao) //"Operador:"	
		EndIf		
		/*
		//QUANDO FOR OPERCAO DE CQ, EXPEDICAO OU SUPERVISORA LIMPA AS VARIAVEIS
		If cOperacao # "01"
		cRecurso   	:= Space(Len(CBH->CBH_RECUR))
		cOP       	:= Space(11)
		nQtdH6		:= 0	
		VTaBrwRefresh()
		EndIf
		*/
		@ 2,00 VTSAY "OP: " //"OP: "
		@ 2,04 VTGET cOP pict '@!'  Valid U_AT06OP(Padr(cOP,Len(CBH->CBH_OP))) When Empty(cOP) 
		U_AT06OP(Padr(cOP,Len(CBH->CBH_OP)))
		VTaBrwRefresh()

		@ 3,00 VTSAY "Qtd.Prod.: " 
		@ 3,10 VTGET nQtdH6 pict '99999' When .F.  

		VTRead
		If VtLastKey() == 27
			Exit
		EndIf
		lAchou :=  .T.
		/*If !Empty(c2Operador)
			cOperador:= c2Operador
			CBAlert("Operador "+cOperador,"Aviso",.T.,2000,2)	
			VTaBrwRefresh()
		EndIf*/

		If cOperacao == "01" //.And. cTipAtu == "1" //Inicio
			//VALIDA SE JA EXISTE OPERACAO EM ANDAMENTO
			CBI->(DbSetOrder(1))
			CBI->(DbSeek(xFilial("CBI")+"01"))
			cTipAtu := CBI->CBI_TIPO

			//VALIDA SE EXISTE OPERACAO EM OUTRA OP
			cQuery := " SELECT CBH_TRANSA, CBH_OP FROM "+RetSqlName("CBH")+" WITH(NOLOCK)"
			cQuery += " WHERE CBH_FILIAL = '"+cFilAnt+"'"
			cQuery += " AND D_E_L_E_T_ <> '*' AND CBH_OPERAD = '"+cOperador+"'"
			cQuery += " AND CBH_OPERAC = '"+cOperacao+"'"
			cQuery += " AND CBH_DTFIM = '' "
			cQuery += " AND CBH_OP <> '"+cOP+"'

			TCQUERY CQUERY NEW ALIAS "TMP"
			Count To nRec
			DBSELECTAREA("TMP")
			DBGOTOP()
			If nRec > 0
				CBALERT("Existe uma operacao em aberto em outra OP "+TMP->CBH_OP,"Aviso",.T.,3000,2)
				TMP->(dbCloseArea())
				cOP       	:= Space(Len(CBH->CBH_OP))
				Loop
			EndIf
			TMP->(dbCloseArea())


			//VALIDA SE EXISTE OPERACAO EM PAUSA
			cQuery := " SELECT CBH_TRANSA FROM "+RetSqlName("CBH")+" WITH(NOLOCK)"
			cQuery += " WHERE CBH_FILIAL = '"+cFilAnt+"'"
			cQuery += " AND D_E_L_E_T_ <> '*' AND CBH_OPERAD = '"+cOperador+"'"
			cQuery += " AND CBH_OPERAC = '"+cOperacao+"'"
			cQuery += " AND CBH_DTFIM = '' AND CBH_TRANSA >= '50'"
			cQuery += " AND CBH_OP = '"+cOP+"'

			TCQUERY CQUERY NEW ALIAS "TMP"
			Count To nRec
			DBSELECTAREA("TMP")
			DBGOTOP()
			If nRec > 0
				cTransac := TMP->CBH_TRANSA
				lAchou :=  .f.
			EndIf
			TMP->(dbCloseArea())

			//QUANDO NAO ENCONTROU PAUSA, BUSCA POR APONTAMENTO DE PRODUCAO
			If Empty(cTransac)
				CBH->(DbSetOrder(3))
				If CBH->(DbSeek(xFilial("CBH")+Padr(cOP,Len(CBH->CBH_OP))+cTipIni+cOperacao+cOperador)) .and. (Empty(CBH->CBH_DTFIM) .OR. Empty(CBH->CBH_HRFIM))
					cTransac := CBH->CBH_TRANSA
					lAchou :=  .f.
				EndIf

				CB1->(DbSetOrder(1))
				If CB1->(DbSeek(xFilial("CB1")+cOperador)) .and. CB1->CB1_ACAPSM # "1" .and. ! Empty(CB1->CB1_OP+CB1->CB1_OPERAC)
					cTransac := CBH->CBH_TRANSA
					lAchou :=  .f.
				EndIf
			EndIf
		EndIf


		//QUANDO FOR OPERACAO 01	
		//QUANDO FOR O INICIO NAO EXIBE OS DADOS	 
		If ((cOperacao == "01" .And. !lAchou) .Or. cOperacao # "01") 
			lMens 		:= .F.
			lMContinua 	:= .T.

			//PARA A TRANSACAO 01  NAO MOSTRA PERGUNTAS
			If cOperacao == "01" 
				lMens 		:= .T.
				lMContinua 	:= .F.
			EndIf	

			//PARA APONTAMENTO DE PAUSA
			If cOperacao == "01" .And. cTransac >= "50" 
				lMens 		:= .F.
				lMContinua 	:= .F.
			EndIf	

			//PARA OS CASOS QUE MOSTRA A MENSAGEM
			If lMens			
				If CBYesNo("Finaliza o apontamento da producao?","ATENCAO",.T.)
					lMContinua 	:= .F.
				Else
					lMContinua 	:= .T.
				EndIf			
			EndIf 	



			If cOperacao # "01" .Or. lMContinua
				@ 4,00 VTSAY "Operacao: " //"Operacao: "
				@ 4,10 VTGET cOperacao pict '@!' Valid U_AT06OPERAC(Padr(cOP,Len(CBH->CBH_OP)),@cOperacao,cOperador)
				@ 7,00 VTSAY "Transacao:" //"Transacao:"
				@ 7,11 VTGET cTransac pict '@!'  Valid U_AT06VTran(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cOperador,cTransac,.F.) F3 "CBI1"


				VtRead
				If VtLastKey() == 27
					Exit
				EndIf
			Else //FINALIZA A PAUSA OU APONTA A PRODUCAO
				U_AT06OPERAC(Padr(cOP,Len(CBH->CBH_OP)),@cOperacao,cOperador)

				cTransac := Iif(cTransac>="50",cTransac ,"02")				
				U_AT06VTran(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cOperador,cTransac,.T.)
				
				
				//MENSAGEM PARA FINALIZACAO DA PAUSA
				If cTransac >= "50"
					CBAlert("A Pausa foi finalizada","Aviso",.T.,1000,2)
				ElseIf l4Pecas //QUANDO FOR APONTAMENTO DE PRODUCAO VERIFICA SE ESTA NAS ULTIMAS 4 PECAS E APAGA AS VARIAVEIS DA OP. DESTA FORMA A OPERADORA PODE INICIAR UMA NOVA OP	
					
					
					//quando faltar 4 pecas ou menos avisa na tela quem sao os operadores
					cQuery := " SELECT CBH_OPERAD FROM "+RetSqlName("CBH")
					cQuery += " WHERE CBH_OP = '"+cOP+"' AND CBH_TRANSA IN ('01')  AND CBH_DTFIM = '' AND D_E_L_E_T_ <> '*' "
					cQuery += " AND CBH_OPERAD <> '"+cOperador+"' "
					MEMOWRITE("ACDAT002BA.SQL",CQUERY)

					TCQUERY CQUERY NEW ALIAS "TMP"

					Count To nRec

					If nRec > 0 .And. nRec <= 4

						dbSelectArea("TMP")
						dbGoTop()
						cPend := ""

						While !Eof()
							dbSelectArea("CB1")
							dbSetOrder(1)
							If dbSeek(xFilial()+TMP->CBH_OPERAD)			
								cPend += "Ope: "+Left(CB1->CB1_NOME,10)+ENTER
							EndIf
							dbSelectArea("TMP")
							dbSkip()
						End


						If !Empty(cPend)
							CBAlert("Apontamentos em aberto"+ENTER+cPend,"Aviso",.T.,3000,2)
						Endif

					ElseIf nRec == 0
						CBAlert("OP Finalizada!!!","Aviso",.T.,3000,2)
					
					EndIf
					TMP->(dbCloseArea())
					
					
					cOP       := Space(Len(CBH->CBH_OP))
					nQtdH6	  := 0
				Endif
			EndIf
		Else
			U_AT06OPERAC(Padr(cOP,Len(CBH->CBH_OP)),@cOperacao,cOperador)

			cTransac := "01"
			If U_AT06VTran(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cOperador,cTransac,.F.)
				CBAlert("Producao iniciada","Aviso",.T.,1000,2)				
				dbSelectArea("SC2")
				dbSetOrder(1)
				If dbSeek(xFilial()+cOP)
					RecLock("SC2",.F.)
					C2__QTDH6 := C2__QTDH6+1
					SC2->(MsUnlock())					
				EndIf
				
				If l4Pecas //QUANDO FOR APONTAMENTO DE PRODUCAO VERIFICA SE ESTA NAS ULTIMAS 4 PECAS E APAGA AS VARIAVEIS DA OP. DESTA FORMA A OPERADORA PODE INICIAR UMA NOVA OP	
					If (nRest4) == 0
						CBAlert("Esta é a última peça a ser produzida desta OP","Aviso",.T.,3000,2)
					Else
						CBAlert("Faltam "+StrZero(nRest4-1,2)+" a Iniciar a Producao, digitacao manual","Aviso",.T.,3000,2)
					EndIf
					cOP       	:= Space(Len(CBH->CBH_OP))
					nQtdH6	  := 0
				EndIf
			Else	
				lContinua := .F.
			EndIf				
		EndIf
		//QUANDO FOR OPERACAO DE CQ, EXPEDICAO OU SUPERVISORA LIMPA AS VARIAVEIS
		If cOperacao # "01"
			cRecurso   := Space(Len(CBH->CBH_RECUR)) 
			cOP       := Space(Len(CBH->CBH_OP))
		EndIf
		//	cOP       := Space(Len(CBH->CBH_OP))
		cOperacao := Space(Len(CBH->CBH_OPERAC))
		cTransac  := Space(Len(CBH->CBH_TRANSA))
	EndDo
	If lContinua
		If IsTelnet() .and. VtModelo() == "RF"
			vtsetkey(05,bkey05)		
			vtsetkey(09,bkey09)
		Else
			TerIsQuit()
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³  CB025GRV  ³ Autor ³ Anderson Rodrigues  ³ Data ³ 20/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza gravacao dos arquivos para apontar a Producao      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ATCB065GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid,dDtIni,cHrIni,dDtFim,cHrFim,aCpsUsu)
	//Local nTamSX1  := Len(SX1->X1_GRUPO)
	Local cCalend,cTempo2
	Local nTempoPar,nTempoTra
	Local nMinutos,nTempo1,nTempo2
	//Local aPEAux	:= {} 
	Local lACD25MOV := .T.
	Default cHrIni  := ""
	Default cHrFim  := Left(Time(),5)
	Default dDtIni  := CTOD("  /  /    ")
	Default dDtFim  := dDataBase


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de Entrada para verificar se executa mata681.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If ExistBlock("ACD25MOV")
	lACD25MOV := ExecBlock("ACD25MOV",.F.,.F.)   
	If ValType(lACD25MOV) <> "L"
	lACD25MOV := .T.
	EndIf
	Endif
	*/
	If TerProtocolo() # "PROTHEUS"
		cTipo := "1" // -> Inicio da operacao para a OP
		CBH->(DbSetOrder(3))
		If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipo+cOperacao+cOperador))
			If Empty(DTOS(dDtIni)+cHrIni)
				CBALERT("OP inconsistente","Aviso",.T.,3000,2,Nil)  //"OP inconsistente"###"Aviso"
				DisarmTransaction()
				Break
			Endif
		ElseIf (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI) > (DTOS(dDtIni)+cHrIni)
			dDtIni:= CBH->CBH_DTINI
			cHrIni:= CBH->CBH_HRINI
		Endif
		If !lACD25MOV
			AT07CBH(cOP,cTipAtu,cOperacao,cTransac,cOperador,@dDtIni,@cHrIni)
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
		Endif
	Endif
	cCalend := GetMV("MV_CBCALEN") // Parametro onde e informado o calendario padrao que deve ser utilizado
	If Empty(cCalend)
		cCalend := Posicione("SH1",1,xFilial("SH1")+cRecurso,"H1_CALEND")
	Endif
	nTempoPar := U_AT06Pausa(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDataBase,cHrFim)
	nTempoTra := IF(SuperGetMV("MV_USACALE",.F.,.T.),PmsHrsItvl(dDtIni,cHrIni,dDtFim,cHrFim,cCalend,"",cRecurso,.T.),A680Tempo(dDtIni,cHrIni,dDtFim,cHrFim))
	nTempo1   := nTempoTra - nTempoPar
	nTempo2   := Int(nTempo1)
	nMinutos  := (nTempo1-nTempo2)*60
	If nMinutos == 60
		nTempo2++
		nMinutos:= 0
	Endif
	cTempo2:= StrZero(nTempo2,3)+":"+StrZero(nMinutos,2)
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtClear()
			VtSay(2,0,"Aguarde MATA681...") //"Aguarde..."
		Else
			TerCls()
			TerSay(1,0,"Aguarde MATA681...") //"Aguarde..."
		Endif
	Endif


	VtClear()
	VtSay(2,0,"Aguarde AT07CBH...")
	U_AT06CBH(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cOperador,cTransac,Nil,dDtIni,cHrIni,dDtFim,cHrFim,cTipAtu,"ACDV023",0,nQtd,cRecurso,aCpsUsu)
	VtClear()
	VtSay(2,0,"Aguarde AT06FIM...")
	U_AT06FIM(Padr(cOP,Len(CBH->CBH_OP)),cProduto,cOperacao,cOperador,nQtd,dDtFim,cHrFim)
	VtClear()
	VtSay(2,0,"Aguarde AT06HrImp...")
	U_AT06HrImp(Padr(cOP,Len(CBH->CBH_OP)),cOperacao,cRecurso,cOperador,dDtIni,cHrIni,dDtFim,cHrFim)
Return .t.
   



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CB025CBH   ³ Autor ³Isaias Florencio      ³ Data ³09/09/14  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Retorna a data e hora final do ultimo registro de log      ³±±
±±³Descri‡…o ³ na tabela CBH, em caso de o ponto de entrada ACD25MOV      ³±±
±±³          ³ estar ativo e retornar .F.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CB025GRV                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AT07CBH(cOP,cTipAtu,cOperacao,cTransac,cOperador,dDtIni,cHrIni)
	Local aAreaAnt := GetArea()
	Local aAreaCBH := CBH->(GetArea())

	#IFNDEF TOP
	Local cSeek    := ""
	CBH->(DbSetOrder(1)) // FILIAL + OP + TRANSA + TIPO + OPERAC + OPERAD
	If CBH->(DbSeek(cSeek := xFilial("CBH")+ cOP+cTransac+cTipAtu+cOperacao+cOperador))
		While CBH->(!Eof()) .And. cSeek == xFilial("CBH")+ CBH->(CBH_OP+CBH_TRANSA+CBH_TIPO+CBH_OPERAC+CBH_OPERAD)
			CBH->(DbSkip())
		EndDo
		CBH->(DbSkip(-1))
		If cSeek == xFilial("CBH")+ CBH->(CBH_OP+CBH_TRANSA+CBH_TIPO+CBH_OPERAC+CBH_OPERAD)
			dDtIni := CBH->CBH_DTFIM
			cHrIni := CBH->CBH_HRFIM
		EndIf	
	EndIf
	#ELSE
	Local cQuery		:= ""
	Local cAliasCBH	:= GetNextAlias()
	cQuery := "SELECT CBH.CBH_DTFIM AS DTFIM, CBH.CBH_HRFIM AS HRFIM "
	cQuery += "FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK)"
	cQuery += "WHERE CBH.CBH_FILIAL = '"+xFilial('CBH')+"' AND CBH.CBH_OP = '"+ cOP +"' AND "
	cQuery += "CBH.CBH_OPERAC = '"+ cOperacao +"' AND CBH.CBH_OPERAD = '"+ cOperador +"' AND "
	cQuery += "CBH.CBH_TRANSA = '"+ cTransac +"' AND CBH.CBH_TIPO   = '"+ cTipAtu +"' AND CBH.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY CBH.R_E_C_N_O_ DESC "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCBH,.T.,.T.)

	(cAliasCBH)->(DbGoTop())
	If !(cAliasCBH)->(Eof())
		dDtIni := STOD((cAliasCBH)->DTFIM)
		cHrIni := (cAliasCBH)->HRFIM
	EndIf
	(cAliasCBH)->(dbCloseArea())
	#ENDIF	

	RestArea(aAreaCBH)
	RestArea(aAreaAnt)
Return Nil

/*
=================================================================================
=================================================================================
||   Arquivo:	ACDAT001.prg
=================================================================================
||   Funcao:	CBVldOpe 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Validacao do usuario onde sera passado qual o tipo de operacao esta 
|| 	cadastrada para o mesmo.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		28/01/2016
=================================================================================
=================================================================================
*/

USER Function AT7CBVldOpe(cOperador,cOperacao)
	Local lRet := .T.
	Local cQuery    := ""
	Local nRecnoCB1 := NIL
	//Local lRFID 	:= .F.
	//Local cRFID
	//Local nPos		:= 0
	
	//Private cEmailAdm 	:= GETMV("MV_WFADMIN")
	cMsg := ""
	cMsg += "cOperador "+cOperador+ENTER

	If Empty(cOperador)
		CBAlert("Operador em branco - ACDAT001",'Aviso',.T.,3000,2)
		lRet := .F.
	EndIf

	If lRet
		cOperador := AllTrim(cOperador)
		CB1->(DbSetOrder(1))
		
		//AUTOR: Renan Bruniera
		//DATA: 19/01/2021
		//REMOVIDAS: ROTINA RFID E LIMITAÇÕES DE CARACTERES PARA OPERADORES
		//QUANDO VIER COM O CODIGO DA MATRICULA
		/*If Len(AllTrim(cOperador)) == 6  
			cOperador := StrZero(VAL(SUBSTR(cOperador,3,5)),6) //StrZero(VAL(SUBSTR(cOperador,4,5)),6) - Alterado para aceitar o código de operador em sua integridade
			CB1->(DbSetOrder(1))
		Else
			//VERIFICA SE O RFID ESTA NO ARRAY
			nPos:= Ascan(aRFID,{|x| x[1] == cOperador})	
			If nPos > 0
				cOperador := aRFID[nPos][2]
				c2Operador := cOperador
				cMsg += "c2Operador "+c2Operador+ENTER
			Else //SOLICITA O CODIGO DA MATRICULA
				aTela:= VtSave()
				cRFID	:= cOperador
				lRFID 	:= .T.
				cOperador  := Space(Len(CB1->CB1_CODOPE))
				CBAlert("Informe o numero da sua matricula","Aviso",.T.,2000,2)		
				VtClear()
				@ 1,00 VtSay "Operador:" VtGet cOperador Valid Len(AllTrim(cOperador))==6 .And. !IsAlpha(cOperador) .And. Ascan(aRFID,{|x| x[2] == cOperador}) == 0	
				VtRead
				cMsg += "cOperador Matr "+cOperador+ENTER
			EndIf
		EndIf*/


		cQuery := " SELECT R_E_C_N_O_ RECCB1 FROM "+RetSqlName("CB1")+" WITH(NOLOCK)"
		cQuery += " WHERE CB1_FILIAL = '"+xFilial("CB1")+"' AND "
		cQuery += " CB1_CODOPE = '"+cOperador+"' AND "
		cQuery += " CB1_STATUS = '1' AND "
		cQuery += " D_E_L_E_T_ <> '*'"
		//	cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CB1TOP")

		If CB1TOP->(!EOF())
			nRecnoCB1 := CB1TOP->RECCB1
			//Conout(nRecnoCB1)
		EndIf

		CB1TOP->(DbCloseArea())

		//Posiciona no operador caso exista.
		If nRecnoCB1#NIL
			CB1->(DbGoto(nRecnoCB1))
		EndIf

		If nRecnoCB1 == NIL .Or. CB1->(cOperador <> CB1_CODOPE)		
			lRet := .f.			
			cMsg += "Operador CB1 "+CB1->CB1_CODOPE+ENTER
			cMsg += "query"+cQuery+ENTER
			//REMOVIDO CONSULTA DO RFID
			/*For nPos :=1 To Len(aRFID)
				cMsg += "ARRAY ID"+StrZero(nPos,2)+" "+aRFID[nPos][1]+ENTER
				cMsg += "ARRAY OPERADOR"+StrZero(nPos,2)+" "+aRFID[nPos][2]+ENTER
			Next*/



		EndIf


		If !lRet
			CBAlert("Operador nao encontrado, tente novamente. Rotina ACDAT001",'Aviso',.T.,3000,2)
			cOperador := Space(15)  //Adicionado para retornar campo vazio após erro de operador
			//CBAlert("Erro operador, inicie a rotina ACDAT001",'Aviso',.T.,3000,2)
			//aRFID := {}
			//U_2EnvMail('pedidos@actionmotors.com.br','grp_sistemas@taiffproart.com.br'	,'',cMsg	,'ERRO APONTAMENTO ROTINA ACDAT001' + DTOC(dDataBase)	,'')								
		EndIf

		/*
		|---------------------------------------------------------------------------------
		|	Realiza a validacao da Operacao pelo cadastro do Operador
		|---------------------------------------------------------------------------------
		*/
		IF lRet
			cOperacao := CB1->CB1_OPERA
			//ASSOCIA O OPERADOR A ETIQUETA RFID
			/*If lRFID
				aAdd(aRFID,{cRFID,cOperador})
				c2Operador := cOperador
				//aTela[1][2]:= "Operador:"+cOperador
				VtRestore(,,,,aTela)	
			EndIf*/
		ENDIF 
	EndIf
Return lRet
