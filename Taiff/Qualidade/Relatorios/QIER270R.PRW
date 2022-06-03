#INCLUDE "QIER270.CH"
#INCLUDE "PROTHEUS.CH"

/*
=================================================================================
=================================================================================
||   Arquivo:	QIER270R.PRW
=================================================================================
||   Funcao: 	QIER270R
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Etiqueta de Laudo de Resultados do Modulo de Inspecao de Entrada. Nele  
|| 	sera impresso se o Produto esta Aprovado/Reprovado/Em Analise e sera 
|| 	impresso o codigo de barras referente ao Lote do Produto. 
|| 
=================================================================================
=================================================================================
||   Autor:	??? 
||   Data:	???
=================================================================================
=================================================================================
*/

USER FUNCTION QIER270R(CPROG, NMV_PAR04, NMV_PAR05)

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	SE FOR CHAMADO PELO CADASTRO ENTRADAS OU PELO MENU, NAO PASSA O VETOR COM
	|	A CHAVE DE CADA ENTRADA.
	|	SE FOR CHAMADO PELA IMPORTACAO, PASSA O VETOR COM AS ENTRADAS PARA A IM-
	|	PRESSAO DAS ETIQUETAS.
	|=================================================================================
	
	/*
	|---------------------------------------------------------------------------------
	|	PARAMETROS PARA A FUNCAO SETPRINT ()
	|---------------------------------------------------------------------------------
	*/
	LOCAL WNREL   	:= "QIER270R"
	LOCAL CSTRING 	:= "QEK"
	LOCAL CDESC1  	:= "SERAO IMPRESSAS AS ETIQUETAS DE LAUDO."					// SERAO IMPRESSAS AS ETIQUETAS DE LAUDO.
	LOCAL CDESC2  	:= "" 					//
	LOCAL CDESC3  	:= ""

	/*
	|---------------------------------------------------------------------------------
	|	GUARDA AQUIVO E INDICES CORRENTES
	|---------------------------------------------------------------------------------
	*/

	/*
	|---------------------------------------------------------------------------------
	|	PARAMETROS PARA A FUNCAO SETPRINT
	|---------------------------------------------------------------------------------
	*/
	PRIVATE CTITULO	 := "ETIQUETA DE LAUDO"					//
	PRIVATE CTAMANHO := "P"
	PRIVATE NPAGINA	 := 1

	/*
	|---------------------------------------------------------------------------------
	|	VARIAVEIS UTILIZADAS PELA FUNCAO SETDEFAULT E SETPRINT
	|---------------------------------------------------------------------------------
	*/
	PRIVATE ARETURN  := {"Zebrado", 1,"Administracao",  1, 2, 1, "",1 }
	PRIVATE NLASTKEY := 0
	PRIVATE CPERG    := "QER270"
	PRIVATE NRECNO   := QEK->(RECNO())
	PRIVATE LEND     := .F.
	PRIVATE NLIMITE  := 80

	DEFAULT CPROG := "QIER270"

	/*
	|=================================================================================
	|   VARIAVEIS UTILIZADAS PARA PARAMETROS
	|---------------------------------------------------------------------------------
	|	MV_PAR01			  // FORNECEDOR DE					     
	|	MV_PAR02			  // FORNECEDOR ATE		    		   	 
	|	MV_PAR03			  // LOJA FORNECEDOR DE	 				 
	|	MV_PAR04			  // LOJA FORNECEDOR ATE   				 
	|	MV_PAR05			  // PRODUTO DE							 
	|	MV_PAR06			  // PRODUTO ATE 						 
	|	MV_PAR07			  // DATA ENTRADA DE					 
	|	MV_PAR08           	  // DATA ENTRADA ATE                    
	|	MV_PAR09              // LOTE DE                             
	|	MV_PAR10              // LOTE ATE                            
	|	MV_PAR11              // ASSUMIR TAM.LOTE                    
	|	MV_PAR12              // N§ DE ETIQUETAS SE NAO USAR TAM.LOTE
	|	MV_PAR13              // CONSIDERA ENTRADA 1)NORMAL			 
	|											   2)BENEFICIAMENTO  
	|											   3)DEVOLUCAO       
	|	MV_PAR14              // NOTA FISCAL                         
	|	MV_PAR15              // SERIE NF                            
	|-- Acrescentado pergunta de Lote de / ate no filtro
	|	MV_PAR16			  // DO LOTE ?
	|	MV_PAR17			  // ATE LOTE ?
	|=================================================================================
	*/
	PERGUNTE(CPERG,.F.)

	/*
	|---------------------------------------------------------------------------------
	|	ENVIA CONTROLE PARA A FUNCAO SETPRINT 
	|---------------------------------------------------------------------------------
	*/
	WNREL := SETPRINT(CSTRING,WNREL,CPERG,@CTITULO,CDESC1,CDESC2,CDESC3,.F.,"",.T.,CTAMANHO,"",.F.)

	/*
	|---------------------------------------------------------------------------------
	|	VERIFICA SE APERTOU O BOTAO CANCELA
	|---------------------------------------------------------------------------------
	*/
	IF NLASTKEY == 27
		RETURN .F.
	ENDIF

	SETDEFAULT(ARETURN,CSTRING)

	IF NLASTKEY == 27
		RETURN .F.
	ENDIF

	RPTSTATUS({|LEND| A270RIMP(@LEND,WNREL,CSTRING,CPROG)},CTITULO)

	// RPTSTATUS({|LEND| TFQ270IMP(@LEND,WNREL,CSTRING,CPROG)},CTITULO)

