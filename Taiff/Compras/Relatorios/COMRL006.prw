#INCLUDE "protheus.ch"
#INCLUDE "AP5MAIL.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE CRLF ( chr(13)+chr(10) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRL006  บAutor  ณMicrosiga           บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRELACAO DE SOLICITACAO DE COMPRAS EM ABERTO                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COMRL006()

	Local nXz  := 0
	Private lWeb := .F.


//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "04" FILIAL "02" MODULO "COM"
	EndIf

//GRAVA DADOS DA ROTINA UTILIZADA
//U_CFGRD001("COMRL006")

	For nXz :=1 To 2
		If lWeb
			dDataBase := Date()
			CORL06GERA()
			If nXz == 2
				RESET ENVIRONMENT
			EndIf
		Else
			If MsgYesNo("Esta rotina irแ enviar e-mail ao compradores, deseja continuar?")
				Processa( {|| CORL06GERA() } )
				MsgInfo("Opera็ใo Finalizada!")
			EndIf
		EndIf
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMRL006  บAutor  ณMicrosiga           บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CORL06GERA()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//Local nTamLin
	Local cLin
	//Local cCpo
	//Local cError := ""
	Local n := 0

	Private cEmailAdm 	:= GETMV("MV_WFADMIN")
	Private cString := "TRB"
	Private cArqTxt := "\SYSTEM\MATR110.CSV"
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"

	cMsg  := "Em anexo, segue a Rela็ใo de Solicita็ใo de Compras em aberto." + CRLF
	cMsg  += CRLF
	cMsg  += "PARยMETROS" + CRLF
	cMsg  += "Tipo    : Solicita็๕es em aberto" + CRLF
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

	cQuery := " SELECT C1_FILIAL,C1_NUM, C1_SOLICIT, C1_ITEM, C1_PRODUTO, C1_DESCRI, C1_QUANT, C1_QUJE, C1_DATPRF, C1_EMISSAO, C1_LOCAL,"
	cQuery += "  C1_OBS, Y1_EMAIL, Y1_NOME"
	cQuery += " FROM "+RetSqlName("SC1")+" C1 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SY1")+" Y1 WITH(NOLOCK) ON C1_GRUPCOM = Y1_GRUPCOM"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = C1_PRODUTO"
	cQuery += " WHERE C1.D_E_L_E_T_ <> '*' AND  Y1.D_E_L_E_T_ <> '*'"
	cQuery += " AND C1_OBS NOT IN('CANCELADO PELO SISTEMA.') "
	cQuery += " AND (( C1_QUANT > C1_QUJE AND C1_COTACAO = '' ) "
	cQuery += " OR ( C1_QUANT > C1_QUJE AND C1_COTACAO <> '' ))    "
	cQuery += " AND C1_TPOP <> 'P' AND C1_RESIDUO = ''"
	cQuery += "   ORDER BY Y1_EMAIL,C1_FILIAL, Y1_NOME,C1_EMISSAO, C1_PRODUTO   "

	MEMOWRITE("COMRL006.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nRec

	Count To nCount

	If nCount == 0
		If !lWeb
			MsgStop("Nใo foram encontrados dados!","Aten็ใo - COMRL006")
		Else
			Conout("Nใo foram encontrados dados!","Aten็ใo - COMRL006")
		EndIf
		TRB->(dbCloseArea())
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
			cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
			IF n == FCount()
				cLin += " Pendente"
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

		If cComprador <> TRB->Y1_NOME .And. !Empty(cComprador) .And. nXz == 1
			fClose(nHdl)
			cAnexo    	:= cArqTxt
			mCorpo  	:= cMsg
			Conout("Envio email para o Comprador "+cComprador,"COMRL006")
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela็ใo de Solicita็ใo de Compras em Aberto' + DTOC(DDATABASE)	,cAnexo)
			FErase(cAnexo)
			nHdl    := fCreate(cArqTxt)
			If !EOF()
				cLin    := ''
				For n := 1 to FCount()
					cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
					IF n == FCount()
						cLin += " Pendente"
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
			cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
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
		Conout("Envio email para o Comprador "+cComprador,"COMRL006")
		U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela็ใo de Solicita็ใo de Compras em Aberto' + DTOC(DDATABASE)	,cAnexo)
	Else
		Conout("Envio email de todas as SCs","COMRL006")
		U_2EnvMail('pedidos@actionmotors.com.br','leonardo.lima@taiff.com.br;rubens.brambilla@taiff.com.br'	,'',mCorpo	,' Segue Rela็ใo Completa de Solicita็ใo de Compras em Aberto' + DTOC(DDATABASE)	,cAnexo)
	EndIf
	FErase(cAnexo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	TRB->(dbCloseArea())

Return
