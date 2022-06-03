#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
************************************************************************************************************************************
************************************************************************************************************************************
*** Programa: IMPASSTEC * Autor: Gilberto Ribeiro Jr * Data: 07/10/15   ***
************************************************************************************************************************************
*** Desc: Realiza Importação dos Pedidos do Portal da Assistência Técnica
************************************************************************************************************************************
*/

User Function IMPASSTEC(cEmpSch,cFilialSch,cMarcaSch)

	Local oObj
	Local lEnd				:= .F.
	//Local aRet 	     		:= {}
	Local lImporta			:= ""
	Private lWeb	:= .F.		//CONTROLA SE ESTA SENDO EXECUTADO PELO SCHEDULE
	Public _sNomeBanco		:= "" // Banco de Dados do Portal da Assistencia (PORTAL_ASSTEC)
	Public _sPermiteImp		:= "" // Verifica se Ã© permitido executar a rotina IMPASSTEC na Empresa/Filial

	DEFAULT cEmpSch := "03"
	DEFAULT cFilialSch := "01"
	DEFAULT cMarcaSch := "TAIFF"

	If Select("SX6") == 0

		cCabEmail := " Empresa/Filial: " + cEmpSch + "/" + cFilialSch + " da Marca " + cMarcaSch

		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"

		lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		_sNomeBanco		:= GetMV("MV_BDASSTE") // Banco de Dados do Portal da Assistencia (PORTAL_ASSTEC)
		_sPermiteImp		:= GetMV("MV_IMPASTE") // Verifica se Ã© permitido executar a rotina IMPASSTEC na Empresa/Filial

		If !lImporta

			PutMv("MV__FTMI0T","S")

			cSemaforo := AllTrim(cEmpAnt) + xFilial("SA1") + FunName() + LEFT(cMarcaSch,1)
			lWeb := .T.
			_aNomeBanco	:= StrTokArr(GETMV("PRT_SEP000"), "/")
			cUnidNeg		:= SuperGetMV("MV_UNIDNEG", .F., "")

			titulo      	:= "IMPASSTEC - Inicio Importação Orçamento ASTEC Empresa " + AllTrim(SM0->M0_NOME) + "/" + SM0->M0_FILIAL

			Processar()

			titulo      	:= "IMPASSTEC - Fim da Importação Orçamento ASTEC Empresa " + AllTrim(SM0->M0_NOME) + "/" + ALLTRIM(SM0->M0_FILIAL)
			PutMv("MV__FTMI0T","N")

		EndIf
		RESET ENVIRONMENT
	Else
		_sNomeBanco		:= GetMV("MV_BDASSTE") // Banco de Dados do Portal da Assistencia (PORTAL_ASSTEC)
		_sPermiteImp		:= GetMV("MV_IMPASTE") // Verifica se Ã© permitido executar a rotina IMPASSTEC na Empresa/Filial
		If _sNomeBanco == ""
			alert("Parâmetro MV_BDASSTE não foi criado para esta Empresa/Filial.")
			return
		EndIf

		If _sPermiteImp == ""
			alert("Parâmetro MV_IMPASTE não foi criado para esta Empresa/Filial.")
			return
		EndIf

		If (cEmpAnt+cFilAnt) $ _sPermiteImp
			If MsgYesNo("Inicia importação dos pedidos do Portal da Assitência Técnica?")
				lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				If lImporta
					Msgstop("Rotina de importação orçamentos já esta sendo executada, tente mais tarde.")
					Return
				Else
					PutMv("MV__FTMI0T","S")
					oObj := MsNewProcess():New({|lEnd| Processar(oObj, @lEnd)}, "", "", .T.)
					oObj :Activate()
				EndIf
			EndIf
			PutMv("MV__FTMI0T","N")
		Else
			Msgstop("Processo não permitido nesta empresa.")
			Return
		EndIf
	EndIf
Return

/*
************************************************************************************************************************************
************************************************************************************************************************************
*** Programa: IMPASSTEC * Autor: Gilberto Ribeiro Jr * Data: 07/10/15   ***
************************************************************************************************************************************
*** Desc:
************************************************************************************************************************************
*/

