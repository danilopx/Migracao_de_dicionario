#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTRL002   บAutor  ณThiago Comelli     บ Data ณ  07/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio para analise dos Apontamentos por OP              บฑฑ
ฑฑบ          ณSolicitado por Humberto - PCP                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ESTRL002()
	Local oObj

	ValidPerg()
	If Pergunte("ESTRL002  ",.T.)
		oObj := MsNewProcess():New({|lEnd| ProcRel(oObj)},"","",.F.)
		oObj :Activate()
	EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROCREL   บAutor  ณMicrosiga           บ Data ณ  12/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcRel(oObj)

	Local cTRB1	:= GetNextAlias()
	Local cQuery	:= ""
	Local aHeader	:= {}
	Local aCols		:= {}
	Local i := 0
	Local f := 0

	Aadd(aHeader,{"OP"				,"OP"			,X3Picture("D3_OP")		,TamSx3("D3_OP")[1]		,TamSx3("D3_OP")[2]		,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Emissao OP"		,"EMISSOP"		,X3Picture("C2_EMISSAO"),TamSx3("C2_EMISSAO")[1],TamSx3("C2_EMISSAO")[2],"AllwaysTrue()"	,"ฐ","D","" } )
	Aadd(aHeader,{"Produto Pai"		,"CODPAI"		,X3Picture("C2_PRODUTO"),TamSx3("C2_PRODUTO")[1],TamSx3("C2_PRODUTO")[2],"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Descricao Pai"	,"DESCPAI"		,X3Picture("B1_DESC")	,TamSx3("B1_DESC")[1]	,TamSx3("B1_DESC")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Tipo Pai"		,"TIPOPAI"		,X3Picture("B1_TIPO")	,TamSx3("B1_TIPO")[1]	,TamSx3("B1_TIPO")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Data Consumo"	,"DATACON"		,X3Picture("D3_EMISSAO"),TamSx3("D3_EMISSAO")[1],TamSx3("D3_EMISSAO")[2],"AllwaysTrue()"	,"ฐ","D","" } )
	Aadd(aHeader,{"Componente Consumido","CODCON"	,X3Picture("C2_PRODUTO"),TamSx3("C2_PRODUTO")[1],TamSx3("C2_PRODUTO")[2],"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Descricao Componente","DESCCON"	,X3Picture("B1_DESC")	,TamSx3("B1_DESC")[1]	,TamSx3("B1_DESC")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Unidade Medida"	,"UMCON"		,X3Picture("B1_UM")		,TamSx3("B1_UM")[1]		,TamSx3("B1_UM")[2]		,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Tipo Componente"	,"TIPOCON"		,X3Picture("B1_TIPO")	,TamSx3("B1_TIPO")[1]	,TamSx3("B1_TIPO")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Quantidade"		,"QUANTCON"		,X3Picture("D3_QUANT")	,TamSx3("D3_QUANT")[1]	,TamSx3("D3_QUANT")[2]	,"AllwaysTrue()"	,"ฐ","N","" } )
	Aadd(aHeader,{"Armazem Consumo"	,"LOCALCON"		,X3Picture("D3_LOCAL")	,TamSx3("D3_LOCAL")[1]	,TamSx3("D3_LOCAL")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Documento Consumo","DOCCON"		,X3Picture("D3_DOC")	,TamSx3("D3_DOC")[1]	,TamSx3("D3_DOC")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Usuแrio"			,"USER"			,X3Picture("D3_USUARIO"),TamSx3("D3_USUARIO")[1],TamSx3("D3_USUARIO")[2],"AllwaysTrue()"	,"ฐ","C","" } )

	oObj:SetRegua1(3)
	oObj:IncRegua1("Gerando Relatorio")

	_cStrOut := ""
	_cStrIn		:= ALLTRIM( mv_par03 )
	IF len(AllTrim(_cStrIn)) > 0
		For i := 1 to len(_cStrIn)

			IF lower( SUBSTR(_cStrIn,i,1) ) $ '/'
				_cStrOut := _cStrOut + "','"

			Else
				_cStrOut := _cStrOut + substr(_cStrIn,i,1)
			Endif

		Next
	ELSE
		_cStrOut := Upper("'"+_cStrIn+"'")
	EndIf

	_cStrOut := Upper("'"+_cStrOut+"'")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
//ณSele็ใo dos Produtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู
	cQuery := " SELECT C2_NUM+C2_ITEM+C2_SEQUEN OP, C2_EMISSAO EMISSAO_OP, C2_PRODUTO PRODUTO_PAI,"
	cQuery += " (SELECT B1_DESC FROM "+ RetSqlName( 'SB1' )+" AS B1 WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1.D_E_L_E_T_ <> '*' AND B1_COD = C2_PRODUTO) DESCRICAO_PAI,"
	cQuery += " (SELECT B1_TIPO FROM "+ RetSqlName( 'SB1' )+" AS B1 WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1.D_E_L_E_T_ <> '*' AND B1_COD = C2_PRODUTO) TIPO_PAI,"
	cQuery += " D3_EMISSAO DATA_CONSUMO, D3_COD COMPONENTE_CONSUMIDO,"
	cQuery += " (SELECT B1_DESC FROM "+ RetSqlName( 'SB1' )+" AS B1 WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1.D_E_L_E_T_ <> '*' AND B1_COD = D3_COD) DESCRICAO_COMPONENTE,"
	cQuery += " (SELECT B1_TIPO FROM "+ RetSqlName( 'SB1' )+" AS B1 WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1.D_E_L_E_T_ <> '*' AND B1_COD = D3_COD) TIPO_COMPONENTE,"
	cQuery += " D3_UM UM_COMP, D3_QUANT QUANT_CONSUMIDA, D3_LOCAL ARMAZEM_CONSUMO, D3_DOC DOCUMENTO_CONSUMO ,"
	cQuery += " D3_USUARIO USUARIO"
	cQuery += " FROM "+ RetSqlName( 'SC2' )+" AS C2"
	cQuery += " INNER JOIN "+ RetSqlName( 'SD3' )+" AS D3 ON D3_FILIAL = '" + XFILIAL("SD3") + "' AND D3.D_E_L_E_T_ <> '*' AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D3_CF LIKE 'RE%'"
	cQuery += " WHERE C2.D_E_L_E_T_ <> '*'"
	cQuery += " AND C2_FILIAL = '" + XFILIAL("SC2") + "'"
	cQuery += " AND C2_PRODUTO IN (SELECT B1_COD FROM "+ RetSqlName( 'SB1' )+" AS B1 WHERE B1_FILIAL = '" + XFILIAL("SB1") + "' AND B1.D_E_L_E_T_ <> '*' AND B1_COD = C2_PRODUTO AND B1_TIPO IN ("+_cStrOut+"))"
	cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cQuery += " ORDER BY C2_NUM+C2_ITEM+C2_SEQUEN"

	oObj:SetRegua2(2)
	oObj:IncRegua2("Selecionando Apontamentos")
	oObj:IncRegua1("Gerando Relatorio")

	nRecCount := 0
	MemoWrite("ESTRL002a.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTRB1, .F., .T.)

	Count to nRecCount

	If nRecCount > 0
		oObj:SetRegua2(nRecCount)

		dbSelectArea(cTRB1)
		(cTRB1)->(dbGoTop())
		While (cTRB1)->(!Eof())

			oObj:IncRegua2("Processando Apontamentos")

			aAdd(aCols,{(cTRB1)->OP,; //OP - 1
			STOD((cTRB1)->EMISSAO_OP),; //Emissใo OP -2
			(cTRB1)->PRODUTO_PAI,; //Produto Pai -3
			(cTRB1)->DESCRICAO_PAI,; //Descricao Pai -4
			(cTRB1)->TIPO_PAI,; //Tipo Pai -5
			STOD((cTRB1)->DATA_CONSUMO),; //Data Consumo -6
			(cTRB1)->COMPONENTE_CONSUMIDO,; //Componente Consumido -7
			(cTRB1)->DESCRICAO_COMPONENTE,; //Descri็ใo Componente -8
			(cTRB1)->TIPO_COMPONENTE,; //Tipo Componente -9
			(cTRB1)->UM_COMP,; //Unidade Medida Componente -10
			(cTRB1)->QUANT_CONSUMIDA,; //Quant Consumida -11
			(cTRB1)->ARMAZEM_CONSUMO,; //Armazem Consumo -12
			(cTRB1)->DOCUMENTO_CONSUMO,; //Documento Consumo -13
			(cTRB1)->USUARIO,; //Usuแrio -14
			.F.}) // -15
			(cTRB1)->(DbSkip())
		EndDo

		(cTRB1)->(DbCloseArea())

	Else

		MSGSTOP("Nใo existem dados para este relatorio!","Aten็ใo")
		(cTRB1)->(DBCLOSEAREA())
		Return

	EndIf

	If !Empty(aCols)
		oObj:SetRegua2(Len(aCols))

		For f := 1 to Len(aCols)
			oObj:IncRegua2("Formatando Colunas")
			aCols[f][1] := CHR(160)+ aCols[f][1]
			aCols[f][3] := CHR(160)+ aCols[f][3]
			aCols[f][7] := CHR(160)+ aCols[f][7]
			aCols[f][12] := CHR(160)+ aCols[f][12]
			aCols[f][13] := CHR(160)+ aCols[f][13]

		Next f

		oObj:IncRegua1("Exportando para o Excel")
		DlgToExcel({{"GETDADOS",OemToAnsi("Ultima Movimentacao de Estoque"),aHeader,aCols}})
	Else
		Aviso("ESTRL002","Nao existem dados para o relat๓rio",{"OK"})
	EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Bindo         บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta nos parametros e no help do Sx1               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()
Local aAtuArea := GetArea()
Local aSX1Area := SX1->(GetArea())

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

If SX1->(!dbSeek("ESTRL002  01"))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO	:= "ESTRL002"
	SX1->X1_ORDEM	:= "01"
	SX1->X1_PERGUNT	:= "Da Data"
	SX1->X1_PERSPA	:= "Da Data"
	SX1->X1_PERENG	:= "Da Data"
	SX1->X1_VARIAVL	:= "MV_CH1"
	SX1->X1_VAR01 	:= "MV_PAR01"
	SX1->X1_TIPO	:= "D"
	SX1->X1_TAMANHO	:= 8
	SX1->X1_GSC		:= "G"
	SX1->X1_PYME	:= "S"
	SX1->(MsUnLock())
EndIf

If SX1->(!dbSeek("ESTRL002  02"))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO	:= "ESTRL002"
	SX1->X1_ORDEM	:= "02"
	SX1->X1_PERGUNT	:= "Ate a Data"
	SX1->X1_PERSPA	:= "Ate a Data"
	SX1->X1_PERENG	:= "Ate a Data"
	SX1->X1_VARIAVL	:= "MV_CH2"
	SX1->X1_VAR01 	:= "MV_PAR02"
	SX1->X1_TIPO	:= "D"
	SX1->X1_TAMANHO	:= 8
	SX1->X1_GSC		:= "G"
	SX1->X1_PYME	:= "S"
	SX1->(MsUnLock())
EndIf

If SX1->(!dbSeek("ESTRL002  03"))
	RecLock("SX1",.T.)
	SX1->X1_GRUPO	:= "ESTRL002"
	SX1->X1_ORDEM	:= "03"
	SX1->X1_PERGUNT	:= "Dos Tipos"
	SX1->X1_PERSPA	:= "Dos Tipos"
	SX1->X1_PERENG	:= "Dos Tipos"
	SX1->X1_VARIAVL	:= "MV_CH3"
	SX1->X1_VAR01 	:= "MV_PAR03"
	SX1->X1_TIPO	:= "C"
	SX1->X1_TAMANHO	:= 8
	SX1->X1_GSC		:= "G"
	SX1->X1_PYME	:= "S"
	SX1->(MsUnLock())
EndIf

RestArea(aSX1Area)
RestArea(aAtuArea)

Return(Nil)
