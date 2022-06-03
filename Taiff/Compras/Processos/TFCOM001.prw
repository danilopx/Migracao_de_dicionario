#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE ENTER Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    TFCOM001   � Autor � Fabricio E. da Costa  � Data � 09/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua todas as manuten��es referente ao contrato vendor e  ���
���          �seus componentes, titulos de origem e parcelas.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AFIN002                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � GAP  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Gilberto    �08/08/13�  �Ajustando a rotina para eliminar res�duos     ���
���            				 corretamente											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFCOM001()
	Local aParamBox		:= {}
	Local aRet				:= {}
	Local dtDe  := CTOD("  /  /    ")  //Criado por Gilberto
	Local dtAte := CTOD("  /  /    ")  //Criado por Gilberto

	Private cCadastro := "Gera Pedidos"
	Private cString := ""
	Private _cIdFornecedor	:= ""  

	/**********************************************/
	//Criado por Edson (08/02/2013) 
	Private _cIdForLoja	:= ""

	/**********************************************/
	//Criado por Gilberto 
	Private _cLocalDe		   := ""
	Private _cLocalAte	   := ""
	Private _cProdutoDe     := ""
	Private _cProdutoAte    := ""
	Private _dtLimiteComDe  := ""
	Private _dtLimiteComAte := ""
	/**********************************************/

	Aadd(aParamBox,{1,"Fornecedor",Space(TamSX3("A2_COD")[1])	,PesqPict("SA2","A2_COD")    ,"","SA2A"	,"",50,.T.})


	/**********************************************/
	//Incluido por Edson (08/02/2013)
	Aadd(aParamBox,{1,"Loja",Space(TamSX3("A2_LOJA")[1])	,PesqPict("SA2","A2_LOJA")    ,"",""	,"",20,.T.})

	/**********************************************/
	//Inclu�do por Gilberto (06/09/2011)   
	Aadd(aParamBox,{1,"Armazem De" ,Space(TamSX3("C1_LOCAL")[1]), PesqPict("SC1","C1_LOCAL"),"" ,""	   , "", 20, .F.}) 
	Aadd(aParamBox,{1,"Armazem Ate",Space(TamSX3("C1_LOCAL")[1]), PesqPict("SC1","C1_LOCAL"),"" ,""	   , "", 20, .F.}) 

	Aadd(aParamBox,{1,"Produto De"   ,SPACE(9),PesqPict("SB1","B1_COD")    ,"" ,"SB1"	, "", 50, .F.})
	Aadd(aParamBox,{1,"Produto Ate"  ,SPACE(9),PesqPict("SB1","B1_COD")    ,"" ,"SB1"	, "", 50, .F.})   

	Aadd(aParamBox,{1,"Dt.Limite De" ,dtDe    ,PesqPict("SC1","C1_DTVALID"),"" ,""	   , "", 50, .F.}) 
	Aadd(aParamBox,{1,"Dt.Limite Ate",dtAte   ,PesqPict("SC1","C1_DTVALID"),"" ,""	   , "", 50, .F.}) 
	/**********************************************/

	If ParamBox(aParamBox,"Informe Parametro",@aRet)

		/*	
		//Teste Gilberto
		MsgAlert(aRet[1]) //Fornecedor
		MsgAlert(aRet[2]) //Local De
		MsgAlert(aRet[3]) //Local Ate	
		MsgAlert(aRet[4]) //Produto de
		MsgAlert(aRet[5]) //Produto ate
		MsgAlert(aRet[6]) //Data de
		MsgAlert(aRet[7]) //Data ate
		//Fim Teste Gilberto
		*/

		_cLocalDe	 := aRet[3]
		_cLocalAte	 := aRet[4]
		_cProdDe     := aRet[5]
		_cProdAte    := aRet[6]   
		_dtLimDe  	 := aRet[7]
		_dtLimAte    := aRet[8]  

		If !empty( aRet[1] ) 
			_cIdFornecedor := aRet[1]
			_cIdForLoja := aRet[2]
			SA2->(DbSetOrder(1))
			If SA2->(DbSeek( xFilial("SA2")+_cIdFornecedor+_cIdForLoja ))
				U_COM_BROWSE()
			Else
				MsgAlert("C�digo de fornecedor n�o cadastrado!","Inconsist�ncia")
			EndIf
		EndIf

	Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    TFCOM001   � Autor � Fabricio E. da Costa  � Data � 09/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua todas as manuten��es referente ao contrato vendor e  ���
