#Include"rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATRL001  บAutor  ณPaulo Bindo         บ Data ณ  05/13/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณResumo financeiro de vendas                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATRL001()

	Private cString
	Private aOrd 		 := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2       := "de acordo com os parametros informados pelo usuario."
	Private cDesc3       := "Resumo Financeiro de Vendas"
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "FATRL001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private titulo		 := "FATRL001"
	Private nLin         := 80
	Private Cabec1
	Private Cabec2       := ""
	Private _cMes00 := _cMes01 := _cMes02 := _cMes03 := ""
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private imprime      := .T.
	Private wnrel        := "FATRL001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nFatur       := 0
	Private cCond        := ""
	Private nOrdem       := 0
	Private cArqDbf      := ""
	Private cArqNtx      := ""
	Private nFatGeral    := 0
	Private nAnoAnt		 := 0
	Private _dDatai1 := _dDatai2 := _dDatai3 := _dDatai4 := dDataf1:= dDataf2:= dDataf3:= dDataf4:= Ctod("")
	Private cPerg		 := "FTRL01"
	Private lContrato    := .F.


	ValidPerg()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario... ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := 18

//forma os meses
	nAnoAnt := Year(dDataBase)-1	//ANO ANTERIOR

	dDatai1 := FirstDay(CtoD('01/'+MV_PAR01+'/'+mv_par04))
	dDatai2 := FirstDay(CtoD('01/'+MV_PAR01+'/'+mv_par04)+35)
	dDatai3 := FirstDay(CtoD('01/'+MV_PAR01+'/'+mv_par04)+70)
	dDatai4 := FirstDay(CtoD('01/'+MV_PAR01+'/'+mv_par04)+105)


	dDataf1 := LastDay(dDatai1)
	dDataf2 := LastDay(dDatai2)
	dDataf3 := LastDay(dDatai3)
	dDataf4 := LastDay(dDatai4)


	_cMes00 := Left(Upper(MesExtenso(Month(dDatai1))),3)+'/'+Str(Year(dDatai1),4)
	_cMes01 := Left(Upper(MesExtenso(Month(dDatai2))),3)+'/'+Str(Year(dDatai2),4)
	_cMes02 := Left(Upper(MesExtenso(Month(dDatai3))),3)+'/'+Str(Year(dDatai3),4)
	_cMes03 := Left(Upper(MesExtenso(Month(dDatai4))),3)+'/'+Str(Year(dDatai4),4)

	titulo       := "Resumo Financeiro de Vendas - "+Upper(MesExtenso(Val(MV_PAR01)))+'/'+mv_par04
	Cabec1       := "DIA REF.  N. NOTAS   TOTAL FATURADO  TOTAL ICMS   %ICMS       "+_cMes00+"      %        "+_cMes01+"      %        "+_cMes02+"      %          "+_cMes03+"      %          FUTURO     %"