RETURN NIL

/*
=================================================================================
=================================================================================
||   Arquivo:	QIER270R.PRW	
=================================================================================
||   Funcao: 	A270RIMP
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira realizar o filtro dos Registros conforme configurados 
|| 	nos parametros pelo usuario e alimentara um array para impressao das  
|| 	Etiquetas. 
=================================================================================
=================================================================================
||   Autor: ???
||   Data:	???
=================================================================================
=================================================================================
*/

STATIC FUNCTION A270RIMP(LEND,WNREL,CSTRING,CPROG)

	LOCAL CSQL
	LOCAL CCHAVEQEK1
	LOCAL AETIQ 	:= {}
	LOCAL CETIQ
	LOCAL NETIQ
	LOCAL LNFQEL  	:= IIF(QEL->(FIELDPOS('QEL_NTFISC')) > 0,.T.,.F.)
	LOCAL LQREINSP	:= IIF(FINDFUNCTION("QIEREINSP"),QIEREINSP(),.F.)

	PRIVATE CTAMLOT	:= ""
	PRIVATE NLIN   	:= 0

	SETPRC(00,00)

	IF !CPROG$"QIEA200.QIER220"

		CSQL := "SELECT "
		CSQL += "QEK_TAMLOT, "
		CSQL += "QEK_PRODUT, "
		CSQL += "QEK_REVI, "
		CSQL += "QEK_FORNEC, "
		CSQL += "QEK_LOJFOR, "
		CSQL += "QEK_PRODUT, "
		CSQL += "QEK_NTFISC, "
		CSQL += "QEK_SERINF, "
		CSQL += "QEK_ITEMNF, "
		CSQL += "QEK_TIPONF, "
		CSQL += "QEK_DTENTR, "
		CSQL += "QEK_LOTE, "
		CSQL += "QEK_NUMSEQ, "
		CSQL += "QER_ENSR INSPETOR, "
		CSQL += "QAA_NOME INSPNOME, "
		CSQL += "B1_RASTRO, "
		CSQL += "B1_ITEMSEG "
		CSQL += "FROM "
		CSQL += RETSQLNAME("QEK") + " QEK "
		CSQL += "INNER JOIN "
		CSQL += RETSQLNAME("SB1") + " SB1 ON "
		CSQL += "B1_FILIAL = '" + XFILIAL("SB1") + "' AND "
		CSQL += "B1_COD = QEK_PRODUT AND "
		CSQL += "SB1.D_E_L_E_T_ = '' "
		CSQL += "LEFT JOIN "
		CSQL += RETSQLNAME("QER") + " QER ON "
		CSQL += "QER_FILIAL = '" + XFILIAL("QER") + "' AND "
		CSQL += "QER_PRODUT = QEK_PRODUT AND "
		CSQL += "QER_FORNEC = QEK_FORNEC AND "
		CSQL += "QER_LOJFOR = QEK_LOJFOR AND "
		CSQL += "QER_DTENTR = QEK_DTENTR AND "
		CSQL += "QER_LOTE 	= QEK_LOTE 	 AND "
		CSQL += "QER.D_E_L_E_T_ = '' "
		CSQL += "LEFT JOIN "
		CSQL += RETSQLNAME("QAA") + " QAA ON "
		CSQL += "QAA_FILIAL = '" + XFILIAL("QAA") + "' AND "
		CSQL += "QAA_MAT = QER_ENSR AND "
		CSQL += "QAA.D_E_L_E_T_ = '' "
		CSQL += "WHERE "
		CSQL += "QEK_FILIAL = '" + XFILIAL("QEK") + "' "
		CSQL += "AND QEK_FORNEC >= '" + MV_PAR01 + "' AND QEK_FORNEC <= '" + MV_PAR02 + "' "
		CSQL += "AND QEK_LOJFOR >= '" + MV_PAR03 + "' AND QEK_LOJFOR <= '" + MV_PAR04 + "' "
		CSQL += "AND QEK_PRODUT >= '" + MV_PAR05 + "' AND QEK_PRODUT <= '" + MV_PAR06 + "' "
		CSQL += "AND QEK_DTENTR >= '" + DTOS(MV_PAR07) + "' AND QEK_DTENTR <= '" + DTOS(MV_PAR08) + "' "
		CSQL += "AND QEK_NTFISC = '" + MV_PAR14 + "' "
		CSQL += "AND QEK_SERINF = '" + MV_PAR15 + "' "

		IF MV_PAR13	== 1
			CSQL += " AND (QEK_TIPONF = 'N' OR QEK_TIPONF = ' ') "
		ELSEIF MV_PAR13 == 2
			CSQL += " AND QEK_TIPONF = 'B' "
		ELSEIF MV_PAR13 == 3
			CSQL += " AND QEK_TIPONF = 'D' "
		ENDIF

		CSQL += "AND QEK_LOTE >= '" + MV_PAR09 + "' "
		CSQL += "AND QEK_LOTE <= '" + MV_PAR10 + "' "
		CSQL += "AND QEK.D_E_L_E_T_ <> '*'"
		CSQL += "GROUP BY "
		CSQL += "QEK_TAMLOT, "
		CSQL += "QEK_PRODUT, "
		CSQL += "QEK_REVI, "
		CSQL += "QEK_FORNEC, "
		CSQL += "QEK_LOJFOR, "
		CSQL += "QEK_PRODUT, "
		CSQL += "QEK_NTFISC, "
		CSQL += "QEK_SERINF, "
		CSQL += "QEK_ITEMNF, "
		CSQL += "QEK_TIPONF, "
		CSQL += "QEK_DTENTR, "
		CSQL += "QEK_LOTE, "
		CSQL += "QEK_NUMSEQ, "
		CSQL += "QER_ENSR, "
		CSQL += "QAA_NOME, "
		CSQL += "B1_RASTRO, "
		CSQL += "B1_ITEMSEG"

		IF SELECT("TMP") > 0
			TMP->( DBCLOSEAREA() )
		ENDIF

		DBUSEAREA(.T., "TOPCONN",TCGENQRY(,,CSQL),"TMP",.F.,.T.)

		//MEMOWRITE( "QIER270R_LOTE_A_IMPRIMIR.SQL" , CSQL )

		IF MV_PAR11 == 1  				// ASSUME O TAMANHO DO LOTE
			NETIQ := TMP->QEK_TAMLOT
		ELSE
			NETIQ := MV_PAR12
		ENDIF

		WHILE TMP->(!EOF() )

			CCHAVEQEK1	:= TMP->QEK_PRODUT+INVERTE(TMP->QEK_REVI)

			DBSELECTAREA("QE6")
			DBSETORDER(1)
			QE6->(DBSEEK(XFILIAL("QE6")+CCHAVEQEK1))

			IF LNFQEL
				QEL->(DBSETORDER(3))
				CSEEK := TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUTO+TMP->QEK_NTFISC+TMP->QEK_SERINF+TMP->QEK_ITEMNF+TMP->QEK_TIPONF+DTOS(TMP->QEK_DTENTR)+TMP->QEK_LOTE+SPACE(TAMSX3("QEL_LABOR")[1])
				IF LQREINSP
					CSEEK += TMP->QEK_NUMSEQ
				ENDIF
			ELSE
				QEL->(DBSETORDER(1))
				CSEEK := TMP->QEK_FORNEC+TMP->QEK_LOJFOR+TMP->QEK_PRODUTO+TMP->QEK_DTENTR+TMP->QEK_LOTE+SPACE(TAMSX3("QEL_LABOR")[1])
			ENDIF

			IF QEL->(DBSEEK(XFILIAL("QEL")+CSEEK))
				IF LQREINSP .AND. !LNFQEL
					WHILE QEL->(!EOF()) .AND. ;
							QEL->(QEL_FILIAL+QEL_FORNEC+QEL_LOJFOR+QEL_PRODUT+DTOS(QEL_DTENTR)+QEL_LOTE)+SPACE(TAMSX3("QEL_LABOR")[1]) == XFILIAL("QEL")+CSEEK

						IF QEL->QEL_NUMSEQ == TMP->QEK_NUMSEQ
							EXIT
						ENDIF

						QEL->(DBSKIP())
					ENDDO
				ENDIF

				IF EMPTY(QEL->(QEL_NUMPER))
					IF QED->(DBSEEK(XFILIAL("QED")+QEL->QEL_LAUDO))
						CETIQ := ALLTRIM(QED->QED_DESCPO)
					ELSE
						CETIQ := "EM INSPECAO" 			//
					ENDIF
				ELSE
					QF2->(DBSETORDER(1))
					IF QF2->(DBSEEK(XFILIAL("QF2")+TMP->QEK_FORNEC+TMP->QEK_LOJFOR+;
							TMP->QEK_PRODUT+DTOS(TMP->QEK_DTENTR)+TMP->QEK_LOTE+;
							QEL->QEL_NUMPER))
						// SE A PU FOR APROVADA, O LAUDO A SER IMPRESSO E LIBERADO
						IF QF2->QF2_STATUS == "A"
							CETIQ := "LIBERADO"		//
						ELSE
							// PERMANECE O LAUDO DEFINIDO PELO USUARIO
							IF QED->(DBSEEK(XFILIAL("QED")+QEL->QEL_LAUDO))
								CETIQ := ALLTRIM(QED->QED_DESCPO)
							ELSE
								CETIQ := "EM INSPECAO" 	//
							ENDIF
						ENDIF
					ENDIF
				ENDIF
			ELSE
				CETIQ := "EM INSPECAO" 					//
			ENDIF

			AADD( AETIQ, {	CETIQ,"PRODUTO: " + TMP->QEK_PRODUTO,QE6->QE6_DESCPO,"DATA ENTREGA: " + DTOC( STOD(TMP->QEK_DTENTR) ),;
				"LOTE: " + TRIM( TMP->QEK_LOTE ) + " TAM. LOTE: " + TMP->QEK_TAMLOT,"NOTA FISCAL: " + TMP->QEK_NTFISC + "/" + TMP->QEK_SERINF,;
				"INSPETOR: " + TMP->INSPETOR,"JUSTIFICATIVA: " + QEL->QEL_JUSTLA,TRIM( TMP->QEK_LOTE ),TMP->B1_RASTRO,TMP->B1_ITEMSEG})

			TMP->(DBSKIP())

		ENDDO

		A270RIMET(LEND,WNREL,CSTRING,CPROG,NETIQ,AETIQ)

	ENDIF

	MS_FLUSH()

