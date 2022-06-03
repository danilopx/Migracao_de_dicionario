#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TBICONN.CH"
#include "TbiCode.ch"
//----------------------------------------------------------------------------------------------------------
//
// Função principal executada pelo SCHEDULE do PROTHEUS é CNMI_DAIHATSU
//
//----------------------------------------------------------------------------------------------------------
//
//                                MERCABEL
//
User Function CNAB_MERCABEL

	Local cChave := ""
	Local nStop  := 0
	Local nQtdParcela := 0
	Local cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "02" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		nQtdParcela := 0
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		nStop  := SE1->(recno())
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			Endif
			SE1->(dbskip())
		End
		If nQtdParcela > 0
			cId_CNAB := ""
			SE1->(dbgoto( nStop ))
			While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
				If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
					Do Case
					Case Empty(SE1->E1_PARCELA) .and. nQtdParcela=1
						cId_CNAB := spac(01) + Substr(SE1->E1_NUM,5,5) + "-1/1"
					Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
						cId_CNAB := spac(01) + Substr(SE1->E1_NUM,5,5) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1) + "/" + Alltrim(Str(nQtdParcela))
					Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
						cId_CNAB := spac(01) + Substr(SE1->E1_NUM,5,5) + "-" + Chr(Asc(SE1->E1_PARCELA)-16) + "/" + Alltrim(Str(nQtdParcela))
					EndCase
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				SE1->(dbskip())
			End
		Endif
	End

	RESET ENVIRONMENT

return

//
//                                    PREVISTO
//
User Function CNAB_PREVISTO
	Local cChave := ""
	Local cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "01" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			//If Empty(SE1->E1_IDCNAB) .AND. Substr(SE1->E1_NUM,1,5)!='00000' .and. Substr(SE1->E1_NUM,1,3)='000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
			If Substr(SE1->E1_NUM,1,4)='0000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Alltrim(SE1->E1_PARCELA)
				EndCase
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End

	RESET ENVIRONMENT

return

//
//                                DAIHATSU
//
User Function CNAB_DAIHATSU
	Local cChave := ""
	Local nStop  := 0
	Local nQtdParcela := 0
	Local cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "01" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		nQtdParcela := 0
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
		nStop  := SE1->(recno())
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM = cChave .and. !SE1->(EOF())
			If Substr(SE1->E1_NUM,1,4)='0000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			Endif
			SE1->(dbskip())
		End
		If nQtdParcela > 0
			cId_CNAB := ""
			SE1->(dbgoto( nStop ))
			While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
				If Substr(SE1->E1_NUM,1,4)='0000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
					Do Case
					Case SE1->E1_FILIAL='02'
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1)
					Case Empty(SE1->E1_PARCELA) .and. nQtdParcela=1
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-1/1"
					Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1) + "/" + Alltrim(Str(nQtdParcela))
					Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Chr(Asc(SE1->E1_PARCELA)-16) + "/" + Alltrim(Str(nQtdParcela))
					EndCase
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				SE1->(dbskip())
			End
		Endif
	End

	RESET ENVIRONMENT

return

