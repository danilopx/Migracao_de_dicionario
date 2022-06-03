#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo: TF_JOBM300.PRW
=================================================================================
||   Funcao: 	JOBM300
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		JOB que realiza a chamado da funcao de Saldo Atual para qualquer
|| Empresa (passado por parametros).
|| 		Caso ocorra erro na execucao do mesmo envia Workflow para informar a 
|| 	ocorrencia.
|| 
=================================================================================
=================================================================================
||   PARAMETROS
||-------------------------------------------------------------------------------
|| 		- cEmpSch 	= Informar a Empresa para acessar o Ambiente
|| 		- cFilialSch		= Informar a Filial para acessar o Ambiente
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	19/05/2014
=================================================================================
=================================================================================
*/

USER FUNCTION TF_JOBM300(AEMPRESA)

	Local z := 0

	Private aEmpresas 	:= {{"01","02"},{"03","01"},{"03","02"},{"04","02"}}
	Private lWeb		:= .F.
	Private cEmpSch
	Private cFilialSch

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		For z:=1 To Len(aEmpresas)
			cFilialSch := aEmpresas[z][2]
			cEmpSch := aEmpresas[z][1]

			RPCSetType(3)  // Nao utilizar licenca
			PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "EST"
			Conout("Rotina saldo atual TF_JOBM300 Empresa:"+cEmpSch+"/"+cFilialSch)
			NTF_JOBM300()
			RESET ENVIRONMENT
		Next
	Else
		cMensagem := " Este programa ira rodar a rotina "
		cMensagem += " de saldo atual "
		cMensagem += " Deseja Continuar?"
		If !MsgYesNo(cMensagem,"Saldo Atual - TF_JOBM300")
			Return
		EndIf
		NTF_JOBM300()
	EndIf

Return

/*
=================================================================================
=================================================================================
||   Arquivo: NTF_JOBM300.PRW
=================================================================================
||   Funcao: 	JOBM300
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		JOB que realiza a chamado da funcao de Saldo Atual para qualquer
|| Empresa (passado por parametros).
|| 		Caso ocorra erro na execucao do mesmo envia Workflow para informar a 
|| 	ocorrencia.
|| 
=================================================================================
=================================================================================
||   PARAMETROS
||-------------------------------------------------------------------------------
|| 		- cEmpSch 	= Informar a Empresa para acessar o Ambiente
|| 		- cFilialSch		= Informar a Filial para acessar o Ambiente
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	19/05/2014
=================================================================================
=================================================================================
*/


