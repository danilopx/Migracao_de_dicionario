#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAF     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 04/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: tabela ZAF determina que são usuarios que podem fazer transferencias (MATA260) no armazem
//| SOLICITANTE: Marcelo Concenição e R. Brito
//| OBSERVACAO: a tabela ZAG determina os gestores dos armazéns, na há rotina para manuseio desta tabela
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAF()
	AxCadastro("ZAF","Permissões de Transferência","U_EXCLZAF()","U_MUDAZAF()")
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alterção da tabela ZAF
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAF()
Local lRetorno := .T.
	If !ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + M->ZAF_LOCAL ))
		Alert("Operador do sistema não é o gestor do armazem, acesso não permitido!","Inconsistência")
		lRetorno := .F.
	Else
		M->ZAF_GESUSR := __CUSERID
		M->ZAF_STATUS := "1"
	Endif
Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Função Exclusão da tabela ZAF
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAF()
Local lRetorno := .T.
	If !ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + ZAF->ZAF_LOCAL ))
		Alert("Operador do sistema não é o gestor do armazem, acesso não permitido!","Inconsistência")
		lRetorno := .F.
	EndIf
Return lRetorno