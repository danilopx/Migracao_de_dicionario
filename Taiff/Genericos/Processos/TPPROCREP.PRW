#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOTVS.CH"

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTPPROCREP บAutor  ณEdson Hornberger    บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcoes relacionadas com Processo de Replica de Cadas-     บฑฑ
ฑฑบ          ณ   tros nas empresas.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Sera utilizado nos PEs dos Cadastros Especificos.          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION TPPROCREP(cAlias,cRotina,nOpc)

	LOCAL lRet			:= .F.
	LOCAL aArea			:= GetArea()
	LOCAL cEmpCad		:= GetMV("MV_GRPCAD"	,,"01")
	LOCAL cQuery		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL lContinua		:= .F.
	LOCAL nRegs			:= 0

	//Verifica se a Replica esta Ativa
	If !GetMV("MV_REPLIC",,.F.)

		Return(.F.)

	EndIf

	//Verifica se esta na Empresa Central de Cadastros (Unica que realiza a Replica)
	If cEmpAnt <> cEmpCad

		Return(.F.)

	EndIf

	//Verifica se existe a Funcao passada
	If !ExistBlock(SubStr(cRotina,3,Len(cRotina) - 2))

		Return(.F.)

	EndIf

	//Verifica se o Alias passado esta Cadastrado no Controle de Replica
	While !lContinua

		If Select("TSZT") > 0

			dbSelectArea("TSZT")
			dbCloseArea()

		EndIf

		cQuery := "SELECT" + cPl
		cQuery += Iif(nRegs == 0,"COUNT(*) AS REGS","*") + cPl
		cQuery += "FROM" + cPl
		cQuery += RetSQLName("SZT") + " SZT" + cPl
		cQuery += "WHERE" + cPl
		cQuery += "SZT.ZT_TABELA = '" + cAlias + "' AND" + cPl
		cQuery += "SZT.D_E_L_E_T_ = ''"
		If nRegs > 0
			cQuery += cPl + "ORDER BY" + cPl
			cQuery += "SZT.ZT_TABELA, SZT.ZT_EMPRESA, SZT.ZT_FILREP"
		EndIf

		TcQuery cQuery New Alias "TSZT"
		dbSelectArea("TSZT")
		dbGoTop()

		If nRegs = 0

			nRegs := TSZT->REGS
			If nRegs = 0

				Return(.F.)

			EndIf

		Else

			lContinua := .T.

		EndIf

	EndDo
	If Alltrim(cAlias) $ "SB1|SA2|SA1|SF4"
		PROCESSA({||TFPROCREP(cAlias,cRotina,nOpc,nRegs,@lRet)},"Controle de R้plicas (" + Alltrim(cAlias) + ")","Processando dados...",.T.)
	Else
		PROCESSA({||ProcRepl(cAlias,cRotina,nOpc,nRegs,@lRet)},"Controle de R้plicas","Processando dados...",.T.)
	EndIf

	RestArea(aArea)

