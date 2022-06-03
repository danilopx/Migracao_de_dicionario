#include "rwmake.ch"
#include "TOPCONN.ch"
#include "PROTHEUS.CH"

#DEFINE CRLF Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTRL003   ºAutor  ³Edinilson-Trade    º Data ³  15/05/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio para amarração NF X SERIAL NUMBER                 º±±
±±º          ³Solicitado por Humberto - PCP                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function ESTRL003()

	Local aSay		  := {}
	Local aButton	  := {}
	Local o			  := Nil
	Local oWnd
	Local nOpcao	  := 0
	LOCAL cString

	Private cDesc1		:= "Geração de Planilha com Nota Fiscal x Serial Number"
	Private cDesc2		:= ""
	Private cCadastro := OemToAnsi("Planilha Excel - Nota Fiscal x Serial Number")
	PRIVATE nomeprog  := "ESTRL003"
	PRIVATE aLinha    := { },nLastKey := 0
	Private cPerg	  := "ESTRL003"		// Pergunta do Relatorio
	Private oProcess

	oWnd		  := Nil
	cString     := "SD2"

	cPerg := PADR(cPerg,10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Validperg()

	pergunte(cPerg,.F.)

	aAdd(aSay,cDesc1)
	aAdd(aSay,cDesc2)

	aADD(aButton, { 5,.T.,{|| Pergunte(cPerg,.T.) } } )
	aAdd(aButton, { 1,.T.,{|o| nOpcao := 1,o:oWnd:End() } } )
	aAdd(aButton, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch(cCadastro,aSay,aButton)

	If  nOpcao == 1 .AND. MV_PAR01=1
		oProcess := MsNewProcess():New( { | lEnd | F_OSPROCES() }, "Processando", "Aguarde, selecionando Ordem de Separacao ...", .F. )
		oProcess:Activate()
	ElseIf  nOpcao == 1 .AND. MV_PAR01=2
		oProcess := MsNewProcess():New( { | lEnd | F_PROCESSA() }, "Processando", "Aguarde, selecionando Nota Fiscal ...", .F. )
		oProcess:Activate()
	ElseIf  nOpcao == 1 .AND. MV_PAR01 = 3
		msgalert("RELATÓRIO EM CONSTRUCAO")
	EndIf
Return nil

Return

Static Function F_OSPROCES()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Private oFwMsEx    := NIL
	Private cArq       := ""
	Private cDir       := GetSrvProfString("Startpath","")
	Private cWorkSheet := ""
	Private cTable     := ""
	Private cDirTmp    := GetTempPath()  //retorna o temporario no start path
	Private cArqTMP    := ""

	cQuery := "SELECT CB8.*,CB7_DTEMIS,CB7__NOME,SB1.B1_DESC,SC5.C5_NUM,SC5.C5_NUMORI,C5_NOMCLI  "		    	    + CRLF
	cQuery += "FROM"																+ CRLF
	cQuery += "	" + RETSQLNAME("CB8") + " CB8 WITH(NOLOCK) " 						+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("CB7") + " CB7 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON CB7_FILIAL	= '02'" 		+ CRLF
	cQuery += "			AND	CB7.CB7_ORDSEP		= CB8.CB8_ORDSEP" 		+ CRLF
	cQuery += "			AND CB7.D_E_L_E_T_	= ''" 		+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("SB1") + " SB1 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON SB1.B1_FILIAL	= '" + XFILIAL("SB1") + "'" 	        + CRLF
	cQuery += "			AND	SB1.B1_COD		= CB8.CB8_PROD"							+ CRLF
	cQuery += "			AND SB1.D_E_L_E_T_	= ''"									+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("SC5") + " SC5 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON SC5.C5_FILIAL	= CB8.CB8_FILIAL" 		             	+ CRLF
	cQuery += "			AND	SC5.C5_NUM		= CB8.CB8_PEDIDO"						+ CRLF
	cQuery += "			AND SC5.D_E_L_E_T_	= ''"									+ CRLF
	cQuery += " WHERE CB8_ORDSEP >= '"+ MV_PAR06 +"' "									+ CRLF
	IF .NOT. EMPTY(MV_PAR07)
		cQuery += " AND CB8_ORDSEP <= '"+ MV_PAR07 +"' "									    + CRLF
	ELSE
		cQuery += " AND CB8_ORDSEP <= 'ZZZZZZ' "									    + CRLF
	ENDIF
	cQuery += " AND CB8_FILIAL = '02' " 									+ CRLF
	cQuery += " AND CB8.D_E_L_E_T_ = ' ' " 											+ CRLF
	cQuery += " ORDER BY CB8_ORDSEP,CB8_ITEM "											+ CRLF

	MEMOWRITE( "ESTRL003_ORDENS_DE_SEPARACAO.SQL",cQuery)

	If  Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TMP1"

	oFwMsEx := FWMsExcel():New()

	cWorkSheet := "OS x Serial Number"
	cTable     := "Ordem de Separacao x Serial Number - Data : " + DTOC(DDATABASE)

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )
// 1-General,2-Number,3-Monetário,4-DateTime

	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem de Separacao"       , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Onda"             , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"            , 1,1)

	oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"         , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Lote Fabricação"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Fabricação"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Número da Caixa"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Serial Number"     , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem de Separação", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido de Venda"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Item do Pedido"    , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem de Produção" , 1,1)

	_Vez1    := .T.
	_ImpProd := .T.

	DbSelectArea("TMP1")
	count to nCount
	DBGOTOP()

	oProcess:SetRegua1(nCount)

	While .not. eof()

		oProcess:IncRegua1( "Processando OS "+ TMP1->CB8_ORDSEP )

		//VERIFICA A QUANTIDADE DE PASTAS CONFORME GROUPO DE CANAIS
		cQuery := "SELECT CB7_FILIAL,CB7_ORDSEP,CB7_PEDORI,CB7_CLIORI,CB7_LOJORI, " + CRLF
		cQuery += "ZA4_FILIAL,ZA4_COD,ZA4_NSERIE,ZA4_DSCETQ,ZA4_DTFAB,ZA4_NCAIXA,ZA4_NLOTE,ZA4_NUMOP,ZA4_SERIAL,ZA4_OPITEM,ZA4_OPSEQ,ZA4_PEDIDO,ZA4_ORDSEP " + CRLF
		cQuery += "FROM CB7030 CB7 (NOLOCK) "				+ CRLF
		cQuery += "	INNER JOIN ZA4040 ZA4 WITH(NOLOCK) " + CRLF
		cQuery += "	ON ZA4.ZA4_FILIAL	= '02' "   		+ CRLF
		cQuery += "	AND ZA4.D_E_L_E_T_ = ' ' "	        + CRLF
		cQuery += "	AND ZA4.ZA4_ORDSEP = CB7_ORDSEP "	        + CRLF
		cQuery += "	AND ZA4_PRCOM = '" + ALLTRIM(TMP1->CB8_PROD) + "' "		+ CRLF
		//cQuery += "	AND RIGHT(ZA4.ZA4_DTFAB,4) ='2019' "	+ CRLF
		cQuery += "WHERE "
		cQuery += "CB7_ORDSEP = '" + TMP1->CB8_ORDSEP + "' "		+ CRLF
		cQuery += "AND CB7.D_E_L_E_T_ = '' " 				+ CRLF
		cQuery += "AND CB7_FILIAL = '02' " 					+ CRLF

		MEMOWRITE( "ESTRL003_ETIQUETAS.SQL",cQuery)

		If   Select("TZA4") > 0
			DbSelectArea("TZA4")
			DbCloseArea()
		Endif

		TCQUERY cQuery NEW ALIAS "TZA4"
		Count to nCount
		oProcess:SetRegua2(nCount)

		DbSelectArea("TZA4")
		dbGoTop()
		While .not. eof()

			oProcess:IncRegua2( "Produto "+ TMP1->CB8_PROD + " Serial Nuber "+TZA4->ZA4_NSERIE)

			IF  _Vez1
				_cDoc    := TMP1->CB8_ORDSEP
				_cSerie  := TMP1->CB7__NOME
				_cEmisso := DTOC((STOD(TMP1->CB7_DTEMIS)))
				_cCliente:= TMP1->C5_NOMCLI
				_cFilial := Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + TMP1->CB8_FILIAL, 1, "" ) ) )
				_Vez1 := .F.
			ELSE
				_cDoc    := ""
				_cSerie  := ""
				_cEmisso := ""
				_cCliente:= ""
				_cFilial := ""
			ENDIF

			_cDesGrupo := ""
			//IF  _ImpProd
			_cProduto := TMP1->CB8_PROD
			_cDescri  := TMP1->B1_DESC
			_ImpProd := .F.
			//ELSE
			//    _cProduto := ""
			//    _cDescri  := ""
			//ENDIF

			oFwMsEx:AddRow( cWorkSheet, cTable,{_cDoc,;
				_cSerie,;
				_cEmisso,;
				_cCliente   ,;
				_cFilial,;
				_cProduto  ,;
				_cDescri ,;
				TZA4->ZA4_NLOTE,;
				TZA4->ZA4_DTFAB,;
				TZA4->ZA4_NCAIXA,;
				TZA4->ZA4_NSERIE,;
				TZA4->ZA4_ORDSEP,;
				TMP1->CB8_PEDIDO,;
				TMP1->CB8_ITEM,;
				TZA4->ZA4_NUMOP+TZA4->ZA4_OPITEM+TZA4->ZA4_OPSEQ})

			dbSelectArea("TZA4")
			TZA4->(dbSkip())
		END
		dbSelectArea("TMP1")
		TMP1->(dbSkip())
	EndDo


	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( "Gerando o arquivo, aguarde...", "Gerar Excel", {|| oFwMsEx:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )
	Endif

Return


Static Function F_PROCESSA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Private oFwMsEx    := NIL
	Private cArq       := ""
	Private cDir       := GetSrvProfString("Startpath","")
	Private cWorkSheet := ""
	Private cTable     := ""
	Private cDirTmp    := GetTempPath()  //retorna o temporario no start path
	Private cArqTMP    := ""

	cQuery := "SELECT SD2.*,SB1.B1_DESC,SC5.C5_NUM,SC5.C5_NUMORI,A1_NOME  "		    	    + CRLF
	cQuery += "FROM"																+ CRLF
	cQuery += "	" + RETSQLNAME("SD2") + " SD2 WITH(NOLOCK) " 						+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("SB1") + " SB1 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON SB1.B1_FILIAL	= '" + XFILIAL("SB1") + "'" 	        + CRLF
	cQuery += "			AND	SB1.B1_COD		= SD2.D2_COD"							+ CRLF
	cQuery += "			AND SB1.D_E_L_E_T_	= ''"									+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("SC5") + " SC5 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON SC5.C5_FILIAL	= SD2.D2_FILIAL" 		             	+ CRLF
	cQuery += "			AND	SC5.C5_NUM		= SD2.D2_PEDIDO"						+ CRLF
	cQuery += "			AND SC5.D_E_L_E_T_	= ''"									+ CRLF
	cQuery += "		INNER JOIN " + RETSQLNAME("SA1") + " SA1 WITH(NOLOCK) " 		+ CRLF
	cQuery += "			ON SA1.A1_FILIAL	= '" + XFILIAL("SA1") + "'"           	+ CRLF
	cQuery += "			AND	SA1.A1_COD		= SD2.D2_CLIENTE"						+ CRLF
	cQuery += "			AND	SA1.A1_LOJA		= SD2.D2_LOJA"	    					+ CRLF
	cQuery += "			AND SA1.D_E_L_E_T_	= ''"									+ CRLF
	cQuery += " WHERE D2_DOC = '"+ MV_PAR02 +"' "									+ CRLF
	cQuery += " AND D2_SERIE = '"+ MV_PAR03 +"' "									+ CRLF
	IF .NOT. EMPTY(MV_PAR05)
		cQuery += " AND D2_COD = '"+ MV_PAR05 +"' "									    + CRLF
	ENDIF
	cQuery += " AND D2_FILIAL = '"+MV_PAR04+"' " 									+ CRLF
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' " 											+ CRLF
	cQuery += " ORDER BY D2_DOC,D2_ITEM "											+ CRLF

	MEMOWRITE( "ESTRL003_DOCUMENTOS.SQL",cQuery)

	If  Select("TMP1") > 0
		DbSelectArea("TMP1")
		DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TMP1"

	oFwMsEx := FWMsExcel():New()

	cWorkSheet := "NF x Serial Number"
	cTable     := "Nota Fiscal x Serial Number - Data : " + DTOC(DDATABASE)

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )
// 1-General,2-Number,3-Monetário,4-DateTime

	oFwMsEx:AddColumn( cWorkSheet, cTable , "Nota Fiscal"       , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Série"             , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Emissão"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Cliente"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Filial"            , 1,1)

	oFwMsEx:AddColumn( cWorkSheet, cTable , "Produto"           , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição"         , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Lote Fabricação"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Data Fabricação"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Número da Caixa"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Serial Number"     , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem de Separação", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Pedido de Venda"   , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Item do Pedido"    , 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Ordem de Produção" , 1,1)

	_Vez1    := .T.
	_ImpProd := .T.

	DbSelectArea("TMP1")
	count to nCount
	DBGOTOP()

	oProcess:SetRegua1(nCount)

	While .not. eof()

		oProcess:IncRegua1( "Processando NF "+ TMP1->D2_DOC )

		//VERIFICA A QUANTIDADE DE PASTAS CONFORME GROUPO DE CANAIS
		cQuery := "SELECT CB7_FILIAL,CB7_ORDSEP,CB7_PEDORI,CB7_CLIORI,CB7_LOJORI, " + CRLF
		cQuery += "ZA4_FILIAL,ZA4_COD,ZA4_NSERIE,ZA4_DSCETQ,ZA4_DTFAB,ZA4_NCAIXA,ZA4_NLOTE,ZA4_NUMOP,ZA4_SERIAL,ZA4_OPITEM,ZA4_OPSEQ,ZA4_PEDIDO,ZA4_ORDSEP " + CRLF
		cQuery += "FROM CB7030 CB7 (NOLOCK) "				+ CRLF
		cQuery += "	INNER JOIN ZA4040 ZA4 WITH(NOLOCK) " + CRLF
		cQuery += "	ON ZA4.ZA4_FILIAL	= '02' "   		+ CRLF
		cQuery += "	AND ZA4.D_E_L_E_T_ = ' ' "	        + CRLF
		cQuery += "	AND ZA4.ZA4_ORDSEP = CB7_ORDSEP "	        + CRLF
		cQuery += "	AND ZA4_PRCOM = '" + ALLTRIM(TMP1->D2_COD) + "' "		+ CRLF
		cQuery += "	AND RIGHT(ZA4.ZA4_DTFAB,4) ='2019' "	+ CRLF
		cQuery += "WHERE "
		If ALLTRIM(MV_PAR04) = "01"
			cQuery += "CB7_PEDORI = '" + TMP1->C5_NUM + "' "		+ CRLF
		ElseIf ALLTRIM(MV_PAR04) = "02"
			cQuery += "CB7_NOTA = '"+TMP1->D2_DOC+"' "		+ CRLF
			cQuery += "AND CB7_SERIE= '"+TMP1->D2_SERIE+"' "		+ CRLF
		Endif
		cQuery += "AND CB7.D_E_L_E_T_ = '' " 				+ CRLF
		cQuery += "AND CB7_FILIAL = '02' " 					+ CRLF

		MEMOWRITE( "ESTRL003_ETIQUETAS.SQL",cQuery)

		If   Select("TZA4") > 0
			DbSelectArea("TZA4")
			DbCloseArea()
		Endif

		TCQUERY cQuery NEW ALIAS "TZA4"
		Count to nCount
		oProcess:SetRegua2(nCount)

		DbSelectArea("TZA4")
		dbGoTop()
		While .not. eof()

			oProcess:IncRegua2( "Produto "+ TMP1->D2_DOC + " Serial Nuber "+TZA4->ZA4_NSERIE)

			IF  _Vez1
				_cDoc    := TMP1->D2_DOC
				_cSerie  := TMP1->D2_SERIE
				_cEmisso := DTOC((STOD(TMP1->D2_EMISSAO)))
				_cCliente:= TMP1->A1_NOME
				_cFilial := Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + TMP1->D2_FILIAL, 1, "" ) ) )
				_Vez1 := .F.
			ELSE
				_cDoc    := ""
				_cSerie  := ""
				_cEmisso := ""
				_cCliente:= ""
				_cFilial := ""
			ENDIF

			_cDesGrupo := ""
			//IF  _ImpProd
			_cProduto := TMP1->D2_COD
			_cDescri  := TMP1->B1_DESC
			_ImpProd := .F.
			//ELSE
			//    _cProduto := ""
			//    _cDescri  := ""
			//ENDIF

			oFwMsEx:AddRow( cWorkSheet, cTable,{_cDoc,;
				_cSerie,;
				_cEmisso,;
				_cCliente   ,;
				_cFilial,;
				_cProduto  ,;
				_cDescri ,;
				TZA4->ZA4_NLOTE,;
				TZA4->ZA4_DTFAB,;
				TZA4->ZA4_NCAIXA,;
				TZA4->ZA4_NSERIE,;
				TZA4->ZA4_ORDSEP,;
				TMP1->D2_PEDIDO,;
				TMP1->D2_ITEMPV,;
				TZA4->ZA4_NUMOP+TZA4->ZA4_OPITEM+TZA4->ZA4_OPSEQ})

			dbSelectArea("TZA4")
			TZA4->(dbSkip())
		END
		dbSelectArea("TMP1")
		TMP1->(dbSkip())
	EndDo


	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( "Gerando o arquivo, aguarde...", "Gerar Excel", {|| oFwMsEx:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
	Else
		MsgInfo( "Arquivo não copiado para temporário do usuário." )
	Endif

Return





/*******************************************************************************************/
Static Function ValidPerg
	Local j := 0
	Local i := 0

	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)

	aRegs :={}

//		  X1_GRUPO	X1_ORDEM	X1_PERGUNT								X1_PERSPA								X1_PERENG							X1_VARIAVL	X1_TIPO	X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01	X1_DEF01		X1_DEFSPA1		X1_DEFENG1		X1_CNT01	X1_VAR02	X1_DEF02			X1_DEFSPA2		X1_DEFENG2		X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME	X1_GRPSXG	X1_HELP
	aAdd(aRegs,{cPerg,	'01',	'Tipo de consulta'				,	'Tipo de consulta?'				,	'Tipo de consulta?'				,	'mv_ch1',	'N'		,01			, 0			,0		,'C'	,	''	,	'mv_par01','Ordem Sep.'	,'Ordem Sep'	,'Ordem Sep'	,	''		,	''		,'Nota Fiscal',	'Nota Fiscal'	,'Nota Fiscal'	,	''		,	''		,'Lote',	'Lote',	'Lote',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'02',	'Nota Fiscal                   '	,	'Nota Fiscla                  ?'	,	'Nota Fiscal                  ?'	,	'mv_ch2',	'C'		,09			, 0			,0		,'G'	,	''	,	'mv_par02',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'03',	'Série NF                      '	,	'Série                        ?'	,	'Serie                        ?'	,	'mv_ch3',	'C'		,03			, 0			,0		,'G'	,	''	,	'mv_par03',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'04',	'Filial da Nota Fiscal         '	,	'Filial da Nota Fiscal?'			,	'Filial da Nota Fiscal?'			,	'mv_ch4',	'C'		,02			, 0			,0		,'G'	,	''	,	'mv_par04',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'05',	'Produto 	                    '	,	'Produto 	                  ?'	,	'Produto 	                  ?'	,	'mv_ch5',	'C'		,15			, 0			,0		,'G'	,	''	,	'mv_par05',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'SB1',	'',	'',	''})
	aAdd(aRegs,{cPerg,	'06',	'Da Ordem de Separacao'			,	'Da Ordem de Separacao?'			,	'Da Ordem de Separacao?'			,	'mv_ch6',	'C'		,06			, 0			,0		,'G'	,	''	,	'mv_par06',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'07',	'Até a Ordem de Separacao'		,	'Até a Ordem de Separacao?'		,	'Até a Ordem de Separacao?'		,	'mv_ch7',	'C'		,06			, 0			,0		,'G'	,	''	,	'mv_par07',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'08',	'Lote de Fabricacao'				,	'Lote de Fabricacao?'				,	'Lote de Fabricacao?'				,	'mv_ch8',	'C'		,05			, 0			,0		,'G'	,	''	,	'mv_par08',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})
	aAdd(aRegs,{cPerg,	'09',	'Data de Fabricacao'				,	'Data de Fabricacao?'				,	'Data de Fabricacao?'				,	'mv_ch9',	'D'		,08			, 0			,0		,'G'	,	''	,	'mv_par09',	'       ',	'       ',	'       ',	'',	'',	'              ',	'              ',	'              ',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	'',	''	 ,	'',	'',	''})

	For i:=1 to Len(aRegs)

		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return
