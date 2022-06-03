#INCLUDE "RWMAKE.CH"
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³RM410BNF  º AUTOR ³ MARCELO CARDOSO    º DATA ³  08/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ VINCULA E/OU DESVINCULA PEDIDOS NORMAIS E BONIFICADOS DE   º±±
±±º          ³ DE ACORDO COM A OPERACAO REALIZADA NO PEDIDO DE VENDA      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ ESPECIFICO TAIFF-PROART                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

USER FUNCTION RM410BNF(_NOPTION)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ DECLARACAO DE VARIAVEIS                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL LRET 		:= .T.
	LOCAL ADADOS		:= {}

	IF INCLUI

		_CALIASC5 := "M"

	ELSE

		DBSELECTAREA("SC5")
		DBSETORDER(1)
		_CALIASC5 := "SC5"

	ENDIF

	_CMARCA		:= &(_CALIASC5 + "->C5_XITEMC")
	_CCLASPED  	:= &(_CALIASC5 + "->C5_CLASPED")
	_CXPVBON   	:= &("M->C5_X_PVBON")
	_CC5NUM    	:= &(_CALIASC5 + "->C5_NUM")
	_CNUMOLD   	:= &(_CALIASC5 + "->C5_NUMOLD")
	_CNUMVEN		:= &(_CALIASC5 + "->C5_VEND1")
	_CCODCLI		:= &(_CALIASC5 + "->C5_CLIENTE") + &(_CALIASC5 + "->C5_LOJACLI")

	AADD(ADADOS, {_CXPVBON,_CNUMOLD,_CC5NUM,_CMARCA,_CCODCLI,_CNUMVEN,_CCLASPED})

/*
|---------------------------------------------------------------------------------
|	INCLUSAO
|---------------------------------------------------------------------------------
*/                                      
	IF _NOPTION == 3

		// NAO PERMITE INCLUIR UM PEDIDO BONIFICADO SEM VINCULA-LO A UM PEDIDO NORMAL.
		IF EMPTY(_CXPVBON) .AND. _CCLASPED == "X"

			AVISO("RM410BNF", "PEDIDO DE BONIFICAÇÃO SEM VÍNCULO." + ENTER + "REALIZE O VÍNCULO DE PEDIDO DE VENDA OU SOLICITE A LIBERAÇÃO AO SUPERIOR!", {"OK"})
			LRET := .T.

		ENDIF

		//CASO SEJA INCLUSAO DE UM PEDIDO BONIFICADO, VINCULA O PEDIDO NORMAL AO BONIFICADO
		IF !EMPTY(_CXPVBON)

			IF U_VERPERCBON(ADADOS)
				U_VINCBNF(_CXPVBON, _CC5NUM, 3, _CCLASPED)
			ELSE
				LRET := .F.
			ENDIF

		ENDIF

	ENDIF

/*
|---------------------------------------------------------------------------------
|	ALTERACAO
|---------------------------------------------------------------------------------
*/
	IF _NOPTION == 4

		IF !EMPTY(_CXPVBON) .AND. _CCLASPED = "V" .AND. (1 = 2)

			AVISO("RM410BNF", "PEDIDO JA VINCULADO A UM PEDIDO BONIFICADO. EXCLUA O PEDIDO BONIFICADO PARA ALTERAR O ORIGINAL", {"OK"})
			LRET := .F.

		ELSEIF _CCLASPED = 'X' .AND. EMPTY(ALLTRIM(_CXPVBON))

			AVISO("RM410BNF", "PEDIDO DE BONIFICAÇÃO SEM VÍNCULO." + ENTER + "REALIZE O VÍNCULO DE PEDIDO DE VENDA OU SOLICITE A LIBERAÇÃO AO SUPERIOR!", {"OK"})
			U_VINCBNF(_CXPVBON, _CC5NUM, 4, _CCLASPED)
			LRET := .T.

		ELSEIF !EMPTY(ALLTRIM(_CXPVBON)) .AND. _CCLASPED = "X"

			IF U_VERPERCBON(ADADOS)
				U_VINCBNF(_CXPVBON, _CC5NUM, 4, _CCLASPED)
				LRET := .T.
			ELSE
				LRET := .F.
			ENDIF

		ENDIF

	ENDIF

/*
|---------------------------------------------------------------------------------
|	COPIA
|---------------------------------------------------------------------------------
*/        
	IF ISINCALLSTACK("A410COPIA")

		LRET := .T.

	ENDIF

