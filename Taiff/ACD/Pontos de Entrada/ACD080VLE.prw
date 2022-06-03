// #########################################################################################
// Projeto: PONTO DE ENTRADA QUE VALIDA A EXCLUSAO DO ITEM NA CBH
// Modulo :
// Fonte  : ACD080VLE.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 08/06/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#INCLUDE 'TOPCONN.CH'
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ACD080VLE
Processa a tabela CBH-MONITORAMENTO DA PRODUCAO.

@author    pbindo
@version   11.3.1.201605301307
@since     08/06/2016
/*/
//------------------------------------------------------------------------------------------
user function ACD080VLE()

	//SALDO DE OPERACAO FINALIZADA
	CQUERY := "SELECT"
	CQUERY += "	ISNULL(SUM(SH6.H6_QTDPROD),0) AS H6_QTDPROD"
	CQUERY += " FROM "+ RETSQLNAME("SH6") + " SH6 WITH (NOLOCK)"
	CQUERY += " WHERE"
	CQUERY += "	SH6.H6_FILIAL = '" + XFILIAL("SH6") + "' AND"
	CQUERY += "	SH6.H6_OP = '" + CBH->CBH_OP + "' AND"
	CQUERY += "	(SH6.H6_OPERAC = '01' OR SH6.H6_OPERAC = '') AND"
	CQUERY += "	SH6.D_E_L_E_T_ = ''"

	MEMOWRITE("ACD080VLEA.SQL",CQUERY)

	TCQUERY CQUERY NEW ALIAS "TMPH6"
	DBSELECTAREA("TMPH6")
	DBGOTOP()

	NSALDO := TMPH6->H6_QTDPROD

	TMPH6->(dbCloseArea())	


	//SALDO DE OPERACAO INICIADA
	cQuery := " SELECT SUM(CBH_QEPREV) CBH_QEPREV FROM "+RetSqlName("CBH")+" WITH(NOLOCK)" 
	cQuery += " WHERE CBH_OP = '"+CBH->CBH_OP+"' AND CBH_TRANSA IN ('01') AND D_E_L_E_T_ <> '*' AND CBH_DTFIM = ''"

	MEMOWRITE("ACD080VLEB",CQUERY)

	TCQUERY CQUERY NEW ALIAS "TMPBH"
	DBSELECTAREA("TMPBH")
	DBGOTOP()

	NSALDO := NSALDO+TMPBH->CBH_QEPREV-1 //TEM QUE TIRAR UMA PECA, POIS NA QUERY O ITEM NAO FOI DELETADO

	TMPBH->(dbCloseArea())	


	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+CBH->CBH_OP)
		RecLock("SC2",.F.)
		C2__QTDH6 := NSALDO
		SC2->(MsUnlock())
	EndIf	



return(.T.)

