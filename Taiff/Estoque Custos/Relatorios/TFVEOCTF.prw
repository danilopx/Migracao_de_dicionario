#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*
+--------------------------------------------------------------------------------------------------------------
|FUNCAO: TFVEOCTF                                     AUTOR: CARLOS ALDAY TORRES               DATA: 08/04/2015   
+--------------------------------------------------------------------------------------------------------------
|DESCRICAO: Rotina do Projeto AVANTE para apresentar as ordens de carga e imprimir relatorio da TAIFF
+--------------------------------------------------------------------------------------------------------------
| Relatório reconstruido por causa da remodelagem do projeto CROS DOCKING 						DATA: 29/10/2015
+--------------------------------------------------------------------------------------------------------------
*/
User Function TFVEOCTF()
	Local xZC5Alias	:= ""
	Local cAlias  := "SF2"
	Local aCores  := {}
	Local cFiltra := "F2_FILIAL == '"+xFilial('SF2')+"' .AND. .NOT. Empty(F2_NUMRM)"

	Private cCadastro		:= "Nota Fiscal de transferencia CD"
	Private aRotina  		:= {}
	Private aIndexZC5		:= {}
	Private bFiltraBrw	:= { || FilBrowse(cAlias,@aIndexZC5,@cFiltra) }
	Private _cEmpMestre	:= ""
	Private _cFilMestre	:= ""
	Private cPerg     	:= 'TFVEOCTF'
	Private cLaPerg 		:= "TFVEDOCNF "
	Private __cNumOC		:= ""
	Private _nMarcaNfe

	CriaSx1Perg( cLaPerg )

	AjustaSx1( cPerg ) // Chama funcao de pergunta

	If pergunte(cPerg,.T.)

		xZC5Alias	:= SF2->(GetArea())

		cFiltra += Iif( mv_par01=1, " .AND. F2_SERIE $ '1  |5  ' " , " .AND. F2_SERIE $ '2  |6  ' " )

		_nMarcaNfe := mv_par01

		AADD(aCores,{"F2_FIMP = 'S'"	,"BR_VERDE"	})
		AADD(aCores,{"F2_FIMP != 'S'"	,"BR_VERMELHO"	})



		AADD(aRotina,{"Pesquisar"		,"PesqBrw"				,0,1})
		AADD(aRotina,{"Imprime NFe"		,"U_TFPERG_OC( SF2->F2_DOC )"	,0,6})
		AADD(aRotina,{"Legenda"			,"U_OTFLegenda"		,0,6})

		dbSelectArea(cAlias)
		dbSetOrder(1)
		Eval(bFiltraBrw)

		MBROWse(6,1,22,75,cAlias,,,,,,aCores,,,,,.F.)

	EndFilBrw(cAlias,aIndexZC5)

EndIf

RestArea(xZC5Alias)

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Função: Legenda
--------------------------------------------------------------------------------------------------------------
*/
User Function OTFLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		, 	"DANFE impressa"	})
	AADD(aLegenda,{"BR_VERMELHO"	,	"Danfe não gerada"	})


	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Impressão da OS selecionada da ZC5
