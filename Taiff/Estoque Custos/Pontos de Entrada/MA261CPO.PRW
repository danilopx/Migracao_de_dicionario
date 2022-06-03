#include "PROTHEUS.CH"

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MA261CPO 		                    AUTOR: ABM						         DATA: 31/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para inclusão de colunas na GRID da transferencia no modelo II
//| SOLICITANTE: 
//| OBSERVACAO: PE executado pela rotina MATA261
//+--------------------------------------------------------------------------------------------------------------

User Function MA261CPO()
PUBLIC _cOpBuffer := ""  // Variavel para controle de movimentação na tabela SD4, executada pelos botoes customizados
PUBLIC _lViewBuff	:= .T.

aAdd(aHeader, {"Op.Transf", "D3_OPTRANS", "@!", 11, 0, "", "", "C", "", ""})                                                                              
//incluido por JAR == 16/02/2010
aAdd(aHeader, {"Num Pedido", "D3_NUM_PED", "@!", 23, 0, "", "", "C", "", ""}) 	

Return