#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110TOK  �Autor  � Fernando Salvatori � Data �  03/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado na validacao da solicitacao     ���
���          � de compras                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT110TOK
Local _lRet 	:= .T.
Local nx1		:= 0
Local nx		:= 0
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303

If GetNewPar("MV_RESTRSC",.T.) .And. FunName() == "MATA110"
	SAI->( dbSetOrder(2) )
	If ! SAI->( dbSeek( xFilial("SAI") + __cUserID ))
		Alert("O usu�rio "+AllTrim(SubStr(cUsuario,7,15))+" n�o possui um cadastro de solicitante, para prosseguir ser� necess�rio ser cadastrado.")
		_lRet := .F.
	EndIf
EndIf

If lUniNeg
	For nx:= 1 to Len(aCols)
		cUneg := acols[nx][GdFieldPos('C1_ITEMCTA')]
		
		If !aCols[nx][Len(aCols[nx])]
			For nx1 := 1 to Len(aCols)
				
				If Empty(acols[nx1][GdFieldPos('C1_ITEMCTA')]) .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]
					_lRet := .F.
					Help(nil,1,'Unidade de Negocios',nil,'Obrigat�rio preencher unidade de negocios';
					+' Produto '+ acols[nx1][GdFieldPos('C1_PRODUTO')],3,0)
					Exit
					
				ElseIf cUneg <> acols[nx1][GdFieldPos('C1_ITEMCTA')] .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]
					
					_lRet := .F.
					Help(nil,1,'Unidade de Negocios',nil,'N�o � permitido usar unidade de negocios diferentes';
					+' Produto '+ acols[nx1][GdFieldPos('C1_PRODUTO')],3,0)
					Exit
					
				EndIf
			Next nx1
		EndIf
		
		If !_lRet
			Exit
		EndiF
	Next nx
	
EndIf

Return _lRet