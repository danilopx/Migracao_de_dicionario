#include "RwMake.ch"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT080GRV  �Autor  �Edson Hornberger    � Data �  07/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Inclusao e Alteracao do TES.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Replica para outras Empresas                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT080GRV()        
Local aArea80g := GetArea()

IF INCLUI

	Processa({|| U_TPPROCREP("SF4","U_CADSF4",3) },"Replicando para as demais empresas...")

ELSEIF ALTERA

	Processa({|| U_TPPROCREP("SF4","U_CADSF4",4) },"Replicando para as demais empresas...")

ENDIF      

RestArea(aArea80g)

RETURN .T.