#Include "Protheus.Ch"

User Function MS520DEL()
Local cUpd := ""

If SF2->F2_TIPO == "B"

    cUpd := "UPDATE " +RetSqlName("ZZS")+ " SET "
    cUpd += "ZZS_NFSBNF = '', "
    cUpd += "ZZS_SRSBNF = '' "
    cUpd += "WHERE D_E_L_E_T_ = ' ' "
    cUpd += "AND ZZS_FILIAL = '" +xFilial("ZZS")+ "' "
    cUpd += "AND ZZS_TPREG = '3' "
    cUpd += "AND ZZS_NFSBNF = '" +SF2->F2_DOC+ "' "
    cUpd += "AND ZZS_SRSBNF = '" +SF2->F2_SERIE+ "' "
    cUpd += "AND ZZS_CODFOR = '" +SF2->F2_CLIENTE+ "' "
    cUpd += "AND ZZS_LOJFOR = '" +SF2->F2_LOJA+ "' "

    TcSqlExec(cUpd)

EndIf

Return(Nil)
