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
|| 		Esse ponto de entrada é executado antes da eliminação de resíduo 
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
	
	MSGINFO("Realizar a Eliminação de Resíduo no Pedido Original." + ENTER + "Empresa/Filial: " + SC5->C5_EMPDES + "/" + SC5->C5_FILDES + ENTER + "Pedido: " + SC5->C5_NUM,"ATENÇÃO")
	LRET := .F.

ELSEIF (CEMPANT + CFILANT) = "0301" .AND. SC5->C5_CLASPED != "A"
	
	IF !(SC5->C5_STCROSS $ CSTATUS) 
	
		MSGINFO("Pedido está em Processo de CrossDocking e não pode ser eliminado resíduo durante o Processo!","ATENÇÃO")
		LRET := .F. 		
	
	ENDIF
	
ENDIF
	
RETURN(LRET)

