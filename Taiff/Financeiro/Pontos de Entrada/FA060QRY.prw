#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

USER FUNCTION FA060QRY()
	Local cSql := ""
/*
	Customização: TOTVS - Jorge                            
	Merge.......: TAIFF - C. Torres                          Data: 14/10/2013
*/
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
Local cUniNeg 	:= Space(TAMSX3("E1_ITEMC")[1]) 			// -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
Local cQRY		:=''

If lUniNeg
	
	@00,00 TO 125,300 DIALOG oDlg TITLE " Seleciona Unidade de Negocio "
	
	@ 10,15 say "Unidade de Negocio : "
	@ 10,60 Get cUniNeg SIZE 22,10 PICTURE "@!" F3 "CTD" Valid ExistCpo("CTD",cUniNeg,1)
	
	@ 45,070 BMPBUTTON TYPE 01 ACTION CLOSE(oDlg)
	//@ 45,110 BMPBUTTON TYPE 02 ACTION CLOSE(oDlg)
	Activate Dialog oDlg centered
	
	cQRY += "E1_ITEMC = '"+cUniNeg+ "'"
	
EndIf
/*
	Fim Customização TOTVS - Jorge
*/

	cSql := " EXISTS "
	cSql += "( "
	cSql += "  SELECT 'X' "
	cSql += "  FROM " + RetSQLName("SA1") + " AUX1 "
	cSql += "  WHERE "
	cSql += "    AUX1.D_E_L_E_T_ = ' ' "
	cSql += "    AND AUX1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cSql += "    AND AUX1.A1_BCO1  != '999' "
	cSql += "    AND AUX1.A1_COD  = SE1.E1_CLIENTE "
	cSql += "    AND AUX1.A1_LOJA = SE1.E1_LOJA "
	cSql += ") "
	If !Empty(cQRY)
		cSql += " AND "
		cSql += cQRY		
	EndIf
Return (cSql)