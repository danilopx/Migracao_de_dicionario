#Include 'Protheus.ch'
#Include 'topconn.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprireces Autor  ณDavid- hrduarte       บ Data ณ  22/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera dados de afastamentos SR8                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AFASTBEN()
`
Local cFile := ""

// Declaracao de Variaveis
Private cPerg    := "GPAFASTBEN"

//Funcao cria perguntas no SX1 - Se nao existir
fPriPerg()

//Abre a janela para o usuแrio fazendo as perguntas
pergunte(cPerg,.T.)

FwMsgRun(,{|oSay| Print(@oSay)},"Processando","Gerando arquivo...")

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
Local aWSheet		:= {{"Afastamentos"}} 
Local xz			:= 0

aEval(aWSheet,{|x| oExcel:AddworkSheet(x[1])})
aEval(aWSheet,{|x| oExcel:AddTable(x[1],x[1])})

For nI := 1 To Len(_aAlias)
	GetTable(_aAlias[nI],nI)
	_aStruct := (_aAlias[nI])->(DbStruct())           
	
	//TRATAMENTO PARA CAMPOS DO TIPO DATA
	For xz := 1 to Len(_aStruct)
		If Alltrim(_aStruct[xz,1]) $ "INICIO,FINAL"  
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

cFolder := cGetFile("XML | *.XML", OemToAnsi("Informe o diretorio.",1,7),,,,nOR(GETF_LOCALHARD,GETF_NETWORKDRIVE))
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

cQuery := ""
cquery += " SELECT
cquery += " 	RA_FILIAL Filial,
cquery += " 	RA_MAT Matricula, 
cquery += " 	RA_NOME Nome,
cquery += " 	R8_TIPOAFA Tipo,
cquery += " 	RCM_DESCRI Descricao,
cquery += " 	R8_DATAINI Inicio,
cquery += " 	R8_DATAFIM Final
cquery += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SR8")+" B, "+RetSqlName("RCM")+" C
cquery += " WHERE
cquery += "	 A.D_E_L_E_T_ = ' '
cquery += "	 AND B.D_E_L_E_T_ = ' '
cquery += "	 AND C.D_E_L_E_T_ = ' '
cquery += "	 AND A.RA_FILIAL = B.R8_FILIAL
cquery += "	 AND A.RA_MAT = B.R8_MAT
cquery += "	 AND B.R8_TIPOAFA = C.RCM_TIPO
cquery += "	 AND A.RA_SITFOLH <> 'D'
Cquery += "	 AND ( ( B.R8_DATAFIM = ' ' OR B.R8_DATAFIM >= '"+DTOS(MV_PAR03)+"' ) AND ( B.R8_DATAINI <= '"+DTOS(MV_PAR04)+"' ) )"


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
aAdd(aRegs,{ cPerg,'03','Data De  ?          ','','','mv_ch3','D',08,0,0,'G','             ','mv_par03','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'04','Data Ate  ?         ','','','mv_ch4','D',08,0,0,'G','NaoVazio     ','mv_par04','                 ','','','','','                 ','','','','','                '    ,'','','','',''                 ,'','','','',''      ,'','','' ,'   ','' })

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
