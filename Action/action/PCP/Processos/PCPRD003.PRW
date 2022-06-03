// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPRD002.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao - GERA OP CONFORME PLANILHA
// -----------+-------------------+---------------------------------------------------------
// 10/07/2017 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "Rwmake.ch"
#include "vkey.ch"
#DEFINE ENTER Chr(13)+Chr(10)

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPRD002
Processa a tabela SB1-Descricao Generica do Produto.

@author    pbindo
@version   11.3.5.201703092121
@since     10/07/2017
/*/
//------------------------------------------------------------------------------------------
/*/{Aterações

@author    SErgio Bruno
@version   12.7
@since     10/07/2018
@Alteração Inclusão do Revisão na estrutura.
@Alteração Retirada da Revisão da Estrutura.
/*/
//------------------------------------------------------------------------------------------



user function PCPRD003()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK") 
	Local oNo		:= LoadBitMap(GetResources(), "LBNO") 
	//Local oDlg
	local oListBox
	//local cListBox
	//Local lContinua := .T.
	Local nOpc		:= 0
	//Local nF4For
	Local oBmp1
	//local oBmp2
	//local oBmp3
	//Local lCampos 	:= .F.
	Local cPerg
	//Local aAreaDA0  := DA0->(GetArea())
	Local lNew := .F.
	//Local lExcAnexo := .T.
	//Local lAnexo := .F.
	//Local nCont  := 0
	//Local l2Anexo := .F.
	//Local cZNChave := ""
	//Local cNFilial
	Private aDados	:= {}
	Private oDlgProdutos

	cPerg := 'PCPRD2'

	Pergunta(cPerg)

	cArquivo := RunDlg()

	If Empty(cArquivo)
		MsgStop('Informe o Nome do Arquivo Padrao Texto!')
		Return
	Endif

	If !Pergunte(cPerg,.T.)
		Return
	Endif 
	
	If mv_par07 < dDataBase
		MsgStop("A data informada é menor que a data atual, altere a data","PCPRD003")
		Return
	EndIf	

	If Empty(MV_PAR01)
		MsgStop('Informe a Coluna do Recurso!')
		Return
	Endif

	If Empty(MV_PAR02)
		MsgStop('Informe a Coluna do Produto!')
		Return
	Endif

	If Empty(MV_PAR03)
		MsgStop('Informe a Coluna da qtde.operador!')
		Return
	Endif

	If Empty(MV_PAR04)
		MsgStop('Informe a Coluna da media de tempo!')
		Return
	Endif

	If Empty(MV_PAR05)
		MsgStop('Informe a Coluna da qtde.a produzir!')
		Return
	Endif

	If Empty(MV_PAR06)
		MsgStop('Informe o Caracter de Separacao. Exemplo ";" !')
		Return
	Endif

    //Retirado Sergio Bruno 
	/*If Empty(MV_PAR08)
		MsgStop('Informe a Coluna da revisão!')
		Return
	Endif*/

	private cArq  :=''
	private cArq2 :=''

	if msgYesNo("Confirma a Importacao do Arquivo "+Alltrim(cArquivo)+", para análise ?")
		szz->(dbclearfil())

		CriaDbf2()
		DbSelectArea('TAB')
		append from &cArquivo sdf
		dbGoTop()
		ProcRegua(RecCount())
		_nCont := 0
		while TAB->(!eof())
			_nCont ++

			IncProc()
			If Empty(CAMPO) .Or. _nCont == 1
				DbSkip()
				Loop
			Endif
			lNew := .F.
			cRecurso := AllTrim(ProcCol(MV_PAR01,CAMPO))

			_cProduto 	:= Iif(!Empty(AllTrim(ProcCol(MV_PAR02,TAB->CAMPO))),AllTrim(ProcCol(MV_PAR02,CAMPO)),'')

			//SOMENTE QUANDO TIVER UM PRODUTO
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial()+_cProduto) .And. !Empty(_cProduto)			 

				dbSelectArea("TAB")
				cDescP 		:= SB1->B1_DESC
				//PRECO VENDA
				nQtdOper  := 0
				cQtdOper	:= ProcCol(MV_PAR03,CAMPO)
				nQtdOper  := Val(cQtdOper)

				If nQtdOper == 0 
					MsgAlert("O Produto "+_cProduto+" com quantidade de Operadores ZERO e não será importado","Atenção - PCPRD002")
					dbSelectArea("TAB")
					dbSkip()
					Loop
				EndIf

				//MEDIA DE TEMPOL
				cMediaT	:= ProcCol(MV_PAR04,CAMPO)
				nMediaT    := Val(cMediaT)

				If nMediaT == 0
					MsgAlert("O Produto "+_cProduto+" com media de tempo ZERO e não será importado","Atenção - PCPRD002")
					dbSelectArea("TAB")
					dbSkip()
					Loop
				EndIf


				//QUANTIDADE A PRODUZIR
				cQProd	:= ProcCol(MV_PAR05,CAMPO)
				nQProd    := Val(cQProd)

				//Retirado Sergio Bruno				
				/*//REVISAO A PRODUZIR
				_cRevisao	:= ProcCol(MV_PAR08,CAMPO)
				_cRevisao    := STRZero(val(_cRevisao),3)*/
				
		
				If nQProd == 0
					MsgAlert("O Produto "+_cProduto+" com Quantidade a Produzir ZERO e não será importado","Atenção - PCPRD002")
					dbSelectArea("TAB")
					dbSkip()
					Loop
				EndIf


				//01-LEGENDA, 02- OK, 03- RECURSO, 04-PRODUTO, 05-DESCRICAO, 06- QTDE OPERADORES, 07 -MEDIA TEMPO, 08-QTDE A PRODUZIR
				aAdd(aDados,{LoadBitMap(GetResources(),"BR_VERDE"),.F.,cRecurso, _cProduto,cDescP, nQtdOper,nMediaT,nQProd})//,_cRevisao)
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

		//01-LEGENDA, 02- OK, 03- RECURSO, 04-PRODUTO, 05-DESCRICAO, 06- QTDE OPERADORES, 07 -MEDIA TEMPO, 08-QTDE A PRODUZIR
		//aTitCampos := {" "," ",OemToAnsi("Recurso"),OemToAnsi("Produto"),OemToAnsi("Descrição"),OemToAnsi("Operadores"),OemToAnsi("Tempo Médio"),OemToAnsi("Qtde.Produzir"),OemToAnsi("Revisao")} - Retirado por Sergio Bruno
		aTitCampos := {" "," ",OemToAnsi("Recurso"),OemToAnsi("Produto"),OemToAnsi("Descrição"),OemToAnsi("Operadores"),OemToAnsi("Tempo Médio"),OemToAnsi("Qtde.Produzir")}

		cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
		//Retirado por Sergio Bruno
		//cLine += " Transform(aDados[oListBox:nAT][6],'@E 999,999'),Transform(aDados[oListBox:nAT][7],'@E 999,999'),Transform(aDados[oListBox:nAT][8],'@E 999,999'),aDados[oListBox:nAT][9],}"
		cLine += " Transform(aDados[oListBox:nAT][6],'@E 999,999'),Transform(aDados[oListBox:nAT][7],'@E 999,999'),Transform(aDados[oListBox:nAT][8],'@E 999,999'),,}"

		bLine := &( "{ || " + cLine + " }" )

		@ 100,005 TO 550,950 DIALOG oDlgProdutos TITLE "OPs"

		oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,,oDlgProdutos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aDados)
		oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := !aDados[oListBox:nAt,2] }


		oListBox:bLine := bLine

		@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgProdutos
		@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgProdutos

		@ 183,110 BUTTON "Ok"  SIZE 40,15 ACTION {nOpc :=1,oDlgProdutos:End()}  PIXEL OF oDlgProdutos
		@ 183,160 BUTTON "Sair"       SIZE 40,15 ACTION {nOpc :=0,oDlgProdutos:End()} PIXEL OF oDlgProdutos

		@ 205,005 BITMAP oBmp1 ResName "BR_VERDE" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
		@ 205,015 SAY "Novo Item" OF oDlgProdutos Color CLR_BLUE,CLR_BLACK PIXEL

		//@ 205,065 BITMAP oBmp2 ResName "BR_BRANCO" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
		//@ 205,075 SAY "Item a Alterar" OF oDlgProdutos Color CLR_BLACK,CLR_WHITE PIXEL

		ACTIVATE DIALOG oDlgProdutos CENTERED

	Endif

	//ATUALIZA OS ITENS
	If nOpc == 1

		processa({|| doProcess()}, "Processando: Descricao Generica do Produto")
	EndIf
	//-- encerramento  ---------------------------------------------------------------------

