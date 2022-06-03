#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATAZAH     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 01/04/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: 
//| SOLICITANTE: Marcelo Concenição e R. Brito
//| OBSERVACAO: 
//+--------------------------------------------------------------------------------------------------------------

User Function MATAZAH()
	DbSelectArea("ZAH")
	DbSetOrder(1)
	DbSetFilter( {|| recno() >= 15 }, "recno() >= 15" )  
	
	AxCadastro("ZAH","Usuarios 02-Buffer","U_EXCLZAH()","U_MUDAZAH()")
	
	DbSelectArea("ZAH")
	DBCLEARFILTER()

Return NIL

//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alterção da tabela ZAH
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAH()
Local lRetorno := .T.
If At(  Alltrim(__CUSERID)  , GetNewPar("TF_USERZAH","") ) = 0
	Aviso("Atenção", "Acesso não permitido!" + chr(13) + chr(10) + "A intervenção deve ser realizada pelo Gestor do Almoxarifado." + chr(13) + chr(10) + "Parametro TF_USERZAH",	{"Ok"}, 	3)
	lRetorno	:= .F. 
Else
	If INCLUI
		If ZAH->(DbSeek( xFilial("ZAH") + M->ZAH_IDUSER )) 
			Aviso("Atenção", "Inclusão não realizada!" + chr(13) + chr(10) + "Usuário já cadastrado.",	{"Ok"}, 	3)
			lRetorno	:= .F. 
		EndIf
	EndIf
EndIf
Return lRetorno 

//+--------------------------------------------------------------------------------------------------------------
//| Função Exclusão da tabela ZAH
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAH()
Local lRetorno := .T.
If At(  Alltrim(__CUSERID)  , GetNewPar("TF_USERZAH","") ) = 0
	Aviso("Atenção", "Acesso não permitido!" + chr(13) + chr(10) + "A intervenção deve ser realizada pelo Gestor do Almoxarifado." + chr(13) + chr(10) + "Parametro TF_USERZAH",	{"Ok"}, 	3)
	lRetorno	:= .F. 
EndIf
Return lRetorno