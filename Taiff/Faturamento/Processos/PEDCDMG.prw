#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	PEDCDMG.prw
=================================================================================
||   Funcao: 	PEDCDMG
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para realizar Copia de Pedido de Venda caso o mesmo esteja 
|| 	com Status como ERRCOP no Campo C5_STCROSS. 
|| 
=================================================================================
||	 CNUMPED  | C | Numero do Pedido de Vendas 
|| 	 LAUTO    | B | Informar se eh um processo automatico
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	28/10/2015
=================================================================================
=================================================================================
*/

USER FUNCTION PEDCDMG(CNUMPED,LAUTO)

	LOCAL CQUERY 	:= ""
	LOCAL NREGS		:= 0
	LOCAL ACABSC5	:= {}
	LOCAL ADETSC6	:= {}
	LOCAL ATMPSC6	:= {}
	LOCAL AAREASC5	:= SC5->(GETAREA())
	LOCAL _CFILOLD	:= CFILANT
	Local cPedPortalTa := ""
	Local cC5transp 		:= ""
	Local cA1transp 		:= ""
	Local cC5trcnpj 		:= ""
	Local cA1trcnpj 		:= ""
	Local I				:= 0
	PRIVATE LMSERROAUTO	:= .F.
	PRIVATE NPOSPROD		:= 0
	PRIVATE NPOSITEM		:= 0

/*
|---------------------------------------------------------------------------------
|	Somente sera realizado o processo de copia para Pedidos com Status de ERRCOP
|	Essa validacao somente sera realizada quando nao for um processo automatico.
|---------------------------------------------------------------------------------
*/
	IF SC5->C5_CLASPED = "A" .AND. !LAUTO

		MSGSTOP("Este processo não pode ser utilizado por Pedido " + ENTER + "pertencente a assistência técnica!","ATENÇÃO")
		RETURN

	ENDIF
	IF .NOT. (SC5->C5_STCROSS $ "ERRCOP|AGCOPY") .AND. !LAUTO

		MSGSTOP("Este processo só pode ser utilizado em Pedido com" + ENTER + 'o Status de "Erro na Cópia do Pedido para CD"',"ATENÇÃO")
		RETURN

	ENDIF

	IF !LAUTO
		IF MESSAGEBOX("Confirma a Cópia do Pedido " + CNUMPED + "?","ATENÇÃO",4) = 7

			MSGINFO("Processo cancelado pelo usuário!","INFORMAÇÃO")
			RETURN

		ENDIF
	ENDIF

/*
|---------------------------------------------------------------------------------
|	Verifica se ja existe Cópia do Pedido no CD de MG
|---------------------------------------------------------------------------------
*/
	CQUERY := "SELECT" 									+ ENTER
	CQUERY += "	COUNT(*) AS NQTD" 						+ ENTER
	CQUERY += "FROM" 									+ ENTER
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 			+ ENTER
	CQUERY += "WHERE" 									+ ENTER
	CQUERY += "	SC5.C5_FILIAL = '02' AND" 				+ ENTER
	CQUERY += "	SC5.C5_NUMORI = '" + CNUMPED + "' AND" 	+ ENTER
	CQUERY += "	SC5.D_E_L_E_T_ = ''"

	IF SELECT("TRB") > 0
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
	ENDIF

	TCQUERY CQUERY NEW ALIAS "TRB"
	DBSELECTAREA("TRB")
	DBGOTOP()

	IF TRB->NQTD > 0

		IF !LAUTO
			MSGINFO("Já existe uma Cópia do Pedido no CD de MG!" + ENTER + "Entre em contato com o Departamento de TI.","Cópia para CD de MG")
		ENDIF
		RETURN

	ENDIF

