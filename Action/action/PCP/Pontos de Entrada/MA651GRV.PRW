#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MA651GRV  ³ Autor ³ Robson Sanchez        ³ Data ³ 15/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Atualiza os arquivos envolvidos na Ordem de Producao       ³±±
±±³			 ³ Gravacao do AA3 (Base Instalada no Field Service)		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Mata651                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa ponto de entrada apos mudar tipo da OP           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function MA651GRV           
Local xAlias	 := GetArea()
Local nQtd   	 := 1
Local nQtdFim	 := Int(sc2->c2_quant)
//Local cCliPad	 := GetMv("MV_ATESTCL")   			// Parâmetro para utilizar o codigo do cliente padrão
//Local cLojPad	 := GetMv("MV_ATESTLJ")   			// Parâmetro para utilizar o codigo da loja padrão
Local cSerie	 := ""
//Local aProdEtiq  := {}
//Local lIntBarT 	 := GetMV("MV_INTBART",,.T.)		// Parametro Integra com Bar Tender
//Local cQuery     := ""
Local lFirst	 := .T. 
Local cPrimSerie := ""
Local nContaEtq  := 0
Local nResto     := 0
Local nLoop      := 0
Local _nTamCliente
Local _nTamLoja

LOCAL cSKUCOD :=""
LOCAL NRECNOSB1 := 0


sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
NRECNOSB1 := SB1->(RECNO())
cSKUCOD := SC2->C2_PRODUTO
If SB1->(FIELDPOS( "B1_PRCOM" )) > 0
	If .NOT. EMPTY(SB1->B1_PRCOM)
		cSKUCOD:= SB1->B1_PRCOM
		SB1->(DbSeek(xFilial("SB1")+cSKUCOD))
	EndIf
EndIf

sb5->(dbseek(xFilial('SB5')+SC2->C2_PRODUTO))

nResto := 1
If 1==2 // sb1->B1_LM > 0
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

nContaEtq := nQtdFim

