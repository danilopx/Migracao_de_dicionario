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
|| 		Este ponto de entrada pertence à rotina de baixa de orçamentos de venda, 
|| 	MATA416(). É acionado no início da execução da rotina.
|| 		Será utilizado para realizar o controle de semaforo, evitando assim que 
|| 	o mesmo Orçamento gere mais de um Pedido de Venda 
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
	|	Não será utilizado o comando de UNLOCKBYNAME(). O semáforo se perderá no 
	|	fechamento do processo (thread).
	|---------------------------------------------------------------------------------
	*/
	IF !LOCKBYNAME(CNAMEBLQ,.F.,.F.,.T.)

		MESSAGEBOX("Existe um usuário utilizando a Rotina de Aprovação de Venda!" + ENTER + "Aguarde","ATENÇÃO",64)
		__QUIT()

	ENDIF 

	lImporta := Iif(GetMV("MV__FTMI07")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
	If lImporta
		MsgStop("Rotina efetivacao orcamentos ja esta sendo executada - MATA416A")
		__QUIT()
	EndIf	

RETURN