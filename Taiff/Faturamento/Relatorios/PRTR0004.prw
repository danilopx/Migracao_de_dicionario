#include "protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTR0004  บAutor  ณThiago Comelli      บ Data ณ  26/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIMPRESSAO DE ETIQUETAS DE PRODUTOS PARA PROART              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico PROART                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PRTR0004()
	Local Arq  := CriaTrab(,.F.)+".TXT" //Nome do Arquivo a Gerar
	Local Path := GetTempPath() + Arq //Local de Gera็ใo do Arquivo
	Local aComp:= {}
	Local x := 0
//Local Path := StrTran(GetSrvProfString("StartPath","") + Arq,":","") //Local de Gera็ใo do Arquivo

	Private cPerg 		:= PADR("PRTR00004",10) //Pergunta
	Private cPorta	:= AllTrim(SuperGetMV("PRT_ETQ004",.F., "LPT1")) //Define a porta padrใo da impressora
	Private nHdl

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica a Existencia de Parametro PRT_ETQ004ณ
//ณCaso nao exista. Cria o parametro.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX6")
	If ! dbSeek("  "+"PRT_ETQ004")
		RecLock("SX6",.T.)
		X6_VAR    	:= "PRT_ETQ004"
		X6_TIPO 	:= "C"
		X6_CONTEUD 	:= "LPT1"
		X6_CONTENG 	:= "LPT1"
		X6_CONTSPA 	:= "LPT1"
		X6_DESCRIC	:= "DEFINE A PORTA DA IMPRESSORA DE ETIQUETAS PARA A  "
		X6_DESC1	:= "ROTINA PRTR00003                                  "
		X6_DESC2	:= "                                                  "
		MsUnlock("SX6")
	EndIf

	ValidPerg()

	If Pergunte(cPerg,.T.)

		//Seleciona dados para manipula็ใo
		cQuery := " SELECT SB1.B1_DESC, SB1.B1_CODBAR, "
		// Tratamento para as informacoes da Etiqueta - Edson Hornberger - 16/08/2013
		cQuery += " SB5.B5_YIMPORT, SB5.B5_YIMPCNP, SB5.B5_YDISTRI, SB5.B5_YDISCNP, SB5.B5_YVALIDA, SB5.B5_YQTDEMB, SB5.B5_YPAISOR, SB5.B5_YCOMPOS "
		cQuery += " FROM "+RetSqlName("SB1") + " SB1, "
		cQuery += RetSqlName("SB5") + " SB5 "
		cQuery += " WHERE SB1.D_E_L_E_T_ = '' "
		cQuery += " AND SB5.D_E_L_E_T_ = '' "
		cQuery += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"' "
		cQuery += " AND SB5.B5_FILIAL = '"+xFilial("SB5")+"' "
		cQuery += " AND SB1.B1_COD = '"+mv_par01+"' " //+mv_par02+"' "
		cQuery += " AND SB5.B5_COD = SB1.B1_COD"
		// Fim do Tratamento

		//MemoWrit("PRTR0004.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasQry := GetNextAlias()), .F., .T.)

		dbSelectArea(cAliasQry)
		dbGoTop()

		If (cAliasQry)->(EOF()) .OR. mv_par02 <= 0 //verifica se estแ no fim do arquivo ou numero de etiquetas a imprimir ้ Zero.
			cMensagem := " Nใo existem etiquetas para serem impressas, nenhum "+Chr(13)+Chr(10)
			cMensagem += " Produto foi selecionado pelos criterios de pesquisa."+Chr(13)+Chr(10)
			MsgStop(cMensagem,"Aten็ใo - PRTR0004")
			(cAliasQry)->(dbCloseArea())
			Return

		Else //Caso tenha dados come็a impressใo de etiquetas

			nHdl    := fCreate(Path) //Cria Arquivo para grava็ใo das etiquetas

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCome็a LOOP de impressaoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			While (cAliasQry)->(!Eof())

				aComp := GERACOMP(ALLTRIM((cAliasQry)->B5_YCOMPOS))

				For x:= 1 to ROUND((mv_par02/2),0) //Divide Numero de Etiquetas por 2, pois sao 2 por linha

					cVar := "^XA"+ENTER
					cVar += "^FO040,10^A0N,15,15^FDImportado por: " + AllTrim((cAliasQry)->B5_YIMPORT) + "^FS"+ENTER
					cVar += "^FO040,27^A0N,15,15^FDCNPJ: " + Transform(AllTrim((cAliasQry)->B5_YIMPCNP),"@R 99.999.999/9999-99")+ "^FS"+ENTER
					cVar += "^FO040,44^A0N,15,15^FDDistribuido por " + AllTrim((cAliasQry)->B5_YDISTRI) + "^FS"+ENTER
					cVar += "^FO040,61^A0N,15,15^FDCNPJ: " + Transform(AllTrim((cAliasQry)->B5_YDISCNP),"@R 99.999.999/9999-99")+ "^FS"+ENTER
					cVar += "^FO040,78^A0N,15,15^FDValidade " + AllTrim((cAliasQry)->B5_YVALIDA) + "^FS"+ENTER
					cVar += "^FO040,95^A0N,15,15^FDQtd.: " + AllTrim((cAliasQry)->B5_YQTDEMB) + "^FS"+ENTER
					//cVar += "^FO040,112^A0N,15,15^FDPais de Origem " + AllTrim((cAliasQry)->B5_YPAISOR) + "^FS"+ENTER
					cVar += "^FO130,95^A0N,15,15^FDPais de Origem " + AllTrim((cAliasQry)->B5_YPAISOR) + "^FS"+ENTER
					cVar += "^FO040,112^A0N,15,15^FDComposicao: " + AllTrim(ACOMP[1][1]) + "^FS"+ENTER
					IF LEN(ACOMP) > 1
						cVar += "^FO040,129^A0N,15,15^FD" + AllTrim(ACOMP[2][1]) + "^FS"+ENTER
					ENDIF
					cVar += "^FO040,145^A0N,35,15^FD"	+SubStr((cAliasQry)->B1_DESC,1,50)+		"^FS"+ENTER
					cVar += "^FO070,175^BY3^BEN,70,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER

					cVar += "^FO420,10^A0N,15,15^FDImportado por: " + AllTrim((cAliasQry)->B5_YIMPORT) + "^FS"+ENTER
					cVar += "^FO420,27^A0N,15,15^FDCNPJ: " + Transform(AllTrim((cAliasQry)->B5_YIMPCNP),"@R 99.999.999/9999-99")+ "^FS"+ENTER
					cVar += "^FO420,44^A0N,15,15^FDDistribuido por " + AllTrim((cAliasQry)->B5_YDISTRI) + "^FS"+ENTER
					cVar += "^FO420,61^A0N,15,15^FDCNPJ: " + Transform(AllTrim((cAliasQry)->B5_YDISCNP),"@R 99.999.999/9999-99")+ "^FS"+ENTER
					cVar += "^FO420,78^A0N,15,15^FDValidade " + AllTrim((cAliasQry)->B5_YVALIDA) + "^FS"+ENTER
					cVar += "^FO420,95^A0N,15,15^FDQtd.: " + AllTrim((cAliasQry)->B5_YQTDEMB) + "^FS"+ENTER
					//cVar += "^FO420,112^A0N,15,15^FDPais de Origem " + AllTrim((cAliasQry)->B5_YPAISOR) + "^FS"+ENTER
					cVar += "^FO510,95^A0N,15,15^FDPais de Origem " + AllTrim((cAliasQry)->B5_YPAISOR) + "^FS"+ENTER
					cVar += "^FO420,112^A0N,15,15^FDComposicao: " + AllTrim(ACOMP[1][1]) + "^FS"+ENTER
					IF LEN(ACOMP) > 1
						cVar += "^FO420,129^A0N,15,15^FD" + AllTrim(ACOMP[2][1]) + "^FS"+ENTER
					ENDIF
					cVar += "^FO420,145^A0N,35,15^FD"	+SubStr((cAliasQry)->B1_DESC,1,50)+		"^FS"+ENTER
					cVar += "^FO450,175^BY3^BEN,70,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
					cVar += "^XZ"+ENTER

					Set Century OFF
					If fWrite(nHdl,cVar,Len(cVar)) != Len(cVar) //Gravacao do arquivo
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
							fClose(nHdl)
							Return
						Endif
					Endif

				Next x

				(cAliasQry)->(DbSkip())
			EndDo

			fClose(nHdl)
			COPY FILE &Path TO LPT1
			MsgAlert("Arquivo  '" + Path + "'  Gerado com Sucesso e Enviado para Impressora na Porta '"+cPorta+"'!","Aten็ใo")

		EndIf

		If Select(cAliasQry) > 0 //Verifica se o Alias ainda estแ aberta
			(cAliasQry)->(DBCLOSEAREA())
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณThiago Comelli      บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta no e o help do SX1                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng          ,cVar	,cTipo  ,nTamanho				,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Produto          	",""                    ,""                    ,"mv_ch1","C"   ,TamSx3("B1_COD")[1]	,0       ,1      , "G",""    			,"SB1" ,""         ,""   ,"mv_par01",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
//PutSx1(cPerg,"02"   ,"Produto Ate        ",""                    ,""                    ,"mv_ch2","C"   ,TamSx3("B1_COD")[1]	,0       ,0      , "G",""    			,"SB1" ,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Quantidade de Etiq.	",""                    ,""                    ,"mv_ch2","N"   ,10						,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par03",""    		 ,""      ,""      ,""    ,""     			,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P."+cPerg+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Produto")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

/*
cKey     := "P."+cPerg+"02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Produto Final")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
*/

	cKey     := "P."+cPerg+"02."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Quantidade de Etiquetas a serem impressas")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return


STATIC FUNCTION GERACOMP(CCOMP)

	LOCAL NPOSSPACE 	:= 0
	LOCAL ARET			:= {}

	IF LEN(CCOMP) <= 50

		AADD(ARET,{CCOMP})

	ELSE

		NPOSSPACE := RAT(" ",SUBSTR(CCOMP,1,35))
		AADD(ARET,{SUBSTR(CCOMP,1,NPOSSPACE)})
		AADD(ARET,{SUBSTR(CCOMP,NPOSSPACE+1,LEN(CCOMP)-NPOSSPACE)})

	ENDIF

RETURN(ARET)
