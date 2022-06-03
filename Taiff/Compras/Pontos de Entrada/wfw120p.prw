#include "rwmake.ch"
#include "Protheus.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFW120P   ºAutor  ³Ewerton C Tomaz     º Data ³  04/04/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada no Pedido de Compra após a gravacao       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFW120P()

Local lPreco := .F.
Local aArea  := GetArea()
Local lQuant := .F.
Local cPeg		:= ""
Local nDiasPed		:= TFaprsx6()
Local _cRspLiber	:= ""
Local nAjuste		:= 0
Local cMensTb		:= ""
Local cTipoBlq		:= ""
Local cDESCR 		:= Space( 250 )
Local oDESCR
Local oDLG1

Private nPrGerAp	:= 0
Private nPrCtrAp	:= 0

U_TFrstsx6() // Carrega percentuais de aprovação

//NA ROTINA AUTOMATICA COLOCA O CAMPO PEG COMO NAO
If IsInCallStack("U_COMMI005")
	cPeg := "Nao"
EndIf

If IsInCallStack("U_TFCOM001") 
	Return(.T.)
EndIf

AIB->(DbSetOrder(2))



lPreco	:= .F.
cPedCo := SC7->C7_NUM
dbSelectArea("SC7")
nRecC7 := Recno()
dbSetOrder(1)
dbSeek(xFilial()+cPedCo)
While !Eof() .And. SC7->C7_NUM == cPedCo
	cTipoBlq	:= ""
	/* Validação - calcular o percentual de variação */
	If !Empty(SC7->C7_CODTAB)
		/* Compara a variação de preço com o preço da tabela de preço */
		If AIB->(DbSeek( xFilial("AIB") + SC7->(C7_FORNECE + C7_LOJA + C7_CODTAB + C7_PRODUTO) ))
			If AIB->AIB_PRCCOM = SC7->C7_PRECO
				nAjuste	 := 0
				lPERGUNTA	:= .F.
			ElseIf AIB->AIB_PRCCOM < SC7->C7_PRECO
				nAjuste :=  ((SC7->C7_PRECO/AIB->AIB_PRCCOM)-1)*100
			ElseIf AIB->AIB_PRCCOM > SC7->C7_PRECO
				nAjuste :=  (1-(SC7->C7_PRECO/AIB->AIB_PRCCOM))*100
			EndIf
			If ((( nAjuste > nPrGerAp .AND. nAjuste < nPrCtrAp ) .OR. nPrGerAp = 0) .AND. Empty(_cRspLiber) ) .AND. nAjuste != 0
				_cRspLiber := "GER"
				lPreco		:= .T.
				cTipoBlq	:= "MGR"
				lPERGUNTA	:= .T.
			ElseIf (( nAjuste >= nPrCtrAp ) .OR. nPrCtrAp = 0) .AND. nAjuste != 0 
				_cRspLiber := "CTR"
				lPreco		:= .T.
				cTipoBlq	:= "MCT"
				lPERGUNTA	:= .T.
			EndIf
			If lPreco .AND. lPERGUNTA
				cDESCR := U_TFwfwCarga() 
				DEFINE MSDIALOG oDlg1 TITLE "Justificativa de alteração" FROM 0,0 TO 155,825 PIXEL
				@ 10,08 SAY "Justificativa de alteração do item " + SC7->C7_ITEM + " - " + Alltrim(SC7->C7_PRODUTO) + ":" SIZE 195, 7 OF oDlg1 PIXEL
				@ 18,08 GET oDESCR VAR cDESCR SIZE 400, 22 OF oDlg1 COLOR CLR_GREEN MEMO PIXEL
				
				DEFINE SBUTTON FROM 55, 200 TYPE 1 ACTION ( IIf( Empty( cDESCR ), ( MsgInfo( "Informe a justificativa da alteração do preço", "Aviso" ), oDESCR:SetFocus() ), {U_TFwfwJUST(cDESCR),oDlg1:End()} ) ) ENABLE OF oDlg1
				ACTIVATE MSDIALOG oDlg1 CENTERED VALID IIf( Empty( cDESCR ), ( MsgInfo( "Informe a justificativa da alteração do preço", "Aviso" ), oDESCR:SetFocus(), .F. ), .T. )
			Endif				
		EndIf
	
		/* 2ª Validação - calcular a data da ultima alteração */
		If !Empty(SC7->C7_ULTALTP) .AND. Empty(_cRspLiber) 
			If SC7->C7_ULTALTP >= (Ddatabase - nDiasPed)
				_cRspLiber := "GER"
				//lPreco		:= .T.		
				cTipoBlq	:= "DTA"
			EndIf
		EndIf
	
	EndIf
	
	//RecLock("SC7",.F.)
	//SC7->C7_TIPOBLQ := cTipoBlq
	//SC7->(MsUnlock())
	
	dbSelectArea("SC7")
	dbSkip()
End

cMens := ""

