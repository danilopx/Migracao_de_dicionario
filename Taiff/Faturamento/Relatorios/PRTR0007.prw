#Include "Protheus.ch"
#include "topconn.ch"

/***************************************************************************************
*| Funcao		: PEDSEP
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Responsavel pela geracao do Relatorio de Pedidos em Separacao
*| Uso			: Especifico Proart
***************************************************************************************/
User Function PRTR0007()

	Private cPerg     := "PEDSEPa"
	Private cRetTPINC := ""

//Cria perguntas caso não existam
	fCriaSx1()

//Chama tela de perguntas, caso cancele, não executar relatorio
	If Pergunte(cPerg,.T.)
		If SimNao("Confirma geração da planilha 'Pedidos em Separação' ?") == "S"
			Processa({ |lEnd| fFilDados(@lEnd),OemToAnsi("Criando cabeçalho, aguarde...")}, OemToAnsi("Aguarde..."))
		EndIf
	EndIf

Return

/***************************************************************************************
*| Funcao		: fFilDados
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Obtem dados do relatorio atraves de consulta SQL, realiza calculo de
*|					totais e porcentagens, gera codigo html do corpo do relatorio,
*|					monta html completo e abre MSExcel para exibição.
***************************************************************************************/
Static Function fFilDados(lEnd)

	Local cQuery 		:= ""
	Local cOrdm  		:= "01"
	Local cHtmlOk	 	:= ""
	Local cArq   		:= "  "
	Local lLoop  		:= .T.
	Local nArq   		:= Nil
	Local nContBg 		:= 01
	Local nCxFrCol 		:= 0 		//caixa fracionada a coletar
	Local nCxFrConf 	:= 0		//caixa fracionada a conferir
	Local nCxFcConf		:= 0		//caixa fechada a conferir
	Local nTotFrCol		:= 0		//total geral de cxs fracionadas a coletar
	Local nTotFrConf	:= 0		//total geral de cxs fracionadas a conferir
	Local nTotFcConf	:= 0		//total geral de cxs fechadas a conferir
	Local cPedido		:= ""
	Local cPedidoAnt	:= ""
	Local cLibera		:= ""
	Local cLibAnt		:= ""
	Local nTotalFrac	:= 0		//total de cxs fracionadas no pedido
	Local nTotFracGer	:= 0		//total geral de cxs fracionadas
	Local nTotalFech	:= 0		//total de cxs fechadas no pedido
	Local nTotFechGer	:= 0		//total geral de cxs fechadas
	Local nRealFrac		:= 0		//porc realizada cxs fracionadas por pedido
	Local nRealFech		:= 0		//porc realizada cxs fechadas por pedido
	Local nRealTot		:= 0		//porc realizada por pedido
	Local nFracGeral	:= 0		//porc realizada cxs fracionadas geral
	Local nFechGeral	:= 0		//porc realizada cxs fechadas geral
	Local nTotGeral		:= 0		//porc realizada geral
	Local nValorItem	:= 0		//soma dos totais por item
	Local nSomaTot		:= 0		//soma dos totais (R$) de todos os pedidos
	Local nTempo		:= 0
	Local aStruFinal	:= {}
	Local cHrIni		:= ""
	Local cHrFim		:= ""
	Local dDtIni		:= ""
	Local dDtFim		:= ""
	Local nDias			:= 0
	Local cPeriodoTot	:= ""
	Local nPedidos		:= 0
	Local x				:= 0
	Local y				:= 0

	Private cPath  		:= AllTrim(GetTempPath())

	While lLoop
		If File(cPath+"PedSeparacao"+cOrdm+".html")
			cOrdm := AllTrim(Soma1(cOrdm))
		Else
			lLoop := .F.
		EndIf
	End

	cArq   := cPath+"PedSeparacao"+cOrdm+".html"
	nArq   := fCreate(cArq,0)

	cQuery := " SELECT "+CRLF
	cQuery += "	CONVERT(VARCHAR(10),CONVERT(DATETIME,C9_DATALIB),103) AS DT_LIBERACAO"+CRLF
	cQuery += " ,ZZF_TPSEP AS TIPO "+CRLF
	cQuery += " ,ZZF_PEDIDO AS PEDIDO "+CRLF
	cQuery += " ,SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) AS EMISSAO "+CRLF
	cQuery += " ,A1_NOME AS CLIENTE "+CRLF
	cQuery += " ,A4_NOME AS TRANSP "+CRLF
	cQuery += " ,A1_MUN AS MUNICIPIO "+CRLF
	cQuery += " ,A1_EST AS UF "+CRLF
	cQuery += " ,(CASE WHEN ZC1_DATAOF = '' OR  ZC1_HORAOF = '' THEN (SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4) + ' 00:00') ELSE (SUBSTRING(ZC1_DATAOF,7,2)+'/'+SUBSTRING(ZC1_DATAOF,5,2)+'/'+SUBSTRING(ZC1_DATAOF,1,4) + ' ' + (SUBSTRING(ZC1_HORAOF, 1, 2) + ':' + SUBSTRING(ZC1_HORAOF, 3, 2))) END) AS HORA_INI "+CRLF
	cQuery += " ,(CASE WHEN (ISNULL(F2_EMISSAO,'') = '' OR  ISNULL(F2_HORA,'') = '' ) --NOTA NAO EMITIDA PEGAR HORA ATUAL  "+CRLF
	cQuery += " 			THEN CONVERT(VARCHAR(20), GETDATE(), 103) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 108),1,5) "+CRLF
	cQuery += " 		WHEN NOT(ISNULL(F2_EMISSAO,'') = '' OR  ISNULL(F2_HORA,'') = '' ) AND ZZF_YDFCNF = '' --NOTA EMITIDA MAS SEM CONFERENCIA - FATURAMENTO ANTECIPADO - PEGAR HORA ATUAL "+CRLF
	cQuery += " 			THEN CONVERT(VARCHAR(20), GETDATE(), 103) + ' ' + SUBSTRING(CONVERT(VARCHAR(20), GETDATE(), 108),1,5) "+CRLF
	cQuery += "		 	WHEN ((F2_EMISSAO+SUBSTRING(F2_HORA,1,2)+SUBSTRING(F2_HORA,4,2)) < (ZZF_YDFCNF+SUBSTRING(ZZF_YHFCNF,1,2)+SUBSTRING(ZZF_YHFCNF,4,2))  )  AND (NOT(ISNULL(F2_EMISSAO,'') = '' OR  ISNULL(F2_HORA,'') = '' ) AND ZZF_YDFCNF <> '')--FATURAMENTO ANTECIPADO CONCLUIDO "+CRLF
	cQuery += " 			THEN (SUBSTRING(ZZF_YDFCNF,7,2)+'/'+SUBSTRING(ZZF_YDFCNF,5,2)+'/'+SUBSTRING(ZZF_YDFCNF,1,4) + ' ' + (SUBSTRING(ZZF_YHFCNF, 1, 2) + ':' + SUBSTRING(ZZF_YHFCNF, 4, 2))) "+CRLF
	cQuery += " 		WHEN  ((F2_EMISSAO+SUBSTRING(F2_HORA,1,2)+SUBSTRING(F2_HORA,4,2)) >= (ZZF_YDFCNF+SUBSTRING(ZZF_YHFCNF,1,2)+SUBSTRING(ZZF_YHFCNF,4,2))  )  AND (NOT(ISNULL(F2_EMISSAO,'') = '' OR  ISNULL(F2_HORA,'') = '' ) AND ZZF_YDFCNF <> '')--FATURAMENTO ANTECIPADO CONCLUIDO--FATURAMENTO NORMAL "+CRLF
	cQuery += "				THEN (SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) + ' ' + (SUBSTRING(F2_HORA, 1, 2) + ':' + SUBSTRING(F2_HORA, 4, 2))) "+CRLF
	cQuery += " END) AS HORA_FIM "+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'F' THEN '0' WHEN SUM(ZZG_QUANT) <> SUM(ZZG_QTDSEP) AND ZZF_YDFCNF = '' THEN '1' ELSE '0' END) AS CFRCOL "+CRLF
	cQuery += " ,(CASE WHEN SUM(ZZG_QUANT) = SUM(ZZG_QTDSEP) AND ZZF_YDFCNF = '' AND ZZF_TPSEP = 'S' THEN '1' ELSE '0' END) AS CFRCNF"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '0' WHEN ZZF_YDFCNF = '' THEN '1' ELSE '0' END) AS CFCCNF"+CRLF
	cQuery += " ,F2_DOC AS NOTAFISCAL "+CRLF
	cQuery += " ,SUBSTRING(F2_DTEMB,7,2)+'/'+SUBSTRING(F2_DTEMB,5,2)+'/'+SUBSTRING(F2_DTEMB,1,4) AS EXPEDICAO "+CRLF
	cQuery += " ,ZZF_DHCALC AS LIBERACAO "+CRLF
	cQuery += " ,CONVERT(DECIMAL(16,2), SUM(ZZG_QUANT*C9_PRCVEN)) AS VALOR  "+CRLF
	cQuery += " FROM "+RetSqlName("ZZF")+" ZZF "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("ZZG")+" ZZG "+CRLF
	cQuery += " ON ZZF_FILIAL = ZZG_FILIAL AND ZZF_PEDIDO = ZZG_PEDIDO AND ZZF_SEQCX = ZZG_SEQCX AND ZZF_DHCALC = ZZG_DHCALC AND ZZG.D_E_L_E_T_ = '' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 "+CRLF
	cQuery += " ON C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = ZZF_PEDIDO AND SC5.D_E_L_E_T_ = '' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SC9")+" SC9" +CRLF
	cQuery += " ON C9_FILIAL = '"+xFilial('SC9')+"' AND SC9.R_E_C_N_O_ = ZZG_SC9 AND SC9.D_E_L_E_T_ = '' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery += " ON A1_FILIAL = '"+xFilial('SA1')+"' AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND SA1.D_E_L_E_T_ = '' "+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SA4")+" SA4 "+CRLF
	cQuery += " ON A4_FILIAL = '"+xFilial('SA4')+"' AND A4_COD = C5_TRANSP AND SA4.D_E_L_E_T_ = '' "+CRLF
	cQuery += " LEFT OUTER JOIN "+RetSqlName("ZC1")+" ZC1  "+CRLF
 	cQuery += " ON ZC1_FILIAL = '"+xFilial('ZC1')+"' AND ZC1_PEDIDO = ZZF_PEDIDO AND ZC1.D_E_L_E_T_ = '' "+CRLF
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SF2")+" SF2 "+CRLF
	cQuery += " ON F2_FILIAL = '"+xFilial('SF2')+"' AND F2_DOC = C9_NFISCAL AND F2_SERIE = C9_SERIENF AND SF2.D_E_L_E_T_ = '' "+CRLF

	//Data Expedição de / ate
	If !Empty(mv_par11) .And. !Empty(mv_par12)
		cQuery += " AND F2_EMISSAO >= '"+DtoS(mv_par11)+"' "+CRLF
		cQuery += " AND F2_EMISSAO <= '"+DtoS(mv_par12)+"' "+CRLF
	EndIf

	cQuery += " WHERE ZZF_FILIAL = '"+xFilial('ZZF')+"' AND ZZF.D_E_L_E_T_ = ''"+CRLF

