#Include "Protheus.Ch"
#Include "Ap5Mail.Ch"
//*******************************************************************************************
// Funcao:     TFGDESVD
// Finalidade: Tela principal para geracao e exportacao de dados ref. Desafio de Vendas
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
User Function TFGDESVD()
Local oCbAno := Nil
Local oCbMes := Nil
Local oCbNMs := Nil
Local oGp1 := Nil
Local oGp2 := Nil
Local oGp3 := Nil
Local oGtPt := Nil
Local oSay1 := Nil
Local oSP1B := Nil
Local oSP2 := Nil
Local oSP3 := Nil
Local oBtEml := Nil
Local oBtFc := Nil
Local oBtGD := Nil
Local oBtGP := Nil
Local oDgA := Nil
Local cGtPt := Space(500)
Local cCbAno := "Janeiro" 
Local cCbMes := "2021"
Local cCbNMs := "3 meses"
Local cEmlTst := Alltrim(SuperGetMV("TFGDESVDE1",,""))
Local cEnvSrv := GetEnvServer()

AjustaSXB()

DEFINE MSDIALOG oDgA TITLE "Desafios de Vendas" FROM 000, 000  TO 245, 600 COLORS 0, 16777215 PIXEL

    @ 002, 002 GROUP oGp1 TO 031, 300 PROMPT "Geração dos Dados" OF oDgA COLOR 0, 16777215 PIXEL
    @ 011, 006 SAY oSay1 PROMPT "Selecione o mês, o ano e quantidade de " SIZE 110, 013 OF oDgA COLORS 0, 16777215 PIXEL
    @ 019, 006 SAY oSP1B PROMPT "meses a considerar para gerar os dados" SIZE 110, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 013, 106 MSCOMBOBOX oCbMes VAR cCbMes ITEMS {"Janeiro","Fevereiro","Marco","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"} SIZE 044, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 013, 149 MSCOMBOBOX oCbAno VAR cCbAno ITEMS {"2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031","2032","2033","2034","2035","2036","2037","2038","2039","2040","2041","2042","2043","2044","2045","2046","2047","2048","2049","2050","2051","2052","2053","2054","2055","2056","2057","2058","2059","2060","2061","2062","2063","2064","2065","2066","2067","2068","2069","2070","2071","2072","2073","2074","2075","2076","2077","2078","2079","2080"} SIZE 034, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 013, 182 MSCOMBOBOX oCbNMs VAR cCbNMs ITEMS {"3 meses","6 meses","9 meses","12 meses","24 meses"} SIZE 046, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 013, 234 BUTTON oBtGD PROMPT "Gerar Dados" Action(MsgRun("Gerando Dados ...","",{||GDados(Alltrim(cCbMes),Alltrim(cCbAno),Alltrim(cCbNMs))})) SIZE 063, 011 OF oDgA PIXEL
    @ 035, 002 GROUP oGp2 TO 064, 300 PROMPT "Planilha de Conferência dos Dados Gerados" OF oDgA COLOR 0, 16777215 PIXEL
    @ 048, 006 SAY oSP2 PROMPT "Salvar na pasta:" SIZE 110, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 046, 049 MSGET oGtPt VAR cGtPt F3 "TFARQP" SIZE 180, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 046, 234 BUTTON oBtGP PROMPT "Gerar Planilha" Action(MsgRun("Gerando Planilha ...","",{||GPlan(Alltrim(cCbMes),Alltrim(cCbAno),Alltrim(cGtPt))})) SIZE 063, 011 OF oDgA PIXEL
    @ 070, 002 GROUP oGp3 TO 098, 300 PROMPT "Envio dos Dados" OF oDgA COLOR 0, 16777215 PIXEL
    @ 083, 006 SAY oSP3 PROMPT 'Ao clicar em "Gerar E-Mail", será exibida uma lista com o destinatário dos dados para seleção.' SIZE 224, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 080, 234 BUTTON oBtEml PROMPT "Gerar E-Mails" Action(MsgRun("Gerando E-Mails ...","",{||GEmail(Alltrim(cCbMes),Alltrim(cCbAno),cEmlTst,cEnvSrv)}))  SIZE 063, 011 OF oDgA PIXEL
    @ 105, 234 BUTTON oBtFc PROMPT "Fechar" Action(oDgA:End()) SIZE 063, 011 OF oDgA PIXEL

ACTIVATE MSDIALOG oDgA CENTERED

Return(Nil)



//*******************************************************************************************
// Funcao:     AJUSTASXB
// Finalidade: Cadastra consulta usada para pegar o caminho do arquivo .CSV
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function AjustaSXB()
Local aSXB := {}  
Local aEstrut := {}
Local i := 0
Local j := 0
Local aArea := GetArea()     

