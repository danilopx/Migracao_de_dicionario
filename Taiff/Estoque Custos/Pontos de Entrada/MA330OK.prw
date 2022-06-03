#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MA330OK.prw
=================================================================================
||   Funcao: 	MA330OK
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Validar execu??o do rec?lculo do custo m?dio.
|| 		O Ponto de entrada e executado no inicio da fun??o MTA330TOk(), 
|| 	utilizado para validar se permite executar o recalculo do custo medio.
||  
=================================================================================
=================================================================================
||   Autor: Edson Hornberger 
||   Data:	30/07/2015
=================================================================================
=================================================================================
*/

USER FUNCTION MA330OK()

	LOCAL LRET 		:= .T.
	LOCAL NCCUSTOS	:= 0
	//LOCAL NREG		:= 0
	LOCAL CQUERY	:= ""
	LOCAL DDTAINI	:= DAYSUM(GETMV("MV_ULMES"),1)
	LOCAL DDTAFIM	:= MV_PAR01
	//LOCAL CMESANO	:= ""
	//LOCAL CMSG		:= ""
	LOCAL NTMPTOT	:= 0
	LOCAL NVLUNMOI	:= 0
	//LOCAL NQTDTMP	:= 0
	LOCAL NCONDIA	:= 0
	LOCAL I 		:= 0
/*
|---------------------------------------------------------------------------------
|	Salva a Area Geral e Area da Tabela SD3 antes de realizar as analises
|---------------------------------------------------------------------------------
*/
	LOCAL AAREA		:= GETAREA()
	LOCAL AAREASD3	:= SD3->(GETAREA())

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|		Inicio da Analise para dar continuidade no Processo de Recalculo de Custo 
|	Medio para a Empresa Action Varginha onde ha Industrializacao.
|		Sera verificado se existe Cadastro de Percentual de MOI e GGF para o 
|	Mes/Ano que esta sendo calculado. Tabela (SZF)
|=================================================================================
|---------------------------------------------------------------------------------
|	Caso seja empresa diferente da Action Varginha continua o processo sem analise
|---------------------------------------------------------------------------------
*/

	IF CEMPANT+CFILANT != '0402'

		RETURN(LRET)

	ENDIF

/*
|---------------------------------------------------------------------------------
|	Antes de verificar se existem os percentuais, verifico quais MOD foram 
|	utilizados no per?odo, para verificar se existem os percentuais para cada. 
|---------------------------------------------------------------------------------
*/

	CQUERY := "SELECT" 																				+ ENTER
	CQUERY += "	MIN(R_E_C_N_O_) AS D3RECNO "																		+ ENTER
	CQUERY += "FROM" 																				+ ENTER
	CQUERY += "	" + RETSQLNAME("SD3") + " SD3" 														+ ENTER
	CQUERY += "WHERE" 																				+ ENTER
	CQUERY += "	SD3.D3_FILIAL = '" + XFILIAL("SD3") + "' AND" 										+ ENTER
	CQUERY += "	SD3.D3_EMISSAO BETWEEN '" + DTOS(DDTAINI) + "' AND '" + DTOS(DDTAFIM) + "' AND" 	+ ENTER
	CQUERY += "	D3_ESTORNO = ' ' AND" 																+ ENTER
	CQUERY += "	SUBSTRING(SD3.D3_COD,1,3) = 'MOD' AND" 												+ ENTER
	CQUERY += "	D3_EMPOP IN ('N') AND" 												+ ENTER
	CQUERY += "	" + RETSQLCOND("SD3") 																+ ENTER

	IF SELECT("TRB") > 0

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

	ENDIF
//MEMOWRITE("MA330OK_RECNOMINIMO.SQL",CQUERY )
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	DBGOTOP()
	NPOSSD3 := TRB->D3RECNO

	CONOUT(NPOSSD3)

	CQUERY := "SELECT" 																				+ ENTER
	CQUERY += "	SD3.D3_COD,"																		+ ENTER
	CQUERY += "	SUM(SD3.D3_QUANT) AS QUANT"															+ ENTER
	CQUERY += "FROM" 																				+ ENTER
	CQUERY += "	" + RETSQLNAME("SD3") + " SD3" 														+ ENTER
	CQUERY += "WHERE" 																				+ ENTER
	CQUERY += "	SD3.D3_FILIAL = '" + XFILIAL("SD3") + "' AND" 										+ ENTER
	CQUERY += "	SD3.D3_EMISSAO BETWEEN '" + DTOS(DDTAINI) + "' AND '" + DTOS(DDTAFIM) + "' AND" 	+ ENTER
	CQUERY += "	D3_ESTORNO = ' ' AND" 																+ ENTER
	CQUERY += "	SD3.D3_TM > '500' AND" 																+ ENTER
	CQUERY += "	SUBSTRING(SD3.D3_COD,1,3) = 'MOD' AND" 												+ ENTER
	CQUERY += "	D3_EMPOP IN ('N') AND" 												+ ENTER
	CQUERY += "	" + RETSQLCOND("SD3") 																+ ENTER
	CQUERY += "GROUP BY" 																			+ ENTER
	CQUERY += "	SD3.D3_COD"

	IF SELECT("TRB") > 0

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	DBGOTOP()
	COUNT TO NCCUSTOS
	DBGOTOP()


