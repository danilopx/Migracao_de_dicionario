#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"

/*
=================================================================================
=================================================================================
||   Arquivo:	A415TBPR.prw
=================================================================================
||   Funcao: 	A415TBPR
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 	Evitar a rejei��o na importa��o de pedido FATMI001 quando se trata de pedido 
|| de SP e marca TAIFF a rotina automatica busca a tabela de pre�o da filial 01
|| sendo que deve permanecer a tabela de pre�o da filial 02
|| 
|| 
=================================================================================
=================================================================================
||   Autor:	CARLOS TORRES  
||   Data:	18/01/2016
=================================================================================
=================================================================================
*/
User Function A415TBPR()
Local cTabela := M->CJ_TABELA

	/***********************************************************/
	/* Executar se o programa que chamou a fun��o for(FATMI001)*/
	/* Inclu�do por Gilberto Ribeiro Jr (04/08/2016)		   */
	/***********************************************************/
	//S� faz a valida��o quando o Verifica se o programa que chamou esta function � o programa de importa��o de pedidos
	If IsInCallStack("U_FATMI001") .OR. IsInCallStack("U_CFGMI02T") .OR. IsInCallStack("U_CFGMI02P") .OR. IsInCallStack("U_IMPASSTEC")
		If l415Auto
			cTabela := (_cPSC5)->C5_TABELA
		EndIf
	EndIf

Return (cTabela)

