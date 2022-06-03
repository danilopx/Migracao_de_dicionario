#include "protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTMI001  º Autor ³ Paulo Bindo        º Data ³  18/08/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ROTINA QUE LIBERA PEDIDOS PARADOS E QUE POSSUEM SALDO      º±±
±±º          ³ EM ESTOQUE                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ESTMI001()
	LOCAL z := 0

	Private lWeb := .F.
	Private cEmailAdm
	Private aEmpresas	:= {{"03","02","TAIFF"},{"03","02","PROART"}}

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		For z:=1 To 1 //Len(aEmpresas)
			cFilialSch := aEmpresas[z][2]
			cEmpSch := aEmpresas[z][1]
			cLinhaSch := aEmpresas[z][3]
		
			RPCSetType(3)  // Nao utilizar licenca
			PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"
			ESTMI1( cLinhaSch )
			RESET ENVIRONMENT
		Next
	Else
		cMensagem := " Este programa ira efetuar a Liberacao"+ENTER
		cMensagem += " de Estoque dos pedidos de venda em Lote"+ENTER
		cMensagem += " Deseja Continuar?"
		If !MsgYesNo(cMensagem,"Liberação Pedidos - ESTMI001")
			Return
		EndIf		
		For z:=1 To Len(aEmpresas)
			If aEmpresas[z][2] = CFILANT .AND. CEMPANT = aEmpresas[z][1] 
				cLinhaSch := aEmpresas[z][3]
				Processa({|| ESTMI1( cLinhaSch ) })
			Else
				MSGALERT("Rotina não pode ser executada nesta empresa/filial","Atenção")
			EndIf
		Next
	EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTMI001  ºAutor  ³Microsiga           º Data ³  04/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ESTMI1( cLinhaProduto )
	Local cPedidoChave := ""
	Local nValMinFatur := 0
	Local nLoop 		:= 0
	Local cEmail		:= "grp_sistemas@taiff.com.br"
	Local cCabEmail	:= ""
	Local ACONDPAG		:= {}
	Local cIdCliente	:= ""
	Local cIdLoja		:= ""
	Local nCtaLoop		:= 0
	Local nPosVlLib	:= 0
	Local cMensLido	:= ""
	Local lJaLiberado	:= .F.
	Local nLoopTeto	:= 0
	Local cMensTeto	:= ""
	Local cDtRefProg	:= ""
	Local dDTVenda		:= CTOD("  /  /  ")
	Local cC5BLOQF		:= ""
	Local ATEMPBNF 	:= {}
	LOCAL I_bnf		:= 0					
	 		 		
	PRIVATE NVALC9LIB	:= 0
	PRIVATE NVALC6VEN	:= 0
	PRIVATE NTOTC9LIB := 0
	PRIVATE NTOTC6VEN	:= 0
	PRIVATE NVALC6TET	:= 0
	PRIVATE NTOTC6TET	:= 0	
	PRIVATE LSALDOOK	:= .T.
	PRIVATE LFRACION	:= .T.
	PRIVATE cItFRACION:= ""
	PRIVATE cItSALDOOK:= ""
	PRIVATE cItC9BLEST:= ""
	PRIVATE lLibAutom	:= Iif(GetMV("MV__LIBAUT")=="S",.T.,.F.)
	PRIVATE nDiasEntrega	:= GetMV("MV__PRZENT",.F.,10)
	PRIVATE nMaxFatur	:= GetMV("MV__MAXFAT",.F.,1000000)
	PRIVATE aPedLido	:= {}
	PRIVATE aPedVlLib	:= {} 
	PRIVATE lEmProcess:= Iif(GetMV("MV__ESTM1" + LEFT(cLinhaProduto,1))=="N",.F.,.T.)
	PRIVATE nSA1Recno	:= 0
	PRIVATE lEmSeparacao := .F.
	PRIVATE aB2saldo	:= {} // Acumula o saldo disponivel para liberação
	PRIVATE nValMinimo:= 0 	// Recebe o valor da venda e a parcela do pedido
	PRIVATE cCondAvist:= GetMV("MV__ESTCND",.F.,"N01|N02|N24")
	PRIVATE ATETOLIBER:= {}
	PRIVATE lAvalMinimo	:= .F. 
	PRIVATE LPRJENDER 	:= GetMV("TF_PRJENDR",.F.,.F.)
	PRIVATE NDIALIMT	:= GETNEWPAR("TF_DATFAT",31) // DIA LIMITE DE RESTRIÇÃO
	PRIVATE cTFd3doc	:= ""
	PRIVATE LHORAPROC	:= .T.
	PRIVATE CDTALIMIT	:= "" // DATA DO DIA LIMITE DE RESTRIÇÃO

	/* Inicio da carga da matriz de valores de teto de faturamento */	
	aAdd( ATETOLIBER ,{      0.00	,	  49999.00 	, 100	}) // atende pela regra do faturamento minimo
	aAdd( ATETOLIBER ,{  50000.00	,	  99999.99 	, 50 	})
	aAdd( ATETOLIBER ,{ 100000.00	,	 199999.99 	, 30	})
	aAdd( ATETOLIBER ,{ 200000.00	,	9999999.99 	, 25	})
	/* fim da matriz de valores */	
		
	If At( "DESENV" , GetEnvServer() )  
		lEmProcess:= .F.
	EndIf
	//LIBERA PEDIDOS COM BLOQUEIO

	If .NOT. lLibAutom
		If .NOT. lWeb
			MSGALERT("Rotina bloqueada para uso" + ENTER + "Solicite a TI atualização do parâmetro MV__LIBAUT","Atenção")
		EndIf
	EndIf 
	If lEmProcess 
		If .NOT. lWeb
			MSGALERT("Rotina bloqueada para uso, pois já está em andamento" + ENTER + "Parâmetro de referencia MV__ESTM1" + LEFT(cLinhaProduto,1),"Atenção")
		EndIf
		// Enviar aviso de rotina parada
		U_2EnvMail("workflow@taiff.com.br", RTrim(cEmail) ,""," *** ATENCAO *** revisar parametro MV__ESTM1"+ LEFT(cLinhaProduto,1) , "Liberação automatica no ambiente " + GetEnvServer()	,'')
		
		Return 
	EndIf
	
	LHORAPROC := .F.
	cQuery := " SELECT * FROM TBL_ESTMI001_HORA" + ENTER
	
	//MemoWrite("ESTMI001_TABELA_DE_HORARIO_DE_PROCESSAMENTO.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
	
	dbSelectArea("TRB1")
	TRB1->(dbGoTop())
	While !TRB1->(Eof())
		IF SUBSTRING(TIME(),1,5) = TRB1->HR_PROCESSA .AND. ALLTRIM(TRB1->STATUS)="HABILITADO" .AND. (ALLTRIM(TRB1->DIA_PROCESSA)="*" .OR. TRB1->DIA_PROCESSA=ALLTRIM(STR(NDIALIMT)))
			LHORAPROC := .T.
		ENDIF
		TRB1->(DbSkip())
	END
	TRB1->(DbCloseArea())

	IF .NOT. LHORAPROC
		/*
		CREATE TABLE [dbo].[TBL_ESTMI001_HORA](
			[HR_PROCESSA] [varchar](05) NULL,
			[STATUS] [varchar](12) NULL,
			[DIA_PROCESSA] [varchar](2) NULL
		) ON [PRIMARY]
		*/
		If .NOT. lWeb
			MSGALERT("ESTMI001 - Horario de processamento não encontrado na tabela de horarios de execução" + ENTER + "Ver tabela TBL_ESTMI001_HORA" ,"Atenção")
		EndIf
		Return
	ENDIF

	PutMv("MV__ESTM1" + LEFT(cLinhaProduto,1),"S")

	cListAvist := ""
	While LEN(cCondAvist)>0
		nPosPipe:= AT("|",cCondAvist)
		nPosPipe:= Iif( nPosPipe !=0 , nPosPipe ,Iif( nPosPipe=0 .AND. LEN(cCondAvist)>0 ,LEN(cCondAvist) + 1,nPosPipe) )
		cListAvist += Iif(EMPTY(cListAvist),"'", ",'") + Substr(cCondAvist, 1 , nPosPipe - 1 ) + "'"	
	
		cCondAvist := 	Substr( cCondAvist, nPosPipe + 1,LEN(cCondAvist) )
	End
	cCondAvist:= GetMV("MV__ESTCND",.F.,"N01|N02|N24")
	
	cQuery := " SELECT C9_PEDIDO,C9_PRODUTO,C9_ITEM,C9_SEQUEN,C9_LOCAL,C9_CLIENTE,C5_XITEMC" + ENTER
	cQuery += " FROM "+RetSqlName("SC9")+" C9" + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5" + ENTER
	cQuery += " 	ON C5_NUM = C9_PEDIDO" + ENTER
	cQuery += " WHERE C9_BLEST = '02'" + ENTER
	cQuery += " AND C9_NFISCAL = ''" + ENTER
	cQuery += " AND C9.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND C5_XLIBCR = 'L' " + ENTER
	cQuery += " AND C5__LIBM != 'M' " + ENTER
	cQuery += " AND C5_CONDPAG NOT IN (" + cListAvist + ") " + ENTER
	cQuery += " AND C5_CLASPED IN ('V','X') " + ENTER
	cQuery += " AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += " AND RTRIM(C5_XITEMC) = '" + cLinhaProduto + "' " + ENTER	
	cQuery += " AND C9_LOCAL = '21'" + ENTER
	//cQuery += " AND EXISTS (SELECT * FROM "+RetSqlName("SB2")+" SB2 WHERE B2_COD = C9_PRODUTO AND B2_QATU-B2_RESERVA >= C9_QTDLIB AND B2_LOCAL = C9_LOCAL AND C9_BLCRED = '' AND SB2.D_E_L_E_T_ <> '*' AND B2_FILIAL = '"+xFilial("SB2")+"')" + ENTER
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
	cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'" + ENTER
	//cQuery += " and C9_PEDIDO = '865849'"
	cQuery += " ORDER BY C5_NUM" + ENTER
	
	//MemoWrite("ESTMI001_PEDIDOS_C9_BLEST_02.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
	
	Count To nRec

	IF NDIALIMT != 31
	ELSEIf nRec == 0 
	Else
		If .NOT. lWeb
			ProcRegua( nRec )
		EndIf
		nCtaLoop	:= 0
		dbSelectArea("TRB1")
		dbGoTop()
		While !Eof()
			If .NOT. lWeb
				IncProc("Processando Pedido " + AllTrim(Str(nCtaLoop)) + " de " + AllTrim(Str(nRec)))
			EndIf
			GravaSC9()
			nCtaLoop++

			DbSelectArea("TRB1")
			DbSkip()
		End
	EndIf
	TRB1->(DbCloseArea())

	GRAVALOG( "ESTMI001", procline(), "Inicio do processamento da montagem de associação da Venda ao Bonificado" , "" , "" )
	TFAssocBonf()

	GRAVALOG( "ESTMI001", procline(), "Inicio do processamento da montagem da matriz de saldos por produto" , "" , "" )
	aB2saldo	:= {}
	TFSaldoMov(cLinhaProduto) // Alimenta matriz aB2saldo com saldo disponivel
	GRAVALOG( "ESTMI001", procline(), "** FIM ** do processamento da montagem da matriz de saldos por produto" , "" , "" )

	If len(aB2saldo) = 0
		If .NOT. lWeb
			MSGALERT("Não há saldo disponivel para liberação de pedidos " + ENTER + "Para a linha de produtos da " + cLinhaProduto,"Atenção")
		EndIf
		PutMv("MV__ESTM1" + LEFT(cLinhaProduto,1),"N")
		Return
	EndIf 

	IF NDIALIMT != 31
	//******** PROCESSAMENTO BLOQUEADO ********//
	// AS RESERVAS SER?O TRATADAS MANUALMENTE  //
	ELSEIF 1=2 
	//******** PROCESSAMENTO BLOQUEADO ********//

		/* cria Controle de Reserva para pedidos aprovados pela alçada de reserva */
		cQuery := " SELECT " + ENTER
		cQuery += " 	C5_NUM " + ENTER
		cQuery += " 	,C5_XITEMC " + ENTER
		cQuery += " 	,SUM((C6_QTDVEN - C6_QTDENT) * C6_PRCVEN) AS VALOR_RESERVA" + ENTER
		cQuery += " 	,C5__RESERV" + ENTER
		cQuery += " FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)" + ENTER
		cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK)" + ENTER
		cQuery += "	ON C6_NUM = C5_NUM" + ENTER
		cQuery += "	AND C6_FILIAL = C5_FILIAL" + ENTER
		cQuery += "	AND SC6.D_E_L_E_T_ <> '*' " + ENTER
		cQuery += "	AND C6_LOCAL  = '21' " + ENTER
		cQuery += "	AND C6_BLQ = '' " + ENTER
		cQuery += "	AND C6_QTDVEN - C6_QTDRESE > 0 " + ENTER
		cQuery += " WHERE " + ENTER
		cQuery += " 	C5.D_E_L_E_T_ <> '*'" + ENTER
		cQuery += "	AND C5_FILIAL = '"+xFilial("SC5")+"'" + ENTER
		cQuery += "	AND C5_CLASPED IN ('V','X') " + ENTER
		cQuery += "	AND C5_TIPO NOT IN ('D','B')  " + ENTER
		cQuery += "	AND C5_NOTA = ''" + ENTER
		cQuery += "	AND C5_XITEMC = '" + cLinhaProduto + "'" + ENTER
		cQuery += "	AND ((C5_CONDPAG IN (" + cListAvist + ")) OR C5__RESERV = 'L') " + ENTER
		cQuery += "	AND C5__LIBM != 'M' " + ENTER
		cQuery += "	AND C5__DTLIBF = '' " + ENTER
		cQuery += "	AND C5_LIBCOM != '2' " + ENTER

		//If At( "DESENV" , GetEnvServer() ) != 0  
		//	cQuery += "	AND C5_NUM IN ('066039','066445') " + ENTER
		//	cQuery += "	AND C5_NUM IN ('066504') " + ENTER ///pedido a vista
		//	cQuery += "	AND C5_NUM IN ('124336','124342') " + ENTER ///pedido venda e bonificacao
		//EndIf
		
		cQuery += " GROUP BY C5_NUM, C5_XITEMC, C5__RESERV " + ENTER
		cQuery += " ORDER BY C5_NUM" + ENTER

		//MemoWrite("ESTMI001_PEDIDOS_COM_ALCADA_DE_RESERVA.SQL",cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
		
		Count To nRec
		
		If nRec == 0 
		Else
			If .NOT. lWeb
				ProcRegua( nRec )
			EndIf
			nCtaLoop	:= 0
			dbSelectArea("TRB1")
			dbGoTop()
			While !Eof()
				If .NOT. lWeb
					IncProc("Processando Pedido " + AllTrim(Str(nCtaLoop)) + " de " + AllTrim(Str(nRec)))
				EndIf
				GravaSC0( TRB1->C5_NUM )
				nCtaLoop++

				DbSelectArea("TRB1")
				DbSkip()
			End
		EndIf
		TRB1->(DbCloseArea())
	ENDIF	
