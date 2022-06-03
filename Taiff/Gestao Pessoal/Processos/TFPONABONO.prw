#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFPONABONO� Autor � Ricardo Duarte Costa  � Data � 18.10.13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de abonos para periodos abertos e/ou fechados    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function TFPONABONO()

Local aArea		:= SRA->(getarea())
Local cDesc1  := "Relatorio de Abonos"
Local cDesc2  := "Sera impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := "usuario."
Local cString := "SRA"  					// Alias do arquivo principal (Base)
Local aOrd    := {"Centro de Custo+Matricula", "Centro de Custo+Nome"}

Set Century On

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {"Zebrado",1,"Administracao",2,2,1,"",1 }	//"Zebrado"###"Administra��o"
Private NomeProg := "TFPONABONO"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "TFPONABONO"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aInfo     := {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "TFPONABONO"
Private wCabec0  := 2

Private wCabec1  := "Matric   Funcionario(a)                           Data       Evento Apontado          Horas Abono/Justificativa           Horas"
Private wCabec2  := ""

Private Li       := 0
Private nTamanho := "M"
Private CONTFL	 := 1

//Cria SX1 - Parametros
ValidPerg()

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

Titulo := " RELATORIO DE ABONOS DO PERIODO "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="TFPONABONO"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     	:= aReturn[8]
cFilDe     	:= mv_par01 				// Filial De
cFilAte    	:= mv_par02					// Filial Ate
cCcDe      	:= mv_par03					// Centro de Custo De
cCcAte     	:= mv_par04					// Centro de Custo Ate
cMatDe     	:= mv_par05					// Matricula De
cMatAte    	:= mv_par06					// Matricula Ate
cSituacao  	:= fSqlIN( mv_par07, 1 )	// Situacao do Funcionario
cCategoria 	:= fSqlIN( mv_par08, 1 ) 	// Categoria do Funcionario
dDtApDe 	:= mv_par09					// Per�odo De
dDtApAte 	:= mv_par10					// Per�odo Ate
lGeraXLS	:= If(mv_par11=2, .T., .F. )// Tipo de Impress�o - 1.Relat�rio/2.Excel
lTodosEv	:= If(mv_par12=1, .F., .T. )// Todos os eventos  - 1.N�o/2.Sim
cEventos	:= fSqlIN( mv_par13, 3 ) 	// Eventos do ponto eletr�nico
Titulo		+= Dtoc(dDtApDe,"DDMMYYYY") + " - " + Dtoc(dDtApAte,"DDMMYYYY")
If nLastKey = 27
	Return
Endif

If !lGeraXLS
	SetDefault(aReturn,cString)
Else

	cDirDocs	:= MsDocPath()
	aStru		:= {{"Tipo"},{"Filial"},{"Centro de Custos"},{"Descri��o C.C."},{"Matr�cula"},{"Nome"},{"Dia da Semana"},{"Data"},{"C�d.Evento"},{"Descri��o Evento"},{"Horas Injustificadas"},{"Horas Justificadas"},{"Cod.Justificativa"},{"Descri��o Justificativa"},{"Grupo CID"},{"Descri��o Grupo CID"}}
	cArquivo	:= CriaTrab(,.F.)
	cPath		:= AllTrim(GetTempPath())
	Private oExcelApp
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

	If nHandle <= 0
		Aviso("Aten��o","O arquivo excel n�o pode ser criado.",{"Ok"})
		Return
	Endif
	//-- Grava o cabe�alho da planilha
	aEval(aStru, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aStru), ";", "") ) } )
	fWrite(nHandle, CRLF ) // Pula linha
	
Endif

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| ProcImp(@lEnd,wnRel,cString)},Titulo)

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ProcImp  � Autor � Ricardo Duarte Costa  � Data � 02.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Mapa de Vale Transporte                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � ProcImp(lEnd,wnRel,cString)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ProcImp(lEnd,WnRel,cString)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local cQuery	 := ""
Local cOrder	 := ""

Private cAliasQ	:= "QMOVF"
Private cFilialAnt := "  "
Private cCcAnt     := Space(20)
Private cMatAnt    := space(08)

