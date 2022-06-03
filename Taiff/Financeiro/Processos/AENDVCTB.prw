#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"
#INCLUDE "FwBrowse.ch"
#INCLUDE "fwmvcdef.ch"
#DEFINE ENTER CHAR(13) + CHAR(10)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  AENDVCTB    ºAutor  ³Totvs-Jackson      º Data ³  29/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina de Contabilização Contratos Endividamento          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AENDVCTB(nOpcCtb,lMostraCtb)
Local lRetCtb 	:= .T.
Local lUsaFlag := .F.
Local aFlagCTB := {} 
//Local lOkJuros := .F.
Local cPadrao  := "" 
Local nHdlPrv  := 0
LOCAL _nTotLan   := 0
LOCAL lDigita  := If(lMostraCtb,.T.,.F.)
LOCAL lPadrao  := .F. 

Local dDataDe  := FirstDay(dDataBase)
Local dDataAte := LastDay(dDataBase)
Local cPerg 	:= "ADGCTB1"
Local cMarca   := GetMark()				                 				
Local aCampos  := {}								             				
Local cIndex  										              				
Local oMark												         			
Local lOk      := .F.							             				
Local lOKCtb   := .F.
Local lInvert  := .F.                                             
Local bAllMark := {|| ManutSel(oMark, "TMP1", "OK", @cMarca)}  //              *
Local nQtdAproc := 0   
Local nQtdProc := 0
Local cLoteCtb  := "E99999"
Local cSubLote := ""

Private cMsgErroCT := "" 
Private cArquivo      
Default nOpcCtb := 3
Default lMostraCtb := .F.

IF SZY->ZY_STATFIN $ " /0" 
     MsgStop("Status do Contrato não permite contabilização, pois não está liberado para o financeiro.","Erro Contabilização")
	  Return(.F.)
EndIf
ValidPerg(cPerg)
pergunte("ADGCTB1",.F.)

MV_PAR04 := cLoteCtb
IF pergunte("ADGCTB1",.T.)

If ValType(MV_PAR06) == "C"
     MV_PAR06 := Val(MV_PAR06)
EndIf                         

If ValType(MV_PAR01) == "C"
     MV_PAR01 := Val(MV_PAR01)
EndIf              
           
If ValType(MV_PAR07) == "C"
     MV_PAR07 := Val(MV_PAR07)
EndIf                         


lDigita 	:= .F. //(MV_PAR01 == 1)
dDataDe 	:= MV_PAR02
dDataAte	:= MV_PAR03
cLoteCtb	:= "002400"//MV_PAR04
cSubLote := MV_PAR05  
lJuros	:= (MV_PAR07 == 2)
lUsaFlag := (MV_PAR06 == 1 .And. !lJuros)
dLastDay := LastDay(MV_PAR03)            
dDtProcJ := SuperGetMV("DG_DTCTBJU",.F.,CTOD("  /  /  "))
IIf(MV_PAR06 == 1,nOpcCtb := 3, nOpcCtb := 5)

If dDataAte == dLastDay  .And. lJuros
		If dLastDay <> dDtProcJ
          lContProc := .T.
      Else
          lContProc := .F.
      EndIf 
Else
	lContProc := .T.                
EndIf
If nOpcCtb == 3
 	If lJuros
		cPadrao := SuperGetMV("DG_LPEMPJI",.F.,"582")
	Else
		cPadrao := SuperGetMV("DG_LPEMPPI",.F.,"580")
	EndIf
ElseIf nOpcCtb == 5	
	If lJuros
		cPadrao := SuperGetMV("DG_LPEMPJE",.f.,"583")
	Else
		cPadrao := SuperGetMV("DG_LPEMPPE",.f.,"581")
	EndIf
Else
	Return .f.
EndIf
lPadrao  := VerPadrao(cPadrao)
IIF(Empty(cLoteCtb),LoteCont("FIN"),)

