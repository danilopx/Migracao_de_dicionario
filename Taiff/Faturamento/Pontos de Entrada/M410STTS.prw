#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  º Autor ³ Paulo Bindo        º Data ³  19/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PPONTO ENTRADA APOS A GRAVACAO DO PEDIDO DE VENDAS         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function M410STTS()
	Local cProd
	Local cOp
	Local cPedido
	Local n := 0

//QUANDO NAO FOR BENEFICIAMENTO OU COPIA DE PEDIDOS SAIR DA ROTINA OU NAO FOR ACTION
	If M->C5_TIPO # "B" .Or. IsInCallStack("A410COPIA") .Or. !(cEmpAnt == "04" .and. cFilAnt='02')
		Return
	EndIf

//PARA PEDIDO DE BENEFICIAMENTO GRAVA A QUANTIDADE ENVIADA NA SD4
	If  IsInCallStack("MATA410")
		nOld := n
		For n:= 1 To Len(aCOLS)
			cOp 	:= BuscaCols("C6__OPBNFC")
			cProd 	:= BuscaCols("C6_PRODUTO")
			cPedido := M->C5_NUM
			If !Empty(cOP)
				dbSelectArea("SD4")
				dbSetOrder(2)
				If dbSeek(xFilial()+cOp+cProd)
					RecLock("SD4",.F.)
					If INCLUI .And. !aCols[n][Len(aCols[n])]
						D4__QTBNFC := D4__QTBNFC+BuscaCols("C6_QTDVEN")
					ElseIf ALTERA
						If !aCols[n][Len(aCols[n])]
							D4__QTBNFC := U_CalcBnfc(cOp,cProd,cPedido,"V")+BuscaCols("C6_QTDVEN")
						Else
							D4__QTBNFC := D4__QTBNFC- BuscaCols("C6_QTDVEN")
						EndIf
					Else //EXCLUI
						D4__QTBNFC := D4__QTBNFC- BuscaCols("C6_QTDVEN")
					EndIf
					SD4->(MsUnlock())
				EndIf
			EndIf

		NEXT nI
		n:= nOld
	EndIf

Return