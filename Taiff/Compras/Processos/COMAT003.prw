#include "rwmake.ch"
#include "Protheus.ch"

#DEFINE ENTER Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT003  บAutor  ณPaulo Bindo		 บ Data ณ  03/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBLOQUEIO PEDIDOS COMPRAS									  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function COMAT003()
Private cUsuLib
Private cCategoria := ""

//GRAVA DADOS DA ROTINA UTILIZADA
//U_CFGRD001("COMAT003")
dbSelectArea("SM0")
cUsuLib := RetCodUsr()

	dbSelectArea("SZV")
	dbSetOrder(4)
	dbSeek(xFilial()+cUsuLib)
	While !Eof() .and. ZV_CODUSU == cUsuLib
		If Alltrim(ZV_FUNCAO)="COMAT003"
			cCategoria := ZV_CATEGOR
		EndIf
		dbSkip()
	End
	
Processa( {|lEnd| COAT03(@lEnd) } ,  'Bloqueio Pedidos de Compras' , 'Aguarde, preparando dados...' , .T. )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT003  บAutor  ณMicrosiga           บ Data ณ  04/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function COAT03(lEnd)

// Local oOk		:= LoadBitMap(GetResources(), "LBOK")
// Local oNo		:= LoadBitMap(GetResources(), "LBNO")
// Local cListBox
// Local nOpc		:= 0
// Local nF4For
Local oBmp1
Local oBmp2
Local oBmp3
Local oBmp4
Local oBmp5
// Local oBmp6
// Local oBmp7
// Local oBmp8
// Local oBmp9
// Local oBmp10
Local nMargem1, nMargem2, nMargem3

Private oListBox,o1ListBox,o2ListBox,oDlgPedL
Private aPeds	:= {}
Private cCadastro :="Pedidos"
Private cQueryCad := ""
Private aFields   := {}


Private _aContadores := {{0,0,0},;   // 1 Pedidos
{0,0,0},;  	// 2 Atrasado
{0,0,0}}	  	// 3 Bloqueados


Private cPerg := 'COAT03'

ValidPerg(cPerg)

If !Pergunte(cPerg,.T.)
	Return
Endif



cQuery := " SELECT C7_FILIAL , C7_NUM ,A2_NOME, " + ENTER
cQuery += " 	C7__DLIB1,C7__PLIB1, C7__ULIB1, C7__HLIB1, " + ENTER
cQuery += " 	SUM(C7_TOTAL) C7_TOTAL, C7__BLOQP, C7__BLOQQ ," + ENTER 
cQuery += " 	MIN(C7_DATPRF )C7_DATPRF , SUM(C7__PRCPOL) C7__PRCPOL" + ENTER
cQuery += " 	,SUM(C7_QUANT*AIB_PRCCOM ) AS AIB_TOTAL " + ENTER
cQuery += " FROM "+RetSqlName("SC7")+" C7" + ENTER
cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 ON A2_COD = C7_FORNECE  " + ENTER
cQuery += " LEFT OUTER JOIN "+RetSqlName("AIB")+" AIB" + ENTER
cQuery += "  ON AIB.D_E_L_E_T_=''" + ENTER
cQuery += "  AND AIB_FILIAL='" + xFilial("AIB") + "' " + ENTER
cQuery += "  AND AIB_CODFOR=C7_FORNECE " + ENTER
cQuery += "  AND AIB_LOJFOR=C7_LOJA " + ENTER
cQuery += "  AND AIB_CODTAB=C7_CODTAB " + ENTER
cQuery += "  AND AIB_CODPRO=C7_PRODUTO " + ENTER
cQuery += " WHERE C7.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*' " + ENTER
cQuery += " AND C7_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'" + ENTER
cQuery += " AND C7_RESIDUO = ''" + ENTER
cQuery += " AND C7_COND <> 'E00'" + ENTER
cQuery += " AND C7_RESPLIB = '" + cCategoria + "'" + ENTER
//PENDENTES
If mv_par03 == 2
	cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = ''" + ENTER