IF lPadrao .And. (lContProc .Or. nOpcCtb == 5)
	DbSelectArea("SZY") 
	SZY->(DbSetOrder(1)) 
	
	
	//If lJuros
 		/*
 		cQrySZY := " SELECT "
 		cQrySZY += ENTER + " E2_FILIAL,E2_PREFIXO,E2_NUM,E2_TIPO,E2_NATUREZ,E2_VALOR,E2_XJURCTR,E2_XJURVAR,SE2.R_E_C_N_O_ RECSE2,SZY.R_E_C_N_O_ RECSZY "
		cQrySZY += ENTER + " FROM " + RetSqlName("SE2") + " SE2 (NOLOCK)"
		cQrySZY += ENTER + " JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' AND SZY.ZY_CODSEQ = SE2.E2_NUM "
		cQrySZY += ENTER + " WHERE SE2.D_E_L_E_T_ <> '*' AND E2_FILIAL = '" + xFilial("SE2") + "' "
		cQrySZY += ENTER + " AND E2_XENDVDG = 'S' "
		cQrySZY += ENTER + " AND E2_PREFIXO NOT IN ('TAC','IOF') "
		cQrySZY += ENTER + " AND SE2.E2_VENCREA BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
		cQrySZY += ENTER + " ORDER BY SE2.E2_VENCREA " 	
 		 */
 		
		cQrySZY := ENTER + " SELECT '  ' OK, SZY.ZY_CODSEQ CONTRATO,SZY.ZY_DESCEMP DESCRICAO,SZY.ZY_DTDIGIT DTDIGIT,SZY.ZY_DTCONTR DTCONTR,SUM(SZZ.ZZ_VLRPRIN) ZZ_VLRPRIN,SUM(SZZ.ZZ_VLRJUR) ZZ_VLRJUR, SUM(SZZ.ZZ_PARAPAG) ZZ_PARAPAG FROM " + RetSqlName("SZZ") + " SZZ "
		cQrySZY += ENTER + " JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL = SZZ.ZZ_FILIAL  AND SZY.ZY_CODSEQ = SZZ.ZZ_CODSEQ AND SZY.ZY_REVISAO = SZZ.ZZ_REVISAO "
		cQrySZY += ENTER + " WHERE SZZ.D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + xFilial("SZY") + "' "
		
		If lJuros
			cQrySZY += ENTER + " AND SZZ.ZZ_DTVENC BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
		Else
			cQrySZY += ENTER + " AND SZY.ZY_DTDIGIT BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
		EndIf
		if MV_PAR06 == 1
 			If !lJuros
 				cQrySZY += ENTER + " AND SZY.ZY_LA <> 'S' "
 		   EndIf
 		Else
		 	cQrySZY += ENTER + " AND SZY.ZY_LA == 'S' "
 		EndIf
 		cQrySZY += ENTER + " GROUP BY SZY.ZY_CODSEQ,SZZ.ZZ_CODSEQ,SZY.ZY_DESCEMP,SZY.ZY_DTDIGIT,SZY.ZY_DTCONTR "
 		cQrySZY += ENTER + " ORDER BY SZZ.ZZ_CODSEQ "
 	/*
 	Else
 		cQrySZY := " SELECT " 
  		cQrySZY += ENTER + " ZY_CODSEQ,ZY_REVISAO,R_E_C_N_O_ RECNO1 " 
  		cQrySZY += ENTER + " FROM " + RetSqlName("SZY")  + " SZY (NOLOCK) "
 		cQrySZY += ENTER + " WHERE SZY.D_E_L_E_T_  <> '*' "
		cQrySZY += ENTER + " AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' "
 		if MV_PAR06 == 1
 			cQrySZY += ENTER + " AND SZY.ZY_LA <> 'S' "
 		Else
		 	cQrySZY += ENTER + " AND SZY.ZY_LA == 'S' "
 		EndIf
 		cQrySZY += ENTER + " AND SZY.ZY_DTDIGIT BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
  	EndIf
  	*/
	If Select("TBSZYT") > 0
	     TBSZYT->(DbCloseArea())
	EndIf 
	TCQUERY cQrySZY NEW ALIAS "TBSZYT"
	TCSetField('TBSZYT', 'DTCONTR',	'D')
	TCSetField('TBSZYT', 'DTDIGIT',	'D')

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Redefine o array aCampos com a estrutura do MarkBrowse                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos := {}   
	Aadd(aCampos, {"OK"        , "", ""         	, ""   }) // Flag marcacao
	Aadd(aCampos, {"CONTRATO"  , "", "Cod.Contrato"	, "@!" }) // Código do Contrato
	Aadd(aCampos, {"DESCRICAO" , "", "Desecrição"  	, "@!" }) // Descrição do contrato
	Aadd(aCampos, {"VLRPRIN" 	, "", "Vlr.Princ."  , "@E 9,999,999,999.99" }) // Valor do Principal
	Aadd(aCampos, {"VLRJURO" 	, "", "Vlr.Juro"    , "@E 9,999,999,999.99" }) // Valor do Juro
	Aadd(aCampos, {"VLRPARPG" 	, "", "Vlr.Parcela" , "@E 9,999,999,999.99" }) // Valor Da parcela
	Aadd(aCampos, {"DTCONTR"   , "", "Dt.Contrato"  , "" }) // Data do Contrato
	Aadd(aCampos, {"DTDIGIT"   , "", "Data Digitação","" }) // Data de Digitação
	
 	aCamposTrb := {}   
	Aadd(aCamposTrb, {"OK"       , "C",02,00}) // Flag marcacao
	Aadd(aCamposTrb, {"CONTRATO" , "C",09,00}) // Código do Contrato
	Aadd(aCamposTrb, {"DESCRICAO", "C",20,00}) // Descrição do contrato
	Aadd(aCamposTrb, {"VLRPRIN"  , "N",15,02}) // Valor do Principal
	Aadd(aCamposTrb, {"VLRJURO"  , "N",15,02}) // Valor do Juro
	Aadd(aCamposTrb, {"VLRPARPG" , "N",15,02}) // Valor Da parcela	
	Aadd(aCamposTrb, {"DTCONTR"  , "D",08,00}) // Data do Contrato
	Aadd(aCamposTrb, {"DTDIGIT"  , "D",08,00}) // Data de Digitação
		
 
    If Select("TMP1") > 0
    	TMP1->(DbCloseArea())    	
    EndIf
	cIndex := CriaTrab(aCamposTrb, .T.)
	dbUseArea( .T.,, cIndex, "TMP1", IF(.F. .OR. .F., !.F., NIL), .F. )
	
	While TBSZYT->(!EOF())
		TMP1->(RecLock("TMP1", .T.))
			TMP1->OK		        := "" 
			TMP1->CONTRATO 	 := TBSZYT->CONTRATO
			TMP1->DESCRICAO    := TBSZYT->DESCRICAO
			TMP1->VLRPRIN		 := TBSZYT->ZZ_VLRPRIN
			TMP1->VLRJURO		 := TBSZYT->ZZ_VLRJUR
			TMP1->VLRPARPG		 := TBSZYT->ZZ_PARAPAG
			TMP1->DTCONTR      := TBSZYT->DTCONTR
			TMP1->DTDIGIT 		:= TBSZYT->DTDIGIT
			TMP1->(MsUnlock())
		nQtdAproc ++
		TBSZYT->(DbSkip())	
	EndDo            
	TBSZYT->(DbCloseArea())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria a tela para exibição                                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Define MsDialog oDlg3 Title 'Produtos para entregar' FROM 259, 471 To 514, 947 Pixel OF oMainWnd
	Define MsDialog oDlg3 Title 'Contratos dentro do Periodo Selecionado' FROM 0,0 TO 500,950  Pixel OF oMainWnd
		oMark := MsSelect():New("TMP1", "OK",, aCampos, @lInvert, cMarca, {03, 03, 225, 480})
		oMark:oBrowse:lCanAllmark 	:= .T.
		oMark:oBrowse:bAllMark		:= bAllMark

		TMP1->(dbGoTop())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Botoes de controle do MsSelect                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@230, 003 Button "Marcar todos"    Size 073, 012 Pixel OF oDlg3 Action ManutSel(oMark, "TMP1", "OK", cMarca, "M")
		@230, 081 Button "Desmarcar todos" Size 073, 012 Pixel OF oDlg3 Action ManutSel(oMark, "TMP1", "OK", cMarca, "L")
		@230, 159 Button "Inverte Selecao" Size 073, 012 Pixel OF oDlg3 Action ManutSel(oMark, "TMP1", "OK", cMarca, "I")
	   
	   @230, 310 BmpButton Type 01 Action (lOk := .T., oDlg3:End())
     	@230, 355 BmpButton Type 02 Action oDlg3:End()
      
	Activate MsDialog oDlg3 Centered
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso tenha clicado em OK                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   //MsgAlert("Passou Aqui")
   
	If lOk .And. TMP1->(!EOF())  
		While TMP1->(!EOF())  
			nHdlPrv := 0
			IF TMP1->OK == cMarca	//IF lJuros			     
			   nQtdProc ++ 
			 	cQrySZY := ENTER + " SELECT '  ' OK, SZY.ZY_CODSEQ CONTRATO,SZY.ZY_DESCEMP DESCRICAO,SZZ.ZZ_NROPAR,SZZ.ZZ_VLRPRIN,SZZ.ZZ_VLRJUR,SZZ.ZZ_PARAPAG,SZY.ZY_DTDIGIT DTDIGIT,SZY.ZY_DTCONTR DTCONTR,SZZ.R_E_C_N_O_ RECSZZ,SZY.R_E_C_N_O_  RECSZY  FROM " + RetSqlName("SZZ") + " SZZ "
				cQrySZY += ENTER + " JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL = SZZ.ZZ_FILIAL  AND SZY.ZY_CODSEQ = SZZ.ZZ_CODSEQ AND SZY.ZY_REVISAO = SZZ.ZZ_REVISAO "
				cQrySZY += ENTER + " WHERE SZZ.D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + xFilial("SZY") + "' "
				
				If lJuros
					cQrySZY += ENTER + " AND SZZ.ZZ_DTVENC BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
				Else
					cQrySZY += ENTER + " AND SZY.ZY_DTDIGIT BETWEEN '" + DTOS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' "
				EndIf
				if MV_PAR06 == 1
		 			If !lJuros
		 				cQrySZY += ENTER + " AND SZY.ZY_LA <> 'S' "
		 			EndIF
		 		Else
				 	cQrySZY += ENTER + " AND SZY.ZY_LA == 'S' "
		 		EndIf
		 		cQrySZY	+= ENTER + " AND SZY.ZY_CODSEQ = '" + TMP1->CONTRATO + "' " 
		 		cQrySZY += ENTER + " ORDER BY SZZ.ZZ_CODSEQ "
					
			    If Select("TBSZY") > 0
				     TBSZY->(DbCloseArea())
				EndIf 
				TCQUERY cQrySZY NEW ALIAS "TBSZY"
				
             While TBSZY->(!EOF())
					//SE2->(DbGoTo(TBSZY->RECSE2))      
					//Posiciona nas tabelas do Contrato para fazer a contabilização
					If TBSZY->RECSZY > 0 .And. TBSZY->RECSZZ > 0  
						SZY->(DbGoTo(TBSZY->RECSZY))			
						SZZ->(DbGoTo(TBSZY->RECSZZ))			
						//Else	
						//	SZY->(DbGoTo(TBSZY->RECNO1))
						//EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inicializa Lancamento Contabil                                   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						//Ajuste do jueros em 10/06/2016
						//If lJuros
						//	nHdlPrv := HeadProva( cLote,;
						//                     "ADGFIN01" /*cPrograma*/,;
						//                      Substr( cUsuario, 7, 6 ),;
						//                      @cArquivo )
						//Else
						If nHdlPrv == 0                  
							//cArquivo := ""
							dbSelectArea("CT2")
							nHdlPrv := HeadProva( cLoteCtb,"AENDVCTB",cUserName,@cArquivo )
					    
					    EndIf
						//EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Prepara Lancamento Contabil                                      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil 
							aAdd( aFlagCTB, {"ZY_LA", "S", "SZY", SZY->( Recno() ), 0, 0, 0} )
						   //aAdd( aFlagCTB, {"ZY_DTLANC",Ddatabase,"SZY",SZY->( Recno() ), 0, 0, 0}) 
						Endif
						_nTotLan := DetProva( nHdlPrv,cPadrao,"AENDVCTB",cLoteCtb )  
						         //DetProva( nHdlPrv,cPadrao,"ADGFIN01" /*cPrograma*/,cLote,/*nLinha*/,/*lExecuta*/,/*cCriterio*/,/*lRateio*/,/*cChaveBusca*/,/*aCT5*/,/*lPosiciona*/,/*@aFlagCTB*/,/*aTabRecOri*/, /*aDadosProva*/ )
						         
						lJurLigado := .F.          
						If lJuros .And. lJurLigado
							//dbSelectArea("CT2")
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Efetiva Lan‡amento Contabil                                      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							IF nHdlPrv <> 0
								RodaProva( nHdlPrv,_nTotLan)							
								cA100Incl( cArquivo,;
								           nHdlPrv,;
								           3 /*nOpcx*/,;
								           cLoteCtb,;
								           lDigita,;
								           .F. /*lAglut*/,;
								           /*cOnLine*/,;
								           IIF(lJuros,dDataBase,dDataBase)/*dData*/,;
								           /*dReproc*/,;
								           IIF(lUsaFlag,@aFlagCTB,),;
								           /*aDadosProva*/,;
								           /*aDiario*/ ) 
							EndIf							
							If lUsaFlag           
								aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
							EndIf
							//DbCloseArea("CT2")	
							DbSelectArea("TBSZY")					
						EndIf												
					Else 
						//Caso não encontre o contrato na segunda query sai do laço e apresenta erro sem fazer nada
						EXIT
						cMsgErroCT := "Contrato Nº " + Alltrim(TMP1->CONTRATO) + " não foi localizado com os dados informados" 						
					EndIf   
					DbSelectArea("TBSZY")
					TBSZY->(DbSkip())
				EndDo        				
				//If !lJuros .And. nHdlPrv > 0 .And. Empty(Alltrim(cMsgErroCT))         
				If nHdlPrv > 0 .And. Empty(Alltrim(cMsgErroCT))         
					//dbSelectArea("CT2")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Efetiva Lan‡amento Contabil                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					RodaProva( nHdlPrv,_nTotLan)
					
					lOKCtb := cA100Incl( cArquivo,nHdlPrv,3,cLoteCtb,lDigita,.F.,,dDataBase )
						//,,IIF(lUsaFlag,@aFlagCTB,))     
						 //cA100incl( cArquivo, nHdlPrv,3,cLoteCtb,.F.,.T.,,SE3->E3_EMISSAO)	
				 	nHdlPrv  := 0
					_nTotLan := 0
					If lUsaFlag           
						aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
					EndIf
				EndIf				
			EndIf                      
			
			TMP1->(DbSkip())
		EndDo	 
		TBSZY->(DbCloseArea())
		TMP1->(DbCloseArea())   
		
		If lJuros .And. Empty(Alltrim(cMsgErroCT)) .And. nQtdAproc == nQtdproc        
		     PutMV("DG_DTCTBJU",dLastDay)	
		EndIf                                           
		IF lOKCtb
			MsgAlert("Contabilização Executada com Sucesso","Contabilização")
		EndIf
	Else
		MSGSTOP("Não selecionado nenhum registro para contabilização","Seleção Contabilização")
	EndIf		
