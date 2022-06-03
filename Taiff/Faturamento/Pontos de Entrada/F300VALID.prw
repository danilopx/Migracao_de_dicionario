#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//----------------------------------------------------------------------------------------------------------------
// PROGRAMA: F300VALID	                                     AUTOR: CARLOS TORRES                 DATA: 17/04/2012
// DESCRICAO: PE para n�o gerar a comissao da NCC conforme campo regulamentador da natureza financeira SED
// OBSERVACOES: Este PE � disparado no bot�o Ok da compensa��o ANTES da sele��o de titulos na rotina "Compensacao Cr" 
//              (FINA330.PRX) no sub-item "Compensar"
//----------------------------------------------------------------------------------------------------------------
User Function F300VALID
Local lRetorno := .T.
Local cNoCarts	:= GetNewPar( "ES_NOCARTS", "2" )

If SE1->E1_TIPO = 'NCC'
	Aviso("Sele��o Inv�lida", "Para compensa��o de titulos selecione titulos a compensar, n�o selecione a NCC.", {"Ok"}, 3)
	lRetorno := .F.
EndIf

If (SE1->E1_SITUACA $ cNoCarts) .AND. lRetorno
	Aviso("Sele��o Inv�lida", "A compensa��o de titulos n�o � permitida para t�tulos na situa��o de carteira igual a " + cNoCarts , {"Ok"}, 3)
	lRetorno := .F.
EndIf

Return (lRetorno)