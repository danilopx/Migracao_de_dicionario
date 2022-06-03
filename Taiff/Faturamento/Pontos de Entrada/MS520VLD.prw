#include "RWMAKE.CH"
#include "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE PULA CHR(13) + CHR(10)
#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT081EXC  ºAutor  ³Richard N. Cabral   º Data ³  22/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para validar a excluição da nf com        º±±
±±º          ³ ordem de separação, no caso, não podera ser exluida sem    º±±
±±º          ³ antes excluir a order de separação                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MS520VLD()

local _lret:=.T.
Local _client:=SF2->F2_CLIENTE
Local _loja:=  SF2->F2_LOJA
Local _Doc:=   SF2->F2_DOC
local _serie:= SF2->F2_SERIE
Local cD2ORDSEP := ""

//Incluido por Edson Hornberger 25/09/2013
Local aAreaSM0	:= SM0->(GetArea())  
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local cCGCEmp	:= ""
Local cEmpDes	:= ""
Local cFilDes	:= ""
Local CQUERY	:= ""
Local aItens	:= {}
Local aArea	:= GetArea()
LOCAL CVARGLB	:= "d" + ALLTRIM(UsrRetName()) + cValtoChar(THREADID())

/* variaveis de uso na validação da NCC de Verba */
Local aSE1Alias	:= SE1->(GetArea()) 
Local aZA6Alias 	:= ZA6->(GetArea()) 
Local cZA6Prefixo	:= ""

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Realiza a validacao para exclusao de NF de Transferencia. Projeto Avante 
|	Fase II.
|	Edson Hornberger - 25/09/2013
|=================================================================================
*/

DBSELECTAREA("SD2")
DBSETORDER(3)
DBGOTOP()
DBSEEK(XFILIAL("SD2") + _Doc + _serie + _client + _loja)

cD2ORDSEP := SD2->D2_ORDSEP

DBSELECTAREA("SC5")
DBSETORDER(1)
DBGOTOP()
DBSEEK(XFILIAL("SC5") + SD2->D2_PEDIDO)

IF SC5->C5_INTER = 'S'
	
	cCGCEmp := POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC") 
	
	DBSELECTAREA("SM0")
	DBSETORDER(1)
	DBGOTOP()
	
	WHILE SM0->(!EOF()) 
		
		IF SM0->M0_CGC = cCGCEmp
		
			cEmpDes := SM0->M0_CODIGO
			cFilDes := SM0->M0_CODFIL
		
		ENDIF
		SM0->(DBSKIP())
		
	ENDDO
	
	RESTAREA(aAreaSM0)
	
	If !Empty(cEmpDes) // Acrescentado em 13/03/2014 por CT
		cQuery := "SELECT" 																					+ PULA 
		cQuery += "SF1.F1_DOC," 																				+ PULA 
		cQuery += "SF1.F1_SERIE" 																			+ PULA 
		cQuery += "FROM" 																						+ PULA 
		cQuery += "SF1" + cEmpDes + "0 SF1" 																+ PULA 
		cQuery += "INNER JOIN SA2" + cEmpDes + "0 SA2 ON" 												+ PULA
		cQuery += "SA2.A2_FILIAL = dbo.FC_TABMODO('" + cEmpDes + "','" + cFilDes + "','SA2') AND" 	+ PULA 
		cQuery += "SA2.A2_COD = SF1.F1_FORNECE AND" 														+ PULA 
		cQuery += "SA2.A2_LOJA = SF1.F1_LOJA AND" 															+ PULA
		cQuery += "SA2.A2_CGC = '" + SM0->M0_CGC + "' AND"												+ PULA 
		cQuery += "SA2.D_E_L_E_T_ = ''" 																	+ PULA
		cQuery += "WHERE" 																					+ PULA
		cQuery += "SF1.F1_FILIAL = dbo.FC_TABMODO('" + cEmpDes + "','" + cFilDes + "','SF1') AND" 	+ PULA
		cQuery += "SF1.F1_DOC = '" + SF2->F2_DOC + "' AND" 												+ PULA 
		cQuery += "SF1.F1_SERIE = '" + SF2->F2_SERIE + "' AND" 											+ PULA 
		cQuery += "SF1.D_E_L_E_T_ = ''"
		
		IF SELECT("TMPSF1") > 0 
			
			DBSELECTAREA("TMPSF1")
			DBCLOSEAREA()
			
		ENDIF
		
		TCQUERY CQUERY NEW ALIAS "TMPSF1"
		DBSELECTAREA("TMPSF1")
		
		IF TMPSF1->(!EOF())
			
			MSGALERT(OEMTOANSI("Nota Fiscal de Transferência já Classificada na Empresa Destino!"),OEMTOANSI("Projeto Avante - FASE II"))
			RETURN(.F.)
			
		ENDIF 
	EndIf