//LIBERA NOVOS PEDIDOS
	/*
	C5_LIBCOM = Liberação comercial (Opções: 1 - liberado 2 - bloqueado), campo manipulado por administração de vendas
	*/
	GRAVALOG( "ESTMI001", PROCLINE(), "Inicio do processamento da montagem do SCRIPT de pedidos a liberar" , "", "" )	
	
	CDTALIMIT := SUBSTR(DTOS(DDATABASE),1,6) + ALLTRIM(STR(NDIALIMT)) 

	cQuery := " SELECT C6_FILIAL,C6_CLI,C6_LOJA, C6_NUM, C6_ITEM, C6_LOCAL, C6_PRODUTO, C6_QTDVEN, C5_XITEMC,C5_CLIORI,C5_LOJORI,C5_CLASPED " + ENTER
 	cQuery += "  FROM "+RetSqlName("SC6")+" C6 WITH(NOLOCK) " + ENTER
	cQuery += "  INNER JOIN "+RetSqlName("SC5")+" C5 WITH(NOLOCK) " + ENTER
	cQuery += "  	ON C5_NUM = C6_NUM " + ENTER
	cQuery += "  	AND C5_FILIAL = C6_FILIAL " + ENTER
	cQuery += "  	AND C5.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "  INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) " + ENTER
	cQuery += "  	ON F4_CODIGO = C6_TES " + ENTER
	cQuery += "  	AND F4_FILIAL = C6_FILIAL " + ENTER
	cQuery += "  	AND SF4.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "  	AND F4_ESTOQUE = 'S' " + ENTER
	cQuery += "  WHERE C6_QTDENT < C6_QTDVEN  " + ENTER
	cQuery += "  AND C6_LOCAL  = '21' " + ENTER
	cQuery += "  AND C6_BLQ = '' " + ENTER
	cQuery += "  AND C6.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "  AND C5_LIBCOM != '2' " + ENTER
	cQuery += "  AND C5_XLIBCR = 'L' " + ENTER
	cQuery += "  AND C5__LIBM != 'M' " + ENTER
	cQuery += "  AND C5_CLASPED IN ('V','X') " + ENTER
	cQuery += "  AND C5_TIPO NOT IN ('D','B')  " + ENTER
	cQuery += "  AND C5_CONDPAG NOT IN (" + cListAvist + ") " + ENTER
	cQuery += "  AND C5__RESERV = '' " + ENTER
	cQuery += "  AND C5__DTLIBF = '' " + ENTER
	cQuery += "  AND C5_EMISSAO >= '20170101' " + ENTER
	cQuery += "  AND RTRIM(C5_XITEMC) = '" + cLinhaProduto + "'" + ENTER	
	cQuery += "  AND RTRIM(C6_XITEMC) = '" + cLinhaProduto + "'" + ENTER	
	cQuery += "  AND EXISTS (SELECT * FROM "+RetSqlName("SB2")+" SB2 WITH(NOLOCK) WHERE B2_COD = C6_PRODUTO AND B2_QATU-B2_RESERVA-B2_QACLASS >0 AND B2_LOCAL = C6_LOCAL AND B2_FILIAL = C6_FILIAL AND SB2.D_E_L_E_T_ <> '*') " + ENTER
	cQuery += "  AND dbo.RET_SC5_PRZ_ENTREGA(C5.C5_DTPEDPR,'" + CDTALIMIT + "',CONVERT(VARCHAR(10),GETDATE(),112)," + ALLTRIM(STR(nDiasEntrega)) +") = 0" + ENTER
	cQuery += "  AND dbo.RET_REGRA_DE_LIBERACAO(C5.C5_VEND1,C5.C5_XITEMC,C5.C5_FILDES,C5.C5_CLIORI,C5.C5_CLIENTE) = 0" + ENTER
	cQuery += "  AND C6_FILIAL = '"+xFilial("SC6")+"'" + ENTER
	cQuery += "  ORDER BY C5_NUM" + ENTER
	
	
	//MemoWrite("ESTMI001_PEDIDOS_A_ATENDER.SQL",cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
	GRAVALOG( "ESTMI001", PROCLINE(), "** FIM ** do processamento da montagem do SCRIPT de pedidos a liberar" , "", "" )	
	
	Count To nRec
	
	If nRec == 0
		TRB1->(DbCloseArea())
		GRAVALOG( "ESTMI001", PROCLINE(), "Não há registro de dados no SCRIPT do ESTMI001_PEDIDOS_A_ATENDER.SQL, fim do processamento da rotina" , "", "" )	
		If .NOT. lWeb
			MSGALERT("Não há pedidos pendentes de liberação" + ENTER + "Para a linha de produtos da " + cLinhaProduto,"Atenção")
		EndIf
		PutMv("MV__ESTM1" + LEFT(cLinhaProduto,1),"N")
		Return
	EndIf
	If .NOT. lWeb
		ProcRegua( nRec )
	EndIf
	
	IF NDIALIMT != 31 .AND. DAY(DATE()) > NDIALIMT 
		GRAVALOG( "ESTMI001", PROCLINE(), "Parametro do projeto de vendas ativado e dentro do dia de controle" , "", "" )	
	ENDIF

	nCtaLoop := 0
	dbSelectArea("TRB1")
	dbGoTop()
	While !TRB1->(Eof())

		cIdCliente := IIF(  Empty(TRB1->C5_CLIORI), TRB1->C6_CLI, TRB1->C5_CLIORI)
		cIdLoja 	:= IIF(  Empty(TRB1->C5_LOJORI), TRB1->C6_LOJA, TRB1->C5_LOJORI)


		/*

		Busca regras do cliente

		*/
		SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1") + cIdCliente + cIdLoja	))

		nSA1Recno	:= SA1->(RECNO())
		LFRACION 	:= .T.
		LSALDOOK	:= .T.
		cItSALDOOK	:= ""
		cItFRACION	:= ""
		NTOTC9LIB	:= 0
		NTOTC6VEN	:= 0
		NVALC9LIB	:= 0
		NVALC6VEN	:= 0
		NVALMINIMO	:= 0
		NVALC6TET	:= 0
		NTOTC6TET	:= 0	
		
		/*
		Loop dos itens do pedido a liberar
		*/
		cPedidoChave := TRB1->C6_NUM
		SC5->(DbSeek(xfilial("SC5") + cPedidoChave ))

		lJaLiberado := Iif( SC5->C5__LIBM = "M" , .T. , .F. )

		/* Funcionalidade do projeto de vendas onde haverá Liberação de pedido com autorização   */
		/* Data: 13/05/2020                                         Responsável: Carlos Torres   */
		/* pedidos TAIFF somente serão liberados em período de restrição para tanto é necessário */
		/* verificar se o pedido de venda está cadastrado em ZAS com tipo de liberação igual a 1 */
		IF NDIALIMT != 31 .AND. DAY(DATE()) > NDIALIMT 
			ZAS->(DbSetOrder(1))
			IF .NOT. ZAS->(DbSeek( xFilial("ZAS") + TRB1->C6_NUM + "1" ))
				GRAVALOG( "ESTMI001", PROCLINE(), "Pedido sem autorização de liberação durante período restritivo" , TRB1->C6_NUM , "" )	
				While TRB1->C6_NUM = cPedidoChave .AND. !TRB1->(Eof()) 
					TRB1->(DbSkip())
				End
				LOOP
			ENDIF
		ENDIF
		/* fim de controle */

		/*
			
			A função TFCalcMinimo carrega em NVALMINIMO o [valor a liberar] do pedido 
			e quando igual a zero é por que atende as regras do valor minimo
			Os pedidos de bonificação serão liberados mesmo que estiverem abaixo do faturamento minimo
			
		*/
		
		TFCalcMinimo( cPedidoChave, cLinhaProduto )

		/*
			Garante que o endereço do item do pedido esteja vazio
		*/
		SC6->(DbSetOrder(1))
		SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM))
		WHILE .NOT. SC6->(Eof()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=SC5->C5_NUM
			IF SC6->(RecLock("SC6",.F.))
				SC6->C6_LOCALIZ := ""
				SC6->(msUnlock())
			ENDIF
			SC6->(DBSKIP())
		END

		DbSelectArea("TRB1")

		cItC9BLEST	:= ""
		lValidPed := .T.
		lEmSeparacao := .F.
		While TRB1->C6_NUM = cPedidoChave .AND. !TRB1->(Eof()) 
			nCtaLoop ++

			If .NOT. lWeb
				IncProc("Processando registro " + AllTrim(Str(nCtaLoop)) + " de " + AllTrim(Str(nRec)) + " registros")
			EndIf
			lAvalMinimo := .F.
			
			If NVALMINIMO = 0 .OR. SC5->C5_CLASPED = "X"
				GRAVALOG( "ESTMI001", PROCLINE(), "Liberando pedido - Contador " + AllTrim(Str(nCtaLoop)) + " de " + AllTrim(Str(nRec)) + " registros" , TRB1->C6_NUM , "" )	
				
				If lValidPed .AND. (.NOT. lJaLiberado)
					U_GravaSC902( TRB1->C6_NUM )
					lValidPed := .F.
				EndIf
			Else
				GRAVALOG( "ESTMI001", PROCLINE(), "Pedido abaixo do minimo" , TRB1->C6_NUM , "" )	
				lAvalMinimo := .T.
			EndIf
			
			DbSelectArea("TRB1")

			DbSkip()
		End

	
		/* Atualiza o status dos campos de Ok para faturamento no pedido de venda SC5 */		
		SC5->(DbSeek(xfilial("SC5") + cPedidoChave ))
		If SC5->(RecLock("SC5",.F.)) .AND. .NOT. lEmSeparacao 
	
			SA1->(DbGoTo( nSA1Recno ))

			SA3->(DbSetOrder(1))
			SA3->(DbSeek( xFilial("SA3") + SC5->C5_VEND1 ))

			/*
			Busca regras do valor minimo
			*/
			nValMinFatur	:= 0
			nParcelaMin	:= 0
			ZAV->(DbSetOrder(1))
			If ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) + SA1->A1_COD_MUN ))
				nValMinFatur	:= ZAV->ZAV_VALMIN
				nParcelaMin	:= ZAV->ZAV_PARCEL
			ElseIf ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) ))
				nValMinFatur	:= ZAV->ZAV_VALMIN
				nParcelaMin	:= ZAV->ZAV_PARCEL
			EndIf

			/* Inicio da validação das regras do cliente */
			SC5->C5__BLOQF := ""
			ACONDPAG	:= {}
			cMensLido	:= ""
			 
			If NVALC9LIB = 0 
				SC5->C5__BLOQF := "E"				
				//cMensLido	:= "Item bloqueado por falta de estoque, produto: " + cItC9BLEST 
				cMensLido	:= "Bloqueado por falta de estoque" 
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf

			If NVALC9LIB = 0 .AND. SC5->C5__PERBNF = 0 .AND. SC5->C5_CLASPED = "X" .AND. .NOT. SC5->C5_BNFLIB
				SC5->C5__BLOQF := "B"				
				cMensLido	:= "Bonificação bloqueado por falta liberação na venda" 
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
			
	
			/* Cliente NAO permite faturamento parcial */
			If SC5->C5_FATPARC = "N"  .AND. NTOTC9LIB > 0 .AND. NTOTC9LIB != NTOTC6VEN .AND. SC5->C5_XITEMC = "TAIFF"  //If SA1->A1_FATPARC = "N"
				SC5->C5__BLOQF := "P"
				cMensLido	:= "Bloqueado, cliente nao permite faturamento parcial"	
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
	
			If .NOT. LSALDOOK	 .AND. SC5->C5_XITEMC = "TAIFF"
				SC5->C5__BLOQF := "S"
				cMensLido	:= "Bloqueado, cliente nao permite faturamento de saldo, item no saldo: " + cItSALDOOK
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
	
			If .NOT. LFRACION .AND. SC5->C5_XITEMC = "TAIFF" //.AND. SC5->C5_CLASPED != "X" 
				SC5->C5__BLOQF := "F"
				cMensLido	:= "Bloqueado, cliente nao permite faturamento fracionado, item fracionado: " + cItFRACION 
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
			/* Fim da validação das regras do cliente */

			If nMaxFatur > 0 .AND. NVALC9LIB > 0 .AND. NVALC9LIB > nMaxFatur   
				cMensLido	:= "Liberado com restrição de frete, valor liberado superior ao valor maximo de frete: " + ALLTRIM(TRANSFORM(nMaxFatur,"@R 999,999,999.99"	))
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
			
			/* PEDIDO DE BONIFICAÇÃO NÃO PASSA PELA ANALISE DO VALOR MINIMO */
			If SC5->C5_CLASPED != "X" 
				/* ---- NVALMINIMO := NVALC9LIB ----- */
				//      NVALMINIMO := NVALMINIMO
				/* Parcela do liberado não atende a parcela minina de faturamento para a UF */
				If nParcelaMin > 0 .AND. NVALC9LIB > 0 
					ACONDPAG 	:= CONDICAO( NVALC9LIB ,SC5->C5_CONDPAG)
					If ACONDPAG[1,2] < nParcelaMin 
						SC5->C5__BLOQF := "C"				
						cMensLido	:= "Bloqueado, parcela " + ALLTRIM(TRANSFORM(ACONDPAG[1,2],"@R 999,999,999.99"	)) + " abaixo do minino " + ALLTRIM(TRANSFORM(nParcelaMin,"@R 999,999,999.99"))
						aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
					EndIf 
				EndIf  		
				
				/* Valor do liberado não atende o valor minino de faturamento para a UF */
				If nValMinFatur > 0 .AND. NVALC9LIB > 0 
					If NVALC9LIB < nValMinFatur 
						SC5->C5__BLOQF := "V"				
						cMensLido	:= "Bloqueado, valor a liberar " + ALLTRIM(TRANSFORM(NVALC9LIB,"@R 999,999,999.99"	)) + " abaixo do minino " + ALLTRIM(TRANSFORM(nValMinFatur,"@R 999,999,999.99"))
						If SC5->C5_FATFRAC = "N"
							cMensLido	:= ALLTRIM(cMensLido) + " pedido nao aceita fracionado"
						EndIf
						aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
					EndIf
				EndIf  		
			EndIf
			
			/*
				aAdd( ATETOLIBER ,{      0.00	,	  49999.00 	, 100	}) // atende pela regra do faturamento minimo
				aAdd( ATETOLIBER ,{  50000.00	,	  99999.99 	, 50 	})
				aAdd( ATETOLIBER ,{ 100000.00	,	 199999.99 	, 30	})
				aAdd( ATETOLIBER ,{ 200000.00	,	9999999.99 	, 25	})
			*/

			/* Validação das regras do Teto de Faturamento */
			If LEN(ATETOLIBER) > 0 .AND. Empty(SC5->C5__BLOQF) .AND. ALLTRIM(SC5->C5_XITEMC) = "TAIFF"
				For nLoopTeto := 1 to Len(ATETOLIBER)

					If NVALC6TET > ATETOLIBER[nLoopTeto,1] .AND. NVALC6TET <= ATETOLIBER[nLoopTeto,2] .AND. ATETOLIBER[nLoopTeto,3] = 100
						/*
							Caso o valor da venda estiver na faixa 1 valerá a regra do faturamento minimo neste caso o campo não sofre intervenção 
							SC5->C5__BLOQF := ""
						*/
						cMensTeto	:= "Liberado pela regra do teto, Venda: " + ALLTRIM(TRANSFORM(NVALC6TET,"@R 999,999,999.99"	)) + " Liberado: " + ALLTRIM(TRANSFORM(NVALC9LIB,"@R 999,999,999.99"	)) + " Falta: " + ALLTRIM(TRANSFORM((NVALC6TET *  (ATETOLIBER[nLoopTeto,3]/100)) - NVALC9LIB ,"@R 999,999,999.99") )
						aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensTeto })
						
					ElseIf NVALC6TET >= ATETOLIBER[nLoopTeto,1] .AND. NVALC6TET <= ATETOLIBER[nLoopTeto,2] .AND. NVALC9LIB < (NVALC6TET *  (ATETOLIBER[nLoopTeto,3]/100))
					 	
						SC5->C5__BLOQF := "T"
						cMensLido	:= "Bloqueado regra do teto, Venda: " + ALLTRIM(TRANSFORM(NVALC6TET,"@R 999,999,999.99"	)) + " Liberado: " + ALLTRIM(TRANSFORM(NVALC9LIB,"@R 999,999,999.99"	)) + " Falta: " + ALLTRIM(TRANSFORM((NVALC6TET *  (ATETOLIBER[nLoopTeto,3]/100)) - NVALC9LIB,"@R 999,999,999.99")) 
						aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
									
					EndIf  
					
				Next							
			EndIf
			
			/*
				Ponto de atualização do minimo quando não passa na liberação loop de liberação, passou apenas pela analise do faturamento mínimo
			*/
			If lAvalMinimo 
				SC5->C5__BLOQF := "V"				
				cMensLido	:= "Bloqueado, valor a liberar " + ALLTRIM(TRANSFORM(NVALMINIMO,"@R 999,999,999.99"	)) + " abaixo do minino " 
				If SC5->C5_FATFRAC = "N"
					cMensLido	:= ALLTRIM(cMensLido) + " pedido nao aceita fracionado"
				EndIf
				aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
			EndIf
			
			If Empty(SC5->C5__BLOQF)
				cMensLido	:= "Valor Liberado: " + ALLTRIM(TRANSFORM(NVALC9LIB,"@R 999,999,999.99"	)) + " Valor da Venda: " + ALLTRIM(TRANSFORM(NVALC6VEN,"@R 999,999,999.99"	)) + ENTER
			EndIf
			

			/* Atualização da data de faturamento conforme regra da data colocada no portal 
				Comando DOW
				Dia da semana | Número |
				--------------+--------+
				Segunda-feira |    2   |
				Terça-feira   |    3   |
				Quarta-feira  |    4   |
				Quinta-feira  |    5   |
				Sexta-feira   |    6   |
				Sábado        |    7   |
				Domingo       |    1   |
			*/


			If .NOT. EMPTY(SC5->C5_DTPEDPR)
				cDtRefProg := SC5->C5_DTPEDPR
				
				If SC5->C5_FILDES="01"  
					If DOW(cDtRefProg) = 2
						cDtRefProg -= 3
					EndIf  
				EndIf
				