For nLoop := 1 to nResto

	If Substr(sb1->b1_serie,3,2) == Right(Strzero(Year(dDataBase),4),2) // Checa Sequencial por Ano
		cSerie   := Alltrim(sb1->b1_serie)
	Else
		cDataSeq := Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
		cSerie   := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Replicate("0",6)
	Endif

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
   
	If nProdCx == 0  
		nProdCx := 6 // O padrão das caixas é com seis embalagens
	Endif
	
	cUnidDesp:= "1"									// Unidade de Despacho - Fixo 1 
	nQtdeCx	:= 1
	cCaixa	:= Soma1(SB1->B1_CAIXA)
	cLote		:= Soma1(  Strzero( Val(SB1->B1_LOTECTL) ,5)  )
	cCxLote	:= ""
	cCodBarra:= cUnidDesp + Left(SB1->B1_CODBAR,12)
	cEAN14	:= cCodBarra + CBDigVer(cCodBarra)
	nQtd		:= 1

	ProcRegua(nQtdFim)

	Begin Transaction

		lFirst	:= .T.  

		While nQtd <= nQtdFim
	
			IncProc()

			If nQtdeCx > nProdCx
				cCaixa  := Soma1(cCaixa)
				nQtdeCx := 1
				lFirst	:= .T.  
			Endif

	         nQtdeCx++

	         //     If Empty(cSerie)
	         //        cSerie := Soma1(sb1->b1_serie)
	         //     Else
	         //		  cSerie :=	Soma1(cSerie)
	         //     Endif
	         cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
	         cSerieCompl := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

	         cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
	         cSerie      := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Strzero(Val( Right(cSerie,6) ) + 1,6)

	         //cSerie	:=	Subs(cSerie,1,Len(cSerie)-6)  +  Strzero(Val( Right(cSerie,6) ) + 1),6)

	         If lFirst
         		lFirst     := .F.
         		cPrimSerie := Right(cSerie,6)
	         Endif	
            //-----------------------------------------------------------------------------------------------------------------
            // Identificação: DESENV001
            // Descrição....: As linhas da pesquisa na tabela SC5 (cabeçalho do pedido) foram comentadas já que o pedido pode 
            //                não existir ao firmar OP, e uma OP firmada visa atender todas as vendas.
            // Autor........: C. TORRES                                                                       Data: 28/02/2012
	         //SC5->(dbsetorder(1))
	         //CB9->(dbOrderNickName("CB9PRODSER"))
	         //CB9->(dbseek(xFilial('CB9')+SC2->C2_PRODUTO+cSerie))
	         //SC5->(dbseek(xFilial('SC5')+CB9->CB9_PEDIDO))
	         //--------------------------------------[ Termino do DESENV001 ]---------------------------------------------------

				aTam:=TamSX3('A1_COD')
				_nTamCliente := aTam[1]
				
				aTam:=TamSX3('A1_LOJA')
				_nTamLoja := aTam[1]
				
            //-----------------------------------------------------------------------------------------------------------------
            // Identificação: DESENV002
            // Descrição....: As linhas de tratamento da tabela AA3 foram comentadas devido a que não utilização do modulo 
            // Autor........: C. TORRES                                                        Data: 25/03/2014
            /*
	         AA3->(dbsetorder(6))
	         If .NOT. AA3->(dbseek( xFilial('AA3') + cSerie ))
					AA3->(RecLock("AA3",.T.))
					AA3->AA3_CODCLI := Substr( GetNewPar("TF_AA3CLIE","00211501") ,1,  _nTamCliente )  					// SC5->C5_CLIENTE // Conf. DESENV001
					AA3->AA3_LOJA   := Substr( GetNewPar("TF_AA3CLIE","00211501") , _nTamCliente + 1, _nTamLoja )	// SC5->C5_LOJACLI // Conf. DESENV001
					AA3->AA3_CODPRO := SC2->C2_PRODUTO
					AA3->AA3_NUMSER := cSerie
					AA3->AA3_DTVEND := ddatabase
					AA3->(MsUnlock())
				Endif
            ----------------------------------------[Fim DESENV002]------------------------------------------------------------
            */ 
	         cBarra		:= Alltrim(SB1->B1_COD)+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Right(Strzero(Year(dDataBase),4),2)+cLote+cCaixa+cPrimSerie

	         nQtd++
	
				If sb1->B1_TIPO == 'PA'            
				
					ZA4->(RecLock("ZA4",.T.))
		
					ZA4->ZA4_FILIAL  	:= xFilial('ZA4')
					ZA4->ZA4_COD		:=  SC2->C2_PRODUTO //SB1->B1_COD
		   	    	ZA4->ZA4_EAN13		:= SB1->B1_CODBAR
		     		ZA4->ZA4_EAN14		:= cEAN14
                    ZA4->ZA4_DSCETQ 	:= SB1->B1_DESC    
					ZA4->ZA4_DTFAB		:= DtoC( SC2->C2_DATPRF ) // DtoC(dDataBase)
			   		ZA4->ZA4_NCAIXA 	:= cCaixa
			   		ZA4->ZA4_USER		:= __CUSERID
		     		ZA4->ZA4_VOLTAG 	:= SB1->B1_VOLTAG
		     		ZA4->ZA4_CXLOTE 	:= cCxLote
			       	ZA4->ZA4_BARRA	   	:= cBarra
			       	ZA4->ZA4_ETIQSL  	:= 1
			       	ZA4->ZA4_APONTA		:= "N"
			       	ZA4->ZA4_NUMOP		:= SC2->C2_NUM
			       	ZA4->ZA4_OPITEM		:= SC2->C2_ITEM
			       	ZA4->ZA4_OPSEQ		:= SC2->C2_SEQUEN
			       	ZA4->ZA4_PRCOM		:= SB1->B1_COD
		       	//
		       	// Os campos serie e lote serão preenchidos na rotina de impressao de etiquetas
		       	//
		       	//Comentado em 23/03/2011 ZA4->ZA4_NSERIE	:= cSerieCompl
		       	//Comentado em 23/03/2011 ZA4->ZA4_NUMSER	:= cSerie
		   		//Comentado em 23/03/2011 ZA4->ZA4_NLOTE	:= cLote

               ZA4->(MsUnlock())
             Endif

		End

	End Transaction


	//
	// Os campos serie e lote serão preenchidos na rotina de impressao de etiquetas
	//
	//Comentado em 23/03/2011 
	/*/
	RecLock("SB1",.F.)
	SB1->B1_LOTECTL:= cLote
	SB1->B1_CAIXA	:= cCaixa
	SB1->(MsUnlock())

	If ! Empty(cSerie)
	   sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
	   sb1->(RecLock("SB1",.f.))
	   sb1->b1_serie := cSerie
	   sb1->(MsUnlock())
	
	   sc2->(RecLock("SC2",.f.))
	   sc2->c2_serie := cSerie
	   sc2->(MsUnlock())
   Endif
   /*/
	If !SB5->(Eof()) 
		If sb5->B5_QE2 > 0
			nContaEtq -= sb5->B5_QE2
		Endif			
	Endif
Next
SB1->(DBGOTO(NRECNOSB1))
RestArea(xAlias)

