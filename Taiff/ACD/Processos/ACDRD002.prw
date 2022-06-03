// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ACDRD002.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 18/04/2017 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#INCLUDE "rwmake.ch"
#DEFINE ENTER Chr(13)+Chr(10)
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ACDRD002
Processa a tabela CB7-Cabecalho de ordem separacao.

@author    pbindo
@version   11.3.5.201703092121
@since     18/04/2017
/*/
//------------------------------------------------------------------------------------------
user function ACDRD002()
	Private lImporta     := Iif(GetMV("MV__ACDRD2")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
	Private dData 	:= dDataBase
	
	
	If lImporta
		MsgStop("Esta rotina ja esta sendo executada ","ACDRD002")
		Return
	EndIf
	PutMv("MV__ACDRD2","S")
	Processa( {||ACDRD2()} )
	PutMv("MV__ACDRD2","N")
	
return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDRD2    ºAutor  ³Microsiga           º Data ³  18/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ ROTINA PARA GERAR A ORDEM DE SEPARACAO                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ACDRD2()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oDlg,oListBox,cListBox
	Local lContinua := .T.
	Local nOpc		:= 0
	Local nF4For
	Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	Local cPesqPV := Space(06)
	Local I
	
	Private aDados		:= {}
	Private nOrigExp   := ""
	Private cSeparador := Space(6)	//variavel utilizada para armazenar o separador da pergunte AIA102, pois o mesmo estava sendo sobreposto por outra pergunte, ao precionar F12 na tela de geracao
	Private cNumUnic
	PRIVATE nConfLote
	PRIVATE nEmbSimul
	PRIVATE nEmbalagem
	PRIVATE nGeraNota
	PRIVATE nImpNota
	PRIVATE nImpEtVol
	PRIVATE nEmbarque
	PRIVATE nAglutPed
	PRIVATE nAglutArm
	//Configuracoes da pergunte AIA107 (Notas Fiscais), ativado pela tecla F12:
	PRIVATE nEmbSimuNF
	PRIVATE nEmbalagNF
	PRIVATE nImpNotaNF
	PRIVATE nImpVolNF
	PRIVATE nEmbarqNF
	//Configuracoes da pergunte AIA108 (Ordens de Producao), ativado pela tecla F12:
	PRIVATE nReqMatOP
	PRIVATE nAglutArmOP
	PRIVATE nPreSep
	
	PRIVATE nADias	:= 0
	PRIVATE n1Dias	:= 0
	PRIVATE n2Dias	:= 0
	PRIVATE nQPed	:= 0
	PRIVATE nQItens	:= 0
	PRIVATE nQTItens	:= 0
	PRIVATE nQVenda := 0
	PRIVATE nPValor	:= 0
	PRIVATE lMais40 := .F.
	
	PRIVATE APEDVENBNF	:= {}
	PRIVATE APEDBNFVEN	:= {}
	PRIVATE APEDBNFVNC	:= {}
	PRIVATE ATEMPBNF		:= {}
	PRIVATE _LRETBNF 		:= .F.
	
	If !Pergunte("AIA101",.T.)
		Return
	EndIf
	nOrigExp := MV_PAR01
	AtivaF12(nOrigExp) // carrega os valores das perguntes relacionados a configuracoes
	
	If	nOrigExp == 1
		cPerg := "ACDR21"
		ValidPerg(cPerg)
		If  !Pergunte(cPerg,.T.)
			Return
		EndIf
		
		cQuery := " SELECT C9_PEDIDO , MIN(C9_DATALIB) C9_DATALIB" + ENTER
 		cQuery += " 	, (CASE WHEN C9_XFIL='01' THEN C9_CLIORI ELSE C9_CLIENTE END) AS C9_CLIENTE" + ENTER
 		cQuery += " 	, (CASE WHEN C9_XFIL='01' THEN C9_LOJORI ELSE C9_LOJA END) AS C9_LOJA" + ENTER 
		cQuery += " 	, (CASE WHEN C9_XFIL='01' THEN C9_PEDORI ELSE C9_PEDIDO END) AS C9_PEDORI,C9_XFIL" + ENTER
		cQuery += " 	,(CASE WHEN C9_XFIL='01' THEN C9_NOMORI ELSE C5_NOMCLI END) AS C9_NOMORI" + ENTER 
		cQuery += " 	, SUM(C9_QTDLIB*C9_PRCVEN) VALOR, COUNT(C9_PEDIDO) ITEM " + ENTER
		cQuery += " 	,C5_CLASPED, C5_X_PVBON, C5_NUMOLD, C5_BNFLIB " + ENTER
		cQuery += " FROM " + RetSqlName("SC9") + " SC9 " + ENTER
		cQuery += " INNER JOIN  " + RetSqlName("SC5") + " SC5 " + ENTER
		cQuery += "	ON C5_NUM=C9_PEDIDO " + ENTER
		cQuery += "  	AND C5_FILIAL=C9_FILIAL " + ENTER
		cQuery += "  	AND SC5.D_E_L_E_T_='' " + ENTER
		cQuery += " WHERE " + ENTER
		cQuery += " C9_PEDIDO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' " + ENTER
		cQuery += " AND C9_CLIENTE BETWEEN '"+mv_par04+"' AND '"+mv_par06+"' " + ENTER
		cQuery += " AND C9_LOJA BETWEEN '"+mv_par05+"' AND '"+mv_par07+"' " + ENTER
		cQuery += " AND C9_DATALIB BETWEEN '"+Dtos(mv_par08)+"' AND '"+Dtos(mv_par09)+"' " + ENTER
		cQuery += " AND C9_ORDSEP = '' " + ENTER
		cQuery += " AND C9_XORDSEP = '' " + ENTER
		cQuery += " AND C9_FILIAL = '"+cFilAnt+"' " + ENTER
		cQuery += " AND SC9.D_E_L_E_T_ <> '*' " + ENTER
		cQuery += " AND C9_NFISCAL = '' " + ENTER
		cQuery += " AND C9_BLCRED = '' AND C9_BLEST = '' " + ENTER
		//cQuery += " AND C9_PEDIDO IN (SELECT C5_NUM FROM "+RetSqlName("SC5")+" WHERE C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND D_E_L_E_T_ <> '*' AND C5_TRANSP BETWEEN '"+mv_par11+"' AND '"+mv_par12+"')
		If mv_par13 == 1
			cQuery += "AND C9_PEDORI IN (SELECT C5_NUM FROM "+RetSqlName("SC5")+" WHERE C5_FILIAL = C9_XFIL AND C5_NUM = C9_PEDORI AND D_E_L_E_T_ <> '*' AND C5_TRANSP BETWEEN '      ' AND 'ZZZZZZ') " + ENTER
		EndIf
		cQuery += "AND C9_PEDIDO IN (SELECT C5_NUM FROM "+RetSqlName("SC5")+" WHERE " + Iif( SC5->(FIELDPOS("C5__DTLIBF")) > 0,"C5__DTLIBF!='' AND '" + DTOS(DDATABASE) + "'>=C5__DTLIBF AND C5__BLOQF='' AND","") + " C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND D_E_L_E_T_ <> '*' AND C5_TRANSP BETWEEN '"+mv_par11+"' AND '"+mv_par12+"') " + ENTER
		//CROSS DOCKING
		If mv_par13 == 1
			cQuery += " AND C9_XFIL <> C9_FILIAL " + ENTER
		Else //BRASIL
			cQuery += " AND C9_XFIL = C9_FILIAL " + ENTER
		EndIf
		cQuery += " AND C9_XITEM = '"+Iif(mv_par14==1,"1","2")+"' " + ENTER
		If mv_par14==2
			cQuery += " AND C5_YSTSEP = '' " + ENTER
		EndIf
		cQuery += " GROUP BY C9_PEDIDO , C9_CLIORI , C9_LOJORI,C9_PEDORI, C9_NOMORI ,C9_XFIL, C9_NOMORI " + ENTER
		cQuery += " ,C5_CLASPED, C5_X_PVBON, C5_NUMOLD, C5_BNFLIB,C9_CLIENTE,C9_LOJA,C5_NOMCLI,C5_YSTSEP " + ENTER
		cQuery += " ORDER BY C9_PEDIDO " + ENTER
		
		MemoWrite("ACDRD002_PEDIDO.SQL",cQuery)
		
		
		cSeparador := MV_PAR01
		nPreSep := MV_PAR10
		
		IF  !Pergunte("AIA106",.T.)
			Return
		EndIf
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
		
		TcSetField('TRB','C9_DATALIB','D')
		Count To nRec
		
		If nRec == 0
			MsgStop("Não existem dados para este filtro!","Atenção")
			TRB->(dbcloseArea())
			Return
		EndIf
		
		APEDVENBNF	:= {}
		APEDBNFVEN	:= {}
		APEDBNFVNC	:= {}

		
		dbSelectArea("TRB")
		ProcRegua(nRec)
		dbGotop()
		While !Eof()
			IF TRB->C5_CLASPED = "V" .AND. !EMPTY(ALLTRIM(TRB->C5_X_PVBON))
				
				IF ASCAN(APEDVENBNF,{|X| X[1] = TRB->C9_PEDIDO}) = 0
					
					ATEMPBNF := {}
					ATEMPBNF := STRTOKARR(ALLTRIM(TRB->C5_X_PVBON),"/")
					FOR I := 1 TO LEN(ATEMPBNF)
						
						DBSELECTAREA("SC5")
						DBORDERNICKNAME("SC5NUMOLD")
						IF DBSEEK(XFILIAL("SC5") + ATEMPBNF[I])
							IF EMPTY(ALLTRIM(SC5->C5_NOTA))
								IF VERSLD(ATEMPBNF[I]) > 0
									AADD(APEDVENBNF,{TRB->C9_PEDIDO,SC5->C5_NUM})
								ENDIF
							ENDIF
						ENDIF
						
					NEXT I
					
				ENDIF
				
				/*
				|---------------------------------------------------------------------------------
				|	Preenchimento de Array de Bonificações com Vínculo
				|---------------------------------------------------------------------------------
				*/
			ELSEIF TRB->C5_CLASPED= "X" .AND. !EMPTY(ALLTRIM(TRB->C5_X_PVBON)) .AND. VERSLD(TRB->C5_NUMOLD) > 0
				
				IF ASCAN(APEDBNFVEN,{|X| X[2] = TRB->C9_PEDIDO}) = 0
					
					DBSELECTAREA("SC5")
					DBORDERNICKNAME("SC5NUMOLD")
					IF DBSEEK(XFILIAL("SC5") + ALLTRIM(SC5->C5_X_PVBON))
						AADD(APEDBNFVEN,{SC5->C5_NUM,TRB->C9_PEDIDO})
					ENDIF
					
				ENDIF
				
			ENDIF
			DBSELECTAREA("TRB")
			
			DbSkip()
		End
		
		_LRETBNF := .T.
		ATEMPBNF := {}
		// Verifica primeiro se os Vinculos da Venda estao selecionados e nao foram liberados para faturamento separado
		IF LEN(APEDVENBNF) > 0
			
			FOR I := 1 TO LEN(APEDVENBNF)
				
				IF ASCAN(APEDBNFVEN,{|X| X[1] = APEDVENBNF[I,1]}) = 0 .AND. BNFSLD(APEDVENBNF[I,2]) = 0 
					//Nao esta selecionado. Verifica se esta liberado para faturamento separado.
					IF POSICIONE("SC5",1,XFILIAL("SC5") + APEDVENBNF[I,2],"C5_X_LIBON") != "L"
						
						AADD(ATEMPBNF,{APEDVENBNF[I,1],APEDVENBNF[I,2],"Pedido de Bonificação não está selecionado para Faturamento!"})
						CONOUT("ACDRD002 - " + ALLTRIM(STR(PROCLINE())) + " PEDIDO ENTROU NA REGRA DE BONIFICACAO SEM A VENDA: " + APEDVENBNF[I,1])
						_LRETBNF := .F.
						
					ENDIF
					
				ENDIF
				
			NEXT I
			
		ENDIF
		
		// Verifica se o Vinculo da Bonificação esta selecionada e se a Bonificação está liberada para faturamento separado
		IF LEN(APEDBNFVEN) > 0
			
			FOR I := 1 TO LEN(APEDBNFVEN)
				
				IF ASCAN(APEDVENBNF,{|X| X[1] = APEDBNFVEN[I,1]}) = 0 .AND. POSICIONE("SC5",1,XFILIAL("SC5") + APEDBNFVEN[I,2],"C5_X_LIBON") != "L"
					
					AADD(ATEMPBNF,{APEDBNFVEN[I,1],APEDBNFVEN[I,2],"Pedido de Venda não está selecionado para Faturamento!"})
					CONOUT("ACDRD002 - " + ALLTRIM(STR(PROCLINE())) + " PEDIDO ENTROU NA REGRA DE BONIFICACAO SEM A VENDA: " + APEDBNFVEN[I,1])
					_LRETBNF := .F.
					
				ENDIF
				
			NEXT I
			
		ENDIF
		
		
		CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
		dbSelectArea("TRB")
		ProcRegua(nRec)
		dbGotop()
		
		aDados	 := {}
		While !Eof()
			IncProc("Montando os itens a serem selecionados")
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(TRB->C9_XFIL + TRB->C9_PEDORI)
			
			If	1=1 //ASCAN(APEDVENBNF,{|X| X[1] = TRB->C9_PEDIDO }) = 0
				
				cVendedor := Posicione("SA3",1,TRB->C9_XFIL + SC5->C5_VEND1,"A3_NOME")
				cNomCli := Posicione("SA1",1,TRB->C9_XFIL + TRB->C9_CLIENTE + TRB->C9_LOJA,"A1_NOME")
				cNomTransp := Posicione("SA4",1, xFilial("SA4") + SC5->C5_TRANSP,"A4_NOME")
				
				// 01 - COR , 02 - MARK, 03 - PEDIDO, 04- '', 05- ENTREGA, 06 - COD CLI, 07 - RAZAO, 08 - COD TRANS, 09 - NOME TRANS, 10 - VALOR , 11- ITENS,12 - VENDEDOR, 13- '', 14- DATA EMISSAO
				aAdd(aDados,{fColor(),.F.,TRB->C9_PEDIDO,'', TRB->C9_DATALIB, TRB->C9_CLIENTE, cNomCli, SC5->C5_TRANSP, cNomTransp,TRB->VALOR,TRB->ITEM,AllTrim(cVendedor), '', SC5->C5_EMISSAO, ''})
				
			EndIf
			dbSelectArea("TRB")
			dbSkip()
		End
		
		
	ElseIf	nOrigExp == 2 // nota fiscal saida
		c2Perg := "ACDR22"
		Valid2Perg(c2Perg)
		
		If	!Pergunte(c2Perg,.T.)
			Return
		EndIf
		
		cSeparador := MV_PAR01
		
		
		cQuery := " SELECT D2_DOC, D2_SERIE, D2_PEDIDO , D2_CLIENTE , D2_LOJA,  D2_EMISSAO, SUM(D2_TOTAL) VALOR, COUNT(D2_ITEM) ITEM " + ENTER
		cQuery += " 	FROM " + RetSqlName("SD2") + " SD2 " + ENTER
		cQuery += " WHERE	" + ENTER
		cQuery += " D2_DOC BETWEEN '"+mv_par02+"' AND '"+mv_par04+"'" + ENTER
		cQuery += " AND D2_SERIE BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'" + ENTER
		cQuery += " AND D2_CLIENTE BETWEEN '"+mv_par06+"' AND '"+mv_par08+"'" + ENTER
		cQuery += " AND D2_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par09+"'" + ENTER
		cQuery += " AND D2_EMISSAO BETWEEN '"+Dtos(mv_par10)+"' AND '"+Dtos(mv_par11)+"'" + ENTER
		cQuery += " AND D2_ORDSEP = ''" + ENTER
		cQuery += " AND D2_FILIAL = '"+cFilAnt+"'" + ENTER
		cQuery += " AND SD2.D_E_L_E_T_ <> '*' AND D2_TIPO = 'N'" + ENTER
		cQuery += " AND EXISTS (SELECT 'S' FROM "+RetSqlName("SF2")+" SF2 " + ENTER
		cQuery += " 				WHERE F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND D_E_L_E_T_ <> '*' AND F2_TRANSP BETWEEN '"+mv_par12+"' AND '"+mv_par13+"' " + ENTER
		If mv_par16 == 1 //CROSS DOCKING
			cQuery += " AND F2_NUMRM = 'CROSS' " + ENTER
		Else
			cQuery += " AND F2_NUMRM <> 'CROSS' " + ENTER
		EndIf
		cQuery += " )" + ENTER
		cQuery += " and D2_ITEMCC = '"+Iif(mv_par14==1,"TAIFF","PROART")+"'" + ENTER
		
		//VERIFICA SE JA FOI SEPARADO POR PEDIDO
		cQuery += " AND NOT EXISTS (SELECT 'S'  FROM "+RetSqlName("SC9")+" WHERE D2_FILIAL = C9_FILIAL AND D2_DOC = C9_NFISCAL AND D2_SERIE = C9_SERIENF AND D2_ITEMPV = C9_ITEM AND D_E_L_E_T_ <> '*' AND C9_ORDSEP <> '')" + ENTER
		
		//FILTRA ESTADO
		If !Empty(mv_par15)
			cQuery += " AND D2_EST = '"+mv_par15+"'" + ENTER
		EndIf
		cQuery += " GROUP BY D2_DOC, D2_SERIE, D2_PEDIDO , D2_CLIENTE , D2_LOJA, D2_EMISSAO " + ENTER
		cQuery += " ORDER BY D2_DOC " + ENTER
		
		MemoWrite("ACDRD002_NOTA.SQL",cQuery)
		
		IF  !Pergunte("AIA107",.T.)
			Return
		EndIf
		
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
		
		TcSetField('TRB','D2_EMISSAO','D')
		Count To nRec
		
		If nRec == 0
			MsgStop("Não existem dados para este filtro!","Atenção")
			TRB->(dbcloseArea())
			Return
		EndIf
		
		dbSelectArea("TRB")
		ProcRegua(nRec)
		dbGotop()
		
		aDados	 := {}
		While !Eof()
			IncProc("Montando os itens a serem selecionados")
			
			
			
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbSeek(xFilial()+TRB->D2_PEDIDO)
			
			cVendedor := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")
			cNomCli := Posicione("SA1",1,xFilial("SA1")+TRB->D2_CLIENTE+TRB->D2_LOJA,"A1_NOME")
			cNomTransp := Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
			
			// 01 - COR , 02 - MARK, 03 - PEDIDO, 04- SERIE, 05- ENTREGA, 06 - COD CLI, 07 - RAZAO, 08 - COD TRANS, 09 - NOME TRANS, 10 - VALOR , 11- ITENS,12 - VENDEDOR, 13- '', 14- DATA EMISSAO
			aAdd(aDados,{fColor(),.F.,TRB->D2_DOC,TRB->D2_SERIE, TRB->D2_EMISSAO, TRB->D2_CLIENTE, cNomCli, SC5->C5_TRANSP, cNomTransp,TRB->VALOR,TRB->ITEM,AllTrim(cVendedor), '', SC5->C5_EMISSAO, ''})
			
			dbSelectArea("TRB")
			dbSkip()
		End
	ElseIf	nOrigExp == 3 // producao
		MsgStop("Opção desabilitada neste tela","ACDRD002")
		Return
	EndIf
	TRB->(dbCloseArea())
	
	If len(aDados) = 0
		MsgStop("Não há dados a apresentar com os parâmetros selecionados!!","ACDRD002")
		Return
	EndIf
	
	aTitCampos := {"", " ",OemToAnsi(Iif(nOrigExp == 1,"Pedido","Nota")),OemToAnsi("Entrega"),OemToAnsi("Cod.Cli"),OemToAnsi("Cliente"),OemToAnsi("Cod.Transp."),OemToAnsi("Transportadora"),;
		OemToAnsi("Valor"), OemToAnsi("Qtd.Itens Pedido"),OemToAnsi("Vendedor"),OemToAnsi("Mun.Entrega"),OemToAnsi("Data Emissão"),''}
	
	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],Transform(aDados[oListBox:nAT][10],'@e 9,999,999.99'),"
	cLine += " aDados[oListBox:nAT][11],aDados[oListBox:nAT][12],aDados[oListBox:nAT][13],aDados[oListBox:nAT][14],}"
	
	bLine := &( "{ || " + cLine + " }" )
	nMult := 7
	aCoord2 := {nMult*1,nMult*1,nMult*6,nMult*6,nMult*8,nMult*6,nMult*10,nMult*6,nMult*6,nMult*10,nMult*9,nMult*12,nMult*15,nMult*8,nMult*1}
	
	@ 100,005 TO 600,950 DIALOG oDlgPedidos TITLE "Pedidos"
	
	oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || (MarcaTodos(oListBox, .T., .T.,1,oListBox:nAt),oDlgPedidos:Refresh()) } //{ || aDados[oListBox:nAt,1] := Iif(aDados[oListBox:nAt,1]==.T.,.F.,.T.)}
	oListBox:bLine := bLine
	
	//TOTAL DE ITENS
	@ 187, 005 SAY "Atrasados" OF oDlgPedidos Color CLR_RED PIXEL
	@ 187, 060 GET oADias 	Var nADias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	//@ 187, 060 SAY Transform(nADias,"@e 99999") OF oDlgPedidos Color CLR_RED PIXEL
	
	@ 187, 115 SAY "Liberado 1 Dia" OF oDlgPedidos Color CLR_BROWN PIXEL
	@ 187, 170 GET o1Dias 	Var n1Dias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	//@ 187, 170 SAY Transform(n1Dias,"@e 99999") OF oDlgPedidos Color CLR_BROWN PIXEL
	
	@ 187, 225 SAY "Liberado 2 Dias ou Mais" OF oDlgPedidos Color CLR_GREEN PIXEL
	@ 187, 280 GET o2Dias 	Var n2Dias 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	//@ 187, 280 SAY Transform(n2Dias,"@e 99999") OF oDlgPedidos Color CLR_GREEN PIXEL
	
	@ 187, 335 SAY "Valor" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 187, 390 GET oPValor 	Var nPValor	Picture "@e 9,999,999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	
	
	@ 200, 005 SAY "Pedidos" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 060 GET oQped 	Var nQPed 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	@ 200, 115 SAY "Itens Distintos" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 170 GET oQItens 	Var nQItens 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	@ 200, 225 SAY "Total Itens" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 280 GET oQTItens	Var nQTItens	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	@ 200, 335 SAY "Total Peças" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos
	
	
	//BOTOES
	@ 220,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgPedidos
	@ 220,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgPedidos
	@ 220,110 BUTTON "Gerar"   	   		SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()}  PIXEL OF oDlgPedidos
	//@ 220,160 BUTTON "Vis.Pedido"		SIZE 40,15 ACTION U_VERPEDIDO(aDados[oListBox:nAT][3], cFilAnt) PIXEL OF oDlgPedidos
	@ 220,210 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos
	
	@ 220,310 SAY "Busca Pedido:" SIZE 65,9 PIXEL OF oDlgPedidos
	@ 220,360 MSGET oSeek VAR cPesqPV SIZE 40,7 Valid (Iif(!Empty(cPesqPV),(Busca(cPesqPV,oListBox),cPesqPV := Space(06),oListBox:Refresh(),oSeek:SetFocus()),)) PIXEL OF oDlgPedidos
	
	@ 240, 005 BITMAP oBmp1 ResName 	"BR_BRANCO" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 015 SAY "Liberado" OF oDlgPedidos Color CLR_GREEN PIXEL
	
	@ 240, 080 BITMAP oBmp2 ResName 	"BR_VERDE" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 090 SAY "2 Dias" OF oDlgPedidos Color CLR_RED PIXEL
	
	@ 240, 155 BITMAP oBmp3 ResName 	"BR_AMARELO" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 165 SAY "1 Dia" OF oDlgPedidos Color CLR_RED PIXEL
	
	@ 240, 230 BITMAP oBmp4 ResName 	"BR_VERMELHO" OF oDlgPedidos Size 15,15 NoBorder When .F. Pixel
	@ 240, 240 SAY "Atraso" OF oDlgPedidos Color CLR_RED PIXEL
	
	ACTIVATE DIALOG oDlgPedidos CENTERED
	
	
	
	If nOpc == 0
		Return
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
	
	
	If nOrigExp==1
		Processa( { || GeraOSepPedido() } )
	ElseIf nOrigExp==2
		Processa( { || GeraOSepNota() } )
	EndIf
	
Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GeraOSepPedido³ Autor ³ Eduardo Motta     ³ Data ³ 06/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera as ordens de separacao a partir dos itens da MarkBrowse³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GeraOrdSep( ExpC1, ExpL1 )                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Marca da MarkBrowse / ExpL1 -> lInverte MarkBrowse³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCHA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC Function GeraOSepPedido()
	Local nI
	Local cCodOpe
	Local aRecSC9	:= {}
	Local aOrdSep	:= {}
	Local cArm		:= Space(Tamsx3("B1_LOCPAD")[1])
	Local cPedido	:= Space(6)
	Local cCliente	:= Space(6)
	Local cLoja		:= Space(2)
	Local cCondPag	:= Space(3)
	Local cLojaEnt	:= Space(2)
	Local cAgreg	:= Space(4)
	Local cOrdSep	:= Space(4)
	Local cTipExp	:= ""
	Local nPos      := 0
	Local nMaxItens	:= GETMV("MV_NUMITEN")			//Numero maximo de itens por nota (neste caso por ordem de separacao)- by Erike
	Local lConsNumIt:= SuperGetMV("MV_CBCNITE",.F.,.T.) //Parametro que indica se deve ou nao considerar o conteudo do MV_NUMITEN
	Local lFilItens	:= ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
	Local lLocOrdSep:= .F.
	Local kk		:= 0
	Local cDCORIGEM	:= "SC6"
	
	Private aLogOS	:= {}
	nMaxItens := If(Empty(nMaxItens),99,nMaxItens)
	
	// analisar a pergunta '00-Separacao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque,07-Aglutina Pedido,08-Aglutina Local,09-Pre-Separacao'
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
	If nPreSep == 1 // pre-separacao - Trocar MV_PAR10 para nPreSep
		cTipExp +="09*"
	EndIf
	If nConfLote == 1 // confere lote
		cTipExp +="10*"
	EndIf
	
	/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
	If	ExistBlock("ACD100VG")
		If ! ExecBlock("ACD100VG",.F.,.F.,)
			Return
		EndIf
	EndIf
	
	ProcRegua(Len(aDados))
	cCodOpe	 := cSeparador
	
	SC5->(DbSetOrder(1))
	SC6->(DbSetOrder(1))
	SDC->(DbSetOrder(1))
	CB7->(DbSetOrder(2))
	CB8->(DbSetOrder(2))
	
	For kk:=1 To Len(aDados)
		
		If aDados[kk][2]
			
			IncProc("Selecionando Pedidos")
			
			dbSelectArea("SC9")
			dbSetOrder(1)
			dbSeek(xFilial()+aDados[kk][3])
			
			While !Eof() .And. SC9->C9_PEDIDO == aDados[kk][3]
				
				If !Empty(SC9->(C9_BLEST+C9_BLCRED+C9_BLOQUEI)) .Or. !Empty(SC9->C9_ORDSEP)
					SC9->(DbSkip())
					Loop
				EndIf
				
				//pesquisa se este item tem saldo a separar, caso tenha, nao gera ordem de separacao
				If CB8->(DbSeek(xFilial('CB8')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN+SC9->C9_PRODUTO)) .and. CB8->CB8_SALDOS > 0
					//Grava o historico das geracoes:
					aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Existe saldo a separar deste item","NAO_GEROU_OS"}) //"Pedido"###"Existe saldo a separar deste item"
					SC9->(DbSkip())
					Loop
				EndIf
				
				If ! SC5->(DbSeek(xFilial('SC5')+SC9->C9_PEDIDO))
					// neste caso a base tem sc9 e nao tem sc5, problema de incosistencia de base
					//Grava o historico das geracoes:
					aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC5 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC5 x SC9)"
					SC9->(DbSkip())
					Loop
				EndIf
				If ! SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
					// neste caso a base tem sc9,sc5 e nao tem sc6,, problema de incosistencia de base
					//Grava o historico das geracoes:
					aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Inconsistencia de base (SC6 x SC9)","NAO_GEROU_OS"}) //"Pedido"###"Inconsistencia de base (SC6 x SC9)"
					SC9->(DbSkip())
					Loop
				EndIf
				
				If !("08*" $ cTipExp)  // gera ordem de separacao por armazem
					cArm :=SC6->C6_LOCAL
				Else  // gera ordem de separa com todos os armazens
					cArm :=Space(Tamsx3("B1_LOCPAD")[1])
				EndIf
				If "11*" $ cTipExp //AGLUTINA TODOS OS PEDIDOS DE UM MESMO CLIENTE
					cPedido := Space(6)
				Else   // Nao AGLUTINA POR PEDIDO
					cPedido := SC9->C9_PEDIDO
				EndIf
				If "09*" $ cTipExp // AGLUTINA PARA PRE-SEPARACAO
					cPedido  := Space(6) // CASO SEJA PRE-SEPARACAO TEM QUE CONSIDERAR TODOS OS PEDIDOS
					cCliente := Space(Tamsx3("C6_CLI")[1])
					cLoja    := Space(Tamsx3("C6_LOJA")[1])
					cCondPag := Space(3)
					cLojaEnt := Space(2)
					cAgreg   := Space(4)
				Else   // NAO AGLUTINA PARA PRE-SEPARACAO
					cCliente := SC6->C6_CLI
					cLoja    := SC6->C6_LOJA
					cCondPag := SC5->C5_CONDPAG
					cLojaEnt := SC5->C5_LOJAENT
					cAgreg   := SC9->C9_AGREG
				EndIf
				
				lLocOrdSep := .F.
				If CB7->(DbSeek(xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg))
					While CB7->(!Eof() .and. CB7_FILIAL+CB7_PEDIDO+CB7_LOCAL+CB7_STATUS+CB7_CLIENT+CB7_LOJA+CB7_COND+CB7_LOJENT+CB7_AGREG==;
							xFilial("CB7")+cPedido+cArm+" "+cCliente+cLoja+cCondPag+cLojaEnt+cAgreg)
						If Ascan(aOrdSep, CB7->CB7_ORDSEP) > 0
							lLocOrdSep := .T.
							Exit
						EndIf
						CB7->(DbSkip())
					EndDo
				EndIf
				
				If Localiza(SC9->C9_PRODUTO)
					cDCORIGEM := "SC6"						
					If ! SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC6"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
						cDCORIGEM := "SC0"						
						If ! SDC->( dbSeek(xFilial("SDC")+SC9->C9_PRODUTO+SC9->C9_LOCAL+"SC0"+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN))
							// neste caso nao existe composicao de empenho
							//Grava o historico das geracoes:
							aadd(aLogOS,{"2","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,SC9->C9_ITEM,SC9->C9_PRODUTO,SC9->C9_LOCAL,"Nao existe composicao de empenho (SDC)","NAO_GEROU_OS"}) //"Pedido"###"Nao existe composicao de empenho (SDC)"
							SC9->(DbSkip())
							Loop
						EndIf
					EndIf
				EndIf
				
				If !lLocOrdSep .or. (("03*" $ cTipExp) .and. !("09*" $ cTipExp) .and. lConsNumIt .And. CB7->CB7_NUMITE >=nMaxItens)
					
					cOrdSep := CB_SXESXF("CB7","CB7_ORDSEP",,1)
					ConfirmSX8()
					
					CB7->(RecLock( "CB7",.T.))
					CB7->CB7_FILIAL := xFilial( "CB7" )
					CB7->CB7_ORDSEP := cOrdSep
					CB7->CB7_PEDIDO := cPedido
					CB7->CB7_CLIENT := cCliente
					CB7->CB7_LOJA   := cLoja
					CB7->CB7_COND   := cCondPag
					CB7->CB7_LOJENT := cLojaEnt
					CB7->CB7_LOCAL  := cArm
					CB7->CB7_DTEMIS := dDataBase
					CB7->CB7_HREMIS := Time()
					CB7->CB7_STATUS := " "
					CB7->CB7_CODOPE := cCodOpe
					CB7->CB7_PRIORI := "1"
					CB7->CB7_ORIGEM := "1"
					CB7->CB7_TIPEXP := cTipExp
					CB7->CB7_TRANSP := SC5->C5_TRANSP
					CB7->CB7_AGREG  := cAgreg
					CB7->CB7__PRESEP:= cNumUnic
					CB7->CB7__TRAVA := "S"
					CB7->CB7__SEQPR := 1
					If	ExistBlock("A100CABE")
						ExecBlock("A100CABE",.F.,.F.)
					EndIf
					CB7->(MsUnlock())
					
					aadd(aOrdSep,CB7->CB7_ORDSEP)
				EndIf
				//Grava o historico das geracoes:
				nPos := Ascan(aLogOS,{|x| x[01]+x[02]+x[03]+x[04]+x[05]+x[10] == ("1"+"Pedido"+SC9->(C9_PEDIDO+C9_CLIENTE+C9_LOJA)+CB7->CB7_ORDSEP)})
				If nPos == 0
					aadd(aLogOS,{"1","Pedido",SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"","",cArm,"",CB7->CB7_ORDSEP}) //"Pedido"
				Endif
				
				If Localiza(SC9->C9_PRODUTO)
					While SDC->(! Eof() .and. DC_FILIAL+DC_PRODUTO+DC_LOCAL+DC_ORIGEM+DC_PEDIDO+;
							DC_ITEM+DC_SEQ==xFilial("SDC")+SC9->(C9_PRODUTO+C9_LOCAL + cDCORIGEM + C9_PEDIDO+C9_ITEM+C9_SEQUEN))
						
						SB1->(DBSetOrder(1))
						If SB1->(DbSeek(xFilial("SB1")+SDC->DC_PRODUTO)) .AND. Alltrim(SB1->B1_TIPO) == "MO"
							SDC->(DbSkip())
							Loop
						Endif
						
						CB8->(RecLock("CB8",.T.))
						CB8->CB8_FILIAL := xFilial("CB8")
						CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
						CB8->CB8_ITEM   := SC9->C9_ITEM
						CB8->CB8_PEDIDO := SC9->C9_PEDIDO
						CB8->CB8_PROD   := SDC->DC_PRODUTO
						CB8->CB8_LOCAL  := SDC->DC_LOCAL
						CB8->CB8_QTDORI := SDC->DC_QUANT
						If "09*" $ cTipExp
							CB8->CB8_SLDPRE := SDC->DC_QUANT
						EndIf
						CB8->CB8_SALDOS := SDC->DC_QUANT
						If ! "09*" $ cTipExp .AND. nEmbalagem == 1
							CB8->CB8_SALDOE := SDC->DC_QUANT
						EndIf
						CB8->CB8_LCALIZ := SDC->DC_LOCALIZ
						CB8->CB8_NUMSER := SDC->DC_NUMSERI
						CB8->CB8_SEQUEN := SC9->C9_SEQUEN
						CB8->CB8_LOTECT := SC9->C9_LOTECTL
						CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
						CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
						CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
						If	ExistBlock("ACD100GI")
							ExecBlock("ACD100GI",.F.,.F.)
						EndIf
						CB8->(MsUnLock())
						//Atualizacao do controle do numero de itens a serem impressos
						RecLock("CB7",.F.)
						CB7->CB7_NUMITE++
						CB7->(MsUnLock())
						SDC->( dbSkip() )
					EndDo
				Else
					CB8->(RecLock("CB8",.T.))
					CB8->CB8_FILIAL := xFilial("CB8")
					CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
					CB8->CB8_ITEM   := SC9->C9_ITEM
					CB8->CB8_PEDIDO := SC9->C9_PEDIDO
					CB8->CB8_PROD   := SC9->C9_PRODUTO
					CB8->CB8_LOCAL  := SC9->C9_LOCAL
					CB8->CB8_QTDORI := SC9->C9_QTDLIB
					If "09*" $ cTipExp
						CB8->CB8_SLDPRE := SC9->C9_QTDLIB
					EndIf
					CB8->CB8_SALDOS := SC9->C9_QTDLIB
					If ! "09*" $ cTipExp .AND. nEmbalagem == 1
						CB8->CB8_SALDOE := SC9->C9_QTDLIB
					EndIf
					CB8->CB8_LCALIZ := ""
					CB8->CB8_NUMSER := SC9->C9_NUMSERI
					CB8->CB8_SEQUEN := SC9->C9_SEQUEN
					CB8->CB8_LOTECT := SC9->C9_LOTECTL
					CB8->CB8_NUMLOT := SC9->C9_NUMLOTE
					CB8->CB8_CFLOTE := If("10*" $ cTipExp,"1","2")
					CB8->CB8_TIPSEP := If("09*" $ cTipExp,"1"," ")
					If	ExistBlock("ACD100GI")
						ExecBlock("ACD100GI",.F.,.F.)
					EndIf
					CB8->(MsUnLock())
					
					//Atualizacao do controle do numero de itens a serem impressos
					RecLock("CB7",.F.)
					CB7->CB7_NUMITE++
					CB7->(MsUnLock())
				EndIf
				aadd(aRecSC9,{SC9->(Recno()),CB7->CB7_ORDSEP})
				
				SC9->( dbSkip() )
			EndDo
		EndIf
	Next
	
	//ATUALIZA O CABECALHO DA ONDA COM O NOME DA ONDA
	cNome := Space(20)
	While Empty(cNome)
		@ 100,153 To 329,435 Dialog oDlg Title OemToAnsi("Nome Onda")
		@ 9,9 Say OemToAnsi("Nome") Size 99,8 Of oDlg Pixel
		@ 28,9 Get cNome  Size 79,10 Of oDlg Pixel
		
		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		
		Activate Dialog oDlg Centered
	End
	
	CB7->(DbSetOrder(1))
	For nI := 1 to len(aOrdSep)
		CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
		CB7->(RecLock("CB7"))
		CB7->CB7_STATUS := "0"  // nao iniciado
		CB7->CB7__NOME  := cNome
		CB7->(MsUnlock())
		If	ExistBlock("ACDA100F")
			ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
		EndIf
	Next
	For nI := 1 to len(aRecSC9)
		SC9->(DbGoto(aRecSC9[nI,1]))
		SC9->(RecLock("SC9"))
		SC9->C9_ORDSEP := aRecSC9[nI,2]
		SC9->(MsUnlock())
	Next
	If !Empty(aLogOS)
		ACDRD2Log()
	Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GeraOSepNota  ³ Autor ³ Eduardo Motta     ³ Data ³ 06/04/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera as ordens de separacao a partir dos itens da MarkBrowse³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³GeraOrdSep( ExpC1, ExpL1 )                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 -> Marca da MarkBrowse / ExpL1 -> lInverte MarkBrowse³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ PCHA030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function GeraOSepNota()
	Local cChaveDB
	Local cTipExp
	Local nI
	Local cCodOpe
	Local aRecSD2 := {}
	Local aOrdSep := {}
	Local lFilItens  := ExistBlock("ACDA100I")  //Ponto de Entrada para filtrar o processamento dos itens selecionados
	Local kk		 := 0
	Private aLogOS:= {}
	
	// analisar a pergunta '00-Separcao,01-Separacao/Embalagem,02-Embalagem,03-Gera Nota,04-Imp.Nota,05-Imp.Volume,06-embarque'
	If nEmbSimuNF == 1
		cTipExp := "01*"
	Else
		cTipExp := "00*"
	EndIF
	If nEmbalagNF == 1
		cTipExp += "02*"
	EndIF
	If nImpNotaNF == 1
		cTipExp += "04*"
	EndIF
	If nImpVolNF == 1
		cTipExp += "05*"
	EndIF
	If nEmbarqNF == 1
		cTipExp += "06*"
	EndIF
	/*Ponto de entrada, permite que o usuário realize o processamento conforme suas particularidades.*/
	If	ExistBlock("ACD100VG")
		If ! ExecBlock("ACD100VG",.F.,.F.,)
			Return
		EndIf
	EndIf
	
	SF2->(DbSetOrder(1))
	
	ProcRegua(Len(aDados))
	cCodOpe := cSeparador
	
	For kk:=1 To Len(aDados)
		
		IncProc("Selecionando Notas")
		
		If aDados[kk][2]
			
			dbSelectArea("SD2")
			DbSetOrder(3)
			If !DbSeek(xFilial("SD2")+aDados[kk][3]+aDados[kk][4])
				MsgStop("Nota Fiscal não encontrada "+aDados[kk][3])
				Return
			EndIf
			
			
			While !Eof() .and. SD2->D2_DOC == aDados[kk][3] .And.  SD2->D2_SERIE == aDados[kk][4]
				If !Empty(SD2->D2_ORDSEP)
					SD2->( dbSkip() )
					Loop
				EndIf
				
				cChaveDB :=xFilial("SDB")+SD2->(D2_COD+D2_LOCAL+D2_NUMSEQ+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
				If Localiza(SD2->D2_COD)
					SDB->(dbSetOrder(1))
					If ! SDB->(dbSeek( cChaveDB ))
						// neste caso nao existe composicao de empenho
						//Grava o historico das geracoes:
						aadd(aLogOS,{"2","Nota",SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"Inconsistencia de base, nao existe registro de movimento (SDB)","NAO_GEROU_OS"})				 //"Nota"###"Inconsistencia de base, nao existe registro de movimento (SDB)"
						SD2->(DbSkip())
						Loop
					EndIf
				EndIf
				
				CB7->(DbSetOrder(4))
				If ! CB7->(DbSeek(xFilial("CB7")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_LOCAL+" "))
					CB7->(RecLock( "CB7", .T. ))
					CB7->CB7_FILIAL := xFilial( "CB7" )
					CB7->CB7_ORDSEP := GetSX8Num( "CB7", "CB7_ORDSEP" )
					CB7->CB7_NOTA   := SD2->D2_DOC
					//CB7->CB7_SERIE  := SD2->D2_SERIE
					SerieNfId ("CB7",1,"CB7_SERIE",,,,SD2->D2_SERIE)
					CB7->CB7_CLIENT := SD2->D2_CLIENTE
					CB7->CB7_LOJA   := SD2->D2_LOJA
					CB7->CB7_LOCAL  := SD2->D2_LOCAL
					CB7->CB7_DTEMIS := dDataBase
					CB7->CB7_HREMIS := Time()
					CB7->CB7_STATUS := " "   // gravar STATUS de nao iniciada somente depois do processo
					CB7->CB7_CODOPE := cCodOpe
					CB7->CB7_PRIORI := "1"
					CB7->CB7_ORIGEM := "2"
					CB7->CB7_TIPEXP := cTipExp
					CB7->CB7__PRESEP:= cNumUnic
					CB7->CB7__TRAVA := "S"
					CB7->CB7__SEQPR := 1
					If SF2->(DbSeek(xFilial("SF2")+SD2->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
						CB7->CB7_TRANSP := SF2->F2_TRANSP
					EndIf
					If	ExistBlock("A100CABE")
						ExecBlock("A100CABE",.F.,.F.)
					EndIf
					CB7->(MsUnLock())
					ConfirmSX8()
					//Grava o historico das geracoes:
					aadd(aLogOS,{"1","Nota",SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,"",CB7->CB7_ORDSEP})
					aadd(aOrdSep,CB7->CB7_ORDSEP)
				EndIf
				If Localiza(SD2->D2_COD)
					While SDB->(!Eof() .And. cChaveDB == DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC+DB_SERIE+DB_CLIFOR+DB_LOJA)
						If SDB->DB_ESTORNO == "S"
							SDB->(dbSkip())
							Loop
						EndIf
						CB8->(DbSetorder(4))
						If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+SDB->DB_LOCALIZ+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
							CB8->(RecLock( "CB8", .T. ))
							CB8->CB8_FILIAL := xFilial( "CB8" )
							CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
							CB8->CB8_ITEM   := SD2->D2_ITEM
							CB8->CB8_PEDIDO := SD2->D2_PEDIDO
							CB8->CB8_NOTA   := SD2->D2_DOC
							//CB8->CB8_SERIE  := SD2->D2_SERIE
							SerieNfId ("CB8",1,"CB8_SERIE",,,,SD2->D2_SERIE)
							CB8->CB8_PROD   := SD2->D2_COD
							CB8->CB8_LOCAL  := SD2->D2_LOCAL
							CB8->CB8_LCALIZ := SDB->DB_LOCALIZ
							CB8->CB8_SEQUEN := SDB->DB_ITEM
							CB8->CB8_LOTECT := SD2->D2_LOTECTL
							CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
							CB8->CB8_NUMSER := SD2->D2_NUMSERI
							CB8->CB8_CFLOTE := "1"
							aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
						Else
							CB8->(RecLock( "CB8", .f. ))
						EndIf
						CB8->CB8_QTDORI += SDB->DB_QUANT
						CB8->CB8_SALDOS += SDB->DB_QUANT
						If nEmbalagem == 1
							CB8->CB8_SALDOE += SDB->DB_QUANT
						EndIf
						If	ExistBlock("ACD100GI")
							ExecBlock("ACD100GI",.F.,.F.)
						EndIf
						CB8->(MsUnLock())
						SDB->(dbSkip())
					Enddo
				Else
					CB8->(DbSetorder(4))
					If ! CB8->(DbSeek(xFilial("CB8")+CB7->CB7_ORDSEP+SD2->(D2_ITEM+D2_COD+D2_LOCAL+Space(15)+D2_LOTECTL+D2_NUMLOTE+D2_NUMSERI)))
						CB8->(RecLock( "CB8", .T. ))
						CB8->CB8_FILIAL := xFilial( "CB8" )
						CB8->CB8_ORDSEP := CB7->CB7_ORDSEP
						CB8->CB8_ITEM   := SD2->D2_ITEM
						CB8->CB8_PEDIDO := SD2->D2_PEDIDO
						CB8->CB8_NOTA   := SD2->D2_DOC
						//CB8->CB8_SERIE  := SD2->D2_SERIE
						SerieNfId ("CB8",1,"CB8_SERIE",,,,SD2->D2_SERIE)
						CB8->CB8_PROD   := SD2->D2_COD
						CB8->CB8_LOCAL  := SD2->D2_LOCAL
						CB8->CB8_LCALIZ := Space(15)
						CB8->CB8_SEQUEN := SD2->D2_ITEM
						CB8->CB8_LOTECT := SD2->D2_LOTECTL
						CB8->CB8_NUMLOT := SD2->D2_NUMLOTE
						CB8->CB8_NUMSER := SD2->D2_NUMSERI
						CB8->CB8_CFLOTE := "1"
						aadd(aRecSD2,{SD2->(Recno()),CB7->CB7_ORDSEP})
					Else
						CB8->(RecLock( "CB8", .f. ))
					EndIf
					CB8->CB8_QTDORI += SD2->D2_QUANT
					CB8->CB8_SALDOS += SD2->D2_QUANT
					If nEmbalagem == 1
						CB8->CB8_SALDOE += SD2->D2_QUANT
					EndIf
					If	ExistBlock("ACD100GI")
						ExecBlock("ACD100GI",.F.,.F.)
					EndIf
					CB8->(MsUnLock())
				EndIf
				
				SD2->( dbSkip() )
			EndDo
		EndIf
	Next
	
	//ATUALIZA O CABECALHO DA ONDA COM O NOME DA ONDA
	cNome := Space(20)
	While Empty(cNome)
		@ 100,153 To 329,435 Dialog oDlg Title OemToAnsi("Nome Onda")
		@ 9,9 Say OemToAnsi("Nome") Size 99,8 Of oDlg Pixel
		@ 28,9 Get cNome  Size 79,10 Of oDlg Pixel
		
		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		
		Activate Dialog oDlg Centered
	End
	CB7->(DbSetOrder(1))
	For nI := 1 to len(aOrdSep)
		CB7->(DbSeek(xFilial("CB7")+aOrdSep[nI]))
		CB7->(RecLock("CB7"))
		CB7->CB7_STATUS := "0"  // nao iniciado
		CB7->CB7__NOME  := cNome
		CB7->(MsUnlock())
		If	ExistBlock("ACDA100F")
			ExecBlock("ACDA100F",.F.,.F.,{aOrdSep[nI]})
		EndIf
	Next
	For nI := 1 to len(aRecSD2)
		SD2->(DbGoto(aRecSD2[nI,1]))
		SD2->(RecLock("SD2",.F.))
		SD2->D2_ORDSEP := aRecSD2[nI,2]
		SD2->(MsUnlock())
	Next
	If !Empty(aLogOS)
		ACDRD2Log()
	Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ AtivaF12 ³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 27/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Executa a Funcao da Pergunte                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtivaF12(nOrigExp)
	Local lPerg := .F.
	Local lRet  := .T.
	If	nOrigExp == NIL
		lPerg := .T.
		If	(lRet:=Pergunte("AIA101",.t.))
			nOrigExp := MV_PAR01
		EndIf
	EndIf
	If	lRet
		If	nOrigExp == 1  //Origem: Pedidos de Venda
			If	Pergunte("AIA106",lPerg) .Or. !lPerg
				nConfLote	:= MV_PAR01
				nEmbSimul	:= MV_PAR02
				nEmbalagem	:= MV_PAR03
				If cPaisLoc == "BRA"
					nGeraNota	:= MV_PAR04
					nImpNota	:= MV_PAR05
					nImpEtVol	:= MV_PAR06
					nEmbarque	:= MV_PAR07
					nAglutPed	:= MV_PAR08
					nAglutArm	:= MV_PAR09
				Else
					nImpEtVol	:= MV_PAR04
					nEmbarque	:= MV_PAR05
					nAglutPed	:= MV_PAR06
					nAglutArm	:= MV_PAR07
				EndIf
			EndIf
		ElseIf	nOrigExp == 2  //Origem: Notas Fiscais
			If	Pergunte("AIA107",lPerg) .Or. !lPerg
				nEmbSimuNF := MV_PAR01
				nEmbalagNF := MV_PAR02
				nEmbalagem := MV_PAR02
				nImpNotaNF := MV_PAR03
				nImpVolNF  := MV_PAR04
				nEmbarqNF  := MV_PAR05
			EndIf
		Else  //Origem: Ordens de Producao
			If	Pergunte("AIA108",lPerg) .Or. !lPerg
				nReqMatOP   := MV_PAR01
				nAglutArmOP := MV_PAR02
			EndIf
		EndIf
	EndIf
Return



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
	
	//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  			,cDefSpa2,cDefEng2,cDef03	,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Separador     	?",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par01",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Pedido de 	    ?",""                    ,""                    ,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    ,"SC5",""         ,""   ,"mv_par02",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Pedido Ate		?",""                    ,""                    ,"mv_ch3","C"   ,06      ,0       ,0      , "G",""    ,"SC5",""         ,""   ,"mv_par03",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Cliente de        ?",""                    ,""                    ,"mv_ch4","C"   ,06      ,0       ,0      , "G",""    ,"SA1",""         ,""   ,"mv_par04",""	 	 		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Loja Cliente de   ?",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par05","" 				,""      ,""      ,""    ,""					,""     ,""      ,""			,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Cliente Ate       ?",""                    ,""                    ,"mv_ch6","C"   ,06      ,0       ,0      , "G",""    ,"SA1",""         ,""   ,"mv_par06",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Loja Cliente Ate  ?",""                    ,""                    ,"mv_ch7","C"   ,02      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par07",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Data Liberacao de ?",""                    ,""                    ,"mv_ch8","D"   ,08      ,0       ,0      , "G",""    ,"" 	,""    		,""   ,"mv_par08",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Data Liberacao Ate?",""                    ,""                    ,"mv_ch9","D"   ,08      ,0       ,0      , "G",""    ,"" 	,""  	  	,""   ,"mv_par09",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Pre Separacao		?",""                    ,""                    ,"mv_chb","N"   ,01      ,0       ,0      , "C",""    ,"" 	,""         ,""   ,"mv_par10","Sim"	 	 		,""      ,""      ,""    ,"Não"					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"11"   ,"Transportadora de ?",""                    ,""                    ,"mv_chc","C"   ,06      ,0       ,0      , "G",""    ,"SA4",""         ,""   ,"mv_par11",""				,""      ,""      ,""    ,""					,""     ,""      ,"" 	 		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"12"   ,"Transportadora Ate?",""                    ,""                    ,"mv_chd","C"   ,06      ,0       ,0      , "G",""    ,"SA4",""         ,""   ,"mv_par12",""	 	 		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"13"   ,"Operacao	        ?",""                    ,""                    ,"mv_che","N"   ,01      ,0       ,0      , "C",""    ,"" 	,""         ,""   ,"mv_par13","Cross Docking"	,""      ,""      ,""    ,"Brasil"		  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"14"   ,"Linha	    	    ?",""                    ,""                    ,"mv_chf","N"   ,01      ,0       ,0      , "C",""    ,"" 	,""         ,""   ,"mv_par14","TAIFF"			,""      ,""      ,""    ,"PROART"		  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	
	
	cKey     := "P.ACDR2101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione um separador")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número inicial do pedido  ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número Final do pedido ")
	aAdd(aHelpPor,"ou coloque ZZZZZ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2104."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o cliente inicial ")
	aAdd(aHelpPor,"ou deixe em BRANCO")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2105."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a loja do cliente ")
	aAdd(aHelpPor,"inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2106."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Cliente final ")
	aAdd(aHelpPor,"ou coloque ZZZZZ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2107."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a loja do ")
	aAdd(aHelpPor,"cliente final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2108."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data inicial ")
	aAdd(aHelpPor,"da liberação do pedido")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2109."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data final ")
	aAdd(aHelpPor,"da liberação do pedido ")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2110."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe se tera pre separacao")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2111."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Transportadora ")
	aAdd(aHelpPor,"inicial ou deixe em BRANCO")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2112."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Transportadora ")
	aAdd(aHelpPor,"final ou coloque ZZZZZZ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2113."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe se ")
	aAdd(aHelpPor,"é uma operação de Cross Docking")
	aAdd(aHelpPor,"ou Brasil")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2114."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione linha ")
	aAdd(aHelpPor,"TAIFF ou PROART")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	
Return



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

Static Function Valid2Perg()
	
	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}
	
	//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  			,cDefSpa2,cDefEng2,cDef03	,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c2Perg,"01"   ,"Separador           ?",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par01",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"02"   ,"Nota De             ?",""                    ,""                    ,"mv_ch2","C"   ,09      ,0       ,0      , "G",""    ,"SF2",""         ,""   ,"mv_par02",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"03"   ,"Serie De            ?",""                    ,""                    ,"mv_ch3","C"   ,03      ,0       ,0      , "G",""    ,""	,""         ,""   ,"mv_par03",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"04"   ,"Nota Ate            ?",""                    ,""                    ,"mv_ch4","C"   ,09      ,0       ,0      , "G",""    ,"SF2",""         ,""   ,"mv_par04",""	 	 		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"05"   ,"Serie Ate           ?",""                    ,""                    ,"mv_ch5","C"   ,03      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par05","" 				,""      ,""      ,""    ,""					,""     ,""      ,""			,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"06"   ,"Cliente De          ?",""                    ,""                    ,"mv_ch6","C"   ,06      ,0       ,0      , "G",""    ,"SA1",""         ,""   ,"mv_par06",""		  		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"07"   ,"Loja Cliente De     ?",""                    ,""                    ,"mv_ch7","C"   ,02      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par07",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"08"   ,"Cliente Ate         ?",""                    ,""                    ,"mv_ch8","C"   ,06      ,0       ,0      , "G",""    ,"SA1",""    		,""   ,"mv_par08",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"09"   ,"Loja Cliente Ate    ?",""                    ,""                    ,"mv_ch9","C"   ,02      ,0       ,0      , "G",""    ,"" 	,""  	  	,""   ,"mv_par09",""         		,""      ,""      ,""    ,""      				,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"10"   ,"Data Emissao de     ?",""	                 ,""                    ,"mv_chb","D"   ,08      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par10",""	 	 		,""      ,""      ,""    ,"" 					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"11"   ,"Data Emissao Ate    ?",""                    ,""                    ,"mv_chc","D"   ,08      ,0       ,0      , "G",""    ,""	,""         ,""   ,"mv_par11",""				,""      ,""      ,""    ,""					,""     ,""      ,"" 	 		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"12"   ,"Transportadora de   ?",""                    ,""                    ,"mv_chd","C"   ,06      ,0       ,0      , "G",""    ,"SA4",""         ,""   ,"mv_par12",""	 	 		,""      ,""      ,""    ,""					,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"13"   ,"Transportadora Ate  ?",""                    ,""                    ,"mv_che","C"   ,06      ,0       ,0      , "G",""    ,"SA4",""         ,""   ,"mv_par13",""				,""      ,""      ,""    ,""			  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"14"   ,"Linha               ?",""                    ,""                    ,"mv_chf","N"   ,01      ,0       ,0      , "C",""    ,"" 	,""         ,""   ,"mv_par14","TAIFF"			,""      ,""      ,""    ,"PROART"		  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"15"   ,"UF                  ?",""                    ,""                    ,"mv_chg","C"   ,02      ,0       ,0      , "G",""    ,"" 	,""         ,""   ,"mv_par15",""				,""      ,""      ,""    ,""			  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"16"   ,"Operacao            ?",""                    ,""                    ,"mv_chh","N"   ,01      ,0       ,0      , "C",""    ,"" 	,""         ,""   ,"mv_par16","Cross Docking"	,""      ,""      ,""    ,"Brasil"		  		,""     ,""      ,""    		,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	
	
	cKey     := "P.ACDR2201."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione um separador")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2202."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o número inicial da Nota  ")
	aAdd(aHelpPor,"ou deixe em BRANCO")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2203."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a serie inicial ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2204."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o numero final da nota ")
	aAdd(aHelpPor,"ou coloque ZZZZZZ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2205."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a serie final da nota ")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2206."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Cliente inicial ")
	aAdd(aHelpPor,"ou deixe em BRANCO")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2207."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a loja do ")
	aAdd(aHelpPor,"cliente Iinicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2208."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o cliente final ")
	aAdd(aHelpPor,"ou coloque ZZZZZZ")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2209."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a loja do ")
	aAdd(aHelpPor,"cliente final ")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2210."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data de emissao ")
	aAdd(aHelpPor,"inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2211."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data de emissao ")
	aAdd(aHelpPor,"final")
	aAdd(aHelpPor,"")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	cKey     := "P.ACDR2212."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Transportadora ")
	aAdd(aHelpPor,"inicial ou deixe em BRANCO")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	
	
	cKey     := "P.ACDR2213."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Transportadora ")
	aAdd(aHelpPor,"final ou coloque ZZZZZZ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	
	cKey     := "P.ACDR2214."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a linha ")
	aAdd(aHelpPor,"TAIFF ou PROART")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	
	cKey     := "P.ACDR2215."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe um estado ")
	aAdd(aHelpPor,"ou deixe em BRANCO")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	
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
//ATRASO - "BR_VERMELHO"
//2 DIAS - "BR_VERDE"
//1 DIA  - "BR_AMARELO"

Static Function fColor()
	Local cEntregue
	
	If	nOrigExp == 1 //POR PEDIDO
		//2 DIAS
		If TRB->C9_DATALIB >= dData+2
			Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
		Endif
		
		//1 DIA
		If   TRB->C9_DATALIB == dData +1
			Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
		Endif
		
		//ATRASO
		If  TRB->C9_DATALIB < dData+1
			Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
		Endif
	Else
		//2 DIAS
		If TRB->D2_EMISSAO >= dData+2
			Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
		Endif
		
		//1 DIA
		If   TRB->D2_EMISSAO == dData +1
			Return(LoadBitMap(GetResources(),"BR_AMARELO"   ))
		Endif
		
		//ATRASO
		If  TRB->D2_EMISSAO < dData+1
			Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
		Endif
		
	Endif
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
	Local cQPedido := ""
	
	If nItem = 0
		For nX := 1 TO Len(oListbox:aArray)
			lRet := InverteSel(oListBox,nX, lInverte, lMarca,0)
		Next
	Else
		lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
	EndIf
	
	//EFETUA OS CALCULOS DA TELA
	nADias	:= 0
	n1Dias	:= 0
	n2Dias	:= 0
	nQPed	:= 0
	nQItens	:= 0
	nQVenda := 0
	nPValor	:= 0
	lMais40 := .F.
	For nX := 1 TO Len(oListbox:aArray)
		
		If oListbox:aArray[nX,2]
			If oListbox:aArray[nX,5] >= dData+2
				n2Dias	++
			ElseIf oListbox:aArray[nX,5] == dData+1
				n1Dias	++
			Else//If oListbox:aArray[nX,5] <= dData
				nADias	++
			EndIf
			nQPed	++
			cQPedido += Iif(nQPed >1,"','","")+oListbox:aArray[nX,3]
			nPValor	+= oListbox:aArray[nX,10]
		EndIf
	Next
	If !Empty(cQPedido)
		cQuery := " SELECT COUNT(DISTINCT(C6_PRODUTO)) ITENS, COUNT(C6_PRODUTO) QTITENS, SUM(C6_QTDVEN) QVENDA"
		cQuery += " FROM "+RetSqlName("SC6")+" WITH(NOLOCK)"
		cQuery += " WHERE D_E_L_E_T_ <> '*'
		cQuery += " AND C6_NUM IN ('"+cQpedido+"')
		
		MemoWrite("ACDRD001B.SQL",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBP", .F., .T.)
		
		dbSelectArea("TRBP")
		dbGoTop()
		nQvenda := TRBP->QVENDA
		nQItens := TRBP->ITENS
		nQTItens := TRBP->QTITENS
		TRBP->(dbcloseArea())
	EndIf
	
	oADias:Refresh()
	o1Dias:Refresh()
	o2Dias:Refresh()
	oQPed:Refresh()
	oQItens:Refresh()
	oQTItens:Refresh()
	oQvenda:Refresh()
	oPValor:Refresh()
	oDlgPedidos:Refresh()
	
	
	If nItem > 0
		Return(lRet)
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ACDRD2Log³ Autor ³ Henrique Gomes Oikawa ³ Data ³ 23/09/04 ³±±
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

Static Function ACDRD2Log()
	Local i, j, k
	Local cChaveAtu, cPedCli, cOPAtual
	
	//Cabecalho do Log de processamento:
	AutoGRLog(Replicate("=",75))
	AutoGRLog("                         I N F O R M A T I V O")
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
	Local nTamSX1     := Len(SX1->X1_GRUPO)
	Local aPerg       := {}
	Local aParam      := {}
	Local ni          := 0
	Local ci          := 0
	Local aLogs       := {}
	
	If cTipGer == "Pedido" //"Pedido"
		cPergParam  := PADR('AIA102',nTamSX1)
		cPergConfig := PADR('AIA106',nTamSX1)
		cDescTipGer := 'PEDIDO DE VENDA' //'PEDIDO DE VENDA'
		aAdd(aParam,nConfLote)
		aAdd(aParam,nEmbSimul)
		aAdd(aParam,nEmbalagem)
		aAdd(aParam,nGeraNota)
		aAdd(aParam,nImpNota)
		aAdd(aParam,nImpEtVol)
		aAdd(aParam,nEmbarque)
		aAdd(aParam,nAglutPed)
		aAdd(aParam,nAglutArm)
	Elseif cTipGer == "Nota" //"Nota"
		cPergParam  := PADR('AIA103',nTamSX1)
		cPergConfig := PADR('AIA107',nTamSX1)
		cDescTipGer := 'NOTA FISCAL' //'NOTA FISCAL'
		aAdd(aParam,nEmbSimuNF)
		aAdd(aParam,nEmbalagNF)
		aAdd(aParam,nImpNotaNF)
		aAdd(aParam,nImpVolNF)
		aAdd(aParam,nEmbarqNF)
	Else //OP
		cPergParam  := PADR('AIA104',nTamSX1)
		cPergConfig := PADR('AIA108',nTamSX1)
		cDescTipGer := 'ORDEM DE PRODUCAO' //'ORDEM DE PRODUCAO'
		aAdd(aParam,nReqMatOP)
		aAdd(aParam,nAglutArmOP)
	Endif
	
	aAdd(aPerg,{"P A R A M E T R O S : "+cDescTipGer,cPergParam}) //"P A R A M E T R O S : "
	aAdd(aPerg,{"C O N F I G U R A C O E S : "+cDescTipGer,cPergConfig}) //"C O N F I G U R A C O E S : "
	//-- Carrega parametros SX1
	SX1->(DbSetOrder(1))
	For ni := 1 To Len(aPerg)
		ci := 1
		aAdd(aLogs,{aPerg[ni,2],{}})
		SX1->(DbSeek(aPerg[ni,2]))
		While SX1->(!Eof() .AND. X1_GRUPO == aPerg[ni,2])
			If	SX1->X1_GSC == 'G'
				cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+Alltrim(X1_CNT01)) //"Pergunta "
			Else
				If	ni == 1
					cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(X1_PRESEL==1,'Sim','Nao')) //"Pergunta "###'Sim'###'Nao'
				Else
					cTexto := SX1->("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(aParam[ci++]==1,'Sim','Nao')) //"Pergunta "###'Sim'###'Nao'
				EndIf
			EndIf
			aAdd(aLogs[ni,2],cTexto)
			SX1->(dbSkip())
		EndDo
	Next
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
	
	Local lOk := .F.
	Local nX	:= 0
	
	For nX := 1 TO Len(oListbox:aArray)
		If Alltrim(oListbox:aArray[nX,3]) == AllTrim(cPesq)
			MarcaTodos(oListBox, .F., .T.,1,nX)
			lOk := .T.
			oListBox:Refresh()
		EndIf
	Next
	
	If !lOk
		MsgAlert("O pedido digitado não foi encontrado!","Atenção - WMSMI001")
	Endif
	
Return(lOk)



/*
SALDO DO PEDIDO
*/

STATIC FUNCTION VERSLD(CPEDIDO)
	
	LOCAL NRET 	:= 0
	LOCAL CQUERY 	:= ""
	
	CQUERY := "SELECT" 															+ ENTER
	CQUERY += "	ISNULL(SUM(C6_QTDVEN) - SUM(C6_QTDENT),0) AS C6_SALDO" 	+ ENTER
	CQUERY += "FROM" 																+ ENTER
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 								+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5 ON"				+ ENTER
	CQUERY += "		SC5.C5_FILIAL = SC6.C6_FILIAL AND" 					+ ENTER
	CQUERY += "		SC5.C5_NUM = SC6.C6_NUM AND" 							+ ENTER
	CQUERY += "		SC5.C5_NUMOLD = '" + CPEDIDO + "' AND" 				+ ENTER
	CQUERY += "		SC5.D_E_L_E_T_ = ''" 									+ ENTER
	CQUERY += "WHERE" 															+ ENTER
	CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL ("SC6") + "' AND" 			+ ENTER
	CQUERY += "	SC6.D_E_L_E_T_ = ''"
	
	MEMOWRITE("ACDRD002_SALDO_DO_PEDIDO_VERSLD.SQL",CQUERY)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,CQUERY), 'SLD', .F., .T.)
	
	Count To nRec
	
	If nRec == 0
	ELSE
		SLD->(DbGotop())
		IF SLD->C6_SALDO > 0
			
			NRET := SLD->C6_SALDO
			
		ENDIF
	EndIf
	
	SLD->(DbCloseArea())
	
RETURN NRET


STATIC FUNCTION BNFSLD(CPEDIDO)

LOCAL NRET 	:= 0 
LOCAL CQUERY 	:= ""

CQUERY := "SELECT"	+ ENTER 
CQUERY += "	ISNULL(SUM(C9_QTDLIB),0) AS C9_SALDO" 	+ ENTER 
CQUERY += "FROM" + ENTER 
CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 								+ ENTER
CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5BNF ON"				+ ENTER
CQUERY += "		SC5BNF.C5_FILIAL = '" + xFilial("SC5") + "' AND" 					+ ENTER 
CQUERY += "		SC5BNF.C5_NUM = '" + CPEDIDO + "' AND" 				+ ENTER 	 
CQUERY += "		SC5BNF.D_E_L_E_T_ = ''" 									+ ENTER  
CQUERY += "	INNER JOIN " + RETSQLNAME("SC5")  + " SC5 ON"				+ ENTER
CQUERY += "		SC5.C5_FILIAL = SC9.C9_FILIAL AND" 					+ ENTER 
CQUERY += "		SC5.C5_NUM = SC9.C9_PEDIDO AND" 							+ ENTER
CQUERY += "		SC5.C5_NUMOLD = RTRIM(LTRIM(SC5BNF.C5_X_PVBON)) AND" 				+ ENTER 	 
CQUERY += "		SC5.D_E_L_E_T_ = ''" 									+ ENTER  
CQUERY += "WHERE" 															+ ENTER 
CQUERY += "	SC9.C9_FILIAL = '" + XFILIAL ("SC9") + "'" 			+ ENTER  
CQUERY += "	AND SC9.D_E_L_E_T_ = ''" + ENTER
CQUERY += "	AND SC9.C9_DATALIB = '" + DTOS(DDATABASE) + "'" 			+ ENTER  

MEMOWRITE("M460MARK_SALDO_NA_SC9_DA_BONIFIC.SQL",CQUERY)

IF SELECT("SLDC9") > 0 
	
	DBSELECTAREA("SLDC9")
	DBCLOSEAREA()
	
ENDIF 

dbUseArea(.T., "TOPCONN", TCGenQry(,,CQUERY), 'SLDC9', .F., .T.)

Count To nRec

If nRec == 0
ELSE
	DBSELECTAREA("SLDC9")
	DBGOTOP()
	
	IF SLDC9->C9_SALDO > 0 
		
		NRET := SLDC9->C9_SALDO
		
	ENDIF 
EndIf

SLDC9->(DbCloseArea())

RETURN NRET
