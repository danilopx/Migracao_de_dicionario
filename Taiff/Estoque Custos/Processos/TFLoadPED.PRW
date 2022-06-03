#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TFLoadPED º Autor ³  JAR              º Data ³  16/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Carrega o PV na transferencia                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ to TAIFF from ABM   - Solicitado por J Antonio             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function TFLoadPED
Local cSql    := ""
Local aLinha  := ""
Local cArmOri := ""
Local cArmDes := ""
Local cPerg   := Avkey("TFLoadPED","X1_GRUPO")
Local cAlias  := Alias()
Local aGetArea:= GetArea()

Local nPosPed := aScan(aHeader, {|x| upper(alltrim(x[2])) =="D3_NUM_PED"})

local nOpc := 1

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Inserido a funcao PADR para que o parametro sempre fique com o tamanho de 
| 6 caracteres, independente do que for preenchido pelos parametros.
|
|	Edson Hornberger - 11/08/2014
|
|=================================================================================
*/

Static oDlg
Static oButton1
Static oButton2
Static oPedVend
Static cPedVend := PADR(GetMv("MV_TFNPED", , space(6) ),6)
Static oEndOrig
Static cEndOrig := PADR(GetMv("MV_TFENDOR", , "ALMOX"),6)
Static oEndDest
Static cEndDest := PADR(GetMv("MV_TFENDDE", , "TERC"),6)
Static oSay1
Static oSay2
Static oSay3

