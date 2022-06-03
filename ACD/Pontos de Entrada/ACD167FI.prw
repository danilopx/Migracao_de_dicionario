#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#include "vkey.ch"
#INCLUDE "APVT100.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	ACD167FI.prw
=================================================================================
||   Funcao: 	ACD167FI
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		No final da função, ao finalizar o processamento. 
|| 		Sera utilizado para alteracao do Status do Pedido de Vendas na Empresa 
||	TaiffProart Matriz - Processo CrossDocking 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	30/09/2015
=================================================================================
=================================================================================
*/
USER FUNCTION ACD167FI()

	LOCAL CQUERY := ""
	Local aArea  := GetArea()
	LOCAL nStConfere := 0

	If CEMPANT='03' .AND. CFILANT='02'
	/*
	|---------------------------------------------------------------------------------
	|	Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz
	|---------------------------------------------------------------------------------
	*/
		CQUERY := "UPDATE" 									+ ENTER
		CQUERY += "	SC5" 									+ ENTER
		CQUERY += "SET" 									+ ENTER
		CQUERY += "	C5_STCROSS = 'AGTRAN'" 					+ ENTER
		CQUERY += "FROM" 									+ ENTER
		CQUERY += "	" + RETSQLNAME("SC5") + " SC5"			+ ENTER
		CQUERY += "WHERE" 									+ ENTER
		CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER
		CQUERY += "	C5_NUM = '" + CB7->CB7_PEDORI + "' AND" + ENTER
		CQUERY += "	D_E_L_E_T_ = ''"

		MEMOWRITE("ACD167FI_update_sc5_crossdocking.sql",CQUERY)

		IF TCSQLEXEC(CQUERY) != 0

			MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
				"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))

		ENDIF

		_cNumOld := ""

		Dbselectarea("SC5")
		Dbsetorder(01)
		DbSeek( xFilial("SC5") + CB7->CB7_PEDIDO)

		_cNumOld := SC5->C5_NUMOLD

		IF  ALLTRIM(SC5->C5_XITEMC) == "PROART"
			aTela := VtSave()
			While .T.
				VTCLear()
				_nQTdVol := 0
				@ 0,0 VTSay "Volume " + cVolume
				@ 1,0 VtSay "Informe Peso Bruto:"
				@ 2,0 VtGet _nQTdvol Pict "@E 999,999.99"
				VTRead
				If   VtLastKey() == 27
					IF   _nQtdVol <= 0
						VtAlert("Informar Peso Bruto do Volume","Aviso",.t.,4000,3)
						VtKeyboard(Chr(20))  // zera o get
					Else
						GRVZARPESO(_nQtdVol,cVolume)
						nStConfere := U_IMPVOLUME()
						IF nStConfere = 1
							// IMPRIME PROXIMO VOLUME
							NOVOVOLUME()
						ELSEIF nStConfere = 2
							// ENCERRA CONFERENCIA
							CONFENCERRA()
						ENDIF
						Exit
					ENDIF
				Endif
				IF   _nQtdVol <= 0
					VtAlert("Informar Peso Bruto do Volume","Aviso",.t.,4000,3)
					VtKeyboard(Chr(20))  // zera o get
				Else
					GRVZARPESO(_nQtdVol,cVolume)
					nStConfere := U_IMPVOLUME()
					IF nStConfere = 1
						// IMPRIME PROXIMO VOLUME
						NOVOVOLUME()
					ELSEIF nStConfere = 2
						// ENCERRA CONFERENCIA
						CONFENCERRA()
					ENDIF
					Exit
				Endif
			End
			VtRestore(,,,,aTela)

		ENDIF
	EndIF
	RestArea(aArea)
RETURN

