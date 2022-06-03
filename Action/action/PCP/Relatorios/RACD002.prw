#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³RACD002   ³ Autor ³ Richard Nahas Cabral  ³ Data ³ 11/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Seleciona as Ordens de Producao para impressao das         ³±±
±±³			 ³ etiquetas. Executa a integração com o Bar Tender.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RACD002

Local xAlias	 	:= GetArea()
//Local aParamBox 	:= {}
//Local aRet			:= {}
//Local cNota
//Local cSerie
//Local sConteudo
//Local _cEtqQuery  := ""
//Local _cCliente   := ""
//Local _nLoop      := 0
//Local _cVolume    := ""
//Local _sComando   := ""
//Local _cTipoBar   := ""
//Local _nVolume    := 0
//Local cNotaFin    := ""
//Local cSerieFin   := ""
//Local _cPedido    := ""
//Local lEnd        := .F.
//Local aCombo		:= {"Lotes a imprimir","Lotes já impressos","Todos os lotes"}
//Local _nOpcao		:= 0
//Local cImprPadrao := GETNEWPAR("MV_IMPQUAP","QUALID")
Local cPerg        := "ZA4001"

Public lNoFiltro	:= .T.
Public _cLineBrow := ""
Public dOPFiltro	:= GETNEWPAR("MV_IMPQUAD" , dDataBase )
Public dOPAte		:= dDataBase
Public lPrimaVez	:= .T.
Public _cMaxLote	:= ""
Public _cMaxCaixa	:= ""
Public _cMaxSerial:= ""

Private cString := ""
PRIVATE cSKUCOD := ""
PRIVATE NRECNOSB1 := 0
/*
aAdd(aRet, "0")
aAdd(aRet, "ZZZZZZ")
aAdd(aRet, dDataBase - 60)
aAdd(aRet, dDataBase + 30)
aAdd(aRet, Alltrim( _cLineBrow ) )
aAdd(aRet, Alltrim( _cLineBrow ) )
aAdd(aRet, "QUALID" )
aAdd(aRet, 3 )
aSize(aRet,If(Len(aRet)>0,-1*Len(aRet),0) )
aSize(aParamBox,If(Len(aParamBox)>0,-1*Len(aParamBox),0) )
				
Aadd(aParamBox,{1,"Numero da OP Inicial"	,Space(TamSX3("C2_NUM")[1])	 	,PesqPict("SC2","C2_NUM")	 ,"","SC2","",50,.T.})
Aadd(aParamBox,{1,"Numero da OP Final"		,Space(TamSX3("C2_NUM")[1])	 	,PesqPict("SC2","C2_NUM")	 ,"","SC2","",50,.T.})
Aadd(aParamBox,{1,"Data da OP Inicial"		,Ctod("  /  /    ")             ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"Data da OP Final"		,Ctod("  /  /    ")             ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"Produto inicial"			,Space(TamSX3("B1_COD")[1])	    ,PesqPict("SB1","B1_COD")    ,"","SB1","",50,.T.})
Aadd(aParamBox,{1,"Produto final"			,Space(TamSX3("B1_COD")[1])	    ,PesqPict("SB1","B1_COD")    ,"","SB1","",50,.T.})
Aadd(aParamBox,{1,"Local de impressão"		,Space(TamSX3("CB5_CODIGO")[1])	,PesqPict("CB5","CB5_CODIGO"),"","CB5","",50,.T.})
AADD(aParamBox,{2,"Tipo de impressao"		,1,aCombo,70,"",.F.})

IF !ParamBox(aParamBox,"Informe os Parametros ",@aRet)
	Return(.F.)
Endif
*/

ValidPerg(cPerg)

If Pergunte(cPerg,.T.)
			
	cQuery := "SELECT DISTINCT '  ' AS ZA4_OK, ZA4_NUMOP, ZA4_COD, ZA4_DTFAB, Min( SUBSTRING(ZA4_NUMSER,8,6) ) AS NM_SERIAL , LEFT(ZA4_DSCETQ,25) AS ZA4_DSCETQ, COUNT(*) AS ETIQUETAS, " + CRLF
	cQuery += "SUM(ZA4_ETIQIM) AS ZA4_ETIQIM , SUM(ZA4_ETIQSL) AS ZA4_ETIQSL, ZA4_NLOTE, ZA4_OPITEM, ZA4_OPSEQ, ZA4_DESTIN  " + CRLF
	cQuery += ",ISNULL((SELECT C2__RECURS FROM " + RetSqlName("SC2") + " SC2 WHERE C2_FILIAL=ZA4_FILIAL AND SC2.D_E_L_E_T_='' AND ZA4_NUMOP=C2_NUM AND ZA4_OPITEM=C2_ITEM AND ZA4_OPSEQ=C2_SEQUEN),'') AS C2RECURSO " + CRLF
	cQuery += "FROM " + RetSqlName("ZA4") + " ZA4 " + CRLF 
	cQuery += "WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' " + CRLF
	cQuery += "AND ZA4_NUMOP >= '" + MV_PAR01 + "' AND ZA4_NUMOP <= '" + MV_PAR02 + "' " + CRLF
	If !empty(MV_PAR03) .and. !empty(MV_PAR04) 
	   cDInicio := STR(YEAR(MV_PAR03),4) + Right("0" + Alltrim(STR(MONTH(MV_PAR03),2)),2) + Right("0" + Alltrim(STR(DAY(MV_PAR03),2)),2)
	   cDFinal  := STR(YEAR(MV_PAR04),4) + Right("0" + Alltrim(STR(MONTH(MV_PAR04),2)),2) + Right("0" + Alltrim(STR(DAY(MV_PAR04),2)),2)
	   cQuery += "AND right(ZA4_DTFAB,4)+right(left(ZA4_DTFAB,5),2)+left(ZA4_DTFAB,2) >= '" + cDInicio + "' " + CRLF
	   cQuery += "AND right(ZA4_DTFAB,4)+right(left(ZA4_DTFAB,5),2)+left(ZA4_DTFAB,2) <= '" + cDFinal + "' " + CRLF
	Endif
	If !empty(MV_PAR05) .and. !empty(MV_PAR06) 
	   cQuery += "AND ZA4_COD >= '" + MV_PAR05 + "' AND ZA4_COD <= '" + MV_PAR06 + "' " + CRLF
	Endif
	If ValType(MV_PAR08) == "C"
		If MV_PAR08='Lotes a imprimir'
			cQuery += "AND ZA4_ETIQIM=0 "     + CRLF
		ElseIf MV_PAR08='Lotes já impressos'
			cQuery += "AND ZA4_ETIQIM=1 "     + CRLF
		Endif
	ElseIf ValType(MV_PAR08) == "N"
		If MV_PAR08=1
			cQuery += "AND ZA4_ETIQIM=0 "     + CRLF
		ElseIf MV_PAR08=2
			cQuery += "AND ZA4_ETIQIM=1 "     + CRLF
		Endif
	EndIf
	cQuery += "AND D_E_L_E_T_ != '*' "     + CRLF
	cQuery += "GROUP BY ZA4_FILIAL, ZA4_NUMOP, ZA4_COD, ZA4_DTFAB, ZA4_DSCETQ, ZA4_NLOTE, ZA4_OPITEM, ZA4_OPSEQ, ZA4_DESTIN " + CRLF
	//cQuery += " ORDER BY ZA4_NUMOP, ZA4_COD, ZA4_DTFAB, ZA4_NLOTE "
	cQuery += "ORDER BY ZA4_NLOTE, ZA4_NUMOP, ZA4_COD, ZA4_DTFAB " + CRLF
	
	MEMOWRITE("RACD002_RESULTADO_DO_FILTRO.SQL",cQuery)
	
	U_ViewZA4()
	
	RestArea(xAlias)
EndIf
Return(.T.)


//
// Funçao para montar a BROWSE
//
User Function ViewZA4()

Local	aCampos 	  := {}
Private cCadastro := "Selecione as Ordens de Produção Para Impressao de Etiquetas"
Private aRotina   := { { "Impr.Etiquetas"	,"U_EtqProd()", 0 , 6 },{ "Reimpressão"	,"U_ViewLot()", 0 , 6 },{ "Destino da Etq"	,"U_DESTINO()", 0 , 6 },{ "Etq.Despacho"	,"U_ImpDespa(1)", 0 , 6 },{ "Novo Etq.Despacho"	,"U_ImpDespa(2)", 0 , 6 }} 
//,{ "Consulta LOG"	,"U_Za4VeLog(TR2ZA4->ZA4_COD)", 0 , 6 }

If Select("TRZA4") > 0
	TRZA4->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TRZA4")

DbSelectArea("TRZA4")

cArq := CriaTrab(NIL,.F.)
Copy To &cArq

dbUseArea(.T.,,cArq,"TR2ZA4",.F.)

DbSelectArea("TR2ZA4")
TR2ZA4->(DBGotop())

AADD(aCampos, {"ZA4_OK"    , NIL ,"Ok"  })
AADD(aCampos, {"ZA4_NUMOP" , NIL ,"Nro.OP"})
AADD(aCampos, {"ZA4_NLOTE" , NIL ,"Lote"})
AADD(aCampos, {"NM_SERIAL" , NIL ,"Serial Ini"})
AADD(aCampos, {"ZA4_COD"   , NIL ,"Cod.Produto"})
AADD(aCampos, {"ZA4_DSCETQ", NIL ,"Descrição Etiqueta"})
AADD(aCampos, {"C2RECURSO" , NIL ,"Recurso"})
AADD(aCampos, {"ZA4_ETIQIM", NIL ,"Impressas"})
AADD(aCampos, {"ZA4_ETIQSL", NIL ,"A imprimir"})
AADD(aCampos, {"ZA4_DTFAB" , NIL ,"Firmada em"})
AADD(aCampos, {"ZA4_DESTIN", NIL ,"Destino"})
AADD(aCampos, {"ETIQUETAS" , NIL ,"Qtd. Etiq. da OP"})
AADD(aCampos, {"ZA4_OPITEM", NIL ,"Item"})
AADD(aCampos, {"ZA4_OPSEQ" , NIL ,"Seq."})

cMarca := GetMark()

MarkBrow("TR2ZA4","ZA4_OK",,aCampos,,GetMark(,"TR2ZA4", "ZA4_OK"))

If Select("TR2ZA4") > 0
	TR2ZA4->(DbCloseArea())
	Ferase(cArq+".DBF")
Endif
If Select("TRZA4") > 0
	TRZA4->(DbCloseArea())
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³EtqProd   ³ Autor ³ Richard Nahas Cabral  ³ Data ³ 11/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Executa a integração com o Bar Tender.                     ³±±
±±³			 ³ 		                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EtqProd()

Local _nCtaEtiquetas := 0
//Local _cEtqQuery 		:= ""
//Local sConteudo 		:= ""
//Local _cPorta 			:= ""
Local lEtqPallet	 	:= .F.
Local	cIniSerie 		:= ""
Local	cFinSerie 		:= ""	
Local	lMarcaOkValido	:= .F.
Local	__cCodBarra		:= ""
Local	__cEAN14			:= ""
Local _cAbreBarT		:= GETNEWPAR("TF_ABREBRT" , "S" )
Local	__lYesNo			:= .F.
Local __2cCodBarra	:= ""
Local __2cEAN14		:= ""
//Local cB1CODANT		:= ""
Local __1cCodBarra	:= ""
Local __1cEAN14		:= ""
Local __cCMseriais	:= ""
Local nLoopCx		:= 0
Local __cCMchave	:= ""
Local __cCMsequen	:= ""
LOCAL NX := 0
LOCAL cCabec := ""

Static __cUnidDesp	:= "1"									// Unidade de Despacho - Fixo 1 

If Empty(TR2ZA4->ZA4_NLOTE)
	If .NOT. U_CriaTfLotes()
		Return(.F.)	
	EndIf
EndIf

