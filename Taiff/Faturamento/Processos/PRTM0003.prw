#include "protheus.ch"
#include "topconn.ch"
#include "RWMAKE.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0003  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo de Embalagens			                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ 20130320-Arlete-Passa a gravar o numero da separacao na ZZGº±±
±±º          ³ e sequência da caixa na SC9 (para usar na ordem de         º±±
±±º          ³ impressão da NF)                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PRTM0003(cChamada)

	Local lRet		:= .T.
	Local lFirst	:= .T.
	Local _nx		:= 0
	Local _ny		:= 0
	Local cQuery	:= ""
	Local cAliasBKP	:= Alias()
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"SC5","SB1","SB9"})
	Local cNameSC9	:= RetSQLName("SC9")
	Local cFilSC9	:= xFilial("SC9")
	Local cNameSB1	:= RetSQLName("SB1")
	Local cFilSB1	:= xFilial("SB1")
	Local cAliasTRB	:= GetNextAlias()
	Local nVolInd	:= 0
	Local nSaldo	:= 0
	Local nSobra	:= 0
	Local nTotVol	:= 0
	Local cSeqCX 	:= Space(6)
	Local aFechadas	:= {}
	Local aSaldos	:= {}
	Local aItens	:= {}
	Local aSepara	:= {}
	Local aResiduos	:= {}
	Local cUserAut 	:= GETMV("MV_EXCLSEP")
	Local aUsu		:= PswRet()
	Local cUsu		:= aUsu[1][1]
	Local _nRec 	:= 0
	LOCAL NQTDSC9	:= 0
	LOCAL NQTDSC6	:= 0

	Private cDataH 	:= alltrim(str(year(ddatabase)))+alltrim(strzero(month(ddatabase),2))+alltrim(strzero(day(ddatabase),2))+(time())
	Private aCaixas := {}
	Private cPedido	:= SC5->C5_NUM
	PRIVATE lESTMI001	:= .F.

/*
--> C5_YSTSEP =
S - Etiquetas Impressas / Em Separacao
C - Em Conferencia
G - Conferencia Finalizada
E - Erro no Calculo de Embalagens
N - Separacao Nao Iniciada
*/

	IF ISINCALLSTACK("U_FATPEDIDO")

		RETURN .T.

	ENDIF

	lESTMI001 := ISINCALLSTACK("U_ESTMI001")

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5") + cPedido))

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	VERIFICA QUAL A UNIDADE DE NEGOCIO ESTA SENDO UTILIZADO. SOMENTE SERA CALCULADO 
	| PARA A UNIDADE PROART.
	|
	|	EDSON HORNBERGER - 03/02/2014
	|=================================================================================
	*/

	IF ALLTRIM(SC5->C5_XITEMC) <> "PROART" .OR. ISINCALLSTACK("U_TF_3AVN_A3") .OR. ISINCALLSTACK("U_TF_4AVN_A4")

		RETURN .T.

	ENDIF

//VERIFICA SE EXISTE CALCULO DE EMBALAGENS E QUESTIONA O USUÁRIO SOBRE A EXCLUSÃO
	cQuery := " SELECT ZZG_PEDIDO FROM "+RetSqlName("ZZG")+" ZZG, "+RetSqlName("SC9")+" SC9 "+CRLF
	cQuery += " WHERE  ZZG_PEDIDO = '" + cPedido + "' AND C9_PEDIDO = '" + cPedido + "' "+CRLF
	cQuery += " AND (SC9.R_E_C_N_O_ = ZZG_SC9 OR ZZG_SC9 NOT IN (SELECT SC9IN.R_E_C_N_O_ FROM "+RetSqlName("SC9")+" SC9IN WHERE SC9IN.D_E_L_E_T_ <> '*' AND SC9IN.C9_FILIAL = '"+xFilial("SC9")+"' AND SC9IN.C9_PEDIDO = '" + cPedido + "') ) "+CRLF
	cQuery += " AND C9_NFISCAL = ' ' "+CRLF
	cQuery += " AND C9_LOCAL = '21' "+CRLF
	cQuery += " AND ZZG_FILIAL = '"+xFilial("ZZG")+"' "+CRLF
	cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"' "+CRLF
	cQuery += " AND ZZG.D_E_L_E_T_ <> '*' "+CRLF
	cQuery += " AND SC9.D_E_L_E_T_ <> '*' "

	cQuery := ChangeQuery( cQuery )
	//MemoWrite("PRTM0003-deletar.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)

	COUNT TO _nRec
	(cAliasTRB)->(dbGoTop())

	(cAliasTRB)->(DbCloseArea())
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)
	//CASO HOUVER CALCULO PARA A LIBERACAO ATUAL (SEM FATURAMENTO)
	If _nRec > 0
		If cUsu $ cUserAut .OR. !(SC5->C5_YSTSEP $ ("SCGN")) .OR. lESTMI001
			If cChamada == "V"
				lDeleta := .T.
			ElseIf Aviso("PRTM0003","Existe Calculo de Embalagem para este pedido: "+cPedido+". Deseja excluir o cálculo ? (Estes itens ainda não estao faturados)",{"Sim","Não"} ) == 1
				lDeleta := .T.
			Else
				lDeleta := .F.
			EndIf

			If lDeleta
				RestOrd(aOrdBKP)
				DbSelectArea(cAliasBKP)
				U_PRTM004(cPedido)
