#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPORDEM º Autor ³ Gilberto Ribeiro Jr  ºData ³ 31/07/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao das Ordens de Serviço do Portal da Assistência  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Por Menu ou por JOB (U_IMPORDEM())                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  *********     DOCUMENTACAO DE MANUTENCAO DO PROGRAMA     *********   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºConsultor ³   Data   ³ Hora  ³ Detalhes da Alteracao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPORDEM()
	Local oObj
	Local cSemaforo := AllTrim(cEmpAnt) + xFilial("SA1") + FunName()
	
	Private _sNomeBanco	 := GetMV("MV_BDASSTE") // Banco de Dados do Portal da Assistencia (PORTAL_ASSTEC)
	Private _sPermiteImp := GetMV("MV_IMPASTE") // Verifica se é permitido executar a rotina IMPASSTEC na Empresa/Filial
	PRIVATE CIMPVENDAS	:= GetMV("MV__FTMI0T") // Importa pedidos de vendas
	
	DEFAULT cEmpSch := "03"
	DEFAULT cFilialSch := "01"
	DEFAULT cMarcaSch := "TAIFF"

	If Select("SX6") == 0
		cCabEmail := " Empresa/Filial: " + cEmpSch + "/" + cFilialSch + " da Marca " + cMarcaSch

		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"

		lImporta := Iif(GetMV("MV__FTMIOS")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		IF CIMPVENDAS = "S"
			lImporta := .T.
		ENDIF

		If !lImporta

			PutMv("MV__FTMIOS","S")

			lWeb := .T.

			Processar()

			PutMv("MV__FTMIOS","N")

		EndIf
		RESET ENVIRONMENT
	Else
		If LockByName(cSemaforo,.T.,.T.,.T.) == .F.
			Msgstop("Processo sendo executado por outro usuário, tente mais tarde.")
			Return Nil
		EndIf
		
		If _sNomeBanco == "" 
			alert("Parâmetro MV_BDASSTE não foi criado para esta Empresa/Filial.")
			return
		EndIf
		
		If _sPermiteImp == "" 
			alert("Parâmetro MV_IMPASTE não foi criado para esta Empresa/Filial.")
			return
		EndIf

		// Caso a importação de pedidos de vendas estiver em progresso a integração das ordens será no próximo ciclo.
		IF CIMPVENDAS = "S"
			ConOut("Importação de pedidos de vendas em progresso!!")
			RETURN
		ENDIF

		If MsgYesNo("Inicia importacao das Ordens de Serviço do Portal da Assistência Técnica?")
			oObj := MsNewProcess():New({|lEnd| Processar(oObj, @lEnd)}, "", "", .T.)
			oObj :Activate()
		EndIf
		
		UnLockByName(cSemaforo,.T.,.T.,.T.)
	ENDIF	
Return Nil

Static Function Processar(oObj, lEnd)
	Local _dataImp 		:= STOD(STR(YEAR(date()), 4) + STR(MONTH(date()), 2) + STR(DAY(date()), 2))
	Local _horaImp 		:= REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
	Local _aCab			:= {}
	Local _aItens		:= {}
	Local _cQuery		:= ""
	Local _cPSC6		:= ""
	Local _nRec 		:= 0
	Local _nProc		:= 1
	Local _nProc2		:= 1
	Local _nOK			:= 0
	Local _nErro		:= 0
	Local _cOper		:= ""
	Local _vClasPed   	:= "A" // Classificação do Pedido da Assitência
	Local _numPed		:= ""
	LOCAL cIDPosto		:= ""		
	LOCAL NITELOOP		:= 0
	LOCAL _aOSItens		:= {}
	LOCAL cC5XNUMOLD	:= ""

	Default lEnd 		:= .F. 
	Private lWeb		:= .F. // CONTROLA SE ESTA SENDO EXECUTADO PELO SCHEDULE
	Private _cPSC5		:= ""
	
	lMsErroAuto := .F.
   
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SELECIONA INFORMAÇÕES DAS ORDENS DE SERVIÇO PARA IMPORTAÇÃO				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT  ORD.ORD_FILIAL AS ORD_FILIAL, " + ENTER  
	_cQuery += " CAST(ORD.ORD_ID AS VARCHAR(6)) AS ORD_ID, " + ENTER
	_cQuery += " 'N' AS ORD_TIPO, " + ENTER
	_cQuery += " ORD.SA1_CLIENTE AS ORD_CLIENTE, " + ENTER
	_cQuery += " ORD.SA1_LOJA AS ORD_LOJA, " + ENTER
	_cQuery += " ORD.SA1_CLIENTE AS ORD_CLIENT, " + ENTER
	_cQuery += " ORD.SA1_LOJA AS ORD_LOJAENT, " + ENTER
	_cQuery += " ISNULL(ORD.SA4_COD, '') AS ORD_TRANSP, " + ENTER
	_cQuery += " ORD.ORD_TP_CLIENTE AS ORD_TIPOCLI, " + ENTER
	_cQuery += " ORD.SE4_CODIGO AS ORD_CONDPAG, " + ENTER 
	_cQuery += " ORD.ORD_COD_TABELA AS ORD_TABELA, " + ENTER
	_cQuery += " ORD.ORD_MEN_NF AS ORD_MENNOTA, " + ENTER
	_cQuery += " ORD.ORD_OBSERVACAO AS ORD_OBSERVA, " + ENTER
	_cQuery += " ISNULL(ORD.ORD_FAT_FRAC, '') AS ORD_FATFRAC, " + ENTER
	_cQuery += " ISNULL(ORD.ORD_FAT_PARC, '') AS ORD_FATPARC, " + ENTER  
	_cQuery += " ISNULL(ORD.ORD_COD_VENDEDOR, '') AS ORD_VEND1, " + ENTER
	_cQuery += " 0 AS ORD_DESC1, " + ENTER
	_cQuery += " CAST(CONVERT(VARCHAR(8),ORD.ORD_DT_EMISSAO , 112) AS VARCHAR(8)) ORD_EMISSAO, " + ENTER
	_cQuery += " ORD.ORD_TP_FRETE AS ORD_TPFRETE, " + ENTER
	_cQuery += " 0 AS ORD_FRETE, " + ENTER
	_cQuery += " 0 AS ORD_PCFRETE, " + ENTER
	_cQuery += " 1 AS ORD_MOEDA, " + ENTER
	_cQuery += " 0 AS ORD_PESOL, " + ENTER
	_cQuery += " 0 AS ORD_PBRUTO, " + ENTER
	_cQuery += " 0 AS ORD_VOLUME1, " + ENTER
	_cQuery += " 'CAIXA' AS ORD_ESPECI1, " + ENTER
	_cQuery += " 'N' AS ORD_INCISS, " + ENTER
	_cQuery += " '1' AS ORD_TIPLIB, " + ENTER
	_cQuery += " ISNULL(ORD.ORD_DT_APROVADO, '') AS ORD_DTAPPO, " + ENTER
	_cQuery += " ISNULL(ORD.ORD_HR_APROVADO, '') AS ORD_HRAPPO, " + ENTER
	_cQuery += " '34' AS ORD_OPER, " + ENTER  // TIPO DE OPERAÇÃO (34 = REMESSA EM GARANTIA)
	_cQuery += " ORD.ORD_UNID_NEGOCIO AS ORD_ITEMC, " + ENTER  // UNIDADE DE NEGÓCIO
	_cQuery += " ORD.ORD_COD_EMP AS ORD_EMPDES, " + ENTER  // EMPRESA DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)
	_cQuery += " ORD.ORD_COD_FIL AS ORD_FILDES " + ENTER  // FILIAL DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)

	_cQuery += " FROM " + _sNomeBanco + "ORDEM_SERVICO ORD " + ENTER

	_cQuery += " WHERE ISNULL(ORD.D_E_L_E_T_, '') = '' " + ENTER
	_cQuery += "   AND ORD.ORD_STATUS = '8' " + ENTER
	_cQuery += "   AND ORD.ORD_ST_IMPORTADO = '' " + ENTER
	_cQuery += "   AND ORD.ORD_CHK_SOMENTE_MO = 'N' " + ENTER // ORD_CHK_SOMENTE_MO = N (SOMENTE OS QUE TEM ITENS)
	_cQuery += "   AND ORD_DT_EMISSAO >= '20210101' " + ENTER // Não considera pedidos inferiores a 2021
	//_cQuery += "   AND ORD_ID IN (32,38,119) " + ENTER
	_cQuery += " ORDER BY SA1_CLIENTE, SA1_LOJA ,ORD.ORD_ID  " + ENTER

	_cQuery := ChangeQuery( _cQuery )
	//MemoWrite("IMPORDEM-LE_ORDENS_SERVICO.sql",_cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC5 := GetNextAlias()), .F., .T.)
    
    COUNT TO _nRec
	
	If !lWeb
		oObj:SetRegua1(_nRec)
	EndIf

    (_cPSC5)->(dbGoTop())
 
    While !(_cPSC5)->(EOF())
	
		If !lWeb
			oObj:IncRegua1("Processando Ordem de Serviço " + Alltrim(Str(_nProc))+ " de " + Alltrim(Str(_nRec)) + " encontrados.")
		EndIf
		
		lMsErroAuto := .F.
		
		_aItens  := {}
        
        __cXNUMOLD := Alltrim((_cPSC5)->ORD_ID) + "OS" // NumOld fica com (OS) no final, para saberem que são Ordens de Serviço da Assistência Técnica
		cC5XNUMOLD	:= __cXNUMOLD

		// Monta Array Cabecalho do Pedido de Venda
		aAdd(_aCab,{"C5_TIPO"		,(_cPSC5)->ORD_TIPO  					,nil}) // Tipo de Pedido          
		aAdd(_aCab,{"C5_CLIENTE"	,(_cPSC5)->ORD_CLIENTE  	 			,nil}) // Codigo de Cliente      
		aAdd(_aCab,{"C5_LOJACLI"	,(_cPSC5)->ORD_LOJA  	 				,nil}) // Loja do Cliente         
		aAdd(_aCab,{"C5_LOJAENT"	,(_cPSC5)->ORD_LOJAENT  	 			,nil}) // Loja do Entrega 
		aAdd(_aCab,{"C5_CLIENT"  	,(_cPSC5)->ORD_CLIENT      				,nil}) // Cliente Entrega            
		aAdd(_aCab,{"C5_TRANSP"  	,(_cPSC5)->ORD_TRANSP      				,nil}) // Transportadora                 
		aAdd(_aCab,{"C5_TABELA"		,(_cPSC5)->ORD_TABELA 	 				,nil}) // Tabela de precos  
		aAdd(_aCab,{"C5_CONDPAG"	,(_cPSC5)->ORD_CONDPAG     				,nil}) // Condicao de Pagto.
		aAdd(_aCab,{"C5_XLIBCR"  	,"P"							      	,nil}) // Libaração de Crédito                 
		aAdd(_aCab,{"C5_MENNOTA" 	,AllTrim((_cPSC5)->ORD_MENNOTA)     	,nil}) // Mensagem da Nota Fiscal                 
		//aAdd(_aCab,{"C5_MENPAD"  	,(_cPSC5)->C5_MENPAD      				,nil}) // Mensa                 
		//aAdd(_aCab,{"C5_FINALID" 	,(_cPSC5)->C5_FINALID     				,nil}) // Finalidade                 
		aAdd(_aCab,{"C5_FATFRAC" 	,(_cPSC5)->ORD_FATFRAC     				,nil}) // Fatura fracionado
		aAdd(_aCab,{"C5_FATPARC" 	,(_cPSC5)->ORD_FATPARC     				,nil}) // Fatura Parcial                 
		aAdd(_aCab,{"C5_INTER"   	,"N"				       				,nil}) // InterCompany                 
		//aAdd(_aCab,{"C5_TFBONIF" 	,(_cPSC5)->C5_TFBONIF	 				,nil}) //                  
		aAdd(_aCab,{"C5_TPFRETE"	,(_cPSC5)->ORD_TPFRETE 	 				,nil}) // Tipo de frete     
		aAdd(_aCab,{"C5_CLASPED"	,_vClasPed		 	 					,nil}) // Classificação do Pedido  
		aAdd(_aCab,{"C5_TIPOCLI"	,(_cPSC5)->ORD_TIPOCLI	 				,nil}) // Tipo de Cliente   
		aAdd(_aCab,{"C5_EMISSAO"	,DDATABASE					 			,nil}) // Data de Emissao   
		aAdd(_aCab,{"C5_NUMOLD"		,__cXNUMOLD			 					,nil}) // Ordem de Serviço
		aAdd(_aCab,{"C5_FRETE"   	,(_cPSC5)->ORD_FRETE		 			,nil}) // Frete  
		aAdd(_aCab,{"C5_VEND1"		,(_cPSC5)->ORD_VEND1		 			,nil}) // Vendedor  
		aAdd(_aCab,{"C5_COMIS1"		,0										,nil}) // Comissão 
		aAdd(_aCab,{"C5_PESOL"		,(_cPSC5)->ORD_PESOL		 			,nil}) // Peso Liquido  
		aAdd(_aCab,{"C5_PBRUTO"		,(_cPSC5)->ORD_PBRUTO					,nil}) // Peso Bruto  
		aAdd(_aCab,{"C5_VOLUME1"	,(_cPSC5)->ORD_VOLUME1	 				,nil}) // Volume  
		aAdd(_aCab,{"C5_ESPECI1"	,(_cPSC5)->ORD_ESPECI1	 				,nil}) // Espécie  
		aAdd(_aCab,{"C5_OBSERVA"	,AllTrim((_cPSC5)->ORD_OBSERVA)	 		,nil}) // Observação   
		aAdd(_aCab,{"C5_DTAPPO"		,STOD((_cPSC5)->ORD_DTAPPO)				,nil}) // Data da aprovação do pedido no Portal
		aAdd(_aCab,{"C5_HRAPPO"		,(_cPSC5)->ORD_HRAPPO					,nil}) // Hora da aprovação do pedido no Portal
		aAdd(_aCab,{"C5_DTIMP"		,_dataImp		 						,nil}) // Data da importação do pedido para o Protheus
		aAdd(_aCab,{"C5_HRIMP"		,_horaImp		 						,nil}) // Hora da importação do pedido para o Protheus   
		aAdd(_aCab,{"C5_PCFRETE"	,(_cPSC5)->ORD_PCFRETE	 				,nil}) // Percentual de Frete
		aAdd(_aCab,{"C5_XITEMC"		,(_cPSC5)->ORD_ITEMC					,nil}) // Linha de Unidade de Negocio	
		aAdd(_aCab,{"C5_EMPDES"		,(_cPSC5)->ORD_EMPDES 					,nil}) // Empresa Destino (03 - TaiffProart)
		aAdd(_aCab,{"C5_FILDES"		,(_cPSC5)->ORD_FILDES 					,nil}) // Filial Destino  (01 - TaiffProart Matriz)  
		aAdd(_aCab,{"C5_TIPLIB"		,(_cPSC5)->ORD_TIPLIB 					,nil}) // Tipo de Liberação
		aAdd(_aCab,{"C5_MOEDA"		,(_cPSC5)->ORD_MOEDA 					,nil}) // Moeda
		aAdd(_aCab,{"C5_TPCARGA"	,"1"				 					,nil}) // Tipo de Carga

		_aOSItens	:= {}

		cIDPosto := (_cPSC5)->ORD_CLIENTE + (_cPSC5)->ORD_LOJA
		While .NOT. (_cPSC5)->(Eof()) .AND. (_cPSC5)->ORD_CLIENTE + (_cPSC5)->ORD_LOJA = cIDPosto

	        __cXNUMOLD := Alltrim((_cPSC5)->ORD_ID) + "OS" // NumOld fica com (OS) no final, para saberem que são Ordens de Serviço da Assistência Técnica

			//Faz consulta dos Itens do pedido no portal do representante.
			_cQuery := "SELECT * " + ENTER 
			_cQuery += "FROM " + _sNomeBanco + "ITEM_ORDEM_SERVICO IOS " + ENTER
			_cQuery += "WHERE ORD_ID = '" + (_cPSC5)->ORD_ID + "' " + ENTER
			_cQuery += "  AND ISNULL(IOS.D_E_L_E_T_, '') = '' " + ENTER
			_cQuery += "ORDER BY IOS.ORD_ID, IOS.IOS_ITEM " + ENTER
			_cQuery := ChangeQuery( _cQuery )
			
			//MemoWrite("IMPORDEM-LE_ITENS_ORDENS_SERVICO.sql",_cQuery)
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC6 := GetNextAlias()), .F., .T.)

			COUNT TO _nRec2
			
			If !lWeb
				oObj:SetRegua2(_nRec2)
			EndIf
			
			_nProc2		:= 1
			
			(_cPSC6)->(dbGoTop())

			While !(_cPSC6)->(EOF())

				aLinha	:= {}
				
				If !lWeb
					oObj:IncRegua2("Processando item " + Alltrim(Str(_nProc2)) + " de " + Alltrim(Str(_nRec2)) + " itens.")
				EndIf
		
				_cOper := (_cPSC6)->IOS_OPERACAO                                                                               
			
				// Está atribuindo, mas no momento da inclusão o TES é substituido
				cTES := "801" //MaTesInt(2, _cOper, (_cPSC5)->ORD_CLIENTE, (_cPSC5)->ORD_LOJA, "C", PadR((_cPSC6)->SB1_COD_COMP, 15))
			
				//alert("TES: " + cTES)
					
				aAdd(aLinha, {"C6_ITEM   "		,(_cPSC6)->IOS_ITEM   				,Nil})
				aAdd(aLinha, {"C6_PRODUTO"		,(_cPSC6)->SB1_COD_COMP				,Nil})
				aAdd(aLinha, {"C6_DESCRI"		,(_cPSC6)->SB1_DESC_COMP			,Nil})
				aAdd(aLinha, {"C6_UM     "		,"PC"			     				,Nil})
				aAdd(aLinha, {"C6_QTDVEN "		,(_cPSC6)->IOS_QTD_COMP		  		,Nil})
				aAdd(aLinha, {"C6_QTDENT "		,0									,Nil})
				aAdd(aLinha, {"C6_QTDENT2"		,0									,Nil})
				aAdd(aLinha, {"C6_QTDLIB"		,0									,Nil})
				aAdd(aLinha, {"C6_QTDEMP"		,0									,Nil})
				aAdd(aLinha, {"C6_PRCVEN "		,(_cPSC6)->IOS_VAL_DESCONTO			,Nil})
				aAdd(aLinha, {"C6_TES    "		,cTES		    					,Nil})
				aAdd(aLinha, {"C6_LOCAL  "		,(_cPSC6)->IOS_LOCAL				,Nil})
				aAdd(aLinha, {"C6_CLI    "		,(_cPSC5)->ORD_CLIENTE				,Nil})
				aAdd(aLinha, {"C6_LOJA   "		,(_cPSC5)->ORD_LOJA					,Nil})
				aAdd(aLinha, {"C6_ENTREG "		,STOD((_cPSC5)->ORD_EMISSAO)		,Nil})
				aAdd(aLinha, {"C6_COMIS1 "		,0				 					,Nil})
				aAdd(aLinha, {"C6_PRUNIT "		,(_cPSC6)->IOS_PRC_COMP 			,Nil})
				aAdd(aLinha, {"C6_REAJIPI"		,"S"								,Nil})
				aAdd(aLinha, {"C6_OPER"			,_cOper								,Nil})
				aAdd(aLinha, {"C6_XOPER"		,_cOper								,Nil})
				aAdd(aLinha, {"C6_XITEMC "		,(_cPSC6)->IOS_UNID_NEGOCIO 		,Nil})			
				aAdd(aLinha, {"C6_XNUMOS"		,__cXNUMOLD					 		,Nil})
			
				aAdd(_aItens, aLinha)
				
				AADD(_aOSItens,__cXNUMOLD)
				_nProc2 ++

				(_cPSC6)->(dbSkip())

			EndDo

			If lEnd //Processo Cancelado pelo Usuário
				Exit
			EndIf

			_nProc++
			
			(_cPSC5)->(dbSkip())
		
		END		
		If !lWeb
			oObj:SetRegua2(1)
			oObj:IncRegua2("Finalizando gravação dos itens.")
		EndIf

		BEGIN TRANSACTION
		
			MSExecAuto({|x,y,z| mata410(x,y,z)}, _aCab, _aItens, 3) //Inclusão
			
			If lMsErroAuto 
				mostraerro()
				_nErro++
			Else
				_numPed := U_RetNumPed(cC5XNUMOLD) //Obtém o código da Ordem de Serviço do Portal
				//alert(_numPed)
				If Select("SX6") == 0
					U_FATMI002(2, _numPed, "N") //Avalia o Crédito e já efetua a Liberação/Bloqueio, dependendo da situação do Cliente
				ENDIF
				FOR NITELOOP := 1 TO LEN(_aOSItens)
					CC6XNUMOS := _aOSItens[NITELOOP]
					AtuStatusAT( CC6XNUMOS , _sNomeBanco, _numPed) //Grava OK na Importação
				NEXT

				_nOK++
			Endif

		END TRANSACTION
		
	EndDo    
  
  	If !lWeb
		Msgstop("Foram importadas " + ALLTRIM(STR(_nOK)) + " Ordens de Serviço. " + ALLTRIM(STR(_nErro)) + " Ordens de Serviço apresentaram erros.")
	End
  
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPORDEM ºAutor  ³Gilberto Ribeiro Jr º Data ³  16/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuStatusAT(_cNumOS, _sNomeBanco ,COSPEDIDO)

	Local _cQuery := ""

	PEDVERSUSOS( COSPEDIDO ,_cNumOS )

	If At("OS", _cNumOS) != 0
		_cNumOS := Stuff(_cNumOS, At("OS", _cNumOS), 2, "")
	EndIf
	
	_cQuery   := "UPDATE " + _sNomeBanco + "ORDEM_SERVICO SET "		
	_cQuery   += "  ORD_STATUS  	   = '1', "
	_cQuery   += "  ORD_ST_IMPORTADO   = 'I', "
	_cQuery   += "  ORD_DT_IMPORTADO   = '" + STRZERO(YEAR(date()),4, 0) + STRZERO(MONTH(date()),2, 0) + STRZERO(DAY(date()),2, 0) + "', "
	_cQuery   += "  ORD_HR_IMPORTADO   = '" + REPLACE(SUBSTRING( time() , 1,5 ), ":", "") + "' "
	_cQuery   += "WHERE ORD_ID = '" + _cNumOS + "'"
	
	//MemoWrite("IMPORDEM-ORDENS_SERVICO_GRAVAOK.sql",_cQuery)
	TCSQLExec(_cQuery)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetNumPed  ºAutor  ³Gilberto Ribeiro Jrº Data ³  18/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o Número do Pedido com base no número da OS		  º±±
