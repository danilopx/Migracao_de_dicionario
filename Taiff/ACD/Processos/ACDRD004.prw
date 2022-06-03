// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ACDRD004.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 22/02/2018 | pbindo            | Gerado com auxํlio do Assistente de C๓digo do TDS.
// -----------+-------------------+---------------------------------------------------------
#INCLUDE "protheus.ch"
#INCLUDE "AP5MAIL.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE CRLF ( chr(13)+chr(10) )

User Function ACDRD004()
	Private lWeb := .F.

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0		
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "04" FILIAL "02"  MODULO "EST"		
		lImporta := Iif(GetMV("MV__ACDR4")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA

		If !lImporta
			//Conout("rotina geracao de apontamento de OP offline ja esta sendo executada - ACDRD004 em "+Dtoc(Date())+"-"+Time())
		//Else

			//U_2EnvMail("workflow@taiff.com.br","grp_sistemas@taiffproart.com.br;renan.bruniera@taiff.com.br"	,"","Inicio da rotina ACDRD004 em " + DTOC(DATE()) + " as " + TIME() ,"Apontamento de OP offline ",'')
			//Conout("Inicio da rotina geracao de apontamento de OP offline - ACDRD004 em "+Dtoc(Date())+"-"+Time())
			PutMv("MV__ACDR4","S")
			PutMv("MV__ACDR42",Dtoc(Date())+"-"+Time())
			
			dDataBase := Date()			
			ACDRD04GERA()
			PutMv("MV__ACDR4","N")
			
			//Conout("Fim da rotina geracao de apontamento de OP offline - ACDRD004 em "+Dtoc(Date())+"-"+Time())
			//U_2EnvMail("workflow@taiff.com.br","grp_sistemas@taiffproart.com.br;renan.bruniera@taiff.com.br"	,"","Termino da rotina ACDRD004 em " + DTOC(DATE()) + " as " + TIME(),"Apontamento de OP offline ",'')
		EndIf
		RESET ENVIRONMENT
	Else
		If MsgYesNo("Esta rotina irแ gerar as baixas doa apontamentos offline, deseja continuar?")
			Processa( {|| ACDRD04GERA() } )
			MsgInfo("Opera็ใo Finalizada!")
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDRD03GERAบAutor  ณMicrosiga          บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ACDRD04GERA()

	Local nTamSX1  := 10//Len(SX1->X1_GRUPO)
	Local cCalend,cH6PT,cTempo2
	Local nTempoPar,nTempoTra
	Local nMinutos,nTempo1,nTempo2


	Local aMata681 := {}


	Local cHrIni  := ""
	Local cHrFim  := Left(Time(),5)
	Local dDtIni  := CTOD("  /  /    ")
	Local dDtFim  := dDataBase
	Local lCfUltOper := GetMV("MV_VLDOPER") == "S" // Verifica se tem controle de operacoes
	Local aMata682:= {}
	Local nOpcao

	Private lMsHelpAuto:= .f.
	Private lMSErroAuto:= .f.


	cQuery := " SELECT SUM(CBH_QTD) CBH_QTD, CBH_OP,CBH_OPERAC,CBH_RECUR,CBH_TIPO,COUNT(DISTINCT(CBH_OPERAD))CBH_OPERAD, MAX(CBH_DTFIM) CBH_DTFIM, MIN(CBH_DTINI) CBH_DTINI,
	cQuery += " (SELECT C2_QUANT FROM "+RetSqlName("SC2")+" WITH(NOLOCK) WHERE C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP AND D_E_L_E_T_ <> '*' ) C2_QUANT
	cQuery += " FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) 
	cQuery += " WHERE NOT EXISTS ( SELECT 'S'   FROM "+RetSqlName("SH6")+" WITH(NOLOCK) WHERE CBH_FILIAL = H6_FILIAL AND CBH_OP = H6_OP  AND D_E_L_E_T_ <> '*') AND D_E_L_E_T_ <> '*' 
	cQuery += " AND CBH_OPERAC = '01' AND CBH_TRANSA = '02' AND CBH_DTFIM <> '' AND CBH_HRFIM <> ''  
	cQuery += " AND CBH_OP NOT IN (SELECT C2_NUM+C2_ITEM+C2_SEQUEN FROM "+RetSqlName("SC2")+" WITH(NOLOCK) WHERE C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP AND C2_FILIAL = CBH_FILIAL AND D_E_L_E_T_ <> '*' AND C2_QUANT <= C2_QUJE) 

	cQuery += " AND ((SELECT C2_QUANT FROM "+RetSqlName("SC2")+" WITH(NOLOCK) WHERE C2_NUM+C2_ITEM+C2_SEQUEN = CBH_OP AND D_E_L_E_T_ <> '*' ) 
	cQuery += " <= (SELECT COUNT(*) FROM "+RetSqlName("CBH")+" CBH2 WITH(NOLOCK) WHERE CBH2.CBH_FILIAL = CBH.CBH_FILIAL AND CBH2.CBH_OP = CBH.CBH_OP  AND CBH2.CBH_OPERAC = '01' AND CBH2.CBH_TRANSA = '02' AND CBH2.CBH_DTFIM <> '' AND CBH2.CBH_HRFIM <> '' )) 
	cQuery += "  GROUP BY CBH_OP , CBH_FILIAL,CBH_OPERAC,CBH_RECUR,CBH_TIPO

	MEMOWRITE("ACDRD004.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	TCSETFIELD("TRB","CBH_DTINI","D")
	TCSETFIELD("TRB","CBH_DTFIM","D")

	Count To nCount

	If nCount == 0 
		If !lWeb
			MsgStop("Nใo foram encontrados dados!","Aten็ใo - ACDRD004")
		//Else
			//Conout("Nใo foram encontrados dados!","Aten็ใo - ACDRD004")
		EndIf
		PutMv("MV__ACDR4","N")		
		TRB->(dbCloseArea())
		Return
	EndIf

	dbSelectArea("TRB")
	dbGoTop()

	ProcRegua(nCount)

	dbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->(DbSeek(PADR("MTA680",nTamSX1)+"04"))  // Confirma que sempre ira permitir o apontamento de Horas conforme a pergunte
		RecLock("SX1",.F.)
		nAnterior:= SX1->X1_PRESEL // Salva a configuracao atual da pergunte
		SX1->X1_PRESEL:= 1
	Endif
	MsUnlock()

	//Conout("ENCONTADA "+StrZero(nCount,6)+" OPS")
	nResta := nCount+1 //soma 1 para que a contagem nao termine no zero

	While !EOF()

		If !lWeb
			IncProc("Gerando apontamentos na SH6")
			Processmessages()
		Else
			nResta --
			//Conout("FALTAM "+StrZero(nResta,6)+" OPS - "+Dtoc(Date())+"-"+Time())
		EndIf

		//VARIAVEIS DA OP
		cOP 		:= TRB->CBH_OP 
		cOperacao 	:= TRB->CBH_OPERAC
		nAMais		:= TRB->CBH_QTD - TRB->C2_QUANT //QUANTIDADE REGISTROS DIGITADOS A MAIS
		cProduto 	:= Posicione("SC2",1,xFilial("SC2")+TRB->CBH_OP,"C2_PRODUTO") 
		cLocPad  	:= Posicione("SC2",1,xFilial("SC2")+TRB->CBH_OP,"C2_LOCAL") 
		cRecurso 	:= TRB->CBH_RECUR
		cOperador 	:= "" 
		cTipAtu 	:= TRB->CBH_TIPO
		nQtd 		:= TRB->CBH_QTD-nAMais
		nOperadores := TRB->CBH_OPERAD
		dDtIni 		:= TRB->CBH_DTINI
		cHrIni 		:= ""
		dDtFim 		:= TRB->CBH_DTFIM
		cHrFim 		:= ""
		
		

		Begin Transaction
			//SELECIONA APONTAMENTOS PARA CALCULO DO TEMPO
			cQuery := " SELECT * FROM "+RetSqlName("CBH")+" WITH(NOLOCK)
			cQuery += " WHERE 
			cQuery += " D_E_L_E_T_ <> '*' AND CBH_FILIAL = '"+cFilAnt+"'
			cQuery += " AND CBH_OP = '"+TRB->CBH_OP+"'
			cQuery += " AND CBH_OPERAC = '01' AND CBH_TRANSA = '02'

			MEMOWRITE("ACDRD004A.SQL",cQuery)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

			TCSETFIELD("TRB1","CBH_DTINI","D")
			TCSETFIELD("TRB1","CBH_DTFIM","D")

			Count To nRec

			dbSelectArea("TRB1")
			dbGoTop()
			nTempTot := 0
			//Conout("OP COM  "+StrZero(nRec,6)+" REGISTROS ")
			n1Resta := nRec +1
			lMVUSACALE := SuperGetMV("MV_USACALE",.F.,.T.)

			While !Eof()
				n1Resta --
				//Conout("FALTAM "+StrZero(n1Resta,6)+" REGISTROS - "+Dtoc(Date())+"-"+Time()+" OP - "+cOP)

				//PULA REGISTROS DIGITADOS A MAIS
				If n1Resta <= nAMais
				//CONOUT('PULANDO REGISTRO')
					dbSelectArea("TRB1")
					dbSkip()
					Loop		
				EndIf

				aMata682 := {}
				aMata681 := {}

				cH6PT:= '' // retirado preenchimento desta variavel pois o MATA681 efetua gravacao do campo H6_PT de acordo com as regras de negocios do PCP

				c1OP 		:= TRB1->CBH_OP 
				c1Operacao 	:= TRB1->CBH_OPERAC

				c1Produto 	:= Posicione("SC2",1,xFilial("SC2")+TRB1->CBH_OP,"C2_PRODUTO") 
				c1LocPad  	:= Posicione("SC2",1,xFilial("SC2")+TRB1->CBH_OP,"C2_LOCAL") 
				c1Recurso 	:= TRB1->CBH_RECUR
				c1Operador 	:= TRB1->CBH_OPERAD 
				c1TipAtu 	:= TRB1->CBH_TIPO
				n1Qtd 		:= TRB1->CBH_QTD
				d1DtIni 	:= TRB1->CBH_DTINI
				c1HrIni 	:= TRB1->CBH_HRINI
				d1DtFim 	:= TRB1->CBH_DTFIM
				c1HrFim 	:= TRB1->CBH_HRFIM




				If d1DtIni == d1DtFim .and. c1HrIni == c1HrFim
					c1HrFim:= Left(c1HrFim,3)+StrZero(Val(Right(c1HrFim,2))+1,2)
					If Right(c1HrFim,2) == "60"
						c1HrFim:= StrZero(Val(Left(c1HrFim,2))+1,2)+":00"
						If Left(c1HrFim,2)== "24"
							c1HrFim:= "00:00"
							d1DtFim++
						EndIf
					EndIf
				Endif

				cCalend := GetMV("MV_CBCALEN") // Parametro onde e informado o calendario padrao que deve ser utilizado
				If Empty(cCalend)
					cCalend := Posicione("SH1",1,xFilial("SH1")+cRecurso,"H1_CALEND")
				Endif



				//VERIFICA SE EXISTE PAUSA
				cQuery := "SELECT * FROM "+RetSqlName("CBH")+" WITH(NOLOCK)
				cQuery += " WHERE D_E_L_E_T_ <> '*'
				cQuery += " AND CBH_OPERAC = '01' AND CBH_TRANSA >= '50'
				cQuery += " AND CBH_OP = '"+c1OP+"'
				cQuery += " AND CBH_OPERAD = '"+c1Operador+"'
				cQuery += " AND CBH_HRINI >= '"+TRB1->CBH_HRINI+"' AND CBH_HRFIM <= '"+TRB1->CBH_HRFIM+"' AND CBH_DTINI = '"+Dtos(TRB1->CBH_DTINI)+"' AND CBH_DTFIM = '"+Dtos(TRB1->CBH_DTFIM)+"'

				MEMOWRITE("ACDRD003A.SQL",cQuery)
				dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB2", .F., .T.)

				TCSETFIELD("TRB2","CBH_DTINI","D")
				TCSETFIELD("TRB2","CBH_DTFIM","D")
				Count To nRec
				nTempoPar := 0
				If nRec > 0
					dbSelectArea("TRB2")
					dbGoTop()

					nTempoPar:= IF(lMVUSACALE,TRB2->(PmsHrsItvl(CBH_DTINI,CBH_HRINI,CBH_DTFIM,CBH_HRFIM,cCalend,"",cRecurso,.T.)),TRB2->(A680Tempo(CBH_DTINI,CBH_HRINI,CBH_DTFIM,CBH_HRFIM)))

					//QUANTO NAO CONSIDERA NO CUSTO NAO GERA SH6
					If TRB2->CBH_TIPO == '2'
						//GRAVA HORAS IMPRODUTIVAS
						nMinutos  := (nTempoPar-Int(nTempoPar))*60
						cTotHrImp2:= StrZero(Int(nTempoPar),3)+":"+StrZero(nMinutos,2)
						aAdd(aMata682,{"H6_OP"	   	,c1OP ,NIL})
						aAdd(aMata682,{"H6__MO"	   	, 	1    	 ,NIL})
						aadd(aMata682,{"H6_RECURSO"	,c1Recurso   ,NIL})
						aadd(aMata682,{"H6_MOTIVO"  ,TRB2->CBH_TRANSA  ,NIL})
						aadd(aMata682,{"H6_DATAINI" ,TRB2->CBH_DTINI    ,NIL})
						aadd(aMata682,{"H6_HORAINI" ,TRB2->CBH_HRINI    ,NIL})
						aadd(aMata682,{"H6_DATAFIN" ,TRB2->CBH_DTFIM    ,NIL})
						aadd(aMata682,{"H6_HORAFIN" ,TRB2->CBH_HRFIM    ,NIL})
						aadd(aMata682,{"H6_TEMPO"   ,cTotHrImp2,NIL})
						aadd(aMata682,{"H6_DTAPONT" ,dDataBase ,NIL})
						aadd(aMata682,{"H6_OPERADO" ,c1Operador ,NIL})
						aadd(aMata682,{"H6_CBFLAG"  ,"1"       ,NIL}) // Flag que indica que foi gerado pelo ACD
						aadd(aMata682,{"H6_TIPO" ,"I" ,NIL})

						If (SH6->(FieldPos("H6_LOCAL")) > 0)
							aadd(aMata682,{"H6_LOCAL",c1LocPad, NIL})
						EndIf
					EndIf
				EndIf
				TRB2->(dbCloseArea())


				dbSelectArea("TRB1")

				nTempoTra := IF(lMVUSACALE,PmsHrsItvl(d1DtIni,c1HrIni,d1DtFim,c1HrFim,cCalend,"",cRecurso,.T.),A680Tempo(d1DtIni,c1HrIni,d1DtFim,c1HrFim))
				nTempo1   := nTempoTra - nTempoPar
				//ACUMULA TEMPO TOTAL
				nTempTot  += nTempo1

				If !Empty(aMata682) //APONTA HORAS IMPRODUTIVAS
					lMsHelpAuto := .T.
					lMSErroAuto := .F.
					nOpcao      := 3 //Inclusao
					MsExecAuto({|x,y|MATA682(x,y)},aMata682,nOpcao)				
					lMsHelpAuto:=.F.

					If lMSErroAuto
						If !lWeb
							MostraErro()
						EndIf
						DisarmTransaction()
					//Else
						//CONOUT("GERANDO APONTAMENTO DE PAUSA")
					EndIf
				EndIf


				dbSelectArea("TRB1")
				dbSkip()
			End
			TRB1->(dbCloseArea())
			
			nTempo2   := Int(nTempTot)
			nMinutos  := (nTempTot-nTempo2)*60
			If nMinutos == 60
				nTempo2++
				nMinutos:= 0
			Endif

			cTempo2:= StrZero(nTempo2,3)+":"+StrZero(nMinutos,2)


			aAdd(aMata681,{"H6_OP", cOP              ,NIL})
			aAdd(aMata681,{"H6_PRODUTO", cProduto    ,NIL})
			aAdd(aMata681,{"H6__MO"	   , nOperadores ,NIL})
			aAdd(aMata681,{"H6_OPERAC" , cOperacao   ,NIL})
			aAdd(aMata681,{"H6_RECURSO", cRecurso    ,NIL})
			aAdd(aMata681,{"H6_DATAINI", dDtIni      ,NIL})
			aAdd(aMata681,{"H6_HORAINI", cHrIni      ,NIL})
			aAdd(aMata681,{"H6_DATAFIN", dDtFim      ,NIL})
			aAdd(aMata681,{"H6_HORAFIN", cHrFim      ,NIL})
			//			If SuperGetMV("MV_CBCALPR", .F., .T.) == .T.
			aAdd(aMata681,{"H6_TEMPO"  , cTempo2 ,NIL})
			//EndIf
			aAdd(aMata681,{"H6_OPERADO", cOperador   ,NIL})
			aAdd(aMata681,{"H6_DTAPONT", dDataBase   ,NIL})
			aAdd(aMata681,{"H6_QTDPROD", nQtd    ,NIL})

			If !Empty(cH6PT)
				aAdd(aMata681,{"H6_PT"  , cH6PT      ,NIL})
			Endif
			aAdd(aMata681,{"H6_CBFLAG","1"           ,NIL}) // Flag que indica que foi gerado pelo ACD

			If !lCfUltOper
				aAdd(aMata681,{"AUTASKULT",.F.,NIL})
			Endif

			If (SH6->(FieldPos("H6_LOCAL")) > 0)
				aadd(aMata681,{"H6_LOCAL",cLocPad    ,NIL})
			EndIf
			/*
			If Rastro(SC2->C2_PRODUTO)
			aadd(aMata681,{"H6_LOTECTL",cLote    ,Nil})
			aadd(aMata681,{"H6_DTVALID",dValid   ,Nil})
			EndIf
			*/

			lMsHelpAuto := .T.
			lMSErroAuto := .F.
			msExecAuto({|x|MATA681(x)},aMata681)


			lMsHelpAuto:=.F.
			If lMSErroAuto	
				If !lWeb
					MostraErro()
				Else
					//Conout("ERRO APONTAMENTO OP "+cOP)	
					DisarmTransaction()
				EndIf
			//Else
				//CONOUT('OP APONTADA CORRETAMENTE - '+cOP)
			EndIf

		End Transaction
		//		U_ESPERA() //TEMPO ENTRE UMA EXECUCAO

		dbSelectArea("TRB")
		dbSkip()
	EndDo

	TRB->(dbCloseArea())

	dbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->(DbSeek(PADR("MTA680",nTamSX1)+"04"))
		RecLock("SX1",.F.)
		SX1->X1_PRESEL:= nAnterior  // Restaura a configuracao da pergunte
	Endif

	MsUnlock() // Tira o Lock do SX1 somente apos a execucao da rotina automatica

	/*
	//horas improdutivas
	If lHrImp
	If !Empty(nTotHrImp1)
	nMinutos  := (nTotHrImp1-Int(nTotHrImp1))*60
	cTotHrImp2:= StrZero(Int(nTotHrImp1),3)+":"+StrZero(nMinutos,2)
	GravaHrImp(cOP,cOperacao,cRecurso,dDtini,cHrini,dData2,cHora2,cTotHrImp2,cTransac,cOperador,lEstorna)
	EndIf
	dData1  := CTOD(" ")
	cHora1  := " "
	dData2  := CTOD(" ")
	cHora2  := " "
	DbGoTo(nRecCBH)
	Else
	CBH->(DBSkip())
	Endif

	*/

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESPERA    บAutor  ณMicrosiga           บ Data ณ  12/15/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณROTINA PARA DAR UMA PAUSA ENTRE IMPORTACOES DE PEDIDOS      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
User Function Espera()
Local nMilSec		:= GetMV("MV__SLEEP") //TEMPO EM MILISEGUNDOS PARA ESPERA ENTRE TAREFAS

Sleep(nMilSec) //TEMPO DE ESPERA PARA EVITAR TRAVAMENTOS

Return
*/
