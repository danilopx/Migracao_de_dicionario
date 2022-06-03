#Include 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa   A415TDOK  �Autor  �Daniel Ruffino      � Data �  17/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada responsavel por filtrar or�amentos que ja ���
���          � estejam liberado o credito.                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A415TDOK()
	Local _aArea:= GetArea()
	Local _nTotal := 0
	
//Preenche em caso de inclus�o manual - Por Edson H.
/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
| 	Incluido verificacao de ExecAuto = !l415Auto 
|
| Edson Hornberger - 22/04/2014
|=================================================================================
*/
If INCLUI .AND. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT05,.F.,") .AND. !l415Auto

	M->CJ_EMPDES := cEmpAnt
	M->CJ_FILDES := cFilAnt

Endif	

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Internamente o programa MATA415 busca a Tabela de Preco do Cliente na Filial 
|	Atual. Nos casos de Pedidos da Marca Proart o Sistema tem que verificar o
|	cadastro de clientes na filial 01.
|
|	Edson Hornberger - 01/04/2015
|=================================================================================
*/

IF M->CJ_XITEMC = 'PROART'

	M->CJ_TABELA := POSICIONE("SA1",1,"01"+M->CJ_CLIENTE+M->CJ_LOJA,"A1_TABELA")

ENDIF 

//-----------------------------------------------------------------------------------------------
//Adicionado por Thiago Comelli em 16/10/2012
//Executa somente na empresa e filial selecionados
	If ALTERA .AND. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT05",.F.,"")
		TMP1->(dbGoTop())
		While !TMP1->(EOF())
			_nTotal += TMP1->CK_VALOR
			TMP1->(dbSkip())
		EndDo

		BeginSql alias 'SCKORCAM'
			SELECT SUM(CK_VALOR) as CK_TOTAL
			FROM %table:SCK% SCK
			WHERE SCK.CK_FILIAL = %xfilial:SCK%
			AND SCK.CK_NUM = %exp:M->CJ_NUM%
			AND SCK.%NotDel%
		EndSql

		aCondAtu := strtokarr(AllTrim(Posicione("SE4", 1, xFilial("SE4")+M->CJ_CONDPAG, "E4_COND")),",")
		aCondAnt := strtokarr(AllTrim(Posicione("SE4", 1, xFilial("SE4")+SCJ->CJ_CONDPAG, "E4_COND")),",")

		If aCondAnt[Len(aCondAnt)] < aCondAtu[Len(aCondAtu)] .AND. SCKORCAM->CK_TOTAL < _nTotal
			M->CJ_XLIBCR := "A"
//�����������������������Ŀ
//�Grava Log na tabela SZC�
//�������������������������
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+M->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= UPPER("08 - Valor total do Orcamento foi alterado para valor superior ao anterior. Condi��o de Pagamento alterada. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")
			_cFuncao	:= "U_A415TDOK"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

			MsgAlert("Valor total do Orcamento foi alterado para valor superior ao anterior. Condi��o de Pagamento alterada. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")

		ElseIf aCondAnt[Len(aCondAnt)] < aCondAtu[Len(aCondAtu)]
			M->CJ_XLIBCR := "A"
//�����������������������Ŀ
//�Grava Log na tabela SZC�
//�������������������������
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+M->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= UPPER("08 - Condi��o de Pagamento alterada. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")
			_cFuncao	:= "U_A415TDOK"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

			MsgAlert("Condi��o de Pagamento alterada. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")

		ElseIf SCKORCAM->CK_TOTAL < _nTotal
			M->CJ_XLIBCR := "A"
//�����������������������Ŀ
//�Grava Log na tabela SZC�
//�������������������������
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+M->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= UPPER("08 - Valor total do Orcamento foi alterado para valor superior ao anterior. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")
			_cFuncao	:= "U_A415TDOK"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

			MsgAlert("Valor total do Orcamento foi alterado para valor superior ao anterior. Orcamento dever� ser submetido a nova Avalia��o de Cr�dito.")

		ElseIf Alltrim(M->CJ_CONDPAG) == Alltrim(SCJ->CJ_CONDPAG) .AND. SCKORCAM->CK_TOTAL >= _nTotal
//�����������������������Ŀ
//�Grava Log na tabela SZC�
//�������������������������
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+M->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= "07 - ORCAMENTO DE VENDA ALTERADO SEM MUDANCA DE VALOR OU CONDICAO DE PAGAMENTO."
			_cFuncao	:= "U_A415TDOK"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

		EndIf
		SCKORCAM->(DbCloseArea())

	EndIf
	RestArea(_aArea)

	Return .T.
