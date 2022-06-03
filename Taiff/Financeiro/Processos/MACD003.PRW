#include "Protheus.ch"
#include "TOPCONN.CH"
#Include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MACD001   ³ Autor ³ Robson Sanchez        ³ Data ³ 15/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Estorno dos Titulos a Receber e Geracao de novos titulos   ³±±
±±³			 ³ porque na Taiff os titulos devem ser gerados apos a saida  ³±±
±±³			 ³ dos produtos da expedicao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Observa. ³ Carlos Alday Torres                    ³ Data ³ 02/06/2010 ³±±
±±³          ³ foram feitas correções e alterações no programa original   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MACD003( cIdEmpresa )
	//Local cPrefixo :=""
	//Local cNum     :=""
	//Local cTipTit  :=""
	//Local cNatureza:=""
	//Local cCli	   :=""
	//Local cLoja    :=""
	//Local n

	//-----------------------------------------------------------------------------------------------------//
	// funções que mudam o ambiente de empresa para 02 - mercabel                                          //
	//-----------------------------------------------------------------------------------------------------//
	RPCClearEnv()
	RPCSetType(3)
	RPCSetEnv( cIdEmpresa ,"01")


	//_nHdl     := fcreate("ML_ETQ4.TMP", 0)
	//_cDestino := "C:\EMBARQUE.TXT"

	cSqlE1 := "SELECT "
	cSqlE1 += "  E1_PREFIXO, E1_NUM,   E1_PARCELA, E1_TIPO,    E1_VENCTO, E1_VENCREA, "
	cSqlE1 += "  E1_DTEMBAR, E1_SERIE, F2_COND,    CB7_DTEMBA, E1_NATUREZ "
	cSqlE1 += "FROM "
	cSqlE1 += "  " + RetSQLName("SE1") + " SE1 JOIN " + RetSQLName("CB7") + " CB7 ON "
	cSqlE1 += "    SE1.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    SE1.E1_FILIAL = '" + xFilial('SE1') + "' AND "
	cSqlE1 += "    CB7.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND "
	cSqlE1 += "    SE1.E1_NUM    = CB7.CB7_NOTA AND "
	cSqlE1 += "    SE1.E1_SERIE  = CB7.CB7_SERIE "
	cSqlE1 += "  JOIN " + RetSQLName("SF2") + " SF2 ON "
	cSqlE1 += "    SF2.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "
	cSqlE1 += "    SF2.F2_DOC   = SE1.E1_NUM AND "
	cSqlE1 += "    SF2.F2_SERIE = SE1.E1_SERIE "
	cSqlE1 += "WHERE "
	cSqlE1 += "  CB7.CB7_STATUS = '9' "
	cSqlE1 += "  AND CB7.CB7_DTEMBA <> '' "
	cSqlE1 += "  AND SE1.E1_DTEMBAR = '" + Space(TamSx3("E1_DTEMBAR")[1]) + "' "
	cSqlE1 += "  AND SE1.E1_TIPO    =  'NF ' "
	cSqlE1 += "  AND SE1.E1_PREFIXO    !=  '001'  "
	cSqlE1 += "  AND NOT EXISTS "
	cSqlE1 += "  ( "
	cSqlE1 += "     SELECT 'X' "
	cSqlE1 += "     FROM " + RetSQLName("SE1") + " SE1X "
	cSqlE1 += "     WHERE "
	cSqlE1 += "       D_E_L_E_T_ = ' ' "
	cSqlE1 += "       AND E1_FILIAL  = '" + xFilial("SE1") + "' "
	cSqlE1 += "       AND SE1X.E1_PREFIXO = SE1.E1_PREFIXO "
	cSqlE1 += "       AND SE1X.E1_NUM     = SE1.E1_NUM "
	cSqlE1 += "       AND SE1X.E1_TIPO    = SE1.E1_TIPO "
	cSqlE1 += "       AND (E1_NUMBOR  <> '" + Space(TamSx3("E1_NUMBOR")[1]) + "' "
	cSqlE1 += "       OR E1_BAIXA   <> '" + Space(TamSx3("E1_BAIXA")[1]) + "' "
	cSqlE1 += "       OR E1_PORTADO <> '" + Space(TamSx3("E1_PORTADO")[1]) + "') "
	cSqlE1 += "  ) "
	// (a) O select foi classificado para que no LOOP totalize pelo numero da nota
	cSqlE1 +="ORDER BY "
	cSqlE1 +="  SE1.E1_NUM, SE1.E1_SERIE, SE1.E1_TIPO, SE1.E1_PARCELA "

	If Select("SQLE1") # 0
		SQLE1->(DbCloseArea())
	EndIf

	TcQuery cSqlE1 New Alias "SQLE1"
	TcSetField("SQLE1", "CB7_DTEMBA", "D")

	//_sComando := "Log de alteração de TITULOS COM DT EMBARQUE" + CHR(13) + CHR(10)
	//fwrite (_nHdl, _sComando)

	U_MACD005()

	//fclose (_nHdl)
	//copy file ML_ETQ4.TMP to (alltrim (_cDestino))
	//delete file ML_ETQ4.TMP

	RPCClearEnv()
	RPCSetType(3)
	RPCSetEnv("01","01")