//				   99        999999    99,999,999.99   99,999.99  999.99  99,999.999,99  999.99  99,999.999,99  999.99  99,999.999,99  99.999  99,999.999,99  99.999  99,999.999,99  99.999
//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345679012345678901234567901234567890101234567901234567890123456789012345678901
//                          1         2         3         4         5         6         7         8         9         0        1        2         3        4         5          6         7         8         0


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Processa({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR42   บAutor  ณMicrosiga           บ Data ณ  05/13/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
	Local z := 0
	Private _cOrdem := ""


	nFatur := 0
	cCondFat := ""
/*
//SELECIONA OS TITULOS VENCIDOS NOS ANOS ANTERIORES
cQuery := " SELECT SUM(E1_VALOR) TOTALR, A1_TPESSOA, E1_CLIENTE, E1__TMKCTR, A3_GRPREP"
cQuery += " FROM "+RetSqlName("SE1")+" E1 "
cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = E1_CLIENTE"
cQuery += " INNER JOIN " + RetSqlName("SA3")+" A3  ON A3_COD = E1_VEND1"
cQuery += " WHERE E1_TIPO = 'NF' "
cQuery += " AND E1.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
cQuery += " AND LEFT(E1_VENCREA,4) <= '"+AllTrim(Str(nAnoAnt))+"' AND E1_BAIXA = ''"
cQuery += " GROUP BY A1_TPESSOA, E1_CLIENTE, E1__TMKCTR, A3_GRPREP"


MemoWrite("FATRL001.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

aMeses := {}

Count To nRec
	If nRec > 0

dbSelectArea("TRB")
ProcRegua(nRec)
dbGotop()

		While !Eof()
IncProc("Selecionando os tํtulos vencidos")
cPessoa	:= TRB->A1_TPESSOA

			If !Empty(TRB->E1__TMKCTR)
lContrato := .T.
			Else
lContrato:= U_Contrato(TRB->E1_CLIENTE,"")
			EndIf

cTipo := Iif(lContrato,"Contrato",Iif(cPessoa=="EP","Governo","Spot"))

nAscan := Ascan(aMeses, {|e| e[1] == TRB->A3_GRPREP .And. e[2] == cTipo})
			If nAscan == 0
aAdd(aMeses,{'',;	//01- MES 01
0,;		//02- VALOR MES 01
'',;	//03- MES 02
0,;		//04- VALOR MES 02
'',;	//05- MES 03
0,;		//06- VALOR MES 03
'',;	//07- MES 04
0,;		//08- VALOR MES 04
'',;	//09- MES 05
0,;		//10- VALOR MES 05
'',;	//11- MES 06
0,;		//12- VALOR MES 06
'',;	//13- MES 07
0,;		//14- VALOR MES 07
'',;	//15- MES 08
0,;		//16- VALOR MES 08
'',;	//17- MES 09
0,;		//18- VALOR MES 09
'',;	//19- MES 10
0,;		//20- VALOR MES 10
'',;	//21- MES 11
0,;		//22- VALOR MES 11
'',;	//23- MES 12
0,;		//24- VALOR MES 12
AllTrim(Str(nAnoAnt)),;	//25- ANO ANTERIOR
TRB->TOTALR,;		//26- VALOR ANO ANTERIOR
TRB->A3_GRPREP,;	//27- GRUPO VENDAS
cTipo})		//28- SEGMENTO VENDAS

nAscan := Ascan(aMeses, {|e| e[1] == TRB->A3_GRPREP .And. e[2] == cTipo})
				For n:= 1 To 12
aMeses[nAscan][(2*n)-1]:= Left(Upper(MesExtenso(n)),3)+'/'+Str(Year(dDataBase),4)
aMeses[nAscan][2*n] 	:= 0
				Next

			Else
aMeses[nAscan][26] += TRB->TOTALR
			EndIf

aAdd(aAtraso,{Iif(lContrato,"Contrato",Iif(cPessoa=="EP","Governo","Spot")), TRB->TOTALR})
dbSelectArea("TRB")
dbSkip()
		End

	EndIf

TRB->(dbCloseArea())
*/
//SELECIONA O FATURAMENTO E OS TITULOS A VENCER
	cQuery := " SELECT RIGHT(F2.F2_EMISSAO,2) F2_EMISSAO, F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE, SUM(D2.D2_TOTAL) D2_TOTAL, SUM(D2.D2_VALICM) ICMS,"
	If mv_par05 == 1 //PREVISTO
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_VENCREA BETWEEN '" + DtoS(dDatai1) +"' AND '" + DtoS(dDataf1) + "' AND E1_FILIAL = F2_FILIAL) NOMES,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_VENCREA BETWEEN '" + DtoS(dDatai2) +"' AND '" + DtoS(dDataf2) + "' AND E1_FILIAL = F2_FILIAL) MES01,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_VENCREA BETWEEN '" + DtoS(dDatai3) +"' AND '" + DtoS(dDataf3) + "' AND E1_FILIAL = F2_FILIAL) MES02,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_VENCREA BETWEEN '" + DtoS(dDatai4) +"' AND '" + DtoS(dDataf4) + "' AND E1_FILIAL = F2_FILIAL) MES03,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_VENCREA > '" + DtoS(dDataf4) + "'AND E1_FILIAL = F2_FILIAL) MESFT,"
	Else //REAL
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_BAIXA BETWEEN '" + DtoS(dDatai1) +"' AND '" + DtoS(dDataf1) + "' AND E1_FILIAL = F2_FILIAL) NOMES,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_BAIXA BETWEEN '" + DtoS(dDatai2) +"' AND '" + DtoS(dDataf2) + "' AND E1_FILIAL = F2_FILIAL) MES01,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_BAIXA BETWEEN '" + DtoS(dDatai3) +"' AND '" + DtoS(dDataf3) + "' AND E1_FILIAL = F2_FILIAL) MES02,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_BAIXA BETWEEN '" + DtoS(dDatai4) +"' AND '" + DtoS(dDataf4) + "' AND E1_FILIAL = F2_FILIAL) MES03,"
		cQuery += " (SELECT SUM(ISNULL(E1.E1_VALOR,0)) FROM " + RetSqlName("SE1")+" E1 WITH(NOLOCK) WHERE E1.E1_TIPO = 'NF' AND E1.E1_NUM = F2.F2_DOC AND E1.E1_CLIENTE = F2.F2_CLIENTE AND E1.E1_PREFIXO = F2.F2_SERIE AND E1.D_E_L_E_T_ = '' AND E1.E1_BAIXA > '" + DtoS(dDataf4) + "'AND E1_FILIAL = F2_FILIAL) MESFT,"
	EndIf
	cQuery += " D2_ITEMCC"
	cQuery += " FROM "+RetSqlName("SF2")+" F2 WITH(NOLOCK) "
	cQuery += " INNER JOIN " + RetSqlName("SD2")+" D2 WITH(NOLOCK) "
	cQuery += " ON D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2_FILIAL = F2_FILIAL "
	cQuery += " INNER JOIN " + RetSqlName("SF4")+" F4 WITH(NOLOCK) "
	cQuery += " ON D2.D2_TES = F4.F4_CODIGO AND F4_FILIAL = F2_FILIAL"
	cQuery += " INNER JOIN " + RetSqlName("SA1")+" A1 WITH(NOLOCK) "
	cQuery += " ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA"
	cQuery += " WHERE F2.D_E_L_E_T_ <> '*' "
	cQuery += " AND D2.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*'  AND A1.D_E_L_E_T_ <> '*'"
	cQuery += " AND F2_FILIAL BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
	cQuery += " AND A1_FILIAL = '"+xFilial("SA1")+"'"
	cQuery += " AND SUBSTRING(F2.F2_EMISSAO,5,2) = '"+MV_PAR01+"' "
	cQuery += " AND LEFT(F2.F2_EMISSAO,4) = '"+mv_par04+"' "

	cQuery += " AND F4_DUPLIC = 'S' AND F2_TIPO = 'N'"
	cQuery += " GROUP BY F2_FILIAL, RIGHT(F2.F2_EMISSAO,2), F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE,D2_ITEMCC"
	cQuery += " ORDER BY D2_ITEMCC, RIGHT(F2.F2_EMISSAO,2), F2.F2_DOC"

