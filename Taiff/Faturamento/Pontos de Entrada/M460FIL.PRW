#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M460FIL  ºAutor  ³ Jorge Tavares      º Data ³  12/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna codigo da unidade de negocios do grupo de perguntasº±±
±±º          ³ do Documento de Saida( utilizado PE M460FIL para gravar SX1º±±
±±º          ³ Filtro para geracao das notas de Saida (MATA461)			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User function M460FIL

Local cRet				:= ''
Local aSx1area 		:= SX1->(Getarea())
Local lUniNeg			:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
Local _lStatusFaseII	:= GetNewPar("MV_ARMCEN",.F.) 
Local cCliMatriz 		:= ""
Local aSxkarea 		:= SXK->(Getarea())
Local cC5DTLIBF		:= ""
Local cC5TRANSP		:= ""
Local cSepMarca		:= ""
LOCAL cCLASSPED		:= ""

IF CEMPANT + CFILANT = "0302"
	cCliMatriz := ALLTRIM(TFsx6cli()) 
ENDIF

If lUniNeg .or. _lStatusFaseII
	cRet += " C9_XEMP='"+CEMPANT+"' .AND. "
	cRet += " C9_XFIL='"+CFILANT+"' "

	SX1->(DbsetOrder(1))
	SXK->(DbsetOrder(1))
	/*
	|---------------------------------------------------------------------------------
	|	Realizado alteracao no fonte Linha 34 passando a pesquisa de 13 para 16, pois
	|	o Consultor Jorge "amarrou" esta pesquisa.
	| 	Edson Hornberger - 11/06/2014
	|---------------------------------------------------------------------------------
	*/
	/* Para o PROTHEUS 12 o grupo de pergunta mudou de 16 para 17 */

	/* Tratamento implementado para diferenciar atendimento de nota fiscal OPERACAO ESTORNO DE CREDITO */
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "19" + "U" + __CUSERID) ) .AND. CEMPANT='03' .AND. CFILANT='02'
		If LEFT(SXK->XK_CONTEUD,1) = "3"
			cCLASSPED := "E"
		EndIf 		
	ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'19') ) .AND. CEMPANT='03' .AND. CFILANT='02'
		If Upper(Alltrim(SX1->X1_CNT01)) == "E"
			cCLASSPED := "E"
		EndIf 		
	EndIf

	If cCLASSPED <> "E"

		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO))+ "17" + "U" + __CUSERID) )
			
			cRet += " .AND. C9_XITEM ='"+ Iif( LEFT(SXK->XK_CONTEUD,1)="T","1",Iif(LEFT(SXK->XK_CONTEUD,1)="P","2","4")) + "'"   
			cSepMarca := Iif( LEFT(SXK->XK_CONTEUD,1)="T","1",Iif(LEFT(SXK->XK_CONTEUD,1)="P","2","4"))
			
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'17') )
			
			cRet += " .AND. C9_XITEM ='"+ Alltrim(Str(SX1->X1_PRESEL))+"'" 
			cSepMarca := Alltrim(Str(SX1->X1_PRESEL))
		EndIf

	EndIf

	/* Para faturamento do CROSS DOCKING foi gerado filtro pelo numero da ordem de carga */
	/* desta forma as notas fiscais serão emitidas conforme separação feita na origem */
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO))+ "18" + "U" + __CUSERID) ) .AND. CEMPANT='03' .AND. CFILANT='01'
		If !Empty(Alltrim(SXK->XK_CONTEUD))
			cRet += " .AND. C9_NUMOF ='"+ Alltrim(SXK->XK_CONTEUD)+"'"
		EndIf 
	ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'18') ) .AND. CEMPANT='03' .AND. CFILANT='01'
		If !Empty(Alltrim(SX1->X1_CNT01))
			cRet += " .AND. C9_NUMOF ='"+ Alltrim(SX1->X1_CNT01)+"'"
		EndIf 
	EndIf
	
	/* Tratamento implementado para diferenciar atendimento da ASTEC ja que o faturamento é pelo armazem 51 */
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "19" + "U" + __CUSERID) ) .AND. CEMPANT='03' .AND. CFILANT='01'
		If LEFT(SXK->XK_CONTEUD,1) = "1"
			cRet += " .AND. C9_LOCAL != '51' "
			cC5DTLIBF := "S"
		ElseIf LEFT(SXK->XK_CONTEUD,1) = "2"
			cRet += " .AND. C9_LOCAL = '51' "
		EndIf 		
	ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'19') ) .AND. CEMPANT='03' .AND. CFILANT='01'
		If SX1->X1_CNT01 = "O"
			cRet += " .AND. C9_LOCAL != '51' "
			cC5DTLIBF := "S"
		ElseIf SX1->X1_CNT01 = "A"
			cRet += " .AND. C9_LOCAL = '51' "
		EndIf 		
	EndIf

	/* Tratamento implementado para filtrar a transportadora */
	If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "20" + "U" + __CUSERID) ) .AND. CEMPANT="03" 
		cC5TRANSP := ALLTRIM(SXK->XK_CONTEUD)
	ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+"20") ) .AND. CEMPANT='03' 
		cC5TRANSP := ALLTRIM(SX1->X1_CNT01)
	EndIf
	RestArea(aSx1area)
	RestArea(aSxkarea)
