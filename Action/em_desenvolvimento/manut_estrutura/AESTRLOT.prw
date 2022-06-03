#Include "PROTHEUS.CH"
//--------------------------------------------------------------
// Funcao:     AESTRLOT
// Finalidade: Altera Estrutura em Lote (PCP)
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------

User Function AESTRLOT()
Local oBtPrc, oBtSair, oGp1, oGp2, oGp3, oRd1, oSay1, oSay2, oDg1 := Nil
Local aAAFlds := { "ACODPRO", "AAQTD", "ANQTD" }
Local aNAFlds := { "NCODPRO", "NNQTD" }
Local aHeadA := {}
Local aHeadN := {}
Local nRd1 := 1
Local cMsg := ""
Local cEmpFil := SuperGetMV( "AESTRLOT1",, "|0401|0402|" )
Private oGDA := Nil
Private oGDN := Nil
Private aColsA := {}
Private aColsN := {}
Private aComps := {}
Private cMGt1 := ""
Private cMGt2 := ""
Private cSG1Tbl := ""
Private cSG1Fil := ""
Private cSB1Tbl := ""
Private cSB1Fil := ""

If  ( ( cEmpAnt + cFilAnt ) $ cEmpFil )

    cSG1Tbl := RetSqlName("SG1")
    cSG1Fil := xFilial("SG1")
    cSB1Tbl := RetSqlName("SB1")
    cSB1Fil := xFilial("SB1")

    RtCmpCod()

    If Len(aComps) > 0

        cMGt1 := Space(9999)
        cMGt2 := Space(9999)

        aAdd( aHeadA, { "Cód. Produto", "ACODPRO", "@!", 15, 0, "U_TFVLDPRD()", , "C", "SB1", "" } )
        aAdd( aHeadA, { "Descrição do Produto", "ADESPRO", "@!", 50, 0, "AllwaysFalse()", , "C", , "" } )
        aAdd( aHeadA, { "Qtd.Atual", "AAQTD", "@E 999,999.99", 12, 2, "AllwaysTrue()", , "N", , "" } )
        aAdd( aHeadA, { "Nova Qtd.", "ANQTD", "@E 999,999.99", 12, 2, "AllwaysTrue()", , "N", , "" } )
        aAdd( aHeadA, { "UM", "AUNMED", "@!", 4, 0, "AllwaysFalse()", , "C", , "" } )

        aAdd( aHeadN, { "Cód. Produto", "NCODPRO", "@!", 15, 0, "U_TFVLDPRD('B')", , "C", "SB1", "" } )
        aAdd( aHeadN, { "Descrição do Produto", "NDESPRO", "@!", 100, 0, "AllwaysFalse()", , "C", , "" } )
        aAdd( aHeadN, { "Qtd.", "NNQTD", "@!E 999,999.99", 12, 2, "AllwaysTrue()", , "N", , "" } )
        aAdd( aHeadN, { "UM", "NUNMED", "@!", 4, 0, "AllwaysFalse()", , "C", , "" } )

        DEFINE MSDIALOG oDg1 TITLE "Manutenção na Estrutura de Produtos Acabados" FROM 000, 000  TO 620, 696 COLORS 0, 16777215 PIXEL

            @ 005, 005 GROUP oGp1 TO 117, 344 PROMPT "Componentes Atuais da Estrutura" OF oDg1 COLOR 0, 16777215 PIXEL
            oGDA := MsNewGetDados():New( 013, 009, 065, 340, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aAAFlds,, 999, "AllwaysTrue", "", "AllwaysTrue", oDg1, aHeadA, aColsA,,,{{"ACODPRO",30},{"ADESPRO",130},{"AAQTD",30},{"ANQTD",30},{"AUNMED",20}})
            @ 077, 009 GET oMGt1 VAR cMGt1 OF oDg1 MULTILINE SIZE 331, 034 COLORS 0, 16777215 HSCROLL PIXEL
            @ 069, 009 SAY oSay1 PROMPT "Observações (serão acrescentadas aos produtos que serão desativados):" SIZE 303, 007 OF oDg1 COLORS 0, 16777215 PIXEL
            @ 120, 005 GROUP oGp2 TO 168, 344 PROMPT "Quanto aos novos componentes:" OF oDg1 COLOR 0, 16777215 PIXEL
            @ 129, 011 RADIO oRd1 VAR nRd1 ITEMS "Substituição","Inclusão","Desativação","Alteração Qtd" SIZE 331, 035 OF oDg1 COLOR 0, 16777215 PIXEL
            @ 172, 005 GROUP oGp3 TO 287, 344 PROMPT "Novo componente" OF oDg1 COLOR 0, 16777215 PIXEL
            oGDN := MsNewGetDados():New( 181, 009, 233, 340, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aNAFlds,, 999, "AllwaysTrue", "", "AllwaysTrue", oDg1, aHeadN, aColsN,,,{{"NCODPRO",40},{"NDESPRO",140},{"NNQTD",40},{"NUNMED",30}})
            @ 247, 009 GET oMGt2 VAR cMGt2 OF oDg1 MULTILINE SIZE 331, 034 COLORS 0, 16777215 HSCROLL PIXEL
            @ 292, 244 BUTTON oBtPrc PROMPT "Processa" Action (Iif(VldDados(nRd1,oGDA,oGDN,@cMsg),PrcData(nRd1),Alert("Erro. Verifique as seguintes inconsistências:"+CRLF+CRLF+cMsg))) SIZE 057, 012 OF oDg1 PIXEL
            @ 292, 307 BUTTON oBtSair PROMPT "Sair" Action(Iif(MsgYesNo("Sair da rotina?"),oDg1:End(),Nil)) SIZE 037, 012 OF oDg1 PIXEL
            @ 239, 009 SAY oSay2 PROMPT "Observações (serão acrescentadas aos novos produtos):" SIZE 304, 007 OF oDg1 COLORS 0, 16777215 PIXEL

        ACTIVATE MSDIALOG oDg1 CENTERED
    
    Else

        MsgInfo( "Impossível prosseguir com a manutenção de estrutura de produtos em lote: não há estruturas de produtos válidas nesta empresa/filial" )

    EndIf

