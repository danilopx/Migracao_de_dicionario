#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

#DEFINE ENTER Chr(13) + Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI010  บAutor  ณGilberto Ribeiro Jr บ Data ณ  24/04/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGERA PEDIDO DE REMESSA CONFORME PEDIDOS DE VENDA A ORDEM     ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATMI010()
	Private cMensFinal := ""
	Private cPerg	   := "FATMI010"

	ValidPerg(cPerg)

	If Pergunte(cPerg,.T.)
		Processa( {|| FTMI10GERA() } )
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFTMI10GERAบAutor  ณMicrosiga           บ Data ณ  09/16/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FTMI10GERA()
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oListBox
	Local nOpc		:= 0
	Local oBmp1, oBmp5, oBmp8
	Local lContinua := .F.
	Local nPedidos  := 0
	Local y := 0


	Private lWeb		:= .F. // CONTROLA SE ESTA SENDO EXECUTADO PELO SCHEDULE
	Private cPedPai
	Private oLocal
	Private cNome
	Private cCliente 	:= Space(6)
	Private dEntrega  	:= Ctod("  /  /  ")
	Private nFrete	   	:= 0
	Private cOper		:= Space(02)
	Private cCond
	Private oDlgPedidos, oValor, oQped, oBNota, oBPed
	Private aPedidos := {}
	Private nQped		:= 0
	Private nValor		:= 0
	Private cBPed

	Cursorwait()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSELECIONA OS PEDIDOS PENDENTES DE VENDA A ORDEM		      				ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := " SELECT   SC5.C5_FILIAL  AS C5_FILIAL,  " + ENTER
	cQuery += " 		 SC5.C5_NUM 	AS C5_NUM,     " + ENTER
	cQuery += " 		 SC5.C5__PEDPAI AS C5__PEDPAI, " + ENTER
	cQuery += " 		 SC5.C5_TIPO 	AS C5_TIPO,    " + ENTER
	cQuery += " 		 SC5.C5_CLIENTE AS C5_CLIENTE, " + ENTER
	cQuery += " 		 SC5.C5_LOJACLI AS C5_LOJACLI, " + ENTER
	cQuery += " 		 SC5.C5_CLIENTE AS C5_CLIENT,  " + ENTER
	cQuery += " 		 SC5.C5_LOJACLI AS C5_LOJAENT, " + ENTER
	cQuery += " 		 SC5.C5_TRANSP  AS C5_TRANSP,  " + ENTER
	cQuery += " 		 SC5.C5_TIPOCLI AS C5_TIPOCLI, " + ENTER
	cQuery += " 		 SC5.C5_CONDPAG AS C5_CONDPAG, " + ENTER
	cQuery += " 		 SC5.C5_TABELA  AS C5_TABELA,  " + ENTER
	cQuery += " 		 SC5.C5_FATFRAC AS C5_FATFRAC, " + ENTER
	cQuery += " 		 SC5.C5_FATPARC AS C5_FATPARC, " + ENTER
	cQuery += " 		 SC5.C5_VEND1   AS C5_VEND1,   " + ENTER
	cQuery += " 		 SC5.C5_DESC1   AS C5_DESC1,   " + ENTER
	cQuery += " 		 SC5.C5_EMISSAO AS C5_EMISSAO, " + ENTER
	cQuery += " 		 SC5.C5_TPFRETE AS C5_TPFRETE, " + ENTER
	cQuery += " 		 SC5.C5_FRETE   AS C5_FRETE,   " + ENTER
	cQuery += " 		 SC5.C5_MOEDA	AS C5_MOEDA,   " + ENTER
	cQuery += " 		 SC5.C5_PESOL	AS C5_PESOL,   " + ENTER
	cQuery += " 		 SC5.C5_PBRUTO  AS C5_PBRUTO,  " + ENTER
	cQuery += " 		 SC5.C5_VOLUME1 AS C5_VOLUME1, " + ENTER
	cQuery += " 		 SC5.C5_ESPECI1 AS C5_ESPECI1, " + ENTER
	cQuery += " 		 SC5.C5_INCISS  AS C5_INCISS,  " + ENTER
	cQuery += " 		 SC5.C5_TIPLIB  AS C5_TIPLIB,  " + ENTER
	cQuery += " 		 ISNULL(SC5.C5_DTPEDPR, '') AS C5_DTPEDPR, " + ENTER
	cQuery += " 		 SC5.C5_DTAPPO  AS C5_DTAPPO,  " + ENTER
	cQuery += "	 	 	 SC5.C5_HRAPPO  AS C5_HRAPPO,  " + ENTER
	cQuery += " 		 SC5.C5_EMPDES  AS C5_EMPDES,  " + ENTER
	cQuery += " 		 SC5.C5_FILDES  AS C5_FILDES,  " + ENTER
	cQuery += " 		 SC6.C6_XOPER   AS C6_XOPER,   " + ENTER // TIPO DE OPERA็ใO (V7 = VENDA A ORDEM)
	cQuery += " 		 SC5.C5_XITEMC  AS C5_XITEMC,  " + ENTER
	cQuery += " 		 SC5.C5_NOTA	AS C5_NOTA,    " + ENTER
	cQuery += " 		 SC5.C5_SERIE   AS C5_SERIE,   " + ENTER
	cQuery += "			 SA1.A1_COD_MUN AS A1_COD_MUN, " + ENTER
	cQuery += "			 SA1.A1_NOME	AS A1_NOME,    " + ENTER
	cQuery += "			 SA4.A4_NOME	AS A4_NOME,	   " + ENTER
	cQuery += " 		 SUM(SC6.C6_VALOR) AS C6_VALOR," + ENTER
	cQuery += " 		 COUNT(SC6.C6_ITEM) AS C6_ITEM," + ENTER
	cQuery += " 		 (SELECT COUNT( DISTINCT(SC9.C9_ITEM)) FROM " + RetSqlName("SC9") + " SC9 WHERE SC9.C9_PEDIDO = SC5.C5_NUM AND SC9.D_E_L_E_T_ <> '*' AND SC9.C9_BLEST = ''  AND SC9.C9_BLCRED = '' AND SC9.C9_FILIAL = '" + xFilial("SC9") + "') C9_ITEM" + ENTER

	cQuery += " FROM " + RetSqlName("SC6") + " SC6 WITH (NOLOCK) " + ENTER

	cQuery += " INNER JOIN " + RetSqlName("SC5") + " SC5 WITH (NOLOCK)" + ENTER
	cQuery += "    ON SC5.C5_NUM    = SC6.C6_NUM " + ENTER
	cQuery += "   AND SC5.C5_FILIAL = SC6.C6_FILIAL " + ENTER

	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 WITH (NOLOCK)" + ENTER
	cQuery += "    ON SA1.A1_COD = SC5.C5_CLIENTE " + ENTER
	cQuery += "   AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = SC5.C5_FILIAL " + ENTER

	cQuery += " INNER JOIN " + RetSqlName("SA4") + " SA4 WITH (NOLOCK) "
	cQuery += "    ON SA4.A4_COD = SC5.C5_TRANSP " + ENTER
	cQuery += "   AND SA4.A4_FILIAL = '" + xFilial("SA4") + "'" + ENTER + ENTER

	cQuery += " WHERE SC5.C5__PEDPAI = '' " + ENTER
	cQuery += "   AND SC6.C6_XOPER = 'V7' " + ENTER

	//cQuery += " SC5.C5_DTPEDPR BETWEEN '" + Dtos(mv_par03) + "' AND '" + Dtos(mv_par04) + "'" + ENTER
	//cQuery += " SC5.C5_DTPEDPR BETWEEN '' AND 'ZZZZZZZZ' " + ENTER

	//FILTRA POR DATA DE EMISSรO
	If !Empty(mv_par02) .And. !Empty(mv_par03)
		cQuery += " AND SC5.C5_EMISSAO BETWEEN '" + Dtos(mv_par02)+ "' AND '" + Dtos(mv_par03) + "'" + ENTER
	EndIf

	//FILTRA POR NUMERO DO PEDIDO
	If !Empty(mv_par04) .And. !Empty(mv_par05)
		cQuery += " AND SC5.C5_NUM BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'" + ENTER
	EndIf

	cQuery += " AND SC5.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " AND SA1.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " AND SC5.C5_TIPO = 'N' " + ENTER
	cQuery += " AND SA4.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'" + ENTER
	cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'" + ENTER
	cQuery += " AND SC6.C6_QTDENT < SC6.C6_QTDVEN " + ENTER

	cQuery += " GROUP BY SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5__PEDPAI, SC5.C5_TIPO, SC6.C6_XOPER, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_TRANSP, " + ENTER
	cQuery += "	 SC5.C5_TIPOCLI, SC5.C5_CONDPAG, SC5.C5_TABELA, SC5.C5_FATFRAC, SC5.C5_FATPARC, SC5.C5_VEND1, SC5.C5_DESC1, SC5.C5_EMISSAO, SC5.C5_TPFRETE, SC5.C5_FRETE, " + ENTER
	cQuery += "	 SC5.C5_MOEDA, SC5.C5_PESOL, SC5.C5_PBRUTO, SC5.C5_VOLUME1, SC5.C5_ESPECI1, SC5.C5_INCISS, SC5.C5_TIPLIB, SC5.C5_DTPEDPR, SC5.C5_DTAPPO, SC5.C5_HRAPPO, SC5.C5_EMPDES, " + ENTER
	cQuery += "	 SC5.C5_FILDES, SC5.C5_XITEMC, SC5.C5_NOTA, SC5.C5_SERIE, SA1.A1_COD_MUN, SA1.A1_NOME, SA4.A4_NOME "

	//MemoWrite("FATMI010.SQL", cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	TcSetField("TRB","C9_DATALIB","D")
	TcSetField("TRB","C5_EMISSAO","D")
	TcSetField("TRB","C5_DTPEDPR","D")
	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem pedidos para gera็ใo de Remessa.","Aten็ใo")
		CursorArrow()
		TRB->(dbCloseArea())
		Return
	EndIf
	CursorArrow()

	dbSelectArea("TRB")
	ProcRegua(nRec1)
	dbGotop()

	aPedidos := {}

	While !Eof()
		IncProc("Montando os itens a serem selecionados")
		aAdd(  aPedidos				;//ARRAY DE PEDIDOS
		,{fColor() 			;//01
		,.F. 					;//02
		,TRB->C5_NUM 			;//03
		,TRB->C5_NOTA			;//04
		,TRB->C5_CLIENTE		;//05
		,TRB->A1_NOME			;//06
		,TRB->C5_TRANSP		;//07
		,TRB->A4_NOME			;//08
		,TRB->C6_VALOR		;//09
		,TRB->C5_VOLUME1		;//10
		,TRB->C6_ITEM			;//11
		,TRB->C9_ITEM			;//12
		,TRB->C5__PEDPAI		;//13
		,TRB->C5_TRANSP  		;//14
		,TRB->C5_TIPOCLI 		;//15
		,TRB->C5_CONDPAG 		;//16
		,TRB->C5_TABELA  		;//17
		,TRB->C5_FATFRAC 		;//18
		,TRB->C5_FATPARC 		;//19
		,TRB->C5_VEND1   		;//20
		,TRB->C5_DESC1   		;//21
		,TRB->C5_EMISSAO 		;//22
		,TRB->C5_TPFRETE 		;//23
		,TRB->C5_FRETE   		;//24
		,TRB->C5_MOEDA		;//25
		,TRB->C5_PESOL		;//26
		,TRB->C5_PBRUTO  		;//27
		,TRB->C5_VOLUME1 		;//28
		,TRB->C5_ESPECI1 		;//29
		,TRB->C5_INCISS  		;//30
		,TRB->C5_TIPLIB  		;//31
		,TRB->C5_DTPEDPR 		;//32
		,TRB->C5_DTAPPO  		;//33
		,TRB->C5_HRAPPO  		;//34
		,TRB->C5_EMPDES  		;//35
		,TRB->C5_FILDES  		;//36
		,TRB->C6_XOPER   		;//37
		,TRB->C5_XITEMC  		;//38
		})
		dbSelectArea("TRB")
		dbSkip()
	End

	CursorArrow()

	If Len(aPedidos) == 0
		MsgStop("Nใo existem dados para este relat๓rio!","Aten็ใo")
		TRB->(dbCloseArea())
		Return
	EndIf

	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0

	aTitCampos := {" "," ",OemToAnsi("Pedido"),OemToAnsi("Nota"),OemToAnsi("Cod.Cli"),OemToAnsi("Cliente"),OemToAnsi("Cod.Transp."),OemToAnsi("Transportadora"),;
		OemToAnsi("Valor"), OemToAnsi("Volume"), OemToAnsi("Itens Pedido"),OemToAnsi("Itens Liberados"),OemToAnsi("Ped.Pai")}

	cLine := "{aPedidos[oListBox:nAT][1],If(aPedidos[oListBox:nAt,2],oOk,oNo),aPedidos[oListBox:nAT][3],aPedidos[oListBox:nAT][4],aPedidos[oListBox:nAT][5],"
	cLine += " aPedidos[oListBox:nAT][6],aPedidos[oListBox:nAT][7],aPedidos[oListBox:nAT][8],aPedidos[oListBox:nAT][9],aPedidos[oListBox:nAT][10],aPedidos[oListBox:nAT][11],"
	cLine += " aPedidos[oListBox:nAT][12],aPedidos[oListBox:nAT][13],}"

	bLine := &( "{ || " + cLine + " }" )
	nMult := 7
	aCoord := {nMult*2, nMult*2, nMult*4, nMult*3, nMult*1, nMult*3, nMult*10, nMult*3, nMult*4, nMult*10, nMult*3, nMult*1, nMult*1, nMult*3}

	@ 100,005 TO 550,1000 DIALOG oDlgPedidos TITLE "Pedidos"
	//oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := !aDados[oListBox:nAt,2] }

	oListBox := TWBrowse():New( 17,4,480,160,,aTitCampos,aCoord,oDlgPedidos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aPedidos)
	oListBox:bLDblClick := { || aPedidos[oListBox:nAt,2] := MarcaTodos(oListBox, .T., .T.,1,oListBox:nAt) }
	oListBox:bLine := bLine

	@ 183,010 BUTTON "Marca Tudo" SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgPedidos
	@ 183,060 BUTTON "Desm. Tudo" SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgPedidos
	@ 183,110 BUTTON "Ok"	      SIZE 40,15 ACTION {nOpc :=1,oDlgPedidos:End()} PIXEL OF oDlgPedidos
	@ 183,160 BUTTON "Sair"       SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

	//@ 183,210 Say OemToAnsi("Nota Remessa") Size 99,6 Of oDlgPedidos Pixel
	//@ 183,250 Get cBNota Picture "@!" SIZE 59,8 object oBNota //Of oDlgPedidos Pixel
	//@ 183,330 BUTTON "Busca NF"   	SIZE 30,10 ACTION Iif(Ascan(aPedidos, {|e| e[4] == cBNota})>0,(aPedidos[Ascan(aPedidos, {|e| e[4] == cBNota}),2]:=Iif(Ascan(aPedidos, {|e| e[4] == cBNota})>0, MarcaTodos(oListBox, .T., .T.,1,Ascan(aPedidos, {|e| e[4] == cBNota})),.F.),cBNota:= Space(9),oDlgPedidos:Refresh(),oBNota:SetFocus()),cBNota:= Space(9)) PIXEL OF oDlgPedidos

	@ 200,210 Say OemToAnsi("Ped.Remessa")  SIZE 99,6 Of oDlgPedidos Pixel
	@ 200,250 Get cBPed Picture "@!" 		SIZE 59,8 object oBPed //Of oDlgPedidos Pixel
	@ 200,330 BUTTON "Busca Ped."   		SIZE 30,10 ACTION (aPedidos[Ascan(aPedidos, {|e| e[3] == cBPed}),2]:=Iif(Ascan(aPedidos, {|e| e[3] == cBPed})>0, MarcaTodos(oListBox, .T., .T.,1,Ascan(aPedidos, {|e| e[3] == cBPed})),.F.),cBPed:= Space(6),oDlgPedidos:Refresh(),oBPed:SetFocus()) PIXEL OF oDlgPedidos

	//ACTION (oListBox:nAT:=Iif(Ascan(aPedidos, {|e| e[3] == cBPed}) > 0,oListBox:nAT:=Ascan(aPedidos, {|e| e[3] == cBPed}),oListBox:nAT),;
		//Iif(Ascan(aPedidos, {|e| e[3] == cBPed}) > 0 .And. !aPedidos[oListBox:nAt,2],nQped ++,),;
		//Iif(Ascan(aPedidos, {|e| e[3] == cBPed}) > 0 .And. !aPedidos[oListBox:nAt,2],nValor	+= aPedidos[oListBox:nAt,10],),;
		//aPedidos[oListBox:nAt,2] := Iif(Ascan(aPedidos, {|e| e[3] == cBPed})>0,.T.,.F.),;
		//cBPed:= Space(6),oDlgPedidos:Refresh(),oBPed:SetFocus()) PIXEL OF oDlgPedidos

	//FATURADO - "BR_VERMELHO"
	//LIBERADO - "BR_VERDE"
	//BLOQUEIO - "BR_AZUL"

	@ 213,005 BITMAP oBmp1 ResName "BR_AZUL" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 213,015 SAY "Bloqueado" OF oDlgPedidos Color CLR_BLUE,CLR_BLACK PIXEL

	@ 213,065 BITMAP oBmp5 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 213,075 SAY "Liberado" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL

	@ 213,125 BITMAP oBmp8 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
	@ 213,135 SAY "Faturado" OF oDlgPedidos Color CLR_RED,CLR_WHITE PIXEL


	@ 213, 185 SAY "Valor" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 213, 215 GET oValor 	Var nValor	Picture "@e 9,999,999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	@ 213, 265 SAY "Pedidos" OF oDlgPedidos Color CLR_BLUE PIXEL
	@ 213, 285 GET oQped 	Var nQPed 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPedidos

	ACTIVATE DIALOG oDlgPedidos CENTERED

	TRB->(dbCloseArea())

	If nOpc == 0
		Return
	EndIf

	// Tamanho da tela
	DEFINE MSDIALOG oLocal FROM 63, 181 TO 250, 743 TITLE "Selecione os Pedidos para Gera็ใo de Remessa" PIXEL

	// Tamanho da borda
	@ 003, 005 TO 90, 280 PIXEL OF oLocal

	@ 012, 007 SAY "Informe o Cliente:" SIZE  60, 7 PIXEL OF oLocal
	@ 012, 060 MsGET cCliente  SIZE   30, 9 F3 "SA1" Valid(BuscaCli(cCliente))  PIXEL OF oLocal
	@ 012, 092 MsGET cNome     SIZE  180, 9 When .F. PIXEL OF oLocal

	@ 028, 007 SAY "Tipo Opera็โo:" SIZE  60, 7 PIXEL OF oLocal
	@ 028, 060 MsGET cOper  		SIZE  30, 9 VALID (Operac(cOper)) F3 "DJ" PIXEL OF oLocal

	DEFINE SBUTTON FROM 060,010 TYPE 1 ACTION (lContinua:= .T.,Close(oLocal)) ENABLE OF oLocal PIXEL OF oLocal
	DEFINE SBUTTON FROM 060,040 TYPE 2 ACTION (lContinua:= .F.,Close(oLocal)) ENABLE OF oLocal PIXEL OF oLocal

	//@ 024,007 SAY "Tipo de Frete:" SIZE  60, 7 PIXEL OF oLocal
	//@ 024,060 COMBOBOX cTPFrete ITEMS aItems SIZE 35,9  PIXEL OF oLocal
	//@ 036,007 SAY "Mensagem da Nota:" SIZE  60, 7 PIXEL OF oLocal
	//@ 036,060 MsGET cMennota   SIZE 180, 9 PIXEL OF oLocal
	//@ 048,007 SAY "Transportadora:" SIZE  60, 7 PIXEL OF oLocal
	//@ 048,060 MsGET cTransp    SIZE 40, 9  VALID .t. F3 "SA4"  PIXEL OF oLocal
	//@ 048,135 SAY "Valor Frete:" SIZE  65, 7 PIXEL OF oLocal
	//@ 048,188 GET nFrete Picture "@E 99,999,999.99" SIZE 60, 9 PIXEL OF oLocal
	//@ 060,007 SAY "Cond.Pagto:" SIZE  60, 7 PIXEL OF oLocal
	//@ 060,060 MsGET cCond SIZE 30, 9    F3 "SE4" PIXEL OF oLocal
	//@ 060,135 SAY "Req.Cliente:" SIZE  65, 7 PIXEL OF oLocal
	//@ 060,188 GET cPedido SIZE 60, 9 when.f. PIXEL OF oLocal
	//@ 096,007 SAY "Data Entrega:" SIZE  60, 7 PIXEL OF oLocal
	//@ 096,060 Get dEntrega  SIZE 35,9  Valid (dEntrega >= dDatabase) .And. U_CALCDENT(cCliente,dEntrega,cFormT,cCEP) PIXEL OF oLocal

	//@ 120,007 SAY "Endereco Entrega:" SIZE  60, 7 PIXEL OF oLocal
	//@ 120,060 GET cEndEnt SIZE 180, 9  VALID .t. PIXEL OF oLocal
	//@ 132,007 SAY "Bairro Entrega:" SIZE  60, 7 PIXEL OF oLocal
	//@ 132,060 GET cBairro SIZE 60, 9  VALID .t. PIXEL OF oLocal
	//@ 132,135 SAY "Cidade Entrega:" SIZE  65, 7 PIXEL OF oLocal
	//@ 132,188 GET cMune SIZE 60, 9  VALID .t. PIXEL OF oLocal
	//@ 144,007 SAY "Estado Entrega:" SIZE  60, 7 PIXEL OF oLocal
	//@ 144,060 GET cEst SIZE 15, 9   VALID .t. PIXEL OF oLocal
	//@ 144,135 SAY "CEP Entrega:" SIZE  60, 7 PIXEL OF oLocal
	//@ 144,188 GET cCEP SIZE 30, 9   VALID .t. PIXEL OF oLocal
	//@ 156,007 SAY "Vendedor:" SIZE  60, 7 PIXEL OF oLocal
	//@ 156,060 MsGET cVend SIZE 30, 9  F3 "SA3" VALID .t. PIXEL OF oLocal
	//@ 168,007 SAY "Mensagem Interna:" SIZE  60, 7 PIXEL OF oLocal
	//@ 168,060 GET cMenInt    SIZE 180, 9 PIXEL OF oLocal
	//@ 180,060 GET cMenInt2   SIZE 180, 9 PIXEL OF oLocal
	//@ 192,007 SAY "Forma Transporte:" SIZE  60, 7 PIXEL OF oLocal
	//@ 192,060 COMBOBOX cFormT ITEMS aItems4 SIZE 35,9  PIXEL OF oLocal
	//@ 204,007 SAY "Ref.Motorista:" SIZE  60, 7 PIXEL OF oLocal
	//@ 204,060 GET cRefMot		   SIZE 180, 9  PIXEL OF oLocal

	ACTIVATE MSDIALOG oLocal CENTER

	If !lContinua
		Return
	EndIf

	//GRAVA OS PEDIDOS
	aCabPV := {}
	aItemPV := {}

	For y:= 1 To Len(aPedidos)
		If aPedidos[y][2]

			IncProc("Lendo Pedido " + StrZero(y,4) + " de " + StrZero(Len(aPedidos),4))

			cPedPai = aPedidos[y][3]

			//MONTA O CABECALHO DO PEDIDO PAI
			If Len(aCabPV) == 0
				//POSICIONA NO CADASTRO DO CLIENTE
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial() + cCliente)

				nComiss := 0

				// Cabecalho
				AAdd(aCabPV,{"C5_FILIAL"  	,xFilial("SC5")				,Nil}) // Filial
				AAdd(aCabPV,{"C5_TIPO"    	,"N"         				,Nil}) // Tipo de pedido
				AAdd(aCabPV,{"C5_CLIENTE" 	,SA1->A1_COD	   			,Nil}) // Codigo do cliente
				AAdd(aCabPV,{"C5_LOJACLI" 	,SA1->A1_LOJA    			,Nil}) // Loja do cliente
				AAdd(aCabPV,{"C5_CLIENT"  	,SA1->A1_COD	   			,Nil}) // Codigo do cliente
				AAdd(aCabPV,{"C5_LOJAENT" 	,SA1->A1_LOJA      			,Nil}) // Loja para entrada
				AAdd(aCabPV,{"C5_TIPOCLI" 	,SA1->A1_TIPO				,Nil}) // Tipo do Cliente
				AAdd(aCabPV,{"C5_INTER"   	,"N"		  				,Nil}) // InterCompany
				AAdd(aCabPV,{"C5_VOLUME1"	,aPedidos[y][10]			,Nil}) // Volume
				AAdd(aCabPV,{"C5_TRANSP"	,aPedidos[y][14]			,Nil}) // Transportadora
				AAdd(aCabPV,{"C5_CONDPAG" 	,aPedidos[y][16]			,Nil}) // Codigo da condicao de pagamanto
				AAdd(aCabPV,{"C5_TABELA" 	,aPedidos[y][17]			,Nil}) // Codigo de tabela de pre็o
				AAdd(aCabPV,{"C5_FATFRAC"	,aPedidos[y][18]			,Nil}) // Fatura Fracionado
				AAdd(aCabPV,{"C5_FATPARC"   ,aPedidos[y][19]			,Nil}) // Fatura Parcial
				AAdd(aCabPV,{"C5_VEND1"   	,aPedidos[y][20]			,Nil}) // Vendedor
				AAdd(aCabPV,{"C5_DESC1"   	,aPedidos[y][21]			,Nil}) // Desconto
				AAdd(aCabPV,{"C5_TPFRETE" 	,aPedidos[y][23]			,Nil}) // Tipo de Frete
				AAdd(aCabPV,{"C5_FRETE" 	,aPedidos[y][24]			,Nil}) // Valor de Frete
				AAdd(aCabPV,{"C5_MOEDA"		,aPedidos[y][25]			,Nil}) // Moeda
				AAdd(aCabPV,{"C5_PESOL"		,aPedidos[y][26]			,Nil}) // Peso Lํquido
				AAdd(aCabPV,{"C5_PBRUTO"	,aPedidos[y][27]			,Nil}) // Peso Bruto
				AAdd(aCabPV,{"C5_LIBEROK" 	,"S"         				,Nil}) // Liberacao Total
				AAdd(aCabPV,{"C5_ESPECI1"	,aPedidos[y][29]			,Nil}) // Especie
				AAdd(aCabPV,{"C5_INCISS"	,aPedidos[y][30]			,Nil}) // ISS
				AAdd(aCabPV,{"C5_TIPLIB"  	,aPedidos[y][31]			,Nil}) // Tipo de Liberacao
				AAdd(aCabPV,{"C5_DTPEDPR"   ,aPedidos[y][32]			,Nil}) // Data de Pedido Programado
				AAdd(aCabPV,{"C5_DTAPPO"	,STOD(aPedidos[y][33])		,Nil}) // Data da Aprova็ใo no Portal
				AAdd(aCabPV,{"C5_HRAPPO" 	,aPedidos[y][34]			,Nil}) // Hora da Aprova็ใo no Portal
				AAdd(aCabPV,{"C5_EMPDES" 	,aPedidos[y][35]			,Nil}) // Empresa Destino
				AAdd(aCabPV,{"C5_FILDES" 	,aPedidos[y][36]			,Nil}) // Filial Destino
				AAdd(aCabPV,{"C5_XITEMC" 	,aPedidos[y][38]			,Nil}) // Unidade de Neg๓cio
				AAdd(aCabPV,{"C5__PEDPAI" 	,cPedPai					,Nil}) // Pedido Pai

				cItSC6   	:= "00"
				nItem := 0

			EndIf

			//PROCESSA OS DETALHES
			dbSelectArea("SC6")
			dbSetOrder(1)
			dbSeek(xFilial() + cPedPai)

			While !Eof() .And. SC6->C6_NUM == cPedPai

				aReg := {}

				//VERIFICA SE JA EXISTE O ITEM NO ARRAY, TEM DE COINCIDIR O CODIGO E O VALOR UNITARIO
				nAscan := Ascan(aItemPV, {|e| e[4][2] == SC6->C6_PRODUTO .And. e[7][2] == SC6->C6_PRCVEN .And. e[22][2] == Iif(Empty(SC6->C6__PEG),"2",SC6->C6__PEG) })

				If nAscan == 0

					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial() + SC6->C6_PRODUTO)
					nPrUnit := Round(SC6->C6_PRCVEN, 4)

					//Estแ atribuindo, mas no momento da inclusใo o TES ้ substituido
					//MaTesInt(2, _cOper, (_cPSC5)->ORD_CLIENTE, (_cPSC5)->ORD_LOJA, "C", PadR((_cPSC6)->SB1_COD_COMP, 15))

					//NAO E NECESSARIO COLOCAR TES, POIS EXISTE ROTINA QUE FAZ AUTOMATICAMENTE CONFORME A OPERACAO
					cItSC6 := Soma1(cItSC6,Len(SC6->C6_ITEM)) //item do pedido

					AAdd(aReg, {"C6_FILIAL"		,xFilial("SC6")							,Nil})
					AAdd(aReg, {"C6_ITEM"		,cItSC6									,Nil})
					AAdd(aReg, {"C6_PRODUTO"	,SC6->C6_PRODUTO						,Nil})
					AAdd(aReg, {"C6_UM"     	,SB1->B1_UM								,Nil})
					AAdd(aReg, {"C6_QTDVEN" 	,SC6->C6_QTDVEN							,Nil})
					AAdd(aReg, {"C6_PRCVEN" 	,nPrUnit								,Nil})
					AAdd(aReg, {"C6_VALOR"  	,Round(SC6->C6_QTDVEN * nPrUnit,4)		,Nil})
					AAdd(aReg, {"C6_OPER"		,cOper									,Nil})
					AAdd(aReg, {"C6_XOPER" 		,cOper			  						,Nil})
					AAdd(aReg, {"C6_QTDLIB" 	,SC6->C6_QTDVEN	 						,Nil})
					AAdd(aReg, {"C6_LOCAL"  	,SC6->C6_LOCAL							,Nil})
					AAdd(aReg, {"C6_CLI"    	,SA1->A1_COD 							,Nil})
					AAdd(aReg, {"C6_LOJA"   	,SA1->A1_LOJA 							,Nil})
					//AAdd(aReg, {"C6_ENTREG" 	,SC6->C6_ENTREG  						,Nil})
					AAdd(aReg, {"C6_PRUNIT" 	,SC6->C6_PRUNIT							,Nil})
					AAdd(aReg, {"C6_COMIS1" 	,Iif(nComiss > 0,nComiss,SC6->C6_COMIS1),Nil})

					AAdd(aItemPV, aReg)

				Else
					aItemPV[nAscan][6][2] += SC6->C6_QTDVEN						//QUANTIDADE
					aItemPV[nAscan][8][2] += SC6->C6_QTDVEN * SC6->C6_PRCVEN	//TOTAL
					aItemPV[nAscan][9][2] += SC6->C6_QTDVEN			  			//QUANTIDADE LIBERADA
				EndIf

				nPedidos++
				dbSelectArea("SC6")
				dbSkip()

			End

		EndIf
	Next

	//GRAVA O PEDIDO PAI
	//EXECUTA A ROTINA AUTOMATICA
	lMSErroAuto := .F.
	lMSHelpAuto := .F.

	MSExecAuto({|x,y,z|Mata410(x,y,z)}, aCabPv, aItemPV, 3)

	If lMsErroAuto
		Mostraerro()
		lOkArquivo := .F.
	Else
		cMensFinal := "Pedidos gerados com sucesso!!!"
		MsgInfo(cMensFinal,"FATMI010")
	Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBUSCACLI  บAutor  ณMicrosiga           บ Data ณ  06/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaCli(cCliente)

	DbSelectArea("SA1")
	DbSetOrder(1)
	if !dbSeek(xFilial('SA1')+cCliente)
		msgStop('Cliente nao encontrado.')
		@ 013,90 SAY Space(25)
		Return(.F.)
	EndIf
	cNome 	:=substr(SA1->A1_NOME,1,25)
	cVend 	:= SA1->A1_VEND
	cCond	:= SA1->A1_COND

	oLocal:Refresh()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCOLOR    บAutor  ณMicrosiga           บ Data ณ  09/22/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RETORNA O STATUS DO PEDIDO                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//FATURADO - "BR_VERMELHO"
