#include 'protheus.ch'
#include 'parmtype.ch'

/*
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
╠?╠╠?un┤┘o    ?efCFD	?Autor ?Sergio Bruno          ?Data ?7/02/2019Ё╠?
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд
╢╠?╠╠?escri┤┘o ?Programa da Acerto de produtos pai do FCI.                 Ё╠?
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠?
╠╠?intaxe   ?RefCFD()						                              Ё╠?
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠?
╠╠?utor     ?Sergio Bruno					                              Ё╠?
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠?
╠╠?etorno   ?Nenhum                                                     Ё╠?╠╠
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠?╠╠?
Uso      ?FCIXFUN                                                    Ё╠?╠╠
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠?
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠?
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ?/*/

User Function RefCFD()
 
	Private cMesAno := ""
 	Private cAnoMes := ""
	Private cPerg	:= "RefCFD"
	Private aPerg	:= {}
	Private aHelp	:= {}
 
 	ValidPerg(cPerg)
 
 	DbSelectArea("CFD")
 	
 	CFD->(DbGoBottom())
 	CFD->(DbSkip(-1))
 	cMesAno := CFD->CFD_PERVEN
 	cAnoMes := Right(Alltrim(cMesAno),4)+Left(Alltrim(cMesAno),2)
 	CFD->(DbSetOrder(2)) //Filial+Codigo+Percal+PerVen

	If !Pergunte(cPerg,.T.)
		Return(.T.)
	Endif
	cMesAno := MV_PAR01
 	cAnoMes := Right(Alltrim(cMesAno),4)+Left(Alltrim(cMesAno),2)
	
	 
 	If !MsgYesNo("Este programa far?o ajuste de produtos tranferidos no periodo"+cMesAno+"."+CRLF;
 				+"Prosseguir?")
 		Return
 	Else  
 		Processa({|lEnd| ProcCFD()},"Processando...","Ajuste FCI",.F.)  //"Processando..."
 	EndIf
 Return	
 
 /*
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©
╠?╠╠?un┤┘o    ?rocCFD	?Autor ?Sergio Bruno          ?Data ?7/02/2019Ё╠?╠╠
цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠?
╠╠?escri┤┘o ?Processamento da Acerto de produtos pai do FCI.            Ё╠?
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠
?╠╠?intaxe   ?ProcCFD()						                          Ё╠?╠╠
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠?
╠╠?etorno   ?Nenhum                                                     Ё╠?
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
╠?╠╠?Uso      ?FCIXFUN                                                  Ё╠?
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
?ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ?/*/
 
 Static Function ProcCFD()
 
  	Local cQry := ""
 	Local cAliasCFD  	:= "ITENSCOM"
 	
	cQry:="SELECT '"+xFilial("CFD")+"' CFD_FILIAL,                                          "+CRLF
	cQry+="		ISNULL((SELECT DISTINCT CFD_PERCAL 											"+CRLF
	cQry+="						FROM "+RetSQLName("CFD") + " CFDX 							"+CRLF
	cQry+="						WHERE CFDX.CFD_PERVEN= '"+cMesAno +"'						"+CRLF
	cQry+="						AND CFDX.D_E_L_E_T_= '' 									"+CRLF
	cQry+="						AND CFDX.CFD_COD = B1_PRCOM),'"+cMesAno +"')   CFD_PERCAL, 		"+CRLF
	cQry+="		'"+cMesAno +"' CFD_PERVEN,													"+CRLF
	cQry+="     B1_PRCOM CFD_COD, 															"+CRLF
	cQry+="		'' CFD_OP,																	"+CRLF
	cQry+="		ROUND(SUM(QUANT*VLRVI)/(CASE 												"+CRLF
	cQry+="			                   WHEN SUM(QUANT) = 0 									"+CRLF
	cQry+="							   THEN 1 ELSE SUM(QUANT) 								"+CRLF
	cQry+="						   END),2) CFD_VPARIM,										"+CRLF
	cQry+="		ROUND(CASE 																	"+CRLF
	cQry+="			WHEN COUNT(*) >0 														"+CRLF
	cQry+="			THEN SUM(VSAIIE)/COUNT(*)												"+CRLF
	cQry+="			ELSE 0																	"+CRLF
	cQry+="		END ,2) CFD_VSAIE,															"+CRLF
	cQry+="		ROUND((1/(CASE 																"+CRLF
	cQry+="			WHEN (SUM(VSAIIE)/COUNT(*)) >0 											"+CRLF
	cQry+="			THEN (SUM(VSAIIE)/COUNT(*))												"+CRLF
	cQry+="			ELSE 1																	"+CRLF
	cQry+="		END))*  																	"+CRLF
	cQry+="		(SUM(QUANT*VLRVI)/(CASE 													"+CRLF
	cQry+="			                   WHEN SUM(QUANT) = 0 									"+CRLF
	cQry+="							   THEN 1 ELSE SUM(QUANT) 								"+CRLF
	cQry+="						   END))*100,2) CFD_CONIMP,									"+CRLF
	cQry+="		'' CFD_FCICOD,																"+CRLF
	cQry+="		'' CFD_FCI_OP,																"+CRLF
	cQry+="		MAX(ORIGEM) CFD_ORIGEM														"+CRLF
	cQry+="FROM																				"+CRLF
	cQry+="	(SELECT SB1.B1_PRCOM, 															"+CRLF
	cQry+="			SB1.B1_COD  COD, 														"+CRLF
	cQry+="			ISNULL(SUM(D3_QUANT),0) QUANT, 											"+CRLF
	cQry+="			ISNULL(CFD_VPARIM,0) VLRVI,												"+CRLF
	cQry+="			ISNULL(AVG(CFD_VSAIIE),0) VSAIIE, 										"+CRLF
	cQry+="			ISNULL(MAX(CFD_ORIGEM),'') ORIGEM										"+CRLF
	cQry+="	FROM "+RetSQLName("SB1") + " SB1 												"+CRLF
	cQry+="		LEFT JOIN "+RetSQLName("CFD") + " CFD										"+CRLF
	cQry+="			ON  CFD.CFD_COD = SB1.B1_COD											"+CRLF
	cQry+="			AND SB1.D_E_L_E_T_				= CFD.D_E_L_E_T_						"+CRLF
	cQry+="			AND CFD.CFD_FILIAL = '"+xFilial("CFD")+"'								"+CRLF
	cQry+="			AND CFD.CFD_PERCAL = '"+cMesAno +"' 									"+CRLF
	cQry+="		LEFT JOIN "+RetSQLName("SD3") + " SD3										"+CRLF
	cQry+="			ON  LEFT(D3_EMISSAO,6)=  '"+cAnoMes +"' 								"+CRLF
	cQry+="			AND SD3.D3_COD					= SB1.B1_COD							"+CRLF
	cQry+="			AND SD3.D_E_L_E_T_				= SB1.D_E_L_E_T_						"+CRLF
	cQry+="			AND SD3.D3_CF IN ('RE4', 'RE7','PR0')									"+CRLF
	cQry+="			AND SD3.D3_FILIAL = '"+xFilial("SD3")+"'								"+CRLF
	cQry+="	   	    AND SD3.D3_ESTORNO = ''													"+CRLF
	cQry+="	WHERE   SB1.D_E_L_E_T_ = ''														"+CRLF
	cQry+="	  AND B1_PRCOM <>''																"+CRLF
	cQry+="	  GROUP BY B1_COD, CFD_VPARIM, SB1.B1_PRCOM) VV									"+CRLF
	cQry+="	 	  WHERE QUANT >0 															"+CRLF
	cQry+="GROUP BY B1_PRCOM																"+CRLF
	cQry+="	  HAVING COUNT(*) >0 AND MAX(ORIGEM)<>''										"

	MemoWrite("Ajuste_FCI.sql",cQry)
	
	cQry:= ChangeQuery(cQry)
	
	If Select(cAliasCFD)
		(cAliasCFD)->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasCFD,.T.,.T.)

	ProcRegua((cAliasCFD)->(RecCount()))
	Do While !(cAliasCFD)->(EOF())

		INCPROC("Processando produto " + (cAliasCFD)->(CFD_COD))
		//IndRegua("Processando produto "+(cAliasCFD)->(CFD_COD))
		DbSelectArea("CFD")
		cChaveCFD 	:= xFilial("CFD");
					+(cAliasCFD)->(CFD_COD+CFD_PERCAL)+Space(TamSX3("CFD_PERCAL")[1]-Len((cAliasCFD)->CFD_PERCAL));
					+(cAliasCFD)->CFD_PERVEN

		If DbSeek(cChaveCFD)
			RecLock("CFD",.F.)
				CFD->CFD_VPARIM := (cAliasCFD)->CFD_VPARIM
				CFD->CFD_VSAIIE	:= (cAliasCFD)->CFD_VSAIE
				CFD->CFD_CONIMP	:= (cAliasCFD)->CFD_CONIMP
			MsUnLock()
		Else
			RecLock("CFD",.T.)
				CFD->CFD_FILIAL := (cAliasCFD)->CFD_FILIAL
				CFD->CFD_PERCAL := (cAliasCFD)->CFD_PERCAL				
				CFD->CFD_PERVEN := (cAliasCFD)->CFD_PERVEN	
				CFD->CFD_COD 	:= (cAliasCFD)->CFD_COD	
				CFD->CFD_OP 	:= (cAliasCFD)->CFD_OP					
				CFD->CFD_VPARIM := (cAliasCFD)->CFD_VPARIM
				CFD->CFD_VSAIIE	:= (cAliasCFD)->CFD_VSAIE
				CFD->CFD_CONIMP	:= (cAliasCFD)->CFD_CONIMP
				CFD->CFD_FCICOD	:= (cAliasCFD)->CFD_FCICOD
				//CFD->CFD_FCI_OP	:= (cAliasCFD)->CFD_FCI_OP
				CFD->CFD_ORIGEM := (cAliasCFD)->CFD_ORIGEM
			MsUnLock()
		EndIf
		DbSelectArea(cAliasCFD)
	    (cAliasCFD)->(DbSkip())
	EndDo

	(cAliasCFD)->(DbCloseArea())
	MsgInfo("AlteraГЦo feita com sucesso!")

