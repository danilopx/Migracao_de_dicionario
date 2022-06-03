// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ajustasdb.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 09/06/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ajustasdb
Processa a tabela SDB-Movimentos de Distribuicao.

@author    pbindo
@version   11.3.1.201605301307
@since     09/06/2016
/*/
//------------------------------------------------------------------------------------------
user function ajustasdb()

	LOCAL nX := 0

	cQuery := " SELECT" 
	cQuery += " ISNULL((SELECT SUM(BF_QUANT) FROM "+RetSqlName("SBF")+" with(nolock) WHERE BF_PRODUTO  = B2_COD  AND D_E_L_E_T_ <> '*' AND BF_FILIAL = B2_FILIAL AND BF_LOCAL = B2_LOCAL ),0)BF_QUANT,"
	cQuery += " * FROM "+RetSqlName("SB2")+" B2 with(nolock)"
	cQuery += " inner join "+RetSqlName("SB1")+" B1 with(nolock) ON B1_COD = B2_COD "+Iif(cEmpAnt # "01"," AND B1_FILIAL = B2_FILIAL","") 
	cQuery += " WHERE "
	cQuery += " B2.D_E_L_E_T_ <> '*'AND B1.D_E_L_E_T_ <> '*'"
	cQuery += " AND B1_LOCALIZ = 'S'"
	cQuery += " AND B2_QATU-B2_QACLASS  <> ISNULL((SELECT SUM(BF_QUANT) FROM "+RetSqlName("SBF")+" with(nolock) WHERE BF_PRODUTO  = B2_COD  AND D_E_L_E_T_ <> '*' AND BF_FILIAL = B2_FILIAL AND BF_LOCAL = B2_LOCAL ),0)"
	cQuery += " AND B2_FILIAL = '"+cFilAnt+"'"
	//	cQuery += " AND B2_COD = '600050056      '"

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBDB", .F., .T.)

	Count to nRec

	If nRec == 0
		MsgStop("NAO EXISTEM DADOS","AJUSTASDB")
		TRBDB->(dbCloseArea())
	EndIf

	dbSelectArea("TRBDB")
	dbGoTop()
	aCriaSDB := {}
	While !Eof()	
		nSaldoSDB  := 0
		dbSelectArea('SDB')

		CONOUT(' 1- Produto '+TRBDB->B2_COD+' Local '+TRBDB->B2_LOCAL)

		If TRBDB->B2_QATU > TRBDB->BF_QUANT //DEVOLVE SALDO
			nSaldoSDB := TRBDB->B2_QATU-TRBDB->BF_QUANT
		Else
			nSaldoSDB := TRBDB->BF_QUANT-TRBDB->B2_QATU
		EndIf

		dbSelectArea("SBF")
		dbSetOrder(2)
		If !dbSeek(xFilial()+TRBDB->B2_COD+TRBDB->B2_LOCAL)
			If TRBDB->B2_LOCAL == "31"
				cLocaliz := "TERC           "
			Else
				//CASO NAO ENCONTRA NAO FAZ NADA
				dbSelectArea("TRBDB")
				dbSkip()
				Loop
			EndIf
		Else
			While !Eof() .And. TRBDB->B2_COD == SBF->BF_PRODUTO .And. TRBDB->B2_LOCAL == SBF->BF_LOCAL
				cLocaliz := SBF->BF_LOCALIZ		
				dbSelectArea("SBF")		 			
				dbSkip()
			End

		EndIf

		//-- Se o Saldo no SDB for Negativo Gera Movimenta‡Æo de Acerto
		CONOUT(' 2- Produto '+TRBDB->B2_COD+' Local '+TRBDB->B2_LOCAL)

		aAdd(aCriaSDB, {TRBDB->B2_COD,;
		TRBDB->B2_LOCAL,;
		Abs(QtdComp(nSaldoSDB)),;
		cLocaliz,;
		"",;
		'ACERDB',;
		'UNI',;
		'',;
		'',;
		'',;
		'SDB',;
		dDataBase,;
		"",;
		"",;
		ProxNum(),;
		Iif(TRBDB->B2_QATU > TRBDB->BF_QUANT,'499','999'),;
		'M',;
		StrZero(1,Len(SDB->DB_ITEM)),;
		.F.,;
		0,;							
		0})

		dbSelectArea("TRBDB")
		dbSkip()
	End

	//GRAVA DADOS NA SDB
	If Len(aCriaSDB)> 0
		For nX := 1 to Len(aCriaSDB)
			CriaSDB(aCriaSDB[nX,01],;
			aCriaSDB[nX,02],;
			aCriaSDB[nX,03],;
			aCriaSDB[nX,04],;
			aCriaSDB[nX,05],;
			aCriaSDB[nX,06],;
			aCriaSDB[nX,07],;
			aCriaSDB[nX,08],;
			aCriaSDB[nX,09],;
			aCriaSDB[nX,10],;
			aCriaSDB[nX,11],;
			aCriaSDB[nX,12],;
			aCriaSDB[nX,13],;
			aCriaSDB[nX,14],;
			aCriaSDB[nX,15],;
			aCriaSDB[nX,16],;
			aCriaSDB[nX,17],;
			aCriaSDB[nX,18],;
			aCriaSDB[nX,19],;
			aCriaSDB[nX,20],;							
			aCriaSDB[nX,21])
		Next nX
	EndIf

	If MsgYesNo("DESEJA EXECUTAR O AJUSTE DE SALDOS?")
		MATA300()
	EndIf
	If MsgYesNo("DESEJA EXECUTAR O REFAZ ACUMULADOS?")
		MATA215()
	EndIf

return
