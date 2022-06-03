#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TFPOR001 ³ Autor ³ Ricardo Duarte Costa  ³ Data ³ 21.04.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conciliação Apontamento X Abonos.         				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±± 
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±*/
User Function TFPOR001()

Local aAreaSM0	:= SM0->(GetArea())
Local aOrd		:= { 'Matricula','Centro de Custo','Nome','C.Custo + Nome'}
//Local cHtml		:= "" 
//Local cAviso		
Local cDesc1    := "Conciliação apontamentos X abonos"
Local cDesc2    := 'Será impresso de acordo com os parametros solicitados pelo'
Local cDesc3    := 'usuario.'
Local cString	:= 'SRA' 	//-- Alias do arquivo principal (Base)
Local lEnd		:= .F.  

Private aReturn  := { 'Zebrado', 1, 'Administração', 2, 2, 1, '',1 } //'Zebrado'###'Administra‡„o'
Private nomeprog := 'TFPOR001'
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := 'TFPOR001  '
Private Titulo   := OemToAnsi( 'Conciliação apontamentos X abonos' )
Private AT_PRG   := 'TFPOR001'
Private wCabec0  := 2
Private wCabec1  := "Fl Matric Funcionario                              Data     Evento                    Horas Abono                          Horas Ini Pre abono Fim Pre abono Apontou Usuario                   Documento  Motivo Intranet"
Private wCabec2  := ""
Private aXlsExp	 := {{"Filial","Matricula","Funcionario","Data","Evento","Desc.Evento","Horas","Abono","Desc.Abono","Horas","Ini Pre abono","Hrs","Fim Pre abono","Hrs","Apontou","Usuario"}}
//Private aXlsExp	 := {{"Filial","Matricula","Funcionario","Data","Evento","Desc.Evento","Horas","Abono","Desc.Abono","Horas","Ini Pre abono","Hrs","Fim Pre abono","Hrs","Apontou","Usuario","Tipo do Dia","1E HP","1S HP","2E HP","2S HP","3E HP","3S HP","4E HP","4S HP","1E HR","1S HR","2E HR","2S HR","3E HR","3S HR","4E HR","4S HR"}}
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
wnrel := 'TFPOR001' //-- Nome Default do relatorio em Disco
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
Private cTipo     := If(mv_par11==1,"B",If(mv_par11==2,"H","A"))
//Private cOrigem	  := If(mv_par12==1,"I",If(mv_par12==2,"O","A"))
Private lImpEve	  := mv_par12 == 1
Private cEvento	  := fSqlIn(mv_par13,3)
Private lImpAbo	  := mv_par14 == 1
Private cAbonos	  := fSqlIn(mv_par15,3)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi³
³nal preservamos-as nas variaveis: dCaleIni e dCaleFim.		   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dIniCale   := dDtIni   //-- Data Inicial a considerar para o Calendario
dFimCale   := dDtFim   //-- Data Final a considerar para o calendario

	IF !( nLastKey == 27 )
	SetDefault( aReturn , cString )
		IF !( nLastKey == 27 )
	    RptStatus( { |lEnd| Impconci( @lEnd , wNRel , cString ) } , Titulo )
		EndIF
	EndIF

RestArea(aAreaSM0)

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
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Impconci( lEnd, wNRel, cString )

	Local cAcessaSRA	:= &("{ || " + ChkRH("TFPOR001","SRA","2") + "}")
	Local aTabPadrao	:= {}
	Local cFilMatAnt	:= "@@@@@@@@"
	Local cQuery		:= ""
	Local lSPJExclu		:= !Empty( xFilial("SPJ") )
	Local dIniPonMes	:= ctod("")
	Local dFimPonMes	:= ctod("")
	Local dPerIni		:= ctod("")
	Local dPerFim		:= ctod("")
	Local nX 			:= 0
	Local ny			:= 0

	Private aImp		:= {}
	Private aPrevisto	:= {}

	lEnd:=.F.

	SRA->(DbSetOrder(1))

	cQuery := " "

