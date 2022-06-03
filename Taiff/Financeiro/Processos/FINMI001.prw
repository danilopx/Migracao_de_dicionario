#Include "Protheus.ch"
#Include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "msgraphi.ch"
#INCLUDE "APWIZARD.CH"
#define CLR_LIGHTRED 256
#define CLR_LIGHTGREEN 65536
#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINMI001 ³ Autor ³Thiago Comelli    (VETI)  ³ Data ³19/10/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FINMI001(cCliente, cLoja, cVisualiza)

	local aArea			:= GetArea()
	Local _aHeader		:= {}
	Local _aCols		:= {}
	Local _aAuxi		:= {}
	Local i				:= 1
	//Local nTamPad		:= 1 	 //Tamanho padrão das colunas, utilizado para centralizar as informações
	Local _cMsg			:= ""
	//Local aAlter     	:= {}
	//Local cLinhaOk   	:= ""    // Funcao executada para validar o contexto da linha atual do aCols
	//Local cTudoOk    	:= ""    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	//Local cIniCpos   	:= ""    // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	Local nFreeze    	:= 0
	Local nMax       	:= 999   // Numero maximo de linhas permitidas. Valor padrao 99
	//Local cCampoOk   	:= ""    // Funcao executada na validacao do campo
	//Local cSuperApagar	:= ""    // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	//Local cApagaOk   	:= ""    // Funcao executada para validar a exclusao de uma linha do aCols

	Local nLd 			:= -12 // Variavel implementada para o PROTHEUS 12
	Local x				:= 0

	/* Variaveis criadas para o projeto Financeiro sobre o limite de crédito */
	/* Data: 08/06/2020                               Responsável: Carlos Torres*/
	LOCAL NVLPEDABE		:= 0	// Valor de pedido aberto
	LOCAL NCONTAEMP 	:= 0	// Quantidade de empresas participantes em SZA
	//LOCAL NPOSTOPX 		:= 0	// Linha inicial área trabalho.
	//LOCAL NPOSTOPY		:= 0	// Coluna inicial área trabalho.
	//LOCAL NPOSBTTX		:= 0	// Linha final área trabalho.
	//LOCAL NPOSBTTY		:= 0	// Coluna final área trabalho.
	LOCAL lBTNAPR 		:= .T.  // Quando .T. Habilita o botão "Aprovar" e desabilita o botão "Bloquear"
	//LOCAL NEXTDIR 		:= 0	// Variavel conterá a extremidade direita do browse da tabela ZSA
	LOCAL lBTNFTR		:= .T.  // Quando .F. desabilita os botões "Aprovar" e "Bloquear" para pedido que está faturado
	/* fim da criação de variavies do projeto Financeiro */

	LOCAL cArqLog 	:= "FINANCEIRO_LOG_ANALISE_CREDITO_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
	LOCAL cTEXTO1	:= ""

	Private nOpcA		:= 0
	Private aSize	  	:= MsAdvSize(.T.,,) //parametro 1 = Usa Enchoice? -- parametro 2 = Deixar em Branco -- Parametro 3 = altura minima da tela
	Private lTFc5stcross:= .T. // Permite alteração do campo C5_STCROSS  
	
	SetPrvt("oFont1","oFont2","oFont3","oBtn1","oBtn2","oBtn3")
	oFont1     := TFont():New( "Arial",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont2     := TFont():New( "Arial",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
	oFont3     := TFont():New( "Arial Narrow",0,-16,,.F.,0,,400,.F.,.F.,,,,,, )

	//MESSAGEBOX("Cliente: " + cCliente + " / Loja: " + cLoja, "Teste", 16) 
	
	If !(cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT08",.F.,"")
		MsgStop("Rotina não permitida nesta Empresa / Filial","FINMI001 - MV__MULT08")
		Return Nil
	EndIf

	If !VerSenha(136) //verifica se o usuario logado possui acesso 136-Lib.Pedido Venda
		MsgStop("Usuário sem acesso","Acesso nao permitido")
		Return Nil
	EndIf
	
	/*
	|---------------------------------------------------------------------------------
	|	Não permite analisar pedidos SP em MG
	|---------------------------------------------------------------------------------
	*/
	IF CEMPANT + CFILANT != SC5->C5_EMPDES + SC5->C5_FILDES
		MESSAGEBOX("Análise de Crédito deve ser realizada na" + ENTER + "Empresa/Filial Destino do Pedido de Venda!","ATENÇÃO",16)
	ENDIF 
	IF CEMPANT = "03" .AND. CFILANT = "01" .AND. .NOT. (EMPTY(SC5->C5_STCROSS) .OR. ALLTRIM(SC5->C5_STCROSS) $ "ABERTO|AGCOPY")  
		lTFc5stcross := .F.
	ENDIF 

	/******************************************************************************************
	| Força um dbSelectArea no cliente, pois quando utiliza o botão [Posição Cliente], 
	| que utiliza função padrão do Protheus, está posicionando no primeiro registro da SA1
	| este problema somente passou a acontecer na versão 12.  
	*******************************************************************************************/
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
	/******************************************************************************************/

	/* Funcionalidade do projeto Financeiro sobre o limite de crédito */
	/* Data: 08/06/2020                               Responsável: Carlos Torres*/
	/* Inclusão do campo relativo ao pedido de vendas em aberto no _aCols[11] */


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta coluna do aCols padrão.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aAuxi:= {	"Cadastrado Desde",;
				"Última Compra",;
				"Maior Compra",;
				"Rentabilidade (R2)",;
				"Canal",;
				"Limite de Credito",;
				"Limite Disponivel",;
				"Titulos a Vencer",;
				"Titulos Vencidos",;
				"Titulos Perdidos",;
				"Ped. abertos a prazo",;
				"Ped. abertos a vista",;
				"R$ Total Vendas",;
				"R$ Total Bonificações",;
				"R$ Total Verbas",;
				"R$ Total Devoluções",;
				"",;
				"% Bonificado s/ Venda",;
				"% de Devolução s/ Venda",;
				"% de Verba s/ Venda",;
				"Prazo Medio",;
				"Atraso Medio",;
				"Faturamento Medio",;
				"",;
				"Analise Pedido Atual",;
				"Valor do pedido",;
				"Simulação",;
				"Status"}

	dbSelectArea("SM0")
	SM0->(dbGoTop())
	DbSelectArea("SZB")
	SZB->(DbSetOrder(1))

	Aadd(_aHeader,{ "INFORMAÇÃO", "COLUNA1", "@!",;
		20, 0,"",;
		"","C", "", "", "", "" } )

	While !SM0->(Eof())
		If(SZB->(dbSeek(xFilial("SZB")+Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL))))
			AADD(_aHeader,{Alltrim(SM0->M0_NOME) +" / "+ Alltrim(SM0->M0_FILIAL),"EMP"+Alltrim(SM0->M0_CODIGO)+Alltrim(SM0->M0_CODFIL) ,"@!",25,0,"","°","C", "", "", "", "" })
		EndIf
		SM0->(DbSkip())
	EndDo

//Cria array com o tamanho das posições do acols
	_aCols := Array(Len(_aAuxi),Len(_aHeader)+1)

//Prenche primeira coluna do Acols.
	aEval(_aCols,{|x| x[1]:=_aAuxi[i++]})
	aEval(_aCols,{|x| x[Len(_aHeader)+1]:= .F.})

	For x:=2 to Len(_aHeader)
		_aCols[01][x]:= ""		  //Cadastrado Desde
		_aCols[02][x]:= ""		  //Ultima Compra
		_aCols[03][x]:= ""		  //Maior Compra
		_aCols[04][x]:= "0,00"	  //Rentabilidade (R2)
		_aCols[05][x]:= ""		  //Canal
		_aCols[06][x]:= "0,00" 	  //Limite de Credito
		_aCols[07][x]:= "0,00" 	  //Limite Disponivel
		_aCols[08][x]:= "0,00"	  //Titulos a Vencer
		_aCols[09][x]:= "0,00"	  //Titulos Vencidos
		_aCols[10][x]:= "0,00"	  //Titulos Perdidos
		_aCols[11][x]:= "0,00"	  //Perdidos abertos somente a Prazo
		_aCols[12][x]:= "0,00"	  //Perdidos abertos somente a Vista
		_aCols[13][x]:= "0,00"	  //Valor Total de Vendas
		_aCols[14][x]:= "0,00"	  //Valor Total de Bonificacao
		_aCols[15][x]:= "0,00"	  //Valor Total de Verbas
		_aCols[16][x]:= "0,00"	  //Valor Total de Devolucao
		_aCols[17][x]:= ""
		_aCols[18][x]:= "0,0"+"%" //Percentual Bonificado sobre Venda
		_aCols[19][x]:= "0,0"+"%" //Percentual de Devolução sobre Venda
		_aCols[20][x]:= "0,0"+"%" //Percentual de Verba sobre Venda
		_aCols[21][x]:= "0"	 	  //Prazo Medio
		_aCols[22][x]:= "0" 	  //Atraso Medio
		_aCols[23][x]:= "0,00"	  //Faturamento Medio
		_aCols[24][x]:= ""
		_aCols[25][x]:= ""		  //Analise Pedido Atual
		_aCols[26][x]:= ""		  //Valor Pedido
		_aCols[27][x]:= ""		  //Simulacao
		_aCols[28][x]:= ""		  //Status
	Next

	BeginSql alias 'SZACONS'
		SELECT SZA.*
		FROM %table:SZA% SZA
		INNER JOIN %table:SA1% A1 
		   ON A1.%NotDel% 
		  AND A1.A1_COD = %exp:cCliente% 
		  AND A1.A1_LOJA = %exp:cLoja% 
		  AND A1.A1_FILIAL = %xfilial:SA1% // incluído por Gilberto, estava triplicando os registros
		  AND A1.A1_EST <> 'EX'
		WHERE SZA.ZA_CNPJRZ = CASE A1.A1_PESSOA WHEN 'J' THEN 
		  						 SUBSTRING(A1.A1_CGC, 1 , LEN(A1.A1_CGC) - 6)
		  					  WHEN 'F' THEN 
		  					  	 SUBSTRING(A1.A1_CGC , 1 , 11) 
		  					  END
		  AND SZA.ZA_FILIAL = %xfilial:SZA%
		  AND SZA.%NotDel%
	EndSql

	If SZACONS->(Eof())
		MsgAlert("Cliente não gerou dados para analise de crédito!")
		SZACONS->(DbCloseArea())
		If FUNNAME() $  "MATA415"
			If SCJ->CJ_XLIBCR != "L"
				If MsgYesNo("Libera o credito do orçamento selecionado?",FunName())
					cUpdate := "UPDATE SCJ SET "
					cUpdate += "	CJ_XLIBCR = 'L' "
					cUpdate += " FROM " + RetSqlName("SCJ") + " SCJ WITH(NOLOCK) "
					cUpdate += " WHERE CJ_NUM = '" + SCJ->CJ_NUM + "' "
					cUpdate += "   AND CJ_FILIAL = '" + xFilial("SCJ") + "' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					TCSqlExec(cUpdate)
				EndIf
			Else
				If MsgYesNo("Bloqueia o credito do orçamento selecionado?",FunName())
					cUpdate := "UPDATE SCJ SET "
					cUpdate += "	CJ_XLIBCR = 'P' "
					cUpdate += " FROM " + RetSqlName("SCJ") + " SCJ WITH(NOLOCK) "
					cUpdate += " WHERE CJ_NUM = '" + SCJ->CJ_NUM + "' "
					cUpdate += "   AND CJ_FILIAL = '" + xFilial("SCJ") + "' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					TCSqlExec(cUpdate)
				EndIf
			EndIf	
		ElseIf FUNNAME() $  "MATA410"
			If SC5->C5_XLIBCR != "L"
				If MsgYesNo("Libera o credito do pedido selecionado?",FunName())
					cUpdate := "UPDATE SC5 SET "
					cUpdate += "	C5_XLIBCR = 'L' "
					cUpdate += " FROM " + RetSqlName("SC5") + " SC5 WITH(NOLOCK) "
					cUpdate += " WHERE C5_NUM = '" + SC5->C5_NUM + "' "
					cUpdate += "   AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					TCSqlExec(cUpdate)

					cUpdate := "UPDATE SC9 SET "
					cUpdate += "	C9_BLCRED = '' "
					cUpdate += " FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
					cUpdate += " WHERE C9_PEDIDO	= '" + SC5->C5_NUM + "' "
					cUpdate += "   AND C9_FILIAL	= '" + xFilial("SC9") + "' "
					cUpdate += "   AND C9_NFISCAL	= '' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					TCSqlExec(cUpdate)
				EndIf
			Else
				If MsgYesNo("Bloqueia o credito do pedido selecionado?",FunName())
					cUpdate := "UPDATE SC5 SET "
					cUpdate += "	C5_XLIBCR = 'P' "
					cUpdate += " FROM " + RetSqlName("SC5") + " SC5 WITH(NOLOCK) "
					cUpdate += " WHERE C5_NUM = '" + SC5->C5_NUM + "' "
					cUpdate += "   AND C5_FILIAL = '" + SC5->C5_FILIAL + "' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					cUpdate += "   AND 0 = ( "
					cUpdate += "		SELECT COUNT(*) FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) " 
					cUpdate += "		WHERE C9_PEDIDO	= '" + SC5->C5_NUM + "' "
					cUpdate += "		AND C9_FILIAL	= '" + SC5->C5_FILIAL + "' "
					cUpdate += "		AND D_E_L_E_T_ != '*'"
					cUpdate += "   ) "
					TCSqlExec(cUpdate)

					/* log temporario */	
					cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
					cTEXTO1 += "FINMI001 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
					cTEXTO1 += " PEDIDO=" + SC5->C5_NUM  + ENTER
					cTEXTO1 += " FILIAL=" + SC5->C5_FILIAL  + ENTER
					cTEXTO1 += "GRAVA EM SC5->C5_XLIBCR := P" + ENTER
					MEMOWRITE(cArqLog,cTEXTO1)
					/* log temporario */	

					cUpdate := "UPDATE SC9 SET "
					cUpdate += "	C9_BLCRED = '09' "
					cUpdate += " FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
					cUpdate += " WHERE C9_PEDIDO	= '" + SC5->C5_NUM + "' "
					cUpdate += "   AND C9_FILIAL	= '" + SC5->C5_FILIAL + "' "
					cUpdate += "   AND C9_NFISCAL	= '' "
					cUpdate += "   AND D_E_L_E_T_ != '*'"
					TCSqlExec(cUpdate)
				EndIf
			EndIf	
		EndIf
		
		Return .T.
		
	EndIf
	NCONTAEMP := 0
	While !SZACONS->(EOF())
		/*GRAVA CAMPOS DO ACOLS*/
		_nPos:= aScan( _aHeader, {|x| AllTrim(x[2]) == "EMP"+Alltrim(SZACONS->ZA_EMPRES)+Alltrim(SZACONS->ZA_FILEMP)})
		_aCols[01][_nPos]:= DTOC(STOD(SZACONS->ZA_DTCAD))	//Cadastrado Desde
		_aCols[02][_nPos]:= Substr(SZACONS->ZA_DTUCOM,7,2)+"/"+Substr(SZACONS->ZA_DTUCOM,5,2)+"/"+Substr(SZACONS->ZA_DTUCOM,3,2)+" - "+AllTrim(TRANSFORM( SZACONS->ZA_VLULCO ,'@E 999,999,999.99' ))+" ("+Alltrim(SZACONS->ZA_CDULCO)+")" //Ultima Compra
		_aCols[03][_nPos]:= Substr(SZACONS->ZA_DTMACO,7,2)+"/"+Substr(SZACONS->ZA_DTMACO,5,2)+"/"+Substr(SZACONS->ZA_DTMACO,3,2)+" - "+AllTrim(TRANSFORM( SZACONS->ZA_VLMACO ,'@E 999,999,999.99' ))+" ("+Alltrim(SZACONS->ZA_CDMACO)+")"//Maior Compra
		_aCols[04][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_RENTAB,'@E 999,999,999.99' ))//Rentabilidade (R2)
		_aCols[05][_nPos]:= Substr(SZACONS->ZA_CANAL,2,49)	//Canal
		_aCols[06][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_LIMCRD,'@E 999,999,999.99' ))+" - "+Substr(SZACONS->ZA_CANAL,1,1) //Limite de Credito
		_aCols[07][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_LIMDSP,'@E 999,999,999.99' )) //Limite Disponivel
		_aCols[08][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTVEN ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTVEN))+")"	//Titulos a Vencer
		_aCols[09][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTVEC ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTVEC))+")"	//Titulos Vencidos
		_aCols[10][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTPRD ,'@E 999,999,999.99'))+" ("+Alltrim(Str(SZACONS->ZA_QTTPRD))+")"	//Titulos Perdidos

		_aCols[13][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTTVE ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTTVE))+")"//Valor Total de Vendas
		_aCols[14][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTTBN ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTTBN))+")"	//Valor Total de Bonificacao
		_aCols[15][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTTVB ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTTVB))+")"	//Valor Total de Verbas
		_aCols[16][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_VLTTDV ,'@E 999,999,999.99' ))+" ("+Alltrim(Str(SZACONS->ZA_QTTTDV))+")"	//Valor Total de Devolucao
		_aCols[17][_nPos]:= ""
		_aCols[18][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_PERBN,'@E 999.9'))+"%"	//Percentual Bonificado sobre Venda
		_aCols[19][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_PERDV,'@E 999.9'))+"%"	//Percentual de Devolução sobre Venda
		_aCols[20][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_PERVB,'@E 999.9'))+"%"	//Percentual de Verba sobre Venda
		_aCols[21][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_PRZMED,'@E 999,999'))//Prazo Medio
		_aCols[22][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_ATZMED,'@E 999,999'))//Atraso Medio
		_aCols[23][_nPos]:= AllTrim(TRANSFORM( SZACONS->ZA_FATMED,'@E 999,999,999.99' ))	//Faturamento Medio
		_aCols[24][_nPos]:= ""
		_aCols[25][_nPos]:= ""			//Analise Pedido Atual

		If Alltrim(SZACONS->ZA_EMPRES) == IIF(FUNNAME() $ "MATA410", SC5->C5_EMPDES, SCJ->CJ_EMPDES) .AND.;
	 	   Alltrim(SZACONS->ZA_FILEMP) == IIF(FUNNAME() $ "MATA410", SC5->C5_FILDES, SCJ->CJ_FILDES)

			If FUNNAME() $ "MATA410"
				aAvalCr := U_FATMI002(2,SC5->C5_NUM, cVisualiza)
				lBTNAPR := IIF( SC5->C5_XLIBCR = "L" , .F., .T.)
				lBTNFTR	:= U_MI1FATUR( SC5->C5_NOTA )
			ElseIf FUNNAME() $ "MATA415/MATA416"
				aAvalCr := U_FATMI002(1,SCJ->CJ_NUM, cVisualiza)
				lBTNAPR := IIF( SCJ->CJ_XLIBCR = "L" , .F., .T.)
				lBTNFTR	:= .T.
			Else
				aAvalCr := {0,"PC"}
			EndIf

			_aCols[26][_nPos]:= AllTrim(TRANSFORM(aAvalCr[1],'@E 999,999,999.99' ))	//Valor Pedido
			_aCols[27][_nPos]:= AllTrim(TRANSFORM(SZACONS->ZA_LIMDSP - aAvalCr[1],'@E 999,999,999.99' ))	//Simulacao
			_aCols[28][_nPos]:= IIF(aAvalCr[2] = "L","APROVADO",IIF(aAvalCr[2] = "PC","CADASTRO DE CLIENTE",IIF(aAvalCr[2] $ "B/M","REPROVADO","")))	//Status

		Else
			_aCols[26][_nPos]:= ""	//Valor Pedido
			_aCols[27][_nPos]:= ""	//Simulacao
			_aCols[28][_nPos]:= ""	//Status
		EndIf
		
		NVLPEDABE := U_FINPEDABE( Alltrim(SZACONS->ZA_EMPRES), Alltrim(SZACONS->ZA_FILEMP),SZACONS->ZA_CNPJRZ,"P" )

		_aCols[11][_nPos]:= AllTrim(TRANSFORM( NVLPEDABE ,'@E 999,999,999.99')) //Perdidos Abertos somente a Prazo

		NVLPEDABE := U_FINPEDABE( Alltrim(SZACONS->ZA_EMPRES), Alltrim(SZACONS->ZA_FILEMP),SZACONS->ZA_CNPJRZ,"A" )

		_aCols[12][_nPos]:= AllTrim(TRANSFORM( NVLPEDABE ,'@E 999,999,999.99')) //Perdidos Abertos somente a Vista

		NCONTAEMP += 1

		SZACONS->(dbSkip())
	EndDo

	//F5 - PARA DETALHES DOS CAMPOS
	SetKey(VK_F5, { || lKey:= .F., Detalhes(_aCols,oGetd),lKey:= .T. })


	//F5 - PARA DETALHES DOS CAMPOS
	SetKey(VK_F5, { || lKey:= .F., Detalhes(_aCols,oGetd),lKey:= .T. })
	DEFINE MSDIALOG oDlg TITLE "Analise de Credito" From oMainWnd:nTop , oMainWnd:nLeft to IIF((oMainWnd:nBottom - 30 + nLd) < 570, 570,oMainWnd:nBottom - 30 + nLd)  , oMainWnd:nRight -15 of oMainWnd PIXEL COLOR CLR_BLACK,CLR_WHITE
	oGetd := 	MsNewGetDados():New(oDlg:nTop + 1 , oDlg:nLeft + 2 , oDlg:nTop + 243 + nLd , oDlg:nRight/2 ,,,,,,nFreeze,nMax,,,,oDlg,_aHeader,_aCols)
	oGetd:oBrowse:lJustific := .F.
	oGetd:oBrowse:lUseDefaultColors := .F.
	oGetd:oBrowse:SetBlkBackColor({|| GETDCLR(oGetd:aCols,oGetd:nAt,_aHeader)})
	oGetd:EditCell()
	If FUNNAME() $  "MATA415/MATA416/MATA410"
		oSay1      := TSay():New( oDlg:nTop + 243 + nLd,002,{||"Observações:"},oDlg,,oFont3,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,012)
		@ oDlg:nTop + 254 + nLd, oDlg:nLeft + 002 GET oMemo VAR _cMsg MEMO SIZE 300, 040 OF oDlg PIXEL
		oBtn1      := TButton():New( oDlg:nTop + 254+ nLd, oDlg:nLeft + 310,"Aprovar Crédito",oDlg,{|| Aprova(_cMsg) },072,016,,oFont1,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( oDlg:nTop + 254+ nLd, oDlg:nLeft + 385,"Bloquear Crédito",oDlg,{|| Bloqueia(_cMsg) },072,016,,oFont2,,.T.,,"",,,,.F. )
	EndIf
	oBtn3      := TButton():New( oDlg:nTop + 254+ nLd, oDlg:nLeft + 460,"Posição Cliente",oDlg,{|| a450F4Con() },072,016,,oFont3,,.T.,,"",,,,.F. )
	
	If cVisualiza = "S"
		oBtn4      := TButton():New( oDlg:nTop + 254+ nLd, oDlg:nLeft + 535,"Sair sem avaliar",oDlg,{|| oDlg:End() },072,016,,oFont3,,.T.,,"",,,,.F. )
	Else
		oBtn4      := TButton():New( oDlg:nTop + 254+ nLd, oDlg:nLeft + 535,"Fechar"	      ,oDlg,{|| oDlg:End() },072,016,,oFont3,,.T.,,"",,,,.F. )
	EndIf
	
	ACTIVATE DIALOG oDlg //center
	
	IF SELECT("SZACONS") > 0 
		SZACONS->(dbCloseArea())
	ENDIF 
	RestArea(aArea)
Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\æ
//³Função para cores do GetDados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\æ

Static Function GETDCLR(aLinha,nLinha,aHeader)

	Local nPosIni := aScan(aHeader,{|x| Alltrim(x[2]) == "COLUNA1"})
	Local nPosEmp := aScan(aHeader,{|x| Alltrim(x[2]) == "EMP"+IIf( FUNNAME()="MATA030",cEmpAnt+cFilAnt,IIF(FUNNAME() $ "MATA410",SC5->C5_EMPDES,SCJ->CJ_EMPDES)+IIF(FUNNAME() $ "MATA410",SC5->C5_FILDES,SCJ->CJ_FILDES))})
	Local nRet := CLR_WHITE
	Local x	:= 0
	Local y := 0

	If aLinha[nLinha][nPosIni] == "" //Linha Cinza para Salto de Linha
		nRet := CLR_LIGHTGRAY
	ElseIf aLinha[nLinha][nPosIni] $ "Status" .AND. AllTrim(aLinha[nLinha][nPosEmp]) $ "REPROVADO" //Linha Vermelha para Reprovado
		nRet := CLR_HRED
	ElseIf aLinha[nLinha][nPosIni] $ "Status" .AND. AllTrim(aLinha[nLinha][nPosEmp]) $ "APROVADO" //Linha Verde para Aprovado
		nRet := CLR_HGREEN
	ElseIf aLinha[nLinha][nPosIni] $ "Titulos Vencidos"
		For x:=2 to Len(aHeader)
			If Substr((aLinha[nLinha][x]),1,1) <> "0" //Linha Vermelho para problemas com Titulos Vencidos
				nRet := CLR_HRED
			EndIf
		Next
	ElseIf aLinha[nLinha][nPosIni] $ "Titulos Perdidos"
		For y:=2 to Len(aHeader)
			If Substr((aLinha[nLinha][y]),1,1) <> "0" //Linha Vermelho para problemas com Titulos Perdidos
				nRet := CLR_HRED
			EndIf
		Next
	ElseIf aLinha[nLinha][nPosIni] $ "Limite Disponivel"
		For x:=2 to Len(aHeader)
			If Substr((aLinha[nLinha][x]),1,1) < "0" //Linha Vermelho para problemas com Limite de Crédito
				nRet := CLR_HRED
			EndIf
		Next
	EndIf

Return nRet

/*----------------------------------
REALIZA APROVAÇÃO DO CREDITO
-----------------------------------*/
Static Function Aprova(cObs)

Local aAreaSC5		:= SC5->(GETAREA())
Local aAreaSC6		:= SC6->(GETAREA())
Local aAreaSM0		:= SM0->(GETAREA())
LOCAL LINTERC		:= .F.
LOCAL cArqLog 	:= "FINANCEIRO_LOG_ANALISE_CREDITO_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
LOCAL cTEXTO1	:= ""

	/*
	|---------------------------------------------------------------------------------
	|	REALIZA A VERIFICACAO DA TABELA DE PRECOS DE TRANSFERENCIA
	|	EDSON HORNBERGER - 05/11/2015
	|---------------------------------------------------------------------------------
	*/	
	IF CEMPANT + CFILANT = "0301" .AND. ((FUNNAME() $ "MATA410" .AND. ALLTRIM(SC5->C5_CLASPED) $ 'V|X') .OR. (FUNNAME() $ "MATA415/MATA416" .AND. ALLTRIM(SCJ->CJ_XCLASPD) $ 'V|X'))
		
		SM0->(DbSeek( CEMPANT + CFILANT ))
		
		CQUERY := "SELECT SA1.A1_TABELA FROM " + RETSQLNAME("SA1") + " SA1 WHERE SA1.A1_FILIAL = '02' AND SA1.A1_CGC = '" + SM0->M0_CGC + "' AND SA1.D_E_L_E_T_ = ''"
		
		IF SELECT("TMP") > 0
			
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
			
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		COUNT TO NREGS
		
		IF NREGS > 0
		
			TMP->(DBGOTOP())
			If FUNNAME() $ "MATA415/MATA416"
				_LRET := ORCAMTAB(TMP->A1_TABELA,SCJ->CJ_NUM)
			Else
				_LRET := VERIFTAB(TMP->A1_TABELA,SC5->C5_NUM)
			EndIf
		
			IF !_LRET
				
				MSGINFO("Existem Produtos sem Tabela de Preço para Transferência!","Processo CrossDocking")
				MSGINFO("Processo de Liberação de Crédito deverá ser realizado novamente após cadastro correto!","Processo CrossDocking")
				RESTAREA(AAREASC5)
				RESTAREA(AAREASC6)
				RESTAREA(AAREASM0)
				
				oDlg:End()
				
			ENDIF 
			
		ELSE
			
			MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")
			MSGINFO("Processo de Liberação de Crédito deverá ser realizado novamente após cadastro correto!","Processo CrossDocking")
			RESTAREA(AAREASC5)
			RESTAREA(AAREASC6)
			RESTAREA(AAREASM0)
			
			oDlg:End()
			
		ENDIF
		
	ENDIF
	 
	/*
	|---------------------------------------------------------------------------------
	|	Realiza a validacao do Cliente verificando se eh do Grupo.
	|---------------------------------------------------------------------------------
	*/
	
	CQUERY := "SELECT '.T.' AS EXISTE FROM SM0_COMPANY WHERE M0_CGC = '" + POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC") + "'"
	IF SELECT("EMP") > 0 
		DBSELECTAREA("EMP")
		DBCLOSEAREA()
	ENDIF 
	TCQUERY CQUERY NEW ALIAS "EMP"
	DBSELECTAREA("EMP")
	DBGOTOP()
	LINTERC := EMP->EXISTE
	LINTERC := IIF(EMPTY(ALLTRIM(LINTERC)),.F.,.T.)	

	If FUNNAME() $ "MATA410"
		If RecLock("SC5",.F.)
			SC5->C5_XLIBCR := "L" //Orcamento liberado
			MsUnlock()

			/* log temporario */	
			cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
			cTEXTO1 += "FINMI001 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
			cTEXTO1 += " PEDIDO=" + SC5->C5_NUM  + ENTER
			cTEXTO1 += " FILIAL=" + SC5->C5_FILIAL  + ENTER
			cTEXTO1 += "GRAVA EM SC5->C5_XLIBCR := L" + ENTER
			MEMOWRITE(cArqLog,cTEXTO1)
			/* log temporario */	


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava Log na tabela SZC³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cAlias		:= "SC5"
			_cChave		:= xFilial("SC5")+SC5->C5_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= "14 - CREDITO LIBERADO MANUALMENTE - PEDIDO DE VENDA - Observacao do Usuário: "+cObs
			_cFuncao	:= "U_FINMI001"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

			U_TfGrvSC9("","09")

			U_FINMI003("L",SC5->C5_NUM)
		EndIf
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Processo de Cópia de Pedido de Venda no Novo Processo do CrossDocking
		|	Somente sera realizado na Empresa 01 e quando o Pedido de Venda foi incluido
		|	manualmente.
		|=================================================================================
		*/
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SC6") + SC5->C5_NUM) 
		
		IF (CEMPANT+CFILANT) = "0301" .AND. !LINTERC .AND. SC6->C6_LOCAL $ ("21") .AND. SC5->C5_CLASPED $ "V|X" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART"
			
			MSGRUN("Gerando cópia do Pedido de Venda para o CD de MG","Processando...",{|| MAKECOPY(SC5->C5_NUM, lTFc5stcross)})
			
		ELSEIF (CEMPANT+CFILANT) = "0301" .AND. !LINTERC .AND. !(SC6->C6_LOCAL $ ("21")) .AND. SC5->C5_CLASPED $ "V|X"  
			
			DBSELECTAREA("SC5")
			IF RECLOCK("SC5",.F.)
				
				SC5->C5_STCROSS := "" // Conteúdo vazio não 
				MSUNLOCK()
				
			ENDIF
			
		ENDIF 
		
	ElseIf FUNNAME() $ "MATA415/MATA416"
		If RecLock("SCJ",.F.)
			SCJ->CJ_XLIBCR := "L" //Orcamento liberado
			MsUnlock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava Log na tabela SZC³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+SCJ->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= "05 - CREDITO LIBERADO MANUALMENTE - ORCAMENTO - Observacao do Usuário: "+cObs
			_cFuncao	:= "U_FINMI001"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

		EndIf
	EndIf
	
	RESTAREA(AAREASC5)
	RESTAREA(AAREASC6)
	RESTAREA(AAREASM0)
	
	oDlg:End()
Return

/*----------------------------------
REALIZA BLOQUEIO DO CREDITO
------------------------------------*/
Static Function Bloqueia(cObs)

LOCAL NREGS 	:= 0 
LOCAL CQUERY	:= ""
LOCAL cPedNUMOLD:= ""
LOCAL cArqLog 	:= "FINANCEIRO_LOG_ANALISE_CREDITO_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
LOCAL cTEXTO1	:= ""

	If FUNNAME() $ "MATA410"
		IF (CEMPANT + CFILANT) != (SC5->C5_EMPDES + SC5->C5_FILDES)
			
			MSGALERT(OEMTOANSI(	"Este Pedido de Vendas deve ser Bloqueado na Filial Destino!")  + ENTER + ;
								"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
		
			/*
			|---------------------------------------------------------------------------------
			|	Verifica se o Pedido de Venda tem Liberação em Aberto. Caso tenha não permite 
			|	o Bloqueio de Crédito.
			|	Edson Hornberger - 27/11/15
			|---------------------------------------------------------------------------------
			*/
			 
			CQUERY := "SELECT" 												+ ENTER 
			CQUERY += "	COUNT(*)" 											+ ENTER 
			CQUERY += "FROM" 													+ ENTER
			CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 					+ ENTER
			CQUERY += "WHERE" 													+ ENTER 
			CQUERY += "	C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 	+ ENTER 
			CQUERY += "	C9_PEDIDO = '" + SC5->C5_NUM + "' AND" 		+ ENTER
			CQUERY += "	C9_NFISCAL = '' AND" 								+ ENTER 
			CQUERY += "	SC9.D_E_L_E_T_ = ''"
			
			IF SELECT("TMP") > 0 
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF 
					
			TCQUERY CQUERY NEW ALIAS "TMP" 
			DBSELECTAREA("TMP")
			DBGOTOP()
			COUNT TO NREGS
		ElseIf NREGS > 0 
				
				MSGINFO("Este Pedido de Venda está Liberado para Faturamento!" + ENTER + "O Departamento Comercial deve estornar a Liberação para que possa ser Bloqueado o Crédito!", "ATENÇÃO")
				Return
				
		
		Else
			cPedNUMOLD := SC5->C5_NUMOLD
			If RecLock("SC5",.F.)
			
				SC5->C5_XLIBCR := "B" //Pedido Bloqueado
				MsUnlock()
				/* log temporario */	
				cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
				cTEXTO1 += "FINMI001 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
				cTEXTO1 += " PEDIDO=" + SC5->C5_NUM  + ENTER
				cTEXTO1 += " FILIAL=" + SC5->C5_FILIAL  + ENTER
				cTEXTO1 += "GRAVA EM SC5->C5_XLIBCR := B" + ENTER
				MEMOWRITE(cArqLog,cTEXTO1)
				/* log temporario */	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava Log na tabela SZC³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cAlias		:= "SC5"
				_cChave		:= xFilial("SC5")+SC5->C5_NUM
				_dDtIni		:= Date()
				_cHrIni		:= Time()
				_cDtFim		:= CTOD("")
				_cHrFim		:= ""
				_cCodUser	:= __CUSERID
				_cEstacao	:= ""
				_cOperac	:= "13 - CREDITO BLOQUEADO MANUALMENTE - PEDIDO DE VENDA - Observacao do Usuário: "+cObs
				_cFuncao	:= "U_FINMI001"
				U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
	
				U_TfGrvSC9("09","")

				U_FINMI003("B",SC5->C5_NUM)

				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")               
				If DBSEEK( "02" + ALLTRIM( cPedNUMOLD ))
					If RecLock("SC5",.F.)
						SC5->C5_XLIBCR := "B" //Pedido Bloqueado
						MsUnlock()
						/* log temporario */	
						cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
						cTEXTO1 += "FINMI001 - Linha: " + alltrim(str(procline())) + " hora log: " + TIME() + ENTER
						cTEXTO1 += " GRAVA NA FILIAL 02 ATRAVES DO C5_NUMOLD " + cPedNUMOLD + ENTER
						cTEXTO1 += " PEDIDO=" + SC5->C5_NUM  + ENTER
						cTEXTO1 += " FILIAL=" + SC5->C5_FILIAL  + ENTER
						cTEXTO1 += "GRAVA EM SC5->C5_XLIBCR := B" + ENTER
						MEMOWRITE(cArqLog,cTEXTO1)
						/* log temporario */	
					EndIF
				EndIf
				SC5->(DbSetOrder(1))	
				//MsgRun("Enviando Workflow de Bloqueio de Crédito... Aguarde..." ,,{ || U_FATWF001(_cAlias,SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJA,cObs) })
	
			EndIf
			
			/*
			|=================================================================================
			|   COMENTARIO
			|---------------------------------------------------------------------------------
			|	Realiza se existe o Pedido de Venda na Empresa 03/02. Caso exista altera o 
			|	Bloqueio do Pedido no CD também.
			|
			|	Edson Hornberger - 29/09/2015
			|=================================================================================
			| UPDATE redundante por tanto comentei todas as linhas
			| Carlos Torres - 24/04/2020
			
			IF (CEMPANT + CFILANT) = "0301" .AND. SC5->C5_CLASPED != "A"
			
				CQUERY := "SELECT COUNT(*) AS QTDREG FROM "  + RETSQLNAME("SC5") + " WHERE C5_FILIAL = '02' AND C5_NUMORI = '" + SC5->C5_NUM + "' AND C5_CLIORI = '" + SC5->C5_CLIENTE + "' AND C5_LOJORI = '" + SC5->C5_LOJACLI + "' AND D_E_L_E_T_ = ''"
				
				IF SELECT("TMP") > 0 
					
					DBSELECTAREA("TMP")
					DBCLOSEAREA()
					
				ENDIF 
				
				TCQUERY CQUERY NEW ALIAS "TMP"
				DBSELECTAREA("TMP")
				DBGOTOP()
				COUNT TO NREGS
				
				IF NREGS > 0 
				
					CQUERY := "UPDATE " + RETSQLNAME("SC5") + " SET C5_XLIBCR = 'B' WHERE C5_FILIAL = '02' AND C5_NUMORI = '" + SC5->C5_NUM + "' AND C5_CLIORI = '" + SC5->C5_CLIENT + "' AND C5_LOJORI = '" + SC5->C5_LOJACLI + "' AND D_E_L_E_T_ = ''"

					IF TCSQLEXEC(CQUERY) != 0 
						
						MSGALERT(OEMTOANSI(	"Erro ao tentar Bloquear Pedido de Vendas no CD!")  + ENTER + ;
											"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
						
					ENDIF
					 
				ENDIF
				
				DBSELECTAREA("TMP")
				DBCLOSEAREA()
				
			ENDIF 
			*/
		
		ENDIF 
		
	ElseIf FUNNAME() $ "MATA415/MATA416"
		If RecLock("SCJ",.F.)
			SCJ->CJ_XLIBCR := "B" //Orcamento Bloqueado
			MsUnlock()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava Log na tabela SZC³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cAlias		:= "SCJ"
			_cChave		:= xFilial("SCJ")+SCJ->CJ_NUM
			_dDtIni		:= Date()
			_cHrIni		:= Time()
			_cDtFim		:= CTOD("")
			_cHrFim		:= ""
			_cCodUser	:= __CUSERID
			_cEstacao	:= ""
			_cOperac	:= "04 - CREDITO BLOQUEADO MANUALMENTE - ORCAMENTO - Observacao do Usuário: "+cObs
			_cFuncao	:= "U_FINMI001"
			U_FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)

			//MsgRun("Enviando Workflow de Bloqueio de Crédito... Aguarde..." ,,{ || U_FATWF001(_cAlias,SCJ->CJ_NUM,SCJ->CJ_CLIENTE,SCJ->CJ_LOJA,cObs) })

		EndIf
	EndIf

	oDlg:End()
Return

/*
Função: TfGrvSC9
Objetivo: Intervir no pedido liberado após ação da área de credito quando libera credito
Autor: CT                                                       Data: 01/01/2013
*---------------------------------ALTERACOES----------------------------------------------*
* DATA       AUTOR       OBJETIVO                                                         *
*----------- ----------- -----------------------------------------------------------------*
*09/01/2015	CT         Implementar ação na tabela SC9 quando ocorre bloqueio de credito *
*******************************************************************************************
*/
User Function TfGrvSC9(__cBLCRED,__cAntBLCRED)
	Local _cQuery := ""
	
	_cQuery := "	UPDATE SC9 SET "
	_cQuery += "			C9_BLCRED ='"+__cBLCRED+"' "
	_cQuery += "	FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
	_cQuery += "	WHERE SC9.D_E_L_E_T_=' ' "
	_cQuery += "	AND SC9.C9_FILIAL='" + xFilial("SC9") + "' "
	_cQuery += "	AND SC9.C9_NFISCAL=' ' "
	_cQuery += "	AND SC9.C9_BLCRED ='"+__cAntBLCRED+"' "
	_cQuery += "	AND SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' "

	TCSQLExec( _cQuery )

Return NIL

/*
=================================================================================
=================================================================================
||   Arquivo:	FINMI001.prw
=================================================================================
||   Funcao: 	MAKECOPY
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		FUNCAO PARA GERAR COPIA DE PEDIDO PARA A EMPRESA TAIFFPROART EXTREMA
|| 	PARA ATENDIMENTO NO PROCESSO DE CROSSDOCKING.
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	25/09/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION MAKECOPY(CPEDIDO,lTFc5stcross) 

LOCAL CQUERY 	:= ""
//LOCAL APEDIDO	:= {}
//LOCAL AVOL		:= {}
LOCAL ACABSC5	:= {}
LOCAL ADETSC6	:= {}
LOCAL ATMPSC6	:= {}
LOCAL NREGS		:= 0
LOCAL _CFILOLD 	:= CFILANT
LOCAL AAREA		:= GETAREA()
LOCAL AAREASC5	:= SC5->(GETAREA())
LOCAL AAREASC6	:= SC6->(GETAREA())
LOCAL LRET		:= .T.
LOCAL CPEDBON	:= ""

Local _nPosSM0	:= SM0->(Recno())
Local cPedPortalTa := ""
Local CC5NUMOLD		:= ""
Local NC5RECNO			:= 0
Local cC5transp 		:= ""
Local cA1transp 		:= ""
Local cC5trcnpj 		:= ""
Local cA1trcnpj 		:= ""  	
Local I := 0

PRIVATE LMSERROAUTO	:= .F.
PRIVATE NPOSPROD		:= 0
PRIVATE NPOSITEM		:= 0

DEFAULT lTFc5stcross := .T.
CURSORWAIT()
	
/*
|---------------------------------------------------------------------------------
|	REALIZA PESQUISA PELO NUMERO DO PEDIDO DO PORTAL NA EMPRESA TAIFFPROART
|	EXTREMA. CASO JA EXISTE NAO CONTINUA
|---------------------------------------------------------------------------------
*/
DBSELECTAREA("SC5")
DBSETORDER(1)
DBSEEK(XFILIAL("SC5") + CPEDIDO)

CQUERY := "SELECT COUNT(*) AS NCONT FROM " + RETSQLNAME("SC5") + " SC5 WHERE SC5.C5_FILIAL = '02' AND SC5.C5_NUMORI = '" + SC5->C5_NUM + "' AND SC5.D_E_L_E_T_ = ''"
IF SELECT("TMP") > 0 
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
	
ENDIF 
TCQUERY CQUERY NEW ALIAS "TMP"
DBGOTOP()

IF TMP->NCONT > 0 
	
	/*
	|---------------------------------------------------------------------------------
	|	SE JA EXISTE O PEDIDO DE VENDA NO CD ALTERA O STATUS DA LIBERACAO
	|---------------------------------------------------------------------------------
	*/
	MSGINFO("Pedido já existe na Empresa Taiff Extrema!","Processo CrossDocking")

	CC5NUMOLD	:= SC5->C5_NUMOLD
	NC5RECNO	:= SC5->(RECNO())
				
	DBSELECTAREA("SC5")
	DBORDERNICKNAME("SC5NUMOLD")               
	If DBSEEK( "02" + CC5NUMOLD )
		SC5->(RECLOCK("SC5",.F.))
		SC5->C5_XLIBCR := "L"
		SC5->(MSUNLOCK())
	EndIf

	SC5->(DbGoTo(NC5RECNO))
	
	If lTFc5stcross
		IF RECLOCK("SC5",.F.)
			
			SC5->C5_STCROSS := "ABERTO"
			MSUNLOCK()
			
		ENDIF 
	EndIf
		
	CURSORARROW()
	RETURN
		
ENDIF 

CQUERY := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_TIPO, SA1.A1_TABELA, SA1.A1_TRANSP FROM " + RETSQLNAME("SA1") + " SA1 WHERE SA1.A1_FILIAL = '02' AND SA1.A1_CGC = (SELECT M0_CGC FROM SM0_COMPANY WHERE M0_CODIGO = '" + CEMPANT + "' AND M0_CODFIL = '" + CFILANT + "') AND SA1.D_E_L_E_T_ = ''"
IF SELECT("TMP") > 0
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
	
ENDIF
TCQUERY CQUERY NEW ALIAS "TMP"
DBSELECTAREA("TMP")
DBGOTOP()
COUNT TO NREGS

IF NREGS > 0
	
	TMP->(DBGOTOP())

	/*
	Tratamento especifico para quando há cliente atendido por transportadora 
	diferente do cadastro do cliente de CROSS DOCKING
	Ex.: ATIVA ou FRIBURGO
	*/
	cC5transp := SC5->C5_TRANSP
	cA1transp := TMP->A1_TRANSP
	
	cC5trcnpj := ""
	cA1trcnpj := ""  	
					
	SA4->(DbSetOrder(1))
	If SA4->(DbSeek( xFilial("SA4") + cC5transp ))
		cC5trcnpj := LEFT(SA4->A4_CGC,6)
	EndIf
	If SA4->(DbSeek( xFilial("SA4") + cA1transp ))
		cA1trcnpj := LEFT(SA4->A4_CGC,6)
	EndIf
	If cA1trcnpj != cC5trcnpj 
		SA4->(DbSetOrder(3))
		SA4->(DbSeek( xFilial("SA4") + cC5trcnpj ))
		While !SA4->(Eof()) .AND. LEFT(SA4->A4_CGC,6) = cC5trcnpj
			If SA4->A4_EST = "MG" .AND. SA4->A4_MSBLQL="2"
				cA1transp := SA4->A4_COD
			EndIf
			SA4->(DbSkip())
	 	End
	EndIf
	/* -----------------[ fim tratamento transportadora ]-----------------*/
	
	/*
	|---------------------------------------------------------------------------------
	|	PRENCHIMENTO DO CABECALHO DO PEDIDO DE VENDA - COPIA PARA CROSSDOCKING
	|	UTILIZANDO O CLIENTE TAIFFPROART MATRIZ
	|---------------------------------------------------------------------------------
	*/
	AADD(ACABSC5,{"C5_TIPO"		,SC5->C5_TIPO			})
	AADD(ACABSC5,{"C5_CLIENTE"	,TMP->A1_COD			})
	AADD(ACABSC5,{"C5_TIPOCLI"	,TMP->A1_TIPO			})
	AADD(ACABSC5,{"C5_LOJACLI"	,TMP->A1_LOJA			})
	AADD(ACABSC5,{"C5_CLIENT"		,TMP->A1_COD 	     	})
	AADD(ACABSC5,{"C5_LOJAENT"	,TMP->A1_LOJA			})
	AADD(ACABSC5,{"C5_EMISSAO"	,DDATABASE				})
	AADD(ACABSC5,{"C5_VEND1"		,SC5->C5_VEND1			})
	AADD(ACABSC5,{"C5_DESC1"		,SC5->C5_DESC1			})
	AADD(ACABSC5,{"C5_TPFRETE"	,"C"					})
	AADD(ACABSC5,{"C5_FINALID"	,"2"					})
	AADD(ACABSC5,{"C5_INTER"  	,"S"					})
	AADD(ACABSC5,{"C5_CLASPED"	,SC5->C5_CLASPED		})
	AADD(ACABSC5,{"C5_FILDES"		,SC5->C5_FILDES		})
	AADD(ACABSC5,{"C5_PCFRETE"	,SC5->C5_PCFRETE		})
	AADD(ACABSC5,{"C5_EMPDES"		,SC5->C5_EMPDES		})
	AADD(ACABSC5,{"C5_ESPECI1"	,"CAIXA"				})
	AADD(ACABSC5,{"C5_OBSERVA"	,SC5->C5_OBSERVA		})
	AADD(ACABSC5,{"C5_MENNOTA"	,"PEDIDO PORTAL: " + SC5->C5_NUMOLD + ENTER + SC5->C5_MENNOTA	})
	AADD(ACABSC5,{"C5_XLIBCR"		,SC5->C5_XLIBCR		})
	AADD(ACABSC5,{"C5_NUMOLD"		,SC5->C5_NUMOLD		})
	AADD(ACABSC5,{"C5_XITEMC"		,SC5->C5_XITEMC		})
	AADD(ACABSC5,{"C5_NUMORI"		,SC5->C5_NUM			})
	AADD(ACABSC5,{"C5_CLIORI"		,SC5->C5_CLIENTE		}) 
	AADD(ACABSC5,{"C5_LOJORI"		,SC5->C5_LOJACLI		})
	AADD(ACABSC5,{"C5_NOMORI"		,SC5->C5_NOMCLI		})
	AADD(ACABSC5,{"C5_FATFRAC"	,SC5->C5_FATFRAC		})
	AADD(ACABSC5,{"C5_FATPARC"	,SC5->C5_FATPARC		})
	AADD(ACABSC5,{"C5_DTPEDPR"	,SC5->C5_DTPEDPR		})
	AADD(ACABSC5,{"C5_NUMOC"		,"CROSS"				}) // Texto simples que dará apoio ao processo de Recebimento Cross Docking 
	AADD(ACABSC5,{"C5_TABELA"		,SC5->C5_TABELA		})
	AADD(ACABSC5,{"C5_CONDPAG"	,SC5->C5_CONDPAG		})
	AADD(ACABSC5,{"C5_PCTFEIR"	,SC5->C5_PCTFEIR		})
	AADD(ACABSC5,{"C5_TPPCTFE"	,SC5->C5_TPPCTFE		})
	AADD(ACABSC5,{"C5_NOMCLI"		,SC5->C5_NOMCLI		})
	AADD(ACABSC5,{"C5_X_PVBON"	,SC5->C5_X_PVBON		})
	AADD(ACABSC5,{"C5_USRBNF"		,SC5->C5_USRBNF		})
	AADD(ACABSC5,{"C5_OBSBNF"		,SC5->C5_OBSBNF		})
	AADD(ACABSC5,{"C5_BNFLIB"		,SC5->C5_BNFLIB		})

	ACABSC5 := U_FCARRAYEXEC("SC5",ACABSC5,.F.)
	ADETSC6 := {}

	cPedPortalTa := SC5->C5_NUMOLD
	
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC6") + CPEDIDO)
	
	WHILE SC6->(!EOF()) .AND. SC6->C6_NUM = CPEDIDO
					
		DBSELECTAREA("SX3")
		DBSETORDER(1)
		DBSEEK("SC6")
		WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = "SC6"
			If AT( ALLTRIM(SX3->X3_CAMPO) , 'C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_UM|C6_LOCAL|C6_DESCRI|C6_TES|C6_CLI|C6_LOJA|C6_XITEMC|C6_PRCVEN|C6_VALOR|C6_PRUNIT|C6_ENTREG|C6_PEDCLI' ) != 0
				IF X3USO(SX3->X3_USADO) .OR. SX3->X3_PROPRI = "U"
					AADD(ATMPSC6,{SX3->X3_CAMPO,&(SX3->X3_ARQUIVO + "->" + ALLTRIM(SX3->X3_CAMPO)),NIL})
				ENDIF 
			EndIf
			SX3->(DBSKIP())
			
		ENDDO
		
		/*
		|---------------------------------------------------------------------------------
		|	CASO O CAMPO DE OPERACAO NAO ESTEJA NO HEADER O MESMO EH INFORMADO PARA 
		|	QUE SEJA REALIZADO O CALCULO DE IMPOSTOS CORRETAMENTE.
		|---------------------------------------------------------------------------------
		*/
		NREGS := ASCAN(ATMPSC6,{|X| ALLTRIM(X[1]) = "C6_XOPER"})
		IF NREGS <= 0 
			AADD(ATMPSC6,{"C6_XOPER","V6",NIL})
		ELSE
			ATMPSC6[NREGS][2] := "V6"
		ENDIF
		NREGS := ASCAN(ATMPSC6,{|X| ALLTRIM(X[1]) = "C6_LOCAL"})					
		If ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .and. NREGS > 0
			ATMPSC6[NREGS][2] := "21"
		EndIf
	
		AADD(ADETSC6,ATMPSC6)
		ATMPSC6 := {}
		SC6->(DBSKIP())
		
	ENDDO 
	
	//RESET ENVIRONMENT
	//RPCSETTYPE ( 3 )
	//PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL "02" MODULO "FAT"
	//SLEEP(1500)
	SM0->(DBSEEK("0302"))
	cFilAnt := "02"  
	
	NPOSPROD		:= ASCAN(ADETSC6[1],{|X| ALLTRIM(X[1]) == "C6_PRODUTO"})
	NPOSITEM		:= ASCAN(ADETSC6[1],{|X| ALLTRIM(X[1]) == "C6_XITEMC"})
	
	FOR I := 1 TO LEN(ADETSC6)
		
		/*
		|---------------------------------------------------------------------------------
		|	CRIA SB2 / SBE / SBF - CASO NAO TENHA PARA O PRODUTO
		|---------------------------------------------------------------------------------
		*/		
		CRIASB2( PadR(ADETSC6[I,NPOSPROD,2],15) , "21" )			

		SBE->(DBSETORDER(1))  //CADASTRO DE ENDERECOS
		SBE->(DBGOTOP())
		IF !SBE->(DBSEEK(XFILIAL("SBE") + "21" + "EXP", .F.))
			SBE->(RECLOCK("SBE", .T.))
			SBE->BE_FILIAL := XFILIAL("SBE")
			SBE->BE_LOCAL  := "21"
			SBE->BE_LOCALIZ:= "EXP"
			SBE->BE_DESCRIC:= "EXPEDICAO " + ALLTRIM(ADETSC6[I,NPOSITEM,2]) 
			SBE->BE_PRIOR  := "ZZZ"
			SBE->BE_STATUS := "1"
			SBE->(MSUNLOCK())
		ENDIF
		
		SBF->(DBSETORDER(1))  //SALDOS POR ENDERECO
		IF !SBF->(DBSEEK(XFILIAL("SBF") + "21" + "EXP            " + PadR(SC6->C6_PRODUTO,15) , .F.))
			SBF->(RECLOCK("SBF", .T.))
			SBF->BF_FILIAL  := XFILIAL("SBF")
			SBF->BF_PRODUTO := PadR(ADETSC6[I,NPOSPROD,2],15)
			SBF->BF_LOCAL   := "21"
			SBF->BF_PRIOR   := "ZZZ"
			SBF->BF_LOCALIZ := "EXP"
			SBF->(MSUNLOCK())
		ENDIF
		
	NEXT I 
	
	LMSERROAUTO := .F. 
	BEGIN TRANSACTION
	
		MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},ACABSC5,ADETSC6,3)
		IF LMSERROAUTO

			DISARMTRANSACTION()
			MSGALERT(OEMTOANSI(	"Erro ao tentar gerar cópia de Pedido de Vendas!")  + ENTER + ;
								"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
			MOSTRAERRO()
		
		ELSE
		
			/*
			|---------------------------------------------------------------------------------
			|	SE O PEDIDO FOR DE BONIFICACAO DEVE REALIZAR A AMARRAÇÃO DO PEDIDO DE VENDA
			|---------------------------------------------------------------------------------
			*/
			IF SC5->C5_CLASPED = "X"
				
				CPEDBON := SC5->C5_NUMOLD
				
				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")               
				IF DBSEEK(XFILIAL("SC5") + ALLTRIM(SC5->C5_X_PVBON))
					
					IF RECLOCK("SC5",.F.)
						
						SC5->C5_X_PVBON := ALLTRIM(SC5->C5_X_PVBON) + IIF(!EMPTY(ALLTRIM(SC5->C5_X_PVBON)),"/" + ALLTRIM(CPEDBON),ALLTRIM(CPEDBON)) 
						MSUNLOCK()
						
					ENDIF
					
				ENDIF 				
				
			ENDIF 
			
									
		ENDIF
		
	END TRANSACTION
	/*
		A função padrão CodSitTri() está gravando em C6_CALSFIS indevidamente a origem do ultimo item do pedido 
		para todos os itens nos pedidos criados em EXTREMA para o PROTHEUS 12
		Isto ocorre apenas no processo do CROSSDOCKING já que não utilizamos a funcionalidade RPC 
	*/
	//CONOUT(PROCNAME() + " LINHA: " + ALLTRIM(STR(PROCLINE())) )
	DBSELECTAREA("SC5")
	DBORDERNICKNAME("SC5NUMOLD")               
	If DBSEEK( "02" + ALLTRIM( cPedPortalTa ))
		SB1->(DbSetOrder(1))
		SC6->(DbSetOrder(1))
		SC6->(DbSeek( "02" + SC5->C5_NUM ))
		While SC6->(C6_FILIAL + C6_NUM) = "02" + SC5->C5_NUM .AND. !SC6->(Eof())
			If SB1->(DbSeek( xFilial("SB1") + SC6->C6_PRODUTO ))
				SC6->(RECLOCK("SC6",.F.))
				SC6->C6_CLASFIS := SB1->B1_ORIGEM + RIGHT(SC6->C6_CLASFIS,2)
				SC6->(MsUnlock())						
			EndIf
			SC6->(DbSkip())
		End  
		If SC5->(RecLock("SC5", .F.))
			SC5->C5_TRANSP := cA1transp
			SC5->(MsUnLock())
		EndIf
	EndIf
	
	LRET := LMSERROAUTO
	
	//RESET ENVIRONMENT
	//PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL _CFILOLD MODULO "FAT"
	//SLEEP(1500)
	SM0->(DbGoto(_nPosSM0))
	cFilAnt := _cFilOld
	
	DBSELECTAREA("SC5")
	DBGOTO(AAREASC5[3])
	
	RECLOCK("SC5",.F.)
	IF LRET
		SC5->C5_STCROSS = 'ERRCOP'
	ELSE
		SC5->C5_STCROSS = 'ABERTO'
	ENDIF 
	MSUNLOCK()
	
ELSE 
	
	MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")
	RECLOCK("SC5",.F.)
		SC5->C5_STCROSS = 'ERRCOP' 
	MSUNLOCK()		
	
ENDIF 	

CURSORARROW()	
RESTAREA(AAREASC6)
RESTAREA(AAREASC5)
RESTAREA(AAREA)
	
RETURN 

/*
=================================================================================
=================================================================================
||   Arquivo:	MTA416BX.prw
=================================================================================
||   Funcao: 	VERIFTAB
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: Edson Hornberger 
||   Data:	05/11/2015
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERIFTAB(CTAB,CNUMPED)
	
	LOCAL LRET 		:= .F.
	//LOCAL CQQUERY 	:= ""
	LOCAL NQTDORI 	:= 0
	LOCAL NQTDDES 	:= 0
	LOCAL APRODUT	:= {}
	
	IF SELECT("TRB") > 0
		
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
		
	ENDIF
	
	//## Gera consulta com itens do Pedido de Transferencia
	CQUERY := "SELECT" 											+ ENTER 
	CQUERY += "	SC6.C6_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER 
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 					+ ENTER
	CQUERY += "WHERE" 											+ ENTER 
	CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER 
	CQUERY += "	SC6.C6_NUM = '" + CNUMPED + "' AND" 			+ ENTER 
	CQUERY += "	SC6.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER 
	CQUERY += "	SC6.C6_PRODUTO" 	
	
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	
	COUNT TO NQTDORI
	
	TRB->(DBCLOSEAREA())
	
	//## Gera consulta com itens do Pedido de Transferencia com Tabela de Precos
	CQUERY := "SELECT" 											+ ENTER 
	CQUERY += "	SC6.C6_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER 
	CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 					+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("DA1") + " DA1 ON" 	+ ENTER 
	CQUERY += "	DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER 
	CQUERY += "	DA1.DA1_CODPRO = SC6.C6_PRODUTO AND" 			+ ENTER 
	CQUERY += "	DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER 
	CQUERY += "	DA1.D_E_L_E_T_ = ''" 							+ ENTER	
	CQUERY += "WHERE" 											+ ENTER 
	CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER 
	CQUERY += "	SC6.C6_NUM = '" + CNUMPED + "' AND" 			+ ENTER 
	CQUERY += "	SC6.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER 
	CQUERY += "	SC6.C6_PRODUTO" 

	
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	
	COUNT TO NQTDDES
	
	TRB->(DBCLOSEAREA())
	
	IF NQTDORI <> NQTDDES
		
		LRET 	:= .F.
		
		CQUERY 	:= "SELECT" 													+ ENTER
		CQUERY 	+= "	SC6.C6_PRODUTO," 										+ ENTER 
		CQUERY 	+= "    SB1.B1_DESC" 											+ ENTER
		CQUERY 	+= "FROM" 														+ ENTER
		CQUERY 	+= "	" + RETSQLNAME("SC6") + " SC6" 							+ ENTER
		CQUERY 	+= "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 			+ ENTER 
		CQUERY 	+= "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 		+ ENTER 
		CQUERY 	+= "		SB1.B1_COD = SC6.C6_PRODUTO AND" 					+ ENTER 
		CQUERY 	+= "		SB1.D_E_L_E_T_ = ''" 								+ ENTER
		CQUERY 	+= "WHERE" 														+ ENTER  
		CQUERY 	+= "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 			+ ENTER 
		CQUERY 	+= "	SC6.C6_NUM = '" + CNUMPED + "' AND" 					+ ENTER 
		CQUERY 	+= "	SC6.C6_PRODUTO NOT IN" 									+ ENTER 
		CQUERY 	+= "	(" 														+ ENTER
		CQUERY 	+= "		SELECT" 											+ ENTER
		CQUERY 	+= "			DA1.DA1_CODPRO" 								+ ENTER
		CQUERY 	+= "		FROM" 												+ ENTER
		CQUERY 	+= "			" + RETSQLNAME("DA1") + " DA1" 					+ ENTER
		CQUERY 	+= "		WHERE" 												+ ENTER  
		CQUERY 	+= "			DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER 
		CQUERY 	+= "            DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER 
		CQUERY 	+= "			DA1.D_E_L_E_T_ = ''" 							+ ENTER
		CQUERY 	+= "	) AND" 													+ ENTER 
		CQUERY 	+= "	SC6.D_E_L_E_T_ = ''" 									+ ENTER
		CQUERY 	+= "GROUP BY" 													+ ENTER 
		CQUERY 	+= "	SC6.C6_PRODUTO," 										+ ENTER
		CQUERY 	+= " 	SB1.B1_DESC"
		
		IF SELECT("TRB") > 0
			
			DBSELECTAREA("TRB")
			DBCLOSEAREA()
			
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")
		DBGOTOP()
		
		WHILE TRB->(!EOF())
			
			AADD(APRODUT,{TRB->C6_PRODUTO,TRB->B1_DESC})
			TRB->(DBSKIP())
			
		ENDDO
		
		//ENVTAB(APRODUT)
		
	ELSE
		
		LRET := .T.
		
	ENDIF
	
RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	MTA416BX.prw
=================================================================================
||   Funcao: 	ENVTAB
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger 
||   Data:		05/11/2015
=================================================================================
=================================================================================
*/
/*
STATIC FUNCTION ENVTAB(ADADOS)
	
	LOCAL CEMAIL 	:= SUPERGETMV("MV_AV3ETAB",.F.,"douglas.fornazier@taiff.com.br;rose.araujo@taiff.com.br;gabriela.santos@taiff.com.br")
	LOCAL OPROCESS
	LOCAL _E := 0
	
	//## Cria processo de Workflow
	OPROCESS 			:= TWFPROCESS():NEW( "WFAV3TAB", OEMTOANSI("WORKFLOW CROSSDOCKING - PRODUTOS SEM TABELA DE PREÇO"))
	OPROCESS:NEWTASK( "WFAV3TAB", "\WORKFLOW\WFAV3TAB.HTM" )
	OPROCESS:CTO 		:= CEMAIL
	OPROCESS:CSUBJECT 	:= OEMTOANSI("WORKFLOW - PRODUTOS SEM TABELA DE PREÇO")
	OHTML 				:= OPROCESS:OHTML
	
	//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	FOR _E := 1 TO LEN(ADADOS)
		AADD(OHTML:VALBYNAME("it.CODPRO")		,ALLTRIM(ADADOS[_E][1]))
		AADD(OHTML:VALBYNAME("it.DESCRICAO")	,ALLTRIM(ADADOS[_E][2]))
	NEXT _E
	
	//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( SUBS(CUSUARIO,7,15) )
	OPROCESS:USERSIGA	:= __CUSERID
	OPROCESS:START()
	OPROCESS:FREE()
	
RETURN()
*/
/*
	Busca itens do orçamento
*/
STATIC FUNCTION ORCAMTAB(CTAB,CNUMPED)
	
	LOCAL LRET 		:= .F.
	//LOCAL CQQUERY 	:= ""
	LOCAL NQTDORI 	:= 0
	LOCAL NQTDDES 	:= 0
	LOCAL APRODUT	:= {}
	
	IF SELECT("TRB") > 0
		
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
		
	ENDIF
	
	//## Gera consulta com itens do Pedido de Transferencia
	CQUERY := "SELECT" 											+ ENTER 
	CQUERY += "	SCK.CK_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER 
	CQUERY += "	" + RETSQLNAME("SCK") + " SCK" 					+ ENTER
	CQUERY += "WHERE" 											+ ENTER 
	CQUERY += "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 	+ ENTER 
	CQUERY += "	SCK.CK_NUM = '" + CNUMPED + "' AND" 			+ ENTER 
	CQUERY += "	SCK.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER 
	CQUERY += "	SCK.CK_PRODUTO" 	
	
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	
	COUNT TO NQTDORI
	
	TRB->(DBCLOSEAREA())
	
	//## Gera consulta com itens do Pedido de Transferencia com Tabela de Precos
	CQUERY := "SELECT" 											+ ENTER 
	CQUERY += "	SCK.CK_PRODUTO" 								+ ENTER
	CQUERY += "FROM" 											+ ENTER 
	CQUERY += "	" + RETSQLNAME("SCK") + " SCK" 					+ ENTER
	CQUERY += "	INNER JOIN " + RETSQLNAME("DA1") + " DA1 ON" 	+ ENTER 
	CQUERY += "	DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER 
	CQUERY += "	DA1.DA1_CODPRO = SCK.CK_PRODUTO AND" 			+ ENTER 
	CQUERY += "	DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER 
	CQUERY += "	DA1.D_E_L_E_T_ = ''" 							+ ENTER	
	CQUERY += "WHERE" 											+ ENTER 
	CQUERY += "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 	+ ENTER 
	CQUERY += "	SCK.CK_NUM = '" + CNUMPED + "' AND" 			+ ENTER 
	CQUERY += "	SCK.D_E_L_E_T_ = ''" 							+ ENTER
	CQUERY += "GROUP BY" 										+ ENTER 
	CQUERY += "	SCK.CK_PRODUTO" 

	
	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	
	COUNT TO NQTDDES
	
	TRB->(DBCLOSEAREA())
	
	IF NQTDORI <> NQTDDES
		
		LRET 	:= .F.
		
		CQUERY 	:= "SELECT" 													+ ENTER
		CQUERY 	+= "	SCK.CK_PRODUTO," 										+ ENTER 
		CQUERY 	+= "    SB1.B1_DESC" 											+ ENTER
		CQUERY 	+= "FROM" 														+ ENTER
		CQUERY 	+= "	" + RETSQLNAME("SCK") + " SCK" 							+ ENTER
		CQUERY 	+= "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 			+ ENTER 
		CQUERY 	+= "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 		+ ENTER 
		CQUERY 	+= "		SB1.B1_COD = SCK.CK_PRODUTO AND" 					+ ENTER 
		CQUERY 	+= "		SB1.D_E_L_E_T_ = ''" 								+ ENTER
		CQUERY 	+= "WHERE" 														+ ENTER  
		CQUERY 	+= "	SCK.CK_FILIAL = '" + XFILIAL("SCK") + "' AND" 			+ ENTER 
		CQUERY 	+= "	SCK.CK_NUM = '" + CNUMPED + "' AND" 					+ ENTER 
		CQUERY 	+= "	SCK.CK_PRODUTO NOT IN" 									+ ENTER 
		CQUERY 	+= "	(" 														+ ENTER
		CQUERY 	+= "		SELECT" 											+ ENTER
		CQUERY 	+= "			DA1.DA1_CODPRO" 								+ ENTER
		CQUERY 	+= "		FROM" 												+ ENTER
		CQUERY 	+= "			" + RETSQLNAME("DA1") + " DA1" 					+ ENTER
		CQUERY 	+= "		WHERE" 												+ ENTER  
		CQUERY 	+= "			DA1.DA1_CODTAB = '" + CTAB + "' AND" 			+ ENTER 
		CQUERY 	+= "            DA1.DA1_FILIAL = '" + XFILIAL("DA1") + "' AND" 	+ ENTER 
		CQUERY 	+= "			DA1.D_E_L_E_T_ = ''" 							+ ENTER
		CQUERY 	+= "	) AND" 													+ ENTER 
		CQUERY 	+= "	SCK.D_E_L_E_T_ = ''" 									+ ENTER
		CQUERY 	+= "GROUP BY" 													+ ENTER 
		CQUERY 	+= "	SCK.CK_PRODUTO," 										+ ENTER
		CQUERY 	+= " 	SB1.B1_DESC"
		
		IF SELECT("TRB") > 0
			
			DBSELECTAREA("TRB")
			DBCLOSEAREA()
			
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")
		DBGOTOP()
		
		WHILE TRB->(!EOF())
			
			AADD(APRODUT,{TRB->CK_PRODUTO,TRB->B1_DESC})
			TRB->(DBSKIP())
			
		ENDDO
		
		//ENVTAB(APRODUT)
		
	ELSE
		
		LRET := .T.
		
	ENDIF
	
RETURN(LRET)


/* Funcionalidade do projeto Financeiro sobre o limite de crédito */
/* Data: 08/06/2020                               Responsável: Carlos Torres*/
/* Busca o total de pedidos abertos                               */
USER FUNCTION FINPEDABE(CEMPZSA,CFILZSA,CCGCZSA,CCONDICAO)
LOCAL AQTABERTO := {}
LOCAL NQTABERTO	:= 0

AQTABERTO := TCSPEXEC("SP_FIN_PEDIDO_ABERTO", CEMPZSA, CFILZSA, CCGCZSA,CCONDICAO, 0 )
 
IF empty(AQTABERTO)
	Conout('Erro na execução da Stored Procedure : '+TcSqlError())
ELSE
	NQTABERTO	:= AQTABERTO[1]
ENDIF

RETURN (NQTABERTO)


/* Funcionalidade do projeto Financeiro sobre o limite de crédito */
/* Data: 10/06/2020                               Responsável: Carlos Torres*/
/* Verifica se houve faturamento de pedido e se houve faturamento não mostra botões */
USER FUNCTION MI1FATUR( CMI1PEDIDO )
LOCAL LRETORNO := .F.
IF EMPTY(SC5->C5_NOTA)
	SC6->(DBSETORDER( 1 ))
	SC6->(DBSEEK( xFilial("SC6") + CMI1PEDIDO ))
	WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CMI1PEDIDO
		IF SC6->C6_BLQ != "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5") 
			LRETORNO := IIF( SC6->C6_QTDENT > 0 , .T. , LRETORNO )
		ENDIF
		SC6->(DBSKIP())
	END
ELSE
	LRETORNO := .T.
ENDIF
RETURN (LRETORNO)
