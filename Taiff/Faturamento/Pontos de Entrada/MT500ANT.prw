#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT500ANT.prw
=================================================================================
||   Funcao: 	MT500ANT
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Esse ponto de entrada � executado antes da elimina��o de res�duo 
|| 	por registro do SC6.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:	30/09/2015
=================================================================================
=================================================================================
*/

USER FUNCTION MT500ANT()

LOCAL LRET := .T.
LOCAL CSTATUS := "ABERTO|ATPARC" 
	
IF (CEMPANT + CFILANT) != (SC5->C5_EMPDES + SC5->C5_FILDES)
	
	MSGINFO("Realizar a Elimina��o de Res�duo no Pedido Original." + ENTER + "Empresa/Filial: " + SC5->C5_EMPDES + "/" + SC5->C5_FILDES + ENTER + "Pedido: " + SC5->C5_NUM,"ATEN��O")
	LRET := .F.

ELSEIF (CEMPANT + CFILANT) = "0301" .AND. SC5->C5_CLASPED != "A"
	
	IF !(SC5->C5_STCROSS $ CSTATUS) 
	
		MSGINFO("Pedido est� em Processo de CrossDocking e n�o pode ser eliminado res�duo durante o Processo!","ATEN��O")
		LRET := .F. 		
	
	ENDIF
	
ENDIF
	
RETURN(LRET)

