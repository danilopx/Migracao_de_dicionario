#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)
#DEFINE CRLF CHR(13) + CHR(10)

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

USER FUNCTION M460MARK()

	LOCAL LRETORNO		:= .T.

	LOCAL _DATUAL 		:= DTOS(DATE())
	LOCAL _CPEDDE  		:= ""
	LOCAL _CPEDATE 		:= ""
	LOCAL _CCLIDE  		:= ""
	LOCAL _CCLIATE 		:= ""
	LOCAL _CDLBDE  		:= ""
	LOCAL _CDLBATE 		:= ""

	LOCAL _CPEDIDO  	:= ""
	LOCAL _AAREASC9		:= SC9->(GETAREA())
	LOCAL _AAREASC5		:= SC5->(GETAREA())

	LOCAL _LMARCA		:= .T.
	LOCAL CQUERY		:= ""
	//LOCAL NULTSELE		:= SELECT()
	//LOCAL LUNINEG		:= CEMPANT+CFILANT $ GETNEWPAR('MV_UNINEG',CEMPANT+CFILANT,) // -- SEPARAR NO PARAMETRO AS EMPRESAS FILIAIS CONCATENADAS. EX. 0302/0303

	Local _lStatusFaseII := GetNewPar("MV_ARMCEN",.F.)
	Local nSx1opc
	Local cOCcross	:= ""

	LOCAL ABOTOES1 		:= {OEMTOANSI("Cancela")}
	LOCAL CMSG			:= ""
	LOCAL CTIT			:= OEMTOANSI("Geração de Documento de Saída (NF)")

	Local nSeleAsstec := 0
	Local cSeleTransP	:= ""
	Local cPedBRsep	:= ""
	Local I := 0
	Local _nIx := 0

	PRIVATE CSMFT01		:= GETMV("MV_SMFT01",.F.,"DEFAULT01")
	PRIVATE CSMFT02		:= GETMV("MV_SMFT02",.F.,"DEFAULT02")

	PRIVATE CPEDBLOCK 	 := ""
	Private _l460BNF     := EXISTBLOCK("RM460BNF")
	Private _l460ATC     := EXISTBLOCK("RM460ATC")
	Private _l460AVI     := EXISTBLOCK("RM460AVI")
	Private _cBNFIL      := GETMV("MV_X_BNFIL")
	Private _cMLT08      := SUPERGETMV("MV__MULT08",.F.,"")
	Private _cSEPA01     := SUPERGETMV("MV__SEPA01",.F.,"")

	PRIVATE _LRETBNF     	:= .T.
	PRIVATE _LC5CLASPD   	:= ALLTRIM(GETSX3CACHE("C5_CLASPED", "X3_CAMPO")) == "C5_CLASPED"
	PRIVATE _LC5PVBON    	:= ALLTRIM(GETSX3CACHE("C5_X_PVBON", "X3_CAMPO")) == "C5_X_PVBON"
	PRIVATE _LC5LIBON    	:= ALLTRIM(GETSX3CACHE("C5_X_LIBON", "X3_CAMPO")) == "C5_X_LIBON"
	PRIVATE _NCALL       	:= 1
	PRIVATE _LPOSICIONA  	:= .F.
	PRIVATE APEDVENBNF		:= {}
	PRIVATE APEDBNFVEN		:= {}
	PRIVATE APEDBNFVNC		:= {}
	PRIVATE ATEMPBNF		:= {}
	PRIVATE _CTITBNF		:= ""
	PRIVATE _CPROBNF		:= ""
	PRIVATE _CSOLBNF		:= ""

	Private _lRetATC     := .T.
	Private _aLbNaoMrk   := {}
	Private _aPVATec     := {}
	Private _cSolATC     := ""
	Private _cProATC     := ""
	Private _cTitATC     := ""

	IF CEMPANT + CFILANT = '0302'
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Verificacao de Semaforo 01. O mesmo nao podera concorrer com a Execucao da 
	|	Geracao da OC e com a Liberacao de Pedidos.
	|
	|	Edson Hornberger - 11/09/2015
	|=================================================================================
	*/
		CMSG := 	ENTER + OEMTOANSI("Existe um usuário bloqueando os Saldos em Estoque."			) + ;
			ENTER + OEMTOANSI("Aguarde uns instantes para que seja liberado!"				) + ;
			ENTER + OEMTOANSI("Caso clique em CANCELAR todo o processo deverá ser"			) + ;
			ENTER + OEMTOANSI("realizado novamente!"	)

		WHILE !LOCKBYNAME(CSMFT01,.T.,.T.)

			IF AVISO(CTIT,CMSG,ABOTOES1,3,OEMTOANSI("   ATENÇÃO") + ENTER + ENTER ,,"AVN_A1_INFO",.F.,10000,2) == 1
				RETURN()
			ENDIF

		ENDDO

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Verificacao de Semaforo 02. O mesmo nao podera concorrer 
	|	com a Liberacao de Pedidos.
	|
	|	Edson Hornberger - 11/09/2015
	|=================================================================================
	*/

		WHILE !LOCKBYNAME(CSMFT02,.T.,.T.)

			IF AVISO(CTIT,CMSG,ABOTOES1,3,OEMTOANSI("   ATENÇÃO") + ENTER + ENTER ,,"AVN_A1_INFO",.F.,10000,2) == 1
				RETURN()
			ENDIF

		ENDDO
	ENDIF

	PERGUNTE("MT461A", .F.)

	_CPEDDE  := MV_PAR05
	_CPEDATE := MV_PAR06
	_CCLIDE  := MV_PAR07 + MV_PAR09
	_CCLIATE := MV_PAR08 + MV_PAR10
	_CDLBDE  := DTOS(MV_PAR11)
	_CDLBATE := DTOS(MV_PAR12)


	If _lStatusFaseII
		SX1->(DbsetOrder(1))
		SXK->(DbsetOrder(1))

	/* Para o PROTHEUS 12 o grupo de pergunta mudou de 16 para 17 */
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO))+ "17" + "U" + __CUSERID) )
			nSx1opc := 	VAL(LEFT(SXK->XK_CONTEUD,1))
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'17') )
			nSx1opc := 	SX1->X1_PRESEL
		EndIf

		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO))+ "18" + "U" + __CUSERID) )
			cOCcross := ALLTRIM(SXK->XK_CONTEUD)
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'18') )
			cOCcross := SX1->X1_CNT01
		EndIf
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "19" + "U" + __CUSERID) )
			nSeleAsstec := VAL(LEFT(SXK->XK_CONTEUD,1))
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'19') )
			nSeleAsstec := SX1->X1_PRESEL
		EndIf
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "20" + "U" + __CUSERID) )
			cSeleTransP := ALLTRIM(SXK->XK_CONTEUD)
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'20') )
			cSeleTransP := ALLTRIM(SX1->X1_CNT01)
		EndIf
	/* Grupo de pergunta: Pedido BR com separacao? */	
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "21" + "U" + __CUSERID) )
			cPedBRsep := Iif( LEFT(SXK->XK_CONTEUD,1) = "1" , "S" , "N" )
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'21') )
			cPedBRsep := Iif( SX1->X1_PRESEL = 1 , "S" , "N" )
		EndIf
	EndIf

	PERGUNTE("MT460A", .F.)

	CQUERY := "SELECT" 																+ CRLF
	CQUERY += "	SC9.*,"																+ CRLF
	CQUERY += "	SC5.C5_TIPO,"														+ CRLF
	CQUERY += "	SC5.C5_XLIBCR,"														+ CRLF
	CQUERY += "	SC5.C5_XITEMC,"														+ CRLF
	CQUERY += "	SC5.C5_YSTSEP,"                                   					+ CRLF
	CQUERY += "	SC5.C5_DTPEDPR,"                                   					+ CRLF
