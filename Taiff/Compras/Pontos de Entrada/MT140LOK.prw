#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

//---------------------------------------------------------------------------------------------------------------------------
// Programa.: MT140LOK 																					Autor: C. Torres        Data: 01/03/2012 
// Descricao: PE para validar o conteudo do campo nota fiscal de origem ao digitar a pre-nota quando se trata de uma devolução
// Observação: Rotina principal mata140.prx 
//---------------------------------------------------------------------------------------------------------------------------
User Function MT140LOK()
Local lRetorno	:= ParamIXB[1]
Local _cNfOrig	:= aCols[n][GDFieldPos("D1_NFORI")]  
Local _cSrOrig	:= aCols[n][GDFieldPos("D1_SERIORI")]
//Local _cItOrig	:= aCols[n][GDFieldPos("D1_ITEMORI")]
Local _cMens01	:= "Preencha os campos obrigatórios para nota fiscal de devolução: "
Local _cMens02	:= "Nota fiscal, serie e item de origem."

If cTipo = "D" .and. (Empty( _cNfOrig ) .OR. Empty( _cSrOrig )) .and. lRetorno //.OR. EmptY( _cItOrig ))
	Aviso("Atenção", _cMens01 + chr(13) + chr(10) + _cMens02 ,	{"Ok"}, 	3)
	lRetorno	:= .F.
EndIf

Return (lRetorno)