//LIBERADO - "BR_VERDE"
//BLOQUEIO - "BR_AZUL"
//BLOQUEIO VOLUME - "BR_AMARELO"

Static Function fColor()

	//FATURADO
	If Empty(TRB->C5_NOTA)
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaTodosบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMarca todos as opcoes do list box - totalizadores           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca, nItem, nPos)
	Local nX		  := 0

	If nItem = 0
		For nX := 1 TO Len(oListbox:aArray)
			InverteSel(oListBox,nX, lInverte, lMarca,0)
		Next
	Else
		lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
		Return(lRet)
	EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInverteSelบAutor  ณPaulo Carnelossi    บ Data ณ  04/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInverte Selecao do list box - totalizadores                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca,nItem)


	If lInverte
		oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
		If oListbox:aArray[nLin,2]
			nQped	++
			nValor	+= oListbox:aArray[nLin,10]

		Else
			nQped	--
			nValor	-= oListbox:aArray[nLin,10]
		EndIf
	Else
		If lMarca
			oListbox:aArray[nLin,2] := .T.
			nQped	++
			nValor	+= oListbox:aArray[nLin,10]

		Else
			oListbox:aArray[nLin,2] := .F.
			nQped	--
			nValor	-= oListbox:aArray[nLin,10]
		EndIf
	EndIf
	// 01 - COR, 02 - MARK, 03 - PEDIDO, 04 - BLOQUEIOS, 05 - COD CLI, 06 - RAZAO, 07 - COD TRANS, 08 - NOME TRANS, 09 - VALOR, 10 - VOLUME, 11 - ITEM PED, 12 - ITEM LIB, 13-NOTA

	oQped:Refresh()
	oValor:Refresh()

	If nItem == 1
		If oListbox:aArray[nLin,2] == .F.
			Return(.F.)
		ElsE
			Return(.T.)
		EndIf
	Else
		aPedidos[nLin,2] := oListbox:aArray[nLin,2]
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI010  บAutor  ณMicrosiga           บ Data ณ  01/20/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Operac(cOper)
	Local lRet := .F.

	dbSelectArea("SFM")
	dbSetOrder(1)
	If !dbSeek(xFilial() + cOper)
		MsgStop("A opera็ใo que voc๊ estแ querendo utilizar nใo possui regras de TES inteligente.","Opera็ใo cancelada - FATMI010")
		Return(lRet)
	EndIf

	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial() + SFM->FM_TS, .F.)

	//VERIFICA SE A TES GERA FINANCEIRO
	If SF4->F4_DUPLIC == "S"
		MsgStop("A Opera็ใo utilizada gera financeiro.","Opera็ใo cancelada - FATMI010")
		Return(lRet)
	EndIf

	//VERIFICA SE O TES MOVIMENTA ESTOQUE
	If SF4->F4_ESTOQUE # "S"
		MsgStop("A Opera็ใo utilizada nโo movimenta Estoque.","Opera็ใo cancelada - FATMI010")
		Return(lRet)
	EndIf

	lRet := .T.
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  11/25/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
	CriaPergunta(cPerg,"01"   ,"Cliente"		,""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    			,"SA1" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	CriaPergunta(cPerg,"02"   ,"Emissao De"		,""                    ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	CriaPergunta(cPerg,"03"   ,"Emissao At้"	,""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,""    	,""         ,""   ,"mv_par03",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	CriaPergunta(cPerg,"04"   ,"Pedido De"		,""                    ,""                    ,"mv_ch4","C"   ,06      ,0       ,0      , "G",""    			,"SC5" 	,""         ,""   ,"mv_par04",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	CriaPergunta(cPerg,"05"   ,"Pedido At้"		,""                    ,""                    ,"mv_ch5","C"   ,06      ,0       ,0      , "G",""    			,"SC5" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณCriaPerguntaณ Autor ณWagner                 ณ Data ณ 14/02/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria uma pergunta usando rotina padrao                      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaPergunta(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
		cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
		cF3, cGrpSxg,cPyme,;
		cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
		cDef02,cDefSpa2,cDefEng2,;
		cDef03,cDefSpa3,cDefEng3,;
		cDef04,cDefSpa4,cDefEng4,;
		cDef05,cDefSpa5,cDefEng5,;
		aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f.


	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return
