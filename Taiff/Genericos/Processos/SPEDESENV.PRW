#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'DIRECTRY.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  05/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION SPEDESENV(cPorta)

	LOCAL CQUERY		:= ""
	LOCAL CPL			:= CHR(13) + CHR(10)
	LOCAL NRETORNO		:= 0
	LOCAL CEMPAT		:= ""
	LOCAL CINICIO		:= ""
	LOCAL CTERMIN		:= ""
	LOCAL CHRINIC		:= ""
	LOCAL CTEMPO		:= ""
	
	DEFAULT CPORTA		:= "8184"
	
	CINICIO 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CHRINIC		:= TIME()
	
	CONOUT("---> SPEDESENV - Iniciando Processo para Configuracao do TSS para o DESENV... DateTime: " + CINICIO)

	aEval(Directory("\SYSTEM\*.CDX"), { |aFile| FERASE(aFile[F_NAME]) })

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SA1"

	DBSELECTAREA("SM0")
	DBGOTOP()

	CQUERY := "UPDATE" 							+ CPL
	CQUERY += "SPED000" 							+ CPL
	CQUERY += "SET"								+ CPL
	CQUERY += "CONTEUDO = '2'" 					+ CPL
	CQUERY += "WHERE"								+ CPL
	CQUERY += "ID_ENT <> '' AND"					+ CPL
	CQUERY += "PARAMETRO = 'MV_AMBIENT' AND" 	+ CPL
	CQUERY += "D_E_L_E_T_ = ''"
                           
	NRETORNO := TCSQLEXEC(CQUERY)

	IF NRETORNO < 0
	
		CONOUT("---* SPEDESENV - Erro na Query " + CPL + cQuery + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
			
	ENDIF

	WHILE SM0->(!EOF())
	
		CEMPAT := SM0->M0_CODIGO
	
		RPCSetType(3)  // Nao utilizar licenca
		RPCSetEnv(SM0->M0_CODIGO,SM0->M0_CODFIL,,,,GetEnvServer(),{ "SA1" })
	
		SLEEP( 5000 )
	
		CONOUT("---* SPEDESENV - Empresa atual - " + ALLTRIM(SM0->M0_NOMECOM) + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
	
		OPENSXS(,,,,SM0->M0_CODIGO,"SX6TMP","SX6",,.F.)
		DBSELECTAREA("SX6TMP")
		DBGOTOP()
	
		WHILE SX6TMP->(!EOF())
		
			IF ALLTRIM(SX6TMP->X6_VAR) = "MV_SPEDURL"
			
				IF RECLOCK("SX6TMP",.F.)
				
					SX6TMP->X6_CONTEUD := "http://192.168.0.8:" + ALLTRIM(CPORTA)
					MSUNLOCK()
				
				ELSE
				                                                  
					CONOUT("---* SPEDESENV - Erro na Alteracao do Parametro MV_SPEDURL - " + ALLTRIM(SM0->M0_NOMECOM) + " DateTime: " + DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5))
				
				ENDIF
			
			ENDIF
		 
			SX6TMP->(DBSKIP())
		
		ENDDO
	
		SM0->(DBSKIP())
	
	ENDDO

	RpcClearEnv()
	
	CTERMIN 	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)
	CTEMPO 		:= ELAPTIME(CHRINIC,TIME())
	
	CONOUT("<--- SPEDESENV - Fim do Processo de Atualizacao... Tempo Decorrido (" + CTEMPO + ") DateTime: " + CTERMIN)
	
	MSGINFO("ATUALIZACAO CONCLUIDA")

RETURN
