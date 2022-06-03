#INCLUDE "RWMAKE.CH"
//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MT260TOK 		                    AUTOR: CARLOS ALDAY TORRES           DATA: 03/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para consistir o usuario que esta realizando a transferencia
//| SOLICITANTE: Marcelo Concenição e R. Brito
//| OBSERVACAO: PE executado pela rotina MATA260 - Transferencia entre armazens usuario validado no botão OK
//+--------------------------------------------------------------------------------------------------------------
User Function MT260TOK()
Local lRet:= .T.
Local __cVldEmpresas := GETNEWPAR("MV_EMPRZAG","01")
If cEmpAnt $ __cVldEmpresas
	If !Empty(CLOCORIG)
		ZAF->(DbSeek( xFilial("ZAF") + __CUSERID + CLOCORIG )) 
		If ZAF->(found()) .and. ZAF->ZAF_STATUS='1'
			// Usuario do armazem cadastrado pela rotina MATAZAF
		Else
			ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + CLOCORIG )) 
			If ZAG->(found()) 
				// Gestor do armazem cadastrado pela rotina MATAZAG
			Else
				Alert("Usuário com restrição de transferência ao local de origem!","Inconsistência")
				lRet:= .F.
			EndIf
		EndIf
	EndIf
EndIf
Return lRet