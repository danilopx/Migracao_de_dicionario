#INCLUDE "rwmake.ch"
#DEFINE ENTER Chr(13)+Chr(10)

// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPRD001
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor PAULO BINDO | Descricao VALIDA SE O NUMERO DE LOTE JA FOI DIGITADO NA BAIXA DA OP MOD2
// ---------+-------------------+-----------------------------------------------------------
// 23/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------


user function PCPRD001()

Local cLote  := &(ReadVar())
Local aArea	 := GetArea()

cLote := StrZero(Val(cLote),5)

//VERIFICA SE JA EXISTE UM PEDIDO GERADO COM O MESMO CODIGO DE PEDIDO DO CLIENTE
cQuery := " SELECT TOP 1 H6__LOTEIN, H6_OP FROM "+RetSqlName('SH6')+" "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND H6_FILIAL = '"+cFilAnt+"'"
cQuery += " AND H6_OP <> '"+M->H6_OP+"'"
cQuery += " AND H6__LOTEIN = '"+cLote+"'
cQuery += " ORDER BY H6_OP DESC"

MEMOWRITE("PCPRD001.SQL", cQuery )
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBRD01', .F., .T.)

Count To nRec
dbSelectArea("TRBRD01")
dbGoTop()
If nRec > 0
	cMensText := " Este número de lote "+Alltrim(cLote)+ENTER
	cMensText += " Jà foi utilizada na OP "+TRBRD01->H6_OP+ENTER
	cMensText += "Deseja Prosseguir?"
	If !MsgYesNo(cMensText,"PCPRD001")
		TRBRD01->(dbCloseArea())
		RestArea(aArea)
		Return(Space(10))
	EndIf
EndIf
TRBRD01->(dbCloseArea())
	


RestArea(aArea)
return(cLote)

