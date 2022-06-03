#include "ACDR100.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"
#include "topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACDR100  ³ Autor ³ Robson Sales   		³ Data ³ 14/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Ordens de Separacao                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ACDR100TF()
Local aOrdem		:= {STR0001}//"Ordem de Separação"
Local aDevice		:= {"DISCO","SPOOL","EMAIL","EXCEL","HTML","PDF"}
Local bParam		:= {|| Pergunte("ACD100", .T.)}
Local cDevice		:= ""
//Local cPathDest	:= GetSrvProfString("StartPath","\system\")
Local cRelName	:= STR0002//"ACDR100"
Local cSession	:= GetPrinterSession()
Local lAdjust		:= .F.
Local nFlags		:= PD_ISTOTVSPRINTER+PD_DISABLEORIENTATION
Local nLocal		:= 1
Local nOrdem		:= 1
Local nOrient		:= 1
Local nPrintType	:= 6
Local oPrinter	:= Nil
Local oSetup		:= Nil
Private nMaxLin	:= 600
Private nMaxCol	:= 800
PRIVATE LPRJENDER 	:= GetMV("TF_PRJENDR",.F.,.F.)


cSession	:= GetPrinterSession()
cDevice	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nOrient	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
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

If oSetup:Activate() == PD_OK 
	fwWriteProfString(cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )	
	fwWriteProfString(cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )	
	fwWriteProfString(cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
		
	oPrinter:lServer			:= oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER	
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
	
	RptStatus({|lEnd| U_TFACD100Imp(@lEnd,@oPrinter)},STR0003)//"Imprimindo Relatorio..."
Else 
	MsgInfo(STR0004) //"Relatório cancelado pelo usuário."
	oPrinter:Cancel()
EndIf

oSetup		:= Nil
oPrinter	:= Nil

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | ACD100Imp  ³ Autor ³ Robson Sales          ³ Data ³14/11/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o corpo do relatorio                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ ACDR100                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function TFACD100Imp(lEnd,oPrinter)

Local nMaxLinha	:= 40
Local nLinCount	:= 0
Local aArea		:= GetArea()
Local cQry			:= ""
Local cOrdSep		:= ""
Local cArmEnder		:= ""
Local nLoop		:= 0
Local nSubCol	:= 0
Local nSubRow	:= 0
Local aResult 	:= {}
LOCAL nStatus	:= 0

Private cAliasOS	:= GetNextAlias()
//Private nMargDir	:= 15
//Private nMargEsq	:= 20
//Private nColAmz	:= nMargEsq+155
//Private nColEnd	:= nColAmz+45
//Private nColLot	:= nColEnd+85
//Private nColSLt	:= nColLot+85
//Private nSerie	:= nColSLt+40
//Private nQtOri	:= nSerie+110
//Private nQtSep	:= nQtOri+85
//Private nQtEmb	:= nQtSep+85
Private oFontA7	:= TFont():New('Arial',,7,.T.)
Private oFontA12	:= TFont():New('Arial',,12,.T.)
Private oFontA16	:= TFont():New('Arial',,16,.T.)

Private nMargDir	:= 15
Private nMargEsq	:= 20
Private nColAmz	:= nMargEsq+40		// pallet
Private nColSLt	:= nColAmz+45		// caixa c/6 //nao imprime mais apenas 2 para dar de espaço

Private nSerie := 0

Private nQtOri	:= nSerie+45		// original
Private nQtSep	:= nQtOri+45		// a separar
Private nQtEmb	:= nQtSep+47		// descricao produto
Private nColDes	:= nQtEmb+215		// transportadora
Private nColEnd	:= nColDes+100		// armazem
Private nColLot	:= nColEnd+45		// endereço
Private oFontC8	:= TFont():New('Arial',,11,.T.)
Private li		:= 10
Private nLiItm	:= 0
Private nPag		:= 0
Private NTOTPALLET	:= 0
Private NTOTCAIXAS	:= 0
Private ALOCALIZ   	:= {}

Pergunte("ACD100",.F.)


//	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//	//³ Monta o arquivo temporario ³ 
//	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	cQry := "SELECT CB7_ORDSEP,CB7_PEDIDO,CB7_CLIENT,CB7_LOJA,CB7_NOTA,"+SerieNfId('CB7',3,'CB7_SERIE')+",CB7_OP,CB7_STATUS,CB7_ORIGEM, "
//	cQry += "CB8_PROD,CB8_ORDSEP,CB8_LOCAL,CB8_LCALIZ,CB8_LOTECT,CB8_NUMLOT,CB8_NUMSER,CB8_QTDORI,CB8_SALDOS,CB8_SALDOE"
//	cQry += " FROM "+RetSqlName("CB7")+","+RetSqlName("CB8")
//	cQry += " WHERE CB7_FILIAL = '"+xFilial("CB7")+"' AND"
//	cQry += " CB7_ORDSEP >= '"+MV_PAR01+"' AND"
//	cQry += " CB7_ORDSEP <= '"+MV_PAR02+"' AND"
//	cQry += " CB7_DTEMIS >= '"+DTOS(MV_PAR03)+"' AND"
//	cQry += " CB7_DTEMIS <= '"+DTOS(MV_PAR04)+"' AND"
//	cQry += " CB8_FILIAL = CB7_FILIAL AND"
//	cQry += " CB8_ORDSEP = CB7_ORDSEP AND"
//	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//	//³ Nao Considera as Ordens ja finalizadas ³ 
//	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If MV_PAR05 == 2
//		cQry += " CB7_STATUS <> '9' AND"
//	EndIf
//	cQry += " "+RetSqlName("CB8")+".D_E_L_E_T_ = '' AND"
//	cQry += " "+RetSqlName("CB7")+".D_E_L_E_T_ = ''"
//	cQry += " ORDER BY CB7_ORDSEP,CB8_PROD"
//	cQry := ChangeQuery(cQry)                  
//	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasOS,.T.,.T.)

/*
	COMANDO N?O RECONHECIDO EM RELEASE 12.1.27

	cQry := "EXEC SP_REL_MAT_NUMERO_DA_OS '" + MV_PAR01 + "' , '" + MV_PAR02 + "' , '" + CEMPANT + "' ,'" + CFILANT + "', " + ALLTRIM(STR(MV_PAR05))
	If Select((cAliasOS)) > 0
		dbSelectArea((cAliasOS))
		(cAliasOS)->(DbCloseArea())
	EndIf
	TCQUERY cQry NEW ALIAS (cAliasOS)
*/
aResult := {}
If TCSPExist("SP_REL_MAT_NUMERO_DA_OS")	
	aResult := TCSPEXEC("SP_REL_MAT_NUMERO_DA_OS", MV_PAR01 , MV_PAR02 , CEMPANT , CFILANT , MV_PAR05, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2))