//cPathBarT 	:= Alltrim(GetMV("MV_PATHBART",,"C:\Arquivos de programas\Seagull\BarTender Suite\BarTender\Bartend.exe"))
cPathBarT	:= Alltrim(GetMV("MV_PATHBART",,"C:\Arquivos de programas\Seagull\BarTender\7.51\Bartend.exe"))
cPathEtiq 	:= Alltrim(GetMV("MV_PATHETIQ",,"C:\Etiquetas_Protheus\"))
cArqTxtInd	:= "ETIQ_IND.TXT"
cArqTxtCxa 	:= "ETIQ_CXA.TXT"
cArqTxtPLT	:= "ETIQ_PLT.TXT"

cCabec := ""
For nX := 1 to ZA4->(FCount())
	cNmCpo	:= ZA4->(fieldname(nX))
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
Next
cNmCpo	:= "DESCR_ETIQ_CORPO"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "LETRA"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "ANO"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "DIA"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL-2"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL-3"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL-4"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL-5"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "SERIAL-6"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "BD_PALLET"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "BD_MASTER"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cNmCpo	:= "BD_UNITARIO"
cCabec	+= '"'+Alltrim(cNmCpo)+'",'
cCabec := Left(cCabec,Len(cCabec)-1)+CRLF

If _cAbreBarT = "N"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
	If File(cPathEtiq + cArqTxtInd)
	   Ferase(cPathEtiq + cArqTxtInd)
	Endif
	
	nHdlInd   := fCreate(cPathEtiq+cArqTxtInd)
	fWrite(nHdlInd,cCabec,Len(cCabec))

	If File(cPathEtiq + cArqTxtCxa)
	   Ferase(cPathEtiq + cArqTxtCxa)
	Endif
	
	nHdlCxa   := fCreate(cPathEtiq+cArqTxtCxa)
	fWrite(nHdlCxa,cCabec,Len(cCabec))
EndIf

DbSelectArea("TR2ZA4")
DbGotop()
Do While ! TR2ZA4->(Eof())

	IF Empty(TR2ZA4->ZA4_OK) 
		TR2ZA4->(DbSkip())
		Loop
	EndIF

	cNumOP:= TR2ZA4->ZA4_NUMOP
	cCod	:= TR2ZA4->ZA4_COD
	cLote	:= TR2ZA4->ZA4_NLOTE
        
	ZA4->(DbSetOrder(2))
	ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
   

	If _cAbreBarT = "S"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
		If File(cPathEtiq + cArqTxtInd)
		   Ferase(cPathEtiq + cArqTxtInd)
		Endif
		
		nHdlInd   := fCreate(cPathEtiq+cArqTxtInd)
		fWrite(nHdlInd,cCabec,Len(cCabec))
	
		If File(cPathEtiq + cArqTxtCxa)
		   Ferase(cPathEtiq + cArqTxtCxa)
		Endif
		
		nHdlCxa   := fCreate(cPathEtiq+cArqTxtCxa)
		fWrite(nHdlCxa,cCabec,Len(cCabec))
   EndIf
   
	cCaixa := ""
	cIniSerie := ""
	cFinSerie := ""	
	
	SB1->(DbSeek(xFilial("SB1")+cCod))
	NRECNOSB1 := SB1->(RECNO())
	cSKUCOD:= SB1->B1_COD
	If SB1->(FIELDPOS( "B1_PRCOM" )) > 0
		IF .NOT. EMPTY(SB1->B1_PRCOM)
			cSKUCOD:= SB1->B1_PRCOM
			SB1->(DbSeek(xFilial("SB1")+cSKUCOD))
		ENDIF
	EndIf
	
	lEtqPallet		:= .F.
	lPrimeiraSerie := .T.
	lMarcaOkValido	:= .F.
	
	_nCtaEtiquetas := 1
	Do While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->(ZA4_NUMOP+ZA4_COD) = cNumOP+cCod .And. ! ZA4->(Eof())
		If ZA4->ZA4_NLOTE = cLote .and. lPrimeiraSerie
			lPrimeiraSerie := .F.
			If Empty( ZA4->ZA4_SERIAL )
				cIniSerie := Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_NUMSER")))) ,6)
			Else
				cIniSerie := Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) ,6)
			Endif
		EndIf
		If ZA4->ZA4_NLOTE = cLote .and. ZA4_ETIQIM = 0
			lEtqPallet := .T.
		EndIf

		__cCodBarra	:= __cUnidDesp + Left(SB1->B1_CODBAR,12)
		__cEAN14		:= __cCodBarra + CBDigVer(__cCodBarra)

		ZA4->(RecLock("ZA4",.f.))
		ZA4->ZA4_DSCETQ:= SB1->B1_DESC    
		ZA4->ZA4_VOLTAG:= SB1->B1_VOLTAG
		ZA4->ZA4_EAN13	:= SB1->B1_CODBAR
  		ZA4->ZA4_EAN14	:= __cEAN14
		ZA4->(MsUnlock())	

	   If ZA4->ZA4_NLOTE = cLote .and. ZA4->ZA4_ETIQSL = 1
			lMarcaOkValido	:= .T.
			If Empty( ZA4->ZA4_SERIAL )
				
				_cSerie			:= ZA4->ZA4_NUMSER
				cDataSeq			:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
				cSerialRecal	:= SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Right( Alltrim(_cSerie) , 6)
				cBarra			:= Alltrim(SB1->B1_COD)+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Right(Strzero(Year(dDataBase),4),2) + Right( Alltrim(ZA4->ZA4_BARRA) , 17 )
				
				ZA4->(RecLock("ZA4",.f.))
				ZA4->ZA4_SERIAL:= cSerialRecal
				ZA4->ZA4_DTIMP	:= dDataBase
				ZA4->ZA4_BARRA	:= cBarra
				ZA4->(MsUnlock())	
				
			EndIf
			
			If len( Alltrim(ZA4->ZA4_SERIAL) ) < len( Alltrim(ZA4->ZA4_NUMSER) )
				ZA4->(RecLock("ZA4",.f.))
				ZA4->ZA4_SERIAL:= ZA4->ZA4_NUMSER
				ZA4->(MsUnlock())	
			EndIf
			
			cLinha := ""

			For nX := 1 to ZA4->(FCount()) 
				cNmCpo := ZA4->(fieldname(nX))	        
				cDado	 := ZA4->(FieldGet(FieldPos(cNmCpo)))	    
				If cNmCpo='ZA4_NUMSER'
					cDado	 := ZA4->(FieldGet(FieldPos('ZA4_SERIAL')))	    
				EndIf
				If cNmCpo='ZA4_NSERIE'
					cDado	 := ZA4->(FieldGet(FieldPos('ZA4_SERIAL')))	    
				EndIf
				If cNmCpo='ZA4_DTFAB'
				   cDado  := Dtoc( ZA4->(FieldGet(FieldPos('ZA4_DTIMP'))) )
				EndIf
				cLinha += '"'+Alltrim(cDado)+'",'
			Next
			//
			// Acrescentada a descrição da etiqueta do corpo
			//
			cDado	 := SB1->(FieldGet(FieldPos("B1_DESCETI")))	    
			cLinha += '"'+Alltrim(cDado)+'",'
			//
			// Composicao de campos para o modelo de etiqueta 010x010
			//
			cDado	 := Left( ZA4->(FieldGet(FieldPos("ZA4_SERIAL"))) ,2) // Letra
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := Right( Left( ZA4->(FieldGet(FieldPos("ZA4_SERIAL"))) ,4),2) // Ano
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := Right( Left( ZA4->(FieldGet(FieldPos("ZA4_SERIAL"))) ,7),3) // Dia
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) ,6) // Serial
			cLinha += '"'+Alltrim(cDado)+'",'
			__cCMsequen		:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) ,6)
			For nLoopCx := 1 to 5
				cLinha += '"'+Alltrim(STRZERO( VAL(__cCMsequen) + nLoopCx ,6))+'",'
			Next 
			cDado	 := Right( Alltrim(__2cEAN14) ,14) // EAN_14 DO PRODUTO ORIGINAL
			cLinha += '"'+Alltrim(cDado)+'",'


			//
			// linha para alimentar o codigo bidimensional "BD_PALLET" 
			//
			__2cCodBarra	:= '2' + Left(SB1->B1_CODBAR,12)
			__2cEAN14		:= __2cCodBarra + CBDigVer(__2cCodBarra)

			cDado	 := "<PL>"
			cDado	 += "<" + __2cEAN14 + ">"
			cDado	 += "<" + ALLTRIM(cSKUCOD) + ">"
			cDado	 += "<" + ZA4->(FieldGet(FieldPos("ZA4_LOTECT")))	  + ">"
			cLinha += '"'+Alltrim(cDado)+'",'
			
			//
			// linha para alimentar o codigo bidimensional "BD_MASTER" 
			//
			__1cCodBarra	:= '1' + Left(SB1->B1_CODBAR,12)
			__1cEAN14		:= __1cCodBarra + CBDigVer(__1cCodBarra)
			__cCMseriais	:= ALLTRIM( ZA4->(FieldGet(FieldPos("ZA4_SERIAL"))) )
			__cCMchave		:= SUBSTR( ZA4->(FieldGet(FieldPos("ZA4_SERIAL"))) ,1,7)
			__cCMsequen		:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) ,6)
			For nLoopCx := 1 to 5
				__cCMseriais += "><" +  __cCMchave + STRZERO( VAL(__cCMsequen) + nLoopCx ,6)
			Next 

			cDado	 := "<CM>"
			cDado	 += "<" + __1cEAN14 + ">"
			cDado	 += "<" + ALLTRIM(cSKUCOD) + ">"
			cDado	 += "<" + ZA4->(FieldGet(FieldPos("ZA4_LOTECT")))	  + ">"
			cDado	 += "<" + "ACT" + ZA4->(FieldGet(FieldPos("ZA4_CAIXA6")))	  + ">"
			cDado	 += "<" + __cCMseriais  + ">"
			cLinha += '"'+Alltrim(cDado)+'",'
 
			//
			// linha para alimentar o codigo bidimensional "BD_UNITARIO" 
			//
			cDado	 := "<CI>"
			cDado	 += "<" + ALLTRIM(SB1->B1_CODBAR) + ">"
			cDado	 += "<" + ALLTRIM(cSKUCOD) + ">"
			cDado	 += "<" + ZA4->(FieldGet(FieldPos("ZA4_LOTECT"))) + ">"
			cDado	 += "<" + "ACT" + ZA4->(FieldGet(FieldPos("ZA4_CAIXA6"))) + ">"
			cDado	 += "<" + ALLTRIM(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) + ">"
			cLinha += '"'+Alltrim(cDado)+'",'
			          
			cLinha := Left(cLinha,Len(cLinha)-1)+CRLF
			fWrite(nHdlInd,cLinha,Len(cLinha))

			If ZA4->ZA4_NCAIXA <> cCaixa
				fWrite(nHdlCxa,cLinha,Len(cLinha))
				cCaixa := ZA4->ZA4_NCAIXA
			Endif
			cFinSerie := Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_SERIAL")))) ,6)
			_nCtaEtiquetas++
		Endif
		ZA4->(DBSkip())
	Enddo

	If _cAbreBarT = "S"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
		fClose(nHdlInd)
		fClose(nHdlcXa)
	EndIf
	
	If	lMarcaOkValido
		lEtqPallet := .F.
		/*
		IF .not. lEtqPallet
			cCabec := ""
			cNmCpo	:= "CODIGO"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "DESCRICAO_1"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "DESCRICAO_2"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "LOTE"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "2EAN14"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "NUMOP"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "SERIE_I"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
			cNmCpo	:= "SERIE_F"
			cCabec	+= '"'+Alltrim(cNmCpo)+'",'
		
			cCabec := Left(cCabec,Len(cCabec)-1)+CRLF
			If File(cPathEtiq + cArqTxtPLT)
			   Ferase(cPathEtiq + cArqTxtPLT)
			Endif
			nHdlPlt   := fCreate(cPathEtiq+cArqTxtPLT)
			fWrite(nHdlPlt,cCabec,Len(cCabec))

			cCodBarra	:= '2' + Left(SB1->B1_CODBAR,12)
			cEAN14		:= cCodBarra + CBDigVer(cCodBarra)
		
			cLinha := ""
		
			cDado	 := SB1->(FieldGet(FieldPos("B1_COD")))	    
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := SUBS(SB1->(FieldGet(FieldPos("B1_DESC"))),01,27)	    
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := SUBS(SB1->(FieldGet(FieldPos("B1_DESC"))),28,27)	    
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := cLote
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := cEAN14
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := cNumOP
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := cIniSerie
			cLinha += '"'+Alltrim(cDado)+'",'
			cDado	 := cFinSerie
			cLinha += '"'+Alltrim(cDado)+'",'
					          
			cLinha := Left(cLinha,Len(cLinha)-1)+CRLF
			fWrite(nHdlPlt,cLinha,Len(cLinha))
		
			fClose(nHdlPlt)
			
		EndIf
		If lEtqPallet
	
			cCodBarra	:= '2' + Left(SB1->B1_CODBAR,12)
			cEAN14		:= cCodBarra + CBDigVer(cCodBarra)
			If CB5->CB5_LPT != "0"
				_cPorta := "LPT" + Alltrim( CB5->CB5_LPT )+":"
			Else
				_cPorta := "COM" + Alltrim( CB5->CB5_PORTA )
			Endif
			
			If CB5->CB5_LPT != "0"
				PrinterWin(.F.) 						// Impressao Dos/Windows
				PreparePrint(.F.,"",.F.,_cPorta) 		// Prepara a impressao na porta especIficada
				InitPrint(1)
			Else
				nHdll := 0
				MsOpenPort(nHdll,_cPorta + ":9600,n,8,1")
			EndIf
				       
			MSCBPRINTER(Alltrim(CB5->CB5_MODELO),_cPorta,,,.F.)
			MSCBCHKStatus(.f.) 
			MSCBBEGIN(1,6)
			MSCBBOX(05,01,100,91,5) // de 61 para 91
			MSCBLineH(05,07,100,5)
			MSCBSAY(07,03,'UNID.DE DESPACHO',"N","B","025,035")
			MSCBSAY(07,10,"CODIGO", "N", "0", "032,030")
			MSCBSAY(07,16,AllTrim(SB1->B1_COD), "N", "B", "030,022")
			MSCBSAY(07,24,"DESCRICAO","N","0","032,030")
			MSCBSAY(07,30,SUBS(SB1->B1_DESC,01,27),"N", "B", "030,022")
			MSCBSAY(07,36,SUBS(SB1->B1_DESC,28,27),"N", "B", "030,022")
			MSCBSAYBAR(20,44,cEAN14,"N","MB07",12,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)        
			MSCBSAY(55,71,"LOTE","N","0","032,030")
			MSCBSAYBAR(38,74,Alltrim(cLote),"N","MB07",12,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)        
	                    
			cSubDetalhe := replicate("-",90)
			MSCBSAY(07,95,cSubDetalhe, "N", "0", "032,030")
	
			cSubDetalhe := "Codigo: " + AllTrim(SB1->B1_COD) + Space(5) + "Lote: " + Alltrim(cLote) + Space(5) + "OP: " + Alltrim(cNumOP)
			MSCBSAY(07,100,cSubDetalhe, "N", "0", "032,030")
	
			cSubDetalhe := "Descricao: " + Alltrim(SB1->B1_DESC)
			MSCBSAY(07,105,cSubDetalhe, "N", "0", "032,030")
	
			cSubDetalhe := "Serial Inicial: " + cIniSerie + spac(05) + "Serial Final: " + cFinSerie
			MSCBSAY(07,110,cSubDetalhe, "N", "0", "032,030")
	
			sConteudo:=MSCBEND()
			                        
			If CB5->CB5_LPT != "0"
				Ms_Flush()
			Else
				MsClosePort(nHdll)
				nHdll := 0
			Endif
		
		EndIf
		*/
		lEtqPallet := .F.
		
		If _cAbreBarT = "S"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
			CallBarT(SB1->B1_ETIQ01)
			CallBarT(SB1->B1_ETIQ02)
			CallBarT(SB1->B1_ETIQ03)
		EndIf
