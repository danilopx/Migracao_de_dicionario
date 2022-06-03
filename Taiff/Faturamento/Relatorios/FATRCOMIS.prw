#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ FATRCOMIS ³ Autor ³ Carlos Torres      ³ Data ³ 16/12/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera demonstrativos de comissão em Excel                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATRCOMIS()
Local oObj	 

Private cCadastro := "Demonstrativos de comissão"
Private cString := ""

AjustaSx1( "FATRCOMIS" ) 

If Pergunte("FATRCOMIS",.T.)
	oObj := MsNewProcess():New({|lEnd| U_TFCOMISTAIFF(oObj, @lEnd)}, "Gera demonstrativos de comissão", "", .T.)
	oObj :Activate()
EndIf

Return

/*
-----------------------------------------------------------------------------------------------------
Criar planilha da TAIFF
-----------------------------------------------------------------------------------------------------
*/
USER FUNCTION TFCOMISTAIFF(oObj,lEnd)

LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		CTITSHEET	:= "Demonstrativo"
LOCAL 		CTITTABLE	:= "Demonstrativo"

Local cArq		:= ""
Local cQryZAG := ""  
Local _nX		:=0
Local nCntaVendedor := 0

PRIVATE OEXCELAPP
PRIVATE OEXCEL 		:= FWMSEXCELEX():NEW()
PRIVATE OEXCEL_PRO	:= FWMSEXCELEX():NEW()
PRIVATE _cAlias

cQryZAG := " SELECT ZAQ_CODVEN, RTRIM(LTRIM(A3_NOME)) AS A3_NOME " + ENTER
cQryZAG += " FROM "+RetSqlName("ZAQ")+" ZAQ WITH(NOLOCK) " + ENTER
cQryZAG += " INNER JOIN "+RetSqlName("SA3")+" SA3 WITH(NOLOCK) " + ENTER
cQryZAG += " 	ON A3_COD = ZAQ_CODVEN"  + ENTER
cQryZAG += " 	AND A3_FILIAL = ZAQ_FILIAL"  + ENTER
cQryZAG += " 	AND SA3.D_E_L_E_T_=''" + ENTER
cQryZAG += " WHERE ZAQ.D_E_L_E_T_ <> '*' " + ENTER
cQryZAG += " AND ZAQ_FILIAL = '" + xFilial("ZAQ") + "'" + ENTER
cQryZAG += " AND ZAQ_CODVEN >= '" + MV_PAR01 + "' " + ENTER
cQryZAG += " AND ZAQ_CODVEN <= '" + MV_PAR02 + "' " + ENTER
cQryZAG += " AND ZAQ_DTPAGT = '" + DTOS(MV_PAR03) + "' " + ENTER
cQryZAG += " AND ZAQ_STATUS = 'F'" 

//MemoWrite("TFCOMISTAIFF.sql",cQryZAG)

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQryZAG),(_cAlias := GetNextAlias()), .F., .T.)

COUNT TO nCntaVendedor
(_cAlias)->(DbGotop())
oObj:SetRegua1( nCntaVendedor )

_nX:=0

