#Include "Protheus.ch"
#Include "topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: QNC040BUT     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 27/01/2012   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para adicionar botão na rotina de controle de não-conformidade rotina QNCA040.PRW
//+--------------------------------------------------------------------------------------------------------------
User Function QNC040BUT()
Local aRotina := {}
	aAdd(aRotina, { "Ficha Custom." , "U_TFQNCR050()" , 0 , 6,,.F.} )  // "Imprime Ficha customizada"
Return (aRotina)
