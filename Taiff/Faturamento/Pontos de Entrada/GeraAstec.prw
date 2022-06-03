#include "Rwmake.ch"
#include "Ap5mail.ch"
#include "Topconn.ch"
#include "TbiConn.ch"                  
#include "TbiCode.ch"
#include "Protheus.ch"
#DEFINE ENTER Chr(13) + Chr(10)

/* Gera pedido da ASTEC para venda do saldo da DAIHATSU para TAIFFPROART - MATRIZ */
User Function GeraAstec()
Local oObj   
Default lEnd 		:= .F. 

If (cEmpAnt = "01" .and. cFilAnt = "02")
	If MsgYesNo("Deseja executar a geração de pedidos da ASCTEC?")
		oObj := MsNewProcess():New({|lEnd| Proc02To02(oObj, @lEnd)}, "", "", .T.)
		oObj :Activate()
	EndIf
Else
	Msgstop("Somente é permitido executar este processo na empresa DAIHATSU - NAÇOES.")
EndIf
	
Return .T.	

Static Function Proc02To02(oObj, lEnd)
	Local _cQuery		:= ""
	Local _nRec 		:= 0
	Local _cPSC5		:= ""
	Local aCabec	:= {} 
	Local aLinha	:= {}
	Local aItens	:= {}
	Local nElementos	:= 0
	Local nItensPed	:= 0
	Local CITEMPED		:= ""
	Local nVlTotal		:= 0
	
	Private lMsErroAuto := .F.
	
	lCredito	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
	lEstoque	:= .T.
	lLiber		:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
	lTransf		:= .F.
	If GetMv("MV_ESTNEG") == "S"
		lAvEst:= .f.
	Else
		lAvEst:= .t.
	Endif
	   
	DA1->(DbSetOrder(1))  
		   
	//***************************************************************************
	//* GERA LISTA COM BASE NO SALDO B2_QATU E BF_LOCALIZ					    	*
	//***************************************************************************
	
	_cQuery := "SELECT BF_PRODUTO,BF_LOCAL,BF_LOCALIZ, B2_QATU,B2_RESERVA,B2_NAOCLAS,B2_QACLASS,SUM(BF_QUANT) AS BF_QUANT,SUM(BF_EMPENHO) AS BF_EMPENHO " + ENTER  
	_cQuery += "FROM SBF010 SBF WITH(NOLOCK) " + ENTER 
	_cQuery += "INNER JOIN SB2010 SB2 WITH(NOLOCK) " + ENTER 
	_cQuery += "	ON B2_COD=BF_PRODUTO	" + ENTER 
	_cQuery += "	AND B2_FILIAL=BF_FILIAL" + ENTER 
	_cQuery += "	AND B2_LOCAL=BF_LOCAL" + ENTER 
	_cQuery += "	AND B2_QATU != 0" + ENTER 
	_cQuery += "	AND B2_LOCAL='51'" + ENTER 
	_cQuery += "	AND B2_QATU - B2_RESERVA > 0" + ENTER
	_cQuery += "	AND SB2.D_E_L_E_T_=''" + ENTER
	_cQuery += "WHERE BF_FILIAL='02'" + ENTER 
	_cQuery += "	AND SBF.D_E_L_E_T_=''" + ENTER 
	_cQuery += "	AND BF_LOCAL='51'" + ENTER 
	_cQuery += "	AND BF_QUANT > 0" + ENTER 
	_cQuery += "	AND B2_COD IN ('623260098      ')      " + ENTER 
	_cQuery += "GROUP BY BF_PRODUTO,BF_LOCAL,BF_LOCALIZ, B2_QATU,B2_RESERVA,B2_NAOCLAS,B2_QACLASS" + ENTER
	_cQuery += "ORDER BY BF_PRODUTO,BF_LOCALIZ	" + ENTER 
	
	
	//MEMOWRITE("GERAASTEC_LISTA_PRODUTOS.SQL",_cQuery)
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC5 := GetNextAlias()), .F., .T.)
	
	COUNT TO _nRec
	oObj:SetRegua1(_nRec)
	
	cTabPreco := "TRA"
	nElementos := 0

	aAdd(aCabec,{"C5_TIPO"	,"N"				,nil}) //  1 Tipo de Pedido          
	aAdd(aCabec,{"C5_CLIENTE"	,"001497"			,nil}) //  2 Codigo de Cliente      
	aAdd(aCabec,{"C5_LOJACLI"	,"01"				,nil}) //  3 Loja do Cliente         
	aAdd(aCabec,{"C5_CLIENT" ,"001497"			,nil}) //  4 Cliente Entrega                 
	aAdd(aCabec,{"C5_LOJAENT"	,"01"				,nil}) //  5 Loja do Entrega         
	aAdd(aCabec,{"C5_NUMOLD"	,""					,nil}) //  6 Pedido do Portal   
	aAdd(aCabec,{"C5_EMISSAO"	,dDataBase			,nil}) //  7 Data de Emissao   
	aAdd(aCabec,{"C5_XITEMC"	,"TAIFF"			,nil}) //  8 Unidade de Negócio
	aAdd(aCabec,{"C5_EMPDES"	,"01"				,nil}) //  9 Empresa Destino
	aAdd(aCabec,{"C5_FILDES"	,"02"				,nil}) // 10 Filial Destino  
	aAdd(aCabec,{"C5_XLIBCR" ,"L"				,nil}) // 11 Libaração de Crédito                 
	aAdd(aCabec,{"C5_CLASPED"	,"V"				,nil}) // 12 Classificação do Pedido  
	aAdd(aCabec,{"C5_VEND1"	,"000511"			,nil}) // 13 Vendedor  
	aAdd(aCabec,{"C5_TABELA"	,cTabPreco			,nil}) // 14 Tabela de precos  
	aAdd(aCabec,{"C5_TRANSP" 	,"000526"			,nil}) // 15 Transportadora 000526 - NOSSO CARRO                
	aAdd(aCabec,{"C5_CONDPAG"	,"N01"				,nil}) // 16 Condicao de Pagto. N01 - A VISTA
	aAdd(aCabec,{"C5_TPFRETE"	,"C"				,nil}) // 17 Tipo de frete     
	aAdd(aCabec,{"C5_INTER"	,"S"				,nil}) // 18 InterCompany                 
	aAdd(aCabec,{"C5_FINALID"	,"2"				,nil}) // 19 Finalidade                 
	aAdd(aCabec,{"C5_VOLUME1"	,""					,nil}) // 20 Volumes                 
	aAdd(aCabec,{"C5_ESPECI1"	,""					,nil}) // 21 Especie                 
	
	(_cPSC5)->(dbGoTop())
	While !(_cPSC5)->(Eof())
		
		nItensPed := 0
		CITEMPED  := Soma1(Replicate("0", TamSX3("C6_ITEM")[1]), TamSX3("C6_ITEM")[1])
		
		While !(_cPSC5)->(Eof()) .AND. nItensPed < 51

			aLinha	:= {}
			nElementos ++
			oObj:IncRegua1("Processando item " + Alltrim(Str(nElementos)) + " de " + Alltrim(Str(_nRec)) + " encontrados.")

			If (_cPSC5)->(B2_RESERVA + B2_NAOCLAS + B2_QACLASS + BF_EMPENHO) = 0

				If DA1->( MsSeek( xFilial('DA1') + cTabPreco + (_cPSC5)->BF_PRODUTO	))
					CTES := MATESINT(2,"V3","001497","01","C",(_cPSC5)->BF_PRODUTO)
					If !Empty(CTES)
						nItensPed ++
		
						nValorPod := DA1->DA1_PRCVEN
						nVlTotal	:= ROUND(nValorPod*(_cPSC5)->BF_QUANT,2)
		
						aAdd(aLinha, {"C6_ITEM   "		,CITEMPED 		  					,Nil})
						aAdd(aLinha, {"C6_PRODUTO"		,(_cPSC5)->BF_PRODUTO				,Nil})
						aAdd(aLinha, {"C6_QTDVEN "		,(_cPSC5)->BF_QUANT				,Nil})
						aAdd(aLinha, {"C6_LOCAL  "		,(_cPSC5)->BF_LOCAL				,Nil})
						aAdd(aLinha, {"C6_LOCALIZ"		,(_cPSC5)->BF_LOCALIZ				,Nil})
						aAdd(aLinha, {"C6_XOPER"			,"V3"								,Nil})
						aAdd(aLinha, {"C6_TES    "		,CTES 			 					,Nil})
						AAdd(aLinha, { "C6_PRCVEN"		, nValorPod						,Nil})
						AAdd(aLinha, { "C6_VALOR"			, nVlTotal							,Nil})
						AAdd(aLinha, { "C6_PRUNIT"		, nValorPod						,Nil})
							      
						aAdd(aItens,aLinha)
						CITEMPED := Soma1(CITEMPED, TamSX3("C6_ITEM")[1])
					Else
						//MemoWrite("ASTEC_erro_produto_sem_TES_" + ALLTRIM((_cPSC5)->BF_PRODUTO) + ".txt", ALLTRIM((_cPSC5)->BF_PRODUTO))
					EndIf				
				Else
					//MemoWrite("ASTEC_erro_produto_sem_preco_" + ALLTRIM((_cPSC5)->BF_PRODUTO) + ".txt", ALLTRIM((_cPSC5)->BF_PRODUTO))
				EndIf
			Else
				//MemoWrite("ASTEC_erro_produto_com_empenho_" + ALLTRIM((_cPSC5)->BF_PRODUTO) + ".txt", ALLTRIM((_cPSC5)->BF_PRODUTO))
			EndIf
			(_cPSC5)->(DbSkip())
			
			If (_cPSC5)->(Eof())
				nItensPed := 100
			EndIf
			
		End

		aCabec[20,2] := Len(aItens) // Alltrim(str( Len(aItens) ))				// 
		aCabec[21,2] := IIF(Len(aItens)>1,"CAIXAS","CAIXA")
		
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3) 
	
		If lMsErroAuto
			//MostraErro()
			MostraErro("\SYSTEM\", "ASTEC_Erros_" + dtos(date()) + "_" + substr(TIME(),1,2) + substr(TIME(),4,2) + ".txt")
			lMsErroAuto := .F.
		Else
			//MemoWrite("ASTEC_Sucesso_" + ALLTRIM(SC5->C5_NUM) + ".txt", ALLTRIM(SC5->C5_NUM))
			/*
			// lIBERADO PEDIDO	
			SC6->(DbSetOrder(1))
			SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM ))
			While  SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == SC5->C5_NUM .and. !SC6->(Eof()) 
				nQtdLib := MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
				If nQtdLib = 0
					MemoWrite("ASTEC_no_liberado_" + ALLTRIM(SC5->C5_NUM) + ".txt", ALLTRIM(SC5->C5_NUM))
				EndIf 
				SC6->(DbSkip())			     
			End
			MaLiberOk({ SC5->C5_NUM },.F.)
      	    */
		EndIf		
		aItens := {}
		
	End
	
	(_cPSC5)->(dbCloseArea())
	
Return .T.


