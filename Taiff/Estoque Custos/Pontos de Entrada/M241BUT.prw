#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//--------------------------------------------------------------------------------------------------------------
// FUNCAO: M241BUT                                        AUTOR: CARLOS TORRES                 DATA: 19/10/2011
// DESCRICAO: PE para ativar botoes na rotina MATA241 - Movimentos Internos
//--------------------------------------------------------------------------------------------------------------

User Function M241BUT()
Local aButtons:={}

Aadd(aButtons , {'CARGA',{||U_TFCARPV()}, 'Carrega PV '})

Return(aButtons)
