#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI009  บAutor  ณCarlos Torres       บ Data ณ  28/12/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta log de pedido de venda                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATMI009()

	Private oVeLogPed
	Private cPerg	:= "FATMI009"
	Private aPerg	:= {}
	Private aHelp	:= {}

	ValidPerg(cPerg)

	@ 200,001 TO 480,380 DIALOG oVeLogPed TITLE OemToAnsi("Consulta status de pedido")
	@ 003,005 TO 085,187 PIXEL OF oVeLogPed
	@ 010,018 Say "Este programa tem a finalidade de consultar status " SIZE 150,010 PIXEL OF oVeLogPed
	@ 020,018 Say "do pedido de venda e rotina de libera็ใo em lote." SIZE 150,010 PIXEL OF oVeLogPed
	@ 065,008 BUTTON "Continua  "  ACTION (Processa({||FATMI0901()}),oVeLogPed:End())PIXEL OF oVeLogPed
	@ 100,008 BMPBUTTON TYPE 02 ACTION oVeLogPed:End()

	Activate Dialog oVeLogPed Centered


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALIDPERG บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG(cPerg)

	//				X1_ORDEM	X1_PERGUNT					X1_PERSPA					X1_PERENG				X1_VARIAVL	X1_TIPO		X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01		X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME		X1_GRPSXG	X1_HELP		X1_PICTURE	X1_IDFIL
	AADD(aPerg,{	"01"   		,"Da Data Liberacao   ?"	,""                    ,""                    ,"mv_ch1"	,"D"   		,08      	,0       	,0      	, "G"	,""    		,"mv_par01"	,""			,""			,""			,""			,""      ,""      	,""    		,""	       	,""     	,""      	,""  	  	,""      	,""			,""    		,""      ,""			,""			,""      	,""			,""      	,""      	,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"02"   		,"Ate a Data Liberacao?"	,""                    ,""                    ,"mv_ch2"	,"D"   		,08      	,0       	,0      	, "G"	,""    		,"mv_par02"	,""        ,""   		,""			,""       	,""      ,""      	,""    		,""    		,""	    	,""      	,""    	  	,""      	,""			,""			,""      ,""     		,""    		,""      	,""      	,""      	,""    	  	,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"03"   		,"Do Gerente	?"			,""                    ,""                    ,"mv_ch3"	,"C"   		,06      	,0       	,0      	, "G"	,""    		,"mv_par03" 	,""        ,""   		,""			,""		   	,""      ,""      	,""    		,""       	,"" 	    ,""     	,""    	  	,""      	,""			,""    		,""      ,""     		,""    		,""      	,""      	,""      	,""    	  	,""      	,""			,""			,"SA3"	,""			,""			,""			,""			,""})
	AADD(aPerg,{	"04"   		,"Filial destino?"		,""                    ,""                    ,"mv_ch4"	,"N"   		,01      	,0       	,0      	, "C"	,""    		,"mv_par04" 	,"EXTREMA" ,""   		,""			,""	 		,""      ,"SAO PAULO"	,""    		,""     	,""     	,""      	,"TODAS"	,""      	,""			,""    		,""      ,""     		,""    		,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"05"   		,"Marca?"					,""                    ,""                    ,"mv_ch5"	,"N"   		,01      	,0       	,0      	, "C"	,""    		,"mv_par05" 	,"TAIFF"  	,""   		,""			,""	 		,""      ,"PROART"	,""    		,""	   		,""     	,""      	,""		  	,""      	,""			,""    		,""      ,""     		,""    		,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"06"   		,"Pedido?"					,""                    ,""                    ,"mv_ch6"	,"C"   		,06      	,0       	,0      	, "G"	,""    		,"mv_par06" 	,""			,""   		,""			,""	 		,""      ,""			,""    		,""	   		,""     	,""      	,""		  	,""      	,""			,""    		,""      ,""     		,""    		,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"07"   		,"Cliente?"				,""                    ,""                    ,"mv_ch7"	,"C"   		,06      	,0       	,0      	, "G"	,""    		,"mv_par07" 	,""  		,""   		,""			,""	 		,""      ,""			,""    		,""	   		,""     	,""      	,""		  	,""      	,""			,""    		,""      ,""     		,""    		,""      	,""      	,""      	,""			,""      	,""			,""			,"SA1"	,""			,""			,""			,""			,""})
	//AADD(aPerg,{	"08"   		,"Classe de Liberacao?"	,""                    ,""                    ,"mv_ch8"	,"N"   		,01      	,0       	,0      	, "C"	,""    		,"mv_par08" 	,"TODAS"	,""   		,""			,""	 		,""      ,"BLOQUEADO"	,""    		,""	   		,""     	,""      	,"LIBERADO",""      	,""			,""    		,""      ,"A PROCESSAR",""    		,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AjustaSX1( cPerg, aPerg, aHelp )
	 
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI0901 บAutor  ณMicrosiga           บ Data ณ  16/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FATMI0901

	Local oListBox
	Local nOpc		:= 0
	Local oBmp2, oBmp3
	Local cDtProcessto := CTOD("  /  /  ")
	Local aTFSize := {}
	Local aPosObj := {}

	Private aDados	:= {}
	Private oDlgPedidos
	Private cBloqI
	Private _cAlias2 := ""

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif

	If SC5->(FIELDPOS("C5__DTLIBF")) = 0
		MsgStop("A consulta nใo estแ disponivel nesta empresa/filial!","Aten็ใo")
		Return(.T.)
	EndIf
	cDtProcessto := GetMV("MV__ESTMD" + Iif(MV_PAR05=1,"T","P") ,.F.,"")
	
	aTFSize := MsAdvSize(.F.)

	aCampos	:= {}
	_cPesqPed	:= Space(6)
	_nTotal	:= 0
	_cMarca	:= ""
	Cursorwait()
