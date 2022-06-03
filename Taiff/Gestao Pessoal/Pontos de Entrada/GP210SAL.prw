User Function GP210SAL()

IF Upper( AllTrim( SuperGetMV("MV_CVTPROP") ) ) == "I"		//Calcula de Acordo com os Dias Trabalhados 
	nSalMes := ( (nSalMes / 30) * DiasTrab ) /*/ IF( nDiaUteis # 0, nDiaUteis , 30 )	*/
EndIF


Return