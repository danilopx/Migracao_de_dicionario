#INCLUDE "Protheus.ch"
#INCLUDE "RwMake.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Tbiconn.ch"
#INCLUDE "FwBrowse.ch"
#INCLUDE "fwmvcdef.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AENDVFI01     ºAutor  ³Jackson Santos      º Data ³  13/08/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina de Controle de Endividamento 				      º±±
±±º          ³  Aplicação Principal                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function AENDVF01()
	Local oDlgEndiv
	//LOCAL bCondic := { || }
	//Local cCondic := ""
	Local cNoFields     := "ZZ_CODSEQ/ZZ_REVISAO/ZZ_CODCONT/ZZ_NPARSE2/ZZ_LA/ZZ_STATPAR"
	Private aSize 	:= {}
	Private aObjects 	:= {}
	Private aInfo 	:= {}
	Private aPosObj 	:= {}
	Private aPosGet 	:= {}
//Private aHeader		:= {}
//Private aCols		:= {}
	Private nUsado 		:= 0
	Private cFiltro	:= ""
	Private aRotina	:= MenuDef()
	Private cCadastro := "Controle de Endividamento"
	Private INCLUI	:= 0
	Private ALTERA	:= 0
	Private EXCLUI	:= 0
	Private lOkInc := .F.
	Private lOkAlt := .F.
	Private lOkExc := .F.
	Private cUsrLibFin := SuperGetmv("DG_LIBEMFI",.f.,"000000")
	Static oFWLayer
	Static oFWLayer2
	Static oWin1
	Static oWin2
	Static oWin3
	Static oWin4
	Static oWin5
	Static aHeader := {}
	Static aCols   := {}
	Static aColsNew := {}

	aSize	:= MsAdvSize( .F. )
	aInfo 	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }

	AAdd( aObjects, { 100	, 050	, .T., .F. })
	AAdd( aObjects, { 100	, 100	, .T., .T. })

	aPosObj	:= MsObjSize(aInfo,aObjects)
	aPosGet	:= MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))

//Modalidade do Emprestimo                    
	DbSelectArea("SZW")
	SZW->(DbSetOrder(1))

//Cabeçalho
	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))
//Itens
	DbSelectArea("SZZ")
	SZZ->(DbSetOrder(1))

//DbSetFilter(bCondic,cCondic)


//Carrega o Header
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZZ")
	While !Eof() .And. X3_ARQUIVO == "SZZ"
		If X3USO( X3_USADO ) .And. cNivel >= X3_NIVEL
			If !Alltrim(X3_CAMPO) $ cNoFields
				aAdd( aHeader, { Trim( X3Titulo() ), X3_CAMPO, X3_PICTURE, X3_TAMANHO, X3_DECIMAL, X3_VALID,/*Reservado*/, X3_TIPO,/*Reservado*/,/*Reservado*/ } )
				nUsado++
			EndIf
		Endif
		dbSkip()
	Enddo