dbSelectArea("SXB")                    
SXB->(dbSetOrder(1))
If SXB->(!dbSeek("TFARQP"))

	aEstrut :=  {"XB_ALIAS" ,"XB_TIPO"	,"XB_SEQ"	,"XB_COLUNA"	,"XB_DESCRI"		    ,"XB_DESCSPA"		    ,"XB_DESCENG"		    ,"XB_CONTEM"	}
	Aadd( aSXB,	{"TFARQP"	,"1"		,"01"		,"RE"			,"Desafios de Venda"    ,"Desafios de Venda"    ,"Desafios de Venda"    ,"ZZT"			})
	Aadd( aSXB,	{"TFARQP"	,"2"		,"01"		,"01"			,""				 	    ,""					    ,""					    ,".T."			})
	Aadd( aSXB,	{"TFARQP"	,"5"		,"01"		,""				,""					    ,""					    ,""					    ,"U_TFGTPATH()"	})	

	dbSelectArea("SXB")                    
	For i:= 1 To Len(aSXB)
		RecLock("SXB",.T.)			
		For j:=1 To Len(aSXB[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
			EndIf
		Next j			
		SXB->(dbCommit())
		SXB->(MsUnLock())
	Next i

EndIf
RestArea(aArea)

Return(Nil)



//*******************************************************************************************
// Funcao:     TFGTPATH
// Finalidade: Selecao da pasta onde a planilha de conferencia sera gravada
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
User Function TFGTPATH()
Local cPasta	:= ""

cPasta := cGetFile(,"Selecione a pasta",,"C:\",.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)

If Empty(cPasta)
    Alert("Pasta inválida")
EndIf                         

Return(cPasta)



//*******************************************************************************************
// Funcao:     GDADOS
// Finalidade: Chama Stored Procedure que gerara os dados
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function GDados( cCbMes, cCbAno, cCbNMs )
Local aRet := ""
Local cMsg := ""
Local cMes := RetMesN( cCbMes )
Local nQMs := Val( SubStr( Alltrim( cCbNMs ), 1, 2 ) )

If TCSPExist( "SP_REPRESENTATIVIDADE_VENDEDOR_VERSUS_PRODUTOS" )
    If ChkDados( @cMsg, cMes, cCbMes, cCbAno )
        If MsgYesNo( cMsg )
            aRet := TCSPEXEC( "SP_REPRESENTATIVIDADE_VENDEDOR_VERSUS_PRODUTOS", Alltrim(cCbAno) + cMes, nQMs )
            MsgRun("Fim do Processamento","",{||Sleep(3000)})
        EndIf
    Else
        Alert( cMsg )
    EndIf
Else
	Alert("Atenção: stored procedure SP_REPRESENTATIVIDADE_VENDEDOR_VERSUS_PRODUTOS não instalada neste ambiente. Contacte o Administrador do Sistema.")
EndIf

Return(Nil)



//*******************************************************************************************
// Funcao:     GPLAN
// Finalidade: Gera a planilha de conferencia no formato XML do Excel
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function GPlan( cCbMes, cCbAno, cGtPt, cCodVnd, cModoG )
Local cMes := RetMesN( cCbMes )
Local cAba := ""
Local cTab := ""
Local cMsg := ""
Local cRet := ""
Local cSPath := ""
Local nNx := 0
Local aDat := {}
Local aAux := {}
Local oExcel := Nil
Local lGo := .T.
Default cCodVnd := ""
Default cModoG := "C" // C=Conferencia, A=Anexo

If cModoG == "C"

    If !ApOleClient("MSExcel")
        lGo := .F.
        cMsg := "Microsoft Excel não instalado!"
    EndIf

    If lGo
        If Empty( cGtPt )
            lGo := .F.
            cMsg := "Caminho para gravação da planilha não informado"
        EndIf
    EndIf

    If lGo
        If !ExistDir( cGtPt )
            lGo := .F.
            cMsg := "Caminho para gravação da planilha é inválido"
        EndIf
    EndIf

    If lGo
        ChkDados( @cMsg, cMes, cCbMes, cCbAno, "P" )
        If !Empty(cMsg)
            lGo := .F.
        EndIf
    EndIf

EndIf

If lGo

    If cModoG == "C"
        lGo := MsgYesNo("Confirma a geração da planilha para o ano de " +cCbAno+ " ?"  )
    EndIf

    If lGo

        cAba := "Desafio"
        cTab := Alltrim(cCbMes) + "/" + Alltrim(cCbAno)

        GDatPlan( cCbAno, cMes, cCodVnd, @aDat )
            
        If Len( aDat ) > 0

            cSPath := GetSrvProfString( "StartPath", "\system\" )
            cFile := "Desafio_de_Vendas_"+Alltrim(cCbMes)+"_"+Alltrim(cCbAno)+"_Emissao_"+DtoS(Date())+"_"+Time()+".xml"
            cFile := StrTran(cFile,":","")

            oExcel := FWMSExcel():New()

            oExcel:AddWorkSheet(cAba)
            oExcel:AddTable(cAba, cTab)
            oExcel:AddColumn(cAba, cTab, "COD. PRODUTO", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "DESCRICAO PRODUTO", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "FAMILIA", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "ID GERENTE", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "NOME GERENTE", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "ID VENDEDOR", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "NOME VENDEDOR", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "ANO BASE", 1, 1, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO JAN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO FEV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO MAR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO ABR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO MAI", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO JUN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO JUL", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO AGO", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO SET", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO OUT", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO NOV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "DESAFIO DEZ", 1, 2, .F.)

            If Empty(cCodVnd)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO JAN", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO FEV", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO MAR", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO ABR", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO MAI", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO JUN", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO JUL", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO AGO", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO SET", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO OUT", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO NOV", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.DESAFIO DEZ", 1, 2, .F.)
            EndIf

            oExcel:AddColumn(cAba, cTab, "% REPRES.JAN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.FEV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.MAR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.ABR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.MAI", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.JUN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.JUL", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.AGO", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.SET", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.OUT", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.NOV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "% REPRES.DEZ", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.JAN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.FEV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.MAR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.ABR", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.MAI", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.JUN", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.JUL", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.AGO", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.SET", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.OUT", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.NOV", 1, 2, .F.)
            oExcel:AddColumn(cAba, cTab, "QT.REALIZ.DEZ", 1, 2, .F.)

            If Empty(cCodVnd)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.JAN", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.FEV", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.MAR", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.ABR", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.MAI", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.JUN", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.JUL", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.AGO", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.SET", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.OUT", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.NOV", 1, 2, .F.)
                oExcel:AddColumn(cAba, cTab, "VL.REALIZ.DEZ", 1, 2, .F.)
            EndIf

            For nNx := 1 To Len( aDat )

                aAux := {}
                aAux := aClone( aDat[nNx] )
                oExcel:AddRow( cAba, cTab, aAux )

            Next nNx

            If !Empty( oExcel:aWorkSheet )

                oExcel:Activate()
                oExcel:GetXMLFile(cFile)

                If cModoG == "C"
            
                    CpyS2T( cSPath+cFile, cGtPt )
                    FErase( cSPath+cFile )

                    If File( cGtPt+cFile )
                        MsgRun("Fim da geração da planilha. Abrindo Excel...","",{||Sleep(3000)})                
                        ShellExecute( "open", cGtPt+cFile, cFile, cGtPt, 1 )
                    Else
                        cMsg := "Não foi possível copiar a planilha para a pasta informada (causa provável: sem permissão de gravação na pasta "+cGt+")"
                    EndIf

                Else

                    If File(cSPath+cFile)
                        cRet := cSPath+cFile
                    EndIf

                EndIf

            Else
            
                cMsg := "Erro na criação da planilha. Tente novamente. Caso o problema persista, contacte o Administrador do Sistema."

            EndIf 

        Else

            cMsg := "Não há dados para o período informado"

        EndIf

    EndIf

EndIf

If !Empty(cMsg)
    Alert(cMsg)
EndIf

Return(cRet)



//*******************************************************************************************
// Funcao:     GDATPLAN
// Finalidade: Gera os dados da planilha de conferencia e da que sera enviada ao vendedor
//             como anexo do e-mail.
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function GDatPlan( cCbAno, cMes, cCodVnd, aDat )
Local cQry := ""
Default cCodVnd := ""
Default aDat := {}

aDat := {}
cQry := "SELECT " 
cQry += "COD_PRODUTO, "
cQry += "DESCRICAO_PRODUTO, "
cQry += "GRP_FAMILIA, "
cQry += "ID_GERENTE, " 
cQry += "NOME_GERENTE, "
cQry += "ID_VENDEDOR, " 
cQry += "NOME_VENDEDOR, "
cQry += "ANO_BASE, "
cQry += "SUM(QT_M01) AS QTM01, "
cQry += "SUM(QT_M02) AS QTM02, "
cQry += "SUM(QT_M03) AS QTM03, "
cQry += "SUM(QT_M04) AS QTM04, "
cQry += "SUM(QT_M05) AS QTM05, "
cQry += "SUM(QT_M06) AS QTM06, "
cQry += "SUM(QT_M07) AS QTM07, "
cQry += "SUM(QT_M08) AS QTM08, "
cQry += "SUM(QT_M09) AS QTM09, "
cQry += "SUM(QT_M10) AS QTM10, "
cQry += "SUM(QT_M11) AS QTM11, "
cQry += "SUM(QT_M12) AS QTM12, "
cQry += "SUM(VL_M01) AS VLM01, "
cQry += "SUM(VL_M02) AS VLM02, "
cQry += "SUM(VL_M03) AS VLM03, "
cQry += "SUM(VL_M04) AS VLM04, "
cQry += "SUM(VL_M05) AS VLM05, "
cQry += "SUM(VL_M06) AS VLM06, "
cQry += "SUM(VL_M07) AS VLM07, "
cQry += "SUM(VL_M08) AS VLM08, "
cQry += "SUM(VL_M09) AS VLM09, "
cQry += "SUM(VL_M10) AS VLM10, "
cQry += "SUM(VL_M11) AS VLM11, "
cQry += "SUM(VL_M12) AS VLM12, "
cQry += "SUM(REP_M01) AS REPM01, "
cQry += "SUM(REP_M02) AS REPM02, "
cQry += "SUM(REP_M03) AS REPM03, "
cQry += "SUM(REP_M04) AS REPM04, "
cQry += "SUM(REP_M05) AS REPM05, "
cQry += "SUM(REP_M06) AS REPM06, "
cQry += "SUM(REP_M07) AS REPM07, "
cQry += "SUM(REP_M08) AS REPM08, "
cQry += "SUM(REP_M09) AS REPM09, "
cQry += "SUM(REP_M10) AS REPM10, "
cQry += "SUM(REP_M11) AS REPM11, "
cQry += "SUM(REP_M12) AS REPM12, "
cQry += "SUM(QT_REAL_M01) AS QTREALM01, "
cQry += "SUM(QT_REAL_M02) AS QTREALM02, "
cQry += "SUM(QT_REAL_M03) AS QTREALM03, "
cQry += "SUM(QT_REAL_M04) AS QTREALM04, "
cQry += "SUM(QT_REAL_M05) AS QTREALM05, "
cQry += "SUM(QT_REAL_M06) AS QTREALM06, "
cQry += "SUM(QT_REAL_M07) AS QTREALM07, "
cQry += "SUM(QT_REAL_M08) AS QTREALM08, "
cQry += "SUM(QT_REAL_M09) AS QTREALM09, "
cQry += "SUM(QT_REAL_M10) AS QTREALM10, "
cQry += "SUM(QT_REAL_M11) AS QTREALM11, "
cQry += "SUM(QT_REAL_M12) AS QTREALM12, "
cQry += "SUM(VL_REAL_M01) AS VLREALM01, "
cQry += "SUM(VL_REAL_M02) AS VLREALM02, "
cQry += "SUM(VL_REAL_M03) AS VLREALM03, "
cQry += "SUM(VL_REAL_M04) AS VLREALM04, "
cQry += "SUM(VL_REAL_M05) AS VLREALM05, "
cQry += "SUM(VL_REAL_M06) AS VLREALM06, "
cQry += "SUM(VL_REAL_M07) AS VLREALM07, "
cQry += "SUM(VL_REAL_M08) AS VLREALM08, "
cQry += "SUM(VL_REAL_M09) AS VLREALM09, "
cQry += "SUM(VL_REAL_M10) AS VLREALM10, "
cQry += "SUM(VL_REAL_M11) AS VLREALM11, "
cQry += "SUM(VL_REAL_M12) AS VLREALM12 "
cQry += "FROM TBL_REPRESENTATIVIDADE "
cQry += "WHERE "
cQry += "ANO_BASE = '" + cCbAno + "' "
If !Empty(cCodVnd)
    cQry += "AND ID_VENDEDOR = '" + cCodVnd + "' " 
    cQry += "AND ID_PERIODO = '" + cCbAno + cMes + "' " 
EndIf
cQry += "GROUP BY ID_VENDEDOR, NOME_VENDEDOR, ID_GERENTE, NOME_GERENTE, COD_PRODUTO, DESCRICAO_PRODUTO, GRP_FAMILIA, ANO_BASE " 
cQry += "ORDER BY ID_VENDEDOR, NOME_VENDEDOR, ID_GERENTE, NOME_GERENTE, COD_PRODUTO, DESCRICAO_PRODUTO, GRP_FAMILIA, ANO_BASE " 

Iif(Select("WRKXDAT")>0,WRKXDAT->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXDAT",.T.,.T.)
TcSetField("WRKXDAT","QTM01","N",14,0)
TcSetField("WRKXDAT","QTM02","N",14,0)
TcSetField("WRKXDAT","QTM03","N",14,0)
TcSetField("WRKXDAT","QTM04","N",14,0)
TcSetField("WRKXDAT","QTM05","N",14,0)
TcSetField("WRKXDAT","QTM06","N",14,0)
TcSetField("WRKXDAT","QTM07","N",14,0)
TcSetField("WRKXDAT","QTM08","N",14,0)
TcSetField("WRKXDAT","QTM09","N",14,0)
TcSetField("WRKXDAT","QTM10","N",14,0)
TcSetField("WRKXDAT","QTM11","N",14,0)
TcSetField("WRKXDAT","QTM12","N",14,0)
TcSetField("WRKXDAT","VLM01","N",12,2)
TcSetField("WRKXDAT","VLM02","N",12,2)
TcSetField("WRKXDAT","VLM03","N",12,2)
TcSetField("WRKXDAT","VLM04","N",12,2)
TcSetField("WRKXDAT","VLM05","N",12,2)
TcSetField("WRKXDAT","VLM06","N",12,2)
TcSetField("WRKXDAT","VLM07","N",12,2)
TcSetField("WRKXDAT","VLM08","N",12,2)
TcSetField("WRKXDAT","VLM09","N",12,2)
TcSetField("WRKXDAT","VLM10","N",12,2)
TcSetField("WRKXDAT","VLM11","N",12,2)
TcSetField("WRKXDAT","VLM12","N",12,2)
TcSetField("WRKXDAT","REPM01","N",12,2)
TcSetField("WRKXDAT","REPM02","N",12,2)
TcSetField("WRKXDAT","REPM03","N",12,2)
TcSetField("WRKXDAT","REPM04","N",12,2)
TcSetField("WRKXDAT","REPM05","N",12,2)
TcSetField("WRKXDAT","REPM06","N",12,2)
TcSetField("WRKXDAT","REPM07","N",12,2)
TcSetField("WRKXDAT","REPM08","N",12,2)
TcSetField("WRKXDAT","REPM09","N",12,2)
TcSetField("WRKXDAT","REPM10","N",12,2)
TcSetField("WRKXDAT","REPM11","N",12,2)
TcSetField("WRKXDAT","REPM12","N",12,2)
TcSetField("WRKXDAT","QTREALM01","N",14,0)
TcSetField("WRKXDAT","QTREALM02","N",14,0)
TcSetField("WRKXDAT","QTREALM03","N",14,0)
TcSetField("WRKXDAT","QTREALM04","N",14,0)
TcSetField("WRKXDAT","QTREALM05","N",14,0)
TcSetField("WRKXDAT","QTREALM06","N",14,0)
TcSetField("WRKXDAT","QTREALM07","N",14,0)
TcSetField("WRKXDAT","QTREALM08","N",14,0)
TcSetField("WRKXDAT","QTREALM09","N",14,0)
TcSetField("WRKXDAT","QTREALM10","N",14,0)
TcSetField("WRKXDAT","QTREALM11","N",14,0)
TcSetField("WRKXDAT","QTREALM12","N",14,0)
TcSetField("WRKXDAT","VLREALM01","N",12,2)
TcSetField("WRKXDAT","VLREALM02","N",12,2)
TcSetField("WRKXDAT","VLREALM03","N",12,2)
TcSetField("WRKXDAT","VLREALM04","N",12,2)
TcSetField("WRKXDAT","VLREALM05","N",12,2)
TcSetField("WRKXDAT","VLREALM06","N",12,2)
TcSetField("WRKXDAT","VLREALM07","N",12,2)
TcSetField("WRKXDAT","VLREALM08","N",12,2)
TcSetField("WRKXDAT","VLREALM09","N",12,2)
TcSetField("WRKXDAT","VLREALM10","N",12,2)
TcSetField("WRKXDAT","VLREALM11","N",12,2)
TcSetField("WRKXDAT","VLREALM12","N",12,2)
WRKXDAT->(dbGoTop())

While WRKXDAT->(!EoF())

    If Empty(cCodVnd)

        aAdd(aDat,{;
            WRKXDAT->COD_PRODUTO,;
            WRKXDAT->DESCRICAO_PRODUTO,;
            WRKXDAT->GRP_FAMILIA,;
            WRKXDAT->ID_GERENTE,;
            WRKXDAT->NOME_GERENTE,;
            WRKXDAT->ID_VENDEDOR,;
            WRKXDAT->NOME_VENDEDOR,;
            WRKXDAT->ANO_BASE,;
            WRKXDAT->QTM01,;
            WRKXDAT->QTM02,;
            WRKXDAT->QTM03,;
            WRKXDAT->QTM04,;
            WRKXDAT->QTM05,;
            WRKXDAT->QTM06,;
            WRKXDAT->QTM07,;
            WRKXDAT->QTM08,;
            WRKXDAT->QTM09,;
            WRKXDAT->QTM10,;
            WRKXDAT->QTM11,;
            WRKXDAT->QTM12,;
            WRKXDAT->VLM01,;
            WRKXDAT->VLM02,;
            WRKXDAT->VLM03,;
            WRKXDAT->VLM04,;
            WRKXDAT->VLM05,;
            WRKXDAT->VLM06,;
            WRKXDAT->VLM07,;
            WRKXDAT->VLM08,;
            WRKXDAT->VLM09,;
            WRKXDAT->VLM10,;
            WRKXDAT->VLM11,;
            WRKXDAT->VLM12,;
            WRKXDAT->REPM01,;
            WRKXDAT->REPM02,;
            WRKXDAT->REPM03,;
            WRKXDAT->REPM04,;
            WRKXDAT->REPM05,;
            WRKXDAT->REPM06,;
            WRKXDAT->REPM07,;
            WRKXDAT->REPM08,;
            WRKXDAT->REPM09,;
            WRKXDAT->REPM10,;
            WRKXDAT->REPM11,;
            WRKXDAT->REPM12,;
            WRKXDAT->QTREALM01,;
            WRKXDAT->QTREALM02,;
            WRKXDAT->QTREALM03,;
            WRKXDAT->QTREALM04,;
            WRKXDAT->QTREALM05,;
            WRKXDAT->QTREALM06,;
            WRKXDAT->QTREALM07,;
            WRKXDAT->QTREALM08,;
            WRKXDAT->QTREALM09,;
            WRKXDAT->QTREALM10,;
            WRKXDAT->QTREALM11,;
            WRKXDAT->QTREALM12,;
            WRKXDAT->VLREALM01,;
            WRKXDAT->VLREALM02,;
            WRKXDAT->VLREALM03,;
            WRKXDAT->VLREALM04,;
            WRKXDAT->VLREALM05,;
            WRKXDAT->VLREALM06,;
            WRKXDAT->VLREALM07,;
            WRKXDAT->VLREALM08,;
            WRKXDAT->VLREALM09,;
            WRKXDAT->VLREALM10,;
            WRKXDAT->VLREALM11,;
            WRKXDAT->VLREALM12})

    Else

        aAdd(aDat,{;
            WRKXDAT->COD_PRODUTO,;
            WRKXDAT->DESCRICAO_PRODUTO,;
            WRKXDAT->GRP_FAMILIA,;
            WRKXDAT->ID_GERENTE,;
            WRKXDAT->NOME_GERENTE,;
            WRKXDAT->ID_VENDEDOR,;
            WRKXDAT->NOME_VENDEDOR,;
            WRKXDAT->ANO_BASE,;
            WRKXDAT->QTM01,;
            WRKXDAT->QTM02,;
            WRKXDAT->QTM03,;
            WRKXDAT->QTM04,;
            WRKXDAT->QTM05,;
            WRKXDAT->QTM06,;
            WRKXDAT->QTM07,;
            WRKXDAT->QTM08,;
            WRKXDAT->QTM09,;
            WRKXDAT->QTM10,;
            WRKXDAT->QTM11,;
            WRKXDAT->QTM12,;
            WRKXDAT->REPM01,;
            WRKXDAT->REPM02,;
            WRKXDAT->REPM03,;
            WRKXDAT->REPM04,;
            WRKXDAT->REPM05,;
            WRKXDAT->REPM06,;
            WRKXDAT->REPM07,;
            WRKXDAT->REPM08,;
            WRKXDAT->REPM09,;
            WRKXDAT->REPM10,;
            WRKXDAT->REPM11,;
            WRKXDAT->REPM12,;
            WRKXDAT->QTREALM01,;
            WRKXDAT->QTREALM02,;
            WRKXDAT->QTREALM03,;
            WRKXDAT->QTREALM04,;
            WRKXDAT->QTREALM05,;
            WRKXDAT->QTREALM06,;
            WRKXDAT->QTREALM07,;
            WRKXDAT->QTREALM08,;
            WRKXDAT->QTREALM09,;
            WRKXDAT->QTREALM10,;
            WRKXDAT->QTREALM11,;
            WRKXDAT->QTREALM12})

    EndIf

    WRKXDAT->(dbSkip())
EndDo
WRKXDAT->(dbCloseArea())

Return(Nil)



//*******************************************************************************************
// Funcao:     GEMAIL
// Finalidade: Chama funcao que gera a lista dos e-mails a serem enviados
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function GEmail( cCbMes, cCbAno, cEmlTst, cEnvSrv )
Local lGo := .T.
Local cMes := RetMesN( cCbMes )
Local cMsg := ""

If lGo
    ChkDados( @cMsg, cMes, cCbMes, cCbAno, "P" )
    If !Empty(cMsg)
        lGo := .F.
    EndIf
EndIf

If lGo
    LSTEMAIL( cCbMes, cCbAno, cEmlTst, cEnvSrv )
EndIf

Return(Nil)



//*******************************************************************************************
// Funcao:     RETMESN
// Finalidade: Retorna o mes em formato NN (caracter)
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function RetMesN(cCbMes)
Local cRet := ""
Local cAux := SubStr(Upper(Alltrim(cCbMes)),1,3)

If cAux == "JAN"
    cRet := "01"
ElseIf cAux == "FEV"
    cRet := "02"
ElseIf cAux == "MAR"
    cRet := "03"
ElseIf cAux == "ABR"
    cRet := "04"
ElseIf cAux == "MAI"
    cRet := "05"
ElseIf cAux == "JUN"
    cRet := "06"
ElseIf cAux == "JUL"
    cRet := "07"
ElseIf cAux == "AGO"
    cRet := "08"
ElseIf cAux == "SET"
    cRet := "09"
ElseIf cAux == "OUT"
    cRet := "10"
ElseIf cAux == "NOV"
    cRet := "11"
ElseIf cAux == "DEZ"
    cRet := "12"
EndIf

Return(cRet)



//*******************************************************************************************
// Funcao:     CHKDADOS
// Finalidade: Verifica se ha' pelo menos um registro gerado para o periodo informado
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function ChkDados( cMsg, cMes, cCbMes, cCbAno, cTpPsq )
Local lRet := .T.
Local lTbl := .T.
Local lHaD := .F.
Local cQry := ""
Default cTpPsq := ""

If TcCanOpen("TBL_REPRESENTATIVIDADE")

    cQry := "SELECT COUNT(*) AS QTDR FROM TBL_REPRESENTATIVIDADE WHERE ID_PERIODO = '" + cCbAno + cMes + "'"

    Iif(Select("WRKQREC")>0,WRKQREC->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKQREC",.T.,.T.)
    TcSetField("WRKQREC","QTDR","N",12,0)
    WRKQREC->(dbGoTop())

    If WRKQREC->(!EoF())
        If WRKQREC->QTDR > 0
            lHaD := .T.
        EndIf
    EndIf
    WRKQREC->(dbCloseArea())

Else

    lTbl := .F.

EndIf

If lTbl
    If cTpPsq == "P"
        If lHaD
            lRet := .T.
            cMsg := ""
        Else
            lRet := .F.
            cMsg := "Não há dados para o período de " +cCbMes+ " de " +cCbAno+ "."
        EndIf
    Else
        lRet := .T.
        If lHaD
            cMsg := "Já existem dados para o período de " +cCbMes+ " de " +cCbAno+ ". Deseja reprocessar os dados deste período ?"
        Else
            cMsg := "Confirma a geração dos dados para o período de " +cCbMes+ " de " +cCbAno+ " ?"
        EndIf
    EndIf
Else
    lRet := .F.
    cMsg := "ERRO: tabela TBL_REPRESENTATIVIDADE nao encontrada no banco de dados deste ambiente. Contacte o Administrador do Sistema."
EndIf

Return(lRet)



//*******************************************************************************************
// Funcao:     LSTEMAIL
// Finalidade: Tela para selecionar os destinatarios dos e-mails
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function LSTEMAIL( cCbMes, cCbAno, cEmlTst, cEnvSrv )
Local oBtAtuE := Nil
Local oBtDes := Nil
Local oBtSair := Nil
Local oBtTd := Nil
Local oBtEnvE := Nil
Local oGtBody := Nil
Local oGtSubj := Nil
Local oSyBody := Nil
Local oSyDest := Nil
Local oSySubj := Nil
Local oLbxDest := Nil
Local oDgMail := Nil
Local aLbxDest := {}
Local cTitDlg := ""
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local cGtSubj := PadR("Desafio de Vendas - " +cCbMes+ " de " + cCbAno, 200)
Local cGtBody := SuperGetMV("TFGDESVDE2",,'<p><strong>Caro Vendedor,</strong></p><p><strong>Segue Desafio X Faturado por produto no m&ecirc;s vigente.</strong></p><p>Obs.: esta &eacute; uma mensagem autom&aacute;tica, n&atilde;o responda.</p><p>&nbsp;</p>')

cGtBody := PadR(cGtBody,250)

GtLstEml( cCbAno, @aLbxDest )



If Len(aLbxDest) > 0

    If Empty(cEmlTst)
        cTitDlg := "Selecione os destinatários dos E-Mails - Ref. " +cCbMes+ " de " +cCbAno
    Else
        cTitDlg := "Sel. dests E-Mails - Ref. " +cCbMes+ "/" +cCbAno+ " [TESTE ATIVADO] Dest.: "+cEmlTst
    EndIf

    DEFINE MSDIALOG oDgMail TITLE cTitDlg FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL

        @ 002, 002 SAY oSySubj PROMPT "Assunto" SIZE 181, 007 OF oDgMail COLORS 0, 16777215 PIXEL
        @ 011, 002 MSGET oGtSubj VAR cGtSubj SIZE 346, 010 OF oDgMail COLORS 0, 16777215 PIXEL
        @ 030, 002 SAY oSyBody PROMPT "Corpo do E-Mail (aceita formatação HTML)" SIZE 345, 007 OF oDgMail COLORS 0, 16777215 PIXEL
        @ 038, 002 GET oGtBody VAR cGtBody OF oDgMail MULTILINE SIZE 346, 031 COLORS 0, 16777215 HSCROLL PIXEL
        @ 078, 002 SAY oSyDest PROMPT "Destinatários do E-Mail" SIZE 341, 007 OF oDgMail COLORS 0, 16777215 PIXEL
        @ 087, 002 LISTBOX oLbxDest Fields HEADER "-","Código","Nome Vendedor","E-Mail" SIZE 346, 142 OF oDgMail PIXEL ColSizes 50,50
        oLbxDest:SetArray(aLbxDest)
        oLbxDest:bLine := {||{IIf(aLbxDest[oLbxDest:nAt,1],oOk,oNo),aLbxDest[oLbxDest:nAt,2],aLbxDest[oLbxDest:nAt,3],aLbxDest[oLbxDest:nAt,4]}}
        oLbxDest:bLDblClick := {||aLbxDest[oLbxDest:nAt,1]:=!aLbxDest[oLbxDest:nAt,1],oLbxDest:DrawSelect()}
        @ 234, 002 BUTTON oBtTd PROMPT "Marca Todos" Action(aEval(aLbxDest,{|x|x[1]:=.T.}),oLbxDest:Refresh(),oDgMail:Refresh()) SIZE 047, 012 OF oDgMail PIXEL
        @ 234, 051 BUTTON oBtDes PROMPT "Desmarca Todos" Action(aEval(aLbxDest,{|x|x[1]:=.F.}),oLbxDest:Refresh(),oDgMail:Refresh()) SIZE 053, 012 OF oDgMail PIXEL
        @ 234, 106 BUTTON oBtAtuE PROMPT "Atualizar E-Mail do Destinatário Selecionado" Action(AtEml(@aLbxDest,@oLbxDest),oLbxDest:Refresh(),oDgMail:Refresh()) SIZE 111, 012 OF oDgMail PIXEL
        @ 234, 219 BUTTON oBtEnvE PROMPT "Enviar E-Mails Selecionados" Action(Iif(EnvEml(Alltrim(cGtSubj),Alltrim(cGtBody),aLbxDest,cCbMes,cCbAno,cEmlTst,cEnvSrv),oDgMail:End(),Nil)) SIZE 087, 012 OF oDgMail PIXEL
        @ 234, 307 BUTTON oBtSair PROMPT "Sair" Action(oDgMail:End())SIZE 040, 012 OF oDgMail PIXEL

    ACTIVATE MSDIALOG oDgMail CENTERED

Else

    Alert("Não há dados para o período de " +cCbMes+ " de " +cCbAno ) 

EndIf

Return(Nil)



//*******************************************************************************************
// Funcao:     GTLSTEML
// Finalidade: Gera lista dos e-mails a serem enviados
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static FuncTion GtLstEml( cCbAno, aLbxDest ) 
Local cQry := ""

aLbxDest := {}

cQry := "SELECT DISTINCT " 
cQry += "A.ID_VENDEDOR AS CODV, "
cQry += "A.NOME_VENDEDOR AS NOMV, "
cQry += "ISNULL(B.A3_EMAIL,'') AS EMAIL "
cQry += "FROM TBL_REPRESENTATIVIDADE A "
cQry += "INNER JOIN SA3030 B ON B.D_E_L_E_T_ = ' ' "
cQry += "AND B.A3_FILIAL = '02' "
cQry += "AND B.A3_COD = A.ID_VENDEDOR "
cQry += "AND B.A3_MSBLQL <> '1' "
cQry += "WHERE ANO_BASE = '" +cCbAno+ "' "
cQry += "ORDER BY A.ID_VENDEDOR"

Iif(Select("WRKALST")>0,WRKALST->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKALST",.T.,.T.)
WRKALST->(dbGoTop())

While WRKALST->(!EoF())
    aAdd( aLbxDest, {   .T.,;
                        Alltrim(WRKALST->CODV),;
                        Alltrim(WRKALST->NOMV),;
                        Alltrim(WRKALST->EMAIL) })
    WRKALST->(dbSkip())
EndDo
WRKALST->(dbCloseArea())

Return(Nil)



//*******************************************************************************************
// Funcao:     ATEML
// Finalidade: Cria tela para atualizar o endereco de e-mail
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function AtEml(aLbxDest,oLbxDest)
Local oBtNo := Nil
Local oBtOK := Nil
Local oCkVnd := Nil
Local oGEmAt := Nil
Local oGtNEm := Nil
Local oSy1 := Nil
Local oSy2 := Nil
Local oDgAtE := Nil
Local lCkVnd := .T.
Local cGEmAt := Alltrim(aLbxDest[oLbxDest:nAt,4])
Local cGtNEm := Space(300)

If Empty(cGEmAt)
    cGEmAt := "<vazio>"
EndIf

DEFINE MSDIALOG oDgAtE TITLE "Atualiza E-Mail" FROM 000, 000  TO 130, 600 COLORS 0, 16777215 PIXEL

    @ 002, 002 SAY oSy1 PROMPT "E-Mail atual de "+Alltrim(aLbxDest[oLbxDest:nAt,2])+" - "+Alltrim(aLbxDest[oLbxDest:nAt,3])+":" SIZE 294, 008 OF oDgAtE COLORS 0, 16777215 PIXEL
    @ 011, 002 MSGET oGEmAt VAR cGEmAt SIZE 296, 010 OF oDgAtE When .F. COLORS 0, 16777215 PIXEL
    @ 027, 002 SAY oSy2 PROMPT "Novo E-Mail:" SIZE 197, 007 OF oDgAtE COLORS 0, 16777215 PIXEL
    @ 036, 002 MSGET oGtNEm VAR cGtNEm SIZE 296, 010 OF oDgAtE COLORS 0, 16777215 PIXEL
    @ 052, 002 CHECKBOX oCkVnd VAR lCkVnd PROMPT "Atualiza E-Mail no Cadastro de Vendedor" SIZE 187, 008 OF oDgAtE COLORS 0, 16777215 PIXEL
    @ 050, 202 BUTTON oBtOK PROMPT "Atualizar" Action(Iif(VldNEml(lCkVnd,Alltrim(cGtNEm),oLbxDest,@aLbxDest),oDgAtE:End(),Nil)) SIZE 049, 012 OF oDgAtE PIXEL
    @ 050, 256 BUTTON oBtNo PROMPT "Cancelar" Action(oDgAtE:End()) SIZE 042, 012 OF oDgAtE PIXEL

ACTIVATE MSDIALOG oDgAtE CENTERED

Return(Nil)



//*******************************************************************************************
// Funcao:     VLDNEML
// Finalidade: Checa se o e-mail e' valido, e atualiza o cadastro do vendedor
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function VldNEml( lCkVnd, cGtNEm, oLbxDest, aLbxDest )
Local lGo := .T.
Local cMsg := ""
Local aChr := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
Local lMasc := .F.

If Empty(cGtNEm)
    lGo := .F.
    cMsg := "Novo E-Mail não informado"
EndIf

If lGo
    If ( !("@" $ cGtNEm) .Or. !("." $ cGtNEm) )
        lGo := .F.
        cMsg := "Novo E-Mail é inválido"
    EndIf
EndIf

If lGo
    aEval(aChr,{|x|Iif(x$cGtNEm,lMasc:=.T.,Nil)})
    If lMasc
        lGo := MsgYesNo("Existem caracteres em maiúsculo no novo E-Mail. Está correto ?")
    EndIf
EndIf

If lGo
    aLbxDest[oLbxDest:nAt,4] := Alltrim(cGtNEm)
    If lCkVnd
        TcSqlExec("UPDATE SA3030 SET A3_EMAIL = '"+cGtNEm+"' WHERE D_E_L_E_T_ = ' ' AND A3_COD = '"+aLbxDest[oLbxDest:nAt,2]+"'")
    EndIf
EndIf

If !Empty(cMsg)
    Alert(cMsg)
EndIf

Return(lGo)



//*******************************************************************************************
// Funcao:     ENVEML
// Finalidade: Gera arquivo a ser anexado e e envia e-mail para os destinatarios selecionados
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function EnvEml( cGtSubj, cGtBody, aLbxDest, cCbMes, cCbAno, cEmlTst, cEnvSrv )
Local lGo := .T.
Local lSel := .F.
Local cMsg := ""
Local cAnx := ""
Local nNx := 0
Local aErr := ""

For nNx := 1 to Len(aLbxDest)

    If aLbxDest[nNx,1]

        lSel := .T.

        If Empty(aLbxDest[nNx,4])

            lGo := .F.
            cMsg += "Vend. " +Alltrim(aLbxDest[nNx,2])+ " sem E-Mail informado"+CRLF

        Else

            If( !("@"$Alltrim(aLbxDest[nNx,4])) .Or. !("."$Alltrim(aLbxDest[nNx,4])) )
                lGo := .F.
                cMsg += "Vend. " +Alltrim(aLbxDest[nNx,2])+ " com E-Mail inválido"+CRLF
            EndIf

        EndIf

    EndIf

Next nNx

If !lSel
    lGo := .F.
    cMsg += "Nenhum vendedor marcado para envio do E-Mail"+CRLF
EndIf

If lGo
    lGo := MsgYesNo("Confirma o envio dos E-Mail(s) marcado(s)?")
    If lGo
        For nNx := 1 to Len(aLbxDest)
            If aLbxDest[nNx,1] .And. lGo        
                cAnx := ""
                MsgRun("Gerando Anexo do Vendedor "+Alltrim(aLbxDest[nNx,3]),"",{||cAnx:=GPlan(cCbMes,cCbAno,"",aLbxDest[nNx,2],"A")})
                If !Empty(cAnx)
                    MsgRun("Enviando e-mail para "+Alltrim(aLbxDest[nNx,4]),"",{||cMsg:=U_TFEMail(Alltrim(aLbxDest[nNx,4]),Alltrim(cGtBody),Alltrim(cGtSubj),Alltrim(cAnx),cEmlTst,cEnvSrv)})
                Else
                    Alert("Não foi possível gerar anexo do vendedor "+Alltrim(aLbxDest[nNx,3]))
                EndIf
                If !Empty(cMsg)
                    aAdd(aErr,cMsg)
                    Alert(cMsg)
                EndIf    
            EndIf
        Next nNx
        cMsg := ""
    Else
        lGo := .F.
    EndIf
EndIf

If !lGo .And. !Empty(cMsg)
    cMsg := "Os E-Mail(s) não serão enviados devido ao(s) erro(s) abaixo:" +CRLF+CRLF+cMsg
    Alert(cMsg)
EndIf

Return(lGo)



//*******************************************************************************************
// Funcao:     TFEMAIL
// Finalidade: Faz o envio de e-mails
// Autor:      Ronald Piscioneri
// Data:       02-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
User Function TFEMail( cTo, cBody, cSubJ, cFile, cEmlTst, cEnvSrv )
Local oMailServer 	:= TMailManager():New()
Local oMessage 		:= TMailMessage():New()
Local cSMTPSrv 	    := SuperGetMV("TFEML001",,"smtp.gmail.com")
Local cSMTPSnh	    := SuperGetMV("TFEML002",,"n#iJE7#2")
Local cSMTPCta	    := SuperGetMV("TFEML003",,"workflow@taiff.com.br")
Local nSMTPPta	    := SuperGetMV("TFEML004",,587)
Local cMsgErro      := ""
Local nErro 		:= 0
Local lGo           := .T.
Default cEmlTst     := ""
Default cEnvSrv     := ""

// E-mails de teste
If !Empty(cEmlTst)

    cSubj := "[TESTE] " +cSubj
    cBody += "<p></p>"
    cBody += "<p>ATENÇÃO: ESTE É UM E-MAIL DE TESTE.</p>"
    cBody += '<p>Destinatario original deste e-mail: '+cTo+ '</p>'
    If !Empty(cEnvSrv)
        cBody += '<p>Ambiente Protheus: ' +cEnvSrv+ '</p>'
    EndIf

    cTo := cEmlTst

EndIf

oMailServer:SetUseSSL( .F. )
oMailServer:SetUseTLS( .T. )
oMailServer:Init( "", cSMTPSrv, cSMTPCta, cSMTPSnh , 0, nSMTPPta )

If ( (nErro := oMailServer:SmtpConnect()) <> 0 )

    lGo := .F.
    cMsgErro := oMailServer:GetErrorString( nErro )

EndIf

If lGo  

	nErro := oMailServer:SmtpAuth( cSMTPCta,cSMTPSnh )
	If nErro <> 0
        lGo := .F.
        cMsgErro := oMailServer:GetErrorString( nErro )
	Endif

EndIf

If lGo

	oMessage:Clear()
	oMessage:cFrom           := "workflow@taiff.com.br"
	oMessage:cTo             := cTo
	oMessage:cCc             := ""
	oMessage:cBcc            := ""
	oMessage:cSubject        := cSubj
	oMessage:cBody           := cBody
    oMessage:AddCustomHeader( 'Content-Type','text/html')

    If !Empty(cFile)
        nErro := oMessage:AttachFile( cFile )
        If nErro <> 0
            lGo := .F.
            cMsgErro := oMailServer:GetErrorString( nErro )
        Endif
    EndIf

EndIf

If lGo
	nErro := oMessage:Send( oMailServer )
	If nErro <> 0
        lGo := .F.
        cMsgErro := oMailServer:GetErrorString( nErro )
	Endif
    If lGo
        nErro := oMailServer:SmtpDisconnect()
        If nErro <> 0
            lGo := .F.
            cMsgErro := oMailServer:GetErrorString( nErro )
        Endif
    EndIf
EndIf

If !Empty(cMsgErro)
    cMsgErro := "ERRO: e-mail para " +Alltrim(cTo)+ " não enviado - " +cMsgErro
EndIf

Return(cMsgErro)
