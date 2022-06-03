#Include 'rwmake.ch'
#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFFATFRET ºAutor  ³Carlos Torres       º Data ³  10/04/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de impressão do metodo de calculo do frete          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 	                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TFFATFRET()
	Private oGeraNf
	Private cPerg		:= "TFFATfre"
	Private cCadastro := "Cálculo do Frete"
	Private oReport

	AjustaSx1( "TFFATfre" )

	If Pergunte("TFFATfre",.T.)
		oReport := DReportDef()
		oReport:PrintDialog()
	EndIf

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Perguntas do relatório
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}

	Aadd( aHelpPor, "Data da Fatura" )
	Aadd( aHelpEng, "Data da Fatura" )
	Aadd( aHelpSpa, "Data da Fatura" )

	PutSx1(cPerg,"01"   ,"Data da Fatura?","",""	,"mv_ch1","D",08,0,0,"G","","",,,;
		"mv_par01", "","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

	aHelpPor := {}
	aHelpEng := {}
	aHelpSpa := {}

	Aadd( aHelpPor, "Informe o código da fatura" )
	Aadd( aHelpEng, "Informe o código da fatura" )
	Aadd( aHelpSpa, "Informe o código da fatura" )

	PutSx1(cPerg,"02"   ,"Fatura?","",""	,"mv_ch2","C",10,0,0,"G","","","","",;
		"mv_par02","","","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		aHelpPor,aHelpEng,aHelpSpa)
	//"","","",".TFSEPTAI.")

Return

/*
--------------------------------------------------------------------------------------------------------------
Função Static de preparação dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef()
	Local oReport
	Local cAliasQry := "TSQLFATU"
	Local oOSTransf_1
	Local oOSTransf_2
	Local oOSTransf_3

	PRIVATE CTFOPE1 := ""
	PRIVATE CTFOPE2 := ""
	PRIVATE CTFOPE3 := ""
	PRIVATE CTFOPE4 := ""

	oReport := TReport():New("TFFATfre","Calculo do frete","TFFATfre", {|oReport| DReportPrint(oReport,cAliasQry)},"")
	oReport:SetLandscape()
	oReport:SetTotalInLine(.T.)

	Pergunte(oReport:uParam,.F.)

	oOSTransf_1 := TRSection():New(oReport,"Analitico do Calculo do Frete",{"PAV"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_1:SetTotalInLine(.F.)
	oOSTransf_1:SetPageBreak(.T.)

	TRCell():New(oOSTransf_1,"PAV_FATURA"	,"PAV"	,"Fatura"				,PesqPict("PAV","PAV_FATURA")	,TamSx3("PAV_FATURA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_FATURA	})
	TRCell():New(oOSTransf_1,"PAV_EMISFA"	,"PAV"	,"Emissao"				,PesqPict("PAV","PAV_EMISFA")	,TamSx3("PAV_EMISFA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_EMISFA	})
	TRCell():New(oOSTransf_1,"PAV_CODTRA"	,"PAV"	,"Transportadora"		,"@!"								,TamSx3("PAV_CODTRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_CODTRA	})

	oOSTransf_2 := TRSection():New(oReport,"Conhecimentos",{"PAV"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oOSTransf_2:SetTotalInLine(.T.)

	TRCell():New(oOSTransf_2,"PAV_CTO"			,"PAV"	,"Conhecimento"	,PesqPict("PAV","PAV_CTO")		,TamSx3("PAV_CTO")[1]		,/*lPixel*/,{|| (cAliasQry)->PAV_CTO		})
	TRCell():New(oOSTransf_2,"PAV_EMICTO"		,"PAV"	,"Emissao"			,PesqPict("PAV","PAV_EMICTO")	,TamSx3("PAV_EMICTO")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_EMICTO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_NF"			,"PAV"	,"Documento"		,PesqPict("PAV","PAV_NF")			,TamSx3("PAV_NF")[1]		,/*lPixel*/,{|| (cAliasQry)->PAV_NF			},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_SERIE"		,"PAV"	,"Serie"			,PesqPict("PAV","PAV_SERIE")		,TamSx3("PAV_SERIE")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_SERIE		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Frete Tran"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_FRETRA		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Frete Calc"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_FRCALC		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Tx. Conhec"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_TXACTO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Pedagio"			,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_VLRPED		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Outras Tx"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_OTRTXA		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Vl. Gris"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_VLGRIS		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"AdValorem"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_ADVALO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Vl. Peso"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_VLPESO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Adic. AdVal"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_ADVALO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Adic.Tx.Peso"	,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_ADPESO		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Vl. T.E.D."		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_VLTED		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Vl. T.R.T."		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_VLTRT		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Vl. Tonel."		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_FRETOL		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_FRETRA"		,"PAV"	,"Peso Util."		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,/*lPixel*/,{|| (cAliasQry)->PAV_PESOCU		},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_EMICTO"		,"PAV"	,"UF Cliente"		,PesqPict("SA1","A1_EST")			,TamSx3("A1_EST")[1]		,/*lPixel*/,{|| CUFCLIENTE					},"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_2,"PAV_EMICTO"		,"PAV"	,"CEP Cliente"		,PesqPict("SA1","A1_CEP")			,TamSx3("A1_CEP")[1]		,/*lPixel*/,{|| CCEPCLIENTE					},"RIGHT",,"RIGHT")

	oOSTransf_3 := TRSection():New(oReport,"TOTAIS",{"PAV"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	TRCell():New(oOSTransf_3,"Totais"			,		,"Frete"			,									,07)
	TRCell():New(oOSTransf_3,"Emissao"			,		,"Emissao"			,									,07)
	TRCell():New(oOSTransf_3,"Documento"		,		,"Documento"		,									,07)
	TRCell():New(oOSTransf_3,"Serie"				,		,"Serie"			,									,07)
	TRCell():New(oOSTransf_3,"PAV_MTA1"			,		,"Frete Tran"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,,,"RIGHT",,"RIGHT")
	TRCell():New(oOSTransf_3,"PAV_MTA"			,		,"Frete Calc"		,PesqPict("PAV","PAV_FRETRA")	,TamSx3("PAV_FRETRA")[1]	,,,"RIGHT",,"RIGHT")

	oOSTransf_3:Cell("Totais"):HideHeader()
	oOSTransf_3:Cell("Emissao"):HideHeader()
	oOSTransf_3:Cell("Documento"):HideHeader()
	oOSTransf_3:Cell("Serie"):HideHeader()
	oOSTransf_3:Cell("PAV_MTA1"):HideHeader()
	oOSTransf_3:Cell("PAV_MTA"):HideHeader()

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Função Static de execução do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)

	oReport:SetTitle(oReport:Title() )
	oReport:Section(1):SetHeaderPage(.T.)
	oReport:Section(1):SetHeaderSection(.T.)
	oReport:Section(1):SetHeaderBreak(.F.)

	MakeSqlExpr(oReport:uParam)

	If TCSPExist("SP_REL_FAT_CALCULO_FRETE_PAV")

		aResult := TCSPEXEC("SP_REL_FAT_CALCULO_FRETE_PAV", DTOS(MV_PAR01), CFILANT, MV_PAR02, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )

		IF !Empty(aResult)

			If Select(cAliasQry) > 0
				dbSelectArea(cAliasQry)
				DbCloseArea()
			EndIf

			TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS cAliasQry

		Else

			Final('Erro na execucao da Stored Procedure SP_REL_FAT_CALCULO_FRETE_PAV: '+TcSqlError())

		EndIf

	Else

		Final("RE-INSTALAR A STORED PROCEDURE: SP_REL_FAT_CALCULO_FRETE_PAV")

	EndIf

	oReport:Section(1):BeginQuery()
	dbSelectArea(cAliasQry)
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SA2->(DbSetOrder(1))
	SA1->(DbSetOrder(1))
//F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_FORMUL, F2_TIPO, R_E_C_N_O_, D_E_L_E_T_
	SF2->(DbSeTOrder(1))

	oReport:SetMeter((cAliasQry)->(LastRec()))
	dbSelectArea(cAliasQry)

	While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

		cDtQuebra := (cAliasQry)->PAV_EMISFA
		cClQuebra := (cAliasQry)->PAV_FATURA

		_nTotMTA := 0
		_nTotMTA1:= 0

		oReport:Section(1):Init()
		oReport:Section(1):PrintLine()
		oReport:Section(2):Init()
		While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->PAV_EMISFA = cDtQuebra .and. (cAliasQry)->PAV_FATURA = cClQuebra

			SF2->(DbSeek( xFilial("SF2") + (cAliasQry)->PAV_NF + (cAliasQry)->PAV_SERIE ))
			If SF2->F2_TIPO $ 'B/D'
				if SA2->(DbSeek( xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA ))
					_cCep	:= SA2->A2_CEP
					_cEst	:= SF2->F2_EST
				endif
			Else
				if SA1->(DbSeek( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))
					_cCep	:= SA1->A1_CEP
					_cEst	:= SA1->A1_EST
					_lTDE	:= SA1->A1_FRETED == "S"
				endif
			Endif

			CUFCLIENTE		:= SF2->F2_EST
			CCEPCLIENTE	:= SA1->A1_CEP

			oReport:Section(2):PrintLine()

			_nTotMTA 	+= (cAliasQry)->PAV_FRCALC
			_nTotMTA1 	+= (cAliasQry)->PAV_FRETRA

			dbSelectArea(cAliasQry)
			dbSkip()
			oReport:IncMeter()
		End

		oReport:Section(3):Init()
		oReport:Section(3):Cell( "Totais" ):SetBlock( { || "TOTAL" } ) // "TOTAL GERAL"
		oReport:Section(3):Cell("PAV_MTA1"):SetBlock( { || _nTotMTA1 } )
		oReport:Section(3):Cell("PAV_MTA"):SetBlock( { || _nTotMTA } )

		oReport:Section(3):PrintLine()
		oReport:Section(3):Finish()
		oReport:Section(2):Finish()
		oReport:Section(1):Finish()

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
