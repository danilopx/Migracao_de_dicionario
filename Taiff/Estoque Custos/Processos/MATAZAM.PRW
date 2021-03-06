#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAM     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 22/11/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para gerenciar a tabela ZAM 
//| OBSERVACAO: Nesta tabela s�o cadastrados os gestores da rotina Movimento Interno Mod. II
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAM()
	AxCadastro("ZAM","Gestor Mov Interno","U_EXCLZAM()","U_MUDAZAM()")
Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Inclus�o/Alter��o da tabela ZAM
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAM()
Local lRetorno		:= .F. 
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
		Aviso("Inconsist�ncia", "Senha inv�lida, opera��o n�o finalizada!" + chr(13) + chr(10) + "Verifique parametro MV_SENHZAG.",	{"Ok"}, 	3)
	EndIf
EndIf
If INCLUI
	M->ZAM_OPERAC := '1'
	ZAM->(DbSetOrder(1))
	If ZAM->(DbSeek( xFilial("ZAM") + M->ZAM_GESTOR ))
		lRetorno := .F.
		Aviso("Inconsist�ncia", "Inclus�o n�o permitida!" + chr(13) + chr(10) + "Gestor j� cadastrado.",	{"Ok"}, 	3)
	EndIf
Endif
If ALTERA
	If ZAM->ZAM_OPERAC != '1'
		lRetorno := .F.
		Aviso("Inconsist�ncia", "Altera��o n�o permitida!" + chr(13) + chr(10) + "Origem do cadastro n�o corresponde.",	{"Ok"}, 	3)
	EndIf
EndIf
Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Fun��o Exclus�o da tabela ZAM
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAM()
Local lRetorno := .F.
	Aviso("Inconsist�ncia", "Exclus�o n�o permitida!" + chr(13) + chr(10) + "Preencha o campo validade.",	{"Ok"}, 	3)
Return lRetorno 
