#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³MT416FIM  ºAUTOR  ³CT      	     º DATA ³  19/10/2015       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ PONTO DE ENTRADA EXECUTADO NO FIM DA EFETIVACAO DO         º±±
±±º          ³ ORÇAMENTO                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
USER FUNCTION MT416FIM()
	LOCAL cEnvPedido		:= M->C5_NUM
	Local _cFilOld 		:= cFilAnt
	Local _nPosSM0			:= SM0->(Recno())
	Local cTxtC5MENSAGEM	:= ""
	Local cPedPortalTa	:= M->C5_NUMOLD
	Local CPATH			:= "\TEMP\"
	Local CNOMEARQERRO	:= "MT416FIM_erro_EXEC_MATA410.TXT"
	Local cC5transp 		:= ""
	Local cA1transp 		:= ""
	Local cC5trcnpj 		:= ""
	Local cA1trcnpj 		:= ""
	Local I					:= 0
	Local NREGS				:= 0


	PRIVATE LCONT		:= .T.
	PRIVATE ACABSC5		:= {}
	PRIVATE ADETSC6		:= {}
	PRIVATE ATMPSC6		:= {}
	PRIVATE LMSERROAUTO	:= .F.

	PRIVATE APEDIDO		:= {}
	PRIVATE NPOSPROD		:= 0
	PRIVATE NPOSITEM		:= 0

	//QUANDO FOR IMPORTACAO AUTOMATICA NAO USA AHEADER
	If IsInCallStack("U_CFGMI002")
		NPOSPROD		:= ASCAN(_AHEADER,{|X| ALLTRIM(X[2]) == "C6_PRODUTO"})
	EndIf
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	INICIO DO PROCESSO DE COPIA DE PEDIDOS DE VENDA REFERENTE AO CROSSDOCKING
		|
		|	EDSON HORNBERGER - 22/09/2015
		|=================================================================================
		|---------------------------------------------------------------------------------
		|	SOMENTE SERA REALIZADO COPIA PARA A EMPRESA TAIFFPROART MATRIZ
		|   OS PEDIDOS DA ASSISTENCIA TÉCNICA NÃO SERÃO COPIADOS 
		|---------------------------------------------------------------------------------
		*/
	IF CEMPANT + CFILANT = "0301" .AND. M->C5_CLASPED != "A"

		CQUERY := "SELECT COUNT(*) AS NCONT FROM " + RETSQLNAME("SC5") + " SC5 WHERE SC5.C5_FILIAL = '02' AND SC5.C5_NUMOLD = '" + M->C5_NUMOLD + "' AND SC5.D_E_L_E_T_ = ''"
		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBGOTOP()

		IF TMP->NCONT > 0

			MSGINFO("Pedido portal " + M->C5_NUMOLD + " já está cadastrado na Empresa Taiff Extrema!","Processo CrossDocking")
			LCONT := .F.

		ENDIF

		CQUERY := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_TIPO, SA1.A1_TABELA, SA1.A1_TRANSP FROM " + RETSQLNAME("SA1") + " SA1 WHERE SA1.A1_FILIAL = '02' AND SA1.A1_CGC = '" + SM0->M0_CGC + "' AND SA1.D_E_L_E_T_ = ''"
		IF SELECT("TMP") > 0

			DBSELECTAREA("TMP")
			DBCLOSEAREA()

		ENDIF
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		COUNT TO NREGS

		IF NREGS > 0 .AND. LCONT

			DBGOTOP()

			cTxtC5MENSAGEM := M->C5_MENNOTA
			If At( M->C5_NUMOLD , M->C5_MENNOTA) = 0
				cTxtC5MENSAGEM :=  "PEDIDO PORTAL: " + M->C5_NUMOLD + ENTER + M->C5_MENNOTA
			EndIf

				/*
				Tratamento especifico para quando há cliente atendido por transportadora 
				diferente do cadastro do cliente de CROSS DOCKING
				Ex.: ATIVA ou FRIBURGO
				*/
			cC5transp := M->C5_TRANSP
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
			AADD(ACABSC5,{"C5_TIPO"		,M->C5_TIPO		})
			AADD(ACABSC5,{"C5_CLIENTE"	,TMP->A1_COD		})
			AADD(ACABSC5,{"C5_TIPOCLI"	,TMP->A1_TIPO		})
			AADD(ACABSC5,{"C5_LOJACLI"	,TMP->A1_LOJA		})
			AADD(ACABSC5,{"C5_CLIENT"		,TMP->A1_COD      })
			AADD(ACABSC5,{"C5_LOJAENT"	,TMP->A1_LOJA		})
			AADD(ACABSC5,{"C5_EMISSAO"	,DDATABASE			})
			AADD(ACABSC5,{"C5_TPFRETE"	,"C"				})
			AADD(ACABSC5,{"C5_FINALID"	,"2"				})
			AADD(ACABSC5,{"C5_INTER"  	,"S"				})
			AADD(ACABSC5,{"C5_CLASPED"	,M->C5_CLASPED		})
			AADD(ACABSC5,{"C5_FILDES"		,M->C5_FILDES		})
			AADD(ACABSC5,{"C5_PCFRETE"	,M->C5_PCFRETE		})
			AADD(ACABSC5,{"C5_EMPDES"		,M->C5_EMPDES		})
			AADD(ACABSC5,{"C5_ESPECI1"	,"CAIXA"			})
			AADD(ACABSC5,{"C5_OBSERVA"	,M->C5_OBSERVA		})
			AADD(ACABSC5,{"C5_MENNOTA"	,cTxtC5MENSAGEM	})
			AADD(ACABSC5,{"C5_XLIBCR"		,M->C5_XLIBCR		})
			AADD(ACABSC5,{"C5_NUMOLD"		,M->C5_NUMOLD		})
			AADD(ACABSC5,{"C5_XITEMC"		,M->C5_XITEMC		})
			AADD(ACABSC5,{"C5_NUMORI"		,M->C5_NUM			})
			AADD(ACABSC5,{"C5_CLIORI"		,M->C5_CLIENTE		})
			AADD(ACABSC5,{"C5_LOJORI"		,M->C5_LOJACLI		})
			AADD(ACABSC5,{"C5_NOMORI"		,M->C5_NOMCLI		})
			AADD(ACABSC5,{"C5_FATFRAC"	,M->C5_FATFRAC		})
			AADD(ACABSC5,{"C5_FATPARC"	,M->C5_FATPARC		})
			AADD(ACABSC5,{"C5_DTPEDPR"	,M->C5_DTPEDPR		})
			AADD(ACABSC5,{"C5_NUMOC"		,"CROSS"			}) // Texto simples que dará apoio ao processo de Recebimento Cross Docking
			AADD(ACABSC5,{"C5_TABELA"		,TMP->A1_TABELA	})
			AADD(ACABSC5,{"C5_CONDPAG"	,M->C5_CONDPAG		})
			AADD(ACABSC5,{"C5_VEND1"		,M->C5_VEND1		})
			AADD(ACABSC5,{"C5_NOMCLI"		,M->C5_NOMCLI		})
			AADD(ACABSC5,{"C5_PCTFEIR"	,M->C5_PCTFEIR		})
			AADD(ACABSC5,{"C5_TPPCTFE"	,M->C5_TPPCTFE		})
			AADD(ACABSC5,{"C5_X_PVBON"	,SC5->C5_X_PVBON	})
			AADD(ACABSC5,{"C5_USRBNF"		,SC5->C5_USRBNF	})
			AADD(ACABSC5,{"C5_OBSBNF"		,SC5->C5_OBSBNF	})
			AADD(ACABSC5,{"C5_BNFLIB"		,SC5->C5_BNFLIB	})

			ACABSC5 := U_FCARRAYEXEC("SC5",ACABSC5,.F.)
			ADETSC6 := {}

			FOR I := 1 TO LEN(_ACOLS)

				FOR NREGS := 1 TO LEN(_AHEADER)
					If AT( ALLTRIM(_AHEADER[NREGS][2]) , 'C6_ITEM|C6_PRODUTO|C6_QTDVEN|C6_UM|C6_LOCAL|C6_DESCRI|C6_TES|C6_CLI|C6_LOJA|C6_XITEMC|C6_PRCVEN|C6_VALOR|C6_PRUNIT|C6_ENTREG|C6_PEDCLI' ) != 0
						AADD(ATMPSC6,{_AHEADER[NREGS][2],_ACOLS[I][NREGS],NIL})
					EndIf
				NEXT NREGS

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

			NEXT I

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
				CRIASB2( PadR(ADETSC6[I,NPOSPROD,2],15) , "21" , CFILANT )

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
					MOSTRAERRO(CPATH,CNOMEARQERRO)

				ENDIF


			END TRANSACTION
			/* Funcionalidade do projeto Financeiro sobre o limite de crédito */
			/* Data: 10/06/2020                               Responsável: Carlos Torres*/
			/* ID Controle: 001-M416F */
			IF .NOT. LMSERROAUTO
				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")
				If DBSEEK( xFilial("SC5") + ALLTRIM( cPedPortalTa ))
					U_FINMI003("I",SC5->C5_NUM)
				ENDIF
			ENDIF
			/* fim de controle 001-M416F */

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
				If SC5->(RecLock("SC5", .F.))
					SC5->C5_TRANSP := cA1transp
					SC5->(MsUnLock())
				EndIf
			EndIf

			SM0->(DbGoto(_nPosSM0))
			cFilAnt := _cFilOld

			SC5->(DbSetOrder(1))
			If SC5->(DbSeek( xFilial("SC5") + cEnvPedido ) )
				If SC5->(RecLock("SC5", .F.))
					IF LMSERROAUTO
						SC5->C5_STCROSS := 'ERRCOP'
					ELSE
						SC5->C5_STCROSS := 'ABERTO'
					ENDIF
					SC5->(MsUnLock())
				EndIf
			EndIf

		ELSE

			IF LCONT
				MSGINFO("Cliente Taiff Matriz não está cadastrada na Empresa Taiff Extrema!","Processo CrossDocking")

				SC5->(DbSetOrder(1))
				If SC5->(DbSeek( xFilial("SC5") + cEnvPedido ) )
					If SC5->(RecLock("SC5", .F.))
						SC5->C5_STCROSS := 'ERRCOP'
						SC5->(MsUnLock())
					EndIf
				EndIf

			ENDIF

		ENDIF

	ENDIF

RETURN
