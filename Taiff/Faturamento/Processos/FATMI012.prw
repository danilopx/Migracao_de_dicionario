#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºPrograma  ?FATMI012  ºAutor  ?Carlos Torres       º Data ?  28/12/2017 º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºDesc.     ? Libera de pedido de venda abaixo do minimo                 º??
??º          ?                                                            º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºUso       ?                                                            º??
??ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FATMI012()

	Private oVeLogPed
	Private cPerg	:= "FATMI012"
	Private aPerg	:= {}
	Private aHelp	:= {}
	PRIVATE nValMinFatur	:= 0
	PRIVATE nParcelaMin	:= 0
	PRIVATE cHistSC5		:= ""

	ValidPerg(cPerg)

	@ 200,001 TO 480,380 DIALOG oVeLogPed TITLE OemToAnsi("Pedidos abaixo do minimo")
	@ 003,005 TO 085,187 PIXEL OF oVeLogPed
	@ 010,018 Say "Este programa tem a finalidade de alterar status " SIZE 150,010 PIXEL OF oVeLogPed
	@ 020,018 Say "do pedido de venda abaixo do valor minimo de venda." SIZE 150,010 PIXEL OF oVeLogPed
	@ 065,008 BUTTON "Continua  "  ACTION (Processa({||FATMI1201()}),oVeLogPed:End())PIXEL OF oVeLogPed
	@ 100,008 BMPBUTTON TYPE 02 ACTION oVeLogPed:End()

	Activate Dialog oVeLogPed Centered


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºPrograma  ?VALIDPERG ºAutor  ?Microsiga           º Data ?  11/25/08   º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºDesc.     ?                                                            º??
??º          ?                                                            º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºUso       ? AP                                                         º??
??ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDPERG(cPerg)
	//Local cKey 		:= ""
	//Local aHelpPor	:= {}
	//Local aHelpEng	:= {}
	//Local aHelpSpa	:= {}
	//				X1_ORDEM	X1_PERGUNT					X1_PERSPA					X1_PERENG				X1_VARIAVL	X1_TIPO		X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01		X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME		X1_GRPSXG	X1_HELP		X1_PICTURE	X1_IDFIL
	AADD(aPerg,{	"01"   		,"Da Emissao   ?"			,""                    ,""                    ,"mv_ch1"	,"D"   		,08      	,0       	,0      	, "G"	,""    		,"mv_par01"	,""			,""			,""			,""			,""      ,""      	,""    		,""	       	,""     	,""      	,""  	  	,""      	,""			,""    		,""      ,""			,""			,""      	,""			,""      	,""      	,""      	,""			,""			,""		,""			,""			,""			,""			,""})
	AADD(aPerg,{	"02"   		,"Ate a Data Emissao?"	,""                    ,""                    ,"mv_ch2"	,"D"   		,08      	,0       	,0      	, "G"	,""    		,"mv_par02"	,""        ,""   		,""			,""       	,""      ,""      	,""    		,""    		,""	    	,""      	,""    	  	,""      	,""			,""			,""      ,""     		,""    		,""      	,""      	,""      	,""    	  	,""      	,""			,""			,""		,""			,""			,""			,""			,""})
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³FATMI0901 ºAutor  ³Microsiga           º Data ³  16/02/2018 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FATMI1201

	//Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	//Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	//Local oDlg,oListBox,cListBox
	//Local lContinua := .T.
	Local nOpc		:= 0
	//Local nF4For
	//Local oBmp1, oBmp2, oBmp3, oBmp4,oBmp5, oBmp6, oBmp7, oBmp8,oBmp9,oBmp10
	//Local lCampos 	:= .F.
	//Local lCtis		:= .F.
	//Local 	aPedidos:= {}
	//Local aSx1area  		:= SX1->(Getarea())
	Local cDtProcessto := CTOD("  /  /  ")
	Local aTFSize := {}
	Local aPosObj := {}
	Local _cFinUsers	:= GetNewPar( "MV__FINIDU", "001291|000348" )

	Private aDados	:= {}
	Private oDlgPedidos
	Private cBloqI
	Private _cAlias2	:= ""
	Private _nPerTt	:= GetNewPar( "MV__FINPERL", 80 ) 
	
	If .NOT. Alltrim(__CUSERID) $ _cFinUsers
		MsgStop("Usu�rio N�o tem direito de acesso a altera��o de status do pedido!"+chr(13)+"Regra atribuida no parametro MV__FINIDU","Aten��o")
		Return(.T.)
	EndIf
	
	If SC5->(FIELDPOS("C5__DTLIBF")) = 0 .OR. .NOT. (CEMPANT="03" .AND. CFILANT="02")
		MsgStop("A consulta N�o est� disponivel nesta empresa/filial!","Aten��o")
		Return(.T.)
	EndIf

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif

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
	cQuery += "	AND C5__BLOQF = 'V'" + ENTER
	cQuery += "	AND C5_CLASPED = 'V'" + ENTER
	
	If MV_PAR04=1
		cQuery += "	AND C5_FILDES = '02' " + ENTER
	ElseIf MV_PAR04=2
		cQuery += "	AND C5_FILDES = '01' " + ENTER
	EndIf
	cQuery += "	AND RTRIM(C5_XITEMC) = '" + Iif(MV_PAR05=1,"TAIFF","PROART") + "' " + ENTER
	//cQuery += "	AND C5__DTLIBF >= '" + DTOS(MV_PAR01) + "' AND C5__DTLIBF <= '" + DTOS(MV_PAR02) + "' " + ENTER
	IF .NOT. EMPTY(MV_PAR01) .AND. .NOT. EMPTY(MV_PAR02)  
		cQuery += "	AND C5_EMISSAO >= '" + DTOS(MV_PAR01) + "' AND C5_EMISSAO <= '" + DTOS(MV_PAR02) + "' " + ENTER
	EndIf
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

	//MemoWrite("FATMI012_PEDIDOS_A_CONSULTAR.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), (_cAlias2 := GetNextAlias()), .F., .T.)

	tcSetField((_cAlias2),"C5__DTLIBF","D")
	
	Count To nRec1

	If nRec1 == 0
		MsgStop("N�o existem pedidos a apresentar com os par�metros informados!","Aten��o")
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

		lCretido :=  TFVeliberado((_cAlias2)->C5_NUM)

		IF MV_PAR05=1 // TAIFF
			cHistSC5 := (_cAlias2)->C5_HIST5
		ENDIF
		
		If lCretido 
			lNota := .F.
			aAdd(aDados,{fColor(), (_cAlias2)->C5_NUM, (_cAlias2)->C5_NOMCLI, (_cAlias2)->C5__LIBM, (_cAlias2)->C5_CLASSE, cHistSC5, (_cAlias2)->C5_DESTINO} )
		EndIf
		
		dbSelectArea((_cAlias2))
		dbSkip()
	End
	lNota := .F.
	CursorArrow()

	If Len(aDados) == 0
		MsgStop("N�o existem pedidos a apresentar com os par�metros informados!","Aten��o")
		(_cAlias2)->(dbCloseArea())
		Return
	EndIf