//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
// Rotina de atualização do campo ID_CNAB para todas as empresas
//------------------------------------------------------------------------------------------------------------//
User Function CNMI_DAIHATSU
	//------------------------------------------------------------------------------------------------------------//
	Local cChave := ""
	Local nStop  := 0
	Local nQtdParcela := 0
	Local cId_CNAB := ""
	//Local _cQuery

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "01" Filial "01" Modulo "FAT"
	Conout("INICIO ROTINA CNMI_DAIHATSU EMPRESA 01/01 em"+Dtoc(Date())+"-"+Time())
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		nQtdParcela := 0
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM
		nStop  := SE1->(recno())
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM = cChave .and. !SE1->(EOF())
			If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			ElseIf E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			Endif
			SE1->(dbskip())
		End
		If nQtdParcela > 0
			cId_CNAB := ""
			SE1->(dbgoto( nStop ))
			While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
				If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
					Do Case
					Case SE1->E1_FILIAL='02'
						cId_CNAB := Strzero(Val(SE1->E1_NUM),8) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1)
					Case Empty(SE1->E1_PARCELA) .and. nQtdParcela=1
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-1/1"
					Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1) + "/" + Alltrim(Str(nQtdParcela))
					Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Chr(Asc(SE1->E1_PARCELA)-16) + "/" + Alltrim(Str(nQtdParcela))
					EndCase
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				If E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
					If !EMPTY(SE1->E1_PARCELA)
						cId_CNAB := Alltrim(SE1->E1_NUM)+"-"+Alltrim(SE1->E1_PARCELA)
						If Len(cId_CNAB) > 10
							cId_CNAB := Subs( cId_CNAB ,(Len(cId_CNAB)-10)+1,10)
						EndIf
					Else
						cId_CNAB := Alltrim(SE1->E1_NUM)
					EndIf
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				SE1->(dbskip())
			End
		Endif
	End
	//--------------------------------------------------------------------------------------------------------------//
	// Executa função para prorrogar os vencimentos                                                                 //
	//--------------------------------------------------------------------------------------------------------------//
	U_MACD003( "01" )
	//--------------------------------------------------------------------------------------------------------------//
	//                                          Fim da rotina                                                       //
	//--------------------------------------------------------------------------------------------------------------//
	Conout("FIM ROTINA CNMI_DAIHATSU EMPRESA 01/01 em"+Dtoc(Date())+"-"+Time())
	RESET ENVIRONMENT


	//
	// Empresa ACTION - 04
	//
	cChave   := ""
	cId_CNAB := ""

	PREPARE ENVIRONMENT Empresa "04" Filial "01" Modulo "FAT"
	Conout("INICIO ROTINA CNMI_DAIHATSU EMPRESA 04/01 em"+Dtoc(Date())+"-"+Time())

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					cId_CNAB := Alltrim(SE1->E1_NUM) + "A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					cId_CNAB := Alltrim(SE1->E1_NUM) + Alltrim(SE1->E1_PARCELA)
				Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
					cId_CNAB := Alltrim(SE1->E1_NUM) + Chr(Asc(  Alltrim(Str(Val(SE1->E1_PARCELA)))  )+16)
				EndCase
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			If E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
				If !EMPTY(SE1->E1_PARCELA)
					cId_CNAB := Alltrim(SE1->E1_NUM)+"-"+Alltrim(SE1->E1_PARCELA)
					If Len(cId_CNAB) > 10
						cId_CNAB := Subs( cId_CNAB ,(Len(cId_CNAB)-10)+1,10)
					EndIf
				Else
					cId_CNAB := Alltrim(SE1->E1_NUM)
				EndIf
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End
	SE1->( dbCloseArea() )
	Conout(" FIM ROTINA CNMI_DAIHATSU EMPRESA 04/01 em"+Dtoc(Date())+"-"+Time())
	RESET ENVIRONMENT


	//
	// Empresa PROART - 03
	//
	cChave   := ""
	cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "03" Filial "01" Modulo "FAT"
	Conout("INICIO ROTINA CNMI_DAIHATSU EMPRESA 03/01 em"+Dtoc(Date())+"-"+Time())

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()

	While ! EOF()
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				cId_CNAB := SE1->E1_IDCNAB
				RecLock("SE1",.F.)

				If Empty(SE1->E1_SITUACA)
					If SA1->(DbSeek( xFilial("SA1") + SE1->(E1_CLIENTE+E1_LOJA) ))
						If SA1->A1_PESSOA='F' .AND. SA1->A1_BCO1='999'
							SE1->E1_SITUACA := '0'
						EndIf
					EndIf
				Endif
				MsUnLock()
			Endif
			If E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
				If !EMPTY(SE1->E1_PARCELA)
					cId_CNAB := Alltrim(SE1->E1_NUM)+"-"+Alltrim(SE1->E1_PARCELA)
					If Len(cId_CNAB) > 10
						cId_CNAB := Subs( cId_CNAB ,(Len(cId_CNAB)-10)+1,10)
					EndIf
				Else
					cId_CNAB := Alltrim(SE1->E1_NUM)
				EndIf
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End
	SE1->(dbCloseArea())

	Conout("FIM ROTINA CNMI_DAIHATSU EMPRESA 03/01 em"+Dtoc(Date())+"-"+Time())
	RESET ENVIRONMENT




	//
	// Empresa MERCABEL - 02
	//
	cChave := ""
	nStop  := 0
	nQtdParcela := 0
	cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "02" Filial "01" Modulo "FAT"
	Conout("INICIO ROTINA CNMI_DAIHATSU EMPRESA 02/01 em"+Dtoc(Date())+"-"+Time())


	SA1->(DbSetOrder(1))
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		nQtdParcela := 0
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		nStop  := SE1->(recno())
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			ElseIf E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
				nQtdParcela++
			Endif
			SE1->(dbskip())
		End
		If nQtdParcela > 0
			cId_CNAB := ""
			SE1->(dbgoto( nStop ))
			While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
				If E1_ORIGEM='MATA460' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
					Do Case
					Case Empty(SE1->E1_PARCELA) .and. nQtdParcela=1
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-1/1"
					Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Str(Val(Alltrim(SE1->E1_PARCELA)),1) + "/" + Alltrim(Str(nQtdParcela))
					Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
						cId_CNAB := Substr(SE1->E1_NUM,4,6) + "-" + Chr(Asc(SE1->E1_PARCELA)-16) + "/" + Alltrim(Str(nQtdParcela))
					EndCase
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				If E1_ORIGEM='FINA040' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NDC' .AND. Empty(SE1->E1_BAIXA)
					If !EMPTY(SE1->E1_PARCELA)
						cId_CNAB := Alltrim(SE1->E1_NUM)+"-"+Alltrim(SE1->E1_PARCELA)
						If Len(cId_CNAB) > 10
							cId_CNAB := Subs( cId_CNAB ,(Len(cId_CNAB)-10)+1,10)
						EndIf
					Else
						cId_CNAB := Alltrim(SE1->E1_NUM)
					EndIf
					RecLock("SE1",.F.)
					SE1->E1_IDCNAB := cId_CNAB
					MsUnLock()
				Endif
				SE1->(dbskip())
			End
		Endif
	End
	//--------------------------------------------------------------------------------------------------------------//
	// Executa função para prorrogar os vencimentos                                                                 //
	//--------------------------------------------------------------------------------------------------------------//
	U_MACD003( "02" )
	//--------------------------------------------------------------------------------------------------------------//
	//                                          Fim da rotina                                                       //
	//--------------------------------------------------------------------------------------------------------------//
	SE1->( dbCloseArea() )
	Conout("FIM ROTINA CNMI_DAIHATSU EMPRESA 02/01 em"+Dtoc(Date())+"-"+Time())
	//------------------------------------------------------------------------------------------------------------//
	RESET ENVIRONMENT
	//------------------------------------------------------------------------------------------------------------//
return



// 
//                                                            PROART
//
User Function CNAB_PROART
	Local cChave   := ""
	Local cId_CNAB := ""


	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "03" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If Substr(SE1->E1_NUM,1,5)='00000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + "A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + Alltrim(SE1->E1_PARCELA)
				Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + Chr(Asc(  Alltrim(Str(Val(SE1->E1_PARCELA)))  )+16)
				EndCase
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End

	RESET ENVIRONMENT
