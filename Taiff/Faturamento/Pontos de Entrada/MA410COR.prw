#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE PULA CHR(13) + CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � MA410COR � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � PONTO DE ENTRADA PARA INCLUS�O DE UM NOVO STATUS UTILIZANDO���
���          � UMA FUNCAO ESPECIFICA.                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION MA410COR()

	LOCAL _ACORES 	:= ACLONE(PARAMIXB)
	LOCAL ACORNEW 	:= {}
	//LOCAL CEMPSEP	:= GETNEWPAR("PRT_SEP005","99")
	//LOCAL CFILSEP	:= GETNEWPAR("PRT_SEP006","01")
	// PEGA A THREAD DA CHAMADA DA FUNCAO DO PEDIDO DE VENDAS - EDSON HORNBERGER - 07/11/2013
	LOCAL NTHREAD	:= THREADID()
	//LOCAL LUNIDNEG	:= (CEMPANT+CFILANT) $ (GETNEWPAR('MV_UNINEG', CEMPANT+CFILANT ,))
	//PARAMETRO PARA ATIVAR O PROCESSO DO PROJETO AVANTE - FASE II
	LOCAL LAVNFSII	:= SUPERGETMV("MV_ARMCEN",.F.,.T.)
	LOCAL NUNIDNEG	:= 0
	LOCAL CQUERY 	:= ""
	LOCAL CPERG		:= PADR("MA410COR",10)
	LOCAL APERG		:= {}
	Local cClassPed:="O" // Outras classes de pedido que n�o sejam Assistencia Tecnica

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	CRIA A PERGUNTA PARA QUE POSSA SER REALIZADO A VERIFICACAO DE UNIDADE DE
	| NEGOCIOS, ONDE SERA ALTERADO A LEGENDA.
	|=================================================================================
	*/

	IF LAVNFSII .AND. CEMPANT <> "01"

		AADD(APERG,{"Unid. Negocio? :"			,"N",01,00,"C","","TAIFF","PROART","CORP","","",""})
		AADD(APERG,{"Classe Pedido? :"			,"N",01,00,"C","","OUTROS","ASTEC","","","",""})

		U_GERAPERG(CPERG,APERG)

		WHILE NUNIDNEG <= 0

			IF PERGUNTE(CPERG,.T.)
				NUNIDNEG :=  MV_PAR01
				cClassPed :=  IIF(MV_PAR02=1,"O","A")

			ENDIF

		ENDDO

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	VERIFICA SE PODE SER ALTERADO A LEGENDA E STATUS E SE FAZ PARTE DAS EMPRESAS
	|	QUE REALIZAM SEPARACAO/CONFERENCIA
	|---------------------------------------------------------------------------------
	*/
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT06",.F.,"") .AND. (CEMPANT+CFILANT) $ SUPERGETMV("MV__SEPA01",.F.,"")

		/*
		PREENCHIMENTOS POSSIVEIS PARA CAMPOS DO PEDIDO DE VENDA
		
		--> C5_YSTSEP =
		S - ETIQUETAS IMPRESSAS / EM SEPARACAO
		C - EM CONFERENCIA
		G - CONFERENCIA FINALIZADA
		E - ERRO NO CALCULO DE EMBALAGENS
		N - SEPARACAO NAO INICIADA
		
		--> C5_XLIBCR =
		L - CREDITO LIBERADO
		P - CREDITO PENDENTE
		B - CREDITO BLOQUEADO
		M - MANUAL
		A - ALTERADO
		*/

		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	CONFORME A RESPOSTA DO USUARIO REFERENTE A UNIDADE DE NEGOCIO MONTA AS CORES
		| DAS LEGENDAS DIFERENCIADAS.
		|	EDSON HORNBERGER - 07/11/2013
		|=================================================================================
		|---------------------------------------------------------------------------------
		|	REALIZADO MANUTENCAO NAS CORES DAS LEGENDA PARA QUE SEJA VERIFICADO O STATUS
		| VERMELHO PARA OS PEDIDOS DE VENDA ONDE FOI REALIZADO O PROCESSO DE ELIMINAR
		| RESIDUO. (VERIFICADO O CAMPO C5_NOTA = 'XXXXXXXXX')
		|	EDSON HORNBERGER - 22/07/2014
		|---------------------------------------------------------------------------------
		*/
		/*
		|---------------------------------------------------------------------------------
		|	VALIDACOES DE STATUS PARA A MARCA PROART
		|---------------------------------------------------------------------------------
		*/
		IF NUNIDNEG = 0 // NUNIDNEG = 2 .OR. NUNIDNEG = 0

			ACORNEW := {	{"C5_XLIBCR='P' .AND. C5_NOTA != 'XXXXXXXXX'"																																												,"V_CRED_AZUL"		},;//PEDIDO PENDENTE CRED.
			{"C5_XLIBCR='M' .AND. C5_NOTA != 'XXXXXXXXX'"																																												,"V_CRED_LARANJA"	},;//PENDENTE AVALIA��O MANUAL CRED.
			{"C5_XLIBCR='A' .AND. C5_NOTA != 'XXXXXXXXX'"																																												,"V_CRED_ROSA"		},;//PENDENTE AVALIA��O CR�DITO POR ALTERA��O DE PRECO OU CONDICAO
			{"C5_XLIBCR='B' .AND. C5_NOTA != 'XXXXXXXXX'"																																												,"V_CRED_VERMELHO"	},;//PEDIDO BLOQUEADO CRED.
			{"C5_XLIBCR='C' .AND. C5_NOTA != 'XXXXXXXXX'"																																												,"V_CRED_AMARELO"	},;//PENDENTE AVAL. CRED. COMPLEMENTAR
			{"C5_XLIBCR='L'  .AND. EMPTY(C5_BLQ) .AND. EMPTY(C5_YSTSEP) .AND. EMPTY(C5_LIBEROK)   .AND. EMPTY(C5_NOTA)  .AND. !U_LIBPARCC9()   .AND. !U_ENCERR() .AND. C5_YFMES <> 'S' .AND. C5_NOTA != 'XXXXXXXXX'"					,'ENABLE' 		},;//PEDIDO EM ABERTO
			{"(C5_XLIBCR='L' .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $  'G' .AND.	C5_YFMES <> 'S' .AND. !EMPTY(C5_NOTA)) .OR. C5_LIBEROK=='E' .OR. (U_ENCERR().AND.C5_YSTSEP='G') .OR. C5_NOTA = 'XXXXXXXXX'"		,'DISABLE'		},;//PED ENCERRADO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'G'  .AND.	!U_ENCERR()		.AND. U_FAT()          .AND. !U_FATPENDL() .AND.  C5_YFMES <> 'S' .AND. C5_NOTA != 'XXXXXXXXX'"					,"BR_LARANJA"	},;//PED PARC FATURADO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ ' N' .AND. !U_LIBPARCC9()	.AND. C5_YFMES <> 'S'  .AND.	!U_ENCERR() .AND. C5_NOTA != 'XXXXXXXXX'"										,'BR_AMARELO'	},;//PED TOT  LIBERADO AG.SEPARACAO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ ' N' .AND. U_LIBPARCC9()	.AND. C5_YFMES <> 'S'  .AND.	!U_ENCERR() .AND. C5_NOTA != 'XXXXXXXXX'"										,"BR_CINZA"		},;//PED PARC LIBERADO AG.SEPARACAO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'S'  .AND.	C5_YFMES <> 'S' .AND. C5_NOTA != 'XXXXXXXXX'"																					,'BR_AZUL'		},;//PED EM SEPARACAO - ETIQUETAS IMPRESSAS
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'C'  .AND. C5_YFMES <> 'S' .AND. C5_NOTA != 'XXXXXXXXX'"																					,'BR_PINK'		},;//PED EM CONFERENCIA
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'G'  .AND.	U_FATPENDL()	.AND. C5_YFMES <> 'S'  .OR. (C5_INTER = 'S' .AND. !EMPTY(C5_NUMOC)) .AND. C5_NOTA != 'XXXXXXXXX'"				,'BR_BRANCO'	},;//PED CONFERIDO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'S'  .AND.	C5_YFMES = 'S' .AND. C5_NOTA != 'XXXXXXXXX'"																					,'V_FAT_AZUL'	},;//PED EM SEPARACAO - ETIQUETAS IMPRESSAS
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ 'C'  .AND. C5_YFMES = 'S' .AND. C5_NOTA != 'XXXXXXXXX'"																					,'V_FAT_PINK'	},;//PED EM CONFERENCIA
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. !(C5_YSTSEP $  'E') .AND. C5_YSTSEP $ ' N' .AND.	C5_YFMES = 'S'  .AND. U_VERLOC21() .AND. C5_NOTA != 'XXXXXXXXX'"																,'V_FAT_MARROM'	},;//PED FATURADO MAS NAO SEPARADO
			{"C5_XLIBCR='L'	 .AND. EMPTY(C5_BLQ) .AND. C5_YSTSEP $  'E' .AND. C5_NOTA != 'XXXXXXXXX'"																																	,'BR_PRETO'		} }//ERRO NO CALCULO DE EMBALAGENS

		/*
		|---------------------------------------------------------------------------------
		|	VALIDACOES DE STATUS PARA A MARCA TAIFF
		|---------------------------------------------------------------------------------
		*/
		ELSEIF NUNIDNEG = 1 .OR. NUNIDNEG = 2

			ACORNEW :=	{	{"C5_XLIBCR='P'"																																	,"V_CRED_AZUL"			},;//PEDIDO PENDENTE CRED.
			{"C5_XLIBCR='M'"																																	,"V_CRED_LARANJA"		},;//PENDENTE AVALIA��O MANUAL CRED.
			{"C5_XLIBCR='A'"																																	,"V_CRED_ROSA"			},;//PENDENTE AVALIA��O CR�DITO POR ALTERA��O DE PRECO OU CONDICAO
			{"C5_XLIBCR$'B'"																																	,"V_CRED_VERMELHO"		},;//PEDIDO BLOQUEADO CRED.
			{"C5_XLIBCR='C'"																																	,"V_CRED_AMARELO"		},;//PENDENTE AVAL. CRED. COMPLEMENTAR
			{"U_VERIFENT() .AND. C5_XLIBCR='L' .AND. C5_LIBCOM<>'2'"																					,"BR_MARROM"			},;//PEDIDO PARCIALMENTE ATENDIDO
			{"U_VERIFENT() .AND. C5_XLIBCR='B'"																											,"V_CRED_VERMELHO"		},;//PEDIDO PARCIALMENTE ATENDIDO (MAS BLOQUEADO NO CR�DITO)
			{"C5_LIBCOM == '2'"																																,'BR_PINK'				},;//BLOQUEIO COMERCIAL
			{"C5_XLIBCR='L' .AND. EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ).AND. U_LIBPARC() "																,'BR_BRANCO'			},;//PEDIDO LIBERADO PARCIALMENTE AGUARDANDO SEPARACAO / CONFERENCIA
			{"C5_XLIBCR='L' .AND. EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ)"															,'ENABLE' 				},;//PEDIDO EM ABERTO
			{"!EMPTY(C5_NOTA).OR.C5_LIBEROK=='E' .AND. EMPTY(C5_BLQ)" 																					,'DISABLE'				},;//PEDIDO ENCERRADO
			{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA).AND. EMPTY(C5_BLQ).AND. !(U_LIBPARC()) .AND. C5_XLIBCR<>'C' .AND. !(U_EXISTOS('SC9'))"	,'BR_AMARELO'			},;//PEDIDO LIBERADO AGUARDANDO SEPARACAO / CONFERENCIA
			{"C5_XLIBCR='L' .AND. EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ).AND. U_LIBPARC() "																,'BR_BRANCO'			},;//PEDIDO LIBERADO PARCIALMENTE AGUARDANDO SEPARACAO / CONFERENCIA
			{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA).AND. EMPTY(C5_BLQ).AND. C5_XLIBCR<>'C' .AND. (U_EXISTOS('SC9'))"		,'BR_VIOLETA'			},;//PEDIDO LIBERADO EM SEP/CONF
			{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.(!EMPTY(C5_NOTA).AND.C5_NOTA!='XXXXXXXXX'.AND.!(U_EXISTOS('SD2')))"					,"V_FAT_AMARELO"		},;//PEDIDO FATURADO AGUARDANDO SEPARACAO / CONFERENCIA
			{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.(!EMPTY(C5_NOTA).AND.C5_NOTA!='XXXXXXXXX'.AND.(U_EXISTOS('SD2')))"						,"V_FAT_VIOLETA"		},;//PEDIDO FATURADO EM SEP/CONF
			{"C5_XLIBCR='L' .AND. C5_BLQ == '1'"																											,'BR_AZUL'				},;//PEDIDO BLOQUEDO POR REGRA
			{"C5_XLIBCR='L' .AND. C5_BLQ == '2'"																											,'BR_LARANJA'			} }//PEDIDO BLOQUEDO POR VERBA

		/*
		|---------------------------------------------------------------------------------
		|	VALIDACOES DE STATUS PARA A PRODUTOS CORPORATIVOS
		|---------------------------------------------------------------------------------
		*/			
		ELSEIF NUNIDNEG = 3

			ACORNEW :=	{	{"C5_XLIBCR='P'"																																,"V_CRED_AZUL"			},;//PEDIDO PENDENTE CRED.
			{"C5_XLIBCR='M'"																																,"V_CRED_LARANJA"		},;//PENDENTE AVALIA��O MANUAL CRED.
			{"C5_XLIBCR='A'"																																,"V_CRED_ROSA"			},;//PENDENTE AVALIA��O CR�DITO POR ALTERA��O DE PRECO OU CONDICAO
			{"C5_XLIBCR$'B'"																																,"V_CRED_VERMELHO"		},;//PEDIDO BLOQUEADO CRED.
			{"C5_XLIBCR='C'"																																,"V_CRED_AMARELO"		},;//PENDENTE AVAL. CRED. COMPLEMENTAR
			{"U_VERIFENT() .AND. C5_XLIBCR='L' .AND. C5_LIBCOM<>'2'"																						,"BR_MARROM"			},;//PEDIDO PARCIALMENTE ATENDIDO
			{"U_VERIFENT() .AND. C5_XLIBCR='B'"																												,"V_CRED_VERMELHO"		},;//PEDIDO PARCIALMENTE ATENDIDO (MAS BLOQUEADO NO CR�DITO)
			{"C5_LIBCOM == '2'"																																,'BR_PINK'				},;//BLOQUEIO COMERCIAL
			{"C5_XLIBCR='L' .AND. EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ)"																	,'ENABLE' 				},;//PEDIDO EM ABERTO
			{"!EMPTY(C5_NOTA).OR.C5_LIBEROK=='E' .AND. EMPTY(C5_BLQ)" 																						,'DISABLE'				},;//PEDIDO ENCERRADO
			{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA).AND. EMPTY(C5_BLQ).AND. !(U_LIBPARC()) .AND. C5_XLIBCR<>'C'"						,'BR_AMARELO'			},;
				{"C5_XLIBCR='L' .AND. !EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA).AND. EMPTY(C5_BLQ).AND. !(U_LIBPARC()) .AND. C5_XLIBCR<>'C'"						,'BR_BRANCO'			},;
				{"C5_XLIBCR='L' .AND. C5_BLQ == '1'"																											,'BR_AZUL'				},;//PEDIDO BLOQUEDO POR REGRA
			{"C5_XLIBCR='L' .AND. C5_BLQ == '2'"																											,'BR_LARANJA'			} }//PEDIDO BLOQUEDO POR VERBA

		ENDIF
	ELSEIF (CEMPANT + CFILANT) = "0301" .AND. cClassPed = "A"

		ACORNEW := PARAMIXB
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"U_VERIFENT()"			,"BR_MARROM"		}
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := { "C5_LIBCOM == '2'"		,'BR_PINK'			}//BLOQUEIO COMERCIAL
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='P'"			,"V_CRED_AZUL"		}//PEDIDO PENDENTE CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='M'"			,"V_CRED_LARANJA"	}//PENDENTE AVALIA��O MANUAL CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='A'"			,"V_CRED_ROSA"		}//PENDENTE AVALIA��O CR�DITO POR ALTERA��O DE PRECO OU CONDICAO
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR$'B'"			,"V_CRED_VERMELHO"	}//PEDIDO BLOQUEADO CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='C'"			,"V_CRED_AMARELO"	}//PENDENTE AVAL. CRED. COMPLEMENTAR

	ELSEIF (CEMPANT + CFILANT) = "0301"

		aCorNew := {	{"C5_XLIBCR='P'"																						,'V_CRED_AZUL'		},;//Pedido Pendente Cred.
		{"C5_XLIBCR='M'"																						,'V_CRED_LARANJA'		},;//Pedido Pendente Cred.
		{"C5_XLIBCR='A'"																						,'V_CRED_ROSA'		},;//Pedido Pendente Cred.
		{"C5_XLIBCR$'B'"																						,'V_CRED_VERMELHO'	},;//Pedido Bloqueado Cred.
		{"C5_XLIBCR='C'"																						,'V_CRED_AMARELO' 	},;//Pendente de Aval. Cred. Complr.
		{"C5_LIBCOM == '2'"																					,'BLQMONEY'			},;//Pedido com Bloqueio Comercial
		{"C5_STCROSS = 'ABERTO'"																				,'ENABLE'		  		},;//Pedido em Aberto
		{"C5_STCROSS = 'FINALI'"																				,'DISABLE'				},;//Pedido Atendido Totalmente
		{"C5_STCROSS = 'ATPARC'"																				,'BR_LARANJA'			},;//Pedido Atendido Parcialmente
		{"C5_STCROSS = 'LIBTOT'"																				,'BR_AMARELO'			},;//Pedido Totalmente Liberado
		{"C5_STCROSS = 'LIBPAR'"																				,'BR_MARROM' 			},;//Pedido Parcialmente Liberado
		{"C5_STCROSS = 'PROSEP'"																				,'PACKING'				},;//Pedido em Separa��o/Conf.
		{"C5_STCROSS = 'AGTRAN'"																				,'TRANSFER'			},;//Pedido aguuardando Transf.
		{"C5_STCROSS = 'EMTRAN'"																				,'TRUCKER'				},;//Pedido em Tr�nsito
		{"C5_STCROSS = 'AGFATU'"																				,'BILL'				},;//Pedido aguardando Faturamento
		{"C5_STCROSS = 'FINRES'"																				,'TRASH'				},;//Pedido Finalizado El.Residuo
		{"C5_STCROSS = 'AGCOPY'"																				,'ALERT'				},;//Pedido aguardando copia
		{"C5_STCROSS = 'ERRCOP'"																				,'ALERT'				}}//Erro na C�pia do Pedido para CD

		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"EMPTY(C5_STCROSS) .AND. C5_XLIBCR='L' .AND. EMPTY(C5_LIBEROK).AND.EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ)"	,'ENABLE' 				}//PEDIDO EM ABERTO

		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"EMPTY(C5_STCROSS) .AND. !EMPTY(C5_NOTA).OR.C5_LIBEROK=='E' .AND. EMPTY(C5_BLQ)"							,'DISABLE'				}//PEDIDO ENCERRADO

		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"EMPTY(C5_STCROSS) .AND. C5_XLIBCR='L' .AND. C5_LIBEROK='S' .AND.EMPTY(C5_NOTA) .AND. EMPTY(C5_BLQ)"		,'BR_AMARELO' 				}//Regra padr�o PROTHEUS
		/*
			Amarelo - Liberado: J� foi submetido � libera��o do Pedido (j� gerou registro na SC9), mas n�o foi encerrado (est� pendente de faturamento) - campo C5_LIBEROK com conte�do S e campo C5_NOTA em branco
		*/

	ELSEIF CEMPANT = '01'

		ACORNEW := PARAMIXB
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"U_VERIFENT()"			,"BR_MARROM"		}
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := { "C5_LIBCOM == '2'"		,'BR_PINK'			}//BLOQUEIO COMERCIAL
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='P'"			,"V_CRED_AZUL"		}//PEDIDO PENDENTE CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='M'"			,"V_CRED_LARANJA"	}//PENDENTE AVALIA��O MANUAL CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='A'"			,"V_CRED_ROSA"		}//PENDENTE AVALIA��O CR�DITO POR ALTERA��O DE PRECO OU CONDICAO
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR$'B'"			,"V_CRED_VERMELHO"	}//PEDIDO BLOQUEADO CRED.
		AADD(ACORNEW,{})
		AINS(ACORNEW,1)
		ACORNEW[1] := {"C5_XLIBCR='C'"			,"V_CRED_AMARELO"	}//PENDENTE AVAL. CRED. COMPLEMENTAR

	ENDIF

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	SE O CONTROLE DE UNIDADE DE NEGOCIOS ESTIVER ATIVA, GRAVA AS INFORMACOES SOBRE
	| QUAL A UNIDADE DE NEGOCIOS ESCOLHIDA PELO USUARIO PARA PODER UTILIZAR AS INFOR-
	| COES NO PONTO DE ENTRADA M410FSQL PARA REALIZAR FILTRO NA TELA DE PEDIDO DE
	| VENDA.
	|	EDSON HORNBERGER - 07/11/2013
	|=================================================================================
	*/	
	IF NUNIDNEG > 0

		CQUERY := "INSERT INTO CONTROLE_LEGENDA" 						+ PULA
		CQUERY += "VALUES" 												+ PULA
		CQUERY += "(" 														+ PULA
		CQUERY += "'" + CEMPANT + "'," 									+ PULA
		CQUERY += "'" + CFILANT + "'," 									+ PULA
		CQUERY += "'" + __CUSERID + "'," 								+ PULA
		CQUERY += CVALTOCHAR(NTHREAD) + ","								+ PULA
		CQUERY += "'" + IIF(NUNIDNEG = 1,"TAIFF",IIF(NUNIDNEG = 2,"PROART","CORP")) + "',"	+ PULA
		CQUERY += "'" + cClassPed + "')"

		IF TCSQLEXEC(CQUERY) < 0

			MSGSTOP(OEMTOANSI("ERRO AO TENTAR CONTROLAR UNIDADE DE NEG�CIO!") + PULA + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("UNIDADE DE NEG�CIO"))
			//MEMOWRITE("MA410COR_INSERT_CONTROLE_LEGENDA.SQL",CQUERY)

		ENDIF

	ENDIF

