// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ACD167IN.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 03/01/2020 | Trade             | Informa a qtde de volumes para separa��o EMPRESA 0302 PROART
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#INCLUDE "APVT100.CH"

#DEFINE ENTER CHR(13) + CHR(10)
//------------------------------------------------------------------------------------------

user function ACD167IN()

	Local lRet	:= .T.
	Local _nQtdVol	:= 0

	Private _cAlias := GetNextAlias()
	cImp := CBRLocImp("MV_IACD01")  //PADRAO

	If   CEMPANT="03" .AND. CFILANT="02"
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5")+CB7->CB7_PEDIDO)
		If   ALLTRIM(SC5->C5_XITEMC) <> "PROART"   //executa somente para familia PROART
			Return(lRet)
		EndIf
		cImp := CBRLocImp("MV__IACD01") //IMPRESSORA ESPECIFICA PARA PROART
		ZAR->(Dbsetorder(1))
		ZAR->(Dbseek(xfilial("ZAR") + CB7->CB7_ORDSEP ))
		IF CB7->CB7_X_QTVO = 0 .OR. (CB7->CB7_X_QTVO != 0 .AND. ZAR->(Eof()))
			aTela := VtSave()
			While .T.
				VTCLear()
				_nQTdVol := 0
				@ 0,0 VTSay "Embalagem"
				@ 1,0 VtSay "Informe Qtd. Volume:"
				@ 2,0 VtGet _nQTdvol Pict "@E 999,999"
				VTRead
				If   VtLastKey() == 27
					IF   _nQtdVol <= 0
						VtAlert("Informar Qtde de Volume","Aviso",.t.,4000,3)
						VtKeyboard(Chr(20))  // zera o get
					ElseIf VTYesNo("Confirma a Qtde de Volme","Aten��o ",.T.)
						Reclock("CB7",.F.)
						Replace CB7_X_QTVO WITH _nQTdVol
						Msunlock()
						Exit
					ENDIF
				Endif
				IF   _nQtdVol <= 0
					VtAlert("Informar Qtde de Volume","Aviso",.t.,4000,3)
					VtKeyboard(Chr(20))  // zera o get
				ElseIf VTYesNo("Confirma a Qtde de Volme","Aten��o ",.T.)
					Reclock("CB7",.F.)
					Replace CB7_X_QTVO WITH _nQTdVol
					Msunlock()
					Exit
				Endif
			End
			VtRestore(,,,,aTela)
		Endif
	EndIf
Return(lRet)