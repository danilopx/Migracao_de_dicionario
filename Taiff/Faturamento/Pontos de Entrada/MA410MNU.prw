#INCLUDE "PROTHEUS.CH"

#DEFINE ENTER Chr(13)+Chr(10)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³ MA410MNU ºAUTOR  ³ FERNANDO SALVATORI º DATA ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ INSERE BOTOES NO PEDIDO DE VENDA                           º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS
*/
USER FUNCTION MA410MNU

//LOCAL LDISTMARCA := SUPERGETMV("MV_ARMCEN",.F.,.F.)

/*
|---------------------------------------------------------------------------------
|	INCLUI BOTAO COM RASTREABILIDADE PARA O PROJETO FASE II
|---------------------------------------------------------------------------------
*/

/* Funcionalidade descontinuada */
/* Comentada por Carlos Torres em 02/07/2020 */
//	IF LDISTMARCA .AND. CEMPANT = '03'
//		
//		/*
//		|=================================================================================
//		|   COMENTARIO
//		|---------------------------------------------------------------------------------
//		|	ALTERADO PARA QUE SEJA UTILIZADO A RASTREABILIDADE DO PEDIDO (ATENDIMENTO SP)
//		|	TAMBEM PARA A MARCA TAIFF
//		|
//		|	EDSON HORNBERGER - 29/04/2015
//		|=================================================================================
//		*/
//		AADD(AROTINA,{"Rast. Pedido" ,"EVAL({|X| IIF(ALLTRIM(X)=='TAIFF',U_TF_2CAVN_A7(),U_TF_1CAVN_A6())},SC5->C5_XITEMC)" ,0,4,0,NIL})
//		
//	ENDIF
/* fim */

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VETI FSW - 08/11 - RECALCULO DE SEPARACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__SEPA01",.F.,"") //ROTINAS DE EXPEDICAO CUSTOMIZADAS
	AADD(AROTINA,{"Consulta"         	,"U_PRTC003A" 		,0,4,0,NIL})
	//AADD(AROTINA,{"Volume"        		,"U_PRTM0008" 		,0,4,0,NIL})
	AADD(AROTINA,{"Cons. Historico"  	,"U_PRTC0005" 		,0,4,0,NIL})
	
//-----------------------------------------------------------------------------------------------
//ADICIONADO POR THIAGO COMELLI EM 16/10/2012
//EXECUTA SOMENTE NA EMPRESA E FILIAL SELECIONADOS
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT04",.F.,"")
		IF VERSENHA(136) //VERIFICA SE O USUARIO LOGADO POSSUI ACESSO 136-LIB.PEDIDO VENDA
			AADD(AROTINA,{"Aprovar Ped.","U_FINMI001(SC5->C5_CLIENTE, SC5->C5_LOJACLI)"	, 0 , 2, 0,NIL})
		ENDIF
	ENDIF
//------------------------------------------------------------------------------------------------
	
ELSE
	/*
	|---------------------------------------------------------------------------------
	|	INSERIDO O BOTAO "CONSULTA" PARA AS EMPRESAS QUE PARTICIPAM DO PARAMETRO
	| MV__MULT04 (MOSTRA BOTOES DE APROVACAO DE CREDITO NAS EMPRESAS SELECIONADAS.)
	|	EDSON HORNBERGER - 22/07/2014
	|---------------------------------------------------------------------------------
	*/
	IF (CEMPANT+CFILANT) $ SUPERGETMV("MV__MULT04",.F.,"")
		AADD(AROTINA,{"Consulta"    ,"U_PRTC003A" ,0,4,0,NIL})
		IF VERSENHA(136) //VERIFICA SE O USUARIO LOGADO POSSUI ACESSO 136-LIB.PEDIDO VENDA
			AADD(AROTINA,{"Aprovar Ped.","U_FINMI001(SC5->C5_CLIENTE, SC5->C5_LOJACLI)"	, 0 , 2, 0,NIL})
		ENDIF
	ENDIF
	
	/*
	|---------------------------------------------------------------------------------
	|	Adicionado Botao para Gerar Pedido de Venda no CD de MG quando houve Erro no 
	|	Processo.
	|
	|	Edson Hornberger - 28/10/2015
	|---------------------------------------------------------------------------------
	*/
	IF CEMPANT + CFILANT = "0301"
			
		AADD(AROTINA,{"Gerar Ped. CD MG"       		,"U_PEDCDMG(SC5->C5_NUM,.F.)" 		,0,4,0,NIL})
		
	ENDIF
	
ENDIF             

