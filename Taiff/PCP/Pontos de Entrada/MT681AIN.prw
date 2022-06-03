#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"


User Function MT681AIN()

Local _cQuery  := ""
Local _xAlias	:= GetArea()

//MsgAlert("Na rotina","MT681AIN")

_cQuery := "UPDATE TOP("+Alltrim(Str(SH6->H6_QTDPROD))+") " + RetSqlName("ZA4") + " " 
_cQuery += "	SET ZA4_APONTA = 'S' "
_cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
_cQuery += "   AND D_E_L_E_T_ != '*' "    
_cQuery += "   AND ZA4_COD = '" + Alltrim(SH6->H6_PRODUTO) + "' "
_cQuery += "   AND ZA4_NLOTE = '" + Alltrim(SH6->H6_LOTECTL) + "' "
_cQuery += "   AND RIGHT(ZA4_DTFAB,4) = '" + Strzero(Year(dDataBase),4) + "'" // ZA4_DTFAB campo tipo caracter formato de gravacao 04/10/2010
_cQuery += "   AND (ZA4_APONTA = ' ' OR ZA4_APONTA = 'N') "
	
TCSQLExec( _cQuery )    

RestArea(_xAlias)
Return NIL