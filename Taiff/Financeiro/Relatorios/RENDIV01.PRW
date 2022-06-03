#include "protheus.ch"
#include "Topconn.ch"
#include "Tbiconn.ch"
#Define ENTER Char(13) + Char(10)

User Function RENDIV01()
Local oReport
Private cPerg := "REDV01"
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

//Carrega Filiais para Pegar o Nome.
dbSelectArea( "SM0" )
dbGoTop()
While !SM0->( EOF() )
		aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->M0_NOME,SM0->M0_FILIAL } )
	SM0->( dbSkip() )
EndDo
oReport := TReport():New("RENDIV01","Endividamento Geral",cPerg,{|oReport| PrintReport(oReport,aRecnoSM0)},"Relatorio de Endividamento Geral")
oReport:SetLandscape()
oSection := TRSection():New(oReport,"Endividamento",{})                                                   
oSection:SetTotalInLine(.F.)                               

TRCell():New(oSection,"ZY_FILIAL","","Cod.Unid",/*Picture*/,8  ,/*lPixel*/		,{|| Alltrim(QRYEMP->ZY_FILIAL)})
TRCell():New(oSection,"UNIDADE","","Unidade",/*Picture*/,15,/*lPixel*/			,{|| Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][4] ),1,15) , "") })
TRCell():New(oSection,"ZMCODBCO","","Cod.Bco",/*Picture*/,7 ,/*lPixel*/			,{|| Substr(Alltrim(QRYEMP->ZY_CODBCO),1,7)})
TRCell():New(oSection,"A6NOME","","Banco",/*Picture*/, 20 ,/*lPixel*/			,{|| IIF(Empty(Alltrim(QRYEMP->A6_NOME)),"BOLETO",Substr(Alltrim(QRYEMP->A6_NOME),1,20))})
TRCell():New(oSection,"ZLDESCRI","","Modalidade",/*Picture*/, 20  ,/*lPixel*/,{|| Substr(Alltrim(QRYEMP->ZW_DESCRI),1,20)})
TRCell():New(oSection,"ZMCODSEQ","","Cod.Contr."  ,/*Picture*/, 10 ,/*lPixel*/,{|| Substr(Alltrim(QRYEMP->ZY_CODSEQ),1,10)})
TRCell():New(oSection,"ZMCODCONT","","Ref.Contrato",/*Picture*/,15 ,/*lPixel*/,{|| Substr(Alltrim(QRYEMP->ZY_CODCONT),1,15)})
TRCell():New(oSection,"ZMDTCONTR","","Dt.Contrato",/*Picture*/, nTamData ,/*lPixel*/,{|| QRYEMP->ZY_DTCONTR})
TRCell():New(oSection,"ZMDTQTCTR","","Dt.Quitação",/*Picture*/, nTamData ,/*lPixel*/,{|| QRYEMP->ZY_DTQTCTR})
TRCell():New(oSection,"ZMVLRCONT","","Vlr.Contrato"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->ZY_VLRCONT})
TRCell():New(oSection,"ZMVRTOTFI","","Vlr.Tot.Fin."	,"@E 999,999,999.99",12,/*lPixel*/,{|| QRYEMP->ZY_VRTOTFI})
TRCell():New(oSection,"VLRTOTCTR","","Vlr.Tot.Ctr."   ,"@E 999,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->VLRTOTCTR})
TRCell():New(oSection,"ZNVLRJUR" ,"" ,"Vlr.Juros  "	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->ZZ_VLRJUR})
TRCell():New(oSection,"ZNVJURVAR","","Vlr.Jur.Var."	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->ZZ_VJURVAR})
TRCell():New(oSection,"ZNPARAPAG","","Parc.A Pagar"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| QRYEMP->ZZ_PARAPAG})
TRCell():New(oSection,"JUROCURTO","","Juro.C.Prazo"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[1]})
TRCell():New(oSection,"JUROLONGO","","Juro.L.Prazo"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[2]})
TRCell():New(oSection,"PRINCURTO","","Prin.C.Prazo"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[3]})
TRCell():New(oSection,"PRINLONGO","","Prin.L.Prazo"	,"@E 999,999,999.99",12 ,/*lPixel*/,{|| CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[4]})

oBreak := TRBreak():New(oSection,oSection:Cell("ZY_FILIAL"),"Sub Total da Unidade")

