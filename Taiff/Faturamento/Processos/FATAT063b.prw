#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'
#DEFINE ENTER Chr(13)+Chr(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATAT063  ºAutor  ³Carlos Torres       º Data ³  17/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retransmite e-mail da carga do CROSS DOCKING               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TFAT063b()

Private cPerg			:= "FTAT63a"
Private oGeraNf
Private cLaPerg 		:= "TFIMPCARGA"

TCriaSx1Perg( cLaPerg )

ValidPerg(cPerg)

@ 200,001 TO 480,380 DIALOG oGeraNf TITLE OemToAnsi("Retransmissão de e-mail")
@ 003,005 TO 085,187 PIXEL OF oGeraNf
@ 010,018 Say "Este programa ira retransmitir e-mail dos pedidos agrupados." SIZE 150,010 PIXEL OF oGeraNf
@ 065,008 BUTTON "Continua  "  ACTION (Processa({|| ConsEmail() }),oGeraNf:End())PIXEL OF oGeraNf
@ 100,008 BMPBUTTON TYPE 02 ACTION oGeraNf:End()

Activate Dialog oGeraNf Centered
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALIDPERG ºAutor  ³Microsiga           º Data ³  11/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDPERG(cPerg)
Local cKey 		:= ""
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

PutSx1(cPerg,"01"   ,"Código da Carga?",""                    ,""                    ,"mv_ch1","C"   ,12      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

cKey     := "P.FTAT63a01."
aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
aAdd(aHelpPor,"Informe o código da carga ")
aAdd(aHelpPor,"encaminhado por e-mail (workflow)")
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return

/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal
--------------------------------------------------------------------------------------------------------------
*/
Static Function TCriaSx1Perg(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 

Aadd( aHelpPor, "Informe o numero da carga" )
Aadd( aHelpEng, "Informe o numero da carga" )
Aadd( aHelpSpa, "Informe o numero da carga" ) 

PutSx1(cPerg,"01"   ,"Numero da Carga a emitir ?","",""	,"mv_ch1","C",12,0,0,"C","","","","",;
"mv_par01", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

RestArea(aAreaAnt)

Return()

/*
------------------------------------------------------------------------------
Cria parametro com e-mail de usuario para workflow de carga de pedido 
------------------------------------------------------------------------------
*/
Static Function TF063sx6()
Local aArea	:=	GetArea()
Local cIdUser	:= ""
Local nPosFim	:= 0
Local nMaxFim	:= 0
Local nPassagem:=0 

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_FATA063" )
	RecLock("SX6", .T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "TF_FATA063"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "e-mail do responsavel pelo faturamento dos pedidos agrupados"
	SX6->X6_DESC1	  := "no projeto do Cross Docking no fonte FATAT063"
	SX6->X6_CONTEUD := "000137;000912;001015;000095;001234;001399;001459;001458" // ;000348 (CT)
	SX6->X6_CONTSPA := "carlos.torres@taiff.com.br;odair.souza@taiff.com.br;fernando.silva@taiff.com.br"
	SX6->X6_CONTENG := "carlos.torres@taiff.com.br;odair.souza@taiff.com.br;fernando.silva@taiff.com.br"
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	MsUnlock()
EndIf
                                                                                                                                                                                                                          
cIdUser	:= Alltrim(GetNewPar("TF_FATA063","")) 
nMaxFim	:= Len(cIdUser)
cMailDest := ""

nPassagem:=0 
While Len(cIdUser) > 0
	nPosFim := At(";",cIdUser)
	If nPosFim = 0
		nPosFim := Len(cIdUser)
	Else
		nPosFim -= 1
	EndIf
	
	cMailDest += 	UsrRetMail( Substr(cIdUser,1,nPosFim) ) + ";"
	

	If nPosFim = 0
		cIdUser := "" 
	Else
		cIdUser := Substr(cIdUser,nPosFim+2,nMaxFim)
	EndIf
	
	nPassagem++
	IF nPassagem>1000
		cIdUser := "" 
	ENDIF
End

RestArea(aArea)
Return (cMailDest)

/*
------------------------------------------------------------------------------
Apresenta o volume da carga dos pedidos selecionados
------------------------------------------------------------------------------
*/
Static Function ConsEmail()
Local cHtml := ""
Local cMarca := ""
Local cNumPedido := ""
Local cMailDest := ""

If !Pergunte(cPerg,.T.)
	Return(.T.)
Endif

SC9->(DBORDERNICKNAME("SC9_NUMOF"))
SC9->(DbSeek( xFilial("SC9") + MV_PAR01 ))

SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5") + SC9->C9_PEDIDO))

SA4->(DbSetorder(1))
SA4->(Dbseek( xFilial("SA4") + SC5->C5_TRANSP ))


If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
	cHtml := '<H1>Processo de Cross Docking - T E S T E</H1>'
Else
	cHtml := '<H1>Processo de Cross Docking</H1>'
EndIf

If At("ATIVA",SA4->A4_NOME) != 0 
	cHtml += '<H3>Transportadora: ATIVA</H3>' 
ElseIf  At("FRIBURGO",SA4->A4_NOME) != 0  
	cHtml += '<H3>Transportadora: FRIBURGO</H3>' 
ELSE 
	cHtml += '<H3>Transportadora: </H3>' 
EndIf

cHtml += '<table border="1"><tr><th>Marca</th><th>Carga</th><th>Pedido MG</th><th>Cliente</th><th>Pedido SP</th></tr>'


While SC9->(C9_FILIAL + C9_NUMOF) = xFilial("SC9") + MV_PAR01 .AND. !SC9->(Eof())

	cMarca := ""
	If SC9->C9_XITEM="1" 
		cMarca := "TAIFF"
	ElseIf SC9->C9_XITEM="2"
		cMarca := "PROART"
	EndIf
	
	cHtml += '<tr><td>' + cMarca + '</td><td>' + SC9->C9_NUMOF + '</td><td>' + SC9->C9_PEDIDO + '</td><td>' + SC9->C9_NOMORI + '</td><td>' + SC9->C9_PEDORI + '</td></tr>'
	cNumPedido := SC9->C9_PEDIDO
	
	While SC9->(C9_FILIAL + C9_NUMOF + C9_PEDIDO) = xFilial("SC9") + MV_PAR01 + cNumPedido .AND. !SC9->(Eof())
	
		SC9->(DbSkip())
	End
End

cHtml += '</table>'
Memowrite("Carga_Cross_Docking.HTML",cHtml)

	cMailDest := TF063sx6()
	//cMailDest += Iif( .not. Empty(cMailDest),";","") + Alltrim(UsrRetMail(RetCodUsr()))
	
	//cMailDest := "carlos.torres@taiffproart.com.br"	 		
	
	U_2EnvMail("workflow@taiff.com.br",RTrim(cMailDest)	,'',cHtml	,"Pedidos do CD para faturamento" + Iif( At( "DESENV",GetEnvServer()) != 0," TESTE",""),'')
	
	MsgBox("E-mail enviado. Verifique caixa de correios","Atençao","ALERT")

Return
