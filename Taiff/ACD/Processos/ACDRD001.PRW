#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDRD001  º Autor ³ Paulo Bindo        º Data ³  22/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera separação de OPS para coletor                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACDRD001()
	Private lImporta     := Iif(GetMV("MV__ACDRD1")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA


	If lImporta
		MsgStop("Esta rotina ja esta sendo executada ","ACDRD001")
		Return
	EndIf
	PutMv("MV__ACDRD1","S")
	Processa( {||ACDRD1()} )
	PutMv("MV__ACDRD1","N")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDRD001  ºAutor  ³Microsiga           º Data ³  03/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ACDRD1()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oListBox
	Local nOpc		:= 0
	Local oBmp1, oBmp2//, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local lMarca 	:= .F.
	Local nNumDados	:= 0
	Local j			:= 0
	Local Kx		:= 0

	Private nMaxItens	:= GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
	Private cTipExp	:= ""
	Private aDados	:= {}
	Private oDlgPedidos
	Private aLogOS	:= {}
	Private cPerg	:= "ACDRD1"
	Private nQOP	:= 0
	Private nQItens	:= 0
	Private nQTItens:= 0
	Private oQOP, oQItens, oQTItens
	Private cPesqPV := Space(13)
	nMaxItens := If(Empty(nMaxItens),99,nMaxItens)

	nConfLote  := 2//MV_PAR01
	nEmbSimul  := 2//MV_PAR02
	nEmbalagem := 2//MV_PAR03
	nGeraNota  := 2//MV_PAR04
	nImpNota   := 2//MV_PAR05
	nImpEtVol  := 2//MV_PAR06
	nEmbarque  := 2//MV_PAR07
	nAglutPed  := 2//MV_PAR08
	nAglutArm  := 2//MV_PAR09


	// analisar a pergunta '00-Separcao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07=Aglutina Pedido,08-Aglutina Local,09-Pre-Separacao'
	If nEmbSimul == 1 // Separacao com Embalagem Simultanea
		cTipExp := "01*"
	Else
		cTipExp := "00*" // Separacao Simples
	EndIF
	If nEmbalagem == 1 // Embalagem
		cTipExp += "02*"
	EndIF
	If nGeraNota == 1 // Gera Nota
		cTipExp += "03*"
	EndIF
	If nImpNota == 1 // Imprime Nota
		cTipExp += "04*"
	EndIF
	If nImpEtVol == 1 // Imprime Etiquetas Oficiais de Volume
		cTipExp += "05*"
	EndIF
	If nEmbarque == 1 // Embarque
		cTipExp += "06*"
	EndIF
	If nAglutPed == 1 // Aglutina pedido
		cTipExp +="11*"
	EndIf
	If nAglutArm == 1 // Aglutina armazem
		cTipExp +="08*"
	EndIf


	If nConfLote == 1 // confere lote
		cTipExp +="10*"
	EndIf

	nRec := Len(aOPs)

	If nRec == 0
		MsgStop("Não existem OPs!","Atenção")		
		Return
	EndIf

	ValidPerg()
	Pergunte(cPerg,.T.)

	ProcRegua(nRec)

	aDados	 := {}	

	For Kx:=1 To Len(aOPs)


		IncProc("Montando os itens a serem selecionados")
		If aOPs[Kx][1] >= mv_par02 .And. aOPs[Kx][1] <= mv_par03;
		.And. aOPs[Kx][3] >= mv_par04 .And. aOPs[Kx][3] <= mv_par05;
		.And. aOPs[Kx][4] >= mv_par07 .And. aOPs[Kx][4] <= mv_par08;
		.And. aOPs[Kx][5] >= mv_par10 .And. aOPs[Kx][5] <= mv_par11

			If (mv_par09 == 1 .And.!aOPs[Kx][2] $ "Faltas|Parcial|") .Or. mv_par09 == 2
				//POSICIONA NA TABELA DE OPS 
				dbSelectArea("SC2")
				dbSetOrder(1)
				dbSeek(xFilial()+aOPs[Kx][1])

				//POSICIONA NO CADASTRO DE PRODUTOS
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial()+SC2->C2_PRODUTO)			

				// 01 - COR , 02 - MARK, 03 - OP, 04- PRODUTO, 05- DESCRICAO, 06 - INCIO PRODUCAO ,07 - RECURSO
				aAdd(aDados,{fColor(),lMarca,aOPs[Kx][1],SB1->B1_COD, SB1->B1_DESC, aOPs[Kx][3], aOPs[Kx][5]})
			EndIf
		EndIf
	Next Kx

	If Len(aDados) == 0
		MsgStop("Não existem dados para esta selecao!","Atenção")		
		Return
	EndIf

	If mv_par06 == 1 //DATA
		aSort(aDados,,,{|x,y| x[6] < y[6]})
	ElseIf mv_par06 == 2 //OP
		aSort(aDados,,,{|x,y| x[3] < y[3]})
	Else //RECURSO
		aSort(aDados,,,{|x,y| x[7] < y[7]})
	EndIf


	//MONTA O CABECALHO

	aTitCampos := {"", " ",OemToAnsi("Recurso"),OemToAnsi("OP"),OemToAnsi("Produto"),OemToAnsi("Descrição"),OemToAnsi("Dt.Inicio"),''}

	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][7],aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],}"


	bLine := &( "{ || " + cLine + " }" )
	nMult := 7
	aCoord2 := {nMult*1,nMult*1,nMult*6,nMult*6,nMult*8,nMult*6}

	@ 100,005 TO 600,950 DIALOG oDlgPedidos TITLE "OPs"

	oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || (MarcaTodos(oListBox, .T., .T.,1,oListBox:nAt),oDlgPedidos:Refresh()) } //{ || aDados[oListBox:nAt,1] := Iif(aDados[oListBox:nAt,1]==.T.,.F.,.T.)}
	oListBox:bLine := bLine

	//TOTAL DE ITENS
	/*
	@ 187, 005 SAY "Atrasados" OF oDlgPedidos Color CLR_RED PIXEL
	@ 187, 060 GET oADias 	Var nADias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	//@ 187, 060 SAY Transform(nADias,"@e 99999") OF oDlgPedidos Color CLR_RED PIXEL

	@ 187, 115 SAY "Entrega 1 Dia" OF oDlgPedidos Color CLR_BROWN PIXEL
	@ 187, 170 GET o1Dias 	Var n1Dias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	//@ 187, 170 SAY Transform(n1Dias,"@e 99999") OF oDlgPedidos Color CLR_BROWN PIXEL

	@ 187, 225 SAY "Entrega 2 Dias ou Mais" OF oDlgPedidos Color CLR_GREEN PIXEL
	@ 187, 280 GET o2Dias 	Var n2Dias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	//@ 187, 280 SAY Transform(n2Dias,"@e 99999") OF oDlgPedidos Color CLR_GREEN PIXEL

	@ 187, 335 SAY "Valor" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 187, 390 GET oPValor 	Var nPValor	Picture "@e 9,999,999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	*/


	@ 200, 005 SAY "OPs" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 060 GET oQOP 	Var nQOP 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	@ 200, 115 SAY "Itens Distintos" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 170 GET oQItens 	Var nQItens 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	@ 200, 225 SAY "Total Itens" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 280 GET oQTItens	Var nQTItens	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	/*
	@ 200, 335 SAY "Total Peças" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	*/

	//BOTOES
	//	@ 220,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgPedidos
	@ 220,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgPedidos
	If mv_par09 == 1 //GERAR ONDA
		@ 220,110 BUTTON "Gerar"   	   		SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()}  PIXEL OF oDlgPedidos
	Else
		@ 220,110 BUTTON "Exportar"	   		SIZE 40,15 ACTION {ExpExcel()}  PIXEL OF oDlgPedidos	
	EndIf	
	//@ 220,160 BUTTON "Vis.Pedido"		SIZE 40,15 ACTION U_VERPEDIDO(aDados[oListBox:nAT][3], cFilAnt) PIXEL OF oDlgPedidos
	@ 220,210 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	@ 220,310 SAY "Busca OP:" SIZE 65,9 PIXEL OF oDlgPedidos
	@ 220,360 MSGET oSeek VAR cPesqPV SIZE 40,7 Valid (Iif(!Empty(cPesqPV),(Busca(cPesqPV,oListBox),cPesqPV := Space(13),oListBox:Refresh(),oSeek:SetFocus()),)) PIXEL OF oDlgPedidos

	@ 240, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 015 SAY "Atendido" OF oDlgPedidos Color CLR_GREEN PIXEL

	@ 240, 080 BITMAP oBmp2 ResName 	"BR_AMARELO" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 090 SAY "Parcial" OF oDlgPedidos Color CLR_RED PIXEL


	ACTIVATE DIALOG oDlgPedidos CENTERED


	If nOpc == 0
		Return
	EndIf

	If nOpc == 1
		//LIBERA AS OPS
		nQOP	:= 0
		nQItens	:= 0
		nQTItens:= 0


		nNumDados := Len(aDados)
		ProcRegua(nNumDados)
		For J:= 1 To nNumDados
			If J<= nNumDados
				IncProc("Preparando as OPs "+aDados[J][3])
				Processmessages()
				If !aDados[J][2]
					aDel(aDados,J)
					aSize(aDados,len(aDados)-1)
					nNumDados--
					J--
				EndIf
			EndIf
		Next

		If Len(aDados) > 0
			LibOP()
		EndIf
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDRD001  ºAutor  ³Microsiga           º Data ³  03/14/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LibOP()
	Local cOrdSep,aOrdSep := {},nI
	Local aRecSC2   := {}
	Local cTipExp
	Local aItemCB8  := {}
	Local lSai      := .f.
	Local cArm      := Space(Tamsx3("B1_LOCPAD")[1])
	Local cTM	    := GetMV("MV_CBREQD3")
	Local lConsEst  := SuperGetMV("MV_CBRQEST",,.F.)  //Considera a Estrutura do Produto x Saldo na geracao da Ordem de Separacao
	Local lParcial  :=  .F.//SuperGetMV("MV_CBOSPRC",,.F.)  //Permite ou nao gerar Ordens de Separacoes parciais
	Local lGera		:= .T.
	Local nSalTotIt := 0
	Local nSaldoEmp := 0
	Local aSaldoSBF := {}
	Local aSaldoSDC := {}
	Local nSldGrv   := 0
	Local nRetSldEnd:= 0
	Local nRetSldSDC:= 0
	Local nSldAtu   := 0
	Local nQtdEmpOS := 0
	Local nPosEmp    
	Local nX
	Local aTravas	:= {}
	Local cArmOri	:= "02"	//ARMAZEM DE SEPARACAO
	Local KK		:= 0
	Private aLogOS := {}
	Private aEmp   := {}
	Private nReqMatOP := 2
	Private nAglutArmOP := 2
	Private nPreSep := 2

	// analisar a pergunta '00-Separcao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07-Requisita'
	cTipExp := "00*"

	If nReqMatOP == 1
		cTipExp += "07*" //Requisicao
	EndIf

	If nAglutArmOP == 1 // Aglutina armazem
		cTipExp +="08*"
	EndIf

	If nPreSep == 1 // Pre-Separacao
		cTipExp +="09*"
	EndIf


	//QUANDO NUMERO UNICO PARA PRE SEPARACAO E SEPARACAO
	cQuery := " SELECT MAX(CB7__PRESE) NEXTNUM FROM "+RetSqlName("CB7")+" WITH(NOLOCK)"
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB7_FILIAL = '"+xFilial("CB7")+"'"
	MEMOWRITE("ACDRD001A.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

	dbSelectArea("TRB1")
	dbGoTop()
	If Empty(TRB1->NEXTNUM)
		cNumUnic := "000001"
	Else
		cNumUnic := Soma1(TRB1->NEXTNUM,6)
	EndIf
	TRB1->(dbCloseArea())




	SB2->(DbSetOrder(1))
	SD4->(DbSetOrder(2))
	SDC->(dbSetOrder(2))
	CB7->(DbSetOrder(1))
	ProcRegua(Len(aDados))
	For kk:=1 To Len(aDados)
		IncProc("Gerando separacao da OP "+aDados[KK][3])
		Processmessages()

		cNumOP := aDados[kk][3]

		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial()+cNumOP)
		While !Eof() .And. C2_NUM+C2_ITEM+C2_SEQUEN == AllTrim(cNumOP)


			CB8->(DbSetOrder(6))
			If CB8->(DbSeek(xFilial("CB8")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
				If CB7->(DbSeek(xFilial("CB7")+CB8->CB8_ORDSEP)) .and. CB7->CB7_STATUS # "9" // Ordem em aberto
					//Grava o historico das geracoes:
					aadd(aLogOS,{"2","OP",SC2->(C2_NUM+C2_ITEM+C2_SEQUEN),"","","Existe uma Ordem de Separacao em aberto para esta Ordem de Producao","NAO_GEROU_OS"}) //
					IncProc()
					SC2->(dbSkip())
					Loop
				Endif
			EndIf
			lSai := .f.
			aEmp := {}
			//Begin Transaction
				SD4->(DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
				While SD4->(! Eof() .And. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					If Empty(SD4->D4_QUANT)
						SD4->(DbSkip())
						Loop
					Endif

					SB1->(DBSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD)) .AND. (Alltrim(SB1->B1_TIPO) == "MO" .Or. SB1->B1_APROPRI == "I") 
						SD4->(DbSkip())
						Loop
					Endif

					//TIRA ITENS QUE SERAO DE APROPRIACAO INDIRETA(KANBAN), QUANDO AJUSTA NA SB1 TIRAR ESTE TRECHO DA ROTINA
					If AllTrim(SD4->D4_COD) $ "623150035|617060025|617060067|617060068|623000463|623000879|623050462|623050876|623100585|623150000|623150001|623150002|623150005|623150007|623150011|623150016|623150018|623150019|623150033|623150034|623260059|623300000|623300001|625200018|960100001|960100007|960902400|625000246|625000286|625000606|625000609|625000671|625000706|625000707|625000708|625000709|625000710|625000711|625000712|625000713|625000714|625000715|625000716|625000717|625000718|625000719|625000720|625000721|625000722|625000723|625000724|625000725|625000726|625000727|625000728|625000729|625000730|625000733|625000734|625000735|625000736|625000737|625000738|625000739|625000740|625000741|625000742|625000743|625000744|625000745|625000746|625000747|625000750|625000751|625000757|625000768|625000769|625000787|625000790|625000791|625000792|625000793|625000797|625050260|625050332|625050333|625050335|625050336|625050337|625050338|625050341|625050342|625050344|625050345|625050349|625050354|625050355|625050356|625050357|625050358|625050360|625050361|625050362|625050363|625050372|625050374|625050379|625050380|625050381|625050386|625050391|625050393|625050394|625050395|625050396|625100074|625100080|625100280|625100281|625100282|625100283|625100284|625100285|625100286|625100293|625100294|625100296|625100297|606020004|606020006|606020007|960000015|625050401|625000814|625000815|625100221|625000815|625000816|625050364|625000818|625000843|625000834|625000840|625000825|625000826|625000827|625000828|625000829|625000830|625000831|625000832|625000833|625000835|625000836|625000837|625000838|625000839|625000841|625000842|625000843|625000852"				
						SD4->(DbSkip())
						Loop
					Endif

					If !Localiza(SD4->D4_COD) // Nao controla endereco
						SB2->(DbSeek(xFilial("SB2")+SD4->(D4_COD+cArmOri))) //paulo
						nSldAtu := If(CBArmProc(SD4->D4_COD,cTM),SB2->B2_QATU,SaldoSB2())
						nPosEmp := Ascan(aEmp,{|x| x[02] == SD4->D4_COD})
						If nPosEmp == 0
							aadd(aEmp,{SD4->D4_OP,SD4->D4_COD,SD4->D4_QUANT,nSldAtu,0,0,0})
						Else
							aEmp[nPosEmp,03] += SD4->D4_QUANT
						Endif
						SD4->(DbSkip())
						Loop
					Endif

					If RetSldSDC(SD4->D4_COD,cArmOri,SD4->D4_OP,.t.,,,SD4->D4_TRT) == 0 
						aAreaSC2:=GetArea("SC2")
						aAreaSD4:=GetArea("SD4")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza arquivo de empenhos               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						U_ACDGravaEmp(SD4->D4_COD,;
						cArmOri,;
						SD4->D4_QUANT,;
						SD4->D4_QTSEGUM,;
						SD4->D4_LOTECTL,;
						SD4->D4_NUMLOTE,;
						NIL,;
						NIL,;
						SD4->D4_OP,;
						SD4->D4_TRT,;
						NIL,;
						NIL,;
						"SC2",;
						SD4->D4_OPORIG,;
						SD4->D4_DATA,;
						@aTravas,;
						.F.,;		//CONTROLA INCLUSAO(.F.) OU ESTORNO(.T.)
						NIL,;
						NIL,;
						.F.,;		//GRAVA SD4
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						NIL,;
						IIF(cPaisLoc=="BRA",SD4->D4_CODLAN,NIL))
						RestArea(aAreaSC2)
						RestArea(aAreaSD4)
					EndIf



					If !CBArmProc(SD4->D4_COD,cTM) .AND. If(!lParcial,(SD4->D4_QUANT > (nRetSldSDC := RetSldSDC(SD4->D4_COD,cArmOri,SD4->D4_OP,.t.))),.F.) .AND. !lConsEst 
						//Grava o historico das geracoes:
						aadd(aLogOS,{"2","OP",SD4->D4_OP,SD4->D4_COD,"","O produto "+Alltrim(SD4->D4_COD)+" nao encontra-se empenhado (SD4 x SDC)","NAO_GEROU_OS"}) //######
						lSai := .t.
					ElseIf CBArmProc(SD4->D4_COD,cTM) .AND. If(!lParcial,(SD4->D4_QUANT > (nRetSldEnd := RetSldEnd(SD4->D4_COD,.t.))),.F.) .AND. !lConsEst
						//Grava o historico das geracoes:
						aadd(aLogOS,{"2","OP",SD4->D4_OP,SD4->D4_COD,"","O produto "+Alltrim(SD4->D4_COD)+" nao possui saldo enderecado suficiente."+CHR(13)+CHR(10)+"        (ou existem Ordens de Separacao ainda nao requisitadas)","NAO_GEROU_OS"}) //### //###
						lSai := .t.
					EndIf

					nPosEmp := Ascan(aEmp,{|x| x[02] == SD4->D4_COD})
					If nPosEmp == 0
						aadd(aEmp,{SD4->D4_OP,SD4->D4_COD,SD4->D4_QUANT,If(CBArmProc(SD4->D4_COD,cTM),nRetSldEnd,nRetSldSDC),0,0,0})
					Else
						aEmp[nPosEmp,03] += SD4->D4_QUANT
					Endif
					SD4->(DbSkip())
				EndDo


				If lConsEst  //Considera a Estrutura do Produto x Saldo na geracao da Ordem de Separacao
					If SemSldOS()
						//Grava o historico das geracoes:
						aadd(aLogOS,{"2","OP",SD4->D4_OP,SD4->D4_COD,"","Os itens empenhados nao possuem saldo em estoque suficiente para a producao de uma unidade do produto da OP","NAO_GEROU_OS"}) //
						lSai := .t.
					Endif
				Endif
				//QUANDO GERA ALGUMA INCONSISTENCIA LIMPA A SDC
				If lSai
					MsgAlert("Verifique o LOG no final da rotina, existem OPs que não possuem saldo suficiente","ACDRD001")
					IncProc()
					aAreaSC2:=GetArea("SC2")
					aAreaSD4:=GetArea("SD4")

					dbSelectArea("SD4")
					dbSetOrder(2)
					dbGoTop()
					dbSeek(xFilial()+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					While !Eof() .And.  (SD4->D4_FILIAL+Left(SD4->D4_OP,11)) == (xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
						dbSelectArea("SDC")
						dbSetOrder(2)
						If dbSeek(xFilial()+SD4->D4_COD+cArmOri+SD4->D4_OP+SD4->D4_TRT+SD4->D4_LOTECTL+SD4->D4_NUMLOTE)							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza arquivo de empenhos               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							U_ACDGravaEmp(SD4->D4_COD,;
							cArmOri,;
							SD4->D4_QUANT,;
							SD4->D4_QTSEGUM,;
							SD4->D4_LOTECTL,;
							SD4->D4_NUMLOTE,;
							NIL,;
							NIL,;
							SD4->D4_OP,;
							SD4->D4_TRT,;
							NIL,;
							NIL,;
							"SC2",;
							SD4->D4_OPORIG,;
							SD4->D4_DATA,;
							@aTravas,;
							.T.,;		//CONTROLA INCLUSAO(.F.) OU ESTORNO(.T.)
							NIL,;
							NIL,;
							.T.,;		//GRAVA SD4
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							NIL,;
							IIF(cPaisLoc=="BRA",SD4->D4_CODLAN,NIL))
						EndIf
						dbSelectArea("SD4")
						dbSkip()
					End
					RestArea(aAreaSC2)
					RestArea(aAreaSD4)
					dbSelectArea("SC2")
					dbSkip()
					Loop
				EndIf

				SD4->(DbSeek(xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN))
				While SD4->(!Eof() .And. D4_FILIAL+Left(D4_OP,11) == xFilial('SD4')+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
					If Empty(SD4->D4_QUANT)
						SD4->(DbSkip())
						Loop
					EndIf  

					SB1->(DBSetOrder(1))
					If SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD)) .AND. (Alltrim(SB1->B1_TIPO) == "MO" .Or. SB1->B1_APROPRI == "I")
						SD4->(DbSkip())
						Loop
					Endif

					//TIRA ITENS QUE SERAO DE APROPRIACAO INDIRETA(KANBAN), QUANDO AJUSTA NA SB1 TIRAR ESTE TRECHO DA ROTINA
					If AllTrim(SD4->D4_COD) $ "623150035|617060025|617060067|617060068|623000463|623000879|623050462|623050876|623100585|623150000|623150001|623150002|623150005|623150007|623150011|623150016|623150018|623150019|623150033|623150034|623260059|623300000|623300001|625200018|960100001|960100007|960902400|625000246|625000286|625000606|625000609|625000671|625000706|625000707|625000708|625000709|625000710|625000711|625000712|625000713|625000714|625000715|625000716|625000717|625000718|625000719|625000720|625000721|625000722|625000723|625000724|625000725|625000726|625000727|625000728|625000729|625000730|625000733|625000734|625000735|625000736|625000737|625000738|625000739|625000740|625000741|625000742|625000743|625000744|625000745|625000746|625000747|625000750|625000751|625000757|625000768|625000769|625000787|625000790|625000791|625000792|625000793|625000797|625050260|625050332|625050333|625050335|625050336|625050337|625050338|625050341|625050342|625050344|625050345|625050349|625050354|625050355|625050356|625050357|625050358|625050360|625050361|625050362|625050363|625050372|625050374|625050379|625050380|625050381|625050386|625050391|625050393|625050394|625050395|625050396|625100074|625100080|625100280|625100281|625100282|625100283|625100284|625100285|625100286|625100293|625100294|625100296|625100297|606020004|606020006|606020007|625050401|625000814|625000815|625100221|625000815|625000816|625050364|625000818|625000843|625000834|625000840|625000825|625000826|625000827|625000828|625000829|625000830|625000831|625000832|625000833|625000835|625000836|625000837|625000838|625000839|625000841|625000842|625000843|625000852"				
						SD4->(DbSkip())
						Loop
					Endif


					If !("08*" $ cTipExp)  // gera ordem de separacao por armazem
						cArm :=If(CBArmProc(SD4->D4_COD,cTM),SB1->B1_LOCPAD,cArmOri)
					Else  // gera ordem de separa com todos os armazens
						cArm :=Space(Tamsx3("B1_LOCPAD")[1])
					EndIf
					If "09*" $ cTipExp // AGLUTINA PARA PRE-SEPARACAO
						cOP:= Space(Len(SD4->D4_OP))
					Else
						cOP:= SD4->D4_OP
					Endif
					CB7->(DbSetOrder(5))
					If ! CB7->(DbSeek(xFilial("CB7")+cOP+cArm+" "))
						cOrdSep   := GetSX8Num( "CB7", "CB7_ORDSEP" )
						CB7->(RecLock( "CB7", .T. ))
						CB7->CB7_FILIAL := xFilial( "CB7" )
						CB7->CB7_ORDSEP := cOrdSep
						CB7->CB7_OP     := cOP
						CB7->CB7_LOCAL  := cArm
						CB7->CB7_DTEMIS := dDataBase
						CB7->CB7_HREMIS := Time()
						CB7->CB7_STATUS := " "   // gravar STATUS de nao iniciada somente depois do processo
						CB7->CB7_CODOPE := ''
						CB7->CB7_PRIORI := "1"
						CB7->CB7_ORIGEM := "3"
						CB7->CB7_TIPEXP := cTipExp 
						CB7->CB7__PRESEP:= cNumUnic
						CB7->CB7__TRAVA := "S"
						CB7->CB7__SEQPR := 1

						ConfirmSX8()
						//Grava o historico das geracoes:
						aadd(aLogOS,{"1","OP",SD4->D4_OP,"",cArm,"",CB7->CB7_ORDSEP})
						aadd(aOrdSep,cOrdSep)
					EndIf

					If Localiza(SD4->D4_COD) //controla endereco

						If !CBArmProc(SD4->D4_COD,cTM)
							aSaldoSDC := RetSldSDC(SD4->D4_COD,cArmOri,SD4->D4_OP,.F.,SD4->D4_LOTECTL,SD4->D4_TRT)
							nSalTotIt := 0
							For nX:=1 to Len(aSaldoSDC)
								nSalTotIt+=aSaldoSDC[nX,7]
							Next
							If lConsEst
								nSaldoEmp := RetEmpOS(lConsEst,SD4->D4_COD,SD4->D4_QUANT)
							EndIf

							// Separacoes sao geradas conf. empenhos nos enderecos (SDC)
							For nX:=1 to Len(aSaldoSDC)
								lGera := .T.
								If !lConsEst
									nSaldoEmp := RetEmpOS(lConsEst,SD4->D4_COD,aSaldoSDC[nX,7])
								EndIf
								If (!lConsEst .And. !lParcial) .And. SD4->D4_QTDEORI <> nSalTotIt
									Exit
								ElseIf lConsEst .And. nSaldoEmp == 0
									lGera := .F.
								Else
									nSldGrv   := aSaldoSDC[nX,7]
									nSaldoEmp -= aSaldoSDC[nX,7]
								EndIf
								If lGera
									cOrdSep := CB7->CB7_ORDSEP
									CB8->(RecLock( "CB8", .T. ))
									CB8->CB8_FILIAL := xFilial( "CB8" )
									CB8->CB8_ORDSEP := cOrdSep
									CB8->CB8_OP     := SD4->D4_OP
									CB8->CB8_ITEM   := RetItemCB8(cOrdSep,aItemCB8)
									CB8->CB8_PROD   := SD4->D4_COD
									CB8->CB8_LOCAL  := aSaldoSDC[nX,2]
									CB8->CB8_QTDORI := nSldGrv
									CB8->CB8_SALDOS := nSldGrv
									If nEmbalagem == 1
										CB8->CB8_SALDOE := nSldGrv
									EndIf
									CB8->CB8_LCALIZ := aSaldoSDC[nX,3]
									CB8->CB8_SEQUEN := ""
									CB8->CB8_LOTECT := aSaldoSDC[nX,4]
									CB8->CB8_NUMLOT := aSaldoSDC[nX,5]
									CB8->CB8_NUMSER := aSaldoSDC[nX,6]
									CB8->CB8_CFLOTE := "1"
									If "09*" $ cTipExp
										CB8->CB8_SLDPRE := nSldGrv
									EndIf
									CB8->(MsUnLock())
									//Atualizacao do controle do numero de itens a serem impressos
									dbSelectArea("CB7")
									RecLock("CB7",.F.)
									CB7_NUMITE++
									CB7->(MsUnLock())

								EndIf
							Next
							SD4->(DbSkip())	
						Else
							aSaldoSBF := RetSldEnd(SD4->D4_COD,.f.)
							If lConsEst
								nSaldoEmp := RetEmpOS(lConsEst,SD4->D4_COD,SD4->D4_QUANT)
							EndIf	
							For nX:=1 to Len(aSaldoSBF)
								If !lConsEst
									nSaldoEmp := RetEmpOS(lConsEst,SD4->D4_COD,SD4->D4_QUANT)
								EndIf
								If (!lConsEst .And. !lParcial) .and. SD4->D4_QTDEORI <> aSaldoSDC[nX,7]
									SD4->(DbSkip())
									Exit
								ElseIf lConsEst .And. nSaldoEmp == 0
									SD4->(DbSkip())
									Exit
								Else
									nSldGrv   := aSaldoSDC[nX,7]
									nSaldoEmp -= aSaldoSDC[nX,7]
								EndIf
								cOrdSep := CB7->CB7_ORDSEP
								CB8->(RecLock( "CB8", .T. ))
								CB8->CB8_FILIAL := xFilial( "CB8" )
								CB8->CB8_ORDSEP := cOrdSep
								CB8->CB8_OP     := SD4->D4_OP
								CB8->CB8_ITEM   := RetItemCB8(cOrdSep,aItemCB8)
								CB8->CB8_PROD   := SD4->D4_COD
								CB8->CB8_LOCAL  := aSaldoSBF[nX,2]
								CB8->CB8_QTDORI := nSldGrv
								CB8->CB8_SALDOS := nSldGrv
								If nEmbalagem == 1
									CB8->CB8_SALDOE := nSldGrv
								EndIf
								CB8->CB8_LCALIZ := aSaldoSBF[nX,3]
								CB8->CB8_SEQUEN := ""
								CB8->CB8_LOTECT := aSaldoSBF[nX,4]
								CB8->CB8_NUMLOT := aSaldoSBF[nX,5]
								CB8->CB8_NUMSER := aSaldoSBF[nX,6]
								CB8->CB8_CFLOTE := "1"
								If "09*" $ cTipExp
									CB8->CB8_SLDPRE := nSldGrv
								EndIf
								CB8->(MsUnLock())
								//Atualizacao do controle do numero de itens a serem impressos
								dbSelectArea("CB7")
								RecLock("CB7",.F.)
								CB7_NUMITE++
								CB7->(MsUnLock())

								SD4->(DbSkip())					
							Next
						Endif
					Else
						cOrdSep   := CB7->CB7_ORDSEP
						nQtdEmpOS := RetEmpOS(lConsEst,SD4->D4_COD,SD4->D4_QUANT)
						CB8->(RecLock( "CB8", .T. ))
						CB8->CB8_FILIAL := xFilial( "CB8" )
						CB8->CB8_ORDSEP := cOrdSep
						CB8->CB8_OP     := SD4->D4_OP
						CB8->CB8_ITEM   := RetItemCB8(cOrdSep,aItemCB8)
						CB8->CB8_PROD   := SD4->D4_COD
						CB8->CB8_LOCAL  := If(CBArmProc(SD4->D4_COD,cTM),SB1->B1_LOCPAD,cArmOri)
						CB8->CB8_QTDORI := nQtdEmpOS
						CB8->CB8_SALDOS := nQtdEmpOS
						If nEmbalagem == 1
							CB8->CB8_SALDOE := nQtdEmpOS
						EndIf
						CB8->CB8_LCALIZ := Space(15)
						CB8->CB8_SEQUEN := ""
						CB8->CB8_LOTECT := SD4->D4_LOTECTL
						CB8->CB8_NUMLOT := SD4->D4_NUMLOTE
						CB8->CB8_CFLOTE := "1"
						If "09*" $ cTipExp
							CB8->CB8_SLDPRE := nQtdEmpOS
						EndIf
						CB8->(MsUnLock())
						//Atualizacao do controle do numero de itens a serem impressos
						dbSelectArea("CB7")
						RecLock("CB7",.F.)
						CB7_NUMITE++
						CB7->(MsUnLock())

						SD4->(DbSkip())
					Endif
				EndDo
				aadd(aRecSC2,SC2->(Recno()))
				IncProc()
			//End Transaction
			SC2->( dbSkip() )
		EndDo
	Next
	CB7->(DbSetOrder(1))
	For nI := 1 to len(aOrdSep)
		CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
		CB7->(RecLock("CB7"))
		CB7->CB7_STATUS := "0"  // nao iniciado
		CB7->(MsUnlock())
	Next
	For nI := 1 to len(aRecSC2)
		SC2->(DbGoto(aRecSC2[nI]))
		SC2->(RecLock("SC2"))
		SC2->C2_ORDSEP := cOrdSep
		SC2->(MsUnlock())
	Next

	If lParcial .and. Empty(aOrdSep) .and. !Empty(aLogOS) // Quando permitir parcial somente gera log se nao existir nenhuma item na OS
		LogACDA100()
	Elseif !lparcial .and.!Empty(aLogOS)
		LogACDA100()
	EndIf

	//ATUALIZA O CABECALHO DA ONDA COM O NOME DA ONDA
	cNome := Space(20)
	While Empty(cNome)
		@ 100,153 To 329,435 Dialog oDlg Title OemToAnsi("Nome Onda")
		@ 9,9 Say OemToAnsi("Nome") Size 99,8 Of oDlg Pixel
		@ 28,9 Get cNome  Size 79,10 Of oDlg Pixel

		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)

		Activate Dialog oDlg Centered
	End

	cQuery := " UPDATE "+retSqlName("CB7")"
	cQuery += " SET CB7__NOME = '"+cNome+"'"
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB7__PRESE = '"+cNumUnic+"' AND CB7_OP <> '' AND CB7_FILIAL = '"+cFilAnt+"'"

	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualização"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Paulo Bindo         º Data ³  12/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria pergunta no e o help do SX1                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

	//PutSx1(cGrupo,cOrdem,cPergunt            ,cPerSpa               ,cPerEng               ,cVar ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid	,cF3	, cGrpSxg ,cPyme,cVar01    ,cDef01     		,cDefSpa1,cDefEng1,cCnt01,cDef02  				,cDefSpa2,cDefEng2,cDef03	,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Numero OPs         ?",""                    ,""                    ,"mv_ch1","N"   ,03      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par01",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Nº Inicial         ?",""                    ,""                    ,"mv_ch2","C"   ,13      ,0       ,0      , "G",""    ,"SC2"	,""      ,""   ,"mv_par02",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Nº Final           ?",""                    ,""                    ,"mv_ch3","C"   ,13      ,0       ,0      , "G",""    ,"SC2" 	,""      ,""   ,"mv_par03",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Da Data            ?",""                    ,""                    ,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par04",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Até a Data         ?",""                    ,""                    ,"mv_ch5","D"   ,08      ,0       ,0      , "G",""    ,"" 		,""      ,""   ,"mv_par05",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Ordena por         ?",""                    ,""                    ,"mv_ch6","N"   ,01      ,0       ,0      , "C",""    ,"" 		,""      ,""   ,"mv_par06","Inicio"  		,""      ,""      ,""    ,"OP"		  		    ,""     ,""      ,"Recurso"		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Do Produto         ?",""                    ,""                    ,"mv_ch7","C"   ,15      ,0       ,0      , "G",""    ,"SB1" 	,""      ,""   ,"mv_par07",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Ate o Produto      ?",""                    ,""                    ,"mv_ch8","C"   ,15      ,0       ,0      , "G",""    ,"SB1" 	,""      ,""   ,"mv_par08",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Gerar              ?",""                    ,""                    ,"mv_ch9","N"   ,01      ,0       ,0      , "C",""    ,""   	,""      ,""   ,"mv_par09","Onda"      		,""      ,""      ,""    ,"Simulacao"			,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Do Recurso         ?",""                    ,""                    ,"mv_ch0","C"   ,06      ,0       ,0      , "G",""    ,"SH1" 	,""      ,""   ,"mv_par10",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"11"   ,"Ate o Recurso      ?",""                    ,""                    ,"mv_cha","C"   ,06      ,0       ,0      , "G",""    ,"SH1" 	,""      ,""   ,"mv_par11",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


	cKey     := "P.ACDRD101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o numero de OPs ")
	aAdd(aHelpPor,"a serem separados")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.ACDRD102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número inicial da OP ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.ACDRD103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número Final da OP    ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.ACDRD104."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data inicial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.ACDRD105."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.ACDRD106."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a forma")
	aAdd(aHelpPor,"em que os pedidos serão apresentados ")
	aAdd(aHelpPor,"na tela")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³InverteSelºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte Selecao do list box - totalizadores                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca,nItem)


	If lInverte
		oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
	Else
		If lMarca
			oListbox:aArray[nLin,2] := .T.
		Else
			oListbox:aArray[nLin,2] := .F.
		EndIf
	EndIf
	// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - BLOQUEIOS, 05 - COD CLI, 06 - RAZAO, 07 - COD TRANS, 08 - NOME TRANS, 09 - VALOR, 10 - VOLUME, 11 - ITEM PED, 12 - ITEM LIB, 13-NOTA

	If nItem == 1
		If oListbox:aArray[nLin,2] == .F.
			Return(.F.)
		ElsE
			Return(.T.)
		EndIf
	Else
		aDados[nLin,2] := oListbox:aArray[nLin,2]
		Return (oListbox:aArray[nLin,2])
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MarcaTodosºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Marca todos as opcoes do list box - totalizadores           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca,nItem,nPos)
	Local nX
	Local cQOP 	:= ""
	Local lRet 	:= .T.
	Local K2   	:= 0
	Local kk	:= 0
	Local k1	:= 0

	If lMarca
		For K1 :=1 To Len(a2ItOPs)
			//VERIFICA SE A OP E IGUAL A MARCADA
			If a2ItOPs[K1][2] == oListbox:aArray[nPos,3]
				//a2ItOPs {01-COR, 02-OP, 03-COD PROD, 04-DESCRICAO, 05-QTDEMP, 06-QTDE OPS, 07-SALDO DISP., 08-SALDO CLASS.,09-SALDO CQ,10-LSEPARA}					

				//a2OPs{01-PRODUTO, 02-EMPENHO, 03-DISPONIBILIDADE, 04-SALDO UTILIZADO}
				nAscan := Ascan(a2OPs, {|e| e[1] == a2ItOPs[K1][3] })
				If nAscan == 0
					MsgStop("Item "+a2ItOPs[K1][3]+" nao encontrado na OP "+a2ItOPs[K1][2],"ACDRD001")						
				Else
					If mv_par09 == 1 //GERAR ONDA
						//QUANDO POSSUI SALDO PARA SEPARAR
						If a2ItOPs[K1][5] <= a2OPS[nAscan][3]-a2OPS[nAscan][4] .And. !oListbox:aArray[nPos,2]
							//ATUALIZA ARRAY SALDOS
							a2OPS[nAscan][4] += a2ItOPs[K1][5]
							//ATUALIZA ARRAY DE ITENS
							a2ItOPs[K1][10]  := .T.
						Else //NAO POSSUI SALDO OU ESTA DESMARCANDO
							If !oListbox:aArray[nPos,2]
								MsgStop("Não existe saldo suficiente para o produto "+a2ItOPs[K1][3],"ACDRD001")
							EndIf

							//VOLTA O SALDO DO QUE JA FOI LIBERADO NESTA OP
							For K2:=1 To Len(a2ItOPs) 								
								//SOMENTE PARA ITENS QUE ESTAO COM STATUS DE LIBERADO
								If a2ItOPs[K2][10] .And. a2ItOPs[K2][2] == oListbox:aArray[nPos,3]
									nAscan := Ascan(a2OPs, {|e| e[1] == a2ItOPs[K2][3] })
									a2OPS[nAscan][4] -= a2ItOPs[K1][5]
									a2ItOPs[K2][10]  := .F.
								EndIf
							Next
							//atualiza o array desmarcando
							lRet := .F. 
							oListbox:aArray[nPos,2] := .F.
							//SAI DO FOR 
							Exit
						EndIf
					Else
						//ATUALIZA ARRAY SALDOS
						a2OPS[nAscan][4] += a2ItOPs[K1][5]
						//ATUALIZA ARRAY DE ITENS
						a2ItOPs[K1][10]  := .T.
					EndIf
				EndIf
			EndIf
		Next

		If lRet
			lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
		EndIf

		//ALTERA A LEGENDA DOS ITENS RESTANTES
		For nX := 1 TO Len(oListbox:aArray)
			If !oListbox:aArray[nX,2] .And. nPos # nX 
				//PERCORRE ARRAY DE ITENS
				For kk :=1 To Len(a2ItOPs)
					//VALIDA SE A OP E A MESMA
					If a2ItOPs[kk][2] == oListbox:aArray[nx][3] .And. a2ItOPs[kk][2] # oListbox:aArray[nPos,3]
						//VERIFICA O SALDO DO PRODUTO
						nAscan := Ascan(a2OPs, {|e| e[1] == a2ItOPs[Kk][3] })
						//QTDE EMP <= SALDO - UTILIZADO 
						If a2ItOPs[kk][5] <= a2OPs[nAscan][3]-a2OPs[nAscan][4] 
							oListbox:aArray[nX,1]:=LoadBitMap(GetResources(),"BR_VERDE"    )				
						ElseIf a2ItOPs[kk][5] >= a2OPs[nAscan][3]-a2OPs[nAscan][4] .And. a2OPs[nAscan][3]>0
							oListbox:aArray[nX,1]:=LoadBitMap(GetResources(),"BR_AMARELO"  )							
							Exit
						Else
							oListbox:aArray[nX,1]:=LoadBitMap(GetResources(),"BR_VERMELHO"  )							
							Exit
						EndIf
					EndIf
				Next
			EndIf
		Next

		//EFETUA OS CALCULOS DA TELA
		nQOP	:= 0
		nQItens	:= 0
		nQTItens:= 0	
		For nX := 1 TO Len(oListbox:aArray)

			If oListbox:aArray[nX,2]
				nQOP	++
				cQOP += Iif(nQOP >1,"','","")+oListbox:aArray[nX,3]
			EndIf
		Next


		If !Empty(cQOP)
			cQuery := " SELECT COUNT(DISTINCT(D4_COD)) ITENS, COUNT(D4_COD) QTITENS"
			cQuery += " FROM "+RetSqlName("SD4")+" WITH(NOLOCK)"
			cQuery += " WHERE D_E_L_E_T_ <> '*'
			cQuery += " AND D4_OP IN ('"+cQOP+"')

			MemoWrite("ACDRD001C.SQL",cQuery)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBP", .F., .T.)

			dbSelectArea("TRBP")
			dbGoTop()
			nQItens := TRBP->ITENS
			nQTItens := TRBP->QTITENS
			TRBP->(dbcloseArea())
		EndIf
	Else 
		//DESMARCA TUDO
		nQOP	:= 0
		nQItens	:= 0
		nQTItens:= 0	

		//LIMPA MARCADO
		For nX := 1 TO Len(oListbox:aArray)
			//atualiza o array desmarcando
			oListbox:aArray[nX,2] := .F.
			//VOLTA COR VERDE
			oListbox:aArray[nX,1]:=LoadBitMap(GetResources(),"BR_VERDE"    )
		Next					

		//DEIXA COMO FALSO OS ITENS MARCADOS
		For K2:=1 To Len(a2ItOPs) 								
			a2ItOPs[K2][10]  := .F.
		Next

		//DEIXA SALDO COMO ZEROS NOS PRODUTOS
		For K2:=1 To Len(a2OPS)
			a2OPS[K2][4] := 0
		Next
		lRet := .F. 
	EndIf

	//ATUALIZA A TELA
	oQOP:Refresh()
	oQItens:Refresh()
	oQTItens:Refresh()
	oDlgPedidos:Refresh()
	oListbox:Refresh()

	If nItem > 0
		Return(lRet)
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCOLOR    ºAutor  ³Microsiga           º Data ³  09/22/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O STATUS DO PEDIDO                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fColor()

	If aOPs[kx][2] == 'Atendido'
		Return(LoadBitMap(GetResources(),"BR_VERDE"    ))				
	ElseIf aOPs[kx][2] == 'Parcial'
		Return(LoadBitMap(GetResources(),"BR_AMARELO"  ))
	Else
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"  ))
	EndIf
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Busca    ºAutor  ³Microsiga           º Data ³  15/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Marca na tela registro buscado                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ InforShop                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Busca(cPesq,oListBox)

	Local lOk 	:= .F.
	Local nx	:= 0

	For nX := 1 TO Len(oListbox:aArray)
		If Alltrim(oListbox:aArray[nX,3]) == AllTrim(cPesq)
			MarcaTodos(oListBox, .F., .T.,1,nX)
			lOk := .T.
			oListBox:Refresh()
		EndIf
	Next

	If !lOk
		MsgAlert("O pedido digitado não foi encontrado!","Atenção - ACDRD001")
	Endif

