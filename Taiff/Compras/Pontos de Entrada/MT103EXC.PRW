#include "rwmake.ch"

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MT103EXC
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor PAULO BINDO | Descricao PONTO DE ENTRADA QUE VALIDA A EXCLUSAO DA NFE
// ---------+-------------------+-----------------------------------------------------------
// 27/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------


user function MT103EXC()
	Local lRet := .T.
	Local aAreaD1 := GetArea("SD1")
	Local aSE1Alias	:= SE1->(GetArea()) 
	Local aZA6Alias 	:= ZA6->(GetArea()) 
	Local cZA6Prefixo	:= ""

	If SF1->F1_TIPO == "N" 

		dbSelectArea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial()+SUBS(CNFISCAL,1,9)+CSERIE+SUBS(CA100FOR,1,6)+CLOJA)
		While !EOF() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == SUBS(CNFISCAL,1,9)+CSERIE+SUBS(CA100FOR,1,6)+CLOJA
			If  !Empty(SD1->D1_OP)
				//VERIFICA SE EXISTE MOVIMENTACAO INTERNA COM DADOS DA NOTA
				dbSelectArea("SD3")
				dbSetOrder(15)
				If dbSeek(xFilial()+CNFISCAL+CSERIE+CA100FOR+SD1->D1_COD)
					//VERIFICA A QUANTIDADE EMPENHADA NA OP
					dbSelectArea("SD4")
					dbSetOrder(2)
					If dbSeek(xFilial()+SD1->D1_OP+SD1->D1_COD)
						nQtdEmp := SD4->D4_QUANT
					EndIf
					//VERIFICA A QUANTIDADE PRODUZIDA DA OP
					dbSelectArea("SC2")
					dbSetOrder(1)
					If dbSeek(xFilial()+SD1->D1_OP)
						nQtdProd := SC2->C2_QUJE+SC2->C2_PERDA
						nPropor  := SD4->D4_QTDEORI/SC2->C2_QUANT //PROPORCAO ITEM X PA
						nQtdReal := nQtdProd/nPropor
						//VERIFICA SE A OP FOI BAIXADA POR ESTA NOTA
						If   ((SD4->D4_QTDEORI-SD4->D4_QUANT)/nPropor) < nQtdReal
							lRet := .F.
							Exit
						EndIf
					EndIf
				EndIf
			EndIf
			dbSelectArea("SD1")
			dbSkip()
		End
		//DEIXAR ESTRE TRECHO POR ULTIMO, ELE VOLTA A QUANTIDADE ENVIADA PARA TERCEIROS NA SD4
		If lRet
			dbSelectArea("SD1")
			dbSetOrder(1)
			dbSeek(xFilial()+SUBS(CNFISCAL,1,9)+CSERIE+SUBS(CA100FOR,1,6)+CLOJA)
			While !EOF() .And. D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == SUBS(CNFISCAL,1,9)+CSERIE+SUBS(CA100FOR,1,6)+CLOJA
				If  !Empty(SD1->D1_OP)
					//VERIFICA A QUANTIDADE EMPENHADA NA OP
					dbSelectArea("SD4")
					dbSetOrder(2)
					If dbSeek(xFilial()+SD1->D1_OP+SD1->D1_COD)
						RecLock("SD4",.F.)
						D4__QTBNFC := D4__QTBNFC + SD1->D1_QUANT
						SD4->(MsUnlock())
					EndIf
				EndIf
				dbSelectArea("SD1")
				dbSkip()
			End
		EndIf


		If !lRet
			MsgStop("Esta nota de entrada possui uma OP BAIXADA, estorne a baixa da OP primeiro","MT103EXC")
		EndIf

		/* Valida exclusão da NDC criada pelo PE MT103FIM quando o documento de entrada se refere a uma devolução */
		/* Solução implementada em 07/06/2016 */
	ElseIf SF1->F1_TIPO == "D" .AND. IsInCallStack("MATA103")

		// (1) - D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(DbSetOrder(1))
		If SD1->(DbSeek( xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) ))

			ZA6->(DbSetOrder(1))
			ZA6->(DbSeek(xFilial("ZA6")+SF1->(F1_FORNECE+F1_LOJA)))

			While ZA6->ZA6_FILIAL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA = xFilial("ZA6")+SF1->(F1_FORNECE+F1_LOJA) .And. ! ZA6->(Eof())
				If ZA6->ZA6_ITEMC = SD1->D1_ITEMCTA .OR. Empty(ZA6->ZA6_ITEMC)  
					cZA6Prefixo := Alltrim(ZA6->ZA6_TPBON) 
					If TamSX3("E1_PREFIXO")[1] > TamSX3("ZA6_TPBON")[1]
						cZA6Prefixo += Space(TamSX3("E1_PREFIXO")[1] - TamSX3("ZA6_TPBON")[1])
					EndIf
					// (2) - E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
					SE1->(DbSetOrder(2))
					If SE1->(DbSeek( xFilial("SE1") + SF1->(F1_FORNECE + F1_LOJA) + cZA6Prefixo + SF1->F1_DOC + Space(TamSX3("E1_PARCELA")[1]) + "NDC" ))
						If .NOT. Empty(SE1->E1_BAIXA)
							lRet := .F.
						EndIf
					EndIf
				EndIf
				ZA6->(DbSkip())
			End

			If !lRet 
				MsgStop("Para excluir a devolução solicite ao financeiro o estorno da baixa do título do tipo NDC!","MT103EXC")				 		
			EndIf
		EndIf
	EndIf

	If SF1->F1_TIPO == "N" .AND. lRet
		If SF1->(FieldPos("F1_NUMRM")) > 0
			If ALLTRIM(SF1->F1_NUMRM) = "CROSS" .AND. SF1->F1_XRECEBE $ "E|F" 
				lRet := .F.
				MsgStop("Este documento não pode ser excluido uma vez que o saldo de estoque está comprometido com CROSS DOCKING","MT103EXC")				 		
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaD1)
	SE1->(RestArea(aSE1Alias))
	ZA6->(RestArea(aZA6Alias))

Return lRet