// SOMENTE IRA VERIFICAR QUANDO FOR TAIFFPROART (EMPRESA 03)
	IF (SUPERGETMV("MV_ARMCEN",.F.,.F.))
		CQUERY += "	SC5.C5_NUMOC,"														+ CRLF
	ENDIF
	CQUERY += "	SA1.A1_EST,"														+ CRLF
	CQUERY += "	SA1.A1_COD_MUN,"													+ CRLF
	CQUERY += "	SA1.A1_CALCSUF," 													+ CRLF
	CQUERY += "	SA1.A1_VLDSUFR,"													+ CRLF
	CQUERY += "	SA1.A1_SUFRAMA,"													+ CRLF
	CQUERY += "	SF4.F4_SITTRIB"														+ CRLF
	CQUERY += "	,SF4.F4_ESTOQUE"														+ CRLF
	CQUERY += "FROM"																+ CRLF
	CQUERY += "	" + RETSQLNAME("SC9") + " SC9 WITH(NOLOCK) " 										+ CRLF
	CQUERY += "		INNER JOIN " + RETSQLNAME("SC5") + " SC5 WITH(NOLOCK) " 					+ CRLF
	CQUERY += "			ON SC5.C5_FILIAL	= '" + XFILIAL("SC5") + "'" 	+ CRLF
	CQUERY += "			AND	SC5.C5_NUM		= SC9.C9_PEDIDO"	+ CRLF
	CQUERY += "			AND SC5.C5_TIPO 	NOT IN ('D','B')" + CRLF
	CQUERY += "			AND SC5.D_E_L_E_T_	= ''"	+ CRLF
	If SC5->(FIELDPOS("C5__DTLIBF")) > 0 .AND. CEMPANT="03" .AND. CFILANT="02"
		CQUERY += "			AND SC5.C5__BLOQF	= '' " + CRLF
		CQUERY += "			AND (  " + CRLF
		CQUERY += "			SC5.C5__DTLIBF != '' " + CRLF
		CQUERY += "			AND  SC5.C5__DTLIBF <= '"+ DTOS(DDATABASE) +"' " + CRLF
		CQUERY += "			)  " + CRLF
	EndIf
	If CEMPANT="03"
		CQUERY += "			AND SC5.C5_LIBCOM != '2' " + CRLF
	EndIF
	If CEMPANT="03" .AND. !EMPTY(cSeleTransP) .AND. CFILANT="02"
		CQUERY += "			AND SC5.C5_TRANSP = '" + cSeleTransP + "' " + CRLF
	EndIf
	CQUERY += "		INNER JOIN " + RETSQLNAME("SC6") + " SC6 WITH(NOLOCK) " 	+ CRLF
	CQUERY += "			ON	SC6.C6_FILIAL	= SC9.C9_FILIAL	AND" 	+ CRLF
	CQUERY += "			SC6.C6_NUM		= SC9.C9_PEDIDO		AND" 	+ CRLF
	CQUERY += "			SC6.C6_ITEM		= SC9.C9_ITEM		AND" 	+ CRLF
	CQUERY += "			SC6.C6_PRODUTO	= SC9.C9_PRODUTO	AND" 	+ CRLF
	CQUERY += "			SC6.D_E_L_E_T_	= ''" 	+ CRLF
	CQUERY += "		INNER JOIN " + RETSQLNAME("SA1") + " SA1 WITH(NOLOCK) ON"					+ CRLF
	CQUERY += "			SA1.A1_FILIAL	= '" + XFILIAL("SA1") + "'			AND" 	+ CRLF
	CQUERY += "			SA1.A1_COD		= SC9.C9_CLIENTE					AND"	+ CRLF
	CQUERY += "			SA1.A1_LOJA		= SC9.C9_LOJA						AND"	+ CRLF
	CQUERY += "			SA1.D_E_L_E_T_	= ''"										+ CRLF
	CQUERY += "		INNER JOIN " + RETSQLNAME("SF4") + " SF4 WITH(NOLOCK) ON"					+ CRLF
	CQUERY += "			SF4.F4_FILIAL	= '" + XFILIAL("SF4") + "'			AND"	+ CRLF
	CQUERY += "			SF4.F4_CODIGO	!= '998'							AND"	+ CRLF
	CQUERY += "			SF4.F4_CODIGO	= SC6.C6_TES						AND"	+ CRLF
	CQUERY += "			SF4.D_E_L_E_T_	= ''"										+ CRLF
	/* Filtro implementado para atender a separação antes do faturamento, quando nSx1opc = 1 significa produtos TAIFF */
	/* Funcionalidade do projeto de endereçamento                               */
	/* Data: 29/05/2020                               Responsável: Carlos Torres*/
	/* ID Controle: 001-460MK */
	/* incluida a PROART nesta condição para atender o faturamento somente com OS finalizada */ 
	If CEMPANT = "03" .AND. CFILANT = "02" .AND. (nSx1opc = 1 .OR. nSx1opc = 2)
		CQUERY += "		INNER JOIN " + RETSQLNAME("CB7") + " CB7 WITH(NOLOCK)" + CRLF
		CQUERY += "			ON CB7_FILIAL	= '" + XFILIAL("CB7") + "'" + CRLF
		CQUERY += "			AND CB7.D_E_L_E_T_ = ''" + CRLF
		CQUERY += "			AND CB7_ORDSEP	= C9_ORDSEP "	+ CRLF
		CQUERY += "			AND CB7_ORDSEP	= '9' "	+ CRLF
	EndIf
	/* fim de controle 001-460MK */
	CQUERY += "WHERE"																+ CRLF
	CQUERY += "	SC9.C9_FILIAL	= '" + XFILIAL("SC9") + "'					AND"	+ CRLF
	CQUERY += "	SC9.C9_NFISCAL	= ''										AND"	+ CRLF
	CQUERY += "	SC9.C9_PEDIDO	BETWEEN '" + _CPEDDE + "' AND '" + _CPEDATE + "'	AND" 				+ CRLF
	CQUERY += "	(SC9.C9_CLIENTE + SC9.C9_LOJA) BETWEEN '" + _CCLIDE + "' AND '" + _CCLIATE + "' AND" 	+ CRLF
	CQUERY += "	SC9.C9_DATALIB	BETWEEN '" + _CDLBDE + "' AND '" + _CDLBATE + "' AND" 					+ CRLF
	CQUERY += "	SC9.D_E_L_E_T_	= ''" 												+ CRLF
	If _lStatusFaseII
		CQUERY += " 	AND SC9.C9_XEMP = '"+CEMPANT+"' "+ CRLF
		CQUERY += " 	AND SC9.C9_XFIL = '"+CFILANT+"' "+ CRLF
		CQUERY += "	AND SC9.C9_XITEM = '"+Alltrim(Str(nSx1opc))+"' "+ CRLF
		If CEMPANT="03" .AND. CFILANT="01" .AND. !Empty(cOCcross)
			CQUERY += "	AND SC9.C9_NUMOF = '" + Alltrim(cOCcross) + "' "+ CRLF
		EndIf
	EndIf
