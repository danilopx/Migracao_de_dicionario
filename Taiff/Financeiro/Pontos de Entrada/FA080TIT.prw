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
		Aviso("Atenção", "O campo numero do cheque é obrigatório para baixa do tipo Normal!" + chr(13) + chr(10) + "Configuração conforme HD 174 da área financeira.",	{"Ok"}, 	3)
		lRetorno := .F.
	EndIf
EndIf

Return (lRetorno)