//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0


	aTitCampos := {" ",OemToAnsi("Pedido"),OemToAnsi("Cliente"),OemToAnsi("Tipo Lib"),OemToAnsi("Classe"),OemToAnsi("Historico"),OemToAnsi("Destino")}

	cLine := "{aDados[oListBox:nAT][1],aDados[oListBox:nAt,2],aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],}"

	bLine := &( "{ || " + cLine + " }" )

	@ aTFSize[7],0 To aTFSize[6],aTFSize[5] DIALOG oDlgPedidos TITLE "Situa��o da Libera��o de Pedidos em Lote"

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
	oListBox:bLDblClick := { || TFliberado( aDados[oListBox:nAt,2],@oListBox ) } 
	oListBox:bLine := bLine


	@ aPosObj[2][1],aPosObj[2][2]+10 SAY "Ultimo processamento " + cDtProcessto OF oDlgPedidos Color CLR_BLACK,CLR_WHITE PIXEL
	@ aPosObj[2][1],aPosObj[2][2]+430 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos
	If MV_PAR05 = 2
		//@ aPosObj[2][1],aPosObj[2][2]+330 BUTTON "Calc. Embal."       	SIZE 40,15 ACTION {nOpc :=0,TFcalcEmbal(aDados[oListBox:nAt,2])} PIXEL OF oDlgPedidos
	EndIf

	//@ aPosObj[2][1]+20,aPosObj[2][2]+065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	//@ aPosObj[2][1]+20,aPosObj[2][2]+075 SAY "Em espera" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºPrograma  ?fColor    ºAutor  ?C. TORRES           º Data ?  16/02/2018 º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºDesc.     ?                                                            º??
??º          ?                                                            º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºUso       ? AP                                                         º??
??ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fColor()

If (_cAlias2)->C5__LIBM=="R"    
	Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
ElseIf EMPTY((_cAlias2)->C5__BLOQF) .OR. (_cAlias2)->C5__BLOQF = "V"  
	Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºPrograma  ?AjustaSX1 ºAutor  ?C. TORRES           º Data ?  16/02/2018 º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºDesc.     ?                                                            º??
