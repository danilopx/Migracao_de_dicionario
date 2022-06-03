#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "topconn.ch"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/21/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Sele_Arq( lPEDDESCR )

Local cFILE, ;
nHdlFile, ;
nBYTES1, ;
nBYTES2, ;
cNOME, ;
cDESCR := Space( 250 ), ;
oDESCR, ;
oDLG1

If Empty( cFile := ChooseFile() )
	Return { -1 }
EndIf
cNOME  := SubStr( cFILE, Rat( "\", cFILE ) + 1 )
If Len( cNOME ) > 250
	MsgInfo( "Nome do arquivo maior que 250 caracteres", "Aviso" )
	FClose( nHdlFile )
	Return { -1 }
EndIf
nHdlFile := FOpen( cFILE, 0 + 64 )  // Read + Shared
If nHdlFile < 0
	Help ( " ", 1, "NOHANDLE")
	FClose( nHdlFile )
	Return { -1 }
EndIf
If FSeek( nHdlFile, 0, 2 ) > 10240000  // Ate 10 Megabytes
	MsgInfo( "Tamanho do arquivo maior que 10 megabytes", "Aviso" )
	FClose( nHdlFile )
	Return { -1 }
EndIf
If lPEDDESCR
	DEFINE MSDIALOG oDlg1 TITLE "Arquivo selecionado" FROM 0,0 TO 155,825 PIXEL
	@ 08,08 SAY "Nome do arquivo:" SIZE 55, 7 OF oDlg1 PIXEL
	@ 08,53 SAY Left( cNOME, 125 ) SIZE 400, 7 OF oDlg1 COLOR CLR_GREEN PIXEL
	@ 15,53 SAY SubStr( cNOME, 126 ) SIZE 400, 7 OF oDlg1 COLOR CLR_GREEN PIXEL
	@ 30,08 SAY "Descrição do conteúdo ( Máximo de 250 caracteres ):" SIZE 195, 7 OF oDlg1 PIXEL
	@ 38,08 GET oDESCR VAR cDESCR SIZE 400, 22 OF oDlg1 COLOR CLR_GREEN MEMO PIXEL
	
	DEFINE SBUTTON FROM 65, 200 TYPE 1 ACTION ( IIf( Empty( cDESCR ), ( MsgInfo( "Informe a descrição do conteúdo do arquivo", "Aviso" ), oDESCR:SetFocus() ), oDlg1:End() ) ) ENABLE OF oDlg1
	ACTIVATE MSDIALOG oDlg1 CENTERED VALID IIf( Empty( cDESCR ), ( MsgInfo( "Informe a descrição do conteúdo do arquivo", "Aviso" ), oDESCR:SetFocus(), .F. ), .T. )
Endif
Return { nHdlFile, cNOME, cDESCR }





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function GrvArqSQL( aARQ, cCHAVE )

//*-----------*

Local nBYTES1, ;
nBYTES2, ;
nTAMARQ, ;
cARQ, ;
xBUFFER, ;
nHDLFILE := aARQ[ 1 ], ;
nITEM := 1, ;
nSEQ  := 1

ZZM->( DbSetOrder( 1 ) )
ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
Do While ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, Len( cCHAVE ) ) + ZZM->ZZM_ITEM == xFILIAL( "ZZM" ) + cCHAVE + StrZero( nITEM, 2 )
	nITEM++
	ZZM->( DbSkip() )
EndDo
RecLock( "ZZM", .T. )
ZZM->ZZM_FILIAL := xFILIAL( "ZZM" )
ZZM->ZZM_CHAVE  := cCHAVE
ZZM->ZZM_ITEM   := StrZero( nITEM, 2 )
ZZM->ZZM_ARQUIV := aARQ[ 2 ]
ZZM->ZZM_DESCR  := aARQ[ 3 ]
If ZZM->( Fieldpos( "ZZM_ACESSO" ) ) > 0
	ZZM->ZZM_ACESSO := "1"
EndIf
ZZM->( MsUnLock() )

nTAMARQ := FSeek( nHdlFile, 0, 2 )
FSeek( nHdlFile, 0, 0 )
nBYTES1 := 0
Do While nTamArq >= nBytes1
	nBYTES2 := 0
	cARQ    := ""
	Do While nTamArq >= nBytes1 .and. nBYTES2 <= 60000
		xBuffer := Space( 4096 )
		FRead( nHdlFile, @xBuffer, Len( xBUFFER ) )
		cARQ    += xBUFFER
		nBytes1 += 4096
		nBytes2 += 4096
	EndDo
	RecLock( "ZZQ", .T. )
	ZZQ->ZZQ_FILIAL := xFILIAL( "ZZQ" )
	ZZQ->ZZQ_CHAVE  := cCHAVE
	ZZQ->ZZQ_ITEM   := StrZero( nITEM, 2 )
	ZZQ->ZZQ_SEQ    := StrZero( nSEQ, 3 )
	ZZQ->ZZQ_BYTES  := cARQ
	ZZQ->( MsUnLock() )
	nSEQ++
EndDo
Fclose( nHdlFile )
Return nBYTES1 >= nTAMARQ




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function AbrArqSQL( cCHAVE, cITEM )

//*-----------*

Local cParam := "", ;
cDir   := "", ;
cDrive := "", ;
nRet, ;
cTEMPPATH, ;
cFILE

ZZM->( DbSetOrder( 1 ) )
if ! ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE + cITEM ) )
	MsgInfo( "Arquivo solicitado não existe.", "Aviso" )
	Return .F.
