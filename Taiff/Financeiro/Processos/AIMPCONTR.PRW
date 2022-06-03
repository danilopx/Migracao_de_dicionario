#INCLUDE 'protheus.ch'
#INCLUDE 'rwmake.ch'
#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"

#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK		 	2
#define CMD_ACTIVEWORKSHEET  		3
#define CMD_READCELL				4
#Define ENTER CHAR(13) + CHAR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  IMPCONTR  บAutor  ณ JACKSON SANTOS 	 บ Data ณ  25/03/15 	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa de importa็ใo dos Contratos de envididamento.    -บฑฑ
ฑฑบ          ณ 										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIMPCONTR()
	Local oDlg
	//Local oBtn1
	//Local oBtn2
	Local oBtn3
	Local oBtn4
	Local nL := 0
//Local oFont     :=TFont():New("Arial",,24,,.T.,,,,.T.,.F.)
// Fontes usadas nas Telas
	Private oFont   		:= TFont():New("Courier New",,-12,.T.)
	Private oFont1  		:= TFont():New("Courier New",,-14,.T.)
	Private oFont3  		:= TFont():New("Arial"      ,,-16,.T.)

	Private nQtdOk	 := 0
	Private cNomArq := "", cCmpArq := "", oSayTrN		// Variแveis do arquivo a ser importado
	Private dGetDtSel := DDataBase
	Private cGetPasta := PADR("Plan1",20)
	Private cGetModal  := SPACE(5)
	Private cGetDescr := SPACE(20)
	Private cGetTpimp := ""
	Private lLibFin   := .F.
	Private nDMaisPar := SuperGetMV("DG_DIMAISP",.f.,2)
	Private nDMenosPar := SuperGetMV("DG_DMENOSP",.f.,2)
	Private aGetTpImp := {} //"1-CDC","2-Leasing","3-BNDS","4-Capital de Giro","5-Finame","6-Finimp"}
	Private cGetFilial   := Space( TamSx3("ZY_FILIAL")[1])

	Private cGetCodBanc	:= Space( TamSx3("ZY_CODBCO")[1])
	Private cGetCodAgen	:= Space( TamSx3("ZY_BCOAGEN")[1])
	Private cGetCodCont	:= Space( TamSx3("ZY_BCOCONT")[1])
	Private cGetModalid	:= Space( TamSX3("ZY_MODFIIN")[1])
	Private dGetDtCredi	:= DDataBase

	Private cGetTbFinan 	:= Space( TamSx3("ZY_TBFINAN")[1])
	Private aGetTbFinan 	:= {"1->SAC","2->Price"} //Space( TamSx3("ZY_TBFINAN")[1])

	Private cGetFormPag	:= Space( TamSX3("ZY_FORMPGT")[1])
	Private aGetFormPag	:= {"1->Debito CC","2->Boleto"} //Space( TamSX3("ZY_FORMPGT")[1])


//Aba de Valores do Contrato
	Private cGetContrat  := Space(4) //Space( TamSx3("ZY_CODCONT")[1])
	Private cGetTpJuros	:= Space(4) //Space( TamSX3("ZY_TPJUROS")[1])
	Private cGetTpVaria  := Space(4) //Space( TamSX3("ZY_TPVARIA")[1])
	Private cGetTipoIOF	:= Space(4) //Space( TamSx3("ZY_TIPOIOF")[1])
	Private cGetTipoTAC	:= Space(4) //Space( TamSx3("ZY_TIPOTAC")[1])

	Private cGetVlrTAC	:= Space(4) //Transform(0.00,"@E 999,999.99")
	Private cGetQParcel  := Space(4) //Transform(000 ,"@E 999")
	Private cGetVlrCont	:= Space(4) //Transform(0.00,"@E 999,999,999.99")
	Private cGetVrTotFi  := Space(4) //Transform(0.00,"@E 999,999,999.99")
	Private cGetVrIofCT	:= Space(4) //Transform(0.00,"@E 999,999.99")
	Private cGetTxJufMM	:= Space(4) //Transform(0.00,"@E 999.9999999")
	Private cGetTxJurAA 	:= Space(4) //Transform(0.00,"@E 999.9999999")
	Private cGetDiaVenP 	:= Space(4) //Transform(01,"@E 99")
	Private cGetDtPrPar	:= Space(4) //DTOC("  /  /  ")

	Private cGetTCarenc 	:= Space(4) //Transform(00,"@E 99")
	Private cGetJrCaren	:= Space(4) //Space( TamSx3("ZY_JRCAREN")[1])
	Private cGetCarPrin 	:= Space(4) //Space( TamSx3("ZY_CARPRIN")[1])
	Private cGetJurCarI 	:= Space(4) //Space( TamSx3("ZY_JURCARI")[1])

//Detalhamento da Parcela
	Private cGetNumParc := Space(4)
	Private cGetParVenc := Space(4)
	Private cGetParPrin := Space(4)
	Private cGetParJuro := Space(4)
	Private cGetParVJur := Space(4)
	Private cGetParViof := Space(4)
	Private cGetParSald := Space(4)
	Private cGetParApag := Space(4)
	Private cGetParDtPg := Space(4)
	Private cGetParVrPG := Space(4)
	Private lWhenDesc	:= .F.
//Grava็ใo dos Pr้-Layout's

//"1-CDC","2-Leasing","3-BNDS","4-Capital de Giro","5-Finame","6-Finimp"
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))

	For nL := 1 To 6
		If !SZ5->(DbSeek(xFilial("SZ0") + STRZERO(nL,3)))
			aRetPreLay := LayoutCtr(nL,.T.)
			If nL == 1
				cDescriL := "CDC"
			ElseIf nL == 2
				cDescriL := "Leasing"
			ElseIf nL == 3
				cDescriL := "BNDS"
			ElseIf nL == 4
				cDescriL := "Capital de Giro"
			ElseIf nL == 5
				cDescriL := "Finame"
			Else
				cDescriL := "Finimp"
			EndIf
			GrvSZ0Lay(Alltrim(STR(nL)),cDescriL,aRetPreLay,cGetModal)
		EndIf
	Next

//Alimenta Variแvel dos Modelos de Layout's para imporata็ใo:
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	SZ0->(DbGoTop())
	If SZ0->(!EOF())
		While SZ0->(!EOF()) //.And. Alltrim(SZ0->SR_TABELA) == "#E"
			AaDd(aGetTpImp,Alltrim(SZ0->Z0_CODIGO) + "-" + Alltrim(SZ0->Z0_DESCRI))
			SZ0->(DbSkip())
		EndDo
	EndIf
	DEFINE MSDIALOG oDlg TITLE "Parโmetros Iniciais" FROM C(0),C(0) TO C(250),C(400) PIXEL

	AaDd(aGetTpImp,Alltrim(Strzero(Len(aGetTpImp)+1,3)) + "-Indefinido" )

	@ C(015),C(010) Say "TP. Contrato:" Size C(030),C(020) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(016),C(040) ComboBox cGetTpimp Items aGetTpImp Valid TrocaCbx(cGetTpImp,"cGetTpImp") SIZE C(060),C(020) OF oDlg  PIXEL

	@ C(040),C(010) Say "Nome da Aba Plan.:" Size C(030),C(020) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(041),C(040) MsGet oGet1 Var cGetPasta Picture "@!" Size C(054),C(015) COLOR CLR_BLACK PIXEL OF oDlg

	@ C(065),C(010) Say "Modalidade:" Size C(030),C(020) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(066),C(040) MsGet oGet2 Var cGetModal Picture "@!" Size C(054),C(015) F3 "SZW" COLOR CLR_BLACK PIXEL OF oDlg

	@ C(065),C(105) Say "Desc.Layout:" Size C(030),C(020) COLOR CLR_BLACK PIXEL OF oDlg
	@ C(066),C(135) MsGet oGet3 Var cGetDescr When lWhenDesc Picture "@!" SIZE C(054),C(015) OF oDlg  PIXEL