Else
	If lPadrao .And. !lContProc
  		MSGSTOP("Processamento de Juros já realizado para o preiodo informado:" + DTOC(dDtProcJ),"Periodo de Processamento")
	Else
		MSGSTOP("Não Existe o Lançamento Padrão para seguir com a contabilização","Lançam.Padrão Inexistente")
	EndIf
EndIf

Else
	MsgStop("Não foi encontrado o arquivo SX1-Perguntas Parâmetros para essa rotina.")
EndIf //Fim do If da validação das Perguntas

Return lRetCtb
                      
//Buscar o Valor contabilização
User Function ADGFBVLR(nTpVlr,lCurtLong,cRefCont1,cRefCont2)      
//Local nVlrRet := 0
Local lAchouContr := .F.
                      
Default nTpVlr := 1 //1=Principal  2=Juros  3=Juros Varialvel  4= IOF
Default lCurtLong := .F. //Atualização do curto e longo prazo
Default cRefCont1 := ""
Default cRefCont2 := ""

If !Empty(cRefCont1) 
	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))
	If SZY->(DbSeek(xFilial("SZY")  + cRefCont1))
	     lAchouContr := .T.
	EndIf
	If !lAchouContr .And. SZY->(DbSeek(xFilial("SZY")  + cRefCont2)) 
		lAchouContr := .T.
	EndIf         	
