#include "protheus.ch"
#include "topconn.ch"
#include "RWMAKE.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTMI001  �Autor  �FSW Veti            � Data �     27/03/14���
�������������������������������������������������������������������������͹��
���Desc.     � ROTINA PARA REPROCESSAR O CAMPO ZZG_SC9 QUANDO DESBALCANCEADO���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�����������������������������������������������������������������������������
*/
USER FUNCTION PRTMI001()

If MsgYesNo("Deseja re-processar o vinculo das embalagens com as libera��es dos pedidos (ZZG_SC9 x SC9.R_E_C_N_O_)?")
	PROCESSA({|| Processar()})
EndIf

Return

Static Function Processar()
Local cNameZZG := RetSqlName("ZZG")
Local cNameSC9 := RetSqlName("SC9")

ProcRegua(0)
IncProc("Re-processando vinculo ZZG_SC9 x SC9.R_E_C_N_O_ ...")

//����������������������������������������������������������������0�
//�Atualiza ZZG: grava RECNO do SC9 em cada item separado          �
//����������������������������������������������������������������0�

cQuery := "UPDATE "+cNameZZG+" SET ZZG_SC9 = "+cNameSC9+".R_E_C_N_O_ "+CRLF
cQuery += "FROM "+cNameSC9+" , "+cNameZZG+" "+CRLF
cQuery += "WHERE "+cNameSC9+".D_E_L_E_T_ = '' "+CRLF
cQuery += "AND "+cNameZZG+".D_E_L_E_T_ = '' "+CRLF
cQuery += "AND C9_FILIAL = ZZG_FILIAL "+CRLF
cQuery += "AND C9_PEDIDO = ZZG_PEDIDO "+CRLF
cQuery += "AND C9_PRODUTO = ZZG_PRODUT "+CRLF
cQuery += "AND ZZG_SC9 <> 0 "+CRLF
cQuery += "AND ZZG_SC9 NOT IN (SELECT R_E_C_N_O_ FROM SC9030 WHERE D_E_L_E_T_ = '') "+CRLF
//MemoWrite("PRTMI001.sql",cQuery)
TCSQLExec(cQuery)

Msgstop("Re-processamento finalizado com sucesso")

RETURN
