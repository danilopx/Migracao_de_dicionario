#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'DIRECTRY.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT100TOK.prw
=================================================================================
||   Funcao: 	MT100TOK
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Este P.E. é chamado na função A103Tudok(). Pode ser usado para validar 
|| 	a inclusao da NF.
|| 		Esse Ponto de Entrada é chamado 2 vezes dentro da rotina A103Tudok(). 
|| 	Para o controle do número de vezes em que ele é chamado foi criada a variável 
|| 	lógica lMT100TOK, que quando for definida como (.F.) o ponto de entrada será 
||	chamado somente uma vez.
||
=================================================================================
=================================================================================
||   Autor:	Gilberto Ribeiro Jr
||   Data:	01/11/2011
=================================================================================
=================================================================================
*/

User Function MT100TOK()

Local aArea		:= GetArea()
Local aArCT1	:= CT1->(GetArea())
Local aArSA2	:= SA2->(GetArea())
Local aArSA1	:= SA1->(GetArea())
Local aArSF4	:= SF4->(GetArea())
Local aArSF2	:= SF2->(GetArea())

Local lExecuta 	:= ParamIxb[1]
Local cInter
Local cMeta
Local cPedido
Local cTes
Local cConta
Local cCodCliForn
Local cCodLoja
Local nLinhas	:= Len(aCols) //Quantidade de linhas para validar
Local i 		:= 0
Local cTFCcusto	:= ""
Local nCC_Nook 	:= 0

//Variaveis para trecho Advise
Local aImposto	:= IIF(Type("oFisRod:aArray") <> "U", oFisRod:aArray, {})
Local lIrrf		:= .F.

//----------------------------------------------------------------------------------------------------------------------------
// Variaveis: TOTVS
//----------------------------------------------------------------------------------------------------------------------------
Local _lRet 	:= .T.
Local nx1		:= 0
Local nx		:= 0
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)

/*
|---------------------------------------------------------------------------------
|	Validação de armazém de CQ
|---------------------------------------------------------------------------------
*/
Local cArmCQ 	:= GetMV("MV_CQ")
Local lArmCQ 	:= .F. 

Local cQuery 	:= ""
Local cNFOrig	:= ""
Local cSrOrig	:= ""
Local cItOrig	:= ""
Local cOp		:= ""
Local aProcRet	:= {}
Local nReg		:= 0
Local cMessage	:= ""
Local nQtdRet	:= 0 
Local ACONDPAG	:= {} // Matriz para receber a condição de pagamento do documento de entrada
Local nCtaPag	:= 0
Local lArm21Rt	:= .F.
Local lCrossDo	:= .F.
Local cChkTDev  := SuperGetMV("MT100TOK01",,"|0301|0302|") // Exemplo de conteudo: "|0301|0302|"

// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
//------------------------------[ Fim Variaveis: TOTVS ]-------------------------------------------------------------
//Verifica se a função chamadora é o MATA103, caso não seja, não executa nada
If FunName() <> "MATA103"
	RestArea(aArea)
	Return (lExecuta)
EndIf

If cTipo == "D"
    If !Empty( cChkTDev ) 
        If ( Alltrim(cEmpAnt) + Alltrim(cFilAnt) ) $ cChkTDev
            U_TFRTTDV()
        EndIf
    EndIf
EndIf

/*
|---------------------------------------------------------------------------------
|	Altero este parametro para rodar somente uma vez.
|---------------------------------------------------------------------------------
*/

If lMT100TOK
	lMT100TOK := .F.
EndIf

cCodCliForn 	:= CA100FOR 	//Código do Cliente ou Fornecedor
cCodLoja		:= CLOJA		//Código da Loja do Cliente ou Fornecedor

