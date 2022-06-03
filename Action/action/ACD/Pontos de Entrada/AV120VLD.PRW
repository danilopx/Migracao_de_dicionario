#Include "Protheus.Ch"
#Include "APVT100.CH"

//Programa:   AV120VLD
//Finalidade: Ponto de Entrada que grava o lote do componente na Conferencia da Pre-Nota
//Autor:      Ronald Piscioneri
//Data:       13-Set-2021

User Function AV120VLD()
Local cPrc1 := SuperGetMV("AV120VLD01",,"S")
Local cLotF := ""
Local cConf := ""
Local cCodP := PadR(Alltrim(cEtiqProd),15)
Local aAtuArea := {}
Local aSB1Area := {}
Local aTBkp := {}
Local nGrvQtd := 0

If cPrc1 == "S"

    If SD1->D1_QTDCONF <= SD1->D1_QUANT

        aAtuArea := GetArea()
        aSB1Area := SB1->(GetArea())

        dbSelectArea("SB1")
        SB1->(dbSetOrder(1))
        If SB1->(dbSeek(xFilial("SB1")+cCodP))

            If SB1->B1_ITEMSEG == "1"

                aTBkp := VTSave()

                While Empty(cLotF)

                    cLotF := "                    "
                    VTClear
                    @ 1,0 VTSay "Leia o Lote "
                    @ 2,0 VTSay cCodP
                    @ 4,0 VTGet cLotF Pict "@!"
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
                        VTClear
                        @ 1,0 VTSay "Confirma o lote "
                        @ 2,0 VTSay cLotF
                        @ 3,0 VTSay "para o produto "
                        @ 4,0 VTSay cCodP
                        @ 5,0 VTSay "(S/N)?"
                        @ 5,8 VTGet cConf Pict "@!" Valid(cConf $ "SN")
                        VTRead

                        If cConf <> "S"

                            cLotF := ""

                        Else

                            nGrvQtd := 0

                            If Type("nQtdEtiq2") == "N"
                                If nQtdEtiq2 > 0
                                    nGrvQtd := nQtdEtiq2
                                Else
                                    nGrvQtd := nQtdEtiq
                                EndIf
                            Else
                                nGrvQtd := nQtdEtiq
                            EndIf

                            dbSelectArea("ZZS")
                            ZZS->(dbSetOrder(1))

                            If RecLock("ZZS",.T.)
                                ZZS->ZZS_FILIAL := xFilial("ZZS")
                                ZZS->ZZS_TPREG := "2"
                                ZZS->ZZS_DTEVEN := Date()
                                ZZS->ZZS_NUMNF := SD1->D1_DOC
                                ZZS->ZZS_SERNF := SD1->D1_SERIE
                                ZZS->ZZS_ITEMNF := SD1->D1_ITEM
                                ZZS->ZZS_CODFOR := SD1->D1_FORNECE
                                ZZS->ZZS_LOJFOR := SD1->D1_LOJA
                                ZZS->ZZS_COMPON := cCodP
                                ZZS->ZZS_LOTEF := cLotF
                                ZZS->ZZS_QTDCMP := nGrvQtd
                                ZZS->ZZS_USERID := __cUserId
                                ZZS->ZZS_USERNM := Alltrim(cUserName)
                                ZZS->(MsUnLock())
                            EndIf

                        EndIf

                    EndIf

                EndDo

                VtRestore(,,,,aTBkp)

            EndIf

        EndIf

        RestArea(aSB1Area)
        RestArea(aAtuArea)

    EndIf

EndIf

Return(.T.)
