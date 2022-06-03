#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½ TFFAT002 ï¿½ Autor ï¿½ Rodrigo Brito         ï¿½ Data ï¿½ 13/10/10 ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Importaï¿½ï¿½o de documento de entrada intercompany.           ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½ Uso      ï¿½                                                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½         ATUALIZACOES SOFRIDAS DESDE A CONSTRUï¿½AO INICIAL.             ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Programador ï¿½ Data   ï¿½ GAP  ï¿½  Motivo da Alteracao                     ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä´ï¿½ï¿½
ï¿½ï¿½ï¿½Rodrigo     ï¿½13/10/10ï¿½      ï¿½ Implementaï¿½ï¿½o                            ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½            ï¿½        ï¿½      ï¿½                                          ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½            ï¿½        ï¿½      ï¿½                                          ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½            ï¿½        ï¿½      ï¿½                                          ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ù±ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
*/

User Function TFFAT002()

	Local cDoc      	:= ""
	Local cFornece  	:= ""
	Local cLojaFor  	:= ""
	Local cTipoFor  	:= ""
	Local cEmpCas   	:= ""
	Local cFilCas   	:= ""
	Local cSql      	:= "" 
	Local cAux      	:= "" 
	Local aCab      	:= {}
	Local cArmCasa  	:= "" 
	Local cSerie    	:= ""
	Local cItem     	:= ""
	Local cClasCas  	:= ""
	Local cMV_Rastro	:= ""
	Local cAliasOld		:= Alias()
	//Local nRegOlg	
	
	//Variaveis referentes a escolha da Empresa Origem - Edson Hornberger 28/01/2013
	Local oDlg,oCbx
	Local nOpc
	LOCAL cCombo1
	Local cNomEmp		:= ""
	Local cFilSF2 		:= ""
	Local cFilSA1 		:= ""
	Local cFilSB1 		:= ""
	Local cFilSD2 		:= ""
	//Local lArmCen		:= SUPERGETMV("MV_ARMCEN",.F.,.T.) //Parametro para ativar o Processo do Projeto Avante - Fase II
	//Local lUnidNeg		:= (CEMPANT + CFILANT) $ SUPERGETMV("MV_UNINEG",.F.,"") //Parametro para ativar o Processo do Projeto Avante - Unidade de Negocios

	//Local cArmDestino	:= ""	
	Private aEmpresas	:= {}, aEmp := {}
	//Fim das declaracoes - Edson Hornberger 28/01/2013
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Declaracao de variaveis para realizar o processo de Nota Fiscal Complementar
	|
	|	Edson Hornberger - 02/12/2014
	|=================================================================================
	*/
	PRIVATE ODLG01
	PRIVATE OFNT01
	PRIVATE OCMB01
	PRIVATE CCMB01 	:= ''
	PRIVATE OCMB02
	PRIVATE CCMB02 	:= ''
	PRIVATE AOPCAO 	:= {'P = PRE-NOTA','D = NOTA FISCAL'}
	PRIVATE OGET01
	PRIVATE CGET01 	:= SPACE(003)
	PRIVATE OGET02
	PRIVATE CGET02 	:= SPACE(009)
	PRIVATE OGET03
	PRIVATE CGET03 	:= SPACE(003)
	PRIVATE OBTN01
	PRIVATE OBTN02
	PRIVATE AITENS 	:= {'N = NORMAL','I = COMPL.ICMS','C = COMPL.ICMS ST.'}
	PRIVATE LPROC	:= .F.
	PRIVATE CTESORI	:= ""
	
	OFNT01 := TFONT():NEW('CONSOLAS',,-14,.T.,.T.,,,,.T.)
		
	cAux := GetMV("MV_FORCAS")
	If Empty(cAux)
		MsgAlert("Parâmetro MV_FORCAS não preenchido.","Venda casada")
		Return
	Endif
	cFornece := StrToKarr(cAux, "/")[1]
	cLojaFor := StrToKarr(cAux, "/")[2]
	                          
	cAux := GetMV("MV_EMPCASA")
	If Empty(cAux)
		MsgAlert("Parâmetro MV_EMPCASA não preenchido.","Venda casada")
		Return           
	Endif   
	cEmpCas := StrToKarr(cAux, "/")[1]
	cFilCas := StrToKarr(cAux, "/")[2]	

	cArmCasa := GetMV("MV_ARMCASA")
	If Empty(cArmCasa)
		MsgAlert("Parâmetro MV_ARMCASA não preenchido.","Venda casada")
		Return           
	Endif
	
	cClasCas := GetMV("MV_CLASCAS")
	If Empty(cClasCas)
		MsgAlert("Parâmetro MV_CLASCAS não preenchido.","Venda casada")
		Return           
	Endif
	
	cMV_Rastro := GetMV("MV_RASTRO")
	If Empty(cMV_Rastro)
		MsgAlert("Parâmetro MV_RASTRO não preenchido.","Venda casada")
		Return           
	Endif
	
	// Inicio do Processo para escolha da Empresa de Origem da NF - Edson Hornberger 28/01/2013
	x047Empresas()
	
	DEFINE FONT oFont NAME "Courier New" SIZE 5,0
    
   	nOpc := 0
    
   	DEFINE MSDIALOG oDlg FROM 36,1 TO 140,220 TITLE "Empresa/Filial" PIXEL 
 
		@ 07, 5   SAY "Empresa/Filial de Origem"  SIZE 100, 7 OF oDlg PIXEL
		@ 16, 5 	COMBOBOX oCbx VAR cCombo1 ITEMS aEmp SIZE 100, 58 OF oDlg PIXEL
	        		 
	  	DEFINE SBUTTON FROM 30, 50 TYPE 2  ENABLE OF oDlg Action (nOpc:=0,oDlg:End())
	  	DEFINE SBUTTON FROM 30, 80 TYPE 1  ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
    
   ACTIVATE MSDIALOG oDlg Centered
   
	If nOpc = 0 
		
		Alert("Será realizado o Processamento utilizando" + CRLF + "Empresa configurada no Parâmetro MV_EMPCASA!")
	
	Else
	
		cNomEmp := AllTrim(SubStr(cCombo1,1,Len(cCombo1)-4))
		cEmpCas := SubStr(cCombo1,Len(cCombo1)-3,2)
		cFilCas := SubStr(cCombo1,Len(cCombo1)-1,2)
		dbSelectArea("SM0")
		nRegOld := Recno()
		SM0->(dbGoTop())
		
		WHILE SM0->(!EOF())
		
			If SM0->M0_CODIGO = cEmpCas .And. SM0->M0_CODFIL = cFilCas
				
				cFornece	:= Posicione("SA2",3,XFILIAL("SA2")+SM0->M0_CGC,"A2_COD") 
				cLojaFor	:= Posicione("SA2",3,XFILIAL("SA2")+SM0->M0_CGC,"A2_LOJA")
				cTipoFor	:= Posicione("SA2",3,XFILIAL("SA2")+SM0->M0_CGC,"A2_TIPO")
				
			EndIf
			
			SM0->(dbSkip())
			
		ENDDO
		
		SM0->(dbGoTo(nRegOld))
		dbSelectArea(cAliasOld)
		
	EndIf
	
	//Fim - Edson Hornberger 28/01/2013
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Inicio do Processo de escolha de Tipo de Documento, TES e informacao da 
	|	Nota Fiscal que serï¿½ gerada.
	|=================================================================================
	*/
	
	DEFINE DIALOG ODLG01 TITLE "Informaï¿½ï¿½es sobre a NF" FROM 180,180 TO 380,453 PIXEL

		OCMB01 := 	TCOMBOBOX():NEW(	005,005,{|U|IF(PCOUNT()>0,CCMB01:=U,CCMB01)},AITENS,070,20,ODLG01,,{||VALIDCMB()},,,,.T.,,,,,,,,,'CCMB01','Tipo da Nota Fiscal:',2,OFNT01)
		OGET01 := 	TGET():NEW( 		020,005,{|U|IF(PCOUNT()>0,CGET01:=U,CGET01)},ODLG01	,030,010,"@R 999"		,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4",'CGET01',,,,.F.,.F.,,'TES qdo Complemento:',2,OFNT01 )
		OGET02 := 	TGET():NEW( 		035,005,{|U|IF(PCOUNT()>0,CGET02:=U,CGET02)},ODLG01	,070,010,"@R 999999999"	,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,,'CGET02',,,,.F.,.T.,,'Nï¿½mero da NFE:      ',2,OFNT01 )							
		OGET03 := 	TGET():NEW( 		050,005,{|U|IF(PCOUNT()>0,CGET03:=U,CGET03)},ODLG01	,030,010,"@!"			,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,,'CGET03',,,,.F.,.T.,,'Sï¿½rie da NFE:       ',2,OFNT01 )
		OCMB01 := 	TCOMBOBOX():NEW(	065,005,{|U|IF(PCOUNT()>0,CCMB02:=U,CCMB02)},AOPCAO,070,20,ODLG01,,,,,,.T.,,,,,,,,,'CCMB02','Importar como:      ',2,OFNT01)								
		
		OGET01:OPARENT:CCAPTION := "TES de Complemento: "
		OGET01:SETCONTENTALIGN(0)
		OGET01:LVISIBLE 		:= .F.
		OGET02:OPARENT:CCAPTION := "Número da NFE: "
		OGET03:OPARENT:CCAPTION := "Série da NFE: "
		
		OBNT01 :=	TBUTTON():NEW( 		085, 050, "Ok"		,ODLG01,{||LPROC:=.T.,ODLG01:END()},040,010,,,.F.,.T.,.F.,,.F.,,,.F. ) 	
		OBNT02 :=	TBUTTON():NEW( 		085, 095, "Cancela"	,ODLG01,{||LPROC:=.F.,ODLG01:END()},040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		ODLG01:CCAPTION := "Informaçoes da NFE"

	ACTIVATE DIALOG ODLG01 CENTERED
	
	If LPROC 
		
		CURSORWAIT()
		
		//Confirmacao do Processo com Empresa escolhida - Edson Hornberger 28/01/2013
		If nOpc = 1 .And. !MsgYesNo("Confirma o processamento da NF: " + CGET02 + "/" + ALLTRIM(CGET03) + CRLF+ "Empresa Origem: " + cNomEmp)
			
			CURSORARROW()
			Return()
			
		EndIF
		
		If Select("__TMP") > 0 
			
			dbSelectArea("__TMP")
			dbCloseArea()
					
		EndIf
		
		/*
		|---------------------------------------------------------------------------------
		|	Verifica as filiais de todas as tabelas envolvidas para poder gerar Query
		|---------------------------------------------------------------------------------
		*/
		cSql := "SELECT dbo.FC_TABMODO('" + cEmpCas + "','" + cFilCas + "','SF2') AS FILIAL"
		TcQuery cSql New Alias "__TMP"
		cFilSF2 := __TMP->FILIAL
		
		dbSelectArea("__TMP")
		dbCloseArea()
		
		cSql := "SELECT dbo.FC_TABMODO('" + cEmpCas + "','" + cFilCas + "','SA1') AS FILIAL"
		TcQuery cSql New Alias "__TMP"
		cFilSA1 := __TMP->FILIAL
		
		dbSelectArea("__TMP")
		dbCloseArea()
		
		cSql := "SELECT dbo.FC_TABMODO('" + cEmpCas + "','" + cFilCas + "','SB1') AS FILIAL"
		TcQuery cSql New Alias "__TMP"
		cFilSB1 := __TMP->FILIAL
		
		dbSelectArea("__TMP")
		dbCloseArea()
		
		cSql := "SELECT dbo.FC_TABMODO('" + cEmpCas + "','" + cFilCas + "','SD2') AS FILIAL"
		TcQuery cSql New Alias "__TMP"
		cFilSD2 := __TMP->FILIAL
		
		dbSelectArea("__TMP")
		dbCloseArea()
		
		cSql := "SELECT dbo.FC_TABMODO('" + cEmpCas + "','" + cFilCas + "','SF2') AS FILIAL"
		TcQuery cSql New Alias "__TMP"
		cFilSF2 := __TMP->FILIAL
		
		dbSelectArea("__TMP")
		dbCloseArea()			
		
		//Fim - Edson Hornberger 28/01/2013
		     	
		cDoc   := CGET02 
		cSerie := CGET03
		SF1->(DbSetOrder(1))
		SF1->(DbSeek(xFilial("SF1")+cDoc+cSerie+cFornece+cLojaFor))
		
		If !SF1->(Found())
			
			/*
			|=================================================================================
			|   COMENTARIO
			|---------------------------------------------------------------------------------
			|	Alterado o fonte, pois não estava sendo realizado verificacao se a tabela 
			| temporaria TMPF2 estava sendo utilizado ou nao, ocasionando erro na execucao.
			|	
			|	Edson Hornberger - 30/04/2014
			|=================================================================================
			*/
			
			If Select("TMPF2") > 0 
			
				dbSelectArea("TMPF2")
				dbCloseArea()
						
			EndIf
			
			cSql := "SELECT A1_CGC "
			cSql += "FROM "
			cSql += "  SF2" + cEmpCas + "0 SF2 JOIN SA1" + cEmpCas + "0 SA1 ON "
			cSql += "    SA1.D_E_L_E_T_ = ' ' AND "
			cSql += "    SF2.D_E_L_E_T_ = ' ' AND "
			cSql += "    SF2.F2_CLIENTE = SA1.A1_COD AND "
			cSql += "    SF2.F2_LOJA    = SA1.A1_LOJA "
			cSql += "WHERE "
			cSql += "  SF2.F2_FILIAL     IN ('" + cFilSF2 + "') " 
			cSql += "  AND SA1.A1_FILIAL IN ('" + cFilSA1 + "') " 
			cSql += "  AND SF2.F2_DOC    = '" + cDoc    + "' " 
			cSql += "  AND SF2.F2_SERIE  = '" + cSerie  + "' " 
			IF CCMB01 = "N"
				cSql += "  AND SF2.F2_TIPO   = 'N' "
			ELSE
				cSql += "  AND SF2.F2_TIPO   = 'I' "
			ENDIF
			TCQuery cSql New Alias "TMPF2"
		
			If !TMPF2->(Eof()) .And. !TMPF2->(Bof())
		
				If TMPF2->A1_CGC == SM0->M0_CGC
		
					TMPF2->(DbCloseArea())
					/*
					|---------------------------------------------------------------------------------
					|	INCLUIDO NA QUERY SUBSTRING NO CODIGO DO PRODUTO PARA QUE SEJA UTILIZADO 
					|	SOMENTE 9 CARACTERES (PRFODUTOS COM FINAL IP).
					|---------------------------------------------------------------------------------
					*/
					cSql := "SELECT D2_DOC, D2_SERIE, D2_EMISSAO, D2_EST, SUBSTRING(D2_COD,1,9) AS D2_COD, D2_QUANT, D2_PRCVEN, "
					cSql += "  D2_TOTAL, D2_VALIPI, D2_VALICM, D2_IPI, D2_PICM, D2_PESO, D2_QTSEGUM, D2_BASEICM, D2_LOCAL, "
					cSql += "  D2_BASEIPI, D2_LOTECTL, D2_CLASFIS, B1_RASTRO "
					cSql += " ,D2_ITEMCC, F2_CHVNFE "
		
					IF (cEmpCas + cFilCas) $ ("0302") 
					
						cSql += " ,F2_NUMRM "
					
					ENDIF
					
					IF CCMB01 != "N"
					
						cSql += " ,D2_NFORI " 
						cSql += " ,D2_SERIORI "
						cSql += " ,(SELECT D1_ITEM FROM " + RETSQLNAME("SD1") + " SD1 WHERE D1_FILIAL = '" + XFILIAL("SD1") + "' AND D1_COD = D2_COD AND D1_DOC = D2_NFORI AND D1_SERIE = D2_SERIORI AND D_E_L_E_T_ = '') AS D2_ITEMORI "
					
					ENDIF
		
					cSql += "FROM SD2" + cEmpCas + "0 AS SD2 JOIN SB1" + cEmpCas + "0 SB1 ON"
					cSql += "    SB1.B1_FILIAL 	= '" + cFilSB1 + "' AND "					
					cSql += "    SB1.D_E_L_E_T_	= ' ' AND "
					cSql += "    SD2.D2_COD    	= SB1.B1_COD "
					cSql += "	  JOIN SF2" + cEmpCas + "0 SF2 ON "
					cSql += "	  SF2.F2_DOC = SD2.D2_DOC AND "
					cSql += "	  SF2.F2_SERIE = SD2.D2_SERIE AND "
					cSql += "	  SF2.F2_CLIENTE = SD2.D2_CLIENTE AND "
					cSql += "	  SF2.F2_LOJA = SD2.D2_LOJA AND "
					cSql += "	  SF2.F2_FILIAL = '" + cFilSF2 + "' AND "
					cSql += "	  SF2.D_E_L_E_T_ = '' "
					cSql += "WHERE "
					cSql += "     SD2.D_E_L_E_T_ = '' "
					cSql += " AND SD2.D2_FILIAL  = '" + cFilSD2 + "' " 
					cSql += " AND SD2.D2_DOC     = '" + cDoc    + "' " 
					
					IF CCMB01 = "N"
						cSql += " AND SD2.D2_TIPO    = 'N' "
					ELSE
						cSql += " AND SD2.D2_TIPO    = 'I' "
					ENDIF
					
					cSql += " AND SD2.D2_SERIE   = '" + cSerie  + "' " 
					cSql += " ORDER BY SD2.D2_ITEM "
					TCQuery cSql New Alias "TMPD2"
					TCSetField("TMPD2", "D2_EMISSAO", "D")					
					
					/*
					|---------------------------------------------------------------------------------
					|	Inicio da montagem dos arrays para MSExecAuto
					|---------------------------------------------------------------------------------
					*/
					aCab   := {}
					aAdd(aCab,{"F1_FILIAL" 	, xFilial("SF1")   	, Nil})
					aAdd(aCab,{"F1_DOC"    	, TMPD2->D2_DOC     , Nil})
					aAdd(aCab,{"F1_SERIE"  	, TMPD2->D2_SERIE  	, Nil})
					aAdd(aCab,{"F1_FORMUL" 	, "N"               	, Nil})					
					/*
					|---------------------------------------------------------------------------------
					|	Verifica qual Tipo de Documento que serï¿½ gerado
					|---------------------------------------------------------------------------------
					*/
					IF CCMB01 = "N"
					
						aAdd(aCab,{"F1_TIPO"   	, "N"               	, Nil})
						
					ELSE
					
						aAdd(aCab,{"F1_TIPO"   	, "I"               	, Nil})
						DBSELECTAREA("SF1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SF1") + TMPD2->D2_NFORI + TMPD2->D2_SERIORI + cFornece + cLojaFor)
						aAdd(aCab,{"F1_COND"   	, SF1->F1_COND               	, Nil})
						
					ENDIF	
					
					aAdd(aCab,{"F1_ESPECIE"	, "SPED"            	, Nil})
					aAdd(aCab,{"F1_EMISSAO"	, TMPD2->D2_EMISSAO, Nil})
					aAdd(aCab,{"F1_FORNECE"	, cFornece          	, Nil})
					aAdd(aCab,{"F1_LOJA"   	, cLojaFor          	, Nil})
					aAdd(aCab,{"F1_CHVNFE"  , TMPD2->F2_CHVNFE	   	, Nil})					
		
					IF (cEmpCas + cFilCas) $ ("0302") 
											
						aAdd(aCab,{"F1_NUMRM"   	, TMPD2->F2_NUMRM       	, Nil})
					
					ENDIF
				
					aItens := {}
					cItem  := Soma1(Replicate("0", TamSX3("D1_ITEM")[1]), TamSX3("D1_ITEM")[1])

					// Itens do documento de entrada
					While !TMPD2->(Eof())
		
						/*
						|=================================================================================
						|   SINTAXE DA FUNCAO MATESINT
						|---------------------------------------------------------------------------------
						|	MaTesInt(nEntSai,cTpOper,cClieFor,cLoja,cTipoCF,cProduto,cCampo)
						|---------------------------------------------------------------------------------
						|	nEntSai -> Tipo de Documento (1=Entrada, 2=Saida)
						|	nEntSai -> Tipo Operaï¿½ï¿½o (SX5 - DF)
						|	cClieFor-> Cï¿½digo do Cliente/Fornecedor 
						|	cLoja	-> Loja do Cliente/Fornecedor
						|	cTipoCF	-> Tipo do Cliente/Fornecedor
						|	cProduto-> Cï¿½digo do Produto	
						|	cCampo	-> ???
						|=================================================================================
						*/
						CTES :=  MaTesInt(1,"60",cFornece,cLojaFor,cTipoFor,TMPD2->D2_COD)
						
						aAdd(aItens, {})
						aAdd(aItens[Len(aItens)], {"D1_FILIAL" , xFilial("SD1")    , Nil})
						aAdd(aItens[Len(aItens)], {"D1_ITEM"   , cItem             , Nil})
						aAdd(aItens[Len(aItens)], {"D1_COD"    , TMPD2->D2_COD     , Nil})						
						aAdd(aItens[Len(aItens)], {"D1_SERIE"  , TMPD2->D2_SERIE   , Nil})						
						IF CCMB01 = "N"
							aAdd(aItens[Len(aItens)], {"D1_QUANT"  , TMPD2->D2_QUANT   , Nil})
							aAdd(aItens[Len(aItens)], {"D1_VUNIT"  , TMPD2->D2_PRCVEN  , Nil})
							aAdd(aItens[Len(aItens)], {"D1_TOTAL"  , Round(TMPD2->D2_PRCVEN * TMPD2->D2_QUANT, SuperGetMV("MV_RNDLOC")), Nil})
							aAdd(aItens[Len(aItens)], {"D1_VALIPI" , TMPD2->D2_VALIPI  , Nil})
							aAdd(aItens[Len(aItens)], {"D1_VALICM" , TMPD2->D2_VALICM  , Nil})
							aAdd(aItens[Len(aItens)], {"D1_IPI"    , TMPD2->D2_IPI     , Nil})
							aAdd(aItens[Len(aItens)], {"D1_PICM"   , TMPD2->D2_PICM    , Nil})
							aAdd(aItens[Len(aItens)], {"D1_PESO"   , TMPD2->D2_PESO    , Nil})
							aAdd(aItens[Len(aItens)], {"D1_BASEICM", TMPD2->D2_BASEICM , Nil})
							aAdd(aItens[Len(aItens)], {"D1_BASEIPI", TMPD2->D2_BASEIPI , Nil})
							If cMV_Rastro == "S" .And. TMPD2->B1_RASTRO <> "N"
		
								aAdd(aItens[Len(aItens)], {"D1_LOTECTL", TMPD2->D2_LOTECTL , Nil})
								aAdd(aItens[Len(aItens)], {"D1_DTVALID", CtoD("31/12/2050"), Nil})
			
							EndIf
							IF CCMB02 = "D"
								
								aAdd(aItens[Len(aItens)], {"D1_TES", CTES, Nil})
							
							ENDIF
						ELSE
							aAdd(aItens[Len(aItens)], {"D1_VUNIT"  , TMPD2->D2_PRCVEN  , Nil})
							aAdd(aItens[Len(aItens)], {"D1_TOTAL"  , Round(TMPD2->D2_PRCVEN, SuperGetMV("MV_RNDLOC")), Nil})
							IF CCMB01 = "C"
								aAdd(aItens[Len(aItens)], {"D1_ICMSRET"	, TMPD2->D2_PRCVEN  , Nil})
							ENDIF
						ENDIF
						IF CEMPANT="03" .AND. CFILANT="01"
							If ALLTRIM(TMPD2->F2_NUMRM) != "CROSS" .AND. CEMPANT="03" .AND. CFILANT="01"  
								aAdd(aItens[Len(aItens)], {"D1_LOCAL"  , "62"   , Nil})
							ElseIf ALLTRIM(TMPD2->F2_NUMRM) = "CROSS" .AND. CEMPANT="03" .AND. CFILANT="01"  
								aAdd(aItens[Len(aItens)], {"D1_LOCAL"  , "21"   , Nil})
							EndIf
						Else
							aAdd(aItens[Len(aItens)], {"D1_LOCAL"  , TMPD2->D2_LOCAL   , Nil})
						EndIf
						aAdd(aItens[Len(aItens)], {"D1_CLASFIS", TMPD2->D2_CLASFIS , Nil})
						aAdd(aItens[Len(aItens)], {"D1_CLASCON", cClasCas          , Nil})
						
						/*
						|---------------------------------------------------------------------------------
						|	Se for Nota Complementar de ICMS procura a NF de Origem para buscar o TES
						|	que foi utilizado, senao utiliza o TES informado no parametro ou tela inicial.
						|---------------------------------------------------------------------------------
						*/
						IF CCMB01 != "N"
							
							IF CCMB01 = "I"
								
								DBSELECTAREA("SD1")
								DBSETORDER("1")
								IF DBSEEK(XFILIAL("SD1") + TMPD2->D2_NFORI + TMPD2->D2_SERIORI + cFornece + cLojaFor + TMPD2->D2_COD + TMPD2->D2_ITEMORI)
								
									aAdd(aItens[Len(aItens)], {"D1_TES"	, SD1->D1_TES	, Nil})
								
								ENDIF
							
							ELSE
							
								aAdd(aItens[Len(aItens)], {"D1_TES"	, CGET01	, Nil})
								
							ENDIF
							
							aAdd(aItens[Len(aItens)], {"D1_NFORI"	, TMPD2->D2_NFORI 	, Nil})
							aAdd(aItens[Len(aItens)], {"D1_SERIORI"	, TMPD2->D2_SERIORI , Nil})
							aAdd(aItens[Len(aItens)], {"D1_ITEMORI"	, STRZERO(VAL(TMPD2->D2_ITEMORI),4) , Nil})
							
						ENDIF
		
						aAdd(aItens[Len(aItens)], {"D1_ITEMCTA", TMPD2->D2_ITEMCC, Nil})
						cItem := Soma1(cItem, TamSX3("D1_ITEM")[1])
						TMPD2->(DbSkip())
		
					End
		
					TMPD2->(DbCloseArea())					
					lMsHelpAuto := .T.             
					lMsErroAuto := .F.
					
					IF CCMB01 = "N" .AND. CCMB02 = "P"
		
						Begin Transaction
			
				 			MSExecAuto({|x,y,z| MATA140(x,y,z)}, aCab, aItens, 3)
			
							If lMsErroAuto
								
								CURSORARROW()			
								MostraErro()
								HS_MsgInf("Houve um problema na inclusï¿½o do documento de entrada. A importaï¿½ï¿½o do documento não serï¿½ efetuada.", "Atenï¿½ï¿½o!!!", "InterCompany")
								DisarmTransaction()
								Final()
			
							Else
								
								CURSORARROW()
								MsgInfo("Documento importado com sucesso.","InterCompany")
			
							EndIf
			
						End Transaction
						
					ELSEIF CCMB01 = "N" .AND. CCMB02 = "D"
						
						Begin Transaction
			
				 			MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 3)
			
							If lMsErroAuto
								
								CURSORARROW()			
								MostraErro()
								HS_MsgInf("Houve um problema na inclusï¿½o do documento de entrada. A importaï¿½ï¿½o do documento não serï¿½ efetuada.", "Atenï¿½ï¿½o!!!", "InterCompany")
								DisarmTransaction()
								Final()
			
							Else
								
								CURSORARROW()
								MsgInfo("Documento importado com sucesso.","InterCompany")
			
							EndIf
			
						End Transaction
						
					ELSE
					
						Begin Transaction
			
				 			MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCab, aItens, 3)
			
							If lMsErroAuto
								
								CURSORARROW()			
								MostraErro()
								HS_MsgInf("Houve um problema na inclusï¿½o do documento de entrada. A importaï¿½ï¿½o do documento não serï¿½ efetuada.", "Atenï¿½ï¿½o!!!", "InterCompany")
								DisarmTransaction()
								Final()
			
							Else
								
								CURSORARROW()			
								MsgInfo("Documento importado com sucesso.","InterCompany")
			
							EndIf
							
						End Transaction
					
					ENDIF
		
				Else
					
					CURSORARROW()		
					MsgAlert("O	documento informado não pertence a esta empresa.","InterCompany")
		
				Endif
		
			Else
				
				CURSORARROW()		
				MsgAlert("Documento não encontrado.","InterCompany")			
		
			EndIf
		
		Else
			
			CURSORARROW()		
	  	  	MsgAlert("Nï¿½ de documento jï¿½ importado.","InterCompany")
		
		EndIf
				
	EndIf
	
	CURSORARROW()
	
Return

/*
=================================================================================
=================================================================================
||   Arquivo:	TFFAT002.PRW
=================================================================================
||   Funcao:	VALIDCMB 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que realiza a verificacao dos TES para complemento, habilitando
|| 	ou nao o TextBox de preenchimento do mesmo. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornnberger 
||   Data:	03/12/2014
=================================================================================
=================================================================================
*/

STATIC FUNCTION VALIDCMB()

LOCAL	CTESCICMST 	:= SUPERGETMV("TF_FAT0022",.F.,"399")	//TES utilizada para NFE Complementar de ICMS ST

IF OCMB01:NAT = 3  
	
	OGET01:LVISIBLE := .T.
	OGET01:CTEXT := CTESCICMST 
	OGET01:CTRLREFRESH()
	OGET01:SETCONTENTALIGN(0)
	
ELSE
	
	OGET01:LVISIBLE := .F.
	
ENDIF 

RETURN .T.