STATIC FUNCTION NOVOVOLUME()
	LOCAL cImp := ""
	LOCAL cCodVol := ""

	cImp := CBRLocImp("MV__IACD01")
	VtRestore(,,,,aTela)
	If ExistBlock('IMG05') .and. CB5SetImp(cImp,.t.)
		cCodVol := CB6->(GetSX8Num("CB6","CB6_VOLUME"))
		ConfirmSX8()
		VTAlert("Imprimindo etiqueta de volume ","Aviso Taiff",.T.,2000) //"Imprimindo etiqueta de volume "###"Aviso"
		ExecBlock("IMG05",.f.,.f.,{cCodVol,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
		MSCBCLOSEPRINTER()

		CB6->(RecLock("CB6",.T.))
		CB6->CB6_FILIAL := xFilial("CB6")
		CB6->CB6_VOLUME := cCodVol
		CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
		CB6->CB6_NOTA   := CB7->CB7_NOTA
		SerieNfId("CB6",1,"CB6_SERIE",,,,CB7->CB7_SERIE)
		CB6->CB6_TIPVOL := "001" // CB3->CB3_CODEMB
		CB6->CB6_STATUS := "1"   // ABERTO
		CB6->(MsUnlock())

	EndIf

RETURN

STATIC FUNCTION CONFENCERRA()
	LOCAL _nTotPesLiq := 0
	LOCAL _nTotPesBru := 0

	Dbselectarea("ZAR")
	Dbsetorder(1)
	Dbseek(xfilial("ZAR") + CB7->CB7_ORDSEP)
	While .not. eof() .and. ZAR->ZAR_ORDSEP = CB7->CB7_ORDSEP
		_nTotPesLiq += ZAR->ZAR_PLIQUI
		_nTotPesBru += ZAR->ZAR_PBRUTO
		Reclock("ZAR",.F.)
		ZAR->ZAR_STATUS := "F"
		Msunlock()
		Dbskip()
	End
	Dbselectarea("SC5")
	Dbsetorder(1)
	If  Dbseek(xfilial("SC5")+CB7->CB7_PEDIDO)
		Reclock("SC5",.F.)
		SC5->C5_PESOL   := _nTotPesLiq
		SC5->C5_PBRUTO  := _nTotPesBru
		SC5->C5_VOLUME1 := CB7->CB7_X_QTVO
		SC5->C5_YSTSEP  := "G"
		Msunlock()
	Endif
RETURN

USER FUNCTION IMPVOLUME()
	LOCAL nRetorno := 0
	LOCAL NTTCAIXAS:= 0
	LOCAL cCDestino:= ""

	SC5->(DBORDERNICKNAME("SC5NUMOLD"))
	If SC5->(DBSEEK(xFilial("SC5") + ZAR->ZAR_PEDIDO))
		cCDestino := ALLTRIM(SC5->C5_FILDES)
	EndIf

	If  CB5->(DbSeek(xFilial("CB5")+ CBRLocImp("MV__IACD01") ))
		If  CB5SetImp(CBRLocImp("MV__IACD01"))
			U_IMG12(ZAR->ZAR_VOLUME,ZAR_PBRUTO,ZAR_CAIXA,CB7->CB7_X_QTVO, cCDestino )
		EndIf
		MSCBCLOSEPRINTER()
	EndIf

	Dbselectarea("ZAR")
	Dbsetorder(01)
	Dbseek(xfilial("ZAR") + CB7->CB7_ORDSEP )
	WHILE .NOT. ZAR->(Eof()) .AND. ZAR->ZAR_ORDSEP = CB7->CB7_ORDSEP
		NTTCAIXAS ++
		ZAR->(DbSkip())
	END
	nRetorno := IIF(NTTCAIXAS = CB7->CB7_X_QTVO,2,1)
RETURN (nRetorno)

STATIC FUNCTION GRVZARPESO(nPeso,cCaixa)
	//GRAVA ZAR - DADOS DA PESAGEM
	_cQuery := "SELECT ISNULL(SUM(CB9_QTEEMB * B1_PESO),0) AS TOTLIQ" + ENTER
	_cQuery += "FROM "+RETSQLNAME("CB9")+" CB9 " 		+ ENTER
	_cQuery += "JOIN "+RETSQLNAME("SB1")+" SB1 ON "     + ENTER
	_cQuery += "CB9_FILIAL = B1_FILIAL AND B1_COD = CB9_PROD AND SB1.D_E_L_E_T_ = ''
	_cQuery += "WHERE CB9_FILIAL = '"+CB7->CB7_FILIAL+"' AND "	+ ENTER
	_cQuery += "CB9_ORDSEP = '"+CB7->CB7_ORDSEP+"' AND "		+ ENTER
	_cQuery += "CB9_VOLUME = '" + cCaixa + "' " + ENTER
	_cQuery += "AND CB9.D_E_L_E_T_ = '' "  + ENTER
	MEMOWRITE("ACD167FI_GRVZARPESO.SQL",_cQuery)

	IF  SELECT("TCB9")
		TCB9->(Dbclosearea())
	ENDIF
	DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TCB9',.F.,.T.)
	Dbselectarea("ZAR")
	Dbsetorder(01)
	IF   Dbseek(xfilial("ZAR") + CB7->CB7_ORDSEP + cCaixa )
		RECLOCK("ZAR",.F.)
		ZAR->ZAR_PLIQUI := TCB9->TOTLIQ
		ZAR->ZAR_PBRUTO := nPeso
		Msunlock()
	ELSE
		Dbselectarea("SC5")
		Dbsetorder(01)
		DbSeek( xFilial("SC5") + CB7->CB7_PEDIDO)

		nCaixa := 0

		_cQuery := "SELECT ISNULL(COUNT(*),0) AS TOTCAIXA  " + ENTER
		_cQuery += "FROM "+RETSQLNAME("ZAR") + " ZAR " + ENTER
		_cQuery += "WHERE ZAR_ORDSEP = '" + CB7->CB7_ORDSEP + "' "+ENTER
		_cQuery += "AND D_E_L_E_T_ = ' ' "
		IF  SELECT("TRB1")
			TRB1->(Dbclosearea())
		ENDIF
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TRB1',.F.,.T.)

		nCaixa := TRB1->TOTCAIXA + 1

		RECLOCK("ZAR",.T.)
		ZAR->ZAR_FILIAL := XFILIAL("ZAR")
		ZAR->ZAR_VOLUME := cCaixa
		ZAR->ZAR_ORDSEP := CB7->CB7_ORDSEP
		ZAR->ZAR_PLIQUI := TCB9->TOTLIQ
		ZAR->ZAR_PBRUTO := nPeso
		ZAR->ZAR_STATUS := "P" //PENDENTE
		ZAR->ZAR_OPERAD := cCodOpe
		ZAR->ZAR_DTPESA := DDATABASE
		ZAR->ZAR_HRPESA := SUBSTR(TIME(), 1, 5)
		ZAR->ZAR_TIPOPS := "2"  //CALCULADO
		ZAR->ZAR_PEDIDO := SC5->C5_NUMOLD
		ZAR->ZAR_CAIXA  := nCaixa
		Msunlock()
	ENDIF
RETURN

//-----
// VERS?O ANTERIOR
//-----
USER FUNCTION OLD_ACD167FI()

	LOCAL CQUERY := ""
	Local aArea  := GetArea()

	If CEMPANT='03' .AND. CFILANT='02'
	/*
	|---------------------------------------------------------------------------------
	|	Altera o Status do Pedido de Vendas na Empresa TaiffProart Matriz
	|---------------------------------------------------------------------------------
	*/
		CQUERY := "UPDATE" 									+ ENTER
		CQUERY += "	SC5" 									+ ENTER
		CQUERY += "SET" 									+ ENTER
		CQUERY += "	C5_STCROSS = 'AGTRAN'" 					+ ENTER
		CQUERY += "FROM" 									+ ENTER
		CQUERY += "	" + RETSQLNAME("SC5") + " SC5"			+ ENTER
		CQUERY += "WHERE" 									+ ENTER
		CQUERY += "	C5_FILIAL = '01' AND" 					+ ENTER
		CQUERY += "	C5_NUM = '" + CB7->CB7_PEDORI + "' AND" + ENTER
		CQUERY += "	D_E_L_E_T_ = ''"

		MEMOWRITE("ACD167FI_update_sc5_crossdocking.sql",CQUERY)

		IF TCSQLEXEC(CQUERY) != 0

			MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas na Matriz!")  + ENTER + ;
				"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))

		ENDIF

		_cNumOld := ""

		Dbselectarea("SC5")
		Dbsetorder(01)
		DbSeek( xFilial("SC5") + CB7->CB7_PEDIDO)

		_cNumOld := SC5->C5_NUMOLD

		IF  ALLTRIM(SC5->C5_XITEMC) == "PROART"

			//GRAVA ZAR - DADOS DA PESAGEM
			_cQuery := "SELECT CB9_ORDSEP,CB9_VOLUME,CB9_CODEMB,ISNULL(SUM(CB9_QTEEMB * B1_PESO),0) AS TOTLIQ,ISNULL(SUM(CB9_QTEEMB * B1_PESBRU),0) AS TOTBRUTO" + ENTER
			_cQuery += "FROM "+RETSQLNAME("CB9")+" CB9 " 		+ ENTER
			_cQuery += "JOIN "+RETSQLNAME("SB1")+" SB1 ON "     + ENTER
			_cQuery += "CB9_FILIAL = B1_FILIAL AND B1_COD = CB9_PROD AND SB1.D_E_L_E_T_ = ''
			_cQuery += "WHERE CB9_FILIAL = '"+CB7->CB7_FILIAL+"' AND "	+ ENTER
			_cQuery += "CB9_ORDSEP = '"+CB7->CB7_ORDSEP+"' AND "		+ ENTER
			_cQuery += "CB9_VOLUME <> ' ' AND CB9.D_E_L_E_T_ = '' "  + ENTER
			_cQuery += "GROUP BY CB9_ORDSEP,CB9_VOLUME,CB9_CODEMB "  + ENTER
			_cQuery += "ORDER BY CB9_ORDSEP,CB9_VOLUME,CB9_CODEMB "  + ENTER

			IF  SELECT("TCB9")
				TCB9->(Dbclosearea())
			ENDIF
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TCB9',.F.,.T.)

			While .not. eof()
				Dbselectarea("ZAR")
				Dbsetorder(01)
				IF   Dbseek(xfilial("ZAR")+TCB9->CB9_ORDSEP+TCB9->CB9_VOLUME)
					RECLOCK("ZAR",.F.)
					REPLACE ZAR_PLIQUI WITH ZAR_PLIQUI + TCB9->TOTLIQ
					REPLACE ZAR_PBRUTO WITH ZAR_PBRUTO + TCB9->TOTBRUTO
					Msunlock()
				ELSE

					nCaixa := 0

					_cQuery := "SELECT ISNULL(COUNT(*),0) AS TOTCAIXA  " + ENTER
					_cQuery += "FROM "+RETSQLNAME("ZAR") + " ZAR " + ENTER
					_cQuery += "WHERE ZAR_ORDSEP = '"+CB7->CB7_ORDSEP+"' "+ENTER
					_cQuery += "AND D_E_L_E_T_ = ' ' "
					IF  SELECT("TRB1")
						TRB1->(Dbclosearea())
					ENDIF
					DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TRB1',.F.,.T.)

					nCaixa := TRB1->TOTCAIXA + 1

					RECLOCK("ZAR",.T.)
					REPLACE ZAR_FILIAL WITH XFILIAL("ZAR")
					REPLACE ZAR_VOLUME WITH TCB9->CB9_VOLUME
					REPLACE ZAR_ORDSEP WITH TCB9->CB9_ORDSEP
					REPLACE ZAR_PLIQUI WITH TCB9->TOTLIQ
					REPLACE ZAR_PBRUTO WITH TCB9->TOTBRUTO
					REPLACE ZAR_STATUS WITH "P" //PENDENTE
					REPLACE ZAR_OPERAD WITH TCB9->CB9_CODEMB
					REPLACE ZAR_DTPESA WITH DDATABASE
					REPLACE ZAR_HRPESA WITH SUBSTR(TIME(), 1, 5)
					REPLACE ZAR_TIPOPS WITH "1"  //CALCULADO
					REPLACE ZAR_PEDIDO WITH _cNumOld
					REPLACE ZAR_CAIXA  WITH nCaixa
					Msunlock()
				ENDIF
				Dbselectarea("TCB9")
				Dbskip()
			END

			Dbselectarea("TCB9")
			Dbclosearea()

			//VERIFICA SE TEM REG. NA ZAR CUJO VOLUME FOI ESTORNADO
			_cQuery := "SELECT * " + ENTER
			_cQuery += "FROM "+RETSQLNAME("ZAR") + " ZAR " + ENTER
			_cQuery += "WHERE ZAR_FILIAL='"+xFILIAL("ZAR")+"' " + ENTER
			_cQuery += "AND ZAR_ORDSEP='"+CB7->CB7_ORDSEP+"' " + ENTER
			_cQuery += "AND 0 = ( " + ENTER
			_cQuery += "       SELECT COUNT(*) "+ENTER
			_cQuery += "       FROM CB9030 CB9 "+ENTER
			_cQuery += "       WHERE CB9_FILIAL=ZAR_FILIAL "+ENTER
			_cQuery += "       AND CB9_ORDSEP=ZAR_ORDSEP "+ENTER
			_cQuery += "       AND CB9_VOLUME=ZAR_VOLUME "+ENTER
			_cQuery += "       AND CB9.D_E_L_E_T_='' "+ENTER
			_cQuery += "             )"+ENTER

			IF  SELECT("TZAR")
				TZAR->(Dbclosearea())
			ENDIF
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TZAR',.F.,.T.)

			_fExcluiu := .F.

			While .not. eof()
				Dbselectarea("ZAR")
				Dbsetorder(01)
				IF   Dbseek(xfilial("ZAR")+TZAR->ZAR_ORDSEP+TZAR->ZAR_VOLUME)
					RECLOCK("ZAR",.F.)
					Dbdelete()
					Msunlock()

					Dbselectarea("CB7")
					Reclock("CB7",.F.)
					Replace CB7_X_QTVO WITH CB7_X_QTVO - 1
					Msunlock()
					_fExcluiu := .T.
					If CB7_X_QTVO < 0
						Reclock("CB7",.F.)
						Replace CB7_X_QTVO WITH 0
						Msunlock()
					EndIf
				ENDIF
				Dbselectarea("TZAR")
				Dbskip()
			END
			IF  _fExcluiu  //refaz a numeracao das caixas
				_nCaixa := 1
				Dbselectarea("ZAR")
				Dbsetorder(1)
				Dbseek(xfilial("ZAR")+CB7->CB7_ORDSEP)
				While .not. eof() .and. ZAR->ZAR_ORDSEP == CB7->CB7_ORDSEP
					Reclock("ZAR",.F.)
					Replace ZAR_CAIXA WITH _nCaixa
					Msunlock()
					_nCaixa++
					Dbskip()
				END
			ENDIF
		ENDIF
	EndIF
	RestArea(aArea)
RETURN
