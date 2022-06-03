#include "protheus.ch"
#include "tbiconn.ch"

#DEFINE ENTER CHR(13) + CHR(10) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRQEENTR  ºAutor  ³ Rodrigo Fazan      º Data ³  26/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³programa para gravacao de informacoes complementares        º±±
±±º          ³na NFE de entrada                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function GQREENTR()
	
	Local om_Obs
	Local cm_Obs := ""
	Local lOk := .f.
	Local aButtons	:= {}
	Local aAreaD1
	Local aAreaD3
	Local lSF1CROSS := .F.
	
	Private oDlg				// Dialog Principal

	aAreaD1 := GetArea("SD1")
	aAreaD3 := GetArea("SD3")

	If FunName() == "MATA103" .AND. SF1->( FieldPos("F1_NUMRM") ) > 0
		If ALLTRIM(SF1->F1_NUMRM) = "CROSS"
			lSF1CROSS := .T. 
		EndIf
	EndIf

	If FunName() == "MATA103" .AND. .NOT. lSF1CROSS
		DEFINE MSDIALOG oDlg TITLE "Observações da NFe" FROM 0,0 TO 175,400 PIXEL
		
		// Cria as Groups do Sistema
		@ 15,5 TO 80,195 LABEL " Observações: (máximo 800)" PIXEL OF oDlg
		
		// Cria Componentes Padroes do Sistema
		@ 25,10 GET om_Obs Var cm_Obs MEMO Size 180,50 PIXEL OF oDlg
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| if( ValObs(cm_Obs),(lOk := .t., oDlg:End()),nil) },{|| lOk := .f.,oDlg:End()},,aButtons)
		
		if lOk .and. SF1->( FieldPos("F1_OBSNFE") ) > 0
			RecLock("SF1", .f.)
			SF1->F1_OBSNFE := cm_Obs
			SF1->(MsUnlock())
		endif
	EndIf
	
	//ATUALIZA A SD3 COM O NUMERO DA NOTA DE BENEFICIAMENTO
	If SF1->F1_TIPO == "N"
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial()+CNFISCAL+CSERIE+CA100FOR+CLOJA)
		While !EOF() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == CNFISCAL+CSERIE+CA100FOR+CLOJA
			If  !Empty(SD1->D1_OP)
				
				//VERIFICA SE EXISTE MOVIMENTACAO INTERNA E GRAVA OS DADOS DA NOTA
				dbSelectArea("SD3")
				dbSetOrder(2)
				If dbSeek(xFilial()+CNFISCAL+SD1->D1_COD)
					While !Eof() .And. xFilial()+CNFISCAL+SD1->D1_COD == SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD
						If !Empty(SD3->D3_OP) .And. Empty(SD3->D3_ESTORNO) .And. Empty(D3__NFEBN) .And. SD3->D3_EMISSAO == SD1->D1_DTDIGIT .And. SD3->D3_OP == SD1->D1_OP
							SD3->(MsUnLockAll())
							RecLock("SD3",.F.)
							D3__NFEBN	:= CNFISCAL
							D3__SNFEBN	:= CSERIE
							D3__FORNEC	:= CA100FOR
							SD3->(MsUnlock())
						EndIf
						dbSkip()
					End
				EndIf
			ElseIf !Empty(D1_NUMOP) //ATUALIZA A SD4 QUANDO FOR PERDA DE MATERIAL
				dbSelectArea("SD4")
				dbSetOrder(2)
				If dbSeek(xFilial()+SD1->D1_NUMOP+SD1->D1_COD)
					RecLock("SD4",.F.)
					D4__QTBNFC := D4__QTBNFC - SD1->D1_QUANT
					SD4->(MsUnlock())
				EndIf			
			EndIf
			dbSelectArea("SD1")
			dbSkip()
		End
	EndIf
	
	If FunName() == "MATA103" .AND. lSF1CROSS  
		/* liberacao automatica de pedido de venda apos o endereçamento dos itens */
		
		cMensLog := TFLIBaNFE()

		MSGALERT( cMensLog ,"Atenção")
		/* ****** Fim da liberacao automatica de pedido de venda ****** */
	EndIf
	
