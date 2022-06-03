//#Include "FATRTRIB.CH"
#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "fileio.ch"
#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE GNRE_TAB CHR(9)
#DEFINE GNRE_CRLF CHR(13)+CHR(10)

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: FATRTRIB2                                    AUTOR: CARLOS TORRES                 DATA: 27/01/2011
// DESCRICAO: Demonstrativo Substituição Tributaria do tipo II - sem protocolo
//--------------------------------------------------------------------------------------------------------------
User Function FATRTRI2()
	Local xSf2Alias	:= SF2->(GetArea())
	Local xSe1Alias	:= SE1->(GetArea())
	Local cAlias  := "SF2"
	Local cFiltra := "F2_FILIAL == '"+xFilial('SF2')+"' "

	Private cCadastro	:= "Demonstrativo ST sem"
	Private aRotina  	:= {}
	Private aIndexSA2	:= {}
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

	U_TFSX6NAT()

	SE1->(DbSetOrder(2))

	AADD(aRotina,{"Pesquisar"			,"PesqBrw"			,0,1})
	AADD(aRotina,{"Legenda"				,"U_TRB2Lege"		,0,3})
	AADD(aRotina,{"Relatorio"			,"U_ImpTRIB2"		,0,6})
	AADD(aRotina,{"Gera Financeiro"	,"U_GeraFin"		,0,7})
	AADD(aRotina,{"Gera GNRE Manual"	,"U_GeraGNRE( .T., 0, Ctod('  /  /  ') )"		,0,8})

	dbSelectArea(cAlias)

	dbSetOrder(1)
	Eval(bFiltraBrw)

	mBrowse(6,1,22,75,cAlias,,,,,,U_TRBLegenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xSf2Alias)
RestArea(xSe1Alias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function TRBLegenda(cAlias)

	Local aLegenda := { 	{"BR_VERDE"		, 	"NF com financeiro" 		},;
		{"BR_VERMELHO"	, 	"NF sem financeiro" 		}}
	Local uRetorno := .T.

	uRetorno := {}

	Aadd(uRetorno, { ' U_EsFinanza(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA) = 1 ', aLegenda[1][1] } )
	Aadd(uRetorno, { ' U_EsFinanza(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA) = 0 ', aLegenda[2][1] } )

Return uRetorno

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function TRB2Lege()
	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		, 	"NF com financeiro" 		})
	AADD(aLegenda,{"BR_VERMELHO"	,	"NF sem financeiro"		})

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

User Function ImpTRIB2()
	Local oReport

	If FindFunction("TRepInUse") .And. TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

Return

//--------------------------------------------------------------------------------------------------------------
// Função que verifica se gerou financeiro
//--------------------------------------------------------------------------------------------------------------
User Function EsFinanza( _cFDocto, _cFSerie, _cFCliente, _FLojaCli )
	Local nRetorno
	Local __cTitulo := Substr("ST-" + Alltrim(Str( Val(_cFDocto) )) + Space(9) ,1,9)
	Local __cParcel := Space(02)
	Local __cTipoDc := "NDC"
	Local __cAserie := Substr(Alltrim(_cFSerie),1,1)

	If SE1->(DbSeek( xFilial("SE1")+_cFCliente+_FLojaCli+"FI"+__cAserie+__cTitulo + __cParcel + __cTipoDc ))
		nRetorno := 1
	Else
		If SE1->(DbSeek( xFilial("SE1")+_cFCliente+_FLojaCli+"FI"+__cAserie+__cTitulo + "01" + __cTipoDc ))
			nRetorno := 1
		Else
			nRetorno := 0
		EndIf
	Endif
Return (nRetorno)

//--------------------------------------------------------------------------------------------------------------
// Função Static de preparação dos objetos
//--------------------------------------------------------------------------------------------------------------
Static Function ReportDef()
	Local oReport
	Local cAliasQry := "TSQL" //GetNextAlias()

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
	oReport := TReport():New("FATRTRI2","DEMONSTRATIVO SUBSTITUICAO TRIBUTARIA S/PROTOCOLO","FIRTRIB", {|oReport| ReportPrint(oReport,cAliasQry)},"Este programa ira emitir o Demonstrativo Substituicao Tributaria" + " " + "ordem de Nota Fiscal.")
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
	TRCell():New(oNFTransp,"ICMS_ST"		,/*Tabela*/	,"   ICMS ST"						,PesqPict("SD2","D2_BRICMS")	,TamSx3("D2_BRICMS")[1]	,/*lPixel*/,{|| (cAliasQry)->ICMS_ST_II})
	TRCell():New(oNFTransp,"NQUANT"		,/*Tabela*/	,"   Dif. ST"						,PesqPict("SD2","D2_ICMSRET")	,TamSx3("D2_ICMSRET")[1],/*lPixel*/,{|| nQuant 						})

	TRFunction():New(oNFTransp:Cell("NVLTOTAL")	,/* cID */	,"SUM"	,/*oBreak*/	,""/*cTitle*/	,/*cPicture*/	,/*uFormula*/	,.T./*lEndSection*/	,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oNFTransp:Cell("NVLBRICMS")	,/* cID */	,"SUM"	,/*oBreak*/	,""/*cTitle*/	,/*cPicture*/	,/*uFormula*/	,.T./*lEndSection*/	,.F./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oNFTransp:Cell("NQUANT")		,/* cID */	,"SUM"	,/*oBreak*/	,""/*cTitle*/	,/*cPicture*/	,/*uFormula*/	,.T./*lEndSection*/	,.F./*lEndReport*/,/*lEndPage*/)

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

	Local cCliente		:= ""
	Local cAliqInterna:= GetNewPar("MV_ESTICM","")
	Local nPerDarj		:= GetNewPar("MV_TFVDARJ",1)
	Local	__lDarj
	Local	__nTotBRICMS
	Local nFecoepAL	:= GetNewPar("TF_FECOEAL",2)
	Local __lFecoepAL
	Local cMV_ESTADO	:= GetMv('MV_ESTADO')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser         ³
