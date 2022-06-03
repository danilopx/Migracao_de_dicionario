#Include 'Protheus.ch'
#Include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPHRFOLEXบAutor  ณ                    บ Data ณ  21/06/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerando planilhas FOLHA EM EXCEL                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GPHRFOLEX()
`
// Declaracao de Variaveis
Private cPerg    := Padr("GPHRFOLEX",10)

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
Local aWSheet		:= {{"Folha em Excel"}}
Local xz			:= 0

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())
	
	//TRATAMENTO PARA CAMPOS DO TIPO DATA
	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "RA_ADMISSA/RA_DEMISSA"
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
cFile := cFolder+".XML"

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

cquery += " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CC, RA_CIC, RA_SALARIO, RA_CATFUNC, RA_ADMISSA, RA_DEMISSA, RA_SITFOLH, RA_RESCRAI, RA_CODFUNC, RJ_DESC, RD_PERIODO, RD_ROTEIR, RD_PD, RV_DESC, RV_TIPOCOD, RD_HORAS, RD_VALOR, RD_CC, CTT_DESC01, RV_INSS, RV_FGTS, RV_IR
cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRD")+" B, "+RetSqlName("SRV")+" C,  "+RetSqlName("SRJ")+"  D,  "+RetSqlName("CTT")+"  E
cquery += " WHERE A.D_E_L_E_T_ = ' ' 
cquery += "             AND B.D_E_L_E_T_ = ' ' 
cquery += "             AND C.D_E_L_E_T_ = ' ' 
cquery += "             AND D.D_E_L_E_T_ = ' ' 
cquery += "             AND E.D_E_L_E_T_ = ' '
cquery += "             AND RA_FILIAL = RD_FILIAL
cquery += "             AND RA_MAT = RD_MAT
cquery += "             AND RD_CC = CTT_CUSTO
cquery += "             AND RD_PERIODO = '"+MV_PAR03+"'
cquery += "             AND RD_ROTEIR = '"+MV_PAR04+"'
cquery += "             AND RD_PD = RV_COD
cquery += "             AND RA_CODFUNC = RJ_FUNCAO
cquery += " 			AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cquery += " UNION ALL
cquery += " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CC, RA_CIC, RA_SALARIO, RA_CATFUNC, RA_ADMISSA, RA_DEMISSA, RA_SITFOLH, RA_RESCRAI, RA_CODFUNC, RJ_DESC, RC_PERIODO, RC_ROTEIR, RC_PD, RV_DESC, RV_TIPOCOD, RC_HORAS, RC_VALOR, RC_CC, CTT_DESC01, RV_INSS, RV_FGTS, RV_IR
cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRC")+" B, "+RetSqlName("SRV")+" C,  "+RetSqlName("SRJ")+"  D,  "+RetSqlName("CTT")+"  E
cquery += " WHERE A.D_E_L_E_T_ = ' ' 
cquery += "             AND B.D_E_L_E_T_ = ' ' 
cquery += "             AND C.D_E_L_E_T_ = ' ' 
cquery += "             AND D.D_E_L_E_T_ = ' '
cquery += "             AND E.D_E_L_E_T_ = ' ' 
cquery += "             AND RA_FILIAL = RC_FILIAL
cquery += "             AND RA_MAT = RC_MAT
cquery += "             AND RC_CC = CTT_CUSTO
cquery += "             AND RC_PERIODO = '"+MV_PAR03+"'
cquery += "             AND RC_ROTEIR = '"+MV_PAR04+"'
cquery += "             AND RC_PD = RV_COD
cquery += "             AND RA_CODFUNC = RJ_FUNCAO
cquery += " 			AND RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cquery += " ORDER BY RA_FILIAL,RA_MAT,RD_PERIODO,RD_ROTEIR,RD_PD

If Select(_cAlias) > 0
	(_cAlias)->(DbCloseArea())
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), _cAlias, .F., .F.)
(_cAlias)->(DBGOTOP())

Return


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
aAdd(aRegs,{ cPerg,'03','Periodo    ?         ','','','mv_ch3','C',06,0,0,'G','NaoVazio     ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'RCH','' })
aAdd(aRegs,{ cPerg,'04','Roteiro    ?         ','','','mv_ch4','C',03,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'SRY','' })
 
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
