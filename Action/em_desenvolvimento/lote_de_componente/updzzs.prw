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
/*/{Protheus.doc} UPDZZS
Função de update de dicionários para compatibilização

@author TOTVS Protheus
@since  14/12/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
User Function UPDZZS( cEmpAmb, cFilAmb )

Local   aSay      := {}
Local   aButton   := {}
Local   aMarcadas := {}
Local   cTitulo   := "ATUALIZACAO DICIONÁRIOS CTREE - 30-MAIO-2022"
Local   cDesc1    := "M  O  N  I  T  O  R       L  O  T  E       D  E       C  O  M  P  O  N  E  N  T  E"
Local   cDesc2    := ""
Local   cDesc3    := "Esta rotina tem como função atualizar os dicionários de dados do sistema:"
Local   cDesc4    := "SX2, SX3 e SIX da tabela ZZS, perguntas (SX1) e campo C6_XORDSEP."
Local   cDesc5    := "30-MAIO-2022: Criacao de indice para pesq. Pedido de Venda"
Local   cDesc6    := ""
Local   cDesc7    := ""
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
aAdd( aSay, cDesc6 )
aAdd( aSay, cDesc7 )

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
		cMsg := "Este update NÃO PODE ser executado neste Ambiente." + CRLF + CRLF + ;
				"Os arquivos de dicionários se encontram no Banco de Dados e este update está preparado " + ;
				"para atualizar apenas ambientes com dicionários no formato ISAM (.dbf ou .dtc)."

		If lAuto
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
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
		If lAuto .OR. MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas, lAuto ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
			oProcess:Activate()

			If lAuto
				If lOk
					MsgStop( "Atualização Realizada.", "UPDZZS2" )
				Else
					MsgStop( "Atualização não Realizada.", "UPDZZS2" )
				EndIf
				dbCloseAll()
			Else
				If lOk
					Final( "Atualização Realizada." )
				Else
					Final( "Atualização não Realizada." )
				EndIf
			EndIf

		Else
			Final( "Atualização não Realizada." )

		EndIf

	Else
		Final( "Atualização não Realizada." )

	EndIf

EndIf

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSTProc
Função de processamento da gravação dos arquivos

@author TOTVS Protheus
@since  14/12/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSTProc( lEnd, aMarcadas, lAuto )
Local   aInfo     := {}
Local   aRecnoSM0 := {}
Local   cAux      := ""
Local   cFile     := ""
Local   cFileLog  := ""
Local   cMask     := "Arquivos Texto" + "(*.TXT)|*.txt|"
Local   cTCBuild  := "TCGetBuild"
Local   cTexto    := ""
Local   cTopBuild := ""
Local   lOpen     := .F.
Local   lRet      := .T.
Local   nI        := 0
Local   nPos      := 0
Local   nRecno    := 0
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
				MsgStop( "Atualização da empresa " + aRecnoSM0[nI][2] + " não efetuada." )
				Exit
			EndIf

			SM0->( dbGoTo( aRecnoSM0[nI][1] ) )

			RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )

			lMsFinalAuto := .F.
			lMsHelpAuto  := .F.

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( "LOG DA ATUALIZAÇÃO DOS DICIONÁRIOS" )
			AutoGrLog( Replicate( " ", 128 ) )
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )
			AutoGrLog( " Dados Ambiente" )
			AutoGrLog( " --------------------" )
			AutoGrLog( " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt )
			AutoGrLog( " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) )
			AutoGrLog( " DataBase...........: " + DtoC( dDataBase ) )
			AutoGrLog( " Data / Hora Ínicio.: " + DtoC( Date() )  + " / " + Time() )
			AutoGrLog( " Environment........: " + GetEnvServer()  )
			AutoGrLog( " StartPath..........: " + GetSrvProfString( "StartPath", "" ) )
			AutoGrLog( " RootPath...........: " + GetSrvProfString( "RootPath" , "" ) )
			AutoGrLog( " Versão.............: " + GetVersao(.T.) )
			AutoGrLog( " Usuário TOTVS .....: " + __cUserId + " " +  cUserName )
			AutoGrLog( " Computer Name......: " + GetComputerName() )

			aInfo   := GetUserInfo()
			If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
				AutoGrLog( " " )
				AutoGrLog( " Dados Thread" )
				AutoGrLog( " --------------------" )
				AutoGrLog( " Usuário da Rede....: " + aInfo[nPos][1] )
				AutoGrLog( " Estação............: " + aInfo[nPos][2] )
				AutoGrLog( " Programa Inicial...: " + aInfo[nPos][5] )
				AutoGrLog( " Environment........: " + aInfo[nPos][6] )
				AutoGrLog( " Conexão............: " + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), "" ), Chr( 10 ), "" ) ) )
			EndIf
			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " " )

			If !lAuto
				AutoGrLog( Replicate( "-", 128 ) )
				AutoGrLog( "Empresa : " + SM0->M0_CODIGO + "/" + SM0->M0_NOME + CRLF )
			EndIf

			oProcess:SetRegua1( 8 )


			oProcess:IncRegua1( "Dicionário de arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
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
					MsgStop( "Ocorreu um erro desconhecido durante a atualização da tabela : " + aArqUpd[nX] + ". Verifique a integridade do dicionário e da tabela.", "ATENÇÃO" )
					AutoGrLog( "Ocorreu um erro desconhecido durante a atualização da estrutura da tabela : " + aArqUpd[nX] )
				EndIf

				If cTopBuild >= "20090811" .AND. TcInternal( 89 ) == "CLOB_SUPPORTED"
					TcInternal( 25, "OFF" )
				EndIf

			Next nX


			oProcess:IncRegua1( "Dicionário de perguntas" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )
			FSAtuSX1()

			AutoGrLog( Replicate( "-", 128 ) )
			AutoGrLog( " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time() )
			AutoGrLog( Replicate( "-", 128 ) )

			RpcClearEnv()

		Next nI

		If !lAuto

			cTexto := LeLog()

			Define Font oFont Name "Mono AS" Size 5, 12

			Define MsDialog oDlg Title "Atualização concluida." From 3, 0 to 340, 417 Pixel

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
@since  14/12/2021
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

AutoGrLog( "Ínicio da Atualização" + " SX2" + CRLF )

aEstrut := { "X2_CHAVE"  , "X2_PATH"   , "X2_ARQUIVO", "X2_NOME"   , "X2_NOMESPA", "X2_NOMEENG", "X2_MODO"   , ;
             "X2_TTS"    , "X2_ROTINA" , "X2_PYME"   , "X2_UNICO"  , "X2_DISPLAY", "X2_SYSOBJ" , "X2_USROBJ" , ;
             "X2_POSLGT" , "X2_CLOB"   , "X2_AUTREC" , "X2_MODOEMP", "X2_MODOUN" , "X2_MODULO" }


dbSelectArea( "SX2" )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cPath := IIf( Right( AllTrim( cPath ), 1 ) <> "\", PadR( AllTrim( cPath ) + "\", Len( cPath ) ), cPath )
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

aAdd( aSX2, {'ZZS',cPath,'ZZS'+cEmpr,'LOTE DE COMPONENTES','LOTE DE COMPONENTES','LOTE DE COMPONENTES','E','','','','','','','','','','','E','E',0} )
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
			AutoGrLog( "Foi incluída a tabela " + aSX2[nI][1] )
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

			AutoGrLog( "Foi alterada a chave única da tabela " + aSX2[nI][1] )
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

AutoGrLog( CRLF + "Final da Atualização" + " SX2" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX3
Função de processamento da gravação do SX3 - Campos

@author TOTVS Protheus
@since  14/12/2021
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

AutoGrLog( "Ínicio da Atualização" + " SX3" + CRLF )

aEstrut := { { "X3_ARQUIVO", 0 }, { "X3_ORDEM"  , 0 }, { "X3_CAMPO"  , 0 }, { "X3_TIPO"   , 0 }, { "X3_TAMANHO", 0 }, { "X3_DECIMAL", 0 }, { "X3_TITULO" , 0 }, ;
             { "X3_TITSPA" , 0 }, { "X3_TITENG" , 0 }, { "X3_DESCRIC", 0 }, { "X3_DESCSPA", 0 }, { "X3_DESCENG", 0 }, { "X3_PICTURE", 0 }, { "X3_VALID"  , 0 }, ;
             { "X3_USADO"  , 0 }, { "X3_RELACAO", 0 }, { "X3_F3"     , 0 }, { "X3_NIVEL"  , 0 }, { "X3_RESERV" , 0 }, { "X3_CHECK"  , 0 }, { "X3_TRIGGER", 0 }, ;
             { "X3_PROPRI" , 0 }, { "X3_BROWSE" , 0 }, { "X3_VISUAL" , 0 }, { "X3_CONTEXT", 0 }, { "X3_OBRIGAT", 0 }, { "X3_VLDUSER", 0 }, { "X3_CBOX"   , 0 }, ;
             { "X3_CBOXSPA", 0 }, { "X3_CBOXENG", 0 }, { "X3_PICTVAR", 0 }, { "X3_WHEN"   , 0 }, { "X3_INIBRW" , 0 }, { "X3_GRPSXG" , 0 }, { "X3_FOLDER" , 0 }, ;
             { "X3_CONDSQL", 0 }, { "X3_CHKSQL" , 0 }, { "X3_IDXSRV" , 0 }, { "X3_ORTOGRA", 0 }, { "X3_TELA"   , 0 }, { "X3_POSLGT" , 0 }, { "X3_IDXFLD" , 0 }, ;
             { "X3_AGRUP"  , 0 }, { "X3_MODAL"  , 0 }, { "X3_PYME"   , 0 } }

aEval( aEstrut, { |x| x[2] := SX3->( FieldPos( x[1] ) ) } )


aAdd( aSX3, {{'SC6',.T.},{'J6',.T.},{'C6_XORDSEP',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Gera OS',.T.},{'Gera OS',.T.},{'Gera OS',.T.},{'Gera Ord. Separacao',.T.},{'Gera Ord. Separacao',.T.},{'Gera Ord. Separacao',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'V',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'01',.T.},{'ZZS_FILIAL',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Filial',.T.},{'Sucursal',.T.},{'Branch',.T.},{'Filial do Sistema',.T.},{'Sucursal',.T.},{'Branch of the System',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),.T.},{'',.T.},{'',.T.},{1,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'033',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'02',.T.},{'ZZS_TPREG',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Tp. Registro',.T.},{'Tp. Registro',.T.},{'Tp. Registro',.T.},{'Tipo de Registro',.T.},{'Tipo de Registro',.T.},{'Tipo de Registro',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'N',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'0=Sep.;1=Conf.NF;2=Conf.P.NF;3=Ped.Vda',.T.},{'0=Sep.;1=Conf.NF;2=Conf.P.NF;3=Ped.Vda',.T.},{'0=Sep.;1=Conf.NF;2=Conf.P.NF;3=Ped.Vda',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'03',.T.},{'ZZS_LOTEF',.T.},{'C',.T.},{20,.T.},{0,.T.},{'Lote Fornec.',.T.},{'Lote Fornec.',.T.},{'Lote Fornec.',.T.},{'Lote Fornecedor',.T.},{'Lote Fornecedor',.T.},{'Lote Fornecedor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'04',.T.},{'ZZS_DTEVEN',.T.},{'D',.T.},{8,.T.},{0,.T.},{'Data Evento',.T.},{'Data Evento',.T.},{'Data Evento',.T.},{'Data do Evento',.T.},{'Data do Evento',.T.},{'Data do Evento',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'05',.T.},{'ZZS_OP',.T.},{'C',.T.},{14,.T.},{0,.T.},{'Ord. Prod.',.T.},{'Ord. Prod.',.T.},{'Ord. Prod.',.T.},{'Ordem de Producao',.T.},{'Ordem de Producao',.T.},{'Ordem de Producao',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'06',.T.},{'ZZS_ORDSEP',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Ord. Separ.',.T.},{'Ord. Separ.',.T.},{'Ord. Separ.',.T.},{'Ord. Separacao',.T.},{'Ord. Separacao',.T.},{'Ord. Separacao',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'07',.T.},{'ZZS_NUMNF',.T.},{'C',.T.},{9,.T.},{0,.T.},{'NF Fornec.',.T.},{'NF Fornec.',.T.},{'NF Fornec.',.T.},{'NF Fornecedor',.T.},{'NF Fornecedor',.T.},{'NF Fornecedor',.T.},{'@R 999999999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'08',.T.},{'ZZS_SERNF',.T.},{'C',.T.},{3,.T.},{0,.T.},{'Serie NF',.T.},{'Serie NF',.T.},{'Serie NF',.T.},{'Serie NF Fornecedor',.T.},{'Serie NF Fornecedor',.T.},{'Serie NF Fornecedor',.T.},{'@R 999',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'09',.T.},{'ZZS_ITEMNF',.T.},{'C',.T.},{4,.T.},{0,.T.},{'Item N.F.',.T.},{'Item N.F.',.T.},{'Item N.F.',.T.},{'Item N.F.',.T.},{'Item N.F.',.T.},{'Item N.F.',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'10',.T.},{'ZZS_ITEMOP',.T.},{'C',.T.},{4,.T.},{0,.T.},{'Item O.P.',.T.},{'Item O.P.',.T.},{'Item O.P.',.T.},{'Item O.P.',.T.},{'Item O.P.',.T.},{'Item O.P.',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'11',.T.},{'ZZS_CODFOR',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod. Fornec.',.T.},{'Cod. Fornec.',.T.},{'Cod. Fornec.',.T.},{'Cod. Fornecedor',.T.},{'Cod. Fornecedor',.T.},{'Cod. Fornecedor',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'12',.T.},{'ZZS_LOJFOR',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Loja Fornec.',.T.},{'Loja Fornec.',.T.},{'Loja Fornec.',.T.},{'Loja Fornecedor',.T.},{'Loja Fornecedor',.T.},{'Loja Fornecedor',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'13',.T.},{'ZZS_COMPON',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Componente',.T.},{'Componente',.T.},{'Componente',.T.},{'Cod. Componente',.T.},{'Cod. Componente',.T.},{'Cod. Componente',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'14',.T.},{'ZZS_CODPA',.T.},{'C',.T.},{15,.T.},{0,.T.},{'Cod. Prd. PA',.T.},{'Cod. Prd. PA',.T.},{'Cod. Prd. PA',.T.},{'Codigo Prod. Acabado',.T.},{'Codigo Prod. Acabado',.T.},{'Codigo Prod. Acabado',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'15',.T.},{'ZZS_QTDCMP',.T.},{'N',.T.},{12,.T.},{2,.T.},{'Qtd. Compon.',.T.},{'Qtd. Compon.',.T.},{'Qtd. Compon.',.T.},{'Qtd. Componente',.T.},{'Qtd. Componente',.T.},{'Qtd. Componente',.T.},{'@E 999,999,999.99',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'16',.T.},{'ZZS_USERID',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod. Usuario',.T.},{'Cod. Usuario',.T.},{'Cod. Usuario',.T.},{'Codigo Usuario',.T.},{'Codigo Usuario',.T.},{'Codigo Usuario',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'17',.T.},{'ZZS_USERNM',.T.},{'C',.T.},{20,.T.},{0,.T.},{'Nome Usuario',.T.},{'Nome Usuario',.T.},{'Nome Usuario',.T.},{'Nome Usuario',.T.},{'Nome Usuario',.T.},{'Nome Usuario',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'18',.T.},{'ZZS_LOTEPA',.T.},{'C',.T.},{10,.T.},{0,.T.},{'Lote PA',.T.},{'Lote PA',.T.},{'Lote PA',.T.},{'Lote Prod.Acab.',.T.},{'Lote Prod.Acab.',.T.},{'Lote Prod.Acab.',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'19',.T.},{'ZZS_PEDVEN',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Ped. Venda',.T.},{'Ped. Venda',.T.},{'Ped. Venda',.T.},{'Pedido de Venda',.T.},{'Pedido de Venda',.T.},{'Pedido de Venda',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'20',.T.},{'ZZS_ITEMPV',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Item PV',.T.},{'Item PV',.T.},{'Item PV',.T.},{'Item Ped. Venda',.T.},{'Item Ped. Venda',.T.},{'Item Ped. Venda',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'21',.T.},{'ZZS_CODCLI',.T.},{'C',.T.},{6,.T.},{0,.T.},{'Cod. Cliente',.T.},{'Cod. Cliente',.T.},{'Cod. Cliente',.T.},{'Cod. Cliente',.T.},{'Cod. Cliente',.T.},{'Cod. Cliente',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'22',.T.},{'ZZS_LOJCLI',.T.},{'C',.T.},{2,.T.},{0,.T.},{'Loja Cliente',.T.},{'Loja Cliente',.T.},{'Loja Cliente',.T.},{'Loja Cliente',.T.},{'Loja Cliente',.T.},{'Loja Cliente',.T.},{'@!',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'23',.T.},{'ZZS_TIPOPV',.T.},{'C',.T.},{1,.T.},{0,.T.},{'Tipo Ped.Vda',.T.},{'Tipo Ped.Vda',.T.},{'Tipo Ped.Vda',.T.},{'Tipo Ped.Vda',.T.},{'Tipo Ped.Vda',.T.},{'Tipo Ped.Vda',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'24',.T.},{'ZZS_NFEBNF',.T.},{'C',.T.},{9,.T.},{0,.T.},{'NF.Ent.Benef',.T.},{'NF.Ent.Benef',.T.},{'NF.Ent.Benef',.T.},{'NF.Ent.Benef',.T.},{'NF.Ent.Benef',.T.},{'NF.Ent.Benef',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'25',.T.},{'ZZS_SREBNF',.T.},{'C',.T.},{3,.T.},{0,.T.},{'Ser.NFE.Benf',.T.},{'Ser.NFE.Benf',.T.},{'Ser.NFE.Benf',.T.},{'Ser.NFE.Benf',.T.},{'Ser.NFE.Benf',.T.},{'Ser.NFE.Benf',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'26',.T.},{'ZZS_NFSBNF',.T.},{'C',.T.},{9,.T.},{0,.T.},{'NF.Sai.Benef',.T.},{'NF.Sai.Benef',.T.},{'NF.Sai.Benef',.T.},{'NF.Sai.Benef',.T.},{'NF.Sai.Benef',.T.},{'NF.Sai.Benef',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )
aAdd( aSX3, {{'ZZS',.T.},{'27',.T.},{'ZZS_SRSBNF',.T.},{'C',.T.},{3,.T.},{0,.T.},{'Ser.NFS.Benf',.T.},{'Ser.NFS.Benf',.T.},{'Ser.NFS.Benf',.T.},{'Ser.NFS.Benf',.T.},{'Ser.NFS.Benf',.T.},{'Ser.NFS.Benf',.T.},{'',.T.},{'',.T.},{ Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) +Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),.T.},{'',.T.},{'',.T.},{0,.T.},{Chr(254) + Chr(192),.T.},{'',.T.},{'',.T.},{'U',.T.},{'S',.T.},{'A',.T.},{'R',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'N',.T.},{'',.T.},{'',.T.},{'',.T.}} )

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
				AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
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
					AutoGrLog( "O tamanho do campo " + aSX3[nI][nPosCpo][1] + " NÃO atualizado e foi mantido em [" + ;
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

AutoGrLog( CRLF + "Final da Atualização" + " SX3" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSIX
Função de processamento da gravação do SIX - Indices

@author TOTVS Protheus
@since  14/12/2021
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

AutoGrLog( "Ínicio da Atualização" + " SIX" + CRLF )

aEstrut := { "INDICE" , "ORDEM" , "CHAVE", "DESCRICAO", "DESCSPA"  , ;
             "DESCENG", "PROPRI", "F3"   , "NICKNAME" , "SHOWPESQ" }

aAdd( aSIX, {'ZZS','1','ZZS_FILIAL+ZZS_NUMNF+ZZS_SERNF+ZZS_CODFOR+ZZS_LOJFOR+ZZS_TPREG+ZZS_LOTEF','NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+Tp. Registro+Lote Fornec','NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+Tp. Registro+Lote Fornec','NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+Tp. Registro+Lote Fornec','U','','ZZS01','S'} )
aAdd( aSIX, {'ZZS','2','ZZS_FILIAL+ZZS_CODFOR+ZZS_LOJFOR+ZZS_NUMNF+ZZS_SERNF+ZZS_TPREG+ZZS_LOTEF','Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registro+Lote Fornec','Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registro+Lote Fornec','Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registro+Lote Fornec','U','','ZZS02','S'} )
aAdd( aSIX, {'ZZS','3','ZZS_FILIAL+ZZS_OP+ZZS_CODPA+ZZS_COMPON+ZZS_TPREG+ZZS_LOTEF','Ord. Prod.+Cod. Prd. PA+Componente+Tp. Registro+Lote Fornec.','Ord. Prod.+Cod. Prd. PA+Componente+Tp. Registro+Lote Fornec.','Ord. Prod.+Cod. Prd. PA+Componente+Tp. Registro+Lote Fornec.','U','','ZZS03','S'} )
aAdd( aSIX, {'ZZS','4','ZZS_FILIAL+ZZS_OP+ZZS_COMPON+ZZS_CODPA+ZZS_TPREG+ZZS_LOTEF','Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro+Lote Fornec.','Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro+Lote Fornec.','Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro+Lote Fornec.','U','','ZZS04','S'} )
aAdd( aSIX, {'ZZS','5','ZZS_FILIAL+ZZS_LOTEF+ZZS_CODFOR+ZZS_LOJFOR+ZZS_NUMNF+ZZS_SERNF+ZZS_TPREG','Lote Fornec.+Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registr','Lote Fornec.+Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registr','Lote Fornec.+Cod. Fornec.+Loja Fornec.+NF Fornec.+Serie NF+Tp. Registr','U','','ZZS05','N'} )
aAdd( aSIX, {'ZZS','6','ZZS_FILIAL+ZZS_LOTEF+ZZS_OP+ZZS_COMPON+ZZS_CODPA+ZZS_TPREG','Lote Fornec.+Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro','Lote Fornec.+Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro','Lote Fornec.+Ord. Prod.+Componente+Cod. Prd. PA+Tp. Registro','U','','ZZS06','N'} )
aAdd( aSIX, {'ZZS','7','ZZS_FILIAL+ZZS_ORDSEP+ZZS_OP+ZZS_NUMNF+ZZS_SERNF+ZZS_CODFOR+ZZS_LOJFOR+ZZS_TPREG','Ord. Separ.+Ord. Prod.+NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+T','Ord. Separ.+Ord. Prod.+NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+T','Ord. Separ.+Ord. Prod.+NF Fornec.+Serie NF+Cod. Fornec.+Loja Fornec.+T','U','','ZZS07','N'} )
aAdd( aSIX, {'ZZS','8','ZZS_FILIAL+ZZS_PEDVEN','Ped de Venda','Ped Venda','Ped Venda','U','','ZZS08','S'} )

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
		AutoGrLog( "Índice criado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
	Else
		lAlt := .T.
		aAdd( aArqUpd, aSIX[nI][1] )
		If !StrTran( Upper( AllTrim( CHAVE )       ), " ", "" ) == ;
		    StrTran( Upper( AllTrim( aSIX[nI][3] ) ), " ", "" )
			AutoGrLog( "Chave do índice alterado " + aSIX[nI][1] + "/" + aSIX[nI][2] + " - " + aSIX[nI][3] )
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

	oProcess:IncRegua2( "Atualizando índices..." )

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SIX" + CRLF + Replicate( "-", 128 ) + CRLF )

Return NIL


//--------------------------------------------------------------------
/*/{Protheus.doc} FSAtuSX1
Função de processamento da gravação do SX1 - Perguntas

