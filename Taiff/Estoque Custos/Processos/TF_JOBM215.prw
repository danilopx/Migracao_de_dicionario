#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TRYEXCEPTION.CH'

/*
=================================================================================
=================================================================================
||   Arquivo: TF_JOBM215.PRW
=================================================================================
||   Funcao: 	JOB215
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		JOB que realiza a chamado da funcao de Refaz Acumulados para qualquer
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
||   Data:	13/03/2014
=================================================================================
=================================================================================
*/

USER FUNCTION TF_JOBM215()

	Local z 				:= 0
	Local _AEMPRESA			:= {}
	Local cEmpSchRESA		:= ""
	Private ALOGERROR		:= {}
	Private CLOGERROR
	Private CPATHERROR
	Private aEmpresas 		:=  {{"03","01"},{"04","01"}}
	Private lWeb			:= .F.
	Private cEmpSch 		:= "01" // Define como Padrão a Empresa Proart caso nao seja passado os parametros
	Private cFilialSch 		:= "01"
	

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		For z:=1 To Len(aEmpresas)
			cFilialSch := aEmpresas[z][2]
			cEmpSch := aEmpresas[z][1]

			RPCSetType(3)  // Nao utilizar licenca
			PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "EST"

			Conout("Rotina Refaz Acumulados TF_JOBM215 Empresa:"+cEmpSch+"/"+cFilialSch)
			ALOGERROR := STRTOKARR(SUPERGETMV("TF_JOB215LG"	,.F.,"JOB215ERROR.LOG|\SYSTEM\"),"|,-")
			CLOGERROR := ALOGERROR[1]
			CPATHERROR:= ALOGERROR[2]
			cEmpSchRESA := SUPERGETMV("TF_JOB215"	,.F.,"0201|0401")
			_AEMPRESA := STRTOKARR(cEmpSchRESA,"|,/-")

			CONOUT('--> Iniciando processo...')

			NTF_JOBM215()

			RESET ENVIRONMENT

		Next


	Else
		cMensagem := " Este programa ira rodar a rotina "+ENTER
		cMensagem += " de Refaz Acumulados "+ENTER
		cMensagem += " Deseja Continuar?"
		If !MsgYesNo(cMensagem,"Saldo Atual - TF_JOBM215")
			Return
		EndIf
		NTF_JOBM215()
	EndIf


Return



Static Function NTF_JOB215()

	LOCAL PARAMIXB 		:= .T.
	LOCAL LMSERROAUTO	:= .F.
	LOCAL CNOMELOG		:= ""
	LOCAL CINICIO		:= ""
	LOCAL CTERMINO		:= ""
	LOCAL CHRINIC		:= ""
	LOCAL CTEMPO		:= ""
	LOCAL ATABS			:= {}
	LOCAL LLOCKTABS		:= .F.
	//LOCAL _NI			:= 0
	LOCAL BERROR		:= {|OERROR| SHOWERROR(OERROR)}
	LOCAL OERROR
	LOCAL NHANDLE
	LOCAL CTEXTOARQ
	Local NX := 0

	TRYEXCEPTION USING BERROR

		CNOMELOG := DTOS(DATE()) + STRTRAN(SUBSTR(TIME(),1,5),":","") + ".LOG"

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Realiza a verificacao se Tabela podem ser abertas de forma Exclusiva!
	|
	|=================================================================================
	*/

		AADD(ATABS,"SA1");AADD(ATABS,"SB1");AADD(ATABS,"SB2");AADD(ATABS,"SB8");AADD(ATABS,"SC0");AADD(ATABS,"SC6")
		AADD(ATABS,"SC7");AADD(ATABS,"SC9");AADD(ATABS,"SD2");AADD(ATABS,"SD1");AADD(ATABS,"SD4");AADD(ATABS,"SDC")
		AADD(ATABS,"SDD");AADD(ATABS,"SC1");AADD(ATABS,"SC2");AADD(ATABS,"SB6");AADD(ATABS,"SBF");AADD(ATABS,"SDA")
		AADD(ATABS,"SL2");AADD(ATABS,"SCQ")

		FOR NX := 1 TO LEN(ATABS)
			IF !MA280FLOCK(ATABS[NX],,!ISBLIND())
				LLOCKTABS := .F.
				EXIT
			ENDIF
		NEXT

		CONOUT('[INFO] Verificou tabelas em uso...')

		IF !LLOCKTABS
		/*
		|---------------------------------------------------------------------------------
		|	FECHA TODOS OS ARQUIVOS E REABRE-OS DE FORMA COMPARTILHADA
		|---------------------------------------------------------------------------------
		*/	
			FOR NX := 1 TO LEN(ATABS)
				DBSELECTAREA(ATABS[NX])
				DBCLOSEAREA()
			NEXT
			OPENFILE(SUBSTR(CNUMEMP,1,2),"")

		ELSE
			FOR NX := 1 TO LEN(ATABS)
				OPENINDX(ATABS[NX])
			NEXT
		ENDIF

		CONOUT('[INFO] Rodando Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch)

		CINICIO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
		CHRINIC		:= TIME()

		MSEXECAUTO({|X| MATA215(X)},PARAMIXB)

		CTERMINO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
		CTEMPO 		:= ELAPTIME(CHRINIC,TIME())

		CONOUT('[INFO] Finalizando Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch)

	/*
	|---------------------------------------------------------------------------------
	|	Envia WorkFlow sendo o Processo Finalizado com Erro ou Nao. WorkFlow enviado 
	|	por Empresa processada.
	|---------------------------------------------------------------------------------
	*/
		IF LMSERROAUTO

			CMSG := OEMTOANSI('Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado com ERRO!')
			CMSG += CHR(13) + CHR(10) + OEMTOANSI('Início: ' + CINICIO + " - Término: " + CTERMINO + " Tempo do Processo: " + CTEMPO)
			CONOUT('<-- Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado com ERRO!')
			MOSTRAERRO(GETTEMPPATH(),CNOMELOG)
			ENVWFM215(.F.,CNOMELOG,CMSG)

		ELSE

			CMSG := OEMTOANSI('Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado!')
			CMSG += CHR(13) + CHR(10) + OEMTOANSI('Início: ' + CINICIO + " - Término: " + CTERMINO + " Tempo do Processo: " + CTEMPO)
			CONOUT('<-- Processo de Refaz Acumulados para a Empresa/Filial = ' + cEmpSch + '/' + cFilialSch + ' finalizado!')
			ENVWFM215(.T.,"",CMSG)

		ENDIF




	CATCHEXCEPTION USING OERROR

		CONOUT("[ERRO] - Ocorreu erro no processo!")

		CLOGERROR 	:= IIF(RIGHT(ALLTRIM(CPATHERROR),1) = "\",ALLTRIM(CPATHERROR),ALLTRIM(CPATHERROR) + "\") + ALLTRIM(CLOGERROR)

		IF !FILE(CLOGERROR)

			NHANDLE := FCREATE(CLOGERROR)

			IF NHANDLE = -1

				CONOUT("[ERRO] - Erro ao tentar criar arquivo de CLOGERROR")

			ELSE

				CTEXTOARQ := OERROR:DESCRIPTION
				FWRITE(NHANDLE,CTEXTOARQ,90)
				FCLOSE(NHANDLE)

			ENDIF

		ELSE

			NHANDLE 	:= FOPEN(CLOGERROR, FO_READWRITE + FO_SHARED)

			IF NHANDLE = -1

				CONOUT("[ERROR] - Erro ao tentar abrir o arquivo de LOG para Processo JOB215")

			ELSE

				FSEEK(NHANDLE,0,FS_END)
				CTEXTOARQ := OERROR:DESCRIPTION
				FWRITE(NHANDLE,CTEXTOARQ,90)
				FCLOSE(NHANDLE)

			ENDIF

		ENDIF

	ENDEXCEPTION

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_JOBM215.PRW
=================================================================================
||   Funcao: 	ENVWFM215
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

STATIC FUNCTION ENVWFM215(LOK,CARQLOG,CMSG)

	LOCAL CEMAIL 	:= SUPERGETMV("MV_JOB215",.F.,"grp_sistemas@taiff.com.br")
	LOCAL OPROCESS
	LOCAL CDTAHRA	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)

	//## Cria processo de Workflow
	OPROCESS 				:= TWFPROCESS():NEW( "WFM215", OEMTOANSI("WORKFLOW REFAZ ACUMULADOS - LOGS"))
	OPROCESS:NEWTASK( "WFM215", "\WORKFLOW\WFM215.HTM" )
	OPROCESS:CTO 			:= CEMAIL
	OPROCESS:CSUBJECT 		:= OEMTOANSI("WORKFLOW - REFAZ ACUMULADOS")
	OHTML 					:= OPROCESS:OHTML

	//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	IF !LOK .AND. !EMPTY(CARQLOG)
		OPROCESS:ATTACHFILE(GETTEMPPATH() + "\" + CARQLOG)
	ENDIF
	OHTML:VALBYNAME("DATAHORA"		,CDTAHRA)
	OHTML:VALBYNAME("STATUS"		,IIF(LOK,"SUCESSO",IIF(!EMPTY(CARQLOG),"ERRO","NÃO EXCLUSIVO")))
	OHTML:VALBYNAME("CORPODAMSG"	,CMSG)

	//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( 'edonizetti' )
	OPROCESS:USERSIGA		:= "000748"
	OPROCESS:START()
	OPROCESS:FREE()

RETURN .T.

/*
=================================================================================
=================================================================================
||   Arquivo:	TF_JOBM215.prw
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION SHOWERROR(OERROR)

	CONOUT(OERROR:DESCRIPTION)
	BREAK

RETURN