RETURN(lRet)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTPPROCREP บAutor  ณMicrosiga           บ Data ณ  04/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION PROCREPL(cAlias,cRotina,nOpc,nRegs,lRet)

	LOCAL aArea001		:= GetArea()
	LOCAL aAreaSM0		:= GetArea("SM0")
	LOCAL oRPC
	LOCAL oErro
	LOCAL _oDlgLog
	LOCAL cErro			:= ""
	LOCAL i				:= 0
	LOCAL cIPServer		:= GetMv("MV_IPSRV"		,,"192.168.0.23")
	LOCAL cPortServer   := GetMv("MV_PORTSRV"	,,20000)
	LOCAL cPrefTab 		:= Iif(SubStr(cAlias, 1, 1) = "S",SubStr(cAlias, 2, 2),cAlias)
	LOCAL cQuery		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL aCmpNRep		:= {}
	LOCAL _aRotAuto		:= {}
	LOCAL cContComp		:= ""
	LOCAL _cEmp			:= ""
	LOCAL _cFil			:= ""
	LOCAL cFilRep		:= ""
	LOCAL cFiltro		:= ""
	LOCAL aEmpresas		:= {}
	LOCAL lGrantUser	:= .F.
	LOCAL cAmbiente		:= ""
	LOCAL _cEmpBase	:= CEMPANT
	LOCAL _cFilBase	:= CFILANT
	LOCAL aSX3SA2SB1	:= {}
	LOCAL nPosX3us		:= 0

	SX3->(DbGotop())
	While !SX3->(Eof())
		If Alltrim(SX3->X3_ARQUIVO) $ "A2|B1"
			aAdd(aSX3SA2SB1,{ Alltrim(SX3->X3_ARQUIVO), AllTrim(SX3->X3_CAMPO), SX3->X3_USADO })
		EndIf
		SX3->(DbSkip())
	End

	//Verificacao de Campos que nao serao Replicados
	If Select("TNREP") > 0

		dbSelectArea("TNREP")
		dbCloseArea()

	EndIf

	cQuery := "SELECT" + cPl
	cQuery += "SX5.X5_DESCRI" + cPl
	cQuery += "FROM" + cPl
	cQuery += RetSQLName("SX5") + " SX5" + cPl
	cQuery += "WHERE" + cPl
	cQuery += "SX5.X5_FILIAL = '" + xFilial("SX5") + "' AND" + cPl
	cQuery += "SX5.X5_TABELA = '" + AllTrim(TSZT->ZT_TABSX5) + "' AND" + cPl
	cQuery += "SX5.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TNREP"
	dbSelectArea("TNREP")
	dbGoTop()

	While TNREP->(!EOF())

		aAdd(aCmpNRep,{AllTrim(TNREP->X5_DESCRI)})
		TNREP->(dbSkip())

	EndDo

	TNREP->(dbCloseArea())

	dbSelectArea(cAlias)

	For i := 1 to FCount()

		cX3usado := ""
		If cPrefTab $ "A2|B1"
			nPosX3us := ASCAN(ASX3SA2SB1,{|X| ALLTRIM(X[1]) == "S"+CPREFTAB .AND. ALLTRIM(X[2]) == ALLTRIM(FIELD(I)) })
			If nPosX3us > 0
				cX3usado := aSX3SA2SB1[nPosX3us,3]
			EndIf
		EndIf

		Do Case

		Case cPrefTab $ "A2|B1" .AND. cX3usado = "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"
			// nใo leva para replica o campo que nใo estแ em uso
		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPBLOQ)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Bloqueados                                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "1", Nil})

		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPMBLQ)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Replica                                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "R", Nil})

		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPREPL)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Replica                                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "S", Nil})

		Case INCLUI .AND. Field(i) == cPrefTab + "_FILIAL"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณQuando for inclusใo, adicionar o campo FILIAL na matriz
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), &(Field(i)), Nil})

		Case Ascan(aCmpNRep, { | x | AllTrim(x[1]) == AllTrim(Field(i)) }) > 0
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCampos Especํficos - Nใo Replica                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Case INCLUI .And. Empty(&(Field(i)))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVALIDANDO APENAS NA INCLUSAO PARA EVITAR QUE NA ALTERACAO DEIXE DE LIMPAR UM CAMPO PREENCHIDOณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Case ALTERA .And. ( (Field(i) == TSZT->ZT_CMPMBLQ) .Or. (Field(i) == TSZT->ZT_CMPBLOQ) .Or. (Field(i) == TSZT->ZT_CMPREPL) )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAltera็ใo nao replica campos Bloqueio, Motivo de Bloqueio, Replicado           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		OtherWise
			AAdd(_aRotAuto, {Field(i), &(Field(i)), Nil})

		EndCase

	Next i

	//Inicio do Processo de Alteracao do Ambiente por Empresa/Filial e chamado da
	//Funcao que ira realizar a Cadastro Especifico nas Empresas
	TSZT->(dbGoTop())

	While TSZT->(!EOF())

		If !Empty(AllTrim(TSZT->ZT_REGRA))

			cFiltro := IF("FORMULA" $ UPPER(AllTrim(TSZT->ZT_REGRA)),&(ALLTRIM(TSZT->ZT_REGRA)),ALLTRIM(TSZT->ZT_REGRA))

			DBSELECTAREA(CALIAS)

			If &(cFiltro)

				aAdd(aEmpresas,{TSZT->ZT_EMPRESA+TSZT->ZT_FILREP})

			EndIf

		Else

			aAdd(aEmpresas,{TSZT->ZT_EMPRESA+TSZT->ZT_FILREP})

		EndIf

		TSZT->(dbSkip())

	EndDo

	If Len(aEmpresas) > 0

		PROCREGUA(nRegs)

	Else

		Return(.T.)

	EndIf

	TSZT->(dbGoTop())

	While TSZT->(!EOF())

		If aScan(aEmpresas,{|x| x[1]=(AllTrim(TSZT->ZT_EMPRESA)+AllTrim(TSZT->ZT_FILREP))}) <= 0

			TSZT->(dbSkip())
			Loop

		EndIf

		IncProc("Empresa " + AllTrim(TSZT->ZT_EMPRESA) + " - Filial " + AllTrim(TSZT->ZT_FILREP) + " - Tabela " + AllTrim(cAlias) + "...")

		//Fecha a Tabela com Compartilhamento
		If Select("_TRBP") > 0

			dbSelectArea("_TRBP")
			dbCloseArea()

		EndIf

		//Cria a Tabela com Compartilhamento
		cQuery := "SELECT dbo.FC_TABMODO('" + TSZT->ZT_EMPRESA + "','" + TSZT->ZT_FILREP + "','" + cAlias + "') AS FILIAL"
		TcQuery cQuery New Alias "_TRBP"
		dbSelectArea("_TRBP")
		_TRBP->(dbGoTop())
		cFilRep := _TRBP->FILIAL

		_TRBP->(dbCloseArea())

		//Se existir o Cadastro no Controle de Replica para mais de uma Filial da mesma Empresa
		//Mas a Tabela for compartilhada, nao realiza mais de uma Inclusao/Alteracao
		If cContComp == TSZT->ZT_EMPRESA .And. Empty(AllTrim(cFilRep))

			cContComp := TSZT->ZT_EMPRESA
			TSZT->(dbSkip())
			Loop

		Else

			cErro		:= ""
			cAmbiente	:= GetEnvServer()
			oRPC 		:= TRPC():New( cAmbiente ) //
			cContComp 	:= TSZT->ZT_EMPRESA
			_cEmp		:= TSZT->ZT_EMPRESA
			_cFil		:= TSZT->ZT_FILREP
			If oRPC:Connect(cIPServer, cPortServer)

				dbSelectArea("SM0")
				dbSetOrder(1)
				dbSeek(_cEmp+_cFil)

				lGrantUser := U_GRANTUSER(__cUserID)

				RestArea(aAreaSM0)

				cErro := oRPC:CallProc("RPCSetType", 3)//3)
				cErro := oRPC:CallProc("RPCSetEnv", _cEmp, _cFil,,,,cAmbiente, {cAlias,"SM4"} )
				CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )

				Sleep(1000)
				CONOUT('---> Iniciando a chamando da Funcao de Replica para empresa ' + _cEmp + "/" + _cFil)
				_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_FILIAL"}),2] := cFilRep
				CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )

				/**********************************************************************************************************
				Data: 29/03/2016
				Analista: Gilberto Ribeiro Junior
				Tratativa para o campo B1_TIPO na Empresa Proart - Matriz, que nใo pode ser MP, entใo alteramos para PR
				***********************************************************************************************************/
				If (cPrefTab == "B1")
					cTipo := _aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2]
					If (_cEmp == "03" .AND. _cFil == "01" .AND. cTipo == "MP")
						_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2] := "PR"
					EndIf
				EndIf
				/***********************************************************************************************************/
				
				cErro := oRPC:CallProc(cRotina, _cEmp, _cFil, _aRotAuto, nOpc, lGrantUser)
				oRPC:CallProc("RpcClearEnv")
				
				//Retorna o Tipo para o Original
				If (cPrefTab == "B1")
					_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2] := cTipo
				EndIf
				
				CONOUT('<--- Finalizando a chamado da Funcao de Replica para empresa ' + _cEmp + "/" + _cFil)
				oRPC:Disconnect()
				lRet := .T.
				
			EndIf
			
			If !Empty(cErro)
				
				cOperacao := If(INCLUI,"Inclusใo",If(ALTERA,"Altera็ใo","Exclusใo"))
				
				DEFINE MSDIALOG _oDlgLog TITLE "Log de Erro" FROM C(240),C(346) TO C(696),C(763) PIXEL
				@ C(009),C(006) GET oErro Var cErro MEMO Size C(194),C(188) PIXEL OF _oDlgLog READONLY
				DEFINE SBUTTON FROM C(203),C(174) TYPE 1 ENABLE OF _oDlgLog ACTION (_oDlgLog:End())
				ACTIVATE MSDIALOG _oDlgLog CENTERED
				
				MsgRun( "Aguarde, armazenando o LOG do erro" , "Replica de Cadastros" , { || U_GrvLogTf( UsrRetName(RetCodUsr()),dDatabase,Time(),TSZT->ZT_EMPRESA,TSZT->ZT_FILREP,cAlias,cErro,.T.,GetNewPar("MV_MAILREP","simone.kawashima@taiff.com.br"),cOperacao ) } )
				lRet := .F.
				
			EndIf
			
		EndIf
		
		TSZT->(dbSkip())
		
	EndDo
	
	/* Refor็a o retorno para empresa/filial onde foi iniciada a r้plica */
	If !Empty(_cEmp) .AND. _cEmp != _cEmpBase
		CONOUT("Refor็a o retorno para empresa/filial " + _cEmpBase + "/" + _cFilBase + " onde foi iniciada a r้plica")
		cAmbiente	:= GetEnvServer()
		oRPC:CallProc("RPCSetEnv", _cEmpBase, _cFilBase,,,,cAmbiente, {cAlias,"SM4"} )
		
	EndIf
	
	RestArea(aArea001)
	RestArea(aAreaSM0)
	
