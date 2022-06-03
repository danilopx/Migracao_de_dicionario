#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#DEFINE  CRLF        Chr(13)+Chr(10)

//Definicao dos elementos do array aTotVal
#DEFINE	TOTHEA	 1 //Total de Header
#DEFINE TOTDET	 2 //Total de Detalhe
#DEFINE TOTTRA	 3 //Total de Trailer
#DEFINE TOTUEN	 4 //Total de Unidade de Entrega
#DEFINE TOTDEP	 5 //Total de Departamento
#DEFINE TOTFUT	 6 //Total de Funcionarios de VT
#DEFINE TOTITT	 7 //Total de Itens de VT
#DEFINE TOTPAS	 8 //Total de Passagens
#DEFINE TOTQVR	 9 //Total de Vale Refeicao
#DEFINE TOTVVR	10 //Total de Valor de VR
#DEFINE TOTFUE	11 //Total de Funcionarios VR Eletronico
#DEFINE TOTFUA  12 //Total de Funcionarios VA Eletronico
#DEFINE TOTTVR  13 //Valor Total VR Eletronico
#DEFINE TOTTVA  14 //Valor Total VA Eletronico

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥GERATKT   ≥ Autor ≥ Ricardo Duarte Costa  ≥ Data ≥12.04.2010≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Geracao de Arquivo Texto para Aquisicao do Kit Beneficios  ≥±±
±±≥          ≥ da empresa Accor.                                          ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Sintaxe   ≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Parametros≥                                                            ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥         ATUALIZACOES SOFRIDAS DESDE A CONSTRUÄAO INICIAL.             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
User Function GeraTkt()

//?
// Declaracao de Variaveis                                             
//
Local aArea			:= GetArea()
Local aAreaSRA		:= SRA->(GetArea())
Local aAreaSM0		:= SM0->(GetArea())
Private lEnd        := .F.
Private lContinua   := .T.
Private lAbortPrint := .F.
Private lDetVT		:= .F.
Private lDetVR		:= .F.
Private lDetVRE		:= .F.
Private lDetVAE		:= .F.
Private nHdl		:= 0
Private nDafas		:= 0
Private cPerg		:= "KTBENEFICI"
Private cNomeArq	:= ""
Private cArq		:= ""
Private	cArqInd		:= ""

fChkPerg()
pergunte(cPerg,.F.)

// Montagem da tela de processamento.                                  
@ 200,001 TO 410,480 DIALOG oDlg TITLE OemToAnsi( "GeraÁ„o do Kit BenefÌcios" )
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Geracao de Arquivo Texto para AquisiÁ„o do Kit BenefÌcios.    "

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 70,188 BMPBUTTON TYPE 01 ACTION OkGeraTxt()

Activate Dialog oDlg Centered
 
	If nHdl > 0
		If fClose(nHdl)
			If (lDetVT .Or. lDetVR .Or. lDetVRE	.Or. lDetVAE) .And. lContinua //Flag de Detalhe de Funcionario com VT ou VR
			Aviso('AVISO','Gerado o arquivo ' + AllTrim(cNomeArq) + '...',{'OK'})	
			Else
				If fErase(cNomeArq) == 0
					If lContinua
					Aviso('AVISO','No existem registros a serem gravados. A geraÁ„o do arquivo ' + AllTrim(cNomeArq) + ' foi abortada ...',{'OK'})
					EndIf
				Else

				MsgAlert('Ocorreram problemas na tentativa de leitura do arquivo '+AllTrim(cNomeArq)+'.')

				EndIf
			EndIf
		Else

		MsgAlert('Ocorreram problemas no fechamento do arquivo '+AllTrim(cNomeArq)+'.')

		EndIf
	
	EndIf

//Fechamento do Arquivo Temporario
	If Select("TMPT") > 0
	TMPT->(dbCloseArea())
	Endif

	If File(cArq + ".DBF")
	
	//Seleciona Area
	dbSelectArea('TMPT')
	
	Ferase(cArq + ".DBF")
	Ferase (cArqInd+OrdBagExt())

	Endif
RestArea(aAreaSM0)
RestArea(aAreaSRA)
RestArea(aArea)
	
Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥OKGERATXT ∫Autor  ≥ PRIMA INFORMATICA  ∫ Data ≥  12/04/2010 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Funcao chamada pelo botao OK na tela inicial de processamen∫±±
±±∫          ≥ to. Executa a geracao do arquivo texto.                    ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥                                                            ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function OkGeraTxt()

Close(oDlg)

Processa({|| fRunTKT() },"Processando...")

Return

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fRunTkt   ∫Autor  ≥ PRIMA INFORMATICA  ∫ Data ≥  12/04/2010 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Processamento do Sistema                                   ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function fRunTkt()

//Variaveis
Private aTotVal		:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0} //Informacoes definidas no #DEFINE
Private lFlag		:= .F.
Private lTran		:= .F.
Private lAlim		:= .F.
Private lRef		:= .F.
Private cFilSRO		:= ""
Private cFilSRN		:= ""
Private cTexto		:= ""
Private cValAnt		:= ""
Private nTVlrServ	:= 0
Private nSeq		:= 1
Private nDtrab 		:= 0
Private nRef		:= 0
Private nX			:= 0
Private aSavRcc		:= {}
Private aLogVR		:= {}
Private aLogVA		:= {}
Private aLogVT		:= {}

//Variaveis das Perguntas
Pergunte(cPerg,.F.)

//Data de Referencia  		mv_par01
//Refeicao          		mv_par02
//Transporte           		mv_par03
//Alimentacao Eletronico    mv_par04
//Filial De            		mv_par05
//Filial Ate         		mv_par06
//Matricula De            	mv_par07
//Matricula Ate          	mv_par08
//Centro de Custo De      	mv_par09
//Centro de Custo Ate   	mv_par10
//Situacoes a Imprimir  	mv_par11
//Categorias a Imprimir 	mv_par12
//VT - Utilizacao De     	mv_par13
//VT - Utilizacao Ate    	mv_par14
//VT - Dt Entrega Minima 	mv_par15
//VT - Dt Entrega Maxima	mv_par16
//VR - Data Entrega      	mv_par17
//VR - Data Entrega      	mv_par18
//Perc do Kit            	mv_par19
//Valor Ponto de Entrega 	mv_par20
//Codigo do Cliente         mv_par21
//Cod. Cliente Eletronico   mv_par22
//Usurio do Sistema     	mv_par23
//Nome do Arquivo           mv_par24
//Ponto Eletronico - De  	mv_par25
//Ponto Eletronico - Ate 	mv_par26


dDataRef	:= If(Empty(mv_par01),dDataBase,mv_par01) // Periodo de Referencia
nRef		:= mv_par02
lTran		:= If(mv_par03==1,.T.,.F.)
lAlim		:= If(mv_par04==1,.T.,.F.)
cFilDe      := mv_par05
cFilAte     := mv_par06
cMatDe      := mv_par07
cMatAte     := mv_par08
cCcDe       := mv_par09
cCcAte      := mv_par10
cSit        := mv_par11
cCat        := mv_par12
dUtilDe     := mv_par13
dUtilAte    := mv_par14
dEntrMin    := mv_par15
dEntrMax    := mv_par16
dVrEntr     := mv_par17
dVaEntr     := mv_par13
nPercKit    := mv_par19
nVlPonto    := mv_par20
cCodcliVT	:= mv_par21
cCodcliTRE	:= mv_par22
cCodcliTAE	:= mv_par23
cUser		:= mv_par24
cNomeArq	:= mv_par25
dPontoDe    := mv_par26
dPontoAte   := mv_par27
cCDGsVR	    := MV_PAR28
cResponsav	:= mv_par29
cFilialAnt	:= cFilAnt
cFilResp	:= mv_par30
cFilAnt		:= cFilResp
cAnoMes     := Str(Year(dDataRef),4) + StrZero(Month(dDataRef),2)

	If lTran .And. (nRef != 3 .Or. lAlim)
	Aviso("AtenÁ„o","A geraÁ„o do vale transporte n„o deve ser feita em conjunto com a geraÁ„o de Vale AlimentaÁ„o e Vale RefeiÁ„o. Ajuste parametrizaÁ„o.",{"Ok"})
	Return
	endif

//-- CÛdigo forÁado para gerar o volume de cartıes antecipado para entrega
	If !lTran .And. .F.
	lGerarCartao:= MsgNoYes("Deseja gerar crÈdito de R$0,01 para geraÁ„o do cart„o?","Selecione a OpÁ„o")
	Else
	lGerarCartao:= .F.
	Endif

