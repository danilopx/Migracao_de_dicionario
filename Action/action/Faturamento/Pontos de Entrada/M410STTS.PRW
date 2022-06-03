#Include "Protheus.Ch"

User Function M410STTS()
Local nOper := ParamIxb[1]

If ( nOper == 3 .Or. nOper == 4 )

    If U_TFVLDPVB( SC5->C5_NUM )
       U_ACTFAT01( SC5->C5_NUM )
    EndIf

EndIf

Return(Nil)