//Pedido de / ate
	If !Empty(mv_par01) .And. !Empty(mv_par02)
		cQuery += " AND ZZF_PEDIDO >= "+fTrataQbra(mv_par01)+" "+CRLF
		cQuery += " AND ZZF_PEDIDO <= "+fTrataQbra(mv_par02)+" "+CRLF
	EndIf

//Data Emissão de / ate
	If !Empty(mv_par03) .And. !Empty(mv_par04)
		cQuery += " AND C5_EMISSAO >= '"+DtoS(mv_par03)+"' "+CRLF
		cQuery += " AND C5_EMISSAO <= '"+DtoS(mv_par04)+"' "+CRLF
	EndIf

//Cliente de / ate
	If !Empty(mv_par05) .And. !Empty(mv_par06)
		cQuery += " C5_CLIENTE >= "+fTrataQbra(mv_par05)+" "+CRLF
		cQuery += " C5_CLIENTE <= "+fTrataQbra(mv_par06)+" "+CRLF
	EndIf

//Transportadora de / ate
	If !Empty(mv_par07) .And. !Empty(mv_par08)
		cQuery += " AND C5_TRANSP >= "+fTrataQbra(mv_par07)+" "+CRLF
		cQuery += " AND C5_TRANSP <= "+fTrataQbra(mv_par08)+" "+CRLF
	EndIf

