#Include "Protheus.ch"
#include "topconn.ch"

/***************************************************************************************
*| Funcao		: LOGEXP
*| Autor		: Suzanna Paizan
*| Data			: 26/03/2013
*| Descricao	: Responsavel pela geracao do Relatorio de Logs (Historico de Separacao e Conferencia)  
*| Uso			: Especifico Proart
***************************************************************************************/
User Function PRTR0008()

	Private cPerg     := "LOGEXP"
	Private cRetTPINC := ""
	Private cAliasTRB
	Private cAliasTRB2

//Cria perguntas caso não existam
	fCriaSx1()

//Chama tela de perguntas, caso cancele, não executar relatorio
	If Pergunte(cPerg,.T.)
		If SimNao("Confirma geração da planilha 'Histórico de Separação e Conferência' ?") == "S"
			Processa({ |lEnd| fFilDados(@lEnd),OemToAnsi("Criando cabeçalho, aguarde...")}, OemToAnsi("Aguarde..."))
		EndIf
	EndIf

	Return

/***************************************************************************************
*| Funcao		: fCabec2
*| Autor		: Suzanna Paizan
*| Data			: 27/03/2013
*| Descricao	: Forma HTML do cabecalho da parte de Separacao (segunda parte do corpo
*|					do documento) 
*|
*| Retorno		: string contendo HTML
***************************************************************************************/
Static Function fCabec2()

	Local cHtml := ""


	cHtml += CRLF+' 	<tr valign="middle" style="font-size:10px" bgcolor="#FFFFFF">'
	cHtml += CRLF+'		<td colspan="18">&nbsp;</td>'
	cHtml += CRLF+'	</tr>'
	cHtml += CRLF+' 	<tr valign="middle" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#000066">'
	cHtml += CRLF+'		<td colspan="18"><b>Separa&ccedil;&atilde;o</b></td>'
	cHtml += CRLF+'	</tr>'

	cHtml += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090">'

	/***************************************************************************************/

	cHtml += CRLF+' 		<td>&nbsp;Tipo Separa&ccedil;&atilde;o&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Volume&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;C&oacute;digo&nbsp;</tTHIAGOd>'
	cHtml += CRLF+' 		<td>&nbsp;Desc. Embalagem&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Dt. I. Sep.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Hr. I. Sep.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Dt. F. Sep.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Hr. F. Sep.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Usu&aacute;rio Separa&ccedil;&atilde;o&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;End. Est.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;End. Sep.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Esta&ccedil;&atilde;o&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Quant.&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Separa&ccedil;&atilde;o&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Confer&ecirc;ncia&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Pedido&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;Nota Fiscal&nbsp;</td>'
	cHtml += CRLF+' 		<td>&nbsp;UF&nbsp;</td>'
	
	/***************************************************************************************/

	cHtml += CRLF+' 	</tr>'

	Return(cHtml)

/***************************************************************************************
*| Funcao		: fFilDados
*| Autor		: Suzanna Paizan
*| Data			: 26/03/2013
*| Descricao	: Obtem dados referentes a Conferencia atraves de consulta SQL,  
*|					gera codigo html da primeira parte do corpo do relatorio.
*|					Obtem dados referentes a Separacao atraves de consulta SQL,  
*|					gera codigo html da segunda parte do corpo do relatorio.
*|					Monta html completo, abre arquivo no Excel
***************************************************************************************/
Static Function fFilDados(lEnd)

	Local cQuery 		:= ""
	Local cQueryS		:= ""
	Local cTipo		:= ""
	Local cOrdm  		:= "01"
	Local cHtmlOk 	:= ""
	Local cArq   		:= "  "
	Local lLoop  		:= .T.
	Local nArq   		:= Nil
	Local nContBg 	:= 01
	Local aStruSQL 	:= {}
	Local aStruSQL2 	:= {}
	Local x				:= 0
	Local y				:= 0

	Private cPath  	:= AllTrim(GetTempPath())

	While lLoop
		If File(cPath+"LogExpedicao"+cOrdm+".html")
			cOrdm := AllTrim(Soma1(cOrdm))
		Else
			lLoop := .F.
		EndIf
	End

	cArq   := cPath+"LogExpedicao"+cOrdm+".html"
	nArq   := fCreate(cArq,0)