RETURN(lRet)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGRANTUSER บAutor  ณEdson Hornberger    บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que ira verificar se usuario tem permissao para     บฑฑ
ฑฑบ          ณ  realizar as alteracoes nos Cadastros                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION GRANTUSER(_IdUser)

	Local _aArea    := GetArea()
	LOCAL lRet		:= .F.
	LOCAL aGrpsUser	:= {}
	LOCAL _i		:= 0
	LOCAL cNameGrp	:= ""

	//Caso nao seja informado o codigo do usuario verifica
	//o usuario atual e retorna seu codigo
	If ValType(_IdUser) == "U" .Or. Empty(_IdUser)

		_IdUser := RetCodUsr()

	EndIf

	//Cria Array com todos os Grupos do Usuario
	//aGrpsUser := UsrRetGrp(_IdUser)
	PSWORDER(1)
	PSWSEEK(_IdUser)
	aGrpsUser := PSWRET(NIL)

	If !Empty(aGrpsUser[1][10])

		For _i := 1 to Len(aGrpsUser[1][10])

			//Retorna o Nome do Grupo do Usuario
			cNameGrp := Upper(AllTrim(GrpRetName(aGrpsUser[1][10][_i])))

			//Compara com o Nome da Empresa Atual
			If Upper(AllTrim(SM0->M0_NOME)) == cNameGrp

				lRet := .T.

			EndIf

		Next _i

	EndIf
	RestArea(_aArea)

RETURN(lRet)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSB1    บAutor  ณEdson Hornberger    บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar Manutencao no Cadastro de             บฑฑ
ฑฑบ          ณ  PRODUTOS                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Controle de Replica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CADSB1(cEmp,cFil,aCampos,nOpc,lGrantUser)

	Local _aArea        := GetArea()
	LOCAL cErro 		:= ""
	LOCAL cProd
	LOCAL cMSBLQL, cMOTBLOQ
	LOCAL nPosMSBLQL, nPosMOTBLOQ
	LOCAL cQuery 		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	//LOCAL cFiltro		:= ""
	LOCAL cA2filial	:= ""
	LOCAL nRecnoFilial:= 0
	LOCAL nSa2Loop		:= 0
	LOCAL cCampo		:= ""

	If Select("TCMP") > 0

		dbSelectArea("TCMP")
		dbCloseArea()

	EndIf

	//Busca o nome dos campos de Controle de Bloqueio e Motivo de Bloqueio
	cQuery := "SELECT" + cPl
	cQuery += "SZT.ZT_CMPBLOQ," + cPl
	cQuery += "SZT.ZT_CMPMBLQ" + cPl
	cQuery += "FROM" + cPl
	cQuery += "SZT010 SZT" + cPl
	cQuery += "WHERE" + cPl
	cQuery += "SZT.ZT_TABELA = 'SB1' AND" + cPl
	cQuery += "SZT.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")
	dbGoTop()

	cMSBLQL 	:= TCMP->ZT_CMPBLOQ
	cMOTBLOQ 	:= TCMP->ZT_CMPMBLQ

	TCMP->(dbCloseArea())

	cProd	:= aCampos[Ascan(aCampos,{|x|x[1] = "B1_COD"}),2]

	cA2filial	:= aCampos[Ascan(aCampos,{|x|x[1] == "B1_FILIAL"}),2]

	cQuery := "SELECT" 						+ cPl
	cQuery += "	B1_COD " 			+ cPl
	cQuery += "	,R_E_C_N_O_ AS B1RECNO" + cPl
	cQuery += "FROM" 						+ cPl
	cQuery += " SB1" + cEmp + "0 SB1 " 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "B1_COD = '" + cProd + "' AND" 	+ cPl
	cQuery += "B1_FILIAL = '" + cA2filial + "' AND" 	+ cPl
	cQuery += "SB1.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")

	Count To nRec

	DbGoTop()

	If nRec != 0
		nRecnoFilial := TCMP->B1RECNO
	EndIf

	If nRec != 0 .And. nOpc == 3

		nOpc := 4

	EndIf

	If nRec == 0 .And. nOpc == 4

		nOpc := 3

	EndIf
	TCMP->(dbCloseArea())


	//Se for Inclusao ira verificar qual empresa o usuario esta cadastrado e
	//deixar o cadastro liberado (Nao estara Bloqueado)
	If nOpc == 3

		If lGrantUser

			nPosMSBLQL	:= Ascan(aCampos,{|x|x[1] == cMSBLQL })
			If ! Empty(nPosMSBLQL)
				aCampos[nPosMSBLQL,2] := "2"
			EndIf

			nPosMOTBLOQ	:= Ascan(aCampos,{|x|x[1] == cMOTBLOQ })
			If ! Empty(nPosMOTBLOQ)
				aCampos[nPosMOTBLOQ,2] := "S"
			EndIf

		EndIF

	EndIf

	ALTERA	:= IIF(nOpc=3,.F.,.T.)
	INCLUI	:= IIF(nOpc=3,.T.,.F.)

	dbUseArea(.T.,"TOPCONN", "SB1" + cEmp + "0","SZ2B20", .T., .F.)
	dbSelectArea("SZ2B20")

	If ALTERA
		DBGoto( nRecnoFilial )
		If .NOT. Eof()
			Reclock("SZ2B20", .F.)
		ELSE
			ALTERA := .F.
		EndIf
	ElseIf INCLUI
		Reclock("SZ2B20", .T.)
	EndIf

	If ALTERA .OR. INCLUI
		SX3->(DbSetOrder(2))
		For nSa2Loop:=1 to Len(aCampos)
			If SX3->(DbSeek( aCampos[nSa2Loop,1] ))
				If SX3->X3_TIPO="D"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + DTOC(aCampos[nSa2Loop,2]) )
				ElseIf SX3->X3_TIPO="N"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + ALLTRIM(STR(aCampos[nSa2Loop,2])) )
				Else
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + aCampos[nSa2Loop,2] )
				EndIf

				/* Grava no campo conte๚do da matriz */
				cCampo := aCampos[nSa2Loop,1]
				&cCampo. := aCampos[nSa2Loop,2]

			Else
				//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + " NAO ENCONTRADO" )
			EndIf
		Next
		msunlock()
	EndIf
	dbCloseArea()


	RestArea(_aArea)
