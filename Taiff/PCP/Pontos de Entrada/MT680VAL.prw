#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	MT680VAL.prw
=================================================================================
||   Funcao: 	MT680VAL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Programa que faz consistencias ap�s a digita��o da tela.
|| 		� chamado na confirma��o da inclus�o das produ��es PCP, modelo I e II 
||	(fun��o A680TudoOk()).
||	� utilizado para validar a inclus�o do apontamento das produ��es PCP. 
|| 	Para verificar de qual programa esta chamando a funcao, utilize as variaveis 
||	Private l680,l681,l682 e l250 a partir da versao 6.09
||
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	27/04/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MT680VAL()

LOCAL LRET := .T. 
	
IF M->H6_QTDPROD <= 0  .And. !IsInCallStack("MATA682")
	
	MSGALERT("O campo de quantidade produzida n�o foi informado!","ATEN��O")
	LRET := .F.
	
ENDIF 
	
RETURN(LRET)