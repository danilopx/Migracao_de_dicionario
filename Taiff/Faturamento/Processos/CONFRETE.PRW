#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONFRETE ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±                    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia da Fatura e seus Conhecimentos de Frete        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Motivo da Alteracao                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Card³15/03/13³Tratamento de erro na variavel de loop do acols  ³±±
±±³            ³        ³da funcao MontaTela                              ³±±
±±³Marcelo Card³19/03/13³Tratamento da possibilidade de mesma numeracao de³±±
±±³            ³        ³conhecimentos para transportadoras distintas     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CONFRETE(xAutoCab,xAutoItens,nOpcAuto)

	Local aCores := {}
	Private lMsErroAuto := .F.
	PRIVATE	_cFatura
	PRIVATE _cTipo
	PRIVATE _lFatura
	PRIVATE _cOperacao
	PRIVATE _cCgcTra
	PRIVATE	_cTransp
	PRIVATE _nValor
	PRIVATE _dEmissao
	PRIVATE _dVencto
	PRIVATE _nDesconto
	PRIVATE _nAjuste
	PRIVATE _nRetorno
	PRIVATE _cAlias
	PRIVATE _nPosSer
	PRIVATE _nPoscgc
	PRIVATE _nPosTipo
	PRIVATE _nPosNF
	PRIVATE _nPosCto
	PRIVATE _nPosFrTra
	PRIVATE _nPosFrCal
	PRIVATE _nPosTxCto
	PRIVATE _nPosVlPed
	PRIVATE _nPosOtrTx
	PRIVATE _nPosVlGri
	PRIVATE _nPosAdVal
	PRIVATE _nPosVlPes
	PRIVATE _nPosAdPes
	PRIVATE _nPosTxPes
	PRIVATE _nPosFrTol
	PRIVATE _nPosCont
	PRIVATE _nPosTDE
	PRIVATE _nPosTRT
	PRIVATE _nPosPesoCub
	PRIVATE _nPosVlAjus
	PRIVATE _nPosCliFor
	PRIVATE _nPosSeqCon
	//PRIVATE _nPosCliFor
	PRIVATE _nPosLoja
	PRIVATE _nPosChvNFe // 20130328
	PRIVATE _cChvNFe
	PRIVATE _lAltValor := .F.
	PRIVATE _lAltera := .F.
	PRIVATE cCadastro:= "Manutencao de Fatura de Frete"
	PRIVATE lAutoConF := .F.
	PRIVATE cPerg   := PADR("CONFRE",10)
	PRIVATE CMPAVCODTRA := ""
	PRIVATE aRotina := 	{ {OemToAnsi("Pesquisar"),"AxPesqui"  , 0 , 1},;	//"Pesquisar"
	{OemToAnsi("Visualizar"),"U_FRVISUAL", 0 , 2},	;	//"Visualizar"
	{OemToAnsi("Incluir"),"U_FRINC", 0 , 3},		;	//"Incluir"
	{OemToAnsi("Alterar"),"U_FRALT", 0 , 4},		;	//"Alterar"
	{OemToAnsi("Excluir"),"U_FREXC", 0 , 5},		;	//"Excluir"
	{OemToAnsi("Liberar"),"U_FRLIBEST(3)", 0 , 6}, ;	// Liberar
	{OemToAnsi("Estornar"),"U_FRLIBEST(5)", 0 , 6}}	// Estornar

	If xAutoCab <> Nil
		DEFAULT nOpcAuto := 3
		aAutoCab   := xAutoCab
		aAutoItens := xAutoItens
		lAutoConF := .T.
		MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"PAV")
		xAutoCab   := aAutoCab
		xAutoItens := aAutoItens
	Else
		DBSelectArea("PAV")
		_cFiltro	:= " PAV_FATURA <> '' "
		mBrowse(06, 01, 22, 75, "PAV",,"PAV_LIBERA",,,,aCores,,,,,,,, _cFiltro)
	endif

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MONTATELA³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Montagem da Tela Principal                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ _cOpcao -> A=Altera,I=Inclui,V=Visualiza,E=Exclui          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaTela(_cOpcao,_cTpOp)

	Local _aButtons  := {}
	Local nLd	:= 0
	//Local aCoors := FWGetDialogSize( oMainWnd )
	Local i := 0
	Local nI := 0
	Local nLoop := 0
	Local _nTp := 0
	Local nX := 0

	DEFAULT _cOpcao := "I"
	DEFAULT _cTpOp  := "F"

	if Type("_lEDIAutoMail") == "U"
		_lEDIAutoMail := .F.
	endif

	ValidPerg(cPerg)
	_lFatura   := _cTpOp == "F"
	_cOperacao := _cOpcao

	aadd(_aButtons,{"ORDEM",{|| U_RESUNOTA()},"Dados N.F." })
	aadd(_aButtons,{"mdiexcel",{|| ExpExcel(aHeader,aCols) },"Excel" })
	aadd(_aButtons,{"CARGA",{|| TotConhec()},"Res.Conhec." })
	aadd(_aButtons,{"geo",{|| U_TABREG()},"Regioes" })
