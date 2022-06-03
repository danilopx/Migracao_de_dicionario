#Include 'Protheus.ch'

//-------------------------------------------------------------------------------------------------------------------------------
// PONTO DE ENTRADA: M415GRV                                                                                                                      AUTOR: CARLOS TORRES                 DATA: 28/01/2013
// DESCRICAO:  Registrar a unidade de negocio para orçamentos com origem na rotina de orçamentos, para pedidos com origem 
//                                                                          no portal isto não é necessario.
//            OBSERVACAO: PE utilizado na rotina MATA415 especificamente no botão na inclusão de orçamento
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
