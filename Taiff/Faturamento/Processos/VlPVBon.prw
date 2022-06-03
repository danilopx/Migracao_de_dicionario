
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VlPVBon  º Autor ³ Marcelo Cardoso    º Data ³  07/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Validacao do Vinculo Pedido Normal vs Pedido Bonificado    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function VlPVBon(_cPedAtu, _cC5PVBon)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lOkPVBon 	:= .T.
Local _cOldAlias 	:= Alias()
Local _aOldAlias 	:= GetArea()
Local _aSC5Alias 	:= SC5->(GetArea())
Local _aSA1Alias 	:= SA1->(GetArea())
Local _cCNPJAtu  	:= ""
Local _cGrpVAtu  	:= ""
Local _cAliasC5  	:= ""      

If SM0->M0_CODIGO + SM0->M0_CODFIL $ GetMV("MV_X_BNFIL")                                              
	IF IsinCallStack("U_IMPSALES")  
		/* Funcionalidade do projeto de validação de bonificação                                 */
		/* Data: 19/08/2020                                         Responsável: Carlos Torres   */
		/* A validação de bonificação quando pedido originado no CRM não será realizada uma vez  */
		/* que os vinculos são gerenciados no próprio CRM, portanto, não haverá nenhuma ação     */
	ELSE
		/*	
		Para atender o projeto CRM está validação foi removida, pois deixou de ter finalidade
		If !EMPTY(ALLTRIM(_cC5PVBon)) .AND. " " $ SubStr(_cC5PVBon, 01, 06)
		
			Aviso("VLPVBON", "Nao utilize espaco em branco no inicio do codigo do Pedido.", {"Ok"})
			_lOkPVBon := .F.
		
		EndIf    
		*/
		
		_cC5PVBon := ALLTRIM(_cC5PVBon)
			
		If INCLUI
			
			_cAliasC5 := "M"
			
		Else
		
			DBSelectArea("SC5")
			DBORDERNICKNAME("SC5NUMOLD")               
			DBSeek(xFilial("SC5") + _cPedAtu)
			_cAliasC5 := "SC5"
		
		EndIf
			
		DBSelectArea("SA1")
		DBSetOrder(1)
		If DBSeek(xFilial("SA1") + &(_cAliasC5+"->C5_CLIENTE") + &(_cAliasC5+"->C5_LOJACLI")  )
		
			_cCNPJAtu  := AllTrim(SA1->A1_CGC)
			_cGrpVAtu  := AllTrim(SA1->A1_GRPVEN)
		
		EndIf
		
		If _cC5PVBon == _cPedAtu
		
			Aviso("VLPVBON", "Informe um numero de Pedido diferente do pedido em edicao.", {"Ok"})
			_lOkPVBon := .F.
			
		EndIf
		
		DBSelectArea("SC5")
		DBORDERNICKNAME("SC5NUMOLD")               
		If DBSeek('02' + _cC5PVBon)
		
			IF !(ALLTRIM(SC5->C5_NUMOLD) == _cC5PVBon) 
			
				Aviso("VLPVBON", "Informe um numero de Pedido existente.", {"Ok"})
				_lOkPVBon := .F.
				
			ENDIF
		
		EndIf
		
		If SC5->C5_CLASPED == "X"
																			
			Aviso("VLPVBON", "O pedido vinculado nao pode ser um pedido Bonificado.", {"Ok"})
			_lOkPVBon := .F.
		
		EndIf
		
		DBSelectArea("SA1")
		DBSetOrder(1)
		If DBSeek(xFilial("SA1") + &(_cAliasC5+"->C5_CLIENTE") + &(_cAliasC5+"->C5_LOJACLI")) .AND. !EMPTY(ALLTRIM(_cC5PVBon))
			
			//Tratamento do Grupo de Vendas
			If _cGrpVAtu <> AllTrim(SA1->A1_GRPVEN)
		
				If Len(_cCNPJAtu) == 14 	// Pessoa Juridica
					
					If SubStr(_cCNPJAtu, 01, 08) <> SubStr(SA1->A1_CGC, 01, 08)
																								
						Aviso("VLPVBON", "O pedido vinculado deve ser de cliente com mesma raiz de CNPJ.", {"Ok"})
						_lOkPVBon := .F.
					
					EndIf 
				
				Else      					// Pessoa Fisica
				
					If _cCNPJAtu <> AllTrim(SA1->A1_CGC)
			
						Aviso("VLPVBON", "O pedido vinculado deve ser de cliente com mesmo CPF.", {"Ok"})
						_lOkPVBon := .F.
					
					EndIf 
				
				EndIf
				
			EndIf
															
		EndIf                                                  
	ENDIF	