//Grava log
				_cAlias		:= "SC5"
				_cChave		:= xFilial("SC5")+SC5->C5_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= UPPER("19 - Exclusão de cálculo de embalagens por usuário autorizado.")
				_cFuncao	:= "U_PRTM0003"
				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

				If cChamada <> "V"
					If Aviso("PRTM003","Pedido: "+SC5->C5_NUM+". Deseja refazer o cálculo ? ",{"Sim","Não"} ) == 2
						Return .T.
					Endif
				EndIf

			Else
				If (!IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001")) .AND. .NOT. lESTMI001
					MSGALERT("Calculo de Embalagens preservado.")
				EndIf
				Return .T.
			EndIf
		Else
			If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
				MSGALERT("Já existe calculo de embalagem para o pedido "+cPedido+". Usuario nao autorizado a refazer o calculo: usuário atual "+cUsu+", usuários autorizados "+cUserAut+".")
			EndIf
			Return .T.
		Endif
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem PRODUTOS BLOQUEADOS para o calculo de embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT C9_PRODUTO, C9_BLEST FROM " + cNameSC9 + " SC9 "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND C9_FILIAL = '" + cFilSC9 + "' "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND SC9.D_E_L_E_T_ = '' AND C9_BLEST <> '' "

	cQuery := ChangeQuery( cQuery )
	//MemoWrite("PRTM0003-C9_BLEST.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)

	COUNT TO _nRec

//Verifica se existem produtos com bloqueio de estoque
	If _nRec > 0
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
			Aviso("PRTM0003","Atencao! O pedido "  + cPedido + " tem itens com bloqueio de estoque. Não será possivel calcular embalagens.",{"Ok"})
		EndIf
//Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema
		(cAliasTRB)->(DbCloseArea())
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)
		Return .F.
	Endif
	(cAliasTRB)->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem PRODUTOS que não são do Armazém 21 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT C9_PRODUTO, C9_LOCAL FROM " + cNameSC9 + " SC9 "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND C9_FILIAL = '" + cFilSC9 + "' "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL <> '21' "
	cQuery += "AND SC9.D_E_L_E_T_ = '' "

	cQuery := ChangeQuery( cQuery )
	//MemoWrite("PRTM0003-DIFERENTE_21.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)

	COUNT TO _nRec

//Verifica se existem PRODUTOS que não são do Armazém 21
	If _nRec > 0
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
			Aviso("PRTM0003","Atencao! O pedido "  + cPedido + " tem itens que não pertencem ao armazém 21. Não será possivel calcular embalagens.",{"Ok"})
		EndIf
//Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema
		(cAliasTRB)->(DbCloseArea())
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)
		Return .F.
	Endif
	(cAliasTRB)->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se existem pedidos liberados para o calculo de embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT C9_PRODUTO, B1_YENDEST, B1_CODFAM,B1_YTOTEMB, B1_YLARG, B1_YALT, B1_YCOMP, B1_YPERRED, SUM(C9_QTDLIB) C9_QTDLIB FROM " + cNameSC9 + " SC9 "
	cQuery += "INNER JOIN " + cNameSB1 + " SB1 ON C9_PRODUTO = B1_COD AND B1_FILIAL = '" + cFilSB1 + "' AND SB1.D_E_L_E_T_ = '' "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND C9_FILIAL = '" + cFilSC9 + "' "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND SC9.D_E_L_E_T_ = '' AND C9_BLEST<>'02' "
	cQuery += "GROUP BY C9_PRODUTO,B1_YENDEST, B1_CODFAM, B1_YTOTEMB, B1_YLARG, B1_YALT, B1_YCOMP, B1_YPERRED "
	cQuery += "ORDER BY C9_PRODUTO "

	cQuery := ChangeQuery( cQuery )
	//MemoWrite("PRTM0003-calc.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)

	COUNT TO _nRec
	(cAliasTRB)->(dbGoTop())

//Verifica se o C9 foi gerado
	If _nRec = 0
		(cAliasTRB)->(DbCloseArea())
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. !IsInCallStack("U_TF_1AVN_A1") .AND. !IsInCallStack("U_TF_2AVN_A2") .AND. .NOT. lESTMI001
			Aviso("PRTM0003","Atencao! O pedido "  + cPedido + " nao foi liberado.",{"Ok"})
		EndIf
//Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)
		U_PRTM004(cPedido) //Alterado por Thiago em 15/07/2013
		Return .F.
	Endif

	While (cAliasTRB)->(!Eof())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega o cadastro de embalagens para validacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFirst
			If !LoadCaix()
				If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
					Aviso("PRTM0003","Atencao! Nao existem embalagens cadastradas. ",{"Ok"})
				EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RestOrd(aOrdBKP)
				DbSelectArea(cAliasBKP)
				Return .F.
			EndIf
			lFirst := .F.
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o produto esta com as medidas preenchidas corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty((cAliasTRB)->B1_YLARG) .OR. Empty((cAliasTRB)->B1_YALT) .OR. EMPTY((cAliasTRB)->B1_YCOMP) .OR. EMPTY((cAliasTRB)->B1_YTOTEMB)
			If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
				Aviso("PRTM0003","Pedido: "+cPedido+". Atencao! O produto "  + (cAliasTRB)->C9_PRODUTO + " esta com o cadastro incompleto. ",{"Ok"})
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)
			Return .F.
		EndIf
		If (cAliasTRB)->B1_YLARG <= 0 .OR. (cAliasTRB)->B1_YALT <= 0 .OR. (cAliasTRB)->B1_YCOMP <= 0 .OR. (cAliasTRB)->B1_YTOTEMB <= 0
			If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
				Aviso("PRTM0003","Pedido: "+cPedido+". Atencao! O produto "  + (cAliasTRB)->C9_PRODUTO + " esta com o cadastro ZERADO. ",{"Ok"})
			EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)
			Return .F.
		EndIf

		nVolInd := (cAliasTRB)->B1_YCOMP * (cAliasTRB)->B1_YLARG * (cAliasTRB)->B1_YALT * (1 - (cAliasTRB)->B1_YPERRED/100)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza o preenchimento das caixas fechadas e coloca as sobras para separacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasTRB)->C9_QTDLIB >= (cAliasTRB)->B1_YTOTEMB
			aAdd(aFechadas,{(cAliasTRB)->C9_PRODUTO,( ((cAliasTRB)->C9_QTDLIB - (cAliasTRB)->C9_QTDLIB%(cAliasTRB)->B1_YTOTEMB )) / ;
				(cAliasTRB)->B1_YTOTEMB,(cAliasTRB)->B1_YENDEST })
			If (cAliasTRB)->C9_QTDLIB%(cAliasTRB)->B1_YTOTEMB <> 0
				wwx := (cAliasTRB)->C9_QTDLIB%(cAliasTRB)->B1_YTOTEMB
				aAdd(aSaldos,{(cAliasTRB)->C9_PRODUTO,(cAliasTRB)->C9_QTDLIB%(cAliasTRB)->B1_YTOTEMB,nVolInd,nVolInd * wwx,(cAliasTRB)->B1_CODFAM})
			EndIf
		Else
			aAdd(aSaldos,{(cAliasTRB)->C9_PRODUTO,; 	//[1] - CODIGO DO PRODUTO
			(cAliasTRB)->C9_QTDLIB,;  	//[2] - QUANTIDADE
			nVolInd,;					 	//[3] - VOLUME CUBICO UNITARIO
			(cAliasTRB)->C9_QTDLIB * nVolInd,; //[4] - VOLUME CUBICO TOTAL
			(cAliasTRB)->B1_CODFAM})		//[5] - CODIGO DA FAMILIA
		EndIf

		(cAliasTRB)->(DbSkip())
	EndDo

	(cAliasTRB)->(DbCloseArea())

	aSort( aSaldos,,, { |x,y| x[4] < y[4]  } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica todos os produtos a fim de descobrir quais podem ser alocados totalmente na maior caixa,³
//³evitando assim que um mesmo produto seja dividido entre as caixas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nx := 1 to len(aSaldos)
		SB1->(DbSetOrder(1))

		While aSaldos[_nx][2] > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o produto cabe na maior caixa - Nao aloca o item, somente ira verificar se existe item muito grande³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (aSaldos[_nx][4] >= aCaixas[1][5])	.and. !(aSaldos[_nx][5] $ aCaixas[1][6]) //Verifica itens proibidos na caixa
				nSobra	:= Int((aCaixas[1][5]%aSaldos[_nx][4])/aSaldos[_nx][3])

				aItens	:= {}

				aAdd(aItens,{aSaldos[_nx][1],aSaldos[_nx][2]-nSobra})

				aSaldos[_nx][2] := nSobra
				aSaldos[_nx][4] := aSaldos[_nx][2] * aSaldos[_nx][3]

				aAdd(aSepara,{aCaixas[1][1],0,aClone(aItens)})
			Else
				Exit
			Endif
		EndDo
	Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pega os Saldos remanescentes para continuar com a montagem das Caixas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nx := 1 to len(aSaldos)

		While aSaldos[_nx][2] > 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Abertura de uma nova embalagem, se necessario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aSepara)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica, atraves do total a ser cubado qual o tamanho da embalagem mais adequada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTotVol := SomaVol(aSaldos) //Total de Cubagem a ser Embalado
				For _ny := 1 to len(aCaixas) //Inicia teste de caixas pela maior caixa
					If !aSaldos[_nx][5] $ aCaixas[_ny][6] //Verifica se o produto eh proibido na caixa
						If nTotVol >= aCaixas[_ny][5] //Verifica se o volume restante de produtos eh maior que a caixa Atual
							If _ny > 1 .and. !aSaldos[_nx][5] $ aCaixas[_ny - 1][6] //Se estiver na segunda caixa, verifica se a anterior eh permitido o tipo de produto
								aAdd(aSepara,{aCaixas[_ny - 1][1],aCaixas[_ny - 1][5],Nil,aCaixas[_ny - 1][6]}) //Se na caixa anterior for permitido o produto, utiliza caixa anterior a atual
								Exit
							Else //Usa a caixa atual para separacao
								aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6]}) //Usa a caixa atual para separar produto
								Exit
							Endif
						EndIf
						If _ny == len(aCaixas) //verifica se é a ultima caixa
							aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6]}) //Utiliza a menor caixa
						EndIf
					EndIf
				Next
			ElseIf aSepara[len(aSepara)][2] <= 0
				nTotVol := SomaVol(aSaldos) //Total de Cubagem a ser Embalado

				If !Empty(aItens)
					aSepara[len(aSepara)][3] := aClone(aItens)
					aItens := {}
				EndiF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica, atraves do total a ser cubado qual o tamanho da embalagem mais adequada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _ny := 1 to len(aCaixas)
					If !aSaldos[_nx][5] $ aCaixas[_ny][6]
						If nTotVol >= aCaixas[_ny][5]
							If _ny > 1 .and. !aSaldos[_nx][5] $ aCaixas[_ny - 1][6]
								aAdd(aSepara,{aCaixas[_ny - 1][1],aCaixas[_ny - 1][5],Nil,aCaixas[_ny - 1][6]})
								Exit
							Else
								aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6] })
								Exit
							Endif
						EndIf
						If _ny == len(aCaixas)
							aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6] })
						EndIf
					EndIF
				Next
			EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coloca os itens na embalagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//aAdd(aSaldos,{(cAliasTRB)->C9_PRODUTO,(cAliasTRB)->C9_QTDLIB, nVolInd, (cAliasTRB)->C9_QTDLIB * nVolInd, (cAliasTRB)->B1_CODFAM})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a Cubagem dos Itens seja menor ou igual a cubagem disponivel na caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aSaldos[_nx][4] <= aSepara[len(aSepara)][2]
				If !aSaldos[_nx][5] $ aSepara[len(aSepara)][4]
					nSobra	:= aSepara[len(aSepara)][2]-aSaldos[_nx][4]

					aAdd(aItens,{aSaldos[_nx][1],aSaldos[_nx][2]})

					nSaldo := aSaldos[_nx][2]
					aSaldos[_nx][2] := 0
					aSaldos[_nx][4] := 0

					aSepara[len(aSepara)][2] := nSobra
				Else
					aAdd(aResiduos, aClone(aSaldos[_nx]))
					aSaldos[_nx][2] := 0
					aSaldos[_nx][4] := 0

				EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a cubagem dos itens seja maior do que o espaco disponivel na caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Evita a quebra do mesmo volume em 2 embalagens. Tenta deixar os produtos na mesma caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
