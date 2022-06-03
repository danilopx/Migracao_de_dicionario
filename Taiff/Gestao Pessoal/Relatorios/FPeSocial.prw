#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณ FPESOCIAL  บ Autor ณ Aline Correa do Vale บ Data ณ 18/09/18 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function FPESOCIAL()

oReport := ReportDef()
oReport:PrintDialog()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma | FPESOCIAL  บ Autor ณ Aline Correa do Vale บ Data ณ 18/09/18 บฑฑ
ฑฑบObjetivo | Defini็ใo das colunas do relat๓rio                          บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
*/
Static Function ReportDef()

Local oReport 
Local oSection1

CriaSX1("FPESOCIAL")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao do componente de impressao                                      ณ
//ณ                                                                        ณ
//ณTReport():New                                                           ณ
//ณExpC1 : Nome do relatorio                                               ณ
//ณExpC2 : Titulo                                                          ณ
//ณExpC3 : Pergunte                                                        ณ
//ณExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ณ
//ณExpC5 : Descricao                                                       ณ
//ณ PARAMETROS                                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport:= TReport():New("FPESOCIAL","CONFERENCIA ESOCIAL","FPESOCIAL", {|oReport| ReportPrint(oReport)},"RELATORIO DE CONFERENCIA ESOCIAL"+" "+"Emite uma rela็ใo comparativa do eSocial com a Folha de Pagamento no Periodo")
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)
Pergunte("FPESCOAL",.F.)

oSection1 := TRSection():New(oReport,"CONFERENCIA ESOCIAL",{"FPTMP"})
oSection1:SetTotalInLine(.F.)
oSection1:SetHeaderPage()
oSection1:SetNoFilter("ZZ6")

TRCell():New(oSection1,"COMP_1200"	,"FPTMP", "COMPETENCIA"			,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RA_FILIAL"	,"FPTMP", "FILIAL"				,/*Picture*/ ,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"RA_MAT"		,"FPTMP", "MATRICULA"			,/*Picture*/ ,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C9V_ID"		,"FPTMP", "ID TRABALHADOR"		,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"C9V_CPF"    ,"FPTMP", "CPF"					,"@e 9999.99",10,/*lPixel*/,/*{|| code-block de impressao }}*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"C9V_NOME"   ,"FPTMP", "FUNCIONARIO"			,,10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"C8R_CODRUB" ,"FPTMP", "RUBRICA"				,,10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"C8R_DESRUB" ,"FPTMP", "DESC. RUBRICA"		,,30,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"VLRRUB_1200","FPTMP", "VLR 1200"			,"@e 999,9999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"VLRRUB_1210","FPTMP", "VLR 1210"			,"@e 999,9999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"VLRRUB_2299","FPTMP", "VLR 2299"			,"@e 999,9999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"VLRSRD"     ,"FPTMP", "VLR FOLHA"			,"@e 999,9999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"VLRRUB_ESOC","FPTMP", "VLR ESOCIAL"			,"@e 999,9999.99",10,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"
TRCell():New(oSection1,"RV_TIPOCOD" ,"FPTMP", "TIPO VERBA"			,,,/*lPixel*/,/*{|| code-block de impressao }*/) //"Total Fornecedor M๊s 2"

//TRCell():New(oSection1,"nValTerc"   ,"   ","CONTRIB. TERCEIROS ORIGINAL"	,"@e 999,999,999.99",TamSX3("ZZ6_VAL")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/,/**/, /**/, /**/, /**/, /**/,.F.)

//TRCell():New(oSection1,"nTotalInss" ,"   ","TOTAL PREVIDสNCIA"				,"@e 999,999,999.99",TamSX3("ZZ6_VAL")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/) //"Saldo SC"

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma ณ ReportPrint ณ Autor: Aline Correa do Vale ณ Data ณ18.09.2018ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณA funcao estatica ReportDef devera ser criada para todos os ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                           ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1) 
Local cAliasFP    := "FPTMP"
if select(cAliasFP) > 0
	dbSelectArea(cAliasFP)
	dbCloseArea()
endif

oReport:SetMeter(C9M->(LastRec()))

oSection1:Init()    
//INCLUIR LE3 PENSAO JUDICIAL
//INCLUIR T5Y RECIBO ANTERIOR DE FERIAS
// T6Q ?? Reten็๕es Pagamento do Vlr Tot
// T6R ?? Inf Comp Relac ao Pgto Efetuad
// incluir S2299 - CMD - T05 - TAFA266 => S-2299 => CMD , T06 , T3G , T05 , T15 , T16 , T5I , T5J , T5Q , T5S , T88 , C9J , T3H
//	AND C91_ATIVO = '1' AND C91_STATUS = '4' AND C91.D_E_L_E_T_ =''

