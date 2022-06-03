#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAG     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 04/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: tabela ZAF determina que são usuarios que podem fazer transferencias (MATA260) no armazem
//| SOLICITANTE: Marcelo Concenição e R. Brito
//| OBSERVACAO: a tabela ZAG determina os gestores dos armazéns, na há rotina para manuseio desta tabela
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAG()
	AxCadastro("ZAG","Gestor do Armazem","U_EXCLZAG()","U_MUDAZAG()")
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alteração da tabela ZAG
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAG()
Local lRetorno := .F.
Local aParamBox	:= {}
Local aRet			:= {}
Local cSenhPadrao := GETNEWPAR("MV_SENHZAG","123456")

Private cCadastro := "Senha de acesso"
Private cString := ""
Aadd(aParamBox,{8,"Senha: "	,Space(06),"","","","",50,.T.})

IF ParamBox(aParamBox,"Informe senha para registro",@aRet)
	If !empty( aRet[1] ) .and. aRet[1]=cSenhPadrao
		lRetorno := .T.
	Else
		Alert("Senha inválida, operação não finalizada! (MV_SENHZAG)","Inconsistência")
	EndIf
EndIf

Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Função Exclusão da tabela ZAG
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAG()
Local lRetorno := .F.
Local aParamBox	:= {}
Local aRet			:= {}
Local cSenhPadrao := GETNEWPAR("MV_SENHZAG","123456")

Private cCadastro := "Senha de acesso"
Private cString := ""
Aadd(aParamBox,{8,"Senha: "	,Space(06),"","","","",50,.T.})

IF ParamBox(aParamBox,"Informe senha para registro",@aRet)
	If !empty( aRet[1] ) .and. aRet[1]=cSenhPadrao
		lRetorno := .T.
	Else
		Alert("Senha inválida, operação não finalizada! (MV_SENHZAG)","Inconsistência")
	EndIf
EndIf
Return lRetorno