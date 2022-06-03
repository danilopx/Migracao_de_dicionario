#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GPRM011  ³ Autor ³ Ricardo Duarte Costa  ³ Data ³20/03/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Evolução Salarial                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³         Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GPRM011()

Local oReport
Local aArea		:= GetArea()
Private cPerg	:= "GPRM011   "
Private cTitFil	:= ""
Private cTitCC	:= ""
Private oBreak, oBreakCc
Private aInfo	:= {}

ValidPerg()

Pergunte(cPerg,.F.)
oReport := ReportDef()
oReport:PrintDialog()	  

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Trade Sistemas      ³ Data ³ 21.09.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Definicao do Componente de Impressao do Relatorio           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1
Local cAliasQry := "QRYSRD"
Local aOrd		:= {"Nome","Matricula","C.Custo + Nome"}

oReport:=TReport():New("GPRM011","Evolução Funcional",cPerg,{|oReport| PrintReport(oReport,cAliasQry)},"Este relatório lista as alterações salariais e funcionais do período.")
oReport:SetTotalInLine(.F.) //Totaliza em linha

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Primeira Secao:³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
oSection1:=TRSection():New(oReport,"Evolução Funcional",{"QRYSRD"},/*aOrd*/,/*Campos do SX3*/,/*Campos do SIX*/)

TRCell():New(oSection1,"RA_FILIAL","QRYSRD","Filial","@!",TamSx3( "RA_FILIAL" )[1])
TRCell():New(oSection1,"RA_MAT","QRYSRD","Matrícula","@!",TamSx3( "RA_MAT" )[1])
TRCell():New(oSection1,"RA_CC","QRYSRD","Centro de Custos",PesqPict("SRA","RA_CC"),TamSx3( "RA_CC" )[1])
TRCell():New(oSection1,"CTT_DESC01","QRYSRD","Descrição C.C.",,20)
TRCell():New(oSection1,"RA_NOME","QRYSRD","Nome",,TamSx3( "RA_NOME" )[1])
TRCell():New(oSection1,"RJ_DESC","QRYSRD","Desc.Função",PesqPict("SRJ","RJ_DESC"),TamSx3( "RJ_DESC" )[1])
TRCell():New(oSection1,"RA_ADMISSA","QRYSRD","Admissão",,8)
TRCell():New(oSection1,"RA_DEMISSA","QRYSRD","Demissão",,8)
TRCell():New(oSection1,"R7_DESCFUN","QRYSRD","Alteração Função",PesqPict("SRJ","RJ_DESC"),TamSx3( "RJ_DESC" )[1])
TRCell():New(oSection1,"R3_VALOR","QRYSRD","Salário",PesqPict("SR3","R3_VALOR"),TamSx3( "R3_VALOR" )[1])
TRCell():New(oSection1,"R3_DATA","QRYSRD","Data Aumento",,8)
TRCell():New(oSection1,"X5_DESCRI","QRYSRD","Tipo de Aumento",,15)

/*
TRCell():New(oSection1,"VALMES","QRYSRD","Valores Mensais",PesqPict("SRD","RD_VALOR"),TamSx3( "RD_VALOR" )[1])
TRCell():New(oSection1,"VALACUM","QRYSRD","Valores Acumulados",PesqPict("SRD","RD_VALOR"),TamSx3( "RD_VALOR" )[1])

//-- Totais por centro de custos
DEFINE BREAK oBreakCc	OF oReport WHEN oSection1:Cell("RD_CC") 	
TRFunction():New(oSection1:Cell("VALMES"),,"SUM",oBreakCC,,"@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection1:Cell("VALACUM"),,"SUM",oBreakCC,,"@E 999,999,999.99",,.F.,.F.)
oBreakCc:OnBreak({|x,y| cTitCc:="Total do centro de custo "+x+" - "+fDesc("CTT",x,"CTT->CTT_DESC01",,x)})	//"TOTAL DO CENTRO DE CUSTO"
oBreakCc:SetTotalText({||cTitCc})

//-- Total por filial
DEFINE BREAK oBreak 	OF oReport WHEN oSection1:Cell("RD_FILIAL")	
TRFunction():New(oSection1:Cell("VALMES"),,"SUM",oBreak,,"@E 999,999,999.99",,.F.,.F.)
TRFunction():New(oSection1:Cell("VALACUM"),,"SUM",oBreak,,"@E 999,999,999.99",,.F.,.F.)
oBreak:OnBreak({|x,y| fInfo(@aInfo,x),cTitFil:="Total da Filial "+x+" - "+aInfo[1]})	//"TOTAL DA FILIAL"
oBreak:SetTotalText({||cTitFil})
oBreak:SetPageBreak()
*/

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ReportDef() ³ Autor ³ Eduardo Ju          ³ Data ³ 30.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do Relatorio (Custo do Treinamento)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function PrintReport(oReport,cAliasQry)