??º          ?                                                            º??
??ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
??ºUso       ? AP                                                         º??
??ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³TFliberadoºAutor  ³C. TORRES           º Data ³  16/02/2018 º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Mostra os itens do pedido e a quantidade liberada           º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TFliberado(cPedLiberado,oListBox)
Local lLiberado	:= .F.
Local _ACOLS		:= {}
Local _AHEADER	:= {}
LOCAL ACMPALT		:= {}
LOCAL NMAX			:= 999 - 100
LOCAL NFREEZE		:= 004
LOCAL NOPCFORM	:= 0
LOCAL ATPCLASSE	:= {{"V"},{"X"}}
LOCAL ANMCLASSE	:= {{"VENDA"},{"BONIFICA��O"}}
LOCAL cNMClass	:= ""
LOCAL NSLDLIB		:= 0
LOCAL NTTALIBERAR	:= 0
LOCAL ACONDPAG	:= {}
LOCAL cMens1		:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionada                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA440",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transfere locais para a liberacao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lTransf:=MV_PAR01==1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Libera Parcial pedidos de vendas                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lLiber :=MV_PAR02==1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sugere quantidade liberada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lSugere:=MV_PAR03==1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa tecla F12 para alterar parametro                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey(VK_F12,{||Pergunte("MTA440",.T.),;
	lTransf:=MV_PAR01==1,;
	lLiber :=MV_PAR02==1,;
	lSugere:=MV_PAR03==1})
	
PRIVATE ODLG1
PRIVATE OFNT1
PRIVATE OGTD1
PRIVATE OBTN1
PRIVATE OBTN2
PRIVATE OLBL1
PRIVATE OLBL2
PRIVATE OLBL3

