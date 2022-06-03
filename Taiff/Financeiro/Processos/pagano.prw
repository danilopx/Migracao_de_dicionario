#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGANO    �Autor  � Paulo, o Vulcano   � Data �  12/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � PROGRAMA PARA SELECIONAR O ANO DO NOSSO NUMERO DO NUMERO   ���
���          � CNAB. QUANDO NAO NAO TIVER TEM QUE SER COLOCADO "00"       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico TAIFF                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pagano()

Local _cRetano := ""

IF SUBSTR(SE2->E2_CODBAR,01,3) != "237"
   _cRetano := "000"
Else
   _cRetano := "0" + SUBSTR(SE2->E2_CODBAR,26,2)
EndIf

Return(_cRetano)