//NF de / ate
	If !Empty(mv_par09) .And. !Empty(mv_par10)
		cQuery += " AND C5_NOTA >= "+fTrataQbra(mv_par09)+" "+CRLF
		cQuery += " AND C5_NOTA <= "+fTrataQbra(mv_par10)+" "+CRLF
	EndIf

//DT. Libera de / ate
	If !Empty(mv_par14) .And. !Empty(mv_par15)
		cQuery += " AND C9_DATALIB >= '"+Dtos(mv_par14)+"' "+CRLF
		cQuery += " AND C9_DATALIB <= '"+Dtos(mv_par15)+"' "+CRLF
	EndIf

	cQuery += " GROUP BY ZZF_PEDIDO, ZZF_SEQCX, C5_EMISSAO, A1_EST, A1_NOME, A1_MUN,  A4_NOME,  ZZF_TPSEP,  ZZF_YDFCNF,ZZF_YHFCNF, F2_DOC, ZC1_DATAOF, ZC1_HORAOF, F2_EMISSAO, F2_HORA, ZZF_DHCALC ,F2_DTEMB, C9_DATALIB "+CRLF
	cQuery += " ORDER BY ZZF_PEDIDO, F2_DOC, ZZF_DHCALC, ZZF_SEQCX "+CRLF

