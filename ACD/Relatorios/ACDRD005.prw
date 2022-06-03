#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#include "topconn.ch"

/*/ {Protheus.doc}
@function ACDRD005
@file ACDRD005.PRW
@description Relatorio Pick-list ACD
@tables CB7,CB8,SB1
@author Michael Cecilio.
@since 23/12/2019
@version 1.0
@param
@active true
/*/


user function ACDRD005(lAuto,cOSde,cOSate,cVde,cVate,cProcesso)
	Local aOrdem		:= {"Packing List"}
	Local aDevice		:= {"DISCO","SPOOL","EMAIL","EXCEL","HTML","PDF"}
	Local bParam		:= {|| Pergunte("ACDRD005", .T.)}
	Local cDevice		:= ""
//Local cPathDest	    := GetSrvProfString("StartPath","\system\")
	Local cRelName	    := "ACDRD005"
	Local cSession	    := GetPrinterSession()
	Local lAdjust		:= .F.
	Local nFlags		:= PD_ISTOTVSPRINTER+PD_DISABLEORIENTATION
	Local nLocal		:= 1
	Local nOrdem		:= 1
	Local nOrient		:= 1
	Local nPrintType	:= 6
	Local oPrinter	    := Nil
	Local oSetup		:= Nil
	Local lContinua     := .t.
	LOCAL ODLG
	LOCAL OFNT01
	LOCAL OSAY01
	LOCAL CSAY01		:= "Informe o volume da Ordem de Separacao"
	Local CGET01 		:= SPACE(10)
	LOCAL OBTN
	LOCAL LOK			:= .F.

	Default lAuto       := .f.
	Default cOSde       := ""
	Default cOSate      := ""
	Default cVde        := ""
	Default cVate       := ""
	DEFAULT cProcesso	:= ""

	Private nMaxLin	:= 600
	Private nMaxCol	:= 800
	OFNT01 := TFONT():NEW('CONSOLAS',,-14,.T.,.T.,,,,.T.)

	IF .NOT. lAuto .AND. EMPTY(cProcesso)
		WHILE .T.
			LOK		:= .F.
			ODLG   := MSDIALOG():NEW(001,001,230,300,'Imprime Packing List',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
			OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )

			OGET01 := 	TGET():NEW(	020,005,{|U|IF(PCOUNT()>0,CGET01:=U,CGET01)},ODLG	,060,010,"@R 9999999999"		,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"",'CGET01',,,,.F.,.F.,,'Numero do Volume',2,OFNT01 )


			OBTN   := TBUTTON():NEW(090,010,'OK'		,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
			OBTN   := TBUTTON():NEW(090,100,'Cancelar'	,ODLG,{|| LCANCEL 	:= .T.,ODLG:END()},40,10,,,,.T.)

			ODLG:ACTIVATE(,,,.T.)

			WHILE !LOK .AND. !LCANCEL

			ENDDO
			IF LOK

				MV_PAR01:= ""
				MV_PAR02:= "ZZZZZZ"
				MV_PAR03:= CGET01
				MV_PAR04:= CGET01
				lAuto 	:= .T.
				lContinua := .T.
/*************************************/
				ValidPerg("ACDRD005")

				cSession	:= GetPrinterSession()
				cDevice	    := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
				nOrient	    := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
				nLocal		:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
				nPrintType	:= aScan(aDevice,{|x| x == cDevice })

				oPrinter	:= FWMSPrinter():New(cRelName, nPrintType, lAdjust, /*cPathDest*/, .T.)
				oSetup		:= FWPrintSetup():New (nFlags,cRelName)

				oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
				oSetup:SetPropert(PD_ORIENTATION , nOrient)
				oSetup:SetPropert(PD_DESTINATION , nLocal)
				oSetup:SetPropert(PD_MARGIN      , {0,0,0,0})
				oSetup:SetOrderParms(aOrdem,@nOrdem)
				oSetup:SetUserParms(bParam)

				fwWriteProfString(cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
				fwWriteProfString(cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
				fwWriteProfString(cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

				oPrinter:lServer	     := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
				oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
				oPrinter:SetLandscape()
				oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
				oPrinter:setCopies(Val(oSetup:cQtdCopia))

				If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
					oPrinter:nDevice		:= IMP_SPOOL
					fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
					oPrinter:cPrinter		:= oSetup:aOptions[PD_VALUETYPE]
				Else
					oPrinter:nDevice		:= IMP_PDF
					oPrinter:cPathPDF		:= oSetup:aOptions[PD_VALUETYPE]
					oPrinter:SetViewPDF(.T.)
				Endif

				Pergunte("ACDRD005",.F.)
				MV_PAR01:= ""
				MV_PAR02:= "ZZZZZZ"
				MV_PAR03:= CGET01
				MV_PAR04:= CGET01
				RptStatus({|lEnd| U_ACDRD5Im(@lEnd,@oPrinter,lAuto,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)},"Imprimindo Relatorio...")

				oSetup		:= Nil
				oPrinter	:= Nil
/*************************************/
			ELSE
				EXIT
			ENDIF
		END
	ELSE

		ValidPerg("ACDRD005")

		cSession	:= GetPrinterSession()
		cDevice	    := If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
		nOrient	    := If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
		nLocal		:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
		nPrintType	:= aScan(aDevice,{|x| x == cDevice })

		oPrinter	:= FWMSPrinter():New(cRelName, nPrintType, lAdjust, /*cPathDest*/, .T.)
		oSetup		:= FWPrintSetup():New (nFlags,cRelName)

		oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
		oSetup:SetPropert(PD_ORIENTATION , nOrient)
		oSetup:SetPropert(PD_DESTINATION , nLocal)
		oSetup:SetPropert(PD_MARGIN      , {0,0,0,0})
		oSetup:SetOrderParms(aOrdem,@nOrdem)
		oSetup:SetUserParms(bParam)

		if ! lAuto
			lContinua := oSetup:Activate() == PD_OK
		endif

		If lContinua
			fwWriteProfString(cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
			fwWriteProfString(cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
			fwWriteProfString(cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )

			oPrinter:lServer	     := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
			oPrinter:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
			oPrinter:SetLandscape()
			oPrinter:SetPaperSize(oSetup:GetProperty(PD_PAPERSIZE))
			oPrinter:setCopies(Val(oSetup:cQtdCopia))

			If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
				oPrinter:nDevice		:= IMP_SPOOL
				fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
				oPrinter:cPrinter		:= oSetup:aOptions[PD_VALUETYPE]
			Else
				oPrinter:nDevice		:= IMP_PDF
				oPrinter:cPathPDF		:= oSetup:aOptions[PD_VALUETYPE]
				oPrinter:SetViewPDF(.T.)
			Endif

			if lAuto
				U_ACDRD5Im(@lEnd,@oPrinter,lAuto,cOSde,cOSate,cVde,cVate)
			ELSE

				Pergunte("ACDRD005",.F.)
				RptStatus({|lEnd| U_ACDRD5Im(@lEnd,@oPrinter,lAuto,MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04)},"Imprimindo Relatorio...")
			endif

		Else
			MsgInfo("Relatório cancelado pelo usuário.")
			oPrinter:Cancel()
		EndIf

		oSetup		:= Nil
		oPrinter	:= Nil
	ENDIF
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ACDRD5Im  ³ Autor ³ Michael Cecilio      ³ Data ³23/12/2019  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o corpo do relatorio                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDRD5Im                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER Function ACDRD5Im(lEnd,oPrinter,lAuto,cSepDe,cSepAte,cVolDe,cVolAte)

Local nMaxLinha	:= 40
Local nLinCount	:= 0
Local aArea		:= GetArea()
Local cQry			:= ""
Local cOrdSep		:= ""
Local cVolume       := ""
//Local cArmEnder		:= ""
Private cAliasOS	:= GetNextAlias()
Private oFontA7	    := TFont():New('Arial',,7,.T.)
Private oFontA12	:= TFont():New('Arial',,12,.T.)
Private oFontA16	:= TFont():New('Arial',,16,.T.)

Private nMargDir	:= 15
Private nMargEsq	:= 20
Private nColAmz	    := nMargEsq+80		
Private nColSLt	    := nColAmz+280		

Private oFontC8	:= TFont():New('Arial',,11,.T.)
Private li		:= 10
Private nLiItm	:= 0
Private nPag		:= 0
Private NTOTPALLET	:= 0
Private NTOTCAIXAS	:= 0

    cQry := "SELECT CB9_ORDSEP,CB9_VOLUME,CB7_ORIGEM,CB7_STATUS,CB7_PEDIDO,CB7_OP,CB7_NOTA,CB7_SERIE,CB9_PROD,B1_DESC, "
    cQry += "   CB7_CLIENT,CB7_LOJA,CB7_CLIORI,CB7_LOJORI,ISNULL(SUM(CB9.CB9_QTESEP),0) AS QTDSEP "
	cQry += "FROM "+RetSqlName("CB9")+" CB9 "
	cQry += "INNER JOIN "+RetSqlName("SB1")+" SB1  WITH(NOLOCK) "
	cQry += "       ON SB1.B1_COD=CB9.CB9_PROD "
	cQry += "	   AND B1_FILIAL ='"+XFILIAL("SB1")+"' "
	cQry += "	   AND SB1.D_E_L_E_T_ ='' "
	cQry += "INNER JOIN "+RetSqlName("CB7")+" CB7  WITH(NOLOCK) "
	cQry += "      ON  CB7.CB7_ORDSEP = CB9.CB9_ORDSEP "
	cQry += "	  AND CB7.CB7_FILIAL= CB9.CB9_FILIAL "
	cQry += "	  AND CB7.D_E_L_E_T_ ='' "
	cQry += "WHERE CB9.D_E_L_E_T_ ='' "
	cQry += "AND CB9_FILIAL   ='"+XFILIAL("CB9")+"' "
	cQry += "AND CB9_ORDSEP  BETWEEN '"+cSepDe+"' AND '"+cSepAte+"' "
	cQry += "AND CB9_VOLUME  BETWEEN '"+cVolDe+"' AND '"+cVolAte+"' "
	cQry += "GROUP BY CB9_ORDSEP,CB9_VOLUME,CB7_ORIGEM,CB7_STATUS,CB7_PEDIDO,CB7_OP,CB7_NOTA,CB7_SERIE,CB9_PROD,B1_DESC,CB7_CLIENT,CB7_LOJA,CB7_CLIORI,CB7_LOJORI "
	cQry += "ORDER BY CB9_ORDSEP,CB9_VOLUME,CB7_ORIGEM,CB7_STATUS,CB7_PEDIDO,CB7_OP,CB7_NOTA,CB7_SERIE,CB9_PROD,B1_DESC,CB7_CLIENT,CB7_LOJA,CB7_CLIORI,CB7_LOJORI "
	                
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasOS,.f.,.f.)
	
	if !lAuto
		SetRegua((cAliasOS)->(LastRec()))
	endif
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia a impressao do relatorio ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAliasOS)->(Eof())
		if  !lAuto
	  IncRegua()
		endif
	nLiItm		:= 110
	nLinCount	:= 0
	nPag++
	oPrinter:StartPage()
	U_ACD05Pag(@oPrinter)
	U_ACD05Ite(@oPrinter,(cAliasOS)->CB7_ORIGEM,(cAliasOS)->CB9_VOLUME)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os titulos das colunas dos itens ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oPrinter:SayAlign(li+100,nMargDir,"Produto",oFontC8,200,200,,0) 
	oPrinter:SayAlign(li+100,nColAmz ,"Descrição do Produto",oFontC8,200,200,,0)
	oPrinter:SayAlign(li+100,nColSLt ,"Qtd. Conferida",oFontC8,200,200,,0)
	
	
	cOrdSep := (cAliasOS)->CB9_ORDSEP
	cVolume := (cAliasOS)->CB9_VOLUME

			
		While !(cAliasOS)->(Eof()) .and. (cAliasOS)->CB9_VOLUME == cVolume  //(cAliasOS)->CB8_ORDSEP == cOrdSep
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia uma nova pagina caso nao estiver em EOF ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLinCount == nMaxLinha
			oPrinter:StartPage()
			nPag++
			U_ACD05Pag(@oPrinter)
			U_ACD05Ite(@oPrinter,(cAliasOS)->CB7_ORIGEM,(cAliasOS)->CB9_VOLUME)
			nLiItm		:= li + 100
			nLinCount	:= 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os titulos das colunas dos itens ³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			oPrinter:SayAlign(nLiItm,nMargDir,"Produto",oFontC8,200,200,,0) //"Produto"
			oPrinter:SayAlign(nLiItm,nColAmz ,"Descrição do Produto",oFontC8,200,200,,0)
			oPrinter:SayAlign(nLiItm,nColSLt ,"Qtd. Conferida",oFontC8,200,200,,0)
			
			EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime os itens da ordem de separacao ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oPrinter:SayAlign(li+nLiItm,nMargDir,(cAliasOS)->CB9_PROD,oFontC8,200,200,,0)
		oPrinter:SayAlign(li+nLiItm,nColAmz,Transform((cAliasOS)->B1_DESC,PesqPict("SB1","B1_DESC"))   ,oFontC8,200,200,,0)
		oPrinter:SayAlign(li+nLiItm,nColSLt,Transform((cAliasOS)->QTDSEP ,PesqPict("CB9","CB9_QTESEP")),oFontC8,200,200,,0)
		
		nLinCount++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime linha para separar itens 		³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrinter:Line(li+nLiItm,nMargDir, li+nLiItm, nMaxCol-nMargEsq,, "-2")
		nLinCount++

			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza a pagina quando atingir a quantidade maxima de itens ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
			If nLinCount == nMaxLinha
			oPrinter:Line(550,nMargDir, 550, nMaxCol-nMargEsq,, "-2")
			oPrinter:EndPage()
			Else
			nLiItm += li
			EndIf
		
		(cAliasOS)->(dbSkip())
		EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a pagina se a quantidade de itens for diferente da quantidade ³ 
	//³ maxima, para evitar que a pagina seja finalizada mais de uma vez.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLinCount <> nMaxLinha
		oPrinter:Line(550,nMargDir, 550, nMaxCol-nMargEsq,, "-2")
		oPrinter:EndPage()
		EndIf
	EndDo

oPrinter:Print()

(cAliasOS)->(dbCloseArea())
RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | CabPagina  ³ Autor ³ Robson Sales          ³ Data ³14/11/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do relatorio                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDR100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function ACD05Pag(oPrinter)

Private nCol1Dir	:= 720-nMargDir   
Private nCol2Dir	:= 760-nMargDir

oPrinter:Line(li+5, nMargDir, li+5, nMaxCol-nMargEsq,, "-8")

oPrinter:SayAlign(li+10,nMargDir,"SIGA/ACDRD005/v12",oFontA7,200,200,,0)
oPrinter:SayAlign(li+20,nMargDir,"Hora: "+Time(),oFontA7,200,200,,0)
oPrinter:SayAlign(li+30,nMargDir,"Empresa: "+FWFilialName(,,2) ,oFontA7,300,200,,0)

oPrinter:SayAlign(li+20,340,"Packing List",oFontA12,nMaxCol-nMargEsq,200,2,0)

oPrinter:SayAlign(li+10,nCol1Dir,"Folha   : ",oFontA7,200,200,,0)
oPrinter:SayAlign(li+20,nCol1Dir,"Dt. Ref.: ",oFontA7,200,200,,0)
oPrinter:SayAlign(li+30,nCol1Dir,"Emissão : ",oFontA7,200,200,,0)

oPrinter:SayAlign(li+10,nCol2Dir,AllTrim(STR(nPag)),oFontA7,200,200,,0)
oPrinter:SayAlign(li+20,nCol2Dir,DTOC(ddatabase),oFontA7,200,200,,0)
oPrinter:SayAlign(li+30,nCol2Dir,DTOC(ddatabase),oFontA7,200,200,,0)

oPrinter:Line(li+40,nMargDir, li+40, nMaxCol-nMargEsq,, "-8")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | CabItem    ³ Autor ³ Robson Sales          ³ Data ³18/11/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o cabecalho do relatorio                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDR100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ACD05Ite(oPrinter,cOrigem,cVolume)

Local cOrdSep		:= AllTrim((cAliasOS)->CB9_ORDSEP)
Local cPedVen		:= POSICIONE("SC5", 1, xFilial("SC5") + (cAliasOS)->CB7_PEDIDO, "C5_NUMOLD")//AllTrim((cAliasOS)->CB7_PEDIDO) //PEGAR C5_NUMOLD 
Local cClient		:= ""
Local cNFiscal	    := AllTrim((cAliasOS)->CB7_NOTA)+"-"+AllTrim((cAliasOS)->&(SerieNfId('CB7',3,'CB7_SERIE')))
Local cOP			:= AllTrim((cAliasOS)->CB7_OP)
//Local cStatus		:= RetStatus((cAliasOS)->CB7_STATUS)
Local cNmClient	    := ""

	if empty((cAliasOS)->CB7_CLIORI)
   cClient   := AllTrim((cAliasOS)->CB7_CLIENT)+"-"+AllTrim((cAliasOS)->CB7_LOJA)
   cNmClient := POSICIONE("SA1", 1, xFilial("SA1") + (cAliasOS)->CB7_CLIENT + (cAliasOS)->CB7_LOJA , "A1_NOME")
	else
   cClient   := AllTrim((cAliasOS)->CB7_CLIORI)+"-"+AllTrim((cAliasOS)->CB7_LOJORI)
   cNmClient := POSICIONE("SA1", 1, xFilial("SA1") + (cAliasOS)->CB7_CLIORI + (cAliasOS)->CB7_LOJORI , "A1_NOME")
	endif

		
oPrinter:SayAlign(li+60,nMargDir,"Ordem de Separação:",oFontC8,200,200,,0)//"Ordem de Separação:"
oPrinter:SayAlign(li+60,nMargDir+105,cOrdSep,oFontC8,200,200,,0)

oPrinter:SayAlign(li+60,nMargDir+310,"Volume de conferencia:",oFontC8,200,200,,0)//"Cliente:"
oPrinter:SayAlign(li+60,nMargDir+410,cVolume,oFontC8,200,200,,0)

	If Alltrim(cOrigem) == "1" // Pedido venda
	oPrinter:SayAlign(li+70,nMargDir,"Pedido Portal:",oFontC8,200,200,,0)//"Pedido de Venda:"
		If Empty(cPedVen) .And. (cAliasOS)->CB7_STATUS <> "9"
		oPrinter:SayAlign(li+70,nMargDir+105,"Aglutinado",oFontC8,200,200,,0)//"Aglutinado"
		oPrinter:SayAlign(li+82,nMargDir,"PV's Aglutinados:",oFontC8,200,200,,0)//"PV's Aglutinados:"
		oPrinter:SayAlign(li+82,nMargDir+105,A100AglPd(cOrdSep),oFontC8,550,200,,0)		
		Else
		oPrinter:SayAlign(li+70,nMargDir+105,cPedVen,oFontC8,200,200,,0)
		EndIf
	ElseIf Alltrim(cOrigem) == "2" // Nota Fiscal
	oPrinter:SayAlign(li+70,nMargDir,"Nota Fiscal:",oFontC8,200,200,,0)//"Nota Fiscal:"
	oPrinter:SayAlign(li+70,nMargDir+105,cNFiscal,oFontC8,200,200,,0)
	ElseIf Alltrim(cOrigem) == "3" // Ordem de Producao
	oPrinter:SayAlign(li+70,nMargDir,"Ordem de Produção:",oFontC8,200,200,,0)
	oPrinter:SayAlign(li+70,nMargDir+105,cOP,oFontC8,200,200,,0)
	EndIf

//oPrinter:SayAlign(li+60,nMargDir+430,"Status:",oFontC8,200,200,,0)
//oPrinter:SayAlign(li+60,nMargDir+470,cStatus,oFontC8,200,200,,0)

oPrinter:SayAlign(li+70,nMargDir+310,"Nome Cliente: ",oFontC8,200,200,,0)//"Cliente:"
oPrinter:SayAlign(li+70,nMargDir+410,cNmClient,oFontC8,200,200,,0)

oPrinter:Line(li+90,nMargDir, li+90, nMaxCol-nMargEsq,, "-2")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | RetStatus  ³ Autor ³ Robson Sales          ³ Data ³18/11/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna o Status da Ordem de Separacao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDR100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
/*
Static Function RetStatus(cStatus)

Local cDescri	:= ""

	If Empty(cStatus) .or. cStatus == "0"
	cDescri:= "Nao iniciado"
	ElseIf cStatus == "1"
	cDescri:= "Em separacao"
	ElseIf cStatus == "2"
	cDescri:= "Separacao finalizada"
	ElseIf cStatus == "3"
	cDescri:= "Em processo de embalagem"
	ElseIf cStatus == "4"
	cDescri:= "Embalagem Finalizada"
	ElseIf cStatus == "5"
	cDescri:= "Nota gerada"
	ElseIf cStatus == "6"
	cDescri:= "Nota impressa"
	ElseIf cStatus == "7"
	cDescri:= "Volume impresso"
	ElseIf cStatus == "8"
	cDescri:= "Em processo de embarque"
	ElseIf cStatus == "9"
	cDescri:= "Finalizado"
	EndIf

Return(cDescri)
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | A100AglPd  ³ Autor ³ Materiais             ³ Data ³ 08/07/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna String com os Pedidos de Venda aglutinados na OS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDR100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A100AglPd(cOrdSep)

Local cAliasPV	:= GetNextAlias()
Local cQuery		:= ""
Local cPedidos	:= ""
Local aArea		:= GetArea()

cQuery := "SELECT C9_PEDIDO FROM "+RetSqlName("SC9")+" WHERE C9_ORDSEP = '"+cOrdSep+"' AND "
cQuery += "C9_FILIAL = '"+xFilial("SC9")+"' AND D_E_L_E_T_ = '' ORDER BY C9_PEDIDO"

cQuery := ChangeQuery(cQuery)                  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPV,.T.,.T.)

	While !(cAliasPV)->(EOF())
	cPedidos += (cAliasPV)->C9_PEDIDO+"/"
	(cAliasPV)->(dbSkip())
	EndDo

(cAliasPV)->(dbCloseArea())
RestArea(aArea)

	If Len(cPedidos) > 119
	cPedidos := SubStr(cPedidos,1,119)+"..."
	EndIf

Return cPedidos

Static Function ValidPerg(cPerg)

Local _aArea := GetArea()
Local _aPerg := {}
Local i := 0

cPerg   := PADR(cPerg,len(sx1->x1_grupo))

Aadd(_aPerg, {cPerg, "01", "Ordem Separacao DE" , "MV_CH1" , 	"C", 06	, 0	, "G"	, "MV_PAR01", "CB7"	,""					,""			,"",""})
Aadd(_aPerg, {cPerg, "02", "Ordem Separacao ATE", "MV_CH2" , 	"C", 06	, 0	, "G"	, "MV_PAR02", "CB7"	,""					,""			,"",""})
Aadd(_aPerg, {cPerg, "03", "Volume DE"          , "MV_CH3" , 	"C", 10	, 0	, "G"	, "MV_PAR03", ""	,""					,""			,"",""})
Aadd(_aPerg, {cPerg, "04", "Volume ATE     ?"   , "MV_CH4" , 	"C", 10	, 0	, "G"	, "MV_PAR04", ""	,""					,""			,"",""})

DbSelectArea("SX1")
DbSetOrder(1)

	For i := 1 To Len(_aPerg)
		IF  !DbSeek(_aPerg[i,1]+_aPerg[i,2])
		RecLock("SX1",.T.)
		Replace X1_GRUPO   with _aPerg[i,01]
		Replace X1_ORDEM   with _aPerg[i,02]
		Replace X1_PERGUNT with _aPerg[i,03]
		Replace X1_VARIAVL with _aPerg[i,04]
		Replace X1_TIPO	   with _aPerg[i,05]
		Replace X1_TAMANHO with _aPerg[i,06]
		Replace X1_PRESEL  with _aPerg[i,07]
		Replace X1_GSC	   with _aPerg[i,08]
		Replace X1_VAR01   with _aPerg[i,09]
		Replace X1_F3	   with _aPerg[i,10]
		Replace X1_DEF01   with _aPerg[i,11]
		Replace X1_DEF02   with _aPerg[i,12]
		Replace X1_DEF03   with _aPerg[i,13]
		Replace X1_DEF04   with _aPerg[i,14]
		MsUnlock()
		EndIF
	Next i
RestArea(_aArea)
Return(.T.)

User function Teste001()
 u_ACDRD005(.t.,"211953","211953","0000214958","0000214958")
return