For i := 1 To nLinhas
	
	cInter  		:= aCols[i][GDFieldPos("D1_INTER")]
	cMeta   		:= aCols[i][GDFieldPos("D1_META")]
	cPedido 		:= aCols[i][GDFieldPos("D1_PEDIDO")]
	cTes 			:= aCols[i][GDFieldPos("D1_TES")]
	cConta			:= aCols[i][GDFieldPos("D1_CONTA")]
	cTFCcusto		:= aCols[i][GDFieldPos("D1_CC")]
	cop				:= aCols[i][GDFieldPos("D1_OP")]
	cNFOrig			:= aCols[i][GDFieldPos("D1_NFORI")]
	cSrOrig			:= aCols[i][GDFieldPos("D1_SERIORI")]
	cItOrig			:= aCols[i][GDFieldPos("D1_ITEMORI")]
	nQtdRet			:= aCols[i][GDFieldPos("D1_QUANT")]
	
	//Se o campo Meta (D1_META) do Item estiver vazio, obtem o campo Meta (F4_META) do cadastro de TES
	If Empty(AllTrim(cMeta))
		dbSelectArea("SF4")
		SF4->( dbSetOrder(1) )
		SF4->(dbSeek(xFilial("SF4")+cTes))
		aCols[i][GDFieldPos("D1_META")] = SF4->F4_META
	EndIf
	
	//Se for do tipo Devolução/Beneficiamento busca no cadastro de Clientes
	If cTipo$"D/B"
		If Empty(AllTrim(cInter))
			dbSelectArea("SA1")
			SA1->( dbSetOrder(1) )
			SA1->(dbSeek(xFilial("SA1")+cCodCliForn+cCodLoja))
			aCols[i][GDFieldPos("D1_INTER")] = SA1->A1_INTER
			
		EndIf
	Else
		If Empty(AllTrim(cInter))
			dbSelectArea("SA2")
			SA2->( dbSetOrder(1) )
			SA2->(dbSeek(xFilial("SA2")+cCodCliForn+cCodLoja))
			aCols[i][GDFieldPos("D1_INTER")] = SA2->A2_INTER
		EndIf
	EndIf
	
	If !Empty(cTFCcusto) 
		If .NOT. U_TFCCUSTO(cempant,cfilant,cTFCcusto)
			nCC_Nook := 1
		EndIf		
	EndIf
	
	/*
	|---------------------------------------------------------------------------------
	|	Verifica qual o armazem esta sendo utilizado. Se CQ retorna Falso
	|---------------------------------------------------------------------------------
	*/
	If aCols[i][GDFieldPos("D1_LOCAL")] == cArmCQ
		
		lArmCQ := .T. 
		
	EndIf 
	
	If aCols[i][GDFieldPos("D1_LOCAL")] == "21"
	
		If cTipo = "D" .AND. CEMPANT = "03" .AND. CFILANT = "01"
			aCols[i][GDFieldPos("D1_LOCAL")] := "96"
		Else
			lArm21Rt := .T.
		EndIf 
		
	EndIf 
	
	/*
	|---------------------------------------------------------------------------------
	|	Verifica se eh uma NF de Retorno de Beneficiamento. Somente quando não for
	|	informado a OP, questionando se eh uma NF de materiais divergentes e/ou
	|	devolvidos com defeitos.
	|---------------------------------------------------------------------------------
	*/
	IF	CEMPANT="04" .AND. CFILANT="02" .AND. !EMPTY(ALLTRIM(cNFOrig)) .AND. !EMPTY(ALLTRIM(cSrOrig)) .AND. !EMPTY(ALLTRIM(cItOrig)) .AND. EMPTY(ALLTRIM(cOp))
		
		cQuery := "SELECT" 																			+ ENTER 
		cQuery += "	SD2.D2_TIPO," 																	+ ENTER
		cQuery += "	SD2.D2_PEDIDO," 																+ ENTER
		cQuery += "	SD2.D2_COD," 																	+ ENTER
		cQuery += "	SC6.C6__OPBNFC," 																+ ENTER
		cQuery += "	SD2.D2_QUANT," 																	+ ENTER 
		cQuery += "	SD2.D2_CLIENTE," 																+ ENTER
		cQuery += "	SD2.D2_LOJA" 																	+ ENTER
		cQuery += "FROM" 																			+ ENTER 
		cQuery += "	" + RetSqlName("SD2") + " SD2 WITH(NOLOCK)" 									+ ENTER
		cQuery += "	INNER JOIN " + RetSqlName("SC6") + " SC6 WITH(NOLOCK) ON" 						+ ENTER 
		cQuery += "		SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND" 								+ ENTER 
		cQuery += "		SC6.C6_NUM = SD2.D2_PEDIDO AND" 											+ ENTER 
		cQuery += "		SC6.C6_ITEM = SD2.D2_ITEMPV AND" 											+ ENTER 
		cQuery += "		SC6.C6_PRODUTO = SD2.D2_COD AND" 											+ ENTER 
		cQuery += "		SC6.D_E_L_E_T_ = ''" 														+ ENTER
		cQuery += "WHERE" 																			+ ENTER 
		cQuery += "	SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND" 									+ ENTER 
		cQuery += "	SD2.D2_DOC + SD2.D2_SERIE + SD2.D2_ITEM = '" + cNFOrig + cSrOrig + cItOrig + "' AND" + ENTER 
		cQuery += "	SD2.D_E_L_E_T_ = ''" 															+ ENTER
		cQuery += "GROUP BY" 																		+ ENTER
		cQuery += "	SD2.D2_TIPO," 																	+ ENTER
		cQuery += "	SD2.D2_COD," 																	+ ENTER
		cQuery += "	SD2.D2_PEDIDO," 																+ ENTER
		cQuery += "	SC6.C6__OPBNFC," 																+ ENTER
		cQuery += "	SD2.D2_QUANT," 																	+ ENTER
		cQuery += "	SD2.D2_CLIENTE," 																+ ENTER
		cQuery += "	SD2.D2_LOJA"
		
		If Select("TMP") > 0 
		
			dbSelectArea("TMP")
			dbCloseArea()
			
		EndIf
	
		TcQuery cQuery New Alias "TMP"
		dbSelectArea("TMP")
		dbGoTop()
		
		Count to nReg
		
		If nReg > 0
			TMP->(dbGoTop())
			aAdd(aProcRet,{i, TMP->C6__OPBNFC, TMP->D2_COD, nQtdRet})
		EndIf	 
	
	ENDIF 
	