//Fecha Alias se estiver em uso
	If Select("SQL") > 0
		SQL->(dbCloseArea())
	Endif

	//MemoWrite("PRTR0007-SELECIONA PEDIDOS.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL", .F., .T.)
	nContaRegs := 0
	Count To nContaRegs

//Carrega HTML
	cHtmlOk := fHtmlCabec()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Carrega HTML
	cHtmlOk := fHtmlCorpo(1)
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	aStruSQL := {}

//Barra processamento
	DbSelectArea("SQL")
	SQL->(DbGoTop())

	ProcRegua(nContaRegs)
	SQL->(DbGoTop())

/***************************************************************************************
*| Carrega dados da Query no array
***************************************************************************************/

	Do While SQL->(!Eof())

		aAdd( aStruSQL , {;
			SQL->TIPO,; //1
		SQL->PEDIDO,; //2
		SQL->EMISSAO,; //3
		SQL->CLIENTE,; //4
		SQL->TRANSP,; //5
		SQL->MUNICIPIO,; //6
		SQL->UF,; //7
		SQL->HORA_INI,; //8
		SQL->HORA_FIM,; //9
		SQL->CFRCOL,; //10
		SQL->CFRCNF,; //11
		SQL->CFCCNF,; //12
		SQL->NOTAFISCAL,; //13
		SQL->EXPEDICAO,; //14
		SQL->LIBERACAO,; //15
		SQL->VALOR,; //16
		SQL->DT_LIBERACAO; //17 - C9_DATALIB
		} )

		SQL->(DbSkip())
	Enddo

/***************************************************************************************
*| obtem e calcula dados, pedido a pedido
***************************************************************************************/
	nPedidos := 0
	For y:=1 To Len(aStruSQL)

		IncProc("Gerando arquivo Excel. Aguarde...")

		cPedido := aStruSQL[y][2] //036754
		cLibera := aStruSQL[y][15] // ''

		If ((cPedido <> cPedidoAnt) .Or. (cPedido == cPedidoAnt .And. cLibera <> cLibAnt)) //pedido e liberacao ainda não foi verificado
			
			For x:=1 To Len(aStruSQL) //percorre todas as linhas do array

				If (aStruSQL[x][2] == cPedido .And. aStruSQL[x][15] == cLibera) //pedido sendo verificado é o mesmo da linha atual (x)?

					If !Empty(aStruSQL[x][8])
						dDtIni := ctod(Substr(aStruSQL[x][8], 1, 10))
						cHrIni := Substr(aStruSQL[x][8], 12, 5)
					EndIf

					If !Empty(aStruSQL[x][9])
						dDtFim := ctod(Substr(aStruSQL[x][9], 1, 10))
						cHrFim := Substr(aStruSQL[x][9], 12, 5)
					EndIf

					nCxFrCol += Val(aStruSQL[x][10]) 		// CFRCOL - fracionada a coletar
					nCxFrConf += Val(aStruSQL[x][11])		// CFRCNF - fracionada a conferir
					nCxFcConf += Val(aStruSQL[x][12])		// CFCCNF - fechada a conferir

					If(aStruSQL[x][1] == "S") // TIPOS: "S" -> fracionada; "F" -> fechada
						nTotalFrac++  // CFRTOT - total de caixas fracionadas
					Else
						nTotalFech++	// CFCTOT - total de caixas fechadas
					EndIf

					nValorItem += aStruSQL[x][16]

				EndIf

			Next x

		//realiza calculo de total realizado (%) (cx fracionada)
			If (nTotalFrac > 0)
				nRealFrac := 100 - ((((nCxFrCol) + (nCxFrConf)) * 100.0) / nTotalFrac)
			EndIf
		//realiza calculo de total realizado (%) (cx fechada)
			If (nTotalFech > 0)
				nRealFech := 100 - ((nCxFcConf * 100.0) / nTotalFech)
			EndIf
		//realiza calculo de total realizado (%) (geral)
			If (nTotalFech > 0 .Or. nTotalFrac > 0)
				nRealTot := 100 - (((nCxFrCol + nCxFrConf + nCxFcConf) * 100.0) / (nTotalFrac + nTotalFech))
			EndIf

		//realiza calculo de tempo total
			If !Empty(dDtIni) .And. !Empty(dDtFim)
				nTempo := fPeriodoTotal(cHrIni, cHrFim, dDtIni, dDtFim)
				nDias := Int(nTempo / 24)
				nTempo := nTempo - (nDias * 24)
				//forma string para exibicao
				If nDias > 0
					cPeriodoTot := CvalToChar(nDias) + " dia(s), " + CvalToChar(Int(nTempo)) + " hora(s) e " + PADR(Substr(CvalToChar(nTempo - Int(nTempo)), 3, 2),2,"0") + " minuto(s)"
				Else
					cPeriodoTot := CvalToChar(Int(nTempo)) + " hora(s) e " + PADR(Substr(CvalToChar(nTempo - Int(nTempo)), 3, 2),2,"0") + " minuto(s)"
				EndIf
			EndIf


		//total de caixas fracionadas, fracionadas a coletar, fracionadas a conferir, fechadas e fechadas a conferir, para formar a linha de totais
			nTotFrCol	+= nCxFrCol
			nTotFrConf	+= nCxFrConf
			nTotFcConf	+= nCxFcConf
			nTotFracGer += nTotalFrac
			nTotFechGer += nTotalFech
			nSomaTot += nValorItem

		/***************************************************************************************
		*| adiciona dados do pedido nem array, para possibilitar ordenação futura
		***************************************************************************************/
			aAdd( aStruFinal , { AllTrim(aStruSQL[y][2]), AllTrim(aStruSQL[y][3]), AllTrim(aStruSQL[y][4]), AllTrim(aStruSQL[y][5]), AllTrim(aStruSQL[y][6]),;
				AllTrim(aStruSQL[y][7]), cPeriodoTot, AllTrim(Transform(nValorItem, "@E 999,999.99")), CvalToChar(nCxFrCol), CvalToChar(nCxFrConf), CvalToChar(nTotalFrac),;
				CvalToChar(NoRound(nRealFrac, 2)), CvalToChar(nCxFcConf), CvalToChar(NoRound(nTotalFech, 2)), CvalToChar(nRealFech), CvalToChar(NoRound(nRealTot, 2)),;
				AllTrim(aStruSQL[y][13]), AllTrim(aStruSQL[y][14]), AllTrim(aStruSQL[y][17]) } )

	 	//limpa variaveis para o proximo pedido
			nCxFrCol 	:= 0
			nCxFrConf 	:= 0
			nTotalFrac	:= 0
			nRealFrac 	:= 0
			nRealFech 	:= 0
			nCxFcConf 	:= 0
			nValorItem	:= 0
			nTotalFech	:= 0
			nRealTot 	:= 0
			nTempo		:= 0
			cHrIni		:= ""
			cHrFim		:= ""
			dDtIni		:= ""
			dDtFim		:= ""
			cPeriodoTot	:= ""

			cPedidoAnt	:= cPedido
			cLibAnt	:= cLibera
			
			nPedidos++

		EndIf

	Next y