Local oSection1 := oReport:Section(1)
Private nOrdem	:= oSection1:GetOrder()

/*
//-- Ajusta o titulo do relatorio
oReport:SetTitle("Resultados da Folha de Pagamento "+left(mv_par01,2)+"/"+right(mv_par01,4))

//-- Define os resumos por grupos apos os totais de filial / empresa / centro de custos (quando for analitico)
DEFINE COLLECTION OF oSection1 FUNCTION SUM FORMULA {|| oSection1:Cell("RV_XGRUPO"):GetValue(.T.) + " - " + Left(oSection1:Cell("GRUPODESC"):GetValue(.T.)+Space(25),25)+"."} CONTENT oSection1:Cell("VALMES") BREAK oBreak TITLE OemToAnsi("Total dos Valores Mensais") PICTURE "@E 999,999,999.99"	NO END SECTION
DEFINE COLLECTION OF oSection1 FUNCTION SUM FORMULA {|| oSection1:Cell("RV_XGRUPO"):GetValue(.T.) + " - " + Left(oSection1:Cell("GRUPODESC"):GetValue(.T.)+Space(25),25)+"."} CONTENT oSection1:Cell("VALACUM") BREAK oBreak TITLE OemToAnsi("Total dos Valores Acumulados") PICTURE "@E 999,999,999.99"	NO END SECTION
If lAnalitico
	DEFINE COLLECTION OF oSection1 FUNCTION SUM FORMULA {|| oSection1:Cell("RV_XGRUPO"):GetValue(.T.) + " - " + Left(oSection1:Cell("GRUPODESC"):GetValue(.T.)+Space(25),25)+"."} CONTENT oSection1:Cell("VALMES") BREAK oBreakCC TITLE OemToAnsi("Total dos Valores Mensais") PICTURE "@E 999,999,999.99"	NO END SECTION NO END REPORT
	DEFINE COLLECTION OF oSection1 FUNCTION SUM FORMULA {|| oSection1:Cell("RV_XGRUPO"):GetValue(.T.) + " - " + Left(oSection1:Cell("GRUPODESC"):GetValue(.T.)+Space(25),25)+"."} CONTENT oSection1:Cell("VALACUM") BREAK oBreakCC TITLE OemToAnsi("Total dos Valores Acumulados") PICTURE "@E 999,999,999.99"	NO END SECTION NO END REPORT
Endif
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma parametros Range em expressao SQL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(cPerg)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a consulta com as informacoes		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):BeginQuery()	
fMtaQuery()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a query dentro da section			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):EndQuery()	//*Array com os parametros do tipo Range*
	
//-- Inicio da impressao do fluxo do relatório
oReport:SetMeter((cAliasQry)->(LastRec()))

oSection1:Print()	 //Imprimir

//-- Libera o ambiente
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
Endif
//-- Fecha a tabela temporaria
DbSelectArea("SRA")

Return Nil   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ Trade Sistemas     º Data ³  21/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß /*/
Static Function ValidPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
aAdd(aRegs,{cPerg,'01','Períodos           ?','','','mv_ch1','D',099,0,0,'R','        ','mv_par01','             ','','','R7_DATA      ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'02','Filiais            ?','','','mv_ch2','C',099,0,0,'R','        ','mv_par02','             ','','','R7_FILIAL    ','','         ','','','','','','','','','','','','','','','','','','','SM0','','','','',''})
aAdd(aRegs,{cPerg,'03','Matriculas         ?','','','mv_ch3','C',099,0,0,'R','        ','mv_par03','             ','','','R7_MAT       ','','         ','','','','','','','','','','','','','','','','','','','SRA','','','','',''})
aAdd(aRegs,{cPerg,'04','Centros de Custos  ?','','','mv_ch4','C',099,0,0,'R','        ','mv_par04','             ','','','RA_CC        ','','         ','','','','','','','','','','','','','','','','','','','CTT','','','','',''})
aAdd(aRegs,{cPerg,'05','Tipos de Aumento   ?','','','mv_ch5','C',099,0,0,'R','        ','mv_par05','             ','','','R7_TIPO      ','','         ','','','','','','','','','','','','','','','','','','','X41','','','','',''})

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

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMtaQuery ºAutor  ³TRADE-RICARDO DUARTEº Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta a query para o programa principal                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Programa principal                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fMtaQuery(lMostrGrp)

Local nPos		:= 0
Local cRTFilial	:= ""
Local cQuery	:= ""
Local cAliasCorr:= Alias()
Local aInssEmp	:= {}
DEFAULT lMostrGrp	:= .T.

DbSelectArea(cAliasCorr)

cQuery	:= " SELECT RA_FILIAL, RA_MAT, RA_CC, CTT_DESC01, RA_NOME, RJ_DESC, RA_ADMISSA, RA_DEMISSA, R7_DESCFUN, R3_VALOR, R3_DATA, R3_TIPO, X5_DESCRI"
cQuery	+= " FROM "+RetSqlName("SR7")+" A"
cQuery	+= " INNER JOIN "+RetSqlName("SR3")+" B ON R7_FILIAL = R3_FILIAL AND R7_MAT = R3_MAT AND R7_DATA = R3_DATA AND R7_TIPO = R3_TIPO AND R7_SEQ = R3_SEQ AND R3_PD = '000' "
cQuery	+= " INNER JOIN "+RetSqlName("SRA")+" C ON R7_FILIAL = RA_FILIAL AND R7_MAT = RA_MAT"
cQuery	+= " INNER JOIN "+RetSqlName("CTT")+" D ON RA_CC = CTT_CUSTO"
cQuery	+= " INNER JOIN "+RetSqlName("SRJ")+" E ON RA_CODFUNC = RJ_FUNCAO"
cQuery	+= " INNER JOIN "+RetSqlName("SX5")+" F ON R7_TIPO = X5_CHAVE AND X5_TABELA = '41'"
cQuery	+= " WHERE "
cQuery	+= " A.D_E_L_E_T_ = ' ' AND B.D_E_L_E_T_ = ' ' AND C.D_E_L_E_T_ = ' ' AND D.D_E_L_E_T_ = ' ' AND E.D_E_L_E_T_ = ' ' AND F.D_E_L_E_T_ = ' ' "
If !Empty(mv_par01)
	cQuery	+= " AND "+MV_PAR01
Endif
If !Empty(mv_par02)
	cQuery	+= " AND "+MV_PAR02
Endif
If !Empty(mv_par03)
	cQuery	+= " AND "+MV_PAR03
Endif
If !Empty(mv_par04)
	cQuery	+= " AND "+MV_PAR04
Endif
If !Empty(mv_par05)
	cQuery	+= " AND "+MV_PAR05
Endif

If nOrdem == 1
	cQuery	+= " ORDER BY RA_FILIAL, RA_NOME"
ElseIf nOrdem == 2
	cQuery	+= " ORDER BY RA_FILIAL, RA_MAT"
ElseIf nOrdem == 3
	cQuery	+= " ORDER BY RA_FILIAL, RA_CC, RA_NOME"
Endif

//-- Executa a query
cQuery	:= Changequery(cQuery) 
TCQuery cQuery New Alias "QRYSRD"
TcSetField("QRYSRD","R3_VALOR","N",14,2)
TcSetField("QRYSRD","R3_DATA","D",8)

DbSelectArea(cAliasCorr)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GQFOLENV ³ Autor ³ Trade-Ricardo Duarte  ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Força o envio de email, indicando um email para copia.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³         Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GQFOLENV()
U_GQFOLMAIL(.T.)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ GQFOLMAIL³ Autor ³ Trade-Ricardo Duarte  ³ Data ³ 01/10/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio de email apos o fechamento mensal.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³         Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GQFOLMAIL(lMenu_)

Local cAnoMesAnt	:= GetMv("MV_FOLMES",,MesAno(dDataBase))
Local cAnoMesAtu	:= ""
Local lEnviaFol		:= .F.
Private cMailTo		:= SuperGetMv("MV_GQFOPAG")
Private cMailCC		:= ""

DEFAULT lMenu_	:= .F.
ValidPer1()

//-- Executa o fechamento mensal e testa a execucao da rotina, atraves da alteracao
//-- do parametro MV_FOLMES
If !lMenu_
	GPEM120()
	cAnoMesAtu	:= GetMv("MV_FOLMES",,MesAno(dDataBase))
	lEnviaFol	:= cAnoMesAnt <> cAnoMesAtu
Else
	If Pergunte("GQFOLMAIL",.T.)
		cMailCC		:= mv_par02
		cMailTo		:= ""
		lEnviaFol	:= .T.
		cAnoMesAnt	:= Right(mv_par01,4)+Left(mv_par01,2)
	Endif
Endif

If lEnviaFol
	MsAguarde( {|| fEnvEMail(cAnoMesAnt) }, "Processando...", "Preparando e-mail do Resultado Folha..." )	
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fEnvEMail ºAutor  ³TRADE-RICARDO DUARTEº Data ³  01/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Enviar o email com o resultado realizado na folha do mes.   º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß */
Static Function fEnvEMail(cAnoMesAnt)

Local cHtml		 	:= ""
Local cAssunto		:= ""
Local nErro			:= 0
Local nPos			:= 0
Local aInfo			:= {}
Local aTotFil		:= {}
Local aTotEmp		:= {}
Private cNomeTab	:= "PERCINSSEMP"
Private cAliasQry	:= "QRYSRD"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ MV_PAR01        //  Mes/Ano                                  ³
//³ MV_PAR02        //  Filiais Selecionadas                     ³
//³ MV_PAR03        //  Matricula De                             ³
//³ MV_PAR04        //  Matricula Ate                            ³
//³ MV_PAR05        //  Centro de Custos De                      ³
//³ MV_PAR06        //  Centro de Custos Ate                     ³
//³ MV_PAR07        //  Sintetico/Analitico                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMesAnoRef	:= cAnoMesAnt
cMatDe		:= space(TamSx3( "RD_MAT" )[1])
cMatAte		:= Replicate("Z",TamSx3( "RD_MAT" )[1])
cCCDe		:= space(TamSx3( "RD_CC" )[1])
cCCAte		:= Replicate("Z",TamSx3( "RD_CC" )[1])
lAnalitico	:= .F.		// Sempre sintetico para o envio do email
cFilialIn	:= ""

fMtaQuery(cNomeTab,.F.)

fInfo(@aInfo,cFilAnt)

//-- Monta o corpo do email
cAssunto	:= alltrim(aInfo[2])+" - Resultado da Folha de Pagamento "+right(cMesAnoRef,2)+"/"+left(cMesAnoRef,4)

cHtml +='<html>'
cHtml +=	'<body bgcolor="#F0F0F0"  topmargin="0" leftmargin="0">'
cHtml +=	'<Center>'
cHtml +=	cAssunto
cHtml +=	'</Center>'
cHtml +=		'<center>'
cHtml +=		'<table  border="1" cellpadding="0" cellspacing="0" bordercolor="#000082" bgcolor="#000082" width="950" height="200">'
cHtml +=		'<td width="950" height="181" bgcolor="#FFFFFF">'
cHtml +=		'<center>'
cHtml +=		'<font color="#000000">'
cHtml += '<!Folha de Pagamento>'
cHtml += '<div align="center">'
cHtml += '<Center>'
cHtml += '<Table bgcolor="#FFFFFF" style="border: 1px #003366 solid;" border="0" cellpadding ="1" cellspacing="1" width="950" height="296">'
cHtml +=    '<tr bgcolor=#D3D3D3>' 
cHtml += 	'<td width="70"><font face="Arial" size="02" color="#000000"><b>' + 'Filial' + '</b></font></td>'
cHtml += 	'<td width="220"><font face="Arial" size="02" color="#000000"><b>' + 'Centro de Custo' + '</b></font></td>'
cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + 'Valores Mensais' + '</b></font></td>'
cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + 'Valores Acumulados' + '</b></font></td>'
cHtml += 	'</tr>'

//-- Imprime os varios titulos a integrar
While !(cAliasQry)->(Eof())
	cFilialAnt	:= (cAliasQry)->RD_FILIAL
	cHtml += '<tr>'
	cHtml += 	'<td width="70"><font face="Arial" size="02" color="#000000">' + (cAliasQry)->RD_FILIAL + '</font></td>'
	cHtml += 	'<td width="220"><font face="Arial" size="02" color="#000000">' + (cAliasQry)->(RD_CC+" - "+CTT_DESC01) + '</font></td>'
	cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform((cAliasQry)->VALMES,"@E 999,999,999.99") + '</b></font></td>'
	cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform((cAliasQry)->VALACUM,"@E 999,999,999.99") + '</b></font></td>'
	cHtml += '</tr>'

	//-- Total da Filial
	nPos	:= Ascan(aTotFil,{|X| X[1] == (cAliasQry)->RD_FILIAL})
	If nPos > 0
		aTotFil[nPos,2] += (cAliasQry)->VALMES
		aTotFil[nPos,3] += (cAliasQry)->VALACUM
	Else
		Aadd(aTotFil,{(cAliasQry)->RD_FILIAL,(cAliasQry)->VALMES,(cAliasQry)->VALACUM})
	Endif

	//-- Total da Empresa
	nPos	:= Ascan(aTotEmp,{|X| X[1] == cEmpAnt})
	If nPos > 0
		aTotEmp[nPos,2] += (cAliasQry)->VALMES
		aTotEmp[nPos,3] += (cAliasQry)->VALACUM
	Else
		Aadd(aTotEmp,{cEmpAnt,(cAliasQry)->VALMES,(cAliasQry)->VALACUM})
	Endif

	(cAliasQry)->(dbskip())
	//-- Imprime o total da filial
	If cFilialAnt <> (cAliasQry)->RD_FILIAL .Or. (cAliasQry)->(Eof())
		If len(aTotFil) > 0
			aInfo := {}
			fInfo(@aInfo,cFilialAnt)
			cHtml += 	'<td width="70"><font face="Arial" size="02" color="#000000">' + "Total" + '</font></td>'
			cHtml += 	'<td width="220"><font face="Arial" size="02" color="#000000">' + aInfo[1] + '</font></td>'
			cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform(aTotFil[len(aTotFil),2],"@E 999,999,999.99") + '</b></font></td>'
			cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform(aTotFil[len(aTotFil),3],"@E 999,999,999.99") + '</b></font></td>'
			cHtml += '</tr>'
			//-- Limpa variaveis para a proxima filial
			aInfo	:= {}
			aTotFil	:= {}
			//-- Salta linha
			cHtml += '<tr>'
			cHtml +=    '<td colspan="4">&nbsp</td>'
			cHtml += '</tr>'
			cHtml += '<tr>'
		Endif
	Endif
Enddo

//-- Imprime o total da empresa
If len(aTotEmp) > 0
	fInfo(@aInfo,cFilialAnt)
	cHtml += 	'<td width="70"><font face="Arial" size="02" color="#000000">' + "Total" + '</font></td>'
	cHtml += 	'<td width="220"><font face="Arial" size="02" color="#000000">' + aInfo[2] + '</font></td>'
	cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform(aTotEmp[len(aTotEmp),2],"@E 999,999,999.99") + '</b></font></td>'
	cHtml += 	'<td width="120" align="right"><font face="Arial" size="02" color="#000000"><b>' + Transform(aTotEmp[len(aTotEmp),3],"@E 999,999,999.99") + '</b></font></td>'
	cHtml += '</tr>'
Endif

//-- Finalização do email
cHtml += '</table>'
cHtml += '</td>'
cHtml += '</table>'
cHtml += '</center>'
cHtml += '</div>'
cHtml += '</body>'
cHtml += '</html>'

//-- Executa o envio do email e controla a mensagem de erro que vier a ocorrer.
MsgRun( OemToAnsi("Aguarde. Enviando Email - Folha de Pagamento Realizada"),"",{|| ( nErro := RH_Email(cMailTo+";"+cMailCC,,cAssunto,cHtml,,) ) })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do Relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select(cAliasQry) > 0
	//-- Processou sem problemas
	RH_ErroMail(nErro)
	If nErro <> 0
		//-- Processo não finalizado.
		Aviso("Atencao","Avisar que o email não foi enviado.",{"Ok"})
    Endif
Endif


//-- Libera o ambiente
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
Endif
//-- Fecha a tabela temporaria
dbSelectArea( "INSSEMP" )
dbCloseArea()
DbSelectArea("SRA")

// Exclui tabela temporaria
If TCCanOpen(cNomeTab)
	TcDelFile(cNomeTab) 
EndIf    

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPER1 º Autor ³ TRADE SISTEMAS     º Data ³  04/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß /*/
Static Function ValidPer1

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR("GQFOLMAIL",Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
aAdd(aRegs,{"GQFOLMAIL",'01','Mês/Ano (MMAAAA)   ?','','','mv_ch1','C',006,0,0,'G','        ','mv_par01','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','','','','','',''})
aAdd(aRegs,{"GQFOLMAIL",'02','Para (email):      ?','','','mv_ch2','C',099,0,0,'G','        ','mv_par02','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','_EM','','','','',''})

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

Return

