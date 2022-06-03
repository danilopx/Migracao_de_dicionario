#INCLUDE "PROTHEUS.CH"
/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³xxxxxxxx()³ Autor ³Aline Correa do Vale  ³ Data ³02/06/2021 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cadastro de Fornecedores de Promotores e Demonstradores    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ikesaki                                         ³±±
ßßßßßßßßßßßßßßßßßßßßßßßrißßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPERBEN()

/*EXEMPLO GPER390
//R0_TPVALE 0=VT, 1=VR, 2=VA
SELECT  RG2_DUTILM QTD, 'TAIFF' Empresa, RG2_FILIAL Filial, RG2_CC CentroCusto, CTT_DESC01 Desc_CC,  RG2_MAT Matricula, RA_NOME Nome, RA_ADMISSA Admissao, RJ_DESC Cargo,  R6_DESC Turno, RA_SITFOLH Situacao, RG2_DUTILM Dias, RG2_VALCAL ValorTotal,  RG2_CUSUNI CustoUni, RG2_CUSFUN VLRFUNC, RG2_CUSEMP VLREMP
FROM RG2030 RG2, CTT030 CTT, SRA030 SRA, SRJ030 SRJ, SR6030 SR6
WHERE RG2_PERIOD = '202101'
AND RG2.D_E_L_E_T_ = ''
AND CTT.D_E_L_E_T_ = ''
AND SRA.D_E_L_E_T_ = ''
AND SR6.D_E_L_E_T_ = ''
AND SRJ.D_E_L_E_T_ = ''
AND RA_FILIAL = RG2_FILIAL
AND RA_MAT = RG2_MAT
AND RG2_CC = RA_CC
AND RJ_FUNCAO = RA_CODFUNC
AND RA_TNOTRAB = R6_TURNO
UNION
SELECT R0_QDIACAL QTD, 'TAIFF' Empresa, R0_FILIAL Filial, R0_CC CentroCusto, CTT_DESC01 Desc_CC,  R0_MAT Matricula, RA_NOME Nome, RA_ADMISSA Admissao, RJ_DESC Cargo,  R6_DESC Turno, RA_SITFOLH Situacao, R0_QDIAINF Dias, R0_VALCAL ValorTotal,  R0_VLRVALE CustoUni, R0_VLRFUNC VLRFUNC, R0_VLREMP VLREMP
FROM SR0030 SR0, CTT030 CTT, SRA030 SRA, SRJ030 SRJ, SR6030 SR6
WHERE R0_PERIOD = '202101'
AND SR0.D_E_L_E_T_ = ''
AND CTT.D_E_L_E_T_ = ''
AND SRA.D_E_L_E_T_ = ''
AND SR6.D_E_L_E_T_ = ''
AND SRJ.D_E_L_E_T_ = ''
AND RA_FILIAL = R0_FILIAL
AND RA_MAT = R0_MAT
AND R0_CC = RA_CC
AND RJ_FUNCAO = RA_CODFUNC
AND RA_TNOTRAB = R6_TURNO
*/
Local oReport
Local aArea 		:= GetArea()
Local oDlg
Local oRadio
Local nRadio
Private cPerg		:= "GPERBEN"
Private aOrd		:={}
Private cAliasQry	:= ""
Private cTitulo		:= "Mapa de Beneficios"
Private nOrdem		:= 1
Private nRelat	:= 2
Private cTipoVale := 'VA'

DEFINE MSDIALOG oDlg FROM  94,1 TO 273,293 TITLE "Tipo do Beneficio" PIXEL
@ 10,17 Say "Escolha o Tipo do Beneficio:" SIZE 150,7 OF oDlg PIXEL 
@ 27,07 TO 72, 140 OF oDlg  PIXEL
@ 35,10 Radio 	oRadio VAR nRadio;
		ITEMS 	" Vale Transporte ",;
				" Vale Refeicao ",;
				" Vale Alimentacao" ;
		3D SIZE 100,10 OF oDlg PIXEL