While !(_cAlias)->(Eof())
	_nX += 1
	oObj:IncRegua1("Processando vendedor " + Alltrim(Str(_nX)) + " de " + Alltrim(Str(nCntaVendedor)) + " encontrados.")
	oObj:SetRegua2(4)

	cTfVende := UPPER((_cAlias)->A3_NOME)
	While At( " " ,cTfVende ) != 0 
		cTfVende := STUFF(cTfVende, At( " " ,cTfVende ) ,1,"")
	End
	 
	cArq := Alltrim(MV_PAR04) + Dtos(Date()) + "_DEMONSTRATIVO_" + cTfVende + "_" + (_cAlias)->ZAQ_CODVEN + ".XLS"
	
	aResult := {}
	If TCSPExist("SP_REL_DEMONSTRATIVO_PAGAMENTO_COMISSAO_PROTHEUS")
		aResult := TCSPEXEC( "SP_REL_DEMONSTRATIVO_PAGAMENTO_COMISSAO_PROTHEUS", (_cAlias)->ZAQ_CODVEN, xFilial("ZAQ"), DTOS(MV_PAR03), '3', DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
	Endif
	IF !Empty(aResult)
		If Select("TMPBM") > 0
			dbSelectArea("TMPBM")
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPBM"
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_DEMONSTRATIVO_PAGAMENTO_COMISSAO_PROTHEUS: '+TcSqlError())
	EndIf

	nCount := 0
	WHILE TMPBM->(!EOF())
		nCount += 1
		TMPBM->(DBSKIP())
	END 

	TMPBM->(DBGOTOP())
	
	If nCount > 0
		oObj:IncRegua2("Gerando planilha 1 de 4.")
	
		CTITSHEET	:= "Demonstrativo"
		CTITTABLE	:= "Demonstrativo"
	
		OEXCEL 	:= FWMSEXCELEX():NEW()
		OEXCEL:ADDWORKSHEET(CTITSHEET)
		OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
		OEXCEL:SetTitleFont('VERDANA')
		OEXCEL:SETTITLESIZEFONT(14)
		OEXCEL:SETTITLEBOLD(.T.)
		OEXCEL:SETTITLEFRCOLOR("#F8B878")
		OEXCEL:SETTITLEBGCOLOR("#FFFFFF")
		
		OEXCEL:SetHeaderBold(.T.)
		OEXCEL:SetHeaderFont('VERDANA')
		OEXCEL:SetHeaderItalic(.F.)
		OEXCEL:SetHeaderUnderLine(.F.)
		OEXCEL:SetHeaderSizeFont(14)
		OEXCEL:SetFrColorHeader("#000000") 
		OEXCEL:SetBgColorHeader("#F4A460")
	
		OEXCEL:SETLINESIZEFONT(8)
		OEXCEL:SET2LINESIZEFONT(8)
		OEXCEL:SetLineBold(.F.)
		OEXCEL:Set2LineBold(.F.)
		
		/*
		OEXCEL:SETLINESIZEFONT(11)
		OEXCEL:SET2LINESIZEFONT(11)
	
		OEXCEL:SETLINEFRCOLOR("#000000")
		OEXCEL:SETLINEBGCOLOR("#FFFFFF")
		OEXCEL:SET2LINEFRCOLOR("#000000")
		OEXCEL:SET2LINEBGCOLOR("#FFFFFF")
		*/
		
		
		ASTRUCT := DBSTRUCT()
		
		FOR NX := 2 TO FCOUNT()
			
			DO CASE
				CASE NX = 2  
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",1,1,.F.)
				CASE NX = 3   
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,2,.F.)
				CASE NX = 4   
					OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,2,.F.)
			ENDCASE 
			
		NEXT NX
		
		WHILE TMPBM->(!EOF()) 
			
			AITENS := {}
			AITTT	:= {}
			
			FOR NX := 2 TO FCOUNT()
			
				AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
				
			NEXT NX  
			
			AADD(AITTT,AITENS)
	
			If TMPBM->COLUNA0 = "07" .OR. TMPBM->COLUNA0 = "15"
				OEXCEL:SetCelBold(.T.)
				OEXCEL:SetCelFont('VERDANA')
				OEXCEL:SetCelItalic(.F.)
				OEXCEL:SetCelUnderLine(.F.)
				OEXCEL:SetCelSizeFont(8)
				OEXCEL:SetCelFrColor("#000000") 
				OEXCEL:SetCelBgColor("#F4A460")
			Else
				OEXCEL:SetCelBold(.F.)
				OEXCEL:SetCelFont('VERDANA')
				OEXCEL:SetCelItalic(.F.)
				OEXCEL:SetCelUnderLine(.F.)
				OEXCEL:SetCelSizeFont(8)
				OEXCEL:SetCelFrColor("#000000") 
				OEXCEL:SetCelBgColor("#FFFFFF")
			EndIf
	
			OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1],{1,2,3})
	
			
			TMPBM->(DBSKIP())
			
		ENDDO

		/**/
		oObj:IncRegua2("Gerando planilha 2 de 4.")
		U_ExcelEmitidas()
		
		/**/
		oObj:IncRegua2("Gerando planilha 3 de 4.")
		U_ExcelRecebida()

		/**/
		oObj:IncRegua2("Gerando planilha 4 de 4.")
		U_ExcelVencida()

		OEXCEL:ACTIVATE()
		OEXCEL:GETXMLFILE( cArq ) 
		OEXCEL:DEACTIVATE()
	
		(_cAlias)->(DBSKIP())
		
		If lEnd 
			Exit
		EndIf
		
	ENDIF	
