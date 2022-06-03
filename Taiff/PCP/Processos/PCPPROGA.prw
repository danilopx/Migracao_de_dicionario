#Include 'Protheus.ch'
#include "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE 'TOPCONN.CH'
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: PCPPROGA     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 24/04/2017   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para registrar o programa de produção 
//+--------------------------------------------------------------------------------------------------------------

User Function PCPPROGA()
	Local aRotAdic :={}

	aadd(aRotAdic,{ "Exporta","U_EXPPCPPROGRAMA", 0 , 6 })
	aadd(aRotAdic,{ "Importa","U_IMPPCPPROGRAMA", 0 , 6 })
	AxCadastro("ZAT","Programa de Produção","U_EXCLZAT()","U_MUDAZAT()", aRotAdic ) //, bPre, bOK, bTTS, bNoTTS, , , aButtons, , )

Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alterção da tabela ZAT
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAT()
	Local lRetorno		:= .T.
	Local aParamBox	:= {}
	Local cIDproduto	:= M->ZAT_COD
	Local cDataZat		:= M->ZAT_DATA

	Private cCadastro := "Senha de acesso"
	Private cString := ""
	Aadd(aParamBox,{8,"Senha: "	,Space(06),"","","","",50,.T.})

	If At(  Alltrim(__CUSERID)  , GetNewPar("TF_PCPPROG","001345;000348") ) = 0
		lRetorno := .F.
		Aviso("Programa de Produção", "Acesso não permitido!" + chr(13) + chr(10) + "Verifique conteúdo do parâmetro TF_PCPPROG.",	{"Ok"}, 	3)
	Else
		If INCLUI
			ZAT->(DBORDERNICKNAME("PRODUTO"))
			If ZAT->(DbSeek( xFilial("ZAT") + cIDproduto + DTOS(cDataZat) ))
				lRetorno := .F.
				Aviso("Programa de Produção", "Inclusão não permitida!" + chr(13) + chr(10) + "Programação do Produto já cadastrado na data.",	{"Ok"}, 	3)
			EndIf
		Endif
		If ALTERA
		EndIf
	EndIf
Return lRetorno

//+--------------------------------------------------------------------------------------------------------------
//| Função Exclusão da tabela ZAT
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAT()
	Local lRetorno := .F.
	Local __cMensagem := "Deseja realmente excluir esta programação?"
	If At(  Alltrim(__CUSERID)  , GetNewPar("TF_PCPPROG","001345;000348") ) = 0
		lRetorno := .F.
		Aviso("Programa de Produção", "Acesso não permitido!" + chr(13) + chr(10) + "Verifique conteúdo do parâmetro TF_PCPPROG.",	{"Ok"}, 	3)
	Else
		If MsgYesNo(  __cMensagem  ,"Programa de Produção")
			lRetorno := .T.
		EndIf
	EndIf
Return lRetorno



//+--------------------------------------------------------------------------------------------------------------
//| Exporta para Excel
//+--------------------------------------------------------------------------------------------------------------
User Function EXPPCPPROGRAMA()
	Local cDataPrograma := ZAT->ZAT_DATA
	Local nZATRecno := ZAT->(Recno())
	Local n := 0

	Private cArqTxt := "C:\TEMP\PCP_PROGRAMA.CSV"
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"


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
		MsgAlert("O arquivo de nome "+cArqTxt+" esta em uso ou com probelmas! Verifique os parametros.","Atencao!")
		Return
	Endif

	DBSELECTAREA("ZAT")

	For n := 1 to FCount()
		aTam := TamSX3(FieldName(n))
	Next

	cLin    := ''
	For n := 1 to FCount()
		cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))

		IF n == FCount()
			cLin += cEOL
		Else
			cLin += ';'
		EndIf
	Next

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	ZAT->(DBORDERNICKNAME("PREVISAO"))
	ZAT->(DbSeek( xFilial("ZAT") + DTOS(cDataPrograma) ))
	While !ZAT->(Eof()) .AND. ZAT->ZAT_FILIAL= xFilial("ZAT") .AND. ZAT->ZAT_DATA=cDataPrograma

		IncProc("Processando Aguarde...")

		cLin    := ''
		For n := 1 to FCount()
			cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
			cLin += IIF(n == FCount(),cEOL,';')
		Next

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif

		ZAT->(dbSkip())
	End

	fClose(nHdl)
	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cArqTxt,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	oExcelApp:Quit()
	oExcelApp:Destroy()

	ZAT->(DbGoto(nZATRecno))

	MsgAlert("O arquivo " + cArqTxt + " foi gerado com sucesso.","Atencao!")

Return