Next i

If nCC_Nook != 0
	lExecuta := .F.
EndIf

//Trecho Advise
If lExecuta
	
	For nX := 1 To Len(aImposto)
		If aImposto[nX][01] == "IRR"
			lIrrf := .T.
		EndIf
	Next nX
	
	If lIrrf
		If cDirf <> "1" .Or. Empty(cCodRet)
			lExecuta := .F.
			Alert("Preencher corretamente dados de IRRF / Código de retenção")
		EndIf
	EndIf
	
EndIf


If lExecuta
	//----------------------------------------------------------------------------------------------------------------------------
	// Ponto de Validação: TOTVS
	// Descrição: Validar unidade de negocio no produto
	// Merge.......: TAIFF - C. Torres                                           Data: 22/08/2013
	//----------------------------------------------------------------------------------------------------------------------------
	If lUniNeg
		For nx:= 1 to Len(aCols)
			cUneg := acols[nx][GdFieldPos('D1_ITEMCTA')]
			
			If !aCols[nx][Len(aCols[nx])]
				For nx1 := 1 to Len(aCols)
					
					If Empty(acols[nx1][GdFieldPos('D1_ITEMCTA')]) .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]
						_lRet := .F.
						Help(nil,1,'Unidade de Negocios',nil,'Obrigatório preencher unidade de negocios',3,0)
						Exit
						
					ElseIf cUneg <> acols[nx1][GdFieldPos('D1_ITEMCTA')] .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]
						
						_lRet := .F.
						Help(nil,1,'Unidade de Negocios',nil,'Não é permitido usar unidade de negocios diferentes',3,0)
						Exit
					EndIf
					
				Next nx1
			EndIf
			
			If !_lRet
				Exit
			EndiF
		Next nx
		
	EndIf
	lExecuta := _lRet
EndIf

//Novo trecho Advise
If lExecuta
	lExecuta := VerICMS()
EndIf

/*
|---------------------------------------------------------------------------------
|	Caso o armazem for de CQ não será liberado a Gravação.
|---------------------------------------------------------------------------------
*/                                                                                                              
If lArmCQ .AND. !(CTIPO $ "I|P|B|C")
	
	Help(nil,1,'Armazém de Entrada',nil,'Não é permitido usar armazém de CQ na entrada da NF',3,0)
	lExecuta := .F.
	
EndIF

/*
|---------------------------------------------------------------------------------
|	Inicia o processo de Retorno de Beneficiamento
|---------------------------------------------------------------------------------
*/
If lExecuta .And. Len(aProcRet) > 0 
			
	cMessage := "A NF de Origem se refere a um Beneficiamento e não foi informado uma OP nesta NF de Retorno." + ENTER + "Confirma que esta NF é um retorno de Materiais Divergentes e/ou com Defeitos?"  
	If MessageBox(cMessage,"Processo de Beneficiamento",1) = 1
		
		Begin Transaction

			For i := 1 To Len(aProcRet)
				
				dbSelectArea("SD4")
				dbSetOrder(2)
				dbGoTop()
				If dbSeek(xFilial("SD4") + aProcRet[i][2] + aProcRet[i][3])
					
					If RecLock("SD4",.F.)
						
						SD4->D4__QTBNFC -= aProcRet[i][4]
						MSUNLOCK()
						
					EndIf
					
				EndIf
				TMP->(dbSkip())
				
			Next i 
			
		End Transaction 
	
	Else
	
		lExecuta := .F.
		
	EndIf

EndIf

If lExecuta .AND. !Empty(cCondicao)
	ACONDPAG	:= CONDICAO( 1000 , cCondicao ) // cCondicao é PRIVATE do fonte MATA103
	For nCtaPag:= 1 to Len(ACONDPAG)
		If ACONDPAG[nCtaPag,1] < date() .AND. lExecuta  
			lExecuta := .F.
			MsgAlert( "A data de vencimento não atende a área financeira!" + ENTER + "Data cálculada para a condição de pagamento: " + Dtoc(ACONDPAG[nCtaPag,1]) + ENTER + ENTER + "Solução: Utilize outra condição de pagamento." ,"Vencimento inválido!" )
		EndIf 
	Next  	
