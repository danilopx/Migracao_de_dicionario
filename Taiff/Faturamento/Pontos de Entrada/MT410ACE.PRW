#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT410ACE.PRW
=================================================================================
||   Funcao:	MT410ACE 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de Entrada no Pedido de Vendas para verificar o acesso do usuário 
|| nas rotinas: Excluir, Visualizar, Residuo, Copiar e Alterar. 
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:		11/02/2014
=================================================================================
=================================================================================
*/

USER FUNCTION MT410ACE

LOCAL LRET 		:= .T.
LOCAL NOPC		:= PARAMIXB[1]
LOCAL CQUERY 	:= ""
LOCAL APEDBON	:= {}
LOCAL CPEDBON	:= ""
LOCAL NI		:= 0
Local _nMarca 	:= 0
Local cVOrdSep	:= SuperGetMV("MT410ACE01",,"S")
Local cVOSStat	:= SuperGetMV("MT410ACE02",,"AND CB7.CB7_STATUS <> '9'") //Verifica Status da OS

/*
|---------------------------------------------------------------------------------
|	Realiza o controle de Exclusão de Pedidos de Venda no processo de CrossDocking
|---------------------------------------------------------------------------------
*/
IF CEMPANT + CFILANT = "0301" .AND. INCLUI = ALTERA .AND. NOPC != 2
	
	IF .NOT. C5_STCROSS $ "ABERTO|AGCOPY" .AND. !EMPTY(C5_STCROSS) 
		
		MSGSTOP("Processo de atendimento do Pedido no CD de MG já foi iniciado!" + ENTER + "O mesmo não poderá ser excluído!" + ENTER + "Utilize o processo de Eliminação de Resíduos!" + ENTER + "Validação Técnica: MT410ACE","Atenção")
		LRET := .F.
		
	ENDIF

ELSEIF CEMPANT + CFILANT = "0302" .AND. INCLUI = ALTERA .AND. SC5->C5_FILDES = "01" .AND. NOPC != 2 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO )

	MSGSTOP("Pedido referente atendimento SP somente pode ser excluído pela Filial SP!","Atenção")
	LRET := .F.
	
ELSEIF CEMPANT + CFILANT = "0302" .AND. INCLUI = ALTERA .AND. SC5->C5_FILDES = "01" .AND. NOPC = 2 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO ) .AND. IsInCallStack("Ma410Resid")

	MSGSTOP("Pedido referente atendimento SP somente pode ser eliminado resíduo pela Filial SP!","Atenção")
	LRET := .F.

ELSEIF CEMPANT + CFILANT = "0302" .AND. ALTERA .AND. SC5->C5_FILDES = "01" .AND. NOPC != 2 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO )
	_nMarca := Iif( SC5->C5_XITEMC="TAIFF",1, Iif(SC5->C5_XITEMC="PROART",2,4) )
	cQuery := "SELECT COUNT(*) AS NREG " + ENTER
	cQuery += " FROM " + RetSQLName("SC9")+" SC9 " + ENTER
	cQuery += " WHERE " + ENTER
	cQuery += " C9_FILIAL = '"+xFilial("SC9")+"' " + ENTER 
	cQuery += " AND C9_NUMOF != '' "  + ENTER
	cQuery += " AND C9_XITEM = '" + Alltrim(Str(_nMarca)) + "' " + ENTER
	cQuery += " AND C9_NFISCAL = '' " + ENTER
	cQuery += " AND SC9.D_E_L_E_T_ = '' " + ENTER
	cQuery += " AND C9_PEDIDO = '" + SC5->C5_NUM + "' " + ENTER
	
	//MemoWrite("MT410ACE_select_de_numof.SQL",cQuery)
	
	IF SELECT("AUX") > 0 
		DBSELECTAREA("AUX")
		DBCLOSEAREA()
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "AUX"
	DBSELECTAREA("AUX")
	IF AUX->NREG > 0
		MSGSTOP("Pedido em processo de transferencia para São Paulo!" + ENTER + "Solicite o estorno do Agrupamento à expedição." ,"Atenção")
		LRET := .F.
	EndIf
	
ELSEIF CEMPANT + CFILANT = "0301" .AND. ALTERA .AND. NOPC != 2 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO ) .AND. C5_STCROSS = "AGFATU" .AND. C5_CLASPED $ ("V|B") .AND. C5_TIPO = "N"

	MESSAGEBOX("Pedido aguardando Faturamento não pode ser alterado." + ENTER + "Entre em contato com o Departamento de TI!","ATENÇÃO",48)
	LRET := .F.

