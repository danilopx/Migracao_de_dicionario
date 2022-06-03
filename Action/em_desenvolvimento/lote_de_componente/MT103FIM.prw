#Include "Protheus.Ch"

User Function MT103FIM()
Local cQry := ""
Local cSD1Tbl := ""
Local cSD1Fil := ""
Local cZZSTbl := ""
Local cZZSFil := ""
Local aUpd := {}
Local nNx := 0

//Confirmacao da Inclusao / Classificacao
If ( ParamIxb[1]  == 3 .Or. ParamIxb[1] == 4 ) .And. ParamIxb[2] == 1 

    cSD1Tbl := RetSqlName("SD1")
    cSD1Fil := xFilial("SD1")
    cZZSTbl := RetSqlName("ZZS")
    cZZSFil := xFilial("ZZS")

    cQry := "SELECT DISTINCT "
    cQry += "ISNULL(ZZS.R_E_C_N_O_,0) AS ZZSRCN "
    cQry += "FROM "
    cQry += cSD1Tbl+ " D1, "
    cQry += cZZSTbl+ " ZZS "
    cQry += "WHERE D1.D_E_L_E_T_ = ' ' "
    cQry += "AND D1_FILIAL = '" +cSD1Fil+ "' "
    cQry += "AND D1_DOC = '" +cNFiscal+ "' "
    cQry += "AND D1_SERIE = '" +cSerie+ "' "
    cQry += "AND D1_FORNECE = '" +cA100For+ "' "
    cQry += "AND D1_LOJA = '" +cLoja+ "' "
    cQry += "AND D1_NFORI <> '' "
    cQry += "AND ZZS.D_E_L_E_T_ = ' ' "
    cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' "
    cQry += "AND ZZS_TPREG = '3' "
    cQry += "AND ZZS_NFSBNF = D1_NFORI "
    cQry += "AND ZZS_SRSBNF = D1_SERIORI "
    cQry += "AND ZZS_COMPON = D1_COD "
    cQry += "AND ZZS_CODFOR = D1_FORNECE "
    cQry += "AND ZZS_LOJFOR = D1_LOJA "

    Iif(Select("WKNFPV")>0,WKNFPV->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKNFPV",.T.,.T.)
    TcSetField("WKNFPV","ZZSRCN","N",14,0)
    WKNFPV->(dbGoTop())

    While WKNFPV->(!EoF())

        If WKNFPV->ZZSRCN > 0

            cQry := "UPDATE " +cZZSTbl+ " SET "
            cQry += "ZZS_NFEBNF = '" +cNFiscal+ "', "
            cQry += "ZZS_SREBNF = '" +cSerie+ "' "
            cQry += "WHERE R_E_C_N_O_ = " +Alltrim(Str(WKNFPV->ZZSRCN))

            aAdd( aUpd, cQry )

        EndIf

        WKNFPV->(dbSkip())
    EndDo
    WKNFPV->(dbCloseArea())

    For nNx := 1 to Len(aUpd)
        TcSqlExec(aUpd[nNx])
    Next nNx

EndIf

Return(Nil)
