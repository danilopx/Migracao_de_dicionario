#Include 'Protheus.ch'
#Include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPHRAM01  บAutor  ณDavid - primainfo   บ Data ณ  19/11/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio para conferencia do calculo de assistencia medicaบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPHRAM01()

// Declaracao de Variaveis
Private cPerg    := Padr("GPHRAM01",10)

//Funcao cria perguntas no SX1 - Se nao existir
fPriPerg()

//Abre a janela para o usuแrio fazendo as perguntas
pergunte(cPerg,.T.)

FwMsgRun(,{|oSay| Print()},"Processando","Gerando arquivo...")

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprint     บAutor  ณMicrosiga           บ Data ณ  03/16/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Print()

Local oExcel		:= FWMSEXCEL():New()
Local nI			:= 0
Local _aStruct		:= {}
Local _aRow			:= {}
Local _aAlias		:= {GetNextAlias()}
Local aWSheet		:= {{"Calculo Planos Medico/Odontologico"}} 
Local xz			:= 0

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())           
	
	//TRATAMENTO PARA CAMPOS DO TIPO DATA
	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_NASC/RA_ADMISSA/RA_DEMISSA/NASC"  
			TCSetField(_aAlias[nI],_aStruct[xz,1], "D", 08, 0 )
		Endif
	Next xz
	
	aEval(_aStruct,{|x| oExcel:AddColumn(aWSheet[nI][1],aWSheet[nI][1],If(Empty(cTitulo:=Posicione("SX3",2,x[1],"X3_TITULO")),x[1],cTitulo),2,1)})
	//oExcel:AddColumn("Teste - 1","Titulo de teste 1","Col1",2,1)
	(_aAlias[nI])->(DbGoTop())
	While (_aAlias[nI])->(!Eof())
		_aRow := Array(Len(_aStruct))
		nX := 0
		aEval(_aStruct,{|x| nX++,_aRow[nX] := (_aAlias[nI])->&(x[1])})
		oExcel:AddRow(aWSheet[nI][1],aWSheet[nI][1],_aRow)
		(_aAlias[nI])->(DbSkip())
	EndDo
	
Next

oExcel:Activate()

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio."),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
cFile := cFolder//+".XML"

oExcel:GetXMLFile(cFile)

MsgInfo("Arquivo gerado com sucesso, sera aberto apos o fechamento dessa mensagem." + CRLF + cFile)

If ApOleClient("MsExcel")
	oExcelApp:=MsExcel():New()
	oExcelApp:WorkBooks:Open(cFile)
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo("Excel nao instaldo!"+chr(13)+chr(10)+"Relatorio gerado com sucesso, arquivo gerado no diretorio abaixo: "+chr(13)+cFile)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRPRMI002  บAutor  ณMicrosiga           บ Data ณ  02/15/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetTable(_cAlias,nTipo)

Local cQuery := ""