//Cria DBF
fCriaDBF()

//Cria o arquivo texto
	While .T.
		If File(cNomeArq)
			If (nAviso := Aviso('AVISO','Deseja substituir o ' + AllTrim(cNomeArq) + ' existente ?', {'Sim','No','Cancela'})) == 1
				If fErase(cNomeArq) == 0
				Exit
				Else
				MsgAlert('Ocorreram problemas na tentativa de ler o arquivo '+AllTrim(cNomeArq)+'.')
				EndIf
			ElseIf nAviso == 2
			Pergunte(cPerg,.T.)				
			Loop
			Else
			Return
			EndIf
		Else
		Exit
		EndIf
	EndDo

nHdl := fCreate(cNomeArq)

	If nHdl == -1
	MsgAlert('O arquivo '+AllTrim(cNomeArq)+' n„o pode ser criado! Verifique os par‚metros.','AtenÁ„o!')
	Return
	Endif

// Cadastro de empresas
SM0->(DbSeek(cEmpAnt+cFilResp))

//-- HistÛrico de BenefÌcios
aAreaSR0 := SR0->(getarea())
SR0->(dbsetorder(3))

//-- Cadastro de BenefÌcios VR e VA
RFO->(DbSetOrder(1))

//Posiciona Tabelas
dbSelectArea( "SRA" )
	If lTran
	dbSetOrder(2)
	Else
	dbSetOrder(3)
	Endif
dbGotop()
ProcRegua(SRA->(RecCount()))
			
//Posiciona Indice RCC
RCC->(dbSetOrder(1))
RCC->(dbGotop())

// Processamento
//While !SRA->(Eof()) .And. SRA->RA_FILIAL + SRA->RA_MAT <= cFilAte + cMatAte .And. lContinua
	While !SRA->(Eof()) .And. lContinua
	nDtrab  	:= F_ULTDIA(dDataRef)
	nDAfas		:= 0
		
		If lAbortPrint .Or. lEnd
			If Aviso('ATENAO','Deseja abandonar a GeraÁ„o do arquivo ' + AllTrim(AllTrim(cNomeArq)) + ' ?',{'Sim','N„o'}) == 1
			lContinua := .F.
			Exit
			EndIf
		Endif
		
	// Verifica Filtro Conforme Parametros
		If	SRA->RA_FILIAL < cFilDe .Or. SRA->RA_FILIAL > cFilAte .Or. ;
		SRA->RA_CC < cCcDe .Or. SRA->RA_CC > cCcAte .Or. ;
		SRA->RA_MAT < cMatDe .Or. SRA->RA_MAT > cMatAte .Or.;
		!(SRA->RA_SITFOLH $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat) .Or.;
		SRA->RA_SITFOLH =='D'
		SRA->(dbSkip())	
		Loop
			EndIf

	//Gera Vale Transporte  
		If lTran
		
		//?
		// Informaes de Vale Transporte (SR0 e SRN)                          
		//
		cFilSRN := If(Empty(xFilial('SRN')),xFilial('SRN'),SRA->RA_FILIAL)

			If SR0->(dbseek(xFilial('SR0',SRA->RA_FILIAL)+SRA->RA_MAT+"0"))
		
			//Verifica Dias de Vales > Zero
				If SR0->R0_QDIACAL <= 0
 
				SRA->(dbSkip())
			
				//Incrementa a regua
				IncProc('Gerando o Arquivo... ')
				Loop
				
				Endif
        
			//Pesquisa e Grava Unidade de Entrega
//			If !TMPT->(dbSeek("TTUN " + cEmpAnt+SRA->RA_FILIAL),Found())
				If !TMPT->(dbSeek("TTUN " + cEmpAnt+SRA->RA_FILPOST),Found())
				fGerTTUN()
				Endif
		
			//Pesquisa e Grava Departamento
				If !TMPT->(dbSeek("TTDE " + SRA->RA_CC),Found())
				fGerTTDE()
				Endif
			
			//Grava Funcionario
			fGerTTFU()
            nSeqFu_	:= 0
            lDetVT	:= .T.  //Flag de Detalhe de Funcionario com VT
            
				Do While !SR0->(eof()) .and. SR0->R0_FILIAL == SRA->RA_FILIAL .and. SR0->R0_MAT == SRA->RA_MAT .And. ;
						SR0->R0_TPVALE == '0'  .And. lContinua
	
						If SR0->R0_QDIACAL <= 0 .Or. SR0->R0_CODIGO == '99' .Or. !SRN->(dbSeek(cFilSRN + SR0->R0_CODIGO, .F.))
					SR0->(dbSkip())
					Loop
					Endif
				
					If Empty(SRN->RN_TKBILHE)
					SR0->(dbSkip())
					Loop
					EndIf
				
				cCodVT  := SRN->RN_TKBILHE	//	AllTrim(SRN->RN_ITEMPED)
				cOper	:= SRN->RN_TKOPERA	//	AllTrim(SRN->RN_OPER_)
				nVUnit  := SRN->RN_VUNIATU
				nSeqFu_	+= 1

				//Gera Itens de VT				
				fGerTTIT()
		
				SR0->(dbSkip())
				
				EndDo
			EndIf
				
		EndIf
		
		If nRef != 3 //Nao Gera Vale Refeicao

		//Verifica se Funcionario Vale Refeicao
			If SR0->(dbseek(xFilial('SR0',SRA->RA_FILIAL)+SRA->RA_MAT+"1")) .And. SR0->R0_CODIGO $cCDGsVR
			
			//-- N„o gera para funcion·rios sem c·lculo
				If SR0->R0_QDIACAL <= 0 .Or. SR0->R0_CODIGO == '99' .Or. SR0->R0_VALCAL <= 0
				SRA->(dbSkip())
				Loop
				Endif

			//?
			// Informacoes de Vales-Refeio (SRA e RFO)
			//
			lFlag := .F.
				If RFO->(DbSeek(xFilial("RFO",SRA->RA_FILIAL)+"1"+SR0->R0_CODIGO))
				lFlag := .T.
				End
				
				If lFlag
				
				//Quantidade, Valor)
				nQtdRef := SR0->R0_QDIACAL
				nValRef := SR0->R0_VALCAL
					
					If lGerarCartao
					nTotBen	:= 0.01
					Else
					nTotBen := nValRef
					Endif
				
				lFlag := .F.

					If nRef == 1 .And. nTotBen > 0 //Vale Refeicao Papel
				
					//Pesquisa e Grava Unidade de Entrega
//					If !TMPT->(dbSeek("TR012" + cEmpAnt + cFilAnt),Found())
						If !TMPT->(dbSeek("TR012" + cEmpAnt + SRA->RA_FILPOST),Found())
						fGerTR012()
						Endif
				
					//Gera Item Funcionario
					fGerTR013()
					lDetVR := .T. //Flag de Detalhe de Funcionario com VR
				
					ElseIf nRef == 2 .And. nTotBen > 0 //Vale Refeicao Eletronico

					//Pesquisa e Grava Unidade de Entrega
//					If !TMPT->(dbSeek("TRE  " + cEmpAnt + cFilAnt),Found())
						If !TMPT->(dbSeek("TRE  " + cEmpAnt + SRA->RA_FILPOST),Found())
						fGerTRE()
						Endif
					
					//Gera Item Funcionario
					fGerTRF()
					lDetVRE := .T. //Flag de Detalhe de Funcionario com VR Eletronico
				
					Endif
				
				EndIf
		
			Endif
    
		Endif
	
	//Vale Alimentao (Cesta Basica)
		If lAlim
		
		//Verifica se Funcionario Vale Refeicao
			If SR0->(dbseek(xFilial('SR0',SRA->RA_FILIAL)+SRA->RA_MAT+"2"))
			
			//-- N„o gera para funcion·rios sem c·lculo
				If SR0->R0_QDIACAL <= 0 .Or. SR0->R0_CODIGO == '99' .Or. SR0->R0_VALCAL <= 0
				SRA->(dbSkip())
				Loop
				Endif

			//?
			// Informacoes de Vales-Refeio (SRA e RFO)
			//
			lFlag := .F.
				If RFO->(DbSeek(xFilial("RFO",SRA->RA_FILIAL)+"2"+SR0->R0_CODIGO))
				lFlag := .T.
				End
				
				If lFlag
				
				//Valor Cesta
				nValRef := SR0->R0_VALCAL
				
					If lGerarCartao
					nTotBen	:= 0.01
					Else
					nTotBen := nValRef
					//-- Caso seja o mÍs de admiss„o do funcion·rio dever· ser dobrado o valor do ticket alimentaÁ„o
