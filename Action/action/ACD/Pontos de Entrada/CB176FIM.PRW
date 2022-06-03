#Include "Protheus.Ch"
//Programa:		CB176FIM
//Descricao:	Ponto de Entrada apos a gravacao das tabelas na rotina ACDV176 - "Desfaz Separacao"
//Parametro:    ParamIxb (Nro da Ordem de Separacao)
//Retorno:      Nenhum
//Finalidade:   Excluir registros do Monitor Lote de Componente (tab. ZZS), 
//              quando a separação for totalmente concluida
//Autor:		Ronald Piscioneri
//Data:			15-OUT-2021
User Function CB176FIM()
Local cQry := ""
Local lGo := .T.

//Verifica se todos os itens tiveram a separacao desfeita
cQry := "SELECT TOP 1 A.CB9_PROD AS CB9PROD "
cQry += "FROM " +RetSqlName("CB9")+ " A "
cQry += "WHERE A.D_E_L_E_T_ = ' ' "
cQry += "AND A.CB9_FILIAL = '" +xFilial("CB9")+ "'
cQry += "AND A.CB9_ORDSEP = '" +ParamIxb+ "'"

Iif(Select("WKXCB9")>0,WKXCB9->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKXCB9",.T.,.T.)
WKXCB9->(dbGoTop())

If WKXCB9->(!EoF())
    If !Empty(WKXCB9->CB9PROD)
        lGo := .F.
    EndIf
EndIf
WKXCB9->(dbCloseArea())

If lGo

    cQry := "UPDATE " +RetSqlName("ZZS")+ " "
    cQry += "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
    cQry += "WHERE D_E_L_E_T_ = ' ' "
    cQry += "AND ZZS_FILIAL = '" +xFilial("ZZS")+ "' "
    cQry += "AND ZZS_ORDSEP = '" +ParamIxb+ "' "

    BeginTran()

    If TcSqlExec(cQry) <> 0
        lGo := .F.
    EndIf

    If !lGo
        DisarmTransaction()
    EndIf

    EndTran()

EndIf

Return(Nil)