//-- Imprime os abonos
	If cTipo == "B" .Or. cTipo == "A"

		//-- Movimento aberto
		cQuery += " SELECT '1' TIPO, "
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
		cQuery += "        pc_qtabono, "
		cQuery += "        rf0_dtprei, "
		cQuery += "        rf0_horini, "
		cQuery += "        rf0_dtpref, "
		cQuery += "        rf0_horfim, "
		cQuery += "        rf0_abona, "
		cQuery += "        rf0_usuar "
		cQuery += " FROM   "+RetSqlName("SPC")+" A "
		cQuery += "        inner join "+RetSqlName("SP9")+" B "
		cQuery += "                ON A.pc_pd = p9_codigo "
		cQuery += "                   AND p9_clasev NOT IN( '01', 'ZZ' ) "
		cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
		cQuery += "        inner join "+RetSqlName("SRA")+" D "
		cQuery += "                ON A.pc_filial = ra_filial "
		cQuery += "                   AND pc_mat = ra_mat "
		cQuery += "                   AND D.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("RF0")+" C "
		cQuery += "               ON A.pc_filial = rf0_filial "
		cQuery += "                  AND A.pc_mat = rf0_mat "
		cQuery += "                  AND A.pc_data = rf0_dtprei "
		cQuery += "                  AND C.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("SP6")+" E "
		cQuery += "               ON A.pc_abono = p6_codigo "
		cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
		cQuery += " WHERE  A.d_e_l_e_t_ = ' ' "
		cQuery += "        AND A.pc_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
		cQuery += "        AND A.pc_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
		cQuery += "        AND A.pc_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
		cQuery += "        AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
		cQuery += "        AND D.ra_sitfolh IN("+cSit+")"
		cQuery += "        AND D.ra_catfunc IN("+cCat+")"
		If !lImpEve
			cQuery += "       AND A.pc_pd IN("+cEvento+")"
		Endif
		If !lImpAbo
			cQuery += "       AND A.pc_abono IN("+cAbonos+")"
		Endif

		//-- União de movimento fechado com movimento aberto
		cQuery += " UNION ALL"

		//-- Movimento fechado
		cQuery += " SELECT '1' TIPO, "
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
		cQuery += "        ph_qtabono, "
		cQuery += "        rf0_dtprei, "
		cQuery += "        rf0_horini, "
		cQuery += "        rf0_dtpref, "
		cQuery += "        rf0_horfim, "
		cQuery += "        rf0_abona, "
		cQuery += "        rf0_usuar "
		cQuery += " FROM   "+RetSqlName("SPH")+" A "
		cQuery += "        inner join "+RetSqlName("SP9")+" B "
		cQuery += "                ON A.ph_pd = p9_codigo "
		cQuery += "                   AND p9_clasev NOT IN( '01', 'ZZ' ) "
		cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
		cQuery += "        inner join "+RetSqlName("SRA")+" D "
		cQuery += "                ON A.ph_filial = ra_filial "
		cQuery += "                   AND ph_mat = ra_mat "
		cQuery += "                   AND D.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("RF0")+" C "
		cQuery += "               ON A.ph_filial = rf0_filial "
		cQuery += "                  AND A.ph_mat = rf0_mat "
		cQuery += "                  AND A.ph_data = rf0_dtprei "
		cQuery += "        left join "+RetSqlName("SP6")+" E "
		cQuery += "               ON A.ph_abono = p6_codigo "
		cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
		cQuery += " WHERE  A.d_e_l_e_t_ = ' ' "
		cQuery += "        AND A.ph_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
		cQuery += "        AND A.ph_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
		cQuery += "        AND A.ph_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
		cQuery += "        AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
		cQuery += "       AND D.ra_sitfolh IN("+cSit+")"
		cQuery += "       AND D.ra_catfunc IN("+cCat+")"
		If !lImpEve
			cQuery += "       AND A.ph_pd IN("+cEvento+")"
		Endif
		If !lImpAbo
			cQuery += "       AND A.ph_abono IN("+cAbonos+")"
		Endif

	Endif

