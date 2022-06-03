#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#include "TbiCode.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSALES  ºAutor  ³Gilberto Ribeiro Jr º Data ³  27/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza Importação dos Pedidos do CRM (Oracle Sales Cloud) º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPSALES(cEmpSch,cFilialSch,cMarcaSch)

	//Local aAreacPSC5 := ""
	//Local aParamBox := {}
	//Local aRet 	    := {}
	Local cSemaforo
	Local oObj
	//Local aUnidNeg	:= {} 		//Array com as Unidades de Negócio
	//Local Kz 		:= 0
	Local i			:= 0

	LOCAL ODLG
	LOCAL OSAY01
	LOCAL CSAY01		:= "Marca"
	LOCAL OBTN
	LOCAL LOK			:= .F.
	//LOCAL LCALNCEL		:= .F.
	LOCAL CMI01MARCA	:= SPACE(009)
	LOCAL AMARCAS		:= {"TAIFF","PROART"}
	Local cEmail		:= "grp_sistemas@taiff.com.br"

	Private lWeb	:= .F.		//CONTROLA SE ESTA SENDO EXECUTADO PELO SCHEDULE
	Private cCabEmail := ""
	Private AHEADER
	Private _cTransp := ""		// Código da Transportadora do Cliente
	Public _aNomeBanco  		//Array com os Banco de Dados dos Portais que terão seus pedidos importados
	Public _sNomeBanco	:= ""  	//String do banco de dados do Web
	Public cUnidNeg				//Array com as Unidades de Negócio

	//DEFAULT aEmpresas	:= {{"03","01",1},{"03","02",1}}



	//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		cCabEmail := " Empresa/Filial: " + cEmpSch + "/" + cFilialSch + " da Marca " + cMarcaSch


		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"

		//lImporta := Iif(GetMV("MV__FTMI01")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		If LEFT(cMarcaSch,1)="P"
			lImporta := Iif(GetMV("MV__FTMI0P")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		ElseIf LEFT(cMarcaSch,1)="T"
			lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		EndIf

		If lImporta
			cEmail:= "grp_sistemas@taiff.com.br"
			U_2EnvMail("workflow@taiff.com.br", RTrim(cEmail) ,""," *** ATENCAO *** revisar parametro MV__FTMI0"+ LEFT(cMarcaSch,1) , "Importação automatica " + PROCNAME() ,'')
		Else
			If LEFT(cMarcaSch,1)="P"
				PutMv("MV__FTMI0P","S")
			ElseIf LEFT(cMarcaSch,1)="T"
				PutMv("MV__FTMI0T","S")
			EndIf

			cSemaforo := AllTrim(cEmpAnt) + xFilial("SA1") + FunName() + LEFT(cMarcaSch,1)
			lWeb := .T.
			_aNomeBanco	:= StrTokArr(GETMV("MV_DBSALES"), "/") // CRIAR ESTE PARÂMETRO
			cUnidNeg		:= SuperGetMV("MV_UNIDNEG", .F., "")

			titulo      	:= "IMPSALES - Inicio Importacao Orçamento Empresa " + AllTrim(SM0->M0_NOME) + "/" + SM0->M0_FILIAL

			If (Time() >= "08:00:00" .AND. Time() <= "08:30:00")
				RESET ENVIRONMENT
				Return
			EndIf

			For i := 1 To Len(_aNomeBanco)   // Se for TaiffProart - Extrema, deverá importar de dois Bancos do Portal de Vendas
				_sNomeBanco := _aNomeBanco[i]
				If (cMarcaSch = "TAIFF" .AND. i = 1) .OR. (cMarcaSch = "PROART" .AND. i = 2)
					Processar()
				EndIf
			Next

			titulo      	:= "IMPSALES - Fim da Importacao Orçamento Empresa " + AllTrim(SM0->M0_NOME) + "/" + ALLTRIM(SM0->M0_FILIAL)

			//PutMv("MV__FTMI01","N")

			If LEFT(cMarcaSch,1)="P"
				PutMv("MV__FTMI0P","N")
			ElseIf LEFT(cMarcaSch,1)="T"
				PutMv("MV__FTMI0T","N")
			EndIf

		EndIf
		RESET ENVIRONMENT
	Else
		_aNomeBanco	:= StrTokArr(GETMV("MV_DBSALES"), "/")
		cUnidNeg	:= SuperGetMV("MV_UNIDNEG", .F., "")
		cSemaforo 	:= AllTrim(cEmpAnt) + xFilial("SA1") + FunName()

		If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT03", .F., "")

			/*
			|---------------------------------------------------------------------------------
			|	Verifica o horário. Somente após as 10:30 hrs pois antes está sendo atualizado
			|	os dados para Análise de Crédito.
			|---------------------------------------------------------------------------------
			*/
			IF TIME() >= "08:00:00" .AND. TIME() <= "08:30:00"

				MESSAGEBOX("Entre 08:00 e 08:30 hrs está" + ENTER + "sendo atualizado os dados para Análise de Crédito!" + ENTER + "Realize a Importação dos Pedidos fora deste horário!","ATENÇÃO",64)
				RETURN

			ENDIF

			If LockByName(cSemaforo,.T.,.T.,.T.) == .F.
				Msgstop("Processo sendo executado por outro usuário, tente mais tarde.")
				Return
			EndIf

			ODLG   := MSDIALOG():NEW(001,001,230,300,'Filtro de Importação',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
			OCMB01 := TCOMBOBOX():NEW(010		,060		, {|U| IF(PCOUNT()>0,CMI01MARCA:=U,CMI01MARCA)}	,AMARCAS		,060			,009			,ODLG		,				,				,				,				,				,.T.			,				,				,				,				,				,				,				,				,'CMI01MARCA')
			OBTN   := TBUTTON():NEW(090,010,'OK'			,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
			OBTN   := TBUTTON():NEW(090,100,'Cancelar'	,ODLG,{|| LCANCEL 	:= .T.,ODLG:END()},40,10,,,,.T.)

			ODLG:ACTIVATE(,,,.T.)

			WHILE !LOK .AND. !LCANCEL

			ENDDO

			IF LOK

				If LEFT(CMI01MARCA,1) = "P"
					lImporta := Iif(GetMV("MV__FTMI0P")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				ElseIf LEFT(CMI01MARCA,1)="T"
					lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				EndIf

				If 0 != 0 //lImporta
					MsgStop("Rotina importacao orcamentos ja esta sendo executada - IMPSALES")
				Else

					If LEFT(CMI01MARCA,1) = "P"
						PutMv("MV__FTMI0P", "S")
					ElseIf LEFT(CMI01MARCA,1) = "T"
						PutMv("MV__FTMI0T", "S")
					EndIf

					If MsgYesNo("Inicia importacao dos Pedidos do CRM - Oracle Sales Cloud?")

						For i := 1 To Len(_aNomeBanco) Step 1  // Se for TaiffProart - Extrema, deverá importar de dois Bancos do Portal de Vendas
							If (CMI01MARCA = "TAIFF" .AND. i = 1) .OR. (CMI01MARCA = "PROART" .AND. i = 2)
								_sNomeBanco := _aNomeBanco[i]
								oObj := MsNewProcess():New({|lEnd| Processar(oObj, @lEnd)}, "", "", .T.)
								oObj :Activate()
							EndIf
						Next

					EndIf

					UnLockByName(cSemaforo,.T.,.T.,.T.)

					If LEFT(CMI01MARCA,1) = "P"
						PutMv("MV__FTMI0P","N")
					ElseIf LEFT(CMI01MARCA,1) = "T"
						PutMv("MV__FTMI0T","N")
					EndIf
				EndIf
			EndIf
		Else
			Msgstop("Processo não permitido nesta empresa.")
		EndIf
	EndIf
Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSALES  ºAutor  ³Gilberto Ribeiro Jrº  Data ³  27/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Processar(oObj,lEnd)

	Local _dataImp 	:= STOD(STR(YEAR(date()),4) + STR(MONTH(date()),2) + STR(DAY(date()),2))
	Local _horaImp 	:= REPLACE(SUBSTRING( time() , 1,5 ), ":", "")
	Local _aCab			:= {}
	Local _aItens		:= {}
	Local aLinha		:= {}
	//Local _nOpc			:= 3
	Local _cQuery		:= ""
	Local _cPSC6		:= ""
	Local _nRec 		:= 0
	Local _nProc		:= 1
	Local _nProc2		:= 1
	Local _nOK			:= 0
	Local _nErro		:= 0
	Local _cAlias		:= ""
	Local _cChave		:= ""
	Local _dDtIni		:= ""
	Local _cHrIni		:= ""
	Local _cDtFim		:= ""
	Local _cHrFim		:= ""
	Local _cCodUser		:= ""
	Local _cEstacao		:= ""
	Local _cOperac		:= ""
	//Local _cOrcament	:= ""
	Local _cOper		:= ""
	Local _vClasPed   	:= "V"
	//Local _numOrc		:= ""
	//Local _nQtdReg		:= 0
	Local _PedBonif		:= ""
	Local cMensImp		:= ""
	Local cMensErr		:= ""
	Local nTotalPed		:= 0
	Local nTotGeral		:= 0
	LOCAL CNOMELOG 		:= ""
	LOCAL cPVBONumold	:= ""
	LOCAL cLibCredito	:= ""
	LOCAL aPedBonifica	:= {}
	Local lBonifIVA		:= GetNewPar("TF_IVABONIF",.F.)
	Local cMV_ESTADO	:= GetMv('MV_ESTADO')
	//Local aColsAux := {}
	Local dVbTTAtiva	:= GetNewPar("TF_ATIVAVB", CTOD("01/02/2020") )
	Local nLoopBonif	:= 0

	Default lEnd 		:= .F.

	Public _cPSC5		:= ""

	lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SELECIONA INFORMAçõES DOS PEDIDOS PENDENTES DE IMPORTAçãO DO PORTAL      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := " SELECT  CAST(PED.NUMSALES AS VARCHAR(6)) AS NUMSALES, " + ENTER
	_cQuery += " PED.TIPO AS TIPO, " + ENTER
	_cQuery += " PED.CLIENTE AS CLIENTE, " + ENTER
	_cQuery += " PED.LOJACLI AS LOJACLI, " + ENTER
	_cQuery += " PED.CLIENTE AS CLIENT, " + ENTER
	_cQuery += " PED.LOJACLI AS LOJAENT, " + ENTER
	_cQuery += " ISNULL(PED.TRANSP,'') AS TRANSP, " + ENTER
	_cQuery += " PED.TIPOCLI AS TIPOCLI, " + ENTER
	_cQuery += " PED.CONDPAG AS CONDPAG, " + ENTER
	_cQuery += " PED.TABELA AS TABELA, " + ENTER
	_cQuery += " PED.OBSERVA AS OBSERVA, " + ENTER
	_cQuery += " ISNULL(PED.FATFRAC, '') AS FATFRAC, " + ENTER
	_cQuery += " ISNULL(PED.FATPARC, '') AS FATPARC, " + ENTER
	_cQuery += " ISNULL(PED.VEND1, '') AS VEND1, " + ENTER
	_cQuery += " 0 AS DESC1, " + ENTER
	//_cQuery += " ISNULL(PED.DESC1, 0) AS DESC1, " + ENTER // VERIFICAR NECESSIDADE DESSE CAMPO
	_cQuery += " CAST(CONVERT(VARCHAR(8),PED.EMISSAO , 112) AS VARCHAR(8)) EMISSAO, " + ENTER
	_cQuery += " PED.TPFRETE AS TPFRETE, " + ENTER
	_cQuery += " CAST(ISNULL(PED.PCFRETE, 0) AS FLOAT) AS FRETE, " + ENTER
	_cQuery += " 1 AS MOEDA, " + ENTER
	_cQuery += " 0 AS PESOL, " + ENTER
	_cQuery += " 0 AS PBRUTO, " + ENTER
	_cQuery += " 0 AS VOLUME1, " + ENTER
	_cQuery += " 'CAIXA' AS ESPECI1, " + ENTER
	_cQuery += " 'N' AS INCISS, " + ENTER
	_cQuery += " '1' AS TIPLIB, " + ENTER
	_cQuery += " ISNULL(PED.DTPEDPR, '') AS DTPEDPR, " + ENTER
	_cQuery += " ISNULL(PED.DTAPPO, '') AS DTAPPO, " + ENTER
	_cQuery += " ISNULL(PED.HRAPPO, '') AS HRAPPO, " + ENTER
	_cQuery += " ISNULL(PED.PCFRETE, 0) AS PCFRETE, " + ENTER
	_cQuery += " ISNULL(PED.PCVBCONTRPED, 0) AS PCVBCTR, " + ENTER
	_cQuery += " PED.EMPDES AS EMPDES, " + ENTER  // EMPRESA DESTINO (UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
	_cQuery += " PED.FILDES AS FILDES, " + ENTER  // FILIAL DESTINO(UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
	_cQuery += " PED.OPER AS OPER, " + ENTER  // TIPO DE OPERAçãO (V3 = VENDAS / V5 = BONIFICAçãO)
	_cQuery += " PED.PEDVENDASSOCIADO AS PEDVENDA, " + ENTER  // ESTE CAMPO ESTARÁ PREENCHIDO QUANDO O PEDIDO FOR DE BONIFICAÇÃO
	_cQuery += " PED.UNIDNEG AS XITEMC " + ENTER  // UNIDADE DE NEGÓCIO
	If SC5->(FIELDPOS("C5_DESCTAT")) > 0
		_cQuery += " ,ISNULL(SUBSTRING(PED.DESCTATICO,1,2), '') AS C5_DESCTAT " + ENTER
		_cQuery += " ,ISNULL(PED.PERCENTUALTATICO, 0) AS C5_PERCTAT " + ENTER
	EndIf
	_cQuery += " FROM " + _sNomeBanco + "PEDIDO PED  " + ENTER

	_cQuery += " WHERE ISNULL(PED.D_E_L_E_T_, '') = '' " + ENTER
	_cQuery += "   AND ISNULL(PED.IMPPED, '') = '' " + ENTER
	_cQuery += "   AND PED.STSPED = '03' " + ENTER
	//_cQuery += "   AND NUMSALES IN (54841) " + ENTER


	// AGORA OS PEDIDOS SERÃO IMPORTADO PARA ONDE SERÃO FATURADOS
	_cQuery += "   AND PED.FILDES = '" + cFilAnt + "' " + ENTER


	_cQuery += " ORDER BY PED.NUMSALES ASC " + ENTER
	_cQuery := ChangeQuery( _cQuery )
	//MemoWrite("IMPSALES-LEPEDIDOS.sql",_cQuery)
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
		_PedBonif := ""
		_vClasPed := IIF ((_cPSC5)->OPER = "V5", "X", "V")
		//__cXNUMOLD := Alltrim((_cPSC5)->NUMSALES) + Substring((_cPSC5)->XITEMC,1,1)
		__cXNUMOLD := Alltrim((_cPSC5)->NUMSALES)

		/*
		|---------------------------------------------------------------------------------
		|	REALIZA A ANALISE DA TABELA DE PEDIDOS ASSOCIADOS
		|---------------------------------------------------------------------------------
		*/	
		/*			
		_cQuery := "SELECT" 												+ ENTER 
		_cQuery += "	C5_CLIENTE," 										+ ENTER 
		_cQuery += "	C5_NUMPRE_VENDAS AS VENDAS," 					+ ENTER
		_cQuery += "	C5_NUMPRE_BONIFICACAO AS BONIFIC,"				+ ENTER 
		_cQuery += "	VALOR" 												+ ENTER 
		_cQuery += "FROM" 													+ ENTER 
		_cQuery += "	" + _sNomeBanco + "TBL_PEDIDOS_ASSOCIADOS BON" 		+ ENTER
		_cQuery += "WHERE" 													+ ENTER 
		_cQuery += "	C5_CLIENTE = '" + (_cPSC5)->C5_CLIENTE + "' AND" 	+ ENTER
		IF _vClasPed = "X"
		_cQuery += "	C5_NUMPRE_BONIFICACAO = " + SUBSTR(__cXNUMOLD,1,LEN(__cXNUMOLD) - 1) 
		ELSE
		_cQuery += "	C5_NUMPRE_VENDAS = " + SUBSTR(__cXNUMOLD,1,LEN(__cXNUMOLD) - 1)
		ENDIF

		IF SELECT("BON") > 0
		DBSELECTAREA("BON")
		DBCLOSEAREA()
		ENDIF

		TCQUERY _cQuery NEW ALIAS "BON"
		DBSELECTAREA("BON")
		DBGOTOP()

		COUNT TO _nQtdReg

		IF _NQTDREG > 0

		_PedBonif := ""
		DBGOTOP()
			WHILE BON->(!EOF())

				IF _vClasPed = "X"
		_PEDBONIF += IIF(EMPTY(_PEDBONIF), (CVALTOCHAR(BON->VENDAS) + Substring((_cPSC5)->C5_XITEMC,1,1)), "/" + (CVALTOCHAR(BON->VENDAS) + Substring((_cPSC5)->C5_XITEMC,1,1)))				
				ELSE
		_PEDBONIF += IIF(EMPTY(_PEDBONIF), (CVALTOCHAR(BON->BONIFIC) + Substring((_cPSC5)->C5_XITEMC,1,1)), "/" + (CVALTOCHAR(BON->BONIFIC) + Substring((_cPSC5)->C5_XITEMC,1,1)))
				ENDIF
		BON->(DBSKIP())

			ENDDO

		ENDIF

		DBSELECTAREA("BON")
		DBCLOSEAREA()
		*/

		/***************************************************************************
		OBTÉM A TRANSPORTADORA DIRETO DO CADASTRO DO CLIENTE
		****************************************************************************/
		DbSelectArea("SA1")
		DbSetOrder(1)
		_cTransp := ""
		if DbSeek(xFilial("SA1") + (_cPSC5)->CLIENTE + (_cPSC5)->LOJACLI )
			_cTransp := SA1->A1_TRANSP
		endif

		_aCab :={	{"C5_CLIENTE"	,(_cPSC5)->CLIENTE				, NIL},;  // Codigo do cliente
		{"C5_LOJACLI"	,(_cPSC5)->LOJACLI       		, Nil},;  // Loja do cliente
		{"C5_CLIENT"	,IIF(Empty((_cPSC5)->CLIENT)	, (_cPSC5)->CLIENTE,(_cPSC5)->CLIENT)	, NIL},;  // Se não tiver cliente de Entrega preenche com o cliente
		{"C5_LOJAENT"	,IIF(Empty((_cPSC5)->LOJAENT) 	, (_cPSC5)->LOJACLI,(_cPSC5)->LOJAENT)	, NIL},;  // Loja para entrada Entrega
		{"C5_CONDPAG"	,(_cPSC5)->CONDPAG     			, Nil},;  // Codigo da condicao de pagamanto*
		{"C5_TIPOCLI"	,(_cPSC5)->TIPOCLI       		, Nil},;  // Tipo de Cliente
		{"C5_TIPO"	   	,(_cPSC5)->TIPO					, Nil},; // Tipo de pedido
		{"C5_DESC1"  	,(_cPSC5)->DESC1        		, Nil},;  // Percentual de Desconto
		{"C5_INCISS" 	,(_cPSC5)->INCISS        		, Nil},;  // ISS Incluso
		{"C5_TIPLIB" 	,(_cPSC5)->TIPLIB        		, Nil},;  // Tipo de Liberacao
		{"C5_MOEDA"  	,(_cPSC5)->MOEDA       			, Nil},;  // Moeda
		{"C5_TRANSP" 	,_cTransp						, Nil},;  // Transportadora
		{"C5_TPFRETE"	,(_cPSC5)->TPFRETE				, Nil},;  // Tipo do Frete
		{"C5_FRETE"  	,(_cPSC5)->FRETE				, Nil},;  // Valor do Frete
		{"C5_PESOL"  	,(_cPSC5)->PESOL 				, Nil},;  // Peso Liquido
		{"C5_PBRUTO" 	,(_cPSC5)->PBRUTO   			, Nil},;  // Peso Bruto
		{"C5_VOLUME1"	,(_cPSC5)->VOLUME1				, Nil},;  // Volume
		{"C5_NUMOLD" 	,__cXNUMOLD						, Nil},;  // Numero do pedido
		{"C5_ESPECI1"	,(_cPSC5)->ESPECI1  			, Nil},;  // Especie
		{"C5_VEND1"  	,(_cPSC5)->VEND1	   			, Nil},;  // Vendedor
		{"C5_TABELA" 	,(_cPSC5)->TABELA				, Nil},;  // Tabela de Preço
		{"C5_FATFRAC"  	,(_cPSC5)->FATFRAC				, Nil},;  // Caixa Fracionada (S/N)
		{"C5_FATPARC"  	,(_cPSC5)->FATPARC				, Nil},;  // Faturamento Parcial (S/N)
		{"C5_OBSERVA" 	,AllTrim((_cPSC5)->OBSERVA)		, Nil},;  // Observação
		{"C5_CLASPED" 	,_vClasPed			   			, Nil},;  // Classificação do pedido
		{"C5_DTIMP"		,_dataImp					    , Nil},;  // Data da importação do pedido
		{"C5_HRIMP"		,_horaImp					    , Nil},;  // Horário da importação do pedido
		{"C5_DTPEDPR" 	,STOD((_cPSC5)->DTPEDPR)		, Nil},;  // Data do pedido programado
		{"C5_DTAPPO" 	,STOD((_cPSC5)->DTAPPO)			, Nil},;  // Data da aprovação do pedido no Portal
		{"C5_HRAPPO"	,(_cPSC5)->HRAPPO				, Nil},;  // Horário da aprovação do pedido no Portal
		{"C5_PCFRETE"	,(_cPSC5)->PCFRETE	      		, Nil},;  // PERCENTUAL DE FRETE DO PEDIDO
		{"C5_PCVBCTR"	,(_cPSC5)->PCVBCTR	      		, Nil},;  // PERCENTUAL DA VERBA CONTRATUAL DO PEDIDO
		{"C5_XLIBCR"	,"P"							, Nil},;  // Orçamento nasce com a liberação de credito como pendente.
		{"C5_TPCARGA"	,'1'						   	, Nil},;  // Carga                                                    
		{"C5_EMPDES"	,(_cPSC5)->EMPDES				, Nil},;  // EMPRESA DESTINO (UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
		{"C5_FILDES"	,(_cPSC5)->FILDES	   			, Nil},;  // FILIAL DESTINO(UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)                                                     
		{"C5_X_PVBON"	,ALLTRIM((_cPSC5)->PEDVENDA)	, Nil},;  // NUMERO DO PEDIDO DE VENDA ASSOCIADO A BONIFICACAO
		{"C5_MENNOTA"	,"PEDIDO PORTAL: " + __cXNUMOLD	, Nil},;  // Mensagem do corpo da nota
		{"C5_XITEMC"	,IIF((_cPSC5)->XITEMC = "VIS", "TAIFF", (_cPSC5)->XITEMC)						, Nil}}  // UNIDADE DE NEGÓCIO (SE FOR VIS, MUDA PARA TAIFF, POIS NAO EXISTE UNIDADE DE NEGOCIO VIS)

		If (SC5->(FIELDPOS("C5_DESCTAT")) > 0) .AND. DDATABASE >= dVbTTAtiva
			AADD(_aCab, {"C5_DESCTAT"	,(_cPSC5)->C5_DESCTAT	   		, Nil})  // TIPO DE VERBA TATICA                                                     
			AADD(_aCab,	{"C5_PERCTAT"	,((_cPSC5)->C5_PERCTAT*100)	, Nil})  // PERCENTUAL DE VERBA TATICA                                                     
		EndIf

		//Faz consulta dos Itens do pedido no portal do representante.
		_cQuery := "SELECT  							" + ENTER 
		_cQuery += "		 NUMSALES					" + ENTER 
		_cQuery += "		,ITEM						" + ENTER 
		_cQuery += "		,PRODUTO					" + ENTER 
		_cQuery += "		,DESCRI						" + ENTER 
		_cQuery += "		,UM 						" + ENTER 
		_cQuery += "		,QTDVEN 					" + ENTER 
		_cQuery += "		,PRUNIT						" + ENTER
		_cQuery += "		,PRCVEN						" + ENTER
		_cQuery += "		,VALDESC					" + ENTER
		_cQuery += "		,OPER						" + ENTER
		_cQuery += "		,LOCAL AS LOCAL_ARM			" + ENTER
		_cQuery += "		,COMIS1						" + ENTER
		_cQuery += "		,PEDCLI						" + ENTER
		_cQuery += "		,UNIDNEG AS XITEMC			" + ENTER
		_cQuery += "FROM " + _sNomeBanco + "ITEMPEDIDO  " + ENTER
		_cQuery += "WHERE NUMSALES = '" + (_cPSC5)->NUMSALES + "' AND ISNULL(D_E_L_E_T_, '') = '' " + ENTER
		_cQuery += "ORDER BY NUMSALES, ITEM " + ENTER
		_cQuery := ChangeQuery( _cQuery )

		//MemoWrite("IMPSALES-LEITENS.sql",_cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cPSC6 := GetNextAlias()), .F., .T.)
		COUNT TO _nRec2
		If !lWeb
			oObj:SetRegua2(_nRec2)
		EndIf
		_nProc2		:= 1
		(_cPSC6)->(dbGoTop())

		While !(_cPSC6)->(EOF())
			If !lWeb
				oObj:IncRegua2("Processando item "+Alltrim(Str(_nProc2))+ " de " + Alltrim(Str(_nRec2)) + " itens.")
			EndIf
			_cOper := (_cPSC6)->OPER                                                                               

			// Manter a busca da TES pela função MaTesInt já que o gatilho padrão do "Tipo de Operação" (CK_OPER) 
			// não sobrepõe qualquer TES colocada na matriz. E nem o gatilho do CK_XOPER ativa a TES inteligente do CK_OPER
			// Autor: CT																Data: 03/09/2014
			//cTES := MaTesInt(2,_cOper,(_cPSC5)->CLIENTE,(_cPSC5)->LOJACLI,"C",PadR((_cPSC6)->PRODUTO,15),"C6_TES")
			cTES := "801"
			SB1->(DBSETORDER(1))  
			SB1->(DBSEEK(XFILIAL("SB1") + PadR((_cPSC6)->PRODUTO,15), .F.))

			/*
			|---------------------------------------------------------------------------------
			|	CRIA SB2 / SBE / SBF - CASO NAO TENHA PARA O PRODUTO
			|---------------------------------------------------------------------------------
			*/
			CRIASB2( PadR((_cPSC6)->PRODUTO,15) , "21" )

			// 
			// Removida a chamada da criação do endereço EXP uma vez que passamos a utilizar endereços por produto
			// Data: 04/01/2021
			// Autor: Carlos Torres
			//
			SBE->(DBSETORDER(1))  //CADASTRO DE ENDERECOS
			IF !SBE->(DBSEEK(XFILIAL("SBE") + "21" + SUBSTRING(SB1->B1_YENDEST + SPACE(TamSX3("BF_LOCALIZ")[1]),1,TamSX3("BF_LOCALIZ")[1]), .F.))
				SBE->(RECLOCK("SBE", .T.))
				SBE->BE_FILIAL := XFILIAL("SBE")
				SBE->BE_LOCAL  := "21"
				SBE->BE_LOCALIZ:= SB1->B1_YENDEST
				SBE->BE_DESCRIC:= "EXPEDICAO " + ALLTRIM((_cPSC5)->XITEMC)
				SBE->BE_PRIOR  := "ZZZ"
				SBE->BE_STATUS := "1"
				SBE->(MSUNLOCK())
			ENDIF

			aLinha := {}
			AAdd(aLinha,{"C6_CLI"			,(_cPSC5)->CLIENTE				, Nil})
			AAdd(aLinha,{"C6_LOJA"			,(_cPSC5)->LOJACLI				, Nil})
			AAdd(aLinha,{"C6_ITEM"			,(_cPSC6)->ITEM		         	, Nil}) // Numero do Pedido no Portal
			AAdd(aLinha,{"C6_PRODUTO"		,PadR((_cPSC6)->PRODUTO,15) 	, Nil}) // Codigo do Produto
			AAdd(aLinha,{"C6_DESCRI"		,(_cPSC6)->DESCRI				, Nil})
			AAdd(aLinha,{"C6_UM"			,(_cPSC6)->UM     				, Nil})
			AAdd(aLinha,{"C6_QTDVEN" 		,(_cPSC6)->QTDVEN				, Nil}) // Quantidade Vendida
			AAdd(aLinha,{"C6_QTDENT"		,0								, Nil})
			AAdd(aLinha,{"C6_QTDENT2"		,0								, Nil})
			AAdd(aLinha,{"C6_QTDLIB"		,0								, Nil})
			AAdd(aLinha,{"C6_QTDEMP"		,0								, Nil})
			AAdd(aLinha,{"C6_PRUNIT" 		,(_cPSC6)->VALDESC      	  	, Nil}) // Preço de Lista
			AAdd(aLinha,{"C6_PRCVEN" 		,(_cPSC6)->VALDESC      		, Nil}) // Preco Unitario Liquido
			AAdd(aLinha,{"C6_REAJIPI"		,"S"							, Nil})
			AAdd(aLinha,{"C6_OPER"  		,_cOper 						, Nil}) // TIPO DE OPERAçãO (SE EMPRESA FOR DAIHATSU, SEMPRE SERá VENDAS (V3))
			AAdd(aLinha,{"C6_XOPER"  		,_cOper 						, Nil}) // TIPO DE OPERAçãO customizada
			AAdd(aLinha,{"C6_LOCAL"  		,(_cPSC6)->LOCAL_ARM       	 	, Nil}) // Almoxarifado
			AAdd(aLinha,{"C6_TES"    		,cTES							, Nil}) // Tipo de Entrada/Saida do Item
			AAdd(aLinha,{"C6_COMIS1"  		,(_cPSC6)->COMIS1				, Nil}) // Percentual de Comissão (Atenção para ver se não irá atrapalhar o cálculo da Comissão)
			AAdd(aLinha,{"C6_PEDCLI" 		,AllTrim((_cPSC6)->PEDCLI)		, Nil}) // Pedido Cliente no campo padrão
			AAdd(aLinha,{"C6_XITEMC" 		,AllTrim((_cPSC6)->XITEMC)		, Nil}) // UNIDADE DE NEGÓCIO

			AAdd( _aItens, aLinha)

			_nProc2 ++
			//SOMA O VALOR DOS PEDIDOS QUANDO GERA FINANCEIRO
			If Posicione("SF4",1,xFilial("SF4") + cTES,"F4_DUPLIC") == "S"
				nTotalPed += (_cPSC6)->QTDVEN * (_cPSC6)->VALDESC
			EndIf

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

			MSExecAuto({|x,y,z| mata410(x,y,z)}, _aCab, _aItens, 3) //Inclusão

			If lMsErroAuto //Grava Erro na Importação
				If !lWeb
					mostraerro()
				Else
					CNOMELOG := "IMPSALES_ERRO_NO_PEDIDO_" + Alltrim((_cPSC5)->NUMSALES) + ".LOG"
					MOSTRAERRO("\SYSTEM\",CNOMELOG)
				EndIf

				AtuSts(_aCab[18][2],.T.,_sNomeBanco)
				_nErro++
				cMensErr += Alltrim((_cPSC5)->NUMSALES) + ENTER
			Else
				_nOK++
				cMensImp += 'Pedido  :'+ Alltrim((_cPSC5)->NUMSALES) + ENTER
				cMensImp += 'Cliente :'+ (_cPSC5)->CLIENTE + "-" + (_cPSC5)->LOJACLI + " " + Posicione("SA1",1,xFilial("SA1") + (_cPSC5)->CLIENTE + (_cPSC5)->LOJACLI, "A1_NOME") + ENTER
				cMensImp += 'Valor   : '+ Transform(nTotalPed,"@e 999,999.99") + ENTER
				cMensImp += '' + ENTER
				nTotGeral += nTotalPed
				U_FATMI002(2, SC5->C5_NUM, "N", lWeb) //Avalia o Crédito e já efetua a Liberação/Bloqueio, dependendo da situação do Cliente
				AtuSts(_aCab[18][2],.F.,_sNomeBanco) //Grava OK na Importação

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava Log na tabela SZC³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cAlias		:= "SC5"
				_cChave		:= xFilial("SC5") + SC5->C5_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= "01 - PEDIDO IMPORTADO COM SUCESSO"
				_cFuncao	:= "U_IMPSALES"

				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)


				//********************************************************************************************************************
				// Regra Fiscal
				// Objetivo...: Atualização do MVA para pedidos de bonificação quando originados em MG para clientes de MG
				// Autor......: Carlos Torres
				// Data.......: 05/12/2019
				// Observação.: O ponto de entrada M410AGRV era utilizado quando os pedidos eram importados para Orçamento, que era
				//              encarregado de atualizar o MVA
				//********************************************************************************************************************
				If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->C5_CLASPED $ "X"
					SF4->(DBSETORDER(1))
					SB1->(DBSETORDER(1))
					SA1->(DBSETORDER(1))
					SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIENT + SC5->C5_LOJACLI))

					SC6->(DbSetOrder(1))
					SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM ))
					While .NOT. SC6->(Eof()) .AND. xFilial("SC6") = xFilial("SC5") .AND. SC6->C6_NUM = SC5->C5_NUM
						SF4->(DBSEEK(XFILIAL("SF4") + SC6->C6_TES , .F. ))
						SB1->(DBSEEK(XFILIAL("SB1") + PadR(SC6->C6_PRODUTO,15) , .F. ))
						If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->C5_CLASPED $ "X" .AND. SA1->A1_EST=cMV_ESTADO .AND. SF7->(FIELDPOS("F7_MARBON"))!=0
							If At( Alltrim(SB1->B1_ORIGEM) , "1|2|3") != 0 .AND.  SC5->C5_TIPO = "N" .AND. SF4->F4_ISS != "S" .AND. SA1->A1_GRPTRIB = "C01" .AND. lBonifIVA

								cQuery := "SELECT ISNULL(F7_MARBON,0) AS F7_MARBON " + ENTER
								cQuery += " FROM " + RetSQLName("SF7")+" SF7 " + ENTER
								cQuery += " WHERE " + ENTER
								cQuery += " F7_FILIAL = '"+xFilial("SF7")+"' " + ENTER
								cQuery += " AND F7_GRPCLI 	= '" + SA1->A1_GRPTRIB + "' "  + ENTER
								cQuery += " AND F7_EST 		= '" + SA1->A1_EST + "' " + ENTER
								cQuery += " AND F7_GRTRIB		= '" + SB1->B1_GRTRIB + "' " + ENTER
								cQuery += " AND SF7.D_E_L_E_T_ = '' " + ENTER

								//MemoWrite("GFATIVAB_iva_bonificacao.SQL",cQuery)

								IF SELECT("AUX") > 0
									DBSELECTAREA("AUX")
									DBCLOSEAREA()
								ENDIF

								TCQUERY CQUERY NEW ALIAS "AUX"
								DBSELECTAREA("AUX")
								If AUX->F7_MARBON > 0
									If SC6->(RECLOCK("SC6",.F.))

										SC6->C6_ALIQMAR := AUX->F7_MARBON
										SC6->C6_PICMRET := AUX->F7_MARBON

									EndIf
									SC6->(MSUNLOCK())
								EndIf

							EndIf
						EndIf
						SC6->(DbSkip())
					End
				EndIf
				//********************************************************************************************************************
				//                                                    FIM da Regra Fiscal
				//********************************************************************************************************************
			Endif
			nTotalPed := 0
		END TRANSACTION
		/* Funcionalidade do projeto Financeiro sobre o limite de cr?dito */
		/* Data: 10/06/2020                               Respons?vel: Carlos Torres*/
		/* Chamada da fun??o FINMI003 passando os par?metros  */
		/* ID Controle: 001-IMLES */
		IF .NOT. lMsErroAuto
			U_FINMI003("I",SC5->C5_NUM)
		ENDIF
		/* fim de controle 001-IMLES */


		// Verifica se o pedido necessita de criação de CrossDocking
		If CEMPANT + CFILANT = "0301" .AND. SC5->C5_CLASPED != "A" .AND. .NOT. lMsErroAuto
			//Chama a rotina que irá gerar o pedido de CrossDocking
			//U_PEDCDMG(SC5->C5_NUM, .F.)
			U_GERAPEDCROSS(SC5->C5_NUM, .F.)
		EndIf

		If CEMPANT = "03" .AND. SC5->C5_CLASPED != "A" .AND. .NOT. lMsErroAuto
			//
			// Atualiza o status de credito do pedido de bonificação quando da importação do pedido de venda
			//
			cLibCredito		:= SC5->C5_XLIBCR
			cPVBONumold		:= SC5->C5_NUMOLD
			aPedBonifica	:= {}

			IF SC5->C5_CLASPED = "V"
				_cQuery := "SELECT NUMSALES AS BONIFICA " + ENTER
				_cQuery += "FROM INTEGRACAOOSC.dbo.PEDIDO WITH(NOLOCK) "  + ENTER
				_cQuery += "WHERE OPER = 'V5' "  + ENTER
				_cQuery += " AND ISNULL(D_E_L_E_T_,'') = '' " + ENTER
				_cQuery += " AND PEDVENDASSOCIADO = " + cPVBONumold

				//MEMOWRITE("IMPSALES_" + ALLTRIM(STR(PROCLINE()))+ ".SQL",_cQuery)
				If Select("SQLSAES") > 0
					SQLSAES->( dbCloseArea() )
				EndIf

				dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,_cQuery),"SQLSAES", .F., .T.)

				SQLSAES->(DbGoTop())
				While .NOT. SQLSAES->(Eof())
					cPVBONumold := SQLSAES->BONIFICA
					AADD(aPedBonifica,{ ALLTRIM(cPVBONumold) })

					SQLSAES->(DbSkip())
				End
				SQLSAES->( dbCloseArea() )

				For nLoopBonif := 1 To LEN(aPedBonifica)

					cPVBONumold := aPedBonifica[nLoopBonif][1]
					_cQuery   := "UPDATE SC5 SET" + ENTER
					_cQuery   += "		C5_XLIBCR = '"+cLibCredito+"' " + ENTER
					_cQuery   += "FROM " + RETSQLNAME("SC5") + " SC5 "  + ENTER
					_cQuery   += "WHERE SC5.C5_NUMOLD = '" + ALLTRIM(cPVBONumold) + "' " + ENTER
					_cQuery   += "		AND SC5.D_E_L_E_T_ = '' " + ENTER
					_cQuery   += "		AND SC5.C5_CLASPED='X' " + ENTER
					_cQuery   += "		AND SC5.C5__BLOQF ='' " // <-- caso esteja em branco é por que ainda não passou por analise de estoque
					//MEMOWRITE("IMPSALES_" + ALLTRIM(STR(PROCLINE()))+ ".SQL",_cQuery)
					TCSQLExec(_cQuery)

				Next

			ENDIF

			//
			// Atualiza o status de credito do pedido de bonificação quando da importação do pedido de bonificação
			//
			IF SC5->C5_CLASPED = "X"
				_cQuery   := "UPDATE SC5  SET " + ENTER
				_cQuery   += "		C5_XLIBCR = ISNULL((SELECT MAX(C5_XLIBCR) FROM SC5030 SC5VEN WITH(NOLOCK) WHERE SC5VEN.C5_NUMOLD = RTRIM(LTRIM(SC5.C5_X_PVBON)) AND SC5VEN.C5_CLASPED='V' AND SC5VEN.D_E_L_E_T_ = '' ),'') " + ENTER
				_cQuery   += "FROM " + RETSQLNAME("SC5") + " SC5 "  + ENTER
				_cQuery   += "WHERE SC5.C5_NUMOLD = '" + __cXNUMOLD + "' " + ENTER
				_cQuery   += "		AND SC5.D_E_L_E_T_ = '' " + ENTER
				_cQuery   += "		AND SC5.C5_CLASPED = 'X' " + ENTER
				_cQuery   += "		AND SC5.C5__BLOQF ='' " // <-- caso esteja em branco é por que ainda não passou por analise de estoque
				//MEMOWRITE("IMPSALES_" + ALLTRIM(STR(PROCLINE()))+ ".SQL",_cQuery)
				TCSQLExec(_cQuery)

			ENDIF
		ENDIF

		_nProc ++
		(_cPSC5)->(dbSkip())
	EndDo

	If !lWeb
		Msgstop("Foram importados " + ALLTRIM(STR(_nOK)) + " Pedidos. " + ALLTRIM(STR(_nErro)) + " pedidos apresentaram erros.")
	Else
		//cEmail := 'grp_sistemas@taiffproart.com.br;grp_vendas@proarthair.com.br;grp_vendas@taiff.com.br'
		cEmail := 'grp_vendas@taiff.com.br'
		//cEmail :='gilberto.ribeiro@taiffproart.com.br'
		//cEmail := 'carlos.torres@taiffproart.com.br'
		//ENVIA EMAIL ERROS
		If !Empty(cMensErr)
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,'Segue Relação de pedidos de Vendas com erro, importar manualmente' + DTOC(DDATABASE)	,'')
		EndIf
		//ENVIA EMAIL ORCAMENTOS IMPORTADOS
		If !Empty(cMensImp)
			cMensImp += 'Valor Total   : '+ Transform(nTotGeral,"@e 99,999,999.99")+ENTER
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensImp	, 'Pedidos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		Else
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'','Não tem pedidos no momento', 'Pedidos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		EndIf
	EndIf

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSALES  ºAutor  ³Gilberto Ribeiro Jr º Data ³  31/09/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³AtuSts: Atualiza status da importação, caso tenha ocorrido  º±±
±±º          ³algum erro, grava na tabela de Log                     	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuSts(_cNumPed, _lErro, _sNomeBanco)
	Local _cQuery := ""
	Local _cDtHora := ""

	/*
	If At("P",_cNumPed)!=0
	_cNumPed := Stuff( _cNumPed , At("P",_cNumPed),1,"" )
	EndIf
	If At("T",_cNumPed)!=0
	_cNumPed := Stuff( _cNumPed , At("T",_cNumPed),1,"" )
	EndIf
	*/

	If !_lErro
		_cQuery   := "UPDATE " + _sNomeBanco + "PEDIDO SET "
		_cQuery   += "	IMPPED = '*', "
		_cQuery   += "  STSPED = '1', "
		_cQuery   += "  DTIMP  = '" + STRZERO(YEAR(date()),4, 0) + STRZERO(MONTH(date()),2, 0) + STRZERO(DAY(date()),2, 0) + "', "
		_cQuery   += "  HRIMP  = '" + REPLACE(SUBSTRING( time() , 1,5 ), ":", "") + "' "
		_cQuery   += "WHERE NUMSALES = '" + _cNumPed + "'"
		//MemoWrite("IMPSALES-GRAVAOK.sql",_cQuery)
		TCSQLExec(_cQuery)
	Else
		_cDtHora   := STR(YEAR(date()),4) + "-" + STR(MONTH(date()),2) + "-" + STR(DAY(date()),2) + " " + SUBSTRING( time() , 1,5 )
		_cQuery := "INSERT INTO " + _sNomeBanco + "LOG_ERRO_IMPORTACAO_PEDIDO"
		_cQuery += " ( NUMSALES , DT_ERRO ) "
		_cQuery += " VALUES "
		_cQuery += " ( '" + _cNumPed + "',Convert(DateTime,'" + _cDtHora + "',120) ) "
		//MemoWrite("IMPSALES-GRAVAERRO.sql",_cQuery)
		TCSQLExec(_cQuery)
	Endif

