#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"

//----------------------------------------------------------------------------------------------------------------
// PROGRAMA: F440aBas	                                     AUTOR: CARLOS TORRES                 DATA: 26/07/2011
// DESCRICAO: PE para n�o gerar a comissao da NCC conforme campo regulamentador da natureza financeira SED
// OBSERVACOES: Este PE � disparado no bot�o Ok da compensa��o apos a sele��o de titulos na rotina "Compensacao Cr" (FINA330.PRX) 
//              no sub-item "Compensar"
//					 Tambem � acionado ao baixar titulos e na rotina FINA440 (rotina de calculo de comissoes OFF-LINE)
/*
	[1]  [C�digo do Vendedor]  
	[2]  [Base da Comiss�o]                             
	[3]  [Base na Emiss�o ]                              
	[4]  [Base na Baixa   ]                             
	[5]  [Vlr  na Emiss�o ]                              
	[6]  [Vlr  na Baixa   ]                              
	[7]  [% da Comiss�o/Se "Zero" diversos %'s]
*/
//----------------------------------------------------------------------------------------------------------------
User Function F440aBas()  
Local mB1Comiss	:= ACLONE(ParamIxb)
Local xSedAlias	:= SED->(GetArea())
Local xSe1Alias	:= SE1->(GetArea())
Local _nLoop 
//mB1Comiss	:= U_TFFa440Comis(SE1->(Recno()),.T.,.T.)

If SED->(FieldPos("ED_NCCCOMI")) != 0 
	SED->(DbSetOrder(1))
	If SE1->E1_TIPO='NCC'
		//
		// Quando o titulo principal � selecionado na compensa��o
		//
		SED->(DbSeek( xFilial("SED") + SE1->E1_NATUREZ ))
		If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .and. Len(mB1Comiss) > 0
			mB1Comiss[1,1] := Space(06)	// Codigo do vendedor - origem SD2
			mB1Comiss[1,2] := 0				// origem SD2
			mB1Comiss[1,3] := 0				// origem SD2
			mB1Comiss[1,4] := 0				// origem SD2
			mB1Comiss[1,5] := 0				// origem SD2
			mB1Comiss[1,6] := 0				// origem SD2
			mB1Comiss[1,7] := 0				// % da comissao - origem SD2
		EndIf
	Else
		If Type("aTitulos") != "U"
			//
			// Os titulos marcados para compensa��o s�o armazenados na matriz aTitulos
			//
			SE1->(DbSetOrder(1))
			For _nLoop := 1 to Len( aTitulos ) 
				If ValType(aTitulos[ _nLoop,8 ]) = "L"
					If aTitulos[ _nLoop,8 ]
						// E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
						__cChave := xFilial( "SE1" )
						__cChave += aTitulos[_nLoop,1] // Prefixo
						__cChave += aTitulos[_nLoop,2] // Numero titulo
						__cChave += aTitulos[_nLoop,3] // Parcela
						__cChave += aTitulos[_nLoop,4] // Tipo
						
						If SE1->(DbSeek( __cChave ))
							SED->(DbSeek( xFilial("SED") + Alltrim( SE1->E1_NATUREZ ) ))
							If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .and. SE1->E1_TIPO='NCC' .and. Len(mB1Comiss) > 0
								mB1Comiss[1,1] := Space(06)	// Codigo do vendedor - origem SD2
								mB1Comiss[1,2] := 0				// origem SD2
								mB1Comiss[1,3] := 0				// origem SD2
								mB1Comiss[1,4] := 0				// origem SD2
								mB1Comiss[1,5] := 0				// origem SD2
								mB1Comiss[1,6] := 0				// origem SD2
								mB1Comiss[1,7] := 0				// % da comissao - origem SD2
							EndIf
						EndIf
					EndIf
				EndIf	
				If ValType(aTitulos[ _nLoop,11 ]) = "L"
					If aTitulos[ _nLoop,11 ]
						__cChave := xFilial( "SE1" )
						__cChave += aTitulos[_nLoop,7] // Prefixo + Numero titulo + Parcela
						__cChave += "NCC"
						
						If SE1->(DbSeek( __cChave ))
							SED->(DbSeek( xFilial("SED") + Alltrim( SE1->E1_NATUREZ ) ))
							If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .and. SE1->E1_TIPO='NCC' .and. Len(mB1Comiss) > 0
								mB1Comiss[1,1] := Space(06)	// Codigo do vendedor - origem SD2
								mB1Comiss[1,2] := 0				// origem SD2
								mB1Comiss[1,3] := 0				// origem SD2
								mB1Comiss[1,4] := 0				// origem SD2
								mB1Comiss[1,5] := 0				// origem SD2
								mB1Comiss[1,6] := 0				// origem SD2
								mB1Comiss[1,7] := 0				// % da comissao - origem SD2
							EndIf
						EndIf
						
					EndIf
				EndIf	
			Next
		ElseIf ( !SE5->(Eof()) .and. !SE5->(Bof()) )
			If Substr( SE5->E5_DOCUMEN ,15,3) = 'NCC'
	
				__cChave := xFilial( "SE1" )
				__cChave += Substr(SE5->E5_DOCUMEN ,1,17 )
				
				SE1->(DbSetOrder(1))
				If SE1->(DbSeek( __cChave ))
					SED->(DbSeek( xFilial("SED") + SE1->E1_NATUREZ ))
					If SED->ED_NCCCOMI='S' .and. !SED->(Eof()) .AND. Len(mB1Comiss) > 0
						mB1Comiss[1,1] := Space(06)	// Codigo do vendedor - origem SD2
						mB1Comiss[1,2] := 0				// origem SD2
						mB1Comiss[1,3] := 0				// origem SD2
						mB1Comiss[1,4] := 0				// origem SD2
						mB1Comiss[1,5] := 0				// origem SD2
						mB1Comiss[1,6] := 0				// origem SD2
						mB1Comiss[1,7] := 0				// % da comissao - origem SD2
					EndIf
				EndIf
			Else
				__cChave := SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO + SE5->E5_CLIFOR + SE5->E5_LOJA + SPACE(TamSx3("E1_TITPAI")[1])
				__cChave := SUBSTR(__cChave  ,1,TamSx3("E1_TITPAI")[1])
				//SE1030S - E1_FILIAL, E1_TITPAI, R_E_C_N_O_, D_E_L_E_T_
				SE1->(DbSetOrder(28))
				If SE1->(DbSeek( xFilial("SE1") + __cChave  ))
					If mB1Comiss[1,7] > 0 .AND. SE1->E1_TIPO="AB-"
						mB1Comiss[1,2] := mB1Comiss[1,2] - SE1->E1_VALOR		// [2]  [Base da Comiss�o]                             
						mB1Comiss[1,4] := mB1Comiss[1,4] - SE1->E1_VALOR		// [4]  [Base na Baixa   ]                             
						mB1Comiss[1,6] := mB1Comiss[1,4] * (mB1Comiss[1,7]/100)	// [6]  [Vlr  na Baixa   ]
					EndIf                              
				EndIF
			EndIf
	
		EndIf
	EndIf