/*01*/AADD(_AHEADER,{"Num. Pedido"	,"C6_NUM"		,"@!"							,06	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PEDIDO","X3_USADO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PEDIDO"	,"X3_RELACAO")})
/*02*/AADD(_AHEADER,{"Item Pedido"	,"C6_ITEM"		,"@!"							,02	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_ITMPED","X3_USADO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_ITMPED"	,"X3_RELACAO")})
/*03*/AADD(_AHEADER,{"Cod. Produto","C6_PRODUTO"	,"@!"							,15	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_CODPRO","X3_USADO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_CODPRO"	,"X3_RELACAO")})
/*04*/AADD(_AHEADER,{"Desc.Produto","B1_DESC"		,"@!"							,50	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_DESPRO","X3_USADO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_DESPRO"	,"X3_RELACAO")})
/*05*/AADD(_AHEADER,{"Qtd.Original","C6_QTDVEN"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_QTDORI","X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDORI"	,"X3_RELACAO")})
/*06*/AADD(_AHEADER,{"Vlr. Total"	,"C6_VALOR"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLTOT"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLTOT"	,"X3_RELACAO")})
/*07*/AADD(_AHEADER,{"Qtd.Liberada","C6_QTDLIB"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_QTDLIB","X3_VALID"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_QTDLIB"	,"X3_RELACAO")})
/*08*/AADD(_AHEADER,{"Vlr.Liberado","C6_VLLIB"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_USADO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_VLLIB"		,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_VLLIB"	,"X3_RELACAO")})
/*09*/AADD(_AHEADER,{"Em estoque"	,"C6_QTDLIB"	,"@E 99,999,999,999.999"		,15	,03		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZC7_PERCAT","X3_USADO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_F3"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZC7_PERCAT"	,"X3_RELACAO")})

SB1->(DbSetOrder(1))

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + cPedLiberado))

SC6->(DbSetOrder(1))
SC6->(DbSeek( xFilial("SC6") + cPedLiberado))
While SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=cPedLiberado .AND. .NOT. SC6->(Eof())
		
	NTOTLIB := SC6->C6_QTDVEN - SC6->C6_QTDENT 
	If SC6->C6_BLQ != "R" .AND. NTOTLIB>0 

		SB1->(DbSeek( xFilial("SB1") + SC6->C6_PRODUTO ))
	
		NTOTLIB := SC6->C6_QTDVEN - SC6->C6_QTDENT 
		NVLTOTLIB := (NTOTLIB * SC6->C6_PRCVEN) 
		DBSELECTAREA("SB2")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB2") + SC6->C6_PRODUTO + "21")
		
		NSLDLIB := SALDOSB2()
		
		IF NSLDLIB = 0 .OR. (NTOTLIB > NSLDLIB)
			NTOTLIB := 0 
			NVLTOTLIB := 0 
		EndIf 
		
		NVLTOTLIB := (NTOTLIB * SC6->C6_PRCVEN) 
	
		AADD(_ACOLS,ARRAY(10))
		
		_ACOLS[Len(_ACOLS),1] := SC6->C6_NUM
		_ACOLS[Len(_ACOLS),2] := SC6->C6_ITEM
		_ACOLS[Len(_ACOLS),3] := SC6->C6_PRODUTO
		_ACOLS[Len(_ACOLS),4] := SUBSTR(SB1->B1_DESC,1,50)
		_ACOLS[Len(_ACOLS),5] := SC6->C6_QTDVEN 
		_ACOLS[Len(_ACOLS),6] := SC6->C6_VALOR
		_ACOLS[Len(_ACOLS),7] := NTOTLIB
		_ACOLS[Len(_ACOLS),8] := NVLTOTLIB
		_ACOLS[Len(_ACOLS),9] := NSLDLIB

		NTTALIBERAR += NVLTOTLIB
		
		lLiberado := .T.
		
	EndIf		
	SC6->(DbSkip())
End

If .NOT. lLiberado
	MSGALERT("N�o h� itens pendentes para este pedido!" ,"Aten��o")
Else
	IF NTTALIBERAR>0	
		ACONDPAG 	:= CONDICAO(NTTALIBERAR,SC5->C5_CONDPAG)
	
	
		/* VALIDA AS REGRAS DE FATURAMENTO MINIMO */
		lOkMinimo := TFVldMinimo(NTTALIBERAR,ACONDPAG[1,2]) 
	ENDIF
	
	cNMClass := "N�o IDENTIFICADA" 
	nPosClass := Ascan(ATPCLASSE,{|x| x[1] = SC5->C5_CLASPED })
	If nPosClass > 0
		cNMClass := ANMCLASSE[nPosClass,1] 
	EndIf 

	cMens1 := "Valor m��nimo R$ " + ALLTRIM(TRANSFORM(nValMinFatur,"@E 999,999,999.99"))
	cMens1 += SPAC(02)
	cMens1 += "Total liberado R$ " + ALLTRIM(TRANSFORM(NTTALIBERAR,"@E 999,999,999.99"))
	
	cMens2	:= "Parcela m��nimo R$ " + ALLTRIM(TRANSFORM(nParcelaMin,"@E 999,999,999.99"))
	cMens2 += SPAC(02)
	IF NTTALIBERAR>0	
		cMens2 += "Parcela liberada R$ " + ALLTRIM(TRANSFORM(ACONDPAG[1,2],"@E 999,999,999.99"))
	ENDIF
		
	If NTTALIBERAR  <  (nValMinFatur * (_nPerTt/100) )
		cMens1 += " abaixo dos " + ALLTRIM(STR(_nPerTt)) + "% "
	EndIf
	
	ODLG1 		:= MSDIALOG():NEW(10,10,680 - 100,990,'Itens do Pedido de Venda ' + SC5->C5_NUM,,,,,CLR_BLACK,CLR_GRAY,,,.T.)
	OFNT1		:= TFONT():NEW('CALIBRI',,-18,.T.,.T.)
	OGTD1		:= MSNEWGETDADOS():NEW(10, 10 ,280  - 100, 480, 2,.T.,.T.,"",ACMPALT	, NFREEZE	, NMAX	,,, "ALLWAYSFALSE()"	, ODLG1, _AHEADER, _ACOLS)
	OBTN1		:= TBUTTON():NEW(305 - 100,410,'Sair',ODLG1,{|| NOPCFORM := 2,ODLG1:END()},70,10,,,,.T.)
	OBTN2		:= TBUTTON():NEW(305 - 100,340,'Liberar',ODLG1,{|| NOPCFORM := 3,ODLG1:END()},70,10,,,,.T.)

	If NTTALIBERAR  <  (nValMinFatur * 0.8)
		OBTN2:Hide()
	Else
		OBTN2:Show()	
	EndIf
	OLBL1 		:= TSAY():NEW(285 - 100,025, {|| "Condi��o de Pagto: " + ALLTRIM(POSICIONE("SE4",1,XFILIAL("SC5") + SC5->C5_CONDPAG,"E4_DESCRI"))},ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL1:LTRANSPARENT:= .T.

	OLBL1 		:= TSAY():NEW(305 - 100,025, {|| cMens2 },ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL1:LTRANSPARENT:= .T.

	OLBL2 		:= TSAY():NEW(320 - 100,025, {|| cMens1 },ODLG1,, OFNT1,,,, .T., CLR_BLUE,CLR_WHITE )
	OLBL2:LTRANSPARENT:= .T.
	
	ODLG1:ACTIVATE(,,,.T.)
	
	/*
	|---------------------------------------------------------------------------------
	|	Criado um looping aguardando que um dos botoes seja clicado
	|---------------------------------------------------------------------------------
	*/
	WHILE NOPCFORM = 0 	
		
	ENDDO
	WHILE NOPCFORM = 3 	
		IF msgYesNo("Confirma a libera��o de faturamento do pedido " + cPedLiberado + " ?")
			If U_TFA440LibM(cPedLiberado,_ACOLS)
				oListBox:AARRAY[oListBox:nAt][1]:=LoadBitMap(GetResources(),"BR_AZUL"   )
			Endif		
			NOPCFORM := 0	
		Else
			NOPCFORM := 0
		ENDIF
	ENDDO

EndIf
SetKey(VK_F12,)
Return


/***************************************************************************/
/***************************************************************************/
/* Valida parcela minima e valor minimo do pedido                          */
/***************************************************************************/
/***************************************************************************/
Static Function TFVldMinimo( NVLTOTLIB, NVLPARCELA1 )
Local lRetorno 	:= .T.
Local cIdCliente	:= IIF( SC5->C5_FILDES = CFILANT, SC5->C5_CLIENTE, SC5->C5_CLIORI)
Local cIdLoja 		:= IIF( SC5->C5_FILDES = CFILANT, SC5->C5_LOJACLI, SC5->C5_LOJORI)

//** Somente os pedidos do tipo venda passam por analise de valor minimo as bonificações ficam de fora. ***//
If SC5->C5_CLASPED = "V" 
	If SC5->(FIELDPOS("C5__DTLIBF")) > 0 // Indica que os parametros da libera��o em lote est� ativo 
		/*
		Busca regras do cliente
		*/
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1") + cIdCliente + cIdLoja	))
		
		nValMinFatur	:= 0
		nParcelaMin	:= 0
		ZAV->(DbSetOrder(1))
		If ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) + SA1->A1_COD_MUN ))
			nValMinFatur	:= ZAV->ZAV_VALMIN
			nParcelaMin	:= ZAV->ZAV_PARCEL
		ElseIf ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) ))
			nValMinFatur	:= ZAV->ZAV_VALMIN
			nParcelaMin	:= ZAV->ZAV_PARCEL
		EndIf
		
		If nParcelaMin > 0 .AND. NVLTOTLIB > 0 
			If NVLPARCELA1 < nParcelaMin 
				lRetorno 	:= .F.
			EndIf 
		EndIf  		
		
		/* Valor do liberado N�o atende o valor minino de faturamento para a UF */
		If nValMinFatur > 0 .AND. NVLTOTLIB > 0  
			If NVLTOTLIB < nValMinFatur 
				lRetorno 	:= .F.
			EndIf
		EndIf
	EndIf  		
