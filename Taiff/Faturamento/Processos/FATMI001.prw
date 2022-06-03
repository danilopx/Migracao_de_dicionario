#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "AP5MAIL.CH"
#include "TbiCode.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATMI001  ºAutor  ³Daniel Ruffino      º Data ³  17/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Realiza a Importação de Pedidos da WEB para Orçamentos     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATMI001(cEmpSch,cFilialSch,cMarcaSch)                

	Local cSemaforo 
	Local oObj           
	Local i			:= 0

	LOCAL ODLG
	LOCAL OSAY01
	LOCAL CSAY01		:= "Marca"
	LOCAL OBTN
	LOCAL LOK			:= .F.
	LOCAL CMI01MARCA	:= SPACE(009)
	LOCAL AMARCAS		:= {"TAIFF","PROART"}
	Local cEmail		:= "grp_sistemas@taiff.com.br"


	Private lWeb	:= .F.		//CONTROLA SE ESTA SENDO EXECUTADO PELO SCHEDULE
	Private cCabEmail := ""
	Private AHEADER

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

			/* Em 25/04/2019 foi implementada validação do parametro TAIFF    */
			/* Para evitar conflito entre rotina de importação TAIFF e PROART */
			lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA

		ElseIf LEFT(cMarcaSch,1)="T" 
			lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		EndIf

		If lImporta
			U_2EnvMail("workflow@taiff.com.br", RTrim(cEmail) ,""," *** ATENCAO *** revisar parametro MV__FTMI0T" , "Importação automatica " + PROCNAME() ,'')
		Else		
			//PutMv("MV__FTMI01","S")
			If LEFT(cMarcaSch,1)="P" 
				PutMv("MV__FTMI0P","S")
				PutMv("MV__FTMI0T","S")
			ElseIf LEFT(cMarcaSch,1)="T" 
				PutMv("MV__FTMI0T","S")
			EndIf

			cSemaforo := AllTrim(cEmpAnt) + xFilial("SA1") + FunName() + LEFT(cMarcaSch,1)
			lWeb := .T.
			_aNomeBanco	:= StrTokArr(GETMV("PRT_SEP000"), "/") 
			cUnidNeg		:= SuperGetMV("MV_UNIDNEG", .F., "")

			titulo      	:= "FATMI001 - Inicio Importacao Orçamento Empresa "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL

			If (Time() >= "08:00:00" .AND. Time() <= "08:30:00")
				RESET ENVIRONMENT
				Return
			EndIf 

			For i := 1 To Len(_aNomeBanco)   // Se for TaiffProart - Extrema, deverá importar de dois Bancos do Portal de Vendas
				_sNomeBanco := _aNomeBanco[i]
				If (cMarcaSch="TAIFF" .AND. i=1) .OR. (cMarcaSch="PROART" .AND. i=2)
					Processar()
				EndIf					
			Next

			titulo      	:= "FATMI001 - Fim da Importacao Orçamento Empresa "+AllTrim(SM0->M0_NOME)+"/"+ALLTRIM(SM0->M0_FILIAL)
			//PutMv("MV__FTMI01","N")
			If LEFT(cMarcaSch,1)="P" 
				PutMv("MV__FTMI0P","N")
				PutMv("MV__FTMI0T","N")
			ElseIf LEFT(cMarcaSch,1)="T" 
				PutMv("MV__FTMI0T","N")
			EndIf
				
		EndIf
			RESET ENVIRONMENT
	Else
		_aNomeBanco	:= StrTokArr(GETMV("PRT_SEP000"), "/") 
		cUnidNeg		:= SuperGetMV("MV_UNIDNEG", .F., "")
		cSemaforo := AllTrim(cEmpAnt) + xFilial("SA1") + FunName()

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

			ODLG 	:= MSDIALOG():NEW(001,001,230,300,'Filtro de Importação',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
			OCMB01 := TCOMBOBOX():NEW(010		,060		, {|U| IF(PCOUNT()>0,CMI01MARCA:=U,CMI01MARCA)}	,AMARCAS		,060			,009			,ODLG		,				,				,				,				,				,.T.			,				,				,				,				,				,				,				,				,'CMI01MARCA')
			OBTN 	:= TBUTTON():NEW(090,010,'OK'			,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
			OBTN 	:= TBUTTON():NEW(090,100,'Cancelar'	,ODLG,{||ODLG:END()},40,10,,,,.T.)
			
			ODLG:ACTIVATE(,,,.T.)
			
			IF LOK	
	
				//lImporta := Iif(GetMV("MV__FTMI01")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				If LEFT(CMI01MARCA,1)="P" 
					lImporta := Iif(GetMV("MV__FTMI0P")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				ElseIf LEFT(CMI01MARCA,1)="T" 
					lImporta := Iif(GetMV("MV__FTMI0T")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
				EndIf
				
				If lImporta
					MsgStop("Rotina importacao orcamentos ja esta sendo executada - FATMI001")
				Else		
					//PutMv("MV__FTMI01","S")
					If LEFT(CMI01MARCA,1)="P" 
						PutMv("MV__FTMI0P","S")
					ElseIf LEFT(CMI01MARCA,1)="T" 
						PutMv("MV__FTMI0T","S")
					EndIf
	
					If MsgYesNo("Inicia importacao dos pedidos de venda do novo Portal?")     
						
						For i := 1 To Len(_aNomeBanco) Step 1  // Se for TaiffProart - Extrema, deverá importar de dois Bancos do Portal de Vendas
							If (CMI01MARCA="TAIFF" .AND. i=1) .OR. (CMI01MARCA="PROART" .AND. i=2)
								_sNomeBanco := _aNomeBanco[i]
								oObj := MsNewProcess():New({|lEnd| Processar(oObj, @lEnd)}, "", "", .T.)
								oObj :Activate()
							EndIf
						Next
	
					EndIf      
	
					UnLockByName(cSemaforo,.T.,.T.,.T.)
					//PutMv("MV__FTMI01","N")
					If LEFT(CMI01MARCA,1)="P" 
						PutMv("MV__FTMI0P","N")
					ElseIf LEFT(CMI01MARCA,1)="T" 
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATMI001  ºAutor  ³Daniel Ruffino      º Data ³  17/10/12   º±±
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
	Local _cCodUser	:= ""
	Local _cEstacao	:= ""
	Local _cOperac		:= ""
	Local _cOper		:= ""
	Local _vClasPed   := "V"
	Local _nQtdReg		:= 0
	Local _PedBonif		:= ""
	Local cMensImp		:= ""
	Local cMensErr		:= ""
	Local nTotalPed		:= 0
	Local nTotGeral		:= 0
	Default lEnd 		:= .F. 

	Private _cPSC5		:= ""

	lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SELECIONA INFORMAçõES DOS PEDIDOS PENDENTES DE IMPORTAçãO DO PORTAL      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	_cQuery += " SC5.C5_OBSERVA AS C5_OBSERVA, " + ENTER
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

	_cQuery += " ISNULL(SC5.C5_PCR2PED, 0) AS C5_PCR2PED, " + ENTER
	_cQuery += " ISNULL(SC5.C5_VLR2PED, 0) AS C5_VLR2PED, " + ENTER
	_cQuery += " ISNULL(SC5.C5_PCBONIPED, 0) AS C5_PCBOPED, " + ENTER
	_cQuery += " ISNULL(SC5.C5_VLVBPRPED, 0) AS C5_VBPRPED, " + ENTER
	_cQuery += " ISNULL(SC5.C5_PCFRETE, 0) AS C5_PCFRETE, " + ENTER
	_cQuery += " ISNULL(SC5.C5_PCVBCONTRPED, 0) AS C5_PCVBCTR, " + ENTER

	_cQuery += " SC5.C5_EMPDES AS C5_EMPDES, " + ENTER  // EMPRESA DESTINO (UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
	_cQuery += " SC5.C5_FILDES AS C5_FILDES, " + ENTER  // FILIAL DESTINO(UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
	_cQuery += " SC5.C5_OPER AS C5_OPER, " + ENTER  // TIPO DE OPERAçãO (V3 = VENDAS / V5 = BONIFICAçãO)
	_cQuery += " SC5.C5_PCTFEIR AS C5_PCTFEIR, " + ENTER  // SE É PACOTE DA FEIRA (S/N)
	_cQuery += " SC5.C5_TPPCTFE AS C5_TPPCTFE, " + ENTER  // CÓDIGO DO PACOTE
	_cQuery += " SC5.C5_XITEMC AS C5_XITEMC " + ENTER  // UNIDADE DE NEGÓCIO

	_cQuery += " FROM " + _sNomeBanco + "SC5   " + ENTER

	_cQuery += " WHERE ISNULL(SC5.D_E_L_E_T_, '') = '' " + ENTER
	_cQuery += "   AND ISNULL(SC5.C5_IMP_PED, '') = '' " + ENTER
	_cQuery += "   AND SC5.C5_STSPED = '8' " + ENTER

	/*
	If (cFilAnt == "01" .AND. cUnidNeg == "TAIFF") //FILIAL 01 - TAIFFPROART - MATRIZ (IMPORTA SOMENTE TAIFF E PEDIDOS DE SÃO PAULO)                                           
	_cQuery += "   AND SC5.C5_XITEMC = '" + cUnidNeg + "' " + ENTER
	_cQuery += "   AND SC5.C5_FILDES = '" + cFilAnt + "' " + ENTER
	ElseIf (cFilAnt == "02" .AND. "PROART" $ cUnidNeg .AND. "TAIFF" $ cUnidNeg)  //FILIAL 02 - TAIFFPROART - EXTREMA (IMPORTA OS TAIFF DA PRóPRIA FILIAL (EXTREMA) E PROART DE TODAS AS FILIAIS)
	_cQuery += "   AND ((SC5.C5_FILDES IN ('01', '02') AND SC5.C5_XITEMC = 'PROART') " + ENTER		
	_cQuery += "    OR (SC5.C5_FILDES = '" + cFilAnt + "' AND SC5.C5_XITEMC = 'TAIFF')) " + ENTER
	EndIf
	*/

	// AGORA OS PEDIDOS SERÃO IMPORTADO PARA ONDE SERÃO FATURADOS
	_cQuery += "   AND SC5.C5_FILDES = '" + cFilAnt + "' " + ENTER
	
	//_cQuery += "	AND SC5.C5_NUMPRE=66119 "
	
	_cQuery += " ORDER BY SC5.C5_NUMPRE  " + ENTER

	_cQuery := ChangeQuery( _cQuery )
	//MemoWrite("FATMI001-LEPEDIDOS.sql",_cQuery)
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

		_vClasPed := IIF ((_cPSC5)->C5_OPER = "V5", "X", "V")

		__cXNUMOLD := Alltrim((_cPSC5)->C5_NUMPRE) + Substring((_cPSC5)->C5_XITEMC,1,1)
		/*
		|---------------------------------------------------------------------------------
		|	REALIZA A ANALISE DA TABELA DE PEDIDOS ASSOCIADOS
		|---------------------------------------------------------------------------------
		*/				
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

		_aCab :={	{"CJ_CLIENTE"	,(_cPSC5)->C5_CLIENTE			, NIL},;  // Codigo do cliente
		{"CJ_LOJA"		,(_cPSC5)->C5_LOJACLI       	, Nil},;  // Loja do cliente
		{"CJ_CLIENT"	,IIF(Empty((_cPSC5)->C5_CLIENT)		, (_cPSC5)->C5_CLIENTE,(_cPSC5)->C5_CLIENT)		, NIL},;  // Se não tiver cliente de Entrega preenche com o cliente
		{"CJ_LOJENT"	,IIF(Empty((_cPSC5)->C5_LOJAENT) 	, (_cPSC5)->C5_LOJACLI,(_cPSC5)->C5_LOJAENT)	, NIL},;  // Loja para entrada Entrega
		{"CJ_CONDPAG"	,(_cPSC5)->C5_CONDPAG     		, Nil},;  // Codigo da condicao de pagamanto*
		{"CJ_XTIPCLI"	,(_cPSC5)->C5_TIPOCLI       	, Nil},;  // Tipo de Cliente
		{"CJ_XTIPO"	   	,(_cPSC5)->C5_TIPO				, Nil},; // Tipo de pedido
		{"CJ_DESC1"  	,(_cPSC5)->C5_DESC1        		, Nil},;  // Percentual de Desconto
		{"CJ_XINCISS" 	,(_cPSC5)->C5_INCISS        	, Nil},;  // ISS Incluso
		{"CJ_XTIPLIB" 	,(_cPSC5)->C5_TIPLIB        	, Nil},;  // Tipo de Liberacao
		{"CJ_MOEDA"  	,(_cPSC5)->C5_MOEDA       		, Nil},;  // Moeda
		{"CJ_XTRANSP" 	,(_cPSC5)->C5_TRANSP			, Nil},;  // Transportadora
		{"CJ_XTPFRTE"	,(_cPSC5)->C5_TPFRETE			, Nil},;  // Tipo do Frete
		{"CJ_FRETE"  	,(_cPSC5)->C5_FRETE				, Nil},;  // Valor do Frete
		{"CJ_XPESOL"  	,(_cPSC5)->C5_PESOL 			, Nil},;  // Peso Liquido
		{"CJ_XPBRUTO" 	,(_cPSC5)->C5_PBRUTO   			, Nil},;  // Peso Bruto
		{"CJ_VXOLUM1"	,(_cPSC5)->C5_VOLUME1			, Nil},;  // Volume
		{"CJ_XNUMOLD" 	,__cXNUMOLD						, Nil},;  // Numero do pedido
		{"CJ_XESPEC1"	,(_cPSC5)->C5_ESPECI1  			, Nil},;  // Especie
		{"CJ_XVEND1"  	,(_cPSC5)->C5_VEND1	   			, Nil},;  // Vendedor
		{"CJ_TABELA" 	,(_cPSC5)->C5_TABELA			, Nil},;  // Tabela de Preço
		{"CJ_XFATFRC"  	,(_cPSC5)->C5_FATFRAC			, Nil},;  // Caixa Fracionada (S/N)
		{"CJ_XFATPAC"  	,(_cPSC5)->C5_FATPARC			, Nil},;  // Faturamento Parcial (S/N)
		{"CJ_XOBSERV" 	,AllTrim((_cPSC5)->C5_OBSERVA)	, Nil},;  // Observação
		{"CJ_XCLASPD" 	,_vClasPed			   			, Nil},;  // Classificação do pedido
		{"CJ_XDTIMP"	,_dataImp					    , Nil},;  // Data da importação do pedido
		{"CJ_XHRIMP"	,_horaImp					    , Nil},;  // Horário da importação do pedido
		{"CJ_XDTPDPR" 	,STOD((_cPSC5)->C5_DTPEDPR)		, Nil},;  // Data do pedido programado
		{"CJ_XDTAPPO" 	,STOD((_cPSC5)->C5_DTAPPO)		, Nil},;  // Data da aprovação do pedido no Portal
		{"CJ_XHRAPPO"	,(_cPSC5)->C5_HRAPPO			, Nil},;  // Horário da aprovação do pedido no Portal
		{"CJ_XPCR2PD"	,(_cPSC5)->C5_PCR2PED	    	, Nil},;  // PERCENTUAL DE R2 DO PEDIDO (NECESSIDADE DE GRAVAR NO MOMENTO DA APROVAÇÃO DO PEDIDO)
		{"CJ_XVLR2PD" 	,(_cPSC5)->C5_VLR2PED	      	, Nil},;  // VALOR DE R2 DO PEDIDO (NECESSIDADE DE CRIAR O CAMPO NO PORTAL TAMBÉM, E GRAVA-LO NO MOMENTO DA APROVAÇÃO)
		{"CJ_XPCBOPD"	,(_cPSC5)->C5_PCBOPED	    	, Nil},;  // PERCENTUAL DE BONIFICAÇÃO DO PEDIDO
		{"CJ_XVBPRPD"	,(_cPSC5)->C5_VBPRPED	      	, Nil},;  // VALOR DA VERBA PROMOCIONAL DIGITADA NO PEDIDO
		{"CJ_PCFRET"	,(_cPSC5)->C5_PCFRETE	      	, Nil},;  // PERCENTUAL DE FRETE DO PEDIDO
		{"CJ_XPCVBCT"	,(_cPSC5)->C5_PCVBCTR	      	, Nil},;  // PERCENTUAL DA VERBA CONTRATUAL DO PEDIDO
		{"CJ_XLIBCR"	,"P"							, Nil},;  // Orçamento nasce com a liberação de credito como pendente.
		{"CJ_TPCARG"	,'1'						   	, Nil},;  // Carga                                                    
		{"CJ_EMPDES"	,(_cPSC5)->C5_EMPDES			, Nil},;  // EMPRESA DESTINO (UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)
		{"CJ_FILDES"	,(_cPSC5)->C5_FILDES	   		, Nil},;  // FILIAL DESTINO(UTILIZADO NA CUSTOMIZAÇÃO DE ATENDIMENTO NOS CDS)                                                     
		{"CJ_PCTFEIR"	,(_cPSC5)->C5_PCTFEIR   		, Nil},;  // SE É OU NÃO PACOTE ESPECIAL DA FEIRA                                                    
		{"CJ_TPPCTFE"	,(_cPSC5)->C5_TPPCTFE   		, Nil},;  // QUAL O CÓDIGO DO PACOTE DA FEIRA	
		{"CJ_X_PVBON"	,_PEDBONIF   					, Nil},;  // PEDIDOS ASSOCIADOS REFERENTE A BONIFICACAO
		{"CJ_XITEMC"	,IIF((_cPSC5)->C5_XITEMC = "VIS", "TAIFF", (_cPSC5)->C5_XITEMC)						, Nil}}  // UNIDADE DE NEGÓCIO (SE FOR VIS, MUDA PARA TAIFF, POIS NAO EXISTE UNIDADE DE NEGOCIO VIS)

		//Faz consulta dos Itens do pedido no portal do representante.
		_cQuery := "SELECT SC6.* " + ENTER 
		_cQuery += "FROM " + _sNomeBanco + "SC6 " + ENTER
		_cQuery += "WHERE C6_NUMPRE = '" + (_cPSC5)->C5_NUMPRE + "' AND ISNULL(D_E_L_E_T_, '') = '' " + ENTER
		_CQUERY += "ORDER BY C6_NUMPRE, C6_ITEM " + ENTER
		_cQuery := ChangeQuery( _cQuery )

		//MemoWrite("FATMI001-LEITENS.sql",_cQuery)
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
			_cOper := (_cPSC6)->C6_OPER                                                                               

			// Manter a busca da TES pela função MaTesInt já que o gatilho padrão do "Tipo de Operação" (CK_OPER) 
			// não sobrepõe qualquer TES colocada na matriz. E nem o gatilho do CK_XOPER ativa a TES inteligente do CK_OPER
			// Autor: CT																Data: 03/09/2014
			cTES := MaTesInt(2,_cOper,(_cPSC5)->C5_CLIENTE,(_cPSC5)->C5_LOJACLI,"C",PadR((_cPSC6)->C6_PRODUTO,15),"C6_TES")
			/*
			|---------------------------------------------------------------------------------
			|	CRIA SB2 / SBE / SBF - CASO NAO TENHA PARA O PRODUTO
			|---------------------------------------------------------------------------------
			*/
			CRIASB2( PadR((_cPSC6)->C6_PRODUTO,15) , "21" )			

			SBE->(DBSETORDER(1))  //CADASTRO DE ENDERECOS
			SBE->(DBGOTOP())
			IF !SBE->(DBSEEK(XFILIAL("SBE") + "21" + "EXP", .F.))
				SBE->(RECLOCK("SBE", .T.))
				SBE->BE_FILIAL := XFILIAL("SBE")
				SBE->BE_LOCAL  := "21"
				SBE->BE_LOCALIZ:= "EXP"
				SBE->BE_DESCRIC:= "EXPEDICAO " + ALLTRIM((_cPSC5)->C5_XITEMC) 
				SBE->BE_PRIOR  := "ZZZ"
				SBE->BE_STATUS := "1"
				SBE->(MSUNLOCK())
			ENDIF

			SBF->(DBSETORDER(1))  //SALDOS POR ENDERECO
			IF !SBF->(DBSEEK(XFILIAL("SBF") + "21" + "EXP            " + PadR((_cPSC6)->C6_PRODUTO,15) , .F.))
				SBF->(RECLOCK("SBF", .T.))
				SBF->BF_FILIAL  := XFILIAL("SBF")
				SBF->BF_PRODUTO := PadR((_cPSC6)->C6_PRODUTO,15)
				SBF->BF_LOCAL   := "21"
				SBF->BF_PRIOR   := "ZZZ"
				SBF->BF_LOCALIZ := "EXP"
				SBF->(MSUNLOCK())
			ENDIF

			__cXNUMOLD := Alltrim((_cPSC6)->C6_NUMPRE)+Substring((_cPSC6)->C6_XITEMC,1,1)

			Aadd(_aItens,{;
			{"CK_NUMOLD"		,__cXNUMOLD			         	, Nil},; // Numero do Pedido no Portal
			{"CK_PRODUTO"		,PadR((_cPSC6)->C6_PRODUTO,15) 	, Nil},; // Codigo do Produto
			{"CK_QTDVEN" 		,(_cPSC6)->C6_QTDVEN				, Nil},; // Quantidade Vendida
			{"CK_PRUNIT" 		,(_cPSC6)->C6_VALDESC      	  	, Nil},; // Preço de Lista
			{"CK_PRCVEN" 		,(_cPSC6)->C6_VALDESC      		, Nil},; // Preco Unitario Liquido
			{"CK_OPER"  		,_cOper 							, Nil},; // TIPO DE OPERAçãO (SE EMPRESA FOR DAIHATSU, SEMPRE SERá VENDAS (V3))
			{"CK_XOPER"  		,_cOper 							, Nil},; // TIPO DE OPERAçãO customizada
			{"CK_LOCAL"  		,(_cPSC6)->C6_LOCAL        	 	, Nil},; // Almoxarifado
			{"CK_XREAJIP"		,"S"                      		, Nil},; // Reajusta IPI
			{"CK_XQTDLIB"		,0      							, Nil},; // Quantidade Liberada
			{"CK_TES"    		,cTES								, Nil},; // Tipo de Entrada/Saida do Item
			{"CK_XVLR1"    	,(_cPSC6)->C6_VALOR_R1   		, Nil},; // Valor de R1
			{"CK_XPCR1"    	,(_cPSC6)->C6_PERC_R1        	, Nil},; // Percentual de R1
			{"CK_XCOMIS1"  	,(_cPSC6)->C6_PERC_COMISSAO		, Nil},; // Percentual de Comissão (Atenção para ver se não irá atrapalhar o cálculo da Comissão)
			{"CK_XROL"     	,(_cPSC6)->C6_ROL       			, Nil},; // Valor da Receita Operacional Líquida
			{"CK_XCUSTPR"		,(_cPSC6)->C6_CUSTPRO   			, Nil},; // Valor da Custo Unitário do Produto
			{"CK_XDESPFI"		,(_cPSC6)->C6_DESPFIN   			, Nil},; // Valor da Despesa Financeira
			{"CK_XPCDEVO"		,(_cPSC6)->C6_PCDEVOL   			, Nil},; // Valor do percentual de Devolução
			{"CK_PEDCLI" 		,AllTrim((_cPSC6)->C6_PEDCLI)	, Nil},; // Pedido Cliente no campo padrão
			{"CK_XITEMC" 		,AllTrim((_cPSC6)->C6_XITEMC)	, Nil}}) // UNIDADE DE NEGÓCIO

			_nProc2 ++
			//SOMA O VALOR DOS PEDIDOS QUANDO GERA FINANCEIRO
			If Posicione("SF4",1,xFilial("SF4")+cTES,"F4_DUPLIC") == "S"
				nTotalPed += (_cPSC6)->C6_QTDVEN*(_cPSC6)->C6_VALDESC 
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
			MSExecAuto({|x,y,z| mata415(x,y,z)},_aCab,_aItens,3) //Inclusao
			If lMsErroAuto //Grava Erro na Importação
				If !lWeb
					mostraerro()
				EndIf

				U_ErroPed(_aCab[18][2],.T.,_sNomeBanco)
				_nErro++
				cMensErr += Alltrim((_cPSC5)->C5_NUMPRE) + Substring((_cPSC5)->C5_XITEMC,1,1)+ENTER
			Else
				_nOK++
				cMensImp += 'Pedido  :'+ Alltrim((_cPSC5)->C5_NUMPRE) + Substring((_cPSC5)->C5_XITEMC,1,1)+ENTER
				cMensImp += 'Cliente :'+ (_cPSC5)->C5_CLIENTE+"-"+(_cPSC5)->C5_LOJACLI+" "+Posicione("SA1",1,xFilial("SA1")+(_cPSC5)->C5_CLIENTE+(_cPSC5)->C5_LOJACLI,"A1_NOME")+ENTER
				cMensImp += 'Valor   : '+ Transform(nTotalPed,"@e 999,999.99")+ENTER
				cMensImp += ''+ENTER
				nTotGeral += nTotalPed
				U_FATMI002(1, SCJ->CJ_NUM, "N",lWeb) //Avalia o Crédito e já efetua a Liberação/Bloqueio, dependendo da situação do Cliente
				U_ErroPed(_aCab[18][2],.F.,_sNomeBanco) //Grava OK na Importação

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Grava Log na tabela SZC³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cAlias		:= "SCJ"
				_cChave		:= xFilial("SCJ") + SCJ->CJ_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= "01 - PEDIDO IMPORTADO COM SUCESSO"		
				_cFuncao	:= "U_FATMI001"		
				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
			Endif
			nTotalPed := 0
		END TRANSACTION
		
		_nProc ++
		(_cPSC5)->(dbSkip())
	EndDo
	If !lWeb
		Msgstop("Foram importados " + ALLTRIM(STR(_nOK)) + " orçamentos. " + ALLTRIM(STR(_nErro)) + " orçamentos apresentaram erros.")
	Else
		cEmail := 'grp_vendas@taiff.com.br'
		//cEmail :='PAULO.BINDO@TAIFFPROART.COM.BR' 
		//cEmail := 'carlos.torres@taiffproart.com.br'
		//ENVIA EMAIL ERROS
		If !Empty(cMensErr)
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,'Segue Relação de orçamentos de Vendas com erro, importar manualmente' + DTOC(DDATABASE)	,'')
		EndIf
		//ENVIA EMAIL ORCAMENTOS IMPORTADOS
		If !Empty(cMensImp)
			cMensImp += 'Valor Total   : '+ Transform(nTotGeral,"@e 99,999,999.99")+ENTER
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensImp	, 'Orçamentos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		Else
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'','Não tem pedidos no momento', 'Orçamentos importados para ' + cCabEmail + " em " + DTOC(DDATABASE)	,'')
		EndIf	
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATMI001  ºAutor  ³Daniel Ruffino      º Data ³  17/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ErroPed(_cNumPed,_lErro,_sNomeBanco)
	Local _cQuery := ""
	Local _cDtHora := ""

	If At("P",_cNumPed)!=0
		_cNumPed := Stuff( _cNumPed , At("P",_cNumPed),1,"" )
	EndIf
	If At("T",_cNumPed)!=0
		_cNumPed := Stuff( _cNumPed , At("T",_cNumPed),1,"" )
	EndIf

	If !_lErro
		_cQuery   := "UPDATE " + _sNomeBanco + "SC5 SET "
		_cQuery   += "	C5_IMP_PED = '*', "
		_cQuery   += "  C5_STSPED  = '1', "
		_cQuery   += "  C5_DTIMP  = '" + STRZERO(YEAR(date()),4, 0) + STRZERO(MONTH(date()),2, 0) + STRZERO(DAY(date()),2, 0) + "', "
		_cQuery   += "  C5_HRIMP  = '" + REPLACE(SUBSTRING( time() , 1,5 ), ":", "") + "' "
		_cQuery   += "WHERE C5_NUMPRE = '" + _cNumPed+ "'"
		//MemoWrite("FATMI001-GRAVAOK.sql",_cQuery)
		TCSQLExec(_cQuery)
	Else
		_cDtHora   := STR(YEAR(date()),4) + "-" + STR(MONTH(date()),2) + "-" + STR(DAY(date()),2) + " " + SUBSTRING( time() , 1,5 )
		_cQuery := "INSERT INTO " + _sNomeBanco + "IMP_LOG_ERRO_PEDIDO"
		_cQuery += " ( CD_PEDIDO , DT_ERRO ) "
		_cQuery += " VALUES "
		_cQuery += " ( '" + _cNumPed + "',Convert(DateTime,'" + _cDtHora + "',120) ) "
		//MemoWrite("FATMI001-GRAVAERRO.sql",_cQuery)
		TCSQLExec(_cQuery)
	Endif

Return


//--------------------------------------------------------------------------------------------------------------
// FUNçãO...: RETAMOCIDENTAL
// DESCRIçãO: SE O MUNICíPIO PERTENCER A AMAZONIA OCIDENTAL, E FALSE SE NãO PERTENCE
// CHAMADA..: ALERT(U_RETAMOCIDENTAL("AM", "01705"))
// AUTOR....: GILBERTO RIBEIRO JUNIOR																	    DATA: 09/05/2012
//--------------------------------------------------------------------------------------------------------------
User Function RetAmOcidental(cSiglaEst, cCodMunicipio)
	Local cRet := .F.

	dbSelectArea("CC2") //TABELA DE MUNICíPIOS
	CC2->( dbSetOrder(1) )
	CC2->( dbSeek( xFilial("CC2") + cSiglaEst + cCodMunicipio ))

	//SE O MUNICIPIO PERTENCER A AMAZONIA OCIDENTAL RETORNARÂ· TRUE
	If CC2->CC2_AMOCID = "S"
		cRet := .T.
	EndIf

Return cRet

//--------------------------------------------------------------------------------------------------------------
// FUNçãO...: RetAreaLivreComercio
// DESCRIçãO: SE O MUNICíPIO PERTENCER A áREA DE LIVRE COMéRCIO, RETORNA TRUE, SENãO RETORNA FALSE
// CHAMADA..: ALERT(U_RetAreaLivreComercio("RO", "00106"))
// AUTOR....: GILBERTO RIBEIRO JUNIOR																	    DATA: 09/05/2012
//--------------------------------------------------------------------------------------------------------------
User Function RetAreaLivreComercio(cSiglaEst, cCodMunicipio)
	Local cRet := .F.

	dbSelectArea("CC2") //TABELA DE MUNICÃŒPIOS
	CC2->( dbSetOrder(1) )
	CC2->( dbSeek( xFilial("CC2") + cSiglaEst + cCodMunicipio ))

	//SE O MUNICIPIO PERTENCER A Â·REA DE LIVRE COMÃˆRCIO RETORNARÂ· TRUE
	If CC2->CC2_AREALC = "S"
		cRet := .T.
	EndIf

Return cRet