return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processa registro corrente de SB1-Descricao Generica do Produto.

@author    pbindo
@version   11.3.5.201703092121
@since     10/07/2017
/*/
//------------------------------------------------------------------------------------------
static function doProcess()
	Local nCont := 0
	Local z:=0
	Local cNumIni 
	Local cNumFim
	Local dDataProd := mv_par07
	Local cOpcionais := ""
	
	Local cRet:= ""
	Local aRetorOpc := {}
	//Local lRet

	LOCAL n := 0

	PRIVATE INCLUI := .T.

	For n:=1 To Len(aDados)
		If aDados[n][2]
			nCont ++
		EndIf
	Next

	If nCont > 0
		procRegua(nCont)

		For z:=1 To Len(aDados)

			If aDados[z][2]

				incProc("Processando Produto "+AllTrim(aDados[z][4])+" - Recurso "+aDados[z][3])
				Processmessages()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Obtem numero da proxima OP                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cNumOp    := GetNumSc2()
				cItemOP   := StrZero(1,Len(SC2->C2_ITEM))
				cSequenOP := StrZero(1,Len(SC2->C2_SEQUEN))


				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial()+aDados[z][4])
				cRet := ""
				aRetorOpc := {}
				cOpcMarc := ""
/*
				dbSelectArea("SG1")
				dbSetOrder(1)
				dbSeek(xFilial()+SB1->B1_COD)
				Do While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+SB1->B1_COD 
					If !Empty(SG1->G1_GROPC) .And. !Empty(SG1->G1_OPC)
						//CASO JA ESTEJA NA STRING, NAO INSERE NOVAMENTE
						If (SG1->G1_GROPC+SG1->G1_OPC) $ cOpcionais
							dbSkip()
							Loop
						EndIf
							
						
						
						// Caso ja tenha opcionais preenchidos, pesquisa se nao ‚ o grupo
						// atual
						If !Empty(cOpcionais)
							// Verifica se ‚ a primeira posicao
							If Substr(cOpcionais,1,Len(SG1->G1_GROPC)) == SG1->G1_GROPC
								nString:=1
							Else
								// Procura grupo no campo de opcionais default
								nString:=AT("/"+SG1->G1_GROPC,cOpcionais)
							EndIf
							If nString > 0
								dbSkip()
								Loop
							EndIf
						EndIf
						cOpcionais += SG1->G1_GROPC+SG1->G1_OPC+"/"
	
					EndIf
					dbSkip()
				EndDo
			*/	