ENDIF

RESTAREA(aAreaSD2)
RESTAREA(aAreaSC5)

/*
|=================================================================================
|	FIM DA VALIDACAO
|=================================================================================
*/

If .NOT. EMPTY(cD2ORDSEP) 
	_lret:=.F.               
	Msgstop("Este documento está associada a uma Ordem de Separação." + ENTER + "Solicite à EXPEDIÇÃO estorno da OS para prosseguir com exclusão!!!" )
EndIf

If CEMPANT + CFILANT = "0302" .and. _lret
	CQUERY := "SELECT DISTINCT " + ENTER 
	CQUERY += "	C9_PEDIDO " + ENTER 
	CQUERY += "	,C9_NUMOF " + ENTER 
	CQUERY += "	,C9_DOCTRF " + ENTER 
	CQUERY += "	,C9_ITEM " + ENTER 
	CQUERY += "	,C9_PRODUTO " + ENTER
	CQUERY += "	,C9_SEQUEN " + ENTER
	CQUERY += "	,C9_ORDSEP " + ENTER
	CQUERY += "	,C9_PEDORI " + ENTER
	CQUERY += "	,C9_CLIORI " + ENTER
	CQUERY += "	,C9_LOJORI " + ENTER
	CQUERY += "	,RTRIM(LTRIM(C9_NOMORI)) AS C9_NOMORI " + ENTER
	CQUERY += "FROM " +RetSqlName("SC9")+ " SC9 " + ENTER 
	CQUERY += "WHERE SC9.D_E_L_E_T_	='' " + ENTER 
	CQUERY += "	AND C9_FILIAL 	= '" + xFilial("SC9") + "'"	+ ENTER
	CQUERY += "	AND C9_NFISCAL 	= '" + SF2->F2_DOC + "'"  	+ ENTER
	CQUERY += "	AND C9_SERIENF 	= '" + SF2->F2_SERIE + "'"  + ENTER
	CQUERY += "	AND C9_CLIENTE 	= '" + SF2->F2_CLIENTE + "'"+ ENTER
	CQUERY += "	AND C9_LOJA		= '" + SF2->F2_LOJA + "'"  	+ ENTER
	//MemoWrite("MS520VLD_ITENS_SC9_VARIAVEL_PUBLICA.SQL",CQUERY)
	
	IF SELECT("MSD25") > 0 
		DBSELECTAREA("MSD25") 
		DBCLOSEAREA()
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "MSD25"
	DBSELECTAREA("MSD25")
	DBGOTOP()
	While !MSD25->(Eof())
		IF .NOT. EMPTY(MSD25->C9_ORDSEP)
			_lret:=.F.              
		ENDIF
		Aadd(aItens,{ MSD25->C9_PEDIDO,MSD25->C9_NUMOF,MSD25->C9_DOCTRF,MSD25->C9_ITEM,MSD25->C9_PRODUTO,MSD25->C9_SEQUEN,MSD25->C9_ORDSEP,MSD25->C9_PEDORI,MSD25->C9_CLIORI,MSD25->C9_LOJORI,MSD25->C9_NOMORI })
		
		MSD25->(DbSkip())
	End

	PUTGLBVARS(CVARGLB,aItens )

	RestArea(aArea)

	IF .NOT. _lret
		Msgstop("Este documento está associada a uma Ordem de Separação." + ENTER + "Solicite à EXPEDIÇÃO estorno da OS para prosseguir com exclusão!!!" )
	ENDIF

EndIf
/* Valida no financeiro o título NCC de Verba */
If _lret

	If SF2->F2_TIPO = "N"
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
					If SE1->E1_TIPO = "NCC" .AND. .NOT. Empty(SE1->E1_BAIXA)
					   _lret := .F.
					EndIf
					SE1->(DbSkip())
				End
			EndIf
			ZA6->(DbSkip())
		End
		If .NOT. _lret
			MsgStop("Para excluir a nota fiscal " + SF2->F2_DOC + " solicite a área financeira o estorno da baixa do título do tipo NCC de verba.")
		EndIf
		SE1->(RestArea(aSE1Alias))
		ZA6->(RestArea(aZA6Alias))		
	EndIf
EndIf
Return(_lret )