//cQuery := ChangeQuery(cQuery)
	//MemoWrite("FATRL001.SQL", cQuery )
	MsgRun("Aguarde...Selecionando dados " ,,{ || dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.) })



	Count To nRec
	If nRec == 0
		MsgStop("Nใo existem dados para este relat๓rio","Aten็ใo")
		TRB->(dbCloseArea())
		Return
	EndIf

	aTotGeral		:= {0,0,0,0,0,0,0,0}
	aResumo			:= {}
	dbSelectArea("TRB")
	ProcRegua(nRec)
	dbGotop()
	While !Eof()
		IncProc("Gerando Arquivo...")


		nAscan := Ascan(aResumo, {|e|  e[2] == TRB->D2_ITEMCC .And. e[3]==TRB->F2_EMISSAO})

		If nAscan == 0
			aAdd(aResumo,{'',;	//01- GRUPO DE VENDAS
			TRB->D2_ITEMCC,;				//02- SEGMENTO DE VENDAS
			TRB->F2_EMISSAO,;	//03- DIA
			TRB->D2_TOTAL,;	//04- VALOR
			TRB->NOMES,;		//05- VENC NO MES
			TRB->MES01,;		//06- VENC MES+1
			TRB->MES02,;		//07- VENC MES+2
			TRB->MES03,;		//08- VENC MES+3
			TRB->MESFT,;		//09- VENC ACIMA MES+3
			TRB->ICMS,;			//10- VALOR ICMS
			1})					//11- NUMERO DE NOTAS
		Else
			aResumo[nAscan][4] += TRB->D2_TOTAL	//04- VALOR
			aResumo[nAscan][5] += TRB->NOMES		//05- VENC NO MES
			aResumo[nAscan][6] += TRB->MES01		//06- VENC MES+1
			aResumo[nAscan][7] += TRB->MES02		//07- VENC MES+2
			aResumo[nAscan][8] += TRB->MES03		//08- VENC MES+3
			aResumo[nAscan][9] += TRB->MESFT		//09- VENC ACIMA MES+3
			aResumo[nAscan][10]+= TRB->ICMS		//10- VALOR ICMS
			aResumo[nAscan][11]++
		EndIf

		//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
		aTotGeral[1] ++
		aTotGeral[2] += TRB->D2_TOTAL
		aTotGeral[3] += TRB->ICMS
		aTotGeral[4] += TRB->NOMES
		aTotGeral[5] += TRB->MES01
		aTotGeral[6] += TRB->MES02
		aTotGeral[7] += TRB->MES03
		aTotGeral[8] += TRB->MESFT


		dbSelectArea("TRB")
		dbSkip()
	End
	TRB->(dbCloseArea())

	aSort(aResumo,,,{|x,y|x[1]+x[2]+x[3]<y[1]+y[2]+y[3]})

	aTotFilial		:= {0,0,0,0,0,0,0,0}
	aTotTipo		:= {0,0,0,0,0,0,0,0}
	cFilialC	 	:= ""
	cFilialR	 	:= ""
	cTipoC			:= ""
	cTipoR			:= ""