RETURN (IIF(LEN(ACORNEW) = 0,_ACORES,ACORNEW))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � VERIFENT � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE ATENDIDO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION VERLOC21()

	LOCAL AGETAREA := GETAREA()

	SC6->(DBSETORDER(1))
	SC6->(DBSEEK(XFILIAL("SC6")+SC5->C5_NUM))

	IF SC6->C6_LOCAL == "21"
		LLOC21 := .T.
	ELSE
		LLOC21 := .F.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LLOC21

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � VERIFENT � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE ATENDIDO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION VERIFENT()

	AGETAREA := GETAREA()

	IF !EMPTY(C5_NOTA).OR.C5_LIBEROK=='E' .AND. EMPTY(C5_BLQ)
		RETURN .F.
	ENDIF

	LPARC := .F.
	SC6->(DBSETORDER(1))
	SC6->(DBSEEK(XFILIAL("SC6")+SC5->C5_NUM))
	DO WHILE SC6->(C6_FILIAL+C6_NUM) = SC5->(C5_FILIAL+C5_NUM) .AND. ! SC6->(EOF())
		IF SC6->C6_QTDENT > 0
			LPARC := .T.
			EXIT
		ENDIF
		SC6->(DBSKIP())
	ENDDO

	RESTAREA(AGETAREA)