//aadd(_aButtons,{"comptitl",{|| U_TABFRE()},"Tab.Frete" })
	aadd(_aButtons,{"comptitl",{|| Ajusta()},"Ajustar" })
	if _lFatura
		aadd(_aButtons,{"AddContainer",{|| U_SELCONHE()},"Imp.Conhec" })
	endif

	PRIVATE LVar01		:=1,nLinhas:=0,bCampo,cSaveMenuh
	PRIVATE cCampo		:=""
	//PRIVATE i:=0
	PRIVATE aObjects 	:={},aPosObj  :={}
	PRIVATE aSize    	:= MsAdvSize()
	PRIVATE aInfo    	:={aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	PRIVATE _cNometra	:= " "
	PRIVATE GetList		:={}, _nOpcao:=3, oDlg
	PRIVATE aLogSld 	:= {}
	PRIVATE aValidGet	:= {}
	PRIVATE cNometra	:= " "
//PRIVATE _aCombo		:= {"Venda","Compra","NRecusa","Devolucao","Reentrega","Armaz Retorno","Envio Armazenagem"}
	PRIVATE _aCombo		:= {"Venda","NRecusa","Reentrega","Devolucao"}
	PRIVATE _aComboTDE	:= {"Sim","Nao"}
	Private _nPosH      := 0
	Private _lSerieCTo  := AllTrim(GetSx3Cache("PAV_SERCTO", "X3_CAMPO")) == "PAV_SERCTO"

	_cTipo	    := "Venda"
	_cFatura	:= CriaVar("PAV_FATURA")
	_cTransp	:= CriaVar("PAV_CODTRA")
	_cTipo  	:= CriaVar("PAV_TIPO")
	_nValor		:= CriaVar("PAV_FRETRA")
	_dEmissao	:= CriaVar("PAV_EMISFA")
	_dVencto	:= CriaVar("PAV_VENCFA")
	_nDesconto	:= 0
	_nAjuste	:= 0

	_nRetorno		:= 0
	_cAlias		:= "PAV"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a entrada de dados do arquivo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE Continua,nUsado:=0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader	  := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( _cAlias )
	While !EOF() .And. (x3_arquivo == _cAlias)
		IF (X3USO(x3_usado))// .AND. cNivel >= x3_nivel ) -->> EDSON HORNBERGER 12/08/2015
			nUsado++
			AADD(aHeader,{ TRIM(X3Titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal, x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
		dbSkip()
	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols	:=	{}
	AADD(aCols,Array(Len(aHeader)+1))
	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If aHeader[i,8] == "C"
			aCols[1][i] := SPACE(aHeader[i,4])
		ELSEIF aHeader[i,8] == "N"
			aCols[1][i] := 0
		ELSEIF aHeader[i,8] == "D"
			aCols[1][i] := dDataBase // + 30
		ELSEIF aHeader[i,8] == "M"
			aCols[1][i] := ""
		ELSE
			aCols[1][nUsado] := .F.
		Endif
		If aHeader[i,10] == "V"
			aCols[1][i] := CriaVar(cCampo)
		Endif
	Next i

	aCols[1][Len(aHeader)+1] := .F.
	AADD(aObjects,{100,020,.T.,.F.,.F.})
	AADD(aObjects,{100,100,.T.,.T.,.F.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizacao das Variaveis e aCols                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	_nPosSer   :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_SERIE"})
	_nPosNF    :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_NF"})
	_nPosCto   :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_CTO"})
	_nPosFrTra :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_FRETRA"})
	_nPosFrCal :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_FRCALC"})
	_nPosTxCto :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_TXACTO"})
	_nPosVlPed :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_VLRPED"})
	_nPosOtrTx :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_OTRTXA"})
	_nPosVlGri :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_VLGRIS"})
	_nPosAdVal :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_ADVALO"})
	_nPosVlPes :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_VLPESO"})
	_nPosAdPes :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_ADPESO"})
	_nPosTxPes :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_TXPESO"})
	_nPosFrTol :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_FRETOL"})
	_nPosFrDes :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_DESCON"})
	_nPosCont  :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_CONT"})
	_nPosSeqCo :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_SEQCON"})
	_nPosEmiCo :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_EMICTO"})
	_nPosCliFor:=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_CLIFOR"})
	_nPoscgc   :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_CGCFOR"})
	_nPosTipo  :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_TIPO"})
	_nPosAcer  :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_ANCONF"})
	_nPosTDE   :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_VLTED"})
	_nPosTRT   :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_VLTRT"})
	_nPosPesoCub:=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_PESOCU"})
	_nPosVlAjus:=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_AJUST"})
	_nPosObsAju:=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_OBSAJU"})
	_nPosAprova:=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_APROVA"})
	_nPosLoja  :=   ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_LOJA"})
	_nPosChvNFe :=  ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_CHVNFE"}) // 20130328

	_nPosSerCto :=  IIf(_lSerieCTo, ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_SERCTO"}), 0) // 20130328

	_cNomeTra := " "

	If _cOperacao == "I" // Inclusao
		nOPC	   := 3
	Endif

	_nDesconto	:= 0
	_nAjuste	:= 0
	_laCols		:= .F.

	If _cOperacao $ "I/A/V/E"
		If _cOperacao $ "V/E"
			nOPC	   := 2 // Visualizacao ou Exclusao
		Endif
		If _cOperacao == "A"
			nOPC	   := 3 // Alteracao
		Endif

		if !lAutoConF
			if _cOperacao <> "I"
				_cNomeTra := Posicione("SA4",1,xFilial("SA4")+PAV->PAV_CODTRA,"A4_NOME")
				if _lFatura
					DbSelectArea("PAV")
					DbSetOrder(1)
					DbSeek(xFilial("PAV")+PAV->PAV_FATURA+PAV->PAV_CODTRA,.F.)
				else
					DbSelectArea("PAV")
					DbSetOrder(2)
					DbSeek(xFilial("PAV")+PAV->PAV_CTO+PAV->PAV_CODTRA,.F.)
				endif
				_cFatura 	:= PAV->PAV_FATURA
				_cTransp 	:= PAV->PAV_CODTRA
				_dEmissao	:= PAV->PAV_EMISFA
				_dVencto 	:= PAV->PAV_VENCFA
				_cTipo		:= PAV->PAV_TIPO
				_cCTO		:= PAV->PAV_CTO

				//Se alteração atualizo variaveis para bloqueio de alteração
				_cTraAlt := _cTransp
				_cFatAlt := _cFatura

				_nDesconto	:= 0
				_nAjuste	:= 0
				_laCols		:= .F.

				if _lFatura
					_cChave := 'PAV->PAV_FILIAL== xFilial("PAV") .AND. PAV->PAV_FATURA==_cFatura .AND. PAV->PAV_CODTRA == _cTransp'
				else
					_cChave := 'PAV->PAV_FILIAL== xFilial("PAV") .AND. PAV->PAV_CTO==_cCTO .AND. PAV->PAV_CODTRA == _cTransp'
				endif

				While ! Eof() .AND. &(_cChave)
					_nDesconto	:= _nDesconto + PAV->PAV_DESCON
					_nAjuste	:= _nAjuste + PAV->PAV_AJUST
					_nValor		:= _nValor + PAV->PAV_FRETRA
					If _laCols
						AADD(aCols,Array(Len(aHeader)+1))
					Endif
					_laCols := .T.
					For i :=1 to Len(aHeader)
						cCampo:=Alltrim(aHeader[i,2])
						If aHeader[i,10] # "V"
							aCols[Len(aCols)][i] := FieldGet(FieldPos(cCampo))
						Else
							aCols[Len(aCols)][i] := CriaVar(cCampo)
						Endif
					Next i
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
					dbSelectArea("PAV")
					dbSkip()
				Enddo
			endif
		else

			nPosCodTra := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_CODTRA"})
			if nPosCodTra > 0
				_cTransp   := aAutoCab[nPosCodTra][2]
			endif
			_cNomeTra := Posicione("SA4",1,xFilial("SA4")+_cTransp,"A4_NOME")
			nPosTipo := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_TIPO"})
			if nPosTipo > 0
				_cTipo   := aAutoCab[nPosTipo][2]
			endif
			nPosFatura := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_FATURA"})
			if nPosFatura > 0
				_cFatura   := aAutoCab[nPosFatura][2]
			endif
			nPosEmissao := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_EMISFA"})
			if nPosEmissao > 0
				_dEmissao   := aAutoCab[nPosEmissao][2]
			endif
			nPosVencto := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_VENCFA"})
			if nPosVencto > 0
				_dVencto   := aAutoCab[nPosVencto][2]
			endif
			nPosCTO := ASCAN(aAutoCab,{|x| Alltrim(x[1]) == "PAV_CTO"})
			if nPosCTO > 0
				_cCTO := aAutoCab[nPosCTO][2]
			endif

			//aAutoCab
			//aAutoItens

			if _cOperacao <> "I"
				//populando acols com os dados da matriz automatica
				if _lFatura
					DbSelectArea("PAV")
					DbSetOrder(1)
					DbSeek(xFilial("PAV")+_cFatura+_cTransp,.F.)
				else
					DbSelectArea("PAV")
					DbSetOrder(2)
					DbSeek(xFilial("PAV")+_cCTO+_cTransp,.F.)
				endif

				//Se alteração atualizo variaveis para bloqueio de alteração
				_cTraAlt := _cTransp
				_cFatAlt := _cFatura

				_nDesconto	:= 0
				_nAjuste	:= 0
				_laCols		:= .F.

				if _lFatura
					_cChave := 'PAV->PAV_FILIAL== xFilial("PAV") .AND. PAV->PAV_FATURA==_cFatura .AND. PAV->PAV_CODTRA == _cTransp'
				else
					_cChave := 'PAV->PAV_FILIAL== xFilial("PAV") .AND. PAV->PAV_CTO==_cCTO .AND. PAV->PAV_CODTRA == _cTransp'
				endif

				//Tratamento para alteração
				//Localizo o que tem no banco, populo, depois vejo no arrey o que deve se mudar com o numero do conhecimento + nota fiscal - Nao implementado ainda no execauto
				While ! Eof() .AND. &(_cChave)
					_nDesconto	:= _nDesconto + PAV->PAV_DESCON
					_nAjuste	:= _nAjuste + PAV->PAV_AJUST
					_nValor		:= _nValor + PAV->PAV_FRETRA
					If _laCols
						AADD(aCols,Array(Len(aHeader)+1))
					Endif
					_laCols := .T.
					For i :=1 to Len(aHeader)
						cCampo:=Alltrim(aHeader[i,2])
						If aHeader[i,10] # "V"
							aCols[Len(aCols)][i] := FieldGet(FieldPos(cCampo))
						Else
							aCols[Len(aCols)][i] := CriaVar(cCampo)
						Endif
					Next i
					aCols[Len(aCols)][Len(aHeader)+1] := .F.
					dbSelectArea("PAV")
					dbSkip()
				Enddo
			else
				//Preenchendo Veiculos
				aCols := {}
				for nLoop := 1 to Len(aAutoItens)
					Aadd(aCols,Array(Len(aHeader) + 1))
					for nI := 1 to Len(aAutoItens[nLoop])
						_nPosH := aScan(aHeader,{|x| Trim(x[2])==aAutoItens[nLoop][nI][1]}) // Mudanca da Variavel nPos para _nPosH e declaracao da mesma
						if _nPosH > 0
							aCols[Len(aCols)][_nPosH]	:= aAutoItens[nLoop][nI][2]
							&("M->"+aHeader[_nPosH,2]):= aAutoItens[nLoop][nI][2]
							//Executo Validacoes de campo
							n := Len(aCols)
							U_FIELDFREOK(alltrim("M->"+aHeader[_nPosH][2]),.F.)
							If ExistTrigger(aHeader[_nPosH][2])
								n := nI
								RunTrigger(2,n,Nil,,aHeader[_nPosH][2])
							Endif
						endif
					Next
					For nI := 1 to len(aHeader)
						cCampo := alltrim(aHeader[nI][2])
						if aCols[Len(aCols)][nI] == Nil
							aCols[Len(aCols)][nI] := CriaVar(cCampo)
							&("M->"+cCampo):= aCols[Len(aCols)][nI]
							//Executo Validacoes de campo
							n := Len(aCols)
							U_FIELDFREOK(alltrim("M->"+aHeader[nI][2]),.F.)
							If ExistTrigger(aHeader[nI][2])
								n := nI
								RunTrigger(2,n,Nil,,aHeader[nI][2])
							Endif
						endif
					Next

					aCols[Len(aCols)][Len(aHeader) + 1]	:= .F.
				Next
			endif

		endif
	Endif

	if !lAutoConF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da Tela                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	/*
	|---------------------------------------------------------------------------------
	|	Alterado o posicionamento do MsGetDados - Edson Hornberger 07/05/2014
	|---------------------------------------------------------------------------------
	*/

		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Inclusao de Conhecimentos de Frete") OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]
		//Define MsDialog oDlg Title OemToAnsi("Inclusao de Conhecimentos de Frete") From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel

		nLd := 2.5 // Variavel implementada para o PROTHEUS 12
		@ (1.1*nLd),1 	SAY "Transportador "
		@ (1.1*nLd),7 	MSGET _cTransp  F3 "SA4"  VALID VERTRANSP()
		//@ 1.1,12 	SAY " - "+_cNomeTra+"*"
		@ (1.1*nLd),13 	MSGET _cNomeTra Size 120,8 WHEN .F.
		@ (1.1*nLd),32 	SAY "Tipo - "

		If _cOperacao == "I"
			@ (1.1*nLd),34    ComboBox _cTipo Items _aCombo Size 050,10 of oDlg
		Else
			_cDesTp := ' '
			For _nTp := 1 To Len(_aCombo)
				If Left(_aCombo[_nTp],1) == _cTipo
					_cDesTp	:= _aCombo[_nTp]
				Endif
			Next
			@ (1.1*nLd),34 SAY   _cDesTp
		Endif

		//@ 1.1,40 	SAY "Cgc Transp "
		//@ 1.1,45 	MSGET _cCgcTra  Picture "@R 99.999.999/9999-99"

		@ (1.6*nLd),1		SAY "Fatura "
		@ (1.6*nLd),5 	MSGET _cFatura VALID VERFAT() of oDlg WHEN _lFatura
		@ (1.6*nLd),13	SAY	"Emissao "
		@ (1.6*nLd),16	MSGET _dEmissao VALID _dEmissao <= dDatabase of oDlg WHEN _lFatura
		@ (1.6*nLd),22	SAY	"Vencimento "
		@ (1.6*nLd),26	MSGET _dVencto VALID _dVencto >= dDatabase .AND. _dVencto >= _dEmissao of oDlg WHEN _lFatura
		@ (1.6*nLd),32	SAY	"Valor "
		@ (1.6*nLd),34	MSGET _nValor Picture "@E 999,999.99" of oDlg WHEN _lFatura
		@ (1.6*nLd),41 	SAY	"Desconto "
		@ (1.6*nLd),45 	MSGET oDescon Var _nDesconto Picture "@E 999,999.99" of oDlg WHEN _lFatura
		@ (1.6*nLd),52 	SAY	"Ajuste "
		@ (1.6*nLd),56 	MSGET oAjuste Var _nAjuste Picture "@E 999,999.99" of oDlg WHEN _lFatura

		aPosObj:=MsObjSize(aInfo,aObjects)
		oGet := MSGetDados():New(aPosObj[2,1] + 20.0,aPosObj[2,2],aPosObj[2,3] - 10.0,aPosObj[2,4],nOpc,"U_LINFREOK()","U_TUDOFREOK()","",.T.,,,.T.,800,"U_FIELDFREOK()","U_SUPERDELFRE()",,"U_DELFRE()", oDlg)

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||IIF(oGet:TudoOK(),(oDlg:End(),_nRetorno:=1),_nRetorno := 0)},{||oDlg:End()},,_aButtons)
	else
		lErro := .F.
		//Validação dos campos
		For nI := 1 to len(aCols)
			n := nI
			if !lErro
				For nX := 1 to len(aHeader)
					cCampo := aHeader[nX][2]
					&("M->"+cCampo):= aCols[n][nX]
					if !U_FIELDFREOK(alltrim("M->"+aHeader[nX][2]))
						lErro := .T.
						Exit
					endif
					if !lErro
						If ExistTrigger(aHeader[nX][2])
							n := nI
							RunTrigger(2,n,Nil,,aHeader[nX][2])
						Endif
					Endif
				Next
			Endif
		Next
		//Validação das linhas
		For nI := 1 to len(aCols)
			if !lErro
				//Validando todos os campos da grid
				n := nI
				If !U_LINFREOK()
					lErro := .T.
					Exit
				endif
			endif
		Next
		_nRetorno := iif(!lErro,1,0)

	endif

Return _nRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FRINC    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao De Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FRINC()

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())

	Private aCols	:={}
	Private aHeader :={}

	If MontaTela("I","F") == 1
		fGravaPAV(.T.,.F.,.F.,"F")
	Endif

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FRVISUAL ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao De Conhecimentos de Frete                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function FRVISUAL()
	Local _aArea := GetArea()
	MontaTela("V","F")
	RestArea(_aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FRALT    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Alteracao De Conhecimentos de Frete                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FRALT()

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())

	Private aCols	:={}
	Private aHeader :={}

	_lLiber	:= JaLiberada(PAV->PAV_FATURA,PAV->PAV_CODTRA)
	If _lLiber
		Aviso("ATENCAO","Fatura ja Esta Liberada , Estorne a Liberacao ",{"OK"},3,"Alteracao Nao permitida ")
		Return
	Endif

	_lAltera := .T.
	If MontaTela("A","F") == 1
		fGravaPAV(.F.,.F.,.T.,"F")
	Endif
	_lAltera := .F.

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FREXC    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclusao De Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FREXC()

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())
	Private aCols	:={}
	Private aHeader :={}

	_lLiber	:= JaLiberada(PAV->PAV_FATURA,PAV->PAV_CODTRA)
	If _lLiber
		Aviso("ATENCAO","Fatura ja Esta Liberada , Estorne a Liberacao ",{"OK"},3,"Exclusao Nao permitida")
		Return
	Endif
	If MontaTela("E","F") == 1
		If MsgYesno("Confirma a exclusao ?","Exclusao de fatura de Frete")
			fGravaPAV(.F.,.T.,.F.,"F")
		Endif
	Endif

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LINFREOK ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao Linha de Conhecimento de Frete                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LINFREOK()

	Local nI
	Local _nElem := 0

//Verifico se se trata de conhecimento repetido para zerar as linhas e acrescentar os dados no total da primeira nota
	_cCTO := aCols[n,_nPosCto]


	_nValBrut  := 0
	_nNotas    := 0
	_aNotas    := {}
	_nRec1NF   := 0
	_nPesProd  := 0
	_nCPesProdC := 0
	_lPesoCub  := .F.
	_nValPesoC := 0
	_nValTrans := 0
	_nVlAjus   := 0
	_nVlDesc   := 0
	_nTIGris   := _nTIAdValor  := _nTITaxaCto  := _nTIValPeda  := _nTIOtrTaxa  := _nTIFrePeso := 0
	_nPIGris   := _nPIAdValor  := _nPITaxaCto  := _nPIValPeda  := _nPIOtrTaxa  := _nPIFrePeso := 0

	For nI := 1 to Len(aCols)
		if _cCTO == aCols[nI,_nPosCto]
			_cNF    := aCols[nI,_nPosNF]
			_cSerie := aCols[nI,_nPosSer]

			if aCols[nI,_nPosPesoCub] <> 1 .AND. aCols[nI,_nPosPesoCub] > 1
				_nValPesoC  += aCols[nI,_nPosPesoCub]
			endif
			_nValTrans  += aCols[nI,_nPosFrTra]

			//Valores importados
			_nTIGris     += aCols[nI,GDFIELDPOS("PAV_IVLGRI",aHEADER)]
			_nTIAdValor  += aCols[nI,GDFIELDPOS("PAV_IADVAL",aHEADER)]
			_nTITaxaCto  += aCols[nI,GDFIELDPOS("PAV_ITXACT",aHEADER)]
			_nTIValPeda  += aCols[nI,GDFIELDPOS("PAV_IVLRPE",aHEADER)]
			_nTIOtrTaxa  += aCols[nI,GDFIELDPOS("PAV_IOTRTX",aHEADER)]
			_nTIFrePeso  += aCols[nI,GDFIELDPOS("PAV_IVLPES",aHEADER)]

			_nPIGris     += aCols[nI,GDFIELDPOS("PAV_IVLGRI",aHEADER)]
			_nPIAdValor  += aCols[nI,GDFIELDPOS("PAV_IADVAL",aHEADER)]
			_nPITaxaCto  += aCols[nI,GDFIELDPOS("PAV_ITXACT",aHEADER)]
			_nPIValPeda  += aCols[nI,GDFIELDPOS("PAV_IVLRPE",aHEADER)]
			_nPIOtrTaxa  += aCols[nI,GDFIELDPOS("PAV_IOTRTX",aHEADER)]
			_nPIFrePeso  += aCols[nI,GDFIELDPOS("PAV_IVLPES",aHEADER)]

			DbSelectArea("SF2")
			DbSetOrder(1)
			if DbSeek(xFilial("SF2")+_cNf+_cSerie)
				_nNotas++
				aadd(_aNotas,{_cNf,_cSerie,nI,SF2->F2_VALBRUT})

				_nValBrut	:= _nValBrut  + SF2->F2_VALBRUT
				_nPesProd   := _nPesProd  + SF2->F2_PBRUTO
				_nCPesProdC  := _nCPesProdC + SF2->F2_PESOCUB

				if _nRec1NF == 0
					_nRec1NF := SF2->(RECNO())
				endif
			endif
		endif
		_nVlAjus    += aCols[nI,_nPosVlAjus]
		_nVlDesc    += aCols[nI,_nPosFrDes]

	Next
	_nAjuste := _nVlAjus
	_nDesconto := _nVlDesc

	if _nNotas > 1
		_nPesProd := iif(_nCPesProdC>0,_nCPesProdC,_nPesProd)
		//Verificando se devo Ratear o Peso Cubagem e o Valor informado
		if _lAltValor
			If iif(lAutoConF,.T.,MsgYesno("O valor do conhecimento ou peso cubagem foram alterados, deseja ratear esses valores para todas as notas do conhecimento?","Multiplas Notas"))
				_lAltValor := .F.
				_nTTotPesoC  := aCols[_aNotas[1][3],_nPosPesoCub]
				_nTTotValTra := aCols[_aNotas[1][3],_nPosFrTra]
				_nValPesoC   := aCols[_aNotas[1][3],_nPosPesoCub]
				_nValTrans   := aCols[_aNotas[1][3],_nPosFrTra]

				For nI := 1 to Len(_aNotas)
					nPerTot := Round((_aNotas[nI][4] / _nValBrut),4)
					_nPesoC  := _nValPesoC*nPerTot
					_nVTrans := _nValTrans*nPerTot

					aCols[_aNotas[nI][3],_nPosPesoCub] := iif(len(_aNotas)>nI,_nPesoC ,_nTTotPesoC)
					aCols[_aNotas[nI][3],_nPosFrTra]   := iif(len(_aNotas)>nI,_nVTrans,_nTTotValTra)

					DbSelectArea("SF2")
					DbSetOrder(1)
					if DbSeek(xFilial("SF2")+_aNotas[nI][1]+_aNotas[nI][2])
						RecLock("SF2")
						SF2->F2_PESOCUB := aCols[_aNotas[nI][3],_nPosPesoCub]
						MsUnlock()
					Endif

					if nI < Len(_aNotas)
						_nTTotPesoC  -= _nPesoC
						_nTTotValTra -= _nVTrans
					endif
				Next
			endif

		else
			//Somo os valores para compror o Total e ratear em novas linhas
			_nTTotPesoC  := _nValPesoC
			_nTTotValTra := _nValTrans

			For nI := 1 to Len(_aNotas)
				nPerTot := Round((_aNotas[nI][4] / _nValBrut),4)
				_nPesoC  := _nValPesoC*nPerTot
				_nVTrans := _nValTrans*nPerTot

				aCols[_aNotas[nI][3],_nPosPesoCub] := iif(len(_aNotas)>nI,_nPesoC ,_nTTotPesoC)
				aCols[_aNotas[nI][3],_nPosFrTra]   := iif(len(_aNotas)>nI,_nVTrans,_nTTotValTra)

				DbSelectArea("SF2")
				DbSetOrder(1)
				if DbSeek(xFilial("SF2")+_cNf+_cSerie)
					RecLock("SF2")
					SF2->F2_PESOCUB := aCols[_aNotas[nI][3],_nPosPesoCub]
					MsUnlock()
				Endif

				if nI < Len(_aNotas)
					_nTTotPesoC  -= _nPesoC
					_nTTotValTra -= _nVTrans
				endif
			Next

		endif

		If _cTipo $ "V/N/R/E"
			DbSelectArea("SF2")
			DbSetOrder(3)
			DBGoTo(_nRec1NF)

			_cTpCalc := 'N'
			_lTDE    := .F.
			If SF2->F2_TIPO== 'B'
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA2->A2_CEP
				_cTpCalc := 'N'
			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA1->A1_CEP
				_lTDE   := SA1->A1_FRETED == "S"
			Endif

			// Averigua se trata-se de Redespacho
			_cEst	:= SF2->F2_EST
			If ! Empty(SF2->F2_REDESP)
				DbSelectArea("SA4")
				DbSetOrder(1)
				DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
				_cCep	:= SA4->A4_CEP
				_cEst	:= SA4->A4_EST
			Endif
			_aCalTrans := U_SeleFrete(_nValBrut,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,SF2->F2_EMISSAO,_lTDE,.T.)

			_nTTaxaCto  := _nTValPeda  := _nTOtrTaxa  := _nTGris     := _nTAdValor  := _nTFrePeso  := _nTAdvPeso  := 0
			_nTTxPeso   := _nTVlrFre   := _nTFreTone  := _nTVlrRent  := _nTVlrDev   := _nTVlrTDE   := _nTVlrTRT   := 0

			_nPTaxaCto  := _nPValPeda  := _nPOtrTaxa  := _nPGris     := _nPAdValor  := _nPFrePeso  := _nPAdvPeso  := 0
			_nPTxPeso   := _nPVlrFre   := _nPFreTone  := _nPVlrRent  := _nPVlrDev   := _nPVlrTDE   := _nPVlrTRT   := 0

			_cCont		:= Space(6)
			_cSeqCont   := Space(3)

			// Calculo do Frete
			// _aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,_nPesProd,SF2->F2_EST,SA1->A1_CEP,"F",SF2->F2_TRANSP,"ATU")
			// Conteudo do Array _aCalTrans
			// _aCalTrans[1][1]  	  // Transportador
			// _aCalTrans[1][2]  	  // Codigo do Contrato
			// _aCalTrans[1][3]  	  // Valores de Frete Calculado
			// _aCalTrans[1][3][1]    // Taxa Por Conhecimento
			// _aCalTrans[1][3][2]    // Valor do Pedagio
			// _aCalTrans[1][3][3]    // Outras Taxas
			// _aCalTrans[1][3][4]    // Valor do Gris
			// _aCalTrans[1][3][5]    // Valor do AdValorem
			// _aCalTrans[1][3][6]    // Valor do Frete Peso
			// _aCalTrans[1][3][7]    // Valor do AdValorem Quando Exceder o Peso
			// _aCalTrans[1][3][8]    // Valor da Taxa Quando Exceder o Peso
			// _aCalTrans[1][3][9]    // Valor  Total do Frete
			// _aCalTrans[1][3][10]   // Valor  Do Frete Por Tonelagem
			// _aCalTrans[1][4]  	  // Sequencia do Contrato
			For _nElem := 1 to Len(_aCalTrans)
				_cCont 	    := _aCalTrans[_nElem,2]
				_nTTaxaCto  := _aCalTrans[_nElem,3,01]
				_nTValPeda  := _aCalTrans[_nElem,3,02]
				_nTOtrTaxa  := _aCalTrans[_nElem,3,03]
				_nTGris     := _aCalTrans[_nElem,3,04]
				_nTAdValor  := _aCalTrans[_nElem,3,05]
				_nTFrePeso  := _aCalTrans[_nElem,3,06]
				_nTAdvPeso  := _aCalTrans[_nElem,3,07]
				_nTTxPeso   := _aCalTrans[_nElem,3,08]
				_nTVlrFre   := _aCalTrans[_nElem,3,09]
				_nTFreTone  := _aCalTrans[_nElem,3,10]
				_nTVlrRent  := _aCalTrans[_nElem,3,11]
				_nTVlrDev   := _aCalTrans[_nElem,3,12]
				_nTVlrTDE   := _aCalTrans[_nElem,3,13]
				_nTVlrTRT   := _aCalTrans[_nElem,3,14]
				_cSeqCont   := _aCalTrans[_nElem,4]

				_nPTaxaCto  := _aCalTrans[_nElem,3,01]
				_nPValPeda  := _aCalTrans[_nElem,3,02]
				_nPOtrTaxa  := _aCalTrans[_nElem,3,03]
				_nPGris     := _aCalTrans[_nElem,3,04]
				_nPAdValor  := _aCalTrans[_nElem,3,05]
				_nPFrePeso  := _aCalTrans[_nElem,3,06]
				_nPAdvPeso  := _aCalTrans[_nElem,3,07]
				_nPTxPeso   := _aCalTrans[_nElem,3,08]
				_nPVlrFre   := _aCalTrans[_nElem,3,09]
				_nPFreTone  := _aCalTrans[_nElem,3,10]
				_nPVlrRent  := _aCalTrans[_nElem,3,11]
				_nPVlrDev   := _aCalTrans[_nElem,3,12]
				_nPVlrTDE   := _aCalTrans[_nElem,3,13]
				_nPVlrTRT   := _aCalTrans[_nElem,3,14]

			Next _nElem
			For nI := 1 to len(_aNotas)
				nPerTot := Round((_aNotas[nI][4] / _nValBrut),4)

				_nTaxaCto  := Round(_nPTaxaCto*nPerTot,2)
				_nValPeda  := Round(_nPValPeda*nPerTot,2)
				_nOtrTaxa  := Round(_nPOtrTaxav*nPerTot,2)
				_nGris     := Round(_nPGris*nPerTot,2)
				_nAdValor  := Round(_nPAdValor*nPerTot,2)
				_nFrePeso  := Round(_nPFrePeso*nPerTot,2)
				_nAdvPeso  := Round(_nPAdvPeso*nPerTot,2)
				_nTxPeso   := Round(_nPTxPeso*nPerTot,2)
				_nVlrFre   := Round(_nPVlrFre*nPerTot,4)
				_nFreTone  := Round(_nPFreTone*nPerTot,2)
				_nVlrRent  := Round(_nPVlrRent*nPerTot,2)
				_nVlrDev   := Round(_nPVlrDev*nPerTot,2)
				_nVlrTDE   := Round(_nPVlrTDE*nPerTot,2)
				_nVlrTRT   := Round(_nPVlrTRT*nPerTot,2)

				_nIGris    := Round(_nPIGris*nPerTot,2)
				_nIAdValor := Round(_nPIAdValor*nPerTot,2)
				_nITaxaCto := Round(_nPITaxaCto*nPerTot,2)
				_nIValPeda := Round(_nPIValPeda*nPerTot,2)
				_nIOtrTaxa := Round(_nPIOtrTaxa*nPerTot,2)
				_nIFrePeso := Round(_nPIFrePeso*nPerTot,2)

				// Aplicar o Percentual para devolucoes ou reentrega
				If _cTipo $ "N/D" // Recusa / Devolução
					_nVlrFre	:= iif(len(_aNotas)>nI,_nVlrDev,_nTVlrDev)
				Endif
				If _cTipo == "R" // Reentrega
					_nVlrFre	:= iif(len(_aNotas)>nI,_nVlrRent,_nTVlrRent)
				Endif
				If aCols[_aNotas[nI][3],_nPosFrTra] == 0
					aCols[_aNotas[nI][3],_nPosFrTra] := iif(len(_aNotas)>nI,_nVlrFre,_nTVlrFre)
				Endif
				aCols[_aNotas[nI][3],_nPosFrCal] :=	iif(len(_aNotas)>nI,_nVlrFre,_nTVlrFre)
				aCols[_aNotas[nI][3],_nPosTxCto] :=	iif(len(_aNotas)>nI,_nTaxaCto,_nTTaxaCto)
				aCols[_aNotas[nI][3],_nPosVlPed] :=	iif(len(_aNotas)>nI,_nValPeda,_nTValPeda)
				aCols[_aNotas[nI][3],_nPosOtrTx] :=	iif(len(_aNotas)>nI,_nOtrTaxa,_nTOtrTaxa)
				aCols[_aNotas[nI][3],_nPosVlGri] :=	iif(len(_aNotas)>nI,_nGris,_nTGris)
				aCols[_aNotas[nI][3],_nPosAdVal] :=	iif(len(_aNotas)>nI,_nAdValor,_nTAdValor)
				aCols[_aNotas[nI][3],_nPosVlPes] :=	iif(len(_aNotas)>nI,_nFrePeso,_nTFrePeso)
				//aCols[n,_nPosAdPes] :=	_nAdvPeso
				aCols[_aNotas[nI][3],_nPosTxPes] :=	iif(len(_aNotas)>nI,_nTxPeso,_nTTxPeso)
				aCols[_aNotas[nI][3],_nPosFrTol] :=	iif(len(_aNotas)>nI,_nFreTone,_nTFreTone)
				aCols[_aNotas[nI][3],_nPosCont]  :=	_cCont

				aCols[_aNotas[nI][3],_nPosTDE] 	:=	iif(len(_aNotas)>nI,_nVlrTDE,_nTVlrTDE)
				aCols[_aNotas[nI][3],_nPosTRT] 	:=	iif(len(_aNotas)>nI,_nVlrTRT,_nTVlrTRT)

				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_IVLGRI",aHEADER)] :=	iif(len(_aNotas)>nI,_nIGris,_nTIGris)
				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_IADVAL",aHEADER)] :=	iif(len(_aNotas)>nI,_nIAdValor,_nTIAdValor)
				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_ITXACT",aHEADER)] :=	iif(len(_aNotas)>nI,_nITaxaCto,_nTITaxaCto)
				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_IVLRPE",aHEADER)] :=	iif(len(_aNotas)>nI,_nIValPeda,_nTIValPeda)
				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_IOTRTX",aHEADER)] :=	iif(len(_aNotas)>nI,_nIOtrTaxa,_nTIOtrTaxa)
				aCols[_aNotas[nI][3],GDFIELDPOS("PAV_IVLPES",aHEADER)] :=	iif(len(_aNotas)>nI,_nIFrePeso,_nTIFrePeso)

				aCols[_aNotas[nI][3],_nPosSeqCon]:= _cSeqCont
				aCols[_aNotas[nI][3],_nPosFrDes] := aCols[_aNotas[nI][3],_nPosFrTra] - aCols[_aNotas[nI][3],_nPosFrCal]

				if len(_aNotas)>nI
					_nTTaxaCto -= _nTaxaCto
					_nTValPeda -= _nValPeda
					_nTOtrTaxa -= _nOtrTaxa
					_nTGris    -= _nGris
					_nTAdValor -= _nAdValor
					_nTFrePeso -= _nFrePeso
					_nTAdvPeso -= _nAdvPeso
					_nTTxPeso  -= _nTxPeso
					_nTVlrFre  -= _nVlrFre
					_nTFreTone -= _nFreTone
					_nTVlrRent -= _nVlrRent
					_nTVlrDev  -= _nVlrDev
					_nTVlrTDE  -= _nVlrTDE
					_nTVlrTRT  -= _nVlrTRT

					_nTIGris    -= _nIGris
					_nTIAdValor -= _nIAdValor
					_nTITaxaCto -= _nITaxaCto
					_nTIValPeda -= _nIValPeda
					_nTIOtrTaxa -= _nIOtrTaxa
					_nTIFrePeso -= _nIFrePeso

				endif

			Next nI

		endif
	endif

	if !lAutoConF
		oDescon:Refresh()
		oAjuste:Refresh()
		oGet:Refresh()
		oDlg:Refresh()
	endif

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TUDOFREOK³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao Total para inclusao / Alteracao Cto. de Frete    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TUDOFREOK()
	Local _lRet
	Local _nVlTran := 0
	Local _nVlHal  := 0
	Local _nVlAjus := 0
	//Local _nVlDesc := 0
	Local _nX	   := 0

	_lFalCGC := .F.
	For _nX := 1 To Len(aCols)
		If !aCols[_nX,Len(aCols[_nX])]
			_nVlTran := _nVlTran + aCols[_nX,_nPosFrtra]
			_nVlHal  := _nVlHal  + aCols[_nX,_nPosFrCal]
			_nVlAjus := _nVlAjus + aCols[_nX,_nPosVlAjus]
			If _cTipo $ 'D/R/N/C'
				If Empty(aCols[_nX,_nPosCGC])
					MsgErro("Para Devolucoes, Compras, Reentregas ,Recusa,Transferencia e Outros deve Mencionar o CGC da Transportadora Emitente do Conhecimento","Cgc Invalido ")
					_lFalCGC	:= .T.
					Exit
				Endif
			Endif
		Endif
	Next

	if !lAutoConF
		_lRet := iif(lAutoConF,.T.,MsgYesno(" Valor Cobrado: "+TransForm(_nVltran,"@E 999,999.99")+Chr(13)+chr(10)+" Valor Calculado: "+TransForm(_nVlHal+_nVlAjus,"@E 999,999.99")+" Diferenca: "+TransForm(_nVlTran-(_nVlHal+_nVlAjus),"@E 999,999.99"),"Soma dos Conhecimentos"))
	else
		_lRet := .T.
	endif

	if _lFatura
		If Empty(_cTransp)
			MsgErro("Codigo do Transportador Nao Informado","Informacao Invalida")
			_lRet := .F.
		Endif
		If Empty(_cFatura)
			MsgErro("Numero da Fatura Nao Informada","Informacao Invalida")
			_lRet := .F.
		Endif
		If Empty(_dEmissao)
			MsgErro("Data da Emissao Nao Informada","Informacao Invalida")
			_lRet := .F.
		Endif
		If Empty(_dVencto)
			MsgErro("Data do Vencimento Nao Informada","Informacao Invalida")
			_lRet := .F.
		Endif
		if !lAutoConF
			If _nValor == 0
				MsgErro("Valor da Fatura nao Informado","Informacao Invalida")
				_lRet := .F.
			Endif
		Endif
	Endif

	If _lFalCgc
		MsgErro("Para Devolucoes, Reentregas ou Recusa deve Mencionar o CGC da Transportadora Emitente do Conhecimento","Cgc Invalido ")
		_lRet := .F.
	Endif

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIELDFREOK³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao Por Campo na inclusao / Alteracao Cto. de Frete   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FIELDFREOK(_FieldAuto,_lMsg)

	Local _aAreaAnt := GetArea()
	Local _lRet		   := .T.
	Local _cField
	Local _cConteudo
	Local _cSerie	   := aCols[n,_nPosSer]
	Local _cNF		   := aCols[n,_nPosNF]
	Local _cCTO		   := aCols[n,_nPosCTO]
	Local _cCliFor	   := aCols[n,_nPosCliFor]
	Local _cLojaFor	   := aCols[n,_nPosLoja]
	//Local _cChvNFe     := aCols[n,_nPosChvNFe] // 20130328
	Local _nPesoCub    := aCols[n,_nPosPesoCub]
	Local _nElem       := 0
	Local _cCep
	Local _cEst
	//Local _cPedido
	//Local _nFreTra	   := 0
	//Local _nFreSis	   := 0
	Local _lCtoSer     := AllTrim(GetSx3Cache("PAV_SERCTO", "X3_CAMPO")) == "PAV_SERCTO"
	Local _nElem1	   := 0

	DEFAULT _FieldAuto := ReadVar()
	DEFAULT _lMsg	   := .T.

	if len(alltrim(_cSerie)) == 0
		_cSerie := SuperGetMv("MV_XOCOSER",,"1  ")
	endif

	_cField	:= _FieldAuto
	_cConteudo:= &(_cField)
	_cTipo	:= Left(_cTipo,1)

	if _cField == "M->PAV_NF"
		if SuperGetMV("MV_XFRETNF",,.T.)
			M->PAV_NF := STRZERO(VAL(M->PAV_NF),TAMSX3("PAV_NF")[1])
			_cConteudo := &(_cField)
			aCols[n,_nPosNF] := _cConteudo
		endif
	endif

//Atualizando Cubagem
	if _cField == "M->PAV_PESOCU" // Peso Bubagem
		if !_lAltValor
			_lAltValor := !(aCols[n,_nPosPesoCub] == &(_cField))
		endif
		If _cTipo $ "V/N/R/E" // Venda, Recusa,Reentrega ou Envio Armazenagem
			DbSelectArea("SF2")
			DbSetOrder(1)
			If DbSeek(xFilial("SF2")+_cNF+_cSerie,.F.)
				If SF2->F2_PESOCUB <> _cConteudo
					If iif(lAutoConF,.T.,MsgYesno("Peso de Cubagem diferente da nota, deseja atualizar a nota fiscal? ","Peso Cubagem"))
						RecLock("SF2",.F.)
						SF2->F2_PESOCUB	:= _cConteudo
						MsUnlock()
					endif
				Endif
			Endif
		Elseif _cTipo $ "D"
			DbSelectArea("SF1")
			DbSetOrder(1)
			If DbSeek(xFilial("SF1")+_cNF+_cSerie+_cCliFor+_cLojaFor,.F.)
				If SF1->F1_PESOCUB <> _cConteudo
					If iif(lAutoConF,.T.,MsgYesno("Peso de Cubagem Diferente da nota, deseja atualizar a nota fiscal? ","Peso Cubagem"))
						RecLock("SF1",.F.)
						SF1->F1_PESOCUB	:= _cConteudo
						MsUnlock()
					endif
				Endif
			Endif
		Endif
	endif


	Do Case
	Case _cField == "M->PAV_NF" // Valida Numero da NF
		If _cTipo $ "V/N/R/E" // Venda, Recusa,Reentrega ou Envio Armazenagem
			DbSelectArea("SF2")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SF2")+_cConteudo+_cSerie,.F.)
				if _lMsg
					MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") - Não Encontrada, Verifique o Numero e Serie da NF","Nota Fiscal Nao encontrada")
				endif
				_lRet	:= .F.
			Else
				aCols[n,_nPosCliFor]:=	SF2->F2_CLIENTE
				aCols[n,_nPosLoja]  :=	SF2->F2_LOJA
				aCols[n,_nPosSer]	:=	_cSerie
			Endif

			If (SF2->F2_TRANSP == "000494" .and. _cTransp == "000800") .or. (_cTransp == "000494" .and. SF2->F2_TRANSP == "000800")

				_nStopHere := 1

			Else

				If SF2->F2_TRANSP <> _cTransp .AND. _lRet
					if _lMsg
						MsgErro("Coleta Nao foi efetuada por este transportador ("+_cTransp+") "+CRLF+"Transportador atual da coleta ("+SF2->F2_TRANSP+")","Coleta iconsistente")
					endif
					_lRet := .F.
				Endif

			EndIf

			If SF2->F2_PESOCUB > 0
				aCols[n,_nPosPesoCub]:=	SF2->F2_PESOCUB
			ENDIF
		ElseIf _cTipo $ "C/A/D" // Compras , Retorno de Armazenagem , Devolucao com Nf do Cliente Ou Transferencia
			_aFornec	:= SeleNF("C",_cConteudo,aCols[n,_nPosSer],aCols[n,_nPosCliFor],aCols[n,_nPosLoja])

			If Len(_aFornec) >= 1
				_cConteudo	         := _aFornec[1]
				_cSerie	             := _aFornec[2]
				_cFornece	         := _aFornec[3]
				_cLojaFor			 := _aFornec[4]
				_nPesoCub            := _aFornec[5]
				aCols[n,_nPosCliFor] :=	 _cFornece
				aCols[n,_nPosLoja]   :=	 _cLojaFor
				aCols[n,_nPosSer]    :=	 _cSerie
				aCols[n,_nPosNF]     :=	 _cConteudo
				if _nPesoCub > 0
					aCols[n,_nPosPesoCub]:= _nPesoCub
				endif
				&(_cField)           := _cConteudo
				// Atualizar o aCols com dados do Fornecedor, da serie e da Loja
				// Posiciona no SF1
				DbSelectArea("SF1")
				DbSetOrder(1)
				DbSeek(xFilial("SF1")+_cConteudo+_cSerie+_cFornece+_cLojaFor,.F.)
			Else
				_lRet := .F.
			Endif
		Endif
		If  _lRet .AND. _cTipo =='V'
			// Verifica se ja nao Houve cobranca da Nota Fiscal em Outra Fatura
			DbSelectArea("PAV")
			DbSetOrder(3)
			If DbSeek(xFilial("PAV") + _cConteudo + _cSerie)

				//Salva a chave de CTe caso o registro de PAV ja tenha sido gravado anteriormente
				If !Empty(AllTrim(aCols[n][_nPosChvNFe])) .and. _cOperacao $ "IA"

					If PAV->PAV_CODTRA == _cTransp .and. PAV->PAV_NF + PAV->PAV_SERIE == _cConteudo + _cSerie

						If Len(AllTrim(PAV->PAV_CHVNFE)) < 44 .or. Empty(AllTrim(PAV->PAV_CHVNFE))

							RecLock("PAV", .F.)

							PAV->PAV_CHVNFE := AllTrim(aCols[n][_nPosChvNFe])

							MSUnLock()

						EndIf

					EndIf

				EndIf

				//Verificando se for Execauto e for inclusao, verifico se registro ja existe na base
				if _cOperacao == "I" .AND. lAutoConF .AND. !_lFatura
					if _lMsg

						_cAdd := ""

						If StrZero(Val(PAV->PAV_CTO), TamSX3("PAV_CTO")[1]) <> StrZero(Val(_cCto), TamSX3("PAV_CTO")[1])

							_cAdd := " Com conhecimentos diferentes: " + StrZero(Val(PAV->PAV_CTO), TamSX3("PAV_CTO")[1]) + " no sistema e " +  StrZero(Val(_cCto), TamSX3("PAV_CTO")[1]) + " no arquivo atual."

						EndIf

						MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja lançada anteriormente!" + _cAdd," Nota ja digitada ")



					endif
					_lRet := .F.
				endif

				if _cOperacao == "I" .AND. lAutoConF .AND. _lFatura .AND. PAV->PAV_FATURA == _cFatura
					if _lMsg


						MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja lançada nesta fatura anteriormente!" ," Nota ja digitada ")

					endif
					_lRet := .F.
				endif

				if _lRet
					if _lFatura
						if _cOperacao == "I" .AND. PAV->PAV_FATURA <> _cFatura .AND. !Empty(PAV->PAV_FATURA)
							if _lMsg
								MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja cobrada na Fatura "+PAV->PAV_FATURA," Nota Ja digitada ")
							endif
							_lRet := .F.
						endif
					else
						if _cOperacao == "I" .AND. PAV->PAV_CTO <> _cCTO .AND. !Empty(PAV->PAV_CTO)
							if _lMsg
								if Empty(PAV->PAV_FATURA)
									MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja lançada no conhecimento "+PAV->PAV_CTO," Nota Ja digitada ")
								else
									MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja cobrada na Fatura "+PAV->PAV_FATURA," Nota Ja digitada ")
								endif
							endif
							_lRet := .F.
						endif
					endif
				Endif
			Endif
		Endif
		If _lRet
			// Verifica se Houve digitacao da NF no mesmo momento
			For _nElem1	:= 1 to Len(aCols)
				If _nElem1 == n
					Loop
				Endif
				_cNfDigi	:=	aCols[_nElem1,_nPosNF]
				If _cNfDigi	==	_cConteudo
					if _lMsg
						MsgErro("Nota Fiscal ("+_cConteudo+"/"+_cSerie+") ja Digitada Nesta Fatura "," Nota Ja digitada ")
					endif
					_lRet	:= .F.
				Endif
			Next
		Endif
	Case _cField == "M->PAV_SERIE" .AND. ! Empty(_cNF) // Valida Serie da Nota Fiscal
		If _cTipo $ "V/N/R/E" // Venda, Recusa,Reentrega ou Envio Armazenagem
			DbSelectArea("SF2")
			DbSetOrder(1)
			If ! DbSeek(xFilial("SF2")+_cNF+_cConteudo,.F.)
				if _lMsg
					MsgErro("Nota Fiscal ("+_cNF+"/"+_cConteudo+") - Não Encontrada, Verifique o Numero e Serie da NF","Nota Fiscal Nao encontrada")
				endif
				//_lRet	:= .T. // Temporario
//			ElseIf SF2->F2_TRANSP <> _cTransp

			Else

				If (SF2->F2_TRANSP == "000494" .and. _cTransp == "000800") .or. (_cTransp == "000494" .and. SF2->F2_TRANSP == "000800")

					_nStopHere := 1

				Else

					If SF2->F2_TRANSP <> _cTransp
						if _lMsg
							MsgErro("Coleta Nao foi efetuada por este transportador ("+_cTransp+") "+CRLF+"Transportador atual da coleta ("+SF2->F2_TRANSP+")","Coleta iconsistente")
						endif
						//_lRet := .T. // Temporario
					EndIf

				EndIf

			Endif

		Endif
	EndCase

/// Calcula Valor do Frete se o Valor nao tiver sido calculado na Saida da NF
	If _lRet .AND. _cField $ "M->PAV_NF/M->PAV_PESOCU" .AND. EMPTY(SF2->F2_NUMNEG) .AND. SF2->F2_TIPROMA <> 'S' // calcula apenas se Frete nao For negociado

		If _cTipo $ "V/N/R/E"
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
			_cTpCalc := 'N'
			_lTDE    := .F.
			If SF2->F2_TIPO== 'B'
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA2->A2_CEP
				_cTpCalc := 'N'
			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA1->A1_CEP
				_lTDE   := SA1->A1_FRETED == "S"
			Endif
			_nPesProd := iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO)
			// Averigua se trata-se de Redespacho
			_cEst	:= SF2->F2_EST
			If ! Empty(SF2->F2_REDESP)
				DbSelectArea("SA4")
				DbSetOrder(1)
				DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
				_cCep	:= SA4->A4_CEP
				_cEst	:= SA4->A4_EST
			Endif
			_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,SF2->F2_EMISSAO,_lTDE,.T.)
		ElseIf _cTipo $ "C/A/D"
		/*
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
		_nPesProd := 0
			While ! Eof() .AND. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)==;
		xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		DbSelectArea("SB1")
		DbSeek(xFilial("SB1")+SD1->D1_COD,.F.)
		_nPesCod	:=	0//SD1->D1_QTSEGUM
					If _cTipo $ "D/A/" // Pega peso Bruto do Produto Acabado
		_nPesCod := SD1->D1_QUANT * SB1->B1_PESO
				Endif
		_nPesProd := _nPesProd + _nPesCod
		DbSkip()
			Enddo
		*/
			_cTpCalc  := 'N'
			_nPesProd := iif(SF1->F1_PESOCUB>0,SF1->F1_PESOCUB,SF1->F1_PBRUTO)
			_lTDE   := .F.
			If _cTipo <>'D'
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
				_cEst	   :=	SA2->A2_EST
				_cCep	   := 	SA2->A2_CEP
				If _cTipo =='A'
					_cTpCalc := 'A'
				Endif

			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
				_cEst	   := SA1->A1_EST
				_cCep	   := SA1->A1_CEP
				_lTDE      := SA1->A1_FRETED == "S"
			Endif
			//Pergunte("CONFR1",.T.)
			//_nPesProd  := MV_PAR01
			aCols[n,_nPosAdPes] :=	_nPesProd
			_aCalTrans := U_SeleFrete(SF1->F1_VALBRUT,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,SF1->F1_DTDIGIT,_lTDE,.T.)
		Endif
		// Zera Conteudo das Colunas
		aCols[n,_nPosFrCal] :=	0
		aCols[n,_nPosTxCto] :=	0
		aCols[n,_nPosVlPed] :=	0
		aCols[n,_nPosOtrTx] :=	0
		aCols[n,_nPosVlGri] :=	0
		aCols[n,_nPosAdVal] :=	0
		aCols[n,_nPosVlPes] :=	0
		//aCols[n,_nPosAdPes] :=	0
		aCols[n,_nPosTxPes] :=	0
		aCols[n,_nPosFrTol] :=	0
		aCols[n,_nPosTDE  ] :=	0
		aCols[n,_nPosTRT  ] :=	0
		aCols[n,_nPosCont]  := "  "
		aCols[n,_nPosSeqCo] := "  "

		// Calculo do Frete
		// _aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,_nPesProd,SF2->F2_EST,SA1->A1_CEP,"F",SF2->F2_TRANSP,"ATU")
		// Conteudo do Array _aCalTrans
		// _aCalTrans[1][1]  	  // Transportador
		// _aCalTrans[1][2]  	  // Codigo do Contrato
		// _aCalTrans[1][3]  	  // Valores de Frete Calculado
		// _aCalTrans[1][3][1]    // Taxa Por Conhecimento
		// _aCalTrans[1][3][2]    // Valor do Pedagio
		// _aCalTrans[1][3][3]    // Outras Taxas
		// _aCalTrans[1][3][4]    // Valor do Gris
		// _aCalTrans[1][3][5]    // Valor do AdValorem
		// _aCalTrans[1][3][6]    // Valor do Frete Peso
		// _aCalTrans[1][3][7]    // Valor do AdValorem Quando Exceder o Peso
		// _aCalTrans[1][3][8]    // Valor da Taxa Quando Exceder o Peso
		// _aCalTrans[1][3][9]    // Valor  Total do Frete
		// _aCalTrans[1][3][10]   // Valor  Do Frete Por Tonelagem
		// _aCalTrans[1][4]  	  // Sequencia do Contrato
		For _nElem := 1 to Len(_aCalTrans)
			_cCont 	   := _aCalTrans[_nElem,2]
			_nTaxaCto  := _aCalTrans[_nElem,3,01]
			_nValPeda  := _aCalTrans[_nElem,3,02]
			_nOtrTaxa  := _aCalTrans[_nElem,3,03]
			_nGris     := _aCalTrans[_nElem,3,04]
			_nAdValor  := _aCalTrans[_nElem,3,05]
			_nFrePeso  := _aCalTrans[_nElem,3,06]
			_nAdvPeso  := _aCalTrans[_nElem,3,07]
			_nTxPeso   := _aCalTrans[_nElem,3,08]
			_nVlrFre   := _aCalTrans[_nElem,3,09]
			_nFreTone  := _aCalTrans[_nElem,3,10]
			_nVlrRent  := _aCalTrans[_nElem,3,11]
			_nVlrDev   := _aCalTrans[_nElem,3,12]
			_nVlrTDE   := _aCalTrans[_nElem,3,13]
			_nVlrTRT   := _aCalTrans[_nElem,3,14]
			_cSeqCont  := _aCalTrans[_nElem,4]

			// Aplicar o Percentual para devolucoes ou reentrega
			If _cTipo $ "N/D" // Recusa / Devolução
				_nVlrFre	:= _nVlrDev
			Endif
			If _cTipo == "R" // Reentrega
				_nVlrFre	:= _nVlrRent
			Endif
			If aCols[n,_nPosFrTra] == 0
				aCols[n,_nPosFrTra] := _nVlrFre
			Endif
			aCols[n,_nPosFrCal] :=	_nVlrFre
			aCols[n,_nPosTxCto] :=	_nTaxaCto
			aCols[n,_nPosVlPed] :=	_nValPeda
			aCols[n,_nPosOtrTx] :=	_nOtrTaxa
			aCols[n,_nPosVlGri] :=	_nGris
			aCols[n,_nPosAdVal] :=	_nAdValor
			aCols[n,_nPosVlPes] :=	_nFrePeso
			//aCols[n,_nPosAdPes] :=	_nAdvPeso
			aCols[n,_nPosTxPes] :=	_nTxPeso
			aCols[n,_nPosFrTol] :=	_nFreTone
			aCols[n,_nPosCont] 	:=	_cCont

			aCols[n,_nPosTDE] 	:=	_nVlrTDE
			aCols[n,_nPosTRT] 	:=	_nVlrTRT

			aCols[n,_nPosSeqCon]:=	_cSeqCont
		Next
	Endif

