#Include "Protheus.Ch"

// Programa     PE01NFESEFAZ
// Descricao    Ponto de Entrada chamado pelo NFeSefaz.prw, permite customizar o XML da NF-e
// Autor        Ronald Piscioneri
// Data         14-JUL-2021
// Uso          Especifico TAIFF
User Function PE01NFESEFAZ()
Local aProd         := ParamIxb[01]
Local cMensCli      := ParamIxb[02]
Local cMensFis      := ParamIxb[03]
Local aDest         := ParamIxb[04]
Local aNota         := ParamIxb[05]
Local aInfoItem     := ParamIxb[06]  
Local aDupl         := ParamIxb[07]
Local aTransp       := ParamIxb[08]
Local aEntrega      := ParamIxb[09]
Local aRetirada     := ParamIxb[10]
Local aVeiculo      := ParamIxb[11]
Local aReboque      := ParamIxb[12]
Local aNfVincRur    := ParamIxb[13]
Local aEspVol       := ParamIxb[14]
Local aNfVinc       := ParamIxb[15]
Local aDetPag	    := ParamIxb[16]
Local aObsCont      := ParamIxb[17]
Local aProcRef      := ParamIxb[18]
Local aMed          := ParamIxb[19]
Local aLote         := ParamIxb[20]
Local aPedCom       := ParamIxb[21]
Local cIndPres      := ParamIxb[22]
Local cIndIntermed  := ParamIxb[23]
Local a01ICMSAg       := ParamIxb[Len(ParamIxb),01]
Local a02ICMSSTAg     := ParamIxb[Len(ParamIxb),02]
Local a03IPIAg        := ParamIxb[Len(ParamIxb),03]
Local a04PISAg        := ParamIxb[Len(ParamIxb),04]
Local a05PISSTAg      := ParamIxb[Len(ParamIxb),05]
Local a06COFINSAg     := ParamIxb[Len(ParamIxb),06]
Local a07COFINSSTAg   := ParamIxb[Len(ParamIxb),07]
Local a08ISSQNAg      := ParamIxb[Len(ParamIxb),08]
Local a09CSTAg        := ParamIxb[Len(ParamIxb),09]
Local a10MedAg        := ParamIxb[Len(ParamIxb),10]
Local a11ArmaAg       := ParamIxb[Len(ParamIxb),11]
Local a12VeicProdAg   := ParamIxb[Len(ParamIxb),12]
Local a13DIAg         := ParamIxb[Len(ParamIxb),13]
Local a14aDIAg        := ParamIxb[Len(ParamIxb),14]
Local a15ExpAg        := ParamIxb[Len(ParamIxb),15]
Local a16PisAlqZAg    := ParamIxb[Len(ParamIxb),16]
Local a17CofAlqZAg    := ParamIxb[Len(ParamIxb),17]
Local aRetPE        := {}
Local nNx           := 0
Local nVIcmSufr     := 0
Local nVPisSufr     := 0
Local nVCofSufr     := 0
Local cEmpREsp      := SuperGetMV("TF_REGIMEE",,"")
Local cFrmFrete	    := SuperGetMV("TF_FRMFRET",,"A84")
Local cFrmSINEF     := SuperGetMV("TF_FRMSINE",,"F12")
Local cFrmSenado    := SuperGetMV("TF_FRMSENA",,"DD7")
Local cMVESTADO     := SuperGetMV("MV_ESTADO",,"SP")
Local cCondAV       := SuperGetMV("TF_CPGTOAV",,"|N01|N02|")
Local cCondPG       := ""  
Local cQry          := ""
Local cNumPed       := ""
Local cItemPC       := ""
Local cMsgEspST     := ""
Local cPedPortal    := ""
Local cMenNota      := ""
Local cNumRM        := ""
Local cDescPg       := ""
Local cMsg1RgE      := ""
Local cMsg2RgE      := ""
Local cC5Tipo       := ""
Local cC5Inter      := ""
Local cMsgFrete     := ""
Local cMsgSINEF     := ""
Local cEstCli       := ""
Local cProdOri      := ""
Local cMsgSenado    := ""
Local cTpPed        := ""
Local cCodSuframa   := ""
Local cNumPC        := ""
Local cMsgTES       := ""
Local lPedPortal    := .F.
Local cSA1Tbl       := RetSqlName("SA1")
Local cSA1Fil       := xFilial("SA1")
Local cSA2Tbl       := RetSqlName("SA2")
Local cSA2Fil       := xFilial("SA2")
Local cSA4Tbl       := RetSqlName("SA4")
Local cSA4Fil       := xFilial("SA4")
Local cSC5Tbl       := RetSqlName("SC5")
Local cSC5Fil       := xFilial("SC5")
Local cSD2Tbl       := RetSqlName("SD2")
Local cSD2Fil       := xFilial("SD2")
Local cSF2Tbl       := RetSqlName("SF2")
Local cSF2Fil       := xFilial("SF2")
Local cSF1Tbl       := RetSqlName("SF1")
Local cSF1Fil       := xFilial("SF1")
Local cSM4Tbl       := RetSqlName("SM4")
Local cSM4Fil       := xFilial("SM4")
Local cSE4Tbl       := RetSqlName("SE4")
Local cSE4Fil       := xFilial("SE4")
Local cSC6Tbl       := RetSqlName("SC6")
Local cSC6Fil       := xFilial("SC6")
Local cSA7Tbl       := RetSqlName("SA7")
Local cSA7Fil       := xFilial("SA7")
Local cSB1Tbl       := RetSqlName("SB1")
Local cSB1Fil       := xFilial("SB1")
Local cSF4Tbl       := RetSqlName("SF4")
Local cSF4Fil       := xFilial("SF4")
Local cZALTbl       := RetSqlName("ZAL")
Local cZALFil       := xFilial("ZAL")
Local cSC9Tbl       := RetSqlName("SC9")
Local cSC9Fil       := xFilial("SC9")
Local cSD1Tbl       := RetSqlName("SD1")
Local cSD1Fil       := xFilial("SD1")

//----------------------------------------------------------------------------------------------------------- 
//O parametro PE01NSFZA permite habilitar (1) ou desabilitar (0) cada tratamento deste Ponto de Entrada
//Se for necessario cria-lo no SX6, deve ser do tipo Caracter e seu conteudo deve ser declarado como
//um array unidimensional
//----------------------------------------------------------------------------------------------------------- 
Local aProcess  := &(SuperGetMV("PE01NSFZA",,"{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}"))

If aProcess[1] <> 0
    If !Empty(cMensCli)
        cMensCli := Alltrim(cMensCli)+ ". "
    EndIf   
EndIf

If aProcess[2] <> 0
    If !Empty(cMensFis)
        cMensFis := Alltrim(cMensFis)+ ". "
    EndIf
EndIf