//Verifica se ja existem itens na caixa. Se sim, coloca a caixa como indisponivel, para evitar a quebra de produtos
//Caso a Caixa esteja vazia (sem itens) e houver quebra - tratamento para evitar loop infinito. nesse caso, havera a quebra
			Elseif Empty(aItens)
//			nSobra	:= Int((aSaldos[_nx][4]%aSepara[len(aSepara)][2])/aSaldos[_nx][3])

				If !aSaldos[_nx][5] $ aSepara[len(aSepara)][4]
					nCubUni := aSaldos[_nx][3]
					nVolCx	:= aSepara[len(aSepara)][2]

					If nCubUni > nVolCx
						nSobra := 0
					Else
						nSobra := Int(aSepara[len(aSepara)][2] / aSaldos[_nx][3]  )
					EndIf

					aSepara[len(aSepara)][2] := 0

					If nSobra > 0
						aAdd(aItens,{aSaldos[_nx][1],nSobra})
						aSaldos[_nx][2] -= nSobra
						aSaldos[_nx][4] := aSaldos[_nx][2] * aSaldos[_nx][3]
					EndIF
				Else
					aAdd(aResiduos, aClone(aSaldos[_nx]))
					aSaldos[_nx][2] := 0
					aSaldos[_nx][4] := 0
				Endif
			Else
//Quebra de embalagens - Torna a caixa indisponivel
				aSepara[len(aSepara)][2] := 0
			Endif
		EndDo
	Next

//Quebra de embalagens - Torna a caixa indisponivel
	If !Empty(aItens)
		aSepara[len(aSepara)][2] := 0
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coloca os itens remanescentes da Ultima Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aItens)
		aSepara[len(aSepara)][3] := aClone(aItens)
		aItens := {}
	EndiF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Trata os Residuos que nao puderam entrar em caixas por restricoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nx := 1 to len(aResiduos)

		While aResiduos[_nx][2] > 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Abertura de uma nova embalagem, se necessario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aSepara)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica, atraves do total a ser cubado qual o tamanho da embalagem mais adequada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nTotVol := SomaVol(aResiduos) //Total de Cubagem a ser Embalado
				For _ny := 1 to len(aCaixas)
					If !aResiduos[_nx][5] $ aCaixas[_ny][6]
						If nTotVol >= aCaixas[_ny][5]
							If _ny > 1 .and. !aResiduos[_nx][5] $ aCaixas[_ny - 1][6]
								aAdd(aSepara,{aCaixas[_ny - 1][1],aCaixas[_ny - 1][5],Nil,aCaixas[_ny - 1][6]})
								Exit
							Else
								aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6]})
								Exit
							Endif
						EndIf
						If _ny == len(aCaixas)
							aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6]})
						EndIf
					EndIf
				Next
			ElseIf aSepara[len(aSepara)][2] <= 0
				nTotVol := SomaVol(aResiduos) //Total de Cubagem a ser Embalado

				If !Empty(aItens)
					aSepara[len(aSepara)][3] := aClone(aItens)
					aItens := {}
				EndiF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica, atraves do total a ser cubado qual o tamanho da embalagem mais adequada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _ny := 1 to len(aCaixas)
					If !aResiduos[_nx][5] $ aCaixas[_ny][6]
						If nTotVol >= aCaixas[_ny][5]
							If _ny > 1 .and. !aResiduos[_nx][5] $ aCaixas[_ny - 1][6]
								aAdd(aSepara,{aCaixas[_ny - 1][1],aCaixas[_ny - 1][5],Nil,aCaixas[_ny - 1][6]})
								Exit
							Else
								aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6] })
								Exit
							Endif
						EndIf
						If _ny == len(aCaixas)
							aAdd(aSepara,{aCaixas[_ny][1],aCaixas[_ny][5],Nil,aCaixas[_ny][6] })
						EndIf
					EndIF
				Next
			EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coloca os itens na embalagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//aAdd(aSaldos,{(cAliasTRB)->C9_PRODUTO,(cAliasTRB)->C9_QTDLIB, nVolInd, (cAliasTRB)->C9_QTDLIB * nVolInd, (cAliasTRB)->B1_CODFAM})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a Cubagem dos Itens seja menor ou igual a cubadem disponivel na caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aResiduos[_nx][4] <= aSepara[len(aSepara)][2]
				If !aResiduos[_nx][5] $ aSepara[len(aSepara)][4]
					nSobra	:= aSepara[len(aSepara)][2]-aResiduos[_nx][4]

					aAdd(aItens,{aResiduos[_nx][1],aResiduos[_nx][2]})

					nSaldo := aResiduos[_nx][2]
					aResiduos[_nx][2] := 0
					aResiduos[_nx][4] := 0

					aSepara[len(aSepara)][2] := nSobra
				Else
					aAdd(aResiduos, aClone(aResiduos[_nx]))
					aResiduos[_nx][2] := 0
					aResiduos[_nx][4] := 0
					aSepara[len(aSepara)][2] := 0
				EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a cubagem dos itens seja maior do que o espaco disponivel na caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Evita a quebra do mesmo volume em 2 embalagens. Tenta deixar os produtos na mesma caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