RETURN(.T.)

/*
=================================================================================
=================================================================================
||   Arquivo:	QIER270R.PRW	
=================================================================================
||   Funcao: 	A270RIMET
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para impressao da Etiqueta.
|| 
=================================================================================
=================================================================================
||   Autor: JAR 
||   Data:	???
=================================================================================
=================================================================================
*/

STATIC FUNCTION A270RIMET(LEND,WNREL,CSTRING,CPROG,NETIQ,AETIQ)

/*
|---------------------------------------------------------------------------------
|	Alterado a definicao de porta de impressao para que seja configurado conforme 
|	cadastrado no Sistema e nao "taxado" no fonte.
|
|	Edson Hornberger - 31/10/2014
|---------------------------------------------------------------------------------
*/

	LOCAL NX
	LOCAL I
	LOCAL CPORTA := ""

	CB5->(DBSEEK(XFILIAL("CB5")+"QUALID"))

	IF CB5->CB5_LPT != "0"
		CPORTA := "LPT" + ALLTRIM( CB5->CB5_LPT )
	ELSE
		CPORTA := "COM" + ALLTRIM( CB5->CB5_PORTA )
	ENDIF

	IF CB5->CB5_LPT != "0"
		PRINTERWIN(.F.) 						// IMPRESSAO DOS/WINDOWS
		PREPAREPRINT(.F.,"",.F.,CPORTA) 		// PREPARA A IMPRESSAO NA PORTA ESPECIFICADA
		INITPRINT(1)
	ELSE
		NHDLL := 0
		MSOPENPORT(NHDLL,CPORTA + ":9600,N,8,1")
	ENDIF

	MSCBPRINTER("S500-8", CPORTA, , 50, .F.)
	MSCBCHKSTATUS(.F.)

	FOR NX := 1 TO LEN(AETIQ)

		FOR I := 1 TO NETIQ

			MSCBINFOETI("QUALIDADE", "LAUDO")
			MSCBBEGIN(1,2,50)

			MSCBSAY(07, 03, AETIQ[NX,01], "N", "0", "040,050",.T.)	// Status do laudo (Aprovado/Reprovado/Em Analise)
			MSCBSAY(07, 09, AETIQ[NX,02], "N", "0", "040,050")		// Codigo do Produto
			MSCBSAY(07, 15, AETIQ[NX,03], "N", "0", "020,020")		// Descricao do Produto
			MSCBSAY(07, 19, AETIQ[NX,04], "N", "0", "020,020")		// Data da Entrega
			MSCBSAY(07, 22, AETIQ[NX,05], "N", "0", "020,020")		// Numero e Tamanho do Lote
			MSCBSAY(07, 25, AETIQ[NX,06], "N", "0", "020,020")		// Nota Fiscal
			MSCBSAY(07, 28, AETIQ[NX,07], "N", "0", "020,020")		// Inspetor
			MSCBSAY(07, 31, AETIQ[NX,08], "N", "0", "020,020")		// Justificativa
			IF AETIQ[NX,10] = 'L' .AND. AETIQ[NX,11] = '1'
				MSCBSAYBAR(10, 36, AETIQ[NX,09], "N", "MB07", 15)		// Codigo de Barras
				MSCBSAY(10, 55, AETIQ[NX,09], "N", "0", "040,050")		// Codigo do Produto
			ENDIF

			MSCBEND()

		NEXT

	NEXT

	MSCBCLOSEPRINTER()
	MS_FLUSH()

RETURN( .T. )