Static Function Processar(oObj, lEnd)

	Local _dataImp 		:= STOD(STR(YEAR(date()), 4) + STR(MONTH(date()), 2) + STR(DAY(date()), 2))
	Local _horaImp 		:= REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
	Local _aCab			:= {}
	Local _aItens		:= {}
	Local _aItAux		:= {}
	//Local _nOpc			:= 3
	Local _cQuery		:= ""
	//Local _cPSC5		:= ""
	Local _cPSC6		:= ""
	Local _nRec 		:= 0
	Local _nProc		:= 1
	Local _nProc2		:= 1
	Local _nOK			:= 0
	Local _nErro		:= 0
	//Local _cAlias		:= ""
	//Local _cChave		:= ""
	//Local _dDtIni		:= ""
	//Local _cHrIni		:= ""
	//Local _cDtFim		:= ""
	//Local _cHrFim		:= ""
	//Local _cCodUser		:= ""
	//Local _cEstacao		:= ""
	//Local _cOperac		:= ""
	//Local _cOrcament	:= ""
	Local _cOper		:= ""
	Local _vClasPed   	:= "A" // Classificação do Pedido da Assistência
	Local _numOrc		:= ""
	Local cMensImp		:= ""
	Local cMensErr		:= ""
	//Local nTotalPed		:= 0
	//Local nTotGeral		:= 0
	LOCAL cListEmail	:= Alltrim(GetNewPar("TF_MAILTEC","grp_sistemas@taiffproart.com.br;marta.sakamoto@taiff.com.br;pedido.assistenciatecnica@taiff.com.br"))

	Default lEnd 		:= .F.
	Private _cPSC5		:= ""

	lMsErroAuto := .F.

	//************************************************************************************************************************************
	//* SELECIONA INFORMAÇÕES DOS PEDIDOS PENDENTES DE IMPORTAÇÃO DO PORTAL DA ASSISTÊNCIA TÉCNICA 										 *
	//************************************************************************************************************************************
	_cQuery := " SELECT  SC5.C5_FILIAL AS C5_FILIAL, " + ENTER
	_cQuery += " CAST(SC5.C5_NUMPRE AS VARCHAR(6)) AS C5_NUMPRE, " + ENTER
	_cQuery += " SC5.C5_TIPO AS C5_TIPO, " + ENTER
	_cQuery += " SC5.C5_CLIENTE AS C5_CLIENTE, " + ENTER
	_cQuery += " SC5.C5_LOJACLI AS C5_LOJACLI, " + ENTER
	_cQuery += " ISNULL(SC5.C5_CLIENTE,'')  AS C5_CLIENT, " + ENTER
	_cQuery += " ISNULL(SC5.C5_LOJACLI,'') AS C5_LOJAENT, " + ENTER
	_cQuery += " ISNULL(SC5.C5_TRANSP,'') AS C5_TRANSP, " + ENTER
	_cQuery += " SC5.C5_TIPOCLI AS C5_TIPOCLI, " + ENTER
	_cQuery += " SC5.C5_CONDPAG AS C5_CONDPAG, " + ENTER
	_cQuery += " SC5.C5_TABELA AS C5_TABELA, " + ENTER
	_cQuery += " ISNULL(SC5.C5_FATFRAC, '') AS C5_FATFRAC, " + ENTER
	_cQuery += " ISNULL(SC5.C5_FATPARC, '') AS C5_FATPARC, " + ENTER
	_cQuery += " ISNULL(SC5.C5_VEND1, '') AS C5_VEND1, " + ENTER
	_cQuery += " ISNULL(SC5.C5_DESC1, 0) AS C5_DESC1, " + ENTER
	_cQuery += " CAST(CONVERT(VARCHAR(8),SC5.C5_EMISSAO , 112) AS VARCHAR(8)) C5_EMISSAO, " + ENTER
	_cQuery += " SC5.C5_TPFRETE AS C5_TPFRETE, " + ENTER
	_cQuery += " CAST(ISNULL(SC5.C5_FRETE, 0) AS FLOAT) AS C5_FRETE, " + ENTER
	_cQuery += " 1 AS C5_MOEDA, " + ENTER
	_cQuery += " 0 AS C5_PESOL, " + ENTER
	_cQuery += " 0 AS C5_PBRUTO, " + ENTER
	_cQuery += " 0 AS C5_VOLUME1, " + ENTER
	_cQuery += " 'CAIXA' AS C5_ESPECI1, " + ENTER
	_cQuery += " 'N' AS C5_INCISS, " + ENTER
	_cQuery += " '1' AS C5_TIPLIB, " + ENTER
	_cQuery += " ISNULL(SC5.C5_DTPEDPR, '') AS C5_DTPEDPR, " + ENTER
	_cQuery += " ISNULL(SC5.C5_DTAPPO, '') AS C5_DTAPPO, " + ENTER
	_cQuery += " ISNULL(SC5.C5_HRAPPO, '') AS C5_HRAPPO, " + ENTER
	_cQuery += " SC5.C5_OPER AS C5_OPER, " + ENTER  // TIPO DE OPERAÇÃO (V3 = VENDAS / V5 = BONIFICAÇÃO)
	_cQuery += " SC5.C5_XITEMC AS C5_XITEMC, " + ENTER  // UNIDADE DE NEGÓCIO
	_cQuery += " SC5.C5_EMPDES AS C5_EMPDES, " + ENTER  // EMPRESA DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)
	_cQuery += " SC5.C5_FILDES AS C5_FILDES, " + ENTER  // FILIAL DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)
	_cQuery += " SC5.C5_MENNOTA AS C5_MENNOTA, " + ENTER
	_cQuery += " SC5.C5_OBSERVA AS C5_OBSERVA " + ENTER

	_cQuery += " FROM " + _sNomeBanco + "SC5   " + ENTER

	_cQuery += " WHERE ISNULL(SC5.D_E_L_E_T_, '') = '' " + ENTER
	_cQuery += "   AND ISNULL(SC5.C5_IMP_PED, '') = '' " + ENTER
	_cQuery += "   AND SC5.C5_STSPED = '8' " + ENTER
	//_cQuery += " AND SC5.C5_NUMPRE IN (004378 , 004379)  " + ENTER
	_cQuery += " ORDER BY SC5.C5_NUMPRE  " + ENTER

	_cQuery := ChangeQuery( _cQuery )
	//MemoWrite("FATMI001-LEPEDIDOS_ASSTEC.sql",_cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC5 := GetNextAlias()), .F., .T.)

	COUNT TO _nRec
	If !lWeb
		oObj:SetRegua1(_nRec)
	EndIf
	(_cPSC5)->(dbGoTop())

	While !(_cPSC5)->(EOF())

		If !lWeb
			oObj:IncRegua1("Processando pedido "+Alltrim(Str(_nProc))+ " de " + Alltrim(Str(_nRec)) + " encontrados.")
		EndIf
		lMsErroAuto := .F.
		_aItens  := {}

		__cXNUMOLD := Alltrim((_cPSC5)->C5_NUMPRE) + _vClasPed // NumOld fica com um (A) no final, para saberem que são pedidos da Assistência Técnica

		_aCab :={{"CJ_CLIENTE"	,(_cPSC5)->C5_CLIENTE				, NIL},;  // Codigo do cliente
		{"CJ_LOJA"		,(_cPSC5)->C5_LOJACLI       		, Nil},;  // Loja do cliente
		{"CJ_CLIENT"	,IIF(Empty((_cPSC5)->C5_CLIENT)		, (_cPSC5)->C5_CLIENTE, (_cPSC5)->C5_CLIENT), NIL},;  // Se nÃ£o tiver cliente de Entrega preenche com o cliente
		{"CJ_LOJENT"	,IIF(Empty((_cPSC5)->C5_LOJAENT) 	, (_cPSC5)->C5_LOJACLI, (_cPSC5)->C5_LOJAENT), NIL},; // Loja para entrada Entrega
		{"CJ_CONDPAG"	,(_cPSC5)->C5_CONDPAG     			, Nil},;  // Codigo da condicao de pagamanto*
		{"CJ_XTIPCLI"	,(_cPSC5)->C5_TIPOCLI        		, Nil},;  // Tipo de Cliente
		{"CJ_XTIPO"	,(_cPSC5)->C5_TIPO					, Nil},;  // Tipo de pedido
		{"CJ_DESC1"  	,(_cPSC5)->C5_DESC1         		, Nil},;  // Percentual de Desconto
		{"CJ_XINCISS" 	,(_cPSC5)->C5_INCISS        		, Nil},;  // ISS Incluso
		{"CJ_XTIPLIB" 	,(_cPSC5)->C5_TIPLIB        		, Nil},;  // Tipo de Liberacao
		{"CJ_MOEDA"  	,(_cPSC5)->C5_MOEDA         		, Nil},;  // Moeda
		{"CJ_XTRANSP" 	,(_cPSC5)->C5_TRANSP				, Nil},;  // Transportadora
		{"CJ_XTPFRTE"	,(_cPSC5)->C5_TPFRETE				, Nil},;  // Tipo do Frete
		{"CJ_FRETE"  	,(_cPSC5)->C5_FRETE					, Nil},;  // Valor do Frete
		{"CJ_XPESOL"  	,(_cPSC5)->C5_PESOL 				, Nil},;  // Peso Liquido
		{"CJ_XPBRUTO" 	,(_cPSC5)->C5_PBRUTO   				, Nil},;  // Peso Bruto
		{"CJ_VXOLUM1"	,(_cPSC5)->C5_VOLUME1				, Nil},;  // Volume
		{"CJ_XNUMOLD" 	,__cXNUMOLD							, Nil},;  // Numero do pedido
		{"CJ_XESPEC1"	,(_cPSC5)->C5_ESPECI1  				, Nil},;  // Especie
		{"CJ_XVEND1"  	,(_cPSC5)->C5_VEND1	   				, Nil},;  // Vendedor
		{"CJ_TABELA" 	,(_cPSC5)->C5_TABELA				, Nil},;  // Tabela de Preço
		{"CJ_XFATFRC"  ,(_cPSC5)->C5_FATFRAC				, Nil},;  // Caixa Fracionada (S/N)
		{"CJ_XFATPAC"  ,(_cPSC5)->C5_FATPARC				, Nil},;  // Faturamento Parcial (S/N)
		{"CJ_XOBSERV" 	,AllTrim((_cPSC5)->C5_OBSERVA)		, Nil},;  // Observação
		{"CJ_XMENNOT" 	,AllTrim((_cPSC5)->C5_MENNOTA)		, Nil},;  // Mensagem para a nota fiscal
		{"CJ_XCLASPD" 	,_vClasPed			   				, Nil},;  // Classificação do pedido
		{"CJ_XDTIMP"	,_dataImp					      	, Nil},;  // Data da importação do pedido
		{"CJ_XHRIMP"	,_horaImp					      	, Nil},;  // Horário da importação do pedido
		{"CJ_XDTPDPR" 	,STOD((_cPSC5)->C5_DTPEDPR)			, Nil},;  // Data do pedido programado
		{"CJ_XDTAPPO" 	,STOD((_cPSC5)->C5_DTAPPO)			, Nil},;  // Data da aprovação do pedido no Portal
		{"CJ_XHRAPPO"	,(_cPSC5)->C5_HRAPPO				, Nil},;  // Horário da aprovação do pedido no Portal
		{"CJ_XLIBCR"	,"P"								, Nil},;  // Orçamento nasce com a liberação de credito como pendente.
		{"CJ_TPCARG"	,'1'						   		, Nil},;  // Carga
		{"CJ_XITEMC"	,(_cPSC5)->C5_XITEMC				, Nil},;  // EMPRESA DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)
		{"CJ_EMPDES"	,(_cPSC5)->C5_EMPDES		   		, Nil},;  // FILIAL DESTINO (UTILIZADO NO CROSSDOCKING - NÃO SE APLICA PARA PEDIDOS DA ASSISTÊNCIA)
		{"CJ_FILDES"	,(_cPSC5)->C5_FILDES		   		, Nil}}   // Unidade de Negócio

		_aCab := FWVetByDic( _aCab, "SCJ" )

		//Faz consulta dos Itens do pedido no portal do representante.
		_cQuery := "SELECT * " + ENTER
		_cQuery += "FROM " + _sNomeBanco + "SC6 " + ENTER
		_cQuery += "WHERE C6_NUMPRE = '" + (_cPSC5)->C5_NUMPRE + "' AND ISNULL(D_E_L_E_T_, '') = '' " + ENTER
		_cQuery += "ORDER BY C6_NUMPRE, C6_ITEM " + ENTER
		_cQuery := ChangeQuery( _cQuery )

		//MemoWrite("FATMI001-LEITENS_ASSTEC.sql",_cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC6 := GetNextAlias()), .F., .T.)

		COUNT TO _nRec2
		If !lWeb
			oObj:SetRegua2(_nRec2)
		EndIf
		_nProc2		:= 1
		(_cPSC6)->(dbGoTop())

		While !(_cPSC6)->(EOF())

			If !lWeb
				oObj:IncRegua2("Processando item " + Alltrim(Str(_nProc2)) + " de " + Alltrim(Str(_nRec2)) + " itens.")
			EndIf

			_cOper := (_cPSC6)->C6_OPER

			// Manter a busca da TES pela função MaTesInt já que o gatilho padrão do "Tipo de Operação" (CK_OPER)
			// não sobrepõe qualquer TES colocada na matriz. E nem o gatilho do CK_XOPER ativa a TES inteligente do CK_OPER
			// Autor: CT																Data: 03/09/2014
			cTES := MaTesInt(2, _cOper, (_cPSC5)->C5_CLIENTE, (_cPSC5)->C5_LOJACLI, "C", PadR((_cPSC6)->C6_PRODUTO, 15))

			_aItAux := {}

			_aItAux := {;
			{"CK_NUMOLD"		,__cXNUMOLD			         	, Nil},; // Numero do Pedido no Portal
			{"CK_PRODUTO"		,PadR((_cPSC6)->C6_PRODUTO,15) 	, Nil},; // Codigo do Produto
			{"CK_QTDVEN" 		,(_cPSC6)->C6_QTDVEN			, Nil},; // Quantidade Vendida
			{"CK_PRUNIT" 		,(_cPSC6)->C6_VALDESC      	  	, Nil},; // Preço de Lista
			{"CK_PRCVEN" 		,(_cPSC6)->C6_VALDESC      		, Nil},; // Preço Unitario Liquido
			{"CK_OPER"  		,_cOper 						, Nil},; // TIPO DE OPERAÇÃO (SE EMPRESA FOR DAIHATSU, SEMPRE SERÁ VENDAS (V3))
			{"CK_XOPER"  		,_cOper 						, Nil},; // TIPO DE OPERAÇÃO customizada
			{"CK_LOCAL"  		,(_cPSC6)->C6_LOCAL        	 	, Nil},; // Almoxarifado
			{"CK_XREAJIP"		,"S"                      		, Nil},; // Reajusta IPI
			{"CK_XQTDLIB"		,0      						, Nil},; // Quantidade Liberada
			{"CK_TES"    		,cTES							, Nil},; // Tipo de Entrada/Saida do Item
			{"CK_PEDCLI" 		,AllTrim((_cPSC6)->C6_PEDCLI)	, Nil},; // Pedido Cliente no campo padrão
			{"CK_XITEMC" 		,AllTrim((_cPSC6)->C6_XITEMC)	, Nil}} // UNIDADE DE NEGÓCIO

			_aItAux := FWVetByDic( _aItAux, "SCK" )
			aAdd( _aItens, _aItAux )

			_nProc2 ++

			(_cPSC6)->(dbSkip())

		EndDo

		If lEnd //Processo Cancelado pelo Usuário
			Exit
		EndIf
		If !lWeb
			oObj:SetRegua2(1)
			oObj:IncRegua2("Finalizando gravação dos itens.")
		EndIf

		BEGIN TRANSACTION

			MSExecAuto({|x,y,z| mata415(x,y,z)}, _aCab, _aItens, 3) //Inclusão

			If lMsErroAuto //Grava Erro na Importação
				If !lWeb
					mostraerro()
				EndIf
				_nErro++
				cMensErr += __cXNUMOLD + ENTER
			Else
				_numOrc := U_RetNumOrc(__cXNUMOLD) //Obtém o código do Orçamento através do código de Pedido Portal
				U_FATMI002(1, _numOrc, "N",lWeb) //Avalia o Crédito e já efetua a Liberação/Bloqueio, dependendo da situação do Cliente
				AtuStatusAT(__cXNUMOLD, _sNomeBanco) //Grava OK na Importação
				_nOK++
				cMensImp += 'Pedido  :'+ __cXNUMOLD + ENTER
				cMensImp += 'Cliente :'+ (_cPSC5)->C5_CLIENTE+"-"+(_cPSC5)->C5_LOJACLI+" "+Posicione("SA1",1,xFilial("SA1")+(_cPSC5)->C5_CLIENTE+(_cPSC5)->C5_LOJACLI,"A1_NOME")+ENTER
				//cMensImp += 'Valor   : '+ Transform(nTotalPed,"@e 999,999.99")+ENTER
				cMensImp += ''+ENTER

			Endif

		END TRANSACTION
		_nProc ++
		(_cPSC5)->(dbSkip())
	EndDo
	If !lWeb
		Msgstop("Foram importados " + ALLTRIM(STR(_nOK)) + " orçamentos. " + ALLTRIM(STR(_nErro)) + " orçamentos apresentaram erros.")
	Else
		//cEmail := "grp_sistemas@taiffproart.com.br;marta.sakamoto@taiff.com.br;pedido.assistenciatecnica@taiff.com.br"
		cEmail := cListEmail
		//ENVIA EMAIL ERROS
		If !Empty(cMensErr)
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,'Segue Relação de orçamentos de Vendas com erro, importar manualmente ' + DTOC(DDATABASE)	,'')
		EndIf
		//ENVIA EMAIL ORCAMENTOS IMPORTADOS
		If !Empty(cMensImp)
			//cMensImp += 'Valor Total   : '+ Transform(nTotGeral,"@e 99,999,999.99")+ENTER
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensImp	, 'Orçamentos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		Else
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'','Não tem pedidos no momento', 'Orçamentos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		EndIf
	EndIf

