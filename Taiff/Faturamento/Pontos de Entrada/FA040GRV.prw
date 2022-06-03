#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: FA040GRV	                                     AUTOR: CARLOS TORRES                 DATA: 08/07/2011
// DESCRICAO: PE para não gerar a comissao da NCC conforme campo regulamentador
// OBSERVACOES: 
//            	 
//--------------------------------------------------------------------------------------------------------------
User Function FA040GRV()  
If SED->(FieldPos("ED_NCCCOMI")) != 0 
	If SE1->E1_TIPO='NCC' .and. SED->ED_NCCCOMI='S' .and. INCLUI
		SE1->(RecLock("SE1",.F.))
		SE1->E1_VEND1 := Space(06)
		SE1->E1_VEND2 := Space(06)
		SE1->E1_VEND3 := Space(06)
		SE1->E1_VEND4 := Space(06)
		SE1->E1_VEND5 := Space(06)
		SE1->E1_COMIS1:= 0
		SE1->E1_COMIS2:= 0
		SE1->E1_COMIS3:= 0
		SE1->E1_COMIS4:= 0
		SE1->E1_COMIS5:= 0
		SE1->(MsUnLock())		
	EndIf
EndIf
Return NIL