--------------------------------------------------------------------------------------------------------------
*/
User Function TFPERG_OC(__cNumOC)
	Private oReport

	SX1->(DbSetOrder(1))
	If SX1->(DbSeek( cLaPerg + "01" ))
		SX1->(reclock("SX1",.F.))
		SX1->X1_CNT01 := SF2->F2_DOC
		SX1->(MsUnlock())
	Else
		Conout( 'Não achou a pergunta sx1 ' + cLaPerg )
	EndIf
	oReport := DReportDef( SF2->F2_DOC )
	oReport:PrintDialog()

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a marca
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)

	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	Aadd( aHelpPor, "Informe a marca: TAIFF ou PROART" )
	Aadd( aHelpEng, "Informe a marca: TAIFF ou PROART" )
	Aadd( aHelpSpa, "Informe a marca: TAIFF ou PROART" )

	PutSx1(cPerg,"01"   ,"Marca ?","",""	,"mv_ch1","N",01,0,0,"C","","","","",;
		"mv_par01", "TAIFF","","","",;
		"PROART","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	RestArea(aAreaAnt)

Return()

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal
--------------------------------------------------------------------------------------------------------------
*/
Static Function CriaSx1Perg(cPerg)

	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	Aadd( aHelpPor, "Informe a marca nota fiscal" )
	Aadd( aHelpEng, "Informe a marca nota fiscal" )
	Aadd( aHelpSpa, "Informe a marca nota fiscal" )

	PutSx1(cPerg,"01"   ,"Nota fiscal a emitir ?","",""	,"mv_ch1","C",09,0,0,"C","","","","",;
		"mv_par01", "","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	RestArea(aAreaAnt)

Return()

/*
--------------------------------------------------------------------------------------------------------------
Função Static de preparação dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef( __cNumOC )
	Local oReport
	Local cAliasQry := "TSQL"
	Local oOSTransf_1
	Local oOSTransf_2

	oReport := TReport():New("TFVEOCTF","Nota Fiscal de Transferencia CD","TFVEDOCNF", {|oReport| DReportPrint(oReport,cAliasQry)},"")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
//oReport:nFontBody := 9

	oReport:cFontBody := 'Arial Narrow'
	oReport:nFontBody := 10
	oReport:SetColSpace(1,.T.)
	oReport:SetLineHeight(50)

	Pergunte(oReport:uParam,.F.)

	oOSTransf_1 := TRSection():New(oReport,"Nota Fiscal de Transferencia",{"SF2"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)

	TRCell():New(oOSTransf_1,"D2_DOC"		,"SD2"	,"No. Documento"	,PesqPict("SD2","D2_DOC")	,20							,/*lPixel*/,{|| (cAliasQry)->D2_DOC		})
	TRCell():New(oOSTransf_1,"FILNOM"		,"SD2"	,"Destino"			,PesqPict("SD2","D2_DESCR")	,TamSx3("D2_DESCR")[1]	,/*lPixel*/,{|| (cAliasQry)->FILNOM		})
	TRCell():New(oOSTransf_1,"TRANSPORTE"	,"ZC5"	,"Transportadora"	,"@!"							,100						,/*lPixel*/,{|| (cAliasQry)->TRANSPORTE	})
	TRCell():New(oOSTransf_1,"C5_XITEMC"	,"SC5"	,"Marca"			,PesqPict("SC5","C5_XITEMC"),TamSx3("C5_XITEMC")[1]	,/*lPixel*/,{|| (cAliasQry)->C5_XITEMC		})

	oOSTransf_2 := TRSection():New(oReport,"Itens da Ordem de Carga",{"ZC5"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)

	TRCell():New(oOSTransf_2,"D2_PEDIDO"		,"SD2"	,"Pedido"			,PesqPict("SD2","D2_PEDIDO")	,TamSx3("D2_PEDIDO")[1]	,/*lPixel*/,{|| (cAliasQry)->D2_PEDIDO	})
	TRCell():New(oOSTransf_2,"C5_NUMOLD"		,"SC5"	,"Pedido Portal"	,PesqPict("SC5","C5_NUMOLD")	,TamSx3("C5_NUMOLD")[1]	,/*lPixel*/,{|| (cAliasQry)->C5_NUMOLD	})
	TRCell():New(oOSTransf_2,"VOLUME_PEDIDO"	,"SC5"	,"Volume"			,PesqPict("SC5","C5_VOLUME1")	,TamSx3("C5_VOLUME1")[1]	,/*lPixel*/,{|| (cAliasQry)->VOLUME_PEDIDO},"RIGHT",,"RIGHT")

//TRFunction():New(oOSTransf_2:Cell("VOLUME_TOTAL")	,NIL,"ONPRINT"	,/*oBreak*/,"",PesqPict("ZC5","ZC5_QTDLIB"),{|| oOSTransf_2:Cell("VOLUME_TOTAL"):GetValue(.T.) },.T.,.F.)

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Função Static de execução do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)
	Local __QuebraOC
	Local _cUpdateSF2
	Local _cUpdateCB7

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)


	MakeSqlExpr(oReport:uParam)


	If TCSPExist("SP_REL_ORDEM_DE_CARGA_TAIFF")


		_cUpdateSF2 := "UPDATE SF2 SET" + ENTER
		_cUpdateSF2 += "	F2_DTEMB='" + DTOS(dDatabase) + "' " + ENTER
		_cUpdateSF2 += "FROM " + RetSQLName("SF2") + " SF2 WITH(NOLOCK) " + ENTER
		_cUpdateSF2 += "WHERE F2_DOC		='" + SF2->F2_DOC + "' " + ENTER
		_cUpdateSF2 += "	AND F2_SERIE	='" + SF2->F2_SERIE + "' " + ENTER
		_cUpdateSF2 += "	AND F2_FILIAL	='" + xFilial("SF2") + "' " + ENTER
		_cUpdateSF2 += "	AND F2_EST		='SP' " + ENTER
		_cUpdateSF2 += "	AND F2_NUMRM	='CROSS' " + ENTER
		_cUpdateSF2 += "	AND F2_DTEMB	='' " + ENTER
		_cUpdateSF2 += "	AND RTRIM(LTRIM(F2_SERIE)) IN ('1','5') " + ENTER
		_cUpdateSF2 += "	AND SF2.D_E_L_E_T_='' " + ENTER

		MemoWrite( "TFVEOCTF_upd_SF2_DTEMB.sql" , _cUpdateSF2 )

		If TCSQLExec( _cUpdateSF2 ) < 0
			conout("Falha no UPDATE SF2 da Data de Embarque pela TFVEOCTF")
		Endif


		_cUpdateCB7 := "UPDATE CB7 SET" + ENTER
		_cUpdateCB7 += "	CB7_DTEMBA='" + DTOS(dDatabase) + "' " + ENTER
		_cUpdateCB7 += "FROM " + RetSQLName("SF2") + " SF2 WITH(NOLOCK) " + ENTER
		_cUpdateCB7 += "INNER JOIN " + RetSQLName("SD2") + " SD2 WITH(NOLOCK) " + ENTER
		_cUpdateCB7 += "	ON D2_DOC=F2_DOC " + ENTER
		_cUpdateCB7 += "	AND D2_SERIE=F2_SERIE " + ENTER
		_cUpdateCB7 += "	AND D2_CLIENTE=F2_CLIENTE " + ENTER
		_cUpdateCB7 += "	AND D2_LOJA=F2_LOJA " + ENTER
		_cUpdateCB7 += "	AND D2_FILIAL='" + xFilial("SD2") + "' " + ENTER
		_cUpdateCB7 += "	AND SD2.D_E_L_E_T_='' " + ENTER
		_cUpdateCB7 += "	AND D2_ITEMCC='TAIFF' " + ENTER
		_cUpdateCB7 += "INNER JOIN " + RetSQLName("CB7") + " CB7 WITH(NOLOCK) " + ENTER
		_cUpdateCB7 += "	ON CB7.D_E_L_E_T_='' " + ENTER
		_cUpdateCB7 += "	AND CB7_FILIAL='" + xFilial("CB7") + "' " + ENTER
		_cUpdateCB7 += "	AND CB7_PEDIDO=D2_PEDIDO " + ENTER
		_cUpdateCB7 += "	AND CB7_CLIENT=D2_CLIENTE " + ENTER
		_cUpdateCB7 += "	AND CB7_LOJA=D2_LOJA " + ENTER
		_cUpdateCB7 += "	AND CB7_STATUS='9' " + ENTER
		_cUpdateCB7 += "	AND LEFT(CB7_DTFIMS,6) = LEFT(F2_EMISSAO,6) " + ENTER
		_cUpdateCB7 += "	AND CB7_DTEMBA	='' " + ENTER
		_cUpdateCB7 += "WHERE F2_DOC		='" + SF2->F2_DOC + "' " + ENTER
		_cUpdateCB7 += "	AND F2_SERIE	='" + SF2->F2_SERIE + "' " + ENTER
		_cUpdateCB7 += "	AND F2_FILIAL	='" + xFilial("SF2") + "' " + ENTER
		_cUpdateCB7 += "	AND F2_EST		='SP' " + ENTER
		_cUpdateCB7 += "	AND F2_NUMRM	='CROSS' " + ENTER
		_cUpdateCB7 += "	AND SF2.D_E_L_E_T_='' " + ENTER

		MemoWrite( "TFVEOCTF_upd_CB7_DTEMB.sql" , _cUpdateCB7 )

		If TCSQLExec( _cUpdateCB7 ) < 0
			conout("Falha no UPDATE CB7 da Data de Embarque pela TFVEOCTF")
		Endif

		_cQuery := "EXEC SP_REL_ORDEM_DE_CARGA_TAIFF '"+SF2->F2_DOC+"' , '" + Alltrim(Str(_nMarcaNfe)) + "' , '"+xFilial("SF2")+"' "

		If Select(cAliasQry) > 0
			dbSelectArea(cAliasQry)
			DbCloseArea()
		EndIf

		TCQUERY _cQuery NEW ALIAS "TSQL"

	EndIf

	oReport:Section(1):BeginQuery()
	dbSelectArea("TSQL")
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		__QuebraOC := (cAliasQry)->D2_DOC
		_nTotalVolumes := 0
		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(2):Init()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->D2_DOC = __QuebraOC

			oReport:Section(2):PrintLine()
			_nTotalVolumes += (cAliasQry)->VOLUME_PEDIDO

			dbSkip()
			oReport:IncMeter()
		End
		//oReport:Section(2):Cell("VOLUME_TOTAL"):SetValue(_nTotalVolumes)
		oReport:Section(2):Finish()
		oReport:Section(1):Finish()
		oReport:SkipLine(1)
		oReport:ThinLine()
		oReport:PrintText(Space(TamSx3("C5_NUMOLD")[1]+TamSx3("D2_PEDIDO")[1]) + "TOTAL DE VOLUMES: " + Alltrim(Str(_nTotalVolumes)) )
		oReport:SkipLine(1)
		oReport:SkipLine(1)
		oReport:PrintText("Conferente: ________________________________________         Data: __________/__________/__________")
		oReport:SkipLine(1)
		oReport:SkipLine(1)
		oReport:SkipLine(1)
		oReport:PrintText("Transportador: ___________________________________________________________________________________")
		oReport:SkipLine(1)
		oReport:SkipLine(1)
		oReport:SkipLine(1)
		oReport:PrintText("ROMANEIO: _____________________________________")
		oReport:SkipLine(1)

		oReport:ThinLine()
		oReport:Section(1):SetPageBreak(.T.)
	End

Return