return
// 
//                                                            VIS
//
User Function CNAB_VIS
	Local cChave   := ""
	Local cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "07" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If Substr(SE1->E1_NUM,1,5)='00000' .and. Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + "A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + Alltrim(SE1->E1_PARCELA)
				Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
					cId_CNAB := spac(03) + Substr(SE1->E1_NUM,5,5) + Chr(Asc(  Alltrim(Str(Val(SE1->E1_PARCELA)))  )+16)
				EndCase
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End

	RESET ENVIRONMENT

return

// 
//                                                            ACTION
//
User Function CNAB_ACT
	Local cChave   := ""
	Local cId_CNAB := ""

	RPCSetType(3)  // Nao utilizar licenca
	PREPARE ENVIRONMENT Empresa "04" Filial "01" Modulo "FAT"

	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGotop()
	While !SE1->(EOF())
		cChave := SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM
		cId_CNAB := ""
		While SE1->E1_FILIAL + SE1->E1_PREFIXO + E1_NUM = cChave .and. !SE1->(EOF())
			If Empty(SE1->E1_NUMBOR) .and. SE1->E1_TIPO='NF' .AND. Empty(SE1->E1_BAIXA)
				Do Case
				Case Empty(SE1->E1_PARCELA)
					cId_CNAB := Alltrim(SE1->E1_NUM) + "A"
				Case SE1->E1_PARCELA >= "A" .and. SE1->E1_PARCELA <= "ZZZ"
					cId_CNAB := Alltrim(SE1->E1_NUM) + Alltrim(SE1->E1_PARCELA)
				Case SE1->E1_PARCELA >= "01" .and. SE1->E1_PARCELA <= "999"
					cId_CNAB := Alltrim(SE1->E1_NUM) + Chr(Asc(  Alltrim(Str(Val(SE1->E1_PARCELA)))  )+16)
				EndCase
				RecLock("SE1",.F.)
				SE1->E1_IDCNAB := cId_CNAB
				MsUnLock()
			Endif
			SE1->(dbskip())
		End
	End

	RESET ENVIRONMENT

return

//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
User Function SERIE_UPD
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	//Local nPonteiro := 7619272 //7089791
	//DbSelectArea("SB1")
	//DbSetOrder(1)
	//DbSelectArea("ZA4")
	//DbSetOrder(0)
	//DbGoto( nPonteiro )
	//While !ZA4->(EOF())
	//   If ZA4->(recno()) >= 7089797 .and. ZA4->(recno()) <= 8448793
	//      If SB1->(dbseek(xFilial('SB1')+ZA4->ZA4_COD))
	//         If SB1->B1_TIPO = 'PE'
	//            RecLock("SB1",.F.)
	//            SB1->B1_LOTECTL := ZA4->ZA4_NLOTE
	//            SB1->B1_CAIXA   := ZA4->ZA4_NCAIXA
	//            sb1->b1_serie   := ZA4->ZA4_NUMSER
	//            SB1->(MsUnlock())
	//         Endif
	//      Endif
	//   Endif
	//   ZA4->(DbSkip())
	//End
	Local nPonteiro := 0

	nPonteiro := 29869
	DbSelectArea("SC2")
	DbGotoP()
	While !SC2->(EOF())
		//If SC2->C2_PRODUTO != '000100036' .AND. SC2->C2_EMISSAO >= CTOD("04/06/2010") .AND. SC2->C2_TPOP='F'
		If SC2->C2_PRODUTO = '000000000' .AND. SC2->C2_EMISSAO >= CTOD("08/07/2010") .AND. SC2->C2_TPOP='F'
			If SB1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
				If SB1->B1_TIPO = 'PE'
					U_GRAVA_ZA4()
				Endif
			Endif
		Endif
		SC2->(DbSkip())
	End
RETURN