//				If dDATABASE >= cDtRefProg  
//					SC5->C5__DTLIBF := IIF( Empty(SC5->C5__BLOQF) , dDataBase , CTOD("  /  /  ") )

				IF (SC5->C5_DTPEDPR <= DDATABASE) ;
					.OR.;
				(SC5->C5_DTPEDPR > dDATABASE .AND. (DAY(SC5->C5_DTPEDPR)-DAY(dDATABASE)) <= nDiasEntrega .AND. MONTH(SC5->C5_DTPEDPR)=MONTH(STOD(CDTALIMIT)) ) ;
					.OR.;
				(SC5->C5_DTPEDPR > dDATABASE .AND. ALLTRIM(STR(DOW(SC5->C5_DTPEDPR - nDiasEntrega))) $ "1|7" .AND. MONTH(SC5->C5_DTPEDPR)=MONTH(SToD(CDTALIMIT)) ) ;
					.OR. ;
				(SC5->C5_DTPEDPR > dDATABASE .AND. SC5->C5_DTPEDPR >= SToD(CDTALIMIT) .AND. MONTH(SC5->C5_DTPEDPR)=MONTH(SToD(CDTALIMIT)) ) 

					SC5->C5__DTLIBF := IIF( Empty(SC5->C5__BLOQF) , dDataBase , CTOD("  /  /  ") )

				Else
					If Empty(SC5->C5__BLOQF) 
						SC5->C5__DTLIBF	:= CTOD("  /  /  ") 
						SC5->C5__BLOQF		:= "G" 
						cMensLido	:= "Bloqueado pela regra de data de faturamento, pedido programado para " + DTOC(SC5->C5_DTPEDPR)  
						aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
					EndIf
				EndIf
			Else
				SC5->C5__DTLIBF := IIF( Empty(SC5->C5__BLOQF) , dDataBase , CTOD("  /  /  ") )
			EndIf
			SC5->C5__LIBM	:= "A"
			SC5->C5_ULIB5 := IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))
			SC5->C5_DLIB5 := dDatabase
			SC5->C5_HLIB5 := Left(Time(),5)
			SC5->C5_PLIB5 := "ESTMI001"
			SC5->C5_HIST5 := SUBSTR(cMensLido,1,100)
			
			
			SC5->(msUnlock())
			
			cMensLido	:= "Valor Liberado: " + ALLTRIM(TRANSFORM(NVALC9LIB,"@R 999,999,999.99"	)) + " Valor da Venda: " + ALLTRIM(TRANSFORM(NVALC6VEN,"@R 999,999,999.99"	)) + ENTER
			cMensLido	+= "Cliente: " + ALLTRIM(SA1->A1_NOME) + ENTER
			cMensLido	+= "Vendedor: " + ALLTRIM(SA3->A3_NOME) + ENTER
			aAdd( aPedVlLib ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })

			/*		              *****  PEDIDO DE VENDA VINCULADO A UMA BONIFICACAO   ****** 
				Quando há vinculo entre pedido de venda e bonficação grava o percentual de bonificacao 
				proporcional à liberação no pedido de venda 
			
			*/
			If SC5->C5_CLASPED = "V" .AND. .NOT. EMPTY(SC5->C5_X_PVBON)
				nO_percentual := 0
				If (.NOT. Empty(SC5->C5__BLOQF)) .OR. NVALC9LIB = 0
					nO_percentual := 0
				ElseIf NVALC9LIB = NVALC6VEN
					nO_percentual := 100 
				ElseIf NVALC9LIB < NVALC6VEN
					nO_percentual := INT( ((NVALC9LIB/NVALC6VEN)*100) )
					If ((int(nO_percentual)/2)) - int((int(nO_percentual)/2)) > 0
						While ((int(nO_percentual)/2)) - int((int(nO_percentual)/2)) > 0 
							nO_percentual += 1
						End					
					EndIf
				EndIf
				dDTVenda	:= SC5->C5__DTLIBF
				cC5BLOQF	:= SC5->C5__BLOQF
				/*
					Toda bonificação receberá o status de faturamento do pedido de venda 
				*/
				ATEMPBNF := {}					
				ATEMPBNF := STRTOKARR(ALLTRIM(SC5->C5_X_PVBON),"/")
				FOR I_bnf := 1 TO LEN(ATEMPBNF)
					DBSELECTAREA("SC5")
					DBORDERNICKNAME("SC5NUMOLD")
					If SC5->(DbSeek(xfilial("SC5") + ATEMPBNF[I_bnf] ))
						If SC5->(RecLock("SC5",.F.))  
							SC5->C5__PERBNF	:= nO_percentual
							If .NOT. EMPTY(SC5->C5__DTLIBF) .AND. EMPTY(SC5->C5__BLOQF) .AND. .NOT. SC5->C5_BNFLIB 
								SC5->C5__DTLIBF	:= Iif( SC5->C5__DTLIBF < dDTVenda, dDTVenda, SC5->C5__DTLIBF )
								SC5->C5__BLOQF		:= cC5BLOQF
							EndIf
						EndIf					
						SC5->(msUnlock())
					EndIf
				NEXT I_bnf
				SC5->(DbSetOrder(1))
				DBSELECTAREA("TRB1")
			EndIf
			/*
				Toda bonificação vinculada a uma pedido de venda receberá o status de faturamento do pedido de venda 
			*/
			If SC5->C5_CLASPED = "X" .AND. .NOT. EMPTY(SC5->C5_X_PVBON) .AND. .NOT. SC5->C5_BNFLIB
				
				nSC5RECNO	:= SC5->(RECNO()) 
				CC5XPVBON	:= ALLTRIM(SC5->C5_X_PVBON)
				
				dDTVenda	:= CTOD("  /  /  ")
				cC5BLOQF	:= "" 

				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")
				If SC5->(DbSeek(xfilial("SC5") + CC5XPVBON ))
					dDTVenda	:= SC5->C5__DTLIBF
					cC5BLOQF	:= SC5->C5__BLOQF
				Else
					cC5BLOQF	:= "B" 
					dDTVenda	:= CTOD("  /  /  ")
				EndIf
				
				SC5->(DbSetOrder(1))
				SC5->(DbGoto( nSC5RECNO ))
				If SC5->(RecLock("SC5",.F.))  
					SC5->C5__DTLIBF	:= dDTVenda
					SC5->C5__BLOQF		:= cC5BLOQF
					SC5->(msUnlock())
				EndIf
									
				If SC5->C5__BLOQF = "B"				
					cMensLido	:= "Bonificação bloqueado por falta liberação na venda" 
					aAdd( aPedLido ,{SC5->C5_NUM,SC5->C5_NUMOLD,SC5->C5_XITEMC , cMensLido })
				EndIf

				DBSELECTAREA("TRB1")
			EndIf

			/* Calculo de embalagem para pedido liberado de produto PROART */
			If SC5->C5_XITEMC = "PROART" .AND. EMPTY(SC5->C5__BLOQF) .AND. .NOT. EMPTY(SC5->C5__DTLIBF)    
				//U_PRTM0003("V")
			EndIf

		Endif
			
	End
	TRB1->(DbCloseArea())

	PutMv("MV__ESTM1" + LEFT(cLinhaProduto,1),"N")

	PutMv("MV__ESTMD" + LEFT(cLinhaProduto,1),DTOC(DDATABASE) + " as " + TIME())
	
	cMensImp := ""
	cCabEmail := ""
	For nLoop := 1 to Len(aPedLido) 
		cMensImp += "Pedido: " + aPedLido[nLoop,1] + " portal: " + aPedLido[nLoop,2] + ENTER
		cMensImp += aPedLido[nLoop,4] + ENTER
		nPosVlLib := Ascan(aPedVlLib,{|x| x[1] = aPedLido[nLoop,1] .AND. x[2] = aPedLido[nLoop,2]}) 
		If nPosVlLib > 0
			cMensImp += aPedVlLib[ nPosVlLib , 4] + ENTER
		EndIf
		cMensImp += "" + ENTER
		cCabEmail := aPedLido[nLoop,3]
	Next
	If .NOT. EMPTY(cMensImp)
		//U_2EnvMail("workflow@taiff.com.br", RTrim(cEmail) ,"",cMensImp , "Pedidos " + ALLTRIM(cCabEmail) + " lidos na liberação automatica no ambiente " + GetEnvServer()	,'')
	EndIf
	GRAVALOG( "ESTMI001", PROCLINE(), "Termino da rotina liberacao de pedidos em lote" , "" , "" )
	If .NOT. lWeb
		MSGALERT("Termino da rotina de liberação de pedidos de venda em lote!" + ENTER + IIF(EMPTY(cMensImp),"Não haviam pedidos a processar!!", "Verifique a caixa de e-mail"),"Atenção")
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Microsiga           º Data ³  08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaSC9()
Local lNaSeparacao := .F.
Local nTTempenho := 0

	/* A rotina a450Grava não está respeitando os pedidos que estão com ordem de separação em andamento */
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek( xFilial("SC9") + TRB1->C9_PEDIDO  )
	While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = TRB1->C9_PEDIDO .AND. .NOT. SC9->(Eof())

		If .NOT. EMPTY(SC9->C9_ORDSEP) .AND. EMPTY( SC9->C9_NFISCAL )
			lNaSeparacao := .T.  
		EndIf

		SC9->(DbSkip())
	End

	If .NOT. lNaSeparacao
		dbSelectArea("SC9")
		dbSetOrder(1)
		If dbSeek( xFilial("SC9") + TRB1->C9_PEDIDO + TRB1->C9_ITEM + TRB1->C9_SEQUEN + TRB1->C9_PRODUTO)
		
			SC9->(a460Estorna())

			nTTempenho := 0
			//DC_FILIAL, DC_PRODUTO, DC_LOCAL, DC_ORIGEM, DC_PEDIDO, DC_ITEM, DC_SEQ, DC_LOTECTL, DC_NUMLOTE, DC_LOCALIZ, DC_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
			SDC->(DbSetOrder(1))
			SDC->(DbSeek( xFilial("SDC") + TRB1->C9_PRODUTO + TRB1->C9_LOCAL + "SC6" + TRB1->C9_PEDIDO + TRB1->C9_ITEM ))
			While !SDC->(Eof()) .AND. xFilial("SDC") + TRB1->C9_PRODUTO + TRB1->C9_LOCAL + "SC6" + TRB1->C9_PEDIDO + TRB1->C9_ITEM = SDC->(DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM)
				nTTempenho += SDC->DC_QUANT
				SDC->(DbSkip())
			End

			If SC6->(RecLock("SC6",.F.))
				SC6->C6_QTDEMP	 := nTTempenho
				SC6->(MsUnlock())
			EndIf 
		EndIf
	EndIf
	/*	
	aSaldos := {}
	a450Grava(1,.F.,.T.,Nil,,.F.)

	If SC9->(RecLock("SC9",.F.))
		SC9->C9_BLINF       := "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME))) +" "+DTOC(dDatabase)+" "+Time()
		SC9->(MsUnlock())
	EndIf
	*/
	
	//U_ESPERA() //TEMPO DE ESPERA PARA EVITAR TRAVAMENTOS

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Microsiga           º Data ³  08/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER Function GravaSC902( cNumPed )
	Local nTTempenho	:= 0
	Local lEstornou	:= .F.
	Local nPosB2S		:= 0
	Local nLibInicial	:= 0
	Local NQTRSVANTES	:= 0
	//Local nPosBonfc	:= 0
	Local nOriLib		:= 0
	Local NREALDISPO	:= 0
	Local lRedzFrac	:= .T.
	Local nQtdFrac 	:= 0
	Local nQean14 		:= 0
	Local nTentativas	:= 0
	Local lTfBloqueado:= .F.
	Local nSC5RECNO	:= 0 
	Local CC5XPVBON	:= ""
	LOCAL APADLISTA := {}

