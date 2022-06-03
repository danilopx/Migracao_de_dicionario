#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TaiffPerg � Autor � Bruno Lazarini     � Data �  18/04/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o de Pergunta.			                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros� Nao ha										              ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                     ���
�������������������������������������������������������������������������͹��
���Aplicacao �                                  		                  ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                         ���
�������������������������������������������������������������������������͹��
���          �        �      �                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������                           
*/                                
User Function TaiffPerg()

Local cPerg := 'TAIFFPERG'

AjustaSx1( cPerg ) // Chama funcao de pergunta

If pergunte(cPerg,.T.) 

	If MV_PAR01 == 1
 		U_TAIFFR4()
	ElseIf MV_PAR01 == 2
		U_TAIFFR5()
	Elseif MV_PAR01 == 3
		U_TAIFFR6()	
	Endif
    
Endif
   
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �AjustaSX1 � Autor � Microsiga             � Data �26/10/10  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Monta perguntas no SX1.                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSx1(cPerg)  

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 

//---------------------------------------MV_PAR01-------------------------------------------------- OK
aHelpPor := {'Escolha o Tipo de Relat�rio?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Escolha o Tipo de Relat�rio ? ","","","mv_ch01"	,"C",01,0,0,"C","","","","","MV_PAR01","1-Com. Pagas","","","","2-Com. Devidas","","","3-Com. Em Aberto","","","","","") 

RestArea(aAreaAnt)

Return()