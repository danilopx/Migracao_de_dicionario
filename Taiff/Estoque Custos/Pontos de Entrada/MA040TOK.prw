#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	MA040TOK.PRW
=================================================================================
||   Funcao:	MA040TOK
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de Entrada na Confirmacao da Inclusao/Alteracao do Cadastro  
||	de Vendedores
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	28/10/2014
=================================================================================
=================================================================================
*/

USER FUNCTION MA040TOK()

LOCAL cEmpCad		:= GetMV("MV_GRPCAD"	,,"01")

IF INCLUI
	Processa({|| U_TPPROCREP("SA3","U_CADSA3",3) },"Replicando para as demais empresas...")
ELSE
	Processa({|| U_TPPROCREP("SA3","U_CADSA3",4) },"Replicando para as demais empresas...")
ENDIF

IF CEMPANT $ CEMPCAD
	
	U_M040GER(3,SA3->A3_COD)
	
ENDIF

RETURN .T.