cQuery := ""	
If MV_PAR06 <> 3	//-- Diferente de co-participa็ใo
	cquery += " SELECT RHR_FILIAL,RHR_MAT,RA_NOME FUNCIONARIO,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_SITFOLH, RHR_ORIGEM
	cquery += " ,(CASE 
	cquery += " 	WHEN RHR_ORIGEM = '1' THEN 'TITULAR' 
	cquery += " 	WHEN RHR_ORIGEM = '3' THEN 'AGREGADO'
	cquery += " 	ELSE 'DEPENDENTE' END) TIPO
	cquery += " ,RHR_CODIGO
	cquery += " ,CASE WHEN RHR_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_NOME FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHR_FILIAL AND RB_MAT = RHR_MAT AND RB_COD = RHR_CODIGO),RA_NOME)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_NOME FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHR_FILIAL AND RHM_MAT = RHR_MAT AND RHM_CODIGO = RHR_CODIGO AND RHM_TPFORN = RHR_TPFORN),RA_NOME) END NOME
	cquery += " ,CASE WHEN RHR_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_CIC FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHR_FILIAL AND RB_MAT = RHR_MAT AND RB_COD = RHR_CODIGO),RA_CIC)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_CPF FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHR_FILIAL AND RHM_MAT = RHR_MAT AND RHM_CODIGO = RHR_CODIGO AND RHM_TPFORN = RHR_TPFORN),RA_CIC) END CODCPF
	cquery += " ,CASE WHEN RHR_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_DTNASC FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHR_FILIAL AND RB_MAT = RHR_MAT AND RB_COD = RHR_CODIGO),RA_NASC)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_DTNASC FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHR_FILIAL AND RHM_MAT = RHR_MAT AND RHM_CODIGO = RHR_CODIGO AND RHM_TPFORN = RHR_TPFORN),RA_NASC) END NASC
	cquery += " ,RHR_TPLAN
	cquery += " , (CASE WHEN RHR_TPLAN = '1' THEN 'MENSALIDADE' WHEN RHR_TPLAN = '2' THEN 'COPARTICIPACAO' ELSE 'REEMBOLSO' END) TIPOLANC
	cquery += " ,RHR_TPFORN
	cquery += " ,(CASE WHEN RHR_TPFORN = '1' THEN 'ASS.MEDICA' ELSE 'ASS.ODONTOLOGICA' END) TIPOFORN
	cquery += " ,RHR_CODFOR
	cquery += " ,(CASE WHEN RHR_TPFORN = '1' THEN (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S016' AND SUBSTRING(RCC_CONTEU,1,3) = RHR_CODFOR)  ELSE (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S017' AND SUBSTRING(RCC_CONTEU,1,3) = RHR_CODFOR)  END) FORNECEDOR
	cquery += " , RHR_TPPLAN
	cquery += " , RHR_PLANO
	cquery += " ,isnull((CASE WHEN RHR_TPFORN = '1' THEN (SELECT MAX(SUBSTRING(RCC_CONTEU,3,20)) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S008' AND SUBSTRING(RCC_CONTEU,1,2) = RHR_PLANO)  ELSE (SELECT max(SUBSTRING(RCC_CONTEU,3,20)) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S014' AND SUBSTRING(RCC_CONTEU,1,2) = RHR_PLANO)  END),' ') DESCPLANO
	cquery += " ,RHR_PD
	cquery += " ,RHR_VLRFUN
	cquery += " ,RHR_VLREMP
	cquery += " FROM  "+RetSqlName("RHR")+"  A,  "+RetSqlName("SRA")+"  B, "+RetSqlName("CTT")+" C, "+RetSqlName("SRJ")+" D
	cquery += " WHERE
	cquery += " A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND RA_CC = CTT_CUSTO
	cquery += " AND RA_CODFUNC = RJ_FUNCAO
	cquery += " AND RHR_FILIAL = RA_FILIAL
	cquery += " AND RHR_MAT = RA_MAT
	cquery += " AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cquery += " AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	cquery += " AND RHR_COMPPG = '"+MV_PAR05+"'
	If MV_PAR06 <> 4
		cquery += " AND RHR_TPFORN = '"+StrZero(MV_PAR06,1)+"'
	Endif
	cquery += " UNION ALL
	cquery += " SELECT RHS_FILIAL,RHS_MAT,RA_NOME FUNCIONARIO,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_SITFOLH, RHS_ORIGEM
	cquery += " ,(CASE 
	cquery += " 	WHEN RHS_ORIGEM = '1' THEN 'TITULAR' 
	cquery += " 	WHEN RHS_ORIGEM = '3' THEN 'AGREGADO'
	cquery += " 	ELSE 'DEPENDENTE' END) TIPO
	cquery += " ,RHS_CODIGO
	cquery += " ,CASE WHEN RHS_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_NOME FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHS_FILIAL AND RB_MAT = RHS_MAT AND RB_COD = RHS_CODIGO),RA_NOME)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_NOME FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHS_FILIAL AND RHM_MAT = RHS_MAT AND RHM_CODIGO = RHS_CODIGO AND RHM_TPFORN = RHS_TPFORN),RA_NOME) END NOME
	cquery += " ,CASE WHEN RHS_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_CIC FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHS_FILIAL AND RB_MAT = RHS_MAT AND RB_COD = RHS_CODIGO),RA_CIC)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_CPF FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHS_FILIAL AND RHM_MAT = RHS_MAT AND RHM_CODIGO = RHS_CODIGO AND RHM_TPFORN = RHS_TPFORN),RA_CIC) END CODCPF
	cquery += " ,CASE WHEN RHS_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_DTNASC FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHS_FILIAL AND RB_MAT = RHS_MAT AND RB_COD = RHS_CODIGO),RA_NASC)
	cquery += " 	ELSE
	cquery += " 	ISNULL((SELECT RHM_DTNASC FROM  "+RetSqlName("RHM")+"  WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHS_FILIAL AND RHM_MAT = RHS_MAT AND RHM_CODIGO = RHS_CODIGO AND RHM_TPFORN = RHS_TPFORN),RA_NASC) END NASC
	cquery += " ,RHS_TPLAN
	cquery += " , (CASE WHEN RHS_TPLAN = '1' THEN 'MENSALIDADE' WHEN RHS_TPLAN = '2' THEN 'COPARTICIPACAO' ELSE 'REEMBOLSO' END) TIPOLANC
	cquery += " ,RHS_TPFORN
	cquery += " ,(CASE WHEN RHS_TPFORN = '1' THEN 'ASS.MEDICA' ELSE 'ASS.ODONTOLOGICA' END) TIPOFORN
	cquery += " ,RHS_CODFOR
	cquery += " ,(CASE WHEN RHS_TPFORN = '1' THEN (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S016' AND SUBSTRING(RCC_CONTEU,1,3) = RHS_CODFOR)  ELSE (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S017' AND SUBSTRING(RCC_CONTEU,1,3) = RHS_CODFOR)  END) FORNECEDOR
	cquery += " , RHS_TPPLAN
	cquery += " , RHS_PLANO
	cquery += " ,isnull((CASE WHEN RHS_TPFORN = '1' THEN (SELECT MAX(SUBSTRING(RCC_CONTEU,3,20)) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S008' AND SUBSTRING(RCC_CONTEU,1,2) = RHS_PLANO)  ELSE (SELECT max(SUBSTRING(RCC_CONTEU,3,20)) FROM  "+RetSqlName("RCC")+"  WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S014' AND SUBSTRING(RCC_CONTEU,1,2) = RHS_PLANO)  END),' ') DESCPLANO
	cquery += " ,RHS_PD
	cquery += " ,RHS_VLRFUN
	cquery += " ,RHS_VLREMP
	cquery += " FROM  "+RetSqlName("RHS")+"  A,  "+RetSqlName("SRA")+"  B, "+RetSqlName("CTT")+" C, "+RetSqlName("SRJ")+" D
	cquery += " WHERE
	cquery += " A.D_E_L_E_T_ = ' '
	cquery += " AND B.D_E_L_E_T_ = ' '
	cquery += " AND C.D_E_L_E_T_ = ' '
	cquery += " AND D.D_E_L_E_T_ = ' '
	cquery += " AND RA_CC = CTT_CUSTO
	cquery += " AND RA_CODFUNC = RJ_FUNCAO
	cquery += " AND RHS_FILIAL = RA_FILIAL
	cquery += " AND RHS_MAT = RA_MAT
	cquery += " AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	cquery += " AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
	cquery += " AND RHS_COMPPG = '"+MV_PAR05+"'
	If MV_PAR06 <> 4
		cquery += " AND RHS_TPFORN = '"+StrZero(MV_PAR06,1)+"'
	Endif