//			      	If AnoMes(MonthSub(dDataRef,1)) == AnoMes(SRA->RA_ADMISSA,6) .And. Day(SRA->RA_ADMISSA) <= 15
//						nTotBen += nValRef
//					Endif
					Endif
				
	        	lFlag := .F.
	                            
					If nTotBen > 0
	    		
					//Pesquisa e Grava Unidade de Entrega
//					If !TMPT->(dbSeek("TRA  " + cEmpAnt + cFilAnt),Found())
						If !TMPT->(dbSeek("TRA  " + cEmpAnt + SRA->RA_FILPOST),Found())
						fGerTAE()
						Endif
				
					//Gera Item Funcionario
					fGerTAF()
					lDetVAE := .T. //Flag de Detalhe de Funcionario com VA Eletronico
					
					Endif
								        
				Endif
	        
			Endif
	
		Endif
	
	SRA->(dbSkip())

	//?
	// Incrementa a regua                                                  
	//
	IncProc('Gerando o Arquivo... ')
		
	Enddo

//Grava Arquivo
	If (lDetVT .Or. lDetVR .Or. lDetVRE .Or. lDetVAE) //Flag de Detalhe de Funcionario com VT,VR (Papel e Eletronico) ou VA Eletronico

	//Header do Arquivo
	fGerLSUP5()

		If lDetVT //Funcionario com Detalhe de VT

		//Header do Arquivo de VT
		fGerT()
    
		//Calculo do Valor do Servico
		nTVlrServ := (nPercKit * aTotVal[TOTPAS]) + (aTotVal[TOTUEN] * nVlPonto)
	
		//Registro de Pedido
		fGerTTPE()
		//Unidade de Entrega	
			If TMPT->(dbSeek("TTUN"),Found())
				While TMPT->TIPREG = "TTUN"
				fGravaReg(AllTrim(TMPT->TEXTO))
				TMPT->(dbSkip())
				Enddo
			Endif

		//Departamento			
			If TMPT->(dbSeek("TTDE"),Found())
				While TMPT->TIPREG = "TTDE"
				fGravaReg(AllTrim(TMPT->TEXTO))
				TMPT->(dbSkip())
				Enddo
			Endif
	
		//Funcionarios
			If TMPT->(dbSeek("TTFU"),Found())
				While TMPT->TIPREG = "TTFU"
				fGravaReg(AllTrim(TMPT->TEXTO))
				TMPT->(dbSkip())
				Enddo
			Endif

		//Item de Vale Transporte
			If TMPT->(dbSeek("TTIT"),Found())
				While TMPT->TIPREG = "TTIT"
				fGravaReg(AllTrim(TMPT->TEXTO))
				TMPT->(dbSkip())
				Enddo
			Endif
	     
		//Trailler de VT
		fGerTT99()
	    
		Endif
	          
		If lDetVR //Funcionario com Detalhe de VR

		//Header do Vale Refeicao
		fGerTR010()
	
		//Unidades de entrega de VR
			If TMPT->(dbSeek("TR012"),Found())
				While TMPT->TIPREG = "TR012"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif
	
		//Item de Vale Refeicao
			If TMPT->(dbSeek("TR013"),Found())
				While TMPT->TIPREG = "TR013"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif

		//Trailler de VR
		fGerTR019()
		Endif
	
		If lDetVRE //Funcionario com Detalhe de VR Eletronico

		//Inicia Sequencia
		nSeq	:= 1
				
		//Header do Vale Refeicao
		fGerHTRE()
	
		//Unidades de entrega de VR
			If TMPT->(dbSeek("TRE"),Found())
				While TMPT->TIPREG = "TRE"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif
	
		//Item de Vale Refeicao
			If TMPT->(dbSeek("TRF"),Found())
				While TMPT->TIPREG = "TRF"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif

		//Trailler de VR
		fGerTTRE()
		
		Endif

		If lDetVAE //Funcionario com Detalhe de VA Eletronico

		//Inicia Sequencia
		nSeq	:= 1
				
		//Header do Vale Alimentacao
		fGerHTAE()
	
		//Unidades de entrega de VA
			If TMPT->(dbSeek("TRA"),Found())
				While TMPT->TIPREG = "TRA"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif
	
		//Item de Vale Alimentacao
			If TMPT->(dbSeek("TAF"),Found())
				While TMPT->TIPREG = "TAF"
				cTexto	:= AllTrim(TMPT->TEXTO)
				cTexto 	+= StrZero(nSeq,5) + CRLF
				fGravaReg(cTexto)
				TMPT->(dbSkip())
				nSeq	+= 1
				Enddo
			Endif

		//Trailler de VA
		fGerTTAE()
		
		Endif

		
	//Trailler do Arquivo
	fGerLSUP9()
	
	Endif

cFilAnt	:= cFilialAnt

Return	    		

//Fim da Rotina

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fGerT     ∫Autor  ≥ PRIMA INFORMATICA  ∫ Data ≥  12/04/2010 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ Gera Header T                                              ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function fGerT()

cTexto := fGerStr(4,"T")                // 001 - 004 -> Tipo do Pacote
cTexto += "A"                           // 005 - 005 -> Ordem do Kit
cTexto += GravaData(dDataBase,.F.,8)    // 006 - 013 -> Data da Geracao
cTexto += "V4.0"                        // 014 - 017 -> Ordem do Kit
cTexto += Space(60)                     // 018 - 077 -> Brancos
cTexto += CRLF

aTotVal[TOTHEA] += 1

fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*


?
Programa  fGerTTPE  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TTPE                                         
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTPE()

	cTexto := "TTPE"                                          // 001 - 004 -> Tipo do Produto
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' ) // 005 - 022 -> Cnpj Principal
	cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
//cTexto += "K."+Dtoc(dDataRef)                             // 023 - 032 -> Numero do Pedido
	cTexto += StrZero(aTotVal[TOTUEN],4)                      // 033 - 036 -> Qde Unidades Pedido
	cTexto += StrZero(aTotVal[TOTDEP],4)                      // 037 - 040 -> Qde Deptos Pedido
	cTexto += StrZero(aTotVal[TOTFUT],5)                      // 041 - 045 -> Qde Funcionario Pedido
	cTexto += StrZero(aTotVal[TOTITT],6)                      // 046 - 051 -> Qde Itens Pedido
	cTexto += Transform(nTVlrServ,'9999999999999.99')         // 052 - 067 -> Valor Servicos Pedido
	cTexto += Transform(aTotVal[TOTPAS],'9999999999999.99')   // 068 - 083 -> Valor Bilhetes Pedido
	cTexto += GravaData(dDataBase,.F.,8)                      // 084 - 091  -> Data de Geracao
	cTexto += " "                                             // 092 - 092 -> Espacos
	cTexto += GravaData(dUtilDe,.F.,8)                        // 093 - 100  -> Periodo Utilizacao De
	cTexto += GravaData(dUtilAte,.F.,8)                       // 101 - 108  -> Periodo Utilizacao Ate
	cTexto += Transform(nPercKit,'999999999.99')              // 109 - 120 -> Preco de 01 Kit
	cTexto += Transform(nVlPonto,'999999999.99')              // 121 - 132 -> Preco por Ponto Entrega
	cTexto += "N"                                             // 133 - 133 -> Tipo do Pedido
	cTexto += StrZero(aTotVal[TOTUEN],4)                      // 134 - 137 -> Qde Unidades Pagas
	cTexto += "A"                                             // 138 - 138 -> Ordem do Pedido TT
	cTexto += "P"                                             // 139 - 139 -> Tipo Rateio Entregas
	cTexto += "%  "                                           // 140 - 142 -> Moeda do Kit
	cTexto += "R$ "                                           // 143 - 145 -> Moeda da Entrega
	cTexto += CRLF

	aTotVal[TOTDET] += 1

	fGravaReg(AllTrim(cTexto))

Return


/*


?
Programa  fGerTTUN  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TTUN                                         
                                                                      
?
Uso        AP7                                                        
?

*/
Static Function fGerTTUN()