EndIf
cTempPath := GetTempPath()
cFile     := cTempPath + "\" + AllTrim( ZZM->ZZM_ARQUIV )
If FILE( cFile )
	fErase( cFile )
EndIf
If ( nHdlFile := fCreate( cFile ) ) <= 0
	MsgInfo( "Não foi possível criar o arquivo para visualizacao.", "Aviso" )
	Return .F.
EndIf
ZZQ->( DbSetOrder( 1 ) )
ZZQ->( dbSeek( xFILIAL( "ZZQ" ) + cCHAVE + cITEM, .T. ) )
Do While ZZQ->ZZQ_FILIAL + Left( ZZQ->ZZQ_CHAVE, Len( cCHAVE ) ) + ZZQ->ZZQ_ITEM == xFILIAL( "ZZQ" ) + cCHAVE + cITEM
	fSeek( nHdlFile, 0, 2 ) // Posiciona no final do arquivo
	fWrite( nHdlFile, ZZQ->ZZQ_BYTES )  // Grava arquivo
	ZZQ->( DbSkip() )
EndDo
Fclose( nHdlFile )

SplitPath( cFile, @cDrive, @cDir )
cDir := Alltrim( cDrive ) + Alltrim( cDir )
nRet := ShellExecute( "open", cFile, cPARAM, cDir, 1 )
If nRet <= 32
	MsgInfo( "Não foi possível abrir o arquivo " + AllTrim( ZZM->ZZM_ARQUIV ) + ".", "Aviso" ) //"Não foi possível abrir a imagem " ## ".","Aviso"
	Return .F.
EndIf
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ExcArqSQL( cCHAVE, cITEM, aARRAY, cANEXO, cCPANEXO )

//*-----------*

Local cParam := "", ;
cDir   := "", ;
cDrive := "", ;
nRet, ;
cTEMPPATH, ;
cFILE

If ! MsgYesNo( "Confirma exclusão do anexo " + AllTrim( cANEXO ) + "?" )
	Return .F.
EndIf
ZZM->( DbSetOrder( 1 ) )
If ! ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE + cITEM ) )
	MsgInfo( "Arquivo solicitado não existe.", "Aviso" )
	Return .F.
EndIf
ZZQ->( DbSetOrder( 1 ) )
ZZQ->( dbSeek( xFILIAL( "ZZQ" ) + cCHAVE + cITEM, .T. ) )
Do While ZZQ->ZZQ_FILIAL + Left( ZZQ->ZZQ_CHAVE, Len( cCHAVE ) ) + ZZQ->ZZQ_ITEM == xFILIAL( "ZZQ" ) + cCHAVE + cITEM
	RecLock( "ZZQ", .F. )
	ZZQ->( DbDelete() )
	ZZQ->( MsUnLock() )
	ZZQ->( DbSkip() )
EndDo
RecLock( "ZZM", .F. )
ZZM->( DbDelete() )
ZZM->( MsUnLock() )
CargaArray( cCHAVE, @aARRAY )
If Len( aARRAY ) == 0
	RecLock( Left( cCHAVE, 3 ), .F. )
	( Left( cCHAVE, 3 ) )->&( cCPANEXO ) := " "
	( Left( cCHAVE, 3 ) )->( MsUnLock() )
	Aadd( aARRAY, { "1", Space( 2 ), Space( 60 ), Space( 120 ) } )
EndIf
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function SelArqSQL( cCHAVE, lINCLUI, lEXCLUI )

//*-----------*

