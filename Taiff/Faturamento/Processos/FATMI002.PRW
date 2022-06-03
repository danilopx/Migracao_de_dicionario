#INCLUDE "PROTHEUS.CH"
#Include "Topconn.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FatMI002 บAutor  ณTHIAGO COMELLI                           		 บ Data ณ  10/12/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avalia o credito do cliente e aprova                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObs.      ณ Se a variแvel cVisualiza	for igual a S, a rotina nใo atualizarแ o status do Or็amento  บฑฑ
			   ou Pedido																			  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function FATMI002(nBut, cNum, cVisualiza,lWeb )
	Local oObj
	Local _aArea := GetArea()
	LOCAL cArqLog 	:= "FINANCEIRO_LOG_ANALISE_CREDITO_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
	LOCAL cTEXTO1	:= ""

	Private aAvalCr := {0,""} //[1] Valor Total Pedido [2] Sigla da Aprova็ใo
	DEFAULT cNum := ""
	DEFAULT lWeb := .F.

	If lWeb
		MV_PAR01 := cNum
		MV_PAR02 := cNum

		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " nBut=" + alltrim(str(nBut))  + ENTER
		cTEXTO1 += " cNum=" + cNum + ENTER
		cTEXTO1 += " MV_PAR01=" + MV_PAR01  + ENTER
		cTEXTO1 += " MV_PAR02=" + MV_PAR02  + ENTER
		cTEXTO1 += " cVisualiza=" + IIF( VALTYPE(cVisualiza) = "U","nao definida",cVisualiza)  + ENTER
		cTEXTO1 += " SCHEDULER " + ENTER
		cTEXTO1 += " FILTROS PARA CHAMADA DA FUNCAO AvaCredOrc" + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	

		AvaCredOrc(nBut, NIL, MV_PAR01, MV_PAR02, .F., cVisualiza)
	Else
		If !VerSenha(136) //verifica se o usuario logado possui acesso 136-Lib.Pedido Venda
			MsgStop("Usuแrio sem acesso","Acesso nao permitido")
		Else
			If !Empty(cNum)
				Pergunte("FATMI00201",.F.,"Aprovar Lote de Or็amentos")
				MV_PAR01 := cNum
				MV_PAR02 := cNum
			Else
				If nBut == 1
					If !Pergunte("FATMI00201",.T.,"Aprovar Lote de Or็amentos")
						Return .T.
					EndIf
				ElseIf nBut == 2
					If !Pergunte("FATMI00301",.T.,"Aprovar Lote de Pedidos")
						Return .T.
					EndIf
				EndIf
			EndIf

			/* log temporario */	
			cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
			cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
			cTEXTO1 += " nBut=" + alltrim(str(nBut))  + ENTER
			cTEXTO1 += " cNum=" + cNum + ENTER
			cTEXTO1 += " MV_PAR01=" + MV_PAR01  + ENTER
			cTEXTO1 += " MV_PAR02=" + MV_PAR02  + ENTER
			cTEXTO1 += " cVisualiza=" + IIF( VALTYPE(cVisualiza) = "U","nao definida",cVisualiza)  + ENTER
			cTEXTO1 += " Usuario=" + UsrRetName(RetCodUsr()) + ENTER
			cTEXTO1 += " FILTROS PARA CHAMADA DA FUNCAO AvaCredOrc" + ENTER
			MEMOWRITE(cArqLog,cTEXTO1)
			/* log temporario */	

			oObj := MsNewProcess():New({|lEnd| AvaCredOrc(nBut, oObj, MV_PAR01, MV_PAR02, @lEnd, cVisualiza)},"","",.T.)
			oObj:Activate()
			//Processa({||AvaCredOrc(nBut) },"Libera็ใo de Cr้dito dos Pedidos","Analisando . . . ",)
		EndIf
	EndIf

	RestArea(_aArea)
