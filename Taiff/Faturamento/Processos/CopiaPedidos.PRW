#include "Rwmake.ch"
#include "Ap5mail.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "Protheus.ch"
#DEFINE ENTER Chr(13) + Chr(10)

/******************************************************************************  
* FUNÇÃO 	: TFCop02To01								  					  *
* OBJETIVO  : REALIZA A CÓPIA DE PEDIDOS DE UMA FILIAL PARA OUTRA E ELIMINA   *
* 			  RESÍDUO DOS PEDIDOS COPIADOS NA ORIGEM						  *
* AUTOR     : GILBERTO RIBEIRO JUNIOR										  *
* DATA      : 28/10/2015													  *
*---------------------------------ALTERACOES----------------------------------*  
* DATA       AUTOR       OBJETIVO											  *
*----------- ----------- -----------------------------------------------------*  
******************************************************************************/  
User Function TFCop02To01()
	Local oObj   
	Local _hora  
	Default lEnd 		:= .F. 
	
	// Se o Processo não estiver sendo executado em Taiff Proart - Matriz, mostra mensagem e sai do Processo
	If (cEmpAnt <> "03" .and. cFilAnt <> "01")
		Msgstop("Somente é permitido executar este processo na Taiff Proart - Matriz.")
		Return
	EndIf
	
	If MsgYesNo("Deseja executar o processo de Cópia de Pedidos com Saldos da Filial Extrema(02) para a Filial Matriz(01).")
		_hora := REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
		alert("Inicio: " + _hora)
		GerSB2()
		oObj := MsNewProcess():New({|lEnd| Proc02To01(oObj, @lEnd)}, "", "", .T.)
		oObj :Activate()
		_hora := REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
		alert("Fim: " + _hora)
	Else
		Return	
	EndIf
	
Return .T.	

User Function TFCop01To02()
	Local oObj 
	Local _hora   
	Default lEnd 		:= .F. 
	
	// Se o Processo não estiver sendo executado em Taiff Proart - Matriz, mostra mensagem e sai do Processo
	If (cEmpAnt <> "03" .and. cFilAnt <> "02")
		Msgstop("Somente é permitido executar este processo na Taiff Proart - Extrema.")
		Return
	EndIf
	
	If MsgYesNo("Deseja executar o processo de Cópia de Pedidos com Saldos da Filial Matriz(01) para a Filial Extrema(02).")
		_hora := REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
		alert("Inicio: " + _hora)
		GerSB2()
		oObj := MsNewProcess():New({|lEnd| Proc01To02(oObj, @lEnd)}, "", "", .T.)
		oObj :Activate()
		_hora := REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
		alert("Fim: " + _hora)
	Else
		Return	
	EndIf
	
Return .T.	