EndIf
RestArea(xSe1Alias)
RestArea(xSedAlias)
Return mB1Comiss

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �FA440Comis� Autor � Eduardo Riera         � Data � 16/12/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua o calculo das bases da comissao de um determinado   ���
���          � t�tulo financeiro.                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpN1 : Numero do Registro do SE1 ( Contas a Receber )     ���
���			 � ExpL2 : .T. : Atualiza baseS da comissao do SE1.			  ���
���			 � ExpL3 : .F. : Retorna bases do SE1 ou (.T.) recalcula(Defa)���
���			 � ExpN4 : Numero do Registro do SD2 para Devol.de Vendas     ���
���			 � ExpL5 : .F. : Nao calcula array de bases por parcela da NF ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Retorna um Array com as bases da comissao. na seguinte     ���
���          � estrutura [C�digo do Vendedor]                             ���
���          �           [Base da Comissao]                               ���
���          �           [Base na Emissao ]                               ���
���          �           [Base na Baixa   ]                               ���
���          �           [Vlr  na Emissao ]                               ���
���          �           [Vlr  na Baixa   ]                               ���
���			 � 			 [% da Comissao/Se "Zero" diversos %'s]           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Fina440                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TFFa440Comis(nRegistro,lGrava,lRefaz,nRegDevol,lCalcParc,nRecnoOrig)

Static lFWCodFil	:= FindFunction("FWCodFil")
STATIC nValAbatCom	:= 0
STATIC nSldTitComis	:= 0
STATIC cNatCom
STATIC cComiLiq
STATIC cChaveComis
STATIC cComisCR
STATIC cParComEm
STATIC cMV_1DUP
STATIC lFindPccBx 	:= FindFunction("FPccBxCr")
STATIC lFindIrBx 	:= FindFunction("FIrPjBxCr")
STATIC lFindAtuSld 	:= FindFunction("AtuSldNat")
STATIC lF440BasEm	
STATIC lF440CVB
STATIC lComp
STATIC lFina440
STATIC lF440Liq
STATIC lComiLiq
STATIC lCompensa
STATIC IsBlind
STATIC lFA440VLD
STATIC lDevolucao
STATIC lF440DelB
STATIC lGestao
Static lSF2460I := ExistBlock("SF2460I")
Static lF440VEND

Local aArea 	 := GetArea()
Local aAreaSE4  := {}
Local aAreaSF2  := {}
Local aAreaSF4  := {}
Local aAreaSD2  := {}
Local aAreaSA1  := {}
Local aAreaSA3  := {}
Local aAreaSD1  := {}
Local aAreaSF1  := {}
Local aAreaSE1  := {}
Local aAux      := {}
Local aSD2Vend  := {} // Array c/ as Bases dos Vend. por item de nota
Local aBaseNCC  := {} // Array c/ as Bases dos Vend.
Local aBaseSE1  := {} // Array c/ as Bases dos Vend. do Titulo em questao
Local aBaseSD1  := {} // Array c/ as Bases dos Vend. do Item da NFE
Local aImp			:= {}  // Recebe o array de TesImpInf
Local aSemNota		:=	{}
Local aVendPed  	:= {}
Local aRelImp		:= MaFisRelImp("MT100",{ "SD2" })
Local nVend     	:= fa440CntVen() // Numero M�ximo de Vendedores
Local nCntFor   	:= 0
Local nMaxFor   	:= 0
Local nBaseSe1  	:= 0 // Base da Comissao
Local nBaseDif  	:= 0
Local nPerComis 	:= 0 // Percentual da Comissao
Local nBaseEmis 	:= 0 // Base da Comissao na Emissao
Local nBaseBaix 	:= 0 // Base da Comissao na Baixa                  s
Local nVlrEmis  	:= 0 // Valor da Comissao na Emissao
Local nVlrBaix  	:= 0 // Valor da Comissao na Baixa
Local nFrete    	:= 0 // Valor do Frete
Local nIcmFrete 	:= 0 // Valor do Icms sobre frete
Local nTotal    	:= 0 // Total das mercadorias pelo item
Local nRatFrete 	:= 0 // Valor rateado do Frete por item
Local nRatIcmFre	:= 0 // Valor rateado do icms s/ frete por item
Local nSF2IcmRet	:= 0 // Valor do Icms Retido
Local nVlrFat   	:= 0 // Valor faturado
Local nVlrTit   	:= 0 // valor do titulo em questao
Local nProp     	:= 0
Local nPos      	:= 0
Local nAlEmissao	:= 0
Local nAlBaixa  	:= 0
Local nRatINSS  	:= 0
Local nRatIRRF  	:= 0
Local nX        	:= 0
Local nRatCOF		:= 0
Local nRatCSL		:= 0
Local nRatPIS  	:= 0
Local nScanPis  	:= 0
Local nScanCof  	:= 0
Local nBaseCC		:= 0											// Base de Comissao, caso seja CC ou CD - LOJA
Local nImp      	:= 0
Local nDescImp  	:= 0 
Local nFreteAux 	:= 0 
Local nPis 			:= 0
Local nCofins 		:= 0
Local nCsll 		:= 0
Local nTamParc  	:= TamSx3("E1_PARCELA")[1]
Local nDecimal  	:= TamSX3("E1_BASCOM1")[2] // N@ de decimais considerados no calculo
Local cVend     	:= "1"
Local cVendedor 	:= ""
Local cSerie    	:= ""
Local cPrefixo  	:= "" // Prefixo da Duplicata
Local cFilialSD1	:= ""
Local cFilialSD2	:= ""
Local cFilialSE1	:= ""
Local cFilialSE2	:= ""
Local cFilialSE4	:= ""
Local cFilialSF1	:= ""
Local cFilialSF2	:= ""
Local cFilialSF4	:= ""
Local cFieldPis 	:= ""
Local cFieldCof 	:= ""                              
Local cCposSD2  	:= "D2_FILIAL#D2_DOC#D2_SERIE#D2_CLIENTE#D2_LOJA#D2_TES#D2_ICMFRET#D2_TOTAL#D2_VALICM#D2_VALIPI#D2_IPI#D2_ICMSRET#D2_VALACRS#D2_ITEM#D2_COD#D2_DESCICM"
Local cAliasSD1 	:= "SD1"
Local cAliasSD2 	:= "SD2"
Local cAliasDev 	:= "SD1"
Local cAliasSF4 	:= "SF4"
Local cImp			:= "N"	 // Se A3_COMIMP nao existe, cImp = N, senao pega valor em A3_COMIMP
Local cMvComisCC	:= Upper( SuperGetMv("MV_COMISCC",,"S") )		// Verifica se deduz ou nao a taxa da adm. financeira p/ LOJA
Local cEspSes		:= " "
Local lQuery    	:= .F.
Local lContinua 	:= .T.
Local cPrimParc 	:= " "
Local lRecIRRF  	:= .F.
Local lMata460  	:= Alltrim(SE1->E1_ORIGEM) == "MATA460"
//Controla o Pis Cofins e Csll na baixa  (1-Retem PCC na Baixa ou 2-Retem PCC na Emiss�o(default) )
Local lPccBxCr		:= If (lFindPccBx,FPccBxCr(),.F.)
Local lPEPerCom 	:= ExistBlock("FIN440PE")
Local lCalEmis		:= IsInCallStack("FA440CALCE")
Local lMultVend := SuperGetMv("MV_LJTPCOM",,"1" ) == "2"
Local nTotCsAbt  := 0 
Local nTotPisAbt := 0 
Local nTotCofAbt := 0
Local nImpComis		:= 0

#IFDEF TOP
	Local cQuery    := ""
#ENDIF	
Static aStruSD1
Static aStruSD2
Static aStruSF4

Default lPEPerCom := ExistBlock("FIN440PE")
Default lCalcParc := .T.
DEFAULT nRecnoOrig := nRegistro
DEFAULT cMV_1DUP	:= SuperGetMv("MV_1DUP")   
DEFAULT cComiLiq 	:= SuperGetMv("MV_COMILIQ",,"2")
DEFAULT lComiLiq	:= ComisBx("LIQ") .AND. cComiLiq == "1"

// Abertura dos arquivos pois no Loja alguns nao sao utilizados

dbSelectArea("SE4")
aAreaSE4  := SE4->(GetArea())
cFilialSE4:= xFilial("SE4")

dbSelectArea("SF2")
aAreaSF2  := SF2->(GetArea())
cFilialSF2:= xFilial("SF2")
                 
dbSelectArea("SF4")
aAreaSF4  := SF4->(GetArea())
cFilialSF4:= xFilial("SF4")

dbSelectArea("SD2")
aAreaSD2  := SD2->(GetArea())
cFilialSD2:= xFilial("SD2") 

dbSelectArea("SA1")
aAreaSA1  := SA1->(GetArea())

dbSelectArea("SA3")
aAreaSA3  := SA3->(GetArea())
                 
dbSelectArea("SD1")
aAreaSD1  := SD1->(GetArea())
cFilialSD1:= xFilial("SD1")

dbSelectArea("SF1")
aAreaSF1  := SF1->(GetArea())
cFilialSF1:= xFilial("SF1")

dbSelectArea("SE1")
aAreaSE1  := SE1->(GetArea())
cFilialSE1:= xFilial("SE1")

dbSelectArea("SE2")
cFilialSE2:= xFilial("SE2")

RestArea(aArea)  

//��������������������������������������������������������������Ŀ
//� Verifica se � a primeira parcela de uma fatura               �
//����������������������������������������������������������������
If nTamParc == 1
	cPrimParc := "1A "
ElseIf nTamparc == 2
	cPrimParc := cMV_1DUP+Space(2-Len(cMV_1DUP))
	cPrimParc += "#1 #A #  #01"
Else	
	cPrimParc := cMV_1DUP+Space(3-Len(cMV_1DUP))
	cPrimParc += "#1  #A  #   #001"
Endif

if cPaisLoc<>"BRA"
	cEspSes	:= GetSesNew("NDC","1")
Endif
//��������������������������������������������������������������Ŀ
//� Tratamento de Parametros Default da funcao                   �
//����������������������������������������������������������������
lRefaz := If( lRefaz == Nil , .T. , lRefaz )
lGrava := If( lGrava == Nil , .T. , lGrava )
/*
If lSF2460I
	lRefaz := .F.
	lGrava := .F.
EndIf
*/
If ( aStruSD1 == Nil )
	aStruSD1 := {}
	dbSelectArea("SD1")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$"D1_FILIAL#D1_DOC#D1_SERIE#D1_FORNECE#D1_LOJA" .Or.;
				FieldName(nCntFor)$"D1_NFORI#D1_SERIORI#D1_COD#D1_ITEMORI#D1_TOTAL#D1_VALDESC#D1_ITEM" )
			aadd(aStruSD1,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})
		EndIf
	Next nCntFor
EndIf
If ( aStruSD2 == Nil )

	//��������������������������������������������������������������Ŀ
	//� Verifica se os campos que gravam o valor do PIS/COFINS para  �
	//� abater da base conforme configurado                          �
	//����������������������������������������������������������������

	If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
		cFieldPis  := aRelImp[nScanPis,2]
	EndIf
	
	If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
		cFieldCof := aRelImp[nScanCof,2]
	EndIf 	

	aStruSD2 := {}
	dbSelectArea("SD2")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$cCposSD2 .Or.;
			FieldName(nCntFor)$cFieldPis .Or.;
			FieldName(nCntFor)$cFieldCof .Or.;
			"D2_COMIS"$FieldName(nCntFor) )			
			aadd(aStruSD2,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})
		EndIf
	Next nCntFor
EndIf
If ( aStruSF4 == Nil )
	aStruSF4 := {}
	dbSelectArea("SF4")
	aAux := dbStruct()
	For nCntFor := 1 To Len(aAux)
		If ( FieldName(nCntFor)$"F4_DUPLIC#F4_INCIDE#F4_IPIFRET#F4_INCSOL#F4_ISS" )
			aadd(aStruSF4,{aAux[nCntFor,1],aAux[nCntFor,2],aAux[nCntFor,3],aAux[nCntFor,4]})	
		EndIf
	Next nCntFor
EndIf
//��������������������������������������������������������������Ŀ
//� Posiciona no Registro do SE1 a ser calculado                 �
//����������������������������������������������������������������
dbSelectArea("SE1")
MsGoto(nRegistro)
//Verifica se o cliente e responsavel pelo recolhimento do IR ou nao.
If cPaisLoc == "BRA"
	dbSelectArea("SA1")       
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA))) .And. SA1->A1_RECIRRF == "1"
		lRecIRRF := .T.
	Endif
Endif
//��������������������������������������������������������������Ŀ
//� Verifica se o titulo foi gerado pelo faturamento e for neces-�
//� sario recalcular suas bases.                                 �
//����������������������������������������������������������������
If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes ) /*.and. !lSF2460I*/
	For nCntFor := 1 To nVend 	
		cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
		nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))
		If ( nPerComis == 0 .And. !Empty(cVendedor) )
			lRefaz := .T.
			Exit
		EndIf
		cVend := Soma1(cVend,1)
	Next nCntFor
ElseIf	cPaisLoc <>"BRA" .and.( SE1->E1_TIPO $ MV_CRNEG+MVRECANT)
	lRefaz := .T. 
EndIf
//��������������������������������������������������������������Ŀ
//� Posiciona Registros                                          �
//� Aqui se faz necessaria a cria��o de tratamento de filial de  �
//� origem para quando se tem SE1 compartilhado e SF2, SE4 ou SD2�
//� exclusivos                                                   �
//����������������������������������������������������������������
If SE1->(FieldPos("E1_MSFIL")) > 0
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf1)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF1",3)=="E" 
		cFilialSf1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf2)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF2",3)=="E" 
		cFilialSf2 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSf4)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF4",3)=="E" 
		cFilialSf4 := SE1->E1_MSFIL
	Endif	
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe1)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE1",3)=="E" 
		cFilialSe1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe2)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE2",3)=="E" 
		cFilialSe2 := SE1->E1_MSFIL
	Endif		
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSe4)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE4",3)=="E" 
		cFilialSe4 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSd1)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SD1",3)=="E" 
		cFilialSd1 := SE1->E1_MSFIL
	Endif
	If !Empty(SE1->E1_MSFIL) .and. !(Empty(cFilialSd2)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SD2",3)=="E" 
		cFilialSd2 := SE1->E1_MSFIL
	Endif
Else
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf1)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF1",3)=="E" 
			cFilialSf1 := SE1->E1_FILORIG
		Endif	
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf2)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF2",3)=="E" 
			cFilialSf2 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe1)).And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE1",3)=="E"
			cFilialSe1 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe2)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE2",3)=="E" 
			cFilialSe2 := SE1->E1_FILORIG
		Endif		
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSe4)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SE4",3)=="E" 
			cFilialSe4 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSd1)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SD1",3)=="E" 
			cFilialSd1 := SE1->E1_FILORIG
		Endif	
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSd2)).And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SD2",3)=="E" 
			cFilialSd2 := SE1->E1_FILORIG
		Endif
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSf4)) .And. FWModeAccess("SE1",3)=="C" .And. FWModeAccess("SF4",3)=="E" 
			cFilialSf4 := SE1->E1_FILORIG
		Endif
	Endif
