#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

// Incluido em 30/07/2013 - Edson Hornberger
#DEFINE PULA CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2460  ºAutor  ³ Robson Sanchez     º Data ³  13/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado apos a gravacao da tabela SD2   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460

Local aArea  		:= GetArea()
Local cQuery 		:= ""
Local cInter 		:= ""
Local cMeta  		:= ""

// Incluido em 30/07/2013 - Edson Hornberger
Local cQryTmp		:= ""
Local cQryCnt 		:= ""
Local lFCITemp		:= GETNEWPAR("TF_FCIDANF",.F.)
Local lFCISimp		:= GETNEWPAR("TF_FCISIMP",.F.)
Local cPeriodo		:= ""
Local nCI			:= 0
Local cNumFCI		:= ""

// Posiciona no Pedido de Vendas para pegar o campo InterCompany (C5_INTER)
SC5->(dbsetorder(3))
SC5->(dbseek(xFilial('SC5')+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO))

cInter:= SC5->C5_INTER

// Posiciona Tes para pegar o campo Meta (F4_META)
SF4->(DbSetOrder(1))  //mjl 26/1/11
SF4->(dbseek(xFilial('SF4')+SD2->D2_TES))

cMeta:= SF4->F4_META

/*ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ Inicio da alteracao para controlar, temporaria-ÿÿ
//ÿÿmente a FCI.                                    ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ Tabela que sera utilizada                      ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ TMP_FCI##0 (## = EMPRESA)                      ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ EDSON HORNBERGER - 30/07/2013                  ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ*/

// Se o parametro estiver habilitado para utilizar o Controle Temporario
// E se o parametro de Mensagem Simples nao estiver habilitado.
If lFCItemp .And. !lFCISimp

	// Verifica se o Pedido nao e Devolucao ou Beneficiamento
	If !(SC5->C5_TIPO  $ ("D|B"))

		// Verifica se Venda e' Interestadual e Cliente nao e' Isento
		If !EMPTY(SA1->A1_INSCR) .And. Upper(AllTrim(SA1->A1_INSCR)) != "ISENTO"

			// Verifica se o TES utilizado nao e para Consumo, Calcula ICMS e Situacao Tributaria esta correta
			If 	SF4->F4_CONSUMO = "N" .And. ;
				SF4->F4_ICM 	= "S" .And. ;
				SF4->F4_ISS		!= "S" .And. ;
				SF4->F4_SITTRIB	$ ("00|10|20|70|90")

				// Verifica a Origem do Produto
				If SB1->B1_ORIGEM $ ("1|2|3|5|8")

					cPeriodo := SubStr(AnoMes(dDataBase),5,2) + SubStr(AnoMes(dDataBase),1,4)

					// Gera query para buscar informacoes da FCI do Produto
					// Nao ira verificar o campo Filial neste processo Temporario
					cQryTmp 	:= "SELECT" 										+ PULA
					cQryTmp 	+= "TMP_FCICOD," 									+ PULA
					cQryTmp 	+= "TMP_CONIMP" 									+ PULA
					cQryCnt	:= "FROM" 											+ PULA
					cQryCnt	+= "TMP_FCI" + AllTrim(cEmpAnt) + "0" 				+ PULA
					cQryCnt	+= "WHERE" 											+ PULA
					cQryCnt	+= "TMP_COD = '" + AllTrim(SD2->D2_COD) + "' AND" 	+ PULA
					cQryCnt	+= "TMP_PERCAL = '" + cPeriodo + "'"

					cQuery 	:= "SELECT COUNT(*) AS QTD " + cQryCnt

					If Select("TMP") > 0

						dbSelectArea("TMP")
						dbCloseArea()

					EndIf

					TcQuery cQuery New Alias "TMP"
					dbSelectArea("TMP")

					// Se achar Informacoes na Tabela Temporaria de FCI
					If TMP->QTD > 0

						cQuery := cQryTmp + cQryCnt

						TMP->(dbCloseArea())

						TcQuery cQuery New Alias "TMP"
						dbSelectArea("TMP")

						nCI		:= TMP->TMP_CONIMP
						cNumFCI	:= TMP->TMP_FCICOD

					EndIf

				EndIf

			EndIf

		EndIf

	EndIf

EndIf

/*ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ FIM DO DESENVOLVIMENTO - Edson Hornberger      ÿÿ
//ÿÿ                          30/07/2013            ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ*/

SD2->(RecLock("SD2",.F.))

	SD2->D2_INTER 		:= cInter
	SD2->D2_META  		:= cMeta
	SD2->D2_XCONIMP	:= nCI		//Incluido em 30/07/2013 - Edson Hornberger
	SD2->D2_XFCICOD	:= cNumFCI	//Incluido em 30/07/2013 - Edson Hornberger

SD2->(MsUnlock())

RestArea(aArea)

Return Nil
