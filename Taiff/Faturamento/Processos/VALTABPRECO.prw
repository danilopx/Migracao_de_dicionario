#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VALTABPRECO º Autor ³ Gilberto R. Jr   ºData ³ 28/04/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o produto já existe na tabela de preço		     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Validação do campo (DA1_CODPRO)                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  *********     DOCUMENTACAO DE MANUTENCAO DO PROGRAMA     *********   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºConsultor ³   Data   ³ Hora  ³ Detalhes da Alteracao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
// Chamada da função => U_ValTabPreco()

User Function ValTabPreco() // Início do Programa
	   
	Local nPosCod  	:= aScan(aHeader,{|x|AllTrim(x[2])=="DA1_CODPRO"}) //Posição da coluna que eu quero obter o conteúdo (CODIGO PRODUTO)
  	Local nPosItem 	:= aScan(aHeader,{|x|AllTrim(x[2])=="DA1_ITEM"}) //Posição da coluna que eu quero obter o conteúdo (ITEM)
	Local nCount		:= 1 //Contador 
	Local nLinhasGrid := Len(aCols) //Número de linhas no Grid da tela
    Local nLinhaAtual := N //Linha atual           
    Local mProduto	   := M->DA1_CODPRO //Código do produto na Linha atual
   	Local nProduto		:= "" //Código do produto para cada linha
           
   	If (FunName()=="OMSA010")
			While (nLinhasGrid > nCount)
				nProduto := aCols[nCount, nPosCod]                                                        
				If (nLinhaAtual <> nCount .AND. nProduto == mProduto)
			   	msgalert("Produto já cadastrado na tabela. (Produto: " + ALLTRIM(nProduto) + " - Item: " + aCols[nCount, nPosItem] + ")") //Printa o conteúdo
			   	M->DA1_CODPRO := ""
			   	Return .F.
			 	EndIf
			   nCount := nCount + 1    
			End                   
		EndIf		
Return .T.