EndIf
If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes .And. lRefaz)
	If Year(SE1->E1_EMISSAO)<2001
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
	Else               	
		cSerie := SE1->E1_SERIE
	EndIf
	dbSelectArea("SF2")
	dbSetOrder(1)
	If (!MsSeek(cFilialSF2+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
		lContinua := .F.
	EndIf
	dbSelectArea("SE4")
	dbSetOrder(1)
	If (!MsSeek(cFilialSE4+SF2->F2_COND))
		lContinua := .F.
	EndIf
	dbSelectArea("SD2")
	dbSetOrder(3)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			SD2->(dbCommit())
			lQuery := .T.
			cAliasSD2 := "FA440COMIS"
			cAliasSF4 := "FA440COMIS"
			cQuery := ""
			For nCntFor := 1 To Len(aStruSD2)
				cQuery += ","+aStruSD2[nCntFor][1]
			Next nCntFor
			For nCntFor := 1 To Len(aStruSF4)
				cQuery += ","+aStruSF4[nCntFor][1]
			Next nCntFor
			
			cQuery := "SELECT SD2.R_E_C_N_O_ SD2RECNO,"+SubStr(cQuery,2)
			cQuery += "  FROM "+RetSqlName("SD2")+" SD2,"+RetSqlName("SF4")+" SF4 "
			cQuery += " WHERE SD2.D2_FILIAL   = '"+cFilialSD2+"'"
			cQuery += "   AND SD2.D2_DOC	  = '"+SE1->E1_NUM+"'"
			cQuery += "   AND SD2.D2_SERIE	  = '"+cSerie+"'"
			cQuery += "   AND SD2.D2_CLIENTE  = '"+SE1->E1_CLIENTE+"'"
			cQuery += "   AND SD2.D2_LOJA     = '"+SE1->E1_LOJA+"'"
			cQuery += "   AND SD2.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SF4.F4_FILIAL	  ='"+cFilialSF4+"'"
			cQuery += "   AND SF4.F4_CODIGO   = SD2.D2_TES"
			cQuery += "   AND SF4.D_E_L_E_T_  <> '*' "
			cQuery += " ORDER BY "+SqlOrder(SD2->(IndexKey()))   
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2)
			
			lContinua := !(cAliasSD2)->(Eof())
			For nCntFor := 1 To Len(aStruSD2)
				If ( aStruSD2[nCntFor][2]!= "C" )
					TcSetField(cAliasSD2,aStruSD2[nCntFor][1],aStruSD2[nCntFor][2],aStruSD2[nCntFor][3],aStruSD2[nCntFor][4])
				EndIf
			Next nCntFor
			For nCntFor := 1 To Len(aStruSF4)
				If ( aStruSF4[nCntFor][2]!="C" )
					TcSetField(cAliasSF4,aStruSF4[nCntFor][1],aStruSF4[nCntFor][2],aStruSD2[nCntFor][3],aStruSF4[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF	
		If (!MsSeek(cFilialSD2+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		#IFDEF TOP
		EndIf	
		#ENDIF
	If ( lContinua )
		//��������������������������������������������������������������Ŀ
		//� Calculo da comissao por item de nota fiscal                  �
		//�                                                              �
		//�1)O Valor do icms s/ frete e adiciona ao campo F2_VALICM, por �
		//�esta razao deve-se somar o vlr do icms dos itens e subtrair   �
		//�do total de icms (F2_VALICM) para apurar-se o vlr icms s/frete�
		//�                                                              �
		//�2)O mesmo ocorre para o valor do IPI sobre frete, Por esta ra-�
		//�zao e' calculado o valor do IPI sobre frete do item multipli- �
		//�cando-se o valor do frete do item pelo % de ipi do item.      �
		//�                                                              �
		//�3)O Valor do Icms Retido pode n�o estar no total da nota (F2_-�
		//�VALBRUT) por isto deve-se considerar o campo (D2_ICMSRET).    �
		//�                                                              �
		//�4)O percentual da comissao dever ser considerado para cada i- �
		//�tem de nota fiscal pois ela pode ser diferente entre eles. O  �
		//�percentual gravado no E1_COMIS � sempre um valor aproximado e �
		//�nao deve ser considerado ser houver nota fiscal para o titulo.�
		//�                                                              �
		//�5)A Base da Comissao � o valor da mercadoria + o valor do ipi �
		//�+ o valor das despesas acessorias +  o icms solidario. Como e'�
		//�por item deve-se conhece-lo pelo item a item.                 �
		//����������������������������������������������������������������
		nTotal     := 0
		nFrete     := (SF2->F2_FRETE + SF2->F2_SEGURO + SF2->F2_DESPESA)
		nIcmFrete  := 0
		nSF2IcmRet :=0
		
		If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALPS2"} ) )
			cFieldPis  := aRelImp[nScanPis,2]
		EndIf
		
		If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SD2" .And. x[3]=="IT_VALCF2"} ) )
			cFieldCof := aRelImp[nScanCof,2]
		EndIf 	
		
		If  lPccBxCr .and. !lCalEmis

			 If !(SE5->E5_PRETPIS	$	"1;2")
			 	nPis	:= SE5->E5_VRETPIS
			 Else
			 	nPis		:=	0
			 EndIf
			 If !(SE5->E5_PRETCOF	$	"1;2")
			 	nCofins	:= SE5->E5_VRETCOF
			 Else
			 	nCofins	:= 0
			 EndIf
			 If !(SE5->E5_PRETCSL $	"1;2")
			 	nCofins	:= SE5->E5_VRETCSL
			 Else
			 	nCofins	:= 0
			 EndIf
		Endif
		
		While ( !Eof() .And. (cAliasSD2)->D2_FILIAL == cFilialSD2 .And.;
				(cAliasSD2)->D2_DOC 	 == SE1->E1_NUM .And.;
				(cAliasSD2)->D2_SERIE	 == cSerie .And.;
				(cAliasSD2)->D2_CLIENTE  == SE1->E1_CLIENTE .And.;
				(cAliasSD2)->D2_LOJA	 == SE1->E1_LOJA	)

			If ( !lQuery )
				dbSelectArea("SF4")
				dbSetOrder(1)
				MsSeek(cFilialSF4+(cAliasSD2)->D2_TES)
			Else
				If cPaisLoc<>"BRA"
					SD2->(DbGoto((cAliasSD2)->SD2RECNO))
				Endif
			EndIf

			cVend := "1"
			For nCntFor := 1 To nVend
				cVendedor := SF2->(FieldGet(SF2->(FieldPos("F2_VEND"+cVend))))
				nPerComis := (cAliasSD2)->(FieldGet((cAliasSD2)->(FieldPos("D2_COMIS"+cVend))))
				nImp     := 0
				nDescImp := 0
				If cPaisLoc <> "BRA"
					SA3->(DbSetOrder(1))
					SA3->(DbSeek(xFilial()+cVendedor))
					aImp := TesImpInf(	(cAliasSD2)->D2_TES)
					cImp := IIf(SA3->(FieldPos("A3_COMIMP")) >0,SA3->A3_COMIMP,"N")
					For nX :=1 to Len(aImp)
						If (cImp+aImp[nX][3] == "S1")
							nImp += SD2->(FieldGet(FieldPos(aImp[nX][2])))
						ElseIf (cImp+aImp[nX][3] == "N2")
							nImp -=	SD2->(FieldGet(FieldPos(aImp[nX][2])))
						EndIf
						If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0 .And. cImp+aImp[nX][13] == "N1"
							nImpComis -= SD2->(FieldGet(FieldPos(aImp[nX][2]))) 
						EndIf
					Next nX
				Else
					If (cAliasSD2)->(FieldPos("D2_DESCICM"))<>0
						nDescImp -= (cAliasSD2)->D2_DESCICM
					EndIf				
				EndIf
				If ( !Empty(cVendedor) .And. (cAliasSF4)->F4_DUPLIC == "S" )
					aadd(aSD2Vend,{ cVendedor,;
						(cAliasSD2)->D2_TOTAL+nImp+nDescImp,;
						(cAliasSD2)->D2_VALICM+nDescImp,;
						(cAliasSD2)->D2_VALIPI,;
						(cAliasSD2)->D2_IPI,;
						(cAliasSF4)->F4_INCIDE,;
						(cAliasSF4)->F4_IPIFRET,;
						Iif(cPaisLoc<>"BRA".Or.(cAliasSF4)->F4_INCSOL=="N",0,(cAliasSD2)->D2_ICMSRET),;
						nPerComis,;
						(cAliasSD2)->D2_VALACRS,;
						If(lQuery,(cAliasSD2)->SD2RECNO,(cAliasSD2)->(RecNo())),;
						(cAliasSF4)->F4_ISS=="S",;
						cVend,;
						nPis,;
						nCofins,;
						Iif(!Empty(cFieldPis), (cAliasSD2)-> D2_VALIMP5,0) ,; // pis apura��o
						Iif(!Empty(cFieldCof), (cAliasSD2)-> D2_VALIMP6,0) }) // cofins apura��o
						If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
							Aadd(aSD2Vend[Len(aSD2Vend)],(cAliasSD2)->D2_TOTAL+nImpComis+nDescImp)
						EndIf
					If aScan(aVendPed, cVendedor) == 0	  // Monta um array com os vendedores para rateio do frete
					   aadd(aVendPed, cVendedor)
					Endif
					//*****************************************************
					// Ajusta a base da comissao da nota para a Moeda 01  *
					//*****************************************************
					If cPaisLoc<>"BRA"
						aSD2Vend[Len(aSD2Vend),2]	:= 	xMoeda( aSD2Vend[Len(aSD2Vend),2] , SF2->F2_MOEDA , 1 , SF2->F2_EMISSAO , nDecimal , SF2->F2_TXMOEDA )
					EndIf 		  
				EndIf							
				cVend := Soma1(cVend,1)
			Next nCntFor
			If ( (cAliasSF4)->F4_ISS != "S" )
				If (cAliasSF4)->(FieldPos("F4_INCSOL"))>0
					nSF2IcmRet += Iif((cAliasSF4)->F4_INCSOL=="N",0,(cAliasSD2)->D2_ICMSRET)
				EndIf
				If (cAliasSD2)->(FieldPos("D2_ICMFRET"))>0
					nIcmFrete  += (cAliasSD2)->D2_ICMFRET
				EndIf
			EndIf
			nTotal	  += (cAliasSD2)->D2_TOTAL
			dbSelectArea(cAliasSD2)
			dbSkip()
		EndDo
		If ( lQuery )
			dbSelectArea(cAliasSD2)
			dbCloseArea()
			dbSelectArea("SD2")
		EndIf
		//��������������������������������������������������������������Ŀ
		//� Calculo da comissao pela nota.                               �
		//�                                                              �
		//�1)Apos calculado as bases de cada vendedor por item de nota   �
		//�deve-se aglutina-las formando uma unica base para toda a nota �
		//�fiscal.                                                       �
		//�                                                              �
		//�2)Como os valores serao aglutinados pode-se haver perda de de-�
		//�cimais por isto deve-se haver um controle para que a perda se-�
		//�ja adicionada a primeira parcela da nota.                     �
		//����������������������������������������������������������������
		nMaxFor := Len(aSD2Vend)
		nPerComis:=0
		nFreteAux := 0
		For nCntFor := 1 To nMaxFor
			If (lPePercom)
				nPerComis := ExecBlock("FIN440PE",.F.,.F.,{aSD2Vend[nCntFor][1]})
				If ( ValType(nPerComis)<>"N" )
					nPerComis := aSD2Vend[nCntFor][9]
				Else
					aSD2Vend[nCntFor][9] := nPerComis
				EndIf
			Else
				nPerComis := aSD2Vend[nCntFor][9]
			EndIf
			If ( SE1->E1_PARCELA $ cPrimParc )
				nBaseDif  := NoRound(nFrete*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
				nBaseDif  := nFrete - nBaseDif
				// No ultimo item o valor do rateio do frete � o valor do frete menos o rateio do frete acumulado
				// ate o penultimo item (evitar diferenca de centavos na base da comissao (E1_BASCOM)
				If nCntFor == nMaxFor
				   nRatFrete := (nFrete * If(Len(aVendPed) > 0, Len(aVendPed), 1)) - nFreteAux
				Else
					nFreteAux += nBaseDif
					nRatFrete := nBaseDif
				EndIf
			Else
				nRatFrete := NoRound(nFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
			EndIf   
			If cPaisLoc == "BRA"
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif  := NoRound(SF2->F2_VALINSS*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
					nBaseDif  := SF2->F2_VALINSS - nBaseDif
					nRatINSS  := nBaseDif
				Else
					nRatINSS := NoRound(SF2->F2_VALINSS*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				EndIf	

				If  lPccBxCr .and. !lCalEmis
			 		If !(SE5->E5_PRETPIS	$	"1;2")
						nPis	:= SE5->E5_VRETPIS
					Else
						nPis	:=	0
					EndIf
					If !(SE5->E5_PRETCOF	$	"1;2")
						nCofins	:= SE5->E5_VRETCOF
					Else
						nCofins	:= 0
					EndIf
					If !(SE5->E5_PRETCSL	$	"1;2")
						nCsll	:= SE5->E5_VRETCSL
					Else
						nCsll	:=	0
					EndIf
					If ( SE1->E1_PARCELA $ cPrimParc )
						nBaseDif  := NoRound(nCsll*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
						nBaseDif  := nCsll - nBaseDif
						nRatCSL  := nBaseDif

						nBaseDif  := NoRound(nPis*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
						nBaseDif  := nPis - nBaseDif
						nRatPIS  := nBaseDif
						
						nBaseDif  := NoRound(nCofins*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
						nBaseDif  := nCofins - nBaseDif
						nRatCOF  := nBaseDif
					Else
						nRatCSL := NoRound(nCsll*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
						nRatPIS:= NoRound(nPis*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
						nRatCOF := NoRound(nCofins*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
					EndIf

				Elseif !lPccBxCr

					If SF2->(FieldPos("F2_VALCSLL")) > 0
						If ( SE1->E1_PARCELA $ cPrimParc )
							nBaseDif  := NoRound(SF2->F2_VALCSLL*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
							nBaseDif  := SF2->F2_VALCSLL - nBaseDif
							nRatCSL  := nBaseDif
						Else
							nRatCSL := NoRound(SF2->F2_VALCSLL*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
						EndIf	
					Endif

					If SF2->(FieldPos("F2_VALPIS")) > 0
						If ( SE1->E1_PARCELA $ cPrimParc )
							nBaseDif  := NoRound(SF2->F2_VALPIS*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
							nBaseDif  := SF2->F2_VALPIS - nBaseDif
							nRatPIS  := nBaseDif
						Else
							nRatPIS := NoRound(SF2->F2_VALPIS*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
						EndIf	
					Endif

					If SF2->(FieldPos("F2_VALCOFI")) > 0
						If ( SE1->E1_PARCELA $ cPrimParc )
							nBaseDif  := NoRound(SF2->F2_VALCOFI*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
							nBaseDif  := SF2->F2_VALCOFI - nBaseDif
							nRatCOF  := nBaseDif
						Else
							nRatCOF := NoRound(SF2->F2_VALCOFI*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
						EndIf	
					Endif
				Endif

				If ( SE1->E1_PARCELA $ cPrimParc )
			  		nBaseDif  := NoRound(SF2->F2_VALIRRF*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal)
					nBaseDif  := SF2->F2_VALIRRF - nBaseDif
					nRatIRRF  := nBaseDif
					nRatIRRF := NoRound(SF2->F2_VALIRRF*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
				Else
					nRatIRRF := NoRound(SF2->F2_VALIRRF*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
				EndIf
				
			EndIf
			nRatIcmFre:= 0
			nBaseSE1  := 0
			nPos      := 0
			nRatIcmFre:= NoRound(nIcmFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal)
			nBaseSE1  := aSD2Vend[nCntFor,2]+IIF(SF2->F2_TIPO=='P',0,aSD2Vend[nCntFor,4])+aSD2Vend[nCntFor,8]+nRatFrete //soma-se IPI e ICM Retido
			dbSelectArea("SA3")
			dbSetOrder(1)
			MsSeek(xFilial()+aSD2Vend[nCntFor,1])

			If SE1->(FieldPos("E1_ALEMIS"+aSD2Vend[nCntFor,13]))<>0 //Nao criar no dicionario padrao
				nAlEmissao := SE1->(FieldGet(FieldPos("E1_ALEMIS"+aSD2Vend[nCntFor,13])))
			Else
				nAlEmissao := SA3->A3_ALEMISS
			EndIf
			If SE1->(FieldPos("E1_ALBAIX"+aSD2Vend[nCntFor,13]))<>0 //Nao criar no dicionario padrao
				nAlBaixa := SE1->(FieldGet(FieldPos("E1_ALBAIX"+aSD2Vend[nCntFor,13])))
			Else
				nAlBaixa := SA3->A3_ALBAIXA
			EndIf

			If ( SA3->A3_FRETE == "N" )
				nBaseSE1 -=  nRatFrete
				nBaseSE1 +=  nRatIcmFre
			Endif
			If ( SA3->A3_IPI   == "N" )
				nBaseSE1 -= ( aSD2Vend[nCntFor,4] )
			EndIf
			If !aSD2Vend[nCntFor,12]
				If ( SA3->A3_ICM   == "N" )
					nBaseSE1 -= aSD2Vend[nCntFor,3]
				EndIf
			Else                    
				If ( SA3->A3_ISS == "N" ) .Or. (( SA3->A3_ISS == "S" ) .And. (SE1->(FieldPos("E1_FRETISS"))>0 .And. SE1->E1_FRETISS=="1").And.;
			   		(SuperGetMV("MV_VRETISS",.F.,0) < aSD2Vend[nCntFor,3]) .And. SA1->A1_RECISS == "1")// Abate o ISS da base
					nBaseSE1 -= ( aSD2Vend[nCntFor,3] )
				EndIf				
			EndIf				
			If ( SA3->A3_ICMSRET == "N" )
				nBaseSE1 -= ( aSD2Vend[nCntFor,8] )
			EndIf
			If SA3->(FieldPos("A3_ACREFIN")) != 0  // Acrescimo Financeiro
				If ( SA3->A3_ACREFIN == "N" ) .and. aSD2Vend[nCntFor,10] > 0
					nBaseSE1 -= ( aSD2Vend[nCntFor,10] )
				EndIf
			Endif
			
			If SA3->(FieldPos("A3_PISCOF")) != 0  // Abate Pis/Cofins
				Do Case
				Case SA3->A3_PISCOF == "2" //Abate Pis
					nBaseSE1 -=aSD2Vend[nCntFor,16]
				Case SA3->A3_PISCOF == "3" //Abate Cofins
					nBaseSE1 -=aSD2Vend[nCntFor,17]				
				Case SA3->A3_PISCOF == "4" //Abate ambos
					nBaseSE1 -=aSD2Vend[nCntFor,16]
					nBaseSE1 -=aSD2Vend[nCntFor,17]
				EndCase	
			Endif
			
			If SuperGetMv("MV_COMISIR") == "N" .And. lRecIRRF
				nBaseSE1 -= nRatIRRF
			Endif
			If GetNewPar("MV_COMIINS","N") == "N"
				nBaseSE1 -= nRatINSS									    
			EndIf
			If !lPccBxCr
				If GetNewPar("MV_COMIPIS","N") == "N"
					nBaseSE1 -= nRatPIS
				EndIf
				If GetNewPar("MV_COMICOF","N") == "N"
					nBaseSE1 -= nRatCOF
				EndIf
				If GetNewPar("MV_COMICSL","N") == "N"
					nBaseSE1 -= nRatCSL
				EndIf
			Else
				If GetNewPar("MV_COMIPIS","N") == "S"
					nPIS := 0
				EndIf
				If GetNewPar("MV_COMICOF","N") == "S"
					nCofins := 0
				EndIf                                             
				
				If GetNewPar("MV_COMICSL","N") == "S"
					nCsll := 0
				EndIf			
			Endif
			
			nPos := aScan(aBaseSE1,{|x| x[1] == aSD2Vend[nCntFor,1]})
			If Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"
				nBaseBaix := Round(nBaseSE1*nAlBaixa/100,nDecimal+1)	 	// Base da Comissao na Baixa
			ELSE
				nBaseBaix:= 0
			Endif
			nBaseEmis := nBaseSE1-nBaseBaix                           		// Base da Comissao na Emissao
			If ( nAlEmissao==0 .AND.  Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO" )
				nBaseEmis := 0
			EndIf
			
			If (IsInCallStack("FINA070") .or. IsInCallStack("FINA110")) .And. MV_PAR05 == 1
				nBaseBaix += nJuros
			EndIf
			
			nVlrEmis  := nBaseEmis*aSD2Vend[nCntFor,9]/100	// Valor da Comissao na Emissao
			nVlrBaix  := nBaseBaix*aSD2Vend[nCntFor,9]/100	// Valor da Comissao na Baixa
			If ( Empty(nRegDevol) .Or. nRegDevol == aSD2Vend[nCntFor,11] )
				If ( nPos == 0 )
					aadd(aBaseSE1,{ aSD2Vend[nCntFor,1] ,;
						nBaseSE1  				,;
						nBaseEmis 				,;
						nBaseBaix 				,;
						nVlrEmis  				,;
						nVlrBaix				,;
						nPerComis				,;
						nPis						,;
						nCsll						,;
						nCofins})
						If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
							Aadd(aBaseSE1[Len(aBaseSE1)],Round((aSD2Vend[nCntFor,18]*aSD2Vend[nCntFor,9]/100)*SA3->A3_ALEMISS/100,nDecimal))
							Aadd(aBaseSE1[Len(aBaseSE1)],aSD2Vend[nCntFor,18]*SA3->A3_ALEMISS/100)
						EndIf
				Else
					aBaseSE1[nPos,2] += nBaseSE1
					aBaseSE1[nPos,3] += nBaseEmis
					aBaseSE1[nPos,4] += nBaseBaix
					aBaseSE1[nPos,5] += nVlrEmis
					aBaseSE1[nPos,6] += nVlrBaix
					If aBaseSE1[nPos,7] == nPerComis
						aBaseSE1[nPos,7] := nPerComis
					Else
						aBaseSE1[nPos,7] := 0
					EndIf
				EndIf	
			EndIf
		Next nCntFor
		//��������������������������������������������������������������Ŀ
		//� Calculo da comissao pelas parcelas.                          �
		//�                                                              �
		//�1)O SE3 � gravado por parcela e nao pela nota. assim e'neces- �
		//�ssario calcular a base da comissao para a parcela em questao. �
		//�                                                              �
		//�2)Aqui deve-se tomar o maximo cuidado com a Condi��o de pagto �
		//�pois se o Icms Solidario ou o Ipi for separado de alguma par- �
		//�cela deve-se considera esta separacao para calcular-se a me-  �
		//�lhor propor�ao possivel para a base da parcela.               �
		//����������������������������������������������������������������
		If lCalcParc
			nMaxFor := Len(aBaseSE1)
			For nCntFor := 1 To nMaxFor
				nProp   := 0
				nVlrFat := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
				nVlrTit := SE1->E1_VLCRUZ
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aBaseSE1[nCntFor,1])
				If ( SA3->A3_IPI == "N" .Or. SA3->A3_ICMSRET == "N" )
					If ( (SE4->E4_IPI == "S" .And. SF2->F2_VALIPI <> 0) .Or. ( SE4->E4_SOLID=="S" .And. SF2->F2_ICMSRET <> 0) ) .And. (SE1->E1_PARCELA $ cPrimParc)
				   		If !Empty(SE1->E1_PARCELA)
							nVlrTit := 0
							nVlrFat := 0
						EndIf
					EndIf
					If ( SE4->E4_IPI == "S" .And. !SE1->E1_PARCELA $ cPrimParc)
						nVlrFat -= ( SF2->F2_VALIPI )
					EndIf
					If ( SE4->E4_SOLID == "S" .And. !SE1->E1_PARCELA $ cPrimParc)
						nVlrFat -= (nSf2IcmRet)
					EndIf
					If ( SE4->E4_IPI == "J" .And. SE1->E1_PARCELA $ cPrimParc)
						nVlrFat -= ( SF2->F2_VALIPI )
						nVlrTit -= ( SF2->F2_VALIPI )
					EndIf
					If ( SE4->E4_IPI == "J" .And. !(SE1->E1_PARCELA $ cPrimParc ))
						nVlrFat -= ( SF2->F2_VALIPI )
					EndIf
					If ( SE4->E4_SOLID == "J" .And. SE1->E1_PARCELA $ cPrimParc )
						nVlrFat -= (nSf2IcmRet)
						nVlrTit -= (nSf2IcmRet)
					EndIf
					If ( SE4->E4_SOLID == "J" .And. !(SE1->E1_PARCELA $ cPrimParc) )
						nVlrFat -= (nSf2IcmRet)
					EndIf
				EndIf
				If ( nVlrTit > 0 )
					nProp := nVlrFat / nVlrTit
				Else
					nProp := 0
				EndIf	
				If (nProp != 0 )
					nBaseSE1 := NoRound(aBaseSE1[nCntFor,2]/nProp,nDecimal+1)
					nBaseEmis:= NoRound(aBaseSE1[nCntFor,3]/nProp,nDecimal+1)
					nBaseBaix:= NoRound(aBaseSE1[nCntFor,4]/nProp,nDecimal+1)
					nVlrEmis := Round(aBaseSE1[nCntFor,5]/nProp,nDecimal+1)
					nVlrBaix := Round(aBaseSE1[nCntFor,6]/nProp,nDecimal+1)
				Else
					nBaseSE1 := 0
					nBaseEmis:= 0
					nBaseBaix:= 0
					nVlrEmis := 0
					nVlrBaix := 0
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc .And. nBaseSE1 != 0 )
					//--> Calculo da Proporcao para a Base da Comissao
					nBaseDif := Round(nBaseSE1 * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,2]-nBaseDif
					aBaseSE1[nCntFor,2] := nBaseSE1+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Emissao
	
					nBaseDif := Round(nBaseEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,3]-nBaseDif
					aBaseSE1[nCntFor,3] := nBaseEmis+nBaseDif
					If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
						aBaseSE1[nCntFor,12] := NoRound(aBaseSE1[nCntFor,12]/nProp,nDecimal+1)
					EndIf
					//--> Calculo da Proporcao para a Base da Comissao pela Baixa
	
					nBaseDif := Round(nBaseBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,4]-nBaseDif
					aBaseSE1[nCntFor,4] := nBaseBaix+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Emissao
	
					nBaseDif := Round(nVlrEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,5]-nBaseDif
					aBaseSE1[nCntFor,5] := nVlrEmis+nBaseDif
					If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
						aBaseSE1[nCntFor,11] := Round(aBaseSE1[nCntFor,11]/nProp,nDecimal+1)     
					EndIf
					//--> Calculo da Proporcao para o Valor da Comissao pela Baixa
	
					nBaseDif := Round(nVlrBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,6]-nBaseDif
					aBaseSE1[nCntFor,6] := nVlrBaix+nBaseDif
				Else
					aBaseSE1[nCntFor,2] := nBaseSE1
					aBaseSE1[nCntFor,3] := nBaseEmis
					aBaseSE1[nCntFor,4] := nBaseBaix
					aBaseSE1[nCntFor,5] := nVlrEmis
					aBaseSE1[nCntFor,6] := nVlrBaix
					If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0 
						aBaseSE1[nCntFor,12] := NoRound(aBaseSE1[nCntFor,12]/nProp,nDecimal+1) 
						aBaseSE1[nCntFor,11] := Round(aBaseSE1[nCntFor,11]/nProp,nDecimal+1)
					EndIf
				EndIf
			Next nCntFor
		EndIf	
	Else
		If ( lQuery .And. Select(cAliasSD2)<>0 )
			dbSelectArea(cAliasSD2)
			dbCloseArea()
			dbSelectArea("SE1")
		EndIf
	EndIf
EndIf
If ( SE1->E1_TIPO $ MV_CRNEG ) .And. !("FINA040" $ SE1->E1_ORIGEM)
	//��������������������������������������������������������������Ŀ
	//� Verifica a filial de origem das notas de devolucao de Venda  �
	//����������������������������������������������������������������
	
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSF1))	
			cFilialSF1 := SE1->E1_FILORIG
		Endif	
	EndIf	
	If SE1->(FieldPos("E1_FILORIG")) > 0
		If !Empty(SE1->E1_FILORIG) .and. !(Empty(cFilialSD1))		
			cFilialSD1 := SE1->E1_FILORIG
		Endif	
	EndIf                     
	
	If Year(SE1->E1_EMISSAO)<2001
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
	Else
		cSerie := SE1->E1_SERIE
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Posiciona Registros                                          �
	//����������������������������������������������������������������
	dbSelectArea("SF1")
	dbSetOrder(1)
	If (!MsSeek(cFilialSF1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
		lContinua := .F.
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Calculo do Estorno da Comissao.                              �
	//�                                                              �
	//�1) Localiza-se a Nota Original                                �
	//�                                                              �
	//�2) Calcula a Comissao para a Nota Original                    �
	//�                                                              �
	//�3) Faz a Proporcao entre os valor da Mercadoria e os valores  �
	//�   da comissao.                                               �
	//�                                                              �
	//����������������������������������������������������������������
	dbSelectArea("SD1")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()!="AS/400" )
			SD1->(dbCommit())
			cAliasSD1 := "BFA440COMIS"
			lQuery := .T.
			cQuery := ""
			For nCntFor := 1 To Len(aStruSD1)
				cQuery += ","+aStruSD1[nCntFor][1]
			Next nCntFor
			
			cQuery := "SELECT "+SubStr(cQuery,2)
			cQuery += "  FROM "+RetSqlName("SD1")+" SD1 "
			cQuery += " WHERE SD1.D1_FILIAL  = '"+cFilialSD1+"'"
			cQuery += "   AND SD1.D1_DOC	 = '"+SE1->E1_NUM+"'"
			cQuery += "   AND SD1.D1_SERIE	 = '"+cSerie+"'"
			cQuery += "   AND SD1.D1_FORNECE = '"+SE1->E1_CLIENTE+"'"
			cQuery += "   AND SD1.D1_LOJA    = '"+SE1->E1_LOJA+"'"
			cQuery += "   AND "
			If cPaisLoc<>"BRA"
				cQuery += "SD1.D_E_L_E_T_<>'*' "
			Else
				cQuery += "    SD1.D_E_L_E_T_<>'*'"
				cQuery += "AND SD1.D1_ITEMORI<>'"+Space(Len(SD1->D1_ITEMORI))+"' "
			EndIF
			cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
			
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
			
			lContinua := !(cAliasSD1)->(Eof())
			For nCntFor := 1 To Len(aStruSD1)
				If ( aStruSD1[nCntFor][2]!="C" )
					TcSetField(cAliasSD1,aStruSD1[nCntFor][1],aStruSD1[nCntFor][2],aStruSD1[nCntFor][3],aStruSD1[nCntFor][4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		If (!MsSeek(cFilialSD1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		#IFDEF TOP
		EndIf
		#ENDIF
	aSemNota	:=	{}
	While ( !Eof() .And. cFilialSD1  == (cAliasSD1)->D1_FILIAL  .And.;
			SF1->F1_DOC 	 == (cAliasSD1)->D1_DOC	  .And.;
			SF1->F1_SERIE	 == (cAliasSD1)->D1_SERIE   .And.;
			SF1->F1_FORNECE == (cAliasSD1)->D1_FORNECE .And.;
			SF1->F1_LOJA	 == (cAliasSD1)->D1_LOJA )
		//��������������������������������������������������������������Ŀ
		//� Localiza a Nota de Saida - Item                              �
		//����������������������������������������������������������������
		dbSelectArea("SD2")
		dbSetOrder(3)
		MsSeek(cFilialSD2+(cAliasSD1)->D1_NFORI+(cAliasSD1)->D1_SERIORI+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+AllTrim((cAliasSD1)->D1_ITEMORI))
		If !SD2->(FOUND())
			//Carrega os items que nao tem nota original
			AAdd(aSemNota,(cAliasSD1)->D1_ITEM)
		Endif
		aBaseSD1 := {} // Inicializa Bases do Item
		//��������������������������������������������������������������Ŀ
		//� Posiciona no Nota Fiscal de Saida - Cabecalho                �
		//����������������������������������������������������������������
		dbSelectArea("SF2")
		dbSetOrder(1)
		MsSeek(cFilialSF2+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
		If Empty(SF2->F2_PREFIXO)			
			cPrefixo := Alltrim(Posicione("SX6",1,cFilialSF2+"MV_1DUPREF","X6_CONTEUD"))
			If Empty(cPrefixo) //Caso n�o exista o parametro na filial posicionada, pega o coteudo (GetMv)
				cPrefixo := &(GetMV("MV_1DUPREF"))
			EndIf
		Else
			cPrefixo := SF2->F2_PREFIXO
		EndIf
		//��������������������������������������������������������������Ŀ
		//� Posiciona no Titulo Financeiro                               �
		//����������������������������������������������������������������
		dbSelectArea("SE1")
		dbSetOrder(2)
		MsSeek(cFilialSE1+SF2->F2_CLIENTE+SF2->F2_LOJA+cPrefixo+SD2->D2_DOC)
		While ( !Eof() .And. cFilialSE1  == SE1->E1_FILIAL .And.;
				SE1->E1_CLIENTE == SF2->F2_CLIENTE .And.;
				SE1->E1_LOJA    == SF2->F2_LOJA .And.;
				SE1->E1_PREFIXO == cPrefixo .And.;
				SE1->E1_NUM		 == SF2->F2_DOC )
			If ( SE1->E1_TIPO $ MVNOTAFIS+cEspSes )
				//��������������������������������������������������������������Ŀ
				//� Calcula o Valor da Comissao para a Parcela                   �
				//����������������������������������������������������������������
				aBaseNCC := Fa440Comis(SE1->(Recno()),.F.,.T.,SD2->(RecNo()))
				For nCntFor := 1 To Len(aBaseNCC)
					cVendedor := aBaseNCC[nCntFor,1]
					nPos := aScan(aBaseSD1,{|x| x[1]==cVendedor})
					If ( nPos == 0 )
						aadd(aBaseSD1,{ 	aBaseNCC[nCntFor,1],;
							aBaseNCC[nCntFor,2],;
							aBaseNCC[nCntFor,3],;
							aBaseNCC[nCntFor,4],;
							aBaseNCC[nCntFor,5],;
							aBaseNCC[nCntFor,6],;
							aBaseNCC[nCntFor,7]})
					Else
						aBaseSD1[nPos,2] += aBaseNCC[nCntFor,2]
						aBaseSD1[nPos,3] += aBaseNCC[nCntFor,3]
						aBaseSD1[nPos,4] += aBaseNCC[nCntFor,4]
						aBaseSD1[nPos,5] += aBaseNCC[nCntFor,5]
						aBaseSD1[nPos,6] += aBaseNCC[nCntFor,6]
					EndIf
				Next nCntFor
			EndIf
			dbSelectArea("SE1")
			dbSkip()
		EndDo
		//������������������������������������������������������������������������Ŀ
		//� Aqui eh proporcionalizado as Bases da nota de saida com o item devol.  �
		//��������������������������������������������������������������������������
		For nCntFor := 1 To Len(aBaseSD1)
			aBaseSD1[nCntFor,2] := NoRound(aBaseSD1[nCntFor,2]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)		
			aBaseSD1[nCntFor,3] := Round(aBaseSD1[nCntFor,3]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
			aBaseSD1[nCntFor,4] := NoRound(aBaseSD1[nCntFor,4]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
			aBaseSD1[nCntFor,5] := (aBaseSD1[nCntFor,5]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL)
			aBaseSD1[nCntFor,6] := NoRound(aBaseSD1[nCntFor,6]*((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC)/SD2->D2_TOTAL,nDecimal+1)
		Next nCntFor
		//������������������������������������������������������������������������Ŀ
		//�Aqui eh somado as bases ja calculadas e como a NCC estorna os valores   �
		//�na emissao, adiciona-se a base da baixa na base da emissao.             �
		//��������������������������������������������������������������������������
		For nCntFor := 1 To Len(aBaseSD1)
			cVendedor := aBaseSD1[nCntFor,1]
			nPos := aScan(aBAseSE1,{|x| x[1] == cVendedor })
			If ( nPos == 0 )
				aadd(aBaseSE1,{ 	aBaseSD1[nCntFor,1],;
					aBaseSD1[nCntFor,2],;
					aBaseSD1[nCntFor,3]+aBaseSD1[nCntFor,4],0,;
					aBaseSD1[nCntFor,5]+aBaseSD1[nCntFor,6],0,0})
			Else
				aBaseSE1[nPos,2] += aBaseSD1[nCntFor,2]
				aBaseSE1[nPos,3] += aBaseSD1[nCntFor,3]+aBaseSD1[nCntFor,4]
				aBaseSE1[nPos,5] += aBaseSD1[nCntFor,5]+aBaseSD1[nCntFor,6]
			EndIf
		Next nCntFor
		dbSelectArea(cAliasSD1)
		dbSkip()
	EndDo
	If ( (Empty(aBaseSE1).Or. Len(aSemNota) > 0) .And. lRefaz .And. cPaisLoc<>"BRA")
		dbSelectArea("SE1")
		MsGoto(nRegistro)
		cSerie := If(Empty(SE1->E1_SERIE),SE1->E1_PREFIXO,SE1->E1_SERIE)
		dbSelectArea("SF1")
		dbSetOrder(1)
		If (!MsSeek(cFilialSF1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
			lContinua := .F.
		EndIf
		dbSelectArea("SE4")
		dbSetOrder(1)
		If (!MsSeek(cFilialSE4+SF1->F1_COND))
			lContinua := .F.
		EndIf
		dbSelectArea("SD1")
		dbSetOrder(1)
		#IFDEF TOP
			If ( TcSrvType()!="AS/400" )
				lQuery := .T.
				cAliasDev := "FA440COMIS"
				cAliasSF4 := "FA440COMIS"
				cQuery := ""
				For nCntFor := 1 To Len(aStruSD1)
					cQuery += ","+aStruSD1[nCntFor][1]
				Next nCntFor
				For nCntFor := 1 To Len(aStruSF4)
					cQuery += ","+aStruSF4[nCntFor][1]
				Next nCntFor  
				
				cQuery := "SELECT SD1.R_E_C_N_O_ SD1RECNO,"+SubStr(cQuery,2)
				cQuery += "  FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SF4")+" SF4 "
				cQuery += " WHERE SD1.D1_FILIAL   = '"+cFilialSD1+"'"
				cQuery += "   AND SD1.D1_DOC      = '"+SE1->E1_NUM+"'"
				cQuery += "   AND SD1.D1_SERIE    = '"+cSerie+"'"
				cQuery += "   AND SD1.D1_FORNECE  = '"+SE1->E1_CLIENTE+"'"
				cQuery += "   AND SD1.D1_LOJA	  = '"+SE1->E1_LOJA+"'"
				cQuery += "   AND SD1.D_E_L_E_T_  <>'*'"
				cQuery += "   AND SF4.F4_FILIAL   = '"+cFilialSF4+"'"
				cQuery += "   AND SF4.F4_CODIGO   = SD1.D1_TES"
				cQuery += "   AND SF4.D_E_L_E_T_<>'*' "
				cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
				
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDev)
				
				lContinua := !(cAliasDev)->(Eof())
				For nCntFor := 1 To Len(aStruSD1)
					If ( aStruSD1[nCntFor][2]!= "C" )
						TcSetField(cAliasDev,aStruSD1[nCntFor][1],aStruSD1[nCntFor][2],aStruSD1[nCntFor][3],aStruSD1[nCntFor][4])
					EndIf
				Next nCntFor
				For nCntFor := 1 To Len(aStruSF4)
					If ( aStruSF4[nCntFor][2]!="C" )
						TcSetField(cAliasSF4,aStruSF4[nCntFor][1],aStruSF4[nCntFor][2],aStruSD1[nCntFor][3],aStruSF4[nCntFor][4])
					EndIf
				Next nCntFor
			Else
		#ENDIF	
			If (!MsSeek(cFilialSD1+SE1->E1_NUM+cSerie+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))
				lContinua := .F.
			EndIf

			#IFDEF TOP
			EndIf	
			#ENDIF
		If ( lContinua )
			//��������������������������������������������������������������Ŀ
			//� Calculo da comissao por item de nota fiscal 			     �
			//�																 �
			//�1)O Valor do icms s/ frete e adiciona ao campo F2_VALICM, por �
			//�esta razao deve-se somar o vlr do icms dos itens e subtrair   �
			//�do total de icms (F2_VALICM) para apurar-se o vlr icms s/frete�
			//�																 �
			//�2)O mesmo ocorre para o valor do IPI sobre frete, Por esta ra-�
			//�zao e' calculado o valor do IPI sobre frete do item multipli- �
			//�cando-se o valor do frete do item pelo % de ipi do item. 	 �
			//�																 �
			//�3)O Valor do Icms Retido pode n�o estar no total da nota (F2_-�
			//�VALBRUT) por isto deve-se considerar o campo (D2_ICMSRET).	 �
			//�																 �
			//�4)O percentual da comissao dever ser considerado para cada i- �
			//�tem de nota fiscal pois ela pode ser diferente entre eles. O  �
			//�percentual gravado no E1_COMIS � sempre um valor aproximado e �
			//�nao deve ser considerado ser houver nota fiscal para o titulo.�
			//�																 �
			//�5)A Base da Comissao � o valor da mercadoria + o valor do ipi �
			//�+ o valor das despesas acessorias +  o icms solidario. Como e'�
			//�por item deve-se conhece-lo pelo item a item.				 �
			//����������������������������������������������������������������
			nTotal	  := 0
			nFrete	  := (SF1->F1_FRETE + SF1->F1_SEGURO + SF1->F1_DESPESA)
			nIcmFrete  := 0
			nSF2IcmRet :=0
			While ( !Eof() .And. (cAliasDev)->D1_FILIAL == cFilialSD1 .And.;
					(cAliasDev)->D1_DOC 	 == SE1->E1_NUM .And.;
					(cAliasDev)->D1_SERIE	 == cSerie .And.;
					(cAliasDev)->D1_FORNECE  == SE1->E1_CLIENTE .And.;
					(cAliasDev)->D1_LOJA	 == SE1->E1_LOJA	)

				If Ascan(aSemNota,(cAliasDev)->D1_ITEM) ==0
					(cAliasDev)->(DbSkip())
					Loop
				EndIf

				If ( !lQuery )
					dbSelectArea("SF4")
					dbSetOrder(1)
					MsSeek(cFilialSF4+(cAliasDev)->D1_TES)
				Else
					If cPaisLoc<>"BRA"
						SD1->(DbGoto((cAliasDev)->SD1RECNO))
					Endif
				EndIf
				cVend := "1"

				cVendedor := SF1->F1_VEND1

				nImp := 0				
				If cPaisLoc <> "BRA"
					SA3->(DbSetOrder(1))
					SA3->(DbSeek(xFilial()+cVendedor))
					aImp := TesImpInf(SD1->D1_TES)			
					cImp := IIf(SA3->(FieldPos("A3_COMIMP")) >0,SA3->A3_COMIMP,"N")
					nPerComis := SA3->A3_COMIS
					For nX :=1 to Len(aImp)
						If (cImp+aImp[nX][3] == "S1")
							nImp += SD1->(FieldGet(FieldPos(aImp[nX][2])))
						ElseIf (cImp+aImp[nX][3] == "N2")
							nImp -= SD1->(FieldGet(FieldPos(aImp[nX][2]))	)
						Endif
					Next	
				EndIf

				If ( !Empty(cVendedor) .And. (cAliasSF4)->F4_DUPLIC == "S" )
					If (cAliasDev)->(FieldPos("D1_COMIS"+cVend)) > 0 .And.;
						(cAliasDev)->(FieldGet((cAliasDev)->(FieldPos("D1_COMIS"+cVend)))) > 0 
						nPerComis := (cAliasDev)->(FieldGet((cAliasDev)->(FieldPos("D1_COMIS"+cVend))))
					Endif
					aadd(aSD2Vend,{ cVendedor,;
						(cAliasDev)->D1_TOTAL+nImp,;
						0,;
						0,;
						0,;
						(cAliasSF4)->F4_INCIDE,;
						(cAliasSF4)->F4_IPIFRET,;
						0,;
						nPerComis,;
						0,;
						If(lQuery,(cAliasDev)->SD1RECNO,(cAliasDev)->(RecNo()))})
				EndIf

				nTotal	  += (cAliasDev)->D1_TOTAL
				dbSelectArea(cAliasDev)
				dbSkip()
			EndDo
			If ( lQuery )
				dbSelectArea(cAliasDev)
				dbCloseArea()
				dbSelectArea("SD1")
			EndIf
			//��������������������������������������������������������������Ŀ
			//� Calculo da comissao pela nota.							     �
			//�																 �
			//�1)Apos calculado as bases de cada vendedor por item de nota   �
			//�deve-se aglutina-las formando uma unica base para toda a nota �
			//�fiscal.														 �
			//�																 �
			//�2)Como os valores serao aglutinados pode-se haver perda de de-�
			//�cimais por isto deve-se haver um controle para que a perda se-�
			//�ja adicionada a primeira parcela da nota. 					 �
			//����������������������������������������������������������������
			nMaxFor := Len(aSD2Vend)
			nPerComis:=0
			For nCntFor := 1 To nMaxFor
				If ( lPeperCom )
					nPerComis := ExecBlock("FIN440PE",.F.,.F.,{aSD2Vend[nCntFor][1]})
					If ( ValType(nPerComis)<>"N" )
						nPerComis := aSD2Vend[nCntFor][9]
					EndIf
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc )
					nBaseDif  := NoRound(nFrete*(1-(aSD2Vend[nCntFor,2]/nTotal)),nDecimal+1)
					nBaseDif  := nFrete - nBaseDif
					nRatFrete := nBaseDif
				Else
					nRatFrete := NoRound(nFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				EndIf
				nRatIcmFre:= 0
				nBaseSE1  := 0
				nPos		 := 0
				nRatIcmFre:= NoRound(nIcmFrete*aSD2Vend[nCntFor,2]/nTotal,nDecimal+1)
				nBaseSE1  := aSD2Vend[nCntFor,2]+aSD2Vend[nCntFor,4]+aSD2Vend[nCntFor,8]+nRatFrete
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aSD2Vend[nCntFor,1])

				nAlEmissao := SA3->A3_ALEMISS
				nAlBaixa := SA3->A3_ALBAIXA

				If ( SA3->A3_FRETE == "N" )
					nBaseSE1 -= ( nRatFrete )
				Endif
				
				If (IsInCallStack("FINA070") .or. IsInCallStack("FINA110")) .And. MV_PAR05 == 1 // Juros na Comiss�o
					nBaseBaix += nJuros
				EndIf
				
				If SA3->(FieldPos("A3_ACREFIN")) != 0  // Acrescimo Financeiro
					If ( SA3->A3_ACREFIN == "N" ) .and. aSD2Vend[nCntFor,10] > 0
						nBaseSE1 -= ( aSD2Vend[nCntFor,10] )
					EndIf
				Endif
				nPos := aScan(aBaseSE1,{|x| x[1] == aSD2Vend[nCntFor,1]})
				If Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"
					nBaseBaix := Round(nBaseSE1*nAlBaixa/100,nDecimal+1) 	// Base da Comissao na Baixa
				Else
					nBaseBaix:= 0
				EndIf
				nBaseEmis := nBaseSE1-nBaseBaix											// Base da Comissao na Emissao
				nVlrEmis  := Round(nBaseEmis*aSD2Vend[nCntFor,9]/100,nDecimal+1) // Valor da Comissao na Emissao
				nVlrBaix  := Round(nBaseBaix*aSD2Vend[nCntFor,9]/100,nDecimal+1) // Valor da Comissao na Baixa
				If ( Empty(nRegDevol) .Or. nRegDevol == aSD2Vend[nCntFor,11] )
					If ( nPos == 0 )
						aadd(aBaseSE1,{ aSD2Vend[nCntFor,1] ,;
							nBaseSE1				,;
							nBaseEmis				,;
							nBaseBaix				,;
							nVlrEmis				,;
							nVlrBaix				,;
							nPerComis		,;
							nPis,;
							nCsll,;
							nCofins})
					Else                	
						aBaseSE1[nPos,2] += nBaseSE1
						aBaseSE1[nPos,3] += nBaseEmis
						aBaseSE1[nPos,4] += nBaseBaix
						aBaseSE1[nPos,5] += nVlrEmis
						aBaseSE1[nPos,6] += nVlrBaix
						If aBaseSE1[nPos,7] == nPerComis
							aBaseSE1[nPos,7] := nPerComis
						Else
							aBaseSE1[nPos,7] := 0
						EndIf
					EndIf
				EndIf
			Next nCntFor
			//��������������������������������������������������������������Ŀ
			//� Calculo da comissao pelas parcelas.							 �
			//�																 �
			//�1)O SE3 � gravado por parcela e nao pela nota. assim e'neces- �
			//�ssario calcular a base da comissao para a parcela em questao. �
			//�																 �
			//�2)Aqui deve-se tomar o maximo cuidado com a Condi��o de pagto �
			//�pois se o Icms Solidario ou o Ipi for separado de alguma par- �
			//�cela deve-se considera esta separacao para calcular-se a me-  �
			//�lhor propor�ao possivel para a base da parcela. 				 �
			//����������������������������������������������������������������
			nMaxFor := Len(aBaseSE1)
			For nCntFor := 1 To nMaxFor
				nProp   := 0
				nVlrFat := xMoeda(SF1->F1_VALBRUT,SE1->E1_MOEDA,1,SE1->E1_EMISSAO)
				nVlrTit := SE1->E1_VLCRUZ
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aBaseSE1[nCntFor,1])
				If ( nVlrTit > 0 )
					nProp := nVlrFat / nVlrTit
				Else
					nProp := 0
				EndIf
				If (nProp != 0 )
					nBaseSE1 := NoRound(aBaseSE1[nCntFor,2]/nProp,nDecimal+1)
					nBaseEmis:= NoRound(aBaseSE1[nCntFor,3]/nProp,nDecimal+1)
					nBaseBaix:= NoRound(aBaseSE1[nCntFor,4]/nProp,nDecimal+1)
					nVlrEmis := Round(aBaseSE1[nCntFor,5]/nProp,nDecimal+1)
					nVlrBaix := Round(aBaseSE1[nCntFor,6]/nProp,nDecimal+1)
				Else
					nBaseSE1 := 0
					nBaseEmis:= 0
					nBaseBaix:= 0
					nVlrEmis := 0
					nVlrBaix := 0
				EndIf
				If ( SE1->E1_PARCELA $ cPrimParc .And. nBaseSE1 != 0 )
					//--> Calculo da Proporcao para a Base da Comissao
					nBaseDif := Round(nBaseSE1 * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,2]-nBaseDif
					aBaseSE1[nCntFor,2] := nBaseSE1+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Emissao

					nBaseDif := Round(nBaseEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,3]-nBaseDif
					aBaseSE1[nCntFor,3] := nBaseEmis+nBaseDif
					//--> Calculo da Proporcao para a Base da Comissao pela Baixa

					nBaseDif := Round(nBaseBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,4]-nBaseDif
					aBaseSE1[nCntFor,4] := nBaseBaix+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Emissao

					nBaseDif := Round(nVlrEmis * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,5]-nBaseDif
					aBaseSE1[nCntFor,5] := nVlrEmis+nBaseDif
					//--> Calculo da Proporcao para o Valor da Comissao pela Baixa

					nBaseDif := Round(nVlrBaix * nProp,nDecimal+1)
					nBaseDif := aBaseSE1[nCntFor,6]-nBaseDif
					aBaseSE1[nCntFor,6] := nVlrBaix+nBaseDif
				Else
					aBaseSE1[nCntFor,2] := nBaseSE1
					aBaseSE1[nCntFor,3] := nBaseEmis
					aBaseSE1[nCntFor,4] := nBaseBaix
					aBaseSE1[nCntFor,5] := nVlrEmis
					aBaseSE1[nCntFor,6] := nVlrBaix
				EndIf
			Next nCntFor
		Else
			If ( lQuery .And. Select(cAliasDev)<>0 )
				dbSelectArea(cAliasDev)
				dbCloseArea()
				dbSelectArea("SE1")
			EndIf
		EndIf
	Endif	
	If ( lQuery .And. Select(cAliasDev)<>0 )
		dbSelectArea(cAliasDev)
		dbCloseArea()
		dbSelectArea("SE1")
	EndIf
	If ( lQuery )
		dbSelectArea(cAliasSD1)
		dbCloseArea()
		dbSelectArea("SD1")
	EndIf
Else
	If Empty(nRegDevol)
		If ( Empty(aBaseSE1) .And. lRefaz )
			cVend := "1"
			For nCntFor := 1 To nVend
				
				SE1->(dbGoto(nRecnoOrig)) // pra caso o titulo parta de uma liquida��o
				cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
				nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))

				dbSelectArea("SE3")
				dbSetOrder(1)
				If DbSeek(XFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA) 

					// Verifica se o tipo da comissao bate com o tipo do titulo. Pode ocorrer dois titulos 
					// com o mesmo prefixo/numero/parcela/cliente/loja com tipos diferentes
					Do While 	SE3->( ! EoF() ) .And. ;
								SE3->( xFilial( "SE3" ) + E3_PREFIXO + E3_NUM + E3_PARCELA ) == ;
								SE1->( xFilial( "SE1" ) + E1_PREFIXO + E1_NUM + E1_PARCELA )
						If SE3->E3_TIPO == SE1->E1_TIPO .And.  SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend)))) ==  SE3->E3_VEND
							nPerComis := SE3->E3_PORC
							Exit
						EndIf
						SE3->( dbSkip() )
					EndDo

	            EndIf

	            MsUnLock()

				SE1->(dbGoto(nRegistro)) // volta ao recno original
				
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+cVendedor)
				If SE1->(FieldPos("E1_ALEMIS"+cVend))<>0//Nao criar no dicionario padrao
					nAlEmissao := SE1->(FieldGet(FieldPos("E1_ALEMIS"+cVend)))
				Else
					nAlEmissao := SA3->A3_ALEMISS
				EndIf
				If SE1->(FieldPos("E1_ALBAIX"+cVend))<>0//Nao criar no dicionario padrao
					nAlBaixa := SE1->(FieldGet(FieldPos("E1_ALBAIX"+cVend)))
				Else
					nAlBaixa := SA3->A3_ALBAIXA
				EndIf
	
				If ( !Empty(cVendedor) ) .and. !SE1->E1_TIPO $ MVABATIM
					If ( Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO" .AND. !"LOJA"$SE1->E1_ORIGEM ) .OR.;		 //Adriano - Comissoes
						( Alltrim(SE1->E1_Hist) == "VENDA EM DINHEIRO" .AND. (("LOJA"$SE1->E1_ORIGEM) .OR. "FATA701"$ SE1->E1_ORIGEM)) 
						If  lMultVend
							nBaseEmis := Round(SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))*(nAlEmissao/100),nDecimal+1)
							nBaseBaix := Round(SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))*(nAlBaixa/100),nDecimal+1)
						Else
							nBaseEmis := Round(SE1->E1_VLCRUZ*(nAlEmissao/100),nDecimal+1)
							nBaseBaix := Round(SE1->E1_VLCRUZ*(nAlBaixa/100),nDecimal+1)
						EndIf
					Else
						nBaseEmis := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend))))
						nBaseBaix := nBaseEmis
						If "LOJA"$SE1->E1_ORIGEM .AND. Alltrim(SE1->E1_Hist) <> "VENDA EM DINHEIRO"

							//Abate o percentual da administradora proporcionalmente
							If cMvComisCC <> "N"
								nBaseCC := 1-((SE1->E1_VLRREAL - SE1->E1_VLCRUZ) / SE1->E1_VLRREAL)
							Else
								nBaseCC	:= 1
							Endif

							If nAlEmissao > 0
								nBaseEmis := Round( (nBaseEmis * nBaseCC) * ( nAlEmissao / 100 ), nDecimal+1 )
								nBaseBaix := 0
							ElseIf nAlBaixa > 0
								nBaseEmis := 0
								nBaseBaix := Round( (nBaseBaix * nBaseCC) * ( nAlBaixa / 100 ), nDecimal+1 )
							Endif
						Endif
					Endif
					If SuperGetMv("MV_COMISIR") == "N" .And. lRecIRRF
						nBaseEmis -= Round(SE1->E1_IRRF*(nAlEmissao/100),nDecimal+1)
						nBaseBaix -= Round(SE1->E1_IRRF*(nAlBaixa/100),nDecimal+1)
					Endif
					If GetNewPar("MV_COMIINS","N") == "N"
						nBaseEmis -= Round(SE1->E1_INSS*(nAlEmissao/100),nDecimal+1)
						nBaseBaix -= Round(SE1->E1_INSS*(nAlBaixa/100),nDecimal+1)
					EndIf				
					If  lPccBxCr .and. !lCalEmis
						If 	!(SE5->E5_PRETPIS	$	"1;2")
						 		nPis		:= SE5->E5_VRETPIS
						 Else
						 		nPis		:=	0
						 EndIf
						 If 	!(SE5->E5_PRETCOF	$	"1;2")
						 		nCofins	:= SE5->E5_VRETCOF
						 Else
						      nCofins	:= 0
						 EndIf
						 If 	!(SE5->E5_PRETCSL	$	"1;2")
						 		nCsll		:= SE5->E5_VRETCSL
						 Else
						 		nCsll		:=	0
						 EndIf
					Elseif !lPccBxCr
						SumAbatRec( SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_MOEDA,'V', , ,,@nTotCsAbt,@nTotPisAbt,@nTotCofAbt)
						If nTotPisAbt > 0
							nPis		:= SE1->E1_PIS
						Endif
						If nTotCofAbt > 0
							nCofins	:= SE1->E1_COFINS
						Endif
						If nTotCsAbt > 0
							nCsll  	:= SE1->E1_CSLL
						Endif
					Endif
					
					If !lPccBxCr

						If GetNewPar("MV_COMIPIS","N") == "N"
							nBaseEmis -= Round(SE1->E1_PIS*(nAlEmissao/100),nDecimal+1)
							nBaseBaix -= Round(nPis*(nAlBaixa/100),nDecimal+1)
						EndIf
						If GetNewPar("MV_COMICOF","N") == "N"
							nBaseEmis -= Round(SE1->E1_COFINS*(nAlEmissao/100),nDecimal+1)
							nBaseBaix -= Round(nCofins*(nAlBaixa/100),nDecimal+1)
						EndIf
						If GetNewPar("MV_COMICSL","N") == "N"
							nBaseEmis -= Round(SE1->E1_CSLL*(nAlEmissao/100),nDecimal+1)
							nBaseBaix -= Round(nCsll*(nAlBaixa/100),nDecimal+1)
						EndIf
					Endif
					If SA3->A3_ISS == "N" .Or. (( SA3->A3_ISS == "S"  .And. (SE1->(FieldPos("E1_FRETISS"))>0 .And.;
						SE1->E1_FRETISS=="1") .And. SuperGetMV("MV_VRETISS",.F.,0) < SE1->E1_ISS))// Abate o ISS da base
						nBaseEmis -= Round(SE1->E1_ISS*(nAlEmissao/100),nDecimal+1)
						nBaseBaix -= Round(SE1->E1_ISS*(nAlBaixa/100),nDecimal+1)
					EndIf																	
					
					If (IsInCallStack("FINA070") .or. IsInCallStack("FINA110")) .And. MV_PAR05 == 1
						nBaseBaix += nJuros
					EndIf
		  
					    If (!lComiLiq) .and. ( FunName()== "FINA040" .Or. (FunName()$ "FINA440|FATA701|LOJA701" .and. Empty(SE1->E1_NUMLIQ))  )  
					     nVlrEmis  := Round(nBaseEmis * (nPerComis/100),nDecimal+1)
					     nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1)   
					    Else 
					     nVlrEmis  := 0
					     nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1) 
					    Endif  
					    
					    If (lComiliq)
					      nVlrEmis  := Round(nBaseEmis * (nPerComis/100),nDecimal+1)
					      nVlrBaix  := Round(nBaseBaix * (nPerComis/100),nDecimal+1)
					    Endif
					    
					
					// --> quer dizer que j� comissionou na liquidacao do titulo original
					If ( lComiLiq ) .and. !Empty(SE1->E1_NUMLIQ) 
						IF IsInCallStack("FA460CAN") .or. ( FunName() == "FINA460" )
						// Se "comiliq", considero comissao como se fosse na baixa e nao na emissao
							nVlrEmis := nVlrBaix
							nBaseEmis:= nBaseBaix
						Elseif !( FunName() == "FINA460" )
							nVlrBaix  	:= 0
							nBaseBaix	:= 0
						Endif
					Endif
					
					aadd(aBaseSE1,{ cVendedor,;
						SE1->E1_VLCRUZ,;
						nBaseEmis,;
						nBaseBaix,;
						nVlrEmis,;
						nVlrBaix,;
						nPerComis	,;
						nPis			,;
						nCsll			,;
						nCofins })
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
		EndIf
		If ( lGrava .And. lRefaz ).AND. !"LOJA"$SE1->E1_ORIGEM
			dbSelectArea("SE1")
			RecLock("SE1")
			cVend := "1"
			For nCntFor := 1 To Len(aBaseSE1)
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+aBaseSE1[nCntFor,1])
				dbSelectArea("SE1")
				If ( FieldGet(FieldPos("E1_VEND"+cVend)) == aBaseSE1[nCntFor,1] )
					FieldPut(FieldPos("E1_BASCOM"+cVend),aBaseSE1[nCntFor,2])
					If ( aBaseSE1[nCntFor,4] != 0 )
						FieldPut(FieldPos("E1_COMIS"+cVend),aBaseSE1[nCntFor,7])
					Endif
					FieldPut(FieldPos("E1_VALCOM"+cVend),aBaseSE1[nCntFor,5])
					If cPaisLoc == "PTG" .And. SFC->(FieldPos("FC_ABATCOM")) > 0
			   			FieldPut(FieldPos("E1_BASCOM"+cVend),aBaseSE1[nCntFor,12])			   			
			   			FieldPut(FieldPos("E1_VALCOM"+cVend),aBaseSE1[nCntFor,11])	
					EndIf
				Else
					If ( SE1->(FieldPos("E1_VEND"+cVend)) != 0 )
						nCntFor--	
					EndIf
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
			MsUnlock()
		EndIf
		If ( Empty(aBaseSE1) )
			cVend := "1"
			For nCntFor := 1 To nVend
				cVendedor := SE1->(FieldGet(SE1->(FieldPos("E1_VEND"+cVend))))
				nPerComis := SE1->(FieldGet(SE1->(FieldPos("E1_COMIS"+cVend))))
				dbSelectArea("SA3")
				dbSetOrder(1)
				MsSeek(xFilial()+cVendedor)
				If ( !Empty(cVendedor) )                                    
					//Trazer a base gravada na emissao, substituindo o zero, para evitar valores negativos
					If SA3->A3_ALBAIXA > 0
						nBaseSE1  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100)
						nBaseEmis := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) - (SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100))
						nBaseBaix := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend)))) * (SA3->A3_ALBAIXA / 100)
						nVlrEmis  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) - (SE1->(FieldGet(FieldPos("E1_BASCOM" + "1"))) * (SA3->A3_ALBAIXA / 100))
					Else
						nBaseSE1  := SE1->(FieldGet(FieldPos("E1_BASCOM" + "1")))
						nBaseEmis := 0
						nBaseBaix := SE1->(FieldGet(SE1->(FieldPos("E1_BASCOM"+cVend)))) * (SA3->A3_ALBAIXA / 100)
						nVlrEmis  := 0
					EndIf						
					// --> Quando o percentual da comissao estiver no produto o sistema
					// --> arredonda o percentual se for pago na baixa, caso haja muita
					// --> distorcao de valores deve-se alterar o numero de casas
					// --> decimais do campo E1_COMIS1..E1_COMIS(n)
					If  lPccBxCr .and. !lCalEmis
						If !(SE5->E5_PRETPIS $	"1;2")
							nPis		:= SE5->E5_VRETPIS
						Else
							nPis		:=	0
						EndIf
						If !(SE5->E5_PRETCOF	$	"1;2")
							nCofins	:= SE5->E5_VRETCOF
						Else
							nCofins	:= 0
						EndIf											 
						If !(SE5->E5_PRETCSL $	"1;2")
							nCsll		:= SE5->E5_VRETCSL
						Else
							nCsll		:=	0
						 EndIf					 							 
					Else    
					 	 nPis			:= SE1->E1_PIS
					 	 nCofins		:= SE1->E1_COFINS
					 	 nCsll		:= SE1->E1_CSLL
					Endif
					If SuperGetMv("MV_COMISIR") == "N" .and. !lMata460
						nBaseSE1 -= SE1->E1_IRRF        
						nBaseBaix -= SE1->E1_IRRF												
					Endif
					If GetNewPar("MV_COMIINS","N") == "N" .and. !lMata460
						nBaseSE1 -= SE1->E1_INSS     
						nBaseBaix -= SE1->E1_INSS    						
					EndIf
					If !lPccBxCr
						If GetNewPar("MV_COMIPIS","N") == "N" .and. !lMata460
							nBaseSE1 -= SE1->E1_PIS
							nBaseBaix -= nPis
						EndIf
						If GetNewPar("MV_COMICOF","N") == "N" .and. !lMata460
							nBaseSE1 -= SE1->E1_COFINS 
							nBaseBaix -= nCofins
						EndIf
						If GetNewPar("MV_COMICSL","N") == "N" .and. !lMata460
							nBaseSE1 -= SE1->E1_CSLL 
							nBaseBaix -= nCsll
						EndIf
					Endif
					If SA3->A3_ISS == "N" .Or. (( SA3->A3_ISS == "S"  .And. (SE1->(FieldPos("E1_FRETISS"))>0 .And.;
						SE1->E1_FRETISS=="1") .And. SuperGetMV("MV_VRETISS",.F.,0) < SE1->E1_ISS))// Abate o ISS da base
						nBaseEmis -= Round(SE1->E1_ISS*(SA3->A3_ALEMISS/100),nDecimal+1)
						nBaseBaix -= Round(SE1->E1_ISS*(SA3->A3_ALBAIXA/100),nDecimal+1)
					EndIf																	
					
					If (IsInCallStack("FINA070") .or. IsInCallStack("FINA110")) .And. MV_PAR05 == 1
						nBaseBaix += nJuros
					EndIf
					
					nVlrBaix  := nBaseBaix * (nPerComis/100)
					//No segundo elemento, a variavel nBaseSE1 foi substituida pelo campo SE1->E1_VLCRUZ (base bruta), pois apenas passava valores
					//negativos
					aadd(aBaseSE1,{ cVendedor,;
						SE1->E1_VLCRUZ,;
						nBaseEmis,;
						nBaseBaix,;
						nVlrEmis,;
						nVlrBaix,;
						nPerComis,;
						nPis		,;
						nCsll		,;
						nCofins})
				EndIf
				cVend := Soma1(cVend,1)
			Next nCntFor
		EndIf
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//� Restaura a Integridade dos dados de Entrada                  �
//����������������������������������������������������������������
RestArea(aAreaSE1)
RestArea(aAreaSE4)
RestArea(aAreaSF1)
RestArea(aAreaSF2)
RestArea(aAreaSF4)
RestArea(aAreaSD1)
RestArea(aAreaSD2) 
RestArea(aAreaSA1)
RestArea(aAreaSA3)
RestArea(aArea)

Return(aBaseSE1)