//				If !Empty(cOpcionais)
//				cRet := cOpcionais
//					lRet:=P3MarkOpc(SB1->B1_COD,@cRet,aRetorOpc,"",SB1->B1_COD,"MATA650",cOpcMarc,	,1,aDados[z][8],dDatabase,aDados[z][9],.F.)
					//              1           2     3         4  5           6         7        8 9 10           11        12           13  
					cOpcionais:=cRet
	//			EndIf
				
				//01-LEGENDA, 02- OK, 03- RECURSO, 04-PRODUTO, 05-DESCRICAO, 06- QTDE OPERADORES, 07 -MEDIA TEMPO, 08-QTDE A PRODUZIR

				//-- Monta array para utilizacao da Rotina Automatica
				aMata650  := {{'C2_NUM',cNumOp					,NIL},;
				{'C2_ITEM'     	,cItemOP						,NIL},;
				{'C2_SEQUEN'   	,cSequenOP  					,NIL},;
				{'C2_PRODUTO'  	,aDados[z][4]					,NIL},;			
				{'C2_QUANT'    	,aDados[z][8]					,NIL},;
				{'C2_QTSEGUM'  	,0								,NIL},;
				{'C2_UM'       	,SB1->B1_UM						,NIL},;
				{'C2_SEGUM'    	,""								,NIL},;
				{'C2_DATPRI'   	,dDataProd						,NIL},;
				{'C2_DATPRF'   	,dDataProd						,NIL},;
				{'C2_TPOP'     	,"F"							,NIL},;
				{'C2_EMISSAO'  	,dDataBase						,NIL},;
				{'C2_SEQMRP'   	,""								,Nil},;
				{'C2__RECURS'   ,aDados[z][3]					,Nil},;
				{'C2__QTDENG'	,aDados[z][7]					,Nil},;     //	{'MRP'         	,'N'							,NIL},;
				{'AUTEXPLODE'  	,'S'							,NIL}}
				

				Begin Transaction
					lMsErroAuto := .f.
					//-- Chamada da rotina automatica
					msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)					


					If lMsErroAuto
						RollBackSX8()
						MostraErro()
					Else
						//Conout("Inclusao de OP efetuada")
						ConfirmSX8()
						//PONTO DE ENTRADA PARA GERACAO DE NUMERO DE SERIE
						dbSelectArea("SC2")
						dbSetOrder(1)
						If dbSeek(xFilial()+cNumOp+cItemOP+cSequenOP)
							U_MA651GRV() 
						Endif
						//ATUALIZA O NUMERO INICIAL E FINAL
						If Empty(cNumIni)
							cNumIni :=cNumOp
							cNumFim :=cNumOp
						Else
							cNumFim :=cNumOp
						EndIf	 

					EndIf
				End Transaction
			EndIf
		Next
	EndIf

	If !Empty(cNumIni)
		MsgInfo("OPs geradas com Sucesso!"+ENTER+"Inicio "+cNumIni+ENTER+"Final "+cNumFim,"PCPRD003")
	EndIf
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COMMI001  ºAutor  ³Microsiga           º Data ³  05/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function Pergunta(cPerg)
	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

	//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   	, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Coluna Recurso   		?",""                    ,""                    ,"mv_ch1","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Coluna Produto  		?",""                    ,""                    ,"mv_ch2","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Coluna Qtd.Operador  	?",""                    ,""                    ,"mv_ch3","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Coluna Tempo Med.		?",""                    ,""                    ,"mv_ch4","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Coluna Qtde Produzir	?",""                    ,""                    ,"mv_ch5","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Caracter Separacao	?",""                    ,""                    ,"mv_ch6","C"   ,01      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par06",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Data Producao			?",""                    ,""                    ,"mv_ch7","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par07",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
  //PutSx1(cPerg,"08"   ,"Coluna Revisao    	?",""                    ,""                    ,"mv_ch8","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par08",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


	cKey     := "P."+cperg+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem o Recurso")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"02."
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

	cKey     := "P."+cPerg+"03."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem a quant. de operadores")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg+"04."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem o tempo médio")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"05."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a coluna da planilha")
	aAdd(aHelpPor,"que contem a quant.a produzir")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"06."
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