RETURN LPARC

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  �VERLIBPARC� AUTOR � RICARDO BALDONI       � DATA �27/01/2012���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE LIBERADO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION LIBPARC()

	AGETAREA := GETAREA()
	LLIBPARC := .F.
	NTOTITENS:=0
	NTOTLIBITENS:=0
	NTOTFAT:=0

	SC6->(DBSETORDER(1))
	SC6->(DBSEEK(XFILIAL("SC6")+SC5->C5_NUM))
	DO WHILE SC6->(C6_FILIAL+C6_NUM) = SC5->(C5_FILIAL+C5_NUM) .AND. ! SC6->(EOF())

		//ALTERADO POR EDSON HORNBERGER - 25/04/2013
		//DEVERA SER VERIFICADO A SOMA DAS QUANTIDADES DOS ITENS E NAO OS ITENS DO PEDIDO
		//NTOTITENS++ //TOTAL ITENS PEDIDO
		NTOTITENS += SC6->C6_QTDVEN

		IF ALLTRIM(SC5->C5_XITEMC) = "PROART"
			IF !EMPTY(SC6->C6_NOTA) .AND. !EMPTY(SC6->C6_SERIE)   //JA EXISTE ITENS FATURADOS
				RETURN .F.
			ELSE
				IF SC6->C6_QTDEMP >0
					IF  EMPTY(SC5->C5_YSTSEP)
						LLIBPARC := .T.
					ENDIF
					//ALTERADO POR EDSON HORNBERGER - 25/04/2013
					//DEVERA SER VERIFICADO A SOMA DAS QUANTIDADES DOS ITENS E NAO OS ITENS DO PEDIDO
					//NTOTLIBITENS++
					NTOTLIBITENS += SC6->C6_QTDEMP
				ENDIF
			ENDIF
		ELSE

			DBSELECTAREA("SC9")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("SC9") + SC6->C6_NUM + SC6->C6_ITEM + "01" + SC6->C6_PRODUTO)
				If SC9->C9_BLEST != "02"
					NTOTLIBITENS += SC9->C9_QTDLIB
				EndIf

			ENDIF

		ENDIF
		SC6->(DBSKIP())
	ENDDO

	//LIBERACAO TOTAL
	IF NTOTITENS  = NTOTLIBITENS
		LLIBPARC := .F.
	ELSEIF NTOTLIBITENS != 0
		LLIBPARC := .T.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LLIBPARC


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  �VERLIBC9� AUTOR � RICARDO BALDONI       � DATA �27/01/2012���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE LIBERADO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION LIBPARCC9()

	AGETAREA := GETAREA()

	LLIBPARC9 := .F.

	CQUERYIK := " SELECT SUM(C9_QTDLIB) AS QTDC9IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC9")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C9_FILIAL = '"+XFILIAL("SC9")+"' AND C9_NFISCAL = '' AND C9_BLEST<>'02'"
	CQUERYIK += " AND C9_PEDIDO='"+SC5->C5_NUM+"'"

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC9IK:= QRYIK->QTDC9IK
	DBCLOSEAREA()

	CQUERYIK1 := " SELECT SUM(C6_QTDVEN) AS QTDC6IK "
	CQUERYIK1 += " FROM "+RETSQLNAME("SC6")
	CQUERYIK1 += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK1 += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' "
	CQUERYIK1 += " AND C6_NUM='"+SC5->C5_NUM+"'"

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK1),"QRYIK1", .F., .T.)

	WQTDC6IK:= QRYIK1->QTDC6IK
	DBCLOSEAREA()

	// LIBERACAO PARCIAL: QUANTIDADE ATUAL LIBERADA NO SC9 (NFISCAL EM BRANCO)
	// DIFERENTE DA QUANTIDADE TOTAL DO PEDIDO.
	IF WQTDC9IK <> WQTDC6IK .AND. WQTDC9IK > 0
		LLIBPARC9 := .T.
	ELSE
		LLIBPARC9 := .F.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LLIBPARC9

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  �VERLIBT� AUTOR � VETI			        � DATA �27/01/2012�  ��
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA TOTALMENTE ATENDIDO    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