±±º          ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RetNumPed(_numOld)
	
	Local numPed 
	Local aliasSC5 := GETNEXTALIAS()
	
	BeginSql alias aliasSC5
		SELECT SC5.C5_NUM AS NUM
		FROM %table:SC5% SC5
		WHERE SC5.C5_FILIAL= %xfilial:SC5%
		  AND SC5.C5_NUMOLD = %exp:_numOld% 
		  AND SC5.%NotDel%
	EndSql

	// Número do Orçamento não foi encontrado
	If (aliasSC5)->(Eof())
		(aliasSC5)->(DbCloseArea())
		Return
	EndIf

	numPed := (aliasSC5)->NUM
	
	(aliasSC5)->(DbCloseArea())

Return numPed	

//
// Registra em tabela a amarração do pedido de venda protheus e suas ordens de serviço
//
STATIC FUNCTION PEDVERSUSOS(COSPEDIDO,COSID_PORTAL)
LOCAL CQUERY
	
	CQUERY := "BEGIN TRAN" 															+ ENTER 
	CQUERY += "	INSERT INTO" 														+ ENTER 
	CQUERY += "		TBL_PEDIDOS_OS_ASTEC (C5_NUM,C6_XNUMOS,D_E_L_E_T_) "			+ ENTER
	CQUERY += "	VALUES" 															+ ENTER
	CQUERY += "			(" 															+ ENTER
	CQUERY += "				'" + COSPEDIDO + "'," 									+ ENTER
	CQUERY += "				'" + COSID_PORTAL + "',"	 							+ ENTER 
	CQUERY += "				' '"					 								+ ENTER 
	CQUERY += "			)"															+ ENTER 
	CQUERY += "IF @@ERROR <> 0 ROLLBACK ELSE COMMIT"
	
	//MemoWrite("IMPORDEM-GRAVA_LOG.sql",CQUERY)

	IF TCSQLEXEC(CQUERY) < 0 
		
		CONOUT(OEMTOANSI("Erro ao tentar Inserir registro na Tabela Pedidos versus ordens de serviço") + ENTER + "FONTE: IMPORDEM.PRW LINHA: " + ALLTRIM(STR(PROCLINE())))
		
	ENDIF
	
	
RETURN