EndIf
Return (lRetorno)						

/***************************************************************************/
/***************************************************************************/
/* Consulta base de libera��o de pedido                                    */
/***************************************************************************/
/***************************************************************************/
Static Function TFVeliberado(cPedLiberado)
LOCAL NTOTLIB		:= 0
LOCAL NTTALIBERAR	:= 0
LOCAL ACONDPAG	:= {}
LOCAL LRETORNO	:= .T.
LOCAL NREALDISPO := 0
LOCAL NITECOMSALDO := 0
LOCAL NITESEMSALDO := 0

cHistSC5 := ""

SB2->(DbSetOrder(1))

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + cPedLiberado))

SC6->(DbSetOrder(1))
SC6->(DbSeek( xFilial("SC6") + cPedLiberado))
While SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=cPedLiberado .AND. .NOT. SC6->(Eof())
	
	SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
	NREALDISPO	:= SaldoMov()
	
	NTOTLIB := SC6->C6_QTDVEN - SC6->C6_QTDENT 
	If SC6->C6_BLQ != "R" .AND. NTOTLIB>0 

		NTTALIBERAR += (NTOTLIB * SC6->C6_PRCVEN) 
	
		NITECOMSALDO += IIF( NREALDISPO = 0,0,1)
		NITESEMSALDO += IIF( NREALDISPO = 0,1,0)
	
	EndIf		
	SC6->(DbSkip())
End

