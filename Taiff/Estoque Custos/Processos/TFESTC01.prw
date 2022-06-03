#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE ENTER CHR(13) + CHR(10) //CARACTER DE FIM DE LINHA

/*
=================================================================================
=================================================================================
||   Arquivo:	TFESTC01.PRW
=================================================================================
||   Funcao: 	TFESTC01
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Tela de Consulta de Rastreabilidade onde eh informado o Numero de 
||	Serie do Produto. Com isso eh retornado as informacoes de OP e componentes
|| 	com controle de Rastro que fazem parte deste pproduto especifico. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	29/10/2014
=================================================================================
=================================================================================
*/

USER FUNCTION TFESTC01()

/*
|---------------------------------------------------------------------------------
|	VARIAVEIS PARA DESENVOLVIMENTO DE LAYOUT DE TELA 
|---------------------------------------------------------------------------------
*/
/*
DADOS DO ARRAY ATELA

1 -> Linha inicial área trabalho.
2 -> Coluna inicial área trabalho.
3 -> Linha final área trabalho.
4 -> Coluna final área trabalho.
5 -> Coluna final dialog (janela).
6 -> Linha final dialog (janela).
7 -> Linha inicial dialog (janela).
*/
LOCAL ATELA 		:= MSADVSIZE(.F.,.F.)							// Obtem as informacoes da area de trabalho inicial. (Tela do Protheus)
LOCAL AOBJECTS		:= {}											// Array com os Obejtos que serao criados na Janela DIALOG
LOCAL APOSOBJS		:= {}											// Array com posicionamento dos Objetos
LOCAL AINFO			:= {} 											// Dados da Area de Trabalho e Separacao dos Objetos

/*
|---------------------------------------------------------------------------------
|	VARIAVEIS REFERENTE OS OBJETOS DA TELA 
|---------------------------------------------------------------------------------
*/
PRIVATE OFONT01														// Fonte
PRIVATE OFONT02														// Fonte
PRIVATE OFONT03														// Fonte
PRIVATE ODLG														// Tela de Dialogo (Principal)
PRIVATE OGROUP01													// Primeiro Grupo onde sera informado o Numero de Serie e onde estarao as informacoes sobre OP
PRIVATE OGROUP02													// Segundo Grupo onde estara a Grid com os Componentes
PRIVATE	OSAYNSER													// "Numero de Serie"
PRIVATE OSAYOP														// "Numero da Ordem de Producao"
PRIVATE OSAYEMIS													// "Data Emissao"
PRIVATE OSAYPROD													// "Produto Acabado"
PRIVATE OSAYLOTE													// "Lote Produto Acabado"
PRIVATE OSAYCOP														// Informacao com o Numero da OP
PRIVATE OSAYCEMIS													// Informacao com a Emissao da OP
PRIVATE OSAYCPROD													// Informacao com o Produto Acabado
PRIVATE OSAYCLOTE													// Informacao com o Lote do Produto Acabado
PRIVATE OGETNSER													// Get que recebera o Numero de Serie para Pesquisa
PRIVATE OBTNFIND													// Botao para Pesquisa
PRIVATE OBTNOUT														// Botao para Sair (Fechar) da Tela
PRIVATE OBRWCOMP													// Grid com os Componentes que tem controle de Rastro referentes ao Produto Pesquisado

/*
|---------------------------------------------------------------------------------
|	VARIAVEIS COM CONTEUDOS PARA ATUALIZACAO DOS OBJETOS EM TELA
|---------------------------------------------------------------------------------
*/
PRIVATE CTITULO			:= "CONSULTA DE RASTREABILIDADE - NUMERO DE SERIE" // Titulo da Janela Principal
PRIVATE COP 			:= SPACE(0011)								// Numero da Ordem de Producao
PRIVATE CEMIS			:= SPACE(0008)								// Data da Emissao da OP
PRIVATE CPROD			:= SPACE(0062)								// Codigo e Descricao do Produto
PRIVATE CNSER			:= SPACE(0020)								// Numero de Serie do Produto
PRIVATE CLOTE			:= SPACE(0010)								// Lote do Produto Acabado
PRIVATE AHEADER			:= {}
PRIVATE ACOLS			:= {}
PRIVATE AALTER			:= {}

