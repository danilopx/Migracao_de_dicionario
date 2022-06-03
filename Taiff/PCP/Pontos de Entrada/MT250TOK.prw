#INCLUDE 'PROTHEUS.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT250TOK.prw
=================================================================================
||   Função:	MT250TOK 	
=================================================================================
||   Descrição
||-------------------------------------------------------------------------------
|| 		Executado na função A250TudoOk(), rotina responsavel por validar os 
|| 	apontamentos de produção simples.
|| 		Este ponto de entrada permite validar algo digitado dependendo da 
|| 	necessidade do usuário, ele valida a tela toda.
|| 
||	(A parte de controle qdo a Requisição for por Requisição Digitada já existia
||	antes da data informada abaixo.)
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	06/05/2016
=================================================================================
=================================================================================
*/
USER FUNCTION MT250TOK(COP)

LOCAL LRET 		:= .T.
LOCAL AAREA 	:= GETAREA()
LOCAL AERROS 	:= {}
LOCAL NQTDAPONT	:= 0
LOCAL I 		:= 0
LOCAL CMSGERRO	:= ""

PRIVATE LVLPROC	:= GETNEWPAR("TF_250TOK",.T.)

COP:=M->D3_OP

IF GETMV("MV_REQAUT") == "D" .AND. IF(L250,M->D3_PARCTOT == "T",M->H6_PT == "T")

	DBSELECTAREA("SD4")
	DBSETORDER(2)
	DBSEEK(XFILIAL("SD4")+COP)
	
	WHILE !EOF() .AND. SD4->(D4_FILIAL+D4_OP) == XFILIAL("SD4")+COP
	
		IF SD4->D4_QUANT > 0
			AADD(AERROS,{SD4->D4_COD,SD4->D4_LOCAL,TRANSFORM(SD4->D4_QUANT,PESQPICTQT("D4_QUANT")),OEMTOANSI("SALDO DE EMPENHO PENDENTE"),NIL,NIL})//SALDO DE EMPENHO PENDENTE
		ENDIF
		DBSKIP()
		
	END
	
	IF !EMPTY(AERROS)
		MSGSTOP("A ORDEM DE PRODUCAO NAO PODERÁ SER APONTADA, AINDA POSSUI SALDO DE EMPENHO(S)NAO ATENDIDO(S)!!!","ATENCAO!")
		LRET := .F.
	ENDIF
	
ENDIF

IF LRET .AND. POSICIONE("SF5",1,XFILIAL("SF5") + M->D3_TM,"F5_ATUEMP") == "N"
	
	AERROS := {}
	
	NQTDAPONT := (SC2->C2_QUJE + SC2->C2_PERDA) + M->D3_QUANT
	DBSELECTAREA("SD4")
	DBSETORDER(2)
	DBSEEK(XFILIAL("SD4")+COP)
	
	WHILE SD4->(!EOF()) .AND. SD4->D4_OP = COP
		
		DBSELECTAREA("SG1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SG1") + SC2->C2_PRODUTO + SD4->D4_COD)
		
		nQtdEstrut := SD4->D4_QTDEORI/SC2->C2_QUANT
		/*
		CONOUT( PROCNAME() + " - " + ALLTRIM(STR(PROCLINE()))  )
		CONOUT( NQTDAPONT )
		CONOUT( nQtdEstrut )
		CONOUT( SD4->D4_QTDEORI )
		CONOUT( SD4->D4_QUANT )
		CONOUT( "*********************************************" )
		*/
		IF (NQTDAPONT * nQtdEstrut) > (SD4->D4_QTDEORI - SD4->D4_QUANT) 
			
			AADD(AERROS,{ALLTRIM(SD4->D4_COD),ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + SD4->D4_COD,"B1_DESC")),SD4->D4_OP})
			LRET := .F.
			
		ENDIF 
		
		SD4->(DBSKIP())
		
	ENDDO
	
	IF LEN(AERROS) > 0 .AND. LVLPROC
		
		CMSGERRO := "Os itens do empenho da OP " + ALLTRIM(COP) + " não foram consumidos:" + ENTER + ENTER 
		
		FOR I := 1 TO LEN(AERROS)
			
			CMSGERRO += AERROS[I][1] + " - " + AERROS[I][2] + ENTER
			
		NEXT I
		
		CMSGERRO += ENTER + "Verifique a Nota Fiscal de Entrada do retorno de Beneficiamento."
		
		MSGSTOP(CMSGERRO,"Apontamento Cancelado!")
		
	ELSEIF .NOT. LVLPROC
		LRET := .T.
	ENDIF 
	
ENDIF 

RESTAREA(AAREA)

RETURN LRET