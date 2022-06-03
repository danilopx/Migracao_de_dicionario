#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFAT009  ³ Autor ³ Richard Nahas Cabral  ³ Data ³12/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Importação da planilha Excel para geração das Metas de     ³±±
±±³          ³ Vendas                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT009

	Local 	oDlg, oDlg1, oBold, lContinua
	Private	cArqCSV, cMes, cAno

	Do While .T.
		cArqCSV := Space(40)
		lContinua := .F.
		cMes := StrZero(Month(dDataBase),2)
		cAno := StrZero(Year(dDataBase),4)

		DEFINE MSDIALOG oDlg1 FROM 096,042 TO 343,520 TITLE "Importação Metas de Vendas" PIXEL
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

		@ 1,1 SAY "Importação Metas de Vendas - As metas serão importadas do arquivo selecionado."  of oDlg
		@ 3,05 Get cArqCSV Size 175,10 When .F.

		@ 030,025 TO 055,225 LABEL "Arquivo Selecionado" PIXEL

		@ 060,025 TO 090,225 LABEL "Mês / Ano" PIXEL
		@ 070,040 MSGET oMes VAR cMes PICTURE "99"   VALID ! Empty(cMes) Size 20,10 PIXEL
		@ 070,070 MSGET oAno VAR cAno PICTURE "9999" VALID ! Empty(cAno) Size 40,10 PIXEL

		@ 100,040 BUTTON "Arquivo"		SIZE 55 ,15   		FONT oDlg1:oFont  OF oDlg1 PIXEL ACTION (cArqCSV := cGetFile("Arquivo Comma Separated Value (*.CSV) |*.CSV", "Escolha o Arquivo de Planilhas",,,.T.))
		@ 100,100 BUTTON "Ok"			SIZE 55 ,15   		FONT oDlg1:oFont  OF oDlg1 PIXEL ACTION (lContinua := .T.,ODlg1:End())
		@ 100,160 BUTTON "Cancela" 		SIZE 55 ,15   		FONT oDlg1:oFont  OF oDlg1 PIXEL ACTION (lContinua := .F.,ODlg1:End())

		ACTIVATE MSDIALOG oDlg1 CENTERED

		If ! lContinua
			Return Nil

		ElseIf lContinua .And. Empty(cArqCSV)
			MsgAlert("Arquivo Invalido.","Escolha o Arquivo Correto.")

		ElseIf lContinua .And. FT_FUSE(cArqCSV) == -1
			MsgAlert("Falha na abertura do arquivo.","Verifique se o mesmo não está em uso.")

		ElseIf lContinua
			Exit

		Endif

	EndDo

	If MsgYesNo("Confirma importação da planilha ?")
		PROCESSA({|| Processar()})
	EndIf

Return Nil

