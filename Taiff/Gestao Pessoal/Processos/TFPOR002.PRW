#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TFPOR002 ³ Autor ³ Ricardo Duarte Costa  ³ Data ³ 21.04.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Apontamentos por dia x abonos.				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±*/
User Function TFPOR002()

Local aAreaSM0	:= SM0->(GetArea())
Local aOrd		:= { 'Matricula','Centro de Custo','Nome','C.Custo + Nome'}
Local cDesc1    := "Relatório de Apontamentos por dia x abonos."
Local cDesc2    := 'Será impresso de acordo com os parametros solicitados pelo'
Local cDesc3    := 'usuario.'
Local cString	:= 'SRA' 	//-- Alias do arquivo principal (Base)
Local lEnd		:= .F.  
Local dDtBaseAnt:= dDataBase

Private aReturn  := { 'Zebrado', 1, 'Administração', 2, 2, 1, '',1 } //'Zebrado'###'Administra‡„o'
Private nomeprog := 'TFPOR002'
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := 'TFPOR002  '
Private Titulo   := OemToAnsi( 'Relatório de Apontamentos por dia x abonos.' )
Private AT_PRG   := 'TFPOR002'
Private wCabec0  := 2
Private wCabec1  := "Fl Matric Funcionario                              Data     Evento                    Horas Abono                          Horas Ini Pre abono Fim Pre abono Apontou Usuario                   Documento  Motivo Intranet"
Private wCabec2  := ""
Private aDatas	 := {}
Private aXlsExp	 := {{"Filial","Centro Custo","Matricula","Funcionario","Evento","Desc.Evento","Horas Previstas",aDatas}}
Private Li       := 0
Private nTamanho := "G"
Private CONTFL	 := 1
Private aInfo    := {}
Private wnrel
Private nOrdem
Private cAliasQ  := "WSRA"
Private cMatAnt	 := "@@"
Private cFilialAnt:= "@@"
Private cCcAnt   := "@@"
Private nTotalFil:= 0
Private nTotalCC := 0
Private nTotal	 := 0
Private nQtdeFil := 0
Private nQtdeCC  := 0
Private nQtde    := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CriaSx1(cPerg)
Pergunte( cPerg , .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := 'TFPOR002' //-- Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna a Ordem do Relatorio.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem    := aReturn[8]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis MV_PAR?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private FilialDe  := MV_PAR01	//Filial  De
Private FilialAte := MV_PAR02	//Filial  Ate
Private CcDe      := MV_PAR03	//Centro de Custo De
Private CcAte     := MV_PAR04	//Centro de Custo Ate
Private MatDe     := MV_PAR05	//Matricula De
Private MatAte    := MV_PAR06	//Matricula Ate
Private dDtIni    := MV_PAR07	//Data Inicial
Private dDtFim    := MV_PAR08	//Data Final
Private cSit      := fSqlIn(MV_PAR09,1)	//Situacao
Private cCat      := fSqlIn(MV_PAR10,1)	//Categoria
Private lImpEve	  := mv_par11 == 1
Private cEvento	  := fSqlIn(mv_par12,3)
Private lImpAbo	  := mv_par13 == 1
Private cAbonos	  := fSqlIn(mv_par14,3)
Private nHrsAbater:= mv_par15

dDataBase	:= dDtFim
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi³
³nal preservamos-as nas variaveis: dCaleIni e dCaleFim.		   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	dIniCale   := dDtIni   //-- Data Inicial a considerar para o Calendario
	dFimCale   := dDtFim   //-- Data Final a considerar para o calendario

	IF !( nLastKey == 27 )
		RptStatus( { |lEnd| Impconci( @lEnd , wNRel , cString ) } , Titulo )
	EndIF

	RestArea(aAreaSM0)
	dDataBase	:= dDtBaseAnt

Return()



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Impconci  ºAutor  ³Microsiga           º Data ³  04/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao de impressao do relatorio.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Impconci( lEnd, wNRel, cString )

Local cAcessaSRA	:= &("{ || " + ChkRH("TFPOR002","SRA","2") + "}")
Local aTabPadrao	:= {}
Local cFilMatAnt	:= "@@@@@@@@"
Local cQuery		:= ""
Local lSPJExclu		:= !Empty( xFilial("SPJ") )
Local dIniPonMes	:= ctod("")
Local dFimPonMes	:= ctod("")
Local dPerIni		:= ctod("")
Local dPerFim		:= ctod("")
Local nx			:= dDtIni
Local ny			:= 0
Local nz			:= 0

Private aImp		:= {}
Private aPrevisto	:= {}
Private cFilRegra	:= "  "
Private nHrsPrev	:= 0

//-- Monta array de datas
	For nx := dDtIni to dDtFim
	Aadd(aDatas,Dtoc(nx))
//	Aadd(aDatas,"Abono")
//	Aadd(aDatas,Dtoc(nx))
	next nx

lEnd:=.F.

SRA->(DbSetOrder(1))

cQuery := " "

//-- Movimento aberto
cQuery += " SELECT "
cQuery += "        ra_filial, "
cQuery += "        ra_mat, "
cQuery += "        ra_nome, "
cQuery += "        ra_cc, "
cQuery += "        pc_data, "
cQuery += "        pc_pd, "
cQuery += "        p9_desc, "
cQuery += "        pc_quantc, "
cQuery += "        pc_abono, "
cQuery += "        p6_desc, "
cQuery += "        pc_qtabono "
cQuery += " FROM   "+RetSqlName("SRA")+" D "
cQuery += "        left join "+RetSqlName("SPC")+" A "
cQuery += "                ON A.pc_filial = ra_filial "
cQuery += "                   AND pc_mat = ra_mat "
cQuery += "                   AND A.pc_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
cQuery += "                   AND A.pc_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
cQuery += "                   AND A.pc_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
cQuery += "                   AND A.d_e_l_e_t_ = ' ' "
	If !lImpEve
	cQuery += "                   AND A.pc_pd IN("+cEvento+")"
	Endif
	If !lImpAbo
	cQuery += "                   AND A.pc_abono IN("+cAbonos+")"
	Endif
cQuery += "        left join "+RetSqlName("SP9")+" B "
cQuery += "                ON A.pc_pd = p9_codigo "
cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
cQuery += "        left join "+RetSqlName("SP6")+" E "
cQuery += "               ON A.pc_abono = p6_codigo "
cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
cQuery += " WHERE  D.d_e_l_e_t_ = ' ' "
cQuery += "        AND D.ra_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
cQuery += "        AND D.ra_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
cQuery += "        AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
cQuery += "        AND D.ra_sitfolh IN("+cSit+")"
cQuery += "        AND D.ra_catfunc IN("+cCat+")"
cQuery += "        AND D.ra_admissa <= '"+dtos(dDtFim)+"'"
cQuery += "        AND ( D.ra_demissa = '        ' or D.ra_demissa >= '"+dtos(dDtIni)+"' )"

//-- União de movimento fechado com movimento aberto
cQuery += " UNION ALL"

//-- Movimento fechado
cQuery += " SELECT "
cQuery += "        ra_filial, "
cQuery += "        ra_mat, "
cQuery += "        ra_nome, "
cQuery += "        ra_cc, "
cQuery += "        ph_data, "
cQuery += "        ph_pd, "
cQuery += "        p9_desc, "
cQuery += "        ph_quantc, "
cQuery += "        ph_abono, "
cQuery += "        p6_desc, "
cQuery += "        ph_qtabono "
cQuery += " FROM   "+RetSqlName("SRA")+" D "
cQuery += "        left join "+RetSqlName("SPH")+" A "
cQuery += "                ON A.ph_filial = ra_filial "
cQuery += "                   AND ph_mat = ra_mat "
cQuery += "                   AND A.d_e_l_e_t_ = ' ' "
cQuery += "                   AND A.ph_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
cQuery += "                   AND A.ph_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
cQuery += "                   AND A.ph_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
	If !lImpEve
	cQuery += "                   AND A.ph_pd IN("+cEvento+")"
	Endif
	If !lImpAbo
	cQuery += "                   AND A.ph_abono IN("+cAbonos+")"
	Endif
cQuery += "        left join "+RetSqlName("SP9")+" B "
cQuery += "                ON A.ph_pd = p9_codigo "
cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
cQuery += "        left join "+RetSqlName("SP6")+" E "
cQuery += "               ON A.ph_abono = p6_codigo "
cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
cQuery += " WHERE  D.d_e_l_e_t_ = ' ' "
cQuery += "       AND D.ra_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
cQuery += "       AND D.ra_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
cQuery += "       AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
cQuery += "       AND D.ra_sitfolh IN("+cSit+")"
cQuery += "       AND D.ra_catfunc IN("+cCat+")"
cQuery += "       AND D.ra_admissa <= '"+dtos(dDtFim)+"'"
cQuery += "       AND ( D.ra_demissa = '        ' or D.ra_demissa >= '"+dtos(dDtIni)+"' )"

cQuery	+= " ORDER BY "
	If nOrdem == 1
	cQuery	+= " RA_FILIAL, RA_MAT, PC_DATA, PC_PD"
	ElseIf nOrdem == 2
	cQuery	+= " RA_FILIAL, RA_CC, RA_MAT, PC_DATA, PC_PD"
	ElseIf nOrdem == 3
	cQuery	+= " RA_FILIAL, RA_NOME, RA_MAT, PC_DATA, PC_PD"
	ElseIf nOrdem == 4
	cQuery	+= " RA_FILIAL, RA_CC, RA_NOME, PC_DATA, PC_PD"
	Endif

cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"
TcSetField("WSRA","PC_DATA","D",8,0)

//-- Inicializa R‚gua de Impress„o
SetRegua(WSRA->(RecCount()))

dbSelectArea("WSRA")
cLastFil	:= "@@"

	While WSRA->( !Eof() )

	//-- Incrementa a R‚gua de Impress„o
	IncRegua()

	//-- Cancela a Impress„o case se pressione Ctrl + A
		If lEnd
		IMPR(cCancela,'C')
		Exit
		EndIF

	Set Device to Printer
    
	//-- Posiciona no funcionário
	SRA->(Dbseek(WSRA->(RA_FILIAL+RA_MAT)))
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		SRA->(dbSkip())
		Loop
		EndIf
	
	//-- Mudança de Filial
		If cLastFil <> SRA->RA_FILIAL

	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Atualiza a Filial Corrente           						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cLastFil := SRA->RA_FILIAL
        cFilRegra:= fFilFunc("SPA") 
		
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega periodo de Apontamento Aberto						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			IF !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .F. , cLastFil )
			Exit
			EndIF

    	/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Obtem datas do Periodo em Aberto							  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		GetPonMesDat( @dIniPonMes , @dFimPonMes , cLastFil )
		
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega as Tabelas de Horario Padrao						  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			IF ( lSPJExclu .or. Empty( aTabPadrao ) )
			aTabPadrao := {}
			fTabTurno( @aTabPadrao , IF( lSPJExclu , cLastFil , NIL ) )
			EndIF

		Endif
	
		If cFilMatAnt <> SRA->RA_FILIAL+SRA->RA_MAT

		cFilMatAnt	:= SRA->RA_FILIAL+SRA->RA_MAT
		aImp		:= {}
		aPrevisto	:= {}
		aPeriodos	:= Monta_per( dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )
	   	
	   	/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Corre Todos os Periodos 									  ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		naPeriodos := Len( aPeriodos )
			For nX := 1 To naPeriodos
	
	   		/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Reinicializa as Datas Inicial e Final a cada Periodo Lido.	  ³
			³Os Valores de dPerIni e dPerFim foram preservados nas   varia³
			³veis: dCaleIni e dCaleFim.									  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	        dPerIni		:= aPeriodos[ nX , 1 ]
	        dPerFim		:= aPeriodos[ nX , 2 ] 
	
	   		/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Obtem as Datas para Recuperacao das Marcacoes				  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	        dMarcIni	:= aPeriodos[ nX , 3 ]
	        dMarcFim	:= aPeriodos[ nX , 4 ]
	
	   		/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Verifica se Impressao eh de Acumulado						  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			lImpAcum := ( dPerFim < dIniPonMes )
			   
		    /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Retorna Turno/Sequencia das Marca‡”es Acumuladas			  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				IF ( lImpAcum )
	   			/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Considera a Sequencia e Turno do Cadastro            		  ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				cTurno	:= SRA->RA_TNOTRAB
				cSeq	:= SRA->RA_SEQTURN  
					IF SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni) ) ) .and. !Empty(SPF->PF_SEQUEPA)
					cTurno	:= SPF->PF_TURNOPA
					cSeq	:= SPF->PF_SEQUEPA
					Else
		    		/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³ Tenta Achar a Sequencia Inicial utilizando RetSeq()³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						IF !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty( cSeq )
		    			/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Tenta Achar a Sequencia Inicial utilizando fQualSeq()		  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						cSeq := fQualSeq( NIL , aTabPadrao , dPerIni , @cTurno )
						EndIF
					EndIF
				Else
	   			/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³Considera a Sequencia e Turno do Cadastro            		  ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				cTurno	:= SRA->RA_TNOTRAB
				cSeq	:= SRA->RA_SEQTURN  
				EndIF
		
		    /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Carrega Arrays com as Marca‡”es do Periodo (aMarcacoes), com³
			³o Calendario de Marca‡”es do Periodo (aTabCalend) e com    as³	
			³Trocas de Turno do Funcionario (aTurnos)					  ³	
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			( aMarcacoes := {} , aTabCalend := {} , aTurnos := {} )   

			//-- Considera a Data de Admissao para o Inicio do Periodo
			dtInicio:=Max(aPeriodos[nX,3],SRA->RA_ADMISSA)                    
	
			//-- Monta calendario com horarios de trabalho
				If !CriaCalend( Max(aPeriodos[nX,1],SRA->RA_ADMISSA),aPeriodos[nX,2],cTurno,cSeq,aTabPadrao,@aTabCalend,SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_CC,@aTurnos,NIL,NIL,.F.)
				Loop
				EndIf
	
			//-- Apura as horas trabalhadas a partir do calendario de trabalho
			nHrsPrev := SomaHoras(nHrsPrev,fHrsPrev(aTabCalend,dtInicio,aPeriodos[nX,4]))

			Next nX
		//-- Abater a quantidade de horas que for preenchida nos parâmetros.
		Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do Funcionario                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fImpFun(aImp,aPrevisto)
	fTestaTotal()  // Quebras e Skips

	Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
