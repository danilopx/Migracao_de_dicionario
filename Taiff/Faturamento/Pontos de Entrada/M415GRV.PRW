#Include 'Protheus.ch'

//-------------------------------------------------------------------------------------------------------------------------------
// PONTO DE ENTRADA: M415GRV                                                                                                                      AUTOR: CARLOS TORRES                 DATA: 28/01/2013
// DESCRICAO:  Registrar a unidade de negocio para or�amentos com origem na rotina de or�amentos, para pedidos com origem 
//                                                                          no portal isto n�o � necessario.
//            OBSERVACAO: PE utilizado na rotina MATA415 especificamente no bot�o na inclus�o de or�amento
//-------------------------------------------------------------------------------------------------------------------------------

User Function M415GRV

Local nOpcao := ParamIxb[1]

	If nOpcao=1 .and. !l415Auto//(Empty(SCJ->CJ_EMPDES) .or. Empty(SCJ->CJ_FILDES))
	
		Reclock("SCJ",.F.)
		SCJ->CJ_EMPDES := cEmpAnt 
		SCJ->CJ_FILDES := cFilAnt
		SCJ->(MSunlock())
	                
	EndIf
	
Return NIL