Return(lOk)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RetSldSDC ³ Autor ³ Microsiga             ³ Data ³ 25/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os saldos disponiveis nas Composicoes de Empenho    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetSldSDC(cProd,cLocal,cOP,lRetSaldo,cLote,cSublote,cTRT)
	Local aArea     := GetArea()
	Local aAreaSDC  := SDC->(GetArea())
	Local nSaldoSDC := 0
	Local aSaldoSDC := {}
	Local cQuerySDC
	Local lQuery    :=.F.
	Local cAliasSDC := "SDC"

	DEFAULT cLote := ''
	DEFAULT cSubLote := ''

	lQuery    :=.T.
	cQuerySDC := "SELECT * FROM " + RetSqlName("SDC")
	cQuerySDC += " WHERE DC_PRODUTO = '" + cProd + "' AND DC_LOCAL = '" + cLocal + "' AND DC_OP = '" + cOP + "' AND "
	If !Empty(cLote)
		cQuerySDC += " DC_LOTECTL = '" + cLote + "' AND " 
	EndIf
	If !Empty(cSubLote)
		cQuerySDC += " DC_NUMLOTE = '" + cSubLote + "' AND " 
	EndIf

	If !Empty(cTRT)
		cQuerySDC += " DC_TRT = '" + cTRT + "' AND " 
	EndIf

	cQuerySDC += " LEFT(DC_LOCALIZ,6) <> 'BUFFER' AND "
	cQuerySDC += " DC_FILIAL = '" + xFilial("SDC") + "' AND " + RetSQLName("SDC") + ".D_E_L_E_T_ <> '*'"
	cQuerySDC += " ORDER BY R_E_C_N_O_"

	TCQUERY cQuerySDC NEW ALIAS "SDCTMP"
	dbSelectArea("SDCTMP")
	cAliasSDC := "SDCTMP"

	While (cAliasSDC)->(!Eof() .AND. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP == xFilial("SDC")+cProd+cLocal+cOP)
		nSaldoSDC += (cAliasSDC)->DC_QUANT
		aadd(aSaldoSDC,{(cAliasSDC)->DC_PRODUTO,(cAliasSDC)->DC_LOCAL,(cAliasSDC)->DC_LOCALIZ,(cAliasSDC)->DC_LOTECTL,(cAliasSDC)->DC_NUMLOTE,(cAliasSDC)->DC_NUMSERI,(cAliasSDC)->DC_QUANT,(cAliasSDC)->(recno())})
		(cAliasSDC)->(DbSkip())
	Enddo
	If lQuery
		(cAliasSDC)->( DbCloseArea() )
	Endif
	aSort(aSaldoSDC,,,{|x,y| x[08]<y[08]})

	RestArea(aAreaSDC)
	RestArea(aArea)