Else
	cRet := " C9_FILIAL ='"+ xFilial('SC9') + "'"
Endif
/*
Projeto...: Cross Docking - Reconstrução
Data......: 23/10/2015
Descriçao.: Bloqueia a liberação do pedido de venda para São Paulo já que o mesmo vai pela rotina de aglutinação
Autor.....: CT
Observacao: Não bloqueia as transferencias para CD's por exemplo faz liberação para Engenharia
*/
IF cCLASSPED = "E" .AND. CEMPANT = "03" .AND. CFILANT = "02"

ELSEIf CEMPANT + CFILANT = "0302" .AND. .NOT. Empty(cCliMatriz)
	cRet += " .AND. ( (C9_CLIENTE+C9_LOJA != '"+ cCliMatriz + "' .AND. EMPTY(C9_PEDORI)) "
	cRet += " .OR.    (C9_CLIENTE+C9_LOJA = '"+ cCliMatriz + "' .AND. EMPTY(C9_PEDORI) .AND. C9_LOCAL='21') )"
EndIf

IF cCLASSPED = "E" .AND. CEMPANT = "03" .AND. CFILANT = "02"

ELSEIf CEMPANT = "03" .AND. .NOT. Empty(cC5TRANSP)
	cRet += " .AND. ( '" + cC5TRANSP + "' = POSICIONE('SC5', 1, xFilial('SC5') + C9_PEDIDO, 'C5_TRANSP') ) "
EndIf 

/* Tratamento para os pedidos que estão disponiveis para fatuamento do projeto de liberação em lote */
IF cCLASSPED = "E" .AND. CEMPANT = "03" .AND. CFILANT = "02"
	cRet += " .AND. C9_PRODUTO = '975000092      ' " // produto especifico para o ESTORNO DE CREDITO - ESTOQUE

ELSEIF CEMPANT = "03" .AND. CFILANT = "02"
	cRet += " .AND. ( "
	cRet += "( .NOT. EMPTY( POSICIONE('SC5', 1, xFilial('SC5') + C9_PEDIDO, 'C5__DTLIBF') ) "
	cRet += " .AND. C9_LOCAL='21'"
	/* Funcionalidade do projeto de Faturamento somente com Ordem de Separa??o */
	/* Data: 12/05/2020                               Respons?vel: Carlos Torres*/
	/* pedidos TAIFF ou PROART somente ser?o faturados se a ordem de separa??o estiver finalizada */
	/* verificar: armaz?m de processo 21 CB7 com status 9 que seja TAIFF ou PROART */
	If cSepMarca $ "1|2"  
		cRet += " .AND. .NOT. EMPTY(C9_ORDSEP)"
		cRet += " .AND. ( POSICIONE('CB7', 1, xFilial('CB7') + C9_ORDSEP, 'CB7_STATUS') = '9' )"
	EndIf
	/* Fim do controle */
	cRet += " ) .OR. (C9_LOCAL!='21' .AND. C9_NFISCAL='') "
	cRet += ")"
EndIf

//MemoWrite("M460FIL_filtro_SC9.TXT",cRet)

Return cRet

/*
	Parametro que contem o cliente/loja da TAIFFPROART - MATRIZ 
	Os pedidos de SP quando em CROSS DOCKING em EXTREMA são criados com o cliente/loja do CNPJ da TAIFFPROART - MATRIZ  
*/
Static Function TFsx6cli()
Local cRetorno		:= ""
Local xSM0Alias	:= SM0->(GETAREA())
Local xSa1Alias	:= SA1->(GETAREA())
Local xSx6Alias	:= SX6->(GETAREA())
Local cCliDeSP		:= ""
Local cCGCdaFilial:= ""

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CLIMATR" )
	DBSELECTAREA("SM0")
	DBSETORDER(1)
	SM0->(DBSEEK("0301"))
	cCGCdaFilial := SM0->M0_CGC
		
	SA1->(DbSetOrder(3))
	If SA1->(DbSeek( xFilial("SA1") + cCGCdaFilial ))
		cCliDeSP := SA1->A1_COD + SA1->A1_LOJA
	EndIf

	RecLock("SX6", .T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "TF_CLIMATR"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "Cliente Loja do CD de SP (TAIFFPROART - MATRIZ) "
	SX6->X6_DESC1   := "utilizado em CROSS DOCKING ou nas transferencias"
	SX6->X6_CONTEUD := cCliDeSP
	SX6->X6_CONTSPA := cCliDeSP
	SX6->X6_CONTENG := cCliDeSP
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	MsUnlock()
	
	cRetorno := cCliDeSP
	 
Else
	cRetorno := SX6->X6_CONTEUD 
EndIf

cRetorno := Alltrim( cRetorno )
RestArea(xSa1Alias)
RestArea(xSM0Alias)
RestArea(xSx6Alias)                                                                                                                                                                                                                         


Return (cRetorno)