return
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

	If nItem = 0
		For nX := 1 TO Len(oListbox:aArray)
			InverteSel(oListBox,nX, lInverte, lMarca,0)
		Next
	Else
		lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
		Return(lRet)
	EndIf

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
Return

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

	cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos",1,'C:\', .F., nOR( GETF_LOCALHARD,  GETF_NETWORKDRIVE  ),.T., .T. )

	If Empty(cFile)
		MsgStop("Cancelada a Selecao!","Voce cancelou o Processo.")
		Return
	EndIf
Return(cFile)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³criaDBF2  ºAutor  ³Microsiga           º Data ³  06/25/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function criaDBF2()
	aFields :={}
	aadd(aFields,{"CAMPO","C",200,0})
	cArq2:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq2,"TAB")
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATM09   ºAutor  ³Microsiga           º Data ³  06/25/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcCol(nCol,cString)
	Local cTexto := ""
	LOCAL nX := 0
	cString := cString+";"

	nPos 	:= 1
	For nX := 1 To nCol
		cTexto  := SubStr(cString,1,At(";",cString)-1)
		nPos := At(";",cString)+1
		cString :=  SubStr(cString,nPos,Len(cString))
	Next

Return(cTexto)



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MarkOpc  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 17/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao recursiva que permite a selecao de Opcionais .      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MarkOpc(ExpC1,ExpC2,ExpA1,ExpC3,ExpC4)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Produto a ter os opcionais escolhidos.             ³±±
±±³          ³ ExpC2 = Retorno da string com os opcionais selecionados.   ³±±
±±³          ³ ExpA1 = Array com retorno de toda estrutura utilizada      ³±±
±±³          ³ ExpC3 = Produto pai da Estrutura                           ³±±
±±³          ³ ExpC4 = String com os produtos da estrutura                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DESABILITADO                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            
Static Function P3MarkOpc(cProduto,cRet,aRetorOpc,cProdPai,cProdAnt,cProg,cOpcMarc,lVisual,nNivel,nQtd,dDataVal,cRevisao,lPreEstr)
//                        1        2    3         4        5        6     7        8       9      10   11       12       13
Static oOk,oNo,oBr