RETURN NIL

//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
/*
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
//
// Modulo desenvolvido pela ADV
// Comentado por: Carlos Alday
// Data.........: 02/07/2010
// Observacao...: Rotinas de calculo do numero de serie e lote estão criando codigos alfanumericos
//
Local nQtd   	:= 1
Local nQtdFim	:= Int(sc2->c2_quant)
Local cCliPad	:= GetMv("MV_ATESTCL")   			// Parâmetro para utilizar o codigo do cliente padrão
Local cLojPad	:= GetMv("MV_ATESTLJ")   			// Parâmetro para utilizar o codigo da loja padrão
Local cSerie	:= ""
Local aProdEtiq := {}
Local lIntBarT 	:= GetMV("MV_INTBART",,.T.)		// Parametro Integra com Bar Tender
Local cQuery
Local lFirst	:= .T. 
Local cPrimSerie := ""
Local xAlias	 := GetArea()

//cQuery := " DELETE FROM " + RetSqlName("ZA4") + " WHERE ZA4_USER = '" + __CUSERID + "'"
//cQuery := " DELETE FROM " + RetSqlName("ZA4") 
//TCSqlExec(cQuery)  

sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
sb5->(dbseek(xFilial('SB5')+SC2->C2_PRODUTO))

//
// Metodo de calculo da serie base Richard
//
If Substr(sb1->b1_serie,13,2) = Right(Strzero(Year(dDataBase),4),2) // Checa Sequencial por Ano
	cSerie 			:= Alltrim(sb1->b1_serie)
Else
	cSerie			:= Replicate("0",12)+Right(Strzero(Year(dDataBase),4),2)+Replicate("0",6)
Endif
//
// Metodo de calculo da serie reformulado para SIGLA do produto
//
If Substr(sb1->b1_serie,3,2) = Right(Strzero(Year(dDataBase),4),2) // Checa Sequencial por Ano
	cSerie 			:= Alltrim(sb1->b1_serie)
Else
	cDataSeq := Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
	cSerie   := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Replicate("0",6)
Endif


nProdCx		:= SB5->B5_QE1							// Quantidade Embalagem 1 - Checar campos EAN14 
cUnidDesp	:= "1"									// Unidade de Despacho - Fixo 1 - Verificar
nQtdeCx 	:= 1
cCaixa		:= Soma1(SB1->B1_CAIXA)
cLote		:= Soma1(SB1->B1_LOTECTL)
cCxLote		:= ""
cCodBarra	:= cUnidDesp + Left(SB1->B1_CODBAR,12)
cEAN14		:= cCodBarra + CBDigVer(cCodBarra)

ProcRegua(nQtdFim)

Begin Transaction

While nQtd <= nQtdFim
	
	IncProc()

	If nQtdeCx > nProdCx
		cCaixa := Soma1(cCaixa)
		nQtdeCx := 1
	Endif

	nQtdeCx++

	//     If Empty(cSerie)
	//        cSerie := Soma1(sb1->b1_serie)
	//     Else
	//		  cSerie :=	Soma1(cSerie)
	//     Endif

	cSerie	:=	Soma1(cSerie)

	If lFirst
		lFirst := .F.
		cPrimSerie := Right(cSerie,6)
	Endif	

	SC5->(dbsetorder(1))
	CB9->(dbOrderNickName("CB9PRODSER"))
	CB9->(dbseek(xFilial('CB9')+SC2->C2_PRODUTO+cSerie))
	SC5->(dbseek(xFilial('SC5')+CB9->CB9_PEDIDO))
	
	AA3->(RecLock("AA3",.T.))
	AA3->AA3_CODCLI := SC5->C5_CLIENTE
	AA3->AA3_LOJA   := SC5->C5_LOJACLI
	AA3->AA3_CODPRO := SC2->C2_PRODUTO
	AA3->AA3_NUMSER := cSerie
	AA3->AA3_DTVEND := ddatabase
	AA3->(MsUnlock())
	
	cDataSeq	:= Strzero(dDataBase - Ctod("31/12/"+Strzero(Year(dDataBase)-1,4)),3)
	cSerieCompl := SB1->B1_LETMAN + Right(strzero(Year(dDataBase),4),2) + cDataSeq + Right(cSerie,6)

	cBarra		:= Alltrim(SB1->B1_COD)+Strzero(Day(dDataBase),2)+Strzero(Month(dDataBase),2)+Right(Strzero(Year(dDataBase),4),2)+cLote+cCaixa+cPrimSerie

	nQtd++
	
	If lIntBarT
       If sb1->B1_TIPO = 'PE'
          ZA4->(RecLock("ZA4",.T.))
		
		  ZA4->ZA4_FILIAL	:= xFilial('ZA4')
		  ZA4->ZA4_COD	    := AA3->AA3_CODPRO
		  ZA4->ZA4_EAN13	:= SB1->B1_CODBAR
		  ZA4->ZA4_EAN14	:= cEAN14
		  ZA4->ZA4_NSERIE	:= cSerieCompl
          ZA4->ZA4_DSCETQ	:= SB1->B1_DESC    //ZA4->ZA4_DSCETQ	:= SB1->B1_DESCETI
		  ZA4->ZA4_DTFAB	:= DtoC(dDataBase)
		  ZA4->ZA4_NCAIXA	:= cCaixa
		  ZA4->ZA4_NLOTE	:= cLote
		  ZA4->ZA4_USER	    := __CUSERID
		  ZA4->ZA4_VOLTAG	:= SB1->B1_VOLTAG
		  ZA4->ZA4_CXLOTE	:= cCxLote
		  ZA4->ZA4_BARRA	:= cBarra
		  ZA4->ZA4_NUMOP    := SC2->C2_NUM
		  ZA4->ZA4_NUMSER   := cSerie
		  ZA4->ZA4_ETIQSL   := 1

          za4->(MsUnlock())
       Endif
//
//		aProdEtiq := {}
//		
//		Aadd(aProdEtiq,Array(13))
//		
//		aProdEtiq[Len(aProdEtiq),01] := xFilial("ZA4")				// za4_filial
//		aProdEtiq[Len(aProdEtiq),02] := AA3->AA3_CODPRO			// za4_cod
//		aProdEtiq[Len(aProdEtiq),03] := SB1->B1_CODBAR				// za4_ean13
//		aProdEtiq[Len(aProdEtiq),04] := cEAN14						// za4_ean14
//		aProdEtiq[Len(aProdEtiq),05] := cSerieCompl					// za4_nserie
//		aProdEtiq[Len(aProdEtiq),06] := SB1->B1_DESCETI			// za4_dscetq
//		aProdEtiq[Len(aProdEtiq),07] := DtoC(dDataBase)			// za4_dtfab
//		aProdEtiq[Len(aProdEtiq),08] := cCaixa						// za4_ncaixa
//		aProdEtiq[Len(aProdEtiq),09] := cLote						// za4_nlote
//		aProdEtiq[Len(aProdEtiq),10] := __CUSERID					// za4_user
//		aProdEtiq[Len(aProdEtiq),11] := SB1->B1_VOLTAG				// za4_voltag
//		aProdEtiq[Len(aProdEtiq),12] := cCxLote						// za4_cxlote
//		aProdEtiq[Len(aProdEtiq),13] := cBarra						// za4_barra
//		
//		U_GravaZA4( aProdEtiq )
//
//

	Else
		
		Aadd(aProdEtiq,{AA3->AA3_CODPRO,Right(AA3->AA3_NUMSER,6),AA3->AA3_DTVEND})
		
	Endif

End

End Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama Bar Tender para impressao das etiquetas de acordo com as etiquetas relacioanadas ao produto no SB1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lIntBarT
	

//	//cPathBarT := Alltrim(GetMV("MV_PATHBART",,"C:\Arquivos de programas\Seagull\BarTender\7.51\Bartend.exe"))
//	cPathBarT := Alltrim(GetMV("MV_PATHBART",,"C:\Arquivos de programas\Seagull\BarTender Suite\BarTender\Bartend.exe"))
//	cPathEtiq := Alltrim(GetMV("MV_PATHETIQ",,"C:\Etiquetas_Protheus\"))
//	
//	CallBarT(SB1->B1_ETIQ01)
//	CallBarT(SB1->B1_ETIQ02)
//	CallBarT(SB1->B1_ETIQ03)
	
	
	
Else
	
	//U_EtiqProd(aProdEtiq)
	
Endif

RecLock("SB1",.F.)
SB1->B1_LOTECTL	:= cLote
SB1->B1_CAIXA	:= cCaixa
SB1->(MsUnlock())

If ! Empty(cSerie)
	sb1->(dbseek(xFilial('SB1')+SC2->C2_PRODUTO))
	sb1->(RecLock("SB1",.f.))
	sb1->b1_serie:=cSerie
	sb1->(MsUnlock())
	
	sc2->(RecLock("SC2",.f.))
	sc2->c2_serie:=cSerie
	sc2->(MsUnlock())
Endif

RestArea(xAlias)

Return .t.
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
*/
//--------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------