/***************************************************************************************
*| Query responsavel por obter os dados de *Conferencia*
***************************************************************************************/
	cQuery := "SELECT DISTINCT"+CRLF
	cQuery += " ZZF_TPSEP AS TIPO"+CRLF
	cQuery += " ,ZZF_SEQCX AS VOLUME"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_PRODUT END) AS CODIGO"+CRLF
	cQuery += " ,ZZF_DSCEMB AS EMB"+CRLF
	cQuery += " ,ZZF_YDICNF AS DATA_INI"+CRLF
	cQuery += " ,ZZF_YHICNF AS HORA_INI"+CRLF
	cQuery += " ,ZZF_YDFCNF AS DATA_FIM"+CRLF
	cQuery += " ,ZZF_YHFCNF AS HORA_FIM"+CRLF
	cQuery += " ,CB1_NOME AS USUARIO"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_ENDEST END) AS END_EST"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_YENDSE END) AS END_SEP"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_ESTAC END) AS ESTACAO"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_QUANT END) AS QUANT"+CRLF
	cQuery += " ,(CASE WHEN ZZF_TPSEP = 'S' THEN '' ELSE ZZG_QTDCNF END) AS QUANT_CNF"+CRLF
	cQuery += " ,C9_NFISCAL AS NOTA"+CRLF
	cQuery += " ,ZZF_PEDIDO AS PEDIDO"+CRLF
	cQuery += " ,ZZF_DHCALC AS LIBERACAO"+CRLF
	cQuery += " ,F2_EST AS UF"+CRLF
	cQuery += " FROM "+RetSqlName("ZZF")+" ZZF"+CRLF
	cQuery += " INNER JOIN "+RetSqlName("ZZG")+" ZZG"+CRLF
	cQuery += " ON ZZF_FILIAL+ZZF_PEDIDO+ZZF_SEQCX+ZZF_DHCALC = ZZG_FILIAL+ZZG_PEDIDO+ZZG_SEQCX+ZZG_DHCALC AND ZZG.D_E_L_E_T_ = ''"+CRLF
	
	//Codigo da embalagem
	If !Empty(mv_par02)
		cQuery += " AND ZZF_TPSEP = 'F' AND ZZG_PRODUT = '" + mv_par02 + "'"+CRLF
	EndIf

	//Estacao
	If !Empty(mv_par11)
		cQuery += " AND ZZF_TPSEP = 'F' AND ZZG_ESTAC = '" + mv_par11 + "'"+CRLF
	EndIf

	//endereco de estoque
	If !Empty(mv_par12)
		cQuery += " AND ZZF_TPSEP = 'F' AND ZZG_ENDEST = '" + mv_par12 + "'"+CRLF
	EndIf

	//endereco de separacao
	If !Empty(mv_par13)
		cQuery += " AND ZZF_TPSEP = 'F' AND ZZG_YENDSE = '" + mv_par13 + "'"+CRLF
	EndIf
	
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5"+CRLF
	cQuery += " ON C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = ZZF_PEDIDO AND SC5.D_E_L_E_T_ = ''"+CRLF
	cQuery += " INNER JOIN "+RetSqlName("SC9")+" SC9"+CRLF
	cQuery += " ON C9_FILIAL = '"+xFilial('SC9')+"' AND ZZG_SC9 = SC9.R_E_C_N_O_ AND SC9.D_E_L_E_T_ = ''"+CRLF
	cQuery += " LEFT OUTER JOIN "+RetSqlName("CB1")+" CB1"+CRLF
	cQuery += " ON CB1_FILIAL = '"+xFilial('CB1')+"' AND CB1_CODOPE = ZZF_USRCNF AND CB1.D_E_L_E_T_ = ''"+CRLF
	
	//Usuario
	If !Empty(mv_par07)
		cQuery += " AND CB1_CODOPE = '" + fTrataQbra(mv_par07) + "'"+CRLF
	EndIf
	
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SF2")+" SF2"+CRLF
	cQuery += " ON F2_FILIAL = '"+xFilial('SF2')+"' AND F2_DOC = C9_NFISCAL AND SF2.D_E_L_E_T_ = ''" +CRLF
	
	//DANFE
	If !Empty(mv_par10)
		cQuery += " AND F2_CHVNFE = '" + mv_par10 + "'"+CRLF
	EndIf
	
	cQuery += " WHERE ZZF_FILIAL = '"+xFilial('ZZF')+"' AND ZZF.D_E_L_E_T_ = ''"+CRLF

