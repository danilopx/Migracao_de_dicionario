#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE PULA Chr(13)+Chr(10)
#DEFINE ENTER Chr(13)+Chr(10)

Static lFirst := .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGAT001   บAutor  ณRichard N. Cabral   บ Data ณ  05/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do campo A1_CGC                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MGAT001()

	Local _aArea		:= GetArea()
	Local aFilNoRepl 	:= {}
	Local cTabNoRepl 	:= "ZB"


	If INCLUI .And. ! l030Auto

		aArea	 := GetArea()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEstou chumbando a busca por dados no SX5 da empresa 01   ณ
		//ณpara nใo ter que cadastrar os dados em todas as empresas.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuerySX5 := "SELECT X5_DESCRI FROM SX5010 SX5 "
		cQuerySX5 += "WHERE X5_FILIAL = '  ' "
		cQuerySX5 += "AND X5_TABELA = '" + cTabNoRepl + "' "
		cQuerySX5 += "AND X5_CHAVE = 'SA1' "
		cQuerySX5 += "AND D_E_L_E_T_ = ' ' "
		dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuerySX5), "SQLSX5", .F., .F. )

		SQLSX5->(Dbgotop())
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlimenta Array com as filiais que nใo serใo replicadas por tabela - Tabela ZB  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Do While ! SQLSX5->(Eof())
			Aadd(aFilNoRepl, AllTrim(SQLSX5->X5_DESCRI))
			SQLSX5->(DBskip())
		EndDo

		SQLSX5->(dbCloseArea())

		RestArea(aArea)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se eh a empresa da Central de Cadastro (DAIHATSU)ณ
		//ณou as empresas configuradas para nao receber a replica  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_aEmpAtu := U_CrgaEmp()
		nEmpAtu := Ascan(_aEmpAtu, { | x | x[1] = cEmpAnt .and. x[2] = cFilAnt } )

		If !(cEmpAnt = "04" .And. cFilAnt = "02") .AND. CEMPANT != "05"

			If Empty()
				If nEmpAtu > 0 .And. ! (Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"DAIHATSU")) )
					MsgAlert("Inclusใo nใo permitida nesta empresa !!!","STOP")
					Return(.F.)
				EndIf
			Else
				If nEmpAtu > 0 .And. ! (Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"DAIHATSU")) .Or. ! Empty(Ascan(aFilNoRepl,cEmpAnt)))
					MsgAlert("Inclusใo nใo permitida nesta empresa !!!","STOP")
					Return(.F.)
				EndIf
			Endif

		EndIf

		If M->A1_PESSOA = "J"

			cQuery := "SELECT A1_COD, MAX(A1_LOJA) as A1_LOJA FROM " + RetSqlName("SA1") + " SA1 WHERE A1_CGC LIKE '" + Left(M->A1_CGC,8) + "%' "
			cQuery += "AND A1_PESSOA = 'J' "
			cQuery += "AND D_E_L_E_T_ = ' ' AND A1_CGC <> '"+Space(TamSX3("A1_CGC")[1])+"' "
			cQuery += "GROUP BY A1_COD"
			dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuery), "TRMAX", .F., .F. )

			TRMAX->(Dbgotop())

			If ! Empty(TRMAX->A1_COD)
				If __lSX8
					RollBackSX8()
				EndIf

				M->A1_COD	:= TRMAX->A1_COD
				M->A1_LOJA	:= Strzero(Val(TRMAX->A1_LOJA)+1,2)
			Else
				If !__lSX8
					M->A1_COD	:= GetSX8Num("SA1","A1_COD")
				EndIf

				If M->A1_EST == "EX" .Or. !Empty( M->A1_CGC )
					M->A1_LOJA	:= "01"
				Else
					M->A1_LOJA	:= "  "
				EndIf
			Endif

			TRMAX->(dbCloseArea())

		Else

			If !__lSX8
				M->A1_COD := GetSX8Num("SA1","A1_COD")
			EndIf

			If M->A1_EST == "EX" .Or. !Empty( M->A1_CGC )
				M->A1_LOJA	:= "01"
			Else
				M->A1_LOJA	:= "  "
			EndIf


		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTratamento para nao conformidade na rotina automatica  ( temporario )ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If INCLUI .And. l030Auto .And. Empty( M->A1_LOJA ) .And. !Empty(aRotAuto[aScan(aRotAuto,{|x| AllTrim(x[1])=="A1_LOJA"}),2])
			M->A1_LOJA := aRotAuto[aScan(aRotAuto,{|x| AllTrim(x[1])=="A1_LOJA"}),2]
		EndIf
	EndIf

	RestArea(_aArea)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGAT002   บAutor  ณRichard N. Cabral   บ Data ณ  02/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do campo A2_COD                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MGAT002()

	If INCLUI .And. FunName() = "MATA020"

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se eh a empresa da Central de Cadastro (DAIHATSU)ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_aEmpAtu := U_CrgaEmp()
		nEmpAtu := Ascan(_aEmpAtu, { | x | x[1] = cEmpAnt .and. x[2] = cFilAnt } )

		//Permite a inclusใo de Fornecedores para Action - MG (Filial 02)
		If !(cEmpAnt = "04" .And. cFilAnt $ "01|02|03")
			If ! ( (nEmpAtu > 0) .And. ( Alltrim(_aEmpAtu[nEmpAtu,3]) = AllTrim(GetMV("MV_GRPCAD",,"DAIHATSU")) ) )
				MsgAlert("Inclusใo nใo permitida nesta empresa !!!","STOP")
				Return(.F.)
			EndIf
		EndIf

	EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMGAT003   บAutor  ณRichard N. Cabral   บ Data ณ  05/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o nome do cliente ou fornecedor de acordo com      บฑฑ
