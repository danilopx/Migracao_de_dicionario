#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	M460NOTA.prw
=================================================================================
||   Funcao:	M460NOTA 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de entrada 'M460NOTA', executado ao final do processamento de 
||	todas as notas fiscais selecionadas na markbrowse e recebe como parametro  
|| 	o alias da tabela.
|| 		Sera utilizado para desativar o Semaforo no Processo de CrossDocking.
|| 
=================================================================================
=================================================================================
||   Autor: Edson Hornberger
||   Data:	11/09/2015
=================================================================================
=================================================================================
*/

USER FUNCTION M460NOTA()

PRIVATE CSMFT01		:= GETMV("MV_SMFT01",.F.,"DEFAULT01")	
PRIVATE CSMFT02		:= GETMV("MV_SMFT02",.F.,"DEFAULT02")

IF CEMPANT + CFILANT = '0302'

	UNLOCKBYNAME(CSMFT01,.T.,.T.,.F.)
	UNLOCKBYNAME(CSMFT02,.T.,.T.,.F.)

ENDIF 

RETURN