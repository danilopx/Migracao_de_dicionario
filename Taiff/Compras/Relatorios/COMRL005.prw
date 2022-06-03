#INCLUDE "protheus.ch"
#INCLUDE "AP5MAIL.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE CRLF ( chr(13)+chr(10) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRL005  บAutor  ณMicrosiga           บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณENVIA CARTEIRA DE PEDIDO DE COMPRAS AOS COMPRADORES         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COMRL005()

	Local nXz := 0
	Private lWeb := .F.

//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "04" FILIAL "02" MODULO "COM"
	EndIf



	For nXz :=1 To 2
		If lWeb
			dDataBase := Date()
			CORL05GERA()
			If nXz == 2
				RESET ENVIRONMENT
			EndIf
		Else
			If MsgYesNo("Esta rotina irแ enviar e-mail de Pedidos de Compras ao compradores, deseja continuar?")
				Processa( {|| CORL05GERA()() } )
				MsgInfo("Opera็ใo Finalizada!")
			EndIf
		EndIf
	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRL005  บAutor  ณMicrosiga           บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CORL05GERA()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//Local nTamLin
	Local cLin
	//Local cCpo
	//Local cError := ""
	Local n := 0

	Private cEmailAdm 	:=""// GETMV("MV_WFADMIN")
	Private cString := "TRB"
	Private cArqTxt := "\spool\MATR120.CSV"
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"

	cMsg  := "Em anexo, segue a Rela็ใo de Pedidos de Compras em aberto." + CRLF
	cMsg  += CRLF
	cMsg  += "PARยMETROS" + CRLF
	cMsg  += "Tipo    : Pedidos em aberto" + CRLF
	cMsg  += "Entrega : menor ou igual a " +DTOC(DDATABASE)+CRLF


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	cQuery := " SELECT C7_FILENT,C7_FORNECE,A2_NREDUZ, C7_NUM, C7_EMISSAO, C7_ITEM,  C7_PRODUTO, C7_DESCRI, C7_DATPRF, C7_QUANT, C7_PRECO,
	cQuery += " C7_TOTAL+C7_VALIPI C7_TOTAL, C7_QUJE, C7_QUANT-C7_QUJE QKJ_QTPEN, (C7_QUANT-C7_QUJE)*C7_PRECO E1_SALDO,
	cQuery += " Y1_NOME, Y1_EMAIL, C7_OBS, C7_CONAPRO,

//DIAS ATRASO
	cQuery += " CASE WHEN  DATEDIFF(DAY,C7_DATPRF,'"+Dtos(dDatabase)+"')<= 0 THEN 0
	cQuery += " ELSE DATEDIFF(DAY,C7_DATPRF,'"+Dtos(dDatabase)+"')
	cQuery += " END  AC2_DIALIM,

//SALDO ATUAL
	cQuery += " (SELECT (B2_QATU-B2_RESERVA-B2_QPEDVEN) FROM "+RetSQLName("SB2")+" WITH(NOLOCK) WHERE B2_FILIAL = C7_FILIAL AND B2_COD = C7_PRODUTO AND B2_LOCAL = C7_LOCAL AND D_E_L_E_T_ <> '*') B2_QATU,

