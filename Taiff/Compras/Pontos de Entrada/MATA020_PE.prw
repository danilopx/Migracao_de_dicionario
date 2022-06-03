#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MATA020_PE  บAutor  ณCarlos Torres   บ Data ณ  29/11/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Na rotina MATA020 o ponto de entrada no Padrใo MVC o nome  บฑฑ
ฑฑบ          ณ da user function ้ CUSTOMERVENDOR que ้ o o ID do Modelo   บฑฑ
ฑฑบ          ณ de Dados                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/* 
	Ver link de referencia para este c๓digo fonte
	http://tdn.totvs.com/display/public/PROT/ADV0044_PE_MVC_MATA020_P12 
*/
User Function CUSTOMERVENDOR()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ''
	Local cIdPonto := ''
	Local cIdModel := ''
	Local lIsGrid := .F.

	//Local nLinha := 0
	//Local nQtdLinhas := 0
	//Local cMsg := ''
	Local nOPCx	:= 0

	If aParam <> NIL

		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )

		If cIdPonto == 'MODELPOS'
			/*
			cMsg := 'Chamada na valida็ใo total do modelo.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/
		ElseIf cIdPonto == 'FORMPOS'
			/*
			cMsg := 'Chamada na valida็ใo total do formulแrio.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			If lIsGrid
				cMsg += 'ษ um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			Else
				cMsg += 'ษ um FORMFIELD' + CRLF
			EndIf

			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/

		ElseIf cIdPonto == 'FORMLINEPRE'
			/*
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pre valida็ใo da linha do formulแrio. ' + CRLF
				cMsg += 'Onde esta se tentando deletar a linha' + CRLF
				cMsg += 'ID ' + cIdModel + CRLF
				cMsg += 'ษ um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
				xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			EndIf
			*/
		ElseIf cIdPonto == 'FORMLINEPOS'
			/*
			cMsg := 'Chamada na valida็ใo da linha do formulแrio.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			cMsg += 'ษ um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/

		ElseIf cIdPonto == 'MODELCOMMITTTS'
			/*
			ApMsgInfo('Chamada apos a grava็ใo total do modelo e dentro da transa็ใo.')
			*/
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			/*
			ApMsgInfo('Chamada apos a grava็ใo total do modelo e fora da transa็ใo. - ' + IIF(ALTERA,"alteracao",IIF(INCLUSAO,"inclusao","")))
			*/
			If CEMPANT = "01" 
				nOPCx := IIF(ALTERA,4,IIF(INCLUI,3,0))
				Processa({|| U_TPPROCREP("SA2","U_CADSA2",nOPCx) },"Replicando para as demais empresas...")
			EndIf		
		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
			/*
			ApMsgInfo('Chamada apos a grava็ใo da tabela do formulแrio.')
			*/
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			/*
			ApMsgInfo('Chamada apos a grava็ใo da tabela do formulแrio.')
			*/
		ElseIf cIdPonto == 'MODELCANCEL'
			/*
			cMsg := 'Deseja Realmente Sair ?'
			xRet := ApMsgYesNo( cMsg )
			*/
		ElseIf cIdPonto == 'BUTTONBAR'
			/*
			xRet := { {'Salvar', 'SALVAR', { || u_TESTEX_1() } } }
			*/
		EndIf
	EndIf
Return xRet

User Function TESTEX_1()
	ALert ("passou")
Return
