#Include "Protheus.ch"
#Include "topconn.ch"
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: FATUZAL     				                    AUTOR: CARLOS ALDAY TORRES           DATA: 16/11/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Tabela de codigo de concessao dada ao cliente no regime especial de tributacao
//| OBSERVACAO: 
//+--------------------------------------------------------------------------------------------------------------

User Function FATUZAL()
	//AxCadastro("ZAL","Concessão R.E.","U_EXCLZAL()","U_MUDAZAL()")
	Private cCadastro := "Concessão R.E."
	Private aRotina := {}
	Private __nOpcao

	AADD( aRotina, {"Pesquisar"  ,"AxPesqui" ,0,1})
	AADD( aRotina, {"Visualizar" ,'U_TFZalMnt',0,2})
	AADD( aRotina, {"Incluir"    ,'U_TFZalInc',0,3})
	AADD( aRotina, {"Alterar"    ,'U_TFZalMnt',0,4})
	AADD( aRotina, {"Excluir"    ,'U_TFZalMnt',0,5})

	dbSelectArea("ZAL")
	dbSetOrder(1)
	dbGoTop()

	MBrowse(,,,,"ZAL")
Return NIL

//+--------------------------------------------------------------------+
//| Rotina | TFZalInc | Autor | CT                | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para incluir dados.                                |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+