/*
|---------------------------------------------------------------------------------
|	EXCLUSAO
|---------------------------------------------------------------------------------
*/
	IF _NOPTION == 1

		//VERIFICA SE ESTA EXCLUINDO UM PEDIDO TIPO BONIFICACAO
		IF _CCLASPED == "X"

			IF !EMPTY(_CXPVBON) // EM SE TRATANDO DE PEDIDO BONIFICADO, VERIFICA SE HA UM PEDIDO NORMAL VINCULADO

				U_VINCBNF(_CXPVBON, _CC5NUM, 1, _CCLASPED)
				LRET := .T.

			ENDIF

		ELSE

			//CASO SEJA UM PEDIDO NORMAL, VINCULADO A UM PEDIDO BONIFICADO NAO PERMITE A EXCLUSAO
			IF !EMPTY(_CXPVBON)

				AVISO("RM410BNF", "PEDIDO JA VINCULADO A UM PEDIDO BONIFICADO. EXCLUA O PEDIDO BONIFICADO PARA EXCLUIR O ORIGINAL", {"OK"})
				LRET := .F.

			ENDIF

		ENDIF

	ENDIF

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	RM410BNF.PRW
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

ARRAY 

/01/ - NUMERO DO PORTAL DO PEDIDO DE VENDA
/02/ - NUMERO DO PORTAL DO PEDIDO DE BONIFICACAO
/03/ - NUMERO DO PEDIDO DE BONIFICACAO
/04/ - MARCA
/05/ - CODIGO/LOJA DO CLIENTE
/06/ - CODIGO DO VENDEDOR
/07/ - CLASSE DE PEDIDO (VENDAS OU BONIFICACAO)

*/

USER FUNCTION VERPERCBON(ADADOS)

	LOCAL LRET 		:= .T.
	LOCAL CQUERY		:= ""
	LOCAL NPERC		:= 0
	LOCAL NVLVENDA	:= 0
	LOCAL NVLBONIF	:= 0
	LOCAL NVLSALDO	:= 0
	LOCAL CDBNAME	:= ""
	LOCAL CPEDVEN	:= ""
	LOCAL CPEDBON	:= ""
	Local I			:= 0

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	REALIZA A VERIFICACAO DO PERCENTUAL MAXIMO PERMITIDO PARA BONIFICACAO 
|	VERIFICACAO POR MARCA. CADA UMA TEM UMA REGRA
|=================================================================================
*/
/*
|---------------------------------------------------------------------------------
|	TAIFF - VERIFICA O CADASTRO DO CANAL DO CLIENTE
|---------------------------------------------------------------------------------
*/
	IF ALLTRIM(ADADOS[1,4]) = 'TAIFF'

		CDBNAME := "PORTAL_TAIFFPROART"

		CQUERY := "SELECT" + ENTER
		CQUERY += "	ZA8.ZA8_PCBONI" + ENTER
		CQUERY += "FROM" + ENTER
		CQUERY += "	" + RETSQLNAME("SA1") + " SA1" + ENTER
		CQUERY += "	INNER JOIN ZA8010 ZA8 ON" + ENTER
		CQUERY += "		ZA8_COD = A1_CODCAN AND" + ENTER
		CQUERY += "		ZA8.D_E_L_E_T_ = ''" + ENTER
		CQUERY += "WHERE" + ENTER
		CQUERY += "	A1_FILIAL = '" + XFILIAL("SA1") + "' AND" + ENTER
		CQUERY += "	A1_COD = '" + SUBSTR(ADADOS[1,5],1,6) + "' AND" + ENTER
		CQUERY += "	A1_LOJA = '" + SUBSTR(ADADOS[1,5],7,2) + "' AND" + ENTER
		CQUERY += "	SA1.D_E_L_E_T_ = ''"

		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")

		NPERC := TMP->ZA8_PCBONI

		DBCLOSEAREA()

/*
|---------------------------------------------------------------------------------
|	PROART - VERIFICA QUAL O GERENTE E CONSULTA TABELA DO PORTAL 
|---------------------------------------------------------------------------------
*/
	ELSEIF ALLTRIM(ADADOS[1,4]) = 'PROART'

		CDBNAME := "PORTAL_PROTHEUS_PROART"

		CQUERY := "SELECT" + ENTER
		CQUERY += "	PORTAL.PERC_BONI_MAXIMA ZA8_PCBONI" + ENTER
		CQUERY += "FROM" + ENTER
		CQUERY += "	" + CDBNAME + "..REGIOES_GERENTES PORTAL" + ENTER
		CQUERY += "	INNER JOIN SZD030 SZD ON" + ENTER
		CQUERY += "		ZD_GERENT = PORTAL.COD_GERENTE AND" + ENTER
		CQUERY += "		ZD_UNEGOC = '" + ALLTRIM(ADADOS[1,4]) + "' AND" + ENTER
		CQUERY += "		ZD_VENDED = '" + ADADOS[1,6] + "' AND" + ENTER
		CQUERY += "		(ZD_DTVALID >= '" + DTOS(DDATABASE) + "' OR ZD_DTVALID = '') AND" + ENTER
		CQUERY += "		SZD.D_E_L_E_T_ = ''" + ENTER
		CQUERY += "WHERE" + ENTER
		CQUERY += "	PORTAL.DESC_REGIOES LIKE '%" + POSICIONE("SA1",1,XFILIAL("SA1") + ADADOS[1,5],"A1_EST")+ "%'"

		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")

		NPERC := TMP->ZA8_PCBONI

		DBCLOSEAREA()

	ENDIF

	CPEDVEN := STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(ALLTRIM(ADADOS[1,2]),"MAN",""),"T",""),"P",""),"MMG",""),"MSP",""),"MANC",""),"TC",""),"PC","")
	CPEDBON := STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(STRTRAN(ALLTRIM(ADADOS[1,1]),"MAN",""),"T",""),"P",""),"MMG",""),"MSP",""),"MANC",""),"TC",""),"PC","")

