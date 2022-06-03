#INCLUDE "RWMAKE.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR6   บ Autor ณ Microsiga          บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de Comissใo 1-Recebidas.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha										              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                  		                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                         บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿                           
*/
User Function TAIFFR6()
                       
Private cAliasTrb	:= "TMPR6" // GetNextAlias()
Private cPerg     	:= PADR('TAIFFR6',10)
Private cString		:= 'Query'                                     
Private oReport

//Realiza a validacao da Empresa
If !Pertence('01|02|03',SM0->M0_CODIGO)
	
	Alert("Empresa nใo configurada para gerar este Relat๓rio!")
	Return
	
EndIf

AjustaSx1( cPerg ) // Chama funcao de pergunta

If pergunte(cPerg,.T.)
 			
	oReport:= ReportDef()
	oReport:PrintDialog()
	
EndIf
     
Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑณFunca o   ณReportDef ณ Autor ณ Microsiga          ณData  ณ 26/10/10    ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do Relatorio.              					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF 				                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
                 
Local oBreak
Local oSection1
Local oSection2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport := TReport():New('TAIFFR6','Relat๓rio de Comiss๕es (Vencidas/A vencer)',cPerg,{|oReport|RunReport(oReport)},'')
oReport:SetLandscape(.T.) 

oSection1 := TRSection():New(oReport,"Vendedor",{"SF2"},,,)
oSection1:SetTotalInLine(.T.)

TRCell():New(oSection1,"F2_FILIAL"	,/*Tabela*/,"Filial"		,/*Picture*/					,12,/*lPixel*/,{|| (cAliasTrb)->F2_FILIAL	})	
TRCell():New(oSection1,"F2_VEND1"	,/*Tabela*/,"C๓d. Vend.",/*Picture*/					,20,/*lPixel*/,{|| (cAliasTrb)->F2_VEND1	})	
TRCell():New(oSection1,"A3_NOME"		,/*Tabela*/,"Nome Vend.",/*Picture*/					,60,/*lPixel*/,{|| (cAliasTrb)->A3_NOME	})	

oSection1:Cell("F2_VEND1"):SetLineBreak()

oSection2 := TRSection():New(oReport,"Titulos do vendedor",{"SF2"})
TRCell():New(oSection2,"F2_DOC"		,/*Tabela*/,"Num. NF"			,/*Picture*/					,15,/*lPixel*/,{|| (cAliasTrb)->F2_DOC			})	
TRCell():New(oSection2,"F2_SERIE"	,/*Tabela*/,"Prefixo"			,/*Picture*/					,08,/*lPixel*/,{|| (cAliasTrb)->F2_SERIE		})	
TRCell():New(oSection2,"F2_EMISSAO"	,/*Tabela*/,"Emissao"			,/*Picture*/					,16,/*lPixel*/,{|| (cAliasTrb)->F2_EMISSAO	})	
TRCell():New(oSection2,"F2_CLIENTE"	,/*Tabela*/,"Cliente"			,/*Picture*/					,12,/*lPixel*/,{|| (cAliasTrb)->F2_CLIENTE	})	
TRCell():New(oSection2,"F2_LOJA"		,/*Tabela*/,"Loja"				,/*Picture*/					,06,/*lPixel*/,{|| (cAliasTrb)->F2_LOJA		})	
TRCell():New(oSection2,"A1_NREDUZ"	,/*Tabela*/,"Nome"				,/*Picture*/					,95,/*lPixel*/,{|| (cAliasTrb)->A1_NREDUZ		})	
TRCell():New(oSection2,"F2_VALBRUT"	,/*Tabela*/,"Vl Bruto"			,'@E 99,999,999,999.99'		,20,/*lPixel*/,{|| (cAliasTrb)->F2_VALBRUT	},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"F2_VALMERC"	,/*Tabela*/,"Vlr. Liq"			,'@E 99,999,999,999.99'		,20,/*lPixel*/,{|| (cAliasTrb)->F2_VALMERC	},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"E1_PARCELA"	,/*Tabela*/,"Parcela"			,/*Picture*/					,14,/*lPixel*/,{|| (cAliasTrb)->E1_PARCELA	},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"TT_PARCELAS",/*Tabela*/,"Qt.Parc"			,/*Picture*/					,14,/*lPixel*/,{|| (cAliasTrb)->TT_PARCELAS	},"LEFT",,"LEFT")	
TRCell():New(oSection2,"E1_VENCREA"	,/*Tabela*/,"Venc. Real"		,/*Picture*/					,18,/*lPixel*/,{|| (cAliasTrb)->E1_VENCREA	})	
TRCell():New(oSection2,"E1_BAIXA"	,/*Tabela*/,"Dt. Baixa"			,/*Picture*/					,18,/*lPixel*/,{|| (cAliasTrb)->E1_BAIXA		})	
TRCell():New(oSection2,"E1_VALOR"	,/*Tabela*/,"Vl Parcela"		,'@E 99,999,999,999.99'	,20,/*lPixel*/,{|| (cAliasTrb)->E1_VALOR		},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"E3_BASE"		,/*Tabela*/,"Vl Base"		,'@E 99,999,999,999.99'	,20,/*lPixel*/,{|| (cAliasTrb)->E3_BASE		},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"E3_PORC"		,/*Tabela*/,"Percentual"	,'@E 99,999,999,999.99'	,20,/*lPixel*/,{|| (cAliasTrb)->E3_PORC		},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"E3_COMIS"	,/*Tabela*/,"Comis.Previsto"	,'@E 99,999,999,999.99'	,20,/*lPixel*/,{|| (cAliasTrb)->E3_COMIS		},"RIGHT",,"RIGHT")	
TRCell():New(oSection2,"E1_ITEMC"	,/*Tabela*/,"Tipo"			,/*Picture*/					,14,/*lPixel*/,{|| (cAliasTrb)->E1_ITEMC	},"RIGHT",,"RIGHT")	
 

