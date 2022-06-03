#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFAT008  ³ Autor ³ Richard Nahas Cabral  ³ Data ³09/03/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Geração de planilha Excel em CSV com os dados selecionados ³±±
±±³          ³ das Metas de Vendas                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFAT008

	Local cPerg

	cPerg := "RFT008"
	ValidPerg( cPerg )

	If ! Pergunte(cPerg,.T.)
		Return
	EndIf

	If MsgYesNo("Confirma geração da planilha ?")
		PROCESSA({|| Processar()})
	EndIf

Return Nil

Static Function Processar()

	Local aVendedor
	Local aGerente
	Local aGrupoSup
	Local aGrpCliente
	Local aCatProd
	Local nLoop := 0
	Local nGerente := 0

	Private cCodVazio := CriaVar("ACU_COD",.F.)
	Private cArquivo

	ProcRegua(4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desmembra Gerente Regional ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Processando Gerentes Regionais")

	aGerente := {}

	If MV_PAR01 = 1

		cQuery := ""
		cQuery += "SELECT DISTINCT A3_GEREN, (SELECT A3_NOME FROM " + RetSqlName( "SA3" ) + " SA3INT WHERE A3_FILIAL = '" + xFilial( "SA3" ) + "' AND D_E_L_E_T_ = ' ' AND SA3.A3_GEREN = SA3INT.A3_COD ) A3_NOME "
		cQuery += " FROM " + RetSqlName( "SA3" ) + " SA3 "
		cQuery += " WHERE A3_FILIAL = '" + xFilial( "SA3" ) + "' "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY A3_GEREN "

		cQuery := ChangeQuery(cQuery)

		DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "SQLSA3", .F., .T. )

		SQLSA3->(DbGoTop())
		Do While ! SQLSA3->(Eof())
			Aadd(aGerente,{SQLSA3->A3_GEREN,SQLSA3->A3_NOME})
			SQLSA3->(DbSkip())
		EndDo

		SQLSA3->(DbCloseArea())

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desmembra Vendedores³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Processando Vendedores")

	aVendedor := {}

	If MV_PAR02 = 1
		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		SA3->(Dbgotop())
		Do While ! SA3->(Eof())
			Aadd(aVendedor,{SA3->A3_COD,SA3->A3_NOME,If(MV_PAR01 = 1,SA3->A3_GEREN,"")})
			SA3->(DbSkip())
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tambem tenha selecionado o Gerente Regional³
		//³classifica por Gerente + Vendedor               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If MV_PAR01 = 1
			aSort(aVendedor,,,{|x,y| x[3] + x[1] < y[3] + y[1] })
		EndIf

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desmembra Grupo Clientes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Processando Grupo de Clientes / Clientes")

	aGrpCliente	:= {}

	If MV_PAR03 = 1

		DbSelectArea("ACY")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os grupos que tem este grupo como superior            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aGrupoSup := {}
		ACY->( DbSetOrder( 2 ) )
		cSeekSup := xFilial( "ACY" ) + "MAINGR"
		If ACY->( DbSeek( cSeekSup ) )
			Do While ACY->ACY_FILIAL + ACY->ACY_GRPSUP == cSeekSup .And. ! ACY->( Eof() )
				Aadd( aGrupoSup, {ACY->ACY_GRPVEN,ACY->ACY_DESCRI} )
				ACY->( DbSkip() )
			EndDo
		EndIf

		For nLoop := 1 To Len( aGrupoSup )
			Aadd(aGrpCliente,{aGrupoSup[nLoop,1],aGrupoSup[nLoop,2],"","","",""})
			ACY->( DbSeek( xFilial( "ACY" ) + aGrupoSup[nLoop,1] ) )
			Do While ACY->ACY_FILIAL + ACY->ACY_GRPSUP == xFilial( "ACY" ) + aGrupoSup[nLoop,1] .And. ! ACY->( Eof() )
				Aadd(aGrpCliente,{aGrupoSup[nLoop,1],aGrupoSup[nLoop,2],ACY->ACY_GRPVEN,ACY->ACY_DESCRI,"",""})
				If MV_PAR04 = 1
					CarCliGrp(@aGrpCliente,aGrupoSup[nLoop,1],aGrupoSup[nLoop,2],ACY->ACY_GRPVEN,ACY->ACY_DESCRI)
				EndIf
				ACY->( DbSkip() )
			EndDo
		Next nLoop

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desmembra Categoria de Produtos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc("Processando Categoria de Produtos / Produtos")

	aCatProd	:= {}

	If MV_PAR05 = 1 .Or. MV_PAR06 = 1

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para montar estrutura baseado nos codigos pais³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("ACV")
		ACV->(DbSetOrder(1))

		DbSelectArea("ACU")
		ACU->(DbSetOrder(2))
		ACU->(DbSeek(xFilial("ACU")))

		MtEstrCat(@aCatProd,cCodVazio,NIL,NIL)

	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria arquivo CSV³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	ProcRegua(Max(Len(aVendedor),1)*Max(Len(aGerente),1)*Max(Len(aGrpCliente),1)*Max(Len(aCatProd),1))

	cArquivo := GetMv("MV_PATHPLA",,"C:\Planilha\")+GetMv("MV_NOMEPLA",,"MetaVendaZerada.csv")
	IF FILE( cArquivo )
		FERASE( cArquivo )
	EndIf

//AcaLog(cArquivo,"Codigo Vendedor;Nome Vendedor;Codigo Regiao;Nome Regiao;Grupo Superior;Descricao Grupo Superior;Codigo Grupo Clientes;Descricao Grupo Clientes;Codigo Cliente;Nome Cliente;Codigo Categoria;Nome Categoria;Codigo Produto;Nome Produto;Preco Medio;Custo Produto;Janeiro Qtde;Janeiro Valor;Fevereiro Qtde;Fevereiro Valor;Marco Qtde;Marco Valor;Abril Qtde;Abril Valor;Maio Qtde;Maio Valor;Junho Qtde;Junho Valor;Julho Qtde;Julho Valor;Agosto Qtde;Agosto Valor;Setembro Qtde;Setembro Valor;Outubro Qtde;Outubro Valor;Novembro Qtde;Novembro Valor;Dezembro Qtde;Dezembro Valor")
//AcaLog(cArquivo,"Vendedor;Nome Vendedor;Regiao;Nome Regiao;Grupo Superior;Descricao Grupo Superior;Grupo Clientes;Descricao Grupo Clientes;Cliente;Nome Cliente;Categoria;Nome Categoria;Produto;Nome Produto;Preco Medio;Custo Produto;Janeiro Qtde;Janeiro Valor;Fevereiro Qtde;Fevereiro Valor;Marco Qtde;Marco Valor;Abril Qtde;Abril Valor;Maio Qtde;Maio Valor;Junho Qtde;Junho Valor;Julho Qtde;Julho Valor;Agosto Qtde;Agosto Valor;Setembro Qtde;Setembro Valor;Outubro Qtde;Outubro Valor;Novembro Qtde;Novembro Valor;Dezembro Qtde;Dezembro Valor")
	AcaLog(cArquivo,"Gerente;Nome Gerente;Vendedor;Nome Vendedor;Grupo Superior;Descricao Grupo Superior;Grupo Clientes;Descricao Grupo Clientes;Cliente;Nome Cliente;Categoria;Nome Categoria;Produto;Nome Produto;Preco Medio;Custo Produto;Janeiro Qtde;Janeiro Valor;Fevereiro Qtde;Fevereiro Valor;Marco Qtde;Marco Valor;Abril Qtde;Abril Valor;Maio Qtde;Maio Valor;Junho Qtde;Junho Valor;Julho Qtde;Julho Valor;Agosto Qtde;Agosto Valor;Setembro Qtde;Setembro Valor;Outubro Qtde;Outubro Valor;Novembro Qtde;Novembro Valor;Dezembro Qtde;Dezembro Valor")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama rotina que ira montar os dados a serem gravados na planilha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(aGerente)
		MtGerente("","",aVendedor,aGrpCliente,aCatProd)
	Else
		For nGerente := 1 to Len(aGerente)
			MtGerente(aGerente[nGerente,1],aGerente[nGerente,2],aVendedor,aGrpCliente,aCatProd)
		Next nGerente
	Endif

	If MsgYesNo("Deseja abrir Planilha no Excel ?")

		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' ) //'MsExcel nao instalado'
			Return Nil
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArquivo ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)

	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtGerente   ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe dados dos gerentes e os demais arrays                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MtGerente(cCodGerente,cNomeGerente,aVendedor,aGrpCliente,aCatProd)

	Local nVendedor := 0

	If Empty(aVendedor)
		MtVendedor(cCodGerente,cNomeGerente,"","",aGrpCliente,aCatProd)
	Else
		For nVendedor := 1 to Len(aVendedor)
			If aVendedor[nVendedor,3] = cCodGerente
				MtVendedor(cCodGerente,cNomeGerente,aVendedor[nVendedor,1],aVendedor[nVendedor,2],aGrpCliente,aCatProd)
			Endif
		Next nVendedor
	Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtVendedor  ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe dados dos Vendedores e os demais arrays               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MtVendedor(cCodGerente,cNomeGerente,cCodVend,cNomeVend,aGrpCliente,aCatProd)

	Local nGrpCliente := 0

	If Empty(aGrpCliente)
		MtGrpCliente(cCodGerente,cNomeGerente,cCodVend,cNomeVend,"","","","","","",aCatProd)
	Else
		For nGrpCliente := 1 to Len(aGrpCliente)
			MtGrpCliente(cCodGerente,cNomeGerente,cCodVend,cNomeVend,aGrpCliente[nGrpCliente,1],aGrpCliente[nGrpCliente,2],aGrpCliente[nGrpCliente,3],aGrpCliente[nGrpCliente,4],aGrpCliente[nGrpCliente,5],aGrpCliente[nGrpCliente,6],aCatProd)
		Next nGrpCliente
	Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtGrpClienteºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe dados dos Grupos de Clientes e os demais arrays       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MtGrpCliente(cCodGerente,cNomeGerente,cCodVend,cNomeVend,cGrupoSup,cDscGrupSup,cCodGrupo,cDescGrupo,cCodCli,cNomeCli,aCatProd)

	Local nCatProd := 0

	If Empty(aCatProd)
		MtCatProd(cCodGerente,cNomeGerente,cCodVend,cNomeVend,cGrupoSup,cDscGrupSup,cCodGrupo,cDescGrupo,cCodCli,cNomeCli,"","","","")
	Else
		For nCatProd := 1 to Len(aCatProd)
			MtCatProd(cCodGerente,cNomeGerente,cCodVend,cNomeVend,cGrupoSup,cDscGrupSup,cCodGrupo,cDescGrupo,cCodCli,cNomeCli,aCatProd[nCatProd,1],aCatProd[nCatProd,2],aCatProd[nCatProd,3],aCatProd[nCatProd,4])
		Next nCatProd
	Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtCatProd   ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recebe dados das Categorias de Produtos                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MtCatProd(cCodGerente,cNomeGerente,cCodVend,cNomeVend,cGrupoSup,cDscGrupSup,cCodGrupo,cDescGrupo,cCodCli,cNomeCli,cCodCat,cNomeCat,cCodProd,cDescProd)

	Local cGerente
	Local cVendedor
	Local cSuperior
	Local cGrupo
	Local cProduto
	Local cCategoria
	Local cCliente

	IncProc("Gerando Planilha...")

	cGerente	:= IncPipe(cCodGerente	,cNomeGerente)
	cVendedor	:= IncPipe(cCodVend		,cNomeVend	)
	cSuperior	:= IncPipe(cGrupoSup	,cDscGrupSup)
	cGrupo		:= IncPipe(cCodGrupo	,cDescGrupo	)
	cProduto	:= IncPipe(cCodProd		,cDescProd	)
	cCategoria	:= IncPipe(cCodCat		,cNomeCat	)
	cCliente	:= IncPipe(cCodCli		,cNomeCli	)

	AcaLog(cArquivo,cGerente+";"+cVendedor+";"+cSuperior+";"+cGrupo+";"+cCliente+";"+cCategoria+";"+cProduto+";;;;;;;;;;;;;;;;;;;;;;;;;;")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncPipe   ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Inclui Pipe para o Excel abrir com zeros a esquerda        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncPipe(cCodigo,cDescricao)

