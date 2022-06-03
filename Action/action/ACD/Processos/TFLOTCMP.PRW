#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

Static cZZSTbl := RetSqlName("ZZS")
Static cZZSFil := xFilial("ZZS")
Static cSC2Tbl := RetSqlName("SC2")
Static cSC2Fil := xFilial("SC2")
Static cSB1Tbl := RetSqlName("SB1")
Static cSB1Fil := xFilial("SB1")
Static cCTTTbl := RetSqlName("CTT")
Static cCTTFil := xFilial("CTT")
Static cSA1Tbl := RetSqlName("SA1")
Static cSA1Fil := xFilial("SA1")
Static cSA2Tbl := RetSqlName("SA2")
Static cSA2Fil := xFilial("SA2")
Static cSF1Tbl := RetSqlName("SF1")
Static cSF1Fil := xFilial("SF1")
Static cSD1Tbl := RetSqlName("SD1")
Static cSD1Fil := xFilial("SD1")
Static cSD4Tbl := RetSqlName("SD4")
Static cSD4Fil := xFilial("SD4")
Static cZA4Tbl := RetSqlName("ZA4")
Static cZA4Fil := xFilial("ZA4")
Static lDbg := ( SuperGetMV("TFLOTCMDBG",,"N") == "S" )

// Programa     TFLOTCMP
// Descricao    Monitor Lote de Componente - Tela Principal
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
// Alteracoes 
User Function TFLOTCMP()
Local cFtDefault := ""
Private cCadastro := "Monitor Lote de Componente"
Private oZZSBrw := Nil

MsgRun("Aguarde... Atualizando Monitor...",,{||RUNATMNT()})

dbSelectArea("ZZS")

SetKey( VK_F2, {||U_TFLTFCMP()} )

cFtDefault := U_TFLTFCMP()

If Empty(cFtDefault)
	Return(Nil)
Endif

DEFINE FWMBROWSE oZZSBrw ALIAS "ZZS" FILTERDEFAULT cFtDefault DESCRIPTION cCadastro NO DETAILS

	ADD LEGEND DATA {|| ZZS->ZZS_TPREG == '0' } COLOR "GREEN" 	TITLE "Separacao"	OF oZZSBrw
	ADD LEGEND DATA {|| ZZS->ZZS_TPREG == '1' } COLOR "YELLOW" 	TITLE "Pre-Nota"	OF oZZSBrw
	ADD LEGEND DATA {|| ZZS->ZZS_TPREG == '2' } COLOR "WHITE"	TITLE "Nota"		OF oZZSBrw
	ADD LEGEND DATA {|| ZZS->ZZS_TPREG == ' ' } COLOR "BLACK"	TITLE "Outros"		OF oZZSBrw

	oZZSBrw:SetCacheView(.F.) //-- Desabilita Cache da View, pois gera colunas dinamicamente

ACTIVATE FWMBROWSE oZZSBrw

Return(Nil)



// Programa     MENUDEF
// Descricao    Opcoes da FWMBrowse do Monitor Lote de Componente
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE "Manutencao"		ACTION "U_TFLTMCMP('M')" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Visualizar"		ACTION "U_TFLTMCMP('V')" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Pesquisar" 		ACTION "PesqBrw"		 OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Consulta por OP" 	ACTION "U_TFRSTLOP()"	 OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Consulta por NF" 	ACTION "U_TFRSTLNF()"	 OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE "Filtros (F2)" 	ACTION "U_TFLTFCMP"		 OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE "Legenda" 			ACTION "U_TFLTLCMP"	     OPERATION 1 ACCESS 0

Return(aRotina)



// Programa     TFLTLCMP
// Descricao    Legenda da FWMBrowse do Monitor Lote de Componente
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
User Function TFLTLCMP()
Local aLegenda := {}

AADD( aLegenda, {"BR_VERDE"		, "Separacao" } )
AADD( aLegenda, {"BR_AMARELO"	, "Pre-Nota" } )
AADD( aLegenda, {"BR_BRANCO"	, "Nota" } )
AADD( aLegenda, {"BR_PRETO"		, "Outros" } )

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return(.T.)



// Programa     TFLTFCMP
// Descricao    Filtro da FWMBrowse do Monitor Lote de Componente. Acionado pela tecla F2.
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
User Function TFLTFCMP()
Local cFiltDef := ""

Pergunte("TFLOTCMP01",.F.)

cFiltDef := " ZZS_FILIAL = '"+xFilial("ZZS")+"' "

If Pergunte("TFLOTCMP01",.T.)	

	If !Empty(MV_PAR02)

		If MV_PAR01 == 1
			cFiltDef += " .AND. ( '" +Alltrim(MV_PAR02)+ "' $ ZZS_OP ) "
		ELSEIf MV_PAR01 == 2
			cFiltDef += " .AND. ( '" +Alltrim(MV_PAR02)+ "' $ ZZS_NUMNF ) "
		ELSEIf MV_PAR01 == 3
			cFiltDef += " .AND. ( '" +Alltrim(MV_PAR02)+ "' $ ZZS_ORDSEP ) "
		ELSEIf MV_PAR01 == 4
			cFiltDef += " .AND. ( '" +Alltrim(MV_PAR02)+ "' $ ZZS_COMPON ) "
		ELSEIf MV_PAR01 == 4
			cFiltDef += " .AND. ( '" +Alltrim(MV_PAR02)+ "' $ ZZS_CODPA ) "
		Else
			cFiltDef += ""
		EndIf

	EndIf
	If !Empty(MV_PAR03)
		cFiltDef += " .AND. ZZS_DTEVEN >= '" +DtoC(MV_PAR03)+ "' "
	EndIf
	If !Empty(MV_PAR04)
		cFiltDef += " .AND. ZZS_DTEVEN <= '"+DtoC(MV_PAR04)+"' "
	EndIf
	
EndIf

If Type("oZZSBrw") <> "U"

	oZZSBrw:SetFilterDefault(cFiltDef)
	TcRefresh(RetSqlName("ZZS"))	
	ZZS->(dbGoTop())
	oZZSBrw:Refresh(.T.)

EndIf

Return(cFiltDef)



// Programa     TFLTMCMP
// Descricao    Tela de Manutencao / Visualizacao dos lotes de componente
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
User Function TFLTMCMP( cOpt )
Local oDgA, oBtS, oBtG, oBtI, oGp1, oGp2, oSay1, oSay2, oSay3, oSay4, oGDD := Nil
Local oFt1 := TFont():New("Courier New",,019,,,,,,,.F.,.F.)
Local cSay1 := ""
Local cSay2 := ""
Local cSay3 := ""
Local cSay4 := ""
Local cTit1 := ""
Local cCodPA := ""
Local lGo := .T.
Local aHeadA := {}
Local aColsA := {}
Local aAFields := {}
Local aParm1 := { ZZS->ZZS_TPREG, ZZS->ZZS_OP, ZZS->ZZS_NUMNF, ZZS->ZZS_SERNF, ZZS->ZZS_CODFOR, ZZS->ZZS_LOJFOR }
Local bBtI := {|| IncItem(@aColsA,@oGDD) }
Local bBtG := {|| aColsA:=aClone(oGDD:aCols),Iif(GrvAlt(aColsA,cCodPA),oDgA:End(),Nil) }
Local bBtS := {|| Iif(cOpt=="M",Iif(MsgYesNo("Sair sem gravar alterações?"),oDgA:End(),Nil),oDgA:End()) }
Default cOpt := "V"

If RetDados( cOpt, @cSay1, @cSay2, @cSay3, @cSay4, @cTit1, @aHeadA, @aColsA, @aAFields, @cCodPA )

	If cOpt == "M"
		If !GetLock()
			Alert("Registro(s) já estão em manutenção em outra instância ou por outro usuário.")
			lGo := .F.
		EndIf
	EndIf

	If lGo

		DEFINE MSDIALOG oDgA TITLE cTit1 FROM 000, 000  TO 500, 950 COLORS 0, 16777215 PIXEL

			@ 002, 002 GROUP oGp1 TO 050, 473 PROMPT "Dados do Documento Selecionado" OF oDgA COLOR 0, 16777215 PIXEL
			@ 010, 006 SAY oSay1 PROMPT cSay1 SIZE 463, 008 OF oDgA FONT oFt1 COLORS 0, 16777215 PIXEL
			@ 020, 006 SAY oSay2 PROMPT cSay2 SIZE 463, 008 OF oDgA FONT oFt1 COLORS 0, 16777215 PIXEL
			@ 030, 006 SAY oSay3 PROMPT cSay3 SIZE 463, 008 OF oDgA FONT oFt1 COLORS 0, 16777215 PIXEL
			@ 040, 006 SAY oSay4 PROMPT cSay4 SIZE 463, 008 OF oDgA FONT oFt1 COLORS 0, 16777215 PIXEL
			@ 052, 002 GROUP oGp2 TO 232, 473 PROMPT "Componentes" OF oDgA COLOR 0, 16777215 PIXEL
			If cOpt == "M"
				If ( ZZS->ZZS_TPREG == '1' .Or. ZZS->ZZS_TPREG == '2' )
					@ 234, 002 BUTTON oBtI PROMPT "Incluir Componente" SIZE 052, 012 OF oDgA ACTION Eval(bBtI) PIXEL
				EndIf
				@ 234, 380 BUTTON oBtG PROMPT "Grava Alterações" SIZE 050, 012 OF oDgA ACTION Eval(bBtG) PIXEL
			EndIf
			@ 234, 435 BUTTON oBtS PROMPT "Sair" Action Eval(bBtS) SIZE 037, 012 OF oDgA PIXEL
			oGDD := MsNewGetDados():New( 059, 004, 229, 470, GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDgA, aHeadA, aColsA)
			oDgA:lEscClose := .F.

		ACTIVATE MSDIALOG oDgA CENTERED

		If cOpt == "M"
			RmvLock(,aParm1)
		EndIf

		MsgRun("Aguarde... Atualizando Monitor...",,{||RUNATMNT()})

	EndIf

EndIf

Return(Nil)



// Programa     RETDADOS
// Descricao    Retorno Dados para Tela de Manutencao / Visualizacao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RetDados( cOpt, cSay1, cSay2, cSay3, cSay4, cTit1, aHeadA, aColsA, aAFields, cCodPA )
Local cQry := ""
Local nSqIt := 1
Local lRet := .T.