// Calculo da Diferenca do Valor de Frete
	If _cField == "M->PAV_NF"
		If _cTipo $ "V/N/R/E"
			If !Empty(SF2->F2_NUMNEG) // Frete Negociado
				aCols[n,_nPosFrCal] := SF2->F2_VALCON
				aCols[n,_nPosTxCto] := 0
				aCols[n,_nPosVlPed] := 0
				aCols[n,_nPosOtrTx] := 0
				aCols[n,_nPosVlGri] := 0
				aCols[n,_nPosAdVal] := 0
				aCols[n,_nPosVlPes] := 0
				//aCols[n,_nPosAdPes] :=	0
				aCols[n,_nPosTxPes] := 0
				aCols[n,_nPosFrTol] :=	SF2->F2_VALCON
				aCols[n,_nPosCont] 	:= 0
				aCols[n,_nPosSeqCon]:= ' '
				aCols[n,_nPosCont]  := "  "

				aCols[n,_nPosTDE] 	:= 0
				aCols[n,_nPosTRT] 	:= 0
			Endif

			if aCols[n,_nPosFrDes] <> Nil
				_nDesconto:= _nDesconto - aCols[n,_nPosFrDes]
				aCols[n,_nPosFrDes] := aCols[n,_nPosFrTra] - aCols[n,_nPosFrCal]
				_nDesconto:= _nDesconto + aCols[n,_nPosFrDes]
			endif
			dlgRefresh(oDlg)
		endif
	Endif

	If _cField == "M->PAV_CTO"
		M->PAV_CTO := STRZERO(VAL(M->PAV_CTO),TAMSX3("PAV_CTO")[1])
		aCols[n,_nPosCTO] := M->PAV_CTO
	endif

	If _lCtoSer

		If _cField == "M->PAV_SERCTO"
			M->PAV_SERCTO := STRZERO(VAL(M->PAV_SERCTO),TAMSX3("PAV_SERCTO")[1])
			//aCols[n,_nPosCTO] := M->PAV_CTO
		EndIf

	EndIf

	If _cField == "M->PAV_FRETRA"
		if !_lAltValor
			_lAltValor := !(aCols[n,_nPosFrTra] == &(_cField))
		endif

		if aCols[n,_nPosFrDes] <> nil
			_nDesconto:= _nDesconto - aCols[n,_nPosFrDes]
			aCols[n,_nPosFrDes] := M->PAV_FRETRA - aCols[n,_nPosFrCal]
			_nDesconto:= _nDesconto + aCols[n,_nPosFrDes]

			if aCols[n,_nPosFrDes] <> 0
				If _cTipo $ "V/N/R/E"
					DbSelectArea("SD2")
					DbSetOrder(3)
					DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
					_cTpCalc := 'N'
					_lTDE    := .F.
					If SF2->F2_TIPO== 'B'
						DbSelectArea("SA2")
						DbSetOrder(1)
						DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
						_cCep	:= SA2->A2_CEP
						_cTpCalc := 'N'
					Else
						DbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
						_cCep	:= SA1->A1_CEP
						_lTDE   := SA1->A1_FRETED == "S"
					Endif
					_nPesProd := iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO)
					// Averigua se trata-se de Redespacho
					_cEst	:= SF2->F2_EST
					If ! Empty(SF2->F2_REDESP)
						DbSelectArea("SA4")
						DbSetOrder(1)
						DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
						_cCep	:= SA4->A4_CEP
						_cEst	:= SA4->A4_EST
					Endif
					_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,SF2->F2_EMISSAO,_lTDE,.T.)
				else
					DbSelectArea("SD1")
					DbSetOrder(3)
					DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
					_cTpCalc := 'N'
					_lTDE    := .F.
					If SF1->F1_TIPO<>'D'
						DbSelectArea("SA2")
						DbSetOrder(1)
						DbSeek(xFilial("SA2")+SF1->F1_CLIENTE+SF1->F1_LOJA,.F.)
						_cCep	:= SA2->A2_CEP
						_cTpCalc := 'N'
					Else
						DbSelectArea("SA1")
						DbSetOrder(1)
						DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
						_cCep	:= SA1->A1_CEP
						_lTDE   := SA1->A1_FRETED == "S"
					Endif
					_nPesProd := iif(SF1->F1_PESOCUB>0,SF1->F1_PESOCUB,SF1->F1_PBRUTO)
					// Averigua se trata-se de Redespacho
					_cEst	:= SF1->F1_EST
					_aCalTrans := U_SeleFrete(SF1->F1_VALBRUT,_nPesProd,_cEst,_cCep,_cTpCalc,_cTransp,SF1->F1_DTDIGIT,_lTDE,.T.)
				endif

				//Ajuste automatico se tabela permitir
				if Len(_aCalTrans) > 0
					if Abs((aCols[n,_nPosFrDes]/M->PAV_FRETRA))*100 <= _aCalTrans[1][8]
						aCols[n,_nPosVlAjus] := aCols[n,_nPosFrDes]
						aCols[n,_nPosObsAju] := "Ajuste automatico via tabela da transportadora"
						aCols[n,_nPosAprova] := "Automatico"
					endif
				endif
			endif
			dlgRefresh(oDlg)
		endif
	Endif

	If _cField == "M->PAV_ANCONF" // Efetua Acerto do frete de acordo com analise na conferencia do frete
		_nPosFrTra :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_FRETRA"})
		_nPosFrCal :=	ASCAN(aHeader,{|x| Alltrim(x[2]) == "PAV_FRCALC"})
		// Retira os valores Incluidos Anteriormente
		aCols[n,_nPosFrCal] := aCols[n,_nPosFrCal] - aCols[n,_nPosAcer]
		// Atualiza os Valores de Acordo com a Conferencia'
		aCols[n,_nPosFrCal] := aCols[n,_nPosFrCal] + M->PAV_ANCONF
		aCols[n,_nPosFrDes]  := aCols[n,_nPosFrTra] - aCols[n,_nPosFrCal]
		dlgRefresh(oDlg)
		//oDlg:Refresh()
	Endif

