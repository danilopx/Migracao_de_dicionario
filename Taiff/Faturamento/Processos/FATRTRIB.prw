//#Include "FATRTRIB.CH"
#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: FATRTRIB                                     AUTOR: CARLOS TORRES                 DATA: 24/01/2011
// DESCRICAO: Demonstrativo Substituição Tributaria
//--------------------------------------------------------------------------------------------------------------
User Function FATRTRIB()

Local oReport 

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

//--------------------------------------------------------------------------------------------------------------
// Função Static de preparação dos objetos
//--------------------------------------------------------------------------------------------------------------
Static Function ReportDef()
Local oReport
#IFDEF TOP
	Local cAliasQry := GetNextAlias()
#ELSE
	Local cAliasQry := "SD2"
#ENDIF	         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("FATRTRIB","DEMONSTRATIVO SUBSTITUICAO TRIBUTARIA","FIRTRIB", {|oReport| ReportPrint(oReport,cAliasQry)},"Este programa ira emitir o Demonstrativo Substituicao Tributaria" + " " + "ordem de Nota Fiscal.")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Secao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTransp := TRSection():New(oReport,"Notas Fiscais",{"SF2","SD2","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oNFTransp:SetTotalInLine(.F.)

TRCell():New(oNFTransp,"B1_POSIPI"	,"SB1"		,"NBM"						,/*Picture*/						,TamSx3("B1_POSIPI")[1]	,/*lPixel*/,{|| (cAliasQry)->B1_POSIPI })	
TRCell():New(oNFTransp,"D2_COD"		,"SD2" 		,RetTitle("D2_COD")		,PesqPict("SD2","D2_COD")		,TamSx3("D2_COD")[1]		,/*lPixel*/,{|| (cAliasQry)->D2_COD		})	
TRCell():New(oNFTransp,"D2_QUANT"	,"SD2"		,RetTitle("D2_QUANT")	,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_QUANT 	})	
TRCell():New(oNFTransp,"B1_DESC"		,"SB1" 		,"Descricao"						,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	,/*lPixel*/,{|| (cAliasQry)->B1_DESC	})	
TRCell():New(oNFTransp,"D2_PRCVEN"	,"SD2"		,RetTitle("D2_PRCVEN")	,PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_PRCVEN	})	
//TRCell():New(oNFTransp,"D2_TOTAL"	,"SD2"		,RetTitle("D2_TOTAL")	,PesqPict("SD2","D2_TOTAL")	,TamSx3("D2_TOTAL")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_TOTAL	})	
TRCell():New(oNFTransp,"NVLTOTAL"	,"SD2"		,RetTitle("D2_TOTAL")	,PesqPict("SD2","D2_TOTAL")	,TamSx3("D2_TOTAL")[1]	,/*lPixel*/,{|| NVLTOTAL					})	
TRCell():New(oNFTransp,"D2_VALICM"	,"SD2"		,"ICMS IE"						,PesqPict("SD2","D2_VALICM")	,TamSx3("D2_VALICM")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_VALICM	})	
TRCell():New(oNFTransp,"D2_MARGEM"	,"SD2"		,"   MVA"						,PesqPict("SD2","D2_MARGEM")	,TamSx3("D2_MARGEM")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_MARGEM	})	
//TRCell():New(oNFTransp,"D2_BRICMS"	,"SD2"		,STR0028						,PesqPict("SD2","D2_BRICMS")	,TamSx3("D2_BRICMS")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_BRICMS	})	
TRCell():New(oNFTransp,"NVLBRICMS"	,/*Tabela*/	,"  BC ST"						,PesqPict("SD2","D2_BRICMS")	,TamSx3("D2_BRICMS")[1]	,/*lPixel*/,{|| NVLBRICMS					})	
TRCell():New(oNFTransp,"ICMS_ST"		,/*Tabela*/	,"   ICMS ST"						,PesqPict("SD2","D2_BRICMS")	,TamSx3("D2_BRICMS")[1]	,/*lPixel*/,{|| (cAliasQry)->ICMS_ST	})	
TRCell():New(oNFTransp,"NQUANT"		,/*Tabela*/	,"   Dif. ST"						,PesqPict("SD2","D2_ICMSRET")	,TamSx3("D2_ICMSRET")[1],/*lPixel*/,{|| nQuant 						})	

