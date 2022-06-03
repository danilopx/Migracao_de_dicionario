#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA201MNU �Autor  �Carlos Torres       � Data �  11/03/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada que acrescenta botao no cadastro          ���
���          � da revis�o de estrutura                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MTA201MNU()
Local lOk_MTA201MNU := .F.

Private cUsuLib
	cUsuLib := RetCodUsr()
	
	If 1=1 // U_CHECAFUNC(cUsuLib,"MTA201MNU")
		lOk_MTA201MNU := .T.
	EndIf
	
	
	If lOk_MTA201MNU
		AADD(aRotina,{"Anexo","U_SelArqSQL('SG5'+SG5->G5_FILIAL+SG5->G5_PRODUTO+SG5->G5_REVISAO,.T., .T.)",0,10,0,NIL}) //ANEXA DOCUMENTOS
	Else
		AADD(aRotina,{"Anexo","U_SelArqSQL('SG5'+SG5->G5_FILIAL+SG5->G5_PRODUTO+SG5->G5_REVISAO,.F., .F.)",0,10,0,NIL}) //ANEXA DOCUMENTOS
	EndIf
Return