EndIf

DBSelectArea("SC5")
RestArea(_aSC5Alias)

DBSelectArea("SA1")
RestArea(_aSA1Alias)

DBSelectArea(_cOldAlias)
RestArea(_aOldAlias)

Return(_lOkPVBon) 

/*
=================================================================================
=================================================================================
||   Arquivo:	VlPVBon.prw
=================================================================================
||   Funcao: 	410CONBN
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		CONSULTA DE PEDIDOS PARA VINCULO COM PEDIDOS DE BONIFICACAO. 
|| 
=================================================================================
=================================================================================
||   Autor: 	EDSON HORNBERGER
||   Data:	08/12/2015
=================================================================================
=================================================================================
*/

USER FUNCTION 410CONBN(CCODCLI)

LOCAL LRET 			:= .F.
LOCAL CQUERY 		:= ""
LOCAL NPERC			:= 0
LOCAL CDBNAME		:= ""

//LOCAL CFUNLEG 		:= "" // FUNÇÃO QUE DEVERÁ RETORNAR UM VALOR LÓGICO E COM ISSO SERÁ ATRIBUÍDO SEMAFÓRO NA PRIMEIRA COLUNA DO BROWSE
//LOCAL LCENTERED 	:= .T. // VALOR VERDADEIRO CENTRALIZA
//LOCAL ARESOURCE 	:= {} // AADD(ARESOURCE,{"IMAGEM","TEXTO SIGNIFICATIVO"})
LOCAL NMODELO 		:= 1 // 1- MENU DO AROTINA
//LOCAL APESQUI 		:= {} // AADD(APESQUI{"TÍTULO",NORDEM}), SE NÃO PASSADO SERÁ UTILIZADO O AXPESQUI
LOCAL CSEEK 			:= "" // CHAVE PRINCIPAL PARA A BUSCA, EXEMPLO: XFILIAL("???")
LOCAL LDIC 			:= .F. // PARÂMETRO EM CONJUNTO COM ACAMPOS
LOCAL LSAVORD 		:= .T. // ESTABELECER A ORDEM APÓS PESQUISAS.