//@ C(031),C(010) Say "Data Sele็ใo:" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg
//@ C(030),C(031) MsGet oGet2 Var dGetDtSel Picture "@E" Size C(184),C(009) COLOR CLR_BLACK PIXEL OF oDlg
	lProcOk := .F.
	oBtn3:=tButton():New(C(100),C(050),'Iniciar Processo',oDlg,{|| iiF( Validproc("1"), lProcOk := TELAPARAM(),oDlg:End()),IIF(lProcOk,Valida(oDlg),)},50,20,,,,.T.)
	oBtn4:=tButton():New(C(100),C(110),'Fechar',oDlg,{||oDlg:End()},50,20,,,,.T.)

	ACTIVATE MSDIALOG oDlg CENTERED
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณTELAPARAM  บAutor  ณJackson Santos        บ Data ณ 28/12/2013      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ บฑฑ
ฑฑบDesc.     Tela de Parametros                     							 			บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       ณMP 11 - ENDIVIDAMENTOV                                          	บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/

Static Function TELAPARAM()
	Local aArea			:= GetArea()
	//Local lProc			:= .F.
	Local oDlg1
	Local ni := 0
	Local nP := 0

//Aba Principal                 
	Private aCadPrinc 	:= {}
	Private cCadastro 	:= "Defini็ใo da Importa็ใo de Contratos"

//Pre-Defini็ใo Lyout
	aPreLayout := LayoutCtr(Val(Left(cGetTpimp,3)),.F.)
	lWhenPre   := .T.
	If Len(aPreLayout) > 0 .And. Val(Left(cGetTpimp,3)) < Len(aGetTpImp)
		lWhenPre := .T.
		For ni:=1 To len(aPreLayout)
			//Carregar as Variแvies pr้-definidas
			&(aPreLayout[nI][1]) := aPreLayout[nI][2]
		Next ni
	EndIf

	DEFINE MSDIALOG oDlg1 TITLE cCadastro FROM 000, 000  TO 550, 950 COLORS 0, 16777215 PIXEL

	@ 010, 010 To 076,463 Label "Refer๊ncias" Of oDlg1 Pixel
	@ 079, 010 To 146,463 Label "Cabe็alho" Of oDlg1 Pixel
	@ 149, 010 To 217,463 Label "Parcelas" Of oDlg1 Pixel


	//Filial
	cGetFilial := xFilial("SZY")
	@ 025, 020 Say "Cod.Filial: " Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 035, 020 MsGet cGetFilial Picture "@!"  WHEN .F. SIZE 050,10 Of oDlg1 Pixel

	cFilName := FWFilialName()

	@ 025, 090 Say "Nome Filial: " Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 035, 090 MsGet cFilName Picture "@!"   	WHEN .F. SIZE 120,10 Of oDlg1 Pixel

	//Dados Principais do Contrato

	@ 050, 020 Say "Cod. Banco: " Size 100,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 060, 020 MsGet cGetCodBanc Picture "@E"  /*Valid   VLCampo()*/ F3 "SA6" SIZE 060,10 Of oDlg1 Pixel

	@ 050, 100 Say "Cod.Ag๊ncia:" Size 100,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 060, 100 MsGet cGetCodAgen Picture "@E" 	/*Valid  VLCampo()*/  SIZE 060,10 Of oDlg1 Pixel

	@ 050, 180 Say "Cod.Conta: " Size 100,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 060, 180 MsGet cGetCodCont Picture "@E"  /*Valid   VLCampo() F3 "SA1"*/  SIZE 060,10 Of oDlg1 Pixel

	If !Empty(cGetModal)
		cGetModalid := cGetModal
	EndIf
	@ 050, 260 Say "Modalidade: " Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 060, 260 MsGet cGetModalid Picture "@!" 	/*Valid  VLCampo()*/ F3 "SZW" SIZE 080,10 Of oDlg1 Pixel

	@ 050, 340 Say "Data do Credito: " Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 060, 340 MsGet dGetDtCredi Picture "@E" 	/*Valid  VLCampo()*/ F3 "SZW" SIZE 080,10 Of oDlg1 Pixel

	// Aba Valores Contrato
	@ 085, 020 Say "Cod.Contrato: " Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 020 MsGet cGetContrat Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel     //NaoVazio( cGetForn ) .And.

	@ 085, 085 Say "Valor Tac: 	" Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 085 MsGet cGetVlrTAC Picture "@!" 	WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel    //NaoVazio( cGetLoja ) .And.

	@ 085, 150 Say "Qtd.Parcelas: " Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 150 MsGet cGetQParcel Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel     //NaoVazio( cGetForn ) .And.

	@ 085, 215 Say "Vlr.Contrato: " Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 215 MsGet cGetVlrCont Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel


	@ 085, 280 Say "V.Tot.Finan.: " Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 280 MsGet cGetVrTotFi Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 085, 345 Say "Valor IOF	: "  Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 095, 345 MsGet cGetVrIofCT Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 120, 020 Say "Tx.Juros M๊s:" Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 130, 020 MsGet cGetTxJufMM Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 120, 085 Say "Tx.Juros Ano:" Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 130, 085 MsGet cGetTxJurAA Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 120, 150 Say "D.Venc.Par.: " Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 130, 150 MsGet cGetDiaVenP Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 120, 215 Say "Dt.Venc.1บPar:" Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 130, 215 MsGet cGetDtPrPar Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	@ 120, 280 Say "Temp.Carencia" Size 055,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 130, 280 MsGet cGetTCarenc Picture "@!" WHEN lWhenPre SIZE 040,10 Of oDlg1 Pixel

	// Parcelas
	@ 157, 020 Say "Num.Parcela" Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 020 MsGet cGetNumParc Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 157, 085 Say "Venc.Parcela" Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 085 MsGet cGetParVenc Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 157, 150 Say "Vlr.Princ.Par. " Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 150 MsGet cGetParPrin Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 157, 215 Say "Vlr.Juros.Par. " Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 215 MsGet cGetParJuro Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 157, 280 Say "Vlr.Jur.Var/aPg." Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 280 MsGet cGetParVJur Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 157, 345 Say "Vlr.IOF Parcela " Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 167, 345 MsGet cGetParViof Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 192, 020 Say "Vlr.Saldo.Contr." Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 020 MsGet cGetParSald Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 192, 085 Say "Vlr.Parcel.เ.PG." Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 085 MsGet cGetParApag Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 192, 150 Say "Dt.Pagam.Parcel." Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 150 MsGet cGetParDtPg Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel

	@ 192, 215 Say "Vlr.Pago.Parcela" Size 060,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 215 MsGet cGetParVrPG Picture "@E"  /*Valid VLCampo()*/ WHEN lWhenPre SIZE 040,010 Of oDlg1 Pixel



	// Tabelas de Financiamento
	@ 192, 280 Say "Tab.Financiam.:" Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 280 ComboBox cGetTbFinan Items aGetTbFinan SIZE 080,40 Of oDlg1 Pixel

	@ 192, 380 Say "Forma de Pagam:" Size 120,10 FONT oFont1 COLOR CLR_BLUE Of oDlg1 Pixel
	@ 202, 380 ComboBox cGetFormPag Items aGetFormPag Valid TrocaCbx("","cGetFormPag") SIZE 080,40 Of oDlg1 Pixel

	//DEFINE SBUTTON oSButton1 FROM 225, 120 TYPE 1 OF oDlg1 ENABLE ACTION IIf( VLCampo("OK"),  Processa( {|| /*lOk :=  TelaConsu(), oDlg1:End()*/ }, 'Aguarde...Verificando dados ...' ) , )
	nOpcas := 0
	DEFINE SBUTTON oSButton1 FROM 230, 120 TYPE 1 OF oDlg1 ENABLE ACTION (IIF(Validproc("2"),nOpcas := 1,),IIF(nOpcas == 1,oDlg1:End(),))
	DEFINE SBUTTON oSButton2 FROM 230, 160 TYPE 2 OF oDlg1 ENABLE ACTION (nOpcas := 2,oDlg1:End())

	ACTIVATE MSDIALOG oDlg1 CENTERED

	If nOpcas <>  1
		lRetParam :=  .F.
	Else
		//	If Val(Left(cGetTpimp,3)) == Len(aGetTpImp)
		For nP := 1 To Len(aPreLayout)
			aPreLayout[nP][2] := IIF(!Empty(Alltrim(&(aPreLayout[nP][1]))),&(aPreLayout[nP][1]),SPACE(04))
		Next nP
		If MsgYesNo("Deseja Salvar o Layout para Pr๓ximas Importa็๕es?","Layot")
			GrvSZ0Lay(Left(cGetTpimp,3),Substr(Alltrim(cGetTpimp),5),aPreLayout,cGetModalid)
		EndIf
		//EndIf
		lRetParam := .T.
	EndIf
	RestArea( aArea )

