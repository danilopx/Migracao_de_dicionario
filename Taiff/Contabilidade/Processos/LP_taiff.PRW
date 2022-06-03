#include "rwmake.ch"
//atualizado no dia 11/05/2011- 21:33
/*                     
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Lp       ºAutor  ³Microsiga           º Data ³  20/12/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Regra para atender a integração contábil                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Regra contábil, para atender o movimento de compras
//Novo
User Function LP_comp()
Local aArea	:= GetArea()
Private cRet	:= ""

DbSelectArea("SBM")
SBM->(dbsetorder(1))//BM_FILIAL+BM_GRUPO

If SD1->D1_CLASCON=="1".AND.alltrim(SD1->D1_GRUPO)<>" ".AND.ALLTRIM(SD1->D1_CLVL)==""
	cRet :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_EST"))
	
ElseiF  SD1->D1_CLASCON=="2".AND.alltrim(SD1->D1_GRUPO)<>" ".AND.ALLTRIM(SD1->D1_CLVL)==""
	cRet :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_REV"))
	
ElseIf SD1->D1_CLASCON $ "6" .AND. SM0->M0_CODIGO $ "01/02/04" .AND. alltrim(SD1->D1_GRUPO)<>" " .AND. ALLTRIM(SD1->D1_CLVL)==""
	If SD1->D1_CC $ ("120602/120603/120604")
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_EST"))
	ElseIf SD1->D1_CC $ ("120801/100101/120101/040201/120201/120301/010301/120501/120601/120401/100201")
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_INVEST"))
	Else
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_OUTRAS"))
	EndIf
	
Elseif  SD1->D1_CLASCON = "6" .AND. alltrim(SD1->D1_GRUPO)<>" ".AND.ALLTRIM(SD1->D1_CLVL)==""
	cRet :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DADM"))
	
Elseif SD1->D1_CLASCON $ "3|4" .AND. alltrim(SD1->D1_GRUPO)<>" " .AND. ALLTRIM(SD1->D1_CLVL) == ""
	//cRet :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_INVEST"))
	If SD1->D1_CC $ ("120602/120603/120604")
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_EST"))
	ElseIf SD1->D1_CC $ ("120801/100101/120101/040201/120201/120301/010301/120501/120601/120401/100201")
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_INVEST"))
	Else
		cRet := alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_OUTRAS"))
	EndIf
	
Elseif SD1->D1_CLASCON=="5".AND.alltrim(SF4->F4_CONTA)<>""//ALTERADO    19-10-10
	cRet := alltrim(SF4->F4_CONTA)
	
Elseif SD1->D1_CLASCON $"1,2,3,4".AND.alltrim(SD1->D1_GRUPO)==" ".AND.ALLTRIM(SD1->D1_CLVL)=="" //ALTERADO 19-10-10
	cRet :="1104010004"  // Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 8101010001
	
Elseif SD1->D1_CLASCON $"1,2,3,4".AND.alltrim(SD1->D1_GRUPO)<>" ".AND.ALLTRIM(SD1->D1_CLVL)<>"" //ALTERADO 20/01/2011
	cRet :=IF(alltrim(Posicione("CTH",1,xFilial("CTH")+SD1->D1_CLVL,"CTH_CONTA"))=="",ALLTRIM(SD1->D1_CONTA),"8101010001") 
		                                                                            
Else
	cRet :=ALLTRIM(SD1->D1_CONTA)
	
Endif
RestArea( aArea )
Return(cRet)

//Regra para atender o lançamento de compras com o movimento de IPI/ICMS/PIS/COFINS, referente aos campos valores.
//ALTERADO DIA 27/02/2011

User Function LP_VrNIm()
Local aArea	:= GetArea()
Private vRetni	:= 0

If SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.!SF4->F4_PISCOF$"1,2,3".AND.!alltrim(SF4->F4_CF)$"3101,3102,1407,2407,1556,2556".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_TOTAL+SD1->D1_VALIPI // A linha original contemplava apenas D1_TOTAL, foi solicitado para incluir D1_VALIPI em 26/04 pelo consulto Altamir (comentado por: ctorres)
	
Elseif SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.!SF4->F4_PISCOF$"1,2,3".AND.alltrim(SF4->F4_CF)$"1407,2407".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO 
	
Elseif SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="S".AND.!SF4->F4_PISCOF$"1,2,3".AND.alltrim(SF4->F4_CF)$"1556,2556".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO
	
Elseif SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="N".AND.!SF4->F4_PISCOF$"1,2,3".AND.alltrim(SF4->F4_CF)$"1556,2556".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO
	
elseIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="N".AND.SF4->F4_PISCOF$"1,2,3".AND.!alltrim(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO
	
elseIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="S".AND.SF4->F4_PISCOF$"1,2,3".AND.alltrim(SF4->F4_CF)$"1403,2403".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->(D1_CUSTO+D1_VALIPI)
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="S".AND.SF4->F4_PISCOF$"1,2,3".AND.!alltrim(SF4->F4_CF)$"3101,3102,1101,2101,1102,2102,1122,2122".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->(D1_CUSTO-D1_VALIPI)

ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="S".AND.SF4->F4_PISCOF$"1,2,3".AND.alltrim(SF4->F4_CF)$"1101,2101,1102,2102,1122,2122".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="S".AND.SF4->F4_PISCOF$"4".AND.alltrim(SF4->F4_CF)$"1101,2101,1102,2102,1122,2122".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni	:=SD1->D1_CUSTO
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="N".AND.!SF4->F4_PISCOF$"4".AND.!alltrim(SF4->F4_CF)$"3101,3102,1403,2403,1401,2401".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->(D1_CUSTO-D1_VALIPI) 
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_ICM=="N".AND.!SF4->F4_PISCOF$"4".AND.alltrim(SF4->F4_CF)$"1403,2403,1401,2401".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO  

ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_ICM=="S".AND.!SF4->F4_PISCOF$"4".AND.alltrim(SF4->F4_CF)$"1403,2403".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->(D1_CUSTO+D1_VALICM)
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $ "1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_PISCOF$"4".AND.!alltrim(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->(D1_CUSTO-D1_VALIPI)
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="S".AND.!SF4->F4_PISCOF$"4".AND.!alltrim(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="S".AND.SF4->F4_PISCOF$"4".AND.!alltrim(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->(D1_CUSTO-D1_VALIPI)
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="S".AND.!SF4->F4_PISCOF$"4".AND.ALLTRIM(SF4->F4_CF)$"3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="S".AND.!SF4->F4_PISCOF$"4".AND.ALLTRIM(SF4->F4_CF)$"3101".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO   
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="S".AND.!SF4->F4_PISCOF$"4".AND.ALLTRIM(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO 
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="S".AND.SF4->F4_CREDICM=="S".AND.!SF4->F4_PISCOF$"1,2,3".AND.ALLTRIM(SF4->F4_CF)$"3101,3102".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO  	
	
		//ALTERADO 17042011
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="S".AND.!SF4->F4_PISCOF$"4".AND.ALLTRIM(SF4->F4_CF)$"1551,2551".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO 
	
ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CREDIPI=="N".AND.SF4->F4_CREDICM=="N".AND.SF4->F4_IPI=="S".AND.SF4->F4_PISCOF$"4".AND.ALLTRIM(SF4->F4_CF)$"1551,2551".AND.!SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO
//OPERAÇÃO COM ST - TES 275,164,245,198,140,113,187

ELSEIF SF1->F1_TIPO $"N,C,B".AND.SD1->D1_CLASCON $"1,2,3,4".AND.SD1->D1_CLASCON<>"5".AND.SF4->F4_CODIGO$"275,164,245,198,140,113,187"
	vRetni:=SD1->D1_CUSTO // +SD1->D1_ICMSRET 
		
Endif
RestArea( aArea )
Return(vRetni)

User Function LP_VrVfor()
Local aArea	:= GetArea()
Private vRetfo	:= 0

If SF4->F4_CREDICM=="S".AND.SD1->D1_TIPO$"N,C,B".AND.SD1->D1_CLASCON<>"5".and.!SF4->F4_CODIGO$"455,456"
	vRetfo:=SD1->(+D1_CUSTO+D1_VALICM+D1_VALIMP5+D1_VALIMP6)-SF1->(F1_INSS+F1_ISS+F1_IRRF)
	
ELSEIF SF4->F4_CREDICM=="N".AND.SD1->D1_TIPO$"N,C,B".AND.SD1->D1_CLASCON<>"5".and.!SF4->F4_CODIGO$"455,456"
	vRetfo:=SD1->(+D1_CUSTO+D1_VALIMP5+D1_VALIMP6)-SF1->(+F1_INSS+F1_ISS+F1_IRRF+F1_VALCOFI+F1_VALPIS+F1_VALCSLL)
	
ELSEIF SF4->F4_CODIGO$"455,456"
	vRetfo:=SD1->D1_TOTAL-SD1->D1_VALISS
	
Endif
RestArea( aArea )
Return(vRetfo)

//Regra para atender Devolução  de Compras, na rotina do faturamento
User Function LP_Devcomp()
Local aArea	:= GetArea()
Private cRetdev	:= ""
DbSelectArea("SB1")
SB1->(dbsetorder(1))
DbSelectArea("SBM")
SBM->(dbsetorder(1))//BM_FILIAL+BM_GRUPO

If  SD2->D2_TIPO=="D" .AND. SD2->D2_GRUPO<>" "
	cRetdev :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_EST"))
	
ElseiF  SD2->D2_TIPO=="D" .AND.SD2->D2_GRUPO<>" "
	cRetdev :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_REV"))
	
Elseif  SD2->D2_TIPO=="D" .AND.SD2->D2_GRUPO<>" "
	cRetdev :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_DADM"))
	
Elseif SD2->D2_TIPO=="D" .AND.SD2->D2_GRUPO<>" "
	cRetdev :=alltrim(Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_INVEST"))
	
Elseif SD2->D2_TIPO=="D" .AND.SD2->D2_GRUPO<>" "
	cRetdev :=alltrim(SF4->F4_CONTA)
	
Elseif SD2->D2_TIPO=="D".AND.SD2->D2_GRUPO==" "
	cRet :="1104010004" // Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 8101010001 
	
Else
	cRetdev :=""
	
Endif
RestArea( aArea )
Return(cRetdev)

//Regra contábil, para atender a contabilização do caixinha
User Function LP_cx()
Local cRetcx	:= ""
Local aArea	:= GetArea()

DbSelectArea("SEU")
SEU->(dbsetorder(6))//EU_FILIAL+EU_CAIXA+EU_TIPO+EU_NROADIA+EU_NUM
DbSelectArea("SED")
SED->(dbsetorder(1))//ED_FILIAL+ED_CODIGO

If     SEU->EU_TIPO $ "00,01,02,10,11"
	cRetcx :=Posicione("SED",1,xFilial("SED")+SEU->EU_NATUREZ,"ED_CONTA")
	
Endif

RestArea( aArea )
Return(cRetcx)

//Regra para atender a baixa contas a pagar - TAIFF(ambiente de produção).
/*
2201	PRO-LABORE
2202	ORDENADOS E SALARIOS
2203	ADIANTAMENTO A FUNCIONARIOS
2205	FERIAS E ABONOS
2206	RESCISOES TRABALHISTAS
2203    ASSISTENCIA MEDICA
IRF	IMPOSTO RENDA RETIDO NA FONTE
ISS	IMPOSTO SOBRE SERVICOS
MOTIVOS DE BAIXA:
NOR(NORMAL);DAC(DAÇÃO); DEV(DEVOLUÇÃO); DEB(DEBITO C/C); VEN(VENDOR); FAT(FATURAS); LIQ(LIQUIDAÇÃO); LOJ(OUTRA LOJA);
PRD(PERDA FINA); DNI(DEPOSITO NÃO IDENTIFICADO); SRV(SERVIÇOS); ATC(ANTECIPADO).
*/
User Function LP_cpbx()
Local _cNatuImpo := AllTrim(GetMv("MV_PISNAT"))+","+AllTrim(GetMv("MV_COFINS"))+","+AllTrim(GetMv("MV_CSLL"))
Local _cContEnco := ""

