#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TFGPM002 �       �RICARDO DUARTE COSTA� Data �  28/07/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Cancelar verbas calculadas em rescis�o.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
User Function TFGPM002()

Local nRet	:= 0
Local nx	:= 0

For nx := 1 to len(Apd)
	//-- Verba lan�ada em dias, quantidade de dias igual a 0,01, informada ou gerada e n�o excluida no array
	If apd[nx,6] == "D" .And. apd[nx,7] $"IG" .And. apd[nx,4] == 0.01 .And. apd[nx,9] <> "D"
		//-- Zeramento do valor calculado.
		apd[nx,6]	:= "V"
		apd[nx,5]	:= 0.00
	Endif
Next nx

Return(nRet)