Return 


Static Function VALIDPERG(cPerg)
	// Local cKey 		:= ""
	// Local aHelpPor	:= {}
	// Local aHelpEng	:= {}
	// Local aHelpSpa	:= {}
	//				X1_ORDEM	X1_PERGUNT					X1_PERSPA					X1_PERENG				X1_VARIAVL	X1_TIPO		X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01		X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME		X1_GRPSXG	X1_HELP		X1_PICTURE	X1_IDFIL
	AADD(aPerg,{	"01"   		,"Mes/Ano   ?"				,""                    ,""                    ,"mv_ch1"	,"C"   		,06      	,0       	,0      	, "G"	,""    		,"mv_par01"	,""			,""			,""			,""			,""      ,""      	,""    		,""	       	,""     	,""      	,""  	  	,""      	,""			,""    		,""      ,""			,""			,""      	,""			,""      	,""      	,""      	,""			,""			,""		,""			,""			,""			,"@R XX/XXXX"			,""})

	AjustaSX1( cPerg, aPerg, aHelp )
	 
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
?????????????????????????????????????????????????????????????????????????????
??иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм???
??╨Programa  ?AjustaSX1 ╨Autor  ?C. TORRES           ╨ Data ?  16/02/2018 ╨??
??лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм???
??╨Desc.     ?                                                            ╨??
??╨          ?                                                            ╨??
??лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм???
??╨Uso       ? AP                                                         ╨??
??хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм???
?????????????????????????????????????????????????????????????????????????????
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
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
