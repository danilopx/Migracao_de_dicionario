#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuDocRev º Autor ³ Marcelo Cardoso    º Data ³  27/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para atualizacao de Revisoes                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AtuDocRev


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local _nRv 		  := 0
	Private aParamBox := {}
	Private _aQDTab   := {}
	Private aRet      := {}
	Private _cQDH2    := "QDH2"
	Private _cNomUser := AllTrim(SubStr(Upper(PSWRET(NIL)[1][4]), 01, 30))

	If !(__cUserID $ AllTrim(GetMV("MV_XQDOLDR"))  )

		MsgStop("Verifique o parametro MV_XQDOLDR. Parametro ou usuario nao cadastrado."  )

		Return

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array com as Tabelas, campos e indices a serem utilizados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AAdd(_aQDTab, { 'QD0', 'QD0_RV', 1 })
	AAdd(_aQDTab, { 'QD1', 'QD1_RV', 1 })
	AAdd(_aQDTab, { 'QD4', 'QD4_RV', 1 })
	AAdd(_aQDTab, { 'QD6', 'QD6_RV', 1 })
	AAdd(_aQDTab, { 'QD7', 'QD7_RV', 1 })
	AAdd(_aQDTab, { 'QD9', 'QD9_RV', 1 })
	AAdd(_aQDTab, { 'QDA', 'QDA_RV', 2 })
	AAdd(_aQDTab, { 'QDB', 'QDB_RV', 1 })
	AAdd(_aQDTab, { 'QDE', 'QDE_RV', 1 })
	AAdd(_aQDTab, { 'QDF', 'QDF_RV', 1 })
	AAdd(_aQDTab, { 'QDG', 'QDG_RV', 1 })
	AAdd(_aQDTab, { 'QDH', 'QDH_RV', 1 })
	AAdd(_aQDTab, { 'QDJ', 'QDJ_RV', 1 })
	AAdd(_aQDTab, { 'QDN', 'QDN_RV', 1 })
	AAdd(_aQDTab, { 'QDP', 'QDP_RV', 1 })
	AAdd(_aQDTab, { 'QDR', 'QDR_RV', 1 })
	AAdd(_aQDTab, { 'QDS', 'QDS_RV', 2 })
	AAdd(_aQDTab, { 'QDU', 'QDU_RV', 1 })
	AAdd(_aQDTab, { 'QDV', 'QDV_RV', 1 })
	AAdd(_aQDTab, { 'QDZ', 'QDZ_RV', 1 })


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia da Tabela de Log. Se nao existir, a cria      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !TCCanOpen("LOGDOCREV")

		_cQuery := "CREATE TABLE LOGDOCREV ( "
		_cQuery += "LDR_EMP   VARCHAR(2), "
		_cQuery += "LDR_FIL   VARCHAR(2), "
		_cQuery += "LDR_USER  VARCHAR(6), "
		_cQuery += "LDR_NOMUS VARCHAR(30), "
		_cQuery += "LDR_DOCTO VARCHAR(16), "
		_cQuery += "LDR_RVANT VARCHAR(3), "
		_cQuery += "LDR_RVNEW VARCHAR(3), "
		_cQuery += "LDR_TABLE VARCHAR(3), "
		_cQuery += "LDR_RECNO VARCHAR(7), "
		_cQuery += "LDR_DATA  VARCHAR(8), "
		_cQuery += "LDR_HORA  VARCHAR(8) "
		_cQuery += ")  "

		TCSQLExec(_cQuery)

	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa variaveis do ParamBox                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cNumDoc := Space(TamSX3("QDH_DOCTO")[1])
	_cNumRev := Space(TamSX3("QDH_RV")[1])
	_cRevNew := Space(TamSX3("QDH_RV")[1])


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta janela para obtencao dos Parametros                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aParamBox,	{1, "Documento"	,     	_cNumDoc,	PesqPict("QDH","QDH_DOCTO" ),	"",	"QDH",	"",	100, .T.})
	Aadd(aParamBox,	{1, "Revisao Antiga", 	_cNumRev,	PesqPict("QDH","QDH_RV" ),		"",	"", 	"",	050, .T.})
	Aadd(aParamBox,	{1, "Revisao Nova  ", 	_cRevNew,	PesqPict("QDH","QDH_RV" ),		"",	"",		"",	050, .T.})