Private aCC			:= {}
Private aFil		:= {}
Private aEmp		:= {}


If nOrdem == 1
	cOrder	:= "1,2,4,6" //"Centro de Custo+Matricula"
ElseIf nOrdem == 2
	cOrder	:= "1,2,5,6" //"Centro de Custo+Nome"
Endif

//-- Monta query de selecao da informacao
cQuery := " "
//-- Monta senten�a com group by da soma de v�rios movimentos
cQuery += " SELECT ra_filial, "
cQuery += "        ra_cc, "
cQuery += "        ctt_desc01, "
cQuery += "        ra_mat, "
cQuery += "        ra_nome, "
cQuery += "        pc_data, "
cQuery += "        p9_desc, "
cQuery += "        pc_pd, "
cQuery += "        (SUM(PC_QUANTC)-SUM(PC_QTABONO)) PC_QUANTC, "
cQuery += "        TIPO, "
cQuery += "        pc_abono, "
cQuery += "        SUM(PC_QTABONO) PC_QTABONO, "
cQuery += "        P6_DESC, "
cQuery += "        tny_grpcid, "
cQuery += "        tlg_descri "
cQuery += " FROM ("

//-- Eventos selecionados do m�s aberto
cQuery += " SELECT "
cQuery += " RA_FILIAL, RA_CC, CTT_DESC01, RA_MAT, RA_NOME, PC_DATA, P9_DESC,"
cQuery += " PC_PD,"
//cQuery += " PC_QUANTC"
cQuery += " ((pc_quantc-floor(pc_quantc))*100+(floor(pc_quantc)*60))/60 pc_quantc, 
cQuery += " CASE WHEN PC_ABONO = '   ' THEN 'Injustificadas' ELSE 'Justificadas' END TIPO,"
cQuery += " PC_ABONO,"
//cQuery += " PC_QTABONO, "
cQuery += " ((pc_qtabono-floor(pc_qtabono))*100+(floor(pc_qtabono)*60))/60 pc_qtabono, 
cQuery += " ISNULL(P6_DESC,'') P6_DESC,"
cQuery += " tny_grpcid,"
cQuery += " tlg_descri"
cQuery += " FROM "+RetSqlName("SPC")+" A"
cQuery += " LEFT JOIN "+RetSqlName("SPK")+" B "
cQuery += " ON A.PC_FILIAL = B.PK_FILIAL AND A.PC_MAT = B.PK_MAT AND A.PC_PD = B.PK_CODEVE AND A.PC_DATA = B.PK_DATA AND B.D_E_L_E_T_ = ' ' "
cQuery += " AND PC_ABONO <> '   '"
cQuery += " AND A.pc_qtabono = B.pk_hrsabo"
cQuery += " LEFT JOIN "+RetSqlName("SP6")+" C"
cQuery += " ON A.PC_ABONO = C.P6_CODIGO AND C.D_E_L_E_T_ = ' ' "
If Empty(xFilial("SP6"))
	cQuery += " AND C.P6_FILIAL = '  '"
Else
	cQuery += " AND A.PC_FILIAL = C.P6_FILIAL"
Endif
cQuery += " INNER JOIN "+RetSqlName("SRA")+" D"
cQuery += " ON PC_FILIAL = RA_FILIAL AND PC_MAT = RA_MAT AND D.D_E_L_E_T_ = ' '"
cQuery += " INNER JOIN "+RetSqlName("CTT")+" E"
cQuery += " ON RA_CC = CTT_CUSTO AND E.D_E_L_E_T_ = ' '"
If Empty(xFilial("CTT"))
	cQuery += " AND E.CTT_FILIAL = '  '"
Else
	cQuery += " AND D.RA_FILIAL = E.CTT_FILIAL"
Endif
cQuery += " INNER JOIN "+RetSqlName("SP9")+" F"
cQuery += " ON A.PC_PD = F.P9_CODIGO AND F.D_E_L_E_T_ = ' ' "
If Empty(xFilial("SP9"))
	cQuery += " AND F.P9_FILIAL = '  '"