Local aARQ1 := {}, ;
oDLG1, ;
oARQ, ;
nOPC := 0, ;
oGET1, ;
cDESCR, ;
lCHKPUB, ;
oCHKPUB, ;
cCPANEXO

Local oEnable  := LoadBitmap( GetResources(), "ENABLE" )
Local oDisable := LoadBitmap( GetResources(), "DISABLE" )
Local cALIAS   := Left( cCHAVE, 3 )

If GetEnvServer() == "CONSULTA"
	Return
EndIf


lINCLUI := If( lINCLUI == NIL, .T., lINCLUI )
lEXCLUI := If( lEXCLUI == NIL, .T., lEXCLUI )

If lINCLUI .or. lEXCLUI
	If ( cALIAS )->( Fieldpos( cALIAS + "_ANEXO" ) ) == 0
		If ( cALIAS )->( Fieldpos( Right( cALIAS, 2 ) + "_ANEXO" ) ) == 0
			MsgInfo( "Solicite ao suporte para criar o campo de controle.", "Aviso" )
			Return .F.
		Else
			cCPANEXO := Right( cALIAS, 2 ) + "_ANEXO"
		EndIf
	Else
		cCPANEXO := cALIAS + "_ANEXO"
	EndIf
EndIf
CargaArray( cCHAVE, @aARQ1 )
If Len( aARQ1 ) == 0
	Aadd( aARQ1, { "1", Space( 2 ), Space( 60 ), Space( 120 ) } )
EndIf
cDESCR  := aARQ1[ 1, 4 ]
lCHKPUB := ( aARQ1[ 1, 1 ] == "1" )
DEFINE MSDIALOG oDlg1 TITLE "Seleção de arquivo" FROM 0,0 TO 370,825 PIXEL
@ 118,08 SAY "Descrição do conteúdo:" SIZE 195, 7 OF oDlg1 PIXEL
@ 128,08 GET oGET1 VAR cDESCR SIZE 400, 20 OF oDlg1 COLOR CLR_GREEN MEMO READONLY PIXEL
@ 000,00 LISTBOX oARQ Fields HEADER "",OemToAnsi( "Item" ),OemToAnsi( "Arquivo" ) SIZE 410,115
oARQ:SetArray( aARQ1 )
oARQ:bLine      := { || { If( aARQ1[ oARQ:nAT, 1 ] == "1", oEnable, oDisable ), aARQ1[ oARQ:nAT, 2 ], aARQ1[ oARQ:nAT, 3 ] } }
oARQ:bChange    := { || cDESCR := aARQ1[ oARQ:nAT, 4 ], lCHKPUB := ( aARQ1[ oARQ:nAT, 1 ] == "1" ), oGET1:Refresh(), oCHKPUB:Refresh() }
oARQ:blDblClick := { || If( ! Empty( aARQ1[ oARQ:nAT, 2 ] ), u_AbrArqSQL( Padr( cCHAVE, 30 ), aARQ1[ oARQ:nAT, 2 ] ), NIL ) }
@ 153,10 CHECKBOX oCHKPUB VAR lCHKPUB PROMPT "Acesso público" SIZE 90,09 ON CHANGE ( aARQ1[ oARQ:nAT, 1 ] := If( aARQ1[ oARQ:nAT, 1 ] == "1", "2", "1" ), AlteraPub( Padr( cCHAVE, 30 ), aARQ1[ oARQ:nAT, 2 ], aARQ1[ oARQ:nAT, 1 ] ), oARQ:Refresh() ) PIXEL
@ 173,If( lEXCLUI .and. lINCLUI, 105, If( ! lEXCLUI .and. ! lINCLUI, 165, 135 ) ) BUTTON "Visualizar" SIZE 30,10 ACTION ( If( ! Empty( aARQ1[ oARQ:nAT, 2 ] ), u_AbrArqSQL( Padr( cCHAVE, 30 ), aARQ1[ oARQ:nAT, 2 ] ), NIL ) ) OF oDlg1 PIXEL
If lINCLUI
	@ 173, If( lEXCLUI, 160, 190 ) BUTTON "Novo" SIZE 30,10  ACTION ( NovoArq( cCHAVE, @aARQ1, cCPANEXO ), oARQ:SetArray( aARQ1 ), ;
	oARQ:bLine := { || { If( aARQ1[ oARQ:nAT, 1 ] == "1", oEnable, oDisable ), aARQ1[ oARQ:nAT, 2 ], aARQ1[ oARQ:nAT, 3 ] } }, ;
	oARQ:bChange := { || cDESCR := aARQ1[ oARQ:nAT, 4 ], lCHKPUB := ( aARQ1[ oARQ:nAT, 1 ] == "1" ), oGET1:Refresh(), oCHKPUB:Refresh() }, ;
	cDESCR := aARQ1[ oARQ:nAT, 4 ], lCHKPUB := ( aARQ1[ oARQ:nAT, 1 ] == "1" ), oGET1:Refresh(), oARQ:Refresh(), oCHKPUB:Refresh() ) OF oDlg1 PIXEL