/* Tratamento implementado para diferenciar atendimento da ASTEC ja que o faturamento é pelo armazem 51 */
	If CEMPANT="03" .AND. CFILANT="01"
		If nSeleAsstec = 1
			CQUERY += "	AND SC9.C9_LOCAL != '51' "+ CRLF
			CQUERY += "	AND SC5.C5_CLASPED != 'A' "+ CRLF
		ElseIf nSeleAsstec = 2
			CQUERY += "	AND SC9.C9_LOCAL = '51' "+ CRLF
			CQUERY += "	AND SC5.C5_CLASPED = 'A' "+ CRLF
		EndIf
	EndIf
	CQUERY += "ORDER BY"															+ CRLF
	CQUERY += "	SC9.C9_PEDIDO,"														+ CRLF
	CQUERY += "	SC9.C9_ITEM"

	//MemoWrite("M460MARK_filtro_SC9.sql",CQUERY)

	IF SELECT("TSC9") > 0

		DBSELECTAREA("TSC9")
		TSC9->(DBCLOSEAREA())

	ENDIF

	Do While !Empty(AllTrim(ProcName(_nCall)))

		If "FWPREEXECUTE" $ Upper(AllTrim(ProcName(_nCall))) .and. "DOCUMENTO DE SAIDA" $ Upper(AllTrim(ProcName(_nCall)))

			_lPosiciona := .T.
			Exit

		EndIf

		_nCall ++

	EndDo

	TCQUERY CQUERY NEW ALIAS "TSC9"
	DBSELECTAREA("TSC9")

	WHILE TSC9->(!EOF())

	/*
	|---------------------------------------------------------------------------------
	|	Verifica se o item do SC9 esta marcado e alimenta a variavel _LMARCA
	|---------------------------------------------------------------------------------
	*/
		DBSELECTAREA("SC9")
		SC9->(DBGOTO(TSC9->R_E_C_N_O_))
		_LMARCA	:= ((TSC9->C9_OK != PARAMIXB[1] .And. PARAMIXB[2] .AND. !A460AVALIA()) .or. (TSC9->C9_OK == PARAMIXB[1] .And. !PARAMIXB[2]))

	/*
	|---------------------------------------------------------------------------------
	|	Processos que serao realizados apenas uma vez por Pedido e nao por Item do Pedido
	|---------------------------------------------------------------------------------
	*/
		IF EMPTY(_CPEDIDO) .OR. _CPEDIDO != TSC9->C9_PEDIDO

			_CPEDIDO 	:= TSC9->C9_PEDIDO

			IF _LMARCA

			/*
			|---------------------------------------------------------------------------------
			|	VALIDAÇÃO PARA CLIENTES QUE PERTENCEM A AMAZONIA OCIDENTAL
			|---------------------------------------------------------------------------------
			*/
				IF (U_RETAMOCIDENTAL(TSC9->A1_EST, TSC9->A1_COD_MUN) .AND. TSC9->A1_CALCSUF <> "N")

					Alert( "Não será possível faturar os pedidos do cliente " + TSC9->C9_CLIENTE + ". Município do cliente pertence a Amazonia Ocidental, e o campo Desc.Suframa deveria estar parametrizado como (Não). ","")
					LRETORNO := .F.

				ENDIF

			/*
			|---------------------------------------------------------------------------------
			|	VALIDAÇÃO PARA CLIENTES QUE TENHAM O SUFRAMA VENCIDO
			|---------------------------------------------------------------------------------
			*/
				IF(!EMPTY(TSC9->A1_SUFRAMA) .AND. (EMPTY(TSC9->A1_VLDSUFR) .OR. TSC9->A1_VLDSUFR < _DATUAL) .AND. LRETORNO)

					Alert( "Não será possível faturar os pedidos do cliente" + TSC9->C9_CLIENTE + ". Cliente possui código Suframa com Data de Validade vencida ou vazia.","")
					LRETORNO := .F.

				ENDIF

			/*
			|---------------------------------------------------------------------------------
			|	Valida concessao do regime especial - C. Torres 09/01/2012
			|---------------------------------------------------------------------------------
			*/
				IF !U_TFRETCONCESSAOOK( TSC9->C9_PEDIDO,TSC9->C9_CLIENTE,TSC9->C9_LOJA,TSC9->C5_XITEMC )

					LRETORNO := .F.

				ENDIF

			/*
			|---------------------------------------------------------------------------------
			|	Verificacao de Liberacao de Credito - INCUIDO POR VETI - THIAGO COMELLI - 26/11/2012
			|---------------------------------------------------------------------------------
			*/
				IF (CEMPANT+CFILANT) $ _cMLT08

					IF TSC9->C5_XLIBCR <> 'L'

						ALERT( "PEDIDO " + _CPEDIDO + " NÃO ESTÁ COM O CRÉDITO LIBERADO. NOTA FISCAL NÃO EMITIDA!","")
						LRETORNO := .F.

					ENDIF

				ENDIF

				IF CEMPANT="03" .AND. CFILANT="02"

					IF TSC9->C5_DTPEDPR > DTOS(DDATABASE)

						ALERT( "Pedido " + _CPEDIDO + " com data programa de faturamento superior à data corrente. Note Fiscal não emitida!","")
						LRETORNO := .F.

					ENDIF

				ENDIF
			/*
			|---------------------------------------------------------------------------------
			|	Verifica se todos os itens do Pedido de transferencia de CrossDocking foram 
			|	liberados corretamente.
			|	Edson Hornberger - 21/08/2015
			|---------------------------------------------------------------------------------
			*/

				IF (SUPERGETMV("MV_ARMCEN",.F.,.F.))

					IF !EMPTY(TSC9->C5_NUMOC) .AND. !VERIFLIBER(_CPEDIDO)

						ALERT("PEDIDO " + _CPEDIDO + " LIBERADO PARCIALMENTE (ERRO!) !","CROSSDOCKING - TRANSFERÊNCIA")
						LRETORNO:= .F.

					ENDIF

				ENDIF
			/*
			|---------------------------------------------------------------------------------
			|	Verifica se os pedidos da filial 0302 e PROART tiveram a pesagem finalizada 
			|	a partir da tabela ZAR
			|	TRADE - 26/12/2019
			|---------------------------------------------------------------------------------
			*/
				IF  cEmpAnt + cfilAnt == "0302" .AND. alltrim(TSC9->C5_XITEMC) == "PROART" .AND. CB7->(FIELDPOS("CB7_X_QTVO")) > 0

					_cQuery := "SELECT ISNULL(COUNT(*),0) AS NPESPENDENTE " + ENTER
					_cQuery += "FROM "+RETSQLNAME("ZAR")+" ZAR " 		+ ENTER
					_cQuery += "JOIN "+RETSQLNAME("CB7")+" CB7 ON "     + ENTER
					_cQuery += "ZAR_FILIAL = CB7_FILIAL AND ZAR_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = '' " + ENTER
					_cQuery += "WHERE ZAR_FILIAL = '"+ XFILIAL("ZAR")+"' AND "	+ ENTER
					_cQuery += "CB7_PEDIDO = '"+TSC9->C9_PEDIDO+"' AND ZAR_STATUS <> 'F' "		+ ENTER
					_cQuery += "AND ZAR.D_E_L_E_T_ = '' " + ENTER
					IF  SELECT("TZAR")
						Dbclosearea()
					ENDIF
					DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TZAR',.F.,.T.)
					Dbselectarea("TZAR")
					Dbgotop()
					IF   TZAR->NPESPENDENTE > 0
						ALERT("PEDIDO " + _CPEDIDO + " COM PESAGEM PENDENTE (ERRO!) !","")
						LRETORNO:= .F.
					ENDIF
				ENDIF

			ENDIF

		ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Processos que serao realizados por Item do Pedido de Venda
	|---------------------------------------------------------------------------------
	*/

	/*
	|---------------------------------------------------------------------------------
	|	Validacao do Processo de Separacao / Conferencia 
	|---------------------------------------------------------------------------------
	*/
		IF LRETORNO .AND. (CEMPANT+CFILANT) $ _cSEPA01 .AND. ALLTRIM(TSC9->C5_XITEMC) = "PROART" .AND. _LMARCA .AND. TSC9->F4_ESTOQUE = "S"

			IF !VALSEPA(@CPEDBLOCK)

				LRETORNO := .F.

			ENDIF

		ENDIF

		If SC5->C5_NUM <> SC9->C9_PEDIDO

			DBSelectArea("SC5")
			DBSetOrder(1)
			DBSeek(xFilial() + SC9->C9_PEDIDO)

			DBSelectArea("SC9")

		EndIf


	/*
	|---------------------------------------------------------------------------------
	|	Validacao do Vinculo Pedido Normal x Pedido Bonificado
	|---------------------------------------------------------------------------------
	*/
		IF LRETORNO .AND. SM0->M0_CODIGO + SM0->M0_CODFIL $ _cBNFIL

			DBSelectArea("SC9")

			IF _LMARCA

				// Verifica se os campos de Controle de Bonificacao existem
				IF _LC5CLASPD .AND. _LC5PVBON

					DBSELECTAREA("SC5")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SC5") + SC9->C9_PEDIDO)

				/*
				|---------------------------------------------------------------------------------
				|	Preenchimento de Array de Pedidos de Venda com Vínculo
				|---------------------------------------------------------------------------------
				*/
					IF SC5->C5_CLASPED = "V" .AND. !EMPTY(ALLTRIM(SC5->C5_X_PVBON))

						IF ASCAN(APEDVENBNF,{|X| X[1] = SC9->C9_PEDIDO}) = 0

							ATEMPBNF := {}
							ATEMPBNF := STRTOKARR(ALLTRIM(SC5->C5_X_PVBON),"/")
							FOR I := 1 TO LEN(ATEMPBNF)

								DBSELECTAREA("SC5")
								DBORDERNICKNAME("SC5NUMOLD")
								IF DBSEEK(XFILIAL("SC5") + ATEMPBNF[I])
									IF EMPTY(ALLTRIM(SC5->C5_NOTA))
										IF VERSLD(ATEMPBNF[I]) > 0
											AADD(APEDVENBNF,{SC9->C9_PEDIDO,SC5->C5_NUM})
										ENDIF
									ENDIF
								ENDIF

							NEXT I

						ENDIF

				/*
				|---------------------------------------------------------------------------------
				|	Preenchimento de Array de Bonificações com Vínculo
				|---------------------------------------------------------------------------------
				*/
					ELSEIF SC5->C5_CLASPED= "X" .AND. !EMPTY(ALLTRIM(SC5->C5_X_PVBON)) .AND. VERSLD(SC5->C5_NUMOLD) > 0

						IF ASCAN(APEDBNFVEN,{|X| X[2] = SC9->C9_PEDIDO}) = 0

							DBSELECTAREA("SC5")
							DBORDERNICKNAME("SC5NUMOLD")
							IF DBSEEK(XFILIAL("SC5") + ALLTRIM(SC5->C5_X_PVBON))
								AADD(APEDBNFVEN,{SC5->C5_NUM,SC9->C9_PEDIDO})
							ENDIF

						ENDIF

				/*
				|---------------------------------------------------------------------------------
				|	Preenchimento de Array de Bonificações sem Vínculo e não Autorizados
				|---------------------------------------------------------------------------------
				*/
					ELSEIF SC5->C5_CLASPED= "X" .AND. EMPTY(SC5->C5_X_PVBON) .AND. !SC5->C5_BNFLIB .AND. VERSLD(SC5->C5_NUMOLD) > 0

						IF ASCAN(APEDBNFVNC,{|X| X[1] = SC9->C9_PEDIDO}) = 0

							AADD(APEDBNFVNC,{SC9->C9_PEDIDO})

						ENDIF

					ENDIF

				ENDIF

			ENDIF

		ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Validacao dos Pedidos de Assistencia Tecnica
	|---------------------------------------------------------------------------------
	*/
		IF _l460ATC .AND. LRETORNO

			IF _LMARCA

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se o Pedido eh de Assistencia Tecnica e se esta apto a ser faturado    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SC5->C5_CLASPED == "A" .and. SC9->C9_BLEST = "  " .and. SC9->C9_BLCRED = "  "

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o numero de Pedido ja foi adicionado a lista de verificacao         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If AScan(_aPVATec, SC9->C9_PEDIDO ) == 0

						AAdd(_aPVATec, SC9->C9_PEDIDO )

					EndIf

				EndIf

			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Trata Itens de Pedido Liberados mas nao marcados                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If AScan(_aLbNaoMrk, {|x| x[1] == SC9->C9_PEDIDO .and. x[2] == SC9->C9_ITEM } ) == 0 .and. SC9->C9_BLEST == "  " .and. SC9->C9_BLCRED == "  "

					If SC5->C5_NUM <> SC9->C9_PEDIDO

						DBSelectArea("SC5")
						DBSeek(xFilial() + SC9->C9_PEDIDO)

					EndIf

					If SC5->C5_CLASPED == "A"

						AAdd(_aLbNaoMrk, {SC9->C9_PEDIDO, SC9->C9_ITEM } )

					EndIf


				EndIf

			EndIf

		ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Validacao dos Pedidos A Vista
	|---------------------------------------------------------------------------------
	*/
		IF _l460AVI .AND. LRETORNO

			IF !U_RM460AVI(PARAMIXB[1])

				LRETORNO := .F.

			ENDIF

		ENDIF


		TSC9->(DBSKIP())

	ENDDO