Return aAvalCr

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AvaCredOrc บAutor  ณDaniel Tadashi Batori                         บ Data ณ  10/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Avalia o credito do cliente e aprova                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObs.      ณ a variavel aRotina utilizada nesta funcao eh private originada em fontes padroes       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AvaCredOrc(nBut, oObj, MV_PAR01, MV_PAR02,lEnd, cVisualiza)
	Local _nCont   := 0
	Local _cAprova := ""
	Local _aArea := GetArea()
	//Local lEnd:= .F.
	Local lVenc := .F.
	Local lLimite := .F.
	Local cNumOrcPed := ""
	Local cAliasAval := GETNEXTALIAS()
	Local cAliasItem := GETNEXTALIAS()
	//Local lSCHEDULE	:= .T.
	Local lPerdaFin	:= .F.
	Local nLogVlTotal	:= 0
	Local cTipoOperacao := ""

	LOCAL cArqLog 	:= "FINANCEIRO_LOG_ANALISE_CREDITO_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
	LOCAL cTEXTO1	:= ""

	If oObj != NIL
		oObj:SetRegua1(2)
		oObj:IncRegua1("Processando Libera็ใo de pedidos . . .")
	EndIf

	If nBut == 1

		BeginSql alias cAliasAval
			SELECT   SCJ.CJ_XLIBCR AS XLIBCR
					,SCJ.CJ_NUM AS NUM
					,SCJ.CJ_CLIENTE
					,SCJ.CJ_LOJA
					,SCJ.R_E_C_N_O_ AS REC 
					,SA1.A1_RISCO
					,ZA_LIMCRD
					,ZA_LIMDSP
					,ZA_QTTVEC
					,ZA_QTTPRD
			FROM %table:SCJ% SCJ
			INNER JOIN %table:SA1% SA1
			   ON SA1.A1_FILIAL= %xfilial:SA1% 
			  AND SA1.A1_COD=SCJ.CJ_CLIENTE
			  AND SA1.A1_LOJA=SCJ.CJ_LOJA 
			  AND SA1.%NotDel%
			  AND SA1.A1_PESSOA IN ('J','F')
			  AND SA1.A1_EST <> 'EX'
			LEFT JOIN %table:SZA% ZA
			  ON ZA.%NotDel% 
			  
			 //Comentado por Gilberto, a anแlise deve ser feita em todas as empresas/filiais, e nใo somente na empresa em que estแ sendo executada a rotina
			 //AND ZA_EMPRES = %exp:cEmpAnt% 
			 //AND ZA_FILEMP = %exp:cFilAnt% 
			 
			 AND ZA_CNPJRZ = CASE SA1.A1_PESSOA WHEN 'J' THEN 
			 						SUBSTRING(SA1.A1_CGC , 1 , LEN(SA1.A1_CGC) - 6)
			 				 	WHEN 'F' THEN 
			 				 		SUBSTRING(SA1.A1_CGC , 1 , 11) 
		END
			WHERE SCJ.CJ_FILIAL= %xfilial:SCJ%
			  AND SCJ.CJ_NUM BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
			  AND SCJ.CJ_STATUS = 'A' //orcamento em aberto
			//AND SCJ.CJ_XLIBCR <> 'L' //orcamento pendente de avaliacao de credito
			  AND SCJ.%NotDel%
	EndSql

ElseIf nBut == 2

		/*
	BeginSql alias cAliasAval
				SELECT   SC5.C5_XLIBCR AS XLIBCR
						,SC5.C5_NUM AS NUM
						,SC5.C5_CLIENTE
						,SC5.C5_LOJACLI
						,SC5.R_E_C_N_O_ as REC 
						,SA1.A1_RISCO
						,ZA_LIMCRD
						,ZA_LIMDSP
						,ZA_QTTVEC
						,ZA_QTTPRD
				FROM %table:SC5% SC5
				INNER JOIN %table:SA1% SA1
				ON SA1.A1_FILIAL=%xfilial:SA1% 
				AND SA1.A1_COD=SC5.C5_CLIENTE
				AND SA1.A1_LOJA=SC5.C5_LOJACLI 
				AND SA1.%NotDel%
				AND SA1.A1_PESSOA IN ('J','F')
				AND SA1.A1_EST <> 'EX'
				LEFT JOIN %table:SZA% ZA
				ON ZA.%NotDel% 
				
				//Comentado por Gilberto, a anแlise deve ser feita em todas as empresas/filiais, e nใo somente na empresa em que estแ sendo executada a rotina
				//AND ZA_EMPRES = %exp:cEmpAnt%
				//AND ZA_FILEMP = %exp:cFilAnt% 
				
				AND ZA_CNPJRZ = CASE SA1.A1_PESSOA WHEN 'J' THEN 
									SUBSTRING(SA1.A1_CGC , 1 , LEN(SA1.A1_CGC) - 6)
								WHEN 'F' THEN 
									SUBSTRING(SA1.A1_CGC , 1 , 11) 
	END
				WHERE SC5.C5_FILIAL= %xfilial:SC5%
				AND SC5.C5_NUM BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
				//AND SC5.C5_XLIBCR <> 'L' //orcamento pendente de avaliacao de credito
				AND SC5.C5_FILDES = %exp:CFILANT%		// Somente irแ realizar libera็ใo em lote para Pedido do mesmo Destino de onde estแ sendo analisado. 	
				AND SC5.%NotDel%
EndSql
		*/