Endif

If MV_PAR06 == 4		// se for ambos
	cquery += " UNION ALL
Endif

If MV_PAR06 == 3 .Or. MV_PAR06 == 4		// se for co-participa็ใo
	cquery += "  SELECT RHO_FILIAL,RHO_MAT,RA_NOME FUNCIONARIO,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_SITFOLH, RHO_ORIGEM
	cquery += " ,(CASE 
	cquery += " WHEN RHO_ORIGEM = '1' THEN 'TITULAR' 
	cquery += "  	WHEN RHO_ORIGEM = '3' THEN 'AGREGADO'
	cquery += "  	ELSE 'DEPENDENTE' END) TIPO
	cquery += "  ,RHO_CODIGO
	cquery += "  ,CASE WHEN RHO_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_NOME FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHO_FILIAL AND RB_MAT = RHO_MAT AND RB_COD = RHO_CODIGO),RA_NOME)
	cquery += "  	ELSE
	cquery += " 	ISNULL((SELECT RHM_NOME FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHO_FILIAL AND RHM_MAT = RHO_MAT AND RHM_CODIGO = RHO_CODIGO AND RHM_TPFORN = RHO_TPFORN),RA_NOME) END NOME
	cquery += "  ,CASE WHEN RHO_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_CIC FROM  "+RetSqlName("SRB")+"   WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHO_FILIAL AND RB_MAT = RHO_MAT AND RB_COD = RHO_CODIGO),RA_CIC)
	cquery += "  	ELSE
	cquery += "  	ISNULL((SELECT RHM_CPF FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHO_FILIAL AND RHM_MAT = RHO_MAT AND RHM_CODIGO = RHO_CODIGO AND RHM_TPFORN = RHO_TPFORN),RA_CIC) END CODCPF
	cquery += "  ,CASE WHEN RHO_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_DTNASC FROM  "+RetSqlName("SRB")+"   WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHO_FILIAL AND RB_MAT = RHO_MAT AND RB_COD = RHO_CODIGO),RA_NASC)
	cquery += " 	ELSE
	cquery += "  	ISNULL((SELECT RHM_DTNASC FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHO_FILIAL AND RHM_MAT = RHO_MAT AND RHM_CODIGO = RHO_CODIGO AND RHM_TPFORN = RHO_TPFORN),RA_NASC) END NASC
	cquery += "  ,RHO_TPLAN
	cquery += "  , (CASE WHEN RHO_TPLAN = '1' THEN 'COPARTICIPACAO' ELSE 'REEMBOLSO' END) TIPOLANC
	cquery += "  ,RHO_TPFORN
	cquery += "  ,(CASE WHEN RHO_TPFORN = '1' THEN 'ASS.MEDICA' ELSE 'ASS.ODONTOLOGICA' END) TIPOFORN
	cquery += "  ,RHO_CODFOR
	cquery += "  ,(CASE WHEN RHO_TPFORN = '1' THEN (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM "+RetSqlName("RCC")+"   WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S016' AND SUBSTRING(RCC_CONTEU,1,3) = RHO_CODFOR)  ELSE (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM "+RetSqlName("RCC")+"   WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S017' AND SUBSTRING(RCC_CONTEU,1,3) = RHO_CODFOR)  END) FORNECEDOR
	cquery += "  , ' ' RHO_TPPLAN
	cquery += "  , ' ' RHO_PLANO
	cquery += "  , ' ' DESCPLANO
	cquery += "  ,RHO_PD
	cquery += "  ,RHO_VLRFUN
	cquery += "  ,RHO_VLREMP
	cquery += "  FROM  "+RetSqlName("RHO")+"   A,  "+RetSqlName("SRA")+"   B, "+RetSqlName("CTT")+"  C, "+RetSqlName("SRJ")+"  D
	cquery += "  WHERE
	cquery += "  A.D_E_L_E_T_ = ' '
	cquery += "  AND B.D_E_L_E_T_ = ' '
	cquery += "  AND C.D_E_L_E_T_ = ' '
	cquery += "  AND D.D_E_L_E_T_ = ' '
	cquery += "  AND RA_CC = CTT_CUSTO
	cquery += "  AND RA_CODFUNC = RJ_FUNCAO
	cquery += "  AND RHO_FILIAL = RA_FILIAL
	cquery += "  AND RHO_MAT = RA_MAT
	cquery += "  AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cquery += "  AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cquery += "  AND RHO_COMPPG = '"+MV_PAR05+"'
	If MV_PAR06 <> 3 .And. MV_PAR06 <> 4
		cquery += "  AND RHO_TPFORN = '"+StrZero(MV_PAR06,1)+"'
	Endif
	cquery += " UNION ALL
	cquery += "  SELECT RHP_FILIAL,RHP_MAT,RA_NOME FUNCIONARIO,RA_CC,CTT_DESC01,RA_CODFUNC,RJ_DESC,RA_ADMISSA,RA_DEMISSA,RA_CATFUNC,RA_SITFOLH, RHP_ORIGEM
	cquery += " ,(CASE 
	cquery += " WHEN RHP_ORIGEM = '1' THEN 'TITULAR' 
	cquery += "  	WHEN RHP_ORIGEM = '3' THEN 'AGREGADO'
	cquery += "  	ELSE 'DEPENDENTE' END) TIPO
	cquery += "  ,RHP_CODIGO
	cquery += "  ,CASE WHEN RHP_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_NOME FROM  "+RetSqlName("SRB")+"  WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHP_FILIAL AND RB_MAT = RHP_MAT AND RB_COD = RHP_CODIGO),RA_NOME)
	cquery += "  	ELSE
	cquery += " 	ISNULL((SELECT RHM_NOME FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHP_FILIAL AND RHM_MAT = RHP_MAT AND RHM_CODIGO = RHP_CODIGO AND RHM_TPFORN = RHP_TPFORN),RA_NOME) END NOME
	cquery += "  ,CASE WHEN RHP_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_CIC FROM  "+RetSqlName("SRB")+"   WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHP_FILIAL AND RB_MAT = RHP_MAT AND RB_COD = RHP_CODIGO),RA_CIC)
	cquery += "  	ELSE
	cquery += "  	ISNULL((SELECT RHM_CPF FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHP_FILIAL AND RHM_MAT = RHP_MAT AND RHM_CODIGO = RHP_CODIGO AND RHM_TPFORN = RHP_TPFORN),RA_CIC) END CODCPF
	cquery += "  ,CASE WHEN RHP_ORIGEM IN ('1','2') THEN ISNULL((SELECT RB_DTNASC FROM  "+RetSqlName("SRB")+"   WHERE D_E_L_E_T_ = ' ' AND RB_FILIAL = RHP_FILIAL AND RB_MAT = RHP_MAT AND RB_COD = RHP_CODIGO),RA_NASC)
	cquery += " 	ELSE
	cquery += "  	ISNULL((SELECT RHM_DTNASC FROM  "+RetSqlName("RHM")+"   WHERE D_E_L_E_T_ = ' ' AND RHM_FILIAL = RHP_FILIAL AND RHM_MAT = RHP_MAT AND RHM_CODIGO = RHP_CODIGO AND RHM_TPFORN = RHP_TPFORN),RA_NASC) END NASC
	cquery += "  ,RHP_TPLAN
	cquery += "  , (CASE WHEN RHP_TPLAN = '1' THEN 'COPARTICIPACAO' ELSE 'REEMBOLSO' END) TIPOLANC
	cquery += "  ,RHP_TPFORN
	cquery += "  ,(CASE WHEN RHP_TPFORN = '1' THEN 'ASS.MEDICA' ELSE 'ASS.ODONTOLOGICA' END) TIPOFORN
	cquery += "  ,RHP_CODFOR
	cquery += "  ,(CASE WHEN RHP_TPFORN = '1' THEN (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM "+RetSqlName("RCC")+"   WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S016' AND SUBSTRING(RCC_CONTEU,1,3) = RHP_CODFOR)  ELSE (SELECT SUBSTRING(RCC_CONTEU,4,30) FROM "+RetSqlName("RCC")+"   WHERE D_E_L_E_T_ = ' ' AND RCC_CODIGO = 'S017' AND SUBSTRING(RCC_CONTEU,1,3) = RHP_CODFOR)  END) FORNECEDOR
	cquery += "  , ' ' RHP_TPPLAN
	cquery += "  , ' ' RHP_PLANO
	cquery += "  , ' ' DESCPLANO
	cquery += "  ,RHP_PD
	cquery += "  ,RHP_VLRFUN
	cquery += "  ,RHP_VLREMP
	cquery += "  FROM  "+RetSqlName("RHP")+"   A,  "+RetSqlName("SRA")+"   B, "+RetSqlName("CTT")+"  C, "+RetSqlName("SRJ")+"  D
	cquery += "  WHERE
	cquery += "  A.D_E_L_E_T_ = ' '
	cquery += "  AND B.D_E_L_E_T_ = ' '
	cquery += "  AND C.D_E_L_E_T_ = ' '
	cquery += "  AND D.D_E_L_E_T_ = ' '
	cquery += "  AND RA_CC = CTT_CUSTO
	cquery += "  AND RA_CODFUNC = RJ_FUNCAO
	cquery += "  AND RHP_FILIAL = RA_FILIAL
	cquery += "  AND RHP_MAT = RA_MAT
	cquery += "  AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cquery += "  AND RA_MAT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cquery += "  AND RHP_COMPPG = '"+MV_PAR05+"'
	If MV_PAR06 <> 3 .And. MV_PAR06 <> 4
		cquery += "  AND RHP_TPFORN = '"+StrZero(MV_PAR06,1)+"'
	Endif