/*
|---------------------------------------------------------------------------------
|	BONIFICACAO - INICIO da verificacao dos dados levantados na varredura do SC9
|---------------------------------------------------------------------------------
*/
	ATEMPBNF := {}
// Verifica primeiro se os Vinculos da Venda estao selecionados e nao foram liberados para faturamento separado
	IF LEN(APEDVENBNF) > 0

		FOR I := 1 TO LEN(APEDVENBNF)

			IF ASCAN(APEDBNFVEN,{|X| X[1] = APEDVENBNF[I,1]}) = 0
				//Nao esta selecionado. Verifica se esta liberado para faturamento separado.
				IF POSICIONE("SC5",1,XFILIAL("SC5") + APEDVENBNF[I,2],"C5_X_LIBON") != "L"

					AADD(ATEMPBNF,{APEDVENBNF[I,1],APEDVENBNF[I,2],"Pedido de Bonificação não está selecionado para Faturamento!"})
					_LRETBNF := .F.

				ENDIF

			ENDIF

		NEXT I

	ENDIF

// Verifica se o Vinculo da Bonificação esta selecionada e se a Bonificação está liberada para faturamento separado
	IF LEN(APEDBNFVEN) > 0

		FOR I := 1 TO LEN(APEDBNFVEN)

			IF ASCAN(APEDVENBNF,{|X| X[1] = APEDBNFVEN[I,1]}) = 0 .AND. POSICIONE("SC5",1,XFILIAL("SC5") + APEDBNFVEN[I,2],"C5_X_LIBON") != "L" .AND. BNFSLD(ALLTRIM(APEDBNFVEN[I,2])) = 0

				AADD(ATEMPBNF,{APEDBNFVEN[I,1],APEDBNFVEN[I,2],"Pedido de Venda não está selecionado para Faturamento!"})
				_LRETBNF := .F.

			ENDIF

		NEXT I

	ENDIF

