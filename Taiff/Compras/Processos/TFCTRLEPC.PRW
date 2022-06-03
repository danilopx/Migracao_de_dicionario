#include 'protheus.ch'


/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFCTRLEPC	ºAutor  ³WAGNER MONTENEGRO   º Data ³  03/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Controle de Entregas Pedidos de Compra                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF - Todas Empresas				                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFCTRLEPC()
Local aPos := {000,000,200,538}
Local nModelo := 3
Local lF3 := .F.
Local lMemoria := .T.
Local lColumn := .F.                                                               
Local caTela := ""
Local lNoFolder := .F.
Local lProperty 
Local nX,nY
Local oGroup,oFont
LOCAL aTELA[0][0]
LOCAL aGETS[0]
Local aAreaSC7:=GetArea()
Local oDlgPsq,oBuscaOk
Private oSButCan
Private aIndex		:= {} 
Private aIndexSC7 := {} 
Private cCondSC7	:= ""
Private bFiltraSC7 :={|| FilBrowse("SC7",@aIndexSC7,@cCondSC7)}
Private oPanel1,oPanel2,oPanel3,oPanel4,oPanel5,oPanel6
Private aCpoSC7:= {}
Private aSizeSC7:={}
Private aCpoEnch:= {}
Private aAltSC7:= {}
Private aAlterEnch	:= {}
Private aPadraoSC7	:= {}
Private oGetD
Private aXTELA[0][0]
Private aXGETS[0]
Private bRefresh
Private nOpca 	 := 0
Private oDlg,oDlg1
Private oFolder
Private oEntrega,oFornece,oLoja,oSolici,oPedido
Private dEntrega:=ctod("")
Private dEntrega2:=dDataBase
Private cForn:=SPACE(TAMSX3("C7_FORNECE")[1])
Private cLoja:=SPACE(TAMSX3("C7_LOJA")[1])
Private cPC:=SPACE(TAMSX3("C7_NUM")[1])
Private cSC:=SPACE(TAMSX3("C7_NUMSC")[1])
Private oButton01,oButton02

Private aFolder 	:= { "Pedidos de Compras" }

DbSelectArea("SC7")
DBORDERNICKNAME("TFCTRLEPC")
SC7->(DbGoTop())

DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD 

oDlg1:=TDialog():New(00,00,036,145,"Compras - Previsão de Entregas",,,,,CLR_BLACK,CLR_WHITE,,,.F.)

oFolder := TFolder():New( 24, 4, aFolder, aFolder, oDlg1,,,, .T., ,566, 228 )
oPanel0 := TPanel():New(00,00,'',oDlg1,, .T., .T.,CLR_BLACK,CLR_HGRAY,578, 024,.F.,.F. )
oPanel1 := TPanel():New(00,00,'',oFolder:aDialogs[1],, .T., .T.,CLR_BLUE,CLR_HGRAY ,564,224,.F.,.F. )

@ 002 , 007 GROUP oGroup TO 024,062 LABEL "D.Entrega de"  OF oPanel0 PIXEL	
@ 002 , 069 GROUP oGroup TO 024,124 LABEL "D.Entrega até"  OF oPanel0 PIXEL
@ 002 , 132 GROUP oGroup TO 024,174 LABEL "Ped.Compra" OF oPanel0 PIXEL
@ 002 , 182 GROUP oGroup TO 024,237 LABEL "Cod.Forn./Loja" OF oPanel0 PIXEL
@ 002 , 245 GROUP oGroup TO 024,298 LABEL "Sol.Compra" OF oPanel0 PIXEL
oGroup:oFont:= oFont  

@ 009 , 010.2 MSGET oEntrega Var dEntrega	Valid UpdBusca(dEntrega,0) 		PICTURE PesqPict("SC7","C7_DATPRF") 	SIZE 050,10 OF oPanel0 PIXEL FONT oFont
@ 009 , 072.2 MSGET dEntrega2	Valid UpdBusca(dEntrega2,1) 		PICTURE PesqPict("SC7","C7_DATPRF") 	SIZE 050,10 OF oPanel0 PIXEL FONT oFont
@ 009 , 134.2 MSGET cPC  		Valid UpdBusca(cPC,2) 				SIZE 42,10 	OF oPanel0 PIXEL FONT oFont
@ 009 , 184.2 MSGET cForn	  	F3 "SA2" Valid UpdBusca(cForn,3) PICTURE PesqPict("SC7","C7_FORNECE") 	SIZE 030,10 OF oPanel0 PIXEL FONT oFont 
@ 009 , 218.2 MSGET cLoja	  	When .F. 								PICTURE PesqPict("SC7","C7_LOJA") 		SIZE 017,10 OF oPanel0 PIXEL FONT oFont
@ 009 , 247.2 MSGET cSC 		Valid UpdBusca(cSC,4) 				PICTURE PesqPict("SC7","C7_NUMSC")		SIZE 50,10 	OF oPanel0 PIXEL FONT oFont
//oBrowSC7	:= BrGetDDB():New(00,00,565,214,,,,oPanel1,cCondSC7,,,,{||UTFDbClic2()},,,,CLR_BLUE,CLR_WHITE,,.F.,'SC7',.T.,/,.F.,,, )
oBrowSC7	:= BrGetDDB():New(00,00,565,214,,,,oPanel1,cCondSC7,,,/*{||UTFChange()}*/,{||UTFDbClic2()},/*{||UTFClikR()}*/,,,CLR_BLUE,CLR_WHITE,/*UTFMens()*/,.F.,'SC7',.T.,/*{||UTFWhen()}*/,.F.,/*{||UTFValid()}*/,, )
oBrowSC7:bDelOk:={||.t.} 