Else
	cQuery += " AND A.PC_FILIAL = F.P9_FILIAL"
Endif
cQuery += " LEFT JOIN "+RetSqlName("RF0")+" G"
cQuery += " ON pc_filial = rf0_filial "
cQuery += " AND pc_mat = rf0_mat "
cQuery += " AND pc_abono = rf0_codabo "
cQuery += " AND pc_data >= rf0_dtprei AND pc_data <= rf0_dtpref"
cQuery += " AND pc_abono <> '   '"
cQuery += " AND G.d_e_l_e_t_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("TNY")+" H"
cQuery += " ON tny_filial = '  '"
cQuery += " AND rf0_natest = tny_natest"
cQuery += " AND h.d_e_l_e_t_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("TLG")+" I"
cQuery += " ON tlg_filial = '  '"
cQuery += " AND tny_grpcid = tlg_grupo"
cQuery += " AND i.d_e_l_e_t_ = ' ' "
cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
If !lTodosEv
	cQuery += " AND A.PC_PD IN("+cEventos+")"
Endif
cQuery += " AND PC_DATA BETWEEN '"+dtos(dDtApDe)+"' AND '"+dtos(dDtApAte)+"'"
cQuery += " AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery += " AND RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
cQuery += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
cQuery += " AND RA_SITFOLH IN("+cSituacao+")"
cQuery += " AND RA_CATFUNC IN("+cCategoria+")"
cQuery += " AND (PC_ABONO = '   ' OR EXISTS(SELECT 1 FROM "+RetSqlName("SP6")+" WHERE A.PC_ABONO = P6_CODIGO AND P6_ABSENT_ = '2' AND D_E_L_E_T_ = ' '))"

cQuery += " UNION ALL"

//-- Eventos selecionados do m�s fechado
cQuery += " SELECT "
cQuery += " RA_FILIAL, RA_CC, CTT_DESC01, RA_MAT, RA_NOME, PH_DATA, P9_DESC,"
cQuery += " PH_PD,"
//cQuery += " PH_QUANTC,	"
cQuery += " ((ph_quantc-floor(ph_quantc))*100+(floor(ph_quantc)*60))/60 ph_quantc,"
cQuery += " CASE WHEN PH_ABONO = '   ' THEN 'Injustificadas' ELSE 'Justificadas' END TIPO,"
cQuery += " PH_ABONO,"
//cQuery += " PH_QTABONO, "
cQuery += " ((ph_qtabono-floor(ph_qtabono))*100+(floor(ph_qtabono)*60))/60 ph_qtabono,"
cQuery += " ISNULL(P6_DESC,'') P6_DESC,"
cQuery += " tny_grpcid,"
cQuery += " tlg_descri"
cQuery += " FROM "+RetSqlName("SPH")+" A"
cQuery += " LEFT JOIN "+RetSqlName("SPK")+" B "
cQuery += " ON A.PH_FILIAL = B.PK_FILIAL AND A.PH_MAT = B.PK_MAT AND A.PH_PD = B.PK_CODEVE AND A.PH_DATA = B.PK_DATA AND B.D_E_L_E_T_ = ' ' "
cQuery += " AND PH_ABONO <> '   '"
cQuery += " AND A.ph_qtabono = B.pk_hrsabo"
cQuery += " LEFT JOIN "+RetSqlName("SP6")+" C"
cQuery += " ON A.PH_ABONO = C.P6_CODIGO AND C.D_E_L_E_T_ = ' ' "
If Empty(xFilial("SP6"))
	cQuery += " AND C.P6_FILIAL = '  '"
Else
	cQuery += " AND A.PH_FILIAL = C.P6_FILIAL"
Endif
cQuery += " INNER JOIN "+RetSqlName("SRA")+" D"
cQuery += " ON PH_FILIAL = RA_FILIAL AND PH_MAT = RA_MAT AND D.D_E_L_E_T_ = ' '"
cQuery += " INNER JOIN "+RetSqlName("CTT")+" E"
cQuery += " ON RA_CC = CTT_CUSTO AND E.D_E_L_E_T_ = ' '"
If Empty(xFilial("CTT"))
	cQuery += " AND E.CTT_FILIAL = '  '"