//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
USER FUNCTION GRAVA_ZA4()
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	Local nQtd   	 := 1
	Local nQtdFim	 := Int(sc2->c2_quant)
	//Local cCliPad	 := GetMv("MV_ATESTCL")   			// Parâmetro para utilizar o codigo do cliente padrão
	//Local cLojPad	 := GetMv("MV_ATESTLJ")   			// Parâmetro para utilizar o codigo da loja padrão
	Local cSerie	 := ""
	//Local aProdEtiq  := {}
	//Local lIntBarT 	 := GetMV("MV_INTBART",,.T.)		// Parametro Integra com Bar Tender
	Local lFirst	 := .T.
	Local cPrimSerie := ""
	Local nContaEtq  := 0
	Local xAlias	 := GetArea()
	Local nResto     := 0
	Local nLoop      := 0

	sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
	sb5->(dbseek(xFilial('SB5')+SC2->C2_PRODUTO))

	nResto := 1
	If sb5->B5_QE2 > 0
		nResto := nQtdFim/sb5->B5_QE2
		If nResto - Int(nResto) > 0
			nResto := Int(nQtdFim/sb5->B5_QE2) + 1
		Else
			nResto := Int(nQtdFim/sb5->B5_QE2)
		Endif
	Endif

	nContaEtq := nQtdFim

	For nLoop := 1 to nResto

		If Substr(sb1->b1_serie,3,2) = Right(Strzero(Year(dDataBase),4),2) // Checa Sequencial por Ano
			cSerie   := Alltrim(sb1->b1_serie)
		Else
			cDataSeq := Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
			cSerie   := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Replicate("0",6)
		Endif

		nQtdFim := sb5->B5_QE2
		If nContaEtq < sb5->B5_QE2
			nQtdFim := Abs(nContaEtq)
		Endif
		nProdCx	    := SB5->B5_QE1							// Quantidade Embalagem 1 - Checar campos EAN14
		cUnidDesp	:= "1"									// Unidade de Despacho - Fixo 1 - Verificar
		nQtdeCx 	:= 1
		cCaixa		:= Soma1(SB1->B1_CAIXA)
		cLote		:= Soma1(  Strzero( Val(SB1->B1_LOTECTL) ,5)  )
		cCxLote	    := ""
		cCodBarra	:= cUnidDesp + Left(SB1->B1_CODBAR,12)
		cEAN14		:= cCodBarra + CBDigVer(cCodBarra)
		nQtd   	    := 1

		ProcRegua(nQtdFim)

		Begin Transaction

			lFirst	:= .T.

			While nQtd <= nQtdFim

				IncProc()

				If nQtdeCx > nProdCx
					cCaixa  := Soma1(cCaixa)
					nQtdeCx := 1
					lFirst	:= .T.
				Endif

				nQtdeCx++

				//     If Empty(cSerie)
				//        cSerie := Soma1(sb1->b1_serie)
				//     Else
				//		  cSerie :=	Soma1(cSerie)
				//     Endif
				cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
				cSerieCompl := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

				cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
				cSerie      := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

				//cSerie	:=	Subs(cSerie,1,Len(cSerie)-6)  +  Strzero(Val( Right(cSerie,6) ) + 1),6)

				If lFirst
					lFirst     := .F.
					cPrimSerie := Right(cSerie,6)
				Endif

				SC5->(dbsetorder(1))
				CB9->(dbOrderNickName("CB9PRODSER"))
				CB9->(dbseek(xFilial('CB9')+SC2->C2_PRODUTO+cSerie))
				SC5->(dbseek(xFilial('SC5')+CB9->CB9_PEDIDO))

				AA3->(dbsetorder(6))
				If .NOT. AA3->(dbseek( xFilial('AA3') + cSerie ))
					AA3->(RecLock("AA3",.T.))
					AA3->AA3_CODCLI := SC5->C5_CLIENTE
					AA3->AA3_LOJA   := SC5->C5_LOJACLI
					AA3->AA3_CODPRO := SC2->C2_PRODUTO
					AA3->AA3_NUMSER := cSerie
					AA3->AA3_DTVEND := ddatabase
					AA3->(MsUnlock())
				Endif

				cBarra		:= Alltrim(SB1->B1_COD)+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Right(Strzero(Year(dDataBase),4),2)+cLote+cCaixa+cPrimSerie

				nQtd++

				If sb1->B1_TIPO = 'PE'
					ZA4->(RecLock("ZA4",.T.))

					ZA4->ZA4_FILIAL	:= xFilial('ZA4')
					ZA4->ZA4_COD	:= AA3->AA3_CODPRO
					ZA4->ZA4_EAN13	:= SB1->B1_CODBAR
					ZA4->ZA4_EAN14	:= cEAN14
					ZA4->ZA4_NSERIE	:= cSerieCompl
					ZA4->ZA4_DSCETQ	:= SB1->B1_DESC    //ZA4->ZA4_DSCETQ	:= SB1->B1_DESCETI
					ZA4->ZA4_DTFAB	:= DtoC(dDataBase)
					ZA4->ZA4_NCAIXA	:= cCaixa
					ZA4->ZA4_NLOTE	:= cLote
					ZA4->ZA4_USER	:= __CUSERID
					ZA4->ZA4_VOLTAG	:= SB1->B1_VOLTAG
					ZA4->ZA4_CXLOTE	:= cCxLote
					ZA4->ZA4_BARRA	:= cBarra
					ZA4->ZA4_NUMOP  := SC2->C2_NUM
					ZA4->ZA4_NUMSER := cSerie
					ZA4->ZA4_ETIQSL := 1

					za4->(MsUnlock())
				Endif

			End

		End Transaction


		RecLock("SB1",.F.)
		SB1->B1_LOTECTL := cLote
		SB1->B1_CAIXA	:= cCaixa
		SB1->(MsUnlock())

		If ! Empty(cSerie)
			sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
			sb1->(RecLock("SB1",.f.))
			sb1->b1_serie := cSerie
			sb1->(MsUnlock())

			sc2->(RecLock("SC2",.f.))
			sc2->c2_serie := cSerie
			sc2->(MsUnlock())
		Endif

		nContaEtq -= sb5->B5_QE2

	Next

	RestArea(xAlias)

RETURN NIL


//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
USER FUNCTION ABRE_ZA8()
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	Local cQuery     := ""

	cAliasImp := "ZA8"
	cQuery := "SELECT * FROM ZA8010"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasImp, .T., .F. )
	dbSelectArea(cAliasImp)
RETURN NIL


//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
USER FUNCTION STATUS_OS()
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	Local nQtd_Original := 0
	Local nBxa_Original := 0
	//Local cNumOs        := ""

	DbSelectArea("CB8")
	DbSetOrder(1)

	DbSelectArea("CB7")
	DbSetOrder(1)

	DbGotop()
	While !CB7->(EOF())
		If CB7->CB7_LOCAL='21' .AND. CB7->CB7_STATUS != '9' .and. CB7->CB7_DTEMIS < Ctod("26/07/2010")
			nQtd_Original := 0
			nBxa_Original := 0

			CB8->( dbseek(xFilial('CB8') + CB7->CB7_ORDSEP )  )
			While CB8->CB8_ORDSEP = CB7->CB7_ORDSEP .and. !CB8->(Eof())
				If CB8->CB8_LOCAL='21'
					nQtd_Original += CB8->CB8_QTDORI
					If CB8->CB8_SALDOS=0 .and. CB8->CB8_SALDOE = (CB8->CB8_QTDORI*-1)
						nBxa_Original += CB8->CB8_QTDORI
					Endif
				Endif
				CB8->(DbSkip())
			End

			If nQtd_Original = nBxa_Original .and. nQtd_Original > 0
				RecLock("CB7",.F.)
				CB7->CB7_STATUS := '9'
				MsUnLock()
			Endif
		Endif
		CB7->(DbSkip())
	Enddo