ฑฑบ          ณ o tipo de NF                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MGAT003()
	Local cChaveCliente := SC5->C5_CLIENTE+SC5->C5_LOJACLI
	Local cReturn := ""
	If cEmpAnt + cFilAnt = "0302" .AND. SC5->C5_FILDES = '01' .AND. SC5->(FIELDPOS("C5_CLIORI")) != 0
		If .NOT. Empty(SC5->C5_CLIORI)
			cChaveCliente:=SC5->C5_CLIORI+SC5->C5_LOJORI
		EndIf
	EndIf
	cReturn := IF(SC5->C5_TIPO $ "DB",POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME"),POSICIONE("SA1",1,XFILIAL("SA1") + cChaveCliente ,"A1_NOME"))

Return (cReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkUsuar  บAutor  ณRichard N. Cabral   บ Data ณ  05/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina utilizada para verificar se o usuแrio tem acesso a  บฑฑ
ฑฑบ          ณ altera็ใo nos campos especificos.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ChkUsuar(cUserName)

	Local aEmpUsu
	Local nCta := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCheca parametro que habilita / desabilita a replica    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ! GetMV("MV_REPLIC",,.F.)
		Return .T.
	EndIf

	Static aGetUser := {}
	Static aGetGroup := {}

	If Empty(aGetUser)
		aGetUser := AllUsers()
	Endif

	If Empty(aGetGroup)
		aGetGroup := AllGroups()
	Endif

	aEmpUsu := U_CrgaEmp()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIdentifica qual eh o grupo da empresa logada    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cGrpUsu := ""
	nGrpUsu := Ascan(aEmpUsu,{|x| x[1] = cEmpAnt .And. x[2] = cFilAnt})
	If ! Empty(nGrpUsu)
		cGrpUsu := aEmpUsu[nGrpUsu,3]
	Endif

	cGrpEmp := ""
	nGrpEmp := ASCAN(aGetGroup, {|x| ALLTRIM(Upper(x[1,2])) = Alltrim(cGrpUsu)})
	If ! Empty(nGrpEmp)
		cGrpEmp := aGetGroup[nGrpEmp, 1, 1]
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณIdentifica se o usuแrio logado pertence ao grupo da empresa ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nUsuario := Ascan(aGetUser, {|x| Alltrim(Upper(x[1,2])) = Alltrim(Upper(cUserName))})

	lUsuEmp := .F.

	If ! Empty(nUsuario)
		//Identifica็ใo: ID0000001
		//Observa็ใo...: Linha abaixo comentada jแ que o ASCAN retornava sempre o NULL e substituida pelo FOR ... NEXT
		//Autor........: CT                     Data: 24/07/2014
		//lUsuEmp := (ASCAN(aGetUser[nUsuario, 1, 10], {|x| ALLTRIM(x) = cGrpEmp }) > 0)
		//
		For nCta := 1 to len(aGetUser[nUsuario, 1, 10])
			If aGetUser[nUsuario, 1, 10,nCta] = Alltrim(cGrpEmp)
				lUsuEmp := .T.
			EndIf
		Next
		//-------------------------------------------------[Fim do ID0000001]----------------------------------
	Endif

Return lUsuEmp

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACFG001   บAutor  ณRichard N. Cabral   บ Data ณ  09/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Manuten็ใo da tabela de Campos Especํficos - Cadastro      บฑฑ
ฑฑบ          ณ de Clientes - SA1 - Tabela Z6 - SX5                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACFG001()

	Local xAlias	:= GetArea()
	Local aRet		:= {}
	Local aParamBox := {}

	Private cPorta
	Private cTitulo	:= "Manut.Campos Especํficos"

	aTabelas := {}

	Aadd(aTabelas, "Z3 - (SA2) Cadastros de Fornecedores")
	Aadd(aTabelas, "Z4 - (SB1) Cadastros de Produtos")
	Aadd(aTabelas, "Z5 - (CT1) Cadastros de Plano de Contas")
	Aadd(aTabelas, "Z6 - (SA1) Cadastros de Clientes")
	Aadd(aTabelas, "Z7 - (SF4) Cadastros de TES")

	Aadd(aParamBox,{2,cTitulo,aTabelas[1],aTabelas,120,"",.T.})

	IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
		Return(.F.)
	Endif

	Processa( {|lEnd| U_ManSx5(Left(aRet[1],2),.F.,.T.,.F.) } , "Aguarde..." , cTitulo + " - " + aRet[1] , .T. )

	RestArea(xAlias)

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCrgaEmp   บAutor  ณRichard N. Cabral   บ Data ณ  11/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega Empresas a serem processadas e Campos Especificos  บฑฑ
ฑฑบ          ณ para nใo replicar - Rotina Especํfica Taiff                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CrgaEmp(cEmpEspec)

	Local aEmp := {}

	aArea		:= GetArea()
	aAreaSM0	:= SM0->(GetArea())

	dbSelectArea("SM0")
	SM0->(DbGotop())
	Do While ! SM0->(EOF())
		If ValType(cEmpEspec) = "U" .Or. ( ValType(cEmpEspec) = "C" .And. M0_CODIGO = cEmpEspec )
			AAdd(aEmp, {M0_CODIGO, M0_CODFIL, M0_NOME})
		Endif
		SM0->(DbSkip())
	End

	RestArea(aAreaSM0)
	RestArea(aArea)

Return(aEmp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณeContas   บAutor  ณMario Cavenaghi     บ Data ณ  18/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os eMails de todos usuarios do grupo               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function eContas(cContas)

	Local aContas := {}
	Local nItem := 0
	Local nPos := 0
	Local aGetUser := AllUsers()
	Local aGetGroup := AllGroups()
	Local cCodGrupo := ""

	cContas := Alltrim(cContas)

	While Len(cContas) > 0 .And. !Empty(cContas)
		nPos := At(";", cContas)
		If nPos > 1	//	Despresa o ";" no fim na String
			Aadd(aContas, Left(cContas, nPos - 1))
			cContas := Alltrim(Substr(cContas, nPos + 1))
		Else
			Aadd(aContas, Alltrim(cContas))
			cContas := ""
		Endif
	Enddo

	cContas := ""

	For nPos := 1 To Len(aContas)
		If At("@", aContas[nPos]) > 0
			cContas += aContas[nPos]+"; "
		Elseif ( nItem := ASCAN(aGetUser, {|x| ALLTRIM(Upper(x[1, 2])) == Upper(aContas[nPos])})) > 0 .AND. !EMPTY(ALLTRIM(aGetUser[nItem, 1, 14]))
			cContas += ALLTRIM(aGetUser[nItem, 1, 14])+"; "
		Else
			nItem := ASCAN(aGetGroup, {|x| ALLTRIM(Upper(x[1, 2])) == Upper(aContas[nPos])})
			If nItem > 0
				cCodGrupo := aGetGroup[nItem, 1, 1]
				For nItem := 1 To Len(aGetUser)
					If ASCAN(aGetUser[nItem, 1, 10], {|x| ALLTRIM(x) == cCodGrupo }) > 0 .AND. !EMPTY(ALLTRIM(aGetUser[nItem, 1, 14]))
						cContas += ALLTRIM(aGetUser[nItem, 1, 14])+"; "
					Endif
				Next
			Endif
		Endif
	Next

	If !Empty(cContas) .AND. RIGHT(cContas, 2) == "; "
		cContas := LEFT(cContas, Len(cContas) - 2)
	Endif

Return(cContas)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออัอออออออัออออออออออออออออออออัออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ SendMail ณ Autor ณ Richard N. Cabral  ณ Data ณ  17/11/09    บฑฑ
ฑฑฬออออออออออุออออออออออฯอออออออฯออออออออออออออออออออฯออออออฯออออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua o e-mail de e-mails conforme parametros...           บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SendMail(cPara, cCC, cBCC, cAssunto, mCorpo, cAnexo1, cAnexo2, cAnexo3, cAnexo4, cAnexo5, cServidor, cConta, cSenhaS)

	Local lOk    := Nil
	Local _lMail := Nil

	Default cServidor 	:= "smtp.taiff.com.br:587" //GetMV("MV_RELSERV")
	Default cConta		:= GetMV("MV_RELACNT")
	Default cSenhaS		:= GetMV("MV_RELAPSW")

	CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cSenhaS Result lOk

	If GetMv("MV_RELAUTH")
		MailAuth(cConta,cSenhaS)
	Endif

	If lOk
		Send Mail From cConta To cPara CC cCC BCC cBCC Subject cAssunto Body mCorpo;
			Attachment cAnexo1, cAnexo2, cAnexo3, cAnexo4, cAnexo5;
			Result _lMail
	EndIf

	If !_lMail
		GET MAIL ERROR cErro
		ALERT(cErro)
	EndIf

	Disconnect SMTP Server

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ  VldSX1  บAutor  ณ   Alexandro Dias   บ Data ณ  09/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao de perguntas do SX1                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VldSX1(aPergunta)

	Local i
	Local aAreaBKP := GetArea()

	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	For i := 1 To Len(aPergunta)
		SX1->(RecLock("SX1",!dbSeek(Padr(aPergunta[i,1],10)+aPergunta[i,2])))
		SX1->X1_GRUPO 		:= aPergunta[i,1]
		SX1->X1_ORDEM		:= aPergunta[i,2]
		SX1->X1_PERGUNT		:= aPergunta[i,3]
		SX1->X1_VARIAVL		:= aPergunta[i,4]
		SX1->X1_TIPO		:= aPergunta[i,5]
		SX1->X1_TAMANHO		:= aPergunta[i,6]
		SX1->X1_DECIMAL		:= aPergunta[i,7]
		SX1->X1_GSC			:= aPergunta[i,8]
		SX1->X1_VAR01		:= aPergunta[i,9]
		SX1->X1_DEF01		:= aPergunta[i,10]
		SX1->X1_DEF02		:= aPergunta[i,11]
		SX1->X1_DEF03		:= aPergunta[i,12]
		SX1->X1_DEF04		:= aPergunta[i,13]
		SX1->X1_DEF05		:= aPergunta[i,14]
		SX1->X1_F3			:= aPergunta[i,15]
		SX1->(MsUnlock())
	Next i

	RestArea(aAreaBKP)

Return(Nil)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRegra de Reducao de IPI do valor unitarioณ
//ณespecifico da Daihatsu                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If cEmpAnt == "01"
		If ("C6_PRCVEN" $ ReadVar() .And. GDFieldGet("C6_PRCVEN") <> M->C6_PRCVEN) .Or. ;
				("C6_PRODUTO" $ ReadVar() .And. GDFieldGet("C6_PRODUTO") <> M->C6_PRODUTO)

			GDFieldPut("C6_REAJIPI"," ")
		EndIf
	EndIf

Return _lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvLogTf บAutor  ณ Fernando Salvatori บ Data ณ  02/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera log para a empresa TAIFF de processos                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvLogTf( cUser,dData,cHora,cEmpDes,cFilDes,cTabela,cMens,lMail,cMail,cOperacao )

	Local cHtml := ""
	Local aMens := {}
	Local nX    := 0

	RecLock("ZA7",.T.)

	ZA7->ZA7_FILIAL := xFilial("ZA7")
	ZA7->ZA7_USU    := cUser
	ZA7->ZA7_DATA   := dData
	ZA7->ZA7_HORA   := cHora
	ZA7->ZA7_EMPDES := cEmpDes
	ZA7->ZA7_FILDES := cFilDes
	ZA7->ZA7_TABELA := cTabela
	ZA7->ZA7_MENS   := cMens
	ZA7->ZA7_OPER	:= cOperacao

	MsUnlock()

	If lMail
		Q_MemoArray( cMens, @aMens, 80 )

		cHtml += '<html>'

		cHtml += '<head>'
		cHtml += '<meta http-equiv="Content-Language" content="en-us">'
		cHtml += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
		cHtml += '<title>Nova pagina 1</title>'
		cHtml += '</head>'

		cHtml += '<body>'

		cHtml += '<p align="center"><font face="Verdana"><b>PROBLEMA EM RษPLICA DE CADASTROS</b></font></p>'
		cHtml += '<p align="left"><font face="Verdana">Houve um problema na r้plica de cadastros, '
		cHtml += 'segue abaixo as informa็๕es para controle:</font></p>'
		cHtml += '<table border="1" width="31%">'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Usuแrio</font></td>'
		cHtml += '		<td><font face="Verdana">'+cUser+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Data</font></td>'
		cHtml += '		<td><font face="Verdana">'+DtoC(dData)+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Hora</font></td>'
		cHtml += '		<td><font face="Verdana">'+cHora+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Empresa Destino</font></td>'
		cHtml += '		<td><font face="Verdana">'+cEmpDes+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Filial Destino</font></td>'
		cHtml += '		<td><font face="Verdana">'+cFilDes+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '	<tr>'
		cHtml += '		<td width="129"><font face="Verdana">Tabela</font></td>'
		cHtml += '		<td><font face="Verdana">'+cTabela+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '		<td width="129"><font face="Verdana">Opera็ใo</font></td>'
		cHtml += '		<td><font face="Verdana">'+cOperacao+'</font></td>'
		cHtml += '	</tr>'
		cHtml += '</table>'
		cHtml += '<table border="1" width="100%">'
		cHtml += '	<tr><td>'
		For nX := 1 to Len( aMens )
			cHtml += '<p><font face="Verdana">'+aMens[nX]+'</font></p>'
		Next nX

		cHtml += '	</td></tr>'
		cHtml += '</table>'

		cHtml += '</body>'

		cHtml += '</html>'

		U_2EnvMail(NIL,RTrim(cMail),"",cHtml,"Problemas com Replica de cadastros" ,"")

	EndIf

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ManZA7   บAutor  ณ Fernando Salvatori บ Data ณ  02/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Manutencao no cadastro ZA7                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MANZA7

Return AxCadastro("ZA7")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RegraVendบAutor  ณ Fernando Salvatori บ Data ณ  02/26/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Regra para Portal                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RegraVend(nRegra)
	Local uRet := Nil

	If nRegra == 1
		SA3->( dbSetOrder(7) )
		If SA3->( MsSeek( xFilial("SA3") + __cUserID ) )
			If SA3->A3_ALTVEN == "2"
				uRet := .F.
			Else
				uRet := .T.
			EndIf
		Else
			uRet := .T.
		Endif
	ElseIf nRegra == 2
		SA3->( dbSetOrder(7) )
		If SA3->( MsSeek( xFilial("SA3") + __cUserID ) )
			If SA3->A3_VENDNOR == "1"
				uRet := .F.
			Else
				uRet := .T.
			EndIf
		Else
			uRet := .T.
		EndIf
	ElseIf nRegra == 3
		SA3->( dbSetOrder(7) )
		If SA3->( MsSeek( xFilial("SA3") + __cUserID ) )
			If SA3->A3_ALTVEN == "2"
				uRet := SA3->A3_COD
			Else
				uRet := Space(TamSX3("A3_COD")[1])
			EndIf
		Else
			uRet := Space(TamSX3("A3_COD")[1])
		EndIf
	EndIf

Return uRet




//------------------------------------------------------------------------------------------------------------------
//Fun็ใo...: TFSC9BRW
//Descri็ใo: Retornar conte๚do de campo virtual no Browse da tabela SC9
//Data.....: 27/11/2014
//Autor....: Carlo Torres
//------------------------------------------------------------------------------------------------------------------
User Function TFSC9BRW( _cCampo )
	Local cRetorno:= ""
	Local cChave	:= ""
	If _cCampo='NomeVendedor'
		cChave:=POSICIONE("SC5",1,XFILIAL("SC5")+SC9->C9_PEDIDO,"C5_VEND1")
		cRetorno :=POSICIONE("SA3",1,XFILIAL("SA3")+cChave,"A3_NOME")
	EndIf
Return (cRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFunction  ณSomenteNumerosLetras  												  บฑฑ
ฑฑบChamada   ณSomenteNumerosLetras(cString, cNomeCampo)   		  			  บฑฑ  
ฑฑบParametros:																				  บฑฑ 
ฑฑบ	cString: Conteudo a ser validado												  บฑฑ 
ฑฑบ	cNomeCampo: Nome do Campo que estแ sendo Validado, serแ usado na 	  บฑฑ 
					   mensagem da valida็ใo											  บฑฑ 
ฑฑบAutor: Gilberto Ribeiro Junior บ Data ณ 05/10/2011  					  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se a String cont้m ou nใo caracteres especiais  	  บฑฑ
ฑฑบ          ณ                          											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SomenteNumerosLetras(cString, cNomeCampo)
	Local _ret := .F.
	Local nX := 0

	If Empty(AllTrim(cString))
		_ret := .T.
	EndIf

	For nX:=1 To Len(AllTrim(cString))
		cChar:=SubStr(cString, nX, 1)
		If (Asc(cChar) >= 48 .And. Asc(cChar) <= 57 .Or. Asc(cChar) == 44 .Or. Asc(cChar) == 46)
			_ret := .T.
		Else
			If(Asc(cChar) >= 97 .And. Asc(cChar) <= 122)
				_ret := .T.
			Else
				Alert("O campo " + cNomeCampo + " somente aceita n๚meros e letras sem acentua็ใo.")
				_ret := .F.
				Exit
			EndIf
		EndIf
	Next nX

Return _ret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFunction  ณRetRentabilidade  												  		  บฑฑ
ฑฑบChamada   ณRetRentabilidade(cNumPed, cOper)	   		  			  		  บฑฑ  
ฑฑบParametros:																				  บฑฑ 
ฑฑบ	cNumPed: N๚mero do Pedido														  บฑฑ 
ฑฑบ	cOper: 	Opera็ใo que estแ sendo executada							 	  บฑฑ 
ฑฑบAutor: Gilberto Ribeiro Junior บ Data ณ 14/12/2011  					  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera as informa็๕es de rentabilidade do pedido			 	  บฑฑ
ฑฑบ          ณ                          											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RetRentabilidade(cNumPed, cOper)

	Local cQuery	:= ""

	If (M->C5_CLASPED <> "V") // Classifica็ใo Pedido <> VENDAS
		If(cOper=="VISUALIZAR")
			RecLock("SC5",.F.) 	// Trava o registro para conseguir alterar
			SC5->C5_VLR1PED := 0 // Valor de R1(Soma dos ํtens)
			SC5->C5_PCR1PED := 0 // Percentual de R1 (Soma dos ํtens)
			SC5->C5_ROL 	 := 0 // Valor da Receita Operacional Lํquida (Soma dos ํtens)
			SC5->C5_VLR2PED := 0 // Valor de R1(Soma dos ํtens)
			SC5->C5_PCR2PED := 0 // Percentual de R1 (Soma dos ํtens)
			MsUnLock()           // Libera o registro
		ElseIf(cOper == "ALTERAR")
			M->C5_VLR1PED := 0 // Valor de R1(Soma dos ํtens)
			M->C5_PCR1PED := 0 // Percentual de R1 (Soma dos ํtens)
			M->C5_ROL 	  := 0 // Valor da Receita Operacional Lํquida (Soma dos ํtens)
			M->C5_VLR2PED := 0 // Valor de R1(Soma dos ํtens)
			M->C5_PCR2PED := 0 // Percentual de R1 (Soma dos ํtens)
		EndIf
		Return Nil
	EndIf

	cQuery += " SELECT SUM(C6_VLR1) C5_VLR1PED  "
	cQuery += " 		,CASE "
	cQuery += "		 		WHEN SUM(C6_ROL) = 0 THEN "
	cQuery += "			 		CAST(SUM(C6_VLR1) AS DECIMAL(5,2)) "
	cQuery += "			 ELSE "
	cQuery += "			 		CAST((SUM(C6_VLR1) / SUM(C6_ROL)) * 100 AS DECIMAL(5,2)) "
	cQuery += "		  	 END C5_PCR1PED "
	cQuery += " 		,SUM(C6_ROL) C5_ROL "
	cQuery += "	FROM " + RetSqlName("SC6") + " SC6 "
	cQuery += " WHERE C6_NUM = '" + cNumPed + "' "
	cQuery += "   AND ISNULL(D_E_L_E_T_, '') = '' "

	If Select("TSC6") > 0
		TSC6->( dbCloseArea() )
	EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery), "TSC6", .F., .T.)

	TSC6->( dbGoTop() )

	If !TSC6->( EOF() )
		If(cOper=="VISUALIZAR")
			RecLock("SC5",.F.) 						 // Trava o registro para conseguir alterar
			SC5->C5_VLR1PED := TSC6->C5_VLR1PED  // Valor de R1(Soma dos ํtens)
			SC5->C5_PCR1PED := TSC6->C5_PCR1PED  // Percentual de R1 (Soma dos ํtens)
			SC5->C5_ROL 	 := TSC6->C5_ROL      // Valor da Receita Operacional Lํquida (Soma dos ํtens)
			MsUnLock()                           // Libera o registro
		ElseIf(cOper == "ALTERAR")
			M->C5_VLR1PED := TSC6->C5_VLR1PED    // Valor de R1(Soma dos ํtens)
			M->C5_PCR1PED := TSC6->C5_PCR1PED    // Percentual de R1 (Soma dos ํtens)
			M->C5_ROL 	  := TSC6->C5_ROL        // Valor da Receita Operacional Lํquida (Soma dos ํtens)
		EndIf
	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFunction  ณEnvMail			  												  		  บฑฑ
ฑฑบChamada   ณU_EnvMail("gjunior@taiff.com.br", "gjunior@taiff.com.br",	  บฑฑ
ฑฑบ							"Teste", "Conte๚do - Teste")							  บฑฑ  
ฑฑบParametros:																				  บฑฑ 
ฑฑบ	cDe:      E-mail do Remetente													  บฑฑ 
ฑฑบ	cPara: 	 E-mail do Destinatแrio											 	  บฑฑ 
ฑฑบ	cAssunto: Assunto																 	  บฑฑ 
ฑฑบ	cCorpo: 	 Conte๚do/Corpo do E-mail										 	  บฑฑ 
ฑฑบAutor: Gilberto Ribeiro Junior บ Data ณ 08/10/2012  					  	  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail														 	  บฑฑ
ฑฑบ          ณ                          											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnvMail(cDe, cPara, cAssunto, cCorpo)
	Local	_cSmtpSrv 	:= AllTrim(GETMV("MV_RELSERV")),;
		_cAccount 	:= Iif(!Empty(AllTrim(GETMV("MV_CMEMAS"))),AllTrim(GETMV("MV_CMEMAS")),AllTrim(GetMV("MV_RELACNT"))),;
		_cPassSmtp	:= Iif(!Empty(AllTrim(GetMV("MV_CMEMPS"))),AllTrim(GetMV("MV_CMEMPS")),AllTrim(GETMV("MV_RELAPSW"))),;
		_cSmtpError	:= '',;
		_lOk		:= .f.,;
		_cTitulo 	:= cAssunto,;
		_cTo		:= AllTrim(cPara),;
		_cFrom		:= cDe,;
		_CMENSAGEM	:= CCORPO,;
		_lReturn	:= .f.

	//_cMensagem	:= '',;
		Local lAuth			:= GetMv("MV_RELAUTH",,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณConectando com o Servidor. !!ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	CONNECT SMTP SERVER _cSmtpSrv ACCOUNT _cAccount PASSWORD _cPassSmtp RESULT _lOk
	ConOut('Conectando com o Servidor SMTP')

	If lAuth		// Autenticacao da conta de e-mail
		lResult := MailAuth(_cAccount, _cPassSmtp)
		If !lResult
			ConOut("Nao foi possivel autenticar a conta - " + _cAccount)
			Return()
		EndIf
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCaso a conexao for esbelecida com sucesso, inicia o processo de envio do e-mail..ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If	( _lOk )
		SEND MAIL FROM _cFrom TO _cTo SUBJECT _cTitulo BODY _cMensagem RESULT _lOk
		DISCONNECT SMTP SERVER
		ConOut('Desconectando do Servidor')
		_lReturn := .t.
	Else
		GET MAIL ERROR _cSmtpError
		ConOut(_cSmtpError)
		_lReturn := .f.
	EndIf

Return _lReturn

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetMVNum  บAutor  ณFernando Salvatori  บ Data ณ 30/07/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria numero sequencial em tabela de Parametros (SX6)       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ GENERICO                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Foi necessario retornar com a Funcao GETMVNUM pois o mesmo eh utilizado na
|	geracao de arquivo CNAB de Contas a Pagar do Banco Bradesco.
|
|	Edson Hornberger - 15/12/2014
|=================================================================================
*/
User Function GetMVNum( cMV, nTam )
	Local _aArea := GetArea()						//Area reservada
	Local _cNum  := Replicate("0",nTam - 1) + "1"	//Numero inicial

	dbSelectArea( "SX6" )
	dbSetOrder(1)
	If dbSeek( xFilial("SX6") + cMV )
		_cNum := GetMV(cMV)
		_cNum := Soma1( _cNum )

		RecLock("SX6", .F.)
		SX6->X6_CONTEUD := _cNum
		SX6->X6_CONTSPA := _cNum
		SX6->X6_CONTENG := _cNum
		MsUnlock()
	Else
		RecLock("SX6", .T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := cMV
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Numero Sequencial - Controle da GetMVNum()"
		SX6->X6_CONTEUD := _cNum
		SX6->X6_CONTSPA := _cNum
		SX6->X6_CONTENG := _cNum
		SX6->X6_PROPRI  := "U"
		SX6->X6_PYME    := "S"
		MsUnlock()
	EndIf

	RestArea( _aArea )

Return _cNum

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMsgHBox   บAutor  ณ Fernando Salvatori บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe uma mensagem no padrao Help.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MsgHBox( cMensagem, cTipoHelp )
	Local aMsg  := {}
	Local cText := ""
	Local nMemo := 0

	Default cTipoHelp := ProcName(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuebro o texto em 40 posicoesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Q_MemoArray( cMensagem, @aMsg, 40 )

	For nMemo := 1 to Len( aMsg )
		cText += aMsg[nMemo]+Chr(13)+Chr(10)
	Next nMemo

	Help(" ",1,"NVAZIO",cTipoHelp,cText,1,0)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvLog    บAutor  ณIvan Morelatto Tore บ Data ณ  22/03/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera arquivo de Log para informar se alguma coisa nao       บฑฑ
ฑฑบ          ณfuncionou corretamente no processamento.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณGrvLog( ExpC1, ExpC2 )                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณExpC1 - Path e nome do arquivo para gerar o log             บฑฑ
ฑฑบ          ณExpC2 - Texto a ser gravado no arquivo de log.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvLog( cArquivo, cTexto )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de Variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local nHdl     := 0			// Handle do arquivo texto

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o arquivo Existeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !File( cArquivo )
		nHdl := FCreate( cArquivo )
	Else
		nHdl := FOpen( cArquivo, 2 )
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua grava็ใo do textoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	FSeek( nHdl, 0, FS_END )
	cTexto += Chr(13) + Chr(10)
	FWrite( nHdl, cTexto, Len(cTexto) )
	FClose( nHdl )
Return

/*
=================================================================================
=================================================================================
||   Arquivo:	TAIFFXFUN.PRW
=================================================================================
||   Funcao: 	CALVOL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para realizar o calculo de volumes dos Pedidos. 
|| 		Eh necessario passar os pedidos em um array para que sejam calculados
|| 	os mesmmos, podendo passar apenas um ou varios.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:	11/03/2015
=================================================================================
=================================================================================
*/

USER FUNCTION CALCVOL(APEDIDOS, LREIMPRESSAO, CNUMORDSEP )

	LOCAL ARET 		:= {}
	LOCAL NVOL		:= 0
	LOCAL I			:= 0
	LOCAL CQUERY 	:= ""
	LOCAL AAREA		:= GETAREA()
	LOCAL NREG		:= 0

	DEFAULT LREIMPRESSAO := .F.
	DEFAULT CNUMORDSEP := ""

	IF LEN(APEDIDOS) = 0

		RETURN({0,0,0})

	ENDIF

	IF SELECT("VOL") > 0

		DBSELECTAREA("VOL")
		DBCLOSEAREA()

	ENDIF

	ARET := {0,0,0}

	FOR I := 1 TO LEN(APEDIDOS)

		CQUERY := "SELECT" 													+ PULA
		CQUERY += "	SUM(SC9.C9_QTDLIB / SB5.B5_QE1) AS VOLUME,"				+ PULA
		CQUERY += "	SUM(SC9.C9_QTDLIB * SB1.B1_PESBRU) AS PBRUTO,"			+ PULA
		CQUERY += "	SUM(SC9.C9_QTDLIB * SB1.B1_PESO) AS PLIQ" 				+ PULA
		CQUERY += "FROM" 													+ PULA
		CQUERY += "	" + RETSQLNAME("SC9") + " SC9" 							+ PULA
		CQUERY += "		INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 		+ PULA
		CQUERY += "			SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 	+ PULA
		CQUERY += "			SB1.B1_COD = SC9.C9_PRODUTO AND" 				+ PULA
		CQUERY += "			SB1.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "		LEFT OUTER JOIN " + RETSQLNAME("SB5") + " SB5 ON" 	+ PULA
		CQUERY += "			SB5.B5_FILIAL = '" + XFILIAL("SB5") + "' AND" 	+ PULA
		CQUERY += "			SB5.B5_COD = SC9.C9_PRODUTO AND" 				+ PULA
		CQUERY += "			SB5.D_E_L_E_T_ = ''" 							+ PULA
		CQUERY += "WHERE" 													+ PULA
		CQUERY += "	SC9.C9_FILIAL = '" + XFILIAL("SC9") + "' AND" 			+ PULA
		CQUERY += "	SC9.C9_PEDIDO IN (" + APEDIDOS[I,1] + ") AND" 			+ PULA
		If .NOT. LREIMPRESSAO
			CQUERY += "	SC9.C9_NFISCAL = '' AND" 								+ PULA
		Else
			CQUERY += "	SC9.C9_ORDSEP = '"+CNUMORDSEP+"' AND" 								+ PULA
		EndIf
		CQUERY += "	SC9.C9_SEQUEN = (SELECT MAX(C9_SEQUEN) FROM " + RETSQLNAME("SC9") + " TMP WHERE TMP.C9_FILIAL = '" + xFILIAL("SC9") + "' AND TMP.C9_PEDIDO = SC9.C9_PEDIDO AND TMP.C9_ITEM = SC9.C9_ITEM AND TMP.C9_PRODUTO = SC9.C9_PRODUTO AND TMP.D_E_L_E_T_ = '') AND" + PULA
		CQUERY += "	SC9.D_E_L_E_T_ = ''"

		MEMOWRITE("CALCVOL.sql",CQUERY)

		TCQUERY CQUERY NEW ALIAS "VOL"
		DBSELECTAREA("VOL")
		COUNT TO NREG

		IF NREG > 0

			DBGOTOP()
			NVOL := VOL->VOLUME

		/*
		|---------------------------------------------------------------------------------
		|	CASO A SOMA RETORNE CASAS DECIMAIS SERA ARREDONDADO O VOLUME
		|---------------------------------------------------------------------------------
		*/
			IF (NVOL - INT(NVOL)) > 0

				NVOL := INT(NVOL) + 1

			ENDIF

			ARET[1] += NVOL
			ARET[2]	+= VOL->PBRUTO
			ARET[3]	+= VOL->PLIQ

		ENDIF

		DBSELECTAREA("VOL")
		DBCLOSEAREA()

	NEXT I

	IF LEN(ARET) = 0

		ARET := {0,0,0}

	ENDIF

	RESTAREA(AAREA)

RETURN(ARET)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAPERG  บAutor  ณEdson Hornberger    บ Data ณ  05/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Funcao para gerar Perguntas (filtro) no SX1.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Funcao de Apoio                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION GERAPERG(CPERG,APERG)

	LOCAL CORDEM 	:= ""
	LOCAL X			:= 0

	DBSELECTAREA("SX1")
	DBSETORDER(1)

	PROCREGUA(LEN(APERG))

	FOR X := 1 TO LEN(APERG)

		INCPROC(OEMTOANSI("Atualizando param๊tros..."))

		CORDEM := STRZERO(X,2)

		IF DBSEEK(CPERG+CORDEM,.T.)

			BEGIN TRANSACTION

				IF RECLOCK("SX1",.F.)
					X1_GRUPO		:= CPERG
					X1_ORDEM		:= CORDEM
					X1_PERGUNT		:= APERG[X,01]
					X1_PERSPA		:= APERG[X,01]
					X1_PERENG		:= APERG[X,01]
					X1_VARIAVL		:= "MV_CH" + ALLTRIM(STR(X))
					X1_TIPO			:= APERG[X,02]
					X1_TAMANHO		:= APERG[X,03]
					X1_DECIMAL		:= APERG[X,04]
					X1_GSC			:= APERG[X,05]
					X1_VALID		:= APERG[X,06]
					X1_VAR01		:= "MV_CH" + ALLTRIM(STR(X))
					X1_DEF01		:= APERG[X,07]
					X1_DEF02		:= APERG[X,08]
					X1_DEF03		:= APERG[X,09]
					X1_DEF04		:= APERG[X,10]
					X1_DEF05		:= APERG[X,11]
					X1_F3			:= APERG[X,12]
					MSUNLOCK()
					DBCOMMIT()

				ELSE

					DISARMTRANSACTION()

				ENDIF

			END TRANSACTION

		ELSE

			BEGIN TRANSACTION

				IF RECLOCK("SX1",.T.)

					X1_GRUPO		:= CPERG
					X1_ORDEM		:= CORDEM
					X1_PERGUNT		:= APERG[X,01]
					X1_PERSPA		:= APERG[X,01]
					X1_PERENG		:= APERG[X,01]
					X1_VARIAVL		:= "MV_CH" + ALLTRIM(STR(X))
					X1_TIPO			:= APERG[X,02]
					X1_TAMANHO		:= APERG[X,03]
					X1_DECIMAL		:= APERG[X,04]
					X1_GSC			:= APERG[X,05]
					X1_VALID		:= APERG[X,06]
					X1_VAR01		:= "MV_CH" + ALLTRIM(STR(X))
					X1_DEF01		:= APERG[X,07]
					X1_DEF02		:= APERG[X,08]
					X1_DEF03		:= APERG[X,09]
					X1_DEF04		:= APERG[X,10]
					X1_DEF05		:= APERG[X,11]
					X1_F3			:= APERG[X,12]
					MSUNLOCK()
					DBCOMMIT()

				ELSE

					DISARMTRANSACTION()

				ENDIF

			END TRANSACTION

		ENDIF

	NEXT X

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	taiffxfun.prw
=================================================================================
||   Funcao: 	VERGRUPO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||  	FUNCAO PARA VERIFICAR SE CNPJ FAZ PARTE DO GRUPO DE EMPRESAS
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:		17/12/2015
=================================================================================
=================================================================================
*/

USER FUNCTION VERGRUPO(CCNPJ)

	LOCAL LRET 	:= .F.
	LOCAL CQUERY 	:= ""

	CQUERY := "SELECT COUNT(*) AS NREGS FROM SM0_COMPANY WHERE M0_CGC = '" + CCNPJ + "'"
	IF SELECT("CGC") > 0

		DBSELECTAREA("CGC")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "CGC"
	DBSELECTAREA("CGC")

	IF CGC->NREGS > 0
		LRET := .T.
	ENDIF

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	taiffxfun.prw
=================================================================================
||   Funcao: 	TFCCUSTO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||  	FUNCAO PARA VALIDAR O USO DO CENTRO DE CUSTO NA EMPRESA 
|| 
=================================================================================
=================================================================================
||   Autor:	Carlos Torres
||   Data:		04/03/2016
=================================================================================
=================================================================================
*/
USER FUNCTION TFCCUSTO(cTFempresa,cTFfilial,cTFcusto)
	Local lRetorno		:= .T.
	Local cParFil		:= ""
	Local cAliasCTT	:= CTT->(GetArea())

/*
1 - 0101
2 - 0102
3 - 0301
4 - 0302
5 - 0303
6 - 0401
7 - 0402
*/
	If cTFfilial == "01" .And. cTFempresa == "01"
		cParFil := "1"
	ElseIf cTFfilial == "02" .And. cTFempresa == "01"
		cParFil := "2"
	ElseIf cTFfilial == "01" .And. cTFempresa == "03"
		cParFil := "3"
	ElseIf cTFfilial == "02" .And. cTFempresa == "03"
		cParFil := "4"
	ElseIf cTFfilial == "03" .And. cTFempresa == "03"
		cParFil := "5"
	ElseIf cTFfilial == "01" .And. cTFempresa == "04"
		cParFil := "6"
	ElseIf cTFfilial == "02" .And. cTFempresa == "04"
		cParFil := "7"
	ElseIf cTFfilial == "01" .And. cTFempresa == "02"
		cParFil := "8"
	ElseIf cTFfilial == "02" .And. cTFempresa == "02"
		cParFil := "9"
	ElseIf cTFfilial == "03" .And. cTFempresa == "04"
		cParFil := "A"
	EndIf

	If !Empty(cTFcusto) .AND. CTT->(FIELDPOS("CTT_FILUSO")) != 0
		CTT->(dbSetOrder(1))
		CTT->(dbSeek(xFilial("CTT")+cTFcusto))
		If AT( cParFil , CTT->CTT_FILUSO ) = 0
			MsgAlert("Centro de custo " + Alltrim(cTFcusto) + " nใo permite uso nesta empresa")
			lRetorno := .F.
		EndIf
	EndIf

	RestArea(cAliasCTT)
Return (lRetorno)

/*
APRESENTA O NOME DO VENDEDOR NO INICIALIZADOR DO BROWSE C5_NOMVEN
COM A FUNวรO POSICIONE... OCORRE ERRO AO IMPORTAR AUTOMATICAMENTE VIA SCHEDULE
*/
User Function TFC5NOMVEN
	Local cNomeVendedor := ""
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek( XFILIAL("SA3") + SC5->C5_VEND1))
		cNomeVendedor := SA3->A3_NOME
	EndIf
Return (cNomeVendedor)



/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?EnvMail   ?Autor  ?Microsiga           ? Data ?  07/23/08   ???
????????????????????????????????????????????????????????????????????????????
???Desc.     ?                                                            ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? AP                                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

//?????????????????????????????????????
//?cVar1 - conta de email no campo FROM?
//?cVar2 - conta de email no campo TO  ?
//?cVar3                               ?
//?cVar4 - Mensagem do corpo do email  ?
//?cVar5 - titullo do email            ?
//?cVar6 - endereco do anexo           ?
//??????????????????????????????????????

User Function 2EnvMail(cVar1,cVar2,cVar3,cVar4,cVar5,cVar6)

	Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
	Local cTitulo1	:= Rtrim(cVar5)
	Local cEmailTo	:= Rtrim(cVar2)
	Local cEmailBcc:= ""
	Local cError   := ""
	Local lRelauth := GetNewPar("MV_RELAUTH",.F.)		// Parametro que indica se existe autenticacao no e-mail
	Local lRet	   := .F.
	Local cFrom	   := GetMV("MV_RELFROM")
	Local cConta   := GetMV("MV_RELACNT")
	Local cSenhaa  := GetMV("MV_RELPSW")
	Local cMensagem	:= cVar4
	Local cAttachment := cVar6

	CONNECT SMTP;
	SERVER 	 GetMV("MV_RELSERV") ; 	// Nome do servidor de e-mail
	ACCOUNT  cConta; 				// Nome da conta a ser usada no e-mail
	PASSWORD cSenhaa ; 				// Senha
	RESULT   lResult             	// Resultado da tentativa de conex?o

	If lResult
	
		If lRelauth
			lRet := Mailauth(cConta,cSenhaa)
		Else
			lRet := .T.
		Endif
	
		If lRet
			SEND MAIL FROM 	cFrom ;
				TO 				cEmailTo;
				BCC     		cEmailBcc;
				SUBJECT 		cTitulo1;
				BODY 			cMensagem;
				ATTACHMENT cAttachment;
				RESULT lResult
		
			If !lResult
				Conout("Erro no envio do email"+FunName())
				GET MAIL ERROR cError
				Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)
			Endif
		EndIf
		DISCONNECT SMTP SERVER
	Else

		Conout("Erro de conexao SMPT"+FunName())
		GET MAIL ERROR cError
		Help(" ",1,"Atencao",,cError,4,5)

	Endif

Return(lResult)


User Function ConVDecHora(nCent)
	nHora	:= Int(nCent)
	nMinuto := (nCent-nHora)*(.6)*100
	nSec    := nMinuto*60
	cString := StrZero(nHora,Iif(nHora>99,3,2))+StrZero(nMinuto,2)+StrZero(Int(Mod(nSec,60)),2,0)

	cHor := Transform(cString,Iif(nHora>99,'@R 999:99:99','@R 99:99:99'))
Return(cHor)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณFRVlCompFil บ Autor ณ Marcio Menon       บ Data ณ 24/03/08  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescricao ณFuncao que retorna o valor da compensacao de um tํtulo que  บฑฑ
ฑฑบ          ณque foi compensado em filiais diferentes.				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณEXPC1 - Tipo da carteira:                                   บฑฑ
ฑฑบ          ณ        "R" - Contas a Receber                              บฑฑ
ฑฑบ          ณ        "P" - Contas a Pagar                                บฑฑ
ฑฑบ          ณEXPC2 - Prefixo do titulo principal                         บฑฑ
ฑฑบ          ณEXPC3 - Numero do titulo principal                          บฑฑ
ฑฑบ          ณEXPC4 - Parcela do titulo principal                         บฑฑ
ฑฑบ          ณEXPC5 - Tipo do titulo principal                            บฑฑ
ฑฑบ          ณEXPC6 - Fornecedor do titulo principal                      บฑฑ
ฑฑบ          ณEXPC7 - Loja do titulo principal                            บฑฑ
ฑฑบ          ณEXPC8 - Tipo de data a ser utilizada para compor o saldo do บฑฑ
ฑฑบ          ณ        0 = Data Da Baixa (E5_DATA)                         บฑฑ
ฑฑบ          ณ        1 = Data de Disponibilidade (E5_DTDISPO)            บฑฑ
ฑฑบ          ณ        2 = Data de Contabilida็ใo (E5_DTDIGIT)             บฑฑ
ฑฑบ          ณEXPA9  - Vetor com todas as filiais da empresa              บฑฑ
ฑฑบ          ณEXPC10 - Vetor com as filiais diferentes da filial atual    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณFINR130 - Relatorio de Titulos a Receber                    บฑฑ
ฑฑบ          ณFINR150 - Relatorio de Titulos a Pagar                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TFFRVlCompFil(cRecPag,cPrefixo,cNumero,cParcela,cTipo,cCliFor,cLoja,nTipoData,aFiliais,cFilQry,lAS400)
LOCAL aArea     := GetArea()
LOCAL nValor    := 0
LOCAL cTipoData := "0"
LOCAL nX        := 0
LOCAL nRegEmp	:= 0
LOCAL cEmpAnt	:= SM0->M0_CODIGO
LOCAL cFilSE5	:= xFilial("SE5")
LOCAL cTipoAdt	:= ""
LOCAL cFilAtu   := ""
Local cCpoQry   := ""
Local cWhere    := ""
LOCAL nLenFil	:= 0
LOCAL nInc		:= 0
Local aSM0		:= {}

#IFDEF TOP
	Default cFilQry	:= ""
	Default lAS400	:= (Upper(TcSrvType()) != "AS/400" .And. Upper(TcSrvType()) != "ISERIES")
#ENDIF

Default aFiliais := {}

nLenFil	:= Len( aFiliais )

// tratativa para a leitura de aFiliais. Usados nos relatorios do Financeiro
If nLenFil <= 1
	Return nValor
EndIf

nTipoData  := Iif( nTipoData == Nil, 0, nTipoData )

//Tipos de Data (cTipoData)
// 0 = Data Da Baixa (E5_DATA)
// 1 = Data de Disponibilidade (E5_DTDISPO)
// 2 = Data de Contabilida็ใo (E5_DTDIGIT)
If nTipoData == 1
	cTipoData := "0"
ElseIf nTipodata == 2
	cTipoData := "1"
Else
	cTipoData := "2"
Endif
  
#IFDEF	TOP
	If lAS400                  
   		For nX := 1 To nLenFil
    		If aFiliais[nX] != cFilSE5
				If !Empty( cFilQry ) 
					cFilQry += ", "
				Endif
				cFilQry += "'" + aFiliais[nX] + "'"
			EndIf
		Next nX

		cQuery  := "SELECT "
			
		cCpoQry := "R_E_C_N_O_ "
		cCpoQry += "FROM " +RetSqlName("SE5") + " SE5 "
			
		cWhere  := "WHERE "
		cWhere  += "SE5.E5_FILIAL IN ( " + cFilQry  + " ) AND "
		cWhere  += "SE5.E5_PREFIXO = '"  + cPrefixo + "' AND "
		cWhere  += "SE5.E5_NUMERO = '"   + cNumero  + "' AND "
		cWhere  += "SE5.E5_PARCELA = '"  + cParcela + "' AND "
		cWhere  += "SE5.E5_TIPO = '"     + cTipo    + "' AND " 
		cWhere  += "SE5.E5_CLIFOR = '"   + cCliFor  + "' AND "
		cWhere  += "SE5.E5_LOJA = '"     + cLoja    + "' AND "
		cWhere  += "SE5.D_E_L_E_T_ = ' ' "

		cQuery  += cCpoQry
		cQuery  += cWhere

		cQuery := ChangeQuery( cQuery )
						
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )
		                       
		// Se existir compensacao em outras filiais, realiza query completa (performance)
		If TRB->( !EoF() )

			If cRecPag == "R"
	                  
  				dbSelectArea( "SE1" )
                           
				TRB->( dbCloseArea() )

				cQuery	:= "SELECT "			

				cCpoQry	:= "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_FILORIG, "
				cCpoQry	+= "SE5.E5_TIPO, SE5.E5_VALOR, SE5.E5_MOTBX, SE5.E5_RECPAG, "

				If cTipoData == "0"
					cCpoQry += "SE5.E5_DATA " 
				ElseIf cTipoData == "1"
					cCpoQry += "SE5.E5_DTDISPO "
				Else	
					cCpoQry += "SE5.E5_DTDIGIT " 
				Endif

				cCpoQry  += "FROM " + RetSqlName("SE5") + " SE5, " + RetSqlName("SE1") + " SE1 "

				cWhere  += "AND "
				cWhere  += "SE1.E1_FILIAL = '"  + xFilial("SE1") + "' AND "
				cWhere  += "SE1.E1_PREFIXO = SE5.E5_PREFIXO AND "
				cWhere  += "SE1.E1_NUM = SE5.E5_NUMERO AND "    
				cWhere  += "SE1.E1_PARCELA = SE5.E5_PARCELA AND "
				cWhere  += "SE1.E1_TIPO = SE5.E5_TIPO AND "
				cWhere  += "SE1.E1_CLIENTE = SE5.E5_CLIFOR AND "
				cWhere  += "SE1.E1_LOJA = SE5.E5_LOJA AND "
				cWhere  += "SE1.D_E_L_E_T_ = ' ' "

				cQuery  += cCpoQry
				cQuery  += cWhere

				cQuery := ChangeQuery( cQuery )

				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )						
				TCSetField( "TRB", "E5_VALOR", "N", TamSX3("E5_VALOR")[1], TamSX3("E5_VALOR")[2] )

				If cTipoData == "0"
					TCSetField( "TRB", "E5_DATA", "D" )
				ElseIf cTipoData == "1"
					TCSetField( "TRB", "E5_DTDISPO", "D" )
				Else	
					TCSetField( "TRB", "E5_DTDIGIT", "D" )
				Endif			
				
				Do While TRB->( !Eof() )
		        
					If TRB->E5_MOTBX == "CMP" .And. TRB->E5_FILORIG == cFilSE5
	                              
						If cTipoData == "0"
							lOk := ( DtoS(TRB->E5_DATA) <= DtoS(dDataBase) )
						ElseIf cTipoData == "1"
							lOk := ( DtoS(TRB->E5_DTDISPO) <= DtoS(dDataBase) )
						Else
							lOk := ( DtoS(TRB->E5_DTDIGIT) <= DtoS(dDataBase) )
						EndIf
						
						If lOk
    						If TRB->E5_RECPAG == cRecPag
								If TRB->E5_TIPO $ MVRECANT+"|"+MV_CRNEG
									If TRB->E5_TIPODOC $ "BA|VL"
										nValor += TRB->E5_VALOR
									EndIf
								Else 
									If TRB->E5_TIPODOC $ "CP"
										nValor += TRB->E5_VALOR
									EndIf			
								EndIf                        
							EndIf							
							If TRB->E5_RECPAG == "P" .And. TRB->E5_TIPODOC == "ES"
								nValor -= TRB->E5_VALOR
							EndIf
						EndIf
					EndIf
					TRB->(dbSkip())
				EndDo
			ElseIf cRecPag == "P"

				dbSelectArea( "SE2" )
                           
				TRB->( dbCloseArea() )
    			                       
				cQuery	:= "SELECT "			

				cCpoQry	:= "SE5.E5_FILIAL, SE5.E5_TIPODOC, SE5.E5_FILORIG, "
				cCpoQry	+= "SE5.E5_TIPO, SE5.E5_VALOR, SE5.E5_MOTBX, SE5.E5_RECPAG, "

				If cTipoData == "0"
					cCpoQry += "SE5.E5_DATA " 
				ElseIf cTipoData == "1"
					cCpoQry += "SE5.E5_DTDISPO "
				Else	
					cCpoQry += "SE5.E5_DTDIGIT " 
				Endif

				cCpoQry  += "FROM " + RetSqlName("SE5") + " SE5, " + RetSqlName("SE2") + " SE2 "
				                               
				cWhere  += "AND "
				cWhere  += "SE2.E2_FILIAL = '"  + xFilial("SE2") + "' AND "
				cWhere  += "SE2.E2_PREFIXO = SE5.E5_PREFIXO AND "
				cWhere  += "SE2.E2_NUM = SE5.E5_NUMERO AND "    
				cWhere  += "SE2.E2_PARCELA = SE5.E5_PARCELA AND "
				cWhere  += "SE2.E2_TIPO = SE5.E5_TIPO AND "
				cWhere  += "SE2.E2_FORNECE = SE5.E5_CLIFOR AND "
				cWhere  += "SE2.E2_LOJA = SE5.E5_LOJA AND "
				cWhere  += "SE2.D_E_L_E_T_ = ' ' "

				cQuery  += cCpoQry
				cQuery  += cWhere
				cQuery := ChangeQuery( cQuery )

				dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB", .T., .T. )						

				TCSetField( "TRB", "E5_VALOR", "N", TamSX3("E5_VALOR")[1], TamSX3("E5_VALOR")[2] )

				If cTipoData == "0"
					TCSetField( "TRB", "E5_DATA", "D" )
				ElseIf cTipoData == "1"
					TCSetField( "TRB", "E5_DTDISPO", "D" )
				Else	
					TCSetField( "TRB", "E5_DTDIGIT", "D" )
				Endif			
				
				Do While TRB->( !Eof() )
		        
					If TRB->E5_MOTBX == "CMP" .And. TRB->E5_FILORIG == cFilSE5
	                              
						If cTipoData == "0"
							lOk := ( DtoS(TRB->E5_DATA) <= DtoS(dDataBase) )
						ElseIf cTipoData == "1"
							lOk := ( DtoS(TRB->E5_DTDISPO) <= DtoS(dDataBase) )
						Else
							lOk := ( DtoS(TRB->E5_DTDIGIT) <= DtoS(dDataBase) )
						EndIf
						
						If lOk
    						If TRB->E5_RECPAG == cRecPag
								If TRB->E5_TIPO $ MVPAGANT+"|"+MV_CPNEG
									If TRB->E5_TIPODOC $ "BA|VL"
										nValor += TRB->E5_VALOR
									EndIf
								Else 
									If TRB->E5_TIPODOC $ "CP"
										nValor += TRB->E5_VALOR
									EndIf			
								EndIf                        
							EndIf							
							If TRB->E5_RECPAG == "R" .And. TRB->E5_TIPODOC == "ES"
								nValor -= TRB->E5_VALOR
							EndIf	       
						EndIf
					EndIf
					TRB->(dbSkip())
				EndDo
			EndIf
		EndIf
	Else
#ENDIF
		cAlias  := Iif( cRecPag == "R", "SE1", "SE2" )
		aSM0	:= AdmAbreSM0()
		nRegEmp	:= SM0->(Recno())
		
		dbSelectArea("SM0")
		dbSeek(cEmpAnt,.T.)
		
		For nX := 1 to Len(aFiliais)

		   	cFilAtu := aFiliais[nX]

			For nInc := 1 To Len( aSM0 )
				If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] == cFilAtu
					cFilAnt := aSM0[nInc][2]

					dbSelectArea("SE5")
					dbSetOrder(7)
					// Soh processa movimentos diferentes da filial corrente. A a SaldoTit() executada antes da 
					// chamada desta funcao, jah processa a filial corrente.
					If cFilSE5 <> cFilAtu
						SE5->(MsSeek(cFilAtu+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja))		
						While SE5->(!Eof()) .And. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) ==;
								cFilAtu+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja
								
							If SE5->E5_MOTBX != "CMP" .And. SE5->E5_RECPAG != cRecPag
								SE5->(dbSkip())
								Loop
							Endif	
							//Defino qual o tipo de data a ser utilizado para compor o saldo do titulo
							If cTipoData == "0"
								dDtFina := SE5->E5_DATA
							ElseIf cTipoData == "1"
								dDtFina := SE5->E5_DTDISPO
							Else	
								dDtFina := SE5->E5_DTDIGIT
							Endif			
							If dDtFina > dDataBase
								SE5->(dbSkip())
								Loop
				            EndIf
				            If SE5->E5_FILORIG == cFilSE5
								cTipoAdt := Iif( cRecPag == "R", MVRECANT+"|"+MV_CRNEG, MVPAGANT+"|"+MV_CPNEG )			            
								If  SE5->E5_RECPAG == cRecPag 
									If SE5->E5_TIPO $ cTipoAdt 
										If SE5->E5_TIPODOC $ "BA|VL"
											nValor += SE5->E5_VALOR
										EndIf	
									Else
										If SE5->E5_TIPODOC $ "CP"
											nValor += SE5->E5_VALOR
										EndIf	
									EndIf
								EndIf	
								If cRecPag == "P"		// Titulos a Pagar
									If SE5->E5_RECPAG == "R" .And. SE5->E5_TIPODOC == "ES"
										nValor -= SE5->E5_VALOR
									EndIf	
								ElseIf cRecPag == "R"	// Titulos a Receber
									If SE5->E5_RECPAG == "P" .And. SE5->E5_TIPODOC == "ES"
										nValor -= SE5->E5_VALOR							
									EndIf	
								EndIf
				            Endif                 			
							SE5->(dbSkip())
				        End
				   	EndIf			
				EndIf
			Next
		Next
		dbSelectArea("SM0")
		SM0->(dbGoTo(nRegEmp))
		cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
  
