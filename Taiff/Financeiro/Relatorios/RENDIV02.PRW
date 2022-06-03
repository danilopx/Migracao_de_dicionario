#include "protheus.ch
#include "Topconn.ch"
#Include "Tbiconn.ch"
#DEFINE ENTER Char(13) + Char(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RDGFIN02  ºAutor  ³ Jackson Santos     º Data ³  05/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Detalhado de Endividamento 			              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                      	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RENDIV02()
	Local oReport
	Private cPerg := "REDV02"
	
	If TRepInUse()
		ValidPerg(cPerg)
		Pergunte(cPerg,.T.)
		oReport := ReportDef()
		oReport:SetParam(cPerg)
		oReport:PrintDialog()
	EndIf

Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local aRecnoSM0 := {}
	Local nTamData  	:= Len(DTOC(MsDate()))
	Private aAnoMesRel := {}
//Carrega Filiais para Pegar o Nome.
	dbSelectArea( "SM0" )
	dbGoTop()
	While !SM0->( EOF() )
		aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME,SM0->M0_FILIAL } )
		SM0->( dbSkip() )
	EndDo

	oReport := TReport():New("RENDIV02","Detalhamento Endividamento",cPerg,{|oReport| PrintReport(oReport,oBreak)},"Relatório de Endividamento Detalhado")
	oReport:SetLandscape()
	oSection := TRSection():New(oReport,"Detalhamento",{},{"Banco","Modalidade"})
	oSection:SetTotalInLine(.F.)

	TRCell():New(oSection,"ZMCODBCO","","Cod.Bco",/*Picture*/,7 ,/*lPixel*/			,{|| Substr(Alltrim(QRYEMP->ZY_CODBCO),1,7)})
	TRCell():New(oSection,"A6NOME","","Banco",/*Picture*/, 20 ,/*lPixel*/			,{|| Substr(Alltrim(QRYEMP->A6_NOME),1,20)})
	TRCell():New(oSection,"ZLDESCRI","","Modalidade",/*Picture*/, 20  ,/*lPixel*/,{|| Substr(Alltrim(QRYEMP->ZW_DESCRI),1,20)})
	TRCell():New(oSection,"UNIDADE","","Unidade",/*Picture*/,15,/*lPixel*/			,{|| /*Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][4] ),1,15) , "") */})
	TRCell():New(oSection,"ZMCODCONT","","Ref.Contrato",/*Picture*/,15 ,/*lPixel*/,{|| Substr(Alltrim(QRYEMP->ZY_CODCONT),1,15)})
	TRCell():New(oSection,"ZMDTCONTR","","Dt.Contrato",/*Picture*/, nTamData ,/*lPixel*/,{|| STOD(QRYEMP->ZY_DTCONTR)})
	TRCell():New(oSection,"CODFORNEC","","Cod.Fornecedor",/*Picture*/,10 ,/*lPixel*/,{|| })
	TRCell():New(oSection,"NOMFORNEC","","Nome Fornecedor",/*Picture*/, 30 ,/*lPixel*/,{|| })
	TRCell():New(oSection,"DTVENC1","","Dt.Prim.Par.",/*Picture*/, nTamData ,/*lPixel*/,{|| STOD(QRYEMP->DTVENC1)})
	TRCell():New(oSection,"DTVENC2","","Dt.Ult.Parc.",/*Picture*/, nTamData ,/*lPixel*/,{|| STOD(QRYEMP->DTVENC2)})
	TRCell():New(oSection,"ZMDTQTCTR","","Dt.Quitação",/*Picture*/, nTamData ,/*lPixel*/,{|| QRYEMP->ZY_DTQTCTR})
	TRCell():New(oSection,"ZMVLRCONT","","Vlr.Contrato"	,"@E 99,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->ZY_VLRCONT})
	TRCell():New(oSection,"ZMTXJURMM","","Tx. De Juro"		,"@E 9,999.99999999",12 ,/*lPixel*/,{|| QRYEMP->ZY_TXJURMM})
	TRCell():New(oSection,"VLRPRIN1","","R$.Prin.1ª.Par."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRPRIN1})
	TRCell():New(oSection,"VLRJUR1","","R$.Juro.1ª.Par."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRJUR1})
	TRCell():New(oSection,"TOTAL1","","R$.Total.1ª.Parc."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->TOTAL1})
	TRCell():New(oSection,"VLRPRIN2","","R$.Prin.U.Par."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRPRIN2})
	TRCell():New(oSection,"VLRJUR2","","R$.Jur.U.Parc."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRJUR2})
	TRCell():New(oSection,"TOTAL2","","R$.Total Parc."	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->TOTAL2})
	TRCell():New(oSection,"VLRPRIN","","Vlr.Principal"	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRPRIN})
	TRCell():New(oSection,"VLRJUR","","Vlr.Juros"	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->VLRJUR})
	TRCell():New(oSection,"TOTAL","","Vlr.Total"	,"@E 99,999,999.99",12,/*lPixel*/,{|| QRYEMP->TOTAL})


	If oSection:nOrder = 1
		oBreak := TRBreak():New(oSection,oSection:Cell("ZMCODBCO"),"Sub Total Banco")
	Else
		oBreak := TRBreak():New(oSection,oSection:Cell("ZLDESCRI"),"Sub Total Modalide")
	EndIf

	TRFunction():New(oSection:Cell("ZMCODCONT"),NIL,"COUNT",oBreak)
	TRFunction():New(oSection:Cell("ZMVLRCONT"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("VLRPRIN1"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("VLRJUR1"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("TOTAL1"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("VLRPRIN2"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("VLRJUR2"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("TOTAL2"),Nil,"SUM",oBreak)

	TRFunction():New(oSection:Cell("VLRPRIN"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("VLRJUR"),Nil,"SUM",oBreak)
	TRFunction():New(oSection:Cell("TOTAL"),Nil,"SUM",oBreak)

Return oReport

Static Function PrintReport(oReport,oBreak)
	Local oSection := oReport:Section(1)
	//Local cPart
	//Local cFiltro   := ""
	Local nY := 0
	Local nX := 0
	Local ARECNOSM0 := {}
	Private aAnoMesRel := {}
//Carrega Filiais para Pegar o Nome.
	dbSelectArea( "SM0" )
	dbGoTop()
	While !SM0->( EOF() )
		aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME,SM0->M0_FILIAL } )
		SM0->( dbSkip() )
	EndDo

	cQAnoMes := " SELECT LEFT(SZZ.ZZ_DTVENC,6) ZZ_DTVENC "
	cQAnoMes += " FROM " + RetSqlName("SZZ") + " SZZ "
	cQAnoMes += " WHERE SZZ.D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	cQAnoMes += " AND SZZ.ZZ_DTVENC BETWEEN '" + DTOS(MV_PAR09) + "' AND '" + DTOS(MV_PAR10) + "' "
	cQAnoMes += " GROUP BY LEFT(SZZ.ZZ_DTVENC,6) "
	cQAnoMes += " ORDER BY ZZ_DTVENC "
	IF Select("TANOMES") > 0
		TANOMES->(DbCloseArea())
	EndIf
	TCQUERY cQAnoMes NEW ALIAS "TANOMES"
	While TANOMES->(!EOF())
		AaDd(aAnoMesRel,TANOMES->ZZ_DTVENC)
		TANOMES->(DbSkip())
	EndDo


//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 	
	MakeSqlExpr(cPerg)
	oSection:BeginQuery()
	cDataDe 	:= DTOS(MV_PAR01)
	cDataAt 	:= DTOS(MV_PAR02)
	cFilialDe:= Alltrim(MV_PAR03)
	cFilialAt:= Alltrim(MV_PAR04)
	cModFinDe:= Alltrim(MV_PAR05)
	cModFinat:= Alltrim(MV_PAR06)
	cCodContrDe := Alltrim(MV_PAR07)
	cCodContrAt := Alltrim(MV_PAR08)
	cDtVenConDe := DTOS(MV_PAR09)
	cDtVenconAt := DTOS(MV_PAR10)
	nCompeSaldo := MV_PAR11
	cDtRefRetro := Dtos(MV_PAR12)
	nPrincJuro  := MV_PAR13

	cVarVazio:= ""
	cVarzero := 0

	If oReport:nDevice == 4 //Se selecionou Planilha

		oSection:Init()
		For nY:=1 To Len(aAnoMesRel)
			If nPrincJuro == 2
				TRCell():New(oSection,"P"+Alltrim(aAnoMesRel[nY])+"P","","Princ." + Substr(Alltrim(aAnoMesRel[nY]),5,2) + "/" + Substr(Alltrim(aAnoMesRel[nY]),1,4) ,"@E 999,999,999.99"/*Picture*/, 15 ,/*lPixel*/		,/*{|| DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nY],QRYEMP->ZY_FILIAL)[1]}*/)
				TRFunction():New(oSection:Cell("P"+Alltrim(aAnoMesRel[nY])+"P"),Nil,"SUM",oBreak)
			ElseIf nPrincJuro == 3
				TRCell():New(oSection,"J"+Alltrim(aAnoMesRel[nY])+"J","","Juros." + Substr(Alltrim(aAnoMesRel[nY]),5,2) + "/" + Substr(Alltrim(aAnoMesRel[nY]),1,4) ,"@E 999,999,999.99"/*Picture*/, 15 ,/*lPixel*/		,/*{|| DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nY],QRYEMP->ZY_FILIAL)[2] }*/)
				TRFunction():New(oSection:Cell("J"+Alltrim(aAnoMesRel[nY])+"J"),Nil,"SUM",oBreak)
			Else
				TRCell():New(oSection,"P"+Alltrim(aAnoMesRel[nY])+"P","","Princ." + Substr(Alltrim(aAnoMesRel[nY]),5,2) + "/" + Substr(Alltrim(aAnoMesRel[nY]),1,4) ,"@E 999,999,999.99"/*Picture*/, 15 ,/*lPixel*/		,/*{|| DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nY],QRYEMP->ZY_FILIAL)[1]}*/)
				TRCell():New(oSection,"J"+Alltrim(aAnoMesRel[nY])+"J","","Juros." + Substr(Alltrim(aAnoMesRel[nY]),5,2) + "/" + Substr(Alltrim(aAnoMesRel[nY]),1,4) ,"@E 999,999,999.99"/*Picture*/, 15 ,/*lPixel*/		,/*{|| DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nY],QRYEMP->ZY_FILIAL)[2] }*/)
				TRFunction():New(oSection:Cell("P"+Alltrim(aAnoMesRel[nY])+"P"),Nil,"SUM",oBreak)
				TRFunction():New(oSection:Cell("J"+Alltrim(aAnoMesRel[nY])+"J"),Nil,"SUM",oBreak)
			EndIf
		Next nY

		cQryTemp := QryRelatorio()
		If Select("QRYEMP") > 0
			QRYEMP->(DbCloseArea())
		EndIf
		TCQUERY cQryTemp NEW ALIAS "QRYEMP"

		While QRYEMP->(!EOF())

			cNomeFilial := Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][5] ),1,15) , "")
			oSection:Cell("ZMCODBCO"):SetValue(Substr(Alltrim(QRYEMP->ZY_CODBCO),1,7))
			oSection:Cell("A6NOME"):SetValue(Substr(Alltrim(QRYEMP->A6_NOME),1,20))
			oSection:Cell("UNIDADE"):SetValue(cNomeFilial /*{|| Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][4] ),1,15) , "")}*/)
			oSection:Cell("ZLDESCRI"):SetValue(Substr(Alltrim(QRYEMP->ZW_DESCRI),1,20))
			oSection:Cell("ZMCODCONT"):SetValue(Substr(Alltrim(QRYEMP->ZY_CODCONT),1,15))
			oSection:Cell("ZMDTCONTR"):SetValue(STOD(QRYEMP->ZY_DTCONTR))
			cCodForn := Posicione("SZY",1,xFilial("SZY") + QRYEMP->ZY_CODSEQ,"ZY_CODFORN")
			cLojForn  := Posicione("SZY",1,xFilial("SZY") + QRYEMP->ZY_CODSEQ,"ZY_LOJFORN")
			oSection:Cell("CODFORNEC"):SetValue(cCodForn +" - "  + cLojForn)
			oSection:Cell("NOMFORNEC"):SetValue(Posicione("SA2",1,xFilial("SA2") + cCodForn + cLojForn,"A2_NOME"))
			oSection:Cell("DTVENC1"):SetValue(STOD(QRYEMP->DTVENC1))
			oSection:Cell("DTVENC2"):SetValue(STOD(QRYEMP->DTVENC2))
			oSection:Cell("ZMDTQTCTR"):SetValue(STOD(QRYEMP->ZY_DTQTCTR))
			oSection:Cell("ZMVLRCONT"):SetValue(QRYEMP->ZY_VLRCONT)
			oSection:Cell("ZMTXJURMM"):SetValue(QRYEMP->ZY_TXJURMM)

			//oSection:Cell("VLRPRIN1"):SetValue(QRYEMP->VLRPRIN1)
			//oSection:Cell("VLRJUR1"):SetValue(QRYEMP->VLRJUR1)
			//oSection:Cell("TOTAL1"):SetValue(QRYEMP->TOTAL1)
			//oSection:Cell("VLRPRIN2"):SetValue(QRYEMP->VLRPRIN2)
			//oSection:Cell("VLRJUR2"):SetValue(QRYEMP->VLRJUR2)
			oSection:Cell("VLRPRIN1"):Disable()
			oSection:Cell("VLRJUR1"):Disable()
			oSection:Cell("TOTAL1"):Disable()
			oSection:Cell("VLRPRIN2"):Disable()
			oSection:Cell("VLRJUR2"):Disable()

			If oReport:nDevice == 4 //Se selecionou Planilha
				aDetParc := DetParCon(QRYEMP->ZY_CODSEQ,"",QRYEMP->ZY_FILIAL)
				//For nX:=1 To Len(aAnoMesRel)
				//oSection:Cell("P"+aAnoMesRel[nX]+"P"):SetValue(DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nX],QRYEMP->ZY_FILIAL)[1])
				//oSection:Cell("J"+aAnoMesRel[nX]+"J"):SetValue(DetParCon(QRYEMP->ZY_CODSEQ,aAnoMesRel[nX],QRYEMP->ZY_FILIAL)[2])
				//Next
				nCont:=0
				For nY:=1 To Len(aAnoMesRel)
					If nPrincJuro == 2
						oSection:Cell("P"+Alltrim(aAnoMesRel[nY])+"P"):SetValue(0)
					ElseIf nPrincJuro == 3
						oSection:Cell("J"+Alltrim(aAnoMesRel[nY])+"J"):SetValue(0)
					Else
						oSection:Cell("P"+Alltrim(aAnoMesRel[nY])+"P"):SetValue(0)
						oSection:Cell("J"+Alltrim(aAnoMesRel[nY])+"J"):SetValue(0)
					Endif
				Next nY
				For nX := 1 To Len(aDetParc)
					nCont++
					If nPrincJuro == 2
						oSection:Cell("P"+aDetParc[nX][4]+"P"):SetValue(aDetParc[nX][5])
					ElseIf nPrincJuro == 3
						oSection:Cell("J"+aDetParc[nX][4]+"J"):SetValue(aDetParc[nX][6])
					Else
						oSection:Cell("P"+aDetParc[nX][4]+"P"):SetValue(aDetParc[nX][5])
						oSection:Cell("J"+aDetParc[nX][4]+"J"):SetValue(aDetParc[nX][6])
					EndIf
	 			/*
					If Mod(ncont,2) == 0
	 				oSection:Cell("P"+aDetParc[nX][4]+"P"):nClrBack := 16711680               
	 				oSection:Cell("J"+aDetParc[nX][4]+"J"):nClrBack := 65280
					Else
	 				oSection:Cell("P"+aDetParc[nX][4]+"P"):nClrBack := 65280
	 				oSection:Cell("J"+aDetParc[nX][4]+"J"):nClrBack := 16711680
					EndIf
	 			*/
				Next nX
			EndIf
			oSection:Cell("TOTAL2"):SetValue(QRYEMP->TOTAL2)
			oSection:Cell("VLRPRIN"):SetValue(QRYEMP->VLRPRIN)
			oSection:Cell("VLRJUR"):SetValue(QRYEMP->VLRJUR)
			oSection:Cell("TOTAL"):SetValue(QRYEMP->TOTAL)
			oSection:PrintLine()
			oReport:SkipLine(1)
			//oSection:Finish()
			QRYEMP->(DbSkip())
		EndDo

	Else
		BeginSql alias "QRYEMP"
		
		SELECT  
			SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI,SZY.ZY_FILIAL,SZY.ZY_CODSEQ,SZY.ZY_CODCONT,SZY.ZY_DTCONTR,SZY.ZY_DTQTCTR,SZY.ZY_VLRCONT,SZY.ZY_TXJURMM,
			SZZT.DTVENC1,SZZT.VLRPRIN1,SZZT.VLRJUR1,SZZT.TOTAL1,
			SZZU.DTVENC2,SZZU.VLRPRIN2,SZZU.VLRJUR2,SZZU.TOTAL2,
			SZZP.VLRPRIN,SZZP.VLRJUR,SZZP.TOTAL
		FROM %table:SZY% SZY
		JOIN %table:SZW% SZW ON SZW.%notDel% AND SZW.ZW_FILIAL = %xfilial:SZW%  AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN
		JOIN %table:SA6% SA6 ON SA6.%notDel% AND SA6.A6_FILIAL = %xfilial:SA6% AND SA6.A6_COD = SZY.ZY_CODBCO AND SA6.A6_AGENCIA = SZY.ZY_BCOAGEN AND SA6.A6_NUMCON = SZY.ZY_BCOCONT
		JOIN (
				SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) VLRJUR, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL 
				FROM %table:SZZ% SZZ
				WHERE SZZ.%notDel% AND SZZ.ZZ_FILIAL BETWEEN  %exp:cFilialDe% AND %exp:cFilialAt% 
				AND SZZ.ZZ_VRPGPAR = %exp:cVarZero%  AND SZZ.ZZ_DTPGPAR = %exp:cVarVazio% 
				GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO) SZZP ON SZZP.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZP.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZP.ZZ_REVISAO = SZY.ZY_REVISAO
		
		JOIN(
			SELECT SZZ.ZZ_FILIAL ,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC DTVENC1,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN1,ROUND(SUM(SZZ.ZZ_VLRJUR+ SZZ.ZZ_VJURVAR),2) VLRJUR1, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL1 
			FROM %table:SZZ% SZZ 
			WHERE SZZ.%notDel% AND SZZ.ZZ_FILIAL BETWEEN %exp:cFilialDe% AND %exp:cFilialAt%
			AND SZZ.R_E_C_N_O_ = (SELECT MIN(R_E_C_N_O_) RECNOS  FROM %table:SZZ% SZZN
			WHERE SZZN.%notDel% AND SZZN.ZZ_FILIAL = SZZ.ZZ_FILIAL AND SZZN.ZZ_CODSEQ = SZZ.ZZ_CODSEQ )
			GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC
			) SZZT ON SZZT.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZT.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZT.ZZ_REVISAO = SZY.ZY_REVISAO 
		JOIN(
			SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC DTVENC2,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN2,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) VLRJUR2, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL2 
			FROM %table:SZZ% SZZ 
			WHERE SZZ.%notDel% AND SZZ.ZZ_FILIAL BETWEEN %exp:cFilialDe% AND %exp:cFilialAt%
			AND SZZ.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) RECNOS  FROM %table:SZZ% SZZN 
			WHERE SZZN.%notDel% AND SZZN.ZZ_FILIAL = SZZ.ZZ_FILIAL AND SZZN.ZZ_CODSEQ = SZZ.ZZ_CODSEQ AND SZZN.ZZ_REVISAO = SZZ.ZZ_REVISAO)
			GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC	
			) SZZU ON SZZU.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZU.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZU.ZZ_REVISAO = SZY.ZY_REVISAO
		
		WHERE SZY.%notDel% AND SZY.ZY_FILIAL BETWEEN %exp:cFilialDe% AND %exp:cFilialAt%
				AND SZY.ZY_DTCONTR BETWEEN %exp:cDataDe% AND %exp:cDataAt%
				AND SZY.ZY_MODFIIN BETWEEN %exp:cModFinDe% AND %exp:cModFinAt%
				AND SZY.ZY_CODSEQ BETWEEN %exp:cCodContrDe% AND %exp:cCodContrAt%
		 		ORDER BY SZY.ZY_FILIAL,SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI
		EndSql
		oSection:Cell("ZMCODBCO"):Disable()