If AllTrim(SE2->E2_tipo) == "PA"
	_cContEnco := SA6->A6_CONTA
Else
	Do Case
		Case AllTrim(SE2->E2_NATUREZ)$_cNatuImpo
			_cContEnco := "213001020004"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_INSS"))
			_cContEnco := "2103050001"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_ISS"))
			_cContEnco := "2104030005"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_IRF"))
			_cContEnco := "2104010002"
		Case AllTrim(SE2->E2_NATUREZ)$"2201"
			_cContEnco := "2103040001"
		Case AllTrim(SE2->E2_NATUREZ)$"2202"
			_cContEnco := "2103010001"
		Case AllTrim(SE2->E2_NATUREZ)$"2203"
			_cContEnco := "1103010001"
		Case AllTrim(SE2->E2_NATUREZ)$"2205"
			_cContEnco := "2103010002"
		Case AllTrim(SE2->E2_NATUREZ)$"2206"
			_cContEnco := "2103010003"
		Case AllTrim(SE2->E2_NATUREZ)$"2203".AND.ALLTRIM(SE5->E5_MOTBX)$"NDF"    //ALTERADO 17042011
			_cContEnco := "6301020001" // Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 3202010006

		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,DNI"    
			_cContEnco :=ALLTRIM(SED->ED_CONTA)
			
		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.ALLTRIM(SE5->E5_MOTBX)$"PRD,PED"    
			_cContEnco := "6402010009"// Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 3205010001
			
		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.!ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,DAC"    
			_cContEnco :=ALLTRIM(SA2->A2_CONTA)
			EndCase
