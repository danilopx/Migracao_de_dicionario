#INCLUDE "protheus.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*
?????????????????????????????????????????????????????????????????????????????
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±?’’’’’’’’’’?’’’’’’’’’’¿’’’’’’’?’’’’’’’’’’’’’’’’’’’’¿’’’’’’?’’’’’’’’’’’’’™±±
±±?Programa  ?M410LIOK  ?Autor  ? Fernando Salvatori ? Data ?  12/14/09   ?±±
±±√’’’’’’’’’’ˇ’’’’’’’’’’†’’’’’’’?’’’’’’’’’’’’’’’’’’’’†’’’’’’?’’’’’’’’’’’’’?±±
±±?Desc.     ? Linha Ok de validacoes do Pedido de Venda                  ?±±
±±?          ?                                                            ?±±
±±ª’’’’’’’’’’?’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
?????????????????????????????????????????????????????????????????????????????
*/
User Function M410LIOK()

	Local _aArea		:= GetArea()
	Local _lRet		:= .T.
	//Local _nValIpi	:= 0
	//Local _nPerRis	:= 0
	//Local _nPerIpi	:= 0
	//Local _lContinua	:= .T.
	Local _nPosLocal	:= Ascan(aHeader, {|x| AllTrim(x[2])=="C6_LOCAL"} ) //acha a posicao do campo de armazem(C6_LOCAL) no aCols
	Local cTES			:= ""
	Local cClasFis	:= ""
	Local cCFOP		:= ""
	Local aDadosCfo	:= {}											// Array para montagem do tratamento do CFOP
	Local xAliasSF4 	:= SF4->(GetArea())
	Local xAliasSB1 	:= SB1->(GetArea())
	Local lMessC6Oper
	Local lOkValida
	Local lTfCliOk 	:= .T.
	Local _lPedidoCrm := .T.
	LOCAL LPOSNUMOS		:= (SC6->(FIELDPOS("C6_XNUMOS")) > 0)
	LOCAL NPOSNUMOS		:= Ascan(aHeader, {|x| AllTrim(x[2])=="C6_XNUMOS"} )
	LOCAL NPOSITEM		:= Ascan(aHeader, {|x| AllTrim(x[2])=="C6_ITEM"} )
	LOCAL NPOSOPER		:= Ascan(aHeader, {|x| AllTrim(x[2])=="C6_OPER"} )

	//----------------------------------------------------------------------------------------------------------------------------
	// Variaveis: TOTVS
	//----------------------------------------------------------------------------------------------------------------------------
	//Local _lRet 	:= .T.
	Local nx1		:= 0
	Local nx		:= 0
	Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
	Local cProd
	Local cOp
	Local cPedido
	Local cUneg		:= '' 					// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
	//--------------------------------------------[ Fim variaveis TOTVS ]------------------------------------------------------

	/*
	|--------------------------------------------------------------------------------------------------------------------------
	|	AUTOR: Gilberto Ribeiro Jr
	|	DATA:  11/07/2016
	|	VALIDACAO PARA PEDIDOS DE TRANSFER NCIA: N√O PERMITIR QUE (C6_OPER) SEJA DIFERENTE DE (V6) QUANDO FOR EMPRESA = 03
	|	E FILIAL = 02, EXISTIR O C5_NUMORI E O CLIENTE FOR 001497 (TAIFF PROART) N√O … UMA OPERA«√O DE VENDA, E SIM UMA 
	|   TRANSFERENCIA (V6) SOMENTE PERMITIR UTILIZAR O (V6) NO CAMPO TIPO DE OPERA«√O.
	|--------------------------------------------------------------------------------------------------------------------------
	*/
	IF CEMPANT = "03" .AND. CFILANT = "02" .AND. !EMPTY(M->C5_NUMORI) .AND. M->C5_CLIENTE = "001497" .AND. M->C5_TIPO = "N"
		IF (ALLTRIM(BuscaCols("C6_OPER")) != "V6" .AND. ALLTRIM(BuscaCols("C6_OPER")) != "")
			MSGALERT("O Tipo de OperaÁ„o que deve ser utilizado em uma transferÍncia È o (V6)", "ATEN«√O")
			RETURN .F.
		ENDIF
	ENDIF
	/*-------------------------------------------------------------------------------------------------------------------------*/

	/*
	|---------------------------------------------------------------------------------
	|	VALIDACAO PARA PEDIDOS MANUAIS EM EXTREMA - CROSSDOCKING REMODELADO
	|	Edson Hornberger - 17/12/2015
	|---------------------------------------------------------------------------------
	*/

	IF CEMPANT + CFILANT = "0302" .AND. .NOT. l410Auto .AND. M->C5_TIPO = "N"

		/*
		|---------------------------------------------------------------------------------
		|	Validacao somente para a primeira linha
		|---------------------------------------------------------------------------------
		*/
		IF LEN(ACOLS) = 1
			/*
			|---------------------------------------------------------------------------------
			|	Cliente do Pedido n„o pode ser do Estado de SP
			|  a n„o ser que se enquadre na excess„o - Ver campo A1__FATUR 
			|---------------------------------------------------------------------------------
			*/
			lTfCliOk := .T.
			If SA1->(FIELDPOS("A1__FATUR")) > 0
				If POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1__FATUR") = "S"
					lTfCliOk := .F.
				EndIf
			EndIf
			IF POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_EST") = "SP" .AND. !U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_CGC")) .AND. !U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC"))
				If lTfCliOk
					MSGALERT("Pedidos para Clientes do Estado de SP devem ser incluÌdos na Filial correspondente!","ATEN«√O")
					RETURN .F.
				EndIf
			ENDIF

		ENDIF

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	Altera o Armazem conforme a Marca do produto
	|---------------------------------------------------------------------------------
	*/
	IF CEMPANT = "03" .AND. .NOT. l410Auto .AND. M->C5_TIPO = "N" .AND. !U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_CGC")) .AND. !U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC"))

		If CEMPANT = "03" .AND. CFILANT = "01"
			IF UPPER(ALLTRIM(M->C5_XITEMC)) $ "TAIFF|PROART" .AND. M->C5_CLASPED $ "V|X" .AND. !GdDeleted(N)
				If EMPTY(M->C5_STCROSS) .AND. ACOLS[N,_nPosLocal] = "21"
					If MsgYesNo("O atendimento deste pedido ser· atravÈs de copia de pedido no CD, " + ENTER + " isto È, via CROSS DOCKING?",FunName())
						M->C5_STCROSS := "AGCOPY"
						ACOLS[N,_nPosLocal] := "21"
					Else
						M->C5_STCROSS := ""
						ACOLS[N,_nPosLocal] := "62" // Segundo Douglas (Controladoria) o armazem 62 È o mais indicado para operaÁıes que n„o s„o CROSS DOCKING
					EndIf
				ElseIf .NOT. EMPTY(M->C5_STCROSS) .AND. ACOLS[N,_nPosLocal] != "21"
					ACOLS[N,_nPosLocal] := "21"
				EndIF
			ENDIF
			IF UPPER(ALLTRIM(M->C5_XITEMC)) $ "TAIFF|PROART" .AND. M->C5_CLASPED $ "A" .AND. !GdDeleted(N)
				IF LPOSNUMOS
					IF EMPTY(M->C5_NUMOLD)
						If ACOLS[N,NPOSOPER]="34"
							M->C5_NUMOLD := M->C5_NUM + "MOS"
							IF EMPTY(ACOLS[N,NPOSNUMOS])
								ACOLS[N,NPOSNUMOS] := M->C5_NUM + ACOLS[N,NPOSITEM] + "MOS"
							ENDIF
						ELSE
							M->C5_NUMOLD := M->C5_NUM + "MA"
						ENDIF
					ELSE
						IF ACOLS[N,NPOSOPER]="34" .AND. EMPTY(ACOLS[N,NPOSNUMOS])
							ACOLS[N,NPOSNUMOS] := M->C5_NUM + ACOLS[N,NPOSITEM] + "MOS"
						ENDIF
					ENDIF
				ENDIF
			ENDIF
		Else
			IF UPPER(ALLTRIM(M->C5_XITEMC)) $ "TAIFF|PROART" .AND. M->C5_CLASPED $ ("V|X") .AND. !GdDeleted(N)
				ACOLS[N,_nPosLocal] := "21"
			EndIf
		EndIf
	ENDIF
	IF CEMPANT = "03" .AND. CFILANT = "02" .AND. .NOT. l410Auto .AND. M->C5_TIPO = "N" .AND. U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_CGC"))
		IF UPPER(ALLTRIM(M->C5_XITEMC)) $ "TAIFF|PROART" .AND. M->C5_CLASPED $ ("V|X") .AND. !GdDeleted(N) .AND. ALLTRIM(M->C5_NUMOC) = "CROSS"
			ACOLS[N,_nPosLocal] := "21"
		EndIf
	ENDIF

	/******************************************************************************************************
		Autor: Gilberto Ribeiro Junior 
		Data: 11/06/2020
		Coment·rio: Valida se o pedido È originado no sistema CRM, se for, n„o permite que exclua itens.
	*******************************************************************************************************/
	If !Empty(SC5->C5_NUMOLD)
		For nx := 1 to Len(AllTrim(SC5->C5_NUMOLD))
			If !IsDigit(SubStr(AllTrim(SC5->C5_NUMOLD), nx, 1))
				_lPedidoCrm := .F. // Pedido CRM n„o tem letra
				Exit
			EndIf
		Next nx
	EndIf

	/*******************************************************************************************************
	Comentado em 20/08/2020 - 15:40
	Solicitado no chamado: 11290
	DescriÁ„o: Voltar no Protheus ajuste de itensno pedido de venda para casos de a vista.ESTAMOS CIENTES QUE N√O DEVEMOS EXCLUIR ITENS DO PEDIDO.
	Solitante: Maria Luisa
	********************************************************************************************************/
	// If _lPedidoCrm
	// 	For nx:= 1 to Len(aCols)
	// 		If GdDeleted(nx)
	// 			MsgAlert("Este pedido teve origem no sistema CRM, portanto, o mesmo n„o pode ser excluÌdo. Caso necess·rio, utilize a funÁ„o para Eliminar ResÌduo.")
	// 			Return .F.
	// 		EndIf
	// 	Next nx
	// EndIf
	/*******************************************************************************************************/

	//----------------------------------------------------------------------------------------------------------------------------
	// Ponto de ValidaÁ„o: TOTVS
	// DescriÁ„o: Validar unidade de negocio no produto
	// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
	//----------------------------------------------------------------------------------------------------------------------------
	// Implementado em 20/07/2020 por C. Torres a condiÁao .T. para validaÁ„o da unidade de negocio na empresa 03 - TAIFFPROART
	//
	If lUniNeg .OR. (.T. .AND. CEMPANT="03")
		IF UPPER(ALLTRIM(M->C5_XITEMC)) $ "TAIFF|PROART" .AND. M->C5_CLASPED $ ("V|X")

			For nx:= 1 to Len(aCols)

				cUneg := ALLTRIM(M->C5_XITEMC)

				If !GdDeleted(nx)
					For nx1 := 1 to Len(aCols)

						If Empty(aCols[nx1][GdFieldPos('C6_XITEMC')]) .And. _lRet .And. !GdDeleted(nx1)
							_lRet := .F.
							Help(nil,1,'Unidade de Negocios',nil,'ObrigatÛrio preencher unidade de negocios',3,0)
							Exit

						ElseIf cUneg <> ALLTRIM(aCols[nx1][GdFieldPos('C6_XITEMC')]) .And. _lRet .And. !GdDeleted(nx1)
							_lRet := .F.
							Help(nil,1,'Unidade de Negocios',nil,'N„o È permitido usar unidade de negocios diferentes',3,0)
							Exit
						EndIf

					Next nx1
				EndIf

				If !_lRet
					Exit
				EndiF

			Next nx

		ENDIF
	EndIf
	//--------------------------------------------[ Fim CustomizaÁ„o TOTVS ]------------------------------------------------------

	If _lRet
		//VALIDA SE O CAMPO DE OP NOS CASOS DE BENEFICIAMENTO DA ACTION ESTAO PREENCHIDOS, E SE A QUANTIDADE ESTA CORRETA
		If cEmpAnt == "04" .and. cFilAnt='02' .And. M->C5_TIPO == "B" .And. !aCols[n][Len(aCols[n])] .And. BuscaCols("C6_LOCAL") == "31"
			//VALIDA CAMPO OP
			If Empty(BuscaCols("C6__OPBNFC"))
				MsgStop("N„o È permitido um pedido de Beneficiamento sem uma OP relacionada","M410LIOK")
				_lRet := .F.
			Else
				cOp := BuscaCols("C6__OPBNFC")
				cProd := BuscaCols("C6_PRODUTO")
				cPedido := M->C5_NUM
				//VALIDA QUANTIDADE
				dbSelectArea("SD4")
				dbSetOrder(2)
				If dbSeek(xFilial()+cOp+cProd)
					If SD4->D4_QTDEORI < U_CalcBnfc(cOp,cProd,cPedido,"V")+BuscaCols("C6_QTDVEN")
						MsgStop("A quantidade digitada È maior que a gerada da OP","M410LIOK")
						_lRet := .F.
					EndIf
				EndIf
			EndIf
		EndIf
		//-----------------------------------------------------------------------------------------------
		//Adicionado por Thiago Comelli em 16/10/2012
		//Executa somente na empresa e filial selecionados
		If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT01",.F.,"")
			//Valida se o local dos itens incluidos sao iguais ao do primeiro item valido(nao deletado)
			If GDFieldGet("C6_LOCAL") <> aCols[1,_nPosLocal] .AND. !GdDeleted(N)//aCols[n,Len(aCols[n])] <> .T.
				MsgAlert("SÛ pode haver um armazÈm no pedido !")
				_lRet = .F.
				RestArea(_aArea)
				Return _lRet
			EndIf

		EndIf
		//-----------------------------------------------------------------------------------------------

		//?????????????????????????????????????????????????????????????¯
		//?Valida se a quantidade do item » m?ltiplo do campo B1_QTMULT
		//IncluÃdo por Gilberto - (28/10/2011)
		//ø?????????????????????????????????????????????????????????????
		If cEmpAnt == "03" .and. cFilAnt='01' .AND. M->C5_CLASPED != "A"
			If !U_MULTIPLO(GDFieldGet("C6_PRODUTO"), GDFieldGet("C6_QTDVEN"))
				_lRet = .F.
				RestArea(_aArea)
				Return _lRet
			EndIf
		EndIf

		If cEmpAnt == "01" .And. FunName() != "MFAT010" .And. !(GDFieldGet("C6_TES") $ GetNewPar("MV_FORTEST",""))
			If .NOT. (M->C5_TIPO $ "D/B" .And. ! GetNewPar("MV_IPIDEV",.F.))
				nXX_vlprunit:=GDFieldGet("C6_PRUNIT")
				nXX_vlprunit:=Round(nXX_vlprunit,2)
				If GDFieldGet("C6_PRUNIT") > 0
					GDFieldPut("C6_PRUNIT"  , nXX_vlprunit)
				EndIf
			EndIf
		EndIf
		/*
		Funcionalidade de reduÁ„o de IPI comentada em 29/01/2014, ver e-mail abaixo:
		--------------------------------------------------------------------------------------------------
		De: Manoel Firmino Alves Ferreira [mailto:manoel.ferreira@taiffproart.com.br]
		Enviada em: terÁa-feira, 28 de janeiro de 2014 16:52
		Para: 'Carlos Torres'; 'Rose Lima'; 'Jorge Elias Tavares Da Silva'; 'Henrique Ventura Regis'
		Cc: patricia.lima@taiffproart.com.br
		Assunto: RES: PreÁo de entrada em Extrema para formaÁ„o de custo
		
		Equipe de TI
		Boa Tarde!
		
		Entendemos que essa antiga funcionalidade deva ser desabilitada.
		Os custos de transferÍncias entre filiais n„o podem sofrer quaisquer tipos de interferÍncias.
		
		Att
		
		Manoel Firmino Alves Ferreira
		Taiff ProArt  |  Controladoria
		--------------------------------------------------------------------------------------------------
		
		*/

		/*
		--------------------------------[ inicio da reduÁ„o de IPI ]---------------------------------------
		//?????????????????????????????????????????????????????????????¯
		//?Caso seja empresa daihatsu, retiro o valor do ipi do produto?
		//ø?????????????????????????????????????????????????????????????
		If M->C5_EMPDES='01' .and. cEmpAnt == "01" .And. FunName() != "MFAT010" .And. !(GDFieldGet("C6_TES") $ GetNewPar("MV_FORTEST",""))
			If M->C5_TIPO $ "D/B" .And. ! GetNewPar("MV_IPIDEV",.F.)
				_lContinua := .F.
			EndIf
			
			If _lContinua
				SA1->( dbSetOrder(1) )
				SA1->( dbSeek( xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI ) )
				
				SA7->( dbSetOrder(1) )
				If SA7->( dbSeek( xFilial("SA7")+M->C5_CLIENTE+M->C5_LOJACLI+GDFieldGet("C6_PRODUTO") ) )
					_nPerRis := SA7->A7_PERRIS
				EndIf
				
				//????????????????????????????????????????????????????????????¯
				//?Caso exista percentual, recalcular o valor unitario do item?
				//?e referencia-lo no item do pedido de compras               ?
				//ø????????????????????????????????????????????????????????????
				If _nPerRis <= 0
					_nPerRis := SA1->A1_PERRIS
				EndIf
				
				SB1->( dbSetOrder(1) )
				SB1->( dbSeek( xFilial("SB1") + GDFieldGet("C6_PRODUTO") ) )
				
				SF4->( dbSetOrder(1) )
				SF4->( dbSeek( xFilial("SF4") + GDFieldGet("C6_TES") ) )
				
				If SB1->B1_IPI > 0 .And. SF4->F4_IPI == "S" .And. GDFieldGet("C6_REAJIPI") <> "S"
					_nPerRis := 100 - _nPerRis
					_nPerIpi := (1+((SB1->B1_IPI/100) * _nPerRis) / 100)
					_nValIpi := GDFieldGet("C6_PRCVEN") / _nPerIpi
					
					_nValIpi := Round(_nValIpi,2)
					
					// Alteracoes Feitas pelo Robson - Arredondamento em 11/02/10
					GDFieldPut("C6_PRCVEN"  , _nValIpi)
					GDFieldPut("C6_VALOR"   , Round((GDFieldGet("C6_PRCVEN")*GDFieldGet("C6_QTDVEN")),2))
					
					If GDFieldGet("C6_PRUNIT") > 0
						GDFieldPut("C6_PRUNIT"  , _nValIpi)
					EndIf
					GDFieldPut("C6_REAJIPI" , "S")
					a410Recalc()
				EndIf
			EndIf
		EndIf
		--------------------------------[ termino da reduÁ„o de IPI ]---------------------------------------
		*/

		//???????????????????????????????¯
		//?Realiza o recalculo das regras?
		//ø???????????????????????????????
		/*
		|---------------------------------------------------------------------------------
		|	Comentado pois a Funcao abaixo foi retirada do Sistema
		|
		|	Edson Hornberger - 09/02/2015
		|---------------------------------------------------------------------------------
		*/
		/*
		If M->C5_EMPDES=cEmpAnt
			U_GFAT001S()
		EndIf
		*/
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Sera alimentado o campo C6_OPER caso Pedido seja copia para Barueri referente
		| Projeto Fase II.
		|
		|   Edson Hornberger - 22/01/2014
		|=================================================================================
		*/
		/*
		Projeto...: ExceÁ„o Fiscal/TES inteligente
		Data......: 12/11/2014
		ObservaÁ„o: Para dar garantia ‡ operaÁ„o de copia de pedido para BARUERI que a TES do pedido È a correta
		foi implementada a funÁ„o padr„o da TOTVS: MaTesInt
		Autor.....: CT
		*/
		/*
		Projeto...: ExceÁ„o Fiscal/TES inteligente
		Data......: 21/11/2014
		ObservaÁ„o: Para dar garantia ‡ operaÁ„o de copia de pedido para BARUERI que o CFOP e
		a ClassificaÁ„o Tribut·ria do pedido s„o os corretos foram implementadas as funÁıes
		padr„o da TOTVS: CodSitTri e MaFisCfo
		Autor.....: CT
		*/
		If cEmpAnt = "03" .And. cFilAnt $ "01|03|02" .and. l410Auto

			lOkValida := .T.

			/*
			If cEmpAnt+cFilAnt $ "0302" .AND. M->C5_FILDES='01'
				lOkValida := .F.
			EndIf
			*/
			If !EMPTY(ALLTRIM(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})])) .AND. lOkValida

				If .NOT. (SB1->B1_COD == aCols[N][GDFieldPOS("C6_PRODUTO")])
					SB1->(dbSetOrder(1))
					SB1->(MsSeek(xFilial('SB1') + aCols[N][GDFieldPOS("C6_PRODUTO")]  ))
				EndIf

				aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})] := aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})]

				GdFieldPut("C6_OPER",aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})] ,N)

				/*
				ObservaÁ„o
				… executada a funÁ„o de busca do TES quando cria o pedido de SP em MG a partir do tipo de operaÁ„o V6 - Transferencia entre filiais  
				*/
				cTES := MaTesInt(2,aCols[N][GDFieldPOS("C6_XOPER")],M->C5_CLIENTE,M->C5_LOJACLI,"C",aCols[N][GDFieldPOS("C6_PRODUTO")])

				aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})] := cTES

				If .NOT. (SF4->F4_CODIGO == cTES)
					SF4->(dbSetOrder(1))
					SF4->(MsSeek(xFilial('SF4')+cTES ))
				EndIf

				cClasFis := CodSitTri()

				aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})] := cClasFis

				Aadd(aDadosCfo,{"OPERNF"		, "S"				})
				Aadd(aDadosCfo,{"TPCLIFOR"	, M->C5_TIPOCLI	})
				Aadd(aDadosCfo,{"UFDEST"		, Iif(M->C5_TIPO$"DB", SA2->A2_EST,SA1->A1_EST)		})
				Aadd(aDadosCfo,{"INSCR"		, Iif(M->C5_TIPO$"DB", SA2->A2_INSCR,SA1->A1_INSCR)	})
				Aadd(aDadosCfo,{"CONTR"		, SA1->A1_CONTRIB	})

				cCFOP := MaFisCfo(,SF4->F4_CF,aDadosCfo)

				If Empty(cCFOP)
					cCFOP	:= SF4->F4_CF
				EndIf

				aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})] := cCFOP

			EndIf

		EndIf
		/*
		Projeto...: ExceÁ„o Fiscal/TES inteligente
		Data......: 08/06/2015
		ObservaÁ„o: Para a operaÁ„o de inclus„o manual de pedido em Extrema forÁaremos a atualizaÁ„o do tipo de operaÁ„o
		Autor.....: CT
		*/
		If cEmpAnt = "03" .And. cFilAnt $ "02" .and. .NOT. l410Auto
			If !Empty( aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})] )
				aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})] := aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})]
				GdFieldPut("C6_XOPER",aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})] ,N)
			EndIf
		EndIf

		/*
		Projeto...: Melhoria
		Data......: 03/08/2015
		ObservaÁ„o: Impedir classe de pedido "bonificaÁ„o" com tipo de operaÁ„o V3 e "venda" com tipo de operaÁ„o V5
		Autor.....: CT
		*/
		If .NOT. l410Auto
			lMessC6Oper := .F.
			DO CASE
			CASE M->C5_CLASPED = 'X' .and. Alltrim(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})]) = 'V3'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'X' .and. Alltrim(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})]) = 'V3'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'V' .and. Alltrim(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})]) = 'V5'
				lMessC6Oper := .T.
			CASE M->C5_CLASPED = 'V' .and. Alltrim(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})]) = 'V5'
				lMessC6Oper := .T.
			EndCASE
			If lMessC6Oper
				MsgStop("Tipo de operaÁ„o "+Alltrim(aCols[N][aScan(aHeader,{|x| AllTrim(x[2])=="C6_XOPER"})])+" È incoerente com a classe de pedido "+M->C5_CLASPED)
				_lRet := .F.
			EndIf
		EndIf
	EndIf

	RestArea(_aArea)
	RestArea(xAliasSF4)
	RestArea(xAliasSB1)