Return If(!Empty(cCodigo) ,"|", "") + cCodigo	+ ";" + If(! Empty(cCodigo)  ,cDescricao  ,"")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CarCliGrp ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega os cliente do Grupo de Vendas                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CarCliGrp(aGrpCliente, cGrpSup, cDescGrpSup, cGrupo, cDescGrupo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os clientes                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := ""
	cQuery += "SELECT A1_COD, A1_LOJA, A1_NOME FROM " + RetSqlName( "SA1" ) + " SA1 "
	cQuery += "WHERE "
	cQuery += "A1_FILIAL='" + xFilial( "SA1" ) + "' AND "
	cQuery += "A1_GRPVEN='" + cGrupo  + "' AND "
	cQuery += "SA1.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY A1_COD, A1_LOJA"

	cQuery := ChangeQuery(cQuery)

	DbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "SQLSA1", .F., .T. )

	SQLSA1->(DbGoTop())
	Do While ! SQLSA1->(Eof())
		Aadd(aGrpCliente, {cGrpSup, cDescGrpSup, cGrupo, cDescGrupo,SQLSA1->(A1_COD+"-"+A1_LOJA), SQLSA1->A1_NOME} )
		SQLSA1->(DbSkip())
	EndDo

	SQLSA1->(DbCloseArea())

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³ Fernando Salvatori º Data ³ 26/01/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria Grupo de Perguntas para este Processamento            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ValidPerg( cPerg )
	Local aHelp := {}

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Gerente Regional ' )
	PutSx1(cPerg, "01", "Gera Gerente Regional ?", "Gera Gerente Regional ?", "Gera Gerente Regional ?", "mv_ch1", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR01", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Vendedor ' )
	PutSx1(cPerg, "02", "Gera Vendedor ?", "Gera Vendedor ?", "Gera Vendedor ?", "mv_ch2", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR02", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Grupo de Clientes ' )
	PutSx1(cPerg, "03", "Gera Grupo de Clientes ?", "Gera Grupo de Clientes ?", "Gera Grupo de Clientes ?", "mv_ch3", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR03", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Cliente ' )
	PutSx1(cPerg, "04", "Gera Cliente ?", "Gera Cliente ?", "Gera Cliente ?", "mv_ch4", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR04", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Categoria de Produtos ' )
	PutSx1(cPerg, "05", "Gera Categoria Produto ?", "Gera Categoria Produto ?", "Gera Categoria Produto ?", "mv_ch5", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR05", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

	aHelp := {}
	AAdd( aHelp, 'Gera dados desmembrados por Produto ' )
	PutSx1(cPerg, "06", "Gera Produto ?", "Gera Produto ?", "Gera Produto ?", "mv_ch6", "N", 01, 0, 0, "C", "", "", "", "", "MV_PAR06", "Sim", "", "", "", "Não", "", "", "", "", "", "", "", "", "", "", "", aHelp, aHelp, aHelp)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MtEstrCat ºAutor  ³ Richard N. Cabral  º Data ³ 10/03/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta estrutura de produtos                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MtEstrCat(aCatProd,cCodPai,lSeek,cCodCateg)

	Local nRec		:= 0
	Local aArea		:= GetArea()

	DEFAULT cCodCateg	:= ""
	DEFAULT lSeek		:= .F.

	dbSelectArea("ACV")
	dbSetOrder(1)

	dbSelectArea("ACU")
	dbSetOrder(2)

	If ! lSeek
		lSeek := MsSeek(xFilial("ACU")+cCodPai)
	EndIf

	If lSeek

		While ACU_FILIAL+ACU_CODPAI == xFilial("ACU")+cCodPai .And. ! ACU->(Eof())

			If MV_PAR05 = 1
				Aadd(aCatProd,{ACU->ACU_COD,ACU->ACU_DESC,"",""})
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Desmembra Produtos             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If MV_PAR06 = 1
				ACV->(DbSeek(xFilial("ACV")+ACU->ACU_COD))
				Do While ACV->ACV_FILIAL + ACV->ACV_CATEGO = xFilial("ACV")+ACU->ACU_COD .And. ! ACV->(Eof())
					If MV_PAR05 = 1
						Aadd(aCatProd,{ACU->ACU_COD,ACU->ACU_DESC,ACV->ACV_CODPRO, Posicione("SB1",1, xFilial("SB1")+ACV->ACV_CODPRO,"B1_DESC")})
					Else
						Aadd(aCatProd,{"","",ACV->ACV_CODPRO, Posicione("SB1",1, xFilial("SB1")+ACV->ACV_CODPRO,"B1_DESC")})
					Endif
					ACV->(DbSkip())
				EndDo
			EndIf

			cCodCateg	:= ACU_COD
			nRec		:= Recno()
			lSeek		:= MSSeek(xFilial("ACU")+cCodCateg)
			If lSeek
				MtEstrCat(@aCatProd,ACU_CODPAI,lSeek,cCodCateg)
			EndIf
			dbGoto(nRec)
			dbSkip()
		End
	EndIf

	RestArea(aArea)

RETURN
