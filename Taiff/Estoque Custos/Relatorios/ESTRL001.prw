#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTRL001   บAutor  ณThiago Comelli     บ Data ณ  07/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio para analise da ultima movimenta็ใo do produto    บฑฑ
ฑฑบ          ณSolicitado por Humberto - PCP                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ESTRL001()

	//Local cPerg 	:= Padr("ESTRL001",len(SX1->X1_GRUPO))
	Local oObj
//ValidPerg()

//If Pergunte(cPerg,.T.)
	oObj := MsNewProcess():New({|lEnd| ProcRel(oObj)},"","",.F.)
	oObj :Activate()
//Processa({|| ProcRel()},"Gerando Planilha...Aguarde...")
//EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATFRL001   บAutor  ณMicrosiga           บ Data ณ  12/23/10   บฑฑ
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
	Local cTRB2	:= GetNextAlias()
	Local cTRB3	:= GetNextAlias()
	Local cQuery	:= ""
	Local aHeader	:= {}
	Local aCols		:= {}
	Local f := 0

	Aadd(aHeader,{"Codigo"			,"COD"			,X3Picture("B1_COD")	,TamSx3("B1_COD")[1]	,TamSx3("B1_COD")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Descri็ใo"		,"DESCR"		,X3Picture("B1_DESC")	,TamSx3("B1_DESC")[1]	,TamSx3("B1_DESC")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Serie NF"		,"SERIENF"		,X3Picture("D2_SERIE")	,TamSx3("D2_SERIE")[1]	,TamSx3("D2_SERIE")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Numero NF"		,"NUMNF"		,X3Picture("D2_DOC")	,TamSx3("D2_DOC")[1]	,TamSx3("D2_DOC")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Data NF"			,"DATANF"		,X3Picture("D2_EMISSAO"),TamSx3("D2_EMISSAO")[1],TamSx3("D2_EMISSAO")[2],"AllwaysTrue()"	,"ฐ","D","" } )
	Aadd(aHeader,{"Local"			,"LOCALNF"		,X3Picture("D2_LOCAL")	,TamSx3("D2_LOCAL")[1]	,TamSx3("D2_LOCAL")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Quantidade"		,"QUANTNF"		,X3Picture("D2_QUANT")	,TamSx3("D2_QUANT")[1]	,TamSx3("D2_QUANT")[2]	,"AllwaysTrue()"	,"ฐ","N","" } )
	Aadd(aHeader,{"Ordem Produ็ใo"	,"NUMOP"		,X3Picture("D3_OP")		,TamSx3("D3_OP")[1]		,TamSx3("D3_OP")[2]		,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Data OP"			,"DATAOP"		,X3Picture("D3_EMISSAO"),TamSx3("D3_EMISSAO")[1],TamSx3("D3_EMISSAO")[2],"AllwaysTrue()"	,"ฐ","D","" } )
	Aadd(aHeader,{"Local"			,"LOCALOP"		,X3Picture("D3_LOCAL")	,TamSx3("D3_LOCAL")[1]	,TamSx3("D3_LOCAL")[2]	,"AllwaysTrue()"	,"ฐ","C","" } )
	Aadd(aHeader,{"Quantidade"		,"QUANTOP"		,X3Picture("D3_QUANT")	,TamSx3("D3_QUANT")[1]	,TamSx3("D3_QUANT")[2]	,"AllwaysTrue()"	,"ฐ","N","" } )

	oObj:SetRegua1(4)
	oObj:IncRegua1("Gerando Relatorio")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
//ณSele็ใo dos Produtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู
	cQuery := " SELECT B1_COD , B1_DESC"
	cQuery += " FROM "+ RetSqlName( 'SB1' )+" AS B1"
	cQuery += " WHERE B1.D_E_L_E_T_ <> '*'"
	cQuery += " ORDER BY B1_COD"

	oObj:SetRegua2(2)
	oObj:IncRegua2("Selecionando Produtos")

	nRecCount := 0
	MemoWrite("ESTRL001a.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTRB1, .F., .T.)

	Count to nRecCount

	If nRecCount > 0
		oObj:SetRegua2(nRecCount)

		dbSelectArea(cTRB1)
		(cTRB1)->(dbGoTop())
		While (cTRB1)->(!Eof())

			oObj:IncRegua2("Verificando Produtos")

			aAdd(aCols,{(cTRB1)->B1_COD,; //Codigo
			(cTRB1)->B1_DESC,; //Descri็ใo
			,; //Serie NF
			,; //Num NF
			,; //Data NF
			,; //Local NF
			,; //Quant NF
			,; //OP
			,; //Data OP
			,; //Local OP
			,; //Quant OP
			.F.})
			(cTRB1)->(DbSkip())
		EndDo

		(cTRB1)->(DbCloseArea())

	Else

		MSGSTOP("Nใo existem dados para este relatorio - SB1!","Aten็ใo")
		(cTRB1)->(DBCLOSEAREA())
		Return

	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSele็ใo das Notas de Saidaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT D2_COD , D2_SERIE , D2_DOC , D2_EMISSAO , D2_LOCAL , D2_QUANT "
	cQuery += " FROM "+ RetSqlName( 'SD2' )+" AS D2"
	cQuery += " WHERE D2.D_E_L_E_T_ <> '*'"
	cQuery += " AND D2_EMISSAO+R_E_C_N_O_ = (SELECT MAX(D2AUX.D2_EMISSAO+D2AUX.R_E_C_N_O_) FROM SD2010 AS D2AUX "
	cQuery += " WHERE D2AUX.D_E_L_E_T_ <> '*' AND D2.D2_COD = D2AUX.D2_COD"
	cQuery += " )"
	cQuery += " ORDER BY D2_COD"

	oObj:SetRegua2(2)
	oObj:IncRegua2("Selecionando Notas de Saida")

	nRecCount := 0
	MemoWrite("ESTRL001b.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTRB2, .F., .T.)

	Count to nRecCount

	If nRecCount > 0
		oObj:IncRegua1("Gerando Relatorio")
		oObj:SetRegua2(nRecCount)

		dbSelectArea(cTRB2)
		(cTRB2)->(dbGoTop())
		While (cTRB2)->(!Eof())
			oObj:IncRegua2("Verificando Notas de Saida")

			nLin := aScan(aCols ,{|x| x[1]== (cTRB2)->D2_COD})

			aCols[nLin][3] := (cTRB2)->D2_SERIE
			aCols[nLin][4] := (cTRB2)->D2_DOC
			aCols[nLin][5] := STOD((cTRB2)->D2_EMISSAO)
			aCols[nLin][6] := (cTRB2)->D2_LOCAL
			aCols[nLin][7] := (cTRB2)->D2_QUANT

			(cTRB2)->(DbSkip())
		EndDo

		(cTRB2)->(DbCloseArea())

	Else

		MSGSTOP("Nใo existem dados para este relatorio - SD2!","Aten็ใo")
		(cTRB2)->(DBCLOSEAREA())
		Return

	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSele็ใo das Ordens de Produ็ใo ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT D3_COD, D3_OP, D3_EMISSAO, D3_LOCAL, D3_QUANT"
	cQuery += " FROM "+ RetSqlName( 'SD3' )+" AS D3"
	cQuery += " WHERE D3.D_E_L_E_T_ <> '*' AND D3.D3_CF LIKE 'RE%' AND D3.D3_OP <> '' "
	cQuery += " AND D3.D3_EMISSAO+D3.R_E_C_N_O_ = (SELECT MAX(D3AUX.D3_EMISSAO+D3AUX.R_E_C_N_O_) FROM SD3010 AS D3AUX "
	cQuery += " WHERE D3AUX.D_E_L_E_T_ <> '*' AND D3AUX.D3_COD = D3.D3_COD AND D3AUX.D3_CF LIKE 'RE%' AND D3AUX.D3_OP <> '' "
	cQuery += " )"
	cQuery += " ORDER BY D3.D3_COD"

	oObj:SetRegua2(2)
	oObj:IncRegua2("Selecionando Ordens de Produ็ใo")

	nRecCount := 0
	MemoWrite("ESTRL001c.sql",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTRB3, .F., .T.)

	Count to nRecCount

	If nRecCount > 0
		oObj:IncRegua1("Gerando Relatorio")
		oObj:SetRegua2(nRecCount)

		dbSelectArea(cTRB3)
		(cTRB3)->(dbGoTop())
		While (cTRB3)->(!Eof())

			oObj:IncRegua2("Verificando Ordens de Produ็ใo")

			nLin := aScan(aCols ,{|x| x[1]== (cTRB3)->D3_COD})

			aCols[nLin][8] := (cTRB3)->D3_OP
			aCols[nLin][9] := STOD((cTRB3)->D3_EMISSAO)
			aCols[nLin][10] := (cTRB3)->D3_LOCAL
			aCols[nLin][11] := (cTRB3)->D3_QUANT

			(cTRB3)->(DbSkip())
		EndDo

		(cTRB3)->(DbCloseArea())

	Else

		MSGSTOP("Nใo existem dados para este relatorio - SD3!","Aten็ใo")
		(cTRB3)->(DBCLOSEAREA())
		Return

	EndIf

	If !Empty(aCols)
		For f := 1 to Len(aCols)
			aCols[f][1] := '="'+ aCols[f][1]+'"'
			aCols[f][4] := IIF(!EMPTY(aCols[f][4]),'="'+ aCols[f][4] +'"',"")
			aCols[f][8] := IIF(!EMPTY(aCols[f][8]),'="'+ aCols[f][8] +'"',"")
		Next f

		DlgToExcel({{"GETDADOS",OemToAnsi("Ultima Movimentacao de Estoque"),aHeader,aCols}})
	Else
		Aviso("ESTRL001","Nao existem dados para o relat๓rio",{"OK"})
	EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Bindo         บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta nos parametros e no help do Sx1               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

	Private cKey := ""
	Private aHelpEng := {}
	Private aHelpPor := {}
	Private aHelpSpa := {}
/*
PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar     ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02  ,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
*/
	PutSx1(cPerg,"01"   ,"Da Linha            ",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    ,"   ",""         ,""   ,"mv_par01",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Ate a Linha         ",""                    ,""                    ,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    ,"   ",""         ,""   ,"mv_par02",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Da Data	          ",""                    ,""                    ,"mv_ch3","D"   ,10      ,0       ,0      , "G",""    ,""   ,""         ,""   ,"mv_par03",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Ate a Data	      ",""                    ,""                    ,"mv_ch4","D"   ,10      ,0       ,0      , "G",""    ,""   ,""         ,""   ,"mv_par04",""         ,""      ,""      ,""    ,""      ,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


	cKey     := "P."+Alltrim(cPerg)+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione o Vendedor Inicial a ser considerado.")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+Alltrim(cPerg)+"02."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione o Vendedor Final a ser considerado.")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+Alltrim(cPerg)+"03."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Indique a data inicial que deseja.")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+Alltrim(cPerg)+"04."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Indique a data final que deseja.")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