Return


//************************************************************************************************************
//*                                                                                                          *
//*  Atualiza prorrogacao de vencimentos.                                                                    *
//*                                                                                                          *
//************************************************************************************************************
User Function MACD005() // (c)
	//Local aTitulos  := {}
	Local aFin040   := {}
	Local cNumTit   := ""
	//Local cErroAuto := ""
	Local nNumPar   := 0
	Local aPgto     := {} // array dos vencimentos e valores das parcelas a serem geradas
	Local nPosNum   := 0
	Local nPosPre   := 0
	Local nPosPar   := 0
	Local nPosTip   := 0
	Local nErros    := 0
	Local i			:= 0

	Private lMsHelpAuto := .t.
	Private lMsErroAuto := .f.
	Private aTitulos    := {}

	While !SQLE1->(Eof())
		If cNumTit <> SQLE1->E1_NUM + SQLE1->E1_SERIE + SQLE1->E1_TIPO
			aPgto   := Condicao(10, SQLE1->F2_COND, , SQLE1->CB7_DTEMBA) // Total para o calculo, cod. cond.pgto,data base
			cNumTit := SQLE1->E1_NUM + SQLE1->E1_SERIE + SQLE1->E1_TIPO
			nNumPar := 0
		EndIf
		aAdd(aFin040, {})
		nNumPar++

		If Len(aPgto) == 0 .or. nNumPar > Len(aPgto)

			nNumPar := Len(aPgto)

		EndIf

		aAdd(aFin040[Len(aFIN040)], {"E1_PREFIXO", SQLE1->E1_PREFIXO , nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_NUM"    , SQLE1->E1_NUM     , nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_PARCELA", SQLE1->E1_PARCELA , nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_TIPO"   , SQLE1->E1_TIPO    , nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_VENCTO" , aPgto[nNumPar,1], nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_VENCREA", aPgto[nNumPar,1], nil})
		aAdd(aFin040[Len(aFIN040)], {"E1_DTEMBAR", SQLE1->CB7_DTEMBA, nil})
		SQLE1->(DbSkip())
	End

	For i := 1 To Len(aFin040)
		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.
		nPosPre := aScan(aFIN040[i], {|x| x[1] == "E1_PREFIXO"})
		nPosNum := aScan(aFIN040[i], {|x| x[1] == "E1_NUM"})
		nPosPar := aScan(aFIN040[i], {|x| x[1] == "E1_PARCELA"})
		nPosTip := aScan(aFIN040[i], {|x| x[1] == "E1_TIPO"})
		Begin Transaction
			MSExecAuto({|x,y| FINA040(x,y)}, aFIN040[i], 4)
			If lMsErroAuto
				nErros++
				//_sComando := "Titulo: " + aFIN040[i,nPosNum,2] + " Tipo: " + aFIN040[i,nPosTip,2] + " Prefixo: " + aFIN040[i,nPosPre,2] + " Parcela: " + aFIN040[i,nPosPar,2] + " Erro na alteração." + CHR(13) + CHR(10)
				//cErroAuto := MostraErro("C:\", "AltTitEmb.txt") + CHR(13) + CHR(10)
				//fwrite (_nHdl, _sComando + cErroAuto)
				DisarmTransaction()
			Else
				//_sComando := "Titulo: " + aFIN040[i,nPosNum,2] + " Tipo: " + aFIN040[i,nPosTip,2] + " Prefixo: " + aFIN040[i,nPosPre,2] + " Parcela: " + aFIN040[i,nPosPar,2] + " Alteração Ok." + CHR(13) + CHR(10)
				//fwrite (_nHdl, _sComando)
			Endif
		End Transaction
	Next
	If nErros > 0
		//fwrite (_nHdl, "Sem erros de alteração")
	Else
		//fwrite (_nHdl, AllTrim(Str(nErros)) + " erros de alteração")
	EndIf

Return .t.


/*
User Function MACD003M()
	Local cPrefixo :=""
	Local cNum     :=""
	Local cTipTit  :=""
	Local cNatureza:=""
	Local cCli	   :=""
	Local cLoja    :=""
	Local n
	_nHdl     := fcreate("ML_ETQ4.TMP", 0)
	_cDestino := "C:\EMBARQUE.TXT"
	              
	cSqlE1 := "SELECT "
	cSqlE1 += "  E1_PREFIXO, E1_NUM,   E1_PARCELA, E1_TIPO,    E1_VENCTO, E1_VENCREA, "
	cSqlE1 += "  E1_DTEMBAR, E1_SERIE, F2_COND,    CB7_DTEMBA, E1_NATUREZ "
	cSqlE1 += "FROM "
	cSqlE1 += "  " + RetSQLName("SE1") + " SE1 JOIN " + RetSQLName("CB7") + " CB7 ON "
	cSqlE1 += "    SE1.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    SE1.E1_FILIAL = '" + xFilial('SE1') + "' AND "
	cSqlE1 += "    CB7.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    CB7.CB7_FILIAL = '" + xFilial("CB7") + "' AND "
	cSqlE1 += "    SE1.E1_NUM    = CB7.CB7_NOTA AND "
	cSqlE1 += "    SE1.E1_SERIE  = CB7.CB7_SERIE "
	cSqlE1 += "  JOIN " + RetSQLName("SF2") + " SF2 ON "
	cSqlE1 += "    SF2.D_E_L_E_T_ = ' ' AND "
	cSqlE1 += "    SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "
	cSqlE1 += "    SF2.F2_DOC   = SE1.E1_NUM AND "
	cSqlE1 += "    SF2.F2_SERIE = SE1.E1_SERIE "
	cSqlE1 += "WHERE "
	cSqlE1 += "  CB7.CB7_STATUS = '9' "
	cSqlE1 += "  AND CB7.CB7_DTEMBA <> SE1.E1_EMISSAO "
	cSqlE1 += "  AND CB7.CB7_DTEMBA <> '' "
	cSqlE1 += "  AND SE1.E1_DTEMBAR = '" + Space(TamSx3("E1_DTEMBAR")[1]) + "' "
	cSqlE1 += "  AND SE1.E1_TIPO    =  'NF ' "
	cSqlE1 += "  AND NOT EXISTS "
	cSqlE1 += "  ( "
	cSqlE1 += "     SELECT 'X' "
	cSqlE1 += "     FROM " + RetSQLName("SE1") + " SE1X "
	cSqlE1 += "     WHERE "
	cSqlE1 += "       D_E_L_E_T_ = ' ' "
	cSqlE1 += "       AND E1_FILIAL  = '" + xFilial("SE1") + "' "
	cSqlE1 += "       AND SE1X.E1_PREFIXO = SE1.E1_PREFIXO "
	cSqlE1 += "       AND SE1X.E1_NUM     = SE1.E1_NUM "
	cSqlE1 += "       AND SE1X.E1_TIPO    = SE1.E1_TIPO "	
	cSqlE1 += "       AND (E1_NUMBOR  <> '" + Space(TamSx3("E1_NUMBOR")[1]) + "' "
	cSqlE1 += "       OR E1_BAIXA   <> '" + Space(TamSx3("E1_BAIXA")[1]) + "' "
	cSqlE1 += "       OR E1_PORTADO <> '" + Space(TamSx3("E1_PORTADO")[1]) + "') "
	cSqlE1 += "  ) "
	// (a) O select foi classificado para que no LOOP totalize pelo numero da nota
	cSqlE1 +="ORDER BY "
	cSqlE1 +="  SE1.E1_NUM, SE1.E1_SERIE, SE1.E1_TIPO, SE1.E1_PARCELA "
	
	If Select("SQLE1") # 0
		SQLE1->(DbCloseArea()) 
	EndIf
	
	TcQuery cSqlE1 New Alias "SQLE1" 
	TcSetField("SQLE1", "CB7_DTEMBA", "D")
	  
	_sComando := "Log de alteração de TITULOS COM DT EMBARQUE" + CHR(13) + CHR(10)
	fwrite (_nHdl, _sComando)
	
	U_MACD005()

	fclose (_nHdl)
	copy file ML_ETQ4.TMP to (alltrim (_cDestino))
	delete file ML_ETQ4.TMP

	RPCClearEnv()
	RPCSetType(3)
	RPCSetEnv("01","01")

Return
*/