Return lRetParam

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValida    บAutor  ณJackson Santos      บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo se o arquivo foi selecionado antes de iniciar a  บฑฑ
ฑฑบ          ณ importa็ใo dos dados                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Valida(oDlg)
	//Local   cSql
	Local nI := 0
	Private nImports := 0
	Private nLin     := 0
	Private aTotal   := {}
	Private aErros 	:= {}
	Private aGrvDados := {}
	Private aGrvCabec := {}
	Private cPatch	:= "C:\LOGIMPORT\"
	Private cArq	:= ""
	Private _ArqTemp1
	Private aStru	:= {}

	IF !fVincArq()
		Alert("Arquivo nใo encontrado!")
		Return
	EndIf

	MsgRun("Importando Contrato","Processando Importa็ใo",{|| Importa() })

	If Len(aErros) > 0

		aadd(aStru,{"CODCONTR"		,"C",20,0})
		aadd(aStru,{"NUMPARCELA"	,"C",03,0})
		aadd(aStru,{"DTVENCPAR"		,"D",10,0})
		aadd(aStru,{"VLRPRINCIP"	,"N",12,2})
		aadd(aStru,{"VLRJUROS"		,"N",12,2})
		aadd(aStru,{"VLRJURVAR"		,"N",12,2})
		aadd(aStru,{"VLRIOFPAR"		,"N",12,2})
		aadd(aStru,{"VLRSALDO"		,"N",12,2})
		aadd(aStru,{"VLRAPAGAR"		,"N",12,2})
		aadd(aStru,{"DTPAGTO"	   ,"D",10,0})
		aadd(aStru,{"VALORPAGO"	   ,"N",12,2})
		aadd(aStru,{"MENSAGEM" 		,"C",40,0})

		_ArqTemp1 := CriaTrab( aStru, .T. )
		If Select("TMPEXC") > 0
			TMPEXC->(DbCloseArea())
		EndIf
		DbUseArea( .T. ,, _ArqTemp1 , "TMPEXC", .F. , .F. )

		For nI := 1 To Len(aErros)
			RecLock("TMPEXC",.T.)
			TMPEXC->CODCONTR 		:= aErros[ni][1]
			TMPEXC->NUMPARCELA 	:= aErros[ni][2]
			TMPEXC->DTVENCPAR 	:= aErros[ni][3]
			TMPEXC->VLRPRINCIP 	:= aErros[ni][4]
			TMPEXC->VLRJUROS 	:= aErros[ni][5]
			TMPEXC->VLRJURVAR := aErros[ni][6]
			TMPEXC->VLRIOFPAR := aErros[ni][7]
			TMPEXC->VLRSALDO	:= aErros[ni][8]
			TMPEXC->VLRAPAGAR := aErros[ni][9]
			TMPEXC->DTPAGTO	:= aErros[ni][10]
			TMPEXC->VALORPAGO := aErros[ni][11]
			TMPEXC->MENSAGEM		 := aErros[nI][12]
			TMPEXC->(MSUNLOCK())
		Next nI

		cArq  := _ArqTemp1+".DBF"
		lExistDir := ExistDir(cPatch)
		//Controlar Existencia e cria็ใo do Diret๓rio Absent
		If !lExistDir
			nRet := makeDir( cPatch )
			If nRet != 0
				MsgAlert("Nใo Foi Possivel Criar o Diret๓rio '" + cPatch + " , o Arquivo Serแ Gravado no Temp do Usuแrio","Alerta Diret๓rio")
				cPatch := AllTrim(GetTempPath())
			EndIf
		EndIf
		TMPEXC->(DbCloseArea())

		If ApOleClient("MsExcel")

			__CopyFIle(cArq , cPatch +"LOGIMP" + DTOS(DDATABASE) + ".DBF")

			oExcelApp:= MsExcel():New()
			oExcelApp:WorkBooks:Open(cPatch+"LOGIMP" + DTOS(DDATABASE) + ".DBF")
			oExcelApp:SetVisible(.T.)
		EndIf

	EndIf
	MsgInfo("O processo de Importa็ใo foi concluํdo. Foram importados " + Alltrim(Str(nQtdOk)) + " de "  + Alltrim(Str(nImports))+ " registros.","Processo Concluํdo")
	oDlg:End()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ C        บAutor  ณMicrosiga           บ Data ณ  ??/??/??   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao responsavel por manter o Layout independente da     บฑฑ