return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GRQEENTR  ºAutor  ³Microsiga           º Data ³  08/26/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function ValObs( cObs )
	if len( cObs ) > 800
		msgAlert( "O conteúdo da observação deverá conter no máximo 800 caracterers. Você digitou até o momento " + alltrim(str(len(cObs))) + " caracteres.","Atencao")
		return .f.
	endIf
return .t.


/*
--------------------------------------------------------------------------------------------------------------
Libera pedidos confirmados
--------------------------------------------------------------------------------------------------------------
*/		
Static Function TFLIBaNFE() 
Local cRetorno	:= "Recebimento da carga não realizada, NFe do CROSS DOCKING não encontrada!! " + ENTER + "Execute a rotina de recebimento"
Local nPedPrevisto := 0
Local nPedLiberado := 0
Local nTotPrevisto := 0
Local nTotLiberado := 0
Local cQuery		 := ""
Local __cNfEntrada	:= ""
Local __cSerieEntrada:= ""
Local __cNFTFornece	:= ""
Local __cNFTLjFornc	:= ""
Local _cFilMestre 	:= ""	
Local cChvCrossDock	:= ""
Local __cSF2Fornece	:= "" 
Local __cSF2LjFornc	:= ""
Local xSM0Alias		:= SM0->(GETAREA())