// Se o Array de Bonificações sem Vinculo e nao autorizadas conter registro bloqueia
	IF LEN(APEDBNFVNC) > 0

		FOR I := 1 TO LEN(APEDBNFVNC)
			IF .NOT. (CEMPANT="03" .AND. CFILANT="01") // NAO VALIDA VINCULO DE BNF E VENDA EM SP
				IF ASCAN(APEDVENBNF,{|X| X[1] = APEDBNFVEN[I,1]}) = 0

					AADD(ATEMPBNF,{"",APEDBNFVNC[I,1],"Pedido de Bonificação sem Vínculo e não Autorizada!"})
					_LRETBNF := .F.

				ENDIF
			ENDIF

		NEXT I

	ENDIF

	If _lRetBNF == .F.

		_CTITBNF := "Problemas com Pedidos de Bonificação!"
		_CPROBNF := ""

		FOR I := 1 TO LEN(ATEMPBNF)

			DO CASE

			CASE AT("Autorizada!",ATEMPBNF[I,3]) > 0

				_CPROBNF += ATEMPBNF[I,2] + " - " + ATEMPBNF[I,3] + ENTER

			CASE AT("Pedido de Venda",ATEMPBNF[I,3]) > 0

				_CPROBNF += "Pedido de Venda: " + ATEMPBNF[I,1] + " - Bonificação: " + ATEMPBNF[I,2] + " - " + ATEMPBNF[I,3] + ENTER

			CASE AT("Pedido de Bonificação",ATEMPBNF[I,3]) > 0

				_CPROBNF += "Pedido de Venda: " + ATEMPBNF[I,1] + " - Bonificação: " + ATEMPBNF[I,2] + " - " + ATEMPBNF[I,3] + ENTER

			ENDCASE

		NEXT I

		_CPROBNF += ENTER

		_CSOLBNF := "Entre em contato com o Departamento Comercial!"

		XMAGHELPFIS(_CTITBNF, _CPROBNF, _CSOLBNF)

	EndIf
/*
|---------------------------------------------------------------------------------
|	BONIFICACAO - TERMINO da verificacao dos dados levantados na varredura do SC9
|---------------------------------------------------------------------------------
*/

/*
|---------------------------------------------------------------------------------------
|	ASSISTENCIA TECNICA - INICIO da verificacao dos dados levantados na varredura do SC9
|---------------------------------------------------------------------------------------
*/

//|---------------------------------------------------------------------------
//|	Identifica atraves do array _aItNotMrk os Pedidos + Itens nao selecionados    
//|---------------------------------------------------------------------------
	For _nIx := 1 To Len(_aLbNaoMrk)

		If AScan(_aPVATec, _aLbNaoMrk[_nIx][1] ) <> 0

			AAdd(_aItNotMrk, {_aLbNaoMrk[_nIx][1], _aLbNaoMrk[_nIx][2] } )

			_lRetATC := .F.

		EndIf

	Next

//|---------------------------------------------------------------------------
//|	Monta janela com alerta para o usuario com base nos itens nao selecionados      
//|---------------------------------------------------------------------------
	If _lRetATC == .F.

		_cProATC := ""
		_cTitATC := "Pedidos da Assistencia Tecnica"

		If Len(_aItNotMrk) > 0

			For _nIx := 1 To Len(_aItNotMrk)

				_cProATC += "Pedido " + _aItNotMrk[_nIx][1] + " Item " + _aItNotMrk[_nIx][2] + " nao selecionado." + CRLF

			Next

			_cSolATC := "Selecione todos os itens acima e prossiga com o faturamento." + CRLF
			_cSolATC += "Para mais informacoes contacte o Departamento de Assistencia Tecnica."

			xMagHelpFis(_cTitATC, _cProATC, _cSolATC)

		EndIf

	EndIf

/*
|----------------------------------------------------------------------------------------
|	ASSISTENCIA TECNICA - TERMINO da verificacao dos dados levantados na varredura do SC9
|----------------------------------------------------------------------------------------
*/      

//Negativa o LRETORNO caso o Retorno de Assitencia Tecnica seja Falso  
//Esta negativacao deve permanecer fora do While do SC9
	If LRETORNO .and. !_lRetATC

		LRETORNO := .F.

	EndIf

//Negativa o LRETORNO caso o Retorno de Bonificacao seja Falso
//Esta negativacao deve permanecer fora do While do SC9
	If LRETORNO .and. !_lRetBNF

		LRETORNO := .F.

		If CEMPANT="03" .AND. CFILANT="01" .AND. !Empty(cOCcross)
			//
			// Os pedidos de VENDA e/ou BONIFICAÇÃO de SP já foram separados em MG atendendo as regras
			// da área comercial, portanto, não impede o faturamento quando em SP e CROSS DOCKING
			//
			LRETORNO := .T.
		EndIf

	EndIf

	RESTAREA(_AAREASC9)
	RESTAREA(_AAREASC5)

	DBSELECTAREA("SC9")


RETURN LRETORNO

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