Local aArea		:=GetArea()
Local cCadastro	:="Opcionais Disponiveis - "+cProduto //"Opcionais Disponiveis - "
Local nAcho		:=0
Local nString	:=0
Local i			:=0
Local nOpca		:=1
Local aGrupos	:={}
Local aRegs		:={}
Local cOpcionais:="" // Variavel utilizada para retorno da string
Local nTamDif	:=(Len(SGA->GA_OPC)+Len(SGA->GA_DESCOPC)+13)-(Len(SGA->GA_GROPC)+Len(SGA->GA_DESCGRP)+3)
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"
Local aOpcionais:={}
Local aSize     :={}
Local aPosObj   :={}
Local aInfo     :={}
Local aObjects  :={}
Local nDifSize  :=0
Local lRet      :=.T.
Local lSELEOPC  :=ExistBlock("SELEOPC")
Local lAddOpc   :=ExistBlock("ADDOPC")
Local lGeraOPI  := SuperGetMV("MV_GERAOPI")
Local aCopyRegs :={}
Local oDlg,oOpc,cOpc
Local lGerOPI	:=ExistBlock("MTGEROPI"),lRetOPI:=.T.
Local nQuantItem:= 1
//Local aRetPe 	:= {}
Local lRetOpc 	:= .F.   
Local aOpcRET	:= {}
Local lTela		:= .T.
Local nQtdAx	:= 0

Default cProg 	 :=""
Default cOpcMarc :=""
Default lVisual  :=.F.
Default nQtd     :=0
Default dDataVal :=dDataBase
Default lPreEstr :=.F.

