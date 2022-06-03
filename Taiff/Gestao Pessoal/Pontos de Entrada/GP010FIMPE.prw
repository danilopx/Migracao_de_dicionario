#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010FIMPEºAutor  ³RICARDO DUARTE COSTAº Data ³  15/05/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica e atualiza o cadastro de pessoas com os códigos deº±±
±±º          ³ usuário do portal e código de menu.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GP010FIMPE 

Local cCodPadMenu	:= SuperGetMv("TF_GPEUSRP",,"000003")

//-- Verifica a existência da pessoa e grava as informações de acesso ao portal
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