PRIVATE AROTINA   	:= {}
PRIVATE ACAMPOS   	:= {}
PRIVATE ASTRUCT		:= {}
PRIVATE CCADASTRO	:= "Pedidos disponíveis"
PRIVATE NOPCSEL   	:= 0 
PRIVATE LEST			:= (POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST") = "SP")

AADD(ASTRUCT, {"C5_NUM"		,"C",06,00})
AADD(ASTRUCT, {"C5_NUMOLD"	,"C",10,00})
AADD(ASTRUCT, {"C5_EMISSAO"	,"D",08,00})
AADD(ASTRUCT, {"C5_CLIENTE"	,"C",06,00})
AADD(ASTRUCT, {"C5_LOJACLI"	,"C",02,00})
AADD(ASTRUCT, {"C5_NOMCLI"	,"C",50,00})
AADD(ASTRUCT, {"SALDO"		,"N",15,02})

AADD(ACAMPOS, {"C5_NUM"		,"@!"					,"Ped.Protheus"	,06,"C"})
AADD(ACAMPOS, {"C5_NUMOLD"	,"@!"					,"Ped.Portal"	,10,"C"})
AADD(ACAMPOS, {"C5_EMISSAO"	,"@D"					,"Emissão"		,08,"D"})
AADD(ACAMPOS, {"C5_CLIENTE"	,"@!"					,"Código"			,06,"C"})
AADD(ACAMPOS, {"C5_LOJACLI"	,"@!"					,"Loja"			,02,"C"})
AADD(ACAMPOS, {"C5_NOMCLI"	,"@!"					,"Razão Social"	,50,"C"})
AADD(ACAMPOS, {"SALDO"		,"@E 999,999.99"	,"Saldo"			,15,"N"})

AADD( AROTINA, { "Confirmar",'TMSCONFSEL',0,2,,,.T.} ) //-- 'CONFIRMAR'  

/*
|---------------------------------------------------------------------------------
|	VERIFICA O PERCENTUAL QUE PODE SER UTIILZADO
|---------------------------------------------------------------------------------
*/

IF ALLTRIM(M->C5_XITEMC) = "TAIFF"

	CDBNAME := "PORTAL_TAIFFPROART"
	
	CQUERY := "SELECT" 												+ ENTER 
	CQUERY += "	ZA8.ZA8_PCBONI" 									+ ENTER
	CQUERY += "FROM" 													+ ENTER
	CQUERY += "	" + RETSQLNAME("SA1") + " SA1" 					+ ENTER
	CQUERY += "	INNER JOIN ZA8010 ZA8 ON" 						+ ENTER
	CQUERY += "		ZA8_COD = A1_CODCAN AND" 					+ ENTER 
	CQUERY += "		ZA8.D_E_L_E_T_ = ''" 						+ ENTER
	CQUERY += "WHERE" 												+ ENTER 
	CQUERY += "	A1_FILIAL = '" + XFILIAL("SA1") + "' AND" 	+ ENTER 
	CQUERY += "	A1_COD = '" + M->C5_CLIENTE + "' AND" 			+ ENTER 
	CQUERY += "	A1_LOJA = '" + M->C5_LOJACLI + "' AND" 		+ ENTER 
	CQUERY += "	SA1.D_E_L_E_T_ = ''"
	
	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP") 
		DBCLOSEAREA()
		
	ENDIF
	
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	
	NPERC := TMP->ZA8_PCBONI / 100
	
	DBCLOSEAREA()
	
ELSEIF ALLTRIM(M->C5_XITEMC) = "PROART"

	CDBNAME := "PORTAL_PROTHEUS_PROART"
	
	CQUERY := "SELECT" 																					+ ENTER 
	CQUERY += "	PORTAL.PERC_BONI_MAXIMA ZA8_PCBONI" 												+ ENTER
	CQUERY += "FROM" 																						+ ENTER 
	CQUERY += "	" + CDBNAME + "..REGIOES_GERENTES PORTAL" 										+ ENTER
	CQUERY += "	INNER JOIN SZD030 SZD ON" 															+ ENTER 
	CQUERY += "		ZD_GERENT = PORTAL.COD_GERENTE AND" 											+ ENTER 
	CQUERY += "		ZD_UNEGOC = '" + ALLTRIM(M->C5_XITEMC) + "' AND" 							+ ENTER 
	CQUERY += "		ZD_VENDED = '" + M->C5_VEND1 + "' AND" 										+ ENTER 
	CQUERY += "		(ZD_DTVALID >= '" + DTOS(DDATABASE) + "' OR ZD_DTVALID = '') AND" 	+ ENTER 
	CQUERY += "		SZD.D_E_L_E_T_ = ''" 																+ ENTER
	CQUERY += "WHERE" 																						+ ENTER 
	CQUERY += "	PORTAL.DESC_REGIOES LIKE '%" + POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST")+ "%'"
	
	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP") 
		DBCLOSEAREA()
		
	ENDIF
	
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	
	NPERC := TMP->ZA8_PCBONI / 100
	
	DBCLOSEAREA()

ELSE

	RETURN .T. 

ENDIF  


IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 																				+ ENTER 
CQUERY += "	SC5.C5_NUM," 																		+ ENTER
CQUERY += "	SC5.C5_NUMOLD," 																	+ ENTER
CQUERY += "	SC5.C5_EMISSAO," 																	+ ENTER
CQUERY += "	SC5.C5_CLIENTE," 																	+ ENTER
CQUERY += "	SC5.C5_LOJACLI," 																	+ ENTER
CQUERY += "	SC5.C5_NOMCLI," 																	+ ENTER
CQUERY += "	ISNULL	(	(" 																			+ ENTER	
CQUERY += "					SELECT" 																+ ENTER 
CQUERY += "						(	SELECT" 														+ ENTER 
CQUERY += "								(SUM(SC6.C6_QTDVEN * SC6.C6_PRCVEN) * " + CVALTOCHAR(NPERC) + ")" 	+ ENTER 
CQUERY += "							FROM" 															+ ENTER 
CQUERY += "								" + RETSQLNAME("SC6") + " SC6 " 					+ ENTER
CQUERY += "							WHERE" 														+ ENTER 
CQUERY += "								SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER 
CQUERY += "								SC6.C6_NUM = TMP.C5_NUM AND" 						+ ENTER 
CQUERY += "								SC6.D_E_L_E_T_ = ''" 									+ ENTER
CQUERY += "						) - SUM(SZ0.Z0_VALOR)"	 									+ ENTER
CQUERY += "					FROM" 																	+ ENTER 
CQUERY += "						" + RETSQLNAME("SZ0") + " SZ0" 								+ ENTER
CQUERY += "						INNER JOIN " + RETSQLNAME("SC5") + " TMP ON" 			+ ENTER 
CQUERY += "							TMP.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 		+ ENTER 
CQUERY += "							TMP.C5_NUMOLD = SZ0.Z0_VENOLD AND " 					+ ENTER
CQUERY += "							TMP.C5_NUM = SC5.C5_NUM AND" 							+ ENTER 
CQUERY += "							TMP.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "					WHERE" 																+ ENTER 
CQUERY += "						SZ0.Z0_FILIAL = '" + XFILIAL("SZ0") + "' AND" 			+ ENTER
CQUERY += "						SZ0.D_E_L_E_T_ = ''" 											+ ENTER
CQUERY += "					GROUP BY" 															+ ENTER 
CQUERY += "						TMP.C5_NUM," 													+ ENTER
CQUERY += "						TMP.C5_NUMOLD" 													+ ENTER
CQUERY += "				),	(	SELECT" 															+ ENTER 
CQUERY += "							(SUM(SC6.C6_QTDVEN * SC6.C6_PRCVEN) * " + CVALTOCHAR(NPERC) + ")" 		+ ENTER 
CQUERY += "						FROM" 																+ ENTER 
CQUERY += "							" + RETSQLNAME("SC6") + " SC6 " 						+ ENTER
CQUERY += "						WHERE" 															+ ENTER 
CQUERY += "							SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 		+ ENTER 
CQUERY += "							SC6.C6_NUM = SC5.C5_NUM AND" 							+ ENTER 
CQUERY += "							SC6.D_E_L_E_T_ = ''" 										+ ENTER
//CQUERY += "				))	- ISNULL((SELECT SUM(VALOR) FROM " + CDBNAME + "..TBL_PEDIDOS_ASSOCIADOS PORTAL WHERE PORTAL.C5_NUMPRE_VENDAS = CAST(SUBSTRING(RTRIM(SC5.C5_NUMOLD),1,LEN(RTRIM(SC5.C5_NUMOLD)) - (CASE WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MAN' THEN 3 WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MMG' THEN 3 WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MSP' THEN 3 ELSE 1 END)) AS INT)),0) AS SALDO" 															+ ENTER
CQUERY += "				))	- ISNULL((SELECT SUM(VALOR) FROM " + CDBNAME + "..TBL_PEDIDOS_ASSOCIADOS PORTAL WHERE PORTAL.C5_NUMPRE_VENDAS = CAST(LEFT(SC5.C5_NUMOLD,5) AS INT)),0) AS SALDO"	+ ENTER
CQUERY += "FROM" 																					+ ENTER 
CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 													+ ENTER
CQUERY += "	INNER JOIN " + RETSQLNAME("SA1") + " SA1 ON"								+ ENTER 
CQUERY += "		SA1.A1_FILIAL = '" + XFILIAL("SA1") + "' AND" 							+ ENTER 
CQUERY += "		SA1.A1_COD = SC5.C5_CLIENTE AND" 											+ ENTER
CQUERY += "		SA1.A1_LOJA = SC5.C5_LOJACLI AND" 											+ ENTER
IF LEST  
	CQUERY += "		SA1.A1_EST = 'SP' AND" 													+ ENTER
ELSE
	CQUERY += "		SA1.A1_EST != 'SP' AND" 													+ ENTER
ENDIF		
CQUERY += "		SA1.D_E_L_E_T_ = ''" 															+ ENTER 
CQUERY += "WHERE" 																					+ ENTER 
CQUERY += "	SC5.C5_FILIAL	= '" + XFILIAL("SC5") + "'	AND" 							+ ENTER
CQUERY += "	SC5.C5_CLIENTE	= '" + CCODCLI + "'	AND" 									+ ENTER 
CQUERY += "	ISNULL	(	(" 																			+ ENTER	
CQUERY += "					SELECT" 																+ ENTER 
CQUERY += "						(	SELECT" 														+ ENTER
CQUERY += "								(SUM(SC6.C6_QTDVEN * SC6.C6_PRCVEN) * " + CVALTOCHAR(NPERC) + ")" 	+ ENTER 
CQUERY += "							FROM" 															+ ENTER 
CQUERY += "								" + RETSQLNAME("SC6") + " SC6 " 					+ ENTER
CQUERY += "							WHERE" 														+ ENTER 
CQUERY += "								SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER 
CQUERY += "								SC6.C6_NUM = TMP.C5_NUM AND" 						+ ENTER 
CQUERY += "								SC6.D_E_L_E_T_ = ''" 									+ ENTER
CQUERY += "						) - SUM(SZ0.Z0_VALOR)"	 									+ ENTER 
CQUERY += "					FROM" 																	+ ENTER 
CQUERY += "						" + RETSQLNAME("SZ0") + " SZ0" 								+ ENTER
CQUERY += "						INNER JOIN " + RETSQLNAME("SC5") + " TMP ON" 			+ ENTER 
CQUERY += "							TMP.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 		+ ENTER 
CQUERY += "							TMP.C5_NUMOLD = SZ0.Z0_VENOLD AND " 					+ ENTER
CQUERY += "							TMP.C5_NUM = SC5.C5_NUM AND" 							+ ENTER 
CQUERY += "							TMP.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "					WHERE" 																+ ENTER 
CQUERY += "						SZ0.Z0_FILIAL = '" + XFILIAL("SZ0") + "' AND"			+ ENTER
CQUERY += "						SZ0.D_E_L_E_T_ = ''" 											+ ENTER
CQUERY += "					GROUP BY" 															+ ENTER 
CQUERY += "						TMP.C5_NUM," 													+ ENTER
CQUERY += "						TMP.C5_NUMOLD" 													+ ENTER
CQUERY += "				),	(" 																		+ ENTER	
CQUERY += "						SELECT" 															+ ENTER 
CQUERY += "							(SUM(SC6.C6_QTDVEN * SC6.C6_PRCVEN) * " + CVALTOCHAR(NPERC) + ")" 		+ ENTER 
CQUERY += "						FROM" 																+ ENTER 
CQUERY += "							" + RETSQLNAME("SC6") + " SC6 " 						+ ENTER
CQUERY += "						WHERE" 															+ ENTER 
CQUERY += "							SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 		+ ENTER 
CQUERY += "							SC6.C6_NUM = SC5.C5_NUM AND" 							+ ENTER 
CQUERY += "							SC6.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "					)" 																		+ ENTER
//CQUERY += "				) - ISNULL((SELECT SUM(VALOR) FROM " + CDBNAME + "..TBL_PEDIDOS_ASSOCIADOS PORTAL WHERE PORTAL.C5_NUMPRE_VENDAS = CAST(SUBSTRING(RTRIM(SC5.C5_NUMOLD),1,LEN(RTRIM(SC5.C5_NUMOLD)) - (CASE WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MAN' THEN 3 WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MMG' THEN 3 WHEN RIGHT(RTRIM(SC5.C5_NUMOLD),3) = 'MSP' THEN 3 ELSE 1 END)) AS INT)),0) > 0		AND" 															+ ENTER 
CQUERY += "				) - ISNULL((SELECT SUM(VALOR) FROM " + CDBNAME + "..TBL_PEDIDOS_ASSOCIADOS PORTAL WHERE PORTAL.C5_NUMPRE_VENDAS = CAST(LEFT(SC5.C5_NUMOLD,5) AS INT)),0) > 0		AND" 		+ ENTER
CQUERY += "	SC5.C5_BLQ		= ''	AND" 														+ ENTER 
CQUERY += "	SC5.C5_NOTA		= ''	AND" 														+ ENTER
CQUERY += "	SC5.C5_CLASPED	!= 'X'	AND	"														+ ENTER 
CQUERY += "	SC5.C5_LIBEROK	!= 'E'	AND" 														+ ENTER 
CQUERY += "	SC5.C5_XITEMC		= '" + M->C5_XITEMC + "' AND"									+ ENTER 
CQUERY += "	SC5.C5_XLIBCR	= 'L'	AND" 														+ ENTER 
CQUERY += "	SC5.D_E_L_E_T_	= ''" 