//		If !Empty(SB1->B1_ETIQ04)
//			CallBarT(SB1->B1_ETIQ04)
//		Endif
//		If !Empty(SB1->B1_ETIQ05)
//			CallBarT(SB1->B1_ETIQ05)
//		Endif
		
		If _cAbreBarT = "S"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
			__lYesNo	:= .F.
			If MsgYesNo("Todas etiquetas da OP numero " + cNumOP + " foram impressas corretamente ?")
				__lYesNo	:= .T.
			EndIf
		Else
			__lYesNo	:= .T.
	   EndIf
	   
		If __lYesNo
			cTime := TIME()
			
			// Atribui 1 ao campo, indicando que ja foi impressa a etiqueta solicitada e data de impressao
			cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_ETIQIM = 1 , "
			cUpdate += " 												ZA4_PRTUSE = '" + Alltrim(cUSERNAME) + "' ,"
			cUpdate += " 												ZA4_PRTHOR = '" + Substr(cTime,1,5) + "' ,"
			cUpdate += " 												ZA4_STATUS = 'S' "
			cUpdate += " WHERE ZA4_NUMOP = '" + cNumOP + "' "
			cUpdate += " 	AND ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			cUpdate += "   AND ZA4_NLOTE = '" + Alltrim(cLote) + "' "
			cUpdate += "   AND ZA4_COD = '" + Alltrim(cCod) + "' "
			cUpdate += "   AND ZA4_ETIQSL = 1"
			cUpdate += "   AND D_E_L_E_T_ != '*'"
			TCSqlExec(cUpdate)
			
			// Atribui 0 ao campo, indicando que não há mais solicitações
			cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_ETIQSL= 0 " 
			cUpdate += " WHERE ZA4_NUMOP = '" + cNumOP + "' "
			cUpdate += " 	AND ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			cUpdate += "   AND ZA4_NLOTE = '" + Alltrim(cLote) + "' "
			cUpdate += "   AND ZA4_COD = '" + Alltrim(cCod) + "' "
			cUpdate += "   AND D_E_L_E_T_ != '*'"
			TCSqlExec(cUpdate)
			
			TR2ZA4->ZA4_ETIQIM += TR2ZA4->ZA4_ETIQSL
			If TR2ZA4->ZA4_ETIQIM > TR2ZA4->ETIQUETAS
				TR2ZA4->ZA4_ETIQIM := TR2ZA4->ETIQUETAS
			Endif
			TR2ZA4->ZA4_ETIQSL := TR2ZA4->ETIQUETAS - TR2ZA4->ZA4_ETIQIM
			TR2ZA4->ZA4_OK     := ""
			
		Endif              
	Else	
		TR2ZA4->ZA4_OK	:= ""
   EndIf
	SB1->(DBGOTO(NRECNOSB1))

	TR2ZA4->(DbSkip())

End
If _cAbreBarT = "N"   // Esta condição foi implementada para atender a operação da ACTION - VARGINHA
	fClose(nHdlInd)
	fClose(nHdlcXa)
EndIf
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CallBarT	ºAutor  ³Richard Nahas Cabralº Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CallBarT(cEtiqueta)

If ! Empty(cEtiqueta)
	SX5->(DbSeek(xFilial("SX5")+"ZA"+cEtiqueta))
	cArqEtiq := Alltrim(SX5->X5_DESCRI)+".btw"
	WinExec(cPathBarT + " " + cPathEtiq + cArqEtiq,1)
	MsgAlert("Etiqueta " + Alltrim(SX5->X5_DESCRI) + " aberta pelo Bar Tender !!! Pressione ENTER apos a impressão !!!","STOP")
Else
	MsgAlert("Produto não classificado para impressão de etiquetas, atualize no cadastro de produtos na aba OUTROS ","A V I S O")
Endif

Return(.T.)

//************************************************************************************************************
// Função que permite ao usuario encerrar a impressao das etiquetas da OP
//************************************************************************************************************
// Autor: Carlos Alday Torres  | Criada em: 29/10/2010
//************************************************************************************************************
User Function EtqFin()
Local _cExNumOP	:= ""
Local _cExCod		:= ""
Local _cExLote		:= ""
Local _cExCaixa	:= ""
Local _cExSerie	:= ""
Local	_dExDtFab	
//Local cUpdate		:= ""
//Local cExcComLte	:= space(01)
//Local nElementos	:= 0
Local nTRB2Last	:= 0
//Local nTRB2Next	:= 0
Local nMarcados	:= 0

//MSGALERT("Esta rotina irá excluir os lotes selecionados e re-enumerar os lotes subseqüentes, mesmo que já tenham sido impressos!","ALERTA")

If MsgYesNo("Deseja realmente executar este processo?")
	//
	// Loop que busca o primeiro lote, numero da caixa e serial que ficará disponível, que corresponde ao lote que será excluido
	//
   nMarcados	:=	0
	TR2ZA4->(DbGoTop())
	While !TR2ZA4->(Eof())
      If !empty(TR2ZA4->ZA4_OK)
		   nMarcados	+=	1
			_cExNumOP	:= TR2ZA4->ZA4_NUMOP
			_cExCod		:= TR2ZA4->ZA4_COD
			_cExLote		:= TR2ZA4->ZA4_NLOTE
			_dExDtFab	:= TR2ZA4->ZA4_DTFAB 
		  	DbSelectArea("ZA4")
			ZA4->(DbSetOrder(2))
			ZA4->(DbSeek(xFilial("ZA4") + _cExNumOP + _cExCod ))
			While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_NUMOP = _cExNumOP  .AND.  ZA4->ZA4_COD = _cExCod  .AND.  !ZA4->(EOF())
			   If ZA4->ZA4_NLOTE = _cExLote .and. ZA4->ZA4_DTFAB=_dExDtFab
					_cExCaixa	:= ZA4->ZA4_NCAIXA
					_cExSerie	:= Alltrim(ZA4->ZA4_NUMSER)
					Exit	// <-- O comando EXIT força a saida do loop apos determinar o primeiro numero de serie
				EndIf
				ZA4->(DbSkip())
			End
      	Exit	// <-- O comando EXIT força a saida do loop do primeiro registro a excluir
      Else
	      nTRB2Last	:= TR2ZA4->(RECNO()) // Este ponteiro contem o primeiro lote que nao será excluido
		EndIf
		TR2ZA4->(DbSkip())
	End
	
	If nMarcados > 0

		Processa({|| U_ExcLote() },"Aguarde, excluindo lotes da tabela de etiquetas ZA4...")
	   
		MSGALERT("Exclusão finalizada, re-enumeração automatica dos lotes e seriais está DESABILITADA!!!","ALERTA")
		
		/* 
		//------------------------------------------------------------------------------------------------
		// ROTINA INIBIDA                           AUTOR: CARLOS ALDAY TORRES            DATA: 18/03/2011    
		// Objetivo da rotina: renumerar os lotes e seriais automaticamente
		// Motivo: A ação automatica será realizada pelo usuário nos botões especificos "Refaz Lote" e 
		//         "Refaz Serie", a justificativa do bloqueio é porque acusam erro nesta rotina
		//------------------------------------------------------------------------------------------------
		//Verifica se tem lote apos o primeiro lote nao será excluido
		TR2ZA4->(DbGoto(nTRB2Last))	
		TR2ZA4->(DbSkip())
		If !TR2ZA4->(Eof())
			nTRB2Next := TR2ZA4->(Recno())
		EndIf
	
		If !Empty( _cExNumOP )
			If !TR2ZA4->(Eof())
				DbSelectArea("TR2ZA4")
				nElementos	:=	TR2ZA4->(reccount())
				TR2ZA4->(DbGoto(nTRB2Next))
				Processa({|| U_AlinLote( _cExLote , _cExCaixa , nElementos ) },"Aguarde, Re-enumerando lotes...")
		
				_cMaxLote	:= ""
				_cMaxCaixa	:= ""
				_cMaxSerial	:= ""
		
				DbSelectArea("TR2ZA4")
				TR2ZA4->(DbGoto(nTRB2Next))
				Processa({|| U_Serial( Right(_cExSerie,6) , nElementos ) },"Aguarde, Re-enumerando seriais...")
				
				TR2ZA4->(DbGoto(nTRB2Next))
			Else
				_cMaxLote	:= ""
				_cMaxCaixa	:= ""
				_cMaxSerial	:= ""
	
				TR2ZA4->(DbGoto(nTRB2Last))	
				DbSelectArea("ZA4")
				ZA4->(DbSetOrder(3))
				ZA4->(DbSeek(xFilial("ZA4") + TR2ZA4->ZA4_COD  ))
				While ZA4->ZA4_COD = TR2ZA4->ZA4_COD .AND. !ZA4->(EOF())
					If Substr(ZA4->ZA4_DTFAB,7,4) = Strzero(Year(dDataBase),4)
						_cMaxSerial	:= ZA4->ZA4_NUMSER
						_cMaxLote	:= ZA4->ZA4_NLOTE
						_cMaxCaixa	:= ZA4->ZA4_NCAIXA
					EndIf
					ZA4->(DbSkip())
				End
				DbSelectArea("TR2ZA4")
			EndIf	
			If !Empty( _cMaxLote )
			   SB1->(dbseek(  xFilial('SB1') + TR2ZA4->ZA4_COD  ))
				RecLock("SB1",.F.)
				SB1->B1_LOTECTL:= _cMaxLote
				SB1->B1_CAIXA	:= _cMaxCaixa
			   SB1->b1_serie	:= _cMaxSerial
				SB1->(MsUnlock())
				MessageBox("Serial atualizado com sucesso na tabela de produtos (SB1)","Serial do produto",0)
			Else
				MessageBox("Serial NÃO atualizado na tabela SB1, comunique a TI!!!","Serial do produto",0)
			EndIf
		EndIf
		//------------------------------------------------------------------------------------------------
		// fim da rotina de renumeração automatica
		//------------------------------------------------------------------------------------------------
		*/
	Else
		MessageBox("Não há itens marcados para Excluir, processamento sem resultados!","Serial do produto",0)
	EndIf
Endif   

Return(.T.)

//----------------------------------------------------------------------------------------------------------------
// Função que exclue na tabela ZA4 os lotes marcados
//----------------------------------------------------------------------------------------------------------------
User Function ExcLote()
//Local cIpToledo	:= GETNEWPAR("MV_IPTOLED","192.168.0.5")
//Local _cArquivoBat:= "C:\LTETOLE.BAT"
//Local _cEndLine	:= CHR(13)+CHR(10)
//Local _cPathToledo:= "\\"+cIpToledo+"\Toledo_Protheus\ /Y"
//Local _sComando	:= ""
//Local _cTexto		:= ""                                    
//Local _cHoraFix	:= Substr(Time(),1,2) + Substr(Time(),4,2) + Substr(Time(),7,2)
//Local _cArqToledo	:= "C:\[e" + Dtos(Date()) + _cHoraFix + "]LOTE.TXT"

ProcRegua( TR2ZA4->(reccount()) ) 

TR2ZA4->(DbGoTop())
While !TR2ZA4->(Eof())
	IncProc()
	If !empty(TR2ZA4->ZA4_OK)
		_cTime	:= TIME()
		If !Empty(TR2ZA4->ZA4_NLOTE)
			cUpdate	:= "UPDATE " + RetSqlName("ZA4") + " "
			cUpdate	+= " 	SET D_E_L_E_T_ = '*', ZA4_STATUS = 'o', "
			cUpdate	+= "      ZA4_DESTIN = 'Exc.em '+Convert(varchar(08),getdate(),112 ), "  
			cUpdate	+= "  	 ZA4_PRTUSE = '" + Alltrim(cUSERNAME) + "', "
			cUpdate	+= " 		 ZA4_PRTHOR = '" + Substr(_cTime,1,5) + "' "
			cUpdate	+= " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			cUpdate	+= "   AND ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "' "
			cUpdate	+= "   AND ZA4_NLOTE = '" + Alltrim(TR2ZA4->ZA4_NLOTE) + "' "
			cUpdate	+= "   AND RIGHT(ZA4_DTFAB,4) = '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "' "
			cUpdate	+= "   AND D_E_L_E_T_ != '*'"
			TCSqlExec(cUpdate)      
	   Else
			cUpdate	:= "UPDATE " + RetSqlName("ZA4") + " "
			cUpdate	+= " 	SET D_E_L_E_T_ = '*', ZA4_STATUS = 'o', "
			cUpdate	+= "      ZA4_DESTIN = 'Exc.em '+Convert(varchar(08),getdate(),112 ), "  
			cUpdate	+= "  	 ZA4_PRTUSE = '" + Alltrim(cUSERNAME) + "', "
			cUpdate	+= " 		 ZA4_PRTHOR = '" + Substr(_cTime,1,5) + "' "
			cUpdate	+= " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			cUpdate	+= "   AND ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "' "
			cUpdate	+= "   AND ZA4_NUMOP = '" + Alltrim(TR2ZA4->ZA4_NUMOP) + "' "
			cUpdate	+= "   AND RIGHT(ZA4_DTFAB,4) = '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "' "
			cUpdate	+= "   AND D_E_L_E_T_ != '*'"
			TCSqlExec(cUpdate)      
	   Endif
		//Regra:   Tabela  Campo vl Antes         vl Apos                                                 Chave de pesquisa   Registro   INCLUSAO
		U_Za4GrvLog( "ZA4",  "", TR2ZA4->ZA4_NLOTE, "LOTE EXCLUIDO - DATA DE FABRICACAO: "+TR2ZA4->ZA4_DTFAB, TR2ZA4->ZA4_COD     , 0 			, "I"    ,"RACD002")

		TR2ZA4->(DbDelete()) 
	EndIf
	TR2ZA4->(DbSkip())