//----------------------------------------------------------------------------------------------------------- 
// Destinatario: Inclui logradouro e corrige o numero do endereco
//----------------------------------------------------------------------------------------------------------- 
If aProcess[3] <> 0

    If !Empty(aDest[1]) 

        //----------------------------------------------------------------------------------------------------------- 
        // NFe de Saida
        //----------------------------------------------------------------------------------------------------------- 
        If aNota[4] == "1"

            cQry := "SELECT "
            cQry += "A1_LOGR AS LOGR, "
            cQry += "A1_END AS ENDE, "
            cQry += "A1_NUME AS NUME, "
            cQry += "A1_SUFRAMA AS SUFRAMA "
            cQry += "FROM " +cSA1Tbl+ " WHERE D_E_L_E_T_ = ' ' "
            cQry += "AND A1_FILIAL = '" +cSA1Fil+ "' "
            cQry += "AND A1_CGC = '" +aDest[1]+ "' "
       
        //----------------------------------------------------------------------------------------------------------- 
        // NFe de Entrada
        //----------------------------------------------------------------------------------------------------------- 
        Else
            
            cQry := "SELECT "
            cQry += "A2_LOGR AS LOGR, "
            cQry += "A2_END AS ENDE, "
            cQry += "A2_NR_END AS NUME, "
            cQry += "'' AS SUFRAMA "
            cQry += "FROM " +cSA2Tbl+ " WHERE D_E_L_E_T_ = ' ' "
            cQry += "AND A2_FILIAL = '" +cSA2Fil+ "' "
            cQry += "AND A2_CGC = '" +aDest[1]+ "' "

        EndIf

        Iif(Select("WRKATBL")>0,WRKATBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKATBL",.T.,.T.)
        WRKATBL->(dbGoTop())

        If WRKATBL->(!EoF())

            aDest[3] := ""
            If !Empty(WRKATBL->LOGR) 
                aDest[3] += Alltrim(WRKATBL->LOGR)
            EndIf

            If !Empty(WRKATBL->ENDE)
                If !Empty(aDest[3])
                    aDest[3] += " "
                EndIf
                aDest[3] += Alltrim(WRKATBL->ENDE)
            EndIf

            If !Empty(WRKATBL->NUME)
                aDest[4] := Alltrim(WRKATBL->NUME)
            Else
                aDest[4] := "SN"   
            EndIf

            If !Empty(WRKATBL->SUFRAMA) 
                cCodSuframa := Alltrim(WRKATBL->SUFRAMA)+ ". "
            EndIf

        EndIf
        WRKATBL->(dbCloseArea())

    EndIf

EndIf

//----------------------------------------------------------------------------------------------------------- 
// Entrega: Inclui logradouro e corrige o numero do endereco de entrega
//----------------------------------------------------------------------------------------------------------- 
If aProcess[4] <> 0

    If ( Len(aEntrega) > 0 .And. !Empty(aEntrega[1]) )

        //----------------------------------------------------------------------------------------------------------- 
        // NFe de Saida
        //----------------------------------------------------------------------------------------------------------- 
        If aNota[4] == "1"

            cQry := "SELECT "
            cQry += "A1_LOGR AS LOGR, "
            cQry += "A1_END AS ENDE, "
            cQry += "A1_NUME AS NUME "
            cQry += "FROM " +cSA1Tbl+ " WHERE D_E_L_E_T_ = ' ' "
            cQry += "AND A1_FILIAL = '" +cSA1Fil+ "' "
            cQry += "AND A1_CGC = '" +aEntrega[1]+ "' "
       
        //----------------------------------------------------------------------------------------------------------- 
        // NFe de Entrada
        //----------------------------------------------------------------------------------------------------------- 
        Else
            
            cQry := "SELECT "
            cQry += "A2_LOGR AS LOGR, "
            cQry += "A2_END AS ENDE, "
            cQry += "A2_NR_END AS NUME "
            cQry += "FROM " +cSA2Tbl+ " WHERE D_E_L_E_T_ = ' ' "
            cQry += "AND A2_FILIAL = '" +cSA2Fil+ "' "
            cQry += "AND A2_CGC = '" +aEntrega[1]+ "' "

        EndIf

        Iif(Select("WRKLTBL")>0,WRKLTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKLTBL",.T.,.T.)
        WRKLTBL->(dbGoTop())

        If WRKLTBL->(!EoF())
            If !Empty(WRKLTBL->LOGR) 
                If !Empty(WRKLTBL->ENDE) 
                    If !Empty(WRKLTBL->NUME) 
                        aEntrega[3] := Alltrim(WRKLTBL->LOGR)+ " " +Alltrim(WRKLTBL->ENDE)+ ", " +Alltrim(WRKLTBL->NUME)
                    EndIf
                EndIf
            EndIf
        EndIf
        WRKLTBL->(dbCloseArea())

    EndIf

EndIf

//----------------------------------------------------------------------------------------------------------- 
// Tratamentos Especificos para NF-e de Saida
//----------------------------------------------------------------------------------------------------------- 
If aNota[4] == "1"

    //----------------------------------------------------------------------------------------------------------- 
    // Verifica se utiliza fornecedor na NF de saida
    //----------------------------------------------------------------------------------------------------------- 
    cQry := "SELECT DISTINCT C5.C5_TIPO AS C5TIPO "
    cQry += "FROM "
    cQry += cSC5Tbl+ " C5, "
    cQry += cSD2Tbl+ " D2 "
    cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
    cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
    cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "
    cQry += "AND D2.D_E_L_E_T_ = ' ' "
    cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
    cQry += "AND D2.D2_DOC = '" +aNota[2]+ "' "
    cQry += "AND D2.D2_SERIE = '" +aNota[1]+ "'"

    Iif(Select("WRK0TBL")>0,WRK0TBL->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRK0TBL",.T.,.T.)
    WRK0TBL->(dbGoTop())

    If WRK0TBL->(!EoF())
        If !Empty(WRK0TBL->C5TIPO)
            cTpPed := WRK0TBL->C5TIPO
        EndIf
    EndIf
    WRK0TBL->(dbCloseArea())

    //----------------------------------------------------------------------------------------------------------- 
    // O Select abaixo serve para varios tratamentos (cada um explicado separadamente)
    //----------------------------------------------------------------------------------------------------------- 
    If cTpPed == "B"

        cQry := "SELECT DISTINCT "
        cQry += "C5.C5_NUM AS C5NUM, "
        cQry += "C5.C5_NUMOLD AS C5NUMOLD, "
        cQry += "C5.C5_MENNOTA AS C5MENNOTA, "
        cQry += "C5.C5_TIPO AS C5TIPO, "
        cQry += "C5.C5_INTER AS C5INTER, "
        If cEmpAnt == "03" 
            cQry += "F2.F2_NUMRM AS F2NUMRM, "
        EndIf
        cQry += "E4.E4_DESCRI AS E4DESCRI, "
        cQry += "A2.A2_EST AS A1EST, "
        cQry += "B1.B1_ORIGEM AS B1ORIGEM "
        cQry += "FROM "
        cQry += cSC5Tbl+ " C5, "
        cQry += cSD2Tbl+ " D2, "
        cQry += cSF2Tbl+ " F2, "
        cQry += cSE4Tbl+ " E4, "
        cQry += cSA2Tbl+ " A2, "
        cQry += cSB1Tbl+ " B1 "
        cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
        cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
        cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "
        cQry += "AND F2.D_E_L_E_T_ = ' ' "
        cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
        cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "
        cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
        cQry += "AND D2.D_E_L_E_T_ = ' ' "
        cQry += "AND D2.D2_FILIAL = F2.F2_FILIAL "
        cQry += "AND D2.D2_DOC = F2.F2_DOC "
        cQry += "AND D2.D2_SERIE = F2.F2_SERIE "
        cQry += "AND D2.D2_CLIENTE = F2.F2_CLIENTE "
        cQry += "AND D2.D2_LOJA = F2.F2_LOJA "
        cQry += "AND D2.D2_FORMUL = F2.F2_FORMUL "
        cQry += "AND E4.D_E_L_E_T_ = ' ' "
        cQry += "AND E4.E4_FILIAL = '" +cSE4Fil+ "' "
        cQry += "AND E4.E4_CODIGO = C5.C5_CONDPAG "
        cQry += "AND A2.D_E_L_E_T_ = ' ' "
        cQry += "AND A2.A2_FILIAL = '" +cSA2Fil+ "' "
        cQry += "AND A2.A2_COD = F2.F2_CLIENTE "
        cQry += "AND A2.A2_LOJA = F2.F2_LOJA "
        cQry += "AND B1.D_E_L_E_T_ = ' ' "
        cQry += "AND B1.B1_FILIAL = '" +cSB1Fil+ "' "
        cQry += "AND B1.B1_COD = D2.D2_COD "

    Else

        cQry := "SELECT DISTINCT "
        cQry += "C5.C5_NUM AS C5NUM, "
        cQry += "C5.C5_NUMOLD AS C5NUMOLD, "
        cQry += "C5.C5_MENNOTA AS C5MENNOTA, "
        cQry += "C5.C5_TIPO AS C5TIPO, "
        cQry += "C5.C5_INTER AS C5INTER, "
        If cEmpAnt == "03" 
            cQry += "F2.F2_NUMRM AS F2NUMRM, "
        EndIf
        cQry += "E4.E4_DESCRI AS E4DESCRI, "
        cQry += "A1.A1_EST AS A1EST, "
        cQry += "B1.B1_ORIGEM AS B1ORIGEM "
        cQry += "FROM "
        cQry += cSC5Tbl+ " C5, "
        cQry += cSD2Tbl+ " D2, "
        cQry += cSF2Tbl+ " F2, "
        cQry += cSE4Tbl+ " E4, "
        cQry += cSA1Tbl+ " A1, "
        cQry += cSB1Tbl+ " B1 "
        cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
        cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
        cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "
        cQry += "AND F2.D_E_L_E_T_ = ' ' "
        cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
        cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "
        cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
        cQry += "AND D2.D_E_L_E_T_ = ' ' "
        cQry += "AND D2.D2_FILIAL = F2.F2_FILIAL "
        cQry += "AND D2.D2_DOC = F2.F2_DOC "
        cQry += "AND D2.D2_SERIE = F2.F2_SERIE "
        cQry += "AND D2.D2_CLIENTE = F2.F2_CLIENTE "
        cQry += "AND D2.D2_LOJA = F2.F2_LOJA "
        cQry += "AND D2.D2_FORMUL = F2.F2_FORMUL "
        cQry += "AND E4.D_E_L_E_T_ = ' ' "
        cQry += "AND E4.E4_FILIAL = '" +cSE4Fil+ "' "
        cQry += "AND E4.E4_CODIGO = C5.C5_CONDPAG "
        cQry += "AND A1.D_E_L_E_T_ = ' ' "
        cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' "
        cQry += "AND A1.A1_COD = F2.F2_CLIENTE "
        cQry += "AND A1.A1_LOJA = F2.F2_LOJA "
        cQry += "AND B1.D_E_L_E_T_ = ' ' "
        cQry += "AND B1.B1_FILIAL = '" +cSB1Fil+ "' "
        cQry += "AND B1.B1_COD = D2.D2_COD "

    EndIf

    Iif(Select("WRKDTBL")>0,WRKDTBL->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKDTBL",.T.,.T.)
    WRKDTBL->(dbGoTop())

    While WRKDTBL->(!EoF())
        If cEmpAnt == "03" 
            If !Empty(WRKDTBL->F2NUMRM)
                If Empty(cNumRM)
                    cNumRM := Alltrim(WRKDTBL->F2NUMRM)
                EndIf
            EndIf
        Else
            cNumRM := ""
        EndIf
        If !Empty(WRKDTBL->C5NUM)
            If !(Alltrim(WRKDTBL->C5NUM) $ cNumPed)
                If !Empty(cNumPed)
                    cNumPed += ", "
                EndIf
                cNumPed := Alltrim(WRKDTBL->C5NUM)
            EndIf
        EndIf
        If !Empty(WRKDTBL->C5NUMOLD)
            If !(Alltrim(WRKDTBL->C5NUMOLD) $ cPedPortal)
                If !Empty(cPedPortal)
                    cPedPortal += ", "
                EndIf
                cPedPortal := Alltrim(WRKDTBL->C5NUMOLD)
            EndIf
        EndIf
        If !Empty(WRKDTBL->C5MENNOTA)
            If cNumRM <> "CROSS"
                If Empty(cMenNota)
                    cMenNota := Alltrim(WRKDTBL->C5MENNOTA)
                ENDIF
            EndIf
        EndIf
        If !Empty(WRKDTBL->C5TIPO)
            If Empty(cC5Tipo)
                cC5Tipo := Alltrim(WRKDTBL->C5TIPO)
            EndIf
        EndIf
        If !Empty(WRKDTBL->C5INTER)
            If Empty(cC5Inter)
                cC5Inter := Alltrim(WRKDTBL->C5INTER)
            EndIf
        EndIf
        If !Empty(WRKDTBL->E4DESCRI)
            If cNumRM <> "CROSS"
                If Empty(cDescPg)
                    cDescPg := Alltrim(WRKDTBL->E4DESCRI)
                EndIf
            EndIf
        EndIf
        If !Empty(WRKDTBL->A1EST)
            If Empty(cEstCli)
                cEstCli := Alltrim(WRKDTBL->A1EST)
            EndIf
        EndIf
        If !Empty(WRKDTBL->B1ORIGEM)
            If !( WRKDTBL->B1ORIGEM $ cProdOri )
                cProdOri += "|"+Alltrim(WRKDTBL->B1ORIGEM)
            EndIf
        EndIf
        WRKDTBL->(dbSkip())
    EndDo
    WRKDTBL->(dbCloseArea())

    //----------------------------------------------------------------------------------------------------------- 
    // Numero do Pedido de Vendas
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[5] <> 0
        If !( Upper(Alltrim(cNumPed)) $ Upper(Alltrim(cMensCli)) )
            If !Empty(cNumPed)
                cMensCli += "Numero do Pedido: " +cNumPed+ ". "
            EndIf
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Numero do Pedido do Portal - Cross Docking
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[6] <> 0 .And. !("PEDIDO PORTAL" $ Upper(cMensCli) )

        If cNumRM == "CROSS"

            cPedPortal := ""

            cQry := "SELECT DISTINCT "
            cQry += "C5.C5_NUMOLD AS PEDPORTAL "
            cQry += "FROM " +cSC5Tbl+ " C5 "
            cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
            cQry += "AND C5.C5_FILIAL + C5.C5_NUM IN ( "
            cQry += "SELECT DISTINCT C9.C9_XFIL + C9.C9_PEDORI "
            cQry += "FROM " +cSC9Tbl+ " C9 WHERE C9.D_E_L_E_T_ = ' ' "
            cQry += "AND C9.C9_FILIAL = '" +cSC9Fil+ "' "
            cQry += "AND C9.C9_NFISCAL = '" +aNota[2]+ "' "
            cQry += "AND C9.C9_SERIENF = '" +aNota[1]+ "' ) "
            cQry += "ORDER BY C5.C5_NUMOLD "

            Iif(Select("WRKJTBL")>0,WRKJTBL->(dbCloseArea()),Nil)
            dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKJTBL",.T.,.T.)
            WRKJTBL->(dbGoTop())

            While WRKJTBL->(!EoF())

                lPedPortal := .T.
                cPedPortal += Alltrim( WRKJTBL->PEDPORTAL )

                WRKJTBL->(dbSkip())

                If WRKJTBL->(!EoF())
                    cPedPortal += ", "
                Else
                    cPedPortal += ". "
                EndIf

            EndDo
            WRKJTBL->(dbCloseArea())

        EndIf

    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Numero do Pedido do Portal - Demais NFs (exceto Cross Docking)
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[7] <> 0
        If cNumRM <> "CROSS"
            If !( "PEDIDO PORTAL" $ Upper(Alltrim(cMensCli)) )
                lPedPortal := .T.
                For nNx := 1 to Len(cPedPortal)
                    If !( SubStr(cPedPortal,nNx,1) $ "1234567890" )
                        lPedPortal := .F.
                    EndIf
                Next nNx
            EndIf
        EndIf
    EndIf

    If lPedPortal
        If !Empty(cPedPortal)
            cMensCli += "Pedido Portal: " +cPedPortal+ ". "
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Pedido de Compra do Cliente
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[8] <> 0
        If cNumRM <> "CROSS"

            aPedCom := {}

            cQry := "SELECT "
            cQry += "D2.D2_ITEM AS ITEMNF, "
            cQry += "ISNULL(C6.C6_PEDCLI,'') AS PEDCLI, " 
            cQry += "ISNULL(C6.C6_ITEMPC,'') AS ITEMPC "
            cQry += "FROM "
            cQry += cSF2Tbl+ " F2 "
            cQry += "INNER JOIN " +cSD2Tbl+ " D2 ON D2.D_E_L_E_T_ = ' ' "
            cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
            cQry += "AND D2.D2_SERIE = F2.F2_SERIE "
            cQry += "AND D2.D2_DOC = F2.F2_DOC "
            cQry += "AND D2.D2_CLIENTE = F2.F2_CLIENTE "
            cQry += "AND D2.D2_LOJA = F2.F2_LOJA "
            cQry += "AND D2.D2_FORMUL = F2.F2_FORMUL "
            cQry += "INNER JOIN " +cSC5Tbl+ " C5 ON C5.D_E_L_E_T_ = ' ' "
            cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
            cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "
            cQry += "LEFT OUTER JOIN " +cSC6Tbl+ " C6 ON C6.D_E_L_E_T_ = ' ' "
            cQry += "AND C6.C6_FILIAL = '" +cSC6Fil+ "' "
            cQry += "AND C6.C6_NUM = D2.D2_PEDIDO "
            cQry += "AND C6.C6_PRODUTO = D2.D2_COD "
            cQry += "WHERE F2.D_E_L_E_T_ = ' ' "
            cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
            cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
            cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "
            cQry += "ORDER BY ITEMNF "

            Iif(Select("WRKETBL")>0,WRKETBL->(dbCloseArea()),Nil)
            dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKETBL",.T.,.T.)
            WRKETBL->(dbGoTop())

            While WRKETBL->(!EoF())
                If !Empty(WRKETBL->PEDCLI)

                    If !( Alltrim(WRKETBL->PEDCLI) $ cNumPC )
                        If !Empty(cNumPC)
                            cNumPC += ", "
                        EndIf
                        cNumPC += Alltrim(WRKETBL->PEDCLI)
                    EndIf

                    If !Empty(WRKETBL->ITEMPC)
                        cItemPC := WRKETBL->ITEMPC
                    Else
                        cItemPC := WRKETBL->ITEMNF
                    EndIf
                    aAdd( aPedCom, { Alltrim(WRKETBL->PEDCLI) , Alltrim(cItemPC) } )
                Else
                    aAdd( aPedCom, {} )
                EndIf
                WRKETBL->(dbSkip())
            EndDo
            WRKETBL->(dbCloseArea())

            If !Empty(cNumPC)
                cMensCli += "Num.Ped.Cliente: " +cNumPC+ ". "
            EndIf

        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Mensagem para Nota, informada no Pedido de Venda
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[9] <> 0
        If cNumRM <> "CROSS"
            If !Empty(cMenNota)
                If !( Upper(Alltrim(cMenNota)) $ Upper(Alltrim(cMensCli)) )
                    cMensCli += cMenNota+ ". "
                EndIf
            EndIf
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Mensagem de Frete - Solicitado pela logistica
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[10] <> 0
        If cNumRM <> "CROSS"
            If !Empty(cFrmFrete)
                If cC5Tipo = "N" .And. cC5Inter <> "S" .And. !Empty(cFrmFrete)
                    cMsgFrete := Alltrim(Formula(cFrmFrete)) + Space(2)
                    If !Empty(cMsgFrete)
                        If !( Upper(Alltrim(cMsgFrete)) $ Upper(Alltrim(cMensCli)) )
                            cMensCli += cMsgFrete+ ". "
                        EndIf
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // NF de Saida: formula especifica da TES - Campo F4_MSGPAD
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[11] <> 0

        cQry := "SELECT DISTINCT "
        cQry += "F4.F4_MSGPAD AS F4MSGPAD "
        cQry += "FROM "
        cQry += cSF4Tbl+ " F4, "
        cQry += cSD2Tbl+ " D2 "
        cQry += "WHERE F4.D_E_L_E_T_ = ' ' "
        cQry += "AND F4.F4_FILIAL = '" +cSF4Fil+ "' "
        cQry += "AND F4.F4_CODIGO = D2.D2_TES "
        cQry += "AND F4.F4_MSGPAD <> '' "
        cQry += "AND D2.D_E_L_E_T_ = ' ' "
        cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
        cQry += "AND D2.D2_DOC = '" +aNota[2]+ "' "
        cQry += "AND D2.D2_SERIE = '" +aNota[1]+ "' "
        cQry += "ORDER BY F4.F4_MSGPAD"

        Iif(Select("WRKOTBL")>0,WRKOTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKOTBL",.T.,.T.)
        WRKOTBL->(dbGoTop())

        While WRKOTBL->(!EoF())
            cMsgTES := Alltrim(Formula(WRKOTBL->F4MSGPAD)) + Space(2)
            If !Empty(cMsgTES)
                If !( Upper(Alltrim(cMsgTES)) $ Upper(Alltrim(cMensFis)) )
                    cMensFis += cMsgTES+ ". "
                EndIf
            EndIf
            WRKOTBL->(dbSkip())
        EndDo
        WRKOTBL->(dbCloseArea())

    EndIf


    //----------------------------------------------------------------------------------------------------------- 
    // Condicao de Pagamento
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[12] <> 0
        If cNumRM <> "CROSS"
            If !Empty(cDescPg)
                If !( Upper(Alltrim(cDescPg)) $ Upper(Alltrim(cMensCli)) )
                    If Empty(cNumRM)
                        cMensCli += "Cond.Pagto: " +cDescPg+ ". "
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Mensagem do Senado
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[13] <> 0
        If Empty(cMsgSenado)
            If ( '2' $ cProdOri .And.  cEstCli <> cMVESTADO .And. !(cC5Tipo $ "|D|B|") )
                cMsgSenado	:= Alltrim(Formula(cFrmSenado))
            EndIf
        EndIf
        If !Empty(cMsgSenado)
            If !( Upper(Alltrim(cMsgSenado)) $ Upper(Alltrim(cMensFis)) )
                cMensFis += cMsgSenado+ ". "
            EndIf
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Retorna codigo da transportadora especifico da Assistencia Tecnica
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[14] <> 0
        If cNumRM <> "CROSS"
    
            cQry := "SELECT DISTINCT "
            cQry += "A4.A4__NOMASS AS A4NOMASS, "
            cQry += "A4.A4_NOME AS A4NOME, "
            cQry += "C5.C5_CLASPED AS C5CLASPED, "
            cQry += "C5.C5_TPFRETE AS C5TPFRETE, "
            cQry += "F2.F2_TPFRETE AS F2TPFRETE "
            cQry += "FROM "
            cQry += cSA4Tbl+ " A4, "
            cQry += cSC5Tbl+ " C5, "
            cQry += cSD2Tbl+ " D2, "
            cQry += cSF2Tbl+ " F2 "
            cQry += "WHERE A4.D_E_L_E_T_ = ' ' "
            cQry += "AND A4.A4_FILIAL = '" +cSA4Fil+ "' "
            cQry += "AND A4.A4_COD = C5.C5_TRANSP "
            cQry += "AND C5.D_E_L_E_T_ = ' ' "
            cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
            cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "
            cQry += "AND D2.D_E_L_E_T_ = ' ' "
            cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
            cQry += "AND D2.D2_DOC = F2.F2_DOC "
            cQry += "AND D2.D2_SERIE = F2.F2_SERIE "
            cQry += "AND D2.D2_CLIENTE = F2.F2_CLIENTE "
            cQry += "AND D2.D2_LOJA = F2.F2_LOJA "
            cQry += "AND D2.D2_FORMUL = F2.F2_FORMUL "
            cQry += "AND F2.D_E_L_E_T_ = ' ' "
            cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
            cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
            cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "

            Iif(Select("WRKBTBL")>0,WRKBTBL->(dbCloseArea()),Nil)
            dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKBTBL",.T.,.T.)
            WRKBTBL->(dbGoTop())

            If WRKBTBL->(!EoF())

                If WRKBTBL->C5CLASPED = "A" .AND. ( WRKBTBL->F2TPFRETE == "S" .OR. WRKBTBL->C5TPFRETE == "S" )
                    If !Empty( WRKBTBL->A4NOMASS )
                        aTransp[2] := Alltrim(WRKBTBL->A4NOMASS)
                    EndIf
                EndIf

            EndIf
            WRKBTBL->(dbCloseArea())

        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Mensagens fiscais declaradas nos itens da NF
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[15] <> 0

        cQry := "SELECT DISTINCT M4.M4_CODIGO M4CODIGO "
        cQry += "FROM " +cSM4Tbl+ " M4 "
        cQry += "WHERE M4.D_E_L_E_T_ = ' ' "
        cQry += "AND M4.M4_FILIAL = '" +cSM4Fil+ "' "
        cQry += "AND M4.M4_CODIGO IN ( "
        cQry += "SELECT DISTINCT D2.D2_XMENSNF "
        cQry += "FROM " +cSD2Tbl+ " D2 WHERE D2.D_E_L_E_T_ = ' ' "
        cQry += "AND D2.D2_XMENSNF <> '' "
        cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' " 
        cQry += "AND D2.D2_SERIE = '" +aNota[1]+ "' " 
        cQry += "AND D2.D2_DOC = '" +aNota[2]+ "' ) "
        cQry += "ORDER BY M4.M4_CODIGO "

        Iif(Select("WRKCTBL")>0,WRKCTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKCTBL",.T.,.T.)
        WRKCTBL->(dbGoTop())

        While WRKCTBL->(!EoF())

            cMsgEspST += Alltrim(Formula( WRKCTBL->M4CODIGO ))
            WRKCTBL->(dbSkip())

            If WRKCTBL->(!EoF())
                cMsgEspST += ", "
            EndIf

        EndDo
        WRKCTBL->(dbCloseArea())

        If !Empty(cMsgEspST)
            cMsgEspST := Alltrim(StrTran( cMsgEspST , '"', '' ))
            If !( Upper(Alltrim(cMsgEspST)) $ Upper(Alltrim(cMensFis)) )
                cMensFis += cMsgEspST+ ". "
            EndIf
        EndIf

    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Complementa a descricao do item com o codigo do produto no cliente (quando houver SA7)
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[16] <> 0
        If cNumRM <> "CROSS"

            For nNx := 1 to Len( aProd )

                If !Empty( aProd[nNx,3] )

                    cQry := "SELECT A7.A7_CODCLI AS PRODCLI "
                    cQry += "FROM " +cSF2Tbl+ " F2 "
                    cQry += "INNER JOIN " +cSA7Tbl+ " A7 ON A7.D_E_L_E_T_ = ' ' "
                    cQry += "AND A7.A7_FILIAL = '" +cSA7Fil+ "' "
                    cQry += "AND A7.A7_CLIENTE = F2.F2_CLIENTE "
                    cQry += "AND A7.A7_LOJA = F2.F2_LOJA "
                    cQry += "INNER JOIN " +cSB1Tbl+ " B1 ON B1.D_E_L_E_T_ = ' ' "
                    cQry += "AND B1.B1_FILIAL = '" +cSB1Fil+ "' "
                    cQry += "AND B1.B1_CODBAR = '" +Alltrim(aProd[nNx,3])+ "' "
                    cQry += "AND B1.B1_COD = A7.A7_PRODUTO "
                    cQry += "WHERE F2.D_E_L_E_T_ = ' ' "
                    cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
                    cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
                    cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "

                    Iif(Select("WRKFTBL")>0,WRKFTBL->(dbCloseArea()),Nil)
                    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKFTBL",.T.,.T.)
                    WRKFTBL->(dbGoTop())

                    If WRKFTBL->(!EoF())
                        If !Empty(WRKFTBL->PRODCLI)
                            If !( Upper(Alltrim(WRKFTBL->PRODCLI)) $ Upper(Alltrim(aProd[nNx,4])) )
                                aProd[nNx,4] := Alltrim(aProd[nNx,4]) +" - "+ Alltrim(WRKFTBL->PRODCLI)
                            EndIf
                        EndIf
                    EndIf
                    WRKFTBL->(dbCloseArea())

                EndIf

            Next nNx

        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Mensagem de Regime Especial para o cliente
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[17] <> 0

        If cEmpAnt $ cEmpREsp

            cQry := "SELECT ZAL.ZAL_MENSAG AS ZALMENSAG, "
            cQry += "ZAL.ZAL_CONCES AS ZALCONCES "
            cQry += "FROM " +cZALTbl+ " ZAL "
            cQry += "INNER JOIN " +cSF2Tbl+ " SF2 ON SF2.D_E_L_E_T_ = ' ' "
            cQry += "AND SF2.F2_FILIAL = '" +cSF2Fil+ "' "
            cQry += "AND SF2.F2_SERIE = '" +aNota[1]+ "' "
            cQry += "AND SF2.F2_DOC = '" +aNota[2]+ "' "
            cQry += "INNER JOIN " +cSD2Tbl+ " SD2 ON SD2.D_E_L_E_T_ = ' ' "
            cQry += "AND SD2.D2_FILIAL = '" +cSD2Fil+ "' "
            cQry += "AND SD2.D2_SERIE = SF2.F2_SERIE "
            cQry += "AND SD2.D2_DOC = SF2.F2_DOC "
            cQry += "AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
            cQry += "AND SD2.D2_LOJA = SF2.F2_LOJA "
            cQry += "INNER JOIN " +cSF4Tbl+ " SF4 ON SF4.D_E_L_E_T_ = ' ' "
            cQry += "AND SF4.F4_FILIAL = '" +cSF4Fil+ "' "
            cQry += "AND SF4.F4_CODIGO = SD2.D2_TES "
            cQry += "AND SF4.F4_SITTRIB = '00' "
            cQry += "WHERE ZAL.D_E_L_E_T_ = ' ' "
            cQry += "AND ZAL.ZAL_FILIAL = '" +cZALFil+ "' "
            cQry += "AND ZAL.ZAL_TIPSIT IN ('N','T') "
            cQry += "AND ZAL.ZAL_CLIENT = SF2.F2_CLIENTE "
            cQry += "AND ZAL.ZAL_LOJA = SF2.F2_LOJA "
            cQry += "AND ZAL.ZAL_VALIDA >= SF2.F2_EMISSAO "
            cQry += "AND ZAL.ZAL_TIPSIT IN ('N','T') "

            Iif(Select("WRKGTBL")>0,WRKGTBL->(dbCloseArea()),Nil)
            dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKGTBL",.T.,.T.)
            WRKGTBL->(dbGoTop())

            If WRKGTBL->(!EoF())
                If !Empty(WRKGTBL->ZALMENSAG)
                    cMsg1RgE := Alltrim(StrTran( Alltrim(Formula(WRKGTBL->ZALMENSAG)) , '"', "" ))
                EndIf
                If !Empty(WRKGTBL->ZALCONCES)
                    cMsg2RgE := Alltrim(WRKGTBL->ZALCONCES)
                EndIf
            EndIf
            WRKGTBL->(dbCloseArea())

            If !Empty(cMsg1RgE)
                If !( Upper(Alltrim(cMsg1RgE)) $ Upper(Alltrim(cMensFis)) )            
                    cMensFis += cMsg1RgE
                    If !( Upper(Alltrim(cMsg2RgE)) $ Upper(Alltrim(cMensFis)) )            
                        If !Empty(cMsg2RgE)
                            cMensFis += " " +cMsg2RgE
                        EndIf
                    EndIf
                    cMensFis += ". "
                EndIf
            EndIf
        EndIf

    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Regime de Tributacao
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[18] <> 0
        If !( "REGIME NORMAL" $ Upper(Alltrim(cMensFis)) )            
            cMensFis += "Codigo Regime Tributario: 3-Regime Normal. "
        EndIf
    EndIf

    //----------------------------------------------------------------------------------------------------------- 
    // Descontos Suframa
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[19] <> 0

        If cNumRM <> "CROSS"

            If !( "DESCONTOS REF. A ZONA FRANCA DE MANAUS / ALC" $ Upper(Alltrim(cMensFis)) )            

                cQry := "SELECT "
                cQry += "ISNULL(SUM(D2.D2_DESCZFR - D2.D2_DESCZFP - D2.D2_DESCZFC),0) AS VICM, "
                cQry += "ISNULL(SUM(D2.D2_DESCZFP),0) AS VPIS, "
                cQry += "ISNULL(SUM(D2.D2_DESCZFC),0) AS VCOF "
                cQry += "FROM "
                cQry += cSD2Tbl+ " D2, "
                cQry += cSA1Tbl+ " A1 "
                cQry += "WHERE D2.D_E_L_E_T_ = ' ' "
                cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
                cQry += "AND D2.D2_SERIE = '" +aNota[1]+ "' "
                cQry += "AND D2.D2_DOC = '" +aNota[2]+ "' "
                cQry += "AND A1.D_E_L_E_T_ = ' ' "
                cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' "
                cQry += "AND A1.A1_COD = D2.D2_CLIENTE "
                cQry += "AND A1.A1_LOJA = D2.D2_LOJA "
                cQry += "AND A1.A1_SUFRAMA <> '' "

                Iif(Select("WRKHTBL")>0,WRKHTBL->(dbCloseArea()),Nil)
                dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKHTBL",.T.,.T.)
                TcSetField("WRKHTBL","VICM","N",14,2)
                TcSetField("WRKHTBL","VPIS","N",14,2)
                TcSetField("WRKHTBL","VCOF","N",14,2)
                WRKHTBL->(dbGoTop())

                If WRKHTBL->(!EoF())
                    If WRKHTBL->VICM > 0
                        nVIcmSufr := WRKHTBL->VICM
                    EndIf
                    If WRKHTBL->VPIS > 0
                        nVPisSufr := WRKHTBL->VPIS
                    EndIf
                    If WRKHTBL->VCOF > 0
                        nVCofSufr := WRKHTBL->VCOF
                    EndIf
                EndIf
                WRKHTBL->(dbCloseArea())

                If ( nVIcmSufr > 0 .Or. nVPisSufr > 0 .Or. nVCofSufr > 0)

                    cMensFis += "Descontos ref. a Zona Franca de Manaus / ALC:"

                    If nVIcmSufr > 0
                        cMensFis += " ICMS R$ " +Alltrim(TransForm(nVIcmSufr,"@E 999,999,999.99"))
                    EndIf

                    If nVPisSufr > 0
                        cMensFis += " PIS R$ " +Alltrim(TransForm(nVPisSufr,"@E 999,999,999.99"))
                    EndIf

                    If nVCofSufr > 0
                        cMensFis += " Cofins R$ " +Alltrim(TransForm(nVCofSufr,"@E 999,999,999.99"))
                    EndIf

                    cMensFis += ". "

                EndIf

            EndIf

        EndIf

    EndIf

EndIf

//----------------------------------------------------------------------------------------------------------- 
// Ajusta Indicador de Presenca e Indicativo de Intermediario
//----------------------------------------------------------------------------------------------------------- 
If !("SUFRAMA" $ Upper(cMensFis))
    If !Empty(cCodSuframa)
        cMensFis += "Codigo Suframa: " +cCodSuframa
    EndIf
EndIf

//----------------------------------------------------------------------------------------------------------- 
// Ajusta Indicador de Presenca e Indicativo de Intermediario
//----------------------------------------------------------------------------------------------------------- 
If aProcess[20] <> 0
    If aNota[4] == "1"
        If cC5Tipo == "N"
            cIndPres := "9"
            cIndIntermed := "0"
        Else
            cIndPres := "0"
            cIndIntermed := ""
        EndIf
    Else
        cIndPres := "9"
        cIndIntermed := "0"
    EndIf
EndIf

//----------------------------------------------------------------------------------------------------------- 
// Tipo de Pagamento
//----------------------------------------------------------------------------------------------------------- 
If aProcess[21] <> 0

    If aNota[4] == "1" // NF de Saída

        cQry := "SELECT DISTINCT "
        cQry += "F2.F2_DUPL AS F2DUPL, "
        cQry += "F2.F2_TIPO AS F2TIPO, "
        cQry += "A1.A1_BCO1 AS A1BCO1, "
        cQry += "A1.A1_INTER AS A1INTER, "
        cQry += "C5.C5_CONDPAG AS C5CONDPAG "
        cQry += "FROM "
        cQry += cSF2Tbl+ " F2, "
        cQry += cSA1Tbl+ " A1, "
        cQry += cSD2Tbl+ " D2, "
        cQry += cSC5Tbl+ " C5 "
        cQry += "WHERE F2.D_E_L_E_T_ = ' ' "
        cQry += "AND F2.F2_FILIAL = '" +cSF2Fil+ "' "
        cQry += "AND F2.F2_DOC = '" +aNota[2]+ "' "
        cQry += "AND F2.F2_SERIE = '" +aNota[1]+ "' "
        cQry += "AND A1.D_E_L_E_T_ = ' ' "
        cQry += "AND A1.A1_FILIAL = '" +cSA1Fil+ "' "
        cQry += "AND A1.A1_COD = F2.F2_CLIENTE "
        cQry += "AND A1.A1_LOJA = F2.F2_LOJA "
        cQry += "AND D2.D_E_L_E_T_ = ' ' "
        cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
        cQry += "AND D2.D2_DOC = F2.F2_DOC "
        cQry += "AND D2.D2_SERIE = F2.F2_SERIE "
        cQry += "AND D2.D2_CLIENTE = F2.F2_CLIENTE "
        cQry += "AND D2.D2_LOJA = F2.F2_LOJA "
        cQry += "AND C5.D_E_L_E_T_ = ' ' "
        cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
        cQry += "AND C5.C5_NUM = D2.D2_PEDIDO "

        Iif(Select("WRKITBL")>0,WRKITBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKITBL",.T.,.T.)
        WRKITBL->(dbGoTop())

        If WRKITBL->(!EoF())

            If WRKITBL->A1INTER == "S"
                cCondPG := "90" // Sem Pagamento
            EndIf

            If WRKITBL->F2TIPO <> "N"
                cCondPG := "90" // Sem Pagamento
            EndIf

            If Empty(cCondPG)
                If ( WRKITBL->C5CONDPAG $ cCondAV )
                    cCondPG := "16" // A Vista - Deposito Bancario
                EndIf
            EndIf

            If Empty(cCondPG)
                If WRKITBL->A1BCO1 == "999"
                    cCondPG := "16" // Deposito Bancario
                EndIf
            EndIf

            If Empty(cCondPG)
                If Empty(WRKITBL->F2DUPL)
                    cCondPG := "90" // Sem Pagamento
                Else
                    cCondPG := "15" // Boleto Bancario
                EndIf
            EndIf

        EndIf
        
        If Empty(cCondPG)
            cCondPG := "90"
        EndIf

        aDetPag[1,1] := cCondPG

        WRKITBL->(dbCloseArea())

    Else

        cQry := "SELECT F1.F1_DUPL AS F1DUPL "
        cQry += "FROM " +cSF1Tbl+ " F1 WHERE F1.D_E_L_E_T_ = ' ' "
        cQry += "AND F1.F1_FILIAL = '" +cSF1Fil+ "' "
        cQry += "AND F1.F1_DOC = '" +aNota[2]+ "' "
        cQry += "AND F1.F1_SERIE = '" +aNota[1]+ "' "
        cQry += "AND F1.F1_FORMUL = 'S' "

        Iif(Select("WRKMTBL")>0,WRKMTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKMTBL",.T.,.T.)
        WRKMTBL->(dbGoTop())

        If WRKMTBL->(!EoF())
            If Empty(WRKMTBL->F1DUPL)
                cCondPG := "90"
            EndIf
            WRKMTBL->(dbSkip())
        EndIf
        WRKMTBL->(dbCloseArea())

        If !Empty(cCondPG)
            aDetPag[1,1] := cCondPG
        EndIf

    EndIf

EndIf

For nNx := 1 to Len( aProd )

    cQry := "SELECT "
    cQry += "ISNULL(B1.B1_COD,'') AS B1COD, "
    cQry += "ISNULL(B1.B1_CODBAR,'') AS B1CODBAR, "
    cQry += "ISNULL(B1.B1_ORIGEM,'') AS B1ORIGEM, "
    cQry += "ISNULL(B1.B1_TIPO,'') AS B1TIPO "
    cQry += "FROM "
    cQry += cSB1Tbl+ " B1, "
    cQry += cSD2Tbl+ " D2 "
    cQry += "WHERE B1.D_E_L_E_T_ = ' ' "
    cQry += "AND B1.B1_FILIAL = '" +cSB1Fil+ "' "
    cQry += "AND B1.B1_COD = D2.D2_COD "
    cQry += "AND D2.D_E_L_E_T_ = ' ' "
    cQry += "AND D2.D2_FILIAL = '" +cSD2Fil+ "' "
    cQry += "AND D2.D2_SERIE = '" +aNota[1]+ "' "
    cQry += "AND D2.D2_DOC = '" +aNota[2]+ "' "
    cQry += "AND D2.D2_COD = '" +aProd[nNx,Len(aProd[nNx])]+ "'"

    Iif(Select("WRKKTBL")>0,WRKKTBL->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKKTBL",.T.,.T.)
    WRKKTBL->(dbGoTop())

    If WRKKTBL->(!EoF())

        If !Empty(WRKKTBL->B1COD)

            //----------------------------------------------------------------------------------------------------------- 
            // Codigo Ean / Codigo do Produto
            //----------------------------------------------------------------------------------------------------------- 
            If aProcess[22] <> 0
                aProd[nNx,3] := Iif(Val(WRKKTBL->B1CODBAR)==0.OR.SUBSTR(WRKKTBL->B1CODBAR,1,LEN(ALLTRIM(WRKKTBL->B1COD)))=ALLTRIM(WRKKTBL->B1COD).OR.LEN(ALLTRIM(WRKKTBL->B1CODBAR))<13,"",StrZero(Val(WRKKTBL->B1CODBAR),Len(Alltrim(WRKKTBL->B1CODBAR)),0))
            EndIf

            //----------------------------------------------------------------------------------------------------------- 
            // Mensagem SINIEF para empresa 01
            //----------------------------------------------------------------------------------------------------------- 
            If aProcess[23] <> 0
                If cEmpAnt == "01"
                    If !Empty(cFrmSINEF)
                        If WRKKTBL->B1ORIGEM <> "0" .And. WRKKTBL->B1TIPO == "PA"
                            cMsgSINEF	:= Alltrim(Formula(cFrmSINEF)) + " "
                        EndIf
                        If !Empty(cMsgSINEF)
                            If !( Upper(Alltrim(cMsgSINEF)) $ Upper(Alltrim(cMensCli)) )
                                cMensCli += cMsgSINEF+ ". "
                            EndIf
                        EndIf
                    EndIf
                EndIf

            EndIf

        EndIf

    EndIf
    WRKKTBL->(dbCloseArea())

Next nNx

//----------------------------------------------------------------------------------------------------------- 
// Observacao da NF de Entrada nos Dados Adicionais
//----------------------------------------------------------------------------------------------------------- 
If aNota[4] == "0"

    If aProcess[24] <> 0

        cQry := "SELECT "
        cQry += "RTRIM(LTRIM(CAST(ISNULL(CONVERT(VARCHAR(MAX),CONVERT(VARBINARY(MAX),F1_OBSNFE)),'') AS CHAR(255)))) AS F1OBSNFE "
        cQry += "FROM " +cSF1Tbl+ " WHERE D_E_L_E_T_ = ' ' "
        cQry += "AND F1_FILIAL = '" +cSF1Fil+ "' "
        cQry += "AND F1_SERIE = '" +aNota[1]+ "' "
        cQry += "AND F1_DOC = '" +aNota[2]+ "' "
        cQry += "AND F1_FORMUL = 'S' "

        Iif(Select("WRKNTBL")>0,WRKNTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKNTBL",.T.,.T.)
        WRKNTBL->(dbGoTop())

        If WRKNTBL->(!EoF())
            cMensCli += Alltrim(WRKNTBL->F1OBSNFE)
        EndIf
        WRKNTBL->(dbCloseArea())

    EndIf


    //----------------------------------------------------------------------------------------------------------- 
    // NF de Entrada: formula especifica da TES - Campo F4_MSGPAD
    //----------------------------------------------------------------------------------------------------------- 
    If aProcess[25] <> 0

        cQry := "SELECT DISTINCT "
        cQry += "F4.F4_MSGPAD AS F4MSGPAD "
        cQry += "FROM "
        cQry += cSF4Tbl+ " F4, "
        cQry += cSD1Tbl+ " D1 "
        cQry += "WHERE F4.D_E_L_E_T_ = ' ' "
        cQry += "AND F4.F4_FILIAL = '" +cSF4Fil+ "' "
        cQry += "AND F4.F4_CODIGO = D1.D1_TES "
        cQry += "AND F4.F4_MSGPAD <> '' "
        cQry += "AND D1.D_E_L_E_T_ = ' ' "
        cQry += "AND D1.D1_FILIAL = '" +cSD1Fil+ "' "
        cQry += "AND D1.D1_DOC = '" +aNota[2]+ "' "
        cQry += "AND D1.D1_SERIE = '" +aNota[1]+ "' "
        cQry += "AND D1.D1_FORMUL = 'S' "
        cQry += "ORDER BY F4.F4_MSGPAD"

        Iif(Select("WRKPTBL")>0,WRKPTBL->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKPTBL",.T.,.T.)
        WRKPTBL->(dbGoTop())

        While WRKPTBL->(!EoF())
            cMsgTES := Alltrim(Formula(WRKPTBL->F4MSGPAD)) + Space(2)
            If !Empty(cMsgTES)
                If !( Upper(Alltrim(cMsgTES)) $ Upper(Alltrim(cMensFis)) )
                    cMensFis += cMsgTES+ ". "
                EndIf
            EndIf
            WRKPTBL->(dbSkip())
        EndDo
        WRKPTBL->(dbCloseArea())

    EndIf

EndIf


//----------------------------------------------------------------------------------------------------------- 
// Remove underline e mais de um espaco em sequencia das mensagens
//----------------------------------------------------------------------------------------------------------- 
If aProcess[26] <> 0
    cMensCli := StrTran(cMensCli,"_","")
    cMensCli := StrTran(cMensCli,"  "," ")
    cMensFis := StrTran(cMensFis,"_","")
    cMensFis := StrTran(cMensFis,"  "," ")
EndIf
If aProcess[27] <> 0
    cMensCli := StrTran(cMensCli,". . ",".")
EndIf

//----------------------------------------------------------------------------------------------------------- 
// Aglutina Produtos de NFs de Transferencia (somente Cross Docking)
//----------------------------------------------------------------------------------------------------------- 
If aProcess[28] <> 0
    If cNumRM == "CROSS"
        Aglutina_aProd(@aProd,@a01ICMSAg,@a02ICMSSTAg,@a03IPIAg,@a04PISAg,@a05PISSTAg,@a06COFINSAg,@a07COFINSSTAg,@a08ISSQNAg,@a09CSTAg,@a10MedAg,@a11ArmaAg,@a12VeicProdAg,@a13DIAg,@a14aDIAg,@a15ExpAg,@a16PisAlqZAg,@a17CofAlqZAg)
    EndIf
EndIf

aRetPE := { aProd,      cMensCli,   cMensFis,   aDest,; 
            aNota,      aInfoItem,  aDupl,      aTransp,;
            aEntrega,   aRetirada,  aVeiculo,   aReboque,;
            aNfVincRur, aEspVol,    aNfVinc,    aDetPag,;
            aObsCont,   aProcRef,   aMed,       aLote,;
            aPedcom,    cIndPres,   cIndIntermed,;
            {a01ICMSAg,;
            a02ICMSSTAg,  a03IPIAg,      a04PISAg,      a05PISSTAg,;
            a06COFINSAg,  a07COFINSSTAg, a08ISSQNAg,    a09CSTAg,;
            a10MedAg,     a11ArmaAg,     a12VeicProdAg, a13DIAg,;
            a14aDIAg,     a15ExpAg,      a16PisAlqZAg,  a17CofAlqZAg }}

Return( aRetPE )



// Programa     Aglutina_aProd
// Descricao    Faz a aglutinacao de produtos (somente para NFs de Cross Docking)
// Obs          Funcao foi copiada do NFeSefaz antigo da Taiff
// Data         14-JUL-2021
// Uso          Especifico TAIFF
Static Function Aglutina_aProd( aProdAg, a01ICMSAg, a02ICMSSTAg, a03IPIAg, a04PISAg, a05PISSTAg,;
                                a06COFINSAg, a07COFINSSTAg, a08ISSQNAg, a09CSTAg, a10MedAg, a11ArmaAg,;
                                a12VeicProdAg, a13DIAg, a14aDIAg, a15ExpAg, a16PisAlqZAg, a17CofAlqZAg )
	Local nSeq              := 1
	Local aAProdAglut	    := {}
	Local aBICMSAglut	    := {}
	Local aCICMSSTAglut	    := {}
	Local aDIPIAglut		:= {}
	Local aEPISAglut		:= {}
	Local aFPISSTAglut	    := {}
	Local aGCOFINSAglut	    := {}
	Local aHCOFINSSTAglut   := {}
	Local aIISSQNAglut      := {}
	Local aJCSTAglut		:= {}
	Local aKMedAglut		:= {}
	Local aLArmaAglut	    := {}
	Local aMVeicProdAglut   := {}
	Local aNDIAglut		    := {}
	Local aOaNDIAglut		:= {}
	Local aPExpAglut		:= {}
	Local aQPisAlqZAglut	:= {}
	Local aRCofAlqZAglut	:= {}
	Local nLoop             := 0
	Local nX                := 0

	For nX := 1 to Len(aProdAg)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Richard - 14/04/10                       ³
		//³Pesquisa se existe o mesmo produto e CFOP³
		//--------------------------------------------------------------------------------------------------------------
		// Implementado a condição "mesmo preço" na condição "mesmo produto e CFOP"
		// Autor: Carlos Alday Torres                                       Data: 05/10/2015
		// aProd[nX,2] = Codigo do Produto
		// aProd[nX,7] = CFOP
		// aProd[nX,16] = preço venda
		// aProd[nX,33] = Aliquota ICMS
		// aProd[nX,23] = CST
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		nPosProd := Ascan(aAProdAglut,{|x| x[2] = aProdAg[nX,2] .And. x[7] = aProdAg[nX,7] .And. x[33] = aProdAg[nX,33] .And. x[23] = aProdAg[nX,23]})

		If Empty(nPosProd)

			Aadd(aAProdAglut,Array(Len(aProdAg[nX])))
			aAProdAglut[Len(aAProdAglut)]   := Aclone(aProdAg[nX])
			aAProdAglut[Len(aAProdAglut),1] := nSeq

			Aadd(aBICMSAglut,Array(Len(a01ICMSAg[nX])))
			aBICMSAglut[Len(aBICMSAglut)]   := Aclone(a01ICMSAg[nX])

			Aadd(aCICMSSTAglut,Array(Len(a02ICMSSTAg[nX])))
			aCICMSSTAglut[Len(aCICMSSTAglut)]   := Aclone(a02ICMSSTAg[nX])

			Aadd(aDIPIAglut,Array(Len(a03IPIAg[nX])))
			aDIPIAglut[Len(aDIPIAglut)]   :=  Aclone(a03IPIAg[nX])

			Aadd(aEPISAglut,Array(Len(a04PISAg[nX])))
			aEPISAglut[Len(aEPISAglut)]   :=  Aclone(a04PISAg[nX])

			Aadd(aFPISSTAglut,Array(Len(a05PISSTAg[nX])))
			aFPISSTAglut[Len(aFPISSTAglut)]   :=  Aclone(a05PISSTAg[nX])

			Aadd(aGCOFINSAglut,Array(Len(a06COFINSAg[nX])))
			aGCOFINSAglut[Len(aGCOFINSAglut)]   :=  Aclone(a06COFINSAg[nX])

			Aadd(aHCOFINSSTAglut,Array(Len(a07COFINSSTAg[nX])))
			aHCOFINSSTAglut[Len(aHCOFINSSTAglut)]   :=  Aclone(a07COFINSSTAg[nX])

			Aadd(aIISSQNAglut,Array(Len(a08ISSQNAg[nX])))
			aIISSQNAglut[Len(aIISSQNAglut)]   :=  Aclone(a08ISSQNAg[nX])

			Aadd(aJCSTAglut,Array(Len(a09CSTAg[nX])))
			aJCSTAglut[Len(aJCSTAglut)]   :=  Aclone(a09CSTAg[nX])

			Aadd(aKMedAglut,Array(Len(a10MedAg[nX])))
			aKMedAglut[Len(aKMedAglut)]   :=  Aclone(a10MedAg[nX])

			Aadd(aLArmaAglut,Array(Len(a11ArmaAg[nX])))
			aLArmaAglut[Len(aLArmaAglut)]   :=  Aclone(a11ArmaAg[nX])

			Aadd(aMVeicProdAglut,Array(Len(a12VeicProdAg[nX])))
			aMVeicProdAglut[Len(aMVeicProdAglut)]   :=  Aclone(a12VeicProdAg[nX])

			Aadd(aNDIAglut,Array(Len(a13DIAg[nX])))
			aNDIAglut[Len(aNDIAglut)]   :=  Aclone(a13DIAg[nX])

			Aadd(aOaNDIAglut,Array(Len(a14aDIAg[nX])))
			aOaNDIAglut[Len(aOaNDIAglut)]   :=  Aclone(a14aDIAg[nX])

			Aadd(aPExpAglut,Array(Len(a15ExpAg[nX])))
			aPExpAglut[Len(aPExpAglut)]   :=  Aclone(a15ExpAg[nX])

			Aadd(aQPisAlqZAglut,Array(Len(a16PisAlqZAg[nX])))
			aQPisAlqZAglut[Len(aQPisAlqZAglut)]   :=  Aclone(a16PisAlqZAg[nX])

			Aadd(aRCofAlqZAglut,Array(Len(a17CofAlqZAg[nX])))
			aRCofAlqZAglut[Len(aRCofAlqZAglut)]   :=  Aclone(a17CofAlqZAg[nX])

			nSeq ++

		Else

			If ! Empty(aProdAg[nX])

				aAProdAglut[nPosProd,09] += aProdAg[nX,09]
				aAProdAglut[nPosProd,10] += aProdAg[nX,10]
				aAProdAglut[nPosProd,12] += aProdAg[nX,12]
				aAProdAglut[nPosProd,13] += aProdAg[nX,13]
				aAProdAglut[nPosProd,14] += aProdAg[nX,14]
				aAProdAglut[nPosProd,15] += aProdAg[nX,15]
				aAProdAglut[nPosProd,21] += aProdAg[nX,21]

			EndIf

			If ! Empty(a01ICMSAg[nX])

				aBICMSAglut[nPosProd,05] += a01ICMSAg[nX,05]
				aBICMSAglut[nPosProd,07] += a01ICMSAg[nX,07]
				aBICMSAglut[nPosProd,09] += a01ICMSAg[nX,09]
				aBICMSAglut[nPosProd,06] := a01ICMSAg[nX,06] // Aliquota do ICMS

			Endif

			If ! Empty(a02ICMSSTAg[nX])

				//
				// A condição abaixo inibe erro de programa, causado por nota fiscal tem o mesmo produto mais de uma vez,
				// onde o primeiro destes não tem ST e o segundo tem. Veja exemplo da nota fiscal 000026041 da DAIHATSU.
				//
				// Autor: Carlos Alday Torres                                       Data: 27/01/2011
				//

				If Len( aCICMSSTAglut[nPosProd] ) = 0
					aCICMSSTAglut[nPosProd]   := Aclone(a02ICMSSTAg[nX])
				Else
					aCICMSSTAglut[nPosProd,05] += a02ICMSSTAg[nX,05]
					aCICMSSTAglut[nPosProd,07] += a02ICMSSTAg[nX,07]
					aCICMSSTAglut[nPosProd,09] += a02ICMSSTAg[nX,09]
				EndIf

			EndIf

			If ! Empty(a03IPIAg[nX])

				aDIPIAglut[nPosProd,06] += a03IPIAg[nX,06]
				aDIPIAglut[nPosProd,07] += a03IPIAg[nX,07]
				aDIPIAglut[nPosProd,10] += a03IPIAg[nX,10]

			EndIF

			If ! Empty(a04PISAg[nX])

				aEPISAglut[nPosProd,02] += a04PISAg[nX,02]
				aEPISAglut[nPosProd,04] += a04PISAg[nX,04]
				aEPISAglut[nPosProd,05] += a04PISAg[nX,05]

			EndIf

			If ! Empty(a05PISSTAg[nX])

				aFPISSTAglut[nPosProd,02] += a05PISSTAg[nX,02]
				aFPISSTAglut[nPosProd,04] += a05PISSTAg[nX,04]
				aFPISSTAglut[nPosProd,05] += a05PISSTAg[nX,05]

			EndIf

			If ! Empty(a06COFINSAg[nX])

				aGCOFINSAglut[nPosProd,02] += a06COFINSAg[nX,02]
				aGCOFINSAglut[nPosProd,04] += a06COFINSAg[nX,04]
				aGCOFINSAglut[nPosProd,05] += a06COFINSAg[nX,05]

			EndIf

			If ! Empty(a07COFINSSTAg[nX])

				aHCOFINSSTAglut[nPosProd,02] += a07COFINSSTAg[nX,02]
				aHCOFINSSTAglut[nPosProd,04] += a07COFINSSTAg[nX,04]
				aHCOFINSSTAglut[nPosProd,05] += a07COFINSSTAg[nX,05]

			EndIf

			If ! Empty(a08ISSQNAg[nX])

				aIISSQNAglut[nPosProd,02] += a08ISSQNAg[nX,02]
				aIISSQNAglut[nPosProd,05] += a08ISSQNAg[nX,05]

			EndIf

		EndIf

	Next nX

	For nLoop :=1 to Len(aBICMSAglut)
		aBICMSAglut[nLoop,07] := (aBICMSAglut[nLoop,05] * (aBICMSAglut[nLoop,06]/100))
	Next nLoop

	aProdAg		    := aAProdAglut
	a01ICMSAg		:= aBICMSAglut
	a02ICMSSTAg	    := aCICMSSTAglut
	a03IPIAg		:= aDIPIAglut
	a04PISAg		:= aEPISAglut
	a05PISSTAg	    := aFPISSTAglut
	a06COFINSAg	    := aGCOFINSAglut
	a07COFINSSTAg	:= aHCOFINSSTAglut
	a08ISSQNAg	    := aIISSQNAglut
	a09CSTAg		:= aJCSTAglut
	a10MedAg		:= aKMedAglut
	a11ArmaAg		:= aLArmaAglut
	a12VeicProdAg	:= aMVeicProdAglut
	a13DIAgAg		:= aNDIAglut
	a14aDIAg		:= aOaNDIAglut
	a15ExpAg		:= aPExpAglut
	a16PisAlqZAg	:= aQPisAlqZAglut
	a17CofAlqZAg	:= aRCofAlqZAglut

Return(Nil)