EndIf
Return(_cContEnco)
//Regra para atender a INCLUSÃO contas a pagar - AMBIENTE TAIFF(PRODUÇÃO) - MANUAL ///ALTERADO 17042011
/*
2902	DEVOLUÇÃO DE VENDA
1105	RECEBIMENTO ANTECIPADO
2519	DESCONTO POR PREÇO INCORRETO
2523	MULTA NIVEL DE SERV.ATRASO ENTREGA
2524	TAXA DESCARREGAMENTO(CHAPA)
2620    PERDAS POR SINISTRO
2612    DESCONTOS CONCEDIDOS
2623    JUROS POR ANTECIPAÇÃO DE RECEBIVEIS
2625    EXTRAVIO DE MERCADORIA TRANSPORTADAS
2805    REMESSA PARA CONSERTO
2902    DEVOLUÇÃO DE VENDAS
NCCPD   PAGAMENTOS EM DUPLICIDADES
NCCPI   PAGAMENTO INDEVIDO
NCCVC   ABATIMENTO DE VERBAS COMERCIAIS
NCCVP   ABATIMENTO DE VERBAS PROMORCIONAIS
*/
User Function LP_InCP()
Local aArea	:= GetArea()
Private cReIcp:= ""

If AllTrim(SE2->E2_NATUREZ)$"2902,2519,2523,2524,2620,2612,2623,2625,2805,2902,NCCPD,NCCPI,NCCVC,NCCVP".AND.SE2->E2_TIPO=="NCC"
	cReIcp:=ALLTRIM(SED->ED_CONTA)
	
Else
	cReIcp:=ALLTRIM(SED->ED_CONTA)
	
Endif

RestArea( aArea )
Return(cReIcp)

