#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440GR.prw
=================================================================================
||   Funcao: 	MT440GR
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		APÓS A CONFIRMAÇÃO DA LIBERAÇÃO PV.
|| 		Ao confirmar a Liberação Manual.
|| 		
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

USER FUNCTION MT440GR()

	LOCAL AOPC				:= PARAMIXB
	//LOCAL LRET				:= .T.
	//LOCAL AAREA			:= GETAREA()
	LOCAL CALIAS			:= "TRB"
	LOCAL NMAX				:= 999

	//LOCAL NOPC				:= 2
	LOCAL ACMPALT			:= {}
	LOCAL CPERCGRL		:= ""
	LOCAL CPERCGRL1		:= ""
	LOCAL CPERCGRL2		:= ""
	LOCAL CPERCGRL3		:= ""
	LOCAL CPERCGRL4		:= ""
	LOCAL CPERCGRL5		:= ""

	LOCAL NFREEZE			:= 002
	//LOCAL LREFRESH		:= .T.
	LOCAL NOPCFORM		:= 0
	LOCAL NQTDREG			:= 0

	//LOCAL ATOTTRF			:= {}
	//LOCAL AITETRF			:= {}
	//LOCAL AITEAUX			:= {}
	//LOCAL CDOC				:= ""
	//LOCAL NOPCAUTO		:= 3 	// INDICA QUAL TIPO DE AçãoO SERï¿½ TOMADA (INCLUSï¿½O/EXCLUSï¿½O)

	//LOCAL aColsEx1			:= {}
	LOCAL ACONDPAG		:= {}
	//LOCAL NLIST			:= 1

	//LOCAL CVARGLB			:= "a" + ALLTRIM(USRRETNAME()) + CVALTOCHAR(THREADID())
	//LOCAL CSD3GLB			:= "b" + ALLTRIM(USRRETNAME()) + CVALTOCHAR(THREADID())

	//LOCAL NSB2RECNO		:= 0 	// CT - TRANSF I
	//LOCAL AITESD3			:= {}
	//LOCAL CLSTPRODUTOS	:= ""
	//LOCAL ARESULTADO		:= {}
	Local LRETLIB := .F.

	Local nPosItem 		:= aScan( aHeader, {|x| Alltrim(x[2]) == "C6_ITEM"} )
	Local nPosProduto 	:= aScan( aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"} )
	Local nPosQtdLib 		:= aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB" } )
	Local NITENOPEDIDO	:= 0

	//Local _nQean14 		:= 0
	Local lOkMinimo		:= .T.
	Local I := 0
	Local xnCol := 0
	Local _DiaAtual		:= Day(Date())
	Local _DiaLimiteFat := GETNEWPAR("TF_DATFAT", 31) // PArâmentro de dia limite para Faturamento

	PRIVATE CCUSMED		:= GETMV("MV_CUSMED") // CT - TRANSF I
	PRIVATE AREGSD3		:= {} 	// CT - TRANSF I
	PRIVATE aColsEx		:= {}
	PRIVATE aCabecalho		:= {}

	PRIVATE LMSHELPAUTO 	:= .T.
	PRIVATE LMSERROAUTO 	:= .F.

	PRIVATE OLST1
	PRIVATE OLBL1
	PRIVATE OLBL2
	PRIVATE OLBL3
	PRIVATE OLBL4
	PRIVATE OLBL5
	PRIVATE OLBL6
	PRIVATE OLBL7
	PRIVATE ODLG1
	PRIVATE OGTD1
	PRIVATE OFNT1
	PRIVATE OBTN1
	PRIVATE OBTN2
	PRIVATE OGROUP1
	PRIVATE OGROUP2

	PRIVATE NTOTGRL		:= 0
	PRIVATE NTOTLIB		:= 0
	PRIVATE NQTDLIB		:= 0
	PRIVATE NVLLIB		:= 0

	PRIVATE ASLDEND		:= {}
	PRIVATE NSLD			:= 0
	PRIVATE CENDORI		:= ""

	PRIVATE nValMinFatur	:= 0
	PRIVATE nParcelaMin	:= 0
	PRIVATE lComCtrlRsv 	:= .F.
	PRIVATE NOUTLIB 		:= 0
	PRIVATE NOUTMIN		:= 0



	/* ID Controle: 001-440GR */
	PRIVATE NVALC9LIB	:= 0
	PRIVATE NVALC6VEN	:= 0
	PRIVATE NTOTC9LIB := 0
	PRIVATE NTOTC6VEN	:= 0
	PRIVATE NVALC6TET	:= 0
	PRIVATE NTOTC6TET	:= 0	
	PRIVATE LSALDOOK	:= .T.
	PRIVATE LFRACION	:= .T.
	PRIVATE cItFRACION:= ""
	PRIVATE cItSALDOOK:= ""
	PRIVATE cItC9BLEST:= ""
	PRIVATE lLibAutom	:= Iif(GetMV("MV__LIBAUT")=="S",.T.,.F.)
	PRIVATE nDiasEntrega	:= GetMV("MV__PRZENT",.F.,10)
	PRIVATE nMaxFatur	:= GetMV("MV__MAXFAT",.F.,1000000)
	PRIVATE aPedLido	:= {}
	PRIVATE aPedVlLib	:= {} 
	PRIVATE lEmProcess	:= Iif(GETNEWPAR("MV__ESTM1T","N")=="N",.F.,.T.)
	PRIVATE nSA1Recno	:= 0
	PRIVATE lEmSeparacao := .F.
	PRIVATE aB2saldo	:= {} // Acumula o saldo disponivel para libera??o
	PRIVATE nValMinimo:= 0 	// Recebe o valor da venda e a parcela do pedido
	PRIVATE cCondAvist:= GetMV("MV__ESTCND",.F.,"N01|N02|N24")
	PRIVATE ATETOLIBER:= {}
	PRIVATE lAvalMinimo	:= .F. 
	PRIVATE LPRJENDER 	:= GETNEWPAR("TF_PRJENDR",.F.)
	PRIVATE LLIBPADRAO 	:= .T.
	PRIVATE NDIALIMT	:= GETNEWPAR("TF_DATFAT",31)
	PRIVATE cTFd3doc	:= ""
	PRIVATE LWEB 		:= .F.
	/* fim de controle 001-440GR */

	/* ID Controle: 003-440GR */
	PRIVATE lflag := .T.
	/* fim de controle 003-440GR */
	PRIVATE NLIBSUG	:= 0

/*
|---------------------------------------------------------------------------------
|	VALIDACAO PARA PEDIDOS DE TRANSPORTADORA E DO GRUPO DE EMPRESAS
|	ACTION INDAIATUBA 
|	PEDIDOS DA ASSISTENCIA TECNICA - BENEFICIAMENTO - EXPORTACAO
|---------------------------------------------------------------------------------
*/

	IF CEMPANT = "03" .AND. CFILANT = "02"

		/*
		|---------------------------------------------------------------------------------
		|	Tratativa para atender a data limite de Liberação/Faturamento de Pedidos
		|	Data: 12/05/2020 
		|	Analista: Gilberto Ribeiro Junior
		|---------------------------------------------------------------------------------
		*/
		If _DiaAtual > _DiaLimiteFat
			If SC5->C5_CLASPED $ ("V|X") .and. SC5->C5_TIPO == "N" .and. SC5->C5_XITEMC != "CORP" .and. SC6->C6_LOCAL == "21"
				DbSelectArea("ZAS")
				DbSetOrder(1)
				// Filial + Numero do Pedido + Tipo de Liberação = "Pedido Separável"
				If !DbSeek(XFilial("ZAS") + SC5->C5_NUM + "1")
					MsgAlert(OEMTOANSI("Período de operação superior ao período estabelecido para atender a liberação de pedidos!"))
					Return .F.
				EndIf
			EndIf
		EndIf
		/*---------------------------------------------------------------------------------*/

		IF U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. EMPTY(SC5->C5_NUMOC) .AND. .NOT. SC5->C5_TIPO $ ("D")

			RETURN .T.

		ElseIf U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. EMPTY(SC5->C5_NUMOC)

			RETURN .T.

		ELSEIF SC5->C5_CLASPED $ ('A|B|E| ')

			RETURN .T.

		ELSEIF SC5->C5_TIPO $ ("D")

			RETURN .T.

		ENDIF

	ELSE
		/******************************************************************************************************
			Autor: Carlos Torres
			Data: 19/08/2021
			Observação: Uso exclusivo da empresa ACTION - Indaiatuba para liberação de pedido de beneficiamento,
						a quantidade liberada será subtraida do empenho do endereço B2_QEMP.
						Isto tem o objetivo de evitar o bloqueio de estoque ao termino da liberação do pedido.
		*******************************************************************************************************/
		IF CEMPANT="04" .AND. CFILANT$"01|02" .AND. SC5->C5_TIPO="B"
			SB2->(DBSETORDER(1))
			SC6->(DbSetOrder(1))
			SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM))
			WHILE .NOT. SC6->(Eof()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=SC5->C5_NUM
				IF .NOT. EMPTY(SC6->C6__OPBNFC)
					IF SB2->(DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
						IF SB2->(RECLOCK("SB2",.F.))
							SB2->B2_QEMP := SB2->B2_QEMP - (SC6->C6_QTDVEN - SC6->C6_QTDENT)
							IF SB2->B2_QEMP < 0
								SB2->B2_QEMP := 0
							ENDIF
						ENDIF
						SB2->(DBUNLOCK())
					ENDIF
				ENDIF
				SC6->(DBSKIP())
			END
		ENDIF
		RETURN .T.
	ENDIF


	IF AOPC[1] != 1
		RETURN .F.
	ENDIF

	/*
		Garante que o endereço do item do pedido esteja vazio
	*/
	SC6->(DbSetOrder(1))
	SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM))
	WHILE .NOT. SC6->(Eof()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=SC5->C5_NUM
		IF SC6->(RecLock("SC6",.F.))
			SC6->C6_LOCALIZ := ""
			SC6->(msUnlock())
		ENDIF
		SC6->(DBSKIP())
	END

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Nova tela para anï¿½lise de estoque para atendimento do Pedido de Venda
|
|=================================================================================
*/
//## MONTA aCabecalho

/*01*/AADD(aCabecalho,{"Num. Pedido"	,"C6_NUM"		,"@!"							,06	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_RELACAO")})
/*02*/AADD(aCabecalho,{"Item Pedido"	,"C6_ITEM"		,"@!"							,02	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_RELACAO")})
/*03*/AADD(aCabecalho,{"Cod. Produto"	,"C6_PRODUTO"	,"@!"							,15	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_RELACAO")})
/*04*/AADD(aCabecalho,{"Desc.Produto"	,"B1_DESC"		,"@!"							,50	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_RELACAO")})
/*05*/AADD(aCabecalho,{"Armazem"		,"C6_LOCAL"		,"@!"							,02	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_LOCAL"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_LOCAL"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_LOCAL"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_LOCAL"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_LOCAL"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_LOCAL"	,"X3_RELACAO")})
/*06*/AADD(aCabecalho,{"Qtd.Original"	,"C6_QTDVEN"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_RELACAO")})
/*07*/AADD(aCabecalho,{"Vlr.Unitario"	,"C6_PRCVEN"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLUNIT"	,"X3_RELACAO")})
/*08*/AADD(aCabecalho,{"Vlr. Total"	,"C6_VALOR"		,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLTOT"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_RELACAO")})
/*09*/AADD(aCabecalho,{"Qtd.Saldo"	,"C6_SALDO"		,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_SALDO"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_SALDO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_SALDO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_SALDO"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_SALDO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_SALDO"	,"X3_RELACAO")})
/*10*/AADD(aCabecalho,{"Vlr.Saldo"	,"C6_VALSLD"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLSLD"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLSLD"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLSLD"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLSLD"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLSLD"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLSLD"	,"X3_RELACAO")})
/*11*/AADD(aCabecalho,{"Qtd.Liberada"	,"C6_QTDLIB"	,"@E 99,999,999,999.999"		,15	,03		,POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_VALID")				,POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_RELACAO")})
/*12*/AADD(aCabecalho,{"Vlr.Liberado"	,"C6_VLLIB"		,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLLIB"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_RELACAO")})
/*13*/AADD(aCabecalho,{"Perc. Atend."	,"C6_PERCAT"	,"@E 9,999.999"					,09	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_RELACAO")})

//## CAMPO QUE PODERA SER ALTERADO
	AADD(ACMPALT,aCabecalho[11][2]) // Quantidade Liberada

//## FAZ UMA QUERY NO BANCO DE DADOS PARA NAO DESPOSICIONAR A TABELA DO SC6 ATUAL
	CQUERY := "SELECT" 												+ ENTER
	CQUERY += "	C6_NUM," 											+ ENTER
	CQUERY += "	C6_ITEM," 											+ ENTER
	CQUERY += "	C6_PRODUTO," 										+ ENTER
	CQUERY += "	B1_DESC," 											+ ENTER
	CQUERY += "	C6_LOCAL," 										+ ENTER
	CQUERY += "	C6_QTDVEN," 										+ ENTER
	CQUERY += "	C6_PRCVEN," 										+ ENTER
	CQUERY += "	C6_VALOR," 										+ ENTER
	CQUERY += "	C6_QTDVEN - (C6_QTDENT + ISNULL((SELECT SUM(C9_QTDLIB) FROM " + RETSQLNAME("SC9") + " SC9 WHERE SC9.D_E_L_E_T_='' AND C9_FILIAL='" + XFILIAL("SC9") + "' AND C9_PEDIDO=C6_NUM AND C9_ITEM=C6_ITEM AND C9_PRODUTO=C6_PRODUTO AND C9_NFISCAL='' ),0) ) AS C6_SALDO," 					+ ENTER
	CQUERY += "	((C6_QTDVEN - (C6_QTDENT + ISNULL((SELECT SUM(C9_QTDLIB) FROM " + RETSQLNAME("SC9") + " SC9 WHERE SC9.D_E_L_E_T_='' AND C9_FILIAL='" + XFILIAL("SC9") + "' AND C9_PEDIDO=C6_NUM AND C9_ITEM=C6_ITEM AND C9_PRODUTO=C6_PRODUTO AND C9_NFISCAL='' ),0) ))*C6_PRCVEN) AS C6_VALSLD," 	+ ENTER
	CQUERY += "	0 AS C6_QTDLIB," 									+ ENTER
	CQUERY += "	0 AS C6_VLLIB," 									+ ENTER
	CQUERY += "	0 AS C6_PERCAT" 									+ ENTER
	CQUERY += "	,C6_QTDRESE" 										+ ENTER
	CQUERY += "FROM" 													+ ENTER
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 					+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 	+ ENTER
	CQUERY += "		B1_FILIAL	= C6_FILIAL AND" 					+ ENTER
	CQUERY += "		B1_COD		= C6_PRODUTO AND" 				+ ENTER
	CQUERY += "		SB1.D_E_L_E_T_ = ''" 						+ ENTER
	CQUERY += "WHERE" 												+ ENTER
	CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER
	CQUERY += "	C6_NUM = '" + SC5->C5_NUM + "' AND" 			+ ENTER
	CQUERY += "	(C6_QTDVEN - C6_QTDENT) > 0 AND" 				+ ENTER
	CQUERY += "	C6_BLQ NOT IN ('R','S') AND"					+ ENTER
	CQUERY += "	SC6.D_E_L_E_T_ = ''"

	//MEMOWRITE("MT440GR_SELECT_DOS_PEDIDOS.SQL",CQUERY)

//## MONTA O aColsEx COM AS INFORMACOES DOS ITENS DO PEDIDO SELECIONADO
	IF SELECT("TRB") > 0
		DBSELECTAREA(CALIAS)
		DBCLOSEAREA()
	ENDIF
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	DBGOTOP()
	NTOTGRL := 0
	NTOTLIB := 0

	WHILE TRB->(!EOF())

		AADD(aColsEx,ARRAY(14))

		FOR I := 1 TO 13

			DBSELECTAREA("TRB")
			aColsEx[Len(aColsEx),I] := FieldGet(FieldPos(aCabecalho[I,2]))

			DO CASE

			CASE I = 3

			 	/*
				|---------------------------------------------------------------------------------
				|	Faï¿½o a Analise da Tabela de Controle de Quantidade Liberada para o Produto 
				|	corrente
				|---------------------------------------------------------------------------------
				*/
				NQTDREG := 0

				CQUERY := "SELECT" 											+ ENTER
				CQUERY += "	SUM(QTDLIB) AS QTDLIB" 						+ ENTER
				CQUERY += "FROM" 												+ ENTER
				CQUERY += "	CONTROLE_QTDLIB" 								+ ENTER
				CQUERY += "WHERE" 											+ ENTER
				CQUERY += "	PRODUTO = '" + aColsEx[LEN(aColsEx),3] + "' AND" 	+ ENTER
				CQUERY += "	D_E_L_E_T_ = ''"								+ ENTER
				CQUERY += "GROUP BY" 										+ ENTER
				CQUERY += "	PRODUTO"

				IF SELECT("QTD") > 0
					DBSELECTAREA("QTD")
					DBCLOSEAREA()
				ENDIF

				TCQUERY CQUERY NEW ALIAS "QTD"
				DBSELECTAREA("QTD")
				DBGOTOP()
				COUNT TO NQTDREG

				IF NQTDREG > 0

					QTD->(DBGOTOP())
					NQTDREG := QTD->QTDLIB

				ENDIF

			CASE I = 11

				DBSELECTAREA("SB2")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB2") + aColsEx[LEN(aColsEx),3] + "21")
				__NSLDSB2 := SALDOSB2() - NQTDREG						// EH VERIFICADO O SALDO DO PRODUTO E SUBTRAIDO A QUANTIDADE RETORNADA DA TABELA DE CONTROLE
				NQTDLIB := 0
				IF aColsEx[LEN(aColsEx),9] != 0 .AND. __NSLDSB2 != 0
					IF aColsEx[LEN(aColsEx),9] < __NSLDSB2
						NQTDLIB := aColsEx[LEN(aColsEx),9]
						NQTDLIB := VALIDFRAC(aColsEx[LEN(aColsEx),3], NQTDLIB)
					ELSE
						NQTDLIB := __NSLDSB2
						NQTDLIB := VALIDFRAC(aColsEx[LEN(aColsEx),3], NQTDLIB)
					ENDIF
				ENDIF

				If (CALIAS)->C6_QTDRESE != 0
					aColsEx[LEN(aColsEx),I] := (CALIAS)->C6_QTDRESE
				Else
					aColsEx[LEN(aColsEx),I] := NQTDLIB
				EndIf


			CASE I = 12

				DBSELECTAREA("SB2")
				DBSETORDER(1)
				DBSEEK(XFILIAL("SB2") + aColsEx[LEN(aColsEx),3] + "21")
				__NSLDSB2 := SALDOSB2() - NQTDREG						// EH VERIFICADO O SALDO DO PRODUTO E SUBTRAIDO A QUANTIDADE RETORNADA DA TABELA DE CONTROLE
				NQTDLIB := 0
				IF aColsEx[LEN(aColsEx),9] != 0 .AND. __NSLDSB2 != 0
					IF aColsEx[LEN(aColsEx),9] < __NSLDSB2
						NQTDLIB := aColsEx[LEN(aColsEx),9]
						NQTDLIB := VALIDFRAC(aColsEx[LEN(aColsEx),3], NQTDLIB)
					ELSE
						NQTDLIB := __NSLDSB2
						NQTDLIB := VALIDFRAC(aColsEx[LEN(aColsEx),3], NQTDLIB)
					ENDIF
				ENDIF

				If (CALIAS)->C6_QTDRESE != 0
					NQTDLIB := (CALIAS)->C6_QTDRESE
				EndIf

				NVLLIB 	:= NQTDLIB * aColsEx[LEN(aColsEx),7]
				aColsEx[LEN(aColsEx),I] := NVLLIB

			CASE I = 13

				aColsEx[Len(aColsEx),I] := ROUND( ((NVLLIB / aColsEx[LEN(aColsEx),8]) * 100) ,2)

			END DO

		NEXT I

		aColsEx[LEN(aColsEx),14]	:= .F.
		NTOTLIB	+= NVLLIB

		IF !U_INSCONTROLE(SC5->C5_NUM, aColsEx[LEN(aColsEx),2], aColsEx[LEN(aColsEx),3], aColsEx[LEN(aColsEx),11])

			MSGALERT(OEMTOANSI(	"Erro ao tentar gerar Controle de Liberacoes!")  + ENTER + ;
				"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
			RETURN .F.

		ENDIF

		If (CALIAS)->C6_QTDRESE != 0
			lComCtrlRsv := .T.
		EndIf

		(CALIAS)->(DBSKIP())

	ENDDO
//## FAZ UMA QUERY NO BANCO DE DADOS PARA NAO DESPOSICIONAR A TABELA DO SC6 ATUAL
	CQUERY := "SELECT" 												+ ENTER
	CQUERY += "	SUM(C6_VALOR) AS TOTAL" 							+ ENTER
	CQUERY += "FROM" 													+ ENTER
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 					+ ENTER
	CQUERY += "WHERE" 												+ ENTER
	CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER
	CQUERY += "	C6_NUM = '" + SC5->C5_NUM + "' AND" 			+ ENTER
	CQUERY += "	SC6.D_E_L_E_T_ = ''"

	IF SELECT("TOT") > 0
		DBSELECTAREA("TOT")
		DBCLOSEAREA()
	ENDIF

	TCQUERY CQUERY NEW ALIAS "TOT"
	DBSELECTAREA("TOT")
	DBGOTOP()

	NTOTGRL 	:= TOT->TOTAL
	If NTOTLIB>0
		ACONDPAG 	:= CONDICAO(NTOTLIB,SC5->C5_CONDPAG)
	EndIf

	//SET KEY VK_F4 TO VIEWREST()
	SetKey(VK_F4, {|| VIEWREST() })

//## VARIAVEL COM STRING QUE APRESENTA O ATENDIMENTO GERAL %

	CPERCGRL 	:= "Atendimento Geral " + ALLTRIM(STR(ROUND((NTOTLIB/NTOTGRL)*100,2))) + "%"
	CPERCGRL1	:= "Valor Total Liberado  R$ " + TRANSFORM(NTOTLIB,"@E 999,999,999.99")
	CPERCGRL2	:= "Valor Total do Pedido R$ " + TRANSFORM(NTOTGRL,"@E 999,999,999.99")
	CPERCGRL3	:= ALLTRIM(SC5->C5_NOMCLI)
	CPERCGRL4	:= ""
	CPERCGRL5	:= ""

/* VALIDA AS REGRAS DE FATURAMENTO MINIMO */
	lOkMinimo := Iif(NTOTLIB>0,TFVldMinimo(NTOTLIB,ACONDPAG[1,2]),.F.)
	NOUTLIB 	:= NTOTLIB
	NOUTMIN		:= nValMinFatur
//## TELA DO DETALHE DO PEDIDO DE VENDA
	DBSELECTAREA("TRB")
	DBGOTOP()
	ODLG1 		:= MSDIALOG():NEW(10,10,680 - 10,990,'Itens do Pedido de Venda ' + SC5->C5_NUM,,,,,CLR_BLACK,CLR_GRAY,,,.T.)
	OFNT1		:= TFONT():NEW('CALIBRI',,-18,.T.,.T.)
	OGTD1		:= MSNEWGETDADOS():NEW(10, 10 ,200 - 10, 480, 2, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue",ACMPALT	, NFREEZE	, NMAX	, "U_VALQTD(@OGTD1,@OLBL1,@OLBL3,@OLST1,NTOTLIB,NTOTGRL,@OLBL6,@OLBL7)"	,, "AllwaysFalse"	, ODLG1, aCabecalho, aColsEx)
	OBTN1		:= TBUTTON():NEW(205 - 10,330,'Confirma'	,ODLG1,{|| NOPCFORM := 1,ODLG1:END()},70,10,,,,.T.)

	/* ID Controle: 002-440GR */
	If lEmProcess 
		MSGALERT("Rotina bloqueada temporariamente para uso, a liberação automática está em progresso" ,"Atenção")
		CPERCGRL4	:= "** Liberacao bloqueada temporariamente para uso **"
		CPERCGRL5	:= "A liberação automática está em progresso, aguarde alguns minutos"
		OBTN1:Hide()
	/* fim de controle 002-440GR */
	ELSEIf lOkMinimo
		OBTN1:Show()
		CPERCGRL4	:= SPACE(40)
		CPERCGRL5	:= SPACE(40)
	Else
		If DTOS(SC5->C5_EMISSAO) > "20180331"
			OBTN1:Hide()
		Else
			OBTN1:Show()
		EndIf
		CPERCGRL4	:= "** Liberacao Abaixo do minimo nao atende parametros **"
		CPERCGRL5	:= "Valor minimo R$ " + ALLTRIM(TRANSFORM(nValMinFatur,"@E 999,999,999.99")) + " - Parcela minima R$ " + ALLTRIM(TRANSFORM(nParcelaMin,"@E 999,999,999.99"))
	EndIf
	OBTN2		:= TBUTTON():NEW(205 - 10,410,'Sair'		,ODLG1,{|| LOUTOK:=lOkMinimo,NOUTLIB:=NTOTLIB,NOUTMIN:=nValMinFatur,NOPCFORM := 2,ODLG1:END()},70,10,,,,.T.)
	OGROUP1	:= TGROUP():NEW(220 - 10,010,330,215,'Parcelas Financeiras',ODLG1,,,.T.)
	@ 230 - 10,015 LISTBOX OLST1 FIELDS TITLE "Vencimento","Vlr. Parcela" SIZE 195,095 	OF ODLG1 PIXEL
	If NTOTLIB > 0
		OLST1:SETARRAY(ACONDPAG)
		OLST1:BLINE := {|| ACONDPAG[OLST1:NAT] }
	EndIf
	OGROUP2	:= TGROUP():NEW(220 - 10,220,330,480,'Informacoes',ODLG1,,,.T.)
	OLBL1 		:= TSAY():NEW(230 - 10,370, {|| CPERCGRL},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL1:LTRANSPARENT:= .T.

	xnCol := 230

	OLBL6 		:= TSAY():NEW(xnCol ,225, {|| CPERCGRL4},ODLG1,, OFNT1,,,, .T., CLR_RED,CLR_WHITE )
	OLBL6:LTRANSPARENT:= .T.
	xnCol += 8
	OLBL7 		:= TSAY():NEW(xnCol,225, {|| CPERCGRL5},ODLG1,, OFNT1,,,, .T., CLR_RED,CLR_WHITE )
	OLBL7:LTRANSPARENT:= .T.
	xnCol += 8
	OLBL2 		:= TSAY():NEW(xnCol,225, {|| "Condicao de Pagto: " + ALLTRIM(POSICIONE("SE4",1,XFILIAL("SC5") + SC5->C5_CONDPAG,"E4_DESCRI"))},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL2:LTRANSPARENT:= .T.
	xnCol += 8
	OLBL3 		:= TSAY():NEW(xnCol,225, {|| CPERCGRL1},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL3:LTRANSPARENT:= .T.
	xnCol += 8
	OLBL4 		:= TSAY():NEW(xnCol,225, {|| CPERCGRL2},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL4:LTRANSPARENT:= .T.
	xnCol += 8
	OLBL5 		:= TSAY():NEW(xnCol,225, {|| CPERCGRL3},ODLG1,, OFNT1,,,, .T., CLR_RED,CLR_WHITE )
	OLBL5:LTRANSPARENT:= .T.
	ODLG1:ACTIVATE(,,,.T.)

/*
|---------------------------------------------------------------------------------
|	Criado um looping aguardando que um dos botoes seja clicado
|---------------------------------------------------------------------------------
*/
	WHILE NOPCFORM = 0

	ENDDO

/*
|---------------------------------------------------------------------------------
|	Inicio dos Procedimentos
|---------------------------------------------------------------------------------
*/
	IF NOPCFORM = 1
		//C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
		SC6->(DbSetOrder(1))
		FOR I := 1 TO LEN(aColsEx)
			If aColsEx[I,11] > 0
				If SC6->(DbSeek( xFilial("SC6") + aColsEx[I,1] + aColsEx[I,2] + aColsEx[I,3] ))

					NITENOPEDIDO := Ascan(ACOLS,{|x| x[nPosItem] == aColsEx[I,2] .AND.  x[nPosProduto] == aColsEx[I,3] })
					If  NITENOPEDIDO> 0

						ACOLS[ NITENOPEDIDO,nPosQtdLib] := aColsEx[I,11]

						LRETLIB := .T.
					EndIf

				Else
					MSGALERT(OEMTOANSI(	"Erro ao tentar atualizar a quantidade a liberar no pedido!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
					LRETLIB := .F.
				EndIf
			EndIf

		Next


	ELSEIF NOPCFORM = 2
		IF .NOT. lOkMinimo
			If NOUTLIB < NOUTMIN
				IF SC5->(RecLock("SC5",.F.))
					SC5->C5__BLOQF := "V"
					cMensLido	:= "Bloqueado, valor a liberar " + ALLTRIM(TRANSFORM(NOUTLIB,"@R 999,999,999.99"	)) + " abaixo do minino " + ALLTRIM(TRANSFORM(NOUTMIN,"@R 999,999,999.99"))
					SC5->C5_HIST5 := SUBSTR(cMensLido,1,100)
					SC5->(msUnlock())
				Endif
			EndIf
		ENDIF

		TRB->(DBGOTOP())

		WHILE TRB->(!EOF())

			IF !U_DELCONTROLE(TRB->C6_NUM,TRB->C6_ITEM,TRB->C6_PRODUTO)

				MSGALERT(OEMTOANSI(	"Erro ao tentar deletar Controle de Liberacoes!")  + ENTER + ;
					"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))

			ENDIF
			TRB->(DBSKIP())

		ENDDO

		LRETLIB := .F.

	ENDIF

	NLIBSUG := 0
	/* Funcionalidade do projeto de endereçamento                               */
	/* Data: 14/05/2020                               Responsável: Carlos Torres*/
	/* ID Controle: 001-440GR */
	IF LRETLIB .AND. ALLTRIM(SC5->C5_XITEMC)="TAIFF" .AND. LPRJENDER .AND. .NOT. lComCtrlRsv
		/* Monta matriz de saldo da SB2 utilizada em GravaSC902 */
		/* aColsEx[I,11] quantidade liberada pelo usuário       */
		aB2saldo	:= {}
		FOR I := 1 TO LEN(aColsEx)
			If SC6->(DbSeek( xFilial("SC6") + aColsEx[I,1] + aColsEx[I,2] + aColsEx[I,3] ))
				If aColsEx[I,11] > 0
					SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
					aAdd( aB2saldo ,  {SC6->C6_PRODUTO, SC6->C6_LOCAL , aColsEx[I,11], 0 , SB2->B2_QATU , SB2->B2_RESERVA , SB2->B2_QACLASS }  )
					NLIBSUG += aColsEx[I,11]
				ENDIF
			ENDIF			
		NEXT
		FOR I := 1 TO LEN(aColsEx)
			If SC6->(DbSeek( xFilial("SC6") + aColsEx[I,1] + aColsEx[I,2] + aColsEx[I,3] ))
				U_DELCONTROLE(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO)
			ENDIF			
		NEXT
		/* Em GravaSC902 executa MaLibdoFat */ 
		U_GravaSC902( TRB->C6_NUM )

		/* Funcionalidade para Atualizar o campo customizado de liberação parcial */
		/* Data: 19/06/2020                               Responsável: Carlos Torres */
		/* ID Controle: 003-440GR */
		lflag := .T.
		FOR I := 1 TO LEN(aColsEx)
			If SC6->(DbSeek( xFilial("SC6") + aColsEx[I,1] + aColsEx[I,2] + aColsEx[I,3] ))

				nQtdSal := SC6->C6_QTDVEN - (  SC6->C6_QTDEMP +  SC6->C6_QTDENT )
				
				If SC6->C6_QTDVEN > (  SC6->C6_QTDEMP +  SC6->C6_QTDENT ) 
					SC5->(Reclock("SC5",.F.))
					SC5->C5_LIBPARC := 'S '
					SC5->(Msunlock())
					lflag := .F.
				Endif
				
				If SC5->C5_LIBPARC=='S ' .And. nQtdSal==0 .And. lflag
					SC5->(Reclock("SC5",.F.))
					SC5->C5_LIBPARC := '  '
					SC5->(Msunlock())
				Endif

			ENDIF			
		NEXT
		/* fim de controle 003-440GR */
		LRETLIB := .F.
	ENDIF
	/* fim de controle 001-440GR */
	IF 	NLIBSUG	!= NTOTC9LIB
		MsgAlert(OEMTOANSI("Foi detectada divergencia entre quantidade sugerida e quantidade empenhada, caso necessário estorne a liberação e a refaça!"))
	ENDIF

	SET KEY VK_F4 TO

RETURN(LRETLIB)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440GR.prw
=================================================================================
||   Funcao: 	VALQTD
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para validacao da quantidade liberada 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:	17/11/2015
=================================================================================
=================================================================================
*/
USER FUNCTION VALQTD(OGTD,OLBL,OLBL1,OLST,NTOTLIB,NTOTGRL,OLBL2,OLBL3)

	LOCAL I			:= 0
	LOCAL LRET 		:= .T.
	LOCAL LCXFRAC		:= .F.
	//LOCAL NQTDORI		:= 0
	//LOCAL NVALORI		:= 0
	LOCAL NQTDLIB		:= 0
	LOCAL CPERCGRL	:= ""
	LOCAL CQUERY 		:= ""
	LOCAL __NSLDSB2	:= 0
	LOCAL NPOSITE		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_ITEM"})
	LOCAL NPOSPRO		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_PRODUTO"})
	LOCAL NPOSVAL		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_PRCVEN"})
	LOCAL NPOSLIB		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_QTDLIB"})
	LOCAL NPOSVLB		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_VLLIB"})
	LOCAL NPOSQTD		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_SALDO"})
	LOCAL NPOSPER		:= ASCAN(OGTD:AHEADER,{|X| X[2] == "C6_PERCAT"})
	LOCAL ACONDPAG	:= {}

	Local _nQean14 	:= 0
	Local nFraEan14 	:= 0

	PRIVATE cCondAvist:= GetMV("MV__ESTCND",.F.,"N01|N02|N24")

	IF lComCtrlRsv .AND. SC5->C5_CONDPAG $ cCondAvist
		MSGALERT("Quantidade nao pode ser alterada uma vez que o pedido esta? associado a uma reserva!!!","Atencao")
		LRET := .F.
		RETURN(LRET)
	ENDIF

/*
|---------------------------------------------------------------------------------
|	Realiza verificacao de Caixa Francionada para o Cliente 
|---------------------------------------------------------------------------------
*/
	LCXFRAC := (SC5->C5_FATFRAC == "S")
	IF !LCXFRAC .AND. SC5->C5_CLASPED != "X" .AND. M->C6_QTDLIB > 0

		NQTDEMB := POSICIONE("SB1",1,XFILIAL("SB1")+OGTD:ACOLS[OGTD:nAT][NPOSPRO],"B1_YTOTEMB")

		IF MOD(M->C6_QTDLIB , Iif( NQTDEMB >0 ,NQTDEMB,1 ) ) > 0

			MSGALERT(OEMTOANSI("Cliente nao aceita Caixa Fracionada!") + ENTER + OEMTOANSI("Qtd. por Emb.: " + TRANSFORM(NQTDEMB,"@E 999,999,999,999")),OEMTOANSI("Liberaçãoo de Pedidos"))
			LRET := .F.
			RETURN(LRET)

		ELSE

			LRET := .T.

		ENDIF
	ENDIF

	CQUERY := "SELECT" 																					+ ENTER
	CQUERY += "	SUM(QTDLIB) AS QTDLIB " 																+ ENTER
	CQUERY += "FROM" 																						+ ENTER
	CQUERY += "	CONTROLE_QTDLIB" 																		+ ENTER
	CQUERY += "WHERE" 																					+ ENTER
	CQUERY += "	PEDIDO + ITEM != '" + SC5->C5_NUM + OGTD:ACOLS[OGTD:nAT][NPOSITE] + "' AND" 	+ ENTER
	CQUERY += "	PRODUTO = '" + OGTD:ACOLS[OGTD:nAT][NPOSPRO] + "' AND" 							+ ENTER
	CQUERY += "	D_E_L_E_T_ = ''"

	//MEMOWRITE("", CQUERY)
	IF SELECT("TMP") > 0

		DBSELECTAREA("TMP")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()


	DBSELECTAREA("SB2")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SB2") + OGTD:ACOLS[OGTD:nAT][NPOSPRO] + "21")

	__NSLDSB2 	:= SALDOSB2() - TMP->QTDLIB
	NQTDLIB 	:= 0
	IF (M->C6_QTDLIB <= OGTD:ACOLS[OGTD:NAT][NPOSQTD])
		IF M->C6_QTDLIB < __NSLDSB2
			NQTDLIB := M->C6_QTDLIB
		ELSE
			NQTDLIB := __NSLDSB2
		ENDIF

		NVLLIB 	:= NQTDLIB * OGTD:ACOLS[OGTD:nAT][NPOSVAL]
		NTOTLIB 	:= NTOTLIB - (TMP->QTDLIB * OGTD:ACOLS[OGTD:nAT][NPOSVAL]) + NVLLIB
		OGTD:ACOLS[OGTD:nAT][NPOSLIB] := NQTDLIB
		OGTD:ACOLS[OGTD:nAT][NPOSVLB] := NVLLIB
		OGTD:ACOLS[OGTD:nAT][NPOSPER] := ROUND(  ((NVLLIB / (OGTD:ACOLS[OGTD:nAT][NPOSQTD]*OGTD:ACOLS[OGTD:nAT][NPOSVAL])) * 100)  ,2)

		LRET := .T.

	ELSE

		OGTD:ACOLS[OGTD:NAT][NPOSLIB] := TMP->QTDLIB
		MSGALERT("Quantidade informada maior que saldo do Item!","Atencao")
		LRET := .F.

	ENDIF

/* Valida faturamento fracionado */
	_nQean14 	:= 0
	If SC5->C5_XITEMC = "TAIFF"
		SA1->(DbSetorder(1))
		If SC5->C5_FILDES = CFILANT
			SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
		Else
			SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIORI + SC5->C5_LOJORI ))
		EndIf
		If SA1->A1_FATFRAC = "N"  // Cliente nao aceita caixa fracionada
			_nQean14 := Posicione("SB5",1,xFilial("SB5") + OGTD:ACOLS[OGTD:nAT][NPOSPRO] ,"B5_EAN141")
			If _nQean14 = 0

				MSGALERT("As regras de Embalagens em Complemento do Produto nao existem para cliente que nao aceita item fracionado!","Atencao")
				LRET := .F.

			EndIf
		EndIf
	EndIf

	If _nQean14 > 0 .AND. LRET
		If SC5->C5_FATFRAC = "N" .AND. SC5->C5_CLASPED != "X"
			nFraEan14 := OGTD:ACOLS[OGTD:nAT][NPOSLIB] - (OGTD:ACOLS[OGTD:nAT][NPOSLIB] % _nQean14)
			If OGTD:ACOLS[OGTD:nAT][NPOSLIB] < _nQean14 .OR. OGTD:ACOLS[OGTD:nAT][NPOSLIB] > nFraEan14
				MSGALERT("A quantidade liberada foi refeita uma vez que o cliente nao aceita item fracionado!","Atencao")
				If OGTD:ACOLS[OGTD:nAT][NPOSLIB] < _nQean14
					OGTD:ACOLS[OGTD:nAT][NPOSLIB] := 0
					NVLLIB 	:= OGTD:ACOLS[OGTD:nAT][NPOSLIB] * OGTD:ACOLS[OGTD:nAT][NPOSVAL]
					NTOTLIB 	:= NTOTLIB - (TMP->QTDLIB * OGTD:ACOLS[OGTD:nAT][NPOSVAL]) + NVLLIB
					OGTD:ACOLS[OGTD:nAT][NPOSVLB] := NVLLIB
					OGTD:ACOLS[OGTD:nAT][NPOSPER] := ROUND( ((NVLLIB / (OGTD:ACOLS[OGTD:nAT][NPOSQTD]*OGTD:ACOLS[OGTD:nAT][NPOSVAL])) * 100) ,2)
				ElseIf OGTD:ACOLS[OGTD:nAT][NPOSLIB] > nFraEan14
					OGTD:ACOLS[OGTD:nAT][NPOSLIB] := nFraEan14
					NVLLIB 	:= OGTD:ACOLS[OGTD:nAT][NPOSLIB] * OGTD:ACOLS[OGTD:nAT][NPOSVAL]
					NTOTLIB 	:= NTOTLIB - (TMP->QTDLIB * OGTD:ACOLS[OGTD:nAT][NPOSVAL]) + NVLLIB

					OGTD:ACOLS[OGTD:nAT][NPOSVLB] := NVLLIB
					OGTD:ACOLS[OGTD:nAT][NPOSPER] := ROUND( ((NVLLIB / (OGTD:ACOLS[OGTD:nAT][NPOSQTD]*OGTD:ACOLS[OGTD:nAT][NPOSVAL])) * 100) ,2)
				EndIf
			EndIf
		EndIf
	EndIf
/* fim da validação do faturamento fracionado */

	IF LRET
		IF !U_UPDCONTROLE(SC5->C5_NUM,ACOLS[OGTD:nAT][NPOSITE],ACOLS[OGTD:nAT][NPOSPRO],NQTDLIB)

			MSGALERT(OEMTOANSI(	"Erro ao tentar alterar Controle de Liberacoes!")  + ENTER + ;
				"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
			LRET := .F.

		ENDIF
	ENDIF

	OGTD:OBROWSE:REFRESH()
	OGTD:REFRESH()
	OGTD:OBROWSE:SETFOCUS()

	NTOTLIB := 0
	NTOTGRL := 0

	FOR I := 1 TO LEN(OGTD:ACOLS)

		NTOTLIB += OGTD:ACOLS[I][NPOSVLB]
		NTOTGRL += (OGTD:ACOLS[I][NPOSQTD]*OGTD:ACOLS[I][NPOSVAL])

	NEXT I

	CPERCGRL 	:= "Atendimento Geral " + ALLTRIM(STR(ROUND((NTOTLIB/NTOTGRL)*100,2))) + "%"
	OLBL:SETTEXT(CPERCGRL)
	OLBL:REFRESH()
	CPERCGRL 	:= "Valor Total Liberado  R$ " + TRANSFORM(NTOTLIB,"@E 999,999,999.99")
	OLBL1:SETTEXT(CPERCGRL)
	OLBL1:REFRESH()


	ACONDPAG 	:= CONDICAO(NTOTLIB,SC5->C5_CONDPAG)


/* VALIDA AS REGRAS DE FATURAMENTO MINIMO */
	lOkMinimo := TFVldMinimo(NTOTLIB,ACONDPAG[1,2])

	If lOkMinimo
		OBTN1:Show()
		CPERCGRL	:= SPACE(40)
		OLBL2:SETTEXT(CPERCGRL)
		OLBL2:REFRESH()

		CPERCGRL	:= SPACE(40)
		OLBL3:SETTEXT(CPERCGRL)
		OLBL3:REFRESH()
	Else
		If DTOS(SC5->C5_EMISSAO) > "20180331"
			OBTN1:Hide()
		Else
			OBTN1:Show()
		EndIf
		CPERCGRL	:= "** Liberação Abaixo do mÃ­nimo nao atende parâmetros **"
		OLBL2:SETTEXT(CPERCGRL)
		OLBL2:REFRESH()

		CPERCGRL	:= "Valor minimo R$ " + ALLTRIM(TRANSFORM(nValMinFatur,"@E 999,999,999.99")) + " - Parcela minima R$ " + ALLTRIM(TRANSFORM(nParcelaMin,"@E 999,999,999.99"))
		OLBL3:SETTEXT(CPERCGRL)
		OLBL3:REFRESH()
	EndIf

	OLST:SETARRAY(ACONDPAG)
	OLST:BLINE	:= {|| ACONDPAG[OLST:NAT] }
	OLST:REFRESH()

	aColsEx[OGTD:nAT,11] := OGTD:ACOLS[OGTD:nAT][NPOSLIB]



RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440GR.prw
=================================================================================
||   Funcao:	SALDOEND 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funçãoo para verificaçãoo de Saldos por Endereï¿½o para atendimento da 
|| 	quantidade liberada do Pedido de Venda
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		15/01/2016
=================================================================================
=================================================================================
*/
/*
STATIC FUNCTION SALDOEND(CPRODUTO,NQTDLIB)

	LOCAL ARET 	:= {}
	LOCAL CQUERY 	:= ""

	IF SELECT("SLD") > 0

		DBSELECTAREA("SLD")
		DBCLOSEAREA()

	ENDIF

	CQUERY := "SELECT" 													+ ENTER
	CQUERY += "	SBF.BF_LOCALIZ," 										+ ENTER
	CQUERY += "	(SBF.BF_QUANT - SBF.BF_EMPENHO) AS BF_SALDO" 		+ ENTER
	CQUERY += "FROM" 														+ ENTER
	CQUERY += "	" + RETSQLNAME("SBF") + " SBF" 						+ ENTER
	CQUERY += "WHERE" 													+ ENTER
	CQUERY += "	SBF.BF_FILIAL = '" + XFILIAL("SBF") + "' AND" 	+ ENTER
	CQUERY += "	SBF.BF_LOCAL = '21' AND" 							+ ENTER
	CQUERY += "	SBF.BF_PRODUTO = '" + CPRODUTO + "' AND" 			+ ENTER
	CQUERY += "	(SBF.BF_QUANT - SBF.BF_EMPENHO) > 0 AND" 			+ ENTER
	CQUERY += "	SBF.D_E_L_E_T_ = ''"

	TCQUERY CQUERY NEW ALIAS "SLD"
	DBSELECTAREA("SLD")
	DBGOTOP()

	WHILE SLD->(!EOF())

		IF SLD->BF_SALDO >= NQTDLIB

			AADD(ARET,{SLD->BF_LOCALIZ,NQTDLIB})
			EXIT

		ELSE

			AADD(ARET,{SLD->BF_LOCALIZ,SLD->BF_SALDO})
			NQTDLIB := NQTDLIB - SLD->BF_SALDO

		ENDIF
		SLD->(DBSKIP())

	ENDDO

RETURN(ARET)
*/

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440GR.prw
=================================================================================
||   Funcao: 	VALIDFRAC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para realizar validacao de caixa fracionada, quando o cliente nao 
|| 	aceita caixas fracionadas. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger	 
||   Data:		18/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VALIDFRAC(CCODPRO,NQTDLIB)

	LOCAL NNEWQTD := NQTDLIB
	LOCAL NQTDEMB := 0
	Local _nQean14 	:= 0
	Local nFraEan14 	:= 0

	IF ((SC5->C5_FATFRAC != "N") .OR. SC5->C5_CLASPED = "X") .AND. SC5->C5_XITEMC != "TAIFF"

		RETURN(NNEWQTD)

	ENDIF

	If SC5->C5_XITEMC != "TAIFF"
		NQTDEMB := POSICIONE("SB1", 1, XFILIAL("SB1") + CCODPRO, "B1_YTOTEMB")

		IF MOD(NQTDLIB , IIf(NQTDEMB > 0, NQTDEMB, 1)) > 0

			NNEWQTD := NNEWQTD - MOD(NQTDLIB , IIf(NQTDEMB > 0, NQTDEMB, 1))

		ENDIF
	ElseIf SC5->C5_XITEMC = "TAIFF"
		_nQean14 	:= 0
		SA1->(DbSetorder(1))
		If SC5->C5_FILDES = CFILANT
			SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
		Else
			SA1->(DbSeek( xFilial("SA1") + SC5->C5_CLIORI + SC5->C5_LOJORI ))
		EndIf
		If SA1->A1_FATFRAC = "N"  // Cliente nao aceita caixa fracionada
			_nQean14 := Posicione("SB5",1,xFilial("SB5") + CCODPRO ,"B5_EAN141")
			If _nQean14 = 0

				MSGALERT("As regras de Embalagens em Complemento do Produto nao existem para cliente que nao aceita item fracionado!","Atencao")

			EndIf
		EndIf
	EndIf

	If _nQean14 > 0
		If SC5->C5_FATFRAC = "N" .AND. SC5->C5_CLASPED != "X"

			nFraEan14 := NNEWQTD - (NNEWQTD % _nQean14)

			If NNEWQTD < _nQean14 .OR. NNEWQTD > nFraEan14
				If NNEWQTD < _nQean14
					NNEWQTD := 0
				ElseIf NNEWQTD > nFraEan14
					NNEWQTD := nFraEan14
				EndIf
			EndIf

		EndIf
	EndIf
/* fim da validaçãoo do faturamento fracionado */


RETURN(NNEWQTD)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440GR.prw
=================================================================================
||   Funcao: 	VIEWREST
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para apresentar tela de Saldos em Estoque do produto onde esta
|| 	o foco no Browse.
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger
||   Data:		19/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VIEWREST()

	SET KEY VK_F4 TO

	MAVIEWSB2(OGTD1:ACOLS[OGTD1:nAT,3])
	SetKey(VK_F4, {||})
	//SET KEY VK_F4 TO VIEWREST()

RETURN

/*
Atualiza a chave pedido de venda na SD3 sem a sequencia de liberaçãoo da SC9 C9_SEQUEN
*/
User Function TFCHAVESD3( cTFd3doc, cTFd3cod, cTFchave )
	Local xSD3alias := SD3->(GetArea())
	SD3->(DBSETORDER(2))
	SD3->(DBSEEK(XFILIAL("SD3") + cTFd3doc + cTFd3cod))
	While !SD3->(Eof()) .AND. SD3->D3_FILIAL=xFILIAL("SD3") .AND. SD3->D3_DOC=cTFd3doc .AND. SD3->D3_COD=cTFd3cod
		If SD3->(RECLOCK("SD3",.F.))
			SD3->D3_SC9PED := cTFchave
			SD3->(MSUNLOCK())
		EndIf
		SD3->(DbSkip())
	End
	RestArea(xSD3alias)

Return NIL

/***************************************************************************/
/***************************************************************************/
/* Valida parcela minima e valor minimo do pedido                          */
/***************************************************************************/
/***************************************************************************/
Static Function TFVldMinimo( NVLTOTLIB, NVLPARCELA1 )
	Local lRetorno 	:= .T.
	Local cIdCliente	:= IIF( SC5->C5_FILDES = CFILANT, SC5->C5_CLIENTE, SC5->C5_CLIORI)
	Local cIdLoja 		:= IIF( SC5->C5_FILDES = CFILANT, SC5->C5_LOJACLI, SC5->C5_LOJORI)

//** Somente os pedidos do tipo venda passam por analise de valor minimo as bonificaçãoes ficam de fora. ***//
	If SC5->C5_CLASPED = "V"
		If SC5->(FIELDPOS("C5__DTLIBF")) > 0 // Indica que os parametros da liberaçãoo em lote esta? ativo
		/*
		Busca regras do cliente
		*/
			SA1->(DbSetOrder(1))
			SA1->(DbSeek( xFilial("SA1") + cIdCliente + cIdLoja	))

			nValMinFatur	:= 0
			nParcelaMin	:= 0
			ZAV->(DbSetOrder(1))
			If ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) + SA1->A1_COD_MUN ))
				nValMinFatur	:= ZAV->ZAV_VALMIN
				nParcelaMin	:= ZAV->ZAV_PARCEL
			ElseIf ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) ))
				nValMinFatur	:= ZAV->ZAV_VALMIN
				nParcelaMin	:= ZAV->ZAV_PARCEL
			EndIf

			If nParcelaMin > 0 .AND. NVLTOTLIB > 0
				If NVLPARCELA1 < nParcelaMin
					lRetorno 	:= .F.
				EndIf
			EndIf

		/* Valor do liberado nao atende o valor minino de faturamento para a UF */
			If nValMinFatur > 0 .AND. NVLTOTLIB > 0
				If NVLTOTLIB < nValMinFatur
					lRetorno 	:= .F.
				EndIf
			EndIf
		EndIf
	EndIf
Return (lRetorno)