Static Function NTF_JOBM300

	/*
	|---------------------------------------------------------------------------------
	| PARAMIXB - Para informar se sera rodado por Batch ou nao.
	|---------------------------------------------------------------------------------
	*/
	LOCAL PARAMIXB 		:= .T.
	LOCAL LMSERROAUTO	:= .F.
	LOCAL CNOMELOG		:= ""
	LOCAL CINICIO		:= ""
	LOCAL CTERMIN		:= ""
	LOCAL CHRINIC		:= ""
	LOCAL CTEMPO		:= ""
	Local cSX6LOG 		:= ""
	Local dTfMVULMES	:= GETMV("MV_ULMES")

	CNOMELOG := DTOS(DATE()) + STRTRAN(SUBSTR(TIME(),1,5),":","") + ".LOG"

	CONOUT('--> Iniciando processo...')

	/*
	|---------------------------------------------------------------------------------
	|	Antes de iniciar o Processo de Saldo Atual alterar o conteúdo do parametro  
	|	MV_ULMES conforme data do ultimo fechamento na SB9 
	|---------------------------------------------------------------------------------
	*/

	cSX6LOG := ""

	cQuery := "SELECT CONVERT(VARCHAR(10),CONVERT(DATE,ISNULL(MAX(B9_DATA),'')),112) AS CB9DATA "
	cQuery += " FROM " + RetSQLName("SB9")+" SB9 WITH(NOLOCK)"
	cQuery += " WHERE SB9.D_E_L_E_T_='' "
	cQuery += " AND B9_FILIAL='" + xFilial("SB9") + "'"

	//MEMOWRITE("TF_JOBM300_SCRIPT_SB9.SQL",cQuery)
	IF SELECT("AUX") > 0
		DBSELECTAREA("AUX")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CQUERY NEW ALIAS "AUX"

	TCSetField("AUX","CB9DATA","D")

	DBSELECTAREA("AUX")

	AUX->(DbGoTop())

	If dTfMVULMES < AUX->CB9DATA
		cSX6LOG := "*** ATENCAO: PARAMETRO MV_ULMES FOI ATUALIZADO DE " + DTOC(dTfMVULMES) + " PARA " + DTOC(AUX->CB9DATA) + " ***"
		PUTMV("MV_ULMES"	,AUX->CB9DATA)
		CONOUT("TF_JOBM300: EM " + CEMPANT + "/" + CFILANT + " " + cSX6LOG)
	EndIf
	AUX->(DBCLOSEAREA())

	/*
	|---------------------------------------------------------------------------------
	|	Inicia o Processo para as empresas informadas no Parametro.
	|---------------------------------------------------------------------------------
	*/

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	IF !DBSEEK("MTA300")

		CONOUT("--* ERRO AO ACHAR PERGUNTAS PARA O PROCESSO DE SALDO ATUAL! PROCESSO FINALIZADO!")
		RETURN

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Antes de iniciar o Processo de Saldo Atual altero os parametros da Rotina 
	|	diretamente no SX1.
	|---------------------------------------------------------------------------------
	*/
	WHILE SX1->(!EOF()) .AND. ALLTRIM(SX1->X1_GRUPO) = "MTA300"

		RECLOCK("SX1",.F.)

		DO CASE

		CASE VAL(SX1->X1_ORDEM) = 1
			SX1->X1_CNT01 := SPACE(002)
		CASE VAL(SX1->X1_ORDEM) = 2
			SX1->X1_CNT01 := "ZZ"
		CASE VAL(SX1->X1_ORDEM) = 3
			SX1->X1_CNT01 := SPACE(015)
		CASE VAL(SX1->X1_ORDEM) = 4
			SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZ"
		CASE VAL(SX1->X1_ORDEM) = 5
			SX1->X1_PRESEL := 1
		CASE VAL(SX1->X1_ORDEM) = 6
			SX1->X1_PRESEL := 1
		CASE VAL(SX1->X1_ORDEM) = 7
			SX1->X1_PRESEL := 2
		CASE VAL(SX1->X1_ORDEM) = 8
			SX1->X1_PRESEL := 2

		END CASE

		MSUNLOCK()

		SX1->(DBSKIP())

	ENDDO

	PERGUNTE("MTA300",.F.)

	CINICIO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CHRINIC		:= TIME()

	MSEXECAUTO({|X| MATA300(X)},PARAMIXB)

	CTERMINO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CTEMPO 		:= ELAPTIME(CHRINIC,TIME())

	/*
	|---------------------------------------------------------------------------------
	|	Envia WorkFlow sendo o Processo Finalizado com Erro ou Nao. WorkFlow enviado 
	|	por Empresa processada.
	|---------------------------------------------------------------------------------
	*/
	IF LMSERROAUTO

		CMSG := OEMTOANSI('Processo de Saldo Atual para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado com ERRO!')
		CMSG += CHR(13) + CHR(10) + OEMTOANSI('Início: ' + CINICIO + " - Término: " + CTERMIN + " Tempo do Processo: " + CTEMPO)
		CONOUT('<-- Processo de Saldo Atual para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado com ERRO!')
		MOSTRAERRO(GETTEMPPATH(),CNOMELOG)
		ENVWFM300(.F.,CNOMELOG,CMSG,cSX6LOG)

	ELSE

		CMSG := OEMTOANSI('Processo de Saldo Atual para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado!')
		CMSG += CHR(13) + CHR(10) + OEMTOANSI('Início: ' + CINICIO + " - Término: " + CTERMIN + " Tempo do Processo: " + CTEMPO)
		CONOUT('<-- Processo de Saldo Atual para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado!')
		ENVWFM300(.T.,"",CMSG,cSX6LOG)

	ENDIF


RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_JOBM300.PRW
=================================================================================
||   Funcao: 	ENVWFM300
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para enviar WorkFlow referente ao processo. 
|| 
=================================================================================
=================================================================================
||   PARAMETROS
||-------------------------------------------------------------------------------
|| 		- LOK 	= Informar se Processo executou corretamente ou nao.
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVWFM300(LOK,CARQLOG,CMSG,CALERTA)

	LOCAL CEMAIL 	:= SUPERGETMV("MV_JOB215",.F.,"grp_sistemas@taiff.com.br")
	LOCAL OPROCESS
	LOCAL CDTAHRA	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)

	//## Cria processo de Workflow
	OPROCESS 				:= TWFPROCESS():NEW( "WFM300", OEMTOANSI("WORKFLOW SALDO ATUAL - LOGS"))
	If EMPTY(CALERTA)
		OPROCESS:NEWTASK( "WFM300", "\WORKFLOW\WFM300.HTM" )
		OPROCESS:CSUBJECT 		:= OEMTOANSI("WORKFLOW - SALDO ATUAL")
	Else
		OPROCESS:NEWTASK( "WFM300", "\WORKFLOW\WFM300SX6.HTM" )
		OPROCESS:CSUBJECT 		:= OEMTOANSI("PROBLEMA ROTINA SALDO ATUAL")
	EndIf
	OPROCESS:CTO 			:= CEMAIL
	OHTML 					:= OPROCESS:OHTML

	//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	IF !LOK .AND. !EMPTY(CARQLOG)
		OPROCESS:ATTACHFILE(GETTEMPPATH() + "\" + CARQLOG)
	ENDIF
	OHTML:VALBYNAME("DATAHORA"	,CDTAHRA)
	OHTML:VALBYNAME("STATUS"		,IIF(LOK,"SUCESSO",IIF(!EMPTY(CARQLOG),"ERRO","NÃO EXCLUSIVO")))
	OHTML:VALBYNAME("CORPODAMSG"	,CMSG)
	If .NOT. EMPTY(CALERTA)
		OHTML:VALBYNAME("ALERTA"		,CALERTA)
	EndIf

	//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( 'edonizetti' )
	OPROCESS:USERSIGA		:= "000748"
	OPROCESS:START()
	OPROCESS:FREE()

RETURN .T.
