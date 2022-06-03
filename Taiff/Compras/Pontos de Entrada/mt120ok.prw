#include "PROTHEUS.CH"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT120TOK �Autor  � Robson Sanchez    � Data � 08/07/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida todas as linhas do GETDADOS antes da conclusao      ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120OK

	Local cAliasBKP	:= Alias()
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"SY1","SB1"})
	Local cUserAtu	:= RetCodUsr()
	Local cFilSY1	:= xFilial("SY1")
	Local cFilSB1	:= xFilial("SB1")
	Local cCodCom	:= Posicione("SY1",3,cFilSY1 + cUserAtu,"Y1_COD")
	Local nPosProd	:= GdFieldPos("C7_PRODUTO",aHeader)
	Local nPosItem	:= GdFieldPos("C7_ITEM",aHeader)
	Local cGrupo	:= ""
	Local cQuery	:= ""
	Local cAliasTRB	:= GetNextAlias()
	Local cNameZZK	:= RetSQLName("ZZK")
	Local cItem		:= ""
	Local cFilZZk	:= xFilial("ZZK")
	Local _nx		:= 0
	Local __cEmpAtu	:= GetNewPar("PRT_COM001","03")
	Local __cFilAtu	:= GetNewPar("PRT_COM002","01")
	Local _nBkpN := N
	Local nPosCC	:= GdFieldPos("C7_CC",aHeader)
	Local cTFCcusto := ""
	//----------------------------------------------------------------------------------------------------------------------------
	// Variaveis: TOTVS
	//----------------------------------------------------------------------------------------------------------------------------
	Local _lRet 	:= .T.
	Local nx1		:= 0
	Local nx		:= 0
	Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
	Local aItemcc 	:= {} 					// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
	Local nz		:= 0
	Local nOld		:= 0
	Local cOp		:= ""
	Local cProd		:= ""
	Local cPedido	:= ""
	Local lCCobrig	:= .F.
	Local cCCItem	:= ""
	Local n			:= 0

	//--------------------------------------------[ Fim Customiza��o TOTVS ]------------------------------------------------------

	/*
	|---------------------------------------------------------------------------------
	|	Realiza a valida��o verificando se � chamado pelo processo de beneficiamento
	|	Analisar pois esta influenciando na gera��o do Pedido de Compra.
	|---------------------------------------------------------------------------------
	*/

	IF ISINCALLSTACK("U_TFCOMBNF") .AND. !l120Auto
		MESSAGEBOX('Utilize o bot�o "FECHAR" para sair da tela!',"ATEN��O",64)
		Return .F.
	ENDIF

	//----------------------------------------------------------------------------------------------------------------------------
	// Ponto de Valida��o: TOTVS
	// Descri��o: Validar unidade de negocio no produto
	// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
	//----------------------------------------------------------------------------------------------------------------------------
	If lUniNeg
		For nx:= 1 to Len(aCols)

			For nz := 1 to Len(aCols)
				//-- Por causa de solicitacoes de compras antigas vazias, traz a unidade de
				// -- negocios do cad. de produtos
				If Empty(acols[nz][GdFieldPos('C7_ITEMCTA')])

					aItemcc := GeTAdvFval('SB1',{'B1_ITEMCC'},;
						/* chave*/ xFilial('SB1')+acols[nz][GdFieldPos('C7_PRODUTO')], 1/*Ordem*/)

					aCols[nz][GdFieldPos('C7_ITEMCTA')] := aItemcc[1]
				EndIf
			Next nz

			cUneg := acols[nx][GdFieldPos('C7_ITEMCTA')]

			If !aCols[nx][Len(aCols[nx])]
				For nx1 := 1 to Len(aCols)

					If Empty(acols[nx1][GdFieldPos('C7_ITEMCTA')]) .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]
						_lRet := .F.
						Help(nil,1,'Unidade de Negocios',nil,'Obrigat�rio preencher unidade de negocios',3,0)
						Exit

					ElseIf cUneg <> acols[nx1][GdFieldPos('C7_ITEMCTA')] .And. _lRet .And. !aCols[nx1][Len(aCols[nx1])]

						_lRet := .F.
						Help(nil,1,'Unidade de Negocios',nil,'N�o � permitido usar unidade de negocios diferentes',3,0)
						Exit
					EndIf

				Next nx1
			EndIf

			If !_lRet
				Exit
			EndiF
		Next nx

	EndIf
	//--------------------------------------------[ Fim Customiza��o TOTVS ]------------------------------------------------------

	//EFETUA ALTERACAO NA TABELA DE EMPENHO REFERENTE A BENEFICIAMENTO
	nOld := n
	For n:=1 To Len(aCols)
		If cEmpAnt == "04" .and. cFilAnt='02' .And. !aCols[n][Len(aCols[n])]
			cOp := BuscaCols("C7__OPBNFC")
			cProd := BuscaCols("C7_PRODUTO")
			cPedido := cA120Num

			//VALIDA QUANTIDADE
			dbSelectArea("SD4")
			dbSetOrder(2)
			If dbSeek(xFilial()+cOp+cProd)
				RecLock("SD4",.F.)
				D4__QTPCBN := U_CalcBnfc(cOp,cProd,cPedido,"C") + BuscAcols("C7_QUANT")
				SD4->(MsUnlock())
			EndIf

		EndIf
	Next
	n:= nOld
	lCCobrig	:= .F.
	cCCItem		:= ""

	If _lRet
		//�����������������������������������Ŀ
		//�INICIO - Rotina pre existente Taiff�
		//�������������������������������������
		If Inclui .Or. Altera

			For _nX := 1 to Len( aCols )
				If aTail( aCols[_nX] )
					Loop
				EndIf

				N := _nX

				/*
				|=================================================================================
				|   COMENTARIO
				|---------------------------------------------------------------------------------
				|	O Ponto de Entrada abaixo foi retirado do Projeto do Grupo
				|
				|	Edson Hornberger - 27/11/2014
				|=================================================================================
				*/
				//_lRet := U_A120LinOK()

				If !_lRet
					Exit
					N := _nBkpN
					Return _lRet
				EndIf

				If Empty(acols[_nx][GdFieldPos("C7_CC")]) .AND. acols[_nx][GdFieldPos("C7_RATEIO")] != "1"
					lCCobrig := .T.
					cCCItem += "Produto: " + aCols[_nx][nPosProd] + " - Item Pedido: " + aCols[_nx][nPosItem] + Chr(13) + Chr(10)
				EndIf

				//�����������������������������������Ŀ
				//�FIM - Rotina pre existente Taiff�
				//�������������������������������������


				//�����������������������������������������������������������Ŀ
				//�Verifica se a empresa e Filial possuem acesso a essa rotina�
				//�������������������������������������������������������������
				If !cEmpAnt $ __cEmpAtu .or. !cFilAnt $ __cFilAtu
					//��������������������������������������Ŀ
					//�Restaura a Ordem Original dos Arquivos�
					//����������������������������������������
					RestOrd(aOrdBKP)
					DbSelectArea(cAliasBKP)
					Return _lRet
				Else
					//���������������������������������������������������������Ŀ
					//�Verifica se o comprador pode comprar esse tipo de produto�
					//�����������������������������������������������������������
					If !Empty(cCodCom) .And. !IsInCallStack("U_TFCOM001")

						cGrupo	:= Posicione("SB1",1,cFilSB1 + aCols[_nx][nPosProd],"B1_GRUPO")

						cQuery := "SELECT COUNT(*) TOTPROD FROM " + cNameZZK + " ZZK "
						cQuery += "WHERE '" + cGrupo + "' >= ZZK_GRPPRD "
						cQuery += "AND '" + cGrupo + "' <= ZZK_GRPFIM "
						cQuery += "AND ZZK_CODGRP = '" + cCodCom + "' "
						cQuery += "AND ZZK_FILIAL = '" + cFilZZK + "' AND ZZK.D_E_L_E_T_ <> '*' "

						TcQuery cQuery ALIAS &(cAliasTRB) new

						If (cAliasTRB)->TOTPROD == 0
							cItem += "Produto: " + aCols[_nx][nPosProd] + " - Item Pedido: " + aCols[_nx][nPosItem] + Chr(13) + Chr(10)
							_lRet := .F.
						EndIf

						(cAliasTRB)->(DbCloseArea())
					EndIf

					//���������������������������������������������������������Ŀ
					//�Valida o uso do centro de custo X empresa/filial		  �
					//�Autor: Carlos Torres					 Data: 07/03/2016	  �
					//�����������������������������������������������������������
					cTFCcusto := aCols[_nx][nPosCC]
					If !Empty(cTFCcusto)
						If .NOT. U_TFCCUSTO(cempant,cfilant,cTFCcusto)
							_lRet := .F.
						EndIf
					EndIf

				EndIf

			Next nX

			If !Empty(cItem)
				Aviso("MT120OK","Comprador nao possui direito para utilizar os seguintes produtos: " + Chr(13) + Chr(10) + cItem,{"Ok"})
			EndIf
			If lCCobrig
				Aviso("MT120OK","Centro de custo obrigat�rio, verifique os itens: " + Chr(13) + Chr(10) + cCCItem,{"Ok"})
			EndIf


			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

		Endif
	EndIf
Return _lRet