PRIVATE AROTINA 		:= {	{"PESQUISAR" , "AXPESQUI" , 0, 1},;					
								{"VISUALIZAR", "AXVISUAL" , 0, 2},;					
								{"INCLUIR"   , "AXINCLUI" , 0, 3}}

/*
|---------------------------------------------------------------------------------
|	VARIAVEIS DE TRABALHO
|---------------------------------------------------------------------------------
*/
PRIVATE CQUERY 			:= ""

/*
|---------------------------------------------------------------------------------
|	DEFININDO O AHEADER DO MSNEWGETDADOS
|---------------------------------------------------------------------------------
*/
/*01*/AADD(AHEADER,{"Codigo"		,"D4_COD"		,"@!"							,15	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D4_COD"		,"X3_USADO"),"C",POSICIONE("SX3",2,"D4_COD"		,"X3_F3"),POSICIONE("SX3",2,"D4_COD"		,"X3_CONTEXT"),POSICIONE("SX3",2,"D4_COD"		,"X3_CBOX"),POSICIONE("SX3",2,"D4_COD"		,"X3_RELACAO")})
/*02*/AADD(AHEADER,{"Descriçao"		,"B1_DESC"		,"@!"							,62	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"B1_DESC"	,"X3_USADO"),"C",POSICIONE("SX3",2,"B1_DESC"	,"X3_F3"),POSICIONE("SX3",2,"B1_DESC"		,"X3_CONTEXT"),POSICIONE("SX3",2,"B1_DESC"		,"X3_CBOX"),POSICIONE("SX3",2,"B1_DESC"		,"X3_RELACAO")})
/*03*/AADD(AHEADER,{"Quantidade"	,"D4_QTDEORI"	,"@E 999,999,999.99"			,12	,02		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D4_QTDEORI"	,"X3_USADO"),"N",POSICIONE("SX3",2,"D4_QTDEORI"	,"X3_F3"),POSICIONE("SX3",2,"D4_QTDEORI"	,"X3_CONTEXT"),POSICIONE("SX3",2,"D4_QTDEORI"	,"X3_CBOX"),POSICIONE("SX3",2,"D4_QTDEORI"	,"X3_RELACAO")})
/*04*/AADD(AHEADER,{"Lote"			,"D4_LOTECTL"	,"@!"							,10	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D4_LOTECTL"	,"X3_USADO"),"C",POSICIONE("SX3",2,"D4_LOTECTL"	,"X3_F3"),POSICIONE("SX3",2,"D4_LOTECTL"	,"X3_CONTEXT"),POSICIONE("SX3",2,"D4_LOTECTL"	,"X3_CBOX"),POSICIONE("SX3",2,"D4_LOTECTL"	,"X3_RELACAO")})
/*05*/AADD(AHEADER,{"Fornecedor"	,"D1_FORNECE"	,"@!"							,09	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D1_FORNECE"	,"X3_USADO"),"C",POSICIONE("SX3",2,"D1_FORNECE"	,"X3_F3"),POSICIONE("SX3",2,"D1_FORNECE"	,"X3_CONTEXT"),POSICIONE("SX3",2,"D1_FORNECE"	,"X3_CBOX"),POSICIONE("SX3",2,"D1_FORNECE"	,"X3_RELACAO")})
/*06*/AADD(AHEADER,{"Razao Social"	,"A2_NOME"		,"@!"							,50	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"A2_NOME"	,"X3_USADO"),"C",POSICIONE("SX3",2,"A2_NOME"	,"X3_F3"),POSICIONE("SX3",2,"A2_NOME"		,"X3_CONTEXT"),POSICIONE("SX3",2,"A2_NOME"		,"X3_CBOX"),POSICIONE("SX3",2,"A2_NOME"		,"X3_RELACAO")})
/*07*/AADD(AHEADER,{"Nota Fiscal"	,"D1_DOC"		,"@!"							,13	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D1_DOC"		,"X3_USADO"),"C",POSICIONE("SX3",2,"D1_DOC"		,"X3_F3"),POSICIONE("SX3",2,"D1_DOC"		,"X3_CONTEXT"),POSICIONE("SX3",2,"D1_DOC"		,"X3_CBOX"),POSICIONE("SX3",2,"D1_DOC"		,"X3_RELACAO")})
/*08*/AADD(AHEADER,{"Emissao"		,"D1_EMISSAO"	,"@!"							,08	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D1_EMISSAO"	,"X3_USADO"),"C",POSICIONE("SX3",2,"D1_EMISSAO"	,"X3_F3"),POSICIONE("SX3",2,"D1_EMISSAO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"D1_EMISSAO"	,"X3_CBOX"),POSICIONE("SX3",2,"D1_EMISSAO"	,"X3_RELACAO")})
/*09*/AADD(AHEADER,{"Dt.Digitacao"	,"D1_DTDIGIT"	,"@!"							,08	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"D1_DTDIGIT"	,"X3_USADO"),"C",POSICIONE("SX3",2,"D1_DTDIGIT"	,"X3_F3"),POSICIONE("SX3",2,"D1_DTDIGIT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"D1_DTDIGIT"	,"X3_CBOX"),POSICIONE("SX3",2,"D1_DTDIGIT"	,"X3_RELACAO")})

AADD(ACOLS,ARRAY(10))
ACOLS[001,010] := .F.

/*
|---------------------------------------------------------------------------------
|	PASSO AS DEFINICOES DOS OBJETOS TGROUP (SERAO DOIS) PARA CALCULO DE 
|	DIMENSIONAMENTO E POSICIONAMENTO.
|---------------------------------------------------------------------------------
*/
AADD(AOBJECTS	,	{	0300,	0100,	.T.,	.F.}) 				// Primeiro TGroup onde o tamanho Y (Vertical) nao sofrera alteracoes
AADD(AOBJECTS	,	{	0500,	0500,	.T.,	.T.}) 				// Segundo TGroup onde sera totalmente redimensionado

AINFO 			:= {	ATELA[1],	ATELA[2],	ATELA[3],	ATELA[4],	0005,	0005,	0005,	0005}
APOSOBJS		:= MSOBJSIZE(	AINFO,	AOBJECTS,	.T.,	.F.)

/*
|---------------------------------------------------------------------------------
|	DEFINICOES DOS FONTES QUE SERA UTILIZADOS
|---------------------------------------------------------------------------------
*/
OFONT01			:= TFONT():NEW("COURIER NEW",,-14,.T.)					// Fonte Courier New 14 Negrito
OFONT02			:= TFONT():NEW("COURIER NEW",,-13,.F.)					// Fonte Courier New 13
OFONT03			:= TFONT():NEW("COURIER NEW",,-12,.F.)					// Fonte Courier New 12

/*
|---------------------------------------------------------------------------------
|	CONTRUCAO DA TELA
|---------------------------------------------------------------------------------
*/
DEFINE MSDIALOG ODLG TITLE CTITULO FROM ATELA[7], 0000 TO ATELA[6], ATELA[5] OF OMAINWND PIXEL

OGROUP01 		:= TGROUP():NEW(	APOSOBJS[0001,0001],	APOSOBJS[0001,0002],	APOSOBJS[0001,0003], 	APOSOBJS[0001,0004],	'Informações do Produto'				,	ODLG,,,.T.) 
OGROUP02 		:= TGROUP():NEW(	APOSOBJS[0002,0001],	APOSOBJS[0002,0002],	APOSOBJS[0002,0003], 	APOSOBJS[0002,0004],	'Informações dos Componentes com Rastro',	ODLG,,,.T.)
OGROUP01:OFONT 	:= OFONT01
OGROUP02:OFONT 	:= OFONT01

/*
|---------------------------------------------------------------------------------
|	DEFINICOES PARA OBJETOS QUE ESTAO DENTRO DO PRIMEIRO TGROUP
|	LEMBRANDO QUE OS OBJETOS NAO OBEDECEM O POSICIONAMENTO DO TGROUP E SIM DA
|	JANELA DIALOG
|---------------------------------------------------------------------------------
*/
OSAYNSER		:= TSAY():NEW(	0020,	0020,	{|| 'Número de Série:'},	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLACK,	CLR_WHITE,	0080, 0010)
OGETNSER		:= TGET():NEW(	0020,	0100,	{|U| IF(PCOUNT()>0,CNSER:=U,CNSER)}, 	OGROUP01,	0200,	0010,"@!",,0		,		,OFONT02,,,.T.,,,,,,,,,,'CNSER')				   
OBTNFIND		:= TBUTTON():NEW(	0020,	0305,	'Pesquisar'	,	OGROUP01,	{|| DADOSNSER(CNSER,OBRWCOMP)},	0050,	0010,,	OFONT02,,	.T.)
OBTNOUT			:= TBUTTON():NEW(	0020,	0365,	'Sair'		,	OGROUP01,	{|| ODLG:END()}				,	0050,	0010,,	OFONT02,,	.T.)
//--------------------------------------------------------------------------------
OSAYOP			:= TSAY():NEW(	0040,	0020,	{|| 'Ordem de Produção:'},	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLACK,	CLR_WHITE,	0080, 0010)
OSAYCOP			:= TSAY():NEW(	0040,	0100,	{|| COP}				,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLUE,	CLR_HGRAY,	0200, 0010)
OSAYCOP:LTRANSPARENT 	:= .F.
OSAYEMIS		:= TSAY():NEW(	0040,	0305,	{|| 'Emissão:'}			,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLACK,	CLR_WHITE,	0080, 0010)
OSAYCEMIS		:= TSAY():NEW(	0040,	0340,	{|| CEMIS}				,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLUE,	CLR_HGRAY,	0080, 0010)
OSAYCEMIS:LTRANSPARENT 	:= .F.
//--------------------------------------------------------------------------------
OSAYPROD		:= TSAY():NEW(	0060,	0020,	{|| 'Produto:'}			,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLACK,	CLR_WHITE,	0080, 0010)
OSAYCPROD		:= TSAY():NEW(	0060,	0100,	{|| CPROD}				,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLUE,	CLR_HGRAY,	0400, 0010)
OSAYCPROD:LTRANSPARENT	:= .F.
//--------------------------------------------------------------------------------
OSAYLOTE		:= TSAY():NEW(	0080,	0020,	{|| 'Lote:'}			,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLACK,	CLR_WHITE,	0080, 0010)
OSAYCLOTE		:= TSAY():NEW(	0080,	0100,	{|| CLOTE}				,	OGROUP01,,	OFONT02,,,,	.T.,	CLR_BLUE,	CLR_HGRAY,	0200, 0010)
OSAYCLOTE:LTRANSPARENT	:= .F.

/*
|---------------------------------------------------------------------------------
|	CRIACAO DE TBROWSE NO SEGUNDO GRUPO
|---------------------------------------------------------------------------------
*/
OBRWCOMP		:= MSNEWGETDADOS():NEW(	APOSOBJS[0002,0001] + 10	, APOSOBJS[0002,0002] + 10	, APOSOBJS[0002,0003] - 10	, APOSOBJS[0002,0004] - 10	, 2			,;
										"ALLWAYSTRUE"				, "ALLWAYSTRUE"				, ""						, AALTER					, 000		,;
										999							, "ALLWAYSTRUE"				, "ALLWAYSFALSE"			, "ALLWAYSFALSE"			, OGROUP02	,;
										AHEADER						, ACOLS)
										
ACTIVATE MSDIALOG ODLG CENTERED

RETURN

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

STATIC FUNCTION DADOSNSER(CNSER,OGRID)

LOCAL NQTDCAB 	:= 0
LOCAL NQTDITM	:= 0

CURSORWAIT()

OGRID:ACOLS := {}

IF SELECT("CAB") > 0 
	
	DBSELECTAREA("CAB")
	DBCLOSEAREA()
	
ENDIF

IF SELECT("ITM") > 0 
	
	DBSELECTAREA("ITM")
	DBCLOSEAREA()
	
ENDIF


CQUERY := "SELECT" 																				+ ENTER
CQUERY += "	RTRIM(ZA4.ZA4_NUMOP) + RTRIM(ZA4.ZA4_OPITEM) + RTRIM(ZA4.ZA4_OPSEQ) AS ZA4_NUMOP," 	+ ENTER
CQUERY += "	SC2.C2_EMISSAO," 																	+ ENTER
CQUERY += "	RTRIM(ZA4.ZA4_COD) + ' - ' + RTRIM(SB1.B1_DESC) AS B1_DESC," 						+ ENTER
CQUERY += "	ZA4.ZA4_NLOTE" 																		+ ENTER
CQUERY += "FROM" 																				+ ENTER
CQUERY += "	" + RETSQLNAME("ZA4") + " ZA4" 														+ ENTER
CQUERY += "		INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 									+ ENTER 
CQUERY += "			SB1.B1_FILIAL	= '" + XFILIAL("SB1") + "' AND" 							+ ENTER 
CQUERY += "			SB1.B1_COD		= ZA4.ZA4_COD AND" 											+ ENTER
CQUERY += "			SB1.D_E_L_E_T_	= ''" 														+ ENTER
CQUERY += "		INNER JOIN " + RETSQLNAME("SC2") + " SC2 ON" 									+ ENTER 
CQUERY += "			SC2.C2_FILIAL	= '" + XFILIAL("SC2") + "' AND" 							+ ENTER 
CQUERY += "			SC2.C2_NUM		= ZA4.ZA4_NUMOP AND" 										+ ENTER 
CQUERY += "			SC2.D_E_L_E_T_	= ''" 														+ ENTER
CQUERY += "WHERE" 																				+ ENTER 
CQUERY += "	ZA4.ZA4_FILIAL	= '" + XFILIAL("ZA4") + "' AND" 									+ ENTER 
CQUERY += "	ZA4.ZA4_NUMSER	= '" + CNSER + "' AND" 												+ ENTER 
CQUERY += "	ZA4.ZA4_DESTIN	= '' AND" 															+ ENTER
CQUERY += "	ZA4.D_E_L_E_T_	= ''"

MEMOWRITE(GETTEMPPATH() + "\TFESTC01_QRY01.SQL",CQUERY)

TCQUERY CQUERY NEW ALIAS "CAB"
DBSELECTAREA("CAB")
COUNT TO NQTDCAB
DBGOTOP()

IF NQTDCAB <= 0 
	
	MSGALERT("Número de Série informado não foi encontrado!")
	RETURN()
	
ENDIF 

CQUERY := "SELECT" 																	+ ENTER
CQUERY += "	SD4.D4_COD," 															+ ENTER
CQUERY += "	SB1.B1_DESC," 															+ ENTER
CQUERY += "	SD4.D4_QTDEORI," 														+ ENTER
CQUERY += "	SD4.D4_LOTECTL," 														+ ENTER
CQUERY += "	ISNULL(SD1.D1_FORNECE,'') AS D1_FORNECE," 								+ ENTER
CQUERY += "	ISNULL((SELECT RTRIM(A2_NOME) FROM " + RETSQLNAME("SA2") + " SA2 WHERE SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND SA2.A2_COD = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA AND SA2.D_E_L_E_T_ = ''),'') AS A2_NOME," + ENTER
CQUERY += "	ISNULL(RTRIM(SD1.D1_DOC) + '/' + RTRIM(SD1.D1_SERIE),'') AS D1_DOC," 	+ ENTER
CQUERY += "	ISNULL(SD1.D1_EMISSAO,'') AS D1_EMISSAO,"								+ ENTER
CQUERY += "	ISNULL(SD1.D1_DTDIGIT,'') AS D1_DTDIGIT" 								+ ENTER
CQUERY += "FROM" 																	+ ENTER 
CQUERY += "	" + RETSQLNAME("SD4") + " SD4"											+ ENTER
CQUERY += "		INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 						+ ENTER 
CQUERY += "			SB1.B1_FILIAL	= '" + XFILIAL("SB1") + "' AND" 				+ ENTER 
CQUERY += "			SB1.B1_COD		= SD4.D4_COD AND" 								+ ENTER
CQUERY += "			SB1.B1_RASTRO	= 'L' AND" 										+ ENTER 
CQUERY += "			SB1.D_E_L_E_T_	= ''" 											+ ENTER
CQUERY += "		LEFT OUTER JOIN " + RETSQLNAME("SD1") + " SD1 ON" 					+ ENTER	
CQUERY += "			SD1.D1_FILIAL	= '" + XFILIAL("SD1") + "' AND" 				+ ENTER 
CQUERY += "			SD1.D1_COD		= SD4.D4_COD AND" 								+ ENTER
CQUERY += "			SD1.D1_LOTECTL	= SD4.D4_LOTECTL AND" 							+ ENTER 
CQUERY += "			SD1.D1_LOTECTL	!= '' AND" 										+ ENTER 
CQUERY += "			SD1.D_E_L_E_T_	= ''" 											+ ENTER
CQUERY += "WHERE" 																	+ ENTER 
CQUERY += "	SD4.D4_FILIAL		= '" + XFILIAL("SD4") + "' AND" 					+ ENTER 
CQUERY += "	SD4.D4_OP			= '" + CAB->ZA4_NUMOP + "' AND" 					+ ENTER 
CQUERY += "	SD4.D4_LOTECTL	!= '' AND" 												+ ENTER 
CQUERY += "	SD4.D_E_L_E_T_ = ''"

MEMOWRITE(GETTEMPPATH() + "\TFESTC01_QRY02.SQL",CQUERY)

TCQUERY CQUERY NEW ALIAS "ITM"
DBSELECTAREA("ITM")
COUNT TO NQTDITM
DBGOTOP()

IF NQTDITM <= 0 
	
	MSGALERT("Não existem componentes com Controle de Rastro!")
	RETURN()
	
ENDIF  

WHILE ITM->(!EOF())
	
	AADD(OGRID:ACOLS,{ITM->D4_COD,ITM->B1_DESC,ITM->D4_QTDEORI,ITM->D4_LOTECTL,ITM->D1_FORNECE,ITM->A2_NOME,ITM->D1_DOC,DTOC(STOD(ITM->D1_EMISSAO)),DTOC(STOD(ITM->D1_DTDIGIT)),.F.})
	ITM->(DBSKIP())

ENDDO 

OSAYCOP:SETTEXT(CAB->ZA4_NUMOP)
OSAYCOP:CTRLREFRESH()
OSAYCEMIS:SETTEXT(DTOC(STOD(CAB->C2_EMISSAO)))
OSAYCEMIS:CTRLREFRESH()
OSAYCPROD:SETTEXT(CAB->B1_DESC)
OSAYCPROD:CTRLREFRESH()
OSAYCLOTE:SETTEXT(CAB->ZA4_NLOTE)
OSAYCLOTE:CTRLREFRESH()
OGRID:OBROWSE:REFRESH()
OGRID:REFRESH()

CURSORARROW()

RETURN()