//INVENTARIO
	cQuery += " ISNULL(ROUND((SELECT (B2_QATU-B2_RESERVA-B2_QPEDVEN-B2_QEMP)/
	cQuery += " CASE WHEN B3_MEDIA = 0 THEN 1
	cQuery += " ELSE
	cQuery += " B3_MEDIA/22
	cQuery += " END
	cQuery += " FROM "+RetSQLName("SB2")+" B2 WITH(NOLOCK)
	cQuery += " INNER JOIN "+RetSQLName("SB3")+" B3 WITH(NOLOCK) ON B3_FILIAL = B2_FILIAL AND B3_COD = B2_COD
	cQuery += " WHERE B2_FILIAL = C7_FILIAL AND B2_COD = C7_PRODUTO AND B2_LOCAL = C7_LOCAL AND B2.D_E_L_E_T_ <> '*' AND  B3.D_E_L_E_T_ <> '*'),0),0) INVENTARIO


	cQuery += " FROM "+RetSQLName("SC7")+" C7 WITH(NOLOCK)
	cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 WITH(NOLOCK) ON C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C7_PRODUTO AND B1_FILIAL = C7_FILIAL
	cQuery += " INNER JOIN "+RetSQLName("SY1")+" Y1 WITH(NOLOCK) ON B1_GRUPCOM = Y1_GRUPCOM
	cQuery += " WHERE  C7_RESIDUO = ' ' AND C7_QUANT-C7_QUJE > 0  AND C7_TIPO = 1  AND C7.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'
	cQuery += " AND Y1.D_E_L_E_T_ <> '*'
	cQuery += " AND C7_FILIAL = '"+cFilAnt+"'"
	cQuery += " ORDER BY Y1_NOME,A2_NREDUZ,C7_DATPRF,C7_NUM,C7_ITEM


	MEMOWRITE("COMRL005.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)


	Count To nCount

	If nCount == 0
		If !lWeb
			MsgStop("Nใo foram encontrados dados!","Aten็ใo - COMRL005")
		Else
			Conout("Nใo foram encontrados dados!","Aten็ใo - COMRL005")
		EndIf
		TRB->(dbCloseArea())
		FErase(cAnexo)
		Return
	EndIf

	For n := 1 to FCount()
		aTam := TamSX3(FieldName(n))
		If !Empty(aTam) .and. aTam[3] $ "N/D"
			TCSETFIELD(cString,FieldName(n),aTam[3],aTam[1],aTam[2])
		EndIf
	Next

	dbSelectArea("TRB")
	dbGoTop()
	cComprador := ""
	cEmail 	   := ""

	If !EOF()
		cLin    := ''
		For n := 1 to FCount()
			If FieldName(n) == "INVENTARIO"
				cLin += FieldName(n)
			Else
				cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
			EndIf
			IF n == FCount()
				//cLin += " Pendente"
				cLin += cEOL
			Else
				cLin += ';'
			EndIf
		Next
	EndIf
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	While !EOF()

		If cComprador <> TRB->Y1_NOME .And. !Empty(cComprador)  .And. nXz == 1
			fClose(nHdl)
			cAnexo    	:= cArqTxt
			mCorpo  	:= cMsg
			Conout("Envio email para o Comprador "+cComprador,"COMRL005")
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela็ใo de Pedidos de Compras em Aberto' + DTOC(DDATABASE)	,cAnexo)
			FErase(cAnexo)
			nHdl    := fCreate(cArqTxt)
			If !EOF()
				cLin    := ''
				For n := 1 to FCount()

					If FieldName(n) == "INVENTARIO"
						cLin += FieldName(n)
					Else
						cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
					EndIf

					IF n == FCount()
						//cLin += " Pendente"
						cLin += cEOL
					Else
						cLin += ';'
					EndIf
				Next

				If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
					ConOut("Ocorreu um erro na gravacao do arquivo.")
					dbCloseArea()
					fClose(nHdl)
					Return
				Endif
			EndIf

		EndIf



		cLin    := ''
		For n := 1 to FCount()
			If FieldName(n) == "INVENTARIO"
				cLin += AllTrim(Transform(FieldGet(n),PesqPict("SD2","D2_QUANT")))
			Else
				cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
			EndIf
			cLin += IIF(n == FCount(),cEOL,';')
		Next


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRB->(dbCloseArea())
			fClose(nHdl)
			Return
		Endif
		cComprador := TRB->Y1_NOME
		cEmail 	   := TRB->Y1_EMAIL
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	fClose(nHdl)
	cAnexo    	:= cArqTxt
	mCorpo  	:= cMsg
	If  nXz == 1
		Conout("Envio email para o Comprador "+cComprador,"COMRL005")
		U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela็ใo de Pedidos de Compras em Aberto' + DTOC(DDATABASE)	,cAnexo)
	Else
		Conout("Envio email de todas as SCs","COMRL006")
		U_2EnvMail('pedidos@actionmotors.com.br','leonardo.lima@taiff.com.br;rubens.brambilla@taiff.com.br'	,'',mCorpo	,'Segue Rela็ใo completa de Pedidos de Compras em Aberto ' + DTOC(DDATABASE)	,cAnexo)
	EndIf

	FErase(cAnexo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TRB->(dbCloseArea())

Return
