#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE PULA Chr(13)+Chr(10)
#DEFINE ENTER Chr(13)+Chr(10)

Static lFirst := .T.

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
/////// fun??o descontinuada MGAT001
/*
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
*/

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
Local cChaveCliente := SC5->(C5_CLIENTE+C5_LOJACLI)
If cEmpAnt + cFilAnt = "0302" .AND. SC5->C5_FILDES = '01' .AND. SC5->(FIELDPOS("C5_CLIORI")) != 0 
	If .NOT. Empty(SC5->C5_CLIORI)
		cChaveCliente:=SC5->(C5_CLIORI+C5_LOJORI)
	EndIf
EndIf
Return IF(SC5->C5_TIPO $ "DB",POSICIONE("SA2",1,XFILIAL("SA2")+SC5->(C5_CLIENTE+C5_LOJACLI),"A2_NOME"),POSICIONE("SA1",1,XFILIAL("SA1") + cChaveCliente ,"A1_NOME"))

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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

//Local lRet		:= .T.
LOCAL aEmpUsu	:= {}
LOCAL nCta		:= 0
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
Local nItem := nPos := 0
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
   LOCAL nX 	:= 0
	
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
//LOCAL NPBRUTO	:= 0
//LOCAL NPLIQ		:= 0
//LOCAL CPEDIDOS 	:= "'"
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
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
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
