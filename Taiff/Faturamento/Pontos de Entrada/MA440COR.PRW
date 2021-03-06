#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410   �Autor  � Fernando Salvatori � Data �  12/15/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada executado para validar toda a Getdados    ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA440COR(aCores)
Local _aCores := {{"C5_LIBCOM != '2' .AND. Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_LIBPARC) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
				{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
				{ "C5_BLQ == '2'",'BR_LARANJA'},;	//Pedido Bloquedo por verba
				{ "!Empty(C5_LIBPARC) .And. Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_BRANCO' },;
				{ "C5_LIBCOM == '2'",'BR_PINK'} }
Return _aCores
