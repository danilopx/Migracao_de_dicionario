#Include "Protheus.Ch"

User Function M410STTS()
Local nOper := ParamIxb[1]

If cEmpAnt == "04"

    If ( nOper == 3 .Or. nOper == 4 )

        U_ACTFAT01( SC5->C5_NUM, nOper )

    EndIf

EndIf

Return(Nil)
