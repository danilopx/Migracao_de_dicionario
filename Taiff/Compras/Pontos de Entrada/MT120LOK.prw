#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT120LOK   | Autor � Richard Nahas Cabral� Data �13/09/2010���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada para validacao da linha no pedido de      ���
���          � compras. Utilizado para nao permitir produtos nao definido ���
���          � para o grupo de compras                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico do TAIFF                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT120LOK()
	
	Local aArea, aAreaSAJ, lRet, lComp, cUser, cProduto, cGrupo, cRestr
	lRet := .T.
	
	//VALIDA SE O CAMPO DE OP NOS CASOS DE BENEFICIAMENTO DA ACTION ESTAO PREENCHIDOS, E SE A QUANTIDADE ESTA CORRETA
	If cEmpAnt == "04" .and. cFilAnt='02' .And. !Empty(BuscaCols("C7__OPBNFC"))
		If !aCols[n][Len(aCols[n])]
			cOp := BuscaCols("C7__OPBNFC")
			cProd := BuscaCols("C7_PRODUTO")
			cPedido := cA120Num
			//VALIDA QUANTIDADE
			dbSelectArea("SD4")
			dbSetOrder(2)
			If dbSeek(xFilial()+cOp+cProd)
				If SD4->D4_QTDEORI < U_CalcBnfc(cOp,cProd,cPedido,"C")+BuscaCols("C7_QUANT")
					MsgStop("A quantidade digitada � maior que a gerada da OP","MT120LOK")
					lRet := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
	
	If GetMv("MV_BLOQCOM",,"N") = "S" .And. GetMv("MV_RESTSOL") = "S" .And. lRet
		
		aArea	 := GetArea()
		aAreaSAJ := SAJ->(GetArea())
		
		nPosProd = Ascan(aHeader, {|x| Alltrim(x[2]) = "C7_PRODUTO"})
		
		cProduto	:= aCols[n,nPosProd]
		cGrupo		:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRUPO")
		cRestr		:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_SOLICIT")
		
		If cRestr = "S"
			
			lRet	:= .F.
			lComp	:= .F.
			
			cUser := RetCodUsr()
			DbSelectArea("SAJ")
			SAJ->(DbSetOrder(2))
			
			SAJ->(DbSeek(xFilial("SAJ")+cUser))
			Do While SAJ->(AJ_FILIAL + AJ_USER) = xFilial("SAJ")+cUser .And. ! SAJ->(Eof())
				
				lComp := .T.
				If (SAJ->AJ_PRODUTO = cProduto) .Or. (SAJ->AJ_GRUPO = cGrupo .And. Alltrim(SAJ->AJ_PRODUTO) = "*")
					lRet := .T.
					Exit
				EndIf
				
				SAJ->(DbSkip())
			EndDo
			
			If ! lRet
				If ! lComp
					MsgAlert("Usu�rio n�o pertence a nenhum grupo de compras !!!")
				Else
					MsgAlert("Produto n�o permitido para este comprador !!!")
				EndIf
			EndIf
			
			SAJ->(RestArea(aAreaSAJ))
			RestArea(aArea)
			
		EndIf
		
	EndIf
	
Return lRet