USER FUNCTION ENCERR()
	AGETAREA := GETAREA()
	LENCERR := .F.

	//QUANTIDADE VENDIDA
	CQUERYIK := " SELECT SUM(C6_QTDVEN) AS QTDC6V "
	CQUERYIK += " FROM "+RETSQLNAME("SC6")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' "
	CQUERYIK += " AND C6_NUM='"+SC5->C5_NUM+"' "

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC6V:= QRYIK->QTDC6V
	DBCLOSEAREA()

	//QUANTIDADE ENTREGUE
	CQUERYIKE := " SELECT SUM(C6_QTDENT) AS QTDC6E "
	CQUERYIKE += " FROM "+RETSQLNAME("SC6")
	CQUERYIKE += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIKE += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' "
	CQUERYIKE += " AND C6_NUM='"+SC5->C5_NUM+"' "

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIKE),"QRYIKE", .F., .T.)

	WQTDC6E:= QRYIKE->QTDC6E
	DBCLOSEAREA()

	//RESIDUO
	CQUERYIKR := " SELECT ISNULL(SUM(C6_QTDVEN) - SUM(C6_QTDENT),0) AS QTDC6R "
	CQUERYIKR += " FROM "+RETSQLNAME("SC6")
	CQUERYIKR += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIKR += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' "
	CQUERYIKR += " AND C6_NUM='"+SC5->C5_NUM+"' "
	CQUERYIKR += " AND C6_BLQ = 'R' "

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIKR),"QRYIKR", .F., .T.)

	WQTDC6R:= QRYIKR->QTDC6R
	DBCLOSEAREA()

	// PEDIDO ENCERRADO: QUANTIDADE VENDIDA - QUANTIDADE ENTREGUE - QUANTIDADE PENDENTE
	IF WQTDC6V - WQTDC6E - WQTDC6R = 0
		LENCERR := .T.
	ELSE
		LENCERR := .F.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LENCERR

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � VERIFENT � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA TOTALMENTE ATENDIDO   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION VERFINAL()

	AGETAREA := GETAREA()

	LVERFIM := 0

	CQUERYIK := " SELECT COUNT(*) AS QTDC6IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC6")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' AND C6_QTDENT <> C6_QTDVEN"
	CQUERYIK += " AND C6_NUM='"+SC5->C5_NUM+"'"


	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC6IK:= QRYIK->QTDC6IK
	DBCLOSEAREA()

	LVERZZF := .F.

	CQUERYIK := " SELECT COUNT(*) AS QTDZZF"
	CQUERYIK += " FROM "+RETSQLNAME("ZZF")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND ZZF_FILIAL = '"+XFILIAL("ZZF")+"' AND ZZF_YDICNF<>'' "
	CQUERYIK += " AND ZZF_PEDIDO='"+SC5->C5_NUM+"'"


	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDZZF:= QRYIK->QTDZZF
	DBCLOSEAREA()


	IF WQTDC6IK == 0  .AND. WQTDZZF <> 0 //NAO TEM PEDIDO A FATURAR  NAO TEM ZZG SEM CONFERIR OU NAO TEM ZZG  - VERMELHO
		LVERFIM := 0
	ELSEIF WQTDC6IK == 0 .AND. WQTDZZF == 0  // NAO TEM PEDIDO A FATURAR E TEM ZZG A CONFERIR - VIOLETA
		LVERFIM := 1
	ELSEIF WQTDC6IK <> 0 .AND. WQTDZZF <> 0 // TEM PEDIDO A FATURAR E NAO TEM ZZG A CONFERIR - LARANJA
		LVERFIM := 2
	ELSE
		LVERFIM := 3  	    //TEM PEDIDO A FATURAR E TEM ZZG A CONFERIR - CINZA
	ENDIF

	RESTAREA(AGETAREA)