DEFINE SBUTTON FROM 75,085 TYPE 1 ENABLE OF oDlg ACTION (nOpca := 1, oDlg:End())
DEFINE SBUTTON FROM 75,115 TYPE 2 ENABLE OF oDlg ACTION (nOpca := 0, oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED ON INIT (nOpca := 0, .T.)	// Zero nOpca caso 
															// para saida com ESC

If nOpca == 1   

	If nRadio == 1
		cTipoVale	:= "VTR" //
		cTpVale := '0'
		cTitulo += " - Vale Transporte"
	ElseIf nRadio == 2  
		cTipoVale	:= "VRF" // Vale Refeicao 
		cTpVale := '1'
		cTitulo += " - Vale Refeição"
	ElseIf nRadio == 3
		cTipoVale	:= "VAL" // Vale Alimentacao
		cTpVale := '2'
		cTitulo += " - Vale Alimentação"
	EndIf   
Else
	return (.f.)

endif

Pergunte(cPerg,.F.)

oReport := ReportDef()
oReport:PrintDialog()

RestArea( aArea )

Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Programa  ³ReportDef ³ Autor: Aline Correa do Vale ³ Data ³ 27.05.2021 ³±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oSection1
//Local oBreak
Local aOrdem := {}
AjustaSX1("GPERBEN")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³ PARAMETROS                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:= TReport():New("GPERBEN",cTitulo,"GPERBEN", {|oReport| ReportPrint(oReport)},cTitulo+" "+"Emite o mapa de beneficios de funcionários")
oReport:SetLandscape()    
//Pergunte("GPERBEN",.F.)
//Aadd( aOrdem, " Por Fornecedor" )

oSection1 := TRSection():New(oReport,cTitulo,{"SR0","RG2","SRA"},aOrdem) 
oSection1:SetHeaderPage()
oSection1:SetNoFilter("SR0")
oSection1:SetHeaderBreak(.T.)
oSection1:SetHeaderSection(.T.)
oSection1:SetLineBreak(.F.)
oSection1:SetTotalInLine(.T.)

//VR Qtd.	Empresa	Filial	Cód.Centro de Custo	Descr.Centro de Custo	Matricula	Nome	Admissão	Cargo	Turno de Trabalho	Situação	Custo Unitário	Qtd.Dias	Dias Deduzidos	Custo Total	Custo Empresa	Custo Empregado		
//VA Qtd.	Empresa	Filial	Cód.Centro de Custo	Descr.Centro de Custo	Matricula	Nome	Admissão	Cargo	Turno de Trabalho	Situação	Custo Unitário	Qtd.Vales	Custo Total	Custo Empresa	Custo Empregado			
//VT Qtd.	Empresa	Filial	Cód.Centro de Custo	Descr.Centro de Custo	Matricula	Nome	Admissão	Cargo	Turno de Trabalho	Situação	Cód.Vale Transp.	Custo Diário	Qtd.Vales	Qtd.Dias	Dias Deduzidos	Custo Total	Custo Empresa	Custo Empregado	Cód.Vale Transp.	Custo Diário	Qtd.Vales	Qtd.Dias	Dias Deduzidos	Custo Total	Custo Empresa	Custo Empregado
TRCell():New(oSection1,"QTDE"	,"QRYTMP", "Qtd."			    	,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"EMPRESA","QRYTMP", "Empresa"				,/*Picture*/,TamSX3("RA_FILIAL")[1]+1,/*lPixel*/,/*{|| alltrim(SMO->M0_NOME) }*/)
TRCell():New(oSection1,"FILIAL"	,"QRYTMP", "Filial"	 			,/*Picture*/,TamSX3("RA_MAT")[1]+1,/*lPixel*/,{|| RetField('SM0',1,cEmpAnt+QRYTMP->FILIAL,'M0_FILIAL') })
TRCell():New(oSection1,"CENTROCUSTO","QRYTMP", "Cód.Centro de Custo",/*Picture*/,TamSX3("RA_NOME")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"DESC_CC"  ,"QRYTMP", "Descr.Centro de Custo"	,/*Picture*/,TamSX3("CTT_DESC01")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"MATRICULA","QRYTMP", "Matricula"			,/*Picture*/,TamSX3("RA_MAT")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"NOME"     ,"QRYTMP", "Nome"				,/*Picture*/,TamSX3("RA_NOME")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"ADMISSAO" ,"QRYTMP", "Admissao"			,"@E",TamSX3("RA_ADMISSA")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"Cargo"    ,"QRYTMP", "Cargo"		,"@e",TamSX3("RF_DATAINI")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"TURNO"  ,"QRYTMP", "Turno de Trabalho"		,/*Picture*/,5,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"SIT_ATU","QRYTMP","Situação"	,"@e"       ,TamSX3("RF_DATAINI")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
if (cTipoVale = 'VAL') //Vale alimentação  R0_TPVALE = '2'
	TRCell():New(oSection1,"CUSTOUNI" ,"QRYTMP", "Custo Unitário"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"QTDE"	  ,"QRYTMP", "Qtde Vales"		,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VALORTOTAL","QRYTMP","Custo Total"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLREMP"   ,"QRYTMP","Custo Empresa"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLRFUNC"    ,"QRYTMP","Custo Empregado"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
elseif (cTipoVale = 'VRF') //Vale refeição  R0_TPVALE = '2'
	TRCell():New(oSection1,"CUSTOUNI" ,"QRYTMP", "Custo Unitário"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DIAS"	  ,"QRYTMP", "Qtd.Vales"	    ,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DIASPRO"  ,"QRYTMP", "Qtd.Dias"	        ,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DEDUZIDO"  ,"", "Dias Deduzidos"	,/*Picture*/,10,/*lPixel*/,{|| QRYTMP->(FALTAS+FERIAS+AFAST) })
	TRCell():New(oSection1,"VALORTOTAL","QRYTMP","Custo Total"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLREMP"   ,"QRYTMP","Custo Empresa"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLRFUNC"    ,"QRYTMP","Custo Empregado"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
elseif (cTipoVale = 'VTR') //Vale transporte R0_TPVALE = '0'
	TRCell():New(oSection1,"VALE"	  ,"QRYTMP", "Cod.Vale"	        ,/*Picture*/,20,/*lPixel*/,{|| RetField('SRN',1,xFilial("SRN")+QRYTMP->VALE,'RN_DESC') })
	TRCell():New(oSection1,"CUSTOUNI" ,"QRYTMP", "Custo Diário"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"QTDE"  ,"QRYTMP", "Qtd.Vales"	    ,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DIASPRO"  ,"QRYTMP", "Qtd.Dias"	        ,/*Picture*/,10,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DEDUZIDO"  ,"", "Dias Deduzidos"	,/*Picture*/,10,/*lPixel*/,{|| QRYTMP->(FALTAS+FERIAS+AFAST)})
	TRCell():New(oSection1,"VALORTOTAL","QRYTMP","Custo Total"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLREMP"   ,"QRYTMP","Custo Empresa"	    ,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"VLRFUNC"    ,"QRYTMP","Custo Empregado"	,"@e 999,999.99",12,/*lPixel*/,/*{|| code-block de impressao }*/)
endif

oBreak := TRBreak():New(oSection1,oSection1:Cell("EMPRESA"),"Custo Total: ",.T.)
oSection1:SetPageBreak(.T.)
oSection1:SetTotalText("Custo Total:")  
//TRFunction():New(oSection1:Cell("VALORTOTAL"),NIL,"SUM",oBreak,"","@E 999,999,999.99",/*uFormula*/,.F.,.T.) 
//TRFunction():New(oSection1:Cell("VLRFUNC"),NIL,"SUM",oBreak,"","@E 999,999,999.99",/*uFormula*/,.F.,.T.) 
//TRFunction():New(oSection1:Cell("VLREMP"),NIL,"SUM",oBreak,"","@E 999,999,999.99",/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("MATRICULA"),NIL,"COUNT" ,oBreak,"Qtd.Colaboradores","@E 999,999,999.99",NIL,.F.,.T.,.F.)
If cTipoVale <> 'VAL'
	TRFunction():New(oSection1:Cell(if(cTipoVale = 'VRF',"DIAS","QTDE")),NIL,"SUM",oBreak,"Qtd.Vales","@E 999,999.99",NIL,.F.,.T.,.F.)
endif
TRFunction():New(oSection1:Cell("VALORTOTAL") ,NIL,"SUM" ,oBreak,"Custo Total","@E 999,999,999.99",NIL,.F.,.T.,.F.)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa ³ ReportPrint ³ Autor: Aline Correa do Vale ³ Data ³02.06.2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)
Local oSection1 := oReport:Section(1)
Local cAliasTmp   := "QRYTMP"
Local cNomeEmpresa := Alltrim(SM0->M0_NOME)
if select(cAliasTmp) > 0
	dbSelectArea(cAliasTmp)
	dbCloseArea()
endif

oSection1:Init()    
dbSelectArea("SR0")
BeginSql alias cAliasTmp
	SELECT RG2_DIACAL Qtde, %exp:cNomeEmpresa% Empresa, RG2_FILIAL Filial, RG2_CC CentroCusto, CTT_DESC01 Desc_CC, RG2_MAT Matricula, RA_NOME Nome, RA_ADMISSA Admissao, RJ_DESC Cargo,  R6_DESC Turno, RA_SITFOLH Situacao, RG2_DUTILM Dias, RG2_VALCAL ValorTotal,  RG2_CUSUNI CustoUni, RG2_CUSFUN VLRFUNC, RG2_CUSEMP VLREMP,X5_DESCRI SIT_ATU, RG2_FALTAS FALTAS, RG2_FERIAS FERIAS, RG2_AFAST AFAST, RG2_CODIGO VALE, RG2_DIAPRO DIASPRO
	FROM %table:RG2% RG2, %table:SRA% SRA, %table:CTT% CTT, %table:SRJ% SRJ, %table:SR6% SR6, %table:SX5% SX5
	WHERE RG2_PERIOD = %exp:mv_par05%
	AND RG2.D_E_L_E_T_ = ''
	AND CTT.D_E_L_E_T_ = ''
	AND SRA.D_E_L_E_T_ = ''
	AND SR6.D_E_L_E_T_ = ''
	AND SRJ.D_E_L_E_T_ = ''
	AND SX5.D_E_L_E_T_ = ''
	AND RA_FILIAL = RG2_FILIAL
	AND RA_MAT = RG2_MAT
	AND CTT_CUSTO = RA_CC
	AND CTT_FILIAL = %Exp:xFilial("CTT")%
	AND RJ_FUNCAO = RA_CODFUNC
	AND RA_TNOTRAB = R6_TURNO
	AND X5_FILIAL = %EXP:xFilial("SX5")%
	AND X5_TABELA = '31'
	AND X5_CHAVE = RA_SITFOLH
	AND RG2_ROTEIR = %exp:cTipoVale%
	UNION
	SELECT R0_QDIACAL Qtde, %exp:cNomeEmpresa% Empresa, R0_FILIAL Filial, R0_CC CentroCusto, CTT_DESC01 Desc_CC,  R0_MAT Matricula, RA_NOME Nome, RA_ADMISSA Admissao, RJ_DESC Cargo,  R6_DESC Turno, RA_SITFOLH Situacao, R0_QDIAINF Dias, R0_VALCAL ValorTotal,  R0_VLRVALE CustoUni, R0_VLRFUNC VLRFUNC, R0_VLREMP VLREMP, X5_DESCRI SIT_ATU, R0_DFALT FALTAS, R0_FERIAS FERIAS, R0_AFAST AFAST, R0_CODIGO VALE, R0_DIASPRO DIASPRO
	FROM %table:SR0% SR0, %table:SRA% SRA, %table:CTT% CTT, %table:SRJ% SRJ, %table:SR6% SR6, %table:SX5% SX5
	WHERE R0_PERIOD = %exp:mv_par05%
	AND SR0.D_E_L_E_T_ = ''
	AND CTT.D_E_L_E_T_ = ''
	AND SRA.D_E_L_E_T_ = ''
	AND SR6.D_E_L_E_T_ = ''
	AND SRJ.D_E_L_E_T_ = ''
	AND SX5.D_E_L_E_T_ = ''
	AND RA_FILIAL = R0_FILIAL
	AND RA_MAT = R0_MAT
	AND CTT_CUSTO = RA_CC
	AND CTT_FILIAL = %Exp:xFilial("CTT")%
	AND RJ_FUNCAO = RA_CODFUNC
	AND RA_TNOTRAB = R6_TURNO	
	AND X5_FILIAL = %EXP:xFilial("SX5")%
	AND X5_TABELA = '31'
	AND X5_CHAVE = RA_SITFOLH
	AND R0_TPVALE = %exp:cTpVale%
	ORDER BY 3, 6
EndSql
TcSetField(cAliasTmp, "ADMISSA", "D", 8, 0)
//TcSetField(cAliasTmp, "PROGRAMA", "D", 8, 0)
//TcSetField(cAliasTmp, "LIMITE", "D", 8, 0)
oReport:SetMeter((cAliasTmp)->(LastRec()))

while (cAliasTmp)->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
//if (cAliasTmp)->(!Eof())
//	oSection1:Cell("nTotal"):SetValue(((cAliasTmp)->VENCIDA+(cAliasTmp)->PROP))
	oSection1:Printline()
//	oSection1:Print()
	(cAliasTmp)->(dbSkip())
//endif
Enddo

//TRBreak():PrintTotal()
//TRFunction():PrintReport( )

if select(cAliasTmp) > 0
	dbSelectArea(cAliasTmp)
	dbCloseArea()
endif

oSection1:Finish()

Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±³Fun‡…o    ³ AjustaSX1 ³ Autor ³ Aline Correa do Vale ³ Data ³27/05/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera descricao da pergunta no SX1                        ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)
Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
Aadd(aRegs,{cPerg,"01","Filial de ?"         ,"","","mv_ch1","C",02,0,0,"G",""                          ,"MV_PAR01",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?"         ,"","","mv_ch2","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR02",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"03","Matricula de?"       ,"","","mv_ch3","C",06,0,0,"G",""                          ,"MV_PAR03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"04","Matricula Ate?"      ,"","","mv_ch4","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR04",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"05","Periodo?"            ,"","","mv_ch5","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR05",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","RCH","","",""})

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
