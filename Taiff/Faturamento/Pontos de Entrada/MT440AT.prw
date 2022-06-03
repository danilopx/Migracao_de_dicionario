#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#DEFINE PULA CHR(13) + CHR(10)
#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT440AT  º Autor ³ Marcelo Cardoso    º Data ³  12/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para Validacao da Liberacao do Pedido     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Taiff-ProaArt                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT440AT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lLibera   	:= .T.      
Local _cOldAlias 	:= Alias()
Local _aOldAlias 	:= GetArea()
Local _aSC5Alias 	:= SC5->(GetArea())
Local _aSC6Alias 	:= SC6->(GetArea())
Local _aSE4Alias 	:= SE4->(GetArea())
Local _aSF4Alias 	:= SF4->(GetArea())
LOCAL CTIT			:= OEMTOANSI("Liberação de Pedidos de Venda")
LOCAL CQUERY		:= ""
Local NTFLIBOK		:= 0
LOCAL CC9ORDSEP		:= ""

If CEMPANT = "03" .AND. CFILANT = "02" .AND. SC5->(FIELDPOS("C5__DTLIBF")) > 0
	 If SC5->C5__LIBM = "A" .AND. .NOT. SC5->C5_CONDPAG $ "N01|N02" 
		MESSAGEBOX("Não é possível realizar Liberações para pedidos que passaram pela liberação automática" + ENTER + "Estorne as liberações pela rotina de pedido de venda." + ENTER + ENTER + "Validação técnica em: " + PROCNAME(),"ATENÇÃO",16)
		RETURN(.F.)
	 EndIf
EndIf


/*
|---------------------------------------------------------------------------------
|	VALIDAÇÃO NA EMPRESA 03/01: NAO PERMITE LIBERAR PEDIDOS EM CROSS DOCKING
|---------------------------------------------------------------------------------
 
*/
IF CEMPANT + CFILANT = "0301" 
	NTFLIBOK := 0 

	If ALLTRIM(SC5->C5_STCROSS) $ "ERRCOP|AGCOPY"
		NTFLIBOK := 1
	EndIf
	
	If NTFLIBOK = 0 
		CQUERY := "SELECT" 												+ ENTER
		CQUERY += "	COUNT(*) AS QTDREG" 								+ ENTER 
		CQUERY += "FROM" 													+ ENTER
		CQUERY += "	" + RETSQLNAME("SC5") 							+ ENTER 
		CQUERY += "WHERE" 												+ ENTER 
		CQUERY += "	C5_FILIAL = '02' " 								+ ENTER 
		CQUERY += "	AND C5_NUMORI = '" + ALLTRIM(SC5->C5_NUM) + "'"+ ENTER
		CQUERY += "	AND D_E_L_E_T_ = ''" 
		
		IF SELECT("TMP") > 0
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
		ENDIF 
		
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		
		NTFLIBOK := TMP->QTDREG 
		DBCLOSEAREA()
	EndIf

	If NTFLIBOK = 0 
		CQUERY := "SELECT" 												+ ENTER
		CQUERY += "	COUNT(*) AS QTDREG" 								+ ENTER 
		CQUERY += "FROM" 													+ ENTER
		CQUERY += "	" + RETSQLNAME("SC6") 							+ ENTER 
		CQUERY += "WHERE" 												+ ENTER 
		CQUERY += "	C6_FILIAL = '" + xFilial("SC6") + "' " 			+ ENTER 
		CQUERY += "	AND C6_NUM = '" + ALLTRIM(SC5->C5_NUM) + "'"	+ ENTER
		CQUERY += "	AND C6_LOCAL = '21'"								+ ENTER
		CQUERY += "	AND D_E_L_E_T_ = ''" 
		
		IF SELECT("TMP") > 0
			DBSELECTAREA("TMP")
			DBCLOSEAREA()
		ENDIF 
		
		TCQUERY CQUERY NEW ALIAS "TMP"
		DBSELECTAREA("TMP")
		DBGOTOP()
		
		NTFLIBOK := TMP->QTDREG 
		DBCLOSEAREA()
	EndIf

	If	NTFLIBOK != 0
		MESSAGEBOX("Não é possível realizar Liberações para PEDIDO na Filial de SP" + ENTER + "quando em CROSS DOCKING ou atribuido ao armazém para CROSS DOCKING!!!" + ENTER + "Validação técnica em: " + PROCNAME(),"ATENÇÃO",16)
		RETURN(.F.)
	ENDIF 