/***************************************************************************************
*| realiza calculo da ultima linha do relatorio, com totais gerais
***************************************************************************************/
//realiza calculo de total realizado geral (%) (cx fracionada)
	If(nTotFracGer > 0)
		nFracGeral := 100 - ((((nTotFrCol) + (nTotFrConf)) * 100.0) / nTotFracGer)
	EndIf
//realiza calculo de total realizado geral (%) (cx fechada)
	If(nTotFechGer > 0)
		nFechGeral := 100 - ((nTotFcConf * 100.0) / nTotFechGer)
	EndIf
//realiza calculo de total realizado geral (%) (geral)
	If(nTotFechGer > 0 .Or. nTotFracGer > 0)
		nTotGeral := 100 - (((nTotFrCol + nTotFrConf + nTotFcConf) * 100.0) / (nTotFracGer + nTotFechGer))
	EndIf

/***************************************************************************************
*| Ordena array, de acordo com o filtro selecionado
***************************************************************************************/
	If (mv_par13 == 2)
	//decrescente por caixas fracionadas a coletar/conferir (pendentes)
		aSort(aStruFinal,,, { |x, y| (Val(x[8]) + Val(x[9])) > (Val(y[8]) + Val(y[9])) })
	EndIf
	If (mv_par13 == 3)
	//decrescente por caixas fechadas a conferir
		aSort(aStruFinal,,, { |x, y| Val(x[12]) > Val(y[12]) })
	EndIf

/***************************************************************************************
*| gera HTML dos itens
***************************************************************************************/
	For y:=1 To Len(aStruFinal)
	//Define cor de fundo da linha
		nContBg ++
		If nContBg%2 == 0
			cBgClr := "#FFFFFF"
		Else
			cBgClr := "#B5CDE5"
		EndIf

		cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:10px"> '
		For x:=1 To 19

			If x = 12 .Or. x = 15
				cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090">' + aStruFinal[y][x] +'&nbsp;</td> '
			Else
				cHtmlOk += CRLF+' 	<td align="left">' + aStruFinal[y][x] +'&nbsp;</td> '
			EndIf

		Next x

		cHtmlOk += CRLF+' </tr> '

	//Carrega HTML
		FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	Next y