RETURN cErro

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSA1    บAutor  ณEdson Hornberger    บ Data ณ  03/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar manutencao no Cadastro de             บฑฑ
ฑฑบ          ณ  CLIENTES                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Controle de Replica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CADSA1(cEmp,cFil,aCampos,nOpc,lGrantUser)

	Local _aArea        := GetArea()
	LOCAL cErro 		:= ""
	LOCAL cFornec, cLoja
	LOCAL cMSBLQL, cMOTBLOQ
	LOCAL nPosMSBLQL, nPosMOTBLOQ
	LOCAL cQuery 		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL cA2filial	:= ""
	LOCAL nRecnoFilial:= 0
	LOCAL nSa2Loop		:= 0
	LOCAL cCampo		:= ""

	If Select("TCMP") > 0

		dbSelectArea("TCMP")
		dbCloseArea()

	EndIf

	//Busca o nome dos campos de Controle de Bloqueio e Motivo de Bloqueio
	cQuery := "SELECT" 						+ cPl
	cQuery += "SZT.ZT_CMPBLOQ," 			+ cPl
	cQuery += "SZT.ZT_CMPMBLQ" 				+ cPl
	cQuery += "FROM" 						+ cPl
	cQuery += RetSQLName("SZT") + " SZT" 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "SZT.ZT_TABELA = 'SA1' AND" 	+ cPl
	cQuery += "SZT.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")
	dbGoTop()

	cMSBLQL 	:= TCMP->ZT_CMPBLOQ
	cMOTBLOQ 	:= TCMP->ZT_CMPMBLQ

	TCMP->(dbCloseArea())

	cFornec 	:= aCampos[Ascan(aCampos,{|x|x[1] == "A1_COD"	 }),2]
	cLoja		:= aCampos[Ascan(aCampos,{|x|x[1] == "A1_LOJA"	 }),2]
	cA2filial	:= aCampos[Ascan(aCampos,{|x|x[1] == "A1_FILIAL"}),2]

	cQuery := "SELECT" 						+ cPl
	cQuery += "	A1_COD " 			+ cPl
	cQuery += "	,A1_LOJA" 				+ cPl
	cQuery += "	,R_E_C_N_O_ AS A2RECNO " + cPl
	cQuery += "FROM" 						+ cPl
	cQuery += " SA1" + cEmp + "0 SA1 " 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "A1_COD = '" + cFornec + "' AND " 	+ cPl
	cQuery += "A1_LOJA = '" + cLoja + "' AND " 	+ cPl
	cQuery += "A1_FILIAL = '" + cA2filial + "' AND " 	+ cPl
	cQuery += "SA1.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")

	Count To nRec

	DbGoTop()

	If nRec != 0
		nRecnoFilial := TCMP->A2RECNO
	EndIf

	If nRec != 0 .And. nOpc == 3

		nOpc := 4

	EndIf

	If nRec == 0 .And. nOpc == 4

		nOpc := 3

	EndIf
	TCMP->(dbCloseArea())

	//Se for Inclusao ira verificar qual empresa o usuario esta cadastrado e
	//deixar o cadastro liberado (Nao estara Bloqueado)
	If nOpc == 3

		If lGrantUser

			nPosMSBLQL	:= Ascan(aCampos,{|x|x[1] == cMSBLQL })
			If ! Empty(nPosMSBLQL)
				aCampos[nPosMSBLQL,2] := "2"
			EndIf

			nPosMOTBLOQ	:= Ascan(aCampos,{|x|x[1] == cMOTBLOQ })
			If ! Empty(nPosMOTBLOQ)
				aCampos[nPosMOTBLOQ,2] := "S"
			EndIf

		Endif

	EndIf

	ALTERA	:= IIF(nOpc=3,.F.,.T.)
	INCLUI	:= IIF(nOpc=3,.T.,.F.)

	dbUseArea(.T.,"TOPCONN", "SA1" + cEmp + "0","SZ2B20", .T., .F.)
	dbSelectArea("SZ2B20")

	If ALTERA
		DBGoto( nRecnoFilial )
		If .NOT. Eof() //dbseek(cA2filial + cFornec + cLoja )
			Reclock("SZ2B20", .F.)
		ELSE
			ALTERA := .F.
		EndIf
	ElseIf INCLUI
		Reclock("SZ2B20", .T.)
	EndIf


	If ALTERA .OR. INCLUI
		SX3->(DbSetOrder(2))
		For nSa2Loop:=1 to Len(aCampos)
			If SX3->(DbSeek( aCampos[nSa2Loop,1] ))
				If SX3->X3_TIPO="D"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + DTOC(aCampos[nSa2Loop,2]) )
				ElseIf SX3->X3_TIPO="N"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + ALLTRIM(STR(aCampos[nSa2Loop,2])) )
				Else
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + aCampos[nSa2Loop,2] )
				EndIf

				/* Grava no campo conte๚do da matriz */
				cCampo := aCampos[nSa2Loop,1]
				&cCampo. := aCampos[nSa2Loop,2]

			Else
				//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + " NAO ENCONTRADO" )
			EndIf
		Next
		msunlock()
	EndIf
	dbCloseArea()

	RestArea(_aArea)