ElseIf mv_par03 == 3 	//ATRASADOS
	cQuery += " AND C7_DATPRF <= '"+Dtos(dDataBase)+"'"  + ENTER
	cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = ''"	 + ENTER
ElseIf mv_par03 == 4 	//BLOQUEIO
	cQuery += " AND (C7__BLOQP <> '' OR C7__BLOQQ <> '')"  + ENTER
	cQuery += " AND C7_QUANT > C7_QUJE	 AND C7_RESIDUO = ''" + ENTER
EndIf

//FILTRA POR FORNECEDOR
If !Empty(mv_par05)
	cQuery += " AND C7_FORNECE = '" + mv_par05 + "'"  + ENTER
EndIf


cQuery += " GROUP BY C7_FILIAL , C7_NUM ,A2_NOME, C7__DLIB1, C7__PLIB1,C7__ULIB1, C7__HLIB1, C7__BLOQP, C7__BLOQQ "  + ENTER


//MONTA A ORDEM
If mv_par04 == 1 //DATA
	cQuery += " ORDER BY C7_DATPRF"
ElseIf mv_par04 == 2 //PEDIDO
	cQuery += " ORDER BY C7_FILIAL, C7_NUM"
ElseIf mv_par04 == 3 //FORNECEDOR
	cQuery += " ORDER BY C7_FORNECE"
ElseIf mv_par04 == 4 //PRODUTO
	cQuery += " ORDER BY C7_PRODUTO"
ElseIf mv_par04 == 5 //VALOR
	cQuery += " ORDER BY C7_TOTAL"
Endif

