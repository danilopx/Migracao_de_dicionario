#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: FA080TIT     				                          AUTOR: CARLOS TORRES           DATA: 15/05/2012   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE executado na rotina de baixa de titulos do contas a pagar, para aplicar regra do chamado HD 174
//+--------------------------------------------------------------------------------------------------------------

User Function FA080TIT
Local lRetorno := .T.

If Type('lF080Auto') =='U' .or. !lF080Auto
	If cMotBx = "N" .and. Empty(cCheque)
		Aviso("Aten��o", "O campo numero do cheque � obrigat�rio para baixa do tipo Normal!" + chr(13) + chr(10) + "Configura��o conforme HD 174 da �rea financeira.",	{"Ok"}, 	3)
		lRetorno := .F.
	EndIf
EndIf

Return (lRetorno)