���          �seus componentes, titulos de origem e parcelas.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AFIN002                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � GAP  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Gilberto    �08/08/13�  �Ajustando a rotina para eliminar res�duos     ���
���            				 corretamente											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COM_BROWSE()
	Local cTitulo    := ""
	Local nGDOpc     := GD_UPDATE	
	Local aTela      := {}
	Local aObjects   := {}
	Local aPanTotal  := {}
	Local aCampoSC1S := {}
	// Local nPosCampo  := 0
	// Local nPosChk01  := 0
	// Local nPosLeg01  := 0
	// Local nPosTpCpo  := 0			
	Private nOpcE      := 0
	Private oDlg, oFolder1, oGDSC1

	cTitulo := "Gera��o de pedidos de compra"

	aTela := MsAdvSize(.T.)  // Pega as coordenadas maximas da tela
	aTela := { aTela[1]+4, aTela[2]+13, aTela[5], aTela[6]-5}  // contem X1,Y1 e X2,Y2 descontando as margens para nao colocar nas bordas

	aAdd(aObjects, {"V", 000} )
	aAdd(aObjects, {"V", 100} )
	aPanTotal := DivideTela(aTela, aObjects)

	oDlg                := tDialog():New()
	oDlg:cName          := "oDlg"
	oDlg:cCaption       := cTitulo
	oDlg:nLeft          := aTela[1]
	oDlg:nTop           := aTela[2] 	
	oDlg:nWidth         := aTela[3] - aTela[1]
	oDlg:nHeight        := aTela[4] - aTela[2]
	oDlg:nClrPane       := 16777215
	oDlg:nStyle         := -2134376320
	oDlg:bInit          := {|| EnchoiceBar(oDlg, {|| nOpcE := 1, Processa({||GeraPed(), "", "Gerando pedidos..."}), oDlg:End()}, {|| nOpcE := 0, oDlg:End()}) }
	oDlg:lCentered      := .F.

	oFolder1 := TFolder():New (0, 0, , , oDlg)
	oFolder1:nTop     := aPanTotal[2,2]
	oFolder1:nLeft    := aPanTotal[2,1]
	oFolder1:nHeight  := aPanTotal[2,4] - aPanTotal[2,2]
	oFolder1:nWidth   := aPanTotal[2,3] - aPanTotal[2,1]	
	oFolder1:AddItem("Solicita��es do Fornecedor: " + Alltrim(SA2->A2_NOME) , .T. )
	//oFolder1:AddItem("Configura��o", .T. )
	oFolder1:SetOption(1)

	aCampoSC1S := {"C1_NUM", "C1_ITEM", "C1_PRODUTO", "C1_DESCRI", "C1_QUANT", "C1_UM", "C1_EMISSAO", "C1_LOCAL", "C1_DATPRF", "C1_DTVALID","C1_ITEMCTA"}
	aHeaderSC1 := CriaHeader("SC1", aCampoSC1S,, {{" ", "_CHK01"}})
	oGDSC1 := MsNewGetDados():New(0, 0, 1, 1, nGDOpc,,,,,,,,,, oFolder1:aDialogs[1], aHeaderSC1, {})
	oGDSC1:aCols := {}
	oGDSC1:nMax  := 300
	oGDSC1:oBrowse:nTop       := 01
	oGDSC1:oBrowse:nLeft      := 01
	oGDSC1:oBrowse:nHeight    := (aPanTotal[2,4] - aPanTotal[2,2] - 25 ) - 90 
	oGDSC1:oBrowse:nWidth     := aPanTotal[2,3] - aPanTotal[2,1] - 8
	oGDSC1:oBrowse:lColDrag   := .T.
	oGDSC1:oBrowse:bLDblClick := {|| }
	oGDSC1:oBrowse:lAdjustColSize := .T.	
	oGDSC1:oBrowse:bHeaderClick := {|oBrw, nCol, aDim| HeaderClick(oBrw, nCol, aDim)}

	LoadSC1(oGDSC1)

	oDlg:Activate()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    TFCOM001   � Autor � Fabricio E. da Costa  � Data � 09/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua todas as manuten��es referente ao contrato vendor e  ���
���          �seus componentes, titulos de origem e parcelas.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AFIN002                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � GAP  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Gilberto    �08/08/13�  �Ajustando a rotina para eliminar res�duos     ���
���            				 corretamente											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function HeaderClick(oBrw, nCol, aDim)
	Local nPosChk01 := 0

	Static lExec   := .T.
	Static lSelect := .T.	

	If lExec
		nPosChk01 := GdFieldPos("_CHK01", oGDSC1:aHeader)
		If nCol == nPosChk01
			aEval(oGDSC1:aCols, {|aItem, nIndex| aItem[1] := Iif(lSelect, 'LBTIK', 'LBNO')})
			oGDSC1:oBrowse:Refresh()
			lSelect := !lSelect
		ElseIf nCol > 1
			aSort(oGDSC1:aCols, , , {|x,y| x[nCol] < y[nCol]})
			oGDSC1:oBrowse:Refresh()
		EndIf
	EndIf
	lExec := !lExec
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    TFCOM001   � Autor � Fabricio E. da Costa  � Data � 09/03/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua todas as manuten��es referente ao contrato vendor e  ���
���          �seus componentes, titulos de origem e parcelas.             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � AFIN002                                                    ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � GAP  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Gilberto    �08/08/13�  �Ajustando a rotina para eliminar res�duos     ���
���            				 corretamente								  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraPed()
	Local aCabPedCom := {}
	Local aItePedCom := {}
	Local aCabSC     := {}
	Local aIteSC     := {}
	Local cProdutos  := ""
	Local cSql       := ""
	Local cNumScs    := ""
	Local cFornece   := ""
	Local cLoja      := ""
	Local cItemCta	  := ""
	Local cProduto   := ""
	Local cItemPed   := ""
	Local cCodTab    := ""
	Local cClassPed  := ""
	// Local cNumScComp := ""
	// Local cIteScComp := ""
	Local nVlrUnit   := 0.0
	Local nReg       := 0
	Local nQtdOri    := 0
	Local nQuant     := 0  // Quantidade a pedir do produto
	Local nQtdTot    := 0  // Soma das necessidades para o produto
	Local nSaldo     := 0  // Soma do que j� foi pedido para o produto
	Local nQtdEmb    := 0  // Quantidade da embalagem padr�o
	// Local nQtdFalta  := 0
	Local nLoteMin   := 0
	Local nMultiplo  := 0
	Local nPosQuant  := 0
	Local nPosChkC1  := 0
	Local nPosCodC1  := 0
	Local nPosNumC1  := 0
	Local nPosItemC1 := 0
	Local lRet 	     := .F.
	Local xSc1Alias  := SC1->(GetArea())
	// Variaveis para Eliminar Residuos das SCs
	Local aSCompra	 := {}
	Local cSCompra	 := ""
	Local lRetLto    := .T.
	Local nContador  := 0
	Private lGatilha := .T. 	    

	Private oDlgSA5

	cCodTab := AllTrim(GetMv("MV_TABPEDC"))
	If Empty(cCodTab)
		MsgAlert("Parametro MV_TABPEDC n�o preenchido.", "Gera��o de pedidos de compra")
		Return
	EndIf
	cClassPed := AllTrim(GetMv("MV_CLPEDC"))
	If Empty(cClassPed )
		MsgAlert("Parametro MV_CLPEDC n�o preenchido.", "Gera��o de pedidos de compra")
		Return
	EndIf
	nPosCodC1  := GdFieldPos("C1_PRODUTO", oGDSC1:aHeader)
	nPosNumC1  := GdFieldPos("C1_NUM", oGDSC1:aHeader)
	nPosItemC1 := GdFieldPos("C1_ITEM", oGDSC1:aHeader)
	nPosChkC1  := GdFieldPos("_CHK01", oGDSC1:aHeader)

	cProdutos := Iif(oGDSC1:aCols[1,nPosChkC1] == "LBTIK", oGDSC1:aCols[1,nPosCodC1], "*")
	aEval(oGDSC1:aCols, {|aItem| cProdutos += Iif(aItem[nPosChkC1] == "LBTIK" .And. !aItem[nPosCodC1] $ cProdutos, "/" + aItem[nPosCodC1], "")}, 2)
	cProdutos := FormatIn(cProdutos, "/")
	//PRODUTO SEM CADASTRO NA SA5
	cQuery := " SELECT B1_COD, B1_DESC,A5_QTDEMB,A5_LOTEMIN,A5_QENTMIN
	cQuery += " FROM "+RetSqlName("SB1")+" B1 WITH(NOLOCK)" 
	cQuery += " INNER JOIN "+RetSqlName("SA5")+" A5 WITH(NOLOCK) ON A5_FILIAL  = B1_FILIAL AND  B1_COD = A5_PRODUTO"
	cQuery += " WHERE" 
	cQuery += " B1_COD IN " + cProdutos + " "
	cQuery += " AND B1.D_E_L_E_T_ = ' '
	cQuery += " AND B1_FILIAL = '"+cFilAnt+"'
	cQuery += " AND  A5_FORNECE = '"+ _cIdFornecedor +"'"
	cQuery += " AND A5_LOJA = '" + _cIdForLoja + "' AND A5.D_E_L_E_T_ <> '*' AND (A5_QTDEMB=0 OR A5_LOTEMIN=0 OR A5_QENTMIN=0)

	MemoWrite("TFCOM001SEMA5.SQL",cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

	Count To nRec			

	dbSelectArea("TRB1")
	dbGoTop()

	If nRec > 0
		While !Eof()
			MsgStop("Produto com amarra��o Produto X Fornecedor incompleta")
			nQtdEmb 	:= TRB1->A5_QTDEMB					
			nLotemin 	:= TRB1->A5_LOTEMIN
			nEntreMin	:= TRB1->A5_QENTMIN

			While nQtdEmb == 0 .Or.  nLotemin = 0 .Or. nEntreMin == 0
				@ 65,193 To 380,435 Dialog oDlgSA5 Title OemToAnsi("Produto x Fornecedor")

				@ 05,9 Say "Fornecedor: "+AllTrim(Posicione("SA2",1,xFilial("SA2")+_cIdFornecedor+_cIdForLoja,"A2_NOME")) Size 199,8 Pixel Of oDlgSA5
				@ 20,9 Say "Produto: "+AllTrim(TRB1->B1_COD)+" - "+TRB1->B1_DESC Size 199,8 Pixel Of oDlgSA5

				@ 45,9 Say OemToAnsi(TitSX3("A5_QTDEMB")[1]) Size 99,8 Pixel Of oDlgSA5
				@ 45,42 MsGet nQtdEmb Valid nQtdEmb > 0 PICTURE PesqPict("SA5","A5_QTDEMB") Size 30,10 Pixel Of oDlgSA5

				@ 60,9 Say OemToAnsi("Lote Minimo") Size 99,8 Pixel Of oDlgSA5
				@ 60,42 MsGet nLotemin Valid nLotemin > 0 PICTURE PesqPict("SA5","A5_LOTEMIN") Size 30,10 Pixel Of oDlgSA5

				@ 75,9 Say OemToAnsi("Entre minima") Size 99,8 Pixel Of oDlgSA5
				@ 75,42 MsGet nEntreMin  Valid nEntreMin > 0 PICTURE PesqPict("SA5","A5_QENTMIN") Size 30,10 Pixel Of oDlgSA5


				@ 136,95 BMPBUTTON TYPE 1 ACTION Close(oDlgSA5)
				Activate Dialog oDlgSA5 Centered

			End	

			dbSelectArea("SA5")
			dbSetOrder(1)
			If dbSeek(xFilial()+_cIdFornecedor+_cIdForLoja+TRB1->B1_COD)
				RecLock("SA5",.F.)
				A5_QTDEMB	:= nQtdEmb 
				A5_LOTEMIN	:= nLotemin 
				A5_QENTMIN	:= nEntreMin						
				SA5->(MsUnlock())
			EndIf

			dbSelectArea("TRB1")
			dbSkip()
		End
	EndIf
	TRB1->(dbCloseArea())


	/*
	//-------------------------------------------------------------------------------------------------------------------------------
	// Prepara consulta em TMPLTO da tabela SA5 com inconsistencias que impactam na rotina     		Autor: ctorres  Data: 16/08/2011
	//-------------------------------------------------------------------------------------------------------------------------------
	cSql := "SELECT "
	cSql += "  A5_PRODUTO, B1_DESC, A5_LOTEMIN, A5_QTDEMB, A5_QENTMIN "
	cSql += "FROM " 
	cSql += "  " + RetSqlName("SA5") + " SA5 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "    SA5.A5_FILIAL  = '" + xFilial("SA5") + "' AND "
	cSql += "    SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "    SA5.D_E_L_E_T_ = ' ' AND "
	cSql += "    SB1.D_E_L_E_T_ = ' ' AND "
	cSql += "    SB1.B1_COD     = SA5.A5_PRODUTO "
	cSql += "WHERE "
	cSql += "  A5_PRODUTO IN " + cProdutos + " "
	cSql += "  AND A5_FORNECE = '"+ _cIdFornecedor +"' AND "
	cSql += "  A5_LOJA = '" + _cIdForLoja + "' "	

	cSql += "GROUP BY "
	cSql += "  A5_PRODUTO, B1_DESC ,A5_LOTEMIN, A5_QTDEMB, A5_QENTMIN "	
	cSql += "HAVING "
	cSql += "   A5_QTDEMB=0 OR A5_LOTEMIN=0 OR A5_QENTMIN=0"

	TcQuery cSql New Alias "TMPLTO"

	lRetLto := TMPLTO->(Eof()) .And. TMPLTO->(Bof())


	cSql := "SELECT "
	cSql += "  A5_PRODUTO, B1_DESC, SUM(A5_PERCOMP) A5_PERCOMP "
	cSql += "FROM " 
	cSql += "  " + RetSqlName("SA5") + " SA5 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "    SA5.A5_FILIAL  = '" + xFilial("SA5") + "' AND "
	cSql += "    SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "    SA5.D_E_L_E_T_ = ' ' AND "
	cSql += "    SB1.D_E_L_E_T_ = ' ' AND "
	cSql += "    SB1.B1_COD     = SA5.A5_PRODUTO "
	cSql += "WHERE "
	cSql += "  A5_PRODUTO IN " + cProdutos + " "
	cSql += "GROUP BY "
	cSql += "  A5_PRODUTO, B1_DESC "	
	cSql += "HAVING "
	cSql += "  COUNT(1) > 1 AND SUM(A5_PERCOMP) < 100 AND SUM(A5_PERCOMP) > 0 "

	TcQuery cSql New Alias "TMPA5"

	lRet := TMPA5->(Eof()) .And. TMPA5->(Bof())

	//		|------------------------------------------------------------------|
	lRet := .T. //		| a partir de 01/06/2011 n�o ser� validado o percentual de compra  | 
	//		|------------------------------------------------------------------|
	*/
	If !lRetLto // !lRet
		//If MsgYesNo("Existem produtos sem parametriza��o para percentual de compra por fornecedor, verifique a liga��o produto/fornecedor. Deseja exibir os produtos?", "Gera��o de pedidos de compra")
		//	ListQry("TMPA5")
		//EndIf
		If MsgYesNo("Existem produtos sem parametriza��o para Qtd.Embalagem ou Entrega de compra por fornecedor, verifique a liga��o produto/fornecedor. Deseja exibir os produtos?", "Gera��o de pedidos de compra")
			ListQry("TMPLTO")
		EndIf
	Else		
		cNumScs := Iif(oGDSC1:aCols[1,nPosChkC1] == "LBTIK", oGDSC1:aCols[1,nPosNumC1] + oGDSC1:aCols[1,nPosItemC1], "*")
		aEval(oGDSC1:aCols, {|aItem| cNumScs += Iif(aItem[nPosChkC1] == "LBTIK" .And. !aItem[nPosNumC1] + aItem[nPosItemC1] $ cNumScs, "/" + aItem[nPosNumC1] + aItem[nPosItemC1], "")}, 2)
		cNumScs := FormatIn(cNumScs, "/")       


		cSql := "SELECT " + ENTER
		cSql += "  C1_PRODUTO, C1_NUM, C1_ITEM, C1_DATPRF, C1_QUANT, C1_LOCAL, C1_SOLICIT, C1_EMISSAO, C1_DTVALID, " + ENTER
		cSql += "  A5_FORNECE, A5_LOJA, A5_LOTEMIN, A5_QTDEMB, A5_QENTMIN, 0 AS A5_PERCOMP, A2_COND, A2_INTER " + ENTER
		cSql += "  ,C1_ITEMCTA " + ENTER
		cSql += " FROM " + RetSqlName("SC1") + " SC1 WITH(NOLOCK) " + ENTER
		cSql += "		INNER JOIN " + RetSqlName("SA5") + " SA5 WITH(NOLOCK) " + ENTER
		cSql += "		INNER JOIN " + RetSqlName("SA2") + " SA2 WITH(NOLOCK) ON " + ENTER
		cSql += "      SA2.D_E_L_E_T_ = ' ' AND " + ENTER
		cSql += "      SA2.A2_FILIAL  = '" + xFilial("SA2") + "' AND " + ENTER
		cSql += "      SA2.A2_COD     = SA5.A5_FORNECE AND " + ENTER
		cSql += "      SA2.A2_LOJA    = SA5.A5_LOJA 	AND " + ENTER
		cSql += "      SA2.A2_MSBLQL	= '2' ON " + ENTER
		cSql += "    SC1.D_E_L_E_T_ = ' ' AND " + ENTER
		cSql += "    SA5.D_E_L_E_T_ = ' ' AND " + ENTER
		cSql += "    SC1.C1_FILIAL  = '" + xFilial("SC1") + "' AND " + ENTER
		//cSql += "    SC1.C1_LOCAL = '31' AND " + ENTER 
		cSql += "    SA5.A5_FILIAL  = '" + xFilial("SA5") + "' AND " + ENTER
		cSql += "    SC1.C1_PRODUTO     = SA5.A5_PRODUTO " + ENTER
		cSql += "WHERE " + ENTER
		cSql += " A5_FORNECE = '" + _cIdFornecedor + "' AND " + ENTER
		cSql += " SC1.C1_NUM + SC1.C1_ITEM IN " + cNumScs + " " + ENTER
		cSql += "ORDER BY " + ENTER
		cSql += "  A5_FORNECE, A5_LOJA, C1_ITEMCTA, C1_PRODUTO, C1_DATPRF" + ENTER

		MEMOWRITE("TFCOM001.sql",cSql)

		TcQuery cSql New Alias "TMPC1"  

		Count To nReg 

		TCSetField("TMPC1", "C1_DATPRF", "D")
		TCSetField("TMPC1", "C1_EMISSAO", "D")
		TCSetField("TMPC1", "C1_DTVALID", "D")

		dbSelectArea("TMPC1")
		dbGoTop()

		If nReg > 0
			ProcRegua(nReg)
			Begin Transaction
				While !TMPC1->(Eof())
					cFornece := TMPC1->A5_FORNECE
					cLoja    := TMPC1->A5_LOJA				
					cItemCta	:= TMPC1->C1_ITEMCTA
					cNumPed  := CriaVar("C7_NUM", .T.)
					aCabPedCom := {}
					aItePedCom := {}
					aAdd(aCabPedCom, {"C7_NUM"    , cNumPed , Nil})
					aAdd(aCabPedCom, {"C7_FORNECE", cFornece, Nil})
					aAdd(aCabPedCom, {"C7_LOJA"   , _cIdForLoja   , Nil})
					aAdd(aCabPedCom, {"C7_COND"   , TMPC1->A2_COND, Nil})
					aAdd(aCabPedCom, {"C7_EMISSAO", CriaVar("C7_EMISSAO", .T.), Nil})
					aAdd(aCabPedCom, {"C7_CONTATO", CriaVar("C7_CONTATO", .T.), Nil})
					aAdd(aCabPedCom, {"C7_FILENT" , CriaVar("C7_FILENT", .T.), Nil})
					cItemPed := "0000"
					While !TMPC1->(Eof()) .And. cFornece == TMPC1->A5_FORNECE .And. _cIdForLoja == TMPC1->A5_LOJA .and. cItemCta=TMPC1->C1_ITEMCTA
						cProduto := TMPC1->C1_PRODUTO
						nQuant   := 0
						nSaldo   := 0
						nQtdTot  := 0
						nQtdOri	 := 0
						nMultiplo:= 0
						While !TMPC1->(Eof())  .And. cFornece == TMPC1->A5_FORNECE .And. _cIdForLoja == TMPC1->A5_LOJA .And. cProduto == TMPC1->C1_PRODUTO
							//cria a quantidade de acordo com o menor multiplo (Lote minimo ou qtd minima de entrega)
							IncProc()
							aCabSC    := {}
							aIteSC    := {}							
							nQtdEmb   := TMPC1->A5_QTDEMB
							nLoteMin  := TMPC1->A5_LOTEMIN
							// nQtdOri   := AbmRound(TMPC1->C1_QUANT * Iif(TMPC1->A5_PERCOMP == 0, 1, TMPC1->A5_PERCOMP / 100), 0, 5, 1)
							nQtdOri   := AbmRound(TMPC1->C1_QUANT , 0, 5, 1)
							If TMPC1->A5_QENTMIN > 0
								nMultiplo := Iif(nQtdOri - (nSaldo - nQtdTot) < nLoteMin, Min(nLoteMin, TMPC1->A5_QENTMIN), nQtdEmb)  // Pega o menor multiplo
								nMultiplo := Iif(nQtdOri - (nSaldo - nQtdTot) < TMPC1->A5_QENTMIN, nMultiplo, nQtdEmb)  // Pega o menor multiplo
								nQuant    := Int((nQtdOri - (nSaldo - nQtdTot)) / nMultiplo)  // Quantos multiplos comprar							
								nQuant    += Iif(Mod(nQtdOri - (nSaldo - nQtdTot), nMultiplo) > 0, 1, 0) // Se n�o for exato adiciona um multiplo a mais
								nQuant    := nQuant * nMultiplo
							Else
								nQuant    := TMPC1->C1_QUANT
							EndIf

							nQtdTot   += nQtdOri
							nSaldo += nQuant
							/*
							|---------------------------------------------------------------------------------
							|	Trantamento quando a variavel nquant estiver igual a zero. 
							|	Edson Hornberger - 14/03/2016
							|---------------------------------------------------------------------------------
							*/
							IF NQUANT > 0 
								cItemPed := Soma1(cItemPed, Len(cItemPed))
								nVlrUnit := MaTabPrCom(cCodTab, TMPC1->C1_PRODUTO, 1, cFornece, _cIdForLoja)
								aAdd(aItePedCom, {})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_NUM"    , cNumPed          , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_ITEM"   , cItemPed         , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_PRODUTO", TMPC1->C1_PRODUTO, Nil})								
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_CLASCON", cClassPed        , Nil})								
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_PRECO"  , nVlrUnit         , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_LOCAL"  , TMPC1->C1_LOCAL  , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_NUMSC"  , TMPC1->C1_NUM    , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_ITEMSC" , TMPC1->C1_ITEM   , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_DATPRF" , TMPC1->C1_DATPRF , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_DTENTRG", TMPC1->C1_DATPRF , Nil}) 
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_DTVALID", TMPC1->C1_DTVALID, Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_EMISSSC", TMPC1->C1_EMISSAO, Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_INTER"  , TMPC1->A2_INTER  , Nil})
								aAdd(aItePedCom[Len(aItePedCom)], {"C7_ITEMCTA", TMPC1->C1_ITEMCTA, Nil})
							ENDIF
								
							TMPC1->(DbSkip())  
							
							IF NQUANT > 0 
								nPosQuant := aScan(aItePedCom[Len(aItePedCom)], {|x| AllTrim(x[1]) == "C7_QUANT"})
	
								If nPosQuant > 0
									aItePedCom[Len(aItePedCom), nPosQuant, 2] += nQuant
								Else
									aAdd(aItePedCom[Len(aItePedCom)], {"C7_QUANT", nQuant, Nil})
								EndIf
							ENDIF 

						End

					End   

					IF LEN(aItePedCom) > 0 
						lMsHelpAuto := .T.
						lMsErroAuto := .F.
	
						MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCabPedCom, aItePedCom, 3)
	
						If lMsErroAuto
							MostraErro()
							DisarmTransaction()
							Exit
							//Final()
						Else
							MsgInfo ("Pedido de compras "+cNumPed+" gerado com Sucesso!","TFCOM001")
						EndIf
					ENDIF 

					//-------------------------------------------------------------------------------------------------------------
					// Eliminando residuo da SC, chamando a rotina ACOM002()							Autor: ctorres      Data: 15/08/2011
					//-------------------------------------------------------------------------------------------------------------
					cSCompra 	:= SubStr(cNumScs, 2, Len(cNumScs) - 2)
					aSCompra	:= StrToKArr(cSCompra, ",")

					SC1->(DbSetOrder(1))

					For nContador := 1  to Len( aSCompra )
						If SC1->(DbSeek( xFilial("SC1") + Substr(aSCompra[nContador], 2, Len(aSCompra[nContador]) -2)))
							If SC1->C1_QUANT != 0 .AND. SC1->C1_QUJE != SC1->C1_QUANT
								U_ACOM002()
							EndIf
						EndIf
					Next


				End	

			End Transaction

		EndIf

		TMPC1->(DbCloseArea())

	EndIf	

	//	TMPA5->(DbCloseArea())	
	//	TMPLTO->(DbCloseArea())	

	RestArea(xSc1Alias)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �LoadSC1   �Autor  �Fabricio E. da Costa� Data �  11/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera a query que filtra os titulos que poder�o fazer parte  ���
���          �do contrato de vendor e carrega o grid com os mesmos.       ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  oGetDados: Objeto NewGetDados que ir� receber os resgitros���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �   Nil                                                      ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LoadSC1(p1)
	Local cSql    := ""
	Local cCampos := ""

	aEval(oGDSC1:aHeader, {|aItem| cCampos += Iif("_CHK" $ aItem[2], "", aItem[2] + ", ")}, 1, Len(oGDSC1:aHeader) - 1) // gera a lista de campos da select
	cCampos += aTail(oGDSC1:aHeader)[2]
	//cCampos += ", E1_CVENDOR" // Campos exce��o que n�o v�o pro aHeader

	cSql := "SELECT "
	cSql += "  " + cCampos + " "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SC1") + " SC1 "
	cSql += "	INNER JOIN " + RetSqlName("SA5") + " SA5 ON SA5.A5_PRODUTO=SC1.C1_PRODUTO AND SA5.A5_FORNECE='"+_cIdFornecedor+"' AND SA5.D_E_L_E_T_ = ' ' "
	cSql += "WHERE "
	cSql += "  SC1.D_E_L_E_T_ = ' ' "
	cSql += "  AND C1_FILIAL  = '" + xFilial("SC1") + "' "
	cSql += "  AND C1_RESIDUO <> 'S' "
	cSql += "  AND C1_TPOP <> 'P' "
	cSql += "  AND C1_APROV = 'L' "
	cSql += "  AND C1_QUANT - C1_QUJE > 0 " 

	/*************************************************************************/ 
	//Inclu�do por Gilberto       
	If (empty(_cLocalDe) == .F. .AND. empty(_cLocalAte) == .F.)
		cSql += "  AND SC1.C1_LOCAL BETWEEN '" + _cLocalDe    + "' AND " + "'" + _cLocalAte + "' "
	EndIf

	If (empty(_cProdDe) == .F. .AND. empty(_cProdAte) == .F.)
		cSql += "  AND SC1.C1_PRODUTO BETWEEN '" + _cProdDe    + "' AND " + "'" + _cProdAte + "' "
	EndIf

	If (empty(_dtLimDe) == .F. .AND. empty(_dtLimAte) == .F.) 
		cSql += "  AND SC1.C1_DTVALID BETWEEN '" + DTOS(_dtLimDe) + "' AND " + "'" + DTOS(_dtLimAte) + "' "
	EndIf
	/*************************************************************************/

	//cSql += "  AND C1_FORNECE = '" + _cIdFornecedor + "' "
	//cSql += "  AND C1_EMISSAO BETWEEN '" + MV_ZD_CODCLI   + "' AND "
	//cSql += "  AND C1_PRODUTO BETWEEN '" + M->ZD_LOJCLI   + "' AND "
	Load_Grid(cSql, oGDSC1, {{"_CHK01","'LBNO'",.T.}})

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � ListQry  �Autor  �Fabricio E. da Costa� Data �  21/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exibe tela com os registros da query.                       ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �   cQuery...: Instru��o SQL a ser listada                   ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �   .........:                                               ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ListQry(cAlias, cTitulo)
	Local bAddDados := ""
	//Local nGDOpc    := GD_UPDATE
	Local nOpcA     := 0
	Local aCampoS   := {}
	// Local nPosChk01 := 0
	// Local aColsPar  := 0 
	Local oDlg1, oGDLst
	Local i := 0

	oDlg1                := tDialog():New()
	oDlg1:cName          := "oDlg1"
	oDlg1:cCaption       := cTitulo
	oDlg1:nLeft          := 001
	oDlg1:nTop           := 001
	oDlg1:nWidth         := 550
	oDlg1:nHeight        := 320
	oDlg1:nClrPane       := 16777215
	oDlg1:nStyle         := -2134376320
	oDlg1:bInit          := {|| EnchoiceBar(oDlg1, {|| nOpcA := 1, oDlg1:End() }, {|| nOpcA := 0, oDlg1:End()}) }
	oDlg1:lCentered      := .T.

	//aCampoS := {"B1_COD", "G1_COMP", "B1_DESC"}
	aHeader := CriaHeader(cAlias, aCampoS)
	oGDLst  := MsNewGetDados():New(0, 0, 1, 1, ,,,,,,,,,, oDlg1, aHeader, {})
	oGDLst:aCols := {}
	oGDLst:oBrowse:nTop       := 25
	oGDLst:oBrowse:nLeft      := 02
	oGDLst:oBrowse:nHeight    := 270
	oGDLst:oBrowse:nWidth     := 545
	oGDLst:oBrowse:bLDblClick := {|| } 
	oGDLst:oBrowse:lAdjustColSize := .T.

	bAddDados := "{|| AAdd(oGDLst:aCols, {"
	For i := 1 To Len(oGDLst:aHeader)
		If oGDLst:aHeader[i,8] $ "N/D" //Acerta campos numericos e datas na query
			TCSetField(cAlias, oGDLst:aHeader[i,2], oGDLst:aHeader[i,8], oGDLst:aHeader[i,4],oGDLst:aHeader[i,5])
		EndIf
		bAddDados += oGDLst:aHeader[i,2] + ", "
	Next	
	bAddDados += ".F.})}"

	bAddDados := &bAddDados.
	oGDLst:aCols := {}	
	(cAlias)->(DbEval(bAddDados))

	oDlg1:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Procedure �Load_Grid �Autor  �Fabricio E. da Costa� Data �  11/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega o grid passado em oGetDados, com os registros       ���
���          �retornados pela query passada em cSql.                      ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  cSql.....: Query que retorna os registros para o grid     ���
���          �  oGetDados: Objeto NewGetDados que ira receber os resgitros���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �   Nil                                                      ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Procedure Load_Grid(cSql, oGetDados, aCheck, aLegenda)
	Local cAction   := ""
	Local cMultSel  := ""
	Local cSingSel  := ""
	//Local cAux      := ""
	Local cCont     := ""
	Local cSx       := ""
	Local cAlias    := ""
	Local bAddDados := "{|| AAdd(oGetDados:aCols, {"
	//Local lCheck    := .F.
	Local lIsSx     := .F.
	Local nPosChk   := 0
	Local i

	Default aCheck   := {}
	Default aLegenda := {}

	lIsSx  := Left(cSql,2) == "SX"
	cSx    := Left(cSql,3)
	cAlias := SubStr(cSql, 5, 3)

	If !lIsSx
		TCQuery cSql NEW ALIAS "TMP1"
	EndIf

	For i := 1 To Len(oGetDados:aHeader)
		If "_CHK" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aCheck[nPosChk, 2] + ", "
		ElseIf "_LEG" $ oGetDados:aHeader[i,2]
			nPosChk   := aScan(aLegenda, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
			bAddDados += aLegenda[nPosChk, 2] + ", "
		Else
			If !lIsSx .And. oGetDados:aHeader[i,8] $ "N/D" // Acerta campos numericos e datas na query
				TCSetField("TMP1", oGetDados:aHeader[i,2], oGetDados:aHeader[i,8], oGetDados:aHeader[i,4],oGetDados:aHeader[i,5])
			EndIf
			bAddDados += oGetDados:aHeader[i,2] + ", "
		EndIf
	Next	
	bAddDados += ".F.})}"

	If lIsSx
		bAddDados := &bAddDados.
		oGetDados:aCols := {}	
		(cSx)->(DbEval(bAddDados, {|| X3_ARQUIVO == cAlias .And. X3Uso(X3_USADO) .And. X3_CONTEXT <> "V" }))
	Else
		bAddDados := &bAddDados.
		oGetDados:aCols := {}	
		TMP1->(DbEval(bAddDados))
		TMP1->(DbCloseArea())
	EndIf

	// Define a a��o lDblClick da getdados para marcar e desmarcar os checkboxs
	For i := 1 To Len(aCheck)
		nPosChk  := aScan(aCheck, {|aItem| AllTrim(aItem[1]) == oGetDados:aHeader[i,2]})
		cMultSel += Iif(aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
		cSingSel += Iif(!aCheck[i,3], "/" + StrZero(nPosChk,3) + "/", "")
	Next
	cMultSel := Iif(Empty(cMultSel), "*", cMultSel)
	cSingSel := Iif(Empty(cSingSel), "*", cSingSel)

	cBloco  := "{|aItem| oGetDados:aCols[nItem,oGetDados:oBrowse:nColPos] := Iif(nItem == oGetDados:nAt, Iif(aItem[oGetDados:oBrowse:nColPos] == 'LBNO', 'LBTIK', 'LBNO'), 'LBNO'), nItem++}"
	cInicio := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1)"
	cCont   := "Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', 1, Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cSingSel + "', Len(oGetDados:aCols), 0))"
	cAction := "nItem := Iif(StrZero(oGetDados:oBrowse:nColPos,3) $ '" + cMultSel + "', oGetDados:nAt, 1), aEval(oGetDados:aCols, " + cBloco + ", " + cInicio + ", " + cCont + "), oGetDados:oBrowse:Refresh()"

	If Len(aCheck) > 0 .And. Len(oGetDados:aCols) > 0 .And. At(Upper(cAction), GetCbSource(oGetDados:oBrowse:bLDblClick)) == 0
		oGetDados:oBrowse:bLDblClick := &(BAddExp(oGetDados:oBrowse:bLDblClick, cAction, 0))
	EndIf
	oGetDados:oBrowse:Refresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �CriaHeader�Autor  �Fabricio E. da Costa� Data �  12/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o aHeader que ser� utilizado pela NewGetDados.         ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  cAlias...: Alias que sera criado o aHeader                ���
���          �  aCamposS.: Array contendo os campos do Alias a serem      ���
���          �             exibidos.                                      ���
���          �  aCamposN.: Array contendo os campos do Alias a serem      ���
���          �             suprimidos do Alias.                           ���
���          �  lCheck...: Indica se o grid ter� checkbox (.T.Sim/.F.N�o).���
���          �  lRecno...: Indica se o grid ter� Recno dos registros      ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  aHeader..: aHeader contendo os campos do Alias            ���
���          �             especificado.                                  ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaHeader(cAlias, aCamposS, aCamposN, aCheck, lRecno)
	Local aHeader := {}
	Local aCampos := {}
	Local i

	Default aCamposS := {}
	Default aCamposN := {}
	Default aCheck   := {}
	Default lRecno   := .F.

	For i := 1 To Len(aCheck)
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader), 01] := AllTrim(aCheck[i,1])
		aHeader[Len(aHeader), 02] := AllTrim(aCheck[i,2])
		aHeader[Len(aHeader), 03] := "@BMP"
		aHeader[Len(aHeader), 04] := 03
		aHeader[Len(aHeader), 05] := 00
		aHeader[Len(aHeader), 08] := "C"
		aHeader[Len(aHeader), 10] := "V"
		aHeader[Len(aHeader), 14] := "V"
	Next	
	SX3->(DbSetOrder(2))
	//SX3->(DbSeek(cAlias))
	aCampos := (cAlias)->(DbStruct())
	For i := 1 To Len(aCampos)
		SX3->(DbSeek(aCampos[i,1]))
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. (aScan(aCamposS, AllTrim(SX3->X3_CAMPO)) > 0 .Or. Len(aCamposS) == 0) .And. (aScan(aCamposN, AllTrim(SX3->X3_CAMPO)) == 0 .Or. Len(aCamposN) == 0)
			Aadd(aHeader, {})
			Aadd(aHeader[Len(aHeader)], AllTrim(SX3->X3_TITULO))
			Aadd(aHeader[Len(aHeader)], AllTrim(SX3->X3_CAMPO))
			Aadd(aHeader[Len(aHeader)], SX3->X3_PICTURE)
			Aadd(aHeader[Len(aHeader)], SX3->X3_TAMANHO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_DECIMAL)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VALID)
			Aadd(aHeader[Len(aHeader)], SX3->X3_USADO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_TIPO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_F3)
			Aadd(aHeader[Len(aHeader)], SX3->X3_CONTEXT)
			Aadd(aHeader[Len(aHeader)], SX3->X3_CBOX)
			Aadd(aHeader[Len(aHeader)], SX3->X3_RELACAO)
			Aadd(aHeader[Len(aHeader)], SX3->X3_WHEN)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VISUAL)
			Aadd(aHeader[Len(aHeader)], SX3->X3_VLDUSER)
			Aadd(aHeader[Len(aHeader)], SX3->X3_PICTVAR)
			Aadd(aHeader[Len(aHeader)], X3Obrigat(SX3->X3_CAMPO))
		EndIf
		//SX3->(DbSkip())
	Next
	If lRecno
		Aadd(aHeader, Nil)
		aHeader[Len(aHeader)] := Array(17)
		aFill(aHeader[Len(aHeader)], " ")
		aHeader[Len(aHeader),01] := "RECNO"
		aHeader[Len(aHeader),02] := "R_E_C_N_O_"
		aHeader[Len(aHeader),03] := "99999999999"
		aHeader[Len(aHeader),04] := 10
		aHeader[Len(aHeader),05] := 00
		aHeader[Len(aHeader),08] := "N"
		aHeader[Len(aHeader),10] := "V"
		aHeader[Len(aHeader),14] := "V"
	EndIf