oPanel1:Hide()
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_FILIAL" 		)[1],{||SC7->C7_FILIAL	},PESQPICT("SC7","C7_FILIAL")		,,,'LEFT' ,TAMSX3("C7_FILIAL")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_FORNECE" 	)[1],{||SC7->C7_FORNECE	},PESQPICT("SC7","C7_FORNECE")	,,,'LEFT' ,TAMSX3("C7_FORNECE")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_LOJA" 		)[1],{||SC7->C7_LOJA		},PESQPICT("SC7","C7_LOJA")		,,,'LEFT' ,TAMSX3("C7_LOJA")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_DESCFOR"		)[1],{||Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")	},PESQPICT("SC7","C7_DESCFOR")	,,,'LEFT' ,TAMSX3("C7_DESCFOR")[1]	,.F.,.F.,,,,.F.,))      
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_NUM" 			)[1],{||SC7->C7_NUM		},PESQPICT("SC7","C7_NUM")			,,,'LEFT' ,TAMSX3("C7_NUM")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_EMISSAO" 	)[1],{||SC7->C7_EMISSAO	},PESQPICT("SC7","C7_EMISSAO")	,,,'LEFT' ,TAMSX3("C7_EMISSAO")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_ITEM" 		)[1],{||SC7->C7_ITEM		},PESQPICT("SC7","C7_ITEM")		,,,'LEFT' ,TAMSX3("C7_ITEM")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_PRODUTO" 	)[1],{||SC7->C7_PRODUTO	},PESQPICT("SC7","C7_PRODUTO")	,,,'LEFT' ,TAMSX3("C7_PRODUTO")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_DESCRI" 		)[1],{||SC7->C7_DESCRI	},PESQPICT("SC7","C7_DESCRI")		,,,'LEFT' ,TAMSX3("C7_DESCRI")[1]	,.F.,.T.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_DATPRF" 		)[1],{||SC7->C7_DATPRF	},PESQPICT("SC7","C7_DATPRF")		,,,'LEFT' ,TAMSX3("C7_DATPRF")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_DATENT2" 	)[1],{||SC7->C7_DATENT2	},PESQPICT("SC7","C7_DATENT2")	,{|| CLR_YELLOW},{|| CLR_HGRAY},'LEFT' ,TAMSX3("C7_DATENT2")[1]	,.F.,.F.,,{|| CLR_RED },,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_QUANT" 		)[1],{||SC7->C7_QUANT	},PESQPICT("SC7","C7_QUANT")		,,,'LEFT' ,TAMSX3("C7_QUANT")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_QUJ" 			)[1],{||SC7->C7_QUJE		},PESQPICT("SC7","C7_QUJE")		,,,'LEFT' ,TAMSX3("C7_QUJE")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New("Qtde. Rec." 					 ,{|| If(Empty(SC7->C7_RESIDUO),IIF(SC7->C7_QUANT-SC7->C7_QUJE<0,0,SC7->C7_QUANT-SC7->C7_QUJE),0)},PESQPICT("SC7","C7_QUANT"),,,'LEFT',TAMSX3("C7_QUANT")[1],.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_NUMSC" 		)[1],{||SC7->C7_NUMSC	},PESQPICT("SC7","C7_NUMSC")		,,,'LEFT' ,TAMSX3("C7_NUMSC")[1]		,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_QTDSOL" 		)[1],{||SC7->C7_QTDSOL	},PESQPICT("SC7","C7_QTDSOL")		,,,'LEFT' ,TAMSX3("C7_QTDSOL")[1]	,.F.,.F.,,,,.F.,))
oBrowSC7:AddColumn(TCColumn():New(TitSX3("C7_DTENTRG" 	)[1],{||SC7->C7_DTENTRG	},PESQPICT("SC7","C7_DTENTRG")	,,,'LEFT' ,TAMSX3("C7_DTENTRG")[1]	,.F.,.F.,,,,.F.,))

bRefresh	:= {|| oDlg1:oFolder:Refresh() }

