#Include "Protheus.ch"
#Include "topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: QN040VLD     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 31/01/2012   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para validar conteudo de campos da rotina QNCA040.PRW
//+--------------------------------------------------------------------------------------------------------------
User Function QN040VLD
Local cMens003 := ""
Local lReturn := .T.
If INCLUI
	If Empty(M->QI2_DESVIO) .and. M->QI2_CODDIS='03'
		cMens003	+= 'Preencha o campo No. do desvio!' + chr(13) + chr(10)
	EndIf
	If M->QI2_QTDAPR = 0 .and. M->QI2_CODDIS='10'
		cMens003	+= 'Preencha o campo Quantidade Parcial!' + chr(13) + chr(10)
	EndIf
ElseIf ALTERA
	If Empty(QI2->QI2_DESVIO) .and. QI2->QI2_CODDIS='03'
		cMens003	+= 'Preencha o campo No. do desvio!' + chr(13) + chr(10)
	EndIf
	If QI2->QI2_QTDAPR = 0 .and. QI2->QI2_CODDIS='10'
		cMens003	+= 'Preencha o campo Quantidade Parcial!' + chr(13) + chr(10)
	EndIf
EndIf
If !Empty(cMens003)
	Aviso("Aviso" , cMens003 , {"Ok"}, 	3)
	lReturn := .F.
EndIf
Return (lReturn)