#IFDEF TOP
	Endif
	If lAS400
		dbSelectArea("TRB")
		dbCloseArea()
	Endif		
#ENDIF
	
RestArea(aArea)   
Return nValor



User Function AtuSep()
	Local Kx	:= 0

	nOnline := 0
	nLocais := 0
	nFinal 	:= 0
	nPend 	:= 0
	nPFinal	:= 0
	nOnline	:= 0
	nQOper 	:= 0
	cTempo 	:= ""
	cMLocal	:= ""
	aOper	:= {}
	aEnder	:= {}
	aProd	:={}


	cQuery := " SELECT CB7_CODOPE , CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_STATUS ,"
	cQuery += " (SELECT TOP 1 CASE WHEN ((SUBSTRING(CB8_LCALIZ,9,1) > '2' AND LEFT(CB8_LCALIZ,2)= 'PP')OR LEFT(CB8_LCALIZ,2)= 'PI') THEN
	cQuery += " 'EM'"
	cQuery += " ELSE"
	cQuery += " LEFT(CB8_LCALIZ,2) "
	cQuery += " END  FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' ORDER BY CB8_LCALIZ DESC) SETOR,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LOCAIS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LOCAIS_FEITOS,"
	cQuery += " CB7_DTINIS  ,"
	cQuery += " CB7_DTFIMS  ,"
	cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
	cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL AND CB1_CODOPE = CB7_CODOPE "
	cQuery += " WHERE CB7__PRESE = '"+cAcompOnda+"' "
	cQuery += " and CB7_PEDIDO = ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LOCAIS DESC"

	MemoWrite("WMSAT00215.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7_DTINIS','D')
	TcSetField('TRBAC','CB7_DTFIMS','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LOCAIS
		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LOCAIS,0,TRBAC->PECAS, TRBAC->LOCAIS_FEITOS, TRBAC->SETOR, 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LOCAIS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LOCAIS_FEITOS
		EndIf

		//ARMAZENA ESTATISTICAS DA ONDA
		nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
		If nAscan == 0
			//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
			aAdd(aEnder,{TRBAC->SETOR,TRBAC->LOCAIS,TRBAC->LOCAIS_FEITOS,TRBAC->PECAS,0,0,0})
		Else
			aEnder[nAscan][2] += TRBAC->LOCAIS
			aEnder[nAscan][3] += TRBAC->LOCAIS_FEITOS
			aEnder[nAscan][4] += TRBAC->PECAS
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7_DTINIS
	dDtFim := TRBAC->CB7_DTFIMS

	While !Eof()
		IncProc("Gerando dados")
		nLcPorc 	:= (TRBAC->LOCAIS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LOCAIS_FEITOS/TRBAC->LOCAIS)*100
		cCor		:= Iif(TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0,"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0
			nFinal+= TRBAC->LOCAIS_FEITOS
		Else
			nPend+= TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametrosณ ExpD1 - Data Inicial
		ณ ExpN1 - Hor rio Inicial
		ณ ExpD2 - Data Final
		ณ ExpN2 - Hor rio Final
		*/
		If TRBAC->HR_INI # "  :  "
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7_DTINIS
				dDtIni := TRBAC->CB7_DTINIS
			EndIf
			If dDtFim < TRBAC->CB7_DTFIMS
				dDtFim := TRBAC->CB7_DTFIMS
			EndIf
			nDifTempo	:= A680Tempo( TRBAC->CB7_DTINIS,TRBAC->HR_INI,TRBAC->CB7_DTFIMS,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"12:00",TRBAC->CB7_DTFIMS,"13:00" )
				nDifTempo -= nTemp24
			EndIf

			//NAO CONTA PERIODO DA NOITE
			If TRBAC->CB7_DTINIS #TRBAC->CB7_DTFIMS
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"22:00",TRBAC->CB7_DTFIMS,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			nTempo+=nDifTempo

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			//ARMAZENA ESTATISTICAS DA ONDA
			nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
			If nAscan > 0
				//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO
				aEnder[nAscan][5] += nDifTempo
			EndIf

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo:= U_ConVDecHora(nDifTempo)
		Else
			cDifTempo	:= '00:00'
		EndIf
		nEndMin := nDifTempo/TRBAC->LOCAIS
		cEndMin:= U_ConVDecHora(nEndMin)

		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS > 0 .And. TRBAC->CB7_STATUS <> '9' ) .Or. (cFiltro == "Finalizado" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0 .And.  TRBAC->CB7_STATUS = '9')
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),TRBAC->CB7_CODOPE,Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME),TRBAC->CB7_ORDSEP, Iif(TRBAC->CB7_STATPA == "1","S","N"), TRBAC->SETOR, TRBAC->PECAS, TRBAC->LOCAIS, Transform(nLcPorc,"@E 999.99"),TRBAC->LOCAIS_FEITOS,Transform(nLcEfPorc,"@E 999.99"),DTOC(TRBAC->CB7_DTINIS), DTOC(TRBAC->CB7_DTFIMS), TRBAC->HR_INI, TRBAC->HR_FIM,cDifTempo,cEndMin,''})
		EndIf


		dbSelectArea("TRBAC")
		dbSkip()
	End
	//nTempo	:= A680Tempo( dDtIni,cHrIni,dDtFim,cHrFim )

	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= nTempo/nFinal
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo:= U_ConVDecHora(nTempo)
	cMLocal:= U_ConVDecHora(nMLocal)


	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd

		nAscan := Ascan(aEnder, {|e| e[1] == aOper[Kx][7]})
		aOper[Kx][9]+= (aOper[Kx][3]/aEnder[nAscan][2])*100
	Next

	For kx:=1 To Len(aEnder)
		//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
		aEnder[Kx][6] += aEnder[Kx][5]/aEnder[Kx][2]
		aEnder[Kx][7] += (aEnder[Kx][2]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //MINUTOS ENDERECOS
		EndIf
	Next



	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())


	If nTamAcolSep == 0
		nTamAcolSep := Len(aAcomp)
	ElseIf nTamAcolSep <> Len(aAcomp)
		While nTamAcolSep <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{'','','Z','','','',0,0,0,0,0,CTOD(''),CTOD(''),"","",0,0})
		End
	EndIf

	If Len(aAcomp) == 0
		MsgInfo("Nใo existem mais enderecos pendentes!")
		Return
	EndIf


	If cOrdem == "Enderecos"
		ASort(aAcomp,,,{|x,y|x[8]+x[14]>y[8]+y[14]})
	ElseIf cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	EndIf