/*
--
-- Rotina aguardará o termino do Faturamento do CrossDocking para dar continuidade e não permitir bloqueio
--
*/
/// atribuir valor ao parametro TF_CROSS quando SIM significa que está em andamento o faturamento 

/* [FIM] */
	 	 			
Begin Transaction

	GRAVALOG( "GravaSC902" , PROCLINE() , "************** INICIO DO BEGIN TRANSACTION **************" , "" , "" )

	/* A rotina a450Grava não está respeitando os pedidos que estão com ordem de separação em andamento */
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek( xFilial("SC9") + cNumPed )
	While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = cNumPed .AND. .NOT. SC9->(Eof())

		If ((.NOT. EMPTY(SC9->C9_ORDSEP)) .AND. EMPTY( SC9->C9_NFISCAL ))
			lEmSeparacao := .T.  
			GRAVALOG( "GravaSC902" , PROCLINE() , "EM SEPARACAO NÃO PROSSEGUE" , cNumPed , SC9->C9_PRODUTO )
		EndIf

		SC9->(DbSkip())
	End

	If .NOT. lEmSeparacao
		
		SC5->(DbSetOrder(1))
		SC5->(DbSeek( xFilial("SC5") + cNumPed ))
		
		dbSelectArea("SC6")
		DBSetOrder(1)
		MsSeek( xFilial("SC6") + cNumPed )
		While !EOF() .And. SC6->C6_NUM == cNumPed .And. SC6->C6_FILIAL == xFilial("SC6")
			
			If SC6->C6_QTDENT < SC6->C6_QTDVEN .AND. SC6->C6_LOCAL  = "21" .AND. EMPTY(SC6->C6_BLQ) 
				/* Funcionalidade do projeto de endereçamento */
				/* Data: 14/05/2020                               Responsável: Carlos Torres*/
				/* ID Controle: 001-ESTMI */
				NDIACORRENTE := DAY(DATE())
				/********************************************************************/
				/*                                                                  */ 
				/********************************************************************/
				//NDIACORRENTE := 27 // <---- COMENTAR QUANDO SUBIR EM PRODUção
				//LPRJENDER := .T.
				/********************************************************************/
				/*                                                                  */ 
				/********************************************************************/
				cTFd3doc	:= ""

				/* Funcionalidade do projeto de endereçamento suspensa por solicitaç?o do Marcio */
				/* para tanto foram removidas as condiç?es relativas ? data limite NDIALIMT
				/* Data: 25/04/2022                               Responsável: Carlos Torres*/
				/* 	de:	Marcio Araujo <marcio.araujo@taiff.com.br>
					para:	Carlos Torres <carlos.torres@taiff.com.br>
					data:	1 de abr. de 2022 08:45
					assunto:	INTERUPÇ?O DE TRANSFER?NCIA PARA ENDEREÇO PICKING
					enviado por:	taiff.com.br
					assinado por:	taiff-com-br.20210112.gappssmtp.com
					Segurança:	 Criptografia padr?o (TLS) Saiba mais
					:	Importante porque voc? marcou como importante.
				 */

				nQtdLib := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) - SC6->C6_QTDEMP) 
				IF LPRJENDER
					IF NDIACORRENTE >= 1 
						SB5->(DBSETORDER( 1 ))
						SB5->(DBSEEK(xFilial("SB5") + SC6->C6_PRODUTO))
						IF INT(nQtdLib/SB5->B5_EAN142) > 0
							APADLISTA := U_TFENDMLT(SC6->C6_PRODUTO,nQtdLib)
							GRAVALOG( "GravaSC902" , PROCLINE() , "ALTERADA PRIORIDADE DO ENDERECO ", cNumPed , SC6->C6_PRODUTO )
						ENDIF
					ENDIF 
				ENDIF
				/* fim de controle 001-ESTMI */
					
				/* 
					Será utilizado o saldo congelado ao iniciar o processamento uma vez que pode  
					ocorrer a atualização de estoque e prejudicar os primeiros pedidos colocados   
				*/		
				SB2->(DbSetOrder(1))
				SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
				// nDispo	:= SaldoMov()
				NREALDISPO	:= SaldoMov()

				nPosB2S	:= aScan(aB2saldo,{|x| AllTrim(x[1]) == Alltrim(SC6->C6_PRODUTO) .AND. AllTrim(x[2]) == Alltrim(SC6->C6_LOCAL)}) 
				nDispo	:= Iif( nPosB2S > 0 , aB2saldo[nPosB2S][3] , 0 )

				If NREALDISPO <= 0 .AND. nDispo > 0
					nDispo := 0 
					aB2saldo[nPosB2S][3] := 0
				EndIf
				GRAVALOG( "GravaSC902" , PROCLINE() , "SALDO DISPONIVEL DO PRODUTO: " + ALLTRIM(STR(nDispo)), cNumPed , SC6->C6_PRODUTO )
				
				If nDispo > 0  
					NQTRSVANTES	:= SB2->B2_RESERVA
					/*
						A função a460Estorna neste ponto é necessária devido as funções MaLibDoFat + a450Grava
						não estão respeitando o que já foi liberado em processamentos anteriores.  
					*/
					nLibInicial := 0
					lEstornou := .F.
					dbSelectArea("SC9")
					dbSetOrder(1)
					dbSeek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM)
					While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = SC6->C6_NUM .AND. SC9->C9_ITEM = SC6->C6_ITEM .AND. (.NOT. SC9->(Eof()))
	
						If EMPTY( SC9->C9_NFISCAL ) .AND. SC6->C6_PRODUTO = SC9->C9_PRODUTO
							If EMPTY(SC9->C9_ORDSEP)  
								nLibInicial += SC9->C9_QTDLIB
								nDispo += SC9->C9_QTDLIB
						
								SC9->(a460Estorna())
								
								NQTRSVANTES	:= SB2->B2_RESERVA
								
								lEstornou := .T.
							EndIf
						EndIf
			
						SC9->(DbSkip())
					End
					If lEstornou
						nTTempenho := 0
						//DC_FILIAL, DC_PRODUTO, DC_LOCAL, DC_ORIGEM, DC_PEDIDO, DC_ITEM, DC_SEQ, DC_LOTECTL, DC_NUMLOTE, DC_LOCALIZ, DC_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
						SDC->(DbSetOrder(1))
						SDC->(DbSeek( xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC6" + SC6->C6_NUM + SC6->C6_ITEM  ))
						While !SDC->(Eof()) .AND. xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC6" + SC6->C6_NUM + SC6->C6_ITEM  = SDC->(DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM)
							nTTempenho += SDC->DC_QUANT
							SDC->(DbSkip())
						End
			
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_QTDEMP	 := nTTempenho
							SC6->(MsUnlock())
						EndIf 
					EndIf
					
					
					GRAVALOG( "GravaSC902" , PROCLINE() ," NECESSIDADE: VENDA (" + ALLTRIM(STR(SC6->C6_QTDVEN)) + ") - JA ENTREGUE (" + ALLTRIM(STR(SC6->C6_QTDENT)) + ") - JA EMPENHADO (" + ALLTRIM(STR(SC6->C6_QTDEMP)) +")"  , cNumPed , SC6->C6_PRODUTO )

					/* NECESSIDADE */
					//nQtdLib  := (SC6->C6_QTDVEN - SC6->C6_QTDENT) - SC6->C6_QTDEMP
					If nDispo >= ((SC6->C6_QTDVEN - SC6->C6_QTDENT) - SC6->C6_QTDEMP) 
						nQtdLib := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) - SC6->C6_QTDEMP) 
					Else
						nQtdLib := nDispo
					EndIf

					/* Verifica se cliente não aceita caixa fracionada caso não aceite será reduzida até chegar ao fator multiplo ou zerar a quantidade */
					If nQtdLib > 0 .AND. SC5->C5_FATFRAC = "N" .AND. ALLTRIM(SC5->C5_CLASPED)="V"
						nQean14 := Posicione("SB5",1, xFilial("SB5") + SC6->C6_PRODUTO ,"B5_EAN141")
						nQtdFrac := nQtdLib 
						If nQtdLib = 1
							nQtdLib := 0 
						ElseIf (nQtdLib / nQean14) - INT(nQtdLib / nQean14) > 0
							lRedzFrac := .T.
							While lRedzFrac
								nQtdLib -= 1
								If nQtdLib < 0 .OR. nQtdLib = 1
									nQtdLib := 0 
									lRedzFrac := .F.
								EndIf 
								If (nQtdLib / nQean14) - INT(nQtdLib / nQean14) = 0
									lRedzFrac := .F.
								EndIf
							End  
							GRAVALOG( "GravaSC902" , PROCLINE() , " CLIENTE NAO ACEITA FRACIONADO QUANTIDADE LIBERADA FOI REDUZIDA DE " + ALLTRIM(STR(nQtdFrac)) + " PARA " + ALLTRIM(STR(nQtdLib)) , cNumPed , SC6->C6_PRODUTO )
						EndIf
					EndIf  
				
					If nQtdLib > 0

						GRAVALOG( "GravaSC902" , PROCLINE() , " INICIO DA LIBERACAO DO ITEM " , cNumPed , SC6->C6_PRODUTO )
						dbSelectArea("SF4")
						dBSetOrder(1)
						MsSeek( xFilial("SF4") + SC6->C6_TES )
						
						If RecLock("SC5")
	
							nOriLib := nQtdLib
							
							If SC5->C5_CLASPED = "X" .AND. .NOT. SC5->C5_BNFLIB 
								/* 
								========================================================================
								Regra descntinuada conforme alinhado com equipe de vendas 
								========================================================================
								De: Carlos Torres <carlos.torres@taiffproart.com.br> 
								Enviada em: quarta-feira, 10 de junho de 2020 18:43
								Para: 'Maria Luisa' <mlrodrigues@taiff.com.br>; 'Cintia Nunes' <cnunes@taiff.com.br>; 'SILVIA CRISTINA BANDEIRA SANTOS' <silvia.bandeira@taiff.com.br>
								Cc: grp_sistemas@taiffproart.com.br; 'Marcio da Guia S de Araujo' <marcio.araujo@taiff.com.br>
								Assunto: Regras de liberação automática
								
								3.	A bonificação será liberada 100% quando houver 50% da venda, e os outros 50% da venda serão desvinculados automaticamente de bonificação.

								*/
								IF 1=2
									If SC5->C5__PERBNF  = 0 .AND. (SC6->C6_QTDVEN = 1 .OR. ((SC6->C6_QTDVEN - SC6->C6_QTDENT) - SC6->C6_QTDEMP) = 1)
										/*
											Neste caso quando a quantidade de bonificação é igual a 1 não há como fracionar a liberação
											portanto libera 
										*/ 
									ElseIf SC5->C5__PERBNF  = 0
										nSC5RECNO	:= SC5->(RECNO()) 
										CC5XPVBON	:= ALLTRIM(SC5->C5_X_PVBON)
						
										DBSELECTAREA("SC5")
										DBORDERNICKNAME("SC5NUMOLD")
										If .NOT. SC5->(DbSeek(xfilial("SC5") + CC5XPVBON ))
											/*
												Neste caso se não encontrar na base o pedido de venda vinculada a bonificação e campo de vinculo marcado como T
												o pedido de bonificacao será empenhado porem status de faturamento será bloqueado. 
											*/ 
										Else
											nQtdLib  := 0
										EndIf 
										SC5->(DbSetOrder(1))
										SC5->(DbGoto( nSC5RECNO ))
									ElseIf SC5->C5__PERBNF  < 100
										If nQtdLib > 1
											nQtdLib := nQtdLib * (SC5->C5__PERBNF / 100) 
											If nQtdLib - INT(nQtdLib) > 0
												If INT( nQtdLib ) > nOriLib
													nQtdLib := nOriLib
												ElseIf INT( nQtdLib ) + 1 > nOriLib
													nQtdLib := INT( nQtdLib )
												Else
													nQtdLib := INT( nQtdLib ) + 1
												EndIF
											Else
												nQtdLib := INT( nQtdLib )
											EndIf
										EndIf
									EndIf
								ENDIF
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Recalcula a Quantidade Liberada                                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RecLock("SC6") //Forca a atualizacao do Buffer no Top
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Libera por Item de Pedido                                               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//Begin Transaction
								/*
								±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
								±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99  ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Descri‡…o ³Liberacao dos Itens de Pedido de Venda                      ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
								±±³          ³controlar a Transacao e os Locks                            ³±±
								±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
								±±³Parametros³ExpN1: Registro do SC6                                      ³±±
								±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
								±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
								±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
								±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
								±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
								±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
								±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
								±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
								±±³          ³       apenas avalia ).                                     ³±±
								±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
								±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
								±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
								±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
								±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
								±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
								*/

								MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.T.,.F.,.T.,.T.,.F.)
								//StaticCall(FATXFUN, MaGravaSC9, SC6->C6_QTDVEN, cBlqCred, cBlqEst, aLocal)
								SC6->(MsUnLock())
							
								GRAVALOG( "GravaSC902" , PROCLINE() , "EXECUTOU MaLibDoFat " , cNumPed , SC6->C6_PRODUTO )
							//End Transaction
							SC5->(MsUnLock())
			 			EndIf
						
						/*/
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
						±±³Fun‡„o    ³A450Grava ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³          ³Rotina de atualizacao da liberacao de credito                ³±±
						±±³          ³                                                             ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
						±±³          ³       2 - Rejeicao                                          ³±±
						±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
						±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
						±±³          ³ExpL4: Indica se exibira o help da liberacao                 ³±±
						±±³          ³ExpA5: Saldo dos lotes a liberar                             ³±±
						±±³          ³ExpA6: Forca analise da liberacao de estoque                 ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Retorno   ³Nenhum                                                       ³±±
						±±³          ³                                                             ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
						±±³          ³venda com base na tabela SC9.                                ³±±
						±±³          ³                                                             ³±±
						±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
						±±³Uso       ³ Materiais                                                   ³±±
						±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
						±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
						ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
						/*/
						If nQtdLib > 0
							aSaldos := {}
							a450Grava(1,.F.,.F.,Nil,,.F.)
							GRAVALOG( "GravaSC902" , PROCLINE() , "EXECUTOU a450Grava" , cNumPed , SC6->C6_PRODUTO )
							If SC9->(RecLock("SC9",.F.))
								SC9->C9_BLINF := "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME))) +" "+DTOC(dDatabase)+" "+Time()
								SC9->(MsUnlock())
							EndIf
							
							IF !EMPTY(cTFd3doc) .AND. LPRJENDER
								U_TFCHAVESD3( cTFd3doc, SC9->C9_PRODUTO, SC9->C9_PEDIDO + SC9->C9_SEQUEN ) // Atualiza a chave do movimento na SD3
							ENDIF

							If 	1=2 //SC9->C9_BLEST != "02"
								SB2->(DbSetOrder(1))
								SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
	
						
								//If SB2->(RecLock("SB2",.F.))
								//	SB2->B2_RESERVA := SB2->B2_RESERVA + NQTRSVANTES  
								//	SB2->(MsUnlock()) 
								//EndIf	
								nTentativas	:= 0
								lTfBloqueado	:= .F.
								While .NOT. lTfBloqueado
									If !SB2->(MsRLock())
										nTentativas += 1
										If nTentativas >= 1000000000000000
											lTfBloqueado	:= .T.
										EndIf
									Else
										lTfBloqueado	:= .T.
										
										SB2->B2_RESERVA := SB2->B2_RESERVA + NQTRSVANTES  
										SB2->(MsUnlock())
										 
									EndIf
								End
								
							EndIf
						EndIf
						
						IF 1=2
							nTTempenho := 0
							//DC_FILIAL, DC_PRODUTO, DC_LOCAL, DC_ORIGEM, DC_PEDIDO, DC_ITEM, DC_SEQ, DC_LOTECTL, DC_NUMLOTE, DC_LOCALIZ, DC_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
							SDC->(DbSetOrder(1))
							SDC->(DbSeek( xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC6" + SC6->C6_NUM + SC6->C6_ITEM ))
							While !SDC->(Eof()) .AND. xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC6" + SC6->C6_NUM + SC6->C6_ITEM = SDC->(DC_FILIAL + DC_PRODUTO + DC_LOCAL + DC_ORIGEM + DC_PEDIDO + DC_ITEM)
								nTTempenho += SDC->DC_QUANT
								SDC->(DbSkip())
							End
				
							If SC6->(RecLock("SC6",.F.))
								SC6->C6_QTDEMP	 := nTTempenho
								SC6->(MsUnlock())
							EndIf 
						ENDIF									
							
						If SC9->C9_BLEST = "02"
							cItC9BLEST := SC6->C6_PRODUTO
						EndIf
				
						SA1->(DbGoTo( nSA1Recno )) // reposicionar o codigo do cliente pois pode se tratar de cliente + cross docking
						If SA1->A1__SALDO = "N"
							If SC6->C6_QTDVEN - (SC6->C6_QTDENT + SC6->C6_QTDEMP) > 0      
								LSALDOOK := .F.
								cItSALDOOK := SC6->C6_PRODUTO
							EndIf
						EndIF
						nQean14 := Posicione("SB5",1, xFilial("SB5") + SC6->C6_PRODUTO ,"B5_EAN141")
				
						If SC5->C5_FATFRAC = "N" // SA1->A1_FATFRAC = "N" 
							If ((SC6->C6_QTDVEN - (SC6->C6_QTDENT + SC6->C6_QTDEMP))  / nQean14) - INT(((SC6->C6_QTDVEN - (SC6->C6_QTDENT + SC6->C6_QTDEMP))  / nQean14)) > 0 
								LFRACION := .F.
								cItFRACION := SC6->C6_PRODUTO
							EndIf
						EndIf
				
						If SC6->(RecLock("SC6",.F.))
							SC6->C6__BLINF	:= "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))+" "+DTOC(dDatabase)+" "+Time()
							SC6->(MsUnlock())
						EndIf 
				
						NTOTC9LIB += SC6->C6_QTDEMP
						NVALC9LIB += (SC6->C6_QTDEMP * SC6->C6_PRCVEN)
				
						/* Subtrair do saldo acumulado a quantidade empenhada*/
						If nPosB2S > 0
							GRAVALOG( "GravaSC902" , PROCLINE() , "ATUALIZA MATRIZ DE SALDO  aB2saldo: " + ALLTRIM(STR(aB2saldo[nPosB2S][3])) + " nDispo " + ALLTRIM(STR(nDispo))  + " SC6->C6_QTDEMP " + ALLTRIM(STR(SC6->C6_QTDEMP)) + " nLibInicial " + ALLTRIM(STR(nLibInicial)), cNumPed , SC6->C6_PRODUTO )
		
							aB2saldo[nPosB2S][3] := aB2saldo[nPosB2S][3] + nLibInicial // Acrescenta no saldo a liberação estornada
							
							aB2saldo[nPosB2S][3] := aB2saldo[nPosB2S][3] - SC6->C6_QTDEMP
							 
							If  aB2saldo[nPosB2S][3] < 0
								aB2saldo[nPosB2S][3] := 0
							EndIf
							
							GRAVALOG( "GravaSC902" , PROCLINE() , " ATUALIZA MATRIZ DE SALDO   aB2saldo[nPosB2S][3] = " + ALLTRIM(STR(aB2saldo[nPosB2S][3])), SC5->C5_NUM , SB2->B2_COD )
						EndIf   
						/* 
							Neste ponto é forçada a atualização da reserva na SB2 pois as funções MaLibDoFat + a450Grava não o estão fazendo 
						*/
						cAliasSDC := "SDCTAIFF"
						cQuery := "SELECT ISNULL(SUM(DC_QUANT),0) AS TT_DCQUANT " + ENTER
						cQuery += "FROM " + RetSqlName("SDC") + " SDC WITH(NOLOCK) " + ENTER
						cQuery += "WHERE SDC.DC_FILIAL = '" + xFilial("SDC") + "' AND " + ENTER
						cQuery += "SDC.D_E_L_E_T_ = ' ' AND " + ENTER
						cQuery += "DC_PRODUTO = '" + SC6->C6_PRODUTO + "' AND " + ENTER
						cQuery += "DC_LOCAL = '" + SC6->C6_LOCAL + "'" + ENTER
						
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSDC,.T.,.T.)
				
						SB2->(DbSetOrder(1))
						SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
						IF (cAliasSDC)->TT_DCQUANT != SB2->B2_RESERVA
							//If SB2->(RecLock("SB2",.F.))
							//	SB2->B2_RESERVA := (cAliasSDC)->TT_DCQUANT
							//	SB2->(MsUnlock()) 
							//EndIf	
							nTentativas	:= 0
							lTfBloqueado	:= .F.
							While .NOT. lTfBloqueado
								If !SB2->(MsRLock())
									nTentativas += 1
									If nTentativas >= 1000000000000000
										lTfBloqueado	:= .T.
									EndIf
								Else
									lTfBloqueado	:= .T.
									
									SB2->B2_RESERVA := (cAliasSDC)->TT_DCQUANT
									SB2->(MsUnlock())
									
								EndIf
							End
						
						EndIf
					
						(cAliasSDC)->(DbCloseArea())
					EndIf
				EndIf				
				IF LPRJENDER
					SB1->(DBSetOrder(1))
					SB1->(DBSeek( xFilial("SB1") + SC6->C6_PRODUTO))
					SBF->(DBSetOrder(1)) // BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
					IF SBF->(DbSeek( xFilial("SBF") + "21" + SUBSTRING(SB1->B1_YENDEST + SPACE(TamSX3("BF_LOCALIZ")[1]),1,TamSX3("BF_LOCALIZ")[1]) + SB1->B1_COD))
						IF SBF->(RecLock("SBF",.F.))  
							SBF->BF_PRIOR := "001"
							SBF->(msUnlock())
						ENDIF
						GRAVALOG( "GravaSC902" , PROCLINE() , "ATUALIZOU A PRIORIDADE DO ENDERECO" , cNumPed , SC6->C6_PRODUTO )
					ENDIF
				ENDIF

			EndIf			
			dbSelectArea("SC6")
			dbSkip()
		End
		
		MaLiberOk({ SC5->C5_NUM },.F.)
		GRAVALOG( "GravaSC902" , PROCLINE() , "EXECUTOU MaLiberOk" , SC5->C5_NUM , "" )
		
		// U_ESPERA() //TEMPO DE ESPERA PARA EVITAR TRAVAMENTOS
	EndIf
	GRAVALOG( "GravaSC902" , PROCLINE() , "************** FIM DO BEGIN TRANSACTION **************" , "" , "" )
End Transaction
		
Return

/***************************************************************************/
/***************************************************************************/
/* Reserva de pedido com controle de reserva                               */
/***************************************************************************/
/***************************************************************************/
Static Function GravaSC0( cNumPed )
Local aOPERINCL	:= {}
Local aOPERDELE	:= {}
Local cNUMERO		:= "" 
Local aLOTE		:= {"","","",""}                                           
Local lNovoNum		:= .F.
Local nQtdReser	:= 0
Local nReservado	:= 0
Local nVendido		:= 0  
Local cRsrvEmail	:= Iif( At( "DESENV" , GetEnvServer() ) != 0, "carlos.torres@taiff.com.br","grp_vendas@taiff.com.br" )
Local cMensImp 	:= ""
Local cIdCliente	:= ""
Local cIdLoja		:= ""
Local cChaveSDC 	:= ""
//Local nTopSDC		:= 0
//Local aSDCrecno 	:= {}
Local NRVALC6VEN	:= 0 
Local NRVALC9LIB	:= 0
Local lRetRsrv		:= .T.

/*
aOPERACAO		vetor				[1] -> [Operacao : 1 Inclui,2 Altera,3 Exclui]
									[2] -> [Tipo da Reserva]
									[3] -> [Documento que originou a Reserva]
									[4] -> [Solicitante]
									[5] -> [Filial da Reserva]
									[6] -> [Observacao]
cNUMERO			caracter			Número da reserva
cPRODUTO		caracter			Código do produto
cLOCAL			caracter			Almoxarifado da reserva
nQUANT			numerico			Quantidade reservada
aLOTE			vetor				[1] -> [Numero do Lote]
									[2] -> [Lote de Controle]
									[3] -> [Localizacao]
									[4] -> [Numero de Serie]
aHEADER			vetor				aHeader com os campos da getdados. Somente utilizar para gravar campos do usuário.
aCOLS			vetor				Acols da getdados. Somente utilizar para gravar campos de usuário.
*/

SF4->(dBSetOrder(1))

SC5->(DbSetOrder(1))
SC5->(DbSeek( xFilial("SC5") + cNumPed ))

SC6->(DbSetOrder(1))
SC6->(DbSeek( xFilial("SC6") + cNumPed ))

SC0->(DbSetOrder(1))

cNUMERO := GETSX8NUM("SC0","C0_NUM")
lNovoNum := .T.

Begin Transaction
	While SC6->C6_FILIAL = xFilial("SC6") .AND. SC6->C6_NUM=cNumPed .AND. .NOT. SC6->(Eof())
		SF4->(DbSeek( xFilial("SF4") + SC6->C6_TES ))
		
		If SF4->F4_ESTOQUE = "S" .AND. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0  
	
			IF SC0->(DBSEEK( XFILIAL("SC0") + SC6->C6_RESERVA + SC6->C6_PRODUTO + SC6->C6_LOCAL ))
			
				cChaveSDC := xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC0" + SC6->C6_RESERVA + SPACE(20) + SC6->C6_LOCALIZ + SPACE(20)
					
				nQtdReser := SC6->C6_QTDVEN - SC6->C6_QTDRESE
				
				If nQtdReser > 0
	
					aOPERDELE := {3,"PD",SC0->C0_TIPO,SC0->C0_DOCRES,SC0->C0_SOLICIT,SC0->C0_FILRES} // exclue
	
					aOPERINCL := {1,"PD",cNumPed,"SCHDL",CFILANT,"(ESTMI001) PEDIDO: " + cNumPed} // inclui
				 
					SB2->(DbSetOrder(1))
					SB2->(DbSeek(xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL  ))
		
					//nDispo	:= SaldoMov() 
					nPosB2S	:= aScan(aB2saldo,{|x| AllTrim(x[1]) == Alltrim(SC6->C6_PRODUTO) .AND. AllTrim(x[2]) == Alltrim(SC6->C6_LOCAL)}) 
					nDispo	:= Iif( nPosB2S > 0 , aB2saldo[nPosB2S][3] , 0 )
					
					If nDispo <= nQtdReser .AND. nDispo > 0
						nQtdReser := nDispo
					EndIf
							
					If nDispo > 0 .AND. nQtdReser > 0
						nQtdReser += SC6->C6_QTDRESE
						
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_QTDRESE	:= 0
							SC6->C6__BLINF		:= "ESTMI001-" + SC0->C0_NUM
							SC6->C6_RESERVA	:= "" 
							SC6->(MsUnlock())
						EndIf
						If SC0->(Reclock( "SC0", .F. ))
							SC0->C0_QUANT := SC0->C0_QTDORIG
							SC0->( MsUnlock() )
						EndIf
						
						lRetRsrv := A430Reserv(aOPERDELE,SC0->C0_NUM,SC0->C0_PRODUTO,SC0->C0_LOCAL,SC0->C0_QUANT ,{	SC0->C0_NUMLOTE,SC0->C0_LOTECTL,SC0->C0_LOCALIZ,SC0->C0_NUMSERI})
	
						If !lRetRsrv
						Else
							aB2saldo[nPosB2S][3] := aB2saldo[nPosB2S][3] + SC0->C0_QUANT
						Endif
						
						A430Reserv(aOPERINCL,cNUMERO,SC6->C6_PRODUTO , SC6->C6_LOCAL , nQtdReser ,{	SC0->C0_NUMLOTE,SC0->C0_LOTECTL,SC0->C0_LOCALIZ,SC0->C0_NUMSERI})
						
						If SC6->(RecLock("SC6",.F.))
							SC6->C6_RESERVA	:= cNUMERO 
							SC6->C6_QTDRESE	:= nQtdReser
							SC6->C6__BLINF		:= "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))+" "+DTOC(dDatabase)+" "+Time()
							SC6->(MsUnlock())
						EndIf
						If SC0->(RecLock("SC0",.F.))
							SC0->C0_QUANT  -= nQtdReser
							SC0->C0_QTDPED += nQtdReser
							SC0->C0_VALIDA	:= DDATABASE + 20
							SC0->(MsUnlock())
						EndIf
							
						aB2saldo[nPosB2S][3] := aB2saldo[nPosB2S][3] - nQtdReser
							 
						If  aB2saldo[nPosB2S][3] < 0
							aB2saldo[nPosB2S][3] := 0
						EndIf
						
					EndIf
				EndIf
		
			Else
				aOPERINCL := {1,"PD",cNumPed,"SCHDL",CFILANT,"(ESTMI001) PEDIDO: " + cNumPed} 
			
				SB2->(DbSetOrder(1))
				SB2->(DbSeek(xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL  )) 
				
				//nDispo	:= SaldoMov()					
				nPosB2S	:= aScan(aB2saldo,{|x| AllTrim(x[1]) == Alltrim(SC6->C6_PRODUTO) .AND. AllTrim(x[2]) == Alltrim(SC6->C6_LOCAL)}) 
				nDispo	:= Iif( nPosB2S > 0 , aB2saldo[nPosB2S][3] , 0 )

				nQtdReser := SC6->C6_QTDVEN - SC6->C6_QTDENT 
				nQtdReser := Iif( nQtdReser > nDispo , nDispo , nQtdReser )  
				
				If nDispo > 0 .AND. nQtdReser > 0
				
					A430Reserv(aOPERINCL,cNUMERO,SC6->C6_PRODUTO , SC6->C6_LOCAL , nQtdReser  ,aLOTE)
		
					// Vincula ao pedido a reserva
					If SC6->(RecLock("SC6",.F.))
						SC6->C6_RESERVA	:= cNUMERO
						SC6->C6_QTDRESE	:= nQtdReser
						SC6->C6__BLINF		:= "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))+" "+DTOC(dDatabase)+" "+Time()
						SC6->C6_LOCALIZ 	:= SBF->BF_LOCALIZ
						SC6->(MsUnlock())
					EndIf
					If SC0->C0_NUM = cNUMERO .AND. SC0->C0_PRODUTO = SC6->C6_PRODUTO
						If SC0->(RecLock("SC0",.F.))
							SC0->C0_QUANT  -= nQtdReser
							SC0->C0_QTDPED += nQtdReser
							SC0->C0_LOCALIZ := SBF->BF_LOCALIZ
							SC0->C0_VALIDA	:= DDATABASE + 20
						EndIf
					EndIf
		
					aB2saldo[nPosB2S][3] := aB2saldo[nPosB2S][3] - nQtdReser
							 
					If  aB2saldo[nPosB2S][3] < 0
						aB2saldo[nPosB2S][3] := 0
					EndIf
					
				EndIf
		
				
			EndIf
			
		
			nReservado += SC6->C6_QTDRESE
			nVendido	+= SC6->C6_QTDVEN  
		EndIf
		SC6->(DbSkip())           
	End
	
	IF lNovoNum
		CONFIRMSX8()
	ENDIF
	If SC5->(RecLock("SC5",.F.)) .AND. nReservado > 0
		If nReservado != nVendido
		
			SC5->C5__DTLIBF := CTOD("  /  /  ")
			SC5->C5__LIBM	:= "A"
			SC5->C5_ULIB5 := IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))
			SC5->C5_DLIB5 := dDatabase
			SC5->C5_HLIB5 := Left(Time(),5)
			SC5->C5_PLIB5 := "ESTMI001"
			SC5->C5_HIST5 := "Percentual de reserva: " + ALLTRIM(TRANSFORM( ((nReservado/nVendido)*100),"@R 999.99"	))  
			SC5->(msUnlock())
		
		ElseIf nReservado = nVendido  
	
			If (.NOT. SC5->C5_CONDPAG $ cCondAvist) // pedido com condição de pagamento a vista não é liberado
				SF4->(dBSetOrder(1))
				SB2->(DbSetOrder(1))
				
				SC6->(DbSetOrder(1))
				SC6->(DbSeek( xFilial("SC6") + cNumPed ))
		
		 		NRVALC6VEN	:= 0 
		 		NRVALC9LIB	:= 0
				While SC6->C6_FILIAL = xFilial("SC6") .AND. SC6->C6_NUM=cNumPed .AND. .NOT. SC6->(Eof()) 
		
					cChaveSDC := xFilial("SDC") + SC6->C6_PRODUTO + SC6->C6_LOCAL + "SC0" + SC6->C6_RESERVA + SPACE(20) + SC6->C6_LOCALIZ + SPACE(20)
					
					SB2->(DbSeek( xFilial("SB2") + SC6->C6_PRODUTO + SC6->C6_LOCAL))
					SF4->(DbSeek( xFilial("SF4") + SC6->C6_TES ))
				
					If RecLock("SC5")
						nQtdLib  := SC6->C6_QTDRESE  
						RecLock("SC6") 
						MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.T.,.F.,.T.,.T.,.F.)					
					EndIf
					SC6->(MsUnLock())
	
					/*
					If nQtdLib > 0
						aSaldos := {}
						a450Grava(1,.F.,.T.,Nil,,.T.)
						If SC9->(RecLock("SC9",.F.))
							SC9->C9_BLINF := "ESTMI001-" + IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME))) +" "+DTOC(dDatabase)+" "+Time()
							SC9->(MsUnlock())
						EndIf
						
					EndIf
					*/
					
					NRVALC6VEN += (SC6->C6_QTDVEN - SC6->C6_QTDENT ) * SC6->C6_PRCVEN 
					NRVALC9LIB += (SC6->C6_QTDEMP * SC6->C6_PRCVEN)
					
					SC6->(DbSkip())           
				End
		
				cMensLido	:= "Valor Liberado: " + ALLTRIM(TRANSFORM(NRVALC9LIB,"@R 999,999,999.99"	)) + " Valor da Venda: " + ALLTRIM(TRANSFORM( NRVALC6VEN,"@R 999,999,999.99"	)) + ENTER
				SC5->C5__DTLIBF := dDataBase
			Else
				cMensLido	:= "Percentual de reserva: " + ALLTRIM(TRANSFORM( ((nReservado/nVendido)*100),"@R 999.99"	))    
				SC5->C5__DTLIBF := CTOD("  /  /  ")
			EndIf
			SC5->C5__LIBM	:= "A"
			SC5->C5_ULIB5 := IIF(lWeb,"SCHDL",Upper(Rtrim(CUSERNAME)))
			SC5->C5_DLIB5 := dDatabase
			SC5->C5_HLIB5 := Left(Time(),5)
			SC5->C5_PLIB5 := "ESTMI001"
			SC5->C5_HIST5 :=   cMensLido
			SC5->(msUnlock())

			cIdCliente := IIF(  Empty(SC5->C5_CLIORI), SC5->C5_CLIENTE, SC5->C5_CLIORI )
			cIdLoja 	:= IIF(  Empty(SC5->C5_LOJORI), SC5->C5_LOJACLI, SC5->C5_LOJORI )
			
			SA3->(DbSetOrder(1))
			SA3->(DbSeek( xFilial("SA3") + SC5->C5_VEND1 ))
	
			SA1->(DbSetOrder(1))
			SA1->(DbSeek( xFilial("SA1") + cIdCliente + cIdLoja	))
	
			cMensImp	:= "Pedido: " + SC5->C5_NUM + " - Portal: " + SC5->C5_NUMOLD 
			cMensImp	+= "Percentual reservado: " + ALLTRIM(STR( (nReservado/nVendido)*100 )) + ENTER
			cMensImp	+= "Cliente: " + ALLTRIM(SA1->A1_NOME) + ENTER
			cMensImp	+= "Vendedor: " + ALLTRIM(SA3->A3_NOME) + ENTER
			
			U_2EnvMail("workflow@taiff.com.br", RTrim(cRsrvEmail) ,"",cMensImp , "Pedido com controle de reserva (" + GetEnvServer() + ") "	,'')

			/*		              *****  PEDIDO DE VENDA VINCULADO A UMA BONIFICACAO   ****** 
				Quando há vinculo entre pedido de venda e bonficação grava o percentual de bonificacao 
			   proporcional à liberação no pedido de venda 
			
			*/
			If SC5->C5_CLASPED = "V" .AND. .NOT. EMPTY(SC5->C5_X_PVBON)
				nO_percentual := 0
				If (.NOT. Empty(SC5->C5__BLOQF)) .OR. NVALC9LIB = 0
					nO_percentual := 0
				ElseIf NVALC9LIB = NVALC6VEN
					nO_percentual := 100 
				ElseIf NVALC9LIB < NVALC6VEN
					nO_percentual := INT( ((NVALC9LIB/NVALC6VEN)*100) )
					If ((int(nO_percentual)/2)) - int((int(nO_percentual)/2)) > 0
						While ((int(nO_percentual)/2)) - int((int(nO_percentual)/2)) > 0 
							nO_percentual += 1
						End					
					EndIf
				EndIf
				cBnfPedido := ALLTRIM(SC5->C5_X_PVBON)
				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")
				If SC5->(DbSeek(xfilial("SC5") + cBnfPedido ))
					If SC5->(RecLock("SC5",.F.))  
						SC5->C5__PERBNF := nO_percentual
					EndIf					
					SC5->(msUnlock())
				EndIf
				SC5->(DbSetOrder(1))
			EndIf

		EndIf
		 
	EndIf