/***************************************************************************************
*| gera HTML da ultima linha, com total geral
***************************************************************************************/
	cHtmlOk := CRLF+' <tr bgcolor="#708090" valign="middle" align="center" style=" font-family:Tahoma; font-size:10px"> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>Total&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>Quantidade de Pedidos: ' + AllTrim(Transform(nPedidos, "@E 999,999,999")) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090" colspan="5">&nbsp;</td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + AllTrim(Transform(nSomaTot, "@E 999,999.99")) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(nTotFrCol) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(nTotFrConf) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(nTotFracGer) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(NoRound(nFracGeral, 2)) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(nTotFcConf) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(nTotFechGer) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090"><b>' + CvalToChar(NoRound(nFechGeral, 2)) + '&nbsp;</b></td> '
	cHtmlOk += CRLF+' 	<td align="left" bgcolor="#708090" colspan="4">&nbsp;</td> '
	cHtmlOk += CRLF+' </tr> '

//Carrega HTML
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Carrega HTML
	cHtmlOk := fHtmlCorpo(2)
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	cHtmlOk := fLegenda()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Carrega HTML
	cHtmlOk := fHtmlRodap()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Fecha Arquivo
	fClose(nArq)

//Fecha Alias
	SQL->(dbCloseArea())

//Verifica se existe excel instalado e abre em excel,
//caso não existe abrir no internet explorer
	If ApOleClient("MsExcel")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cArq)
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		ShellExecute("open",cArq,"","",1)
	EndIf

Return()

/***************************************************************************************
*| Funcao		: fHtmlCabec
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Forma o cabecalho do doc html, ate linha anterior a tabela
*|
*| Retorno		: string em html do cabecalho
***************************************************************************************/

Static Function fHtmlCabec()

	Local cHtml := ""

	cHtml += CRLF+' <html> '
	cHtml += CRLF+' <head> '
	cHtml += CRLF+' <title>&nbsp;</title> '
	cHtml += CRLF+' </head> '
	cHtml += CRLF+' <body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" link="#000000" vlink="#000000" alink="#000000"> '
	cHtml += CRLF+' <!-- CABEÇALHO --> '
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="90" width="25%" colspan="2" rowspan="6" align="center" valign="middle"><img src="\\192.168.0.8\Protheus10\Protheus_desenv01\system\lglr030100.jpg"></img></td> '
	cHtml += CRLF+' 		<td height="90" width="50%" colspan="4" rowspan="6" align="center" valign="middle"><b>PEDIDOS EM SEPARAÇÃO</b></td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%">&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%">&nbsp;</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="25%" colspan="2" align="center"><b>Dados da Emissão</b></td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="right">Data:&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="left">&nbsp;'+DtoC(Date())+'</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="right">Hora:&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="left">&nbsp;'+Time()+'</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="right">Usuário:&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="left">&nbsp;'+AllTrim(cUserName)+'</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="right">Local:&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="left">&nbsp;'+alltrim(cPath)+'</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="right">&nbsp;</td> '
	cHtml += CRLF+' 		<td height="15" width="12.5%" align="left">&nbsp;</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' </table> '
	cHtml += CRLF+' <!-- UMA LINHA PARA ESPAÇO --> '
	cHtml += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="15" colspan="8">&nbsp;</td> '
	cHtml += CRLF+' 	</tr> '
	cHtml += CRLF+' </table> '

Return(cHtml)

/***************************************************************************************
*| Funcao		: fHtmlCorpo
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Forma cabecalho da tabela em HTML
*|
*| Parametros 	: nTrch -> 	0 - mantem linha e tabela aberta (tr e table)
*|								1 - fecha linha da tabela (tr)
*|								2 - fecha tabela (table)
*|
*| Retorno		: texto em html
***************************************************************************************/
Static Function fHtmlCorpo(nTrch)

	Local cHtml   := ""
	Local cHtmlA  := ""
	Local cHtmlB  := ""
	Default nTrch := 0


	/***************************************************************************************/
	cHtmlA += CRLF+' <!-- DETALHAMENTO -->'
	cHtmlA += CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#000000" bordercolordark="#FFFFFF">'
	cHtmlA += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090">'

	cHtmlA += CRLF+' 		<td colspan="8"></td>'
	cHtmlA += CRLF+' 		<td colspan="4"><b>&nbsp;CAIXAS FRACIONADAS&nbsp;</b></td>'
	cHtmlA += CRLF+' 		<td colspan="3"><b>&nbsp;CAIXAS FECHADAS&nbsp;</b></td>'
	cHtmlA += CRLF+' 		<td rowspan="2" valign="middle"><b>&nbsp;TOTAL REALIZADO (%)&nbsp;</b></td>'
	cHtmlA += CRLF+' 		<td rowspan="2" valign="middle"><b>&nbsp;NOTA FISCAL&nbsp;</b></td>'
	cHtmlA += CRLF+' 		<td rowspan="2" valign="middle"><b>&nbsp;DATA EXPEDI&Ccedil;&Atilde;O&nbsp;</b></td>'
	cHtmlA += CRLF+' 		<td rowspan="2" valign="middle"><b>&nbsp;DATA LIBERA&Ccedil;&Atilde;O&nbsp;</b></td>'

	cHtmlA += CRLF+' 	</tr>'
	cHtmlA += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090">'

	cHtmlA += CRLF+' 		<td>&nbsp;PEDIDO&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;EMISS&Atilde;O&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CLIENTE&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;TRANSPORTADORA&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;MUNIC&Iacute;PIO&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;UF&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;TEMPO&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;TOTAL (R$)&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CFRCOL&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CFRCNF&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CFRTOT&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;REALIZADO (%)&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CFCCNF&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;CFCTOT&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;REALIZADO (%)&nbsp;</td>'

	cHtmlA += CRLF+' 	</tr>'

	/***************************************************************************************/
	cHtmlB += CRLF+' </table> '

	/***************************************************************************************/

	If nTrch == 0
		cHtml := ""
	ElseIf nTrch == 1
		cHtml := cHtmlA
	ElseIf nTrch == 2
		cHtml := cHtmlB
	EndIf

