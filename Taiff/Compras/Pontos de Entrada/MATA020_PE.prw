#Include 'Protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MATA020_PE  �Autor  �Carlos Torres   � Data �  29/11/2017  ���
�������������������������������������������������������������������������͹��
���Desc.     � Na rotina MATA020 o ponto de entrada no Padr�o MVC o nome  ���
���          � da user function � CUSTOMERVENDOR que � o o ID do Modelo   ���
���          � de Dados                                                   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/* 
	Ver link de referencia para este c�digo fonte
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
			cMsg := 'Chamada na valida��o total do modelo.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/
		ElseIf cIdPonto == 'FORMPOS'
			/*
			cMsg := 'Chamada na valida��o total do formul�rio.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF

			If lIsGrid
				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			Else
				cMsg += '� um FORMFIELD' + CRLF
			EndIf

			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/

		ElseIf cIdPonto == 'FORMLINEPRE'
			/*
			If aParam[5] == 'DELETE'
				cMsg := 'Chamada na pre valida��o da linha do formul�rio. ' + CRLF
				cMsg += 'Onde esta se tentando deletar a linha' + CRLF
				cMsg += 'ID ' + cIdModel + CRLF
				cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
				cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
				xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			EndIf
			*/
		ElseIf cIdPonto == 'FORMLINEPOS'
			/*
			cMsg := 'Chamada na valida��o da linha do formul�rio.' + CRLF
			cMsg += 'ID ' + cIdModel + CRLF
			cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
			cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			*/

		ElseIf cIdPonto == 'MODELCOMMITTTS'
			/*
			ApMsgInfo('Chamada apos a grava��o total do modelo e dentro da transa��o.')
			*/
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			/*
			ApMsgInfo('Chamada apos a grava��o total do modelo e fora da transa��o. - ' + IIF(ALTERA,"alteracao",IIF(INCLUSAO,"inclusao","")))
			*/
			If CEMPANT = "01" 
				nOPCx := IIF(ALTERA,4,IIF(INCLUI,3,0))
				Processa({|| U_TPPROCREP("SA2","U_CADSA2",nOPCx) },"Replicando para as demais empresas...")
			EndIf		
		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
			/*
			ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')
			*/
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			/*
			ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')
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