cProduto := PadR(cProduto,Len(SB1->B1_COD))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao exista cria array que registra todos os niveis da estrutura    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aRetorOpc") <> "A"
	aRetorOpc:={}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta titulo da janela com o codigo do produto+descricao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	cCadastro:="Opcionais Disponiveis - "+AllTrim(cProdPai)+If(!Empty(cProdPai)," - > ","")+Rtrim( cProduto )+" / " + Left(SB1->B1_DESC,25) //"Opcionais Disponiveis - "
	If Empty(cOpcMarc)
		cOpcMarc := RetFldProd(SB1->B1_COD,"B1_OPC")
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do array dos opcionais                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 1 Marcado (.T. ou .F.)
// 2 Titulo("0") ou Item("1")
// 3 Item Opcional+Descricao Opcional
// 4 Grupo de Opcionais
// 5 Registro no SG1
// 6 Nivel no SG1
// 7 Recno do SG1
// 8 Componente Ok (.T.) ou Vencido (.F.)
// 9 Codigo do componente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre a estrutura do produto                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(IIf(lPreEstr,"SGG","SG1"))
dbSetOrder(1)
dbSeek(xFilial()+cProduto)
Do While !Eof() .And. IIf(lPreEstr,SGG->GG_FILIAL+SGG->GG_COD == xFilial("SGG")+cProduto,SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto) 
	If !Empty(IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC)) .And. !Empty(IIf(lPreEstr,SGG->GG_OPC,SG1->G1_OPC))
		// Caso ja tenha opcionais preenchidos, pesquisa se nao ‚ o grupo
		// atual
		If !Empty(cRet)
			// Verifica se ‚ a primeira posicao
			If Substr(cRet,1,Len(SGA->GA_GROPC)) == IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC)
				nString:=1
			Else
				// Procura grupo no campo de opcionais default
				nString:=AT("/"+IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC),cRet)
			EndIf
			If nString > 0 .And. lOpcPadrao
				dbSkip()
				Loop
			EndIf
		EndIf
		If SGA->(dbSeek(xFilial("SGA")+IIf(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)))
			//-- Ponto de Entrada para validar os Opcionais	
			If	lSELEOPC 
				lRet := ExecBlock('SELEOPC',.F.,.F.,{lPreEstr,cRevisao})
				If ValType(lRet) <> 'L'
					lRet := .T.
				EndIf
				If !lRet //-- Se o Opcional nao for valido
					If lPreEstr
					    SGG->(dbSkip())
					Else
						SG1->(dbSkip())
					EndIf	
					Loop
				EndIf
			EndIf
			// Verifica se o grupo ja foi incluido
			nAcho:=ASCAN(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
			//Valida datas e revisao
			If !Empty(nQtd)
				nQuantItem := Round(ExplEstr(nQtd,dDataVal,"",cRevisao,,lPreEstr),TamSX3("D4_QUANT")[2])
			EndIf
			If nAcho == 0
				AADD(aGrupos,IIf(lPreEstr,SGG->GG_GROPC,SG1->G1_GROPC))
				// Adiciona titulo ao array
				//AADD(aOpcionais,{.F.,"0",SGA->GA_GROPC+" - "+SGA->GA_DESCGRP+Space(nTamDif),SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem)>QtdComp(0),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
				AADD(aOpcionais,{.F.,"0",SGA->GA_GROPC+" - "+SGA->GA_DESCGRP+Space(nTamDif),SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),.T.,IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
			EndIf
			// Verifica se o grupo ja foi digitado neste nivel
			nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
			If nAcho == 0
				// Adiciona item ao array
				If !lVisual
					//AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem)>QtdComp(0),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
					AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),.T.,IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
				Else
					If (SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc)
						//AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),QtdComp(nQuantItem)>QtdComp(0),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
						AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),.T.,IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		// Caso nao tenha opcionais neste nivel, guarda o registro para
		// pesquisar em niveis inferiores
	//	AADD(aRegs,{IIf(lPreEstr,SGG->(Recno()),SG1->(Recno())),IIf(lPreEstr,SGG->GG_NIV+SGG->GG_COMP,SG1->G1_NIV+SG1->G1_COMP),IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)})
	EndIf
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso tenha opcionais neste nivel, monta a tela de sele‡ao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aOpcionais) > 0
	// Valor padrao para DIALOG
	nOpca:=0
	// Sorteia array com grupos
	ASORT(aGrupos)
	// Sorteia array com opcionais
	ASORT(aOpcionais,,,{|x,y| x[4]+x[2]+x[3] < y[4]+y[2]+y[3] })
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ha opcional X cliente						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If AliasInDic("SDJ") .And. cProg == "MATA410" .And. AllTrim(M->C5_SOLOPC) == '2'
	   cOpcionais := MtPesqOpc(cProduto,M->(C5_CLIENTE+C5_LOJACLI),aGrupos)
	   aEval(aOpcionais, {|x| If(x[4]+Substr(x[3],1,Len(SGA->GA_OPC)) $ cOpcionais,x[1]:=.T.,x[1]:=.F.) })
	   cOpcionais := ""
	   lTela := !OpcTudOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais,cProg,.F.)
	EndIf
	If lTela
		If !IsBlind()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le na resource os bitmaps utilizados no Listbox p/ sele‡ao  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oOk == NIL
				oOk := LoadBitmap( GetResources(), "LBOK")
			EndIf
			If oNo == NIL
				oNo := LoadBitmap( GetResources(), "LBNO")
			EndIf
			If oBr == NIL
				oBr := LoadBitmap( GetResources(), "NADA")
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula automaticamente as dimensoes dos objetos            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aSize := MsAdvSize(.F.)
			aObjects := {}
			AAdd( aObjects, { 100,  20, .T., .F. } )
			AAdd( aObjects, { 100, 100, .T., .T., .T. } )
			AAdd( aObjects, { 100,  15, .T., .F. } )
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Diminui o tamanho retornado e garante que a largura da Dialog nao ultrapasse 600 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nDifSize := 0
			If ( aSize[ 5 ] - 80 ) > 600
				nDifSize := aSize[ 5 ] - 80 - 600
			EndIf
	
			aSize[ 3 ] -= 40 + nDifSize / 2	
			aSize[ 4 ] -= 40
	
			aSize[ 5 ] -= 80 + nDifSize
			aSize[ 6 ] -= 80
	
			aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
			aPosObj := MsObjSize( aInfo, aObjects )
	
			Do While .T.
	
				DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	
				@ 05, 03 SAY cCadastro OF oDlg PIXEL
	
				@ 15, 00 TO 17, 2000 PIXEL 	  
				
				If ExistBlock("MTOPCADD")
					aOpcRet := ExecBlock("MTOPCADD",.F.,.F.,{aOpcionais})
				EndIf
	
				@ aPosObj[2,1],aPosObj[2,2] LISTBOX oOpc VAR cOpc Fields HEADER "","Grupos/Itens Opcionais","Validade Componente",iif(len(aOpcRet) > 0,aOpcRet[1,1],' ')  SIZE aPosObj[2,3],aPosObj[2,4] ON DBLCLICK If(!lVisual,(aOpcionais:=Opc3Troca(oOpc:nAt,aOpcionais),oOpc:Refresh()),) NOSCROLL OF oDlg PIXEL  //"Grupos/Itens Opcionais"###"Validade Componente"
				oOpc:SetArray(aOpcionais)
				oOpc:bLine := { || {If(aOpcionais[oOpc:nAt,2]=="0",oBr,IF(aOpcionais[oOpc:nAt,1],oOk,oNo)),aOpcionais[oOpc:nAt,3],If(aOpcionais[oOpc:nAt,2]=="0","",If(aOpcionais[oOpc:nAt,8]," Ok"," Vencido")),iif (len(aOpcRet)>1,aOpcRet[oOpc:nAt+1,2],' ')}} //" Vencido"				
				DEFINE SBUTTON FROM aPosObj[3,1]+2,aPosObj[3,4] - 57 TYPE 1 ACTION (IF(If(!lVisual .OR. (!INCLUI .And. !ALTERA),OpcTudOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais,cProg),.T.),(nOpca:=1,oDlg:End()),)) ENABLE OF oDlg PIXEL  
				DEFINE SBUTTON FROM aPosObj[3,1]+2,aPosObj[3,4] - 27 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg PIXEL
				ACTIVATE MSDIALOG oDlg CENTERED
				If nOpcA == 1 .Or. lVisual
					Exit
				ElseIf nOpca == 0
					Exit
				EndIf
			EndDo
		Else
			IF (ASCAN(aOpcionais,{|x| x[8]})) > 0
				OpcTudOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais)
				If !Empty(cOpcionais)
					nOpcA := 1
				EndIf
			Else
				nOpcA := 1
			EndIf
		EndIf
	Else
		nOpcA := 1
	EndIf
	cRet+=cOpcionais
	// Este trecho foi removido pois nas chamadas recursivas o opcional selecionado no nivel anterior estava sendo substituido indevidamente
	//If !lOpcPadrao .And. nNivel > 1
	//	aRetorOpc[Len(aRetoropc),2]:=cOpcionais
	//EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para adicionar mais opcionais ao array aRegs.	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 If lAddOpc
	aCopyRegs := aClone(aRegs)
	aRegs     := ExecBlock('ADDOPC',.F.,.F.,{aRegs,cProdAnt,cOpcionais})
	If ValType(aRegs) <> 'A'
		aRegs := aClone(aCopyRegs)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para a utilizado para verificar a 		    ³