RETURN NIL

//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
USER FUNCTION BAIXA_TIT()
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	Local _cQuery := ""
	Local aVetor := {}

	_nHdl     := fcreate("ML_ETQ4.TMP", 0)
	_cDestino := "C:\LIXO\BANCO.TXT"

	_cQuery := "SELECT VL_ORIGI , VL_BAIXA, CD_BANCO, IsNull(CONVERT(CHAR(10),EE_CONTA),'') AS EE_AGENCIA , "
	_cQuery += "       IsNull(CONVERT(CHAR(10),EE_AGENCIA),'') AS EE_CONTA,  "
	_cQuery += "       CASE WHEN LEFT(EMPRESA,8)='MERCABEL' "
	_cQuery += "          THEN ' '+DUPLICATA ELSE DUPLICATA END AS E1_IDCNAB, "
	_cQuery += "       CASE WHEN IsNull(DT_BAIXA,'')='' "
	_cQuery += "          THEN CONVERT(char(12), CONVERT(DATETIME,DT_OCOR ), 103) "
	_cQuery += "          ELSE CONVERT(char(12), CONVERT(DATETIME,DT_BAIXA), 103) "
	_cQuery += "       END AS DT_CREDITO"
	_cQuery += "  FROM LINKMP10.LAYOUTS.DBO.RETCOM_BRADESCO ITT "
	_cQuery += " WHERE CD_OCOR='06' AND IsNull(VL_BAIXA,0) != 0 AND IsNull(VL_ORIGI,0) != 0 "
	_cQuery += "   AND EE_AGENCIA != '15553-1' AND LEFT(EMPRESA,8)!='MERCABEL' "
	_cQuery += "   AND ITT.DT_BAIXA < CONVERT(DATETIME,'06/30/2010') "
	// ****************
	// ****************
	//_cQuery += "  AND DUPLICATA='34986-4/4' " // titulo em carteira do tipo descotado
	//_cQuery += "  AND DUPLICATA='37116-1/1' "
	// ****************
	// ****************
	If Select("ITT") > 0
		ITT->(DbCloseArea())
	Endif

	TcQuery _cQuery NEW ALIAS ("ITT")

	DbSelectArea("ITT")

	ITT->(DbGotop())
	While !ITT->(Eof())
		SE1->(DbSetOrder(16))
		If SE1->(DbSeek( xFilial("SE1") + Rtrim(ITT->E1_IDCNAB) ))
			If SE1->E1_SALDO != 0 .and. SE1->E1_SALDO = SE1->E1_VALOR .and. ITT->VL_ORIGI=SE1->E1_VALOR .and. Empty(SE1->E1_BAIXA)

				cBancoSaldo := xFilial("SE8") + Alltrim(ITT->CD_BANCO)
				cBancoSaldo += Alltrim(ITT->EE_AGENCIA) + SPAC(5-LEN(Alltrim(ITT->EE_AGENCIA)))
				cBancoSaldo += Alltrim(ITT->EE_CONTA) + SPAC(10-LEN(Alltrim(ITT->EE_CONTA)))
				cBancoSaldo += DTOS(Ctod(ITT->DT_CREDITO))

				DbSelectArea("SE8")
				SE8->(DbSetOrder(1))
				If SE8->(DbSeek( cBancoSaldo ))
					RecLock("SE8",.F.)
					SE8->(DbDelete())
					MsUnLock()
				Endif
				DbSelectArea("ITT")

				//
				// Titulo nao baixado com saldo igual ao valor do titulo e valor do titulo igual ao valor original no CNAB
				//
				lMsErroAuto := .F.

				aVetor := {{"E1_FILIAL"	,SE1->E1_FILIAL    ,Nil},;
					{"E1_PREFIXO"	,SE1->E1_PREFIXO   ,Nil},;
					{"E1_NUM"		,SE1->E1_NUM       ,Nil},;
					{"E1_PARCELA"	,SE1->E1_PARCELA   ,Nil},;
					{"E1_TIPO"	    ,SE1->E1_TIPO      ,Nil},;
					{"AUTMOTBX"	    ,"NOR"             ,Nil},;
					{"AUTDTBAIXA"	,Ctod(ITT->DT_CREDITO)     ,Nil},;
					{"AUTDTCREDITO" ,Ctod(ITT->DT_CREDITO)     ,Nil},;
					{"AUTHIST"	    ,'BA TI em '+Dtoc(ddatabase)+" "+Time() ,Nil},;
					{"AUTVALREC"    ,SE1->E1_SALDO     , Nil }  ,;
					{"AUTBANCO"	    ,Alltrim(ITT->CD_BANCO)    ,Nil},;
					{"AUTAGENCIA"	,Alltrim(ITT->EE_AGENCIA)  ,Nil},;
					{"AUTCONTA"	    ,Alltrim(ITT->EE_CONTA)    ,Nil},;
					{"AUTDESCONT"	,0               ,Nil},;
					{"AUTDECRESC"   ,0               ,Nil},;
					{"AUTACRESC"    ,0               ,Nil},;
					{"AUTMULTA"     ,0               ,Nil},;
					{"AUTJUROS"     ,0               ,Nil}}

				MSExecAuto({|x,y| fina070(x,y)},aVetor,3) //Inclusao

				If lMsErroAuto

					MostraErro()

					_sComando := "Titulo: " + SE1->E1_NUM + " Parcela: " + SE1->E1_PARCELA
					_sComando += " Prefixo: " + SE1->E1_PREFIXO
					_sComando += " - BAIXA DE TITULO: SALDO IGUAL AO VALOR ORIGINAL - SDQ01 error" + CHR(13) + CHR(10)

					fwrite (_nHdl, _sComando)
				Else
					_sComando := "Titulo: " + SE1->E1_NUM + " Parcela: " + SE1->E1_PARCELA
					_sComando += " Prefixo: " + SE1->E1_PREFIXO
					_sComando += " - BAIXA DE TITULO: SALDO IGUAL AO VALOR ORIGINAL - SDQ01" + CHR(13) + CHR(10)

					fwrite (_nHdl, _sComando)
				Endif
			ElseIf SE1->E1_SALDO > 0 .and. SE1->E1_VALOR = ITT->VL_ORIGI .and. !Empty(SE1->E1_BAIXA) .AND. SE1->E1_VALLIQ < ITT->VL_BAIXA .and. SE1->E1_VALOR = (SE1->E1_VALLIQ+SE1->E1_SALDO)
				//
				// Liquidacao parcial ex.: E1_IDCNAB MERCABEL = 37313-1/1 ou 37939-1/1
				//
			ElseIf SE1->E1_SALDO > 0 .AND. SE1->E1_VALLIQ = ITT->VL_BAIXA .AND. SE1->E1_VALOR > ITT->VL_ORIGI .and. !Empty(SE1->E1_BAIXA)
				//
				// Titulo liquidado porem o valor liquidado via CNAB é superior ao valor original PROTHEUS sobrou saldo ex.: E1_IDCNAB MERCABEL = 40599-1/3
				//
			EndIf
		EndIf
		ITT->(DbSkip())
	End

	fclose (_nHdl)
	copy file ML_ETQ4.TMP to (alltrim (_cDestino))
	delete file ML_ETQ4.TMP