//³ utilizadas em outras funcoes nao precisando declara-las      ³
//³ como private											  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):Cell("NVLTOTAL"	):SetBlock({|| NVLTOTAL		})
	oReport:Section(1):Cell("NQUANT" 	):SetBlock({|| nQuant		})
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
	aResult := {}
	If TCSPExist("SP_REL_DEMONSTRATIVO_ST")
		aResult := TCSPEXEC("SP_REL_DEMONSTRATIVO_ST", mv_par01, mv_par02, mv_par03, mv_par04, DTOS(mv_par05), DTOS(mv_par06), cAliqInterna, SM0->M0_CODIGO, SF2->F2_FILIAL, cMV_ESTADO, MV_PAR07, MV_PAR08, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	Endif
	IF !Empty(aResult)
		If Select(cAliasQry) > 0
			dbSelectArea(cAliasQry)
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS cAliasQry
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_DEMONSTRATIVO_ST: '+TcSqlError())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oReport:Section(1):BeginQuery()
	dbSelectArea("TSQL")				// Cabecalho da Nota de Saida
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)
	oReport:Section(1):Init()

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2")=F2_FILIAL
		lIsento	:= .F.
		cCliente := (cAliasQry)->F2_CLIENTE + (cAliasQry)->F2_LOJA
		cNfDocto	:= (cAliasQry)->(F2_DOC + F2_SERIE)
		cLinDet	:= (cAliasQry)->F2_CLIENTE + " - Loja: " + (cAliasQry)->F2_LOJA
		nAliqLocal := Val( Substr(cAliqInterna , At( (cAliasQry)->A1_EST , cAliqInterna )+2,2) )
		If !(cAliasQry)->F2_TIPO $ "DB"
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+cCliente)
			oReport:PrintText("Cliente" + ": " + (cAliasQry)->F2_CLIENTE + " Loja: "+ (cAliasQry)->F2_LOJA +" - " + A1_NOME + (cAliasQry)->A1_SIMPLES )
			oReport:PrintText("CNPJ: " + A1_CGC + "  IE: " + A1_INSCR )
			oReport:PrintText("Municipio: " + A1_MUN + "  UF: " + A1_EST + "  Aliq. Local: " + Str(nAliqLocal)+"%" )
			__lDarj := SA1->A1_EST = "RJ"
			__lFecoepAL := SA1->A1_EST = "AL" .AND. nFecoepAL != 0
			lIsento	:= At( "ISENT" , SA1->A1_INSCR ) != 0

		Else
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+cCliente)
			oReport:PrintText("Cliente" + ": " + (cAliasQry)->F2_CLIENTE + " - " + A2_NOME)
			oReport:PrintText("CNPJ: " + A2_CGC + "  IE: " + A2_INSCR )
			oReport:PrintText("Municipio: " + A2_MUN + "   UF: " + A2_EST )
			__lDarj := .F.
			__lFecoepAL := .F.

			lIsento	:= At( "ISENT" , SA2->A2_INSCR ) != 0

		Endif
		cDtEmissao := Substr( (cAliasQry)->F2_EMISSAO ,7,2) + "/"
		cDtEmissao += Substr( (cAliasQry)->F2_EMISSAO ,5,2) + "/"
		cDtEmissao += Substr( (cAliasQry)->F2_EMISSAO ,1,4)

		oReport:PrintText("Nota Fiscal: " + (cAliasQry)->F2_DOC + " - Serie: " + (cAliasQry)->F2_SERIE + "  Dt. Emissão: " + cDtEmissao) // Dtoc((cAliasQry)->F2_EMISSAO) )
		//oReport:SkipLine()
		__nTotBRICMS := 0

		dbSelectArea(cAliasQry)
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2") = F2_FILIAL .And. F2_CLIENTE+F2_LOJA = cCliente .And. F2_DOC + F2_SERIE = cNfDocto

			nQuant	:= 0
			If (cAliasQry)->D2_MARGEM != 0
				nD2_BRICMS	:= 0
				If SM0->M0_CODIGO='01'
					nD2_BRICMS	:= ((cAliasQry)->(D2_TOTAL+D2_VALIPI)*(1+((cAliasQry)->D2_MARGEM/100)))
				Else
					nD2_BRICMS	:= ((cAliasQry)->D2_TOTAL*(1+((cAliasQry)->D2_MARGEM/100)))
				EndIf
				If nD2_BRICMS > 0
					nQuant	+= (nD2_BRICMS * (nAliqLocal/100) ) - (cAliasQry)->D2_VALICM
				EndIf
			EndIf

			If SM0->M0_CODIGO='01'
				NVLTOTAL		:= (cAliasQry)->(D2_TOTAL+D2_VALIPI)
			Else
				NVLTOTAL		:= (cAliasQry)->D2_TOTAL
			EndIf
			NVLBRICMS 	:= (cAliasQry)->D2_BRICMS
			__nTotBRICMS+= (cAliasQry)->D2_BRICMS

			If lIsento
				nQuant			:= 0
				__nTotBRICMS 	:= 0
				NVLBRICMS		:= 0
			EndIf

			If !(cAliasQry)->F2_TIPO $ "DB"
				TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
			Else
				TRPosition():New(oReport:Section(1),"SA2",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
			Endif
			oReport:Section(1):PrintLine()

			dbSkip()
			oReport:IncMeter()
		End

		If	__lDarj
			oReport:skipLine()
			oReport:PrintText( "Valor DARJ sobre "+Alltrim(Str(nPerDarj))+"%: " + Alltrim(Transform( __nTotBRICMS * (nPerDarj/100),PesqPict("SD2","D2_BRICMS"))) )
		EndIf
		If	__lFecoepAL
			oReport:skipLine()
			oReport:PrintText( "Valor FECOEP sobre "+Alltrim(Str(nFecoepAL))+"%: " + Alltrim(Transform( __nTotBRICMS * (nFecoepAL/100),PesqPict("SD2","D2_BRICMS"))) )
		EndIf

		oReport:Section(1):SetTotalText("Total do Cliente" + ": " + cLinDet)
		oReport:Section(1):Finish()

		// Forca salto de pagina no fim da secao
		oReport:nrow := 5000
		oReport:skipLine()

		oReport:Section(1):Init()

	End

	oReport:Section(1):SetPageBreak(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Query/SetFilter                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	(cAliasQry)->(dbCloseArea())

	//Exclui a tabela temporaria do Banco de Dados
	If TcCanOpen(aResult[1])
		TcSqlExec("DROP TABLE "+aResult[1])
	EndIf

	If !Empty(mv_par03)
		SF2->(DbSetOrder(1))
		SF2->(DbSeek( xFilial("SF2") + mv_par03 ))
	EndIf

Return

//--------------------------------------------------------------------------------------------------------------
// Função para gerar o financeiro, com base no demonstrativo ST sem protocolo
//--------------------------------------------------------------------------------------------------------------
User Function GeraFin
	Local aVetor 		:= {}
	Local pVetor 		:= {}
	Local __cTitulo	:= Substr("ST-" + Alltrim(Str( Val( SF2->F2_DOC ) )) + Space(9) ,1,9)
	Local __cParcel	:= Space(02)
	Local __cTipoDc	:= "NDC"
	Local __cPrefixo	:= "FI"+Alltrim(SF2->F2_SERIE)
	Local _cFCliente	:= SF2->F2_CLIENTE
	Local _cFLojaCli	:=	SF2->F2_LOJA
	Local _cNaturFin	:= GetNewPar("TF_GNRENAT","2351")
	Local __dVencto	:= dDataBase + 15
	Local __nVlSt		:= 0
	Local nVlComProto	:= 0
	Local _xSf2Alias	:= SF2->(GetArea())
	Local _cHistFin	:= "REEMBOLSO DE ST"
	Local __cSf2Doc	:= SF2->F2_DOC
	Local __cSf2Serie := SF2->F2_SERIE
	Local __cSf2Cli   := SF2->F2_CLIENTE
	Local __cSf2Loja  := SF2->F2_LOJA
	Local nPerDarj		:= GetNewPar("MV_TFVDARJ",1)
	Local _nVlDarj		:= 0
	Local _cVende1		:= SF2->F2_VEND1
	Local _xSa1Alias	:= SA1->(GetArea())
	Local __cUniNeg	:= ""

	Private __dVenceP1	:= ctod("  /  /  ")
	Private __dVenceP2	:= ctod("  /  /  ")
	Private __dVenceP3	:= ctod("  /  /  ")
	Private __dVenceR3	:= ctod("  /  /  ")
	Private __nVlBaseST	:= 0

	SA1->(DbSetOrder(1))
	SA1->(DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))

	If U_EsFinanza(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA) = 1
		MsgAlert("Financeiro já gerado!, procedimento inválido.","")
	ElseIf At( "ISENT" , SA1->A1_INSCR ) != 0 .and. !SA1->(Eof())
		MsgAlert("Inscrição Estadual do cliente: " + Alltrim( SA1->A1_INSCR ) + ", não permite gerar financeiro.","")
	Else
		If (__nVlSt := U_semProto( SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA, SM0->M0_CODIGO , SF2->F2_FILIAL ) ) != 0

			dbSelectArea("SD2")
			dbSetorder(3)
			If dbSeek(xFilial("SD2")+ __cSf2Doc + __cSf2Serie + __cSf2Cli + __cSf2Loja)
				dbSelectArea("SC6")
				dbSetorder(1)
				If dbSeek(xFilial("SC6")+ SD2->D2_PEDIDO )
					__cUniNeg := SC6->C6_XITEMC
				EndIf
			EndIf


			If SF2->F2_EST = "RJ"
				__cParcel := "01"
			EndIf
			aVetor:= {	{"E1_PREFIXO" 	,__cPrefixo	,	Nil	},;
				{"E1_NUM"		,__cTitulo	,	Nil	},;
				{"E1_PARCELA"	,__cParcel	,	Nil	},;
				{"E1_TIPO"		,__cTipoDc	,	Nil	},;
				{"E1_NATUREZ"	,_cNaturFin	,	Nil	},;
				{"E1_CLIENTE"	,_cFCliente	,	Nil	},;
				{"E1_LOJA"		,_cFLojaCli	,	Nil	},;
				{"E1_EMISSAO"	,dDataBase	,	Nil	},;
				{"E1_VENCTO"	,__dVencto	,	Nil	},;
				{"E1_VENCREA"	,__dVencto	,	Nil	},;
				{"E1_HIST"		,_cHistFin	,	Nil	},;
				{"E1_VEND1"		,_cVende1	,	Nil	},;
				{"E1_COMIS1"	,0				,	Nil	},;
				{"E1_VALOR"		,__nVlSt		,	Nil	},;
				{"E1_ITEMC"		,__cUniNeg 	,	Nil	}}
			lMsErroAuto := .F.
			MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
			If lMsErroAuto
				MostraErro()
				MsgStop("Houve um problema ao incluir título a receber " + __cTitulo + ". A operação será interrompida.", "Atenção!!!")
			EndIf

			pVetor := {}
			AaDd(pVetor,{"E2_FILIAL"	,xFilial("SE2")	,Nil})
			AaDd(pVetor,{"E2_PREFIXO"	,"ST"					,Nil})
			AaDd(pVetor,{"E2_NUM"		,__cSf2Doc			,Nil})
			AaDd(pVetor,{"E2_PARCELA"	,"   "     			,Nil})
			AaDd(pVetor,{"E2_TIPO"   	,"ICM"				,Nil})
			AaDd(pVetor,{"E2_NATUREZ"	,_cNaturFin			,Nil})
			AaDd(pVetor,{"E2_FORNECE"	,"ESTADO"			,Nil})
			AaDd(pVetor,{"E2_LOJA"		,"00"					,Nil})
			AaDd(pVetor,{"E2_EMISSAO"	,ddatabase 			,Nil})
			AaDd(pVetor,{"E2_VENCTO" 	,__dVenceP1			,Nil})
			AaDd(pVetor,{"E2_VENCREA" 	,__dVenceP1			,Nil})
			AaDd(pVetor,{"E2_VALOR" 	,__nVlSt				,Nil})
			AaDd(pVetor,{"E2_ORIGEM" 	,"FINA050"			,Nil})
			AaDd(pVetor,{"E2_HIST"   	,"GNRE NF " + __cSf2Doc ,Nil})
			AaDd(pVetor,{"E2_ITEMC"   	,__cUniNeg 			,Nil})
			lMsErroAuto := .F.
			MSExecAuto({|x,y| Fina050(x,y)},pVetor,3)
			If lMsErroAuto
				MostraErro()
				MsgStop("Houve um problema ao incluir título a Pagar " + __cSf2Doc + ". A operação será interrompida.", "Atenção!!!")
			EndIf
			dbSelectArea("SD2")
			dbSetorder(3)
			dbSeek(xFilial("SD2")+ __cSf2Doc + __cSf2Serie + __cSf2Cli + __cSf2Loja)
			nVlComProtocolo	:= 0
			While xFilial("SD2")=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == __cSf2Doc + __cSf2Serie + __cSf2Cli + __cSf2Loja
				nVlComProtocolo	+= D2_ICMSRET
				dbSkip()
			End

			If nVlComProto != 0
				pVetor := {}
				AaDd(pVetor,{"E2_FILIAL"	,xFilial("SE2")	,Nil})
				AaDd(pVetor,{"E2_PREFIXO"	,"ST_"				,Nil})
				AaDd(pVetor,{"E2_NUM"		,__cSf2Doc			,Nil})
				AaDd(pVetor,{"E2_PARCELA"	,"   "     			,Nil})
				AaDd(pVetor,{"E2_TIPO"   	,"ICM"				,Nil})
				AaDd(pVetor,{"E2_NATUREZ"	,_cNaturFin			,Nil})
				AaDd(pVetor,{"E2_FORNECE"	,"ESTADO"			,Nil})
				AaDd(pVetor,{"E2_LOJA"		,"00"					,Nil})
				AaDd(pVetor,{"E2_EMISSAO"	,ddatabase 			,Nil})
				AaDd(pVetor,{"E2_VENCTO" 	,__dVenceP2			,Nil})
				AaDd(pVetor,{"E2_VENCREA" 	,__dVenceP2			,Nil})
				AaDd(pVetor,{"E2_VALOR" 	,nVlComProto		,Nil})
				AaDd(pVetor,{"E2_ORIGEM" 	,"FINA050"			,Nil})
				AaDd(pVetor,{"E2_HIST"   	,"GNRE NF " + __cSf2Doc ,Nil})
				AaDd(pVetor,{"E2_ITEMC"   	,__cUniNeg 			,Nil})
				lMsErroAuto := .F.
				MSExecAuto({|x,y| Fina050(x,y)},pVetor,3)
				If lMsErroAuto
					MostraErro()
					MsgStop("Houve um problema ao incluir título a Pagar " + __cSf2Doc + ". A operação será interrompida.", "Atenção!!!")
				EndIf
			EndIf

			U_GeraGNRE( .F. , __nVlSt, __dVenceP1 )

			If SF2->F2_EST = "RJ"

				_nVlDarj := __nVlBaseST * (nPerDarj/100)

				pVetor := {}
				AaDd(pVetor,{"E2_FILIAL"	,xFilial("SE2")	,Nil})
				AaDd(pVetor,{"E2_PREFIXO"	,"ST"					,Nil})
				AaDd(pVetor,{"E2_NUM"		,__cSf2Doc			,Nil})
				AaDd(pVetor,{"E2_PARCELA"	,"   "     			,Nil})
				AaDd(pVetor,{"E2_TIPO"   	,"DAR"				,Nil})
				AaDd(pVetor,{"E2_NATUREZ"	,_cNaturFin			,Nil})
				AaDd(pVetor,{"E2_FORNECE"	,"ESTADO"			,Nil})
				AaDd(pVetor,{"E2_LOJA"		,"00"					,Nil})
				AaDd(pVetor,{"E2_EMISSAO"	,ddatabase 			,Nil})
				AaDd(pVetor,{"E2_VENCTO" 	,__dVenceP3			,Nil})
				AaDd(pVetor,{"E2_VENCREA" 	,__dVenceP3			,Nil})
				AaDd(pVetor,{"E2_VALOR" 	,_nVlDarj			,Nil})
				AaDd(pVetor,{"E2_ORIGEM" 	,"FINA050"			,Nil})
				AaDd(pVetor,{"E2_HIST"   	,"DARJ NF " + __cSf2Doc ,Nil})
				AaDd(pVetor,{"E2_ITEMC"   	,__cUniNeg 			,Nil})
				lMsErroAuto := .F.
				MSExecAuto({|x,y| Fina050(x,y)},pVetor,3)
				If lMsErroAuto
					MostraErro()
					MsgStop("Houve um problema ao incluir título a Pagar " + __cSf2Doc + ". A operação será interrompida.", "Atenção!!!")
				EndIf

				__cParcel	:= "02"
				aVetor:= {	{"E1_PREFIXO" 	,__cPrefixo	,	Nil	},;
					{"E1_NUM"		,__cTitulo	,	Nil	},;
					{"E1_PARCELA"	,__cParcel	,	Nil	},;
					{"E1_TIPO"		,__cTipoDc	,	Nil	},;
					{"E1_NATUREZ"	,_cNaturFin	,	Nil	},;
					{"E1_CLIENTE"	,_cFCliente	,	Nil	},;
					{"E1_LOJA"		,_cFLojaCli	,	Nil	},;
					{"E1_EMISSAO"	,dDataBase	,	Nil	},;
					{"E1_VENCTO"	,__dVenceR3	,	Nil	},;
					{"E1_VENCREA"	,__dVenceR3	,	Nil	},;
					{"E1_HIST"		,"DARJ NF " +	__cSf2Doc ,	Nil	},;
					{"E1_VEND1"		,_cVende1	,	Nil	},;
					{"E1_COMIS1"	,0				,	Nil	},;
					{"E1_VALOR"		,_nVlDarj	,	Nil	},;
					{"E1_ITEMC"		,__cUniNeg 	,	Nil	}}
				lMsErroAuto := .F.
				MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
				If lMsErroAuto
					MostraErro()
					MsgStop("Houve um problema ao incluir título a receber " + __cTitulo + ". A operação será interrompida.", "Atenção!!!")
				EndIf
			EndIf

		EndIf
	EndIf
	DbSelectArea("SF2")

	RestArea(_xSa1Alias)
	RestArea(_xSf2Alias)
Return


//--------------------------------------------------------------------------------------------------------------
// Calculo do valor a gerar no financeiro sem PROTOCOLO
//--------------------------------------------------------------------------------------------------------------
User Function semProto( _cSf2Doc, _cSf2Serie, _cSf2Cli, _cSf2Loja, __cEmpresa, __cFilial )
	Local nValor := 0
	Local nVlComProtocolo := 0
	Local cAliqInterna:= GetNewPar("MV_ESTICM","")
	Local _xSd2Alias	:= SD2->(GetArea())

	Local omDlg
	Local omGetDB
	Local aLinha	:= 0
	Local aTam		:= {}
	Local cLinOk		:= "AllwaysTrue"
	Local cTudoOk		:= "AllwaysTrue"
	Local cIniCpos		:= ""
	Local nFreeze		:= 000
	Local nMax			:= 999
	Local cSuperDel	:= ""
	Local cDelOk		:= "AllwaysFalse"
	Local aHeader1		:= {}
	Local aCols1		:= {}
	Local aButtons		:= {}
	Local clOk			:= ""
	Local nX			:= 0

	Local nPerDarj		:= GetNewPar("MV_TFVDARJ",1)
	Local cMV_ESTADO	:= GetMv('MV_ESTADO')

	Private lRefresh	:= .T.

	aResult[1] := {}
	aResult[2] := {}

	If TCSPExist("SP_CALC_DIF_ST")

		aResult1 := TCSPEXEC("SP_CALC_BC_ST", _cSf2Doc, _cSf2Serie, _cSf2Cli, _cSf2Loja, cAliqInterna, __cEmpresa, __cFilial, cMV_ESTADO, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
		IF !Empty(aResult1)
			If Select("TSQLBC") > 0
				dbSelectArea("TSQLBC")
				DbCloseArea()
			EndIf
			TCQuery "SELECT * FROM " + aResult1[1] NEW ALIAS "TSQLBC"
			__nVlBaseST := TSQLBC->BC_ST
			DbCloseArea()
		Else
			Final('Erro na execucao da Stored Procedure SP_CALC_BC_ST: '+TcSqlError())
		EndIf

		aResult2 := TCSPEXEC("SP_CALC_DIF_ST", _cSf2Doc, _cSf2Serie, _cSf2Cli, _cSf2Loja, cAliqInterna, __cEmpresa, __cFilial, cMV_ESTADO, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
		IF !Empty(aResult2)
			If Select("TSQL") > 0
				dbSelectArea("TSQL")
				DbCloseArea()
			EndIf
			TCQuery "SELECT * FROM " + aResult2[1] NEW ALIAS "TSQL"
			nValor := TSQL->DIF_ST
			DbCloseArea()
		Else
			Final('Erro na execucao da Stored Procedure SP_CALC_DIF_ST: '+TcSqlError())
		EndIf

		DbSelectArea("SF2")

	EndIf

	dbSelectArea("SD2")
	dbSetorder(3)
	dbSeek(xFilial("SD2")+ _cSf2Doc + _cSf2Serie + _cSf2Cli + _cSf2Loja)
	nVlComProtocolo	:= 0
	While xFilial("SD2")=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA == _cSf2Doc + _cSf2Serie + _cSf2Cli + _cSf2Loja
		nVlComProtocolo	+= D2_ICMSRET
		dbSkip()
	End

	DbSelectArea("SF2")

	aTam := TamSX3('E1_NOMCLI'	); Aadd(aHeader1, {'Descrição'		, 'E1_NOMCLI'	, "@R!"												,	20		 , 0		 , ''	, USADO, 'C', 'SE1', ''}) //
	aTam := TamSX3('E1_NOMCLI' ); Aadd(aHeader1, {'Cliente'			, 'E1_NOMCLI'	, "@R!"												,	20		 , 0		 , ''	, USADO, 'C', 'SE1', ''}) //
	aTam := TamSX3('E1_NUM' 	); Aadd(aHeader1, {'Documento'		, 'E1_NUM'		, PesqPict('SE1', 'E1_NUM'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', 'SE1', ''}) //
	aTam := TamSX3('E1_VALOR'  ); Aadd(aHeader1, {'Dif. ST'			, 'E1_VALOR'	, PesqPict('SE1', 'E1_VALOR'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', 'SE1', ''}) //
	aTam := TamSX3('E1_VENCTO' ); Aadd(aHeader1, {'Vencto.Pagar'	, 'E1_VENCTO'	, PesqPict('SE1', 'E1_VENCTO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'D', 'SE1', ''}) //
	aTam := TamSX3('E1_VENCREA'); Aadd(aHeader1, {'Vencto.Receb'	, 'E1_VENCREA'	, PesqPict('SE1', 'E1_VENCREA', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'D', 'SE1', ''}) //

	aAdd(aCols1, Array(Len(aHeader1)+1))
	For nX := 1 To Len(aHeader1)
		cCampo:=Alltrim(aHeader1[nX,2])
		If IsHeadRec(aHeader1[nX][2])
			aCols1[1][nX] := 0
		ElseIf IsHeadAlias(aHeader1[nX][2])
			aCols1[1][nX] := cAlias
		ElseIf aHeader1[nX,8] == 'C'
			aCols1[1,nX] := Space(aHeader1[nX,4])
		ElseIf aHeader1[nX,8] == 'N'
			aCols1[1,nX] := 0
		Else
			aCols1[1,nX] := .F.
		EndIf
	Next nX
	aCols1[1,Len(aHeader1)+1] := .F.

	aLinha 	:= aClone(aCols1[1])

	SA1->(DbSeek( xFilial("SA1") + _cSf2Cli+ _cSf2Loja ))

	aTail(aCols1)[1]  := "A receber e a pagar SEM protocolo"
	aTail(aCols1)[2]  := Substr(SA1->A1_NOME,1,30)
	aTail(aCols1)[3]  := _cSf2Doc
	aTail(aCols1)[4]  := nValor
	aTail(aCols1)[5]  := ddatabase + 1
	aTail(aCols1)[6]  := ddatabase + 1
	aAdd(aCols1, aClone(aLinha))
	__dVenceP1 := ddatabase + 1

	If	nVlComProtocolo != 0
		aTail(aCols1)[1]  := "A pagar COM protocolo"
		aTail(aCols1)[2]  := Substr(SA1->A1_NOME,1,30)
		aTail(aCols1)[3]  := _cSf2Doc
		aTail(aCols1)[4]  := nVlComProtocolo
		aTail(aCols1)[5]  := ddatabase
		aTail(aCols1)[6]  := ctod("  /  /  ")
		aAdd(aCols1, aClone(aLinha))
		__dVenceP2 := ddatabase
	EndIf

	If SF2->F2_EST = "RJ"
		aTail(aCols1)[1]  := "A pagar e a receber DARJ"
		aTail(aCols1)[2]  := Substr(SA1->A1_NOME,1,30)
		aTail(aCols1)[3]  := _cSf2Doc
		aTail(aCols1)[4]  := __nVlBaseST * (nPerDarj/100)
		aTail(aCols1)[5]  := ddatabase
		aTail(aCols1)[6]  := ddatabase + 15
		aAdd(aCols1, aClone(aLinha))
		__dVenceP3 := ddatabase
		__dVenceR3 := ddatabase + 15
	EndIf

	omDlg 	:= MSDIALOG():New(000,000,500,820, "Valor DIF. do ST",,,,,,,,,.T.)

//							cLinOk,cTudoOk,cIniCpos,{},nFreeze,nMax,cFieldOk, cSuperDel,;

	omGetDB:= MsNewGetDados():New( 15,05,248,410,	2,;
		cLinOk,cTudoOk,cIniCpos,{"E1_VENCTO"},nFreeze,nMax,"U_TFvencto", cSuperDel,;
		cDelOk, omDlg, aHeader1, aCols1)
	omDlg:bInit := {|| EnchoiceBar(omDlg, {|| clOk:="N", omDlg:End() },{|| clOk:="S", omDlg:End() },,aButtons)}
	omDlg:lCentered := .T.
	omDlg:Activate()

	RestArea(_xSd2Alias)
	If clOk="S"
		nValor:=0
	EndIf

	If Len(aResult1) > 0
		If TcCanOpen(aResult1[1])
			TcSqlExec("DROP TABLE "+aResult1[1])
		EndIf
	EndIf

	If Len(aResult2) > 0
		If TcCanOpen(aResult2[1])
			TcSqlExec("DROP TABLE "+aResult2[1])
		EndIf
	EndIf

Return (nValor)

//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: TFvencto   		                             AUTOR: CARLOS ALDAY TORRES           DATA: 03/06/2011   |
//+--------------------------------------------------------------------------------------------------------------
User Function TFvencto()
	Local lReturn := .T.
	If Empty( M->E1_VENCTO ) .or. M->E1_VENCTO<ddatabase
		lReturn := .F.
		MsgAlert("Data inválida!","")
	Else
		If N = 1
			__dVenceP1 := M->E1_VENCTO
		ElseIf N = 2 .and. !Empty( __dVenceP2 )
			__dVenceP2 := M->E1_VENCTO
		ElseIf N = 2 .and. Empty( __dVenceP2 ) .and. !Empty( __dVenceP3 )
			__dVenceP3 := M->E1_VENCTO
		ElseIf N = 3
			__dVenceP3 := M->E1_VENCTO
		EndIf
	EndIf
Return (lReturn)

//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: GeraGNRE   		                             AUTOR: CARLOS ALDAY TORRES           DATA: 22/08/2011   |
//+--------------------------------------------------------------------------------------------------------------
User Function GeraGNRE( lMensagemOk, nVlSt, dDtVencto  )
	Local __cPastaGnre:= GetNewPar("MV_TFGNREP","")
	Local __cNmArquivo:= ""
	Local __cGNREtexto:= ""
	Local __cPthEmpGnr
	Local __cMesRef
	Local __cAnoRef
	Local __cEndCob
	Local __nCriaDir
	Local __lLogAcesso

	__cPthEmpGnr := Alltrim(__cPastaGnre) + Upper( Alltrim(SM0->M0_NOME) )

	If !Empty( __cPastaGnre )
		//
		// Link do portal da GNRE
		//http://www.gnre.pe.gov.br/gnre/portal/GNRE_Arquivo_incorporacao.jsp
		//

		If lMensagemOk
			SE2->(DbSetOrder(1))
			If SE2->(DbSeek( xFilial("SE2") + "ST " + SF2->F2_DOC + Space(Len(SE2->E2_PARCELA)) + "ICM" + "ESTADO" + "00" ))
				nVlSt		:=	SE2->E2_VALOR
				dDtVencto:= SE2->E2_VENCTO
			EndIf
		EndIf
		If nVlSt != 0
			SA1->(DbSetOrder(1))
			SA1->(DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))

			If At( "ISENT" , SA1->A1_INSCR ) = 0 .and. !SA1->(Eof())
				cTxtInfo := "NFe: " + SF2->F2_DOC + Space(01)
				cTxtInfo += Alltrim(SM0->M0_NOMECOM) + Space(01)
				cTxtInfo += "CNPJ: " + SM0->M0_CGC + Space(01)
				cTxtInfo += "IE: " + SM0->M0_INSC

				__cMesRef	:= STRZERO( Month(SF2->F2_EMISSAO) ,2)
				__cAnoRef   := STRZERO( Year(SF2->F2_EMISSAO) ,4)

				__cEndCob	:= Alltrim( SA1->A1_LOGR ) + Space(01)
				__cEndCob	+= Alltrim( SA1->A1_END ) + ", "
				__cEndCob	+= SA1->A1_NUME

				__cGNREtexto := SF2->F2_EST 																							// UF Favorecida
				__cGNREtexto += GNRE_TAB	+	'100099'																				// Codigo da Receita
				__cGNREtexto += GNRE_TAB	+	SA1->A1_CGC																			// CNPJ ou CPF
				__cGNREtexto += GNRE_TAB	+	SF2->F2_DOC																			// Documento de Origem
				__cGNREtexto += GNRE_TAB	+	"1" + __cMesRef + __cAnoRef 													// Referencia
				__cGNREtexto += GNRE_TAB	+	StrTran(STR(nVlSt,14,2),".",",") 											// Valor Principal
				__cGNREtexto += GNRE_TAB	+	StrTran(STR(0,14,2),".",",") 													// Atualizacao monetaria
				__cGNREtexto += GNRE_TAB	+	StrTran(STR(0,14,2),".",",") 													// Juros
				__cGNREtexto += GNRE_TAB	+	StrTran(STR(0,14,2),".",",") 													// Multa
				__cGNREtexto += GNRE_TAB	+	StrTran(STR(nVlSt,14,2),".",",") 											// Total a Receber
				__cGNREtexto += GNRE_TAB	+	SUBSTR(DTOS(dDtVencto),7,2)+"/"+SUBSTR(DTOS(dDtVencto),5,2)+"/"+SUBSTR(DTOS(dDtVencto),1,4) // Data vencimento
				__cGNREtexto += GNRE_TAB	+	""																						// Convenio
				__cGNREtexto += GNRE_TAB	+	SA1->A1_NOME																		// Razao Social
				__cGNREtexto += GNRE_TAB	+	SA1->A1_INSCR																		// Inscricao Estadual
				__cGNREtexto += GNRE_TAB	+	__cEndCob																			// Endereco
				__cGNREtexto += GNRE_TAB	+	SA1->A1_MUN																			// Municipio
				__cGNREtexto += GNRE_TAB	+	SA1->A1_EST																			// UF
				__cGNREtexto += GNRE_TAB	+	SUBSTR(SA1->A1_CEP,1,5)+"-"+SUBSTR(SA1->A1_CEP,6,3)					// CEP
				__cGNREtexto += GNRE_TAB	+	SA1->A1_DDD+SA1->A1_TEL															// Telefone
				__cGNREtexto += GNRE_TAB	+	cTxtInfo																				// Inform
				__cGNREtexto += GNRE_TAB	+	Iif( SA1->A1_EST $ 'PE|AL' ,'99','00') 									// Convenio

				__lLogAcesso := .T.
				If !EXISTDIR( __cPthEmpGnr )
					__nCriaDir := MAKEDIR( __cPthEmpGnr )
					If __nCriaDir != 0
						Msgalert("Não foi possivel criar pasta "+__cPthEmpGnr+" de deposito do arquivo GNRE!")
						__lLogAcesso := .F.
					EndIf
				EndIf

				If __lLogAcesso
					__cNmArquivo:= __cPthEmpGnr + "\" + "NFE_" + Alltrim(xFilial("SF2")) + "_" + Alltrim(SF2->F2_DOC) + "_" + Alltrim(SF2->F2_SERIE) + ".TXT"
					_nArquivo 	:= fcreate( __cNmArquivo , FC_NORMAL)

					If ferror() # 0
						msgalert ("ERRO AO CRIAR O ARQUIVO, ERRO: " + str(ferror()))
					Else
						fwrite( _nArquivo  ,   __cGNREtexto + GNRE_CRLF)
						If ferror() # 0
							msgalert ("ERRO GRAVANDO ARQUIVO, ERRO: " + str(ferror()))
						Else
							If lMensagemOk
								msgalert ("Arquivo gerado...")
							EndIf
						EndIf
					EndIf
					fclose( _nArquivo )

				EndIf
			EndIf
		Else
			If lMensagemOk
				msgalert ("Arquivo não gerado, falta de referencia de vencimento e valor de ST!")
			EndIf
		EndIf

	EndIf

Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: TFSX6NAT   		                             AUTOR: CARLOS ALDAY TORRES           DATA: 04/04/2014   |
//+--------------------------------------------------------------------------------------------------------------
User Function TFSX6NAT()
	dbSelectArea("SX6")

	SX6->(dbSetOrder(1))

	if !SX6->(dbSeek(xFilial("SX6") + "TF_GNRENAT"))
		RecLock("SX6", .T.)
		SX6->X6_FIL		:= xFilial("SX6")
		SX6->X6_VAR		:= "TF_GNRENAT"
		SX6->X6_TIPO		:= "C"
		SX6->X6_DESCRIC	:= "Informa a natureza financeira utilizada na geracao"
		SX6->X6_DESC1		:= "da GNRE, principal rotina que utiliza FATRTRI2."
		SX6->X6_DESC2		:= ""
		SX6->X6_CONTEUD	:= "2351"
		SX6->X6_PROPRI	:= "S"
		SX6->X6_PYME		:= "S"
		MsUnLock()
	EndIf
Return NIL