// Atualiza o Tipo da Modalidade de Frete
	aCols[n,_nPosTipo]:= _cTipo
	RestArea(_aAreaAnt)

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DELFRE    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao Na Exclusap da Linha do conhecimento de frete     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function DELFRE()

//MsgInfo("APAGA ","VALIDADOR DELECAO DA LINHA")

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERTRANSP ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Localizacao do Transportador                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerTransp()
	DbSelectArea("SA4")
	DbSetOrder(1)
	_lRetorno := .T.
	If _lAltera
		if _cTraAlt <> _cTransp
			MsgErro("Codigo do Transportador Nao Pode Ser Alterado")
			_lRetorno := .F.
		endif
	Else
		If !Dbseek(xFilial("SA4")+_cTransp,.F.)
			MsgErro("Transportador Nao Cadastrado")
			_lRetorno := .F.
		else
			_cNomeTra := SA4->A4_NOME
		Endif
	Endif
Return(_lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERFAT    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 04/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se Fatura ja Esta Digitada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VerFAT()
	DbSelectArea("PAV")
	DbSetOrder(1)
	_cFatura  := StrZero(Val(_cFatura),TAMSX3("PAV_FATURA")[1])
	_lRetorno := .T.
	If _lAltera
		if _cFatAlt <> _cFatura
			MsgErro("Numero da Fatura Nao Pode Ser Alterada")
			_lRetorno := .F.
		endif
	Else
		If Dbseek(xFilial("PAV")+_cFatura+_cTransp,.F.)
			MsgErro("Fatura ja Digitada Para Este Transportador")
			_lRetorno := .F.
		Endif
	Endif
Return(_lRetorno)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FGRAVAPAV ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao Conhecimento de Frete                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGravaPAV(_lInclui,_lExclui,_lAltera,_Operacao)

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())
	Local nMaxArray := Len(aCols)
	Local ny := 0
	Local nx := 0

	If _lInclui == NIL
		_lInclui := .F.
	Endif
	If _lExclui == NIL
		_lExclui := .F.
	Endif
	If _lAltera == NIL
		_lAltera := .F.
	Endif
	If _Operacao == NIL
		_Operacao := "F"
	Endif

	If _lInclui   // INCLUSAO
		For nx := 1 to nMaxArray
			If !aCols[nx][Len(aCols[nx])]
				//Acrescentando busca pela NF/Conhecimento, pois pode ser um conhecimento avulso, e noa deve ser criado novamente, somente atualizado o registro
				DBSelectArea("PAV")
//			DBSetOrder(3)
//			if DBSeek(xFilial("PAV")+aCOLS[nX,GDFIELDPOS("PAV_NF",aHEADER)]+aCOLS[nX,GDFIELDPOS("PAV_SERIE",aHEADER)]+aCOLS[nX,GDFIELDPOS("PAV_CTO",aHEADER)])

				//Substituicao do Indice 3 pelo indice 5 para evitar conflito de numeracao de conhecimentos numa mesma transportadora // 15/03/2013
				DBSetOrder(5)
				if DBSeek(xFilial("PAV")+aCOLS[nX,GDFIELDPOS("PAV_NF",aHEADER)]+aCOLS[nX,GDFIELDPOS("PAV_SERIE",aHEADER)] + aCOLS[nX,GDFIELDPOS("PAV_CTO",aHEADER)]  + _cTransp)
					RecLock("PAV",.F.)
				else
					RecLock("PAV",.T.)
				endif
				For ny := 1 to Len(aHeader)
					If aHeader[ny][10] # "V"
						xVar := Trim(aHeader[ny][2])
						Replace &xVar. With aCols[nx][ny]
					Endif
				Next ny
				PAV->PAV_FILIAL := xFilial("PAV")
				PAV->PAV_FATURA := _cFatura
				PAV->PAV_CODTRA	:= _cTransp
				PAV->PAV_EMISFA := _dEmissao
				PAV->PAV_VENCFA := _dVencto
				MsUnlock()

				If _cTipo =='V'
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DBSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)
						RecLock("SF2",.F.)
						SF2->F2_CONHECI := PAV->PAV_CTO
						SF2->F2_FATURA  := PAV->PAV_FATURA
						SF2->F2_VALCON  := PAV->PAV_FRETRA
						SF2->F2_DTCON   := dDataBase
						MsUnlock()
					Endif
				ElseIf _cTipo $ 'C/A/D'
					DbSelectArea("SF1")
					DbSetOrder(1)
					If DBSeek(xFilial("SF1")+PAV->PAV_NF+PAV->PAV_SERIE+PAV->PAV_CLIFOR+PAV->PAV_LOJA,.F.)
						RecLock("SF1",.F.)
						SF1->F1_CONHECI := PAV->PAV_CTO
						SF1->F1_XFATFRE := PAV->PAV_FATURA
						SF1->F1_VALCON  := PAV->PAV_FRETRA
						SF1->F1_DTCON   := dDataBase
						MsUnlock()
					Endif
				Endif
			Endif
			DbSelectArea("PAV")
		Next nx
	Endif

	If _lAltera  // Alteracao
		For nx := 1 to nMaxArray
			_cCto	:= aCols[nx,_nPosCto]
			_cNF	:= aCols[nx,_nPosNf]
			If !aCols[nx][Len(aCols[nx])]
			/*
			DbSelectArea("PAV")
			DbSetOrder(2)  // Conhecimento + Transportador + Fatura + Nota Fiscal
				If DbSeek(xFilial("PAV") + _cCto + _cTransp + _cFatura+_cNf,.F.)
			RecLock("PAV",.F.)
				Else
			RecLock("PAV",.T.)
				Endif
			*/
				DBSelectArea("PAV")
//			DBSetOrder(3)
//			if DBSeek(xFilial("PAV")+aCOLS[nX,GDFIELDPOS("PAV_NF",aHEADER)]+aCOLS[nX,GDFIELDPOS("PAV_SERIE",aHEADER)]+aCOLS[nX,GDFIELDPOS("PAV_CTO",aHEADER)])

				DBSetOrder(5)  // Ajustado para evitar tratar a possibilidade de mesma numeracao de Conhecimento para transportadoras distintas.
				If DBSeek(xFilial("PAV") + aCOLS[nX, GDFIELDPOS("PAV_NF", aHEADER)] + aCOLS[nX, GDFIELDPOS("PAV_SERIE", aHEADER)] + aCOLS[nX, GDFIELDPOS("PAV_CTO", aHEADER)] + _cTransp )
					RecLock("PAV",.F.)
				else
					RecLock("PAV",.T.)
				endif

				For ny := 1 to Len(aHeader)
					If aHeader[ny][10] # "V"
						xVar := Trim(aHeader[ny][2])
						Replace &xVar. With aCols[nx][ny]
					Endif
				Next ny
				PAV->PAV_FILIAL := xFilial("PAV")
				PAV->PAV_FATURA := _cFatura
				PAV->PAV_CODTRA	:= _cTransp
				PAV->PAV_EMISFA := _dEmissao
				PAV->PAV_VENCFA := _dVencto
				MsUnlock()

				If _cTipo =='V'
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DBSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)
						RecLock("SF2",.F.)
						SF2->F2_CONHECI := PAV->PAV_CTO
						SF2->F2_FATURA  := PAV->PAV_FATURA
						SF2->F2_VALCON  := PAV->PAV_FRETRA
						SF2->F2_DTCON   := dDataBase
						MsUnlock()
					Endif
				ElseIf _cTipo  $'C/D/A'
					DbSelectArea("SF1")
					DbSetOrder(1)
					If DBSeek(xFilial("SF1")+PAV->PAV_NF+PAV->PAV_SERIE+PAV->PAV_CLIFOR+PAV->PAV_LOJA,.F.)
						RecLock("SF1",.F.)
						SF1->F1_CONHECI := PAV->PAV_CTO
						SF1->F1_XFATFRE := PAV->PAV_FATURA
						SF1->F1_VALCON  := PAV->PAV_FRETRA
						SF1->F1_DTCON   := dDataBase
						MsUnlock()
					Endif
				Endif
				DbSelectArea("PAV")
			Else
				DbSelectArea("PAV")
				DbSetOrder(2)  // Conhecimento + Transportador + Fatura + NF
				If DbSeek(xFilial("PAV") + _cCto + _cTransp + _cFatura+_cNf,.F.)
					//verifico se foi importado via EDI, Se sim nao excluo o documento quando for exclusao de fatura, somente se for exclusao do conhecimento
					if (_Operacao == "C") .OR. (_Operacao == "F" .AND. PAV->PAV_IMPORT=="N")
						If _cTipo == 'V'
							DbSelectArea("SF2")
							DbSetOrder(1)
							If DBSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)
								RecLock("SF2",.F.)
								SF2->F2_CONHECI := ""
								SF2->F2_FATURA  := ""
								SF2->F2_DTCON   := Ctod("")
								MsUnlock()
							Endif
						ElseIf _cTipo $ "C/D/A"
							DbSelectArea("SF1")
							DbSetOrder(1)
							If DBSeek(xFilial("SF1")+PAV->PAV_NF+PAV->PAV_SERIE+PAV->PAV_CLIFOR+PAV->PAV_LOJA,.F.)
								RecLock("SF1",.F.)
								SF1->F1_CONHECI := ""
								SF1->F1_XFATFRE := ""
								SF1->F1_VALCON  := 0
								SF1->F1_DTCON   := Ctod("")
								MsUnlock()
							Endif
						Endif
						DbSelectArea("PAV")
						RecLock("PAV",.F.)
						DbDelete()
						msUnlock()
					else
						DbSelectArea("PAV")
						RecLock("PAV",.F.)
						PAV->PAV_FATURA := ""
						PAV->PAV_EMISFA := CTOD("")
						PAV->PAV_VENCFA := CTOD("")
						msUnlock()
					endif
				Endif
			Endif
		Next nx
	Endif

	If _lExclui  // Exclusao
		For nx := 1 to nMaxArray
			_cCto	:= aCols[nx,_nPosCto]
			_cNF	:= aCols[nx,_nPosNf]
			DbSelectArea("PAV")
			DbSetOrder(2)  // Conhecimento + Transportador + Fatura+ nf
			If DbSeek(xFilial("PAV") + _cCto + _cTransp + _cFatura+_cNf,.F.)
				//verifico se foi importado via EDI, Se sim nao excluo o documento quando for exclusao de fatura, somente se for exclusao do conhecimento
				if (_Operacao == "C") .OR. (_Operacao == "F" .AND. PAV->PAV_IMPORT=="N")
					If _cTipo == 'V'
						DbSelectArea("SF2")
						DbSetOrder(1)
						If DBSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)
							RecLock("SF2",.F.)
							SF2->F2_CONHECI := ""
							SF2->F2_FATURA  := ""
							SF2->F2_DTCON   := Ctod("")
							MsUnlock()
						Endif
					ElseIf _cTipo $ "C/D/A"
						DbSelectArea("SF1")
						DbSetOrder(1)
						If DBSeek(xFilial("SF1")+PAV->PAV_NF+PAV->PAV_SERIE+PAV->PAV_CLIFOR+PAV->PAV_LOJA,.F.)
							RecLock("SF1",.F.)
							SF1->F1_CONHECI := ''
							SF1->F1_XFATFRE := ''
							SF1->F1_VALCON  := 0
							SF1->F1_DTCON   := Ctod(" ")
							MsUnlock()
						Endif
					Endif
					DbSelectArea("PAV")
					RecLock("PAV",.F.)
					DbDelete()
					msUnlock()
				else
					DbSelectArea("PAV")
					RecLock("PAV",.F.)
					PAV->PAV_FATURA := ""
					PAV->PAV_EMISFA := CTOD("")
					PAV->PAV_VENCFA := CTOD("")
					msUnlock()
				endif
			Endif
		Next nx
	Endif

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONSNF    ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualiza a Nota Fiscal de Saida                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CONSNF()

	Local _aArea	:= GetArea()
	Local _cSerie	:= aCols[n,_nPosSer]
	Local _cNF		:= aCols[n,_nPosNF]
	Local _cCliFor	:= aCols[n,_nPosCliFor]
	Local _cLojaFor := aCols[n,_nPosLoja]

	If _cTipo $ "V/N/R/E"
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2")+_cNF+_cSerie)
			Mc090Visual()  // Visualizacao Nota Fiscal
		Endif
	else
		DbSelectArea("SF1")
		DbSetOrder(1)
		If DbSeek(xFilial("SF1")+_cNF+_cSerie+_cCliFor+_cLojaFor)
			A103NFiscal("SF1",SF1->(RECNO()),2)
		Endif
	endif
	RestArea(_aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESUNOTA  ³ Autor ³ Eduardo Barbosa       ³ Data ³ 22/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Resumo da Nota Fiscal                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function RESUNOTA()

	Local _aArea	:= GetArea()
	Local _cSerie	:= aCols[n,_nPosSer]
	Local _cNF		:= aCols[n,_nPosNF]
	Local _cCliFor	:= aCols[n,_nPosCliFor]
	Local _cLojaFor	:= aCols[n,_nPosLoja]
	Local _cCont	:= aCols[n,_nPosCont]
	Local _cSeqCont	:= aCols[n,_nPosSeqCo]
	Private _cTDE   := "Nao"


	If _cTipo $ "V/N/R" // Venda Recusa ou Reentrega
		DbSelectArea("SF2")
		DbSetOrder(1)
		If ! DbSeek(xFilial("SF2")+_cNF+_cSerie,.F.)
			Return
		Endif
		_nValBrut	:= SF2->F2_VALBRUT
		_nPBruto	:= iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO)
		If SF2->F2_TIPO== 'B'
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
			_cCep		:= SA2->A2_CEP
			_cNome		:= SA2->A2_NOME
			_cMun		:= SA2->A2_MUN
			_cEst		:= SA2->A2_EST
			_cCliFor	:= SA2->A2_COD
			_cCliLoja	:= SA2->A2_LOJA
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
			_cCep		:= SA1->A1_CEP
			_cNome		:= SA1->A1_NOME
			_cMun		:= SA1->A1_MUN
			_cEst		:= SA1->A1_EST
			_cCliFor	:= SA1->A1_COD
			_cCliLoja	:= SA1->A1_LOJA
			_cTDE		:= iif(Empty(SA1->A1_FRETED),"Nao",iif(SA1->A1_FRETED=="S","Sim","Nao"))
		Endif
	Else
		If _cTipo $ "D" // Devolucao
			DbSelectArea("SF1")
			DbSetOrder(1)
			If DbSeek(xFilial("SF1")+_cNF+_cSerie+_cCliFor+_cLojaFor)
				_nValBrut	:= SF1->F1_VALBRUT
				_nPBruto	:= iif(SF1->F1_PESOCUB>0,SF1->F1_PESOCUB,SF1->F1_PBRUTO)
				DbSelectArea("SA1")
				DbSetOrder(1)
				if DbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
					_cCep		:= SA1->A1_CEP
					_cNome		:= SA1->A1_NOME
					_cMun		:= SA1->A1_MUN
					_cEst		:= SA1->A1_EST
					_cCliFor	:= SA1->A1_COD
					_cCliLoja	:= SA1->A1_LOJA
				endif
			endif
		endif
	Endif

