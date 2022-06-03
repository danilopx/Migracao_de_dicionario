#include "Protheus.ch"
#include "FWMVCDEF.CH"  

//-------------------------------------------------------------------
/*/{Protheus.doc} CRMA980
Ponto de Entrada do Cadastro de Clientes (MVC)
@param      Não há
@return     Vários. Dependerá de qual PE está sendo executado.
@author 	Faturamento
@version	12.1.17 / Superior
@since		Mai/2021
/*/
//-------------------------------------------------------------------
User Function CRMA980()
Local nOpt := 0
Local lRet := .T.

If ParamIxb[2] == 'MODELPOS'

    MsgRun("Validando dados...","Aguarde...",{||lRet:=U_MA030TOK()})

EndIf

If ParamIxb[2] == 'MODELCOMMITNTTS'

    nOpt := ParamIxb[1]:nOperation
    
    If ( nOpt == 3 .Or. nOpt == 4 .Or. nOpt == 5 )

        MsgRun("Replicando para as demais empresas...","Aguarde...",{||U_TPPROCREP("SA1","U_CADSA1",nOpt)})
    
    EndIf

EndIf

Return(lRet)
