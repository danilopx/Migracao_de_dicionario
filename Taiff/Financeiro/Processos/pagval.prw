#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PAGVAL    �Autor  � Paulo, o Vulcano   � Data �  12/30/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � VALOR DO DOCUMENTO DO CODIGO DE BARRA DA POSICAO 10 - 19,  ���
���          � NO ARQUIVO E DA POSICAO 190 - 204 , QUANDO NAO FOR CODIGO  ���
���          � DE BARRA VAI O VALOR DO SE2 E A POSI�AO DO FATOR DE VENCTO ���                          
�������������������������������������������������������������������������͹��
���Uso       � Especifico TAIFF                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Pagval()

Local _cValor := ""

IF Empty(SE2->E2_CODBAR)
   _cValor := STRZERO((SE2->E2_SALDO*100),15)
Else
   _cValor := "0"+SUBSTR(SE2->E2_CODBAR,6,4)+SUBSTR(SE2->E2_CODBAR,10,10)
EndIf

Return(_cValor)