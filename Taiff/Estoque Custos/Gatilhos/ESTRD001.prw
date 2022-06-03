// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ESTRD001.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 08/09/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/* {Protheus.doc} ESTRD001
	Processa a tabela SB1-Descricao Generica do Produto.

	@author    pbindo
	@version   11.3.2.201607211753
	@since     08/09/2016
*/
//------------------------------------------------------------------------------------------
user function ESTRD001()
	Local cCampo	:= AllTrim(ReadVar())
	Local cValor	:= AllTrim(&cCampo)
	Local aArea		:= GetArea()

	cQuery := " SELECT * FROM "+RetSqlName("SB1")
	cQuery += " WHERE "
	If cCampo == "M->B1_CODBAR"
		cQuery += " B1_CODBAR = '"+cValor+"'" 
	Else
		cQuery += " B1_EAN14 = '"+cValor+"'"
	EndIf
	cQuery += " AND D_E_L_E_T_ <> '*'"
	cQuery += " AND LEFT(B1_COD,9) <> '"+LEFT(M->B1_COD,9)+"'

	MemoWrite("ESTRD001.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBB1",.T.,.T.)

	Count To nCount	

	If nCount >0 
		dbGoTop()
		MsgStop("Codigo de barras já utilizado no produto "+TRBB1->B1_COD+" Operacao nao permitida","ESTRD001")
		TRBB1->(dbCloseArea())
		RestArea(aArea)	
		Return(Space(TamSX3("B1_CODBAR")[1]))
	EndIf

	TRBB1->(dbCloseArea())
	RestArea(aArea)	
return(cValor)
