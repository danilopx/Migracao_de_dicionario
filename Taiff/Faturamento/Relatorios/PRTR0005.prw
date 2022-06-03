#include "protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTR0005  บAutor  ณ                    บ Data ณ  26/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIMPRESSAO DE ETIQUETAS DE PRODUTOS PARA PROART caixa fechadaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico PROART                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PRTR0005()
Local Arq  := CriaTrab(,.F.)+".TXT" //Nome do Arquivo a Gerar
Local Path := GetTempPath() + Arq //Local de Gera็ใo do Arquivo
//Local Path := StrTran(GetSrvProfString("StartPath","") + Arq,":","") //Local de Gera็ใo do Arquivo
LOCAL X	:= 0

Private cPerg 		:= PADR("TFPRTR005",10) //Pergunta
Private cPorta	:= AllTrim(SuperGetMV("PRT_ETQ005",.F., "LPT1")) //Define a porta padrใo da impressora
Private nHdl

Private nTamDescricao := GetNewPar("TF_ETQ05a",39)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica a Existencia de Parametro PRT_ETQ005ณ
//ณCaso nao exista. Cria o parametro.           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX6")
If ! dbSeek("  "+"PRT_ETQ005")
	RecLock("SX6",.T.)
	X6_VAR    	:= "PRT_ETQ005"
	X6_TIPO 	:= "C"
	X6_CONTEUD 	:= "LPT1"
	X6_CONTENG 	:= "LPT1"
	X6_CONTSPA 	:= "LPT1"
	X6_DESCRIC	:= "DEFINE A PORTA DA IMPRESSORA DE ETIQUETAS PARA A  "
	X6_DESC1	:= "ROTINA PRTR00005                                  "
	X6_DESC2	:= "                                                  "
	MsUnlock("SX6")
EndIf

ValidPerg()

If Pergunte(cPerg,.T.)
	
	//Seleciona dados para manipula็ใo
	cQuery := " SELECT B1_COD, B1_DESC, B1_CODBAR, B1_YTOTEMB, B1_PESO, B1_YENDEST, B1_YCAIFEC, B1_YESTAC, B1_YENDSEP, B1_EAN14 "
	cQuery += " FROM "+RetSqlName("SB1")
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	//cQuery += " AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cQuery += " AND B1_COD = '"+mv_par01+"' "
	
	//MemoWrit("PRTR0005.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasQry := GetNextAlias()), .F., .T.)
	
	dbSelectArea(cAliasQry)
	dbGoTop()
	
	If (cAliasQry)->(EOF()) .OR. mv_par02 <= 0 //verifica se estแ no fim do arquivo ou numero de etiquetas a imprimir ้ Zero.
		cMensagem := " Nใo existem etiquetas para serem impressas, nenhum "+Chr(13)+Chr(10)
		cMensagem += " Produto foi selecionado pelos criterios de pesquisa."+Chr(13)+Chr(10)
		MsgStop(cMensagem,"Aten็ใo - PRTR0005")
		(cAliasQry)->(dbCloseArea())
		Return
		
	Else //Caso tenha dados come็a impressใo de etiquetas
		
		nHdl    := fCreate(Path) //Cria Arquivo para grava็ใo das etiquetas
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCome็a LOOP de impressaoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		While (cAliasQry)->(!Eof())
			
			For x:= 1 to mv_par02 //Divide Numero de Etiquetas por 3, pois sao 3 por linha
   /*				
				cVar := "^XA"+ENTER
				cVar += "^FO060,20^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
				cVar += "^FO060,55^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
				cVar += "^FO320,20^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
				cVar += "^FO320,55^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
				cVar += "^FO585,20^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
				cVar += "^FO585,55^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
				cVar += "^XZ"+ENTER    */
				
			wpesob := str(((cAliasQry)->B1_YTOTEMB*(cAliasQry)->B1_PESO ))
			
   			cVar := "^XA"+ENTER
			cVar += "^LRY"+ENTER
			cVar += "^FO000,000^GB1000,100,120^FS"+ENTER
			cVar += "^FO000,130^GB1000,1,1^FS"+ENTER
			cVar += "^FO015, 30^A0N,35,35^FD"		    	+SubStr((cAliasQry)->B1_DESC,1,nTamDescricao)+		"^FS"+ENTER  
  			cVar += "^FO445,180^A0N,35,35^FDSETOR^FS"+ENTER 
			cVar += "^FO015,250^A0N,25,25^FDPeso Bruto : "	+ALLTRIM(wpesob)				  +		" Kg.^FS"+ENTER       
   			cVar += "^FO435,230^A0N,50,50^FD"   	+ALLTRIM((cAliasQry)->B1_YENDEST) +		"^FS"+ENTER    
  			cVar += "^FO450,380^A0N,35,35^FD"   	+ALLTRIM((cAliasQry)->B1_COD) +		"^FS"+ENTER 
 	//		cVar += "^FO005,330^BCN,90,Y,N,N^FD"+((cAliasQry)->B1_)+		"^FS"+ENTER 
			cVar += "^FO020,330^BCN,90,Y,N,N^FD"	+SubStr((cAliasQry)->B1_EAN14,1,14)+	"^FS"+ENTER	
   //			cVar += "^FO005,330^BCN,90,Y,N,N^FD"+((cAliasQry)->ZZF_PEDIDO+(cAliasQry)->ZZF_SEQCX)+		"^FS"+ENTER
   			cVar += "^FO000,470^GB1000,1,1^FS"+ENTER		      			
			cVar += "^FO015,480^A0N,12,27^FDTAIFF PROART DISTRIBUIDORA DE PRODUTOS DE BELEZA LTDA - PROART^FS"+ENTER
						   

			cVar += "^LRN"+ENTER
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
SetKey(VK_F12, {||})	
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
PutSx1(cPerg,"01"   ,"Produto          ",""                    ,""                    ,"mv_ch1","C"   ,TamSx3("B1_COD")[1]	,0       ,1      , "G",""    			,"SB1" ,""         ,""   ,"mv_par01",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"Quantidade de Etiq.",""                    ,""                    ,"mv_ch2","N"   ,10						,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par02",""    		 ,""      ,""      ,""    ,""     			,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

cKey     := "P."+cPerg+"01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Produto a imprimir")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

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
