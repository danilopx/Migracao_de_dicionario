#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'

#DEFINE PL CHR(13) + CHR(10)
/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMR01.PRW
=================================================================================
||   Funcao: 	TFCOMR01
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Planilha Excel para analise de dados das Notas Fiscais de Entrada.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	16/04/2014
=================================================================================
=================================================================================
*/

USER FUNCTION TFCOMR01()

LOCAL 		CSQL		:= ""
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT		:= {}
LOCAL 		OEXCEL 		:= FWMSEXCEL():NEW()
LOCAL 		OEXCELAPP
LOCAL 		CTITSHEET	:= "Notas Fiscais de Entrada"
LOCAL 		CTITTABLE	:= "Notas Fiscais de Entrada"
LOCAL		CARQ
LOCAL		CPERG		:= PADL("TFCOMR01",10)
LOCAL		APERG		:= {}

/*01*/AADD(APERG,{"Data de:"		,"D",08,00,"G","","","","","","",""})
/*02*/AADD(APERG,{"Data ate:"		,"D",08,00,"G","","","","","","",""})
/*03*/AADD(APERG,{"Produto de:"		,"C",15,00,"G","","","","","","","SB1"})
/*04*/AADD(APERG,{"Produto ate:"	,"C",15,00,"G","","","","","","","SB1"})
/*05*/AADD(APERG,{"TES de:"			,"C",03,00,"C","","","","","","","SF4"})	
/*06*/AADD(APERG,{"TES ate:"		,"C",03,00,"C","","","","","","","SF4"})

U_GERAPERG(CPERG,APERG)

IF !PERGUNTE(CPERG,.T.)
	
	MSGALERT(OEMTOANSI("Operação Cancelada pelo Usuário"),"Notas Fiscais de Entrada")
	RETURN()
	
ENDIF

IF .NOT.( APOLECLIENT("MSEXCEL") )
	ALERT("Aplicativo MS Office Excel não está instalado!")
	BREAK
ENDIF

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#000000")
OEXCEL:SETTITLEBGCOLOR("#778899")
OEXCEL:SETLINESIZEFONT(12)
OEXCEL:SET2LINESIZEFONT(12)

IF SELECT("TRBEXC") > 0 
	
	DBSELECTAREA("TRBEXC")
	DBCLOSEAREA()
	
ENDIF 