RETURN LVERFIM



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � VERIFENT � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE ATENDIDO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION VERSC6()

	AGETAREA := GETAREA()

	LVERSC6 := .F.

	CQUERYIK := " SELECT COUNT(*) AS QTDC6IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC6")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' AND C6_QTDLIB <> C6_QTDVEN"
	CQUERYIK += " AND C6_NUM='"+SC5->C5_NUM+"'"


	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC6IK:= QRYIK->QTDC6IK
	DBCLOSEAREA()


	IF WQTDC6IK == 0  //NAO TEM PEDIDO A FATURAR
		LVERSC6 := .T.
	ELSE
		LVERSC6 := .F.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LVERSC6


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � VERIFENT � AUTOR � RICHARD NAHAS CABRAL  � DATA �25/02/2010���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA SE O PEDIDO ESTA PARCIALMENTE FATURADO ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION VERSC6FAT()

	AGETAREA := GETAREA()

	LVERSC6FAT := .F.

	CQUERYIK := " SELECT COUNT(*) AS QTDC6IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC6")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' AND C6_NOTA<>''"
	CQUERYIK += " AND C6_NUM='"+SC5->C5_NUM+"'"


	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC6IK:= QRYIK->QTDC6IK
	DBCLOSEAREA()


	IF WQTDC6IK == 0  //NAO TEM PEDIDO A FATURAR
		LVERSC6FAT := .T.
	ELSE
		LVERSC6FAT := .F.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LVERSC6FAT

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � FAT	 � AUTOR � VETI					   � DATA �01/04/2013���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA FATURAMENTOS PARA O PEDIDO              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION FAT()

	AGETAREA := GETAREA()

	LFAT := .F.

	CQUERYIK := " SELECT COUNT(*) AS QTDC6IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC6")
	CQUERYIK += " WHERE D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C6_FILIAL = '"+XFILIAL("SC6")+"' AND C6_NOTA <> ''"
	CQUERYIK += " AND C6_NUM='"+SC5->C5_NUM+"'"

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC6FP:= QRYIK->QTDC6IK
	DBCLOSEAREA()

	IF WQTDC6FP > 0  // J� HOUVE FATURAMENTO PARA ESTE PEDIDO (TOTAL OU PARCIAL)
		LFAT := .T.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LFAT

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � FATL	 � AUTOR � VETI					   � DATA �01/04/2013���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � VERIFICA PENDENCIA DE FATUR. DA LIBERA��O ATUAL DO PEDIDO   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION FATPENDL()

	AGETAREA := GETAREA()

	LPEND		:= .F.

	/*
	|---------------------------------------------------------------------------------
	|	INSERIDO NA QUERY VERIFICACAO DA SEQUENCIA DA LIBERACAO.
	|
	|	EDSON HORNBERGER - 25/09/14
	|---------------------------------------------------------------------------------
	*/

	CQUERYIK := " SELECT COUNT(*) AS QTDC9IK "
	CQUERYIK += " FROM "+RETSQLNAME("SC9") + " SC9 "
	CQUERYIK += " WHERE SC9.D_E_L_E_T_ <> '*' "
	CQUERYIK += " AND C9_FILIAL = '"+XFILIAL("SC9")+"' AND C9_NFISCAL = ''"
	CQUERYIK += " AND C9_PEDIDO = '"+SC5->C5_NUM+"'"
	CQUERYIK += " AND C9_SEQUEN = (SELECT MAX(C9_SEQUEN) FROM " + RETSQLNAME("SC9") + " TMP WHERE TMP.C9_FILIAL = '" + xFILIAL("SC9") + "' AND TMP.C9_PEDIDO = SC9.C9_PEDIDO AND TMP.C9_ITEM = SC9.C9_ITEM AND TMP.C9_PRODUTO = SC9.C9_PRODUTO AND TMP.D_E_L_E_T_ = '') "
	CQUERYIK += " AND C9_BLEST <> '02' "
	CQUERYIK += " AND C9_ORDSEP <> '' "

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDC9FP:= QRYIK->QTDC9IK
	DBCLOSEAREA()

	IF WQTDC9FP > 0  // H� ITENS PENDENTES DE FATURAMENTO NA LIBERA��O ATUAL
		LPEND := .T.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LPEND

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  � FMES	 � AUTOR � VETI					   � DATA �01/04/2013���
�������������������������������������������������������������������������Ĵ��
���DESCRI��O � FUNCAO QUE VERIFICA FATURAMENTOS DE FINAL DE MES            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/

