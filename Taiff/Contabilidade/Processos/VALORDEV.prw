#include "protheus.ch"

User Function VALORDEV()

	Local nValorDev := 0  
	Local aArea := GetArea()
	Local aAreaSE3 := SE3->(GetArea())
	
	SE3->(dbSetOrder(1)) 
	If SE3->(dbSeek(xFilial("SE3") + SF1->(F1_SERIE + F1_DOC)))
		
		While SE3->(!EOF()) .and. SE3->E3_FILIAL == xFilial("SE3") .and. SE3->(E3_PREFIXO + E3_NUM) == SF1->(F1_SERIE + F1_DOC)
		
			If SE3->(E3_CODCLI + E3_LOJA) == SF1->(F1_FORNECE + F1_LOJA) .and. AllTrim(SE3->E3_TIPO) == "NCC"
	
				nValorDev += (SE3->E3_COMIS * -1)
			
			EndIf
		
			SE3->(dbSkip())
		EndDo
		
	EndIf	                         
	
	RestArea(aAreaSE3)
	RestArea(aArea)	

Return nValorDev