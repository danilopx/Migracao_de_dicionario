#include "protheus.ch"
#include "Topconn.ch"
#Include "RwMake.ch"
#Include "Tbiconn.ch"
#DEFINE ENTER CHAR(13) + CHAR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RDGFIN02  ºAutor  ³ Jackson Santos     º Data ³  05/05/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Detalhado de Endividamento   		              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                      	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RDGFIN03()
	Local oReport
	Private cPerg := "REDV03"
	Private aPropSZW := {}
	Private aBancos  := {}
	If TRepInUse()
		ValidPerg(cPerg)
		Pergunte(cPerg,.T.)
		oReport := ReportDef()
		oReport:SetParam(cPerg)
		oReport:PrintDialog()
	EndIf
	If Select("QRYEMP") > 0
		QRYEMP->(DbCloseArea())
	EndIf
Return

Static Function ReportDef()
	Local oReport
	Local oSection
	Local oBreak
	Local aRecnoSM0 := {}
	//Local nTamData  	:= Len(DTOC(MsDate()))
	Local nX := 0

//Carrega Filiais para Pegar o Nome.
	dbSelectArea( "SM0" )
	dbGoTop()
	While !SM0->( EOF() )
		aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME,SM0->M0_FILIAL } )
		SM0->( dbSkip() )
	EndDo

	AAdd(aBancos,{"001","BANCO DO BRASIL"})
//AAdd(aBancos,{"001","BANCO DO BRASIL"})  
	AAdd(aBancos,{"021","BANCO BANESTES"})
	AAdd(aBancos,{"033","SANTANDER"})
	AAdd(aBancos,{"041","BANRISUL"})
	AAdd(aBancos,{"074","BANCO SAFRA"})
	AAdd(aBancos,{"104","CAIXA ECONOMICA FEDERAL"})
	AAdd(aBancos,{"237","BRADESCO"})
	AAdd(aBancos,{"341","ITAU"})
	AAdd(aBancos,{"399","HSBC"})
	AAdd(aBancos,{"422","BANCO SAFRA"})
	AAdd(aBancos,{"655","BANCO VOTORANTIM"})


	cQrySZW := " SELECT ZW_CODIGO CODIGO,ZW_DESCRI DESCRICAO "
	cQrySZW += ENTER + " FROM " + RetSqlName("SZW") + " SZW "
	cQrySZW += ENTER + " WHERE SZW.D_E_L_E_T_ = '' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' "
	cQrySZW += ENTER + " ORDER BY DESCRICAO,SZW.ZW_CODIGO "
	IF Select("TSZW") > 0
		TSZW->(DbCloseArea())
	EndIF
	TCQUERY cQrySZW NEW ALIAS "TSZW"
	While TSZW->(!EOF())
		AaDd(aPropSZW,{TSZW->CODIGO,TSZW->DESCRICAO})
		TSZW->(DbSkip())
	EndDo
	IF Select("TSZW") > 0
		TSZW->(DbCloseArea())
	EndIF


	oReport := TReport():New("RDGFIN03","Report Mensal ","RDGF03",{|oReport| PrintReport(oReport)},"Relatorio de Endividamento - Report Mensal")
//oReport:SetLandscape()
	oSection := TRSection():New(oReport,"Mensal",{})
	oSection:SetTotalInLine(.F.)

	If MV_PAR05==1
		TRCell():New(oSection,"UNIDADE","","Unidade",/*Picture*/,15,/*lPixel*/			,{|| Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZW_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZW_FILIAL),Len(x[3])) } )][5] ),1,15) , "") })
	EndIF
	TRCell():New(oSection,"BANCO","","Banco",/*Picture*/,30 ,/*lPixel*/			,{|| iif( aScan(aBancos,{|x| x[1] == LEFT(Alltrim(QRYEMP->BANCO),3)}) > 0, LEFT(Alltrim(QRYEMP->BANCO),3) + "-" + aBancos[aScan(aBancos,{|x| x[1]== LEFT(Alltrim(QRYEMP->BANCO),3)})][2],IIF(Empty(Alltrim(QRYEMP->BANCO)),"BOLETO",Alltrim(QRYEMP->BANCO)))})

	For nX := 1 To Len(aPropSZW)
		TRCell():New(oSection,"SZW" + aPropSZW[nX][1],"",Alltrim(aPropSZW[nX][2]),"@E 999,999,999.99"/*Picture*/, 15 ,/*lPixel*/		,{|| QRYEMP->&("SZW" + aPropSZW[nX][1])})
	Next nX

	TRCell():New(oSection,"TOTAL","","Vlr.Total"	,"@E 9,999,999,999.99",18,/*lPixel*/,{|| QRYEMP->TOTAL})

	If MV_PAR05==1
		oBreak := TRBreak():New(oSection,oSection:Cell("UNIDADE"),"Sub Total da Unidade")
		TRFunction():New(oSection:Cell("BANCO"),NIL,"COUNT",oBreak)
		For nX := 1 To Len(aPropSZW)
			TRFunction():New(oSection:Cell("SZW" + aPropSZW[nX][1]),NIL,"SUM",oBreak)
		Next nX
	Else
		//oBreak := TRBreak():New(oSection,oSection:Cell("BANCO"),"Sub Total do Banco")
	EndIf