/***************************************************************************************
*| Inclui parametros na query, se preenchidos
***************************************************************************************/

//Tipo de separacao (S = Fracionada; F = Fechada)
	If (mv_par01 == 2)
		cQuery += " AND ZZF_TPSEP = 'S'"+CRLF
	EndIf
	If (mv_par01 == 3)
		cQuery += " AND ZZF_TPSEP = 'F'"+CRLF
	EndIf

//Pedido de / ate
	If !Empty(mv_par08) .And. !Empty(mv_par09)
		cQuery += " AND ZZF_PEDIDO >= '"+mv_par08+"' "+CRLF
		cQuery += " AND ZZF_PEDIDO <= '"+mv_par09+"' "+CRLF
	EndIf

//Data de Inicio-Fim - de / ate
	If !Empty(mv_par03) .And. !Empty(mv_par05)
		If !Empty(mv_par04) .And. !Empty(mv_par06) //se foi preenchido os parametros de horario
			cQuery += " AND CONVERT(DATETIME, ZZF_YDICNF + ' ' + ZZF_YHICNF) >= CONVERT(DATETIME, '" + DtoS(mv_par03) + " " + mv_par04 +"')"+CRLF
			cQuery += " AND CONVERT(DATETIME, ZZF_YDFCNF + ' ' + ZZF_YHFCNF) <= CONVERT(DATETIME, '" + DtoS(mv_par05) + " " + mv_par06 +"')"+CRLF
		Else
			cQuery += " AND ZZF_YDICNF >= '" + DtoS(mv_par03) + "' "+CRLF
			cQuery += " AND ZZF_YDFCNF <= '" + DtoS(mv_par05) + "' "+CRLF
		EndIf
	EndIf
	/***************************************************************************************/

	cQuery += " GROUP BY ZZF_TPSEP, ZZF_PEDIDO, ZZF_SEQCX, ZZF_DHCALC, ZZG_PRODUT, ZZF_DSCEMB, ZZF_YDICNF, ZZF_YHICNF, ZZF_YDFCNF, ZZF_YHFCNF, CB1_NOME, ZZG_ENDEST,ZZG_YENDSE, ZZG_ESTAC, ZZG_QUANT, ZZG_QTDSEP, ZZG_QTDCNF, C9_NFISCAL,F2_EST "+CRLF
	cQuery += " ORDER BY ZZF_PEDIDO, C9_NFISCAL, ZZF_SEQCX"+CRLF


//Fecha Alias se estiver em uso
	If Select(cAliasTRB) > 0
		(cAliasTRB)->(dbCloseArea())
	Endif

	//MemoWrite("PRTR0008-A.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)
	TCSetField(cAliasTRB,"DATA_INI","D",8,0)
	TCSetField(cAliasTRB,"DATA_FIM","D",8,0)
	nContaRegs := 0
	Count To nContaRegs

//Carrega cabecalho HTML
	cHtmlOk := fHtmlCabec()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Carrega inicio corpo HTML
	cHtmlOk := fHtmlCorpo(1)
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Barra processamento
	DbSelectArea(cAliasTRB)
	(cAliasTRB)->(DbGoTop())

	ProcRegua(nContaRegs)
	(cAliasTRB)->(DbGoTop())

/***************************************************************************************
*| Carrega dados da Query no array
***************************************************************************************/
	Do While (cAliasTRB)->(!Eof())
	
		If (cAliasTRB)->TIPO == 'F'
			cTipo := 'Fechada'
		Else
			cTipo := 'Fracionada'
		EndIf
	
		aAdd( aStruSQL , { cTipo, (cAliasTRB)->VOLUME, AllTrim((cAliasTRB)->CODIGO), AllTrim((cAliasTRB)->EMB), DTOC((cAliasTRB)->DATA_INI), (cAliasTRB)->HORA_INI, DTOC((cAliasTRB)->DATA_FIM), (cAliasTRB)->HORA_FIM,;
			AllTrim((cAliasTRB)->USUARIO), (cAliasTRB)->END_EST, (cAliasTRB)->END_SEP, (cAliasTRB)->ESTACAO, CvalToChar((cAliasTRB)->QUANT), cValToChar((cAliasTRB)->QUANT_CNF), cValToChar((cAliasTRB)->QUANT_CNF), (cAliasTRB)->PEDIDO , (cAliasTRB)->NOTA , (cAliasTRB)->UF} )
		
		(cAliasTRB)->(DbSkip())
	Enddo