//Regra para atender a baixa contas a pagar - TAIFF(ambiente RISCO).
/*
2201	PRO-LABORE
2202	ORDENADOS E SALARIOS
2203	ADIANTAMENTO A FUNCIONARIOS
2205	FERIAS E ABONOS
2206	RESCISOES TRABALHISTAS
2203    ASSISTENCIA MEDICA
IRF	IMPOSTO RENDA RETIDO NA FONTE
ISS	IMPOSTO SOBRE SERVICOS
MOTIVOS DE BAIXA:
NOR(NORMAL);DAC(DAÇÃO); DEV(DEVOLUÇÃO); DEB(DEBITO C/C); VEN(VENDOR); FAT(FATURAS); LIQ(LIQUIDAÇÃO); LOJ(OUTRA LOJA);
PRD(PERDA FINA); DNI(DEPOSITO NÃO IDENTIFICADO); SRV(SERVIÇOS); ATC(ANTECIPADO).
*/
User Function LP_RIcpbx()
Local _cNatuImpo := AllTrim(GetMv("MV_PISNAT"))+","+AllTrim(GetMv("MV_COFINS"))+","+AllTrim(GetMv("MV_CSLL"))
Local _cContEnco := ""

If AllTrim(SE2->E2_tipo) == "PA"
	_cContEnco := SA6->A6_CONTA
Else
	Do Case
		Case AllTrim(SE2->E2_NATUREZ)$_cNatuImpo
			_cContEnco := "213001020004"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_INSS"))
			_cContEnco := "2103050001"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_ISS"))
			_cContEnco := "2104030005"
		Case AllTrim(SE2->E2_NATUREZ)$AllTrim(GetMv("MV_IRF"))
			_cContEnco := "2104010002"
		Case AllTrim(SE2->E2_NATUREZ)$"2201"
			_cContEnco := "2103040001"
		Case AllTrim(SE2->E2_NATUREZ)$"2202"
			_cContEnco := "2103010001"
		Case AllTrim(SE2->E2_NATUREZ)$"2203"
			_cContEnco := "1103010001"
		Case AllTrim(SE2->E2_NATUREZ)$"2205"
			_cContEnco := "2103010002"
		Case AllTrim(SE2->E2_NATUREZ)$"2206"
			_cContEnco := "2103010003"
		Case AllTrim(SE2->E2_NATUREZ)$"2203".AND.ALLTRIM(SE5->E5_MOTBX)$"NDF"    //ALTERADO 17042011
			_cContEnco := "6301020001" // Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 3202010006
		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,DNI"    
			_cContEnco :=ALLTRIM(SED->ED_GOCONTA) 
			
		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.ALLTRIM(SE5->E5_MOTBX)$"PRD,PED"    
			_cContEnco := "6402010009" // Alteracao TOTVS - Karlla Honorio | Projeto: Novo Plano de Contas - CONTA ANTIGA: 3205010001   
			
		Case !AllTrim(SE2->E2_NATUREZ)$"2201,2202,2203,2205,2206,2203".AND.!ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,DAC"   
			_cContEnco :=ALLTRIM(SA2->A2_CONTA)
		
	EndCase
EndIf
Return(_cContEnco)

//REGRA PARA ATENDER A INCLUSÃO DO CONTAS A PAGAR - AMBIENTE TAIFF(RISCO).
User Function LP_RInCP()
Local aArea	:= GetArea()
Private cReRIcp:= 0

If AllTrim(SE2->E2_NATUREZ)$"2902,2519,2523,2524,2620,2612,2623,2625,2805,2902,NCCPD,NCCPI,NCCVC,NCCVP".AND.SE2->E2_TIPO=="NCC"
	cReRIcp:=ALLTRIM(SED->ED_GOCONTA)
	
Else
	cReRIcp:=ALLTRIM(SED->ED_GOCONTA)
	
Endif

RestArea( aArea )
Return(cReRIcp)

//REGRA PARA BAIXA DO RECEBIMENTO - AMBIENTE TAIFF(RISCO)
User Function LP_RECRBX()
Local aArea	:= GetArea()
Private cReCR:= ""

If ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,SRV,DAC"
	cReCR:=ALLTRIM(SED->ED_GOCONTA)
	
ElseIf !ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,SRV,DAC"
	cRecbto:=ALLTRIM(SA6->A6_CONTA)
	
Endif

RestArea( aArea )
Return(cReCR)

//REGRA PARA BAIXA DO RECEBIMENTO - AMBIENTE TAIFF(PRODUÇÃO)
User Function LP_PROrec()
Local aArea	:= GetArea()
Private cRecbto:= ""

If ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,SRV,DAC"
	cRecbto:=ALLTRIM(SED->ED_CONTA)
	
ElseIf !ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,PRD,PED,DNI,SRV,DAC"
	cRecbto:=ALLTRIM(SA6->A6_CONTA)
	
Endif

RestArea( aArea )
Return(cRecbto)

