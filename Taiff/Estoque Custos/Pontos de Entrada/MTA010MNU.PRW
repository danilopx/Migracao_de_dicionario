/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA010MNU �Autor  �Paulo Bindo         � Data �  29/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que acrescenta botao no cadastro          ���
���          � de Produto                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA010MNU()
Local lOk_MTA010MNU := .F.

Private cUsuLib
If ISINCALLSTACK("MATA010")
	cUsuLib := RetCodUsr()
	
	If 1=1 //U_CHECAFUNC(cUsuLib,"MTA010MNU")
		lOk_MTA010MNU := .T.
	EndIf
	
	
	If lOk_MTA010MNU
		AADD(aRotina,{"Anexo","U_SelArqSQL('SB1'+SB1->B1_FILIAL+SB1->B1_COD,.T., .T.)",0,10,0,NIL}) //ANEXA DOCUMENTOS
	Else
		AADD(aRotina,{"Anexo","U_SelArqSQL('SB1'+SB1->B1_FILIAL+SB1->B1_COD,.F., .F.)",0,10,0,NIL}) //ANEXA DOCUMENTOS
	EndIf
EndIf
Return