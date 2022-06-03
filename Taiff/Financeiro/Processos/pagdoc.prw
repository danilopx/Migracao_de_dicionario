#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGDOC    �Autor  � Paulo, o Vulcano   � Data �  12/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA GRAVAR AS INFORMACOES COMPLEMENTARES              ���
���          � CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (374-413)        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico TAIFF                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pagdoc()

Local _cDoc := "",_cMod := ""

_cMod := SUBSTR(SEA->EA_MODELO,1,2)

IF Empty(_cMod)
   _cMod := IF(SUBSTR(SE2->E2_CODBAR,1,3)=="237","30","31")
EndIf

If     _cMod $ "03/07/08/41/43"
       _cDoc := IF(SA2->A2_CGC==SM0->M0_CGC,"D","C")+"000000"+"01"+"01"+SPACE(29)
ElseIf _cMod == "31"
       _cDoc := SUBSTR(SE2->E2_CODBAR,20,25)+SUBSTR(SE2->E2_CODBAR,5,1)+SUBSTR(SE2->E2_CODBAR,4,1)+SPACE(13)
Else
       _cDoc := SPACE(40)
EndIf       

Return(_cDoc)