BeginSql alias cAliasFP

	SELECT  C91_PERAPU COMP_1200,C9V_ID, C91_FILIAL FILIAL, C91_TRABAL, RA_FILIAL, C91_STATUS ESSTATUS, 
	RA_MAT,C9V_CPF,C9V_NOME,C8R_CODRUB, C8R_DESRUB, C9M_VLRRUB VLRRUB_1200,0 VLRRUB_1210, 0 VLRRUB_ESOC, 0 VLRRUB_2299, RD_VALOR VLRSRD, RV_TIPOCOD
	FROM %table:C91% C91
	LEFT JOIN %table:C9M% C9M ON C9M_ID = C91_ID AND C91_TRABAL = C9M_TRABAL AND C91_VERSAO = C9M_VERSAO AND C91_FILIAL = C9M_FILIAL AND C9M.D_E_L_E_T_ ='' 
	LEFT JOIN %table:C8R% C8R ON C9M_CODRUB = C8R_ID AND C8R.D_E_L_E_T_=''
	LEFT JOIN %table:C9V% C9V ON C9V_ID = C9M_TRABAL AND C9V_FILIAL = C91_FILIAL AND C9V.D_E_L_E_T_ ='' AND C9V_ATIVO = '1' AND C9V_STATUS = '4'
	LEFT JOIN %table:SRV% RV ON  RV_COD = C8R_CODRUB AND RV.D_E_L_E_T_ =''
	LEFT JOIN %table:SRA% RA ON RA_FILIAL = C9V_FILIAL AND (RA_CODUNIC = C9V_MATRIC OR RA_CIC = C9V_CPF) AND RA.D_E_L_E_T_ ='' 
	LEFT JOIN %table:SRD% RD ON RD_MAT =RA_MAT AND RD_PERIODO = C91_PERAPU AND RD.D_E_L_E_T_ ='' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL
	WHERE C9M.D_E_L_E_T_ ='' AND C91.D_E_L_E_T_ =''
	AND C91_ATIVO = '1' AND C91.D_E_L_E_T_ =''
	AND (C91_PERAPU >= %exp:mv_par03% AND C91_PERAPU <= %exp:mv_par04%) 
	AND (C91_FILIAL >= %exp:mv_par01% AND C91_FILIAL <= %exp:mv_par02%) 
UNION ALL
	SELECT  T3P_PERAPU COMP_1200,C9V_ID, T3P_FILIAL FILIAL, T3P_BENEFI, RA_FILIAL, T3P_STATUS ESSTATUS, 
	RA_MAT,C9V_CPF,C9V_NOME,C8R_CODRUB, C8R_DESRUB, 0 VLRRUB_1200, LE2_VLRRUB VLRRUB_1210, 0 VLRRUB_ESOC, 0 VLRRUB_2299, RD_VALOR VLRSRD, RV_TIPOCOD
	FROM %table:T3P% T3P
	LEFT JOIN %table:LE2% LE2 ON LE2_ID = T3P_ID AND T3P_FILIAL = LE2_FILIAL AND T3P_VERSAO = LE2_VERSAO AND LE2.D_E_L_E_T_ ='' 
	LEFT JOIN %table:C8R% C8R ON LE2_IDRUBR = C8R_ID AND C8R.D_E_L_E_T_=''
	LEFT JOIN %table:C9V% C9V ON C9V_ID = T3P_BENEFI AND C9V_FILIAL = T3P_FILIAL AND C9V.D_E_L_E_T_ ='' AND C9V_ATIVO = '1' AND C9V_STATUS = '4'
	LEFT JOIN %table:SRV% RV ON  RV_COD = C8R_CODRUB AND RV.D_E_L_E_T_ =''
	LEFT JOIN %table:SRA% RA ON RA_FILIAL = C9V_FILIAL AND (RA_CODUNIC = C9V_MATRIC OR RA_CIC = C9V_CPF) AND RA.D_E_L_E_T_ ='' 
	LEFT JOIN %table:SRD% RD ON RD_MAT =RA_MAT AND RD_PERIODO = T3P_PERAPU AND RD.D_E_L_E_T_ ='' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL
	WHERE LE2.D_E_L_E_T_ ='' AND T3P.D_E_L_E_T_ =''
	AND T3P_ATIVO = '1' AND T3P.D_E_L_E_T_ =''
	AND (T3P_PERAPU >= %exp:mv_par03% AND T3P_PERAPU <= %exp:mv_par04%) 
	AND (T3P_FILIAL >= %exp:mv_par01% AND T3P_FILIAL <= %exp:mv_par02%) 
