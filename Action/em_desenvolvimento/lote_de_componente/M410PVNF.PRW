#Include "Protheus.ch"

//Programa:   M410PVNF
//Descricao:  Ponto de Entrada antes de gerar a NF-e, permite fazer validacoes
//Retorno:    L (.T./.F.: prossegue ou nao com a geracao da NF-e)
//Autor:      Ronald Piscioneri
//Data:       30-Nov-2021

User Function M410PVNF()
Local lRet := .T.
Local cVldOSBnf := ""
Local cTpPV := ""
Local cCFBnf := ""
Local cMsg := ""
Local cQry := ""

//Para pedidos de beneficiamento, e' necessario gravar o lote do fornecedor, para itens de
//seguranca. A gravacao e' feita na separacao do ACD. Portanto, so' permite faturar pedido
//de vendas de beneficiamento se a separacao estiver concluida

If cEmpAnt == "04"

    cVldOSBnf := SuperGetMV("M410PNF01",,"S")

    If cVldOSBnf == "S"

        //Verifica se e' um pedido de beneficiamento
        cTpPV := SuperGetMV("M410PNF02",,"('B')")
        cCFBnf := SuperGetMV("M410PNF03",,"('5901','6901','5902','6902')")

        cQry := "SELECT DISTINCT C5_NUM AS C5NUM "
        cQry += "FROM "
        cQry += RetSqlName("SC5")+ " C5, "
        cQry += RetSqlName("SC6")+ " C6, "
        cQry += RetSqlName("SB1")+ " B1 "
        cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
        If !Empty(cTpPV)
            cQry += "AND C5.C5_TIPO IN " +cTpPV+ " "
        EndIf
        cQry += "AND C5.R_E_C_N_O_ = " +Alltrim(Str(ParaIxb))+ " "
        cQry += "AND C6.D_E_L_E_T_ = ' ' "
        cQry += "AND C6_FILIAL = C5_FILIAL "
        cQry += "AND C6_NUM = C5_NUM "
        If !Empty(cCFBnf)
            cQry += "AND C6_CF IN " +cCFBnf+ " "
        EndIf
        cQry += "AND B1.D_E_L_E_T_ = ' ' "
        cQry += "AND B1_FILIAL = C6_FILIAL "
        cQry += "AND B1_COD = C6_PRODUTO "
        cQry += "AND B1_ITEMSEG = '1' "

        Iif(Select("WKPVBN")>0,WKPVBN->(dbCloseArea()),Nil)
        dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKPVBN",.T.,.T.)
        WKPVBN->(dbGoTop())

        If WKPVBN->(!EoF())

        If !Empty(WKPVBN->C5NUM)

                //Verifica Ordem de Separacao
                cQry := "SELECT "
                cQry += "CB7_ORDSEP AS CB7ORDSEP, "
                cQry += "CB7_STATUS AS CB7STATUS, "
                cQry += "FROM " +RetSqlName("CB7")+ " "
                cQry += "WHERE D_E_L_E_T_ = ' ' "
                cQry += "AND CB7_FILIAL = '" +xFilial("CB7")+ "' "
                cQry += "AND CB7_PEDIDO = '" +WKPVBN->C5NUM+ "' "

                Iif(Select("WKOSPV")>0,WKOSPV->(dbCloseArea()),Nil)
                dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKOSPV",.T.,.T.)
                WKOSPV->(dbGoTop())

                If WKOSPV->(!EoF())
                    If !Empty(WKOSPV->CB7ORDSEP)
                        If Alltrim(WKOSPV->CB7STATUS) <> "9"
                            cMsg := "Nao e possivel gerar NF para o pedido " +Alltrim(WKPVBN->C5NUM)+ ": "
                            cMsg += "a ordem de separacao " +Alltrim(WKOSPV->CB7ORDSEP)+ " nao esta concluida."
                        EndIf
                    Else
                        cMsg := "Nao e possivel gerar NF para o pedido " +Alltrim(WKPVBN->C5NUM)+ ": "
                        cMsg += "nao existe ordem de separacao para este pedido."
                    EndIf
                Else
                    cMsg := "Nao e possivel gerar NF para o pedido " +Alltrim(WKPVBN->C5NUM)+ ": "
                    cMsg += "nao existe ordem de separacao para este pedido."
                EndIf
                WKOSPV->(dbCloseArea())
        
            EndIf

        EndIf
        WKPVBN->(dbCloseArea())

    EndIf

    If !Empty(cMsg)
        lRet := .F.
        Alert(cMsg)
    EndIf

EndIf

Return(lRet)