//seleciona os pedidos
	cQuery := "SELECT" + ENTER
	cQuery += "	C5_NUM" + ENTER
	cQuery += "	,LEFT(C5_NOMCLI,30)  AS C5_NOMCLI" + ENTER
	cQuery += "	,CASE WHEN C5__LIBM = 'A' THEN 'AUTOMATICO' WHEN C5__LIBM = 'M' THEN 'MANUAL' ELSE '' END AS C5__LIBM" + ENTER
	cQuery += "	,C5_HIST5" + ENTER
	cQuery += "	,C5__DTLIBF" + ENTER
	cQuery += "	,C5__BLOQF" + ENTER
	cQuery += "	,CASE WHEN C5__RESERV = '' THEN '' ELSE 'COM CONTROLE' END AS C5__RESERV" + ENTER
	cQuery += "	,C9_ORDSEP" + ENTER
	cQuery += "	,CASE WHEN C5_FILDES = '01' THEN 'SP' WHEN C5_FILDES = '02' THEN 'MG' ELSE '' END AS C5_DESTINO " + ENTER
	cQuery += "	,CASE WHEN C5_CLASPED = 'V' THEN 'VENDA' WHEN C5_CLASPED = 'X' THEN 'BONIFICACAO' ELSE 'OUTROS' END AS C5_CLASSE " + ENTER
	cQuery += "	,CASE WHEN C5_CONDPAG IN ('N01','N02') THEN 'COND. PAGTO: A VISTA' " + ENTER
	cQuery += "	WHEN ISNULL(C5__LIBM,'')='' THEN 'NAO PROCESSADO' " + ENTER
	cQuery += "	WHEN C5__BLOQF != '' THEN ''" + ENTER
	cQuery += "	WHEN ISNULL(C9_ORDSEP,'')='' AND C5_FILDES = '01' THEN 'SEM SEPARACAO' " + ENTER
	cQuery += "	WHEN ISNULL(CB7_STATUS,'')=0 AND C5_FILDES = '01' THEN 'AGUARDANDO SEPARACAO' " + ENTER 
	cQuery += "	WHEN ISNULL(CB7_STATUS,'') BETWEEN 1 AND 8 AND C5_FILDES = '01' THEN 'EM SEPARACAO' " + ENTER 
	cQuery += "	WHEN ISNULL(CB7_STATUS,'')=9 AND C5_FILDES = '01' THEN 'SEPARADA' " + ENTER 
	cQuery += "	ELSE 'A FATURAR' END AS CB7_STATUS " + ENTER
	cQuery += "FROM "+RetSqlName("SC5")+" SC5 WITH(NOLOCK) " + ENTER
	cQuery += "LEFT OUTER JOIN "+RetSqlName("SC9")+" SC9 WITH(NOLOCK) " + ENTER
	cQuery += "	ON SC9.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND C9_FILIAL=C5_FILIAL" + ENTER
	cQuery += "	AND C9_PEDIDO=C5_NUM" + ENTER
	cQuery += "	AND C9_NFISCAL=''" + ENTER
	cQuery += "LEFT OUTER JOIN "+RetSqlName("CB7")+" CB7 WITH(NOLOCK)" + ENTER
	cQuery += "	ON CB7.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND CB7_FILIAL=C5_FILIAL" + ENTER
	cQuery += "	AND CB7_PEDIDO=C5_NUM" + ENTER
	cQuery += "	AND CB7_ORDSEP=C9_ORDSEP" + ENTER
	If .NOT. EMPTY(MV_PAR03)
		cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH(NOLOCK)" + ENTER
		cQuery += "	ON SA3.D_E_L_E_T_ =''" + ENTER
		cQuery += "	AND A3_FILIAL = C5_FILIAL " + ENTER
		cQuery += "	AND A3_COD = C5_VEND1 " + ENTER
		cQuery += "	AND A3_GEREN='" + MV_PAR03 + "' " + ENTER
	EndIf
	cQuery += "WHERE " + ENTER
	cQuery += "	SC5.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND C5_FILIAL = '"+xFilial("SC5")+"'  " + ENTER
	cQuery += "	AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += "	AND C5_NOTA = ''" + ENTER
	If MV_PAR04=1
		cQuery += "	AND C5_FILDES = '02' " + ENTER
	ElseIf MV_PAR04=2
		cQuery += "	AND C5_FILDES = '01' " + ENTER
	EndIf
	cQuery += "	AND RTRIM(C5_XITEMC) = '" + Iif(MV_PAR05=1,"TAIFF","PROART") + "' " + ENTER
	//cQuery += "	AND C5__DTLIBF >= '" + DTOS(MV_PAR01) + "' AND C5__DTLIBF <= '" + DTOS(MV_PAR02) + "' " + ENTER
	cQuery += "  	AND C5_EMISSAO >= '20170101' " + ENTER
	If .NOT. EMPTY(MV_PAR06) 
		cQuery += "  	AND C5_NUM = '" + ALLTRIM(MV_PAR06) + "' " + ENTER
	EndIf
	If .NOT. EMPTY(MV_PAR07) 
		cQuery += "  	AND ((C5_FILDES='02' AND C5_CLIENTE='" + MV_PAR07 + "') OR (C5_FILDES='01' AND C5_CLIORI='" + MV_PAR07 + "')) " + ENTER
	EndIf
	cQuery += "GROUP BY" + ENTER
	cQuery += "	C5_NUM" + ENTER
	cQuery += "	,C5_NOMCLI" + ENTER
	cQuery += "	,C5__LIBM" + ENTER
	cQuery += "	,C5_HIST5" + ENTER
	cQuery += "	,C5__DTLIBF " + ENTER
	cQuery += "	,C5__BLOQF " + ENTER
	cQuery += "	,C5__RESERV " + ENTER
	cQuery += "	,C5_FILDES" + ENTER
	cQuery += "	,C9_ORDSEP" + ENTER
	cQuery += "	,CB7_STATUS " + ENTER
	cQuery += "	,C5_CONDPAG " + ENTER	
	cQuery += "	,C5_CLASPED " + ENTER	
	cQuery += "ORDER BY C5_NUM" + ENTER

	//MemoWrite("FATMI009_PEDIDOS_A_CONSULTAR.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), (_cAlias2 := GetNextAlias()), .F., .T.)

	tcSetField((_cAlias2),"C5__DTLIBF","D")
	
	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		CursorArrow()
		(_cAlias2)->(dbCloseArea())
		Return
	EndIf


	dbSelectArea((_cAlias2))
	ProcRegua(nRec1)
	dbGotop()
	//_cMarca	:= (_cAlias2)->C5_XITEMC

	aDados	 := {}
	While !Eof()
	
	
		IncProc("Montando os itens a serem selecionados")
	
		lNota := .F.
		aAdd(aDados,{fColor(), (_cAlias2)->C5_NUM, (_cAlias2)->C5_NOMCLI, (_cAlias2)->C5__LIBM, (_cAlias2)->C5_CLASSE, (_cAlias2)->C5_HIST5, (_cAlias2)->C5__DTLIBF, (_cAlias2)->C5_DESTINO, (_cAlias2)->CB7_STATUS})

		dbSelectArea((_cAlias2))
		dbSkip()
	End
	lNota := .F.
	CursorArrow()

	If Len(aDados) == 0
		MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		(_cAlias2)->(dbCloseArea())
		Return
	EndIf



