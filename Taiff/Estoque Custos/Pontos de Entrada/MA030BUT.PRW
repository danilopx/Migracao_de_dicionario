#Include 'Protheus.ch'

User Function MA030BUT()

	aButtons := {}
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT08",.F.,"")
		Aadd( aButtons, { "SIMULACAO" , {|| U_FINMI001(SA1->A1_COD, SA1->A1_LOJA,"S") }, "Analise de Credito Consolidada", "Consolidado"})
	EndIf
Return(aButtons)