TRFunction():New(oSection:Cell("ZMCODSEQ"),NIL,"COUNT",oBreak)
TRFunction():New(oSection:Cell("ZMVLRCONT"),Nil,"SUM",oBreak)
TRFunction():New(oSection:Cell("ZMVRTOTFI"),Nil,"SUM",oBreak)
TRFunction():New(oSection:Cell("VLRTOTCTR"),Nil,"SUM",oBreak)
TRFunction():New(oSection:Cell("ZNVLRJUR"),Nil,"SUM",oBreak)
TRFunction():New(oSection:Cell("ZNVJURVAR"),Nil,"SUM",oBreak)
TRFunction():New(oSection:Cell("ZNPARAPAG"),Nil,"SUM",oBreak) 
TRFunction():New(oSection:Cell("JUROCURTO"),Nil,"SUM",oBreak) 
TRFunction():New(oSection:Cell("JUROLONGO"),Nil,"SUM",oBreak) 
TRFunction():New(oSection:Cell("PRINCURTO"),Nil,"SUM",oBreak) 
TRFunction():New(oSection:Cell("PRINLONGO"),Nil,"SUM",oBreak) 


Return oReport

Static Function PrintReport(oReport,aRecnoSM0)
Local oSection := oReport:Section(1)
//Local cPart
//Local cFiltro   := ""

//Transforma parametros do tipo Range em expressao SQL para ser utilizada na query 	
MakeSqlExpr(cPerg)	
//oSection:BeginQuery()	
cDataDe 	:= DTOS(MV_PAR01)
cDataAt 	:= DTOS(MV_PAR02)
cFilialDe	:= Alltrim(MV_PAR03)
cFilialAt	:= Alltrim(MV_PAR04)
cModFinDe	:= Alltrim(MV_PAR05) 
cModFinat	:= Alltrim(MV_PAR06)
cCodContrDe := Alltrim(MV_PAR07)
cCodContrAt := Alltrim(MV_PAR08) 
cDtRefCurtL := DTOS(MV_PAR09) 
nCompoeSaldo := MV_PAR10 

cMyQuery := MySqlQuery(cDataDe,cDataAt,cFilialDe,cFilialAt,cModFinDe,cModFinat,cCodContrDe,cCodContrAt,cDtRefCurtL,nCompoeSaldo)
IF Select("QRYEMP") > 0 
     QRYEMP->(DbCloseArea())
EndIf                       
TCQUERY cMyQuery NEW ALIAS "QRYEMP"
oSection:Init()
While QRYEMP->(!EOF())
	oSection:Cell("ZY_FILIAL"):SetValue(Alltrim(QRYEMP->ZY_FILIAL))
	
	//oSection:Cell("UNIDADE"):SetValue({|| Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][4] ),1,15) , "") })
	oSection:Cell("UNIDADE"):SetValue({|| Iif(aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } ) > 0, Substr(Alltrim(aRecnoSM0[aScan(aRecnoSM0,{|x| x[3] == PADR(ALLTRIM(QRYEMP->ZY_FILIAL),Len(x[3])) } )][5] ),1,15), "") })
	oSection:Cell("ZMCODBCO"):SetValue(Substr(Alltrim(QRYEMP->ZY_CODBCO),1,7))
	oSection:Cell("A6NOME"):SetValue(IIF(Empty(Alltrim(QRYEMP->A6_NOME)),"BOLETO",Substr(Alltrim(QRYEMP->A6_NOME),1,20)))
	oSection:Cell("ZLDESCRI"):SetValue(Substr(Alltrim(QRYEMP->ZW_DESCRI),1,20))
	oSection:Cell("ZMCODSEQ"):SetValue(Substr(Alltrim(QRYEMP->ZY_CODSEQ),1,10))
	oSection:Cell("ZMCODCONT"):SetValue(Substr(Alltrim(QRYEMP->ZY_CODCONT),1,15))
	oSection:Cell("ZMDTCONTR"):SetValue(STOD(QRYEMP->ZY_DTCONTR))
	oSection:Cell("ZMDTQTCTR"):SetValue(STOD(QRYEMP->ZY_DTQTCTR))
	oSection:Cell("ZMVLRCONT"):SetValue(QRYEMP->ZY_VLRCONT)
	oSection:Cell("ZMVRTOTFI"):SetValue(QRYEMP->ZY_VRTOTFI)
	oSection:Cell("VLRTOTCTR"):SetValue(QRYEMP->VLRTOTCTR)
	oSection:Cell("ZNVLRJUR"):SetValue(QRYEMP->ZZ_VLRJUR)
	oSection:Cell("ZNVJURVAR"):SetValue(QRYEMP->ZZ_VJURVAR)
	oSection:Cell("ZNPARAPAG"):SetValue(QRYEMP->ZZ_PARAPAG)
	oSection:Cell("JUROCURTO"):SetValue(CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[1])
	oSection:Cell("JUROLONGO"):SetValue(CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[2])
	oSection:Cell("PRINCURTO"):SetValue(CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[3])
	oSection:Cell("PRINLONGO"):SetValue(CalcCurLong(Alltrim(QRYEMP->ZY_CODSEQ),Alltrim(QRYEMP->ZY_FILIAL),DTOS(MV_PAR09),MV_PAR10)[4])
	oSection:Cell("ZY_FILIAL"):Disable()
	oSection:Cell("ZMCODBCO"):Disable()

	oSection:PrintLine()
 	QRYEMP->(DbSkip())