// Posicionar na Tabela de Regioes
	_lRegiao := .F.
	DbSelectArea("PAZ")
	DbSetOrder(2)// Estado + Tipo
	DbSeek(xFilial("PAZ")+_cEst,.F.)
	While ! Eof() .AND. PAZ->(PAZ_FILIAL+PAZ_ESTADO) == xFilial("PAZ") + _cEst .AND. !Empty(_cCep)
		If _cCep >= PAZ->PAZ_CEPINI .AND. _cCep <= PAZ->PAZ_CEPFIM
			_lRegiao := .T.
			Exit
		Endif
		DbSkip()
	Enddo

	DbSelectArea("PAX")
	DbSetOrder(1)
	DbSeek(xFilial("PAX")+_cTransp,.F.)
	While ! Eof() .AND. PAX->PAX_CODTRA == _cTransp .and. ! Empty(_cSeqCont)
		If PAX->PAX_CODIGO == _cCont .AND. PAX->PAX_SEQCON == _cSeqCont
			Exit
		Endif
		DbSkip()
	Enddo

	DEFINE MSDIALOG oDlg2 FROM	09,0 TO 21,80 TITLE "Resumo Nota Fiscal" OF oMainWnd

	@ 004,005 SAY "Cli/For" 		SIZE 025,07          OF oDlg2 PIXEL
	@ 012,004 MSGET _cCliFor      	SIZE 070,09 WHEN .F. OF oDlg2 PIXEL
	@ 004,077 SAY "Loja" 			SIZE 020,07          OF oDlg2 PIXEL
	@ 012,077 MSGET _cCliLoja		    SIZE 021,09 WHEN .F. OF oDlg2 PIXEL
	@ 004,100 SAY "Nome" 			SIZE 025,07 OF oDlg2 PIXEL
	@ 012,100 MSGET _cNome			SIZE 150,09 WHEN .F. OF oDlg2 PIXEL

	@ 023,005 SAY "CEP"				SIZE 025,07 OF oDlg2 PIXEL
	@ 030,004 MSGET _cCep			SIZE 070,09 PICTURE PesqPict("SA1","A1_CEP") WHEN .F. OF oDlg2 PIXEL
	@ 023,077 SAY "Municipio" 		SIZE 025,07 OF oDlg2 PIXEL
	@ 030,077 MSGET  _cMun			SIZE 060,09 PICTURE PesqPict("SA1","A1_MUN") WHEN .F. OF oDlg2 PIXEL
	@ 023,141 SAY "Estado"			SIZE 035,07 OF oDlg2 PIXEL
	@ 030,141 MSGET _cEst			SIZE 010,03 PICTURE PesqPict("SA1","A1_EST") WHEN .F. OF oDlg2 PIXEL
	If _lRegiao
		@ 023,160 SAY "Regiao"		SIZE 035,07 OF oDlg2 PIXEL
		@ 030,160 MSGET PAZ->PAZ_CODIGO  SIZE 010,03 PICTURE PesqPict("PAZ","PAZ_CODIGO") F3 "PAZ" WHEN .T. OF oDlg2 PIXEL
	Endif

	If _cTipo $ "V/N/R" // Venda Recusa ou Reentrega
		@ 042,005 SAY "Emissao NF"		SIZE 025,07 OF oDlg2 PIXEL
		@ 049,004 MSGET SF2->F2_EMISSAO SIZE 070,09 PICTURE PesqPict("SF2","F2_EMISSAO") WHEN .F. OF oDlg2 PIXEL
		@ 042,077 SAY "Expedicao NF"	SIZE 025,07 OF oDlg2 PIXEL
		@ 049,077 MSGET  SF2->F2_DTEMB  SIZE 060,09 PICTURE PesqPict("SF2","F2_DTEMB") WHEN .F. OF oDlg2 PIXEL
		@ 042,141 SAY "Entrega"			SIZE 025,07 OF oDlg2 PIXEL
		@ 049,141 MSGET SF2->F2_DTRECEB SIZE 060,09 PICTURE PesqPict("SF2","F2_DTRECEB") WHEN .F. OF oDlg2 PIXEL
	Endif
	@ 061,005 SAY "Valor Bruto NF"  SIZE 025,07 OF oDlg2 PIXEL
	@ 068,004 MSGET _nValBrut       SIZE 070,09 PICTURE PesqPict("SF2","F2_VALBRUT") WHEN .F. OF oDlg2 PIXEL
	@ 061,077 SAY "Peso Bruto Produtos" SIZE 025,07 OF oDlg2 PIXEL
	@ 068,077 MSGET  _nPBruto SIZE 060,09 PICTURE PesqPict("SF2","F2_PBRUTO") WHEN .F. OF oDlg2 PIXEL
	If _cTipo $ "V/N/R" // Venda Recusa ou Reentrega
		If !SF2->F2_TIPO $ 'D/B'
			@ 061,141 SAY "T.D.E."			SIZE 025,07 OF oDlg2 PIXEL
			//@ 068,141 ComboBox _cTDE Items _aComboTDE Size 050,10 OF oDlg2 PIXEL Change( Alert(_cTDE) )
			_oTDE := TComboBox():New(068,141,{|u|if(PCount()>0,_cTDE:=u,_cTDE)},_aComboTDE,50,20,oDlg2,,{||MudaTDE()},,,,.T.,,,,,,,,,'_cTDE')
		endif
	endif

	If !Empty(_cSeqCont)
		@ 010,272 BUTTON OemToAnsi("Tab.Frete") SIZE 40,12 FONT oDlg2:oFont   ACTION AxAltera("PAX",,4)  	OF oDlg2 PIXEL
	else
		@ 010,272 BUTTON OemToAnsi("Tab.Frete") SIZE 40,12 FONT oDlg2:oFont   ACTION U_TABFRE()  	OF oDlg2 PIXEL
	Endif
	@ 024,272 BUTTON OemToAnsi("Nota Fiscal") SIZE 40,12 FONT oDlg2:oFont ACTION CONSNF()	OF oDlg2 PIXEL
	@ 038,272 BUTTON OemToAnsi("Sair")    SIZE 40,12 FONT oDlg2:oFont ACTION oDlg2:End()	OF oDlg2 PIXEL

	ACTIVATE MSDIALOG oDlg2

	RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MudaTDE   ³ Autor ³ Anderson Messias      ³ Data ³ 14/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua Alteração do Flag de Taxa de Dificuldade de entrega  ³±±
±±³          ³ no cadastro do cliente                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MudaTDE()

	if SA1->A1_FRETED <> Substr(_cTDE,1,1)
		aSavAtu := GetArea()
		DBSelectArea("SA1")
		Reclock("SA1")
		SA1->A1_FRETED := Substr(_cTDE,1,1)
		MsUnlock()
		RestArea(aSavAtu)
	endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FRLIBEST  ³ Autor ³ Eduardo Barbosa       ³ Data ³ 21/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua Geracao ou Estorno do documento de entrada           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


USER Function FrLibEst(_nAcao)

	Local	_aArea	:=	GetArea()
	Local dDtFatura		:= PAV->PAV_EMISFA // Data referente à fatura
	Local dDtCTO		:= PAV->PAV_EMICTO  // Data referente ao conhecimento
	Local dDtMVDATAFIN	:= GetMv("MV_DATAFIN")
	Local dDtMVULMES	:= GetMv("MV_ULMES")
	Local dDtMVDATAFIS	:= GetMv("MV_DATAFIS")

	If _nAcao == 5 .and. !VerSenha(6) // Consiste o Acesso 6 (Alterar Pedidos Compras) para garantir acesso tambem a estorno

		MsgStop("Usuario sem acesso","Acesso nao permitido")
		Return

	EndIf

	If _nAcao==5
		If dDtFatura < dDtMVDATAFIN
			Aviso("ATENCAO","Data da emissão da Fatura inferior ao período de fechamento FINANCEIRO " + DTOC(dDtMVDATAFIN) + ", estorno não realizado. " + SPACE(100) + " Data dos parametros: Fechamento Fiscal " + DTOC(dDtMVDATAFIS) + " Fechamento Mensal " + DTOC(dDtMVULMES),{"OK"},3,"Operação Invalida")
			Return
		EndIf
		If dDtFatura < dDtMVDATAFIS
			Aviso("ATENCAO","Data da emissão da Fatura inferior ao período de fechamento FISCAL " + DTOC(dDtMVDATAFIS) + ", estorno não realizado. " + SPACE(100) + " Data dos parametros: Fechamento Financeiro " + DTOC(dDtMVDATAFIN) + " Fechamento Mensal " + DTOC(dDtMVULMES),{"OK"},3,"Operação Invalida")
			Return
		EndIf
		If dDtCTO < dDtMVULMES
			Aviso("ATENCAO","Data da emissão do CTO inferior ao período de fechamento Mensal " + DTOC(dDtMVULMES) + ", estorno não realizado. " + SPACE(100) + " Data dos parametros: Fechamento Financeiro " + DTOC(dDtMVDATAFIN) + " Fechamento Fiscal " + DTOC(dDtMVDATAFIS),{"OK"},3,"Operação Invalida")
			Return
		EndIf
	EndIf

	CMPAVCODTRA := PAV->PAV_CODTRA

	If !MsgYesno("Confirma a Liberacao / Estorno Da Fatura : "+PAV->PAV_FATURA+" ?","Liberação de fatura de Frete")
		Return
	Endif

	_lLiber	:= JaLiberada(PAV->PAV_FATURA,PAV->PAV_CODTRA)
