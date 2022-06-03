#INCLUDE "Protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "FWMVCDEF.CH"
//---------------------------------------------------------------------------------------------------------------------------
// Programa: MA080MNU 																					Autor: C. Torres        Data: 09/09/2011 
// Descricao: PE de ação na rotina do cadastro de TES
// Observação: Em 24/10/2012 foi liberado acesso para manutenção da TES por orientação da Marta Alves, foi mantida a regra 
//					de exclusão.
//---------------------------------------------------------------------------------------------------------------------------
User Function MA080MNU

Local _cTesUsers	:= GetNewPar( "TF_USERTES", "000605|000703" )
Local aRotina := ParamIxb[1]

	/*
	If SM0->M0_CODIGO != '01'
		aRotina[3,2] := "U_VLD080()"
		aRotina[4,2] := "U_VLD080()"
		aRotina[5,2] := "U_VLD080()"
		aRotina[6,2] := "U_VLD080()"
	EndIf
	If SM0->M0_CODIGO = '01'
		aRotina[5,2] := "U_Excl080()"
	EndIf
	*/

/*
|---------------------------------------------------------------------------------
|	Incluido a variavel L080AUTO para que nao haja bloqueio na Replica de 
|	Cadastros. Incluido a funcao FUNNAME para somente ser utilizado se estiver
|	sendo chamado dentro do MATA080
|
|	Edson Hornberger - 31/07/2014
|---------------------------------------------------------------------------------
*/
If FUNNAME() != "MATA080"
	
	RETURN NIL 
	
ENDIF

If CEMPANT != '01' .AND. !L080AUTO
	aRotina[3,2] := "U_VLD080('I')"  // botão inclusão
EndIf
If .NOT. Alltrim(__CUSERID) $ _cTesUsers
	aRotina[4,2] := "U_VLD080('A')" // botão alteração
EndIf


aRotina[5,2] := "U_Excl080()" // botão exclusão


Return aRotina

//---------------------------------------------------------------------------------------------------------------------------
User Function VLD080( cOpcaoIA )
Local _nPosID	:= 2
Local _cTexto	:= "" 
Local _cTesUsers	:= GetNewPar( "TF_USERTES", "000605|000703" )

If cOpcaoIA = "A"

	While Len(Alltrim(Substr(_cTesUsers, _nPosID , 6 ))) > 0
		If !Empty( _cTexto )
			_cTexto	+= ", "
		EndIf
		_cTexto	+= Alltrim( UsrFullName( Substr(_cTesUsers, _nPosID , 6 )  ) )
		_nPosID += 7
	End
   If !Empty( _cTexto )
		Aviso("Acesso não disponivel", "Acesso não disponivel para a empresa selecionada."+chr(10)+"Acesso permitido apenas: " + _cTexto, {"Ok"}, 3)
	Else
		Aviso("Acesso não disponivel", "Acesso não disponivel para a empresa selecionada."+chr(10)+"Acesso permitido apenas para gestor de área.", {"Ok"}, 3)
	EndIf
ElseIf cOpcaoIA="I" 
	Aviso("Acesso não disponivel", "Acesso não disponivel para a empresa selecionada."+chr(10)+"Utilize a empresa DAIHATSU para inclusão de TES", {"Ok"}, 3)
EndIf

Return NIL

//---------------------------------------------------------------------------------------------------------------------------
User Function EXCL080()
	Aviso("Acesso não disponivel", "Exclusao nao permitida."+chr(10)+"Utilize o recurso de Bloqueio de TES.", {"Ok"}, 3)
Return NIL