Return aClone(aHeader)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �DivideTela�Autor  �Fabricio E. da Costa� Data �  03/03/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Devide as coordenadas passadas em aDesktop(que pode ser a   ���
���          �tela ou parte dela) conforme o n�mero de itens e seus       ���
���          �e os percentuais definidos em aItens.                       ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  aDesktop.: Dimens�es da tela ou do trecho a ser dividido  ���
���          �             Ex: {X1,X2,Y1,Y2}                              ���
���          �  aItens...: Itens em que a tela ser� dividida. Conteudo:   ���
���          �             [n,1] - Eixo da divis�o V-Vertical H-Horizontal���
���          �             [n,2] - Percentual do item                     ���
���          �             Ex: {{"V",70},{"V",30} - Este aItens dividira, ���
���          �             vericalmente, as dimens�es de aDesktop em duas ���
���          �             partes, 70% e 30% respectivamente.             ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  aObjects.: Array contendo as dimens�es dos itens passados ���
���          �             em aItens.                                     ���
���          �             aObjects[1] = {X1,X2,Y1,Y2}                    ���
���          �             aObjects[2] = {X1,X2,Y1,Y2}                    ���
���          �             aObjects[n] = {X1,X2,Y1,Y2}                    ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DivideTela(aDesktop, aItens)
	Local i
	Local aObjects := {}
	Local nEixoX  := aDesktop[3] - aDesktop[1]
	Local nEixoY  := aDesktop[4] - aDesktop[2]
	Local nObjX1  := 0
	Local nObjX2  := aDesktop[1]
	Local nObjY1  := 0
	Local nObjY2  := aDesktop[2]

	For i := 1 To Len(aItens)
		nObjX1 := Iif(aItens[i,1] == "H", nObjX2, aDesktop[1])
		nObjX2 := nObjX1 + Iif(aItens[i,1] == "H", Int(nEixoX * (aItens[i,2]/100)), nEixoX)
		nObjY1 := Iif(aItens[i,1] == "V", nObjY2, aDesktop[2])
		nObjY2 := nObjY1 + Iif(aItens[i,1] == "V", Int(nEixoY * (aItens[i,2]/100)), nEixoY)
		aAdd(aObjects, {nObjX1, nObjY1, nObjX2, nObjY2} )
		nEixoX += Iif(aItens[i,1] == "H",-1,0)
		nEixoY += Iif(aItens[i,1] == "V",-1,0)
		nObjX2 += 1
		nObjY2 += 1
	Next

Return aObjects

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �BEmpty    �Autor  �Fabricio E. da Costa� Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Avalia se a lista de express�es de um code block esta vazia ���
���          �ou n�o.                                                     ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  bVal.....: Codeblock a ser avaliado.                      ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  lRet.....: Indica se a lista de express�es do codeblock   ���
���          �             esta vazia(.T.) ou n�o (.F.)                   ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BEmpty(bVal)
	Local cLista  := ""
	Local nInicio := 0
	Local nFinal  := 0

	cLista  := GetCbSource(bVal)
	If !Empty(cLista)
		nInicio := Rat("|", cLista) + 1
		nFinal  := Rat("}", cLista)
		cLista  := SubStr(cLista, nInicio, nInicio)
	EndIf

Return Empty(cLista)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �BAddExp   �Autor  �Fabricio E. da Costa� Data �  17/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona uma express�o a lista de um codeblock.             ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  bVal.....: Codeblock que ser� inserida a expressao.       ���
���          �  cExp.....: Express�o a ser inserida no codeblock.         ���
���          �  nLocal...: Local em que ser� inserida a expressao         ���
���          �             0-Inicio 1-Final                               ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  cRet.....: Indica se a lista de express�es do codeblock   ���
���          �             esta vazia(.T.) ou n�o (.F.)                   ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �  O valor retornado � uma string, pois codeblocks n�o podem ���
���          �ser utilizados como retorno de fun��o.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BAddExp(bVal, cExp, nLocal)
	Local cBlock  := ""
	//Local bRet    := ""
	Local nPos    := 0

	Default nLocal := 1

	cBlock := GetCbSource(bVal)
	nPos   := Iif(nLocal = 0, Rat("|", cBlock) + 1, Rat("}", cBlock))
	If !BEmpty(bVal)
		cBlock := Stuff(cBlock, nPos, 0, Iif(nLocal = 0, cExp + ", ", ", " + cExp))
	Else
		cBlock := Stuff(cBlock, nPos, 0, cExp)
	EndIf

Return cBlock


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �'  �Autor  �Fabricio E. da Costa� Data �  07/04/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz o arrendondamento seguindo a precis�o definida nPrecisao���
���          �e considerando como base de arredondamento nFator.          ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          �  nValor...: Valor a ser arredondado.                       ���
���          �  nCasas...: Numero final de casas decimais.                ���
���          �  nPrecisao: Numero de casas decimais a serem consiferadas  ���
���          �             para arredondamento.                           ���
���          �  nFator...: Indica qual a base de arredondamento.          ���
���          �                                                            ���
���          �Retorno:                                                    ���
���          �  nResult..: Valor arredondado conforme parametros.         ���
���          �                                                            ���
���          �Observacao:                                                 ���
���          �  Ex: AbmRound(3.5557, 1, 3, 6) => 3.5                      ���
���          �      AbmRound(3.5557, 1, 4, 6) => 3.6                      ���
���          �      AbmRound(3.5334, 2, 3, 4) => 3.53                     ���
���          �      AbmRound(3.5334, 2, 4, 4) => 3.54                     ���
���          �      AbmRound(3.5334, 1, 4, 4) => 3.6                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AbmRound(nValor, nCasas, nPrecisao, nFator)
	Local nDec    := 0
	Local nResult	:= 0

	nResult := nValor * (10 ^ nPrecisao) / (10 ^ (nPrecisao-(nPrecisao-1)))
	nDec    := nResult - Int(nResult)
	nResult := Int(nResult) + Iif(nDec >= nFator / 10, 1, 0)
	nResult := Int(nResult) / (10 ^ (nPrecisao - 1))
	If nPrecisao - 1 > nCasas
		nResult := AbmRound(nResult, nCasas, nPrecisao-1, nFator)
	EndIf

Return nResult

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �Conta_Reg �Autor  �Fabricio E. da Costa� Data �  04/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna quantos registros uma instrucao SQL selecionara.    ���
���          �                                                            ���
���          �Parametros:                                                 ���
���          � cSql...: Instrucao SQL ser contada. A instrucao deve estar ���
���          �          sem a clausula ORDER BY.                          ���
���          �Retorno:                                                    ���
���          � Nill                                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GERAL                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function Conta_Reg(cSql)
	Local nCount   := 0
	Local aArea    := GetArea()
	Local cAlias   := Alias()
	Local cSqlCont := ""

	// Monta script contador de registros antes da ordenacao
	cSqlCont := "Select Count(1) QTD From ( " + cSql + " ) AS TMP"
	TCQUERY cSqlCont NEW ALIAS "CONT"
	nCount := CONT->QTD
	CONT->(DbCloseArea())

	DbSelectArea(cAlias)
	RestArea(aArea)
Return nCount