User Function TFZalInc( cAlias, nReg, nOpc )
	Local oDlg
	Local oGet


	Private aHeader	:= {}
	Private aCOLS		:= {}
	Private aREG		:= {}
	Private aItems	:={"N=Normal","C=Cassada","A=Anulada","R=Revogada","T=Texto"}
	Private cCodigo	:= Space(Len(ZAL->ZAL_CLIENT))
	Private cLoja 	:= Space(Len(ZAL->ZAL_LOJA))
	Private cConcess	:= Space(Len(ZAL->ZAL_CONCES))
	Private cTipSit	:= Space(Len(ZAL->ZAL_TIPSIT))
	Private cNome		:= Space(30)
	Private dData		:= Ctod(Space(8))
	Private cCodMsg	:= Space(Len(ZAL->ZAL_MENSAG))

	__nOpcao := nOpc
	dbSelectArea( cAlias )
	dbSetOrder(1)

	TFZalaHeader( cAlias )
	TFZalaCOLS( cAlias, nReg, nOpc )

	aSizeAut   := MsAdvSize(,.F.,400)

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
	oTFont := TFont():New('Courier new',,-16,.T.)

	oSay:= TSay():New(48,006,{||'Cliente:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(48,092,{||'Loja:'}		,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(48,166,{||'Nome:'}		,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)

	oSay:= TSay():New(62,006,{||'Situação:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,092,{||'Validade:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,166,{||'Concessão:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,270,{||'Mensagem:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)

	oTGet1 := TGet():New( 047,028,{|u| If(PCount()>0,cCodigo:=u,cCodigo)}		,oDlg ,030,007,"@!"			,{|| TFZalClie(cCodigo,@cNome)}	,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SA1"	,"cCodigo",,)
	oTGet2 := TGet():New( 047,115,{|u| If(PCount()>0,cLoja:=u,cLoja)}			,oDlg ,020,007,"@!"			,{|| TFZalLoja(cCodigo,cLoja)}	,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,""		,"cLoja",,)

	@ 47, 195 MSGET cNome When .F. SIZE 200,7 PIXEL OF oDlg

	oCombo1 := TComboBox():New(061,028,{|u|if(PCount()>0,cTipSit:=u,cTipSit)},aItems,050,020,oDlg,,,,,,.T.,,,,,,,,,'cTipSit')

	oTGet3 := TGet():New( 061,115,{|u| If(PCount()>0,dData:=u,dData)}		,oDlg ,040,007,"99/99/99"	,{|| !Empty(dData)}				,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,""		,"dData",,)
	oTGet4 := TGet():New( 061,195,{|u| If(PCount()>0,cConcess:=u,cConcess)}	,oDlg ,050,007,"@!"		 	,{|| TFVLConc(cConcess,cCodigo,cLoja,nOpc)}		,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,""		,"cConcess",,)
	oTGet5 := TGet():New( 061,304,{|u| If(PCount()>0,cCodMsg:=u,cCodMsg)} 	,oDlg ,030,007,"@!"		 	,{|| !Empty(cCodMsg)}			,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SM4"	,"cCodMsg",,)

	oGet := MSGetDados():New(85,05,200,200,nOpc,"U_TFZalLOk()","U_TFZalTOk","+ZAL_ITEM",.T., {"ZAL_XITEMC","ZAL_POSIPI"}, , .F., 200, "U_TFZalDet", "U_TFSUPERDEL", , "U_TFDELOK", oDlg)

	ACTIVATE MSDIALOG oDlg CENTER ON INIT 	EnchoiceBar(oDlg,{|| (IIF(U_TFZalTOk(), TFZalGrvI(), "") ,  oDlg:End()) },{|| oDlg:End() })

Return

User Function TFTUDOOK()
	//ApMsgStop("LINHAOK")
Return .T.
User Function TFDELOK()
	Local lReturn:=.T.
	//ApMsgStop("DELOK")
	If __nOpcao=2
		lReturn:=.F.
	EndIf
Return (lReturn)
User Function TFSUPERDEL()
	Local lReturn:=.T.
	If __nOpcao=2
		lReturn:=.F.
	EndIf
	//ApMsgStop("SUPERDEL")
Return .T.
//+--------------------------------------------------------------------+
//| Rotina | TFZalDet | Autor | CT                 | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | rotina para validar conteúdo das demais linhas.           |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
User Function TFZalDet()
	Local lRetorna := .T.
	If __nOpcao=2
		lRetorna:=.F.
	EndIf
Return (lRetorna)


//+--------------------------------------------------------------------+
//| Rotina | TFZalMnt | Autor | CT                | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+

User Function TFZalMnt( cAlias, nReg, nOpc )

	Local oDlg
	Local oGet
	Local oTFont
	Local aSizeAut:= {}

	Private aHeader	:= {}
	Private aCOLS		:= {}
	Private aREG		:= {}
	Private cCodigo	:= Space(Len(ZAL->ZAL_CLIENT))
	Private cLoja 	:= Space(Len(ZAL->ZAL_LOJA))
	Private cConcess	:= Space(Len(ZAL->ZAL_CONCES))
	Private cTipSit	:= Space(Len(ZAL->ZAL_TIPSIT))
	Private cNome		:= Space(30)
	Private dData		:= Ctod(Space(8))
	Private cCodMsg	:= Space(Len(ZAL->ZAL_MENSAG))
	Private aItems	:={"N=Normal","C=Cassada","A=Anulada","R=Revogada","T=Texto"}
	__nOpcao := nOpc

	dbSelectArea( cAlias )
	dbGoTo( nReg )

	cCodigo := ZAL->ZAL_CLIENT
	cLoja	 := ZAL->ZAL_LOJA
	cNome   := POSICIONE("SA1",1,XFILIAL("ZAL") + ZAL->(ZAL_CLIENT+ZAL_LOJA) ,"A1_NOME")
	dData   := ZAL->ZAL_VALIDA
	cConcess:= ZAL->ZAL_CONCES
	cTipSit := ZAL->ZAL_TIPSIT
	cCodMsg := ZAL->ZAL_MENSAG

	aSizeAut   := MsAdvSize(,.F.,400)
	TFZalaHeader( cAlias )
	TFZalaCOLS( cAlias, nReg, nOpc )

	DEFINE MSDIALOG oDlg FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL
	oTFont := TFont():New('Courier new',,-16,.T.)

	oSay:= TSay():New(48,006,{||'Cliente:'}		,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(48,092,{||'Loja:'}		,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(48,166,{||'Nome:'}		,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)

	oSay:= TSay():New(62,006,{||'Situação:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,092,{||'Validade:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,166,{||'Concessão:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)
	oSay:= TSay():New(62,270,{||'Mensagem:'}	,oDlg,,oFont,,,,.T.,NIL,NIL,70,7)

	If nOpc == 4 // Alteração
		@ 47, 028 MSGET cCodigo		When .F. SIZE 030,7 PIXEL OF oDlg
		@ 47, 115 MSGET cLoja		When .F. SIZE 020,7 PIXEL OF oDlg
		@ 47, 195 MSGET cNome		When .F. SIZE 200,7 PIXEL OF oDlg

		oCombo1 := TComboBox():New(061,028,{|u|if(PCount()>0,cTipSit:=u,cTipSit)},aItems,050,020,oDlg,,,,,,.T.,,,,,,,,,'cTipSit')

		oTGet3 := TGet():New( 061,115,{|u| If(PCount()>0,dData:=u,dData)}		,oDlg ,040,007,"99/99/99"	,{|| !Empty(dData)}				,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,""		,"dData",,)
		oTGet4 := TGet():New( 061,195,{|u| If(PCount()>0,cConcess:=u,cConcess)}	,oDlg ,050,007,"@!"		 	,{|| TFVLConc(cConcess,cCodigo,cLoja,nOpc)}			,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,""		,"cConcess",,)
		oTGet5 := TGet():New( 061,304,{|u| If(PCount()>0,cCodMsg:=u,cCodMsg)} 	,oDlg ,030,007,"@!"		 	,{|| !Empty(cCodMsg)}			,NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SM4"	,"cCodMsg",,)

	Else
		@ 47, 028 MSGET cCodigo		When .F. SIZE 030,7 PIXEL OF oDlg
		@ 47, 115 MSGET cLoja		When .F. SIZE 020,7 PIXEL OF oDlg
		@ 47, 195 MSGET cNome		When .F. SIZE 200,7 PIXEL OF oDlg

		@ 61, 028 MSGET cTipSit		When .F. SIZE 015,7 PIXEL OF oDlg

		oTGet3 := TGet():New( 061,115,{|u| dData	}	,oDlg ,040,007,"99/99/99"	,{|| },NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,""	,"dData",,)
		oTGet4 := TGet():New( 061,195,{|u| cConcess	}	,oDlg ,050,007,"@!"		 	,{|| },NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,""	,"cConcess",,)
		oTGet5 := TGet():New( 061,304,{|u| cCodMsg 	} 	,oDlg ,030,007,"@!"		 	,{|| },NIL,NIL,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SM4"	,"cCodMsg",,)

	EndIf


	If nOpc == 4 // Alteração
		oGet := MSGetDados():New(85,05,200,200,nOpc,"U_TFZalLOk()"	,"U_TFZalTOk()"	,"+ZAL_ITEM",.T., {"ZAL_XITEMC","ZAL_POSIPI"}, , .F., 200, "U_TFZalDet"	, "U_TFSUPERDEL"	, , "U_TFDELOK"	, oDlg)
	Else
		oGet := MSGetDados():New(85,05,200,200,nOpc,"U_TFZalLOk()"	,"U_TFZalTOk()"	,"+ZAL_ITEM",.T., {"ZAL_XITEMC","ZAL_POSIPI"}, , .F., 200, ".T."	, "U_TFSUPERDEL"	, , "U_TFDELOK"	, oDlg)
	Endif

	ACTIVATE MSDIALOG oDlg CENTER ON INIT 	EnchoiceBar(oDlg,{|| ( IIF( nOpc==4 , IIF(U_TFZalTOk() ,TFZalGrvA(),	MsgAlert("Dados não alterados!",cCadastro)), IIF( nOpc==5, TFZalGrvE(), oDlg:End() ) ), oDlg:End() ) },	{|| oDlg:End() },.F.)

Return



//+--------------------------------------------------------------------+
//| Rotina | TFZalaHeader | Autor | CT               |Data|23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader.                       |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+

Static Function TFZalaHeader( cAlias )
	Local aArea := GetArea()

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .and. (At(Alltrim(X3_CAMPO),"ZAL_ITEM" )!=0)
			AADD( aHeader, { Trim( X3Titulo() ),;
				X3_CAMPO,;
				X3_PICTURE,;
				X3_TAMANHO,;
				X3_DECIMAL,;
				X3_VALID,;
				X3_USADO,;
				X3_TIPO,;
				X3_ARQUIVO,;
				X3_CONTEXT})
		Endif
		dbSkip()
	End
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .and. (At(Alltrim(X3_CAMPO),"ZAL_XITEMC|ZAL_POSIPI" )!=0)
			AADD( aHeader, { Trim( X3Titulo() ),;
				X3_CAMPO,;
				X3_PICTURE,;
				X3_TAMANHO,;
				X3_DECIMAL,;
				X3_VALID,;
				X3_USADO,;
				X3_TIPO,;
				X3_ARQUIVO,;
				X3_CONTEXT})
		Endif
		dbSkip()
	End
	RestArea(aArea)
Return

//+--------------------------------------------------------------------+
//| Rotina | TFZalaCOLS | Autor | CT               |Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS.                         |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalaCOLS( cAlias, nReg, nOpc )
	Local aArea := GetArea()
	Local cChave := ZAL_CLIENT+ZAL_LOJA+ZAL_CONCES
	Local nI := 0

	If nOpc <> 3
		dbSelectArea( cAlias )
		dbSetOrder(1)
		dbSeek( xFilial( cAlias ) + cChave )
		While !EOF() .And. ZAL->( ZAL_FILIAL + ZAL_CLIENT+ZAL_LOJA+ZAL_CONCES ) == xFilial( cAlias ) + cChave
			AADD( aREG, ZAL->( RecNo() ) )
			AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
			For nI := 1 To Len( aHeader )
				If aHeader[nI,10] == "V"
					aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
				Else
					aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
				Endif
			Next nI
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			dbSkip()
		End
	Else
		AADD( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
		Next nI
		aCOLS[1, GdFieldPos("ZAL_ITEM")] := "01"
		aCOLS[1, Len( aHeader )+1 ] := .F.
	Endif
	Restarea( aArea )
Return

//+--------------------------------------------------------------------+
//| Rotina | TFZalGrvI | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na inclusão.                  |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalGrvI()
	Local aArea := GetArea()
	Local nI := 0
	Local nX := 0

	dbSelectArea("ZAL")
	dbSetOrder(1)
	For nI := 1 To Len( aCOLS )
		If ! aCOLS[nI,Len(aHeader)+1]
			RecLock("ZAL",.T.)
			ZAL->ZAL_FILIAL	:= xFilial("ZAL")
			ZAL->ZAL_CLIENT	:= cCodigo
			ZAL->ZAL_LOJA		:= cLoja
			ZAL->ZAL_VALIDA	:= dData
			ZAL->ZAL_CONCES	:= cConcess
			ZAL->ZAL_TIPSIT	:= cTipSit
			ZAL->ZAL_MENSAG	:= cCodMsg
			For nX := 1 To Len( aHeader )
				FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			Next nX
			MsUnLock()
		Endif
	Next nI

	RestArea(aArea)
Return

//+--------------------------------------------------------------------+
//| Rotina | TFZalGrvA | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalGrvA()
	Local aArea := GetArea()
	Local nI := 0
	Local nX := 0

	dbSelectArea("ZAL")
	For nI := 1 To Len( aCOLS )
		If nI <= Len( aREG )
			dbGoTo( aREG[nI] )
			RecLock("ZAL",.F.)
			If aCOLS[nI, Len(aHeader)+1]
				dbDelete()
			Endif
		Else
			RecLock("ZAL",.T.)
		Endif

		If !aCOLS[nI, Len(aHeader)+1]
			ZAL->ZAL_FILIAL 	:= xFilial("ZAL")
			ZAL->ZAL_CLIENT	:= cCodigo
			ZAL->ZAL_LOJA		:= cLoja
			ZAL->ZAL_VALIDA	:= dData
			ZAL->ZAL_CONCES	:= cConcess
			ZAL->ZAL_TIPSIT	:= cTipSit
			ZAL->ZAL_MENSAG	:= cCodMsg
			For nX := 1 To Len( aHeader )
				FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			Next nX
		Endif
		MsUnLock()
	Next nI
	RestArea( aArea )
Return

//+--------------------------------------------------------------------+
//| Rotina | TFZalGrvE | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para excluir os registros.                         |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalGrvE()
	Local nI := 0

	dbSelectArea("ZAL")
	For nI := 1 To Len( aCOLS )
		dbGoTo(aREG[nI])
		RecLock("ZAL",.F.)
		dbDelete()
		MsUnLock()
	Next nI
Return

//+--------------------------------------------------------------------+
//| Rotina | TFZalClie | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar o código do cliente.                  |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalClie( cCodigo,cNome )
//Local cNome := ""
	If ExistCpo("SA1",cCodigo) //.And. ExistChav("ZAL",cCodigo)
		cNome := Posicione("SA1",1,xFilial("SA1")+cCodigo,"A1_NOME")
	Endif
Return(!Empty(cNome))
//+--------------------------------------------------------------------+
//| Rotina | TFZalClie | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a loja do cliente.                    |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFZalLoja( cCodigo,cLoja )
	Local lRetorna := .F.
	If ExistCpo("SA1",cCodigo+cLoja) //.And. ExistChav("ZAL",cCodigo)
		cNome := Posicione("SA1",1,xFilial("SA1")+cCodigo+cLoja,"A1_NOME")
		lRetorna := .T.
	Endif
Return(lRetorna)

//+--------------------------------------------------------------------+
//| Rotina | TFVLConc   | Autor | CT               | Data | 23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a concessão.                          |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
Static Function TFVLConc(cConcess,cCodigo,cLoja,nOpc)
	Local lRetorna := .T.
	Local xZalAlias:= ZAL->(GetArea())

	If Empty(cConcess)
		MsgAlert("Aviso de inconsistência! Campo obrigatório",cCadastro)
		lRetorna := .F.
	EndIf
	ZAL->(DbSeek( xFilial("ZAL") + cCodigo + cLoja + cConcess ))
	If ZAL->(Found()) .and. nOpc == 3
		MsgAlert("Aviso de inconsistência! Concessão já cadastrada, inclusão não realizada.",cCadastro)
		lRetorna := .F.
	EndIf
	If Ascan(aREG,ZAL->(Recno())) == 0 .and. nOpc == 4
		MsgAlert("Aviso de inconsistência! Concessão já cadastrada, alteração não permitida.",cCadastro)
		lRetorna := .F.
	EndIf
	RestArea(xZalAlias)
Return(lRetorna)

//+--------------------------------------------------------------------+
//| Rotina | TFZalLOk | Autor | CT                 | Data |23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar a linha de dados.                     |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+
User Function TFZalLOk()
	Local lRetorna := .T.
	Local nI := 0

	If !aCOLS[n, Len(aHeader)+1]
		If Empty(aCOLS[n,GdFieldPos("ZAL_XITEMC")])
			MsgAlert("Não é permitido linhas sem a unidade de negócio.",cCadastro)
			lRetorna := .F.
		Endif
		If Empty(aCOLS[n,GdFieldPos("ZAL_POSIPI")])
			MsgAlert("Não é permitido linhas sem NCM.",cCadastro)
			lRetorna := .F.
		Endif
	Endif
	If Len( aCOLS )>1
		For nI := 1 To Len( aCOLS )
			If nI <> n .and. .not. aCols[nI][Len(aHeader)+1]
				If lRetorna .and. Alltrim(aCOLS[n, GdFieldPos("ZAL_XITEMC")]) == Alltrim(aCOLS[nI, GdFieldPos("ZAL_XITEMC")]) .AND. Alltrim(aCOLS[n, GdFieldPos("ZAL_POSIPI")]) == Alltrim(aCOLS[nI, GdFieldPos("ZAL_POSIPI")])
					lRetorna := .F.
					MsgAlert("Aviso de inconsistência!, Conjundo de dados já cadastrados.",cCadastro)
				EndIf
			EndIf
		Next nI
	EndIf

Return( lRetorna )

//+--------------------------------------------------------------------+
//| Rotina | TFZalTOk | Autor | CT                 | Data |23/09/2014 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para validar toda as linhas de dados.              |
//+--------------------------------------------------------------------+
//| Uso    |                                                           |
//+--------------------------------------------------------------------+

User Function TFZalTOk()
	Local lRetorna := .T.
	Local nI := 0
	Local nJ := 0

	For nI := 1 To Len( aCOLS )
		If aCOLS[nI, Len(aHeader)+1]
			Loop
		Endif
		If !aCOLS[nI, Len(aHeader)+1]
			If Empty(aCOLS[n,GdFieldPos("ZAL_XITEMC")])
				MsgAlert("Não será permitido linhas sem a unidade de negócio.",cCadastro)
				lRetorna := .F.
				Exit
			Endif
			For nJ := 1 To Len( aCOLS )
				If nI <> nJ .and. .not. aCols[nJ][Len(aHeader)+1]
					If lRetorna .and. Alltrim(aCOLS[nI, GdFieldPos("ZAL_XITEMC")]) == Alltrim(aCOLS[nJ, GdFieldPos("ZAL_XITEMC")]) .AND. Alltrim(aCOLS[nI, GdFieldPos("ZAL_POSIPI")]) == Alltrim(aCOLS[nJ, GdFieldPos("ZAL_POSIPI")])
						lRetorna := .F.
						MsgAlert("Aviso de inconsistência!, Conjundo de dados em duplicadade. Linha: "+Alltrim(aCOLS[nJ, GdFieldPos("ZAL_XITEMC")])+" NCM:"+Alltrim(aCOLS[nJ, GdFieldPos("ZAL_POSIPI")]),cCadastro)
					EndIf
				EndIf
			Next nJ
		Endif
	Next nI
Return( lRetorna )

//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão/Alterção da tabela ZAL
//+--------------------------------------------------------------------------------------------------------------
User Function MUDAZAL()
	Local lRetorno		:= .T.
	Local nRecno		:= 0
	Local lJaExiste	:= .F.
	Local cChave		:= ""

	ZAL->(DbSetOrder(1))
	If INCLUI
		If ZAL->(DbSeek( xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA + M->ZAL_CONCES ))
			MsgAlert("Aviso de inconsistência! Concessão já cadastrada, inclusão não realizada.",cCadastro)
			lRetorno := .F.
		EndIf
		If lRetorno
			cChave := xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA
			ZAL->(DbSeek( xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA ))
			While ZAL->(ZAL_FILIAL + ZAL_CLIENT + ZAL_LOJA ) = cChave .and. !ZAL->(Eof())
				If ZAL->ZAL_TIPSIT='N' .and. ZAL->ZAL_VALIDA >= M->ZAL_VALIDA //.and. M->ZAL_PROTOC=ZAL->ZAL_PROTOC
					lJaExiste := .T.
				EndIf
				ZAL->(DbSkip())
			End
			If lJaExiste
				MsgAlert("Aviso de inconsistência! Já há concessão dentro da validade, inclusão não realizada.",cCadastro)
				lRetorno := .F.
			EndIf
		EndIf
	EndIf
	If ALTERA
		nRecno := ZAL->(recno())
		cChave := xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA + M->ZAL_CONCES

		ZAL->(DbSeek( xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA + M->ZAL_CONCES ))
		While ZAL->(ZAL_FILIAL + ZAL_CLIENT + ZAL_LOJA + ZAL_CONCES) = cChave .and. !ZAL->(Eof())
			If ZAL->(recno()) != nRecno
				lJaExiste := .T.
			EndIf
			ZAL->(DbSkip())
		End

		If lJaExiste
			MsgAlert("Aviso de inconsistência! Concessão já cadastrada, alteração não realizada.",cCadastro)
			lRetorno := .F.
		EndIf
		If lRetorno
			cChave := xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA
			ZAL->(DbSeek( xFilial("ZAL") + M->ZAL_CLIENT + M->ZAL_LOJA ))
			While ZAL->(ZAL_FILIAL + ZAL_CLIENT + ZAL_LOJA ) = cChave .and. !ZAL->(Eof())
				If ZAL->ZAL_TIPSIT='N' .and. ZAL->ZAL_VALIDA >= M->ZAL_VALIDA .and. ZAL->(recno()) != nRecno  // .and. M->ZAL_PROTOC=ZAL->ZAL_PROTOC
					lJaExiste := .T.
				EndIf
				ZAL->(DbSkip())
			End
			If lJaExiste
				MsgAlert("Aviso de inconsistência! Já há concessão dentro da validade, alteração não realizada.",cCadastro)
				lRetorno := .F.
			EndIf
		EndIf

		ZAL->(DbGoto( nRecno ))
	EndIf
Return lRetorno

//+--------------------------------------------------------------------------------------------------------------
//| Função Exclusão da tabela ZAL
//+--------------------------------------------------------------------------------------------------------------
User Function EXCLZAL()
	Local lRetorno := .T.
Return lRetorno

//+--------------------------------------------------------------------------------------------------------------
//| Função PosicZAL() utilizada no Inic.Padrao do campo ZAL_NOMCLI
//+--------------------------------------------------------------------------------------------------------------
User Function PosicZAL()
	If INCLUI .or. ALTERA
		cRetorno:= POSICIONE("SA1",1,XFILIAL("ZAL") + M->(ZAL_CLIENT+ZAL_LOJA) ,"A1_NOME")
	Else
		cRetorno:= POSICIONE("SA1",1,XFILIAL("ZAL") + ZAL->(ZAL_CLIENT+ZAL_LOJA) ,"A1_NOME")
	EndIf
Return (cRetorno)

/*
#include "protheus.ch"
User Function Exemplo()
Local nI
Local oDlg
Local oGetDados
Local nUsado := 0
Private lRefresh := .T.
Private aHeader := {}
Private aCols := {}
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
	                 {"Visualizar", "AxVisual", 0, 2},;
	                 {"Incluir", "AxInclui", 0, 3},;
	                 {"Alterar", "AxAltera", 0, 4},;
	                 {"Excluir", "AxDeleta", 0, 5}}
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SA1")
	While !Eof() .and. SX3->X3_ARQUIVO == "SA1"
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
		nUsado++        
		Aadd(aHeader,{Trim(X3Titulo()),;
				SX3->X3_CAMPO,;                      
				SX3->X3_PICTURE,;                      
				SX3->X3_TAMANHO,;                      
				SX3->X3_DECIMAL,;                      
				SX3->X3_VALID,;                      
				"",;                      
				SX3->X3_TIPO,;                      
				"",;                      
				"" })
		EndIf
	DbSkip()
	End
Aadd(aCols,Array(nUsado+1))For nI := 1 To nUsado    aCols[1][nI] := CriaVar(aHeader[nI][2])NextaCols[1][nUsado+1] := .F.
DEFINE MSDIALOG oDlg TITLE "Exemplo" FROM 00,00 TO 300,400 PIXEL
oGetDados := MsGetDados():New(05, 05, 145, 195, 4, "U_LINHAOK", "U_TUDOOK", "+A1_COD", .T., {"A1_NOME"}, , .F., 200, "U_FIELDOK", "U_SUPERDEL", , "U_DELOK", oDlg)
ACTIVATE MSDIALOG oDlg CENTERED
Return 

User Function LINHAOK()ApMsgStop("LINHAOK")Return .T.
User Function TUDOOK()ApMsgStop("LINHAOK")Return .T.
User Function DELOK()ApMsgStop("DELOK")Return .T.
User Function SUPERDEL()ApMsgStop("SUPERDEL")Return .T.
User Function FIELDOK()ApMsgStop("FIELDOK")Return .T.
*/