/***************************************************************************************
*| gera HTML dos itens - conferencia
***************************************************************************************/
	For y:=1 To Len(aStruSQL)
	
		IncProc("Gerando arquivo Excel. Aguarde...")
	
	//Define cor de fundo da linha
		nContBg ++
		If nContBg%2 == 0
			cBgClr := "#FFFFFF"
		Else
			cBgClr := "#B5CDE5"
		EndIf

		cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:10px"> '
		For x:=1 To 18
			If (x >= 13 .AND. x <= 15)
				cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL[y][x] +'</td> '
			Else
				cHtmlOk += CRLF+' 	<td align="left">' +  aStruSQL[y][x] +'&nbsp;</td> '
			EndIf
		Next x
				
		cHtmlOk += CRLF+' </tr> '

	//Carrega HTML
		FWrite(nArq,cHtmlOk,Len(cHtmlOk))

	Next y

	/***************************************************************************************/

//Carrega cabecalho da Separacao
	cHtmlOk := fCabec2()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

/* Verifica se o usuario filtrou por caixa fechada. Caso tenha filtrado, não sera exibida esta parte do relatorio
 * pois se trata da parte de picking. Tipos de separacao (S = Fracionada; F = Fechada) */
	
	If !(mv_par01 == 3)

	/***************************************************************************************
	*| Query responsavel por obter os dados de *Separacao*
	***************************************************************************************/
		cQueryS := "SELECT"
		cQueryS += " ZZF_TPSEP AS TIPO"
		cQueryS += " ,ZZF_SEQCX AS VOLUME"
		cQueryS += " ,ZZG_PRODUT AS CODIGO"
		cQueryS += " ,ZZG_DSCPRD AS EMB"
		cQueryS += " ,ZZG_YDISEP AS DATA_INI"
		cQueryS += " ,ZZG_YHISEP AS HORA_INI"
		cQueryS += " ,ZZG_YDFSEP AS DATA_FIM"
		cQueryS += " ,ZZG_YHFSEP AS HORA_FIM"
		cQueryS += " ,CB1_NOME AS USUARIO"
		cQueryS += " ,ZZG_ENDEST AS END_EST"
		cQueryS += " ,ZZG_YENDSE AS END_SEP"
		cQueryS += " ,ZZG_ESTAC AS ESTACAO"
		cQueryS += " ,ZZG_QUANT AS QUANT"
		cQueryS += " ,ZZG_QTDSEP AS QUANT_SEP"
		cQueryS += " ,ZZG_QTDCNF AS QUANT_CNF"
		cQueryS += " ,C9_NFISCAL AS NOTA"
		cQueryS += " ,ZZF_PEDIDO AS PEDIDO"
		cQueryS += " ,ZZF_DHCALC AS LIBERACAO"
		cQueryS += " ,F2_EST AS UF"
		cQueryS += " FROM "+RetSqlName("ZZF")+" ZZF"
		cQueryS += " INNER JOIN "+RetSqlName("ZZG")+" ZZG"
		cQueryS += " ON ZZF_FILIAL+ZZF_PEDIDO+ZZF_SEQCX+ZZF_DHCALC = ZZG_FILIAL+ZZG_PEDIDO+ZZG_SEQCX+ZZG_DHCALC AND ZZG.D_E_L_E_T_ = ''"
		
		//Codigo da embalagem
		If !Empty(mv_par02)
			cQueryS += CRLF+" AND ZZG_PRODUT = '" + mv_par02 + "'"
		EndIf
	
		//Estacao
		If !Empty(mv_par11)
			cQueryS += CRLF+" AND ZZG_ESTAC = '" + mv_par11 + "'"
		EndIf
	
		//endereco de estoque
		If !Empty(mv_par12)
			cQueryS += CRLF+" AND ZZG_ENDEST = '" + mv_par12 + "'"
		EndIf
	
		//endereco de separacao
		If !Empty(mv_par13)
			cQueryS += CRLF+" AND ZZG_YENDSE = '" + mv_par13 + "'"
		EndIf
		
		cQueryS += " INNER JOIN "+RetSqlName("SC5")+" SC5"
		cQueryS += " ON C5_FILIAL = '"+xFilial('SC5')+"' AND C5_NUM = ZZF_PEDIDO AND SC5.D_E_L_E_T_ = ''"
		cQueryS += " INNER JOIN "+RetSqlName("SC9")+" SC9"
		cQueryS += " ON C9_FILIAL = '"+xFilial('SC9')+"' AND ZZG_SC9 = SC9.R_E_C_N_O_ AND SC9.D_E_L_E_T_ = ''"
		cQueryS += " LEFT OUTER JOIN "+RetSqlName("CB1")+" CB1"
		cQueryS += " ON CB1_FILIAL = '"+xFilial('CB1')+"' AND CB1_CODOPE = ZZG_USUSEP AND CB1.D_E_L_E_T_ = ''"
		
		//Usuario
		If !Empty(mv_par07)
			cQueryS += CRLF+" AND CB1_CODOPE = '" + fTrataQbra(mv_par07) + "'"
		EndIf
		
		cQueryS += " LEFT OUTER JOIN "+RetSqlName("SF2")+" SF2"
		cQueryS += " ON F2_FILIAL = '"+xFilial('SF2')+"' AND F2_DOC = C9_NFISCAL AND F2_SERIE=C9_SERIENF AND F2_SERIE=C9_SERIENF AND SF2.D_E_L_E_T_ = ''"
	
		//DANFE
		If !Empty(mv_par10)
			cQueryS += CRLF+" AND F2_CHVNFE = '" + mv_par10 + "'"
		EndIf
		
		cQueryS += " WHERE ZZF_FILIAL = '"+xFilial('ZZF')+"' AND ZZF.D_E_L_E_T_ = ''"
		cQueryS += " AND ZZF_TPSEP = 'S'"
	
	/***************************************************************************************
	*| Inclui parametros na query, se preenchidos
	***************************************************************************************/
	
	//Pedido de / ate
		If !Empty(mv_par08) .And. !Empty(mv_par09)
			cQueryS += CRLF+" AND ZZF_PEDIDO >= '"+mv_par08+"' "
			cQueryS += CRLF+" AND ZZF_PEDIDO <= '"+mv_par09+"' "
		EndIf
	
	//Data de Inicio-Fim - de / ate
		If !Empty(mv_par03) .And. !Empty(mv_par05)
			If !Empty(mv_par04) .And. !Empty(mv_par06) //se foi preenchido os parametros de horario
				cQueryS += CRLF+" AND CONVERT(DATETIME, ZZF_YDICNF + ' ' + ZZF_YHICNF) >= CONVERT(DATETIME, '" + DtoS(mv_par03) + " " + mv_par04 +"')"
				cQueryS += CRLF+" AND CONVERT(DATETIME, ZZF_YDFCNF + ' ' + ZZF_YHFCNF) <= CONVERT(DATETIME, '" + DtoS(mv_par05) + " " + mv_par06 +"')"
			Else
				cQueryS += CRLF+" AND ZZF_YDICNF >= '" + DtoS(mv_par03) + "' "
				cQueryS += CRLF+" AND ZZF_YDFCNF <= '" + DtoS(mv_par05) + "' "
			EndIf
		EndIf
		/***************************************************************************************/
	
		cQueryS += CRLF+" GROUP BY ZZF_TPSEP, ZZF_PEDIDO, ZZF_SEQCX, ZZF_DHCALC, ZZG_PRODUT, ZZG_DSCPRD, ZZG_YDISEP, ZZG_YHISEP, ZZG_YDFSEP, ZZG_YHFSEP, CB1_NOME, ZZG_ENDEST,ZZG_YENDSE, ZZG_ESTAC, ZZG_QUANT, ZZG_QTDSEP, ZZG_QTDCNF, C9_NFISCAL,F2_EST "
		cQueryS += CRLF+" ORDER BY ZZF_PEDIDO, C9_NFISCAL, ZZF_SEQCX"
	
	//Fecha Alias se estiver em uso
		If Select(cAliasTRB2) > 0
			(cAliasTRB2)->(dbCloseArea())
		Endif
	
		//MemoWrite("PRTR0008-B.sql",cQuery)
		dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQueryS),(cAliasTRB2 := GetNextAlias()), .F., .T.)
		TCSetField(cAliasTRB2,"DATA_INI","D",8,0)
		TCSetField(cAliasTRB2,"DATA_FIM","D",8,0)
		nContaRegs := 0
		Count To nContaRegs
	
		DbSelectArea(cAliasTRB2)
		(cAliasTRB2)->(DbGoTop())
	
	/***************************************************************************************
	*| Carrega dados da Query no array
	***************************************************************************************/
		Do While (cAliasTRB2)->(!Eof())
		
			If (cAliasTRB)->TIPO == 'F'
				cTipo := 'Fechada'
			Else
				cTipo := 'Fracionada'
			EndIf
			aAdd( aStruSQL2 , { cTipo, (cAliasTRB2)->VOLUME, AllTrim((cAliasTRB2)->CODIGO), AllTrim((cAliasTRB2)->EMB), DTOC((cAliasTRB2)->DATA_INI), (cAliasTRB2)->HORA_INI, DTOC((cAliasTRB2)->DATA_FIM), (cAliasTRB2)->HORA_FIM,;
				AllTrim((cAliasTRB2)->USUARIO), (cAliasTRB2)->END_EST, (cAliasTRB2)->END_SEP, (cAliasTRB2)->ESTACAO, CvalToChar((cAliasTRB2)->QUANT), CvaltoChar((cAliasTRB2)->QUANT_SEP), cValToChar((cAliasTRB2)->QUANT_CNF), (cAliasTRB2)->PEDIDO , (cAliasTRB2)->NOTA, (cAliasTRB2)->UF } )
	
			(cAliasTRB2)->(DbSkip())
		Enddo
	
	/***************************************************************************************
	*| gera HTML dos itens - separacao
	***************************************************************************************/
		For y:=1 To Len(aStruSQL2)
	
			IncProc("Gerando arquivo Excel. Aguarde...")
		
		//Define cor de fundo da linha
			nContBg ++
			If nContBg%2 == 0
				cBgClr := "#FFFFFF"
			Else
				cBgClr := "#B5CDE5"
			EndIf
	
			cHtmlOk := CRLF+' <tr bgcolor='+cBgClr+' valign="middle" align="center" style=" font-family:Tahoma; font-size:10px"> '
			For x:=1 To 18
		
				If (x >= 13 .AND. x <= 15)
					cHtmlOk += CRLF+' 	<td align="right">' + aStruSQL2[y][x] +'</td> '
				Else
					cHtmlOk += CRLF+' 	<td align="left">' +  aStruSQL2[y][x] +'&nbsp;</td> '
				EndIf
				
			
			Next x
					
			cHtmlOk += CRLF+' </tr> '
		
		//Carrega HTML
			FWrite(nArq,cHtmlOk,Len(cHtmlOk))
		
		Next y
	
	//Fecha Alias
		(cAliasTRB2)->(dbCloseArea())
	
	EndIf
	