//IMPRIME O RELATORIO
	For z:= 1 To Len(aResumo)

		IncProc("Imprimindo Relat๓rio ")


		//IMPRIME A TOTALIZACAO DA MODALIDADE
		If (cTipoC # aResumo[z][2] ) .And. z > 1
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. .  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nLin+6 > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				If z > 1
					@nLin,000 PSAY "CONTINUA MODALIDADE-> "+cTipoC
					nLin+= 2
				EndIf
			Endif

			//			nLin ++
			@nLin,001 PSAY Replicate("=",212)
			nLin ++

			//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
			@nLin,001 PSAY "TOTAL TIPO ->"									 				//DIA
			@nLin,014 PSAY aTotTipo[1] 							PICTURE '999999'			//NUMERO NOTAS
			@nLin,021 PSAY aTotTipo[2] 							PICTURE "@E 999,999,999.99"	//TOTAL
			@nLin,037 PSAY aTotTipo[3]							PICTURE "@E 9,999,999.99"	//ICMS
			@nLin,048 PSAY aTotTipo[3]/aTotTipo[2]*100		 	PICTURE "@E 999.99"			//%ICMS
			@nLin,056 PSAY aTotTipo[4] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
			@nLin,071 PSAY aTotTipo[4]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES ATUAL
			@nLin,079 PSAY aTotTipo[5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
			@nLin,094 PSAY aTotTipo[5]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +1
			@nLin,102 PSAY aTotTipo[6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
			@nLin,119 PSAY aTotTipo[6]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +2
			@nLin,127 PSAY aTotTipo[7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
			@nLin,143 PSAY aTotTipo[7]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +3
			@nLin,151 PSAY aTotTipo[8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
			@nLin,165 PSAY aTotTipo[8]/aTotTipo[2]*100	 		PICTURE "@E 999.99"			//%MES FUTURO
			aTotTipo		:= {0,0,0,0,0,0,0,0}
			nLin +=2
		EndIf

		//IMPRIME O TOTAL FILIAL
		If cTipoC # aResumo[z][2] .And. z > 1

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. .  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If nLin+6 > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				If z > 1
					@nLin,000 PSAY "CONTINUA MODALIDADE-> "+cTipoC
					nLin+= 2
				EndIf
			Endif

		/*
		nLin ++
		@nLin,001 PSAY Replicate("=",212)
		nLin ++
		//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
		@nLin,001 PSAY "TOTAL FIL.->"
		@nLin,014 PSAY aTotFilial[1] 							PICTURE '999999'			//NUMERO NOTAS
		@nLin,021 PSAY aTotFilial[2] 							PICTURE "@E 999,999,999.99"	//TOTAL
		@nLin,037 PSAY aTotFilial[3]							PICTURE "@E 999,999.99"		//ICMS
		@nLin,048 PSAY aTotFilial[3]/aTotFilial[2]*100		 	PICTURE "@E 999.99"			//%ICMS
		@nLin,056 PSAY aTotFilial[4] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
		@nLin,071 PSAY aTotFilial[4]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES ATUAL
		@nLin,079 PSAY aTotFilial[5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
		@nLin,094 PSAY aTotFilial[5]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +1
		@nLin,102 PSAY aTotFilial[6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
		@nLin,119 PSAY aTotFilial[6]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +2
		@nLin,127 PSAY aTotFilial[7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
		@nLin,143 PSAY aTotFilial[7]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +3
		@nLin,151 PSAY aTotFilial[8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
		@nLin,165 PSAY aTotFilial[8]/aTotFilial[2]*100	 		PICTURE "@E 999.99"			//%MES FUTURO
		aTotFilial		:= {0,0,0,0,0,0,0,0}
		nLin +=2
		*/
		EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. .  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nLin > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
			If z > 1
				@nLin,000 PSAY "CONTINUA MODALIDADE-> "+cTipoC
				nLin+= 2
			EndIf
		Endif

	/*
	//IMPRIME CABECALHO DA FILIAL
		If cFilialC # aResumo[z][1]
	cFilialC 	:= aResumo[z][1]
	cTipoC		:= ""
	@nLin,000 PSAY "FILIAL-> "+cFilialC
	nLin++
		EndIf
	*/
		//IMPRIME CABECALHO DO O GRUPO
		If cTipoC # aResumo[z][2]
			cTipoC 		:= aResumo[z][2]
			@nLin,000 PSAY "MODALIDADE-> "+cTipoC
			nLin++
		EndIf



		//	Cabec1       := "DIA REF.  N. NOTAS   TOTAL FATURADO  TOTAL ICMS   %ICMS      "+_cMes00+"     %      "+_cMes01+"    %      "+_cMes02+"     %      "+_cMes03+"       FUTURO              %"
		//				   99        999999    99,999,999.99  999,999.99  999.99  99,999.999,99  999.99  99,999.999,99  999.99  99,999.999,99  99.999  99,999.999,99  99.999  99,999.999,99  99.999
		//                0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345679012345679012345678901234567901234567890101234567901234567890123456789012345678901
		//                          1         2         3         4         5         6         7         8         9         0        1        2         3        4         5          6         7         8         0

		@nLin,001 PSAY aResumo[z][3] 							PICTURE '@!' 				//DIA
		@nLin,014 PSAY aResumo[z][11] 							PICTURE '999999'			//NUMERO NOTAS
		@nLin,021 PSAY aResumo[z][4] 							PICTURE "@E 99,999,999.99"	//TOTAL
		@nLin,037 PSAY aResumo[z][10]							PICTURE "@E 999,999.99"		//ICMS
		@nLin,048 PSAY aResumo[z][10]/aResumo[z][4]*100	 	PICTURE "@E 999.99"			//%ICMS
		@nLin,056 PSAY aResumo[z][5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
		@nLin,071 PSAY aResumo[z][5]/aResumo[z][4]*100 		PICTURE "@E 999.99"			//%MES ATUAL

		@nLin,079 PSAY aResumo[z][6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
		@nLin,094 PSAY aResumo[z][6]/aResumo[z][4]*100 		PICTURE "@E 999.99"			//%MES +1
		@nLin,102 PSAY aResumo[z][7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
		@nLin,119 PSAY aResumo[z][7]/aResumo[z][4]*100 		PICTURE "@E 999.99"			//%MES +2
		@nLin,127 PSAY aResumo[z][8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
		@nLin,143 PSAY aResumo[z][8]/aResumo[z][4]*100 		PICTURE "@E 999.99"			//%MES +3
		@nLin,151 PSAY aResumo[z][9] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
		@nLin,165 PSAY aResumo[z][9]/aResumo[z][4]*100 		PICTURE "@E 999.99"			//%MES FUTURO

		@nLin++

		//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
		aTotFilial[1] += aResumo[z][11]
		aTotFilial[2] += aResumo[z][4]
		aTotFilial[3] += aResumo[z][10]
		aTotFilial[4] += aResumo[z][5]
		aTotFilial[5] += aResumo[z][6]
		aTotFilial[6] += aResumo[z][7]
		aTotFilial[7] += aResumo[z][8]
		aTotFilial[8] += aResumo[z][9]

		aTotTipo[1] += aResumo[z][11]
		aTotTipo[2] += aResumo[z][4]
		aTotTipo[3] += aResumo[z][10]
		aTotTipo[4] += aResumo[z][5]
		aTotTipo[5] += aResumo[z][6]
		aTotTipo[6] += aResumo[z][7]
		aTotTipo[7] += aResumo[z][8]
		aTotTipo[8] += aResumo[z][9]
	Next

	If nLin+6 > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		If z > 1
			@nLin,000 PSAY "CONTINUA FILIAL-> "+cFilialc
			nLin+= 2
		EndIf
	Endif

//IMPRIME O TOTAL DO GRUPO
	nLin ++
	@nLin,001 PSAY Replicate("=",212)
	nLin ++

//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
	@nLin,001 PSAY "TOTAL TIPO ->"
	@nLin,014 PSAY aTotTipo[1] 							PICTURE '999999'			//NUMERO NOTAS
	@nLin,021 PSAY aTotTipo[2] 							PICTURE "@E 999,999,999.99"	//TOTAL
	@nLin,037 PSAY aTotTipo[3]							PICTURE "@E 9,999,999.99"		//ICMS
	@nLin,048 PSAY aTotTipo[3]/aTotTipo[2]*100		 	PICTURE "@E 999.99"			//%ICMS
	@nLin,056 PSAY aTotTipo[4] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
	@nLin,071 PSAY aTotTipo[4]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES ATUAL
	@nLin,079 PSAY aTotTipo[5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
	@nLin,094 PSAY aTotTipo[5]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +1
	@nLin,102 PSAY aTotTipo[6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
	@nLin,119 PSAY aTotTipo[6]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +2
	@nLin,127 PSAY aTotTipo[7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
	@nLin,143 PSAY aTotTipo[7]/aTotTipo[2]*100 		PICTURE "@E 999.99"			//%MES +3
	@nLin,151 PSAY aTotTipo[8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
	@nLin,165 PSAY aTotTipo[8]/aTotTipo[2]*100	 		PICTURE "@E 999.99"			//%MES FUTURO

	If nLin+6 > 60 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
/*
//IMPRIME O TOTAL DA FILIAL
nLin ++
@nLin,001 PSAY Replicate("=",212)
nLin ++
//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
@nLin,001 PSAY "TOTAL FIL.->"
@nLin,014 PSAY aTotFilial[1] 							PICTURE '999999'			//NUMERO NOTAS
@nLin,021 PSAY aTotFilial[2] 							PICTURE "@E 999,999,999.99"	//TOTAL
@nLin,037 PSAY aTotFilial[3]							PICTURE "@E 999,999.99"		//ICMS
@nLin,048 PSAY aTotFilial[3]/aTotFilial[2]*100		 	PICTURE "@E 999.99"			//%ICMS
@nLin,056 PSAY aTotFilial[4] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
@nLin,071 PSAY aTotFilial[4]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES ATUAL
@nLin,079 PSAY aTotFilial[5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
@nLin,094 PSAY aTotFilial[5]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +1
@nLin,102 PSAY aTotFilial[6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
@nLin,119 PSAY aTotFilial[6]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +2
@nLin,127 PSAY aTotFilial[7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
@nLin,143 PSAY aTotFilial[7]/aTotFilial[2]*100 		PICTURE "@E 999.99"			//%MES +3
@nLin,151 PSAY aTotFilial[8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
@nLin,165 PSAY aTotFilial[8]/aTotFilial[2]*100	 		PICTURE "@E 999.99"			//%MES FUTURO
*/

//IMPRIME O TOTAL GERAL
	nLin +=2
	@nLin,001 PSAY Replicate("=",212)
	nLin ++

//01- QTDE NOTAS, 02- TOTAL, 03- ICMS, 04- MES ATUAL, 05- MES +1, 06- MES+2, 07- MES+3, 08- MES FUTURO
	@nLin,001 PSAY "TOTAL GERAL:"
	@nLin,014 PSAY aTotGeral[1] 							PICTURE '999999'			//NUMERO NOTAS
	@nLin,021 PSAY aTotGeral[2] 							PICTURE "@E 999,999,999.99"	//TOTAL
	@nLin,037 PSAY aTotGeral[3]			  					PICTURE "@E 9,999,999.99"		//ICMS
	@nLin,048 PSAY aTotGeral[3]/aTotGeral[2]*100		 	PICTURE "@E 999.99"			//%ICMS
	@nLin,056 PSAY aTotGeral[4] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES ATUAL
	@nLin,071 PSAY aTotGeral[4]/aTotGeral[2]*100	 		PICTURE "@E 999.99"			//%MES ATUAL
	@nLin,079 PSAY aTotGeral[5] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +1
	@nLin,094 PSAY aTotGeral[5]/aTotGeral[2]*100 			PICTURE "@E 999.99"			//%MES +1
	@nLin,102 PSAY aTotGeral[6] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +2
	@nLin,119 PSAY aTotGeral[6]/aTotGeral[2]*100 			PICTURE "@E 999.99"			//%MES +2
	@nLin,127 PSAY aTotGeral[7] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES +3
	@nLin,143 PSAY aTotGeral[7]/aTotGeral[2]*100 			PICTURE "@E 999.99"			//%MES +3
	@nLin,151 PSAY aTotGeral[8] 							PICTURE "@E 999,999,999.99"	//VENCIMENTO NO MES FUTURO
	@nLin,165 PSAY aTotGeral[8]/aTotGeral[2]*100	 		PICTURE "@E 999.99"			//%MES FUTURO
	aTotGeral		:= {0,0,0,0,0,0,0,0}
	nLin +=2

	roda(cbcont,cbtxt)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณPaulo Bindo         บ Data ณ  12/01/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria pergunta no e o help do SX1                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Mes Referencia   		?",""                    ,""                    ,"mv_ch1","C"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Da Filial      		?",""                    ,""                    ,"mv_ch2","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Ate a Filial   		?",""                    ,""                    ,"mv_ch3","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par03",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Ano 			  		?",""                    ,""                    ,"mv_ch4","C"   ,04      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Vencimento	  		?",""                    ,""                    ,"mv_ch5","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par05","Previsto"   	 ,""      ,""      ,""    ,"Real"      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")



	cKey     := "P.FTRL0101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o M๊s ")
	aAdd(aHelpPor,"de Refer๊ncia")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTRL0102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Filial")
	aAdd(aHelpPor,"inicial ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.FTRL0103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Filial Final ")
	aAdd(aHelpPor,"ou coloque ZZ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTRL0104."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Ano ")
	aAdd(aHelpPor,"de Refer๊ncia")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTRL0105."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Data de vencimento ")
	aAdd(aHelpPor,"Real ou prevista. A Real so analisa titulos baixados")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


Return
