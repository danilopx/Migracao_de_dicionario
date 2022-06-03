#Include 'Protheus.ch'

#DEFINE ENTER CHR(13) + CHR(10)

User Function SF1100E()
	Local aZA6Alias	:= ZA6->(GetArea())
	Local aBonif 	:= {}
	Local cTpVerbaTT:= GetMV("MV__FINVTT",.F.,"02") // Tipo de verba: 02 - Verba Tática ou 03 - Verba Bonificação
	Local _cQryCx   := ""
	Local _cAreaCx  := GetNextAlias()

	If SF1->F1_TIPO == "D"

		ZA6->(DbSetOrder(1))
		ZA6->(DbSeek(xFilial("ZA6")+SF1->(F1_FORNECE+F1_LOJA)))
		While ZA6->ZA6_FILIAL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA = xFilial("ZA6")+SF1->(F1_FORNECE+F1_LOJA) .And. ! ZA6->(Eof())
			Aadd(aBonif, {ZA6->ZA6_TPBON, ZA6->ZA6_PERC, ZA6->ZA6_ABIMP})
			ZA6->(DbSkip())
		End

		If ! Empty(aBonif)
			Processa({|| EstornaNDC(aBonif)},"Estornando NDCs " + SF1->F1_FORNECE + "-" + SF1->F1_LOJA + "-" + Alltrim(Posicione("SA1",1,xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA),"A1_NOME")) + "...")
		EndIf

	/* Estorna título no financeiro quando verba tática */
		If SC5->(FIELDPOS("C5_DESCTAT")) > 0

			_cQryCx := "SELECT " + ENTER
			_cQryCx += "	ISNULL(MAX(C5_PERCTAT),0) AS C5_PERCTAT " + ENTER
			_cQryCx += "	,ISNULL(MAX(C5_DESCTAT),'') AS C5_DESCTAT " + ENTER
			_cQryCx += "FROM " + RetSQLName("SD1") + " SD1 WITH(NOLOCK) " + ENTER
			_cQryCx += "INNER JOIN " + RetSQLName("SD2") + " SD2 WITH(NOLOCK) " + ENTER
			_cQryCx += "ON D2_FILIAL=D1_FILIAL " + ENTER
			_cQryCx += "AND D2_DOC=D1_NFORI " + ENTER
			_cQryCx += "AND D2_SERIE=D1_SERIORI " + ENTER
			_cQryCx += "AND D2_COD=D1_COD " + ENTER
			_cQryCx += "AND D2_ITEM=D1_ITEMORI " + ENTER
			_cQryCx += "AND SD2.D_E_L_E_T_='' " + ENTER
			_cQryCx += "INNER JOIN " + RetSQLName("SC5") + " SC5 WITH(NOLOCK) " + ENTER
			_cQryCx += "ON C5_FILIAL=D1_FILIAL " + ENTER
			_cQryCx += "AND C5_NUM=D2_PEDIDO " + ENTER
			_cQryCx += "AND SC5.D_E_L_E_T_='' " + ENTER
			_cQryCx += "AND C5_CONDPAG NOT IN ('N01','N02') " + ENTER
			_cQryCx += "INNER JOIN " + RetSQLName("SA1") + " SA1 WITH(NOLOCK) " + ENTER
			_cQryCx += "ON A1_FILIAL=D1_FILIAL " + ENTER
			_cQryCx += "AND A1_COD=C5_CLIENTE " + ENTER
			_cQryCx += "AND A1_LOJA=C5_LOJACLI " + ENTER
			_cQryCx += "AND SA1.D_E_L_E_T_='' " + ENTER
			_cQryCx += "AND A1_BCO1!='999' " + ENTER
			_cQryCx += "WHERE D1_FILIAL='" + xFilial("SD1") + "' " + ENTER
			_cQryCx += "AND D1_DOC='" + SF1->F1_DOC + "' " + ENTER
			_cQryCx += "AND D1_SERIE='" + SF1->F1_SERIE + "' " + ENTER
			_cQryCx += "AND D1_FORNECE='" + SF1->F1_FORNECE + "' " + ENTER
			_cQryCx += "AND D1_LOJA='" + SF1->F1_LOJA + "' " + ENTER
			_cQryCx += "AND SD1.D_E_L_E_T_='' " + ENTER

			MEMOWRITE(PROCNAME() + "_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQryCx)

			DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQryCx), (_cAreaCx), .F., .T.)

			DBSelectArea(_cAreaCx)

			If ALLTRIM((_cAreaCx)->C5_DESCTAT) == cTpVerbaTT .AND. (_cAreaCx)->C5_PERCTAT > 0
				Processa({|| EstorDevVTT( (_cAreaCx)->C5_PERCTAT) },"Gerando Verba Tática ...")
			EndIf
		EndIf
	/* Fim do processamento de verba tática */

	EndIf
	ZA6->(RestArea(aZA6Alias))
Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³EstornaNDC   º Autor ³Carlos Torres  º Data ³  06/06/2016   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Estorno das NDCs de Bonificacoes Financeiras por Verba     º±±
±±º          ³ Promocional                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EstornaNDC(aBonif)
	Local aFin040		:= {}
	Local cZA6Prefixo	:= ""
	Local aSE1Alias := SE1->(GetArea())
	Local nX := 0
	Local n	 := 0

	For nX := 1 to Len(aBonif)

		cZA6Prefixo := aBonif[nX,1]
		If TamSX3("E1_PREFIXO")[1] > TamSX3("ZA6_TPBON")[1]
			cZA6Prefixo += Space(TamSX3("E1_PREFIXO")[1] - TamSX3("ZA6_TPBON")[1])
		EndIf

		// (2) - E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		SE1->(DbSetOrder(2))
		If SE1->(DbSeek( xFilial("SE1") + SF1->(F1_FORNECE + F1_LOJA) + cZA6Prefixo + SF1->F1_DOC + Space(TamSX3("E1_PARCELA")[1]) + "NDC" ))
			AADD(aFIN040,{ {"E1_PREFIXO"	,	SE1->E1_PREFIXO	,nil},;
				{"E1_NUM"		,	SE1->E1_NUM		,nil},;
				{"E1_PARCELA"	,	SE1->E1_PARCELA	,nil},;
				{"E1_TIPO"		,	SE1->E1_TIPO		,nil},;
				{"E1_NATUREZ"	,	SE1->E1_NATUREZ	,nil},;
				{"E1_CLIENTE"	,	SE1->E1_CLIENTE	,nil},;
				{"E1_LOJA"		,	SE1->E1_LOJA		,nil}	 })
		EndIf
	Next
