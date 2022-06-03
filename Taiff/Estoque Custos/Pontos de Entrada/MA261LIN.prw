#INCLUDE "Protheus.ch"
//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MA261LIN 		                    AUTOR: CARLOS ALDAY TORRES           DATA: 31/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para consistir o usuario que esta realizando a transferencia no modelo II
//| SOLICITANTE: Marcelo Concenição e R. Brito
//| OBSERVACAO: PE executado pela rotina MATA261 - Transferencia entre armazens usuario validado a linha digitada
//| 14.07.14 - revisado com alteração, incluído tratamento de área
//+--------------------------------------------------------------------------------------------------------------

User Function MA261LIN()
Local _aArea     := GetArea()
Local lRet := .T.
Local nLinha := PARAMIXB[1]  // numero da linha do aCols
Local __cLocalOrigem := ""
Local __cVldEmpresas := GETNEWPAR("MV_EMPRZAG","01")
Local __cArmDestino	:= GETNEWPAR("MV_TFARMBL","81")
Local __cLocalDestin := ""

If	Alltrim(cModulo)!="ACD" //Alltrim( _NOMEEXEC ) != 'SIGAACD.EXE' // ctorres - para executar a rotina de transferencias por ACD não utilizar este PE
	If cEmpAnt $ __cVldEmpresas 
		If Alltrim(Upper(FunName())) == "MATA261" .AND. INCLUI
			__cLocalOrigem := aCols[nLinha,4] //M->D3_LOCAL
			If !Empty(__cLocalOrigem)
				ZAF->(DbSeek( xFilial("ZAF") + __CUSERID + __cLocalOrigem )) 
				If ZAF->(found()) .and. ZAF->ZAF_STATUS='1'
					// Usuario do armazem cadastrado pela rotina MATAZAF
				Else
					ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + __cLocalOrigem )) 
					If ZAG->(found()) 
						// Gestor do armazem cadastrado pela rotina MATAZAG
					Else
						Alert("Usuário com restrição de transferência ao local de origem!","Inconsistência")
						lRet:= .F.
					EndIf
				EndIf
			EndIf
			__cLocalDestin := aCols[nLinha,9] //M->D3_LOCAL
			If !Empty(__cLocalDestin) .and. lRet
				If At( Strzero(Val(__cLocalDestin),2) , __cArmDestino ) != 0
					Alert("Armazem destino com restrição de movimentação!","Inconsistência")
					lRet:= .F.
				EndIf
			EndIf
		EndIf
	EndIf
EndIf	

RestArea(_aArea)
Return lRet