ELSEIF CEMPANT + CFILANT = "0302" .AND. ALTERA .AND. NOPC != 2 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO )

	If !Empty(cVOSStat)

		//Verifica se algum item do PV esta' em processo de separacao,
		//comparando as sequencias de liberacao da SC9 com a CB8
		cQuery := "SELECT DISTINCT "
		cQuery += "CB7.CB7_STATUS AS STPED "
		cQuery += "FROM " +RetSqlName("CB7")+ " CB7 "
		cQuery += "INNER JOIN " +RetSqlName("CB8")+ " CB8 ON CB8.D_E_L_E_T_ = ' ' "
		cQuery += "AND CB8.CB8_FILIAL = CB7.CB7_FILIAL "
		cQuery += "AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP "
		cQuery += "AND CB8.CB8_PEDIDO = CB7.CB7_PEDIDO "
		cQuery += "INNER JOIN " +RetSqlName("SC9")+ " SC9 ON SC9.D_E_L_E_T_ = ' ' "
		cQuery += "AND SC9.C9_FILIAL = CB7.CB7_FILIAL "
		cQuery += "AND SC9.C9_ORDSEP = CB7.CB7_ORDSEP "
		cQuery += "AND SC9.C9_PEDIDO = CB7.CB7_PEDIDO "
		cQuery += "AND SC9.C9_ITEM = CB8.CB8_ITEM "
		cQuery += "AND SC9.C9_PRODUTO = CB8.CB8_PROD "
		cQuery += "AND SC9.C9_SEQUEN = CB8.CB8_SEQUEN "
		cQuery += "AND SC9.C9_NFISCAL = '         ' "
		cQuery += "WHERE CB7.D_E_L_E_T_ = ' ' "
		cQuery += "AND CB7.CB7_FILIAL = '" +SC5->C5_FILIAL+ "' "
		cQuery += "AND CB7.CB7_PEDIDO = '" +SC5->C5_NUM+ "' "
		cQuery += cVOSStat

		Iif(Select("WC9B78")>0,WC9B78->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"WC9B78",.T.,.T.)
		WC9B78->(dbGoTop())

		If WC9B78->(!EoF())
			If !Empty(WC9B78->STPED)
				lRet := .F.
			EndIf
		EndIf
		WC9B78->(dbCloseArea())

		If !lRet
			MessageBox("Pedido não pode ser alterado/excluído," + ENTER + "pois há itens em processo de separação","ATENÇÃO",48)
		EndIf

	EndIf

ENDIF

/*
|---------------------------------------------------------------------------------
|	REALIZA A VERIFICACAO DE PEDIDOS ASSOCIADOS REFERENTE A BONIFICACAO
|	ANTES DE REALIZAR A EXCLUSAO
|---------------------------------------------------------------------------------
*/

IF LRET .AND. INCLUI = ALTERA .AND. NOPC != 2 .AND. CEMPANT = "03" .AND. SC5->C5_CLASPED != "A"

	IF !EMPTY(ALLTRIM(SC5->C5_X_PVBON)) .AND. SC5->C5_CLASPED != "X"
		
		APEDBON := STRTOKARR(ALLTRIM(SC5->C5_X_PVBON),"/")
		CPEDBON := "('"
		
		FOR NI := 1 TO LEN(APEDBON)
			
			CPEDBON += IIF(LEN(CPEDBON) = 2, APEDBON[NI] + "'", ",'" + APEDBON[NI] + "'")  
			
		NEXT NI 
		
		CPEDBON += ")" 
			
		CQUERY := "SELECT" 											+ ENTER 
		CQUERY += "	'X' AS EXISTE" 									+ ENTER 
		CQUERY += "FROM" 											+ ENTER
		CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 					+ ENTER
		CQUERY += "WHERE" 											+ ENTER 
		CQUERY += "	SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 	+ ENTER 
		CQUERY += "	SC5.C5_NUMOLD IN " + CPEDBON + " AND" 			+ ENTER 
		CQUERY += "	SC5.D_E_L_E_T_ = ''" 
		
		IF SELECT("TMP") > 0 
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
		ENDIF 
		
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		
		IF TMP->EXISTE = "X"
			
			MSGSTOP("Existem Pedidos de Bonificação amarrados a este Pedido." + ENTER + "Exclua os Pedidos de Bonificação. Após isso exclua o Pedido de Venda","ATENÇÃO")
			LRET := .F.
			
		ENDIF			
				
	ENDIF 

ENDIF

//Verifica se Pedido tem ordem de separação vinculada
If cVOrdSep == "S"
	If lRet
		If ( nOpc == 1 .Or. nOpc == 4 ) // 1-Excluir, 2-Visualizar/Residuo, 3-Copiar, 4-Alterar
			If cEmpAnt + cFilAnt == "0302"

				cQuery := "SELECT DISTINCT C9.C9_PEDIDO "
				cQuery += "FROM " +RetSqlName("SC9")+ " C9 "
				cQuery += "WHERE C9.D_E_L_E_T_ = ' ' "
				cQuery += "AND C9.C9_FILIAL = '" +SC5->C5_FILIAL+ "' "
				cQuery += "AND C9.C9_PEDIDO = '" +SC5->C5_NUM+ "' "
				cQuery += "AND C9.C9_NFISCAL = '' "
				cQuery += "AND ( C9.C9_ORDSEP <> '' OR C9.C9_XORDSEP <> '' ) "

				Iif(Select("WKC5C9")>0,WKC5C9->(dbCloseArea()),Nil)
				dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"WKC5C9",.T.,.T.)
				WKC5C9->(dbGoTop())

				If WKC5C9->(!EoF())
					If !Empty(WKC5C9->C9_PEDIDO)
						lRet := .F.
					EndIf
				EndIf
				WKC5C9->(dbCloseArea())

				If !lRet
					MsgStop("Não é possível " +Iif(nOpc==1,"excluir","alterar")+ " este pedido, pois há itens vinculados a ordem de separação.")
				EndIf

			EndIf
		EndIf
	EndIf
EndIf

RETURN(LRET)
