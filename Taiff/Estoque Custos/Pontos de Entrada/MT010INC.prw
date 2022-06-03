#INCLUDE 'PROTHEUS.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT010INC  �Autor  �Edson Hornberger    � Data �  07/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Inclusao do Produto.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Replica para outras Empresas                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT010INC()  
Local aArea10i := GetArea()

Processa({|| U_TPPROCREP("SB1","U_CADSB1",3) },"Replicando para as demais empresas...")     

RestArea(aArea10i)

RETURN .T.