IF NTTALIBERAR>0	
	ACONDPAG 	:= CONDICAO(NTTALIBERAR,SC5->C5_CONDPAG)


	/* VALIDA AS REGRAS DE FATURAMENTO MINIMO */
	lOkMinimo := TFVldMinimo(NTTALIBERAR,ACONDPAG[1,2]) 
	cHistSC5 := "Bloqueado, valor a liberar " + ALLTRIM(STR(NTTALIBERAR)) + " abaixo do minino " + ALLTRIM(STR(nValMinFatur))
ENDIF
If NTTALIBERAR  <  (nValMinFatur * (_nPerTt/100) ) 
	// Abaixo do minimo N�o apresenta
	LRETORNO	:= .F.
ELSE
	// ACIMA DO MINIMO 
	IF NITECOMSALDO = 0 .AND. NITESEMSALDO != 0  
		// UM DOS ITENS DO PEDIDO A LIBERAR APRESENTOU SALDO ZERO
		LRETORNO	:= .F.
	ENDIF
EndIf
RETURN (LRETORNO)



User Function TFA440LibM(cPedLiberado,_ALibCOLS)
Local _aLibArea	:= GetArea()
//Local cAlias 	:= "SC5"
//Local nReg   	:= SC5->(Recno())
//Local nOpc 	 	:= 4 
Local lRet		:= .F.
LOCAL NLOOP		:= 0
LOCAL LIBEROK	:= .F.

lCredito	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
lEstoque	:= .T.
lLiber	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
lTransf	:= .F.
If GetMv("MV_ESTNEG") == "S"
	lAvEst:= .f.
Else
	lAvEst:= .t.
Endif                        
lWeb := .T.

If SC5->C5_NUM == cPedLiberado .and. SC5->C5__LIBM = "R"
	MSGALERT("Pedido j� est� com status Liberado!" ,"Pedido Liberado")
	lRet := .T.
ElseIf SC5->C5_NUM == cPedLiberado 
	//A440Libera(cAlias,nReg,nOpc)
	LIBEROK	:= .F.
	FOR NLOOP := 1 TO LEN(_ALibCOLS)
		If SC6->(DbSeek(xFilial("SC6") + cPedLiberado + _ALibCOLS[NLOOP,2] + _ALibCOLS[NLOOP,3]  )) .AND. _ALibCOLS[NLOOP,7] > 0
			//nQtdLib := MaLibDoFat(SC6->(RecNo()),_ALibCOLS[NLOOP,7],@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)
			nQtdLib := _ALibCOLS[NLOOP,7]
			nQtdLib := MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.T.,.F.,.T.,.T.,.F.)
			
			If nQtdLib > 0
				LIBEROK := .T.
				aSaldos := {}
				a450Grava(1,.F.,.T.,Nil,,.T.)
				If SC9->(RecLock("SC9",.F.))
					SC9->C9_BLINF := "FATMI012-" + Upper(Rtrim(CUSERNAME)) +" "+DTOC(dDatabase)+" "+Time()
					SC9->(MsUnlock())
				EndIf
			EndIf
		EndIf
	NEXT

	MaLiberOk({ SC5->C5_NUM },.F.)

	If LIBEROK .And. Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) //SC5->C5__BLOQF == 'V'
		IF SC5->(RecLock("SC5",.F.))
			SC5->C5__BLOQF		:= ""
			SC5->C5__LIBM		:= "R"
			SC5->C5__DTLIBF	:= dDatabase
			SC5->C5_ULIB5		:= Upper(Rtrim(Substr(cusuario,7,15)))
			SC5->C5_DLIB5		:= dDatabase
			SC5->C5_HLIB5		:= Left(Time(),5)
			SC5->C5_PLIB5		:= "FATMI012"
		Endif
		SC5->(MsUnLock())
			
		MSGALERT("Pedido Liberado com sucesso!" ,"Pedido Liberado")
		lRet := .T.
	Else
		lRet := .T.
		ShowHelpDlg("TFA440PROC.03",;
			{	"Aten��o! N�o foi possivel utilizar",;
				"a Libera��o Manual.               ",;
				"Para liberar esse Pedido utilize  "},5,;
			{	"a rotina padrão de libera��o.     "},5)	
	Endif
Else
	ShowHelpDlg("TFA440PROC.04",;
		{	"Aten��o! Pedido em uso por outro  ",;
			"usuario.                          ",;
			"Tente novamente em instantes.     "},5,;
		{	"                                  "},5)	
