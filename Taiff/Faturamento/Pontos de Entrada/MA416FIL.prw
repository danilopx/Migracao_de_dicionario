#Include 'Protheus.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA416FIL  ºAutor  ³Daniel Ruffino      º Data ³  17/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada responsavel por filtrar orçamentos que ja º±±
±±º          ³ estejam liberado o credito.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA416FIL()
Local _cFiltro := ""
Local CMARCA	:= ""
Local CCLASSEPED:= ""
LOCAL AMARCAS		:= {"TAIFF","PROART","AMBAS"}
LOCAL ACLASSES		:= {"OUTRAS","ASTEC"}
LOCAL ODLG
LOCAL OSAY01
LOCAL OSAY02
LOCAL CSAY01		:= "Marca a efetivar"
LOCAL CSAY02		:= "Classes de Pedido"
LOCAL OCMB01
LOCAL OCMB02
LOCAL OBTN
LOCAL LOK			:= .F.
LOCAL LCANCEL		:= .F.

//-----------------------------------------------------------------------------------------------
//Adicionado por Thiago Comelli em 16/10/2012
//Executa somente na empresa e filial selecionados
If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT07",.F.,"")
	_cFiltro := 'CJ_XLIBCR == "L" .AND. CJ_STATUS == "A"'
EndIf

/*
Atribuido à funcionalidade de efeticação de orçamento o filtro da marca informado pelo usuário em 30/09/2016
*/
If CEMPANT = "03"
	ODLG 	:= MSDIALOG():NEW(001,001,170,350,'Filtro da efetivação',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OSAY02 := TSAY():NEW(030,010, {|| CSAY02},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OCMB01 := TCOMBOBOX():NEW(010,060, {|U| IF(PCOUNT()>0,CMARCA:=U,CMARCA)},AMARCAS,060,009,ODLG,,,,,,.T.,,,,,,,,,'CMARCA')
	OCMB02 := TCOMBOBOX():NEW(030,060, {|U| IF(PCOUNT()>0,CCLASSEPED:=U,CCLASSEPED)},ACLASSES,060,009,ODLG,,,,,,.T.,,,,,,,,,'CCLASSEPED')
	OBTN 	:= TBUTTON():NEW(060,010,'OK'			,ODLG,{|| LOK 		:= .T.,ODLG:END()},60,10,,,,.T.)
	OBTN 	:= TBUTTON():NEW(060,100,'Cancelar'	,ODLG,{|| LCANCEL 	:= .T.,ODLG:END()},60,10,,,,.T.)

	ODLG:ACTIVATE(,,,.T.)
	
	WHILE !LOK .AND. !LCANCEL
	
	ENDDO
	
	IF LOK
		If CMARCA != "AMBAS"
			_cFiltro += ' .AND. CJ_XITEMC = "' + CMARCA + '"'
		EndIf
		If CCLASSEPED = "ASTEC"
			_cFiltro += ' .AND. CJ_XCLASPD = "A" '			
		Else
			_cFiltro += ' .AND. CJ_XCLASPD != "A" '			
		EndIf
	EndIf
EndIf

Return(_cFiltro)