ENDIF 

/*
|---------------------------------------------------------------------------------
|	REALIZA A VALIDAÇÃO PARA QUE NÃO SEJA REALIZADO LIBERAÇÕES SENDO QUE JÁ 
|	EXITEM REGISTROS NO SC9 AGUARDANDO FATURAMENTO
|---------------------------------------------------------------------------------
*/

CQUERY := "SELECT" 													+ ENTER 
CQUERY += "	COUNT(*) AS QTDREG" 									+ ENTER 
CQUERY += "FROM" 														+ ENTER
CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 						+ ENTER 
CQUERY += "WHERE" 													+ ENTER 
CQUERY += "	SC9.C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 	+ ENTER
CQUERY += "	SC9.C9_PEDIDO = '" + SC5->C5_NUM + "' AND" 		+ ENTER 
CQUERY += "	SC9.C9_NFISCAL = '' AND" 							+ ENTER 
CQUERY += "	SC9.D_E_L_E_T_ = ''"

IF SELECT("TMP") > 0 
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
	
ENDIF

TCQUERY CQUERY NEW ALIAS "TMP"
DBSELECTAREA("TMP")
DBGOTOP()

IF TMP->QTDREG > 0 .AND. .NOT. IsInCallStack("U_ESTMI001") 
	
	MESSAGEBOX("Existem liberações aguardando Faturamento!" + ENTER + "Para realizar nova liberação aguarde o faturamento ou altere o Pedido" + ENTER + "para cancelar as liberações atuais!","ATENÇÃO",48)
	DBSelectArea("SC5")
	RestArea(_aSC5Alias)
	
	DBSelectArea("SC6")
	RestArea(_aSC6Alias)
	
	DBSelectArea("SE4")
	RestArea(_aSE4Alias)
	
	DBSelectArea("SF4")
	RestArea(_aSF4Alias)
	
	DBSelectArea(_cOldAlias)
	RestArea(_aOldAlias)
	
	Return(.F.)
	
ENDIF 

/*
|---------------------------------------------------------------------------------
|	ALTERA O PARAMETRO DE "SUGERE QTD LIBERADA" POR USUARIO
|---------------------------------------------------------------------------------
*/
IF CEMPANT + CFILANT = "0302" //.AND. SC5->C5_TIPO = 'N'

	IF 	(U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. EMPTY(SC5->C5_NUMOC) .AND. .NOT. SC5->C5_TIPO $ ("D")) .OR. ; 
		(U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. EMPTY(SC5->C5_NUMOC)) .OR. ;
		(SC5->C5_CLASPED $ ('A|B|E| ')) .OR. ;
		(SC5->C5_TIPO $ ("D"))  
	
		DBSELECTAREA("SX1")
		DBSETORDER(1)
		IF DBSEEK(PADR("MTA440",10) + "03")
			
			IF RECLOCK("SX1",.F.)
				
				SX1->X1_PRESEL := 1
				MSUNLOCK()
				
			ENDIF
			
		ENDIF 
		
		MV_PAR03 	:= 1 
		LSUGERE	:= .T.
		IF .NOT. IsInCallStack("U_FATMI012")
			MESSAGEBOX('Utilize a opção "Ajusta Est.Disponivel" para realizar a Liberação do Pedido!',"ATENÇÃO",48)
		ENDIF
	
	ELSE
	
		DBSELECTAREA("SX1")
		DBSETORDER(1)
		IF DBSEEK(PADR("MTA440",10) + "03")
			
			IF RECLOCK("SX1",.F.)
				
				SX1->X1_PRESEL := 2
				MSUNLOCK()
				
			ENDIF
			
		ENDIF 
		
		MV_PAR03 	:= 2 
		LSUGERE	:= .F.
	
	ENDIF
	 
