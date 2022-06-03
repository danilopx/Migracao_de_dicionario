#Include 'Protheus.ch'

User Function FA050INC()
Local lRetorno := .T.
//Local cParFil := ""

IF INCLUI
	lRetorno := U_TFCCUSTO(cempant,cfilant,M->E2_CCC)
	
	If lRetorno
		lRetorno := U_TFCCUSTO(cempant,cfilant,M->E2_CCD)
	EndIf 

EndIf	

Return (lRetorno)