Else

    MsgInfo( "Uso não permitido nesta empresa / filial" )

EndIf

Return( Nil )



//--------------------------------------------------------------
// Funcao:     VLDDADOS
// Finalidade: Valida se os dados informados na tela correspondem
//             a operacao escolhida
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function VldDados( nRd1, oGDA, oGDN, cMsg )
Local lRet := .T.
Local lItA := .F.
Local lItN := .F.
Local lZQA := .F.
Local lZNQ := .F.
Local lZQN := .F.
Local lVPA := .F.
Local lVPN := .F.

cMsg := ""

aEval( oGDA:aCols, { |x| Iif( !x[6], Iif( !Empty(x[1]), lItA := .T., Nil ) , Nil )})
aEval( oGDN:aCols, { |x| Iif( !x[5], Iif( !Empty(x[1]), lItN := .T., Nil ) , Nil )})
aEval( oGDA:aCols, { |x| Iif( !x[6], Iif( x[3] <= 0, lZQA := .T., Nil ) , Nil )})
aEval( oGDA:aCols, { |x| Iif( !x[6], Iif( x[4] <= 0, lZNQ := .T., Nil ) , Nil )})
aEval( oGDN:aCols, { |x| Iif( !x[5], Iif( x[3] <= 0, lZQN := .T., Nil ) , Nil )})

If nRd1 == 1 // Substituicao

    If !lItA
        cMsg += "- Informe o(s) componente(s) atual(is)."+CRLF
    EndIf
    If lZQA
        cMsg += "- Informe a quantidade do(s) componente(s) atual(is)."+CRLF
    EndIf
    If !lItN
        cMsg += "- Informe o(s) novo(s) componente(s)."+CRLF
    EndIf
    If lZQN
        cMsg += "- Informe a quantidade do(s) novos componente(s)."+CRLF
    EndIf
    If Empty(Alltrim(cMGt1))
        cMsg += "- Faltam observações para os componentes atuais."+CRLF
    EndIf
    If Empty(Alltrim(cMGt2))
        cMsg += "- Faltam observações para os novos componentes"+CRLF
    EndIf

    lVPA := .T.
    lVPN := .T.

