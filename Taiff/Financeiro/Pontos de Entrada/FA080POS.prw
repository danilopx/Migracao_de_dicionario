#include 'protheus.ch'
#include 'parmtype.ch'

user function FA080POS()
Local nTaxaDi := 0
Local nVlrJurDI := 0
Local nVlrSld   := 0


IF SE2->E2_XENDVDG == "S"	 	
	
	nTaxaDi := U_AENDVTXDI(SE2->E2_EMISSAO,DDATABASE,SE2->E2_NUM,.T.,6)
	nVlrSld := U_AENDVSLD() + SE2->E2_SALDO + SE2->E2_ACRESC
	
	//MsgAlert("Valor do Saldo " + STR(nVlrSld) + "TAXA DI " + str(nTaxaDi) )
	
	If nTaxaDi > 0  
		nVlrJurDI := (nVlrSld * (nTaxaDi/100) )  //- nVlrSld
		nJuros	  := nVlrJurDI 
		nValPgto  := nValLiq + nVlrJurDI
		nValLiq	  := nValLiq + nVlrJurDI		
		
	EndIf
EndIf	
	
return