@author TOTVS Protheus
@since  14/12/2021
@obs    Gerado por EXPORDIC - V.6.6.1.5 EFS / Upd. V.5.1.0 EFS
@version 1.0
/*/
//--------------------------------------------------------------------
Static Function FSAtuSX1()
Local aEstrut   := {}
Local aSX1      := {}
Local aStruDic  := SX1->( dbStruct() )
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTam1     := Len( SX1->X1_GRUPO )
Local nTam2     := Len( SX1->X1_ORDEM )

AutoGrLog( "Ínicio da Atualização " + cAlias + CRLF )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

aAdd( aSX1, {'TFLOTCMP01','01','Filtra por','Filtra por','Filtra por','MV_CH1','N',1,0,1,'C','','MV_PAR01','Ordem Producao','Ordem Producao','Ordem Producao','','','Nota Fiscal','Nota Fiscal','Nota Fiscal','','','Ord. Separacao','Ord. Separacao','Ord. Separacao','','','Pedido Venda','Pedido Venda','Pedido Venda','','','Prod. Acabado','Prod. Acabado','Prod. Acab','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP01','02','Expressao','Expressao','Expressao','MV_CH2','C',20,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP01','03','Data De','Data De','Data De','MV_CH3','D',8,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP01','04','Data Ate','Data Ate','Data Ate','MV_CH4','D',8,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','01','Do Lote Fornecedor','Do Lote Fornecedor','Do Lote Fornecedor','MV_CH1','C',20,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','02','Ate Lote Fornecedor','Ate Lote Fornecedor','Ate Lote Fornecedor','MV_CH2','C',20,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','03','Do Cod. Fornecedor','Do Cod. Fornecedor','Do Cod. Fornecedor','MV_CH3','C',6,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','SA2','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP02','04','Ate Cod. Fornecedor','Ate Cod. Fornecedor','Ate Cod. Fornecedor','MV_CH4','C',6,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','SA2','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP02','05','Da Data Fabricacao','Da Data Fabricacao','Da Data Fabricacao','MV_CH5','D',8,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','06','Ate Data de Fabricacao','Ate Data de Fabricacao','Ate Data de Fabricacao','MV_CH6','D',8,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','07','Do Nosso Nro. de Serie','Do Nosso Nro. de Serie','Do Nosso Nro. de Serie','MV_CH7','C',20,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','08','Ate Nosso Nro. de Serie','Ate Nosso Nro. de Serie','Ate Nosso Nro. de Serie','MV_CH8','C',20,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','09','Da Nota Fiscal','Da Nota Fiscal','Da Nota Fiscal','MV_CH9','C',9,0,0,'G','','MV_PAR09','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','10','Ate a Nota Fiscal','Ate a Nota Fiscal','Ate a Nota Fiscal','MV_CHA','C',9,0,0,'G','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','11','Da Ordem de Producao','Da Ordem de Producao','Da Ordem de Producao','MV_CHB','C',11,0,0,'G','','MV_PAR11','','','','','','','','','','','','','','','','','','','','','','','','','SC2','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','12','Ate Ordem de Producao','Ate Ordem de Producao','Ate Ordem de Producao','MV_CHC','C',11,0,0,'G','','MV_PAR12','','','','','','','','','','','','','','','','','','','','','','','','','SC2','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','13','Do Cod. Componente','Do Cod. Componente','Do Cod. Componente','MV_CHD','C',15,0,0,'G','','MV_PAR13','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {'TFLOTCMP02','14','Ate Cod. Componente','Ate Cod. Componente','Ate Cod. Componente','MV_CHE','C',15,0,0,'G','','MV_PAR14','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','01','Do Lote','Do Lote','Do Lote','MV_CH0','C',20,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','02','Ate Lote','Ate Lote','Ate Lote','MV_CH0','C',20,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','03','Da Nota Fiscal','Da Nota Fiscal','Da Nota Fiscal','MV_CH0','C',9,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','04','Ate Nota Fiscal','Ate Nota Fiscal','Ate Nota Fiscal','MV_CH0','C',9,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','05','Da Serie','Da Serie','Da Serie','MV_CH0','C',3,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','06','Ate Serie','Ate Serie','Ate Serie','MV_CH0','C',3,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','07','Do Fornecedor','Do Fornecedor','Do Fornecedor','MV_CH0','C',6,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','SA2','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','08','Da Loja Fornec.','Da Loja Fornec.','Da Loja Fornec.','MV_CH0','C',2,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','09','Ate Fornecedor','Ate Fornecedor','Ate Fornecedor','MV_CH0','C',6,0,0,'G','','MV_PAR09','','','','','','','','','','','','','','','','','','','','','','','','','SA2','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','10','Ate Loja Fornec.','Ate Loja Fornec.','Ate Loja Fornec.','MV_CH1','C',2,0,0,'G','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','11','Da Data Entrada NF','Da Data Entrada NF','Da Data Entrada NF','MV_CH1','D',8,0,0,'G','','MV_PAR11','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','12','Ate Data Entrada NF','Ate Data Entrada NF','Ate Data Entrada NF','MV_CH1','D',8,0,0,'G','','MV_PAR12','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','13','Da Data Emissao NF','Da Data Emissao NF','Da Data Emissao NF','MV_CH1','D',8,0,0,'G','','MV_PAR13','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','14','Ate Data Emissao NF','Ate Data Emissao NF','Ate Data Emissao NF','MV_CH1','D',8,0,0,'G','','MV_PAR14','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','15','Do Componente','Do Componente','Do Componente','MV_CH1','C',15,0,0,'G','','MV_PAR15','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {'TFLOTCMP03','16','Ate Componente','Ate Componente','Ate Componente','MV_CH1','C',15,0,0,'G','','MV_PAR16','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {'TFLOTCMP04','01','Do Pedido','Do Pedido','Do Pedido','MV_CH0','C',6,0,0,'G','','MV_PAR01','','','','','','','','','','','','','','','','','','','','','','','','','SC5','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','02','Ate Pedido','Ate Pedido','Ate Pedido','MV_CH0','C',6,0,0,'G','','MV_PAR02','','','','','','','','','','','','','','','','','','','','','','','','','SC5','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','03','Da Emissao','Da Emissao','Da Emissao','MV_CH0','D',8,0,0,'G','','MV_PAR03','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP04','04','Ate Emissao','Ate Emissao','Ate Emissao','MV_CH0','D',8,0,0,'G','','MV_PAR04','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP04','05','Do Lote','Do Lote','Do Lote','MV_CH0','C',20,0,0,'G','','MV_PAR05','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP04','06','Ate Lote','Ate Lote','Ate Lote','MV_CH0','C',20,0,0,'G','','MV_PAR06','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {'TFLOTCMP04','07','Do Cli / Fornec.','Do Cli / Fornec.','Do Cli / Fornec.','MV_CH0','C',6,0,0,'G','','MV_PAR07','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','08','Da Loja Cli / Forn.','Da Loja Cli / Forn.','Da Loja Cli / Forn.','MV_CH0','C',2,0,0,'G','','MV_PAR08','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','09','Ate Cli / Fornec.','Ate Cli / Fornec.','Ate Cli / Fornec.','MV_CH0','C',6,0,0,'G','','MV_PAR09','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','10','Ate Loja Cli / Forn.','Ate Loja Cli / Forn.','Ate Loja Cli / Forn.','MV_CH1','C',2,0,0,'G','','MV_PAR10','','','','','','','','','','','','','','','','','','','','','','','','','','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','11','Do Produto','Do Produto','Do Produto','MV_CH0','C',15,0,0,'G','','MV_PAR11','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','@!',''} )
aAdd( aSX1, {'TFLOTCMP04','12','Ate Produto','Ate Produto','Ate Produto','MV_CH0','C',15,0,0,'G','','MV_PAR12','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','@!',''} )

//
// Atualizando dicionário
//

nPosPerg:= aScan( aEstrut, "X1_GRUPO"   )
nPosOrd := aScan( aEstrut, "X1_ORDEM"   )
nPosTam := aScan( aEstrut, "X1_TAMANHO" )
nPosSXG := aScan( aEstrut, "X1_GRPSXG"  )

oProcess:SetRegua2( Len( aSX1 ) )

dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX1 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX1[nI][nPosSXG]  )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX1[nI][nPosSXG] ) )
			If aSX1[nI][nPosTam] <> SXG->XG_SIZE
				aSX1[nI][nPosTam] := SXG->XG_SIZE
				AutoGrLog( "O tamanho da pergunta " + aSX1[nI][nPosPerg] + " / " + aSX1[nI][nPosOrd] + " NÃO atualizado e foi mantido em [" + ;
				AllTrim( Str( SXG->XG_SIZE ) ) + "]" + CRLF + ;
				"   por pertencer ao grupo de campos [" + SXG->XG_GRUPO + "]" + CRLF )
			EndIf
		EndIf
	EndIf

	oProcess:IncRegua2( "Atualizando perguntas..." )

	If !SX1->( dbSeek( PadR( aSX1[nI][nPosPerg], nTam1 ) + PadR( aSX1[nI][nPosOrd], nTam2 ) ) )
		AutoGrLog( "Pergunta Criada. Grupo/Ordem " + aSX1[nI][nPosPerg] + "/" + aSX1[nI][nPosOrd] )
		RecLock( "SX1", .T. )
	Else
		AutoGrLog( "Pergunta Alterada. Grupo/Ordem " + aSX1[nI][nPosPerg] + "/" + aSX1[nI][nPosOrd] )
		RecLock( "SX1", .F. )
	EndIf

	For nJ := 1 To Len( aSX1[nI] )
		If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
			SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aSX1[nI][nJ] ) )
		EndIf
	Next nJ

	MsUnLock()

Next nI

AutoGrLog( CRLF + "Final da Atualização" + " SX1" + CRLF + Replicate( "-", 128 ) + CRLF )

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
Local   lOk       := .F.
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

oDlg:cToolTip := "Tela para Múltiplas Seleções de Empresas/Filiais"

oDlg:cTitle   := "Selecione a(s) Empresa(s) para Atualização"

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
Message "Máscara Empresa ( ?? )"  Of oDlg
oSay:cToolTip := oMascEmp:cToolTip

@ 128, 10 Button oButInv    Prompt "&Inverter"  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Inverter Seleção" Of oDlg
oButInv:SetCss( CSSBOTAO )
@ 128, 50 Button oButMarc   Prompt "&Marcar"    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Marcar usando" + CRLF + "máscara ( ?? )"    Of oDlg
oButMarc:SetCss( CSSBOTAO )
@ 128, 80 Button oButDMar   Prompt "&Desmarcar" Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message "Desmarcar usando" + CRLF + "máscara ( ?? )" Of oDlg
oButDMar:SetCss( CSSBOTAO )
@ 112, 157  Button oButOk   Prompt "Processar"  Size 32, 12 Pixel Action (  RetSelecao( @aRet, aVetor ), IIf( Len( aRet ) > 0, oDlg:End(), MsgStop( "Ao menos um grupo deve ser selecionado", "UPDZZS2" ) ) ) ;
Message "Confirma a seleção e efetua" + CRLF + "o processamento" Of oDlg
oButOk:SetCss( CSSBOTAO )
@ 128, 157  Button oButCanc Prompt "Cancelar"   Size 32, 12 Pixel Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) ;
Message "Cancela o processamento" + CRLF + "e abandona a aplicação" Of oDlg
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
@since  14/12/2021
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
	MsgStop( "Não foi possível a abertura da tabela " + ;
	IIf( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ), "ATENÇÃO" )
EndIf

Return lOpen


//--------------------------------------------------------------------
/*/{Protheus.doc} LeLog
Função de leitura do LOG gerado com limitacao de string

@author TOTVS Protheus
@since  14/12/2021
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
		cRet += "Tamanho de exibição maxima do LOG alcançado." + CRLF
		cRet += "LOG Completo no arquivo " + cFile + CRLF
		cRet += Replicate( "=" , 128 ) + CRLF
		Exit
	EndIf

	FT_FSKIP()
End

FT_FUSE()

Return cRet


/////////////////////////////////////////////////////////////////////////////