CQUERY := "SELECT SC5.C5_XLIBCR AS XLIBCR" + ENTER
CQUERY += " ,SC5.C5_NUM AS NUM" + ENTER
CQUERY += " ,SC5.C5_CLIENTE" + ENTER
CQUERY += " ,SC5.C5_LOJACLI" + ENTER
CQUERY += " ,SC5.R_E_C_N_O_ as REC " + ENTER
CQUERY += " ,SA1.A1_RISCO" + ENTER
CQUERY += " ,ZA_LIMCRD" + ENTER
CQUERY += " ,ZA_LIMDSP" + ENTER
CQUERY += " ,ZA_QTTVEC" + ENTER
CQUERY += " ,ZA_QTTPRD" + ENTER
CQUERY += " FROM " + RETSQLNAME("SC5") + " SC5" + ENTER
CQUERY += " INNER JOIN " + RETSQLNAME("SA1") + " SA1" + ENTER
CQUERY += "  ON SA1.A1_FILIAL='" + xFilial("SA1") + "'" + ENTER
CQUERY += "  AND SA1.A1_COD=SC5.C5_CLIENTE" + ENTER
CQUERY += "  AND SA1.A1_LOJA=SC5.C5_LOJACLI " + ENTER
CQUERY += "  AND SA1.D_E_L_E_T_ = ''" + ENTER
CQUERY += "  AND SA1.A1_PESSOA IN ('J','F')" + ENTER
CQUERY += "  AND SA1.A1_EST <> 'EX'" + ENTER
CQUERY += " LEFT JOIN " + RETSQLNAME("SZA") + " ZA" + ENTER
CQUERY += "  ON ZA.D_E_L_E_T_ = '' " + ENTER
CQUERY += "  AND ZA_CNPJRZ = CASE SA1.A1_PESSOA WHEN 'J' THEN " + ENTER
CQUERY += "  		 	SUBSTRING(SA1.A1_CGC , 1 , LEN(SA1.A1_CGC) - 6)" + ENTER
CQUERY += "  		 WHEN 'F' THEN " + ENTER
CQUERY += "  			SUBSTRING(SA1.A1_CGC , 1 , 11) " + ENTER
CQUERY += "  		 END" + ENTER
CQUERY += " WHERE SC5.C5_FILIAL= '" + xFilial("SC5") + "'" + ENTER
CQUERY += "  AND SC5.C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + ENTER
CQUERY += "  AND SC5.C5_FILDES = '" + CFILANT + "'" + ENTER
CQUERY += "  AND SC5.D_E_L_E_T_ = ''" + ENTER

TCQUERY CQUERY NEW ALIAS (cAliasAval)

EndIf

// Nenhum item foi encontrado com o Select acima
If (cAliasAval)->(Eof())
	MsgAlert("Nenhum Item Selecionado!")
	(cAliasAval)->(DbCloseArea())
Return .T.
EndIf

(cAliasAval)->( dbEval( {|| _nCont++ } ) )
(cAliasAval)->( DbGoTop() )
If oObj != NIL
	oObj:SetRegua1(_nCont)
	oObj:SetRegua2(_nCont)
EndIf
_nProc2		:= 1