//ATUALIZA O PEDIDO COM O BLOQUEIO DE PRECO
If lPreco .Or. lQuant
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+cPedCo)
	While !Eof() .And. SC7->C7_NUM == cPedCo
		If lPreco
			RecLock("SC7",.F.)
			SC7->C7__BLOQP		:= "P"
			SC7->C7__DLIB1		:= Ctod("")
			SC7->C7_CONAPRO	:= "B"
			SC7->C7_RESPLIB	:= _cRspLiber
			SC7->C7_ULTALTP	:= dDataBase
			SC7->(MsUnlock())
		EndIf
		If SC7->C7_PRECO == 0
			cMens += "Linha : " + SC7->C7_ITEM + ENTER
		EndIf
		dbSelectArea("SC7")
		dbSkip()
	End
	
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+"PC"+cPedCo)
	While !Eof() .And. SCR->CR_NUM == cPedCo
		RecLock("SCR",.F.)
		SCR->CR_STATUS:= "02"
		SCR->(MsUnlock())
		dbSelectArea("SCR")
		dbSkip()
	End
	//QUANDO FOR ROTINA AUTOMATICA NAO EXIBE MENSAGEM
	If !IsInCallStack("U_COMMI005")
		MsgAlert("Este pedido está com bloqueio: " + ENTER + "..ou de preco " + ENTER + "..ou quantidade " + ENTER + "..ou tempo desde a ultima alteração" + ENTER + "..ou sem tabela de preço" + ENTER + "Solicitar sua liberação junto a " + Iif( _cRspLiber="GER","Gerencia","Controladoria") + "!" + ENTER + cMensTb ,"WFW120P")
	EndIf
ElseIf ALTERA
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(xFilial()+cPedCo)
	While !Eof() .And. SC7->C7_NUM == cPedCo
		If SC7->C7_PRECO == 0
			cMens += "Linha : " + SC7->C7_ITEM + ENTER
		EndIf
		RecLock("SC7",.F.)
		C7__BLOQP := " "
		C7__BLOQQ := " "
		C7__ULIB1 := ""
		C7__DLIB1 := cTod("")
		C7__HLIB1 := ""
		C7__PLIB1 := ""
		C7_RESPLIB:= ""
		C7_ULTALTP	:= dDataBase
		SC7->(MsUnlock())
		dbSelectArea("SC7")
		dbSkip()
	End
EndIf

If !Empty(cMens)
	MsgStop("Valor Unitário zero nas linhas "+cMens,"MT120OK")
EndIf
RestArea(aArea)
Return(.T.)

/*
------------------------------------------------------------------------------
Cria parametro de restrição de dias na alteração de preço no pedido de compra 
------------------------------------------------------------------------------
*/
Static Function TFaprsx6()
Local aArea	:=	GetArea()
Local nCMPdias	:= 0 

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMPDPED" )
	RecLock("SX6", .T.)
	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "TF_CMPDPED"
	SX6->X6_TIPO		:= "N"
	SX6->X6_DESCRIC	:= "Numero de dias de restrição na alteração de preço "
	SX6->X6_DESC1		:= "no pedido de compra."
	SX6->X6_CONTEUD	:= "180"
	SX6->X6_CONTSPA	:= ""
	SX6->X6_CONTENG	:= ""
	SX6->X6_PROPRI		:= "U"
	SX6->X6_PYME		:= "S"
	MsUnlock()
EndIf
                                                                                                                                                                                                                          
nCMPdias := GetNewPar("TF_CMPDPED",90) 

RestArea(aArea)
Return (nCMPdias)

/*
------------------------------------------------------------------------------
Cria parametro com percentual de restrição para aprovação do Gerente/Controler 
------------------------------------------------------------------------------
*/
User Function TFrstsx6()
Local aArea	:=	GetArea()

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMGERPD" )
	RecLock("SX6", .T.)
	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "TF_CMGERPD"
	SX6->X6_TIPO		:= "N"
	SX6->X6_DESCRIC	:= "Percentual da variação da alteração de preço no pe"
	SX6->X6_DESC1		:= "dido de compra para envio de aprovação do gerente."
	SX6->X6_CONTEUD	:= "0,5"
	SX6->X6_CONTSPA	:= ""
	SX6->X6_CONTENG	:= ""
	SX6->X6_PROPRI		:= "U"
	SX6->X6_PYME		:= "S"
	MsUnlock()
EndIf
nPrGerAp	:= Val(SX6->X6_CONTEUD)
                                                                                                                                                                                                                          
dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMCTRPD" )
	RecLock("SX6", .T.)
	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "TF_CMCTRPD"
	SX6->X6_TIPO		:= "N"
	SX6->X6_DESCRIC	:= "Percentual da variação da alteração de preço no pe"
	SX6->X6_DESC1		:= "dido de compra para envio de aprovação da controla"
	SX6->X6_DESC2		:= "doria."
	SX6->X6_CONTEUD	:= "3"
	SX6->X6_CONTSPA	:= ""
	SX6->X6_CONTENG	:= ""
	SX6->X6_PROPRI		:= "U"
	SX6->X6_PYME		:= "S"
	MsUnlock()
EndIf
nPrCtrAp	:= Val(SX6->X6_CONTEUD) 

RestArea(aArea)
Return NIL

/*
------------------------------------------------------------------------------
Inclusão de texto em ZZM e ZZN 
------------------------------------------------------------------------------
*/

User Function TFwfwJUST( cTexto )

Local cChave := "SC7" + SC7->(C7_FILIAL + C7_NUM + C7_ITEM )
ZZM->( DbSetOrder( 1 ) )
If ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
	RecLock( "ZZM", .F. )
Else
	RecLock( "ZZM", .T. )
EndIf
ZZM->ZZM_FILIAL := xFILIAL( "ZZM" )
ZZM->ZZM_CHAVE  := cCHAVE
ZZM->ZZM_ITEM   := StrZero( 1, 2 )
ZZM->ZZM_ARQUIV := "WFW120P.PRW"
ZZM->ZZM_DESCR  := cTexto
ZZM->ZZM_ACESSO := "1"
ZZM->( MsUnLock() )
	
Return NIL

User Function TFwfwCarga()
Local cTexto := ""
Local cChave := "SC7" + SC7->(C7_FILIAL + C7_NUM + C7_ITEM )
ZZM->( DbSetOrder( 1 ) )
If ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
	cTexto := Alltrim(ZZM->ZZM_DESCR)   
EndIf
	
Return (cTexto)