Return


USER FUNCTION GERAPEDCROSS(CNUMPED, LAUTO)

	LOCAL CQUERY 	:= ""
	//LOCAL NREGS		:= 0
	LOCAL ACABSC5	:= {}
	LOCAL ADETSC6	:= {}
	LOCAL ATMPSC6	:= {}
	LOCAL AAREASC5	:= SC5->(GETAREA())
	//LOCAL _CFILOLD	:= CFILANT
	Local cPedPortalTa := ""
	Local cC5transp 		:= ""
	Local cA1transp 		:= ""
	Local cC5trcnpj 		:= ""
	Local cA1trcnpj 		:= ""
	LOCAL cGet1 		:= ""
	//LOCAL cTEXTO1 		:= ""
	LOCAL lTFLogError	:= GetMV("MV__LOGSAL") // PARA HABILITAR O REGISTRO DE LOG POR PEDIDO ALTERE O CONTEÚDO DO PARAMETRO COM .T.
	LOCAL cClasPedido	:= ""
	LOCAL cPVBONumold	:= ""
	LOCAL aPedBonifica	:= {}
	//LOCAL lOK_LOG 		:= .F.
	LOCAL I				:= 0
	LOCAL nLoopBonif	:= 0

	PRIVATE LMSERROAUTO	:= .F.
	PRIVATE NPOSPROD		:= 0
	PRIVATE NPOSITEM		:= 0

	IF lTFLogError
		cGet1 := "IMPSALES_LOG_CROSS_PEDIDO_" + CNUMPED + ".TXT"
		cTEXTO1 := "Linha: " + alltrim(str(procline())) + " - Pedido " + CNUMPED + " classe de pedido: " + SC5->C5_CLASPED + ENTER
		MEMOWRITE(cGet1,cTEXTO1)
	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Somente sera realizado o processo de copia para Pedidos com Status de ERRCOP
	|	Essa validacao somente sera realizada quando nao for um processo automatico.
	|---------------------------------------------------------------------------------
	*/

	/*
	|---------------------------------------------------------------------------------
	|	Verifica se ja existe Cópia do Pedido no CD de MG
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 									+ ENTER
	CQUERY += "	COUNT(*) AS NQTD" 						+ ENTER
	CQUERY += "FROM" 									+ ENTER
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 			+ ENTER
	CQUERY += "WHERE" 									+ ENTER
	CQUERY += "	SC5.C5_FILIAL = '02' AND" 				+ ENTER
	CQUERY += "	SC5.C5_NUMORI = '" + CNUMPED + "' AND" 	+ ENTER
	CQUERY += "	SC5.D_E_L_E_T_ = ''"

	IF SELECT("TRB") > 0
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
	ENDIF

	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	DBGOTOP()

	IF TRB->NQTD > 0
		IF lTFLogError
			cTEXTO1 := MEMOREAD(cGet1)
			cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - Pedido já existe na filial 02 no campo c5_numori " + CNUMPED + ENTER
			MEMOWRITE(cGet1,cTEXTO1)
		ENDIF

		IF !LAUTO
			MSGINFO("Já existe uma Cópia do Pedido no CD de MG!" + ENTER + "Entre em contato com o Departamento de TI.","Cópia para CD de MG")
		ENDIF
		RETURN

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Inicio do Processo de Cópia do Pedido
	|---------------------------------------------------------------------------------
	*/
	CURSORWAIT()

	CQUERY := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_TIPO, SA1.A1_TABELA, SA1.A1_TRANSP FROM " + RETSQLNAME("SA1") + " SA1 WHERE SA1.A1_FILIAL = '02' AND SA1.A1_CGC = (SELECT M0_CGC FROM SM0_COMPANY WHERE M0_CODIGO = '" + CEMPANT + "' AND M0_CODFIL = '" + CFILANT + "') AND SA1.D_E_L_E_T_ = ''"
	IF SELECT("TMP") > 0
		DBSELECTAREA("TMP")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()
	COUNT TO NREGS

	IF NREGS > 0
		IF lTFLogError
			cTEXTO1 := MEMOREAD(cGet1)
			cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - Passou pelo controle de transportadora " + CNUMPED + ENTER
			MEMOWRITE(cGet1,cTEXTO1)
		ENDIF

		TMP->(DBGOTOP())
		/*
		Tratamento especifico para quando há cliente atendido por transportadora 
		diferente do cadastro do cliente de CROSS DOCKING
		Ex.: ATIVA ou FRIBURGO
		*/
		cC5transp := SC5->C5_TRANSP
		cA1transp := TMP->A1_TRANSP

		cC5trcnpj := ""
		cA1trcnpj := ""

		SA4->(DbSetOrder(1))
		If SA4->(DbSeek( xFilial("SA4") + cC5transp ))
			cC5trcnpj := LEFT(SA4->A4_CGC,6)
		EndIf
		If SA4->(DbSeek( xFilial("SA4") + cA1transp ))
			cA1trcnpj := LEFT(SA4->A4_CGC,6)
		EndIf
		If cA1trcnpj != cC5trcnpj
			SA4->(DbSetOrder(3))
			SA4->(DbSeek( xFilial("SA4") + cC5trcnpj ))
			While !SA4->(Eof()) .AND. LEFT(SA4->A4_CGC,6) = cC5trcnpj
				If SA4->A4_EST = "MG" .AND. SA4->A4_MSBLQL="2"
					cA1transp := SA4->A4_COD
				EndIf
				SA4->(DbSkip())
			End
		EndIf
		/* -----------------[ fim tratamento transportadora ]-----------------*/

		/*
		|---------------------------------------------------------------------------------
		|	PRENCHIMENTO DO CABECALHO DO PEDIDO DE VENDA - COPIA PARA CROSSDOCKING
		|	UTILIZANDO O CLIENTE TAIFFPROART MATRIZ
		|---------------------------------------------------------------------------------
		*/
		AADD(ACABSC5,{"C5_TIPO"		,SC5->C5_TIPO			})
		AADD(ACABSC5,{"C5_CLIENTE"	,TMP->A1_COD			})
		AADD(ACABSC5,{"C5_TIPOCLI"	,TMP->A1_TIPO			})
		AADD(ACABSC5,{"C5_CLIENT"	,TMP->A1_COD 	     	})

		IF LAUTO
			AADD(ACABSC5,{"C5_LOJACLI"	,"01"				})
			AADD(ACABSC5,{"C5_LOJAENT"	,"01"				})
		ELSE
			AADD(ACABSC5,{"C5_LOJACLI"	,TMP->A1_LOJA		})
			AADD(ACABSC5,{"C5_LOJAENT"	,TMP->A1_LOJA		})
		ENDIF

		AADD(ACABSC5,{"C5_EMISSAO"	,DDATABASE				})
		AADD(ACABSC5,{"C5_VEND1"	,SC5->C5_VEND1			})
		AADD(ACABSC5,{"C5_DESC1"	,SC5->C5_DESC1			})
		AADD(ACABSC5,{"C5_TPFRETE"	,"C"					})
		AADD(ACABSC5,{"C5_FINALID"	,"2"					})
		AADD(ACABSC5,{"C5_INTER"  	,"S"					})
		AADD(ACABSC5,{"C5_CLASPED"	,SC5->C5_CLASPED		})
		AADD(ACABSC5,{"C5_FILDES"	,SC5->C5_FILDES			})
		AADD(ACABSC5,{"C5_PCFRETE"	,SC5->C5_PCFRETE		})
		AADD(ACABSC5,{"C5_EMPDES"	,SC5->C5_EMPDES			})
		AADD(ACABSC5,{"C5_ESPECI1"	,"CAIXA"				})
		AADD(ACABSC5,{"C5_OBSERVA"	,SC5->C5_OBSERVA		})
		AADD(ACABSC5,{"C5_MENNOTA"	,IIF( AT("PEDIDO PORTAL: ",SC5->C5_MENNOTA) != 0 ,SC5->C5_MENNOTA,"PEDIDO PORTAL: " + SC5->C5_NUMOLD + ENTER + SC5->C5_MENNOTA)	})
		AADD(ACABSC5,{"C5_XLIBCR"	,SC5->C5_XLIBCR			})
		AADD(ACABSC5,{"C5_NUMOLD"	,SC5->C5_NUMOLD			})
		AADD(ACABSC5,{"C5_XITEMC"	,SC5->C5_XITEMC			})
		AADD(ACABSC5,{"C5_NUMORI"	,SC5->C5_NUM			})
		AADD(ACABSC5,{"C5_CLIORI"	,SC5->C5_CLIENTE		})
		AADD(ACABSC5,{"C5_LOJORI"	,SC5->C5_LOJACLI		})
		AADD(ACABSC5,{"C5_NOMORI"	,SC5->C5_NOMCLI			})
		AADD(ACABSC5,{"C5_FATFRAC"	,SC5->C5_FATFRAC		})
		AADD(ACABSC5,{"C5_FATPARC"	,SC5->C5_FATPARC		})
		AADD(ACABSC5,{"C5_DTPEDPR"	,SC5->C5_DTPEDPR		})
		AADD(ACABSC5,{"C5_NUMOC"	,"CROSS"				}) // Texto simples que dará apoio ao processo de Recebimento Cross Docking
		AADD(ACABSC5,{"C5_TABELA"	,SC5->C5_TABELA			})
		AADD(ACABSC5,{"C5_CONDPAG"	,SC5->C5_CONDPAG		})
		AADD(ACABSC5,{"C5_PCTFEIR"	,SC5->C5_PCTFEIR		})
		AADD(ACABSC5,{"C5_TPPCTFE"	,SC5->C5_TPPCTFE		})
		AADD(ACABSC5,{"C5_NOMCLI"	,SC5->C5_NOMCLI			})
		AADD(ACABSC5,{"C5_X_PVBON"	,SC5->C5_X_PVBON		})
		AADD(ACABSC5,{"C5_USRBNF"	,SC5->C5_USRBNF			})
		AADD(ACABSC5,{"C5_OBSBNF"	,SC5->C5_OBSBNF			})
		AADD(ACABSC5,{"C5_BNFLIB"	,SC5->C5_BNFLIB			})
		AADD(ACABSC5,{"C5_TRANSP"	,cA1transp				})

		ACABSC5 := U_FCARRAYEXEC("SC5",ACABSC5,.F.)
		ADETSC6 := {}

		cPedPortalTa	:= SC5->C5_NUMOLD
		cLibCredito	:= SC5->C5_XLIBCR    //GUARDA O FLAG DE LIBERACAO DE CREDITO DO PEDIDO ORIGINAL APOS A ROTINA DE LIBERACAO DE CREDITO - 14/05/19
		cClasPedido	:= SC5->C5_CLASPED
		cPVBONumold	:= SC5->C5_X_PVBON

		DBSELECTAREA("SC6")
		DBSETORDER(1)

		IF !LAUTO
			DBSEEK(XFILIAL("SC6") + CNUMPED)
		ELSE
			DBSEEK("01" + CNUMPED)
		ENDIF

		WHILE SC6->(!EOF()) .AND. SC6->C6_NUM = CNUMPED
			DBSELECTAREA("SX3")
			DBSETORDER(1)
			DBSEEK("SC6")
			WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = "SC6"
				If AT( ALLTRIM(SX3->X3_CAMPO) , 'C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_UM|C6_LOCAL|C6_DESCRI|C6_TES|C6_CLI|C6_LOJA|C6_XITEMC|C6_PRCVEN|C6_VALOR|C6_PRUNIT|C6_ENTREG' ) != 0
					IF X3USO(SX3->X3_USADO) .OR. SX3->X3_PROPRI = "U"
						AADD(ATMPSC6,{SX3->X3_CAMPO,&(SX3->X3_ARQUIVO + "->" + ALLTRIM(SX3->X3_CAMPO)),NIL})
					ENDIF
				EndIf
				SX3->(DBSKIP())
			ENDDO

			/*
			|---------------------------------------------------------------------------------
			|	CASO O CAMPO DE OPERACAO NAO ESTEJA NO HEADER O MESMO EH INFORMADO PARA 
			|	QUE SEJA REALIZADO O CALCULO DE IMPOSTOS CORRETAMENTE.
			|---------------------------------------------------------------------------------
			*/
			NREGS := ASCAN(ATMPSC6,{|X| ALLTRIM(X[1]) = "C6_XOPER"})
			IF NREGS <= 0
				AADD(ATMPSC6,{"C6_XOPER","V6",NIL})
			ELSE
				ATMPSC6[NREGS][2] := "V6"
			ENDIF

			NREGS := ASCAN(ATMPSC6,{|X| ALLTRIM(X[1]) = "C6_LOCAL"})
			If NREGS > 0
				ATMPSC6[NREGS][2] := "21"
			EndIf

			AADD(ADETSC6,ATMPSC6)
			ATMPSC6 := {}
			SC6->(DBSKIP())
		ENDDO

		IF !LAUTO

			SM0->(DBSEEK("0302"))
			cFilAnt := "02"
			SLEEP(1500)
		ENDIF

		NPOSPROD		:= ASCAN(ADETSC6[1],{|X| ALLTRIM(X[1]) == "C6_PRODUTO"})
		NPOSITEM		:= ASCAN(ADETSC6[1],{|X| ALLTRIM(X[1]) == "C6_XITEMC"})

		FOR I := 1 TO LEN(ADETSC6)

			SB1->(DBSETORDER(1))  
			SB1->(DBSEEK(XFILIAL("SB1") + PadR(ADETSC6[I,NPOSPROD,2],15), .F.))

			/*
			|---------------------------------------------------------------------------------
			|	CRIA SB2 / SBE / SBF - CASO NAO TENHA PARA O PRODUTO
			|---------------------------------------------------------------------------------
			*/		
			CRIASB2( PadR(ADETSC6[I,NPOSPROD,2],15) , "21" )

			// 
			// Removida a chamada da criação do endereço EXP uma vez que passamos a utilizar endereços por produto
			// Data: 04/01/2021
			// Autor: Carlos Torres
			//
			SBE->(DBSETORDER(1))  //CADASTRO DE ENDERECOS
			IF !SBE->(DBSEEK(XFILIAL("SBE") + "21" + SUBSTRING(SB1->B1_YENDEST + SPACE(TamSX3("BF_LOCALIZ")[1]),1,TamSX3("BF_LOCALIZ")[1]), .F.))
				SBE->(RECLOCK("SBE", .T.))
				SBE->BE_FILIAL := XFILIAL("SBE")
				SBE->BE_LOCAL  := "21"
				SBE->BE_LOCALIZ:= SB1->B1_YENDEST
				SBE->BE_DESCRIC:= "EXPEDICAO " + ALLTRIM(ADETSC6[I,NPOSITEM,2])
				SBE->BE_PRIOR  := "ZZZ"
				SBE->BE_STATUS := "1"
				SBE->(MSUNLOCK())
			ENDIF

		NEXT I

		LMSERROAUTO := .F.
		BEGIN TRANSACTION

			SA4->(DbSetOrder(1))
			SA4->(DbSeek( xFilial() + ALLTRIM(cA1transp) ))

			MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},ACABSC5,ADETSC6,3)
			IF LMSERROAUTO

				IF lTFLogError
					cTEXTO1 := MEMOREAD(cGet1)
					cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - erro ao tentar gerar no CD Extrema para pedido: " + CNUMPED + ENTER
					//cTEXTO1 += MostraErro()
					CNOMELOG := "IMPSALES_GERACROSS_ERRO_NO_PEDIDO_" + Alltrim(CNUMPED) + ".LOG"
					MOSTRAERRO("\SYSTEM\",CNOMELOG)
					MEMOWRITE(cGet1,cTEXTO1)
				ENDIF

				DISARMTRANSACTION()
				CURSORARROW()
				IF !LAUTO
					MSGALERT(OEMTOANSI(	"Erro ao tentar gerar cópia de Pedido de Vendas!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
				ENDIF
				//MOSTRAERRO()
			ELSE
				IF lTFLogError
					cTEXTO1 := MEMOREAD(cGet1)
					cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - processamento sem erro no CD Extrema para pedido: " + CNUMPED + ENTER
					MEMOWRITE(cGet1,cTEXTO1)
				Endif
			ENDIF

		END TRANSACTION

		//Atualiza o campo C5_XLIBCR do Pedido gerado no CD EXTREMA - FORCA GRAVACAO COM O MESMO STATUS DO PEDIDO ORIGINAL - 14/05/2019
		_cQuery   := "UPDATE " + RETSQLNAME("SC5") + "  SET "
		_cQuery   += "C5_XLIBCR = '"+cLibCredito+"' "
		_cQuery   += "WHERE C5_FILIAL = '02' AND C5_NUMORI = '" + CNUMPED + "' "
		_cQuery   += "AND D_E_L_E_T_ = '' "
		TCSQLExec(_cQuery)

		//
		// Atualiza o status de credito do pedido de bonificação quando da importação do pedido de venda
		//
		IF 1=2 //cClasPedido = "V"

			_cQuery := "SELECT NUMSALES AS BONIFICA "
			_cQuery += "FROM INTEGRACAOOSC.dbo.PEDIDO WITH(NOLOCK) "
			_cQuery += "WHERE OPER = 'V5' "
			_cQuery += " AND ISNULL(D_E_L_E_T_,'') = '' "
			_cQuery += " AND PEDVENDASSOCIADO = " + cPVBONumold

			If Select("SQLSAES") > 0
				SQLSAES->( dbCloseArea() )
			EndIf

			dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,_cQuery),"SQLSAES", .F., .T.)

			SQLSAES->(DbGoTop())
			While .NOT. SQLSAES->(Eof())

				cPVBONumold := SQLSAES->BONIFICA
				AADD(aPedBonifica,{ ALLTRIM(cPVBONumold) })

				SQLSAES->(DbSkip())
			End
			SQLSAES->( dbCloseArea() )

			For nLoopBonif := 1 To LEN(aPedBonifica)

				cPVBONumold := aPedBonifica[nLoopBonif][1]

				_cQuery   := "UPDATE SC5 SET"
				_cQuery   += "		C5_XLIBCR = '"+cLibCredito+"' "
				_cQuery   += "FROM " + RETSQLNAME("SC5") + " SC5 "
				_cQuery   += "WHERE SC5.C5_NUMOLD = '" + ALLTRIM(cPVBONumold) + "' "
				_cQuery   += "		AND SC5.D_E_L_E_T_ = '' "
				_cQuery   += "		AND SC5.C5_CLASPED='X' "
				_cQuery   += "		AND SC5.C5__BLOQF ='' " // <-- caso esteja em branco é por que ainda não passou por analise de estoque
				TCSQLExec(_cQuery)

				IF lTFLogError
					cTEXTO1 := MEMOREAD(cGet1)
					cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - UPDATE de atualizacao do C5_XLIBCR para " + cLibCredito + " no pedido (numold) " + cPVBONumold + ENTER
					MEMOWRITE(cGet1,cTEXTO1)
				ENDIF
			Next
		ENDIF

		//
		// Atualiza o status de credito do pedido de bonificação quando da importação do pedido de bonificação
		//
		IF 1=2 //cClasPedido = "X"
			_cQuery   := "UPDATE SC5  SET "
			_cQuery   += "		C5_XLIBCR = (CASE WHEN SC5.C5_X_PVBON != '' THEN ISNULL((SELECT MAX(C5_XLIBCR) FROM SC5030 SC5VEN WITH(NOLOCK) WHERE SC5VEN.C5_NUMOLD = RTRIM(LTRIM(SC5.C5_X_PVBON)) AND SC5VEN.C5_CLASPED='V'),'') ELSE '" + cLibCredito + "' END )"
			_cQuery   += "FROM " + RETSQLNAME("SC5") + " SC5 "
			_cQuery   += "WHERE SC5.C5_NUMOLD = '" + cPedPortalTa + "' "
			_cQuery   += "		AND SC5.D_E_L_E_T_ = '' "
			_cQuery   += "		AND SC5.C5_CLASPED='X' "
			_cQuery   += "		AND SC5.C5__BLOQF ='' " // <-- caso esteja em branco é por que ainda não passou por analise de estoque
			TCSQLExec(_cQuery)
			IF lTFLogError
				cTEXTO1 := MEMOREAD(cGet1)
				cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - UPDATE de atualizacao do C5_XLIBCR para o pedido (numold) " + cPedPortalTa + ENTER
				MEMOWRITE(cGet1,cTEXTO1)
			ENDIF
		ENDIF

		/*
		A função padrão CodSitTri() está gravando em C6_CALSFIS indevidamente a origem do ultimo item do pedido 
		para todos os itens nos pedidos criados em EXTREMA para o PROTHEUS 12
		Isto ocorre apenas no processo do CROSSDOCKING já que não utilizamos a funcionalidade RPC 
		*/
		DBSELECTAREA("SC5")
		DBORDERNICKNAME("SC5NUMOLD")
		If DBSEEK( "02" + ALLTRIM( cPedPortalTa ))

			_cQuery   := "UPDATE SC6 SET "
			_cQuery   += "		C6_CLASFIS = B1_ORIGEM + RIGHT(C6_CLASFIS,2) "
			_cQuery   += "FROM " + RETSQLNAME("SC6") + " SC6 "
			_cQuery   += "INNER JOIN " + RETSQLNAME("SC5") + " SC5 "
			_cQuery   += "		ON C5_FILIAL=C6_FILIAL"
			_cQuery   += "		AND C5_NUM=C6_NUM"
			_cQuery   += "		AND SC5.D_E_L_E_T_ = '' "
			_cQuery   += "		AND C5_NUMOLD='" + cPedPortalTa + "' "
			_cQuery   += "INNER JOIN " + RETSQLNAME("SB1") + " SB1 "
			_cQuery   += "		ON B1_FILIAL=C6_FILIAL "
			_cQuery   += "		AND B1_COD=C6_PRODUTO "
			_cQuery   += "		AND SB1.D_E_L_E_T_ = '' "
			_cQuery   += "WHERE C6_FILIAL='02' "
			_cQuery   += "		AND SC6.D_E_L_E_T_ = ''

			TCSQLExec(_cQuery)

		EndIf

		LRET := LMSERROAUTO

		IF !LAUTO
			SM0->(DBSEEK("0301"))
			cFilAnt := "01"
			SLEEP(1500)
		ENDIF

		DBSELECTAREA("SC5")
		DBGOTO(AAREASC5[3])

		RECLOCK("SC5",.F.)
		IF LRET
			SC5->C5_STCROSS = 'ERRCOP'
		ELSE
			SC5->C5_STCROSS = 'ABERTO'
		ENDIF
		MSUNLOCK()

		CURSORARROW()

	ELSE
		IF lTFLogError
			cTEXTO1 := MEMOREAD(cGet1)
			cTEXTO1 += "Linha: " + alltrim(str(procline())) + " - NAO passou pelo controle de transportadora " + CNUMPED + ENTER
			MEMOWRITE(cGet1,cTEXTO1)
		ENDIF

		CURSORARROW()
		IF !LAUTO
			MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")
		ENDIF
		RECLOCK("SC5",.F.)
		SC5->C5_STCROSS = 'ERRCOP'
		MSUNLOCK()

	ENDIF

RETURN
User Function A730HNUT
	Local nRetHNaoUtil  := 0
	Local dData   := PARAMIXB[1] // Data a ser analisada
	If DTOS(dData) == '20060421'
		nRetHNaoUtil := 8
	EndIf
Return nRetHNaoUtil