//³ necessidade de gerar ou nao OPs intermediarias				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGerOPI
	lRetOPI:=ExecBlock("MTGEROPI",.F.,.F.)
	If ValType(lRetOPI) # "L"
		lRetOPI:=.T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Na inclusao manual de OPs, nao deve analisar opcionais de           ³
//³outros niveis da estrutura, quando o parametro MV_GERAOPI for Falso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetOPI .And. (  lGeraOPI .Or. (!( "C2_PRODUTO" $ ReadVar())))                                   // qdo vier da inclusão da OP (mata650) e MV_GERAOPI = .F., não tem 
	ASORT(aRegs,,,{|x,y| x[2] < y[2]})                                                              // sentido o cursor estar posicionado no produto para funcionar o MV_GERAOPI
	// Varre o array para que sejam selecionados os itens restantes
	For i:=1 to Len(aRegs)
		If IIf(lPreEstr,SGG->(dbSeek(xFilial("SGG")+aRegs[i,3])),SG1->(dbSeek(xFilial("SG1")+aRegs[i,3]))) 
			If lPreEstr
				SGG->(dbGoto(aRegs[i,1]))
			Else
				SG1->(dbGoto(aRegs[i,1]))
			EndIf	
			// Adiciona no array que registra todos os niveis da estrutura
			AADD(aRetorOpc,{cProdAnt+IIf(lPreEstr,SGG->GG_COMP+SGG->GG_TRT,SG1->G1_COMP+SG1->G1_TRT),cOpcionais})
			nNivel+=1
			nQtdAx := Round(ExplEstr(nQtd,dDataVal,"",cRevisao,,lPreEstr),TamSX3("D4_QUANT")[2])
			SB1->(dbSeek(xFilial("SB1")+IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)))
			IF nQtdAx > 0
				If IsInCallStack("MATA650")  
					If SB1->B1_FANTASM == 'S' .Or. lGeraOPI 
						Do Case
							Case RetFldProd(SB1->B1_COD,"B1_TIPE") == "H"
								dDataVal -= Int(RetFldProd(SB1->B1_COD,"B1_PE")/24)
							Case SB1->B1_TIPE == "S"
								dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 7)
							Case SB1->B1_TIPE == "M"
								dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 30)
							Case SB1->B1_TIPE == "A"
								dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 365)
							OtherWise
								dDataVal -= RetFldProd(SB1->B1_COD,"B1_PE")
						EndCase
						lRetOpc := MarkOpc(IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),@cRet,aRetorOpc,IIf(lPreEstr,SGG->GG_COD,SG1->G1_COD),cProdAnt+IIf(lPreEstr,SGG->GG_COMP+SGG->GG_TRT,SG1->G1_COMP+SG1->G1_TRT),cProg,cOpcMarc,lVisual,nNivel,nQtdAx,dDataVal,SB1->B1_REVATU,lPreEstr)	
						If !lRetOpc
							nOpca := 0
						EndIf
						nNivel-=1 
					EndIf	
				Else
					Do Case
						Case RetFldProd(SB1->B1_COD,"B1_TIPE") == "H"                                
							dDataVal -= Int(RetFldProd(SB1->B1_COD,"B1_PE")/24)
						Case SB1->B1_TIPE == "S"
							dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 7)
						Case SB1->B1_TIPE == "M"
							dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 30)
						Case SB1->B1_TIPE == "A"
							dDataVal -= (RetFldProd(SB1->B1_COD,"B1_PE") * 365)
						OtherWise
							dDataVal -= RetFldProd(SB1->B1_COD,"B1_PE")
					EndCase
					lRetOpc := MarkOpc(IIf(lPreEstr,SGG->GG_COMP,SG1->G1_COMP),@cRet,aRetorOpc,IIf(lPreEstr,SGG->GG_COD,SG1->G1_COD),cProdAnt+IIf(lPreEstr,SGG->GG_COMP+SGG->GG_TRT,SG1->G1_COMP+SG1->G1_TRT),cProg,cOpcMarc,lVisual,nNivel,nQtdAx,dDataVal,SB1->B1_REVATU,lPreEstr)	
					If !lRetOpc
						nOpca := 0
					EndIf
					nNivel-=1 
				EndIf
			EndIf
		Else
			If lPreEstr
				SGG->(dbGoto(aRegs[i,1]))
			Else
				SG1->(dbGoto(aRegs[i,1]))
			EndIf
			If !lOpcPadrao
				// Adiciona no array que registra todos os niveis da estrutura
				AADD(aRetorOpc,{cProdAnt+IIf(lPreEstr,SGG->GG_COMP+SGG->GG_TRT,SG1->G1_COMP+SG1->G1_TRT),SG1->G1_GROPC+SG1->G1_OPC+"/"})
			EndIf
		EndIf
	Next I