oButton01  := SButton():New(08,315,17,{||TFiltro(),oPanel1:Show()},oPanel0,.T.,"Filtrar") 
oButton02  := SButton():New(255,530,2 ,{||nOpca := 1,oDlg1:End()}	,oDlg1,.T.,"Sair") 

bBlock := { || If(nOpca==1,{||oDlg1:End()},), .T. }

oDlg1:Activate(,,,.T.,{||Eval(bBlock)},, ) 

EndFilBrw("SC7",aIndexSC7)
RestArea(aAreaSC7)
Return()


/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFiltro	ºAutor  ³WAGNER MONTENEGRO   º Data ³  03/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtro SC7										                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF - Todas Empresas				                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function TFiltro()
MsSeek(xFilial("SC7")+" "+DTOS(dEntrega))
FilBrowse("SC7",@aIndexSC7,@cCondSC7)
SC7->(DbGoTop())
Return
  
/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UTFDbClic2ºAutor  ³WAGNER MONTENEGRO   º Data ³  03/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Edição/Alteração da Data de Entrega no Duplo Click		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF - Todas Empresas				                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function UTFDbClic2()
Local lEdit	:= .F.
Local dDataPRF:=SC7->C7_DATENT2
Local cFake:=""
Local bSetGet
Local oDgl2
Local oDlgGet
Local aDim
Local oBtn
IF ( ( oBrowSC7:ColPos == 11 ) )
	   bSetGet:={|u| If(PCount()>0,dDataPRF:=u,dDataPRF)}
	   GetCellRect( @oBrowSC7 , @aDim )
		DEFINE MSDIALOG oDlg2 FROM 0,0 TO 0,0 STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL WINDOW oBrowSC7:oWnd
		oDlgGet :=TGet():New( ,	,bSetGet		,oDlg2, , 		,"@!",{||.T.,oDlg2:End()},,,,,,,,,,,,{||oDlg2:End()})
		oDlgGet2 :=TGet():New( ,,		,oDlg2, , 		,"@!",{||.T.,oDlg2:End()},,,,,,,,,,,,{||oDlg2:End()})
		oDlgGet:Move( -2 , -2 , ( ( aDim[ 4 ] - aDim[ 2 ] ) + 4 ) , ( ( aDim[ 3 ] - aDim[ 1 ] ) + 4 ) )
		oDlg2:Move( aDim[1] , aDim[2] , ( aDim[4]-aDim[2] ) , ( aDim[3]-aDim[1] ) ) 
	ACTIVATE MSDIALOG oDlg2		
		IF SC7->( !Eof() .and. !Bof() )
			If SC7->C7_DATENT2	<> dDataPRF
				lEdit	:= SC7->( RecLock( "SC7" , .F. ) )
				IF ( lEdit )
					SC7->C7_DATENT2	:= dDataPRF
				EndIF  
				SC7->( MsUnLock() )
			Endif
		EndIF
Endif
Return

/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UpdBusca	ºAutor  ³WAGNER MONTENEGRO   º Data ³  03/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Condição para Filtro SC7                            	     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF - Todas Empresas				                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION UpdBusca(xDado,n) 
	Local lRet:=.T.
	If n==0
		dEntrega:=xDado
	Elseif n==1
	dEntrega2:=xDado
	Elseif n==2
	cPC:=xDado
	Elseif n==3
	cForn:=xDado
	If !Empty(cForn)
		cLoja:=SA2->A2_LOJA
		Endif
	Else
	cSC:=xDado
	Endif
	If !Empty(dEntrega) .and. !Empty(dEntrega2)
		If Empty(cSC)
			If Empty(cForn)
			If Empty(cPC)
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0 "
				Else
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_NUM=='"+cPC+"'"
				Endif
			Else
			If Empty(cPC)
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_FORNECE=='"+cForn+"'"
				Else
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_NUM=='"+cPC+"' .and. C7_FORNECE=='"+cForn+"'"
				Endif
			Endif		
		Else
			If Empty(cForn)
			If Empty(cPC)
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_SOLNUM=='"+cSC+"'"
				Else
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_NUM=='"+cPC+"' .and. C7_SOLNUM=='"+cSC+"'"
				Endif
			Else
			If Empty(cPC)
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_FORNECE=='"+cForn+"' .and. C7_SOLNUM=='"+cSC+"'"
				Else
				cCondSC7:="C7_FILIAL=='"+xFilial('SC7')+"' .AND. C7_RESIDUO == ' ' .AND. C7_DATPRF >= CTOD('"+DTOC(dEntrega)+"') .AND. C7_DATPRF <= CTOD('"+DTOC(dEntrega2)+"') .and. (C7_QUANT-C7_QUJE) > 0  .and. C7_NUM=='"+cPC+"' .and. C7_FORNECE=='"+cForn+"' .and. C7_SOLNUM=='"+cSC+"'" 
				Endif
			Endif		
		Endif
	Else
	MsgAlert("Informe as datas de (Entrega de/ate)!")
	lRet:=.F.
	Endif
Return(lRet)