RETURN NIL


//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
USER FUNCTION CARGA_GPE()
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	//------------------------------------------------------------------------------------------------------------//
	// Rotina para carga de dados da tabela SR1 (origem) para SRC (destino) executar apenas uma vez
	//
	//
	IF 1=2
		//
		//

		DbSelectArea("SR1")
		DbGotop()
		While !SR1->(EOF())
			If (SR1->R1_PD = "325" .or. SR1->R1_PD = "465") .and. SR1->R1_DATA=ctod("31/07/2010")
				DbSelectArea("SRC")
				RecLock("SRC",.T.)
				SRC->RC_FILIAL	:= SR1->R1_FILIAL
				SRC->RC_MAT		:= SR1->R1_MAT
				SRC->RC_PD		:= SR1->R1_PD
				SRC->RC_TIPO1	:= SR1->R1_TIPO1
				SRC->RC_HORAS	:= SR1->R1_HORAS
				SRC->RC_VALOR	:= SR1->R1_VALOR
				SRC->RC_DATA	:= SR1->R1_DATA
				SRC->RC_SEMANA	:= SR1->R1_SEMANA
				SRC->RC_CC		:= SR1->R1_CC
				SRC->RC_PARCELA:= SR1->R1_PARCELA
				SRC->RC_TIPO2	:= SR1->R1_TIPO2
				MsUnLock()
			EndIf
			DbSelectArea("SR1")
			SR1->(DbSkip())
		End
		SR1->( dbCloseArea() )
		SC1->( dbCloseArea() )
		IF EmpOpenFile("SR1","SR1",1,.T.,"02","C")        // Empresa - MERCABEL
			IF EmpOpenFile("SC1","SC1",1,.T.,"02","C")
				DbSelectArea("SR1")
				DbGotop()
				While !SR1->(EOF())
					If (SR1->R1_PD = "325" .or. SR1->R1_PD = "465") .and. SR1->R1_DATA=ctod("31/07/2010")
						DbSelectArea("SRC")
						RecLock("SRC",.T.)
						SRC->RC_FILIAL	:= SR1->R1_FILIAL
						SRC->RC_MAT		:= SR1->R1_MAT
						SRC->RC_PD		:= SR1->R1_PD
						SRC->RC_TIPO1	:= SR1->R1_TIPO1
						SRC->RC_HORAS	:= SR1->R1_HORAS
						SRC->RC_VALOR	:= SR1->R1_VALOR
						SRC->RC_DATA	:= SR1->R1_DATA
						SRC->RC_SEMANA	:= SR1->R1_SEMANA
						SRC->RC_CC		:= SR1->R1_CC
						SRC->RC_PARCELA:= SR1->R1_PARCELA
						SRC->RC_TIPO2	:= SR1->R1_TIPO2
						MsUnLock()
					EndIf
					DbSelectArea("SR1")
					SR1->(DbSkip())
				End
			EndIf
		EndIf

		SR1->( dbCloseArea() )
		SC1->( dbCloseArea() )
		IF EmpOpenFile("SR1","SR1",1,.T.,"03","C")        // Empresa - PROART
			IF EmpOpenFile("SC1","SC1",1,.T.,"03","C")
				DbSelectArea("SR1")
				DbGotop()
				While !SR1->(EOF())
					If (SR1->R1_PD = "325" .or. SR1->R1_PD = "465") .and. SR1->R1_DATA=ctod("31/07/2010")
						DbSelectArea("SRC")
						RecLock("SRC",.T.)
						SRC->RC_FILIAL	:= SR1->R1_FILIAL
						SRC->RC_MAT		:= SR1->R1_MAT
						SRC->RC_PD		:= SR1->R1_PD
						SRC->RC_TIPO1	:= SR1->R1_TIPO1
						SRC->RC_HORAS	:= SR1->R1_HORAS
						SRC->RC_VALOR	:= SR1->R1_VALOR
						SRC->RC_DATA	:= SR1->R1_DATA
						SRC->RC_SEMANA	:= SR1->R1_SEMANA
						SRC->RC_CC		:= SR1->R1_CC
						SRC->RC_PARCELA:= SR1->R1_PARCELA
						SRC->RC_TIPO2	:= SR1->R1_TIPO2
						MsUnLock()
					EndIf
					DbSelectArea("SR1")
					SR1->(DbSkip())
				End
			EndIf
		EndIf

		//
		//
	EndIf
	//
	//