End
TR2ZA4->(DbGoTop())
RETURN (.T.)

//----------------------------------------------------------------------------------------------------------------
// Função de Apoio à exclusão de lote, re-enumeração do lote
//----------------------------------------------------------------------------------------------------------------
// Autor: Carlos Alday Torres  | Criada em: 29/10/2010
//----------------------------------------------------------------------------------------------------------------
User Function AlinLote( _cExLote, _cExCaixa , nElementos )
Local cLote		:= _cExLote
Local cCaixa	:= _cExCaixa
Local nStop		:= TR2ZA4->(recno())
Local	cNumOP	:= TR2ZA4->ZA4_NUMOP
Local	cCod		:= TR2ZA4->ZA4_COD
Local	_cLote	:= TR2ZA4->ZA4_NLOTE
Local	nQtdeCx	:= 1
//Local nLtUltimo:= TR2ZA4->ZA4_NLOTE
//Local nRecAtua	:= 0
//Local nRecNext	:= 0
Local _dDtFab
Local lUmLog 	:= .T.

ProcRegua(nElementos) 

While !TR2ZA4->(Eof())

	IncProc()

	cNumOP	:= TR2ZA4->ZA4_NUMOP
	cCod		:= TR2ZA4->ZA4_COD
	_cLote	:= TR2ZA4->ZA4_NLOTE
	_dDtFab	:= TR2ZA4->ZA4_DTFAB 
	nQtdeCx	:= 1

   TR2ZA4->ZA4_NLOTE := cLote
   
	lUmLog := .T.
	DbSelectArea("ZA4")
	ZA4->(DbSetOrder(2))
	ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
	While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_NUMOP = cNumOP .AND. ZA4->ZA4_COD = cCod .AND. !ZA4->(EOF())
	   If ZA4->ZA4_NLOTE = _cLote  .and.  ZA4->ZA4_DTFAB = _dDtFab 

		   RecLock('ZA4',.F.)
		   ZA4->ZA4_CXLOTE	:= ZA4->ZA4_NLOTE
		   ZA4->ZA4_NLOTE		:= cLote
			If	!empty( _cExCaixa )		   
				ZA4->ZA4_NCAIXA	:= cCaixa
				If nQtdeCx = 6
					cCaixa  := Soma1(cCaixa)
					nQtdeCx := 0
				EndIf
	         nQtdeCx++
         Endif
		   ZA4->(MsUnLock())
			
			If lUmLog
				//Regra:   Tabela  Campo        vl Antes         vl Apos         Chave de pesquisa   registro         Inclusao
				U_Za4GrvLog( "ZA4",  "ZA4_NLOTE", ZA4->ZA4_CXLOTE, ZA4->ZA4_NLOTE, ZA4->ZA4_COD      , ZA4->(RECNO()) , "I","RACD002")
				lUmLog := .F.
	      EndIf
	      
		EndIf
		ZA4->(DbSkip())
	End
	DbSelectArea("TR2ZA4")
	cLote			:= Strzero( Val(cLote) + 1 , Len(Alltrim(_cExLote)) )
	TR2ZA4->(DbSkip())		
End	

DbSelectArea("TR2ZA4")
DbGoto( nStop )
Return (.T.)


//************************************************************************************************************
// Função que permite ao alterar a quantidade de etiquetas a imprimir
//************************************************************************************************************
// Responsavel: Carlos Alday Torres  | Criada em: 04/05/2010
//************************************************************************************************************
User Function ViewLot()
Local _cNumOP := ""
Local _cCod	  := ""
Local _cLote  := ""
Local cQuery  := ""
Local _xAlias := GetArea()
Local mCampos := {}
Local nTR2Rec := 0

Private cCadastro := "Selecione as Series das Ordens de Produção Para Impressao de Etiquetas"
Private aRotina   := { { "Confirme"	,"U_EtqMarc()", 0 , 6 } } 
Private cMarca    := GetMark()

_cNumOP	:= TR2ZA4->ZA4_NUMOP
_cCod		:= TR2ZA4->ZA4_COD
_cLote	:= TR2ZA4->ZA4_NLOTE
nTR2Rec	:= TR2ZA4->(Recno())

cQuery := "SELECT '  ' AS ZA3_OK, ZA4_NUMOP, ZA4_COD, ZA4_DTFAB, ZA4_DSCETQ, ZA4_NUMSER, "
cQuery += "  ZA4_NCAIXA , ZA4_DTIMP, "
cQuery += "  (CASE WHEN ZA4_ETIQIM=1 THEN 'Sim' ELSE 'Não' END) AS ZA4_ETIQIM , ZA4_ETIQSL, ZA4_NLOTE,  "
//cQuery += "  (CASE WHEN ZA4_STATUS='F' THEN 'Encerrada' ELSE ' ' END) AS ZA4_STATUS "
cQuery += "  ZA4_STATUS, ZA4_PRTUSE, ZA4_PRTHOR "
cQuery += " FROM " + RetSqlName("ZA4") + " " 
cQuery += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' "
cQuery += " AND ZA4_NUMOP = '" + _cNumOp + "' AND ZA4_COD = '" + _cCod + "' "
cQuery += " AND ZA4_NLOTE = '" + _cLote  + "' "
cQuery += " AND D_E_L_E_T_ != '*' "    
cQuery += " ORDER BY ZA4_NUMSER  "

If Select("TMPLOT") > 0
	TMPLOT->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TMPLOT")

TCSetField("TMPLOT","ZA4_DTIMP","D") 	

DbSelectArea("TMPLOT")

cArq := CriaTrab(NIL,.F.)
Copy To &cArq

dbUseArea(.T.,,cArq,"TRB3",.F.)

DbSelectArea("TRB3")
TRB3->(DBGotop())
While !TRB3->(EOF())
   If Empty( TRB3->ZA4_STATUS )
      TRB3->ZA3_OK := If(TRB3->ZA4_ETIQIM='Sim' , ' ', cMarca)
   Endif   
   TRB3->(DbSkip())
End
TRB3->(DBGotop())

AADD(mCampos, {"ZA3_OK"    , NIL ,"Imp"  })
AADD(mCampos, {"ZA4_NUMOP" , NIL ,"Nro.OP"})
AADD(mCampos, {"ZA4_NLOTE" , NIL ,"Lote"})
AADD(mCampos, {"ZA4_NCAIXA", NIL ,"Caixa"})
AADD(mCampos, {"ZA4_NUMSER", NIL ,"Serie"})
AADD(mCampos, {"ZA4_STATUS", NIL ,"Conf."})
AADD(mCampos, {"ZA4_DTIMP"	, NIL ,"Dt.Imp."})
AADD(mCampos, {"ZA4_PRTHOR", NIL ,"Hr.Imp."})
AADD(mCampos, {"ZA4_PRTUSE", NIL ,"Autor"})
AADD(mCampos, {"ZA4_DSCETQ", NIL ,"Descrição Etiqueta"})

//MarkBrow("TRB3","ZA4_OK",,mCampos,,_cMarca)
MARKBROW("TRB3","ZA3_OK",,mCampos,,cMarca,'U_MarkAll()',,,,'U_Mark()')

TMPLOT->(DbCloseArea())
TRB3->(DbCloseArea())

Ferase(cArq+".DBF")

DbSelectArea("TR2ZA4")
TR2ZA4->(dbgoto(nTR2Rec))

RestArea(_xAlias)
Return(.T.)

//************************************************************************************************************
// Função que permite ao usuario marca as etiquetas/series a imprimir
//************************************************************************************************************
// Responsavel: Carlos Alday Torres  | Criada em: 06/05/2010
//************************************************************************************************************
User Function EtqMarc()
	Processa({|| U_AtuMarca() },"Processando...")
Return NIL

//************************************************************************************************************
// Função que permite ao usuario marca as etiquetas/series a imprimir
//************************************************************************************************************
// Responsavel: Carlos Alday Torres  | Criada em: 06/05/2010
//************************************************************************************************************
User Function AtuMarca()
Local _nRecnoStop  := TRB3->(recno())
Local nSolicitados := 0
//
// Totaliza itens marcados e nao marcados
//
DbSelectArea("TRB3")
ProcRegua(RecCount()) // Numero de registros a processar
TRB3->(DBGotop())
While !TRB3->(EOF())
   IncProc()
   //If Empty(TRB3->ZA4_STATUS)
      If !empty(TRB3->ZA3_OK)
         nSolicitados ++
         cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_ETIQSL = 1 "
      Else
         cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_ETIQSL = 0 "
      Endif
      cUpdate += " WHERE ZA4_NUMOP = '" + TRB3->ZA4_NUMOP + "' AND D_E_L_E_T_ != '*'"
		cUpdate += " 	AND ZA4_FILIAL = '" + xFilial("ZA4") + "' "
      cUpdate += "   AND ZA4_NLOTE = '" + Alltrim(TRB3->ZA4_NLOTE) + "' "
      cUpdate += "   AND ZA4_COD = '" + Alltrim(TRB3->ZA4_COD) + "' "
      cUpdate += "   AND ZA4_NUMSER = '" +Alltrim(TRB3->ZA4_NUMSER)+ "' "
      TCSqlExec(cUpdate)
   //Endif
   TRB3->(DbSkip())
End
TRB3->(DBGotop())


DbSelectArea("TR2ZA4")
_nTrb2Rec := TR2ZA4->(recno())
DbGotop()
Do While !TR2ZA4->(Eof())
   If TRB3->ZA4_NLOTE=TR2ZA4->ZA4_NLOTE .AND. TRB3->ZA4_COD=TR2ZA4->ZA4_COD .AND. TRB3->ZA4_NUMOP=TR2ZA4->ZA4_NUMOP
      TR2ZA4->ZA4_ETIQSL := nSolicitados
   Endif
   TR2ZA4->(DbSkip())
End                  
TR2ZA4->(DBGoto( _nTrb2Rec ))

DbSelectArea("TRB3")
TRB3->(DBGoto( _nRecnoStop ))
Return(.T.)


//
// Função marca/desmarca individual
//
User Function Mark()
If IsMark('ZA3_OK',cMarca)
   RecLock('TRB3',.F.)
   Replace ZA3_OK With Space(2)
   MsUnLock()
Else
   RecLock('TRB3',.F.)
   Replace ZA3_OK With cMarca 
   MsUnLock()
EndIf
Return

//
// Função marca/desmarca todos
//
User Function MarkTodos()
Local nRecno:=Recno()
dbSelectArea('TRB3')
ProcRegua(RecCount()) // Numero de registros a processar
dbGotop()
While !Eof()
  IncProc()
  u_Mark()
  dbSkip()
End
dbGoto(nRecno)
Return        

//
// Função de progresso marcadora de registros
//
User Function MarkAll()
 Processa({|| U_MarkTodos() },"Processando...")
Return NIL

//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
// Função para refazer os numeros de lote
//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
User Function RefazLote()
//Local cLote			:= ""
Local aParamBox	:= {}
Local aRet			:= {}
//Local	cNumOP		:= ""
//Local	cCod			:= ""
//Local	_cLote		:= ""
//Local	nQtdeCx		:= 0
//Local	nStop 		:= 0
//Local _dDtFab
//Local	lUmLog 		:= .T.

Private cCadastro := "Alteração de lote"
Private cString := ""

Aadd(aParamBox,{1,"Lote Inicial"	,Space(06),"","","","",50,.T.})
Aadd(aParamBox,{1,"Caixa"	,Space(06),"","","","",50,.F.})
Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

If !empty( aRet[1] ) .and. aRet[3]="LOTE00"

	_nElementos:= TR2ZA4->(reccount())

	Processa({|| U_Za4RLote( Alltrim(aRet[1]) , Alltrim(aRet[2]), _nElementos ) },"Processando...")

EndIf	
Return NIL


User Function Za4RLote( __cParam1, __cParam2, _nElementos )
cLote	:= __cParam1
cCaixa:= __cParam2 
cLotData	:= dtos(Date())
//
// Update para marcar lotes a serem alterados
//
cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_TOLEDO= '"+cLotData+"' + 'L' + ZA4_NLOTE "
cUpdate += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' AND D_E_L_E_T_ != '*'"
cUpdate += "   AND ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "' "
cUpdate += "   AND ZA4_NLOTE >= '" +Alltrim(TR2ZA4->ZA4_NLOTE)+ "' "
cUpdate += "   AND RIGHT(ZA4_DTFAB,4)= '" +Substr(TR2ZA4->ZA4_DTFAB,7,4)+"' "
TCSqlExec(cUpdate)