//Carrega continuacao do corpo HTML
	cHtmlOk := fHtmlCorpo(2)
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Carrega rodape  HTML
	cHtmlOk := fHtmlRodap()
	FWrite(nArq,cHtmlOk,Len(cHtmlOk))

//Fecha Arquivo
	fClose(nArq)

//Fecha Alias
	(cAliasTRB)->(dbCloseArea())

//Verifica se existe excel instalado e abre em excel, caso não exista, abrir no internet explorer
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
	cHtml += CRLF+' 	<tr><td>&nbsp;</td></tr> '
	cHtml += CRLF+' 	<tr valign="top" width="100%" style=" font-family:Tahoma; font-size:12px"> '
	cHtml += CRLF+' 		<td height="90" width="25%" colspan="5" rowspan="6" align="center" valign="middle">&nbsp;</td> '
	cHtml += CRLF+' 		<td height="90" width="50%" colspan="4" rowspan="6" align="center" valign="middle"><b>HIST&Oacute;RICO DE SEPARA&Ccedil;&Atilde;O &amp; CONFER&Ecirc;NCIA</b></td> '
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
*| Parametros	: nTrch -> 	0 - mantem linha e tabela aberta (tr e table)
*|							1 - fecha linha da tabela (tr)
*|							2 - fecha tabela (table)
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

	cHtmlA += CRLF+' 	<tr valign="middle" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#000066">'
	cHtmlA += CRLF+'		<td colspan="18"><b>Confer&ecirc;ncia</b></td>'
	cHtmlA += CRLF+'	</tr>'

	cHtmlA += CRLF+' 	<tr valign="middle" align="center" style=" color:#FFFFFF; font-family:Tahoma; font-size:10px" bgcolor="#708090">'
	cHtmlA += CRLF+' 		<td>&nbsp;Tipo Separa&ccedil;&atilde;o&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Volume&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;C&oacute;digo&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Desc. Embalagem&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Dt. I. Conf.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Hr. I. Conf.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Dt. F. Conf.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Hr. F. Conf.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Usu&aacute;rio Confer&ecirc;ncia&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;End. Est.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;End. Sep.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Esta&ccedil;&atilde;o&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Quant.&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Separa&ccedil;&atilde;o&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Confer&ecirc;ncia&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Pedido&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;Nota Fiscal&nbsp;</td>'
	cHtmlA += CRLF+' 		<td>&nbsp;UF&nbsp;</td>'
	cHtmlA += CRLF+' 	</tr>'

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
*| Funcao		: fCriaSx1
*| Autor		: Suzanna Paizan
*| Data			: 26/03/2013
*| Descricao	: Funcao responsavel por criar os parametros do relatorio 
***************************************************************************************/
Static Function fCriaSx1()

	Local aPergs := {}

	aAdd(aPergs,{"Tipo de Separação" 	, "Tipo de Separação"	, "Tipo de Separação" , "mv_ch1", "N" , 01,00,00, "C", "", "mv_par01", "Ambas" , "" , "" , "", "", "Cxs Fracionadas" , "" , "" , "", "", "Cxs Fechadas" ,"", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Cód. Produto"			, "Cód. Produto"   		, "Cód. Produto"    	 , "mv_ch2" , "C" , 20,00,00 ,"G", "", "mv_par02", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"    , "","S","","",{},{},{}})
	aAdd(aPergs,{"Data Inicial"			, "Data Inicial"    		, "Data Inicial" 		 , "mv_ch3" , "D" , 08,00,00, "G", "", "mv_par03", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Hora Inicial"			, "Hora Inicial"   		, "Hora Inicial" 		 , "mv_ch4" , "C" , 08,00,00, "G", "", "mv_par04", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Data Final"			, "Data Final"    		, "Data Final" 		 , "mv_ch5" , "D" , 08,00,00, "G", "", "mv_par05", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Hora Final"			, "Hora Final"   			, "Hora Final" 		 , "mv_ch6" , "C" , 08,00,00, "G", "", "mv_par06", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Usuário"				, "Usuário"   			, "Usuário" 			 , "mv_ch7" , "C" , 06,00,00, "G", "", "mv_par07", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Pedido Inicial"		, "Pedido Inicial"		, "Pedido Inicial" 	 , "mv_ch8" , "C" , 06,00,00, "G", "", "mv_par08", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Pedido Final"			, "Pedido Final"		   	, "Pedido Final" 		 , "mv_ch9" , "C" , 06,00,00, "G", "", "mv_par09", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"DANFE"					, "DANFE"		   			, "DANFE"	 			 , "mv_ch10" , "C" , 44,00,00, "G", "", "mv_par10", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Estação"				, "Estação"	   			, "Estação" 			 , "mv_ch11" , "C" , 01,00,00, "G", "", "mv_par11", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Endereço Estoque"		, "Endereço Estoque"		, "Endereço Estoque"	 , "mv_ch12" , "C" , 08,00,00, "G", "", "mv_par12", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})
	aAdd(aPergs,{"Endereço Separação"	, "Endereço Separação"	, "Endereço Separação", "mv_ch13" , "C" , 08,00,00, "G", "", "mv_par13", "         " , "         " , "         " , "", "", "         " , "         " , "         " , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""       , "","S","","",{},{},{}})

	//AjustaSx1(cPerg,aPergs)

	Return

/***************************************************************************************
*| Funcao		: fTrataQbra
*| Autor		: VETI
*| Data			: 18/02/2013
*| Descricao	: Altera possiveis caracteres utilizados para separacao por virgula 
*|
*| Parametros	: cTrataStr: string a ser verificada
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