Return oReport

Static Function PrintReport(oReport)
	Local oSection := oReport:Section(1)
	//Local cPart
	//Local cFiltro   := ""
	Local nX := 0

//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 	
	MakeSqlExpr(cPerg)

	cDataDe 	:= DTOS(MV_PAR01)
	cDataAt 	:= DTOS(MV_PAR02)
	cFilialDe:= Alltrim(MV_PAR03)
	cFilialAt:= Alltrim(MV_PAR04)
	nConsFilial := MV_PAR05
	nConsBanco 	:= MV_PAR06
	nPrincJuro  := MV_PAR07
	cBancoDe		:= MV_PAR08
	cBancoAt		:= MV_PAR09

	Pivot(aPropSZW,"QRYEMP",cDataDe,cDataAt,cFilialDe,cFilialAt,nPrincJuro)
	oSection:Init()

	While QRYEMP->(!EOF())


		//If nConsFilial <> 1
		//	oSection:Cell("UNIDADE"):Disable()
		//EndIf
		If nConsBanco <> 1
			oSection:Cell("BANCO"):Disable()
		Else
			oSection:Cell("BANCO"):SetValue(iif( aScan(aBancos,{|x| x[1] == LEFT(Alltrim(QRYEMP->BANCO),3)}) > 0, LEFT(Alltrim(QRYEMP->BANCO),3) + "-" + aBancos[aScan(aBancos,{|x| x[1]== LEFT(Alltrim(QRYEMP->BANCO),3)})][2],IIF(Empty(Alltrim(QRYEMP->BANCO)),"BOLETO",Alltrim(QRYEMP->BANCO)))/*Alltrim(QRYEMP->BANCO)*/)
		EndIf
		For nX := 1 To Len(aPropSZW)
			cVarSZW := "SZW" + aPropSZW[nX][1]
			oSection:Cell(Alltrim(cVarSZW)):SetValue(QRYEMP->&(Alltrim(cVarSZW)))
		Next nX
		oSection:Cell("TOTAL"):SetValue(QRYEMP->TOTAL)

		oSection:PrintLine()
		QRYEMP->(DbSkip())
	EndDo

	If Select("QRYEMP") > 0
		QRYEMP->(DbCloseArea())
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
	AADD(aRegs,{cPerg,"01","Periodo De: ","","","mv_ch1" ,"D",08,0,0,"G",""           ,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Periodo Até:  ","","","mv_ch2" ,"D",08,0,0,"G","" 				,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Filial De:    ","","","mv_ch3" ,"C",04,0,0,"G",""           ,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"04","Filal Até:    ","","","mv_ch4" ,"C",04,0,0,"G","NaoVazio()" ,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"05","Cons. Unidade ?","","","mv_ch5" ,"C",01,0,0,"C",""           ,"MV_PAR05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"06","Cons. Banco   ?","","","mv_ch6" ,"C",01,0,0,"C",""           ,"MV_PAR06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"07","Princal/Juros?","","","mv_ch7" ,"C",01,0,0,"C",""           ,"MV_PAR07","Ambos","","","","","Principal","","","","","Juros","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"08","Banco De:    ","","","mv_ch8" ,"C",03,0,0,"G",""           ,"MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","","",""})
	AADD(aRegs,{cPerg,"09","Banco Até:   ","","","mv_ch9" ,"C",03,0,0,"G","NaoVazio()" ,"MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","","",""})

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


Static Function Pivot(aPivot,cAlias,cDataDe,cDataAt,cFilialDe,cFilialAt,nPrincJuro)
	Local cQuery :=""
	Local cCrlf  := Chr(13)+Chr(10)
	Local nY := 0

	Default aPivot := {}
	Default cAlias := ""
	DEfault cDataDe := ""
	Default cDataAt := ""
	Default cFilialDe := ""
	DEfault cFilialAt := ""
	Default nPrincJuro := 0

//cQuery:= " SELECT ZW_FILIAL, BANCO + '-' +  BCONOME BANCO , "
	If nConsFilial == 1
		cQuery:= " SELECT ZW_FILIAL, BANCO + '-' + (SELECT TOP 1 A6_NOME FROM " + RetSqlName("SA6") + " SA6N WHERE SA6N.D_E_L_E_T_ = '' AND SA6N.A6_FILIAL = '' AND SA6N.A6_COD = BANCO)  BANCO, "
	Else
		cQuery:= " SELECT  BANCO + '-' + (SELECT TOP 1 A6_NOME FROM " + RetSqlName("SA6") + " SA6N WHERE SA6N.D_E_L_E_T_ = '' AND SA6N.A6_FILIAL = '' AND SA6N.A6_COD = BANCO)  BANCO, "
	EndIf
	For nY:=1 To len(aPropSZW)
		cQuery += cCrlf +	" ISNULL([" + aPropSZW[nY][1] + "],0) AS " + "SZW" + aPropSZW[nY][1] + " ,"
	Next nY

	For nY:=1 To len(aPropSZW)
		If nY < Len(aPropSZW)
			cQuery += cCrlf +	" ISNULL([" + aPropSZW[nY][1] + "],0) + "
		Else
			cQuery += cCrlf + " ISNULL([" + aPropSZW[nY][1] + "],0) AS " + "TOTAL"
		EndIf
	Next nY
	cQuery += cCrlf +	" FROM ( "
//cQuery += cCrlf +	" SELECT SZW.ZW_FILIAL,SZW.ZW_CODIGO,SLD.BANCO,SLD.BCONOME,SLD.SALDO FROM " + RetSqlName("SZW") + " SZW
	If nConsFilial == 1
		cQuery += cCrlf +	" SELECT SZW.ZW_FILIAL,SZW.ZW_CODIGO,SLD.BANCO,SLD.SALDO FROM " + RetSqlName("SZW") + " SZW
	Else
		cQuery += cCrlf +	" SELECT SZW.ZW_CODIGO,SLD.BANCO,SLD.SALDO FROM " + RetSqlName("SZW") + " SZW
	EndIf
	cQuery += cCrlf +	" JOIN ( "
//cQuery += cCrlf +	" 	SELECT SZY.ZY_MODFIIN,SZY.ZY_CODBCO BANCO,SA6.A6_NOME BCONOME,ROUND(SUM(" 
	cQuery += cCrlf +	" 	SELECT SZY.ZY_FILIAL,SZY.ZY_MODFIIN,SZY.ZY_CODBCO BANCO,ROUND(SUM("
	If nPrincJuro == 2
		cQuery += cCrlf + "SZZ.ZZ_VLRPRIN "
	ElseIf nPrincJuro == 3
		cQuery += cCrlf + " CASE WHEN SZZ.ZZ_PARAPAG > 0 AND SZZ.ZZ_VLRPRIN <= 0  THEN SZZ.ZZ_PARAPAG  ELSE CASE WHEN  SZZ.ZZ_PARAPAG > 0 AND SZZ.ZZ_VLRPRIN > 0 THEN  SZZ.ZZ_VLRJUR  ELSE 0 END END "
	Else
		cQuery += cCrlf + "SZZ.ZZ_PARAPAG "
	EndIf
	cQuery += cCrlf +	"),2) SALDO FROM " + RetSqlName("SZZ") + " SZZ  "
	cQuery += cCrlf +	" 	JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL = SZZ.ZZ_FILIAL AND SZY.ZY_CODSEQ = SZZ.ZZ_CODSEQ
	cQuery += cCrlf +	" 	AND SZY.ZY_REVISAO = SZZ.ZZ_REVISAO AND SZY.ZY_DTCONTR BETWEEN '" + cDataDe + "' AND '" + cDataAt + "' AND SZY.ZY_CODBCO BETWEEN '" + cBancoDe + "' AND '" + cBancoAt + "' "
	cQuery += cCrlf +	" 	LEFT JOIN " + RetSqlName("SA6") + " SA6 ON SA6.D_E_L_E_T_ = '' AND SA6.A6_FILIAL = '' AND SA6.A6_COD = SZY.ZY_CODBCO AND SA6.A6_AGENCIA = SZY.ZY_BCOAGEN AND SA6.A6_NUMCON = SZY.ZY_BCOCONT "
	cQuery += cCrlf +	" 	WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN  '" + cFilialDe + "' AND '" + cFilialAt + "' "
	cQuery += cCrlf +	" 	AND SZZ.ZZ_DTPGPAR = '' AND SZZ.ZZ_PARAPAG > 0 "
//cQuery += cCrlf +	" 	GROUP BY SZY.ZY_MODFIIN,SZY.ZY_CODBCO,SA6.A6_NOME "
	cQuery += cCrlf +	" 	GROUP BY SZY.ZY_FILIAL,SZY.ZY_MODFIIN,SZY.ZY_CODBCO "

	cQuery += cCrlf +	" ) SLD ON SLD.ZY_MODFIIN  = SZW.ZW_CODIGO AND SLD.ZY_FILIAL = SZW.ZW_FILIAL "
	cQuery += cCrlf +	" WHERE SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL BETWEEN  '" + cFilialDe + "' AND '" + cFilialAt + "' "
	cQuery += cCrlf +	" AND SZW.ZW_CODIGO BETWEEN '' AND 'ZZZ'"
	cQuery += cCrlf +	" ) PIVTAB "
	cQuery += cCrlf +	" PIVOT( SUM(SALDO)  FOR ZW_CODIGO IN ( "
	For nY:=1 To len(aPropSZW)
		If nY < Len(aPropSZW)
			cQuery += cCrlf +	"[" + aPropSZW[nY][1] + "],"
		Else
			cQuery += cCrlf +	"[" + aPropSZW[nY][1] + "]"
		EndIf
	Next nY
	cQuery += cCrlf +	" 	)) AS PIVRES "
	If Select(cAlias) > 0
		(cAlias)->(DbClosearea())
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.F.)
	DbSelectArea(cAlias)

Return
