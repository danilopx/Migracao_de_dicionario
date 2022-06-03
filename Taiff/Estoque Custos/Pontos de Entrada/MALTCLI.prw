#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���PROGRAMA  �MALTCLI   �AUTOR  �RICHARD N. CABRAL   � DATA �  04/11/09   ���
�������������������������������������������������������������������������͹��
���DESC.     � PONTO DE ENTRADA PARA REPLICAR O CADASTRO DE CLIENTES NA   ���
���          � ALTERA��O PARA DEMAIS EMPRESAS DO GRUPO                    ���
�������������������������������������������������������������������������͹��
���USO       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION MALTCLI()   
Local aAreaCli := GetArea()
Private cUsuLib

cUsuLib := RetCodUsr()
If U_CHECAFUNC(cUsuLib,"MA030TOK")  
	SA1->(RecLock("SA1",.F.))
	SA1->A1_MSBLQL := "1"
	SA1->(MsUnLock())
EndIf
		
PROCESSA({|| U_TPPROCREP("SA1","U_CADSA1",4) },"REPLICANDO PARA AS DEMAIS EMPRESAS...")   

RestArea(aAreaCli)

RETURN .T.