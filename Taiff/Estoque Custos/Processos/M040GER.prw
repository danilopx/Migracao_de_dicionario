#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE PULA CHR(13) + CHR(10)
/*
=================================================================================
=================================================================================
||   Arquivo:	M040GER.PRW
=================================================================================
||   Funcao:	M040GER
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que sera utilizada para informar qual o Gerente X Marca para 
|| 	cada Vendedor. 
|| 		O mesmo devera ser chamado nos Pontos de Entrada de Inclusao e Alteracao
|| do cadastro de Vendedores.
|| 
=================================================================================
=================================================================================
||   PARAMETROS DA FUNCAO 
||   NOPC --> Numerico 		--> Opcao do Cadastro (3=Inluir, 4=Alterar, 5=Excluir)
||   CVENDEDOR --> Caracter --> Codigo do Vendedor
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		19/03/2014
=================================================================================
=================================================================================
*/

USER FUNCTION M040GER(NOPC,CVENDEDOR)

	LOCAL CSTR			:= ""

	LOCAL OFNT0

	LOCAL OBTN0
	// LOCAL OBTN1
	// LOCAL OBTN2

	LOCAL OLBL0
	LOCAL OLBL1
	LOCAL OLBL2

	LOCAL OGET0

	LOCAL NMAX			:= 999
	LOCAL AHEADER		:= {}

	LOCAL NREGS		:= 0
	Local I 		:= 0

	PRIVATE NFREEZE	:= 0
	PRIVATE ACOLS		:= {}
	PRIVATE LREFRESH	:= .T.
	PRIVATE ODLG0
	PRIVATE ODTG0
	PRIVATE OLBL3
	PRIVATE OCMB0
	PRIVATE OCMB1
	PRIVATE CCMB0		:= ""
	PRIVATE CCMB1		:= '{"TAIFF","PROART","CORP"}'
	PRIVATE ACMB0		:= {}
	PRIVATE ACMB1		:= &(CCMB1)
	PRIVATE CGET0		:= SPACE(009)

	/*
	|---------------------------------------------------------------------------------
	| CASO NAO SEJA INFORMADO A OPCAO DE INCLUSAO, ALTERACAO OU EXCLUSAO
	|---------------------------------------------------------------------------------
	*/
	DEFAULT NOPC 	:= 3

	IF EMPTY(CVENDEDOR)

		MSGALERT(OEMTOANSI("Código do Vendedor não informado!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
		RETURN .F.

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	| CASO SEJA EXCLUSAO REALIZA O PROCESSO DE FLAG NO D_E_L_E_T_
	|---------------------------------------------------------------------------------
	*/

	IF NOPC = 5

		CSTR := "UPDATE" 										+ PULA
		CSTR += "	SZD030" 									+ PULA
		CSTR += "SET" 											+ PULA
		CSTR += "	D_E_L_E_T_ 	= '*'," 					+ PULA
		CSTR += "	R_E_C_D_E_L_ 	= R_E_C_N_O_"				+ PULA
		CSTR += "WHERE" 										+ PULA
		CSTR += "	ZD_VENDED = '" + CVENDEDOR + "' AND" 	+ PULA
		CSTR += "	D_E_L_E_T_ = ''"

		IF TCSQLEXEC(CSTR) < 0

			MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_M040GER.QRY",CSTR)
			MSGALERT(OEMTOANSI("Erro no processo de Exclusão dos Registros!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))

		ELSE

			MSGINFO(OEMTOANSI("Registros de Relac. Gerente X Vendedor forma exsluídos!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))

		ENDIF

		RETURN .F.

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	| SELECAO DOS REGISTROS DE GERENTES
	|---------------------------------------------------------------------------------
	*/

	CSTR := "SELECT" + PULA
	CSTR += " SA3.A3_COD," + PULA
	CSTR += " RTRIM(SA3.A3_NOME) AS 'A3_NOME'" + PULA
	CSTR += "FROM" + PULA
	CSTR += "	" + RETSQLNAME("SA3") + " SA3" + PULA
	CSTR += "WHERE" + PULA
	CSTR += "	SA3.A3_GEREN = '' AND" + PULA
	CSTR += "	SA3.A3_MSBLQL != '1' AND" + PULA
	CSTR += "	" + RETSQLCOND("SA3")

	IF SELECT("CMB") > 0

		DBSELECTAREA("CMB")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CSTR NEW ALIAS "CMB"
	DBSELECTAREA("CMB")
	COUNT TO NREGS

	IF NREGS <= 0

		MSGALERT(OEMTOANSI("Não existem Gerentes cadastrados!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
		RETURN .F.

	END

	/*
	|---------------------------------------------------------------------------------
	|	MONTAGEM DO ARRAY PARA O COMBO 0
	|---------------------------------------------------------------------------------
	*/

	CCMB0 := "{"

	CMB->(DBGOTOP())
	WHILE CMB->(!EOF())

		CCMB0 += '"' + ALLTRIM(CMB->A3_COD) + '=' + ALLTRIM(CMB->A3_NOME) + '",'
		CMB->(DBSKIP())

	ENDDO

	CCMB0 := SUBSTR(CCMB0,1,LEN(CCMB0) - 1) + "}"
	ACMB0 := &(CCMB0)

	/*
	|---------------------------------------------------------------------------------
	|	MONTAGEM DO HEADER DO MSGETDADOS
	|---------------------------------------------------------------------------------
	*/

	/*01*/AADD(AHEADER,{"Gerente"		,"ZD_GERENT"	,"@!"								,06	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZD_GERENT"	,"X3_USADO"),POSICIONE("SX3",2,"ZD_GERENT"	,"X3_TIPO"),POSICIONE("SX3",2,"ZD_GERENT"	,"X3_F3"),POSICIONE("SX3",2,"ZD_GERENT"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZD_GERENT"	,"X3_CBOX"),POSICIONE("SX3",2,"ZD_GERENT"	,"X3_RELACAO")})
	/*02*/AADD(AHEADER,{"Nome"			,"A3_NOME"		,"@!"								,40	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"A3_NOME"		,"X3_USADO"),POSICIONE("SX3",2,"A3_NOME"		,"X3_TIPO"),POSICIONE("SX3",2,"A3_NOME"	,"X3_F3"),POSICIONE("SX3",2,"A3_NOME"		,"X3_CONTEXT"),POSICIONE("SX3",2,"A3_NOME"	,"X3_CBOX"),POSICIONE("SX3",2,"A3_NOME"	,"X3_RELACAO")})
	/*03*/AADD(AHEADER,{"Un. Negócio"	,"ZD_UNEGOC"	,"@!"								,09	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_USADO"),POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_TIPO"),POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_F3"),POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_CBOX"),POSICIONE("SX3",2,"ZD_UNEGOC"	,"X3_RELACAO")})
	/*04*/AADD(AHEADER,{"C. Custo"		,"ZD_CCUSTO"	,"@!"								,09	,		,"ALLWAYSTRUE()",POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_USADO"),POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_TIPO"),POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_F3"),POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_CONTEXT"),POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_CBOX"),POSICIONE("SX3",2,"ZD_CCUSTO"	,"X3_RELACAO")})

	/*
	|---------------------------------------------------------------------------------
	|	SE OPCAO FOR ALTERACAO VERIFICA SE EXISTEM REGISTROS NO BANCO DE DADOS
	|	E MONTA ACOLS SENAO PASSA ACOLS EM BRANCO
	|---------------------------------------------------------------------------------
	*/

	IF NOPC = 4

		CSTR := "SELECT" 											+ PULA
		CSTR += "	SZD.ZD_GERENT," 								+ PULA
		CSTR += "	RTRIM(SA3.A3_NOME) AS A3_NOME," 			+ PULA
		CSTR += "	SZD.ZD_UNEGOC," 								+ PULA
		CSTR += "	SZD.ZD_CCUSTO" 								+ PULA
		CSTR += "FROM" 											+ PULA
		CSTR += "	SZD030 SZD" 									+ PULA
		CSTR += "		INNER JOIN " + RETSQLNAME("SA3") + " SA3 ON" + PULA
		CSTR += "			SA3.A3_COD = SZD.ZD_GERENT AND" 	+ PULA
		CSTR += "			" + RETSQLCOND("SA3")					+ PULA
		CSTR += "WHERE" 											+ PULA
		CSTR += "	SZD.ZD_VENDED = '" + CVENDEDOR + "' AND" 	+ PULA
		CSTR += "	" + RETSQLCOND("SZD")

		IF SELECT("TMP1") > 0

			DBSELECTAREA("TMP1")
			DBCLOSEAREA()

		ENDIF

		TCQUERY CSTR NEW ALIAS "TMP1"
		DBSELECTAREA("TMP1")
		COUNT TO NREGS

		IF NREGS > 0

			TMP1->(DBGOTOP())
			WHILE TMP1->(!EOF())

				AADD(ACOLS,ARRAY(05))

				FOR I := 1 TO 4

					ACOLS[LEN(ACOLS),I] := FIELDGET(FIELDPOS(AHEADER[I,2]))

				NEXT I

				ACOLS[LEN(ACOLS),05] := .F.

				TMP1->(DBSKIP())

			ENDDO

		ELSE

			AADD(ACOLS,ARRAY(05))
			ACOLS[LEN(ACOLS),05] := .F.

		ENDIF

	ELSE

		AADD(ACOLS,ARRAY(05))
		ACOLS[LEN(ACOLS),05] := .F.

	ENDIF

	ODLG0 	:= MSDIALOG():NEW(0000,0000,0500,0700,'Relacionamento de Gerentes X Vendedor',,,,,CLR_BLACK,CLR_GRAY,,,.T.)

	OFNT0	:= TFONT():NEW('CALIBRI',,-15,.T.,.T.)

	OLBL0 	:= TSAY():NEW( 0020,0020, {|| OEMTOANSI('Gerente:')}		,ODLG0,,OFNT0,,,,.T.,CLR_HBLUE,CLR_GRAY )
	OLBL0:LTRANSPARENT:= .T.
	OLBL1 	:= TSAY():NEW( 0040,0020, {|| OEMTOANSI('Un. Negócio:')}	,ODLG0,,OFNT0,,,,.T.,CLR_HBLUE,CLR_GRAY )
	OLBL1:LTRANSPARENT:= .T.
	OLBL2 	:= TSAY():NEW( 0060,0020, {|| OEMTOANSI('C. Custo:')}	,ODLG0,,OFNT0,,,,.T.,CLR_HBLUE,CLR_GRAY )
	OLBL2:LTRANSPARENT:= .T.
	OLBL3 	:= TSAY():NEW( 0060,0150, {|| OEMTOANSI('...')}			,ODLG0,,OFNT0,,,,.T.,CLR_RED,CLR_GRAY,100 )
	OLBL3:LTRANSPARENT:= .T.

	OCMB0 	:= TCOMBOBOX():NEW(0020,0080,{|U|IF(PCOUNT()>0,CCMB0:=U,CCMB0)},ACMB0,150,020,ODLG0,,,,,,.T.,,,,,,,,,'CCMB0')
	OCMB1 	:= TCOMBOBOX():NEW(0040,0080,{|U|IF(PCOUNT()>0,CCMB1:=U,CCMB1)},ACMB1,150,020,ODLG0,,,,,,.T.,,,,,,,,,'CCMB1')

	OGET0	:= TGET():NEW(0060,0080,{|U| IF(PCOUNT()>0,CGET0:=U,CGET0)}, ODLG0,050,010,'@!',{|| ATULBL3(OLBL3)},CLR_BLACK,,OFNT0,,,.T.,,,,,,,,,"CTT",'CGET0')

	OBTN0	:= TBUTTON():NEW(0085,0080,'Adiciona'	,ODLG0,{|| INSERTACOLS()}						,040,013,,,,.T.,,"Adiciona as informações no Grid.")
	OBTN0	:= TBUTTON():NEW(0085,0130,'Confirma'	,ODLG0,{|| GRVDADOS(NOPC,CVENDEDOR),ODLG0:END()}	,040,013,,,,.T.,,"Grava as informações e sai da Tela.")
	OBTN0	:= TBUTTON():NEW(0085,0180,'Cancela'	,ODLG0,{|| ODLG0:END()}							,040,013,,,,.T.,,"Sai da Tela sem gravar.")

	ODTG0	:= MSNEWGETDADOS():NEW(0110,0020,0230,0333, GD_INSERT+GD_UPDATE+GD_DELETE,"AlwaysTrue","AlwaysTrue","",{},NFREEZE,NMAX,"AllwaysTrue","",{|| SETDELETADO(ODTG0)}, ODLG0, AHEADER, ACOLS)
	//"AllwaysTrue"
	ODLG0:LCENTERED := .T.
	ODLG0:ACTIVATE()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	M040GER.PRW
=================================================================================
||   Funcao:	ATULBL3
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira atualizar Label com a descricao do Centro de Custo 
|| selecionado.  
=================================================================================
=================================================================================
*/

STATIC FUNCTION ATULBL3(OLBL3)

	LOCAL LRET := .T.

	IF !EMPTY(ALLTRIM(CGET0)) .AND. (CTT->CTT_CLASSE = "1" .OR. CTT->CTT_BLOQ = "1" .OR. (CTT->CTT_DTEXSF != CTOD("  /  /  ") .AND. CTT->CTT_DTEXSF <= DDATABASE))

		MSGALERT(OEMTOANSI("Centro de Custo não pode ser utilizado!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
		LRET := .F.

	ENDIF

	IF !EMPTY(ALLTRIM(CGET0))
		OLBL3:SETTEXT(ALLTRIM(CTT->CTT_DESC01))
		OLBL3:CTRLREFRESH()
	ELSE
		OLBL3:SETTEXT("...")
		OLBL3:CTRLREFRESH()
	ENDIF

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	M040GER.PRW
=================================================================================
||   Funcao:	ATULBL3
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira atualizar Label com a descricao do Centro de Custo 
|| selecionado.  
=================================================================================
=================================================================================
*/

STATIC FUNCTION INSERTACOLS()

	//LOCAL CSTR 	:= ""
	LOCAL I		:= 1
	LOCAL CGERE	:= ""
	LOCAL CNOME	:= ""

/*
|---------------------------------------------------------------------------------
|	REALIZA AS VALIDACOES PARA PODER INSERIR REGISTRO NO ACOLS
|---------------------------------------------------------------------------------
*/

// VERIFICA SE TODOS OS CAMPOS ESTAO PREENCHIDOS
	IF OCMB0:NAT = 0 .OR. OCMB1:NAT = 0

		MSGALERT(OEMTOANSI("Os campos de Gerente e Un. Negócios são obrigatórios!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
		RETURN

	ENDIF

// VERIFICA SE JA EXISTE O REGISTRO NO ACOLS

	CGERE := SUBSTR(ACMB0[OCMB0:NAT],1,6)
	CNOME := SUBSTR(ACMB0[OCMB0:NAT],8,LEN(ACMB0[OCMB0:NAT]) - 7)

	FOR I := 1 TO LEN(ODTG0:ACOLS)

		IF ODTG0:ACOLS[I,5] = .T.

			LOOP

		ENDIF

		IF ALLTRIM(ODTG0:ACOLS[I,1]) = ALLTRIM(CGERE) .AND. ALLTRIM(ODTG0:ACOLS[I,3]) = ALLTRIM(ACMB1[OCMB1:NAT])

			MSGALERT(OEMTOANSI("Informações já estão presentes no Grid!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
			RETURN

		ENDIF

	NEXT I

	IF ALLTRIM(ACOLS[LEN(ACOLS),1]) != ""

		ODTG0:ADDLINE(.F.,.F.)
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),01] := CGERE
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),02] := CNOME
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),03] := ALLTRIM(ACMB1[OCMB1:NAT])
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),04] := CGET0
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),05] := .F.
		ODTG0:ADDLASTEDIT(LEN(ODTG0:ACOLS))

	ELSE

		ODTG0:ACOLS[LEN(ODTG0:ACOLS),01] := CGERE
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),02] := CNOME
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),03] := ALLTRIM(ACMB1[OCMB1:NAT])
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),04] := CGET0
		ODTG0:ACOLS[LEN(ODTG0:ACOLS),05] := .F.

	ENDIF

	ODTG0:OBROWSE:REFRESH()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	M040GER.PRW
