#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	ACD100GI.prw
=================================================================================
||   Funcao: 	ACD100GI
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		No momento da grava??o dos itens da ordem de separa??o, permitindo 
|| 	gravar campos espec?ficos.
||		Sera utilizado para preenchimento de campos referentes ao novo Processo 
|| 	de CrossDocking.
||-------------------------------------------------------------------------------
||	VARIAVEIS
||-------------------------------------------------------------------------------
||		nOrigExp = Ordem de Separa??o ser? gerada por: 
||					1 - Pedido de Venda
||					2 - Nota Fiscal
||					3 - Ordem de Produ??o
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	25/09/2015
=================================================================================
=================================================================================
*/

USER FUNCTION ACD100GI()

IF NORIGEXP = 1 .AND. CEMPANT='03' .AND. CFILANT='02'
 
	CB8->CB8_PEDORI := SC9->C9_PEDORI		
	
ENDIF 

RETURN