TRFunction():New(oNFTransp:Cell("NVLTOTAL")	,/* cID */	,"SUM"	,/*oBreak*/	,"" /*cTitle*/	,/*cPicture*/	,/*uFormula*/	,.T./*lEndSection*/	,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NVLBRICMS")	,/* cID */	,"SUM"	,/*oBreak*/	,"" /*cTitle*/	,/*cPicture*/	,/*uFormula*/	,.T./*lEndSection*/	,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT"		),/* cID */,"SUM"		,/*oBreak*/,"" /*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no top da pagina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salta Pagina na Quebra da Secao                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTransp:SetPageBreak(.T.)

TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA})

Return(oReport)


//--------------------------------------------------------------------------------------------------------------
// Função Static de execução do Script SQL para alimentar os objetos
//--------------------------------------------------------------------------------------------------------------
Static Function ReportPrint(oReport,cAliasQry)

Local cCliente 	:= ""

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere    := ""
#ENDIF
Local nSomaICMSRET
Local nPerDarj		:= GetNewPar("MV_TFVDARJ",1)
Local	__lDarj 
Local	__nTotBRICMS
Local nFecoepAL	:= GetNewPar("TF_FECOEAL",2)
Local __lFecoepAL
Local nVlVFECPST := 0
Local nTotFecpRj := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser         ³
//³ utilizadas em outras funcoes nao precisando declara-las      ³
//³ como private											  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("NQUANT" 	):SetBlock({|| nQuant		})
oReport:Section(1):Cell("NVLTOTAL"	):SetBlock({|| NVLTOTAL		})
oReport:Section(1):Cell("NVLBRICMS"	):SetBlock({|| NVLBRICMS	})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera o Titulo do Relatorio de acordo com parametros	 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() )	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cWhere := "% AND FT_TIPOMOV='S' "
	

	/*
	--
	-- Implementação: 28/02/2013 por Carlos Torres, solicitante Odair
	-- Regra: Toda nf emitida por Extrema e Itumbiara para MS e MT não deve apresentar dados no relatorio
	--
	-- Acrescentada a regra do chamado 3893 que diz: excluir do relatório : SIGA/FATRTRIB/v.12 as UFs SP e MG - TAIFF PROART EXTREMA
	--
	-- Atendendo solicitaç?o GLPI do Fernando Silva a UF MT foi removida da chave cWhere desta forma os dados ser?o apresentados
	*/
	If (cEmpAnt="03" .AND. cFilAnt="02") .OR. (cEmpAnt="02" .AND. cFilAnt="02")
	
		cWhere += " AND NOT F2_EST IN ('MS','SP','PR','RJ','SC','RS') "
		
	EndIf
	/*
	--
	-- Implementação: 01/03/2013 por Carlos Torres, solicitante Odair
	-- Regra: Toda nf emitida por Extrema para MG não deve apresentar dados no relatorio
	--
	*/
	If cEmpAnt='03' .AND. cFilAnt='02' .AND. 1=2
		cWhere += " AND F2_EST != 'MG' "
	EndIf
	
	cWhere += "%"
	
	dbSelectArea("SF2")				// Cabecalho da Nota de Saida
	dbSetOrder(1)					// Documento,Serie,Cliente,Loja
	
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasQry

	SELECT  F2_FILIAL, F2_EST, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, 
			B1_POSIPI, D2_COD, SUM(D2_QUANT) AS D2_QUANT, B1_DESC,
			D2_PRCVEN, SUM(D2_TOTAL) AS D2_TOTAL, SUM(D2_VALICM) AS D2_VALICM, D2_MARGEM, SUM(D2_VALIPI) AS D2_VALIPI,
			SUM(D2_BRICMS) AS D2_BRICMS,	SUM(ICMS_ST) as ICMS_ST,
			SUM(D2_ICMSRET) AS D2_ICMSRET, F2_TIPO, F2_EMISSAO,
			A1_NOME, A1_MUN, A1_EST, A1_CGC, A1_INSCR, D2_TES ,D2_ITEM , F2_TIPOCLI, D2_ITEMCC
	
	FROM 
		(	SELECT DISTINCT SF2.F2_FILIAL, SF2.F2_EST, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_DOC, SF2.F2_SERIE, 
			SB1.B1_POSIPI, SD2.D2_COD, SD2.D2_QUANT, SB1.B1_DESC,
			SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_VALICM, SD2.D2_MARGEM,SD2.D2_VALIPI,
			SD2.D2_BRICMS,	(SD2.D2_BRICMS*SD2.D2_ALIQSOL)/100 as ICMS_ST,
			SD2.D2_ICMSRET AS D2_ICMSRET, SF2.F2_TIPO, SF2.F2_EMISSAO,
			SA1.A1_NOME, SA1.A1_MUN, SA1.A1_EST, SA1.A1_CGC, SA1.A1_INSCR, D2_TES , D2_ITEM , F2_TIPOCLI, D2_ITEMCC
	
			FROM %Table:SF2% SF2
				INNER JOIN %Table:SA1% SA1 ON SA1.A1_FILIAL = %xFilial:SA1% AND SA1.A1_COD=SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.%notdel%
				INNER JOIN %Table:SD2% SD2 ON SD2.D2_FILIAL = %xFilial:SD2% AND SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.%notdel%
				INNER JOIN %Table:SB1% SB1 ON SB1.B1_FILIAL = %xFilial:SB1% AND SB1.B1_COD=SD2.D2_COD AND SB1.%notdel%
				INNER JOIN %Table:SFT% SFT ON SFT.FT_FILIAL = %xFilial:SFT% AND SFT.FT_SERIE=SD2.D2_SERIE AND SFT.FT_NFISCAL=SD2.D2_DOC AND SFT.FT_PRODUTO=SD2.D2_COD AND SFT.FT_ITEM=SD2.D2_ITEM AND SFT.%notdel%
			
			WHERE F2_FILIAL = %xFilial:SF2%
				AND F2_DOC >= %Exp:mv_par03% AND F2_DOC <= %Exp:mv_par04%
				AND F2_EMISSAO >= %Exp:DTOS(mv_par05)% AND F2_EMISSAO <= %Exp:DTOS(mv_par06)%
				AND F2_CLIENTE >= %Exp:mv_par01% AND F2_CLIENTE <= %Exp:mv_par02%
				AND F2_EST >= %Exp:mv_par07% AND F2_EST <= %Exp:mv_par08%
				AND SF2.%NotDel%
				AND D2_FILIAL = %xFilial:SD2%
				%Exp:cWhere%
			
		) TMP
	GROUP BY F2_FILIAL, F2_EST, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, B1_POSIPI, D2_COD, B1_DESC, D2_PRCVEN, D2_MARGEM,F2_TIPO, F2_EMISSAO,
			A1_NOME, A1_MUN, A1_EST, A1_CGC, A1_INSCR	, D2_TES , D2_ITEM , F2_TIPOCLI, D2_ITEMCC
	ORDER BY F2_DOC,F2_SERIE
	EndSql 
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	dbSelectArea(cAliasQry)			// Cabecalho da Nota de Saida
	dbSetOrder(1)					// Documento,Serie,Cliente,Loja
	cCondicao   := "F2_FILIAL == '"+xFilial("SF2")+"' "
	cCondicao   += " .And. F2_DOC >= '"+mv_par03+"' .And. F2_DOC <= '"+mv_par04+"'"
	cCondicao   += " .And. Dtos(F2_EMISSAO) >= '"+Dtos(mv_par05)+"' .And. Dtos(F2_EMISSAO) <= '"+Dtos(mv_par06)+"'"
	cCondicao   += " .And. F2_CLIENTE >= '"+mv_par01+"' .And. F2_CLIENTE <= '"+mv_par02+"'"
	cCondicao   += " .And. F2_EST >= '"+mv_par07+"' .And. F2_EST <= '"+mv_par08+"'"
    
	oReport:Section(1):SetFilter(cCondicao,"F2_FILIAL+F2_DOC+F2_SERIE")