If ( ZZS->ZZS_TPREG == "0" )

	If !Empty(ZZS->ZZS_OP)

		If cOpt == "M"

			cTit1 := "MANUTENÇÃO: lote do fornecedor obtido na separação dos componentes da OP"
			aAFields := { "LOTEFOR", "NFISCAL", "SERIENF", "QTDCOMP" }
			aHeadA := {	{ "Item"		, "NITEMNF"	, "@!"			, 04, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Lote Forn."	, "LOTEFOR"	, "@!"			, 20, 0, "AllwaysTrue()"  ,, "C", "", "A" },;
						{ "Produto"		, "CODPROD"	, "@!"			, 15, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Descricao"	, "DESPROD"	, "@!"			, 40, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Quant."		, "QTDCOMP"	, "@E 9999.99"	, 07, 2, "AllwaysTrue()"  ,, "N", "", "A" },;
						{ "Nota Fiscal"	, "NFISCAL"	, "@!"			, 09, 0, "AllwaysTrue()"  ,, "C", "", "A" },;
						{ "Serie NF"	, "SERIENF"	, "@!"			, 02, 0, "AllwaysTrue()"  ,, "C", "", "A" },;
						{ "Ord. Sep."	, "ORDSEPR"	, "@!"			, 06, 0, "AllwaysTrue()"  ,, "C", "", "V" } }

		Else

			cTit1 := "VISUALIZACAO: lote do fornecedor obtido na separação dos componentes da OP"
			aAFields := { }
			aHeadA := {	{ "Item"		, "NITEMNF"	, "@!"			, 04, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Lote Forn."	, "LOTEFOR"	, "@!"			, 20, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Produto"		, "CODPROD"	, "@!"			, 15, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Descricao"	, "DESPROD"	, "@!"			, 40, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Quant."		, "QTDCOMP"	, "@E 9999.99"	, 07, 2, "AllwaysFalse()" ,, "N", "", "V" },;
						{ "Nota Fiscal"	, "NFISCAL"	, "@!"			, 09, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Serie NF"	, "SERIENF"	, "@!"			, 02, 0, "AllwaysFalse()" ,, "C", "", "V" },;
						{ "Ord. Sep."	, "ORDSEPR"	, "@!"			, 06, 0, "AllwaysFalse()" ,, "C", "", "V" } }

		EndIf			

		cQry := "SELECT " +Iif(lDbg,CRLF,"")
		cQry += "C2_PRODUTO AS CODPRO, " +Iif(lDbg,CRLF,"")
		cQry += "B1.B1_DESC AS DESCPRO, " +Iif(lDbg,CRLF,"")
		cQry += "SUBSTRING(C2_EMISSAO,7,2)+'/'+SUBSTRING(C2_EMISSAO,5,2)+'/'+SUBSTRING(C2_EMISSAO,1,4) AS DTEMIS, " +Iif(lDbg,CRLF,"")
		cQry += "SUBSTRING(C2_DATRF,7,2)+'/'+SUBSTRING(C2_DATRF,5,2)+'/'+SUBSTRING(C2_DATRF,1,4) AS DATRF, " +Iif(lDbg,CRLF,"")
		cQry += "C2_UM AS UNIDM, " +Iif(lDbg,CRLF,"")
		cQry += "C2_QUANT AS QUANT, " +Iif(lDbg,CRLF,"")
		cQry += "C2_QUJE AS QENTR, " +Iif(lDbg,CRLF,"")
		cQry += "C2_CC AS CODCC, " +Iif(lDbg,CRLF,"")
		cQry += "CTT_DESC01 AS DESCCC, " +Iif(lDbg,CRLF,"")
		cQry += "C2_OBS AS OBSOP " +Iif(lDbg,CRLF,"")
		cQry += "FROM " +cSC2Tbl+ " (NOLOCK) C2 " +Iif(lDbg,CRLF,"")
		cQry += "INNER JOIN " +cSB1Tbl+ " (NOLOCK) B1 ON B1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND B1_COD = C2.C2_PRODUTO " +Iif(lDbg,CRLF,"")
		cQry += "INNER JOIN " +cCTTTbl+ " (NOLOCK) CTT ON CTT.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND CTT_FILIAL = '" +cCTTFil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND CTT_CUSTO = C2_CC " +Iif(lDbg,CRLF,"")
		cQry += "WHERE C2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND C2_FILIAL = '" +cSC2Fil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND C2_NUM = '" +SubStr(ZZS->ZZS_OP,1,6)+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND C2_ITEM = '" +SubStr(ZZS->ZZS_OP,7,2)+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND C2_SEQUEN  = '" +SubStr(ZZS->ZZS_OP,9,3)+ "' " +Iif(lDbg,CRLF,"")

		Iif(lDbg,VISDBG(cQry),Nil)

		Iif(Select("WRKAXB")>0,WRKAXB->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKAXB",.T.,.T.)
		TcSetField("WRKAXB","QUANT","N",12,0)
		TcSetField("WRKAXB","QENTR","N",12,0)
		WRKAXB->(dbGoTop())

		If WRKAXB->(!EoF())

			cSay1 := "Ordem de Producao: " +PadR(ZZS->ZZS_OP,13)+ "          Data de Emissao: " +PadR(WRKAXB->DTEMIS,10)+ "       Data Real. Fim: " +PadR(WRKAXB->DATRF,10)
			cSay2 := "Produto:           " +Alltrim(WRKAXB->CODPRO)+ " - " +Alltrim(WRKAXB->DESCPRO)
			cSay3 := "Unid. Medida:      " +PadR(Alltrim(WRKAXB->UNIDM),2)+ "              Quant.OP: " + Transform(WRKAXB->QUANT,"@E 9999999.99") + "                   Quant. Entregue: " + Transform(WRKAXB->QENTR,"@E 9999999.99")
			cSay4 := "Centro de Custo:   " +PadR(Alltrim(WRKAXB->CODCC)+" - "+Alltrim(WRKAXB->DESCCC),25)+ "    Obs.: " +Alltrim(WRKAXB->OBSOP)
			cCodPA := Alltrim(WRKAXB->CODPRO)

		EndIf
		WRKAXB->(dbCloseArea())

		cQry := "SELECT DISTINCT " +Iif(lDbg,CRLF,"")
		cQry += "ISNULL(ZZS_LOTEF,'                    ') AS LOTEF, " +Iif(lDbg,CRLF,"")
		cQry += "D4_COD AS CODPRO, " +Iif(lDbg,CRLF,"")
		cQry += "B1_DESC AS DESCPRO, " +Iif(lDbg,CRLF,"")
		cQry += "ISNULL(SUM(ZZS_QTDCMP),0) AS QUANT, " +Iif(lDbg,CRLF,"")
		cQry += "ISNULL(ZZS_NUMNF,'         ') AS NUMNF, " +Iif(lDbg,CRLF,"")
		cQry += "ISNULL(ZZS_SERNF,'   ') AS SERNF, " +Iif(lDbg,CRLF,"")
		cQry += "ISNULL(ZZS_ORDSEP,'      ') AS ORDSEP " +Iif(lDbg,CRLF,"")
		cQry += "FROM " +cSD4Tbl+ " (NOLOCK) D4 " +Iif(lDbg,CRLF,"")
		cQry += "LEFT OUTER JOIN " +cZZSTbl+ " (NOLOCK) ZZS ON ZZS.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_OP = D4_OP " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_COMPON = D4_COD " +Iif(lDbg,CRLF,"")
		cQry += "INNER JOIN " +cSB1Tbl+ " (NOLOCK) B1 ON B1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND B1_COD = D4_COD " +Iif(lDbg,CRLF,"")
		If !lDbg
			cQry += "AND B1_ITEMSEG = '1' " +Iif(lDbg,CRLF,"")
		EndIf
		cQry += "WHERE D4.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND D4_FILIAL = '" +cSD4Fil+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D4_OP = '" +ZZS->ZZS_OP+ "'  " +Iif(lDbg,CRLF,"")
		cQry += "GROUP BY ZZS_LOTEF, D4_COD, B1_DESC, ZZS_NUMNF, ZZS_SERNF, ZZS_ORDSEP " +Iif(lDbg,CRLF,"")
		cQry += "ORDER BY CODPRO, DESCPRO, NUMNF, SERNF, ORDSEP, LOTEF " +Iif(lDbg,CRLF,"")

		Iif(lDbg,VISDBG(cQry),Nil)

		Iif(Select("WRKBXB")>0,WRKBXB->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKBXB",.T.,.T.)
		TcSetField("WRKBXB","QUANT","N",12,2)
		WRKBXB->(dbGoTop())

		While WRKBXB->(!EoF())

			aAdd( aColsA, {	StrZero(nSqIt++,4),;
							WRKBXB->LOTEF,;
							WRKBXB->CODPRO,;
							WRKBXB->DESCPRO,;
							WRKBXB->QUANT,;
							WRKBXB->NUMNF,;
							WRKBXB->SERNF,;
							WRKBXB->ORDSEP,;
							.F. })

			WRKBXB->(dbSkip())
		EndDo
		WRKBXB->(dbCloseArea())

		If Len(aColsA) == 0
			aColsA := {{"","","","","","","",0,.F.}}
		EndIf

	EndIf

ElseIf ( ZZS->ZZS_TPREG == "1" .Or. ZZS->ZZS_TPREG == "2" )

	If cOpt == "M"

		cTit1 := "MANUTENÇÃO: lote do fornecedor obtido na conferência da nota fiscal"
		aAFields := {"LOTEFOR","QTDCOMP"}
		aHeadA := {	{ "Item"		, "NITEMNF"	, "@!"			, 04, 0, "AllwaysFalse()" ,, "C", "", "V"},;
					{ "Lote Forn."	, "LOTEFOR"	, "@!"			, 20, 0, "AllwaysTrue()"  ,, "C", "", "A"},;
					{ "Produto"		, "CODPROD"	, "@!"			, 15, 0, "AllwaysFalse()" ,, "C", "", "V" },;
					{ "Descricao"	, "DESPROD"	, "@!"			, 40, 0, "AllwaysFalse()" ,, "C", "", "V" },;
					{ "Quant."		, "QTDCOMP"	, "@E 9999.99"	, 07, 2, "AllwaysTrue()"  ,, "N", "", "A" }} 
	Else

		cTit1 := "VISUALIZAÇÃO: lote do fornecedor obtido na conferência da nota fiscal"
		aAFields := {}
		aHeadA := {	{ "Item"		, "NITEMNF"	, "@!"			, 04, 0, "AllwaysFalse()" ,, "C", "", "V"},;
					{ "Lote Forn."	, "LOTEFOR"	, "@!"			, 20, 0, "AllwaysFalse()" ,, "C", "", "V"},;
					{ "Produto"		, "CODPROD"	, "@!"			, 15, 0, "AllwaysFalse()" ,, "C", "", "V" },;
					{ "Descricao"	, "DESPROD"	, "@!"			, 40, 0, "AllwaysFalse()" ,, "C", "", "V" },;
					{ "Quant."		, "QTDCOMP"	, "@E 9999.99"	, 07, 2, "AllwaysFalse()" ,, "N", "", "V" }} 
	EndIf

	cQry := "SELECT " +Iif(lDbg,CRLF,"")
	cQry += "SUBSTRING(F1.F1_DTDIGIT,7,2)+'/'+SUBSTRING(F1.F1_DTDIGIT,5,2)+'/'+SUBSTRING(F1.F1_DTDIGIT,1,4) AS DTENTR, " +Iif(lDbg,CRLF,"")
	cQry += "SUBSTRING(F1.F1_EMISSAO,7,2)+'/'+SUBSTRING(F1.F1_EMISSAO,5,2)+'/'+SUBSTRING(F1.F1_EMISSAO,1,4) AS DTEMIS, " +Iif(lDbg,CRLF,"")
	cQry += "TIPONF = ( " +Iif(lDbg,CRLF,"")
	cQry += "CASE " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'N' THEN 'NORMAL' " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'D' THEN 'DEVOLUCAO' " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'B' THEN 'BENEFICIAMENTO' " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'C' THEN 'COMPLEMENTO' " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'I' THEN 'COMPLEMENTO DE ICMS' " +Iif(lDbg,CRLF,"")
	cQry += "WHEN F1.F1_TIPO = 'P' THEN 'COMPLEMENTO DE IPI' " +Iif(lDbg,CRLF,"")
	cQry += "ELSE 'OUTROS' " +Iif(lDbg,CRLF,"")
	cQry += "END ), " +Iif(lDbg,CRLF,"")
	cQry += "NOMFORN = ISNULL(( " +Iif(lDbg,CRLF,"")
	cQry += "CASE WHEN " +Iif(lDbg,CRLF,"")
	cQry += "F1.F1_TIPO = 'D' " +Iif(lDbg,CRLF,"")
	cQry += "THEN " +Iif(lDbg,CRLF,"")
	cQry += "( SELECT UPPER(RTRIM(LTRIM(A1.A1_NOME))) " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA1Tbl+ " (NOLOCK) A1 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE A1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "ELSE " +Iif(lDbg,CRLF,"")
	cQry += "( SELECT UPPER(RTRIM(LTRIM(A2.A2_NOME))) " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA2Tbl+ " (NOLOCK) A2 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE A2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_FILIAL = '" +cSA2Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "END ),''), " +Iif(lDbg,CRLF,"")
	cQry += "CNPJ = ISNULL(( " +Iif(lDbg,CRLF,"")
	cQry += "CASE WHEN " +Iif(lDbg,CRLF,"")
	cQry += "F1.F1_TIPO = 'D' " +Iif(lDbg,CRLF,"")
	cQry += "THEN " +Iif(lDbg,CRLF,"")
	cQry += "( SELECT A1.A1_CGC " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA1Tbl+ " (NOLOCK) A1 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE A1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "ELSE " +Iif(lDbg,CRLF,"")
	cQry += "( SELECT A2.A2_CGC "  +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA2Tbl+ " (NOLOCK) A2 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE A2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_FILIAL = '" +cSA2Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "END ),''), " +Iif(lDbg,CRLF,"")
	cQry += "ENDFORN = ISNULL(( " +Iif(lDbg,CRLF,"")
	cQry += "CASE WHEN " +Iif(lDbg,CRLF,"")
	cQry += "F1.F1_TIPO = 'D' " +Iif(lDbg,CRLF,"")
	cQry += "THEN "  +Iif(lDbg,CRLF,"")
	cQry += "( SELECT UPPER(RTRIM(LTRIM( LTRIM(RTRIM(A1.A1_LOGR)) +' '+ LTRIM(RTRIM(A1.A1_END)) +', '+ LTRIM(RTRIM(A1.A1_NUME)) +' - '+ LTRIM(RTRIM(A1.A1_BAIRRO)) + ' - ' + LTRIM(RTRIM(A1.A1_MUN)) +'/'+ LTRIM(RTRIM(A1.A1_EST))  ))) " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA1Tbl+ " (NOLOCK) A1 "  +Iif(lDbg,CRLF,"")
	cQry += "WHERE A1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A1.A1_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "ELSE " +Iif(lDbg,CRLF,"")
	cQry += "( SELECT UPPER(RTRIM(LTRIM( LTRIM(RTRIM(A2.A2_LOGR))+ ' ' +LTRIM(RTRIM(A2.A2_END)) +', '+ LTRIM(RTRIM(A2.A2_NR_END)) +' - '+ LTRIM(RTRIM(A2.A2_BAIRRO)) + ' - ' + LTRIM(RTRIM(A2.A2_MUN)) +'/'+ LTRIM(RTRIM(A2.A2_EST))  ))) " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSA2Tbl+ " (NOLOCK) A2 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE A2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_FILIAL = '" +cSA2Fil+ "'  " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_COD = F1.F1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A2.A2_LOJA = F1.F1_LOJA ) " +Iif(lDbg,CRLF,"")
	cQry += "END ),'') "  +Iif(lDbg,CRLF,"")
	cQry += "FROM " +Iif(lDbg,CRLF,"")
	cQry += cSF1Tbl+ " (NOLOCK) F1 " +Iif(lDbg,CRLF,"")
	cQry += "WHERE F1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND F1.F1_FILIAL = '" +cSF1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND F1.F1_DOC = '" +ZZS->ZZS_NUMNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND F1.F1_SERIE = '" +ZZS->ZZS_SERNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND F1.F1_FORNECE = '" +ZZS->ZZS_CODFOR+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND F1.F1_LOJA = '" +ZZS->ZZS_LOJFOR+ "' " +Iif(lDbg,CRLF,"")

	Iif(lDbg,VISDBG(cQry),Nil)

	Iif(Select("WRKCXB")>0,WRKCXB->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKCXB",.T.,.T.)
	WRKCXB->(dbGoTop())

	If WRKCXB->(!EoF())

		cSay1 := "Nota Fiscal: " +PadR(ZZS->ZZS_NUMNF,9)+ " Serie: "+SubStr(Alltrim(ZZS->ZZS_SERNF),1,3)+ "              Entrada: " +SubStr(WRKCXB->DTENTR,1,10)+ "               Emissao: " +SubStr(WRKCXB->DTEMIS,1,10)
		cSay2 := "Fornecedor:  " +PadR(ZZS->ZZS_CODFOR,6)+ "-" +PadR(ZZS->ZZS_LOJFOR,2)+ " " +Alltrim(WRKCXB->NOMFORN)
		cSay3 := "Endereço:    " +Alltrim(WRKCXB->ENDFORN)
		cSay4 := "Tipo da NF:  " +PadR(WRKCXB->TIPONF,68)+ "CNPJ: " +PadR(WRKCXB->CNPJ,14)

	EndIf
	WRKCXB->(dbCloseArea())

	cQry := "SELECT " +Iif(lDbg,CRLF,"")
	cQry += "D1_ITEM AS ITEM, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_LOTEF,'') AS LOTEF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_COD AS CODPRO, " +Iif(lDbg,CRLF,"")
	cQry += "B1_DESC DESPRO, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(SUM(ZZS_QTDCMP),0) AS QTD " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSD1Tbl+ " (NOLOCK) D1 " +Iif(lDbg,CRLF,"")
	cQry += "LEFT OUTER JOIN " +cZZSTbl+ " (NOLOCK) ZZS ON ZZS.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_CODFOR = D1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_LOJFOR = D1_LOJA " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_NUMNF = D1_DOC " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_SERNF = D1_SERIE " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_ITEMNF = D1_ITEM " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_COMPON = D1_COD " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_TPREG IN ('1','2') " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cSB1Tbl+ " (NOLOCK) B1 ON B1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1_COD = D1_COD " +Iif(lDbg,CRLF,"")
	If !lDbg
		cQry += "AND B1_ITEMSEG = '1' " +Iif(lDbg,CRLF,"")
	EndIf
	cQry += "WHERE D1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_FILIAL = '" +cSD1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_DOC = '" +ZZS->ZZS_NUMNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_SERIE = '" +ZZS->ZZS_SERNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_FORNECE = '" +ZZS->ZZS_CODFOR+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_LOJA = '" +ZZS->ZZS_LOJFOR+ "' " +Iif(lDbg,CRLF,"")
	cQry += "GROUP BY D1_ITEM, ZZS_LOTEF, D1_COD, B1_DESC " +Iif(lDbg,CRLF,"")
	cQry += "ORDER BY D1_ITEM, ZZS_LOTEF, D1_COD, B1_DESC" +Iif(lDbg,CRLF,"")

	Iif(lDbg,VISDBG(cQry),Nil)

	Iif(Select("WRKCXC")>0,WRKCXC->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKCXC",.T.,.T.)
	TcSetField("WRKCXC","QTD","N",7,2)
	WRKCXC->(dbGoTop())

	While WRKCXC->(!EoF())
		aAdd( aColsA, {	WRKCXC->ITEM,;
						If(Empty(WRKCXC->LOTEF),Space(20),PadR(WRKCXC->LOTEF,20)),;
						WRKCXC->CODPRO,;
						WRKCXC->DESPRO,;
						WRKCXC->QTD,;
						.F. })

		WRKCXC->(dbSkip())
	EndDo
	WRKCXC->(dbCloseArea())

	If Len(aColsA) == 0
		aColsA := {{"","","","",0,.F.}}
	EndIf

Else

	cTit1 := "Manutenção do Lote do Fornecedor"

EndIf

Return(lRet)



// Programa     GRVALT
// Descricao    Chama a rotina de validacao e gravacao dos dados alterados na tela de manutencao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function GrvAlt(aColsA,cCodPA)
Local lRet := .F.

cMsg := MsgRun("Aguarde... Validando Dados...",,{||lRet:=RunGrv(aColsA,cCodPA)})

Return(lRet)



// Programa     RUNGRV
// Descricao    Valida e grava os dados alterados na tela de manutencao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RunGrv(aColsA,cCodPA)
Local nNx := 0
Local nPos := 0
Local aItNF := {}
Local cQry := ""
Local cMsg := ""
Local cNumNF := ""
Local cSerNF := ""
Local cCodFor := ""
Local cLojFor := ""
Local cTpReg := ""
Local cOrdPro := ""
Local lDel := .T.
Local lRet := .T.
Default cCodPA := ""

If ZZS->ZZS_TPREG == "0"

	For nNx := 1 to Len(aColsA)

		If !aColsA[nNx,Len(aColsA[nNx])]
			If !Empty(aColsA[nNx,2])
				lDel := .F.
			EndIf
		EndIf

	Next nNx

	If lDel
		lRet := MsgYesNo("ATENÇÃO: todos os itens com lote serão excluídos. Continua com a exclusão?")
	EndIf

	If lRet .And. !lDel

		For nNx := 1 to Len(aColsA)
			If !aColsA[nNx,Len(aColsA[nNx])]
				If !Empty(aColsA[nNx,2])

					cQry := "SELECT ISNULL(D4_QTDEORI,0) AS D4QUANT " +Iif(lDbg,CRLF,"")
					cQry += "FROM " +cSD4Tbl+ " D4 WHERE D4.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
					cQry += "AND D4_FILIAL = '" +cSD4Fil+ "' " +Iif(lDbg,CRLF,"")
					cQry += "AND D4_OP = '" +ZZS->ZZS_OP+ "' " +Iif(lDbg,CRLF,"")
					cQry += "AND D4_COD = '" +aColsA[nNx,3]+ "' " +Iif(lDbg,CRLF,"")

					Iif(lDbg,VISDBG(cQry),Nil)

					Iif(Select("WRKXD4")>0,WRKXD4->(dbCloseArea()),Nil)
					dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXD4",.T.,.T.)
					TcSetField("WRKXD4","D4QUANT","N",12,2)
					WRKXD4->(dbGoTop())

					If WRKXD4->(!EoF())
						If WRKXD4->D4QUANT > 0
							If aColsA[nNx,5] > WRKXD4->D4QUANT
								cMsg += "Quantidade do item " +aColsA[nNx,1]+ " é maior que o da Ordem de Produção" +CRLF
							EndIf
						Else
							cMsg += "OP não encontrada - Item " +aColsA[nNx,1]+ CRLF
						EndIf
					Else
						cMsg += "OP não encontrada - Item " +aColsA[nNx,1]+ CRLF
					EndIf
					WRKXD4->(dbCloseArea())

				EndIf

			EndIf

		Next nNx

		If !Empty(cMsg)
			lRet := .F.
			Alert("As alterações não serão gravadas:"+CRLF+CRLF+cMsg)
		EndIf

	EndIf

	If lRet

		cNumNF := ZZS->ZZS_NUMNF
		cTpReg := ZZS->ZZS_TPREG
		cOrdPro := ZZS->ZZS_OP

		BeginTran()

		cQry := "UPDATE " +cZZSTbl+ " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
		cQry += "WHERE D_E_L_E_T_ = ' ' "
		cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' "
		cQry += "AND ZZS_OP = '" +cOrdPro+ "' "
		cQry += "AND ZZS_TPREG = '" +cTpReg+ "'"

		lRet := ( TcSqlExec(cQry) == 0 )

		If !lDel
			If lRet
				For nNx := 1 to Len(aColsA)
					If lRet
						If !aColsA[nNx,Len(aColsA[nNx])]
							If !Empty(aColsA[nNx,2])
								If RecLock("ZZS",.T.)
									ZZS->ZZS_FILIAL := cZZSFil
									ZZS->ZZS_TPREG := cTpReg
									ZZS->ZZS_DTEVEN := dDataBase
									ZZS->ZZS_OP := cOrdPro
									ZZS->ZZS_COMPON := aColsA[nNx,3]
									ZZS->ZZS_CODPA := cCodPA
									ZZS->ZZS_LOTEF := aColsA[nNx,2]
									ZZS->ZZS_QTDCMP := aColsA[nNx,5]
									ZZS->ZZS_NUMNF := aColsA[nNx,6]
									ZZS->ZZS_SERNF := aColsA[nNx,7]
									ZZS->ZZS_ORDSEP := aColsA[nNx,8]
									ZZS->ZZS_USERID := __cUserId
									ZZS->ZZS_USERNM := Alltrim(cUserName)
									ZZS->(MsUnLock())
								Else
									lRet := .F.
								EndIf
							EndIf
						EndIf
					EndIf
				Next nNx
			EndIf
		EndIf

		If lRet
			U_TFGLOTPA()
		Else
			DisarmTransaction()
		EndIf

		EndTran()

		If lRet
			MsgInfo("Dados gravados com sucesso")
		Else
			Alert("Houve erro na gravação. Nenhum dado foi alterado. Tente novamente. Se o problema persistir, contacte o administrador do sistema.")
		EndIf

	EndIf

ElseIf ( ZZS->ZZS_TPREG == "1" .Or. ZZS->ZZS_TPREG == "2" )

	For nNx := 1 to Len(aColsA)

		If !aColsA[nNx,Len(aColsA[nNx])]
			If !Empty(aColsA[nNx,2])
				lDel := .F.
				nPos := aScan( aItNF, {|x| Alltrim(x[1])+Alltrim(x[2]) == Alltrim(aColsA[nNx,1])+Alltrim(aColsA[nNx,3]) } )
				If nPos == 0
					aAdd(aItNF, { aColsA[nNx,1], aColsA[nNx,3], aColsA[nNx,5] })
				Else
					aItNF[nPos,3] += aColsA[nNx,5]
				EndIf
			EndIf
		EndIf

	Next nNx

	If lDel
		lRet := MsgYesNo("ATENÇÃO: todos os itens com lote serão excluídos. Continua com a exclusão?")
	EndIf

	If lRet .And. !lDel

		For nNx := 1 to Len(aItNF)

			cQry := "SELECT ISNULL(D1_QUANT,0) AS D1QUANT " +Iif(lDbg,CRLF,"")
			cQry += "FROM " +cSD1Tbl+ " D1 WHERE D1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_FILIAL = '" +cSD1Fil+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_DOC = '" +ZZS->ZZS_NUMNF+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_SERIE = '" +ZZS->ZZS_SERNF+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_FORNECE = '" +ZZS->ZZS_CODFOR+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_LOJA = '" +ZZS->ZZS_LOJFOR+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_ITEM = '" +aItNF[nNx,1]+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND D1_COD = '" +aItNF[nNx,2]+ "' " +Iif(lDbg,CRLF,"")

			Iif(lDbg,VISDBG(cQry),Nil)

			Iif(Select("WRKXD1")>0,WRKXD1->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXD1",.T.,.T.)
			TcSetField("WRKXD1","D1QUANT","N",12,2)
			WRKXD1->(dbGoTop())

			If WRKXD1->(!EoF())
				If WRKXD1->D1QUANT > 0
					If aItNF[nNx,3] > WRKXD1->D1QUANT
						cMsg += "Quantidade do item " +aItNF[nNx,1]+ " é maior que a da NF" +CRLF
					EndIf
				Else
					cMsg += "NF não encontrada - Item " +aItNF[nNx,1]+ CRLF
				EndIf
			Else
				cMsg += "NF não encontrada - Item " +aItNF[nNx,1]+ CRLF
			EndIf
			WRKXD1->(dbCloseArea())

		Next nNx

		If !Empty(cMsg)
			lRet := .F.
			Alert("As alterações não serão gravadas:"+CRLF+CRLF+cMsg)
		EndIf

	EndIf

	If lRet
		lRet := MsgYesNo("Confirma a gravação ?")
	EndIf

	If lRet

		cNumNF := ZZS->ZZS_NUMNF
		cSerNF := ZZS->ZZS_SERNF
		cCodFor := ZZS->ZZS_CODFOR
		cLojFor := ZZS->ZZS_LOJFOR
		cTpReg := ZZS->ZZS_TPREG

		BeginTran()

		cQry := "UPDATE " +cZZSTbl+ " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
		cQry += "WHERE D_E_L_E_T_ = ' ' "
		cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' "
		cQry += "AND ZZS_NUMNF = '" +ZZS->ZZS_NUMNF+ "' "
		cQry += "AND ZZS_SERNF = '" +ZZS->ZZS_SERNF+ "' "
		cQry += "AND ZZS_CODFOR = '" +ZZS->ZZS_CODFOR+ "' "
		cQry += "AND ZZS_LOJFOR = '" +ZZS->ZZS_LOJFOR+ "'"

		lRet := ( TcSqlExec(cQry) == 0 )

		If !lDel
			If lRet
				For nNx := 1 to Len(aColsA)
					If lRet
						If !aColsA[nNx,Len(aColsA[nNx])]
							If !Empty(aColsA[nNx,2])
								If RecLock("ZZS",.T.)
									ZZS->ZZS_FILIAL := cZZSFil
									ZZS->ZZS_TPREG := cTpReg
									ZZS->ZZS_DTEVEN := dDataBase
									ZZS->ZZS_NUMNF := cNumNF
									ZZS->ZZS_SERNF := cSerNF
									ZZS->ZZS_ITEMNF := aColsA[nNx,1]
									ZZS->ZZS_CODFOR := cCodFor
									ZZS->ZZS_LOJFOR := cLojFor
									ZZS->ZZS_COMPON := aColsA[nNx,3]
									ZZS->ZZS_LOTEF := aColsA[nNx,2]
									ZZS->ZZS_QTDCMP := aColsA[nNx,5]
									ZZS->ZZS_USERID := __cUserId
									ZZS->ZZS_USERNM := Alltrim(cUserName)
									ZZS->(MsUnLock())
								Else
									lRet := .F.
								EndIf
							EndIf
						EndIf
					EndIf
				Next nNx
			EndIf
		EndIf

		If !lRet
			DisarmTransaction()
		EndIf

		EndTran()

		If lRet
			MsgInfo("Dados gravados com sucesso")
		Else
			Alert("Houve erro na gravação. Nenhum dado foi alterado. Tente novamente. Se o problema persistir, contacte o administrador do sistema.")
		EndIf

	EndIf

EndIf

Return(lRet)



// Programa     GETLOCK
// Descricao    Insere trava nos registros para manutencao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function GetLock()
Local lRet := .T.
Local nNx := 0
Local aZZS := ZZS->(GetArea())
Local aRcn := RetRcn()

If Len(aRcn) > 0

	dbSelectArea("ZZS")
	For nNx := 1 to Len(aRcn)
		ZZS->(dbGoto(aRcn[nNx]))
		If ZZS->(RecNo()) == aRcn[nNx]
			If !MsRLock(ZZS->(aRcn[nNx]))
				lRet := .F.
			EndIf
		Else
			lRet := .F.
		EndIf
	Next nNx

EndIf

If !lRet
	If Len(aRcn) > 0
		RmvLock(aRcn)
	EndIf
EndIf

RestArea(aZZS)

Return(lRet)



// Programa     RMVLOCK
// Descricao    Remove trava dos registros ao finalizar a manutencao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RmvLock( aRcn, aParms )
Local cQry := ""
Local nNx := 0
Local aZZSArea := ZZS->(GetArea())
Default aRcn := {}
Default aParms := {}

If Len(aRcn) == 0
	If Len(aParms) > 0

		cQry := "SELECT R_E_C_N_O_ AS ZZSRCN " +Iif(lDbg,CRLF,"")
		cQry += "FROM " +cZZSTbl+ " (NOLOCK) " +Iif(lDbg,CRLF,"")
		cQry += "WHERE D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
		If aParms[1] == "0" //ZZS_TPREG
			cQry += "AND ZZS_OP = '" +aParms[2]+ "' " +Iif(lDbg,CRLF,"")
		Else
			cQry += "AND ZZS_NUMNF = '" +aParms[3]+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND ZZS_SERNF = '" +aParms[4]+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND ZZS_CODFOR = '" +aParms[5]+ "' " +Iif(lDbg,CRLF,"")
			cQry += "AND ZZS_LOJFOR = '" +aParms[6]+ "' " +Iif(lDbg,CRLF,"")
		EndIf	

		Iif(lDbg,VISDBG(cQry),Nil)

		Iif(Select("WRKRCN")>0,WRKRCN->(dbCloseArea()),Nil)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKRCN",.T.,.T.)
		TcSetField("WRKRCN","ZZSRCN","N",14,0)
		WRKRCN->(dbGoTop())

		While WRKRCN->(!EoF())
			aAdd( aRcn, WRKRCN->ZZSRCN )
			WRKRCN->(dbSkip())
		EndDo
		WRKRCN->(dbCloseArea())

	EndIf
EndIf

If Len(aRcn) > 0

	dbSelectArea("ZZS")
	For nNx := 1 to Len(aRcn)
		ZZS->(dbGoto(aRcn[nNx]))
		If ZZS->(RecNo()) == aRcn[nNx]
			ZZS->(MsRUnLock())
		EndIf
	Next nNx

EndIf

RestArea(aZZSArea)

Return(Nil)



// Programa     RETRCN
// Descricao    Retorna recnos dos registros que serao travados
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RetRcn()
Local cQry := ""
Local aRet := {}

cQry := "SELECT R_E_C_N_O_ AS ZZSRCN " +Iif(lDbg,CRLF,"")
cQry += "FROM " +cZZSTbl+ " (NOLOCK) " +Iif(lDbg,CRLF,"")
cQry += "WHERE D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
If ZZS->ZZS_TPREG == "0"
	cQry += "AND ZZS_OP = '" +ZZS->ZZS_OP+ "' " +Iif(lDbg,CRLF,"")
Else
	cQry += "AND ZZS_NUMNF = '" +ZZS->ZZS_NUMNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_SERNF = '" +ZZS->ZZS_SERNF+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_CODFOR = '" +ZZS->ZZS_CODFOR+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_LOJFOR = '" +ZZS->ZZS_LOJFOR+ "' " +Iif(lDbg,CRLF,"")
EndIf	

Iif(lDbg,VISDBG(cQry),Nil)

Iif(Select("WRKRCN")>0,WRKRCN->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKRCN",.T.,.T.)
TcSetField("WRKRCN","ZZSRCN","N",14,0)
WRKRCN->(dbGoTop())

While WRKRCN->(!EoF())
	aAdd( aRet, WRKRCN->ZZSRCN )
	WRKRCN->(dbSkip())
EndDo
WRKRCN->(dbCloseArea())

Return(aRet)



// Programa     INCITEM
// Descricao    Tela de inclusao de item na manutencao por NF conferida
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function IncItem( aColsA, oGDD )
Local oFnt2 := TFont():New("Courier New",,017,,.F.,,,,,.F.,.F.)
Local oBCn, oBOk, oGtLote, oGtDesc, oGtItem, oGtProd, oGtQuant, oSay1, oSay2, oSay3, oSay4, oSay5 := Nil
Local oDgB := Nil
Local cGtItem := Space(4)
Local cGtLote := Space(20)
Local cGtProd := ""
Local cGtDesc := ""
Local nGtQuant := 0
Local nOpt := 0

DEFINE MSDIALOG oDgB TITLE "Inclusão de Item" FROM 000, 000  TO 180, 450 COLORS 0, 16777215 PIXEL

    @ 005, 005 SAY oSay1 PROMPT "Item" SIZE 025, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 004, 040 MSGET oGtItem VAR cGtItem SIZE 035, 011 OF oDgB PICTURE "9999" VALID (!Empty(cGtItem) .And. ChkItem(aColsA,@cGtItem,@cGtProd,@cGtDesc,@oGtItem,@oGtProd,@oGtDesc,@oDgB)) COLORS 0, 16777215 FONT oFnt2 PIXEL
    @ 020, 005 SAY oSay2 PROMPT "Lote Forn." SIZE 027, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 019, 040 MSGET oGtLote VAR cGtLote SIZE 180, 011 OF oDgB COLORS 0, 16777215 FONT oFnt2 PIXEL
    @ 035, 005 SAY oSay3 PROMPT "Produto" SIZE 025, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 034, 040 MSGET oGtProd VAR cGtProd SIZE 086, 011 OF oDgB COLORS 0, 16777215 FONT oFnt2 READONLY PIXEL
    @ 050, 005 SAY oSay4 PROMPT "Descrição" SIZE 027, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 049, 040 MSGET oGtDesc VAR cGtDesc SIZE 180, 011 OF oDgB COLORS 0, 16777215 FONT oFnt2 READONLY PIXEL
    @ 065, 005 SAY oSay5 PROMPT "Quant." SIZE 025, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 064, 040 MSGET oGtQuant VAR nGtQuant SIZE 065, 011 OF oDgB PICTURE "@E 99999.99" VALID (!Empty(nGtQuant)) COLORS 0, 16777215 FONT oFnt2 PIXEL
    @ 072, 139 BUTTON oBOk PROMPT "OK" Action(nOpt:=1,oDgB:End()) SIZE 037, 012 OF oDgB  PIXEL
    @ 072, 182 BUTTON oBCn PROMPT "Cancela" Action(oDgB:End()) SIZE 037, 012 OF oDgB PIXEL

ACTIVATE MSDIALOG oDgB CENTERED

If nOpt == 1
	aColsA := aClone(oGDD:aCols)
	aAdd(aColsA, {	cGtItem,;
					PadR(cGtLote,20),;
					cGtProd,;
					cGtDesc,;
					nGtQuant,;
					.F.})

	aSort(aColsA,,,{ |x,y| X[1]+X[2] < Y[1]+Y[2] })
	oGDD:aCols := aClone(aColsA)
	oGDD:Refresh()

EndIf

Return(Nil)



// Programa     CHKITEM
// Descricao    Validacao do item incluido
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function ChkItem( aColsA, cGtItem, cGtProd, cGtDesc, oGtItem, oGtProd, oGtDesc, oDgB )
Local nNx := 0

cGtItem := StrZero(Val(cGtItem),4)
cGtProd := "" 
cGtDesc := ""

For nNx := 1 to Len( aColsA )
	If aColsA[nNx,1] == cGtItem
		cGtProd := aColsA[nNx,3]
		cGtDesc := aColsA[nNx,4]
	EndIf
Next nNx

If Empty(cGtProd)
	cGtItem := "    "
	Alert("Informe um item válido")
EndIf

oGtItem:Refresh()
oGtProd:Refresh()
oGtDesc:Refresh()
oDgB:Refresh()

Return(.T.)



// Programa     TFRSTLOP
// Descricao    Tela de consulta (rastro) por ordem de producao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
User Function TFRSTLOP()
Local oBEEx, oBPq, oBRP, oBSr, oGDFab, oGForn, oGLote, oGpNS, oGpCF := Nil
Local oGpDF, oGpLF, oGpRes, oGtNS, oGtStat, oALbx, oDgC1 := Nil
Local cGDFab := CtoD("//")
Local cGForn := Space(6)
Local cGLote := Space(20)
Local cGtNS := Space(15)
Local cGtStat := Space(255)
Local aTitCpo := {"Ord.Prod","Lote PA","Cód.PA","Desc.PA","Cod.Comp","Lote Forn.","Desc.Comp","It.Seg?","Qtd.OP","Dt.Fab","N.Série","Qtd.Lote","Nro.NF","Série","Cod.Forn.","Lj.Forn.","Nome Forn."}
Local aALbx := {{"","","","","","","","","","","",0,"","","","",""}}
Local bEndD := {||Iif(MsgYesNo("Sair da consulta de lote de fornecedor?"),oDgC1:End(),Nil)}

DEFINE MSDIALOG oDgC1 TITLE "Consulta Lote de Componentes - por Ordem de Produção" FROM 000, 000  TO 400, 892 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

	@ 002, 002 GROUP oGpLF TO 022, 076 PROMPT "Lote Fornecedor" OF oDgC1 COLOR 0, 16777215 PIXEL
	@ 002, 076 GROUP oGpCF TO 022, 136 PROMPT "Cód. Fornecedor" OF oDgC1 COLOR 0, 16777215 PIXEL
	@ 002, 136 GROUP oGpDF TO 022, 200 PROMPT "Data Fabricação" OF oDgC1 COLOR 0, 16777215 PIXEL
	@ 002, 200 GROUP oGpNS TO 022, 290 PROMPT "Nosso Número de Série" OF oDgC1 COLOR 0, 16777215 PIXEL
	@ 005, 291 BUTTON oBPq PROMPT "Pesquisa" SIZE 031, 017 OF oDgC1 ACTION (MsgRun("Aguarde... Obtendo Dados...",,{||RDTPSQA("A",@aALbx,@oALbx,cGLote,cGForn,cGDFab,cGtNS)})) PIXEL
	@ 005, 322 BUTTON oBRP PROMPT "Refinar Pesquisa" SIZE 048, 017 OF oDgC1 ACTION (MsgRun("Aguarde... Obtendo Dados...",,{||RDTPSQA("B",@aALbx,@oALbx)})) PIXEL
	@ 005, 370 BUTTON oBEEx PROMPT "Exportar Excel" SIZE 048, 017 OF oDgC1 ACTION (MsgRun("Aguarde... Exportando Dados para Excel...",,{||ExpXL(aTitCpo,aALbx)})) PIXEL
	@ 005, 418 BUTTON oBSr PROMPT "Sair" SIZE 029, 017 OF oDgC1 ACTION Eval(bEndD) PIXEL
	@ 008, 004 MSGET oGLote VAR cGLote SIZE 069, 010 OF oDgC1 COLORS 0, 16777215 PIXEL
	@ 008, 078 MSGET oGForn VAR cGForn SIZE 055, 010 F3 "SA2" OF oDgC1 COLORS 0, 16777215 PIXEL
	@ 008, 138 MSGET oGDFab VAR cGDFab SIZE 060, 010 OF oDgC1 COLORS 0, 16777215 PIXEL
	@ 008, 202 MSGET oGtNS VAR cGtNS SIZE 086, 010 F3 "SB1" OF oDgC1 COLORS 0, 16777215 PIXEL
	@ 024, 002 GROUP oGpRes TO 184, 447 PROMPT "Resultado da Pesquisa" OF oDgC1 COLOR 0, 16777215 PIXEL
	@ 032, 004 LISTBOX oALbx Fields HEADER "Ord.Prod","Lote PA","Cód.PA","Desc.PA","Cod.Comp","Lote Forn.",;
		"Desc.Comp","It.Seg?","Qtd.OP","Dt.Fab","N.Série","Qtd.Lote","Nro.NF","Série","Cod.Forn.",;
		"Lj.Forn.","Nome Forn." SIZE 440, 150 OF oDgC1 PIXEL ColSizes 50,50
	oALbx:SetArray(aALbx)
	oALbx:bLine:={||{	aALbx[oALbx:nAt,01],aALbx[oALbx:nAt,02],aALbx[oALbx:nAt,03],aALbx[oALbx:nAt,04],;
						aALbx[oALbx:nAt,05],aALbx[oALbx:nAt,06],aALbx[oALbx:nAt,07],aALbx[oALbx:nAt,08],;
						aALbx[oALbx:nAt,09],aALbx[oALbx:nAt,10],aALbx[oALbx:nAt,11],aALbx[oALbx:nAt,12],;
						aALbx[oALbx:nAt,13],aALbx[oALbx:nAt,14],aALbx[oALbx:nAt,15],aALbx[oALbx:nAt,16],;
						aALbx[oALbx:nAt,17] }}
	@ 186, 002 MSGET oGtStat VAR cGtStat SIZE 446, 010 OF oDgC1 COLORS 8421504, 16777215 READONLY PIXEL
	oDgC1:lEscClose := .F.

ACTIVATE MSDIALOG oDgC1 CENTERED

MsgRun("Aguarde... Atualizando Monitor...",,{||RUNATMNT()})

Return(Nil)



// Programa     TFRSTLNF
// Descricao    Tela de consulta (rastro) por nota fiscal
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
User Function TFRSTLNF()
Local oBEEx, oBPq, oBRP, oBSr, oGtDEmi, oGtForn, oGtNota, oGpCC, oGpCF := Nil
Local oGpDF, oGpNF, oGpRes, oGtLote, oGtStat, oALbx, oDgC2 := Nil
Local cGtDEmi := CtoD("//")
Local cGtForn := Space(6)
Local cGtNota := Space(9)
Local cGtLote := Space(20)
Local cGtStat := Space(255)
Local aTitCpo := {"Cod.Forn","Loja","Nome Forn.","Dt.Entr.","Dt.Emis.","Num.NF","Serie","Item","Lote Forn.","Cod.Comp","Descr.Comp","Quant.NF","Quant.Lote"}
Local aALbx := {{"","","","","","","","","","","",0,0}}
Local bEndD := {||Iif(MsgYesNo("Sair da consulta de lote de fornecedor?"),oDgC2:End(),Nil)}

DEFINE MSDIALOG oDgC2 TITLE "Consulta Lote de Componentes - Por Nota Fiscal" FROM 000, 000  TO 400, 892 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME

	@ 002, 002 GROUP oGpNF TO 022, 076 PROMPT "Nota Fiscal" OF oDgC2 COLOR 0, 16777215 PIXEL
	@ 002, 076 GROUP oGpCF TO 022, 136 PROMPT "Cód. Fornecedor" OF oDgC2 COLOR 0, 16777215 PIXEL
	@ 002, 136 GROUP oGpDF TO 022, 200 PROMPT "Data Emissão" OF oDgC2 COLOR 0, 16777215 PIXEL
	@ 002, 200 GROUP oGpCC TO 022, 290 PROMPT "Lote Forn." OF oDgC2 COLOR 0, 16777215 PIXEL
	@ 005, 291 BUTTON oBPq PROMPT "Pesquisa" SIZE 031, 017 OF oDgC2 ACTION (MsgRun("Aguarde... Obtendo Dados...",,{||RDTPSQB("A",@aALbx,@oALbx,cGtNota,cGtForn,cGtDEmi,cGtLote)})) PIXEL
	@ 005, 322 BUTTON oBRP PROMPT "Refinar Pesquisa" SIZE 048, 017 OF oDgC2 ACTION (MsgRun("Aguarde... Obtendo Dados...",,{||RDTPSQB("B",@aALbx,@oALbx)})) PIXEL
	@ 005, 370 BUTTON oBEEx PROMPT "Exportar Excel" SIZE 048, 017 OF oDgC2 ACTION (MsgRun("Aguarde... Exportando Dados para Excel...",,{||ExpXL(aTitCpo,aALbx)})) PIXEL
	@ 005, 418 BUTTON oBSr PROMPT "Sair" SIZE 029, 017 OF oDgC2 ACTION Eval(bEndD) PIXEL
	@ 008, 004 MSGET oGtNota VAR cGtNota SIZE 069, 010 OF oDgC2 COLORS 0, 16777215 PIXEL
	@ 008, 078 MSGET oGtForn VAR cGtForn SIZE 055, 010 F3 "SA2" OF oDgC2 COLORS 0, 16777215 PIXEL
	@ 008, 138 MSGET oGtDEmi VAR cGtDEmi SIZE 060, 010 OF oDgC2 COLORS 0, 16777215 PIXEL
	@ 008, 202 MSGET oGtLote VAR cGtLote SIZE 086, 010 F3 "SB1" OF oDgC2 COLORS 0, 16777215 PIXEL
	@ 024, 002 GROUP oGpRes TO 184, 447 PROMPT "Resultado da Pesquisa" OF oDgC2 COLOR 0, 16777215 PIXEL
	@ 032, 004 LISTBOX oALbx Fields HEADER "Cod.Forn", "Loja", "Nome Forn.", "Dt.Entr.", "Dt.Emis.",;
	  "Num.NF", "Serie", "Item", "Lote Forn.", "Cod.Comp", "Descr.Comp", "Quant.NF","Quant.Lote" ;
	  SIZE 440, 150 OF oDgC2 PIXEL ColSizes 50,50
	oALbx:SetArray(aALbx)
	oALbx:bLine:={||{	aALbx[oALbx:nAt,01],aALbx[oALbx:nAt,02],aALbx[oALbx:nAt,03],aALbx[oALbx:nAt,04],;
						aALbx[oALbx:nAt,05],aALbx[oALbx:nAt,06],aALbx[oALbx:nAt,07],aALbx[oALbx:nAt,08],;
						aALbx[oALbx:nAt,09],aALbx[oALbx:nAt,10],aALbx[oALbx:nAt,11],aALbx[oALbx:nAt,12],;
						aALbx[oALbx:nAt,13] }}
	@ 186, 002 MSGET oGtStat VAR cGtStat SIZE 446, 010 OF oDgC2 COLORS 8421504, 16777215 READONLY PIXEL
	oDgC2:lEscClose := .F.

ACTIVATE MSDIALOG oDgC2 CENTERED

MsgRun("Aguarde... Atualizando Monitor...",,{||RUNATMNT()})

Return(Nil)



// Programa     RDTPSQA
// Descricao    Retorna dados da pesquisa por ordem de producao
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RDTPSQA( cTpPsq, aALbx, oALbx, cGLote, cGForn, cGDFab, cGtNS )
Local cQry := ""
Local aMvBkp := {}
Local nNx := 0
Local lGo := .T.
Local cMsg := ""
Default cTpPsq := "A"
Default cGLote := ""
Default cGForn := ""
Default cGDFab := ""
Default cGtNS := ""

For nNx := 1 to 60
	aAdd( aMvBkp, &("MV_PAR"+StrZero(nNx,2)) )
Next nNx

If cTpPsq == "A"

	If Empty(cGLote) .And. Empty(cGForn) .And. Empty(cGDFab) .And. Empty(cGtNS)
		lGo := .F.
		cMsg := "Preencha pelo menos 1 campo para proceder à pesquisa"
	EndIf

ElseIf cTpPsq == "B"

	lGo := Pergunte("TFLOTCMP02",.T.)

EndIf

If lGo

	aALbx := {}

	cQry := "SELECT " +Iif(lDbg,CRLF,"")
	cQry += "A.NUMOP, " +Iif(lDbg,CRLF,"")
	cQry += "A.CODPA, " +Iif(lDbg,CRLF,"")
	cQry += "A.LOTPA, " +Iif(lDbg,CRLF,"")
	cQry += "A.DESCPA, " +Iif(lDbg,CRLF,"")
	cQry += "A.CODCOMP, " +Iif(lDbg,CRLF,"")
	cQry += "A.DESCCOMP, " +Iif(lDbg,CRLF,"")
	cQry += "A.ITEMSEG, " +Iif(lDbg,CRLF,"")
	cQry += "A.QTDOP, " +Iif(lDbg,CRLF,"")
	cQry += "A.DATAFAB, " +Iif(lDbg,CRLF,"")
	cQry += "A.NSERIEPA, " +Iif(lDbg,CRLF,"")
	cQry += "A.LOTEFOR, " +Iif(lDbg,CRLF,"")
	cQry += "A.QTDLOTE, " +Iif(lDbg,CRLF,"")
	cQry += "A.NUMNF, " +Iif(lDbg,CRLF,"")
	cQry += "A.SERNF, " +Iif(lDbg,CRLF,"")
	cQry += "A.CODFOR, " +Iif(lDbg,CRLF,"")
	cQry += "A.LOJFOR, " +Iif(lDbg,CRLF,"")
	cQry += "A.NOMFOR " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +Iif(lDbg,CRLF,"")
	cQry += "( " +Iif(lDbg,CRLF,"")
	cQry += "SELECT DISTINCT " +Iif(lDbg,CRLF,"")
	cQry += "D4_OP AS NUMOP, " +Iif(lDbg,CRLF,"")
	cQry += "D4_PRODUTO AS CODPA, " +Iif(lDbg,CRLF,"")
	cQry += "B1A.B1_DESC AS DESCPA, " +Iif(lDbg,CRLF,"")
	cQry += "D4_COD AS CODCOMP, " +Iif(lDbg,CRLF,"")
	cQry += "B1B.B1_DESC AS DESCCOMP, " +Iif(lDbg,CRLF,"")
	cQry += "ITEMSEG = CASE WHEN B1B.B1_ITEMSEG = '1' THEN 'Sim' ELSE '' END, " +Iif(lDbg,CRLF,"")
	cQry += "D4_QUANT AS QTDOP, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZA4_DTFAB,'') AS DATAFAB, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZA4_NUMSER,'') AS NSERIEPA, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_LOTEPA,'') AS LOTPA, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_LOTEF,'') AS LOTEFOR, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_QTDCMP,0) AS QTDLOTE, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_NUMNF,'') AS NUMNF, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_SERNF,'') AS SERNF, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_CODFOR,'') AS CODFOR, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(ZZS_LOJFOR,'') AS LOJFOR, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(A2_NOME,'') AS NOMFOR " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSD4Tbl+ " D4 " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cSB1Tbl+ " B1A ON B1A.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1A.B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1A.B1_COD = D4_PRODUTO " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cSB1Tbl+ " B1B ON B1B.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1B.B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1B.B1_COD = D4_COD " +Iif(lDbg,CRLF,"")
	If !lDbg
		cQry += "AND B1B.B1_ITEMSEG = '1' " +Iif(lDbg,CRLF,"")
	EndIf
	cQry += "INNER JOIN " +cSC2Tbl+ " C2 ON C2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND C2_FILIAL = '" +cSC2Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND C2_NUM = SUBSTRING(D4_OP,1,6) " +Iif(lDbg,CRLF,"")
	cQry += "AND C2_ITEM = SUBSTRING(D4_OP,7,2) " +Iif(lDbg,CRLF,"")
	cQry += "AND C2_SEQUEN = SUBSTRING(D4_OP,9,3) " +Iif(lDbg,CRLF,"")
	cQry += "AND C2_PRODUTO = D4_PRODUTO " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cZZSTbl+ " ZZS ON ZZS.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_OP = D4_OP " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_COMPON = D4_COD " +Iif(lDbg,CRLF,"")
	If cTpPsq == "A"
		If !Empty(cGLote)
			cQry += "AND ZZS_LOTEF = '" +cGLote+ "' " +Iif(lDbg,CRLF,"")
		EndIf
		If !Empty(cGForn)
			cQry += "AND ZZS_CODFOR = '" +cGForn+ "' " +Iif(lDbg,CRLF,"")
		EndIf
	Else
		cQry += "AND ZZS_LOTEF BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_NUMNF BETWEEN '" +MV_PAR09+ "' AND '" +MV_PAR10+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND ZZS_CODFOR BETWEEN '" +MV_PAR03+ "' AND '" +MV_PAR04+ "' " +Iif(lDbg,CRLF,"")
	EndIf
	cQry += "INNER JOIN " +cZA4Tbl+ " ZA4 ON ZA4.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZA4_FILIAL = '" +cZA4Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZA4_NUMOP = C2_NUM " +Iif(lDbg,CRLF,"")
	cQry += "AND ZA4_OPITEM = C2_ITEM " +Iif(lDbg,CRLF,"")
	cQry += "AND ZA4_OPSEQ = C2_SEQUEN " +Iif(lDbg,CRLF,"")
	cQry += "AND ZA4_COD = C2_PRODUTO " +Iif(lDbg,CRLF,"")
	If cTpPsq == "A"
		If !Empty(cGtNS)
			cQry += "AND ZA4_NUMSER = '" +cGtNS+ "' " +Iif(lDbg,CRLF,"")
		EndIf
		If !Empty(cGDFab)
			cQry += "AND SUBSTRING(ZA4_DTFAB,7,4)+SUBSTRING(ZA4_DTFAB,4,2)+SUBSTRING(ZA4_DTFAB,1,2) = '" +DtoS(cGDFab)+ "' " +Iif(lDbg,CRLF,"")
		EndIf
	Else
		cQry += "AND ZA4_NUMSER BETWEEN '" +MV_PAR07+ "' AND '" +MV_PAR08+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND SUBSTRING(ZA4_DTFAB,7,4)+SUBSTRING(ZA4_DTFAB,4,2)+SUBSTRING(ZA4_DTFAB,1,2) BETWEEN '" +DtoS(MV_PAR05)+ "' AND '" +DtoS(MV_PAR06)+ "' " +Iif(lDbg,CRLF,"")
	EndIf
	cQry += "LEFT OUTER JOIN " +cSA2Tbl+ " A2 ON A2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_FILIAL = '" +cSA2Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_COD = ZZS_CODFOR " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_LOJA = ZZS_LOJFOR " +Iif(lDbg,CRLF,"")
	cQry += "WHERE D4.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND D4_FILIAL = '02' " +Iif(lDbg,CRLF,"")
	If cTpPsq <> "A"
		cQry += "AND D4_OP BETWEEN '" +MV_PAR11+ "' AND '" +MV_PAR12+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D4_COD BETWEEN '" +MV_PAR13+ "' AND '" +MV_PAR14+ "' " +Iif(lDbg,CRLF,"")
	EndIf
	cQry += ") " +Iif(lDbg,CRLF,"")
	cQry += "AS A " +Iif(lDbg,CRLF,"")
	cQry += "ORDER BY A.NUMOP, A.NSERIEPA, A.CODCOMP " +Iif(lDbg,CRLF,"")

	Iif(lDbg,VISDBG(cQry),Nil)

	Iif(Select("WKRSTL")>0,WKRSTL->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKRSTL",.T.,.T.)
	TcSetField("WKRSTL","QTDLOTE","N",12,0)
	TcSetField("WKRSTL","DATAFAB","D",08,0)
	WKRSTL->(dbGoTop())

	While WKRSTL->(!EoF())
		aAdd( aALbx,{	WKRSTL->NUMOP,;
						WKRSTL->LOTPA,;
						WKRSTL->CODPA,;
						WKRSTL->DESCPA,;
						WKRSTL->CODCOMP,;
						WKRSTL->LOTEFOR,;
						WKRSTL->DESCCOMP,;
						WKRSTL->ITEMSEG,;
						WKRSTL->QTDOP,;
						WKRSTL->DATAFAB,;
						WKRSTL->NSERIEPA,;
						WKRSTL->QTDLOTE,;
						WKRSTL->NUMNF,;
						WKRSTL->SERNF,;
						WKRSTL->CODFOR,;
						WKRSTL->LOJFOR,;
						WKRSTL->NOMFOR })
		WKRSTL->(dbSkip())
	EndDo
	WKRSTL->(dbCloseArea())

	If Len(aALbx) == 0
		aALbx := {{"","","","","","","","","","","",0,"","","","",""}}
	EndIf

	oALbx:nAt := 1
	oALbx:aArray := aClone(aALbx)
	oALbx:Refresh()

EndIf

For nNx := 1 to Len(aMvBkp)
	&("MV_PAR"+StrZero(nNx,2)) := aMvBkp[nNx]
Next nNx

If !Empty(cMsg)
	MsgInfo(cMsg)
EndIf

Return(Nil)



// Programa     RDTPSQB
// Descricao    Retorna dados da pesquisa por nota fiscal
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function RDTPSQB( cTpPsq, aALbx, oALbx, cGtNota, cGtForn, cGtDEmi, cGtLote )
Local cQry := ""
Local cMsg := ""
Local nNx := 0
Local lGo := .T.
Local aMvBkp := {}
Default cTpPsq := "A"

aALbx := {}

For nNx := 1 to 60
	aAdd( aMvBkp, &("MV_PAR"+StrZero(nNx,2)) )
Next nNx

If cTpPsq == "A"
	If ( Empty(cGtNota) .And. Empty(cGtForn) .And. Empty(cGtDEmi) .And. Empty(cGtLote) )
		lGo := .F.
		cMsg := "Preencha pelo menos 1 campo para proceder à pesquisa"
	EndIf
Else
	lGo := Pergunte("TFLOTCMP03",.T.)
EndIf

If lGo

	cQry := "SELECT " +Iif(lDbg,CRLF,"")
	cQry += "D1_FORNECE AS CODFOR, " +Iif(lDbg,CRLF,"")
	cQry += "D1_LOJA AS LOJFOR, " +Iif(lDbg,CRLF,"")
	cQry += "A2_NOME AS NOMFOR, " +Iif(lDbg,CRLF,"")
	cQry += "D1_DTDIGIT AS ENTNF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_EMISSAO AS EMISNF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_DOC AS NUMNF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_SERIE AS SERNF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_ITEM AS ITEM, " +Iif(lDbg,CRLF,"")
	cQry += "ZZS_LOTEF AS LOTEF, " +Iif(lDbg,CRLF,"")
	cQry += "D1_COD AS CODPRO, " +Iif(lDbg,CRLF,"")
	cQry += "B1_DESC DESPRO, " +Iif(lDbg,CRLF,"")
	cQry += "SUM(D1_QUANT) AS QTDNF, " +Iif(lDbg,CRLF,"")
	cQry += "ISNULL(SUM(ZZS_QTDCMP),0) AS QTDLOTE " +Iif(lDbg,CRLF,"")
	cQry += "FROM " +cSD1Tbl+ " (NOLOCK) D1 " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cZZSTbl+ " (NOLOCK) ZZS ON ZZS.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_CODFOR = D1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_LOJFOR = D1_LOJA " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_NUMNF = D1_DOC " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_SERNF = D1_SERIE " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_ITEMNF = D1_ITEM " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_COMPON = D1_COD " +Iif(lDbg,CRLF,"")
	cQry += "AND ZZS_TPREG IN ('1','2') " +Iif(lDbg,CRLF,"")

	If cTpPsq == "A"
		If !Empty(cGtLote)
			cQry += "AND ZZS_LOTEF = '" +cGtLote+ "' " +Iif(lDbg,CRLF,"")
		EndIf
	Else
		cQry += "AND ZZS_LOTEF BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "' " +Iif(lDbg,CRLF,"")
	EndIf

	cQry += "INNER JOIN " +cSA2Tbl+ " (NOLOCK) A2 ON A2.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_FILIAL = '" +cSA2Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_COD = D1_FORNECE " +Iif(lDbg,CRLF,"")
	cQry += "AND A2_LOJA = D1_LOJA " +Iif(lDbg,CRLF,"")
	cQry += "INNER JOIN " +cSB1Tbl+ " (NOLOCK) B1 ON B1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1_FILIAL = '" +cSB1Fil+ "' " +Iif(lDbg,CRLF,"")
	cQry += "AND B1_COD = D1_COD " +Iif(lDbg,CRLF,"")
	cQry += "WHERE D1.D_E_L_E_T_ = ' ' " +Iif(lDbg,CRLF,"")
	cQry += "AND D1_FILIAL = '" +cSD1Fil+ "' " +Iif(lDbg,CRLF,"")

	If cTpPsq == "A"

		If !Empty(cGtNota)
			cQry += "AND D1_DOC = '" +cGtNota+ "' " +Iif(lDbg,CRLF,"")
		EndIf
		If !Empty(cGtForn)
			cQry += "AND D1_FORNECE = '" +cGtForn+ "' " +Iif(lDbg,CRLF,"")
		EndIf
		If !Empty(cGtDEmi)
			cQry += "AND D1_EMISSAO = '" +DtoS(cGtDEmi)+ "' " +Iif(lDbg,CRLF,"")
		EndIf

	Else

		cQry += "AND D1_DOC BETWEEN '" +MV_PAR03+ "' AND '" +MV_PAR04+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_SERIE BETWEEN '" +MV_PAR05+ "' AND '" +MV_PAR06+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_FORNECE BETWEEN '" +MV_PAR07+ "' AND '" +MV_PAR09+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_LOJA BETWEEN '" +MV_PAR08+ "' AND '" +MV_PAR10+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_DTDIGIT BETWEEN '" +DtoS(MV_PAR11)+ "' AND '" +DtoS(MV_PAR12)+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_EMISSAO BETWEEN '" +DtoS(MV_PAR13)+ "' AND '" +DtoS(MV_PAR14)+ "' " +Iif(lDbg,CRLF,"")
		cQry += "AND D1_COD BETWEEN '" +MV_PAR15+ "' AND '" +MV_PAR16+ "' " +Iif(lDbg,CRLF,"")

	EndIf	

	cQry += "GROUP BY D1_FORNECE, D1_LOJA, A2_NOME, D1_DTDIGIT, D1_EMISSAO, D1_DOC, D1_SERIE, D1_ITEM, ZZS_LOTEF, D1_COD, B1_DESC " +Iif(lDbg,CRLF,"")
	cQry += "ORDER BY D1_FORNECE, D1_LOJA, A2_NOME, D1_DTDIGIT, D1_EMISSAO, D1_DOC, D1_SERIE, D1_ITEM, ZZS_LOTEF, D1_COD, B1_DESC" +Iif(lDbg,CRLF,"")

	Iif(lDbg,VISDBG(cQry),Nil)

	Iif(Select("WKRSTL")>0,WKRSTL->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKRSTL",.T.,.T.)
	TcSetField("WKRSTL","ENTNF","D",08,0)
	TcSetField("WKRSTL","EMISNF","D",08,0)
	TcSetField("WKRSTL","QTDLOTE","N",12,0)
	WKRSTL->(dbGoTop())

	While WKRSTL->(!EoF())

		aAdd( aALbx,{	WKRSTL->CODFOR,;
						WKRSTL->LOJFOR,;
						WKRSTL->NOMFOR,;
						WKRSTL->ENTNF,;
						WKRSTL->EMISNF,;
						WKRSTL->NUMNF,;
						WKRSTL->SERNF,;
						WKRSTL->ITEM,;
						WKRSTL->LOTEF,;
						WKRSTL->CODPRO,;
						WKRSTL->DESPRO,;
						WKRSTL->QTDNF,;
						WKRSTL->QTDLOTE } )
		WKRSTL->(dbSkip())
	EndDo
	WKRSTL->(dbCloseArea())

EndIf

If Len(aALbx) == 0
	aALbx := {{"","","","","","","","","","","",0,0}}
EndIf

oALbx:aArray := aClone(aALbx)
oALbx:Refresh()

For nNx := 1 to Len(aMvBkp)
	&("MV_PAR"+StrZero(nNx,2)) := aMvBkp[nNx]
Next nNx

If !Empty(cMsg)
	MsgInfo(cMsg)
EndIf

Return(Nil)



// Programa     VISDBG
// Descricao    Monta tela para visualizar variaveis, quando modo debug estiver ativo
// Autor        Ronald Piscioneri
// Data         06-OUT-2021
// Uso          Especifico TAIFF
Static Function VISDBG(cGStr,cTit)
Local oFt1 := TFont():New("Courier New",,017,,.F.,,,,,.F.,.F.)
Local oBNo, oGStr, oDDbg := Nil
Default cGStr := "<vazio>"
Default cTit := ""

DEFINE MSDIALOG oDDbg TITLE "<<< D E B U G >>>  "+cTit FROM 000, 000  TO 480, 640 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
    @ 001, 002 GET oGStr VAR cGStr OF oDDbg MULTILINE SIZE 317, 226 COLORS 0, 16777215 FONT oFt1 READONLY HSCROLL PIXEL
    @ 228, 294 BUTTON oBNo PROMPT "Sair" Action(oDDbg:End()) SIZE 025, 010 OF oDDbg PIXEL
	oDDbg:lEscClose := .F.
ACTIVATE MSDIALOG oDDbg CENTERED

Return(Nil)



//-----------------------------------------------------------------------
//{Protheus.doc} ExpXL
//Description    Cria planilha do Excel a partir de arrays
//@author        Ronald Piscioneri
//@since         19/10/2021
//-----------------------------------------------------------------------
Static Function ExpXL( aCpos, aLin, cSheet)
Local lRet := .T.
Local nNx := 0
Local nNy := 0
Local aAux := {}
Local cFile := ""
Local cTmpP := ""
Local cWBook := "Consulta"
Local oFWMsExcel := Nil
Default cSheet := "Lotes Fornecedor"

If !Empty(aLin[1,1])

	lRet := MsgYesNo("Confirma a exportação dos dados para Excel ?")

	If lRet

		cTmpP := GetTempPath()
		cFile := "PLAN_"+__cUserId+"_"+DtoS(dDataBase)+"_"+Time()+".xml"
		cFile := StrTran(cFile,":","")
		cFile := StrTran(cFile," ","")

		oFWMsExcel := FWMSExcel():New()
		oFWMsExcel:AddworkSheet( cWBook )
		oFWMsExcel:AddTable( cWBook, cSheet )
	
		For nNx := 2 to Len(aCpos)
			oFWMsExcel:AddColumn( cWBook, cSheet, aCpos[nNx], 1, 1 )
		Next nNx

		For nNx := 1 To Len( aLin )
			aAux := {}
			For nNy := 2 to Len( aCpos )
				aAdd( aAux, aLin[ nNx, nNy ] )
			Next nNy
			oFWMsExcel:AddRow( cWBook, cSheet, aAux )
		Next nNx

		oFWMsExcel:Activate()

		If oFWMsExcel:GetXMLFile(cTmpP+cFile)
			ShellExecute( "OPEN", cTmpP+cFile , cFile, cTmpP, 3 )
		EndIf
		
	EndIf

Else

	MsgInfo("Não há dados para exportar para Excel")

EndIf


Return(lRet)



//-----------------------------------------------------------------------
//{Protheus.doc} TFGLOTPA
//Description    Grava o lote do PA na tabela do Monitor
//@author        Ronald Piscioneri
//@since         09/11/2021
//-----------------------------------------------------------------------
User Function TFGLOTPA()
Local cQry := ""
Local aUpd := {}
Local nNx := ""

cQry := "SELECT DISTINCT "
cQry += "ZA4.ZA4_LOTECT AS ZA4LOTECT, "
cQry += "ZZS.R_E_C_N_O_ AS ZZSRECNO "
cQry += "FROM "
cQry += cZZSTbl+ " ZZS (NOLOCK), "
cQry += cZA4Tbl+ " ZA4 (NOLOCK) "
cQry += "WHERE ZZS.D_E_L_E_T_ = ' ' "
cQry += "AND ZZS.ZZS_FILIAL = '" +cZZSFil+ "' "
cQry += "AND ZZS.ZZS_OP <> '' "
cQry += "AND ZZS.ZZS_LOTEPA = '' "
cQry += "AND ZA4.D_E_L_E_T_ = ' ' "
cQry += "AND ZA4.ZA4_FILIAL = '" +cZA4Fil+ "' "
cQry += "AND ZA4.ZA4_NUMOP = SUBSTRING(ZZS.ZZS_OP,1,6) "
cQry += "AND ZA4.ZA4_OPITEM = SUBSTRING(ZZS.ZZS_OP,7,2) "
cQry += "AND ZA4.ZA4_OPSEQ = SUBSTRING(ZZS.ZZS_OP,9,3) "
cQry += "AND ZA4.ZA4_COD = ZZS.ZZS_CODPA"

Iif(Select("WRKDXB")>0,WRKDXB->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKDXB",.T.,.T.)
TcSetField("WRKDXB","ZZSRECNO","N", 14, 0 )
WRKDXB->(dbGoTop())

While WRKDXB->(!EoF())
	If ( !Empty(WRKDXB->ZA4LOTECT) .And. WRKDXB->ZZSRECNO > 0 )
		aAdd( aUpd, "UPDATE " +cZZSTbl+ " SET ZZS_LOTEPA = '" +WRKDXB->ZA4LOTECT+ "' WHERE R_E_C_N_O_ = " +Alltrim(Str(WRKDXB->ZZSRECNO)) )
	EndIf
	WRKDXB->(dbSkip())
EndDo
WRKDXB->(dbCloseArea())

For nNx := 1 to Len(aUpd)
	TcSqlExec(aUpd[nNx])
Next nNx

Return(Nil)



// Programa     TFATLMNT
// Descricao    Limpa registros gerados erroneamente no ato da leitura no coletor de dados
// Autor        Ronald Piscioneri
// Data         12-NOV-2021
// Uso          Especifico TAIFF
User Function TFATLMNT()
Local cSQL := ""

cSQL := "UPDATE " +cZZSTbl+ " SET R_E_C_D_E_L_ = R_E_C_N_O_, D_E_L_E_T_ = '*' "
cSQL += "WHERE R_E_C_N_O_ IN ( "
cSQL += "SELECT DISTINCT A.R_E_C_N_O_ "
cSQL += "FROM " +cZZSTbl+ " A WHERE A.D_E_L_E_T_ = ' ' "
cSQL += "AND A.ZZS_OP <> '' "
cSQL += "AND A.ZZS_FILIAL + A.ZZS_OP + A.ZZS_COMPON NOT IN ( "
cSQL += "SELECT DISTINCT B.D4_FILIAL + B.D4_OP + B.D4_COD "
cSQL += "FROM " +cSD4Tbl+ " B WHERE B.D_E_L_E_T_ = ' ' "
cSQL += "AND B.D4_FILIAL = '" +cSD4Fil+ "' "
cSQL += "AND B.D4_OP = A.ZZS_OP "
cSQL += "AND B.D4_COD = A.ZZS_COMPON ) )"

TcSqlExec( cSQL )

Return(Nil)



// Programa     RUNATMNT
// Descricao    Execute funcoes de atualizacao do monitor de lote de componente
// Autor        Ronald Piscioneri
// Data         16-NOV-2021
// Uso          Especifico TAIFF
Static Function RUNATMNT()
U_TFATLMNT()
U_TFGLOTPA()
Return(Nil)