/*
cTexto := "TTUN"                                                // 001 - 004 -> Tipo de Registro
cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' )       // 005 - 022 -> CNPJ
cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
cTexto += fGerZero(6,cEmpAnt+SRA->RA_FILIAL)                     // 033 - 038 -> Codigo Un. Entrega
cTexto += fGerStr(26,SM0->M0_NOMECOM)                           // 039 - 064 -> Nome Uni.Entrega
cTexto += fGerStr(4,"R")                                        // 065 - 068 -> Tipo Logradouro
cTexto += fGerStr(30,SM0->M0_ENDCOB)                               // 069 - 098 -> Nome do Logradouro
cTexto += fGerZero(6,"0")                                // 099 - 104 -> Numero do Logradouro
cTexto += fGerStr(10,SM0->M0_COMPCOB)                           // 105 - 114 -> Complemento do Logradouro
cTexto += fGerStr(15,SM0->M0_BAIRCOB)                           // 115 - 129 -> Bairro
cTexto += fGerStr(25,SM0->M0_CIDCOB)                            // 130 - 154 -> Municipio
cTexto += Subst(SM0->M0_CEPCOB,1,5) + "-" + Subst(SM0->M0_CEPCOB,6,3) // 155 - 163 -> CEP
cTexto += SM0->M0_ESTCOB                                            // 164 - 165 -> Estado
cTexto += GravaData(dEntrMin,.F.,8)                             // 166 - 173 -> Data Minima Entrega
cTexto += GravaData(dEntrMax,.F.,8)                             // 174 - 181 -> Data Maxima Entrega
cTexto += fGerStr(20,cResponsav)                           // 182 - 201 -> Responsavel Recebimento
cTexto += fGerZero(11,strtran("0"+substr(SM0->M0_TEL,3),"-",""))              // 202 - 212 -> Fone Contato
cTexto += fGerZero(4,"0")                                       // 213 - 216 -> Ramal
cTexto += "S"                                                   // 217 - 217 -> Lista de Assinatura
cTexto += Space(40)                                             // 218 - 257 -> Reservado
cTexto += "S"                                                   // 258 - 258 -> Separacao por Departamento
cTexto += CRLF
*/

//-- Cadastro de unidades de entrega
	SZK->(DbSetOrder(1))
	SZK->(Dbseek(xFilial("SZK")+SRA->RA_FILPOST))

	cTexto := "TTUN"                                                // 001 - 004 -> Tipo de Registro
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' )       // 005 - 022 -> CNPJ
	cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,cEmpAnt+cFilAnt)							// 033 - 038 -> Codigo Un. Entrega
	cTexto += fGerStr(26,SM0->M0_NOMECOM)                           // 039 - 064 -> Nome Uni.Entrega
	cTexto += fGerStr(4,"R")                                        // 065 - 068 -> Tipo Logradouro
	cTexto += fGerStr(30,SZK->ZK_LOGRADO)                           // 069 - 098 -> Nome do Logradouro
	cTexto += fGerZero(6,SZK->ZK_NUMERO)                            // 099 - 104 -> Numero do Logradouro
	cTexto += fGerStr(10,SZK->ZK_COMPLEM)                           // 105 - 114 -> Complemento do Logradouro
	cTexto += fGerStr(15,SZK->ZK_BAIRRO)                            // 115 - 129 -> Bairro
	cTexto += fGerStr(25,SZK->ZK_CIDADE)                            // 130 - 154 -> Municipio
	cTexto += Subst(SZK->ZK_CEP,1,5) + "-" + Subst(SZK->ZK_CEP,6,3) // 155 - 163 -> CEP
	cTexto += SZK->ZK_ESTADO                                        // 164 - 165 -> Estado
	cTexto += GravaData(dEntrMin,.F.,8)                             // 166 - 173 -> Data Minima Entrega
	cTexto += GravaData(dEntrMax,.F.,8)                             // 174 - 181 -> Data Maxima Entrega
	cTexto += fGerStr(20,cResponsav)                                // 182 - 201 -> Responsavel Recebimento
	cTexto += fGerZero(11,strtran("0"+substr(SM0->M0_TEL,3),"-",""))// 202 - 212 -> Fone Contato
	cTexto += fGerZero(4,"0")                                       // 213 - 216 -> Ramal
	cTexto += "S"                                                   // 217 - 217 -> Lista de Assinatura
	cTexto += Space(40)                                             // 218 - 257 -> Reservado
	cTexto += "S"                                                   // 258 - 258 -> Separacao por Departamento
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTUN"
//	TMPT->CODIGO	:= cEmpAnt+cFilAnt
		TMPT->CODIGO	:= cEmpAnt+SRA->RA_FILPOST
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTUEN] += 1
		aTotVal[TOTDET] += 1
	Endif

Return

//Fim da Rotina