USER FUNCTION FMES()

	AGETAREA := GETAREA()

	LFMES := .F.

	/*
	CQUERYIK := " SELECT COUNT(*) AS CALCNAOSEP FROM "+RETSQLNAME("SC9")+","+RETSQLNAME("ZZG")+" "
	CQUERYIK += " WHERE C9_PEDIDO = '"+SC5->C5_NUM+"'"
	CQUERYIK += " AND C9_NFISCAL <> '' "
	CQUERYIK += " AND SC9030.R_E_C_N_O_ = ZZG_SC9 "
	CQUERYIK += " AND ZZG_YDISEP = '' "
	CQUERYIK += " AND SC9030.D_E_L_E_T_ = '' "
	CQUERYIK += " AND ZZG030.D_E_L_E_T_ = '' "
	*/

	CQUERYIK := " SELECT COUNT(*) AS CALCNAOSEP FROM "+RETSQLNAME("SC9")+","+RETSQLNAME("ZZG")+" "
	CQUERYIK += " WHERE ZZG_PEDIDO = '"+SC5->C5_NUM+"'"
	CQUERYIK += " AND ZZG_SC9 = SC9030.R_E_C_N_O_ "
	CQUERYIK += " AND ZZG_YDISEP = '' "
	CQUERYIK += " AND C9_NFISCAL <> '' "
	CQUERYIK += " AND SC9030.D_E_L_E_T_ = '' "
	CQUERYIK += " AND ZZG030.D_E_L_E_T_ = '' "

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	CALCNS := QRYIK->CALCNAOSEP
	DBCLOSEAREA()

	IF CALCNS > 0  // HOUVE FATURAMENTO E N�O INICIOU A SEPARA��O
		LFMES := .T.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LFMES