Enddo

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

RETURN


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

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informar o codigo do vendedor inicial ou" )
Aadd( aHelpPor, "deixe em branco para considerar todos   " )

Aadd( aHelpEng, "Informar o codigo do vendedor inicial ou" )
Aadd( aHelpEng, "deixe em branco para considerar todos   " )

Aadd( aHelpSpa, "Informar o codigo do vendedor inicial ou" ) 
Aadd( aHelpSpa, "deixe em branco para considerar todos   " )

PutSx1("FATRCOMIS","01"   ,"Do vendedor","Do vendedor","Do vendedor"	,"mv_ch1","C",6,0,0,"G","","SA3","","S",;
"mv_par01", "","","",SPAC(06),;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informar o codigo do vendedor final ou  " )
Aadd( aHelpPor, "deixe com ZZZZZZ para considerar todos  " )

Aadd( aHelpEng, "Informar o codigo do vendedor final ou  " )
Aadd( aHelpEng, "deixe com ZZZZZZ para considerar todos  " )

Aadd( aHelpSpa, "Informar o codigo do vendedor final ou  " ) 
Aadd( aHelpSpa, "deixe com ZZZZZZ para considerar todos  " )

PutSx1("FATRCOMIS","02"   ,"Até o Vendedor","Até o Vendedor","Até o Vendedor","mv_ch2","C",6,0,0,"G","","SA3","","S",;
"mv_par02", "","","","ZZZZZZ",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			"","","",".FATRCOMIS.")

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informar a data de pagamento da comissao" )

Aadd( aHelpEng, "Informar a data de pagamento da comissao" )

Aadd( aHelpSpa, "Informar a data de pagamento da comissao" ) 

PutSx1(cPerg,"03","Qual a data de pagamento?","Qual a data de pagamento?","Qual a data de pagamento?","mv_ch3",;
"D",8,0,0,"C","","","","","mv_par03","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Informar a pasta destino dos arquivos   " )
Aadd( aHelpPor, "Exemplo M:\publico\ODAIR\              " )  

Aadd( aHelpEng, "Informar a pasta destino dos arquivos   " )
Aadd( aHelpEng, "Exemplo M:\publico\ODAIR\              " )  

Aadd( aHelpSpa, "Informar a pasta destino dos arquivos   " ) 
Aadd( aHelpSpa, "Exemplo M:\publico\ODAIR\              " )  

PutSx1(cPerg,"04","Qual a pasta destino?","Qual a pasta destino?","Qual a pasta destino?","mv_ch4",;
"C",50,0,0,"C","","","","","mv_par04","","","","M:\publico\ODAIR\","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)


RestArea(aAreaAnt)
Return()

/*
--------------------------------------------------------------------------------------------------------------
Gera Aba da comissão emitida
--------------------------------------------------------------------------------------------------------------
*/
User Function ExcelEmitidas 
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		CTITSHEET	:= "Comissoes_Emitidas"
LOCAL 		CTITTABLE	:= "Comissoes_Emitidas"
Local nBrutTaiff	:= 0
Local nComiTaiff	:= 0
Local nBaseTaiff	:= 0
Local nBrutProart	:= 0
Local nComiProart	:= 0
Local nBaseProart	:= 0

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SetTitleFont('VERDANA')
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#F8B878")
OEXCEL:SETTITLEBGCOLOR("#FFFFFF")

OEXCEL:SetHeaderBold(.T.)
OEXCEL:SetHeaderFont('VERDANA')
OEXCEL:SetHeaderItalic(.F.)
OEXCEL:SetHeaderUnderLine(.F.)
OEXCEL:SetHeaderSizeFont(8)
OEXCEL:SetFrColorHeader("#000000") 
OEXCEL:SetBgColorHeader("#F4A460")

aResult := {}
If TCSPExist("SP_REL_COMISSAO_EMITIDA_POR_VENDEDOR_PROTHEUS")
	aResult := TCSPEXEC("SP_REL_COMISSAO_EMITIDA_POR_VENDEDOR_PROTHEUS", CEMPANT, xFilial("ZAQ"), (_cAlias)->ZAQ_CODVEN, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
Endif
IF !Empty(aResult)
	If Select("TMPBM") > 0
		dbSelectArea("TMPBM")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPBM"
Else
	Final('Erro na execucao da Stored Procedure SP_REL_COMISSAO_EMITIDA_POR_VENDEDOR_PROTHEUS: '+TcSqlError())
EndIf

ASTRUCT := DBSTRUCT()

FOR NX := 3 TO FCOUNT()
	
	DO CASE
		CASE NX = 3   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(12) ,1,1,.F.)
		CASE NX = 4   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(10) ,3,1,.F.)
		CASE NX = 11   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,3,.F.)
		CASE NX = 12   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,3,.F.)
		CASE NX = 13   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,2,.F.)
		CASE NX = 14   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,3,.F.)
		OTHERWISE 
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",1,1,.F.)
	ENDCASE 
	