EndIf

RestArea(aArea)
Return nOpcA == 1


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ OpcTroca                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 12/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Troca marcador entre x e branco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ Versao Windows-> OpcTroca(ExpN1,ExpA1)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ (Somente versao WINDOWS)                                   ³±±
±±³           ³ ExpN1 = Linha em que esta sendo efetuado o Double-Click    ³±±
±±³           ³ ExpA1 = Array utilizado na marcacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Selecao de Opcionais                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Opc3Troca(nIt,aArray)
LOCAL aAcho:={}
Local lMultOpc	:= SuperGetMv("MV_MULTOPC",.F.,.F.)
Local nX := 0
// Muda caso seja ITEM
If aArray[nIt,2] == "1" 
	If !aArray[nIt,8]
		Help( ,, 'Help',, "Componente vencido. Seleção não permitida.", 1, 0 )
	Else
		If aArray[nIt,1]
			//Desmarca o opcional selecionado
			aArray[nIt,1] := ! aArray[nIt,1]
		Else
			If !lMultOpc
				// Varre o array para verificar se marcou apenas um item por grupo
				aAcho:={ASCAN(aArray,{|x| x[4] == aArray[nIt,4] .And. x[1]})}
			Else
				aAcho:=OpcConc(aArray,aArray[nIt,4],SubStr(aArray[nIt,3],1,TamSX3("GA_OPC")[1]))
			EndIf
		
			// Desmarca Item
			For nX := 1 To Len(aAcho)
				If aAcho[nX] # 0
					aArray[aAcho[nX],1]:= .F.
				EndIf
			Next nX
			aArray[nIt,1]  := !aArray[nIt,1]
		EndIf
	EndIf
EndIf
Return aArray    
