#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MC090MNU �Autor  �Anderson Messias    � Data �  20/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para acrescentar Botao na rotina de       ���
���          � consulta de notas de sa�da                                 ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MC090MNU()

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|		Foi necessario voltar o fonte para o Proejto pois o Departamento de 
|	Logistica necessita informar a Data de Entrega para algumas Notas de Saida 
|	onde a mesma nao vem informada no arquivo de EDI.
|
|	Edson Hornberger - 09/02/2015
|=================================================================================
Em 17/04/2015 foi removido o comentario que inibia a fun��o de registro de data de embarque
para atender solicita��o da �rea de log�stica.
*/

aadd(aRotina,{ "Data Entrega","u_DFATNF02()",0,4,0,NIL})
aadd(aRotina,{ "Data Embarque","u_DFATNF01()",0,5,0,NIL}) 

Return