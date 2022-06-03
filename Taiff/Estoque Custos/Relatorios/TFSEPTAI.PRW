#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "REPORT.CH"   		
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)
#DEFINE PL CHR(13) + CHR(10)

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: TFSEPTAI                                     AUTOR: CARLOS TORRES                 DATA: 09/04/2015
// DESCRICAO: Gera planilha em Excel com PEDIDOS DE VENDAS TAIFF QUE SERÃO SEPARADOS - CROSS DOCKING 
//--------------------------------------------------------------------------------------------------------------
User Function TFSEPTAI()
	// Local aParamBox	:= {}
	// Local aRet			:= {}

	Private cCadastro := "Pre-Separação TAIFF"
	Private cString := ""


	AjustaSx1( "TFSEPTfs" ) 

	If Pergunte("TFSEPTfs",.T.)
		U_TfSeparaPed(  Alltrim(Str(mv_par01)) , mv_par02 , mv_par03 , mv_par04 , Alltrim(Str(mv_par05)) , mv_par06, mv_par07 )
	EndIf

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Geração da planilha excel
--------------------------------------------------------------------------------------------------------------
*/
User Function TfSeparaPed( __cOFdE , __dIni , __dAte, __cPst , __cSitOs , __cOsIni, __cOsFin )
 

//Local lForced := .F.
//Local nConta	:= 0
//Local cDthFim	:= ""
//Local cHoraFim:= "" 

//LOCAL 		CSQL		:= ""
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		OEXCEL 	:= FWMSEXCEL():NEW()
//LOCAL 		OEXCEL_PRO	:= FWMSEXCEL():NEW()
//LOCAL 		OEXCELAPP
LOCAL 		CTITSHEET	:= "Analitico"
LOCAL 		CTITTABLE	:= "Analitico"

Local cArq		:= ""
//Local cScript	:= ""
Local cTime	:= Time()
Local cPasta	:= Alltrim(__cPst)
  
While At(":",cTime) != 0
	cTime := Stuff( cTime , At(":",cTime),1,"" )	
End

cArq := cPasta+"Pedidos_TAIFF_por_Liberacao_" + Dtos(Date()-1) + "_" + cTime + ".XLS"

IF ( APOLECLIENT("MSEXCEL") )

	If TCSPExist("SP_REL_PRE_SEPARACAO_TAIFF")
		OEXCEL:ADDWORKSHEET(CTITSHEET)
		OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
		OEXCEL:SETTITLESIZEFONT(14)
		OEXCEL:SETTITLEBOLD(.T.)
		OEXCEL:SETTITLEFRCOLOR("#000000")
		OEXCEL:SETTITLEBGCOLOR("#778899")
		OEXCEL:SETLINESIZEFONT(11)
		OEXCEL:SET2LINESIZEFONT(11)
	
		_cQuery := "EXEC SP_REL_PRE_SEPARACAO_TAIFF '" + __cOFdE + "', '" + Dtos( __dIni ) + "', '" + Dtos( __dAte ) + "', '" + __cSitOs + "', '" + __cOsIni + "', '" +  __cOsFin + "'"  
		
		If Select("TMPBM") > 0
			dbSelectArea("TMPBM")
			DbCloseArea()
		EndIf
	
		TCQUERY _cQuery NEW ALIAS "TMPBM"
	
		DBSELECTAREA("TMPBM")
		
		ASTRUCT := DBSTRUCT()
		
		FOR NX := 1 TO FCOUNT()
			
			DO CASE
				CASE ASTRUCT[NX,02] = "C"  
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,1)
				CASE ASTRUCT[NX,02] = "N"
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,2)
				CASE ASTRUCT[NX,02] = "D"
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,4)
			ENDCASE 
			
		NEXT NX
		
		WHILE TMPBM->(!EOF()) 
			
			AITENS := {}
			AITTT	:= {}
			
			FOR NX := 1 TO FCOUNT()
			
				AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
				
			NEXT NX  
			
			AADD(AITTT,AITENS)
			OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
			
			TMPBM->(DBSKIP())
			
		ENDDO
		
		OEXCEL:ACTIVATE()
		OEXCEL:GETXMLFILE( cArq ) 
		OEXCEL:DEACTIVATE()
		
		IF .NOT.( ApOleClient("MsExcel") )
			BREAK
		EndIF
		
		oMsExcel := MsExcel():New()
		oMsExcel:WorkBooks:Open( cArq )
		oMsExcel:SetVisible( .T. )
		oMsExcel := oMsExcel:Destroy()
		

	Else
		MsgAlert("Procedure SP_REL_PRE_SEPARACAO_TAIFF não encontrada!")
	EndIf
Else
	MsgAlert("Aplicativo MS Office Excel não está instalado!")
EndIf
Return
/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal de transferencia
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 

Aadd( aHelpPor, "Informe a marca a separar TAIFF ou PROART" )
Aadd( aHelpEng, "Informe a marca a separar TAIFF ou PROART" )
Aadd( aHelpSpa, "Informe a marca a separar TAIFF ou PROART" ) 

PutSx1(cPerg,"01"   ,"Marca ?","",""	,"mv_ch1","N",01,0,0,"C","","","","",;
"mv_par01", "TAIFF","","","",;
		    "PROART","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {} 

Aadd( aHelpPor, "Data de liberação do pedido" )
Aadd( aHelpEng, "Data de liberação do pedido" )
Aadd( aHelpSpa, "Data de liberação do pedido" ) 

PutSx1(cPerg,"02"   ,"Data de Liberação De?","",""	,"mv_ch2","D",08,0,0,"G","","",,,;
"mv_par02", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {} 

Aadd( aHelpPor, "Data de liberação do pedido" )
Aadd( aHelpEng, "Data de liberação do pedido" )
Aadd( aHelpSpa, "Data de liberação do pedido" ) 

PutSx1(cPerg,"03"   ,"Data de Liberação Ate?","",""	,"mv_ch3","D",08,0,0,"G","","",,,;
"mv_par03", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

PutSx1(cPerg,"04"   ,"Pasta destino do arquivo?","",""	,"mv_ch4","C",60,0,0,"G","","","","",;
"mv_par04", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			"","","",".TFSEPTAI.")

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {} 

Aadd( aHelpPor, "Condisera pedidos com a OS" )
Aadd( aHelpEng, "Condisera pedidos com a OS" )
Aadd( aHelpSpa, "Condisera pedidos com a OS" ) 

PutSx1(cPerg,"05"   ,"Considera Pedidos ?","",""	,"mv_ch5","N",01,0,0,"C","","","","",;
"mv_par05", "Sem OS","","","",;
		    "Somente com OS","","",;
			"Todos os Pedidos","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {} 

Aadd( aHelpPor, "Ordem de Separação inicial" )
Aadd( aHelpEng, "Ordem de Separação inicial" )
Aadd( aHelpSpa, "Ordem de Separação inicial" ) 

PutSx1(cPerg,"06"   ,"Da OS?","",""	,"mv_ch6","C",06,0,0,"G","","","","",;
"mv_par06","","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {} 

Aadd( aHelpPor, "Ordem de Separação final" )
Aadd( aHelpEng, "Ordem de Separação final" )
Aadd( aHelpSpa, "Ordem de Separação final" ) 

PutSx1(cPerg,"07"   ,"Até a OS?","",""	,"mv_ch7","C",06,0,0,"G","","","","",;
"mv_par07","","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

RestArea(aAreaAnt)

Return()