Return

/*
************************************************************************************************************************************
************************************************************************************************************************************
*** Programa: IMPASSTEC * Autor: Gilberto Ribeiro Jr * Data: 07/10/15   ***
************************************************************************************************************************************
*** Desc:
************************************************************************************************************************************
*/
Static Function AtuStatusAT(_cNumPed, _sNomeBanco)

	Local _cQuery := ""
	//Local _cDtHora := ""

	If At("A", _cNumPed) != 0
		_cNumPed := Stuff(_cNumPed, At("A", _cNumPed), 1, "" )
	EndIf

	_cQuery   := "UPDATE " + _sNomeBanco + "SC5 SET "
	_cQuery   += "	C5_IMP_PED = '*', "
	_cQuery   += "  C5_STSPED  = '1', "
	_cQuery   += "  C5_DTIMP   = '" + STRZERO(YEAR(date()),4, 0) + STRZERO(MONTH(date()),2, 0) + STRZERO(DAY(date()),2, 0) + "', "
	_cQuery   += "  C5_HRIMP   = '" + REPLACE(SUBSTRING( time() , 1,5 ), ":", "") + "' "
	_cQuery   += "WHERE C5_NUMPRE = '" + _cNumPed + "'"
	//MemoWrite("FATMI001-GRAVAOK_ASSTEC.sql",_cQuery)
	TCSQLExec(_cQuery)

Return

/*
************************************************************************************************************************************
************************************************************************************************************************************
*** Programa: IMPASSTEC * Autor: Gilberto Ribeiro Jr * Data: 07/10/15   ***
************************************************************************************************************************************
*** Desc:
************************************************************************************************************************************
*/
User Function RetNumOrc(_numOld)

	Local numOrc
	Local aliasSCJ := GETNEXTALIAS()

	BeginSql alias aliasSCJ
		SELECT SCJ.CJ_NUM AS NUM
		FROM %table:SCJ% SCJ
		WHERE SCJ.CJ_FILIAL= %xfilial:SCJ%
		  AND SCJ.CJ_XNUMOLD = %exp:_numOld% 
		  AND SCJ.%NotDel%
	EndSql

	// Número do Orçamento não foi encontrado
	If (aliasSCJ)->(Eof())
		(aliasSCJ)->(DbCloseArea())
		Return
	EndIf

	numOrc := (aliasSCJ)->NUM

	(aliasSCJ)->(DbCloseArea())

Return numOrc