//If _nAcao == 5 .AND. !_lLiber
//	Aviso("ATENCAO","Estorno sao permitidos apenas para faturas liberadas ",{"OK"},3,"Fatura Nao Foi Liberada")
//	Return
//Endif
	If _nAcao == 3 .AND. _lLiber
		Aviso("ATENCAO","Liberacao Sao permitidas apenas para faturas nao Liberadas ",{"OK"},3,"Fatura Ja Foi Liberada")
		Return
	Endif
	MsAguarde({|| fGeraNF(_nAcao)},"Aguarde,  Processando Integracoes ")
	RestArea(_aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FGERANF   ³ Autor ³ Eduardo Barbosa       ³ Data ³ 13/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona os Conhecimentos Para Geracao documento de entrad³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function fGeraNF(_nAcao)

	Local _aArea	:= GetArea()
	//Local _cUsuFis	:= SubStr(cUsuario,7,15)
	Local _cCodPro	:= GetMv("MV_XFREPR")//,.F.,"975010007")  // Codigo do Produto Frete
	Local _cTesPro	:= GetMv("MV_XFRETE")//,.F.,"174")        // Tes do Produto Frete
	Local _cCodFat	:= GetMv("MV_XFATPR")//,.F.,"975010007")  // Codigo do produto Fatura
	Local _cTesFat	:= GetMv("MV_XFATTE")//,.F.,"455")        // Tes do produto Fatura
	//Local _cTesSub	:= GetMv("MV_XSUBTE")//,.F.,"174")        // Tes Para substituicao Tributaria
	Local _cTipo    := ""

//Ajustes ADVISE - TES especifica por tipo de transportadora
	Local cTesNSim		:= SuperGetMV("TA_TESTRAN", Nil, "")	//Tes de Transportadora nao optante do simples nacional
	Local cTesPSim		:= SuperGetMV("TA_TESSIMN", Nil, "")	//Tes de Transportadora optante do simples nacional
	Local cTesISim		:= SuperGetMV("TA_TESSENT", Nil, "")	//Tes de Transportadora nao optante do simples nacional Isento
	Local lSimpNac		:= .F.	//Simples Nacional
	Local cEstTra		:= ""	//Estado da Transportadora
	Local _lSerCto      := AllTrim(GetSx3Cache("PAV_SERCTO", "X3_CAMPO")) == "PAV_SERCTO"

/*
|---------------------------------------------------------------------------------
|	Variavel para TES Inteligente
|---------------------------------------------------------------------------------
*/
	Local cTESInt		:= ""

/*
|---------------------------------------------------------------------------------
|	Variavel para validação do vencimento no financeiro
|---------------------------------------------------------------------------------
*/
	Local aPgto	:= {}
	Local nNumPar	:= 0
	Local oDlgFrete
	Local lSE2vencto := .F.

	Private _cFornLoj	:= ""

	_cFornece := ""
	_cLoja    := ""

//Na Taiff ja existe o Codigo e Loja do fornecedor no cadastro da transportadora, se estiver em branco uso a logica antiga!

	DBSelectArea("SA4")
	DBSetOrder(1)
	if DBSeek(xFilial("SA4")+PAV->PAV_CODTRA)

//	_cFornece := SA4->A4_FORNECE
//	_cLoja	  := SA4->A4_LOJAFOR

//Else

		DBSelectArea("SA2")
		DBSetOrder(3)
		If DBSeek(xFilial("SA2") + SA4->A4_CGC)

			_cFornece := SA2->A2_COD
			_cLoja	  := SA2->A2_LOJA

		EndIf

	EndIf

	if Empty(_cFornece)
		cQuery := " SELECT A2_COD,A2_LOJA,A2_CGC,A2_TRANSP,A2_COND,A2_NATUREZ,A2_SIMPNAC,A2_EST "
		cQuery += " FROM "+RETSQLNAME('SA2')
		cQuery += " WHERE A2_FILIAL='"+xFilial("SA2")+"'"
		cQuery += " AND  A2_TRANSP='"+PAV->PAV_CODTRA+"'"
		cQuery += " AND  D_E_L_E_T_ = ' ' "
		If Sele("TRB") <> 0
			DbSelectArea("TRB")
			DbCloseArea()
		Endif

		TCQUERY cQuery NEW ALIAS "TRB"

		_cFornece	:= TRB->A2_COD
		_cLoja		:= TRB->A2_LOJA
		_cCondPg	:= TRB->A2_COND
		_cCodTra	:= PAV->PAV_CODTRA
		_cCgc		:= TRB->A2_CGC
		_cNaturez	:= TRB->A2_NATUREZ
		lSimpNac	:= TRB->A2_SIMPNAC == "1"
		cEstTra	:= TRB->A2_EST
		TRB->(DbCloseArea())
	else

		DBSelectArea("SA2")
		DBSetOrder(1)
		if DBSeek(xFilial("SA2")+_cFornece+_cLoja)
			_cFornece	:= SA2->A2_COD
			_cLoja	  	:= SA2->A2_LOJA
			_cCondPg 	:= SA2->A2_COND
			_cCodTra 	:= PAV->PAV_CODTRA
			_cCgc	  	:= SA2->A2_CGC
			_cNaturez	:= SA2->A2_NATUREZ
			lSimpNac	:= SA2->A2_SIMPNAC == "1"
			cEstTra	:= SA2->A2_EST
		else

			DBSelectArea("SA2")
			DBSetOrder(3)
			If DBSeek(xFilial("SA2") + SA4->A4_CGC)

				_cFornece := SA2->A2_COD
				_cLoja	  := SA2->A2_LOJA

				_cCondPg  := SA2->A2_COND
				_cCodTra  := PAV->PAV_CODTRA
				_cCgc	  := SA2->A2_CGC
				_cNaturez := SA2->A2_NATUREZ
				lSimpNac  := SA2->A2_SIMPNAC == "1"
			EndIf
		EndIf

	endif

// Efetua Validacao do Transportador e Condicao de pagamento
	If Empty(_cFornece)
		Aviso("ATENCAO","Nao Foi Localizado Fornecedor Para este Transportador",{"OK"},3,"Fornecedor Nao Localizado")
		Return
	Endif
	If Empty(_cCondPg)
		Aviso("ATENCAO","Informe a Condicao de Pagamento no cadastro do Fornecedor "+_cFornece+'/'+_cLoja,{"OK"},3,"Condicao de Pagamento")
		Return
	Endif
	If Empty(_cNaturez)
		Aviso("ATENCAO","Informe a Natureza no Cadastro do Fornecedor",{"OK"},3,"Natureza Nao Preenchida")
		Return
	Endif

	If _nAcao==3
		aPgto   := Condicao(10, _cCondPg, , PAV->PAV_EMISFA)
		nNumPar	 := 1
		If len(aPgto) != 0
			nOpc := 0
			dDtVencimento := aPgto[nNumPar,1]
			If dDtVencimento < dDataBase
				define msDialog oDlgFrete from 0,0 to 120,290 title "Validação de Vencimento" Of oDlgFrete Pixel
				@ 005,005 say "Validação de Vencimento do título no financeiro" size  100,07 Of oDlgFrete Pixel
				@ 018,005 say "Vencto:" size 21,07 Of oDlgFrete Pixel
				@ 018,37 GET oDESCR VAR dDtVencimento SIZE 49, 08 Of oDlgFrete Pixel

				define sButton from 040,080 type 1 action( IIf( dDtVencimento < dDataBase,( MsgInfo( "A data de vencimento da Fatura é inferior à data base do sistema", "Aviso" ), oDESCR:SetFocus() ),{oDlgFrete:End(),nOpc := 1}) ) enable  Of oDlgFrete Pixel
				define sButton from 040,110 type 2 action(oDlgFrete:End(),nOpc := 2) enable  Of oDlgFrete Pixel
				activate msDialog oDlgFrete center
				If nOpc = 2
					Return
				EndIf
				If nOpc = 1
					lSE2vencto := .T.
				EndIf
			EndIf
		Else
			Aviso("ATENCAO","Não foi possível calcular a data de vencimento da Fatura.",{"OK"},3,"Vencimento Inválido")
			Return
		EndIf
	EndIf

	DbSelectarea("SA4")
	DbSetOrder(1)
	DbSeek(xFilial("SA4")+_cCodTra,.F.)
	If Alltrim(SA4->A4_CGC) <> Alltrim(_cCgc)
		Aviso("ATENCAO","Cgc do Transportador Diferente do Cgc do Fornecedor "+_cFornece+'/'+_cLoja,{"OK"},3,"CGC Diferente")
		Return
	Endif

	__nOpcao 	:= _nAcao // nAcao == 3 -> Inclusao nAcao = 5 // Exclusao
	_cFatura 	:= PAV->PAV_FATURA
	_cTransp 	:= PAV->PAV_CODTRA
	_dEmissao	:= PAV->PAV_EMISFA
	_dVencto 	:= PAV->PAV_VENCFA
	_cTipo      := PAV->PAV_TIPO

// Digitacaio da data de Emissao do Frete
	DbSelectarea("PAV")
	DbSetOrder(1)
	DbSeek(xFilial("PAV")+_cFatura+_cTransp,.F.)
	_nTotVlr	:= 0
	_nTotDesc	:= 0
	_nTotAjus	:= 0
	_cFatura 	:= PAV->PAV_FATURA
	_cTransp 	:= PAV->PAV_CODTRA
	_dEmissao	:= PAV->PAV_EMISFA
	_dVencto 	:= PAV->PAV_VENCFA
	_cNFeChv    := PAV->PAV_CHVNFE  // 20130328
	_nTotDes	:=	0
	_lErro	 	:= .T.
	_nRecno		:= Recno()

// Primeiro Efetua Calculo para pegar valor total da Fatura
	While ! Eof() .AND. PAV->(PAV_FILIAL+PAV_FATURA) == xFilial("PAV")+_cFatura .AND. PAV->PAV_CODTRA == _cTransp //.AND. __nOpcao == 3 // Inclusao
		MsprocTxt("Gerando Fatura - Conhecimento -> "+PAV->PAV_CTO)
		_nTotVlr  := _nTotVlr  + PAV->PAV_FRETRA
		_nTotDes  := _nTotDes  + PAV->PAV_DESCON
		_nTotAjus := _nTotAjus + PAV->PAV_AJUST

		If __nOpcao == 5 // Exclusao
			_cForOld 	:= _cFornece
			_cLojOld	:= _cLoja

			If PAV->PAV_TIPO $ "D/R/N/C"  // Devolucao / Reentrega / Recusa / Compra
				DbSelectArea("SA2")
				DbSetOrder(3)
				DbSeek(xFilial('SA2')+PAV->PAV_CGCFOR,.F.)
				_cFornece	:= SA2->A2_COD
				_cLoja		:= SA2->A2_LOJA
			Endif

			DbSelectArea("SF1")
			DbSetOrder(1)
			DbSeek(xFilial("SF1")+PAV->PAV_CTO+PAV->PAV_SERCTO+_cFornece+_cLoja,.F.)
			_cFornece	:= _cForOld
			_cLoja		:= _cLojOld
			DbSelectArea("PAV")
		Endif
		DbSkip()
	Enddo

// Tenta Efetuar Gravacao da Fatura
	If _nTotvlr > 0 .OR. __nOpcao == 5 // Exclusao

		If (_nTotDes-_nTotAjus) < 0
			_nTotdes :=0
			_nTotAjus:=0
		Endif

		/// Verifica Se Transportador Possui Substituição Tributaria Destacada na Nota Fiscal
		//_cSubStr := GetMv("MV_HATRSU")
		_cSubStr := "XXX"
		If Alltrim(_cTransp) $ _cSubStr
			_nTotDes := Round(_nTotVlr * 0.12,2)
		Endif

		_cSerCto := IIf(_lSerCto, PAV->PAV_SERCTO, "U  ")

		If !Empty(AllTrim(_cNFeChv)) .and. Len(AllTrim(_cNFeChv)) == 44 .and. !Empty(SubStr(AllTrim(_cNFeChv), 23, 03))

			If _cSerCto <> SubStr(AllTrim(_cNFeChv), 23, 03)

				_cSerCto := SubStr(AllTrim(_cNFeChv), 23, 03)

			EndIf

		EndIf

		If __nOpcao == 5 .AND. _dEmissao <= STOD("'20160301")

			_cSerCto := IIf(_lSerCto, PAV->PAV_SERCTO, "U  ")

		ElseIf (__nOpcao == 5 .AND. _dEmissao > STOD("20160301")) .OR. __nOpcao == 3

			_cSerCto := "FAT"

		Endif

		If _cTipo $ "R"
			_cCodFat := BuscaProd( "" , "" , _cTipo)
		EndIf
		_cCusto	:= ''   //(__nOpcao,_cProduto,_cTes, _cSerie,_cDoc,   _cFornece,_cLoja,_dEmissao, _nValor,  _nDesc,             _cFat,   _cEspecie,_nQtde,_cCentro,_nPicm,_aCtoS)
		//_lErro := FGravaNf(__nOpcao,_cCodFat,_cTesFat,_cSerCto,_cFatura,_cFornece,_cLoja,_dEmissao,_nTotVlr,(_nTotDes-_nTotAjus),_cFatura,'NFE',    1     ,_cCusto,      ,      , _cNFeChv) // 20130328
		_lErro := FGravaNf(__nOpcao,_cCodFat,_cTesFat,_cSerCto,_cFatura,_cFornece,_cLoja,_dEmissao,_nTotVlr,(_nTotDes-_nTotAjus),_cFatura,'NFE',    1     ,_cCusto,      ,      , _cNFeChv) // 20130328

		If ! _lErro
			// Os Vencimentos dos titulos de fatura de frete ocorrem no dia 05 ou dia 20 do mes subsequente
			DbSelectArea("SE2") // Fornecedor + Loja + Prefixo + Titulo + Parcela + Tipo
			DbSetOrder(6)
			If DbSeek(xFilial("SE2")+_cFornece+_cLoja+"FRA"+_cFatura,.F.)
				_dVenctoV	:= DataValida(_dVencto)
				RecLock("SE2",.F.)
				SE2->E2_VENCTO	:=	_dVencto
				SE2->E2_VENCREA	:=	_dVenctoV
				SE2->E2_VENCORI	:=	_dVencto
				msUnlock()
			Endif
		Endif
		If lSE2vencto
			DbSelectArea("SE2")
			DbSetOrder(6) // E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO
			If DbSeek( xFilial("SE2") + _cFornece + _cLoja + _cSerCto + _cFatura ,.F.)
				_dVenctoV	:= DataValida(dDtVencimento)
				RecLock("SE2",.F.)
				SE2->E2_VENCTO		:=	dDtVencimento
				SE2->E2_VENCREA	:=	_dVenctoV
				SE2->E2_VENCORI	:=	dDtVencimento
				msUnlock()
			Endif
		EndIf
	Endif

	If _lErro
		_cTexto := IIF(__nOpcao==3,"Liberar ","Estornar ")
		Aviso("ATENCAO","Nao e Possivel "+_cTexto+" a Fatura->"+_cFatura,{"OK"},3,"Estorno / Liberacao Nao permitido")
	Endif

// Efetua Gravacao dos Conhecimentos se estiver conseguido gravar a Fatura
	DbSelectArea("PAV")
	DbGoTo(_nRecno)
	While ! Eof() .AND. PAV->(PAV_FILIAL+PAV_FATURA+PAV_CODTRA) == xFilial("PAV")+_cFatura+_cTransp .and. !_lErro

		MsprocTxt("Conhecimento -> "+PAV->PAV_CTO)

		// Localizacao da Nota Fiscal para pegar o produto de acordo com o estado ( casos em que o icms pode ser de 07 ou 12%)
		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)


		//Tratamento para redespacho!
		_cEst	:= SF2->F2_EST
		If ! Empty(SF2->F2_REDESP)
			DbSelectArea("SA4")
			DbSetOrder(1)
			DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
			_cEst	:= SA4->A4_EST
		Endif

		_nAliq	:= 1
		If _cEst $ GETMV("MV_NORTE") //.AND. EMPTY(SF2->F2_REDESP)
			_nAliq		:= 7
		Else
			_nAliq		:= 12
		Endif

		_cCto	:= PAV->PAV_CTO
		_nValfre	:= 0
		_aCtoS	:= {}

		// While no Mesmo Conhecimento Para pegar o valor total do Conhecimento
		DbSelectArea("PAV")
		While ! Eof() .AND. PAV->(PAV_FILIAL+PAV_FATURA+PAV_CODTRA+PAV_CTO) == xFilial("PAV")+_cFatura+_cTransp+_cCto
			RecLock("PAV",.F.)
			If __nOpcao == 3
				PAV->PAV_LIBERA='S'
			Else
				PAV->PAV_LIBERA=' '
			Endif
			msUnlock()
			_nValfre := Round(_nValFre + Round(PAV->PAV_FRETRA,2),2)

			////Rotina de busca do CFOP
			_cProduto 	:= BuscaProd(PAV->PAV_NF,PAV->PAV_SERIE,PAV->PAV_TIPO)
			_nposProd 	:= ASCAN(_aCtoS,{|x| x[1] == _cProduto})
			IF CEMPANT = "03"
				cTESInt	:= MATESINT(1,"65",_cFornece,_cLoja,"F",_cProduto)
			ENDIF
			IF ALLTRIM(_cTransp) $ ("001222|000918")
				If Alltrim(SF2->F2_EST) == "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007"
					cTESInt	:= "388"
				ElseIf Alltrim(SF2->F2_EST) == "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003"
					cTESInt	:= "442"
				ElseIf Alltrim(SF2->F2_EST) != "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007"
					cTESInt	:= "486"
				ElseIf Alltrim(SF2->F2_EST) != "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003"
					cTESInt	:= "451"
				EndIf
			ElseIF ALLTRIM(_cTransp) $ ("001308")
				If Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007" // Vendas
					cTESInt	:= "388" // "486"
				ElseIf Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003" // bonificaç?o
					cTESInt	:= "442" // "451"
				EndIf
			EndIf
			If _nPosProd==0
				AADD(_aCtoS,{_cProduto,Round(PAV->PAV_FRETRA,2),cTESInt})
			Else
				_aCtoS[_nPosProd,02] := _aCtoS[_nPosProd,02] +  Round(PAV->PAV_FRETRA,2)
			Endif

			DbSelectArea("PAV")
			PAV->(DbSkip())
		Enddo
		DbSkip(-1)
		_cForOld 	:= _cFornece
		_cLojOld	:= _cLoja

		If PAV->PAV_TIPO $ "D/R/N/C"  // Devolucao / Reentrega / Recusa / Compra
			DbSelectArea("SA2")
			DbSetOrder(3)
			DbSeek(xFilial('SA2')+PAV->PAV_CGCFOR,.F.)
			_cFornece	:= SA2->A2_COD
			_cLoja		:= SA2->A2_LOJA
			DbSelectArea("PAV")
		Endif

		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+PAV->(PAV_NF+PAV_SERIE),.F.)

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA),.F.)
		_cCusto		:= ' ' //SA1->A1_CCC

		DbSelectArea("PAV")
		_cCodTes    := '059'
		If PAV->PAV_EMICTO > dDataBase
			RecLock("PAV",.F.)
			PAV->PAV_EMICTO := dDataBase
			msUnlock()
		Endif

		//======================================================
		//Tratamento para Buscar TES
		If lSimpNac
			_cTesPro	:= cTesPSim
		Else
			_cTesPro	:= cTesNSim
		EndIf

		//Verifica isencao de ICMS
	/*
	|---------------------------------------------------------------------------------
	|	Patrícia lima solicitou alteração da forma de tributação conforme email
	|	Para a Transportadora Atlas o tratamento continua o mesmo. 
	|
	|	Edson Hornberger - 26/08/2015
	|---------------------------------------------------------------------------------
		If Alltrim(SF2->F2_EST) == "MG" .And. Alltrim(SF2->F2_EST) == Alltrim(SM0->M0_ESTCOB) .And. Alltrim(SF2->F2_EST) == Alltrim(cEstTra)
		_cTesPro	:= cTesISim
		EndIf
	*/
		_cFornLoj := POSICIONE("SA2", 3, XFILIAL("SA2") + POSICIONE("SA4", 1, XFILIAL("SA4") + PAV_CODTRA,"A4_CGC"), "A2_COD")
		_cFornLoj += POSICIONE("SA2", 3, XFILIAL("SA2") + POSICIONE("SA4", 1, XFILIAL("SA4") + PAV_CODTRA,"A4_CGC"), "A2_LOJA")

		IF _cFornLoj $ ("00938601|00966301|00976701|00992501|01071201|01413801|00907501")
			If Alltrim(SF2->F2_EST) == "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007"
				_cTesPro	:= "388"
			ElseIf Alltrim(SF2->F2_EST) == "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003"
				_cTesPro	:= "442"
			ElseIf Alltrim(SF2->F2_EST) != "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007"
				_cTesPro	:= "486"
			ElseIf Alltrim(SF2->F2_EST) != "MG" .And. Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003"
				_cTesPro	:= "451"
			EndIf
		ElseIF _cFornLoj $ ("01580501")
			If Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010007" // Vendas
				_cTesPro	:= "388" // "486"
			ElseIf Alltrim(SM0->M0_ESTCOB) = "MG" .AND. ALLTRIM(_cProduto) = "975010003" // Bonificaç?o
				_cTesPro	:= "442" // "451"
			EndIf
		ELSE
			If Alltrim(SM0->M0_ESTCOB) == "MG" .And. Alltrim(SM0->M0_ESTCOB) == Alltrim(cEstTra)
				_cTesPro	:= cTesISim
			EndIf
		ENDIF

		//======================================================

		_cSerCto := IIf(_lSerCto, PAV->PAV_SERCTO, "U  ")

		If !Empty(AllTrim(_cNFeChv)) .and. Len(AllTrim(_cNFeChv)) == 44 .and. !Empty(SubStr(AllTrim(_cNFeChv), 23, 03))

			If _cSerCto <> SubStr(AllTrim(_cNFeChv), 23, 03)

				_cSerCto := SubStr(AllTrim(_cNFeChv), 23, 03)

			EndIf

		EndIf
		//Substituicao de "U  " pelo conteudo do PAV_SERCTO
		_lErro := FGravaNf(__nOpcao,_cCodPro,_cTesPro,_cSerCto ,PAV->PAV_CTO,_cFornece,_cLoja,PAV->PAV_EMICTO,_nValfre,0,PAV->PAV_FATURA,'CTE',1,_cCusto,_nAliq,_aCtoS,      ,      , PAV->PAV_CHVNFE) // 20130328
		_cFornece	:=	_cForOld
		_cLoja      :=  _cLojOld

		DbSelectArea("PAV")
		DbSkip()
	Enddo

	if _cTipo == "V" //so contabiliza fatura de venda
		if SuperGetMV("MV_XCTBFRE",,.F.)
			_lMostraCont := SuperGetMV("MV_XVERCTB",,.T.)
			if __nOpcao == 3
				//Contabilizo o Frete
				u_CTBPFrete(_lMostraCont,_cFatura,_cTransp,.F.)
			else
				//Contabilizo o estorno do Frete
				u_CTBPFrete(_lMostraCont,_cFatura,_cTransp,.T.)

				_cDataBase := DToC(dDataBase)

				_cLog := "Empresa        " + SM0->M0_CODIGO 				+ Chr(13) + Chr(10)
				_cLog += "Filial         " + SM0->M0_CODFIL					+ Chr(13) + Chr(10)
				_cLog += "DataBase       " + _cDataBase						+ Chr(13) + Chr(10)
				_cLog += "Horario        " + Time()							+ Chr(13) + Chr(10)
				_cLog += "Opcao          " + AllTrim(Str(__nOpcao))			+ Chr(13) + Chr(10)
				_cLog += "Execucao       " + IIf(lAutoConF, "SIM", "NAO" )	+ Chr(13) + Chr(10)
				_cLog += "Usuario        " + __cUserID						+ Chr(13) + Chr(10)
				_cLog += "Fatura         " + _cFatura						+ Chr(13) + Chr(10)
				_cLog += "Transportadora " + _cTransp						+ Chr(13) + Chr(10)

				_nCall := 1

				Do While !Empty(AllTrim(ProcName(_nCall)))

					_cLog += IIf(_nCall == 1, "Call Stack     ", "               ") + AllTrim(ProcName(_nCall)) + Chr(13) + Chr(10)

					_nCall ++

				EndDo

				_cDataBase := DToS(dDataBase)

				MemoWrit("CTBFrete_" + _cDataBase + "_" +_cFatura + "_" + _cTransp + ".txt", _cLog)

			endif
		endif
	endif

	Aviso("Liberação / Estorno Fatura",iif(__nOpcao == 3,"Liberação da fatura "+_cFatura+" executada com sucesso!","Estorno da liberação da fatura "+_cFatura+" executada com sucesso!"),{"OK"},3)

	RestArea(_aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FGRAVANF ³ Autor ³ Eduardo Barbosa       ³ Data ³ 13/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava os Documentos de Entrada da Fatura                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FGravaNf(__nOpcao, _cProduto, _cTes, _cSerie, _cDoc, _cFornece, _cLoja, _dEmissao, _nValor, _nDesc, _cFat, _cEspecie, _nQtde, _cCentro, _nPicm, _aCtoS, xVar1, xVar2, _cNFeChv)
// Nova recepcao de variaveis
//FGravaNf(__nOpcao,  _cProduto,  _cTes,     _cSerie,  _cDoc,         _cFornece,  _cLoja,  _dEmissao,        _nValor,   _nDesc,  _cFat,             _cEspecie, _nQtde,  _cCentro,  _nPicm,  _aCtoS, xVar1, xVar2, _cNFeChv)                                                                                                                                                     

// Recepcao de variaveis Anterior
//FGravaNf(__nOpcao,_cProduto,_cTes,_cSerie,_cDoc,_cFornece,_cLoja,_dEmissao,_nValor,_nDesc,_cFat,_cEspecie,_nQtde,_cCentro,_nPicm,_aCtoS, _cNFeChv) 
	Local _aCab		:=	{}
	Local _aItens   := 	{}
	Local  _nTamB1  := TamSX3("B1_COD")[1]
	Local _nY := 0

	DEFAULT _cCentro := AllTrim(GetMV("MV_X_CCFRE"))
	DEFAULT _nPicm   := 0
	DEFAULT _aCtoS   := {}

	PRIVATE CF1MUORITR := ""
	PRIVATE CF1UFORITR := ""
	PRIVATE CF1MUDESTR := ""
	PRIVATE CF1UFDESTR := ""

	If Len(_aCtoS) == 0
		AADD(_aCtoS,{_cProduto,_nValor,_cTes})
	Endif

// Ajusta o Tamanho do Codigo do Produto
	_cProduto	:= Alltrim(_cProduto)
	_cProduto 	:= _cProduto+Space(_nTamB1-Len(_cProduto))

//Se For exclusao, verifico se a nota existe
	if __nOpcao == 5
		DBSelectArea("SF1")
		DBSetOrder(1)
		if !DBSeek(xFilial("SF1")+_cDoc+_cSerie+_cFornece+_cLoja)
			Return .F.
		endif
	endif

//Se For exclusao, verifico se a nota existe
	if __nOpcao == 3
		DBSelectArea("SF1")
		DBSetOrder(1)
		if DBSeek(xFilial("SF1")+_cDoc+_cSerie+_cFornece+_cLoja)
			Return .F.
		endif
	endif

//_aCab := {{"F1_TIPO"		,'N'		,NIL},;
//{"F1_FORMUL"	,'N'		,NIL},;
//{"F1_DOC"		,_cDoc		,NIL},;
//{"F1_SERIE"		,_cSerie	,NIL},;
//{"F1_EMISSAO"	,_dEmissao	,NIL},;
//{"F1_FORNECE"	,_cFornece 	,NIL},;
//{"F1_LOJA"	   ,_cLoja     	,NIL},;
//{"F1_XFATFRE" 	,_cFat     	,NIL},;
//{"F1_ESPECIE"	,_cEspecie	,NIL},;
//{"F1_CHVNFE"	,_cNFeChv	,NIL}}


	AAdd(_aCab, {"F1_TIPO"	    	,'N'		,NIL})
	AAdd(_aCab, {"F1_FORMUL"	,'N'		,NIL})
	AAdd(_aCab, {"F1_DOC"		,_cDoc		,NIL})
	AAdd(_aCab, {"F1_SERIE"		,_cSerie	,NIL})
	AAdd(_aCab, {"F1_EMISSAO"	,_dEmissao	,NIL})
	AAdd(_aCab, {"F1_FORNECE"	,_cFornece 	,NIL})
	AAdd(_aCab, {"F1_LOJA"	   ,_cLoja     	,NIL})
	AAdd(_aCab, {"F1_XFATFRE" 	,_cFat     	,NIL})
	AAdd(_aCab, {"F1_ESPECIE"	,_cEspecie	,NIL})

	If _cEspecie <>  "NFE"

		_cQryChv := "SELECT DISTINCT PAV_CHVNFE AS PAVCHVNFE "
		_cQryChv += "FROM "
		_cQryChv += RetSQLName("PAV") + " PAV WITH(NOLOCK), "
		_cQryChv += RetSQLName("SA4") + " SA4 WITH(NOLOCK)  "
		_cQryChv += "WHERE "

		_cQryChv += "PAV.D_E_L_E_T_ <> '*' AND "
		_cQryChv += "SA4.D_E_L_E_T_ <> '*' AND "

		_cQryChv += "PAV_FILIAL = '" + xFilial("PAV") + "' AND "
		_cQryChv += "A4_FILIAL  = '" + xFilial("SA4") + "' AND "

		_cQryChv += "PAV_CTO    = '" + _cDoc   + "' AND "
		_cQryChv += "PAV_SERCTO = '" + _cSerie + "' AND "
		_cQryChv += "PAV_CODTRA = A4_COD            AND "
		_cQryChv += "SUBSTRING(PAV_CHVNFE, 26, 09) = '" + _cDoc + "'  AND "

		_cQryChv += "A4_CGC = SUBSTRING(PAV_CHVNFE, 07, 14) AND "

		_cQryChv += "  SUBSTRING(PAV_CHVNFE, 03, 02) = '" + SUBSTRING(Dtos(ddatabase),03,02) + "' AND " // Ano base da operação
		_cQryChv += "  PAV_CODTRA = '" + CMPAVCODTRA + "'"

		//MEMOWRITE( "CONFRETE_FGravaNf.SQL", _cQryChv )

		_cAliasChv := GetNextAlias()

		If Select(_cAliasChv) > 0

			DBSelectArea(_cAliasChv)
			DBCloseArea()

		EndIf

		DBUseArea(.T., "TOPCONN", TCGenQry(,, _cQryChv), _cAliasChv, .F., .T.)

		DBSelectArea(_cAliasChv)

		If !Empty(AllTrim((_cAliasChv)->PAVCHVNFE))

			_cNFeChv := (_cAliasChv)->PAVCHVNFE

		Else

			_cNFeChv := ""

		EndIf

		DBSelectArea(_cAliasChv)
		DBCloseArea()

	EndIf

	If !Empty(AllTrim(_cNFeChv)) .and. Len(AllTrim(_cNFeChv)) == 44

		AAdd(_aCab, {"F1_CHVNFE"	,_cNFeChv	,NIL})

		// Autor: Carlos Torres
		// Data: 19/02/2021 
		// Detalhes: informar os estados e municípios de origem/destino do transporte no documento de entrada.
		// Chamada da funç?o que faz a leitura do XML 
		U_MT103CTE(_cNFeChv,@CF1MUORITR,@CF1UFORITR,@CF1MUDESTR,@CF1UFDESTR,__nOpcao)

		AAdd(_aCab, {"F1_MUORITR"	,CF1MUORITR	,NIL})
		AAdd(_aCab, {"F1_UFORITR"	,CF1UFORITR	,NIL})
		AAdd(_aCab, {"F1_MUDESTR"	,CF1MUDESTR	,NIL})
		AAdd(_aCab, {"F1_UFDESTR"	,CF1UFDESTR	,NIL})

	EndIf

//{"E2_NATUREZ" 	,'2006'    	,NIL},;

//Tratamento da Classe contabil para contabilizar somente quando for o conhecimento, a fatura nao deve ser contabilizada
	if _cSerie == "FRA"
		_cClasCon := "5"
	else
		_cClasCon := "3"
	endif

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Alterado o preenchimento do campo de Centro de Custo para que pegue o que   
|	esta cadastrado no Produto.
|=================================================================================
*/

	_aItens := {}
	For _nY := 1 to Len(_aCtoS)
		_aItem:={{"D1_COD"	,_aCtoS[_nY][1]			,NIL},;
			{"D1_QUANT"	 ,_nQtde	,NIL},;
			{"D1_CLASCON",_cClasCon	,NIL},;
			{"D1_VUNIT"	 ,_aCtoS[_nY][2]	,NIL},;
			{"D1_TOTAL"	 ,_aCtoS[_nY][2]	,NIL},;
			{"D1_TES"	 ,IIF(EMPTY(_aCtoS[_nY][3]),_cTes,_aCtoS[_nY][3])		,NIL},;
			{"D1_VALDESC",_nDesc	,NIL},;
			{"D1_PICM"	 ,_nPicm	,NIL},;
			{"D1_CC"	 , POSICIONE("SB1",1,XFILIAL("SB1")+_aCtoS[_nY][1],"B1_CC")	,NIL}}
		//{"D1_CC"	 ,_cCentro	,NIL}}
		aadd(_aItens,_aItem)
	Next

	lMSErroAuto :=  .F.
	MSExecAuto({|x,y,z| MATA103(x,y,z)},_aCab,_aItens,__nOpcao)
	If lMsErroAuto //.AND. __nOpcao <> 5
		//DisarmTransaction()
		MostraErro()

	Else

		If !Empty(AllTrim(_cNFeChv)) .and. Len(AllTrim(_cNFeChv)) == 44 .and. Len(_aItens) > 1 .AND. __nOpcao <> 5

			_cQryUpd := "UPDATE " + RetSQLName("SF1")  + "  "
			_cQryUpd += "SET F1_CHVNFE = '" + _cNFeChv + "' "
			_cQryUpd += "WHERE "
			_cQryUpd += "F1_FILIAL  = '" + xFilial("SF1") + "' AND "
			_cQryUpd += "F1_DOC     = '" + _cDoc          + "' AND "
			_cQryUpd += "F1_SERIE   = '" + _cSerie        + "' AND "
			_cQryUpd += "F1_FORNECE = '" + _cFornece      + "' AND "
			_cQryUpd += "F1_LOJA    = '" + _cLoja         + "' AND "
			_cQryUpd += "D_E_L_E_T_ <> '*' AND "
			_cQryUpd += "F1_CHVNFE  = ''      "

			TCSqlExec(_cQryUpd)

		EndIf

	EndIf


Return lMSErroAuto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³JALIBERADA³ Autor ³ Eduardo Barbosa       ³ Data ³ 13/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Averigua se a Fatura ja Gerou Doucmento de Entrada         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function JaLiberada(_cFatura,_cTransp)

	//Local _cFatura	:=	_cFatura
	//Local _Transp	:=	_cTransp
	Local _lRet		:= .F.
	Local _aAreaAtu	:=	GetArea()

	DbSelectarea("PAV")
	DbSetOrder(1)
	DbSeek(xFilial("PAV")+_cFatura+_cTransp,.F.)
	While ! Eof() .AND. PAV->(PAV_FILIAL+PAV_FATURA+PAV_CODTRA) == xFilial("PAV")+_cFatura+_cTransp
		If !Empty(PAV->PAV_LIBERA)
			_lRet	:=	 .T.
			Exit
		Endif
		DbSkip()
	Enddo
	RestArea(_aAreaAtu)
Return _lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ POSCTO   ³ Autor ³ Eduardo Barbosa       ³ Data ³ 13/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inicializador Padrao do Campo de Emissao do Conhecimento   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function POSCTO()
// Funcao executada no Inicializado Padrao do Campo de Emissao do Conhecimento
// Para considerar a emissao do Conhecimento Anterior ( Facilitar a Digitacao )
	Local _dRet	:= aCols[n,_nPosEmiCo]
	If n>1 .AND. !EMPTY(aCols[n,_nPosEmiCo])
		_dRet	:= aCols[n-1,_nPosEmiCo]
	Else
		_dRet   := dDatabase
	Endif
Return _dRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SELENF   ³ Autor ³ Eduardo Barbosa       ³ Data ³ 13/03/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Seleciona NF de entrada                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function SeleNf(_cTpFre,_cDocEnt,_cSerEnt,_cCodCli,_cLojCli)
	Local _aRetorno	:= {}
	Local _aAreaAtu	:= GetArea()
	Local aArrayF4	:= {}
	Local cCadastro
	Local _nOpca
//Local nHdl  	:= GetFocus()

	DEFAULT _cDocEnt := "*********"
	DEFAULT _cSerEnt := ""
	DEFAULT _cCodCli := "******"
	DEFAULT _cLojCli := ""

	DBSelectArea("SF1")
	DBSetOrder(1)
	if DBSeek(xFilial("SF1")+_cDocEnt+_cSerEnt+_cCodCli+_cLojCli)
		AADD(_aRetorno,_cDocEnt)
		AADD(_aRetorno,_cSerEnt)
		AADD(_aRetorno,_cCodCli)
		AADD(_aRetorno,_cLojCli)
		AADD(_aRetorno,SF1->F1_PESOCUB)
	else
		// If o Tipo For Devolucao -> Posiciona no Cliente Para Pegar o Codigo
		If _cTipo =='D' // Devolucao

			DBSelectArea("SA1")
			DBSetOrder(1)
			if !DBSeek(xFilial("SA1")+_cCodCli+_cLojCli)
				_cCgc  := Space(14)
				aPergs := {}
				aRet   := {}
				aAdd( aPergs ,{1,"CNPJ do Cliente",_cCgc,"@R 99.999.999/9999-99",'.T.',,'.T.',80,.T.})
				If !ParamBox(aPergs ,"CNPJ do Cliente ",aRet)
					Return _aRetorno
				Endif
				_cCgc := aRet[1]
				If Empty(_cCgc)
					Return  _aRetorno
				Endif

				_cCodCli:= Posicione("SA1",3,xFilial('SA1')+_cCgc,'A1_COD')
				_cLojCli:= Posicione("SA1",3,xFilial('SA1')+_cCgc,'A1_LOJA')
			endif

			cQuery := "SELECT F1_DOC,F1_SERIE,F1_FORNECE,F1_VALBRUT,A1_NOME AS NOME ,F1_LOJA, F1_PESOCUB "
			cQuery += " FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SA1")+" SA1 "
			cQuery += " WHERE F1_FILIAL='"+xFilial("SF1")+"' "
			cQuery += " AND F1_FORNECE='"+_cCodCli+"'"
			cQuery += " AND F1_LOJA='"+_cLojCli+"'"
			cQuery += " AND F1_TIPO='D'"
			cQuery += " AND F1_FORNECE=A1_COD"
			cQuery += " AND F1_LOJA=A1_LOJA"
			//cQuery += " AND F1_DTDIGIT>='"+DTOS(dDataBase-180)+"'"
			cQuery += " AND SF1.D_E_L_E_T_=' '"
			cQuery += " AND SA1.D_E_L_E_T_=' '"
		Else
			cQuery := "SELECT F1_DOC,F1_SERIE,F1_FORNECE,F1_VALBRUT,A2_NOME AS NOME ,F1_LOJA, F1_PESOCUB "
			cQuery += " FROM "+RetSqlName("SF1")+" SF1,"+RetSqlName("SA2")+" SA2 "
			cQuery += " WHERE F1_FILIAL='"+xFilial("SF1")+"' "
			cQuery += " AND F1_DOC='"+_cDocEnt+"'"
			cQuery += " AND F1_DTDIGIT>='"+DTOS(dDataBase-180)+"'"
			cQuery += " AND F1_FORNECE=A2_COD"
			cQuery += " AND F1_LOJA=A2_LOJA"
			cQuery += " AND SF1.D_E_L_E_T_=' '"
			cQuery += " AND SA2.D_E_L_E_T_=' '"
		Endif
		If Sele("TRB1") <> 0
			DbSelectArea("TRB1")
			DbCloseArea()
		Endif
		TCQUERY cQuery NEW ALIAS "TRB1"
		_aRet		:={}
		DbSelectArea("TRB1")

		While !TRB1->(Eof())
			AADD(aArrayF4,{TRB1->F1_DOC,TRB1->F1_SERIE,TRB1->F1_FORNECE,TRB1->F1_LOJA,Transform(TRB1->F1_VALBRUT,"@E 999,999.99"),TRB1->NOME,TRB1->F1_PESOCUB})
			TRB1->(DbSkip())
		Enddo
		TRB1->(DbCloseArea())

		If !Empty(aArrayF4)
			cCadastro := OemToAnsi("Notas Fiscais de Entrada:--> "+_cDocEnt)
			_nOpca := 0
			DEFINE MSDIALOG oDlgLT TITLE cCadastro From 0,0 To 250,500 OF oMainWnd PIXEL
			@ 5,5 LISTBOX oQual VAR cVar Fields HEADER OemToAnsi("Nota Fiscal"),OemToAnsi("Serie"),OemToAnsi("Codigo"),OemToAnsi("Loja"),OemToAnsi("Valor"),OemToAnsi("Cliente / Fornecedor") SIZE 190,100 PIXEL ON DBLCLICK (_nOpca := 1,oDlgLT:End())
			oQual:SetArray(aArrayF4)
			oQual:bLine := { || {aArrayF4[oQual:nAT][1],aArrayF4[oQual:nAT][2],aArrayF4[oQual:nAT][3],aArrayF4[oQual:nAT][4],aArrayF4[oQual:nAT][5],aArrayF4[oQual:nAT][6]}}
			DEFINE SBUTTON FROM 05 ,200  TYPE 1 ACTION (_nOpca := 1,oDlgLT:End()) ENABLE OF oDlglt PIXEL
			DEFINE SBUTTON FROM 20 ,200  TYPE 2 ACTION oDlgLT:End() ENABLE OF oDlgLT PIXEL
			ACTIVATE MSDIALOG oDlgLT VALID (nOAT := oQual:nAT,.t.)

			If _nOpca ==1
				AADD(_aRetorno,aArrayF4[nOAT][01])
				AADD(_aRetorno,aArrayF4[nOAT][02])
				AADD(_aRetorno,aArrayF4[nOAT][03])
				AADD(_aRetorno,aArrayF4[nOAT][04])
				AADD(_aRetorno,aArrayF4[nOAT][07])
			Endif
		Else
			AVISO("Verifique se o Numero Digitado esta Correto","Notas fiscais nao encontradas",{"OK"})
		Endif
	Endif
	RestArea(_aAreaAtu)