Return If(lRetSaldo,nSaldoSDC,aSaldoSDC)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LogACDA100³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 23/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibicao do log das geracoes das Ordens de Separacao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Apos a geracao das OS sao exibidas todas as informacoes que³±±
±±³          ³ ocorreram durante o processo                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LogACDA100()
	Local i, j, k
	Local cChaveAtu, cPedCli, cOPAtual

	//Cabecalho do Log de processamento:
	AutoGRLog(Replicate("=",75))
	AutoGRLog("                         I N F O R M A T I V O") //
	AutoGRLog("               H I S T O R I C O   D A S   G E R A C O E S") //

	//Detalhes do Log de processamento:
	AutoGRLog(Replicate("=",75))
	AutoGRLog("I T E N S   P R O C E S S A D O S :") //
	AutoGRLog(Replicate("=",75))
	If aLogOS[1,2] == "Pedido" 
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[10]+x[03]+x[04]+x[05]+x[06]+x[07]+x[08]<y[01]+y[10]+y[03]+y[04]+y[05]+y[06]+y[07]+y[08]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Pedido + Cliente + Loja + Item + Produto + Local
		cChaveAtu := ""
		cPedCli   := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,10] <> cChaveAtu .OR. (aLogOs[i,03]+aLogOs[i,04] <> cPedCli)
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75))
				Endif
				j:=0
				k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
				cChaveAtu := aLogOs[i,10]
				For j:=k to len(aLogOs)
					If aLogOs[j,10] <> cChaveAtu
						Exit
					Endif
					If Empty(aLogOs[j,08]) //Aglutina Armazem
						AutoGRLog("Pedido: "+aLogOs[j,03]+" - Cliente: "+aLogOs[j,04]+"-"+aLogOs[j,05]) //###
					Else
						AutoGRLog("Pedido: "+aLogOs[j,03]+" - Cliente: "+aLogOs[j,04]+"-"+aLogOs[j,05]+" - Local: "+aLogOs[j,08]) //######
					Endif
					cPedCli := aLogOs[j,03]+aLogOs[j,04]
					If aLogOs[j,10] == "NAO_GEROU_OS"
						Exit
					Endif
					i:=j
				Next
				AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,10],"N A O  G E R A D A")) //###
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog("Motivo: ") //
				Endif
			Endif
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog("Item: "+aLogOs[i,06]+" - Produto: "+AllTrim(aLogOs[i,07])+" - Local: "+aLogOs[i,08]+" ---> "+aLogOs[i,09]) //######
			Endif
		Next
	Elseif aLogOS[1,2] == "Nota" //
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[08]+x[03]+x[04]+x[05]+x[06]<y[01]+y[08]+y[03]+y[04]+y[05]+y[06]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Nota + Serie + Cliente + Loja
		cChaveAtu := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,08] <> cChaveAtu
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75))
				Endif
				cChaveAtu := aLogOs[i,08]
				AutoGRLog("Nota: "+aLogOs[i,3]+"/"+aLogOs[i,04]+" - Cliente: "+aLogOs[i,05]+"-"+aLogOs[i,06]) //###
				AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,08],"N A O  G E R A D A")) //###
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog("Motivo: ") //
				Endif
			Endif
		Next
	Else  //Ordem de Producao
		aLogOS := aSort(aLogOS,,,{|x,y| x[01]+x[07]+x[03]+x[04]<y[01]+y[07]+y[03]+y[04]})
		// Status Ord.Sep(1=Gerou;2=Nao Gerou) + Ordem Separacao + Ordem Producao + Produto
		cChaveAtu := ""
		cOPAtual  := ""
		For i:=1 to len(aLogOs)
			If aLogOs[i,07] <> cChaveAtu .OR. aLogOs[i,03] <> cOPAtual
				If !Empty(cChaveAtu)
					AutoGRLog(Replicate("-",75) )
				Endif
				j:=0
				k:=i  //Armazena o conteudo do contador do laco logico principal (i) pois o "For" j altera o valor de i;
				cChaveAtu := aLogOs[i,07]
				For j:=k to len(aLogOs)
					If aLogOs[j,07] <> cChaveAtu
						Exit
					Endif
					If Empty(aLogOs[j,05]) //Aglutina Armazem
						AutoGRLog("Ordem de Producao: "+aLogOs[i,03]) //
					Else
						AutoGRLog("Ordem de Producao: "+aLogOs[i,03]+" - Local: "+aLogOs[j,05]) //###
					Endif
					cOPAtual := aLogOs[j,03]
					If aLogOs[j,07] == "NAO_GEROU_OS"
						Exit
					Endif
					i:=j
				Next
				AutoGRLog("Ordem de Separacao: "+If(aLogOs[i,01]=="1",aLogOs[i,07],"N A O  G E R A D A")) //###
				If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
					AutoGRLog("Motivo: ") //
				Endif
			Endif
			If aLogOs[i,01] == "2"  //Ordem Sep. NAO gerada
				AutoGRLog(" ---> "+aLogOs[i,06])
			Endif
		Next
	Endif
	MostraParam(aLogOS[1,2])
	MostraErro()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MostraParam ³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 28/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exibicao dos parametros da geracao da Ordem de Separacao     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MostraParam(cTipGer)
	Local cPergParam  := ""
	Local cPergConfig := ""
	Local cDescTipGer := ""
	Local nTamSX1     := 10 //Len(SX1->X1_GRUPO)
	Local aPerg       := {}
	Local aParam      := {}
	Local ni          := 0
	Local ci          := 0
	Local aLogs       := {}

	If cTipGer == "Pedido" //
		cPergParam  := PADR('AIA102',nTamSX1)
		cPergConfig := PADR('AIA106',nTamSX1)
		cDescTipGer := 'PEDIDO DE VENDA' //
		aAdd(aParam,nConfLote)
		aAdd(aParam,nEmbSimul)
		aAdd(aParam,nEmbalagem)
		aAdd(aParam,nGeraNota)
		aAdd(aParam,nImpNota)
		aAdd(aParam,nImpEtVol)
		aAdd(aParam,nEmbarque)
		aAdd(aParam,nAglutPed)
		aAdd(aParam,nAglutArm)
	Elseif cTipGer == "Nota" //
		cPergParam  := PADR('AIA103',nTamSX1)
		cPergConfig := PADR('AIA107',nTamSX1)
		cDescTipGer := 'NOTA FISCAL' //
		aAdd(aParam,nEmbSimuNF)
		aAdd(aParam,nEmbalagNF)
		aAdd(aParam,nImpNotaNF)
		aAdd(aParam,nImpVolNF)
		aAdd(aParam,nEmbarqNF)
	Else //OP
		cPergParam  := PADR('AIA104',nTamSX1)
		cPergConfig := PADR('AIA108',nTamSX1)
		cDescTipGer := 'ORDEM DE PRODUCAO' //
		aAdd(aParam,nReqMatOP)
		aAdd(aParam,nAglutArmOP)
	Endif

	aAdd(aPerg,{"P A R A M E T R O S : "+cDescTipGer,cPergParam}) //
