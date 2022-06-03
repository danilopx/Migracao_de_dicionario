#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI011  บAutor  ณPaulo Bindo         บ Data ณ  01/16/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPROGRAMA PARA EXCLUSAO DE PEDIDO DE FATURA                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATMI011()
	Private cPedPai := Space(06)



	If FunName() == "MATA410"
		cPedPai := SC5->C5_NUM
	Else
		@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Exclusใo Pedido Remessa")
		@ 9,9 Say OemToAnsi("Pedido") Size 99,8
		@ 28,9 Get cPedPai Picture "@!" F3 "SC5"  Size 59,10

		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		Activate Dialog oDlg Centered
	EndIf

	If Empty(cPedPai)
		MsgStop("Informe o numero do pedido pai")
		Return
	EndIf

	cMensagem := " Este programa ira Excluir o pedido de remessa e liberar o de Fatura "


	If MsgYesNo(cMensagem,"EXCLUSAO PEDIDO FATURA")
		Processa( {|| EXCPED() } )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณARRUMASC5 บAutor  ณMicrosiga           บ Data ณ  10/30/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EXCPED()

	cQuery := " SELECT C5_NUM FROM "+RetSqlName("SC5")
	cQuery += " WHERE C5__PEDPAI = '"+cPedPai+"' AND C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "

	//MEMOWRITE("EXCPED.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

	Count To nCount
	Y	  := 0
	ProcRegua(nCount)

	If nCount == 0
		MsgStop("Este pedido nใo ้ um pedido de Fatura!","FATMI011")
		TRB1->(dbCloseArea())
		Return
	Else
		//EXCLUI O PEDIDO REMESSA
		dbSelectArea("SC9")
		dbSetOrder(1)
		dbSeek(xFilial()+cPedPai)

		While !Eof() .And. SC9->C9_PEDIDO == TRB1->C5_NUM
			Begin Transaction
				a460Estorna(.T.)
			End Transaction
			dbSkip()
		End

		aCabec := {}
		aItens := {}

		dbSelectArea("SC5")
		dbSetOrder(1)
		If !dbSeek(xFilial()+TRB1->C5_NUM)
			Return
		EndIf

		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial()+SC5->C5_NUM)

		While !Eof() .And. SC6->C6_NUM == SC5->C5_NUM

			If Len(aCabec) == 0
				aadd(aCabec,{"C5_NUM",SC5->C5_NUM,Nil})
				aadd(aCabec,{"C5_TIPO","N",Nil})
				aadd(aCabec,{"C5_CLIENTE",SC5->C5_CLIENTE,Nil})
				aadd(aCabec,{"C5_LOJACLI",SC5->C5_LOJACLI,Nil})
				aadd(aCabec,{"C5_LOJAENT",SC5->C5_LOJAENT,Nil})
				aadd(aCabec,{"C5_CONDPAG",SC5->C5_CONDPAG,Nil})
				aadd(aCabec,{"C5_TIPOCLI",SC5->C5_TIPOCLI,Nil})
			EndIf


			aLinha := {}
			aadd(aLinha,{"C6_NUM",SC6->C6_NUM})
			aadd(aLinha,{"C6_ITEM",SC6->C6_ITEM})
			aadd(aLinha,{"C6_PRODUTO",SC6->C6_PRODUTO,Nil})
			aadd(aLinha,{"C6_QTDVEN",SC6->C6_QTDVEN,Nil})
			aadd(aLinha,{"C6_PRCVEN",SC6->C6_PRCVEN,Nil})
			aadd(aLinha,{"C6_PRUNIT",SC6->C6_PRUNIT,Nil})
			aadd(aLinha,{"C6_VALOR",SC6->C6_VALOR,Nil})
			aadd(aLinha,{"C6_TES",SC6->C6_TES,Nil})
			aadd(aItens,aLinha)

			dbSelectArea("SC6")
			dbSkip()
		End

		lMsErroAuto := .F.
		MATA410(aCabec,aItens,5)


		If !lMsErroAuto

			Dbselectarea("TRB1")
			dbGoTop()
			While !Eof()
				Y++
				IncProc("Liberando Pedidos "+StrZero(y,8)+" de "+StrZero(nCount,8))
				Processmessages()


				//LIMPAR MENSAGEM DA NOTA
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek(xFilial()+TRB1->C5_NUM)
				RecLock("SC5",.F.)
				C5_MENNOTA := ''			
				SC5->(MsUnlock())

				dbSelectArea("TRB1")
				dbSkip()
			End
			MsgInfo("Exclusao com sucesso! ","Atencao")

		Else

			MsgInfo("Nโo foi possivel a Exclusao ! ","Atencao")

		EndIf

	EndIf
	TRB1->(dbCloseArea())
Return