//SetFocus(nHdl)

Return _aRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ExpExcel ºAutor  ³ Anderson Messias   º Data ³  21/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exportar Excel                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DeltaDecisao                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExpExcel(_aHeader,_Acols)

	Local nI := 0

	DEFAULT _aHeader := {}
	DEFAULT _Acols   := {}

	aHeadExc := {}

	For nI := 1 to Len(_aHeader)
		aadd(aHeadExc,{_aHeader[nI][2],_aHeader[nI][8],_aHeader[nI][4],_aHeader[nI][5]})
	Next

	u_DELTAXLS(aHeadExc,_Acols)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TotConhecºAutor  ³ Anderson Messias   º Data ³  15/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Totaliza dados por Conhecimento                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DeltaDecisao                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TotConhec()

	Local _aArea	:= GetArea()
	Local _cCTO		:= aCols[n,_nPosCto]
	Local nI
	local _nFrTra   := 0
	Local _nFrCal   := 0
	Local _nTaxaCto := 0
	Local _nValPeda := 0
	Local _nOtrTaxa := 0
	Local _nGris    := 0
	Local _nAdValor := 0
	Local _nVlPes	:= 0
	Local _nTxPes   := 0
	Local _nFrTol   := 0
	Local _nTDE     := 0
	Local _nTRT 	:= 0
	Local _nPesoCub := 0
	//Local _nVlPes   := 0
	Local _nAdPes   := 0

	Local _nIGris   := 0
	Local _nIAdValor:= 0
	Local _nITaxaCto:= 0
	Local _nIValPeda:= 0
	Local _nIOtrTaxa:= 0
	Local _nIVlPes  := 0
	Local _nAdVlPes	:= 0

	_lImp := .F.
	For nI := 1 to len(aCols)
		if _cCTO == aCols[nI,_nPosCto]
			if aCols[nI,GDFIELDPOS("PAV_IMPORT",aHEADER)] == "S"
				//Vejo se existe alguma linha importada no resumo para apresentar valores
				_lImp := .T.
			endif

			_nFrTra   += aCols[nI,_nPosFrTra]
			_nFrCal   += aCols[nI,_nPosFrCal]
			_nTaxaCto += aCols[nI,_nPosTxCto]
			_nValPeda += aCols[nI,_nPosVlPed]
			_nOtrTaxa += aCols[nI,_nPosOtrTx]
			_nGris    += aCols[nI,_nPosVlGri]
			_nAdValor += aCols[nI,_nPosAdVal]
			_nVlPes	  += aCols[nI,_nPosVlPes]
			_nTxPes   += aCols[nI,_nPosTxPes]
			_nFrTol   += aCols[nI,_nPosFrTol]
			_nTDE     += aCols[nI,_nPosTDE  ]
			_nTRT 	  += aCols[nI,_nPosTRT  ]
			_nPesoCub += aCols[nI,_nPosPesoCub ]
			_nAdPes   += aCols[nI,_nPosAdPes ]

			_nIGris   += aCols[nI,GDFIELDPOS("PAV_IVLGRI",aHEADER) ]
			_nIAdValor+= aCols[nI,GDFIELDPOS("PAV_IADVAL",aHEADER) ]
			_nITaxaCto+= aCols[nI,GDFIELDPOS("PAV_ITXACT",aHEADER) ]
			_nIValPeda+= aCols[nI,GDFIELDPOS("PAV_IVLRPE",aHEADER) ]
			_nIOtrTaxa+= aCols[nI,GDFIELDPOS("PAV_IOTRTX",aHEADER) ]
			_nIVlPes  += aCols[nI,GDFIELDPOS("PAV_IVLPES",aHEADER) ]

		endif

	Next

	DEFINE MSDIALOG oDlgTot FROM	09,0 TO iif(!_lImp,21,27),77 TITLE "Resumo Nota Fiscal" OF oMainWnd

	@ 002,005 SAY "** ABAIXO VALORES CALCULADOS ***********************************************************************"	 	SIZE 350,07          OF oDlgTot PIXEL

	@ 010,005 SAY "Peso Cubagem" 	SIZE 055,07          OF oDlgTot PIXEL
	@ 018,005 MSGET _nPesoCub      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

	@ 010,065 SAY "Total Transp." 	SIZE 055,07          OF oDlgTot PIXEL
	@ 018,065 MSGET _nFrTra      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 010,125 SAY "Total Calc." 	SIZE 055,07          OF oDlgTot PIXEL
	@ 018,125 MSGET _nFrCal      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 010,185 SAY "Valor Gris"	 	SIZE 055,07          OF oDlgTot PIXEL
	@ 018,185 MSGET _nGris      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 010,245 SAY "Ad Valorem" 		SIZE 055,07          OF oDlgTot PIXEL
	@ 018,245 MSGET _nAdValor      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 030,005 SAY "Frete Peso" 		SIZE 055,07          OF oDlgTot PIXEL
	@ 038,005 MSGET _nVlPes      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

	@ 030,065 SAY "Ad. Valor Peso" 	SIZE 055,07          OF oDlgTot PIXEL
	@ 038,065 MSGET _nAdVlPes     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 030,125 SAY "Ad. Peso"  		SIZE 055,07          OF oDlgTot PIXEL
	@ 038,125 MSGET _nAdPes      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 030,185 SAY "fr Tonelada"	 	SIZE 055,07          OF oDlgTot PIXEL
	@ 038,185 MSGET _nFrTol      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 030,245 SAY "T.D.E."	 		SIZE 055,07          OF oDlgTot PIXEL
	@ 038,245 MSGET _nTDE   	   	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 050,005 SAY "T.R.T" 			SIZE 055,07          OF oDlgTot PIXEL
	@ 058,005 MSGET _nTRT 	     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"

	@ 050,065 SAY "Taxa Conhecimento" SIZE 055,07          OF oDlgTot PIXEL
	@ 058,065 MSGET _nTaxaCto      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 050,125 SAY "Pedagio"  		SIZE 055,07          OF oDlgTot PIXEL
	@ 058,125 MSGET _nValPeda      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	@ 050,185 SAY "Outras Taxas" 	SIZE 055,07          OF oDlgTot PIXEL
	@ 058,185 MSGET _nOtrTaxa      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

	if _lImp
		//****************** Totais importados ******************
		@ 082,005 SAY "** ABAIXO VALORES IMPORTADOS VIA EDI - PROCEDA *********************************************************"	 	SIZE 350,07          OF oDlgTot PIXEL

		@ 090,005 SAY "Valor Gris"	 	SIZE 055,07          OF oDlgTot PIXEL
		@ 098,005 MSGET _nIGris      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

		@ 090,065 SAY "Ad Valorem" 		SIZE 055,07          OF oDlgTot PIXEL
		@ 098,065 MSGET _nIAdValor     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

		@ 090,125 SAY "Taxa Conhecimento" SIZE 055,07          OF oDlgTot PIXEL
		@ 098,125 MSGET _nITaxaCto     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

		@ 090,185 SAY "Pedagio"  		SIZE 055,07          OF oDlgTot PIXEL
		@ 098,185 MSGET _nIValPeda     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

		@ 090,245 SAY "Outras Taxas" 	SIZE 055,07          OF oDlgTot PIXEL
		@ 098,245 MSGET _nIOtrTaxa     	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.99"

		@ 110,005 SAY "Frete Peso" 		SIZE 055,07          OF oDlgTot PIXEL
		@ 118,005 MSGET _nIVlPes      	SIZE 055,09 WHEN .F. OF oDlgTot PIXEL PICTURE "@E 999,999,999.9999"
	endif

	@ iif(!_lImp,072,118),245 BUTTON OemToAnsi("Sair") SIZE 50,12 FONT oDlgTot:oFont ACTION oDlgTot:End() OF oDlgTot PIXEL

	ACTIVATE MSDIALOG oDlgTot

	RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BuscaProdºAutor  ³ Anderson Messias   º Data ³  27/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca produto pela CFOP para dar entrada no conhecimento   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DeltaDecisao                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BuscaProd(_cNF,_cSerie,_tipoPav)

	Local _cProd := Alltrim(GetMV("MV_XFREPR"))
	DBSelectArea("SD2")
	DBSetOrder(3)
	if DBSeek(xFilial("SD2")+_cNF+_cSerie)
		_cCF := Substr(SD2->D2_CF,2)
		DBSelectArea("SX5")
		DBSetOrder(1)
		if DBSeek(xFilial("SX5")+"ZA"+_cCF)
			_cProd := alltrim(SX5->X5_DESCRI)
		elseif DBSeek(xFilial("SX5")+"ZA***") //Qualquer CFOP que nao tiver na lista será considerada como venda
			_cProd := alltrim(SX5->X5_DESCRI)
		endif
	endif
	If _tipoPav = "R" // ReEntrega
		DBSelectArea("SX5")
		DBSetOrder(1)
		If DBSeek( xFilial("SX5") + "ZA" + _tipoPav )
			_cProd := alltrim(SX5->X5_DESCRI)
		EndIf
	EndIf