ElseIf nRd1 == 2 // Inclusao

    If !lItA
        cMsg += "- Informe o(s) componente(s) atual(is)."+CRLF
    EndIf
    If lZQA
        cMsg += "- Informe a quantidade do(s) componente(s) atual(is)."+CRLF
    EndIf
    If !lItN
        cMsg += "- Informe o(s) novo(s) componente(s)."+CRLF
    EndIf
    If lZQN
        cMsg += "- Informe a quantidade do(s) novos componente(s)."+CRLF
    EndIf
    If !Empty(Alltrim(cMGt1))
        cMsg += "- Não informe observações para os componentes atuais."+CRLF
    EndIf
    If Empty(Alltrim(cMGt2))
        cMsg += "- Faltam observações para os novos componentes"+CRLF
    EndIf

    lVPA := .T.
    lVPN := .T.

ElseIf nRd1 == 3 // Desativacao

    If !lItA
        cMsg += "- Informe o(s) componente(s) atual(is)."+CRLF
    EndIf
    If lZQA
        cMsg += "- Informe a quantidade do(s) componente(s) atual(is)."+CRLF
    EndIf
    If lItN
        cMsg += "- Para desativar componentes atuais, não é necessário informar novos componentes."+CRLF
    EndIf
    If Empty(Alltrim(cMGt1))
        cMsg += "- Faltam observações para os componentes atuais."+CRLF
    EndIf
    If !Empty(Alltrim(cMGt2))
        cMsg += "- Não informe observações para os novos componentes"+CRLF
    EndIf

    lVPA := .T.

ElseIf nRd1 == 4 // Alteracao Qtd

    If !lItA
        cMsg += "- Informe o(s) componente(s) atual(is)."+CRLF
    EndIf
    If lZNQ
        cMsg += "- Informe a nova quantidade do(s) componente(s) atual(is)."+CRLF
    EndIf
    If lItN
        cMsg += "- Para alterar a quantidade do(s) componente(s) atual(is), não é necessário informar novo(s) componente(s)."+CRLF
    EndIf
    If Empty(Alltrim(cMGt1))
        cMsg += "- Faltam observações para os componentes atuais."+CRLF
    EndIf
    If !Empty(Alltrim(cMGt2))
        cMsg += "- Não informe observações para os novos componentes"+CRLF
    EndIf

    lVPA := .T.

Else

    cMsg := "Informe uma operação válida: substituição, inclusão, desativação ou alteração de quantidade."

EndIf

If !Empty(cMsg)
    lRet := .F.
EndIf

Return( lRet )



//--------------------------------------------------------------
// Funcao:     TFVLDPRD
// Finalidade: Valida se o componente e valido
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
User Function TFVLDPRD(cOrigP)
Local lRet := .F.
Local cQry := ""
Local cMsg := ""
Local cCodP := ""
Local cDescP := ""
Default cOrigP := "A"

If cOrigP == "A"
    cCodP := Upper(Alltrim(M->ACODPRO))
Else
    cCodP := Upper(Alltrim(M->NCODPRO))
EndIf

cQry := "SELECT "
cQry += "B1_DESC AS DESCP, "
cQry += "B1_MSBLQL AS BLOQ "
cQry += "FROM " +cSB1Tbl+ " "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND B1_FILIAL = '" +cSB1Fil+ "' "
cQry += "AND B1_COD = '" +cCodP+ "' "

