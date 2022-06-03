#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#DEFINE PULA CHR(13) + CHR(10) 

/*
=================================================================================
=================================================================================
||   Arquivo:	MT440VLD.PRW
=================================================================================
||   Funcao: 	MT440VLD
=================================================================================
||   Descricao
||------------------------------------------------------------------------------- 
|| 		Ponto de entrada para validação da execução da rotina de processamento 
|| 	da liberação automatica de pedido de venda.
|| 		O ponto de entrada inibe a execução da rotina.
|| 		Utilizado para Controle de Semaforo do Processo CrossDocking
=================================================================================
=================================================================================
||   Autor:	 
||   Data:
=================================================================================
=================================================================================
*/

User Function MT440VLD

Local _RET			:= .T.
LOCAL ABOTOES1 		:= {OEMTOANSI("Cancela")}
LOCAL CMSG			:= ""
LOCAL CTIT			:= OEMTOANSI("Liberação de Pedidos de Venda")

PRIVATE CSMFT01		:= GETMV("MV_SMFT01",.F.,"DEFAULT01")	
PRIVATE CSMFT02		:= GETMV("MV_SMFT02",.F.,"DEFAULT02")

IF ALLTRIM(SC5->C5_XITEMC) = "TAIFF" .AND. SC5->C5_CLASPED != "A" 			
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Verificacao de Semaforo 01. O mesmo nao podera concorrer com a Execucao da 
	|	Geracao da OC e com a Liberacao de Pedidos.
	|
	|	Edson Hornberger - 11/09/2015
	|=================================================================================
	*/
	CMSG := 	PULA + OEMTOANSI("Existe um usuário bloqueando os Saldos em Estoque."			) + ;
				PULA + OEMTOANSI("Aguarde uns instantes para que seja liberado!"				) + ;
				PULA + OEMTOANSI("Caso clique em CANCELAR todo o processo deverá ser"			) + ;
				PULA + OEMTOANSI("realizado novamente!"	) 
	
	WHILE !LOCKBYNAME(CSMFT01,.T.,.T.)
		
		IF AVISO(CTIT,CMSG,ABOTOES1,3,OEMTOANSI("   ATENÇÃO") + PULA + PULA ,,"AVN_A1_INFO",.F.,10000,2) == 1
			RETURN()
		ENDIF
		
	ENDDO
		
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Verificacao de Semaforo 02. O mesmo nao podera concorrer 
	|	com a Liberacao de Pedidos.
	|
	|	Edson Hornberger - 11/09/2015
	|=================================================================================
	*/
	
	WHILE !LOCKBYNAME(CSMFT02,.T.,.T.)
		
		IF AVISO(CTIT,CMSG,ABOTOES1,3,OEMTOANSI("   ATENÇÃO") + PULA + PULA ,,"AVN_A1_INFO",.F.,10000,2) == 1
			RETURN()
		ENDIF
		
	ENDDO
	
ENDIF 

RETURN(_RET)

