#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include 'parmtype.ch'

//---------------------------------------------------------------------------------------------------------//
// Função: MTA650I          Autor: Carlos Alday Torres                              Data: 13/09/2010       //
//---------------------------------------------------------------------------------------------------------//
// Descrição: Ponto de entrada da rotina que inclue OP, cuja finalidade é criar etiquetas na tabela ZA4    //
//            que nascem firmadas                                                                          //
//---------------------------------------------------------------------------------------------------------//

User Function MTA650I
	Reclock("SC2",.F.)
	
		SC2->C2_MOPC := "" //Apaga erros de população de campo de opcionais.
	
	MsUnlock()

If Alltrim(Upper(FunName())) == "MATA650"
	If SC2->C2_TPOP='F'
		U_MA651GRV()
	EndIf
Endif	

Return NIL