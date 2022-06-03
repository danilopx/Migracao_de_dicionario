#Include "Protheus.Ch"

//Programa:     MT140SAI
//Finalidade:   P.E. ao sair da tela de Pre-Nota. Exclui lote de componente 
//Autor:        Ronald Piscioneri
//Data:         14-Set-2021
//Uso:          Taiff / Action

User Function MT140SAI()
Local nOpt := ParamIxb[1]
Local cNumNF := ParamIxb[2]
Local cSerNF := ParamIxb[3]
Local cCodFor := ParamIxb[4]
Local cLojFor := ParamIxb[5]
Local lGo := ( ParamIxb[7] == 1 )
Local cEmpFAtl := SuperGetMV("MT140SAI01",,"|0402|")
Local cSql := ""

If lGo
    If nOpt == 5 //Exclusao da Pre-Nota
        If ( Alltrim(cEmpAnt) + Alltrim(cFilAnt) ) $ cEmpFAtl

            cSql := "UPDATE " +RetSqlName("ZZS")+ " "
            cSql += "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
            cSql += "WHERE D_E_L_E_T_ = ' ' "
            cSql += "AND ZZS_FILIAL = '" +xFilial("ZZS")+ "' "
            cSql += "AND ZZS_NUMNF = '" +cNumNF+ "' "
            cSql += "AND ZZS_SERNF = '" +cSerNF+ "' "
            cSql += "AND ZZS_CODFOR = '" +cCodFor+ "' "
            cSql += "AND ZZS_LOJFOR = '" +cLojFor+ "' "

            TcSqlExec( cSql )

        EndIf
    EndIf
EndIf

Return(Nil)
