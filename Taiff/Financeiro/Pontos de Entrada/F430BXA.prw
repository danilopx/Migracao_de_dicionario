#INCLUDE "Protheus.ch"
#INClUDE "RwMake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F430BXA    �Autor  �Totvs - Jackson Santos Data �  29/10/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na BAixa do Titulo a Pagar por Cnab       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F430BXA()
	IF SE2->E2_XENDVDG == "S"
	      U_ADGBXTIT(3)      
	EndIF                   	
Return