Static Function Proc02To01(oObj, lEnd)
	Local _cQuery		:= ""
	Local _nRec 		:= 0
	Local _nProc		:= 1
	Local cNumPedTest   := "" // Somente preencher esta variável quando a for efetuar teste apenas com um único pedido
	Local _cPSC5		:= ""
	
	Private lMsErroAuto := .F.  
	Private cNumPed		:= ''
	Private cpEmp 		:= ""
	Private cpFil 		:= ""
		   
	//***************************************************************************
	//* OBTEM TODOS OS PEDIDOS QUE NECESSITAM SER COPIADOS						*
	//***************************************************************************
	
	//_cQuery := " SELECT DISTINCT  TOP 10 SC5.C5_FILIAL "	+ ENTER
	_cQuery := " SELECT DISTINCT  SC5.C5_FILIAL "	   		+ ENTER  
	_cQuery += " 				 ,SC5.C5_NUM "		   		+ ENTER 
	_cQuery += " FROM SC6030 SC6 "		   			   		+ ENTER 
	_cQuery += " INNER JOIN SC5030 SC5 "   			   		+ ENTER 
	_cQuery += "   ON SC6.C6_NUM     = SC5.C5_NUM "    		+ ENTER 
	_cQuery += "  AND SC6.C6_FILIAL  = SC5.C5_FILIAL " 		+ ENTER
	_cQuery += "  AND SC6.D_E_L_E_T_ = '' "			   		+ ENTER
	_cQuery += "  AND SC5.D_E_L_E_T_ = '' "			   		+ ENTER 
	_cQuery += " WHERE C5_FILIAL = '02'	"	   		   		+ ENTER // SOMENTE FILIAL EXTREMA
	_cQuery += "   AND C5_INTER  <> 'S' "		   	   		+ ENTER // DIFERENTE DE INTERCOMPANY
	_cQuery += "   AND C6_LOCAL  IN ('22', '23') "	   		+ ENTER // APENAS OS PEDIDOS QUE ESTÃO NO ARMAZÉM 21
	_cQuery += "   AND C6_QTDENT < C6_QTDVEN " 		   		+ ENTER // SALDO DE PEDIDO
	_cQuery += "   AND C6_BLQ    = '' "				   		+ ENTER // SEM ELIMINAÇÃO DE RESÍDUO
	_cQuery += "   AND C5_XITEMC IN ('TAIFF', 'PROART') "	+ ENTER // UNIDADE DE NEGÓCIO (TAIFF/PROART)
	_cQuery += "   AND C5_FILDES = '01' "					+ ENTER // SOMENTE PEDIDOS COM DESTINO SÃO PAULO
		
	If cNumPedTest <> ""
		_cQuery += " AND C5_NUM = '" + cNumPedTest + "' "   + ENTER // FILTRA O PEDIDO PARA TESTES	
	EndIf
	
	_cQuery += " ORDER BY SC5.C5_NUM "				   		+ ENTER // ORDENA POR CÓDIGO DO PEDIDO
	
	_cQuery := ChangeQuery( _cQuery )
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC5 := GetNextAlias()), .F., .T.)
	
	COUNT TO _nRec
	oObj:SetRegua1(_nRec)
	(_cPSC5)->(dbGoTop())
	
	Do While !(_cPSC5)->(Eof())
		
		oObj:IncRegua1("Processando pedido " + Alltrim(Str(_nProc)) + " de " + Alltrim(Str(_nRec)) + " encontrados.")
		
		cNumPed   := (_cPSC5)->C5_NUM
		codFilial := (_cPSC5)->C5_FILIAL
		
		// Monta os arrays do Pedido para inclusão		
		TFGerarPed(cNumPed, codFilial, .F.)
		
		_nProc ++
		
		(_cPSC5)->(DbSkip())
		
	EndDo
	
	(_cPSC5)->(dbCloseArea())
	
	If !lMsErroAuto
		MsgInfo("Pedidos de Venda gerados com sucesso.")
	EndIf
	
Return .T.