//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0


	aTitCampos := {" ",OemToAnsi("Pedido"),OemToAnsi("Cliente"),OemToAnsi("Tipo Lib"),OemToAnsi("Classe"),OemToAnsi("Historico"),OemToAnsi("Dt.Lib.Fat."),OemToAnsi("Destino"),OemToAnsi("Expedi็ใo")}

	cLine := "{aDados[oListBox:nAT][1],aDados[oListBox:nAt,2],aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],}"

	bLine := &( "{ || " + cLine + " }" )

	@ aTFSize[7],0 To aTFSize[6],aTFSize[5] DIALOG oDlgPedidos TITLE "Situa็ใo da Libera็ใo de Pedidos em Lote"

	aCoord2 := {} //aCoord2 := {1,1,6,6,6,15,6,10,6,4,4,4,8,8,3}

	oSize := FwDefSize():New(.T.,,,oDlgPedidos)             

	oSize:AddObject('GRID'  ,100,80,.T.,.T.)
	oSize:AddObject('FOOT'  ,100,40 ,.T.,.F.)	

	oSize:lProp 		:= .T. // Proporcional             
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
	
	oSize:Process() 	   // Dispara os calculos   

	aAdd(aPosObj,{oSize:GetDimension('GRID'  , 'LININI'),oSize:GetDimension('GRID'  , 'COLINI'),oSize:GetDimension('GRID'  , 'XSIZE')-15,oSize:GetDimension('GRID'  , 'YSIZE')})
	aAdd(aPosObj,{oSize:GetDimension('FOOT'  , 'LININI'),oSize:GetDimension('FOOT'  , 'COLINI'),oSize:GetDimension('FOOT'  , 'LINEND'),oSize:GetDimension('FOOT'  , 'COLEND')})

   oListBox := TWBrowse():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || TFliberado( aDados[oListBox:nAt,2] ) } 
	oListBox:bLine := bLine


	@ aPosObj[2][1],aPosObj[2][2]+10 SAY "Ultimo processamento " + cDtProcessto OF oDlgPedidos Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[2][1],aPosObj[2][2]+430 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	@ aPosObj[2][1]+20,aPosObj[2][2]+065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2][1]+20,aPosObj[2][2]+075 SAY "Em espera" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL
	@ aPosObj[2][1]+20,aPosObj[2][2]+115 BITMAP oBmp3 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2][1]+20,aPosObj[2][2]+125 SAY "Bloqueado" OF oDlgPedidos Color CLR_RED,CLR_WHITE PIXEL
	@ aPosObj[2][1]+20,aPosObj[2][2]+215 BITMAP oBmp2 ResName "BR_AZUL" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ aPosObj[2][1]+20,aPosObj[2][2]+225 SAY "Liberado" OF oDlgPedidos Color CLR_BLUE,CLR_WHITE PIXEL

	ACTIVATE DIALOG oDlgPedidos CENTERED

	(_cAlias2)->(dbCloseArea())

	If nOpc == 1
	EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfColor    บAutor  ณC. TORRES           บ Data ณ  16/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fColor()

