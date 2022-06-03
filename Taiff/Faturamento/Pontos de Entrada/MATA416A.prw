#INCLUDE 'PROTHEUS.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MATA416A.prw
=================================================================================
||   Funcao: 	MATA416A
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Este ponto de entrada pertence � rotina de baixa de or�amentos de venda, 
|| 	MATA416(). � acionado no in�cio da execu��o da rotina.
|| 		Ser� utilizado para realizar o controle de semaforo, evitando assim que 
|| 	o mesmo Or�amento gere mais de um Pedido de Venda 
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger
||   Data:		12/01/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MATA416A()

	LOCAL CNAMEBLQ := SUPERGETMV("TF_SMFLIB",.F.,"SMFLIBORC")

	/*
	|---------------------------------------------------------------------------------
	|	N�o ser� utilizado o comando de UNLOCKBYNAME(). O sem�foro se perder� no 
	|	fechamento do processo (thread).
	|---------------------------------------------------------------------------------
	*/
	IF !LOCKBYNAME(CNAMEBLQ,.F.,.F.,.T.)

		MESSAGEBOX("Existe um usu�rio utilizando a Rotina de Aprova��o de Venda!" + ENTER + "Aguarde","ATEN��O",64)
		__QUIT()

	ENDIF 

	lImporta := Iif(GetMV("MV__FTMI07")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
	If lImporta
		MsgStop("Rotina efetivacao orcamentos ja esta sendo executada - MATA416A")
		__QUIT()
	EndIf	

RETURN