#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "AP5MAIL.CH"

#DEFINE ENTER CHR(13) + CHR(10)
/*
VETI - Ponto de Entrada na exclusao da NF de Saida
Restaura as amarracoes do ZZG com o SC9 e Atualiza Status dos Pedidos de Venda para Separacao com Esteira
*/

USER FUNCTION M521DNFS()

	Local aArea		:= GetArea()
	Local WQTDZZGIK 	:= 0
	Local WQTDSC9IK 	:= 0
	Local aPedido 		:= PARAMIXB[1]
	LOCAL CQUERY 		:= ""
	Local lIntercompany := .F.
	LOCAL CVARGLB		:= "d" + ALLTRIM(UsrRetName()) + cValtoChar(THREADID())
	Local cVetiPed 	:= ""
	Local cClassPed	:= ""
	Local cTpVerbaTT	:= GetMV("MV__FINVTT",.F.,"02") // Tipo de verba: 02 - Verba Tática ou 03 - Verba Bonificação
	Local i := 0
	Local nLoop := 0
	Local cRGvOS := SuperGetMV("M521DNFS01",,"|0301|0302|")

	PRIVATE ADELPED		:= {}
	PRIVATE cEmail		:= "grp_contabilidade@taiff.com.br" // "carlos.torres@taiffproart.com.br"

	//Regrava dados de separacao e cliente, atraves de SC9 deletada
	If !Empty( cRGvOS )
		If ( Alltrim(cEmpAnt) + Alltrim(cFilAnt) $ cRGvOS )
			RGvPdDel( aPedido )
		EndIf
	EndIf

	//Verifica se a empresa está no parametro
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Executa somente na empresa e filial selecionados
		cPedidos := ""
		cVetiPed := ""
		//Cria cPedidos pronto para querys com uso da clausula IN
		For i:=1 to Len(aPedido)

			//## Incluido verificacao para Pedido de Transferencia - Projeto Avante - Fase II
			//## Edson Hornberger - 18/09/2013
			DBSELECTAREA("SC5")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SC5") + APEDIDO[I])


			IF SC5->C5_INTER <> 'S'
				cPedidos += "'" + AllTrim(aPedido[i]) + "',"
			Else
				lIntercompany := .T.
			ENDIF

			If Alltrim(SC5->C5_XITEMC) = "PROART"
				cVetiPed += "'" + AllTrim(aPedido[i]) + "',"
			EndIf

		Next

		If cempant + cfilant = "0301" .AND. .NOT. SC5->C5_TIPO $ "D|B"
			For i:=1 to Len(aPedido)

				DBSELECTAREA("SC5")
				DBSETORDER(1)
				If DBSEEK(XFILIAL("SC5") + APEDIDO[I])
					cClassPed := Iif( SC5->C5_CLASPED = "A" ,SC5->C5_CLASPED,cClassPed)
					If SC5->C5_CLASPED != "A" .AND. !EMPTY(SC5->C5_STCROSS)
						IF SC5->(RECLOCK("SC5",.F.))
							SC5->C5_STCROSS := "AGFATU"
							SC5->(MSUNLOCK())
						ENDIF
					EndIf
				EndIf

			Next
		EndIf

		If lIntercompany

			/*
			Projeto...: Cross Docking - Reconstrução
			Data......: 23/10/2015
			Descriçao.: Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz   
			Autor.....: CT
			*/
			/*
			|---------------------------------------------------------------------------------
			|	Realiza a validacao do Cliente verificando se eh do Grupo.
			|---------------------------------------------------------------------------------
			*/
			If cempant + cfilant = "0302"
				cPedidos := ""
				For i:=1 to Len(aPedido)

					DBSELECTAREA("SC5")
					DBSETORDER(1)
					DBSEEK(XFILIAL("SC5") + APEDIDO[I])

					IF SC5->C5_INTER = 'S' .and. .NOT. Empty(SC5->C5_NUMORI)
						cPedidos += "'" + SC5->C5_NUMORI + "',"
					ENDIF

				Next
				If .NOT. EMPTY(cPedidos)
					cPedidos += " '-----' "
					CQUERY := "UPDATE" 								+ ENTER
					CQUERY += "	SC5" 								+ ENTER
					CQUERY += "SET" 									+ ENTER
					CQUERY += "	C5_STCROSS = 'AGTRAN'" 			+ ENTER
					CQUERY += "FROM" 									+ ENTER
					CQUERY += "	" + RETSQLNAME("SC5") + " SC5"	+ ENTER
					CQUERY += "WHERE" 								+ ENTER
					CQUERY += "	C5_FILIAL = '01' AND" 			+ ENTER
					CQUERY += "	C5_NUM IN ("+cPedidos+") AND"  	+ ENTER
					CQUERY += "	D_E_L_E_T_ = ''"

					IF TCSQLEXEC(CQUERY) != 0

						MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
							"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))

					ENDIF
				EndIf


				GETGLBVARS(CVARGLB,@ADELPED)

				CB7->(DbSetOrder(2))
				DBSELECTAREA("SC9")
				SC9->(DbSetOrder(1))
				cPedidos := ""
				For i:=1 to Len(aPedido)

					CB7->(DbSeek( XFILIAL("CB7") + APEDIDO[I] )) // Marca PROART não tem CB7

					If SC9->(DBSEEK(XFILIAL("SC9") + APEDIDO[I] ))

						WHILE SC9->(!EOF()) .AND. SC9->(C9_FILIAL + C9_PEDIDO) = XFILIAL("SC9") + APEDIDO[I]

							IF EMPTY(ALLTRIM(SC9->C9_NFISCAL)) .AND. EMPTY(ALLTRIM(SC9->C9_ORDSEP)) .AND. SC9->C9_DATALIB = DDATABASE .AND. SC9->C9_BLEST != "02"
								nPosVrPbl := 0
								For nLoop := 1 to Len(ADELPED)
									If APEDIDO[I] = ADELPED[nLoop][1] .AND. ADELPED[nLoop][4] = SC9->C9_ITEM .AND. ADELPED[nLoop][5] = SC9->C9_PRODUTO .AND. ADELPED[nLoop][6] = SC9->C9_SEQUEN
										nPosVrPbl := nLoop
									EndIf
								Next nLoop

								IF SC9->(RECLOCK("SC9",.F.))
									If len(ADELPED)>0
										SC9->C9_ORDSEP	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][7]
										SC9->C9_PEDORI	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][8]
										SC9->C9_CLIORI	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][9]
										SC9->C9_LOJORI	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][10]
										SC9->C9_NOMORI	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][11]
										SC9->C9_NUMOF	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][2]
										If nPosVrPbl > 0
											SC9->C9_DOCTRF	:= ADELPED[ nPosVrPbl ][3]
										EndIf
									EndIf
									SC9->(MSUNLOCK())
								ENDIF

							ENDIF
							SC9->(DBSKIP())

						ENDDO

					ENDIF

				Next
				RestArea(aArea)
				CLEARGLBVALUE(CVARGLB)
			EndIf
			cPedidos := cVetiPed

		ElseIf cempant + cfilant = "0302"

			GETGLBVARS(CVARGLB,@ADELPED)

			DBSELECTAREA("SC9")
			SC9->(DbSetOrder(1))
			cPedidos := ""
			For i:=1 to Len(aPedido)
				SC9->(DBSEEK(XFILIAL("SC9") + APEDIDO[I] ))

				WHILE SC9->(!EOF()) .AND. SC9->(C9_FILIAL + C9_PEDIDO) = XFILIAL("SC9") + APEDIDO[I]

					IF EMPTY(ALLTRIM(SC9->C9_NFISCAL)) .AND. SC9->C9_DATALIB = DDATABASE .AND. SC9->C9_BLEST != "02"

						nPosVrPbl := 0
						For nLoop := 1 to Len(ADELPED)
							If APEDIDO[I] = ADELPED[nLoop][1] .AND. ADELPED[nLoop][4] = SC9->C9_ITEM .AND. ADELPED[nLoop][5] = SC9->C9_PRODUTO .AND. ADELPED[nLoop][6] = SC9->C9_SEQUEN
								nPosVrPbl := nLoop
							EndIf
						Next nLoop

						IF SC9->(RECLOCK("SC9",.F.))
							If len(ADELPED)>0
								SC9->C9_NUMOF	:= ADELPED[ ASCAN( ADELPED , {|x| Alltrim(x[1]) = APEDIDO[I]} ) ][2]
								If nPosVrPbl > 0
									SC9->C9_DOCTRF	:= ADELPED[ nPosVrPbl ][3]
								EndIf
							EndIf
							SC9->(MSUNLOCK())
						ENDIF

					ENDIF
					SC9->(DBSKIP())

				ENDDO

			Next
			RestArea(aArea)
			CLEARGLBVALUE(CVARGLB)
			cPedidos := cVetiPed

		EndIf

			/* Chamada da função para excluir título do contas a pagar */
		U_TFdelTAXAS()

			/* Chamada da função para excluir título do financeiro NCC - Verba*/
		U_TFdelNCCVERBA(cClassPed)

			/* Chamada da função para excluir título do financeiro AB- sobre Verba Tatica*/
		If SC5->(FIELDPOS("C5_DESCTAT")) > 0
			For i:=1 to Len(aPedido)

				DBSELECTAREA("SC5")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SC5") + APEDIDO[I])
					If ALLTRIM(SC5->C5_DESCTAT) == cTpVerbaTT .AND. SC5->C5_PERCTAT > 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³cVar1 - conta de email no campo FROM³
						//³cVar2 - conta de email no campo TO  ³
						//³cVar3                               ³
						//³cVar4 - Mensagem do corpo do email  ³
						//³cVar5 - titullo do email            ³
						//³cVar6 - endereco do anexo           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cMensErr := "Nota Fiscal excluida na empresa/filail " + Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + ENTER
						If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
							cMensErr += "emitida no ambiente de T E S T E S utilizada no processo de VERBA TATICA" + ENTER
						Else
							cMensErr += "emitida no ambiente OFICIAL utilizada no processo de VERBA TATICA" + ENTER
						EndIf
						cMensErr += "Número da nota fiscal/Serie: " +  SF2->F2_DOC + "/" + SF2->F2_SERIE + ENTER
						If .NOT. Empty(SF2->F2_DTLANC)
							cMensErr += "Data de contabilização: " +  DTOC(SF2->F2_DTLANC) + ENTER
						Else
							cMensErr += "Não contabilizada " + ENTER
						EndIf

						U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,"Nota Fiscal excluida em " + DTOC(DDATABASE)	,'')

						U_TFdelTATVERBA()
					EndIf
				EndIf
			Next
		EndIf
		if Empty(cPedidos)

			Return()

		endif

		BEGIN Transaction

			cPedidos := Substr(cPedidos,1,Len(cPedidos)-1)

			//Atualiza C5_YFMES
			cQuery := " UPDATE "+RetSQLName("SC5")+" SET C5_YFMES=''"
			cQuery += " WHERE C5_FILIAL='"+xFilial("SC5")+"' AND C5_NUM IN ("+cPedidos+")"
			cQuery += " AND D_E_L_E_T_ <> '*'"

			//MemoWrite("M521DNFS-LimpaPedidos.sql",cQuery)
			TcSqlExec(cQuery)
			TCREFRESH(RetSqlName("SC5"))

			// Refaz a gravação de dados de separação nos novos registros SC9 e ZZG da NF excluída

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
			//³Atualiza ZZG: grava RECNO do SC9 em cada item separado          ³
			//³Arlete - mai 2013													 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

			cQuery := "UPDATE "+RetSqlName("ZZG")+" SET ZZG_SC9 = "+RetSqlName("SC9")+".R_E_C_N_O_ "
			cQuery += "FROM "+RetSqlName("ZZG")+","+RetSqlName("SC9")+" "
			cQuery += "WHERE C9_PEDIDO IN (" + cPedidos + ") "
			cQuery += "AND ZZG_PEDIDO = C9_PEDIDO "
			cQuery += "AND C9_NFISCAL = '' "
			cQuery += "AND ZZG_PRODUT = C9_PRODUTO "
			cQuery += "AND ZZG_SC9 NOT IN (SELECT R_E_C_N_O_ FROM "+RetSqlName("SC9")+" AS SC9SUB WHERE SC9SUB.C9_PEDIDO IN (" + cPedidos + ")  AND SC9SUB.D_E_L_E_T_ <> '*') "
			cQuery += "AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
			cQuery += "AND "+RetSqlName("SC9")+".D_E_L_E_T_ <> '*' "

			//MemoWrite("M521DNFS-AtualizaZZG.sql",cQuery)
			TCSQLExec(cQuery)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Atualiza SC9: grava numero da caixa de cada produto da liberação atual ³