Return(cHtml)

/***************************************************************************************
*| Funcao		: fHtmlRodap
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Finaliza documento html
*|
*| Retorno		: string contendo rodape do html
***************************************************************************************/
Static Function fHtmlRodap()

	Local cHtml := ""

	cHtml += CRLF+' </body> '
	cHtml += CRLF+' </html> '

Return(cHtml)

/***************************************************************************************
*| Funcao		: fLegenda
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Finaliza documento html
*|
*| Retorno		: string contendo rodape do html
***************************************************************************************/
Static Function fLegenda()

	Local cHtmlOk := ""

//Inclui legenda
	cHtmlOk := CRLF+' <!-- UMA LINHA PARA ESPAÇO --> '
	cHtmlOk += CRLF+' <table bgcolor="#FFFFFF" border="0" width="780" cellpadding="0" cellspacing="0"> '
	cHtmlOk += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtmlOk += CRLF+' 		<td height="15" colspan="8">&nbsp;</td> '
	cHtmlOk += CRLF+' 	</tr> '
	cHtmlOk += CRLF+' </table> '
	cHtmlOk += CRLF+' <table bgcolor="#FFFFFF" border="1" cellpadding="1" cellspacing="0"> '
	cHtmlOk += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090"> '
	cHtmlOk += CRLF+'			<td colspan="2">Legenda</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090"> '
	cHtmlOk += CRLF+'			<td>Abrev.</td><td>Descri&ccedil;&atilde;o</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td><b>CFRCOL</b></td><td bgColor="#B5CDE5">Caixa Fracionada &agrave; ser coletada/separada</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td><b>CFRCNF</b></td><td bgColor="#B5CDE5">Caixa fracionada j&aacute; separada e &agrave; conferir</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td><b>CFRTOT</b></td><td bgColor="#B5CDE5">Total de caixas fracionadas do pedido</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td>&nbsp;</td><td>&nbsp;</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+' 		<td><b>CFCCNF</b></td><td bgColor="#B5CDE5">Caixa fechada &agrave; conferir</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td><b>CFCTOT</b></td><td bgColor="#B5CDE5">Total de caixas fechadas do pedido</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td>&nbsp;</td><td>&nbsp;</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'		<tr valign="middle" style=" color:#000000; font-family:Tahoma; font-size:10px" bgcolor="#B5CDE5"> '
	cHtmlOk += CRLF+'			<td><b>TEMPO</b></td><td bgColor="#B5CDE5">Tempo total do pedido desde a entrada no portal at&eacute; faturamento</td> '
	cHtmlOk += CRLF+'		</tr> '
	cHtmlOk += CRLF+'	</table> '

Return(cHtmlOk)

