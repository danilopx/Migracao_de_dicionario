#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Programa � MT380INC � Autor � Paulo Bindo           � Data � 28/09/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � P.E. PARA VALIDAR O AJUSTE DE EMPENHO SIMPLES              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT380INC()
	Local lRet380 	:= .T.
	Local aArea		:=GetArea("SD4")
	Local aAreaCB7	:= CB7->(GetArea())

	cOp := M->D4_OP

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
		MsgStop("Esta � uma OP de beneficiamento e j� teve material enviado ao fornecedor ou um pedido de compras colocado, o ajuste de empenho n�o ser� permitido!","MT380INC")
	EndIf

	If 	lRet380 .AND. CB7->(FIELDPOS("CB7__PRESE")) > 0
		CB7->(DbSetOrder(5))
		If CB7->(DbSeek( xFilial("CB7") + cOp ))
			MsgStop("Esta OP j� est� em processo separa��o atraves da ONDA: " + CB7->CB7__PRESE,"MT380INC")
			lRet380 := .F.
		EndIf
	EndIF

	RestArea(aAreaCB7)	
	RestArea(aArea)
Return(lRet380)