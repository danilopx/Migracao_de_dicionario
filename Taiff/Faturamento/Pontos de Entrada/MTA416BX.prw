#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³MTA416BX  ºAUTOR  ³DANIEL RUFFINO      º DATA ³  17/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ PONTO DE ENTRADA RESPONSAVEL POR BLOQUEAR A BAIXA DE       º±±
±±º          ³ ORCAMENTOS QUE NAO ESTEJAM COMO LIBERADOS(CJ_XLIBCR == "L")º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/
USER FUNCTION MTA416BX()

	LOCAL _LRET:=.F.
	LOCAL _CALIAS 	:= PARAMIXB[1]
	LOCAL CQUERY 	:= ""
	LOCAL NREGS 	:= 0
//-----------------------------------------------------------------------------------------------
//ADICIONADO POR THIAGO COMELLI EM 16/10/2012
//EXECUTA SOMENTE NA EMPRESA E FILIAL SELECIONADOS
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT07",.F.,"")

		IF (_CALIAS)->CJ_XLIBCR == "L" .AND. (_CALIAS)->CJ_STATUS == "A"
			_LRET:=.T.
		ELSE
			_LRET:=.F.
		ENDIF

	ENDIF

/*
|---------------------------------------------------------------------------------
|	REALIZA A VERIFICACAO DA TABELA DE PRECOS DE TRANSFERENCIA
|	EDSON HORNBERGER - 05/11/2015
|---------------------------------------------------------------------------------
*/

	IF _LRET .AND. CEMPANT + CFILANT = "0301" .AND. (_CALIAS)->CJ_XCLASPD != "A"

		CQUERY := "SELECT SA1.A1_TABELA FROM " + RETSQLNAME("SA1") + " SA1 WHERE SA1.A1_FILIAL = '02' AND SA1.A1_CGC = '" + SM0->M0_CGC + "' AND SA1.D_E_L_E_T_ = ''"
		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		COUNT TO NREGS

		IF NREGS > 0

			TMP->(DBGOTOP())
			_LRET := VERIFTAB(TMP->A1_TABELA,(_CALIAS)->CJ_NUM)
			IF !_LRET

				MSGINFO("Existem Produtos sem Tabela de Preço para Transferência!","Processo CrossDocking")

			ENDIF

		ELSE

			MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")

		ENDIF

	ENDIF

RETURN _LRET

