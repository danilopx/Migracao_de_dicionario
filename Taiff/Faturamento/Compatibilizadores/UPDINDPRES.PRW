#INCLUDE "protheus.ch"

#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

//--------------------------------------------------------------------
/*/{Protheus.doc} UPDC5CP1
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDINDPRES( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUAL. DICIONARIOS - NT 2020.006 v1.20 Sefaz - 12-AGO-2021"
Local   cDesc1    := "Serao criados campos ref. Indicador de Presenca e Intermediador:"
Local   cDesc2    := "C5_INDPRES, C5_CODA1U, CJ_INDPRES, CJ_CODA1U, F1_INDPRES, F1_CODA1U,"
Local   cDesc3    := "F2_CODA1U, L1_INTERMD, L1_INDPRES, LQ_INTERMD, LQ_INDPRES, UA_CODA1U,"
Local   cDesc4    := "UA_INDPRES, A1U_FILIAL, A1U_CODIGO, A1U_NOME e A1U_CGC."
Local   cDesc5    := ""
Local   cMsg      := ""
Local   lOk       := .F.
Local   lAuto     := ( cEmpAmb <> NIL .or. cFilAmb <> NIL )

Private oMainWnd  := NIL
Private oProcess  := NIL

#IFDEF TOP
    TCInternal( 5, "*OFF" ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

If lAuto
	lOk := .T.
Else
	FormBatch(  cTitulo,  aSay,  aButton )
EndIf

If lOk

	If FindFunction( "MPDicInDB" ) .AND. MPDicInDB()
		cMsg := "Este update NAO PODE ser executado neste Ambiente." + CRLF + CRLF + ;
				"Os arquivos de dicionarios se encontram no Banco de Dados e este update esta preparado " + ;
				"para atualizar apenas ambientes com dicionarios no formato ISAM (.dbf ou .dtc)."

		If lAuto
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZACAO DOS DICIONARIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( cMsg )
			ConOut( DToC(Date()) + "|" + Time() + cMsg )
		Else
			MsgInfo( cMsg )
		EndIf

		Return NIL
	EndIf

	If lAuto
		aMarcadas :={{ cEmpAmb, cFilAmb, "" }}
	Else

		aMarcadas := EscEmpresa()
	EndIf

	If !Empty( aMarcadas )
		If lAuto .OR. MsgNoYes( "Confirma a atualizacao dos dicionarios ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualizacao Realizada.", "UPDC5CP1" )
				Else
					MsgStop( "Atualizacao nao Realizada.", "UPDC5CP1" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualizacao Realizada." )
				Else
					Final( "Atualizacao nao Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualizacao nao Realizada." )

		EndIf

	Else
		Final( "Atualizacao nao Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cFile     := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nX        := 0
Local   oDlg      := NIL
Local   oFont     := NIL
Local   oMemo     := NIL

Private aArqUpd   := {}

If ( lOpen := MyOpenSm0(.T.) )

	dbSelectArea( "SM0" )
	dbGoTop()

	While !SM0->( EOF() )
		// Só adiciona no aRecnoSM0 se a empresa for diferente
		If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
		   .AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
			aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
		EndIf
		SM0->( dbSkip() )
	End

	SM0->( dbCloseArea() )

	If lOpen

		For nI := 1 To Len( aRecnoSM0 )

			If !( lOpen := MyOpenSm0(.F.) )
				MsgStop( "Atualizacao da empresa " + aRecnoSM0[nI][2] + " nao efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZACAO DOS DICIONARIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Inicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versao.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuario da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estacao............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexao............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )


			oProcess:IncRegua1( "Dicionario de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX2()


			FSAtuSX3()


			oProcess:IncRegua1( "Dicionário de índices" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSIX()

			oProcess:IncRegua1( "Dicionário de dados" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			oProcess:IncRegua2( "Atualizando campos/índices" )

			// Alteração física dos arquivos
			__SetX31Mode( .F. )

			If FindFunction(cTCBuild)
				cTopBuild := &cTCBuild.()
			EndIf

			For nX := 1 To Len( aArqUpd )

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					If ( ( aArqUpd[nX] >= "NQ " .AND. aArqUpd[nX] <= "NZZ" ) .OR. ( aArqUpd[nX] >= "O0 " .AND. aArqUpd[nX] <= "NZZ" ) ) .AND.;
						!aArqUpd[nX] $ "NQD,NQF,NQP,NQT"
						TcInternal( 25, "CLOB" )
					EndIf
				EndIf

				If Select( aArqUpd[nX] ) > 0
					dbSelectArea( aArqUpd[nX] )
					dbCloseArea()
				EndIf

				X31UpdTable( aArqUpd[nX] )

				If __GetX31Error()
					Alert( __GetX31Trace() )
					MsgStop( "Ocorreu um erro desconhecido durante a atualizacao da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionario e da tabela.", "ATENCAO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualizacao concluida." From 3, 0 to 340, 417 Pixel

			@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
			oMemo:bRClicked := { || AllwaysTrue() }
			oMemo:oFont     := oFont

			Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
			Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, "" ), If( cFile == "", .T., ;
			MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel

			Activate MsDialog oDlg Center

		EndIf

	EndIf

Else

	lRet := .F.

EndIf

Return lRet


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX2
Função de processamento da gravação do SX2 - Arquivos

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX2()
Local aEstrut   := {}
Local aSX2      := {}
Local cAlias    := ""
Local cCpoUpd   := "X2_ROTINA /X2_UNICO  /X2_DISPLAY/X2_SYSOBJ /X2_USROBJ /X2_POSLGT /"
Local cEmpr     := ""
Local cPath     := ""
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Inicio da Atualizacao" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

aAdd( aSX2, {'A1U',cPath,'A1U'+cEmpr,'Intermediadores','Intermediadores','Mediators','C','','','S','A1U_FILIAL+A1U_CODIGO','','FATA760','','1','2','2','E','E',5} )
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( "SX2" )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	oProcess:IncRegua2( "Atualizando Arquivos (SX2)..." )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + "/"
			AutoGrLog( "Foi incluida a tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == "X2_ARQUIVO"
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  "0" )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf
			EndIf
		Next nJ
		MsUnLock()

	Else

		If  !( StrTran( Upper( AllTrim( SX2->X2_UNICO ) ), " ", "" ) == StrTran( Upper( AllTrim( aSX2[nI][12]  ) ), " ", "" ) )
			RecLock( "SX2", .F. )
			SX2->X2_UNICO := aSX2[nI][12]
			MsUnlock()

			If MSFILE( RetSqlName( aSX2[nI][1] ),RetSqlName( aSX2[nI][1] ) + "_UNQ"  )
				TcInternal( 60, RetSqlName( aSX2[nI][1] ) + "|" + RetSqlName( aSX2[nI][1] ) + "_UNQ" )
			EndIf

			AutoGrLog( "Foi alterada a chave unica da tabela " + aSX2[nI][1] )
		EndIf

		RecLock( "SX2", .F. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If PadR( aEstrut[nJ], 10 ) $ cCpoUpd
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
				EndIf

			EndIf
		Next nJ
		MsUnLock()

	EndIf

Next nI

AutoGrLog( CRLF + "Final da Atualizacao" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX3()
Local aEstrut   := {}
Local aSX3      := {}
Local cAlias    := ""
Local cAliasAtu := ""
Local cSeqAtu   := ""
Local cX3Campo  := ""
Local cX3Dado   := ""
Local nI        := 0
Local nJ        := 0
Local nPosArq   := 0
Local nPosCpo   := 0
Local nPosOrd   := 0
Local nPosSXG   := 0
Local nPosTam   := 0
Local nPosVld   := 0
Local nSeqAtu   := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )

AutoGrLog( "Ínicio da Atualizacao" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


aAdd( aSX3, {{'A1U',.T.},{'01',.T.},{'A1U_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do sistema',.T.},{'Sucursal del sistema',.T.},{'System branch',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'A1U',.T.},{'02',.T.},{'A1U_CODIGO',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Código',.T.},{'Código',.T.},{'Code',.T.},{'Código do intermediador',.T.},{'Código de intermediador',.T.},{'Agent Code',.T.},{'@!',.T.},{'NaoVazio().And. ExistChav("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(176),.T.},{'GetSXENum("A1U","A1U_CODIGO")',.T.},{'',.T.},{1,.T.},{Chr(133) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'IIF(ALTERA,.F.,.T.)',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'S',.T.}} )
aAdd( aSX3, {{'A1U',.T.},{'03',.T.},{'A1U_NOME',.T.},{'C',.T.},{60,.T.},{0,.T.},{'Nome',.T.},{'Nomb',.T.},{'Name',.T.},{'Nome do intermediador',.T.},{'Nombre intermediador',.T.},{'Agent Name',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(149) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'S',.T.}} )
aAdd( aSX3, {{'A1U',.T.},{'04',.T.},{'A1U_CGC',.T.},{'C',.T.},{14,.T.},{0,.T.},{'CNPJ',.T.},{'CNPJ',.T.},{'EIN',.T.},{'CNPJ do intermediador',.T.},{'CNPJ de intermediador',.T.},{'Agent EIN',.T.},{'@R 99.999.999/9999-99',.T.},{'FT760CGC(M->A1U_CGC)',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(133) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'IIF(ALTERA,.F.,.T.)',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SC5',.T.},{'I2',.T.},{'C5_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presenca Com',.T.},{'Presenc Comp',.T.},{'Purchaser',.T.},{'Presenca Comprador',.T.},{'Presencia del comprador',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence(" 0/1/2/3/5/9")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'"9"',.T.},{'',.T.},{0,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'0=Não Aplica;1=Presencial;2=Não Presencial,Net;3=Não Presencial,TeleAtendi.;5=Presencial,ForadoEstab.;9=Não Presencial,outros',.T.},{'0=No Aplica;1=Presencial;2=No Presencial,Net;3=No Presencial,TeleAtenc.;5=Presencial,FueraEstab.;9=No Presencial,otros',.T.},{'0=Not applicable;1=Presential;2=Non Presential,Net;3=Not Presential,Remote serv;5=Presential,;off-site9=Non Presential,other',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'N',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SC5',.T.},{'O7',.T.},{'C5_CODA1U',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Med.Code',.T.},{'Código Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .Or. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(134) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'AliasInDic("A1U") .And. FindFunction("FATA760")',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SCJ',.T.},{'92',.T.},{'CJ_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presença Com',.T.},{'Presencia Co',.T.},{'Purch.Pres.',.T.},{'Presença Comprador',.T.},{'Presencia Comprad',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence(" 012359")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(134) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'0=Não aplica;1=Presencial;2=Não Presencial,Net;3=Não Presencial,Teleatend.;5=Presencial,Fora do Estab.;9=Não Presencial,Outros',.T.},{'0=No aplica;1=Presencial;2=No presencial,Net;3=No presencial,Teleatenc.;5=Presencial,FueradeEstab.;9=No presencial,otros',.T.},{'0=Not Applicable;1=On site;2=Not on Site,Web;3=Not on site,Teleservic;5=On site, Out of Facil.;9=Not on Site, Others',.T.},{'',.T.},{'AliasInDic("A1U").AND.FindFunction("FATA760")',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SCJ',.T.},{'93',.T.},{'CJ_CODA1U',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cód. Interme',.T.},{'Cód. Interm',.T.},{'Mediator Cd',.T.},{'Código do Intermediador',.T.},{'Código de intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .OR. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(134) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'AliasInDic("A1U").AND.FindFunction("FATA760")',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SF1',.T.},{'L5',.T.},{'F1_CODA1U',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Mediator Cd',.T.},{'Codigo Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .Or. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SF1',.T.},{'L6',.T.},{'F1_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presença Com',.T.},{'Presencia Co',.T.},{'Purch.Pres.',.T.},{'Presença Comprador',.T.},{'Presencia Comprador',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence(" 0/1/2/3/4/5/9")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'0=Não Aplica;1=Presencial;2=Não Presencial,Net;3=Não Presencial,Tel;4=NFC-e;5=Presencial,ForadoEstab.;9=Não Presencial,outros',.T.},{'0=No aplica;1=Presencial;2=No presencial,Net;3=No presencial,Tel;4=e-FactC;5=Presencial,FueradeEstab.;9=No presencial,otros',.T.},{'0=Not Applicable;1=On site;2=Not on Site,Net;3=Not on site,Phone;4=NFC-e;5=On site,OutofFac.;9=Not on Site,others',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SF2',.T.},{'O7',.T.},{'F2_CODA1U',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Med.Code',.T.},{'Código Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(134) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SL1',.T.},{'L7',.T.},{'L1_INTERMD',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Mediator Cd',.T.},{'Código Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .Or. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(132) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SL1',.T.},{'L8',.T.},{'L1_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presença com',.T.},{'Presencia Co',.T.},{'Presence wit',.T.},{'Presença Comprador',.T.},{'Presencia Comprador',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence("1/2/3/4/5/9")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'"1"',.T.},{'',.T.},{1,.T.},{Chr(132) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'1=Presencial;2=Não Presencial;3=Não Presenc. TeleAtendi.;4=Entrega Domicilio;5=Presencial,ForaEstab.;9=Não Presencial,outros',.T.},{'1=Presencial;2=No presencial;3=No Presenc. Teleatenc.;4=Entrega domicilio;5=Presencial,FueraEstab.;9=No presencial,otros',.T.},{'1=On site;2=Not on Site,Net;3=Not on site,Teleservic;4=Home Delivery;5=On site,Out of the facility;9=Not on Site,others',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SLQ',.T.},{'K7',.T.},{'LQ_INTERMD',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Mediator Cd',.T.},{'Codigo Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .Or. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(132) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SLQ',.T.},{'K8',.T.},{'LQ_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presença Com',.T.},{'Presencia Co',.T.},{'Purch.Pres.',.T.},{'Presença Comprador',.T.},{'Presencia Comprador',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence("1/2/3/4/5/9")',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'"1"',.T.},{'',.T.},{1,.T.},{Chr(132) + Chr(192),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'1=Presencial;2=Não Presencial;3=Não Presenc. TeleAtendi.;4=Entrega Domicilio;5=Presencial,ForaEstab.;9=Não Presencial,outros',.T.},{'1=Presencial;2=Não Presencial;3=Não Presenc. Teleatenc.;4=Entrega domicilio;5=Presencial,FueraEstab.;9=No presencial,otros',.T.},{'1=On site;2=Not on Site,Net;3=Not on site,Teleservic;4=Home Delivery;5=On site,Out of the facility;9=Not on Site,others',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SUA',.T.},{'99',.T.},{'UA_CODA1U',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod Intermed',.T.},{'Cód Intermed',.T.},{'Mediator Cd',.T.},{'Código Intermediador',.T.},{'Código intermediador',.T.},{'Mediator Code',.T.},{'@!',.T.},{'Vazio() .Or. ExistCpo("A1U")',.T.},{ Chr(128) + Chr(130) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'A1U',.T.},{1,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'AliasInDic("A1U") .And. FindFunction("FATA760")',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )
aAdd( aSX3, {{'SUA',.T.},{'A0',.T.},{'UA_INDPRES',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Presença Com',.T.},{'Presencia Co',.T.},{'Purch.Pres.',.T.},{'Presença Comprador',.T.},{'Presencia Comprador',.T.},{'Purchaser Presence',.T.},{'@!',.T.},{'Pertence(" 0/1/2/3/5/9")',.T.},{ Chr(128) + Chr(130) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(132) + Chr(128),.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'0=Não Aplica;1=Presencial;2=Não Presencial,Net;3=Não Presencial,TeleAtendi.;5=Presencial,ForadoEstab.;9=Não Presencial,outros',.T.},{'0=No aplica;1=Presencial;2=No presencial,Net;3=No presencial,Teleatenc.;5=Presencial,FueradeEstab.;9=No presencial,otros',.T.},{'0=Not Applicable;1=On site;2=Not on Site,Net;3=Not on site,Teleservic;5=On site,Out of State;9=Not on Site,others',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'1',.T.},{'N',.T.},{'',.T.},{'2',.T.},{'S',.T.}} )

//
// Atualizando dicionário
//
nPosArq := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ARQUIVO" } )
nPosOrd := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_ORDEM"   } )
nPosCpo := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_CAMPO"   } )
nPosTam := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_TAMANHO" } )
nPosSXG := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_GRPSXG"  } )
nPosVld := aScan( aEstrut, { |x| AllTrim( x[1] ) == "X3_VALID"   } )

aSort( aSX3,,, { |x,y| x[nPosArq][1]+x[nPosOrd][1]+x[nPosCpo][1] < y[nPosArq][1]+y[nPosOrd][1]+y[nPosCpo][1] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( "SX3" )
dbSetOrder( 2 )
cAliasAtu := ""

For nI := 1 To Len( aSX3 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX3[nI][nPosSXG][1] )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX3[nI][nPosSXG][1] ) )
			If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
				aSX3[nI][nPosTam][1] := SXG->XG_SIZE
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NAO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				" por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	SX3->( dbSetOrder( 2 ) )

	If !( aSX3[nI][nPosArq][1] $ cAlias )
		cAlias += aSX3[nI][nPosArq][1] + "/"
		aAdd( aArqUpd, aSX3[nI][nPosArq][1] )
	EndIf

	If !SX3->( dbSeek( PadR( aSX3[nI][nPosCpo][1], nTamSeek ) ) )

		//
		// Busca ultima ocorrencia do alias
		//
		If ( aSX3[nI][nPosArq][1] <> cAliasAtu )
			cSeqAtu   := "00"
			cAliasAtu := aSX3[nI][nPosArq][1]

			dbSetOrder( 1 )
			SX3->( dbSeek( cAliasAtu + "ZZ", .T. ) )
			dbSkip( -1 )

			If ( SX3->X3_ARQUIVO == cAliasAtu )
				cSeqAtu := SX3->X3_ORDEM
			EndIf

			nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
		EndIf

		nSeqAtu++
		cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )

		RecLock( "SX3", .T. )
		For nJ := 1 To Len( aSX3[nI] )
			If     nJ == nPosOrd  // Ordem
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), cSeqAtu ) )

			ElseIf aEstrut[nJ][2] > 0
				SX3->( FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] ) )

			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		AutoGrLog( "Criado campo " + aSX3[nI][nPosCpo][1] )

	Else

		//
		// Verifica se o campo faz parte de um grupo e ajsuta tamanho
		//
		If !Empty( SX3->X3_GRPSXG ) .AND. SX3->X3_GRPSXG <> aSX3[nI][nPosSXG][1]
			SXG->( dbSetOrder( 1 ) )
			If SXG->( MSSeek( SX3->X3_GRPSXG ) )
				If aSX3[nI][nPosTam][1] <> SXG->XG_SIZE
					aSX3[nI][nPosTam][1] := SXG->XG_SIZE
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NAO atualizado e foi mantido em [" + ;
					AllTrim( Str( SXG->XG_SIZE ) ) + "]"+ CRLF + ;
					"   por pertencer ao grupo de campos [" + SX3->X3_GRPSXG + "]" + CRLF )
				EndIf
			EndIf
		EndIf

		//
		// Verifica todos os campos
		//
		For nJ := 1 To Len( aSX3[nI] )

			If aSX3[nI][nJ][2]
				cX3Campo := AllTrim( aEstrut[nJ][1] )
				cX3Dado  := SX3->( FieldGet( aEstrut[nJ][2] ) )

				If  aEstrut[nJ][2] > 0 .AND. ;
					PadR( StrTran( AllToChar( cX3Dado ), " ", "" ), 250 ) <> ;
					PadR( StrTran( AllToChar( aSX3[nI][nJ][1] ), " ", "" ), 250 ) .AND. ;
					!cX3Campo  == "X3_ORDEM"

					AutoGrLog( "Alterado campo " + aSX3[nI][nPosCpo][1] + CRLF + ;
					"   " + PadR( cX3Campo, 10 ) + " de [" + AllToChar( cX3Dado ) + "]" + CRLF + ;
					"            para [" + AllToChar( aSX3[nI][nJ][1] )           + "]" + CRLF )

					RecLock( "SX3", .F. )
					FieldPut( FieldPos( aEstrut[nJ][1] ), aSX3[nI][nJ][1] )
					MsUnLock()
				EndIf
			EndIf
		Next

	EndIf

	oProcess:IncRegua2( "Atualizando Campos de Tabelas (SX3)..." )

Next nI

AutoGrLog( CRLF + "Final da Atualizacao" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSIX()
Local aEstrut   := {}
Local aSIX      := {}
Local lAlt      := .F.
Local lDelInd   := .F.
Local nI        := 0
Local nJ        := 0

AutoGrLog( "Inicio da Atualizacao" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

aAdd( aSIX, {'A1U','1','A1U_FILIAL+A1U_CODIGO','Código','Código','Code','S','','','S'} )
aAdd( aSIX, {'A1U','2','A1U_FILIAL+A1U_CGC','CNPJ','CNPJ','EIN','S','','','S'} )
//
// Atualizando dicionário
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( "SIX" )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )

	lAlt    := .F.
	lDelInd := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		AutoGrLog( "Indice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do indice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
			lDelInd := .T. // Se for alteração precisa apagar o indice do banco
		EndIf
	EndIf

	RecLock( "SIX", !lAlt )
	For nJ := 1 To Len( aSIX[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
		EndIf
	Next nJ
	MsUnLock()

	dbCommit()

	If lDelInd
		TcInternal( 60, RetSqlName( aSIX[nI][1] ) + "|" + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] )
	EndIf

	oProcess:IncRegua2( "Atualizando indices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualizacao" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} EscEmpresa
Função genérica para escolha de Empresa, montada pelo SM0

@return aRet Vetor contendo as seleções feitas.
             Se não for marcada nenhuma o vetor volta vazio

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function EscEmpresa()

//---------------------------------------------
// Parâmetro  nTipo
// 1 - Monta com Todas Empresas/Filiais
// 2 - Monta só com Empresas
// 3 - Monta só com Filiais de uma Empresa
//
// Parâmetro  aMarcadas
// Vetor com Empresas/Filiais pré marcadas
//
// Parâmetro  cEmpSel
// Empresa que será usada para montar seleção
//---------------------------------------------
Local   aRet      := {}
Local   aSalvAmb  := GetArea()
Local   aSalvSM0  := {}
Local   aVetor    := {}
Local   cMascEmp  := "??"
Local   cVar      := ""
Local   lChk      := .F.
Local   lTeveMarc := .F.
Local   oNo       := LoadBitmap( GetResources(), "LBNO" )
Local   oOk       := LoadBitmap( GetResources(), "LBOK" )
Local   oDlg, oChkMar, oLbx, oMascEmp, oSay
Local   oButDMar, oButInv, oButMarc, oButOk, oButCanc

Local   aMarcadas := {}


If !MyOpenSm0(.F.)
	Return aRet
EndIf


dbSelectArea( "SM0" )
aSalvSM0 := SM0->( GetArea() )
dbSetOrder( 1 )
dbGoTop()

While !SM0->( EOF() )

	If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
		aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
	EndIf

	dbSkip()
End

RestArea( aSalvSM0 )

Define MSDialog  oDlg Title "" From 0, 0 To 280, 395 Pixel

oDlg:cToolTip := "Tela para Multiplas Selecoes de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualizacao"

@ 10, 10 Listbox  oLbx Var  cVar Fields Header " ", " ", "Empresa" Size 178, 095 Of oDlg Pixel
oLbx:SetArray(  aVetor )
oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
aVetor[oLbx:nAt, 2], ;
aVetor[oLbx:nAt, 4]}}
oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
oLbx:cToolTip   :=  oDlg:cTitle
oLbx:lHScroll   := .F. // NoScroll

@ 112, 10 CheckBox oChkMar Var  lChk Prompt "Todos" Message "Marca / Desmarca"+ CRLF + "Todos" Size 40, 007 Pixel Of oDlg;
on Click MarcaTodos( lChk, @aVetor, oLbx )

// Marca/Desmarca por mascara
@ 113, 51 Say   oSay Prompt "Empresa" Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture "@!"  Valid (  cMascEmp := StrTran( cMascEmp, " ", "?" ), oMascEmp:Refresh(), .T. ) ;
Message "Mascara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Selecao" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "mascara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "mascara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDC5CP1" ) ) ) ;
Message "Confirma a selecao e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicacao" Of oDlg
oButCanc:SetCss( CSSBOTAO )

Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( "SM0" )
dbCloseArea()

Return  aRet


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaTodos
Função auxiliar para marcar/desmarcar todos os ítens do ListBox ativo

@param lMarca  Contéudo para marca .T./.F.
@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} InvSelecao
Função auxiliar para inverter a seleção do ListBox ativo

@param aVetor  Vetor do ListBox
@param oLbx    Objeto do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} RetSelecao
Função auxiliar que monta o retorno com as seleções

@param aRet    Array que terá o retorno das seleções (é alterado internamente)
@param aVetor  Vetor do ListBox

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function RetSelecao( aRet, aVetor )
Local  nI    := 0

aRet := {}
For nI := 1 To Len( aVetor )
	If aVetor[nI][1]
		aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
	EndIf
Next nI

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MarcaMas
Função para marcar/desmarcar usando máscaras

@param oLbx     Objeto do ListBox
@param aVetor   Vetor do ListBox
@param cMascEmp Campo com a máscara (???)
@param lMarDes  Marca a ser atribuída .T./.F.

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
Local cPos1 := SubStr( cMascEmp, 1, 1 )
Local cPos2 := SubStr( cMascEmp, 2, 1 )
Local nPos  := oLbx:nAt
Local nZ    := 0

For nZ := 1 To Len( aVetor )
	If cPos1 == "?" .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
		If cPos2 == "?" .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
			aVetor[nZ][1] := lMarDes
		EndIf
	EndIf
Next

oLbx:nAt := nPos
oLbx:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} VerTodos
Função auxiliar para verificar se estão todos marcados ou não

@param aVetor   Vetor do ListBox
@param lChk     Marca do CheckBox do marca todos (referncia)
@param oChkMar  Objeto de CheckBox do marca todos

@author Ernani Forastieri
@since  27/09/2004
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function VerTodos( aVetor, lChk, oChkMar )
Local lTTrue := .T.
Local nI     := 0

For nI := 1 To Len( aVetor )
	lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
Next nI

lChk := IIf( lTTrue, .T., .F. )
oChkMar:Refresh()

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} MyOpenSM0
Função de processamento abertura do SM0 modo exclusivo

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function MyOpenSM0(lShared)
Local lOpen := .F.
Local nLoop := 0

If FindFunction( "OpenSM0Excl" )
	For nLoop := 1 To 20
		If OpenSM0Excl(,.F.)
			lOpen := .T.
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
Else
	For nLoop := 1 To 20
		dbUseArea( .T., , "SIGAMAT.EMP", "SM0", lShared, .F. )

		If !Empty( Select( "SM0" ) )
			lOpen := .T.
			dbSetIndex( "SIGAMAT.IND" )
			Exit
		EndIf
		Sleep( 500 )
	Next nLoop
EndIf

If !lOpen
	MsgStop( "Nao foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENCAO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  12/08/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function LeLog()
Local cRet  := ""
Local cFile := NomeAutoLog()
Local cAux  := ""

FT_FUSE( cFile )
FT_FGOTOP()

While !FT_FEOF()

	cAux := FT_FREADLN()

	If Len( cRet ) + Len( cAux ) < 1048000
		cRet += cAux + CRLF
	Else
		cRet += CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		cRet += "Tamanho de exibicao maxima do LOG alcancado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
