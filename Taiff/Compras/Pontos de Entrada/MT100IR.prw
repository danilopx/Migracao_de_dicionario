#INCLUDE "PROTHEUS.CH"
#include "TbiConn.ch"
#INCLUDE "Topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| PE: MT100IR                                    AUTOR: CARLOS ALDAY TORRES                DATA: 03/12/2014   |
//+--------------------------------------------------------------------------------------------------------------
//| Ponto de Entrada: MT100IR - Recálculo de IRRF e ISS na gravação de SE2
//| DESCRICAO: Ponto de entrada acionado ao gerar o titulo do IR para atender a divergencia do IR da comissão
//| SOLICITANTE: Olga - Diretoria
//+--------------------------------------------------------------------------------------------------------------
User Function MT100IR
Local cDtRefer:= Left(Dtos( SE2->E2_VENCREA ),6)
Local cFornece:= SE2->E2_FORNECE
Local cQuery 
Local nVl_IR	:= PARAMIXB[1]

If Alltrim(SF1->F1_ESPECIE)="NFS" .AND. At("COMISS",Upper(SED->ED_DESCRIC))!=0
	
	
	// Tabela ZAQ 
	// 
	//
	cQuery := "SELECT TOP(1) ZAQ_IR_DEB "
	cQuery += "FROM "+ RetSqlName("ZAQ") + " ZAQ WITH(NOLOCK) "
	cQuery += "	INNER JOIN "+ RetSqlName("SA3") + " SA3 WITH(NOLOCK)" 
	cQuery += "	ON SA3.D_E_L_E_T_= '' "
	cQuery += "	AND SA3.A3_FILIAL	= ZAQ_FILIAL "
	cQuery += "	AND SA3.A3_COD	= ZAQ_CODVEN "
	cQuery += "	AND SA3.A3_FORNECE= '"+cFornece+"' "	
	cQuery += "	INNER JOIN "+ RetSqlName("SA2") + " SA2 WITH(NOLOCK)"
	cQuery += "	ON SA2.D_E_L_E_T_=''"
	cQuery += "	AND SA2.A2_FILIAL=ZAQ_FILIAL"
	cQuery += "	AND SA2.A2_COD=SA3.A3_FORNECE"
	cQuery += "	AND SA2.A2_LOJA=SA3.A3_LOJA"
	cQuery += "	AND SA2.A2_SIMPNAC != '1'"
	cQuery += "WHERE "
	cQuery += "	ZAQ.D_E_L_E_T_	='' AND "
	cQuery += "	ZAQ.ZAQ_FILIAL 	='"+xFilial("ZAQ")+"' AND "	
	cQuery += "	LEFT(ZAQ.ZAQ_DTPAGT,6)='"+cDtRefer+"' "

	MemoWrite("MT100IR-LE_ZAQ_IR_VENDEDOR.sql",cQuery)

	If Select("TMPZAQ") > 0
		TMPZAQ->(DbCloseArea())
	Endif
	TcQuery cQuery NEW ALIAS ("TMPZAQ")
	
	If !TMPZAQ->(Eof()) .AND. !TMPZAQ->(Bof()) 
		If TMPZAQ->ZAQ_IR_DEB > 0
			nVl_IR	:=TMPZAQ->ZAQ_IR_DEB
		EndIf
	EndIf
		
EndIf
Return (nVl_IR)