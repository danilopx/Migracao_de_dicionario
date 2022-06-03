#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �MACD002	� Autor � Cesar Cunha	        � Data � 22/04/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun�ao para liberar separa��o manual						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe	 � MACD002              									  ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � 															  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                      

USER Function MACD002

Local aArea := GetArea()
//Local cExpressao := " "
                                                            
DbSelectArea("SX3")                                         
DbSetOrder(2)

If DbSeek("CB8_SALDOS")
		RecLock("SX3")
		Replace X3_VISUAL	With "A"
		MsUnlock()
Endif

If DbSeek("CB8_SALDOE")
		RecLock("SX3")
		Replace X3_VISUAL	With "A"
		MsUnlock()
Endif

SX3->(dbSetOrder(1))

RestArea(aArea)

Return(0)

