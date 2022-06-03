#include "PROTHEUS.CH"
//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MA260Exc 		                    AUTOR: Carlos Alday Torres	         DATA: 18/04/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para estorno da transferencia do empenho do BUFFER
//| SOLICITANTE: 
//| OBSERVACAO: PE executado pela rotina MATA260 - Transferencia Mod. I
//+--------------------------------------------------------------------------------------------------------------

User Function MA260Exc()
Local _cUpDate		:= ""
Local	__nQtdSD3	:= SD3->D3_QUANT
Local __cDesEnde	:= GETNEWPAR("MV_TFENDES","BUFFER") 


If SD3->D3_TM > "500" .and. Alltrim(SD3->D3_LOCALIZ)=Alltrim(__cDesEnde)

	_cUpdate := "UPDATE SD4 "
	_cUpdate += "	SET  SD4.D4_QTBUFPG = D4_QTBUFPG - " +  Alltrim( Str(__nQtdSD3) )
	_cUpdate += " FROM "
	_cUpdate += "  " + RetSqlName("SD4") + " SD4 "
	_cUpdate += " WHERE"
	_cUpdate += "	D_E_L_E_T_ = ' ' "
	_cUpdate += "	AND D4_FILIAL	= '" + xFilial("SD4") + "'"
	_cUpdate += "  AND D4_COD		= '" + SD3->D3_COD + "'"
	_cUpdate += "  AND D4_OP      = '" + SD3->D3_OPTRANS + "' "
	_cUpdate += "  AND D4_TRT		= '" + SD3->D3_TRT + "'"
	//_cUpdate += "  AND D4_LOTECTL	= '" + SD3->D3_LOTECTL + "'"
	//_cUpdate += "  AND D4_NUMLOTE	= '" + SD3->D3_NUMLOTE + "'"
	
	TCSqlExec(_cUpdate)

	_cUpdate := "UPDATE SD4 "
	_cUpdate += "	SET  SD4.D4_QTBUFPG = 0 " 
	_cUpdate += " FROM "
	_cUpdate += "  " + RetSqlName("SD4") + " SD4 "
	_cUpdate += " WHERE"
	_cUpdate += "	D_E_L_E_T_ = ' ' "
	_cUpdate += "	AND D4_FILIAL	= '" + xFilial("SD4") + "'"
	_cUpdate += "  AND D4_COD		= '" + SD3->D3_COD + "'"
	_cUpdate += "  AND D4_OP      = '" + SD3->D3_OPTRANS + "' "
	_cUpdate += "  AND D4_TRT		= '" + SD3->D3_TRT + "'"
	//_cUpdate += "  AND D4_LOTECTL	= '" + SD3->D3_LOTECTL + "'"
	//_cUpdate += "  AND D4_NUMLOTE	= '" + SD3->D3_NUMLOTE + "'"
	_cUpdate += "  AND SD4.D4_QTBUFPG < 0 "
	
	TCSqlExec(_cUpdate)
	
EndIf	
Return NIL