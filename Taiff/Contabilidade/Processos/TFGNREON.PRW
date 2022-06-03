#Include "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGNREON    บAutor  ณNatalia Antonucci   บ Data ณ  22/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreparacao do meio magnetico GNREON - A Guia Nacional de    บฑฑ
ฑฑบ          ณRecolhimento de Tributos Estaduais, tem sido um documento   บฑฑ
ฑฑบ          ณde uso habitual por todos os contribuintes que realizam 	  บฑฑ
ฑฑบ          ณopera็๕es de vendas interestaduais sujeitas เ substitui็ใo  บฑฑ
ฑฑบ          ณtributแria.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                

User Function TFGNREON()
	Local	lEnd		:=	.F.
	Local	aWizard		:=	{}
	Local	cFileDest	:=	"GNREON.XML"
	Local cLaPerg		:=	"TFGNREON"

	TCriaSx1Perg( cLaPerg )
	If Pergunte(cLaPerg,.T.)
	
		Processa({||TPrGNREON(@lEnd, aWizard, @cFileDest)})
	
		If !Empty(cFileDest)
			MsgInfo("Arquivo "  + cFileDest + " gerado com sucesso!") //"Arquivo "###" gerado com sucesso!"
		Else
			MsgAlert("Nใo foi possํvel gerar o arquivo!") //"Nใo foi possํvel gerar o arquivo!"
		EndIf
	
	Endif
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrGNREON  บAutor  ณNatalia Antonucci   บ Data ณ  22/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao principal de processamento do arq. magnetico GNREON  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TPrGNREON(lEnd,aWizard,cFileDest)

	Local cFilDe   	:= ""
	Local cFilAte  	:= ""
	Local cDir     	:= ""
	Local cMvEstado	:= ""
	Local cAliasSF6	:= "SF6"
	Local cFiltro  	:= ""
	Local cIndex   	:= ""
	Local cXml     	:= ""
	Local cCampos  	:= ""
	lOCAL cCodR    	:= ""
	Local cMVSUBTRIB:= GetNewPar("MV_SUBTRIB")
	Local cMVUFGNRE := GetNewPar("MV_UFGNRE","")
	Local cCODRECAP := GetNewPar("MV_RECEAPU","")
	Local dDataDe  	:= ctod("//")
	Local dDataAte 	:= ctod("//")
	Local aFieldDt 	:=	{}
	Local nIndex   	:= 0
	Local nCount   	:= 0
	Local nLote    	:= 0
	Local nX	   	:= 0
	Local cInsc    	:= ""
	Local lGerou 	:= .F.
	Local lQuery    := .F.

	dDataDe		:= MV_PAR01
	dDataAte	:= MV_PAR02
	cDir     	:= Alltrim(MV_PAR03)
	cFilDe   	:= Alltrim(MV_PAR05)
	cFilAte  	:= Alltrim(MV_PAR06)

	cNfeDe   	:= Alltrim(MV_PAR07)
	cNfeAte  	:= Alltrim(MV_PAR08)
	cSerDe   	:= MV_PAR09
	cSerAte  	:= MV_PAR10

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTrata Diretorioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If (SubStr (cDir, Len (cDir), 1)<>"\")
		cDir	+=	"\"
	EndIf
	//cFileDest	:= AllTrim(aWizard[1][4])
	cFileDest	:= ALLTRIM(MV_PAR04)

                                                                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao da ordem das tabelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DbSelectArea ("SA1")	//Cadastro do Cliente
	SA1->(DbSetOrder (1))
	DbSelectArea ("SF6")	//GNRE
	SF6->(DbSetOrder (1))
	DbSelectArea ("SF3")    //Livros Fiscais
	SF3->(dbSetOrder(4))

	DbSelectArea ("SM0")
	SM0->(DbGoTop())
	SM0->(DbSeek(cEmpAnt+cFilDe, .T.))	//Pego a filial mais proxima
	Do While !SM0->(Eof ()) .And. (cEmpAnt==SM0->M0_CODIGO) .And. (SM0->M0_CODFIL>=cFilDe) .And. (SM0->M0_CODFIL<=cFilAte)
		cFilAnt := SM0->M0_CODFIL
		cMvEstado := GetMv("MV_ESTADO")
 	
		DbSelectArea("SF6")
		SF6->(DbSetOrder(1))
		#IFDEF TOP
			If (TcSrvType ()<>"AS/400")
				lQuery    := .T.
    		
				cAliasSF6	:=	GetNextAlias()
				aAdd(aFieldDt,"F6_DTVENC")
				aAdd(aFieldDt,"F6_DTPAGTO")
		  	
				cCampos := "%"
				If  SF6->(FieldPos("F6_DETRECE")) > 0  .AND. SF6->(FieldPos("F6_PROCESS")) > 0
					cCampos += ", SF6.F6_DETRECE, SF6.F6_PROCESS"
					cCampos += "%"
				EndIf
       				  		   	
				BeginSql Alias cAliasSF6
					SELECT SF6.F6_FILIAL, SF6.F6_DTARREC, SF6.F6_MESREF, SF6.F6_EST, SF6.F6_CODREC, SF6.F6_TIPOIMP, SF6.F6_VALOR, SF6.F6_ANOREF,
					SF6.F6_DOC, SF6.F6_NUMCONV, SF6.F6_CLIFOR, SF6.F6_LOJA, SF6.F6_NUMERO, SF6.F6_DTVENC, SF6.F6_DTPAGTO, SF6.F6_OPERNF,
					SF6.F6_SERIE, SF6.F6_MULTA, SF6.F6_JUROS, SF6.F6_ATMON, SF6.F6_CODPROD, SF6.F6_REF
					%Exp:cCampos%
					FROM
					%Table:SF6% SF6
					WHERE
					SF6.F6_FILIAL=%Exp:cFilAnt% AND
					SF6.F6_DTARREC>=%Exp:dDataDe% AND
					SF6.F6_DTARREC<=%Exp:dDataAte% AND
					SF6.F6_TIPOIMP = '3' AND
					SF6.F6_OPERNF = '2' AND
					SF6.F6_EST <> %Exp:cMvEstado% AND
					SF6.F6_DOC>=%Exp:cNfeDe% AND
					SF6.F6_DOC<=%Exp:cNfeAte% AND
					SF6.F6_SERIE>=%Exp:cSerDe% AND
					SF6.F6_SERIE<=%Exp:cSerAte% AND
					SF6.%NotDel%
					ORDER BY %Order:SF6%
				EndSql
				For nX := 1 To Len(aFieldDt)
					TcSetField(cAliasSF6,aFieldDt[nX],"D",8,0)
				Next nX
			Else
			#ENDIF
			cIndex	:= CriaTrab(NIL,.F.)
			cFiltro	:= 'F6_FILIAL=="'+cFilAnt+'".And.'
			cFiltro += 'DToS (F6_DTARREC)>="'+DToS (dDataDe)+'".And.DToS (F6_DTARREC)<="'+DToS (dDataAte)+'" '
			cFiltro += '.And. F6_TIPOIMP =="3" '
			cFiltro += '.And. F6_OPERNF =="2" '
			cFiltro += '.And. F6_EST <> "'+cMvEstado+'" '
			cFiltro += '.and. F6_DOC >= "'+cNfeDe+'" .AND. F6_DOC <= "'+cNfeAte+'" '
			cFiltro += '.and. F6_SERIE >= "'+cSerDe+'" .AND. F6_SERIE <= "'+cSerAte+'" '
			 
			IndRegua (cAliasSF6, cIndex, SF6->(IndexKey ()),, cFiltro)
			nIndex := RetIndex(cAliasSF6)
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSelectArea (cAliasSF6)
			dbSetOrder (nIndex+1)
			#IFDEF TOP
			Endif
		#ENDIF
			
		DbSelectArea (cAliasSF6)
		(cAliasSF6)->(DbGoTop ())
		ProcRegua ((cAliasSF6)->(RecCount ()))
		
		cNomeArq := cFileDest
		nLote := 1
		lGerou := .F.
		While !(cAliasSF6)->(Eof ())
			nCount := 0
			cXml	 :=	""
			cXml:= GrvCab(nLote,@cNomeArq)
			While !(cAliasSF6)->(Eof ()) .and. nCount < 50
				If (cAliasSF6)->(FieldPos("F6_PROCESS")) > 0 .and. !(cAliasSF6)->F6_PROCESS=="1"

					lGerou:= .T.
					If (cAliasSF6)->F6_EST$cMVUFGNRE

						cInsc := IESubTrib((cAliasSF6)->F6_EST)
						cCodR := IIf(!Empty(cCODRECAP), cCODRECAP,Alltrim((cAliasSF6)->F6_CODREC))
						SA1->(Dbseek(xFilial("SA1")+(cAliasSF6)->F6_CLIFOR+(cAliasSF6)->F6_LOJA))
						SF3->(dbSeek(xFilial("SF3")+(cAliasSF6)->F6_CLIFOR+(cAliasSF6)->F6_LOJA+(cAliasSF6)->F6_DOC+(cAliasSF6)->F6_SERIE))
		           	
						If (cAliasSF6)->F6_EST$cMVSUBTRIB .and. cCodR=="100048" .and. !Alltrim((cAliasSF6)->F6_CODREC)=="100099"

							cXml += MontaXML("TDadosGNRE",,,,,,5,.T.,.F.,.T.)
							cXml += MontaXML("c01_UfFavorecida",(cAliasSF6)->F6_EST,,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c02_receita",cCodR,"C",9,2,,9,.T.,.T.,.T.)
						
							If (cAliasSF6)->(FieldPos("F6_DETRECE")) > 0 .AND. !Empty((cAliasSF6)->F6_DETRECE)
								cXml += MontaXML("c25_detalhamentoReceita",AllTrim((cAliasSF6)->F6_DETRECE),"C",9,2,,9,.T.,.T.,.T.)
							Endif
					   	
							If (cAliasSF6)->F6_CODPROD > 0 .AND. (cAliasSF6)->F6_EST$"AL/GO/MA/MG/PI/RN/RO/SE/TO"
								cXml += MontaXML("c26_produto",(cAliasSF6)->F6_CODPROD,"N",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If !Empty((cAliasSF6)->F6_DOC)
								cXml += MontaXML("c04_docOrigem",(cAliasSF6)->F6_DOC,"C",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_VALOR > 0
								cXml += MontaXML("c06_valorPrincipal",(cAliasSF6)->F6_VALOR,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							Endif
					   
							If (cAliasSF6)->F6_VALOR .AND. (cAliasSF6)->F6_EST$"SC/"
								cXml += MontaXML("c06_valorPrincipal",(cAliasSF6)->F6_VALOR,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							Endif

							If (cAliasSF6)->F6_ATMON > 0 .or. (cAliasSF6)->F6_JUROS > 0 .or. (cAliasSF6)->F6_MULTA > 0
								cXml += MontaXML("c10_valorTotal",(cAliasSF6)->F6_ATMON+(cAliasSF6)->F6_JUROS+(cAliasSF6)->F6_MULTA,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							Endif
						
							cXml += MontaXML("c14_dataVencimento",StrZero (Year ((cAliasSF6)->F6_DTVENC), 4)+"-"+StrZero (Month ((cAliasSF6)->F6_DTVENC), 2)+"-"+StrZero (Day ((cAliasSF6)->F6_DTVENC), 2),"C",,,,9,.T.,.T.,.T.)
						
							If !Empty((cAliasSF6)->F6_NUMCONV)
								cXml += MontaXML("c15_convenio",(cAliasSF6)->F6_NUMCONV,"N",9,2,,9,.T.,.T.,.T.)
							Endif
					
							cXml += MontaXML("c17_inscricaoEstadualEmitente",cInsc,,,,,9,.T.,.T.,.T.)
						
							cXml += MontaXML("c33_dataPagamento",StrZero (Year ((cAliasSF6)->F6_DTPAGTO), 4)+"-"+StrZero (Month ((cAliasSF6)->F6_DTPAGTO), 2)+"-"+StrZero (Day ((cAliasSF6)->F6_DTPAGTO), 2),"C",,,,9,.T.,.T.,.T.)
						
							cXml += MontaXML("c05_referencia",,,,,,5,.T.,.F.,.T.)
						
							If (cAliasSF6)->F6_REF$"1" .AND. (cAliasSF6)->F6_EST$"AC/AM/BA/MA/MG/PE/RS/SE"
								cXml += MontaXML("periodo",0,"N",9,2,,9,.T.,.T.,.T.)
					   
							Endif
						
							If (cAliasSF6)->F6_MESREF > 0
								cXml += MontaXML("mes",StrZero((cAliasSF6)->F6_MESREF,2),"N",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_ANOREF > 0
								cXml += MontaXML("ano",(cAliasSF6)->F6_ANOREF,"N",9,2,,9,.T.,.T.,.T.)
							Endif
						
							cXml += MontaXML("c05_referencia",,,,,,5,.F.,.T.,.T.)
							cXml += MontaXML("TDadosGNRE",,,,,,5,.F.,.T.,.T.)
							cXml += Chr (13)+Chr (10)
						Elseif Alltrim((cAliasSF6)->F6_CODREC)=="100099"
							cXml += MontaXML("TDadosGNRE",,,,,,5,.T.,.F.,.T.)
							cXml += MontaXML("c01_UfFavorecida",(cAliasSF6)->F6_EST,,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c02_receita",AllTrim((cAliasSF6)->F6_CODREC),"C",9,2,,9,.T.,.T.,.T.)
							If (cAliasSF6)->(FieldPos("F6_DETRECE")) > 0 .AND. !Empty((cAliasSF6)->F6_DETRECE)
								cXml += MontaXML("c25_detalhamentoReceita",AllTrim((cAliasSF6)->F6_DETRECE),"C",9,2,,9,.T.,.T.,.T.)
							Endif
					   	
							If (cAliasSF6)->F6_CODPROD > 0 .AND. (cAliasSF6)->F6_EST$"AL/AM/BA/GO/MA/PE/PI/RN/SC/SE/TO/DF"
								cXml += MontaXML("c26_produto",(cAliasSF6)->F6_CODPROD,"N",9,2,,9,.T.,.T.,.T.)
							Endif
					   			
							If Len(AllTrim(SM0->M0_CGC))>=14
								cXml += MontaXML("c27_tipoIdentificacaoEmitente","1",,,,,9,.T.,.T.,.T.)
							Endif
					   			
							cXml += MontaXML("c03_idContribuinteEmitente",,,,,,5,.T.,.F.,.T.)
									
							If Len(AllTrim(SM0->M0_CGC))>=14
								cXml += MontaXML("CNPJ",SM0->M0_CGC,,,,,24,.T.,.T.,.T.)
							Endif
						
							cXml += MontaXML("c03_idContribuinteEmitente",,,,,,5,.F.,.T.,.T.)
						
							If !Empty(SF3->F3_ESPECIE)
								cXml += MontaXML("c28_tipoDocOrigem",Iif(Alltrim(SF3->F3_ESPECIE)=="NFA","01",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/SPED","10",Iif(Alltrim(SF3->F3_ESPECIE)$"CTR/CTE","07","00"))),"C",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If !Empty((cAliasSF6)->F6_DOC)
								cXml += MontaXML("c04_docOrigem",(cAliasSF6)->F6_DOC,"C",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_VALOR > 0
								cXml += MontaXML("c06_valorPrincipal",(cAliasSF6)->F6_VALOR,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							Endif
					   
							If (cAliasSF6)->F6_ATMON > 0 .or. (cAliasSF6)->F6_JUROS > 0 .or. (cAliasSF6)->F6_MULTA > 0
								cXml += MontaXML("c10_valorTotal",(cAliasSF6)->F6_ATMON+(cAliasSF6)->F6_JUROS+(cAliasSF6)->F6_MULTA,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_VALOR > 0 .AND. (cAliasSF6)->F6_EST$"SC/"
								cXml += MontaXML("c10_valorTotal",(cAliasSF6)->F6_VALOR,"N",9,2,"@R 9999999999999999999.99",9,.T.,.T.,.T.)
							Endif
						
							cXml += MontaXML("c14_dataVencimento",StrZero (Year ((cAliasSF6)->F6_DTVENC), 4)+"-"+StrZero (Month ((cAliasSF6)->F6_DTVENC), 2)+"-"+StrZero (Day ((cAliasSF6)->F6_DTVENC), 2),"C",,,,9,.T.,.T.,.T.)
						
							If !Empty((cAliasSF6)->F6_NUMCONV)
								cXml += MontaXML("c15_convenio",(cAliasSF6)->F6_NUMCONV,"N",9,2,,9,.T.,.T.,.T.)
							Endif
				
							cXml += MontaXML("c16_razaoSocialEmitente",SM0->M0_NOMECOM,,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c18_enderecoEmitente",FisGetEnd(SM0->M0_ENDENT)[1],,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c19_municipioEmitente",Substr(SM0->M0_CODMUN,3),,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c20_ufEnderecoEmitente",SM0->M0_ESTENT,,,,,9,.T.,.T.,.T.)
							cXml += MontaXML("c21_cepEmitente",SM0->M0_CEPENT,,,,,9,.T.,.T.,.T.)

							cTelefone:= substr(SM0->M0_TEL,4,Len(SM0->M0_TEL) )
							While At("-",cTelefone) != 0
								cTelefone := Stuff( cTelefone , At("-",cTelefone),1,"" )
							End
							cTelefone := Alltrim(cTelefone)
						
							cXml += MontaXML("c22_telefoneEmitente",cTelefone,,,,,9,.T.,.T.,.T.)
						
							If !Empty(SA1->A1_CGC) .And. Empty(SA1->A1_INSCR) .and. !(cAliasSF6)->F6_EST$"AC|BA|MG|PB|PE|RS"
								cXml += MontaXML("c34_tipoIdentificacaoDestinatario",Iif(!Empty(SA1->A1_CGC) .and. RetPessoa(SA1->A1_CGC) == "J","1","2"),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_CGC) .And. !Empty(SA1->A1_INSCR) .and. (cAliasSF6)->F6_EST$"AC|BA|MG|PB|PE"
								cXml += MontaXML("c34_tipoIdentificacaoDestinatario",Iif(!Empty(SA1->A1_CGC) .And. !Empty(SA1->A1_INSCR) .and. RetPessoa(SA1->A1_CGC) == "J","2","1"),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_CGC) .And. (cAliasSF6)->F6_EST$"PE|"
								cXml += MontaXML("c34_tipoIdentificacaoDestinatario",Iif(!Empty(SA1->A1_CGC) .and. RetPessoa(SA1->A1_CGC) == "J","1","2"),,,,,9,.T.,.T.,.T.)
							Endif
						
							if !Empty(SA1->A1_CGC) .and. ((cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO/BA" .OR. ((cAliasSF6)->F6_EST='MG' .AND. At("ISENT",SA1->A1_INSCR)!=0))
								cXml += MontaXML("c35_idContribuinteDestinatario",,,,,,5,.T.,.F.,.T.)
							Endif
				   	 	
							If !Empty(SA1->A1_CGC) .and. RetPessoa(SA1->A1_CGC) == "F" .And. ((cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO/BA" .OR. ((cAliasSF6)->F6_EST='MG' .AND. At("ISENT",SA1->A1_INSCR)!=0))
								cXml += MontaXML("CPF",SA1->A1_CGC,,,,,9,.T.,.T.,.T.)
							Endif
						
							If !Empty(SA1->A1_CGC) .and. RetPessoa(SA1->A1_CGC) == "J" .And. ((cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO/BA" .OR. ((cAliasSF6)->F6_EST='MG' .AND. At("ISENT",SA1->A1_INSCR)!=0))
								cXml += MontaXML("CNPJ",SA1->A1_CGC,,,,,9,.T.,.T.,.T.)
							Endif

							if !Empty(SA1->A1_CGC) .and. (cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO/BA"
								cXml += MontaXML("c35_idContribuinteDestinatario",,,,,,5,.F.,.T.,.T.)
							Elseif !Empty(SA1->A1_CGC) .and. (cAliasSF6)->F6_EST$"MG" .And. At("ISENT",SA1->A1_INSCR)!=0
								cXml += MontaXML("c35_idContribuinteDestinatario",,,,,,5,.F.,.T.,.T.)
							endif
						
							If !Empty(SA1->A1_INSCR) .and. (cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO/RS"
								cXml += MontaXML("c36_inscricaoEstadualDestinatario",SA1->A1_INSCR,,,,,9,.T.,.T.,.T.)
							Elseif !Empty(SA1->A1_INSCR) .and. (cAliasSF6)->F6_EST$"MG" .And. At("ISENT",SA1->A1_INSCR)!=0
							// COMENTARIO REAL
							Elseif !Empty(SA1->A1_INSCR) .and. (cAliasSF6)->F6_EST$"AC|BA|MG|PB|PE|SC|AP"
								cXml += MontaXML("c36_inscricaoEstadualDestinatario",SA1->A1_INSCR,,,,,9,.T.,.T.,.T.)
							Endif
						
							If !Empty(SA1->A1_NOME) .And. Empty(SA1->A1_INSCR) .and. (cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO"
								cXml += MontaXML("c37_razaoSocialDestinatario",Alltrim(SA1->A1_NOME),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_NOME) .And. (cAliasSF6)->F6_EST$"PE/RS"
								cXml += MontaXML("c37_razaoSocialDestinatario",Alltrim(SA1->A1_NOME),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_NOME) .And. (cAliasSF6)->F6_EST$"MG" .And. At("ISENT",SA1->A1_INSCR)!=0
								cXml += MontaXML("c37_razaoSocialDestinatario",Alltrim(SA1->A1_NOME),,,,,9,.T.,.T.,.T.)
							Endif
						
							If !Empty(SA1->A1_COD_MUN) .And. Empty(SA1->A1_INSCR) .and.(cAliasSF6)->F6_EST$"AL/AM/GO/MA/MT/PI/RN/RO/SE/TO"
								cXml += MontaXML("c38_municipioDestinatario",Alltrim(SA1->A1_COD_MUN),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_COD_MUN) .And. (cAliasSF6)->F6_EST$"PE/RS"
								cXml += MontaXML("c38_municipioDestinatario",Alltrim(SA1->A1_COD_MUN),,,,,9,.T.,.T.,.T.)
							ElseIf !Empty(SA1->A1_COD_MUN) .And. (cAliasSF6)->F6_EST$"MG" .And. At("ISENT",SA1->A1_INSCR)!=0
								cXml += MontaXML("c38_municipioDestinatario",Alltrim(SA1->A1_COD_MUN),,,,,9,.T.,.T.,.T.)
							Endif
						

							cXml += MontaXML("c33_dataPagamento",StrZero (Year ((cAliasSF6)->F6_DTPAGTO), 4)+"-"+StrZero (Month ((cAliasSF6)->F6_DTPAGTO), 2)+"-"+StrZero (Day ((cAliasSF6)->F6_DTPAGTO), 2),"C",,,,9,.T.,.T.,.T.)
						
							cXml += MontaXML("c05_referencia",,,,,,5,.T.,.F.,.T.)
					
							If (cAliasSF6)->F6_EST$"AM/BA/SE/AL"
								cXml += MontaXML("periodo",IIF((cAliasSF6)->F6_REF$"1" .OR. Empty((cAliasSF6)->F6_REF),"0",IIF((cAliasSF6)->F6_REF$"2","1",IIF((cAliasSF6)->F6_REF$"3","2",IIF((cAliasSF6)->F6_REF$"4","3",IIF((cAliasSF6)->F6_REF$"5","4",IIF((cAliasSF6)->F6_REF$"6","5","")))))),"C",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_MESREF > 0
								cXml += MontaXML("mes",StrZero((cAliasSF6)->F6_MESREF,2),"N",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_ANOREF > 0
								cXml += MontaXML("ano",(cAliasSF6)->F6_ANOREF,"N",9,2,,9,.T.,.T.,.T.)
							Endif
						
							If (cAliasSF6)->F6_EST$"DF"
								cXml += MontaXML("parcela",1,"N",9,2,,9,.T.,.T.,.T.)
							Endif
							cXml += MontaXML("c05_referencia",,,,,,5,.F.,.T.,.T.)
							__cChave := "NFE: " + (cAliasSF6)->F6_DOC + " "
							__cChave += "CNPJ: " + SA1->A1_CGC + " "
							__cChave += "IE: " + SA1->A1_INSCR + " "

							__cNomChave := Alltrim(Substr(SA1->A1_NOME,1,100 - Len(__cChave) )) + " "

							__cChave := "NFE: " + (cAliasSF6)->F6_DOC + " "
							__cChave += __cNomChave
							__cChave += "CNPJ: " + SA1->A1_CGC + " "
							__cChave += "IE: " + SA1->A1_INSCR + " "
							If (cAliasSF6)->F6_EST=="PB"
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","30",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","31","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",(cAliasSF6)->F6_DOC,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="MG"
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
				   		//cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","10",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","31","")),"C",9,2,,9,.T.,.T.,.T.)
		     				//cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
		     				//cXml += MontaXML("valor",(cAliasSF6)->F6_DOC,"C",9,2,,9,.T.,.T.,.T.)

								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","45",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","31","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)

								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="PR"
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","56",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","31","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="AP"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","47",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="PE"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","9",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="BA"
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","64",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="RS"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","74",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="SC"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","84",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="AM"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","12",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							ElseIf (cAliasSF6)->F6_EST=="RN"
								__cChave :=SF3->F3_CHVNFE
								cXml += MontaXML("c39_camposExtras",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.T.,.F.,.T.)
								cXml += MontaXML("codigo",Iif(Alltrim(SF3->F3_ESPECIE)=="SPED","97",Iif(Alltrim(SF3->F3_ESPECIE)$"NF/NFA","","")),"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("tipo","T","C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("valor",__cChave,"C",9,2,,9,.T.,.T.,.T.)
								cXml += MontaXML("campoExtra",,,,,,5,.F.,.T.,.T.)
								cXml += MontaXML("c39_camposExtras",,,,,,5,.F.,.T.,.T.)
							Endif
							cXml += MontaXML("TDadosGNRE",,,,,,5,.F.,.T.,.T.)
							cXml += Chr (13)+Chr (10)
						Endif
						nCount++
					Endif
	     
					SF6->( dbSetOrder(1))
					If SF6->(MsSeek(xFilial("SF6")+(cAliasSF6)->F6_EST+(cAliasSF6)->F6_NUMERO))
						RecLock("SF6",.F.)
						SF6->F6_PROCESS := "1"
						SF6->(MsUnlock())
					Endif
	       
				Endif
				(cAliasSF6)->(DbSkip())
	      	           
			EndDo
			If lGerou
				cXml += MontaXML("guias",,,,,,,.F.,.T.,.T.)
				cXml += MontaXML("TLote_GNRE",,,,,,,.F.,.T.,.T.)
				MemoWrite(cDir+cNomeArq,cXml)
				nLote++
				cNomeArq := cFileDest
			Endif
		EndDo

		#IFDEF TOP
			DbSelectArea(cAliasSF6)
			(cAliasSF6)->(DbCloseArea())
		#ENDIF

		SM0->(DbSkip())
	EndDo

	If !lQuery
		RetIndex("SF6")
		dbClearFilter()
		Ferase(cIndex+OrdBagExt())
	EndIf
                      
Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvCab   บAutor  ณNatalia Antonucci   บ Data ณ  22/05/12    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Cabecalho do XML                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function  GrvCab(nLote,cNomeArq)
	Local cMontXml := ""

	cNomeArq := cNomeArq + ALLTRIM(Str(nLote)) + ".XML"
 
	cMontXml += MontaXML("?xml",,,,,,,.T.,.F.,.T.,"version="+'"1.0"'+" encoding="+'"UTF-8" standalone="yes"'+" ?")
	cMontXml += MontaXML("TLote_GNRE",,,,,,,.T.,.F.,.T.,' xmlns="http://www.gnre.pe.gov.br"' )
	cMontXml += MontaXML("guias",,,,,,,.T.,.F.,.T.,.T.)

Return(cMontXml)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWizard    บAutor  ณNatalia Antonucci   บ Data ณ  22/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o Wizard da rotina.                                  บฑฑ
ฑฑบ          ณ Retorna .T. se finalizado com sucesso                      บฑฑ
ฑฑบ          ณ Retorna .F. se foi cancelado                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Wizard(cNomWiz)
	Local	aTxtApre	:=	{}
	Local	aPaineis	:=	{}
	Local	cTitObj1	:=	""
	Local	cTitObj2	:=	""
	Local	lRet		:=	.T.

//ฺฤฤฤฤฤฤฤฤฟ
//ณPainel 0ณ
//ภฤฤฤฤฤฤฤฤู
	aAdd (aTxtApre, "Parโmetros necessแrios.")
	aAdd (aTxtApre, "")
	aAdd (aTxtApre, "Preencha corretamente as informa็๕es solicitadas.")
	aAdd (aTxtApre, "Informa็๕es necessแrias para a gera็ใo do meio-magn้tico GNREON.")

//ฺฤฤฤฤฤฤฤฤฟ
//ณPainel 1ณ
//ภฤฤฤฤฤฤฤฤู
	aAdd (aPaineis, {})
	nPos	:=	Len (aPaineis)
	aAdd (aPaineis[nPos], "Preencha corretamente as informa็๕es solicitadas.")
	aAdd (aPaineis[nPos], "Parโmetros para Gera็ใo")
	aAdd (aPaineis[nPos], {})
//
	cTitObj1	:=	"Data de";								   		cTitObj2	:=	"Data at้"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});					aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	aAdd (aPaineis[nPos][3], {2,,,3,,,,});							aAdd (aPaineis[nPos][3], {2,,,3,,,,})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});							aAdd (aPaineis[nPos][3], {0,"",,,,,,})
//
	cTitObj1	:=	"Diret๓rio do Arquivo Destino";					cTitObj2	:=	"Nome do Arquivo Destino"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	cTitObj1	:=	Replicate ("X", 50);									cTitObj2	:=	Replicate ("X", 20)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});			aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,20})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
//
	cTitObj1	:=	"Filial de"; 											cTitObj2	:=	"Filial ate"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	cTitObj1	:=	Replicate ("X", 2);									cTitObj2	:=	Replicate ("X", 2)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,2});				aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,20})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
//aAdd (aPaineis[nPos][3], {1,"",,,,,,});						aAdd (aPaineis[nPos][3], {1,"",,,,,,})
//
	cTitObj1	:=	"Nota fiscal de"; 									cTitObj2	:=	"Nota fiscal ate"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	cTitObj1	:=	Replicate ("X", 9);									cTitObj2	:=	Replicate ("X", 9)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,9});				aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,9})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
//
	cTitObj1	:=	"Serie de"; 											cTitObj2	:=	"Serie ate"
	aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});				aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
	cTitObj1	:=	Replicate ("X", 3);									cTitObj2	:=	Replicate ("X", 3	)
	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,3});				aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,3})
	aAdd (aPaineis[nPos][3], {0,"",,,,,,});						aAdd (aPaineis[nPos][3], {0,"",,,,,,})
//


	lRet	:=	xMagWizard (aTxtApre, aPaineis, cNomWiz)
Return (lRet)
                                           
/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal
--------------------------------------------------------------------------------------------------------------
*/
Static Function TCriaSx1Perg(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 


//"Informa็๕es necessแrias para a gera็ใo do meio-magn้tico GNREON."

Aadd( aHelpPor, "Informe a data de inicio para gera็ใo do arquivo" )
Aadd( aHelpEng, "Informe a data de inicio para gera็ใo do arquivo" )
Aadd( aHelpSpa, "Informe a data de inicio para gera็ใo do arquivo" ) 
PutSx1(cPerg,"01"   ,"Data de?","",""	,"mv_ch1","D",08,0,0,"G","","","","",;
"mv_par01", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a data de termino para gera็ใo do arquivo" )
Aadd( aHelpEng, "Informe a data de termino para gera็ใo do arquivo" )
Aadd( aHelpSpa, "Informe a data de termino para gera็ใo do arquivo" ) 
PutSx1(cPerg,"02"   ,"Data ate?","",""	,"mv_ch2","D",08,0,0,"G","","","","",;
"mv_par02", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe o diret๓rio do Arquivo Destino, Ex.: C:\TEMP\" )
Aadd( aHelpEng, "Informe o diret๓rio do Arquivo Destino, Ex.: C:\TEMP\" )
Aadd( aHelpSpa, "Informe o diret๓rio do Arquivo Destino, Ex.: C:\TEMP\" ) 
PutSx1(cPerg,"03"   ,"Diretorio destino?","",""	,"mv_ch3","C",20,0,0,"G","","","","",;
"mv_par03", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe o nome do arquivo Destino" )
Aadd( aHelpEng, "Informe o nome do arquivo Destino" )
Aadd( aHelpSpa, "Informe o nome do arquivo Destino" ) 
PutSx1(cPerg,"04"   ,"Nome do arquivo?","",""	,"mv_ch4","C",20,0,0,"G","","","","",;
"mv_par04", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Filial de" )
Aadd( aHelpEng, "Informe a Filial de" )
Aadd( aHelpSpa, "Informe a Filial de" ) 
PutSx1(cPerg,"05"   ,"Filial de?","",""	,"mv_ch5","C",02,0,0,"G","","","","",;
"mv_par05", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Filial ate" )
Aadd( aHelpEng, "Informe a Filial ate" )
Aadd( aHelpSpa, "Informe a Filial ate" ) 
PutSx1(cPerg,"06"   ,"Filial ate?","",""	,"mv_ch6","C",02,0,0,"G","","","","",;
"mv_par06", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Nota fiscal de" )
Aadd( aHelpEng, "Informe a Nota fiscal de" )
Aadd( aHelpSpa, "Informe a Nota fiscal de" ) 
PutSx1(cPerg,"07"   ,"Nota fiscal de?","",""	,"mv_ch7","C",09,0,0,"G","","","","",;
"mv_par07", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Nota fiscal ate" )
Aadd( aHelpEng, "Informe a Nota fiscal ate" )
Aadd( aHelpSpa, "Informe a Nota fiscal ate" ) 
PutSx1(cPerg,"08"   ,"Nota fiscal ate?","",""	,"mv_ch8","C",09,0,0,"G","","","","",;
"mv_par08", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Serie de" )
Aadd( aHelpEng, "Informe a Serie de" )
Aadd( aHelpSpa, "Informe a Serie de" ) 
PutSx1(cPerg,"09"   ,"Serie de?","",""	,"mv_ch9","C",03,0,0,"G","","","","",;
"mv_par09", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
Aadd( aHelpPor, "Informe a Serie ate" )
Aadd( aHelpEng, "Informe a Serie ate" )
Aadd( aHelpSpa, "Informe a Serie ate" ) 
PutSx1(cPerg,"10"   ,"Serie ate?","",""	,"mv_ch10","C",03,0,0,"G","","","","",;
"mv_par10", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

RestArea(aAreaAnt)

Return()
                                           