End Transaction

Return


/***************************************************************************/
/***************************************************************************/
/* Alimenta matriz com saldo disponível                                    */
/***************************************************************************/
/***************************************************************************/

Static Function TFSaldoMov(cMARCA)
	Local cQuery	:= ""
	Local nRec		:= 0
	Local NQTEMPROCESSO := 0
	Local nLoopSb2	:= 0
	
	aB2saldo	:= {}

	cQuery := "SELECT DISTINCT" + ENTER 
	cQuery += "	C6_PRODUTO, C6_LOCAL  " + ENTER
	cQuery += "FROM SC6030 C6 WITH(NOLOCK)" + ENTER
	cQuery += "INNER JOIN SC5030 C5 WITH(NOLOCK) " + ENTER
	cQuery += "	ON C5_NUM = C6_NUM " + ENTER
	cQuery += "  	AND C5_FILIAL = C6_FILIAL " + ENTER
	cQuery += "	AND C5.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND C5_LIBCOM != '2' " + ENTER
	cQuery += "	AND C5_XLIBCR = 'L' " + ENTER
	cQuery += "	AND C5__LIBM != 'M' " + ENTER
	cQuery += "	AND C5_TIPO NOT IN ('D','B') " + ENTER 
	cQuery += "	AND RTRIM(C5_XITEMC) = '" + cMARCA + "'" + ENTER
	cQuery += "	AND (CASE " + ENTER
	cQuery += "		WHEN C5_DTPEDPR = '' THEN 0" + ENTER
	cQuery += "		WHEN CONVERT(DATE,C5_DTPEDPR) > CONVERT(DATE,GETDATE()) THEN DATEDIFF(day,CONVERT(DATE,GETDATE()),CONVERT(DATE,C5_DTPEDPR))" + ENTER
	cQuery += "		WHEN CONVERT(DATE,C5_DTPEDPR) <= CONVERT(DATE,GETDATE()) THEN DATEDIFF(day,CONVERT(DATE,C5_DTPEDPR),CONVERT(DATE,GETDATE()))" + ENTER
	cQuery += "		ELSE 0" + ENTER
	cQuery += "		END) <= " + ALLTRIM(STR(nDiasEntrega)) + ENTER
	cQuery += "WHERE C6_QTDENT < C6_QTDVEN" + ENTER  
	cQuery += "	AND C6_LOCAL  = '21' " + ENTER
	cQuery += "	AND C6_BLQ = '' " + ENTER
	cQuery += "	AND C6.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND C6_FILIAL = '02'" + ENTER
	cQuery += "	AND RTRIM(C6_XITEMC) = '" + cMARCA + "' " + ENTER
	cQuery += "ORDER BY C6_PRODUTO" + ENTER
	
	//MemoWrite("ESTMI001_PRODUTOS_SALDO_ATUAL.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXSB', .F., .T.)
	
	Count To nRec
	
	If nRec != 0
		AUXSB->(DbGoTop())
		SB2->(DbSetOrder(1))
		While !AUXSB->(Eof())
		
			SB2->(DbSeek( xFilial("SB2") + AUXSB->C6_PRODUTO + AUXSB->C6_LOCAL))
			
			nDispo	:= SaldoMov()

			/* verifica se o produto está em processo e levanta qual o saldo necessário a reservar */
			NQTEMPROCESSO := TFemProcesso( AUXSB->C6_PRODUTO, AUXSB->C6_LOCAL,cMARCA )
			nDispo	:= nDispo	- NQTEMPROCESSO   
			
			If nDispo < 0
				nDispo	:= 0  
			EndIf
			
			aAdd( aB2saldo ,  {AUXSB->C6_PRODUTO, AUXSB->C6_LOCAL , nDispo, NQTEMPROCESSO , SB2->B2_QATU , SB2->B2_RESERVA , SB2->B2_QACLASS }  )
			
			AUXSB->(DbSkip())
		End
	EndIf
	
	AUXSB->(DbCloseArea())
	
	GRAVALOG( "TFSaldoMov", PROCLINE(), "*** LISTA DOS PRODUTOS COM SALDO DISPONIVEL NA SB2 ***" , , )
	GRAVALOG( "TFSaldoMov", PROCLINE(), "PRODUTO         | DISPONIVEL | EM PROCESS | B2_QATU    | B2_RESERVA | B2_QACLASS" , , )
	//      XXXXXXXXXXXXXXX | 9999999999 | 9999999999 | 9999999999 | 9999999999 | 9999999999 
	For nLoopSb2 := 1 to Len(aB2saldo)
		If aB2saldo[nLoopSb2,3] > 0
			GRAVALOG( "TFSaldoMov", PROCLINE(), aB2saldo[nLoopSb2,1] + " | " + STR(aB2saldo[nLoopSb2,3],10) +  " | " + STR(aB2saldo[nLoopSb2,4],10) +  " | " + STR(aB2saldo[nLoopSb2,5],10)+  " | " + STR(aB2saldo[nLoopSb2,6],10)+  " | " + STR(aB2saldo[nLoopSb2,7],10) , , )
		EndIf
	Next
	GRAVALOG( "TFSaldoMov", PROCLINE(), "*** FIM DA LISTA DO SALDOS NA SB2 ***" , , )

	cQuery := "SELECT " + ENTER
	cQuery += "	RTRIM(BE_LOCALIZ) AS ENDERECO" + ENTER
	cQuery += "	,BE_DESCRIC AS DESCRICAO" + ENTER
	cQuery += "	,ISNULL(BF_PRIOR,BE_PRIOR) AS PRIORIDADE" + ENTER
	cQuery += "	,ISNULL(BF_PRODUTO,'') AS PRODUTO" + ENTER
	cQuery += "	,ISNULL(BF_QUANT,0) AS QTD_ENDERECO" + ENTER
	cQuery += "	,ISNULL(BF_EMPENHO,0) AS QTD_EMPENHO" + ENTER
	cQuery += "	,ISNULL(BF_QUANT-BF_EMPENHO,0) AS QTD_DISPONIVEL" + ENTER
	cQuery += "FROM SBE030 SBE WITH(NOLOCK) " + ENTER
	cQuery += "LEFT OUTER JOIN SBF030 SBF WITH(NOLOCK) " + ENTER
	cQuery += "	ON BF_FILIAL = BE_FILIAL " + ENTER
	cQuery += "	AND BF_LOCALIZ = BE_LOCALIZ " + ENTER
	cQuery += "	AND BF_LOCAL=BE_LOCAL " + ENTER
	cQuery += "	AND SBF.D_E_L_E_T_ ='' " + ENTER
	cQuery += "WHERE BE_FILIAL='02' AND BE_DESCRIC LIKE '%TAIFF%' AND SBE.D_E_L_E_T_ ='' AND BE_LOCALIZ!='EXP'" + ENTER
	cQuery += "	AND BE_LOCAL='21'" + ENTER
	cQuery += " ORDER BY PRODUTO" + ENTER

	//MemoWrite("ESTMI001_PRODUTOS_SALDO_ATUAL_POR_ENDERECO.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXSB', .F., .T.)
	
	Count To nRec
	
	If nRec != 0
		GRAVALOG( "TFSaldoMov", PROCLINE(), "*** LISTA DOS PRODUTOS COM SALDO DISPONIVEL NO ENDERECO ***" , , )
		GRAVALOG( "TFSaldoMov", PROCLINE(), "PRODUTO         | PRIORIDADE | ENDERECO        | QTD_ENDERECO | QTD_EMPENHO | QTD_DISPONIVEL" , , )
		//                                   XXXXXXXXXXXXXXX   XXX          XXXXXXXXXXXXXXX   9999999999     9999999999    9999999999
        //                                   1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//                                            1         2         3         4         5         6         7         8         9
		AUXSB->(DbGoTop())
		SB2->(DbSetOrder(1))
		While !AUXSB->(Eof())
		
			GRAVALOG( "TFSaldoMov", PROCLINE(), AUXSB->PRODUTO + " | " + AUXSB->PRIORIDADE + SPACE(07) + " | " + AUXSB->ENDERECO + " | " + STR(AUXSB->QTD_ENDERECO,10) + SPACE(02) + " | " + STR(AUXSB->QTD_EMPENHO,10) + SPACE(01) + " | " + STR(AUXSB->QTD_DISPONIVEL,10), , )
			
			AUXSB->(DbSkip())
		End
	EndIf
	
	AUXSB->(DbCloseArea())
	GRAVALOG( "TFSaldoMov", PROCLINE(), "*** FIM DA LISTA DO SALDOS POR ENDERECO ***" , , )