STATIC FUNCTION VALSEPA(CPEDBLOCK)

	LOCAL LRET		:= .T.
	//LOCAL LMARCADO  := .T.
	//LOCAL CLOG		:= ''

	IF (ALLTRIM(TSC9->C5_YSTSEP) $ 'S/C/E' .OR. ALLTRIM(TSC9->C5_YSTSEP) = '' .OR. EMPTY(ALLTRIM(TSC9->C9_ORDSEP))) .AND. TSC9->C9_LOCAL = "21"

		IF  !(ALLTRIM(TSC9->C9_PEDIDO) $ CPEDBLOCK)

			IF ALLTRIM(TSC9->C5_YSTSEP) = '' .OR. EMPTY(ALLTRIM(TSC9->C9_ORDSEP))

				ALERT( "STATUS DO PEDIDO " + TSC9->C9_PEDIDO + " NÃO PERMITE EMISSÃO DE NF. NÃO FORAM CALCULADAS EMBALAGENS OU SEPARAÇÃO NÃO INICIADA!","")

			ELSEIF ALLTRIM(TSC9->C5_YSTSEP) $ 'S/C'

				ALERT( "STATUS DO PEDIDO " + TSC9->C9_PEDIDO + " NÃO PERMITE EMISSÃO DE NF. A ETIQUETA DE SEPARAÇÃO JÁ FOI EMITIDA!","")

			ELSEIF ALLTRIM(SC5->C5_YSTSEP) $ 'E'

				ALERT( "STATUS DO PEDIDO " + TSC9->C9_PEDIDO + " NÃO PERMITE EMISSÃO DE NF. EXISTE ERRO NO CALCULO DE EMBALAGEM!","")

			ENDIF

		ENDIF
		LRET := .F.

		DBSELECTAREA("SC9")
		RECLOCK("SC9",.F.)
		IF PARAMIXB[2]
			SC9->C9_OK := PARAMIXB[1]
		ELSE
			SC9->C9_OK := ""
		ENDIF
		MSUNLOCK()

		CPEDBLOCK += TSC9->C9_PEDIDO + "/"

	ENDIF

RETURN(LRET)

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

USER FUNCTION TFRETCONCESSAOOK( CTFPEDIDO,CTFCLIENTE,CTFLOJA, CTFXITEMC )

	LOCAL LRETORNO		:= .T.
	LOCAL _DDTREVOGA 	:= CTOD("  /  /  ")
	LOCAL _DDTMAISVAL	:= CTOD("  /  /  ")
	LOCAL CALIASPROC	:= GETNEXTALIAS()
	LOCAL CMENS001		:= "CLIENTE COM CONCESSÃO DO REGIME ESPECIAL VENCIDA, COMUNIQUE ADM. VENDAS PARA QUE SELECIONE TES TRIBUTAVEL.  "
	LOCAL CMENS002		:= "PEDIDO " + CTFPEDIDO + " NÃO SERÁ FATURADO, CONFORME REGULAMENTO INTERNO. "
	LOCAL CMENS005		:= "CLIENTE COM CONCESSÃO DO REGIME ESPECIAL REVOGADA, COMUNIQUE ADM. VENDAS PARA QUE SELECIONE TES TRIBUTAVEL. "
	Local aSC6posipi 	:= {}

	IF SM0->M0_CODIGO $ GETNEWPAR("TF_REGIMEE","")  // EMPRESAS PARTICIPANTES DA CONCESSAO DO REGIME ESPECIAL
//
// SELECIONAR TODAS AS TES UTILIZADAS NO PEDIDO QUE NÃO SE ENQUADRAM NA SUBSTITUIÇÃO TRIBUTARIA
//
		_CQUERY := " SELECT ISNULL(COUNT(*),0) AS TES_VLDA  "
		_CQUERY += " 	FROM " + RETSQLNAME("SC6") + " SC6 "
		_CQUERY += "      	INNER JOIN " + RETSQLNAME("SF4") + " SF4 ON "
		_CQUERY += "   				SC6.C6_TES 						= SF4.F4_CODIGO "
		_CQUERY += "   				AND SF4.F4_SITTRIB				= '00' "
		_CQUERY += "   				AND ISNULL(SF4.D_E_L_E_T_, '')	= '' "
		_CQUERY += "      	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON "
		_CQUERY += "   				SC6.C6_PRODUTO					= SB1.B1_COD "
		_CQUERY += "   				AND ISNULL(SB1.D_E_L_E_T_, '')	= '' "
		_CQUERY += "      	INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON "
		_CQUERY += "   				SC6.C6_CLI							= SA1.A1_COD "
		_CQUERY += "   				AND SC6.C6_LOJA					= SA1.A1_LOJA "
		_CQUERY += "   				AND ISNULL(SA1.D_E_L_E_T_, '')	= '' "
		_CQUERY += " WHERE "
		_CQUERY += " 	ISNULL(SC6.D_E_L_E_T_, '') 	= '' "
		_CQUERY += "   	AND SC6.C6_FILIAL 			= '" + XFILIAL("SC6") + "'"
		_CQUERY += "   	AND SC6.C6_CLI				= '" + CTFCLIENTE + "'"
		_CQUERY += "   	AND SC6.C6_LOJA				= '" + CTFLOJA + "'"
		_CQUERY += "  	AND SC6.C6_NUM				= '" + CTFPEDIDO + "'"
		_CQUERY += "		AND SA1.A1_GRPTRIB 			= 'C03' "

		IF SELECT( (CALIASPROC) ) > 0
			DBSELECTAREA( (CALIASPROC) )
			DBCLOSEAREA()
		ENDIF

		TCQUERY _CQUERY NEW ALIAS (CALIASPROC)
		(CALIASPROC)->(DBGOTOP())

		IF (CALIASPROC)->TES_VLDA != 0

			ZAL->(DBSETORDER(1))
			ZAL->(DBSEEK( XFILIAL("ZAL") + CTFCLIENTE + CTFLOJA ))
			WHILE ZAL->(ZAL_FILIAL+ZAL_CLIENT+ZAL_LOJA) = XFILIAL("ZAL") + CTFCLIENTE + CTFLOJA .AND. !ZAL->(EOF())
				If ZAL->ZAL_XITEMC = CTFXITEMC .AND. (ZAL->ZAL_POSIPI = '*' .or. AScan(aSC6posipi, ZAL->ZAL_POSIPI) != 0  )
					IF _DDTREVOGA <= ZAL->ZAL_VALIDA .AND. ZAL->ZAL_TIPSIT='R'
						_DDTREVOGA := ZAL->ZAL_VALIDA
					ENDIF

					IF _DDTMAISVAL <= ZAL->ZAL_VALIDA .AND. ZAL->ZAL_TIPSIT $ 'N'
						_DDTMAISVAL:= ZAL->ZAL_VALIDA
					ENDIF
				EndIf
				ZAL->(DBSKIP())
			END

			DO CASE

			CASE !EMPTY(_DDTREVOGA) .AND. EMPTY(_DDTMAISVAL)
				AVISO("INCONSISTÊNCIA: REGIME ESPECIAL" , CMENS005 + CHR(13) + CHR(10) + CMENS002, {"OK"}, 	3)
				LRETORNO	:= .F.

			CASE !EMPTY(_DDTREVOGA) .AND. !EMPTY(_DDTMAISVAL) .AND. _DDTREVOGA > _DDTMAISVAL
				AVISO("INCONSISTÊNCIA: REGIME ESPECIAL" , CMENS005 + CHR(13) + CHR(10) + CMENS002, {"OK"}, 	3)
				LRETORNO	:= .F.

			CASE !EMPTY(_DDTMAISVAL) .AND. _DDTMAISVAL < DDATABASE
				AVISO("INCONSISTÊNCIA: REGIME ESPECIAL" , CMENS001 + CHR(13) + CHR(10) + CMENS002, {"OK"}, 	3)
				LRETORNO := .F.

			ENDCASE

		ENDIF

		(CALIASPROC)->(DBCLOSEAREA())

	ENDIF