//³Arlete - mai 2013															 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

			cQuery := "UPDATE " + RetSqlName("SC9") + " SET C9_ORDSEP = ZZG_SEQCX "
			cQuery += "FROM "+RetSqlName("SC9")+","+RetSqlName("ZZG")+" "
			cQuery += "WHERE C9_PEDIDO IN (" + cPedidos + ") "
			cQuery += "AND C9_PEDIDO = ZZG_PEDIDO "
			cQuery += "AND C9_NFISCAL = '' "
			cQuery += "AND C9_PRODUTO = ZZG_PRODUT "
			cQuery += "AND "+RetSqlName("SC9")+".R_E_C_N_O_ = ZZG_SC9 "
			cQuery += "AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
			cQuery += "AND "+RetSqlName("SC9")+".D_E_L_E_T_ <> '*' "
			cQuery += "AND C9_XITEM != '1' "

			//MemoWrite("M521DNFS-AtualizaSC9.sql",cQuery)
			TCSQLExec(cQuery)

			// Verifica se os dados continuam consistentes ZZG x SC9, pois os registros SC9 foram refeitos
			// na exclusão da NF, por padrão Protheus

			// COUNT ZZG
			cQueryIK := " SELECT SUM(ZZG_QUANT) AS ZZGIK "
			cQueryIK += " FROM "+RetSqlName("ZZG")+" ZZG "
			cQueryIK += " INNER JOIN "+RetSqlName("SC9")+" SC9 "
			cQueryIK += " ON SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND ZZG.ZZG_SC9 = SC9.R_E_C_N_O_ AND SC9.D_E_L_E_T_ <> '*' "
			cQueryIK += " WHERE ZZG.D_E_L_E_T_ <> '*' "
			cQueryIK += " AND ZZG_FILIAL = '"+xFilial("ZZG")+"'"
			cQueryIK += " AND ZZG_PEDIDO IN (" + cPedidos + ") "
			cQueryIK += " AND SC9.C9_NFISCAL = '' "

			//MemoWrite("M521DNFS-COUNT-ZZG.sql",cQuery)
			cQueryIK := ChangeQuery( cQueryIK )
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),(_cAlias := GetNextAlias()), .F., .T.)

			WQTDZZGIK := (_cAlias)->ZZGIK
			dbCloseArea()

			// conta SC9
			cQueryIK := " SELECT SUM(C9_QTDLIB ) AS C9QTDLIBIK "
			cQueryIK += " FROM "+RetSqlName("SC9")+" SC9 "
			cQueryIK += " WHERE SC9.D_E_L_E_T_ <> '*' "
			cQueryIK += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
			cQueryIK += " AND C9_PEDIDO IN (" + cPedidos + ") "
			cQueryIK += " AND C9_NFISCAL = '' "
			cQueryIK += " AND C9_BLEST<>'02' "

			//MemoWrite("M521DNFS-COUNT-SC9.sql",cQuery)
			cQueryIK := ChangeQuery( cQueryIK )
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryIK),(_cAlias2 := GetNextAlias()), .F., .T.)

			WQTDSC9IK := (_cAlias2)->C9QTDLIBIK
			dbCloseArea()

			WSTERROIK := .F.
			IF  WQTDZZGIK == WQTDSC9IK
				U_M003LOG(,SC5->C5_NUM,"Dados da separação verificados com sucesso após exclusão da NF de saída. Produto "+SC9->C9_PRODUTO+".")
				IF !ISINCALLSTACK("U_TF_4AVN_A4")
					MsgAlert("Dados da separação verificados com sucesso após exclusão da NF de saída. Produto "+SC9->C9_PRODUTO+".")
				ENDIF
			ELSE
				U_M003LOG(,SC5->C5_NUM,"Dados da separação não conferem após exclusão da NF de saída. Produto "+SC9->C9_PRODUTO+".")
				IF !ISINCALLSTACK("U_TF_4AVN_A4")
					Alert("Dados da separação não conferem após exclusão da NF de saída. Produto "+SC9->C9_PRODUTO+".")
				ENDIF
				WSTERROIK := .T.
			ENDIF

		End Transaction

	ENDIF


	/* Chamada da função para excluir título do contas a pagar */
	U_TFdelTAXAS()

	/* Chamada da função para excluir título do financeiro NCC - Verba*/
	U_TFdelNCCVERBA(cClassPed)

	/* Chamada da função para excluir título do financeiro AB- sobre Verba Tatica*/
	If SC5->(FIELDPOS("C5_DESCTAT")) > 0
		For i:=1 to Len(aPedido)

			DBSELECTAREA("SC5")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC5") + APEDIDO[I])
				If ALLTRIM(SC5->C5_DESCTAT) == cTpVerbaTT .AND. SC5->C5_PERCTAT > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³cVar1 - conta de email no campo FROM³
					//³cVar2 - conta de email no campo TO  ³
					//³cVar3                               ³
					//³cVar4 - Mensagem do corpo do email  ³
					//³cVar5 - titullo do email            ³
					//³cVar6 - endereco do anexo           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cMensErr := "Nota Fiscal excluida na empresa/filail " + Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + ENTER
					If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
						cMensErr += "emitida no ambiente de T E S T E S utilizada no processo de VERBA TATICA" + ENTER
					Else
						cMensErr += "emitida no ambiente OFICIAL utilizada no processo de VERBA TATICA" + ENTER
					EndIf
					cMensErr += "Número da nota fiscal/Serie: " +  SF2->F2_DOC + "/" + SF2->F2_SERIE + ENTER
					If .NOT. Empty(SF2->F2_DTLANC)
						cMensErr += "Data de contabilização: " +  DTOC(SF2->F2_DTLANC) + ENTER
					Else
						cMensErr += "Não contabilizada " + ENTER
					EndIf
					U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,"Nota Fiscal excluida em " + DTOC(DDATABASE)	,'')

					U_TFdelTATVERBA()
				EndIf
			EndIf
		Next
	EndIf

	RestArea(aArea)