//Begin Transaction

	lMsErroAuto := .F. // variavel interna da rotina automatica
	lMsHelpAuto := .F.

	For n := 1 to len(aFIN040)
		MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],5)
		If LMsErroAuto
			MostraErro()
			//DisarmTransaction()
			//Break
		Endif
	Next
//End Transaction
	SE1->(RestArea(aSE1Alias))
Return(.T.)


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³EstornaNDC   º Autor ³Carlos Torres  º Data ³  06/06/2016   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Estorno das NDCs de Verba Tática no Financeiras            º±±
±±º          ³ Promocional                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function EstorDevVTT(__NPERCTAT)
	Local aFin040	:= {}
	Local aSE1Alias := SE1->(GetArea())
	Local _cParcel	:= Space(TamSX3("E1_PARCELA")[1])
	Local n			:= 0
	
	// (2) - E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
	SE1->(DbSetOrder(2))
	If  SE1->(DbSeek( xFilial("SE1") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC + _cParcel + "NDC" ))
		AADD(aFIN040,{ {"E1_PREFIXO"	,	SF1->F1_SERIE	,nil},;
			{"E1_NUM"		,	SF1->F1_DOC			,nil},;
			{"E1_PARCELA"	,	_cParcel			,nil},;
			{"E1_TIPO"		,	"NDC"				,nil},;
			{"E1_NATUREZ"	,	"NCCAB+"			,nil},;
			{"E1_CLIENTE"	,	SF1->F1_FORNECE		,nil},;
			{"E1_LOJA"		,	SF1->F1_LOJA		,nil}	 })

		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.

		For n := 1 to len(aFIN040)
			MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],5)
			If LMsErroAuto
				MostraErro()
			Endif
		Next
	EndIf
	SE1->(RestArea(aSE1Alias))
Return(.T.)