//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alterção da tabela ZAT
//+--------------------------------------------------------------------------------------------------------------
User Function IMPPCPPROGRAMA()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oListBox
	Local lContinua := .T.
	Local nOpc		:= 0
	Local oBmp1, oBmp2
	Local cPerg2
	Local lNew := .F.
	Local nLinhasXls := 0
	Local z := 0

	Private aDados	:= {}
	Private oDlgProdutos


	If At(  Alltrim(__CUSERID)  , GetNewPar("TF_PCPPROG","001345;000348") ) = 0
		Aviso("Programa de Produção", "Acesso não permitido!" + chr(13) + chr(10) + "Verifique conteúdo do parâmetro TF_PCPPROG.",	{"Ok"}, 	3)
		return
	EndIf

	cPerg2 := 'IMPPCPPR'

	Pergunta2(cPerg2)

	cArquivo := RunDlg()

	If Empty(cArquivo)
		MsgStop('Informe o Nome do Arquivo Padrao Texto!')
		Return
	Endif

	If !Pergunte(cPerg2,.T.)
		Return
	Endif


	If Empty(MV_PAR01)
		MsgStop('Informe a Coluna da Tabela!')
		Return
	Endif

	If Empty(MV_PAR02)
		MsgStop('Informe a Coluna do Produto!')
		Return
	Endif

	If Empty(MV_PAR03)
		MsgStop('Informe a Coluna do Preco Cheio!')
		Return
	Endif

	If Empty(MV_PAR04)
		MsgStop('Informe a Coluna do Desconto!')
		Return
	Endif

	If Empty(MV_PAR05)
		MsgStop('Informe o Caracter de Separacao. Exemplo ";" !')
		Return
	Endif

	private cArq  :=''
	private cArq2 :=''

	if msgYesNo("Confirma a Importacao do Arquivo "+Alltrim(cArquivo)+", para análise ?")

		CriaDbf2()
		DbSelectArea('TAB')
		append from &cArquivo sdf
		dbGoTop()
		ProcRegua(RecCount())
		_nCont := 0
		nLinhasXls := 0
		do while TAB->(!eof())
			nLinhasXls += 1
			IncProc()
			If Empty(CAMPO) .OR. (nLinhasXls=1 .AND. MV_PAR06=1)
				DbSkip()
				Loop
			Endif
			lNew := .F.
			cTabela := StrZero(Val(AllTrim(ProcCol(MV_PAR01,CAMPO))),2)

			_cProduto := Iif( Len(AllTrim(ProcCol(MV_PAR02,CAMPO)))>9,AllTrim(ProcCol(MV_PAR02,CAMPO)),StrZero(Val(AllTrim(ProcCol(MV_PAR02,CAMPO))),9))

			_cProduto := SUBSTR(ALLTRIM(_cProduto) + SPAC(15),1,15)

			nPreco  := 0
			cPreco	:= ProcCol(MV_PAR03,CAMPO)
			cPreco 	:= StrTran(cPreco,".","")
			cPreco 	:= StrTran(cPreco,",",".")
			nPreco  := Val(cPreco)

			If 1=2 //nPreco == 0
				MsgAlert("O Produto "+_cProduto+" com Quantidade ZERO e não será importado","Atenção - PCPPROGRA")
				dbSelectArea("TAB")
				dbSkip()
				Loop
			EndIf

			cDesc	:= ProcCol(MV_PAR04,CAMPO)
			cDesc	:= CTOD(cDesc)

			ZAT->(DBORDERNICKNAME("PRODUTO"))
			If ZAT->(DbSeek( xFilial("ZAT") + _cProduto + DTOS(cDesc) ))
				lNew := .F.
			Else
				lNew := .T.
			EndIf

			dbSelectArea("SB1")
			dbSetOrder(1)
			If !dbSeek(xFilial()+_cProduto)
				MsgAlert("O Produto "+_cProduto+" não foi encontrado no cadastro de produto e não será importado","Atenção - COMI01IP")
				dbSelectArea("TAB")
				dbSkip()
				Loop
			EndIf
			lContinua := .T.
			If lContinua
				//01-LEGENDA, 02- OK, 03- FORNECEDOR, 04- LOJA, 05 - TABELA, 06-PRODUTO, 07-DESCRICAO, 08-MARCA, 09- PRECO CHEIO, 10-%DESCONTO
				//aAdd(aDados,{Iif(lNew,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_BRANCO")),.F.,cFornece, cLoja,cTabela, _cProduto,SB1->B1_DESC, SB1->B1_PYNFORN,nPreco,nDesc})
				aAdd(aDados,{Iif(lNew,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_BRANCO")),.F.,cTabela, _cProduto,SB1->B1_DESC, SB1->B1_ITEMCC,nPreco,cDesc})
			EndIf
			dbSelectArea("TAB")
			dbSkip()
		End
		dbSelectArea("TAB")
		dbCloseArea()
		if file(cArq2+".DBF")
			fErase(cArq2+".DBF")
		endif

		If Len(aDados) == 0
			MsgStop("Não existem dados para este relatório!","Atenção")
			Return
		EndIf
		//MONTA O CABECALHO
		cFields := " "
		nCampo 	:= 0

		aTitCampos := {" "," ",OemToAnsi("Filial"),OemToAnsi("Produto"),OemToAnsi("Descrição"),OemToAnsi("Marca"),OemToAnsi("Quantidade"),OemToAnsi("Data")}

		cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
		cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],}"


		bLine := &( "{ || " + cLine + " }" )

		@ 100,005 TO 550,950 DIALOG oDlgProdutos TITLE "Produtos"

		oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,,oDlgProdutos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aDados)
		oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := !aDados[oListBox:nAt,2] }


		oListBox:bLine := bLine

		@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgProdutos
		@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgProdutos

		@ 183,110 BUTTON "Atualizar"  SIZE 40,15 ACTION {nOpc :=1,oDlgProdutos:End()}  PIXEL OF oDlgProdutos
		@ 183,160 BUTTON "Sair"       SIZE 40,15 ACTION {nOpc :=0,oDlgProdutos:End()} PIXEL OF oDlgProdutos

		@ 205,005 BITMAP oBmp1 ResName "BR_VERDE" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
		@ 205,015 SAY "Novo Item" OF oDlgProdutos Color CLR_BLUE,CLR_BLACK PIXEL

		@ 205,065 BITMAP oBmp2 ResName "BR_BRANCO" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
		@ 205,075 SAY "Item a Alterar" OF oDlgProdutos Color CLR_BLACK,CLR_WHITE PIXEL

		ACTIVATE DIALOG oDlgProdutos CENTERED

	Endif

