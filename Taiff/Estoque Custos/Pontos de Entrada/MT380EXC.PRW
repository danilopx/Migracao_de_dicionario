#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ MT380EXC ³ Autor ³ Paulo Bindo           ³ Data ³ 28/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ P.E. PARA VALIDAR O AJUSTE DE EMPENHO SIMPLES NA EXCLUSAO  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT380EXC()
	Local lRet380 	:= .T.
	Local aArea		:=GetArea("SD4")
	Local aAreaCB7	:= CB7->(GetArea())

	cOp := SD4->D4_OP

	dbSelectArea("SD4")
	dbSetOrder(2)
	dbSeek(xFilial()+cOp)
	While !Eof() .And. SD4->D4_OP == cOp

		If SD4->D4__QTBNFC > 0 .Or. SD4->D4__QTPCBN >0
			lRet380 := .F.
		EndIf
		dbSkip()
	End

	If 	!lRet380
		MsgStop("Esta é uma OP de beneficiamento e já teve material enviado ao fornecedor ou um pedido de compras colocado, a Exclusao de empenho não será permitida!","MT380EXC")
	EndIf

	If 	lRet380 .AND. CB7->(FIELDPOS("CB7__PRESE")) > 0
		CB7->(DbSetOrder(5))
		If CB7->(DbSeek( xFilial("CB7") + cOp ))
			MsgStop("Esta OP já está em processo separação atraves da ONDA: " + CB7->CB7__PRESE,"MT380EXC")
			lRet380 := .F.
		EndIf
	EndIF

	RestArea(aAreaCB7)
	RestArea(aArea)
Return(lRet380)