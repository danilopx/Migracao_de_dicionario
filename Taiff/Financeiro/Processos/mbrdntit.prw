#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � mbrdntit � Autor � Adilson Gomes       � Data � 27/02/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para retonar o valor liquido do titulo a receber.   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     � Uso Especifico PHB                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function mbrdntit()
Local aGetArea	:= GetArea()
Local cRetFun	:= " "

cRetFun := SE2->( E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA )+TABELA(SEE->EE_TABELA,SE2->E2_TIPO)

RestArea( aGetArea )
Return cRetFun