#ENDIF		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF4")
dbSetorder(1)
dbSelectArea("SFT")
dbSetorder(1)

oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
oReport:Section(1):Init()
                          
While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2")=F2_FILIAL

	__nTotBRICMS 	:= 0
	nVlVFECPST		:= 0
	cCliente := (cAliasQry)->F2_CLIENTE + (cAliasQry)->F2_LOJA
	cNfDocto	:= (cAliasQry)->(F2_DOC + F2_SERIE)
	cLinDet	:= (cAliasQry)->F2_CLIENTE + " - Loja: " + (cAliasQry)->F2_LOJA
	dbSelectArea("SD2")
	dbSetorder(3)
	dbSeek(xFilial("SD2")+(cAliasQry)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA ) )
	nSomaICMSRET	:= 0
	While xFilial("SD2")=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == (cAliasQry)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA )
		If SF4->(DbSeek( xFilial("SF4") + SD2->D2_TES ))
			If SF4->F4_SITTRIB $ '10|30'
				nSomaICMSRET	+= SD2->D2_ICMSRET
			EndIf
		EndIf
		SD2->(DbSkip())
	End
	If SM0->M0_CODIGO $ GetNewPar("TF_REGIMEE","")  // Empresas que participam do regime especial
		cAliasAuxSd2 := GetNextAlias()

		cQuery := "SELECT IsNull(COUNT(*),0) AS REGIME "
		cQuery += " FROM "+RetSqlName("SD2")+" SD2 WITH(NOLOCK) "
		cQuery += " 	INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) ON SF4.F4_FILIAL = '" + xFilial("SF4") + "' AND SF4.F4_CODIGO=SD2.D2_TES " 
		cQuery += " WHERE  SD2.D2_FILIAL 	= '" + xFilial("SD2") + "' "
		cQuery += "		AND SD2.D_E_L_E_T_  	= ' ' "
		cQuery += "		AND SD2.D2_DOC 		= '" + (cAliasQry)->F2_DOC + "' "
		cQuery += "		AND SD2.D2_SERIE 		= '" + (cAliasQry)->F2_SERIE + "' "
		cQuery += "		AND SD2.D2_CLIENTE 	= '" + (cAliasQry)->F2_CLIENTE + "' "
		cQuery += "		AND SD2.D2_LOJA 		= '" + (cAliasQry)->F2_LOJA + "' "
		cQuery += "		AND SF4.D_E_L_E_T_	= ' ' "
		cQuery += "		AND SF4.F4_SITTRIB	= '00' "
		
		TcQuery cQuery NEW ALIAS (cAliasAuxSd2)

		SM4->(DbSetOrder(1))

		__cTexto := ""
		ZAL->(DbSetOrder(1))
		ZAL->(DbSeek( xFilial("ZAL") + (cAliasQry)->F2_CLIENTE + (cAliasQry)->F2_LOJA ))	
		While ZAL->(ZAL_FILIAL+ZAL_CLIENT+ZAL_LOJA) = xFilial("ZAL") + (cAliasQry)->F2_CLIENTE + (cAliasQry)->F2_LOJA .AND. !ZAL->(Eof())
			If (((cAliasAuxSd2)->REGIME  !=  0 .and. ZAL->ZAL_TIPSIT = 'N') .or. ZAL->ZAL_TIPSIT $ 'T' ) .and. (cAliasQry)->F2_EMISSAO <= ZAL->ZAL_VALIDA  .and.  Empty( __cTexto ) 

				SM4->(DbSeek( xFilial("SM4") + ZAL->ZAL_MENSAG )) 
				__cTexto += Substr(Alltrim( SM4->M4_FORMULA ) ,2, len(Alltrim(SM4->M4_FORMULA))-2 ) // Retirada as aspas de inicio e fim 
				__cTexto += ZAL->ZAL_CONCES 
            
			EndIf
			ZAL->(DbSkip())
		End
		If !Empty(  __cTexto  )
			nSomaICMSRET := 0
		EndIf
		(cAliasAuxSd2)->(DbCloseArea())
		dbSelectArea(cAliasQry)	
	EndIf
	If nSomaICMSRET != 0

		If !(cAliasQry)->F2_TIPO $ "DB"
			dbSelectArea("SA1") 
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+cCliente)
			oReport:PrintText("Cliente" + ": " + (cAliasQry)->F2_CLIENTE + " Loja: "+ (cAliasQry)->F2_LOJA +" - " + A1_NOME)	
			oReport:PrintText("CNPJ: " + A1_CGC + "  IE: " + A1_INSCR )	
			oReport:PrintText("Municipio: " + A1_MUN + "  UF: " + A1_EST )	
			__lDarj := SA1->A1_EST = "RJ"
			__lFecoepAL := SA1->A1_EST = "AL" .AND. nFecoepAL != 0
		Else
			dbSelectArea("SA2") 
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+cCliente)
			oReport:PrintText("Cliente" + ": " + (cAliasQry)->F2_CLIENTE + " - " + A2_NOME)	
			oReport:PrintText("CNPJ: " + A2_CGC + "  IE: " + A2_INSCR )	
			oReport:PrintText("Municipio: " + A2_MUN + "   UF: " + A2_EST )	
			__lDarj := .F.
			__lFecoepAL := .F.
		Endif	
		oReport:PrintText("Nota Fiscal: " + (cAliasQry)->F2_DOC + " - Serie: " + (cAliasQry)->F2_SERIE + "  Dt. Emissão: " + Dtoc((cAliasQry)->F2_EMISSAO) )
		//oReport:SkipLine()
	
		nQuant	:= 0
		nVlTotal	:= 0
		nTotFecpRj := 0
		
		dbSelectArea(cAliasQry)	
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2") = F2_FILIAL .And. F2_CLIENTE+F2_LOJA = cCliente .And. F2_DOC + F2_SERIE = cNfDocto	
	
			/*
			dbSelectArea("SD2")
			dbSetorder(3)
			dbSeek(xFilial("SD2")+(cAliasQry)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+D2_COD) )
			nQuant	:= 0
			nVlTotal	:= 0
			While xFilial("SD2")=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD == (cAliasQry)->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+D2_COD)
				nQuant	+= D2_ICMSRET
				nVlTotal	+= D2_TOTAL
				dbSkip()
			End
			*/
			If SF4->(DbSeek( xFilial("SF4") + (cAliasQry)->D2_TES ))
				If SF4->F4_SITTRIB $ '10|30'
					nQuant	:= (cAliasQry)->D2_ICMSRET
					nVlTotal	:= (cAliasQry)->D2_TOTAL
					If __lDarj
						If ALLTRIM((cAliasQry)->F2_TIPOCLI) $ 'R|F'
							nVlVFECPST := 0
							//FT_FILIAL, FT_TIPOMOV, FT_SERIE, FT_NFISCAL, FT_CLIEFOR, FT_LOJA, FT_ITEM, FT_PRODUTO
							If SFT->(DbSeek( xFilial("SFT") + "S" + (cAliasQry)->F2_SERIE + (cAliasQry)->F2_DOC + (cAliasQry)->F2_CLIENTE + (cAliasQry)->F2_LOJA + (cAliasQry)->D2_ITEM + space(02) + (cAliasQry)->D2_COD ))
								nVlVFECPST := SFT->FT_VFECPST
							EndIf
							nQuant	:= (cAliasQry)->D2_ICMSRET - nVlVFECPST
							nTotFecpRj += nVlVFECPST
						EndIf	
					EndIf
					If __lFecoepAL
						nQuant	:= (cAliasQry)->D2_ICMSRET - ((cAliasQry)->D2_BRICMS * (nFecoepAL/100))
					EndIf
				Else
					nQuant	:= 0
					nVlTotal	:= 0
				EndIf
         Else
				nQuant	:= (cAliasQry)->D2_ICMSRET
				nVlTotal	:= (cAliasQry)->D2_TOTAL
				If __lDarj
					nQuant	:= (cAliasQry)->D2_ICMSRET - ((cAliasQry)->D2_BRICMS * (nPerDarj/100))
				EndIf
				If __lFecoepAL
					nQuant	:= (cAliasQry)->D2_ICMSRET - ((cAliasQry)->D2_BRICMS * (nFecoepAL/100))
				EndIf
         EndIf
			If SM0->M0_CODIGO='01'
				NVLTOTAL		:= (cAliasQry)->(D2_TOTAL+D2_VALIPI)
			Else
				NVLTOTAL		:= (cAliasQry)->D2_TOTAL
			EndIf
			NVLBRICMS 	:= (cAliasQry)->D2_BRICMS
     		__nTotBRICMS+= (cAliasQry)->D2_BRICMS
     		
			If !(cAliasQry)->F2_TIPO $ "DB"
				TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
			Else
				TRPosition():New(oReport:Section(1),"SA2",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
			Endif	
			oReport:Section(1):PrintLine()
	
			dbSelectArea(cAliasQry)
			dbSkip()
			oReport:IncMeter()
		End

		If	__lDarj 
			oReport:skipLine()
			oReport:PrintText( "Valor DARJ sobre "+Alltrim(Str(nPerDarj))+"%: " + Alltrim(Transform( nTotFecpRj ,PesqPict("SD2","D2_BRICMS"))) ) 
		EndIf
		If __lFecoepAL
			oReport:skipLine()
			oReport:PrintText( "Valor FECOEP sobre "+Alltrim(Str(nFecoepAL))+"%: " + Alltrim(Transform( __nTotBRICMS * (nFecoepAL/100),PesqPict("SD2","D2_BRICMS"))) ) 
		EndIf
		
		oReport:Section(1):SetTotalText("Total do Cliente" + ": " + cLinDet)	
		oReport:Section(1):Finish()
	
		// Forca salto de pagina no fim da secao
		oReport:nrow := 5000			
		oReport:skipLine()
		
		oReport:Section(1):Init()
	Else
		dbSelectArea(cAliasQry)	
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2") = F2_FILIAL .And. F2_CLIENTE+F2_LOJA = cCliente .And. F2_DOC + F2_SERIE = cNfDocto	
			dbSkip()
			oReport:IncMeter()
		End
	EndIf		
End

oReport:Section(1):SetPageBreak(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Query/SetFilter                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAliasQry)->(dbCloseArea())

Return

