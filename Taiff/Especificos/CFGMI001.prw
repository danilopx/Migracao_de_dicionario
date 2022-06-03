#INCLUDE "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "shell.ch"
#include "fileio.ch"
#include "TOTVS.ch"

#DEFINE ENTER Chr(13)+Chr(10)
#DEFINE SW_HIDE             0 // Escondido
#DEFINE CHR_ENTER				'<br>'
#DEFINE CHR_FONT_DET_OPEN	'<font face="Courier New" size="2">'
#DEFINE CHR_FONT_DET_CLOSE	'</font>'

/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFGMI001  º Autor ³Paulo Bindo         º Data ³  04/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ROTINA DE UPLOAD E DOWNLOAD                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFGMI001()
	Local aFTP := {}
	Local aErros := {}
	Local cMens  := ""
	Local z := 0
	Local x := 0
	LOCAL cPrefixo := ""
	LOCAL nStatus2 := 0
	LOCAL cArqOrigem:= ""
	LOCAL cArqDestin:= ""
	LOCAL CNOMOPERAC:= ""
	LOCAL LAWR	:= .F.
	LOCAL lWeb := .F.

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT"
	EndIf
	Conout("CFGMI001 - Inicio Rotina de carga ao FTP TAIFF as " + TIME())

	Private cEmailAdm 	:= 'grp_sistemas@taiff.com.br' //GETMV("MV_WFADMIN")

	dbSelectArea("SZ4")
	dbSetOrder(1)
	dbGoTop()

	While !Eof()
		//QUANDO ESTIVER BLOQUEADO
		If Z4_MSBLQL == "1" 
			dbSkip()
			Loop
		EndIf
		Conout("CFGMI001 - Inicio da operação: " + SZ4->Z4_COD + " TIPO " + ALLTRIM(SZ4->Z4_OPER) + " DE " + alltrim(SZ4->Z4_DIRFTP))
		cServFTP 	:= AllTrim(SZ4->Z4_SERVFTP)
		cUsuFTP   	:= AllTrim(SZ4->Z4_USERFTP)
		cSenhaFTP   := AllTrim(SZ4->Z4_SENHA)
		lConnect := .F.
		lUpload  := .F.
		lDownload:= .F.
		nQtdeReg := 0
		nRej 	 := 0
		nQtdeUpl := 0

		FTPDisconnect()
		_xConnect := 1
		// Realiza 5 tentativas de conexao.
		While _xConnect <= 5 .And. !lConnect
			lConnect := FTPConnect( cServFTP ,, cUsuFTP, cSenhaFTP )
			If !lConnect
				//01 - CLIENTE, 02-OPERACAO, 03-DIRETORIO FTP, 04 - DATA, 05- HORA, 06-ERRO
				aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),'Erro ao conectar-se ao servidor'})
			Endif
			_xConnect ++
		End

		If lConnect
			//aAdd(aFTP,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),'Sucesso ao conectar-se ao servidor'})

			//SELECIONA O DIRETORIO FTP
			cDirFTP := AllTrim(SZ4->Z4_DIRFTP)
			_lDir := FTPDirChange(cDirFTP)
			If _lDir
				//OPERACAO DOWNLOAD
				If ALLTRIM(SZ4->Z4_OPER) == "D"
					aDirs := FTPDirectory(AllTrim(SZ4->Z4_EXTENSA))
					For z:=1 To Len(aDirs)
						cPrefixo := ""
						IF SZ4->Z4_CLIENTE != "IKESAK"
							// DOWNLOAD PARA A PASTA GKO
							If FTPDownload("\EDI\GKO\"+aDirs[z][1], aDirs[z][1] )
								aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Download na pasta de EDI da GKO"+aDirs[z][1]})
							EndIf
						ELSEIF SZ4->Z4_CLIENTE = "IKESAK"
							IF AT("/22467513/IKESAKI/PROCEDA/",ALLTRIM(cDirFTP)) != 0 .AND. AT("OCO",UPPER(aDirs[z][1])) != 0
								cPrefixo := "LIG"
							ENDIF
							// DOWNLOAD PARA A PASTA GKO
							If FTPDownload("\EDI\GKO_IKESAKI\" + aDirs[z][1], aDirs[z][1] )
								aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Download em EDI GKO IKESAKI"+aDirs[z][1]})
							EndIf
						ENDIF
						If FTPDownload(AllTrim(SZ4->Z4_DIRPROT)+aDirs[z][1], aDirs[z][1] )
							aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Arquivo Baixado "+aDirs[z][1]})

							If !FTPErase(aDirs[z][1])
								aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Erro Exclusao Arquivo "+aDirs[z][1]})
							Else
								aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Arquivo Apagado "+aDirs[z][1]})
							EndIf
						Else
							aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Erro Download Arquivo "+aDirs[z][1]})
						EndIf
						IF .NOT. EMPTY(cPrefixo)
							cArqOrigem := aDirs[z][1]
							cArqDestin := cPrefixo + aDirs[z][1]
							nStatus2 := U_TFRENAME( cArqOrigem , cArqDestin , strzero(z,3) )
						ENDIF
					Next
				Else
					//OPERACAO UPLOAD
					aDirs := {}
					ADir(AllTrim(SZ4->Z4_DIRPROT)+AllTrim(SZ4->Z4_EXTENSA),aDirs)
					
					LAWR := .T. // <<===<< PENDENTE 

					For z:=1 To Len(aDirs)
						If FTPUpLoad(AllTrim(SZ4->Z4_DIRPROT)+ aDirs[z] , aDirs[z] )
							aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Upload do arquivo: "+aDirs[z]})
							IF LAWR
								__CopyFile(AllTrim(SZ4->Z4_DIRPROT)+aDirs[z], AllTrim(SZ4->Z4_DIRPROT)+"backup\"+aDirs[z])
							ENDIF
							aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Arquivo Copiado: "+AllTrim(SZ4->Z4_DIRPROT)+"backup\"+aDirs[z]})
							If FErase(AllTrim(SZ4->Z4_DIRPROT)+ aDirs[z]) # 0
								aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Erro de exclusao do arquivo: "+aDirs[z]})
							Else
								aAdd(aFtp,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Arquivo " + alltrim(aDirs[z]) + " removido da pasta origem"})
							EndIf
						Else
							aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Erro de UPLOAD de arquivo "+aDirs[z]})
						EndIf
					Next

				EndIf
			Else
				aAdd(aErros,{SZ4->Z4_NOME, SZ4->Z4_OPER, SZ4->Z4_DIRFTP,Date(),Time(),"Erro Acesso ao Diretorio "+cDirFTP})
				FTPDisconnect()
			Endif
		Endif
		Conout("CFGMI001 - Fim da operação: " + SZ4->Z4_COD + " TIPO " + ALLTRIM(SZ4->Z4_OPER) )
		dbSelectArea("SZ4")
		dbSkip()
	End
	FTPDisconnect()
	//ENVIA EMAILS
	If Len(aFtp) >0
		cMens := ""
		For x:=1 To Len(aFtp)
			CNOMOPERAC := IIF( aFTP[x][2] = "D","DOWNLOAD",IIF(aFTP[x][2]="U","UPLOAD",aFTP[x][2]))
	
			cMens += "Cliente: "+aFTP[x][1]+ENTER
			cMens += "Operação: " + CNOMOPERAC + ENTER
			cMens += "Diretório: "+aFTP[x][3]+ENTER
			cMens += "Date: "+Dtoc(aFTP[x][4])+ENTER
			cMens += "Hota: "+aFTP[x][5]+ENTER
			cMens += "Mensagem: "+aFTP[x][6]+ENTER
			cMens += ""+ENTER
		Next
	EndIf

	If !Empty(cMens)
		Conout("CFGMI001 - Rotina finalizada, um email foi enviado para o e-mail do Administrador as " + TIME())
	Else
		cMens :="** NAO HA' DADOS A CARREGAR NO FTP **"
		Conout("CFGMI001 - Rotina finalizada, não há dados a carregar no FTP TAIFF as " + TIME())
	EndIf
	
	U_2EnvMail("workflow@taiff.com.br"      ,RTrim(cEmailAdm),'',cMens	    ,"Resumo carga de FTP TAIFF" ,'')

	If Len(aErros) > 0
		cMens := ""
		For x:=1 To Len(aErros)
			CNOMOPERAC := IIF( aErros[x][2] = "D","DOWNLOAD",IIF(aErros[x][2]="U","UPLOAD",aErros[x][2]))
			cMens += "Cliente: "+aErros[x][1]+ENTER
			cMens += "Operação: "+aErros[x][2]+ENTER
			cMens += "Diretório: "+aErros[x][3]+ENTER
			cMens += "Date: "+Dtoc(aErros[x][4])+ENTER
			cMens += "Hota: "+aErros[x][5]+ENTER
			cMens += "Mensagem: "+aErros[x][6]+ENTER
			cMens += ""+ENTER
		Next
		If !Empty(cMens)
			U_2EnvMail("workflow@taiff.com.br",RTrim(cEmailAdm)	,'',cMens	,"Resumo Erros FTP" ,'')
		EndIf
	EndIf
	IF lWeb
		RESET ENVIRONMENT
	ENDIF
Return

/*******************************************************************************/
/* FUNÇÃO....: CFGMIA01                                                        */
/* OBJETIVO..: Criar arquivos de lote (BAT) para execução de JOB WINDOWS       */
/* AUTOR.....: Carlos Torres                                                   */
/* DATA......: 20/11/2020                                                      */
/*******************************************************************************/
/* OBSERVACAO: Os arquivos BAT buscam XML de nota fiscal IKESAKI para envio ao */
/*             FTP da TAIFF, desta forma tanto GKO quanto as transportadoras   */
/*             receberão estes arquivos                                        */
/*             O ciclo de chamada da função: ocorre de hora em hora iniciando  */
/*             às 07:00 AM por um período de 12 horas, executado todos os dias */
/*             exceto aos domingos                                             */
/*                                                                             */
/*             Este processo não funciona quando executado via SCHEDULER do    */
/*             PROTHEUS ao acionar o comando SHELLEXECUTE                      */
/*******************************************************************************/
User Function CFGMIA01()
LOCAL nHandle := ""
LOCAL n2Handle:= ""
LOCAL cLine   := ""
LOCAL _AlinTXT:= {}
LOCAL NLOOP 	:= 0
LOCAL CBASEMES	:= STRZERO(YEAR(DATE()),4) + STRZERO(MONTH(DATE()),2)
LOCAL ACNPJ		:= {}
LOCAL ARAIZCNPJ	:= {}
LOCAL ANOMEARQ	:= {}
LOCAL AORIGARQ	:= {}
LOCAL N2LOOP 	:= 0
LOCAL ABKPDEST	:= {}

aAdd(ACNPJ,{"34028316\"+CBASEMES+"\PAC"})
aAdd(ACNPJ,{"34028316\"+CBASEMES+"\SEDEX"})
aAdd(ACNPJ,{"01125797"})
aAdd(ACNPJ,{"18233211"})
aAdd(ACNPJ,{"22467513"})
aAdd(ACNPJ,{"08298621"})
aAdd(ACNPJ,{"08298621\erro_transp"})
aAdd(ACNPJ,{"08298621\erro_gko"})
aAdd(ACNPJ,{"31160012"})
aAdd(ACNPJ,{"41030634"})


aAdd(ARAIZCNPJ,{"34028316"})
aAdd(ARAIZCNPJ,{"34028316"})
aAdd(ARAIZCNPJ,{"01125797"})
aAdd(ARAIZCNPJ,{"18233211"})
aAdd(ARAIZCNPJ,{"22467513"})
aAdd(ARAIZCNPJ,{"08298621"})
aAdd(ARAIZCNPJ,{"08298621\ecommerce"})
aAdd(ARAIZCNPJ,{"08298621\ecommerce"})
aAdd(ARAIZCNPJ,{"31160012"})
aAdd(ARAIZCNPJ,{"41030634"})

aAdd(ANOMEARQ,{"correiospac"})
aAdd(ANOMEARQ,{"correiossedex"})
aAdd(ANOMEARQ,{"ativa"})
aAdd(ANOMEARQ,{"fl"})
aAdd(ANOMEARQ,{"liglog"})
aAdd(ANOMEARQ,{"awr"})
aAdd(ANOMEARQ,{"awr_t"})
aAdd(ANOMEARQ,{"awr_g"})
aAdd(ANOMEARQ,{"ligcar"})
aAdd(ANOMEARQ,{"lsjcar"})

aAdd(AORIGARQ,{"ecommerce"})
aAdd(AORIGARQ,{"ecommerce"})
aAdd(AORIGARQ,{"televendas"})
aAdd(AORIGARQ,{"televendas"})
aAdd(AORIGARQ,{"televendas"})
aAdd(AORIGARQ,{"televendas"})
aAdd(AORIGARQ,{"ecommerce"})
aAdd(AORIGARQ,{"ecommerce"})
aAdd(AORIGARQ,{"televendas"})
aAdd(AORIGARQ,{"televendas"})

aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"bkp"})
aAdd(ABKPDEST,{"bkp"}) // No ecommerce será sempre BKP
aAdd(ABKPDEST,{"backup"})
aAdd(ABKPDEST,{"backup"})

//
// processo da transportadora CARRIERS
//
	CONOUT("CFGMI001 - inicio de copia de arquivos via JOB Windows " + TIME())

	IF FERASE("\IKESAKI\CARGA_LISTA.bat") == -1
		conout("CFGMI001 - Falha na deleção do Arquivo CARGA_LISTA.BAT - FError " + str(ferror(),4))
	Else
		conout("CFGMI001 - Arquivo CARGA_LISTA.BAT deletado com sucesso.")
	ENDIF

	IF FERASE("\IKESAKI\LISTA.txt") == -1
		conout("CFGMI001 - Falha na deleção do Arquivo LISTA.TXT - FError " + str(ferror(),4))
	Else
		conout("CFGMI001 - Arquivo LISTA.TXT deletado com sucesso.")
	ENDIF

	IF FERASE("\IKESAKI\COPIA_LISTA.bat") == -1
		conout("CFGMI001 - Falha na deleção do Arquivo COPIA_LISTA.BAT - FError " + str(ferror(),4))
	Else
		conout("CFGMI001 - Arquivo COPIA_LISTA.BAT deletado com sucesso.")
	ENDIF

	nHandle := FCREATE("\IKESAKI\CARGA_LISTA.bat")

    if nHandle = -1
        conout("CFGMI001 - Erro ao criar arquivo BAT - ferror " + Str(Ferror()))
    else
        conout("CFGMI001 - arquivo BAT criado com sucesso ")
        FWrite(nHandle, "net use \\192.168.2.2\nfe /delete /persistent:yes" + CRLF)
        FWrite(nHandle, "net use \\192.168.2.2\nfe /user:ikesaki.local\ctorres 835221Cta" + CRLF)
        FWrite(nHandle, "dir \\192.168.2.2\nfe\ecommerce\carriers\*.xml > E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\lista.txt /B" + CRLF)
		
        FClose(nHandle)
    endif
	sleep( 1000 ) // Para o processamento por 1 segundo * 30

	//IF WaitRun("E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\CARGA_LISTA.bat", SW_HIDE ) = -1
	IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\carga_lista.bat", "", "", SW_HIDE ) <= 32
	    conout("CFGMI001 - 1o. WaitRun com erro ")
	Else
	    conout("CFGMI001 - 1o. WaitRun executado com sucesso ")
	ENDIF

	conout("CFGMI001 - inicio do SLEEP: " + TIME())
	sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30
	conout("CFGMI001 - fim do SLEEP: " + TIME())

	// Abre o arquivo
	n2Handle := FT_FUse("\IKESAKI\lista.txt")
	// Se houver erro de abertura abandona processamento
	if n2Handle = -1
		conout("CFGMI001 - Erro ao abrir arquivo lista.txt - ferror " + Str(Ferror()))
	Else
		conout("CFGMI001 - No LOOP de carga a matriz lista.txt" )
		FT_FGoTop()
		While !FT_FEOF()
			cLine  := UPPER(ALLTRIM(FT_FReadLn()))
			
			AADD(_AlinTXT, cLine)

			FT_FSKIP()
		End
		// Fecha o Arquivo
		FT_FUSE()
		conout("CFGMI001 - Termino do LOOP de carga a matriz lista.txt" )

		nHandle := FCREATE("\IKESAKI\COPIA_LISTA.bat")

		if nHandle = -1
			conout("CFGMI001 - Erro ao criar arquivo COPIA_LISTA.bat - ferror " + Str(Ferror()))
		else
	        FWrite(nHandle, "net use \\192.168.2.2\nfe /delete /persistent:yes" + CRLF)
    	    FWrite(nHandle, "net use \\192.168.2.2\nfe /user:ikesaki.local\ctorres 835221Cta" + CRLF)
			FOR NLOOP := 1 TO LEN(_AlinTXT)
				FWrite(nHandle, "XCOPY \\192.168.2.2\nfe\ecommerce\carriers\" + _AlinTXT[NLOOP] + " E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\10520136\ /y" + ENTER)
				FWrite(nHandle, "MOVE \\192.168.2.2\nfe\ecommerce\carriers\" + _AlinTXT[NLOOP] + " \\192.168.2.2\nfe\ecommerce\carriers\backup" + ENTER)
			NEXT NLOOP 
			FClose(nHandle)
			IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\COPIA_LISTA.bat", "", "", SW_HIDE ) <= 32
				conout("CFGMI001 - 2o. WaitRun com erro ")
			Else
				conout("CFGMI001 - 2o. WaitRun executado com sucesso ")
			ENDIF
			conout("CFGMI001 - inicio do SLEEP fim de processo: " + TIME())
			sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30
			conout("CFGMI001 - fim do SLEEP do fim de processo: " + TIME())
		endif
	endif

//
// processo da transportadora CORREIOS e demais
//
	FOR N2LOOP := 1 TO LEN(ACNPJ)
		IF FERASE("\IKESAKI\CARGA_" + ANOMEARQ[N2LOOP,1] + ".bat") == -1
			conout("CFGMI001 - Falha na deleção do Arquivo CARGA_" + ANOMEARQ[N2LOOP,1] + ".BAT - FError " + str(ferror(),4))
		Else
			conout("CFGMI001 - Arquivo CARGA_" + ANOMEARQ[N2LOOP,1] + ".BAT deletado com sucesso.")
		ENDIF

		IF FERASE("\IKESAKI\LISTA_" + ANOMEARQ[N2LOOP,1] + ".txt") == -1
			conout("CFGMI001 - Falha na deleção do Arquivo LISTA_" + ANOMEARQ[N2LOOP,1] + ".TXT - FError " + str(ferror(),4))
		Else
			conout("CFGMI001 - Arquivo LISTA_" + ANOMEARQ[N2LOOP,1] + ".TXT deletado com sucesso.")
		ENDIF

		IF FERASE("\IKESAKI\COPIA_" + ANOMEARQ[N2LOOP,1] + ".bat") == -1
			conout("CFGMI001 - Falha na deleção do Arquivo COPIA_" + ANOMEARQ[N2LOOP,1] + ".BAT - FError " + str(ferror(),4))
		Else
			conout("CFGMI001 - Arquivo COPIA_" + ANOMEARQ[N2LOOP,1] + ".BAT deletado com sucesso.")
		ENDIF

		nHandle := FCREATE("\IKESAKI\CARGA_" + ANOMEARQ[N2LOOP,1] + ".bat")

		if nHandle = -1
			conout("CFGMI001 - Erro ao criar arquivo BAT - ferror " + Str(Ferror()))
		else
			conout("CFGMI001 - arquivo BAT criado com sucesso ")
			conout("CFGMI001 - gravando dados para " + ACNPJ[N2LOOP,1])
			FWrite(nHandle, "net use \\192.168.2.2\nfe /delete /persistent:yes" + CRLF)
			FWrite(nHandle, "net use \\192.168.2.2\nfe /user:ikesaki.local\ctorres 835221Cta" + CRLF)
			FWrite(nHandle, "dir \\192.168.2.2\nfe\"+AORIGARQ[N2LOOP,1]+"\" + ACNPJ[N2LOOP,1] + "\*.xml > E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\LISTA_" + ANOMEARQ[N2LOOP,1] + ".txt /B" + CRLF)

			FClose(nHandle)
		endif
		sleep( 1000 ) // Para o processamento por 1 segundo * 30

		//IF WaitRun("E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\CARGA_LISTA.bat", SW_HIDE ) = -1
		IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\carga_" + ANOMEARQ[N2LOOP,1] + ".bat", "", "", SW_HIDE ) <= 32
			conout("CFGMI001 - 1o. WaitRun com erro ")
		Else
			conout("CFGMI001 - 1o. WaitRun executado com sucesso ")
		ENDIF

		conout("CFGMI001 - inicio do SLEEP: " + TIME())
		sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30
		conout("CFGMI001 - fim do SLEEP: " + TIME())

		// Abre o arquivo
		n2Handle := FT_FUse("\IKESAKI\lista_" + ANOMEARQ[N2LOOP,1] + ".txt")
		// Se houver erro de abertura abandona processamento
		if n2Handle = -1
			conout("CFGMI001 - Erro ao abrir arquivo lista_" + ANOMEARQ[N2LOOP,1] + ".txt - ferror " + Str(Ferror()))
		Else
			conout("CFGMI001 - No LOOP de carga a matriz lista_" + ANOMEARQ[N2LOOP,1] + ".txt" )
			
			_AlinTXT := {}

			FT_FGoTop()
			While !FT_FEOF()
				cLine  := UPPER(ALLTRIM(FT_FReadLn()))
				
				AADD(_AlinTXT, cLine)

				FT_FSKIP()
			End
			// Fecha o Arquivo
			FT_FUSE()
			conout("CFGMI001 - Termino do LOOP de carga a matriz lista.txt" )

			nHandle := FCREATE("\IKESAKI\COPIA_" + ANOMEARQ[N2LOOP,1] + ".bat")

			if nHandle = -1
				conout("CFGMI001 - Erro ao criar arquivo COPIA_" + ANOMEARQ[N2LOOP,1] + ".bat - ferror " + Str(Ferror()))
			else
				FWrite(nHandle, "net use \\192.168.2.2\nfe /delete /persistent:yes" + CRLF)
				FWrite(nHandle, "net use \\192.168.2.2\nfe /user:ikesaki.local\ctorres 835221Cta" + CRLF)
				FOR NLOOP := 1 TO LEN(_AlinTXT)
					FWrite(nHandle, "XCOPY \\192.168.2.2\nfe\"+AORIGARQ[N2LOOP,1]+"\" + ACNPJ[N2LOOP,1] + "\" + _AlinTXT[NLOOP] + " E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\" + ARAIZCNPJ[N2LOOP,1] + "\ /y" + ENTER)
					FWrite(nHandle, "MOVE \\192.168.2.2\nfe\"+AORIGARQ[N2LOOP,1]+"\" + ACNPJ[N2LOOP,1] + "\" + _AlinTXT[NLOOP] + " \\192.168.2.2\nfe\"+AORIGARQ[N2LOOP,1]+"\" + ACNPJ[N2LOOP,1] + "\" + ABKPDEST[N2LOOP,1] + ENTER)
				NEXT NLOOP 
				FClose(nHandle)
				IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\COPIA_" + ANOMEARQ[N2LOOP,1] + ".bat", "", "", SW_HIDE ) <= 32
					conout("CFGMI001 - 2o. WaitRun com erro ")
				Else
					conout("CFGMI001 - 2o. WaitRun executado com sucesso ")
				ENDIF
				conout("CFGMI001 - inicio do SLEEP fim de processo: " + TIME())
				sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30
				conout("CFGMI001 - fim do SLEEP do fim de processo: " + TIME())
			endif
		endif
	NEXT N2LOOP
Return


/*******************************************************************************/
/* FUNÇÃO....: TFRENAME                                                        */
/* OBJETIVO..: Para teste da função FRENAME                                    */
/* AUTOR.....: Carlos Torres                                                   */
/* DATA......: 04/03/2021                                                      */
/*******************************************************************************/
USER FUNCTION TFRENAME(_CORIGEM,_CDESTINO,ID_ARQUIVO)
LOCAL NRETORNO	:= 0
LOCAL CARQBAT	:= "E:\TOTVS\Microsiga\Protheus_Data\system\LIGLOG.BAT"
LOCAL CDIRBAT	:= "E:\TOTVS\Microsiga\Protheus_Data\system\"

NRETORNO := ShellExecute( "open", CARQBAT, _CORIGEM , CDIRBAT, SW_HIDE )

IF NRETORNO <= 32
	conout("CFGMI001 " + ALLTRIM(STR(PROCLINE())) + "- ***** Comando ShellExecute para LIGLOG executado com erro: " + ALLTRIM(STR(NRETORNO)))
	NRETORNO	:= -1
Else
	conout("CFGMI001 " + ALLTRIM(STR(PROCLINE())) + "- Comando ShellExecute para LIGLOG executado com sucesso")
ENDIF
sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30
RETURN (NRETORNO)

/*
*********************************************************************************************************************
*******            o arquivo LIGLOG.BAT deverá ficar na pasta CD\TOTVS\Microsiga\Protheus_Data\system         *******
*********************************************************************************************************************
@echo off
if "%1" == "" goto erro
	E:
	CD\TOTVS\Microsiga\Protheus_Data\EDI\GKO_IKESAKI
	RENAME %1 LIG%1
	goto fim

:erro
 goto fim

:fim 
*/

User Function ZZFTP()
    Local nRet
    //Local nI
    Local sRet
    Local cEnd := '162.214.71.231'
    Local cUser:= 'ftpedi@taiff.com.br'
    Local cPass := 'ta1ff45taiff'
    Local nPort := 21
    
    Private oFTPHandle

	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT"
	EndIf
	Conout("ZZFTP - Inicio Rotina de carga ao FTP TAIFF as " + TIME())
     
    //REALIZAR CONEXAO
    oFTPHandle := tFtpClient():New()
    nRet := oFTPHandle:FTPConnect(cEnd,nPort,cUser,cPass)
    sRet := oFTPHandle:GetLastResponse()
    Conout( sRet )
    /*Diz ao servidor para entrar no "modo passivo".
     No modo passivo, o servidor aguardará o cliente estabelecer uma conexão
      com ele, em vez de tentar se conectar a uma porta especificada pelo cliente.
       O servidor responderá com o endereço da porta em que está ouvindo*/
    oFTPHandle:bFireWallMode := .T.
    sRet := oFTPHandle:Quote("PASV")     
    sRet := oFTPHandle:GetLastResponse()
    Conout( sRet )
     
    If (nRet != 0)
      Conout( "Falha ao conectar" )
      Return .F.
    EndIf
     
	nRet := oFTPHandle:MkDir("torres_folder")
  	varinfo("Mkdir ret",nRet)
  	sRet := oFTPHandle:GetLastResponse()
  	Conout(sRet)

	nRet := oFTPHandle:ChDir("torres_folder")
	varinfo("Chdir ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
  
	oFTPHandle:GetCurDir(sRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)

	nRet := oFTPHandle:Directory("*")
	varinfo("Directory ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)

	nRet := oFTPHandle:Directory("*.XML")
	varinfo("Directory ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)

	nRet := oFTPHandle:ReceiveFile("nfe.xml", "\EDI\nfe.xml")
	varinfo("Receive ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)

    oFTPHandle:Close()
    sRet := oFTPHandle:GetLastResponse()
    Conout(sRet)
  Return

user function ikesak_p1()
LOCAL nHandle	:= ""
LOCAL n2Handle	:= ""
LOCAL cLine		:= ""
LOCAL _AlinTXT	:= {}
LOCAL NLOOP		:= 0
LOCAL NLOOPGERAL:= 0
LOCAL _ArqsTXT	:= {}
LOCAL _PastaTXT	:= {}
LOCAL CFTPARQUIVO := ""
LOCAL NRRIECTA	:= 0

	AADD(_PastaTXT,"/10520136/CONEMB/")
	AADD(_PastaTXT,"/10520136/DOCCOB/")
	AADD(_PastaTXT,"/10520136/PROCEDA/")
	AADD(_PastaTXT,"/10520136/CTE/")
	AADD(_PastaTXT,"/01125797/IKESAKI/CAMPINAS/")
	AADD(_PastaTXT,"/01125797/IKESAKI/CD_TELEVENDAS/")
	AADD(_PastaTXT,"/01125797/IKESAKI/ECOMMERCE/")
	AADD(_PastaTXT,"/01125797/IKESAKI/GUARULHOS/")
	AADD(_PastaTXT,"/01125797/IKESAKI/LIBERDADE/")
	AADD(_PastaTXT,"/01125797/IKESAKI/MATRIZ/")
	AADD(_PastaTXT,"/01125797/IKESAKI/OSASCO/")
	AADD(_PastaTXT,"/01125797/IKESAKI/SANTO_AMARO/")
	AADD(_PastaTXT,"/01125797/IKESAKI/SANTO_ANDRE/")
	AADD(_PastaTXT,"/01125797/IKESAKI/SAO_MIGUEL/")
	AADD(_PastaTXT,"/01125797/IKESAKI/TUCURUVI/")
	AADD(_PastaTXT,"/18233211/IKESAKI/CTE/")
	AADD(_PastaTXT,"/18233211/IKESAKI/PROCEDA/")
	AADD(_PastaTXT,"/22467513/IKESAKI/CTE/")
	AADD(_PastaTXT,"/08298621/IKESAKI/CTE/")                                    
	AADD(_PastaTXT,"/04601873/IKESAKI/PROCEDA/")
	AADD(_PastaTXT,"/04601873/IKESAKI/CTE/")
	AADD(_PastaTXT,"/08298621/IKESAKI/PROCEDA/")
	AADD(_PastaTXT,"/22467513/IKESAKI/PROCEDA/")
	AADD(_PastaTXT,"/31160012/IKESAKI/CTE/")
	AADD(_PastaTXT,"/31160012/IKESAKI/PROCEDA/")
	AADD(_PastaTXT,"/41030634/IKESAKI/CTE/")
	AADD(_PastaTXT,"/41030634/IKESAKI/PROCEDA/")


	AADD(_ArqsTXT,"LISTA_1.TXT")
	AADD(_ArqsTXT,"LISTA_2.TXT")
	AADD(_ArqsTXT,"LISTA_3.TXT")
	AADD(_ArqsTXT,"LISTA_4.TXT")
	AADD(_ArqsTXT,"LISTA_5.TXT")
	AADD(_ArqsTXT,"LISTA_6.TXT")
	AADD(_ArqsTXT,"LISTA_7.TXT")
	AADD(_ArqsTXT,"LISTA_8.TXT")
	AADD(_ArqsTXT,"LISTA_9.TXT")
	AADD(_ArqsTXT,"LISTA_10.TXT")
	AADD(_ArqsTXT,"LISTA_11.TXT")
	AADD(_ArqsTXT,"LISTA_12.TXT")
	AADD(_ArqsTXT,"LISTA_13.TXT")
	AADD(_ArqsTXT,"LISTA_14.TXT")
	AADD(_ArqsTXT,"LISTA_15.TXT")
	AADD(_ArqsTXT,"LISTA_16.TXT")
	AADD(_ArqsTXT,"LISTA_17.TXT")
	AADD(_ArqsTXT,"LISTA_18.TXT")
	AADD(_ArqsTXT,"LISTA_19.TXT")
	AADD(_ArqsTXT,"LISTA_20.TXT")
	AADD(_ArqsTXT,"LISTA_21.TXT")
	AADD(_ArqsTXT,"LISTA_22.TXT")
	AADD(_ArqsTXT,"LISTA_23.TXT")
	AADD(_ArqsTXT,"LISTA_24.TXT")
	AADD(_ArqsTXT,"LISTA_25.TXT")
	AADD(_ArqsTXT,"LISTA_26.TXT")
	AADD(_ArqsTXT,"LISTA_27.TXT")

	conout("ikesak_p1 - inicio da criação do arquivo de GET as " + TIME())
	FOR NLOOPGERAL := 1 TO LEN(_ArqsTXT)
	 	_AlinTXT	:= {}
		// Abre o arquivo
		n2Handle := FT_FUse("\EDI\FTP_COMANDOS\" + _ArqsTXT[NLOOPGERAL])
		// Se houver erro de abertura abandona processamento
		if n2Handle = -1
			conout("ikesak_p1 - Erro ao abrir arquivo " + _ArqsTXT[NLOOPGERAL] + " - ferror " + Str(Ferror()))
		Else
			conout("ikesak_p1 - No LOOP de carga a matriz " + _ArqsTXT[NLOOPGERAL] )
			NRRIECTA := 0
			FT_FGoTop()
			While !FT_FEOF()
				cLine  := ALLTRIM(FT_FReadLn())
				IF (NLOOPGERAL=4 .AND. NRRIECTA < 201) .OR. NLOOPGERAL != 4
					AADD(_AlinTXT, cLine)
				ENDIF
				NRRIECTA ++
				FT_FSKIP()
			End
			// Fecha o Arquivo
			FT_FUSE()
			IF NLOOPGERAL=1
				nHandle := FCREATE("\EDI\FTP_COMANDOS\ftp_ikesaki_d.txt")
				FWrite(nHandle, "open 162.214.71.231" + CRLF)
				FWrite(nHandle, "ftpedi@taiff.com.br" + CRLF)
				FWrite(nHandle, "ta1ff45taiff" + CRLF)
				FWrite(nHandle, "prompt off" + CRLF)
				FWrite(nHandle, "lc E:\TOTVS\Microsiga\Protheus_Data\EDI\GKO_IKESAKI" + CRLF)
				FWrite(nHandle, "ascii" + CRLF)
			ENDIF
			FWrite(nHandle, "cd " + _PastaTXT[NLOOPGERAL] + CRLF)

			conout("ikesak_p1 - No LOOP de carga a get do arquivo " + _ArqsTXT[NLOOPGERAL] + " com " + ALLTRIM(STR(LEN(_AlinTXT)))+ " elementos")
			FOR NLOOP := 1 TO LEN(_AlinTXT)
				IF LEN(ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60)))>5 .AND. ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60))!="BACKUP"
					CFTPARQUIVO := ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60))

					IF _PastaTXT[NLOOPGERAL] = "/22467513/IKESAKI/PROCEDA/" .OR. _PastaTXT[NLOOPGERAL] = "/31160012/IKESAKI/PROCEDA/" .OR. _PastaTXT[NLOOPGERAL] = "/41030634/IKESAKI/PROCEDA/"
						FWrite(nHandle, "get " + CFTPARQUIVO + " LIG"+CFTPARQUIVO + ENTER)
					ELSE
						FWrite(nHandle, "get " + CFTPARQUIVO + ENTER)
					ENDIF
					FWrite(nHandle, "delete " + CFTPARQUIVO + ENTER)
				ENDIF
			NEXT NLOOP 

		ENDIF
	NEXT NLOOPGERAL
	FWrite(nHandle, "disconnect" + CRLF)
	FWrite(nHandle, "quit" + CRLF)	
	FClose(n2Handle)
	FClose(nHandle)
	conout("ikesak_p1 - fim da criação do arquivo de GET as " + TIME())
return


user function taiff_p1()
LOCAL nHandle	:= ""
LOCAL n2Handle	:= ""
LOCAL cLine		:= ""
LOCAL _AlinTXT	:= {}
LOCAL NLOOP		:= 0
LOCAL NLOOPGERAL:= 0
LOCAL _ArqsTXT	:= {}
LOCAL _PastaTXT	:= {}
LOCAL CFTPARQUIVO := ""

	AADD(_PastaTXT,"/01125797/")
	AADD(_PastaTXT,"/01515934/")
	AADD(_PastaTXT,"/60664828/")
	AADD(_PastaTXT,"/08831345/")
	AADD(_PastaTXT,"/01743404/")
	AADD(_PastaTXT,"/48740351/")
	AADD(_PastaTXT,"/08322757/")
	AADD(_PastaTXT,"/52871738/")
	AADD(_PastaTXT,"/25866971/")
	AADD(_PastaTXT,"/13528071/")
	AADD(_PastaTXT,"/18233211/")

	AADD(_ArqsTXT,"FLISTA_1.TXT")
	AADD(_ArqsTXT,"FLISTA_2.TXT")
	AADD(_ArqsTXT,"FLISTA_3.TXT")
	AADD(_ArqsTXT,"FLISTA_4.TXT")
	AADD(_ArqsTXT,"FLISTA_5.TXT")
	AADD(_ArqsTXT,"FLISTA_6.TXT")
	AADD(_ArqsTXT,"FLISTA_7.TXT")
	AADD(_ArqsTXT,"FLISTA_8.TXT")
	AADD(_ArqsTXT,"FLISTA_9.TXT")
	AADD(_ArqsTXT,"FLISTA_10.TXT")
	AADD(_ArqsTXT,"FLISTA_11.TXT")

	conout("taiff_p1 - inicio da criação de arquivo GET as " + TIME())
	FOR NLOOPGERAL := 1 TO LEN(_ArqsTXT)
	 	_AlinTXT	:= {}
		// Abre o arquivo
		n2Handle := FT_FUse("\EDI\FTP_COMANDOS\" + _ArqsTXT[NLOOPGERAL])
		// Se houver erro de abertura abandona processamento
		if n2Handle = -1
			conout("taiff_p1 - Erro ao abrir arquivo " + _ArqsTXT[NLOOPGERAL] + " - ferror " + Str(Ferror()))
		Else
			conout("taiff_p1 - No LOOP de carga a matriz " + _ArqsTXT[NLOOPGERAL] )
			FT_FGoTop()
			While !FT_FEOF()
				cLine  := ALLTRIM(FT_FReadLn())
				
				AADD(_AlinTXT, cLine)

				FT_FSKIP()
			End
			// Fecha o Arquivo
			FT_FUSE()
			IF NLOOPGERAL=1
				nHandle := FCREATE("\EDI\FTP_COMANDOS\ftp_taiff_d.txt")
				FWrite(nHandle, "open 162.214.71.231" + CRLF)
				FWrite(nHandle, "ftpedi@taiff.com.br" + CRLF)
				FWrite(nHandle, "ta1ff45taiff" + CRLF)
				FWrite(nHandle, "prompt off" + CRLF)
				FWrite(nHandle, "lc E:\TOTVS\Microsiga\Protheus_Data\EDI" + CRLF)
				FWrite(nHandle, "ascii" + CRLF)
			ENDIF
			FWrite(nHandle, "cd " + _PastaTXT[NLOOPGERAL] + CRLF)
			IF NLOOPGERAL!=8
				FOR NLOOP := 1 TO LEN(_AlinTXT)
					IF LEN(ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60)))>5 .AND. AT(UPPER(ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60))) ,".FTPQUOTA|IKESAKI") = 0
						CFTPARQUIVO := ALLTRIM(SUBSTRING(_AlinTXT[NLOOP],63,60))

						FWrite(nHandle, "get " + CFTPARQUIVO + ENTER)
						FWrite(nHandle, "delete " + CFTPARQUIVO + ENTER)
					ENDIF
				NEXT NLOOP 
			ENDIF
		ENDIF
	NEXT NLOOPGERAL
	FWrite(nHandle, "disconnect" + CRLF)
	FWrite(nHandle, "quit" + CRLF)	
	FClose(n2Handle)
	FClose(nHandle)
	conout("taiff_p1 - fim da criação do arquivo de GET as " + TIME())
return

USER FUNCTION FLOOPEDI()

IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\EDI\FTP_COMANDOS\taiff_l.bat", "", "", SW_HIDE ) <= 32
	conout("FLOOPEDI - 1o. WaitRun com erro ")
Else
	conout("FLOOPEDI - 1o. WaitRun executado com sucesso ")
ENDIF
sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30

U_taiff_p1()

sleep( 1000 * 10 ) // Para o processamento por 1 segundo * 30

IF ShellExecute( "open", "E:\TOTVS\Microsiga\Protheus_Data\EDI\FTP_COMANDOS\taiff_d.bat", "", "", SW_HIDE ) <= 32
	conout("FLOOPEDI - 1o. WaitRun com erro ")
Else
	conout("FLOOPEDI - 1o. WaitRun executado com sucesso ")
ENDIF

RETURN

//
// CARGA FTP CARRIERS
//
User Function FTPCARRIERS()
	Local aFTP := {}
	Local aErros := {}
	Local cMens  := ""
	Local z := 0
	Local x := 0
	LOCAL CNOMOPERAC:= ""
	LOCAL CRDIRFTP := "/10520136/XML/REDUNDANCIA"
	LOCAL CRDIRPAD := "/10520136/XML"
	LOCAL CRDIRPRO := "\IKESAKI\10520136\backup\backup\" // "E:\Microsiga\Protheus_Data\IKESAKI\10520136\backup\backup\" //"E:\TOTVS\Microsiga\Protheus_Data\IKESAKI\10520136\backup\backup\"

    Local cEnd := '162.214.71.231'
    Local cUser:= 'ftpedi@taiff.com.br'
    Local cPass := 'ta1ff45taiff'
    Local nPort := 21
	Local nRet
	Local sRet
	LOCAL lWeb := .F.

	Private oFTPHandle

	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		lWeb := .T.
		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT"
	EndIf
	Conout(PROCNAME() + " - Inicio Rotina de carga ao FTP TAIFF as " + TIME())

	Private cEmailAdm 	:= "carlos.torres@taiff.com.br" //;thaina.negri@ikesaki.com.br" /// 'grp_sistemas@taiff.com.br' //GETMV("MV_WFADMIN")

	oFTPHandle := tFtpClient():New()
	nRet := oFTPHandle:FTPConnect(cEnd,nPort,cUser,cPass)
	sRet := oFTPHandle:GetLastResponse()
	//Conout( sRet )
    oFTPHandle:bFireWallMode := .T.
    //sRet := oFTPHandle:Quote("PASV")     
    //sRet := oFTPHandle:GetLastResponse()
    //Conout( sRet )

	If (nRet != 0)
		Conout( PROCNAME() + " - Falha ao conectar" )
		Return .F.
	EndIf

	//
	// Muda para o diretorio FTP redundancia
	//
	nRet := oFTPHandle:ChDir( CRDIRFTP )
	/*
	varinfo("Chdir ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
	*/

	/*
	//
	// Mostra o diretorio corrente
	// 
	oFTPHandle:GetCurDir(sRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
	*/

	aDirs := {}
	ADir(AllTrim(CRDIRPRO)+AllTrim(SZ4->Z4_EXTENSA),aDirs)

	For z:=1 To Len(aDirs)
		nRet := oFTPHandle:SendFile(AllTrim(CRDIRPRO) + aDirs[z], aDirs[z])
		IF nRet = 0
			aAdd(aFtp,{"CARRIERS ", "U", AllTrim(CRDIRFTP),Date(),Time(),"Upload do arquivo: "+aDirs[z]})
		Else
			aAdd(aErros,{"CARRIERS ", "U", AllTrim(CRDIRFTP),Date(),Time(),"Erro de UPLOAD de arquivo "+aDirs[z]})
		EndIf
	Next
   
	//
	// Muda para o diretorio FTP padrão
	//
	nRet := oFTPHandle:ChDir( CRDIRPAD )
	/*
	varinfo("Chdir ret",nRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
	*/

	/*
	//
	// Mostra o diretorio corrente
	// 
	oFTPHandle:GetCurDir(sRet)
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
	*/

	aDirs := {}
	ADir(AllTrim(CRDIRPRO)+AllTrim(SZ4->Z4_EXTENSA),aDirs)

	For z:=1 To Len(aDirs)
		nRet := oFTPHandle:SendFile(AllTrim(CRDIRPRO) + aDirs[z], aDirs[z])
		IF nRet = 0
			//CONOUT(PROCNAME() + " - CARGA FTP EM " + CRDIRPAD + " DO ARQUIVO " + aDirs[z])
			IF .NOT. (FERASE(AllTrim(CRDIRPRO) + aDirs[z]) <> -1)
				CONOUT(PROCNAME() + " - Error in the file deletion no " + STR(FERROR()))
			//ELSE
			//	CONOUT(PROCNAME() + " - NOT Error in the file deletion no " + STR(FERROR()))
			ENDIF
		ENDIF
	Next

	//
	// Fecha FTP
	//
	oFTPHandle:Close()
	/*
	sRet := oFTPHandle:GetLastResponse()
	Conout(sRet)
	*/

	//
	// Envia e-mail
	//
	If Len(aFtp) >0
		cMens := ""
		For x:=1 To Len(aFtp)
			CNOMOPERAC := IIF( aFTP[x][2] = "D","DOWNLOAD",IIF(aFTP[x][2]="U","UPLOAD",aFTP[x][2]))
			IF X = 1
				cMens := CHR_FONT_DET_OPEN
				cMens += "Cliente: "+aFTP[x][1] + CHR_ENTER
				cMens += "Operação: " + CNOMOPERAC + " de arquivos XML de Nfe e-commerce" + CHR_ENTER
				cMens += "Diretório: "+aFTP[x][3] + CHR_ENTER
				cMens += "Date: "+Dtoc(aFTP[x][4]) + CHR_ENTER
				cMens += "Hora: "+aFTP[x][5] + CHR_ENTER
				cMens += "Total de " + alltrim(str(Len(aFtp))) + " arquivo(s) carregado(s) no FTP" + CHR_ENTER
			ENDIF
			cMens += "Mensagem: "+aFTP[x][6] + CHR_ENTER
			IF X = LEN(aFtp)
				cMens += "*** fim do LOG *** " + CHR_ENTER
				cMens += CHR_FONT_DET_CLOSE
			ENDIF
		Next		
	EndIf
	If !Empty(cMens)
		Conout(PROCNAME() + " - Rotina finalizada, um email foi enviado para o e-mail do Administrador as " + TIME())
	Else
		cMens := CHR_FONT_DET_OPEN
		cMens += "** NAO HA' DADOS A CARREGAR NO FTP **"
		cMens += CHR_FONT_DET_CLOSE
		Conout(PROCNAME() + " - Rotina finalizada, não há dados a carregar no FTP TAIFF as " + TIME())
	EndIf
	
	U_CTEnvMail("workflow@taiff.com.br",RTrim(cEmailAdm),'',cMens,"Carga de FTP CARRIERS - REDUNDANCIA",'')
	If Len(aErros) > 0
		cMens := ""
		For x:=1 To Len(aErros)
			CNOMOPERAC := IIF( aErros[x][2] = "D","DOWNLOAD",IIF(aErros[x][2]="U","UPLOAD",aErros[x][2]))
			IF X = 1
				cMens := CHR_FONT_DET_OPEN
				cMens += "Cliente: "+aErros[x][1] + CHR_ENTER
				cMens += "Operação: "+aErros[x][2] + CHR_ENTER
				cMens += "Diretório: "+aErros[x][3] + CHR_ENTER
				cMens += "Date: "+Dtoc(aErros[x][4]) + CHR_ENTER
				cMens += "Hora: "+aErros[x][5] + CHR_ENTER
			ENDIF
			cMens += "Mensagem: "+aErros[x][6] + CHR_ENTER
			IF X = LEN(aFtp)
				cMens += "*** fim do LOG *** " + CHR_ENTER
				cMens += CHR_FONT_DET_CLOSE
			ENDIF
		Next
		If !Empty(cMens)
			U_CTEnvMail("workflow@taiff.com.br",RTrim(cEmailAdm)	,'',cMens	,"Resumo Erros FTP" ,'')
		EndIf
	EndIf
	Conout(PROCNAME() + " - Fim da Rotina de carga ao FTP TAIFF as " + TIME())
	IF lWeb
		RESET ENVIRONMENT
	ENDIF

Return

//
// FUNÇÃO DE ENVIO DE E-MAIL
//
User Function CTEnvMail(cVar1,cVar2,cVar3,cVar4,cVar5,cVar6)
	Local oMailServer 	:= TMailManager():New()
	Local oMessage 		:= TMailMessage():New()
	Local nErro 		:= 0
	LOCAL CSMTPSERVER 	:= "smtp.gmail.com" //GetMV("MV_RELSERV") 	
	LOCAL cSMTPSenha	:= "n#iJE7#2"
	LOCAL cSMTPConta	:= "workflow@taiff.com.br"
	LOCAL CSMTPPorta	:= 587 

	oMailServer:SetUseSSL( .F. )
	oMailServer:SetUseTLS( .T. )

	oMailServer:Init( "", CSMTPSERVER, cSMTPConta, cSMTPSenha , 0, CSMTPPorta )
	If( (nErro := oMailServer:SmtpConnect()) != 0 )
		conout( PROCNAME() + " - Não conectou no SMTP para envio de e-mail.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf
  
	nErro := oMailServer:SmtpAuth( cSMTPConta,cSMTPSenha )
	If nErro <> 0
		conout( PROCNAME() + " - ERRO retornado pelo SMTP ao enviar e-mail:" + oMailServer:GetErrorString( nErro ) )
		oMailServer:SMTPDisconnect()
		return .F.
	Endif

	oMessage:Clear()
	oMessage:cFrom           := cVar1
	oMessage:cTo             := cVar2
	oMessage:cCc             := ""
	oMessage:cBcc            := ""
	oMessage:cSubject        := cVar5
	oMessage:cBody           := cVar4
	oMessage:MsgBodyType( "text/html" )

	// Para solicitar confimação de envio
	//oMessage:SetConfirmRead( .T. )

	// Adiciona um anexo, nesse caso a imagem esta no root
	///////----oMessage:AttachFile( cVar6 )

	// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
	/////////oMessage:AddAttHTag( 'Content-ID: &lt;ID_siga.jpg&gt;' )
	nErro := oMessage:Send( oMailServer )
	If( nErro != 0 )
		conout( PROCNAME() + " - Não enviou o e-mail da CARRIERS: " + oMailServer:GetErrorString( nErro ) )
		Return
	EndIf
	nErro := oMailServer:SmtpDisconnect()
	If( nErro != 0 )
		conout( PROCNAME() + " - Não desconectou do SMTP para envio de e-mail.", oMailServer:GetErrorString( nErro ) )
		Return
	EndIf
Return
