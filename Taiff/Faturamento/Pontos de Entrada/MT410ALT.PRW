#include "protheus.ch"
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410ALT ºAutor  ³ Fernando Salvatori º Data ³  01/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alterações do Pedido de Venda                              º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410Alt()

If SM0->M0_CODIGO = "05" // ctorres - 19/06/2011 Somente a empresa BeautyFair usa a tabela ZBB (contratos)
	ZBB->( dbSetOrder(1) )
	If ZBB->( dbSeek( xFilial("ZBB") + SC5->C5_NUM ) )
		ZBB->( RecLock("ZBB",.F.) )
		ZBB->( dbDelete() )
		ZBB->( MsUnlock() )
		
		ZBA->( dbSetOrder(1) )
		ZBA->( dbSeek( xFilial("ZBA") + SC5->C5_NUM ) )
		Do While ZBA->( !Eof() ) .And. ZBA->( ZBA_FILIAL + ZBA_PEDIDO ) == xFilial("ZBA") + SC5->C5_NUM
			ZBA->( RecLock("ZBA",.F.) )
			ZBA->( dbDelete() )
			ZBA->( MsUnlock() )
			ZBA->( dbSkip() )
		EndDo
	EndIf
EndIf

Return Nil