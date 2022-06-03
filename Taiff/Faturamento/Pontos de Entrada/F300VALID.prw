#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//----------------------------------------------------------------------------------------------------------------
// PROGRAMA: F300VALID	                                     AUTOR: CARLOS TORRES                 DATA: 17/04/2012
// DESCRICAO: PE para não gerar a comissao da NCC conforme campo regulamentador da natureza financeira SED
// OBSERVACOES: Este PE é disparado no botão Ok da compensação ANTES da seleção de titulos na rotina "Compensacao Cr" 
//              (FINA330.PRX) no sub-item "Compensar"
//----------------------------------------------------------------------------------------------------------------
User Function F300VALID
Local lRetorno := .T.
Local cNoCarts	:= GetNewPar( "ES_NOCARTS", "2" )

If SE1->E1_TIPO = 'NCC'
	Aviso("Seleção Inválida", "Para compensação de titulos selecione titulos a compensar, não selecione a NCC.", {"Ok"}, 3)
	lRetorno := .F.
EndIf

If (SE1->E1_SITUACA $ cNoCarts) .AND. lRetorno
	Aviso("Seleção Inválida", "A compensação de titulos não é permitida para títulos na situação de carteira igual a " + cNoCarts , {"Ok"}, 3)
	lRetorno := .F.
EndIf

Return (lRetorno)