DbSelectArea("TR2ZA4")
ProcRegua(_nElementos) // Numero de registros a processar
nStop := TR2ZA4->(recno())
While !TR2ZA4->(Eof())
	IncProc()

	cNumOP	:= TR2ZA4->ZA4_NUMOP
	cCod		:= TR2ZA4->ZA4_COD
	_cLote	:= TR2ZA4->ZA4_NLOTE
	_dDtFab 	:= TR2ZA4->ZA4_DTFAB
	nQtdeCx	:= 1
	cChaveLot:= cLotData + "L" + Alltrim(TR2ZA4->ZA4_NLOTE) 

   TR2ZA4->ZA4_NLOTE := cLote
   
	lUmLog := .T.
	DbSelectArea("ZA4")
	ZA4->(DbSetOrder(2))
	ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
	While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_NUMOP = cNumOP .AND. ZA4->ZA4_COD = cCod .AND. !ZA4->(EOF())
	   If ZA4->ZA4_TOLEDO=cChaveLot .AND. ZA4->ZA4_DTFAB = _dDtFab // .AND. Empty(ZA4->ZA4_SERIAL) // .AND. Empty( ZA4->ZA4_CXLOTE )

		   RecLock('ZA4',.F.)
		   ZA4->ZA4_CXLOTE := ZA4->ZA4_NLOTE
		   ZA4->ZA4_NLOTE := cLote
			If	!empty( __cParam2 )		   
				ZA4->ZA4_NCAIXA	:= cCaixa
				If nQtdeCx = 6
					cCaixa  := Soma1(cCaixa)
					nQtdeCx := 0
				EndIf
	         nQtdeCx++
         Endif

		   ZA4->(MsUnLock())
			If lUmLog
				//Regra:   Tabela  Campo        vl Antes         vl Apos         Chave de pesquisa   registro         inclusao
				U_Za4GrvLog( "ZA4",  "ZA4_NLOTE", ZA4->ZA4_CXLOTE, ZA4->ZA4_NLOTE, ZA4->ZA4_COD      , ZA4->(RECNO()) , "I","RACD002")
				lUmLog := .F.
	      EndIf
	   EndIf		
		ZA4->(DbSkip())
	End
	DbSelectArea("TR2ZA4")
	cLote := Strzero( Val(cLote) + 1 , Len(Alltrim(__cParam1)) )
	TR2ZA4->(DbSkip())		
End	

DbSelectArea("TR2ZA4")
DbGoto( nStop )
//
// Update para DESMARCAR lotes alterados, e que deverão ser transmitidos para toledo
//
cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_TOLEDO= '' "
cUpdate += " WHERE ZA4_FILIAL = '" + xFilial("ZA4") + "' AND D_E_L_E_T_ != '*'"
cUpdate += "   AND ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "' "
cUpdate += "   AND LEFT(ZA4_TOLEDO,9)= '"+cLotData+"' + 'L' "
cUpdate += "   AND RIGHT(ZA4_DTFAB,4)= '" +Substr(TR2ZA4->ZA4_DTFAB,7,4)+"' "
TCSqlExec(cUpdate)

Return NIL


//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função para refazer os numeros de serie
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function RefazSerie()
Local aParamBox	:= {}
Local aRet			:= {}
Local _nElementos	:= 0

Private cCadastro := "Alteração da sequencia do serial"
Private cString := ""

Aadd(aParamBox,{1,"Serie Inicial"	,Space(06),"","","","",50,.T.})
Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

If !empty( aRet[1] ) .and. aRet[2]="SERIE0"
                          
	_cSerie := Alltrim(aRet[1])
	DbSelectArea("TR2ZA4")
	_nElementos:= TR2ZA4->(reccount())
	Processa({|| U_Serial( _cSerie , _nElementos ) },"Processando...")

EndIf	
Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função que executa a readequaçao dos numeros de serie
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function Serial( _cExSerie, _nElementos )
//Local cLote			:= ""
Local nCaixa		:= 0
Local nStop			:= 0
Local cNumOp		:= ""
Local	cCod			:= ""
Local	_cLote		:= ""
Local	nQtdeCx		:= 0
Local cBarraSerial:= ""
Local _cSerie		:= _cExSerie
Local	_cLteSerial	:= ""
Local	_lLteSerial	:= .T.
Local _dDtFab

nStop := TR2ZA4->(recno())

ProcRegua(_nElementos) 

While !TR2ZA4->(Eof())

	IncProc()
	cNumOP	:= TR2ZA4->ZA4_NUMOP
	cCod		:= TR2ZA4->ZA4_COD
	_cLote	:= TR2ZA4->ZA4_NLOTE
	_dDtFab	:=	TR2ZA4->ZA4_DTFAB
	nQtdeCx	:= 1
	nCaixa	:= 1
	
	_cLteSerial	:= ""
	_lLteSerial	:= .T.

	lUmLog 		:= .T.
	
	DbSelectArea("ZA4")
	ZA4->(DbSetOrder(3))
	ZA4->(DbSeek(xFilial("ZA4") + cCod + _cLote ))
	
	While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_COD = cCod .AND. ZA4->ZA4_NLOTE = _cLote .AND. !ZA4->(EOF())
		If cNumOP = ZA4->ZA4_NUMOP  .and.  ZA4->ZA4_DTFAB = _dDtFab
		   If Empty( Alltrim(ZA4->ZA4_SERIAL) )
	         _cSerial	:= Left( Alltrim(ZA4->ZA4_NUMSER) , Len(Alltrim(ZA4->ZA4_NUMSER)) - 6 ) + _cSerie
			Else   
	         _cSerial	:= Left( Alltrim(ZA4->ZA4_SERIAL) , Len(Alltrim(ZA4->ZA4_SERIAL)) - 6 ) + _cSerie
	      Endif
	      
	      If nCaixa = 1
	      	cBarraSerial := Right( _cSerial ,6 )
	      Endif	
	
	      If _lLteSerial
				_cLteSerial	:= Right( _cSerial ,6 )	      
				_lLteSerial := .F.
	      Endif
	      
			nCaixa += 1 
			
			If nCaixa > 6
				nCaixa	:= 1
			EndIf	
			
			If Empty(ZA4->ZA4_DTIMP)
				_cBarra := Left( ZA4->ZA4_BARRA, 9 ) 
	         _cBarra += Strzero(Day(dDataBase),2)
				_cBarra += Strzero(Month(dDataBase),2) 
				_cBarra += Right(Strzero(Year(dDataBase),4),2)
				_cBarra += Alltrim(ZA4->ZA4_NLOTE)
	         _cBarra += Alltrim(ZA4->ZA4_NCAIXA)
	         _cBarra += cBarraSerial
			Else
				_cBarra := Left( ZA4->ZA4_BARRA, 9 ) 
	         _cBarra += Strzero(Day(ZA4->ZA4_DTIMP),2)
				_cBarra += Strzero(Month(ZA4->ZA4_DTIMP),2) 
				_cBarra += Right(Strzero(Year(ZA4->ZA4_DTIMP),4),2)
				_cBarra += Alltrim(ZA4->ZA4_NLOTE)
	         _cBarra += Alltrim(ZA4->ZA4_NCAIXA)
	         _cBarra += cBarraSerial
			Endif
	      
			cSerieAntes	:=	ZA4->ZA4_NUMSER
		   RecLock('ZA4',.F.)
		   If Empty( Alltrim(ZA4->ZA4_SERIAL) )
	         //_cSerial        := Left( Alltrim(ZA4->ZA4_NUMSER) , Len(Alltrim(ZA4->ZA4_NUMSER)) - 6 ) + _cSerie
				ZA4->ZA4_NUMSER := _cSerial
			Else   
	         //_cSerial        := Left( Alltrim(ZA4->ZA4_SERIAL) , Len(Alltrim(ZA4->ZA4_SERIAL)) - 6 ) + _cSerie
				ZA4->ZA4_SERIAL := _cSerial
				ZA4->ZA4_NUMSER := _cSerial
	      Endif
			ZA4->ZA4_BARRA	:= _cBarra
		   ZA4->(MsUnLock())	
			If lUmLog
				//Regra:   Tabela  Campo         vl Antes     vl Apos         Chave de pesquisa   registro          inclusao
				U_Za4GrvLog( "ZA4",  "ZA4_NUMSER", cSerieAntes, ZA4->ZA4_NUMSER, ZA4->ZA4_COD      , ZA4->(RECNO()) , "I","RACD002")
				lUmLog := .F.
	      EndIf
		   
			_cMaxSerial	:= ZA4->ZA4_NUMSER
			_cMaxLote	:= ZA4->ZA4_NLOTE
			_cMaxCaixa	:= ZA4->ZA4_NCAIXA
			
			_cSerie		:= Strzero( Val(_cSerie) + 1 , 6 )
		EndIf		
		ZA4->(DbSkip())
	End
	DbSelectArea("TR2ZA4")
	
	TR2ZA4->NM_SERIAL	:= _cLteSerial
	
	TR2ZA4->(DbSkip())		
End	
DbSelectArea("TR2ZA4")
DbGoto( nStop )
Return NIL


        
//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função para gerar a tabela ZA4 conforme numero do OP
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function GeraZA4()
//Local cLote			:= ""
Local aParamBox	:= {}
Local aRet			:= {}
Local __xAlias		:= GetArea()

Private cCadastro := "Gera tabela ZA4 da OP firmada"
Private cString := ""

Aadd(aParamBox,{1,"OP + item + seq Firmada"	,Space(11),"","","","",50,.T.})
Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

If !empty( aRet[1] ) .and. aRet[2]="ZA4000"
	DbSelectArea("SC2")
	DbSetOrder(1)
	If SC2->(DbSeek( xFilial("SC2") + aRet[1] ))
		If SC2->C2_TPOP='F'
			U_MA651GRV()
		EndIf
	EndIf
EndIf	
RestArea( __xAlias )

Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função para gerar a tabela ZA4 conforme OP firmada que nao estavam cadastrados na tabela 
// de complemento de produtos
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function FullZA4()
//Local cLote			:= ""
Local aParamBox	:= {}
Local aRet			:= {}
Local __xAlias		:= GetArea()

Private cCadastro := "Gera dados em ZA4 para OP firmada"
Private cString := ""

Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

If !empty( aRet[1] ) .and. aRet[2]="ZA4000"
	DbSelectArea("SC2")
	DbSetOrder(1)
	While !SC2->(Eof())
		If SC2->C2_TPOP='F' .and. SC2->CD_EMISSAO > Ctod("11/08/2010")
			//U_MA651GRV()
		EndIf
		SC2->(DbSkip())
	End		
EndIf	
RestArea( __xAlias )
Return NIL
 
//	//
//	//--------------------------------------------------------------------------------------------------------------
//	//--------------------------------------------------------------------------------------------------------------
//	// Função para refazer os numeros de serie
//	//--------------------------------------------------------------------------------------------------------------
//	//--------------------------------------------------------------------------------------------------------------
//	//
//	User Function RefazBarra()
//	Local cLote			:= ""
//	Local aParamBox	:= {}
//	Local aRet			:= {}
//	
//	Private cCadastro := "Alteração da sequencia do BARRA"
//	Private cString := ""
//	
//	Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})
//	
//	IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
//		Return(.F.)
//	Endif
//	
//	If aRet[1]="SERIE0"
//		
//		nPos	:= 1
//	
//		DbSelectArea("TR2ZA4")
//		nStop := TR2ZA4->(recno())
//		While !TR2ZA4->(Eof())
//	
//			cNumOP	:= TR2ZA4->ZA4_NUMOP
//			cCod		:= TR2ZA4->ZA4_COD
//			_cLote	:= TR2ZA4->ZA4_NLOTE
//			
//		
//			nQtdeCx	:= 1
//		   
//			DbSelectArea("ZA4")
//			ZA4->(DbSetOrder(2))
//			ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
//			While ZA4->ZA4_NUMOP = cNumOP .AND. ZA4->ZA4_COD = cCod .AND. !ZA4->(EOF())
//			   If ZA4->ZA4_NLOTE = _cLote
//			   	If nPos = 1
//			   		cBarra:= Right( Alltrim(ZA4->ZA4_NUMSER) ,6 )
//						nPos	:= 2
//					Endif
//	
//	            If Empty(ZA4->ZA4_DTIMP)
//						_cBarra := Left( ZA4->ZA4_BARRA, 9 ) 
//			         _cBarra += Strzero(Day(dDataBase),2)
//		   	      _cBarra += Strzero(Month(dDataBase),2) 
//	  	      	   _cBarra += Right(Strzero(Year(dDataBase),4),2)
//		         	_cBarra += Alltrim(ZA4->ZA4_NLOTE)
//			         _cBarra += Alltrim(ZA4->ZA4_NCAIXA)
//			         _cBarra += cBarra
//					Else
//						_cBarra := Left( ZA4->ZA4_BARRA, 9 ) 
//			         _cBarra += Strzero(Day(ZA4->ZA4_DTIMP),2)
//		   	      _cBarra += Strzero(Month(ZA4->ZA4_DTIMP),2) 
//	  	      	   _cBarra += Right(Strzero(Year(ZA4->ZA4_DTIMP),4),2)
//		         	_cBarra += Alltrim(ZA4->ZA4_NLOTE)
//			         _cBarra += Alltrim(ZA4->ZA4_NCAIXA)
//			         _cBarra += cBarra
//					Endif
//				
//					ZA4->(RecLock("ZA4",.f.))
//					ZA4->ZA4_BARRA	:= _cBarra
//					ZA4->(MsUnlock())	
//	
//					If nQtdeCx = 6
//						cBarra   := Right( Alltrim(ZA4->ZA4_NUMSER) ,6 )
//						nQtdeCx := 0
//					EndIf
//		         nQtdeCx++
//			      
//			   EndIf		
//				ZA4->(DbSkip())
//				If nQtdeCx = 1
//					cBarra   := Right( Alltrim(ZA4->ZA4_NUMSER) ,6 )
//				EndIf
//			End
//			DbSelectArea("TR2ZA4")
//			TR2ZA4->(DbSkip())		
//		End	
//		
//		DbSelectArea("TR2ZA4")
//		DbGoto( nStop )
//	EndIf	
//	Return NIL
	

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função para atualizar na tabela SB1 o numero de serie do item selecionado no browse
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function AtuBase()
//Local cLote			:= ""
Local aParamBox	:= {}
Local aRet			:= {}
Local aCombo		:= {"Atualiza somente item selecionado","Atualiza todos os produtos"}
Local	cTipoAtualiz:= 'UNICO'
Local c__LoteAnt 
Local c__SerieAnt

Private cCadastro := "Atualiza serial na tabela SB1 do item selecionado"
Private cString := ""