/*
	-------------------------------------------------------------------------------------
	Ronald Piscioneri, 18-Ago-2021: removido acesso direto ao SX1 (alterar para MV_PARnn)
	-------------------------------------------------------------------------------------
	aAdd(aPerg,{"C O N F I G U R A C O E S : "+cDescTipGer,cPergConfig}) //
	//-- Carrega parametros SX1
	SX1->(DbSetOrder(1))
	For ni := 1 To Len(aPerg)
		ci := 1
		aAdd(aLogs,{aPerg[ni,2],{}})
		SX1->(DbSeek(aPerg[ni,2]))
		While SX1->(!Eof() .AND. X1_GRUPO == aPerg[ni,2])
			If	SX1->X1_GSC == 'G'
				cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+Alltrim(X1_CNT01)) //
			Else
				If	ni == 1
					cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(X1_PRESEL==1,'Sim','Nao')) //######
				Else
					cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(aParam[ci++]==1,'Sim','Nao')) //"Pergunta "###'Sim'###'Nao'
				EndIf
			EndIf
			aAdd(aLogs[ni,2],cTexto)
			SX1->(dbSkip())
		EndDo
	Next
*/
	//-- Gera Log
	For ni := 1 To Len(aPerg)
		AutoGRLog(Replicate("=",75))
		AutoGRLog(aPerg[ni,1])
		AutoGRLog(Replicate("=",75))
		For ci := 1 To Len(aLogs[ni,2])
			AutoGRLog(aLogs[ni,2,ci])
		Next
	Next
	AutoGRLog(Replicate("=",75))
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³GravaEmp  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 18.03.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tratamento na geracao de empenhos                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³[1] Lote de Controle                                        ³±±
±±³          ³[2] Sub-Lote                                                ³±±
±±³          ³[3] Localizacao                                             ³±±
±±³          ³[4] Numero de Serie                                         ³±±
±±³          ³[5] Quantidade                                              ³±±
±±³          ³[6] Data de Validade                                        ³±±
±±³          ³[7] Registro do SB2                                         ³±±
±±³          ³[8] Registro do SBF                                         ³±±
±±³          ³[9] Array com Registros do SB8 e qtd                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC01: Codigo do Produto         - Obrigatorio             ³±±
±±³          ³ExpC02: Local                     - Obrigatorio             ³±±
±±³          ³ExpN01: Quantidade                - Obrigatorio             ³±±
±±³          ³ExpN02: Quantidade 2a UM          - Obrigatorio             ³±±
±±³          ³ExpC03: Lote de Controle          - Obrig. se Inf. Sub-Lote ³±±
±±³          ³ExpC04: Sub-Lote                                            ³±±
±±³          ³ExpC05: Localizacao                                         ³±±
±±³          ³ExpC06: Numero de Serie                                     ³±±
±±³          ³ExpC07: Ordem de Producao                                   ³±±
±±³          ³ExpC08: Sequencia do Empenho / Liberacao do Pedido de Venda ³±±
±±³          ³ExpC09: Pedido de Venda                                     ³±±
±±³          ³ExpC10: Item do Pedido de Venda                             ³±±
±±³          ³ExpC11: Origem do Empenho                                   ³±±
±±³          ³ExpC12: Op original                                         ³±±
±±³          ³ExpD01: Data de Entrega do Empenho                          ³±±
±±³          ³ExpA01: Array para o travamento dos saldos, caso nao seja   ³±±
±±³          ³       informado nao havera travamento.                     ³±±
±±³          ³ExpL01: Flag que indica se estorna empenho                  ³±±
±±³          ³ExpL02: Flag que indica se e chamada da Projecao de Estoques³±±
±±³          ³ExpL03: Flag que indica se empenha material do SB2          ³±±
±±³          ³ExpL04: Flag que indica se grava registro no SD4            ³±±
±±³          ³ExpL05: Flag que indica se considera Lotes Vencidos         ³±±
±±³          ³ExpL06: Flag que indica se empenha material no SB8/SBF      ³±±
±±³          ³ExpL07: Flag que indica se CRIA registros no SDC            ³±±
±±³          ³ExpL08: Flag que indica se encerra empenho de OP            ³±±
±±³          ³ExpC13: Identificador do DCF                                ³±±
±±³          ³ExpA02: Array de campos utilizados no ajuste de empenho SD4 ³±±
±±³          ³ExpN03: Posicao atual do elemento do array de campos        ³±±
±±³          ³ExpL09: Flag que indica se a OP esta Encerrada              ³±±
±±³          ³ExpC14: Tipo OP				                              ³±±
±±³          ³ExpC15: Codigo CAT 83			                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACDGravaEmp(cProduto,cLocal,nQtd,nQtd2UM,cLoteCtl,cNumLote,cLocaliza,cNumSerie,cOp,cTrt,cPedido,cItem,cOrigem,cOpOrig,dEntrega,aTravas,lEstorno,lProj,lEmpSB2,lGravaSD4,lConsVenc,lEmpSB8SBF,lCriaSDC,lEncerrOp,cIdDCF,aSalvCols,nSG1,lOpEncer,cTpOp,cCAT83)
	Local i           := 0
	Local z           := 0
	Local nBaixa      := 0
	Local nQuant      := 0
	Local cSeekLoc    := ""
	Local cSeek       := ""
	Local nBaixa2     := 0
	Local nQuant2     := 0
	Local nQtdAtEmpN  := 0
	Local nQtdDif     := 0
	Local aArray	  := {}
	Local aArea		  := GetArea()
	Local aAreaSC2    := {}
	Local aAreaSC6    := {}
	Local lSelLote	  := (SuperGetMV("MV_SELLOTE") == "1")
	Local lAtuSGJ	  := SuperGetMV("MV_PVCOMOP",.F.,.F.) 

	DEFAULT aSalvCols := {}
	DEFAULT cIdDCF    := ''
	DEFAULT lEncerrOp := .F.
	DEFAULT nSG1      := 0
	DEFAULT cTpOp     := "F"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche parametros nao recebidos pela funcao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lProj      := IF(lProj      == NIL, .F., lProj)
	lEstorno   := IF(lEstorno   == NIL, .F., lEstorno)
	lGravaSD4  := IF(lGravaSD4  == NIL, .F., lGravaSD4)
	lEmpSB2    := IF(lEmpSB2    == NIL, .T., lEmpSB2)
	lEmpSB8SBF := IF(lEmpSB8SBF == NIL, lEmpSB2, lEmpSB8SBF)
	lCriaSDC   := IF(lCriaSDC   == NIL, If(Localiza(cProduto), .T., .F.), lCriaSDC)
	cPedido    := IF(cPedido    == NIL, CriaVar("DC_PEDIDO"), cPedido)
	cOpOrig    := IF(cOpOrig    == NIL, CriaVar("D4_OPORIG"), cOpOrig)
	cLoteCtl   := IF(cLoteCtl   == NIL, CriaVar("BF_LOTECTL"), cLoteCtl)
	cNumLote   := IF(cNumLote   == NIL, CriaVar("BF_NUMLOTE", If(SuperGetMV('MV_LOTEUNI', .F., .F.), .F., Nil)),cNumLote)
	cLocaliza  := IF(cLocaliza  == NIL, CriaVar("BF_LOCALIZ"), cLocaliza)
	cNumSerie  := IF(cNumSerie  == NIL, CriaVar("BF_NUMSERI"), cNumSerie)
	cOrigem    := IF(cOrigem    == NIL, CriaVar("DC_ORIGEM"), cOrigem)
	cItem      := IF(cItem      == NIL, CriaVar("DC_ITEM"), cItem)
	cTrt       := IF(cTrt       == NIL, If(lGravaSD4.And.Empty(cPedido),CriaVar("DC_TRT"),CriaVar("DC_SEQ")),cTrt)
	cOp        := IF(cOp        == NIL, CriaVar("DC_OP"), cOp)
	lConsVenc  := IF(lEstorno, .T., IF(lConsVenc == NIL,GetMV('MV_LOTVENC')=='S',lConsVenc))
	nQtd2UM    := IF(nQtd2UM    == NIL, ConvUm(cProduto,nQtd,0,2), nQtd2UM)
	lOpEncer   := IF(lOpEncer   == NIL, .F., lOpEncer)
	lEncerrOp  := lEncerrOp .And. !Empty(cOP)
	cCAT83     := IF(cCAT83     == NIL, "", cCAT83)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Caso nao exista as variaveis l380 e l381 | 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Type("l380") <> "L"
		l380 := .F.
	EndIf

	If Type("l381") <> "L"
		l381 := .F.
	EndIf

	// Verifica tipo de empenho a ser atualizado
	If !Empty(cOP)
		dbSelectArea("SC2")
		aAreaSC2:=GetArea()
		dbSetOrder(1)
		If dbSeek(xFilial()+cOP)
			cTpOp:=SC2->C2_TPOP
		EndIf
		RestArea(aAreaSC2)
	EndIf

	If !lEstorno
		If (Localiza(cProduto) .And. (lCriaSDC .Or. !Empty(cLocaliza) .Or. !Empty(cNumSerie))) .Or. (Rastro(cProduto) .And. (!Empty(cLoteCtl) .Or. !Empty(cNumLote)))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Faz FIFO Lote/Sub-Lote/Localizacao/Numero de Serie    ³
			//³ caso seja digitado na OP pelo menos um dos quatro ou  ³
			//³ caso seja empenho que nao esteja amarrado ao SD4      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aArray:=SldPorLote(cProduto,cLocal,nQtd,nQtd2UM,cLoteCtl,cNumLote,cLocaliza,cNumSerie,@aTravas,NIL,NIL,lConsVenc, , cTpOp=="P")
			For i:=1 to Len(aArray)
				If lGravaSD4
					// Gera registro do empenho no SD4
					A650ReplD4(cProduto,cLocal,dEntrega,aArray[i,5],cOp,cTrt,aArray[i,2],aArray[i,1],aArray[i,7],cOpOrig,aArray[i,6],aArray[i,12],lOpEncer,cCAT83)
				EndIf
				If lEmpSB2
					// Soma empenho no SB2
					dbSelectArea("SB2")
					MsGoto(aArray[i,8])
					GravaB2Emp("+",aArray[i,5],cTpOp,!Empty(cPedido).And.cOrigem!="SDD",aArray[i,6])
				EndIf
				// Caso utilize registros da Rastreabilidade soma empenho no SB8
				If lEmpSB8SBF
					dbSelectArea("SB8")
					For z:=1 to Len(aArray[i,10])
						MsGoto(aArray[i,10,z,1])
						GravaB8Emp("+",aArray[i,10,z,2],cTpOp,!Empty(cPedido).And.cOrigem!="SDD",aArray[i,10,z,3])
					Next z
					// Caso utilize registros da Localizacao Fisica soma empenho no SBF
					If aArray[i,9] > 0
						dbSelectArea("SBF")
						MsGoto(aArray[i,9])
						GravaBFEmp("+",aArray[i,5],cTpOp,!Empty(cPedido).And.cOrigem!="SDD",aArray[i,6])
						// Gera registro do empenho no SDC
						If lCriaSDC
							Reclock("SDC",.T.)
							Replace DC_FILIAL   With xFilial()
							Replace DC_ORIGEM   With cOrigem
							Replace DC_PRODUTO  With cProduto
							Replace DC_LOCAL    With cLocal
							Replace DC_LOTECTL  With aArray[i,1]
							If Rastro(cProduto,"S")
								Replace DC_NUMLOTE   With aArray[i,2]
							EndIf
							Replace DC_LOCALIZ  With aArray[i,3]
							Replace DC_NUMSERI  With aArray[i,4]
							Replace DC_QTDORIG  With Min(SD4->D4_QTDEORI,aArray[i,5])
							Replace DC_QUANT    With aArray[i,5]
							Replace DC_QTSEGUM  With ConvUM(SDC->DC_PRODUTO,aArray[i,5],aArray[i,6],2)
							Replace DC_OP       With cOp
							Replace DC_TRT      With cTrt
							If !lGravaSD4 .And. !Empty(cPedido)
								Replace DC_PEDIDO  With cPedido
								Replace DC_ITEM    With cItem
								Replace DC_SEQ  With cTrt
							EndIf
							SDC->DC_IDDCF := cIdDCF
							MsUnlock()
						EndIf
					EndIf
				EndIf
			Next i
		Else
			If lGravaSD4
				A650ReplD4(cProduto,cLocal,dEntrega,nQtd,cOp,cTrt,NIL,NIL,NIL,cOpOrig,nQtd2UM,NIL,lOpEncer,cCAT83)
			EndIf
			If lEmpSB2
				dbSelectArea("SB2")
				If !(B2_FILIAL+B2_COD+B2_LOCAL == xFilial()+cProduto+cLocal)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona SB2                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !dbSeek(xFilial()+cProduto+cLocal)
						CriaSB2(cProduto,cLocal)
					EndIf
				EndIf
				If nQtd > 0
					GravaB2Emp("+",nQtd,cTpOp,!Empty(cPedido).And.cOrigem!="SDD",nQtd2UM)
					If SB2->B2_QEMPN > 0 .And. !Empty(cPedido) .And. cOrigem <> "SDD" .And. ( lAtuSGJ <> NIL .And. !lAtuSGJ )
						nQtdAtEmpN := nQtd
						If ! SuperGetMv("MV_LIBACIM")
							dbSelectArea("SC6")
							aAreaSC6 := GetArea()
							dbSetOrder(1)
							MsSeek(xFilial("SC6")+cPedido+cItem+cProduto)
							nQtdDif := SC6->(C6_QTDVEN-C6_QTDENT) - nQtdAtEmpN
							// Indica liberacao acima do saldo do pedido e nao grava o excesso liberado em B2_QEMPN
							If QtdComp(nQtdDif) < QtdComp(0)
								nQtdAtEmpN += nQtdDif
							EndIf
							RestArea(aAreaSC6)
						EndIf
					Endif
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o B2_SALPED ou B2_SALPRE, somente se o produto ³
					//³ for negativo na estrutura. Caso nao tenha estrutura ou  ³
					//³ nao seja uma producao, nao executara a funcao GravaB2Pre³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If IsCompENeg(NIL,cProduto,cOp,.F.)
						GravaB2Pre("+",ABS(nQtd),cTpOp)
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		dbSelectArea("SB2")
		If !dbSeek(xFilial()+cProduto+cLocal)
			CriaSB2(cProduto,cLocal)
		EndIf
		If nQtd > 0
			If lEmpSB8SBF
				If Rastro(cProduto) .And. !Empty(cLoteCtl+cNumLote) .And. !(Localiza(cProduto))
					aArray:=SldPorLote(cProduto,cLocal,nQtd,nQtd2UM,cLoteCtl,cNumLote,,,,If(cPaisLoc=="BRA",.T.,lEmpSB8SBF),NIL,lConsVenc,NIL,cTpOp=="P")
					nQtd:=0
					nQtd2UM:=0
					For i:=1 to Len(aArray)
						dbSelectArea("SB8")
						For z:=1 to Len(aArray[i,10])
							nQtd+=aArray[i,10,z,2]
							nQtd2UM+=aArray[i,10,z,3]
						Next z
					Next i
				EndIf
				If !Empty(cLoteCtl+cNumLote) .And. Rastro(cProduto,"S")
					dbSelectArea("SB8")
					dbSetOrder(2)
					cSeek:=xFilial()+cNumLote+cLoteCtl+cProduto+cLocal
					If	dbSeek(cSeek)
						GravaB8Emp("-",nQtd,cTpOp,!Empty(cPedido).And.cOrigem!="SDD",nQtd2UM)
					EndIf
				ElseIf !Empty(cLoteCtl) .And. Rastro(cProduto,"L")
					dbSelectArea("SB8")
					dbSetOrder(3)
					cSeek:=xFilial()+cProduto+cLocal+cLoteCtl
					dbSeek(cSeek)
					nQuant:=nQtd
					nQuant2:=nQtd2UM
					Do While !Eof() .And. B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL == cSeek .And. nQuant > 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixa o empenho que conseguir neste lote   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cTpOp=="P"
							nBaixa:=Min(AvalQtdPre("SB8",1,NIL,NIL,.T.),nQuant)
							nBaixa2:=Min(AvalQtdPre("SB8",1,.T.,NIL,.T.),nQuant2)
						Else
							nBaixa:=Min(B8_EMPENHO,nQuant)
							nBaixa2:=Min(B8_EMPENH2,nQuant2)
						EndIf
						nQuant-=nBaixa
						nQuant2-=nBaixa2
						GravaB8Emp("-",nBaixa,cTpOp,!Empty(cPedido).And.cOrigem!="SDD",nBaixa2)
						dbSkip()
					EndDo
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento referente a localizacao fisica  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Localiza(cProduto) .And. lCriaSDC
					dbSelectArea("SDC")
					If !lGravaSD4
						dbSetOrder(1)
						cComparaLoc:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL+DC_NUMLOTE"
						cSeekLoc:=xFilial()+cProduto+cLocal+cOrigem+cPedido+cItem+cTrt+cLoteCtl+cNumLote
						If lSelLote
							cComparaLoc:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+DC_ITEM+DC_SEQ+DC_LOTECTL"
							cSeekLoc:=xFilial()+cProduto+cLocal+cOrigem+cPedido+cItem+cTrt+cLoteCtl
						EndIf
					Else
						dbSetOrder(2)
						cComparaLoc:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL+DC_NUMLOTE"
						cSeekLoc:=xFilial()+cProduto+cLocal+cOp+cTrt+cLoteCtl+cNumLote
						If lSelLote
							cComparaLoc:="DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_OP+DC_TRT+DC_LOTECTL"
							cSeekLoc:=xFilial()+cProduto+cLocal+cOp+cTrt+cLoteCtl
						EndIf
					EndIf
					dbSeek(cSeekLoc)
					nQuant:=nQtd
					nQuant2:=nQtd2UM
					Do While !Eof() .And. &cComparaLoc == cSeekLoc .And. nQuant > 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Limpa Registros com qtd zerada para comp. versoes ant.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (QtdComp(SDC->DC_QUANT) <= QtdComp(0)) .And. SDC->DC_ORIGEM $ "SC6/SL2"
							RecLock("SDC",.F.,.T.)
							dbDelete()
							MsUnLock()
							dbSkip()
							Loop
						EndIf
						nBaixa:=Min(nQuant,SDC->DC_QUANT)
						nBaixa2:=Min(nQuant2,SDC->DC_QTSEGUM)
						nQuant-=nBaixa
						nQuant2-=nBaixa2
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Retira empenho do SBF                                  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("SBF")
						dbSetOrder(1)
						If dbSeek(xFilial()+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO+SDC->DC_NUMSERI+SDC->DC_LOTECTL+SDC->DC_NUMLOTE)
							GravaBFEmp("-",nBaixa,cTpOp,!Empty(cPedido).And.cOrigem!="SDD",nBaixa2)
						EndIf
						dbSelectArea("SDC")
						If If(lEncerrOp,(nBaixa <= SDC->DC_QUANT),(nBaixa < SDC->DC_QUANT))
							RecLock("SDC",.F.)
							Replace DC_QUANT With SDC->DC_QUANT - nBaixa
							Replace DC_QTSEGUM With ConvUM(SDC->DC_PRODUTO, SDC->DC_QUANT - nBaixa, 0, 2)
						ElseIf !lEncerrOp
							RecLock("SDC",.F.,.T.)
							dbDelete()
						EndIf
						MsUnLock()
						dbSkip()
					EndDo
				EndIf
			EndIf
			If lEmpSB2
				GravaB2Emp("-",nQtd,cTpOp,!Empty(cPedido).And.cOrigem!="SDD",nQtd2UM)
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o B2_SALPED ou B2_SALPRE, somente se o produto ³
			//³ for negativo na estrutura. Caso nao tenha estrutura ou  ³
			//³ nao seja uma producao, nao executara a funcao GravaB2Pre³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If IsCompENeg(NIL,cProduto,cOp,.F.)
				GravaB2Pre("-",ABS(nQtd),cTpOp)
			EndIf
		EndIf
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Remove travas dos registros utilizados                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MaDesTrava(aTravas)
	RestArea(aArea)