//Verifica se ja existem itens na caixa. Se sim, coloca a caixa como indisponivel, para evitar a quebra de produtos
//Caso a Caixa esteja vazia (sem itens) e houver quebra - tratamento para evitar loop infinito. nesse caso, havera a quebra
			Elseif Empty(aItens)
//			nSobra	:= Int((aResiduos[_nx][4]%aSepara[len(aSepara)][2])/aResiduos[_nx][3])
				If !aResiduos[_nx][5] $ aSepara[len(aSepara)][4]
					nCubUni := aResiduos[_nx][3]
					nVolCx	:= aSepara[len(aSepara)][2]

					If nCubUni > nVolCx
						nSobra := 0
					Else
						nSobra := Int(aSepara[len(aSepara)][2] / aResiduos[_nx][3]  )
					EndIf

					aSepara[len(aSepara)][2] := 0

					If nSobra > 0
						aAdd(aItens,{aResiduos[_nx][1],nSobra})
						aResiduos[_nx][2] -= nSobra
						aResiduos[_nx][4] := aResiduos[_nx][2] * aResiduos[_nx][3]
					EndIF
				Else
					aAdd(aResiduos, aClone(aResiduos[_nx]))
					aResiduos[_nx][2] := 0
					aResiduos[_nx][4] := 0
					aSepara[len(aSepara)][2] := 0
				Endif
			Else
//Quebra de embalagens - Torna a caixa indisponivel
				aSepara[len(aSepara)][2] := 0
			Endif
		EndDo
	Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Coloca os itens remanescentes da Ultima Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aItens)
		aSepara[len(aSepara)][3] := aClone(aItens)
		aItens := {}
	EndiF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia a Gravação do Calculo de Embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as Embalagens fechadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSort(aFechadas,,, { |x, y| x[3] < y[3] }) //Ordena por Endereços B1_YENDEST

		For _nx := 1 to len(aFechadas)
			For _ny := 1 to aFechadas[_nx][2]
				cSeqCX := SomaIt(cSeqCX)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho do Calculo de Embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RecLock("ZZF",.T.)
					ZZF->ZZF_FILIAL		:= xFilial("ZZF")
					ZZF->ZZF_PEDIDO 	:= cPedido
					ZZF->ZZF_SEQCX		:= cSeqCX
					ZZF->ZZF_CODEMB     := "CXFECH"
					ZZF->ZZF_DSCEMB		:= Posicione("SB1",1,cFilSB1 + aFechadas[_nx][1],"B1_DESC")
					ZZF->ZZF_TPSEP		:= "F"
					ZZF->(MsUnLock())
				Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Itens do Calculo de Embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RecLock("ZZG",.T.)
					ZZG->ZZG_FILIAL := xFilial("ZZG")
					ZZG->ZZG_PEDIDO := cPedido
					ZZG->ZZG_SEQCX	:= cSeqCX
					ZZG->ZZG_CODEMB := "CXFECH"
					ZZG->ZZG_PRODUT	:= aFechadas[_nx][1]
					ZZG->ZZG_DSCPRD	:= Posicione("SB1",1,cFilSB1 + aFechadas[_nx][1],"B1_DESC")
					ZZG->ZZG_GRPPRO := SB1->B1_GRUPO
					ZZG->ZZG_ENDEST	:= SB1->B1_YENDEST
					ZZG->ZZG_ESTAC	:= SB1->B1_YESTAC
					ZZG->ZZG_QUANT	:= SB1->B1_YTOTEMB
					ZZG->ZZG_YENDSE	:= SB1->B1_YENDSEP
					ZZG->(MsUnLock())
				Endif
			Next
		Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava as Caixas de Separacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nx := 1 to len(aSepara)
			cSeqCX := SomaIt(cSeqCX)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho do Calculo de Embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If RecLock("ZZF",.T.)
				ZZF->ZZF_FILIAL		:= xFilial("ZZF")
				ZZF->ZZF_PEDIDO 	:= cPedido
				ZZF->ZZF_SEQCX		:= cSeqCX
				ZZF->ZZF_CODEMB     := aSepara[_nx][1]
				ZZF->ZZF_DSCEMB		:= Posicione("ZZD",1,xFilial("ZZD") + aSepara[_nx][1],"ZZD_DESEMB")
				ZZF->ZZF_TPSEP		:= "S"
				ZZF->(MsUnLock())
			Endif

			For _ny := 1 to len(aSepara[_nx][3])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Itens do Calculo de Embalagens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If RecLock("ZZG",.T.)
					ZZG->ZZG_FILIAL := xFilial("ZZG")
					ZZG->ZZG_PEDIDO := cPedido
					ZZG->ZZG_SEQCX	:= cSeqCX
					ZZG->ZZG_CODEMB	:= aSepara[_nx][1]
					ZZG->ZZG_PRODUT	:= aSepara[_nx][3][_ny][1]
					ZZG->ZZG_DSCPRD	:= Posicione("SB1",1,cFilSB1 + aSepara[_nx][3][_ny][1],"B1_DESC")
					ZZG->ZZG_GRPPRO := SB1->B1_GRUPO
					ZZG->ZZG_ENDEST	:= SB1->B1_YENDEST
					ZZG->ZZG_ESTAC	:= SB1->B1_YESTAC
					ZZG->ZZG_QUANT	:= aSepara[_nx][3][_ny][2]
					ZZG->ZZG_YENDSE	:= SB1->B1_YENDSEP
					ZZG->(MsUnLock())
				Endif
			Next
		Next

	End transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza ZZG: grava RECNO do SC9 em cada item separado          ³
