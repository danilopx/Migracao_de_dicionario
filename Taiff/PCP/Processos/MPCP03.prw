/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMPCP03    บAutor  ณMarcos J.           บ Data ณ  09/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para efetuar a troca de empenho, com base nos       บฑฑ
ฑฑบ          ณparametros.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
#include "PROTHEUS.CH"
#include "TOPCONN.CH" 

#define CHR_ENTER				'<br>'  
#define CHR_FONT_DET_OPEN	'<font face="Courier New" size="2">'
#define CHR_FONT_DET_CLOSE	'</font>'

User Function MPCP03()
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := 0
	Local aHelpPor := {}
	Local cTitoDlg := "Substitui็ใo de Empenhos"
	Local cPerg    := "MPCP03"
	Local cMensagem := ""
	Local cMailDest := AllTrim(GETNEWPAR("MV_MAILEST", "", xFilial("SX6"))) // E-mail configurado para receber e-mail para altera็๕es nas esturuturas dos produtos
   Local cUserName := UsrFullName(RetCodUsr()) // Login do usuแrio logado
	
	If LockByName("MPCP03_" + SM0->(M0_CODIGO + M0_CODFIL), .T., .T., .T.)  //Nใo permite ser executado simultaneamente, para a mesma empresa/filial.

		ProcLogIni(aButtons)  //Cria botao para visualizar o log de execucao da rotina - Tabela CV8
	
		//Pergunta 01 SXG=030
		aHelpPor := {}
		aAdd(aHelpPor, "Informe o codigo do produ")
		aAdd(aHelpPor, "to que deseja substituir")
		PutSx1(cPerg, "01", "Prod.Atual", "Prod.Atual", "Prod.Atual", "mv_ch1", "C", TamSX3("B1_COD")[1], 0, 0, "G", "ExistCpo('SB1')", "SB1", "030", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 02 SXG=024
		aHelpPor := {}
		aAdd(aHelpPor, "Considera apenas os empenhos")
		aAdd(aHelpPor, "que estใo no armazem")
		PutSx1(cPerg, "02", "Armazem", "Armazem", "Armazem", "mv_ch2", "C", TamSX3("B2_LOCAL")[1], 0, 0, "G", "", "", "024", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 03
		aHelpPor := {}
		aAdd(aHelpPor, "Informe a data inicial dos")
		aAdd(aHelpPor, "empenhos.")
		PutSx1(cPerg, "03", "Dt.Inicial", "Dt.Inicial", "Dt.Inicial", "mv_ch3", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 04
		aHelpPor := {}
		aAdd(aHelpPor, "Informe a data final dos")
		aAdd(aHelpPor, "empenhos.")
		PutSx1(cPerg, "04", "Dt.Final", "Dt.Final", "Dt.Final", "mv_ch4", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 05
		aHelpPor := {}
		aAdd(aHelpPor, "Informe a OP inicial que")
		aAdd(aHelpPor, "sera utilizada no filtro.")
		PutSx1(cPerg, "05", "OP Inicial", "OP Inicial", "OP Inicial", "mv_ch5", "C", 13, 0, 0, "G", "", "SC2", "", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 06
		aHelpPor := {}
		aAdd(aHelpPor, "Informe a OP final que")
		aAdd(aHelpPor, "sera utilizada no filtro.")
		PutSx1(cPerg, "06", "OP Final", "OP Final", "OP Final", "mv_ch6", "C", 13, 0, 0, "G", "", "SC2", "", "", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		//Pergunta 07
		aHelpPor := {}
		aAdd(aHelpPor, "Informe o codigo do produ")
		aAdd(aHelpPor, "to que sera utilizado")
		PutSx1(cPerg, "07", "Prod.Destino", "Prod.Destino", "Prod.Destino", "mv_ch7", "C", TamSX3("B1_COD")[1], 0, 0, "G", "ExistCpo('SB1')", "SB1", "030", "", "MV_PAR07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)
	
		aAdd(aSays, "Essa rotina tem por objetivo alterar os empenhos do produto ORIGEM para")
		aAdd(aSays, "um novo c๓digo.")
		aAdd(aSays, "Para essa altera็ใo ser realizada ้ necessแrio que, o empenho ainda nใo tenha")
		aAdd(aSays, "sofrido nenhuma movimentacao.")
		aAdd(aSays, " ")
		aAdd(aSays, "ATENCAO, Essa rotina nใo altera as SCs ja geradas.")
		aAdd(aSays, " ")
		
		aAdd(aButtons,{5, .T., {|o| Pergunte(cPerg, .T.)}})
		aAdd(aButtons,{1, .T., {|o| nOpca := 1, FechaBatch()}})
		aAdd(aButtons,{2, .T., {|o| nOpca := 2, FechaBatch()}})
		FormBatch(cTitoDlg, aSays, aButtons)
		
		If nOpca == 1
			Pergunte(cPerg, .F.)
			If (MV_PAR01 == MV_PAR07) .or. Empty(MV_PAR07)  //Produtos iguais
				aPMsgStop("Produto origem e destino sใo iguais, favor rever os parโmetros.", "ATENวรO")
				Return
			EndIf   
			
			/*
			//produtos que possuem estrutura nao sao aceitos			
			SG1->(DbSetOrder(1))
			If SG1->(DbSeek(xFilial("SG1") + MV_PAR07, .F.))
				aPMsgStop("O produto destino possui estrutura, nใo serแ possํvel efetuar a troca.", "ATENวรO")
				Return
			EndIf
	
			//produtos que possuem estrutura nao sao aceitos			
			If SG1->(DbSeek(xFilial("SG1") + MV_PAR01, .F.))
				aPMsgStop("O produto origem possui estrutura, nใo serแ possํvel efetuar a troca.", "ATENวรO")
				Return
			EndIf
			*/
			
			//Produtos com unidades de medida diferentes
			If Posicione("SB1", 1, xFilial("SB1") + MV_PAR01, "B1_UM") != Posicione("SB1", 1, xFilial("SB1") + MV_PAR07, "B1_UM")
				aPMsgStop("O produto origem e o destino devem possuir a mesma unidade de medida.", "ATENวรO")
				Return
			EndIf

			Processa({|| MPCP03A()})  //Executa a alteracao dos empenhos
			
			If (cMailDest <> "")
	   		cMensagem += CHR_FONT_DET_OPEN
		 		cMensagem += "A rotina de Substitui็ใo de Empenho foi utilizada com os seguintes parametros: " + CHR_ENTER  
	         cMensagem += "Prod.Atual: " + AllTrim(MV_PAR01) + CHR_ENTER
	         cMensagem += "Armazem: " + AllTrim(MV_PAR02) + CHR_ENTER
	         cMensagem += "Dt.Inicial: " + AllTrim(MV_PAR03) + CHR_ENTER
	         cMensagem += "Dt.Final: " + AllTrim(MV_PAR04) + CHR_ENTER
	         cMensagem += "OP Inicial: " + AllTrim(MV_PAR05) + CHR_ENTER
	         cMensagem += "OP Final: " + AllTrim(MV_PAR06) + CHR_ENTER
				cMensagem += "Prod.Destino: " + AllTrim(MV_PAR07) + CHR_ENTER
				cMensagem += "Empresa: " + SM0->M0_CODIGO + " Filial:" + SM0->M0_CODFIL + CHR_ENTER + CHR_ENTER
	         cMensagem += "O usuแrio: (" + cUserName + ") foi o responsแvel pela execu็ใo da rotina."   
		 		cMensagem += CHR_FONT_DET_CLOSE  
		 		// Enviar o e-mail     
				U_EnvMail("empenho@taiff.com.br", cMailDest, "Substitui็ใo de Empenho", OemToAnsi(cMensagem))		
	   	EndIf    

		EndIf    

		UnLockByName("MPCP03_" + SM0->(M0_CODIGO + M0_CODFIL), .T., .T., .T.)  //Libera semaforo.
		
	Else
		aPMsgStop("Esta rotina jแ estแ sendo executada por outro usuแrio, favor tentar novamente mais tarde...", "ATENวรO")		
	EndIf

Return

Static Function MPCP03A()
	Local cQuery  := ""
	Local cCampo  := ""
	Local nHandle := ""
	Local nTotReg := 0
	Local nI      := 0
	Local aLogErr := {}
	Local cEof    := Chr(13)+Chr(10)
	
	SB1->(DbSetOrder(1))  //Produtos              - B1_FILIAL+B1_COD
	SB2->(DbSetOrder(1))  //Saldos em estoque     - B2_FILIAL+B2_COD+B2_LOCAL
	SC2->(DbSetOrder(1))  //Ordens de producao    - C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	SD4->(DbSetOrder(1))  //Empenhos              - D4_FILIAL+D4_COD+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE
	SB8->(DbSetOrder(3))  //Saldos por lote       - B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
	SBF->(DbSetOrder(1))  //Saldos por endereco   - BF_FILIAL+BF_LOCAL+BF_LOCALIZ+BF_PRODUTO+BF_NUMSERI+BF_LOTECTL+BF_NUMLOTE
	SDC->(DbSetOrder(2))  //Composi็ใo do empenho - DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE+DC_LOCALIZ+DC_NUMSERI

	//Apenas os empenhos que nao foram pagos "D4_QTDPG = 0" e, os empenhos que ainda nao foram
	//baixados "D4_QUANT = D4_QTDEORI", fazem parte da query.
	cQuery := "SELECT D4_FILIAL, D4_COD, D4_LOCAL, D4_OP, D4_TRT, D4_DATA, D4_QTDEORI, D4_QUANT,"
	cQuery += " D4_QTDPG, D4_LOTECTL, D4_NUMLOTE, D4_QSUSP, D4_SITUACA, D4_ORDEM, D4_OPORIG, D4_SEQ,"
	cQuery += " R_E_C_N_O_ AS NUMREG"
	cQuery += " FROM " + RetSqlName("SD4") + " SD4"
	cQuery += " WHERE D4_FILIAL = '" + xFilial("SD4") + "'"
	cQuery += "   AND D4_COD    = '" + MV_PAR01 + "'"
	cQuery += "   AND D4_LOCAL  = '" + MV_PAR02 + "'"
	cQuery += "   AND D4_DATA  >= '" + Dtos(MV_PAR03) + "'"
	cQuery += "   AND D4_DATA  <= '" + Dtos(MV_PAR04) + "'"
	cQuery += "   AND D4_OP    >= '" + MV_PAR05 + "'"
	cQuery += "   AND D4_OP    <= '" + MV_PAR06 + "'"
	cQuery += "   AND D4_QUANT  = D4_QTDEORI"
	cQuery += "   AND D4_QTDPG  = 0"
	cQuery += "   AND SD4.D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY D4_FILIAL, D4_COD, D4_DATA, D4_OP, D4_TRT"
	cQuery := ChangeQuery(cQuery)

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRB1", .F., .F.)
	TcSetField("TRB1", "D4_DATA", "D", 8, 0)
	
	Begin Transaction  //Inicia o controle de transacao
		ProcLogAtu("INICIO")  //Cria o log inicial de execucao da rotina
		//Grava os parametros usados na rotina
		ProcLogAtu("MENSAGEM", "Produto Atual: " + MV_PAR01) 
		ProcLogAtu("MENSAGEM", "Armazem .....: " + MV_PAR02) 
		ProcLogAtu("MENSAGEM", "Data Inicial.: " + Dtoc(MV_PAR03))
		ProcLogAtu("MENSAGEM", "Data Final...: " + Dtoc(MV_PAR04))
		ProcLogAtu("MENSAGEM", "OP Inicial...: " + MV_PAR05)
		ProcLogAtu("MENSAGEM", "OP Final.....: " + MV_PAR06)
		ProcLogAtu("MENSAGEM", "Prod.Destino.: " + MV_PAR07)
		TRB1->(DbGoTop())
		ProcRegua(TRB1->(LastRec()))
		While TRB1->(!Eof())
			SC2->(DbSeek(xFilial("SC2") + TRB1->D4_OP, .F.))  //Posiciona na OP
			SB1->(DbSeek(xFilial("SB1") + TRB1->D4_COD, .F.)) //Posiciona no produto
	
			If !SDC->(DbSeek(xFilial("SDC") + TRB1->(D4_COD+D4_LOCAL+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE), .F.)) //Nใo localizou na SDC-Composi็ใo do empenho
				
				If !SD4->(DbSeek(TRB1->D4_FILIAL + MV_PAR07 + TRB1->(D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE) + MV_PAR02, .F.))  //Verifica chave duplicada na SD4
		            
					SB2->(DbSeek(xFilial("SB2") + TRB1->(D4_COD+D4_LOCAL), .F.))
					SD4->(DbGoTo(TRB1->NUMREG))
					SD4->(RecLock("SD4", .F.))
	
					//Elimina o empenho original
					GravaB2Emp("-", SD4->D4_QUANT, SC2->C2_TPOP)
					
					//Cria o novo empenho
					SD4->D4_COD := MV_PAR07
					SD4->D4_DTVALID := DATE() //Altera a data para a data atual, afim de guardar o hist๓rico de quando foi feita a substitui็ใo
					SD4->(MsUnLock())
					
					SB1->(DbSeek(xFilial("SB1") + MV_PAR07, .F.))
					If !SB2->(DbSeek(xFilial("SB2") + MV_PAR07 + MV_PAR02, .F.))
						CriaSB2(MV_PAR07, MV_PAR02)
					EndIf
					GravaB2Emp("+", SD4->D4_QUANT, SC2->C2_TPOP)
					
					nTotReg++
				Else
					//Grava log "CV8" da inconsistencia encontrada
					ProcLogAtu("ERRO","Chave Duplicada: " + TRB1->D4_FILIAL + MV_PAR07 + TRB1->(D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE) + MV_PAR02)
					aAdd(aLogErr, TRB1->NUMREG)
				EndIf
	
			Else  //Existe empenho por endereco ou lote			
			
				If !SD4->(DbSeek(TRB1->D4_FILIAL + MV_PAR07 + TRB1->(D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE) + MV_PAR02, .F.))  //Verifica chave duplicada na SD4

					SB2->(DbSeek(xFilial("SB2") + TRB1->(D4_COD+D4_LOCAL), .F.))

					SD4->(DbGoTo(TRB1->NUMREG))
					SD4->(RecLock("SD4", .F.))
					//Elimina o empenho original
					GravaB2Emp("-", SD4->D4_QUANT, SC2->C2_TPOP)

					//Cria o novo empenho
					SD4->D4_COD := MV_PAR07
					SD4->(MsUnLock())
					SB1->(DbSeek(xFilial("SB1") + MV_PAR07, .F.))
					If !SB2->(DbSeek(xFilial("SB2") + MV_PAR07 + MV_PAR02, .F.))
						CriaSB2(MV_PAR07, MV_PAR02)
					EndIf
					GravaB2Emp("+", SD4->D4_QUANT, SC2->C2_TPOP)

					While SDC->(DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE) == ;
					     TRB1->(D4_FILIAL+D4_COD+D4_LOCAL+D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE) .and. !SDC->(Eof())

						If SDC->DC_ORIGEM != "SC2"
							SDC->(DbSkip())
							Loop
						EndIf

						If !Empty(SDC->DC_LOCALIZ)  //Existe empenho por endereco
							SBF->(DbSeek(xFilial("SBF") + SDC->(DC_LOCAL+DC_LOCALIZ+DC_PRODUTO), .F.))
							GravaBFEmp("-", SDC->DC_QUANT, SC2->C2_TPOP)
						EndIf

						If !Empty(SDC->DC_LOTECTL)  //Existe empenho por lote
							SB8->(DbSeek(xFilial("SB8") + SDC->(DC_PRODUTO+DC_LOCAL+DC_LOTECTL), .F.))
							GravaB8Emp("-", SDC->DC_QUANT, SC2->C2_TPOP)
						EndIf

						SDC->(RecLock("SDC", .F.))
						SDC->(DbDelete())
						SDC->(MsUnLock())
						SDC->(DbSkip())
					EndDo
					nTotReg++
				Else
					//Grava log "CV8" da inconsistencia encontrada
					ProcLogAtu("ERRO","Chave Duplicada: " + TRB1->D4_FILIAL + MV_PAR07 + TRB1->(D4_OP+D4_TRT+D4_LOTECTL+D4_NUMLOTE) + MV_PAR02)
					aAdd(aLogErr, TRB1->NUMREG)
				EndIf
			EndIf
			TRB1->(DbSkip())
			IncProc("Processando empenhos OP: " + TRB1->D4_OP + " ...")
		EndDo
		TRB1->(DbCloseArea())
		ProcLogAtu("FIM")  //Grava o log de termino de execucao da rotina
	End Transaction  //Fim do controle de transacao

	//Impressao do log de inconsistencia.
	If Len(aLogErr) > 0
		cArqLog:= "C:\TEMP\MPCP03_LOG_" + Dtos(dDataBase) + StrTran(Time(), ":", "") + ".TXT"  //Cria arquivo texto com as inconsistencias
		nHandle:= Fcreate(cArqLog)
		cCampo := "Lista de empenhos que nใo foram alterados." + cEof
		cCampo += "Data: " + Dtoc(dDataBase) + " Hora: " + Time() + cEof
		cCampo += "Parametros utilizados" + cEof
		cCampo += "Produto origem: " + MV_PAR01 + cEof
		cCampo += "Almoxarifado  : " + MV_PAR02 + cEof
		cCampo += "Data Inicial  : " + Dtos(MV_PAR03) + cEof
		cCampo += "Data Final    : " + Dtos(MV_PAR04) + cEof
		cCampo += "OP Inicial    : " + MV_PAR05 + cEof
		cCampo += "OP Final      : " + MV_PAR06 + cEof
		cCampo += "Prod.Destino  : " + MV_PAR07 + cEof + cEof
		Fwrite(nHandle, cCampo)
		For nI := 1 To Len(aLogErr)
			SD4->(DbGoTo(aLogErr[nI]))
			cCampo := "Filial: " + SD4->D4_FILIAL
			cCampo += " Codigo: " + SD4->D4_COD
			cCampo += " OP: " + SD4->D4_OP
			cCampo += " Seq: " + SD4->D4_TRT
			cCampo += " Lote: " + SD4->D4_LOTECTL
			cCampo += " Sub.Lote: " + SD4->D4_NUMLOTE
			cCampo += " Local: " + SD4->D4_LOCAL + " .Ja existe dados para o produto destino." + cEof
			Fwrite(nHandle, cCampo)
		Next nI
		Fclose(nHandle)
		aPMsgAlert("As altera็๕es foram finalizadas e ocorreram inconsist๊ncias, favor verificar a pr๓xima tela...", "Termino c/Erro")
		WinExec("C:\WINDOWS\NOTEPAD.EXE " + cArqLog, 1)  //Executa o NOTEPAD para mostrar os erros
	Else
		aPMsgInfo("As altera็๕es foram finalizadas, registros processados: " + Ltrim(Str(nTotReg)), "Termino s/Erro")
	EndIf	
Return