NEXT NX
NSTRUCOUNT	:= LEN(ASTRUCT)

AITENS := {}
AITTT	:= {}
FOR NX := 3 TO NSTRUCOUNT
	
	AADD(AITENS,FIELDNAME(NX))
	
NEXT NX
AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

OEXCEL:SetLineFont('VERDANA')
OEXCEL:Set2LineFont('VERDANA')
OEXCEL:SETLINESIZEFONT(8)
OEXCEL:SET2LINESIZEFONT(8)
OEXCEL:SetLineBold(.F.)
OEXCEL:Set2LineBold(.F.)

//OEXCEL:SETLINEFRCOLOR("#000000")
//OEXCEL:SETLINEBGCOLOR("#FFFFFF")
//OEXCEL:SET2LINEFRCOLOR("#FFFFFF")
//OEXCEL:SET2LINEBGCOLOR("#000000")

OEXCEL:SetLineFrColor("#d4d4d4")
OEXCEL:Set2LineFrColor("#ffffff")

CLOOPMARCA := TMPBM->MARCA
CPROCMARCA := ALLTRIM(TMPBM->MARCA)
nBrutTaiff	:= 0
nComiTaiff	:= 0
nBaseTaiff	:= 0
nBrutProart	:= 0
nComiProart	:= 0
nBaseProart	:= 0
WHILE TMPBM->(!EOF()) 
	
	If TMPBM->MARCA = "TAIFF"
		nBrutTaiff	+= TMPBM->VALOR_BRUTO
		nComiTaiff	+= TMPBM->VALOR_COMISSAO
		nBaseTaiff	+= TMPBM->VALOR_BASE
	ElseIf TMPBM->MARCA = "PROART"
		nBrutProart	+= TMPBM->VALOR_BRUTO
		nComiProart	+= TMPBM->VALOR_COMISSAO
		nBaseProart	+= TMPBM->VALOR_BASE
	EndIf

	CPROCMARCA := TMPBM->MARCA
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 3 TO FCOUNT()
	
		AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
		
	NEXT NX  

	OEXCEL:SetCelBold(.F.)
	OEXCEL:SetCelFont('VERDANA')
	OEXCEL:SetCelItalic(.F.)
	OEXCEL:SetCelUnderLine(.F.)
	OEXCEL:SetCelSizeFont(8)
	OEXCEL:SetCelFrColor("#000000") 
	OEXCEL:SetCelBgColor("#FFFFFF")
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

	
	TMPBM->(DBSKIP())
	
	If TMPBM->MARCA != CLOOPMARCA .OR. TMPBM->(EOF())
		CLOOPMARCA := TMPBM->MARCA
		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		OEXCEL:SetCelBold(.T.)
		OEXCEL:SetCelFont('VERDANA')
		OEXCEL:SetCelItalic(.F.)
		OEXCEL:SetCelUnderLine(.F.)
		OEXCEL:SetCelSizeFont(8)
		OEXCEL:SetCelFrColor("#000000") 
		OEXCEL:SetCelBgColor("#F4A460")

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. BRUTO")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBrutTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBrutProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. BASE")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBaseTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBaseProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. COMISSAO")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nComiTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nComiProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		If !TMPBM->(EOF())

			AITENS := {}
			AITTT	:= {}
			FOR NX := 3 TO NSTRUCOUNT
				
				AADD(AITENS,FIELDNAME(NX))
				
			NEXT NX
			AADD(AITTT,AITENS)
			OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
		ENDIF

	EndIf