RETURN NIL

User Function fVendor()
	Local aQtEmb, nPesoLiq, nPesoBru, nPosQtEmb, nQtd
	Local cChave := ""
	Local nX := 0

	cChave := "0000041681  00207903"

	aQtEmb	 := {}
	nPesoLiq := 0
	nPesoBru := 0

	SD2->(DbSetOrder(3))
	SD2->(DbSeek( xFilial("SD2") + cChave ))
	Do While SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) = xFilial("SD2") + cChave .And. ! SD2->(Eof())

		SB5->(DbSeek(xFilial("SB5")+SD2->D2_COD))

		SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))

		nPosQtEmb := Ascan(aQtEmb,{ |x| x[1] = SB5->B5_QE1 })
		If Empty(nPosQtEmb)
			Aadd(aQtEmb,{SB5->B5_QE1,0})
			nPosQtEmb := Len(aQtEmb)
		EndIf
		aQtEmb[nPosQtEmb,2]	+= SD2->D2_QUANT
		nPesoLiq			+= (SB1->B1_PESO	* SD2->D2_QUANT)
		nPesoBru			+= (SB1->B1_PESBRU	* SD2->D2_QUANT)

		SD2->(DbSkip())
	EndDo

	nQtEmb := 0

	For nX := 1 to Len(aQtEmb)

		If aQtEmb[nX,1] <> 0
			nQtd 	:= ( aQtEmb[nX,2] / aQtEmb[nX,1] )
			nQtEmb	+= ( Int(nQtd) + If( nQtd > Int(nQtd),  1, 0) )
		Endif

	Next nX

	nEmbala := nQtEmb

	cChave := ""

Return (lRetorno)


//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
// Função para atualizar campo na tabela CB7 do campo status e data de saida conforme movimentação na WEB
// Observação: Somente para MERCABEL
//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
User Function AjustaCB7()
	IF EmpOpenFile("CB7","CB7",1,.T.,"02","C") // 02 - empresa MERCABEL

		DbSelectArea("CB7")
		DbSetOrder(1)

		_cQuery := "SELECT CB7_ORDSEP, "
		_cQuery += "     CB7_STATUS,    "
		_cQuery += "     CB7_NOTA,       "
		_cQuery += "     CB7_LOJA,        "
		_cQuery += "	 CB7.R_E_C_N_O_ AS R_E_C_N_O_, "
		_cQuery += "     LEFT(SA1.A1_NOME,40) AS CLIENTE  "
		_cQuery += "    ,CONVERT(char(12), CONVERT(DATETIME,CB7_DTFIMS), 103) AS CB7_DTFIMS"
		_cQuery += "    ,CONVERT(char(12), CONVERT(DATETIME,DT_SAIDA), 103) AS DT_SAIDA     "
		_cQuery += "	,NRO_NOTAFISCALVENDAS AS NF_WEB"
		_cQuery += "	,dt_emissaonfvendaS AS EMISSAO_WEB"
		_cQuery += "	,("
		_cQuery += "		SELECT SUM(CB8.CB8_QTDORI)"
		_cQuery += "		FROM CB8020 CB8 WHERE CB8.CB8_ORDSEP=CB7.CB7_ORDSEP AND CB8.D_E_L_E_T_ != '*'     "
		_cQuery += "	 ) AS SALDO_A_SEPARAR"
		_cQuery += "	,("
		_cQuery += "		SELECT SUM (CB8.CB8_SALDOE*-1)"
		_cQuery += "		FROM CB8020 CB8 WHERE CB8.CB8_ORDSEP=CB7.CB7_ORDSEP AND CB8.D_E_L_E_T_ != '*'     "
		_cQuery += "						AND (CB8.CB8_SALDOS=0 AND CB8.CB8_SALDOE = (CB8.CB8_QTDORI*-1))"
		_cQuery += "	 ) AS SALDO_EMBARCADO"
		_cQuery += "  FROM CB7020 CB7 "
		_cQuery += "  INNER JOIN SA1020 SA1 ON SA1.A1_LOJA=CB7.CB7_LOJA AND SA1.A1_COD=CB7.CB7_CLIENT AND SA1.D_E_L_E_T_ != '*'"
		_cQuery += "  INNER JOIN LINKMP10.MERCABEL.DBO.vendas_nfs NFS ON NFS.NRO_NOTAFISCALVENDAS=CB7.CB7_NOTA "
		_cQuery += "													AND status_separacao='DE'                            "
		_cQuery += "													AND dt_emissaonfvendaS > '2010-03-30 23:59:59'        "
		_cQuery += "													AND dt_emissaonfvendaS < '2010-08-19 00:00:00'         "
		_cQuery += "													AND NFS.SERIE_NF='55'                                   "
		_cQuery += " WHERE CB7.CB7_FILIAL = '01'                                                                    "
		_cQuery += "	AND CB7.D_E_L_E_T_ != '*'                                                                     "
		_cQuery += "	AND CB7.CB7_STATUS > '1' AND CB7.CB7_STATUS < '9' AND CB7.CB7_LOCAL='21'                       "
		_cQuery += "	AND                                                                                             "
		_cQuery += "	(                                                                                                "
		_cQuery += "		SELECT SUM(CB8.CB8_QTDORI)                                                                     "
		_cQuery += "		FROM CB8020 CB8 WHERE CB8.CB8_ORDSEP=CB7.CB7_ORDSEP AND CB8.D_E_L_E_T_ != '*'                   "
		_cQuery += "	 ) > 0                                                                                              "
		_cQuery += "	AND                                                                                                  "
		_cQuery += "	(                                                                                                     "
		_cQuery += "		SELECT SUM(CB8.CB8_QTDORI)                                                                          "
		_cQuery += "		FROM CB8020 CB8 WHERE CB8.CB8_ORDSEP=CB7.CB7_ORDSEP AND CB8.D_E_L_E_T_ != '*'                        "
		_cQuery += "	 ) =                                                                               "
		_cQuery += "	(                                                                                  "
		_cQuery += "		SELECT SUM(CB8.CB8_SALDOE*-1)                                                   "
		_cQuery += "		FROM CB8020 CB8 WHERE CB8.CB8_ORDSEP=CB7.CB7_ORDSEP AND CB8.D_E_L_E_T_ != '*'    "
		_cQuery += "						AND (CB8.CB8_SALDOS=0 AND CB8.CB8_SALDOE = (CB8.CB8_QTDORI*-1))       "
		_cQuery += "	 )                                                                                    "
		_cQuery += "  ORDER BY CB7.CB7_ORDSEP                                                                 "


		If Select("ITT") > 0
			ITT->(DbCloseArea())
		Endif

		TcQuery _cQuery NEW ALIAS ("ITT")

		DbSelectArea("ITT")

		ITT->(DbGotop())
		While !ITT->(Eof())
			_cEmissao := ITT->DT_SAIDA
			If CB7->(DbSeek( xFilial("CB7")+ITT->CB7_ORDSEP ))
				If CB7->CB7_LOCAL='21'
					CB7->(RecLock("CB7",.f.))
					CB7->CB7_STATUS := "9"
					CB7->CB7_STATPA := " "
					CB7->CB7_DTFIMS := Ctod( _cEmissao )
					CB7->(MsUnlock())
				Endif
			Endif
			ITT->(DbSkip())
		End
	EndIf