Return


User Function ACOSEPPROD(cNomOper)
	Local oDlgOper
	Local a2Oper := {}
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Local Kx		:= 0

	For Kx:=1 To Len(aOper)
		If aOper[Kx][2] == cNomOper
			aAdd(a2Oper,{aOper[Kx][1],aOper[Kx][2],aOper[Kx][3],aOper[Kx][4],aOper[Kx][5],aOper[Kx][6],aOper[Kx][7],aOper[Kx][8],aOper[Kx][9]})
		EndIf
	Next

	//TOTALIZACAO OPERADORES
	ASort(a2Oper,,,{|x,y|x[7]>y[7]})
	@050,005 TO 300,550  DIALOG oDlgOper TITLE "Dados Operador x Separacao "

	//a2Oper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO

	aOP2TitCampos := {OemToAnsi("Codigo"),OemToAnsi("Nome"),OemToAnsi("Enderecos"),OemToAnsi("End.Feitos"),OemToAnsi("Pecas"),OemToAnsi("Tempo"),OemToAnsi("Setor"),OemToAnsi("Min/End"),OemToAnsi("Produt."),''}

	cOP2Line := "{a2Oper[oOP2ListBox:nAT][1],a2Oper[oOP2ListBox:nAT][2],Transform(a2Oper[oOP2ListBox:nAT][3],'@E 99999'),Transform(a2Oper[oOP2ListBox:nAT][6],'@E 99999'),a2Oper[oOP2ListBox:nAT][5],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][4]),"
	cOP2Line += " a2Oper[oOP2ListBox:nAT][7],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][8]),Transform(a2Oper[oOP2ListBox:nAT][9],'@E 999.99'),}"

	aOP2Coord := {3,10,4,4,9,4,2,4,4,1}

	bOP2Line := &( "{ || " + cOP2Line + " }" )
	oOP2ListBox := TWBrowse():New( 10,4,270,90,,aOP2TitCampos,aOP2Coord,oDlgOper,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oOP2ListBox:SetArray(a2Oper)
	oOP2ListBox:bLine := bOP2Line

	@ 100,200 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOper:End() PIXEL OF oDlgOper

	ACTIVATE DIALOG oDlgOper CENTERED


Return



User Function Pausa(cPOrdSep)

	cQuery := " UPDATE "+RetSqlName("CB7")+" SET CB7_STATPA = '1' WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7_ORDSEP = '"+cPOrdSep+"' AND D_E_L_E_T_ <> '*'"

	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualiza็ใo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf

	MsgInfo("Em Pausa!","WMSAT002")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMAT02EXC บAutor  ณMicrosiga           บ Data ณ  02/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXPORTA DADOS SEPARACAO PARA EXCEL                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WMAT02EXC()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local cLin 
	local cDirDocs  := MsDocPath()
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "SEPARACAO"+cAcompOnda+".CSV"
	Local oExcelApp
	Local nTotEnd := 0
	Local Kx		:= 0	
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"


	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("Nใo foi possํvel abrir o arquivo CSV pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o arquivo texto                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	//CABECALOS ESTATISTICAS ENDERECOS
	cLin := "DISTRIBUICAO ENDERECOS"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin    :=  OemToAnsi("Setor")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("% End.")
	cLin += cEOL //ULTIMO ITEM

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aEnder))

	For Kx:=1 To Len(aEnder)
		IncProc("Aguarde......Montando Planilha enderecos!")
		nTotEnd += aEnder[Kx][2]
		cLin    := ''
		cLin    += aEnder[Kx][1]+';'+Transform(aEnder[Kx][2],'@E 99999')+';'+Transform(aEnder[Kx][3],'@E 99999')+';'+Transform(aEnder[Kx][4],'@E 99999')+';'+U_ConVDecHora(aEnder[Kx][5])+';'+U_ConVDecHora(aEnder[Kx][6])+';'+Transform(aEnder[Kx][7],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//PULA LINHA
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR X SETOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR X SETOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Setor")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("Produt.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aOper))
	//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
	ASort(aOper,,,{|x,y|x[7]+StrZero(x[9],4)>y[7]+StrZero(y[9],4)})

	For Kx:=1 To Len(aOper)
		IncProc("Aguarde......Montando Planilha Operadores!")
		cLin    := ''
		cLin    += aOper[Kx][2]+';'+Transform(aOper[Kx][3],'@E 99999')+';'+Transform(aOper[Kx][6],'@E 99999')+';'+Transform(aOper[Kx][5],'@E 99999')+';'+U_ConVDecHora(aOper[Kx][4])+';'
		cLin    += aOper[Kx][7]+';'+U_ConVDecHora(aOper[Kx][8])+';'+Transform(aOper[Kx][9],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	cLin := ""
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("Produt.")+';'+OemToAnsi("Tempo")+";"+OemToAnsi("Min/End.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aProd))
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
	ASort(aProd,,,{|x,y|x[5]>y[5]})

	For Kx:=1 To Len(aProd)
		IncProc("Aguarde......Montando Planilha Produtividade!")
		cLin    := ''
		cLin    += aProd[Kx][1]+';'+Transform(aProd[Kx][2],'@E 99999')+';'+Transform((aProd[Kx][2]/aProd[Kx][3])*100,'@E 999.99')+';'+U_ConVDecHora(aProd[Kx][4])+';'+U_ConVDecHora(aProd[Kx][4]/aProd[Kx][2])

		//PULA LINHA
		cLin += cEOL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
		//ณ linha montada.                                                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next


	fClose(nHdl)

	CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cPath+cArquivo,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuPre    บAutor  ณMicrosiga           บ Data ณ  03/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza o pre checkout                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuPre()
	Local nMinEnd 	:= 0
	Local aOper		:= {} 
	Local Kx		:= 0

	nLocais	:= 0
	nFinal	:= 0
	nPend	:= 0
	nPFinal	:= 0
	nQOper	:= 0
	nTempo	:= 0
	nMLocal	:= 0
	nOnline := 0
	nDifTempo := 0
	aOper := {}
	aAcomp	:={}
	aProd	:= {}
	nPedFalta := 0
	cTempo	:= ""
	cMLocal	:= ""


	cQuery := " SELECT "
	If cNOpc == "P"
		cQuery += " CB7__CODOP AS CB7_CODOPE, "
	Else
		cQuery += " CB7_CODOPE , "
	EndIf
	cQuery += " CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_PEDIDO, CB7_NOTA, CB7__CHECK ,CB7_STATUS,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LINHAS,"
	If cNOpc == "P"
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8__SALDO = 0) LINHAS_FEITAS,"
		cQuery += " CB7__DTINI  ,"
		cQuery += " CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7__HRFIM      ,1,2)+':'+SUBSTRING(CB7__HRFIM     ,3,2) HR_FIM"
	Else
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LINHAS_FEITAS,"
		cQuery += " CB7_DTINIS CB7__DTINI  ,"
		cQuery += " CB7_DTFIMS CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	EndIf
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL "
	If cNOpc == "P"
		cQuery += " AND CB1_CODOPE = CB7__CODOP "
	Else
		cQuery += " AND CB1_CODOPE = CB7_CODOPE "
	EndIf
	cQuery += " WHERE CB7__PRESE = '"+cNOnda+"' "
	cQuery += " and CB7_PEDIDO <> ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LINHAS DESC"

	MemoWrite("WMSAT00216.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7__DTINI','D')
	TcSetField('TRBAC','CB7__DTFIM','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LINHAS

		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE })
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LINHAS,0,TRBAC->PECAS, TRBAC->LINHAS_FEITAS, '', 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LINHAS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LINHAS_FEITAS
		EndIf

		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7__DTINI
	dDtFim := TRBAC->CB7__DTFIM

	While !Eof()
		IncProc("Gerando dados")

		nLcPorc 	:= (TRBAC->LINHAS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LINHAS_FEITAS/TRBAC->LINHAS)*100
		cCor		:= Iif(TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0 .Or. (TRBAC->CB7__CHECK == "2"  .And. cNOpc == "P"),"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0
			nFinal+= TRBAC->LINHAS_FEITAS
		Else
			nPend+= TRBAC->LINHAS-TRBAC->LINHAS_FEITAS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametrosณ ExpD1 - Data Inicial
		ณ ExpN1 - Hor rio Inicial
		ณ ExpD2 - Data Final
		ณ ExpN2 - Hor rio Final
		*/

		If !(Len(AllTrim(TRBAC->HR_INI)) < 5 .Or. Len(AllTrim(TRBAC->HR_FIM)) < 5) .And. !Empty(TRBAC->CB7__DTINI) .And. !Empty(TRBAC->CB7__DTFIM)
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7__DTINI
				dDtIni := TRBAC->CB7__DTINI
			EndIf
			If dDtFim < TRBAC->CB7__DTFIM
				dDtFim := TRBAC->CB7__DTFIM
			EndIf

			nDifTempo	:= A680Tempo( TRBAC->CB7__DTINI,TRBAC->HR_INI,TRBAC->CB7__DTFIM,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"12:00",TRBAC->CB7__DTFIM,"13:00" )
				nDifTempo -= nTemp24
			EndIf
			//NAO CONTA PERIODO NOTURNO
			If TRBAC->CB7__DTINI #TRBAC->CB7__DTFIM
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"22:00",TRBAC->CB7__DTFIM,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			nTempo+=nDifTempo

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo := U_ConVDecHora(nDifTempo)

		Else
			nDifTempo := 0
			cDifTempo := "00:00"
		EndIf

		nEndMin := nDifTempo/TRBAC->LINHAS
		cEndMin := U_ConVDecHora(nEndMin)


		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS > 0 .And. Empty(TRBAC->CB7_NOTA) .And. Iif( cNOpc == "P",TRBAC->CB7__CHECK <> "2",TRBAC->CB7_STATUS <> "9")) .Or. (cFiltro == "Finalizado" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			If cFiltro == "Pendente"  .Or. (cFiltro == "Todos" .And. TRBAC->CB7__CHECK <> "2" .And. Empty(TRBAC->CB7_NOTA))
				nPedFalta ++
			EndIf

			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"999999",TRBAC->CB7_CODOPE),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"FATURADO S/ PRE-CHECKOUT",Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME)),;
			TRBAC->CB7_ORDSEP,;
			Iif(TRBAC->CB7_STATPA == "1","S","N"),;
			'',;
			TRBAC->PECAS,;
			TRBAC->LINHAS,;
			Transform(nLcPorc,"@E 999.99"),;
			TRBAC->LINHAS_FEITAS,;
			Transform(nLcEfPorc,"@E 999.99"),;
			DTOC(TRBAC->CB7__DTINI),;
			DTOC(TRBAC->CB7__DTFIM),;
			TRBAC->HR_INI,;
			TRBAC->HR_FIM,;
			cDifTempo,;
			cEndMin,;
			TRBAC->CB7_PEDIDO,;
			''})
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End

	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LINHAS,04-TEMPO, 05-PECAS, 06-LINHAS FEITAS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE LINHA
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd
		aOper[Kx][9]+= (aOper[Kx][3]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //SOMA MIN/LINHA
		EndIf
	Next



	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= (nTempo/nFinal)
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo  := U_ConVDecHora(nTempo)
	cMLocal := U_ConVDecHora(nMLocal)

	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())

	If nTamAcolPre == 0
		nTamAcolPre := Len(aAcomp)
	ElseIf nTamAcolPre <> Len(aAcomp)
		While nTamAcolPre <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			aAdd(aAcomp,{'','','Z','ZZZZZZ','','',0,0,0,0,0,CTOD(''),CTOD(''),":",":",0,0,''})
		End
	EndIf



	If Len(aAcomp) == 0
		If cNOpc == "P"
			MsgInfo("Nใo existem mais Pre-checkouts pendentes!")
		Else
			MsgInfo("Nใo existem mais Checkouts pendentes!")
		EndIf
		Return
	EndIf

	If cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	ElseIf cOrdem == "Pedido"
		ASort(aAcomp,,,{|x,y|x[18]<y[18]})
	ElseIf cOrdem == "Ordem Sep."
		ASort(aAcomp,,,{|x,y|x[4]<y[4]})
	EndIf