WSRA->(DbCloseArea())

dbSelectArea('SRA')
dbSetOrder(1)

cDirDocs   	:= MsDocPath()
cArquivo   	:= CriaTrab(,.F.)
cPath		:= AllTrim(GetTempPath())
nHandle 	:= MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
	If nHandle > 0
		For nx := 1 to len(aXlsExp)
		cDet	:= ""
			For ny := 1 to len(aXlsExp[nx])-1
				If valtype(aXlsExp[nx][ny]) == "N"
				cDet	+= Transform(aXlsExp[nx][ny],"@E 999,999,999.99")
				ElseIf valtype(aXlsExp[nx][ny]) == "D"
				cDet	+= dtoc(aXlsExp[nx][ny],"DDMMYYYY")
				Else
				cDet	+= alltochar(aXlsExp[nx][ny])
				Endif
				If ny <> len(aXlsExp[nx])
				cDet	+= ";"
				Endif
			Next ny
		//-- Relatório de
			For nz := 1 to len(aXlsExp[nx,ny])
				If valtype(aXlsExp[nx][ny][nz]) == "N"
				cDet	+= Transform(aXlsExp[nx][ny][nz],"@E 999,999,999.99")
				ElseIf valtype(aXlsExp[nx][ny][nz]) == "D"
				cDet	+= dtoc(aXlsExp[nx][ny][nz],"DDMMYYYY")
				Else
				cDet	+= alltochar(aXlsExp[nx][ny][nz])
				Endif
				If nz <> len(aXlsExp[nx,ny])
				cDet	+= ";"
				Endif
			Next nz
		cDet	+= CRLF
		//-- Grava a linha do funcionário
		fWrite(nHandle,cDet)
		Next nx
		
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	Ferase(cDirDocs+"\"+cArquivo+".CSV")
	Aviso("Atenção","A planilha foi gerada em "+cPath+cArquivo+".CSV",{"Ok"})
		If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
		Return
		EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	Else
	MsgAlert( "Falha na criação do arquivo" )
	Endif

Set Filter To
Set Device To Screen
	If aReturn[5] == 1
	Set Printer To
	Commit
	Endif
MS_FLUSH()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpFun  ³ Autor ³ Prima Informatica     ³ Data ³ 30.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Funcionario                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFun													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                         			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpFun(aImp,aPrevisto)

Local nPosDia	:= 0
Local nPosFunc	:= 0
Local aHrsFunc	:= Array(17)           
Local aDtAux	:= Array(len(aDatas))
Afill(aHrsFunc,"")
Afill(aDtAux,0)

//-- Pesquisa se o funcionário e evento já foram gravados no array
	If (nPosFunc	:= Ascan(aXlsExp,{|X| X[1]+X[3]+X[5] == (cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT+(cAliasQ)->PC_PD})) > 0
	aDtAux	:= Aclone(aXlsExp[nPosFunc,Len(aXlsExp[1])])
	Endif

nPosDia		:= Ascan(aDatas,{|X| X == Dtoc((cAliasQ)->PC_DATA) })
	If nPosDia > 0
	aDtAux[nPosDia]		:= Somahoras(aDtAux[nPosDia],(cAliasQ)->PC_QUANTC)
//	aDtAux[nPosDia+1]	:= (cAliasQ)->P6_DESC
//	aDtAux[nPosDia+2]	:= Somahoras(aDtAux[nPosDia+2],(cAliasQ)->PC_QTABONO)
	Endif

//-- Se já houver registro de apontamento nesta data atualiza o array com os totais atualizados
	If nPosFunc > 0
	aXlsExp[nPosFunc,Len(aXlsExp[1])] := Aclone(aDtAux)
	Else
	//-- Acrescenta as horas previstas somente no primeiro cabeçalho do funcionário
		If Ascan(aXlsExp,{|X| X[1]+X[3] == (cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT}) == 0
		Aadd(aXlsExp,{;
		(cAliasQ)->ra_filial,;
		(cAliasQ)->ra_cc+"-"+FDESC("CTT",(cAliasQ)->ra_cc,"CTT_DESC01"),;
		(cAliasQ)->ra_mat,;
		(cAliasQ)->ra_nome,;
		space(len((cAliasQ)->pc_pd)),;
		space(len((cAliasQ)->p9_desc)),;
		nHrsPrev,;
		Aclone(aDtAux);
		})
		Endif

	//-- Acrescenta o primeiro evento do mesmo funcionário
		If !Empty((cAliasQ)->pc_pd)
		Aadd(aXlsExp,{;
		(cAliasQ)->ra_filial,;
		(cAliasQ)->ra_cc+"-"+FDESC("CTT",(cAliasQ)->ra_cc,"CTT_DESC01"),;
		(cAliasQ)->ra_mat,;
		(cAliasQ)->ra_nome,;
		(cAliasQ)->pc_pd,;
		(cAliasQ)->p9_desc,;
		0,;
		Aclone(aDtAux);
		})
		Endif
	Endif

//-- Zera sempre a quantidade de horas previstas
nHrsPrev	:= 0

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fTestaTotal ³ Autor ³ Prima Informatica   ³ Data ³ 30.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizacao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fTestaTotal												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                         			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fTestaTotal()

dbSelectArea( cAliasQ )
cFilialAnt := (cAliasQ)->RA_FILIAL              // Iguala Variaveis
cCcAnt     := (cAliasQ)->RA_CC
(cAliasQ)->(dbSkip())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSX1   º Autor ³ PRIMA INFORMATICA  º Data ³  28/11/09   º±±
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
cPerg := PADR(cPerg,10)

Aadd(aRegs,{cPerg,"01","Filial de ?"         ,"","","mv_ch1","C",02,0,0,"G",""                          ,"MV_PAR01",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?"         ,"","","mv_ch2","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR02",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"03","Centro de Custo de ?","","","mv_ch3","C",09,0,0,"G",""                          ,"MV_PAR03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","CTT","","",""})
Aadd(aRegs,{cPerg,"04","Centro de Custo Ate?","","","mv_ch4","C",09,0,0,"G","NaoVazio()"                ,"MV_PAR04",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","CTT","","",""})
Aadd(aRegs,{cPerg,"05","Matricula de ?"      ,"","","mv_ch5","C",06,0,0,"G",""                          ,"MV_PAR05",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"06","Matricula Ate?"      ,"","","mv_ch6","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR06",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"07","Data Início ?"       ,"","","mv_ch7","D",08,0,0,"G","NaoVazio()"                ,"MV_PAR07",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"08","Data Final  ?"       ,"","","mv_ch8","D",08,0,0,"G","NaoVazio()"                ,"MV_PAR08",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"09","Situacoes ?"         ,"","","mv_ch9","C",05,0,0,"G","fSituacao  "               ,"MV_PAR09",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"10","Categorias?"         ,"","","mv_cha","C",12,0,0,"G","fCategoria "               ,"MV_PAR10",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"11","Todos os eventos?"   ,"","","mv_chb","C",01,0,1,"C",""                          ,"MV_PAR11","Sim   " ,"" ,"" ,"","","Não"  ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"12","Eventos?"            ,"","","mv_chc","C",60,0,0,"G","fEventos(NIL,NIL)    "     ,"MV_PAR12",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"13","Todos os abonos?"    ,"","","mv_chd","C",01,0,1,"C",""                          ,"MV_PAR13","Sim   " ,"" ,"" ,"","","Não"  ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"14","Abonos?"             ,"","","mv_che","C",60,0,0,"G",""                          ,"MV_PAR14",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SP6","","",""})
aAdd(aRegs,{cPerg,"15","Total Hrs.a abater?" ,"","","mv_chf","N",06,2,0,"G",""                          ,"MV_PAR15",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","   ","","",""})

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FSQLIN   ºAutor  ³ PRIMA INFORMATICA  º Data ³  19/06/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para Montar a Selecao da Clausula IN do SQL.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fSqlIN( cTexto, nStep )

 Local cRet := ""
 Local i
 
 cTexto := Rtrim( cTexto )

	If Len( cTexto ) > 0
		For i := 1 To Len( cTexto ) Step nStep
        cRet += "'" + SubStr( cTexto, i, nStep ) + "'"
        
			If i + nStep <= Len( cTexto )
           cRet += ","
			EndIf
		Next
	EndIf

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Monta_Per³ Autor ³Equipe Advanced RH     ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function Monta_Per( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )

Local aPeriodos := {}
Local cFilSPO	:= xFilial( "SPO" , cFil )
Local dAdmissa	:= SRA->RA_ADMISSA
Local dPerIni   := Ctod("//")
Local dPerFim   := Ctod("//")

SPO->( dbSetOrder( 1 ) )
SPO->( dbSeek( cFilSPO , .F. ) )
	While SPO->( !Eof() .and. PO_FILIAL == cFilSPO )
                       
    dPerIni := SPO->PO_DATAINI
    dPerFim := SPO->PO_DATAFIM  

    //-- Filtra Periodos de Apontamento a Serem considerados em funcao do Periodo Solicitado
		IF dPerFim < dDataIni .OR. dPerIni > dDataFim
		SPO->( dbSkip() )  
		Loop  
		Endif

    //-- Somente Considera Periodos de Apontamentos com Data Final Superior a Data de Admissao
		IF ( dPerFim >= dAdmissa )
       aAdd( aPeriodos , { dPerIni , dPerFim , Max( dPerIni , dDataIni ) , Min( dPerFim , dDataFim ) } )
		Else
		Exit
		EndIF

	SPO->( dbSkip() )

	End While

	IF ( aScan( aPeriodos , { |x| x[1] == dIniAtu .and. x[2] == dFimAtu } ) == 0.00 )
	dPerIni := dIniAtu
	dPerFim	:= dFimAtu 
		IF !(dPerFim < dDataIni .OR. dPerIni > dDataFim)
			IF ( dPerFim >= dAdmissa )
			aAdd(aPeriodos, { dPerIni, dPerFim, Max(dPerIni,dDataIni), Min(dPerFim,dDataFim) } )
			EndIF
		Endif
	EndIF

Return( aPeriodos )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fHrsPrev ³ Autor ³ Alexsandro Pereira    ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function fHrsPrev(aTabCalend,dPerIni,dPerfim)

Local nHrsPrev := 0
Local nX       := 0
Local dData    := 0
Local cTipodia 		:= ''        
Local lTrbFeriado	:=.F.
Local cFRegra		:= ''   
Local cOrdem		:= '!!'  
Local lAfastado		:= .F. 
Local lForaPer		:= .F.

	For nX := 1 To Len(aTabCalend)
    
	dData := aTabCalend[nX,1]      
 
		
    //Somente verifica afastamento para Ordem ainda nao lida
		If cOrdem <> aTabCalend[nX,2]
	   cOrdem	:= aTabCalend[nX,2]  
  	   //-- Desconsidera as datas fora do periodo solicitado
	   lForaPer	:= (dData < dPerIni .OR. dData > dPerFim)  .OR. SRA->( RA_SITFOLH $ 'DúT' .and. dData > RA_DEMISSA ) 
	   //-- Desconsidera as datas de afastamento             
	   lAfastado:=  fAfasta(SRA->RA_FILIAL,SRA->RA_MAT,dData)                               
		Endif
    
    //Desconsidera a data de APONTAMENTO se funcionario afastado ou se a data estiver fora do periodo solicitado.
		If lAfastado .OR. lForaPer
       Loop
		Endif
    
	    //-- Verifica se funcionario Trabalha em Feriado
		If cfRegra <> ( cFilRegra + aTabCalend[ nX , 23 ] )
       cFRegra		:= ( cFilRegra + aTabCalend[ nX , 23 ]  )
       lTrbFeriado	:= GetTrbFer( cFilRegra , aTabCalend[ nX , 23 ] )
		Endif

    // *** Verifica Tipo Dia ***
    //-- Se Feriado 
         //-- Se Excecao
              //Tipo Dia
         //--Senao Excecao     
	         //-- Se NaoTrabalha Feriado
	         //   Tipo dia  = "Feriado"
	         //---Senao NaoTrabalha Feriado
	         //   Tipo dia     
	         //-- Fim se Nao Trabalha Feriado
         //-- Fim se Escecao
    //Senao
    //   Tipo Dia
    //-- Fim se Feriado
    
	cTipoDia	:= IF( aTabCalend[ nX , 19 ] , IF(  aTabCalend[ nX , 10 ]  == "E" , aTabCalend[ nX , 06 ] , IF(!lTrbFeriado,"F",aTabCalend[ nX , 06 ] ) ) , aTabCalend[ nX , 06 ] )                  
    
    //-- Descarta as Horas da Tabela para Dias diferentes de Trabalhado
		If cTipoDia !='S'
       Loop
		Endif

	//-- Verifica o total de horas trabalhadas da jornada
		If !Empty(aTabCalend[nX,7])
		nHrsPrev := SomaHoras(nHrsPrev,SubHoras(aTabCalend[nX,7],If(aTabCalend[nX,4]=="1E",nHrsAbater,0.00)))
		Endif

	Next nX
Return nHrsPrev

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GetTrbFer  ³ Autor ³ Equipe RH             ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna  .T. se Trabalha .F. senao.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GetTrbFer(cFil, cRegra)                                     ³±± 
±±³          ³ cFil   -> Filial para Consulta da Regra em SPA              ³±±
±±³          ³ cRegra -> Regra a ser Pesquisada                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Absent                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function GetTrbFer( cFil , cRegra )
Return( ( PosSPA( cRegra , cFil , "PA_FERIADO" , 1 , .F. ) == "S" ) )