Else
	cQuery += " AND D.RA_FILIAL = E.CTT_FILIAL"
Endif
cQuery += " INNER JOIN "+RetSqlName("SP9")+" F"
cQuery += " ON A.PH_PD = F.P9_CODIGO AND F.D_E_L_E_T_ = ' ' "
If Empty(xFilial("SP9"))
	cQuery += " AND F.P9_FILIAL = '  '"
Else
	cQuery += " AND A.PH_FILIAL = F.P9_FILIAL"
Endif
cQuery += " LEFT JOIN "+RetSqlName("RF0")+" G"
cQuery += " ON ph_filial = rf0_filial "
cQuery += " AND ph_mat = rf0_mat "
cQuery += " AND ph_abono = rf0_codabo "
cQuery += " AND ph_data >= rf0_dtprei AND ph_data <= rf0_dtpref"
cQuery += " AND ph_abono <> '   '"
cQuery += " AND G.d_e_l_e_t_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("TNY")+" H"
cQuery += " ON tny_filial = '  '"
cQuery += " AND rf0_natest = tny_natest"
cQuery += " AND h.d_e_l_e_t_ = ' ' "
cQuery += " LEFT JOIN "+RetSqlName("TLG")+" I"
cQuery += " ON tlg_filial = '  '"
cQuery += " AND tny_grpcid = tlg_grupo"
cQuery += " AND i.d_e_l_e_t_ = ' ' "
cQuery += " WHERE A.D_E_L_E_T_ = ' ' "
If !lTodosEv
	cQuery += " AND A.PH_PD IN("+cEventos+")"
Endif
cQuery += " AND PH_DATA BETWEEN '"+dtos(dDtApDe)+"' AND '"+dtos(dDtApAte)+"'"
cQuery += " AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery += " AND RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
cQuery += " AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"'"
cQuery += " AND RA_SITFOLH IN("+cSituacao+")"
cQuery += " AND RA_CATFUNC IN("+cCategoria+")"
cQuery += " AND (PH_ABONO = '   ' OR EXISTS(SELECT 1 FROM "+RetSqlName("SP6")+" WHERE A.PH_ABONO = P6_CODIGO AND P6_ABSENT_ = '2' AND D_E_L_E_T_ = ' '))"

cQuery += " ) TMP"
cQuery += " GROUP BY ra_filial, "
cQuery += "        ra_cc, "
cQuery += "        ctt_desc01, "
cQuery += "        ra_mat, "
cQuery += "        ra_nome, "
cQuery += "        pc_data, "
cQuery += "        p9_desc, "
cQuery += "        pc_pd, "
cQuery += "        TIPO, "
cQuery += "        pc_abono, "
cQuery += "        P6_DESC, "
cQuery += "        tny_grpcid, "
cQuery += "        tlg_descri "

cQuery += " ORDER BY "+cOrder
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "QMOVF"
TcSetField("QMOVF","PC_QUANTC" ,"N",05,2)
TcSetField("QMOVF","PK_QTABONO","N",05,2)
TcSetField("QMOVF","PC_DATA","D",08,0)
                                        
dbSelectArea( cAliasQ )
SetRegua((cAliasQ)->(RecCount()))

While !(cAliasQ)->(EOF())
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IncRegua()
		
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impres�o ao se pressionar <ALT> + <A>                �
	//����������������������������������������������������������������
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	//��������������������������������������������������������������Ŀ
	//� Impressao do Funcionario                                     �
	//����������������������������������������������������������������
	fImpFun()
	
	fTestaTotal()  // Quebras e Skips
	
EndDo

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
(cAliasQ)->(dbclosearea())
dbSelectArea("SRA")
Set Filter to
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	If !lGeraXLS
		ourspool(wnrel)
	Endif
Endif
MS_FLUSH()