RETURN cErro

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSA2    บAutor  ณEdson Hornberger    บ Data ณ  03/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar manutencao no Cadastro de             บฑฑ
ฑฑบ          ณ  FORNECEDORES                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Controle de Replica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CADSA2(cEmp,cFil,aCampos,nOpc,lGrantUser)

	Local _aArea        := GetArea()
	LOCAL cErro 		:= ""
	LOCAL cFornec, cLoja
	LOCAL cMSBLQL, cMOTBLOQ
	LOCAL nPosMSBLQL, nPosMOTBLOQ
	LOCAL cQuery 		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL cA2filial	:= ""
	LOCAL nRecnoFilial:= 0
	LOCAL nSa2Loop		:= 0
	LOCAL cCampo		:= ""

	If Select("TCMP") > 0

		dbSelectArea("TCMP")
		dbCloseArea()

	EndIf

	//Busca o nome dos campos de Controle de Bloqueio e Motivo de Bloqueio
	cQuery := "SELECT" 						+ cPl
	cQuery += "SZT.ZT_CMPBLOQ," 			+ cPl
	cQuery += "SZT.ZT_CMPMBLQ" 				+ cPl
	cQuery += "FROM" 						+ cPl
	cQuery += RetSQLName("SZT") + " SZT" 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "SZT.ZT_TABELA = 'SA2' AND" 	+ cPl
	cQuery += "SZT.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")
	dbGoTop()

	cMSBLQL 	:= TCMP->ZT_CMPBLOQ
	cMOTBLOQ 	:= TCMP->ZT_CMPMBLQ

	TCMP->(dbCloseArea())

	cFornec 	:= aCampos[Ascan(aCampos,{|x|x[1] == "A2_COD"	 }),2]
	cLoja		:= aCampos[Ascan(aCampos,{|x|x[1] == "A2_LOJA"	 }),2]
	cA2filial	:= aCampos[Ascan(aCampos,{|x|x[1] == "A2_FILIAL"}),2]

	cQuery := "SELECT" 						+ cPl
	cQuery += "	A2_COD " 			+ cPl
	cQuery += "	,A2_LOJA" 				+ cPl
	cQuery += "	,R_E_C_N_O_ AS A2RECNO " + cPl
	cQuery += "FROM" 						+ cPl
	cQuery += " SA2" + cEmp + "0 SA2 " 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "A2_COD = '" + cFornec + "' AND " 	+ cPl
	cQuery += "A2_LOJA = '" + cLoja + "' AND " 	+ cPl
	cQuery += "A2_FILIAL = '" + cA2filial + "' AND " 	+ cPl
	cQuery += "SA2.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")

	Count To nRec

	DbGoTop()

	If nRec != 0
		nRecnoFilial := TCMP->A2RECNO
	EndIf

	If nRec != 0 .And. nOpc == 3

		nOpc := 4

	EndIf

	If nRec == 0 .And. nOpc == 4

		nOpc := 3

	EndIf
	TCMP->(dbCloseArea())

	//Se for Inclusao ira verificar qual empresa o usuario esta cadastrado e
	//deixar o cadastro liberado (Nao estara Bloqueado)
	If nOpc == 3

		If lGrantUser

			nPosMSBLQL	:= Ascan(aCampos,{|x|x[1] == cMSBLQL })
			If ! Empty(nPosMSBLQL)
				aCampos[nPosMSBLQL,2] := "2"
			EndIf

			nPosMOTBLOQ	:= Ascan(aCampos,{|x|x[1] == cMOTBLOQ })
			If ! Empty(nPosMOTBLOQ)
				aCampos[nPosMOTBLOQ,2] := "S"
			EndIf

		Endif

	EndIf

	ALTERA	:= IIF(nOpc=3,.F.,.T.)
	INCLUI	:= IIF(nOpc=3,.T.,.F.)

	dbUseArea(.T.,"TOPCONN", "SA2" + cEmp + "0","SZ2B20", .T., .F.)
	dbSelectArea("SZ2B20")

	If ALTERA
		DBGoto( nRecnoFilial )
		If .NOT. Eof() //dbseek(cA2filial + cFornec + cLoja )
			Reclock("SZ2B20", .F.)
		ELSE
			ALTERA := .F.
		EndIf
	ElseIf INCLUI
		Reclock("SZ2B20", .T.)
	EndIf


	If ALTERA .OR. INCLUI
		SX3->(DbSetOrder(2))
		For nSa2Loop:=1 to Len(aCampos)
			If SX3->(DbSeek( aCampos[nSa2Loop,1] ))
				If SX3->X3_TIPO="D"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + DTOC(aCampos[nSa2Loop,2]) )
				ElseIf SX3->X3_TIPO="N"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + ALLTRIM(STR(aCampos[nSa2Loop,2])) )
				Else
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + aCampos[nSa2Loop,2] )
				EndIf

				/* Grava no campo conte๚do da matriz */
				cCampo := aCampos[nSa2Loop,1]
				&cCampo. := aCampos[nSa2Loop,2]

			Else
				//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + " NAO ENCONTRADO" )
			EndIf
		Next
		msunlock()
	EndIf
	dbCloseArea()

	RestArea(_aArea)
