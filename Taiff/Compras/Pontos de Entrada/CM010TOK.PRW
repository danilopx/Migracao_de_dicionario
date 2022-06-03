#include "Protheus.ch"
#include "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER Chr(13) + Chr(10)

/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CM010TOK  º Autor ³ PAULO BINDO        º Data ³  12/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PONTO DE ENTRADA PARA CONFIRMACAO DA TABELA DE PRECO DE    º±±
±±º          ³ COMPRAS                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CM010TOK()
	Local nPrcBl := 0
	Local nOld   := n
	Local nCont  := 0
	Local lAnexo := .F.
	Local l2Anexo := .F.
	Local cZNChave := ""
	Local cMailDest := U_TFmaisx6()
	Local cMensFlw := ""
	Local lInclusao := .F.
	Local nPrcAnterior := 0
	Local n := 0
	Local cQuery

	For n:=1 To Len(aCols)
		nPrcBl := Buscacols("AIB__PREPR")
		If nPrcBl > 0
			nCont ++
		EndIf
	Next
	If nCont > 1
		lAnexo := .T.
	EndIf
//VERIFICA SE EXISTE UM PRECO PARA APROVACAO E GRAVA NA TABELA SZN
	cProCntDias := ""
	For n:=1 To Len(aCols)
		//VERIFICA SE JA EXISTE PELO MENOS UMA VEZ
		cQuery := " SELECT * FROM "+RetSqlName("SZN")
		cQuery += " WHERE ZN_CODFOR = '"+M->AIA_CODFOR+"' AND ZN_CODPRO = '"+Buscacols("AIB_CODPRO")+"'"
		cQuery += " AND D_E_L_E_T_ <> '*' "

		MEMOWRITE("CM010TOK_Inclusao.sql",cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)

		Count To nRec0
		TRBCM0->(dbCloseArea())

		nPrcAnterior := 0
		lInclusao := .F.
		If nRec0 = 0
			cQuery := " SELECT AIB_PRCCOM FROM "+RetSqlName("AIB") + ENTER
			cQuery += " WHERE " + ENTER
			cQuery += "	AIB_FILIAL = '" + xFILIAL("AIB") + "'" + ENTER
			cQuery += "	AND D_E_L_E_T_ <> '*' "
			cQuery += "	AND AIB_CODFOR = '" + M->AIA_CODFOR + "'" + ENTER
			cQuery += "	AND AIB_CODTAB = '" + M->AIA_CODTAB + "'" + ENTER
			cQuery += "	AND AIB_ITEM = '" + Buscacols("AIB_ITEM") + "'" + ENTER

			MEMOWRITE("CM010TOK_preco_anterior.sql",cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)

			nPrcAnterior := TRBCM0->AIB_PRCCOM
			TRBCM0->(dbCloseArea())
		EndIf

		nPrcBl := Buscacols("AIB__PREPR")
		If nPrcBl = 0 .and. nPrcAnterior != Buscacols("AIB_PRCCOM") // Siginifica que houve alteração abaixo da regra
			lInclusao := .T.
		EndIf
		If nPrcBl > 0 .OR. lInclusao
			If Empty(cMensFlw) .AND. nPrcBl > 0
				SA2->(DbSetOrder(1))
				SA2->(DbSeek( xFilial("SA2") + M->AIA_CODFOR + M->AIA_LOJFOR))
				cMensFlw += CHR(13) + "Tabela de preço " + Alltrim(M->AIA_CODTAB) + " do fornecedor " + M->AIA_CODFOR + " - " + Alltrim(SA2->A2_NOME) + " sofreu intervenção."
				cMensFlw += CHR(13) + "e está aguardando aprovação da controladoria."
				cMensFlw += CHR(13) + "Origem: CM010TOK (COMA010) - Tabela de Preço - Autor: " + SubStr(cUsuario,7,15)
				cMensFlw += CHR(13) + CHR(13) + space(20) + "** e-mail automático, não responda! ** "
			EndIf
			//VERIFICA SE JA EXISTE UM REGISTRO SEM APROVACAO E O ALTERA
			cQuery := " SELECT * FROM "+RetSqlName("SZN")
			cQuery += " WHERE ZN_CODFOR = '"+M->AIA_CODFOR+"' AND ZN_CODPRO = '"+Buscacols("AIB_CODPRO")+"'"
			cQuery += " AND D_E_L_E_T_ <> '*' AND ZN_APROV = '' AND ZN_TIPO = 'C'"

			MEMOWRITE("CM010TOK.sql",cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)

			Count To nRec1

			If nRec1 > 0
				dbSelectArea("TRBCM0")
				dbGoTop()

				dbSelectArea("SZN")
				dbSetOrder(2)
				If dbSeek(xFilial()+M->AIA_CODFOR+Buscacols("AIB_CODPRO"))
					If Empty(SZN->ZN_APROV)
						RecLock("SZN",.F.)
						ZN_PRCCOM 	:= nPrcBl
						ZN_DATA		:= dDataBase
						ZN_USERINC  := SubStr(cUsuario,7,15)
						ZN_HRINC    := Time()
						ZN_TIPO 	:= "C"
						SZN->(MsUnlock())
					EndIf
				EndIf
				//CASO NAO TENHA SIDO ALTERADO, INCLUI
			Else
				dbSelectArea("SZN")
				cNumSZN := GetSx8Num("SZN","ZN_COD")
				If Empty(cZNChave)
					cZNChave := 'SZN'+xFilial()+Buscacols("AIB_CODPRO")+cNumSZN
				EndIf
				RecLock("SZN",.T.)
				ZN_FILIAL 	:= xFilial()
				ZN_COD		:= cNumSZN
				ZN_CODTAB	:= M->AIA_CODTAB
				ZN_CODFOR	:= M->AIA_CODFOR
				ZN_CODPRO	:= Buscacols("AIB_CODPRO")
				ZN_PRCCOM 	:= nPrcBl
				ZN_DATA		:= dDataBase
				ZN_USERINC  := SubStr(cUsuario,7,15)
				ZN_HRINC    := Time()
				ZN_TIPO 	:= "C"
				ZN_ARQUIVO 	:= cZNChave
				ZN_ANEXO 	:= "S"
				ZN_PRCANT	:= Buscacols("AIB_PRCCOM")
				SZN->(ConfirmSX8())

				If .NOT. lInclusao .OR. nPrcBl > 0
					//EFETUA A PERGUNTA DE ANEXO PARA TUDO E GRAVA PARA O PRIMEIRO ITEM
					If lAnexo
						U_SelArqSQL(cZNChave,.T.,.T.)
						l2Anexo := .T.
						lAnexo := .F.
					ElseIf !l2Anexo
						If MsgYesNo("Deseja incluir um anexo que comprove o aumento do preço?","CM010TOK")
							U_SelArqSQL(cZNChave,.T.,.T.)
						Else
							ZN_ARQUIVO 	:= ""
							ZN_ANEXO 	:= ""
						EndIf
					ElseIf !lAnexo .And.!l2Anexo
						ZN_ARQUIVO 	:= ""
						ZN_ANEXO 	:= ""
					EndIf
				ElseIf lInclusao
					ZN_PRCCOM 	:= Buscacols("AIB_PRCCOM")
					ZN_ARQUIVO	:= ""
					ZN_ANEXO 	:= ""
					ZN_DATAAPR	:= dDataBase
					ZN_APROV  	:= "INCLUSAO"
					ZN_HRAPROV := Time()
					ZN_PRCANT	:= nPrcAnterior
				EndIf
				SZN->(MsUnlock())
			EndIf
			TRBCM0->(dbCloseArea())
		EndIf
	Next
	If .NOT. Empty(cMensFlw)
		If U_EnvMail("workflow@taiff.com.br", cMailDest, "Manutenção Tabela de Preço de Compra ", OemToAnsi(cMensFlw))
			conout("workflow enviado para Manutenção Tabela de Preço de Compra")
		EndIf
	EndIf
	n:= nOld
Return(.T.)
