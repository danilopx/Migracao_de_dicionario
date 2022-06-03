#Include 'Protheus.ch'
#INCLUDE "Topconn.ch"

#DEFINE ENTER chr(13) + chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATCO440 �Autor  �Carlos Torres       � Data �  26/04/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca e apresenta a �ltima data de libera��o do pedido     ���
���          � Usada na rotina TFGERAOS relativa � tarefa do PMS 030603   ���
�������������������������������������������������������������������������͹��
���Uso       � Em campo virtual da tabela SC5 - C5_C9DTLIB                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FATCO440( cC5_Pedido )
Local dDataLib := CTOD("  /  /  ")
Local cQuery := ""

If FUNNAME() $ "TFGERAOS"
	cQuery := " SELECT ISNULL(MAX(C9_DATALIB),'') AS C9_DATALIB " + ENTER
	cQuery += " FROM "+RetSqlName("SC9")+ " SC9 " + ENTER
	cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9") + "' " + ENTER
	cQuery += " AND SC9.D_E_L_E_T_ = '' " + ENTER
	cQuery += " AND C9_PEDIDO = '" + cC5_Pedido + "' " + ENTER
	cQuery += " AND C9_NFISCAL = '' " + ENTER
	
	//MEMOWRITE( "FATCO440_SELECT_SC9.SQL",cQuery)
	
	If Select("SQLFT44") != 0
		SQLFT44->(DbCloseArea()) 
	EndIf
	
	TcQuery cQuery New Alias "SQLFT44" 
	TcSetField("SQLFT44", "C9_DATALIB", "D")
	
	dDataLib := Iif( !Empty(SQLFT44->C9_DATALIB),SQLFT44->C9_DATALIB,dDataLib)
EndIf

Return (dDataLib)

