/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������								���
�������������������������������������������������������������������������ͻ																								���
���Programa  � MT120ALT �Autor  � MMS           � Data �  05/02/16	  																���
�������������������������������������������������������������������������͹																										���
���Desc.     �   Ponto de entrada para permitir a altera��o do pedido de compras gerado pelo SIGAGCT               ���
���          �                                                            																							���
��������������������������������������������������������������������������																											���
���Uso       � Compras/Gest�o de contratos                                            															���
��������������������������������������������������������������������������																											���
�����������������������������������������������������������������������������								���
���������������������������������������������������������������������������
*/
user funcTion mt120ALT()                                            

if  empty(sc7->c7_contra) = .F. .and. Altera  										//Checo se � altera��o e se tem contrato gravado                                    
	reclock("SC7",.F.)                        
	replace sc7->c7_obs with "SIGAGCT: "+SC7->C7_CONTRA				//Gravo na observa��o o contrato
	replace sc7->c7_contra with SPACE(10)                        					//Retiro o n�mero do contrato                                                                 	
	msunlock()
endif
		
return(.T.)
	