//-- Se a escolha for AMBOS soma as duas query´s para avaliação
	If cTipo == "A"
		cQuery += " UNION ALL "
	Endif

//-- Se a escolha for AMBOS soma as duas query´s para avaliação
	If cTipo == "H" .or. cTipo == "A"

		//-- Movimento aberto
		cQuery += " SELECT '2' TIPO, "
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
		cQuery += "        pc_qtabono, "
		cQuery += "        pt_dataref rf0_dtprei, "
		cQuery += "        pt_horini rf0_horini, "
		cQuery += "        pt_data rf0_dtpref, "
		cQuery += "        pt_horfim rf0_horfim, "
		cQuery += "        ' ' rf0_abona, "
		cQuery += "        ' ' rf0_usuar "
		cQuery += " FROM   "+RetSqlName("SPC")+" A "
		cQuery += "        inner join "+RetSqlName("SP9")+" B "
		cQuery += "                ON A.pc_pd = p9_codigo "
		cQuery += "                   AND p9_clasev IN( '01' ) "
		cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
		cQuery += "        inner join "+RetSqlName("SRA")+" D "
		cQuery += "                ON A.pc_filial = ra_filial "
		cQuery += "                   AND pc_mat = ra_mat "
		cQuery += "                   AND D.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("SPT")+" C "
		cQuery += "               ON A.pc_filial = pt_filial "
		cQuery += "                  AND A.pc_mat = pt_mat "
		cQuery += "                  AND A.pc_data = pt_dataref "
		cQuery += "                  AND C.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("SP6")+" E "
		cQuery += "               ON A.pc_abono = p6_codigo "
		cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
		cQuery += " WHERE  A.d_e_l_e_t_ = ' ' "
		cQuery += "        AND A.pc_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
		cQuery += "        AND A.pc_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
		cQuery += "        AND A.pc_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
		cQuery += "        AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
		cQuery += "        AND D.ra_sitfolh IN("+cSit+")"
		cQuery += "        AND D.ra_catfunc IN("+cCat+")"
		If !lImpEve
			cQuery += "       AND A.pc_pd IN("+cEvento+")"
		Endif
		If !lImpAbo
			cQuery += "       AND A.pc_abono IN("+cAbonos+")"
		Endif

		//-- União de movimento fechado com movimento aberto
		cQuery += " UNION ALL"

		//-- Movimento fechado
		cQuery += " SELECT '2' TIPO, "
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
		cQuery += "        ph_qtabono, "
		cQuery += "        pt_dataref rf0_dtprei, "
		cQuery += "        pt_horini rf0_horini, "
		cQuery += "        pt_data rf0_dtpref, "
		cQuery += "        pt_horfim rf0_horfim, "
		cQuery += "        ' ' rf0_abona, "
		cQuery += "        ' ' rf0_usuar "
		cQuery += " FROM   "+RetSqlName("SPH")+" A "
		cQuery += "        inner join "+RetSqlName("SP9")+" B "
		cQuery += "                ON A.ph_pd = p9_codigo "
		cQuery += "                   AND p9_clasev IN( '01' ) "
		cQuery += "                   AND B.d_e_l_e_t_ = ' ' "
		cQuery += "        inner join "+RetSqlName("SRA")+" D "
		cQuery += "                ON A.ph_filial = ra_filial "
		cQuery += "                   AND ph_mat = ra_mat "
		cQuery += "                   AND D.d_e_l_e_t_ = ' ' "
		cQuery += "        left join "+RetSqlName("SPT")+" C "
		cQuery += "               ON A.ph_filial = pt_filial "
		cQuery += "                  AND A.ph_mat = pt_mat "
		cQuery += "                  AND A.ph_data = pt_dataref "
		cQuery += "        left join "+RetSqlName("SP6")+" E "
		cQuery += "               ON A.ph_abono = p6_codigo "
		cQuery += "                  AND E.d_e_l_e_t_ = ' ' "
		cQuery += " WHERE  A.d_e_l_e_t_ = ' ' "
		cQuery += "        AND A.ph_data BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"'"
		cQuery += "        AND A.ph_filial BETWEEN '"+FilialDe+"' AND '"+FilialAte+"'"
		cQuery += "        AND A.ph_mat BETWEEN '"+MatDe+"' AND '"+MatAte+"'"
		cQuery += "        AND D.ra_cc BETWEEN '"+CcDe+"' AND '"+CcAte+"'"
		cQuery += "       AND D.ra_sitfolh IN("+cSit+")"
		cQuery += "       AND D.ra_catfunc IN("+cCat+")"
		If !lImpEve
			cQuery += "       AND A.ph_pd IN("+cEvento+")"
		Endif
		If !lImpAbo
			cQuery += "       AND A.ph_abono IN("+cAbonos+")"
		Endif

	Endif

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
	TcSetField("WSRA","RF0_DTPREI","D",8,0)
	TcSetField("WSRA","RF0_DTPREF","D",8,0)

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
		    /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Importante: 												  ³
			³ O periodo fornecido abaixo para recuperar as marcacoes   cor³
			³ respondente ao periodo de apontamentoo Calendario de 	 Marca³	
			³ ‡”es do Periodo ( aTabCalend ) e com  as Trocas de Turno  do³	
			³ Funcionario ( aTurnos ) integral afim de criar o  calendario³	
			³ com as ordens correspondentes as gravadas nas marcacoes	  ³	
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				IF !GetMarcacoes(	@aMarcacoes					,;	//Marcacoes dos Funcionarios
								@aTabCalend					,;	//Calendario de Marcacoes
								@aTabPadrao					,;	//Tabela Padrao
								@aTurnos					,;	//Turnos de Trabalho
								dPerIni 					,;	//Periodo Inicial
								dPerFim						,;	//Periodo Final
								SRA->RA_FILIAL				,;	//Filial
								SRA->RA_MAT					,;	//Matricula
								cTurno						,;	//Turno
								cSeq						,;	//Sequencia de Turno
								SRA->RA_CC					,;	//Centro de Custo
					IF(lImpAcum,"SPG","SP8")	,;	//Alias para Carga das Marcacoes
								NIL							,;	//Se carrega Recno em aMarcacoes
								.T.							,;	//Se considera Apenas Ordenadas
							    .T.    						,;	//Se Verifica as Folgas Automaticas
							  	.F.    			 			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
						 )
				Loop
					EndIF
		   
		    aPrtTurn:={}
		    Aeval(aTurnos, {|x| If( x[2] >= dPerIni .AND. x[2]<= dPerFim, Aadd(aPrtTurn, x),Nil )} ) 
		   
		    /*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³Carrega o Array a ser utilizado na Impress„o.				  ³
			³aPeriodos[nX,3] --> Inicio do Periodo para considerar as  mar³
			³                    cacoes e tabela						  ³
			³aPeriodos[nX,4] --> Fim do Periodo para considerar as   marca³
			³                    coes e tabela							  ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					IF !fMontaAimp( aTabCalend, aMarcacoes, @aImp,dMarcIni,dMarcFim,aPrevisto)
				Loop
					EndIF
	    
				Next nX

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
				For ny := 1 to len(aXlsExp[nx])
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
	ourspool(wnrel)
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

Local lImpNome	:= cMatAnt<>(cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT
Local nPosDia	:= 0
Local nx		:= 0
Local aHrsFunc	:= Array(17)
Local cUserHE	:= Subs( Embaralha( (cAliasQ)->rf0_usuar, 1), 1, 15)+space(15)
Afill(aHrsFunc,"")

	If Left(cUserHE,4) == "  q@"
	cUserHe	:= "Intranet                      "
	ElseIf Empty(cUserHE)
	cUserHe	:= space(30)
	Endif

cMatAnt	:= (cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT

cDet := If(lImpNome,(cAliasQ)->ra_filial,space(Len((cAliasQ)->ra_filial))) + Space(1)
cDet += If(lImpNome,(cAliasQ)->ra_mat,space(Len((cAliasQ)->ra_mat))) + Space(1)
cDet += If(lImpNome,(cAliasQ)->ra_nome,space(Len((cAliasQ)->ra_nome))) + Space(1)
cDet += dtoc((cAliasQ)->pc_data,"DDMMYYYY") + Space(1)
cDet += (cAliasQ)->pc_pd + Space(1)
cDet += (cAliasQ)->p9_desc + Space(1)
cDet += Transform((cAliasQ)->pc_quantc,"@E 999.99") + Space(1)
cDet += (cAliasQ)->pc_abono + Space(1)
cDet += (cAliasQ)->p6_desc + Space(1)
cDet += Transform((cAliasQ)->pc_qtabono,"@E 999.99") + Space(1)
cDet += dtoc((cAliasQ)->rf0_dtprei,"DDMMYYYY") + Space(1)
cDet += Transform((cAliasQ)->rf0_horini,"@E 99.99") + Space(1)
cDet += dtoc((cAliasQ)->rf0_dtpref,"DDMMYYYY") + Space(1)
cDet += Transform((cAliasQ)->rf0_horfim,"@E 99.99") + Space(1)
cDet += (cAliasQ)->rf0_abona + Space(1)
cDet += If((cAliasQ)->TIPO == "2",cUserHe,(cAliasQ)->rf0_usuar)

Impr(cDet,"C")

//-- Tratamento para o horário previsto
nPosDia	:= Ascan(aImp,{|X| X[1] == (cAliasQ)->pc_data })
	If nPosDia > 0
		For nx := 1 to 17
		//-- Tipo do Dia
			If nx == 1
			aHrsFunc[nx] := If(alltrim(aPrevisto[nPosDia,3])=="S","Trabalhado",If(alltrim(aPrevisto[nPosDia,3])=="N","Não Trabalhado",If(alltrim(aPrevisto[nPosDia,3])=="C","Compensado","DSR")))
		//-- Horário Previsto
			ElseIf nx >= 2 .And. nx <= 9
				If alltrim(aHrsFunc[1]) == "Trabalhado"
					If nx-1 <= Len(aPrevisto[nPosDia,2])
					aHrsFunc[nx]	:= aPrevisto[nPosDia,2,nx-1]
					Endif
				Endif
		//-- Horário Realizado
			ElseIf nx >= 10
				If nx-9 <= Len(aImp[nPosDia])-3
				aHrsFunc[nx]	:= aImp[nPosDia,nx-6]
				Endif
			Endif
		Next nx
	Endif

//-- Tratamento para o horário realizado

Aadd(aXlsExp,{;
(cAliasQ)->ra_filial,;
(cAliasQ)->ra_mat,;
(cAliasQ)->ra_nome,;
dtoc((cAliasQ)->pc_data,"DDMMYYYY"),;
(cAliasQ)->pc_pd,;
(cAliasQ)->p9_desc,;
Transform((cAliasQ)->pc_quantc,"@E 999.99"),;
(cAliasQ)->pc_abono,;
(cAliasQ)->p6_desc,;
Transform((cAliasQ)->pc_qtabono,"@E 999.99"),;
dtoc((cAliasQ)->rf0_dtprei,"DDMMYYYY"),;
Transform((cAliasQ)->rf0_horini,"@E 99.99"),;
dtoc((cAliasQ)->rf0_dtpref,"DDMMYYYY"),;
Transform((cAliasQ)->rf0_horfim,"@E 99.99"),;
(cAliasQ)->rf0_abona,;
	If(WSRA->TIPO=="2",cUserHe,(cAliasQ)->rf0_usuar);
})

/*
			If(WSRA->TIPO=="2",cUserHe,(cAliasQ)->rf0_usuar),;
aHrsFunc[01],;
aHrsFunc[02],;
aHrsFunc[03],;
aHrsFunc[04],;
aHrsFunc[05],;
aHrsFunc[06],;
aHrsFunc[07],;
aHrsFunc[08],;
aHrsFunc[09],;
aHrsFunc[10],;
aHrsFunc[11],;
aHrsFunc[12],;
aHrsFunc[13],;
aHrsFunc[14],;
aHrsFunc[15],;
aHrsFunc[16],;
aHrsFunc[17];

*/

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpCc	  ³ Autor ³ Prima Informatica   ³ Data ³ 06.04.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizacao                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpCc													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                         			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpCc(cCcAnt)
Local cDet	:= ""
//Local nPos	:= 0
//Local nPos1	:= 0
//Local nx	:= 0

	If (nOrdem <> 2 .And. nOrdem <> 4)
	Return Nil
	Endif

	If nTotalCC == 0
	Return Nil
	Endif

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " T O T A L  C E N T R O  D E  C U S T O S: " + STR(nQtdeCC, 5, 0) + " Funcionarios Calculados"
cDet += Space(20) + Transform(nTotalCC,"@E 999,999,999.99")
Impr(cDet,"C")
nTotalCC	:= 0
nQtdeCC		:= 0