/*


?
Programa  fGerTTDE  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TTDE                                         
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTDE()

//Pesquisa Setor
//SI3->(dbSeek(xFilial("SI3") + SRA->RA_CC))
	CTT->(dbSeek(xFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC))

//Departamento
	cTexto := "TTDE"                                             // 001 - 004 -> Tipo de Produto
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' )    // 005 - 022 -> CNPJ
	cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
//cTexto += "K."+Dtoc(dDataRef)                                // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,cEmpAnt+SRA->RA_FILIAL)                // 033 - 038 -> Codigo Un. Entrega
	cTexto += fGerZero(6,CTT->CTT_CUSTO)                         // 039 - 044 -> Codigo Departamento
	cTexto += fGerStr(26,CTT->CTT_DESC01)                          // 045 - 070 -> Nome Departamento
	cTexto += Space(20)                                          // 071 - 090 -> Reservado
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' )    // 091 - 108 -> CNPJ de Faturamento
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTDE"
		TMPT->CODIGO	:= CTT->CTT_CUSTO
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTDEP]	+= 1
		aTotVal[TOTDET]	+= 1
	Endif

Return

//Fim da Rotina

/*


?
Programa  fGerTTFU  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TTFU                                         
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTFU()

	cTexto := "TTFU"                                          // 001 - 004 -> Tipo do Produto
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' ) // 005 - 022 -> Cnpj Principal
	cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
//cTexto += "K."+Dtoc(dDataRef)                             // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,cEmpAnt+SRA->RA_FILIAL)                     // 033 - 038 -> Codigo da Unidade
	cTexto += fGerZero(6,SRA->RA_CC)                     // 039 - 044 -> Codigo do Depto
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)  	  // 045 - 052 -> Codigo do Funcionario
	cTexto += fGerStr(30,SRA->RA_NOME)                        // 057 - 086 -> Nome do Funcionario
//cTexto += fGerStr(10,STRTRAN(SRA->RA_RG,".",""),1,10)     // 087 - 096 -> Nro RG do funcionrio (comentado por Gilberto (27/04/2020), chamada da funÁ„o fGerStr passando mais par‚metros do que a funÁ„o requer)
	cTexto += fGerStr(10,STRTRAN(SRA->RA_RG,".",""))     // 087 - 096 -> Nro RG do funcionrio
	cTexto += fGerZero(11,SRA->RA_CIC)                        // 097 - 107 -> Nro CPF do funcionrio
	cTexto += Space(4)							              // 108 - 111 -> Reservado
	cTexto += GravaData(SRA->RA_NASC,.F.,8)           		  // 112 - 119 -> Data Nascimento aaaammdd
	cTexto += SRA->RA_RGUF                        			  // 120 - 121 -> Estado de Emissao do RG
	cTexto += SRA->RA_SEXO                        			  // 122 - 122 -> Sexo do funcionrio
	cTexto += fGerStr(30,SRA->RA_MAE)                         // 123 - 152 -> Nome da Me do funcionrio
	cTexto += fGerStr(5,"R")                       			  // 153 - 157 -> Tipo do Logradouro fixamos "RUA"
	cTexto += fGerStr(40,SRA->RA_ENDEREC)                     // 158 - 197 -> Nome da Me do funcionrio
	cTexto += fGerZero(6,"0")                                 // 198 - 203 -> Nro. do Logradouro fixamos "000000"
	cTexto += fGerStr(15,SRA->RA_COMPLEM)                     // 204 - 218 -> Complemento do Endereco
	cTexto += fGerStr(40,SRA->RA_MUNICIP)               	  // 219 - 258 -> Municipio do Endereco
	cTexto += fGerStr(30,SRA->RA_BAIRRO)               		  // 259 - 288 -> Municipio do Endereco
	cTexto += fGerZero(8,SRA->RA_CEP)             			  // 289 - 296 -> Cep do Endereco
	cTexto += SRA->RA_ESTADO  								  // 297 - 298 -> Estado do Endereco
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTFU"
		TMPT->CODIGO	:= ALLTRIM(SRA->RA_CC)+SRA->RA_NOME //SRA->RA_FILIAL + SRA->RA_MAT
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTFUT]	+= 1
		aTotVal[TOTDET]	+= 1

	Endif

Return

//Fim da Rotina

/*


?
Programa  fGerTTIT  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TTIT                                         
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTIT()

	cTexto := "TTIT"                                             // 001 - 004 -> Tipo do Produto
	cTexto += Transform(SM0->M0_CGC,'@R 99.999.999/9999-99' )    // 005 - 022 -> Cnpj Principal
	cTexto += "K."+right(dtos(dDataRef),2)+"/"+substr(dtos(dDataRef),5,2)+"/"+substr(dtos(dDataRef),3,2) // 023 - 032 -> Numero do Pedido
//cTexto += "K."+Dtoc(dDataRef)                           	 // 023 - 032 -> Numero do Pedido
	cTexto += fGerZero(6,cEmpAnt+SRA->RA_FILIAL)              	// 033 - 038 -> Codigo da Unidade
	cTexto += fGerZero(6,SRA->RA_CC)                    		 // 039 - 044 -> Codigo do Depto
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT)          // 045 - 056 -> Codigo do Funcionario
	cTexto += StrZero(nSeqFu_,3)                          		 // 057 - 059 -> Seq Itens Funcionario
	cTexto += StrZero(SR0->R0_QDIACAL,8)                         // 060 - 067 -> Qde Bilhetes/Viagens
	cTexto += fGerZero(9,Transform(SRN->RN_VUNIATU,'999999.99')) // 068 - 076 -> Valor Tarifa do Item
	cTexto += fGerStr(6,SRN->RN_TKOPERA)                           // 077 - 082 -> Codigo Operadora Transp
	cTexto += fGerStr(12,SRN->RN_TKBILHE)                        // 083 - 094 -> Codigo Bilhete Operadora
	cTexto += fGerStr(4," ")                         // 095 - 098 -> Tipo Bilhete
	cTexto += "N"                                           	 // 099 - 099 -> Flag Tipo Pedido
	cTexto += CRLF

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TTIT"
		TMPT->CODIGO	:= ALLTRIM(SRA->RA_CC)+SRA->RA_NOME
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTITT]	+= 1
		aTotVal[TOTPAS]	+= SR0->R0_QDIACAL
		aTotVal[TOTDET]	+= 1
	Endif

Return

//Fim da Rotina

/*


?
Programa  fGerTT99  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TT99                                         
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTT99()

	cTexto := "9999"                               // 001 - 004 -> Fixo "9999"
	cTexto += StrZero(aTotVal[TOTITT],8)           // 005 - 012 -> Total Linhas
	cTexto += Space(152)                           // 013 - 164 -> Brancos
	cTexto += CRLF

	aTotVal[TOTTRA]	+= 1

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*


?
Programa  fGerTR010 Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TR010                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTR010()

	cTexto := "TR01"                                   // 001 - 004 -> Tipo do Produto
	cTexto += "0"                                      // 005 - 005 -> Tipo Registro
	cTexto += "R"                                      // 006 - 006 -> Refeicao
	cTexto += cCodCliTRE			                    // 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(30,SM0->M0_NOMECOM)              // 017 - 046 -> Nome da Empresa
	cTexto += GravaData(dDataBase,.F.,8)               // 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 // 055 - 062 -> Data de Entrega
	cTexto += "A"                                      // 063 - 063 -> Tipo do Pedido
	cTexto += " "                                      // 064 - 064 -> Brancos
	cTexto += "S"                                      // 065 - 065 -> Relatorio Assinaturas
	cTexto += "1"                                      // 066 - 066 -> 1a Linha Pers Ticket
	cTexto += "2"                                      // 067 - 067 -> 2a Linha Pers Ticket
	cTexto += "4"                                      // 068 - 068 -> 1a Linha Pers Rotulo
	cTexto += "5"                                      // 069 - 069 -> 2a Linha Pers Rotulo
	cTexto += "N"                                      // 070 - 070 -> Recibo Encarte
	cTexto += "N"                                      // 071 - 071 -> Relatorio Gerencial
	cTexto += "N"                                      // 072 - 072 -> Resumo Unidades
	cTexto += Space(7)                                 // 073 - 079 -> Brancos
	cTexto += StrZero(Month(dDataRef),2)               // 080 - 081 -> Mes Utilizacao
	cTexto += Space(19)                                // 082 - 100 -> Brancos
	cTexto += "04"                                     // 101 - 102 -> Tipo de Lay-Out
	cTexto += Space(56)								// 103 - 158 -> Reservado
	cTexto += StrZero(nSeq,6)                          // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	nSeq	+= 1
	aTotVal[TOTHEA] += 1

	fGravaReg(AllTrim(cTexto))

	aTotVal[TOTDET]	+= 1


Return

/*


?
Programa  fGerTR012 Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TR012                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTR012()

//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC))

	cTexto := "TR01" 								// 001 - 004 -> Tipo do Produto
	cTexto += "2"									// 005 - 005 -> Tipo Registro
	cTexto += fGerZero(6,CTT->CTT_CUSTO)			// 006 - 011 -> Codigo do Depto
	cTexto += fGerStr(20,CTT->CTT_DESC01)				// 012 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        // 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,CTT->CTT_ENDER)               // 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,"0")                // 066 - 071 -> Numero do Logradouro
	cTexto += Space(10)                             // 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,CTT->CTT_MUNIC)            // 082 - 106 -> Municipio
	cTexto += fGerStr(15,CTT->CTT_BAIRRO)            // 107 - 121 -> Bairro
	cTexto += Subst(CTT->CTT_CEP,1,5)                // 122 - 126 -> CEP
	cTexto += CTT->CTT_ESTADO                            // 127 - 128 -> Estado
	cTexto += fGerStr(20,cResponsav)           // 129 - 148 -> Responsavel
	cTexto += Subst(CTT->CTT_CEP,6,3)                // 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              // 152 - 158 -> Reservado
	cTexto += "0"                                   // 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TR012"
		TMPT->CODIGO	:= cEmpAnt + SRA->RA_FILPOST
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTDET]	+= 1
	Endif


Return

//Fim da Rotina

/*


?
Programa  fGerTR012 Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TR013                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTR013()

//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT") + SRA->RA_CC))

	cTexto := "TR01"                                    // 001 - 004 -> Tipo do Produto
	cTexto += "3"                                       // 005 - 005 -> Tipo Registro
	cTexto += fGerZero(6,SRA->RA_CC)               // 006 - 011 -> Codigo do Depto
	cTexto += fGerStr(20,CTT->CTT_DESC01)                 // 012 - 031 -> Nome do Depto
	cTexto += fGerZero(12,SRA->RA_FILIAL + SRA->RA_MAT) // 032 - 043 -> Codigo do Funcionario
	cTexto += Space(26)                                 // 044 - 069 -> Personalizacao By Cliente
	cTexto += fGerZero(6,SRA->RA_CC)               // 070 - 075 -> Codigo da Unidade
	cTexto += fGerStr(20,CTT->CTT_DESC01)                 // 076 - 095 -> Descricao da Unidade
	cTexto += StrZero(nQtdBen,3)                        // 096 - 098 -> Total Tickets Func
	cTexto += StrZero(nQtdBen,2)                        // 099 - 100 -> Tickets Por Talao
	cTexto += StrZero(Int(nValRef*100),9)               // 101 - 109 -> Valor Facial Ticket
	cTexto += "R"                                       // 110 - 110 -> Refeicao
	cTexto += "C"                                       // 111 - 111 -> Carne
	cTexto += fGerStr(30,SRA->RA_NOME)                  // 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                 // 142 - 158 -> Brancos
	cTexto += "0"                                       // 159 - 164 -> Controle Sequencia

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:=	"TR013"
		TMPT->CODIGO	:= Space(8)
		TMPT->TEXTO		:= cTexto
		MSunLock()
		aTotVal[TOTQVR]	+= nQtdBen
		aTotVal[TOTVVR]	+= (nValRef * nQtdBen)
		aTotVal[TOTDET]	+= 1
	Endif


Return
//Fim da Rotina 


/*


?
Programa  fGerTR019 Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro TR019                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTR019()

	cTexto := "TR01"                                // 001 - 004 -> Tipo do Produto
	cTexto += "9"                                   // 005 - 005 -> Tipo Registro
	cTexto += StrZero(aTotVal[TOTQVR],8)            // 006 - 013 -> Total Tickets
	cTexto += StrZero(aTotVal[TOTVVR] * 100,14)     // 014 - 027 -> Total Pedidos
	cTexto += Space(131)                            // 028 - 158 -> Brancos
	cTexto += StrZero(nSeq,6)                       // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	aTotVal[TOTTRA]	+= 1
	nSeq			+= 1

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*


?
Programa  fGerLSUP  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro LSUP5                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerLSUP5()

	cTexto := "LSUP5"                      // 001 - 005 -> Tipo do Registro
	cTexto += fGerStr(8,cUser)             // 006 - 013 -> Nome do Usuario que gerou o arquivo
	cTexto += Space(11)                    // 014 - 024 -> Brancos
	cTexto += GravaData(dDataBase,.F.,8 )  // 025 - 032 -> Data da Geracao
	cTexto += Time()	   				   // 033 - 040 -> Hora da Gravao HH.MM.SS
	If lTran
		cTexto += fGerStr(17,"LAYOUT-08/10/2009")// 041 - 057 -> Brancos
	Else
		cTexto += fGerStr(17,"LAYOUT-05/05/2008")// 041 - 057 -> Brancos
	Endif
	cTexto += Space(107)                   // 058 - 164 -> Brancos
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*


?
Programa   fGerHTRE Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Header Vale Refeicao Eletronico              
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerHTRE()

	cTexto := "T"         	                            // 001 - 001 -> Fixo T
	cTexto += "R"                                       // 002 - 002 -> Refeicao
	cTexto += "02"										// 003 - 004 -> Fixo 02
	cTexto += "0"										// 005 - 005 -> 0
	cTexto += "R"										// 006 - 006 -> Refeicao
	cTexto += cCodCliTRE			                   	// 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(24,SM0->M0_NOMECOM)              	// 017 - 040 -> Nome da Empresa
	cTexto += Space(06)                                	// 041 - 046 -> Brancos
	cTexto += GravaData(dDataBase,.F.,8)               	// 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 	// 055 - 062 -> Data de Entrega
	cTexto += "C"                                      	// 063 - 063 -> C
	cTexto += Space(16)                                	// 064 - 079 -> Brancos
	cTexto += StrZero(Month(dDataBase),2)              	// 080 - 081 -> Mes de Referencia
	cTexto += Space(19)                                	// 082 - 100 -> Brancos
	cTexto += "04"		                                // 101 - 102 -> 04
	cTexto += "34"		          		                // 103 - 104 -> Tipo de Cartao - (TRE
	cTexto += Space(48)									// 105 - 152 -> Brancos
	cTexto += fGerStr(06,"SUP")							// 153 - 158 -> Preencher com "SUP"
	cTexto += StrZero(nSeq,6)                           // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

	nSeq += 1
	aTotVal[TOTHEA] += 1

Return

//Fim de Arquivo

/*


?
Programa   fGerTRE  Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Unidade de Entrega Vale Refeicao Eletronico  
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTRE()

/*
cTexto := "T" 									// 001 - 001 -> Tipo do Produto
cTexto += "R"									// 005 - 005 -> ProdutoTipo Registro
cTexto += "02"									// 003 - 004 -> Fixo 02
cTexto += "2"									// 005 - 005 -> 2
cTexto += fGerStr(26,SM0->M0_NOMECOM)			// 006 - 031 -> Nome do Depto
cTexto += fGerStr(4,"R")                        // 032 - 035 -> Tipo de Logradouro
cTexto += fGerStr(30,SM0->M0_ENDCOB)			// 036 - 065 -> Nome do Logradouro
cTexto += fGerZero(6,"0")                		// 066 - 071 -> Numero do Logradouro
cTexto += fGerStr(10,SM0->M0_COMPCOB)			// 072 - 081 -> Complemento do Logradouro
cTexto += fGerStr(25,SM0->M0_CIDCOB)            // 082 - 106 -> Municipio
cTexto += fGerStr(15,SM0->M0_BAIRCOB)			// 107 - 121 -> Bairro
cTexto += Subst(SM0->M0_CEPCOB,1,5)				// 122 - 126 -> CEP
cTexto += SM0->M0_ESTCOB						// 127 - 128 -> Estado
cTexto += fGerStr(20,cResponsav)				// 129 - 148 -> Responsavel
cTexto += Subst(SM0->M0_CEPCOB,5,3)				// 149 - 151 -> Complemento CEP
cTexto += Space(7)                              // 152 - 158 -> Reservado
cTexto += "0"                                   // 159 - 164 -> Sequencial
*/