ENDDO
OEXCEL:SetCelBold(.T.)
OEXCEL:SetCelFont('VERDANA')
OEXCEL:SetCelItalic(.F.)
OEXCEL:SetCelUnderLine(.F.)
OEXCEL:SetCelSizeFont(8)
OEXCEL:SetCelFrColor("#000000") 
OEXCEL:SetCelBgColor("#F4A460")

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VLR. BRUTO")
AADD(AITENS,STR(nBrutTaiff + nBrutProart,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VLR. BASE")
AADD(AITENS,STR(nBaseTaiff + nBaseProart,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"TOTAL COMISSAO")
AADD(AITENS,STR(nComiTaiff + nComiProart,14,2) )
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Gera Aba da comissão recebida
--------------------------------------------------------------------------------------------------------------
*/
User Function ExcelRecebida 
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		CTITSHEET	:= "Comissoes_Recebida"
LOCAL 		CTITTABLE	:= "Comissoes_Recebida"
Local nBrutTaiff	:= 0
Local nComiTaiff	:= 0
Local nBaseTaiff	:= 0
Local nBrutProart	:= 0
Local nComiProart	:= 0
Local nBaseProart	:= 0

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SetTitleFont('VERDANA')
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#F8B878")
OEXCEL:SETTITLEBGCOLOR("#FFFFFF")

OEXCEL:SetHeaderBold(.T.)
OEXCEL:SetHeaderFont('VERDANA')
OEXCEL:SetHeaderItalic(.F.)
OEXCEL:SetHeaderUnderLine(.F.)
OEXCEL:SetHeaderSizeFont(8)
OEXCEL:SetFrColorHeader("#000000") 
OEXCEL:SetBgColorHeader("#F4A460")

aResult := {}
If TCSPExist("SP_REL_COMISSAO_RECEBIDA_POR_VENDEDOR_PROTHEUS")
	aResult := TCSPEXEC("SP_REL_COMISSAO_RECEBIDA_POR_VENDEDOR_PROTHEUS", CEMPANT, xFilial("ZAQ"), (_cAlias)->ZAQ_CODVEN, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
Endif
IF !Empty(aResult)
	If Select("TMPBM") > 0
		dbSelectArea("TMPBM")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPBM"
Else
	Final('Erro na execucao da Stored Procedure SP_REL_COMISSAO_EMITIDA_POR_VENDEDOR_PROTHEUS: '+TcSqlError())
EndIf

ASTRUCT := DBSTRUCT()

FOR NX := 3 TO FCOUNT()
	
	DO CASE
		CASE NX = 3   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(12) ,1,1,.F.)
		CASE NX = 4   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(10) ,3,1,.F.)
		CASE NX = 11 .OR. NX = 12 .OR. NX = 17 .OR. NX = 18 .OR. NX = 20
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,3,.F.)
		CASE NX = 13 .OR. NX = 14 .OR. NX = 19   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,2,.F.)
		OTHERWISE 
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",1,1,.F.)
	ENDCASE 
	
NEXT NX
NSTRUCOUNT	:= LEN(ASTRUCT)

AITENS := {}
AITTT	:= {}
FOR NX := 3 TO NSTRUCOUNT
	
	AADD(AITENS,FIELDNAME(NX))
	
NEXT NX
AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

OEXCEL:SetLineFont('VERDANA')
OEXCEL:Set2LineFont('VERDANA')
OEXCEL:SETLINESIZEFONT(8)
OEXCEL:SET2LINESIZEFONT(8)
OEXCEL:SetLineBold(.F.)
OEXCEL:Set2LineBold(.F.)

