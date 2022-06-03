#INCLUDE "protheus.ch"
#INCLUDE "AP5MAIL.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE CRLF ( chr(13)+chr(10) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMRL007  �Autor  �Microsiga           � Data �  05/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �RELACAO DE ITENS ABAIXO PONTO DE PEDIDO - KANBAN            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function COMRL007()

	Local nXz  := 0
	Private lWeb := .F.


//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "04" FILIAL "02" MODULO "COM"
	EndIf

//GRAVA DADOS DA ROTINA UTILIZADA
//U_CFGRD001("COMRL007") - Sandro

	For nXz :=1 To 2
		If lWeb
			dDataBase := Date()
			CORL07GERA()
			If nXz == 2
				RESET ENVIRONMENT
			EndIf
		Else
			If MsgYesNo("Esta rotina ir� enviar e-mail de itens abaixo do ponto de pedido aos compradores, deseja continuar?")
				Processa( {|| CORL07GERA() } )
				MsgInfo("Opera��o Finalizada!")
			EndIf
		EndIf
	Next
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMRL006  �Autor  �Microsiga           � Data �  05/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CORL07GERA()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
	//Local nTamLin
	Local cLin
	//Local cCpo
	Local n := 0
	//Local cError := ""

	Private cEmailAdm 	:= GETMV("MV_WFADMIN")
	Private cString := "TRB"
	Private cArqTxt := "\SYSTEM\COMRL007.CSV"
	Private nHdl    := fCreate(cArqTxt)
	Private cEOL    := "CHR(13)+CHR(10)"

	cMsg  := "Em anexo, segue a Rela��o de itens abaixo do ponto de pedido - Kanban." + CRLF
	cMsg  += CRLF
	cMsg  += "PAR�METROS" + CRLF
	cMsg  += "Tipo    : Solicita��es em aberto" + CRLF
	cMsg  += "Entrega : menor ou igual a " +DTOC(DDATABASE)+CRLF


//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

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


	cQuery := " SELECT B2_COD, B1_DESC , SUM(B2_QATU) B2_QATU,  Y1_NOME , Y1_EMAIL, B1_EMIN, SUM(B2_QACLASS)B2_QACLASS , SUM(B2_NAOCLAS)B2_NAOCLAS, SUM(B2_SALPEDI) B2_SALPEDI, SUM(B2_QEMP) B2_QEMP, (SUM(B2_QATU)/(B1_EMIN/5)) AS HKS_QGIRO
	cQuery += " FROM "+RetSqlName("SB2")+" B2 WITH(NOLOCK)
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 WITH(NOLOCK) ON B1_COD = B2_COD AND B1_FILIAL = B2_FILIAL
	cQuery += " INNER JOIN "+RetSqlName("SY1")+" Y1 WITH(NOLOCK) ON B1_GRUPCOM = Y1_GRUPCOM  AND B1_FILIAL = Y1_FILIAL
	cQuery += " WHERE
	cQuery += " B1_GRUPCOM <> ''
	cQuery += " AND B1.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*' AND Y1.D_E_L_E_T_ <> '*'
	cQuery += " AND B2_LOCAL IN ('01','02','11')
	cQuery += " AND B1_EMIN > 0
	cQuery += " AND B1_EMIN >(SELECT SUM(B2_QATU) FROM "+RetSqlName("SB2")+" B21 WITH(NOLOCK) WHERE B1_COD = B21.B2_COD AND B1_FILIAL = B21.B2_FILIAL AND B21.D_E_L_E_T_ <> '*' AND B21.B2_LOCAL IN ('01','02','11'))
	cQuery += " GROUP BY B2_COD, B1_DESC ,  Y1_NOME , Y1_EMAIL, B1_EMIN
	cQuery += " ORDER BY Y1_EMAIL, B2_COD   "

	MEMOWRITE("COMRL007.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

	Count To nRec

	Count To nCount

	If nCount == 0
		If !lWeb
			MsgStop("N�o foram encontrados dados!","Aten��o - COMRL007")
		Else
			Conout("N�o foram encontrados dados!","Aten��o - COMRL007")
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
				cLin += ""
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
			Conout("Envio email para o Comprador "+cComprador,"COMRL007")
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela��o de itens abaixo ponto de pedido - Kanban' + DTOC(DDATABASE)	,cAnexo)
			FErase(cAnexo)
			nHdl    := fCreate(cArqTxt)
			If !EOF()
				cLin    := ''
				For n := 1 to FCount()
					cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
					IF n == FCount()
						cLin += ""
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


		//���������������������������������������������������������������������Ŀ
		//� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
		//� linha montada.                                                      �
		//�����������������������������������������������������������������������

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
		Conout("Envio email para o Comprador "+cComprador,"COMRL007")
		U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',mCorpo	,'A/C:'+RTrim(cComprador)+', Segue Rela��o de itens abaixo ponto de pedido - Kanban' + DTOC(DDATABASE)	,cAnexo)
	Else
		Conout("Envio email de itens abaixo ponto de pedido","COMRL007")
		U_2EnvMail('pedidos@actionmotors.com.br','leonardo.lima@taiff.com.br;rubens.brambilla@taiff.com.br;alberto.onisi@taiff.com.br;jordana.oliveira@taiff.com.br;processosvga@taiff.com.br'	,'',mCorpo	,' Segue Rela��o completa de itens abaixo ponto de pedido - Kanban' + DTOC(DDATABASE)	,cAnexo)
		//U_2EnvMail('pedidos@actionmotors.com.br','BINDO@GLOBO.COM'	,'',mCorpo	,' Segue Rela��o completa de itens abaixo ponto de pedido - Kanban' + DTOC(DDATABASE)	,cAnexo)
	EndIf
	FErase(cAnexo)

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
	TRB->(dbCloseArea())

Return