/*
|---------------------------------------------------------------------------------
|	VERIFICA QUAL O VALOR TOTAL DO PEDIDO DE VENDAS
|---------------------------------------------------------------------------------
*/
	CQUERY := "SELECT" + ENTER
	CQUERY += "	SUM(C6_QTDVEN * C6_PRCVEN) AS TOTAL" + ENTER
	CQUERY += "FROM" + ENTER
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" + ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" + ENTER
	CQUERY += "		C5_FILIAL = C6_FILIAL AND" + ENTER
	CQUERY += "		C5_NUMOLD = '" + IIF(ADADOS[1,7] = 'X',ALLTRIM(ADADOS[1,1]),ADADOS[1,2]) + "' AND" + ENTER
	CQUERY += "		C5_NUM = C6_NUM AND" + ENTER
	CQUERY += "		SC5.D_E_L_E_T_ = ''" + ENTER
	CQUERY += "WHERE" + ENTER
	CQUERY += "	C6_FILIAL = '" + XFILIAL("SC6") + "' AND" + ENTER
	CQUERY += "	SC6.D_E_L_E_T_ = ''"

	IF SELECT("TMP") > 0

		DBSELECTAREA("TMP")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")

	NVLVENDA := TMP->TOTAL

	DBCLOSEAREA()

/*
|---------------------------------------------------------------------------------
|	VERIFICA QUAL O VALOR TOTAL DOS PEDIDOS DE BONIFICACAO
|---------------------------------------------------------------------------------
*/
// TABELA DO PORTAL DE VENDAS
	CQUERY := "SELECT" + ENTER
	CQUERY += "	SUM(VALOR) AS TOTAL" + ENTER
	CQUERY += "FROM" + ENTER
	CQUERY += "	" + CDBNAME + "..TBL_PEDIDOS_ASSOCIADOS PORTAL" + ENTER
	CQUERY += "WHERE" + ENTER
	CQUERY += "	PORTAL.C5_NUMPRE_VENDAS = " + IIF(ADADOS[1,7] = 'X',LEFT(CPEDBON,5),LEFT(CPEDVEN,5)) + " AND"
	CQUERY += "	PORTAL.C5_NUMPRE_BONIFICACAO != " + IIF(ADADOS[1,7] = 'V',LEFT(CPEDBON,5),LEFT(CPEDVEN,5))

	IF SELECT("TMP") > 0

		DBSELECTAREA("TMP")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")

	NVLBONIF += TMP->TOTAL

	DBCLOSEAREA()

// TABELA DO SISTEMA PROTHEUS 
	CQUERY := "SELECT" + ENTER
	CQUERY += "	SUM(Z0_VALOR) AS TOTAL" + ENTER
	CQUERY += "FROM" + ENTER
	CQUERY += "	" + RETSQLNAME("SZ0") + " SZ0" + ENTER
	CQUERY += "WHERE" + ENTER
	CQUERY += "	SZ0.Z0_VENOLD = '" + IIF(ADADOS[1,7] = 'X',ALLTRIM(ADADOS[1,1]),ADADOS[1,2]) + "' AND" + ENTER
	CQUERY += "	SZ0.D_E_L_E_T_ = ''"

	IF SELECT("TMP") > 0

		DBSELECTAREA("TMP")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")

	NVLBONIF += TMP->TOTAL
	DBCLOSEAREA()

/*
|---------------------------------------------------------------------------------
|	SALVANDO O SALDO PARA APRESENTAR SE NECESSARIO
|---------------------------------------------------------------------------------
*/

	NVLSALDO := (NVLVENDA * (NPERC/100)) - NVLBONIF

/*
|---------------------------------------------------------------------------------
|	REALIZO A SOMA DOS ITENS DA NOVA BONIFICACAO PARA ANALISAR SE EXISTE SALDO
|---------------------------------------------------------------------------------
*/

	FOR I := 1 TO LEN(ACOLS)

		NVLBONIF += (ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})] * ACOLS[I,aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})])

	NEXT I

	IF ((NVLBONIF/NVLVENDA) * 100) <= NPERC
		LRET := .T.
	ELSE
		MSGSTOP("Não há Saldo para esta Bonificação no Pedido de Venda informado!" + ENTER + "Saldo R$ " + TRANSFORM(NVLSALDO,"@E 999,999.99"),"ATENÇÃO")
		LRET := .F.
	ENDIF

RETURN(LRET)