#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'

/*
=================================================================================
=================================================================================
||   Arquivo: FCARRAYEXEC.PRW
=================================================================================
||   Funcao: FCARRAYEXEC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para gerar e retornar array que sera utilizado em MSExecAuto do
|| Sistema colocando os campos nas posicoes conforme Dicionario de Dados SX3.
|| Podera ser passado um Array com os Campos que se deseja ou solicitar todos 
|| os campos do Dicionario de Dados.
||
|| O array com os Campos deve ser passado com os Valores para o MSExecAuto:
|| 		aCampos[1] = Nome do campo
|| 		aCampos[2] = Valor do campo
||
|| O retorno sera o array para o MSExecAuto:
||		aRet[1] = Nome do Campo
||		aRet[2] = Valor do Campo
||		aRet[3] = NIL
||
|| Caso seja solicitado todos os campos a posicao com os valores sera passado
|| em branco ('').
=================================================================================
=================================================================================
||   Autor: Edson Hornberger
||   Data: 11/09/2013
=================================================================================
=================================================================================
*/

USER FUNCTION FCARRAYEXEC(cTabela,aCampos,lTudo)

	LOCAL ARET 		:= {}
	LOCAL AAREASX3		:= SX3->(GETAREA())
	LOCAL NPOS			:= 0

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Abaixo faz a verificacao dos parametros passados para a Funcao.
|
|=================================================================================
*/

// NAO FOI PASSADO O NOME DA TABELA
	IF VALTYPE(CTABELA) = "U" .OR. EMPTY(CTABELA) .OR. LEN(CTABELA) > 3
	
		CONOUT("ln " + ALLTRIM(STR(PROCLINE())) + " - FUNCAO: " + ALLTRIM(PROCNAME()) + " - Parametro CTABELA nao foi informado corretamente...")
		RETURN()
	
	ENDIF

	DEFAULT ACAMPOS := {}
	DEFAULT LTUDO := .T.

// CASO SEJA INFORMADO ARRAY COM CAMPOS VERIFICA SE FOI PASSADO TAMBEM OS VALORES
	IF LEN(ACAMPOS) > 0 .AND. !LTUDO
	
		IF LEN(ACAMPOS[1]) <> 2
		
			CONOUT("ln " + ALLTRIM(STR(PROCLINE())) + " - FUNCAO: " + ALLTRIM(PROCNAME()) + " - Parametro ACAMPOS nao foi informado corretamente...")
			RETURN()
	
		ENDIF
	
	ENDIF

// INICIA A VERIFICACAO NO DICIONARIO DE DADOS SX3
	DBSELECTAREA("SX3")
	DBSETORDER(1)
	DBGOTOP()
	DBSEEK(CTABELA)

	WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = CTABELA
	
	// VERIFICA SE VAI LEVAR TODOS OS CAMPOS OU SOMENTE OS PASSADOS PELO PARAMETRO
		IF !LTUDO
		
			NPOS := ASCAN(ACAMPOS,{|X| ALLTRIM(X[1]) == ALLTRIM(SX3->X3_CAMPO)})
		
			IF  NPOS > 0
			
				AADD(ARET,{ALLTRIM(SX3->X3_CAMPO),IIF(SX3->X3_TIPO = "C",PADR(ACAMPOS[NPOS][2],SX3->X3_TAMANHO),ACAMPOS[NPOS][2]),NIL})
		
			ELSE
		
				IF U_VEROBRIGAT(ALLTRIM(SX3->X3_CAMPO))
				
					IF EMPTY(SX3->X3_RELACAO)
					
						CONOUT("ln " + ALLTRIM(STR(PROCLINE())) + " - FUNCAO: " + ALLTRIM(PROCNAME()) + " - Campo Obrigatorio " + ALLTRIM(SX3->X3_CAMPO) + " sem Inicializador Padrao...")
					
					ELSE
					
						AADD(ARET,{ALLTRIM(SX3->X3_CAMPO),IIF(SX3->X3_TIPO = "C",PADR(&(SX3->X3_RELACAO),SX3->X3_TAMANHO),&(SX3->X3_RELACAO)),NIL})
					
					ENDIF
				
				ENDIF
		
			ENDIF
		
		ELSE
		
			IF EMPTY(SX3->X3_RELACAO)
		
				AADD(ARET,{ALLTRIM(SX3->X3_CAMPO),IIF(SX3->X3_TIPO = "C",PADR(&(SX3->X3_RELACAO),SX3->X3_TAMANHO),&(SX3->X3_RELACAO)),NIL})
			
			ELSE
			
				AADD(ARET,{ALLTRIM(SX3->X3_CAMPO),"",NIL})
		
			ENDIF
		
		ENDIF
	
		SX3->(DBSKIP())

	ENDDO

	RESTAREA(AAREASX3)

RETURN(ARET)

/*
=================================================================================
=================================================================================
||   Arquivo: FCARRAYEXEC.PRW
=================================================================================
||   Funcao: VEROBRIGAT
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Esta funcao verifica se o campo e obrigatorio no SX3. 
|| 
=================================================================================
=================================================================================
||   Autor: Edson Hornberger
||   Data: 13/09/2013
=================================================================================
=================================================================================
*/


USER FUNCTION VEROBRIGAT(CCAMPO)

	LOCAL LRET 		:= .F.
	LOCAL AAREASX3 	:= SX3->(GETAREA())

	DEFAULT CCAMPO 	:= ""

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Abaixo faz a verificacao dos parametros passados para a Funcao.
|
|=================================================================================
*/

	IF EMPTY(CCAMPO)
	
		CONOUT("ln " + ALLTRIM(STR(PROCLINE())) + " - FUNCAO: " + ALLTRIM(PROCNAME()) + " - Parametro CCAMPO nao foi informado corretamente...")
		RETURN(LRET)
	
	ENDIF

	DBSELECTAREA("SX3")
	DBSETORDER(2)
	IF DBSEEK(CCAMPO)

		LRET := X3USO(SX3->X3_USADO) .AND. ((SUBSTR(BIN2STR(SX3->X3_OBRIGAT),1,1) == "X") .OR. VERBYTE(SX3->X3_RESERV,7))
	
	ELSE
	
		CONOUT("ln " + ALLTRIM(STR(PROCLINE())) + " - FUNCAO: " + ALLTRIM(PROCNAME()) + " - Parametro CCAMPO foi passado com informacao incorreta...")
	
	ENDIF

	RESTAREA(AAREASX3)

RETURN(LRET)

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|  Adicionando informacoes no lMSErroAuto
/	-----------
/	lMsErroAuto := .F.
/
/	//Exclui
/	MsExecAuto({|x,y|Mata650(x,y)},aMata650,5)
/
/	//Em caso de erro
/	If lMsErroAuto
/		AutoGrLog( "Data.........: " + DtoC(Date()) )
/		AutoGrLog( "Hora.........: " + Time() )
/		AutoGrLog( "Aonde........: ExcluiOP " )
/		AutoGrLog( "Ordem........: " + SC2->C2_NUM + SC2->C2_SEQUEN + SC2->C2_ITEM )
/
/		MostraErro()
/	EndIf
|	----------
|=================================================================================
*/