While !(cAliasAval)->(Eof())

	If lEnd //Processo Cancelado pelo Usuแrio
		Exit
	EndIf
	If oObj != NIL
		oObj:IncRegua1("Processando Libera็ใo de Cr้dito . . .")
		oObj:IncRegua2("Processando Item "+Alltrim(Str(_nProc2))+ " de " + Alltrim(Str(_nCont)) + " itens.")
	EndIf
	_nProc2 ++

	If nBut == 1

		BeginSql alias cAliasItem
					Column ValOrc as Numeric(18,8)
					SELECT   SUM(CK_VALOR) as ValorTotal
							,MAX(CK_XOPER) as TipoOper
					FROM %table:SCK% SCK
					WHERE SCK.CK_FILIAL = %xfilial:SCK%
					AND SCK.CK_NUM = %exp:(cAliasAval)->NUM%
					AND SCK.%NotDel%
		EndSql

	ElseIf nBut == 2

		BeginSql alias cAliasItem
					Column ValOrc as Numeric(18,8)
					SELECT   SUM(C6_VALOR) as ValorTotal
							,MAX(C6_XOPER) as TipoOper
					FROM %table:SC6% SC6
					WHERE SC6.C6_FILIAL= %xfilial:SC6%
					AND SC6.C6_NUM = %exp:(cAliasAval)->NUM%
					AND SC6.%NotDel%
		EndSql

	EndIf

	_cAprova := ""

	If (cNumOrcPed <> (cAliasAval)->NUM)
		lVenc := IIF((cAliasAval)->ZA_QTTVEC > 0,.T.,.F.)
		lLimite := IIF(((cAliasAval)->ZA_LIMDSP - (cAliasItem)->ValorTotal) < 0,.T.,.F.)
		cNumOrcPed := (cAliasAval)->NUM
		lPerdaFin  := IIF((cAliasAval)->ZA_QTTPRD > 0,.T.,.F.)

		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " PEDIDO=" + (cAliasAval)->NUM  + ENTER
		cTEXTO1 += " ZA_QTTVEC=" + ALLTRIM(STR((cAliasAval)->ZA_QTTVEC))  + ENTER
		cTEXTO1 += " ZA_LIMDSP=" + ALLTRIM(STR((cAliasAval)->ZA_LIMDSP ))  + ENTER
		cTEXTO1 += " ValorTotal=" + ALLTRIM(STR((cAliasItem)->ValorTotal))  + ENTER
		cTEXTO1 += " ZA_QTTPRD = " + ALLTRIM(STR((cAliasAval)->ZA_QTTPRD))  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	

	Else
		If (lVenc = .F.)
			lVenc := IIF((cAliasAval)->ZA_QTTVEC > 0,.T.,.F.)
		EndIf

				/* 
					Implementada em 21/08/2017 por CT a seguinte regra atraves da variavel lLimite: 
						.serแ mantido o bloqueio de credito mesmo que ocorra libera็ใo de credito em outra empresa/filial 
				*/
		If (lLimite  = .F.)
			lLimite := IIF(((cAliasAval)->ZA_LIMDSP - (cAliasItem)->ValorTotal) < 0,.T.,.F.)
		EndIf

				/* 
					Implementada em 21/08/2017 por CT a seguinte regra atraves da variavel lPerdaFin: 
						.a perda financeira tamb้m farแ parte do criterio de avalia็ใo de credito  
				*/
		If (lPerdaFin  = .F.)
			lPerdaFin  := IIF((cAliasAval)->ZA_QTTPRD > 0,.T.,.F.)
		EndIf
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " PEDIDO=" + (cAliasAval)->NUM  + ENTER
		cTEXTO1 += " ZA_QTTVEC=" + ALLTRIM(STR((cAliasAval)->ZA_QTTVEC))  + ENTER
		cTEXTO1 += " ZA_LIMDSP=" + ALLTRIM(STR((cAliasAval)->ZA_LIMDSP ))  + ENTER
		cTEXTO1 += " ValorTotal=" + ALLTRIM(STR((cAliasItem)->ValorTotal))  + ENTER
		cTEXTO1 += " ZA_QTTPRD = " + ALLTRIM(STR((cAliasAval)->ZA_QTTPRD))  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
	EndIf

	//********************************************************
	// comentar os alerts
			/*
	if lVenc = .T.
				alert("Cont้m tํtulos vencidos")
	endif
			
	if lLimite = .T.
				alert("Sem limite de cr้dito")
	endif*/
		//********************************************************
					
		aAvalCr[1]    := (cAliasItem)->ValorTotal
		nLogVlTotal   := (cAliasItem)->ValorTotal
		cTipoOperacao := AllTrim((cAliasItem)->TipoOper)
		
		(cAliasItem)->(DbCloseArea())

	Do Case
	Case cTipoOperacao == "34" // Se for Remessa em Garantia Libera o pedido sem a necessidade fazer outras verifica็๕es
			_cAprova := "L"
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " cTipoOperacao=" + cTipoOperacao  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
	Case (cAliasAval)->A1_RISCO == "A" //Libera automatico
			_cAprova := "L"
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " A1_RISCO=" + (cAliasAval)->A1_RISCO  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
	Case (cAliasAval)->A1_RISCO == "B" //Avalia Limite
		If lLimite //Nใo Aprova - Limite de Cr้dito Ultrapassado
				_cAprova := "M"
		Else //APROVA - Limite de Cr้dito Suficiente
				_cAprova := "L"
		EndIf
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " A1_RISCO=" + (cAliasAval)->A1_RISCO  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
	Case (cAliasAval)->A1_RISCO == "C" //Avalia Limite e Atrasos
		If lPerdaFin .OR. lVenc .OR. lLimite //Nใo Aprova - Existem Titulos Vencidos ou Sem Limite ou Tํtulo com Perda
				_cAprova := "M"
		Else //APROVA - Nใo tem titulos Vencidos e Tem Limite Disponivel
				_cAprova := "L"
		EndIf
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " A1_RISCO=" + (cAliasAval)->A1_RISCO  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
	Case (cAliasAval)->A1_RISCO == "E" //Bloqueado
		/* log temporario */	
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
		cTEXTO1 += " A1_RISCO=" + (cAliasAval)->A1_RISCO  + ENTER
		MEMOWRITE(cArqLog,cTEXTO1)
		/* log temporario */	
			_cAprova := "M"
	EndCase

		// Se o campo CJ_XLIBCR/C5_XLIBCR for B/A/L e a variแvel _cAprova for diferente de L, obtem o pr๓prio Status que jแ estแ no Or็amento/Pedido
	If (cAliasAval)->XLIBCR $ "B/A/L" .AND. _cAprova <> 'L'
			_cAprova := (cAliasAval)->XLIBCR
	EndIf

		//Se a tela for chamada de dentro do Or็amento ou do Pedido, a altera็ใo nใo ้ feita
	If cVisualiza <> "S"
		If !Empty(_cAprova)
					aAvalCr[2] := _cAprova
			If nBut == 1
		
						SCJ->(DbGoTo( (cAliasAval)->REC ))
				If RecLock("SCJ",.F.)
							SCJ->CJ_XLIBCR := _cAprova
							MsUnlock()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava Log na tabela SZCณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							_cAlias		:= "SCJ"
							_cChave		:= xFilial("SCJ")+SCJ->CJ_NUM
							_dDtIni		:= Date()
							_cHrIni		:= Time()
							_cDtFim		:= CTOD("")
							_cHrFim		:= ""
							_cCodUser	:= __CUSERID
							_cEstacao	:= ""
							_cOperac	:= IIF(_cAprova $ "M/B","02 - CREDITO BLOQUEADO POR AVALIAวรO AUTOMATICA - ORCAMENTO","03 - CREDITO LIBERADO POR AVALIAวรO AUTOMATICA - ORCAMENTO")
							_cFuncao	:= "U_FATMI002"
							U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					If _cAprova $ "M/B"
								_cOperac := "Tipo aprovacao = " + _cAprova + " "
								_cOperac += "Perda Financeira = " + ALLTRIM(TRANSFORM((cAliasAval)->ZA_QTTPRD,"@E 999,999,999")) + " " 
								_cOperac += "Qtd. Vencida = " + ALLTRIM(TRANSFORM((cAliasAval)->ZA_QTTVEC,"@E 999,999,999")) + " "
								_cOperac += "Limite disponivel = " + ALLTRIM(TRANSFORM((cAliasAval)->ZA_LIMDSP,"@E 999,999,999.99")) + " "
								_cOperac += "Valor Total = " + ALLTRIM(TRANSFORM(nLogVlTotal,"@E 999,999,999.99")) + " "
								
								_cCodUser	:= "LOG_II"
								U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
					EndIf

				EndIf
		
			ElseIf nBut == 2
		
						SC5->(DbGoTo( (cAliasAval)->REC ))
				If RecLock("SC5",.F.)
							SC5->C5_XLIBCR := _cAprova //Pedido liberado
							MsUnlock()
							/* log temporario */	
							cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
							cTEXTO1 += "FATMI002 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
							cTEXTO1 += " PEDIDO=" + SC5->C5_NUM  + ENTER
							cTEXTO1 += " FILIAL=" + SC5->C5_FILIAL  + ENTER
							cTEXTO1 += " _cAprova=" + _cAprova  + ENTER
							cTEXTO1 += "GRAVA EM SC5->C5_XLIBCR := " + _cAprova  + ENTER
							MEMOWRITE(cArqLog,cTEXTO1)
							/* log temporario */	

		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณGrava Log na tabela SZCณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
							_cAlias		:= "SC5"
							_cChave		:= xFilial("SC5")+SC5->C5_NUM
							_dDtIni		:= Date()
							_cHrIni		:= Time()
							_cDtFim		:= CTOD("")
							_cHrFim		:= ""
							_cCodUser	:= __CUSERID
							_cEstacao	:= ""
							_cOperac	:= _cOperac	:= IIF(_cAprova $ "M/B","11 - CREDITO BLOQUEADO POR AVALIAวรO AUTOMATICA - PEDIDO DE VENDA","12 - CREDITO LIBERADO POR AVALIAวรO AUTOMATICA - PEDIDO DE VENDA")
							_cFuncao	:= "U_FATMI002"
							U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
							
				EndIf
			EndIf
		EndIf
	EndIf
			(cAliasAval)->(DbSkip())
EndDo

	(cAliasAval)->(DbCloseArea())

	RestArea(_aArea)
	
Return .T.