//ATUALIZA OS ITENS
	If nOpc == 1
		For z:=1 To Len(aDados)
			If aDados[z][2]
				dbSelectArea("ZAT")
				ZAT->(DBORDERNICKNAME("PRODUTO"))
				If ZAT->(DbSeek( xFilial("ZAT") + aDados[z][4] + DTOS(aDados[z][8]) ))
					ZAT->(RecLock("ZAT",.F.))
					ZAT->ZAT_QUANT := aDados[z][7]
					ZAT->(MsUnlock())
				Else
					ZAT->(RecLock("ZAT",.T.))
					ZAT->ZAT_FILIAL 	:= xFilial("ZAT")
					ZAT->ZAT_COD		:= aDados[z][4]
					ZAT->ZAT_DATA		:= aDados[z][8]
					ZAT->ZAT_QUANT 	:= aDados[z][7]
					ZAT->(MsUnlock())
				EndIf
			EndIf
		Next
	EndIf

Return

//+--------------------------------------------------------------------------------------------------------------
//| Função Perguntas da Importação do Excel
//+--------------------------------------------------------------------------------------------------------------
static function Pergunta2(cPerg2)
	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   	, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg2,"01"   ,"Coluna Filial   		?",""                    ,""                    ,"mv_ch1","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg2,"02"   ,"Coluna Produto  		?",""                    ,""                    ,"mv_ch2","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg2,"03"   ,"Coluna Quantidade	?",""                    ,""                    ,"mv_ch3","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg2,"04"   ,"Coluna Data	 		?",""                    ,""                    ,"mv_ch4","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg2,"05"   ,"Caracter Separacao	?",""                    ,""                    ,"mv_ch5","C"   ,01      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg2,"06"   ,"1a. Linha cabeçalho	?",""                    ,""                    ,"mv_ch6","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par07","Sim"	    ,""      ,""      ,""    ,"Nao"	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P."+cPerg2+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem a filial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg2+"02."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem o código do Produto")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg2+"03."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem a quantidade")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg2+"04."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem a data da programação")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg2+"05."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe qual o caracter")
	aAdd(aHelpPor,"que separa as colunas no arquivo")
	aAdd(aHelpPor,"geralmente é ponto e virgula")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg2+"06."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe se 1a. linha do arquivo")
	aAdd(aHelpPor,"é apenas cabeçalho")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³ RUNDLG   º Autor ³ Luiz Carlos Vieira º Data ³Thu  24/09/98º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³ Executa o dialogo selecionado pelo usuario em FunNovos     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso		 ³ Espec¡fico para clientes Microsiga						  º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function RunDlg()
	Private cFile

	cTipo :=         "Retorno (*.CSV)          | *.CSV | "
	cTipo := cTipo + "Todos os Arquivos  (*.*) |   *.*   |"

	cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")

	If Empty(cFile)
		MsgStop("Cancelada a Selecao!","Voce cancelou o Processo.")
		Return
	EndIf
Return(cFile)


static function criaDBF2()
	aFields :={}
	aadd(aFields,{"CAMPO","C",200,0})
	cArq2:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq2,"TAB")
return


Static Function ProcCol(nCol,cString)
	Local cTexto := ""
	Local nX := 0

	cString := cString+";"

	nPos 	:= 1
	For nX := 1 To nCol
		cTexto  := SubStr(cString,1,At(";",cString)-1)
		nPos := At(";",cString)+1
		cString :=  SubStr(cString,nPos,Len(cString))
	Next

Return(cTexto)

Static Function MarcaTodos(oListBox, lInverte, lMarca,nItem,nPos)
	Local nX

	If nItem = 0
		For nX := 1 TO Len(oListbox:aArray)
			InverteSel(oListBox,nX, lInverte, lMarca,0)
		Next
	Else
		lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
		Return(lRet)
	EndIf

Return

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
Return