ELSE

	DBSELECTAREA("SX1")
	DBSETORDER(1)
	IF DBSEEK(PADR("MTA440",10) + "03")
		
		IF RECLOCK("SX1",.F.)
			
			SX1->X1_PRESEL := 1
			MSUNLOCK()
			
		ENDIF
		
	ENDIF 
	
	MV_PAR03 	:= 1 
	LSUGERE	:= .T.

	IF .NOT. IsInCallStack("U_FATMI012")
		MESSAGEBOX('Utilize a opção "Ajusta Est.Disponivel" para realizar a Liberação do Pedido!',"ATENÇÃO",48)
	ENDIF
	
ENDIF 

If SC5->C5_CLASPED == "A"

	If !AllTrim(__cUserID) $ GetMV("MV_X_LIBAT")
	
		Aviso("MV_X_LIBAT", "Usuario nao autorizado a liberar Pedidos de Assistencia Tecnica.", {"Ok"})

		_lLibera := .F.
		
	EndIf

EndIf              

/*
Projeto...: Cross Docking
Data......: 15/10/2015
Descriçao.: Bloqueia a liberação do pedido de venda quando a data programada de entrega for superior à data base   
Autor.....: CT
*/
If CEMPANT+CFILANT = '0302' .AND. ALLTRIM(SC5->C5_XITEMC) = 'TAIFF' .AND. .NOT. Empty(SC5->C5_DTPEDPR)   
	If SC5->C5_DTPEDPR > DDATABASE 
		AVISO(CTIT,"Pedido com data programada de entrega para " + DTOC(C5_DTPEDPR) + " superior à data base do sistema, isto impede a liberação.",{"Ok"}) 
		_lLibera := .F.
	EndIf
EndIf
/*
Projeto...: Cross Docking
Data......: 28/10/2015
Descriçao.: Bloqueia a liberação do pedido de venda quando houver eliminação de residuo pendente de executar   
Autor.....: CT
*/
If CEMPANT+CFILANT = '0302' .AND. SC5->C5_FILDES = '01' .AND. .NOT. Empty(SC5->C5_NUMORI) 
	If ZC8->(DbSeek( xFilial("ZC8") + SC5->C5_NUMORI ))  
		AVISO(CTIT,"Pedido com eliminação de resíduo em andamento no CD de origem isto impede a liberação.",{"Ok"}) 
		_lLibera := .F.
	EndIf
EndIf

/*
|---------------------------------------------------------------------------------
|	VERIFICA SE O PEDIDO (TAIFFPROART SP) TEM COPIA EM TAIFFPROART MG. SE HOUVER 
|	NAO PERMITE A ALTERACAO  
|---------------------------------------------------------------------------------
NÃO VALIDA PEDIDOS DA ASSISTENCIA TECNICA
*/

