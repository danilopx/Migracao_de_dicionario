#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP010FIMPE�Autor  �RICARDO DUARTE COSTA� Data �  15/05/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica e atualiza o cadastro de pessoas com os c�digos de���
���          � usu�rio do portal e c�digo de menu.                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GP010FIMPE 

Local cCodPadMenu	:= SuperGetMv("TF_GPEUSRP",,"000003")

//-- Verifica a exist�ncia da pessoa e grava as informa��es de acesso ao portal
IF INCLUI
	RD0->(DbSetOrder(6))
	If RD0->(DbSeek(xFilial("RD0",SRA->RA_FILIAL)+SRA->RA_CIC))
		While xFilial("RD0",SRA->RA_FILIAL)+SRA->RA_CIC == RD0->RD0_FILIAL+RD0->RD0_CIC
			If Empty(RD0->RD0_LOGIN) .Or. Empty(RD0->RD0_PORTAL)
				RecLock("RD0",.F.)
				RD0->RD0_LOGIN		:= SRA->RA_CIC
				RD0->RD0_PORTAL		:= cCodPadMenu
				RD0->(DbCloseArea())
			Endif
			RD0->(DbSkip())
		Enddo
	Endif
Endif

Return

