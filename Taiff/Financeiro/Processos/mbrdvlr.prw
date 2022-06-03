#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � mbrdvlr  � Autor � Adilson Gomes       � Data � 27/02/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para verificar o valor do titulo e retornar para a  ���
���          � posicao ( 195 a 204 )                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     � Uso Especifico da PHB                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function mbrdvlr()
Local cRetFun := Replicate("0",10)

//��������������������������������������������Ŀ
//� Verifica se o codigo de barras e digitavel �
//����������������������������������������������
If SE2->E2_TCODBAR == "1"
	cRetFun := SubStr(SE2->E2_CODBAR, 10, 10)
Else
	cRetFun := SubStr(SE2->E2_CODBAR, 38, 10)
Endif

//������������������������������������������Ŀ
//� Verifica se o codigo nao esta preenchido �
//��������������������������������������������
if Empty(SE2->E2_CODBAR)
	cRetFun := StrZero(SE2->E2_SALDO*100, 10)
endif

Return cRetFun