If lGeraXLS
	fClose(nHandle)
	If !(__copyfile( cDirDocs+"\"+cArquivo+".CSV" , cPath+If(right(cPath,1)<>"\","\","")+wnrel+".CSV"))
		Aviso("Aten��o","N�o foi poss�vel copiar o arquivo: "+cPath+If(right(cPath,1)<>"\","\","")+wnrel+".CSV. Verifique se o mesmo n�o est� em uso.",{"Ok"})
		fErase( cDirDocs+"\"+cArquivo+".CSV" )
		Return
	Endif

	fErase( cDirDocs+"\"+cArquivo+".CSV" )
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+If(right(cPath,1)<>"\","\","")+wnrel+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fImpFun  � Autor � Ricardo Duarte Costa  � Data � 30.11.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Funcionario                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fImpFun													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpFun()

Local aInfo
Local lImpNome	:= cMatAnt <> (cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT

If !lGeraXLS
	//-- Imprime o cabecalho inicial do primeiro registro a ser impresso.
	If Empty(cMatAnt) .And. Empty(cFilialAnt) .And. Empty(cCcAnt)
		fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial
		fCabec(2,(cAliasQ)->RA_CC,(cAliasQ)->CTT_DESC01)	//-- Centro de custo
	Endif
	
	cMatAnt	:= (cAliasQ)->RA_FILIAL+(cAliasQ)->RA_MAT
	If lImpNome
		cDet := (cAliasQ)->RA_MAT + " - "
		cDet += AllTrim(Substr((cAliasQ)->RA_NOME,1,30)) + Space(41-Len(AllTrim(Substr((cAliasQ)->RA_NOME,1,30))))
	Else
		cDet := Space(50)
	EndIf
	cDet += Dtoc((cAliasQ)->PC_DATA,"DDMMYYYY") + space(1)
	cDet += (cAliasQ)->PC_PD + space(1)
	cDet += (cAliasQ)->P9_DESC + space(1)
	cDet += STR((cAliasQ)->PC_QUANTC,5,2) + space(1)
	cDet += (cAliasQ)->PC_ABONO + space(1)
	cDet += (cAliasQ)->P6_DESC + space(1)
	cDet += If((cAliasQ)->PC_QTABONO > 0,STR((cAliasQ)->PC_QTABONO,5,2),space(len(STR((cAliasQ)->PC_QTABONO,5,2))))

Else
	
	fWrite(nHandle, (cAliasQ)->TIPO + ";" )
	fWrite(nHandle, (cAliasQ)->RA_FILIAL + ";" )
	fWrite(nHandle, (cAliasQ)->RA_CC + ";" )
	fWrite(nHandle, (cAliasQ)->CTT_DESC01 + ";" )
	fWrite(nHandle, (cAliasQ)->RA_MAT + ";" )
	fWrite(nHandle, (cAliasQ)->RA_NOME + ";" )
	fWrite(nHandle, DiaSemana((cAliasQ)->PC_DATA,8) + ";" )
	fWrite(nHandle, Dtoc((cAliasQ)->PC_DATA,"DDMMYYYY") + ";" )
	fWrite(nHandle, (cAliasQ)->PC_PD + ";" )
	fWrite(nHandle, (cAliasQ)->P9_DESC + ";" )
	fWrite(nHandle, Transform((cAliasQ)->PC_QUANTC,"@E 999.99") + ";" )
	fWrite(nHandle, If((cAliasQ)->PC_QTABONO > 0,Transform((cAliasQ)->PC_QTABONO,"@E 999.99"),Transform(0,"@E 999.99")) + ";")
	fWrite(nHandle, (cAliasQ)->PC_ABONO + ";" )
	fWrite(nHandle, (cAliasQ)->P6_DESC + ";" )
	fWrite(nHandle, (cAliasQ)->tny_grpcid + ";")
	fWrite(nHandle, (cAliasQ)->tlg_descri)
	fWrite(nHandle, CRLF )

Endif

DbSelectArea( cAliasQ )
If !lGeraXLS
	Impr(cDet,"C")
Endif

If ( nPos	:= Ascan(aCC,{|X| X[1] == (cAliasQ)->RA_CC}) ) > 0
	If lImpNome //.or. (nOrdem = 5 .or. nOrdem = 6)
		aCC[nPos,2] += 1
	EndIf 
Else
	Aadd(aCC,{ (cAliasQ)->RA_CC,;
				1,;
	 			(cAliasQ)->CTT_DESC01;
			  } )
Endif

If ( nPos	:= Ascan(aFil,{|X| X[1] == (cAliasQ)->RA_FILIAL}) ) > 0
	If lImpNome
		aFil[nPos,2] += 1
	EndIf 
Else
	fInfo(@aInfo,cFilialAnt)

	Aadd(aFil,{ (cAliasQ)->RA_FILIAL,;
				1,;
	 			aInfo[1]  ;
			  } )
Endif

If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) > 0
	If lImpNome
		aEmp[nPos,2] += 1
	EndIf 
Else
	Aadd(aEmp,{ cEmpAnt,;
				1,;
	 			"";
			  } )
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fTestaTotal � Autor � Ricardo Duarte Costa  � Data � 30.11.09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totalizacao                                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fTestaTotal												  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fTestaTotal()

dbSelectArea( cAliasQ )
cFilialAnt := (cAliasQ)->RA_FILIAL              // Iguala Variaveis
cCcAnt     := (cAliasQ)->RA_CC
dbSkip()

If !lGeraXLS
	If Eof()
		fImpCc(cCcAnt)
		fImpFil(cFilialAnt)
		fImpEmp()
	Elseif cFilialAnt # (cAliasQ)->RA_FILIAL
		fImpCc(cCcAnt)
		fImpFil(cFilialAnt)
	Elseif cCcAnt # (cAliasQ)->RA_CC
		fImpCc(cCcAnt)
	Endif
Endif

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpCc	  � Autor � Ricardo Duarte Costa  � Data � 06.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totalizacao                                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fImpCc													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpCc(cCcAnt)
Local cDet	:= ""
Local nPos	:= 0

If ( nPos	:= Ascan(aCC,{|X| X[1] == cCcAnt}) ) == 0
	Return Nil
Endif

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " T O T A L  C E N T R O  D E  C U S T O S: " + STR(aCC[nPos,2], 5, 0) + " Funcionarios Listados"
nCCFunc := 0

Impr(cDet,"C")

cDet := Repl("-",132)
Impr(cDet,"C")

//-- Imprime cabecalho para o proximo centro de custos
fCabec(2,(cAliasQ)->RA_CC,(cAliasQ)->CTT_DESC01)	//-- Centro de custo

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpFil	  � Autor � Ricardo Duarte Costa  � Data � 06.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totalizacao por Filial                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fImpFil 													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpFil(cFilialAnt)

Local cDet	:= ""
Local nPos	:= 0
Local aInfo	:= {}

If ( nPos	:= Ascan(aFil,{|X| X[1] == cFilialAnt}) ) == 0
	Return Nil
Endif
fInfo(@aInfo,cFilialAnt)

cDet := Repl("-",132)
Impr(cDet,"C")

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " Filial : "+aFil[nPos,1]+" - "+aInfo[1]
Impr(cDet,"C")
                         
cDet := " T O T A L    D A    F I L I A L:          " + STR(aFil[nPos,2], 5, 0) + " Funcionarios Listados"
Impr(cDet,"C")

cDet := Repl("-",132)
Impr(cDet,"C")

//-- Imprime cabecalho da proxima filial
fCabec(1,(cAliasQ)->RA_FILIAL)	//-- Filial

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fImpEmp	  � Autor � Ricardo Duarte Costa  � Data � 06.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Totalizacao por Empresa                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fImpEmp 													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fImpEmp()

Local cDet	:= ""
Local nPos	:= 0
Local aInfo	:= {}

If ( nPos	:= Ascan(aEmp,{|X| X[1] == cEmpAnt}) ) == 0
	Return Nil
Endif
fInfo(@aInfo,aFil[len(aFil),1])

cDet := SPACE(1)
Impr(cDet,"C")

cDet := " Empresa: "+aEmp[nPos,1]+" - "+aInfo[2]
Impr(cDet,"C")

cDet := SPACE(1)
Impr(cDet,"C")

nFilFunc 	:= 0
nEmpFunc	:= 0

cDet := " T O T A L    D A    E M P R E S A:        " + STR(aEmp[nPos,2], 5, 0) + " Funcionarios Listados"
nEmpFunc := 0

Impr(cDet,"C")

cDet := Repl("-",132)
Impr(cDet,"C")

Impr("","F")

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fCabec   � Autor � Ricardo Duarte Costa  � Data � 05.04.11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Cabecalho                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fCabec 													  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                         			                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function	fCabec(nTipo,cCod,cDesc)

Local cDet	:= ""
Local aInfo	:= {}

If Empty(cCod)
	Return()
Endif

If nTipo == 1
	fInfo(@aInfo,cCod)
	cDet := " Filial : "+cCod+" - "+aInfo[1]
	Impr(cDet,"C")
	cDet := SPACE(1)
	Impr(cDet,"C")
ElseIf nTipo == 2
	cDet := " C.Custo: "+cCod+" - "+cDesc
	Impr(cDet,"C")
	cDet := SPACE(1)
	Impr(cDet,"C")
Endif

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor �Ricardo Duarte Costa� Data �  30/11/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/
Static Function ValidPerg()

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/ Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
aAdd(aRegs,{cPerg,'01','Filial De          ?','','','mv_ch1','C',002,0,0,'G','        	','mv_par01','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','SM0','','','','',''})
aAdd(aRegs,{cPerg,'02','Filial Ate         ?','','','mv_ch2','C',002,0,0,'G','        	','mv_par02','             ','','','99           ','','         ','','','','','','','','','','','','','','','','','','','SM0','','','','',''})
aAdd(aRegs,{cPerg,'03','Centro de Custo De ?','','','mv_ch3','C',009,0,0,'G','        	','mv_par03','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','CTT','','','','',''})
aAdd(aRegs,{cPerg,'04','Centro de Custo Ate?','','','mv_ch4','C',009,0,0,'G','        	','mv_par04','             ','','','ZZZZZZZZZZZZZ','','         ','','','','','','','','','','','','','','','','','','','CTT','','','','',''})
aAdd(aRegs,{cPerg,'05','Matricula De       ?','','','mv_ch5','C',006,0,0,'G','        	','mv_par05','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','SRA','','','','',''})
aAdd(aRegs,{cPerg,'06','Matricula Ate      ?','','','mv_ch6','C',006,0,0,'G','        	','mv_par06','             ','','','999999       ','','         ','','','','','','','','','','','','','','','','','','','SRA','','','','',''})
Aadd(aRegs,{cPerg,'07','Sit.Folha    	   ?','','',"mv_ch7",'C',005,0,0,'G','fSituacao ','mv_par07','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
Aadd(aRegs,{cPerg,'08','Categoria    	   ?','','',"mv_ch8",'C',012,0,0,'G','fCategoria','mv_par08','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'09','Periodo De         ?','','','mv_ch9','D',008,0,0,'G','        	','mv_par09','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'10','Periodo At�        ?','','','mv_cha','D',008,0,0,'G','        	','mv_par10','             ','','','             ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'11','Impress�o      	   ?','','','mv_chb','N',001,0,1,'C','        	','mv_par11','Relat�rio    ','','','             ','','Excel    ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'12','Todos os eventos   ?','','','mv_chc','N',001,0,1,'C','        	','mv_par12','N�o          ','','','             ','','Sim      ','','','','','','','','','','','','','','','','','','','   ','','','','',''})
aAdd(aRegs,{cPerg,'13','Sele��o de Eventos ?','','','mv_chd','C',060,0,0,'G','fEventos(NIL,NIL,NIL)','mv_par13','  ','','','             ','','         ','','','','','','','','','','','','','','','','','','','   ','','','','',''})

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

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FSQLIN   �Autor  �Ricardo Duarte Costa� Data �  19/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Montar a Selecao da Clausula IN do SQL.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
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

