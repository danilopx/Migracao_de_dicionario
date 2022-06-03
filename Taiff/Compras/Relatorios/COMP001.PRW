#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao:	COMP001 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Relatorio Grafico para impressao do Pedido de Compra.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		10/12/2013
=================================================================================
=================================================================================
*/

USER FUNCTION COMP001()

	PRIVATE CPERG			:= PADR("COMP001",10)
	PRIVATE APERG			:= {}
	PRIVATE NLIN			:= 0
	PRIVATE CSTARTPATH 	:= ""
	PRIVATE CEMAIL			:= ""
	PRIVATE nREG            := 0

/*01*/AADD(APERG,{"Emissao de:"		,"D",08,00,"G","","","","","","",""})
/*02*/AADD(APERG,{"Emissao ate:"	,"D",08,00,"G","","","","","","",""})
/*03*/AADD(APERG,{"Pedido de:"		,"C",06,00,"G","","","","","","",""})
/*04*/AADD(APERG,{"Pedido ate:"		,"C",06,00,"G","","","","","","",""})
/*05*/AADD(APERG,{"Envia Email:"	,"C",01,00,"C","","Sim","Nao","","","",""})

	CRIAPERG(CPERG,APERG)

	IF TYPE("PARAMIXB") <> "U"

		DBSELECTAREA("SC7")
		MV_PAR01 := SC7->C7_EMISSAO
		MV_PAR02 := SC7->C7_EMISSAO
		MV_PAR03 := SC7->C7_NUM
		MV_PAR04 := SC7->C7_NUM
		IF MSGYESNO("Envia por Email?")

			MV_PAR05 := 1

		ELSE

			MV_PAR05 := 2

		ENDIF

		GERATRAB()

		IF CNT->CNT <= 0

			MSGINFO("RelatÛrio sem dados para serem impressos!","Pedido de Compra")
			RETURN()

		ENDIF

		MAKEDIR("C:\PEDCOMPRAS\")

		PROCESSA({|| GERAREL(CNT->CNT)},"Imprindo Pedido de Compra")

		IF MV_PAR05 = 1

			DBSELECTAREA("TRB")
			DBGOTOP()

			CEMAIL := ALLTRIM(LOWER(TRB->A2_EMAIL))

			IF FILE("\MAILSPOOL\COM001.PDF")

				DELETE FILE "\MAILSPOOL\COM001.PDF"

			ENDIF
			PROCESSA( { || LRET := CPYT2S("C:\PEDCOMPRAS\COM001.PDF","\MAILSPOOL\")},"Transferindo PDF para Servidor!","Aguarde")
			U_1ENVMAIL("\MAILSPOOL\COM001.PDF",CEMAIL)

		ENDIF

	ELSE

		IF PERGUNTE(CPERG,.T.)

			GERATRAB()

			IF CNT->CNT <= 0

				MSGINFO("RelatÛrio sem dados para serem impressos!","Pedido de Compra")
				RETURN()

			ENDIF

			MAKEDIR("C:\PEDCOMPRAS\")

			PROCESSA({|| GERAREL(CNT->CNT)},"Imprindo Pedido de Compra")

			IF MV_PAR05 = 1

				DBSELECTAREA("TRB")
				DBGOTOP()

				CEMAIL := ALLTRIM(LOWER(TRB->A2_EMAIL))

				IF FILE("\MAILSPOOL\COM001.PDF")

					DELETE FILE "\MAILSPOOL\COM001.PDF"

				ENDIF
				PROCESSA( { || LRET := CPYT2S("C:\PEDCOMPRAS\COM001.PDF","\MAILSPOOL\")},"Transferindo PDF para Servidor!","Aguarde")
				U_1ENVMAIL("\MAILSPOOL\COM001.PDF",CEMAIL)

			ENDIF

		ENDIF

	ENDIF

RETURN()

/*
=================================================================================
=================================================================================
||   Arquivo: COMP001.PRW
=================================================================================
||   Funcao: 	CRIAPERG
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que gera ou da manutencao no Grupo de Perguntas.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION CRIAPERG(CPERG,APERG)

	LOCAL CORDEM 	:= ""
	Local X := 0

	DBSELECTAREA("SX1")
	DBSETORDER(1)

	FOR X := 1 TO LEN(APERG)
		CORDEM := STRZERO(X,2)
		IF DBSEEK(CPERG+CORDEM,.T.)
			RECLOCK("SX1",.F.)
			X1_GRUPO	:= CPERG
			X1_ORDEM	:= CORDEM
			X1_PERGUNT	:= APERG[X,01]
			X1_PERSPA	:= APERG[X,01]
			X1_PERENG	:= APERG[X,01]
			X1_VARIAVL	:= "MV_CH" + ALLTRIM(STR(X))
			X1_TIPO	:= APERG[X,02]
			X1_TAMANHO	:= APERG[X,03]
			X1_DECIMAL	:= APERG[X,04]
			X1_GSC		:= APERG[X,05]
			X1_VALID	:= APERG[X,06]
			X1_VAR01	:= "MV_CH" + ALLTRIM(STR(X))
			X1_DEF01	:= APERG[X,07]
			X1_DEF02	:= APERG[X,08]
			X1_DEF03	:= APERG[X,09]
			X1_DEF04	:= APERG[X,10]
			X1_DEF05	:= APERG[X,11]
			X1_F3		:= APERG[X,12]
			MSUNLOCK()
		ELSE
			RECLOCK("SX1",.T.)
			X1_GRUPO	:= CPERG
			X1_ORDEM	:= CORDEM
			X1_PERGUNT	:= APERG[X,01]
			X1_PERSPA	:= APERG[X,01]
			X1_PERENG	:= APERG[X,01]
			X1_VARIAVL	:= "MV_CH" + ALLTRIM(STR(X))
			X1_TIPO	:= APERG[X,02]
			X1_TAMANHO	:= APERG[X,03]
			X1_DECIMAL	:= APERG[X,04]
			X1_GSC		:= APERG[X,05]
			X1_VALID	:= APERG[X,06]
			X1_VAR01	:= "MV_CH" + ALLTRIM(STR(X))
			X1_DEF01	:= APERG[X,07]
			X1_DEF02	:= APERG[X,08]
			X1_DEF03	:= APERG[X,09]
			X1_DEF04	:= APERG[X,10]
			X1_DEF05	:= APERG[X,11]
			X1_F3		:= APERG[X,12]
			MSUNLOCK()
		ENDIF
	NEXT X

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao:	GERATRAB 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que gera os Arquivos de Trabalho com registros a partir
|| 	dos parametros definidos pelo usuario.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION GERATRAB()

	PRIVATE CQUERY 	:= ""
	PRIVATE CPL		:= CHR(13) + CHR(10)

	IF SELECT("TRB") > 0

		DBSELECTAREA("TRB")
		DBCLOSEAREA()

	ENDIF

	IF SELECT("CNT") > 0

		DBSELECTAREA("CNT")
		DBCLOSEAREA()

	ENDIF

	CQUERY := "SELECT" + CPL
	CQUERY += "SC7.C7_NUM," + CPL
	CQUERY += "SC7.C7_EMISSAO," + CPL
	CQUERY += "SC7.C7_FORNECE," + CPL
	CQUERY += "SA2.A2_NOME," + CPL
	CQUERY += "SA2.A2_END," + CPL
	CQUERY += "SA2.A2_COMPLEM," + CPL
	CQUERY += "SA2.A2_BAIRRO," + CPL
	CQUERY += "SA2.A2_MUN," + CPL
	CQUERY += "SA2.A2_EST," + CPL
	CQUERY += "SA2.A2_CEP," + CPL
	CQUERY += "SA2.A2_CGC," + CPL
	CQUERY += "SA2.A2_DDD," + CPL
	CQUERY += "SA2.A2_TEL," + CPL
	CQUERY += "SA2.A2_FAX," + CPL
	CQUERY += "SA2.A2_EMAIL," + CPL
	CQUERY += "SC7.C7_MOEDA," + CPL
	CQUERY += "SC7.C7_ITEM," + CPL
	CQUERY += "SC7.C7_PRODUTO," + CPL
	CQUERY += "SC7.C7_DESCRI," + CPL
	CQUERY += "SC7.C7_UM," + CPL
	CQUERY += "SC7.C7_QUANT," + CPL
	CQUERY += "SC7.C7_PRECO," + CPL
	CQUERY += "SC7.C7_IPI," + CPL
	CQUERY += "SC7.C7_TOTAL," + CPL
	CQUERY += "SC7.C7_VLDESC," + CPL
	CQUERY += "SC7.C7_DATPRF," + CPL
	CQUERY += "SC7.C7_COND," + CPL
	CQUERY += "SC7.C7_CC," + CPL
	CQUERY += "RTRIM(SC7.C7_NUMSC) + RTRIM(SC7.C7_ITEMSC) AS C7_NUMSC," + CPL
	CQUERY += "SC7.C7_APROV," + CPL
	CQUERY += "SC7.C7_CONAPRO," + CPL
	CQUERY += "SE4.E4_COND," + CPL
	CQUERY += "SE4.E4_DESCRI," + CPL
	CQUERY += "SC7.C7_VALIPI," + CPL
	CQUERY += "SC7.C7_VALICM," + CPL
	CQUERY += "SC7.C7_ICMSRET," + CPL
	CQUERY += "SC7.C7_VALFRE," + CPL
	CQUERY += "SC7.C7_DESPESA," + CPL
	CQUERY += "SC7.C7_SEGURO," + CPL
	CQUERY += "SC7.C7_USER," + CPL
	CQUERY += "SC7.C7_OBS" + CPL

	CQUERY += "FROM" + CPL
	CQUERY += RETSQLNAME("SC7") + " SC7," + CPL
	CQUERY += RETSQLNAME("SA2") + " SA2," + CPL
	CQUERY += RETSQLNAME("SE4") + " SE4" + CPL

	CQUERY += "WHERE" + CPL

	CQUERY += "SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" + CPL
	CQUERY += "SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" + CPL
	CQUERY += "SE4.E4_FILIAL = '" + XFILIAL("SE4") + "' AND" + CPL
	CQUERY += "SC7.C7_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND" + CPL
	CQUERY += "SC7.C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND" + CPL
	CQUERY += "SC7.C7_COND = SE4.E4_CODIGO AND" + CPL
	CQUERY += "SC7.C7_FORNECE = SA2.A2_COD AND" + CPL
	CQUERY += "SC7.C7_LOJA = SA2.A2_LOJA AND" + CPL
	CQUERY += "SC7.D_E_L_E_T_ = ' ' AND" + CPL
	CQUERY += "SA2.D_E_L_E_T_ = ' ' AND" + CPL
	CQUERY += "SE4.D_E_L_E_T_ = ' '" + CPL

	CQUERY += "ORDER BY SC7.C7_NUM, SC7.C7_ITEM" + CPL

	MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_AVN1.QRY",CQUERY)
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")

	CQUERY := "SELECT" + CPL
	CQUERY += "COUNT(*) AS CNT" + CPL

	CQUERY += "FROM" + CPL
	CQUERY += RETSQLNAME("SC7") + " SC7," + CPL
	CQUERY += RETSQLNAME("SA2") + " SA2," + CPL
	CQUERY += RETSQLNAME("SE4") + " SE4" + CPL

	CQUERY += "WHERE" + CPL

	CQUERY += "SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" + CPL
	CQUERY += "SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" + CPL
	CQUERY += "SE4.E4_FILIAL = '" + XFILIAL("SE4") + "' AND" + CPL
	CQUERY += "SC7.C7_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND" + CPL
	CQUERY += "SC7.C7_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' AND" + CPL
	CQUERY += "SC7.C7_COND = SE4.E4_CODIGO AND" + CPL
	CQUERY += "SC7.C7_FORNECE = SA2.A2_COD AND" + CPL
	CQUERY += "SC7.C7_LOJA = SA2.A2_LOJA AND" + CPL
	CQUERY += "SC7.D_E_L_E_T_ = ' ' AND" + CPL
	CQUERY += "SA2.D_E_L_E_T_ = ' ' AND" + CPL
	CQUERY += "SE4.D_E_L_E_T_ = ' '"

	TCQUERY CQUERY NEW ALIAS "CNT"
	DBSELECTAREA("CNT")

RETURN()

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	GERAREL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que realiza o controle de impressao do Relatorio. 
|| 	Nele e realizado o controle do Meter com as quantidades de Registros 
|| selecionados.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION GERAREL(nCNT)

	LOCAL lADJUSTTOLEGACY 	:= .F.
	LOCAL lDISABLESETUP		:= .T.
	PRIVATE nTAMHOR			:= 0
	PRIVATE nTAMVER			:= 0
	PRIVATE cCODPEDI		:= ""
	PRIVATE nTOTMERC		:= 0
	PRIVATE nTOTDESC		:= 0
	PRIVATE nTOTGERA		:= 0
	PRIVATE nTOTICMS		:= 0
	PRIVATE nTOTIPI			:= 0
	PRIVATE nTOTFRET		:= 0
	PRIVATE nTOTSEGU		:= 0
	PRIVATE nTOTDESP		:= 0
	PRIVATE cCONDPG			:= ""
	PRIVATE cDESCPG			:= ""
	PRIVATE cUSUARIO		:= ""
	PRIVATE aOBSERV			:= {}
	PRIVATE nITENS			:= 1

	SETPRVT("oPRINT,oFONT09,oFONT09N,oFONT10,oFONT10N,oFONT11,oFONT12,oFONT12N,oFONT16N")

	oFONT08		:= TFONT():NEW("ARIAL",,10,,.F.,,,,,.F.,.F.)
	oFONT09		:= TFONT():NEW("ARIAL",,11,,.F.,,,,,.F.,.F.)
	oFONT09N	:= TFONT():NEW("ARIAL",,11,,.T.,,,,,.F.,.F.)
	oFONT10		:= TFONT():NEW("ARIAL",,12,,.F.,,,,,.F.,.F.)
	oFONT10N	:= TFONT():NEW("ARIAL",,12,,.T.,,,,,.F.,.F.)
	oFONT11		:= TFONT():NEW("ARIAL",,13,,.F.,,,,,.F.,.F.)
	oFONT12		:= TFONT():NEW("ARIAL",,14,,.F.,,,,,.F.,.F.)
	oFONT12N	:= TFONT():NEW("ARIAL",,14,,.T.,,,,,.F.,.F.)
	oFONT14N	:= TFONT():NEW("ARIAL",,16,,.T.,,,,,.F.,.F.)
	oFONT16N	:= TFONT():NEW("ARIAL",,18,,.T.,,,,,.F.,.F.)

	oPRINT 		:= FWMSPRINTER():NEW("COM001.REL",IMP_PDF,lADJUSTTOLEGACY,,lDISABLESETUP)
	oPRINT:SETRESOLUTION(78)
	oPRINT:SETLANDSCAPE()
	oPRINT:SETPAPERSIZE(DMPAPER_A4)
	oPRINT:SETMARGIN(60,60,60,60)
	oPRINT:cPATHPDF := "C:\PEDCOMPRAS\"

	nTAMHOR := 870
	nTAMVER := 610

	PROCREGUA(nCNT)
	DBSELECTAREA("TRB")
	DBGOTOP()

	WHILE TRB->(!EOF())

		INCPROC("Imprimindo Pedido de Compra " + TRB->C7_NUM)

		IF cCODPEDI <> TRB->C7_NUM

			IF !EMPTY(cCODPEDI)

				IF NLIN >= 391.58 .OR. nITENS > 21

					NLIN := IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)
					nITENS := 1

				ENDIF

				NLIN := IMPINF(NLIN,nTOTMERC,nTOTDESC,nTOTGERA,nTOTICMS,nTOTIPI,nTOTFRET,nTOTSEGU,nTOTDESP,nTAMHOR,nTAMVER,cCONDPG,cDESCPG,cUSUARIO,aOBSERV,CLIB,CAPROVAD,cCODPEDI)

			ENDIF

			IF NLIN >= 391.58 .OR. nITENS > 21

				NLIN 	:= 0
				nITENS 	:= 1
				NLIN 	:= IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)

			ENDIF

			cCODPEDI	:= TRB->C7_NUM
			CLIB		:= TRB->C7_CONAPRO
			CAPROVAD	:= TRB->C7_APROV
			nTOTMERC	:= 0
			nTOTDESC	:= 0
			nTOTGERA	:= 0
			nTOTICMS	:= 0
			nTOTIPI		:= 0
			nTOTST		:= 0
			nTOTFRET	:= 0
			nTOTSEGU	:= 0
			nTOTDESP	:= 0
			NLIN		:= 0
			NLIN 		:= IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)

		ENDIF

		IF NLIN >= 368.95 .OR. nITENS > 21

			NLIN 	:= IMPINF(NLIN,nTOTMERC,nTOTDESC,nTOTGERA,nTOTICMS,nTOTIPI,nTOTFRET,nTOTSEGU,nTOTDESP,nTAMHOR,nTAMVER,cCONDPG,cDESCPG,cUSUARIO,aOBSERV,CLIB,CAPROVAD,cCODPEDI)
			NLIN 	:= IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)
			nITENS 	:= 1

		ENDIF

		IF NLIN >= 573.84  .OR. nITENS > 21

			NLIN 	:= IMPINF(NLIN,nTOTMERC,nTOTDESC,nTOTGERA,nTOTICMS,nTOTIPI,nTOTFRET,nTOTSEGU,nTOTDESP,nTAMHOR,nTAMVER,cCONDPG,cDESCPG,cUSUARIO,aOBSERV,CLIB,CAPROVAD,cCODPEDI)
			oPRINT:ENDPAGE()
			nITENS 	:= 1
			NLIN 	:= 0
			NLIN 	:= IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)

		ENDIF

		NLIN 	:= IMPDET(NLIN,nTAMHOR,nTAMVER)
		nITENS 	+= 1

		IF LEN(aOBSERV) > 0

			nPOS := 0
			nPOS := ASCAN(aOBSERV,{|X| X[1] == ALLTRIM(TRB->C7_OBS)})
			IF nPOS <= 0

				AADD(aOBSERV,{ALLTRIM(TRB->C7_OBS)})

			ENDIF

		ELSE

			AADD(aOBSERV,{ALLTRIM(TRB->C7_OBS)})

		ENDIF

		nTOTMERC	+= TRB->C7_TOTAL
		nTOTDESC	+= TRB->C7_VLDESC
		nTOTGERA	+= TRB->C7_TOTAL + TRB->C7_VALIPI + TRB->C7_ICMSRET + TRB->C7_VALFRE + TRB->C7_DESPESA + TRB->C7_SEGURO - TRB->C7_VLDESC
		nTOTICMS	+= TRB->C7_VALICM
		nTOTIPI		+= TRB->C7_VALIPI
		nTOTST		+= TRB->C7_ICMSRET
		nTOTFRET	+= TRB->C7_VALFRE
		nTOTSEGU	+= TRB->C7_SEGURO
		nTOTDESP	+= TRB->C7_DESPESA
		cCONDPG		:= TRB->E4_COND
		cDESCPG		:= TRB->E4_DESCRI
		cUSUARIO	:= TRB->C7_USER

		TRB->(DBSKIP())

	ENDDO

	NLIN := IMPINF(NLIN,nTOTMERC,nTOTDESC,nTOTGERA,nTOTICMS,nTOTIPI,nTOTFRET,nTOTSEGU,nTOTDESP,nTAMHOR,nTAMVER,cCONDPG,cDESCPG,cUSUARIO,aOBSERV,CLIB,CAPROVAD,cCODPEDI)

	oPRINT:ENDPAGE()
	oPRINT:PREVIEW()

	FREEOBJ(oPRINT)

RETURN()

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	IMPSUP
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica onde e realizado a impressao da parte Superior do 
|| 	Relatorio.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION IMPSUP(NLIN,cCODPEDI,nTAMHOR,nTAMVER)

	LOCAL cLOGOTIPO 	:= "\SYSTEM\LGRL" + CEMPANT + ".BMP"
	LOCAL aDADOSEMP	:= {}

	AADD(aDADOSEMP,{ALLTRIM(SM0->M0_NOMECOM),ALLTRIM(SM0->M0_ENDCOB),SM0->M0_CEPCOB,ALLTRIM(SM0->M0_CIDCOB),SM0->M0_ESTCOB,STRTRAN(SM0->M0_TEL,"-",""),STRTRAN(SM0->M0_FAX,"-",""),SM0->M0_CGC,SM0->M0_INSC})

	oPRINT:STARTPAGE()

//RETANGULO EXTERNO DO RELATORIO
	oPRINT:BOX(0,0,610,870,"-6")

//LINHAS HORIZONTAIS DO CABECALHO
	oPRINT:LINE(048.46,353.41,048.46,NTAMHOR,,"-6")
	oPRINT:LINE(113.39,000.00,113.39,NTAMHOR,,"-6")
	oPRINT:LINE(138.48,000.00,138.48,NTAMHOR,,"-6")

//LINHAS VERTICAIS DO CABECALHO
	oPRINT:LINE(113.39,040.13,391.58,040.13,,"-6") // CC
	oPRINT:LINE(113.39,076.13,391.58,076.13,,"-6") // Item
	oPRINT:LINE(113.39,144.42,391.58,144.42,,"-6") // CÛdigo
	oPRINT:LINE(113.39,352.41,391.58,352.41,,"-6") // DescriÁ„o
	oPRINT:LINE(113.39,377.55,391.58,377.55,,"-6") // UM.
	oPRINT:LINE(113.39,432.86,391.58,432.86,,"-6") // Quantidade
	oPRINT:LINE(113.39,525.87,391.58,525.87,,"-6") // Valor Unit.
	oPRINT:LINE(113.39,605.24,445.69,605.24,,"-6") // IPI
	oPRINT:LINE(113.39,682.62,391.58,682.62,,"-6") // ST
	oPRINT:LINE(113.39,760.62,391.58,760.62,,"-6") // Valor Total
	oPRINT:LINE(113.39,815.62,391.58,815.62,,"-6") // Entrega

	oPRINT:LINE(000.00,352.41,113.39,352.41,,"-6") // Divide o logotipo do "PEDIDO DE COMPRA"
	oPRINT:LINE(000.00,538.75,048.46,538.75,,"-6") // Divide o "PEDIDO DE COMPRA" do "N⁄MERO DO PEDIDO"
	oPRINT:LINE(000.00,705.91,048.46,705.91,,"-6") // Divide o "N⁄MERO DO PEDIDO" da "DATA DO PEDIDO"
	oPRINT:LINE(048.46,795.54,113.39,795.54,,"-6") // Divide as informaÁıes do "FFORNECEDOR" da "MOEDA"


//IMPRESSAO DO LOGOTIPO
	oPRINT:SAYBITMAP(055.05,015.00,cLOGOTIPO,083.33,053.62)
	oPRINT:SAY(025.58,386.90,"PEDIDO DE COMPRA",oFONT12N)
	oPRINT:SAY(025.58,612.32,TRB->C7_NUM,oFONT12N)
	oPRINT:SAY(025.58,770.05,DTOC(STOD(TRB->C7_EMISSAO)),oFONT12N)

//IMPRESSAO DOS DADOS DA EMPRESA
//oPRINT:SAY(031.73,126.98,aDADOSEMP[1][1],oFONT12N)
	oPRINT:SAY(015.00,021.00,aDADOSEMP[1][1],oFONT12N)
	oPRINT:SAY(058.05,124.50,aDADOSEMP[1][2],oFONT11)
	oPRINT:SAY(069.75,124.50,"CEP: " + TRANSFORM(aDADOSEMP[1][3],"@R 99.999-999") + " - " + aDADOSEMP[1][4] + " - " + aDADOSEMP[1][5] ,oFONT11)
	oPRINT:SAY(081.45,124.50,"TEL: " + TRANSFORM(aDADOSEMP[1][6],"@R 99 (99) 9999-9999") + " FAX: " + TRANSFORM(aDADOSEMP[1][7],"@R 99 (99) 9999-9999"),oFONT10)
	oPRINT:SAY(093.15,124.50,"CNPJ: " + TRANSFORM(aDADOSEMP[1][8],"@R 99.999.999/9999-99") + " IE: " + aDADOSEMP[1][9],oFONT11)

//IMPRESSAO DOS DADOS DO FORNECEDOR
	oPRINT:SAY(060.54,375.48,TRB->C7_FORNECE + " - " + ALLTRIM(SUBSTR(TRB->A2_NOME,1,50)),oFONT11)
	oPRINT:SAY(072.14,375.48,ALLTRIM(TRB->A2_END) + " - " + ALLTRIM(TRB->A2_BAIRRO),oFONT11)
	oPRINT:SAY(083.74,375.48,ALLTRIM(TRB->A2_MUN) + " - " + TRB->A2_EST + " - CEP: " + TRANSFORM(TRB->A2_CEP,"@R 99.999-999") + " - CNPJ: " + TRANSFORM(TRB->A2_CGC,"@R 99.999.999/9999-99"),oFONT11)
	oPRINT:SAY(095.34,375.48,"FONE: " + TRANSFORM(IIF(LEN(ALLTRIM(TRB->A2_DDD)) = 3,SUBSTR(TRB->A2_DDD,2,2),TRB->A2_DDD)+TRB->A2_TEL,"@R (99) 9999-9999") + " FAX: " + TRANSFORM(IIF(LEN(ALLTRIM(TRB->A2_DDD)) = 3,SUBSTR(TRB->A2_DDD,2,2),TRB->A2_DDD)+TRB->A2_FAX,"@R (99) 9999-9999"),oFONT11)

//IMPRESSAO DA MOEDA
	oPRINT:SAY(071.33,811.97,"MOEDA",oFONT10N)
	oPRINT:SAY(082.40,819.66,GETMV("MV_MOEDA"+STR(TRB->C7_MOEDA,1)),oFONT10N)

//IMPRESSAO CABECALHO DOS ITENS
	oPRINT:SAY(125.00,013.50,"CC",oFONT09N)
	oPRINT:SAY(125.00,046.50,"ITEM",oFONT09N)
	oPRINT:SAY(125.00,090.50,"C”DIGO",oFONT09N)
	oPRINT:SAY(125.00,185.32,"DESCRI«√O DO PRODUTO",oFONT09N)
	oPRINT:SAY(125.00,358.19,"UM",oFONT09N)
	oPRINT:SAY(125.00,386.58,"QUANT.",oFONT09N)
	oPRINT:SAY(125.00,444.78,"VLR. UNIT¡RIO",oFONT09N)
	oPRINT:SAY(125.00,558.85,"IPI",oFONT09N)
	oPRINT:SAY(125.00,635.60,"ST",oFONT09N)
	oPRINT:SAY(125.00,694.79,"VLR. TOTAL",oFONT09N)
	oPRINT:SAY(125.00,766.41,"ENTREGA",oFONT09N)
	oPRINT:SAY(125.00,833.63,"SC",oFONT09N)

	NLIN := 150.48

RETURN(NLIN)

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	IMPINF
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que imprime a parte inferior do Relatorio com varias 
|| 	informacoes sobre o Pedido de Compras.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION IMPINF(NLIN,nTOTMERC,nTOTDESC,nTOTGERA,nTOTICMS,nTOTIPI,nTOTFRET,nTOTSEGU,nTOTDESP,nTAMHOR,nTAMVER,cCONDPG,cDESCPG,cUSUARIO,aOBSERV,CLIB,CAPROVAD,cPEDIDO)

	LOCAL aDADOSEND	:= {}
	LOCAL AINFUSR	:= {}
	LOCAL CAPROV	:= ""
	LOCAL _nI		:= 0
	Local cAprovadores := ""

	PRIVATE CQUERY 	:= ""
	PRIVATE CPL		:= CHR(13) + CHR(10)

	AADD(aDADOSEND,{"Local de Entrega: " + ALLTRIM(SM0->M0_ENDENT) + " - " + ALLTRIM(SM0->M0_CIDENT) + " - " + SM0->M0_ESTENT + " - CEP: " + TRANSFORM(SM0->M0_CEPENT,"@R 99.999-999")})

	IF ALLTRIM(SM0->M0_CGC) == "03801629000200" //Condicao colocada por solicitaÁ„o do Guilherme, pois as cobrancas estavam indo para MG e atrasava o pagto. - Sandro 05/06/2015
		AADD(aDADOSEND,{"Local de CobranÁa: " + "AV NACOES UNIDAS, 21.314" + " - "  + "SAO PAULO"             +  " - " + "SP"           + " - CEP: " + "04.795-000"  })
	ELSE
		AADD(aDADOSEND,{"Local de CobranÁa: " + ALLTRIM(SM0->M0_ENDCOB)   + " - " + ALLTRIM(SM0->M0_CIDCOB) + " - "  + SM0->M0_ESTCOB + " - CEP: " + TRANSFORM(SM0->M0_CEPCOB,"@R 99.999-999")})
	ENDIF

//LINHAS HORIZONTAIS
	oPRINT:LINE(391.58,000.00,391.58,nTAMHOR,,"-6")
	oPRINT:LINE(433.64,000.00,433.64,397.55,,"-6")
	oPRINT:LINE(445.69,397.55,445.69,nTAMHOR,,"-6")
	oPRINT:LINE(467.58,000.00,467.58,397.55,,"-6")
	oPRINT:LINE(498.85,397.55,498.85,nTAMHOR,,"-6") // Linha que divide "Impostos" do "Total Geral"
	oPRINT:LINE(525.14,397.55,525.14,nTAMHOR,,"-6") // Linha que divide "Total Geral" dos "Compradores e Aprovadores"
	oPRINT:LINE(573.84,000.00,573.84,nTAMHOR,,"-6") // Linha que divide a "NOTA"

//LINHAS VERTICAIS
	oPRINT:LINE(391.58,397.55,573.84,397.55,,"-6")

//DADOS
	oPRINT:SAY(406.90,018.35,aDADOSEND[1][1],oFONT08)
	oPRINT:SAY(417.47,018.35,aDADOSEND[2][1],oFONT08)

	oPRINT:SAY(410.32,406.23,"Total das Mercadorias: " + TRANSFORM(nTOTMERC,"@E 999,999,999.99"),oFONT11)
	oPRINT:SAY(426.87,406.23,"Total com Impostos: " + TRANSFORM(nTOTMERC + nTOTIPI + nTOTST,"@E 999,999,999.99"),oFONT11)

	oPRINT:SAY(418.60,680.50,"PEDIDO " + IIF(CLIB == "B","BLOQUEADO","LIBERADO"))

	oPRINT:SAY(446.81,018.35,"CondiÁıes de Pagto.: " + ALLTRIM(cCONDPG),oFONT11)
	oPRINT:SAY(459.35,018.35,ALLTRIM(cDESCPG),oFONT11)

	oPRINT:SAY(457.81,406.23,"ICMS:",oFONT10)
	oPRINT:SAY(457.81,471.21,TRANSFORM(nTOTICMS,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(457.81,654.24,"IPI:",oFONT10)
	oPRINT:SAY(457.81,761.62,TRANSFORM(nTOTIPI,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(471.59,406.23,"ST.:",oFONT10)
	oPRINT:SAY(471.59,471.21,TRANSFORM(nTOTST,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(471.59,654.24,"Frete:",oFONT10)
	oPRINT:SAY(471.59,761.62,TRANSFORM(nTOTFRET,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(483.64,406.23,"Seguro:",oFONT10)
	oPRINT:SAY(483.64,471.21,TRANSFORM(nTOTSEGU,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(483.64,654.24,"Despesas:",oFONT10)
	oPRINT:SAY(483.64,761.62,TRANSFORM(nTOTDESP,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(495.64,406.23,"Desconto:",oFONT10)
	oPRINT:SAY(495.64,471.21,TRANSFORM(nTOTDESC,"@E 999,999,999.99"),oFONT10)

	oPRINT:SAY(478.70,018.35,"ObservaÁıes",oFONT10N)
	NLIN := 478.70

	IF VALTYPE(aOBSERV) = "A" .AND. LEN(aOBSERV) > 0

		FOR _nI:= 1 TO LEN(aOBSERV)

			NLIN += 012
			//oPRINT:SAY(NLIN,030.13,ALLTRIM(aOBSERV[I][1]),oFONT09)
			//IMPMEMO(oPrint,_cMEMO,_nTAMANHO,_nLIN,_nCOL,oFnt)
			NLIN := U_IMPMEMO(oPRINT,aOBSERV[_nI][1],35,NLIN,030.13,oFONT09)

		NEXT _nI

	ENDIF

	IF NREG >= 19
		oPRINT:SAY(514.20,406.23,"S U B  -  T O T A L:",oFONT12N)
		NREG := 0
	ELSE
		oPRINT:SAY(514.20,406.23,"T O T A L   G E R A L:",oFONT12N)
	ENDIF

	oPRINT:SAY(514.20,761.62,TRANSFORM(nTOTGERA,"@E 999,999,999.99"))

	PSWORDER(1)
	PSWSEEK(cUSUARIO)
	AINFUSR := PSWRET(NIL)

	oPRINT:SAY(543.60,406.23,"Comprador(a): " + ALLTRIM(AINFUSR[1,4]),oFONT09)

	CQUERY := "SELECT" + CPL
	CQUERY += "	RTRIM(SAL.AL_USER) AS AL_USER" + CPL
	CQUERY += "FROM" + CPL
	CQUERY += "	" + RETSQLNAME("SAL") + " SAL" + CPL
	CQUERY += "WHERE" + CPL
	CQUERY += "	SAL.AL_FILIAL = '" + XFILIAL("SAL") + "' AND" + CPL
	CQUERY += "	SAL.AL_APROV = '" + CAPROVAD + "' AND" + CPL
	CQUERY += "	SAL.D_E_L_E_T_ = ''"

	IF SELECT("_TRB") > 0

		DBSELECTAREA("_TRB")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "_TRB"
	DBSELECTAREA("_TRB")

	CAPROV := _TRB->AL_USER

	CAPROV := POSICIONE("SAK",2,XFILIAL("SAK")+_TRB->AL_USER,"AK_NOME")

	CQUERY := "SELECT TOP(1) " + CPL
	CQUERY += "	RTRIM(SAK.AK_NOME) AS AK_NOME " + CPL
	CQUERY += "FROM" + CPL
	CQUERY += "	" + RETSQLNAME("SCR") + " SCR " + CPL
	CQUERY += "INNER JOIN " + RETSQLNAME("SAK") + " SAK" + CPL
	CQUERY += "	ON SAK.D_E_L_E_T_=''" + CPL
	CQUERY += "	AND AK_FILIAL='" + XFILIAL("SAK") + "' " + CPL
	CQUERY += "	AND AK_COD = CR_LIBAPRO " + CPL
	CQUERY += "WHERE" + CPL
	CQUERY += "	SCR.CR_FILIAL = '" + XFILIAL("SCR") + "' " + CPL
	CQUERY += "	AND SCR.D_E_L_E_T_ = ''" + CPL
	CQUERY += "	AND SCR.CR_LIBAPRO	!=	''" + CPL
	CQUERY += "	AND SCR.CR_VALLIB	!=	0 " + CPL
	CQUERY += "	AND SCR.CR_NUM = '" + cPEDIDO + "' " + CPL
	CQUERY += "ORDER BY CR_DATALIB DESC" + CPL

	MEMOWRITE("COMP001_LISTA_NOMES_AK_APROVADORES.SQL",CQUERY)

	IF SELECT("_TRB") > 0

		DBSELECTAREA("_TRB")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "_TRB"
	DBSELECTAREA("_TRB")

	cAprovadores := ""
	_TRB->(DbGoTop())
	While !_TRB->(Eof())
		If !Empty(cAprovadores)
			cAprovadores += ", "
		EndIf
		cAprovadores += Alltrim(_TRB->AK_NOME)
		_TRB->(DbSkip())
	End

	If !Empty(cAprovadores)
		CAPROV := cAprovadores
	EndIf


	oPRINT:SAY(563.60,406.23,"Aprovador(es): " + ALLTRIM(CAPROV),oFONT09)

	oPRINT:SAY(588.90,183.05,"NOTA: SÛ aceitaremos a mercadoria se na sua Nota Fiscal constar o n˙mero do nosso Pedido de Compra.",oFONT10N)

RETURN(NLIN)

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	IMPLIN
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica para impressao de linhas.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION IMPLIN(NLIN,nTAMHOR,nTAMVER)

	oPRINT:LINE(391.58,046.13,nTAMVER,0186,,"-6")
	oPRINT:LINE(391.58,165.42,nTAMVER,0667,,"-6")
	oPRINT:LINE(391.58,375.48,nTAMVER,1514,,"-6")
	oPRINT:LINE(391.58,397.55,nTAMVER,1603,,"-6")
	oPRINT:LINE(391.58,482.86,nTAMVER,1947,,"-6")
	oPRINT:LINE(391.58,574.87,nTAMVER,2318,,"-6")
	oPRINT:LINE(391.58,654.24,nTAMVER,2638,,"-6")
	oPRINT:LINE(391.58,761.62,nTAMVER,3071,,"-6")



RETURN(NLIN)

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao:	COMP001 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que imprime os itens do Pedido de Compras (Detalhes). 
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION IMPDET(NLIN,nTAMHOR,nTAMVER)

	oPRINT:SAY(NLIN,006.50,TRB->C7_CC,oFONT08) // Centro de Custo
	oPRINT:SAY(NLIN,045.12,TRB->C7_ITEM,oFONT08) // Item
	oPRINT:SAY(NLIN,081.50,ALLTRIM(TRB->C7_PRODUTO),oFONT08) // CÛdigo do Produto
	oPRINT:SAY(NLIN,149.14,SUBSTRING(ALLTRIM(TRB->C7_DESCRI),1,40),oFONT08) // DescriÁ„o do Produto
	oPRINT:SAY(NLIN,358.70,TRB->C7_UM,oFONT08) // Unidade de Medida
	oPRINT:SAY(NLIN,377.53,TRANSFORM(TRB->C7_QUANT,"@E 999,999,999.99"),oFONT08) // Quantidade
	oPRINT:SAY(NLIN,452.58,TRANSFORM(TRB->C7_PRECO,"@E 999,999.99999999"),oFONT08) // PreÁo Unit·rio
	oPRINT:SAY(NLIN,530.81,TRANSFORM(TRB->C7_VALIPI,"@E 99,999.99999999"),oFONT08) // IPI
	oPRINT:SAY(NLIN,610.81,TRANSFORM(TRB->C7_ICMSRET,"@E 99,999.99999999"),oFONT08) // ST
	oPRINT:SAY(NLIN,690.71,TRANSFORM(TRB->C7_TOTAL + TRB->C7_VALIPI + TRB->C7_ICMSRET,"@E 999,999,999.99"),oFONT08) // Total
	oPRINT:SAY(NLIN,765.50,DTOC(STOD(TRB->C7_DATPRF)),oFONT08) // Data de Entrega
	oPRINT:SAY(NLIN,820.00,TRB->C7_NUMSC,oFONT08) // SC

	NLIN += 012
	nREG +=	01

RETURN(NLIN)

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	1ENVMAIL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que apresenta Tela para envio de Email com o Anexo do Pedido
|| 	de Compra em PDF.
||
=================================================================================
=================================================================================
*/

USER FUNCTION 1ENVMAIL(cANEXO,CEMAIL)

	PRIVATE CSERVER		:=	GETMV("MV_RELSERV")
	PRIVATE CACCOUNT		:=	GETMV("MV_RELACNT")
	PRIVATE CENVIA			:=	GETMV("MV_RELFROM")
	PRIVATE CPASSWORD 	:= 	GETMV("MV_RELAPSW")
	PRIVATE CDESTINO		:= 	SPACE(100)
	PRIVATE CASSUNTO		:= 	SPACE(100)
	PRIVATE CMENSAGE		:= 	""

	SETPRVT("OFONT1","OFONT2","OFONT3","ODLG1","OSAY1","OSAY2","OSAY3","OGET1","OGET2","OMGET","OBTN1","OBTN2")

	CDESTINO	:= IIF(EMPTY(CEMAIL),SPACE(100),CEMAIL)
	CASSUNTO 	:= "Envio de Pedido de Compra"
	CMENSAGE 	:= CHR(13) + CHR(10) + ALLTRIM(SM0->M0_NOMECOM) + CHR(13) + CHR(10) +"grp_compras@taiff.com.br"

	OFONT1     	:= TFONT():NEW( "ARIAL ROUNDED MT BOLD",0,-15,,.F.,0,,400,.F.,.F.,,,,,, )
	OFONT2     	:= TFONT():NEW( "ARIAL NARROW",0,-15,,.F.,0,,400,.F.,.F.,,,,,, )
	OFONT3     	:= TFONT():NEW( "COMIC SANS MS",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	ODLG1      	:= MSDIALOG():NEW( 091,232,388,667,"ENVIAR EMAIL",,,.F.,,,,,,.T.,,,.T. )
	OSAY1      	:= TSAY():NEW( 004,004,{||"Destinat·rio"},ODLG1,,OFONT1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,070,008)
	OSAY2      	:= TSAY():NEW( 032,004,{||"Assunto"},ODLG1,,OFONT1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,042,008)
	OSAY3      	:= TSAY():NEW( 060,004,{||"Mensagem"},ODLG1,,OFONT1,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,054,008)
	OGET1      	:= TGET():NEW( 016,004,{|U|IF(PCOUNT()>0,CDESTINO:=U,CDESTINO)},ODLG1,204,012,'',,CLR_BLACK,CLR_WHITE,OFONT2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	OGET2      	:= TGET():NEW( 044,004,{|U|IF(PCOUNT()>0,CASSUNTO:=U,CASSUNTO)},ODLG1,204,012,'',,CLR_BLACK,CLR_WHITE,OFONT2,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	OMGET      	:= TMULTIGET():NEW( 072,004,{|U|IF(PCOUNT()>0,CMENSAGE:=U,CMENSAGE)},ODLG1,204,048,OFONT2,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	OBTN1      	:= TBUTTON():NEW( 124,132,"Ok",ODLG1,{||ENVIANDO(CDESTINO,CASSUNTO,CMENSAGE,CANEXO,CSERVER,CACCOUNT,CPASSWORD,CENVIA)},037,012,,OFONT3,,.T.,,"",,,,.F. )
	OBTN2      	:= TBUTTON():NEW( 124,172,"Cancelar",ODLG1,{||ODLG1:END()},037,012,,OFONT3,,.T.,,"",,,,.F. )

	ODLG1:ACTIVATE(,,,.T.)

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	ENVIAANEXO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que realiza o processo de Envio do Email com o Anexo.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVIAANEXO(CACCOUNT,CPASSWORD,CENVIA,CDESTINO,CASSUNTO,CMENSAGE,CANEXO)

	PRIVATE LENVIADO := .F.
	PRIVATE CMSGERRO := ""


	IF GETMV("MV_RELAUTH")

		LOK := MAILAUTH(CACCOUNT,CPASSWORD)

		IF !LOK

			ALERT("NAO FOI POSSIVEL AUTENTICAR NO SERVIDOR DE EMAIL!")
			RETURN

		ENDIF

	ENDIF

	SEND MAIL FROM CENVIA TO ALLTRIM(CDESTINO) SUBJECT CASSUNTO BODY CMENSAGE;
		ATTACHMENT CANEXO RESULT LENVIADO

	IF LENVIADO

		MSGBOX("MENSAGEM ENVIADA COM SUCESSO!!!")

	ELSE

		CMSGERRO := " "
		GET MAIL ERROR CMSGERRO
		IIF(!EMPTY(CMSGERRO),ALERT(CMSGERRO),)

	ENDIF

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao: 	CONECTASERV
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que realiza o Processo de Conexao com o Servidor de 
|| 	Email.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION CONECTASERV(CSERVER,CACCOUNT,CPASSWORD,LCONECTOU)

//CONECTA COM O SERVIDOR DE E-MAIL
	CONNECT SMTP SERVER CSERVER ACCOUNT CACCOUNT PASSWORD CPASSWORD RESULT LCONECTOU

	IF !LCONECTOU

		ALERT ("ERRO NA CONECÁ„O COM SERVIDOR " + CSERVER)

	ENDIF

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	COMP001.PRW
=================================================================================
||   Funcao:	ENVIANDO 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao Estatica que realiza o controle de todos os processos de Envio 
|| 	de Email.
|| 
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVIANDO(CDESTINO,CASSUNTO,CMENSAGE,CANEXO,CSERVER,CACCOUNT,CPASSWORD,CENVIA)

	PRIVATE LCONECTOU 	:= .F.
	PRIVATE LDISCONECTOU	:= .F.
	PRIVATE LEND			:= .F.

	IF "@" $ (ALLTRIM(CDESTINO))
	ELSE
		ALERT("ENDERECO DE ENVIO INV·LIDO!")
		RETURN
	ENDIF

//PROCESSO PARA CONECTAR NO SERVIDOR DE E-MAIL
	LEND   := .F.
	BBLOCO := { |LEND| CONECTASERV(CSERVER,CACCOUNT,CPASSWORD,LCONECTOU) }
	MSAGUARDE(BBLOCO,"AGUARDE","CONECTANDO NO SERVIDOR DE E-MAIL...",.F.)

	LEND   := .F.
	BBLOCO := { |LEND| ENVIAANEXO(CACCOUNT,CPASSWORD,CENVIA,CDESTINO,CASSUNTO,CMENSAGE,CANEXO) }
	MSAGUARDE(BBLOCO,"AGUARDE","ENVIANDO O E-MAIL...",.F.)

//PROCESSO PARA DESCONCTAR DO SERVIDOR DE E-MAIL
	IF LCONECTOU
		DISCONNECT SMTP SERVER RESULT LDISCONECTOU
		IF !LDISCONECTOU
			ALERT ("ERRO AO DISCONECTAR DO SERVIDOR DE E-MAIL - " + CSERVER)
		ENDIF
	ENDIF

RETURN