RETURN cErro

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCADSF4    บAutor  ณEdson Hornberger    บ Data ณ  03/28/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para realizar manutencao no Cadastro de             บฑฑ
ฑฑบ          ณ  TIPOS DE ENTRADA E SAIDA                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Controle de Replica                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION CADSF4(cEmp,cFil,aCampos,nOpc,lGrantUser)

	Local _aArea        := GetArea()
	LOCAL cErro 		:= ""
	//LOCAL cFornec, cLoja
	LOCAL cMSBLQL, cMOTBLOQ
	LOCAL nPosMSBLQL, nPosMOTBLOQ
	LOCAL cQuery 		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL cA2filial	:= ""
	LOCAL nRecnoFilial:= 0
	LOCAL nSa2Loop		:= 0
	LOCAL cCampo		:= ""

	If Select("TCMP") > 0

		dbSelectArea("TCMP")
		dbCloseArea()

	EndIf

	//Busca o nome dos campos de Controle de Bloqueio e Motivo de Bloqueio
	cQuery := "SELECT" 						+ cPl
	cQuery += "SZT.ZT_CMPBLOQ," 			+ cPl
	cQuery += "SZT.ZT_CMPMBLQ" 				+ cPl
	cQuery += "FROM" 						+ cPl
	cQuery += RetSQLName("SZT") + " SZT" 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "SZT.ZT_TABELA = 'SF4' AND" 	+ cPl
	cQuery += "SZT.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")
	dbGoTop()

	cMSBLQL 	:= TCMP->ZT_CMPBLOQ
	cMOTBLOQ 	:= TCMP->ZT_CMPMBLQ

	TCMP->(dbCloseArea())

	cFornec 	:= aCampos[Ascan(aCampos,{|x|x[1] == "F4_CODIGO"	 }),2]
	//cLoja		:= aCampos[Ascan(aCampos,{|x|x[1] == "A1_LOJA"	 }),2]
	cA2filial	:= aCampos[Ascan(aCampos,{|x|x[1] == "F4_FILIAL"}),2]

	cQuery := "SELECT" 						+ cPl
	cQuery += "	F4_CODIGO " 			+ cPl
	//cQuery += "	,A1_LOJA" 				+ cPl
	cQuery += "	,R_E_C_N_O_ AS A2RECNO " + cPl
	cQuery += "FROM" 						+ cPl
	cQuery += " SF4" + cEmp + "0 SF4 " 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "F4_CODIGO = '" + cFornec + "' AND " 	+ cPl
	//cQuery += "A1_LOJA = '" + cLoja + "' AND " 	+ cPl
	cQuery += "F4_FILIAL = '" + cA2filial + "' AND " 	+ cPl
	cQuery += "SF4.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")

	Count To nRec

	DbGoTop()

	If nRec != 0
		nRecnoFilial := TCMP->A2RECNO
	EndIf

	If nRec != 0 .And. nOpc == 3

		nOpc := 4

	EndIf

	If nRec == 0 .And. nOpc == 4

		nOpc := 3

	EndIf
	TCMP->(dbCloseArea())

	//Se for Inclusao ira verificar qual empresa o usuario esta cadastrado e
	//deixar o cadastro liberado (Nao estara Bloqueado)
	If nOpc == 3

		If lGrantUser

			nPosMSBLQL	:= Ascan(aCampos,{|x|x[1] == cMSBLQL })
			If ! Empty(nPosMSBLQL)
				aCampos[nPosMSBLQL,2] := "2"
			EndIf

			nPosMOTBLOQ	:= Ascan(aCampos,{|x|x[1] == cMOTBLOQ })
			If ! Empty(nPosMOTBLOQ)
				aCampos[nPosMOTBLOQ,2] := "S"
			EndIf

		Endif

	EndIf

	ALTERA	:= IIF(nOpc=3,.F.,.T.)
	INCLUI	:= IIF(nOpc=3,.T.,.F.)

	dbUseArea(.T.,"TOPCONN", "SF4" + cEmp + "0","SZ2B20", .T., .F.)
	dbSelectArea("SZ2B20")

	If ALTERA
		DBGoto( nRecnoFilial )
		If .NOT. Eof() //dbseek(cA2filial + cFornec + cLoja )
			Reclock("SZ2B20", .F.)
		ELSE
			ALTERA := .F.
		EndIf
	ElseIf INCLUI
		Reclock("SZ2B20", .T.)
	EndIf


	If ALTERA .OR. INCLUI
		SX3->(DbSetOrder(2))
		For nSa2Loop:=1 to Len(aCampos)
			If SX3->(DbSeek( aCampos[nSa2Loop,1] ))
				If SX3->X3_TIPO="D"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + DTOC(aCampos[nSa2Loop,2]) )
				ElseIf SX3->X3_TIPO="N"
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + ALLTRIM(STR(aCampos[nSa2Loop,2])) )
				Else
					//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + aCampos[nSa2Loop,2] )
				EndIf

				/* Grava no campo conte๚do da matriz */
				cCampo := aCampos[nSa2Loop,1]
				&cCampo. := aCampos[nSa2Loop,2]

			Else
				//CONOUT( "CAMPO " + aCampos[nSa2Loop,1] + " NAO ENCONTRADO" )
			EndIf
		Next
		msunlock()
	EndIf
	dbCloseArea()

	RestArea(_aArea)
RETURN cErro


/*
=================================================================================
=================================================================================
||   Arquivo:	TPPROCREP.PRW
=================================================================================
||   Funcao: 	CADSA3
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 	Funcao para realizar manutencao no Cadastro de
|| 	VENDEDORES
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	25/07/2014 (Nota.: Esta Funcao teve de ser refeita)
=================================================================================
=================================================================================
*/

USER FUNCTION CADSA3(cEmp,cFil,aCampos,nOpc,lGrantUser)

	Local _aArea        := GetArea()
	LOCAL cErro 		:= ""
	LOCAL cVend
	LOCAL cMSBLQL, cMOTBLOQ
	LOCAL nPosMSBLQL, nPosMOTBLOQ
	LOCAL cQuery 		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	PRIVATE lMsHelpAuto := .T. // se .T. direciona as mensagens de help para o arquivo de log
	PRIVATE lMsErroAuto := .F. // necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros

	If Select("TCMP") > 0

		dbSelectArea("TCMP")
		dbCloseArea()

	EndIf

	//Busca o nome dos campos de Controle de Bloqueio e Motivo de Bloqueio
	cQuery := "SELECT" 						+ cPl
	cQuery += "SZT.ZT_CMPBLOQ," 			+ cPl
	cQuery += "SZT.ZT_CMPMBLQ" 				+ cPl
	cQuery += "FROM" 						+ cPl
	cQuery += RetSQLName("SZT") + " SZT" 	+ cPl
	cQuery += "WHERE" 						+ cPl
	cQuery += "SZT.ZT_TABELA = 'SA3' AND" 	+ cPl
	cQuery += "SZT.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TCMP"
	dbSelectArea("TCMP")
	dbGoTop()

	cMSBLQL 	:= TCMP->ZT_CMPBLOQ
	cMOTBLOQ 	:= TCMP->ZT_CMPMBLQ

	TCMP->(dbCloseArea())

	dbSelectArea("SA3")
	dbSetOrder(1)

	cVend 		:= aCampos[Ascan(aCampos,{|x|x[1] == "A3_COD"	 }),2]

	If SA3->(Dbseek(xFilial("SA3") + cVend)) .And. nOpc == 3

		nOpc := 4

	EndIf

	If !SA3->(Dbseek(xFilial("SA3") + cVend)) .And. nOpc == 4

		nOpc := 3

	EndIf

	//Se for Inclusao ira verificar qual empresa o usuario esta cadastrado e
	//deixar o cadastro liberado (Nao estara Bloqueado)
	If nOpc == 3

		If lGrantUser

			nPosMSBLQL	:= Ascan(aCampos,{|x|x[1] == cMSBLQL })
			If ! Empty(nPosMSBLQL)
				aCampos[nPosMSBLQL,2] := "2"
			EndIf

			nPosMOTBLOQ	:= Ascan(aCampos,{|x|x[1] == cMOTBLOQ })
			If ! Empty(nPosMOTBLOQ)
				aCampos[nPosMOTBLOQ,2] := "S"
			EndIf

		Else

			ConOut('---* Problemas com direitos para realizar a Replica!')

		Endif

	EndIf

	//Inicio do Processo de Manutencao do Cadastro
	Begin Transaction

		ConOut('---> Inicio do MSExecAuto...')
		MSExecAuto({|x, y| Mata040(x, y)}, aCampos, nOpc)
		If lMSErroAuto
			Qout(Iif(nOpc == 3 ,"Inclusใo","Altera็ใo/Exclusใo") + " nใo executada na empresa " + cEmp + ", Filial " + cFil)
			DisarmTransaction()
		Endif
		ConOut('<--- Fim do MSExecAuto...')

	End Transaction

	If lMSErroAuto
		cErro := MostraErro()
	Endif

	RestArea(_aArea)