//Regra contábil, para atender a contabilização da requisição
/*
User Function LP_req()
Local aArea	:= GetArea()
Private cRetreq	:= ""

DbSelectArea("SBM")
SBM->(dbsetorder(1))//BM_FILIAL+BM_GRUPO
DbSelectArea("SD3")
SD3->(dbsetorder(3))//D3_FILIAL+D3_COD+D3_LOCAL+D3_NUMSEQ+D3_CF

IF SD3->D3_CLASREQ=="1".AND. SD3->D3_TM $ "501,502"
cRetreq :=Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")

ELSEIF SD3->D3_CLASREQ=="3".AND. SD3->D3_TM $ "501,502"
cRetreq :=Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")

ELSEIF SD3->D3_CLASREQ=="2".AND. SD3->D3_TM $ "501,502"
cRetreq :=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")
Else
cRetreq :=" "

Endif

RestArea( aArea )
Return(cRetreq)*/

//Regra Contábil para atender devolucao de req
/*
User Function LP_reqdev()
Local aArea	:= GetArea()
Private cRetdev	:= ""

DbSelectArea("SBM")
SBM->(dbsetorder(1))//BM_FILIAL+BM_GRUPO
DbSelectArea("SD3")
SD3->(dbsetorder(5))//D3_FILIAL+D3_TM+D3_COD

IF SD3->D3_CLASREQ=="1".AND. SD3->D3_TM $ "001,002"
cRetdev :=Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")

ELSEIF SD3->D3_CLASREQ=="3".AND. SD3->D3_TM $ "001,002"
cRetdev :=Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")

ELSEIF SD3->D3_CLASREQ=="2".AND. SD3->D3_TM $ "001,002"
cRetdev :=	Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"")
Else
cRetdev :=" "

Endif

RestArea( aArea )
Return(cRetdev)

//Regra contábil para atender Ativo Fixo(depreciação)
User Function LP_atf()
Local cRetatf	:= ""
Local aArea	:= GetArea()

SN1->( dbSetOrder( 1 ) ) //N1_FILIAL+N1_CBASE+N1_ITEM
SNG->( dbSetOrder( 1 ) ) //NG_FILIAL+NG_GRUPO

If SN1->( dbSeek( SN3->( N3_FILIAL + N3_CBASE + N3_ITEM)  ) )
If SNG->( dbSeek( xFilial('SNG') + SN1->N1_GRUPO ) )
cRetatf := SNG->NG_CONCUST
EndIf
EndIf

RestArea( aArea )
Return(cRetatf)  */

//Regra para atender a integração contábil da folha de pagamento

/*
User Function Lp_Folp()
Local aArea	:= GetArea()
Private cRetfol	:= ""

DbSelectArea("SRA")
SRA->(dbsetorder(1))
IF (SRA->(DBSEEK(XFILIAL('SRA')+SRZ->RZ_MAT)))

// Custo Direto:
If SRA->RA_CLASGPE=="1" .and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")
// Custo Indireto:
ElseIF SRA->RA_CLASGPE=="2".and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")
//Comercial:
ElseIF SRA->RA_CLASGPE=="3".and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")
//Adm
ElseIF SRA->RA_CLASGPE=="4".and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")

ElseIF SRA->RA_CLASGPE $"1,2,3,4" .and. SRZ->RZ_PD=="799"
cRetfol :="210301116"

//Para atender a regra de contabilidade - Pro Labore
//custo direto.

/*
ElseIF SRA->RA_CLASGPE=="1" .and. SRA->RA_CATFUNC=="P" .and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")

ElseIF SRA->RA_CLASGPE=="2" .and. SRA->RA_CATFUNC=="P" .and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")

ElseIF SRA->RA_CLASGPE=="3" .and. SRA->RA_CATFUNC=="P".and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")

ElseIF SRA->RA_CLASGPE=="4" .and. SRA->RA_CATFUNC=="P" .and. SRZ->RZ_PD<>"799"
cRetfol :=Posicione("SRV",1,xFilial("SRV")+SRZ->RZ_PD,"")

ElseIF SRA->RA_CLASGPE=="1" .and. SRA->RA_CATFUNC=="P" .and. SRZ->RZ_PD=="799"
cRetfol :="210301106"

ElseIF SRA->RA_CLASGPE=="2" .and. SRA->RA_CATFUNC=="P".and. SRZ->RZ_PD=="799"
cRetfol :=""
ElseIF SRA->RA_CLASGPE=="3" .and. SRA->RA_CATFUNC=="P".and. SRZ->RZ_PD=="799"
cRetfol :=""

ElseIF SRA->RA_CLASGPE=="4" .and. SRA->RA_CATFUNC=="P".and. SRZ->RZ_PD=="799"
cRetfol :=""

Else
cRetfol:=""
Endif
Endif
RestArea( aArea )
Return(cRetfol) */

//Regra para atender a descrição do historico contábil
User Function LP_Hist()
Private cRethis	:= ""

DbSelectArea("SD1")
SD1->(dbsetorder(1))
DbSelectArea("SB1")
SB1->(dbsetorder(1))
DbSelectArea("SBM")
SBM->(dbsetorder(1))
DbSelectArea("SF1")
SF1->(dbsetorder(1))
DbSelectArea("SA2")
SA2->(dbsetorder(1))

If SD1->D1_TOTAL > 0 .and. SD1->D1_TIPO=="N"
	cRethis :="Doc-Nr-"+substr(SF1->F1_DOC,1,9)+"-"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_NREDUZ");
	+SF1->F1_FORNECE
