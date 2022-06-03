#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MA410LEG ³ Autor ³ Richard Nahas Cabral  ³ Data ³25/02/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Ponto de Entrada para inclusão de legenda referente novo   ³±±
±±³          ³ status                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MA410LEG()

Local lUnidNeg := GETNEWPAR('MV_ARMCEN', .T. ,)

aCorNew	:= PARAMIXB
cEmpSep	:= GetNewPar("PRT_SEP005","99")
cFilSep	:= GetNewPar("PRT_SEP006","01")

	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") .AND. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"")
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Mostra Legenda conforme a Unidade de Negocios que foi filtrada no Ponto de 
		| Entrada M410FSQL.
		|	Edson Hornberger - 07/11/2013
		|=================================================================================
		*/
		
		If lUnidNeg
		 
			If AllTrim(SC5->C5_XITEMC) = "PROART"
		
				aCorNew := {	{'ENABLE'				,"Pedido em Aberto" 							},;//Pedido em Aberto
								{'DISABLE'				,"Pedido Encerrado"								},;//Pedido Encerrado
								{'BR_LARANJA'			,"Pedido Parcialmente Faturado"					},;
								{'BR_AMARELO'			,"Pedido Liberado / Aguardando Separacao"		},;//Pedido Lib. Ag. Separacao
								{'BR_CINZA' 			,"Pedido Parcialmente Liberado"					},;
								{'BR_AZUL'				,"Etiq. Separacao Emitida"						},;//Pedido Lib. Em Separacao
								{'BR_PINK'				,"Pedido Lib. em Sep/Conf"						},;//Pedido Lib. Em Conferencia
								{'BR_BRANCO'			,"Pedido Lib. Conferido"						},;//Pedido Lib. Conferido
								{'V_FAT_AZUL'			,"Pedido Com nota em separação"					},;//Com nota Azul (em separação)
								{'V_FAT_PINK'			,"Pedido Com nota em conferência"				},;//Com nota Pink (em conferência)
								{'V_FAT_MARROM'			,"Pedido Com nota não separado"					},;//Com nota nao separado
								{'BR_PRETO'				,"Erro no Calculo de Embalagens"				},;//Pedido Lib. com erro de cubagem
								{'V_CRED_AZUL'			,"Pendente Aval. Cred."							},;//Pedido Pendente Cred.
								{'V_CRED_LARANJA'		,"Pendente Aval. Manual Cred."					},;//Pedido Pendente Cred.
								{'V_CRED_ROSA'			,"Pendente Aval. Cred. Devido Alteração"		},;//Pedido Pendente Cred.
								{'V_CRED_VERMELHO'		,"Pedido Bloqueado Cred."						},;//Pedido Bloqueado Cred.
								{'V_CRED_AMARELO' 		,"Pendente de Aval. Cred. Complr."				} }//Pendente de Aval. Cred. Complr.
								
			ElseIf AllTrim(SC5->C5_XITEMC) = "TAIFF" 
				
				aCorNew := {	{'ENABLE'				,"Pedido em Aberto" 							},;//Pedido em Aberto
								{'DISABLE'				,"Pedido Encerrado"								},;//Pedido Encerrado
								{'BR_AMARELO'			,"Pedido Liberado aguard. Sep./Conf."			},;//Pedido Lib. Ag. Separacao
								{'BR_BRANCO'			,"Pedido Liberado Parcialmente aguard. Sep./Conf."	},;
								{'BR_VIOLETA'			,"Pedido Liberado em Sep./Conf."				},;
								{'V_FAT_AMARELO'		,"Pedido Faturado aguard. Sep./Conf."			},;
								{'V_FAT_VIOLETA'		,"Pedido Faturado em Sep./Conf."				},;
								{'BR_AZUL' 				,"Pedido com Bloqueio de Regra"					},;
								{'BR_LARANJA'			,"Pedido com Bloqueio de Verba"					},;
								{'BR_PINK'				,"Pedido com Bloqueio Comercial"				},;
								{'BR_MARROM'			,"Pedido Parcialmente Atendido"					},;								
								{'V_CRED_AZUL'			,"Pendente Aval. Cred."							},;//Pedido Pendente Cred.
								{'V_CRED_LARANJA'		,"Pendente Aval. Manual Cred."					},;//Pedido Pendente Cred.
								{'V_CRED_ROSA'			,"Pendente Aval. Cred. Devido Alteração"		},;//Pedido Pendente Cred.
								{'V_CRED_VERMELHO'		,"Pedido Bloqueado Cred."						},;//Pedido Bloqueado Cred.
								{'V_CRED_AMARELO' 		,"Pendente de Aval. Cred. Complr."				} }//Pendente de Aval. Cred. Complr.
			
			ElseIf AllTrim(SC5->C5_XITEMC) = "CORP"				
				
				aCorNew := {	{'ENABLE'				,"Pedido em Aberto" 							},;//Pedido em Aberto
								{'DISABLE'				,"Pedido Encerrado"								},;//Pedido Encerrado
								{'BR_AMARELO'			,"Pedido Liberado"								},;//Pedido Lib. Ag. Separacao
								{'BR_BRANCO'			,"Pedido Liberado Parcialmente"					},;
								{'BR_AZUL' 				,"Pedido com Bloqueio de Regra"					},;
								{'BR_LARANJA'			,"Pedido com Bloqueio de Verba"					},;
								{'BR_PINK'				,"Pedido com Bloqueio Comercial"				},;								
								{'BR_MARROM'			,"Pedido Parcialmente Atendido"					},;								
								{'V_CRED_AZUL'			,"Pendente Aval. Cred."							},;//Pedido Pendente Cred.
								{'V_CRED_LARANJA'		,"Pendente Aval. Manual Cred."					},;//Pedido Pendente Cred.
								{'V_CRED_ROSA'			,"Pendente Aval. Cred. Devido Alteração"		},;//Pedido Pendente Cred.
								{'V_CRED_VERMELHO'		,"Pedido Bloqueado Cred."						},;//Pedido Bloqueado Cred.
								{'V_CRED_AMARELO' 		,"Pendente de Aval. Cred. Complr."				} }//Pendente de Aval. Cred. Complr.
			
			EndIf
		
		EndIf
	
	ELSEIF (CEMPANT + CFILANT) = "0301" .AND. SC5->C5_CLASPED != "A"
	
		aCorNew := {	{'ENABLE'				,"Pedido em Aberto" 							},;//Pedido em Aberto
						{'DISABLE'				,"Pedido Atendido Totalmente"					},;//Pedido Atendido Totalmente
						{'BR_LARANJA'			,"Pedido Atendido Parcialmente"					},;//Pedido Atendido Parcialmente
						{'BR_AMARELO'			,"Pedido Totalmente Liberado"					},;//Pedido Totalmente Liberado
						{'BR_MARROM' 			,"Pedido Parcialmente Liberado"					},;//Pedido Parcialmente Liberado						
						{'PACKING'				,"Pedido em Separação/Conf."					},;//Pedido em Separação/Conf.
						{'TRANSFER'				,"Pedido aguuardando Transf."					},;//Pedido aguuardando Transf.
						{'TRUCKER'				,"Pedido em Trânsito"							},;//Pedido em Trânsito
						{'BILL'					,"Pedido aguardando Faturamento"				},;//Pedido aguardando Faturamento
						{'TRASH'				,"Pedido Finalizado El.Residuo"					},;//Pedido Finalizado El.Residuo
						{'ALERT'				,"Erro na Cópia do Pedido para CD"				},;//Erro na Cópia do Pedido para CD
						{'BLQMONEY'				,"Pedido com Bloqueio Comercial"				},;//Pedido com Bloqueio Comercial
						{'V_CRED_AZUL'			,"Pendente Aval. Cred."							},;//Pedido Pendente Cred.
						{'V_CRED_LARANJA'		,"Pendente Aval. Manual Cred."					},;//Pedido Pendente Cred.
						{'V_CRED_ROSA'			,"Pendente Aval. Cred. Devido Alteração"		},;//Pedido Pendente Cred.
						{'V_CRED_VERMELHO'		,"Pedido Bloqueado Cred."						},;//Pedido Bloqueado Cred.
						{'V_CRED_AMARELO' 		,"Pendente de Aval. Cred. Complr."				} }//Pendente de Aval. Cred. Complr.
					
	ELSEIF CEMPANT = "01" .OR. ((CEMPANT + CFILANT) = "0301" .AND. SC5->C5_CLASPED = "A")		
		
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"BR_MARROM","Pedido Parcialmente Atendido"}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"BR_PINK","Pedido com Bloqueio Comercial"}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"BR_BRANCO","Pedido Parcialmente Liberado"}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"V_CRED_AZUL","Pendente Aval. Cred."}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"V_CRED_LARANJA","Pendente Aval. Manual Cred."}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"V_CRED_ROSA","Pendente Aval. Cred. Devido Alteração"}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"V_CRED_VERMELHO","Pedido Bloqueado Cred."}
		Aadd(aCorNew,{})
		Ains(aCorNew,1)
		aCorNew[1] := {"V_CRED_AMARELO","Pendente de Aval. Cred. Complr."}
	
	Endif

Return aCorNew