//***********************************************************************************************************************************
//* COPIA OS PEDIDOS DA MATRIZ PARA EXTREMA (SOMENTE OS PEDIDO QE FORAM COPIADOS ATRAVÉS DA ROTINA (Proc02To01)						*
//***********************************************************************************************************************************
Static Function Proc01To02(oObj, lEnd)
	Local _cQuery		:= ""
	Local _nRec 		:= 0
	Local _nProc		:= 1
	Local cNumPedTest   := "" // Somente preencher esta variável quando a for efetuar teste apenas com um único pedido
	Local _cPSC5		:= ""
	
	Private lMsErroAuto := .F.  
	Private cNumPed		:= ''
	Private cpEmp 		:= ""
	Private cpFil 		:= ""
		   
	//***************************************************************************
	//* OBTEM TODOS OS PEDIDOS QUE NECESSITAM SER COPIADOS						*
	//***************************************************************************
	
	_cQuery := " SELECT DISTINCT  SC5.C5_FILIAL "	   		+ ENTER  
	_cQuery += " 				 ,SC5.C5_NUM "		   		+ ENTER 
	_cQuery += " FROM SC6030 SC6 "		   			   		+ ENTER 
	_cQuery += " INNER JOIN SC5030 SC5 "   			   		+ ENTER 
	_cQuery += "   ON SC6.C6_NUM     = SC5.C5_NUM "    		+ ENTER 
	_cQuery += "  AND SC6.C6_FILIAL  = SC5.C5_FILIAL " 		+ ENTER
	_cQuery += "  AND SC6.D_E_L_E_T_ = '' "			   		+ ENTER
	_cQuery += "  AND SC5.D_E_L_E_T_ = '' "			   		+ ENTER 
	_cQuery += " WHERE C5_FILIAL = '01'	"	   		   		+ ENTER // SOMENTE FILIAL MATRIZ
	_cQuery += "   AND C5_INTER  <> 'S' "		   	   		+ ENTER // DIFERENTE DE INTERCOMPANY
	_cQuery += "   AND C6_LOCAL  IN ('22', '23') "	   		+ ENTER // APENAS OS PEDIDOS QUE ESTÃO NO ARMAZÉM 21
	_cQuery += "   AND C5_NUMOLD LIKE '%C' "				+ ENTER // SOMENTE PEDIDOS QUE TENHAM SIDO CRIADOS ATRAVÉS DA ROTINA (Proc02To01)
	_cQuery += "   AND C5_STCROSS = '' "					+ ENTER // PARA ELIMINAR OS PEDIDOS QUE JÁ FORAM COPIADOS
		
	If cNumPedTest <> ""
		_cQuery += " AND C5_NUM = '" + cNumPedTest + "' "   + ENTER // FILTRA O PEDIDO PARA TESTES	
	EndIf
	
	_cQuery += " ORDER BY SC5.C5_NUM "				   		+ ENTER // ORDENA POR CÓDIGO DO PEDIDO
	
	_cQuery := ChangeQuery( _cQuery )
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC5 := GetNextAlias()), .F., .T.)
	
	COUNT TO _nRec
	oObj:SetRegua1(_nRec)
	(_cPSC5)->(dbGoTop())
	
	
	SC5->(DbSetOrder(1))
	
	Do While !(_cPSC5)->(Eof())
		
		oObj:IncRegua1("Processando pedido " + Alltrim(Str(_nProc)) + " de " + Alltrim(Str(_nRec)) + " encontrados.")
		
		cNumPed   := (_cPSC5)->C5_NUM
		codFilial := (_cPSC5)->C5_FILIAL
		
		If SC5->(DbSeek(codFilial + cNumPed))
			U_PEDCDMG(cNumPed, .T.)
		EndIf
		
		_nProc ++
		
		(_cPSC5)->(DbSkip())
		
	EndDo
	
	(_cPSC5)->(dbCloseArea())
	
	If !lMsErroAuto
		MsgInfo("Pedidos de Venda gerados com sucesso em Extrema.")
	EndIf
	
Return .T.