Static Function Processar()

	Local cLinha
	Local aColsLinha := {}
	Local nX := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faco a abertura do arquivo de produtos.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUSE( cArqCSV )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Avanco para a primeira linha.                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FGOTOP()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrego todos os registros do TXT para o aCols.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do While !FT_FEOF()

		cLinha := FT_FREADLN() //Leitura da linha

		aAdd(aColsLinha, cLinha )

		FT_FSKIP()
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faco o fechamento do arquivo em uso.                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUSE()

	ProcRegua(Len(aColsLinha))

	aMeses := {}

	Aadd(aMeses,"Janeiro")
	Aadd(aMeses,"Fevereiro")
	Aadd(aMeses,"Marco")
	Aadd(aMeses,"Abril")
	Aadd(aMeses,"Maio")
	Aadd(aMeses,"Junho")
	Aadd(aMeses,"Julho")
	Aadd(aMeses,"Agosto")
	Aadd(aMeses,"Setembro")
	Aadd(aMeses,"Outubro")
	Aadd(aMeses,"Novembro")
	Aadd(aMeses,"Dezembro")

	aCampos := {}

	Aadd(aCampos,{"Gerente","CT_GERENTE"})
	Aadd(aCampos,{"Vendedor","CT_VEND"})
	Aadd(aCampos,{"Grupo Clientes","CT_GRPVEN"})
	Aadd(aCampos,{"Cliente","CT_CLIENTE"})
	Aadd(aCampos,{"Categoria","CT_CATEGO"})
	Aadd(aCampos,{"Produto","CT_PRODUTO"})
	Aadd(aCampos,{"Preco Medio","CT_PRMED"})
	Aadd(aCampos,{"Custo Produto","CT_CSTMED"})
	Aadd(aCampos,{"Janeiro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Janeiro Valor","CT_VALOR"})
	Aadd(aCampos,{"Fevereiro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Fevereiro Valor","CT_VALOR"})
	Aadd(aCampos,{"Marco Qtde","CT_QUANT"})
	Aadd(aCampos,{"Marco Valor","CT_VALOR"})
	Aadd(aCampos,{"Abril Qtde","CT_QUANT"})
	Aadd(aCampos,{"Abril Valor","CT_VALOR"})
	Aadd(aCampos,{"Maio Qtde","CT_QUANT"})
	Aadd(aCampos,{"Maio Valor","CT_VALOR"})
	Aadd(aCampos,{"Junho Qtde","CT_QUANT"})
	Aadd(aCampos,{"Junho Valor","CT_VALOR"})
	Aadd(aCampos,{"Julho Qtde","CT_QUANT"})
	Aadd(aCampos,{"Julho Valor","CT_VALOR"})
	Aadd(aCampos,{"Agosto Qtde","CT_QUANT"})
	Aadd(aCampos,{"Agosto Valor","CT_VALOR"})
	Aadd(aCampos,{"Setembro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Setembro Valor","CT_VALOR"})
	Aadd(aCampos,{"Outubro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Outubro Valor","CT_VALOR"})
	Aadd(aCampos,{"Novembro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Novembro Valor","CT_VALOR"})
	Aadd(aCampos,{"Dezembro Qtde","CT_QUANT"})
	Aadd(aCampos,{"Dezembro Valor","CT_VALOR"})

	cCabecalho := aColsLinha[1]
	aCabec := {}
	Do While .T.
		nPosVirgula := At(";",cCabecalho)
		If nPosVirgula > 0
			cCampo := Substr(cCabecalho,1,nPosVirgula-1)
			Aadd(aCabec,cCampo)
			cCabecalho := Substr(cCabecalho, nPosVirgula+1)
		Else
			Exit
		Endif
	EndDo

	cRevisao := "01"

	Do While .T.
		cDocumento := cAno+cMes+"-"+cRevisao
		If ! SCT->(DbSeek(xFilial("SCT")+cDocumento))
			Exit
		Else
			cRevisao := Soma1(cRevisao)
		Endif

	EndDo

	SX3->(DbSetOrder(2))

	cSeq := "000"
	For nX := 2 to Len(aColsLinha)
		cDetalhe := aColsLinha[nX]
		cSeq := Soma1(cSeq)
		nCampo := 0

		IncProc("Gerando Metas de Vendas - " + cMes + "/" + cAno + " - Revisao " + cRevisao)
		RecLock("SCT",.T.)
		SCT->CT_FILIAL	:= xFilial("SCT")
		SCT->CT_DOC		:= cDocumento
		SCT->CT_SEQUEN	:= cSeq
		SCT->CT_DESCRI	:= "METAS DE VENDAS - " + cMes + "/" + cAno + " - REV. " + cRevisao
		SCT->CT_DATA	:= LastDay(StoD(cAno+cMes+"01"))
		SCT->CT_MOEDA	:= 1

		Do While .T.
			nCampo ++
			nPosVirgula := At(";",cDetalhe)
			If nPosVirgula > 0
				cCampo := If(nPosVirgula = 1,"",Substr(cDetalhe,1,nPosVirgula-1))
				cDetalhe := Substr(cDetalhe, nPosVirgula+1)
				cPrimPalav := Substr(aCabec[nCampo],1,At(" ",aCabec[nCampo])-1)
				If ! ( Ascan(aMeses,cPrimPalav) > 0 .And. Strzero(Ascan(aMeses,cPrimPalav),2) <> cMes )
					nPosaCampos := Ascan(aCampos, {|x| x[1] = aCabec[nCampo]})
					If nPosaCampos > 0 .And. ! Empty(cCampo)
						cCpoTab := aCampos[nPosaCampos,2]
						SX3->(DbSeek(cCpoTab))
						Do Case

						Case Alltrim(cCpoTab) $ "CT_GERENTE,CT_VEND,CT_GRPVEN,CT_CATEGO"
							SCT->&(cCpoTab) := Substr(cCampo,2,6)

