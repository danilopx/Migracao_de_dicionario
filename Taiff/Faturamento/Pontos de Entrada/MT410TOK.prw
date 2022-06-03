#include "PROTHEUS.CH"
#Include 'TopConn.ch'

#Define cPl Chr(13) + Chr(10)
#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410TOK ºAutor  ³ Fernando Salvatori º Data ³ 05/01/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida todas as linhas do GETDADOS antes da conclusao      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT410TOK

	Local _lRet  		:= .T.
	Local _nX    		:= 0
	Local _nBkpN 		:= N
	Local _dAtual 		:= DTOS(Date())
	Local _Suframa		:= ""
	Local _CalcSuf		:= ""
	Local _VldSufr		:= ""
	//Local _lRegimeRet	:= .F.
	Local _nTotSC6		:= 0
	Local n_nx			:= 0

	//Local cEmpSep		:= GetNewPar("PRT_SEP005","99")
	//Local cFilSep		:= GetNewPar("PRT_SEP006","01")
	//Local cPrePed		:= GetNewPar("PRT_SEP009","S")

	Local cCondLvr		:= GetNewPar("TF_CONDLVR","501")
	//Local nIcmst  		:= 0
	Local nComiss		:= 0

	Local cPerCalFCI 	:= ""
	Local cQuery 		:= ""
	Local cQryTmp		:= ""
	//Local _cTForigemP := ""
	//Local	_cTFclasfis := ""
	Local _lCont		:= .T.
	Local lMessC6Oper
	Local CC6XOPER
	Local lCrosPedOk	:= .T.
	Local NRECNOANT	:= 0
	Local lArm21Ok		:= .F.
	Local lMudaArm 	:= .F.
	Local cC6RESERVA	:= ""
	Local _lRecLimCred := .F.
	Local _nTotSC6Ant  := 0
	Local _lPedidoCrm := .F.
	LOCAL LPOSNUMOS		:= (SC6->(FIELDPOS("C6_XNUMOS")) > 0)
	LOCAL C6XNUMOS		:= ""
	LOCAL CC6OPER 		:= ""
	Local cTESF01 := SuperGetMV("MT410TOK",,"555")
	Local cMsgErr := "" 



	private _cJaValidou := ""
	PRIVATE ADETPED		:= {}
	PRIVATE NQTDPED		:= 0
	PRIVATE NREGS		:= 0
	PRIVATE XNOPC		:= PARAMIXB[1]
	PRIVATE LINTERC		:= .T.
	PRIVATE AAREASC5	:= SC5->(GETAREA())
	PRIVATE AAREASC6	:= SC6->(GETAREA())
	PRIVATE AAREA		:= GETAREA()

	//Verifica se e' permitido o uso da TES escolhida
	If !Empty(cTESF01)
		If cEmpAnt == "04" .And. cFilAnt <> "01"
			For _nX := 1 to Len( aCols )
				If aCols[_nX][GDFieldPOS("C6_TES")] $ cTESF01
					cMsgErr += "Item " +aCols[_nX][GDFieldPOS("C6_ITEM")]+ " - TES " +aCols[_nX][GDFieldPOS("C6_TES")] +CRLF
				EndIf
			Next _nX
			If !Empty(cMsgErr)
				Alert("ERRO"+CRLF+CRLF+"Não será possível prosseguir, pois os itens abaixo"+CRLF+"estão usando TES específicas da filial 01:"+CRLF+CRLF+cMsgErr)
				Return(.F.)
			EndIf
		EndIf
	EndIf


	/*
	|---------------------------------------------------------------------------------
	|	Realiza a validacao do Cliente verificando se eh do Grupo.
	|---------------------------------------------------------------------------------
	*/

	CQUERY := "SELECT '.T.' AS EXISTE FROM SM0_COMPANY WHERE M0_CGC = '" + POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC") + "'"
	IF SELECT("EMP") > 0
		DBSELECTAREA("EMP")
		DBCLOSEAREA()
	ENDIF
	TCQUERY CQUERY NEW ALIAS "EMP"
	DBSELECTAREA("EMP")
	DBGOTOP()
	LINTERC := EMP->EXISTE
	LINTERC := IIF(EMPTY(ALLTRIM(LINTERC)),.F.,.T.)

	/******************************************************************************************************
		Autor: Carlos Torres
		Data: 19/08/2021
		Observação: Uso exclusivo da empresa ACTION - Indaiatuba para estorno de liberação de pedido de 
					beneficiamento, a quantidade liberada retornará ao empenho do endereço B2_QEMP.
					Este trecho está associado no PE MT440GR.PRW que ocorre a remoção do B2_QEMP para evitar
					o bloqueio de estoque na liberação do pedido.
	*******************************************************************************************************/
	IF CEMPANT="04" .AND. CFILANT$"01|02" .AND. SC5->C5_TIPO="B" .AND. ALTERA
		SB2->(DBSETORDER(1))
		SC6->(DBSETORDER(1)) //C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
		For _nX := 1 to Len( aCols )
			COPBENEF:= aCols[_nX][GDFieldPOS("C6__OPBNFC")]
			IF .NOT. EMPTY(COPBENEF)
				NCLOCPEST:= aCols[_nX][GDFieldPOS("C6_LOCAL")]
				CPRODUTO:= aCols[_nX][GDFieldPOS("C6_PRODUTO")]
				CITEMPED:= aCols[_nX][GDFieldPOS("C6_ITEM")]
				NQEMPEST := 0

				IF SC6->(DBSEEK(XFILIAL("SC6") + SC5->C5_NUM + CITEMPED + CPRODUTO ))
					NQEMPEST := SC6->C6_QTDEMP
				ENDIF
				IF SB2->(DBSEEK(XFILIAL("SB2") + CPRODUTO + NCLOCPEST))
					IF SB2->(RECLOCK("SB2",.F.))
						SB2->B2_QEMP := SB2->B2_QEMP + (NQEMPEST)
					ENDIF
					SB2->(MsUnlock())
				ENDIF
			ENDIF
		NEXT _nX
	ENDIF
	/*
		A regras definidas a partir deste ponto em diante não se aplicam a empresa ACTION – Varginha, em qualquer circunstância. 
	*/
	IF CEMPANT="04" .AND. CFILANT="02"
		RETURN .T.
	ENDIF

	/******************************************************************************************************
		Autor: Gilberto Ribeiro Junior 
		Data: 09/06/2020
		Comentário: Trecho utilizado para atualizar o Saldo Disponível de Crédito quando o pedido é 
		alterado ou excluído. E para pedidos do Poratl CRM (TAIFF) não permite Exclusão.
		Observação: Função reposicionada para não impactar na "deleção" na linha do item do pedido e execução
				somente na empresa TAIFFPROART
	*******************************************************************************************************/
	IF CEMPANT = "03"
		If !Empty(SC5->C5_NUMOLD)
			_lPedidoCrm := .T.
			For _nX := 1 to Len(AllTrim(SC5->C5_NUMOLD))
				If !IsDigit(SubStr(AllTrim(SC5->C5_NUMOLD), _nX, 1))
					_lPedidoCrm := .F. // Pedido CRM não tem letra
					Exit
				EndIf
			Next _nX
		EndIf
	ELSE
		_lPedidoCrm := .F. // Pedido CRM não tem letra
	ENDIF


	/*
	|---------------------------------------------------------------------------------
	|	Faz a validacao da Exclusao do Pedido de Venda 
	|---------------------------------------------------------------------------------
	*/
	IF (CEMPANT + CFILANT) != (SC5->C5_EMPDES + SC5->C5_FILDES) .AND. XNOPC = 5 .AND. ( TYPE("L410AUTO") <> "U" .AND. !L410AUTO )

		MSGINFO("Pedido de Venda só pode ser excluída na Empresa Destino e se não houver atendimento!","ATENÇÃO")
		RETURN .F.

	ELSEIF (CEMPANT + CFILANT) = "0301" .AND. INCLUI = ALTERA .AND. XNOPC != 2 .AND. !Empty(SC5->C5_STCROSS) .AND. SC5->C5_CLASPED $ "V|X" //.AND. !LINTERC

		IF .NOT. SC5->C5_STCROSS $ "ABERTO|AGCOPY"

			MSGINFO("Pedido de Venda não pode ser excluido pois já houve atendimento!","ATENÇÃO")
			RETURN .F.

		ELSEIF SC5->C5_STCROSS $ "ABERTO"

			MSGRUN("Excluindo o Pedido Cópia na empresa Taiff Extrema CD!","AGUARDE",{|| EXCPEDCPY(SC5->C5_NUM)})
			_LRET := .T.
			///////////
			//// REFORÇAR O RETORNO DA FUNÇÃO "EXCPEDCPY" SE EFETIVAMENTE EXCLUIU O PEDIDO EM EXTREMA
			///////////

		ENDIF

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Faz a leitura da variavel Global declarada no PE MA330OK com os valores. 
	|---------------------------------------------------------------------------------
	*/
	If (CEMPANT + CFILANT = "0301" .AND. ALTERA) .OR. (CEMPANT + CFILANT = "0302" .AND. M->C5_FILDES='01' .AND. ALTERA)
		GETGLBVARS("aGlbMT410",@ADETPED)
	Endif

	SF4->(DbSetOrder(1))
	DBSelectArea("SC6")

	cC6RESERVA := ""
	If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->(FIELDPOS("C5__DTLIBF")) > 0
		cC6RESERVA := 	M->C5__RESERV
	EndIf

	For n_nx:= 1 to Len(aCols)
		// Se for pedido proveniente do CRM, não permite a exlcusão do mesmo
		If GDdeleted(n_nx) .and. _lPedidoCrm .and. M->C5_INTER != "S"
			MsgAlert("Este pedido teve origem no sistema CRM, portanto, o mesmo não pode ser excluído. Caso necessário, utilize a função para Eliminar Resíduo.")
			Return .F.
		EndIf

		NQTDPED += aCols[n_nx][GDFieldPOS("C6_QTDVEN")]
		CC6XOPER := aCols[n_nx][GDFieldPOS("C6_XOPER")]

		If SF4->(DbSeek(  xFilial("SF4") + aCols[n_nx][GDFieldPOS("C6_TES")] ))
			If SF4->F4_META != "001"
				aCols[n_nx][GDFieldPOS("C6_COMIS1")] := 0
				M->C5_COMIS1 = 0
			Else
				If SC6->(FIELDPOS("C6_XITEMC")) > 0
					If ALLTRIM(aCols[n_nx][GDFieldPOS("C6_XITEMC")]) = "TAIFF"
						M->C5_COMIS1 = 0 // Força o preendhimento da Comissão Geral do Pedido com o valor 0 - Edson Hornberger - 05/12/2013
					EndIf
				EndIf
				If M->C5_CLASPED = "A"
					nComiss := 0
				Else
					nComiss := U_RetComis(M->C5_CLIENT, M->C5_LOJACLI, M->C5_VEND1, aCols[n_nx][GDFieldPOS("C6_PRODUTO")])
				EndIf
				If !(cEmpAnt+cFilAnt == '0101') .And.  ( nComiss <> aCols[n_nx][GDFieldPOS("C6_COMIS1")] )  .And. !GDdeleted(n_nx) // Na Daihatsu nao valido a comissao se esta preenchida.
					aCols[n_nx][GDFieldPOS("C6_COMIS1")] := nComiss
				EndIf
				If SC5->(FIELDPOS("C5_XITEMC")) > 0
					If Alltrim(M->C5_XITEMC) = "PROART"
						aCols[n_nx][GDFieldPOS("C6_COMIS1")] := 0
					ElseIf Alltrim(M->C5_XITEMC) = "TAIFF"
						M->C5_COMIS1 = 0
					EndIf
				EndIf
			EndIf

		EndIf
		/*
		Projeto...: Melhoria
		Data......: 03/08/2015
		Observação: Impedir classe de pedido "bonificação" com tipo de operação V3 e "venda" com tipo de operação V5 
		Autor.....: CT
		*/
		If .NOT. l410Auto
			lMessC6Oper := .F.
			DO CASE
			CASE M->C5_CLASPED = 'X' .and. Alltrim(aCols[n_nx][GDFieldPOS("C6_XOPER")]) = 'V3'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'X' .and. Alltrim(aCols[n_nx][GDFieldPOS("C6_OPER")]) = 'V3'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'V' .and. Alltrim(aCols[n_nx][GDFieldPOS("C6_XOPER")]) = 'V5'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'V' .and. Alltrim(aCols[n_nx][GDFieldPOS("C6_OPER")]) = 'V5'
				lMessC6Oper := .T.
			EndCASE
			If lMessC6Oper
				MsgStop("Tipo de operação "+Alltrim(aCols[n_nx][GDFieldPOS("C6_XOPER")])+" é incoerente com a classe de pedido "+M->C5_CLASPED)
				_lRet := .F.
			EndIf
		EndIf

		lArm21Ok := Iif( .NOT. lArm21Ok , Alltrim(aCols[n_nx][GDFieldPOS("C6_LOCAL")]) = "21" , lArm21Ok )

		/*
		Atualiza campos atualizados pela liberação automatica ESTMI001 
		*/
		If .NOT. INCLUI
			If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC6->(FIELDPOS("C6__BLINF")) > 0
				aCols[n_nx][GDFieldPOS("C6__BLINF")] := "MT410TOK-" + Upper(Rtrim(CUSERNAME))+" "+DTOC(dDatabase)+" "+Time()
				aCols[n_nx][GDFieldPOS("C6_LOCALIZ")] := ""
				If EMPTY(cC6RESERVA) .AND. .NOT. EMPTY(aCols[n_nx][GDFieldPOS("C6_RESERVA")])
					cC6RESERVA := "L"
				EndIf
			EndIf
		EndIf


	Next n_nx

	If !IsInCallStack('U_GERAPDCD') //Se usar funcao que copia nao valida a gravacao do pedido de vendas

		If Inclui .Or. Altera

			/***********************************************************/
			/* Quando a Classificação do pedido for Bonificação, o	  */
			/* campo Tipo de Bonificação é obrigatório                 */
			/* Incluído por Gilberto Ribeiro (08/07/2011)				  */
			/***********************************************************/
			//Só faz a validação quando o Verifica se o programa que chamou esta function é o programa de importação de pedidos
			If IsInCallStack("U_FATMI001")
				_lRet := .T.
			EndIf

			//----------------------------------------------------------------------
			// ID: DESENV001
			// Descrição: Adequação da regra de validação de cliente SUFRAMA
			// Autor: Carlos Torres                                 Data: 16/04/2012
			//----------------------------------------------------------------------
			If At( Alltrim(FunName()) , "IMPPEDxFATMI001" ) = 0  //FunName() <> "IMPPED"
				//----------------------------------------------------------------------------------------
				// Descrição: Atualiza origem da empresa/filial para pedidos NOVOS
				// Autor: Carlos Torres                                                   Data: 05/02/2013
				//----------------------------------------------------------------------------------------

				If Empty(M->C5_EMPDES)
					M->C5_EMPDES := cEmpAnt
					M->C5_FILDES := cFilAnt
				EndIf

				//----------------------------------------------------------------------------------------
				// Descrição: Atualiza Status liberação de credito para pedidos de NF complementar ou livre de debito
				// Autor: Carlos Torres                                                   Data: 01/02/2013
				//----------------------------------------------------------------------------------------
				/*
				|---------------------------------------------------------------------------------
				| Incluido Liberacao para Pedidos de Transferencia entre Filiais - Edson - 17/02/2014
				|	Projeto Filial 02 - Daihatsu
				|---------------------------------------------------------------------------------
				*/
				If M->C5_TIPO != "N" .or. At( Alltrim(M->C5_CONDPAG) , cCondLvr ) != 0  .Or. IsInCallStack("MATA310")
					M->C5_XLIBCR := 'L'
				EndIf

				/***********************************************************/
				/* VALIDA O CLIENTE é SUFRAMADO, E SE FOR, VALIDA SE A DATA*/
				/*	DE VALIDADE DO SUFRAMA NãO ESTá VENCIDA					  */
				/* INCLUíDO POR GILBERTO RIBEIRO (25/11/2011)  			     */
				/***********************************************************/
				If !(M->C5_TIPO$"D/B")

					SA1->(dbSetOrder(1))
					SA1->(dbSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI))
					_Suframa := SA1->A1_SUFRAMA
					_CalcSuf := SA1->A1_CALCSUF
					_VldSufr := DTOS(SA1->A1_VLDSUFR)

					If (!Empty(_Suframa) .AND. _CalcSuf = "S" .AND. _VldSufr < _dAtual)
						Msgstop("O cliente possui Data de Validade do Suframa vencida.")
						Return .F.
					EndIf

					//----------------------------------------------------------------------------------------
					// Descrição: Atualiza informações do Pedido para utilizar no crossDocking
					// Autor: Gilberto Ribeiro Junior                                         Data: 21/05/2015
					//----------------------------------------------------------------------------------------
				/*
				|---------------------------------------------------------------------------------
				|	Inserido controle para que esta alteracao nao seja realizada para Pedidos de 
				|	Transferencia entre Filiais do Grupo.
				|	Edson Hornberger - 10/06/2015
				|---------------------------------------------------------------------------------
				*/
					cQuery := "SELECT COUNT(*) AS NREG FROM SM0_COMPANY WHERE M0_CGC = '"  + SA1->A1_CGC + "'"

					IF SELECT("TMP") > 0
						DBSELECTAREA("TMP")
						DBCLOSEAREA()
					ENDIF

					TCQUERY CQUERY NEW ALIAS "TMP"
					DBSELECTAREA("TMP")

					/*
					|---------------------------------------------------------------------------------
					|	Se retornar algum registro referente ao Cadastro de Emrpresas nao realiza a 
					|	alteracao.
					|---------------------------------------------------------------------------------
					*/
					IF TMP->NREG > 0
						_lCont := .F.
					ENDIF

					IF LPOSNUMOS
						C6XNUMOS := ""
						For _nX := 1 to Len( aCols )
							IF EMPTY(C6XNUMOS)
								C6XNUMOS := aCols[_nX][GDFieldPOS("C6_XNUMOS")]							
							ENDIF
						Next
					ENDIF

					DBSELECTAREA("TMP")
					DBCLOSEAREA()

					If (cEmpAnt = "03" .AND. Empty(AllTrim(M->C5_NUMOLD))) .AND. _lCont
						If CFILANT = "01" .AND. M->C5_CLASPED = "A"
							M->C5_NUMOLD := M->C5_NUM + "MA"
							M->C5_FILDES := "01"
							IF .NOT. EMPTY(C6XNUMOS)
								M->C5_NUMOLD := M->C5_NUM + "MOS"
								M->C5_FILDES := "01"
							ENDIF

						ElseIf CFILANT = "01"
							M->C5_NUMOLD := M->C5_NUM + "MSP"
							M->C5_FILDES := "01"
						ElseIf CFILANT = "02"
							M->C5_NUMOLD := M->C5_NUM + "MMG"
						EndIf
					EndIf

					//----------------------------------------------------------------------------------------
					// Descrição: Atualiza liberação de credito para operação INTERCOMPANY
					// Autor: Carlos Torres                                                   Data: 04/02/2013
					//----------------------------------------------------------------------------------------
					If SA1->A1_INTER = "S"
						M->C5_XLIBCR := 'L'
					EndIf

				EndIf
				/***********************************************************/
			EndIf
			//---------------------------[ Termino DESENV001 ]----------------------

			//----------------------------------------------------------
			// Preenche o Periodo de Calculo para Pesquisa na CFD (FCI)
			// Edson Hornberger - 08/10/2013
			//----------------------------------------------------------

			/*
			|=================================================================================
			| COMENTARIO PARA FCI
			|---------------------------------------------------------------------------------
			| O tratamento que será dado para a empresa DAIHATSU é que a origem da FCI somente   
			| se dá na DAIHATSU, mesmo que exista FCI na ACTION não pode ser adotado esse  
			| conteúdo.
			|---------------------------------------------------------------------------------
			| Solicitante: CHAYANA (Fiscal)
			| Data.......: 15/02/2016 
			| Autor......: CT
			|=================================================================================
			*/

			cPerCalFCI := SubStr(DtoS(dDataBase),5,2) + SubStr(DtoS(dDataBase),1,4)

			For _nX := 1 to Len( aCols )

				If SC6->(FIELDPOS("C6_FCICOD")) > 0 .AND. (.NOT. IsInCallStack("A410COPIA")) // IsInCallStack implementado em 20/05/2014 CT
				/*
				|=================================================================================
				|   COMENTARIO
				|---------------------------------------------------------------------------------
				|	Tratamento que esta sendo realizado para preenchimento da FCI no Pedido de  
				|	Venda, pois no padrao nao esta atendendo.
				|	Edson Hornberger - 08/10/2013.
				|=================================================================================
				*/

					If Select("FCI") > 0

						FCI->(dbCloseArea())

					EndIf
					If Select("FCIC") > 0

						FCIC->(dbCloseArea())

					EndIf

					cQuery := "FROM" 																									+ cPl
					cQuery += "CFD040 CFD" 																							+ cPl
					cQuery += "WHERE" 																								+ cPl
					cQuery += "CFD.CFD_COD = '" + aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})] + "' AND" 	+ cPl
					cQuery += "CFD.CFD_PERCAL = '" + cPerCalFCI + "' AND" 														+ cPl
					cQuery += "CFD.D_E_L_E_T_ = ''"

					cQryTmp := "SELECT COUNT(*) AS CNT" + cPl + cQuery

					TcQuery cQryTmp New Alias "FCIC"
					dbSelectArea("FCIC")

					/*
					|=================================================================================
					|   COMENTARIO
					|---------------------------------------------------------------------------------
					|	Foi incluido verificacao da Empresa 04 para que nao seja levado o codigo 
					|	FCI para produtos TAIFF Secadores, pois estava pegando FCI da Empresa 
					|	Daihatsu.
					|
					|	Edson Hornberger - 02/03/2015 (Email da Patricia Lima)
					|=================================================================================
					*/
					/*
					|=================================================================================
					|   COMENTARIO
					|---------------------------------------------------------------------------------
					|	Foi alterado o Fonte para que seja verificado somente a Empresa 04 Action
					|	pois a empresa Daihatsu não esta mais fabricando produtos.
					|	
					|	Edson Hornberger - 30/04/2015 (Email da Patricia e Henrique)
					|=================================================================================
					*/
					If cEmpAnt = '01'
						/* Regra 15/02/2016 */
						If Select("FCI") > 0
							FCI->(dbCloseArea())
						EndIf
						If Select("FCIC") > 0
							FCIC->(dbCloseArea())
						EndIf

						cQuery := "FROM" 																									+ cPl
						cQuery += "CFD010 CFD" 																							+ cPl
						cQuery += "WHERE" 																								+ cPl
						cQuery += "CFD.CFD_COD = '" + aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})] + "' AND" 	+ cPl
						cQuery += "CFD.CFD_PERCAL = '" + cPerCalFCI + "' AND" 														+ cPl
						cQuery += "CFD.D_E_L_E_T_ = ''"

						cQryTmp := "SELECT COUNT(*) AS CNT" + cPl + cQuery

						TcQuery cQryTmp New Alias "FCIC"
						dbSelectArea("FCIC")
						If FCIC->CNT > 0
							FCIC->(dbCloseArea())

							cQryTmp := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + cPl + cQuery

							TcQuery cQryTmp New Alias "FCI"
							dbSelectArea("FCI")

							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= FCI->CFD_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)
							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FCICOD"})] 	:= UPPER(FCI->CFD_FCICOD)

							FCI->(dbCloseArea())
						EndIf

					ElseIf FCIC->CNT > 0

					/*
							.AND. cEmpAnt <> '04'
					
						FCIC->(dbCloseArea())
					
						cQryTmp := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + cPl + cQuery
					
						TcQuery cQryTmp New Alias "FCI"
						dbSelectArea("FCI")
					
						aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= FCI->CFD_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)
						aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FCICOD"})] 	:= UPPER(FCI->CFD_FCICOD)
					
						FCI->(dbCloseArea())
					
					Else
					*/

						FCIC->(dbCloseArea())

						cQuery := StrTran(cQuery,"CFD010","CFD040")

						cQryTmp := "SELECT COUNT(*) AS CNT" + cPl + cQuery

						TcQuery cQryTmp New Alias "FCIC"
						dbSelectArea("FCIC")

						If FCIC->CNT > 0

							FCIC->(dbCloseArea())

							cQryTmp := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + cPl + cQuery

							TcQuery cQryTmp New Alias "FCI"
							dbSelectArea("FCI")

							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= FCI->CFD_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)
							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FCICOD"})] 	:= UPPER(FCI->CFD_FCICOD)

							FCI->(dbCloseArea())

						Else

							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1") + aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})])

							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= SB1->B1_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)

						EndIf
					Else
						/*
						Deacordo com e-mail Patricia Lima caso não encontre na ACTION buscar a FCI na DAIHATSU
						Autor: CT em 23/06/2015
						*/
						FCIC->(dbCloseArea())

						cQuery := StrTran(cQuery,"CFD040","CFD010")

						cQryTmp := "SELECT COUNT(*) AS CNT" + cPl + cQuery

						TcQuery cQryTmp New Alias "FCIC"
						dbSelectArea("FCIC")

						If FCIC->CNT > 0

							FCIC->(dbCloseArea())

							cQryTmp := "SELECT CFD.CFD_FCICOD, CFD.CFD_ORIGEM" + cPl + cQuery

							TcQuery cQryTmp New Alias "FCI"
							dbSelectArea("FCI")

							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= FCI->CFD_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)
							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_FCICOD"})] 	:= UPPER(FCI->CFD_FCICOD)

							FCI->(dbCloseArea())
						Else

							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1") + aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})])

							aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] 	:= SB1->B1_ORIGEM + SubStr(aCols[_nX][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})],2,2)

						EndIf

					EndIf

				/*
				|=================================================================================
				| Fim do Preenchimento do codigo FCI
				|=================================================================================
				*/
				EndIf

				If aTail( aCols[_nX] )
					Loop
				EndIf

				N := _nX

				_lRet := U_M410LIOK()

				If !_lRet
					Exit
				EndIf

			Next nX
		Endif

		N := _nBkpN

		If INCLUI .and. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"")
			_lRet:= .F.

			If IsInCallStack("U_FATMI001") .OR. ( Type("l410Auto") <> "U" .And. l410Auto )
				_lRet := .T.
			EndIf
			/*
			Comentarios: Não há restrição para inclusão de pedidos nas empresas que se enquadram no 
							parametro MV__SEPA01, isto foi desenvolvido por causa do modelo de "PRE-PEDIDO" 
							atualmente (2013) utiliza-se a rotina de orçamento. Desta forma o parametro 
							_lRet será sempre .T.
			Data.......: 06/09/2013
			Autor......: CT			
			*/
			_lRet := .T.

			/*
			If !_lRet
			Aviso("MT410TOK","Inclusão manual de pedidos de venda não permitida. Favor utilizar a rotina de pré-pedidos.",{"Ok"})
			Endif
			*/
		Elseif (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") .and. !IsInCallStack("U_FATMI001") .and. cEmpAnt <> '03'
			If U_PRTC0003()
				_lRet := .T.
			Else
				Aviso("MT410TOK","Favor revisar e reavaliar o pedido.",{"Ok"})
			EndIf
		EndIf

		//-----------------------------------------------------------------------------------------------
		//Adicionado por VETI -  Daniel Ruffino em 17/10/2012
		//Bloquear Pedidos onde foi alterado a condicao de pagamento OU o valor total do pedido por alterado para MAIOR
		If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"")
			If ALTERA .AND. _lRet
				BeginSql alias 'SC6PEDIDO'
					SELECT SUM(C6_VALOR) as C6_TOTAL
					FROM %table:SC6% SC6
					WHERE SC6.C6_FILIAL = %xfilial:SC6%
					AND SC6.C6_NUM = %Exp:M->C5_NUM%
					AND SC6.%NotDel%
				EndSql
				aEval(aCols,{|x| _nTotSC6+= x[12]})

				aCondAtu := strtokarr(AllTrim(Posicione("SE4", 1, xFilial("SE4")+M->C5_CONDPAG, "E4_COND")),",")
				aCondAnt := strtokarr(AllTrim(Posicione("SE4", 1, xFilial("SE4")+SC5->C5_CONDPAG, "E4_COND")),",")

				If aCondAnt[Len(aCondAnt)] < aCondAtu[Len(aCondAtu)] .AND. SC6PEDIDO->C6_TOTAL < _nTotSC6 .AND. M->C5_CONDPAG <> "N33" .AND. M->C5_CLASPED <> "A"
					M->C5_XLIBCR := "A"
					M->C5_YSTSEP := " "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava Log na tabela SZC³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_cAlias		:= "SC5"
					_cChave		:= xFilial("SC5")+M->C5_NUM
					_dDtIni		:= Date()
					_cHrIni		:= Time()
					_cDtFim		:= CTOD("")
					_cHrFim		:= ""
					_cCodUser	:= __CUSERID
					_cEstacao	:= ""
					_cOperac	:= UPPER("10 - Valor total do Pedido foi alterado para Valor superior ao anterior. Condição de Pagamento alterada. Pedido deverá ser submetido a nova Avaliação de Crédito.")
					_cFuncao	:= "U_MT410TOK"
					U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					_lRecLimCred := .T.
					_nTotSC6Ant := SC6PEDIDO->C6_TOTAL

					MsgAlert("Valor total do Pedido foi alterado para Valor superior ao anterior. Condição de Pagamento alterada. Pedido deverá ser submetido a nova Avaliação de Crédito.")
				ElseIf aCondAnt[Len(aCondAnt)] < aCondAtu[Len(aCondAtu)] .AND.  M->C5_CONDPAG <> "N33" .AND. M->C5_CLASPED <> "A"
					M->C5_XLIBCR := "A"
					M->C5_YSTSEP := " "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava Log na tabela SZC³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_cAlias		:= "SC5"
					_cChave		:= xFilial("SC5")+M->C5_NUM
					_dDtIni		:= Date()
					_cHrIni		:= Time()
					_cDtFim		:= CTOD("")
					_cHrFim		:= ""
					_cCodUser	:= __CUSERID
					_cEstacao	:= ""
					_cOperac	:= UPPER("10 - Condição de Pagamento alterada. Pedido deverá ser submetido a nova Avaliação de Crédito.")
					_cFuncao	:= "U_MT410TOK"
					U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					_lRecLimCred := .T.

					MsgAlert("Condição de Pagamento alterada. Pedido deverá ser submetido a nova Avaliação de Crédito.")
				ElseIf SC6PEDIDO->C6_TOTAL < _nTotSC6 .AND.  M->C5_CONDPAG <> "N33" .AND. M->C5_CLASPED <> "A"
					M->C5_XLIBCR := "A"
					M->C5_YSTSEP := " "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava Log na tabela SZC³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_cAlias		:= "SC5"
					_cChave		:= xFilial("SC5")+M->C5_NUM
					_dDtIni		:= Date()
					_cHrIni		:= Time()
					_cDtFim		:= CTOD("")
					_cHrFim		:= ""
					_cCodUser	:= __CUSERID
					_cEstacao	:= ""
					_cOperac	:= UPPER("10 - Valor total do Pedido foi alterado para Valor superior ao anterior. Pedido deverá ser submetido a nova Avaliação de Crédito.")
					_cFuncao	:= "U_MT410TOK"
					U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					_lRecLimCred := .T.
					_nTotSC6Ant := SC6PEDIDO->C6_TOTAL

					MsgAlert("Valor total do Pedido foi alterado para Valor superior ao anterior. Pedido deverá ser submetido a nova Avaliação de Crédito.")
				ElseIf Alltrim(M->C5_CONDPAG) == Alltrim(SC5->C5_CONDPAG) .AND. SC6PEDIDO->C6_TOTAL >= _nTotSC6
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Grava Log na tabela SZC³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					_cAlias		:= "SC5"
					_cChave		:= xFilial("SC5")+M->C5_NUM
					_dDtIni		:= Date()
					_cHrIni		:= Time()
					_cDtFim		:= CTOD("")
					_cHrFim		:= ""
					_cCodUser	:= __CUSERID
					_cEstacao	:= ""
					_cOperac	:= "09 - PEDIDO DE VENDA ALTERADO SEM MUDANCA DE VALOR OU CONDICAO DE PAGAMENTO."
					_cFuncao	:= "U_MT410TOK"
					U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					_lRecLimCred := .F.
				EndIf
				SC6PEDIDO->(DbCloseArea())
			ElseIf INCLUI .AND. _lRet .and. M->C5_CONDPAG == "N33" .and. M->C5_CLASPED == "A" // Se for inclusão manual de pedido de Remessa em Garantia (Assistencia Técnica) já nasce liberado
				M->C5_XLIBCR := "L"
				M->C5_YSTSEP := " "
			EndIf
		EndIf

		// Exclusão ou Alteração (que tenha alterado valor do pedido ou condição de pagamento, chama a rotina para refazer o Limite disponível de crédito)
		If XNOPC == 1 // Operação de Exclusão
			If _lPedidoCrm .and. M->C5_INTER != "S"
				MsgAlert("Este pedido teve origem no sistema CRM, portanto, o mesmo não pode ser excluído. Caso necessário, utilize a função para Eliminar Resíduo.")
				Return .F.
			EndIf
			//alert("Exclusão - FINMI003")
			U_FINMI003("X", SC5->C5_NUM, nil, nil, nil)
		ElseIf XNOPC == 4 .and. _lRecLimCred // Operação de Alteração e que teve alteração no valor do pedido
			//alert("Entrou no ElseIf - FINMI003")
			U_FINMI003("A", SC5->C5_NUM, nil, nil, _nTotSC6Ant)
		EndIf
		/******************************************************************************************************/

	EndIf

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Realiza a validação das quantidades dos itens do Pedido de Venda para que 
	|	nao haja nenhuma alteração
	|=================================================================================
	*/
	If CEMPANT + CFILANT = "0301" .AND. ALTERA .AND. !LINTERC .AND. M->C5_CLASPED != "A"
		IF ADETPED[1][1]

			IF ADETPED[1][2] != NQTDPED

				MSGSTOP("Houve alteração na quantidade dos itens deste Pedido " + cPl + "sendo que já exite cópia do mesmo na Empresa Taiff Extrema CD!" + cPl + "Alteração não permitida" ,"ATENÇÃO")
				_LRET := .F.

			ENDIF

		ENDIF
	ElseIf CEMPANT + CFILANT = "0302" .AND. M->C5_FILDES='01' .AND. ALTERA .AND. .NOT. EMPTY(M->C5_NUMOC)
		IF ADETPED[1][1]

			IF ADETPED[1][2] != NQTDPED .OR. ADETPED[1][3] != CC6XOPER .OR.  ADETPED[1][4] != M->C5_CLIENTE .OR. ADETPED[1][5] != M->C5_LOJACLI .OR. ADETPED[1][6] != M->C5_CLASPED .OR. ADETPED[1][7] != M->C5_XITEMC .OR. ADETPED[1][8] != M->C5_TABELA .OR. ADETPED[1][9] != M->C5_CONDPAG

				MSGSTOP("Houveram alterações chaves no Pedido " + cPl + "que devem ser realizadas na empresa Taiff Matriz CD!" + cPl + "Alteração não permitida" ,"ATENÇÃO")
				_LRET := .F.

			ENDIF

		ENDIF
	EndIf

	lMudaArm := .F.
	If (CEMPANT + CFILANT) = "0301" .AND. IsInCallStack("MATA410") .AND. lArm21Ok
		If ( Type("l410Auto") <> "U" .And. l410Auto )
			// não questionar nada
		Else
			If INCLUI .AND. XNOPC = 3 .AND. Empty(M->C5_STCROSS) .AND. M->C5_CLASPED $ "V|X"
				If MsgYesNo("O atendimento deste pedido será através de copia de pedido no CD, " + ENTER + " isto é, via CROSS DOCKING?",FunName())
					M->C5_STCROSS := "AGCOPY"
				Else
					lMudaArm := .T.
				EndIf
			ElseIf ALTERA .AND. XNOPC = 4 .AND. Empty(M->C5_STCROSS) .AND. M->C5_CLASPED $ "V|X"
				If MsgYesNo("O atendimento deste pedido será através de copia de pedido no CD, " + ENTER + " isto é, via CROSS DOCKING?",FunName())
					M->C5_STCROSS := "AGCOPY"
				Else
					M->C5_STCROSS := ""
					lMudaArm := .T.
				EndIf
			ELSEIf INCLUI .AND. XNOPC = 3 .AND. Empty(M->C5_NUMOLD) .AND. M->C5_CLASPED $ "A"
				IF LPOSNUMOS
					For n_nx:= 1 to Len(aCols)
						IF EMPTY(aCols[n_nx][GDFieldPOS("C6_XNUMOS")]) .AND. aCols[n_nx][GDFieldPOS("C6_OPER")]="34"
							aCols[n_nx][GDFieldPOS("C6_XNUMOS")] := M->C5_NUM + ACOLS[N,NPOSITEM] + "MOS"
							CC6OPER := "34"
						ENDIF
					Next n_nx
				ENDIF
				IF CC6OPER = "34"
					M->C5_NUMOLD := M->C5_NUM + "MOS"
				ELSE
					M->C5_NUMOLD := M->C5_NUM + "MA"
				ENDIF
				
			ELSEIf ALTERA .AND. XNOPC = 4 .AND. AT("OS",M->C5_NUMOLD)!=0 .AND. M->C5_CLASPED $ "A"
				IF LPOSNUMOS
					For n_nx:= 1 to Len(aCols)
						IF EMPTY(aCols[n_nx][GDFieldPOS("C6_XNUMOS")]) .AND. aCols[n_nx][GDFieldPOS("C6_OPER")]="34"
							aCols[n_nx][GDFieldPOS("C6_XNUMOS")] := M->C5_NUM + ACOLS[N,NPOSITEM] + "MOS"
						ENDIF
					Next n_nx
				ENDIF
			EndIf
			If lMudaArm
				For n_nx:= 1 to Len(aCols)

					aCols[n_nx][GDFieldPOS("C6_LOCAL")] := "62"

				Next n_nx
			EndIf
		EndIf
	EndIf


	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Realiza a validacao do Status do Pedido tambem para o Pedido de Vendas no 
	|	CD.
	|=================================================================================
	*/
	IF (CEMPANT + CFILANT) = '0301' .AND. _LRET .AND. !LINTERC .AND. M->C5_CLASPED != "A"
		If ( Type("l410Auto") <> "U" .And. .NOT. l410Auto ) .OR. Type("l410Auto") = "U"
			CQUERY := "SELECT " 										+ ENTER
			CQUERY += "ISNULL(SC5.R_E_C_N_O_,0) AS QTDREG "		+ ENTER
			CQUERY += "FROM " + RETSQLNAME("SC5") + " SC5 "		+ ENTER
			CQUERY += "WHERE " 										+ ENTER
			CQUERY += "C5_FILIAL = '02' AND " 						+ ENTER
			CQUERY += "C5_NUMORI = '" + M->C5_NUM + "' AND "		+ ENTER
			CQUERY += "C5_CLIORI = '" + M->C5_CLIENT + "' AND " 	+ ENTER
			CQUERY += "C5_LOJORI = '" + M->C5_LOJAENT + "' AND "	+ ENTER
			CQUERY += "D_E_L_E_T_ = '' "

			//MEMOWRITE("MT410TOK_RECNO_SC5_FILIAL_02_I.SQL",CQUERY)
			IF SELECT("TMP") > 0

				DBSELECTAREA("TMP")
				DBCLOSEAREA()

			ENDIF

			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			NREGS := TMP->QTDREG

			IF NREGS > 0
				NRECNOANT := SC5->(RECNO())
				SC5->(DbGoto(NREGS))
				IF .NOT. (SC5->(Eof()) .AND. SC5->(Bof()))
					If SC5->(RECLOCK("SC5",.F.))
						SC5->C5_XLIBCR 	:= M->C5_XLIBCR
						SC5->C5_CONDPAG 	:= M->C5_CONDPAG
						SC5->(MsUnlock())
					EndIf
				Endif
				SC5->(DbGoto(NRECNOANT))
			ENDIF
		ENDIF
	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Caso haja alteração de Bloqueio Comercial realiza no CD também.
	|---------------------------------------------------------------------------------
	*/
	IF  (CEMPANT + CFILANT) = '0301' .AND. _LRET .AND. !LINTERC .AND. M->C5_LIBCOM != SC5->C5_LIBCOM .AND. M->C5_CLASPED != "A" .AND. ALTERA
		If ADETPED[1][2] = NQTDPED

			CQUERY := "SELECT " 										+ ENTER
			CQUERY += "ISNULL(SC5.R_E_C_N_O_,0) AS QTDREG "		+ ENTER
			CQUERY += "FROM " + RETSQLNAME("SC5") + " SC5 "		+ ENTER
			CQUERY += "WHERE " 										+ ENTER
			CQUERY += "C5_FILIAL = '02' AND " 						+ ENTER
			CQUERY += "C5_NUMOLD = '" + M->C5_NUMOLD + "' AND "	+ ENTER
			CQUERY += "D_E_L_E_T_ = '' "

			//MEMOWRITE("MT410TOK_RECNO_SC5_FILIAL_02_II.SQL",CQUERY)
			IF SELECT("TMP") > 0

				DBSELECTAREA("TMP")
				DBCLOSEAREA()

			ENDIF

			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			NREGS := TMP->QTDREG

			IF NREGS > 0
				NRECNOANT := SC5->(RECNO())
				SC5->(DbGoto(NREGS))
				If SC5->(RECLOCK("SC5",.F.))
					SC5->C5_LIBCOM 	:= M->C5_LIBCOM
					SC5->(MsUnlock())
				EndIf
				SC5->(DbGoto(NRECNOANT))
			EndIf
		EndIf
	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Realiza a alteração do campo de Pedido Vinculado do processo de Bonificação
	|---------------------------------------------------------------------------------
	*/
	IF  (CEMPANT + CFILANT) = '0301' .AND. _LRET .AND. !LINTERC .AND. M->C5_CLASPED = "X"

		CQUERY := "SELECT " 										+ ENTER
		CQUERY += "ISNULL(SC5.R_E_C_N_O_,0) AS QTDREG "		+ ENTER
		CQUERY += "FROM " + RETSQLNAME("SC5") + " SC5 "		+ ENTER
		CQUERY += "WHERE " 										+ ENTER
		CQUERY += "C5_FILIAL = '02' AND " 						+ ENTER
		CQUERY += "C5_NUMOLD = '" + M->C5_NUMOLD + "' AND "	+ ENTER
		CQUERY += "D_E_L_E_T_ = '' "

		//MEMOWRITE("MT410TOK_RECNO_SC5_FILIAL_02_III.SQL",CQUERY)
		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		NREGS := TMP->QTDREG

		IF NREGS > 0
			NRECNOANT := SC5->(RECNO())
			SC5->(DbGoto(NREGS))
			If SC5->(RECLOCK("SC5",.F.))
				SC5->C5_X_PVBON 	:= M->C5_X_PVBON
				SC5->(MsUnlock())
			EndIf
			SC5->(DbGoto(NRECNOANT))
		EndIf

	ENDIF

	If SC5->(FIELDPOS("C5_NUMOLD")) > 0

	/* Comentado por Gilberto - 24/10/2016
		If Altera .And. cEmpAnt+cFilAnt == '0101' .And.;  // Nao permite alterar pedidos do Portal na Daihatsu
			!Empty(M->C5_NUMOLD)
			_lRet := .F.
			Help(,,'HELP',,"Não é permitido alterar pedidos do Portal na Daihatsu",1,0)
		EndIf
	*/

		//Validacao do vinculo Pedido Normal x Pedido Bonificado
		lCrosPedOk := .T.
		If (CEMPANT + CFILANT = "0301" .AND. ALTERA) .OR. (CEMPANT + CFILANT = "0302" .AND. M->C5_FILDES='01' .AND. ALTERA)
			If ADETPED[1][2] = NQTDPED
				lCrosPedOk := .T.
			Else
				lCrosPedOk := .F.
			EndIf
		EndIf
		If ExistBlock("RM410BNF") .and. _lRet .and. Alltrim(FunName()) = "MATA410" .AND. M->C5_LIBCOM = SC5->C5_LIBCOM .AND. lCrosPedOk
			If SM0->M0_CODIGO + SM0->M0_CODFIL $ GetMV("MV_X_BNFIL") // Alterado por CT para empresas onde o parametro não existe
				_lRet := U_RM410BNF(PARAMIXB[1])
			EndIf
		EndIf
	EndIf

	If (CEMPANT + CFILANT) = "0302" .AND. M->C5_FILDES='01' .AND. ALTERA .AND. _LRET .AND. .NOT. EMPTY(SC5->C5_NUMOC)

		CQUERY := "SELECT " 										+ ENTER
		CQUERY += "ISNULL(SC5.R_E_C_N_O_,0) AS QTDREG "		+ ENTER
		CQUERY += "FROM " + RETSQLNAME("SC5") + " SC5 "		+ ENTER
		CQUERY += "WHERE " 										+ ENTER
		CQUERY += "C5_FILIAL = '" + M->C5_FILDES+ "' AND " 	+ ENTER
		CQUERY += "C5_NUM = '" + M->C5_NUMORI + "' AND" 		+ ENTER
		CQUERY += "C5_CLIENT = '" + M->C5_CLIORI + "' AND " 	+ ENTER
		CQUERY += "C5_LOJAENT = '" + M->C5_LOJORI + "' AND" 	+ ENTER
		CQUERY += "D_E_L_E_T_ = '' "

		//MEMOWRITE("MT410TOK_RECNO_SC5_FILIAL_02_IV.SQL",CQUERY)
		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		NREGS := TMP->QTDREG

		IF NREGS > 0
			NRECNOANT := SC5->(RECNO())
			SC5->(DbGoto(NREGS))
			If SC5->(RECLOCK("SC5",.F.))
				SC5->C5_STCROSS := "ABERTO"
				SC5->(MsUnlock())
			EndIf
			SC5->(DbGoto(NRECNOANT))
		EndIf

	EndIf

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Limpa variavel global e elimina a mesma.
	|
	|=================================================================================
	*/
	If ((CEMPANT + CFILANT = "0301") .OR. (CEMPANT + CFILANT = "0302" .AND. M->C5_FILDES='01' .AND. ALTERA) ) .AND. _LRET
		CLEARGLBVALUE("aGlbMT410")
	EndIf

	// caso pedido colocado seja de imposto e da marca PROART atualizar o campo C5_YTSEP = "G" para não impactar nas cores/legendas
	If SC5->(FIELDPOS("C5_XITEMC")) > 0
		If M->C5_TIPO = "I" .AND. ALLTRIM(M->C5_XITEMC) = "PROART"
			M->C5_YSTSEP := "G"
		EndIf
	EndIf

	/*
	Limpa campos atualizados pela liberação automatica ESTMI001 
	*/
	If .NOT. INCLUI
		If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->(FIELDPOS("C5__DTLIBF")) > 0
			If .NOT. EMPTY(M->C5__LIBM)
				_cAlias		:= "SC5"
				_cChave		:= xFilial("SC5")+M->C5_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= "21 - PEDIDO ALTERADO, STATUS " + M->C5__BLOQF + " DA LIBERACAO (" + M->C5__LIBM + ") ANTES DA ALTERACAO: DT. FATUR: " + DTOC(M->C5__DTLIBF) + " AS " + M->C5_HLIB5 + " POR " + M->C5_ULIB5 + " HISTORICO: " + M->C5_HIST5
				_cFuncao	:= "U_MT410TOK"
				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
			EndIf
			M->C5__DTLIBF	:= CTOD("  /  /  ")
			M->C5__BLOQF 	:= ""
			M->C5_ULIB5	:= ""
			M->C5_DLIB5	:= CTOD("  /  /  ")
			M->C5_HLIB5	:= ""
			M->C5_PLIB5	:= ""
			M->C5__LIBM	:= ""
			M->C5__RESERV	:= cC6RESERVA
			M->C5_HIST5	:= ""
			M->C5__PERBNF	:= 0
		EndIf
	EndIf

	RESTAREA(AAREASC5)
	RESTAREA(AAREASC6)
	RESTAREA(AAREA)

