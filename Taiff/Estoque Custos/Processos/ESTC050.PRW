#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'

#DEFINE PL CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	ESTC050.PRW
=================================================================================
||   Funcao: 	ESTC050
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que gera Planilha Excel (XML) com informacoes do Estoque 
|| conforme parametrizacao do usuario.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		14/01/2014
=================================================================================
=================================================================================
*/


USER FUNCTION ESTC050()

LOCAL 		CSQL		:= ""
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		OEXCEL 		:= FWMSEXCEL():NEW()
LOCAL 		OEXCELAPP
LOCAL 		CTITSHEET	:= "Analise de Estoques"
LOCAL 		CTITTABLE	:= "Analise de Estoques"
LOCAL		CARQ
LOCAL		CPERG		:= PADL("ESTC050",10)
LOCAL		APERG		:= {}
LOCAL 		CARMAZ		:= ""
LOCAL 		CTEMP		:= ""

/*01*/AADD(APERG,{"Produto de:"			,"C",15,00,"G","","","","","","","SB1"})
/*02*/AADD(APERG,{"Produto ate:"		,"C",15,00,"G","","","","","","","SB1"})
/*03*/AADD(APERG,{"Familia de:"			,"C",03,00,"G","","","","","","","ZA1001"})
/*04*/AADD(APERG,{"Familia ate:"		,"c",03,00,"G","","","","","","","ZA1001"})
/*05*/AADD(APERG,{"Armazem(s):"			,"C",99,00,"C","U_SELARMAZ","","","","","",""})	

U_GERAPERG(CPERG,APERG)

IF !PERGUNTE(CPERG,.T.)
	
	MSGALERT(OEMTOANSI("Operação Cancelada pelo Usuário"),"Análise de Estoques")
	RETURN()
	
ENDIF

CARMAZ 	:= "''"
CTEMP	:= MV_PAR05 

WHILE LEN(CTEMP) > 0
	
	IF SUBSTR(CTEMP,1,2) <> '**'
		CARMAZ += SUBSTR(CTEMP,1,2) + "'',''"
	ENDIF
	CTEMP	:= SUBSTR(CTEMP,3,LEN(CTEMP) - 2)
	
ENDDO

CARMAZ := SUBSTR(CARMAZ,1,LEN(CARMAZ) - 3)

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

CSQL := "EXEC SP_ANALISE_ESTOQUE '" + CEMPANT + "','" + CFILANT + "','" + MV_PAR01 + "','" + MV_PAR02 + "','" + MV_PAR03 + "','" + MV_PAR04 + "','(" + CARMAZ + ")'"
TCQUERY CSQL NEW ALIAS "TRBEXC"
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
		OEXCELAPP:DESTROY()
ELSE
	MSGINFO( "ARQUIVO NÃO COPIADO PARA TEMPORÁRIO DO USUÁRIO." )
ENDIF

OEXCEL:DEACTIVATE()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	ESTC050.PRW
=================================================================================
||   Funcao: 	SELARMAZ
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para que o usuario possa escolher quais armazens entraram na
|| 	Analise da Planilha. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		14/01/2014
=================================================================================
=================================================================================
*/

USER FUNCTION SELARMAZ()

	LOCAL CALIAS		:= ""
	LOCAL MVPAR			:= ""
	LOCAL MVRET			:= ""
	LOCAL CSQL			:= ""
	//LOCAL NX			:= 0 
	PRIVATE AITENS		:= {}
	PRIVATE AESTOQUES 	:= {}

	CALIAS 		:= ALIAS()

	MVPAR		:= &(ALLTRIM(READVAR()))
	MVRET		:= ALLTRIM(READVAR())

	CTITULO 	:= "Seleção dos Armazéns"

	CSQL := "SELECT * FROM TBL_NOME_ARMAZENS ORDER BY ID_ARMAZ"

	IF SELECT("TRBEST") > 0 
		
		DBSELECTAREA("TRBEST")
		DBCLOSEAREA()
		
	ENDIF

	TCQUERY CSQL NEW ALIAS "TRBEST"
	DBSELECTAREA("TRBEST")

	MVPARDEF := ""

	WHILE TRBEST->(!EOF())
		
		AADD(AITENS,ALLTRIM(TRBEST->ID_ARMAZ) + " - " + ALLTRIM(TRBEST->NM_ARMAZ))
		MVPARDEF += ALLTRIM(TRBEST->ID_ARMAZ)
		TRBEST->(DBSKIP())
		
	ENDDO

	MVPARDEF := SUBSTR(MVPARDEF,1,LEN(MVPARDEF)-1)

	AADD(AESTOQUES,AITENS)

	/*
			f_Opcoes(	uVarRet			,;	//Variavel de Retorno
						cTitulo			,;	//Titulo da Coluna com as opcoes
						aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
						cOpcoes			,;	//String de Opcoes para Retorno
						nLin1				,;	//Nao Utilizado
						nCol1				,;	//Nao Utilizado
						l1Elem				,;	//Se a Selecao sera de apenas 1 Elemento por vez
						nTam				,;	//Tamanho da Chave
						nElemRet			,;	//No maximo de elementos na variavel de retorno
						lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
						lComboBox			,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
						cCampo				,;	//Qual o Campo para a Montagem do aOpcoes
						lNotOrdena			,;	//Nao Permite a Ordenacao
						lNotPesq			,;	//Nao Permite a Pesquisa	
						lForceRetArr  	,;	//Forca o Retorno Como Array
						cF3				 	;	//Consulta F3	
					)
	*/

	IF F_OPCOES(@MVPAR,CTITULO,AITENS,MVPARDEF,12,49,.F.,2,49)
		&MVRET := MVPAR
	ENDIF

	DBSELECTAREA(CALIAS)

RETURN(.T.) 
