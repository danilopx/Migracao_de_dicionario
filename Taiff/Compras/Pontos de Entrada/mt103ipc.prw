#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT103IPC ºAutor  ³ Fernando Salvatori º Data ³ 17/11/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado apos a insercao da linha do     º±±
±±º          ³ documento de entrada baseado em um pedido de compras       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103IPC
	
	Local _aArea  		:= GetArea()
	Local _aArSB1 		:= SB1->(GetArea()) // Eduardo Alberti Em 10/Jul/2014
	Local nItem   		:= ParamIXB[1] //Numero do item processado
	Local nPosDs  		:= aScan(aHeader,{|X| AllTrim(X[2]) == "D1_DESCR"})		//Posicao do valor unitario
	Local nPosClassi	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CLASCON" }) 	// variavel com a posicao do campo a ser atualizado no SD1
	Local nPosOP		:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_OP" }) 		// variavel com a posicao do campo a ser atualizado no SD1
	
	
	aCols[nItem,nPosDS] 	 := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC")
	aCols[nItem][nPosClassi] := SC7->C7_CLASCON
	aCols[nItem][nPosOP] 	 := SC7->C7__OPBNFC
	
	RestArea(_aArSB1)	// Eduardo Alberti Em 10/Jul/2014
	RestArea(_aArea)
	
Return Nil