/*	Prepara relatorio para executar a query gerada pelo Embedded SQL passando como 	parametro a pergunta ou vetor com perguntas do tipo Range que foram alterados 	pela funcao MakeSqlExpr para serem adicionados a query	*/	
		oSection:EndQuery()
		cSqlBkp := GetLastQuery()
	EndIf

	oSection:Print()
	oSection:Finish()
Return




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
	AADD(aRegs,{cPerg,"01","Dt.Contrato De: ","","","mv_ch1" ,"D",08,0,0,"G",""           ,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Dt.Contrato Até:","","","mv_ch2" ,"D",08,0,0,"G","" 				,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Filial De:    ","","","mv_ch3" ,"C",04,0,0,"G",""           ,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"04","Filal Até:    ","","","mv_ch4" ,"C",04,0,0,"G","NaoVazio()" ,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"05","Modalidade De:","","","mv_ch5" ,"C",03,0,0,"G",""           ,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SZW","","","","",""})
	AADD(aRegs,{cPerg,"06","Modalidade Até:","","","mv_ch6" ,"C",03,0,0,"G","NaoVazio()","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SZW","","","","",""})
	AADD(aRegs,{cPerg,"07","Contrato De:"  ,"","","mv_ch7" ,"C",09,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SZY","","","","",""})
	AADD(aRegs,{cPerg,"08","Contrato Até:" ,"","","mv_ch8" ,"C",09,0,0,"G","NaoVazio()","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SZY","","","","",""})
	AADD(aRegs,{cPerg,"09","Dt.Vencto De: ","","","mv_ch9" ,"D",08,0,0,"G",""           ,"MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Dt.Vencto Até:","","","mv_chA" ,"D",08,0,0,"G","" 				,"MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"11","Comp.Sld.Retro?","","","mv_chB","C",01,0,0,"C",""           ,"MV_PAR11","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Dt.Ref.Retroat.","","","mv_chC" ,"D",08,0,0,"G","" 			,"MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"13","Princal/Juros?","","","mv_chD" ,"C",01,0,0,"C",""           ,"MV_PAR13","Ambos","","","","","Principal","","","","","Juros","","","","","","","","","","","","","","","","","","",""})
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


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
//³FUNÇÃO PARA BUSCAR AS PARCELAS MES A MES DO CONTRATO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
ENDDOC*/
Static Function DetParCon(cNumContr,cAnoMes,cDetFilPesq)
Local aRetDet := {}
Default cNumContr := ""
Default cAnoMes := ""
Default cDetFilPesq := ""
//Default cDetFilAt := ""
cQryDet := " SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_CODCONT,LEFT(SZZ.ZZ_DTVENC,6) ZZ_DTVENC,SUM(SZZ.ZZ_VLRPRIN) ZZ_VLRPRIN,SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR) ZZ_VLRJUR,SUM(SZZ.ZZ_PARAPAG) ZZ_PARAPAG "
cQryDet += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
cQryDet += ENTER + " WHERE SZZ.D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + cDetFilPesq + "' "
cQryDet += ENTER + " AND SZZ.ZZ_DTVENC BETWEEN '" + cDtVenConDe /*Dtos(DDataBase)*/ + "' AND '" + cDtVenConAt + "' "
cQryDet += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cNumContr + "' AND SZZ.ZZ_PARAPAG > 0	 "
	If nCompeSaldo == 2
	cQryDet += ENTER + " AND SZZ.ZZ_VRPGPAR <= 0 " 
	Else
	cQryDet += ENTER + "				AND (SZZ.ZZ_DTPGPAR = ''  OR SZZ.ZZ_DTPGPAR >= '" + cDtRefRetro + "' ) "   
	Endif
//cQryDet += ENTER + " AND LEFT(SZZ.ZZ_DTVENC,6) = '" + cAnoMes + "' "
cQryDet += ENTER + " GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_CODCONT,LEFT(SZZ.ZZ_DTVENC,6) "
	IF Select("TMPPAR") > 0
     TMPPAR->(DbCloseAre())
	EndIf
TCQUERY cQryDet NEW ALIAS "TMPPAR"
	IF TMPPAR->(!EOF())
		While	TMPPAR->(!EOF())
		aAdd(aRetDet,{TMPPAR->ZZ_FILIAL,TMPPAR->ZZ_CODSEQ,TMPPAR->ZZ_CODCONT,TMPPAR->ZZ_DTVENC,TMPPAR->ZZ_VLRPRIN,TMPPAR->ZZ_VLRJUR,TMPPAR->ZZ_PARAPAG})
		//aRetDet := {TMPPAR->ZZ_VLRPRIN,TMPPAR->ZZ_VLRJUR,TMPPAR->ZZ_PARAPAG} 
		TMPPAR->(DbSkip())	
		EndDo
	Else
	aAdd(aRetDet,{"","","",LEFT(DTOS(DDATABASE),6),0,0,0})
	EndIf
	IF Select("TMPPAR") > 0
     TMPPAR->(DbCloseAre())
	EndIf
Return aRetDet

Static Function QryRelatorio()
Local cQryRel := ""
	
cQryRel := "	SELECT  
cQryRel += ENTER + "	SZY.ZY_FILIAL,SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI,SZY.ZY_FILIAL,SZY.ZY_CODSEQ,SZY.ZY_CODCONT,SZY.ZY_DTCONTR,SZY.ZY_DTQTCTR,SZY.ZY_VLRCONT,SZY.ZY_TXJURMM, "
cQryRel += ENTER + "			SZZT.DTVENC1,SZZT.VLRPRIN1,SZZT.VLRJUR1,SZZT.TOTAL1, "
cQryRel += ENTER + "			SZZU.DTVENC2,SZZU.VLRPRIN2,SZZU.VLRJUR2,SZZU.TOTAL2, "
cQryRel += ENTER + "			SZZP.VLRPRIN,SZZP.VLRJUR,SZZP.TOTAL "
cQryRel += ENTER + "		FROM " + RetSqlName("SZY") + " SZY "
cQryRel += ENTER + "		JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ = '' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
cQryRel += ENTER + "		LEFT JOIN " + RetSqlName("SA6") + " SA6 ON SA6.D_E_L_E_T_ = '' AND SA6.A6_FILIAL = '" + xfilial("SA6") + "' AND SA6.A6_COD = SZY.ZY_CODBCO AND SA6.A6_AGENCIA = SZY.ZY_BCOAGEN AND SA6.A6_NUMCON = SZY.ZY_BCOCONT "
cQryRel += ENTER + "		JOIN ( "
	If nCompeSaldo == 2
	cQryRel += ENTER + "				SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN,"
	cQryRel += ENTER + " ROUND(SUM(CASE WHEN SZZ.ZZ_PARAPAG > 0 AND SZZ.ZZ_VLRPRIN <= 0  THEN SZZ.ZZ_PARAPAG  ELSE CASE WHEN  SZZ.ZZ_PARAPAG > 0 AND SZZ.ZZ_VLRPRIN > 0 THEN  SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR ELSE 0 END END),2)  VLRJUR,ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL " //ROUND(SUM(CASE WHEN SZZ.ZZ_PARAPAG > 0 THEN SZZ.ZZ_VLRJUR ELSE 0 END),2) VLRJUR, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL "
	Else
	cQryRel += ENTER + "				SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) VLRJUR, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL "
	EndIf
cQryRel += ENTER + "				FROM " + RetSqlName("SZZ") + " SZZ "
cQryRel += ENTER + "		WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN  '" + cFilialDe + "' AND '" + cFilialAt + "' " 
	If nCompeSaldo == 2
	cQryRel += ENTER + "				AND SZZ.ZZ_VRPGPAR = " + Alltrim(STR(cVarZero)) + "  AND SZZ.ZZ_DTPGPAR = '" + cVarVazio + "' "  	
	Else
	cQryRel += ENTER + "				AND (SZZ.ZZ_DTPGPAR = '" + cVarVazio + "'  OR SZZ.ZZ_DTPGPAR >= '" + cDtRefRetro + "' ) "   
	EndIf
cQryRel += ENTER + "				GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO) SZZP ON SZZP.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZP.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZP.ZZ_REVISAO = SZY.ZY_REVISAO "
cQryRel += ENTER + "		JOIN( "
cQryRel += ENTER + "			SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC DTVENC1,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN1,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) VLRJUR1, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL1 "
cQryRel += ENTER + "			FROM " + RetSqlName("SZZ") + " SZZ "
cQryRel += ENTER + "			WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN '" + cFilialDe + "'  AND '" + cFilialAt + "' "
cQryRel += ENTER + "			AND SZZ.R_E_C_N_O_ = (SELECT MIN(R_E_C_N_O_) RECNOS  FROM " + RetSqlName("SZZ") + " SZZN "
cQryRel += ENTER + "			WHERE SZZN.D_E_L_E_T_ = '' AND SZZN.ZZ_FILIAL = SZZ.ZZ_FILIAL AND SZZN.ZZ_CODSEQ = SZZ.ZZ_CODSEQ ) "
cQryRel += ENTER + "			GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC "
cQryRel += ENTER + "			) SZZT ON SZZT.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZT.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZT.ZZ_REVISAO = SZY.ZY_REVISAO  "
cQryRel += ENTER + "		JOIN( "
cQryRel += ENTER + "			SELECT SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC DTVENC2,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) VLRPRIN2,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) VLRJUR2, ROUND(SUM(SZZ.ZZ_PARAPAG),2) TOTAL2  "
cQryRel += ENTER + "			FROM " + RetSQlName("SZZ") + " SZZ "  
cQryRel += ENTER + "			WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAt + "' "
cQryRel += ENTER + "			AND SZZ.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) RECNOS  FROM " + RetSqlName("SZZ") + " SZZN "
cQryRel += ENTER + "			WHERE SZZN.D_E_L_E_T_ = '' AND SZZN.ZZ_FILIAL = SZZ.ZZ_FILIAL AND SZZN.ZZ_CODSEQ = SZZ.ZZ_CODSEQ AND SZZN.ZZ_REVISAO = SZZ.ZZ_REVISAO) "
cQryRel += ENTER + "		GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO,SZZ.ZZ_DTVENC	"
cQryRel += ENTER + "		)  SZZU ON SZZU.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZU.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZU.ZZ_REVISAO = SZY.ZY_REVISAO "
cQryRel += ENTER + "	WHERE SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAt + "' "
cQryRel += ENTER + "			AND SZY.ZY_DTCONTR BETWEEN '" + cDataDe + "' AND '" + cDataAt +"' "
cQryRel += ENTER + "			AND SZY.ZY_MODFIIN BETWEEN '" + cModFinDe + "' AND '" + cModFinAt + "' "
cQryRel += ENTER + "			AND SZY.ZY_CODSEQ BETWEEN '" + cCodContrDe + "' AND '" + cCodContrAt + "' "
cQryRel += ENTER + "	 		ORDER BY SZY.ZY_FILIAL,SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI "

Return cQryRel