endif
IF empty(aResult)
	Conout('Erro na execução da Stored Procedure : '+TcSqlError())
else

	cQry := "SELECT * FROM " + aResult[1]

	TCQUERY cQry NEW ALIAS (cAliasOS)

	SetRegua((cAliasOS)->(LastRec()))

	_fTAIFF := .F.
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a impressao do relatorio ³ 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !(cAliasOS)->(Eof())
		IncRegua()
		nLiItm		:= 110
		nLinCount	:= 0
		nPag++
		oPrinter:StartPage()
		U_TFCabPagina(@oPrinter)
		U_TFCabItem(@oPrinter,(cAliasOS)->CB7_ORIGEM)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime os titulos das colunas dos itens ³ 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if  alltrim((cAliasOS)->B1_ITEMCC) == "TAIFF"
			nSerie	:= nColSLt+50		// unitar
			IF .NOT. LPRJENDER
				_fTaiff := .T. 	// Linha deixará de ser usada para o projeto de endereços TAIFF uma vez que será o usado o mesmo conceito 
								// da PROART onde será impresso somente o endereço diferente do endereço padrão (B1_YENDEST)
			ENDIF
		else
			nSerie	:= nColSLt+2		// unitar
		endif


		oPrinter:SayAlign(li+100,nMargDir,"Produto",oFontC8,200,200,,0) //"produto"
		oPrinter:SayAlign(li+100,nColAmz,"Qt.Original",oFontC8,200,200,,0)
		if  alltrim((cAliasOS)->B1_ITEMCC) == "TAIFF"
			oPrinter:SayAlign(li+100,nColSLt,"Qt.Pallet",oFontC8,200,200,,0)
			oPrinter:SayAlign(li+100,nSerie,"Qt.Caixa c/6",oFontC8,200,200,,0)
		Elseif  alltrim((cAliasOS)->B1_ITEMCC) == "PROART"
			oPrinter:SayAlign(li+100,nColSLt,"Qt.Fechada",oFontC8,200,200,,0)
		endif
		oPrinter:SayAlign(li+100,nQtOri+nSerie,"Qt.Unitar",oFontC8,200,200,,0)
		oPrinter:SayAlign(li+100,nQtSep+nSerie,"A Separar",oFontC8,200,200,,0)
		oPrinter:SayAlign(li+100,nQtEmb+nSerie,"Descricao Produto",oFontC8,200,200,,0)
		oPrinter:SayAlign(li+100,nColDes+nSerie,"Transportadora",oFontC8,200,200,,0)
		oPrinter:SayAlign(li+100,nColEnd+nSerie,"Armazem",oFontC8,200,200,,0) //"armazem"	
		oPrinter:SayAlign(li+100,nColLot+nSerie,"Endereco",oFontC8,200,200,,0) //"endereço"
		oPrinter:Line(li+110,nMargDir, li+110, nMaxCol-nMargEsq,, "-2")
		
		cOrdSep := (cAliasOS)->CB7_ORDSEP
		NTOTPALLET := 0
		NTOTCAIXAS	:= 0
		ALOCALIZ   	:= {}
				
		While !(cAliasOS)->(Eof()) .and. (cAliasOS)->CB8_ORDSEP == cOrdSep
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicia uma nova pagina caso nao estiver em EOF ³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if  alltrim((cAliasOS)->B1_ITEMCC) == "TAIFF"
				nSerie	:= nColSLt+50		// unitar
			else
				nSerie	:= nColSLt+2		// unitar
			endif

			If nLinCount == nMaxLinha
				oPrinter:StartPage()
				nPag++
				U_TFCabPagina(@oPrinter)
				U_TFCabItem(@oPrinter,(cAliasOS)->CB7_ORIGEM)
				nLiItm		:= li + 100
				nLinCount	:= 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Imprime os titulos das colunas dos itens ³ 
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			

				oPrinter:SayAlign(nLiItm,nMargDir,"Produto",oFontC8,200,200,,0) //"Produto"
				oPrinter:SayAlign(nLiItm,nColAmz,"Qt.Original",oFontC8,200,200,,0)
				if  alltrim((cAliasOS)->B1_ITEMCC) == "TAIFF"
					oPrinter:SayAlign(nLiItm,nColSLt,"Qt.Pallet",oFontC8,200,200,,0)
					oPrinter:SayAlign(nLiItm,nSerie,"Qt.Caixa c/6",oFontC8,200,200,,0)
				Elseif  alltrim((cAliasOS)->B1_ITEMCC) == "PROART"
					oPrinter:SayAlign(nLiItm,nColSLt,"Qt.Fechada",oFontC8,200,200,,0)
				endif
				oPrinter:SayAlign(nLiItm,nQtOri+nSerie,"Qt.Unitar",oFontC8,200,200,,0)
				oPrinter:SayAlign(nLiItm,nQtSep+nSerie,"A Separar",oFontC8,200,200,,0)
				oPrinter:SayAlign(nLiItm,nQtEmb+nSerie,"Descricao Produto",oFontC8,200,200,,0)
				oPrinter:SayAlign(nLiItm,nColDes+nSerie,"Transportadora",oFontC8,200,200,,0)
				oPrinter:SayAlign(nLiItm,nColEnd+nSerie,"Armazem",oFontC8,200,200,,0) //"Armazem"
				oPrinter:SayAlign(nLiItm,nColLot+nSerie,"Endereco",oFontC8,200,200,,0) //"Endereço"
				oPrinter:Line(li+nLiItm,nMargDir, li+nLiItm, nMaxCol-nMargEsq,, "-2")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os itens da ordem de separacao ³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrinter:SayAlign(li+nLiItm,nMargDir,(cAliasOS)->CB8_PROD,oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nColAmz,Transform((cAliasOS)->CB8_QTDORI,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nColSLt,Transform((cAliasOS)->CB7_QTPALLET,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0)
			if  alltrim((cAliasOS)->B1_ITEMCC) == "TAIFF"
				oPrinter:SayAlign(li+nLiItm,nSerie,Transform((cAliasOS)->CB7_QTCAIXA,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0)
			endif
			oPrinter:SayAlign(li+nLiItm,nQtOri+nSerie,Transform((cAliasOS)->CB7_QTUNITA,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0) 
			oPrinter:SayAlign(li+nLiItm,nQtSep+nSerie,Transform((cAliasOS)->CB8_SALDOS,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nQtEmb+nSerie,(cAliasOS)->DESCRICAO_PRO,oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nColDes+nSerie,(cAliasOS)->A4_NOMTRA,oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nColEnd+nSerie,(cAliasOS)->CB8_LOCAL,oFontC8,200,200,,0)
			oPrinter:SayAlign(li+nLiItm,nColLot+nSerie,(cAliasOS)->CB8_LCALIZ,oFontC8,200,200,,0)
			nLinCount++

			cArmEnder := (cAliasOS)->CB8_LOCAL + (cAliasOS)->CB8_LCALIZ
			If .NOT. _fTaiff
				If ALLTRIM((cAliasOS)->CB8_LCALIZ) != ALLTRIM( (cAliasOS)->PAD_LCALIZ )
					If ASCAN(ALOCALIZ, (cAliasOS)->CB8_LOCAL + (cAliasOS)->CB8_LCALIZ ) = 0 
						AADD(ALOCALIZ , (cAliasOS)->CB8_LOCAL + (cAliasOS)->CB8_LCALIZ )
					EndIf
				EndIf
			EndIf				
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime linha para separar itens 		³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			oPrinter:Line(li+nLiItm,nMargDir, li+nLiItm, nMaxCol-nMargEsq,, "-2")
			nLinCount++

			NTOTPALLET += (cAliasOS)->CB7_QTPALLET
			NTOTCAIXAS	+= (cAliasOS)->CB7_QTCAIXA
				
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
			If (cAliasOS)->(Eof()) .OR. (cAliasOS)->CB8_ORDSEP != cOrdSep
				oPrinter:Line(li+nLiItm,nMargDir, li+nLiItm, nMaxCol-nMargEsq,, "-2")
				nLinCount++
				oPrinter:SayAlign(li+nLiItm,nMargDir,"TOTAIS",oFontC8,200,200,,0) //"TOTAL"
				oPrinter:SayAlign(li+nLiItm,nColSLt ,Transform(NTOTPALLET,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0) 
				IF  _fTaiff
					oPrinter:SayAlign(li+nLiItm,nSerie,Transform(NTOTCAIXAS,PesqPictQt("CB8_QTDORI",20)),oFontC8,200,200,,0)
					_cImpEnder := cArmEnder
					nLiItm += li
					nLinCount++
					oPrinter:FWMSBAR("CODE128",30 /*nRow*/,10 /*nCol*/,AllTrim(_cImpEnder),oPrinter,,,, 0.049,1.0,,,,.F.,,,)
					nLiItm += li
					oPrinter:SayAlign(340 ,nMargDir + 100,"Armazem Endereco",oFontA16,200,200,,0)
					oPrinter:SayAlign(400 ,nMargDir + 120,_cImpEnder,oFontA16,200,200,,0)
					nLinCount++
				Else
					nSubCol := 0
					nSubRow	:= 0
					for nLoop := 1 to LEN(ALOCALIZ)
						If nLinCount <> nMaxLinha
							oPrinter:Line(550,nMargDir, 550, nMaxCol-nMargEsq,, "-2")
							oPrinter:EndPage()
						EndIf
						_cImpEnder := ALOCALIZ[nLoop]
						oPrinter:FWMSBAR("CODE128" /*cTypeBar*/,30 + nSubRow /*nRow*/,05 + nSubCol /*nCol*/,AllTrim(_cImpEnder)/*cCode*/,oPrinter/*oPrint*/,.T./*lCheck*/,/*Color*/,.T./*lHorz*/,0.049/*nWidth*/,1.0/*nHeigth*/,.T. /*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,2/*nPFWidth*/,2/*nPFHeigth*/,.F./*lCmtr2Pix*/)
						nSubCol += 20
						If nSubCol > 40
							nSubRow += 05
							nSubCol := 0
						EndIf
						nLiItm += li
						nLinCount++
					next
					nLiItm += li
					nLinCount++
				endif
			Endif
			
			Loop
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

	nStatus := TCSqlExec("DROP TABLE " + aResult[1])
	
	if (nStatus < 0)
		conout("TCSQLError() " + TCSQLError())
	endif

endif

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
USER Function TFCabPagina(oPrinter)

Private nCol1Dir	:= 720-nMargDir   
Private nCol2Dir	:= 760-nMargDir

oPrinter:Line(li+5, nMargDir, li+5, nMaxCol-nMargEsq,, "-8")

oPrinter:SayAlign(li+10,nMargDir,STR0023,oFontA7,200,200,,0)//"SIGA/ACDR100/v11"
oPrinter:SayAlign(li+20,nMargDir,STR0024+Time(),oFontA7,200,200,,0)//"Hora: "
oPrinter:SayAlign(li+30,nMargDir,STR0025+FWFilialName(,,2) ,oFontA7,300,200,,0)//"Empresa: "

oPrinter:SayAlign(li+20,340,STR0026,oFontA12,nMaxCol-nMargEsq,200,2,0)//"Impressão das Ordens de Separação"

oPrinter:SayAlign(li+10,nCol1Dir,STR0027,oFontA7,200,200,,0)//"Folha   : "
oPrinter:SayAlign(li+20,nCol1Dir,STR0028,oFontA7,200,200,,0)//"Dt. Ref.: "
oPrinter:SayAlign(li+30,nCol1Dir,STR0029,oFontA7,200,200,,0)//"Emissão : "

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
User Function TFCabItem(oPrinter,cOrigem)

Local cOrdSep		:= AllTrim((cAliasOS)->CB7_ORDSEP)
Local cPedVen		:= AllTrim((cAliasOS)->CB7_PEDIDO)
Local cClient		:= AllTrim((cAliasOS)->CB7_CLIENT)+"-"+AllTrim((cAliasOS)->CB7_LOJA)
Local cNFiscal	    := AllTrim((cAliasOS)->CB7_NOTA)+"-"+AllTrim((cAliasOS)->&(SerieNfId('CB7',3,'CB7_SERIE')))
Local cOP			:= AllTrim((cAliasOS)->CB7_OP)
Local cStatus		:= RetStatus((cAliasOS)->CB7_STATUS)
Local cNmClient	    := AllTrim((cAliasOS)->CB7_NOMCLI)
Local cMarca	    := AllTrim((cAliasOS)->B1_ITEMCC)
LOCAL CUFCLIENTE	:= AllTrim((cAliasOS)->UF_CLIENT)
LOCAL C5DTPEDPR		:= AllTrim((cAliasOS)->C5_DTPEDPR)
LOCAL CCLASPED		:= AllTrim((cAliasOS)->LIN_CLASPED)


oPrinter:SayAlign(li+60,nMargDir,STR0030,oFontC8,200,200,,0)//"Ordem de Separação:"
oPrinter:SayAlign(li+60,nMargDir+105,cOrdSep,oFontC8,200,200,,0)

If Alltrim(cOrigem) == "1" // Pedido venda
	oPrinter:SayAlign(li+60,nMargDir+160,STR0031,oFontC8,200,200,,0)//"Pedido de Venda:"
	If Empty(cPedVen) .And. (cAliasOS)->CB7_STATUS <> "9"
		oPrinter:SayAlign(li+60,nMargDir+245,STR0047,oFontC8,200,200,,0)//"Aglutinado"
		oPrinter:SayAlign(li+72,nMargDir,STR0048,oFontC8,200,200,,0)//"PV's Aglutinados:"
		oPrinter:SayAlign(li+72,nMargDir+105,A100AglPd(cOrdSep),oFontC8,550,200,,0)		
	Else
		oPrinter:SayAlign(li+60,nMargDir+245,cPedVen,oFontC8,200,200,,0)
	EndIf
	oPrinter:SayAlign(li+60,nMargDir+310,STR0032,oFontC8,200,200,,0)//"Cliente:"
	oPrinter:SayAlign(li+60,nMargDir+355,cClient,oFontC8,200,200,,0)
ElseIf Alltrim(cOrigem) == "2" // Nota Fiscal
	oPrinter:SayAlign(li+60,nMargDir+160,STR0033,oFontC8,200,200,,0)//"Nota Fiscal:"
	oPrinter:SayAlign(li+60,nMargDir+230,cNFiscal,oFontC8,200,200,,0)
	oPrinter:SayAlign(li+60,nMargDir+310,STR0034,oFontC8,200,200,,0)//"Cliente:"
	oPrinter:SayAlign(li+60,nMargDir+355,cClient,oFontC8,200,200,,0)
ElseIf Alltrim(cOrigem) == "3" // Ordem de Producao
	oPrinter:SayAlign(li+60,nMargDir+160,STR0035,oFontC8,200,200,,0)//"Ordem de Produção:"
	oPrinter:SayAlign(li+60,nMargDir+255,cOP,oFontC8,200,200,,0)
EndIf

oPrinter:SayAlign(li+60,nMargDir+430,STR0036,oFontC8,200,200,,0)//"Status:"
oPrinter:SayAlign(li+60,nMargDir+470,cStatus,oFontC8,200,200,,0)

oPrinter:SayAlign(li+70,nMargDir,"Nome Cliente: ",oFontC8,200,200,,0)
oPrinter:SayAlign(li+70,nMargDir+105,cNmClient,oFontC8,200,200,,0)
oPrinter:SayAlign(li+70,nMargDir+310,"Marca: ",oFontC8,200,200,,0)
oPrinter:SayAlign(li+70,nMargDir+355,cMarca   ,oFontC8,200,200,,0)
oPrinter:SayAlign(li+70,nMargDir+430,"UF Cliente: ",oFontC8,200,200,,0)
oPrinter:SayAlign(li+70,nMargDir+470,CUFCLIENTE,oFontC8,200,200,,0)

IF .NOT. EMPTY(C5DTPEDPR)
	oPrinter:SayAlign(li+70,nMargDir+525,"Faturamento: ",oFontC8,200,200,,0)
	oPrinter:SayAlign(li+70,nMargDir+570,C5DTPEDPR,oFontC8,200,200,,0)
ENDIF
IF .NOT. EMPTY(CCLASPED)
	oPrinter:SayAlign(li+80,nMargDir+105,CCLASPED,oFontC8,500,200,,0)
ENDIF

oPrinter:Line(li+90,nMargDir, li+90, nMaxCol-nMargEsq,, "-2")

If MV_PAR06 == 1
	oPrinter:FWMSBAR("CODE128",5/*nRow*/,60/*nCol*/,AllTrim(cOrdSep),oPrinter,,,, 0.049,1.0,,,,.F.,,,)
EndIf

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
Static Function RetStatus(cStatus)

Local cDescri	:= ""

If Empty(cStatus) .or. cStatus == "0"
	cDescri:= STR0037//"Nao iniciado"
ElseIf cStatus == "1"
	cDescri:= STR0038//"Em separacao"
ElseIf cStatus == "2"
	cDescri:= STR0039//"Separacao finalizada"
ElseIf cStatus == "3"
	cDescri:= STR0040//"Em processo de embalagem"
ElseIf cStatus == "4"
	cDescri:= STR0041//"Embalagem Finalizada"
ElseIf cStatus == "5"
	cDescri:= STR0042//"Nota gerada"
ElseIf cStatus == "6"
	cDescri:= STR0043//"Nota impressa"
ElseIf cStatus == "7"
	cDescri:= STR0044//"Volume impresso"
ElseIf cStatus == "8"
	cDescri:= STR0045//"Em processo de embarque"
ElseIf cStatus == "9"
	cDescri:= STR0046//"Finalizado"
EndIf

Return(cDescri)

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