UNION ALL 
	SELECT  SUBSTRING(CMD_DTDESL,1,6) COMP_1200,C9V_ID, CMD_FILIAL FILIAL, CMD_FUNC, RA_FILIAL, CMD_STATUS ESSTATUS, 
	RA_MAT,C9V_CPF,C9V_NOME,C8R_CODRUB, C8R_DESRUB, 0 VLRRUB_1200, 0 VLRRUB_1210, 0 VLRRUB_ESOC, T05_VLRRUB VLRRUB_2299, RD_VALOR VLRSRD, RV_TIPOCOD
	FROM %table:CMD% CMD
	LEFT JOIN %table:T05% T05 ON T05_ID = CMD_ID AND T05_VERSAO = CMD_VERSAO AND T05_FILIAL = CMD_FILIAL AND T05.D_E_L_E_T_ ='' 
	LEFT JOIN %table:C8R% C8R ON T05_CODRUB = C8R_ID AND C8R.D_E_L_E_T_=''
	LEFT JOIN %table:C9V% C9V ON C9V_ID = CMD_FUNC AND C9V_FILIAL = CMD_FILIAL AND C9V.D_E_L_E_T_ ='' AND C9V_ATIVO = '1' AND C9V_STATUS = '4'
	LEFT JOIN %table:SRV% RV ON  RV_COD = C8R_CODRUB AND RV.D_E_L_E_T_ =''
	LEFT JOIN %table:SRA% RA ON RA_FILIAL = C9V_FILIAL AND (RA_CODUNIC = C9V_MATRIC OR RA_CIC = C9V_CPF) AND RA.D_E_L_E_T_ ='' 
	LEFT JOIN %table:SRD% RD ON RD_MAT = RA_MAT AND RD_PERIODO = SUBSTRING(CMD_DTDESL,1,6) AND RD.D_E_L_E_T_ ='' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL
	WHERE T05.D_E_L_E_T_ ='' AND CMD.D_E_L_E_T_ =''
	AND CMD_ATIVO = '1' AND CMD.D_E_L_E_T_ =''
	AND (SUBSTRING(CMD_DTDESL,1,6) >= %exp:mv_par03% AND SUBSTRING(CMD_DTDESL,1,6) <= %exp:mv_par04%) 
	AND (T05_FILIAL >= %exp:mv_par01% AND T05_FILIAL <= %exp:mv_par02%)

ORDER BY C9V_NOME, C8R_CODRUB

EndSql

While !oReport:Cancel() .And. (cAliasFP)->(!Eof())
	If oReport:Cancel()
		Exit
	EndIf
	if (ESSTATUS = '4' )
		if VLRRUB_2299>0
			oSection1:Cell("VLRRUB_ESOC"):SetValue(VLRRUB_2299)
		else
			oSection1:Cell("VLRRUB_ESOC"):SetValue(if(VLRRUB_1200>0,VLRRUB_1200,VLRRUB_1210))
		endif
	Endif
	oReport:IncMeter()
	oSection1:PrintLine()
	(cAliasFP)->(DbSkip())
	
//		oSection1:Cell("FORNECEDOR"):SetValue((cAliasFP)->ZZ6_FORNEC)
//		oSection1:Cell("FANTASIA"):SetValue((cAliasFP)->ZZ5_FANTAS)
Enddo

if select(cAliasFP) > 0
	dbSelectArea(cAliasFP)
	dbCloseArea()
endif

oSection1:Finish()

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บ Autor ณAline Correa do Valeบ Data ณ  25/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณObjetivo desta funcao e verificar se existe o grupo de      บฑฑ
ฑฑบ          ณperguntas, se nao existir a funcao ira cria-lo.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณcPerg -> Nome com  grupo de perguntas em questใo.           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSx1(cPerg)

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
Aadd(aRegs,{cPerg,"01","Filial de ?"         ,"","","mv_ch1","C",02,0,0,"G",""                          ,"MV_PAR01",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?"         ,"","","mv_ch2","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR02",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"03","Ano/Mes De?"         ,"","","mv_ch3","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"04","Ano/Mes Ate?"        ,"","","mv_ch4","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR04",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})

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

dbSelectArea(_sAlias)

Return Nil