Elseif SD1->D1_TOTAL > 0 .and. SD1->D1_TIPO=="C"
	cRethis :="Compl.(ICMS/IPI/Frete)-Doc-Nr-"+substr(SF1->F1_DOC,1,9)+"-"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_NREDUZ");
	+SF1->F1_FORNECE
Elseif SD1->D1_TOTAL > 0 .and. SD1->D1_TIPO=="B"
	cRethis :="Benef.-Nr-"+substr(SF1->F1_DOC,1,9)+"-"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_NREDUZ");
	+SF1->F1_FORNECE
Elseif SD1->D1_TOTAL > 0 .and. SD1->D1_TIPO=="D"
	cRethis :="Dev.Vendas-Nr-"+substr(SF1->F1_DOC,1,9)+"-"+Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE,"A2_NREDUZ");
	+SF1->F1_FORNECE
Else
	cRethis :=" "
Endif
Return(cRethis)

//Regra para atender o faturamento
User Function LP_vendas()//ALTERADO 19-10-10
Private cRetvev	:= 0

//NF -  SAIDA - ITEM - SEQ.001
IF ALLTRIM(SD2->D2_TIPO)=="N".AND.SF2->F2_VALFAT==0.AND.SF4->F4_CODIGO<>""
	NRetvev :=(SD2->D2_TOTAL-SD2->D2_VALINS-SD2->D2_VALISS,SF2->F2_VALFAT)
	
ElseIf ALLTRIM(SD2->D2_TIPO)=="N" .AND.SF4->F4_CODIGO=="".AND.SF4->F4_.AND.SF2->F2_VALFAT==0
	NRetvev :=0
	
	//NF - SAIDA - ICMS - SEQ.002
ElseIf ALLTRIM(SD2->D2_TIPO)=="N".AND.SD2->D2_VALICM<>0
	NRetvev :=SD2->D2_VALICM
	
	//NF -  SAIDA - PIS NAO CUMULATIVO - SEQ.003
	//NF -  SAIDA - PIS (CUMULATIVO - SEQ.004
	//NF -  SAIDA - COFINS NAO CUMULATIVO - SEQ.005
	//NF -  SAIDA - COFINS (CUMULATIVO) - SEQ.006
	//NF -  SAIDA - ISS - SEQ.007
	//NF - SAIDA - DEVOLUCAO DE COMPRAS - SEQ.008
	//NF - SAIDA - DEVOLUCAO DE COMPRAS- ICMS - SEQ.009
	//NF - SAIDA - DEVOLUCAO DE COMPRAS - IPI - SEQ.010
	//NF - SAIDA - IPI - SEQ.011
Endif
Return(cRetvev)

//------------------------------------------------------------------------------------------------------------------------------
// Lançamento padrão - LP520
// Solicitante: Waldir - ADVISE
// Data: sex 05/12/2014 10:00
//------------------------------------------------------------------------------------------------------------------------------
User Function LP520()
Local cRetorno 
cRetorno := IIF(ALLTRIM(SE5->E5_MOTBX)=="DFI".AND.ALLTRIM(SE5->E5_TIPO)$"NCC/RA","2106030001",IIF(ALLTRIM(SE5->E5_MOTBX)=="DNI","1102090001", IIF(ALLTRIM(SE5->E5_MOTBX)=="DFI","6402010006",IIF(ALLTRIM(SE5->E5_TIPO)=="RA",SED->ED_CONTA,IIF(SE5->E5_TIPO=="NCC","2106030001",IIF(SE5->E5_MOTBX=="ASD","1103030017",IIF(ALLTRIM(SE5->E5_MOTBX)$"FOL","2106020007",IIF(ALLTRIM(SE5->E5_MOTBX)$"DEV,VEN,SRV",SED->ED_CREDIT,IIF(ALLTRIM(SE5->E5_MOTBX)$"PRD,PED,DAC","6402010009",SA6->A6_CONTA)))))))))
Return (cRetorno) 


//------------------------------------------------------------------------------------------------------------------------------
// Lançamento padrão - LP530010
// Solicitante: Waldir - ADVISE
// Data: qua 07/01/2015 15:49
// Revisão: 20/02/2015 14:00
// Revisão: 16/07/2015 11:00 Ampliado o numero de elementos referentes à natureza - E5_NATUREZ
//------------------------------------------------------------------------------------------------------------------------------
User Function LP530010()
Local cRetorno 
cRetorno := IF(ALLTRIM(SE5->E5_MOTBX)=="DFI".AND.ALLTRIM(SE5->E5_TIPO) $ ("NCC/RA"),"2106030001",IF(ALLTRIM(SE5->E5_NATUREZ) $ "2310/2311/2318/2319/2320/2321/2322/2323/2324/2325/2326/2327/2328/2330/2331/2333/2334/2336/2337/2338/2339/2341/2342/2351",SED->ED_CONTA,IF(ALLTRIM(SE5->E5_MOTBX)=="IND","6305060007",IF(ALLTRIM(SE5->E5_MOTBX)=="DEV",SA6->A6_CONTA,IF(ALLTRIM(SE5->E5_PREFIXO) $ "GPE",SED->ED_CONTA,IIF(ALLTRIM(SE5->E5_TIPO) $ "TX1|COF|CSL|DAR|TX|ICM|INS|IR-|IRF|IS-|ISS|PIS|DA|PF|TX2",SED->ED_CONTA,IIF(SE5->E5_MOTBX $"FOL","2103010001",IIF(ALLTRIM(SE5->E5_TIPO)=="PA",SA6->A6_CONTA,SA2->A2_CONTA))))))))
Return (cRetorno)