//Carrega Perguntas
//Pergunta 01
aHelpPor := {}
aAdd( aHelpPor, "Informe o numero do " )
aAdd( aHelpPor, "Pedido de Venda" )
PutSx1(cPerg, "01", "Num do Ped Venda", "Num do Ped Venda", "Num do Ped Venda", "mv_ch1", "C", 06, 0, 0, "G", "", "", "", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5", "", "", aHelpPor, aHelpPor, aHelpPor)
   
//Pergunta 02
aHelpPor := {}
aAdd( aHelpPor, "Informe o Endereço" )
aAdd( aHelpPor, "de origem" )
PutSx1(cPerg, "02", "End Origem", "End Origem", "End Origem", "mv_ch2", "C", 06, 0, 0, "G", "", "", "", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor) 
 
//Pergunta 03
aHelpPor := {}
aAdd( aHelpPor, "Informe o Endereço" )
aAdd( aHelpPor, "de destino" )
PutSx1(cPerg, "03", "End Destino", "End Destino", "End Destino", "mv_ch3", "C", 06, 0, 0, "G", "", "", "", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor, aHelpPor, aHelpPor)     

cArmOri := GetMv("MV_TPVAPORI", , "02")  
If Empty(cArmOri)
	MsgAlert("Parametro MV_TPVAPORI não criado ou não preenchido.")
	Return
EndIf
      
cArmDes := GetMv("MV_TPVARDES", , "03")  
If Empty(cArmOri)
	MsgAlert("Parametro MV_TPVARDES não criado ou não preenchido.")      	
	Return
EndIf     

DEFINE MSDIALOG oDlg TITLE "Endereçamento" FROM 000, 000  TO 150, 350 COLORS 0, 16777215 PIXEL

@ 009, 008 SAY oSay1 PROMPT "Num do Pedido:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 009, 048 MSGET oPedVend VAR cPedVend SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 026, 008 SAY oSay2 PROMPT "End Origem:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 025, 048 MSGET oEndOrig VAR cEndOrig SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 042, 010 SAY oSay3 PROMPT "End Destino: " SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 040, 048 MSGET oEndDest VAR cEndDest SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL

DEFINE SBUTTON FROM 009, 122 TYPE 01 ENABLE OF oDlg ACTION (nOpc := 1, oDlg:End())
DEFINE SBUTTON FROM 030, 122 TYPE 02 ENABLE OF oDlg ACTION (nOpc := 0, oDlg:End())

ACTIVATE MSDIALOG oDlg

if nOpc == 1 .and. !Empty( cPedVend )
//If Pergunte(cPerg) .And. !Empty(MV_PAR01)   
// por causa de conflitos as variaveis foram substituidas
// mv_par01 -> cPedVend
// mv-par02 -> cEndOrig
// mv_par03 -> cEndDest

	if (Posicione("SC5",1,xFilial("SC5")+cPedVend,"C5_TIPO") <> "B")
		MsgInfo("O pedido informado não é do tipo 'B'")
		Return nil	
	endif
	
	if !Empty( Posicione("SC6",1,xFilial("SC6")+cPedVend,"C6_DOC_END") )
		MsgInfo("O pedido já foi Transferido")
		Return nil		
	endif
 
	cSQL := "SELECT SC6.*, "
	cSQL += "(SC6.C6_QTDVEN - SC6.C6_QTDENT) QTD_DISP, "
	cSQL += "(SC6.C6_UNSVEN - SC6.C6_QTDENT2) QTD_DISP2 "	
	cSQL += "from " + RetSqlName("SC6") + " SC6 "
	cSQL += "WHERE (SC6.C6_QTDVEN - SC6.C6_QTDENT) > 0 AND SC6.C6_NUM = '" + cPedVend + "' "
	cSQL += "AND SC6.D_E_L_E_T_ <> '*' "	
	cSQL += "ORDER BY SC6.C6_ITEM"

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cSql), "TMPC6", .T., .T.) 
	aLinha := aClone(aCols[1])	
	
	TMPC6->( DbGotop() )
	while !TMPC6->( eof() )
		if (Posicione("SF4",1,xFilial("SF4")+TMPC6->C6_TES,"F4_ESTOQUE") == "S")    
		
			PutMv("MV_TFENDOR", cEndOrig)
			PutMv("MV_TFENDDE", cEndDest)   
		
			//nPosCod1    := 1                      Codigo do Produto Origem
	   		//nPosDes1    := 2                      Descricao do Produto Origem
			//nPosUm1     := 3                      Unidade de Medida Origem
			//nPosLoc1    := 4                      Armazem Origem
			//nPosLcz1    := 5                      Localizacao Origem
			//nPosCod2    := 6                      Codigo do Produto Destino
			//nPosDes2    := 7                      Descricao do Produto Destino
			//nPosUm2     := 8                      Unidade de Medida Destino
			//nPosLoc2    := 9                      Armazem Destino
			//nPosLcz2    := 10                     Localizacao Destino
			//nPosNumSer := 11                      Numero de Serie
			//nPosLotCTL := 12                      Lote de Controle
			//nPosLote    := 13                     Numero do Lote
			//nPosDValid := 14                      Data Valida
			//nPosPotenc := 15                      Potencia
			//nPosQuant   := 16                     Quantidade
			//nPosQSUm1   := 17                     Quantidade na 2a. Unidade de Medida
			//nPosEstor   := 18                   	Estorno S/N
		
			aTail(aCols)[1]  := TMPC6->C6_PRODUTO   
			aTail(aCols)[2]  := TMPC6->C6_DESCRI   			
			aTail(aCols)[3]  := TMPC6->C6_UM   			
			aTail(aCols)[4]  := cArmOri
			aTail(aCols)[5]  := alltrim( cEndOrig )
			aTail(aCols)[6]  := TMPC6->C6_PRODUTO
			aTail(aCols)[7]  := TMPC6->C6_DESCRI
			aTail(aCols)[8]  := TMPC6->C6_UM   
			aTail(aCols)[9]  := cArmDes
			aTail(aCols)[10] := alltrim( cEndDest )
			aTail(aCols)[11] := ""
			aTail(aCols)[12] := ""
			aTail(aCols)[13] := ""
			aTail(aCols)[14] := ctod(" / / ") 
			aTail(aCols)[15] := 0 
			aTail(aCols)[16] := TMPC6->QTD_DISP  
			aTail(aCols)[17] := TMPC6->QTD_DISP2 
			aTail(aCols)[18] := "" 			

			aTail(aCols)[nPosPed]  := TMPC6->C6_NUM+TMPC6->C6_ITEM+TMPC6->C6_PRODUTO		

			aAdd(aCols, aClone(aLinha))	  
		else
			MsgInfo( "TES não permite movimentação do estoque" )
		endif	
		TMPC6->( DbSkip() )	
	enddo
    TMpC6->( DBCloseArea() )
endif

RestArea(aGetArea)
DbSelectArea(cAlias)

return

