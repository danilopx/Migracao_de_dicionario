#INCLUDE "Protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMMI007  บ Autor ณ Paulo Bindo        บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ gera pre nota de entrada importando do pedido de compras   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function COMMI001()
	Local aTotItens := {}
	Local aCab 		:= {}
	Local aItens 	:= {}
	//Local cFilOld   := cFilAnt
	Local mnpar01Old:= mv_par01
	Local mnpar02Old:= mv_par02
	Local mnpar03Old:= mv_par03
	//Local mnpar04Old:= mv_par04
	//Local mnpar05Old:= mv_par05

	Private cPerg   := "COMI01"

	ValidPerg(cPerg)

	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	cNPedido	:= mv_par01
	cNEspecie  	:= mv_par02
	dNEmissao 	:= mv_par03


	cQuery := " SELECT * FROM "+RetsQlName("SC7")+" C7"
	cQuery += " WHERE C7_FILIAL = '"+cFilAnt+"' AND C7_NUM = '"+cNPedido+"'"
	cQuery += " AND D_E_L_E_T_ <> '*' AND C7_CONAPRO IN ('L','')
	cQuery += " AND C7__NUMDOC <> '' AND C7_RESIDUO = '' AND C7_QUANT > C7_QUJE"
	cQuery += " ORDER BY C7__NUMDOC"

	MemoWrite("COMMI001.sql",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB1", .F., .T.)

	TcSetField("TRB1","C7_EMISSAO","D")
	TcSetField("TRB1","C7_DATRF","D")

	COUNT TO nRecCount
	//CASO NAO TENHA DADOS
	If nRecCount == 0
		MsgStop("Pedido ce compras nใo encontradO!","COMMI001")

		mv_par01 := mnpar01Old
		mv_par02 := mnpar02Old
		mv_par03 := mnpar03Old
		/*
		mv_par04 := mnpar04Old
		mv_par05 := mnpar05Old
		*/

		TRB1->(dbCloseArea())
		Return
	Else

		dbSelectArea("TRB1")
		dbGoTop()
		cNumDoc := TRB1->C7__NUMDOC
		cItem		:= "0001"
		While !Eof()
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek(xFilial()+TRB1->C7_FORNECE)	



			//caso seja a primeira vez carrega o cabecalho
			If Len(aCab) == 0 .Or. cNumDoc # TRB1->C7__NUMDOC
				
				If  Len(aCab) > 0
					lMsErroAuto := .f.

					MSExecAuto( {|x,y,z,w|MATA140( x, y, z, w ) }, aCab, aTotItens, 3, .F. )

					If lMsErroAuto
						Mostraerro()
					Else
						MsgInfo("Nota Fiscal "+cNumDoc+" gerada com Sucesso!")
					EndIf
					aCab 		:= {}

				EndIf

				If Len(aCab)==0
								// Campos e seus conteudos a serem gravados na tabela SF1
					cItem		:= "0001"
					aTotItens	:= {}
					aItens 	:= {}					

				EndIf

				aCab := {	{"F1_TIPO"   ,"N"        ,NIL},;
				{"F1_FORMUL" ,"N"        		,NIL},;
				{"F1_EMISSAO",dNEmissao			,NIL},;
				{"F1_DTDIGIT",dDataBase  		,NIL},;
				{"F1_FORNECE",SA2->A2_COD		,NIL},;
				{"F1_LOJA"   ,SA2->A2_LOJA    	,NIL},;
				{"F1_SERIE"  ,TRB1->C7__NUMSER 	,NIL},;
				{"F1_DOC"    ,TRB1->C7__NUMDOC	,NIL},;
				{"F1_ESPECIE",cNEspecie    		,NIL},;
				{"F1_EST"	 ,SA2->A2_EST     	,NIL},;
				{"F1_COND"   ,TRB1->C7_COND		,NIL},;
				{"F1_STATUS" ,""        		,NIL}}
			EndIf


			SB1->( dbSetOrder( 1 ) )
			SB1->( dbSeek( xFilial( "SB1" ) + TRB1->C7_PRODUTO ) )


			// Campos e conteudos a serem gravados na tabela SD1
			aItens := {	{"D1_COD"    ,TRB1->C7_PRODUTO			,NIL},;
			{"D1_ITEM"   ,cItem					,NIL},;
			{"D1_DOC"    ,TRB1->C7__NUMDOC		,NIL},;
			{"D1_UM"     ,SB1->B1_UM			,NIL},;
			{"D1_QUANT"  ,TRB1->C7_QUANT		,NIL},;
			{"D1_VUNIT"  ,TRB1->C7_PRECO		,NIL},;
			{"D1_TOTAL"  ,TRB1->C7_TOTAL	 	,NIL},;
			{"D1_FORNECE",SA2->A2_COD			,NIL},;
			{"D1_LOJA"   ,SA2->A2_LOJA			,NIL},;
			{"D1_EMISSAO",dNEmissao				,NIL},;
			{"D1_DTDIGIT",dDataBase				,NIL},;
			{"D1_TIPO"   ,"N"					,NIL},;
			{"D1_TP"     ,SB1->B1_TIPO			,NIL},;
			{"D1_PEDIDO" ,TRB1->C7_NUM			,NIL},;
			{"D1_ITEMPC" ,TRB1->C7_ITEM			,NIL},;						
			{"D1_LOCAL"  ,SB1->B1_LOCPAD		,NIL}} 



			AAdd( aTotItens, aItens )
			cItem := SomaIt(cItem)
			cNumDoc := TRB1->C7__NUMDOC

			dbSelectArea("TRB1")
			dbSkip()
		End
		TRB1->(dbCloseArea())

		//GERA PRE NOTA DO ULTIMO ITEM
		lMsErroAuto := .f.

		MSExecAuto( {|x,y,z,w|MATA140( x, y, z, w ) }, aCab, aTotItens, 3, .F. )

		If lMsErroAuto
			Mostraerro()
		Else
			MsgInfo("Nota Fiscal "+cNumDoc+" gerada com Sucesso!")
		EndIf

	Endif

	mv_par01 := mnpar01Old	
	mv_par02 := mnpar02Old
	mv_par03 := mnpar03Old
	/*
	mv_par04 := mnpar04Old
	mv_par05 := mnpar05Old
	*/
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Bindo         บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta no e o help do SX1                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

	// Local cKey := ""
	// Local aHelpEng := {}
	// Local aHelpPor := {}
	// Local aHelpSpa := {}

	//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Pedido compra 		?",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    			,"SC7" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Especie NF 			?",""                    ,""                    ,"mv_ch2","C"   ,05      ,0       ,0      , "G",""    			,"42" 	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Emissao NF 			?",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


Return