//³Arlete - marco 2013													 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

	cQuery := "UPDATE "+RetSqlName("ZZG")+" SET ZZG_SC9 = "+cNameSC9+".R_E_C_N_O_ "
	cQuery += "FROM "+RetSqlName("ZZG")+","+cNameSC9+" "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND ZZG_PEDIDO = C9_PEDIDO "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND ZZG_PRODUT = C9_PRODUTO "
	cQuery += "AND ZZG_SC9 = '' "
	cQuery += "AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
	cQuery += "AND "+cNameSC9+".D_E_L_E_T_ <> '*' "
	//MemoWrite("PRTM0003-SC9-ZZG.sql",cQuery)
	TCSQLExec(cQuery)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza o Status do Pedido de Venda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
//IKK

	cQueryIK := " SELECT COUNT(*) AS QTDCXIK "
	cQueryIK += " FROM "+RetSqlName("ZZF")
	cQueryIK += " WHERE D_E_L_E_T_ <> '*' "
	cQueryIK += " AND ZZF_FILIAL = '"+xFilial("ZZF")+"'"
	cQueryIK += " AND ZZF_PEDIDO='"+cPedido+"'"
	cQueryIK += " AND ZZF_YDICNF=''"

	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),"QRYIK", .F., .T.)
//DbGoTop()
	WQTDCXIK:= QRYIK->QTDCXIK
	dbCloseArea()

	cQueryIK := " SELECT SUM(ZZG_QUANT * B1_PESO) AS PESOIK "
	cQueryIK += " FROM "+RetSqlName("ZZG")+" ZZG," + RetSqlName("SB1")+" SB1"
	cQueryIK += " WHERE ZZG.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' "
	cQueryIK += " AND ZZG_FILIAL = '"+xFilial("ZZG")+"' AND B1_FILIAL='"+xFilial("SB1")+"'"
	cQueryIK += " AND ZZG_PEDIDO='"+cPedido+"' AND ZZG_PRODUT=B1_COD"

	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),"QRYIK", .F., .T.)

//DbGoTop()
	WPESOIK:= QRYIK->PESOIK
	dbCloseArea()

// Query -> ajustada para considerar liberação parcial (ZZG_SC9 já gravado)
	cQueryIK := " SELECT SUM(ZZG_QUANT) AS ZZGIK "
	cQueryIK += " FROM "+RetSqlName("ZZG")+" ZZG "
	cQueryIK += " INNER JOIN "+RetSqlName("SC9")+" SC9 "
	cQueryIK += " ON SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND ZZG.ZZG_SC9 = SC9.R_E_C_N_O_ AND SC9.D_E_L_E_T_ <> '*' "
	cQueryIK += " WHERE ZZG.D_E_L_E_T_ <> '*' "
	cQueryIK += " AND ZZG_FILIAL = '"+xFilial("ZZG")+"'"
	cQueryIK += " AND ZZG_PEDIDO='"+cPedido+"'"
	cQueryIK += " AND SC9.C9_NFISCAL = '' "

/*Query -> liberação total
cQueryIK := " SELECT SUM(ZZG_QUANT ) AS ZZGIK "
cQueryIK += " FROM "+RetSqlName("ZZG")+" ZZG "
cQueryIK += " WHERE ZZG.D_E_L_E_T_ <> '*' "
cQueryIK += " AND ZZG_FILIAL = '"+xFilial("ZZG")+"'"
cQueryIK += " AND ZZG_PEDIDO='"+cPedido+"'"
*/

	cQueryIK := ChangeQuery( cQueryIK )
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),(_cAlias := GetNextAlias()), .F., .T.)

//dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),"QRYIK", .F., .T.)
	WQTDZZGIK := (_cAlias)->ZZGIK
	dbCloseArea()

	cQueryIK := " SELECT SUM(C9_QTDLIB ) AS C9QTDLIBIK "
	cQueryIK += " FROM "+RetSqlName("SC9")+" SC9 "
	cQueryIK += " WHERE SC9.D_E_L_E_T_ <> '*' "
	cQueryIK += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
	cQueryIK += " AND C9_PEDIDO='"+cPedido+"'"
	cQueryIK += " AND C9_NFISCAL = '' "
	cQueryIK += " AND C9_LOCAL = '21' "
	cQueryIK += " AND C9_BLEST<>'02' "

	cQueryIK := ChangeQuery( cQueryIK )
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),(_cAlias2 := GetNextAlias()), .F., .T.)

//dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),"QRYIK", .F., .T.)
	WQTDSC9IK := (_cAlias2)->C9QTDLIBIK
	dbCloseArea()

	WSTERROIK := .F.
	IF  WQTDZZGIK == WQTDSC9IK
		U_M003LOG(,SC5->C5_NUM,"Calculo de Embalagens realizado com Sucesso!")
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. !IsInCallStack("U_TF_1AVN_A1") .AND. !IsInCallStack("U_TF_2AVN_A2") .AND. .NOT. lESTMI001
			MsgAlert("Calculo de Embalagens realizado com Sucesso!")
		EndIf
	ELSE
		U_M003LOG(,SC5->C5_NUM,"ERRO NO Calculo de Embalagens!")
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
			MsgAlert("ERRO NO Calculo de Embalagens!")
		EndIf
		WSTERROIK := .T.
	ENDIF

	Begin transaction

		If RecLock("SC5",.F.)
			IF WSTERROIK
				SC5->C5_YSTSEP := "E"
			ELSE
				SC5->C5_YSTSEP := "N"
			ENDIF
