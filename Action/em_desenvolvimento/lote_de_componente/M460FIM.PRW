#Include "Protheus.Ch"

User Function M460FIM()
Local cQry := ""
Local cZZSTbl := RetSqlName("ZZS")
Local cZZSFil := xFilial("ZZS")
Local cSD2Tbl := RetSqlName("SD2")
Local cSD2Fil := xFilial("SD2")
Local aZZSRcn := {}
Local nNx := 0

cQry := "SELECT DISTINCT "
cQry += "ISNULL(ZZS.R_E_C_N_O_,0) AS ZZSRCN "
cQry += "FROM "
cQry += cZZSTbl+ " ZZS, "
cQry += cSD2Tbl+ " SD2 "
cQry += "WHERE ZZS.D_E_L_E_T_ = ' ' "
cQry += "AND ZZS_FILIAL = '" +cZZSFil+ "' "
cQry += "AND ZZS_TPREG = '3' "
cQry += "AND SD2.D_E_L_E_T_ = ' ' "
cQry += "AND D2_FILIAL = '" +cSD2Fil+ "' "
cQry += "AND D2_COD = ZZS_COMPON "
cQry += "AND D2_ITEMPV = ZZS_ITEMPV "
cQry += "AND D2_PEDIDO = ZZS_PEDVEN "
cQry += "AND D2_TIPO = ZZS_TIPOPV "
cQry += "AND D2_DOC = '" +SF2->F2_DOC+ "' "
cQry += "AND D2_SERIE = '" +SF2->F2_SERIE+ "' "
cQry += "AND D2_FORMUL = '" +SF2->F2_FORMUL+ "' "
cQry += "AND D2_CLIENTE = '" +SF2->F2_CLIENTE+ "' "
cQry += "AND D2_LOJA = '" +SF2->F2_LOJA+ "' "

Iif(Select("WKNFPV")>0,WKNFPV->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKNFPV",.T.,.T.)
TcSetField("WKNFPV","ZZSRCN","N",14,0)
WKNFPV->(dbGoTop())

While WKNFPV->(!EoF())
    If WKNFPV->ZZSRCN > 0

        cQry := "UPDATE " +cZZSTbl+ " SET "
        cQry += "ZZS_NFSBNF = '" +SF2->F2_DOC+ "', "
        cQry += "ZZS_SRSBNF = '" +SF2->F2_SERIE+ "' "
        cQry += "WHERE R_E_C_N_O_ = " + Alltrim(Str(WKNFPV->ZZSRCN))
    
        aAdd( aZZSRcn, cQry )

    EndIf
    WKNFPV->(dbSkip())
EndDo
WKNFPV->(dbCloseArea())

For nNx := 1 to Len(aZZSRcn)

    TcSqlExec(aZZSRcn[nNx])

Next nNx


Return(Nil)
