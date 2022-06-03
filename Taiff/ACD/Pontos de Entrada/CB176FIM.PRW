#Include "Protheus.Ch"
//Programa:		CB176FIM
//Descricao:	Ponto de Entrada apos a gravacao das tabelas na rotina ACDV176 - "Desfaz Separacao"
//Parametro:    ParamIxb (Nro da Ordem de Separacao)
//Retorno:      Nenhum
//Finalidade:   Limpar o campo C9_XORDSEP caso a separacao tenha sido desfeita
//Autor:		Ronald Piscioneri
//Data:			22-ABR-2021
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

//Limpa OS do PV, somente se a OS foi desfeita completamente
If lGo

    cQry := "UPDATE " +RetSqlName("SC9")+ " "
    cQry += "SET C9_XORDSEP = '' "
    cQry += "WHERE D_E_L_E_T_ = ' ' "
    cQry += "AND C9_FILIAL = '" +xFilial("SC9")+ "' "
    cQry += "AND C9_XORDSEP = '" +ParamIxb+ "' "

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
