// #########################################################################################
// Projeto: PONTO DE ENTRADA QUE VALIDA A EXCLUSAO DO ITEM NA CBH
// Modulo :
// Fonte  : ACD080VLE.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 08/06/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------
// 17/05/2021 | Renan Bruniera    | Feita alteração para ajustar automaticamente o contador
//            | RB                | C2__QTDH6 em caso de exclusão de peças.
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

/* RB: 17/05/2021 - Na atual rotina customizada, não é permitida a exclusão de operações finalizadas,
					pois somente gera movimento na CBH. SH6 é gerada posteriormente, com 1 linha apenas,
					ao ser executada rotina ACDRD004 via SCHEDULER.

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
	//----------------------------------------- QUERY ANTIGA ----------------------------------------------------------
	//cQuery := " SELECT SUM(CBH_QEPREV) CBH_QEPREV FROM "+RetSqlName("CBH")+" WITH(NOLOCK)" 
	//cQuery += " WHERE CBH_OP = '"+CBH->CBH_OP+"' AND CBH_TRANSA IN ('01') AND D_E_L_E_T_ <> '*' AND CBH_DTFIM = ''"
	//-----------------------------------------------------------------------------------------------------------------
*/

	//RB: NOVA QUERY. Considerar saldo conforme a quantidade de transações "01" lançadas

If CEMPANT = "04" .AND. CFILANT = "02"

	cQuery := " SELECT COUNT(CBH_TRANSA) CBH_TRANSA FROM "+RetSqlName("CBH")+" WITH(NOLOCK)" 
	cQuery += " WHERE CBH_OP = '"+CBH->CBH_OP+"'AND CBH_OPERAC = '01' AND CBH_TRANSA = '01' AND D_E_L_E_T_ <> '*'"

	MEMOWRITE("ACD080VLEB",CQUERY)

	TCQUERY CQUERY NEW ALIAS "TMPBH"
	DBSELECTAREA("TMPBH")
	DBGOTOP()

	NSALDO := 0
	NSALDO := NSALDO+TMPBH->CBH_TRANSA-1 //TEM QUE TIRAR UMA PECA, POIS NA QUERY O ITEM NAO FOI DELETADO

	TMPBH->(dbCloseArea())	

	dbSelectArea("SC2")
	dbSetOrder(1)
	If dbSeek(xFilial()+CBH->CBH_OP)
		RecLock("SC2",.F.)
		If CBH_OPERAC = '01' .AND. CBH_TRANSA = "01"
			C2__QTDH6 := NSALDO
			SC2->(MsUnlock())
		EndIf
	EndIf	

EndIf

return(.T.)
