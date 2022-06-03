#include "protheus.ch"
#include "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBPFRETE ºAutor  ³ Anderson Messias   º Data ³  18/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Contabilização da Fatura de Frete                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBPFrete(_lMostra,_cFatura,_cTransp,_lEstorno)

Local aSavATU   := GetArea()
Local aSavPAV   := PAV->(GetArea())
Local aSavSF2   := SF2->(GetArea())
Local _cPadraoC := SuperGetMV("MV_XLPCFRE",,"010")
Local _cPadraoE := SuperGetMV("MV_XLPEFRE",,"011")
Local _cPadrao  := ""
Local _cArquivo := ""
Local _nTotal   := 0
Local cLote     := SuperGetMV("MV_XLOTFRE",,"008880")

DEFAULT _lMostra := .T.
DEFAULT _cFatura := "*********"
DEFAULT _cTransp := "******"
DEFAULT _lEstorno:= .F.

if _lEstorno
	_cPadrao := _cPadraoE
else
	_cPadrao := _cPadraoC
endif

_lPadraoC := VerPadrao(_cPadraoC)
_lPadraoE := VerPadrao(_cPadraoE)

DBSelectArea("PAV")
DBSetOrder(1)
if DBSeek(xFilial("PAV")+_cFatura+_cTransp)
	_nHdlPrv := HeadProva(cLote,"CTBPFRETE",alltrim(Substr(cUsuario,7,15)),@_cArquivo)
	While !PAV->(Eof()) .AND. PAV->PAV_CODTRA == _cTransp .AND. PAV->PAV_FATURA == _cFatura
		DBSelectArea("SF2")
		DBSetOrder(1)
		if DBSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE)
			_nTotal += DetProva(_nHdlPrv,_cPadrao,"CTBPFRETE",cLote)
		endif
		PAV->(DBSkip())
	EndDo
	RodaProva(_nHdlPrv,_nTotal)
	cA100Incl(_cArquivo,_nHdlPrv,3,cLote,_lMostra,.F.)
endif

RestArea(aSavSF2)
RestArea(aSavPAV)
RestArea(aSavATU)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBPFRETE ºAutor  ³ Anderson Messias   º Data ³  18/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Contabilização da devolução do frete de notas    º±±
±±º          ³ que nao sairam da empresa porem devem ser devolvidas via   º±±
±±º          ³ documento de entrada                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBDevFrete()

Local nValorFrete := 0
Local aSavATU     := GetArea()
Local aSavSD1     := SD1->(GetArea())
Local aSavSF2     := SF2->(GetArea())

//Esta funcao necessita que a nota de entrada esteja posicionada, ou seja, so pode ser usada na LP de contabilização do cabecalho da nota de entrada
if SF1->F1_TIPO == "D" //Somente se for devolução
	DBSelectArea("SD1")
	DBSetOrder(1)
	if DBSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		//Localizo a nota fiscal de origem do primeiro item da nota de devolução
		//Os campos SeriOri e NFOri devem estar preenchidos devidamente para localizar o documento de saida
	    DBSelectArea("SF2")
	    DBSetOrder(1)
	    if DBSeek(xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI)
	    	if DTOS(SF2->F2_DTEMB) == "19000101" //Somente retornar valor a devolver se a data de embarque for 01/01/1900
		    	nValorFrete := SF2->F2_PRVFRE	
		    endif
	    endif
	endif
endif

RestArea(aSavSF2)
RestArea(aSavSD1)
RestArea(aSavATU)

Return nValorFrete

/* Rotinas de Teste da contabilização 
User Function CTBPFreExe()
u_CTBPFrete(.T.,"000043552","000745",.F.)
u_CTBPFrete(.T.,"000043552","000745",.T.)
Return

User Function CTBPFreMES()

local cQuery

cQuery := "SELECT DISTINCT "
cQuery += "  PAV_FATURA, PAV_CODTRA,PAV_EMISFA "
cQuery += "FROM "
cQuery += "  "+RetSQLName("PAV")+" "
cQuery += "WHERE "
cQuery += "  D_E_L_E_T_='' AND "
cQuery += "  PAV_EMISFA BETWEEN '20120301' AND '20120330' "
cQuery += "ORDER BY "
cQuery += "  PAV_CODTRA,PAV_EMISFA,PAV_FATURA "
If Sele("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DBSelectArea("TRB")

dDataOld := dDatabase

While !TRB->(Eof())
	dDatabase := STOD(TRB->PAV_EMISFA)
	u_CTBPFrete(.T.,TRB->PAV_FATURA,TRB->PAV_CODTRA,.F.)
	TRB->(DBSkip())
EndDo

dDatabase := dDataOld

DBSelectArea("TRB")
DBCloseArea()

Return

User Function PROVPFreMES()

local cQuery

cQuery := "SELECT DISTINCT "
cQuery += "  PAV_NF, PAV_SERIE "
cQuery += "FROM  "
cQuery += "  "+RetSQLName("PAV")+" "
cQuery += "WHERE "
cQuery += "  D_E_L_E_T_='' AND "
cQuery += "  PAV_EMISFA BETWEEN '20120301' AND '20120330' "
cQuery += "ORDER BY "
cQuery += "  PAV_NF, PAV_SERIE "

If Sele("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DBSelectArea("TRB")
dDataOld := dDatabase

While !TRB->(Eof())
	DBSelectArea("SF2")
	DBSetOrder(1)
	if DBSeek(xFilial("SF2")+TRB->PAV_NF+TRB->PAV_SERIE)
		dDatabase := SF2->F2_EMISSAO
		
		If SF2->F2_TIPO $ 'B/D'
			DbSelectArea("SA2")
			DbSetOrder(1)
			if DbSeek( xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA )
				_cCep	:= SA2->A2_CEP
				_cEst	:= SF2->F2_EST
			endif
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			if DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA )
				_cCep	:= SA1->A1_CEP
				_cEst	:= SA1->A1_EST
				_lTDE	:= SA1->A1_FRETED == "S"
			endif
		Endif
		
		_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT ,SF2->F2_PBRUTO , _cEst,_cCep,"N",SF2->F2_TRANSP,SF2->F2_EMISSAO,_lTDE,.T.)
		
		If len(_aCalTrans) > 0
			SF2->( RecLock("SF2",.F.) )
			//SF2->F2_PESOPRE 	:= _aCalTrans[1][3][6]  // Valor do Frete Peso
			SF2->F2_PRVFRE 	:= _aCalTrans[1][3][9]  // Valor  Total do Frete
			SF2->( MsUnlock() )
		EndIf
		
	endif
	TRB->(DBSkip())
EndDo

dDatabase := dDataOld

DBSelectArea("TRB")
DBCloseArea()

Return
*/