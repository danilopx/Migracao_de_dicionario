#include "protheus.ch"
#Include 'TopConn.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410ALT �Autor  � Fernando Salvatori � Data �  01/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Altera��es do Pedido de Venda                              ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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