Return aArray

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RetEmpOS  ³ Autor ³ Microsiga             ³ Data ³ 20/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a quantidade do produto a ser separada na Ordem de  ³±±
±±³          ³ Separacao                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetEmpOS(lConsEst,cProdEmp,nQtdEmp)
	Local nPos

	If !lConsEst
		Return nQtdEmp
	Endif

	nPos := Ascan(aEmp,{|x| x[02] == cProdEmp})

Return aEmp[nPos,07]

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RetEmpOS  ³ Autor ³ Microsiga             ³ Data ³ 20/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a quantidade do produto a ser separada na Ordem de  ³±±
±±³          ³ Separacao                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RetItemCB8(cOrdSep,aItemCB8)
	Local nPos := Ascan(aItemCB8,{|x| x[1] == cOrdSep})
	If Empty(nPos )
		AAdd(aItemCB8,{cOrdSep,0})
		nPos := len(aItemCB8)
	EndIF
	aItemcb8[nPos,2]++
Return StrZero(aItemcb8[nPos,2],2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RetSldEnd ³ Autor ³ Microsiga                                                        ³ Data ³ 09/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os saldos disponiveis nos enderecos:                                                           ³±±
±±³          ³ - Quando produto com apropriacao INDIRETA, disconsidera o saldo de Ordens de Separacao ainda nao sepa- ³±±
±±³          ³   radas;                                                                                               ³±±
±±³          ³ - Quando produto com apropriacao DIRETA, disconsidera apenas o saldo nao separado do item atual;       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetSldEnd(cProd,lRetSaldo,aVarAlt)
	Local aArea     := GetArea()
	Local aAreaSBF  := SBF->(GetArea())
	Local cArmProc  := "02" //GetMV("MV_LOCPROC") paulo
	Local nSaldoAtu := 0
	Local nSaldoCB8 := 0
	Local nSaldoSBF := 0
	Local aSaldoSBF := {}
	Local cQuerySBF
	Local lQuery    :=.F.
	Local cAliasSBF := "SBF"
	Local lACD100END                 

	Local cTM       := GetMV("MV_CBREQD3")
	Local lApropInd := CBArmProc(cProd,cTM)

	LocaL cArmOri    
	Local cEndOri    
	Local cLoteOri   
	Local cSLoteOri  
	Local cNumSerOri          
	Local nSldSepOri
	Local lExec001 := ExistBlock("ACD100END")

	If aVarAlt<>NIL
		cArmOri    := aVarAlt[1]
		cEndOri    := aVarAlt[2]
		cLoteOri   := aVarAlt[3]
		cSLoteOri  := aVarAlt[4]
		cNumSerOri := aVarAlt[5]
		nSldSepOri := aVarAlt[6]
	EndIf

	lQuery    :=.T.
	cQuerySBF := "SELECT * FROM " + RetSqlName("SBF")
	cQuerySBF += " WHERE BF_PRODUTO = '" + cProd + "' AND "
	cQuerySBF += " BF_FILIAL = '" + xFilial("SBF") + "' AND "
	cQuerySBF += RetSQLName("SBF") + ".D_E_L_E_T_ <> '*'"
	cQuerySBF += " ORDER BY BF_PRODUTO,BF_LOCAL,BF_LOTECTL,BF_NUMLOTE"
	cQuerySBF := ChangeQuery( cQuerySBF )
	TCQUERY cQuerySBF NEW ALIAS "SBFTMP"
	dbSelectArea("SBFTMP")
	cAliasSBF := "SBFTMP"

	While (cAliasSBF)->(!Eof() .AND. BF_FILIAL+BF_PRODUTO == xFilial("SBF")+cProd)
		If (cAliasSBF)->BF_LOCAL == cArmProc
			(cAliasSBF)->(DbSkip())
			Loop
		Endif
		If lExec001
			lACD100END := ExecBlock("ACD100END",.F.,.F.,{(cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_PRODUTO,(cAliasSBF)->BF_NUMSERI,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE})
			lACD100END := If(ValType(lACD100END)=="L",lACD100END,.T.)
			If !lACD100END
				(cAliasSBF)->(DbSkip())
				Loop
			Endif
		Endif
		If lApropInd
			nSaldoAtu := (cAliasSBF)->(SaldoSBF(BF_LOCAL,BF_LOCALIZ,BF_PRODUTO,BF_NUMSERI,BF_LOTECTL,BF_NUMLOTE))
			nSaldoCB8 := (cAliasSBF)->(RetSldCB8(BF_PRODUTO,BF_LOCAL,BF_LOCALIZ,BF_NUMSERI,BF_LOTECTL,BF_NUMLOTE))
			If (nSaldoAtu-nSaldoCB8) > 0
				nSaldoSBF += (nSaldoAtu-nSaldoCB8)
				aadd(aSaldoSBF,{(cAliasSBF)->BF_PRODUTO,(cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,(cAliasSBF)->BF_NUMSERI,(nSaldoAtu-nSaldoCB8)})
			Endif
		Else                                                                                                        
			nSaldoAtu := (cAliasSBF)->(SaldoSBF(BF_LOCAL,BF_LOCALIZ,BF_PRODUTO,BF_NUMSERI,BF_LOTECTL,BF_NUMLOTE))
			If aVarAlt<> NIL .and. (cProd+cArmOri+cEndOri+cLoteOri+cSLoteOri+cNumSerOri) == (cAliasSBF)->(BF_PRODUTO+BF_LOCAL+BF_LOCALIZ+BF_LOTECTL+BF_NUMLOTE+BF_NUMSERI)
				//Se a chave SBF corresponder a chave do CB8, permitir que o usuario possa seleciona-la com o saldo a ser separado:
				nSaldoAtu := nSldSepOri
			Endif                                                                        

			If nSaldoAtu > 0
				nSaldoSBF += nSaldoAtu
				aadd(aSaldoSBF,{(cAliasSBF)->BF_PRODUTO,(cAliasSBF)->BF_LOCAL,(cAliasSBF)->BF_LOCALIZ,(cAliasSBF)->BF_LOTECTL,(cAliasSBF)->BF_NUMLOTE,(cAliasSBF)->BF_NUMSERI,nSaldoAtu})
			Endif
		Endif
		(cAliasSBF)->(DbSkip())
	Enddo
	If lQuery
		(cAliasSBF)->( DbCloseArea() )
	Endif
	aSort(aSaldoSBF,,,{|x,y| x[01]+x[02]+x[03]+x[04]+x[05]+x[06]<y[01]+y[02]+y[03]+y[04]+y[05]+y[06]})

	RestArea(aAreaSBF)
	RestArea(aArea)
Return If(lRetSaldo,nSaldoSBF,aSaldoSBF)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RetSldCB8 ³ Autor ³ Microsiga             ³ Data ³ 13/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna os saldos que ainda nao foram separados nas OS      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RetSldCB8(cProd,cLocal,cLocaliz,cNumSerie,cLote,cSubLote)
	Local aArea     := GetArea()
	Local aAreaCB7  := CB7->(GetArea())
	Local nSaldoCB8 := 0

	cQueryCB8 := "SELECT SUM(CB8_SALDOS) AS SALDOSEP FROM " + RetSqlName("CB7") + " CB7, " + RetSqlName("CB8") + " CB8"
	cQueryCB8 += " WHERE CB7.CB7_ORDSEP = CB8.CB8_ORDSEP AND CB7.CB7_OP <> '' AND CB7.CB7_REQOP <> '1' AND"
	cQueryCB8 += " CB8.CB8_LOCAL = '" + cLocal + "' AND CB8.CB8_LCALIZ = '" + cLocaliz + "' AND"
	cQueryCB8 += " CB8.CB8_NUMSER = '" + cNumSerie + "' AND CB8.CB8_LOTECT = '" + cLote + "' AND CB8.CB8_NUMLOT = '" + cSubLote + "' AND"
	cQueryCB8 += " CB8.CB8_PROD = '" + cProd + "' AND CB8.CB8_SALDOS > 0 AND"
	cQueryCB8 += " CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND CB8.CB8_FILIAL = '" + xFilial("CB8") + "' AND "
	cQueryCB8 += " CB7.D_E_L_E_T_ <> '*' AND CB8.D_E_L_E_T_ <> '*'"
	cQueryCB8 := ChangeQuery( cQueryCB8 )
	TCQUERY cQueryCB8 NEW ALIAS "CB8TMP"
	dbSelectArea("CB8TMP")
	CB8TMP->(DbGoTop())
	If CB8TMP->(!Eof())
		nSaldoCB8 := CB8TMP->SALDOSEP
	Endif
	CB8TMP->( DbCloseArea() )

	RestArea(aAreaCB7)
	RestArea(aArea)
Return nSaldoCB8

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ ExpExcel  ³ Autor ³ Microsiga             ³ Data ³ 13/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exporta para o excel simulacao                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExpExcel()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cLin
	local cDirDocs  := MsDocPath()
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "SIMUL_SEPARACAO.CSV"
	Local oExcelApp
	Local Kx		:= 0	
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"


	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("Não foi possível abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	//CABECALOS ESTATISTICAS ENDERECOS
	cLin := "SIMULACAO SEPARACAO"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		//ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin    :=  OemToAnsi("Código")+';'+OemToAnsi("Descricao")+';'+OemToAnsi("Empenho")+';'+OemToAnsi("Sld.Atual")+';'+OemToAnsi("Reserva")+';'+OemToAnsi("Sld.Disp.")+';'+OemToAnsi("Sld.CQ.")+';'+OemToAnsi("Sld.Recebimento")+';'+OemToAnsi("Ped.Venda")+';'+OemToAnsi("Lote Repos.")+';'+OemToAnsi("Fornecedor")
	cLin += cEOL //ULTIMO ITEM

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		//ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(a2ItOPs))

	//a2ItOPs {01-COR, 02-OP, 03-COD PROD, 04-DESCRICAO, 05-QTDEMP, 06-QTDE OPS, 07-SALDO DISP., 08-SALDO CLASS.,09-SALDO CQ,10-LSEPARA}
	For Kx:=1 To Len(a2ItOPs)
		If a2ItOPs[Kx][10]
			IncProc("Aguarde......Montando Planilha!")
			//PEGA DADOS ESTOQUE
			dbSelectArea("SB2")
			dbSetOrder(1)
			dbSeek(xFilial()+a2ItOPs[Kx][3]+cArmOri)
			nReserva := SB2->B2_RESERVA
			nSldDisp := SB2->B2_QATU-SB2->B2_RESERVA
			nPedVen  := SB2->B2_QPEDVEN
			//BUSCA FORNECEDOR
			dbSelectArea("SA5")
			dbSetOrder(2)
			dbSeek(xFilial("SA5")+a2ItOPs[Kx][3])

			cFornece := Posicione("SA2",1,xFilial("SA2")+SA5->A5_FORNECE+SA5->A5_LOJA,"A2_NOME") 

			cLin    := ''
			cLin    += a2ItOPs[Kx][3]+';'+a2ItOPs[Kx][4]+';'+Transform(a2ItOPs[Kx][5],'@E 9999999')+';'+Transform(a2ItOPs[Kx][7],'@E 9999999')+';'+Transform(nReserva,'@E 9999999')+';'+Transform(nSldDisp,'@E 9999999')+';'+Transform(a2ItOPs[Kx][9],'@E 9999999')+';'+Transform(a2ItOPs[Kx][8],'@E 9999999')+';'+Transform(nPedVen,'@E 9999999')+';'+Transform(0,'@E 9999999')+';'+cFornece

			//PULA LINHA
			cLin += cEOL

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
			//³ linha montada.                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				//ConOut("Ocorreu um erro na gravacao do arquivo.")
				fClose(nHdl)
				Return
			Endif
		EndIf
	Next

	//PULA LINHA
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		//ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	fClose(nHdl)

	CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cPath+cArquivo,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

Return