cDet := Repl("-",132)
Impr(cDet,"C")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpFil	  ³ Autor ³ Prima Informatica   ³ Data ³ 06.04.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizacao por Filial                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFil 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                         			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpFil(cFilialAnt)

//Local cDescFil
Local cDet	:= ""
//Local nPos	:= 0
Local aInfo	:= {}
//Local aTotal:= {}
//Local nx	:= 0

	If nTotalFil == 0
	Return Nil
	Endif

fInfo(@aInfo,cFilialAnt)

	If nOrdem == 2 .Or. nOrdem == 4
	cDet := Repl("-",132)
	Impr(cDet,"C")
	Endif

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " Filial : "+cFilialAnt+" - "+aInfo[1]
Impr(cDet,"C")

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " T O T A L    D A    F I L I A L: " + STR(nQtdeFil, 5, 0) + " Funcionarios Calculados"
cDet += Space(20) + Transform(nTotalFil,"@E 999,999,999.99")
Impr(cDet,"C")

nQtdeFil	:= 0
nTotalFil	:= 0

cDet := Repl("-",132)
Impr(cDet,"C")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpEmp	  ³ Autor ³ Prima Informatica   ³ Data ³ 06.04.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totalizacao por Empresa                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpEmp 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                         			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpEmp()

Local cDet	:= ""
//Local nPos	:= 0
Local aInfo	:= {}
//Local nx	:= 0

	If nTotal == 0
	Return Nil
	Endif