IF CEMPANT+CFILANT = "0301" .AND. SC5->C5_CLASPED != "A" 
	If !U_VERGRUPO(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .AND. !U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC"))
	
		If .NOT. SC5->C5_TIPO $ 'D|B'
			DBSELECTAREA("SC5")
			DBORDERNICKNAME("SC5NUMOLD")
			IF DBSEEK("02" + SC5->C5_NUMOLD)
				
				AVISO(CTIT,"Pedido só pode ser liberado em Taiff MG!",{"Ok"})
				_lLibera := .F.
				
			ENDIF
		EndIf
	EndIf		
ENDIF

/*
|---------------------------------------------------------------------------------
|	ANTES DE REALIZAR A LIBERACAO DO PEDIDO DE BONIFICACAO SERA VERIFICADO A 
|	AMARRACAO DO PEDIDO DE VENDA
|---------------------------------------------------------------------------------
*/

IF SC5->C5_CLASPED = "X" .AND. CNUMEMP $ GetMV("MV_X_BNFIL") .AND. EMPTY(ALLTRIM(SC5->C5_X_PVBON)) .AND. !SC5->C5_BNFLIB   

	MSGSTOP("Pedido de Bonificação sem amarração com Pedido de Venda e sem Aprovação!","ATENÇÃO")
	_lLibera := .F.
	
ELSEIF SC5->C5_CLASPED = "X" .AND. CNUMEMP $ GetMV("MV_X_BNFIL") .AND. !EMPTY(ALLTRIM(SC5->C5_X_PVBON))
	
	CQUERY := "SELECT" 													+ ENTER 
	CQUERY += "	'X' AS EXISTE" 											+ ENTER 
	CQUERY += "FROM" 													+ ENTER
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 							+ ENTER
	CQUERY += "WHERE" 													+ ENTER 
	CQUERY += "	SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 			+ ENTER 
	CQUERY += "	SC5.C5_NUMOLD = '" + ALLTRIM(SC5->C5_X_PVBON) + "' AND"	+ ENTER 
	CQUERY += "	SC5.D_E_L_E_T_ = ''" 

	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP")
		DBCLOSEAREA()
		
	ENDIF 

	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	DBGOTOP()
	
	IF TMP->EXISTE != "X"
	
		MSGSTOP("Pedido de Venda amarrado a este Pedido de Bonificação não existe." + ENTER + "Liberação não será realizada!","ATENÇÃO")
		_lLibera := .F.
	
	ELSE
	
		CQUERY := "SELECT" + ENTER
		CQUERY += "	COUNT(*) AS NREGS" + ENTER 
		CQUERY += "FROM" + ENTER 
		CQUERY += "	" + RETSQLNAME("SC9") + " SC9" + ENTER
		CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" + ENTER 
		CQUERY += "		SC5.C5_FILIAL = SC9.C9_FILIAL AND" + ENTER 
		CQUERY += "		SC5.C5_NUM = SC9.C9_PEDIDO AND" + ENTER 
		CQUERY += "		SC5.C5_NUMOLD = '" + ALLTRIM(SC5->C5_X_PVBON) + "' AND" + ENTER 
		CQUERY += "		SC5.D_E_L_E_T_ = ''" + ENTER 
		CQUERY += "WHERE" + ENTER 
		CQUERY += "	C9_FILIAL = '" + XFILIAL("SC9") + "' AND" + ENTER  
		CQUERY += "	C9_NFISCAL = '' AND" + ENTER
		CQUERY += "	SC9.D_E_L_E_T_ = ''"
		IF SELECT("EXT") > 0 
			DBSELECTAREA("EXT")
			DBCLOSEAREA()
		ENDIF 
		
		TCQUERY CQUERY NEW ALIAS "EXT"
		DBSELECTAREA("EXT")
		
		IF EXT->NREGS <= 0 
			
			MSGSTOP("O Pedido de Venda vínculado nesta Bonificação ainda não foi Liberado!" + ENTER + "Liberar o Pedido de Venda primeiro!","ATENÇÃO")
			lLibera := .F.
			
		ENDIF 
		
	ENDIF 
	
ENDIF

/*
Projeto...: Liberação somente com OS finalizada
Data......: 27/07/2020
Descriçao.: Não permite nova liberação enquanto houver OS não faturada
Autor.....: CT
*/
If CEMPANT+CFILANT = '0302' .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART"
	IF ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X" .AND. SC5->C5_TIPO="N"
		CC9ORDSEP	:= ""
		
		SC9->(DbSetOrder(1))
		SC9->(DbSeek( xFilial("SC9") + SC5->C5_NUM ))
		While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = SC5->C5_NUM .AND. !SC9->(Eof())
			IF EMPTY(SC9->C9_NFISCAL) 
				CC9ORDSEP := SC9->C9_ORDSEP
			ENDIF
			SC9->(DbSkip())
		EndDo

		IF .NOT. EMPTY(CC9ORDSEP) 
			Aviso(CTIT, "Pedido com ordem de separação não faturada", {"Ok"}, 3)
			_lLibera := .F.
		ENDIF
	ENDIF


EndIf

DBSelectArea("SC5")
RestArea(_aSC5Alias)

DBSelectArea("SC6")
RestArea(_aSC6Alias)

DBSelectArea("SE4")
RestArea(_aSE4Alias)

DBSelectArea("SF4")
RestArea(_aSF4Alias)

DBSelectArea(_cOldAlias)
RestArea(_aOldAlias)

Return(_lLibera)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440AT.prw
=================================================================================
||   Funcao: 	CLITRANSP
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para verificar se o cliente é um Transportadora.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		22/01/2016
=================================================================================
=================================================================================
*/

USER FUNCTION CLITRANSP(CCGC)

LOCAL LRET := .F. 

DBSELECTAREA("SA4")
DBSETORDER(3)
IF DBSEEK(XFILIAL("SA4") + CCGC)
	
	LRET := .T.
	
ELSE

	LRET := .F.

ENDIF 

RETURN(LRET)
