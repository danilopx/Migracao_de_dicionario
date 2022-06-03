#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*
+--------------------------------------------------------------------------------------------------------------
|FUNCAO: TFVIEWOC                                     AUTOR: CARLOS ALDAY TORRES               DATA: 26/07/2013   
+--------------------------------------------------------------------------------------------------------------
|DESCRICAO: Rotina do Projeto AVANTE para apresentar as ordens de carga e imprimir relatorio
+--------------------------------------------------------------------------------------------------------------
*/
User Function TFVIEWOC()
	Local xZc1Alias	:= ""
	Local cAlias  := "ZC1"
	Local aCores  := {}
	Local cFiltra := "ZC1_FILIAL == '"+xFilial('ZC1')+"' .AND. !Empty(ZC1_NUMOC)"
	Local aFaixa  := {{"Ordem Carga","ZC1_NUMOC"},{"Data Ord. Carga","ZC1_DATAOC"},{"Produto","ZC1_CODPRO"}}

	Private cCadastro	:= "Ordem de Carga"
	Private aRotina  	:= {}
	Private aIndexZC1	:= {}
	Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexZC1,@cFiltra) }
	Private _cEmpMestre	 := ""
	Private _cFilMestre	 := ""

	xZc1Alias	:= ZC1->(GetArea())

	AADD(aCores,{"U_TFcorped(ZC1->ZC1_PEDIDO)='S'"	,"BR_AZUL"	})
	AADD(aCores,{"U_TFcorped(ZC1->ZC1_PEDIDO)='C'"	,"BR_PINK"	})
	AADD(aCores,{"U_TFcorped(ZC1->ZC1_PEDIDO)$' |N'"	,"BR_AMARELO"})


	AADD(aRotina,{"Pesquisar"		,"PesqBrw"				,0,1})
	AADD(aRotina,{"Imprime OC"		,"U_TFIMPR_OC(.T.)"	,0,6})
	AADD(aRotina,{"Consulta"      ,"U_TF_callPRT"		,0,6})
	AADD(aRotina,{"Legenda"			,"U_ZC1Legenda"		,0,6})

	dbSelectArea(cAlias)
	dbSetOrder(1)
	Eval(bFiltraBrw)

	MBROWse(6,1,22,75,cAlias,aFaixa,,,,,aCores,,,,,.F.)

EndFilBrw(cAlias,aIndexZC1)

RestArea(xZc1Alias)

Return NIL


/*
--------------------------------------------------------------------------------------------------------------
Consulta Pedido da OS selecionada da ZC1
--------------------------------------------------------------------------------------------------------------
*/
User Function TF_callPRT()
	dbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+ZC1->ZC1_PEDIDO))
		U_PRTC003A()
	EndIf
	dbSelectArea("ZC1")
Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Impressão da OS selecionada da ZC1
--------------------------------------------------------------------------------------------------------------
*/
User Function TFIMPR_OC(__lPergunta,__cNumOC)
	Private cPerg     	:= 'ZC1IMPOC'
	Private cString   	:= 'Query'
	Private oReport

	If !__lPergunta
		SX1->(DbSetOrder(1))
		If SX1->(DbSeek( cPerg + "01" ))
			SX1->(reclock("SX1",.F.))
			SX1->X1_CNT01 := __cNumOC
			SX1->(MsUnlock())
		EndIf
		oReport := DReportDef( __cNumOC )
		oReport:PrintDialog()
	Else
		AjustaSx1( cPerg ) // Chama funcao de pergunta

		If pergunte(cPerg,.T.)
			oReport := DReportDef()
			oReport:PrintDialog()
		EndIf
	EndIf
Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a OC
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)

	Local aAreaAnt := GetArea()
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