If EMPTY((_cAlias2)->C5__BLOQF) .AND. .NOT. EMPTY((_cAlias2)->C5__LIBM)  
	Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
ElseIf .NOT. EMPTY((_cAlias2)->C5__BLOQF)   .AND. .NOT. EMPTY((_cAlias2)->C5__LIBM)  
	Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
ElseIf  EMPTY((_cAlias2)->C5__LIBM)    
	Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณC. TORRES           บ Data ณ  16/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1( cPerg, aPerg, aHelp )
	Local aArea := GetArea()
	Local aCpoPerg := {}
	Local nX := 0
	Local nY := 0
			
// DEFINE ESTRUTUA DO ARRAY DAS PERGUNTAS COM AS PRINCIPAIS INFORMACOES
	AADD( aCpoPerg, 'X1_ORDEM' )
	AADD( aCpoPerg, 'X1_PERGUNT' )
	AADD( aCpoPerg, 'X1_PERSPA' )
	AADD( aCpoPerg, 'X1_PERENG' )
	AADD( aCpoPerg, 'X1_VARIAVL' )
	AADD( aCpoPerg, 'X1_TIPO' )
	AADD( aCpoPerg, 'X1_TAMANHO' )
	AADD( aCpoPerg, 'X1_DECIMAL' )
	AADD( aCpoPerg, 'X1_PRESEL' )
	AADD( aCpoPerg, 'X1_GSC' )
	AADD( aCpoPerg, 'X1_VALID' )
	AADD( aCpoPerg, 'X1_VAR01' )
	AADD( aCpoPerg, 'X1_DEF01' )
	AADD( aCpoPerg, 'X1_DEFSPA1' )
	AADD( aCpoPerg, 'X1_DEFENG1' )
	AADD( aCpoPerg, 'X1_CNT01' )
	AADD( aCpoPerg, 'X1_VAR02' )
	AADD( aCpoPerg, 'X1_DEF02' )
	AADD( aCpoPerg, 'X1_DEFSPA2' )
	AADD( aCpoPerg, 'X1_DEFENG2' )
	AADD( aCpoPerg, 'X1_CNT02' )
	AADD( aCpoPerg, 'X1_VAR03' )
	AADD( aCpoPerg, 'X1_DEF03' )
	AADD( aCpoPerg, 'X1_DEFSPA3' )
	AADD( aCpoPerg, 'X1_DEFENG3' )
	AADD( aCpoPerg, 'X1_CNT03' )
	AADD( aCpoPerg, 'X1_VAR04' )
	AADD( aCpoPerg, 'X1_DEF04' )
	AADD( aCpoPerg, 'X1_DEFSPA4' )
	AADD( aCpoPerg, 'X1_DEFENG4' )
	AADD( aCpoPerg, 'X1_CNT04' )
	AADD( aCpoPerg, 'X1_VAR05' )
	AADD( aCpoPerg, 'X1_DEF05' )
	AADD( aCpoPerg, 'X1_DEFSPA5' )
	AADD( aCpoPerg, 'X1_DEFENG5' )
	AADD( aCpoPerg, 'X1_CNT05' )
	AADD( aCpoPerg, 'X1_F3' )
	AADD( aCpoPerg, 'X1_PYME' )
	AADD( aCpoPerg, 'X1_GRPSXG' )
	AADD( aCpoPerg, 'X1_HELP' )
	AADD( aCpoPerg, 'X1_PICTURE' )
	AADD( aCpoPerg, 'X1_IDFIL' )

	DBSelectArea( "SX1" )
	DBSetOrder( 1 )
	For nX := 1 To Len( aPerg )
		IF !DBSeek( PADR(cPerg,10) + aPerg[nX][1] )
			RecLock( "SX1", .T. ) // Inclui
		Else
			RecLock( "SX1", .F. ) // Altera
		Endif
 // Grava informacoes dos campos da SX1
		For nY := 1 To Len( aPerg[nX] )
			If aPerg[nX][nY] <> NIL
				SX1->( &( aCpoPerg[nY] ) ) := aPerg[nX][nY]
			EndIf
		Next
		SX1->X1_GRUPO := PADR(cPerg,10)
		MsUnlock() // Libera Registro
 // Verifica se campo possui Help
		_nPosHelp := aScan(aHelp,{|x| x[1] == aPerg[nX][1]})
		IF (_nPosHelp > 0)
			cNome := "P."+TRIM(cPerg)+ aHelp[_nPosHelp][1]+"."
			PutSX1Help(cNome,aHelp[_nPosHelp][2],{},{},.T.)
		Else
 // Apaga help ja existente.
			cNome := "P."+TRIM(cPerg)+ aPerg[nX][1]+"."
			PutSX1Help(cNome,{" "},{},{},.T.)
		Endif
	Next