Return _lRet
/*
?????????????????????????????????????????????????????????????????????????????
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±?’’’’’’’’’’?’’’’’’’’’’¿’’’’’’’?’’’’’’’’’’’’’’’’’’’’¿’’’’’’?’’’’’’’’’’’’’™±±
±±?Programa  ? VALIDA MULTIPLO ?Autor  ? Gilberto 	  ? Data ? 25/10/2011  ?±±
±±√’’’’’’’’’’ˇ’’’’’’’’’’†’’’’’’’?’’’’’’’’’’’’’’’’’’’’†’’’’’’?’’’’’’’’’’’’’?±±
±±?DESC.     ? VALIDA O CAMPO C6_QTDVEN » M?LTIPLO DO CAMPO B1_QTMULT     ?±±
±±?CHAMADA.  ? CHAMADA ATRAV»S DA VALIDA¡?O DO USU∑RIO     					  ?±±
±±ª’’’’’’’’’’?’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’’∫±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
?????????????????????????????????????????????????????????????????????????????
*/

User Function MULTIPLO(cProduto, QtdVen)

	Local _aArea := GetArea()
	Local Ret := .T.
	Local QtdMultipla := 0

	//Se quantidade de vendas for zero, n?o precisa validar se » m?ltiplo.
	If(QtdVen <= 0) //Se a quantidade for menor que zero, n?o valida nada, sai da fun¡?o retornando True
		Return (Ret)
	EndIf

	dbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	//If SB1->(DbSeek(xFilial("SB1") +  "462020037"))
	If SB1->(DbSeek(xFilial("SB1") +  cProduto))
		QtdMultipla := IIf(SB1->B1_QTMULT = 0 .OR. SB1->B1_ITEMCC = "TAIFF", 1, SB1->B1_QTMULT) //Multiplo
		If (QtdVen % QtdMultipla <> 0) .AND. Alltrim(SB1->B1_ITEMCC) != "CORP"
			Alert("A quantidade para este produto dever ser m˙ltiplo de " + AllTrim(Str(QtdMultipla)) + ".")
			Ret := .F.
		EndIf
	EndIf

	RestArea(_aArea)

Return (Ret)