=================================================================================
||   Funcao:	SETDELETADO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira validar a Exclusão da Linha. 
||   
=================================================================================
=================================================================================
*/

STATIC FUNCTION SETDELETADO(ODTG0)

	LOCAL 	LRET := .T.

	IF !ODTG0:ACOLS[ODTG0:NAT][5]
		LRET := .T.
	ELSE
		LRET := .F.
	ENDIF

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	M040GER.PRW
=================================================================================
||   Funcao:	SETDELETADO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que ira validar a Exclusão da Linha. 
||   
=================================================================================
=================================================================================
*/

STATIC FUNCTION GRVDADOS(NOPC,CVENDEDOR)

	LOCAL CSTR 	:= ""
	LOCAL I		:= 0

	CSTR := "DELETE SZD030 WHERE ZD_VENDED = '" + CVENDEDOR + "'"
	TCSQLEXEC(CSTR)

	FOR I := 1 TO LEN(ODTG0:ACOLS)

		IF !ODTG0:ACOLS[I,5]

			CSTR := "DECLARE @NRECNO INT" 			+ PULA
			CSTR += "SET @NRECNO = (SELECT MAX(R_E_C_N_O_) FROM SZD030) + 1" + PULA + PULA
			CSTR += "INSERT INTO SZD030 VALUES (" 	+ PULA
			CSTR += "''," 								+ PULA 	//FILIAL
			CSTR += "'" + ODTG0:ACOLS[I,1] + "'," 	+ PULA 	//GERENTE
			CSTR += "'" + CVENDEDOR + "',"			+ PULA	//VENDEDOR
			CSTR += "'',"								+ PULA //DATA VALIDADE (NAO ESTA SENDO UTILIZADO)
			CSTR += "'" + ODTG0:ACOLS[I,3] + "'," 	+ PULA 	//UNIDADE DE NEGOCIO
			CSTR += "'" + ODTG0:ACOLS[I,4] + "'," 	+ PULA 	//CENTRO DE CUSTO
			CSTR += "'',"								+ PULA //D_E_L_E_T_
			CSTR += "@NRECNO," 						+ PULA //R_E_C_N_O_
			CSTR += "0)"										//R_E_C_D_E_L_

			IF TCSQLEXEC(CSTR) < 0
				IF NOPC = 3
					MSGALERT(OEMTOANSI("Erro no Processo de Inclusão!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
				ELSEIF NOPC = 4
					MSGALERT(OEMTOANSI("Erro no Processo de Alteração!"),OEMTOANSI("Relac. de Gerentes X Vendedor"))
				ENDIF
				MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_M040GER.QRY",CSTR)
				RETURN
			ENDIF

		ENDIF

	NEXT I

RETURN