User Function LP520CRE()
Local cRetorno 
cRetorno := IF(ALLTRIM(SE5->E5_MOTBX)=="DFI".AND.ALLTRIM(SE5->E5_TIPO) $ ("NCC/RA"),"6401010005",IF(ALLTRIM(SE5->E5_MOTBX)=="DFI",SA1->A1_CONTA,IF(ALLTRIM(SE5->E5_TIPO) $ "RA/NCC",SA6->A6_CONTA,IF(ALLTRIM(SE5->E5_TIPO)=="PRD","6105010002",IIF(ALLTRIM(SE5->E5_MOTBX)=="ASD","1102010001",IIF(EMPTY(SA1->A1_CONTA), "1102010001",SA1->A1_CONTA))))))                                                                                                                                                                        
Return (cRetorno)

User Function LP650001()
Local cRetorno 
cRetorno := IIF(ALLTRIM(SD1->D1_CLASCON) $ "3/5".AND.ALLTRIM(SD1->D1_CF)$"1949/2949".AND. POSICIONE("SF4",1, XFILIAL("SF4")+SD1->D1_TES,"F4_DUPLIC")=="S".AND.SD1->D1_TES <>"487",SD1->(D1_TOTAL+D1_VALIPI+D1_VALFRE+D1_DESPESA+D1_ICMSRET+D1_VALCMAJ-D1_VALDESC),IIF( SD1->D1_TES$"051/077/078".OR.SUBSTR(SD1->D1_CLASFIS,1,1)$"1|6",0,IIF(ALLTRIM(SD1->D1_CLASCON)="5".OR.SF1->F1_TIPO$"D/B/I/P".OR.substr(SD1->D1_CF,2,3)$"902/920/949/920/921/908/949/915/916/911/925/409/152/252/151/251/157/257",0,IIF(!alltrim(SD1->D1_CF)$"3101/3102",SD1->(D1_TOTAL+IIF(SF4->F4_IPI="R",0,D1_VALIPI)+D1_VALFRE+D1_DESPESA+D1_ICMSRET+D1_VALCMAJ-D1_VALDESC)-IIF(ALLTRIM(SD1->D1_CLASCON)<>"3",IIF(SF4->F4_CREDICM=="S",SD1->D1_VALICM,0)+IIF(SF4->F4_PISCOF$"1,2,3",SD1->(D1_VALIMP6+D1_VALIMP5-D1_VALCMAJ),0)+IIF(SF4->F4_CREDIPI=="S",SD1->D1_VALIPI,0),0)-IIF(alltrim(SD1->D1_CF)$"3101",SD1->D1_VALIPI,0),SD1->D1_CUSTO))))                                                                                                                                                                         
Return (cRetorno)

User Function LP65002CRE()
Local cRetorno 
cRetorno := IIF(ALLTRIM(SD1->D1_CLASCON) $ "3/5".AND.ALLTRIM(SD1->D1_CF)$"1949/2949".AND.ALLTRIM(SD1->D1_TIPO)=="D","6202010001",IIF(ALLTRIM(SD1->D1_CF) $ ("1910/2910"),"6201010006",IIF(ALLTRIM(SD1->D1_CLASCON) $"1,2,3,4,5".and.ALLTRIM(SF1->F1_TIPO)$"N,C,B".and.SF1->F1_SERIE<>"TX",ALLTRIM(SA2->A2_CONTA),IIf(SD1->D1_CLASCON $"1,2,3,4,5".and.SF1->F1_TIPO$"N,C,B".and.SF1->F1_SERIE=="TX",SED->ED_CONTA,""))))                                                                                                                                                                          
Return (cRetorno)


User Function LP650002()
Local cRetorno 
cRetorno := IIF(ALLTRIM(SD1->D1_CLASCON) $ "3/5".AND.ALLTRIM(SD1->D1_CF)$"1949/2949".AND. POSICIONE("SF4",1, XFILIAL("SF4")+SD1->D1_TES,"F4_DUPLIC")=="S".AND.SD1->D1_TES <>"487",SD1->(D1_TOTAL+D1_VALIPI+D1_VALFRE+D1_DESPESA+D1_ICMSRET+D1_VALCMAJ-D1_VALDESC),IF(SD1->D1_TES =="051",0,If(!SF4->F4_CODIGO$"275,164,245,198,140,113,187".AND.SF4->F4_CREDICM=="S".AND.SF4->F4_ICM=="N".AND.SF4->F4_IPI="N".AND.SF4->F4_CREDIPI=="S".AND.SD1->D1_TIPO$"N,C,B".AND.SD1->D1_CLASCON<>"5",SD1->(+D1_CUSTO+D1_VALICM+D1_VALIPI+D1_VALIMP5+D1_VALIMP6+D1_VALIPI)+SF1->(F1_INSS+F1_ISS+F1_IRRF),0)))
Return (cRetorno)