//OEXCEL:SETLINEFRCOLOR("#000000")
//OEXCEL:SETLINEBGCOLOR("#FFFFFF")
//OEXCEL:SET2LINEFRCOLOR("#FFFFFF")
//OEXCEL:SET2LINEBGCOLOR("#000000")

OEXCEL:SetLineFrColor("#d4d4d4")
OEXCEL:Set2LineFrColor("#ffffff")

CLOOPMARCA := TMPBM->MARCA
CPROCMARCA := ALLTRIM(TMPBM->MARCA)
nBrutTaiff	:= 0
nComiTaiff	:= 0
nBaseTaiff	:= 0
nBrutProart	:= 0
nComiProart	:= 0
nBaseProart	:= 0
WHILE TMPBM->(!EOF()) 
	
	If TMPBM->MARCA = "TAIFF"
		nBrutTaiff	+= TMPBM->VALOR_TITULO
		nComiTaiff	+= TMPBM->VALOR_COMISSAO
		nBaseTaiff	+= TMPBM->VALOR_BASE
	ElseIf TMPBM->MARCA = "PROART"
		nBrutProart	+= TMPBM->VALOR_TITULO
		nComiProart	+= TMPBM->VALOR_COMISSAO
		nBaseProart	+= TMPBM->VALOR_BASE
	EndIf

	CPROCMARCA := TMPBM->MARCA
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 3 TO FCOUNT()
	
		AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
		
	NEXT NX  

	OEXCEL:SetCelBold(.F.)
	OEXCEL:SetCelFont('VERDANA')
	OEXCEL:SetCelItalic(.F.)
	OEXCEL:SetCelUnderLine(.F.)
	OEXCEL:SetCelSizeFont(8)
	OEXCEL:SetCelFrColor("#000000") 
	OEXCEL:SetCelBgColor("#FFFFFF")
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

	
	TMPBM->(DBSKIP())
	
	If TMPBM->MARCA != CLOOPMARCA .OR. TMPBM->(EOF())
		CLOOPMARCA := TMPBM->MARCA
		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		OEXCEL:SetCelBold(.T.)
		OEXCEL:SetCelFont('VERDANA')
		OEXCEL:SetCelItalic(.F.)
		OEXCEL:SetCelUnderLine(.F.)
		OEXCEL:SetCelSizeFont(8)
		OEXCEL:SetCelFrColor("#000000") 
		OEXCEL:SetCelBgColor("#F4A460")

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VALOR DA MARCA")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBrutTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBrutProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. BASE")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBaseTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBaseProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. COMISSAO")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nComiTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nComiProart,14,2))
		Else
			AADD(AITENS,"0")
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		If !TMPBM->(EOF())

			AITENS := {}
			AITTT	:= {}
			FOR NX := 3 TO NSTRUCOUNT
				
				AADD(AITENS,FIELDNAME(NX))
				
			NEXT NX
			AADD(AITTT,AITENS)
			OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
		ENDIF

	EndIf