Return 

/***************************************************************************/
/***************************************************************************/
/* Calcula o valor minimo do pedido                                        */
/***************************************************************************/
/***************************************************************************/

Static Function TFCalcMinimo( cPedidoChave, cMARCA )
	Local cQuery	:= ""
	Local nRec		:= 0
	Local nVlCalc	:= 0
	Local lRedzFrac := .T.
	
	NVALMINIMO	:= 0
	
	cQuery := "SELECT " + ENTER 
	cQuery += "	(C6_QTDVEN-C6_QTDENT) AS C6_VENDA" + ENTER
	cQuery += "	,(C6_QTDVEN - (C6_QTDENT+C6_QTDEMP)) AS C6_TETOVENDA" + ENTER
	cQuery += "	,C6_PRCVEN " + ENTER
	cQuery += "	,C6_PRODUTO " + ENTER
	cQuery += "	,C6_LOCAL " + ENTER
	cQuery += "FROM SC6030 C6 WITH(NOLOCK)" + ENTER
	cQuery += "WHERE C6_QTDENT < C6_QTDVEN" + ENTER  
	cQuery += "	AND C6_LOCAL  = '21' " + ENTER
	cQuery += "	AND C6_BLQ = '' " + ENTER
	cQuery += "	AND C6.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += "	AND C6_FILIAL = '02'" + ENTER
	cQuery += "	AND RTRIM(C6_XITEMC) = '" + cMARCA + "'" + ENTER
	cQuery += "	AND C6_NUM = '" + cPedidoChave + "'" + ENTER
	
	
	//MemoWrite("ESTMI001_VALOR_MINIMO.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXMN', .F., .T.)
	
	Count To nRec
	
	If nRec != 0

		AUXMN->(DbGoTop())
		While .NOT. AUXMN->(Eof())
			
			nPosB2S	:= aScan(aB2saldo,{|x| AllTrim(x[1]) == Alltrim(AUXMN->C6_PRODUTO) .AND. AllTrim(x[2]) == Alltrim(AUXMN->C6_LOCAL)}) 
			nDispo	:= Iif( nPosB2S > 0 , aB2saldo[nPosB2S][3] , 0 )

			/* Verifica se cliente não aceita caixa fracionada caso não aceite será reduzida até chegar ao fator multiplo ou zerar a quantidade */
			If nDispo > 0 .AND. SC5->C5_FATFRAC = "N"
				nQean14 := Posicione("SB5",1, xFilial("SB5") + AUXMN->C6_PRODUTO ,"B5_EAN141")
				If nDispo = 1
					nDispo := 0 
				ElseIf (nDispo / nQean14) - INT(nDispo / nQean14) > 0
					lRedzFrac := .T.
					While lRedzFrac
						nDispo -= 1
						If nDispo < 0 .OR. nDispo = 1
							nDispo := 0 
							lRedzFrac := .F.
						EndIf 
						If (nDispo / nQean14) - INT(nDispo / nQean14) = 0
							lRedzFrac := .F.
						EndIf
					End  
				EndIf
			EndIf  

			
			If nDispo < AUXMN->C6_VENDA .AND. nDispo > 0 
				nVlCalc += nDispo * AUXMN->C6_PRCVEN
			ElseIf nDispo > 0
				nVlCalc += AUXMN->C6_VENDA * AUXMN->C6_PRCVEN
			EndIf

			NTOTC6VEN += AUXMN->C6_VENDA 
			NVALC6VEN += AUXMN->C6_VENDA * AUXMN->C6_PRCVEN

			NTOTC6TET += AUXMN->C6_TETOVENDA 
			NVALC6TET += AUXMN->C6_TETOVENDA * AUXMN->C6_PRCVEN
			
			AUXMN->(DbSkip())
		End 
		
		SA1->(DbGoTo( nSA1Recno ))

		nValMinFatur	:= 0
		nParcelaMin	:= 0
		ZAV->(DbSetOrder(1))
		If ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) + SA1->A1_COD_MUN ))
			nValMinFatur	:= ZAV->ZAV_VALMIN
			nParcelaMin	:= ZAV->ZAV_PARCEL
		ElseIf ZAV->(DbSeek( xFilial("ZAV") + SA1->A1_EST + ALLTRIM(SC5->C5_XITEMC) ))
			nValMinFatur	:= ZAV->ZAV_VALMIN
			nParcelaMin	:= ZAV->ZAV_PARCEL
		EndIf

		If nParcelaMin > 0 .AND. nVlCalc > 0 
			ACONDPAG 	:= CONDICAO( nVlCalc ,SC5->C5_CONDPAG)
			If ACONDPAG[1,2] < nParcelaMin 
				NVALMINIMO := nVlCalc
			EndIf 
		EndIf  		
		
		/* Valor do liberado não atende o valor minino de faturamento para a UF */
		If nValMinFatur > 0 .AND. nVlCalc > 0  
			If nVlCalc < nValMinFatur 
				NVALMINIMO := nVlCalc
			EndIf
		EndIf  		
	
	EndIf
	
	AUXMN->(DbCloseArea())