Else
	oCHKPUB:lReadOnly := .T.
EndIf
If lEXCLUI
	@ 173, If( lINCLUI, 215, 185 ) BUTTON "Excluir" SIZE 30,10  ACTION ( If( ! Empty( aARQ1[ oARQ:nAT, 2 ] ), u_ExcArqSQL( Padr( cCHAVE, 30 ), aARQ1[ oARQ:nAT, 2 ], @aARQ1, aARQ1[ oARQ:nAT, 3 ], cCPANEXO ), ;
	NIL ), oARQ:SetArray( aARQ1 ), oARQ:bLine := { || { If( aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 1 ] == "1", oEnable, oDisable ), aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 2 ], aARQ1[ If( oARQ:nAT > Len( aARQ1 ), ;
	Len( aARQ1 ), oARQ:nAT ), 3 ] } }, oARQ:bChange := { || cDESCR := aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 4 ], lCHKPUB := ( aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 1 ] == "1" ), oGET1:Refresh(), oCHKPUB:Refresh() }, ;
	cDESCR := aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 4 ], lCHKPUB := ( aARQ1[ If( oARQ:nAT > Len( aARQ1 ), Len( aARQ1 ), oARQ:nAT ), 1 ] == "1" ), oGET1:Refresh(), oARQ:Refresh(), oCHKPUB:Refresh() ) OF oDlg1 PIXEL
EndIf
@ 173, If( lEXCLUI .and. lINCLUI, 270, If( ! lEXCLUI .and. ! lINCLUI, 210, 240 ) ) BUTTON "Sair" SIZE 30,10  ACTION ( oDlg1:End() ) OF oDlg1 PIXEL
ACTIVATE MSDIALOG oDlg1 CENTERED VALID SairAnexo( cCHAVE )
Return NIL




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function SairAnexo( cCHAVE )

//*-----------*

Local aRECSE2 := {}, ;
nCONT, ;
cQUERY

If Left( cCHAVE, 3 ) == "SF1"
	If SE2->( Fieldpos( "E2_ANEXO" ) ) > 0
		
		cQuery := "SELECT R_E_C_N_O_ SE2RECNO FROM " + RetSqlName("SE2") + " SE2 (NOLOCK) WHERE "
		cQuery += "E2_FILIAL = '" + xFilial("SE2") +"' AND "
		cQuery += "E2_PREFIXO = '" + SF1->F1_SERIE +"' AND "
		cQuery += "E2_NUM = '" + SF1->F1_DOC +"' AND "
		cQuery += "E2_FORNECE IN ( '" + SF1->F1_FORNECE +"') AND "
		cQuery += "E2_EMIS1 = '" + DTOS( SF1->F1_DTDIGIT ) +"' AND "
		cQuery += "E2_ORIGEM = 'MATA100 ' AND "
		cQuery += "D_E_L_E_T_ = '' "
		
		dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), "SE2TMP", .F., .T. )
		ZZM->( DbSetOrder( 1 ) )
		ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
		Do While ! SE2TMP->( Eof() )
			SE2->( DbGoto( SE2TMP->SE2RECNO ) )
			RecLock( "SE2", .F. )
			SE2->E2_ANEXO := If( ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, Len( cCHAVE ) ) == xFILIAL( "ZZM" ) + cCHAVE, "S", " " )
			SE2->( MsUnLock() )
			SE2TMP->( DbSkip() )
		EndDo
		SE2TMP->( DbCloseArea() )
	EndIf
Endif
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ExistAnexo( cCHAVE, lPERGUNTA, lEXCLUI )

//*-----------*

Local cCPANEXO
Local cALIAS := Left( cCHAVE, 3 )

lPERGUNTA := If( lPERGUNTA == NIL, .T., lPERGUNTA )
lEXCLUI   := If( lEXCLUI == NIL, .T., lEXCLUI )
If ( cALIAS )->( Fieldpos( cALIAS + "_ANEXO" ) ) == 0
	If ( cALIAS )->( Fieldpos( Right( cALIAS, 2 ) + "_ANEXO" ) ) > 0
		cCPANEXO := Right( cALIAS, 2 ) + "_ANEXO"
	EndIf
