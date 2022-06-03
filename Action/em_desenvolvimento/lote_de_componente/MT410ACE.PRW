#Include "Protheus.Ch"
User Function MT410ACE()
Local lRet := .T.
Local nOpt := 0

If cEmpAnt == "04"

    If ParamIxb[1] == 4 //Alteracao
        nOpt := 98
    ElseIf ParamIxb[1] == 5 //Exclusao
        nOpt := 98
    EndIf

    If nOpt <> 0
        lRet := U_ACTFAT01( SC5->C5_NUM, nOpt )
    EndIf

EndIf

Return(lRet)