Return ()  

/***************************************************************************/
/***************************************************************************/
/* Levanta a saldo do que está em processo pendente de atendimento         */
/***************************************************************************/
/***************************************************************************/

Static Function TFemProcesso( cIdProduto, cIdLocal,cIDMARCA )
	Local cQuery	:= ""
	Local nRec		:= 0
	Local nRetorno	:= 0
	
	cQuery := "SELECT " + ENTER
	cQuery += "	SUM(C6_QTDVEN  - (C6_QTDENT + C6_QTDEMP)) AS QT_EMPROCESSO " + ENTER
	cQuery += "FROM "+RetSqlName("SC5")+" SC5 WITH(NOLOCK)" + ENTER
	cQuery += "INNER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK)" + ENTER
	cQuery += "	ON SC6.D_E_L_E_T_='' " + ENTER
	cQuery += "	AND C6_NUM=C5_NUM " + ENTER
	cQuery += "	AND C6_FILIAL=C5_FILIAL " + ENTER
	cQuery += "	AND C6_LOCAL='" + cIdLocal + "' " + ENTER
	cQuery += "	AND C6_PRODUTO='" + cIdProduto + "' " + ENTER
	cQuery += "	AND C6_BLQ = '' " + ENTER
	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK)" + ENTER
	cQuery += "	ON SF4.D_E_L_E_T_='' " + ENTER
	cQuery += "	AND F4_CODIGO=C6_TES " + ENTER
	cQuery += "	AND F4_FILIAL=C6_FILIAL " + ENTER
	cQuery += "	AND F4_ESTOQUE='S' " + ENTER
	cQuery += "INNER JOIN "+RetSqlName("SC9")+" SC9 WITH(NOLOCK)" + ENTER
	cQuery += "	ON SC9.D_E_L_E_T_='' " + ENTER
	cQuery += "	AND C9_FILIAL=C6_FILIAL " + ENTER
	cQuery += "	AND C9_PEDIDO=C6_NUM " + ENTER
	cQuery += "	AND C9_ITEM=C6_ITEM " + ENTER
	cQuery += "	AND C9_PRODUTO=C6_PRODUTO " + ENTER
	cQuery += "	AND C9_NFISCAL='' " + ENTER
	cQuery += "WHERE C5_FILIAL='" + xFilial("SC5") +"'  " + ENTER
	cQuery += "	AND SC5.D_E_L_E_T_=''  " + ENTER
	cQuery += "	AND C5_XITEMC =  '" + cIDMARCA + "'" + ENTER
	cQuery += "	AND C5__DTLIBF != '' " + ENTER
	cQuery += "	AND C5_TIPO='N' " + ENTER
	cQuery += "	AND C5_LIBCOM != '2' " + ENTER

	//MemoWrite("ESTMI001_PRODUTO_EM_PROCESSO.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXPR', .F., .T.)
	
	Count To nRec
	
	If nRec != 0
		AUXPR->(DbGoTop())
		nRetorno := AUXPR->QT_EMPROCESSO
		If nRetorno < 0
			nRetorno := 0 
		EndIf
	EndIf
	
	AUXPR->(DbCloseArea())
Return (nRetorno) 

/***************************************************************************/
/***************************************************************************/
/* Associa os pedidos de venda aos pedidos de bonificaçao                  */
/***************************************************************************/
/***************************************************************************/
Static Function TFAssocBonf()
	Local cQuery	:= ""
	//Local nRec		:= 0
	Local nRetorno	:= 0
	Local cPedVndK	:= ""
	Local nPonteiro:= 0
	local cPedBnfK	:= ""
	
	cQuery := "SELECT " + ENTER
	cQuery += "	SC5_VND.R_E_C_N_O_ AS N_POSICAO" + ENTER
	cQuery += "	,SC5_BNF.C5_NUMOLD AS C5_NUMOLD" + ENTER
	cQuery += "	,SC5_VND.C5_NUM AS C5_NUM " + ENTER
	cQuery += "FROM "+RetSqlName("SC5")+" SC5_VND " + ENTER
	cQuery += "INNER JOIN "+RetSqlName("SC5")+" SC5_BNF" + ENTER
	cQuery += "	ON SC5_BNF.C5_FILIAL=SC5_VND.C5_FILIAL" + ENTER
	cQuery += "	AND SC5_BNF.C5_CLASPED = 'X' " + ENTER
	cQuery += "	AND SC5_BNF.C5_X_PVBON != '' " + ENTER
	cQuery += "	AND SC5_BNF.D_E_L_E_T_ = '' " + ENTER
	cQuery += "	AND ( ISNULL(SC5_BNF.C5_NOTA, '') = '' OR ISNULL(SC5_BNF.C5_LIBEROK, '') != 'E' AND ISNULL(SC5_BNF.C5_BLQ, '') != '' )" + ENTER
	cQuery += "	AND RTRIM(SC5_BNF.C5_X_PVBON) = SC5_VND.C5_NUMOLD " + ENTER
	cQuery += "WHERE SC5_VND.C5_FILIAL='02'" + ENTER
	cQuery += "	AND SC5_VND.C5_CLASPED = 'V' " + ENTER
	cQuery += "	AND SC5_VND.C5_TIPO='N' " + ENTER
	cQuery += "	AND SC5_VND.D_E_L_E_T_=''" + ENTER
	cQuery += "	AND SC5_VND.C5_X_PVBON=''" + ENTER
	cQuery += "	AND ( ISNULL(SC5_VND.C5_NOTA, '') = '' OR ISNULL(SC5_VND.C5_LIBEROK, '') != 'E' AND ISNULL(SC5_VND.C5_BLQ, '') != '' ) " + ENTER
	cQuery += "ORDER BY SC5_VND.C5_NUM" + ENTER

	//MemoWrite("ESTMI001_PEDIDOS_DE_VENDA_SEM_ASSOCIACAO_NA_BONIF.SQL",cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXBNF', .F., .T.)
	
	AUXBNF->(DbGoTop())
	While .NOT. AUXBNF->(Eof())
		cPedVndK	:= AUXBNF->C5_NUM
		nPonteiro	:= AUXBNF->N_POSICAO
		cPedBnfK	:= ""
		While .NOT. AUXBNF->(Eof()) .AND. AUXBNF->C5_NUM = cPedVndK
			If .NOT. EMPTY(cPedBnfK)
				cPedBnfK	+= "/"
			EndIf 
		 	cPedBnfK	+= AUXBNF->C5_NUMOLD
			AUXBNF->(DbSkip())
		End
		
		If .NOT. EMPTY(cPedBnfK)
			SC5->(DbGoTo(nPonteiro))
			If EMPTY(SC5->C5_X_PVBON) .AND. ALLTRIM(SC5->C5_X_LIBON) != "L"
				If SC5->(RecLock("SC5",.F.))  
					SC5->C5_X_PVBON := cPedBnfK
				EndIf					
				SC5->(msUnlock())
			EndIf
		EndIf
		
	End 
	
Return (nRetorno) 


/***************************************************************************/
/***************************************************************************/
/* LOCALIZA ENDEREÇOS COM SALDO DISPONIVEL DE ESTOQUE REFERENCIA MÚLTIPLA  */
/***************************************************************************/
/***************************************************************************/
USER FUNCTION TFENDMLT(CIDPRODUTO,nQtdLib)
LOCAL NMOVESLD	:= 0
LOCAL ALISTA	:= {}
LOCAL CQUERY	:= ""
LOCAL NSLDEND	:= 0
LOCAL NLENLOCALZ:= 0
LOCAL CLOCALIZ 	:= "" 


