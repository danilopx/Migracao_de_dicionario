// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : V166VLD.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 25/08/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#INCLUDE "APVT100.CH"

#DEFINE ENTER CHR(13) + CHR(10)
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} V166VLD
Processa a tabela CB0-ID de etiquetas.

@author    pbindo
@version   11.3.2.201607211753
@since     25/08/2016
/*/
//------------------------------------------------------------------------------------------
user function V166VLD()

	Local lRet		:= .T.
	Local cNumSer	:= Space(Len(ZA4->ZA4_NSERIE))
	Local cMaxLote	:= 0
	Local cQuery	:= ""
	
	Private cEtiqProd := ParamIXB[1]
	Private nQuant 	:= ParamIXB[2]
	Private x		:= 0
	Private cTipo
	Private cProd   := CB8->CB8_PROD
	Private _cAlias := GetNextAlias()
	Private nQtObrig	:= 0
	Private lRegZa4Ok := .F.

	If CEMPANT="03" .AND. CFILANT="02" // A validação e armazentamento do serial do produto é para o CD de EXTREMA
		//FAZ A VALIDACAO PADRAO DA ETIQUETA, O PONTO DE ENTRADA E ANTES E NAO PODE SER LIDO O ID CASO ESTEJA ERRADO
		If !Vld166Produto(Nil,cEtiqProd,nQuant)
			lRet :=.F.
			Return(lRet)
		EndIf	

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+cProd)
		If  ALLTRIM(SB1->B1_ITEMCC) == "PROART"   //TRADE - NAO ABRE JANELA DE REG. SERIAL NUMBER PARA PROART 
			lRet :=.T.
			Return(lRet)
		EndIf	
	
		
		//CONTA QUANTIDADE QUE TEM SERIAL
		cQuery := " SELECT TOP(1) ZA4_PRCOM  FROM ZA4040 WITH(NOLOCK) " + ENTER
		cQuery += " WHERE D_E_L_E_T_ <> '*' " + ENTER
		cQuery += " AND ZA4_FILIAL = '02' " + ENTER
		cQuery += " AND ZA4_PRCOM = '" + cProd + "' " + ENTER
	
		MemoWrite("V166VLS_TEM_SERIAL.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
	
		Count To nQtObrig
	
		(_cAlias)->(dbCloseArea())	 	
	
		//VERIFICA SE E EAN13, OU 14 OU CAIXA
		dbSelectArea("SB1")

		cCodBarra:= "1" + Left(SB1->B1_CODBAR,12)
		cEAN14	:= cCodBarra + CBDigVer(cCodBarra)
		c2CodBarra:= "2" + Left(SB1->B1_CODBAR,12)	
		cEAN142	:= c2CodBarra + CBDigVer(c2CodBarra)	
	
	
		If AllTrim(cEtiqProd) == AllTrim(SB1->B1_CODBAR)
			cTipo := "EAN13"
			//COMO NAO IRA COLETAR DA CAIXA AVULSA EM UM PRIMEIRO MOMENTO, SAI DA ROTINA
			//lRet :=.T.
			//Return(lRet)
			cMens := "Leia o numero Serie"
			cMaxLote:= 1
		ElseIf 	AllTrim(cEtiqProd) == AllTrim(cEAN14)
			cMaxLote := Posicione("SB5",1,xFilial("SB5")+cProd,"B5_QE1")
			cTipo := "EAN14"
			nQuant := nQuant*6
			cMens := "Leia o numero Caixa"
		ElseIf 	AllTrim(cEtiqProd) == AllTrim(cEAN142)
			cMaxLote := Posicione("SB5",1,xFilial("SB5")+cProd,"B5_QE2")
			cTipo := "EAN142"
			nQuant := nQuant*cMaxLote //144
			cMens := "Leia o numero Lote"
		EndIf
		//QUANDO FOR QUANTIDADE ZERO SAI DA ROTINA
		If nQuant == 0
			lRet := .F.
			Return(lRet)
		EndIf
		If cMaxLote = 0
			CBALERT("Não há dados de embalagem. (Complemento do Produto)","Aviso",.T.,3000,2)				
			lRet := .F.
			Return(lRet)
		EndIf
		/* Log ACD */		
		TfLogACD(__CUSERID ,"I",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
	
	
		aTela := VtSave()
		While .T.
			VTCLear()
			@ 0,0 VTSAY cMens
			@ 1,0 VtGet cNumSer Pict "@!" Valid VldNumSer(cNumSer)
			VTRead
			If VtLastKey() == 27 .OR. (VtLastKey() == 13 .AND. Empty(cNumSer) .AND. nQtObrig>0)  
				If CBYesNo("Deseja sair sem ler os números de serie?","ATENCAO",.T.)
					/* Log ACD */		
					TfLogACD(__CUSERID ,"A",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
					lRet := .T.
					Exit
				Else
					lRet := .F.
					Exit
				EndIf
			ElseIf lRegZa4Ok
				lRet := .T.
				Exit
			EndIf		
			cNumSer	:= Space(TamSx3("ZA4_NSERIE")[1])
		End
		VtRestore(,,,,aTela)
		/* Log ACD */		
		TfLogACD(__CUSERID ,"F",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
		
	EndIf
	
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ VldNumSer³ Autor ³ Paulo Bindo           ³ Data ³ 25/08/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ATUALIZA A TABELA Z04-NUMERO DE SERIE                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cID    - Numero do ID da Etiqueta                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ array                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldNumSer(cNumSer)
	Local lRet2		:= .T.
	Local nQtdeDispo:= 0
	Local nQtdeLida	:= 0
	Local nQtdeTot	:= 0
	Local nRec		:= 0
	Local aDispo	:= {}
	Local cNumPed	:= ""
	Local cQuery	:= ""
	Local cPMensLido:= ""
	Local cCMensLido:= ""
	Local nQGrava	:= 0
	Local nQtdOriginal
	Local lJaLido := .F.
	Local kk
	
	//Pega Numero Pedido
	cNumPed := CB8->CB8_PEDIDO
	nQtdOriginal:= CB8->CB8_QTDORI

	If Len(AllTrim(cNumSer)) == 5 //ETIQUETA LOTE
		TfLogZA4(__CUSERID ,"LA",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ALLTRIM(cNumSer),"","")
	ElseIf Len(AllTrim(cNumSer)) == 6 //ETIQUETA CAIXA
		TfLogZA4(__CUSERID ,"CA",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"",ALLTRIM(cNumSer),"")
	ElseIf Len(AllTrim(cNumSer)) == 13 //ETIQUETA NUMERO SERIE
		TfLogZA4(__CUSERID ,"S",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","",ALLTRIM(cNumSer))
	ElseIf Len(AllTrim(cNumSer)) == 10 //ETIQUETA LOTE
		TfLogZA4(__CUSERID ,"LN",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ALLTRIM(cNumSer),"","")
	ElseIf Len(AllTrim(cNumSer)) == 8 //ETIQUETA CAIXA
		TfLogZA4(__CUSERID ,"CN",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"",ALLTRIM(cNumSer),"")
	EndIf

	//CONTA QUANTIDADE JA LIDA
	cQuery := " SELECT * FROM ZA4040 WITH(NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND ZA4_FILIAL = '02' "
	cQuery += " AND ZA4_PRCOM = '" + cProd + "' "
	cQuery += " AND ZA4_PEDIDO = '" + cNumPed + "' "
	cQuery += " AND ZA4_ORDSEP = '" + CB8->CB8_ORDSEP + "' "

	MemoWrite("V166VLS.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	Count To nQtdeLida

	(_cAlias)->(dbCloseArea())	 	

	If CB8->CB8_QTDORI <= nQtdeLida
		CBALERT("Todos os numeros de serie ja foram lidos","Aviso",.T.,3000,2)		
		lRet2 := .T. 
		Return(lRet2) 	
	EndIf

	nQtdLote := Posicione("SB5",1,xFilial("SB5")+cProd,"B5_QE2")
	nQtdCaixa := Posicione("SB5",1,xFilial("SB5")+cProd,"B5_QE1")

	//VALIDA A ETIQUETA DE NUMERO DE SERIE COM O EAN
	If (Len(AllTrim(cNumSer)) == 5 .OR. Len(AllTrim(cNumSer)) == 10).And. cTipo # "EAN142" .And. nQuant < nQtdLote//ETIQUETA LOTE
		CBALERT("Etiqueta invalida, voce Bipou em uma etiqueta de Pallet","Aviso",.T.,3000,2)
		lRet2 := .F. 
		Return(lRet2)		
	ElseIf (Len(AllTrim(cNumSer)) == 6 .OR. Len(AllTrim(cNumSer)) == 8) .And. cTipo # "EAN14" .And. nQuant < nQtdCaixa //ETIQUETA CAIXA
		CBALERT("Etiqueta invalida, voce Bipou em uma etiqueta de caixa","Aviso",.T.,3000,2)
		lRet2 := .F. 
		Return(lRet2)		
	ElseIf Len(AllTrim(cNumSer)) == 13 .And. cTipo # "EAN13"
		CBALERT("Etiqueta invalida, voce Bipou em etiqueta unitaria","Aviso",.T.,3000,2)		
		lRet2 := .F. 
		Return(lRet2)
	ElseIf nQtObrig>0 .AND. (EMPTY(cNumSer) .OR. (Len(AllTrim(cNumSer)) != 13 .AND. Len(AllTrim(cNumSer)) != 5 .AND. Len(AllTrim(cNumSer)) != 10 .AND. Len(AllTrim(cNumSer)) != 6 .AND. Len(AllTrim(cNumSer)) != 8))   
		CBALERT("Etiqueta Obrigatoria, informe um codigo valido","Aviso",.T.,3000,2)		
		lRet2 := .F. 
		Return(lRet2)		
	ElseIf EMPTY(cNumSer)
		lRet2 := .T. 
		Return(lRet2)	
	EndIf



	//SELECIOAN TODOS OS NUMEROS DE SERIE
	cQuery := " SELECT * FROM ZA4040 WITH(NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND ZA4_FILIAL = '02' "
	cQuery += " AND RTRIM(LTRIM(ZA4_PRCOM)) = '" + ALLTRIM(cProd) + "' "
	If Len(AllTrim(cNumSer)) == 5 //ETIQUETA LOTE
		cQuery += " AND RTRIM(ZA4_NLOTE)  = '" + ALLTRIM(cNumSer) + "'"
	ElseIf Len(AllTrim(cNumSer)) == 6 //ETIQUETA CAIXA
		cQuery += " AND RTRIM(ZA4_NCAIXA) = '" + ALLTRIM(cNumSer) + "'"
	ElseIf Len(AllTrim(cNumSer)) == 13 //ETIQUETA NUMERO SERIE
		cQuery += " AND RTRIM(ZA4_SERIAL) = '" + ALLTRIM(cNumSer) + "'"
	ElseIf Len(AllTrim(cNumSer)) == 10 //ETIQUETA LOTE
		cQuery += " AND RTRIM(ZA4_LOTECT)  = '" + ALLTRIM(cNumSer) + "'"
	ElseIf Len(AllTrim(cNumSer)) == 8 //ETIQUETA CAIXA
		cQuery += " AND RTRIM(ZA4_CAIXA6) = '" + ALLTRIM(cNumSer) + "'"
	EndIf
	cQuery +=  "ORDER BY ZA4_DTIMP  DESC"

	MemoWrite("V166VLSA.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)
	
	//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
	//CONOUT(cNumSer)
	//CONOUT(cProd)
	
	Count To nRec

	If nRec == 0
		lRet2 := .F.
		(_cAlias)->(dbCloseArea())
		If Len(AllTrim(cNumSer)) == 5 //ETIQUETA LOTE
			CBALERT("LOTE invalido","Aviso",.T.,3000,2)
		ElseIf Len(AllTrim(cNumSer)) == 6 //ETIQUETA CAIXA
			CBALERT("CAIXA invalidA","Aviso",.T.,3000,2)
		ElseIf Len(AllTrim(cNumSer)) == 13 //ETIQUETA NUMERO SERIE
			CBALERT("Numero de serie invalido","Aviso",.T.,3000,2)
		ElseIf Len(AllTrim(cNumSer)) == 10 //ETIQUETA LOTE
			CBALERT("LOTE invalido","Aviso",.T.,3000,2)
		ElseIf Len(AllTrim(cNumSer)) == 8 //ETIQUETA CAIXA
			CBALERT("CAIXA invalidA","Aviso",.T.,3000,2)
		ELSE
			CBALERT("ID invalido","Aviso",.T.,3000,2)
		EndIf
		Return(lRet2)
	EndIf

	//CONTA QUANTIDADES LIDAS E NAO LIDAS
	dbSelectArea(_cAlias)
	dbGoTop()
	lJaLido := .F.

	While !Eof()
		//QUANDO FOR NUMERO DE SERIE, VERIFICA SE JA FOI LIDO
		If !Empty((_cAlias)->ZA4_PEDIDO) .And. Len(AllTrim(cNumSer)) == 13
			If (_cAlias)->ZA4_PEDIDO == cNumPed
				CBALERT("Numero de serie ja lido neste pedido","Aviso",.T.,3000,2)
				lRet2 := .F.
				(_cAlias)->(dbCloseArea())
				Return(lRet2)
			Else
				CBALERT("Numero de serie lido em outro pedido "+(_cAlias)->ZA4_PEDIDO,"Aviso",.T.,3000,2)
				lJaLido := .T.
			EndIf
		EndIf

		//QUANDO FOR PALLET NAO PODE TER TIDO LEITURA NO LOTE
		If !Empty((_cAlias)->ZA4_PEDIDO) .And. (Len(AllTrim(cNumSer)) == 5 .OR. Len(AllTrim(cNumSer)) == 10 ) 
			If (_cAlias)->ZA4_PEDIDO # cNumPed			
				If !(_cAlias)->ZA4_PEDIDO $ cPMensLido
					//cPMensLido += (_cAlias)->ZA4_PEDIDO + ENTER
					lJaLido := .T.					
				EndIf
			Else
				CBALERT("Este pallet ja foi lido para este pedido","Aviso",.T.,3000,2)				
				lRet2 := .F.
				(_cAlias)->(dbCloseArea())
				Return(lRet2)
			EndIf
		EndIf


		//QUANDO FOR CAIXA NAO PODE TER TIDO LEITURA
		If !Empty((_cAlias)->ZA4_PEDIDO) .And. (Len(AllTrim(cNumSer)) == 6 .OR. Len(AllTrim(cNumSer)) == 8)
			If (_cAlias)->ZA4_PEDIDO # cNumPed			
				If !(_cAlias)->ZA4_PEDIDO $ cCMensLido
					//cCMensLido += (_cAlias)->ZA4_PEDIDO +ENTER
					lJaLido := .T.					
				EndIf
			Else
				CBALERT("Esta caixa ja foi lida para este pedido","Aviso",.T.,3000,2)				
				lRet2 := .F.
				(_cAlias)->(dbCloseArea())
				Return(lRet2)
			EndIf	
		EndIf

		//CONTA A QUANTIDADE DISPONIVEL
		If Empty((_cAlias)->ZA4_PEDIDO) .or. lJaLido
			nQtdeDispo ++
			//ADISPO 01-LOTE, 02-CAIXA, 03-NUM SERIE
			aAdd(aDispo,{(_cAlias)->ZA4_NLOTE,(_cAlias)->ZA4_NCAIXA,(_cAlias)->ZA4_NSERIE })
		Else
			nQtdeLida ++
		EndIf	
		lOtroPedido := .F.
		nQtdeTot ++
		dbSkip()
	End
	(_cAlias)->(dbCloseArea())

	//QUANDO FOR PALLET NAO PODE TER NUMERO DE SERIE LIDO
	If !Empty(cPMensLido)
		CBALERT("Lote ja lido no pedido "+cPMensLido,"Aviso",.T.,3000,2)				
		lRet2 := .F.			
		Return(lRet2)
	EndIf

	//QUANDO FOR CAIXA NAO PODE TER NUMERO DE SERIE LIDO
	If !Empty(cCMensLido)
		CBALERT("Caixa ja lida no pedido "+cCMensLido,"Aviso",.T.,3000,2)				
		lRet2 := .F.			
		Return(lRet2)
	EndIf

	//DEBUGAR AQUI, QUANDO PASSA 1 E DEPOIS A CAIXA NAO ESTA VALIDANDO
	If (Len(AllTrim(cNumSer)) == 5 .OR. Len(AllTrim(cNumSer)) == 10)//ETIQUETA LOTE
		//If nQuant < (nQtdeLida+nQtdLote)
		If nQuant + nQtdeLida > nQtdOriginal .OR. nQuant > nQtdLote
			CBALERT("A quantidade de um lote excede a necessaria","Aviso",.T.,3000,2)				
			lRet2 := .F.			
			Return(lRet2)
		EndIf
	ElseIf (Len(AllTrim(cNumSer)) == 6 .OR. Len(AllTrim(cNumSer)) == 8)//ETIQUETA CAIXA
		//If nQuant < (nQtdeLida+nQtdCaixa)
		If nQuant + nQtdeLida > nQtdOriginal .OR. nQuant > nQtdCaixa
			CBALERT("A quantidade de uma caixa excede a necessaria","Aviso",.T.,3000,2)				
			lRet2 := .F.			
			Return(lRet2)
		EndIf
	EndIf
	lUpdLote := .F.					
	If Len(AllTrim(cNumSer)) == 5 //ETIQUETA LOTE
	
		cQuery := "UPDATE ZA4 SET " 									
		cQuery += "	ZA4_PEDIDO = '" + cNumPed + "' "
		cQuery += "	,ZA4_ORDSEP	= '" + CB8->CB8_ORDSEP + "' "
		cQuery += "FROM ZA4040 ZA4 " 									
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += " AND ZA4_FILIAL = '02' "
		cQuery += " AND RTRIM(ZA4_PRCOM) = '" + ALLTRIM(cProd) + "' "
		cQuery += " AND RTRIM(ZA4_NLOTE)  = '" + ALLTRIM(cNumSer) + "' "
		cQuery += " AND ZA4.R_E_C_N_O_ "
		cQuery += " 	IN (SELECT TOP(" + STR(nQtdLote) + ") AUX.R_E_C_N_O_" 
		cQuery += " 		FROM ZA4040 AUX" 
		cQuery += " 		WHERE AUX.D_E_L_E_T_ <> '*'"
		cQuery += " 		AND AUX.ZA4_FILIAL = '02' "
		cQuery += " 		AND RTRIM(AUX.ZA4_PRCOM) = '" + ALLTRIM(cProd) + "'" 
		cQuery += " 	 	AND RTRIM(AUX.ZA4_NLOTE)  = '" + ALLTRIM(cNumSer) + "'" 
		cQuery += " 		ORDER BY AUX.ZA4_DTIMP  DESC"
		cQuery += " 		)" 

		MemoWrite("V166VLD_UPD_DA_OS_NO_LOTE.SQL",cQuery)
	
		lRegZa4Ok := .T.

		IF TCSQLEXEC(cQuery) != 0 
			TfLogACD(__CUSERID ,"N",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
		ELSE
			TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,"")
			lUpdLote := .T.					
		ENDIF				

		TfLogZA4(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,cNumSer,"","")

	EndIf
	If Len(AllTrim(cNumSer)) == 10 //ETIQUETA LOTE
	
		cQuery := "UPDATE ZA4 SET " 									
		cQuery += "	ZA4_PEDIDO = '" + cNumPed + "' "
		cQuery += "	,ZA4_ORDSEP	= '" + CB8->CB8_ORDSEP + "' "
		cQuery += "FROM ZA4040 ZA4 " 									
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += " AND ZA4_FILIAL = '02' "
		cQuery += " AND RTRIM(ZA4_PRCOM) = '" + ALLTRIM(cProd) + "' "
		cQuery += " AND RTRIM(ZA4_LOTECT)  = '" + ALLTRIM(cNumSer) + "' "

		MemoWrite("V166VLD_UPD_DA_OS_NO_LOTE.SQL",cQuery)
	
		lRegZa4Ok := .T.

		IF TCSQLEXEC(cQuery) != 0 
			TfLogACD(__CUSERID ,"N",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
		ELSE
			TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,"")
			lUpdLote := .T.					
		ENDIF				
		TfLogZA4(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,cNumSer,"","")

	EndIf
	If Len(AllTrim(cNumSer)) == 8 //ETIQUETA LOTE
	
		cQuery := "UPDATE ZA4 SET " 									
		cQuery += "	ZA4_PEDIDO = '" + cNumPed + "' "
		cQuery += "	,ZA4_ORDSEP	= '" + CB8->CB8_ORDSEP + "' "
		cQuery += "FROM ZA4040 ZA4 " 									
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += " AND ZA4_FILIAL = '02' "
		cQuery += " AND RTRIM(ZA4_PRCOM) = '" + ALLTRIM(cProd) + "' "
		cQuery += " AND RTRIM(ZA4_CAIXA6)  = '" + ALLTRIM(cNumSer) + "' "

		MemoWrite("V166VLD_UPD_DA_OS_NO_LOTE.SQL",cQuery)
	
		lRegZa4Ok := .T.

		IF TCSQLEXEC(cQuery) != 0 
			TfLogACD(__CUSERID ,"N",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","","")					
		ELSE
			TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,"")
			lUpdLote := .T.					
		ENDIF				
		TfLogZA4(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"",cNumSer,"")

	EndIf
	If .NOT. lUpdLote					
		
		nQGrava := Iif(Len(AllTrim(cNumSer)) == 5,nQtdLote,Iif(Len(AllTrim(cNumSer)) == 6,nQtdCaixa,1))
	
		//GRAVA O NUMERO DO PEDIDO NA TABELA DE NUMERO DE SERIE
		dbSelectArea("ZA4") 
		dbSetOrder(1) // ZA4_FILIAL, ZA4_COD, ZA4_NSERIE
		For kk:=1 To nQGrava
			dbSetOrder(1) // ZA4_FILIAL, ZA4_COD, ZA4_NSERIE
			If dbSeek(xFilial("ZA4") + cProd + aDispo[kk][3] )
				If Empty(ZA4_PEDIDO + ZA4_ORDSEP)
					TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,ZA4->ZA4_SERIAL)					
					RecLock("ZA4",.F.)
					ZA4_PEDIDO := cNumPed
					ZA4_ORDSEP	:= CB8->CB8_ORDSEP
					ZA4->(MsUnlock())
					lRegZa4Ok := .T.
				Else
					TfLogACD(__CUSERID ,"E",ZA4->ZA4_ORDSEP,ZA4->ZA4_PEDIDO,ZA4->ZA4_COD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,ZA4->ZA4_SERIAL)					
					TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,ZA4->ZA4_SERIAL)					
					RecLock("ZA4",.F.)
					ZA4_PEDIDO := cNumPed
					ZA4_ORDSEP	:= CB8->CB8_ORDSEP
					ZA4->(MsUnlock())
					lRegZa4Ok := .T.
				EndIf
			Else
				cQuery := "UPDATE ZA4 SET " 									
				cQuery += "	ZA4_PEDIDO = '" + cNumPed + "' "
				cQuery += "	,ZA4_ORDSEP	= '" + CB8->CB8_ORDSEP + "' "
				cQuery += "FROM ZA4040 ZA4 " 									
				cQuery += " WHERE D_E_L_E_T_ <> '*'"
				cQuery += " AND ZA4_FILIAL = '02' "
				cQuery += " AND RTRIM(ZA4_PRCOM) = '" + ALLTRIM(cProd) + "' "
				cQuery += " AND ZA4_NUMSER = '"+aDispo[kk][3]+"' "
	
				lRegZa4Ok := .T.
	
				IF TCSQLEXEC(cQuery) != 0 
					TfLogACD(__CUSERID ,"N",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","",aDispo[kk][3])					
					//CBALERT("Código " + aDispo[kk][3] + " na tabela (ZA4) de etiquetas não encontrado!","Aviso",.T.,3000,2)
				ELSE
					TfLogACD(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,ZA4->ZA4_NLOTE,ZA4->ZA4_NCAIXA,aDispo[kk][3])					
				ENDIF				
			EndIf
			TfLogZA4(__CUSERID ,"G",CB8->CB8_ORDSEP,CB8->CB8_PEDIDO,CB8->CB8_PROD,"","",aDispo[kk][3])
		Next
	EndIf
	//VALIDA AS QUANTIDADES NO FINAL
	//CONTA QUANTIDADE JA LIDA
	cQuery := " SELECT * FROM ZA4040 WITH(NOLOCK) "
	cQuery += " WHERE D_E_L_E_T_ <> '*'"
	cQuery += " AND ZA4_FILIAL = '02' "
	cQuery += " AND ZA4_PRCOM = '"+cProd+"' "
	cQuery += " AND ZA4_PEDIDO = '"+cNumPed+"' "
	cQuery += " AND ZA4_ORDSEP = '" + CB8->CB8_ORDSEP + "' "

	MemoWrite("V166VLS.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.T.)

	Count To nQtdeLida

	(_cAlias)->(dbCloseArea())	 	

	If 1=2 //nQtdeLida >= CB8->CB8_QTDORI 
		CBALERT("Todos os numeros de serie ja foram lidos","Aviso",.T.,3000,2)
		x := nQtdeLida		
		lRet2 := .T.
		lRegZa4Ok := .T.		 
		Return(lRet2) 	
	EndIf	

Return(lRet2)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³VldProduto³ Autor ³ ACD                   ³ Data ³ 27/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Validacao da etiqueta de produto com ou sem CB0            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Vld166Produto(cEtiCB0,cEtiProd,nQtde)
	Local cCodCB0
	Local cLote       := Space(TamSX3("B8_LOTECTL")[1])
	Local cSLote      := Space(TamSX3("B8_NUMLOTE")[1])
	Local cNumSer	  := Space(TamSX3("BF_NUMSERI")[1])
	//Local cV166VLD    := If(UsaCB0("01"),Space(TamSx3("CB0_CODET2")[1]),Space(48))
	Local nP          := 0
	Local nQtdTot     := 0
	Local cEtiqueta
	Local aEtiqueta   := {}
	Local aItensPallet:= {}
	Local lIsPallet   := .T.
	Local cMsg        := ""
	Local nSaldo      := 0
	Local nSaldoLote  := 0
	Local aAux        := {}
	Local lErrQTD     := .F.
	Local lACD166BEmp := .T.
	Local cMVEstNeg   := SuperGetMV("MV_ESTNEG")
	Static __PulaItem := .F.
	DEFAULT cEtiCB0   := Space(TamSx3("CB0_CODET2")[1])
	DEFAULT cEtiProd  := Space(48)
	DEFAULT nQtde     := 1

	If __PulaItem
		Return .t.
	EndIf

	If Empty(cEtiCB0+cEtiProd)
		Return .f.
	EndIf                   

	If UsaCB0("01")
		aItensPallet := CBItPallet(cEtiCB0)
	Else 
		aItensPallet := CBItPallet(cEtiProd)
	EndIf	
	If Len(aItensPallet) == 0
		If UsaCB0("01")
			aItensPallet:={cEtiCB0}
		Else
			aItensPallet:={cEtiProd}
		EndIf
		lIsPallet := .f.
	EndIf

	//validacao
	Begin Sequence
		For nP:= 1 to Len(aItensPallet)
			cEtiqueta:= aItensPallet[nP]

			If UsaCB0("01")
				aEtiqueta := CBRetEti(cEtiqueta,"01")
				If Empty(aEtiqueta)
					cMsg := "Etiqueta invalida"
					Break
				EndIf
				cLote  := aEtiqueta[16]
				cSLote := aEtiqueta[17]
				cNumSer:= aEtiqueta[23]
				cCodCB0:= CB0->CB0_CODETI
				If ! lIsPallet
					If ! Empty(CB0->CB0_PALLET)
						cMsg := "Etiqueta invalida, Produto pertence a um Pallet"
						Break
					EndIf
				EndIf
				If !Empty(CB0->CB0_STATUS)
					cMsg := "Etiqueta invalida, ja consumida por outro processo."
					Break
				EndIf
				If CB8->CB8_LOCAL <> aEtiqueta[10] 
					cMsg := "Armazem associado a esta etiqueta esta diferente do item da separacao"
					Break
				EndIf
				If CB8->(CB8_LOCAL+CB8_LCALIZ) <> aEtiqueta[10]+aEtiqueta[9] .and. ! Empty(CB8->CB8_LCALIZ)
					cMsg := "Endereco associado a esta etiqueta esta diferente"
					Break
				EndIf
				If Ascan(aAux,{|x| x[4] == CB0->CB0_CODETI}) > 0
					cMsg := "Etiqueta ja lida"
					Break
				EndIf
				If A166VldCB9(aEtiqueta[1], CB0->CB0_CODETI)
					cMsg := "Etiqueta ja lida"
					Break
				EndIf
			Else
				cCodCB0  := Space(10)
				If !CBLoad128(@cEtiqueta)
					cMsg:=""
					Break
				EndIf
				If ! CbRetTipo(cEtiqueta) $ "EAN8OU13-EAN14-EAN128"
					cMsg := "Etiqueta invalida"
					Break
				EndIf
				aEtiqueta := CBRetEtiEan(cEtiqueta)
				If len(aEtiqueta) == 0
					cMsg := "Etiqueta invalida"
					Break
				EndIf
				cLote  := aEtiqueta[3]
			EndIf
			If CB8->CB8_PROD <> aEtiqueta[1]
				cMsg := "Produto diferente"
				Break
			EndIf
			If ! CBProdLib(CB8->CB8_LOCAL,aEtiqueta[1])
				cMsg:=""
				Break
			EndIf
			If nSaldoCB8 < (aEtiqueta[2]*nQtde)
				cMsg := "Quantidade maior que necessario"
				lErrQTD := .t.
				Break
			EndIf
			If !CBRastro(CB8->CB8_PROD,@cLote,@cSLote)
				cMsg:=""
				Break
			EndIf
			If CB7->CB7_ORIGEM == "1" // por pedido

				// Somente faz checagens de rastreabilidade se produto possuir tal controle
				If Rastro(CB8->CB8_PROD)
					If CB8->CB8_CFLOTE == "1"  // se confronta o lote da ordem de separacao com o lote lido
						If CB8->(CB8_LOTECT+CB8_NUMLOT) <> cLote+cSLote
							cMsg := "Lote invalido"
							Break
						EndIf
					Else
						If ! CB8->(CBExistLot(CB8_PROD,CB8_LOCAL,CB8_LCALIZ,cLote,cSLote))
							cMsg := "Lote nao existe"
							Break
						EndIf
						If cLote+cSLote != CB8->(CB8_LOTECT+CB8_NUMLOT)
							nSaldoLote := SaldoLote(CB8->CB8_PROD,CB8->CB8_LOCAL,cLote,cSLote,,,,dDataBase,,)
							If nSaldoLote < nQtde .Or. ! CB8->(A166GetSld(CB8_ORDSEP,CB8_PROD,CB8_LOCAL,CB8_LCALIZ,cLote,cSLote,cNumSer))
								cMsg := "Lote com saldo insuficiente"
								Break
							EndIf
						EndIf
						// Nao permite informar lote pertencente a outro endereco
						If Localiza(CB8->CB8_PROD)
							If !CB8->(A166EndLot(CB8_PROD,cLote,cSlote,cNumSer,CB8_LOCAL,CB8_LCALIZ))
								cMsg := "Lote digitado pertence a outro endereco"
								Break
							EndIf
						EndIf
					EndIf
				EndIf
			Else // por NF ou OP
				If  CB8->(CB8_LOTECT+CB8_NUMLOT) <> cLote+cSLote
					cMsg := "Lote invalido"
					Break
				EndIf
			EndIf
			If !UsaCB0("01")
				If CbRetTipo(cEtiqueta)=="EAN128"
					cNumSer := aEtiqueta[5]
				Else
					If ! Empty(CB8->CB8_NUMSER) .AND. ! CBNumSer(@cNumSer,CB8->CB8_NUMSER,aEtiqueta,.F.)
						Break
					EndIf
					If Empty(cNumSer)
						cNumSer := CB8->CB8_NUMSER
					EndIf      
					If !Empty(CB8->CB8_NUMSER)
						// Valida se o numero de serie pertece ao lote informado pelo operador
						SBF->(dbSetOrder(4))
						If SBF->(dbSeek(xFilial("SBF")+(CB8->CB8_PROD+cNumSer)))
							If cLote+cSlote # SBF->(BF_LOTECTL+BF_NUMLOTE)
								cMsg := "O número de série não pertence ao lote informado"
								Break
							EndIf
						Else
							cMsg := "O número de série não foi localizado na tabela de saldos"
							Break
						EndIf
					EndIf	  
				EndIf
			EndIf
			If CB7->CB7_ORIGEM # "2" .and. cMVEstNeg =="N"
				If Localiza(CB8->CB8_PROD)
					nSaldo := SaldoSBF(CB8->CB8_LOCAL,cEndereco,CB8->CB8_PROD,cNumSer,cLote,cSLote,lACD166BEmp)
				Else
					SB2->(DbSetOrder(1))
					SB2->(MsSeek(xFilial("SB2")+CB8->CB8_PROD+CB8->CB8_LOCAL))
					nSaldo := SaldoSB2()
				EndIf
				If aEtiqueta[2]*nQtde > nSaldo+CB8->CB8_SALDOS
					cMsg := "Saldo em estoque insuficiente"
					lErrQTD := .t.
					Break
				EndIf
			EndIf
			aAdd(aAux,{aEtiqueta[2]*nQtde,cLote,cSLote,cNumSer,cCodCB0})
			nQtdTot+=aEtiqueta[2]*nQtde
		Next nP
		If nQtdTot > nSaldoCB8
			cMsg := "Pallet excede a quantidade a separar"
			lErrQTD := .t.
			Break
		EndIf
		For nP:= 1 to Len(aAux)
			//CB8->(GravaCB8(aAux[nP,1],CB8_LOCAL,CB8_LCALIZ,CB8_PROD,CB8_LOTECT,CB8_NUMLOT,aAux[nP,2],aAux[nP,3],CB8_NUMSER,aAux[nP,5],aAux[nP,4]))
		Next nP
		aAux := {}

		Recover
		If ! Empty(cMsg)
			VtAlert(cMsg,"Aviso",.t.,4000,4) //
		EndIf
		VtClearGet("cEtiProd")
		VtGetSetFocus("cEtiProd")
		If !UsaCB0("01") .and. lForcaQtd .and. lErrQTD
			VtGetSetFocus("nQtde")
		EndIf
		Return .f.
	End Sequence

Return .t.
/*
Registro em tabela LOG as operações realizadas pelo operador 
*/
Static Function TfLogACD(cIDoperador,cStatus,cCB8ORDSEP,cCB8PEDIDO,cCB8PROD,cZA4NLOTE,cZA4NCAIXA,cZA4SERIAL)
/*
 Opções de STATUS
 	I - Inicio do processo de registro do serial
 	F - Termino do processo de registro do serial
 	A - Operação abortada pelo operador
 	G - Grava serial lido
 	E - O serial já está lido em outro pedido/OS
 	N - O serial não foi encontrado
 	J - Já fez a leitura do lote ou da caixa 
*/
		If !TCCanOpen("TB_LOG_ACDSERIAL")

			_cQuery := "CREATE TABLE TB_LOG_ACDSERIAL ( "
			_cQuery += "ID_OPERADOR VARCHAR(06), "
			_cQuery += "DT_LOG VARCHAR(10), "
			_cQuery += "TM_LOG VARCHAR(05), "
			_cQuery += "STATUS VARCHAR(01), "
			_cQuery += "CB8_ORDSEP VARCHAR(06), "
			_cQuery += "CB8_PEDIDO VARCHAR(06), "
			_cQuery += "CB8_PROD VARCHAR(15), "
			_cQuery += "ZA4_NLOTE VARCHAR(05), "
			_cQuery += "ZA4_NCAIXA VARCHAR(06),  "
			_cQuery += "ZA4_SERIAL VARCHAR(20)  "
			_cQuery += ")  "

			TCSQLExec(_cQuery)

		EndIf

		_cQuery := "INSERT INTO TB_LOG_ACDSERIAL ( ID_OPERADOR,DT_LOG,TM_LOG,STATUS,CB8_ORDSEP,CB8_PEDIDO,CB8_PROD,ZA4_NLOTE,ZA4_NCAIXA,ZA4_SERIAL) "
		_cQuery += "VALUES ( "
		_cQuery += "'" + cIDoperador + "',"
		_cQuery += "'" + dtos(date()) + "',"
		_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
		_cQuery += "'" + cStatus + "',"
		_cQuery += "'" + cCB8ORDSEP + "',"
		_cQuery += "'" + cCB8PEDIDO + "',"
		_cQuery += "'" + cCB8PROD + "',"
		_cQuery += "'" + cZA4NLOTE + "',"
		_cQuery += "'" + cZA4NCAIXA + "',"
		_cQuery += "'" + cZA4SERIAL + "' "
		_cQuery += ") "

		TCSQLExec(_cQuery)



Return .T. 

/*
Registro em tabela LOG as operações realizadas pelo operador 
*/
Static Function TfLogZA4(cIDoperador,cStatus,cCB8ORDSEP,cCB8PEDIDO,cCB8PROD,cZA4NLOTE,cZA4NCAIXA,cZA4SERIAL)

IF cStatus="S"
	ZA4->(dbSetOrder(1)) // ZA4_FILIAL, ZA4_COD, ZA4_NSERIE
	If ZA4->(dbSeek(xFilial("ZA4") + cCB8PROD + cZA4SERIAL ))
		cZA4NLOTE := IIF( EMPTY(ZA4->ZA4_LOTECT),ZA4->ZA4_NLOTE,ZA4->ZA4_LOTECT)
		cZA4NCAIXA:= IIF( EMPTY(ZA4->ZA4_CAIXA6),ZA4->ZA4_NCAIXA,ZA4->ZA4_CAIXA6) 
	ENDIF
	_cQuery := "INSERT INTO TBL_ZA4030 ( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) "
	_cQuery += "VALUES ( "
	_cQuery += "'02',"
	_cQuery += "'" + dtos(date()) + "',"
	_cQuery += "'" + cIDoperador + "',"
	_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
	_cQuery += "'" + cZA4SERIAL + "', "
	_cQuery += "'" + cCB8PEDIDO + "',"
	_cQuery += "'" + cCB8ORDSEP + "',"
	_cQuery += "'" + cCB8PROD + "',"
	_cQuery += "'" + cZA4NCAIXA + "',"
	_cQuery += "'" + cZA4NLOTE + "' "
	_cQuery += ") "
	
	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)
ENDIF
IF cStatus="CN"
	_cQuery := "INSERT INTO TBL_ZA4030 ( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) "
	_cQuery += "VALUES ( "
	_cQuery += "'02',"
	_cQuery += "'" + dtos(date()) + "',"
	_cQuery += "'" + cIDoperador + "',"
	_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
	_cQuery += "'" + cZA4SERIAL + "', "
	_cQuery += "'" + cCB8PEDIDO + "',"
	_cQuery += "'" + cCB8ORDSEP + "',"
	_cQuery += "'" + cCB8PROD + "',"
	_cQuery += "'" + cZA4NCAIXA + "',"
	_cQuery += "'" + cZA4NLOTE + "' "
	_cQuery += ") "
	
	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

	_cQuery := "INSERT INTO TBL_ZA4030 " + ENTER
	_cQuery += "( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) " + ENTER
	_cQuery += "SELECT" + ENTER
	_cQuery += "	'02' AS ZA4_FILIAL" + ENTER
	_cQuery += "	,'" + dtos(date()) + "' AS ZA4_DTLOG" + ENTER
	_cQuery += "	,'" + cIDoperador + "' AS ZA4_PRTUSE" + ENTER
	_cQuery += "	,'" + SubStr(Time(), 01, 05) + "' AS ZA4_PRTHOR" + ENTER
	_cQuery += "	,ZA4_NUMSER " + ENTER
	_cQuery += "	,'" + cCB8PEDIDO + "' AS ZA4_PEDIDO" + ENTER
	_cQuery += "	,'" + cCB8ORDSEP + "' AS ZA4_ORDSEP" + ENTER
	_cQuery += "	,ZA4_PRCOM" + ENTER
	_cQuery += "	,ZA4_CAIXA6" + ENTER
	_cQuery += "	,ZA4_LOTECT" + ENTER
	_cQuery += "FROM ZA4040 ZA4 WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE ZA4_CAIXA6='" + cZA4NCAIXA + "'" + ENTER
	_cQuery += "AND ZA4_FILIAL='02'" + ENTER
	_cQuery += "AND ZA4_PRCOM='" + cCB8PROD + "'" + ENTER

	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

ENDIF

IF cStatus="LN"
	_cQuery := "INSERT INTO TBL_ZA4030 ( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) "
	_cQuery += "VALUES ( "
	_cQuery += "'02',"
	_cQuery += "'" + dtos(date()) + "',"
	_cQuery += "'" + cIDoperador + "',"
	_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
	_cQuery += "'" + cZA4SERIAL + "', "
	_cQuery += "'" + cCB8PEDIDO + "',"
	_cQuery += "'" + cCB8ORDSEP + "',"
	_cQuery += "'" + cCB8PROD + "',"
	_cQuery += "'" + cZA4NCAIXA + "',"
	_cQuery += "'" + cZA4NLOTE + "' "
	_cQuery += ") "
	
	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

	_cQuery := "INSERT INTO TBL_ZA4030 " + ENTER
	_cQuery += "( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) " + ENTER
	_cQuery += "SELECT" + ENTER
	_cQuery += "	'02' AS ZA4_FILIAL" + ENTER
	_cQuery += "	,'" + dtos(date()) + "' AS ZA4_DTLOG" + ENTER
	_cQuery += "	,'" + cIDoperador + "' AS ZA4_PRTUSE" + ENTER
	_cQuery += "	,'" + SubStr(Time(), 01, 05) + "' AS ZA4_PRTHOR" + ENTER
	_cQuery += "	,ZA4_NUMSER " + ENTER
	_cQuery += "	,'" + cCB8PEDIDO + "' AS ZA4_PEDIDO" + ENTER
	_cQuery += "	,'" + cCB8ORDSEP + "' AS ZA4_ORDSEP" + ENTER
	_cQuery += "	,ZA4_PRCOM" + ENTER
	_cQuery += "	,ZA4_CAIXA6" + ENTER
	_cQuery += "	,ZA4_LOTECT" + ENTER
	_cQuery += "FROM ZA4040 ZA4 WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE ZA4_LOTECT='" + cZA4NLOTE + "'" + ENTER
	_cQuery += "AND ZA4_FILIAL='02'" + ENTER
	_cQuery += "AND ZA4_PRCOM='" + cCB8PROD + "'" + ENTER

	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

ENDIF

IF cStatus="LA"
	_cQuery := "INSERT INTO TBL_ZA4030 ( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) "
	_cQuery += "VALUES ( "
	_cQuery += "'02',"
	_cQuery += "'" + dtos(date()) + "',"
	_cQuery += "'" + cIDoperador + "',"
	_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
	_cQuery += "'" + cZA4SERIAL + "', "
	_cQuery += "'" + cCB8PEDIDO + "',"
	_cQuery += "'" + cCB8ORDSEP + "',"
	_cQuery += "'" + cCB8PROD + "',"
	_cQuery += "'" + cZA4NCAIXA + "',"
	_cQuery += "'" + cZA4NLOTE + "' "
	_cQuery += ") "
	
	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

	_cQuery := "INSERT INTO TBL_ZA4030 " + ENTER
	_cQuery += "( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) " + ENTER
	_cQuery += "SELECT" + ENTER
	_cQuery += "	'02' AS ZA4_FILIAL" + ENTER
	_cQuery += "	,'" + dtos(date()) + "' AS ZA4_DTLOG" + ENTER
	_cQuery += "	,'" + cIDoperador + "' AS ZA4_PRTUSE" + ENTER
	_cQuery += "	,'" + SubStr(Time(), 01, 05) + "' AS ZA4_PRTHOR" + ENTER
	_cQuery += "	,ZA4_NUMSER " + ENTER
	_cQuery += "	,'" + cCB8PEDIDO + "' AS ZA4_PEDIDO" + ENTER
	_cQuery += "	,'" + cCB8ORDSEP + "' AS ZA4_ORDSEP" + ENTER
	_cQuery += "	,ZA4_PRCOM" + ENTER
	_cQuery += "	,ZA4_CAIXA6" + ENTER
	_cQuery += "	,ZA4_LOTECT" + ENTER
	_cQuery += "FROM ZA4040 ZA4 WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE ZA4_NLOTE='" + cZA4NLOTE + "'" + ENTER
	_cQuery += "AND ZA4_FILIAL='02'" + ENTER
	_cQuery += "AND ZA4_PRCOM='" + cCB8PROD + "'" + ENTER

	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

ENDIF
IF cStatus="CA"
	_cQuery := "INSERT INTO TBL_ZA4030 ( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) "
	_cQuery += "VALUES ( "
	_cQuery += "'02',"
	_cQuery += "'" + dtos(date()) + "',"
	_cQuery += "'" + cIDoperador + "',"
	_cQuery += "'" + SubStr(Time(), 01, 05) + "',"
	_cQuery += "'" + cZA4SERIAL + "', "
	_cQuery += "'" + cCB8PEDIDO + "',"
	_cQuery += "'" + cCB8ORDSEP + "',"
	_cQuery += "'" + cCB8PROD + "',"
	_cQuery += "'" + cZA4NCAIXA + "',"
	_cQuery += "'" + cZA4NLOTE + "' "
	_cQuery += ") "
	
	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

	_cQuery := "INSERT INTO TBL_ZA4030 " + ENTER
	_cQuery += "( ZA4_FILIAL,ZA4_DTLOG,ZA4_PRTUSE,ZA4_PRTHOR,ZA4_NUMSER,ZA4_PEDIDO,ZA4_ORDSEP,ZA4_PRCOM,ZA4_CAIXA6,ZA4_LOTECT) " + ENTER
	_cQuery += "SELECT" + ENTER
	_cQuery += "	'02' AS ZA4_FILIAL" + ENTER
	_cQuery += "	,'" + dtos(date()) + "' AS ZA4_DTLOG" + ENTER
	_cQuery += "	,'" + cIDoperador + "' AS ZA4_PRTUSE" + ENTER
	_cQuery += "	,'" + SubStr(Time(), 01, 05) + "' AS ZA4_PRTHOR" + ENTER
	_cQuery += "	,ZA4_NUMSER " + ENTER
	_cQuery += "	,'" + cCB8PEDIDO + "' AS ZA4_PEDIDO" + ENTER
	_cQuery += "	,'" + cCB8ORDSEP + "' AS ZA4_ORDSEP" + ENTER
	_cQuery += "	,ZA4_PRCOM" + ENTER
	_cQuery += "	,ZA4_CAIXA6" + ENTER
	_cQuery += "	,ZA4_LOTECT" + ENTER
	_cQuery += "FROM ZA4040 ZA4 WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE ZA4_NCAIXA='" + cZA4NCAIXA + "'" + ENTER
	_cQuery += "AND ZA4_FILIAL='02'" + ENTER
	_cQuery += "AND ZA4_PRCOM='" + cCB8PROD + "'" + ENTER

	MemoWrite("TfLogZA4.SQL",_cQuery)

	TCSQLExec(_cQuery)

ENDIF

Return .T. 