Iif(Select("WRKXB1")>0,WRKXB1->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXB1",.T.,.T.)
WRKXB1->(dbGoTop())

If WRKXB1->(!EoF())
    If !Empty(WRKXB1->DESCP)
        If WRKXB1->BLOQ == "1"
            cMsg := "Produto bloqueado"
        Else
            cDescP := Alltrim(WRKXB1->DESCP)
        EndIf
    Else
        cMsg := "Codigo de produto invalido"
    EndIf
Else
    cMsg := "Codigo de produto invalido"
EndIf
WRKXB1->(dbCloseArea())



If cOrigP == "A"
    
    If Empty(cMsg)

        If ( aScan( aComps,{ |x| x[1] == cCodP }) == 0 )
            cMsg := "Este produto não pode ser escolhido, pois não é usado em nenhuma estrutura"
            cDescP := ""
        EndIf

    EndIf

    oGDA:aCols[oGDA:nAt,2] := cDescP
    oGDA:Refresh()

Else

    oGDN:aCols[oGDN:nAt,2] := cDescP
    oGDN:Refresh()

EndIf

If Empty(cMsg)
    lRet := .T.
Else
    Alert(cMsg)
EndIf
 
Return(lRet)



//--------------------------------------------------------------
// Funcao:     PRCDATA
// Finalidade: Pesquisa o BD e monta a lista de PAs
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function PrcData(nRd1)
Local cQry := ""
Local cMsg := ""
Local aALbx := {}
Local nNx := 0
Local lGo := .F.

For nNx := 1 to Len(oGDA:aCols)
    If !oGDA:aCols[nNx,6]
        lGo := .T.
    EndIf
Next nNx

If !lGo
    cMsg := "Nao há componentes válidos para pesquisa"
EndIf

If lGo

    cQry := "SELECT DISTINCT "
    cQry += "A.G1_COD AS G1COD, "
    cQry += "C.B1_DESC AS B1DESC "
    cQry += "FROM " 
    cQry += cSG1Tbl+ " A, "
    cQry += cSB1Tbl+ " C "
    cQry += "WHERE A.D_E_L_E_T_ = ' ' "
    cQry += "AND A.G1_FILIAL = '" +cSG1Fil+ "' "
    cQry += "AND A.D_E_L_E_T_ = ' ' "
    cQry += "AND C.B1_FILIAL = '" +cSB1Fil+ "' "
    cQry += "AND C.B1_COD = A.G1_COD "
    For nNx := 1 to Len(oGDA:aCols)
        If !oGDA:aCols[nNx,6]
            cQry += "AND ( "
            cQry += "SELECT COUNT(B.R_E_C_N_O_) FROM " +cSG1Tbl+ " B WHERE B.D_E_L_E_T_ = A.D_E_L_E_T_ "
            cQry += "AND B.G1_FILIAL = A.G1_FILIAL "
            cQry += "AND B.G1_COD = A.G1_COD "
            cQry += "AND B.G1_COMP = '" +Alltrim(oGDA:aCols[nNx,1])+ "' "
            cQry += "AND B.G1_QUANT = " +Alltrim(Str(oGDA:aCols[nNx,3]))+ " "
            cQry += "AND B.G1_FIM >= " +Alltrim(DtoS(Date()))+ " "
            cQry += ") > 0 "
        EndIf
    Next nNx

    Iif(Select("WRKXG1")>0,WRKXG1->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXG1",.T.,.T.)
    WRKXG1->(dbGoTop())

    While WRKXG1->(!EoF())
        If !Empty(WRKXG1->G1COD)
            aAdd( aALbx, { .F., Alltrim(WRKXG1->G1COD), Alltrim(WRKXG1->B1DESC) } )
        EndIf
        WRKXG1->(dbSkip())
    EndDo
    WRKXG1->(dbCloseArea())

    If Len(aALbx) > 0
        SelProd(aALbx,nRd1)
    Else
        lGo := .F.
        cMsg := "Não há produtos com os componentes que foram informados"
    EndIf

EndIf

If !Empty(cMsg)
    Alert(cMsg)
EndIf

Return(Nil)



//--------------------------------------------------------------
// Funcao:     RTCMPCOD
// Finalidade: Retorna lista de componentes atuais validos
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function RtCmpCod()
Local cQry := ""

aComps := {}

cQry := "SELECT DISTINCT "
cQry += "A.G1_COMP AS G1COMP, "
cQry += "CASE WHEN B.B1_MSBLQL = '1' THEN 'S' ELSE '' END AS B1MSBLQL "
cQry += "FROM "
cQry += cSG1Tbl+ " A, "
cQry += cSB1Tbl+ " B "
cQry += "WHERE "
cQry += "A.D_E_L_E_T_ = ' ' "
cQry += "AND A.G1_FILIAL = '" +cSG1Fil+ "' "
cQry += "AND B.D_E_L_E_T_ = A.D_E_L_E_T_ "
cQry += "AND B.B1_FILIAL = '" +cSB1Fil+ "' "
cQry += "AND B.B1_COD = A.G1_COMP "
cQry += "ORDER BY A.G1_COMP "

Iif(Select("WRKXG1")>0,WRKXG1->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXG1",.T.,.T.)
WRKXG1->(dbGoTop())

While WRKXG1->(!EoF())

    aAdd( aComps, { Upper(Alltrim(WRKXG1->G1COMP)), Upper(Alltrim(WRKXG1->B1MSBLQL)) })

    WRKXG1->(dbSkip())
EndDo
WRKXG1->(dbCloseArea())

Return(Nil)



//--------------------------------------------------------------
// Funcao:     SELPROD
// Finalidade: Monta tela de selecao de produtos
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function SelProd(aALbx,nRd1)
Local oBMT, oBDT, oBCF, oBSR, oSay1, oALbx, oDg2 := Nil
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oNo := LoadBitmap( GetResources(), "LBNO" )

DEFINE MSDIALOG oDg2 TITLE "Selecione os produtos acabados" FROM 000, 000  TO 500, 696 COLORS 0, 16777215 PIXEL

    @ 004, 002 SAY oSay1 PROMPT "Componentes que sofrerão alteração (desativação)" SIZE 343, 010 OF oDg2 COLORS 0, 16777215 PIXEL
    @ 019, 002 LISTBOX oALbx Fields HEADER " ","Codigo","Descricao" SIZE 344, 208 OF oDg2 PIXEL ColSizes 10,50,300
    oALbx:SetArray(aALbx)
    oALbx:bLine := {||{Iif( aALbx[oALbx:nAt,1], oOk, oNo ),aALbx[oALbx:nAt,2],aALbx[oALbx:nAt,3]}}
    oALbx:bLDblClick := {||aALbx[oALbx:nAt,1]:=!aALbx[oALbx:nAt,1],oALbx:DrawSelect()}
    @ 232, 002 BUTTON oBMT PROMPT "Marca Todos" Action(aEval(aALbx,{|x|x[1]:=.T.}),oALbx:Refresh(),oDg2:Refresh()) SIZE 048, 012 OF oDg2 PIXEL
    @ 232, 055 BUTTON oBDT PROMPT "Desmarca Todos" Action(aEval(aALbx,{|x|x[1]:=.F.}),oALbx:Refresh(),oDg2:Refresh()) SIZE 048, 012 OF oDg2 PIXEL
    @ 232, 244 BUTTON oBCF PROMPT "Confirma" Action(Iif(GrvEstr(aALbx,nRd1),oDg2:End(),Nil)) SIZE 048, 012 OF oDg2 PIXEL
    @ 232, 297 BUTTON oBSR PROMPT "Sair" Action(oDg2:End()) SIZE 048, 012 OF oDg2 PIXEL

ACTIVATE MSDIALOG oDg2 CENTERED

Return



//--------------------------------------------------------------
// Funcao:     GRVESTR
// Finalidade: Efetua a gravacao dos componentes nas estruturas
//             de PAs que foram selecionados
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function GrvEstr(aALbx,nRd1)
Local lRet := .F.
Local lDArm := .F.
Local aAltR := {}
Local aAInc := {}
Local aAtuArea := GetArea()
Local aSG1Area := SG1->(GetArea())
Local cQry := ""
Local cMsg := ""
Local nNx := 0
Local nNy := 0
Local cObs := ""
Local cXObs := ""
Local cLog := ""

For nNx := 1 to Len(aALbx)
    If aALbx[nNx,1]
        lRet := .T.
    EndIf
Next nNx

If !lRet
    cMsg := "Nenhum produto foi selecionado"+CRLF
EndIf

If lRet
    lRet := MsgYesNo("Confirma a gravação ?")
EndIf

If lRet

    If nRd1 == 1
        cObs := "<<< Substituicao"
        cLog := "Operacao: Substituicao"+CRLF
    ElseIf nRd1 == 2
        cObs := "Inclusao"
        cLog := "Operacao: Inclusao"+CRLF
    ElseIf nRd1 == 3
        cObs := "Desativacao"
        cLog := "Operacao: Desativacao"+CRLF
    ElseIf nRd1 == 4
        cObs := "Alteracao Qtd"
        cLog := "Operacao: Alteracao Qtd"+CRLF
    Else
        cObs := "Alteracao"
        cLog := "Operacao: Alteracao"+CRLF
    EndIf
    cObs += " por " +cUserName+ " em " +DtoC(Date())+ " as " +Time() + " >>>"
    cLog += "Por " +cUserName+ " em " +DtoC(Date())+ " as " +Time()+CRLF+CRLF

    If ( nRd1 == 1 .Or. nRd1 == 3 .Or. nRd1 == 4 ) // Substituição, Desativação e Alteração Qtd
        For nNx := 1 to Len(oGDA:aCols)
            If !oGDA:aCols[nNx,6]
                For nNy := 1 to Len(aALbx)
                    If aALbx[nNy,1]

                        cLog += "Produto Acabado: "+CRLF
                        cLog += Alltrim(aALbx[nNy,2])+"-"+Alltrim(aALbx[nNy,3])+CRLF
                        cLog += "Componente Atual: "+CRLF
                        cLog += Alltrim(oGDA:aCols[nNx,1])+"-"+Alltrim(oGDA:aCols[nNx,2])+CRLF
                        cLog += "Quantidade Atual: "+CRLF
                        cLog += Alltrim(Str(oGDA:aCols[nNx,3]))+CRLF+CRLF

                        cQry := "SELECT A.R_E_C_N_O_ AS SG1RCN, "
                        cQry += "RTRIM(LTRIM(CAST(ISNULL(CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),G1_XOBS)),'') AS CHAR(255)))) AS G1XOBS "
                        cQry += "FROM " +cSG1Tbl+ " A WHERE A.D_E_L_E_T_ = ' ' "
                        cQry += "AND A.G1_FILIAL = '" +cSG1Fil+ "' "
                        cQry += "AND A.G1_COD = '" +aALbx[nNy,2]+ "' "
                        cQry += "AND A.G1_COMP = '" +oGDA:aCols[nNx,1]+ "' "
                        cQry += "AND A.G1_QUANT = " +Alltrim(Str(oGDA:aCols[nNx,3]))+ " "

                        Iif(Select("WKXRG1")>0,WKXRG1->(dbCloseArea()),Nil)
                        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKXRG1",.T.,.T.)
                        TcSetField("WKXRG1","SG1RCN","N",14,0)
                        WKXRG1->(dbGoTop())

                        If WKXRG1->(!EoF())
                            If WKXRG1->SG1RCN > 0

                                cXObs := cObs + CRLF
                                cXObs += Alltrim(cMGt1) + CRLF
                                If !Empty(Alltrim(WKXRG1->G1XOBS))
                                    cXObs += Alltrim(WKXRG1->G1XOBS) + CRLF
                                EndIf
                                cXObs += CRLF

                                If nRd1 == 4
                                    aAdd( aAltR, {  { "RECNO", WKXRG1->SG1RCN } ,;
                                                    { "G1_QUANT", oGDA:aCols[nNx,4] } ,;
                                                    { "G1_XOBS", Alltrim(cXObs) } } )
                                Else
                                    aAdd( aAltR, {  { "RECNO", WKXRG1->SG1RCN } ,;
                                                    { "G1_FIM", Date()-1 } ,;
                                                    { "G1_XOBS", cXObs } } )
                                EndIf
                            EndIf
                        EndIf
                        WKXRG1->(dbCloseArea())

                    EndIf
                Next nNy
            EndIf
        Next nNx
    EndIf

    If ( nRd1 == 1 .Or. nRd1 == 2 ) // Substituição ou Inclusão

        cXObs := cObs + CRLF
        cXObs += Alltrim(cMGt2) + CRLF + CRLF

        For nNx := 1 to Len(oGDN:aCols)
            If !oGDN:aCols[nNx,5]
                For nNy := 1 to Len(aALbx)
                    If aALbx[nNy,1]

                        cLog += "Produto Acabado: "+CRLF
                        cLog += Alltrim(aALbx[nNy,2])+"-"+Alltrim(aALbx[nNy,3])+CRLF
                        cLog += "Novo Componente: "+CRLF
                        cLog += Alltrim(oGDN:aCols[nNx,1])+"-"+Alltrim(oGDN:aCols[nNx,2])+CRLF
                        cLog += "Quantidade: "+CRLF
                        cLog += Alltrim(Str(oGDN:aCols[nNx,3]))+CRLF+CRLF

                        aAdd( aAInc, {  {"G1_FILIAL", cSG1Fil },;
                                        {"G1_COD", aALbx[nNy,2] },;
                                        {"G1_COMP", oGDN:aCols[nNx,1] },;
                                        {"G1_QUANT", oGDN:aCols[nNx,3] },;
                                        {"G1_INI", Date() },;
                                        {"G1_FIM", StoD("20491231") },;
                                        {"G1_REVFIM", "ZZZ" },;
                                        {"G1_NIV", "01" },;
                                        {"G1_NIVINV", "99" },;
                                        {"G1_USAALT", "1" },;
                                        {"G1_XOBS", cXObs } } )
                    EndIf
                Next nNy
            EndIf
        Next nNx
    EndIf

    BeginTran()

    dbSelectArea("SG1")

    If Len(aAltR) > 0
        For nNx := 1 to Len(aAltR)
            For nNy := 1 to Len(aAltR[nNx])
                If aAltR[nNx,nNy,1] == "RECNO"
                    SG1->(dbGoTo(aAltR[nNx,nNy,2]))
                    If SG1->(RecNo()) == aAltR[nNx,nNy,2]
                        If !RecLock("SG1",.F.)
                            lDArm := .T.
                        EndIf
                    Else
                        lDArm := .T.
                    EndIf
                Else
                    If !lDArm
                        SG1->&(aAltR[nNx,nNy,1]) := aAltR[nNx,nNy,2]
                    EndIf
                EndIf
            Next nNy
            If !lDArm
                SG1->(MsUnLock())
            EndIf
        Next nNx
    EndIf

    If !lDArm
        If Len(aAInc) > 0
            For nNx := 1 to Len(aAInc)
                If !lDArm
                    If RecLock("SG1",.T.)
                        For nNy := 1 to Len(aAInc[nNx])
                            SG1->&(aAInc[nNx,nNy,1]) := aAInc[nNx,nNy,2]
                        Next nNy
                        SG1->(MsUnLock())
                    Else
                        lDArm := .T.
                    EndIf
                EndIf
            Next nNx
        EndIf
    EndIf

    If lDArm
        DisarmTransaction()
    EndIf

    EndTran()

    If lDArm

        lRet := .F.
        cMsg := "Houve erro na gravação. Tente novamente. Se o problema persistir, contacte o Administrador do Sistema."

    Else

        If !Empty(cLog)
            ShowLog(cLog)
        Else
            MsgInfo("Alterações gravadas com sucesso")
        EndIf
        oGDA:nAt := 1
        oGDN:nAt := 1
        oGDA:aCols := {{"               ","",0,0,"",.F.}} 
        oGDN:aCols := {{"               ","",0,"",.F.}}
        aColsA := {{"               ","",0,0,"",.F.}} 
        aColsN := {{"               ","",0,"",.F.}} 
        cMGt1 := Space(9999)
        cMGt2 := Space(9999)

    EndIf

EndIf

If !Empty(cMsg)
    Alert(cMsg)
EndIf


RestArea(aSG1Area)
RestArea(aAtuArea)

Return(lRet)



//--------------------------------------------------------------
// Funcao:     SHOWLOG
// Finalidade: Exibe tela de log, se gravacao com sucesso
// Autor:      Ronald Piscioneri
// Data:       27-Maio-2022
//--------------------------------------------------------------
Static Function ShowLog(cLog)
Local oBFch, oMtLog, oSay1, oSay2, oDlg := Nil
oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)

DEFINE MSDIALOG oDlg TITLE "Log das alterações" FROM 000, 000  TO 500, 696 COLORS 0, 16777215 PIXEL

    @ 004, 005 SAY oSay1 PROMPT "Alterações gravadas com sucesso." SIZE 342, 011 OF oDlg FONT oFont1 COLORS 32768, 16777215 PIXEL
    @ 017, 005 SAY oSay2 PROMPT "Verifique abaixo o log das alterações" SIZE 341, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 027, 005 GET oMtLog VAR cLog OF oDlg MULTILINE SIZE 339, 202 COLORS 0, 16777215 READONLY HSCROLL PIXEL
    @ 234, 308 BUTTON oBFch PROMPT "Fechar" Action(oDlg:End()) SIZE 037, 012 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)
