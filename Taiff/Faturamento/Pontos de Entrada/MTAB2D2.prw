#Include 'Protheus.ch'
/*
=================================================================================
=================================================================================
||   Arquivo:	MTAB2D2.prw
=================================================================================
||   Funcao: MTAB2D2
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| Ponto de Entrada está localizado na função B2AtuComD2 e 
|| é executado ANTES da gravação do SB2
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data: 11/12/2015
=================================================================================
=================================================================================
*/

User Function MTAB2D2()
	Local cIDproduto	:= PARAMIXB[1]
	Local cIDlocal		:= PARAMIXB[2]
	Local aLockSB2 	:= {}
	Local lTfBloqueado:= .F.
	Local nTentativas := 0
	Local xSB2Alias	:= SB2->(GetArea())
	Local lSB2Found	:= .T.
	Local nX := 0

	SB2->(DbSetOrder(1))

	aLockSB2 		:= {}
	lTfBloqueado	:= .F.
	While .NOT. lTfBloqueado
		If SB2->(DbSeek( xFilial("SB2") + cIDproduto + cIDlocal ))
			If ASCAN( aLockSB2 ,SB2->(Recno())) = 0
				If !SB2->(MsRLock())
					nTentativas += 1
					If nTentativas >= 1000000000000000
						lTfBloqueado	:= .T.
						lSB2Found		:= .F.
					EndIf
				Else
					AAdd(aLockSB2,SB2->(Recno()))
					lTfBloqueado := .T.
				EndIf
			EndIf
		Else
			lTfBloqueado	:= .T.
			lSB2Found		:= .F.
		EndIf
	End

	If 	lSB2Found
		For nX := 1 To Len(aLockSB2)
			SB2->(MsGoto(aLockSB2[nX]))
			SB2->(MsUnLock())
		Next nX
	EndIf

	RESTAREA(xSB2Alias)
Return

