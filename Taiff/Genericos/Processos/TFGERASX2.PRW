#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'DIRECTRY.CH'

#DEFINE PULA CHR(13) + CHR(10) 

/*
=================================================================================
=================================================================================
||   Arquivo:
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||  
|| 
=================================================================================
=================================================================================
*/


USER FUNCTION TFGERASX2()

	LOCAL CQUERY		:= ""
	LOCAL CPL			:= CHR(13) + CHR(10)
	LOCAL NRETORNO		:= 0
	LOCAL CEMPAT		:= ""
	LOCAL CINICIO		:= ""
	LOCAL CTERMIN		:= ""
	LOCAL CHRINIC		:= ""
	LOCAL CTEMPO		:= ""
	
	CINICIO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CHRINIC		:= TIME()
	
	/*
	|---------------------------------------------------------------------------------
	|	Deleta os arquivo de Indice do Dicionario de Dados
	|---------------------------------------------------------------------------------
	*/
	//aEval(Directory("\SYSTEM\*.CDX"), { |aFile| FERASE(aFile[F_NAME]) })

	CONOUT("---> TFGERASX2 - Iniciando Processo que preenche Tabela SQL com informacoes do SX2... DateTime: " + CINICIO)

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1"

	DBSELECTAREA("SM0")
	DBGOTOP()
	
	/*
	|---------------------------------------------------------------------------------
	|	Deleta os Registros da SM0_COOMPANY
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "DELETE SM0_COMPANY"
	NRETORNO := TCSQLEXEC(CQUERY)
	
	IF NRETORNO < 0
			
		CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))

	ELSE

		CONOUT("[INFO]  TFGERASX2 - Registros do SM0_COMPANY deletados... DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
	ENDIF
	
	/*
	|---------------------------------------------------------------------------------
	|	Deleta os Registros da SX2_COMPANY
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "DELETE SX2_COMPANY"
	NRETORNO := TCSQLEXEC(CQUERY)
	
	IF NRETORNO < 0
			
		CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))

	ELSE

		CONOUT("[INFO]  TFGERASX2 - Registros do SX2_COMPANY deletados... DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
	ENDIF
	
	/*
	|---------------------------------------------------------------------------------
	|	Deleta os Registros da SX6_COMPANY
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "DELETE SX6_COMPANY"
	NRETORNO := TCSQLEXEC(CQUERY)

	IF NRETORNO < 0
			
		CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
	
	ELSE

		CONOUT("[INFO]  TFGERASX2 - Registros do SX6_COMPANY deletados... DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
	ENDIF
	
	/*
	|---------------------------------------------------------------------------------
	|	Inicia o processo de preenchimento das Tabelas com informacoes dos arquivos
	|	CTREE
	|---------------------------------------------------------------------------------
	*/
	WHILE SM0->(!EOF())
	
		CEMPAT := SM0->M0_CODIGO
	
		RPCSetType(3)  // Nao utilizar licenca
		RPCSetEnv(SM0->M0_CODIGO,SM0->M0_CODFIL,,,,GetEnvServer(),{ "SA1" })
	
		SLEEP( 5000 )				
		
		CONOUT("[INFO]  TFGERASX2 - Empresa atual - " + ALLTRIM(SM0->M0_NOMECOM)+ " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))	
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SX2 (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SX2TMP","SX2",,.F.)
		DBSELECTAREA("SX2TMP")
		DBGOTOP()
	
		WHILE SX2TMP->(!EOF())
		
			CQUERY := "INSERT INTO SX2_COMPANY VALUES ('" 					
			CQUERY += ALLTRIM(SM0->M0_CODIGO) + "','" 							
			CQUERY += ALLTRIM(SX2TMP->X2_CHAVE) + "','" 						
			CQUERY	+= ALLTRIM(SX2TMP->X2_ARQUIVO) + "','" 					
			CQUERY += ALLTRIM(STRTRAN(SX2TMP->X2_NOME,"'","''")) + "','" 	
			CQUERY += ALLTRIM(SX2TMP->X2_MODO) + "','" 						
			CQUERY += ALLTRIM(SX2TMP->X2_UNICO) + "')" 						
			NRETORNO := TCSQLEXEC(CQUERY)
		
			IF NRETORNO < 0
			
				CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
			ENDIF
		
			SX2TMP->(DBSKIP())
		
		ENDDO
	
		SX2TMP->(DBCLOSEAREA())
		
		/*
		|---------------------------------------------------------------------------------
		|	Abre o SX6 (CTree) exclusivo e inicia leitura e gravacao
		|---------------------------------------------------------------------------------
		*/
		OPENSXS(,,,,SM0->M0_CODIGO,"SX6TMP","SX6",,.F.)
		DBSELECTAREA("SX6TMP")
		DBGOTOP()
	
		WHILE SX6TMP->(!EOF())
		
			CQUERY := "INSERT INTO SX6_COMPANY VALUES ('" 																				
			CQUERY += ALLTRIM(SM0->M0_CODIGO) + "','" 																								
			CQUERY += ALLTRIM(SX6TMP->X6_FIL) + "','" 																								
			CQUERY += ALLTRIM(SX6TMP->X6_TIPO) + "','" 																								
			CQUERY	+= ALLTRIM(SX6TMP->X6_VAR) + "','" 																								
			CQUERY += ALLTRIM(STRTRAN(ALLTRIM(SX6TMP->X6_DESCRIC)+ALLTRIM(SX6TMP->X6_DESC1)+ALLTRIM(SX6TMP->X6_DESC2),"'","''")) + "','" 	
			CQUERY += ALLTRIM(STRTRAN(SX6TMP->X6_CONTEUD,"'","''")) + "')" 																		
			NRETORNO := TCSQLEXEC(CQUERY)
		
			IF NRETORNO < 0
			
				CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
			ENDIF
		
			SX6TMP->(DBSKIP())
		
		ENDDO
	
		SX6TMP->(DBCLOSEAREA())
				
		WHILE SM0->M0_CODIGO = CEMPAT
			
			/*
			|---------------------------------------------------------------------------------
			|	Grava as informacoes da Empresa no SM0
			|---------------------------------------------------------------------------------
			*/			
			CQUERY := "INSERT INTO SM0_COMPANY VALUES ('"
			CQUERY += ALLTRIM(SM0->M0_CODIGO) + "','"
			CQUERY += ALLTRIM(SM0->M0_CODFIL) + "','"
			CQUERY += ALLTRIM(SM0->M0_FILIAL) + "','"
			CQUERY += ALLTRIM(SM0->M0_NOME) + "','"
			CQUERY += ALLTRIM(SM0->M0_NOMECOM) + "','"
			CQUERY += ALLTRIM(SM0->M0_ENDCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_CIDCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_ESTCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_CEPCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_ENDENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_CIDENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_ESTENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_CEPENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_CGC) + "','"
			CQUERY += ALLTRIM(SM0->M0_INSC) + "','"
			CQUERY += ALLTRIM(SM0->M0_TEL) + "','"
			CQUERY += ALLTRIM(SM0->M0_BAIRCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_BAIRENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_COMPCOB) + "','"
			CQUERY += ALLTRIM(SM0->M0_COMPENT) + "','"
			CQUERY += ALLTRIM(SM0->M0_CNAE) + "','"
			CQUERY += ALLTRIM(SM0->M0_FPAS) + "','"
			CQUERY += ALLTRIM(SM0->M0_CODMUN) + "','"
			CQUERY += ALLTRIM(SM0->M0_NATJUR) + "','"
			CQUERY += ALLTRIM(DTOS(SM0->M0_DTVLD)) + "','"
			CQUERY += ALLTRIM(SM0->M0_INSCM) + "','"
			CQUERY += ALLTRIM(SM0->M0_NIRE) + "','"
			CQUERY += ALLTRIM(DTOS(SM0->M0_DTRE)) + "')"
			NRETORNO := TCSQLEXEC(CQUERY)
			
			IF NRETORNO < 0
				
				CONOUT("---* TFGERASX2 - Erro na Query " + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
			ENDIF
			
			SM0->(DBSKIP())
			
		ENDDO
	
	ENDDO

	RpcClearEnv()
	
	CTERMIN 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CTEMPO 		:= ELAPTIME(CHRINIC,TIME())
	
	CONOUT("<--- TFGERASX2 - Fim do Processo de Atualizacao... Tempo Decorrido (" + CTEMPO + ") DateTime: " + CTERMIN)

RETURN