//MEMOWRITE("VIPVBON_BRW.SQL",CQUERY)

CARQTRB := CRIATRAB(ASTRUCT,.T.)
DBUSEAREA(.T., NIL, CARQTRB, "TRB", .F., .F.)
SQLTOTRB(CQUERY,ASTRUCT,"TRB")

CARQIND := CRIATRAB(NIL,.F.)
INDREGUA("TRB",CARQIND,"C5_NUM",,,"SELECIONANDO REGISTROS...")
DBSELECTAREA("TRB")

MAWNDBROWSE(0			,0			,400		,800		,CCADASTRO	,"TRB"		,ACAMPOS,AROTINA,,""		,""			,.T.			,,NMODELO,,CSEEK,LDIC,LSAVORD)

IF NOPCSEL == 1
	VAR_IXB := TRB->C5_NUMOLD
	LRET    := .T.
ENDIF

IF FILE(CARQIND+ORDBAGEXT())
	FERASE(CARQIND+ORDBAGEXT())
ENDIF

RETURN LRET

/*
=================================================================================
=================================================================================
||   Arquivo:	VlPVBon.prw
=================================================================================
||   Funcao: 	LIBBNFSVC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		FUNCAO PARA LIBERACAO DE PEDIDO DE BONIFICACAO SEM VINCULO
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	09/12/2015
=================================================================================
=================================================================================
*/