//Aadd(aParamBox,{1,"Produto",   Space(TamSX3("B1_COD")[1])	 ,PesqPict("SB1","B1_COD")	,"","SB1","",100,.T.})


	IF !ParamBox(aParamBox, "Informe o Documento a atualizar:", @aRet)

		Return

	Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o usuario nao informou Revisao Nova e Antiga iguais     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aRet[2] == aRet[3]

		MsgStop("Informe revisoes diferentes."  )

		Return

	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui retorno do ParamBox as variaveis do programa                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cNumDoc := aRet[1]
	_cNumRev := aRet[2]
	_cRevNew := aRet[3]

	If _cRevNew <> StrZero(Val(_cRevNew),3)

		MsgStop("Informe a numeracao de Revisao com zeros esquerda. " + Chr(13) + "Exemplo: 003 no lugar de 3 ou 03.")
		Return

	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para levantar as Revisoes existentes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_cQuery := "SELECT DISTINCT QDH_RV AS REVIS "
	_cQuery += "FROM " + RetSQLName("QDH") + " "
	_cQuery += "WHERE QDH_DOCTO = '" + _cNumDoc + "' "
	_cQuery += "AND QDH_FILIAL = '" + xFilial("QDH") + "' "
	_cQuery += "AND D_E_L_E_T_ <> '*' "
	_cQuery += "ORDER BY QDH_RV "

	_cNewAlias := GetNextAlias()

	DBUseArea( .T., "TOPCONN"     , TCGENQRY(,,_cQuery), _cNewAlias , .F., .T.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Popula o array _aRevis com as Revisoes Existentes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aRevis := {}

	DBSelectArea(_cNewAlias)
	While !EOF()

		AAdd(_aRevis, {(_cNewAlias)->REVIS, Space(3) })

		DBSelectArea(_cNewAlias)
		DBSkip()

	End


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o Alias temporario da Query                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DBSelectArea(_cNewAlias)
	DBCloseArea()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao tenha encontrado nenhuma revisao abandona o programa       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(_aRevis) == 0

		MsgStop("Nenhuma revisao encontrada para o documento " + _cNumDoc )
		Return

	Else

		_nPosRv   := AScan(_aRevis, {|x| x[1] == _cNumRev })

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso nao exista a Revisao abandona o programa                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If _nPosRv == 0

			MsgStop("Revisao " + _cNumRev + " nao encontrada para o documento " + _cNumDoc )
			Return

		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso exista, monta o De-Para no proprio array _aRevis considerando    ³
			//³ a mudanca das revisoes subsequentes a revisao atualizada pelo usuario ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_nAddRv := 0

			For _nRv := _nPosRv To Len(_aRevis)

				_aRevis[_nRv][2] := StrZero(Val(_cRevNew) + _nAddRv, 3)

				_nAddRv += 1

			Next _nRv

		EndIf


	EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a chamada da funcao de mudanca de revisao a partir da revisao   ³
//³ mais atualizada para a revisao mais antiga para evitar encavalamen- ³
//³ mento de atualizacoes                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Begin Transaction

		_nTamRev := Len(_aRevis)

		For _nRv := _nTamRev To 1 Step -1

			If _aRevis[_nRv][1] <> _aRevis[_nRv][2] .and. !Empty(AllTrim(_aRevis[_nRv][2]))

				ChgRev(_cNumDoc, _aRevis[_nRv][1], _aRevis[_nRv][2])

			EndIf

		Next

	End Transaction

	MsgInfo("Atualizacao concluida.","Atencao")

Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ ChgRev   º Autor ³ Marcelo Cardoso    º Data ³  27/06/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Executa a troca de Revisoes para todas as tabelas QD?      º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AtuDocRev                                                  º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ChgRev(_cDocNum, _cDcRvOld, _cDcRvNew)

	Local _nQD := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa o mesmo processo para todas as tabelas QD?                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nQD := 1 To Len(_aQDTab)

		_cTabQD := _aQDTab[_nQD][1] // Tabela
		_cCmpQD := _aQDTab[_nQD][2] // Campo a ser atualizado
		_nOrdQD := _aQDTab[_nQD][3] // Indice

		//Posiciona na tabela a ser atualizada
		DBSelectArea(_cTabQD)

		//Define o indice a ser utilizado
		DBSetOrder(_nOrdQD)

		//Efetua busca da chave Filial + Documento + Revisao
		If DBSeek(xFilial(_cTabQD) + _cDocNum + _cDcRvOld)

			// Determina o nome do campo QD?_FILIAL
			_cQDFil := SubStr(_cCmpQD, 1, 4) + "FILIAL"

			// Separa os campos que compoe a chave do Indice utilizado e coloca-os num array
			_aFielQD := Str2Arr(IndexKey(_nOrdQD), "+")

			// Com base no array acima, monta a chave Filial + Documento + Revisao para fim de comparacao no While
			_cKeyQD  := _aFielQD[1] + " + " +  _aFielQD[2] + " + " +  _aFielQD[3]

			//Varre a tabela QD? Corrente enquanto nao for Fim de arquivo e tratar-se de mesma chave Filial + Documento + Revisao
			While !EOF() .and. &(_cKeyQD) == xFilial(_cTabQD) + _cDocNum + _cDcRvOld

				DBSelectArea(_cTabQD)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratativa especial: atualizacao de campo da chave de indice corrente causa desposcionamento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !EOF() 					// Caso nao seja fim de arquivo

					_nAtuRec := Recno() 		// Memoriza o registro atual

					DBSkip() 					// Pula para o registro seguinte dentro da ordenacao vigente

					_nNxtRec := Recno() 		// Guarda o numero do registro do registro seguinte

					DBGoTo(_nAtuRec)  			// Retorna para o registro anterior

				Else                  		// Caso SEJA fim de arquivo

					_nNxtRec := LastRec()		// Considera o proximo registro como sendo o ultimo

				EndIf


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o campo Revisao                                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock(_cTabQD, .F.)

				&(_cCmpQD) := _cDcRvNew

				MSUnLock()


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria registro de Log com todas as informacoes da atualizacao        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				_cQuery := "INSERT INTO LOGDOCREV ( LDR_EMP, LDR_FIL, LDR_USER, LDR_NOMUS, LDR_DOCTO, LDR_RVANT, LDR_RVNEW, LDR_TABLE, LDR_RECNO, LDR_DATA, LDR_HORA ) "
				_cQuery += "VALUES ( "
				_cQuery += "'" + SM0->M0_CODIGO 		+ "', "
				_cQuery += "'" + SM0->M0_CODFIL 		+ "', "
				_cQuery += "'" + __cUserID      		+ "', "
				_cQuery += "'" + _cNomUser 				+ "', "
				_cQuery += "'" + _cDocNum  				+ "', "
				_cQuery += "'" + _cDcRvOld 				+ "', "
				_cQuery += "'" + _cDcRvNew 				+ "', "
				_cQuery += "'" + _cTabQD   				+ "', "
				_cQuery += "'" + StrZero(Recno(), 7)	+ "', "
				_cQuery += "'" + DToS(dDataBase) 		+ "', "
				_cQuery += "'" + Time() 				+ "'  "
				_cQuery += ") "

				TCSQLExec(_cQuery)


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ A atualizacao pode ter movido o registro para fora da sequencia     ³
				//³ entao pula para o proximo registro da sequencia correta             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DBSelectArea(_cTabQD)
				DBGoTo(_nNxtRec)

			End

		EndIf

	Next _nQD

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³ Str2Arr  º Autor ³ Marcelo Cardoso    º Data ³  27/06/13   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Gera um array a partir de string com separador             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AtuDocRev                                                  º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Str2Arr(_cTXT, _cSepara)

	Local _aArray := {}
	Local _nPos   := 0

	While Len(_cTXT) > 0

		_nPos := At(_cSepara, _cTXT)

		Do Case

		Case _nPos > 1

			AAdd(_aArray, SubStr(_cTXT, 01, _nPos - 1) )

			_cTXT := SubStr(_cTXT, _nPos + 1, Len(_cTXT) )

		Case _nPos == 1

			AAdd(_aArray, " ")

			_cTXT := SubStr(_cTXT, _nPos + 1, Len(_cTXT) )

		Case _nPos == 0

			AAdd(_aArray, SubStr(_cTXT, 01, Len(_cTXT) ) )

			_cTXT := ""

		EndCase

	End

Return(_aArray)