EndIf

If lExecuta .AND. CEMPANT="03" .AND. CFILANT="01" .AND. lArm21Rt  
	lCrossDo := .F.
	// Busca em Extrema (filial=02) a origem da nota fiscal caso seja intercompany de CROSS DOCKING deve permitir a inclusão 
	SF2->(DbsetOrder(1)) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO
	If SF2->(Dbseek( "02" + CNFISCAL + CSERIE ))
		If ALLTRIM(SF2->F2_NUMRM) = "CROSS"
			lCrossDo := .T.
		EndIf
	EndIf
	
	If (.NOT. lCrossDo) .AND. (.NOT. (CTIPO $ "I|P|C"))
		Help(nil,1,"MT100TOK" ,nil,"O armazém 21 é exclusivo do processo de CROSS DOCKING.",3,0)
		lExecuta := .F.
	EndIf
EndIf

RestArea(aArSF2)
RestArea(aArCT1)
RestArea(aArSA2)
RestArea(aArSA1)
RestArea(aArSF4)
RestArea(aArea)

Return (lExecuta)

/*==========================================================================
Funcao.........:	VerICMS
Descricao......:	Verifica preenchimento do ICMS
Autor..........:	Amedeo D. Paoli Filho (Advise)
Parametros.....:	Nil
Retorno........:	Logico
==========================================================================*/
Static Function VerICMS()

Local aAreaF1	:= SF1->(GetArea())
Local aAreaD1	:= SD1->(GetArea())
Local aAreaA2	:= SA2->(GetArea())
Local aAreaF4	:= SF4->(GetArea())

Local nPICMS	:= Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_PICM"		})
Local nPBase	:= Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_BASEICM"	})
Local nPValor	:= Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_VALICM"	})
Local nPTes		:= Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_TES"		})
Local nAliqMax	:= SuperGetMV("TF_PERSIMP", Nil, 7)

Local lRetorno	:= .T.
Local nX		:= 0

For nX := 1 To Len(aCols)
	If !aCols[nX][Len(aHeader)+1]
		
		CONOUT("Item: " + aCols[nX][Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_ITEM"	})] + " LOCAL: " + aCols[nX][Ascan(aHeader, {|x| AllTrim(x[02]) == "D1_LOCAL"	})])
		//Verifica cadastro de TES
		DbSelectarea("SF4")
		SF4->(DbSetorder(1))
		SF4->(MsSeek(xFilial("SF4") + aCols[nX][nPTes]))
		
		If SF4->F4_ICM == "N"
			
			//Verifica campo D1_PICM
			If lRetorno
				If nPICMS > 0 .And. aCols[nX][nPICMS] <> 0
					lRetorno := .F.
					MsgInfo("A TES: " + Alltrim(SF4->F4_CODIGO) + " Está para não calcular ICMS e o percentual está preenchido, Verifique linha: " + Alltrim(Str(nX)))
				EndIf
			EndIf
			
			//Verifica campo D1_BASEICM
			If lRetorno
				If nPBase > 0 .And. aCols[nX][nPBase] <> 0
					lRetorno := .F.
					MsgInfo("A TES: " + Alltrim(SF4->F4_CODIGO) + " Está para não calcular ICMS e o valor Base de ICMS está preenchido, Verifique linha: " + Alltrim(Str(nX)))
				EndIf
			EndIf
			
			//Verifica campo D1_VALICM
			If lRetorno
				If nPValor > 0 .And. aCols[nX][nPValor] <> 0
					lRetorno := .F.
					MsgInfo("A TES: " + Alltrim(SF4->F4_CODIGO) + " Está para não calcular ICMS e o valor de ICMS está preenchido, Verifique linha: " + Alltrim(Str(nX)))
				EndIf
			EndIf
			
		EndIf
		
		
		//Valida ICMS de Fornecedor Simples Nacional
		If lRetorno .And. !CTIPO $ "D/B"
			DbSelectarea("SA2")
			SA2->(DbSetorder(1))
			SA2->(MsSeek(xFilial("SA2") + CA100FOR + CLOJA))
			If SA2->A2_SIMPNAC == "1"
				If aCols[nX][nPICMS] > nAliqMax  // Alterado para reter apenas quando a aliquota informada for maior que o padrao
					lRetorno := .F.
					Alert("O percentual do ICMS da linha " + Alltrim(Str(nX)) + " está maior que o valor permitido, Verifique!!!")
				EndIf
			EndIf
		EndIf
		
	EndIf
Next nX

RestArea(aAreaF1)
RestArea(aAreaD1)
RestArea(aAreaA2)
RestArea(aAreaF4)

Return lRetorno
