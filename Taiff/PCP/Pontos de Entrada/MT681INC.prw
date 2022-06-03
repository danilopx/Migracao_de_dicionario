// #########################################################################################
// Projeto: ponto de entrada apos gracavao producao modelo2 
// Modulo :
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 06/06/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#INCLUDE 'TOPCONN.CH'

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} new_source
Processa a tabela SC2-Ordens de Producao.

@author    pbindo
@version   11.3.1.201605301307
@since     06/06/2016
/*/
//------------------------------------------------------------------------------------------

user function MT681INC()
RETURN
	//SALDO DE OPERACAO FINALIZADA
	CQUERY := "SELECT"
	CQUERY += "	ISNULL(SUM(SH6.H6_QTDPROD),0) AS H6_QTDPROD"
	CQUERY += " FROM "+ RETSQLNAME("SH6") + " SH6 WITH (NOLOCK)"
	CQUERY += " WHERE"
	CQUERY += "	SH6.H6_FILIAL = '" + XFILIAL("SH6") + "' AND"
	CQUERY += "	SH6.H6_OP = '" + SH6->H6_OP + "' AND"
	CQUERY += "	SH6.H6_PRODUTO = '" + SH6->H6_PRODUTO + "' AND"
	CQUERY += "	(SH6.H6_OPERAC = '01' OR SH6.H6_OPERAC = '') AND"
	CQUERY += "	SH6.D_E_L_E_T_ = ''"

	MEMOWRITE("MT681INC.SQL",CQUERY)

	TCQUERY CQUERY NEW ALIAS "TMPH6"
	DBSELECTAREA("TMPH6")
	DBGOTOP()

	NSALDO := TMPH6->H6_QTDPROD

	TMPH6->(dbCloseArea())	

	//SALDO DE OPERACAO INICIADA
	cQuery := " SELECT SUM(CBH_QEPREV) CBH_QEPREV FROM "+RetSqlName("CBH")+" WITH(NOLOCK)" 
	cQuery += " WHERE CBH_OP = '"+SH6->H6_OP+"' AND CBH_TRANSA IN ('01') AND D_E_L_E_T_ <> '*' AND CBH_DTFIM = ''"

	MEMOWRITE("ACD080VLEB",CQUERY)

	TCQUERY CQUERY NEW ALIAS "TMPBH"
	DBSELECTAREA("TMPBH")
	DBGOTOP()

	NSALDO := NSALDO+TMPBH->CBH_QEPREV 

	TMPBH->(dbCloseArea())	

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+SH6->H6_OP)
		RecLock("SC2",.F.)
		C2__QTDH6 := NSALDO
		SC2->(MsUnlock())
	EndIf


Return