// Apaga perguntas nao definidas no array
	DBSEEK(cPerg,.T.)
	DO WHILE SX1->(!Eof()) .And. SX1->X1_GRUPO == cPerg
		IF ASCAN(aPerg,{|Y| Y[1] == SX1->X1_ORDEM}) == 0
			Reclock("SX1", .F.)
			SX1->(DBDELETE())
			Msunlock()
		ENDIF
		SX1->(DBSKIP())
	ENDDO
	RestArea( aArea )
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTFliberadoบAutor  ณC. TORRES           บ Data ณ  16/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra os itens do pedido e a quantidade liberada           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TFliberado(cPedLiberado)
Local lLiberado	:= .F.
Local _ACOLS		:= {}
Local _AHEADER		:= {}
LOCAL ACMPALT		:= {}
LOCAL NMAX			:= 999
LOCAL NFREEZE		:= 004
LOCAL NOPCFORM		:= 0
LOCAL ATPCLASSE	:= {{"V"},{"X"}}
LOCAL ANMCLASSE	:= {{"VENDA"},{"BONIFICAวรO"}}
LOCAL cNMClass		:= ""

PRIVATE ODLG1
PRIVATE OFNT1
PRIVATE OGTD1
PRIVATE OBTN1
PRIVATE OLBL1
PRIVATE OLBL2