ฑฑบ          ณ resolucao horizontal do Monitor do Usuario.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function C(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf
Return Int(nTam)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVincArq  บAutor  ณJackson Santos      บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Vincula arquivo+localiza็ใo completa do espelho da rota    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVincArq()
	cCmpArq := cGetFile('Arquivos (*.*)|*.*' , 'Selecione o Arquivo a ser importado, formato XLS',1,'C:\',.F.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

	if Empty(cCmpArq)
		Return .F.
	endif

	cNomArq := fNomArq(cCmpArq, "\")	// Retorna o nome do arquivo

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfNomArq   บAutor  ณJackson Santos      บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna parte do nome do arquivo digitalizado              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fNomArq(cPar, cToken)
	Local nPos  := 0
	Local cFile := ""

	if (nPos := RAT(cToken, StrTran(cPar,"/","\"))) != 0
		cFile := SubStr(cPar, nPos+1)
	endif
Return cFile


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVisualArqบAutor  ณJackson Santos      บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visu	aliza arquivo da ser Importado para o Protheus         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVisualArq()
	if !Empty(cCmpArq) .and. File(cCmpArq)	// Exibe arquivo nใo salvo
		ShellExecute("open",cCmpArq,"","",1)
		Return .T.
	endif
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImporta   บAutor  ณJackson Santos      บ Data ณ  24/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo dos Registros...  abre arquivo TXT, trata e     บฑฑ
ฑฑบ          ณ cadastra nas tabelas                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ENDIVIDAMENTO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Importa()


	Local cBuffer	:= ''
	Local cFile		:= ''
	Local aCells	:= {} //array com as celulas a serem lidas
	//Local aPeditens := {}
	Local nI		:= 0
	Local nCelini   := 2 //posicao da primeira celula com valor
	Local nTCarenc := 0
	Local cPasta    := Alltrim(cGetPasta) //"Plan1" //nome da pasta dentro da planilha
	Local aplanilha :={}
	Local cPatchDll := "C:\DLL\"
	Local cArqDll  := "\DLLEXCEL\readexcel.dll"
	Local lErroImp := .F.
	//Local lIncProduto := SuperGetMV("TW_INCPROD",.f.,.f.)
	Local nContPar := 0 //Contar as parcelas
	Local cPrefixCTR := "'FIN','FNP','EMP','BND','LEA','CDC','MIG'"
	Local nP := 0
	Local nCont := 0
	Local nk := 0

	Private lGatilho := .F.
	Private cMsg := ""
	Private aCposGrv := {}
	cDir := substr(cCmpArq,1,RAT("\", StrTran(cCmpArq,"/","\")))
	cArqui := cNomArq

	cFile:= cDir + cArqui

	nCont:=1
	cMV_PLAN:=ALLTRIM(cArqui)
	do while nCont<len(cMV_PLAN)
		nAt:=AT(";",SUBSTR(cMV_PLAN,nCont,len(cMV_PLAN)) )
		if nAt=0
			nAt:=len(cMV_PLAN)+1
		endif
		aAdd(aPlanilha,ALLTRIM(cDir)+substr(cMV_PLAN,nCont,nAt-1))
		nCont:=nAt+1
	enddo

	lExistDir := ExistDir(cPatchDll)
//Controlar Existencia e cria็ใo do Diret๓rio da DLL
	If !lExistDir
		nRet := makeDir( cPatchDll )
		If nRet != 0
			MsgAlert("Nใo Foi Possivel Criar o Diret๓rio '" + cPatchDll + " ,  Arquivo Serแ Gravado no Temp do Usuแrio","Alerta Diret๓rio")
			cPatchDLL := AllTrim(GetTempPath())
			lErroImp := .T.
		Else
			lErroImp := .F.
		EndIf
		If File(cArqDll) .And. !lErroImp
			__CopyFIle(cArqDll , cPatchDll+"readexcel.dll")
			lErroImp := .F.
		Else
			lErroImp := .T.
		EndIf
	Else
		IF !File(cPatchDll+"readexcel.dll")
			If File(cArqDll)
				__CopyFIle(cArqDll , cPatchDll+"readexcel.dll")
				lErroImp := .F.
			Else
				lErroImp := .T.
			EndIf
		Else
			lErroImp := .F.
		EndIf
	EndIf

	cCtrPrefix := SuperGetMV("DG_PREFCTR",.f.,"")
	If !Empty(cCtrPrefix)
		lCtrContin := .T.
		cPrefixCTR := "'"
		While lCtrContin

			//For nP:=1 to len(cCtrPrefix)
			nVirgula := At(";",Alltrim(cCtrPrefix))
			nPontVir := At(",",Alltrim(cCtrPrefix))
			nBarraDt := At("/",Alltrim(cCtrPrefix))

			If  nVirgula > 0  .Or. nPontVir  > 0 .Or. nBarraDt  > 0
				nPontAt := nVirgula + nPontVir + nBarraDt
				cPrefixCTR += Substr(Alltrim(cCtrPrefix),1,nPontAt-1) + ",'"
				cCtrPrefix := STUFF(cCtrPrefix, 1, nPontAt,"")
			Else
				cPrefixCTR += Alltrim(cCtrPrefix)
				lCtrContin := .F.
				Loop
			EndIf
			//Next

		EndDo
		cPrefixCTR += "'"
	EndIf

	IF !lErroImp
		FOR nCont:=1 to Len(aPlanilha)
			nHdl    := ExecInDLLOpen(cPatchDll+"readexcel.dll")
			cBuffer := ''
			nCelini := 1  //posicao da primeira celula com valor

			cFile	:= aPlanilha[nCont]
			aCells	:= {}

			// Monta array das celulas que serao lidas
			Aadd(aCells,{  'A'+alltrim(str(nCelini)),'B'+alltrim(str(nCelini)),'C'+alltrim(str(nCelini)),'D'+alltrim(str(nCelini)),;
				'E'+alltrim(str(nCelini)),'F'+alltrim(str(nCelini)),'G'+alltrim(str(nCelini)),'H'+alltrim(str(nCelini)),'I'+alltrim(str(nCelini)),;
				'J'+alltrim(str(nCelini)),'K'+alltrim(str(nCelini)),'L'+alltrim(str(nCelini)),'M'+alltrim(str(nCelini))} )


			If ( nHdl >= 0 )

				// Carrega o Excel e Abre o arquivo
				cBuffer := cFile + Space(512)
				nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)

				If ( nBytes < 0 )
					// Erro critico na abertura do arquivo sem msg de erro
					MsgStop('Nใo foi possivel abrir o arquivo : ' + cFile)
				ElseIf ( nBytes > 0 )
					// Erro critico na abertura do arquivo com msg de erro
					MsgStop(Subs(cBuffer, 1, nBytes))
				EndIf

				// Seleciona a worksheet
				cBuffer := cPasta + Space(512)
				ExeDLLRun2(nHdl, CMD_ACTIVEWORKSHEET, @cBuffer)





				aGrvCabec := {}
				cMensErro := ""
				nLimCab := Val( Substr(Alltrim(cGetNumParc),2 ) )-1

				nI := 1

				//Defini็ใo do Cabe็allho do Contrato
				AaDd( aGrvCabec,{"ZY_FILIAL",xFilial("SZY"),Nil})

				AaDd( aGrvCabec,{"ZY_CODSEQ","",Nil})
				AaDd( aGrvCabec,{"ZY_REVISAO","00",Nil})
				AaDd( aGrvCabec,{"ZY_MODFIIN",cGetModalid,Nil})
				AaDd( aGrvCabec,{"ZY_CODBCO",cGetCodBanc,Nil})
				AaDd( aGrvCabec,{"ZY_BCOAGEN",cGetCodAgen,Nil})
				AaDd( aGrvCabec,{"ZY_BCOCONT",cGetCodCont,Nil})
				AaDd( aGrvCabec,{"ZY_TBFINAN",Left(Alltrim(cGetTbFinan),1),Nil})
				AaDd( aGrvCabec,{"ZY_FORMPGT",Left(Alltrim(cGetFormPag),1),Nil})

				lTemMov := Alltrim(Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_MOVBANC")) == "S"
				If lTemMov
					AaDd( aGrvCabec,{"ZY_DTCRED",dGetDtCredi,Nil})
				EndIf
				AaDd( aGrvCabec,{"ZY_DTDIGIT",DDataBase,Nil})
				AaDd( aGrvCabec,{"ZY_CTADBPR",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTADBPR"),Nil})
				AaDd( aGrvCabec,{"ZY_CTACRPR",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTACRPR"),Nil})
				AaDd( aGrvCabec,{"ZY_CTADBJU",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTADBJU"),Nil})
				AaDd( aGrvCabec,{"ZY_CTACRJU",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTACRJU"),Nil})
				AaDd( aGrvCabec,{"ZY_CTADBOU",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTADBOT"),Nil})
				AaDd( aGrvCabec,{"ZY_CTACROT",Posicione("SZW",1,xFilial("SZW") + cGetModalid,"ZW_CTACROT"),Nil})
				//AaDd( aGrvCabec,{"ZY_STATFIN","0",Nil})

				lContinua := .T.

				Do while lContinua

					If nI <=nLimCab
						If Substr(cGetContrat,1,1) + Alltrim(STR(nI)) == Alltrim(cGetContrat)
							cBuffer := Alltrim(cGetContrat) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cCodContr  :=Subs(cBuffer, 1, nBytes)
							cCodCont2  := IIF(Left(Alltrim(cCodContr),1) $ 'B/C/E/F/L',Substr(Alltrim(cCodContr),2),cCodContr)
							cCodCont3  := IIF(Len(Alltrim(cCodContr)) > 9,Left(cCodContr,9),"")
							cCodCont4  := IIF(At("-",Alltrim(cCodContr)) > 0,Substr(Alltrim(cCodContr),1,At("-",Alltrim(cCodContr)) -1) + Substr(Alltrim(cCodContr),At("-",Alltrim(cCodContr))+1),"")
							AaDd( aGrvCabec,{"ZY_CODCONT",cCodContr,Nil})
							AaDd( aGrvCabec,{"ZY_XCTRIMP","S"		,Nil})
						EndIf
						If "B" + Alltrim(STR(nI)) == Alltrim("B1")
							cBuffer := Alltrim("B1") + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cDescric :=Subs(cBuffer, 1, nBytes)
							AaDd( aGrvCabec,{"ZY_DESCEMP",cDescric,Nil})
						EndIf

						If Substr(cGetVlrTAC,1,1) + Alltrim(STR(nI)) == Alltrim(cGetVlrTAC)
							cBuffer := Alltrim(cGetVlrTAC) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cValorTac :=Subs(cBuffer, 1, nBytes)
							nValorTAC := Val(StrTran(cValorTac,",","."))
							AaDd( aGrvCabec,{"ZY_VLRTAC",nValorTAC,"N"})
						EndIf

						If Substr(cGetQParcel,1,1) + Alltrim(STR(nI)) == Alltrim(cGetQParcel)
							cBuffer := Alltrim(cGetQParcel) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cQtdParcel :=Subs(cBuffer, 1, nBytes)
							nQtdParcel := Val(StrTran(cQtdParcel,",","."))
							AaDd( aGrvCabec,{"ZY_QTDPARC",nQtdParcel,"N"})
						EndIf
						If Substr(cGetVlrCont,1,1) + Alltrim(STR(nI)) == Alltrim(cGetVlrCont)
							cBuffer := Alltrim(cGetVlrCont) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cVlrContr :=Subs(cBuffer, 1, nBytes)
							nVlrContr := Val(StrTran(cVlrContr,",","."))
							nVlrContr := IIF(nVlrContr < 0 ,nVlrContr * -1,nVlrContr)
							AaDd( aGrvCabec,{"ZY_VLRCONT",nVlrContr,"N"})
						EndIf
						If Substr(cGetVrTotFi,1,1) + Alltrim(STR(nI)) == Alltrim(cGetVrTotFi)
							cBuffer := Alltrim(cGetVrTotFi) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cVlrTotFi :=Subs(cBuffer, 1, nBytes)
							nVlrTotFi := Val(StrTran(cVlrTotFi,",","."))
							nVlrTotFi := IIF(nVlrTotFi < 0 ,nVlrTotFi * -1,nVlrTotFi)
							AaDd( aGrvCabec,{"ZY_VRTOTFI",nVlrTotFi,"N"})
						EndIf
						If Substr(cGetVrIofCT,1,1) + Alltrim(STR(nI)) == Alltrim(cGetVrIofCT)
							cBuffer := Alltrim(cGetVrIofCT) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cVlrIofCT :=Subs(cBuffer, 1, nBytes)
							nVlrIofCT := Val(StrTran(cVlrIofCT,",","."))
							AaDd( aGrvCabec,{"ZY_VRIOFCT",nVlrIofCT,"N"})
						EndIf
						If Substr(cGetTxJufMM,1,1) + Alltrim(STR(nI)) == Alltrim(cGetTxJufMM)
							cBuffer := Alltrim(cGetTxJufMM) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cTxJufMM :=Subs(cBuffer, 1, nBytes)
							nTxJufMM := Val(StrTran(cTxJufMM,",","."))
							AaDd( aGrvCabec,{"ZY_TXJURMM",nTxJufMM,"N"})
						EndIf

						If Substr(cGetTxJurAA,1,1) + Alltrim(STR(nI)) == Alltrim(cGetTxJurAA)
							cBuffer := Alltrim(cGetTxJurAA) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cTxJurAA :=Subs(cBuffer, 1, nBytes)
							nTxJurAA := Val(StrTran(cTxJurAA,",","."))
							AaDd( aGrvCabec,{"ZY_TXJURAA",nTxJurAA,"N"})
						EndIf
						If Substr(cGetDiaVenP,1,1) + Alltrim(STR(nI)) == Alltrim(cGetDiaVenP)
							cBuffer := Alltrim(cGetDiaVenP) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cDiaVenP :=Subs(cBuffer, 1, nBytes)
							AaDd( aGrvCabec,{"ZY_DIAVENP",Val(Substr(cDiaVenP,1,2)),Nil})
							AaDd( aGrvCabec,{"ZY_DTCONTR",CTOD(cDiaVenP),"D"})
						EndIf
						If Substr(cGetTCarenc,1,1) + Alltrim(STR(nI)) == Alltrim(cGetTCarenc)
							cBuffer := Alltrim(cGetTCarenc) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cTCarenc :=Subs(cBuffer, 1, nBytes)
							nTCarenc := Val(StrTran(cTCarenc,",","."))
							AaDd( aGrvCabec,{"ZY_TCARENC",nTCarenc,"N"})
						EndIf
					Else
						//Pegar as Parcelas
						IF nI == (nLimCab + 1)
							nQtdContr := 0
							if !Empty(Alltrim(cCodContr))
								cQryCtr := " SELECT LTRIM(RTRIM(ZY_CODCONT)) CONTRATO, COUNT(*) QTDCTR "
								cQryCtr += ENTER + " FROM " + RetSqlName("SZY") + " SZY "
								cQryCtr += ENTER + " WHERE SZY.D_E_L_E_T_ = '' AND SZY.ZY_FILIAL = '" + xFilial("SZY") + "' AND SZY.ZY_CODCONT = '" + Alltrim(cCodContr)+ "' "
								cQryCTR += ENTER + " GROUP BY ZY_CODCONT "
								IF Select("TSCTR") > 0
									TSCTR->(DbCloseArea())
								EndIf
								TCQUERY cQryCTR NEW ALIAS "TSCTR"
								nQtdContr := TSCTR->QTDCTR

								TSCTR->(DbCloseArea())
								IF nQtdContr > 0
									lContinua := .F.
									MsgStop("Contrato n๚mero:" + cCodContr  + " jแ existente na base de dados","Erro importa็ใo")
									Loop
								Endif
							Else
								MsgStop("C๓digo do Contrato Vazio, favor colocar o n๚mero do contrato na planilha a ser importada.","Erro Importa็ใo")
								lContinua := .F.
								Loop
							EndIf
						EndIf
						lErro := .F.
						If nTCarenc > 0 .And. nContPar <= nTCarenc
							nContPar ++
							cNumParc  :=STRZERO(nContPar,3)
						Else
							nContPar ++
							cBuffer := Substr(Alltrim(cGetNumParc),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cNumParc  :=STRZERO(IIF(Val(Alltrim(Subs(cBuffer, 1, nBytes))) > 0 ,Val(Alltrim(Subs(cBuffer, 1, nBytes))) + nTCarenc,0),3)
						EndIf
						If 	Empty(cNumParc) .Or. Alltrim(cNumParc) == "000"
							lContinua := .F.
							Loop
						EndIF
						//Adiciona os dados de vencimento da Parcela
						If nContPar == 1
							If Substr(cGetDtPrPar,1,1) + Alltrim(STR(nI)) == Alltrim(cGetDtPrPar)
								cBuffer := Alltrim(cGetDtPrPar) + Space(1024)
								nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
								cDtPrPar :=Subs(cBuffer, 1, nBytes)
								AaDd( aGrvCabec,{"ZY_DTPRPAR",CTOD(cDtPrPar),"D"})
							EndIf
						EndIf

						If !Empty(Alltrim(cGetParVenc))
							cBuffer := Substr(Alltrim(cGetParVenc),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParVenc  :=Subs(cBuffer, 1, nBytes)
						Else
							If nTCarenc > 0 .And. cNumParc <= STRZERO(nTCarenc,3)
								lErro := .T.
								cMensErro += "Parcela Sem Valor Principal Informado." + ENTER
							EndIf
						EndIf
						If !Empty(Alltrim(cGetParPrin)).And. !lErro
							cBuffer := Substr(Alltrim(cGetParPrin),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParPrin :=Subs(cBuffer, 1, nBytes)
							nParPrin := Val(StrTran(cParPrin,",","."))
							nParPrin := IIF(nParPrin<0,nParPrin *(-1),nParPrin)
						Else
							If nTCarenc > 0 .And. cNumParc <= STRZERO(nTCarenc,3)
								lErro := .T.
								cMensErro += "Parcela Sem Valor Principal Informado."	+ ENTER
							EndIf
						Endif

						If !Empty(Alltrim(cGetParJuro)) .And. !lErro
							cBuffer := Substr(Alltrim(cGetParJuro),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParJuro  :=Subs(cBuffer, 1, nBytes)
							nParJuro := Val(StrTran(cParJuro,",","."))
							nParJuro := IIF(nParJuro<0,nParJuro *(-1),nParJuro)
						Else
							If nTCarenc > 0 .And. cNumParc <= STRZERO(nTCarenc,3)
								lErro := .T.
								cMensErro += "Parcela Sem Juros informado." + ENTER
							EndIf
						EndIf
						cBuffer := Substr(Alltrim(cGetParVJur),1,1)+ALLTRIM(STR(nI)) + Space(1024)
						nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
						cParVJur  :=Subs(cBuffer, 1, nBytes)
						nParVJur := Val(StrTran(cParVJur,",","."))
						nParVJur := IIF(nParVJur<0,nParVJur *(-1),nParVJur)

						cBuffer := Substr(Alltrim(cGetParViof),1,1)+ALLTRIM(STR(nI)) + Space(1024)
						nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
						cParViof  :=Subs(cBuffer, 1, nBytes)
						nParViof := Val(StrTran(cParViof,",","."))
						nParViof := IIF(nParViof<0,nParViof *(-1),nParViof)

						cBuffer := Substr(Alltrim(cGetParSald),1,1)+ALLTRIM(STR(nI)) + Space(1024)
						nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
						cParSald  :=Subs(cBuffer, 1, nBytes)
						nParSald := Val(StrTran(cParSald,",","."))
						nParSald := IIF(nParSald < 0 ,(nParSald*-1),nParSald)
						If !Empty(Alltrim(cGetParApag)) .And. !lErro
							cBuffer := Substr(Alltrim(cGetParApag),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParApag  :=Subs(cBuffer, 1, nBytes)
							nParApag := Val(StrTran(cParApag,",","."))
							nParApag := IIF(nParApag < 0 ,(nParApag*-1),nParApag)
						Else
							If nTCarenc > 0 .And. cNumParc <= STRZERO(nTCarenc,3)
								lErro := .T.
								cMensErro += "Parcela Sem Valor informado." + ENTER
							EndIf
						Endif
						IF !Empty(Alltrim(cGetParDtPg))
							cBuffer := Substr(Alltrim(cGetParDtPg),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParDtPg  :=Subs(cBuffer, 1, nBytes)
							cParDtPg := CtoD(cParDtPg)
						Else
							If Ctod(cParVenc) < dDataBase
								cParDtPg := Ctod(cParVenc)
							Else
								cParDtPg := CTOD("  /  /  ")
							EndIf
						EndIf
						IF !Empty(Alltrim(cGetParVrPG))
							cBuffer := Substr(Alltrim(cGetParVrPG),1,1)+ALLTRIM(STR(nI)) + Space(1024)
							nBytes = ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
							cParVrPG  :=Subs(cBuffer, 1, nBytes)
							nParVrPG := Round(Val(StrTran(cParVrPG,",",".")),2)
							nParVrPG := IIF(nParVrPG < 0 ,nParVrPG*(-1),nParVrPG)
							If Ctod(cParVenc) < dDataBase .And. nParVrPG == 0
								nParVrPG := Round(nParApag,2)
							EndIf
						Else
							If Ctod(cParVenc) < dDataBase
								nParVrPG := Round(nParApag,2)
							Else
								nParVrPG := 0
							EndIf
						EndIf
						IF nParApag > 0
							//Relaciona a Parcela jแ gerado com a percela importada na rotina de Endividamento
							cQryPar := " SELECT "
							cQryPar += ENTER + " E2_PREFIXO,E2_NUM,E2_PARCELA,E2_VALOR,E2_BAIXA,E2_SALDO,R_E_C_N_O_ RECSE2  "
							cQryPar += ENTER + " FROM " + RetSqlName("SE2") + " WHERE D_E_L_E_T_ <> '*' AND E2_FILIAL = '" + xFilial("SE2") + "' "
							cQryPar += ENTER + " AND ( LTRIM(RTRIM(E2_NUM)) = '" + Alltrim(cCodContr) + "' OR  LTRIM(RTRIM(E2_NUM)) = '" + Alltrim(cCodCont2) + "' "
							IF !Empty(Alltrim(cCodCont3))
								cQryPar += ENTER + " OR  LTRIM(RTRIM(E2_NUM)) = '" + Alltrim(cCodCont3) + "' "
							EndIf
							If !Empty(Alltrim(cCodCont4))
								cQryPar += ENTER + " OR  LTRIM(RTRIM(E2_NUM)) = '" + Alltrim(cCodCont4) + "' "
							EndIf
							cQryPar += ENTER + " ) "
							cQryPar += ENTER + " AND (E2_VENCTO BETWEEN '" + DTOS(Ctod(cParVenc) - nDMenosPar) + "' AND '" + DTOS(Ctod(cParVenc) + nDMaisPar) + "' OR E2_PARCELA = '" + Substr(Alltrim(cNumParc),2,2) + "' ) "
							cQryPar += ENTER + " AND E2_PREFIXO IN (" + cPrefixCtr +") "
							cQryPar += ENTER + " AND E2_PARCELA <> '' "
							//cQryPar += ENTER + " AND CAST(E2_VALOR AS INT) =  " + Alltrim(STR(Int(nParApag))) + " "
							If Select("TSE2") > 0
								TSE2->(DbCloseArea())
							EndIf
							TCQUERY cQryPar NEW Alias "TSE2"

							IF TSE2->(!EOF())
								cNumParSe2 := TSE2->E2_PARCELA
								cPrefixSe2 := TSE2->E2_PREFIXO
								nRecnoSe2 := TSE2->RECSE2
							Else
								cNumParSe2 := ""
								cPrefixSe2 := ""
								nRecnoSe2 := 0
							EndIf

							If Select("TSE2") > 0
								TSE2->(DbCloseArea())
							EndIf

							//Detalhamento da Parcela
						Else
							cNumParSe2 := ""
							nRecnoSe2 := 0
						EndIf
						If !lErro
							AaDd(aGrvDados,{cNumParc,Ctod(cParVenc),nParPrin,nParJuro,nParVJur,nParViof,nParSald,nParApag,cParDtPg,nParVrPG,cNumParSe2,nRecnoSe2})
							nQtdOk ++
						Else
							AaDd(aErros,{cCodContr,cNumParc,Ctod(cParVenc),nParPrin,nParJuro,nParVJur,nParViof,nParSald,nParApag,cParDtPg,nParVrPG,cMensErro})
						EndIf

					EndIf
					nImports++
					nI++
				Enddo

				// Fecha o arquivo e remove o excel da memoria
				cBuffer := Space(512)
				ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)

				ExecInDLLClose(nHdl)

				If Len(aGrvDados) > 0 .And. Len(aGrvCabec) > 0
					lPesqNum := .T.
					aAreaSZY := SZY->(GetArea())
					While lPesqNum
						cCodSeqCtr := GETSXENUM("SZY","ZY_CODSEQ")//GetSxeNum("SZY","ZY_CODSEQ")
						DBSelectArea("SZY")
						SZY->(DbSetOrder(1))
						If !SZY->(DbSeek(xFilial("SZY") + cCodSeqCtr ))
							lPesqNum := .F.
							Loop
						Endif
					EndDo
					RestArea(aAreaSZY)
					nPosCodSeq  := aScan(aGrvCabec,{|x| x[1] == "ZY_CODSEQ"})
					aGrvCabec[nPosCodSeq][2] := cCodSeqCtr
					lErroGrava := .F.
					Begin Transaction
						For nP:= 1 to len(aGrvDados)
							IF RecLock("SZN",.T.) .And. !lErroGrava
								SZN->ZN_FILIAL  	:= xFilial("SZN")
								SZN->ZN_CODSEQ  	:= cCodSeqCtr
								SZN->ZN_REVISAO 	:= "00"
								SZN->ZN_CODCONT 	:= cCodContr
								SZN->ZN_NROPAR	 	:= aGrvDados[nP][1]
								SZN->ZN_DTVENC	 	:= aGrvDados[nP][2]
								SZN->ZN_VLRPRIN 	:= aGrvDados[nP][3]
								SZN->ZN_VLRJUR	 	:= aGrvDados[nP][4]
								SZN->ZN_VJURAPG	:= aGrvDados[nP][4]
								SZN->ZN_VJURVAR	:= aGrvDados[nP][5]
								SZN->ZN_VLRIOF 		:= aGrvDados[nP][6]
								SZN->ZN_SLDDEVP		:= aGrvDados[nP][7]
								SZN->ZN_PARAPAG		:= aGrvDados[nP][8]
								SZN->ZN_DTPGPAR  	:= aGrvDados[nP][9]
								SZN->ZN_VRPGPAR  	:= aGrvDados[nP][10]
								SZN->ZN_NPARSE2		:= aGrvDados[nP][11]
								SZN->ZN_STATPAR 	:= IIF(aGrvDados[nP][10] > 0 ,"1","2")
								SZN->(MsUnlock())
								lLibFin := aGrvDados[nP][12] > 0
							Else
								lErroGrava := .T.
								DisarmTransaction()
							EndIf
						Next nP
						If !lErroGrava
							//Grava o Cabe็alho
							IF RecLock("SZY",.T.)
								For nk:=1 To len(aGrvCabec)
									SZY->&(aGrvCabec[nk][1]) := aGrvCabec[nk][2]
								Next nk
								IF lLibFin
									SZY->ZY_STATFIN := "1"
								EndIf
								SZY->(MsUnLock())

								//Ajustar Parcelas Encontradas no SE2
								aSaveSE2 := SE2->(GetArea())
								DbSelectArea("SE2")
								SE2->(DbGoTop())
								For nK:= 1 To len(aGrvDados)
									If aGrvDados[nK][12] > 0
										SE2->(DbGoTo(aGrvDados[nK][12]))
										If Alltrim(SE2->E2_NUM) + Alltrim(SE2->E2_PARCELA) == Alltrim(cCodContr) + Alltrim(aGrvDados[nK][11]) .Or.;
												Alltrim(SE2->E2_NUM) + Alltrim(SE2->E2_PARCELA) == Alltrim(cCodCont2) + Alltrim(aGrvDados[nK][11])
											If RecLock("SE2",.F.)
												SE2->E2_XENDVDG := "S"
												SE2->E2_XJURCTR := aGrvDados[nK][4]
												SE2->E2_XJURVAR := aGrvDados[nK][5]
												SE2->E2_XRFENDV := Alltrim(cCodSeqCtr)
												SE2->(MsUnlock())
											Else
												lErroGrava := .T.
											EndIf
										EndIf
									EndIf
								Next nK
								RestArea(aSaveSE2)
								If !lErroGrava
									DBCommitAll() //ConfirmSx8()
								Else
									DisarmTransaction()
									MsgStop("Erro na Grava็ใo,","Erro")
								EndIf
							Else
								DisarmTransaction()
								MsgStop("Erro na Grava็ใo,","Erro")
							EndIf
						Else
							MsgStop("Erro na Grava็a๕","Erro")
						EndIf
					End Transaction
					If !lErroGrava
						//Criar o Item Contแbil do Contrato
						If Empty(ALLTRIM(SZY->ZY_ITEM))
							aRetItemc := U_GERITEMC()
							lErroGrava := aRetItemc[1]
						EndIf
					EndIf
				EndIf
				If Len(aErros) > 0
					MsgAlert("Ocorreram Erros durante o processamento, favor verificar o log.")
				EndIf
			Else
				MsgStop('Nao foi possivel carregar a DLL')
				EXIT
			EndIf
		NEXT
	Else
		//Erro nas defini็๕es dos arquivos de imoprta็ao
	EndIf


Return Nil


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ FUNCTION RETCHAR              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function RETCHAR(cString)
	Local cChar  	:= ""
	Local cTraco	:= "-"
	Local cPonto	:= "."
	Local nC		:= 0

	For nC := 1 To Len(cString)
		cChar := SubStr(cString, nC, 1)
		If cChar $ cTraco+cPonto

			nY := At(cChar,cTraco)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf

			nY := At(cChar,cPonto)
			If nY > 0
				cString := StrTran(cString,cChar,"")
			EndIf
		EndIf
	Next nC

Return cString



/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFUNวรO RESPONSมVEL POR DEFINIR OS LAYOUTS ณ
//ณDE IMPORTAวรO.                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/
Static Function LayoutCtr(nOpcLayout,lNEWSZ0)
Local aRetLayout := {} 

Default nOpcLayout := 0
Default lNEWSZ0    := .F.
	If lNEWSZ0
		Do Case
		Case  nOpcLayout == 1 //CDC
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetVlrTAC','D7'})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','D5'})
			Aadd(aRetLayout,{'cGetVrIofCT','D6'})
			Aadd(aRetLayout,{'cGetVrTotFi','D5'})
			Aadd(aRetLayout,{'cGetTxJufMM','D3'})
			Aadd(aRetLayout,{'cGetTxJurAA','F3'})	
			Aadd(aRetLayout,{'cGetDiaVenP','F5'})
			Aadd(aRetLayout,{'cGetDtPrPar','B10'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A10'})
			Aadd(aRetLayout,{'cGetParVenc','B10'})
			Aadd(aRetLayout,{'cGetParPrin','C10'})
			Aadd(aRetLayout,{'cGetParJuro','D10'})
			Aadd(aRetLayout,{'cGetParVJur',Space(4)})
			Aadd(aRetLayout,{'cGetParViof',Space(4)})
			Aadd(aRetLayout,{'cGetParSald','E10'})
			Aadd(aRetLayout,{'cGetParApag','F10'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG',Space(4)})
		Case 	nOpcLayout == 2 //Leasing
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetVlrTAC','G7'})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','B8'})
			Aadd(aRetLayout,{'cGetVrIofCT','G4'})
			Aadd(aRetLayout,{'cGetVrTotFi','E8'})
			Aadd(aRetLayout,{'cGetTxJufMM','I6'})
			Aadd(aRetLayout,{'cGetTxJurAA','I6'})	
			Aadd(aRetLayout,{'cGetDiaVenP','G8'})
			Aadd(aRetLayout,{'cGetDtPrPar','B11'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A11'})
			Aadd(aRetLayout,{'cGetParVenc','B11'})
			Aadd(aRetLayout,{'cGetParPrin','C11'})
			Aadd(aRetLayout,{'cGetParJuro','D11'})
			Aadd(aRetLayout,{'cGetParVJur','E11'})
			Aadd(aRetLayout,{'cGetParViof','F11'})
			Aadd(aRetLayout,{'cGetParSald','G11'})
			Aadd(aRetLayout,{'cGetParApag','H11'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG',Space(4)})
	
		Case 	nOpcLayout == 3 //BNDES
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetVlrTAC' ,'D7'})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','D5'})
			Aadd(aRetLayout,{'cGetVrIofCT','D6'})
			Aadd(aRetLayout,{'cGetVrTotFi','D5'})
			Aadd(aRetLayout,{'cGetTxJufMM','D3'})
			Aadd(aRetLayout,{'cGetTxJurAA','F3'})	
			Aadd(aRetLayout,{'cGetDiaVenP','F5'})
			Aadd(aRetLayout,{'cGetDtPrPar','B10'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A10'})
			Aadd(aRetLayout,{'cGetParVenc','B10'})
			Aadd(aRetLayout,{'cGetParPrin','C10'})
			Aadd(aRetLayout,{'cGetParJuro','D10'})
			Aadd(aRetLayout,{'cGetParVJur',Space(4)})
			Aadd(aRetLayout,{'cGetParViof',Space(4)})
			Aadd(aRetLayout,{'cGetParSald','E10'})
			Aadd(aRetLayout,{'cGetParApag','F10'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG','G10'})
	
		Case 	nOpcLayout == 4 //Capital de Giro
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetVlrTAC',SPACE(04)})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','C4'})
			Aadd(aRetLayout,{'cGetVrIofCT','C8'})
			Aadd(aRetLayout,{'cGetVrTotFi','C4'})
			Aadd(aRetLayout,{'cGetTxJufMM','B7'})
			Aadd(aRetLayout,{'cGetTxJurAA','B6'})	
			Aadd(aRetLayout,{'cGetDiaVenP','C5'})
			Aadd(aRetLayout,{'cGetDtPrPar','B11'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A11'})
			Aadd(aRetLayout,{'cGetParVenc','B11'})
			Aadd(aRetLayout,{'cGetParPrin','C11'})
			Aadd(aRetLayout,{'cGetParJuro','D11'})
			Aadd(aRetLayout,{'cGetParVJur',Space(4)})
			Aadd(aRetLayout,{'cGetParViof',Space(4)})
			Aadd(aRetLayout,{'cGetParSald','E11'})
			Aadd(aRetLayout,{'cGetParApag','F11'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG','G11'})
	
		Case 	nOpcLayout == 5 //Finame
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetTCarenc','E4'})
			Aadd(aRetLayout,{'cGetVlrTAC','C7'})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','C4'})
			Aadd(aRetLayout,{'cGetVrIofCT',Space(4)})
			Aadd(aRetLayout,{'cGetVrTotFi','C4'})
			Aadd(aRetLayout,{'cGetTxJufMM','D8'})
			Aadd(aRetLayout,{'cGetTxJurAA','C6'})	
			Aadd(aRetLayout,{'cGetDiaVenP','C5'})
			Aadd(aRetLayout,{'cGetDtPrPar','B10'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A10'})
			Aadd(aRetLayout,{'cGetParVenc','B10'})
			Aadd(aRetLayout,{'cGetParPrin','C10'})
			Aadd(aRetLayout,{'cGetParJuro','D10'})
			Aadd(aRetLayout,{'cGetParVJur',Space(4)})
			Aadd(aRetLayout,{'cGetParViof',Space(4)})
			Aadd(aRetLayout,{'cGetParSald','E10'})
			Aadd(aRetLayout,{'cGetParApag','F10'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG','G10'})
		Case 	nOpcLayout == 6 //FINIMP
			//Aba de Valores do Contrato
			Aadd(aRetLayout,{'cGetContrat','E2'})
			Aadd(aRetLayout,{'cGetVlrTAC' ,'D7'})
			Aadd(aRetLayout,{'cGetQParcel','G2'})                     	
			Aadd(aRetLayout,{'cGetVlrCont','D5'})
			Aadd(aRetLayout,{'cGetVrIofCT','D6'})
			Aadd(aRetLayout,{'cGetVrTotFi','D5'})
			Aadd(aRetLayout,{'cGetTxJufMM','D3'})
			Aadd(aRetLayout,{'cGetTxJurAA','D4'})	
			Aadd(aRetLayout,{'cGetDiaVenP','F5'})
			Aadd(aRetLayout,{'cGetDtPrPar','B10'})
			
			//Detalhamento da Parcela
			Aadd(aRetLayout,{'cGetNumParc','A10'})
			Aadd(aRetLayout,{'cGetParVenc','B10'})
			Aadd(aRetLayout,{'cGetParPrin','H10'})
			Aadd(aRetLayout,{'cGetParJuro','I10'})
			Aadd(aRetLayout,{'cGetParVJur',Space(4)})
			Aadd(aRetLayout,{'cGetParViof',Space(4)})
			Aadd(aRetLayout,{'cGetParSald','E10'})
			Aadd(aRetLayout,{'cGetParApag','J10'})
			Aadd(aRetLayout,{'cGetParDtPg',Space(4)})
			Aadd(aRetLayout,{'cGetParVrPG',Space(4)})
		EndCase
	                            
	Else
		If SZ0->(DbSeek(xFilial("SZ0") + STRZERO(nOpcLayout,3)))
		cDescLay1 := Alltrim(SZ0->Z0_MLAYOUT)   	 	
		cDescrAtu := ""
		cGetCampo := ""
		cGetValor := ""
		nPosPontv := 0
		nPosVirgu := 0 
		lContinua := .T.
		//For nY := 1 To Len(Alltrim(cDescLay1))
			While lContinua
				If Empty(Alltrim(cDescLay1))
			     lContinua := .F.
			     Loop
				Else
				nPosPontv := At(";",cDescLay1)
				nPosVirgu := At(",",cDescLay1)
				cDescrAtu := Substr(cDescLay1,1,nPosPontv)
		    	AaDd(aRetLayout,{Substr(cDescrAtu,1,nPosVirgu - 1),Substr(cDescrAtu,nPosVirgu + 1,Len(cDescrAtu) - (nPosVirgu +1))})
				cDescLay1 := STUFF(cDescLay1, 1, nPosPontv, "")	
				EndIf
			EndDo
		Else
   		aRetLayout := {}   
   		//Aba de Valores do Contrato
		Aadd(aRetLayout,{'cGetContrat',''})
		Aadd(aRetLayout,{'cGetVlrTAC' ,''})
		Aadd(aRetLayout,{'cGetQParcel',''})                     	
		Aadd(aRetLayout,{'cGetVlrCont',''})
		Aadd(aRetLayout,{'cGetVrIofCT',''})
		Aadd(aRetLayout,{'cGetVrTotFi',''})
		Aadd(aRetLayout,{'cGetTxJufMM',''})
		Aadd(aRetLayout,{'cGetTxJurAA',''})	
		Aadd(aRetLayout,{'cGetDiaVenP',''})
		Aadd(aRetLayout,{'cGetDtPrPar',''})
		
		//Detalhamento da Parcela
		Aadd(aRetLayout,{'cGetNumParc',''})
		Aadd(aRetLayout,{'cGetParVenc',''})
		Aadd(aRetLayout,{'cGetParPrin',''})
		Aadd(aRetLayout,{'cGetParJuro',''})
		Aadd(aRetLayout,{'cGetParVJur',''})
		Aadd(aRetLayout,{'cGetParViof',''})
		Aadd(aRetLayout,{'cGetParSald',''})
		Aadd(aRetLayout,{'cGetParApag',''})
		Aadd(aRetLayout,{'cGetParDtPg',''})
		Aadd(aRetLayout,{'cGetParVrPG',''})
		EndIf
	EndIf

Return aRetLayout

/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤUT' ธโ ฟ
//ณFUNวAO RESPONSมVEL POR GRAVAR OS LAYOUT'Sณ
//ณNA TABELA SZ0                 ณ                             
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤUT' ธโ ู
ENDDOC*/
Static Function GrvSZ0Lay(cCodLayout,cDescrLay,aLayoutCTR,cCodModal)
Local lRetSZ0 := .F.    
//Local cMensErro := ""
//Local cDescLay01 := "" 
//Local cDescLay02 := ""
Local MLAYOUTSZ0 := "" 
Local nI := 0

Default aLayoutCTR := {}
Default cCodLayout := ""
Default cDescrLay  := ""              
Default cCodModal := ""
	If Len(aLayoutCTR) > 0
	DbSelectArea("SZ0")
	SZ0->(DbSetOrder(1))
	MLAYOUTSZ0 := CriaVar("Z0_MLAYOUT",.T.)
		For nI:= 1 To Len(aLayoutCTR)
		MLAYOUTSZ0 += aLayoutCTR[nI][1] + "," + aLayoutCTR[nI][2] + ";"
		lMenErro := .F.
		Next nI
	lInclus := .F.
		If !lMenErro
		cCodLayout := STRZERO(VAl(cCodLayout),3)
			If SZ0->(DbSeek(xFilial("SZ0") + cCodLayout))
			Reclock("SZ0",.F.)
			Else
   		 	Reclock("SZ0",.T.)
    		lInclus := .T.
			EndIf
        SZ0->Z0_FILIAL  := xFilial("SZ0")
        SZ0->Z0_CODIGO  := Alltrim(cCodLayout)  
	    SZ0->Z0_DESCRI	:= Alltrim(cDescrLay)
	    SZ0->Z0_MLAYOUT	:= Alltrim(MLAYOUTSZ0)
			If lInclus
	    	SZ0->Z0_DATAINC := DdataBase
	    	SZ0->Z0_USERINC := RetCodUsr()
			EndIf
	    SZ0->Z0_MODALID  := cCodModal
		SZ0->(MsUnLock())
		lRetSZ0 := .T.
		EndIf
	EndIf
Return lRetSZ0

Static Function TrocaCbx(cTpImpCBX,cCampoCbx)
Local lRetCbx := .T.                           
Default cTpImpCBX := ""

	If !Empty(cTpImpCBX) .And. Alltrim(cCampoCbx) == "cGetTpImp"
	cVarCpoMod := Posicione("SZ0",1, xFilial("SZ0") + Left(Alltrim(cGetTpImp),3), "Z0_MODALID")
		If !Empty(Alltrim(cVarCpoMod))
		cGetModal := Alltrim(cVarCpoMod)
		EndIf
	
		If Val(Left(Alltrim(cTpImpCBX),3)) <= 6  //6 Modalidades Pr้-Definidas
		cGetPasta := Alltrim(Substr(cTpImpCBX,5)) + SPACE(10)                                       
		Else
		cGetPasta := PADR("Plan1",20)
		EndIf
		If Val(Left(Alltrim(cTpImpCBX),3)) == Len(aGetTpImp)
		lWhenDesc := .T.                               
		Else
			
		lWhenDesc := .F.                               
		EndIf
	ElseIf Alltrim(cCampoCbx) == "cGetFormPag"
		If Left(Alltrim(cGetFormPag),1) == "2"//Se for Boleto
  		cGetCodBanc	:= Space( TamSx3("ZY_CODBCO")[1])
 		cGetCodAgen	:= Space( TamSx3("ZY_BCOAGEN")[1])
 		cGetCodCont	:= Space( TamSx3("ZY_BCOCONT")[1])
		EndIf
	EndIf
  
Return lRetCbx

Static Function ValidProc(cTpValid)
Local lRetProc := .T.
Default cTpValid := ""
	If cTpValid == "1" //Primeira Tela - Inicial
		If lRetProc .And. Empty(Alltrim(cGetPasta))
		MsgStop("Nome da Aba no Arquivo Excel nใo informada.","Erro Importa็ใo")
		lRetProc := .F.
		EndIf
	
		If lRetProc .And. Empty(Alltrim(cGetModal))
	     MsgStop("Modalidade nใo informada.","Erro Importa็ใo")
	     lRetProc := .F.
		Endif
	
		If lRetProc .And. Empty(Alltrim(cGetDescr)) .And.  Val(Left(Alltrim(cGetTpimp),3)) == Len(aGetTpimp)
		MsgStop("Descri็ใo nใo preenchida para novo Layout.","Erro Importa็ใo")
	 	lRetProc := .F.
		EndIf
	ElseIf cTpValid == "2" //Segunda tela -  Parametros
		If lRetProc .And. Left(Alltrim(cGetFormPag),1) == "1" .And. (Empty(Alltrim(cGetCodBanc)) .Or. Empty(Alltrim(cGetCodAgen))  .Or. Empty(Alltrim(cGetCodCont)))
		MsgStop("Dados Bancแrio nใo informado corretamente","Erro Importa็ใo")
	 	lRetProc := .F.
		EndIf
		If lRetProc .And. Left(Alltrim(cGetFormPag),1) == "1" .And. !SA6->(DbSeek(xFilial("SA6") + Padr(Alltrim(cGetCodBanc),TamSx3("A6_COD")[1]) + ;
		Padr(Alltrim(cGetCodAgen),TamSx3("A6_AGENCIA")[1]) + Padr(Alltrim(cGetCodCont),TamSx3("A6_NUMCON")[1])))
		MsgStop("Banco informado nใo encontrado.","Erro Importa็ใo")
	 	lRetProc := .F.	
			EndIf
	EndIf
Return lRetProc 
