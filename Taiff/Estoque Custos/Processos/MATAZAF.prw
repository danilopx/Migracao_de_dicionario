#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAF     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 04/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: tabela ZAF determina que s�o usuarios que podem fazer transferencias (MATA260) no armazem
//| SOLICITANTE: Marcelo Conceni��o e R. Brito
//| OBSERVACAO: a tabela ZAG determina os gestores dos armaz�ns, na h� rotina para manuseio desta tabela
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAF()
	AxCadastro("ZAF","Permiss�es de Transfer�ncia","U_EXCLZAF()","U_MUDAZAF()")
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Inclus�o/Alter��o da tabela ZAF
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAF()
Local lRetorno := .T.
	If !ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + M->ZAF_LOCAL ))
		Alert("Operador do sistema n�o � o gestor do armazem, acesso n�o permitido!","Inconsist�ncia")
		lRetorno := .F.
	Else
		M->ZAF_GESUSR := __CUSERID
		M->ZAF_STATUS := "1"
	Endif
Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Exclus�o da tabela ZAF
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAF()
Local lRetorno := .T.
	If !ZAG->(DbSeek( xFilial("ZAG") + __CUSERID + ZAF->ZAF_LOCAL ))
		Alert("Operador do sistema n�o � o gestor do armazem, acesso n�o permitido!","Inconsist�ncia")
		lRetorno := .F.
	EndIf
Return lRetorno