MEMOWRITE("COMAT003.SQL",cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

TcSetField("TRB","C7_EMISSAO","D")
TcSetField("TRB","C7_DATPRF","D")
TcSetField("TRB","C7__DLIB1","D")

Count To _nCount

If _nCount == 0
	//01- COR, 02-FILIAL, 03- PEDIDO, 04- NOME, 05- TOTAL, 06-LIBERADOR, 07-ENTREGA
	aAdd(aPeds,{'','','','',0,'',cTod("")})
Else
	
	Dbselectarea("TRB")
	DbGoTop()
	ProcRegua(_nCount)
	nConta := 0
	
	While !EOF()
		nConta ++
		IncProc('Processando '+AllTrim(Str(nConta))+' de '+AllTrim(Str(_nCount))+" Pedidos")
		ProcessMessages()
		If lEnd
			TRB->(DbCloseArea())
			Return
		EndIf
		
		
		dData := TRB->C7__DLIB1
		cHora := TRB->C7__HLIB1
		cLiber:= Left(TRB->C7__PLIB1,9)+" "+Left(TRB->C7__ULIB1,8)+" - "+Dtoc(dData)+" "+cHora  
		cCor := Iif(!Empty(TRB->C7__BLOQP) .And. !Empty(TRB->C7__BLOQQ) ,LoadBitMap(GetResources(),"BR_AZUL"),Iif(!Empty(TRB->C7__BLOQP) ,LoadBitMap(GetResources(),"BR_AMARELO"),Iif(!Empty(TRB->C7__BLOQQ) ,LoadBitMap(GetResources(),"BR_MARROM"),Iif(C7_DATPRF < dDataBase,LoadBitMap(GetResources(),"BR_VERMELHO"),LoadBitMap(GetResources(),"BR_VERDE")))))
		
		
		//01- COR, 02-FILIAL, 03- PEDIDO, 04- NOME, 05- TOTAL, 06-LIBERADOR, 07-ENTREGA
		aAdd(aPeds,{cCor,TRB->C7_FILIAL,TRB->C7_NUM, TRB->A2_NOME,Transform(TRB->C7_TOTAL,"@e 9,999,999.99"),cLiber,TRB->C7_DATPRF })
		
	
		// Pedidos
		_aContadores[1,1] := _aContadores[1,1] + 1
		_aContadores[1,2] += TRB->C7_TOTAL
		_aContadores[1,3] += TRB->AIB_TOTAL // TRB->C7__PRCPOL
		
		//ATRASADOS
		If C7_DATPRF < dDataBase .And. Empty(TRB->C7__BLOQP)
			_aContadores[2,1] := _aContadores[2,1] + 1
			_aContadores[2,2] += TRB->C7_TOTAL
			_aContadores[2,3] += TRB->AIB_TOTAL // TRB->C7__PRCPOL
		Endif
		
		//BLOQUEADOS
		If !Empty(TRB->C7__BLOQP)
			_aContadores[3,1] := _aContadores[3,1] + 1
			_aContadores[3,2] += TRB->C7_TOTAL
			_aContadores[3,3] += TRB->AIB_TOTAL // TRB->C7__PRCPOL
		Endif
		
		
		Dbselectarea("TRB")
		dBSkip()
	EndDo
EndIf
TRB->(DbCloseArea())


cFields := " "
nCampo 	:= 0

//01- COR, 02-FILIAL, 03- PEDIDO, 04- NOME, 05- TOTAL, 06-LIBERADOR, 07-ENTREGA
aTitCampos := {'',OemToAnsi("Filial"),OemToAnsi("Pedido"),OemToAnsi("Nome"),OemToAnsi("Total R$"),OemToAnsi("Liberador"),OemToAnsi("Entrega"),''}

cLine := "{aPeds[oListBox:nAT][1],aPeds[oListBox:nAT][2],aPeds[oListBox:nAT][3],aPeds[oListBox:nAT][4],aPeds[oListBox:nAT][5],aPeds[oListBox:nAT][6],"
cLine += " aPeds[oListBox:nAT][7],}"

bLine := &( "{ || " + cLine + " }" )
conout(_aContadores[1,2])
conout(_aContadores[1,3])

nMargem1 := Iif(_aContadores[1,3]=0 ,0,((_aContadores[1,2]/_aContadores[1,3])-1)*100)
nMargem2 := Iif(_aContadores[2,3]=0 ,0,((_aContadores[2,2]/_aContadores[2,3])-1)*100)
nMargem3 := Iif(_aContadores[3,3]=0 ,0,((_aContadores[3,2]/_aContadores[3,3])-1)*100)

@ 010,005 TO 600,780 DIALOG oDlgPedL TITLE "Pedidos Compras"
oListBox := TWBrowse():New( 3,4,370,190,,aTitCampos,,oDlgPedL,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox:SetArray(aPeds)
//oListBox:bLDblClick := { ||TKRD17BP(aPeds[oListBox:nAt,3]) }
oListBox:bLine := bLine


@ 200,347 BUTTON "Ver Pedido"      SIZE 40,15 ACTION FTA19B2(aPeds[oListBox:nAT][3],aPeds[oListBox:nAT][2]) PIXEL OF oDlgPedL
@ 220,347 BUTTON "Lib.Pedido" 		SIZE 40,15 ACTION (FTA19B5(aPeds[oListBox:nAT][3],aPeds[oListBox:nAT][2]),oListBox:Refresh()) PIXEL OF oDlgPedL
@ 250,347 BUTTON "Sair"            SIZE 40,15 ACTION Close(oDlgPedL) PIXEL OF oDlgPedL

@ 201,050 SAY "QTDE" PIXEL OF oDlgPedL
@ 201,120 SAY "$ TOTAL" PIXEL OF oDlgPedL
@ 201,190 SAY "% MARGEM" PIXEL OF oDlgPedL

@ 211,005 SAY "      PEDIDOS: " PIXEL OF oDlgPedL
@ 231,005 SAY "    ATRASADOS: " PIXEL OF oDlgPedL
@ 251,005 SAY "   BLOQUEADOS: " PIXEL OF oDlgPedL

@ 211,050 GET _aContadores[1,1] Picture '999999' SIZE 40,9 When .f. PIXEL OF oDlgPedL	//PEDIDO
@ 211,120 GET _aContadores[1,2] Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL
@ 211,190 GET nMargem1 Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL

@ 231,050 GET _aContadores[2,1] Picture '999999' SIZE 40,9 When .f. PIXEL OF oDlgPedL	//PEDIDO
@ 231,120 GET _aContadores[2,2] Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL
@ 231,190 GET nMargem2 Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL

@ 251,050 GET _aContadores[3,1] Picture '999999' SIZE 40,9 When .f. PIXEL OF oDlgPedL	//PEDIDO
@ 251,120 GET _aContadores[3,2] Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL
@ 251,190 GET nMargem3 Picture '@ER 99,999,999.99' SIZE 40,9 When .f. PIXEL OF oDlgPedL


@ 275, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgPedL Size 15,15 NoBorder When .F. Pixel
@ 275, 015 SAY "A ser entregue" OF oDlgPedL Color CLR_GREEN PIXEL

@ 275, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgPedL Size 15,15 NoBorder When .F. Pixel
@ 275, 090 SAY "Atrasado" OF oDlgPedL Color CLR_RED PIXEL

@ 275, 155 BITMAP oBmp3 ResName 	"BR_AMARELO" OF oDlgPedL Size 15,15 NoBorder When .F. Pixel
@ 275, 165 SAY "Bl.Preco" OF oDlgPedL Color CLR_RED PIXEL

@ 275, 240 BITMAP oBmp4 ResName 	"BR_MARROM" OF oDlgPedL Size 15,15 NoBorder When .F. Pixel
@ 275, 250 SAY "Bl.Quant" OF oDlgPedL Color CLR_RED PIXEL

@ 275, 325 BITMAP oBmp5 ResName 	"BR_AZUL" OF oDlgPedL Size 15,15 NoBorder When .F. Pixel
@ 275, 335 SAY "Bl.Preco e Quant." OF oDlgPedL Color CLR_RED PIXEL


ACTIVATE DIALOG oDlgPedL CENTERED


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKRD018   บAutor  ณMicrosiga           บ Data ณ  06/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG(cPerg)

// Local cKey := ""
// Local aHelpEng := {}
// Local aHelpPor := {}
// Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     	,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04		,cDefSpa4	,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01"   ,"Emissao Inicio   		?",""                    ,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"Emissao Final    		?",""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""   	,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"03"   ,"Tipo Pedido     		?",""                    ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par03","Todos"     	 ,""      ,""      ,""    ,"Pendente"      	,""     ,""      ,"Atrasado"  	,""      ,""      ,"Bloqueio" 	,""			,""     ,""    	,""    	,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"04"   ,"Ordena	      		?",""                    ,""                    ,"mv_ch4","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par04","Emissao"    	 ,""      ,""      ,""    ,"Pedido"        	,""     ,""      ,"Fornecedor"	,""      ,""      ,"Produto"  	,""			,""     ,""    	,""    	,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"05"   ,"Fornecedor      		?",""                    ,""                    ,"mv_ch5","C"   ,06      ,0       ,0      , "G",""    			,"SA2" 	,""         ,""   ,"mv_par06",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")

Return






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKRD018   บAutor  ณMicrosiga           บ Data ณ  06/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FTA19B2(cTPedido,cTFilial)
Private _cFrete := ""

SC7->(DBSETORDER(1))
if !SC7->(DbSeek(cTFilial+cTPedido,.f.))
	msgbox("Pedido nao localizado na tabela ")
	return
endif
SetKey(121 , { || U_RESTC03(aCols[n,2],cTFilial) }) // F10
VerPedido(SC7->C7_NUM,"SC7",cTFilial)
return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKRD018   บAutor  ณMicrosiga           บ Data ณ  06/04/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerPedido(_cPedOrc,_cAlias,cFilPed)
local _nVez

dbSelectArea(_cAlias)
dbsetorder(1)
dbseek(cFilPed+_cPedOrc,.f.)

_cFornece := SC7->C7_FORNECE
_cCond    := SC7->C7_COND

dbSelectArea("SX3")
dbsetorder(1)
dbseek(_cAlias,.f.)
_vItens:={}
do while sx3->(!eof().and.x3_arquivo==_cAlias)
	if Alltrim(SX3->x3_campo)$ "C7_NUM|C7_FORNECE|C7_LOJA|C7_COND"
		_cDescric:=padr(alltrim(SX3->x3_descric)+": ",28,' ')+" "
		_xConteudo:=_cAlias+"->"+sx3->x3_campo
		_xConteudo:=&_xConteudo
		if valtype(_xConteudo)=="D"
			_xConteudo:=dtoc(_xConteudo)
		elseif valtype(_xConteudo)=="N"
			_xConteudo:=padl(tran(_xConteudo,sx3->x3_picture),30)
		elseif valtype(_xConteudo)=="L"
			_xConteudo:=if(_xConteudo,".T.",".F.")
		endif
		if alltrim(sx3->x3_campo)$"C7_FORNECE"
			_xConteudo+=" "+posicione("SA2",1,xfilial("SA2")+_xConteudo,"A2_NOME")
		endif
		aadd(_vItens,_cDescric+_xConteudo)
	endif
	sx3->(dbskip(1))
enddo
cCHAVE := "SC7" + xFilial("SC7") + _cPedOrc
ZZM->( DbSetOrder( 1 ) )
If ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
	aadd(_vItens, "*** Justificativas de altera็ใo de pre็o ***" )
EndIf
Do While ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, 11 ) == xFILIAL( "ZZM" ) + cCHAVE .AND. !ZZM->(Eof())
 	cCOMATexto := "Item: " + Substr( ZZM->ZZM_CHAVE, 12 ,4 ) + " - " + ZZM->ZZM_DESCR
	aadd(_vItens, cCOMATexto )
	ZZM->( DbSkip() )
EndDo

// Carga do Aheader
aHeader:={}

// Logo APOS o campo abaixo, sera exibido no acols o custo unitario e total
// do item, de acordo com a politica de precos correspondente...
_cRefSC7:="C7_PRECO"

sx3->(dbsetorder(2))
SetKey(122 , { || U_RCOMA11(aCols[n,2],cFilPed) }) // F11
SetKey(121 , { || U_RESTC03(aCols[n,2],cFilPed) }) // F10

// Alteracao para inclusao da marca no acols

sx3->(dbseek("C7__PRCPOL",.f.))
_vSzzUni:=sx3->({"Prc Original",x3_campo,x3_picture,x3_tamanho,x3_decimal,;
x3_valid,x3_usado,x3_tipo,x3_arquivo})
sx3->(dbseek("ZZ_PYPRCV",.f.))
_vSzzTot:=sx3->({"Custo Total",x3_campo,x3_picture,x3_tamanho,x3_decimal,;
x3_valid,x3_usado,x3_tipo,x3_arquivo})
sx3->(dbseek("ZZ_PYPRCV",.f.))
_vDivisao:=sx3->({"Divisao","DIVISAO","@er 999.99",6,2,;
x3_valid,x3_usado,x3_tipo,x3_arquivo})

sx3->(dbseek("ZZ_PYPRCV",.f.))
_vVariacao:=sx3->({"Variacao","VARIACAO","@er 999.99",6,2,;
x3_valid,x3_usado,x3_tipo,x3_arquivo})

dbSelectArea("SX3")
dbsetorder(1)
dbseek(_cAlias,.f.)


do while sx3->(!eof().and.x3_arquivo==_cAlias)
	if sx3->(x3_tipo<>"M".and.x3_context<>"V" .And. x3_usado != " " .And. cNivel >= X3_NIVEL .and.!( Alltrim(x3_campo)$ "C7_NUM|C7_FORNECE|C7_LOJA|C7_COND|C7_FILIAL|C7_TIPO"))
		sx3->(aadd(aHeader,{x3_titulo,x3_campo,x3_picture,x3_tamanho,x3_decimal,x3_valid,x3_usado,x3_tipo,x3_arquivo}))
	endif
	
	if alltrim(sx3->x3_campo)$"C7_DESCRI"
		aadd(aHeader,_vDivisao)
	endif
	if alltrim(sx3->x3_campo)== _cRefSC7
		aadd(aHeader,_vSzzUni)
		aadd(aHeader,_vVariacao)
	endif
	sx3->(dbskip(1))
enddo

// Carga do acols para SUB / SC6
aCols:={}

_cTitulo:="Dados do pedido de Compra"
AIB->(DbSetOrder(2))

dbSelectArea("SC7")
dbSetOrder(1)
dbseek(cFilPed+_cPedOrc,.f.)

_nValTot:=0 // valor unitario x quantidade
while !Eof() .And. cFilPed == SC7->C7_FILIAL .And. _cPedOrc == SC7->C7_NUM
	_vItensSub:={}
	for _nVez:=1 to len(aHeader)
		If ALLTRIM(aHeader[_nVez][2])$"BLQ" 
			//cCor := Iif(SC7->C7_TIPOBLQ="MCT" ,LoadBitMap(GetResources(),"BR_AZUL"),Iif(!Empty(TRB->C7__BLOQP) ,LoadBitMap(GetResources(),"BR_AMARELO"),Iif(!Empty(TRB->C7__BLOQQ) ,LoadBitMap(GetResources(),"BR_MARROM"),Iif(C7_DATPRF < dDataBase,LoadBitMap(GetResources(),"BR_VERMELHO"),LoadBitMap(GetResources(),"BR_VERDE")))))
			_xConteudo := LoadBitMap(GetResources(),"BR_AZUL")	
		Elseif !ALLTRIM(aHeader[_nVez][2])$"DIVISAO/VARIACAO/ZZ_PYPRCV/C7__PRCPOL/" // B1_PYMARCA/
			If !Empty(alltrim(aHeader[_nVez][2]))
				_xConteudo:=_cAlias+"->"+alltrim(aHeader[_nVez][2])
				_xConteudo:=&_xConteudo
			Else
				_xConteudo:=0							
			EndIf
		Elseif ALLTRIM(aHeader[_nVez][2])$"C7__PRCPOL" 
			If AIB->(DbSeek( xFilial("AIB") + SC7->(C7_FORNECE + C7_LOJA + C7_CODTAB + C7_PRODUTO) ))
				_xConteudo := AIB->AIB_PRCCOM 
			Else
				_xConteudo:=0
			EndIf
		Elseif ALLTRIM(aHeader[_nVez][2])$"VARIACAO" 
			If AIB->(DbSeek( xFilial("AIB") + SC7->(C7_FORNECE + C7_LOJA + C7_CODTAB + C7_PRODUTO) ))
				_xConteudo:=Iif(AIB->AIB_PRCCOM=0 ,0,((SC7->C7_PRECO/AIB->AIB_PRCCOM )-1)*100)
			Else
				_xConteudo:=0
			EndIf							
		else
			_xConteudo:=0
		endif
		aadd(_vItensSub,_xConteudo)
	next
	aadd(_vItensSub,.f.)
	aadd(aCols,_vItensSub)

	// Calculo do valor total
	_nValTot+=SC7->C7_TOTAL
	
	dbskip()
End
/*
Linhas comentadas devido เ falta da fun็ใo fValAcols e campo B1_PYMARCA
// Carga dos custos
_nCustoGer:=0
for _nVez:=1 to len(aCols)
	_cProduto:=u__fValAcols(_nVez,"C7_PRODUTO")
	_cPyMarca:= ""
	_cPyMarca:=posicione("SB1",1,xfilial("SB1")+_cProduto,"B1_PYMARCA")
	
	aCols[_nVez][ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="B1_PYMARCA"})]:=_cPyMarca
	
	_nCustoUni:=posicione("SC7",4,cFilPed+_cProduto+_cPedOrc,"C7__PRCPOL")
	_nCustoTot:=u__fValAcols(_nVez,"C7_QUANT")*_nCustoUni
	_nCustoGer+=_nCustoTot
	
//	aCols[_nVez][ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="ZZ_PYPRCL"})]:=_nCustoUni
	aCols[_nVez][ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="ZZ_PYPRCV"})]:=_nCustoTot
	
	_cCampo:= "C7_TOTAL"
	_nTotLin:=aCols[_nVez][ascan(aHeader,{|_vAux|alltrim(_vAux[2])==_cCampo})]
	_nDivisao:=100-(_nCustoTot/_nTotLin*100)
	aCols[_nVez][ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="DIVISAO"})]:=_nDivisao
next
*/
_nList:=1
@ 000,000 TO 400,780  	DIALOG _oDlg1 TITLE _cTitulo
@ 005,005 LISTBOX _nList ITEMS _vItens SIZE 382,080 Pixel Of _oDlg1

//@ 085,005 say u__fAjTxt("Itens") Pixel Of _oDlg1

@ 095,005 TO 180,387 MULTILINE
//@ 183,015 say u__fAjTxt("Custo total das mercadorias:         "+(tran(_nCustoGer,pesqpict("SF2","F2_VALFAT")))+;
//space(10)+"Condicao: "+Posicione('SE4',1,xFilial("SE4")+_cCond,'E4_DESCRI')) Pixel Of _oDlg1

//@ 192,015 say u__fAjTxt("Valor de compra das mercadorias: "+;
//(tran(_nValTot,pesqpict("SF2","F2_VALFAT")))+;
//space(10)+"% Aumento: "+alltrim(tran(100-((_nCustoGer/_nValtot)*100),;
//"@er 9,999.99")) + space(10) ) Pixel Of _oDlg1

@ 183,350 Button "Sair" Size 40,15 Action _oDlg1:End() Pixel Of _oDlg1

Activate DIALOG _oDlg1 centered


return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKRD018   บAutor  ณMicrosiga           บ Data ณ  07/20/10   บฑฑ
ฑฑฬออออออออออุออออออออออสออออออ/อฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ LIBERA O BLOQUEIO DE MARGEM                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FTA19B5(cNumPed,cFilPed)


If !U_CHECAFUNC(cUsuLib,"COMAT003")
	MsgStop("Voc๊ nใo tem permissใo para utilizar esta rotina!")
	Return
EndIf



If MsgYesNo("Deseja liberar o pre็o do  pedido "+cNumPed+"?")
	
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbSeek(cFilPed+cNumPed)
	While !Eof() .And. cFilPed == SC7->C7_FILIAL .And. cNumPed == SC7->C7_NUM
		RecLock("SC7",.F.)
		SC7->C7__BLOQP := " "
		SC7->C7__BLOQQ := " "
		SC7->C7__ULIB1 := SubStr(cUsuario,7,15)
		SC7->C7__DLIB1 := dDatabase
		SC7->C7__HLIB1 := Left(Time(),5)
		SC7->C7__PLIB1 := 'PRECO'
		SC7->C7_CONAPRO:= "L"
		SC7->(MsUnlock())
		dbSkip()
	End

	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+"PC"+cNumPed)
	While !Eof() .And. SCR->CR_NUM == cNumPed
		RecLock("SCR",.F.)
		SCR->CR_STATUS:= "03"
		SCR->(MsUnlock())
		dbSelectArea("SCR")
		dbSkip()
	End        
	
	nAscan := Ascan(aPeds, {|e| e[2]== cFilPed .And. e[3] == cNumPed})
	If nAscan  > 0
		aPeds[nAscan][1] := Iif(SC7->C7_DATPRF < dDataBase,LoadBitMap(GetResources(),"BR_VERMELHO"),LoadBitMap(GetResources(),"BR_VERDE"))
		dData := SC7->C7__DLIB1
		cHora := SC7->C7__HLIB1
		cLiber:= Left(SC7->C7__PLIB1,9)+" "+Left(SC7->C7__ULIB1,8)+" - "+Dtoc(dData)+" "+cHora
		aPeds[nAscan][6] := cLiber
	EndIf
EndIf

Return