Return _cProd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CONFCONH ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CONFCONH(xAutoCab,xAutoItens,nOpcAuto)

	Local aCores :=	{{"alltrim(PAV_FATURA) == '' ","ENABLE" 	} ,{"alltrim(PAV_FATURA) <> '' ","DISABLE"	}}

	PRIVATE	_cFatura
	PRIVATE _cTipo
	PRIVATE _lFatura
	PRIVATE _cOperacao
	PRIVATE _cCgcTra
	PRIVATE	_cTransp
	PRIVATE _nValor
	PRIVATE _dEmissao
	PRIVATE _dVencto
	PRIVATE _nDesconto
	PRIVATE _nAjuste
	PRIVATE _nRetorno
	PRIVATE _cAlias
	PRIVATE _nPosSer
	PRIVATE _nPoscgc
	PRIVATE _nPosTipo
	PRIVATE _nPosNF
	PRIVATE _nPosCto
	PRIVATE _nPosFrTra
	PRIVATE _nPosFrCal
	PRIVATE _nPosTxCto
	PRIVATE _nPosVlPed
	PRIVATE _nPosOtrTx
	PRIVATE _nPosVlGri
	PRIVATE _nPosAdVal
	PRIVATE _nPosVlPes
	PRIVATE _nPosAdPes
	PRIVATE _nPosTxPes
	PRIVATE _nPosFrTol
	PRIVATE _nPosCont
	PRIVATE _nPosTDE
	PRIVATE _nPosTRT
	PRIVATE _nPosPesoCub
	PRIVATE _nPosVlAjus
	PRIVATE _nPosCliFor
	PRIVATE _nPosSeqCon
	//PRIVATE _nPosCliFor
	PRIVATE _nPosLoja
	PRIVATE _lAltValor := .F.
	PRIVATE _lAltera := .F.
	PRIVATE cCadastro:= "Manutencao de Conhecimento de Frete"
	PRIVATE cPerg   := PADR("CONFRE",10)
	PRIVATE lAutoConF   := xAutoCab <> NIL .And. xAutoItens <> NIL
	PRIVATE aAutoCab   := {}
	PRIVATE aAutoItens := {}

	PRIVATE aRotina := 	{ {OemToAnsi("Pesquisar"),"AxPesqui"  , 0 , 1},;	//"Pesquisar"
	{OemToAnsi("Visualizar"),"U_COVISUAL", 0 , 2},	;	//"Visualizar"
	{OemToAnsi("Incluir"),"U_COINC", 0 , 3},		;	//"Incluir"
	{OemToAnsi("Alterar"),"U_COALT", 0 , 4},		;	//"Alterar"
	{OemToAnsi("Excluir"),"U_COEXC", 0 , 5},		;	//"Excluir"
	{OemToAnsi("Legenda"),"U_CONFCOLG", 0 , 3}}	//"LEGENDA"

	If xAutoCab <> Nil
		DEFAULT nOpcAuto := 3
		aAutoCab   := xAutoCab
		aAutoItens := xAutoItens
		lAutoConF := .T.
		MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"PAV")
		xAutoCab   := aAutoCab
		xAutoItens := aAutoItens
	Else
		DBSelectArea("PAV")
		_cFiltro	:= " PAV_FATURA = '' "
		mBrowse(06, 01, 22, 75, "PAV",,"PAV_LIBERA",,,,aCores,,,,,,,, _cFiltro)
	endif

RETURN


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Legenda do Browser.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CONFCOLG

BrwLegenda(cCadastro,"Legenda",	{;
{"ENABLE" ,"Conhecimento Pendente"},;
{"DISABLE","Conhecimento em Fatura"}})
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COVISUAL ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Visualizacao De Conhecimentos de Frete                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COVISUAL()
	Local _aArea := GetArea()

	MontaTela("V",'C')
	RestArea(_aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COINC    ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclusao De Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COINC(cAlias,nReg,nOpc)

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())

	Private aCols	:={}
	Private aHeader :={}

	If MontaTela("I","C") == 1
		fGravaPAV(.T.,.F.,.F.,"C")
	Endif

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COALT    ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Alteracao De Conhecimentos de Frete                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COALT()

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())

	Private aCols	:={}
	Private aHeader :={}

	_lLiber	:= JaLiberada(PAV->PAV_FATURA,PAV->PAV_CODTRA)
	If _lLiber
		Aviso("ATENCAO","Fatura ja Esta Liberada , Estorne a Liberacao ",{"OK"},3,"Alteracao Nao permitida ")
		Return
	Endif

	_lAltera := .T.
	If MontaTela("A",'C') == 1
		fGravaPAV(.F.,.F.,.T.,"C")
	Endif
	_lAltera := .F.

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COEXC    ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclusao De Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COEXC()

	Local aSavATU := GetArea()
	Local aSavPAV := PAV->(GetArea())

	Private aCols	:={}
	Private aHeader :={}

	_lLiber	:= JaLiberada(PAV->PAV_FATURA,PAV->PAV_CODTRA)
	If _lLiber
		Aviso("ATENCAO","Fatura ja Esta Liberada , Estorne a Liberacao ",{"OK"},3,"Exclusao Nao permitida")
		Return
	Endif
	If MontaTela("E","C") == 1
		If MsgYesno("Confirma a exclusao ?","Exclusao de fatura de Frete")
			fGravaPAV(.F.,.T.,.F.,"C")
		Endif
	Endif

	RestArea(aSavPAV)
	RestArea(aSavATU)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COEXC    ³ Autor ³ Anderson Messias      ³ Data ³ 22/03/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclusao De Conhecimentos de Frete                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ DeltaDecisao                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MsgErro(cMsg,cTitulo)

	DEFAULT cMsg := ""
	DEFAULT cTitulo := ""

	if lAutoConF == Nil
		lAutoConF := .F.
	endif

	if !lAutoConF
		MsgStop(cMsg,cTitulo)
	else
		AutoGrLog(cMsg)
	endif

	lMsErroAuto := .T.

Return



User Function ExAutoCON()

	RpcSetType(3)
	RPCSetEnv("03","01") //Posiciono na empresa 01 e filial 01 pois é onde está configurado o workflow de envio do email

	aCab := {}
	aadd(aCab,{"PAV_CODTRA","000743",Nil})
	aadd(aCab,{"PAV_TIPO","V",Nil})

	aItem := {}
	aadd(aItem,{"PAV_SERIE","1  ",Nil})
	aadd(aItem,{"PAV_NF","28027",Nil})
	aadd(aItem,{"PAV_CTO","642530",Nil})
	aadd(aItem,{"PAV_EMICTO",Date(),Nil})
	aadd(aItem,{"PAV_FRETRA",243.88,Nil})
	aadd(aItem,{"PAV_PESOCU",59.00,Nil})
	aItens := {}
	aadd(aItens,aItem)

	aItem := {}
	aadd(aItem,{"PAV_NF","28030",Nil})
	aadd(aItem,{"PAV_CTO","642530",Nil})
	aadd(aItem,{"PAV_PESOCU",1,Nil})
	aadd(aItem,{"PAV_FRETRA",1,Nil})
	aadd(aItem,{"PAV_EMICTO",Date(),Nil})
	aadd(aItens,aItem)

	aItem := {}
	aadd(aItem,{"PAV_NF","28035",Nil})
	aadd(aItem,{"PAV_CTO","642530",Nil})
	aadd(aItem,{"PAV_PESOCU",1,Nil})
	aadd(aItem,{"PAV_FRETRA",1,Nil})
	aadd(aItem,{"PAV_EMICTO",Date(),Nil})
	aadd(aItens,aItem)

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| u_CONFCONH(x,y,z)},aCab,aItens,3)
	If lMsErroAuto //.AND. __nOpcao <> 5
		DisarmTransaction()
		MostraErro()
	else
		AutoGrLog("Operação concluida com sucesso!")
		MostraErro()
	EndIf

	RPCClearEnv()

Return


User Function ExAutoFAT()

	RpcSetType(3)
	RPCSetEnv("03","01") //Posiciono na empresa 01 e filial 01 pois é onde está configurado o workflow de envio do email

	aCab := {}
//aadd(aCab,{"PAV_FATURA","000000002",Nil})
	aadd(aCab,{"PAV_CODTRA","000743",Nil})
	aadd(aCab,{"PAV_TIPO","V",Nil})
//aadd(aCab,{"PAV_FRETRA",100,Nil})
//aadd(aCab,{"PAV_EMISFA",STOD("20120327"),Nil})
//aadd(aCab,{"PAV_VENCFA",STOD("20120327"),Nil})

	aItem := {}
	aadd(aItem,{"PAV_NF","1  ",Nil})
	aadd(aItem,{"PAV_NF","000028035",Nil})
	aadd(aItem,{"PAV_CTO","000642532",Nil})
	aadd(aItem,{"PAV_EMICTO",Date(),Nil})

	aItens := {}
	aadd(aItens,aItem)

	lMsErroAuto := .F.
	MSExecAuto({|x,y,z| u_CONFRETE(x,y,z)},aCab,aItens,3)
	If lMsErroAuto //.AND. __nOpcao <> 5
		DisarmTransaction()
		MostraErro()
	else
		AutoGrLog("Operação concluida com sucesso!")
		MostraErro()
	EndIf

	RPCClearEnv()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SELCONHE ºAutor  ³Anderson Messias    º Data ³  15/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Selecionar conhecimentos                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CASABRASIL                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SELCONHE()

Local aSavPAV   := PAV->(GetArea())

Local oDlgSelCon
//Local oCBX
//Local oBigGet
Local nPercTela  := 0.80
Local _nDesconto := 0
Local _nAjuste   := 0
Local _nValor    := 0

//Local lSeek    	:= .F.

Local aInfo		:= { aSize[1]*nPercTela, aSize[2]*nPercTela, aSize[3]*nPercTela, aSize[4]*nPercTela, 3, 3 }
Local aObjects	:= {}
Local aPosObj   := {}
Local aPosGet1  := {}
Local oFold1   	:= 1

Local nOpcSele  := 0
Local bOk		:= 	{|| Iif(U_SELCONRET(), (nOpcSele := 1, oDlgSelCon:End()), nOpcSele := 0)}
Local bCancel	:=	{|| nOpcSele := 3, oDlgSelCon:End()}
Local aButtons	:= 	{}
Local aSavATU   := GetArea()
Local nX := 0

private _cFilePAV
Private oBrwPerf
Private _cMarca	  := GetMark()
Private _lInverte := .F.
Private aSavSX3   := SX3->(GetArea())
Private _aCampos  := {}
Private _aTitulos := {}
Private _cFileDZA

aAdd( aObjects, {100,100, .T., .T.})

aPosObj  		:= MsObjSize( ainfo, aObjects )
aPosGet1 		:= { aPosObj[1,1], aPosObj[1,2], aPosObj[1,3], (aPosObj[1,4]) }

DEFINE DIALOG oDlgSelCon TITLE OemToAnsi("Conhecimentos") FROM 00,00 to aSize[6]*nPercTela,aSize[5]*nPercTela PIXEL

oFold1 			:= TFolder():New( aPosObj[1,1],aPosObj[1,2],{"Selecao de Conhecimentos"},{},oDlgSelCon,,,,.T.,.T.,(aPosObj[1,4])-5,(aPosObj[1,3]))

//GetPerfil(oFold1)
dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbSeek("PAV"))
aadd(_aTitulos,{"PAV_OK",    , "", "@!"})
aadd(_aCampos ,{"PAV_OK", "C", 02, 0   })
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "PAV"
	//If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .AND. SX3->X3_BROWSE == "S"
	//if Alltrim(SX3->X3_CAMPO) $ "DZB_ITEM/DZB_CPROD/DZB_NPROD/DZB_GPROD/DZB_FPROD/DZB_P1/DZB_P2/DZB_P3/DZB_P4/DZB_P5/DZB_P6/DZB_QTDE"
	aadd(_aTitulos,{Alltrim(SX3->X3_CAMPO),,SX3->X3_TITULO,SX3->X3_PICTURE})
	aadd(_aCampos ,{Alltrim(SX3->X3_CAMPO),SX3->X3_TIPO, SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	//endif
	//Endif
	SX3->(DBSkip())
	EndDo

	If Select("TPAV") <= 0
	CriaTPAV()
	Endif

_cQuery := "SELECT '  ' as PAV_OK, R_E_C_N_O_ AS PAV_RECNO FROM "+RetSQLName("PAV")+" WHERE D_E_L_E_T_='' AND PAV_FATURA='' AND PAV_CODTRA='"+_cTransp+"' ORDER BY PAV_CTO, PAV_NF "
	If Select("TSQL") <> 0
	DbSelectArea("TSQL")
	DbCloseArea()
	Endif
TCQUERY _cQuery NEW ALIAS "TSQL"
DBSelectArea("TSQL")

	if !TSQL->(Eof()) .AND. !TSQL->(Bof())
	
	//Se alteração atualizo variaveis para bloqueio de alteração
	_nDesconto	:= 0
	_nAjuste	:= 0
	_laCols		:= .F.
	
	//Tratamento para alteração
	//Localizo o que tem no banco, populo, depois vejo no arrey o que deve se mudar com o numero do conhecimento + nota fiscal - Nao implementado ainda no execauto
		While !TSQL->(Eof())
		//Posiciono a PAV pelo Recno para pegar os campos, pois agora com campo memo nao vem na query
		DBSelectArea("PAV")
		DBSetOrder(1)
		DBGoTo(TSQL->PAV_RECNO)
		
		_nDesconto	:= _nDesconto + PAV->PAV_DESCON
		_nAjuste	:= _nAjuste + PAV->PAV_AJUST
		_nValor		:= _nValor + PAV->PAV_FRETRA
		
		//Atualiza o ajuste conforme o desconto
		PAV->(RecLock("PAV",.F.))
		PAV->PAV_AJUST := PAV->PAV_DESCON
		PAV->(MsUnlock())		
		
		DBSelectArea("TPAV")
		RecLock("TPAV",.T.)
			For nX := 1 To FCount()
				if alltrim(FieldName(nX)) == "PAV_OK"
				&("TPAV->"+FieldName(nX)) := &("TSQL->PAV_OK")
				else
				&("TPAV->"+FieldName(nX)) := &("PAV->"+FieldName(nX))
				endif
			Next nX
		msunlock()
		
		TSQL->(dbSkip())
		Enddo
	endif

DbSelectArea("TPAV")
TPAV->(DbGoTop())

oBrwPerf := MsSelect():New( "TPAV","PAV_OK",,_aTitulos,@_lInverte,@_cMarca,{5,5,(oFold1:aDialogs[1]:nClientHeight/2)-15,(oFold1:aDialogs[1]:nClientWidth/2)-10},,,oFold1:aDialogs[1])
oBrwPerf:oBrowse:lHasMark := .F.
oBrwPerf:oBrowse:lCanAllMark := .F.

oDlgSelCon:Activate(,,,,,,{|| EnchoiceBar( oDlgSelCon, bOk , bCancel , , aButtons ) } )

	If Select("TPAV") > 0
	DelTPAV()
	endif

	If Select("TSQL") <> 0
	DbSelectArea("TSQL")
	DbCloseArea()
	Endif

RestArea(aSavSX3)
RestArea(aSavPAV)
RestArea(aSavATU)

DBSelectArea("PAV")

Return(Nil)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SELCONRETºAutor  ³Anderson Messias    º Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Enviando registros selecionados                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function SELCONRET

Local lRet := .T.
Local aColsAux := {}
Local nI := 0

aColsAnt := aClone(aCols)
//aCols    := aClone(oGet:aCols)
//aHeader  := aClone(oGet:aHeader)

	if Len(aCols) > 0
	aSort(aCols,,,{|x,y| x[GDFIELDPOS("PAV_NF",aHeader)]+x[GDFIELDPOS("PAV_CTO",aHeader)] < y[GDFIELDPOS("PAV_NF",aHeader)]+y[GDFIELDPOS("PAV_CTO",aHeader)]})
	endif

	For nI := 1 to Len(aCols)
		if Len(alltrim(aCols[nI][GDFIELDPOS("PAV_NF",aHeader)])) <> 0
		aadd(aColsAux,aCols[nI])
		endif
	Next

aCols := aClone(aColsAux)

DBSelectArea("TPAV")
DBGoTop()
	While !TPAV->(Eof())
	nPosNF := Ascan(aCols,{|x| x[GDFIELDPOS("PAV_NF",aHeader)]+x[GDFIELDPOS("PAV_CTO",aHeader)] == TPAV->PAV_NF+TPAV->PAV_CTO })
	lMarcado := TPAV->PAV_OK == _cMarca
		if nPosNF == 0
			if lMarcado
			aadd(aCols,Array(Len(aHeader)+1))
			n := Len(aCols)
				For nI := 1 to Len(aHeader)
					if Type("TPAV->"+aHeader[nI][2]) <> "U"
					aCols[n][nI] := &("TPAV->"+aHeader[nI][2])
					else
					aSavSX3 := SX3->(GetArea())
					DBSelectArea("SX3")
					DBSetOrder(2)
						if DBSeek(aHeader[nI][2])
						aCols[n][nI] := CriaVar(aHeader[nI][2])
						endif
					RestArea(aSavSX3)
					endif
				Next
			aCols[n][Len(aHeader)+1] := .F.
			endif
		else
			if lMarcado
			aCols[nPosNF][Len(aHeader)+1] := .F.
			else
			aCols[nPosNF][Len(aHeader)+1] := .T.
			endif
		endif
	TPAV->(DBSkip())
	EndDo

/*
//Executando todos os gatilhos da rotina.
	For nX := 1 to Len(aCols)
		For nI := 1 to Len(aHeader)
			If ExistTrigger(aHeader[nI][2])
n := nX
RunTrigger(2,n,Nil,,aHeader[nI][2])
			Endif
		Next
	Next

aSort(aCols,,,{|x,y| strZero(x[GDFIELDPOS("BM_ORDEM",aHeader)],2)+x[GDFIELDPOS("DZB_CPROD",aHeader)] < strZero(y[GDFIELDPOS("BM_ORDEM",aHeader)],02)+y[GDFIELDPOS("DZB_CPROD",aHeader)]})

oGetDZB:aCols  := aClone(aCols)
oGetDZB:aHeader:= aClone(aHeader)
oGetDZB:Refresh()

//Validação do MSNEWGETDADOS
	For nX := 1 to Len(oGetDZB:aCols)
oGetDZB:nAt := Nx
U_CVM01G01(oGetDZB:aCols[oGetDZB:nAt][GDFIELDPOS("DZB_PDESCI",oGetDZB:aHeader)])
lRet := oGetDZB:ChkObrigat(nX)
		if !lRet
Return lRet
		Endif
	Next

//Restaurando aCols Original
	if Len(oGetDZB:aCols) == 0
oGetDZB:aCols := aClone(aColsAnt)
	endif
*/

	oGet:Refresh()
	oDlg:Refresh()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaTPAV ºAutor  ³ Anderson Messias   º Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que seleciona os conhecimentos importados           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaTPAV()

	If Select("TPAV") > 0
		Return .T.
	EndIf

	_cFilePAV := CriaTrab(_aCampos,.T.)
	dbUseArea( .T.,__LocalDriver, _cFilePAV, "TPAV", .T., .F. )
	IndRegua("TPAV", _cFilePAV, "PAV_CODTRA+PAV_CTO+PAV_NF",,,"Selecionando Registros...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DelTPAV  ºAutor  ³ Anderson Messias   º Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que deleta temporaria criada                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DelTPAV()

	DBSelectArea("TPAV")
	DBCloseArea()
	fErase(_cFilePAV+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Ajusta   ºAutor  ³ Anderson Messias   º Data ³  15/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que monta tela para ajuste do conhecimento          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ajusta()

	Local cObsM    := aCols[n,GDFIELDPOS("PAV_OBSAJU",aHEADER)]
	Local cUser    := alltrim(Substr(cUsuario,7,15))
	Local nVlAjust := aCols[n,GDFIELDPOS("PAV_DESCON",aHEADER)]

	DEFINE MSDIALOG oDlgAju FROM 0,0 TO 230,360 TITLE "Ajuste do conhecimento" PIXEL

	@ 10,003 SAY "Usuario" OF oDlgAju PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ 10,035 MSGET oUser VAR cUser PIXEL SIZE 60,10 OF oDlgAju PIXEL WHEN .F.

	@ 25,003 SAY "Valor Ajuste" OF oDlgAju PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ 25,035 MSGET oVlAjust VAR nVlAjust PIXEL SIZE 60,10 OF oDlgAju PIXEL WHEN .F.

	@ 40,003 SAY "Observacao" OF oDlgAju PIXEL Color CLR_BLACK,CLR_WHITE PIXEL
	@ 40,035 GET oObsM	VAR cObsM MEMO SIZE 140,50 PIXEL OF oDlgAju Valid !Empty(cObsM)

	DEFINE SBUTTON FROM 95,080 TYPE 1 ACTION (nOk := 1,oDlgAju:End()) ENABLE OF oDlgAju
	DEFINE SBUTTON FROM 95,110 TYPE 2 ACTION (nOk := 0,oDlgAju:End()) ENABLE OF oDlgAju
	DEFINE SBUTTON FROM 95,140 TYPE 3 ACTION (nOk := 2,oDlgAju:End()) ENABLE OF oDlgAju

	ACTIVATE MSDIALOG oDlgAju CENTERED

	if nOk == 1
		aCols[n,GDFIELDPOS("PAV_OBSAJU",aHEADER)] := cObsM
		aCols[n,GDFIELDPOS("PAV_APROVA",aHEADER)] := cUser
		aCols[n,GDFIELDPOS("PAV_AJUST",aHEADER)]  := nVlAjust
	endif

	if nOk == 2
		if MsgYESNO("Confirma cancelamento do ajuste do conhecimento?")
			aCols[n,GDFIELDPOS("PAV_OBSAJU",aHEADER)] := ""
			aCols[n,GDFIELDPOS("PAV_APROVA",aHEADER)] := ""
			aCols[n,GDFIELDPOS("PAV_AJUST",aHEADER)]  := 0
		endif
	endif

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o    ³VALIDPERG ³ Autor ³ Anderson Messias      ³ Data ³ 10/03/11 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ TAIFF                                                      ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VALIDPERG(cPerg)

	cPerg := PADR(cPerg,10)

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
	PutSx1(cPerg,"01","CNPJ/CPF ?","","","mv_ch1","C",14,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return Nil
