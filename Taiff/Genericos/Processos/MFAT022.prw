/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MFAT022 - Funcoes da Entregas Fracionadas				  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para tratamento da Entrega Fracionada e liberacao º±±
±±º          | de credito no pedido de vendas					          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MFAT022

Return nil

User Function QtdEmbSB5(cProduto)
Local cFilSB5:=xFilial('SB5')
Local nQE:=0

If Sb5->(dbseek(cFilSB5+cProduto))
   nQE:=Sb5->b5_qe1   
Endif

Return nQE

User Function CalcMultLib(cProduto,nQtd)

Local nQtdLib:=0
Local nMultiplo

Local nQE:=U_QtdEmbSB5(cProduto)

nMultiplo:= Int(nQtd/nQE)
nQtdLib:=nQE*nMultiplo

Return nQtdLib

User Function EntFracCli(xCliente)  
Local nRecA1:=Sa1->(Recno())
Local lRet:=.t.

Sa1->(dbsetorder(1)) 
SA1->(dbseek(xFilial('SA1')+xCliente))

//lRet:=Sa1->A1_ENTFRAC == "S"    // Cliente Nao Aceita Entrega Fracionada

// Comentado em 26/10/2010 por que nao foi encontrado na base de producao o campo A1_ENTFRAC
lRet:=.T.    // Cliente Nao Aceita Entrega Fracionada

Sa1->(dbgoto(nRecA1))

Return lRet


User Function MsgNaoFrac()
Local aSays   :={}
Local aButtons:={}
Local cTexto1 :="O Cliente deste Pedido nao aceita Entrega Fracionada. "
Local lExibeMsg:=.f.

Local cCli:=IF((IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006")) ,SC5->C5_CLIENTE,M->C5_CLIENTE)
Local cTexto2   :=""
Local nPProduto	:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local cProduto  := aCols[n][nPProduto]
Local nQE       :=U_QtdEmbSB5(cProduto)  // Qtde de Itens por Embalagem
Local cPict      :=AvSx3("B5_QE1",6)

cTexto2+="A quantidade liberada para o produto["+Alltrim(cProduto)+"] sera calculada automaticamente pelo Sistema. A Qtde Calculada nao "
cTexto2+="pode ser inferior a Qtde Total por Embalagem ["+Alltrim(Trans(nQE,cPict))+"] PECAS "
   
If ! U_EntFracCli(cCli)  
//If FunName() == "MATA440" .and. ! U_EntFracCli(SC5->C5_CLIENTE) 
//   AADD(aSays, cTexto1 ) 
//   AADD(aSays, cTexto2 ) 

//   AADD(aButtons, { 1,.T.,{|o| nOpca := 1 , o:oWnd:End()}} )
//   AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

//   FormBatch( cCadastro, aSays, aButtons )
   U_MsgHBox(cTexto1+cTexto2)
Endif

Return .t.

User Function VldQtEntFrac()
Local nValorDig  :=&(ReadVar())                          
Local nDeleted   :=Len(aHeader)+1
Local cTexto1 :="O Cliente deste Pedido nao aceita Entrega Fracionada. "
Local cTexto2 :="A quantidade liberada sera calculada automaticamente pelo Sistema"

Local nPProduto	 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPLocal	 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPosQtdVen :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Local nQtdLib, nQtdVen, cProduto, cLocal
Local nQuantB2   :=0
Local cFilSB2    :=xFilial("SB2")
Local cPictQt    :=AvSx3("C6_QTDLIB",6)
Local cPictEmb   :=AvSx3("B5_QE1",6)

Local nQE

If aCols[n][nDeleted]
   Return .t.
Endif

If Empty( nValorDig )
   Return .t.
Endif

If U_EntFracCli(M->C5_CLIENTE)    // Se o Cliente Aceitar Entrega Fracionada Nao precisa calcular a Qtde Liberada
   Return .t.
Endif

cProduto:= aCols[n][nPProduto]
cLocal  := aCols[n][nPLocal]
nQtdVen := aCols[n][nPosQtdVen]
      
If SB2->(dbSeek(cFilSB2+cProduto+cLocal))
   nQuantB2:=SaldoSB2()
EndIf    

/*
If nValorDig > nQtdVen
   MsgStop("QTDE INFORMADA NAO PODE SER SUPERIOR A QTDE DO PEDIDO","Atencao")
   Return .f.
Endif
*/

nQE:=U_QtdEmbSB5(cProduto)  // Qtde de Itens por Embalagem
   
nQtdLib := nValorDig

If nQuantB2 < nQtdVen
   nQtdLib:=nQuantB2
Endif
    
nNvQtdLib:= U_CalcMultLib(cProduto,nQtdLib)    // Funcao Definida no fonte MFAT022.PRW - ROBSON SANCHEZ  - 08/01/10

If nNvQtdLib < nQE 
//   MsgStop("A QTDE LIBERADA ESTA MENOR DO QUE A QTDE DE ITENS POR EMBALAGEM"+,"Atencao")
   cTexto1:="A qtde disponivel/Estoque para  este produto ["+Alltrim(Trans(nQtdLib,cPictQt))+"] é inferior a qtde total de itens por embalagem ["+Alltrim(Trans(nQE,cPictEmb))+"] pecas. "
   cTexto2:="Este produto nao podera ser liberado.Verifique a qtde disponivel em estoque "
   U_MsgHBox(cTexto1+cTexto2)
   Return .f.
Endif

If nNvQtdLib <> nValorDig
   cTexto1:="A qtde Calculada para  este produto ["+Alltrim(Trans(nNvQtdLib,cPictQt))+"] é multipla da qtde total de itens por embalagem ["+Alltrim(Trans(nQE,cPictEmb))+"] pecas. "
   cTexto2:=""
   U_MsgHBox(cTexto1+cTexto2)
Endif

  
aCols[n][nPosQtdLib]:=nNvQtdLib
M->C6_QTDLIB:=nNvQtdLib

Return .t.

User Function VldLibCred()
Local nValorDig  :=&(ReadVar())                          
Local cTexto1:=""
Local nPosRegra1 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRMRC"})
Local nPosPrcVen :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local cBlqCred   := ""
Local nValAV	 := 0

Local nValR,cValorR,nValPrcVen, lCredito

// Validacao da Liberacao de Credito  
If FunName() == "MATA410"  // Quando for liberado pelo Pedido de Vendas Bloquear a qtde liberada
   If ! Empty( nValorDig )
      cTexto1:="Devido a Consistencia de Liberacao de Credito, Este Pedido so pode ser liberado pela Rotina de Liberacao de Pedido "
      U_MsgHBox(cTexto1)
      Return .f.
   Endif
Endif

nValPrcVen:= aCols[n][nPosPrcVen]
cValorR   := aCols[n][nPosRegra1]
nValR     := U_GRetVal(cValorR)
nValAv    := (nValPrcVen+nValR)*nValorDig

lCredito  := MaAvalCred(M->C5_CLIENTE,M->C5_LOJACLI,nValAv,M->C5_MOEDA,.T.,@cBlqCred)

If ! lCredito
   cTexto1:="Cliente nao possui credito suficiente para liberacao deste item/produto "
   U_MsgHBox(cTexto1)
   Return .f.
Endif

Return .t.