//SC5->C5_YFMES   := ""
			SC5->C5_VOLUME1 := WQTDCXIK
			SC5->C5_ESPECI1 := "CAIXAS"
			SC5->C5_PESOL   := WPESOIK
			SC5->C5_PBRUTO  := WPESOIK
			SC5->(MsUnLock())
		EndIf

		/*
		|---------------------------------------------------------------------------------
		|	Realiza a Manutencao do Status do Pedido de Venda no CD de SP
		|---------------------------------------------------------------------------------
		*/
		IF !WSTERROIK

			/*
			|---------------------------------------------------------------------------------
			|	Analise das Quantidades Vendidas contra as Liberadas para determinar o Status 
			|---------------------------------------------------------------------------------
			*/
			CQUERY 	:= "SELECT SUM(C9_QTDLIB) AS NQTDLIB FROM " + RETSQLNAME("SC9") + " SC9 WHERE SC9.C9_FILIAL = '" + XFILIAL("SC9") + "' AND SC9.C9_PEDIDO = '" + SC5->C5_NUM + "' AND SC9.C9_NFISCAL = '' AND SC9.C9_BLEST = '' AND SC9.D_E_L_E_T_ = ''"
			IF SELECT("TMP") > 0
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
			ENDIF
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			NQTDSC9 := TMP->NQTDLIB
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			CQUERY 	:= "SELECT SUM(C6_QTDVEN) AS NQTDVEN FROM " + RETSQLNAME("SC6") + " SC6 WHERE SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND SC6.C6_NUM = '" + SC5->C5_NUM + "' AND SC6.D_E_L_E_T_ = ''"
			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			NQTDSC6 := TMP->NQTDVEN
			DBSELECTAREA("TMP")
			DBCLOSEAREA()

			IF NQTDSC6 - NQTDSC9 != 0

				CQUERY := "UPDATE SC5030 SET C5_STCROSS = 'LIBPAR' WHERE C5_FILIAL = '01' AND C5_NUM = '" + SC5->C5_NUMORI + "' AND D_E_L_E_T_ = ''"

			ELSE

				CQUERY := "UPDATE SC5030 SET C5_STCROSS = 'LIBTOT' WHERE C5_FILIAL = '01' AND C5_NUM = '" + SC5->C5_NUMORI + "' AND D_E_L_E_T_ = ''"

			ENDIF

			IF TCSQLEXEC(CQUERY) != 0
				If .NOT. lESTMI001
					MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas no CD de SP!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
				EndIf
			ENDIF

		ENDIF

	End Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza SC9: grava numero da caixa de cada produto da liberação atual ³
//³Arlete - marco 2013															 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

	cQuery := "UPDATE " + cNameSC9 + " SET C9_ORDSEP = ZZG_SEQCX "
	cQuery += "FROM "+cNameSC9+","+RetSqlName("ZZG")+" "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND C9_PEDIDO = ZZG_PEDIDO "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND C9_PRODUTO = ZZG_PRODUT "
	cQuery += "AND "+cNameSC9+".R_E_C_N_O_ = ZZG_SC9 "
	cQuery += "AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
	cQuery += "AND "+cNameSC9+".D_E_L_E_T_ <> '*' "
	//MemoWrite("PRTM0003-UPD-SC9_ORDSEP.sql",cQuery)
	TCSQLExec(cQuery)