//oReport:Section(1):SetHeaderPage() // Nใo habilitar
//oReport:Section(2):SetHeaderPage() // Nao habilitar 

oBreak := TRBreak():New(oSection1,{ || oSection1:Cell('F2_VEND1'):uPrint },'Total do representante' ,.F.,'',.T.)
oBreak:SetPageBreak(.T.)

TRFunction():New(oSection2:Cell('E1_VALOR')	,'', 'SUM',oBreak ,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell('E3_BASE')	,'', 'SUM',oBreak ,,,,.F.,.F.,.F., oSection2)
TRFunction():New(oSection2:Cell('E3_COMIS')	,'', 'SUM',oBreak ,,,,.F.,.F.,.F., oSection2)

oSection1:SetPageBreak(.T.)

oSection2:SetLeftMargin(10)		
oSection2:SetPageBreak(.T.)
oSection2:SetHeaderBreak(.T.)

Return( oReport )   


//---------------------------------------------------------------------------------------------------------------//
//
//---------------------------------------------------------------------------------------------------------------//
Static Function RunReport( oReport )

If TCSPExist("SP_REL_COMISS_DAIHATSU")

	aResult := {}
	If SM0->M0_CODIGO='01'
		aResult := TCSPEXEC("SP_REL_COMISS_DAIHATSU", mv_par01, mv_par02, mv_par03, mv_par04, mv_par11, mv_par12, Dtos(mv_par07), Dtos(mv_par08), Dtos(mv_par09), Dtos(mv_par10), SM0->M0_CODIGO, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	ElseIf SM0->M0_CODIGO='02'
		aResult := TCSPEXEC("SP_REL_COMISS_MERCABEL", mv_par01, mv_par02, mv_par03, mv_par04, mv_par11, mv_par12, Dtos(mv_par07), Dtos(mv_par08), Dtos(mv_par09), Dtos(mv_par10), SM0->M0_CODIGO, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	ElseIf SM0->M0_CODIGO='03'
		aResult := TCSPEXEC("SP_REL_COMISS_PROART", mv_par01, mv_par02, mv_par03, mv_par04, mv_par11, mv_par12, Dtos(mv_par07), Dtos(mv_par08), Dtos(mv_par09), Dtos(mv_par10), SM0->M0_CODIGO, ALLTRIM(str(mv_par15)), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	EndIf
		
	If Select("TMPR6") > 0
		dbSelectArea("TMPR6")
		DbCloseArea()
	EndIf

	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPR6"

	TCSetField("TMPR6" , "F2_EMISSAO" , "D") 	
	TCSetField("TMPR6" , "E1_VENCREA" , "D") 	
	TCSetField("TMPR6" , "E1_BAIXA"	 , "D") 	

EndIf
dbSelectArea("TMPR6")				

oReport:Section(1):BeginQuery()	
dbSelectArea("TMPR6")				
oReport:Section(1):EndQuery()

nRecMaximo := (cAliasTrb)->(LastRec())

oReport:SetMeter((cAliasTrb)->(LastRec()))
dbSelectArea((cAliasTrb))
oReport:Section(1):Init()
oReport:Section(2):Init()
                          
While !oReport:Cancel() .And. !(cAliasTrb)->(Eof()) 
                                   
	oReport:Section(1):PrintLine()
	cVendedor := (cAliasTrb)->F2_VEND1
	While !oReport:Cancel() .and. cVendedor=(cAliasTrb)->F2_VEND1 .And. !(cAliasTrb)->(Eof()) 
		oReport:Section(2):PrintLine()
		dbSkip()
		oReport:IncMeter()
	End

	oReport:Section(1):Finish()
	//oReport:Section(2):Finish()

	oReport:nrow := 5000			
	oReport:skipLine()
	
	oReport:Section(1):Init()
	//oReport:Section(2):Init()
	
End

(cAliasTrb)->(dbCloseArea())

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ Microsiga             ณ Data ณ26/10/10  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Monta perguntas no SX1.                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 

//---------------------------------------MV_PAR01-------------------------------------------------- OK
aHelpPor := {'Filial de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Filial de      ? ","","","mv_ch1","C",02,0,0,"G","","SM0",,,"MV_PAR01")

//---------------------------------------MV_PAR02-------------------------------------------------- OK 
aHelpPor := {'Filial ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"02","Filial ate     ? ","","","mv_ch2","C",02,0,0,"G","","SM0",,,"MV_PAR02")

//---------------------------------------MV_PAR03-------------------------------------------------- OK
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Vendedor de?     ","","","mv_ch3","C",06,0,0,"G","","SA3",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- OK
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Vendedor ate?    ","","","mv_ch4","C",06,0,0,"G","","SA3",,,"MV_PAR04")   

//---------------------------------------MV_PAR05-------------------------------------------------- OK
aHelpPor := {'Data Emissao de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Data Emissao de (Tํtulo)? ","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- OK
aHelpPor := {'Data Emissao ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Data Emissao ate (Tํtulo)? ","","","mv_ch6","D",08,0,0,"G","","",,,"MV_PAR06")                                                                                            

//---------------------------------------MV_PAR07-------------------------------------------------- OK
aHelpPor := {'Data Vencimento de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Data Vencimento de (Tํtulo)? ","","","mv_ch7","D",08,0,0,"G","","",,,"MV_PAR07")

//---------------------------------------MV_PAR08-------------------------------------------------- OK
aHelpPor := {'Data Vencimento ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"08","Data Vencimento ate (Tํtulo)? ","","","mv_ch8","D",08,0,0,"G","","",,,"MV_PAR08")
                                                                                                 
//---------------------------------------MV_PAR09-------------------------------------------------- OK
aHelpPor := {'Data Baixa de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"09","Data Baixa de (Tํtulo)? ","","","mv_ch9","D",08,0,0,"G","","",,,"MV_PAR09")

//---------------------------------------MV_PAR10-------------------------------------------------- OK
aHelpPor := {'Data Baixa ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"10","Data Baixa ate (Tํtulo)? ","","","mv_cha","D",08,0,0,"G","","",,,"MV_PAR10")

//---------------------------------------MV_PAR11-------------------------------------------------- OK
aHelpPor := {'Cliente de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"11","Cliente de?     ","","","mv_chb","C",06,0,0,"G","","SA1",,,"MV_PAR11")

//---------------------------------------MV_PAR12-------------------------------------------------- OK
aHelpPor := {'Cliente ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"12","Cliente ate?    ","","","mv_chc","C",06,0,0,"G","","SA1",,,"MV_PAR12")

//---------------------------------------MV_PAR13-------------------------------------------------- OK
aHelpPor := {'Titulo de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"13","Titulo de?     ","","","mv_chd","C",09,0,0,"G","","SE1",,,"MV_PAR13")

//---------------------------------------MV_PAR14-------------------------------------------------- OK
aHelpPor := {'Titulo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"14","Titulo ate?    ","","","mv_che","C",09,0,0,"G","","SE1",,,"MV_PAR14")  

//---------------------------------------MV_PAR15-------------------------------------------------- OK
aHelpPor := {'Unidade de Negocio?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"15","Unidade de Negocio?","","","mv_chf","N",01,0,0,"C","","","","","MV_PAR15","Todas"	   	 ,""      ,""      ,""    ,"TAIFF"        	,""     ,""      ,"PROART" 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")  

RestArea(aAreaAnt)

Return()
