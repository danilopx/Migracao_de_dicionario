#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA200   �Autor  �Ivan Morelatto Tore � Data �  31/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para alterar a variavel cConta caso o     ���
���          � campo A6_NCONALT esteja preenchido                         ���
�������������������������������������������������������������������������͹��
���Uso       � FINA200                             	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FINA200

//**************************************
// Variaveis Private do fonte FINA200
//cBanco  := mv_par06
//cAgencia:= mv_par07
//cConta  := mv_par08
//**************************************

dbSelectArea("SA6")
DbSetOrder(1)
IF SA6->( dbSeek(xFilial("SA6") + cBanco + cAgencia + cConta) )

	If !Empty( SA6->A6_NCONALT )	
		cConta := SA6->A6_NCONALT
		If SA6->(FIELDPOS("A6_AGALTER")) != 0
			If !Empty( SA6->A6_AGALTER )
				cAgencia := SA6->A6_AGALTER
			EndIf
		EndIf
		
		//�����������������������������������������������������������Ŀ
		//�Reposiciona o SA6 para a outra conta pois dentro da func�o �
		//�FA070Grv, em alguns pontos, � utilizado o SA6 posicionado. �
		//�������������������������������������������������������������
		SA6->( dbSeek( xFilial( "SA6") + cBanco + cAgencia + cConta ) )
		//CONOUT("FINA200 - " + ALLTRIM(STR(PROCLINE())) + " Reposicionando para conta alternativa...")
	//ELSE
		//CONOUT("FINA200 - " + ALLTRIM(STR(PROCLINE())) + " Manteve a conta atual sem mudar para conta alternativa.")
	Endif
ENDIF
Return