Return Nil
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
// Função para atualizar campo B1_CODBAR na tabela SB1 da MERCABEL com base nos dados da DAIHATSU
// Somente para os campos divergentes
//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
User Function BarCodMer()
	Local _cQuery := ""

	IF EmpOpenFile("SB1","SB1",1,.T.,"02","C") // 02 - empresa MERCABEL

		_cQuery := "SELECT DAI.B1_CODBAR,DAI.B1_COD "
		_cQuery += "	FROM SB1010 DAI "
		_cQuery += "INNER JOIN SB1020 MER ON DAI.B1_COD=MER.B1_COD AND MER.D_E_L_E_T_ != '*' AND MER.B1_TIPO='PE'"
		_cQuery += "   WHERE DAI.D_E_L_E_T_ != '*' "
		_cQuery += "	  AND DAI.B1_TIPO='PE' "
		_cQuery += "	  AND MER.B1_CODBAR != DAI.B1_CODBAR "
		_cQuery += "     AND DAI.B1_CODBAR!=''"

		If Select("ITT") > 0
			ITT->(DbCloseArea())
		Endif

		TcQuery _cQuery NEW ALIAS ("ITT")

		DbSelectArea("ITT")

		ITT->(DbGotop())
		While !ITT->(Eof())
			If SB1->(DbSeek( xFilial("SB1") + ITT->B1_COD ))
				SB1->(RecLock("SB1",.f.))
				SB1->B1_CODBAR := ITT->B1_CODBAR
				SB1->(MsUnlock())
			Endif
			ITT->(DbSkip())
		Enddo

	Endif
Return Nil

//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
// Baixa de titulos de contas a pagar
//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
User Function BxPagar080()



	cFilAnt:= aDados[nI][1] // Filial
	aAdd(aTitulo, {"E2_FILIAL"		,aDados[nI][1]			,nil})
	aAdd(aTitulo, {"E2_PREFIXO"	,aDados[nI][2]			,nil})
	aAdd(aTitulo, {"E2_NUM"			,aDados[nI][3]			,nil})
	aAdd(aTitulo, {"E2_PARCELA"	,aDados[nI][4]			,nil})
	aAdd(aTitulo, {"E2_TIPO"		,aDados[nI][5]			,nil})
	aAdd(aTitulo, {"E2_FORNECE"	,aDados[nI][6]			,nil})
	aAdd(aTitulo, {"E2_LOJA"		,aDados[nI][7]			,nil})
	aAdd(aTitulo, {"AUTDTCREDITO"	,aDados[nI][8]			,nil})
	aAdd(aTitulo, {"AUTBANCO"     ,MV_PAR01				,nil})
	aAdd(aTitulo, {"AUTAGENCIA"	,MV_PAR02				,nil})
	aAdd(aTitulo, {"AUTCONTA"		,MV_PAR03				,nil})
	aAdd(aTitulo, {"AUTMOTBX"		,"NOR"					,nil})
	aAdd(aTitulo, {"AUTDTBAIXA"	,dDataBase				,nil})
	aAdd(aTitulo, {"AUTHIST"		,"Baixa SCO PAGAR"	,nil})

	MSExecAuto({|x,y| FINA080(x,y)},aTitulo,3)

Return NIL