//Carrega o Acols
	Aadd( aCols, Array( Len(aHeader) + 1 ) )
	AaDd(aColsNew,Array( Len(aHeader) + 1 ) )
	aAlterAcols := {}
	nUsado := 0
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZZ")
	While !Eof() .And. X3_ARQUIVO == "SZZ"
		If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
			If !Alltrim(X3_CAMPO) $ cNoFields
				nUsado++
				aCols[ Len(aCols), nUsado ]	:= CriaVar(Trim(X3_CAMPO),.T.)
				AaDd(aAlterAcols,Trim(X3_CAMPO))
				aColsNew[Len(aColsNew), nUsado ]	:= CriaVar(Trim(X3_CAMPO),.T.)
			EndIf
		Endif
		DbSkip()
	Enddo
	aCols[ Len(aCols), nUsado + 1 ]	:= .F.
	aColsNew[Len(aColsNew), nUsado + 1 ]	:= .F.


	DEFINE MSDIALOG oDlgEndiv TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd STYLE nOR( WS_VISIBLE,WS_POPUP ) PIXEL

	oDlgEndiv:lEscClose := .F.


	oFWLayer := FWLayer():New()
	oFWLayer:Init(oDlgEndiv,.F.)

	oFWLayer:AddCollumn("Col01",10,.T.)
	oFWLayer:AddCollumn("Col02",90,.T.)

	oFWLayer:AddWindow("Col01","Win01"	,"Açoes"	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer:AddWindow("Col02","Win02"	,cCadastro	,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin1 := oFWLayer:GetWinPanel('Col01','Win01')
	oWin2 := oFWLayer:GetWinPanel('Col02','Win02')

	// Botões da tela
	oBtn0 := TButton():New(0,0,"Sair",oWin1,{|| oDlgEndiv:End() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn0:Align  := CONTROL_ALIGN_BOTTOM
	oBtn1 := TButton():New(0,0,"Visualizar",oWin1,{|| ADGF001VIS("SZY",SZY->(Recno()),2) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)

	oBtn1:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn11 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn11:Align  := CONTROL_ALIGN_TOP

	oBtn2 := TButton():New(0,0,"Incluir",oWin1,{|| lOkInc := ADGF01INC("","",3),oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn2:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn22 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn22:Align  := CONTROL_ALIGN_TOP

	oBtn3 := TButton():New(0,0,"Alterar",oWin1,{|| lOkAlt := ADGF01ALT("SZY",SZY->(Recno()),4),oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn3:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn33 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn33:Align  := CONTROL_ALIGN_TOP

	oBtn4 := TButton():New(0,0,"Excluir",oWin1,{||  lOkExc := ADGF001EXC('SZY',SZY->(Recno()),5),iif(lOkExc,MsgAlert("Excluido com Sucesso", ""),), oBrowse:Refresh(.T.) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn4:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn44 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn44:Align  := CONTROL_ALIGN_TOP

	oBtn5 := TButton():New(0,0,"Quitar",oWin1,{|| lOkQut := IIF(SZY->(Recno()) > 0,ADGF001QUIT('SZY',SZY->(Recno()),6,SZY->ZY_CODSEQ,SZY->ZY_REVISAO),.F.),iif(lOkQut,MsgAlert("Quitado com Sucesso", ""),), oBrowse:Refresh(.T.)  },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtn5:Align  := CONTROL_ALIGN_TOP

	@ 000, 000 SAY oBtn55 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
	oBtn55:Align  := CONTROL_ALIGN_TOP

	//Verifica se o usuário possui acesso a liberar o contrato para gerar as parcelas no financeiro.
	If RetCodUsr() $ cUsrLibFin
		oBtn8 := TButton():New(0,0,"Lib.Cta.Pag",oWin1,{||  MsgRun("Aguarde, processando liberação e gerando parcelas no financeiro.","Liberação",{||lLibok:=U_AENDVF02("SZY",SZY->(Recno()),3,SZY->ZY_CODSEQ,SZY->ZY_REVISAO)}),,oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.,SZY->ZY_CODCONT)
		oBtn8:Align  := CONTROL_ALIGN_TOP

		@ 000, 000 SAY oBtn88 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		oBtn88:Align  := CONTROL_ALIGN_TOP


		oBtn9 := TButton():New(0,0,"Estorn.Lib.CP.",oWin1,{||  MsgRun("Aguarde, processando estorno e excluindo parcelas no financeiro.","Estorno",{||lLibok:=U_AENDVF02("SZY",SZY->(Recno()),5,SZY->ZY_CODSEQ,SZY->ZY_REVISAO)}),,oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtn9:Align  := CONTROL_ALIGN_TOP
		@ 000, 000 SAY oBtn99 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		oBtn99:Align  := CONTROL_ALIGN_TOP


		//oBtn14 := TButton():New(0,0,"Atual.Contr.CDI",oWin1,{||  Processa( {|| AtualizCDI() }, "Atualizando CDI Aguarde..." )  },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		//oBtn14:Align  := CONTROL_ALIGN_TOP
		//@ 000, 000 SAY oBtn140 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		//oBtn140:Align  := CONTROL_ALIGN_TOP

		oBtn10 := TButton():New(0,0,"Config.Modal.",oWin1,{||  AxCadastro("SZW","Cadastro da Modalidade do Endividamento") },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtn10:Align  := CONTROL_ALIGN_BOTTOM
		@ 000, 000 SAY oBtn100 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		oBtn100:Align  := CONTROL_ALIGN_BOTTOM

		//oBtn13 := TButton():New(0,0,"Importa Contr.",oWin1,{||  U_AIMPCONTR(),oBrowse:Refresh() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		//oBtn13:Align  := CONTROL_ALIGN_BOTTOM
		//@ 000, 000 SAY oBtn130 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		//oBtn130:Align  := CONTROL_ALIGN_BOTTOM

		oBtn12 := TButton():New(0,0,"Contabilização",oWin1,{||  U_AENDVCTB(3,.F.) },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtn12:Align  := CONTROL_ALIGN_BOTTOM
		@ 000, 000 SAY oBtn120 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		oBtn120:Align  := CONTROL_ALIGN_BOTTOM
		nOpcSel := 0
		oBtn11 := TButton():New(0,0,"Rel.Endividam.",oWin1,{||  SelectRel() },00,14,,,.F.,.T.,.F.,,.F.,,,.F.)
		oBtn11:Align  := CONTROL_ALIGN_BOTTOM
		@ 000, 000 SAY oBtn110 PROMPT Space(100) SIZE 049, 001 OF oWin1 PIXEL
		oBtn110:Align  := CONTROL_ALIGN_BOTTOM


	EndIf

	//Browse
	DEFINE FWBROWSE oBrowse DATA TABLE ALIAS "SZY" OF oWin2

	//Adiciona Legenda no Browse
	ADD LEGEND DATA ' Empty(ZY_STATFIN) .Or. ZY_STATFIN == "0"  '	COLOR "BR_VERDE"	TITLE "Contrato em Aberto"	OF oBrowse
	ADD LEGEND DATA ' ZY_STATFIN == "1" '	COLOR "BR_AZUL"	    TITLE "Contrato Liberado"			OF oBrowse
	ADD LEGEND DATA ' ZY_STATFIN == "2" '	COLOR "BR_LARANJA"	TITLE "Parcialmente Pago"			OF oBrowse
	ADD LEGEND DATA ' ZY_STATFIN == "3" '	COLOR "BR_VERMELHO"	TITLE "Contrato Quitado/Baixado"	OF oBrowse


	//Colunas do Browse Principal
	ADD COLUMN oColumn1 DATA { || ZY_CODSEQ  } TITLE Posicione("SX3",2,"ZY_CODSEQ" ,"X3_TITULO") SIZE TamSx3("ZY_CODSEQ" )[1] OF oBrowse
	ADD COLUMN oColumn2 DATA { || ZY_REVISAO } TITLE Posicione("SX3",2,"ZY_REVISAO","X3_TITULO") SIZE TamSx3("ZY_REVISAO")[1] OF oBrowse
	ADD COLUMN oColumn3 DATA { || ZY_DESCEMP } TITLE Posicione("SX3",2,"ZY_DESCEMP","X3_TITULO") SIZE TamSx3("ZY_DESCEMP")[1] OF oBrowse
	ADD COLUMN oColumn4 DATA { || ZY_MODFIIN } TITLE Posicione("SX3",2,"ZY_MODFIIN","X3_TITULO") SIZE TamSx3("ZY_MODFIIN")[1] OF oBrowse
	ADD COLUMN oColumn5 DATA { || ZY_CODCONT	} TITLE Posicione("SX3",2,"ZY_CODCONT","X3_TITULO") SIZE TamSx3("ZY_CODCONT")[1] OF oBrowse
	ADD COLUMN oColumn6 DATA { || ZY_DTCONTR } TITLE Posicione("SX3",2,"ZY_DTCONTR","X3_TITULO") SIZE TamSx3("ZY_DTCONTR")[1] OF oBrowse
	ADD COLUMN oColumn7 DATA { || ZY_CODBCO 	} TITLE Posicione("SX3",2,"ZY_CODBCO" ,"X3_TITULO") SIZE TamSx3("ZY_CODBCO" )[1] OF oBrowse
	ADD COLUMN oColumn8 DATA { || ZY_BCOAGEN } TITLE Posicione("SX3",2,"ZY_BCOAGEN","X3_TITULO") SIZE TamSx3("ZY_BCOAGEN")[1] OF oBrowse
	ADD COLUMN oColumn9 DATA { || ZY_BCOCONT } TITLE Posicione("SX3",2,"ZY_BCOCONT","X3_TITULO") SIZE TamSx3("ZY_BCOCONT")[1] OF oBrowse

	
	oBrowse:CleanFilter()
	oBrowse:SetUseFilter()
	oBrowse:SetFilterDefault ( "SZY->ZY_FILIAL == '"  + xFilial("SZY") +  "' " )
	oBrowse:AddFilter( "Contrato em Aberto", ' Empty(ZY_STATFIN) .Or. ZY_STATFIN == "0"  '	, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/ )
	oBrowse:AddFilter( "Contrato Liberado", ' ZY_STATFIN == "1" '									, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/ )
	oBrowse:AddFilter( "Parcialmente Pago", ' ZY_STATFIN == "2" '									, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/)
	oBrowse:AddFilter( "Contrato Quitado/Baixado",' ZY_STATFIN == "3" '							, /*[ lNoCheck]*/.F.,/*[ lSelected]*/.F., /*[ cAlias]*/, /*[ lFilterAsk]*/, /*[ aFilParser]*/, /*[ cID]*/)

	//Ativa o Browse
	ACTIVATE FWBROWSE oBrowse

	ACTIVATE MSDIALOG oDlgEndiv CENTERED



Return


Static Function ADGF01INC(cAlias,nRecno,nOpcx)
	Local lRet := .F.
	//Local lRetorno		:= .T.
	Local aAlterFields 	:= {}
	Local lOkGrv 		:= .F.
	Local cFieldOk      := "U_AVLDDGCP(ReadVar())"
	Private cTitulo		:= cCadastro
	Private aSize 		:= {}
	Private aObjects 	:= {}
	Private aInfo 		:= {}
	Private aPosObj 	:= {}
	Private aPosGet 	:= {}
	Private lOkSaida := .F.
	Private aFields 	:= {"NOUSER"}
	Private aAltAcols 	:={"ZZ_PARAPAG","ZZ_VJURVARG","ZZ_DTPGPAR","ZZ_VRPGPAR"}
	Private nCols		:= 0
	Private nTotJurP 	:= 0
	Private nTotParP	:= 0
	Private nTotJrAP    := 0
	Private nTotJrAd		:= 0
	Private nTotIofP  	:= 0
	Private nTotParA  	:= 0


	Private nPosLin	:= 0

	Private _oDlg
	Private oGetdados

	Private VISUAL  := (nOpcx == 2)
	Private INCLUI	:= (nOpcx == 3)
	Private ALTERA	:= (nOpcx == 4)
	Private EXCLUI	:= (nOpcx == 5)

	Private oFont1	:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
	Private oFont2	:= TFont():New("Verdana",,044,,.T.,,,,,.F.,.F.)
	Private oFont18	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)

	Static oEnchoice
	PRIVATE aTELA[0][0]
	PRIVATE aGETS[0]
	PRIVATE lTemMvBco := .F.
	Private nOPCselX	:= 0
	Default nRecno := 0

	aSize	:= MsAdvSize( .F. )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 005, .T., .F. } )

	aPosObj	:= MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

	DbSelectarea("SZY")

//Carrega Variaveis na Memoria
	RegToMemory("SZY", .T., .T.,.T.)
	aEval(ApBuildHeader("SZY", Nil), {|x| Aadd(aFields, x[2])})
	aAlterFields := aClone(aFields)
	If Len(aCols) > 1
		aCols := aClone(aColsNew)
	EndIf
	DEFINE MSDIALOG _oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oFWLayer2 := FWLayer():New()
	oFWLayer2:Init(_oDlg,.F.)

	oFWLayer2:AddCollumn("Col03",07,.T.)
	oFWLayer2:AddCollumn("Col04",93,.T.)

	oFWLayer2:AddWindow("Col03","Win03"	,"Açoes"				,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win04"	,"Dados do Contrato"	,045,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win05"	,"Parcelas do Contrato"	,042,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win07"	,"Total do Parcelament"	,013,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin3 := oFWLayer2:GetWinPanel("Col03","Win03")
	oWin4 := oFWLayer2:GetWinPanel("Col04","Win04")
	oWin5 := oFWLayer2:GetWinPanel("Col04","Win05")
	oWin7 := oFWLayer2:GetWinPanel("Col04","Win07")

	@ 000, 000 BTNBMP oBitmap1  RESNAME "FINAL"  SIZE 008, 035 OF oWin3 MESSAGE "Sair";
		Action( If(MSGYESNO("Deseja realmente sair do sistema?","Validação"),lOkSaida:=.T.,),IIF(lOkSaida,_oDlg:End(),))
	oBitmap1:cCaption := " <F4>"
	oBitmap1:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{||If(MSGYESNO("Deseja realmente sair do sistema?","Validação"),lOkSaida:=.T.,),IIF( lOkSaida,_oDlg:End(),)})

	@ 000, 000 BTNBMP oBitmap2  RESNAME "OK"  SIZE 008, 035 OF oWin3 MESSAGE "Gravar Contrato" ;
		Action( Iif(ValidGRV(nOpcx,{{"SZY"},{"SZZ"}}),lOkGrv := GravEmpr(),MsgStop("Erro de Gravação","Erro")),IIF(lokGrv,_oDlg:End(),/*Else*/),IIF(lokGrv,nOPCselX := 1,/*Else*/))
	oBitmap2:cCaption := "<F10>"
	oBitmap2:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F10,{||  Iif(ValidGRV(nOpcx,{{"SZY"},{"SZY"}}), lOkGrv := GravEmpr(),MsgStop("Erro de Gravação","Erro")),iIf(lOkGrv,_oDlg:End(),/*Else*/),IIF(lokGrv,nOPCselX := 1,/*Else*/),Nil } )
	oBitmap2:LVISIBLECONTROL := IIF(INCLUI .or. ALTERA,.T.,.F.)

	@ 000, 000 BTNBMP oBitmap3  RESNAME "PRECO"  SIZE 008, 035 OF oWin3 MESSAGE "Gerar Parcelas" ;
		Action(IIF(INCLUI .And. obrigatorio(aGets,aTela),CalcParcel(M->ZY_CODSEQ,M->ZY_REVISAO,M->ZY_CODCONT,nOpcx),Nil) )
	oBitmap3:cCaption := "<F9>"
	oBitmap3:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F9,{|| IIF(INCLUI .And. obrigatorio(aGets,aTela) ,CalcParcel(M->ZY_CODSEQ,M->ZY_REVISAO,M->ZY_CODCONT,nOpcx),Nil) })
	oBitmap3:LVISIBLECONTROL := INCLUI

	@ 000, 000 BTNBMP oBitmap4  RESNAME "BMPVISUAL"  SIZE 008, 035 OF oWin3 MESSAGE "Resumo Contrato" ;
		Action( ResumoCtr(SZY->ZY_CODSEQ,SZY->ZY_REVISAO) )
	oBitmap4:cCaption := "<F8>"
	oBitmap4:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F8,{|| /*Iif(.T.,(nOpcA:=1,_oDlg:End()),Nil)*/ })

	/*
	@ 000, 000 BTNBMP oBitmap5  RESNAME "SALARIOS"  SIZE 008, 035 OF oWin3 MESSAGE "Pagar Parcela" ;
	Action( (nOpcA:=1,_oDlg:End()) )
	oBitmap5:cCaption := "<F7>"
	oBitmap5:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F7,{|| Iif(VE07Valid(),(nOpcA:=1,_oDlg:End()),Nil) })
	*/
	@ 000, 000 BTNBMP oBitmap6  RESNAME "PEDIDO"  SIZE 008, 035 OF oWin3 MESSAGE "Liquidar Contrato" ;
		Action( (nOpcA:=1,_oDlg:End()) )
	oBitmap6:cCaption := "<F6>"
	oBitmap6:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F6,{|| Iif(VE07Valid(),(nOpcA:=1,_oDlg:End()),Nil) })
	oBitmap6:LVISIBLECONTROL := VISUAL //Apenas se for na visualização.

	//Enchoice
	lMemory := .T.

	oEnchoice := MsMGet():New("SZY",nRecno,nOpcx,,,,aFields,aPosObj[1],aAlterFields,1,,,,oWin4,.F./*lConF3*/,.T./*lMemory*/,.F./*lColuna*/,/*caTela*/,;
							  /*lNoFolder*/,/*lProperty*/,/*aField*/,/*aFolder*/,/*lCreate afolder*/,/*lNoMDIStretch*/,,.F./*lOrderACho*/)

	oGetDados := MsNewGetDados():New(0,0,0,0,nOpcx,/*lLinOk*/"U_VLDLACOLS",/*lTudOk*/,"+ZZ_NROPAR"/*CpoInc*/,aAlterAcols,,,cFieldOk,,,oWin5,aHeader,aCols)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDados:BCHANGE := {|| U_AVLDDGCP(ReadVar())}
	oGetDados:BFIELDOK := {|| U_AVLDDGCP(ReadVar())}


	oTGet1 := TGet():New(01,110, {|| ROUND(nTotParP,2)}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParP")
	oTGet2 := TGet():New(01,180, {|| ROUND(nTotJurP,2)}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet3 := TGet():New(01,250, {|| ROUND(nTotJrAP,2)}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet4 := TGet():New(01,320, {|| ROUND(nTotIofP,2)}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotIofP")
	oTGet5 := TGet():New(01,460, {|u| If( PCount() > 0,ROUND(nTotParA,2),ROUND(nTotParA,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParA")

	ACTIVATE MSDIALOG _oDlg ON INIT({|| If(!obrigatorio(aGets,aTela),nOpcA:=0,_oDlg:End()) }) CENTERED

	If lOkSaida .OR. nOPCselX == 0
		ROLLBACKSXE()
	EndIf

	If nOpcX == 1
		//CLICOU EM OK

	Else
		//CLICOU EM CANCELAR
	EndIf

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGFIN001  ºAutor  ³Jackson Santos      º Data ³  18/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Programa de Alteração dos Dados                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



Static Function ADGF01ALT(cAlias,nRecno,nOpcx)
	Local lRet := .F.
	//Local lRetorno		:= .T.
	Local nI
	Local cFieldOk      	:= "U_AVLDDGCP(ReadVar())
	Private aFields 		:= {"NOUSER"}
	Private aAlterFields 	:= {}
	Private aAltAcols		:= {}
	Private cTitulo		:= cCadastro
	Private aSize 		:= {}
	Private aObjects 	:= {}
	Private aInfo 		:= {}
	Private aPosObj 	:= {}
	Private aPosGet 	:= {}
	Private nUsado 		:= 0
	Private nCols		:= 0
	Private nTotJurP 	:= 0
	Private nTotParP	:= 0
	Private nTotJrAP    := 0
	Private nTotIofP  	:= 0
	Private nTotParA  	:= 0
	Private _oDlg
	Private oGetdados
	PRIVATE aTELA[0][0]
	PRIVATE aGETS[0]

	Private lAltOK  := (Empty(SZY->ZY_STATFIN) .Or. SZY->ZY_STATFIN == "0")
	Private oFont1	:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
	Private oFont2	:= TFont():New("Verdana",,044,,.T.,,,,,.F.,.F.)
	Private oFont18	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)

	Static oEnchoice
	Default nRecno := 0

	If SZY->ZY_XCTRIMP == "S"
		aAltAcols 	:={"ZZ_VLRPRIN","ZZ_VLRJUR","ZZ_VJURAPG","ZZ_PARAPAG","ZZ_VJURVAR","ZZ_DTPGPAR","ZZ_VRPGPAR","ZZ_NPARSE2"}
	Else
		aAltAcols 	:={"ZZ_VJURAPG","ZZ_PARAPAG","ZZ_VJURVAR","ZZ_DTPGPAR","ZZ_VRPGPAR","ZZ_NPARSE2"}
	EndIf

	INCLUI	:= (nOpcx == 3)
	ALTERA	:= (nOpcx == 4)
	EXCLUI	:= (nOpcx == 5)

	aSize	:= MsAdvSize( .F. )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 005, .T., .F. } )

	aPosObj	:= MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

	DbSelectarea("SZY")

//Carrega Variaveis na Memoria
	RegToMemory("SZY", .F., .T.,.F.)
	aEval(ApBuildHeader("SZY", Nil), {|x| Aadd(aFields, x[2])})
	aAlterFields := aClone(aFields)

	aAlterAcols := aAltAcols
	aAlteraSZZ := {}
	nContReg := 0
	DbSelectArea("SZZ")
	SZZ->(DbSetOrder(1))
	SZZ->(DbGoTop())
	if SZZ->(DBSEEK(SZY->ZY_FILIAL + SZY->ZY_CODSEQ + SZY->ZY_REVISAO))
		While SZZ->(!EOF()) .And. SZZ->ZZ_FILIAL + SZZ->ZZ_CODSEQ + SZZ->ZZ_REVISAO == SZY->ZY_FILIAL + SZY->ZY_CODSEQ + SZY->ZY_REVISAO
			AaDd(aAlteraSZZ, Array(Len(aCols[1])))
			//aAlteraSZZ[Len( aAlteraSZZ)] := aCols[1]
			nContReg ++
			For nI := 1 to Len(aHeader)
				aAlteraSZZ[nContReg][nI] := SZZ->&(aHeader[nI][2])
			Next nI
			aAlteraSZZ[nContReg][Len(aAlteraSZZ[nContReg])] := .F.
			SZZ->(DbSkip())
		EndDo
		aCols := aAlteraSZZ
	Else
		MsgStop("Não foi encontrado nenhum registro para alteração","Erro Registro")
	Endif

	DEFINE MSDIALOG _oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oFWLayer2 := FWLayer():New()
	oFWLayer2:Init(_oDlg,.F.)

	oFWLayer2:AddCollumn("Col03",07,.T.)
	oFWLayer2:AddCollumn("Col04",93,.T.)

	oFWLayer2:AddWindow("Col03","Win03"	,"Açoes"				,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win04"	,"Dados do Contrato"	,045,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win05"	,"Parcelas do Contrato"	,042,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win07"	,"Total do Parcelament"	,013,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin3 := oFWLayer2:GetWinPanel("Col03","Win03")
	oWin4 := oFWLayer2:GetWinPanel("Col04","Win04")
	oWin5 := oFWLayer2:GetWinPanel("Col04","Win05")
	oWin7 := oFWLayer2:GetWinPanel("Col04","Win07")

	@ 000, 000 BTNBMP oBitmap1  RESNAME "FINAL"  SIZE 008, 035 OF oWin3 MESSAGE "Sair" ;
		Action( If(MSGYESNO("Deseja realmente sair do sistema?","Validação"), _oDlg:End(),))
	oBitmap1:cCaption := " <F4>"
	oBitmap1:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{|| If(MSGYESNO("Deseja realmente sair do sistema?","Validação"), _oDlg:End(),) })


	@ 000, 000 BTNBMP oBitmap2  RESNAME "OK"  SIZE 008, 035 OF oWin3 MESSAGE "Confirmar" ;
		Action( Iif(ValidGRV(nOpcx,{{"SZY"},{"SZZ"}}),lOkGrv := GravEmpr(),MsgStop("Erro de Gravação","Erro")),IIF(lokGrv,_oDlg:End(),/*Else*/))
	oBitmap2:cCaption := "<F10>"
	oBitmap2:Align  := CONTROL_ALIGN_TOP
	SetKey(VK_F10,{||  Iif(ValidGRV(nOpcx,{{"SZY"},{"SZY"}}), lOkGrv := GravEmpr(),MsgStop("Erro de Gravação","Erro")),iIf(lOkGrv,_oDlg:End(),/*Else*/),Nil } )

	//Se não Tiver liberado para o financeiro altera recalcula parcela.
	If SZY->ZY_STATFIN $ " /0"
		@ 000, 000 BTNBMP oBitmap3  RESNAME "PRECO"  SIZE 008, 035 OF oWin3 MESSAGE "Gerar Parcelas" ;
			Action(IIF(ALTERA .And. obrigatorio(aGets,aTela),CalcParcel(M->ZY_CODSEQ,M->ZY_REVISAO,M->ZY_CODCONT,nOpcx),Nil) )
		oBitmap3:cCaption := "<F9>"
		oBitmap3:Align  := CONTROL_ALIGN_TOP
		SetKey(VK_F9,{|| IIF(ALTERA .And. obrigatorio(aGets,aTela) ,CalcParcel(M->ZY_CODSEQ,M->ZY_REVISAO,M->ZY_CODCONT,nOpcx),Nil) })
		oBitmap3:LVISIBLECONTROL := ALTERA

	EndIf
	//Enchoice
	lMemory := .T.
	nStyle := GD_UPDATE + GD_DELETE
	oEnchoice := MsMGet():New("SZY",nRecno,nOpcx,,,,aFields,aPosObj[1],aAlterFields,,,,,oWin4,,.T.)

	oGetDados := MsNewGetDados():New(0,0,0,0,nStyle,"U_VLDLACOLS",,,aAlterAcols,,Len(aCols),cFieldOk,,,oWin5,aHeader,aCols)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	oGetDados:oBrowse:lUseDefaultColors := .F.
	oGetDados:BCHANGE := {|| U_AVLDDGCP(ReadVar())}
	oGetDados:BFIELDOK := {|| U_AVLDDGCP(ReadVar())}


	oTGet1 := TGet():New(01,110, {|u| If( PCount() > 0,ROUND(nTotParP,2),ROUND(nTotParP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParP")
	oTGet2 := TGet():New(01,180, {|u| If( PCount() > 0,ROUND(nTotJurP,2),ROUND(nTotJurP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet3 := TGet():New(01,250, {|u| If( PCount() > 0,ROUND(nTotJrAP,2),ROUND(nTotJrAP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet4 := TGet():New(01,320, {|u| If( PCount() > 0,ROUND(nTotIofP,2),ROUND(nTotIofP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotIofP")
	oTGet5 := TGet():New(01,460, {|u| If( PCount() > 0,ROUND(nTotParA,2),ROUND(nTotParA,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParA")


	ACTIVATE MSDIALOG _oDlg CENTERED

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DGFIN001  ºAutor  ³Jackson Santos      º Data ³  18/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Programa de Visualização dos Dado                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß3ßßßßßßß
*/

Static Function ADGF001VIS(cAlias,nRecno,nOpcx)
	Local lRet := .F.
	//Local lRetorno		:= .T.
	Local aFields 		:= {"NOUSER"}
	Local cNoFields
	Local cFieldOk      := "U_AVLDDGCP(ReadVar())"
	Local aAlterFields 	:= {}
	Local nI
	Private cTitulo		:= cCadastro
	Private aSize 		:= {}
	Private aObjects 	:= {}
	Private aInfo 		:= {}
	Private aPosObj 	:= {}
	Private aPosGet 	:= {}
	Private nUsado 		:= 0
	Private nCols		:= 0
	Private nTotJurP 	:= 0
	Private nTotParP	:= 0
	Private nTotJrAP    := 0
	Private nTotIofP  	:= 0
	Private nTotParA  	:= 0

	Private aTELA 		:= {}
	Private aGETS 		:= {}

	Private _oDlg
	Private oGetdados

	Private oFont1	:= TFont():New("Verdana",,024,,.T.,,,,,.F.,.F.)
	Private oFont2	:= TFont():New("Verdana",,044,,.T.,,,,,.F.,.F.)
	Private oFont18	:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)

	Static oEnchoice
	Default nRecno := 0

	cNoFields     := "ZZ_CODSEQ/ZZ_REVISAO/ZZ_CODCONT"

	INCLUI	:= (nOpcx == 3)
	ALTERA	:= (nOpcx == 4)
	EXCLUI	:= (nOpcx == 5)

	aSize	:= MsAdvSize( .F. )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 005, .T., .F. } )

	aPosObj	:= MsObjSize(aInfo,aObjects)
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

	DbSelectarea("SZY")
	SZY->(DbSetOrder(1))
	SZY->(DbGoTo(nRecno))
//Carrega Variaveis na Memoria
	RegToMemory("SZY", .F., .F.,.F.)
	aEval(ApBuildHeader("SZY", Nil), {|x| Aadd(aFields, x[2])})
	aAlterFields := aClone(aFields)


	aVisualSZZ := {}
	nContReg := 0
	DbSelectArea("SZZ")
	SZZ->(DbSetOrder(1))
	if SZZ->(DBSEEK(SZY->ZY_FILIAL + SZY->ZY_CODSEQ + SZY->ZY_REVISAO))
		While SZZ->(!EOF()) .And. SZZ->ZZ_FILIAL + SZZ->ZZ_CODSEQ + SZZ->ZZ_REVISAO == SZY->ZY_FILIAL + SZY->ZY_CODSEQ + SZY->ZY_REVISAO
			AaDd(aVisualSZZ, Array(Len(aCols[1])))
			nContReg ++
			For nI := 1 to Len(aHeader)
				aVisualSZZ[nContReg][nI] := SZZ->&(aHeader[nI][2])
			Next nI
			aVisualSZZ[nContReg][Len(aVisualSZZ[nContReg])] := .F.
			SZZ->(DbSkip())
		EndDo
		aCols := aVisualSZZ
	Else
		MsgStop("Não Foi econtrato Registro na tabela de Itens para o contrato.","Erro na Pesquisa")
	Endif

	DEFINE MSDIALOG _oDlg TITLE cCadastro FROM aSize[7],aSize[1] TO aSize[6],aSize[5] OF oMainWnd PIXEL

	oFWLayer2 := FWLayer():New()
	oFWLayer2:Init(_oDlg,.F.)

	oFWLayer2:AddCollumn("Col03",07,.T.)
	oFWLayer2:AddCollumn("Col04",93,.T.)

	oFWLayer2:AddWindow("Col03","Win03"	,"Açoes"				,100,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win04"	,"Dados do Contrato"	,045,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win05"	,"Parcelas do Contrato"	,042,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)
	oFWLayer2:AddWindow("Col04","Win07"	,"Total do Parcelament"	,013,.F.,.F.,/*bAction*/,/*cIDLine*/,/*bGotFocus*/)

	oWin3 := oFWLayer2:GetWinPanel("Col03","Win03")
	oWin4 := oFWLayer2:GetWinPanel("Col04","Win04")
	oWin5 := oFWLayer2:GetWinPanel("Col04","Win05")
	oWin7 := oFWLayer2:GetWinPanel("Col04","Win07")

	@ 000, 000 BTNBMP oBitmap1  RESNAME "FINAL"  SIZE 008, 035 OF oWin3 MESSAGE "Sair" Action( _oDlg:End() )
	oBitmap1:cCaption := " <F4>"
	oBitmap1:Align  := CONTROL_ALIGN_BOTTOM
	SetKey(VK_F4 ,{|| _oDlg:End() })

	//Enchoice
	lMemory := .T.
	oEnchoice := MsMGet():New("SZY",nRecno,nOpcx,,,,aFields,aPosObj[1],/*aAlterFields*/,,,cFieldOk,,oWin4,,.F.)

	oGetDados := MsNewGetDados():New(0,0,0,0,nOpcx,,,,/*aAlterAcols*/,,Len(aCols),,,,oWin5,aHeader,aCols)
	oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	//oGetDados:oBrowse:lUseDefaultColors := .F.
	oGetDados:BCHANGE := {|| U_AVLDDGCP(ReadVar())}
	oGetDados:BFIELDOK := {|| U_AVLDDGCP(ReadVar())}

	oTGet1 := TGet():New(01,110, {|u| If( PCount() > 0,ROUND(nTotParP,2),ROUND(nTotParP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParP")
	oTGet2 := TGet():New(01,180, {|u| If( PCount() > 0,ROUND(nTotJurP,2),ROUND(nTotJurP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet3 := TGet():New(01,250, {|u| If( PCount() > 0,ROUND(nTotJrAP,2),ROUND(nTotJrAP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet4 := TGet():New(01,320, {|u| If( PCount() > 0,ROUND(nTotIofP,2),ROUND(nTotIofP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotIofP")
	oTGet5 := TGet():New(01,460, {|u| If( PCount() > 0,ROUND(nTotParA,2),ROUND(nTotParA,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParA")

	ACTIVATE MSDIALOG _oDlg CENTERED

Return lRet


Static Function ADGF001EXC(cAlias,nRecno,nOpcx)
	Local lRetExc := .F.
	Local cAliasIt := IIF(cAlias == "SZY","SZZ","")
	Default cAlias := ""
	Default nRecno := 0
	Default nOpcx  := 0

//Exclusão do Contrato
	If nOpcx == 5 .And. (Empty(SZY->ZY_STATFIN) .Or. SZY->ZY_STATFIN == "0")
		DBSelectArea(cAlias)
		(cAlias)->(DbSetOrder(1))
		(cAlias)->(DbGoTo(nRecno))

		//Validar a quantidade de registro na tabela de Itens

		cQVldSZZ := " SELECT COUNT(*) QTDITENS "
		cQVldSZZ += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ "
		cQVldSZZ += ENTER + " WHERE SZZ.D_E_L_E_T_='' "
		cQVldSZZ += ENTER + " AND SZZ.ZZ_FILIAL  = '" + (cAlias)->&(Substr(cAlias,2,2) + "_FILIAL" ) +"' "
		cQVldSZZ += ENTER + " AND SZZ.ZZ_CODSEQ  = '" + (cAlias)->&(Substr(cAlias,2,2) + "_CODSEQ" ) + "' "
		cQVldSZZ += ENTER + " AND SZZ.ZZ_REVISAO = '" + (cAlias)->&(Substr(cAlias,2,2) + "_REVISAO") + "' "

		If Select("TVLDREG") > 0
			TVLDREG->(DbCloseArea())
		EndIf
		TCQUERY cQVldSZZ NEW ALIAS "TVLDREG"
		nQtdRegIt := TVLDREG->QTDITENS
		TVLDREG->(DBCloseArea())

		DBSelectArea(cAliasIt)
		(cAliasIt)->(DbSetOrder(1))
		(cAliasIt)->(DbGotop())
		nQtdItCanc := 0
		If (cAliasIt)->(DbSeek((cAlias)->&(Substr(cAlias,2,2) + "_FILIAL") + (cAlias)->&(Substr(cAlias,2,2) + "_CODSEQ") + (cAlias)->&(Substr(cAlias,2,2) + "_REVISAO")))
			If MsgYesNo("Deseja Realmente Excluir o Contrato de Emprestimo Número: " + SZY->ZY_CODCONT + CHAR(13) + CHAR(10) + ;
					" - Referência do Sistema: " + SZY->ZY_CODSEQ +"-"+ SZY->ZY_REVISAO + " ?","Alerta de Exclusão")
				BEGIN Transaction
					While (cAliasIt)->(!EOF()) .And. ;
							(cAlias)->&(Substr(cAlias,2,2) + "_FILIAL") + (cAlias)->&(Substr(cAlias,2,2) + "_CODSEQ") + (cAlias)->&(Substr(cAlias,2,2) + "_REVISAO") == ;
							(cAliasIt)->&(Substr(cAliasIt,2,2) + "_FILIAL") + (cAliasIt)->&(Substr(cAliasIt,2,2) + "_CODSEQ") + (cAliasIt)->&(Substr(cAliasIt,2,2)+ "_REVISAO")
						Reclock(cAliasIt,.F.)
						(cAliasIt)->(DbDelete())
						(cAliasIt)->(MsUnlock())
						nQtdItCanc ++
						(cAliasIt)->(DbSkip())
					EndDo
					If nQtdItCanc == nQtdRegIt
						RecLock(cAlias,.F.)
						(cAlias)->(DbDelete())
						(cAlias)->(MsUnlock())
						lRetExc := .T.
					Else
						//Se der algum erro ao excluir o registro da Rollback na Transação.
						lRetExc := .F.
						DisarmTransaction()
					EndIf
				END Transaction
			Else
				lRetExc := .F.
			EndIf
		Else
			MsgStop("Não Foi encontrado nehum registro para exclusão","Erro Exclusão")
		EndIf
	Else
		IF !SZY->ZY_STATFIN $ " /0"
			MsgStop("Status do Contrato não Permite Exclusão.","Erro Exclusão")
		Else
			MsgStop("Opção de Entrada da Rotina Incorreta para a exclsuão do Registro.","Erro Exclusão")
		EndIf
	EndIf

	If !lRetExc
		MsgStop("Houve algum erro ao tentar excluir o registro, a operação foi abortada!","Erro Exclusão")
	EndIf
Return lRetExc

Static Function ADGF001QUIT(cAlias,nRecno,nOpcx,cCodContr,cCodRev)
	Local lRetQuit := .T.
	//Local lRet := .F.
	Local oDlgQt
	Local cTitulo := "Quitação do Contrato"
	Private oFont   		:= TFont():New("Courier New",,-12,.T.)
	Private oFont1  		:= TFont():New("Courier New",,-14,.T.)
	Private oFont3  		:= TFont():New("Arial"      ,,-16,.T.)
	Private nOpcQuit  := 0
	Default cCodContr := SZY->ZY_CODSEQ
	Default cCodRev   := SZY->ZY_REVISAO

	cDescContr 	:= SZY->ZY_DESCEMP
	nQtdParcTot := SZY->ZY_QTDPARC
	nVlrContrat := SZY->ZY_VLRCONT
	nQtdParcEAb := 0
	nVlrSldPrin := 0
	nVlrSldJuro := 0
	nVlrSldIOF	:= 0
	nVlrSldIOF2 := 0
	nVLrSldJVar := 0
	nVlrSldTot	:= 0

	cQrySld := " SELECT COUNT(*) QTDPAR,SUM(ZZ_VLRPRIN) PRINCIPAL , SUM(ZZ_VLRJUR) JUROS , "
	cQrySld += ENTER + " SUM(ZZ_VLRPRIN + ZZ_VLRJUR) TOTSLDCONT, "
	cQrySld += ENTER + " SUM(ZZ_VLRIOF) VLRIOF, SUM(ZZ_IOFAPAG) IOFAPG "
	cQrySld += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' AND SZZ.ZZ_DTPGPAR = '' "
	cQrySld += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "' AND SZZ.ZZ_REVISAO = '" + cCodRev + "' "

	IF Select("TSALD") > 0
		TSALD->(DBCloseArea())
	EndIf
	TCQUERY cQrySld NEW ALIAS "TSALD"


	While TSALD->(!EOF())
		nQtdParcEAb := TSALD->QTDPAR
		nVlrSldPrin := TSALD->PRINCIPAL
		nVlrSldJuro := TSALD->JUROS
		nVlrSldIOF	:= TSALD->VLRIOF
		nVlrSldIOF2 := TSALD->IOFAPG
		nVLrSldJVar := 0
		nVlrSldTot  := TSALD->TOTSLDCONT
		TSALD->(DbSkip())
	EndDo
	IF Select("TSALD") > 0
		TSALD->(DBCloseArea())
	EndIf
	DEFINE MSDIALOG oDlgQt TITLE cTitulo  FROM 0,0 TO 500,800 OF oMainWnd PIXEL
	@ 010, 010 To 250,400 Label "Valores para Quitação." Of oDlgQt Pixel

	// Fornecedor
	@ 030, 020 Say "Codigo/Revisao/Descrição: " Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cContrDesc := cCodContr + " - " + cCodRev + " - " + cDescContr
	@ 040, 020 MsGet  cContrDesc	Picture "@!"  SIZE 220,10 When .F. Of oDlgQt Pixel

	@ 060, 020 Say "Qtd.Parcelas Orig.:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cQtdParcTot := TRANSFORM(nQtdParcTot,"@E 999,999,999.99")
	@ 070, 020 MsGet cQtdParcTot 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel


	@ 060, 0130 Say "Vlr.Total Original:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cVlrContrat := TRANSFORM(nVlrContrat,"@E 999,999,999.99")
	@ 070, 0130 MsGet cVlrContrat 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel

	@ 060, 240 Say "Vlr.Saldo Total:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cVlrSldTot := TRANSFORM(nVlrSldTot,"@E 999,999,999.99")
	@ 070, 240 Get cVlrSldTot /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel

	@ 090, 020 Say "Vlr.Saldo Principal:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cVlrPrincipal := TRANSFORM(nVlrSldPrin,"@E 999,999,999.99")
	@ 100, 020 MsGet cVlrPrincipal 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel

	@ 090, 130 Say "Vlr.Saldo do Juros:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cVlrSldJuro := TRANSFORM(nVlrSldJuro,"@E 999,999,999.99")
	@ 100, 130 MsGet cVlrSldJuro	/*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel


	@ 090, 240 Say "Vlr.Saldo IOF" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cVlrSldIOF := TRANSFORM(nVlrSldIOF,"@E 999,999,999.99")
	@ 100, 240 MsGet cVlrSldIOF /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgQt Pixel

	@ 120, 020 Say "Data Quitação:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cDtQuitacao := DTOC(DDATABASE)
	@ 135, 020 MsGet cDtQuitacao /*Picture "@!"*/ SIZE 100,10 When .T. Of oDlgQt Pixel

	@ 120, 130 Say "Vlr.De Quitação :" Size 170,10 FONT oFont1 COLOR CLR_RED Of oDlgQt Pixel
	nVlrQuitacao := 0 //TRANSFORM(0,"@E 999,999,999.99")
	@ 135, 130 MsGet nVlrQuitacao Picture "@E 999,999,999.99" SIZE 100,10 When .T. Of oDlgQt Pixel

	@ 120, 240 Say "Contrato Quitação.:" Size 170,10 FONT oFont1 COLOR CLR_RED Of oDlgQt Pixel
	cContQuit := SPACE(6)
	@ 135, 240 MsGet cContQuit /*Picture "@!"*/ F3 "SZY" SIZE 100,10 When .T. Of oDlgQt Pixel

	cCodBco := SPACE(3)
	@ 150, 020 Say "Banco:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	@ 165, 020 MsGet cCodBco  Picture "@E 999"   F3 "SA6" SIZE 100,10 When .T.  Of oDlgQt Pixel

	@ 150, 130 Say "Agência:" Size 170,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cCodAgen := SPACE(5)
	@ 165, 130 MsGet cCodAgen Picture "@E 99999" SIZE 100,10 When .T. Of oDlgQt Pixel

	@ 150, 240 Say "Conta:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	cCodConta := SPACE(10)
	@ 165, 240 MsGet cCodConta Picture "@E 9999999999" SIZE 100,10 When .T. Of oDlgQt Pixel

	cMotivQuit := ""
	aMotivQuit := {"1-Antecipada","2-Reompra"}
	@ 180, 020 Say "Motivo Quitação:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgQt Pixel
	@ 195, 020 ComboBox cMotivQuit Items aMotivQuit SIZE 100,10 Of oDlgQt Pixel

	// ocorre erro (Sintax error) ao compilar está linha avaliar se fonte é utilizado.
	//DEFINE SBUTTON oSButton1 TITLE "Quitar" FROM 230, 120 TYPE 1 OF oDlgQt ENABLE ACTION ( IIF(MsgYesNo("Deseja executar a quitação com os dados informados?","Quitar"),(nOpcQuit:=1,oDlgQt:End()),) )
	//DEFINE SBUTTON oSButton4 TITLE "Sair" FROM 230, 160 TYPE 2 OF oDlgQt ENABLE ACTION (oDlgQt:End() )


	ACTIVATE MSDIALOG oDlgQt CENTERED

	IF Select("TSALD") > 0
		TSALD->(DBCloseArea())
	EndIf

	If nOpcQuit == 1 //Quitação

		cQryProc := " SELECT ZZ_CODSEQ,ZZ_REVISAO,ZZ_NPARSE2,ZZ_VLRPRIN, ZZ_VLRJUR,ZZ_VLRIOF,ZZ_IOFAPAG "
		cQryProc += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' AND SZZ.ZZ_DTPGPAR = '' "
		cQryProc += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "' AND SZZ.ZZ_REVISAO = '" + cCodRev + "' "

		IF SELECT("TPROC") > 0
			TPROC->(DbCloseArea())
		Endif

		TCQUERY cQryProc NEW ALIAS "TPROC"
		nContpar := 0
		aRetErrQt := {}
		lRetQt	 := .F.
		cE2_NUM     := Space(09)
		cE2_TIPO  	:= Space(03)
		cE2_NATUREZ := Space(10)
		cE2_FORNECE := Space(06)
		cE2_LOJA		:= Space(02)

		BEGIN TRANSACTION
			While TPROC->(!EOF())
				nContpar ++
				MsgRun("Aguarde,Executando quitação do Contrato. Parc:" + STRZERO(nContpar,3) + " De: " + STRZERO(nQtdParcEAb,3) ,"Quitação.",{||aRetErrQt := QUITCONTR(TPROC->ZZ_CODSEQ,TPROC->ZZ_REVISAO,TPROC->ZZ_NPARSE2,cCodBco,cCodAgen,cCodConta)})
				TPROC->(DbSkip())
			EndDo
			If Len(aRetErrQt) > 0
				DisarmTransaction()
				lRetQt := .T.
			Else
				lRetQt := .T. //Retorno Ok da Baixa
			EndIf
		END TRANSACTION

		If lRetQt
			MsgRun("Aguarde,Executando quitação do Contrato. Gerando Parcela Unica" ,"Quitação.",{||aRetErrQt := QTCGERPUN(TPROC->ZZ_CODSEQ,TPROC->ZZ_REVISAO,TPROC->ZZ_NPARSE2,cCodBco,cCodAgen,cCodConta)})
			If Len(aRetErrQt) > 0
				lRetQt := .F.
			Else
				lRetQt := .T. //Retorno Ok da Baixa
			EndIf
		EndIf


	ElseIf nOpcQuit == 2 //Estorno da quitação


	EndIf
Return lRetQuit
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VALCOD     ºAutor  ³ Jackson Santos    º Data ³  14/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteração do Item				                          º±±
±±º          ³ Validacao do produto.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VALIDGRV(nOpca,aTabsVld,aCposVld)

	//Local nPosAcol	:= 0
	//Local nLenAcol	:= 0
	Local lRet			:= .T.
	//Local nPosJurVar	:= aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VJURVAR" } )
	Local nY
	Default nOpca := 0
	Default aCposVld := {}
	Default aTabsVld := {}

//Validar a inclusão
	If nOpca == 3
		//Campos Especificos a serem validados
		If Len(aCposVld) > 0
			For nY := 1 to Len(aCposVld)
				&("nPos" + Substr(aCposVld[nY][1],5)) := aScan( aHeader, {|x| Alltrim(x[2]) == &(Substr(cAliasVld,2) + "_CODSEQ")  } )
			Next nY
		EndIf

		//Valida se todos os campos obrigatórios Foram preenchidos.
		If !obrigatorio(aGets,aTela)
			MsgStop("Existem Campos Obrigatorios não preenchidos.","Erro Validação")
			lRet := .F.
		EndIf

		//Validação da Quantidade de Parcelas Geradas
		If lRet .And. Len(oGetDados:aCols) < M->ZY_QTDPARC
			MsgStop("A quantidade de Parcelas geradas é menor que a informada no cabeçalho do contrato.","Erro Validação")
			lRet := .F.
		EndIf

		//Validação do IOF
		If lRet .And. M->ZY_TIPOIOF == "2" .And. M->ZY_VRIOFCT <= 0 //Avista
		/*Se o IOF for a vista é preciso informar o valor para gerar o título no Financeiro*/
			MsgStop("Valor do IOF inválido ou não informado para o 'tipo de pagamento do IOF escclhido'.Favor corrigir!","Erro Validação")
			lRet := .F.
		EndIf

		//Validação da TAC
		If lRet .And. M->ZY_TIPOTAC == "1" .And. M->ZY_VLRTAC <= 0
		/*Se o IOF for a vista é preciso informar o valor para gerar o título no Financeiro*/
			MsgStop("Valor da TAC inválido ou não informado para o 'tipo de pagamento da TAC escclhido'.Favor corrigir!","Erro Validação")
			lRet := .F.
		EndIf


		//Validação da Data de Crédito para Emprestimos com movimento bancário
		cMvtoBco := POSICIONE("SZW",1,xFilial("SZW") + M->ZY_MODFIIN,"ZW_MOVBANC")
		lTemMvBco := ( Alltrim(cMvtoBco) == "S")
		If lRet .And. !Empty(Alltrim(DTOS(M->ZY_DTCRED))) .And. lTemMvBco
		/*Se o IOF for a vista é preciso informar o valor para gerar o título no Financeiro*/
			MsgStop("Contrato com movimentação bancárias Sem data de Crédito Preenchida. Favor preencher o campo de Dt.Cred.!","Erro Validação")
			lRet := .F.
		EndIf
	EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SetCor    ºAutor  ³ Jackson Santos     º Data ³  18/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Definição das cores do get de acordo com as quantidades    º±±
±±º          ³conferidas.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Static Function SetCor(nLinCol)
Local nRet		:= 16777215
Local nPosIOFA	:= aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_IOFAPAG" } ) 

	If nLinCol == nPosLin
	nRet := 12632256
	ElseIf oGetDados:aCols[nLinCol,nPosIOFA] > 0
	nRet := 65280 // "Verde Claro"
//Else
//	nRet := 65535 // "Amarelo"
	EndIf

Return nRet            
*/

Static Function GravEmpr(nOpcGrv)
	Local lRet  := .F.
	//Local aReg  := {}
	//Local cItem := "00"
	Local lErroGrv := .F.
	Local aErroGrv := {}
	Local nPosParc := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_PARAPAG" } )
	Local nPosSeqP := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_NROPAR" } )
	Local nI
	Local nY
	Local nX
	Local nP
	Local lRetLk := .F.
	Private aCab := {}


	//Gravar tabela SZY
	Begin Transaction
		If INCLUI
			lRetLk := RecLock("SZY",.T.)
		Else
			lRetLk := RecLock("SZY",.F.)
		EndIf
		If lRetLk
			SZY->ZY_FILIAL := xFilial("SZY")
			For nI := 1 to Len(aFields)
				Iif(aFields[nI] <> "NOUSER",SZY->&(aFields[nI]) := M->&(aFields[nI]),)
			Next nI

			SZY->(MsUnlock())
		Else
			lErroGrv := .T.
			aAdd(aErroGrv,{"SZY","Não foi possível alocar o registro para gravação"})
		EndIf
		If !lErroGrv .And. Empty(ALLTRIM(SZY->ZY_ITEM))
			aRetItemc := U_GERITEMC()
			lErroGrv := aRetItemc[1]
		EndIf

		cNumParSE2 := "00"
		//Gravar o SZZ
		If !lErroGrv
			For nX := 1 To Len(OGETDADOS:ACOLS)
				LALTERAR := .F.
				If INCLUI
					lRetLk := RecLock("SZZ",.T.)
				ElseIf ALTERA
					If SZZ->(DbSeek(SZY->ZY_FILIAL + SZY->ZY_CODSEQ + SZY->ZY_REVISAO + OGETDADOS:ACOLS[nX][nPosSeqP] ))
						lRetLk :=  RecLock("SZZ",.F.)
					EndIf
				EndIf
				If lRetLk
					For nY := 1 to Len(aHeader)
						IF ALTERA
							IF SZZ->&(aHeader[nY][2]) <> OGETDADOS:ACOLS[nX][nY]
								SZZ->&(aHeader[nY][2]) := OGETDADOS:ACOLS[nX][nY]
								LALTERAR := .T.
							ENDIF
						ELSE
							SZZ->&(aHeader[nY][2]) := OGETDADOS:ACOLS[nX][nY]
						ENDIF
					Next nY
					If	OGETDADOS:ACOLS[nX][nPosParc] > 0 .And. INCLUI
						cNumParSE2 := Soma1(cNumParSE2,2)
						SZZ->ZZ_NPARSE2 := cNumParSE2
					EndIf
					//Gravar os campos comuns das parcelas e a amarraçao com o SZY
					If INCLUI
						SZZ->ZZ_FILIAL  := SZY->ZY_FILIAL
						SZZ->ZZ_CODSEQ  := M->ZY_CODSEQ
						SZZ->ZZ_REVISAO := M->ZY_REVISAO
						SZZ->ZZ_CODCONT := M->ZY_CODCONT
					ENDIF
					SZZ->(MsUnlock())
					cPrefixo := POSICIONE("SZW",1,xFilial("SZW") + SZY->ZY_MODFIIN,"ZW_TIPOTIT")
					//Altera a Parcela no SE2 apenas os campos passiveis de alteração.
					If SE2->(DbSeek(xFilial("SE2") + cPrefixo + PADR(SZZ->ZZ_CODSEQ + SZZ->ZZ_REVISAO,TAMSX3("E2_NUM")[1]) + SZZ->ZZ_NPARSE2)) .AND. LALTERAR
						If RecLock("SE2",.F.)
							SE2->E2_VENCTO 	:= SZZ->ZZ_DTVENC
							SE2->E2_VENCREA := DataValida(SZZ->ZZ_DTVENC,.T.)
							SE2->E2_SALDO   := IIF(SE2->E2_SALDO > 0,IIF(SE2->E2_SALDO < SE2->E2_VALOR, SZZ->ZZ_PARAPAG - (SE2->E2_VALOR - SE2->E2_SALDO), SZZ->ZZ_PARAPAG),SE2->E2_SALDO)
							SE2->E2_VALOR		:= SZZ->ZZ_PARAPAG
							SE2->E2_VALLIQ		:= SZZ->ZZ_PARAPAG
							SE2->E2_VLCRUZ    := SZZ->ZZ_PARAPAG
							SE2->E2_XJURCTR 	:= SZZ->ZZ_VLRJUR
							SE2->E2_XJURVAR 	:= SZZ->ZZ_VJURVAR
							SE2->(MsUnlock())
						Else
							lErroGrv := .T.
							aAdd(aErroGrv,{"SE2","Não foi possível alocar o registro para gravação"})
						EndIf
					EndIf
				Else
					lErroGrv := .T.
					aAdd(aErroGrv,{"SZZ","Não foi possível alocar o registro para gravação"})
				EndIf
			Next nX
		EndIf
		//Se Der erro desarma a transação
		If lErroGrv
			cTabErro := aErroGrv[1][1]
			cMenErro := ""
			For nP := 1 to Len(aErroGrv)
				cMenErro += aErroGrv[nP][2] + Char(13) + Char(10)
			Next nP
			MsgStop(cMenErro,"Erro Gravação - " + cTabErro)
			Disarmtransaction()
		Else
			lRet := .T.
		EndIf
	End Transaction
	If INCLUI .And. lRet
		ConfirmSX8()
	EndIf

	oBrowse:Refresh()

Return lRet


/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄIH¿
//³FUNÇÃO RESPONSÁVEL POR CALCULAR AS PARCELAS DOS EMPRESTIMOS³
//³BASEADA NO PREENCHIMENTO DO CABEÇALHO.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄIHÙ
ENDDOC*/
Static Function CalcParcel(cCodCtrl,cRevCtrl,cContrat,nOpcax)
Local nQtdParc := M->ZY_QTDPARC 
Local nVlrEmpFi := M->ZY_VRTOTFI
Local nTxJurosP := M->ZY_TXJURMM /100
Local nTxJurVar := iif(M->ZY_TXJRVAR >0,M->ZY_TXJRVAR / 100,0)
Local nVlrPrinP := 0           
Local nVlrJuroP := 0
Local nVlrJurAd := 0
Local nVlrMora	:= 0
Local nVlrSaldo := 0
Local nJuroAPg	:= 0
Local nVlrIOFP 	:= 0
Local nStepPrinc := 0
Local nStepJuros := 0  
Local nQtdDDMes := SuperGetMV("DG_QTDDDMES",.f.,30) //Quandidade de Dias no Mes para o cálculo
Local nFatorDi	:= 0
Local nJr		:= 0
Local nJuroAPg	:= 0

Local cNumParc  := "000"
Local cMesParc  := "00"  
Local aParcEmpr := {}
Local nVr 
Local nI		 := 0
Local nC		 := 0
Local cDDVencPar := STRZERO(M->ZY_DIAVENP,2)
Local dDtVencPar := M->ZY_DTPRPAR

Local lJurNormal := .T.
Private nVlrParcela := 0

Default cContrat := ""  
Default cCodCtrl := ""
Default cRevCtrl := ""
Default nOpcax := 0 


	If nOpcax == 3 .Or. nOpcax == 4 // Se For inclusão ou alteração
	//Se o pagamento do juros será do modo normal, ou de tráz para frente.
	lJurNormal := IIF(Posicione("SZW",1,xFilial("SZW") + M->ZY_MODFIIN,"ZW_TPPGJUR") <> "2",.T.,.F.)
	lTemIOfAD :=  IIF(Posicione("SZW",1,xFilial("SZW") + M->ZY_MODFIIN,"ZW_IOFADIA") <> "2",.T.,.F.)
	//Tempo de Carência inicial do Contrato.
    nDDPriParc := IIF(M->ZY_TCARENC > 0,M->ZY_TCARENC * nQtdDDMes,nQtdDDMes) 
    nTCarencia := M->ZY_TCARENC
    //Se pagará juros durante a carência inicial do Contrato.
    lPgJCarenI := (M->ZY_JURCARI == "S") 
    
    //Taxa IOF AD
    nTXIOFAD := M->ZY_VRIOFAD
    
    //Taxa Mora Dia 
    nMoraDia := M->ZY_MORADIA
    
    //Data do Contrato
    dDtContrat := M->ZY_DTCONTR
     
    //Qtd Dias Juros primeira parcela
    nQtdDiasJur := 0
    
    //Definição da Carencia do Valor Principal do Contrato
		Do Case
		Case M->ZY_CARPRIN == "2" //Mensal
   	 		nStepPrinc := 1
		Case M->ZY_CARPRIN == "3" //Trimestral
   	   		nStepPrinc := 3
		Case M->ZY_CARPRIN == "4" //Semetral
            nStepPrinc := 6
		Case M->ZY_CARPRIN == "5" //Anual
      		nStepPrinc := 12
		Case M->ZY_CARPRIN == "6" //Fim do Contrato
      		nStepPrinc := nQtdParc  
		otherwise
        	nStepPrinc := 1
		EndCase
    
    //Definição da Caréncia do Juros.    
		Do Case
		Case M->ZY_JRCAREN == "2" //Mensal
   	 		nStepJuros := 1
		Case M->ZY_JRCAREN == "3" //Trimestral
   	   		nStepJuros := 3
		Case M->ZY_JRCAREN == "4" //Semetral
            nStepJuros := 6
		Case M->ZY_JRCAREN == "5" //Anual
      		nStepJuros := 12
		Case M->ZY_JRCAREN == "6" //Fim do Contrato
      		nStepJuros := nQtdParc  
		otherwise
        	nStepJuros := 1
		EndCase
            
		IF M->ZY_TBFINAN ==  "1" //SAC
			IF M->ZY_TPJUROS $ '1/2/3' //Juros Pré-Fixado
      		
				If nStepPrinc > 1
      			nVrPrinP := Round((nVlrEmpFi / (nQtdParc - nTCarencia)) * nStepPrinc,4) 
				Else
      			nVrPrinP := Round(nVlrEmpFi / (nQtdParc - nTCarencia),4)  
				EndIf
      		cMesParc := iif(!Empty(M->ZY_DTPRPAR),SUBSTR(DTOS(M->ZY_DTPRPAR),5,2),SUBSTR(DTOS(DDATABASE),5,2))   		
      		
      		nTotJurP 	:= 0
			nTotParP	:= 0
			nTotJrAP 	:= 0
			nTotJrAd	:= 0
			nTotIofP  	:= 0
			nTotParA  	:= 0
            nIncrPar   	:= 0
            nQtdDiasJur := 0
				For nI := 1 to nQtdParc
      		   cNumParc := Soma1(cNumParc,3)      	        	
      	      nIncrPar ++
      	        
      	        //Verifica a Data de Vencimento da Parcela
					If nI == 1
	                
	            	dDtVencPar  := IIF(!Empty(M->ZY_DTPRPAR),M->ZY_DTPRPAR,M->ZY_DTCONTR + nDDPriParc)   
	            	dDtVencPar  := STOD(Substr(DTOS(dDtVencPar),1,6) + Alltrim(cDDVencPar))     	       
	            	dDtvencPar  := DataValida(dDtVencPar)      	
	            	nQtdDiasJur  :=  (dDtVencPar - M->ZY_DTCONTR) - 1//Não considera o primeiro dia CalcDiaUtil(M->ZY_DTCONTR,dDtVencPar) dDtVencPar - M->ZY_DTCONTR  //Qtd dias de juros da parcela para calcular o ADicionar.	            	
					Else
	                dDtVencPar1 	:= dDtVencPar + 30      
						If Month(dDtVencPar1) == 2
	      	          dDtVencUltD := LastDay(dDtVencPar1)		
							If Substr(DTOS(dDtVencUltD),7,2) < cDDVencPar
	      	      	  	dDtVencPar := dDtVencUltD	 
							Else
	      	      	 		dDtVencPar1  := STOD(Substr(DTOS(dDtVencPar1),1,6) + Alltrim(cDDVencPar))     
	            	 		dDtVencPar := dDtVencPar1
							EndIf
						Else
	      	      		dDtVencPar1  := STOD(Substr(DTOS(dDtVencPar1),1,6) + Alltrim(cDDVencPar))     
	            	 	dDtVencPar := dDtVencPar1
						EndIf
	            	dDtvencPar  := DataValida(dDtVencPar) 
	            	nQtdDiasJur  := (dDtVencPar - M->ZY_DTCONTR) - 1 // CalcDiaUtil(M->ZY_DTCONTR,dDtVencPar)//dDtVencPar - M->ZY_DTCONTR  //Qtd dias de juros da parcela para calcular o ADicionar.	            	
					EndIf
					If  nIncrPar > nTCarencia
						If nI == (1 + nTCarencia)   //Tratamento para a primeira parcela do Contrato
	      	      		//Recalcula o Valor Princilal
							If nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc) == 0
	      	      			nVrPrinP := Round((nVlrEmpFi / (nQtdParc - nTCarencia)) * nStepPrinc,4)      	      			      	      		
							ElseIF nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc)  <> 0
	      	      			nVrPrinP := 0      	      		   					
							EndIf
	      	                                                       
	      	           	//Calcula o Juros da Parcela
							If nStepJuros > 1 .And. Mod(nIncrPar,nStepJuros)  == 0
	      	           		nVlrJuroP := Round(nVlrEmpFi * nTxJurosP/30 * nQtdDiasJur ,4)
	      	           		nVlrJurAd := Round((nVlrEmpFi * nTxIofAd / 100) * nQtdDiasJur ,4)
	      	           		nVlrMora  := Round((nVlrEmpFi * nMoradia / 100) * nQtdDiasJur,4)
	      	           		
								If !lJurNormal
	      	           			nJuroAPg  := Round( (((nVlrEmpFi / (nQtdPARC - nTCarencia)) * nIncrPar)*nStepJuros) * nTxJurosP,4)       	     	          	           
								Else
	      	           			nJuroAPg := nVlrJuroP
								EndIf
							Else
	     						nVlrJuroP := Round(nVlrEmpFi * nTxJurosP/30 * nQtdDiasJur,4) 
	     						nVlrJurAd := Round((nVlrEmpFi * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	    			nVlrMora  := Round((nVlrEmpFi * nMoradia / 100) * nQtdDiasJur,4)  
	      	           			
	     						nJuroApg	:= 0
							EndIf
	      				  	            
	      	            //Valor do IOF da Parcela quando for financiado      
	      	           	nVlrIOFP	:= 0                 
	      	           	
	      	           	//Valor do Sald do Contrato
	      	           	nVlrSaldo := nVlrEmpFi - nVrPrinP     	           	
	      	           	
	      	           	//Valor do Juros Variável
	      	           	nVlrJurVar := nVlrJurAd +  nVlrMora
	      	           	
	      	           	//Valor Da Parcela
							If  nStepJuros > 1
	      	           		nVlrParcela := nVrPrinP + nJuroAPG + nVlrIOFP  + nVlrJurVar
							Else
	      	            	nVlrParcela := nVrPrinP + nVlrJuroP + nVlrIOFP + nVlrJurVar
							EndIf
	      	            
	      	            
	      	           AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),nJuroApg,Round(nVlrJurVar,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),nQtdDiasJur,.F.})      	        
						ElseIf nI ==  (nQtdParc - 1) //Trata a penultima parcela que terá todo o saldo da devedor
	      	       
	      	       		//Recalcula o Valor Princilal
							If nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc) == 0
	      	      			nVrPrinP := Round((nVlrEmpFi / (nQtdParc - nTCarencia)) * nStepPrinc,4)      	      			      	      		
							ElseIf nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc)  <> 0
	      	      			nVrPrinP := 0      	      		   					
							EndIf
	      	                                                       
	      	           	//Calcula o Juros da Parcela
							If nStepJuros > 1 .And. Mod(nIncrPar,nStepJuros)  == 0
	      	           		nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)	      	        
	      	           		nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	           		nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)
	      	           		
								If !lJurNormal
	      	           			nJuroAPg  := Round( (((nVlrEmpFi / (nQtdPARC - nTCarencia)) * nIncrPar)*nStepJuros) * nTxJurosP,4)       	     	          	           
								Else
	      	           			nJuroAPg := nVlrJuroP
									For nJr:=1 To (nStepJuros - 1)
	      	           				nJuroAPg += aParcEmpr[nI - nJr][4] //nVlrJuroP
									Next nJr
								EndIf
							Else
	     						nVlrJuroP := Round(aParcEmpr[nI - 1][7] * nTxJurosP,4) 	     					
	      	           	nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	           	nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)	      	           		
	     						nJuroApg	:= 0	      	        
							EndIf
	      				  	            
	      	            //Valor do IOF da Parcela quando for financiado      
	      	           	nVlrIOFP	:= 0                 
	      	           	
	      	           	//Valor do Sald do Contrato
	      	           	nVlrSaldo 	:= nVlrEmpFi - (nTotParP + nVrPrinP)
		      	        
	      	        	//Valor do Juros Variável
	      	           	nVlrJurVar := nVlrJurAd +  nVlrMora
	      	           	
	      	           	//Valor Da Parcela
							If  nStepJuros > 1
	      	           		nVlrParcela := nVrPrinP + nJuroAPG + nVlrIOFP  + nVlrJurVar
							Else
	      	            	nVlrParcela := nVrPrinP + nVlrJuroP + nVlrIOFP + nVlrJurVar
							EndIf
	      	            
	      	            
	      	           AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),nJuroApg,Round(nVlrJurVar,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),nQtdDiasJur,.F.})      	        
	      	    
						ElseIf nI == nQtdParc //Trata Ultima Parcela
	      	        	 					
	 					//Recalcula o Valor Princilal
							If nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc) == 0
	      	      			nVrPrinP := Round((nVlrEmpFi / (nQtdParc - nTCarencia)) * nStepPrinc,4)      	      			      	      		
							ElseIf nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc)  <> 0
	      	      			nVrPrinP := 0      	      		   					
							EndIf
	      	                                                       
	      	           	//Calcula o Juros da Parcela
							If nStepJuros > 1 .And. Mod(nIncrPar,nStepJuros)  == 0
	      	           		nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)	      	        
	      	           		nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	           		nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)
	      	           		
								If !lJurNormal
	      	           			nJuroAPg  := Round( (((nVlrEmpFi / (nQtdPARC-nTCarencia)) * nIncrPar)*nStepJuros) * nTxJurosP,4)       	     	          	           
								Else
	      	           			nJuroAPg := nVlrJuroP
									For nJr:=1 To (nStepJuros - 1)
	      	           				nJuroAPg += aParcEmpr[nI - nJr][4] //nVlrJuroP
									Next nJr
								EndIf
							Else
	     						nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)  
	     						nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	           	nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)
	      	           		
	     						nJuroApg	:= 0	      	        
							EndIf
	      				  	            
	      	            //Valor do IOF da Parcela quando for financiado      
	      	           	nVlrIOFP	:= 0                 
	      	           	
	      	           	//Valor do Saldo do Contrato
	      	           	nVlrSaldo 	:= 0
	      	           	       	//Valor do Juros Variável
	      	           	nVlrJurVar := nVlrJurAd +  nVlrMora
	      	           	
	      	           	//Valor Da Parcela
							If  nStepJuros > 1
	      	           		nVlrParcela := nVrPrinP + nJuroAPG + nVlrIOFP  + nVlrJurVar
							Else
	      	            	nVlrParcela := nVrPrinP + nVlrJuroP + nVlrIOFP + nVlrJurVar
							EndIf
	      	            
	      	            
	      	           AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),nJuroApg,Round(nVlrJurVar,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),nQtdDiasJur,.F.})      	        
	      	    
						Else //Tratamento para as demais parcelas do Contrato.
	      	         	      
	   	  					//Recalcula o Valor Princilal
							If nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc) == 0
	      	      			nVrPrinP := Round((nVlrEmpFi / (nQtdParc - nTCarencia)) * nStepPrinc,4)      	      			      	      		
							ElseIf nStepPrinc > 1 .And. Mod(nIncrPar,nStepPrinc)  <> 0
	      	      			nVrPrinP := 0      	      		   					
							EndIf
	      	                                                       
	      	           	//Calcula o Juros da Parcela
							If nStepJuros > 1 .And. Mod(nIncrPar,nStepJuros)  == 0
	      	           		nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)	      	        	      	           		
	      	           		nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur  ,4)
	      	           		nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)
	      	           		
								If !lJurNormal
	      	           			nJuroAPg  := Round( (((nVlrEmpFi / (nQtdPARC - nTCarencia)) * nIncrPar)*nStepJuros) * nTxJurosP,4)       	     	          	           
								Else
	      	           			nJuroAPg := nVlrJuroP
									For nJr:=1 To (nStepJuros - 1)
	      	           				nJuroAPg += aParcEmpr[nI - nJr][4] //nVlrJuroP
									Next nJr
								EndIf
							Else
	     					nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)	      	     					
	      	           		nVlrJurAd := Round((aParcEmpr[nI - 1][7] * nTxIofAd / 100) * nQtdDiasJur ,4)
	      	           		nVlrMora  := Round((aParcEmpr[nI - 1][7] * nMoradia / 100) * nQtdDiasJur,4)
	      	           			        
	      					nJuroApg	:= 0
							EndIf
	      				  	            
	      	            //Valor do IOF da Parcela quando for financiado      
	      	           	nVlrIOFP	:= 0                 
	      	           	
	      	           	//Valor do Saldo do Contrato
	      	           	nVlrSaldo := aParcEmpr[nI - 1][7] - nVrPrinP
		      	        	      	        
	      	           	       	//Valor do Juros Variável
	      	           	nVlrJurVar := nVlrJurAd +  nVlrMora
	      	           	
	      	           	//Valor Da Parcela
							If  nStepJuros > 1
	      	           		nVlrParcela := nVrPrinP + nJuroAPG + nVlrIOFP  + nVlrJurVar
							Else
	      	            	nVlrParcela := nVrPrinP + nVlrJuroP + nVlrIOFP + nVlrJurVar
							EndIf
	      	            
	      	            
	      	           AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),nJuroApg,Round(nVlrJurVar,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),nQtdDiasJur,.F.})      	        
	      	    
						EndIf
      	        
      	        	nTotJurP += nVlrJuroP
      	        	nTotJrAP += nJuroAPg
      	        	nTotJrAd += 	nVlrJurAd  +	nVlrMora	      	           		
      	        	nTotParP += nVrPrinP   
      	        	nTotIofP += nVlrIOFP
      	        	nTotParA += nVlrParcela
					Else
      	      		AaDd(aParcEmpr,{cNumParc,dDtVencPar,0,0,0,0,0,0,0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),0,.F.})
					EndIf
      	        
				Next nI
      		             
      		        
      		/*****Ajuste dos Arredondanmentos na apresentação dos totais*********/
            nCTotJurP := 0
      	 	nCTotJrAp := 0
      	 	nCTotParP := 0
      	    
      	    nCTotIofP := 0 
      	    nCTotParA := 0
				For nC:=1 to Len(aParcEmpr)
      		  	nCTotParP += aParcEmpr[nC][3]   
      	    	nCTotJurP += aParcEmpr[nC][4]
      	    	nCTotJrAp += aParcEmpr[nC][5]
      	    	nCTotIofP += aParcEmpr[nC][6]
      	    	nCTotParA += aParcEmpr[nC][8]
				Next nC
            
				IF (nCTotJurP -  INT(nCTotJurP)) == 0.99
              	nCTotJurP := nCTotJurP + 0.01
				ElseIF (nCTotJurP -  INT(nCTotJurP)) == 0.01
            	nCTotJurP := nCTotJurP - 0.01
				EndIF
      		
				IF (nCTotIofP -  INT(nCTotIofP)) == 0.99
              	nCTotIofP := nCTotIofP + 0.01
				ElseIF (nCTotIofP -  INT(nCTotIofP)) == 0.01
            	nCTotIofP := nCTotIofP - 0.01
				EndIF
      		
				IF (nCTotParA -  INT(nCTotParA)) == 0.99
              	nCTotParA := nCTotParA + 0.01
				ElseIF (nCTotParA -  INT(nCTotParA)) == 0.01
            	nCTotParA := nCTotParA - 0.01
				EndIF
             nTotJurP := nCTotJurP
             nTotJrAp := nCTotJrAp
      	     nTotIofP := nCTotIofP
      	     nTotParA := nCTotParA     	
			EndIf
		Else
            //PRICE
			IF M->ZY_TPJUROS $ '1/2/3' //Juros Pré-Fixado
      		nTotJurP 	:= 0
			nTotParP	:= 0
			nTotJrAP 	:= 0
			nTotIofP  	:= 0
			nTotParA  	:= 0
			nIncrPar   	:= 0
			//Calcula o Valor Da parcela, que será fixa
			nVlrParcela :=  Round((nTxJurosP * ( nVlrEmpFi*( (nTxJurosP + 1)^(nQtdParc-nTCarencia)))) /  (((nTxJurosP + 1) ^ (nQtdParc-nTCarencia))-1),4)			
      		    	
				For nI := 1 to nQtdParc
      			cNumParc := Soma1(cNumParc,3)      	        	
      	      nIncrPar ++  
      	        //Verifica a Data de Vencimento da Parcela
					If nI == 1
	            	dDtVencPar := IIF(!Empty(M->ZY_DTPRPAR),M->ZY_DTPRPAR,M->ZY_DTCONTR + nDDPriParc)	            
	            	dDtVencPar  := STOD(Substr(DTOS(dDtVencPar),1,6) + Alltrim(cDDVencPar))     	            	
	            	dDtvencPar  := DataValida(dDtVencPar) 
					Else
	            	dDtVencPar1 	:= dDtVencPar + 30	      	      	        
						If Month(dDtVencPar1) == 2
	      	          dDtVencUltD := LastDay(dDtVencPar1)		
							If Substr(DTOS(dDtVencUltD),7,2) < cDDVencPar
	      	      	  	dDtVencPar := dDtVencUltD	 
							Else
	      	      	 	dDtVencPar1  := STOD(Substr(DTOS(dDtVencPar1),1,6) + Alltrim(cDDVencPar))     
	            	 		dDtVencPar := dDtVencPar1
							EndIf
						Else
	      	      	dDtVencPar1  := STOD(Substr(DTOS(dDtVencPar1),1,6) + Alltrim(cDDVencPar))     
	            	 	dDtVencPar := dDtVencPar1
						EndIf
	            	dDtvencPar  := DataValida(dDtVencPar) 
					EndIf
	            nQtdDiasJur  :=  dDtVencPar - M->ZY_DTCONTR  //Qtd dias de juros da parcela para calcular o ADicionar.	            	
					If  nIncrPar > nTCarencia
						If nI == (1 + nTCarencia) //Tratamento para a primeira parcela do Contrato
	      	      	nVlrJuroP := Round(nVlrEmpFi * nTxJurosP,4)                 
	      				nVrPrinP := Round(nVlrParcela - nVlrJuroP,4)       		
	      				nVlrSaldo := nVlrEmpFi - nVrPrinP      							
	      				nVlrIOFP	:= 0       		
	      				AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),Round(nJuroApg,2),Round(nVlrIOFP,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),.F.})
	      	        
						ElseIf nI ==  (nQtdParc - 1) //Trata a penultima parcela que terá todo o saldo da devedor
	      	        	
	      	        	nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)
		      	      	nVrPrinP := Round(nVlrParcela - nVlrJuroP,4)     			
		      	        nVlrSaldo 	:= nVlrEmpFi - (nTotParP + nVrPrinP)
		      	        nVlrIOFP	:= 0 
	      				AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),Round(nJuroApg,2),Round(nVlrIOFP,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),.F.})      	        
	      	        
						ElseIf nI == nQtdParc //Trata Ultima Parcela
	      	        	
	      	        	nVlrJuroP 	:= Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)
		      	       	nVrPrinP := Round(nVlrParcela - nVlrJuroP,4)      	      
		      	        nVlrSaldo	:= 0 
		      	        nVlrIOFP	:= 0 
	      				AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),Round(nJuroApg,2),Round(nVlrIOFP,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),.F.})
	      	       	
						Else //Tratamento para as demais parcelas do Contrato.
	      	        
	      	         	nVlrJuroP := Round(aParcEmpr[nI - 1][7] * nTxJurosP,4)
		      	       	nVrPrinP := Round(nVlrParcela - nVlrJuroP,4)       	      
		      	        nVlrSaldo := aParcEmpr[nI - 1][7] - nVrPrinP
		      	        nVlrIOFP	:= 0 
	      				AaDd(aParcEmpr,{cNumParc,dDtVencPar,Round(nVrPrinP,2),Round(nVlrJuroP,2),Round(nJuroApg,2),Round(nVlrIOFP,2),Round(nVlrSaldo,2),Round(nVlrParcela,2),0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),.F.})
	      	        
						EndIf
	      	        
	      	        nTotJurP += nVlrJuroP
	      	        nTotJrAP += nJuroAPg
	      	        nTotParP += nVrPrinP   
	      	        nTotIofP += nVlrIOFP
	      	        nTotParA += nVlrParcela
					Else
      				AaDd(aParcEmpr,{cNumParc,dDtVencPar,0,0,0,0,0,0,0,CTOD("  /  /  "),0,CTOD("  /  /  "),CTOD("  /  /  "),CTOD("  /  /  "),CTOD("  /  /  "),.F.})
					EndIf
				Next nI
			EndIf
		EndIf
	ElseIf nOpcax <> 0
	/*A OPÇÃO DE CALCULAR PARCELAS SÓ ESTARÁ ATIVA NA INCLUSÃO DO CONTRATO,CASO SEJA OUTRA OPÇÃO IRÁ APAGAR AS PARCELAS GERADAS
	POIS TRATASE DE ALGUMA AÇÃO DE ALTERAÇÃO NO CABEÇALHO EM CAMPOS CHAVES
	*/
	EndIf

	oGetDados:aCols := aParcEmpr
	oGetDados:AALTER := aAltAcols
	oGetDados:NMAX   := nQtdParc
	oGetDados:Refresh()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADGFIN01  ºAutor  ³Jackson Santos      º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Validação do ACols                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VLDLACOLS()
	Local lRetVld := .T.
	Local nPosVencto := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_DTVENC" } )
	Local nPosVlrPar := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_PARAPAG" } )
	Local nPosVlrPri := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VLRPRIN" } )
	Local nPosVlrJur := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VLRJUR" } )
	Local nPosVlrJVa := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VJURVAR" } )
	Local nPosIOFAPG := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_IOFAPAG" } )
	Local nPosVlrIOF := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VLRIOF" } )
	Local nPosDtPgPar := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_DTPGPAR" } )
	Local nPosVrPgPar := aScan( aHeader, {|x| Alltrim(x[2]) == "ZZ_VRPGPAR" } )

	IF ALTERA

	ELSE

	ENDIF
Return lRetVld



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ADGFIN01  ºAutor  ³Jackson Santos      º Data ³  19/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Validação digitação do campo digitado                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AVLDDGCP(cVarDigit,nTipo)
	Local lRetVld := .T.
	Local cPriceSac  := M->ZY_TBFINAN
	Local lJurVariav := (M->ZY_TPJUROS $ "2/3")

	Local lJrInver 	 := IIF(Posicione("SZW",1,xFilial("SZW") + M->ZY_MODFIIN,"ZW_TPPGJUR") == "2",.T.,.F.)  //Pg Juros Invertido
	Local cCposAlter := IIf(lJrInver,"M->ZZ_VJURVAR/M->ZZ_VLRPRIN/M->ZZ_VJURAPG","M->ZZ_VJURVAR/M->ZZ_VLRPRIN/M->ZZ_VLRJUR/M->ZZ_VJURAPG")
	Local aCposAlter := IIF(lJrInver,{"ZZ_VJURVAR","ZZ_VLRPRIN","ZZ_VJURAPG"},{"ZZ_VJURVAR","ZZ_VLRPRIN","ZZ_VLRJUR","ZZ_VJURAPG"})
	Local nPZZ_VRPGPAR := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_VRPGPAR"})
	Local nPZZ_DTPGPAR := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_DTPGPAR"})
	Local nI := 0

	Private nPZZ_VLRPRIN := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_VLRPRIN"})
	Private nPZZ_VLRJUR  := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_VLRJUR"})
	Private nPZZ_VJURAPG := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_VJURAPG"})
	Private nPZZ_VJURVAR := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_VJURVAR"})
	Private nPZZ_PARAPAG := Ascan(oGetDados:aHeader,{|x| Alltrim(x[2]) == "ZZ_PARAPAG"})

	Default cVarDigit := ""    //Variável Digitada


//Se For Juros variável
	IF  cVarDigit $ cCposAlter
		IF !oGetDados:aCols[oGetDados:nAt][Len(oGetDados:aCols[oGetDados:nAt])] .And. oGetDados:aCols[oGetDados:nAt][nPZZ_VRPGPAR] == 0
			IF lJurVariav .And. !lJrInver
				IF !oGetDados:aCols[oGetDados:nAt][Len(oGetDados:aCols[oGetDados:nAt])]
					oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] := 0
					For nI := 1 to Len(aCposAlter)
						If aCposAlter[nI] <> Substr(Alltrim(cVarDigit),4)
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] +=   oGetDados:aCols[oGetDados:nAt][&("nP" + aCposAlter[nI])]
						Else
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] += &(cVarDigit)
						EndIf
					Next nI
				EndIf
			ElseIf lJurVariav .And. lJrInver
				IF !oGetDados:aCols[oGetDados:nAt][Len(oGetDados:aCols[oGetDados:nAt])] .And. oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] > 0
					oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] := 0
					For nI := 1 to Len(aCposAlter)
						If aCposAlter[nI] <> Substr(Alltrim(cVarDigit),4)
							cVerAtu :=("nP" + aCposAlter[nI])
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] +=   oGetDados:aCols[oGetDados:nAt][&("nP" + aCposAlter[nI])]
						Else
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] += &(cVarDigit)
						EndIf
					Next nI
				EndIf
			Else
				IF !oGetDados:aCols[oGetDados:nAt][Len(oGetDados:aCols[oGetDados:nAt])]
					oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] := 0
					For nI := 1 to Len(aCposAlter)
						If aCposAlter[nI] <> Substr(Alltrim(cVarDigit),4)
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] +=   oGetDados:aCols[oGetDados:nAt][&("nP" + aCposAlter[nI])]
						Else
							oGetDados:aCols[oGetDados:nAt][nPZZ_PARAPAG] += &(cVarDigit)
						EndIf
					Next nI
				EndIf
			EndIF
		Else

			&(cVarDigit) := oGetDados:aCols[oGetDados:nAt][&("nP" + Substr(Alltrim(cVarDigit),4))]
			MsgStop("Não é possível fazer alteração em parcelas baixadas.","Erro Alteração Parcelas")
		EndIf
	EndIf
//Recalcula valores totais
	nTotJurP := 0
	nTotParP := 0
	nTotJrAP := 0
	nTotParA := 0
	aEval(oGetDados:aCols, {|x| nTotJurP  += x[nPZZ_VLRJUR]})
	aEval(oGetDados:aCols, {|x| nTotParP  += x[nPZZ_VLRPRIN]})
	aEval(oGetDados:aCols, {|x| nTotJrAP  += x[nPZZ_VJURAPG]})
	aEval(oGetDados:aCols, {|x| nTotParA  += x[nPZZ_PARAPAG]})
	oGetDados:Refresh()

	FreeObj(oTGet1)
	FreeObj(oTGet2)
	FreeObj(oTGet3)
	FreeObj(oTGet4)
	FreeObj(oTGet5)

	oTGet1 := TGet():New(01,110, {|u| If( PCount() > 0,ROUND(nTotParP,2),ROUND(nTotParP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParP")
	oTGet2 := TGet():New(01,180, {|u| If( PCount() > 0,ROUND(nTotJurP,2),ROUND(nTotJurP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet3 := TGet():New(01,250, {|u| If( PCount() > 0,ROUND(nTotJrAP,2),ROUND(nTotJrAP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotJurP")
	oTGet4 := TGet():New(01,320, {|u| If( PCount() > 0,ROUND(nTotIofP,2),ROUND(nTotIofP,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotIofP")
	oTGet5 := TGet():New(01,460, {|u| If( PCount() > 0,ROUND(nTotParA,2),ROUND(nTotParA,2))}, oWin7,060,007,"@E 999,999,999.99",,,,,,,.T.,,,{||.F.},,,,,,,"TotParA")

	_odlg:Refresh()

Return lRetVld


Static Function ResumoCtr(cCodContr,cCodRev)
	Local lRet := .F.
	Local oDlgRes
	Local cTitulo := "Resumo do Contrato"
	Private oFont   		:= TFont():New("Courier New",,-12,.T.)
	Private oFont1  		:= TFont():New("Courier New",,-14,.T.)
	Private oFont3  		:= TFont():New("Arial"      ,,-16,.T.)

	Default cCodContr := ""
	Default cCodRev   := ""

	cDescContr 	:= SZY->ZY_DESCEMP
	nQtdParcTot := SZY->ZY_QTDPARC
	nVlrContrat := SZY->ZY_VLRCONT
	nQtdParcEAb := 0
	nVlrSldPrin := 0
	nVlrSldJuro := 0
	nVlrSldIOF	:= 0
	nVlrSldIOF2 := 0
	nVLrSldJVar := 0
	nVlrSldTot	:= 0

	cQrySld := " SELECT COUNT(*) QTDPAR,SUM(ZZ_VLRPRIN) PRINCIPAL , SUM(ZZ_VLRJUR) JUROS , "
	cQrySld += ENTER + " SUM(ZZ_VLRPRIN + ZZ_VLRJUR) TOTSLDCONT, "
	cQrySld += ENTER + " SUM(ZZ_VLRIOF) VLRIOF, SUM(ZZ_IOFAPAG) IOFAPG "
	cQrySld += ENTER + " FROM " + RetSqlName("SZZ") + " SZZ WHERE SZZ.D_E_L_E_T_ = '' AND SZZ.ZZ_FILIAL = '" + xFilial("SZZ") + "' AND SZZ.ZZ_DTPGPAR = '' "
	cQrySld += ENTER + " AND SZZ.ZZ_CODSEQ = '" + cCodContr + "' AND SZZ.ZZ_REVISAO = '" + cCodRev + "' "

	IF Select("TSALD") > 0
		TSALD->(DBCloseArea("TSALD"))
	EndIf
	TCQUERY cQrySld NEW ALIAS "TSALD"


	While TSALD->(!EOF())
		nQtdParcEAb := TSALD->QTDPAR
		nVlrSldPrin := TSALD->PRINCIPAL
		nVlrSldJuro := TSALD->JUROS
		nVlrSldIOF	:= TSALD->VLRIOF
		nVlrSldIOF2 := TSALD->IOFAPG
		nVLrSldJVar := 0
		nVlrSldTot  := TSALD->TOTSLDCONT
		TSALD->(DbSkip())
	EndDo
	IF Select("TSALD") > 0
		TSALD->(DBCloseArea("TSALD"))
	EndIf
	DEFINE MSDIALOG oDlgRes TITLE cTitulo  FROM 0,0 TO 500,800 OF oMainWnd PIXEL
	@ 010, 010 To 250,400 Label "Resumo do Contrato" Of oDlgRes Pixel

	// Fornecedor
	@ 030, 020 Say "Codigo/Revisao/Descrição: " Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cContrDesc := cCodContr + " - " + cCodRev + " - " + cDescContr
	@ 040, 020 MsGet  cContrDesc	Picture "@!"  SIZE 220,10 When .F. Of oDlgRes Pixel

	@ 060, 020 Say "Qtd.Parcelas Orig.:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cQtdParcTot := TRANSFORM(nQtdParcTot,"@E 999,999,999.99")
	@ 070, 020 MsGet cQtdParcTot 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel


	@ 060, 0130 Say "Vlr.Total Original:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cVlrContrat := TRANSFORM(nVlrContrat,"@E 999,999,999.99")
	@ 070, 0130 MsGet cVlrContrat 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel

	@ 090, 020 Say "Vlr.Saldo Principal:"  Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cVlrPrincipal := TRANSFORM(nVlrSldPrin,"@E 999,999,999.99")
	@ 100, 020 MsGet cVlrPrincipal 	  /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel

	// Data de Solicitacao
	@ 090, 130 Say "Vlr.Saldo do Juros:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cVlrSldJuro := TRANSFORM(nVlrSldJuro,"@E 999,999,999.99")

	@ 100, 130 MsGet cVlrSldJuro	/*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel


	@ 090, 240 Say "Vlr.Saldo IOF" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cVlrSldIOF := TRANSFORM(nVlrSldIOF,"@E 999,999,999.99")
	@ 100, 240 MsGet cVlrSldIOF /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel

	// Justificativa da Rejeicao
	@ 120, 020 Say "Vlr.Saldo Total:" Size 160,10 FONT oFont1 COLOR CLR_BLUE Of oDlgRes Pixel
	cVlrSldTot := TRANSFORM(nVlrSldTot,"@E 999,999,999.99")
	@ 135, 020 Get cVlrSldTot /*Picture "@!"*/ SIZE 100,10 When .F. Of oDlgRes Pixel

	//DEFINE SBUTTON oSButton4 TITLE "Sair" FROM 230, 160 TYPE 2 OF oDlgRes ENABLE ACTION (oDlgRes:End() )


	ACTIVATE MSDIALOG oDlgRes CENTERED

Return


Static  Function QUITCONTR(cContrat,cRevisa,cNroPar,cCodBco,cCodAgen,cCodConta,aErros)

	Local nI := 0

	Private lMsErroAuto := .F.
	PRIVATE lAutoErrNoFile  := .T.
	Private cError 	  := ""
	Default cContrat := ""
	Default cRevisa := ""
	Default cNroPar := ""
	Default cCodBco := ""
	Default cCodAgen := ""
	Default cCodConta := ""
	Default aErros := {}

	cQuery := " SELECT "
	cQuery += ENTER + "	E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,SE2.R_E_C_N_O_ RECNOS  "
	cQuery += ENTER + "	FROM " + RetSqlName("SE2") + " SE2 "
	cQuery += ENTER + "	JOIN " + RetSqlName("SZY") + " SZY ON SZY.D_E_L_E_T_ <> '*' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' AND SZY.ZY_CODSEQ = '" + cContrat +  "' "
	cQuery += ENTER + "	JOIN " + RetSqlName("SZW") + " SZW ON SZW.D_E_L_E_T_ <> '*' AND SZW.ZW_FILIAL = '" + xFilial("SZW") + "' AND SZW.ZW_CODIGO = SZY.ZY_MODFIIN "
	cQuery += ENTER + "	WHERE SE2.D_E_L_E_T_ <> '*' AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
	cQuery += ENTER + "	AND E2_SALDO = E2_VALOR "
	cQuery += ENTER + "	AND E2_BAIXA = '' "
	cQuery += ENTER + "	AND E2_NUM = '" + cContrat +  cRevisa + "' "
	cQuery += ENTER + " 	AND E2_PARCELA = '" + cNroPar + "' "
	If Select("TSE2S") > 0
		TSE2S->(DbCloseArea())
	EndIF
	TCQUERY cQuery NEW ALIAS "TSE2S"

	dbSelectArea("SE2")
	SE2->(dbSetOrder(1))
	SE2->(dbGoTop())
	If SE2->(dbSeek(xFilial("SE2") + TSE2S->E2_PREFIXO+TSE2S->E2_NUM+TSE2S->E2_PARCELA+TSE2S->E2_TIPO+TSE2S->E2_FORNECE+TSE2S->E2_LOJA))
		If SE2->E2_SALDO > 0
			cHistBaixa := "Quitação do Econtrato"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Monta array com os dados da baixa a pagar do título³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aBaixa := {}
			AADD(aBaixa, {"E2_FILIAL" , SE2->E2_FILIAL , Nil})
			AADD(aBaixa, {"E2_PREFIXO" , SE2->E2_PREFIXO , Nil})
			AADD(aBaixa, {"E2_NUM" , SE2->E2_NUM , Nil})
			AADD(aBaixa, {"E2_PARCELA" , SE2->E2_PARCELA , Nil})
			AADD(aBaixa, {"E2_TIPO" , SE2->E2_TIPO , Nil})
			AADD(aBaixa, {"E2_FORNECE" , SE2->E2_FORNECE , Nil})
			AADD(aBaixa, {"E2_LOJA" , SE2->E2_LOJA , Nil})
			AADD(aBaixa, {"AUTMOTBX" , "QTC" , Nil})
			AADD(aBaixa, {"AUTDTBAIXA" , dDataBase , Nil})
			AADD(aBaixa, {"AUTDTCREDITO", dDataBase , Nil})
			AADD(aBaixa, {"AUTHIST" , cHistBaixa , Nil})
			AADD(aBaixa, {"AUTVLRPG" , SE2->E2_SALDO , Nil})
			ACESSAPERG("FIN080", .F.)
			MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)
			If lMsErroAuto
				aErro := GetAutoGRLog()
				For nI := 1 To Len(aErro)
					cError += aErro[nI]+Chr(13)+Chr(10)
				Next nI
				AaDd(aErros,{xFilial("SE2") + TSE2S->E2_PREFIXO+TSE2S->E2_NUM+TSE2S->E2_PARCELA+TSE2S->E2_TIPO+TSE2S->E2_FORNECE+TSE2S->E2_LOJA,;
					"Erro ExecAtuto",cError})
			EndIf
			cE2_NUM     := SE2->E2_NUM //Space(09)
			cE2_TIPO  	:= SE2->E2_TIPO		   //Space(03)
			cE2_NATUREZ := SE2->E2_NATUREZ	 //Space(10)
			cE2_FORNECE := SE2->E2_FORNECE //Space(06)
			cE2_LOJA		:= SE2->E2_LOJA 		//Space(02)

		Else
			cError := 	"O título não possui saldo a pagar em aberto"
			AaDd(aErros,{xFilial("SE2") + TSE2S->E2_PREFIXO+TSE2S->E2_NUM+TSE2S->E2_PARCELA+TSE2S->E2_TIPO+TSE2S->E2_FORNECE+TSE2S->E2_LOJA,;
				"Erro Saldo",cError})
		EndIf

	Else
		cError := "O título a pagar não foi localizado"
		AaDd(aErros,{xFilial("SE2") + TSE2S->E2_PREFIXO+TSE2S->E2_NUM+TSE2S->E2_PARCELA+TSE2S->E2_TIPO+TSE2S->E2_FORNECE+TSE2S->E2_LOJA, ;
			"Erro Pesquisa",cError})
	EndIf

	If Select("TSE2S") > 0
		TSE2S->(DbCloseArea())
	EndIF

Return aErros

Static Function QTCGERPUN(cContrat,cRevisa,cNroPar,cCodBco,cCodAgen,cCodConta)
	Local aErros := {}
	Local cError 	  := ""
	Local aParcelas := {}
	Local nI := 0

	Private lMsErroAuto := .F.
	PRIVATE lAutoErrNoFile  := .T.
	Default cContrat := ""
	Default cRevisa := ""
	Default cNroPar := ""
	Default cCodBco := ""
	Default cCodAgen := ""
	Default cCodConta := ""
	cE2_PREFIXO := "QTC"
	cE2_PARCELA := ""
	dE2_EMISSAO := CTOD(cDtQuitacao)
	dE2_VENCTO  := CTOD(cDtQuitacao)
	dE2_VENCREA := CTOD(cDtQuitacao)
	cE2_PORTADO := cCodBco
	nE2_VALOR	:= nVlrQuitacao
	cE2_HISTOR	:= IIF(!Empty(cContQuit),"Recompra-Contr.:" + cContQuit,"Quitação Antecipada" )
	aParcelas := {{ "E2_PREFIXO"   , cE2_PREFIXO   , NIL },;
		{ "E2_NUM"      , cE2_NUM     	, NIL },;
		{ "E2_TIPO"     , cE2_TIPO    	, NIL },;
		{ "E2_PARCELA"	 , cE2_PARCELA	, NIL },;
		{ "E2_NATUREZ"  , cE2_NATUREZ   , NIL },;
		{ "E2_FORNECE"  , cE2_FORNECE   , NIL },;
		{ "E2_LOJA"		 , cE2_LOJA		, NIL },;
		{ "E2_EMISSAO"  , dE2_EMISSAO	, NIL },;
		{ "E2_VENCTO"   , dE2_VENCTO	, NIL },;
		{ "E2_VENCREA"  , dE2_VENCREA	, NIL },;
		{ "E2_ORIGEM"   , "ADGFIN02"	, NIL },;
		{ "E2_PORTADO"  , cE2_PORTADO	, NIL },;
		{ "E2_VALOR"    , nE2_VALOR     , NIL }}
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aParcelas,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	If lMsErroAuto
		aErro := GetAutoGRLog()
		For nI := 1 To Len(aErro)
			cError += aErro[nI]+Chr(13)+Chr(10)
		Next nI
		AaDd(aErros,{xFilial("SE2") + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,;
			"Erro ExecAtuto FINA050",cError})
	Else
		//Salva o título
		//SE2->(DbCommit())

		//Baixa a Parcela Gerada
		If SE2->(DbSeek(xFilial("SE2") + cE2_PREFIXO + cE2_NUM + cE2_PARCELA + cE2_TIPO + cE2_FORNECE + cE2_LOJA ))
			cHistBaixa := "Quitação do Econtrato"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Monta array com os dados da baixa a pagar do título³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aBaixa := {}
			AADD(aBaixa, {"E2_FILIAL" 	, SE2->E2_FILIAL , Nil})
			AADD(aBaixa, {"E2_PREFIXO" , SE2->E2_PREFIXO , Nil})
			AADD(aBaixa, {"E2_NUM" 		, SE2->E2_NUM , Nil})
			AADD(aBaixa, {"E2_PARCELA" , SE2->E2_PARCELA , Nil})
			AADD(aBaixa, {"E2_TIPO" 	, SE2->E2_TIPO , Nil})
			AADD(aBaixa, {"E2_FORNECE" , SE2->E2_FORNECE , Nil})
			AADD(aBaixa, {"E2_LOJA" 	, SE2->E2_LOJA , Nil})
			AADD(aBaixa, {"AUTMOTBX" 	, "NOR" , Nil})
			AADD(aBaixa, {"AUTBANCO" 	, cCodBco , Nil})
			AADD(aBaixa, {"AUTAGENCIA" , cCodAgen , Nil})
			AADD(aBaixa, {"AUTCONTA" 	, cCodConta , Nil})
			AADD(aBaixa, {"AUTDTBAIXA" , dE2_EMISSAO , Nil})
			AADD(aBaixa, {"AUTDTCREDITO",dE2_EMISSAO , Nil})
			AADD(aBaixa, {"AUTHIST" 	, cHistBaixa , Nil})
			AADD(aBaixa, {"AUTVLRPG" 	, SE2->E2_SALDO , Nil})
			ACESSAPERG("FIN080", .F.)
			MSEXECAUTO({|x,y| FINA080(x,y)}, aBaixa, 3)
			If lMsErroAuto
				aErro := GetAutoGRLog()
				For nI := 1 To Len(aErro)
					cError += aErro[nI]+Chr(13)+Chr(10)
				Next nI
				AaDd(aErros,{xFilial("SE2") + SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA,;
					"Erro ExecAtuto FINA080",cError})
			EndIf
		Else
			cError := "Titulo não Encontrado."
			AaDd(aErros,{xFilial("SE2") + cE2_PREFIXO + cE2_NUM + cE2_PARCELA + cE2_TIPO + cE2_FORNECE + cE2_LOJA,;
				"Erro ExecAtuto FINA080",cError})
		EndIf
	EndIf

Return aErros

Static Function SelectRel()

	aRadio := { "Relatório Geral" , "Hist.Detalhado" , "Report Mensal" }
	nRadio := 1
	@ 96,042 TO 500,505 DIALOG oDlg6 TITLE "Impressão de Relatórios."

	@ 10,05 TO 200,120 TITLE "Lista de Opcoes"
	@ 20,10 RADIO aRadio VAR nRadio

	@ 45,180 BUTTON "Confirma"      SIZE 50,15 ACTION Relatorios(nRadio)
	@ 65,180 BUTTON "Sair"          SIZE 50,15 ACTION Close(oDlg6)

	ACTIVATE DIALOG oDlg6 CENTERED

Return

Static Function Relatorios(nOpcar)

	Do Case
	Case nOpcar == 1
		U_RENDIV01()
	Case nOpcar == 2
		U_RENDIV02()
	Case nOpcar == 3
		U_RENDIV03()
	EndCase
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RetConNum     ºAutor  ³Retorna Numeraçãoº Data ³  09/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de contraole de numeração da rotina de envidamento. º±±
±±º          ³ Valida o próximo número.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AENDVNCTR(cRotinaAtu)
	Local cRetNum := ""
	Local nTamCodSeq := TamSx3("ZY_CODSEQ")[1]
	Local aAreaAtu := GetArea()
	Local cCodCtrSZY := ""
	Default cRotinaAtu := ""

	If Alltrim(cRotinaAtu) $ "U_AENDVF01" //Controle de Endividamento

		cCodCtrSZY := GetSx8Num("SZY", "ZY_CODSEQ")
		DbSelectArea("SZY")
		SZY->(DbSetOrder(1)) //ZY_FILIAL, ZY_CODSEQ

		While SZY->(DbSeek(xFilial("SZY") + cCodCtrSZY))
			ConfirmSx8()
			cCodCtrSZY := GetSx8Num("SZY", "ZY_CODSEQ")
		End
		If Empty(Alltrim(cCodCtrSZY))
			cCodCtrSZY := GetSxENum("SZY", "ZY_CODSEQ")
		EndIf
	EndIf

	cRetNum := cCodCtrSZY

	RestArea(aAreaAtu)
Return cRetNum



User Function EndvDcSai(cCodForn,cLojForn)

	Local   cCadastro  := "Notas Fiscais do Fornecedor"
	Local   aRotOld    := Iif(Type('aRotina') == 'A',AClone(aRotina),{})
	Local   aCampos    := {}
	Local   aIndexSF1  := {}
	Local   cFiltraSF1 := ''
	Local   bFiltraBrw := {|| Nil}
	Local   nRecnoSF1  := 0
	Local   cFilSF1    := ''
	Local cNfsFiltro  := ""
	Local cQryFor	:= ""
	Local aAreaAtu := GetArea()
	Private oBrwBusca
	Private nOpcSel    := 0
	Private cFiltro	:= ""
	Default cCodForn := ""
	Default  cLojForn := ""
//cAlias := "SF1" 
//nReg  := nOpcx
	aRotina := {}
	AAdd( aRotina, { "Confirmar" ,"U_EndvConfS",0,2,,,.T.} ) // "&Confirmar"
	AAdd( aRotina, { "Visual.NF" ,"U_EndvVsNF",0,2,,,.T.} ) // "&Visuliazar"


//AAdd(aCampos, {"F1_DOC", "C", 9, 0})
//AAdd(aCampos, {"F1_SERIE", "C", 3, 0})      
//AAdd(aCampos, {"F1_EMISSAO", "D", 8, 0})
//AAdd(aCampos, {"F1_VALBRUT", "N", 15,2})
//AAdd(aCampos, {"F1_XNOMFOR","C",30,0})  

	AAdd(aCampos, "F1_DOC")
	AAdd(aCampos,"F1_SERIE")
	AAdd(aCampos,"F1_EMISSAO")
	AAdd(aCampos,"F1_VALBRUT")
	AAdd(aCampos,"F1_XNOMFOR")


	cFilSF1 := xFilial('SF1')


	cQryFor := " SELECT F1_DOC F1DOC FROM " + RetSqlName("SF1")  + " SF1 "
	cQryFor += " JOIN " + RetSqlName("SA2") + " SA2 ON SA2.D_E_L_E_T_ = '' AND SA2.A2_FILIAL = '" + xFilial("SA2") +  "' AND SA2.A2_COD = SF1.F1_FORNECE AND SA2.A2_LOJA = SF1.F1_LOJA AND SA2.A2_MSBLQL <> '1' "
	cQryFor += " WHERE SF1.D_E_L_E_T_ = '' AND SF1.F1_FILIAL = '" + cFilSF1 + "' "
	cQryFor += " AND SF1.F1_FORNECE = '" + cCodForn + "' AND SF1.F1_LOJA = '" + cLojForn + "' "
	cQryFor += " AND SF1.F1_DOC+SF1.F1_FILIAL IN ( "
	cQryFor += " SELECT E2_NUM+SE2.E2_FILORIG FROM " + RetSqlName("SE2") + " SE2 "
	cQryFor += " WHERE SE2.D_E_L_E_T_ = '' AND SE2.E2_FILIAL = '" + xFilial("SE2") + "' "
	cQryFor += " AND SE2.E2_FORNECE = '" + cCodForn + "' AND SE2.E2_LOJA = '" + cLojForn + "' "
	cQryFor += " AND SE2.E2_SALDO > 0  "
	cQryFor += " GROUP BY E2_NUM+SE2.E2_FILORIG) "

	If Select("TRBNFS") > 0
		TRBNFS->(DbCloseArea())
	EndIf
	TCQUERY cQryFor  New Alias "TRBNFS"


	IF TRBNFS->(!EOF())
		cNfsFiltro  := ""
		While TRBNFS->(!EOF())
			cNfsFiltro += TRBNFS->F1DOC + "/"
			TRBNFS->(DbSkip())
		EndDo

		SF1->(DbSetOrder(1))

		cFiltraSF1 := "SF1->F1_FILIAL == '"+cFilSF1+"' .And. "
		cFiltraSF1 += "SF1->F1_DOC $ '" + cNfsFiltro + "' .And. "
		cFiltraSF1 += "SF1->F1_FORNECE == '" + cCodForn + "' .And. "
		cFiltraSF1 += "SF1->F1_LOJA == '" + cLojForn + "' "
		bFiltraBrw := {|| FilBrowse("SF1",@aIndexSF1,@cFiltraSF1) }
		Eval(bFiltraBrw)
		dbGoTop()
		//DbSelectArea("SF1")
		//Set Filter To &(cFiltraSF1)

		//MaWndBrowse(0,0,300,600,cCadastro,"SF1",aCampos,aRotina,,,,.T.)

		oBrwBusca := MaWndBrowse(0,0,300,600,cCadastro,"SF1",aCampos,aRotina,,,,.F.)
		nRecnoSF1 := SF1->(Recno())
	EndFilBrw("SF1",aIndexSF1)

	SF1->(dbGoTo(nRecnoSF1))

Else
	MsgStop("Não foi possível encontrar registros com o Fornecedor + Loja informado, verifique!","Erro Pesquisa Nota")
EndIf
//DbClearFilter()                         
aRotina   := AClone(aRotOld)
TRBNFS->(DbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza o uso da funcao FilBrowse e retorna os indices padroes.       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//EndFilBrw("SF1",aIndexSF2)

Return( nOpcSel == 1 )


User Function EndvConfS()

	nOpcSel := 1

	If Type("oWind") == "O"
		oBrwBusca:End()
	Else
		oBrwBusca:End()
	EndIf

Return( Nil )

User Function EndvVsNf()

	A103NFiscal("SF1",SF1->(Recno()),2)

Return

  /*                                            

User Function AENDVTXDI(dDtCalculo,dDtSaldo,cContrato,lBaixa,nPosMoeda,nTaxaNom)
Local nFatorUm		:= DEC_CREATE("1",64,0)                                                       
Local nResultParc	:= DEC_CREATE("1",64,16)
Local nValor1 := 0
Local nValor2 := 0
Local CBASECDI := "2" 
Local nFormula1	:= 0
Local nFormula2	:= 0
Local cDate     := "DD/MM/YYYY"
Local nDec1	:= 0
Local nDec2	:= 0

Default nPosMoeda := 6
Default lBaixa	  := .f.
Default nTaxaNom  := 1
nPosMoeda := SM2->(FIELDPOS("M2_MOEDA"+Alltrim(STR(nPosMoeda))))

	If lBaixa
	dbSelectArea("SM2") // Cadastro de Moedas
	dbSetOrder(1)
	dbSeek( dDtSaldo )
	nTaxaNom  := SM2->(FieldGet(nPosMoeda))
	//DbSelectArea('SZW')
	//SZW->(DbSetOrder(1))
	//IF SZW->(DBSeek(xFilial('SZW') + cContrato ))
	//	dDtCalculo := SZW->ZW_DTCONTR
	//Else
 	//dDtCalculo := dDtCalculo - 30
	//EndIf
	EndIf



	While ( dDtCalculo < dDtSaldo )
			
	dbSelectArea("SM2") // Cadastro de Moedas
	dbSetOrder(1)
	dbSeek( dDtCalculo )
		If ( Found() )
            
		nFatorDia := DEC_CREATE("1",64,16)
		
			If (cBaseCdi=="1") .Or. dDtCalculo <= Ctod("31/12/1997") // Ate 31/12/1997 a taxa do DI era divulgada ao mes, depois a taxa comecou a ser divulgada ao ano.
			
			nFormula1 := nTaxaNom/100 //Percentual destacado - Precisao 4
			nFormula2 := SM2->(FieldGet(nPosMoeda))/3000 ////TDIk - Precisao 8
			
			Else
		
			nFormula1 := nTaxaNom/100 //Percentual destacado - Precisao 4
			
			nValor1 := (1+(SM2->(FieldGet(nPosMoeda))/100))    
			nValor2 := (1/252)
	    
			nFormula2 = (nValor1 ^ nValor2)-1   //TDIk - Precisao 8
	                               
			Endif
	
		nDec1   := DEC_CREATE(Str(nFormula1),64,4)
		nDec2   := DEC_CREATE(Str(nFormula2),64,8)
	    
		nFatorDia   :=  DEC_MUL(nDec1,nDec2) 
		nFatorDia   :=  DEC_RESCALE(nFatorDia,16,2) // Produtorio das taxas (C) - Precisao 16
	
		nFatorDia   :=  DEC_ADD(nFatorUm,nFatorDia) // Soma 1 no Produtorio das taxas (C) 
	    
		nResultParc := DEC_MUL(nFatorDia,nResultParc)            
		nResultParc := DEC_RESCALE(nResultParc,16,2) // Produtorio das taxas (C) - Precisao 16	
		EndIf

	SET(_SET_DATEFORMAT, "DD/MM/YY")
	
	lFerMunic := .F.
	dFerMunic := dDtCalculo+1
	aArea := GetArea()
	DbSelectArea("SX5")
	SX5->(DbSetOrder(1)) // X5_FILIAL+X5_TABELA+X5_CHAVE
	SX5->(DbSeek(xFilial()+"63")) // TABELA DE FERIADOS
		While SX5->(!EOF()) .And. SX5->X5_TABELA == "63"
			If DTOC(dFerMunic) == SubSTR(SX5->X5_DESCRI,1,8) .Or. SubSTR(DTOC(dFerMunic),1,5) == SubSTR(SX5->X5_DESCRI,1,5)
			nPosFer	:= At("[",SX5->X5_DESCRI)
			cTpFeriado := If( nPosFer != 0, SubSTR(SX5->X5_DESCRI,nPosFer+1,1),"U") 	// N - NACIONAL / E - ESTADUAL / M - MUNICIPAL
				If cTpFeriado == "M" .And. DOW(dFerMunic) != 1 .And. DOW(dFerMunic) != 7
				lFerMunic := .T.
				Exit
				EndIf
			EndIf
		cTpFeriado := "U" // INDEFINIDO
		SX5->(DbSkip())
		EndDo
	
	SET(_SET_DATEFORMAT, cDate)
	
		If lFerMunic // FERIADO MUNICIPAL É CONSIDERADO NO CALCULO
		dDtCalculo := dFerMunic
		Else
		dDtCalculo := DataValida(dDtCalculo+1,.T.)
		EndIf
	RestArea(aArea)
	EndDo

//Fator resutante - Precisao 8
nResultParc := DEC_RESCALE(nResultParc,8,0)
nFatorAtu := Val(cValToChar(nResultParc)) //Transforma para numerico

Return nFatorAtu
*/



User Function AENDVTXDI(dDtCalculo,dDtSaldo,cContrato,lBaixa,nPosMoeda,nTaxaNom)
	Local nFatorUm		:= DEC_CREATE("1",64,0)
	Local nResultParc	:= DEC_CREATE("1",64,16)
	Local nValor1 := 0
	Local nValor2 := 0
	Local CBASECDI := "2"
	Local nFormula1	:= 0
	Local nFormula2	:= 0
	Local cDate     := "DD/MM/YYYY"
	Local nDec1	:= 0
	Local nDec2	:= 0

	Default nPosMoeda := 6
	Default lBaixa	  := .f.
	Default nTaxaNom  := 0
	nPosMoeda := SM2->(FIELDPOS("M2_MOEDA"+Alltrim(STR(nPosMoeda))))

	nQtdDias  := CalcDiaUtil(dDtCalculo,dDtSaldo)  //Retira o dia da baixa, pois é o fator anterior

	nDifAcum := 0
	nTxDia	 := 0
/*
	While ( dDtCalculo < dDtSaldo )
			
	dbSelectArea("SM2") // Cadastro de Moedas
	dbSetOrder(1)
	dbSeek( dDtCalculo )
		If ( Found() )
			If nTxDia <>  SM2->(FieldGet(nPosMoeda)) .And.  SM2->(FieldGet(nPosMoeda)) > 0 .And. nTxDia > 0
			nDifAcum += nTxDia - SM2->(FieldGet(nPosMoeda))
			Else
			nTxDia := SM2->(FieldGet(nPosMoeda))    
			EndIf
		EndIf
	dDtCalculo := DataValida(dDtCalculo+1,.T.)	
	EndDo
*/
	nQtdMoeda := 0
	DbSelectArea("SM2")
	SM2->(DbSetOrder(1))
	While ( dDtCalculo < dDtSaldo )
		If SM2->(DbSeek(DTOS(dDtSaldo)))
			//nTxDia := SM2->(FieldGet(nPosMoeda))
			IF SM2->(FieldGet(nPosMoeda)) > 0
				nTxDia := nTxDia + SM2->(FieldGet(nPosMoeda))
				nQtdMoeda ++
			EndIf
			//MsgAlert("Taxa moeda" + STR(nTxDia))
		Else
			//MsgAlert("Taxa Não cadastrada para essa data")
			nTxDia := 0
		EndIf
		dDtCalculo := dDtCalculo + 1
	EndDo
	nTxDia := nTxDia / nQtdMoeda
//Fator resutante - Precisao 8
//nResultParc := DEC_RESCALE(nResultParc,8,0)
	nFatorAtu := IIF(nTxDia > 0,(nTxDia / 21 * nQtdDias),0)

Return nFatorAtu

Static Function CalcDiaUtil(dDtInic,dDtFim)
	Local dDataAtu
	Local nQtdDias := 0
	Local dDataVld

	dDataAtu := dDtInic
	While dDataAtu <= dDtFim
		dDataVld := DataValida(dDataAtu)
		If dDataVld == dDataAtu
			nQtdDias ++
		EndIf
		dDataAtu := dDataAtu + 1
	EndDo
Return nQtdDias



Static Function MenuDef()

Local nPos       := 0
Local aEntRelac  := {}
Local aAtiv      := {}
Local aAnotac    := {}
Local aRotina2  := {{"Incluir","A410Barra",0,3},;							   // "Incluir"
				    {"Alterar","A410Barra",0,4}}								// "Alterar"
Local aRotina3  := {{ "Excluir","A410Deleta"	,0,5,21,NIL},;
					{ "Residuo","Ma410Resid",0,2,0,NIL}}			//"Residuo"

Private aRotina := {	{	"Pesquisar","AxPesqui"		,0,1,0 ,.F.},;		//"Pesquisar"
							{ "Visual","A410Visual"	,0,2,0 ,NIL},;		//"Visual"
							{ "Incluir","A410Inclui"	,0,3,0 ,NIL},;		//"Incluir"
							{ "Alterar","A410Altera"	,0,4,20,NIL},;		//"Alterar"
							{ "Excluir",IIf((Type("l410Auto") <> "U" .And. l410Auto),"A410Deleta",aRotina3),0,5,0,NIL},; // Excluir
							{ "Cod.Barra",aRotina2 		,0,3,0 ,NIL},;		//"Cod.barra"
							{ "Copia","a410PCopia('SC5',SC5->(RecNo()),4)"	,0,6,0 ,NIL},;		//"Copia"
							{ "Dev. Compras","A410Devol('SC5',SC5->(RecNo()),4)"	,0,3,0 ,.F.},;		//"Dev. Compras"
							{ "Prep.Doc.Saída","Ma410PvNfs"	,0,2,0 ,NIL},;		//"Prep.Doc.Saída"
							{ "Tracker Contábil","CTBC662", 0, 7, 0, Nil },; 		//"Tracker Contábil"
							{ "Legenda","A410Legend"	,0,1,0 ,.F.} }		//"Legenda"

Aadd(aEntRelac, { "Conhecimento", "MsDocument('SC5',SC5->(RecNo()),4)", 0, 4, 0, NIL })//"Conhecimento"

If nModulo == 73
	
	Aadd(aEntRelac, { "Privilégios", "CRMA200('SC5')", 0, 8, 0, NIL })//"Privilégios" 
	
	aEntRelac := CRMXINCROT("SC5",aEntRelac)
	
	nPos := ASCAN(aEntRelac, { |x| IIF(ValType(x[2]) == "C", x[2] == "CRMA190Con()",Nil) })
	If nPos > 0 
		ADD OPTION aRotina TITLE aEntRelac[nPos][1] ACTION aEntRelac[nPos][2] OPERATION 8  ACCESS 0//"Conectar"
		Adel(aEntRelac,nPos)
		Asize(aEntRelac,Len(aEntRelac)-1)
	EndIf
	
	nPos := ASCAN(aEntRelac, { |x|  IIF(ValType(x[2]) == "C", x[2] == "CRMA180()", Nil) })
	If nPos > 0
		ADD OPTION aAtiv   TITLE "Nova Atividade" ACTION "CRMA180(,,,3,,)" OPERATION 3  ACCESS 0 //"Nova Atividade" 
		ADD OPTION aAtiv   TITLE "Todas as ATividades" ACTION "CRMA180()" OPERATION 8  ACCESS 0 //"Todas as ATividades"
		aEntRelac[nPos][2] := aAtiv
	EndIf
	
	nPos := ASCAN(aEntRelac, { |x| IIF(ValType(x[2]) == "C", x[2] == "CRMA090()", Nil)})
	If nPos > 0
		ADD OPTION aAnotac   TITLE "Nova Anotação" ACTION "CRMA090(3)" OPERATION 3  ACCESS 0 //"Nova Anotação"
		ADD OPTION aAnotac   TITLE "Todas as Anotações" ACTION "CRMA090()" OPERATION 8  ACCESS 0 //"Todas as Anotações" 
		aEntRelac[nPos][2] := aAnotac
	EndIf
EndIf

Asort(aEntRelac,,,{ | x,y | y[1] > x[1] } )
Aadd(aRotina, {"Relacionadas",aEntRelac	, 0 , 8 , 3 	, .T.	})//"Relacionadas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica motivo de bloqueio por regra/verba                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If	SuperGetMv("MV_VEBLQRG", .F., .F.)	
	aAdd(aRotina,{ "Blq. Regra" ,"BlqRegBrw",0,0,0 ,NIL} )		//"Blq. Regra"
EndIf
				
If ExistBlock("MA410MNU")
	ExecBlock("MA410MNU",.F.,.F.)
EndIf

//PONTO DE ENTRADA para Incluir chamada de acao relacionada no menu do pedido
If FindFunction("OGX225F") .AND. (SuperGetMV("MV_AGRUBS",.F.,.F.))
   aRotina := OGX225F(aRotina)
EndIf
Return(aRotina)