/*
|---------------------------------------------------------------------------------
|	Se existe o cadastro realiza o preenchimento do array (variavel global)
|---------------------------------------------------------------------------------
*/
	IF NCCUSTOS > 0

		PRIVATE APERCENT 	:= ARRAY(NCCUSTOS,3)
		PRIVATE NPOS		:= 1

		TRB->(DBGOTOP())

	/*
	|---------------------------------------------------------------------------------
	|	Primeiro preenche com os dados do CC de MOD do periodo (SD3)
	|---------------------------------------------------------------------------------
	*/

		WHILE TRB->(!EOF())

			APERCENT[NPOS,1] 	:= TRB->D3_COD
			APERCENT[NPOS,2] 	:= 0		//  TRB->QUANT
			APERCENT[NPOS,3] 	:= 0
			///NTMPTOT 			+= TRB->QUANT
			NPOS ++
			TRB->(DBSKIP())

		ENDDO

		CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " preenche com os dados do CC de MOD do periodo (SD3) ")
		SD3->(DbSetOrder(6)) //D3_FILIAL, D3_EMISSAO, D3_NUMSEQ, D3_CHAVE, D3_COD, R_E_C_N_O_, D_E_L_E_T_
		//SD3->(DbGoTo( NPOSSD3 ))
		While !SD3->(Dbseek( xFilial("SD3") + DTOS(DDTAINI) ))
			CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " DTOS(DDTAINI): " + DTOS(DDTAINI))
			DDTAINI += 1

			NCONDIA++
			IF NCONDIA > 100
				EXIT
			ENDIF
		End

		While !SD3->(Eof()) .AND. SD3->D3_FILIAL = xFilial("SD3") .AND. DTOS(SD3->D3_EMISSAO) <= DTOS(DDTAFIM)

			If EMPTY(SD3->D3_ESTORNO)  .AND. SD3->D3_TM > "500" .AND. SUBSTR(SD3->D3_COD,1,3) = "MOD" .AND. SD3->D3_EMPOP = "N"
				NPOS := ASCAN(APERCENT,{|X| X[1] = ALLTRIM(SD3->D3_COD) })
				APERCENT[NPOS,2] 	+= SD3->D3_QUANT
				NTMPTOT 			+= SD3->D3_QUANT
			EndIf

			SD3->(DBSKIP())
		End
		//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " ****** FIM *****")

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

		CQUERY := "SELECT" 																				+ ENTER
		CQUERY += "	SD3.D3_COD,"																			+ ENTER
		CQUERY += "	SUM(SD3.D3_QUANT) AS QUANT"															+ ENTER
		CQUERY += "FROM" 																				+ ENTER
		CQUERY += "	" + RETSQLNAME("SD3") + " SD3" 														+ ENTER
		CQUERY += "WHERE" 																				+ ENTER
		CQUERY += "	SD3.D3_FILIAL = '" + XFILIAL("SD3") + "' AND" 										+ ENTER
		CQUERY += "	SD3.D3_EMISSAO BETWEEN '" + DTOS(DDTAINI) + "' AND '" + DTOS(DDTAFIM) + "' AND" 	+ ENTER
		CQUERY += "	D3_ESTORNO = ' ' AND" 																+ ENTER
		CQUERY += "	SD3.D3_TM <= '500' AND"																+ ENTER
		CQUERY += "	SUBSTRING(SD3.D3_COD,1,3) = 'MOD' AND" 												+ ENTER
		CQUERY += "	D3_EMPOP IN ('N') AND" 												+ ENTER
		CQUERY += "	" + RETSQLCOND("SD3") 																+ ENTER
		CQUERY += "GROUP BY" 																			+ ENTER
		CQUERY += "	SD3.D3_COD"