//-- Cadastro de unidades de entrega
	SZK->(DbSetOrder(1))
	SZK->(Dbseek(xFilial("SZK")+SRA->RA_FILPOST))

	cTexto := "T" 									// 001 - 001 -> Tipo do Produto
	cTexto += "R"									// 005 - 005 -> ProdutoTipo Registro
	cTexto += "02"									// 003 - 004 -> Fixo 02
	cTexto += "2"									// 005 - 005 -> 2
	cTexto += fGerStr(26,SM0->M0_NOMECOM)			// 006 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        // 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,SZK->ZK_LOGRADO)			// 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,SZK->ZK_NUMERO)       		// 066 - 071 -> Numero do Logradouro
	cTexto += fGerStr(10,SZK->ZK_COMPLEM)			// 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,SZK->ZK_CIDADE)            // 082 - 106 -> Municipio
	cTexto += fGerStr(15,SZK->ZK_BAIRRO)			// 107 - 121 -> Bairro
	cTexto += Subst(SZK->ZK_CEP,1,5)				// 122 - 126 -> CEP
	cTexto += SZK->ZK_ESTADO						// 127 - 128 -> Estado
	cTexto += fGerStr(20,cResponsav)				// 129 - 148 -> Responsavel
	cTexto += Subst(SZK->ZK_CEP,6,3)				// 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              // 152 - 158 -> Reservado
	cTexto += "0"                                   // 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:= "TRE"
//	TMPT->CODIGO	:= cEmpAnt + cFilAnt
		TMPT->CODIGO	:= cEmpAnt + SRA->RA_FILPOST
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif

	aTotVal[TOTDET] += 1

Return

//Fim da Rotina