/*
						Case cCpoTab = "CT_GERENTE"
							SCT->CT_GERENTE	:= Substr(cCampo,2,6)
						Case cCpoTab = "CT_VEND"
							SCT->CT_VEND	:= Substr(cCampo,2,6)
						Case cCpoTab = "CT_GRPVEN"
							SCT->CT_GRPVEN	:= Substr(cCampo,2,6)
						Case cCpoTab = "CT_CATEGO"
							SCT->CT_CATEGO	:= Substr(cCampo,2,6)
*/

						Case cCpoTab = "CT_CLIENTE"
							SCT->CT_CLIENTE	:= Substr(cCampo,2,6)
							SCT->CT_LOJA 	:= Substr(cCampo,9,2)
						Case cCpoTab = "CT_PRODUTO"
							SCT->CT_PRODUTO	:= Substr(cCampo,2,15)
						Case SX3->X3_TIPO = "N"
							SCT->&(cCpoTab) := Val(StrTran(cCampo,",","."))
						OtherWise
							SCT->&(cCpoTab) := cCampo
						EndCase
					EndIf
				EndIf
			Else
				Exit
			Endif
		EndDo

		MsUnlock()

	Next nX
/*
SCT->(DbSeek(xFilial("SCT")+cDocumento))

	Do While SCT->(CT_FILIAL + CT_DOC) = xFilial("SCT")+cDocumento .And. ! SCT->(Eof())

		If SCT->CT_QUANT > 0 .Or. SCT->CT_VALOR > 0
		SCT->(DbSkip())
		Loop
		Endif

	cGerente	:= SCT->CT_GERENTE					// Gerente
	cVendedor	:= SCT->CT_VEND						// Vendedor
	cGrupoCli	:= SCT->CT_GRPVEN					// Grupo de Cliente
	cCliente	:= SCT->CT_CLIENTE					// Cliente
	cLojaCli	:= SCT->CT_LOJA						// Loja Cliente
	cProduto	:= SCT->CT_PRODUTO					// Produto
	cCateg		:= SCT->CT_CATEGO					// Categoria do Produto	

	cAliasSCT := GetNextAlias()

	cQuery := "SELECT SUM(CT_QUANT) AS CT_QUANT, SUM(CT_VALOR) AS CT_VALOR FROM " + RetSqlName("SCT") + " SCT "
	cQuery += "WHERE	CT_FILIAL	 = '" + xFilial("SCT")	+ "'  "
	cQuery += "AND		CT_DOC		 = '" + cDocumento		+ "'  "
	cQuery += "AND 		CT_GERENTE	 = '" + cGerente		+ "'  "
	cQuery += "AND		CT_VEND		 = '" + cVendedor		+ "'  "
	cQuery += "AND 		CT_GRPVEN	 = '" + cGrupoCli		+ "'  "
//	cQuery += "AND 		CT_CLIENTE	 = '" + cCliente		+ "'  "
//	cQuery += "AND 		CT_LOJA		 = '" + cLojaCli		+ "'  "
//	cQuery += "AND 		CT_PRODUTO	 = '" + cProduto		+ "'  "
	cQuery += "AND 		CT_CATEGO LIKE '" + Alltrim(cCateg) + "%' "
	cQuery += "AND D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCT,.T.,.T.)

	RecLock("SCT",.F.)
		If ( cAliasSCT )->(CT_QUANT) = 0 .And. ( cAliasSCT )->(CT_VALOR) = 0
//		SCT->(DbDelete())
		Else
		SCT->CT_QUANT := ( cAliasSCT )->(CT_QUANT)
		SCT->CT_VALOR := ( cAliasSCT )->(CT_VALOR)
		Endif
	SCT->(MsUnLock())

	( cAliasSCT )->( dbCloseArea() )

	SCT->(DbSkip())

	EndDo
*/
	SCT->(DbSeek(xFilial("SCT")+cDocumento))

	MsgAlert("Gerado Documento " + cDocumento + " com sucesso !!!")

Return