RETURN cErro



STATIC FUNCTION TFPROCREP(cAlias,cRotina,nOpc,nRegs,lRet)

	LOCAL aArea001		:= GetArea()
	LOCAL aAreaSM0		:= GetArea("SM0")
	LOCAL oRPC
	//LOCAL oErro
	//LOCAL _oDlgLog
	LOCAL cErro			:= ""
	LOCAL i				:= 0
	//LOCAL cIPServer		:= GetMv("MV_IPSRV"		,,"192.168.0.23")
	//LOCAL cPortServer   := GetMv("MV_PORTSRV"	,,20000)
	LOCAL cPrefTab 		:= Iif(SubStr(cAlias, 1, 1) = "S",SubStr(cAlias, 2, 2),cAlias)
	LOCAL cQuery		:= ""
	LOCAL cPl			:= Chr(13) + Chr(10)
	LOCAL aCmpNRep		:= {}
	LOCAL _aRotAuto		:= {}
	LOCAL cContComp		:= ""
	LOCAL _cEmp			:= ""
	LOCAL _cFil			:= ""
	LOCAL cFilRep		:= ""
	LOCAL cFiltro		:= ""
	LOCAL aEmpresas		:= {}
	LOCAL lGrantUser	:= .F.
	LOCAL cAmbiente		:= ""
	//LOCAL _cEmpBase	:= CEMPANT
	//LOCAL _cFilBase	:= CFILANT
	LOCAL aSX3SA2SB1	:= {}
	LOCAL nPosX3us		:= 0
	Local NLOOP			:= 0


	PUBLIC ATSZT := {}

	ALTERA := .T.
	INCLUI := .F.

	SX3->(DbGotop())
	While !SX3->(Eof())
		If Alltrim(SX3->X3_ARQUIVO) $ "SA2|SB1|SA1|SF4"
			aAdd(aSX3SA2SB1,{ Alltrim(SX3->X3_ARQUIVO), AllTrim(SX3->X3_CAMPO), SX3->X3_USADO })
		EndIf
		SX3->(DbSkip())
	End

	//Verificacao de Campos que nao serao Replicados
	If Select("TNREP") > 0

		dbSelectArea("TNREP")
		dbCloseArea()

	EndIf

	cQuery := "SELECT" + cPl
	cQuery += "SX5.X5_DESCRI" + cPl
	cQuery += "FROM" + cPl
	cQuery += RetSQLName("SX5") + " SX5" + cPl
	cQuery += "WHERE" + cPl
	cQuery += "SX5.X5_FILIAL = '" + xFilial("SX5") + "' AND" + cPl
	cQuery += "SX5.X5_TABELA = '" + AllTrim(TSZT->ZT_TABSX5) + "' AND" + cPl
	cQuery += "SX5.D_E_L_E_T_ = ''"

	TcQuery cQuery New Alias "TNREP"
	dbSelectArea("TNREP")
	dbGoTop()

	While TNREP->(!EOF())

		aAdd(aCmpNRep,{AllTrim(TNREP->X5_DESCRI)})
		TNREP->(dbSkip())

	EndDo

	TNREP->(dbCloseArea())

	dbSelectArea(cAlias)

	For i := 1 to FCount()

		cX3usado := ""
		If cPrefTab $ "A2"
			nPosX3us := ASCAN(ASX3SA2SB1,{|X| ALLTRIM(X[1]) == "SA2" .AND. ALLTRIM(X[2]) == ALLTRIM(FIELD(I)) })
			If nPosX3us > 0
				cX3usado := aSX3SA2SB1[nPosX3us,3]
			EndIf
		ElseIf cPrefTab $ "B1"
			nPosX3us := ASCAN(ASX3SA2SB1,{|X| ALLTRIM(X[1]) == "SB1" .AND. ALLTRIM(X[2]) == ALLTRIM(FIELD(I)) })
			If nPosX3us > 0
				cX3usado := aSX3SA2SB1[nPosX3us,3]
			EndIf
		ElseIf cPrefTab $ "A1"
			nPosX3us := ASCAN(ASX3SA2SB1,{|X| ALLTRIM(X[1]) == "SA1" .AND. ALLTRIM(X[2]) == ALLTRIM(FIELD(I)) })
			If nPosX3us > 0
				cX3usado := aSX3SA2SB1[nPosX3us,3]
			EndIf
		ElseIf cPrefTab $ "F4"
			nPosX3us := ASCAN(ASX3SA2SB1,{|X| ALLTRIM(X[1]) == "SF4" .AND. ALLTRIM(X[2]) == ALLTRIM(FIELD(I)) })
			If nPosX3us > 0
				cX3usado := aSX3SA2SB1[nPosX3us,3]
			EndIf
		EndIf

		Do Case

		Case cPrefTab $ "A2" .AND. ALLTRIM(cX3usado) = "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"  .AND. FIELD(I) != "A2_FILIAL"
			// nใo leva para replica o campo que nใo estแ em uso
		Case cPrefTab $ "A1" .AND. ALLTRIM(cX3usado) = "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"  .AND. FIELD(I) != "A1_FILIAL"
			// nใo leva para replica o campo que nใo estแ em uso
		Case cPrefTab $ "B1" .AND. ALLTRIM(cX3usado) = "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"  .AND. FIELD(I) != "B1_FILIAL"
			// nใo leva para replica o campo que nใo estแ em uso
		Case cPrefTab $ "F4" .AND. ALLTRIM(cX3usado) = "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ"  .AND. FIELD(I) != "F4_FILIAL"
			// nใo leva para replica o campo que nใo estแ em uso
		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPBLOQ)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Bloqueados                                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "1", Nil})

		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPMBLQ)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Replica                                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "R", Nil})

		Case INCLUI .And. (Field(i) == TSZT->ZT_CMPREPL)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSempre Replica                                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), "S", Nil})

		Case INCLUI .AND. Field(i) == cPrefTab + "_FILIAL"
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณQuando for inclusใo, adicionar o campo FILIAL na matriz
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			AAdd(_aRotAuto, {Field(i), &(Field(i)), Nil})

		Case Ascan(aCmpNRep, { | x | AllTrim(x[1]) == AllTrim(Field(i)) }) > 0
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCampos Especํficos - Nใo Replica                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Case INCLUI .And. Empty(&(Field(i)))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณVALIDANDO APENAS NA INCLUSAO PARA EVITAR QUE NA ALTERACAO DEIXE DE LIMPAR UM CAMPO PREENCHIDOณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Case ALTERA .And. ( (Field(i) == TSZT->ZT_CMPMBLQ) .Or. (Field(i) == TSZT->ZT_CMPBLOQ) .Or. (Field(i) == TSZT->ZT_CMPREPL) )
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAltera็ใo nao replica campos Bloqueio, Motivo de Bloqueio, Replicado           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		OtherWise
			AAdd(_aRotAuto, {Field(i), &(Field(i)), Nil})

		EndCase

	Next i

	//Inicio do Processo de Alteracao do Ambiente por Empresa/Filial e chamado da
	//Funcao que ira realizar a Cadastro Especifico nas Empresas
	TSZT->(dbGoTop())

	While TSZT->(!EOF())

		If !Empty(AllTrim(TSZT->ZT_REGRA))

			cFiltro := IF("FORMULA" $ UPPER(AllTrim(TSZT->ZT_REGRA)),&(ALLTRIM(TSZT->ZT_REGRA)),ALLTRIM(TSZT->ZT_REGRA))

			DBSELECTAREA(CALIAS)

			If &(cFiltro)

				aAdd(aEmpresas,{TSZT->ZT_EMPRESA+TSZT->ZT_FILREP})

			EndIf

		Else

			aAdd(aEmpresas,{TSZT->ZT_EMPRESA+TSZT->ZT_FILREP})

		EndIf

		TSZT->(dbSkip())

	EndDo

	If Len(aEmpresas) > 0

	Else

		Return(.T.)

	EndIf

	ATSZT := {}
	TSZT->(dbGoTop())

	While TSZT->(!EOF())

		If aScan(aEmpresas,{|x| x[1]=(AllTrim(TSZT->ZT_EMPRESA)+AllTrim(TSZT->ZT_FILREP))}) <= 0

			TSZT->(dbSkip())
			Loop

		EndIf

		aAdd(ATSZT,{ Alltrim(TSZT->ZT_EMPRESA), AllTrim(TSZT->ZT_FILREP) })


		TSZT->(dbSkip())

	EndDo

	lGrantUser := U_GRANTUSER(__cUserID)


	FOR NLOOP := 1 TO LEN(ATSZT)

		//Fecha a Tabela com Compartilhamento
		If Select("_TRBP") > 0

			dbSelectArea("_TRBP")
			dbCloseArea()

		EndIf

		//Cria a Tabela com Compartilhamento
		cQuery := "SELECT dbo.FC_TABMODO('" + ATSZT[NLOOP,1] + "','" + ATSZT[NLOOP,2] + "','" + cAlias + "') AS FILIAL"
		TcQuery cQuery New Alias "_TRBP"
		dbSelectArea("_TRBP")
		_TRBP->(dbGoTop())
		cFilRep := _TRBP->FILIAL

		_TRBP->(dbCloseArea())

		//Se existir o Cadastro no Controle de Replica para mais de uma Filial da mesma Empresa
		//Mas a Tabela for compartilhada, nao realiza mais de uma Inclusao/Alteracao
		If cContComp == ATSZT[NLOOP,1] .And. Empty(AllTrim(cFilRep))

			cContComp := ATSZT[NLOOP,1]

		Else

			cErro		:= ""
			cAmbiente	:= GetEnvServer()
			oRPC 		:= TRPC():New( cAmbiente ) //
			cContComp 	:= ATSZT[NLOOP,1]
			_cEmp		:= ATSZT[NLOOP,1]
			_cFil		:= ATSZT[NLOOP,2]

			_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_FILIAL"}),2] := cFilRep

			/**********************************************************************************************************
			Data: 29/03/2016
			Analista: Gilberto Ribeiro Junior
			Tratativa para o campo B1_TIPO na Empresa Proart - Matriz, que nใo pode ser MP, entใo alteramos para PR
			***********************************************************************************************************/
			If (cPrefTab == "B1")
				cTipo := _aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2]
				If (_cEmp == "03" .AND. _cFil == "01" .AND. cTipo == "MP")
					_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2] := "PR"
				EndIf
			EndIf
			/***********************************************************************************************************/
			If cPrefTab == "B1"
				U_CADSB1( _cEmp , _cFil , _aRotAuto , nOpc , lGrantUser)
			ElseIf cPrefTab == "A2"
				U_CADSA2( _cEmp , _cFil , _aRotAuto , nOpc , lGrantUser)
			ElseIf cPrefTab == "A1"
				U_CADSA1( _cEmp , _cFil , _aRotAuto , nOpc , lGrantUser)
			ElseIf cPrefTab == "F4"
				U_CADSF4( _cEmp , _cFil , _aRotAuto , nOpc , lGrantUser)
			EndIf
			
			
			//Retorna o Tipo para o Original
			If (cPrefTab == "B1")
				_aRotAuto[Ascan(_aRotAuto,{|x|x[1] == cPrefTab + "_TIPO"}),2] := cTipo
			EndIf
			
			CONOUT('<--- Finalizando a chamado da Funcao de Replica para empresa ' + _cEmp + "/" + _cFil)
			
			lRet := .T.
			
			
		EndIf
		
	NEXT
	
	
	RestArea(aArea001)
	RestArea(aAreaSM0)
	
	If cPrefTab == "B1"
		dbSelectArea("SB1")
	ElseIf cPrefTab == "A2"
		dbSelectArea("SA2")
	ElseIf cPrefTab == "A1"
		dbSelectArea("SA1")
	ElseIf cPrefTab == "F4"
		dbSelectArea("SF4")
	EndIf
	
RETURN(lRet)