/***************************************************************************************
*| Funcao		: fCriaSx1
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Funcao responsavel por criar os parametros do relatorio
***************************************************************************************/
Static Function fCriaSx1()

	Local aPergs := {}

	aAdd(aPergs,{"Pedido Inicial"   , "Pedido Inicial"   , "Pedido Inicial"   , "mv_ch1" , "C" , 06,00,00 ,"G", "", "mv_par01", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Pedido Final"     , "Pedido Final"     , "Pedido Final"     , "mv_ch2" , "C" , 06,00,00 ,"G", "", "mv_par02", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Da Dt.Emissão"    , "Da Dt.Emissão"    , "Da Dt.Emissão"    , "mv_ch3" , "D" , 08,00,00, "G", "", "mv_par03", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Ate Dt.Emissão"   , "Ate Dt.Emissão"   , "Ate Dt.Emissão"   , "mv_ch4" , "D" , 08,00,00, "G", "", "mv_par04", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Cliente Inicial"  , "Cliente Inicial"  , "Cliente Inicial"  , "mv_ch5" , "C" , 06,00,00 ,"G", "", "mv_par05", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Cliente Final"    , "Cliente Final"    , "Cliente Final"    , "mv_ch6" , "C" , 06,00,00 ,"G", "", "mv_par06", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA1"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Transp Inicial"   , "Transp Inicial"   , "Transp Inicial"   , "mv_ch7" , "C" , 06,00,00 ,"G", "", "mv_par07", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA4"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Transp Final"     , "Transp Final"     , "Transp Final"     , "mv_ch8" , "C" , 06,00,00 ,"G", "", "mv_par08", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA4"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"NF Inicial"       , "NF Inicial"       , "NF Inicial"       , "mv_ch9" , "C" , 09,00,00 ,"G", "", "mv_par09", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"NF Final"         , "NF Final"         , "NF Final"         , "mv_ch10" , "C" , 09,00,00 ,"G", "", "mv_par10", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Da Dt.Expedição"  , "Da Dt.Expedição"  , "Da Dt.Expedição"  , "mv_ch11" , "D" , 08,00,00, "G", "", "mv_par11", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Ate Dt.Expedição" , "Ate Dt.Expedição" , "Ate Dt.Expedição" , "mv_ch12" , "D" , 08,00,00, "G", "", "mv_par12", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Ordenação" 		, "Ordenação" 		, "Ordenação" 		, "mv_ch13" , "C" , 01,00,00, "C", "", "mv_par13", "Nenhuma" , "" , "" , "", "", "Cxs Fracionadas" , "" , "" , "", "", "Cxs Fechadas" ,"", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Da Dt.Liberação"  , "Da Dt.Liberação"  , "Da Dt.Liberação"  , "mv_ch14" , "D" , 08,00,00, "G", "", "mv_par14", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Ate Dt.Liberação" , "Ate Dt.Liberação" , "Ate Dt.Liberação" , "mv_ch15" , "D" , 08,00,00, "G", "", "mv_par15", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	//AjustaSx1(cPerg,aPergs)

Return

/***************************************************************************************
*| Funcao		: fTrataQbra
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Altera possiveis caracteres utilizados para separacao por virgula
*|
*| Parametros 	: cTrataStr: string a ser verificada
*|
*| Retorno		: string formatada
***************************************************************************************/
Static Function fTrataQbra(cTrataStr)

	Local cRet := ""
	Local i    := 0

	cTrataStr  := StrTran(cTrataStr," ","")

	cRet += "'"
	If Len(cTrataStr) > 3
		For i:=1 to Len(cTrataStr)
			If SubStr(cTrataStr,i,1) $ "/\;-|,:*"
				cRet  += "','"
			Else
				cRet  += SubStr(cTrataStr,i,1)
			EndIf
		Next
	Else
		cRet  += AllTrim(cTrataStr)
	EndIf
	cRet += "'"

Return(cRet)

/***************************************************************************************
*| Funcao		: fPeriodoTotal
*| Autor		: Suzanna Paizan
*| Data		: 22/03/2013
*| Descricao	: Calcula o tempo total (horas) entre duas datas
*|
*| Parametros : cHoraIni: hora inicial (hh:mm)
*|           	  cHoraFim: hora final (hh:mm)
*|           	  dDtIni	: data inicial (dd/mm/aaaa)
*|           	  dDtFim	: data final (dd/mm/aaaa)
*| Retorno		: total de horas no intervalo (numerico -> hh,mm)
***************************************************************************************/
Static Function fPeriodoTotal(cHoraIni, cHoraFim, dDtIni, dDtFim)

	Local nHoras  := 0
	Local nDias 	:= 0

	If dDtFim > dDtIni
		nDias := dDtFim - dDtIni
	EndIf

/***************************************************************************************
*| se nDias for 0, se trata do mesmo dia. Faz a diferenca de horas, que será o total final
*| se for = 1, se trata do dia seguinte
*| se > 1, mais de um dia de diferença, calcula dias
***************************************************************************************/
	If nDias == 0
		nHoras := SomaHoras(Elaptime(cHoraIni+":00", cHoraFim+":00"),"00:00")

	ElseIf nDias == 1
		nHoras := SomaHoras(Substr((Elaptime(cHoraIni+":00", "24:00:00")), 1, 5), Substr((Elaptime("00:00:00", cHoraFim+":00")), 1, 5))

	Else
		nDias--
		nHoras := nDias * 24

		nHoras += SomaHoras(Substr((Elaptime(cHoraIni+":00", "24:00:00")), 1, 5), Substr((Elaptime("00:00:00", cHoraFim+":00")), 1, 5))

	EndIf

Return (nHoras)
