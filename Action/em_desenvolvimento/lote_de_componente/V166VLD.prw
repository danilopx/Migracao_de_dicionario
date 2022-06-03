#Include "Protheus.Ch"
#Include "APVT100.CH"

//Programa:   V166VLD
//Finalidade: Ponto de Entrada que valida o produto na Separacao - ACD
//Autor:      Ronald Piscioneri
//Data:       09-Set-2021

User Function V166VLD()
Local cPrc1 := SuperGetMV("V166VLD01",,"S")
Local cPrc2 := SuperGetMV("V166VLD02",,"N") //Pergunta se confirma a gravacao do lote (S), ou grava o lote sem perguntar (N) ?
Local cLotF := ""
Local cConf := ""
Local cNNFe := ""
Local cSNFe := ""
Local cCodP := PadR(Upper(Alltrim(ParamIxb[1])),15)
Local aAtuArea := {}
Local aSB1Area := {}
Local aCB7Area := {}
Local aCB8Area := {}
Local aSC2Area := {}
Local aSC5Area := {}
Local aSC6Area := {}

If cPrc1 == "S"

    aAtuArea := GetArea()
    aSC2Area := SC2->(GetArea())
    aSB1Area := SB1->(GetArea())
    aCB7Area := CB7->(GetArea())
    aCB8Area := CB8->(GetArea())
    aSC5Area := SC5->(GetArea())
    aSC6Area := SC6->(GetArea())

    dbSelectArea("CB7")
    CB7->(dbSetOrder(1))
    If CB7->(dbSeek(xFilial("CB7")+cOrdSep))

        If !Empty(CB7->CB7_OP)

            dbSelectArea("SB1")
            SB1->(dbSetOrder(1))
            If SB1->(dbSeek(xFilial("SB1")+cCodP))

                If SB1->B1_ITEMSEG == "1"

                    If ParamIxb[2] <= nSaldoCB8

                        While Empty(cLotF)

                            cLotF := "                    "
                            cNNFe := "         "
                            cSNFe := "   "

                            VTClear
                            @ 1,00 VTSay "Item de Seguranca"
                            @ 2,00 VTSay cCodP
                            @ 3,00 VTSay "Leia o Lote"
                            @ 4,00 VTGet cLotF Pict "@!"
                            @ 5,00 VTSay "Leia a Nota"
                            @ 6,00 VTGet cNNFe Pict "@R 999999999"
                            @ 6,10 VTSay "-"
                            @ 6,12 VTGet cSNFe Pict "@R 999"
                            VTRead

                            If Empty(cLotF)

                                VTClear
                                @ 1,0 VTSay "ATENCAO:"
                                @ 2,0 VTSay "o lote do produto"
                                @ 3,0 VTSay cCodP
                                @ 4,0 VTSay "e' obrigatorio."
                                Inkey(3)

                            Else

                                cConf := " "

                                If !Empty(cNNFe)
                                    cNNFe := StrZero(Val(cNNFe),9)
                                EndIf
                                If !Empty(cSNFe)
                                    cSNFe := StrZero(Val(cSNFe),3)
                                EndIf

                                If cPrc2 == "S"

                                    VTClear
                                    @ 1,0 VTSay "Confirma o lote:"
                                    @ 2,0 VTSay Alltrim(cLotF)
                                    @ 3,0 VTSay "e Nota Fiscal:"
                                    @ 4,0 VTSay Alltrim(cNNFe)+"-"+Alltrim(cSNFe)
                                    @ 5,0 VTSay "para o produto: "
                                    @ 6,0 VTSay cCodP
                                    @ 7,0 VTSay "(S/N)?"
                                    @ 7,8 VTGet cConf Pict "@!" Valid(cConf $ "SN")
                                    VTRead

                                Else

                                    cConf := "S"

                                EndIf
                                    
                                If cConf <> "S"

                                    cLotF := ""
                                    cNNFe := ""
                                    cSNFe := ""

                                Else

                                    dbSelectArea("SC2")
                                    SC2->(dbSetOrder(1))
                                    If SC2->(dbSeek(xFilial("SC2")+CB8->CB8_OP))

                                        dbSelectArea("ZZS")
                                        ZZS->(dbSetOrder(1))
                                        If RecLock("ZZS",.T.)
                                            ZZS->ZZS_FILIAL := xFilial("ZZS")
                                            ZZS->ZZS_TPREG := "0"
                                            ZZS->ZZS_DTEVEN := Date()
                                            ZZS->ZZS_NUMNF := cNNFe
                                            ZZS->ZZS_SERNF := cSNFe
                                            ZZS->ZZS_COMPON := cCodP
                                            ZZS->ZZS_CODPA := SC2->C2_PRODUTO
                                            ZZS->ZZS_ORDSEP := cOrdSep
                                            ZZS->ZZS_OP := CB8->CB8_OP
                                            ZZS->ZZS_LOTEF := cLotF
                                            ZZS->ZZS_QTDCMP := ParamIxb[2]
                                            ZZS->ZZS_USERID := __cUserId
                                            ZZS->ZZS_USERNM := Alltrim(cUserName)
                                            ZZS->(MsUnLock())
                                        EndIf

                                    EndIf

                                EndIf

                            EndIf

                        EndDo

                    EndIf

                EndIf

            EndIf

        EndIf

        If !Empty(CB7->CB7_PEDIDO)

            dbSelectArea("SC6")
            SC6->(dbSetOrder(12)) // C6_FILIAL + C6_NUM + C6_PRODUTO + C6_SOLCOM
            If SC6->(dbSeek(xFilial("SC6")+ CB7->CB7_PEDIDO+cCodP))

                If SC6->C6_XORDSEP == "S"

                    If ParamIxb[2] <= nSaldoCB8

                        While Empty(cLotF)

                            cLotF := "                    "
                            cNNFe := "         "
                            cSNFe := "   "

                            VTClear
                            @ 1,00 VTSay "Item de Seguranca"
                            @ 2,00 VTSay cCodP
                            @ 3,00 VTSay "Leia o Lote"
                            @ 4,00 VTGet cLotF Pict "@!"
                            @ 5,00 VTSay "Leia a Nota"
                            @ 6,00 VTGet cNNFe Pict "@R 999999999"
                            @ 6,10 VTSay "-"
                            @ 6,12 VTGet cSNFe Pict "@R 999"
                            VTRead

                            If Empty(cLotF)

                                VTClear
                                @ 1,0 VTSay "ATENCAO:"
                                @ 2,0 VTSay "o lote do produto"
                                @ 3,0 VTSay cCodP
                                @ 4,0 VTSay "e' obrigatorio."
                                Inkey(3)

                            Else

                                cConf := " "

                                If !Empty(cNNFe)
                                    cNNFe := StrZero(Val(cNNFe),9)
                                EndIf
                                If !Empty(cSNFe)
                                    cSNFe := StrZero(Val(cSNFe),3)
                                EndIf

                                If cPrc2 == "S"

                                    VTClear
                                    @ 1,0 VTSay "Confirma o lote:"
                                    @ 2,0 VTSay Alltrim(cLotF)
                                    @ 3,0 VTSay "e Nota Fiscal:"
                                    @ 4,0 VTSay Alltrim(cNNFe)+"-"+Alltrim(cSNFe)
                                    @ 5,0 VTSay "para o produto: "
                                    @ 6,0 VTSay cCodP
                                    @ 7,0 VTSay "(S/N)?"
                                    @ 7,8 VTGet cConf Pict "@!" Valid(cConf $ "SN")
                                    VTRead

                                Else

                                    cConf := "S"

                                EndIf
                                    
                                If cConf <> "S"

                                    cLotF := ""
                                    cNNFe := ""
                                    cSNFe := ""

                                Else

                                    dbSelectArea("SC5")
                                    SC5->(dbSetOrder(1))
                                    If SC5->(dbSeek(xFilial("SC5")+CB7->CB7_PEDIDO))

                                        dbSelectArea("SC6")
                                        SC6->(dbSetOrder(12))
                                        If SC6->(dbSeek(xFilial("SC6")+CB7->CB7_PEDIDO+cCodP))

                                            dbSelectArea("ZZS")
                                            ZZS->(dbSetOrder(1))
                                            If RecLock("ZZS",.T.)

                                                ZZS->ZZS_FILIAL := xFilial("ZZS")
                                                ZZS->ZZS_TPREG := "3"
                                                ZZS->ZZS_DTEVEN := Date()
                                                ZZS->ZZS_NUMNF := cNNFe
                                                ZZS->ZZS_SERNF := cSNFe
                                                ZZS->ZZS_COMPON := cCodP
                                                ZZS->ZZS_ORDSEP := cOrdSep
                                                ZZS->ZZS_OP := SC6->C6__OPBNFC
                                                ZZS->ZZS_PEDVEN := CB7->CB7_PEDIDO
                                                ZZS->ZZS_ITEMPV := SC6->C6_ITEM
                                                ZZS->ZZS_TIPOPV := SC5->C5_TIPO
                                                ZZS->ZZS_LOTEF := cLotF
                                                ZZS->ZZS_QTDCMP := ParamIxb[2]
                                                ZZS->ZZS_USERID := __cUserId
                                                ZZS->ZZS_USERNM := Alltrim(cUserName)
                                                If ( "|N|" $ SC5->C5_TIPO )
                                                    ZZS->ZZS_CODCLI := SC5->C5_CLIENTE
                                                    ZZS->ZZS_LOJCLI := SC5->C5_LOJACLI
                                                Else
                                                    ZZS->ZZS_CODFOR := SC5->C5_CLIENTE
                                                    ZZS->ZZS_LOJFOR := SC5->C5_LOJACLI
                                                EndIf

                                                ZZS->(MsUnLock())

                                            EndIf

                                        EndIf

                                    EndIf

                                EndIf

                            EndIf

                        EndDo

                    EndIf

                EndIf

            EndIf

        EndIf

    EndIf

    RestArea(aSC6Area)
    RestArea(aSC5Area)
    RestArea(aCB8Area)
    RestArea(aCB7Area)
    RestArea(aSB1Area)
    RestArea(aSC2Area)
    RestArea(aAtuArea)

EndIf

Return(.T.)