Else
	cCPANEXO := cALIAS + "_ANEXO"
EndIf
ZZM->( DbSetOrder( 1 ) )
ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
If ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, Len( cCHAVE ) ) <> xFILIAL( "ZZM" ) + cCHAVE
	Return .F.
EndIf
ZZQ->( DbSetOrder( 1 ) )
If lEXCLUI .and. ( ! lPERGUNTA .or. MsgYesNo( "Deseja excluir arquivos anexos também?" ) )
	Do While ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, Len( cCHAVE ) ) == xFILIAL( "ZZM" ) + cCHAVE
		ZZQ->( dbSeek( xFILIAL( "ZZQ" ) + ZZM->ZZM_CHAVE + ZZM->ZZM_ITEM, .T. ) )
		Do While ZZQ->ZZQ_FILIAL + Left( ZZQ->ZZQ_CHAVE, Len( cCHAVE ) ) + ZZQ->ZZQ_ITEM == xFILIAL( "ZZQ" ) + cCHAVE + ZZM->ZZM_ITEM
			RecLock( "ZZQ", .F. )
			ZZQ->( DbDelete() )
			ZZQ->( MsUnLock() )
			ZZQ->( DbSkip() )
		EndDo
		RecLock( "ZZM", .F. )
		ZZM->( DbDelete() )
		ZZM->( MsUnLock() )
		ZZM->( DbSkip() )
	EndDo
	If cCPANEXO <> NIL
		RecLock( cALIAS, .F. )
		( cALIAS )->&( cCPANEXO ) := " "
		( cALIAS )->( MsUnLock() )
	EndIf
EndIf
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function CargaArray( cCHAVE, aARRAY )

//*-----------*

aARRAY := {}
ZZM->( DbSetOrder( 1 ) )
ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE, .T. ) )
Do While ZZM->ZZM_FILIAL + Left( ZZM->ZZM_CHAVE, Len( cCHAVE ) ) == xFILIAL( "ZZM" ) + cCHAVE
	Aadd( aARRAY, { If( ZZM->( Fieldpos( "ZZM_ACESSO" ) ) > 0, If( Empty( ZZM->ZZM_ACESSO ), "1", ZZM->ZZM_ACESSO ), "1" ), ZZM->ZZM_ITEM, ZZM->ZZM_ARQUIV, ZZM->ZZM_DESCR } )
	ZZM->( DbSkip() )
EndDo
Return NIL




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function NovoArq( cCHAVE, aARRAY, cCPANEXO )

//*-----------*

Local aARQ := U_Sele_Arq( .T. )


If aARQ[ 1 ] > 0
	 U_GrvArqSQL( aARQ, cCHAVE )
	
		RecLock( Left( cCHAVE, 3 ), .F. )
		( Left( cCHAVE, 3 ) )->&( cCPANEXO ) := "S"
		( Left( cCHAVE, 3 ) )->( MsUnLock() )
		CargaArray( cCHAVE, @aARRAY )	
Endif
Return NIL




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ChooseFile()

//*-------------*

Local cTitle := "Arquivo a ser gravado"
Local cMask  := "Tipo do arquivo (*.*)|*.*|(*.jpg)|*.jpg|(*.jpeg)|*.jpeg|(*.bmp)|*.bmp|(*.tif)|*.tif|(*.pdf)|*.pdf|(*.doc)|*.doc|(*.docx)|*.docx|(*.xls)|*.xls|(*.xlsx)|*.xlsx"
Local cFile  := ""
Local nDefaultMask := 0
Local cDefaultDir  := "C:\"
Local nOptions := GETF_OVERWRITEPROMPT + GETF_LOCALHARD + GETF_NETWORKDRIVE

cFile := cGetFile( cMask, cTitle, nDefaultMask, cDefaultDir,, nOptions )
Return cFile




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIBANEXO  ºAutor  ³Microsiga           º Data ³  03/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AlteraPub( cCHAVE, cITEM, cPUB )

//*-----------*

ZZM->( DbSetOrder( 1 ) )
If ZZM->( DbSeek( xFILIAL( "ZZM" ) + cCHAVE + cITEM ) )
	RecLock( "ZZM", .F. )
	If ZZM->( Fieldpos( "ZZM_ACESSO" ) ) > 0
		ZZM->ZZM_ACESSO := cPUB
	EndIf
	ZZM->( MsUnLock() )
EndIf
Return NIL