/*
=================================================================================
=================================================================================
||   ARQUIVO:
=================================================================================
||   FUNCAO:
=================================================================================
||   DESCRICAO
||-------------------------------------------------------------------------------
||
||
||
||
||
=================================================================================
=================================================================================
||   AUTOR:
||   DATA:
=================================================================================
=================================================================================
*/

//VERZZG - FUNCAO QUE VERIFICA SE O PEDIDO J� TEVE A SEPARACAO INICIADA, E A NOTA N�O EST� EMITIDA.
// FUN��O ALTERADA EM 13/MAIO - ARLETE: VERIFICA SE N�O EST� COM STATUS "G"
USER FUNCTION VERZZG()

	AGETAREA := GETAREA()

	LVERZZG := .F.

	CQUERYIK := " SELECT COUNT(*) AS QTDZZG "+CRLF
	CQUERYIK += " FROM "+RETSQLNAME("ZZG")+","+RETSQLNAME("SC9")+","+RETSQLNAME("SC5")+" "+CRLF
	CQUERYIK += " WHERE ZZG_PEDIDO = C9_PEDIDO "+CRLF
	CQUERYIK += " AND ZZG_SC9 = "+RETSQLNAME("SC9")+".R_E_C_N_O_ "+CRLF
	CQUERYIK += " AND ZZG_PRODUT = C9_PRODUTO "+CRLF
	CQUERYIK += " AND ZZG_FILIAL = '"+XFILIAL("ZZG")+"' AND ZZG_YDISEP<>'' "+CRLF //SOMENTE O QUE TEM DATA DE INICIO DE SEPARACAO
	CQUERYIK += " AND "+RETSQLNAME("ZZG")+".D_E_L_E_T_ <> '*' "+CRLF
	CQUERYIK += " AND C9_PEDIDO = '" + SC5->C5_NUM + "' "+CRLF
	IF SC5->C5_YFMES <> 'S'
		CQUERYIK += " AND C9_NFISCAL = '' "+CRLF
	ELSE
		CQUERYIK += " AND C9_NFISCAL = (SELECT TOP 1 C9SUB.C9_NFISCAL FROM "+RETSQLNAME("SC9")+" AS C9SUB WHERE C9SUB.D_E_L_E_T_ <> '*'  AND C9SUB.C9_FILIAL = '"+XFILIAL("SC9")+"' AND C9SUB.C9_PEDIDO = '" + SC5->C5_NUM + "' ORDER BY C9SUB.R_E_C_N_O_ DESC)"+CRLF
	ENDIF
	CQUERYIK += " AND C9_FILIAL = '"+XFILIAL("SC9")+"'"+CRLF
	CQUERYIK += " AND "+RETSQLNAME("SC9")+".D_E_L_E_T_ <> '*' "+CRLF
	CQUERYIK += " AND C5_NUM = '" + SC5->C5_NUM + "' "+CRLF
	CQUERYIK += " AND C5_YSTSEP <> 'G' "+CRLF // SOMENTE OS QUE EST�O EM SEPARA��O (N�O OS QUE J� FORAM CONFERIDOS)
	CQUERYIK += " AND "+RETSQLNAME("SC5")+".D_E_L_E_T_ <> '*' "

	//MEMOWRITE( "MA410COR-VERZZG.SQL",CQUERYIK)
	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDZZG:= QRYIK->QTDZZG
	DBCLOSEAREA()

	/*
	|====================================================================================
	|   COMENTARIO
	|------------------------------------------------------------------------------------
	|	INCLUIDO VERIFICACAO DA TABELA ZZF (SE JA FOI INICIADO O PROCESSO DE CONFERENCIA)
	|	EDSON HORNBERGER - 09/05/2014
	|====================================================================================
	*/

	CQUERYIK := " SELECT COUNT(*) AS QTDZZF " + CRLF
	CQUERYIK += " FROM " + RETSQLNAME("ZZF") + "," + RETSQLNAME("SC9") + "," + RETSQLNAME("SC5") + " " + CRLF
	CQUERYIK += " WHERE ZZF_PEDIDO = C9_PEDIDO " + CRLF
	CQUERYIK += " AND ZZF_FILIAL = '" + XFILIAL("ZZF") + "' AND ZZF_YDICNF <> '' " + CRLF
	CQUERYIK += " AND " + RETSQLNAME("ZZF") + ".D_E_L_E_T_ <> '*' " + CRLF
	CQUERYIK += " AND C9_PEDIDO = '" + SC5->C5_NUM + "' " + CRLF
	IF SC5->C5_YFMES <> 'S'
		CQUERYIK += " AND C9_NFISCAL = '' " + CRLF
	ELSE
		CQUERYIK += " AND C9_NFISCAL = (SELECT TOP 1 C9SUB.C9_NFISCAL FROM "+RETSQLNAME("SC9")+" AS C9SUB WHERE C9SUB.D_E_L_E_T_ <> '*'  AND C9SUB.C9_FILIAL = '"+XFILIAL("SC9")+"' AND C9SUB.C9_PEDIDO = '" + SC5->C5_NUM + "' ORDER BY C9SUB.R_E_C_N_O_ DESC)"+CRLF
	ENDIF
	CQUERYIK += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' " + CRLF
	CQUERYIK += " AND " + RETSQLNAME("SC9") + ".D_E_L_E_T_ <> '*' " + CRLF
	CQUERYIK += " AND C5_NUM = '" + SC5->C5_NUM + "' " + CRLF
	CQUERYIK += " AND C5_YSTSEP <> 'G' " + CRLF
	CQUERYIK += " AND " + RETSQLNAME("SC5") + ".D_E_L_E_T_ <> '*' "

	//MEMOWRITE( "MA410COR-VERZZF.SQL",CQUERYIK)
	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERYIK),"QRYIK", .F., .T.)

	WQTDZZF:= QRYIK->QTDZZF
	DBCLOSEAREA()

	/*
	|---------------------------------------------------------------------------------
	|	E SOMADO OS DOIS VALORES DOS RESULTADOS DAS QUERYS
	|---------------------------------------------------------------------------------
	*/

	IF (WQTDZZG + WQTDZZF) == 0  //NAO TEM PEDIDO SEPARADO
		LVERZZG := .F.
	ELSE
		LVERZZG := .T.
	ENDIF

	RESTAREA(AGETAREA)

RETURN LVERZZG

