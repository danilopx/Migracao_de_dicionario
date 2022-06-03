#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	M440FIL.prw
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

USER FUNCTION M440FIL()

LOCAL CRET 		:= ""
LOCAL ODLG
LOCAL OSAY01
LOCAL CSAY01		:= "Marca"
LOCAL OSAY02
LOCAL CSAY02		:= "Filial Destino"
LOCAL OSAY03
LOCAL CSAY03		:= "Gerente Vendas"
LOCAL OCMB01
LOCAL OGET02		
LOCAL OGET03
LOCAL OBTN
LOCAL LOK			:= .F.
LOCAL LCANCEL	:= .F.
LOCAL CFILDES		:= CFILANT 
LOCAL CMARCA		:= SPACE(009)
LOCAL CGERENTE	:= SPACE(006)
LOCAL CQUERY		:= ""
LOCAL AMARCAS		:= {"TAIFF","PROART","CORP"}
LOCAL CVENDED		:= ""
LOCAL NREG			:= 0 

IF (CEMPANT + CFILANT) = "0302"
	
	ODLG 	:= MSDIALOG():NEW(001,001,230,300,'Filtro Liberação',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OSAY02 := TSAY():NEW(035,010, {|| CSAY02},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OSAY03 := TSAY():NEW(060,010, {|| CSAY03},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
//			   TCOMBOBOX():NEW( [ NROW ], [ NCOL ]	, [ BSETGET ]									, [ NITENS ]	, [ NWIDTH ]	, [ NHEIGHT ]	, [ OWND ]	, [ UPARAM8 ]	, [ BCHANGE ]	, [ BVALID ]	, [ NCLRBACK ], [ NCLRTEXT ], [ LPIXEL ]	, [ OFONT ]	, [ UPARAM15 ], [ UPARAM16 ], [ BWHEN ]	, [ UPARAM18 ], [ UPARAM19 ], [ UPARAM20 ], [ UPARAM21 ], [ CREADVAR ], [ CLABELTEXT ]	, [ NLABELPOS ]	, [ OLABELFONT ]	, [ NLABELCOLOR ] )
	OCMB01 := TCOMBOBOX():NEW(010		,060		, {|U| IF(PCOUNT()>0,CMARCA:=U,CMARCA)}	,AMARCAS		,060			,009			,ODLG		,				,				,				,				,				,.T.			,				,				,				,				,				,				,				,				,'CMARCA')
	OGET02 := TGET():NEW(035,060,	{|U| IF(PCOUNT()>0,CFILDES:=U,CFILDES)}	,ODLG,017,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'CFILDES',,,, )
	OGET03 := TGET():NEW(060,060,	{|U| IF(PCOUNT()>0,CGERENTE:=U,CGERENTE)}	,ODLG,040,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,'CGERENTE',,,, )
	OBTN 	:= TBUTTON():NEW(090,010,'OK'			,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
	OBTN 	:= TBUTTON():NEW(090,100,'Cancelar'	,ODLG,{|| LCANCEL 	:= .T.,ODLG:END()},40,10,,,,.T.)
	
	OGET03:BF3 := &('{|| IIF(CONPAD1(,,,"SA3LIB",,,.F.),EVAL({|| CGERENTE := SA3->A3_COD,OGET03:REFRESH()}),.T.)}') 
	
	ODLG:ACTIVATE(,,,.T.)
	
	WHILE !LOK .AND. !LCANCEL
	
	ENDDO
	
	IF LOK
		CRET := "C5_XITEMC = '" + CMARCA + "' .AND. C5_FILDES = '" + CFILDES + "' .AND. EMPTY(C5_NOTA) .AND. C5_LIBEROK != 'E' .AND. EMPTY(C5_BLQ) .AND. C5_XLIBCR = 'L'"
		IF !EMPTY(ALLTRIM(CGERENTE))
			CQUERY := "SELECT SA3.A3_COD FROM " + RETSQLNAME("SA3") + " SA3 WHERE SA3.A3_FILIAL = '" + XFILIAL("SA3") + "' AND SA3.A3_GEREN = '" + CGERENTE + "' AND SA3.D_E_L_E_T_ = ''"
			IF SELECT("VEN") > 0 
				DBSELECTAREA("VEN")
				DBCLOSEAREA()
			ENDIF 
			TCQUERY CQUERY NEW ALIAS "VEN"
			DBSELECTAREA("VEN")
			DBGOTOP()
			COUNT TO NREG
			IF NREG > 0 
				DBGOTOP()
				WHILE VEN->(!EOF())
					IF EMPTY(CVENDED)
						CVENDED += '"' + VEN->A3_COD 
					ELSE
						CVENDED += "|" + VEN->A3_COD
					ENDIF
					CVENDED += '"'
					VEN->(DBSKIP())
				ENDDO	
			ENDIF
			IF !EMPTY(CVENDED)
				CRET += " .AND. C5_VEND1 $ ('" + CVENDED + "')"
			ENDIF
		ENDIF 
	ELSEIF LCANCEL 
		CRET := "EMPTY(C5_NOTA) .AND. C5_LIBEROK != 'E' .AND. EMPTY(C5_BLQ) .AND. C5_XLIBCR = 'L'"
	ENDIF
	
ENDIF 

RETURN(CRET)