fInfo(@aInfo,cFilialAnt)

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " Empresa: "+cFilialAnt+" - "+aInfo[2]
Impr(cDet,"C")

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " T O T A L    D A    E M P R E S A: " + STR(nQtde, 5, 0) + " Funcionarios Calculados"
cDet += Space(20) + Transform(nTotal,"@E 999,999,999.99")
Impr(cDet,"C")

cDet := Repl("-",132)
Impr(cDet,"C")

Impr("","F")

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
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

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
Aadd(aRegs,{cPerg,"11","Tipo?"               ,"","","mv_chb","C",01,0,1,"C",""                          ,"MV_PAR11","Abono " ,"" ,"" ,"","","Horas Extras"  ,"" ,"" ,"","","Ambos","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"12","Todos os eventos?"   ,"","","mv_chc","C",01,0,1,"C",""                          ,"MV_PAR12","Sim   " ,"" ,"" ,"","","Não"  ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"13","Eventos?"            ,"","","mv_chd","C",60,0,0,"G","fEventos(NIL,NIL)    "     ,"MV_PAR13",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"14","Todos os abonos?"    ,"","","mv_che","C",01,0,1,"C",""                          ,"MV_PAR14","Sim   " ,"" ,"" ,"","","Não"  ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
aAdd(aRegs,{cPerg,"15","Abonos?"             ,"","","mv_chf","C",60,0,0,"G",""                          ,"MV_PAR15",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SP6","","",""})

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
±±³Fun‡…o    ³FMontaaIMP³ aUTOR ³ EQUIPE DE RH          ³ dATA ³ 09/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o Vetor aImp , utilizado na impressao do espelho     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ POR010IMP                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FMontaAimp(aTabCalend, aMarcacoes, aImp,dInicio,dFim,aPrevisto)

Local cTipAfas   := ""
Local cDescAfas  := ""
Local cOcorr     := ""
Local cOrdem     := ""
Local cTipDia    := ""
Local dData      := Ctod("//")
Local dDtBase    := dFim
Local lRet       := .T.
Local lFeriado   := .T.
Local lTrabaFer  := .F.
Local lAfasta    := .T.   
//Local nX         := 0
Local nDia       := 0
Local nMarc      := 0
Local nLenMarc	 := Len( aMarcacoes )
Local nTab       := 0
Local nContMarc  := 0
Local nDias		 := 0 
Local cFilSPA	 := xFilial("SPA", SRA->RA_FILIAL)

//-- Variaveis ja inicializadas.
aImp := {}

nDias := ( dDtBase - dInicio )
	For nDia := 0 To nDias

	//-- Reinicializa Variaveis.
	dData      := dInicio + nDia
	cOcorr     := ""
	cTipAfas   := ""
	cDescAfas  := ""
	cOcorr	   := ""
	//-- o Array aTabcalend ‚ setado para a 1a Entrada do dia em quest„o.
		IF ( nTab := aScan(aTabCalend, {|x| x[1] == dData .and. x[4] == '1E' }) ) == 0.00
		Loop
		EndIF

	//-- o Array aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
	nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })

	//-- Consiste Afastamentos, Demissoes ou Transferencias.
		IF ( ( lAfasta := aTabCalend[ nTab , 24 ] ) .or. SRA->( RA_SITFOLH $ 'DúT' .and. dData > RA_DEMISSA ) )
		lAfasta		:= .T.
		cTipAfas	:= IF(!Empty(aTabCalend[ nTab , 25 ]),aTabCalend[ nTab , 25 ],fDemissao(SRA->RA_SITFOLH, SRA->RA_RESCRAI) )
		cDescAfas	:= fDescAfast( cTipAfas, Nil, Nil, SRA->( RA_SITFOLH == 'D' .and. dData > RA_DEMISSA ) )
		EndIF

	//Verifica Regra de Apontamento ( Trabalha Feriado ? )
	lTrabaFer := ( PosSPA( aTabCalend[ nTab , 23 ] , cFilSPA , "PA_FERIADO" , 01 ) == "S" )

	//-- Consiste Feriados.
		IF ( lFeriado := aTabCalend[ nTab , 19 ] )  .AND. !lTrabaFer
		cOcorr := aTabCalend[ nTab , 22 ]
		EndIF

	//-- Monta Array com os horários previstos
		If cOrdem <> aTabCalend[nTab,2]
		//-- Salva o dia e o tipo do dia para somente então adicionar os horários previstos daquele dia
		Aadd(aPrevisto,{dData,{},aTabCalend[nTab,6]})
		//-- Sempre que for a mesma ordem adiciona o horário previsto
		Aeval(aTabCalend,{|X| If(X[2]==aTabCalend[nTab,2],Aadd(aPrevisto[len(aPrevisto),2],strtran(strzero(X[3],5,2),".",":")),nil)})
		Endif
	
	//-- Ordem e Tipo do dia em quest„o.
	cOrdem  := aTabCalend[nTab,2]
	cTipDia := aTabCalend[nTab,6]

    //-- Se a Data da marcacao for Posterior a Admissao
		IF dData >= SRA->RA_ADMISSA
		//-- Se Afastado
			If ( lAfasta  .AND. aTabCalend[nTab,10] <> 'E' )
			cOcorr := cDescAfas 
		//-- Se nao for Afastado
			Else

		    //-- Se tiver EXCECAO para o Dia  ------------------------------------------------
				If aTabCalend[nTab,10] == 'E'
		       //-- Se excecao trabalhada
					If cTipDia == 'S'
		          //-- Se nao fez Marcacao
						If Empty(nMarc)
					 cOcorr := '** Ausente **'	
				  //-- Se fez marcacao	 
						Else
		          	 //-- Motivo da Marcacao
							If !Empty(aTabCalend[nTab,11])
					 	cOcorr := AllTrim(aTabCalend[nTab,11])
							Else
					 	cOcorr := '** Excecao nao Trabalhada **'
							EndIf
						Endif
		       //-- Se excecao outros dias (DSR/Compensado/Nao Trabalhado)
					Else
 					//-- Motivo da Marcacao
						If !Empty(aTabCalend[nTab,11])
						cOcorr := AllTrim(aTabCalend[nTab,11])
						Else
						cOcorr := '** Excecao nao Trabalhada **'  
						EndIf
					Endif

		    //-- Se nao Tiver Excecao  no Dia ---------------------------------------------------
				Else
		        //-- Se feriado 
					If lFeriado
		       	    //-- Se nao trabalha no Feriado
						If !lTrabaFer
						cOcorr := If(!Empty(cOcorr),cOcorr,'** Feriado **' )
					//-- Se trabalha no Feriado
						Else
					    //-- Se Dia Trabalhado e Nao fez Marcacao
							If cTipDia == 'S' .and. Empty(nMarc)
							cOcorr := '** Ausente **'
							ElseIf cTipDia == 'D'
							cOcorr := '** D.S.R. **'  
							ElseIf cTipDia == 'C'
							cOcorr := '** Compensado **'
							ElseIf cTipDia == 'N'
							cOcorr := '** Nao Trabalhado **'
							EndIf
						Endif
					Else
		    	    //-- Se Dia Trabalhado e Nao fez Marcacao
						If cTipDia == 'S' .and. Empty(nMarc)
						cOcorr := '** Ausente **'
						ElseIf cTipDia == 'D'
						cOcorr := '** D.S.R. **'
						ElseIf cTipDia == 'C'
						cOcorr := '** Compensado **'
						ElseIf cTipDia == 'N'
						cOcorr := '** Nao Trabalhado **'
						EndIf
				
					Endif
				Endif
			Endif
		Endif
	
	//-- Adiciona Nova Data a ser impressa.
	aAdd(aImp,{})
	aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])

	//-- Ocorrencia na Data.
		If cOcorr == '** Ausente **'
		aAdd( aImp[Len(aImp)], cOcorr) 
		aAdd( aImp[Len(aImp)], Space(01)) 
		Else
		aAdd( aImp[Len(aImp)], Space(01)) 
	  	aAdd( aImp[Len(aImp)], cOcorr )
		Endif

	//-- Marca‡oes ocorridas na data.
		If nMarc > 0
			While nMarc <= nLenMarc .and. cOrdem == aMarcacoes[nMarc,3]
			nContMarc ++
			aAdd( aImp[Len(aImp)], StrTran(StrZero(aMarcacoes[nMarc,2],5,2),'.',':'))
			nMarc ++
			End While
		EndIf

	Next nDia

lRet := If(nContMarc>=1,.T.,.F.)

Return( lRet )

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