AADD(aParamBox,{2,"Tipo de atualização"		,1,aCombo,70,"",.F.})
Aadd(aParamBox,{8,"Senha acesso"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif
If ValType(aRet[1]) == "C"
	If aRet[1]='Atualiza somente item selecionado'
		cTipoAtualiz := 'UNICO'
	ElseIf aRet[1]='Atualiza todos os produtos'
		cTipoAtualiz := 'TODOS'
	Endif
ElseIf ValType(aRet[1]) == "N"
	If aRet[1]=1
		cTipoAtualiz := 'UNICO'
	ElseIf aRet[1]=2
		cTipoAtualiz := 'TODOS'
	Endif
EndIf

If aRet[2]="PRO001" .AND. cTipoAtualiz = 'UNICO'

	cNumOP	:= TR2ZA4->ZA4_NUMOP
	cCod		:= TR2ZA4->ZA4_COD
	_cLote	:= TR2ZA4->ZA4_NLOTE
	_dDtFab	:=	TR2ZA4->ZA4_DTFAB
	_cCaixa	:= ""
	_cSerial	:= ""
		
	DbSelectArea("ZA4")
	ZA4->(DbSetOrder(2))
	ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
	While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_NUMOP = cNumOP .AND. ZA4->ZA4_COD = cCod .AND. !ZA4->(EOF())
	   If ZA4->ZA4_NLOTE = _cLote .AND. ZA4->ZA4_DTFAB = _dDtFab
			_cCaixa	:= ZA4->ZA4_NCAIXA
			If Empty(ZA4->ZA4_SERIAL)
				_cSerial	:= ZA4->ZA4_NUMSER
			Else
				_cSerial	:= ZA4->ZA4_SERIAL
			Endif
	   EndIf		
		ZA4->(DbSkip())
	End
	DbSelectArea("TR2ZA4")
	If !empty( _cCaixa )
		c__LoteAnt	:=	SB1->B1_LOTECTL
		c__SerieAnt	:=	SB1->B1_SERIE	
	   SB1->(dbseek(  xFilial('SB1') + TR2ZA4->ZA4_COD  ))
		RecLock("SB1",.F.)
		SB1->B1_LOTECTL:= _cLote
		SB1->B1_CAIXA	:= _cCaixa
	   SB1->b1_serie	:= _cSerial
		SB1->(MsUnlock())
		//Regra:   Tabela  Campo           vl Antes     vl Apos         Chave de pesquisa   registro         inclusao
		U_Za4GrvLog( "SB1",  "B1_LOTECTL"	, c__LoteAnt , SB1->B1_LOTECTL, TR2ZA4->ZA4_COD    , SB1->(RECNO()) , "I" ,"RACD002")
		U_Za4GrvLog( "SB1",  "B1_SERIE"		, c__SerieAnt, SB1->B1_SERIE	, TR2ZA4->ZA4_COD    , SB1->(RECNO()) , "I" ,"RACD002")

		MessageBox("Serial atualizado com sucesso na tabela SB1","Serial do produto",0)
	Else
		MsgAlert("Serial não atualizado na tabela de produtos","Serial do produto")
	Endif	
ElseIf aRet[2]="PRO001" .AND. cTipoAtualiz = 'TODOS'

	Processa({|| U_FullSB1() },"Processando...")

EndIf	
Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Função para atualizar na tabela SB1 o numero de serie de todos os itens da tabela ZA4 gerados em agosto.
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function FullSB1()

_cQuery := "UPDATE " + RetSqlName("SB1") + " " 
		
TCSQLExec( _cQuery )    

DbSelectArea("ZA4")
nStop := TR2ZA4->(recno())

ProcRegua(RecCount()) // Numero de registros a processar

While !TR2ZA4->(Eof())

	IncProc()
End
		
Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Impressao individual da etiqueta de despacho
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function ImpDespa(nTPETQDES)
Local cNumOP	:= TR2ZA4->ZA4_NUMOP
Local cCod		:= TR2ZA4->ZA4_COD
Local _cLote	:= TR2ZA4->ZA4_NLOTE
Local cLote		:= TR2ZA4->ZA4_NLOTE
Local cPrima	:= .T.
Local cIniSerie:= "" 
Local cFinSerie:= ""
Local __lPallet:=.F.
Local cPathEtiq 	:= Alltrim(GetMV("MV_PATHETIQ",,"C:\Etiquetas_Protheus\"))
Local cArqTxtPLT	:= "ETIQ_PLT.TXT"
LOCAL APARAMB		:= {}
LOCAL ARESP		:= {}
LOCAL CTITULO		:= "RECURSO"
LOCAL CRECURSO	:= ""
LOCAL COPCOMP		:= TR2ZA4->ZA4_NUMOP + TR2ZA4->ZA4_OPITEM + TR2ZA4->ZA4_OPSEQ
//LOCAL __2cCodBarra:= ""
//LOCAL __2cEAN14	:= ""
LOCAL CCXINICIAL:= ""
LOCAL CCXFINAL 	:= ""
LOCAL NQTDITENS	:= 0

LOCAL CZA4LOTECTL	:= ""

Private cCadastro := "Etiqueta de Despacho"
Private cString := ""

        
SB1->(DbSeek(xFilial("SB1")+cCod))
NRECNOSB1 := SB1->(RECNO())
cSKUCOD:= SB1->B1_COD
If SB1->(FIELDPOS( "B1_PRCOM" )) > 0
	IF .NOT. EMPTY(SB1->B1_PRCOM)
		cSKUCOD:= SB1->B1_PRCOM
		SB1->(DbSeek(xFilial("SB1")+cSKUCOD))
	ENDIF
EndIf
NQTDITENS	:= 0
DbSelectArea("ZA4")
ZA4->(DbSetOrder(2))
ZA4->(DbSeek(xFilial("ZA4")+cNumOP+cCod))
While xFilial("ZA4")=ZA4->ZA4_FILIAL .AND. ZA4->ZA4_NUMOP = cNumOP .AND. ZA4->ZA4_COD = cCod .AND. !ZA4->(EOF())
   If ZA4->ZA4_NLOTE = _cLote
   		NQTDITENS ++
   		CZA4LOTECTL := ZA4->ZA4_LOTECT 
	   If cPrima	
		   CCXINICIAL:= ZA4->ZA4_NCAIXA
		   cPrima	:= .F.
			If Empty(ZA4->ZA4_SERIAL)
				cIniSerie	:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_NUMSER")))) ,6) //ZA4->ZA4_NUMSER
			Else
				cIniSerie	:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_NUMSER")))) ,6) //ZA4->ZA4_SERIAL
			Endif
		Endif
		
		If Empty(ZA4->ZA4_SERIAL)
			cFinSerie	:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_NUMSER")))) ,6) // ZA4->ZA4_NUMSER
		Else
			cFinSerie	:= Right( Alltrim(ZA4->(FieldGet(FieldPos("ZA4_NUMSER")))) ,6) // ZA4->ZA4_SERIAL
		Endif
		CCXFINAL 	:= ZA4->ZA4_NCAIXA
   EndIf		
	ZA4->(DbSkip())
End
DbSelectArea("TR2ZA4")

cCodBarra	:= '2' + Left(SB1->B1_CODBAR,12)
cEAN14		:= cCodBarra + CBDigVer(cCodBarra)


CRECURSO := TR2ZA4->C2RECURSO
If EMPTY(TR2ZA4->C2RECURSO)
	AADD(APARAMB,{1,"Infome Célula produtiva: ",SPACE(006),"@!",,"SH1",,6,.T.})
	IF !PARAMBOX(APARAMB,@CTITULO,@ARESP)
		
		MESSAGEBOX("Operação Cancelada pelo usuário!","ATENÇÃO",48)
		RETURN NIL
		
	ENDIF 
	CRECURSO := ALLTRIM(ARESP[1])
EndIf
__lPallet:=.T.
IF __lPallet
	cCabec := ""
	cNmCpo	:= "CODIGO"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "DESCRICAO_1"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "DESCRICAO_2"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "LOTE"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "2EAN14"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "NUMOP"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "SERIE_I"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "SERIE_F"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "CELULA"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "CHAVE_OP"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "ID_PRODUCAO"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "LOTECTL"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "BD_PALLET"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "QT_PALLET"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "CX_INICIAL"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	cNmCpo	:= "CX_FINAL"
	cCabec	+= '"'+Alltrim(cNmCpo)+'",'
	
	cCabec := Left(cCabec,Len(cCabec)-1)+CRLF
	If File(cPathEtiq + cArqTxtPLT)
	   Ferase(cPathEtiq + cArqTxtPLT)
	Endif
	nHdlInd   := fCreate(cPathEtiq+cArqTxtPLT)
	fWrite(nHdlInd,cCabec,Len(cCabec))

	cLinha := ""

	cDado	 := SB1->(FieldGet(FieldPos("B1_COD")))	    
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := SUBS(SB1->(FieldGet(FieldPos("B1_DESC"))),01,27)	    
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := SUBS(SB1->(FieldGet(FieldPos("B1_DESC"))),28,27)	    
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := cLote
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := cEAN14
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := COPCOMP
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := cIniSerie
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := cFinSerie
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := CRECURSO
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := COPCOMP + SPAC(03) + "01" + CRECURSO + SPAC(01)
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := cCod
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := CZA4LOTECTL			          
	cLinha += '"'+Alltrim(cDado)+'",'

	//
	// linha para alimentar o codigo bidimensional "BD_PALLET" 
	//
	cDado	:= "<PL>"
	cDado	+= "<" + cEAN14 + ">"
	cDado	+= "<" + cSKUCOD + ">"
	cDado	+= "<" + CZA4LOTECTL	  + ">"
	cLinha 	+= '"'+Alltrim(cDado)+'",'
			          
	cDado	 := ALLTRIM(STR(NQTDITENS))		          
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := CCXINICIAL			          
	cLinha += '"'+Alltrim(cDado)+'",'
	cDado	 := CCXFINAL			          
	cLinha += '"'+Alltrim(cDado)+'",'

	cLinha := Left(cLinha,Len(cLinha)-1)+CRLF
	fWrite(nHdlInd,cLinha,Len(cLinha))

	fClose(nHdlInd)	
	
	MESSAGEBOX("Arquivo gerado com suscesso!","ATENÇÃO",64)

	SB1->(DbGoto(NRECNOSB1))
		
Else
	If CB5->CB5_LPT != "0"
		_cPorta := "LPT" + Alltrim( CB5->CB5_LPT )+":"
	Else
		_cPorta := "COM" + Alltrim( CB5->CB5_PORTA )
	Endif
	
	If CB5->CB5_LPT != "0"
		PrinterWin(.F.) 						// Impressao Dos/Windows
		PreparePrint(.F.,"",.F.,_cPorta) 		// Prepara a impressao na porta especIficada
		InitPrint(1)
	Else
		nHdll := 0
		MsOpenPort(nHdll,_cPorta + ":9600,n,8,1")
	EndIf
		       
	MSCBPRINTER(Alltrim(CB5->CB5_MODELO),_cPorta,,,.F.)
	MSCBCHKStatus(.f.) 
	MSCBBEGIN(1,6)
	MSCBBOX(05,01,100,91,5) // de 61 para 91
	MSCBLineH(05,07,100,5)
	MSCBSAY(07,03,'UNID.DE DESPACHO',"N","B","025,035")
	MSCBSAY(07,10,"CODIGO", "N", "0", "032,030")
	MSCBSAY(07,16,AllTrim(SB1->B1_COD), "N", "B", "030,022")
	MSCBSAY(07,24,"DESCRICAO","N","0","032,030")
	MSCBSAY(07,30,SUBS(SB1->B1_DESC,01,27),"N", "B", "030,022")
	MSCBSAY(07,36,SUBS(SB1->B1_DESC,28,27),"N", "B", "030,022")
	MSCBSAYBAR(20,44,cEAN14,"N","MB07",12,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)        
	MSCBSAY(55,71,"LOTE","N","0","032,030")
	MSCBSAYBAR(38,74,Alltrim(CZA4LOTECTL),"N","MB07",12,.F.,.T.,.F.,,3,2,.F.,.F.,"1",.T.)        
	                    
	cSubDetalhe := replicate("-",90)
	MSCBSAY(07,95,cSubDetalhe, "N", "0", "032,030")
	
	cSubDetalhe := "Codigo: " + AllTrim(SB1->B1_COD) + Space(5) + "Lote: " + Alltrim(cLote) + Space(5) + "OP: " + Alltrim(cNumOP)
	MSCBSAY(07,100,cSubDetalhe, "N", "0", "032,030")
	
	cSubDetalhe := "Descricao: " + Alltrim(SB1->B1_DESC)
	MSCBSAY(07,105,cSubDetalhe, "N", "0", "032,030")
	
	cSubDetalhe := "Serial Inicial: " + cIniSerie + spac(05) + "Serial Final: " + cFinSerie
	MSCBSAY(07,110,cSubDetalhe, "N", "0", "032,030")
	
	sConteudo:=MSCBEND()
	                        
	If CB5->CB5_LPT != "0"
		Ms_Flush()
	Else
		MsClosePort(nHdll)
		nHdll := 0
	Endif
	
EndIf

Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Informar o destino das etiquetas, como por exemplo se vai para produção Interna ou para fornecedor como MDC
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function DESTINO()

Local aParamBox	:= {}
Local aRet			:= {}
Local aCombo		:= {"Produção Externa","Produção Interna"}
Local	cDestino		:= ''

Private cCadastro := "Registra destino das etiquetas"
Private cString := ""

AADD(aParamBox,{2,"Destino da produção"	,1						,aCombo,70,"",.F.})
Aadd(aParamBox,{1,"Descrição do Destino"	,"MDC"+SPACE(12)	,"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif
If ValType(aRet[1]) == "C"
	If aRet[1]='Produção Externa'
		cDestino		:= aRet[2]
	ElseIf aRet[1]='Produção Interna'
		cDestino		:= 'PROD.INTERNA'
	Endif
ElseIf ValType(aRet[1]) == "N"
	If aRet[1]=1
		cDestino		:= aRet[2]
	ElseIf aRet[1]=2
		cDestino		:= 'PROD.INTERNA'
	Endif
EndIf

Processa({|| U_ATUDESTIN( cDestino ) },"Processando...")

Return NIL

//
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
// Atualizar o destino das etiquetas
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
User Function ATUDESTIN( cDestino )
Local	__cNumOP		:= ""
Local	__cCod		:= ""
Local	__cLote		:= ""

DbSelectArea("TRZA4")

nStop := TR2ZA4->(recno())

TR2ZA4->(DbGotop())
ProcRegua(RecCount()) // Numero de registros a processar

While !TR2ZA4->(Eof())
	IncProc()
	If !Empty(TR2ZA4->ZA4_OK) 
		TR2ZA4->ZA4_DESTIN	:= cDestino
		TR2ZA4->ZA4_OK		:= ""

		__cNumOP	:= TR2ZA4->ZA4_NUMOP
		__cCod	:= TR2ZA4->ZA4_COD
		__cLote	:= TR2ZA4->ZA4_NLOTE
		If !empty( TR2ZA4->ZA4_OPITEM )
			__cItemOp	:= TR2ZA4->ZA4_OPITEM
			__cSeqOp		:= TR2ZA4->ZA4_OPSEQ
		EndIf
		
		cUpdate := "UPDATE " + RetSqlName("ZA4") + " SET ZA4_DESTIN = '" + cDestino + "' "
		cUpdate += " WHERE ZA4_NUMOP = '" + __cNumOP + "' AND ZA4_COD = '" + Alltrim(__cCod) + "' "
		cUpdate += "   AND ZA4_NLOTE = '" + Alltrim(__cLote) + "' "
		cUpdate += "   AND ZA4_FILIAL= '" + xFilial("ZA4") + "' "
		cUpdate += "   AND D_E_L_E_T_ != '*'"
		If !empty( TR2ZA4->ZA4_OPITEM )
			cUpdate += "   AND ZA4_OPITEM = '" + Alltrim(__cItemOp) + "' "
			cUpdate += "   AND ZA4_OPSEQ = '" + Alltrim(__cSeqOp) + "' "
		EndIf
		TCSqlExec(cUpdate)      

   Endif
   TR2ZA4->(DbSkip())
End
TR2ZA4->(DbGoto(nStop))
Return NIL

//-----------------------------------------------------------------------------------------------------------
User Function PrevisaoIni()
//-----------------------------------------------------------------------------------------------------------
Local aParamBox	:= {}
Local aRet			:= {}

Private cCadastro := "Previsão de Inicio da Produção"
Private cString := ""

Aadd(aParamBox,{1,"Previsão Inicio"	,dOPFiltro ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"            Até"	,dOPAte	  ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

dOPFiltro	:= aRet[1]
dOPAte		:= aRet[2]
lPrimaVez	:= .T.

Return NIL

//-----------------------------------------------------------------------------------------------------------
// Rotina: Função Za4GrvLog()
// Descrição: Grava LOG na tabela ZA4 
//-----------------------------------------------------------------------------------------------------------
User Function Za4GrvLog( __cTabela, __cCampo, __cVlAntes, __cVlApos, __cID, __nPonteiro, __cTipoLock, __cRotina)
Local xAlias	 	:= GetArea()
/*                                                  
	//
	// rotina não ativa, as tabelas na foram criadas
	//
If __cTipoLock='I'
	RecLock('ZAI',.T.)
	ZAI->ZAI_FILIAL	:= xFilial('ZAI')
	ZAI->ZAI_TABELA	:= __cTabela
	ZAI->ZAI_AUTOR		:=	Alltrim(cUSERNAME)
	ZAI->ZAI_DATA		:= Date()
	ZAI->ZAI_HORA		:= Substr(Time(),1,2)+Substr(Time(),4,2)
	ZAI->ZAI_CAMPO		:= __cCampo
	ZAI->ZAI_VLANTE   := __cVlAntes
	ZAI->ZAI_VLAPOS	:= __cVlApos
	ZAI->ZAI_RECNO		:= __nPonteiro
	ZAI->ZAI_ID			:= __cID
	ZAI->ZAI_ORIGEM	:= "S"
	ZAI->ZAI_ROTINA	:= __cRotina
	ZAI->(DbUnlock())
ElseIf __cTipoLock='A'
	RecLock('ZAI',.F.)
	ZAI->ZAI_VLAPOS	:= __cVlApos
	ZAI->ZAI_ROTINA	:= __cRotina
	ZAI->(DbUnlock())
EndIf	
*/
RestArea(xAlias)
Return NIL

//-----------------------------------------------------------------------------------------------------------
// Rotina: Função Za4LogView()
// Descrição: Consulta LOG na tabela ZA4 
//-----------------------------------------------------------------------------------------------------------
User Function Za4VeLog(c__LgProduto)
//Local xAlias	:= GetArea()
//Local dOPFiltro	:= dDataBase - 100
Local xZa4Alias	:= TR2ZA4->(GetArea())
Local cAlias  := "ZAI"
//Local aCores  := {}
Local cFiltra := "ZAI_FILIAL == '"+xFilial('ZAI')+"' .And. ZAI_ROTINA = 'RACD002' .and. ZAI_ID= '"+Alltrim(c__LgProduto)+"'"

Private cCadastro	:= "Movimentos do Produto"
Private aRotina  	:= {}                
Private aIndexSA2	:= {}	
Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }


dbSelectArea(cAlias)                         

dbSetOrder(1)
Eval(bFiltraBrw)

AADD(aRotina,{"Pesquisar"		,"PesqBrw"			,0,1})

mBrowse(6,1,22,75,cAlias,,,,,,U_ZA4Legenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xZa4Alias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function ZA4Legenda(cAlias)

Local aLegenda := { 	{"BR_VERDE"		, 	"OP não paga" 		} }
Local uRetorno := .T.

uRetorno := {}

Aadd(uRetorno, { '.T.', aLegenda[1][1] } )

Return uRetorno


//-----------------------------------------------------------------------------------------------------------
// Função que cria os lotes e os seriais
//-----------------------------------------------------------------------------------------------------------
User Function CriaTfLotes()
Local _nQtdLotes	:= TR2ZA4->ZA4_ETIQSL
Local aParamBox	:= {}
Local aRet			:= {}
Local cMensPrm		:= ""
Local lRetorno 	:= .T.

Private cCadastro := "Impressão da OP selecionada"
Private cString := ""

Aadd(aParamBox,{1,"Qtd. de etiquetas a imprimir"	,_nQtdLotes,"@R 999,999","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

sb1->(dbseek(xFilial('SB1')+TR2ZA4->ZA4_COD))
sb5->(dbseek(xFilial('SB5')+TR2ZA4->ZA4_COD))

If Empty( SB1->B1_LETMAN ) 
	cMensPrm := " As iniciais (campo: Letra Manual) do produto não estão parametrizadas no cadastro do Produto. "
EndIf

If SB5->(Eof())
	cMensPrm += " O produto não está cadastrado em Complemento do Produto. "
Else
	If SB5->B5_QE1 = 0 .or. SB5->B5_QE2=0
		cMensPrm += " Não há parametros do PALLET (campo: Qtd. Embalagem) no cadastro Complemento do Produto. "
	Endif
EndIf

If !empty(cMensPrm)
	Aviso("Inconsistencia do Produto!" , cMensPrm,	{"Ok"}, 	3)
	lRetorno := .F.
Else
	Processa({|| U_NvoTfLot( aRet[1] ) },"Processando...")
EndIf

Return (lRetorno)

//-----------------------------------------------------------------------------------------------------------
// Função que cria os lotes e os seriais
//-----------------------------------------------------------------------------------------------------------
User Function NvoTfLot( _nQtdPrmLt )
Local __cProxLote := ""
Local __cProxSerie:= ""
Local __cProxCaixa:= ""
Local cQuery		:= ""
Local __cMarcador := ""
Local __cNumDaOP	:= ""
Local __cIteDaOP	:= ""
Local __cSeqDaOP	:= ""
Local __cDtFabOP	:= ""
Local __cSerieDoLt:= ""
//Local	lLtoGravado := .F.
Local __nA_Imprime:= 0
Local __nTrb2Recno:= 0
Local __aRet		:= {}
Local cBaseFilial	:= xFilial("ZA4")
//Local nESLAPRIMA 	:= 0
Local __cRecurso	:= "" 
local cOP_PRODUTO := ""
LOCAL NLOOP	:= 0

sb1->(dbseek(xFilial('SB1')+TR2ZA4->ZA4_COD))
NRECNOSB1 := SB1->(RECNO())
cSKUCOD := SB1->B1_COD
cOP_PRODUTO := SB1->B1_COD
If SB1->(FIELDPOS( "B1_PRCOM" )) > 0
	IF .NOT. EMPTY(SB1->B1_PRCOM)
		cSKUCOD:= SB1->B1_PRCOM
		SB1->(DbSeek(xFilial("SB1")+cSKUCOD))
	ENDIF
EndIf

IF cEmpAnt='01' .AND. cFilAnt='02'  // EMPRESA DESCONTINUADA
	cQuery := "SELECT COUNT(*) AS NCONTADOS FROM ZA4010 ZA4 "
	cQuery += "	WHERE ZA4.ZA4_FILIAL = '02' "
	cQuery += "	AND ZA4.D_E_L_E_T_!='*'     "
	cQuery += "	AND ZA4.ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "'"
	cQuery += "	AND RIGHT(ZA4.ZA4_DTFAB,4) = '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "'"
	cQuery += "	AND ZA4_NLOTE!=''"
	
	If Select("TMPULO") > 0
		TMPULO->(DbCloseArea())
	Endif
	
	TcQuery cQuery NEW ALIAS ("TMPULO")
	
	If TMPULO->NCONTADOS=0

		cQuery := "SELECT COUNT(*) AS NCONTADOS FROM ZA4010 ZA4 "
		cQuery += "	WHERE ZA4.ZA4_FILIAL = '01' "
		cQuery += "	AND ZA4.D_E_L_E_T_!='*' "
		cQuery += "	AND ZA4.ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "'"
		cQuery += "	AND RIGHT(ZA4.ZA4_DTFAB,4) = '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "'"
		cQuery += "	AND ZA4_NLOTE != ''"
	
		If Select("TMPULO") > 0
			TMPULO->(DbCloseArea())
		Endif
		
		TcQuery cQuery NEW ALIAS ("TMPULO")
		IF TMPULO->NCONTADOS>0
			cBaseFilial:='01'
		EndIf
	EndIf
	TMPULO->(DbCloseArea())
EndIf

//
// Busca a ultima serie do produto
//
cQuery := "SELECT MAX(SERIE_ZA4) AS SERIE_ZA4 "
cQuery += "FROM "
cQuery += "	( "
cQuery += "		SELECT RIGHT(RTRIM(ZA4_NUMSER),6) AS SERIE_ZA4 "
cQuery += "		FROM " + RetSqlName("ZA4") + " ZA4 " 
cQuery += "		WHERE ZA4.ZA4_FILIAL = '" + cBaseFilial + "' "
cQuery += "			AND ZA4.D_E_L_E_T_!='*' "
//cQuery += "			AND ZA4.ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "'"
cQuery += "			AND ZA4.ZA4_PRCOM = '" + Alltrim(cSKUCOD) + "'"
cQuery += "			AND RIGHT(ZA4.ZA4_DTFAB,4)= '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "'"
cQuery += "	) TMP "

If Select("TMPULO") > 0
	TMPULO->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TMPULO")

If TMPULO->(Eof()) .and. TMPULO->(Bof())
	__cProxSerie:= "000000"
Else
	If Empty(TMPULO->SERIE_ZA4)
		__cProxSerie:= "000000"
	Else
		__cProxSerie:= TMPULO->SERIE_ZA4
	EndIf
EndIf

//
// Busca a ultimo lote do produto
//
cQuery := "SELECT MAX(ZA4_NLOTE) AS LOTE_ZA4 "
cQuery += " FROM " + RetSqlName("ZA4") + " ZA4 " 
cQuery += " WHERE ZA4.ZA4_FILIAL = '" + cBaseFilial + "' "
cQuery += "  AND ZA4.D_E_L_E_T_!='*' "
//cQuery += "  AND ZA4.ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "'"
cQuery += "  AND ZA4.ZA4_PRCOM = '" + Alltrim(cSKUCOD) + "'"
cQuery += "  AND RIGHT(ZA4.ZA4_DTFAB,4)= '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "'"

If Select("TMPULO") > 0
	TMPULO->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TMPULO")

If TMPULO->(Eof()) .and. TMPULO->(Bof())
	__cProxLote:= "00000"
Else
	If Empty(TMPULO->LOTE_ZA4)
		__cProxLote:= "00000"
	Else
		__cProxLote:= TMPULO->LOTE_ZA4
	EndIf
EndIf


//
// Busca a ultima caixa do lote do produto
//
cQuery := "SELECT MAX(ZA4_NCAIXA) AS CAIXA_ZA4 "
cQuery += " FROM " + RetSqlName("ZA4") + " ZA4 " 
cQuery += " WHERE ZA4.ZA4_FILIAL = '" + cBaseFilial + "' "
cQuery += "  AND ZA4.D_E_L_E_T_!='*' "
//cQuery += "  AND ZA4.ZA4_COD = '" + Alltrim(TR2ZA4->ZA4_COD) + "'"
cQuery += "  AND ZA4.ZA4_PRCOM = '" + Alltrim(cSKUCOD) + "'"
cQuery += "  AND RIGHT(ZA4.ZA4_DTFAB,4)= '" + Substr(TR2ZA4->ZA4_DTFAB,7,4) + "'"
cQuery += "  AND ZA4.ZA4_NLOTE = '" + Alltrim(__cProxLote) + "'"


If Select("TMPULO") > 0
	TMPULO->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TMPULO")

If TMPULO->(Eof()) .and. TMPULO->(Bof())
	__cProxCaixa:= "000000"
Else
	If Empty(TMPULO->CAIXA_ZA4)
		__cProxCaixa:= "000000"
	Else
		__cProxCaixa:= TMPULO->CAIXA_ZA4
	EndIf
EndIf
TMPULO->(DbCloseArea())

nQtdFim	 := _nQtdPrmLt
__nA_Imprime:= _nQtdPrmLt


sb5->(dbseek(xFilial('SB5')+TR2ZA4->ZA4_COD))

nResto := 1
If 1=2 // sb1->B1_LM > 0
   nResto := nQtdFim/sb1->B1_LM
   If nResto - Int(nResto) > 0
      nResto := Int(nQtdFim/sb1->B1_LM) + 1
   Else   
      nResto := Int(nQtdFim/sb1->B1_LM) 
   Endif   
ElseIf !SB5->(Eof())
	If sb5->B5_QE2 > 0
	   nResto := nQtdFim/sb5->B5_QE2
   	If nResto - Int(nResto) > 0
	      nResto := Int(nQtdFim/sb5->B5_QE2) + 1
   	Else   
	      nResto := Int(nQtdFim/sb5->B5_QE2) 
   	Endif   
	Endif   	
Endif   

__cMarcador := TR2ZA4->ZA4_OK
__cNumDaOP	:= TR2ZA4->ZA4_NUMOP
__cIteDaOP	:= TR2ZA4->ZA4_OPITEM
__cSeqDaOP	:= TR2ZA4->ZA4_OPSEQ
__cDtFabOP	:= TR2ZA4->ZA4_DTFAB
__nQtdToOP	:= TR2ZA4->ZA4_ETIQSL
__cRecurso	:= TR2ZA4->C2RECURSO
TR2ZA4->(DbDelete()) 

ZA4->(DbSetOrder(2))

RecLock("SB1",.F.)
SB1->B1_LOTECTL	:= __cProxLote
SB1->B1_CAIXA		:= __cProxCaixa
SB1->(MsUnlock())

If TCSPExist("SP_ZA4_GERA_SERIAIS")
	__aRet := TCSPExec("SP_ZA4_GERA_SERIAIS",  __cNumDaOP , Alltrim(cOP_PRODUTO) , Substr(__cDtFabOP,7,4) , _nQtdPrmLt, cEmpAnt, cFilAnt, alltrim(cSKUCOD))
EndIf

cDataSeq := Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
cSerie   := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Replicate(__cProxSerie,6)

nContaEtq := nQtdFim

ProcRegua(nResto)

For nLoop := 1 to nResto

	IncProc()

	nProdCx	:= 0							// Quantidade Embalagem 1 - Checar campos EAN14 
	//
	// Se o produto exista na base produto complementar busca-se a informação na tabela SB5, 
	// caso contrario mante-se a solicitação
	//
	If !SB5->(Eof()) 
		If sb5->B5_QE2 > 0
			nQtdFim := sb5->B5_QE2
			If nContaEtq < sb5->B5_QE2
				nQtdFim := Abs(nContaEtq)
			Endif
		Endif
		If SB5->B5_QE1 > 0
			nProdCx	:= SB5->B5_QE1							// Quantidade Embalagem 1 - Checar campos EAN14 
		EndIf	
	EndIf    
   
	If nProdCx = 0  
		nProdCx := 6 // O padrão das caixas é com seis embalagens
	Endif
	
	nQtdeCx	:= 1
	cCaixa	:= Soma1(SB1->B1_CAIXA)
	cLote		:= Soma1(  Strzero( Val(SB1->B1_LOTECTL) ,5)  )
	nQtd		:= 1

	lFirst	:= .T.  
	__cSerieDoLt := ""
	
	While nQtd <= nQtdFim     

		If nQtdeCx > nProdCx
			cCaixa  := Soma1(cCaixa)
			nQtdeCx := 1
			lFirst	:= .T.  
		Endif

		nQtdeCx++

		cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
		cSerieCompl := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

		cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
		cSerie      := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

		If lFirst
			lFirst     := .F.
			cPrimSerie := Right(cSerie,6)
		Endif	

		If Empty(__cSerieDoLt)
			__cSerieDoLt := Right(cSerie,6)
		Endif
		cBarra		:= Alltrim(SB1->B1_COD)+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Right(Strzero(Year(dDataBase),4),2)+cLote+cCaixa+cPrimSerie

		nQtd++
      
		If .NOT. TCSPExist("SP_ZA4_GERA_SERIAIS")
			cUpdate := "UPDATE TOP(1) ZA4 "
			cUpdate += " SET "		
			cUpdate += "  ZA4_BARRA	= '" + cBarra      + "', "
			cUpdate += "  ZA4_NSERIE= '" + cSerieCompl + "', "
			cUpdate += "  ZA4_NUMSER= '" + cSerie      + "', "
			cUpdate += "  ZA4_NCAIXA= '" + cCaixa      + "', "
			cUpdate += "  ZA4_NLOTE	= '" + cLote       + "' "
			cUpdate += " FROM " + RetSqlName("ZA4") + " ZA4 " 		
			cUpdate += " WHERE ZA4.ZA4_FILIAL = '" + xFilial("ZA4") + "' "
			cUpdate += "   AND ZA4.ZA4_NUMOP = '" + __cNumDaOP + "'
			cUpdate += "   AND ZA4.ZA4_COD = '" + Alltrim(SB1->B1_COD) + "' "
			cUpdate += "   AND RIGHT(ZA4.ZA4_DTFAB,4)= '" + Substr(__cDtFabOP,7,4) + "'"
			cUpdate += "   AND ZA4.ZA4_NLOTE = '' "
			cUpdate += "   AND ZA4.D_E_L_E_T_ != '*'"
			TCSqlExec(cUpdate)      
		EndIf

	End

	TR2ZA4->(RecLock("TR2ZA4",.T.))
	TR2ZA4->ZA4_OK		:= __cMarcador
	TR2ZA4->ZA4_NUMOP   := __cNumDaOP
	TR2ZA4->ZA4_NLOTE	:= cLote
	TR2ZA4->NM_SERIAL	:= __cSerieDoLt
	TR2ZA4->ZA4_COD		:= cOP_PRODUTO
	TR2ZA4->ZA4_DSCETQ	:= SB1->B1_DESC    
	TR2ZA4->ZA4_ETIQIM	:= 0
	TR2ZA4->ZA4_ETIQSL	:= nQtdFim
	TR2ZA4->ZA4_DTFAB	:= __cDtFabOP
	TR2ZA4->ZA4_DESTIN	:= ""
	TR2ZA4->ETIQUETAS	:= nQtdFim
	TR2ZA4->ZA4_OPITEM	:= __cIteDaOP
	TR2ZA4->ZA4_OPSEQ	:= __cSeqDaOP
	TR2ZA4->C2RECURSO	:= __cRecurso 	

   If __nTrb2Recno=0
	   __nTrb2Recno := TR2ZA4->(Recno())
   Endif

	RecLock("SB1",.F.)
	SB1->B1_LOTECTL	:= cLote
	SB1->B1_CAIXA		:= cCaixa
   SB1->B1_SERIE		:= cSerie
	SB1->(MsUnlock())
	If !SB5->(Eof()) 
		If sb5->B5_QE2 > 0
			nContaEtq -= sb5->B5_QE2
		Endif			
	Endif
Next
If __nQtdToOP != 0 .and. (__nQtdToOP - __nA_Imprime) > 0
	TR2ZA4->(RecLock("TR2ZA4",.T.))
	TR2ZA4->ZA4_OK		:= ""
	TR2ZA4->ZA4_NUMOP	:= __cNumDaOP
	TR2ZA4->ZA4_NLOTE	:= ""
	TR2ZA4->NM_SERIAL	:= ""
	TR2ZA4->ZA4_COD	:= cOP_PRODUTO
	TR2ZA4->ZA4_DSCETQ:= SB1->B1_DESC    
	TR2ZA4->ZA4_ETIQIM:= 0
	TR2ZA4->ZA4_ETIQSL:= __nQtdToOP - __nA_Imprime
	TR2ZA4->ZA4_DTFAB	:= __cDtFabOP
	TR2ZA4->ZA4_DESTIN:= ""
	TR2ZA4->ETIQUETAS	:= __nQtdToOP - __nA_Imprime
	TR2ZA4->ZA4_OPITEM:= __cIteDaOP
	TR2ZA4->ZA4_OPSEQ	:= __cSeqDaOP
	TR2ZA4->C2RECURSO	:= __cRecurso 	
EndIf
If __nTrb2Recno !=0 
	TR2ZA4->(DbGoto( __nTrb2Recno ))
EndIf
SB1->(DBGOTO(NRECNOSB1))
Return NIL


/*
//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
User Function VisaoOP()
Local _oDlg
Local _oTPanel1

DEFINE MSDIALOG _oDlg TITLE "Informações da OP" FROM 0,0 TO 140,500 OF oMainWnd PIXEL

_oTPanel1 := TPanel():New(0,0,"",_oDlg,NIL,.T.,.F.,NIL,NIL,0,100,.T.,.F.)

_oTPanel1:Align := CONTROL_ALIGN_TOP
   
@  4, 006 SAY "Previsão Inicial: " SIZE 170,300 PIXEL OF _oTPanel1   
@  4, 080 SAY sc2->c2_datpri SIZE 170,300 PIXEL OF _oTPanel1   

@ 20, 006 SAY "Quantidade total da OP : " SIZE 170,300 PIXEL OF _oTPanel1
@ 20, 080 SAY Alltrim(Transform( sc2->c2_quant ,"@R 999,999,999")) SIZE 170,300 PIXEL OF _oTPanel1

@ 40, 120 BUTTON "Ok"  SIZE 020, 017 PIXEL OF _oDlg ACTION (nOpca := 1,_oDlg:End())

ACTIVATE MSDIALOG _oDlg CENTER

RETURN NIL
*/

Static Function VALIDPERG(cPerg)
//Local cKey := ""
//Local aHelpEng := {}
//Local aHelpPor := {}
//Local aHelpSpa := {}

Local aTfCombo		:= {"A imprimir  ","Já impressos","Todos os lotes    "}
/*
aAdd(aRet, dDataBase - 60)
aAdd(aRet, dDataBase + 30)

Aadd(aParamBox,{1,"Numero da OP Inicial"	,Space(TamSX3("C2_NUM")[1])	 	,PesqPict("SC2","C2_NUM")	 ,"","SC2","",50,.T.})
Aadd(aParamBox,{1,"Numero da OP Final"		,Space(TamSX3("C2_NUM")[1])	 	,PesqPict("SC2","C2_NUM")	 ,"","SC2","",50,.T.})
Aadd(aParamBox,{1,"Data da OP Inicial"		,Ctod("  /  /    ")             ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"Data da OP Final"		,Ctod("  /  /    ")             ,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"Produto inicial"			,Space(TamSX3("B1_COD")[1])	    ,PesqPict("SB1","B1_COD")    ,"","SB1","",50,.T.})
Aadd(aParamBox,{1,"Produto final"			,Space(TamSX3("B1_COD")[1])	    ,PesqPict("SB1","B1_COD")    ,"","SB1","",50,.T.})
Aadd(aParamBox,{1,"Local de impressão"		,Space(TamSX3("CB5_CODIGO")[1])	,PesqPict("CB5","CB5_CODIGO"),"","CB5","",50,.T.})
AADD(aParamBox,{2,"Tipo de impressao"		,1,aCombo,70,"",.F.})
*/
PutSx1(cPerg,"01","Numero da OP Inicial","","","mv_ch1","C",TamSX3("C2_NUM")[1]		,0,0, "G","","SC2","","","mv_par01",""		   	,"","","",""	       ,"","",""  	 	,"","","","","","","","","","","","")
PutSx1(cPerg,"02","Numero da OP Final"	,"","","mv_ch2","C",TamSX3("C2_NUM")[1]		,0,0, "G","","SC2","","","mv_par02",""        	,"","","",""        	,"","",""    	  	,"","","","","","","","","","","","")
PutSx1(cPerg,"03","Data da OP Inicial"	,"","","mv_ch3","D",08      					,0,0, "G","","" 	,"","","mv_par03",""		   	,"","","",""	       ,"","",""  	 	,"","","","","","","","","","","","")
PutSx1(cPerg,"04","Data da OP Final"	,"","","mv_ch4","D",08      					,0,0, "G","",""   ,"","","mv_par04",""        	,"","","",""        	,"","",""    	  	,"","","","","","","","","","","","")
PutSx1(cPerg,"05","Produto inicial"		,"","","mv_ch5","C",TamSX3("B1_COD")[1]		,0,0, "G","","SB1","","","mv_par05",""		   	,"","","",""	       ,"","",""    	  	,"","","","","","","","","","","","")
PutSx1(cPerg,"06","Produto final"		,"","","mv_ch6","C",TamSX3("B1_COD")[1]		,0,0, "G","","SB1","","","mv_par06",""		   	,"","","",""	       ,"","",""    	  	,"","","","","","","","","","","","")
PutSx1(cPerg,"07","Local de impressão"	,"","","mv_ch7","C",TamSX3("CB5_CODIGO")[1]	,0,0, "G","","CB5","","","mv_par07",""		   	,"","","",""			,"","",""			,"","","","","","","","","","","","")
PutSx1(cPerg,"08","Tipo de impressao"	,"","","mv_ch8","N",01      					,0,0, "C","","" 	,"","","mv_par08",aTfCombo[1],"","","",aTfCombo[2]	,"","",aTfCombo[3],"","","","","","","","","","","","")

Return

