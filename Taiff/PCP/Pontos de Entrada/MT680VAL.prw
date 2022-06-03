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
|| 		Programa que faz consistencias após a digitação da tela.
|| 		É chamado na confirmação da inclusão das produções PCP, modelo I e II 
||	(função A680TudoOk()).
||	É utilizado para validar a inclusão do apontamento das produções PCP. 
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
	
	MSGALERT("O campo de quantidade produzida não foi informado!","ATENÇÃO")
	LRET := .F.
	
ENDIF 
	
RETURN(LRET)