/*01*/AADD(_AHEADER,{"Num. Pedido"	,"C6_NUM"		,"@!"							,06	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PEDIDO","X3_USADO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_RELACAO")})
/*02*/AADD(_AHEADER,{"Item Pedido"	,"C6_ITEM"		,"@!"							,02	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_ITMPED","X3_USADO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_RELACAO")})
/*03*/AADD(_AHEADER,{"Cod. Produto"	,"C6_PRODUTO"	,"@!"							,15	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_CODPRO","X3_USADO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_RELACAO")})
/*04*/AADD(_AHEADER,{"Desc.Produto"	,"B1_DESC"		,"@!"							,50	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_DESPRO","X3_USADO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_RELACAO")})
/*05*/AADD(_AHEADER,{"Qtd.Original"	,"C6_QTDVEN"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_QTDORI","X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_RELACAO")})
/*06*/AADD(_AHEADER,{"Vlr. Total"	,"C6_VALOR"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLTOT"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_RELACAO")})
/*07*/AADD(_AHEADER,{"Qtd.Liberada"	,"C6_QTDLIB"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_QTDLIB","X3_VALID"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_RELACAO")})
/*08*/AADD(_AHEADER,{"Vlr.Liberado"	,"C6_VLLIB"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLLIB"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_RELACAO")})
/*09*/AADD(_AHEADER,{"Perc. Atend."	,"C6_PERCAT"	,"@E 999.99"					,06	,02		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PERCAT","X3_USADO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_RELACAO")})

SB1->(DbSetOrder(1))

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + cPedLiberado))

SC6->(DbSetOrder(1))
SC6->(DbSeek( xFilial("SC6") + cPedLiberado))
While SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=cPedLiberado .AND. .NOT. SC6->(Eof())
		
	SB1->(DbSeek( xFilial("SB1") + SC6->C6_PRODUTO ))
	NTOTLIB := 0
	NVLTOTLIB := 0
	SC9->(DbSetOrder(1))
	SC9->(DbSeek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM ))
	While SC9->C9_FILIAL=xFilial("SC9") .AND. SC9->C9_PEDIDO=SC6->C6_NUM .AND. SC9->C9_ITEM=SC6->C6_ITEM .AND. .NOT. SC9->(Eof())
		If EMPTY(SC9->C9_NFISCAL) .AND. EMPTY(SC9->C9_BLEST)
			NTOTLIB += SC9->C9_QTDLIB
			NVLTOTLIB += (SC9->C9_QTDLIB * SC6->C6_PRCVEN) 
			lLiberado	:= .T.
		EndIf
		SC9->(DbSkip())
	End

	AADD(_ACOLS,ARRAY(10))
	
	_ACOLS[Len(_ACOLS),1] := SC6->C6_NUM
	_ACOLS[Len(_ACOLS),2] := SC6->C6_ITEM
	_ACOLS[Len(_ACOLS),3] := SC6->C6_PRODUTO
	_ACOLS[Len(_ACOLS),4] := SUBSTR(SB1->B1_DESC,1,50)
	_ACOLS[Len(_ACOLS),5] := SC6->C6_QTDVEN
	_ACOLS[Len(_ACOLS),6] := SC6->C6_VALOR
	_ACOLS[Len(_ACOLS),7] := NTOTLIB
	_ACOLS[Len(_ACOLS),8] := NVLTOTLIB
	_ACOLS[Len(_ACOLS),9] := ROUND( ((NVLTOTLIB / SC6->C6_VALOR) * 100) ,2)
		
	SC6->(DbSkip())
End

If .NOT. lLiberado
	MSGALERT("Nใo hแ itens liberados para este pedido!" ,"Aten็ใo")
Else

	cNMClass := "NรO IDENTIFICADA" 
	nPosClass := Ascan(ATPCLASSE,{|x| x[1] = SC5->C5_CLASPED })
	If nPosClass > 0
		cNMClass := ANMCLASSE[nPosClass,1] 
	EndIf 


	ODLG1 		:= MSDIALOG():NEW(10,10,680,990,'Itens do Pedido de Venda ' + SC5->C5_NUM,,,,,CLR_BLACK,CLR_GRAY,,,.T.)
	OFNT1		:= TFONT():NEW('CALIBRI',,-18,.T.,.T.)
	OGTD1		:= MSNEWGETDADOS():NEW(10, 10 ,300 , 480, 2,.T.,.T.,"",ACMPALT	, NFREEZE	, NMAX	,,, "ALLWAYSFALSE()"	, ODLG1, _AHEADER, _ACOLS)
	OBTN1		:= TBUTTON():NEW(305,410,'Sair',ODLG1,{|| NOPCFORM := 2,ODLG1:END()},70,10,,,,.T.)
	OLBL1 		:= TSAY():NEW(305,025, {|| "Condi็ใo de Pagto: " + ALLTRIM(POSICIONE("SE4",1,XFILIAL("SC5") + SC5->C5_CONDPAG,"E4_DESCRI"))},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL1:LTRANSPARENT:= .T.
	OLBL2 		:= TSAY():NEW(320,025, {|| "Classe de pedido: " + cNMClass },ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL2:LTRANSPARENT:= .T.
	
	ODLG1:ACTIVATE(,,,.T.)
	
	/*
	|---------------------------------------------------------------------------------
	|	Criado um looping aguardando que um dos botoes seja clicado
	|---------------------------------------------------------------------------------
	*/
	WHILE NOPCFORM = 0 	
		
	ENDDO

EndIf
Return


