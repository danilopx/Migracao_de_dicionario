#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030INC   �Autor  �Edson Hornberger    � Data �  07/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Inclusao do Cliente.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Replica para outras Empresas                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION M030INC()  
Local aArea30i := GetArea()
Private cUsuLib

cUsuLib := RetCodUsr()
If U_CHECAFUNC(cUsuLib,"MA030TOK")  
	SA1->(RecLock("SA1",.F.))
	SA1->A1_MSBLQL := "1"
	SA1->(MsUnLock())
EndIf
		
IF PARAMIXB != 3

	Processa({|| U_TPPROCREP("SA1","U_CADSA1",3) },"Replicando para as demais empresas...")
	
ENDIF    

RestArea(aArea30i)

RETURN .T.