Return _lRet

/*
=================================================================================
=================================================================================
||   Arquivo:	MT410TOK.prw
=================================================================================
||   Funcao: 	EXCPEDCPY
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao utilizada para realizar a Exclusao do Pedido de Venda.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	30/09/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION EXCPEDCPY(CPEDIDO)

	LOCAL AAREA		:= GETAREA()
	LOCAL AAREASC5	:= SC5->(GETAREA())
	LOCAL AAREASC6	:= SC6->(GETAREA())
	LOCAL CQUERY 	:= ""
	LOCAL ACABSC5	:= {}
	LOCAL AITESC6	:= {}
	LOCAL ADETSC6	:= {}
	LOCAL CNEWPED	:= ""
	PRIVATE LMSERROAUTO	:= .F.

	CQUERY := "SELECT" 								+ ENTER
	CQUERY += "	C5_NUM" 							+ ENTER
	CQUERY += "FROM" 								+ ENTER
	CQUERY += "	" + RETSQLNAME("SC5") 				+ ENTER
	CQUERY += "WHERE" 								+ ENTER
	CQUERY += "	C5_FILIAL = '02' AND" 				+ ENTER
	CQUERY += "	C5_NUMORI = '" + CPEDIDO + "' AND" 	+ ENTER
	CQUERY += "	D_E_L_E_T_ = ''"

	IF SELECT("TMP") > 0

		DBSELECTAREA("TMP")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()
	CNEWPED := TMP->C5_NUM

	RPCCLEARENV()
	RPCSETTYPE(3)
	RPCSETENV("03", "02")
	SLEEP(1500)

	DBSELECTAREA("SC5")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC5") + CNEWPED)

	DBSELECTAREA("SX3")
	DBSETORDER(1)
	DBSEEK("SC5")
	WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = "SC5"

		If AT( ALLTRIM(SX3->X3_CAMPO) , 'C5_NUM|C5_TIPO|C5_CLIENTE|C5_LOJACLI|C5_CLIENT|C5_LOJAENT' ) != 0

			AADD(ACABSC5,{SX3->X3_CAMPO,&(SX3->X3_ARQUIVO + "->" + ALLTRIM(SX3->X3_CAMPO)),NIL})

		ENDIF

		SX3->(DBSKIP())

	ENDDO

	DBSELECTAREA("SC6")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC6") + CNEWPED)

	WHILE SC6->(!EOF()) .AND. SC6->C6_NUM = CNEWPED

		DBSELECTAREA("SX3")
		DBSETORDER(1)
		DBSEEK("SC6")
		WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = "SC6"
			If AT( ALLTRIM(SX3->X3_CAMPO) , 'C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_UM|C6_LOCAL|C6_DESCRI|C6_TES|C6_CLI|C6_LOJA|C6_XITEMC|C6_PRCVEN|C6_VALOR|C6_PRUNIT|C6_ENTREG|C6_PEDCLI' ) != 0

				AADD(ADETSC6,{SX3->X3_CAMPO,&(SX3->X3_ARQUIVO + "->" + ALLTRIM(SX3->X3_CAMPO)),NIL})

			ENDIF

			SX3->(DBSKIP())

		ENDDO

		AADD(AITESC6,ADETSC6)
		ADETSC6 := {}
		SC6->(DBSKIP())

	ENDDO

	LMSERROAUTO := .F.
	BEGIN TRANSACTION

		MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},ACABSC5,AITESC6,5)
		IF LMSERROAUTO

			DISARMTRANSACTION()
			MSGALERT(OEMTOANSI(	"Erro ao tentar excluir Pedido de Vendas!")  + ENTER + ;
				"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
			MOSTRAERRO()

		ENDIF

	END TRANSACTION

	RPCCLEARENV()
	RPCSETTYPE(3)
	RPCSETENV("03", "01")
	SLEEP(1500)

	RESTAREA(AAREA)
	RESTAREA(AAREASC5)
	RESTAREA(AAREASC6)

RETURN