Endif
RestArea(_aLibArea)
Return(lRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Funcao    ?a440Proces? Rev.  ?Eduardo Riera          ? Data ?24.03.99  ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ?Processamento da Liberacao automatica de Pedidos de Venda   ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Retorno   ?Nenhum                                                      ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Parametros?ExpC1: Alias                                                ???
???          ?ExpN2: Recno                                                ???
???          ?ExpN3: Opcao                                                ???
???          ?ExpL4: Flag de encerramento por solicitacao do usuario      ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???   DATA   ? Programador   ?Manutencao Efetuada                         ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???          ?               ?                                            ???
??ÀÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function a440Proc(cAlias,nReg,nOpc,lEnd)

Local aArea     := GetArea()
Local aAreaSX1  := SX1->(GetArea())
Local aRegistros:= {}
Local cQuery    := ""
Local cAliasSC6 := "SC6"
Local cPedido   := ""
Local cIndSC6   := CriaTrab(,.F.)
Local cFiltro   := ""
Local cMensagem := RetTitle("C6_NUM")
Local nFolga    := GetMV("MV_FOLGAPV")
//Local nIndex    := 0
Local nQtdLib   := 0
Local lMt440Fil := ExistBlock("MT440FIL")
Local lMt440Lib := ExistBlock("MT440LIB")
Local lMta410TT := ExistTemplate("MTA410T")
Local lMta410T  := ExistBlock("MTA410T")
Local lFiltro   := .F.
Local lValido   := .T.
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local lPerg 	 := .F.

Private nValItPed	:= 0

If !Empty(SC5->(dbFilter()))
	SC5->(dbClearFilter())
	lFiltro := .T.
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? mv_par01 Ordem Processmento ?  Ped.+Item /Dt.Entrega+Ped.+Item         ?
//? mv_par02 Pedido de          ?                                          ?
//? mv_par03 Pedido ate         ?                                          ?
//? mv_par04 Cliente de         ?                                          ?
//? mv_par05 Cliente ate        ?                                          ?
//? mv_par06 Dta Entrega de     ?                                          ?
//? mv_par07 Dta Entrega ate    ?                                          ?
//? mv_par08 Liberar            ? Credito/Estoque Credito                  ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Aqui e montada a query de trabalho.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("MT440VLD")
	lValido := ExecBlock("MT440VLD",.F.,.F.)
EndIf
If lValido

	dbSelectArea("SX1")
	dbSetOrder(1)
	If dbSeek(PADR("MTALIB",nTamSX1)+"09")        
     lPerg := .T.
    Endif 

	
	ProcRegua(SC6->(LastRec()))
	If ( MV_PAR01 == 2 )
		dbSelectArea("SC6")
		dbSetOrder(3)
	Else
		dbSelectArea("SC6")
		dbSetOrder(1)
	EndIf
	cAliasSC6 := "QUERYSC6"
	cQuery := "SELECT SC6.R_E_C_N_O_ C6RECNO,SC5.R_E_C_N_O_ C5RECNO,"
	cQuery += "SC6.C6_FILIAL,SC6.C6_NUM,SC6.C6_ITEM,SC6.C6_QTDVEN,SC6.C6_QTDEMP,SC6.C6_QTDENT,"
	cQuery += "SC6.C6_ENTREG,SC6.C6_BLQ,SC6.C6_BLOQUEI,SC6.C6_LOJA "
	cQuery += " FROM "+RetSqlName("SC6")+" SC6,"
	cQuery += RetSqlName("SC5")+" SC5 "
	cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial('SC6')+"' AND "
	cQuery += " SC6.C6_NUM >='"+MV_PAR02+"' AND "
	cQuery += " SC6.C6_NUM <='"+MV_PAR03+"' AND "
	cQuery += " SC6.C6_CLI >='"+MV_PAR04+"' AND "
	cQuery += " SC6.C6_CLI <='"+MV_PAR05+"' AND "         
	If lPerg
		cQuery += "SC6.C6_LOJA >='"+MV_PAR09+"' AND "
		cQuery += "SC6.C6_LOJA <='"+MV_PAR10+"' AND "
	Endif
	cQuery += " SC6.C6_ENTREG >='"+Dtos(MV_PAR06)+"' AND "
	cQuery += " SC6.C6_ENTREG <='"+Dtos(MV_PAR07)+"' AND "
	cQuery += " SC6.C6_ENTREG < '"+Dtos(dDataBase+nFolga)+"' AND "
	cQuery += " SC6.C6_BLQ NOT IN ('S ','R ') AND "
	cQuery += " (SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
	cQuery += " SC6.D_E_L_E_T_ = ' ' AND "
	cQuery += " SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
	cQuery += " SC5.C5_NUM=SC6.C6_NUM AND "
	cQuery += " SC5.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY "+SqlOrder(SC6->(IndexKey()))
	cQuery := ChangeQuery(cQuery)

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cAliasSC6, .F., .T.)

	TcSetField(cAliasSC6,"C6_ENTREG","D",8,0)
	dbSelectArea(cAliasSC6)
	While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6")
	
		cPedido    := (cAliasSC6)->C6_NUM
		aRegistros := {}
	
		While !Eof() .And. (cAliasSC6)->C6_FILIAL == xFilial("SC6") .And.;
				(cAliasSC6)->C6_NUM == cPedido
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o item esta bloqueado e dentro do prazo de entrega          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !AllTrim((cAliasSC6)->C6_BLQ) $ "SR" .And. (cAliasSC6)->C6_ENTREG <= (dDataBase + nFolga) .And. Empty((cAliasSC6)->C6_BLOQUEI)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula a Quantidade Liberada                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nQtdLib := ( (cAliasSC6)->C6_QTDVEN - ( (cAliasSC6)->C6_QTDEMP + (cAliasSC6)->C6_QTDENT ) )
				If lMt440Lib
					SC6->(MsGoto((cAliasSC6)->C6RECNO))
					nQtdLib := ExecBlock("MT440LIB",.F.,.F.,nQtdLib)
				EndIf
				If lMt440Fil
					SC6->(MsGoto((cAliasSC6)->C6RECNO))
					cFiltro := ExecBlock("MT440FIL",.F.,.F.)
				EndIf
				If nQtdLib > 0 .And. (Empty(cFiltro) .Or. &cFiltro)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posiciona o Pedido de Venda                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("SC5")
					MsGoto((cAliasSC6)->C5RECNO)
					
					//-- Valida��o referente ao contrato em aprova��o
					If !CN300CAprv(SC5->C5_MDCONTR, .F.)
						Help('',1,'CNTA300APR',,"O pedido " + AllTrim(cPedido) + " N�o poder� ser liberado pois o contrato que o originou encontra-se em processo de revisão, fazendo-se necess�ria sua aprova��o ou cancelamento para realiza��o deste procedimento",4)											
					Else 
					
						If RecLock("SC5")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Posiciona item do pedido de venda                                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
							SC6->(MsGoto((cAliasSC6)->C6RECNO))
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6") //Forca a atualizacao do Buffer no Top
							nQtdLib := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )
							If lMt440Lib
								nQtdLib := ExecBlock("MT440LIB",.F.,.F.,nQtdLib)
							EndIf
							If nQtdLib > 0
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o tipo de Liberacao                                            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ( SC5->C5_TIPLIB == "1" )
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Libera por Item de Pedido                                               ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									Begin Transaction
										MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,MV_PAR08==1,lLiber,lTransf)
									End Transaction
								Else
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Libera por Pedido                                                       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
									Begin Transaction
										RecLock("SC6")
										SC6->C6_QTDLIB := nQtdLib
										MsUnLock()
										aadd(aRegistros,SC6->(RecNo()))
									End Transaction
								EndIf
							EndIf
							SC6->(MsUnLock())
							EndIf
						EndIf
					EndIf						
				EndIf
									
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Move o cursor dos itens do pedido                                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				IncProc(cMensagem+"..:"+(cAliasSC6)->C6_NUM+"/"+(cAliasSC6)->C6_ITEM)
				dbSelectArea(cAliasSC6)
				dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Libera por Total de Pedido                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( Len(aRegistros) > 0 )
			Begin Transaction
				SC6->(MaAvLibPed(cPedido,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,MV_PAR08==1))
			End Transaction
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Flag do Pedido de Venda                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
			SC6->(MaLiberOk({cPedido},.F.))
		End Transaction
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pontos de entrada para todos os itens do pedido.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( lMta410TT )
			ExecTemplate("MTA410T",.F.,.F.)
		EndIf
	    
		If nModulo == 72
			KEXF920()
		EndIf
		
		If ( lMta410T )
			ExecBlock("MTA410T",.F.,.F.)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle de cancelamento por solicitacao do usuario                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasSC6)
		If lEnd
			Exit
		EndIf
	EndDo

	// Integrado ao wms devera avaliar as regras para convoca��o do serviço
	// e disponibilizar os registros de atividades do WMS para convoca��o
	If IntWms()
		WmsAvalExe()
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura as condicoes de entrada                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
EndIf
dbSelectArea(cAliasSC6)
dbCloseArea()
Ferase(cIndSC6+OrdBagExt())
dbSelectArea("SC6")

If Type("bFiltraBrw") == "B" .And. lFiltro
	Eval(bFiltraBrw)	
Endif	

RestArea(aAreaSX1)
RestArea(aArea)

Return(.T.)
