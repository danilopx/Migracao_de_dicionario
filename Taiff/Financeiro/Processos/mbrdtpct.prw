#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � mbrdtpct � Autor � Adilson Gomes       � Data � 27/02/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para verificar o tipo da conta para retorno na      ���
���          � posicao ( 479 a 479 )                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     � Uso Especifico da PHB                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function mbrdtpct()
Local cRetFun := "0"

//�������������������������������������������Ŀ
//� Verifica a modalidade do arquivo de envio �
//���������������������������������������������
if Left(SEA->EA_MODELO,2) $ "01/03/05/41"
	cRetFun := "1"
endif

Return cRetFun