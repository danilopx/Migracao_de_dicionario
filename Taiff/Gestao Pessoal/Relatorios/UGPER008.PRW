#INCLUDE "PROTHEUS.CH"
#INCLUDE "UGPER008.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    	³ GPER008    ³ Autor ³ Mauricio Takakura     	      ³ Data ³ 05/11/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o 	³ Relatorio de Conferencia do Calculo de Planos de Saude       			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   	³ GPER008()                                                    			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      	³ Generico ( DOS e Windows )                                   			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ FNC			³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mauricio T.  ³05/11/2011³                ³Criacao novo fonte.                        ³±±
±±³Luis Ricardo ³14/12/2011³00000032043/2011³Ajuste na query para incluir o campo Tp. 	³±±
±±³Cinalli		³		   ³Chamado: TEDB33	³Fornec. na ordem e corrigir a sequencia de	³±±
±±³				³		   ³				³impressao dos agregados no relatorio.		³±±
±±³				³19/12/2011³				³Ao trocar Origem limpa o Codigo Usuario	³±±
±±³				³		   ³				³para forcar impressao do 1o nome.			³±±
±±³Luis Ricardo ³03/01/2012³00000033643/2011³Ajuste para permitir a impressao de acordo	³±±
±±³Cinalli		³		   ³Chamado: TEGFW4	³com a data de referencia, independente de	³±±
±±³				³		   ³				³ser maior que o param MV_FOLMES.			³±±
±±³Mauricio T.  ³09/01/2012³00000030820/2011³Tratamento para Periodos da Nova Folha de  ³±±
±±³             ³		   ³TECFVT	   	    ³Pagamentos - Gestao Publica.               ³±±
±±³Luis Ricardo	³06/01/2012³00000000526/2012³Ajustes na chamada do fPosTab para tratar o³±±
±±³Cinalli		³		   ³Chamado: TEHKII ³retorno como numerico e nao ocasionar error³±±
±±³				³		   ³				³log na utilizacao com a var cAux.			³±±
±±³Luis Ricardo	³13/02/2012³00000003245/2012³Incluido tratamento para reg deletado da	³±±
±±³Cinalli		³		   ³Chamado: TEMRBD ³tabela CTT para nao duplicar informacao no ³±±
±±³				³		   ³				³relatorio.									³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         MELHORIAS E PERSONALIZAÇÕES.                                    			³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador  ³ Data     ³ Solicitante    ³  Motivo da Alteracao                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ricardo     	³03/08/2012³ Renata Freitas ³Incluido tratamento exportar para o excel. ³±±
±±³Duarte 		³		   ³                ³Incluido tratamento para filtrar plano de/ ³±±
±±³				³		   ³				³ate e tipo de plano ass.medica/odontologica³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function UGPER008()

	Local aArea		:= SRA->(GetArea())
	Local aOrd    	:= {OemToAnsi(STR0004), OemToAnsi(STR0006), OemToAnsi(STR0007)	} // "Centro de Custo + Matricula"###"Matricula"###"Nome"

	Local cDesc1  	:= OemToAnsi( STR0001 ) // "Relatorio do Calculo de Planos de Saude"
	Local cDesc2  	:= OemToAnsi( STR0002 ) // "Sera impresso de acordo com os parametros solicitados "
	Local cDesc3  	:= OemToAnsi( STR0003 ) // "pelo usuario."
	Local cAliasSRA	:= "SRA"  				// Alias do arquivo principal (Base)
	
	Local cFolMes		:= GetMv( "MV_FOLMES",,Space(08) ) 
	Private cDirDocs	:= MsDocPath()
	Private aStru		:= {}
	Private cArquivo	:= CriaTrab(,.F.)
	Private cPath		:= AllTrim(GetTempPath())
	Private oExcelApp
	Private nHandle

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Define Variaveis Private(Basicas)                            ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Private lGSP := If( GetMv( "MV_GSPUBL",, "1" ) == "1", .F., .T. ) // Gestao Publica 1=Nao; 2=Sim

	Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }	//"Zebrado"###"Administra‡„o"
	Private NomeProg := "UGPER008"
	Private aLinha   := {}
	Private nLastKey := 0
	Private cPerg    := "UGPER008"
	If lGSP
		cPerg    := "GPER008A"
	EndIf
	CriaSx1(cPerg)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Define Variaveis Private(Programa)                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Private aInfo     := {}
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Variaveis Utilizadas na funcao IMPR                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Private Titulo
	Private AT_PRG   := "UGPER008"
	
	Private wCabec0  := 1
	Private wCabec1  := OemToAnsi(STR0009) // "Tipo            Matr/Seq Nome                           Lancamento          Tp Fornec          Fornecedor               Tp Plano              Cod Plano         Vlr. Func        Vlr. Empresa    Total"
	Private Li       := 0
	Private nTamanho := "G"
	Private CONTFL	 := 1
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Verifica as perguntas selecionadas                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Pergunte(cPerg,.F.)
	
	Titulo := OemToAnsi( STR0001 ) // "Relatorio do Calculo de Planos de Saude"
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Envia controle para a funcao SETPRINT                        ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	wnrel	:=	"UGPER008"            //Nome Default do relatorio em Disco
	wnrel	:=	SetPrint(cAliasSRA, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., aOrd,,nTamanho)
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	nOrdem     	:= aReturn[8]
	
	If !lGSP
		dDataRef	:=	mv_par01	//	Data de Referencia - Competencia
		cAnoMes		:=	Substr(DTOS( dDataRef ), 1, 6)
		cFilDe     	:= mv_par02 	// Filial De
		cFilAte    	:= mv_par03		// Filial Ate
		cMatDe     	:= mv_par04		// Matricula De
		cMatAte    	:= mv_par05		// Matricula Ate
		cNomeDe    	:= mv_par06		// Nome De
		cNomeAte   	:= mv_par07		// Nome Ate
		cCcDe      	:= mv_par08		// Centro de Custo De
		cCcAte     	:= mv_par09		// Centro de Custo Ate
		cCategoria 	:= mv_par10 	// Categoria do Funcionario
		cSituacao  	:= mv_par11		// Situacao do Funcionario
		lAnalitico	:= If(mv_par12==1,.T., .F.) // Se a impressao e analitica
		lMovAberto 	:= .T.
		cPlanoDe   	:= mv_par13		// Plano médico/odontológico De
		cPlanoAte  	:= mv_par14		// Plano médico/odontológico Ate
		cTpPlano	:= str(mv_par15,1)	// Tipo do Plano 1=Médico / 2=Odontológico / 3=Ambos
		lExpExcel	:= mv_par16==2	// Exporta para o Excel

		If cAnoMes < cFolMes
			lMovAberto := .F.
		EndIf

		Titulo += "    "  + OemToAnsi(STR0027) + Substr(cAnoMes,5,2) + " / " + Substr(cAnoMes,1,4)   // "Competência: "

	Else
		cProces		:= mv_par01		// Processo
		cRoteiro	:= mv_par02		// Roteiro
		cPeriodo	:= mv_par03 	// Periodo
		cNumPagto	:= mv_par04		// Numero de Pagamento
		cFilDe     	:= mv_par05 	// Filial De
		cFilAte    	:= mv_par06		// Filial Ate
		cMatDe     	:= mv_par07		// Matricula De
		cMatAte    	:= mv_par08		// Matricula Ate
		cNomeDe    	:= mv_par09		// Nome De
		cNomeAte   	:= mv_par10		// Nome Ate
		cCcDe      	:= mv_par11		// Centro de Custo De
		cCcAte     	:= mv_par12		// Centro de Custo Ate
		cCategoria 	:= mv_par13 	// Categoria do Funcionario
		cSituacao  	:= mv_par14		// Situacao do Funcionario
		lAnalitico	:= If(mv_par15==1,.T., .F.) // Se a impressao e analitica
		lMovAberto 	:= .T.

		cPlanoDe   	:= ""			// Plano médico/odontológico De
		cPlanoAte  	:= "ZZ"			// Plano médico/odontológico Ate
		cTpPlano	:= "3"			// Tipo do Plano 1=Médico / 2=Odontológico / 3=Ambos
		lExpExcel	:= .F.			// Exporta para o Excel
		
		// Validar o Periodo Selecionado
		DbSelectArea( "RCH" ) 
		DbSetOrder( RetOrdem( "RCH", "RCH_FILIAL+RCH_PROCES+RCH_PER+RCH_NUMPAG+RCH_ROTEIR" ) )
		DbSeek( xFilial( "RCH" ) + cProces + cPeriodo + cNumPagto + cRoteiro, .F. )
		If Eof()
			DbSeek( xFilial( "RCH" ) + cProces + cPeriodo + cNumPagto +  Space( GetSx3Cache("RCH_ROTEIR","X3_TAMANHO" )), .F. )
		EndIf
		If Eof()
			Help(,,'HELP',,OemToAnsi(STR0031),1,0)	//"Periodo Informado nao Cadastrado! "
			Return
		EndIf
		
		If !Empty(RCH->RCH_DTFECH)
			lMovAberto 	:= .F.
		EndIf
		
		Titulo += "    "  + OemToAnsi(STR0032) + cPeriodo + " / " + cNumPagto + "  / " + cRoteiro //"Periodo: "

	EndIf
	
	If nLastKey = 27
		Return
	Endif
	
	SetDefault(aReturn,cAliasSRA)
	
	If nLastKey = 27
		Return
	Endif

	RptStatus({|lEnd| ProcImp(@lEnd,wnRel,cAliasSRA)},Titulo)
	
	RestArea(aArea)

