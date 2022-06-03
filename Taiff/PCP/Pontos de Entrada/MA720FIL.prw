// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CFIL720.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 11/07/2016 | pbindo            | Gerado com aux�lio do Assistente de C�digo do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} CFIL720
Processa a tabela SC2-Ordens de Producao.

@author    pbindo
@version   11.3.1.201605301307
@since     11/07/2016
/*/
//------------------------------------------------------------------------------------------
user function MA720FIL()
Local cFil720:= ParamIXB

MsgAlert("Ops com fornecedor amarrado n�o aparece nesta rotina, pois existem rastreabilidades que n�o podem ser apagadas","CFIL720")

cFil720 := 'Empty(C2__FORNECE)'


Return (cFil720)