USER FUNCTION LIBBNFSVC(CPEDIDO)
	
LOCAL CUSERLIB 		:= SUBSTR(CUSERNAME,1,15)
//LOCAL AAREASC5		:= SC5->(GETAREA())
PRIVATE	ODLG
PRIVATE 	CTITULO	:= "Liberação Bonificação s/ Vínculo"
PRIVATE 	OLBL01	
PRIVATE 	CLBL01		:= "Informe o Motivo da Liberação!"
PRIVATE	OOBS
PRIVATE	COBS		:= SPACE(200)
PRIVATE 	ABUTTONS	:= {}
PRIVATE 	LOK			:= .F.

IF SC5->C5_CLASPED != "X" 
	
	MSGINFO("Pedido tem que ser de Bonificação!")
	RETURN
	
ENDIF

IF !EMPTY(ALLTRIM(SC5->C5_X_PVBON))
	
	MSGINFO("Liberação somente para Bonificações sem Vínculo!")
	RETURN
	
ENDIF 

IF !EMPTY(ALLTRIM(C5_OBSBNF))
	
	MSGINFO("Pedido já Liberado!")
	COBS := SC5->C5_OBSBNF
	
ENDIF	

/*
|---------------------------------------------------------------------------------
|	REALIZA O TRATAMENTO DE PEDIDO DO CROSSDOCKING
|---------------------------------------------------------------------------------
*/
IF CEMPANT + CFILANT = "0302" .AND. !U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. SC5->C5_FILDES = '01' 
	
	MSGINFO("Pedido de Bonificação para atendimento em SP!" + ENTER + "Entre na Filial de SP para efetuar a Autorização!")
	RETURN
	 