/*
=================================================================================
=================================================================================
||   Arquivo:	MTA416BX.prw
=================================================================================
||   Funcao: 	VERIFTAB
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
||   Autor: Edson Hornberger 
||   Data:	05/11/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERIFTAB(CTAB,CNUMORC)

	LOCAL LRET 		:= .F.
	LOCAL NQTDORI 	:= 0
	LOCAL NQTDDES 	:= 0
	LOCAL APRODUT	:= {}

	IF SELECT("TRB") > 0

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

	ENDIF

	//## Gera consulta com itens do Pedido de Transferencia
	CQUERY := "SELECT" 											+ ENTER
	CQUERY += "	SCK.CK_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER
	CQUERY += "	" + RETSQLNAME("SCK") + " SCK" 					+ ENTER
	CQUERY += "WHERE" 											+ ENTER
	CQUERY += "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 	+ ENTER
	CQUERY += "	SCK.CK_NUM = '" + CNUMORC + "' AND" 			+ ENTER
	CQUERY += "	SCK.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER
	CQUERY += "	SCK.CK_PRODUTO"

	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")

	COUNT TO NQTDORI

	TRB->(DBCLOSEAREA())

	//## Gera consulta com itens do Pedido de Transferencia com Tabela de Precos
	CQUERY := "SELECT" 											+ ENTER
	CQUERY += "	SCK.CK_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER
	CQUERY += "	" + RETSQLNAME("SCK") + " SCK" 					+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("DA1") + " DA1 ON" 	+ ENTER
	CQUERY += "	DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER
	CQUERY += "	DA1.DA1_CODPRO = SCK.CK_PRODUTO AND" 			+ ENTER
	CQUERY += "	DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER
	CQUERY += "	DA1.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "WHERE" 											+ ENTER
	CQUERY += "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 	+ ENTER
	CQUERY += "	SCK.CK_NUM = '" + CNUMORC + "' AND" 			+ ENTER
	CQUERY += "	SCK.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER
	CQUERY += "	SCK.CK_PRODUTO"

	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")

	COUNT TO NQTDDES

	TRB->(DBCLOSEAREA())

	IF NQTDORI <> NQTDDES

		LRET 	:= .F.

		CQUERY 	:= "SELECT" 													+ ENTER
		CQUERY 	+= "	SCK.CK_PRODUTO," 										+ ENTER
		CQUERY 	+= "    SB1.B1_DESC" 											+ ENTER
		CQUERY 	+= "FROM" 														+ ENTER
		CQUERY 	+= "	" + RETSQLNAME("SCK") + " SCK" 							+ ENTER
		CQUERY 	+= "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 			+ ENTER
		CQUERY 	+= "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 		+ ENTER
		CQUERY 	+= "		SB1.B1_COD = SCK.CK_PRODUTO AND" 					+ ENTER
		CQUERY 	+= "		SB1.D_E_L_E_T_ = ''" 								+ ENTER
		CQUERY 	+= "WHERE" 														+ ENTER
		CQUERY 	+= "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 			+ ENTER
		CQUERY 	+= "	SCK.CK_NUM = '" + CNUMORC + "' AND" 					+ ENTER
		CQUERY 	+= "	SCK.CK_PRODUTO NOT IN" 									+ ENTER
		CQUERY 	+= "	(" 														+ ENTER
		CQUERY 	+= "		SELECT" 											+ ENTER
		CQUERY 	+= "			DA1.DA1_CODPRO" 								+ ENTER
		CQUERY 	+= "		FROM" 												+ ENTER
		CQUERY 	+= "			" + RETSQLNAME("DA1") + " DA1" 					+ ENTER
		CQUERY 	+= "		WHERE" 												+ ENTER
		CQUERY 	+= "			DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER
		CQUERY 	+= "            DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER
		CQUERY 	+= "			DA1.D_E_L_E_T_ = ''" 							+ ENTER
		CQUERY 	+= "	) AND" 													+ ENTER
		CQUERY 	+= "	SCK.D_E_L_E_T_ = ''" 									+ ENTER
		CQUERY 	+= "GROUP BY" 													+ ENTER
		CQUERY 	+= "	SCK.CK_PRODUTO," 										+ ENTER
		CQUERY 	+= " 	SB1.B1_DESC"

		IF SELECT("TRB") > 0

			DBSELECTAREA("TRB")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")
		DBGOTOP()

		WHILE TRB->(!EOF())

			AADD(APRODUT,{TRB->CK_PRODUTO,TRB->B1_DESC})
			TRB->(DBSKIP())

		ENDDO

		ENVTAB(APRODUT)

	ELSE

		LRET := .T.

	ENDIF

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	MTA416BX.prw
=================================================================================
||   Funcao: 	ENVTAB
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
||   Autor: 	Edson Hornberger 
||   Data:		05/11/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVTAB(ADADOS)

	LOCAL CEMAIL 	:= SUPERGETMV("MV_AV3ETAB",.F.,"douglas.fornazier@taiff.com.br;rose.araujo@taiff.com.br;gabriela.santos@taiff.com.br")
	LOCAL OPROCESS
	Local _E := 0

	//## Cria processo de Workflow
	OPROCESS 			:= TWFPROCESS():NEW( "WFAV3TAB", OEMTOANSI("WORKFLOW CROSSDOCKING - PRODUTOS SEM TABELA DE PREÇO"))
	OPROCESS:NEWTASK( "WFAV3TAB", "\WORKFLOW\WFAV3TAB.HTM" )
	OPROCESS:CTO 		:= CEMAIL
	OPROCESS:CSUBJECT 	:= OEMTOANSI("WORKFLOW - PRODUTOS SEM TABELA DE PREÇO")
	OHTML 				:= OPROCESS:OHTML

	//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	FOR _E := 1 TO LEN(ADADOS)
		AADD(OHTML:VALBYNAME("it.CODPRO")		,ALLTRIM(ADADOS[_E][1]))
		AADD(OHTML:VALBYNAME("it.DESCRICAO")	,ALLTRIM(ADADOS[_E][2]))
	NEXT _E

	//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( SUBS(CUSUARIO,7,15) )
	OPROCESS:USERSIGA	:= __CUSERID
	OPROCESS:START()
	OPROCESS:FREE()

RETURN()