/*
|---------------------------------------------------------------------------------
|	Inicio do Processo de Cópia do Pedido
|---------------------------------------------------------------------------------
*/
	CURSORWAIT()

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
		AADD(ACABSC5,{"C5_CLIENT"	,TMP->A1_COD 	     	})
		IF LAUTO
			AADD(ACABSC5,{"C5_LOJACLI"	,"01"					})
			AADD(ACABSC5,{"C5_LOJAENT"	,"01"					})
		ELSE
			AADD(ACABSC5,{"C5_LOJACLI"	,TMP->A1_LOJA			})
			AADD(ACABSC5,{"C5_LOJAENT"	,TMP->A1_LOJA			})
		ENDIF
		AADD(ACABSC5,{"C5_EMISSAO"	,DDATABASE				})
		AADD(ACABSC5,{"C5_VEND1"	,SC5->C5_VEND1			})
		AADD(ACABSC5,{"C5_DESC1"	,SC5->C5_DESC1			})
		AADD(ACABSC5,{"C5_TPFRETE"	,"C"					})
		AADD(ACABSC5,{"C5_FINALID"	,"2"					})
		AADD(ACABSC5,{"C5_INTER"  	,"S"					})
		AADD(ACABSC5,{"C5_CLASPED"	,SC5->C5_CLASPED		})
		AADD(ACABSC5,{"C5_FILDES"	,SC5->C5_FILDES			})
		AADD(ACABSC5,{"C5_PCFRETE"	,SC5->C5_PCFRETE		})
		AADD(ACABSC5,{"C5_EMPDES"	,SC5->C5_EMPDES			})
		AADD(ACABSC5,{"C5_ESPECI1"	,"CAIXA"				})
		AADD(ACABSC5,{"C5_OBSERVA"	,SC5->C5_OBSERVA		})
		AADD(ACABSC5,{"C5_MENNOTA"	,"PEDIDO PORTAL: " + SC5->C5_NUMOLD + ENTER + SC5->C5_MENNOTA	})
		AADD(ACABSC5,{"C5_XLIBCR"	,SC5->C5_XLIBCR			})
		AADD(ACABSC5,{"C5_NUMOLD"	,SC5->C5_NUMOLD			})
		AADD(ACABSC5,{"C5_XITEMC"	,SC5->C5_XITEMC			})
		AADD(ACABSC5,{"C5_NUMORI"	,SC5->C5_NUM			})
		AADD(ACABSC5,{"C5_CLIORI"	,SC5->C5_CLIENTE		})
		AADD(ACABSC5,{"C5_LOJORI"	,SC5->C5_LOJACLI		})
		AADD(ACABSC5,{"C5_NOMORI"	,SC5->C5_NOMCLI			})
		AADD(ACABSC5,{"C5_FATFRAC"	,SC5->C5_FATFRAC		})
		AADD(ACABSC5,{"C5_FATPARC"	,SC5->C5_FATPARC		})
		AADD(ACABSC5,{"C5_DTPEDPR"	,SC5->C5_DTPEDPR		})
		AADD(ACABSC5,{"C5_NUMOC"	,"CROSS"				}) // Texto simples que dará apoio ao processo de Recebimento Cross Docking
		AADD(ACABSC5,{"C5_TABELA"	,SC5->C5_TABELA			})
		AADD(ACABSC5,{"C5_CONDPAG"	,SC5->C5_CONDPAG		})
		AADD(ACABSC5,{"C5_PCTFEIR"	,SC5->C5_PCTFEIR		})
		AADD(ACABSC5,{"C5_TPPCTFE"	,SC5->C5_TPPCTFE		})
		AADD(ACABSC5,{"C5_NOMCLI"	,SC5->C5_NOMCLI			})
		AADD(ACABSC5,{"C5_X_PVBON"	,SC5->C5_X_PVBON			})
		AADD(ACABSC5,{"C5_USRBNF"	,SC5->C5_USRBNF			})
		AADD(ACABSC5,{"C5_OBSBNF"	,SC5->C5_OBSBNF			})
		AADD(ACABSC5,{"C5_BNFLIB"	,SC5->C5_BNFLIB			})
		AADD(ACABSC5,{"C5_TRANSP"		,cA1transp			})

		ACABSC5 := U_FCARRAYEXEC("SC5",ACABSC5,.F.)
		ADETSC6 := {}

		cPedPortalTa := SC5->C5_NUMOLD

		DBSELECTAREA("SC6")
		DBSETORDER(1)

		IF !LAUTO
			DBSEEK(XFILIAL("SC6") + CNUMPED)
		ELSE
			DBSEEK("01" + CNUMPED)
		ENDIF

		WHILE SC6->(!EOF()) .AND. SC6->C6_NUM = CNUMPED

			DBSELECTAREA("SX3")
			DBSETORDER(1)
			DBSEEK("SC6")
			WHILE SX3->(!EOF()) .AND. SX3->X3_ARQUIVO = "SC6"
				If AT( ALLTRIM(SX3->X3_CAMPO) , 'C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_UM|C6_LOCAL|C6_DESCRI|C6_TES|C6_CLI|C6_LOJA|C6_XITEMC|C6_PRCVEN|C6_VALOR|C6_PRUNIT|C6_ENTREG' ) != 0
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
			If NREGS > 0
				ATMPSC6[NREGS][2] := "21"
			EndIf

			AADD(ADETSC6,ATMPSC6)
			ATMPSC6 := {}
			SC6->(DBSKIP())

		ENDDO

		IF !LAUTO
			RESET ENVIRONMENT
			RPCSETTYPE ( 3 )
			PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL "02" MODULO "FAT"
			SLEEP(1500)
		ENDIF

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
				CURSORARROW()
				IF !LAUTO
					MSGALERT(OEMTOANSI(	"Erro ao tentar gerar cópia de Pedido de Vendas!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))
				ENDIF
				MOSTRAERRO()

			ENDIF

		END TRANSACTION
	/*
		A função padrão CodSitTri() está gravando em C6_CALSFIS indevidamente a origem do ultimo item do pedido 
		para todos os itens nos pedidos criados em EXTREMA para o PROTHEUS 12
		Isto ocorre apenas no processo do CROSSDOCKING já que não utilizamos a funcionalidade RPC 
	*/
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
		EndIf

		LRET := LMSERROAUTO

		IF !LAUTO
			RESET ENVIRONMENT
			PREPARE ENVIRONMENT EMPRESA CEMPANT FILIAL _CFILOLD MODULO "FAT"
			SLEEP(1500)
		ENDIF

		DBSELECTAREA("SC5")
		DBGOTO(AAREASC5[3])

		RECLOCK("SC5",.F.)
		IF LRET
			SC5->C5_STCROSS = 'ERRCOP'
		ELSE
			SC5->C5_STCROSS = 'ABERTO'
		ENDIF
		MSUNLOCK()

		IF !LAUTO
			IF LRET
				MSGINFO("Processo Finalizado com Erro! Cópia não gerada!","ATENÇÃO")
			ELSE
				MSGINFO("Processo Finalizado com Sucesso!","FINALIZADO")
			ENDIF
		ENDIF
		CURSORARROW()

	ELSE

		CURSORARROW()
		IF !LAUTO
			MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")
		ENDIF
		RECLOCK("SC5",.F.)
		SC5->C5_STCROSS = 'ERRCOP'
		MSUNLOCK()

	ENDIF

RETURN