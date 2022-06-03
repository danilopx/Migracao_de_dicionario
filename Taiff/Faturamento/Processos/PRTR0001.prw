#INCLUDE "TOPCONN.CH"
#INCLUDE "tbiconn.ch"
#Include "rwmake.ch"
#Include "protheus.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTR0001  บAutor  ณBruno Roberto       บ Data ณ  11/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Realiza a gera็ใo do relatorio de romaneio de embarque     บฑฑ
ฑฑบ          ณ 						                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออnออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PRTR0001()

Local nLastKey  := 0
Local nRecCount := 0
Local nLin		:= 270
Local nFolha 	:= 1
Local nPri      := 1
Local nNF       := 0
Local nTotalNF  := 0
Local nVolumes  := 0
//Local nVolAB	:= 0
//Local nVolFC	:= 0
Local nPL		:= 0
Local nPB		:= 0
Local oFont10   := TFont():New('Tahoma',9,10,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont12   := TFont():New('Tahoma',9,12,.T.,.F.,5,.T.,5,.T.,.F.)
Local oFont12n  := TFont():New('Tahoma',9,12,.T.,.T.,5,.T.,5,.T.,.F.)
Local oFont14n  := TFont():New('Tahoma',9,14,.T.,.T.,5,.T.,5,.T.,.F.)

Private cPerg   := "PRTR01A"
Private cNF 	:=""
Private cSerie	:=""

ValidPerg(cPerg)

If nLastKey == 27
	Return
Endif

If !Pergunte(cPerg,.T.)
	Return
Endif


oPrint := TMSPrinter():New(OemToAnsi("Romaneio de Despacho (Expedicao)"))
oPrint:SETPAPERSIZE(9)
oPrint:setup()
//oPrint:Print( {1,2}, 2 )

/*cQuery := "	SELECT ZZL_MINUTA, A4_NOME, A4_CGC, A4_END, A4_COD, C5_NUM, F2_CLIENTE,F2_LOJA, A1_NOME, F2_DOC, F2_SERIE, F2_EMISSAO, F2_VALFAT, SUM(F2_VOLUME1+F2_VOLUME2+F2_VOLUME3+F2_VOLUME4) F2_VOLUMES, "
cQuery += " F2_PLIQUI, F2_PBRUTO, "
cQuery += " (SELECT COUNT(*) VOLAB FROM " + RetSQLName("ZZF") + " ZZF WHERE ZZF_FILIAL = '" + xFilial("ZZF") + "' AND ZZF_PEDIDO = C5_NUM AND ZZF_TPSEP = 'S' "
cQuery += " AND ZZF.D_E_L_E_T_ <> '*') VOLAB, "
cQuery += " (SELECT COUNT(*) VOLFC FROM " + RetSQLName("ZZF") + " ZZF WHERE ZZF_FILIAL = '" + xFilial("ZZF") + "' AND ZZF_PEDIDO = C5_NUM AND ZZF_TPSEP = 'F' "
cQuery += " AND ZZF.D_E_L_E_T_ <> '*') VOLFC "
cQuery += " FROM "+ RetSqlName("SF2")+" F2"
cQuery += " INNER JOIN "+ RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ <> '*' AND A1_FILIAL = '"+xFilial("SA1")+"' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
cQuery += " INNER JOIN "+ RetSqlName("SA4")+" A4 ON A4.D_E_L_E_T_ <> '*' AND A4_FILIAL = '"+xFilial("SA4")+"' AND F2_TRANSP = A4_COD "
cQuery += " INNER JOIN " + RetSQLName("ZZL") + " ZZL ON ZZL.D_E_L_E_T_ <> '*' AND ZZL_FILIAL = '" + xFilial("ZZL") + "' AND ZZL_DOC = F2_DOC AND ZZL_SERIE = F2_SERIE "
cQuery += " AND ZZL_MINUTA = '" + mv_par01 + "'" //and ZZL_IMPR = '" + mv_par02 + "' "
cQuery += " INNER JOIN "+ RetSqlName("SC6")+" C6 ON C6.D_E_L_E_T_ <> '*' AND C6_FILIAL = '"+xFilial("SC6")+"' AND F2_DOC = C6_NOTA AND F2_SERIE = C6_SERIE "
cQuery += " INNER JOIN "+ RetSqlName("SC5")+" C5 ON C5.D_E_L_E_T_ <> '*' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = C6_NUM "
cQuery += " WHERE F2.D_E_L_E_T_ <> '*'"
cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"'"
cQuery += " GROUP BY ZZL_MINUTA, A4_NOME, A4_CGC, A4_END,A4_COD, C5_NUM, F2_CLIENTE,F2_LOJA, A1_NOME, F2_DOC, F2_SERIE, F2_EMISSAO, F2_VALFAT,F2_PLIQUI, F2_PBRUTO
*/
cQuery := "SELECT F2_CLIENTE,F2_LOJA, F2_DOC, F2_SERIE, F2_EMISSAO, " + ENTER
cQuery += "(CASE WHEN F2_CLIENTE='001497' THEN C5_VOLUME1 ELSE F2_VOLUME1 END) AS F2_VOLUME1, " + ENTER
cQuery += " F2_VOLUME2,F2_VOLUME3,F2_VOLUME4, " + ENTER
cQuery += "C5_PESOL AS F2_PLIQUI, " + ENTER
cQuery += "C5_PBRUTO AS F2_PBRUTO,  " + ENTER
cQuery += "A1_NOME,A4_NOME, A4_CGC, A4_END, A4_COD, ZZL_MINUTA,D2_PEDIDO " + ENTER
cQuery += ", SUM(D2_VALBRUT) AS F2_VALBRUT " + ENTER
cQuery += "FROM "+ RetSqlName("SF2")+" F2" + ENTER
cQuery += " INNER JOIN "+ RetSqlName("SA1")+" A1 ON A1.D_E_L_E_T_ <> '*' AND A1_FILIAL = '"+xFilial("SA1")+"' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA" + ENTER  
cQuery += " INNER JOIN "+ RetSqlName("SA4")+" A4 ON A4.D_E_L_E_T_ <> '*' AND A4_FILIAL = '"+xFilial("SA4")+"' AND F2_TRANSP = A4_COD   " + ENTER
cQuery += " INNER JOIN "+ RetSqlName("ZZL")+" ZZL ON ZZL.D_E_L_E_T_ <> '*' AND ZZL_FILIAL = '"+xFilial("ZZL")+"' AND ZZL_DOC = F2_DOC AND ZZL_SERIE = F2_SERIE  AND ZZL_MINUTA = '" + mv_par01 + "'" + ENTER
cQuery += " INNER JOIN "+ RetSqlName("SD2")+" D2 ON D2.D_E_L_E_T_ <> '*' AND D2_FILIAL = '"+xFilial("SD2")+"' AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE  " + ENTER
cQuery += " INNER JOIN "+ RetSqlName("SC5")+" SC5 ON SC5.D_E_L_E_T_ <> '*' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM = D2_PEDIDO " + ENTER
cQuery += " WHERE F2.D_E_L_E_T_ <> '*' AND F2_FILIAL = '"+xFilial("SF2")+"'" + ENTER
cQuery += " GROUP BY F2_CLIENTE,F2_LOJA, F2_DOC, F2_SERIE, F2_EMISSAO, F2_VOLUME1 ,F2_VOLUME2,F2_VOLUME3,F2_VOLUME4, C5_PESOL, C5_PBRUTO,A1_NOME,A4_NOME, A4_CGC, A4_END, A4_COD, ZZL_MINUTA,D2_PEDIDO,C5_VOLUME1 " + ENTER 
cQuery += " ORDER BY F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE" + ENTER

If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

//MemoWrite("PRTR0001.sql",cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

TcSetField("TRB","F2_EMISSAO","D")

Count to nRecCount

If nRecCount > 0
	ProcRegua(nRecCount)
	
	dbSelectArea("TRB")
	dbGoTop()
	
	oPrint:StartPage()
	//+--------------------------+
	//ฆ Impressao do Cabecalho   ฆ
	//+--------------------------+
	oPrint:Box(0030,0070,3350,2335) // Box Geral I
	oPrint:Box(0030,0070,0200,2335) // Box Cabecalho
	oPrint:Box(0310,0070,3350,2335) // Box Dados Gerais
	
	oPrint:Say  (0160,2060,"Folha:"+" "+ Transform(nFolha,"@E"),oFont10)
	oPrint:Say  (0100,0800,"Romaneio de Despacho (Expedicao)",oFont14n)
	oPrint:Say  (0080,2060,"Hora:"+""+ Time(),oFont10)
	oPrint:Say  (0120,2060,"Data:"+""+ DTOC(dDataBase),oFont10)
	
	//Imprime Transp.
	oPrint:Say  (0210,0100,"Minuta   :"	+TRB->ZZL_MINUTA,oFont10)
	oPrint:Say  (0250,0100,"Transp.  :"	+TRB->A4_COD,oFont10)
	oPrint:Say  (0250,0450,"Nome :"	+Substring(TRB->A4_NOME,1,40),oFont10)
	oPrint:Say  (0250,1450,"CNPJ/CPF :"	+TRB->A4_CGC,oFont10)
	
	While TRB->(!EOF())
		
		IncProc(OemToAnsi("Aguarde"))
		ProcessMessages()
		
		If nLin >= 2300
			nFolha += 1
			nLin   := 270
			oPrint:EndPage()
			oPrint:StartPage()
			
			//+--------------------------+
			//ฆ Impressao do Cabecalho   ฆ
			//+--------------------------+
			oPrint:Box(0030,0070,3350,2335) // Box Geral I
			oPrint:Box(0030,0070,0200,2335) // Box Cabecalho
			oPrint:Box(0310,0070,3350,2335) // Box Dados Gerais
			
			oPrint:Say  (0160,2060,"Folha:"+" "+ Transform(nFolha,"@E"),oFont10)
			oPrint:Say  (0100,0800,"Romaneio de Despacho (Expedicao)",oFont14n)
			oPrint:Say  (0080,2060,"Hora:"+""+ Time(),oFont10)
			oPrint:Say  (0120,2060,"Data:"+""+ DTOC(dDataBase),oFont10)

				nLin += 50
				
				oPrint:Say  (nLin,0100,"Pedido",oFont12)
				oPrint:Say  (nLin,0250,"Cliente",oFont12)
				oPrint:Say  (nLin,0400,"Loja",oFont12)
				oPrint:Say  (nLin,0530,"Nome",oFont12)
				oPrint:Say  (nLin,1170,"Nota Fiscal",oFont12)
				oPrint:Say  (nLin,1400,"Volume",oFont12)
				oPrint:Say  (nLin,1600,"P. Liq.",oFont12)
				oPrint:Say  (nLin,1750,"P. Bruto",oFont12)
				oPrint:Say  (nLin,1950,"Emissao",oFont12)
				
				If mv_par02 $ ("Ss")
					oPrint:Say  (nLin,2150,"Vlr. Bruto",oFont12)
				Endif
				
				nLin += 100
			
			oPrint:Say  (nLin,0100,TRB->D2_PEDIDO,oFont10)
			oPrint:Say  (nLin,0250,TRB->F2_CLIENTE+Space(03)+TRB->F2_LOJA,oFont10)
			oPrint:Say  (nLin,0530,Substr(Alltrim(TRB->A1_NOME),1,30),oFont10)
			oPrint:Say  (nLin,1170,TRB->F2_DOC+"/"+TRB->F2_SERIE ,oFont10) //1050
			oPrint:Say  (nLin,1500,Transform((TRB->F2_VOLUME1+TRB->F2_VOLUME2+TRB->F2_VOLUME3+TRB->F2_VOLUME4),"@E 9999"),oFont10,,,,1)
			oPrint:Say  (nLin,1700,Transform(TRB->F2_PLIQUI,"@E 9999.99"),oFont10,,,,1)
			oPrint:Say  (nLin,1900,Transform(TRB->F2_PBRUTO,"@E 9999.99"),oFont10,,,,1)
			oPrint:Say  (nLin,1950,DTOC(TRB->F2_EMISSAO),oFont10)
			If mv_par02 $ ("Ss")
				oPrint:Say  (nLin,2330,Transform(TRB->F2_VALBRUT,"@E 999,999.99"),oFont10,,,,1)
			Endif
			
			//			oPrint:Say  (nLin,1150,Transform(TRB->VOLAB,"@E 9999.99"),oFont12)
			//			oPrint:Say  (nLin,1450,Transform(TRB->VOLFC,"@E 9999.99"),oFont12)
			
			nNF ++
			nTotalNF	+=	TRB->F2_VALBRUT
			nVolumes	+=	(TRB->F2_VOLUME1+TRB->F2_VOLUME2+TRB->F2_VOLUME3+TRB->F2_VOLUME4)
//			nVolAB		+=	TRB->VOLAB
//			nVolFC		+=	TRB->VOLFC
			nPL			+=	TRB->F2_PLIQUI
			nPB			+=	TRB->F2_PBRUTO
			
			nLin += 50
			
			//Imprime Transp.
			oPrint:Say  (0210,0100,"Minuta   :"	+TRB->ZZL_MINUTA,oFont12)
			oPrint:Say  (0250,0100,"Transp.  :"	+TRB->A4_COD,oFont10)
			oPrint:Say  (0250,0450,"Nome :"	+Substring(TRB->A4_NOME,1,40),oFont10)
			oPrint:Say  (0250,1500,"CNPJ/CPF :"	+TRB->A4_CGC,oFont10)
			
		Else
			If nPri = 1
				nLin += 50
				
				oPrint:Say  (nLin,0100,"Pedido",oFont12)
				oPrint:Say  (nLin,0250,"Cliente",oFont12)
				oPrint:Say  (nLin,0400,"Loja",oFont12)
				oPrint:Say  (nLin,0530,"Nome",oFont12)
				oPrint:Say  (nLin,1170,"Nota Fiscal",oFont12)
				oPrint:Say  (nLin,1400,"Volume",oFont12)
				oPrint:Say  (nLin,1600,"P. Liq.",oFont12)
				oPrint:Say  (nLin,1750,"P. Bruto",oFont12)
				oPrint:Say  (nLin,1950,"Emissao",oFont12)
				
				If mv_par02 $ ("Ss")
					oPrint:Say  (nLin,2150,"Vlr. Bruto",oFont12)
				Endif
				
				nLin += 100
			Endif
			
			oPrint:Say  (nLin,0100,TRB->D2_PEDIDO,oFont10)
			oPrint:Say  (nLin,0250,TRB->F2_CLIENTE+Space(03)+TRB->F2_LOJA,oFont10)
			oPrint:Say  (nLin,0530,Substr(Alltrim(TRB->A1_NOME),1,30),oFont10)
			oPrint:Say  (nLin,1170,TRB->F2_DOC+"/"+TRB->F2_SERIE ,oFont10) //1050
			oPrint:Say  (nLin,1500,Transform((TRB->F2_VOLUME1+TRB->F2_VOLUME2+TRB->F2_VOLUME3+TRB->F2_VOLUME4),"@E 9999"),oFont10,,,,1)
			oPrint:Say  (nLin,1700,Transform(TRB->F2_PLIQUI,"@E 9999.99"),oFont10,,,,1)
			oPrint:Say  (nLin,1900,Transform(TRB->F2_PBRUTO,"@E 9999.99"),oFont10,,,,1)
			oPrint:Say  (nLin,1950,DTOC(TRB->F2_EMISSAO),oFont10)
			If mv_par02 $ ("Ss")
				oPrint:Say  (nLin,2330,Transform(TRB->F2_VALBRUT,"@E 999,999.99"),oFont10,,,,1)
			Endif
			
			//			oPrint:Say  (nLin,1150,Transform(TRB->VOLAB,"@E 9999.99"),oFont12)
			//			oPrint:Say  (nLin,1450,Transform(TRB->VOLFC,"@E 9999.99"),oFont12)
			
			nNF ++
			nTotalNF	+=	TRB->F2_VALBRUT
			nVolumes	+=	(TRB->F2_VOLUME1+TRB->F2_VOLUME2+TRB->F2_VOLUME3+TRB->F2_VOLUME4)
//			nVolAB		+=	TRB->VOLAB
//			nVolFC		+=	TRB->VOLFC
			nPL			+=	TRB->F2_PLIQUI
			nPB			+=	TRB->F2_PBRUTO
			
			nLin += 50
		EndIf
		
		nPri ++        
		
		cNF		:=	TRB->F2_DOC
		cSerie	:=	TRB->F2_SERIE
//		AtuDT(cNF,cSerie)
		
		TRB->(dbSkip())	
	EndDo
	
	nPri := 1
	nLin		+= 100
	If mv_par02 $ ("Ss")
		oPrint:Say  (nLin,0100,"Totais",oFont12n)
		oPrint:Say  (nLin,1500,Transform(nVolumes,"@E 9999"),oFont10,,,,1)
		oPrint:Say  (nLin,1700,Transform(nPL,"@E 9999.99"),oFont10,,,,1)
		oPrint:Say  (nLin,1900,Transform(nPB,"@E 9999.99"),oFont10,,,,1)
		oPrint:Say  (nLin,2330,Transform(nTotalNF,"@E 999,999.99"),oFont10,,,,1)
	Endif
	
	nLin		+= 200
	oPrint:Say(nLin,0100,"Placa do veiculo: ________________________________________         Data: __________/__________/__________",oFont12)
	nLin		+= 200
	oPrint:Say(nLin,0100,"Nome legํvel: ___________________________________________________________________________________",oFont12)
	nLin		+= 200
	oPrint:Say(nLin,0100,"R.G.: _____________________________________",oFont12)
	
	
	nTotalNF 	:= 0
	nVolumes	:= 0
//	nVolAB		:= 0
//	nVolFC		:= 0
	nLin		+= 50
	
	oPrint:EndPage()
	AtuZZL()  //Fun็ใo que atualiza a Flag de Minuta Impressa
Else
	ALERT("Nao foram encontrados registros!.")
EndIf

TRB->(DBCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImprime em Video, e finaliza a impressao. !ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPrint:Preview()

MS_FLUSH()


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณ Fernando Salvatori บ Data ณ 26/01/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Grupo de Perguntas para este Processamento            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAGPE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg( cPerg )

PutSx1(cPerg,"01"   ,"Minuta  ?   		   ",""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    ,"ZZL" ,""         ,""   ,"mv_par01",""      ,""      ,""      ,""    ,""	,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"Imprime Valor  ?	   ",""                    ,""                    ,"mv_ch2","C"   ,01      ,0       ,0      , "C",""    ,"   " ,""         ,""   ,"mv_par02",""      ,""      ,""      ,""    ,""	,""     ,""      ,""    ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""     ,""      ,""      ,""      ,"")

Return

Static Function AtuZZL()

_cQuery   := "UPDATE " + RetSqlName("ZZL") + " SET "
_cQuery   += "	ZZL_IMPR ='S'"
_cQuery   += "WHERE ZZL_MINUTA = '" + mv_par01 + "'

TCSQLExec(_cQuery)

Return .T.


Static Function AtuDT(cNF,cSerie)

Local dDt:=Date()
_cQuery   := "UPDATE " + RetSqlName("SF2") + " SET "
_cQuery   += "	F2_DTEMB ='"+dtos(dDt)+"'"
_cQuery   += " WHERE F2_DOC = '" + cNF + "'
_cQuery   += " AND F2_SERIE = '" + cSerie + "'
_cQuery   += " AND F2_DTEMB =' "+"        '"

TCSQLExec(_cQuery)
Return.T.