RETURN (LRETORNO)

/*
Static Function ApuVPP(_cNumOld)
                                             
Local _cAntAlias := Alias()
Local _aAntAlias := GetArea()
Local _cTam      := AllTrim(Str(TamSX3("C5_NUMOLD")[1])) 
Local _cPed      := AllTrim(_cNumOld)                      
Local _cNxtAlias := GetNextAlias()      

Local _cRptQry   := ""
Local _cQuery    := ""

_cRptQry := " AND D_E_L_E_T_ <> '*' AND C5_FILIAL = '" + xFilial("SC5") + "' "

_cQuery := ""
_cQuery += "SELECT " 
_cQuery += "PA.C5_NUMPRE_VENDAS AS VENDA, " 
_cQuery += "( "
_cQuery += "SELECT C5_NUM " 
_cQuery += "FROM " + RetSQLName("SC5") + " "  
_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_VENDAS AS VARCHAR(" + _cTam + ")) " 
_cQuery += _cRptQry
_cQuery += ") AS PV_VEN_PRO, " 
_cQuery += "( "
_cQuery += "SELECT C5_FILIAL "
_cQuery += "FROM " + RetSQLName("SC5") + " "  
_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_VENDAS AS VARCHAR(" + _cTam + ")) " 
_cQuery += _cRptQry
_cQuery += ") AS FL_VEN_PRO, " 
_cQuery += "PA.C5_NUMPRE_BONIFICACAO AS BONIF, "
_cQuery += "( "
_cQuery += "SELECT C5_NUM " 
_cQuery += "FROM " + RetSQLName("SC5") + " "  
_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) " 
_cQuery += _cRptQry
_cQuery += ") AS PV_BON_PRO, " 
_cQuery += "( "
_cQuery += "SELECT C5_FILIAL "
_cQuery += "FROM " + RetSQLName("SC5") + " "  
_cQuery += "WHERE C5_NUMOLD = CAST(PA.C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) " 
_cQuery += _cRptQry
_cQuery += ") AS FL_BON_PRO "
_cQuery += "FROM PORTAL_TAIFFPROART..TBL_PEDIDOS_ASSOCIADOS PA  WITH(NOLOCK) " 
_cQuery += "WHERE " 
_cQuery += "CAST(C5_NUMPRE_VENDAS      AS VARCHAR(" + _cTam + ")) = '" + _cPed + "' "   
_cQuery += "OR "
_cQuery += "CAST(C5_NUMPRE_BONIFICACAO AS VARCHAR(" + _cTam + ")) = '" + _cPed + "' "    

DBUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery), _cNxtAlias , .F., .T.)
	
DBSelectArea(_cNxtAlias)

_aRetPVV    := {"", "", "", "", "", ""}

_aRetPVV[1] := AllTrim(Str((_cNxtAlias)->VENDA))                     
_aRetPVV[2] := AllTrim((_cNxtAlias)->PV_VEN_PRO)        
_aRetPVV[3] := AllTrim((_cNxtAlias)->FL_VEN_PRO)
                                   
_aRetPVV[4] := AllTrim(Str((_cNxtAlias)->BONIF))  
_aRetPVV[5] := AllTrim((_cNxtAlias)->PV_BON_PRO)       
_aRetPVV[6] := AllTrim((_cNxtAlias)->FL_BON_PRO)
	
DBSelectArea(_cNxtAlias)
DBCloseArea()   

DBSelectArea(_cAntAlias)
RestArea(_aAntAlias)

Return(_aRetPVV)
*/
/*
=================================================================================
=================================================================================
||   Arquivo:	M460MARK.prw
=================================================================================
||   Funcao: 	VERIFLIBER
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira verificar se o Pedido de Venda referente a Transferencia
|| 	do Processo de CrossDocking está totalmente liberado.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger	
||   Data:	20/08/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERIFLIBER(NUMPED)

	LOCAL LRET 		:= .T.
	LOCAL NREG		:= 0
	LOCAL CQRY		:= ""
	LOCAL ADADOS	:= {}

	CQRY := "SELECT" 																+ CRLF
	CQRY += "	SC6.C6_PRODUTO," 													+ CRLF
	CQRY += "	SC6.C6_QTDVEN," 													+ CRLF
	CQRY += "	ISNULL(" 															+ CRLF
	CQRY += "	(	SELECT" 														+ CRLF
	CQRY += "			SC9.C9_QTDLIB" 												+ CRLF
	CQRY += "		FROM" 															+ CRLF
	CQRY += "			" + RETSQLNAME("SC9") + " SC9" 								+ CRLF
	CQRY += "		WHERE" 															+ CRLF
	CQRY += "			SC9.C9_FILIAL = SC6.C6_FILIAL AND" 							+ CRLF
	CQRY += "			SC9.C9_PEDIDO = SC6.C6_NUM AND" 							+ CRLF
	CQRY += "			SC9.C9_ITEM = SC6.C6_ITEM AND" 								+ CRLF
	CQRY += "			SC9.C9_PRODUTO = SC6.C6_PRODUTO AND" 						+ CRLF
	CQRY += "			SC9.C9_NFISCAL = '' AND" 									+ CRLF
	CQRY += "			SC9.D_E_L_E_T_ = ''" 										+ CRLF
	CQRY += "	),0) AS C9_QTDLIB" 													+ CRLF
	CQRY += "FROM" 																	+ CRLF
	CQRY += "	" + RETSQLNAME("SC6") + " SC6 WITH(NOLOCK)" 						+ CRLF
	CQRY += "WHERE" 																+ CRLF
	CQRY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 						+ CRLF
	CQRY += "	SC6.C6_NUM = '" + NUMPED + "' AND" 									+ CRLF
	CQRY += "	SC6.D_E_L_E_T_ = ''" 												+ CRLF
	CQRY += "GROUP BY" 																+ CRLF
	CQRY += "	SC6.C6_FILIAL," 													+ CRLF
	CQRY += "	SC6.C6_NUM," 														+ CRLF
	CQRY += "	SC6.C6_ITEM," 														+ CRLF
	CQRY += "	SC6.C6_PRODUTO," 													+ CRLF
	CQRY += "	SC6.C6_QTDVEN" 														+ CRLF
	CQRY += "HAVING" 																+ CRLF
	CQRY += "	(SC6.C6_QTDVEN - ISNULL((	SELECT" 								+ CRLF
	CQRY += "									SC9.C9_QTDLIB" 						+ CRLF
	CQRY += "								FROM" 									+ CRLF
	CQRY += "									" + RETSQLNAME("SC9") + " SC9" 		+ CRLF
	CQRY += "								WHERE" 									+ CRLF
	CQRY += "									SC9.C9_FILIAL = SC6.C6_FILIAL AND"	+ CRLF
	CQRY += "									SC9.C9_PEDIDO = SC6.C6_NUM AND" 	+ CRLF
	CQRY += "									SC9.C9_ITEM = SC6.C6_ITEM AND" 		+ CRLF
	CQRY += "									SC9.C9_PRODUTO = SC6.C6_PRODUTO AND" + CRLF
	CQRY += "									SC9.C9_NFISCAL = '' AND" 			+ CRLF
	CQRY += "									SC9.D_E_L_E_T_ = ''),0)) > 0"

	IF SELECT("XTM") > 0

		DBSELECTAREA("XTM")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQRY NEW ALIAS "XTM"
	DBSELECTAREA("XTM")
	DBGOTOP()
	COUNT TO NREG
	DBGOTOP()

	IF NREG > 0

		WHILE XTM->(!EOF())

			AADD(ADADOS,{NUMPED,XTM->C6_PRODUTO,XTM->C6_QTDVEN,XTM->C9_QTDLIB})
			XTM->(DBSKIP())

		ENDDO

		ENVWFTI(ADADOS)
		LRET := .F.

	ENDIF

	DBSELECTAREA("XTM")
	DBCLOSEAREA()

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	M460MARK.prw
=================================================================================
||   Funcao: 	ENVWFTI
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao de envio de WorkFlow informando diferenca entre as quantidades 
|| 	vendidas e as liberadas.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	21/08/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVWFTI(ADADOS)

	LOCAL CEMAIL 	:= "grp_sistemas@taiff.com.br"
	LOCAL OPROCESS
	LOCAL I			:= 0

//## Cria processo de Workflow
	OPROCESS 			:= TWFPROCESS():NEW( "ENVWFTI", OEMTOANSI("WORKFLOW PROBLEMAS DE LIBERAÇÃO"))
	OPROCESS:NEWTASK( "ENVWFTI", "\WORKFLOW\ENVWFTI.HTM" )
	OPROCESS:CTO 		:= CEMAIL
	OPROCESS:CSUBJECT 	:= OEMTOANSI("WORKFLOW PROBLEMAS DE LIBERAÇÃO")
	OHTML 				:= OPROCESS:OHTML

//## Preenche o campo de Numero da OC e Marca do Produto
	OHTML:VALBYNAME("cMARCA"		,ALLTRIM(POSICIONE("SC5",1,XFILIAL("SC5") + ADADOS[1,1],"C5_XITEMC")))
	OHTML:VALBYNAME("cNUMOC"		,POSICIONE("SC5",1,XFILIAL("SC5") + ADADOS[1,1],"C5_NUMOC"))

	FOR I := 1 TO LEN(ADADOS)

		//## Preenche a tabela da pagina HTM com as informacoes dos Pedidos
		AADD(OHTML:VALBYNAME("it.CODPED")	,ALLTRIM(ADADOS[I,1]))
		AADD(OHTML:VALBYNAME("it.PRODUTO")	,ALLTRIM(ADADOS[I,2]))
		AADD(OHTML:VALBYNAME("it.QTDVEN")	,TRANSFORM(ADADOS[I,3],"@E 999,999,999.99"))
		AADD(OHTML:VALBYNAME("it.QTDLIB")	,TRANSFORM(ADADOS[I,4],"@E 999,999,999.99"))

	NEXT I

//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( SUBS(CUSUARIO,7,15) )
	OPROCESS:USERSIGA	:= __CUSERID
	OPROCESS:START()
	OPROCESS:FREE()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	M460MARK.prw
=================================================================================
||   Funcao: 	VERSLD
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para nalisar que pedido tem saldo a faturar.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		23/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERSLD(CPEDIDO)

	LOCAL NRET 	:= 0
	LOCAL CQUERY 	:= ""

	CQUERY := "SELECT" 															+ ENTER
	CQUERY += "	ISNULL(SUM(C6_QTDVEN) - SUM(C6_QTDENT),0) AS C6_SALDO" 	+ ENTER
	CQUERY += "FROM" 																+ ENTER
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 								+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5 ON"				+ ENTER
	CQUERY += "		SC5.C5_FILIAL = SC6.C6_FILIAL AND" 					+ ENTER
	CQUERY += "		SC5.C5_NUM = SC6.C6_NUM AND" 							+ ENTER
	CQUERY += "		SC5.C5_NUMOLD = '" + CPEDIDO + "' AND" 				+ ENTER
	CQUERY += "		SC5.D_E_L_E_T_ = ''" 									+ ENTER
	CQUERY += "WHERE" 															+ ENTER
	CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL ("SC6") + "' AND" 			+ ENTER
	CQUERY += "	SC6.D_E_L_E_T_ = ''"

	//MEMOWRITE("\VERSLD.SQL",CQUERY)

	IF SELECT("SLD") > 0

		DBSELECTAREA("SLD")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "SLD"
	DBSELECTAREA("SLD")
	DBGOTOP()

	IF SLD->C6_SALDO > 0

		NRET := SLD->C6_SALDO

	ENDIF

RETURN NRET

STATIC FUNCTION BNFSLD(CPEDIDO)

	LOCAL NRET 	:= 0
	LOCAL CQUERY 	:= ""

	CQUERY := "SELECT" 															+ ENTER
	CQUERY += "	ISNULL(SUM(C9_QTDLIB),0) AS C9_SALDO" 	+ ENTER
	CQUERY += "FROM" 																+ ENTER
	CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 								+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5BNF ON"				+ ENTER
	CQUERY += "		SC5BNF.C5_FILIAL = '" + xFilial("SC5") + "' AND" 					+ ENTER
	CQUERY += "		SC5BNF.C5_NUM = '" + CPEDIDO + "' AND" 				+ ENTER
	CQUERY += "		SC5BNF.D_E_L_E_T_ = ''" 									+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5 ON"				+ ENTER
	CQUERY += "		SC5.C5_FILIAL = SC9.C9_FILIAL AND" 					+ ENTER
	CQUERY += "		SC5.C5_NUM = SC9.C9_PEDIDO AND" 							+ ENTER
	CQUERY += "		SC5.C5_NUMOLD = RTRIM(LTRIM(SC5BNF.C5_X_PVBON)) AND" 				+ ENTER
	CQUERY += "		SC5.D_E_L_E_T_ = ''" 									+ ENTER
	CQUERY += "WHERE" 															+ ENTER
	CQUERY += "	SC9.C9_FILIAL = '" + XFILIAL ("SC9") + "'" 			+ ENTER
	CQUERY += "	AND SC9.D_E_L_E_T_ = ''"
	CQUERY += "	AND SC9.C9_DATALIB >= '" + DTOS(DDATABASE - 7) + "'" 			+ ENTER

	//MEMOWRITE("M460MARK_SALDO_NA_SC9_DA_BONIFIC.SQL",CQUERY)

	IF SELECT("SLDC9") > 0

		DBSELECTAREA("SLDC9")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "SLDC9"
	DBSELECTAREA("SLDC9")
	DBGOTOP()

	IF SLDC9->C9_SALDO > 0

		NRET := SLDC9->C9_SALDO

	ENDIF

RETURN NRET