EndDo

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
	AADD(aRegs,{cPerg,"01","Periodo Dede: ","","","mv_ch1" ,"D",08,0,0,"G",""           ,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Periodo Até:  ","","","mv_ch2" ,"D",08,0,0,"G","" 				,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"03","Filial De:    ","","","mv_ch3" ,"C",04,0,0,"G",""           ,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"04","Filal Até:    ","","","mv_ch4" ,"C",04,0,0,"G","NaoVazio()" ,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
	AADD(aRegs,{cPerg,"05","Modalidade De:","","","mv_ch5" ,"C",03,0,0,"G",""           ,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SZW","","","","",""})
	AADD(aRegs,{cPerg,"06","Modalidade Até:","","","mv_ch6" ,"C",03,0,0,"G","NaoVazio()","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SZW","","","","",""})
	AADD(aRegs,{cPerg,"07","Contrato De:"  ,"","","mv_ch7" ,"C",09,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SZY","","","","",""})
	AADD(aRegs,{cPerg,"08","Contrato Até:" ,"","","mv_ch8" ,"C",09,0,0,"G","NaoVazio()","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SZY","","","","",""})
	AADD(aRegs,{cPerg,"09","Ref.Curto/Longo:","","","mv_ch9" ,"D",08,0,0,"G","" 				,"MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"10","Comp.Sld.Retro?","","","mv_chA" ,"C",01,0,0,"C",""           ,"MV_PAR10","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","",""})
	
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


Static Function CalcCurLong(cCodContr,cFilCont,cDtRefCurtL,cCompoeSaldo)
Local aRet := {}

                                             
cQuery := " SELECT ZY_CODSEQ,ISNULL(SZZJ.ZZ_VLRJURC,0) ZZ_VLRJURC, ISNULL(ZZ_VLRPRIC,0) ZZ_VLRPRIC,ISNULL(ZZ_VLRJURL,0) ZZ_VLRJURL,"
cQuery += ENTER + " ISNULL(ZZ_VLRPRIL,0) ZZ_VLRPRIL, ISNULL(SZZJ.ZZ_VLRJURC + ZZ_VLRPRIC + ZZ_VLRJURL +ZZ_VLRPRIL,0)  TOTAL "
cQuery += ENTER + " FROM " + RetSqlName("SZY") + " SZY "
cQuery += ENTER + " JOIN ( "
cQuery += ENTER + " SELECT SZZ.ZZ_CODSEQ,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) ZZ_VLRJURC,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) ZZ_VLRPRIC "
cQuery += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
cQuery += ENTER + " WHERE D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + cFilCont + "' "
If cCompoeSaldo == 2
	cQuery += ENTER + " AND SZZ.ZZ_VRPGPAR  = 0 "
	cQuery += ENTER + " AND SZZ.ZZ_DTPGPAR = '' "
Else
	cQuery += ENTER + " AND SZZ.ZZ_DTVENC >= '" + cDtRefCurtL + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '') "  
EndIf
cQuery += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "' "
cQuery += ENTER + " AND SZZ.ZZ_NROPAR IN (SELECT TOP 12 ZZ_NROPAR FROM " + RetSqlName("SZZ") + " SZZ "  
cQuery += ENTER + " WHERE D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + cFilCont + "' "
If cCompoeSaldo == 2
	cQuery += ENTER + " AND SZZ.ZZ_VRPGPAR  = 0 "
	cQuery += ENTER + " AND SZZ.ZZ_DTPGPAR = '' "
Else
	cQuery += ENTER + " AND SZZ.ZZ_DTVENC >= '" + cDtRefCurtL + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '') "
EndIf
cQuery += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "'  ORDER BY SZZ.ZZ_NROPAR ) "
cQuery += ENTER + " GROUP BY ZZ_CODSEQ "
cQuery += ENTER + " ) SZZJ ON SZZJ.ZZ_CODSEQ = SZY.ZY_CODSEQ "
cQuery += ENTER + " LEFT JOIN ( "
cQuery += ENTER + " SELECT SZZ.ZZ_CODSEQ,ROUND(SUM(SZZ.ZZ_VLRJUR + SZZ.ZZ_VJURVAR),2) ZZ_VLRJURL,ROUND(SUM(SZZ.ZZ_VLRPRIN),2) ZZ_VLRPRIL "
cQuery += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ " 
cQuery += ENTER + " WHERE D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + cFilCont + "' "
If cCompoeSaldo == 2
	cQuery += ENTER + " AND SZZ.ZZ_VRPGPAR  = 0 "
	cQuery += ENTER + " AND SZZ.ZZ_DTPGPAR = '' "
Else
	cQuery += ENTER + " AND SZZ.ZZ_DTVENC >= '" + cDtRefCurtL + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '') "
EndIf
cQuery += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "' "
cQuery += ENTER + " AND SZZ.ZZ_NROPAR NOT IN (SELECT TOP 12 ZZ_NROPAR FROM " + RetSqlName("SZZ") + " SZZ "  
cQuery += ENTER + " WHERE D_E_L_E_T_ ='' AND SZZ.ZZ_FILIAL = '" + cFilCont + "'  " 
If cCompoeSaldo == 2
	cQuery += ENTER + " AND SZZ.ZZ_VRPGPAR  = 0 "
	cQuery += ENTER + " AND SZZ.ZZ_DTPGPAR = '' "
Else
	cQuery += ENTER + " AND SZZ.ZZ_DTVENC >= '" + cDtRefCurtL + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '') "
EndIf
cQuery += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "'  ORDER BY SZZ.ZZ_NROPAR ) "

cQuery += ENTER + " GROUP BY ZZ_CODSEQ "
cQuery += ENTER + " ) SZZL ON SZZL.ZZ_CODSEQ = SZY.ZY_CODSEQ "
cQuery += ENTER + " WHERE SZY.D_E_L_E_T_ ='' AND SZY.ZY_FILIAL = '" + cFilCont + "' "
cQuery += ENTER + " AND SZY.ZY_CODSEQ = '" + cCodContr + "' "
If Select("TRBCL") > 0
	TRBCL->(DbCloseArea())
EndIf                    
TCQUERY cQuery NEW ALIAS "TRBCL"

If TRBCL->(!EOF())
	AaDd(aRet,TRBCL->ZZ_VLRJURC)
	AaDd(aRet,TRBCL->ZZ_VLRJURL)
	AaDd(aRet,TRBCL->ZZ_VLRPRIC)
	AaDd(aRet,TRBCL->ZZ_VLRPRIL)
Else
	aRet := {0,0,0,0}
EndIF
If Select("TRBCL") > 0
	TRBCL->(DbCloseArea())
EndIf                    
Return aRet

Static Function MySqlQuery(cDataDe,cDataAt,cFilialDe,cFilialAt,cModFinDe,cModFinat,cCodContrDe,cCodContrAt,cDtRefCurtL,nCompoeSaldo)
Local cQryRet := ""

cQryRet := "	SELECT  "
cQryRet += "		SZY.ZY_FILIAL,SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI,SZY.ZY_CODSEQ,SZY.ZY_CODCONT,SZY.ZY_DTCONTR,SZY.ZY_DTQTCTR,SZY.ZY_VLRCONT, "
cQryRet += "		SZY.ZY_VRTOTFI,SZZP.ZZ_VLRPRIN,SZZP.ZZ_VLRJUR,SZZP.ZZ_VJURVAR,SZZP.ZZ_PARAPAG,(SZZP.ZZ_VLRPRIN + SZZP.ZZ_VLRJUR + SZZP.ZZ_VJURVAR) VLRTOTCTR "
cQryRet += "	FROM " + RetSqlName("SZY") + " SZY "
cQryRet += "	JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ = '' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
cQryRet += "	LEFT JOIN " + RetSqlName("SA6") + " SA6 ON SA6.D_E_L_E_T_ = '' AND SA6.A6_FILIAL = '" + xFilial("SA6") + "' AND SA6.A6_COD = SZY.ZY_CODBCO AND SA6.A6_AGENCIA = SZY.ZY_BCOAGEN AND SA6.A6_NUMCON = SZY.ZY_BCOCONT "
cQryRet += "	JOIN (SELECT  SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO, ROUND(SUM(SZZ.ZZ_VLRPRIN),2) ZZ_VLRPRIN ,ROUND(SUM(SZZ.ZZ_VLRJUR),2) ZZ_VLRJUR, "
cQryRet += "			ROUND(SUM(SZZ.ZZ_VJURVAR),2) ZZ_VJURVAR,ROUND(SUM(SZZ.ZZ_PARAPAG),2) ZZ_PARAPAG "
cQryRet += "			FROM " + RetSqlName("SZZ") + " SZZ "
cQryRet += "			WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN  '" + cFilialDe + "'  AND '" + cFilialAt + "' "
If nCompoeSaldo == 2 
	cQryRet += "		AND SZZ.ZZ_DTPGPAR = '' "  
Else
	cQryRet += "		AND SZZ.ZZ_DTVENC >= '" + Substr(cDtRefCurtoL,1,6) + "01" + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '')  " 
EndIf
cQryRet += "		GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO) SZZP ON SZZP.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZP.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZP.ZZ_REVISAO = SZY.ZY_REVISAO "
cQryRet += "	LEFT JOIN (SELECT  SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO, ROUND(SUM(SZZ.ZZ_VLRPRIN),2) ZZ_VLRPRIN ,ROUND(SUM(SZZ.ZZ_VLRJUR),2) ZZ_VLRJUR, "
cQryRet += "			ROUND(SUM(SZZ.ZZ_VJURVAR),2) ZZ_VJURVAR,ROUND(SUM(SZZ.ZZ_PARAPAG),2) ZZ_PARAPAG "
cQryRet += "			FROM " + RetSqlName("SZZ") + " SZZ "
cQryRet += "			WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAt + "'  "
If nCompoeSaldo == 2 
	cQryRet += "			AND SZZ.ZZ_DTPGPAR <> '' "    
Else                                     
	cQryRet += "		AND SZZ.ZZ_DTVENC >= '" + Substr(cDtRefCurtoL,1,6) + "01" + "' AND  (SZZ.ZZ_DTPGPAR >= '" + cDtRefCurtL + "' OR  SZZ.ZZ_DTPGPAR = '')  " 
EndIf
cQryRet += "			GROUP BY SZZ.ZZ_FILIAL,SZZ.ZZ_CODSEQ,SZZ.ZZ_REVISAO) SZZA ON SZZA.ZZ_FILIAL = SZY.ZY_FILIAL AND SZZA.ZZ_CODSEQ = SZY.ZY_CODSEQ AND SZZA.ZZ_REVISAO = SZY.ZY_REVISAO "
cQryRet += "	WHERE SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL BETWEEN '" + cFilialDe + "' AND '" + cFilialAt + "' "
cQryRet += "			AND SZY.ZY_DTCONTR BETWEEN '" + cDataDe + "' AND '" + cDataAt + "' "
cQryRet += "			AND SZY.ZY_MODFIIN BETWEEN '" + cModFinDe + "' AND '" + cModFinAt + "' "
cQryRet += "			AND SZY.ZY_CODSEQ BETWEEN '" + cCodContrDe + "' AND '" + cCodContrAt + "' "
cQryRet += " 			AND SZY.ZY_STATFIN NOT IN ('','0') "
cQryRet += "	ORDER BY SZY.ZY_FILIAL,SZY.ZY_CODBCO,SA6.A6_NOME,SZW.ZW_DESCRI	 "

Return cQryRet 