ENDDO
OEXCEL:SetCelBold(.T.)
OEXCEL:SetCelFont('VERDANA')
OEXCEL:SetCelItalic(.F.)
OEXCEL:SetCelUnderLine(.F.)
OEXCEL:SetCelSizeFont(8)
OEXCEL:SetCelFrColor("#000000") 
OEXCEL:SetCelBgColor("#F4A460")

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VALOR")
AADD(AITENS,STR(nBrutTaiff + nBrutProart,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VLR. BASE")
AADD(AITENS,STR(nBaseTaiff + nBaseProart,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"TOTAL COMISSAO")
AADD(AITENS,STR(nComiTaiff + nComiProart,14,2) )
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return NIL


/*
--------------------------------------------------------------------------------------------------------------
Gera Aba da comissão vencidas/a vencer
--------------------------------------------------------------------------------------------------------------
*/
User Function ExcelVencida 
LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		CTITSHEET	:= "Vencidas_a_Vencer"
LOCAL 		CTITTABLE	:= "Vencidas_a_Vencer"
Local nBrutTaiff	:= 0
Local nComiTaiff	:= 0
Local nBaseTaiff	:= 0
Local nBrutProart	:= 0
Local nComiProart	:= 0
Local nBaseProart	:= 0

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SetTitleFont('VERDANA')
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#F8B878")
OEXCEL:SETTITLEBGCOLOR("#FFFFFF")

OEXCEL:SetHeaderBold(.T.)
OEXCEL:SetHeaderFont('VERDANA')
OEXCEL:SetHeaderItalic(.F.)
OEXCEL:SetHeaderUnderLine(.F.)
OEXCEL:SetHeaderSizeFont(8)
OEXCEL:SetFrColorHeader("#000000") 
OEXCEL:SetBgColorHeader("#F4A460")

aResult := {}
If TCSPExist("SP_REL_COMISS_VENCIDA_E_A_VENCER_PROTHEUS")
	aResult := TCSPEXEC("SP_REL_COMISS_VENCIDA_E_A_VENCER_PROTHEUS", SM0->M0_CODIGO, SM0->M0_CODFIL, (_cAlias)->ZAQ_CODVEN, DTOS(Date())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
//	aResult := TCSPEXEC("SP_REL_COMISS_VENCIDA_E_A_VENCER_PROTHEUS", mv_par01, mv_par02, mv_par03, mv_par04, DTOS(mv_par05), DTOS(mv_par06), cAliqInterna, SM0->M0_CODIGO, SF2->F2_FILIAL, cMV_ESTADO, MV_PAR07, MV_PAR08, DTOS(Date())+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
Endif
IF !Empty(aResult)
	If Select("TMPBM") > 0
		dbSelectArea("TMPBM")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPBM"
Else
	Final('Erro na execucao da Stored Procedure SP_REL_COMISS_VENCIDA_E_A_VENCER_PROTHEUS: '+TcSqlError())
EndIf

ASTRUCT := DBSTRUCT()

FOR NX := 3 TO FCOUNT()
	
	DO CASE
		CASE NX = 3   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(12) ,1,1,.F.)
		CASE NX = 4   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,SPACE(10) ,3,1,.F.)
		CASE NX = 11 .OR. NX = 12 .OR. NX = 17 .OR. NX = 18 .OR. NX = 20
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,3,.F.)
		CASE NX = 13 .OR. NX = 14 .OR. NX = 19   
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",3,2,.F.)
		OTHERWISE 
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,"",1,1,.F.)
	ENDCASE 
	
NEXT NX
NSTRUCOUNT	:= LEN(ASTRUCT)

AITENS := {}
AITTT	:= {}
FOR NX := 3 TO NSTRUCOUNT
	
	AADD(AITENS,FIELDNAME(NX))
	
NEXT NX
AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

OEXCEL:SetLineFont('VERDANA')
OEXCEL:Set2LineFont('VERDANA')
OEXCEL:SETLINESIZEFONT(8)
OEXCEL:SET2LINESIZEFONT(8)
OEXCEL:SetLineBold(.F.)
OEXCEL:Set2LineBold(.F.)

//OEXCEL:SETLINEFRCOLOR("#000000")
//OEXCEL:SETLINEBGCOLOR("#FFFFFF")
//OEXCEL:SET2LINEFRCOLOR("#FFFFFF")
//OEXCEL:SET2LINEBGCOLOR("#000000")

OEXCEL:SetLineFrColor("#d4d4d4")
OEXCEL:Set2LineFrColor("#ffffff")