/*
=================================================================================
=================================================================================
||   Arquivo:	MA410COR.PRW
=================================================================================
||   Funcao: 	EXISTOS
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		FUNCAO QUE IRA VERIFICAR SE EXISTE ORDEM DE CARGA E SE A MESMA AINDA ESTA
|| 	EM ABERTO OU FINALIZADA.
|| 
=================================================================================
=================================================================================
||   Autor:	EDSON HORNBERGER 
||   Data:	23/04/2015
=================================================================================
=================================================================================
*/

USER FUNCTION EXISTOS(__CALIAS)

	LOCAL LRET	:= .F.
	LOCAL AAREA := GETAREA()
	LOCAL CQUERY:= ""
	LOCAL _NREG := 0

/*
|---------------------------------------------------------------------------------
|	ANTES DE VERIFICAR ORDENS DE SEPARACAO, VERIFICA SE O PEDIDO ESTA CONTIDO EM 
|	ORDEM DE FATURAMENTO
|---------------------------------------------------------------------------------
*/

	CQUERY := "SELECT" 										+ PULA
	CQUERY += "	COUNT(*) AS NREG" 							+ PULA
	CQUERY += "FROM" 										+ PULA
	CQUERY += "	" + RETSQLNAME("ZC4") + " ZC4" 				+ PULA
	CQUERY += "WHERE" 										+ PULA
	CQUERY += "	ZC4_PEDIDO = '" + SC5->C5_NUM + "' AND" 	+ PULA
	CQUERY += "	ZC4_NUMOC = '' AND" 						+ PULA
	CQUERY += "	ZC4_NFISCA = '' AND" 						+ PULA
	CQUERY += "	ZC4.D_E_L_E_T_ = ''"

	IF SELECT("XXX") > 0

		DBSELECTAREA("XXX")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "XXX"
	DBSELECTAREA("XXX")

	_NREG := XXX->NREG

	DBSELECTAREA("XXX")
	DBCLOSEAREA()

	IF _NREG <= 0

		RETURN(.F.)

	ENDIF

/*
|---------------------------------------------------------------------------------
|	VERIFICA ONDE DEVE REALIZAR A VERIFICACAO DA ORDEM DE SEPARACAO
|---------------------------------------------------------------------------------
*/

	DO CASE

	CASE ALLTRIM(__CALIAS) $ "SC9|SD2"

		CQUERY := "SELECT" 												+ PULA
		CQUERY += "	DISTINCT C9_ORDSEP" 								+ PULA
		CQUERY += "FROM" 												+ PULA
		CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 						+ PULA
		CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 		+ PULA
		CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 	+ PULA
		CQUERY += "		SC5.C5_NUM = SC9.C9_PEDIDO AND" 				+ PULA
		CQUERY += "		SC5.C5_FILDES != '" + CFILANT + "' AND" 		+ PULA
		CQUERY += "		SC5.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "	INNER JOIN " + RETSQLNAME("CB7") + " CB7 ON"		+ PULA
		CQUERY += "		CB7.CB7_FILIAL = '" + XFILIAL("CB7") + "' AND" 	+ PULA
		CQUERY += "		CB7.CB7_PEDIDO = SC9.C9_PEDIDO AND"				+ PULA
		CQUERY += "		CB7.CB7_STATUS IN ('0','1','2','3','4') AND" 	+ PULA
		CQUERY += "		CB7.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "WHERE" 												+ PULA
		CQUERY += "	C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 			+ PULA
		CQUERY += "	C9_PEDIDO = '" + SC5->C5_NUM + "' AND" 				+ PULA
		CQUERY += "	C9_NFISCAL = '' AND" 								+ PULA
		CQUERY += "	SC9.D_E_L_E_T_ = ''"

		TCQUERY CQUERY NEW ALIAS "XXX"
		DBSELECTAREA("XXX")

		COUNT TO _NREG

		DBGOTOP()

		IF _NREG > 0

			IF !EMPTY(ALLTRIM(XXX->C9_ORDSEP))

				LRET := .T.

			ELSE

				LRET := .F.

			ENDIF

		ELSE

			LRET := .F.

		ENDIF

		DBSELECTAREA("XXX")
		DBCLOSEAREA()

	CASE 1 =2 // __CALIAS = "SD2"

		CQUERY := "SELECT" 												+ PULA
		CQUERY += "	DISTINCT D2_ORDSEP" 								+ PULA
		CQUERY += "FROM" 												+ PULA
		CQUERY += "	" + RETSQLNAME("SD2") + " SD2" 						+ PULA
		CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 		+ PULA
		CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 	+ PULA
		CQUERY += "		SC5.C5_NUM = SD2.D2_PEDIDO AND" 				+ PULA
		CQUERY += "		SC5.C5_FILDES = '" + CFILANT + "' AND" 			+ PULA
		CQUERY += "		SC5.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "	INNER JOIN " + RETSQLNAME("CB7") + " CB7 ON"		+ PULA
		CQUERY += "		CB7.CB7_FILIAL = '" + XFILIAL("CB7") + "' AND" 	+ PULA
		CQUERY += "		CB7.CB7_NOTA = SD2.D2_DOC AND" 					+ PULA
		CQUERY += "		CB7.CB7_SERIE = SD2.D2_SERIE AND" 				+ PULA
		CQUERY += "		CB7.CB7_STATUS IN ('0','1','2','3','4') AND" 	+ PULA
		CQUERY += "		CB7.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "WHERE" 												+ PULA
		CQUERY += "	D2_FILIAL = '" + XFILIAL("SD2") + "' AND" 			+ PULA
		CQUERY += "	D2_PEDIDO = '" + SC5->C5_NUM + "' AND" 				+ PULA
		//CQUERY += "	D2_NFISCAL = '' AND" 								+ PULA
		CQUERY += "	SD2.D_E_L_E_T_ = ''"

		TCQUERY CQUERY NEW ALIAS "XXX"
		DBSELECTAREA("XXX")

		COUNT TO _NREG

		DBGOTOP()

		IF _NREG > 0

			IF !EMPTY(ALLTRIM(XXX->D2_ORDSEP))

				LRET := .T.

			ELSE

				LRET := .F.

			ENDIF

		ELSE

			LRET := .F.

		ENDIF

		DBSELECTAREA("XXX")
		DBCLOSEAREA()

	ENDCASE

	RESTAREA(AAREA)

RETURN(LRET)