Static Function TFGerarPed(numPedido, numFilial, infOrigem)
	
	Local aCabec	:= {} 
	Local aLinha	:= {}
	Local aItens	:= {}
	
	Private numOld := ""
	Private qtdSaldo := 0
	
		
		SC5->(DbSetOrder(1))
		
	If SC5->(DbSeek(numFilial + numPedido))
		
			numOld := SC5->C5_NUMOLD
		
			// Somente quando for executada a cópia para São Paulo, quando for para Minas o NumOld deverá ser o próprio NumOld
		if (infOrigem == .F. )
			If Empty(AllTrim(numOld))
					numOld := AllTrim(SC5->C5_NUM) + "C" // Para pedidos que não foram gerados através do Portal
			Else
					numOld := AllTrim(SC5->C5_NUMOLD) + "C"
			EndIf
		EndIf
			
		    // Monta Array Cabecalho do Pedido de Venda
			aAdd(aCabec,{"C5_TIPO"		,SC5->C5_TIPO  		 ,nil}) // Tipo de Pedido          
			aAdd(aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE  	 ,nil}) // Codigo de Cliente      
			aAdd(aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI  	 ,nil}) // Loja do Cliente         
			aAdd(aCabec,{"C5_LOJAENT"	,SC5->C5_LOJAENT  	 ,nil}) // Loja do Entrega         
			aAdd(aCabec,{"C5_TRANSP"  	,SC5->C5_TRANSP      ,nil}) // Transportadora                 
			aAdd(aCabec,{"C5_TABELA"	,SC5->C5_TABELA 	 ,nil}) // Tabela de precos  
			aAdd(aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG     ,nil}) // Condicao de Pagto.
			aAdd(aCabec,{"C5_XLIBCR"  	,SC5->C5_XLIBCR      ,nil}) // Libaração de Crédito                 
			aAdd(aCabec,{"C5_CLIENT"  	,SC5->C5_CLIENT      ,nil}) // Cliente Entrega                 
			aAdd(aCabec,{"C5_MENNOTA" 	,SC5->C5_MENNOTA     ,nil}) // Mensagem da Nota Fiscal                 
			aAdd(aCabec,{"C5_MENPAD"  	,SC5->C5_MENPAD      ,nil}) // Mensa                 
			aAdd(aCabec,{"C5_FINALID" 	,SC5->C5_FINALID     ,nil}) // Finalidade                 
			aAdd(aCabec,{"C5_FATFRAC" 	,SC5->C5_FATFRAC     ,nil}) // Fatura fracionado                 
			aAdd(aCabec,{"C5_INTER"   	,SC5->C5_INTER       ,nil}) // InterCompany                 
			aAdd(aCabec,{"C5_TFBONIF" 	,SC5->C5_TFBONIF	 ,nil}) //                  
			aAdd(aCabec,{"C5_TPFRETE"	,SC5->C5_TPFRETE 	 ,nil}) // Tipo de frete     
			aAdd(aCabec,{"C5_CLASPED"	,SC5->C5_CLASPED 	 ,nil}) // Classificação do Pedido  
			aAdd(aCabec,{"C5_TIPOCLI"	,SC5->C5_TIPOCLI	 ,nil}) // Tipo de Cliente   
			aAdd(aCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO	 ,nil}) // Data de Emissao   
			aAdd(aCabec,{"C5_PESOL"		,SC5->C5_PESOL       ,nil}) // Peso
			aAdd(aCabec,{"C5_PBRUTO"	,SC5-> C5_PBRUTO     ,nil}) // Peso Bruto
			aAdd(aCabec,{"C5_NUMOLD"	,numOld				 ,nil}) // Pedido do Portal   
			aAdd(aCabec,{"C5_FRETE"   	,SC5->C5_FRETE		 ,nil}) // Frete  
			aAdd(aCabec,{"C5_VEND1"		,SC5->C5_VEND1		 ,nil}) // Vendedor  
			aAdd(aCabec,{"C5_COMIS1"	,SC5->C5_COMIS1		 ,nil}) // Comissão (Verificar se passando a Comissão não ficará errado com a nova quantidade) 
			aAdd(aCabec,{"C5_PESOL"		,SC5->C5_PESOL		 ,nil}) // Peso Liquido  
			aAdd(aCabec,{"C5_PBRUTO"	,SC5->C5_PBRUTO		 ,nil}) // Peso Bruto  
			aAdd(aCabec,{"C5_VOLUME1"	,SC5->C5_VOLUME1	 ,nil}) // Volume  
			aAdd(aCabec,{"C5_ESPECI1"	,SC5->C5_ESPECI1	 ,nil}) // Espécie  
			aAdd(aCabec,{"C5_DTPEDPR"	,SC5->C5_DTPEDPR	 ,nil}) // Data do Pedido Programado  
			aAdd(aCabec,{"C5_OBSERVA"	,SC5->C5_OBSERVA	 ,nil}) // Observação   
			aAdd(aCabec,{"C5_DTAPPO"	,SC5->C5_DTAPPO		 ,nil}) // Data da aprovação do pedido no Portal
			aAdd(aCabec,{"C5_HRAPPO"	,SC5->C5_HRAPPO		 ,nil}) // Hora da aprovação do pedido no Portal
			aAdd(aCabec,{"C5_DTIMP"		,SC5->C5_DTIMP		 ,nil}) // Data da importação do pedido para o Protheus
			aAdd(aCabec,{"C5_HRIMP"		,SC5->C5_HRIMP		 ,nil}) // Hora da importação do pedido para o Protheus   
			aAdd(aCabec,{"C5_XITEMC"	,SC5->C5_XITEMC		 ,nil}) // Unidade de Negócio
			aAdd(aCabec,{"C5_PCFRETE"	,SC5->C5_PCFRETE	 ,nil}) // Percentual de Frete
			aAdd(aCabec,{"C5_XITEMC"	,SC5->C5_XITEMC		 ,nil}) // Linha de Unidade de Negocio	
			aAdd(aCabec,{"C5_EMPDES"	,SC5->C5_EMPDES		 ,nil}) // Empresa Destino
			aAdd(aCabec,{"C5_FILDES"	,SC5->C5_FILDES		 ,nil}) // Filial Destino  
			aAdd(aCabec,{"C5_NUMORI"	,IIf(infOrigem == .T., SC5->C5_NUM, ""), 	 nil}) // Numero do Pedido de Origem
			aAdd(aCabec,{"C5_CLIORI"	,IIf(infOrigem == .T., SC5->C5_CLIENTE, ""), nil}) 
			aAdd(aCabec,{"C5_LOJORI"	,IIf(infOrigem == .T., SC5->C5_LOJACLI, ""), nil})
			aAdd(aCabec,{"C5_NOMORI"	,IIf(infOrigem == .T., SC5->C5_NOMCLI, ""),  nil})
			aAdd(aCabec,{"C5_NUMOC"		,IIf(infOrigem == .T., "CROSS", ""), 		 nil}) // Texto simples que dará apoio ao processo de Recebimento Cross Docking
	      
	        SC6->(DbSetOrder(1))
	        
	        SC6->(DbSeek(numFilial + numPedido))     
	            
		While !SC6->(Eof()) .AND. SC6->C6_FILIAL = numFilial .AND. SC6->C6_NUM = numPedido
	      	
			If (SC6->C6_LOCAL $ "22|23" .AND. Empty(SC6->C6_BLQ) .AND. (SC6->C6_QTDENT < SC6->C6_QTDVEN))

					aLinha	:= {}
					
					qtdSaldo := SC6->C6_QTDVEN - SC6->C6_QTDENT
										
					aAdd(aLinha, {"C6_ITEM   "		,SC6->C6_ITEM   					,Nil})
					aAdd(aLinha, {"C6_PRODUTO"		,SC6->C6_PRODUTO					,Nil})
					aAdd(aLinha, {"C6_UM     "		,SC6->C6_UM     					,Nil})
					aAdd(aLinha, {"C6_QTDVEN "		,qtdSaldo		  					,Nil})
					aAdd(aLinha, {"C6_QTDENT "		,0									,Nil})
					aAdd(aLinha, {"C6_QTDENT2"		,0									,Nil})
					aAdd(aLinha, {"C6_PRCVEN "		,SC6->C6_PRCVEN 					,Nil})
					aAdd(aLinha, {"C6_TES    "		,SC6->C6_TES    					,Nil})
					aAdd(aLinha, {"C6_LOCAL  "		,SC6->C6_LOCAL  					,Nil})
					aAdd(aLinha, {"C6_CF     "		,SC6->C6_CF     					,Nil})
					aAdd(aLinha, {"C6_CLI    "		,SC6->C6_CLI    					,Nil})
					aAdd(aLinha, {"C6_ENTREG "		,SC6->C6_ENTREG 					,Nil})
					aAdd(aLinha, {"C6_LOJA   "		,SC6->C6_LOJA   					,Nil})
					aAdd(aLinha, {"C6_NOTA   "		,SC6->C6_NOTA   					,Nil})
					aAdd(aLinha, {"C6_SERIE  "		,SC6->C6_SERIE  					,Nil})
					aAdd(aLinha, {"C6_DATFAT "		,SC6->C6_DATFAT 					,Nil})
					aAdd(aLinha, {"C6_COMIS1 "		,SC6->C6_COMIS1 					,Nil})
					aAdd(aLinha, {"C6_PEDCLI "		,SC6->C6_PEDCLI 					,Nil})
					aAdd(aLinha, {"C6_DESCRI "		,SC6->C6_DESCRI 					,Nil})
					aAdd(aLinha, {"C6_PRUNIT "		,SC6->C6_PRUNIT 					,Nil})
					aAdd(aLinha, {"C6_PICMRET"		,SC6->C6_PICMRET					,Nil})
					aAdd(aLinha, {"C6_CLASFIS"		,SC6->C6_CLASFIS					,Nil})
					aAdd(aLinha, {"C6_CUSTPRO"		,SC6->C6_CUSTPRO					,Nil})
					aAdd(aLinha, {"C6_XOPER"		,SC6->C6_XOPER						,Nil})
					aAdd(aLinha, {"C6_DTFIMNT"		,SC6->C6_DTFIMNT					,Nil})
					aAdd(aLinha, {"C6_TPOP	 "		,SC6->C6_TPOP						,Nil})
					aAdd(aLinha, {"C6_TPESTR "		,SC6->C6_TPESTR 					,Nil})
					aAdd(aLinha, {"C6_FCICOD "		,SC6->C6_FCICOD 					,Nil})
					aAdd(aLinha, {"C6_XITEMC "		,SC6->C6_XITEMC 					,Nil})
						      
			        aAdd(aItens,aLinha)
			      
			EndIf
		        
		        SC6->(DbSkip())
		        
		End
			
	      MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3) 
	
		If lMsErroAuto
	          //MostraErro()
	          MostraErro("\SYSTEM\", "CopiaPedidos_Erros_" + numPedido + ".txt")
	          lMsErroAuto := .F.
		Else
	      	  ElimRes(numPedido, numFilial)	
	      	  //MemoWrite("CopiaPedidos_Sucesso_" + numPedido + ".txt", numPedido)
		EndIf
	      
	EndIf
Return .T.


/******************************************************************************  
* FUNÇÃO 	: ElimRes								  						  *
* OBJETIVO  : REALIZA A ELIMINAÇÃO DE RESÍDUO DO PEDIDO DE VENDA			  *
* AUTOR     : GILBERTO RIBEIRO JUNIOR										  *
* DATA      : 30/03/2015													  *
*---------------------------------ALTERACOES----------------------------------*  
* DATA       AUTOR       OBJETIVO											  *
*----------- ----------- -----------------------------------------------------*  
******************************************************************************/  
Static Function ElimRes (numPedido, numFilial)

	Local cUpdate := ""
	
	cUpdate :=  " UPDATE SC5030 SET " 
	cUpdate += " 	 C5_NOTA  = 'XXXXXXXXX' "
	cUpdate += " 	,C5_SERIE = 'XXX' " 
	cUpdate += " WHERE C5_FILIAL = '" + numFilial + "' "
	cUpdate += "   AND C5_NUM = '" + numPedido + "' "
	cUpdate += "   AND D_E_L_E_T_ = '' "
	
	TCSqlExec(cUpdate)
	
	cUpdate := " UPDATE SC6030 SET "
	cUpdate += "	 C6_BLQ   = 'R' " 
	cUpdate += " WHERE C6_FILIAL = '" + numFilial + "' "
	cUpdate += "   AND C6_NUM = '" + numPedido + "' "
	cUpdate += "   AND C6_QTDENT < C6_QTDVEN " 
	cUpdate += "   AND C6_BLQ = '' "
	cUpdate += "   AND D_E_L_E_T_ = '' "

	TCSqlExec(cUpdate)
	
Return


/*
   	|=================================================================================
   	|   COMENTARIO
   	|---------------------------------------------------------------------------------
   	|		Antes de realizar a Importacao dos Pedidos de Vendas do Portal para o 
   	|	Protheus, sera verificado se existe Saldo Inicial para os Produtos existen-
   	|	tes nos Pedidos. Caso nao haja sera criado antes da Importacao.
   	|
   	|	Edson Hornberger - 16/03/2015
   	|=================================================================================
   	*/

Static Function GerSB2()

	Local CLOCALIZ		:= SuperGetMV("MV_CDENDD",.F.,"EXP")

	Local nRegSB9		:= 0
	Private aItensSB9	:= {}
	Private cFilAtu		:= ""
	Private cFilDes		:= ""
	Private _cQuery 	:= ""

	lMsErroAuto := .F.

	_cQuery := "SELECT DISTINCT  '01' AS FILDES "												 + ENTER
	_cQuery += "				,SC6.C6_PRODUTO AS CODIGO "										 + ENTER
	_cQuery += "				,SC6.C6_LOCAL AS XLOCAL "										 + ENTER
	_cQuery += "				,ISNULL(SB9.B9_COD,'CRIAR') AS STATUS " 	 					 + ENTER
	_cQuery += "FROM SC6030 SC6 "		   			   											 + ENTER
	_cQuery += "INNER JOIN SC5030 SC5 "   			   											 + ENTER
	_cQuery += "   ON SC6.C6_NUM     = SC5.C5_NUM "    											 + ENTER
	_cQuery += "  AND SC6.C6_FILIAL  = SC5.C5_FILIAL " 											 + ENTER
	_cQuery += "  AND SC6.D_E_L_E_T_ = '' "			   											 + ENTER
	_cQuery += "  AND SC5.D_E_L_E_T_ = '' "			   											 + ENTER
	_cQuery += "LEFT OUTER JOIN SB9030 SB9 "													 + ENTER
	_cQuery += "  ON SB9.B9_FILIAL = '01' "														 + ENTER
	_cQuery += " AND SB9.B9_COD = SC6.C6_PRODUTO "												 + ENTER
	_cQuery += " AND SB9.B9_LOCAL IN ('22') "												 + ENTER
	_cQuery += " AND SB9.D_E_L_E_T_ = ''"														 + ENTER
	_cQuery += "WHERE C5_FILIAL = '02'	"	   		   											 + ENTER // SOMENTE FILIAL BARUERI
	_cQuery += "   AND C5_INTER  <> 'S' "		   	   											 + ENTER // DIFERENTE DE INTERCOMPANY
	_cQuery += "   AND C6_LOCAL  IN ('22') "	   		   									 + ENTER // APENAS OS PEDIDOS QUE ESTÃO NO ARMAZÉM 21
	_cQuery += "   AND C6_QTDENT < C6_QTDVEN " 		   											 + ENTER // SALDO DE PEDIDO
	_cQuery += "   AND C6_BLQ    = '' "				   											 + ENTER // SEM ELIMINAÇÃO DE RESÍDUO
	_cQuery += "   AND C6_XITEMC IN ('TAIFF') "		   											 + ENTER // UNIDADE DE NEGÓCIO (TAIFF)
	_cQuery += " UNION ALL "
	_cQuery += "SELECT DISTINCT  '01' AS FILDES "												 + ENTER
	_cQuery += "				,SC6.C6_PRODUTO AS CODIGO "										 + ENTER
	_cQuery += "				,SC6.C6_LOCAL AS LOCAL "										 + ENTER
	_cQuery += "				,ISNULL(SB9.B9_COD,'CRIAR') AS STATUS " 	 					 + ENTER
	_cQuery += "FROM SC6030 SC6 "		   			   											 + ENTER
	_cQuery += "INNER JOIN SC5030 SC5 "   			   											 + ENTER
	_cQuery += "   ON SC6.C6_NUM     = SC5.C5_NUM "    											 + ENTER
	_cQuery += "  AND SC6.C6_FILIAL  = SC5.C5_FILIAL " 											 + ENTER
	_cQuery += "  AND SC6.D_E_L_E_T_ = '' "			   											 + ENTER
	_cQuery += "  AND SC5.D_E_L_E_T_ = '' "			   											 + ENTER
	_cQuery += "LEFT OUTER JOIN SB9030 SB9 "													 + ENTER
	_cQuery += "  ON SB9.B9_FILIAL = '01' "														 + ENTER
	_cQuery += " AND SB9.B9_COD = SC6.C6_PRODUTO "												 + ENTER
	_cQuery += " AND SB9.B9_LOCAL IN ('23') "												 + ENTER
	_cQuery += " AND SB9.D_E_L_E_T_ = ''"														 + ENTER
	_cQuery += "WHERE C5_FILIAL = '02'	"	   		   											 + ENTER // SOMENTE FILIAL BARUERI
	_cQuery += "   AND C5_INTER  <> 'S' "		   	   											 + ENTER // DIFERENTE DE INTERCOMPANY
	_cQuery += "   AND C6_LOCAL  IN ('23') "	   		   									 + ENTER // APENAS OS PEDIDOS QUE ESTÃO NO ARMAZÉM 21
	_cQuery += "   AND C6_QTDENT < C6_QTDVEN " 		   											 + ENTER // SALDO DE PEDIDO
	_cQuery += "   AND C6_BLQ    = '' "				   											 + ENTER // SEM ELIMINAÇÃO DE RESÍDUO
	_cQuery += "   AND C6_XITEMC IN ('PROART') "		   											 + ENTER // UNIDADE DE NEGÓCIO (TAIFF)
	_cQuery += "ORDER BY SC6.C6_PRODUTO " 		   											     + ENTER

	//MemoWrite("TFCopExtrema_QryGerSB2.SQL",_cQuery)

	IF SELECT("TST") > 0
		DBSELECTAREA("TST")
		DBCLOSEAREA()
	ENDIF

	TCQUERY _cQuery NEW ALIAS "TST"
	DBSELECTAREA("TST")

	AITENSSB9 := {}

	WHILE TST->(!EOF())

		IF TST->STATUS = "CRIAR"

			AADD(AITENSSB9,{TST->FILDES,{{"B9_FILIAL",TST->FILDES,NIL},{"B9_COD",TST->CODIGO,NIL},{"B9_LOCAL",TST->XLOCAL,NIL},{"B9_QINI",0,NIL}}})

		ENDIF

		TST->(DBSKIP())

	ENDDO
	IF LEN(AITENSSB9) > 0

		RESET ENVIRONMENT
		RPCSETTYPE ( 3 )
		PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL AITENSSB9[1,1] MODULO "FAT"
		SLEEP(1500)

		FOR NREGSB9 := 1 TO LEN(AITENSSB9)

			BEGIN TRANSACTION

				MSEXECAUTO({|X,Y| MATA220(X,Y)},AITENSSB9[NREGSB9,2],3)

				IF LMSERROAUTO

					DISARMTRANSACTION()
					MSGALERT(OEMTOANSI(	"Erro ao tentar gerar Saldo Inicial para Produtos!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
					MOSTRAERRO()

				ELSE

					/*
					|---------------------------------------------------------------------------------
					|	CRIA SALDO INICIAL POR ENDERECO
					|---------------------------------------------------------------------------------
					*/

					If LOCALIZA(AITENSSB9[NREGSB9,2,2,2])
						DBSELECTAREA("SBK")

						RECLOCK("SBK",.T.)
						SBK->BK_FILIAL 	:= "01"
						SBK->BK_COD 	:= AITENSSB9[NREGSB9,2,2,2]
						SBK->BK_LOCAL	:= AITENSSB9[NREGSB9,2,3,2]
						SBK->BK_QINI	:= 0
						SBK->BK_LOCALIZ	:= CLOCALIZ
						MSUNLOCK()
					EndIf
				ENDIF

				LMSERROAUTO := .F.

			END TRANSACTION

		NEXT NREGSB9

		RESET ENVIRONMENT
		RPCSETTYPE ( 3 )
		PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL CFILANT MODULO "FAT"
		SLEEP(1500)

		lMsErroAuto := .F.

	ENDIF

	IF SELECT("TST") > 0
		DBSELECTAREA("TST")
		DBCLOSEAREA()
	ENDIF

Return