CLOOPMARCA := TMPBM->MARCA
CPROCMARCA := ALLTRIM(TMPBM->MARCA)
nBrutTaiff	:= 0
nComiTaiff	:= 0
nBaseTaiff	:= 0
nBrutProart	:= 0
nComiProart	:= 0
nBaseProart	:= 0
nBrutAll	:= 0
nComiAll	:= 0
nBaseAll	:= 0
WHILE TMPBM->(!EOF()) 
	
	If TMPBM->MARCA = "TAIFF"
		nBrutTaiff	+= TMPBM->VALOR_PARCELA
		nComiTaiff	+= TMPBM->VL_COMIS_PREVISAO
		nBaseTaiff	+= TMPBM->VALOR_BASE
	ElseIf TMPBM->MARCA = "PROART"
		nBrutProart	+= TMPBM->VALOR_PARCELA
		nComiProart	+= TMPBM->VL_COMIS_PREVISAO
		nBaseProart	+= TMPBM->VALOR_BASE
	Else
		nBrutAll	+= TMPBM->VALOR_PARCELA
		nComiAll	+= TMPBM->VL_COMIS_PREVISAO
		nBaseAll	+= TMPBM->VALOR_BASE
	EndIf

	CPROCMARCA := TMPBM->MARCA
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 3 TO FCOUNT()
	
		AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
		
	NEXT NX  

	OEXCEL:SetCelBold(.F.)
	OEXCEL:SetCelFont('VERDANA')
	OEXCEL:SetCelItalic(.F.)
	OEXCEL:SetCelUnderLine(.F.)
	OEXCEL:SetCelSizeFont(8)
	OEXCEL:SetCelFrColor("#000000") 
	OEXCEL:SetCelBgColor("#FFFFFF")
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

	
	TMPBM->(DBSKIP())
	
	If TMPBM->MARCA != CLOOPMARCA .OR. TMPBM->(EOF())
		CLOOPMARCA := TMPBM->MARCA
		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		OEXCEL:SetCelBold(.T.)
		OEXCEL:SetCelFont('VERDANA')
		OEXCEL:SetCelItalic(.F.)
		OEXCEL:SetCelUnderLine(.F.)
		OEXCEL:SetCelSizeFont(8)
		OEXCEL:SetCelFrColor("#000000") 
		OEXCEL:SetCelBgColor("#F4A460")

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. PARCELAS DA MARCA")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBrutTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBrutProart,14,2))
		Else
			AADD(AITENS,STR(nBrutAll,14,2))
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. BASE")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nBaseTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nBaseProart,14,2))
		Else
			AADD(AITENS,STR(nBaseAll,14,2))
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		AADD(AITENS,"VLR. COMISSAO PREVISTO")
		If CPROCMARCA = "TAIFF"
			AADD(AITENS,STR(nComiTaiff,14,2))
		ElseIf CPROCMARCA = "PROART"
			AADD(AITENS,STR(nComiProart,14,2))
		Else
			AADD(AITENS,STR(nComiAll,14,2))
		EndIf
		FOR NX := 5 TO FCOUNT()
			AADD(AITENS,SPACE(10)) 
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		AITENS := {}
		AITTT	:= {}
		
		FOR NX := 3 TO FCOUNT()
			AADD(AITENS,SPACE(10)) // Quebra de linha
		NEXT NX  
		
		AADD(AITTT,AITENS)
		OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

		If !TMPBM->(EOF())

			AITENS := {}
			AITTT	:= {}
			FOR NX := 3 TO NSTRUCOUNT
				
				AADD(AITENS,FIELDNAME(NX))
				
			NEXT NX
			AADD(AITTT,AITENS)
			OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
		ENDIF

	EndIf
ENDDO
OEXCEL:SetCelBold(.T.)
OEXCEL:SetCelFont('VERDANA')
OEXCEL:SetCelItalic(.F.)
OEXCEL:SetCelUnderLine(.F.)
OEXCEL:SetCelSizeFont(8)
OEXCEL:SetCelFrColor("#000000") 
OEXCEL:SetCelBgColor("#F4A460")

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VLR. PARCELAS")
AADD(AITENS,STR(nBrutTaiff + nBrutProart + nBrutAll,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"VLR. BASE")
AADD(AITENS,STR(nBaseTaiff + nBaseProart + nBaseAll,14,2))
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

AITENS := {}
AITTT	:= {}

AADD(AITENS,"TOTAL VLR. COMISSAO PREVISTO")
AADD(AITENS,STR(nComiTaiff + nComiProart + nComiAll,14,2) )
FOR NX := 5 TO FCOUNT()
	AADD(AITENS,SPACE(10)) // Quebra de linha
NEXT NX  

AADD(AITTT,AITENS)
OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return NIL