Return

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ ProcImp		³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Relatorio                                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function ProcImp(lEnd, WnRel, cAliasSRA)

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Define Variaveis Locais (Programa)                           ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Local cQuery	 	:= ""
	Local cOrder	 	:= ""
	Local cInicio  		:= ""
	Local cFim     		:= ""
	
	Private cAliasQ		:= "SRA"
	Private cFilialAnt 	:= "  "
	Private cCcAnt     	:= Space(20)
	Private cMatAnt    	:= space(08)
	Private cTpOrigem	:= "" 
	Private cCodUsu		:= ""
	Private cAntMat 	:= ""
	Private lExeQry 	:= .F.

	Private aCC			:= {}
	Private aFil		:= {}
	Private aEmp		:= {}
	Private cAliasMov 	:= "RHR"

	If !lMovAberto
		cAliasMov := "RHS"
	EndIf
	
	#IFDEF TOP
		lExeQry		:= 	!ExeInAs400()
	#ENDIF
    
    DbSelectArea( "SRA" )
	If !lExeQry
		If nOrdem == 1	//"Centro de Custo + Matricula"
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_CC+RA_MAT") )
			DbSeek( cFilDe + cCcDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
			cFim     := cFilAte + cCcAte + cMatAte
		ElseIf nOrdem == 2	// Matricula 
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_MAT") )
			DbSeek( cFilDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
			cFim     := cFilAte + cMatAte
		ElseIf nOrdem == 3	// Nome
			DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_NOME+RA_MAT") )
			DbSeek( cFilDe + cMatDe, .T. )
			cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
			cFim     := cFilAte + cNomeAte + cMatAte
		EndIf
	Else
		DbSetOrder( RetOrdem( "SRA", "RA_FILIAL+RA_MAT") )

		cAliasQ		:= "QSRA"
		If nOrdem == 1
			cOrder	:= "1, 4, 2, 8, 9, 10"
		ElseIf nOrdem == 2
			cOrder	:= "1, 2, 8, 9, 10"
		ElseIf nOrdem == 3
			cOrder	:= "1, 3, 8, 9, 10"
		Endif
		
		// Converter string en condicao de IN (Query)
		cSituacao  	:= fSqlIN( cSituacao, 1 )	// Situacao do Funcionario
		cCategoria 	:= fSqlIN( cCategoria, 1 ) 	// Categoria do Funcionario

		//-- Monta query de selecao da informacao
		cQuery	:= "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, SRA.RA_ADMISSA,  "
		cQuery	+= "CTT.CTT_CUSTO, CTT.CTT_DESC01 CTT_DESC01, MOV." + cAliasMov + "_ORIGEM ORIGEM, " 
		cQuery  += "MOV." + cAliasMov + "_CODIGO CODIGO, MOV." + cAliasMov + "_TPFORN TPFORN, MOV.* "
		cQuery	+= "FROM "+RetSqlName(cAliasMov)+" MOV "
		cQuery  += "INNER JOIN " + RetSqlName("SRA") + " SRA "
		cQuery  += "ON MOV." + cAliasMov + "_FILIAL = SRA.RA_FILIAL "
		cQuery  += "AND MOV." + cAliasMov + "_MAT = SRA.RA_MAT "
		cQuery  += "LEFT JOIN " + RetSqlName("CTT") + " CTT "
		If !Empty(xFilial("CTT"))
			cQuery  += "ON SRA.RA_FILIAL = CTT.CTT_FILIAL AND "
		Else
			cQuery	+= "ON "
		EndIf
		cQuery	+= "SRA.RA_CC = CTT.CTT_CUSTO "
		cQuery	+= "WHERE "
		cQuery	+= "SRA.RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "
		cQuery	+= "AND SRA.RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' "
		cQuery	+= "AND SRA.RA_NOME BETWEEN '"+cNomeDe+"' AND '"+cNomeAte+"' "
		cQuery	+= "AND SRA.RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' "
		cQuery	+= "AND SRA.RA_SITFOLH IN("+cSituacao+") "
		cQuery	+= "AND SRA.RA_CATFUNC IN("+cCategoria+") "

		If !lGSP
			cQuery	+= "AND MOV." + cAliasMov + "_COMPPG = '" + cAnoMes + "' "
		Else
			cQuery	+= "AND MOV." + cAliasMov + "_PROCES = '" + cProces + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_ROTEIR = '" + cRoteiro + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_PERIOD = '" + cPeriodo + "' "
			cQuery	+= "AND MOV." + cAliasMov + "_NUMPAG = '" + cNumPagto + "' "
		EndIf
		
		//-- Filtra o tipo de plano - assistência médica ou odontológica
		If cTpPlano <> "3"
			cQuery	+= "AND MOV." + cAliasMov + "_TPFORN = '" + cTpPlano + "' "
		Endif
		//-- Filtra o código de plano de/até
		cQuery	+= "AND MOV." + cAliasMov + "_PLANO BETWEEN '"+cPlanoDe+"' AND '"+cPlanoAte+"' "

		cQuery	+= " AND MOV.D_E_L_E_T_ = ' ' "
		cQuery	+= " AND SRA.D_E_L_E_T_ = ' ' "
		cQuery	+= " AND CTT.D_E_L_E_T_ = ' '  "
		cQuery	+= "ORDER BY " + cOrder

		cQuery	:= ChangeQuery( cQuery )
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasQ, .F., .T.)
	EndIf

	dbSelectArea( cAliasQ )
	SetRegua((cAliasQ)->(RecCount()))
	
	//-- Cria o arquivo temporário
	If lExpExcel
		nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
		If nHandle > 0
			fWrite(nHandle, "Tipo Dependente;")				//-- Cabeçalhos planilha
			fWrite(nHandle, "C.Custo;")						//-- Cabeçalhos planilha
			fWrite(nHandle, "Descrição C.Custos;")			//-- Cabeçalhos planilha
			fWrite(nHandle, "Matrícula;")					//-- Cabeçalhos planilha
			fWrite(nHandle, "Nome;")						//-- Cabeçalhos planilha
			fWrite(nHandle, "Tipo de lançamento;")			//-- Cabeçalhos planilha
			fWrite(nHandle, "Tipo do Benefícios;")			//-- Cabeçalhos planilha
			fWrite(nHandle, "Fornecedor;")					//-- Cabeçalhos planilha
			fWrite(nHandle, "Tipo do Plano;")				//-- Cabeçalhos planilha
			fWrite(nHandle, "Codigo-Descrição do Plano;")	//-- Cabeçalhos planilha
			fWrite(nHandle, "Valor do funcionário;")		//-- Cabeçalhos planilha
			fWrite(nHandle, "Valor da empresa;")			//-- Cabeçalhos planilha
			fWrite(nHandle, "Valor Total")					//-- Cabeçalhos planilha
			fWrite(nHandle, CRLF ) 					//-- Pula linha
		Endif
	Endif
	cAntMat := ""
                              
	While !(cAliasQ)->(Eof()) .And. If( lExeQry, .T., &cInicio <= cFim )
	
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Movimenta Regua Processamento                                ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IncRegua()
	
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cancela ImpresÆo ao se pressionar <ALT> + <A>                ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIf
		
		If cAntMat <> ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
			cAntMat := ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
			cCodUsu		:= ""
			cTpOrigem	:= "" 
		EndIf
	
		If !lExeQry 
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Consiste Parametrizacao do Intervalo de Impressao            ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If ( ( cAliasQ )->RA_NOME < cNomeDe )  .Or. ( ( cAliasQ )->RA_NOME > cNomeAte ) .Or. ;
				( ( cAliasQ )->RA_MAT < cMatDe )   .Or. ( ( cAliasQ )->RA_MAT > cMatAte ) .Or. ;
				( ( cAliasQ )->RA_CC < cCcDe )   .Or. ( ( cAliasQ )->RA_CC > cCcAte ) .Or. ;
				!( ( cAliasQ )->RA_SITFOLH $ cSituacao ) .Or. ;
				!( ( cAliasQ )->RA_CATFUNC $ cCategoria )

				dbSelectArea( cAliasQ )
				fTestaTotal()
				Loop
			EndIf
			
			DbSelectArea( cAliasMov )
			DbSetOrder( 1 )
			If !lGSP 
				DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT + cAnoMes, .F. )
			Else
				DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT + cProces + cRoteiro + cPeriodo + cNumPagto, .F. )			
			EndIf
			If Eof()
				dbSelectArea( cAliasQ )
				fTestaTotal()
				Loop
			EndIf
			While !Eof() .and. (cAliasMov)->( &(cAliasMov + "_FILIAL") + &(cAliasMov + "_MAT"))  == ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT
				
				If (!lGSP .and. &(cAliasMov + "_COMPPG") <>  cAnoMes ) .Or. ( lGSP .and. &(cAliasMov + "_PROCES") + &(cAliasMov + "_ROTEIR") + &(cAliasMov + "_PERIOD") + &(cAliasMov + "_NUMPAG") <>  cProces + cRoteiro + cPeriodo + cNumPagto )
					Exit
				EndIf
				
				/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Impressao do Funcionario                                     ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				SRA->( DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT ))
				fImpFun()
				DbSelectArea( cAliasMov )
				DbSkip()
	
			EndDo
			fTestaTotal()
		Else
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Impressao do Funcionario                                     ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			SRA->(DbSeek( ( cAliasQ )->RA_FILIAL + ( cAliasQ )->RA_MAT ))
			fImpFun()
			
			fTestaTotal()
		
		EndIf

	EndDo
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Termino do Relatorio                                         ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If lExpExcel
		If nHandle > 0
			fClose(nHandle)
			CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
			Ferase( cDirDocs+"\"+cArquivo+".CSV" )
			If ! ApOleClient( 'MsExcel' )
				MsgAlert( 'MsExcel nao instalado' )
				Return
			EndIf
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
		Else
			MsgAlert( "Falha na criação do arquivo" )
		EndIf
	Endif
	If lExeQry 
		(cAliasQ)->(dbclosearea())
	EndIf
	dbSelectArea("SRA")
	Set Filter to
	dbSetOrder(1)
	If !lExpExcel
		Set Device To Screen
		If aReturn[5] = 1
			Set Printer To
			Commit
			ourspool(wnrel)
		EndIf
		MS_FLUSH()
	Endif
Return

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fImpFun		³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Funcionario                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fImpFun()
	Local cCcDesc
	Local cAux 
	Local cAliasImp
	Local cAtCodUsu 
	Local cNome		:= "" 
	Local cTab 		:= "S008"
	Local nCol 		:= 13
    Local nPosTab
	Local lHasDep

	//Tipo			Matr/Seq Nome							Lancamento  		Tp Fornec		  Fornecedor 			   Tp Plano              Cod Plano  	   Vlr. Func		Vlr. Empresa
	//1-Titular		xxxxxx - xxxxxxxxxxxxxxxxxxxxxxxxxxxxx  1-Co-participacao   1-Ass. Odontol.   xx-xxxxxxxxxxxxxxxxxxxx  x-Vlr Fixo por vida   xx-xxxxxxxxxxxxX  999,999,999.99   999,999,999.99
	//2-Dependente
	//3-Agregado

	If lExeQry
		cAliasImp := cAliasQ
	Else
		cAliasImp := cAliasMov
	EndIf

	//-- Imprime o cabecalho inicial do primeiro registro a ser impresso.
	If Empty(cMatAnt) .And. Empty(cFilialAnt) .And. Empty(cCcAnt)
		fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial
		If nOrdem == 1
			If lExeQry
				cCcDesc := (cAliasQ)->CTT_DESC01
			Else
				cCcDesc := fDesc("CTT",(cAliasQ)->RA_CC,"CTT->CTT_DESC01",30)
			EndIf
			fCabec(2,(cAliasQ)->RA_CC,cCcDesc)	//-- Centro de custo
		EndIf
	EndIf
	
	cMatAnt	:= (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT
	If lAnalitico
		cDet := "" 
		
		// Impressao do Tipo
		If cTpOrigem <> (cAliasImp)->( &(cAliasMov + "_ORIGEM" ) ) .Or. lExpExcel
			cTpOrigem	:= (cAliasImp)->( &(cAliasMov + "_ORIGEM" ) )
			cCodUsu		:= ""	// Ao trocar Origem limpa o Cod. Usuario para forcar impressao do 1o nome
			
			If cTpOrigem == "1" 
				cDet += cTpOrigem + "-" + OemToAnsi(STR0012) //"Titular"
			ElseIf cTpOrigem == "2" 
				cDet += cTpOrigem + "-" + OemToAnsi(STR0013) //"Dependente"
			Else
				cDet += cTpOrigem + "-" + OemToAnsi(STR0014) //"Agregado"
			EndIf
			cDet := If( Len(cDet) > 12, Substr(cDet,1,12), cDet+Space(12-Len(cDet)))
		Else
			cDet := Space(12)
		EndIf
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		cDet += "  "

		// Impressao da matricula/Sequencia + Nome
		If cTpOrigem == "1" //Titular
			cAtCodUsu := (cAliasQ)->RA_MAT
		Else
			cAtCodUsu := (cAliasImp)->( &(cAliasMov + "_CODIGO" ) )
		EndIf

		If cCodUsu <> cAtCodUsu
			cCodUsu 	:= cAtCodUsu
			If cTpOrigem == "1" //Titular
				cNome := (cAliasQ)->RA_NOME
			ElseIf cTpOrigem == "2" //Dependente
				DbSelectArea( "SRB" )
				DbSetOrder( RetOrdem( "SRB", "RB_FILIAL+RB_MAT" ) )
				DbSeek( (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT, .F. )
				lHasDep := .F.
				While SRB->( !EOF() ) .and. SRB->RB_FILIAL + SRB->RB_MAT == (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT
					If SRB->RB_COD == cCodUsu
						lHasDep := .T.
						Exit
					EndIf
					SRB->( DbSkip() )
				EndDo
                cNome := SRB->RB_NOME
			Else
				DbSelectArea( "RHM" ) 
				DbSetOrder( RetOrdem( "RHM", "RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO"))
				DbSeek( (cAliasQ)->RA_FILIAL + (cAliasQ)->RA_MAT + (cAliasImp)->(&(cAliasMov + "_TPFORN")) + (cAliasImp)->(&(cAliasMov + "_CODFOR")) + (cAliasImp)->(&(cAliasMov + "_CODIGO")), .F.)
				If !Eof()
					cNome := RHM->RHM_NOME
				EndIf
			EndIf
			cAux := cCodUsu + "-" + cNome
			If lExpExcel
				If nHandle > 0
					fWrite(nHandle, (cAliasQ)->RA_CC + ";" )
					fWrite(nHandle, (cAliasQ)->CTT_DESC01  + ";" )
					fWrite(nHandle, (cAliasQ)->RA_MAT + ";" )
					fWrite(nHandle, cNome + ";" )
					cDet	:= ""
				Endif
			Endif
			If Len(cAux) > 39
				cAux := Substr( cAux, 1, 39 )
			Else
				cAux := cAux + Space( 39 - Len(cAux) )
			EndIf
			cDet += cAux
		Else 
			cDet += Space(39)
		EndIf
		cDet += "  "
		If lExpExcel
			If nHandle > 0
				cDet	:= ""
			Endif
		Endif
		
		// Impressao do Tipo de Lancamentos 
		If (cAliasImp)->( &(cAliasMov + "_TPLAN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0015) //Planos
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPLAN")) == "2"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0016) //Co-Participacao
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPLAN")) + "-" + OemToAnsi(STR0017) //Reembolso
		EndIf
		If Len(cAux) > 17
			cAux := Substr(cAux, 1, 17)
		Else
			cAux := cAux + Space( 17-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		
		// Impressao do Tipo do Fornecedor
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0018) //"Ass. Medica"
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0019) //"Ass. Odontol."
		EndIf
		If Len(cAux) > 15
			cAux := Substr(cAux, 1, 15)
		Else
			cAux := cAux + Space( 15-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		
		// Impressao do Fornecedor 
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1" 
			If ( nPosTab := fPosTab( "S016", (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", 4 ) ) > 0
				cAux := fTabela("S016",nPosTab,5)
			Else 
				cAux := " " 
			EndIf
		Else
			If ( nPosTab := fPosTab( "S017" , (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", 4 ) ) > 0
				cAux := fTabela("S017",nPosTab,5)
			Else 
				cAux := " " 
			EndIf
		EndIf
		cAux := (cAliasImp)->( &(cAliasMov + "_CODFOR")) + "-" + cAux 
		If Len( cAux ) > 23
			cAux := Substr(cAux, 1, 23 )
		Else
			cAux := cAux + Space( 23 - Len(cAux) )
		EndIf
		cDet += cAux + "  "
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
                        
		// Impressao do Tipo do Plano
		If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0020) //"Faixa Salarial" 
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0021) //"Faixa Etaria" 
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3"
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0022) //"Vlr Fixo por vida" 
		Else
			cAux := (cAliasImp)->( &(cAliasMov + "_TPFORN")) + "-" + OemToAnsi(STR0023) //"% Sobre salario" 
		EndIf
		If Len(cAux) > 20
			cAux := Substr(cAux, 1, 20)
		Else
			cAux := cAux + Space( 20-Len(cAux) )
		EndIf
		cDet += cAux + "   "
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		
		// Impressao do Plano
		If (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "1" 
			If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1" 
				cTab := "S008"
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2" 
				cTab := "S009"
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3" 
				cTab := "S028" 
				nCol := 12
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "4" 
				cTab := "S029" 
				nCol := 15
			EndIf
		ElseIf (cAliasImp)->( &(cAliasMov + "_TPFORN")) == "2"
			If (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "1" 
				cTab := "S013" 
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "2" 
				cTab := "S014" 
				nCol := 13
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "3" 
				cTab := "S030" 
				nCol := 12
			ElseIf (cAliasImp)->( &(cAliasMov + "_TPPLAN")) == "4" 
				cTab := "S031" 
				nCol := 15
			EndIf
		EndIf

		If ( nPosTab := fPosTab( cTab, (cAliasImp)->( &(cAliasMov + "_CODFOR")),"=", nCol, (cAliasImp)->( &(cAliasMov + "_PLANO")),"=", 4 ) ) > 0
			cAux := fTabela(cTab,nPosTab,5)
		Else 
			cAux := " " 
		EndIf

		cAux := (cAliasImp)->( &(cAliasMov + "_PLANO")) + "-" + cAux 
		If Len( cAux ) > 16
			cAux := Substr(cAux, 1, 16 )
		Else
			cAux := cAux + Space( 16 - Len(cAux) )
		EndIf
		cDet += cAux + "  "
		If lExpExcel
			If nHandle > 0
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif

		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLRFUN")) , 12,2) + Space(3) 
		If lExpExcel
			If nHandle > 0
				cDet	:= Strtran(cDet,".",",")
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLREMP")) , 12,2) + Space(4)
		If lExpExcel
			If nHandle > 0
				cDet	:= Strtran(cDet,".",",")
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		
		cDet += Str( (cAliasImp)->( &(cAliasMov + "_VLRFUN")) + (cAliasImp)->( &(cAliasMov + "_VLREMP")), 12,2)
		If lExpExcel
			If nHandle > 0
				cDet	:= Strtran(cDet,".",",")
				fWrite(nHandle, cDet + ";" )
				cDet	:= ""
			Endif
		Endif
		
		If !lExpExcel
			Impr(cDet,"C")
		Else
			If nHandle > 0
				fWrite(nHandle, CRLF)
			Endif
		Endif
	EndIf
	
	//-- Acumula Centro de custo / filial / empresa
	If ( nPos := Ascan(aCC,{|x| x[1] == (cAliasQ)->RA_CC}) ) > 0
		aCC[nPos,2]		+= 1
		aCC[nPos,3]		+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aCC[nPos,4]		+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aCC,{(cAliasQ)->RA_CC, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

	If ( nPos	:= Ascan(aFil,{|x| x[1] == (cAliasQ)->RA_FILIAL}) ) > 0
		aFil[nPos,2]	+= 1
		aFil[nPos,3]	+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aFil[nPos,4]	+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aFil,{(cAliasQ)->RA_FILIAL, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

	If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) > 0
		aEmp[nPos,2]	+= 1
		aEmp[nPos,3]	+= (cAliasImp)->( &(cAliasMov + "_VLRFUN"))
		aEmp[nPos,4]	+= (cAliasImp)->( &(cAliasMov + "_VLREMP"))
	Else
		Aadd(aEmp,{cEmpAnt, 1, (cAliasImp)->( &(cAliasMov + "_VLRFUN")), (cAliasImp)->( &(cAliasMov + "_VLREMP"))})
	EndIf

Return Nil

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fTestaTotal	³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Totalizador                                    ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fTestaTotal()

	dbSelectArea( cAliasQ )
	cFilialAnt := (cAliasQ)->RA_FILIAL              // Iguala Variaveis
	cCcAnt     := (cAliasQ)->RA_CC
	dbSkip()
	
	If !lExpExcel
		If Eof()
			fImpCc(cCcAnt)
			fImpFil(cFilialAnt)
			fImpEmp()
		Elseif cFilialAnt # (cAliasQ)->RA_FILIAL
			fImpCc(cCcAnt)
			fImpFil(cFilialAnt)
		Elseif cCcAnt # (cAliasQ)->RA_CC
			fImpCc(cCcAnt)
		EndIf
	Endif

Return

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fImpCc     	³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Totalizador por Centro de Custo                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fImpCc(cCcAnt)
	Local cDet		:= ""
	Local cCcDesc	:=""
	Local nPos		:= 0
	
	If nOrdem == 2 .Or. nOrdem == 3
		Return Nil
	EndIf
	
	If ( nPos	:= Ascan(aCC,{|X| X[1] == cCcAnt}) ) == 0
		Return Nil
	Endif
	
	cDet := Space(1)
	Impr(cDet,"C")
	
	cDet := OemToAnsi(STR0024)  //" T O T A L  C E N T R O  D E  C U S T O S" ## " Funcionário(s) "
	
	cDet += Space(119) + Transform(aCC[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aCC[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aCC[nPos,3]+aCC[nPos,4],"@E 9,999,999.99") + " "
	Impr(cDet,"C")
	
	cDet := Repl("-",220)
	Impr(cDet,"C")

	cDet := ""
	Impr(cDet,"C")
	Impr(cDet,"C")
	
	//-- Imprime cabecalho para o proximo centro de custos
	If lExeQry
		cCcDesc := (cAliasQ)->CTT_DESC01
	Else
		cCcDesc := fDesc("CTT",(cAliasQ)->RA_CC,"CTT->CTT_DESC01",30)
	EndIf
	
	fCabec(2,(cAliasQ)->RA_CC,cCcDesc)	//-- Centro de custo

Return Nil

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fImpFil     	³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Totalizador por Filial                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fImpFil(cFilialAnt)

	Local cDet		:= ""
	Local nPos		:= 0
	Local aInfo		:= {}
	
	If ( nPos	:= Ascan(aFil,{|x| x[1] == cFilialAnt}) ) == 0
		Return Nil
	EndIf
	fInfo(@aInfo,cFilialAnt)

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0010) + aFil[nPos,1] + " - " + aInfo[1] //"Filial : "
	Impr(cDet,"C")

	cDet := Space(1)
	Impr(cDet,"C")

	cDet :=  OemToAnsi(STR0026) //" T O T A L    D A    F I L I A L         " ### "Funcionarios: " 
	cDet += Space(119) + Transform(aFil[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aFil[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aFil[nPos,3]+aFil[nPos,4],"@E 9,999,999.99") + " "

	Impr(cDet,"C")

	cDet := Repl("-",220)
	Impr(cDet,"C")

	Impr("","P")

	//-- Imprime cabecalho da proxima filial
	fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial

Return Nil

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fImpEmp    	³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Totalizador por Empresa                        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fImpEmp()

	Local cDet	:= ""
	Local nPos	:= 0
	Local aInfo	:= {}
	
	If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) == 0
		Return Nil
	EndIf
	fInfo(@aInfo,aFil[len(aFil),1])

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0005)+aEmp[nPos,1]+" - "+aInfo[2] //"Empresa: "
	Impr(cDet,"C")

	cDet := Space(1)
	Impr(cDet,"C")

	cDet := OemToAnsi(STR0025)  //" T O T A L    D A    E M P R E S A       " ### "Funcionarios" 
	cDet += Space(119) + Transform(aEmp[nPos,3],"@E 9,999,999.99") + " "
	cDet += Space(2) + Transform(aEmp[nPos,4],"@E 9,999,999.99") + " "
	cDet += Space(3) + Transform(aEmp[nPos,3]+aEmp[nPos,4],"@E 9,999,999.99") + " "
	Impr(cDet,"C")

	cDet := Repl("-",220)
	Impr(cDet,"C")

	Impr("","F")

Return Nil

/*                                	
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³ fCabec			³Autor³ Mauricio Takakura ³ Data ³05/11/2011³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Impressao do Cabecalho                                      ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³< Vide Parametros Formais >									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ALL			                                                ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Retorno  ³aRotina														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³< Vide Parametros Formais >									³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function	fCabec(nTipo, cCod, cDesc)

	Local cDet	:= ""
	Local aInfo	:= {}

	If Empty(cCod) .Or. lExpExcel
		Return
	EndIf

	If nTipo == 1
		fInfo(@aInfo, cCod)
		cDet := OemToAnsi(STR0010) + cCod + " - " + aInfo[1] // " Filial : "
		Impr(cDet,"C")
		cDet := Space(1)
		Impr(cDet,"C")
	ElseIf nTipo == 2
		cDet := OemToAnsi(STR0011) + cCod + " - " + cDesc //"C.Custo: "
		Impr(cDet,"C")
		cDet := Space(1)
		Impr(cDet,"C")
	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSX1   º Autor ³Ricardo Duarte Costaº Data ³  03/08/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Objetivo desta funcao e verificar se existe o grupo de      º±±
±±º          ³perguntas, se nao existir a funcao ira cria-lo.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³cPerg -> Nome com  grupo de perguntas em questão.           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static Function CriaSx1(cPerg)

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

Aadd(aRegs,{cPerg,"13","Plano De?"           ,"","","mv_chd","C",02,0,0,"G",""                          ,"MV_PAR13",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,"14","Plano Ate?"          ,"","","mv_che","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR14",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,"15","Tipo de Plano"       ,"","","mv_chf","N",01,0,0,"C",""                          ,"MV_PAR15","Ass.Medica","" ,"" ,"","","Ass.Odontológica"  ,"" ,"" ,"","","Ambos","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"16","Exportar para Excel" ,"","","mv_chg","N",01,0,0,"C",""                          ,"MV_PAR16","Não","" ,"" ,"","","Sim"  ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return Nil