//MEMOWRITE("MA330OK_1.SQL",CQUERY )

		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")
		DBGOTOP()
		COUNT TO NCCUSTOS
		DBGOTOP()

		IF NCCUSTOS > 0

			TRB->(DBGOTOP())
		/*
		|---------------------------------------------------------------------------------
		|	Primeiro preenche com os dados do CC de MOD do periodo (SD3)
		|---------------------------------------------------------------------------------
		*/
			WHILE TRB->(!EOF())

				NPOS := ASCAN(APERCENT,{|X| X[1] = TRB->D3_COD})
				IF NPOS > 0

					APERCENT[NPOS,2] -= TRB->QUANT

				ENDIF
				NTMPTOT -= TRB->QUANT
				TRB->(DBSKIP())

			ENDDO

		ENDIF

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

	/*
	|---------------------------------------------------------------------------------
	|	Realizando a soma dos Debitos/Credito e achando o Saldo para calculo dos 
	|	percentuais que serao agragados.
	|---------------------------------------------------------------------------------
	*/

		CQUERY := "SELECT" 														+ ENTER
		CQUERY += "	(SUM(CQ3.CQ3_DEBITO) - SUM(CQ3.CQ3_CREDIT)) / " + ALLTRIM(STR(NTMPTOT)) + " AS 'SALDO'" 	+ ENTER
		CQUERY += "FROM" 														+ ENTER
		CQUERY += "	" + RETSQLNAME("CQ3") + " CQ3" 								+ ENTER
		CQUERY += "WHERE" 														+ ENTER
		CQUERY += "	CQ3.CQ3_FILIAL = '" + XFILIAL("CQ3") + "' AND" 				+ ENTER
		CQUERY += "	CQ3.CQ3_DATA BETWEEN '" + DTOS(DDTAINI) + "' AND '" + DTOS(DDTAFIM) + "' AND" 	+ ENTER
		CQUERY += "	CQ3.CQ3_CONTA != '6203090001' AND"							+ ENTER // CONTA REDUTORA NAO DEVE ENTRAR NO CALCULO
		CQUERY += "	CQ3.CQ3_CCUSTO IN" 											+ ENTER
		CQUERY += "	(" 															+ ENTER
		CQUERY += "		SELECT" 												+ ENTER
		CQUERY += "			CTT.CTT_CUSTO" 										+ ENTER
		CQUERY += "		FROM" 													+ ENTER
		CQUERY += "			" + RETSQLNAME("CTT") + " CTT" 						+ ENTER
		CQUERY += "		WHERE" 													+ ENTER
		CQUERY += "			CTT.CTT_CCTIPO = '1' AND" 							+ ENTER
		CQUERY += "			CTT.D_E_L_E_T_ = ''" 								+ ENTER
		CQUERY += "	) AND" 														+ ENTER
		CQUERY += "	CQ3.D_E_L_E_T_ = ''"
//MEMOWRITE("MA330OK_2.SQL",CQUERY )

		IF SELECT("CST") > 0

			DBSELECTAREA("CST")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "CST"
		DBSELECTAREA("CST")
		DBGOTOP()
		COUNT TO NVLUNMOI

		IF NVLUNMOI > 0

			CST->(DBGOTOP())
			NVLUNMOI := CST->SALDO

		ENDIF
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " CST->SALDO: " + ALLTRIM(STR(CST->SALDO,2)) )	
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " NVLUNMOI: " + ALLTRIM(STR(NVLUNMOI,2)) )	

	/*
	|---------------------------------------------------------------------------------
	|	Grava o custo unitario do MOI e GGF em um array que sera declarado como Global 
	|---------------------------------------------------------------------------------
	*/
		FOR I := 1 TO LEN(APERCENT)

			IF SELECT("CST") > 0
				DBSELECTAREA("CST")
				DBCLOSEAREA()
			ENDIF

			CQUERY := "SELECT" 														+ ENTER
			CQUERY += "	(SUM(CQ3.CQ3_DEBITO) - SUM(CQ3.CQ3_CREDIT)) / " + ALLTRIM(STR(APERCENT[I,2])) + " AS 'SALDO'" 	+ ENTER
			CQUERY += "FROM" 														+ ENTER
			CQUERY += "	" + RETSQLNAME("CQ3") + " CQ3" 								+ ENTER
			CQUERY += "WHERE" 														+ ENTER
			CQUERY += "	CQ3.CQ3_FILIAL = '" + XFILIAL("CQ3") + "' AND" 				+ ENTER
			CQUERY += "	CQ3.CQ3_DATA BETWEEN '" + DTOS(DDTAINI) + "' AND '" + DTOS(DDTAFIM) + "' AND" 	+ ENTER
			CQUERY += "	CQ3.CQ3_CONTA != '6203090001' AND"							+ ENTER // CONTA REDUTORA NAO DEVE ENTRAR NO CALCULO
			CQUERY += "	CQ3.CQ3_CCUSTO = '" + SUBSTR(APERCENT[I,1],4,11) + "' AND"	+ ENTER
			CQUERY += "	CQ3.D_E_L_E_T_ = ''"
//MEMOWRITE("MA330OK_3.SQL",CQUERY )

			TCQUERY CQUERY NEW ALIAS "CST"

			APERCENT[I,3] := CST->SALDO + NVLUNMOI

//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " CST->SALDO: " + ALLTRIM(STR(CST->SALDO,2)) )	
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " NVLUNMOI: " + ALLTRIM(STR(NVLUNMOI,2)) )	

		NEXT I

		DBSELECTAREA("CST")
		DBCLOSEAREA()

	/*
	|---------------------------------------------------------------------------------
	|	Cria variaveL GlobaL onde serao salvos os valores que serao agregados.
	|---------------------------------------------------------------------------------
	*/	
		PUTGLBVARS("aGlbMT330",APERCENT)

	ENDIF

/*
|---------------------------------------------------------------------------------
|	Restaura a Area da Tabela SD3 e da Area Geral
|---------------------------------------------------------------------------------
*/
	RESTAREA(AAREASD3)
	RESTAREA(AAREA)

RETURN(LRET)