Endif
cquery += "  ORDER BY 1,2,11,13"

cquery := ChangeQuery ( cquery ) 

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPriPerg  บAutor  ณMicrosiga           บ Data ณ  05/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPriPerg()

Local aRegs := {}
Local a_Area := getArea()
Local j := 0   
Local i := 0

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Filial De ?          ','','','mv_ch1','C',02,0,0,'G','             ','mv_par01','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'02','Filial Ate ?         ','','','mv_ch2','C',02,0,0,'G','NaoVazio     ','mv_par02','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'XM0','' })
aAdd(aRegs,{ cPerg,'03','Matricula de ?       ','','','mv_ch3','C',06,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'04','Matricula Ate ?      ','','','mv_ch4','C',06,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'05','Periodo              ','','','mv_ch5','C',06,0,0,'G','NaoVazio     ','mv_par05','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
AAdd(aRegs,{ cPerg,"06","Tipo de Plano"        ,"","","mv_ch6","N",01,0,0,"C","NaoVazio()","mv_par06","Ass.Medica","Ass.Medica","Ass.Medica","","","Ass.Odontologica","Ass.Odontologica","Ass.Odontologica","","","Co-participa็ใo","Co-participa็ใo","Co-participa็ใo","","","Ambos","Ambos","Ambos","","","","","","","",""})

dbSelectArea("SX1")

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

RestArea(a_Area)

Return