/*


?
Programa    fGerTRF Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro de Funcionarios do Vale Refeicao Eletronico  
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTRF()

	//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC))

	cTexto := "T"	                          	        			// 001 - 001 -> Fixo T
	cTexto += "R"                                      			// 002 - 002 -> R Refeicao
	cTexto += "02"                                   				// 003 - 004 -> Fixo 02
	cTexto += "3"  				                    			// 005 - 005 -> Fixo 3
	cTexto += fGerStr(26,SRA->RA_CC)		            			// 006 - 031 -> Codigo do Departamento
	cTexto += fGerZero(12,SRA->RA_CIC)								// 032 - 043 -> Codigo do Funcionario
	cTexto += GravaData(SRA->RA_NASC,.F.,5)            			// 044 - 051 -> Data de Nascimento
	cTexto += Space(18)					            			// 052 - 069 -> Branco
	cTexto += fGerStr(26,SM0->M0_NOMECOM)							// 070 - 095 -> Nome da Unidade de Entrega
	cTexto += "00101"                                  			// 096 - 100 -> Preencher 00101
	cTexto += StrZero(Round(nTotBen * 100,2),9)        			// 101 - 109 -> Valor Total do Beneficio
	cTexto += "R"                                      			// 110 - 110 -> Produto
	cTexto += "E"   	                                			// 111 - 111 -> Eletronico
	cTexto += fGerStr(30,SRA->RA_NOME)                 			// 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                			// 142 - 158 -> Brancos
	cTexto += "0"                                      			// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:= "TRF"
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif

	aTotVal[TOTFUE] += 1
	aTotVal[TOTTVR] += nTotBen
	aTotVal[TOTDET] += 1
Return

//Fim da Rotina

/*


?
Programa   fGerTTRE Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Trailes do Vale Refeicao Eletronico          
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTRE()

	cTexto := "T"                     	   				// 001 - 001 -> Tipo do Registro
	cTexto += "R"										// 002 - 002 -> Refeicao
	cTexto += "02"										// 003 - 003 -> 02
	cTexto += "9"										// 005 - 005 -> Tipo de Registro
	cTexto += StrZero(aTotVal[TOTFUE],8)       			// 006 - 013 -> Total de Funcionarios
	cTexto += StrZero(Round(aTotVal[TOTTVR] * 100,2),14)// 014 - 027 -> Total de Funcionarios
	cTexto += Space(131)                   				// 028 - 158 -> Brancos
	cTexto += StrZero(nSeq,6)                   		// 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))
	aTotVal[TOTTRA]	+= 1

Return

//Fim da Rotina

/*


?
Programa   fGerHTAE Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Header Vale Alimentacao Eletronico           
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerHTAE()

	cTexto := "T"         	                            // 001 - 001 -> Fixo T
	cTexto += "A"                                       // 002 - 002 -> Alimentacao
	cTexto += "02"										// 003 - 004 -> Fixo 02
	cTexto += "0"										// 005 - 005 -> 0
	cTexto += "A"										// 006 - 006 -> Alimentacao
	cTexto += Strzero(val(cCodCliTAE),10)                	// 007 - 016 -> Codigo Cliente Ticket
	cTexto += fGerStr(30,SM0->M0_NOMECOM)              	// 017 - 046 -> Nome da Empresa
	cTexto += GravaData(dDataBase,.F.,8)               	// 047 - 054 -> Data de Geracao
	cTexto += GravaData(dVrEntr,.F.,8)                 	// 055 - 062 -> Data de Entrega
	cTexto += "C"                                      	// 063 - 063 -> C
	cTexto += Space(16)                                	// 064 - 079 -> Brancos
	cTexto += StrZero(Month(dDataBase),2)              	// 080 - 081 -> Mes de Referencia
	cTexto += Space(19)                                	// 082 - 100 -> Brancos
	cTexto += "04"		                                // 101 - 102 -> 04
	cTexto += "33"		          		                // 103 - 104 -> Tipo de Cartao - (TAE)
	cTexto += Space(48)									// 105 - 152 -> Brancos
	cTexto += fGerStr(06,"SUP")							// 153 - 158 -> Preencher com "SUP"
	cTexto += StrZero(nSeq,6)                           // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

	nSeq += 1
	aTotVal[TOTHEA] += 1

Return

//Fim de Arquivo

/*


?
Programa   fGerTAE  Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Unidade Entrega Vale Alimentacao Eletronico  
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTAE()

//-- Cadastro de unidades de entrega
	SZK->(DbSetOrder(1))
	SZK->(Dbseek(xFilial("SZK")+SRA->RA_FILPOST))

	cTexto := "T" 									// 001 - 001 -> Tipo do Produto
	cTexto += "A"									// 005 - 005 -> ProdutoTipo Registro
	cTexto += "02"									// 003 - 004 -> Fixo 02
	cTexto += "2"									// 005 - 005 -> 2
	cTexto += fGerStr(26,SM0->M0_NOMECOM)			// 006 - 031 -> Nome do Depto
	cTexto += fGerStr(4,"R")                        // 032 - 035 -> Tipo de Logradouro
	cTexto += fGerStr(30,SZK->ZK_LOGRADO)			// 036 - 065 -> Nome do Logradouro
	cTexto += fGerZero(6,SZK->ZK_NUMERO)                		// 066 - 071 -> Numero do Logradouro
	cTexto += fGerStr(10,SZK->ZK_COMPLEM)			// 072 - 081 -> Complemento do Logradouro
	cTexto += fGerStr(25,SZK->ZK_CIDADE)            // 082 - 106 -> Municipio
	cTexto += fGerStr(15,SZK->ZK_BAIRRO)			// 107 - 121 -> Bairro
	cTexto += Subst(SZK->ZK_CEP,1,5)				// 122 - 126 -> CEP
	cTexto += SZK->ZK_ESTADO						// 127 - 128 -> Estado
	cTexto += fGerStr(20,cResponsav)				// 129 - 148 -> Responsavel
	cTexto += Subst(SZK->ZK_CEP,6,3)				// 149 - 151 -> Complemento CEP
	cTexto += Space(7)                              // 152 - 158 -> Reservado
	cTexto += "0"                                   // 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:= "TRA"
//	TMPT->CODIGO	:= cEmpAnt + cFilAnt
		TMPT->CODIGO	:= cEmpAnt + SRA->RA_FILPOST
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif

	aTotVal[TOTDET] += 1

Return

//Fim da Rotina

/*


?
Programa    fGerTAF Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro de Funcionarios Vale Alimentacao Eletronico  
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTAF()

	//Pesquisa Setor
	CTT->(dbSeek(xFilial("CTT",SRA->RA_FILIAL) + SRA->RA_CC))

	cTexto := "T"	                          	        	// 001 - 001 -> Fixo T
	cTexto += "A"                                      	// 002 - 002 -> A Alimentacao
	cTexto += "02"                                     	// 003 - 004 -> Fixo 02
	cTexto += "3"  				                    	// 005 - 005 -> Fixo 3
	cTexto += fGerStr(26,SRA->RA_CC)              			// 006 - 031 -> Codigo do Departamento
	cTexto += fGerZero(12,SRA->RA_CIC)						// 032 - 043 -> Codigo do Funcionario
	cTexto += GravaData(SRA->RA_NASC,.F.,5)            	// 044 - 051 -> Data de Nascimento
	cTexto += Space(18)					            	// 052 - 069 -> Branco
	cTexto += fGerStr(26,SM0->M0_NOMECOM)					// 070 - 095 -> Nome da Unidade de Entrega
	cTexto += "00101"                                  	// 096 - 100 -> Preencher 00101
	cTexto += StrZero(Round(nTotBen * 100,2),9)        	// 101 - 109 -> Valor Total do Beneficio
	cTexto += "A"                                      	// 110 - 110 -> Produto
	cTexto += "E"   	                                	// 111 - 111 -> Eletronico
	cTexto += fGerStr(30,SRA->RA_NOME)                 	// 112 - 141 -> Nome do Funcionario
	cTexto += Space(17)                                	// 142 - 158 -> Brancos
	cTexto += "0"                                      	// 159 - 164 -> Sequencial

	If RecLock("TMPT",.T.)
		TMPT->TIPREG	:= "TAF"
		TMPT->TEXTO		:= cTexto
		MSunLock()
	Endif

	aTotVal[TOTFUA] += 1
	aTotVal[TOTTVA] += nTotBen
	aTotVal[TOTDET] += 1

Return

//Fim da Rotina

/*


?
Programa   fGerTTAE Autor  Jose Carlos Gouveia  Data   04/02/05   
?
Desc.      Gera Registro Trailes do Vale Alimentacao Eletronico       
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerTTAE()

	cTexto := "T"                     	   		// 001 - 001 -> Tipo do Registro
	cTexto += "A"								// 002 - 002 -> Alimentacao
	cTexto += "02"								// 003 - 003 -> 02
	cTexto += "9"								// 005 - 005 -> Tipo de Registro
	cTexto += StrZero(aTotVal[TOTFUA],8)    	// 006 - 013 -> Total de Funcionarios
	cTexto += StrZero(aTotVal[TOTTVA] * 100,14) // 014 - 027 -> Valor Total dos Funcionarios
	cTexto += Space(131)                   		// 028 - 158 -> Brancos
	cTexto += StrZero(nSeq,6)                   // 159 - 164 -> Controle Sequencia
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))
	aTotVal[TOTTRA]	+= 1

Return

//Fim da Rotina

/*


?
Programa  fGerLSUP9 Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Gera Registro LSUP9                                        
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerLSUP9()

	cTexto := "LSUP9"                     // 001 - 005 -> Tipo do Registro
	cTexto += StrZero(aTotVal[TOTHEA],8)  // 006 - 013 -> Total Headers
	cTexto += StrZero(aTotVal[TOTTRA],8)  // 014 - 021 -> Total Traillers
	cTexto += StrZero(aTotVal[TOTDET],8)  // 022 - 029 -> Total Registros
	cTexto += Space(135)                  // 030 - 306 -> Brancos
	cTexto += CRLF

	fGravaReg(AllTrim(cTexto))

Return

//Fim da Rotina

/*


?
Programa    fGerStr Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Acrescenta espacos a direita                               
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerStr(nNum,cVaria)

	Local cVar

	cVar := AllTrim(cVaria) + Space(nNum)

	cVar := Subst(cVar,1,nNum)

Return(cVar)

//Fim da Rotina

/*


?
Programa  fGerZero  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Acrescenta zeros a Esquerda                                
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fGerZero(nNum,cVaria)

	Local cVar

	cVar := AllTrim(cVaria)

	While Len(cVar) < nNum

		cVar := "0" + cVar

	End

Return(cVar)

/*


?
Programa  fCriaDBF  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Cria DBF                                                   
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fCriaDBF()

	Local aCamp 	:= {}
	Local cInd		:= ""

	If Select("TMPT") > 0
		TMPT->(DbCloseArea())
	Endif
//Vale Transporte
//Arquivo Unidade de Entrega/Departamento VT
	aadd(aCamp,{'TIPREG','C',5,0})
	aadd(aCamp,{'CODIGO','C',8,0})
	aadd(aCamp,{'TEXTO','C',310,0})

//Nome e Criacao do Arquivo
	cArq := Criatrab(aCamp,.t.)

//Abertura do Arquivo
	dbUseArea(.t.,,cArq,'TMPT')
	dbSelectArea('TMPT')

//Cria Indice Temporario
//Nome do Indice
	cArqInd := CriaTrab(Nil,.F.)

	cInd := "TIPREG + CODIGO"
//Criacao do Indice
	IndRegua("TMPT",cArqInd,cInd,,,"Selecionando Registros")

Return

//Fim da Rotina

/*


?
Funo     fGravaReg     Autor Jose Carlos Gouveia Data  06.11.00 
J
Descrio  Grava Registros no Arquivo Texto                           
J
Sintaxe    fGravaReg()                                                
J
 Uso       GeraKit                                                    
J

*/
Static Function fGravaReg(cLin)

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgYesNo('Ocorreu um erro na gravao do arquivo '+AllTrim(cNomeArq)+'.   Continua?','Ateno!')
			lContinua := .F.
			Return
		Endif
	Endif