Return



User Function ALWSAT02()
	aAlerta := {}
	//ZERA O CRONOMETRO
	nATimeMin := 0
	nATimeSeg := 0
	cATimeAtu := "00:00"

	//Cursorwait()

	cQuery := " SELECT CB1_CODOPE , CB1_NOME,"
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9'  AND CB7_DTFIMS = '' AND CB7_PEDIDO = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  SEPARACAO,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7__CODOP = CB1_CODOPE  AND CB7__CHECK <> '2' AND CB7_PEDIDO <> '' AND CB7__DTFIM = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  PRECHECKOUT,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9' AND CB7_PEDIDO <> '' AND CB7_DTFIMS = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  CHECKOUT
	cQuery += " FROM "+RetSqlName("CB1")+"  CB1"
	cQuery += " WHERE"
	cQuery += " CB1_FILIAL = '"+cFilAnt+"' AND CB1.D_E_L_E_T_ <> '*' AND CB1_STATUS = '1'"

	MemoWrite("WMST0ALERTA.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAL", .F., .T.)

	Count To nRec

	If nRec == 0
		MsgAlert("Nใo existem operadores trabalhando no momento!","WMSAT002")
		TRBAL->(dbCloseArea())
	EndIf

	dbSelectArea("TRBAL")
	dbGoTop()

	While !Eof()
		If Empty(TRBAL->SEPARACAO) .And. Empty(TRBAL->PRECHECKOUT) .And. Empty(TRBAL->CHECKOUT)
			dbSkip()
			Loop
		EndIf
		//VERIFICA NA SEPARACAO
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->SEPARACAO)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			//01-OPERADOR, 02-NOME, 03-DATA INICIAL, 04- HORA INICIAL, 05-ALERTA, 06 -TEMPO DECORRIDO, 07- OPERACAO
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE) ,"SEPARACAO"})
		EndIf

		//VERIFICA PRE-CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->PRECHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2)
			If !Empty(CB7__DTINI)
				nDifTempo	:= A680Tempo( CB7__DTINI,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)) )
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO") 
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7__DTINI),cHrini,cCor,(nDifTempo/CB7_NUMITE), "PRE-CHECKOUT"})
		EndIf

		//VERIFICA CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->CHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE),"CHECKOUT"})
		EndIf

		dbSelectArea("TRBAL")
		dbSkip()
	End

	If nTamAcolAle == 0
		nTamAcolAle := Len(aAlerta)
	ElseIf nTamAcolAle <> Len(aAlerta)
		While nTamAcolAle <> Len(aAlerta)
			aAdd(aAlerta,{'','Z',CTOD(''),'',"",0,''})
		End
	EndIf

	ASort(aAlerta,,,{|x,y|x[6]>y[6]})
	TRBAL->(dbCloseArea())
	//CursorArrow()

Return