//QUERY PARA IDENTIFICAR OS DE COR LARANJA
	/*	
	cQuery1 := " UPDATE "+RETSQLNAME("SC5")+" C5 SET C5__YVERSL ='N' WHERE (C5_FILIAL+C5_NUM) IN
	cQuery1 += " 		( "
	cQuery1 += "			SELECT DISTINCT (C9_FILIAL+C9_PEDIDO) "
	cQuery1 += " 			FROM "
	cQuery1 += "			"+RETSQLNAME("SC9")+" C9 "
    cQuery1 += "            WHERE "
    cQuery1 += "			C9_NFISCAL='' "
	cQuery1 += "			 AND C9_ORDSEP <>' ' AND C9.D_E_L_E_T_ =' ' "
	cQuery1 += "		) "
	cQuery1 += " AND C5.D_E_L_E_T_ =' ' "
	TCSQLExec(cQuery1)
	*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza ZZF: Grava Data e Hora do Calculo                      ³
//³Arlete - marco 2013													³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

	cQuery := "UPDATE "+RetSqlName("ZZF")+" SET ZZF_DHCALC = '"+cDataH+"' "
	cQuery += "FROM "+RetSqlName("ZZF")+","+cNameSC9+" "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND ZZF_PEDIDO = C9_PEDIDO "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND ZZF_USRCNF = '' "
	cQuery += "AND "+RetSqlName("ZZF")+".D_E_L_E_T_ <> '*' "
	cQuery += "AND "+cNameSC9+".D_E_L_E_T_ <> '*' "
	//MemoWrite("PRTM0003-UPD-ZZF_DHCALC.sql",cQuery)
	TCSQLExec(cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza ZZG: Grava Data e Hora do Calculo                      ³
//³Arlete - marco 2013													 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

	cQuery := "UPDATE "+RetSqlName("ZZG")+" SET ZZG_DHCALC = '"+cDataH+"' "
	cQuery += "FROM "+RetSqlName("ZZG")+","+cNameSC9+" "
	cQuery += "WHERE C9_PEDIDO = '" + cPedido + "' "
	cQuery += "AND ZZG_PEDIDO = C9_PEDIDO "
	cQuery += "AND C9_NFISCAL = '' "
	cQuery += "AND C9_LOCAL = '21' "
	cQuery += "AND ZZG_PRODUT = C9_PRODUTO "
	cQuery += "AND "+cNameSC9+".R_E_C_N_O_ = ZZG_SC9 "
	cQuery += "AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
	cQuery += "AND "+cNameSC9+".D_E_L_E_T_ <> '*' "
	//MemoWrite("PRTM0003-UPD-ZZG_DHCALC.sql",cQuery)
	TCSQLExec(cQuery)

//Grava LOG
	_cAlias		:= "SC5"
	_cChave		:= xFilial("SC5")+SC5->C5_NUM
	_dDtIni		:= Date()
	_cHrIni		:= Time()
	_cDtFim		:= CTOD("")
	_cHrFim		:= ""
	_cCodUser	:= __CUSERID
	_cEstacao	:= ""
	_cOperac	:= UPPER("17 - Calculo de embalagens efetuado para a liberação do pedido em "+alltrim(cDataH)+".")
	_cFuncao	:= "U_PRTM0003"
	U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0003  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do Log de Ocorrencias do Calculo de Embalagens     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaLog(cPedido, cMensagem)

	Begin Transaction

		If RecLock("SC5",.F.)
			SC5->C5_YSTSEP := "E"
			SC5->C5_YLGCNF := Alltrim(SC5->C5_YLGCNF) + DtoC(dDataBase) + " - " + ;
				Alltrim(UsrFullName(RetCodUsr())) + " - " + Alltrim(cMensagem) + Chr(13) + Chr(10)
			SC5->(MsUnLock())
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Gravacao do Log de Pre-Pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_M003LOG(,SC5->C5_NUM,"Tentativa de Calculo de Embalagens. Erro: " + Alltrim(cMensagem))

	End Transaction

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0003  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega o Cadastro de Embalagens                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LoadCaix()

	Local cQuery 	:= ""
	Local lRet		:= .F.
	Local cNameZZD	:= RetSQLName("ZZD")
	Local cFilZZD	:= xFilial("ZZD")
	Local cNameZZE	:= RetSQLName("ZZE")
	Local cFilZZE	:= xFilial("ZZE")
	Local cAliasTR1	:= GetNextAlias()
	Local cAliasTR2	:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as embalagens disponiveis para armazenagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT * FROM " + cNameZZD + " ZZD "
	cQuery += "WHERE ZZD_FILIAL = '" + cFilZZD + "' "
	cQuery += "AND ZZD.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER BY ZZD_CUBAGE DESC "

	TcQuery cQuery ALIAS &(cAliasTR1) NEW

	While (cAliasTR1)->(!Eof())
		lRet := .T.
		aAdd(aCaixas,{(cAliasTR1)->ZZD_CODIGO,; //1
		(cAliasTR1)->ZZD_COMP,; //2
		(cAliasTR1)->ZZD_LARG,; //3
		(cAliasTR1)->ZZD_ALT,;  //4
		(cAliasTR1)->ZZD_CUBAGE,; //5
		""})  //6

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[¿
//³Verifica as Execeções da Caixa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[Ù
		cQuery := "SELECT * FROM " + cNameZZE + " ZZE "
		cQuery += "WHERE ZZE_FILIAL = '" + cFilZZE + "' "
		cQuery += "AND ZZE.D_E_L_E_T_ <> '*' "
		cQuery += "AND ZZE_CODIGO = '" + (cAliasTR1)->ZZD_CODIGO + "' "

		TcQuery cQuery ALIAS &(cAliasTR2) NEW

		While (cAliasTR2)->(!Eof())
			aCaixas[len(aCaixas)][6] += Alltrim((cAliasTR2)->ZZE_GRUPO) + "|"
			(cAliasTR2)->(DbSkip())
		EndDo
		(cAliasTR2)->(DbCloseArea())


		(cAliasTR1)->(DbSkip())
	EndDo

	(cAliasTR1)->(DbCloseArea())


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0003  ºAutor  ³FSW Veti            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calcula o Restante de Volumes a serem embalados             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaVol(aSaldos)

	Local nTotVol := 0

	aEval(aSaldos, {|x| nTotVol += x[4]})

Return nTotVol


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRTM0003  ºAutor  ³FSW VETI            º Data ³     08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Realiza a Gravacao do Log na Tabela de Pre-Pedido           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³PROART                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M003LOG(cPrePed,cPedVen,cMensagem)

	Local cQuery	:= ""
	Local cAliasBKP	:= Iif(Empty(Alias()),"ZZC",Alias())
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZC"})
	Local cNameZZA	:= RetSQLName("ZZA")
	Local cFilZZA	:= xFilial("ZZA")
	Local cAliasTRB	:= GetNextAlias()

	Default cPrePed 	:= ""
	Default cPedVen		:= ""
	Default cMensagem 	:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se os parametros passados foram preenchidos corretamente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cMensagem)
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
			Aviso("M003LOG","Mensagem em branco. O Log de pré-pedido não será gerado. Contate o Administrador!",{"Ok"})
		EndIf
		Return .F.
	Endif

	If Empty(cPrePed) .and. Empty(cPedVen)
		If !IsInCallStack("U_FATMI002") .AND. !IsInCallStack("U_FINMI001") .AND. .NOT. lESTMI001
			Aviso("M003LOG","Codigo do Pedido ou Pre-pedido não informado. O Log de pré-pedido não será gerado. Contate o Administrador!",{"Ok"})
		EndIf
		Return .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso não tenha o numero do pre-pedido, localiza o pre pedido pelo numero do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(cPrePed)
		cQuery := "SELECT ISNULL(ZZA_NUMOLD,'') ZZA_NUMOLD FROM " + cNameZZA + " ZZA "
		cQuery += "WHERE ZZA_FILIAL = '" + cFilZZA + "' "
		cQuery += "AND ZZA_SC5NUM = '" + cPedVen + "' "
		cQuery += "AND ZZA.D_E_L_E_T_ <> '*' "

		TcQuery cQuery ALIAS &(cAliasTRB) NEW


		If (cAliasTRB)->(!Eof()) .and. (cAliasTRB)->(!Bof())
			cPrePed := (cAliasTRB)->ZZA_NUMOLD
		Endif

		(cAliasTRB)->(DbCloseArea())

	Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return .T.