Return

//Fim da Rotina

/*/


	?
	Funo	  FGETPATH  Autor  Kleber Dias Gomes      Data  26/06/00
	J
	Descrio  Permite que o usuario decida onde sera criado o arquivo
	J
	Uso        CONVERTE
	?

*/
User Function UfGetPath()
	Local cRet := Alltrim(ReadVar())
	Local cPath  := cNomeArq

	oWnd := GetWndDefault()

	While .T.

		If Empty(cPath)
			cPath := cGetFile( "Arquivos Texto de Importacao | *.TXT ",OemToAnsi("Selecione Arquivo"))
		EndIf

		If Empty(cPath)
			Return .F.
		EndIf

		&(cRet) := cPath

		Exit

	EndDo

	If oWnd != Nil
		GetdRefresh()
	EndIf

Return .T.
//Fim da Rotina 

/*


?
Programa  fChkPerg  Autor  Jose Carlos Gouveia  Data   10/11/14   
?
Desc.      Perguntas do Sistema.                                      
                                                                      
?
Uso        AP7                                                        
?

 */
Static Function fChkPerg()

	Local aRegs := {}

	aAdd(aRegs,{cPerg,'01','Data de Referencia      ?','','','mv_ch1','D',08,0,0,'G','NaoVazio   ','mv_par01','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'02','Refeicao                ?','','','mv_ch2','N',01,0,0,'C','           ','mv_par02','Papel          ','','','','','Eletronico   ','','','','','Nenhum       ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'03','Transporte              ?','','','mv_ch3','N',01,0,0,'C','           ','mv_par03','Sim            ','','','','','Nao          ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'04','Alimentacao Eletronico  ?','','','mv_ch4','N',01,0,0,'C','           ','mv_par04','Sim            ','','','','','Nao          ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'05','Filial De               ?','','','mv_ch5','C',02,0,0,'G','           ','mv_par05','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','XM0','','',''})
	aAdd(aRegs,{cPerg,'06','Filial Ate              ?','','','mv_ch6','C',02,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','XM0','','',''})
	aAdd(aRegs,{cPerg,'07','Matricula De            ?','','','mv_ch7','C',06,0,0,'G','           ','mv_par07','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA','','',''})
	aAdd(aRegs,{cPerg,'08','Matricula Ate           ?','','','mv_ch8','C',06,0,0,'G','NaoVazio   ','mv_par08','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','SRA','','',''})
	aAdd(aRegs,{cPerg,'09','Centro de Custo De      ?','','','mv_ch9','C',20,0,0,'G','           ','mv_par09','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','CTT','','',''})
	aAdd(aRegs,{cPerg,'10','Centro de Custo Ate     ?','','','mv_cha','C',20,0,0,'G','NaoVazio   ','mv_par10','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','CTT','','',''})
	aAdd(aRegs,{cPerg,'11','Situacoes a Imprimir    ?','','','mv_chb','C',05,0,0,'G','fSituacao  ','mv_par11','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'12','Categorias a Imprimir   ?','','','mv_chc','C',12,0,0,'G','fCategoria ','mv_par12','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'13','VT - Utilizacao De      ?','','','mv_chd','D',08,0,0,'G','NaoVazio   ','mv_par13','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'14','VT - Utilizacao Ate     ?','','','mv_che','D',08,0,0,'G','NaoVazio   ','mv_par14','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'15','VT - Dt Entrega Minima  ?','','','mv_chf','D',08,0,0,'G','NaoVazio   ','mv_par15','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'16','VT - Dt Entrega Maxima  ?','','','mv_chg','D',08,0,0,'G','NaoVazio   ','mv_par16','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'17','VR - Data Entrega       ?','','','mv_chh','D',08,0,0,'G','NaoVazio   ','mv_par17','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'18','VA - Data Entrega       ?','','','mv_chi','D',08,0,0,'G','NaoVazio   ','mv_par18','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'19','Perc do Kit             ?','','','mv_chj','N',06,2,0,'G','           ','mv_par19','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'20','Valor Ponto de Entrega  ?','','','mv_chk','N',12,2,0,'G','           ','mv_par20','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'21','Contrato VT             ?','','','mv_chl','C',10,0,0,'G','NaoVazio   ','mv_par21','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'22','Contrato TR  Eletronico ?','','','mv_chm','C',10,0,0,'G','NaoVazio   ','mv_par22','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'23','Contrato TA  Eletronico ?','','','mv_chn','C',10,0,0,'G','NaoVazio   ','mv_par23','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'24','Usurio do Sistema       ?','','','mv_cho','C',08,0,0,'G','NaoVazio   ','mv_par24','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'25','Nome do  Arquivo        ?','','','mv_chp','C',25,0,0,'G','U_UfGetPath()','mv_par25','             ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'26','Ponto - Utilizacao De   ?','','','mv_chq','D',08,0,0,'G','NaoVazio   ','mv_par26','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'27','Ponto - Utilizacao Ate  ?','','','mv_chr','D',08,0,0,'G','NaoVazio   ','mv_par27','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'28','Cod. VR ?                ','','',"mv_chs",'C',99,0,0,'R','U_fCodVR1  ','mv_par28','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'29','Respons·vel recebimento? ','','','mv_cht','C',20,0,0,'G','NaoVazio   ','mv_par29','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','   ','','',''})
	aAdd(aRegs,{cPerg,'30','Filial Para Faturamento ?','','','mv_chu','C',02,0,0,'G','           ','mv_par30','               ','','','','','             ','','','','','             ','','','','','              ','','','','','               ','','','','XM0','','',''})

	ValidPerg(aRegs,cPerg,.F.)

Return


User Function fCodVR1(l1Elem)
/*/f/
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
	<Descricao> :  Monta tela para seleÁ„o de multiplos Codigos de VR a processar.
	<Autor> : Alexandre
	<Data> : 29/09/2008
	<Parametros> : Nenhum
	<Retorno> : Logico
	<Processo> : Especifico Galvao Engenharia - GPE - Beneficios.
	<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
	<Obs> : Funcao chamada na digitacao dos beneficios.
	‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

	Local cTitulo:=""
	Local MvPar
	Local MvParDef:=""

	Private aCodVR :={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	lTipoRet := .T.

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	cTitulo := "Codigos VR"
	dbSelectArea("RFO")
	dbGoTop()
	dbSeek(xFilial("RFO")+"1")
	If !RFO->( Eof() ) .And. RFO->RFO_TPVALE = '1'

		CursorWait()
		While !RFO->(Eof()) .And. RFO->RFO_TPVALE = '1'
			Aadd(aCodVR, RFO->RFO_CODIGO+" "+RFO->RFO_DESCR)
			MvParDef+=RFO->RFO_CODIGO
			RFO->(dbSkip())
		Enddo
		CursorArrow()

	Else

		Help(" ",1,"O cadastro de benefÌcios esta vazio.Verifique.") //
		MvParDef:=" "
	Endif

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aCodVR,MvParDef,12,49,l1Elem,3)
			&MvRet := mvpar
		EndIF
	EndIF

	dbSelectArea(cAlias)

Return( IF( lTipoRet , .T. , MvParDef ) )
