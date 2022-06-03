#Include "PROTHEUS.CH"
//--------------------------------------------------------------                                                    
//Description                                                     
//@param xParam Parameter Description                             
//@return xRet Return Description                                 
//@author  -                                               
//@since 16/12/2021                                                   
//--------------------------------------------------------------                        
User Function ACTFAT01( cNumPV, nOper )
Local cQry := ""
Local cSC5Tbl := ""
Local cSC5Fil := ""
Local cSB1Tbl := ""
Local cSB1Fil := ""
Local cSC6Tbl := ""
Local cSC6Fil := ""
Local cCB8Tbl := ""
Local cCB8Fil := ""
Local cCB7Tbl := ""
Local cCB7Fil := ""
Local aLbx001 := {}
Local cStaOS := ""
Local cGerOS := ""
Local cMsg := ""
Local lRet := .T.
Default nOper := 0

If cEmpAnt == "04"

    cSC5Tbl := RetSqlName("SC5")
    cSC5Fil := xFilial("SC5")
    cSB1Tbl := RetSqlName("SB1")
    cSB1Fil := xFilial("SB1")
    cSC6Tbl := RetSqlName("SC6")
    cSC6Fil := xFilial("SC6")
    cCB8Tbl := RetSqlName("CB8")
    cCB8Fil := xFilial("CB8")
    cCB7Tbl := RetSqlName("CB7")
    cCB7Fil := xFilial("CB7")

    cQry := "SELECT DISTINCT "
    cQry += "C6.C6_XORDSEP AS GERAOS, "
    cQry += "ISNULL(CB8.CB8_ORDSEP,'') AS ORDSEP, "
    cQry += "ISNULL(CB7.CB7_STATUS,'') AS STATUSOS, "
    cQry += "C6.C6_ITEM AS ITEM, "
    cQry += "C6.C6_PRODUTO AS CODPRO, "
    cQry += "B1.B1_DESC AS DESCPRO, "
    cQry += "C6.C6_QTDVEN AS QTDPV, "
    cQry += "C6.R_E_C_N_O_ AS C6RCN "
    cQry += "FROM " 
    cQry += cSC5Tbl+ " C5, "
    cQry += cSB1Tbl+ " B1, "
    cQry += cSC6Tbl+ " C6 "
    cQry += "LEFT OUTER JOIN " +cCB8Tbl+ " CB8 ON CB8.D_E_L_E_T_ = ' ' "
    cQry += "AND CB8.CB8_FILIAL = '" +cCB8Fil+ "' "
    cQry += "AND CB8.CB8_PEDIDO = C6.C6_NUM "
    cQry += "AND CB8.CB8_PROD = C6.C6_PRODUTO "
    cQry += "AND CB8.CB8_ITEM = C6.C6_ITEM "
    cQry += "LEFT OUTER JOIN " +cCB7Tbl+ " CB7 ON CB7.D_E_L_E_T_ = ' ' "
    cQry += "AND CB7.CB7_FILIAL = '" +cCB7Fil+ "' "
    cQry += "AND CB7.CB7_PEDIDO = C6.C6_NUM "
    cQry += "AND CB7.CB7_ORDSEP = CB8.CB8_ORDSEP "
    cQry += "WHERE C5.D_E_L_E_T_ = ' ' "
    cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
    cQry += "AND C5.C5_NUM = '" +cNumPV+ "' "
    cQry += "AND C5.C5_TIPO = 'B' "
    cQry += "AND C6.D_E_L_E_T_ = ' ' "
    cQry += "AND C6.C6_FILIAL = '" +cSC6Fil+ "' "
    cQry += "AND C6.C6_NUM = C5.C5_NUM "
    cQry += "AND B1.D_E_L_E_T_ = ' ' "
    cQry += "AND B1.B1_FILIAL = '" +cSB1Fil+ "' "
    cQry += "AND B1.B1_COD = C6.C6_PRODUTO "
    cQry += "AND B1.B1_ITEMSEG = '1' "

    Iif(Select("WKMKPV")>0,WKMKPV->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKMKPV",.T.,.T.)
    TcSetField("WKMKPV","QTDPV","N",12,2)
    TcSetField("WKMKPV","C6RCN","N",14,0)
    WKMKPV->(dbGoTop())

    If WKMKPV->(!EoF())

        If !Empty(WKMKPV->CODPRO)

            //Antes de alterar, desmarca todos os itens
            If nOper == 4

                cQry := "UPDATE " +cSC6Tbl+ " SET C6_XORDSEP = ' ' WHERE D_E_L_E_T_ = ' ' "
                cQry += "AND C6_FILIAL = '" +cSC6Fil+ "' "
                cQry += "AND C6_NUM = '" +cNumPV+ "'"
                TcSqlExec( cQry )

            EndIf

            While WKMKPV->(!EoF())

                If ( nOper == 3 .Or. nOper == 4 )

                    cQry := "UPDATE " +cSC6Tbl+ " SET C6_XORDSEP = 'S' WHERE R_E_C_N_O_ = " + Alltrim(Str(WKMKPV->C6RCN))
                    TcSqlExec( cQry )

                ElseIf ( nOper == 98 ) //Verifica se PV tem OS vinculada

                    If !Empty(WKMKPV->ORDSEP)

                        lRet := .F.
                        cMsg := "Este pedido está vinculado a ordem de separação " +Alltrim(WKMKPV->ORDSEP)+ ". "
                        cMsg += "Estorne a ordem de separação antes de alterar o pedido."

                    EndIf

                ElseIf ( nOper == 99 ) //Lista a OS

                    cGerOS := ""
                    If WKMKPV->GERAOS == "S"
                        cGerOS := "Sim"
                    Else
                        cGerOS := "Nao"
                    EndIf

                    cStaOS := ""
                    If WKMKPV->STATUSOS == "0"
                        cStaOS := "0=Inicio"
                    ElseIf WKMKPV->STATUSOS == "1"
                        cStaOS := "1=Separando"
                    ElseIf WKMKPV->STATUSOS == "2"
                        cStaOS := "2=Sep.Final"
                    ElseIf WKMKPV->STATUSOS == "3"
                        cStaOS := "3=Embalando"
                    ElseIf WKMKPV->STATUSOS == "4"
                        cStaOS := "4=Emb.Final"
                    ElseIf WKMKPV->STATUSOS == "5"
                        cStaOS := "5=Gera Nota"
                    ElseIf WKMKPV->STATUSOS == "6"
                        cStaOS := "6=Imp.nota"
                    ElseIf WKMKPV->STATUSOS == "7"
                        cStaOS := "7=Imp.Vol"
                    ElseIf WKMKPV->STATUSOS == "8"
                        cStaOS := "8=Embarcado"
                    ElseIf WKMKPV->STATUSOS == "9"
                        cStaOS := "9=Emb.Final."            
                    Else
                        cStaOS := ""
                    EndIf
                
                    aAdd( aLbx001,{ cGerOS,;
                                    WKMKPV->ORDSEP,;
                                    cStaOS,;
                                    WKMKPV->ITEM,;
                                    WKMKPV->CODPRO,;
                                    WKMKPV->DESCPRO,;
                                    WKMKPV->QTDPV })

                EndIf

                WKMKPV->(dbSkip())

            EndDo

        EndIf

    EndIf
    WKMKPV->(dbCloseArea())

    If nOper == 99

        If Len( aLbx001 ) > 0

            ExibDet( cNumPV, aLbx001 )

        Else

            lRet := .F.
            cMsg := "Este pedido não é de beneficiamento, ou não está vinculado a uma ordem de separação"

        EndIf

    EndIf

    If !Empty(cMsg)
        MsgInfo(cMsg)
    EndIf

EndIf

Return(lRet)



Static Function ExibDet( cNumPV, aLbx001 )
Local oBt001, oDlg := Nil

DEFINE MSDIALOG oDlg TITLE "Ordem de Separação Vinculada ao Pedido de Vendas nro. " FROM 000, 000  TO 400, 800 COLORS 0, 16777215 PIXEL

    @ 007, 005 LISTBOX oLbx001 Fields HEADER "Gera OS","Nro. OS","Status OS","Item Ped.","Cod. Produto","Descrição do Produto","Quant." SIZE 390, 171 OF oDlg PIXEL ColSizes 30,40,50,30,60,120,30
    oLbx001:SetArray(aLbx001)
    oLbx001:bLine := {|| {;
      aLbx001[oLbx001:nAt,1],;
      aLbx001[oLbx001:nAt,2],;
      aLbx001[oLbx001:nAt,3],;
      aLbx001[oLbx001:nAt,4],;
      aLbx001[oLbx001:nAt,5],;
      aLbx001[oLbx001:nAt,6],;
      aLbx001[oLbx001:nAt,7] }}
    @ 183, 358 BUTTON oBt001 PROMPT "Fechar" SIZE 037, 012 OF oDlg ACTION (oDlg:End()) PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)
