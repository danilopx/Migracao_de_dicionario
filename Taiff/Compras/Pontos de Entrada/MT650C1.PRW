/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT650C1   ºAutor  ³Marcos J.           º Data ³  11/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para corrigir SB2, solicitacoes sendo geradas no armazemº±±
±±º          ³padrao ao inves de onde foi empenhado.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "protheus.ch"
User Function MT650C1()
	Local cAlias := Alias()
	Local aAreaB1:= SB1->(GetArea()) //"SB1")
	Local aAreaB2:= SB2->(GetArea()) //"SB2")

	If (SM0->M0_CODIGO == "01" .OR. (SM0->M0_CODIGO == "04" .AND. xFilial("SB1")='02'))
	    If GetMV("MV_GERASC")  //Gera SC na inclusão da OP
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + SC1->C1_PRODUTO, .F.))
		
			SB2->(DbSetOrder(1))
			If SB2->(DbSeek(xFilial("SB2") + SC1->(C1_PRODUTO + C1_LOCAL), .F.))
				SB2->(RecLock("SB2", .F.))
				SB2->B2_SALPEDI -= SC1->C1_QUANT
				SB2->(MsUnLock())
			Else
				
			EndIf
		
			If SB1->B1_LOCPAD != SC1->C1_LOCAL		
				SC1->(RecLock("SC1", .F.))
				SC1->C1_LOCAL   := SB1->B1_LOCPAD
				SC1->(MsUnLock())
		
				SB2->(DbSetOrder(1))
				If SB2->(DbSeek(xFilial("SB2") + SC1->(C1_PRODUTO + C1_LOCAL), .F.))
					SB2->(RecLock("SB2", .F.))
					SB2->B2_SALPEDI += SC1->C1_QUANT
					SB2->(MsUnLock())
				Else
					CriaSB2(SC1->C1_PRODUTO, SC1->C1_LOCAL)
		
					If SB2->(DbSeek(xFilial("SB2") + SC1->(C1_PRODUTO + C1_LOCAL), .F.))
						SB2->(RecLock("SB2", .F.))
						SB2->B2_SALPEDI += SC1->C1_QUANT
						SB2->(MsUnLock())
					EndIf
				EndIf
			EndIf
		EndIf
		If SC1->(FieldPos("C1_DTVALID")) > 0
			SC1->(RecLock("SC1", .F.))
			SC1->C1_DTVALID := SC1->C1_DATPRF - SB1->B1_PE
			SC1->(MsUnLock())
		EndIf
	EndIf

	RestArea(aAreaB1)
	RestArea(aAreaB2)	
	DbSelectArea(cAlias)
	Return