IF SM0->M0_CODIGO + SM0->M0_CODFIL $ GETMV("MV_X_BNFIL") 
	
	//Verifica se usuario tem acesso a Liberar Bonificacoes                                               
		If __cUserID $ GetMV("MV_X_LIBON")                   
		                                           
			//Verifica se a rotina de Liberacao de Bonificacao esta compilada no ambiente corrente
			If ExistBlock("RX410LIB")
		                                                                     
				Aadd(aRotina,{"Lib Bonifica Vinc."		, "U_RX410LIBB(SC5->C5_FILIAL, SC5->C5_NUM)"	, 0 , 2, 0,NIL})
				If __cUserID $ GetMV("TF_LIBBNF",.T.,"000748")
					Aadd(aRotina,{"Lib.Bonific.s/Vinc."	, "U_LIBBNFSVC(SC5->C5_NUM)"						, 0 , 2, 0,NIL})
				endif 
			
			EndIf
			
		EndIf

ENDIF                      
/*
IF CEMPANT = "03" .AND. CFILANT = "02" 
		
	AADD(AROTINA,{"A reservar"       		,"U_TFRESERVA()" 		,0,4,0,NIL})
	
ENDIF
*/


IF CEMPANT = "03" .AND. CFILANT = "02" 
		
	AADD(AROTINA,{"Aprovar Separacao"       		,"U_TFAVISTA()" 		,0,4,0,NIL})
	
ENDIF

RETURN NIL

User Function TFRESERVA()
	Local lRetorno := .T.
	Local cTitulo		:= "Controle de Reserva por Alcada"
	Local nOpca			:= 0

	If SC5->(FIELDPOS("C5__DTLIBF")) > 0
		If SC5->C5__RESERV = "R"
			Aviso("ATENÇÃO!", "Pedido já está na alcada de reserva!", {"Ok"}, 3)
		ElseIf SC5->C5__RESERV = "L"
			Aviso("ATENÇÃO!", "Pedido já está liberado pela alcada de reserva!", {"Ok"}, 3)
		ElseIf (.NOT. EMPTY(SC5->C5__DTLIBF)) .OR. (.NOT. EMPTY(SC5->C5_LIBEROK)) 
			Aviso("ATENÇÃO!", "Pedido não está disponivel para alcada de reserva!", {"Ok"}, 3)
		Else	
			DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 120,300 PIXEL
		
			@ 001,001 TO 060, 150 OF oDlg PIXEL
		
			@ 010,010 SAY   "Solicita aprovacao de Reserva?" SIZE 155, 07 OF oDlg PIXEL
		
			DEFINE SBUTTON FROM 045, 040 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
		
			DEFINE SBUTTON FROM 045, 090 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg
		
			ACTIVATE MSDIALOG oDlg CENTERED
		
			If nOpca=2
				Aviso("ATENÇÃO!", "O pedido não foi atribuido à alcada de reserva!", {"Ok"}, 3)
			Else
				If SC5->(RecLock("SC5",.F.))
					SC5->C5__RESERV := "R"
					SC5->(MsUnlock())				
					Aviso("ATENÇÃO!", "O pedido foi atribuido controle de reserva" + ENTER + "Solicite à alcada aprovacao da reserva!", {"Ok"}, 3)
				EndIf
			EndIf
		EndIf
	EndIf
Return (lRetorno)

User Function TFAVISTA()
	Local lRetorno := .T.
	Local cTitulo		:= "Controle de Separacao"
	Local nOpca			:= 0

	If SC5->(FIELDPOS("C5_YSTSEP")) > 0
		If SC5->C5_YSTSEP = "G" .OR. .NOT. EMPTY(SC5->C5_NOTA) .OR. (.NOT. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" )
			Aviso("ATENÇÃO!", "Situacao do Pedido não permite manutencao do status!", {"Ok"}, 3)
		Else 
			DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 120,300 PIXEL
			
			@ 001,001 TO 060, 150 OF oDlg PIXEL

			If SC5->C5_YSTSEP = "N"
				@ 010,010 SAY   "Libera o status de separacao/conferencia no CD?" SIZE 155, 07 OF oDlg PIXEL
			ElseIf Empty(SC5->C5_YSTSEP)
				@ 010,010 SAY   "Bloqueia o status de separacao/conferencia no CD?" SIZE 155, 07 OF oDlg PIXEL
			EndIf

			DEFINE SBUTTON FROM 045, 040 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
		
			DEFINE SBUTTON FROM 045, 090 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg
		
			ACTIVATE MSDIALOG oDlg CENTERED
		
			If nOpca=2
				Aviso("ATENÇÃO!", "O pedido não sofreu alteracao!", {"Ok"}, 3)
			Else
				If SC5->C5_YSTSEP = "N"
					If SC5->(RecLock("SC5",.F.))
						SC5->C5_YSTSEP := ""
						SC5->(MsUnlock())				
						Aviso("ATENÇÃO!", "Status do pedido alterado para liberacao da separacao/conferencia" , {"Ok"}, 3)
					EndIf
				ElseIf Empty(SC5->C5_YSTSEP)
					If SC5->(RecLock("SC5",.F.))
						SC5->C5_YSTSEP := "N"
						SC5->(MsUnlock())				
						Aviso("ATENÇÃO!", "Status do pedido alterado para BLOQUEIO da separacao/conferencia" , {"Ok"}, 3)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return (lRetorno)