Endif

If nTpVlr == 1 //Valor Principal da Parcela
	cQrySZZ := " SELECT " 
	cQrySZZ += ENTER + " 'TOTAL' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRPRIN) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
	cQrySZZ += ENTER + " WHERE SZZ.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "            
	cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
	cQrySZZ += ENTER + " 	UNION ALL "
	cQrySZZ += ENTER + " SELECT 'CURTO' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRPRIN) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ1 "
	cQrySZZ += ENTER + " WHERE SZZ1.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "   
 	If lCurtLong
 		//cQrySZZ += ENTER + " AND SZZ1.ZZ_VRPGPAR = 0 "
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  = ( "
 	  	cQrySZZ += ENTER + " 							SELECT ZZ_NROPAR + 12 FROM " + RetSqlName("SZZ") + " SZZ11 "
		cQrySZZ += ENTER + " 							 WHERE SZZ11.D_E_L_E_T_ = '' AND SZZ11.ZZ_FILIAL  ='" + xFilial("SZZ") + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "
		//cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_VRPGPAR = 0  "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_NPARSE2 = '" + SE2->E2_PARCELA + "' ) " 		
 		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
 	Else 
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  <= '012' "       
		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO  "
		cQrySZZ += ENTER + " 	UNION ALL "
		cQrySZZ += ENTER + " SELECT'LONGO' TP_PRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRPRIN) VALORRET "
		cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ2 "
		cQrySZZ += ENTER + " WHERE SZZ2.D_E_L_E_T_ <>  '*' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "	 
 		cQrySZZ += ENTER + " AND SZZ2.ZZ_NROPAR  > '012' "
 		cQrySZZ += ENTER + " GROUP BY SZZ2.ZZ_CODSEQ,SZZ2.ZZ_REVISAO " 
   EndIf
ElseIf nTpVlr == 2 //Juros
	
	cQrySZZ := " SELECT " 
	cQrySZZ += ENTER + " 'TOTAL' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURAPG) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
	cQrySZZ += ENTER + " WHERE SZZ.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "            
	cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
	cQrySZZ += ENTER + " 	UNION ALL "
	cQrySZZ += ENTER + " SELECT 'CURTO' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURAPG) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ1 "
	cQrySZZ += ENTER + " WHERE SZZ1.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "   
 	If lCurtLong
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_VRPGPAR = 0 "
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  = ( "
 	  	cQrySZZ += ENTER + " 							SELECT ZZ_NROPAR + 12 FROM " + RetSqlName("SZZ") + " SZZ11 "
		cQrySZZ += ENTER + " 							 WHERE SZZ11.D_E_L_E_T_ = '' AND SZZ11.ZZ_FILIAL  ='" + xFilial("SZZ") + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "
		//cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_VRPGPAR = 0  "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_NPARSE2 = '" + SE2->E2_PARCELA + "' ) " 		
 		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO  "
 	Else	
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  <= '012' "       
		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO  "
		cQrySZZ += ENTER + " 	UNION ALL "
		cQrySZZ += ENTER + " SELECT'LONGO' TP_PRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURAPG + ZZ_VLRJUR) VALORRET "
		cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ2 "
		cQrySZZ += ENTER + " WHERE SZZ2.D_E_L_E_T_ <>  '*' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "	 
 		cQrySZZ += ENTER + " AND SZZ2.ZZ_NROPAR  > '012' "
 		cQrySZZ += ENTER + " GROUP BY SZZ2.ZZ_CODSEQ,SZZ2.ZZ_REVISAO " 
	EndIf

ElseIf nTpVlr == 3 //Juros Variavel
	cQrySZZ := " SELECT " 
	cQrySZZ += ENTER + " 'TOTAL' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURVAR) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
	cQrySZZ += ENTER + " WHERE SZZ.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "            
	cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
	cQrySZZ += ENTER + " 	UNION ALL "
	cQrySZZ += ENTER + " SELECT 'CURTO' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURVAR ) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ1 "
	cQrySZZ += ENTER + " WHERE SZZ1.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "   
 	If lCurtLong
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_VRPGPAR = 0 "
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  = ( "
 	  	cQrySZZ += ENTER + " 							SELECT ZZ_NROPAR + 12 FROM " + RetSqlName("SZZ") + " SZZ11 "
		cQrySZZ += ENTER + " 							 WHERE SZZ11.D_E_L_E_T_ = '' AND SZZ11.ZZ_FILIAL  ='" + xFilial("SZZ") + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "
		//cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_VRPGPAR = 0  "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_NPARSE2 = '" + SE2->E2_PARCELA + "' ) " 		
 		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO   "
 	Else	
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  <= '012' "       
		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO  "
		cQrySZZ += ENTER + " 	UNION ALL "
		cQrySZZ += ENTER + " SELECT'LONGO' TP_PRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VJURVAR) VALORRET "
		cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ2 "
		cQrySZZ += ENTER + " WHERE SZZ2.D_E_L_E_T_ <>  '*' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "	 
 		cQrySZZ += ENTER + " AND SZZ2.ZZ_NROPAR  > '012' "
 		cQrySZZ += ENTER + " GROUP BY SZZ2.ZZ_CODSEQ,SZZ2.ZZ_REVISAO " 
 	EndIf
ElseIf nTpVlr == 4 //IOF                                                                        
	cQrySZZ := " SELECT " 
	cQrySZZ += ENTER + " 'TOTAL' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRIOF) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
	cQrySZZ += ENTER + " WHERE SZZ.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "            
	cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
	cQrySZZ += ENTER + " 	UNION ALL "
	cQrySZZ += ENTER + " SELECT 'CURTO' TPPRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRIOF) VALORRET "
	cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ1 "
	cQrySZZ += ENTER + " WHERE SZZ1.D_E_L_E_T_ <>  '*' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
	cQrySZZ += ENTER + " AND SZZ1.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "   
 	If lCurtLong
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_VRPGPAR = 0 "
 		cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  = ( "
 	  	cQrySZZ += ENTER + " 							SELECT ZZ_NROPAR + 12 FROM " + RetSqlName("SZZ") + " SZZ11 "
		cQrySZZ += ENTER + " 							 WHERE SZZ11.D_E_L_E_T_ = '' AND SZZ11.ZZ_FILIAL  ='" + xFilial("SZZ") + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "
		//cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_VRPGPAR = 0  "
		cQrySZZ += ENTER + " 							 AND SZZ11.ZZ_NPARSE2 = '" + SE2->E2_PARCELA + "' ) " 		
 		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO "
 	Else 
	 	cQrySZZ += ENTER + " AND SZZ1.ZZ_NROPAR  <= '012' "       
		cQrySZZ += ENTER + " GROUP BY ZZ_CODSEQ,ZZ_REVISAO  "
		cQrySZZ += ENTER + " 	UNION ALL "
		cQrySZZ += ENTER + " SELECT'LONGO' TP_PRAZO,ZZ_CODSEQ,ZZ_REVISAO,SUM(ZZ_VLRIOF) VALORRET "
		cQrySZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ2 "
		cQrySZZ += ENTER + " WHERE SZZ2.D_E_L_E_T_ <>  '*' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_FILIAL = '" + xFilial("SZZ")  + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_CODSEQ = '" + SZY->ZY_CODSEQ + "' "
		cQrySZZ += ENTER + " AND SZZ2.ZZ_REVISAO = '" + SZY->ZY_REVISAO + "' "	 
	 	cQrySZZ += ENTER + " AND SZZ2.ZZ_NROPAR  > '012' "
	 	cQrySZZ += ENTER + " GROUP BY SZZ2.ZZ_CODSEQ,SZZ2.ZZ_REVISAO " 
	EndIf
EndIf 

If Select("TBSZZ") > 0 
     TBSZZ->(DbCloseArea())
EndIf         
TCQUERY cQrySZZ NEW ALIAS "TBSZZ"
aVlrRet := {0,0,0}
             
While TBSZZ->(!EOF())
   If Alltrim(TBSZZ->TPPRAZO) == "TOTAL"
       aVlrRet[1] := TBSZZ->VALORRET
   ElseIf Alltrim(TBSZZ->TPPRAZO) == "CURTO"
   	 aVlrRet[2] := TBSZZ->VALORRET
   ElseIf Alltrim(TBSZZ->TPPRAZO) == "LONGO"
   	 aVlrRet[3] := TBSZZ->VALORRET
   EndIf 
	TBSZZ->(DbSkip())
EndDo 

If Select("TBSZZ") > 0 
     TBSZZ->(DbCloseArea())
EndIf 
Return aVlrRet
 


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcção para criar o item contábil.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
User Function GERITEMC(cDgParFil)

local cIC := "EMP"

local nCont := 0
local lGrava := .F.
local lRetErro := .T.   
Local cMens	:= ""
Local aRet := {.F.,""}
Private cFilialC := IIF(!Empty(Alltrim(cDgParFil)),cDgParFil,xFilial("SZY"))
Default cDgParFil := ""

dbSelectArea ("CTD")
dbSetOrder (1)
If CTD->(Dbseek(cFilialC+"EMP"+SZY->ZY_CODSEQ))
	lGrava :=.F.
Else
	lGrava :=.T.
Endif
	cCodItem := cIC + SZY->ZY_CODSEQ 
	If RecLock("CTD",lGrava)
			CTD_FILIAL:= cFilialC
			CTD_ITEM:= cCodItem
			CTD_DESC01:= SZY->ZY_CODCONT + Alltrim(SZY->ZY_DESCEMP)
			CTD_CLASSE:= "2"
			CTD_BLOQ:= "2"
			CTD_DTEXIS:= STOD("19800101")
			CTD_ITLP:= cCodItem
			CTD_CLOBRG:= "2"
			CTD_ACCLVL:= "1"
			CTD->(MsUnlock())
			nCont++        
			cMens += "Foi criado " + Alltrim(str(nCont)) + " iten contábil " + cCodItem + ENTER 
			lRetErro := .F.
		Else
			cMens := "Não é possível gravar no momento, a rotina já está em uso." + ENTER 
			//Alert("Não é possível gravar no momento, a rotina já está em uso.")
			
			lRetErro := .T.
		Endif
		//Atualiza o Número do Item contábil no contrato
		If SZY->(FieldPos("ZY_ITEM")) > 0
			IF RecLock("SZY",.F.)
			    	SZY->ZY_ITEM := cCodItem	
			    SZY->(MsUnLock())
				 lRetErro := .F.			
			Else
				lRetErro := .T.
			EndIf
		EndIf
		//Alert("Foram criados " + Alltrim(str(nCont)) + " itens contábeis")
		
		aRet := {lRetErro,cMens,cCodItem}		
Return aRet
 
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg º Autor ³ Jackson Santos     º Data ³  15/01/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definição das Perguntas.                                   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg(cPerg)
Local aRegs := {}
Local i,j
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,len(SX1->X1_GRUPO))
	
	// Grupo/Ordem/Pergunta/Perg.Spa/Perg.Eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa01/DefEng01/Cnt01/Var02/Def02/DefSpa02/DefEng02/Cnt02/Var03/Def03/DefSpa03/DefEng03/Cnt03/Var04/Def04/DefSpa04/DefEng04/Cnt04/Var05/Def05/DefSpa05/DefEng05/Cnt05/F3/PYME/GRPSXG/HELP/PICTURE/IDFIL
	AADD(aRegs,{cPerg,"01","Mostra Lanç.Ctb:","","","mv_ch1" ,"C",01,0,0,"C",""           ,"MV_PAR01","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Periodo De:     ","","","mv_ch2" ,"D",08,0,0,"G","" 				,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Periodo Até:    ","","","mv_ch3" ,"D",08,0,0,"G",""           ,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"04","Lote:      		 ","","","mv_ch4" ,"C",06,0,0,"G","NaoVazio()" ,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"05","Sub-Lote: 		 ","","","mv_ch5" ,"C",06,0,0,"G",""           ,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SZY","","","","",""})
	AADD(aRegs,{cPerg,"06","Tipo Contabiliz.","","","mv_ch6" ,"C",01,0,0,"C",""           ,"MV_PAR06","Inclusão","","","","","Estorno","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Tipp Movimento  ","","","mv_ch7" ,"C",01,0,0,"C",""           ,"MV_PAR07","Contrato","","","","","Juros","","","","","","","","","","","","","","","","","","","","","","","",""})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
Return	


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ManutSel º Autor ³ Jackson Santos      º Data ³  18/01/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ comandos                                         .         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function ManutSel(oTela, cArquivo, cCampo, cMarca, cAcao)

	Default cAcao := "M"

	(cArquivo)->(dbGoTop())
	
	While (cArquivo)->(!Eof())
		RecLock(cArquivo,.F.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  			//³Marcar todos                                                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF cAcao == "M"
				(cArquivo)->(&cCampo) := cMarca
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  			//³DesMarcar todos                                                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIF cAcao == "L"
				(cArquivo)->(&cCampo) := ""
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  			//³Inverter selecao                                                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		  	ElseIF cAcao == "I"
		  	   (cArquivo)->(&cCampo) := IIF(Empty((cArquivo)->(&cCampo)), cMarca, "") 
		  	EndIF
			
		(cArquivo)->(MsUnlock())
		
		(cArquivo)->(dbSkip())		
	EndDo
	
	(cArquivo)->(dbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³Atualiza os dados                                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oTela:oBrowse:Refresh()

Return