CSQL := "SELECT" 																						+ PL
CSQL += "	'" + ALLTRIM(SM0->M0_NOME) + "'				AS 'EMPRESA'," 									+ PL
CSQL += "	'" + ALLTRIM(SM0->M0_FILIAL) + "'			AS 'FILIAL'," 									+ PL						
CSQL += "	SD1.D1_DOC					AS 'NUMERO_NF'," 												+ PL
CSQL += "	SD1.D1_SERIE				AS 'SERIE_NF'," 												+ PL
CSQL += "	SF1.F1_ESPECIE				AS 'TIPO_NF',"													+ PL
CSQL += "	SD1.D1_EMISSAO				AS 'EMISSAO'," 													+ PL
CSQL += "	SUM(SD1.D1_TOTAL)			AS 'TOTAL'," 													+ PL
CSQL += "	SD1.D1_CONTA				AS 'CTA_CONTABIL'," 											+ PL
CSQL += "	SD1.D1_ITEMCTA				AS 'UNID_NEGOCIO'," 											+ PL
CSQL += "	SD1.D1_FORNECE				AS 'COD_FORNECEDOR'," 											+ PL
CSQL += "	SD1.D1_LOJA					AS 'LOJA_FORNECEDOR',"	 										+ PL
CSQL += "	SA2.A2_NOME					AS 'RAZAO_SOCIAL'" 												+ PL
CSQL += "FROM" 																							+ PL
CSQL += "	" + RETSQLNAME("SD1") + " SD1" 																+ PL
CSQL += "		INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 											+ PL 
CSQL += "			SA2.A2_FILIAL	= '" + XFILIAL("SA2") + "' 	AND" 									+ PL
CSQL += "			SA2.A2_COD		= SD1.D1_FORNECE 			AND" 									+ PL 
CSQL += "			SA2.A2_LOJA		= SD1.D1_LOJA 				AND" 									+ PL 
CSQL += "			SA2.D_E_L_E_T_	= ''" 																+ PL
CSQL += "		INNER JOIN " + RETSQLNAME("SF1") + " SF1 ON" 											+ PL 
CSQL += "			SF1.F1_FILIAL	= '" + XFILIAL("SF1") + "' 	AND" 									+ PL 
CSQL += "			SF1.F1_DOC		= SD1.D1_DOC 				AND" 									+ PL 
CSQL += "			SF1.F1_SERIE	= SD1.D1_SERIE 				AND" 									+ PL 
CSQL += "			SF1.F1_FORNECE	= SD1.D1_FORNECE 			AND" 									+ PL 
CSQL += "			SF1.F1_LOJA		= SD1.D1_LOJA 				AND" 									+ PL
CSQL += "			SF1.D_E_L_E_T_	= ''" 																+ PL
CSQL += "WHERE" 																						+ PL 
CSQL += "	SD1.D1_FILIAL	= '" + XFILIAL("SD1") + "'											AND" 	+ PL 
CSQL += "	SD1.D1_EMISSAO	BETWEEN '" + DTOS(MV_PAR01) + "'	AND '" + DTOS(MV_PAR02) + "'	AND" 	+ PL 
CSQL += "	SD1.D1_COD		BETWEEN '" + MV_PAR03 + "'			AND '" + MV_PAR04 + "'			AND" 	+ PL 
CSQL += "	SD1.D1_TES		BETWEEN '" + MV_PAR05 + "'			AND '" + MV_PAR06 + "'			AND" 	+ PL 
CSQL += "	SD1.D_E_L_E_T_	= ''" 																		+ PL
CSQL += "GROUP BY" 																						+ PL
CSQL += "	SD1.D1_FILIAL," 																			+ PL
CSQL += "	SD1.D1_DOC," 																				+ PL
CSQL += "	SD1.D1_SERIE," 																				+ PL
CSQL += "	SF1.F1_ESPECIE," 																			+ PL
CSQL += "	SD1.D1_EMISSAO," 																			+ PL
CSQL += "	SD1.D1_FORNECE," 																			+ PL
CSQL += "	SD1.D1_LOJA," 																				+ PL
CSQL += "	SA2.A2_NOME," 																				+ PL
CSQL += "	SD1.D1_CONTA," 																				+ PL
CSQL += "	SD1.D1_ITEMCTA" 																			+ PL
CSQL += "ORDER BY" 																						+ PL 
CSQL += "	SD1.D1_FILIAL," 																			+ PL
CSQL += "	SD1.D1_DOC," 																				+ PL
CSQL += "	SD1.D1_SERIE," 																				+ PL
CSQL += "	SF1.F1_ESPECIE," 																			+ PL
CSQL += "	SD1.D1_EMISSAO," 																			+ PL
CSQL += "	SD1.D1_FORNECE," 																			+ PL
CSQL += "	SD1.D1_LOJA"

TCQUERY CSQL NEW ALIAS "TRBEXC"
TCSETFIELD("TRBEXC","EMISSAO","D")

DBSELECTAREA("TRBEXC")

ASTRUCT := DBSTRUCT()

FOR NX := 1 TO FCOUNT()
	
	DO CASE
		CASE ASTRUCT[NX,02] = "C"  
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,1)
		CASE ASTRUCT[NX,02] = "N"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,2)
		CASE ASTRUCT[NX,02] = "D"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,4)
	ENDCASE 
	
NEXT NX

WHILE TRBEXC->(!EOF()) 
	
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 1 TO FCOUNT()
	
		AADD(AITENS,&("TRBEXC->" + FIELDNAME(NX)))
		
	NEXT NX  
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
	
	TRBEXC->(DBSKIP())
	
ENDDO

OEXCEL:ACTIVATE()
CARQ := CRIATRAB( NIL, .F. ) + ".XML"
LJMSGRUN( "GERANDO O ARQUIVO, AGUARDE...", CTITTABLE, {|| OEXCEL:GETXMLFILE( CARQ ) } )
SLEEP(3000)
IF __COPYFILE( CARQ, "C:\TEMP\" + CARQ )
		OEXCELAPP := MSEXCEL():NEW()
		OEXCELAPP:WORKBOOKS:OPEN( "C:\TEMP\" + CARQ )
		OEXCELAPP:SETVISIBLE(.T.)
		MSGINFO( "ARQUIVO " + CARQ + " GERADO COM SUCESSO NO DIRETÓRIO C:\TEMP" )
		FERASE( CARQ )
ELSE
	MSGINFO( "ARQUIVO NÃO COPIADO PARA TEMPORÁRIO DO USUÁRIO." )
ENDIF

OEXCEL:DEACTIVATE()

RETURN

