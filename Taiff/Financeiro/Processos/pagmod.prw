#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGMOD    �Autor  � Paulo, o Vulcano   � Data �  12/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO            ���
���          � CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (264-265)        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico TAIFF                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pagmod()

Local _cModel := ""

_cModel := SUBSTR(SEA->EA_MODELO,1,2)

If Empty(_cModel)
   _cModel := IF(SUBSTR(SE2->E2_CODBAR,1,3)=="237","30","31")
EndIf

If _cModel == "41" .And. SEA->EA_PORTADO ==  "237" //-- Se for TED para o Banco Bradesco o codigo
	_cModel := "08"
EndIf

Return(_cModel)