Return


/*
---------------------------------------------------------------------------------------------------------
 FUNÇÃO.....: TFdelTAXAS 		                           AUTOR: CARLOS ALDAY TORRES        DATA: 19/05/2016 
 DESCRICAO..: Excluir o título de contas a pagar quando a nota fiscal tem ST e o título é do tipo TXn
 				onde "n" é a série da nota fiscal. Ver também o PE CPAPUICMS.PRW
---------------------------------------------------------------------------------------------------------
*/
User Function TFdelTAXAS()
	Local cMV_FornGNRE:= GETNEWPAR("MV_RECST" + SD2->D2_EST ,"")	// Indica o fornecedor e loja padrão para geração dos títulos a pagar do ICMS-ST (Rio de Janeiro)
	Local cForn_GNRE	:= ""
	Local cLoja_GNRE	:= ""
	Local cNomArqErro := "M521DNFS_TFdelTAXAS_ERROR.LOG"
	Local cAliasGNRE 	:= GetNextAlias()

	Private lMsErroAuto := .F.

	cForn_GNRE	:= Substr(cMV_FornGNRE,1,TamSX3("E2_FORNECE")[1])
	cLoja_GNRE	:= Substr(cMV_FornGNRE,  TamSX3("E2_FORNECE")[1] + 2  ,TamSX3("E2_LOJA")[1])

	_cQuery := "SELECT CDC_GUIA " + ENTER
	_cQuery += " FROM " + RetSQLName("CDC") + " CDC WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE " + ENTER
	_cQuery += "  CDC.D_E_L_E_T_ = '*' " + ENTER
	_cQuery += "  AND CDC_FILIAL	= '" + xFilial("CDC") + "' " + ENTER
	_cQuery += "  AND CDC_TPMOV	= 'S' " + ENTER
	_cQuery += "  AND CDC_DOC		= '" + SD2->D2_DOC + "' " + ENTER
	_cQuery += "  AND CDC_SERIE	= '" + SD2->D2_SERIE + "' " + ENTER
	_cQuery += "  AND CDC_CLIFOR	= '" + SD2->D2_CLIENTE + "' " + ENTER
	_cQuery += "  AND CDC_LOJA	= '" + SD2->D2_LOJA + "' " + ENTER
	_cQuery += "  AND CDC_UF		= '" + SD2->D2_EST + "' " + ENTER

	//MemoWrite( "521DNFS_TFdelTAXAS.sql" , _cQuery )

	TcQuery _cQuery NEW ALIAS (cAliasGNRE)

	While !(cAliasGNRE)->(Eof())
		DbSelectArea("SE2")
		DbSetOrder(1)
		If DbSeek(xFilial("SE2") + (cAliasGNRE)->CDC_GUIA + Space(TamSX3("E2_PARCELA")[1])+"TX"+LEFT(ALLTRIM(SD2->D2_SERIE),1)+cForn_GNRE+cLoja_GNRE)
			aArray :={	{ "E2_PREFIXO"	, SE2->E2_PREFIXO	, NIL },;
				{ "E2_NUM"		, SE2->E2_NUM 		, NIL },;
				{ "E2_PARCELA"	, SE2->E2_PARCELA	, NIL },;
				{ "E2_TIPO"	, SE2->E2_TIPO 	, NIL },;
				{ "E2_FORNECE"	, SE2->E2_FORNECE	, NIL },;
				{ "E2_LOJA"	, SE2->E2_LOJA 	, NIL }	}
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 5)
			If lMsErroAuto
				MostraErro("\TEMP\", cNomArqErro )
			Endif
		EndIf

		(cAliasGNRE)->(DbSkip())
	End

Return NIL

/*
---------------------------------------------------------------------------------------------------------
 FUNÇÃO.....: TFdelNCCVERBA 		                           AUTOR: CARLOS ALDAY TORRES        DATA: 06/06/2016 
 DESCRICAO..: Excluir títulos VERBAS gerados pela rotina M460FIM
---------------------------------------------------------------------------------------------------------
*/
User Function TFdelNCCVERBA( _cClassPed )
	Local aSE1Alias	:= SE1->(GetArea())
	Local aZA6Alias 	:= ZA6->(GetArea())
	Local cZA6Prefixo	:= ""
	Local aFin040		:= {}
	Local cNomArqErro := "M521DNFS_TFdelNCCVERBA_ERROR.LOG"
	Local n := 0

	If SF2->F2_TIPO = "N" .AND. _cClassPed != "A"
	/* Carga a matriz os títulos NCC de Verba da nota fiscal de venda */
		// (2) - E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		SE1->(DbSetOrder(2))

		ZA6->(DbSetOrder(1))
		ZA6->(DbSeek(xFilial("ZA6")+SF2->(F2_CLIENTE+F2_LOJA)))

		While ZA6->ZA6_FILIAL + ZA6->ZA6_CLIENT + ZA6->ZA6_LOJA = xFilial("ZA6")+SF2->(F2_CLIENTE+F2_LOJA) .And. ! ZA6->(Eof())
			If ZA6->ZA6_ITEMC = SD2->D2_ITEMCC .OR. Empty(ZA6->ZA6_ITEMC)
				cZA6Prefixo := Alltrim(ZA6->ZA6_TPBON)
				If TamSX3("E1_PREFIXO")[1] > TamSX3("ZA6_TPBON")[1]
					cZA6Prefixo += Space(TamSX3("E1_PREFIXO")[1] - TamSX3("ZA6_TPBON")[1])
				EndIf
				SE1->(DbSeek( xFilial("SE1") + SF2->(F2_CLIENTE+F2_LOJA) + cZA6Prefixo + SF2->F2_DOC  ))
				While !SE1->(Eof()) .AND. SE1->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM) = xFilial("SE1") + SF2->(F2_CLIENTE + F2_LOJA) + cZA6Prefixo + SF2->F2_DOC
					If SE1->E1_TIPO = "NCC"
						AADD(aFIN040,{ {"E1_PREFIXO"	,	SE1->E1_PREFIXO	,nil},;
							{"E1_NUM"		,	SE1->E1_NUM		,nil},;
							{"E1_PARCELA"	,	SE1->E1_PARCELA	,nil},;
							{"E1_TIPO"		,	SE1->E1_TIPO		,nil},;
							{"E1_NATUREZ"	,	SE1->E1_NATUREZ	,nil},;
							{"E1_CLIENTE"	,	SE1->E1_CLIENTE	,nil},;
							{"E1_LOJA"		,	SE1->E1_LOJA		,nil}	 })
					EndIf
					SE1->(DbSkip())
				End
			EndIf
			ZA6->(DbSkip())
		End
	/* Executa a exclusão dos títulos */
		//Begin Transaction

		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.

		For n := 1 to len(aFIN040)
			MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],5)
			If LMsErroAuto
				MostraErro("\TEMP\", cNomArqErro )
				//MostraErro()
				//DisarmTransaction()
				//Break
			Endif
		Next
		//End Transaction
		SE1->(RestArea(aSE1Alias))
		ZA6->(RestArea(aZA6Alias))
	EndIf
Return(.t.)

/*
---------------------------------------------------------------------------------------------------------
 FUNÇÃO.....: TFdelTATVERBA 		                  AUTOR: CARLOS ALDAY TORRES        DATA: 18/09/2019 
 DESCRICAO..: Excluir títulos com origem na VERBA TATICA gerados pela rotina M460FIM
---------------------------------------------------------------------------------------------------------
*/
User Function TFdelTATVERBA()
	Local aFin040	:= {}
	Local cNomArqErro := "M521DNFS_TFdelTATVERBA_ERROR.LOG"
	Local _cQuery 	:= ""
	Local n := 0

	If SF2->F2_TIPO = "N"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Encontra o título no financeiro do abatimento        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cQuery := "SELECT SE1.R_E_C_N_O_ AS E1_PONTEIRO" + ENTER
		_cQuery += " FROM " + RetSQLName("SE1") + " SE1 WITH(NOLOCK) " + ENTER
		_cQuery += "WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "' " + ENTER
		_cQuery += " AND SE1.E1_CLIENTE = '" + SF2->F2_CLIENTE + "' " + ENTER
		_cQuery += " AND SE1.E1_LOJA = '" + SF2->F2_LOJA + "' " + ENTER
		_cQuery += " AND SE1.E1_TIPO = 'AB-' " + ENTER
		_cQuery += " AND SE1.E1_NUM	= '" + SF2->F2_DOC + "' " + ENTER
		_cQuery += " AND SE1.E1_PREFIXO	= '" + SF2->F2_SERIE + "' " + ENTER
		_cQuery += " AND SE1.D_E_L_E_T_ = '' "

		//MEMOWRITE("M521DNFS_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)

		If Select("SQLE1") > 0
			SQLE1->( dbCloseArea() )
		EndIf

		dbUseArea( .T., "TOPCONN"     , TCGENQRY(,,_cQuery),"SQLE1", .F., .T.)

		SQLE1->(DbGotop())

		While .NOT. SQLE1->(Eof())
			SE1->(DbGoto( SQLE1->E1_PONTEIRO))

			AADD(aFIN040,{ {"E1_PREFIXO"	,	SE1->E1_PREFIXO	,nil},;
				{"E1_NUM"		,	SE1->E1_NUM		,nil},;
				{"E1_PARCELA"	,	SE1->E1_PARCELA	,nil},;
				{"E1_TIPO"		,	SE1->E1_TIPO		,nil},;
				{"E1_NATUREZ"	,	SE1->E1_NATUREZ	,nil},;
				{"E1_CLIENTE"	,	SE1->E1_CLIENTE	,nil},;
				{"E1_LOJA"		,	SE1->E1_LOJA		,nil}	 })

			SQLE1->(DbSkip())
		End
	/* Executa a exclusão dos títulos */
		//Begin Transaction

		lMsErroAuto := .F. // variavel interna da rotina automatica
		lMsHelpAuto := .F.

		For n := 1 to len(aFIN040)
			MSExecAuto({|x,y| FINA040(x,y)},aFIN040[n],5)
			If LMsErroAuto
				MostraErro("\TEMP\", cNomArqErro )
				//MostraErro()
				//DisarmTransaction()
				//Break
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³cVar1 - conta de email no campo FROM³
				//³cVar2 - conta de email no campo TO  ³
				//³cVar3                               ³
				//³cVar4 - Mensagem do corpo do email  ³
				//³cVar5 - titullo do email            ³
				//³cVar6 - endereco do anexo           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMensErr := "Nota Fiscal excluida na empresa/filail " + Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + ENTER
				If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
					cMensErr += "emitida no ambiente de T E S T E S utilizada no processo de VERBA TATICA" + ENTER
				Else
					cMensErr += "emitida no ambiente de OFICIAL utilizada no processo de VERBA TATICA" + ENTER
				EndIf
				cMensErr += "Número da nota fiscal/Serie: " +  SF2->F2_DOC + "/" + SF2->F2_SERIE + ENTER

				U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensErr	,"Nota Fiscal excluida em " + DTOC(DDATABASE)	,'')
			Endif
		Next
	EndIf
Return(.t.)



//{Protheus.doc}	RGvPdDel
//Description 	    Regrava dados na SC9, a partir dos registros que foram excluidos
//@param			aPeds (array com os numeros dos pedidos de venda ref. a NF excluida)
//@return			Nao ha
//@author			Ronald Piscioneri
//@since			09-ABR-2021
Static Function RGvPdDel( aPeds )
Local cQry := ""
Local nNx := 0
Local lDArm := .F.
Local aUpd := {}
Local cSC9Tbl := RetSqlName("SC9")
Local cSC9Fil := xFilial("SC9")

For nNx := 1 to Len( aPeds )

	cQry := "SELECT "
	cQry += "A.C9_ITEM AS AC9ITEM, "
	cQry += "A.C9_PRODUTO AS AC9PRODUTO, "
	cQry += "A.C9_SEQUEN AS AC9SEQUEN, "
	cQry += "A.C9_QTDLIB AS AC9QTDLIB, "
	cQry += "ISNULL(A.R_E_C_N_O_,0) AS ASC9RCN "
	cQry += "FROM " +cSC9Tbl+ " A WHERE A.D_E_L_E_T_ = ' ' "
	cQry += "AND A.C9_FILIAL = '" +cSC9Fil+ "' "
	cQry += "AND A.C9_PEDIDO = '" +aPeds[nNx]+ "' "
	cQry += "AND A.C9_NFISCAL = '' "
	cQry += "ORDER BY A.C9_ITEM, A.C9_PRODUTO "

	Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
	TcSetField("AWRK", "ASC9RCN", "N", 14, 0 )
	TcSetField("AWRK", "AC9QTDLIB", "N", 12, 2 )
	AWRK->(dbGoTop())

	While AWRK->(!EoF())

		If AWRK->ASC9RCN > 0

			cQry := "SELECT TOP 1 "
			cQry += "B.C9_PEDORI AS BC9PEDORI, "
			cQry += "B.C9_CLIORI AS BC9CLIORI, "
			cQry += "B.C9_LOJORI AS BC9LOJORI, "
			cQry += "B.C9_NOMORI AS BC9NOMORI, "
			cQry += "B.C9_NUMOF AS BC9NUMOF, "
			cQry += "B.C9_XORDSEP AS BC9XORDSEP, "
			cQry += "ISNULL(B.R_E_C_N_O_,0) AS BSC9RCN "
			cQry += "FROM " +cSC9Tbl+ " B WHERE B.D_E_L_E_T_ = '*' "
			cQry += "AND B.C9_FILIAL = '" +cSC9Fil+ "' " 
			cQry += "AND B.C9_PEDIDO = '" +aPeds[nNx]+ "' "
			cQry += "AND B.C9_ITEM = '" +AWRK->AC9ITEM+ "' "
			cQry += "AND B.C9_PRODUTO = '" +AWRK->AC9PRODUTO+ "' "
			cQry += "AND B.C9_SEQUEN = '" +AWRK->AC9SEQUEN+ "' "
			cQry += "AND B.C9_QTDLIB = " +Alltrim(Str(AWRK->AC9QTDLIB))+ " "
			cQry += "ORDER BY B.R_E_C_N_O_ DESC "

			Iif(Select("BWRK")>0,BWRK->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"BWRK",.T.,.T.)
			TcSetField("BWRK", "BSC9RCN", "N", 14, 0 )
			BWRK->(dbGoTop())

			If BWRK->(!EoF())
				If BWRK->BSC9RCN > 0

					cQry := "UPDATE " +cSC9Tbl+ " SET "
					cQry += "C9_PEDORI = '" +BWRK->BC9PEDORI+ "', "
					cQry += "C9_ORDSEP = '" +BWRK->BC9XORDSEP+ "', "
					cQry += "C9_NUMOF = '"  +BWRK->BC9NUMOF+ "', "
					cQry += "C9_CLIORI = '" +BWRK->BC9CLIORI+ "', "
					cQry += "C9_LOJORI = '" +BWRK->BC9LOJORI+ "', "
					cQry += "C9_NOMORI = '" +BWRK->BC9NOMORI+ "', "
					cQry += "C9_XORDSEP = '' "
					cQry += "WHERE R_E_C_N_O_ = " +Alltrim(Str(AWRK->ASC9RCN))

					aAdd( aUpd, cQry )

				EndIf
			EndIf
			BWRK->(dbSkip())

		EndIf
		AWRK->(dbSkip())
	EndDo
	AWRK->(dbCloseArea())

Next nNx

If Len(aUpd) > 0

	BeginTran()
	
	For nNx := 1 to Len(aUpd)
		If TcSqlExec(aUpd[nNx]) <> 0
			lDArm := .T.
		EndIf
	Next nNx

	If lDArm
		DisarmTransaction()
	EndIf

	EndTran()

EndIf

Return(Nil)