User Function LP610ASTEC(cTipoCta)
Local cRetorno := "" 
If Alltrim(cTipoCta) = "C"
	cRetorno := IF((SM0->M0_CODIGO=="03".AND.SM0->M0_CODFIL=="01".AND.ALLTRIM(SD2->D2_SERIE)=="3"),"6101010006",IF(ALLTRIM(SA1->A1_INTER)=="S".AND.SB1->B1_CODFAM $ ("000/001/402/403/460/461/462/463/465/466/502/600/609/612/515/613/619/622/623"),"6101010005",IF(ALLTRIM(SA1->A1_INTER)=="S".AND.SB1->B1_CODFAM $ ("000/001"),"6101010004",SF4->F4_CONTA)))
EndIf
 
Return (cRetorno)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 001  -  Execblock para Conta Debito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640001D()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6102010001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6102010003"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6102010002"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 002  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640002C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6103010001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6103010011"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6103010006"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 004  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640004C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6103010003"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6103010012"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6103010008"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 005  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640005C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6103010004"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6103010013"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6103010009"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 006  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640006C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6103010005"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6103010014"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6103010010"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lançamento padrão  -  640 Sequencia 007  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640007C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "2106030001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "2106030003"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "2106030002"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 008  -  Execblock para Conta Debito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640008D()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6102010001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6102010003"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6102010002"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 009  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640009C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6104010001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6104010013"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6104010008"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 011  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640011C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6104010003"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6104010014"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6104010010"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 012  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640012C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6104010004"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6104010015"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6104010011"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 013  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640013C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6104010005"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6104010016"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6104010012"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 014  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640014C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "1102010001"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "1102010003"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "1102010002"
		ElseIf Alltrim(WXARK->A1EST) == "EX"
			cRet := "1102020001"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)



//---------------------------------------------------------------------------------------
// Lancamento padrao  -  640 Sequencia 020  -  Execblock para Conta Credito
// Autor: Ronald Piscioneri
// Data:  21-Maio-2021
// Obs.:  Este execBlock foi criado, porque o sistema padrao nao posiciona na tabela SD2
//---------------------------------------------------------------------------------------
User Function L640020C()
Local cQry := ""
Local cRet := "NAO CLASSIFICADO"

If ( !Empty(SD1->D1_NFORI) .And. !Empty(SD1->D1_SERIORI) .And. !Empty(SD1->D1_ITEMORI) )

	cQry := "SELECT DISTINCT "
	cQry += "D2.D2_SERIE AS D2SERIE, "
	cQry += "A1.A1_EST AS A1EST, "
	cQry += "A1.A1_INTER AS A1INTER "
	cQry += "FROM " 
	cQry += RetSqlName("SD2")+ " D2, "
	cQry += RetSqlName("SA1")+ " A1 "
	cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
	cQry += "AND D2.D2_FILIAL = '" +Alltrim(SD1->D1_FILIAL)+ "' "
	cQry += "AND D2.D2_DOC = '" +Alltrim(SD1->D1_NFORI)+ "' "
	cQry += "AND D2.D2_SERIE = '" +Alltrim(SD1->D1_SERIORI)+ "' "
	cQry += "AND D2.D2_ITEM = '" +Alltrim(SD1->D1_ITEMORI)+ "' "
	cQry += "AND D2.D2_CLIENTE = '" +Alltrim(SD1->D1_FORNECE)+ "' "
	cQry += "AND D2.D2_LOJA = '" +Alltrim(SD1->D1_LOJA)+ "' "
	cQry += "AND A1.D_E_L_E_T_ = ' ' "
	cQry += "AND A1.A1_FILIAL = '" +xFilial("SA1")+ "' "
	cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
	cQry += "AND A1.A1_LOJA = D2.D2_LOJA "

	Iif(Select("WXARK")>0,WXARK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WXARK",.T.,.T.)
	WXARK->(dbGoTop())

	If WXARK->(!EoF())
	
		If ( Alltrim(WXARK->A1EST) <> "EX" .AND. Alltrim(WXARK->D2SERIE) <> "3" .AND. Alltrim(WXARK->A1INTER) <> "S" )
			cRet := "6104010005"
		ElseIf Alltrim(WXARK->D2SERIE) == "3"
			cRet := "6104010016"
		ElseIf Alltrim(WXARK->A1INTER) == "S"
			cRet := "6104010012"
		EndIf

	EndIf
	WXARK->(dbCloseArea())

EndIf

Return(cRet)


/*/ 
//Obs.: a funcao abaixo foi desenvolvida somente para testar os ExecBlocks que serao configurados 
//como lancamentos padronizados (Ronald Piscioneri, 24-Maio-2021)
User Function SIGACTB()
Local cRet := ""
dbSelectArea("SD1")
SD1->(dbGoTo(1306605))
cRet:=U_L640001D()
cRet:=U_L640002C()
cRet:=U_L640004C()
cRet:=U_L640005C()
cRet:=U_L640006C()
cRet:=U_L640007C()
cRet:=U_L640008D()
cRet:=U_L640009C()
cRet:=U_L640011C()
cRet:=U_L640012C()
cRet:=U_L640013C()
cRet:=U_L640014C()
cRet:=U_L640020C()
Return(Nil)
/*/
