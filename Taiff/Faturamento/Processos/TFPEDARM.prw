#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: TFPEDARM     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 11/04/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Controla o armazem do pedido
//| SOLICITANTE: 
//| OBSERVACAO: rotina que valida o armazem no campo C6_LOCAL parametrizada no configurador no campo Val.Usuário
//+--------------------------------------------------------------------------------------------------------------

User Function TFPEDARM()
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local lRetorna := .T.

If FunName() == "MATA410"
	If M->C6_LOCAL ='02'
		Alert("Armazem não permite movimentação para faturamento!","Inconsistência")
		M->C6_LOCAL := IIf( !Empty(aCols[N][nPLocal]) ,aCols[N][nPLocal],M->C6_LOCAL)
		lRetorna := .F.
	Endif
EndIf

Return (lRetorna)