If CEMPANT="03" .AND. CFILANT="01" 

	lCredito	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
	lEstoque	:= .T.
	lLiber	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
	lTransf	:= .F.
	If GetMv("MV_ESTNEG") == "S"
		lAvEst:= .f.
	Else
		lAvEst:= .t.
	Endif                        
	/*
	Função: MaLibDoFat
	Retorna Quantidade Liberada
	Parametros                	
		ExpN1: Registro do SC6                                      
		ExpN2: Quantidade a Liberar                                 
		ExpL3: Bloqueio de Credito                                  
		ExpL4: Bloqueio de Estoque                                  
		ExpL5: Avaliacao de Credito                                 
		ExpL6: Avaliacao de Estoque                                 
		ExpL7: Permite Liberacao Parcial                            
		ExpL8: Tranfere Locais automaticamente                      
		ExpA9: Empenhos (Caso seja informado nao efetua a gravacao apenas avalia)
		ExpbA: CodBlock a ser avaliado na gravacao do SC9          
		ExpAB: Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)         
		ExpLC: Indica se apenas esta trocando lotes do SC9         
		ExpND: Valor a ser adicionado ao limite de credito         
		ExpNE: Quantidade a Liberar - segunda UM                   
	
	Parametros: MaLiberOk
		ExpA1: Array com numero de pedidos
		ExpL2: Elimina residuo
	
	*/


	__cNfEntrada	:= SF1->F1_DOC
	__cSerieEntrada:= SF1->F1_SERIE
	__cNFTFornece	:= SF1->F1_FORNECE
	__cNFTLjFornc	:= SF1->F1_LOJA
	_cFilMestre 	:= "02"	

	SM0->(DbSetOrder(1))
	SM0->(DbSeek( CEMPANT + CFILANT , .T.))	//Pego a filial mais proxima
	
	cQuery := "SELECT A1_COD, A1_LOJA " + ENTER
	cQuery += "FROM "+ RetSqlName("SA1") + " SA1 WITH(NOLOCK) " + ENTER
	cQuery += "WHERE " + ENTER
	cQuery += "	A1_FILIAL			= '" + _cFilMestre + "' " + ENTER
	cQuery += "	AND A1_CGC			= '" + ALLTRIM(SM0->M0_CGC) + "' " + ENTER
	cQuery += "	AND SA1.D_E_L_E_T_		= '' " + ENTER
	cQuery += "	AND A1_INTER='S'" + ENTER
	
	MemoWrite("GQREENTR_A1_COD_ORIGEM.SQL",cQuery)
	
	If Select("TMPCGC") > 0
		TMPCGC->(DbCloseArea())
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPCGC", .F., .T.)
	
	Count To nRec
	
	If nRec != 0 
		TMPCGC->(DbGoTop())
		__cSF2Fornece := TMPCGC->A1_COD 
		__cSF2LjFornc := TMPCGC->A1_LOJA
	Endif
	
	TMPCGC->(DbCloseArea())

	/*
	Busca o numero da carga dos pedidos gerados na nota fiscal de origem (filial mestre do Cross Docking).
	*/
	cQuery := "SELECT " + ENTER
	cQuery += "	DISTINCT SC9.C9_NUMOF " + ENTER
	cQuery += "FROM "+ RetSqlName("SC9") + " SC9 WITH(NOLOCK) " + ENTER
	cQuery += "WHERE " + ENTER
	cQuery += "	SC9.D_E_L_E_T_	= '' " + ENTER
	cQuery += "	AND C9_FILIAL	= '" + _cFilMestre + "' " + ENTER
	cQuery += "	AND C9_NFISCAL	= '" + __cNfEntrada + "' " + ENTER
	cQuery += "	AND C9_SERIENF	= '" + __cSerieEntrada + "' " + ENTER
	cQuery += "	AND C9_CLIENTE	= '" + __cSF2Fornece + "' " + ENTER
	cQuery += "	AND C9_LOJA 	= '" + __cSF2LjFornc + "' " + ENTER
	
	MemoWrite("GQREENTR_C9_NUMOF_CARGA.SQL",cQuery)

	If Select("TMPSC9") > 0
		TMPSC9->(DbCloseArea())
	Endif
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPSC9", .F., .T.)
	
	Count To nRec
	
	If nRec == 0 
		cChvCrossDock := "" 
	Else					
		TMPSC9->(DbGoTop())
		cChvCrossDock := TMPSC9->C9_NUMOF
	EndIf
	TMPSC9->(DbCloseArea())
	
	cQuery := "SELECT " + ENTER
	cQuery += "	SC5_MG.C5_NUMORI AS C5_NUM " + ENTER
	cQuery += "	,D2_PEDIDO " + ENTER
	cQuery += "	,D2_ITEMPV " + ENTER
	cQuery += "	,D2_QUANT - D2_XRECLIB AS D2_QUANT" + ENTER
	cQuery += "	,D2_COD " + ENTER
	cQuery += "	,D2_ITEM " + ENTER
	cQuery += "FROM "+ RetSqlName("SD2") + " SD2 WITH(NOLOCK) " + ENTER
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5_MG WITH(NOLOCK) " + ENTER
	cQuery += "	ON SC5_MG.D_E_L_E_T_ 	= '' " + ENTER
	cQuery += "	AND SC5_MG.C5_FILIAL		= D2_FILIAL " + ENTER
	cQuery += "	AND SC5_MG.C5_NUM 		= D2_PEDIDO " + ENTER
	cQuery += "	AND SC5_MG.C5_CLIENTE 	= D2_CLIENTE " + ENTER
	cQuery += "	AND SC5_MG.C5_LOJACLI 	= D2_LOJA " + ENTER
	cQuery += "WHERE " + ENTER
	cQuery += "	SD2.D_E_L_E_T_	= '' " + ENTER
	cQuery += "	AND D2_FILIAL		= '" + _cFilMestre + "' " + ENTER
	cQuery += "	AND D2_DOC 		= '" + __cNfEntrada + "' " + ENTER
	cQuery += "	AND D2_SERIE 		= '" + __cSerieEntrada + "' " + ENTER
	cQuery += "	AND D2_CLIENTE 	= '" + __cSF2Fornece + "' " + ENTER
	cQuery += "	AND D2_LOJA 		= '" + __cSF2LjFornc + "' " + ENTER
	cQuery += "	AND D2_TIPO 		= 'N' " + ENTER
	cQuery += "	AND D2_XRECEBE		!= 'T' " + ENTER
	
	MemoWrite("GQREENTR_PEDIDOS_A_LIBERAR_INTERCOMPANY.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPNFT", .F., .T.)
	
	SC6->(DbSetOrder(1))
	SC5->(DbSetOrder(1))
	SD2->(DbSetOrder(3))
	TMPNFT->(DbGotop())
	While !TMPNFT->(Eof())
		SC5->(dbSeek(xFilial("SC5")+TMPNFT->C5_NUM)) 
		If !SC5->(Eof())
			cNumChave := TMPNFT->C5_NUM 
			lPedLiberado := .T.
			While TMPNFT->C5_NUM = cNumChave .and. !TMPNFT->(Eof())
				nTotPrevisto += TMPNFT->D2_QUANT
				nPedPrevisto += TMPNFT->D2_QUANT
				If SC6->(DbSeek(xFilial("SC6") + TMPNFT->C5_NUM + TMPNFT->D2_ITEMPV + TMPNFT->D2_COD  )) .AND. TMPNFT->D2_QUANT > 0
					/*			Executar a função padrão PROTHEUS de liberação de pedido	MaLibDoFat	*/
					nQtdLib := MaLibDoFat(SC6->(RecNo()),TMPNFT->D2_QUANT,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
	
					If nQtdLib = 0
						lPedLiberado := .F.
					Else
						If SD2->(DbSeek( _cFilMestre + __cNfEntrada + __cSerieEntrada + __cSF2Fornece + __cSF2LjFornc + TMPNFT->D2_COD + TMPNFT->D2_ITEM ))
							SD2->(RecLock("SD2", .F.))
							SD2->D2_XRECEBE := IIF( TMPNFT->D2_QUANT = nQtdLib ,'T',IIF(TMPNFT->D2_QUANT > nQtdLib ,'P',SD2->D2_XRECEBE) )
							SD2->D2_XRECLIB := SD2->D2_XRECLIB + nQtdLib 
							SD2->(MsUnLock())
						EndIf
					EndIf
					nTotLiberado += nQtdLib 
					nPedLiberado += nQtdLib
				EndIf
				TMPNFT->(DbSkip())			     
			End
			MaLiberOk({ SC5->C5_NUM },.F.)
	
			/*			Reforçar a atualização do credito na SC9 			*/
			cQuery := "UPDATE " + RetSqlName("SC9") + " SET " + ENTER
			cQuery += "	C9_BLCRED='' " + ENTER
			cQuery += "	,C9_NUMOF= '" + cChvCrossDock + "' " + ENTER
			cQuery += "FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) " + ENTER
			cQuery += "WHERE SC9.D_E_L_E_T_ = '' "   + ENTER
			cQuery += "	AND C9_FILIAL		= '"+xFilial("SC9")+"' " + ENTER
			cQuery += "	AND C9_NFISCAL 	= '' " + ENTER
			cQuery += "	AND C9_PEDIDO 		= '" + SC5->C5_NUM + "' " + ENTER
			cQuery += "	AND C9_NUMOF		= ''"
			MemoWrite("GQREENTR_Atualiza_Credito_SC9.sql",cQuery)
			TCSQLExec(cQuery)
	
			If lPedLiberado
				SC5->(RecLock("SC5", .F.))
				If nPedLiberado = nPedPrevisto
					SC5->C5_XSTACON := 'C'
				ElseIf nPedPrevisto > nPedLiberado 
					SC5->C5_XSTACON := 'I'
				EndIf
				SC5->C5_YSTSEP := 'G'
				SC5->(MsUnLock())
	
				SF1->(RecLock("SF1", .F.))
				SF1->F1_XRECEBE := 'E'
				SF1->(MsUnLock())
			EndIf
		Else
			nTotPrevisto += TMPNFT->D2_QUANT
			TMPNFT->(DbSkip())
		EndIf
	End
	/*
	Atualiza status da nota fiscal de INTERCOMPANY - SF1
	*/
	If nTotPrevisto = nTotLiberado .AND. nTotLiberado > 0 
		SF1->(RecLock("SF1", .F.))
		SF1->F1_XRECEBE := 'F'
		SF1->(MsUnLock())
		cRetorno	:= "Recebimento da carga realizada com sucesso!! " + ENTER + "Dê Prosseguimento com emissão de Nota Fiscal ao cliente."
	Else
		cRetorno	:= "Recebimento da carga não realizada!! " + ENTER + "Execute a rotina de recebimento ou verifique pedidos "
	EndIf
	TMPNFT->(DbCloseArea())
EndIf
RestArea(xSM0Alias)

Return (cRetorno)