SB1->(DBSetOrder(1))
SB1->(DBSeek( xFilial("SB1") + CIDPRODUTO))
IF SB1->B1_LOCALIZ="S"
	NMOVESLD := nQtdLib

	CQUERY := "SELECT BF_LOCALIZ, BF_QUANT, BF_EMPENHO " + ENTER
	CQUERY += "FROM " + RetSqlName("SBF") + " SBF WITH(NOLOCK) " + ENTER
	CQUERY += "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH(NOLOCK) " + ENTER
	CQUERY += " ON SB1.D_E_L_E_T_='' " + ENTER
	CQUERY += " AND B1_COD=BF_PRODUTO " + ENTER
	CQUERY += " AND B1_FILIAL=BF_FILIAL " + ENTER
	CQUERY += "WHERE BF_FILIAL='02' " + ENTER
	CQUERY += " AND SBF.D_E_L_E_T_=''" + ENTER
	CQUERY += " AND BF_PRODUTO = '" + CIDPRODUTO + "'" + ENTER
	CQUERY += " AND (BF_QUANT - BF_EMPENHO) > 0 " + ENTER
	CQUERY += " AND BF_LOCALIZ != B1_YENDEST " + ENTER
	CQUERY += " AND BF_LOCAL='21' " + ENTER
	CQUERY += "ORDER BY BF_QUANT DESC" + ENTER

	//MemoWrite("ESTMI001_SALDO_SBF_ENDERECOS.SQL",CQUERY)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,CQUERY), 'AUXSBF', .F., .T.)
	
	AUXSBF->(DbGoTop())
	While .NOT. AUXSBF->(Eof())
		IF (AUXSBF->BF_QUANT - AUXSBF->BF_EMPENHO) >= NMOVESLD .AND. NMOVESLD != 0
			AADD(ALISTA,{AUXSBF->BF_LOCALIZ , NMOVESLD })
			NMOVESLD := 0
		ELSEIF (AUXSBF->BF_QUANT - AUXSBF->BF_EMPENHO) < NMOVESLD .AND. NMOVESLD != 0
			NSLDEND := (AUXSBF->BF_QUANT - AUXSBF->BF_EMPENHO)
			AADD(ALISTA,{AUXSBF->BF_LOCALIZ , NSLDEND })
			NMOVESLD := NMOVESLD - NSLDEND
			IF NMOVESLD < 0
				NMOVESLD := 0
			ENDIF
		ENDIF
		AUXSBF->(DbSkip())
	END
	AUXSBF->(DBCLOSEAREA())

	NLENLOCALZ	:= TamSX3("BF_LOCALIZ")[1]
	CLOCALIZ	:= SUBSTRING(SB1->B1_YENDEST + SPACE(NLENLOCALZ),1,NLENLOCALZ)

	SBF->(DBSetOrder(1)) // BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
	IF SBF->(DbSeek( xFilial("SBF") + "21" + CLOCALIZ + SB1->B1_COD))
		IF SBF->(RecLock("SBF",.F.))  
		 	SBF->BF_PRIOR := "ZZZ"
			SBF->(msUnlock())
		ENDIF
	ENDIF

ENDIF

RETURN (ALISTA)

/****************************************************************************************/
/* REGRA DA TRANSFERENCIA                                                               */ 
/****************************************************************************************/
/* Caso a quantidade do pedido for multiplo deverá buscar o saldo nos endereços estoque */
/* em não havendo saldo nos endereços estoque deverá buscar o saldo do endereço picking */
/* e em não havendo saldo no picking deve transferir o saldo do estoque ao picking      */
/****************************************************************************************/
USER FUNCTION TFTRANSLD(CIDPRODUTO,nQtdLib)
LOCAL LRETORNO := .T.
LOCAL LMOVESLD := .F.
LOCAL NMOVESLD := 0
Local aAuto	:= {}
Local aItem := {}
Local aLinha := {}
Local alista := {} //Produto Utilizado
Local nX := 0
LOCAL CNOMELOG := "ESTMI001_MOVE_SALDO_DO_PRODUTO_" + Alltrim(CIDPRODUTO) + ".LOG"
LOCAL CLOCAL	:= "21"
LOCAL LSLDOK 	:= .F.
LOCAL NLENLOCALZ:= 0
LOCAL CLOCALIZ	:= ""

Local nOpcAuto := 3

Private lMsErroAuto := .F.


SB1->(DBSetOrder(1))
SB1->(DBSeek( xFilial("SB1") + CIDPRODUTO))
IF .NOT. EMPTY(SB1->B1_YENDEST) .AND. SB1->B1_LOCALIZ="S"
	SB5->(DBSETORDER( 1 ))
	SB5->(DBSEEK(xFilial("SB5") + CIDPRODUTO ))


	NLENLOCALZ	:= TamSX3("BF_LOCALIZ")[1]
	CLOCALIZ	:= SUBSTRING(SB1->B1_YENDEST + SPACE(NLENLOCALZ),1,NLENLOCALZ)

	LSLDOK 	:= .F.
	/* FASE I - BUSCA SALDO QUANDO MULTIPLO */
	IF INT(nQtdLib/SB5->B5_EAN142) > 0 
		SBF->(DBSETORDER( 2 ))  //BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
		SBF->(DBSEEK( xFilial("SBF") + CIDPRODUTO + CLOCAL ))
		WHILE .NOT. SBF->(EOF()) .AND. SBF->BF_PRODUTO=CIDPRODUTO .AND. SBF->BF_LOCAL = CLOCAL
			IF ALLTRIM(SBF->BF_LOCALIZ) != ALLTRIM(SB1->B1_YENDEST)
				IF (SBF->BF_QUANT - SBF->BF_EMPENHO) >= nQtdLib
					LSLDOK := .T.
				ENDIF
			ENDIF
			SBF->(DBSKIP())
		END
		IF LSLDOK 
			SBF->(DBSetOrder(1)) // BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
			IF SBF->(DbSeek( xFilial("SBF") + CLOCAL + CLOCALIZ + CIDPRODUTO))
				IF SBF->(RecLock("SBF",.F.))  
					SBF->BF_PRIOR := "ZZZ"
					SBF->(msUnlock())
				ENDIF
			ENDIF
		ENDIF
	ENDIF

	/* FASE II - BUSCA SALDO DO PICKING */
	IF .NOT. LSLDOK 
		SBF->(DBSETORDER( 2 ))  //BF_FILIAL, BF_PRODUTO, BF_LOCAL, BF_LOTECTL, BF_NUMLOTE, BF_PRIOR, BF_LOCALIZ, BF_NUMSERI, R_E_C_N_O_, D_E_L_E_T_
		SBF->(DBSEEK( xFilial("SBF") + CIDPRODUTO + CLOCAL ))
		WHILE .NOT. SBF->(EOF()) .AND. SBF->BF_PRODUTO=CIDPRODUTO .AND. SBF->BF_LOCAL = CLOCAL
			IF ALLTRIM(SBF->BF_LOCALIZ) = ALLTRIM(SB1->B1_YENDEST)
				IF (SBF->BF_QUANT - SBF->BF_EMPENHO) >= nQtdLib
					LSLDOK := .T.
				ENDIF
			ENDIF
			SBF->(DBSKIP())
		END	
	ENDIF 

	/* FASE III - TRANSFERE O SALDO AO PINCKING */
	IF .NOT. LSLDOK 
		LMOVESLD := .F.
		NMOVESLD := nQtdLib
		SBF->(DBSetOrder(2))
		SBF->(DbSeek( xFilial("SBF") + CIDPRODUTO + CLOCAL ))
		WHILE .NOT. SBF->(Eof()) .AND. SBF->BF_FILIAL = xFilial("SBF") .AND. SBF->BF_PRODUTO=CIDPRODUTO .AND. SBF->BF_LOCAL=CLOCAL
			IF .NOT. (ALLTRIM(SBF->BF_LOCALIZ) = ALLTRIM(SB1->B1_YENDEST) .AND. (SBF->BF_QUANT - SBF->BF_EMPENHO) > 0) .AND. NMOVESLD>0
				LMOVESLD := .T.
				IF (SBF->BF_QUANT - SBF->BF_EMPENHO) >= NMOVESLD
					NQTDMOV := NMOVESLD
					NMOVESLD -= NQTDMOV
				ELSEIF NMOVESLD > (SBF->BF_QUANT - SBF->BF_EMPENHO)
					NQTDMOV := (SBF->BF_QUANT - SBF->BF_EMPENHO)
					NMOVESLD -= NQTDMOV
				ENDIF
				AADD(alista,{SBF->BF_LOCALIZ,NQTDMOV})
			ENDIF
			SBF->(DbSkip())
		END

		IF LMOVESLD 
			//Cabecalho a Incluir
			cTFd3doc := TFMAXNUM() //GetSxeNum("SD3","D3_DOC")
			aadd(aAuto,{cTFd3doc,dDataBase}) //Cabecalho

			//Itens a Incluir 
			aItem := {}

			for nX := 1 to len(alista)

				aLinha := {}
				//Origem 
				aadd(aLinha,{"ITEM"			,'00'+cvaltochar(nX),Nil})
				aadd(aLinha,{"D3_COD"		, SB1->B1_COD, Nil}) //Cod Produto origem 
				aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC, Nil}) //descr produto origem 
				aadd(aLinha,{"D3_UM"		, SB1->B1_UM, Nil}) //unidade medida origem 
				aadd(aLinha,{"D3_LOCAL"		, SB1->B1_LOCPAD, Nil}) //armazem origem 
				aadd(aLinha,{"D3_LOCALIZ"	, PadR(alista[nX,1], tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem

				aadd(aLinha,{"D3_COD"		, SB1->B1_COD, Nil}) //cod produto destino 
				aadd(aLinha,{"D3_DESCRI"	, SB1->B1_DESC, Nil}) //descr produto destino 
				aadd(aLinha,{"D3_UM"		, SB1->B1_UM, Nil}) //unidade medida destino 
				aadd(aLinha,{"D3_LOCAL"		, SB1->B1_LOCPAD, Nil}) //armazem destino 
				aadd(aLinha,{"D3_LOCALIZ"	, PadR(ALLTRIM(SB1->B1_YENDEST), tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino

				aadd(aLinha,{"D3_NUMSERI"	, "", Nil}) //Numero serie
				aadd(aLinha,{"D3_LOTECTL"	, "", Nil}) //Lote Origem
				aadd(aLinha,{"D3_NUMLOTE"	, "", Nil}) //sublote origem
				aadd(aLinha,{"D3_DTVALID"	, '', Nil}) //data validade 
				aadd(aLinha,{"D3_POTENCI"	, 0, Nil}) // Potencia
				aadd(aLinha,{"D3_QUANT"		, alista[nX,2], Nil}) //Quantidade
				aadd(aLinha,{"D3_QTSEGUM"	, 0, Nil}) //Seg unidade medida
				aadd(aLinha,{"D3_ESTORNO"	, "", Nil}) //Estorno 
				aadd(aLinha,{"D3_NUMSEQ"	, "", Nil}) // Numero sequencia D3_NUMSEQ

				aadd(aLinha,{"D3_LOTECTL"	, "", Nil}) //Lote destino
				aadd(aLinha,{"D3_NUMLOTE"	, "", Nil}) //sublote destino 
				aadd(aLinha,{"D3_DTVALID"	, '', Nil}) //validade lote destino
				aadd(aLinha,{"D3_ITEMGRD"	, "", Nil}) //Item Grade

				aadd(aLinha,{"D3_CODLAN"	, "", Nil}) //cat83 prod origem
				aadd(aLinha,{"D3_CODLAN"	, "", Nil}) //cat83 prod destino 

				aAdd(aAuto,aLinha)

			Next nX

			MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

			if lMsErroAuto 
				MOSTRAERRO("\SYSTEM\",CNOMELOG)
			EndIf
			//SLEEP( 1000 * 15 )
		ENDIF
	ENDIF
ENDIF

RETURN (LRETORNO)

/***************************************************************************/
/***************************************************************************/
/* BUSCA O ULTIMO NUMERO DO DOCUMENTO DE TRANSFERENCIA AUTOMATICA          */
/***************************************************************************/
/***************************************************************************/
STATIC FUNCTION TFMAXNUM()
LOCAL CMAXSD3	:= ""
LOCAL cQuery	:= ""
LOCAL nRec		:= 0
	
cQuery := " SELECT MAX(D3_DOC) AS D3_DOC" + ENTER
cQuery += " FROM "+RetSqlName("SD3")+" SD3" + ENTER
cQuery += " WHERE D3_FILIAL = '02'" + ENTER
cQuery += " AND SD3.D_E_L_E_T_ = ''" + ENTER
cQuery += " AND SD3.D3_EMISSAO > '20200101'" + ENTER
cQuery += " AND LEFT(SD3.D3_DOC,2) = 'TF' " + ENTER

//MemoWrite("ESTMI001_ULTIMO_DOC_SD3.SQL",cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'AUXSD3', .F., .T.)

DBSelectArea("AUXSD3")

Count To nRec
AUXSD3->(DBGOTOP())

IF nRec = 0
	CMAXSD3	:= "TF0000001"
ELSE
	CMAXSD3 := "TF" + STRZERO( VAL(RIGHT(AUXSD3->D3_DOC,7)) + 1 , 7)
ENDIF
AUXSD3->(DBCLOSEAREA())

RETURN (CMAXSD3)

/***************************************************************************/
/***************************************************************************/
/* GRAVA EM ARQUIVO TEXTO LOG DO PROCESSAMENTO                             */
/***************************************************************************/
/***************************************************************************/
STATIC FUNCTION GRAVALOG( CFUNCAO, NLINHA, CTEXTO , CPEDIDO , CPRODUTO )
LOCAL cArqLog 	:= "\logs\ESTIMI001_LOG_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
LOCAL CTEXTO1	:= ""

   IF ALLTRIM(CFUNCAO) = "TFSaldoMov"
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += CTEXTO 
		MEMOWRITE(cArqLog,cTEXTO1)
   ELSE
		cTEXTO1	:= MEMOREAD( cArqLog ) + ENTER
		cTEXTO1 += CTEXTO + ENTER
		IF EMPTY(CPEDIDO)
			cTEXTO1 += " ACIONADO POR: " + Upper(Rtrim(CUSERNAME)) + ENTER
		ENDIF
		cTEXTO1 += CFUNCAO + " - Linha: " + alltrim(str(NLINHA)) + " hora log: " + TIME() + ENTER
		IF .NOT. EMPTY(CPEDIDO)
			cTEXTO1 += " PEDIDO=" + CPEDIDO  
		ENDIF
		IF .NOT. EMPTY(CPRODUTO)
			cTEXTO1 += " PRODUTO=" + CPRODUTO  
		ENDIF

		MEMOWRITE(cArqLog,cTEXTO1)
	ENDIF
RETURN