ENDIF 

AADD( ABUTTONS, {"EXCLUIR", {|| CANCLIB(),LOK := .F.,ODLG:END()}, "Cancela Liberação..."}) 

DEFINE MSDIALOG ODLG TITLE CTITULO FROM 0,0 TO 178,400 PIXEL	
@ 10,5 TO 80,195 LABEL CLBL01 PIXEL OF ODLG
@ 20,10 GET OOBS VAR COBS MEMO SIZE 180,50 PIXEL OF ODLG 

ACTIVATE MSDIALOG ODLG CENTERED ON INIT ENCHOICEBAR(ODLG, {|| IF( !EMPTY(COBS) .AND. !SC5->C5_BNFLIB,(LOK := .T., ODLG:END()),(LOK := .F., ODLG:END())) },{|| LOK := .F.,ODLG:END()},,ABUTTONS)

IF LOK .AND. SC5->( FIELDPOS("C5_OBSBNF") ) > 0

	IF RECLOCK("SC5", .F.)
		SC5->C5_USRBNF := CUSERLIB
		SC5->C5_OBSBNF := "Data Liberação: " + DTOC(DDATABASE) + ENTER + COBS 
		SC5->C5_BNFLIB := .T.

		SC5->(MSUNLOCK())
	ENDIF
	
	IF CEMPANT + CFILANT = '0301'
		
		SC5->(DBORDERNICKNAME("SC5NUMOLD"))
		SC5->(DBSEEK("02" + SC5->C5_NUMOLD))
		IF RECLOCK("SC5", .F.)
			SC5->C5_USRBNF := CUSERLIB
			SC5->C5_OBSBNF := "Data Liberação: " + DTOC(DDATABASE) + ENTER + COBS 
			SC5->C5_BNFLIB := .T.
	
			SC5->(MSUNLOCK())
		ENDIF
		
	ENDIF 
	 
ENDIF
	
RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	VlPVBon.prw
=================================================================================
||   Funcao: 	CANCLIB
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		FUNCAO PARA CANCELAMENTO DE LIBERACAO DO PEDIDO DE BONIFICACAO SEM 
|| 	VINCULO.
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	09/12/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION CANCLIB()
	
IF RECLOCK("SC5",.F.)
	
	SC5->C5_USRBNF := ""
	SC5->C5_OBSBNF := "" 
	SC5->C5_BNFLIB := .F.

	SC5->(MSUNLOCK())
	
ENDIF 
	
	
RETURN