//---------------------------------------MV_PAR01-------------------------------------------------- OK
	aHelpPor := {'Informe o numero da OC a imprimir'}
	aHelpEng := {''}
	aHelpSpa := {''}

	PutSx1(cPerg,"01","Numero da OC? ","","","mv_ch1","C",10,0,0,"G","","",,,"MV_PAR01")

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

	oReport := TReport():New("TFVIEWOC","Ordem de Carga","ZC1IMPOC", {|oReport| DReportPrint(oReport,cAliasQry)},"")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:nFontBody := 9

	Pergunte(oReport:uParam,.F.)

	If !Empty(__cNumOC)
		MV_PAR01 := __cNumOC
	EndIf

	oOSTransf_1 := TRSection():New(oReport,"Ordem de Carga",{"ZC1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)

	TRCell():New(oOSTransf_1,"ZC1_NUMOC"	,"ZC1"	,"No. OC"			,PesqPict("ZC1","ZC1_NUMOC")	,20								,/*lPixel*/,{|| (cAliasQry)->ZC1_NUMOC		})
	TRCell():New(oOSTransf_1,"ZC1_FILNOM"	,"ZC1"	,"Destino"			,PesqPict("ZC1","ZC1_FILNOM")	,TamSx3("ZC1_FILNOM")[1]	,/*lPixel*/,{|| (cAliasQry)->ZC1_FILNOM	})
	TRCell():New(oOSTransf_1,"TRANSPORTE"	,"ZC1"	,"Transportadora"	,"@!"									,100								,/*lPixel*/,{|| (cAliasQry)->TRANSPORTE	})

	oOSTransf_2 := TRSection():New(oReport,"Itens da Ordem de Carga",{"ZC1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)

	TRCell():New(oOSTransf_2,"ZC1_PEDIDO"		,"ZC1"	,"Pedido"			,PesqPict("ZC1","ZC1_PEDIDO")	,TamSx3("ZC1_PEDIDO")[1]	,/*lPixel*/,{|| (cAliasQry)->ZC1_PEDIDO	})
	TRCell():New(oOSTransf_2,"ZC1_NUMOLD"		,"ZC1"	,"Pedido Portal"	,PesqPict("ZC1","ZC1_NUMOLD")	,TamSx3("ZC1_NUMOLD")[1]	,/*lPixel*/,{|| (cAliasQry)->ZC1_NUMOLD	})
	TRCell():New(oOSTransf_2,"VOLUME_PEDIDO"	,"ZC1"	,"Volume"			,PesqPict("ZC1","ZC1_QTDLIB")	,TamSx3("ZC1_QTDLIB")[1]	,/*lPixel*/,{|| (cAliasQry)->VOLUME_PEDIDO},"RIGHT",,"RIGHT")

//TRFunction():New(oOSTransf_2:Cell("VOLUME_TOTAL")	,NIL,"ONPRINT"	,/*oBreak*/,"",PesqPict("ZC1","ZC1_QTDLIB"),{|| oOSTransf_2:Cell("VOLUME_TOTAL"):GetValue(.T.) },.T.,.F.)

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Função Static de execução do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)
	Local __QuebraOC

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)

	MakeSqlExpr(oReport:uParam)

	aResult := {}
	If TCSPExist("SP_REL_ORDEM_DE_CARGA")
		aResult := TCSPEXEC("SP_REL_ORDEM_DE_CARGA", mv_par01, xFilial("ZC1"), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	Endif
	IF !Empty(aResult)
		If Select("TSQL") > 0
			dbSelectArea("TSQL")
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TSQL"
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_ORDEM_DE_CARGA: '+TcSqlError())
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

		__QuebraOC := (cAliasQry)->ZC1_NUMOC
		_nTotalVolumes := 0
		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(2):Init()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->ZC1_NUMOC = __QuebraOC

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
		oReport:PrintText(Space(TamSx3("ZC1_NUMOLD")[1]+TamSx3("ZC1_PEDIDO")[1]) + "TOTAL DE VOLUMES: " + Alltrim(Str(_nTotalVolumes)) )
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
	End

	//Fecha Alias Temporario
	If Select(cAliasQry)
		(cAliasQry)->(dbCloseArea())
	EndIf

	//Exclui a tabela temporaria do Banco de Dados
	If TcCanOpen(aResult[1])
		TcSqlExec("DROP TABLE "+aResult[1])
	EndIf

Return
