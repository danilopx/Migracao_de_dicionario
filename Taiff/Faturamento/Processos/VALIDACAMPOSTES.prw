#include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALIDACAMPOSTES �Autor  � Gilberto 	  � Data � 09/08/2011  ���
�������������������������������������������������������������������������͹��
���DESC.     � VALIDA O CAMPO F4_ESTOQUE, CASO J� TENHA SIDO PREENCHIDO   ���
���N�O PERMITE ALTERA��O	  															  ���
���SOMENTE � FEITA A VALIDA��O NO MODO ALTERA��O, CHAMDA NA VALIDA��O DO  ���
���DO USU�RIO�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VF4ESTOQUE

	Local Ret := .T.
   
   If Altera
   	dbSelectArea("SF4")
		SF4->(DbSetOrder(1))                              
	   If SF4->(DbSeek(xFilial("SF4") +  M->F4_CODIGO))
	   	If !Empty(SF4->F4_ESTOQUE) .And. M->F4_ESTOQUE <> SF4->F4_ESTOQUE
	   		Alert("N�o � poss�vel alterar o valor do campo Atu. Estoque")
	   		Ret := .F.
		   EndIf
	   EndIf
	EndIf
			
Return (Ret)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALIDACAMPOSTES �Autor  � Gilberto 	  � Data � 09/08/2011  ���
�������������������������������������������������������������������������͹��
���DESC.     � VALIDA O CAMPO F4_PODER3, CASO J� TENHA SIDO PREENCHIDO    ���
���N�O PERMITE ALTERA��O	  															  ���
���SOMENTE � FEITA A VALIDA��O NO MODO ALTERA��O, CHAMDA NA VALIDA��O DO  ���
���DO USU�RIO�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VF4PODER3

	Local Ret := .T.

   If Altera
   	dbSelectArea("SF4")
		SF4->(DbSetOrder(1))                              
	   If SF4->(DbSeek(xFilial("SF4") +  M->F4_CODIGO))
	   	If !Empty(SF4->F4_PODER3) .And. M->F4_PODER3 <> SF4->F4_PODER3
	   		Alert("N�o � poss�vel alterar o valor do campo Poder Terc.")
	   		Ret := .F.
		   EndIf
	   EndIf
	EndIf
			
Return (Ret)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALIDACAMPOSTES �Autor  � Gilberto 	  � Data � 09/08/2011  ���
�������������������������������������������������������������������������͹��
���DESC.     � VALIDA O CAMPO F4_META, PERMITINDO INCLUIR SOMENTE CONTE�DO��� 
���EXISTENTE NA TABELA ZAJ					                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VF4META

	Local Ret := .T.

   dbSelectArea("ZAJ")
	ZAJ->(DbSetOrder(1))                              
	If !ZAJ->(DbSeek(xFilial("ZAJ") +  M->F4_META))
		Alert("C�digo inv�lido para a Classifica��o da TES.")
	   Ret := .F.
	EndIf
			
Return (Ret)
