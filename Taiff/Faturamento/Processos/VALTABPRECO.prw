#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VALTABPRECO � Autor � Gilberto R. Jr   �Data � 28/04/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida se o produto j� existe na tabela de pre�o		     ���
�������������������������������������������������������������������������͹��
���Uso       � Valida��o do campo (DA1_CODPRO)                            ���
�������������������������������������������������������������������������͹��
���  *********     DOCUMENTACAO DE MANUTENCAO DO PROGRAMA     *********   ���
�������������������������������������������������������������������������͹��
���Consultor �   Data   � Hora  � Detalhes da Alteracao                   ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
 
// Chamada da fun��o => U_ValTabPreco()

User Function ValTabPreco() // In�cio do Programa
	   
	Local nPosCod  	:= aScan(aHeader,{|x|AllTrim(x[2])=="DA1_CODPRO"}) //Posi��o da coluna que eu quero obter o conte�do (CODIGO PRODUTO)
  	Local nPosItem 	:= aScan(aHeader,{|x|AllTrim(x[2])=="DA1_ITEM"}) //Posi��o da coluna que eu quero obter o conte�do (ITEM)
	Local nCount		:= 1 //Contador 
	Local nLinhasGrid := Len(aCols) //N�mero de linhas no Grid da tela
    Local nLinhaAtual := N //Linha atual           
    Local mProduto	   := M->DA1_CODPRO //C�digo do produto na Linha atual
   	Local nProduto		:= "" //C�digo do produto para cada linha
           
   	If (FunName()=="OMSA010")
			While (nLinhasGrid > nCount)
				nProduto := aCols[nCount, nPosCod]                                                        
				If (nLinhaAtual <> nCount .AND. nProduto == mProduto)
			   	msgalert("Produto j� cadastrado na tabela. (Produto: " + ALLTRIM(nProduto) + " - Item: " + aCols[nCount, nPosItem] + ")") //Printa o conte�do
			   	M->DA1_CODPRO := ""
			   	Return .F.
			 	EndIf
			   nCount := nCount + 1    
			End                   
		EndIf		
Return .T.
