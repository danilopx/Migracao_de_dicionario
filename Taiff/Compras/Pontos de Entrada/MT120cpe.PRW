/*
���������������������������������������������������������������������������
�����������������������������������������������������������������������������								���
�������������������������������������������������������������������������ͻ																								���
���Programa  � MT120CPE		Autor  � MMS           � Data �  05/02/16   																���
�������������������������������������������������������������������������͹																										���
���Desc.     �   Ponto de entrada no fim da medi��o autom�tica, para enviar e-mail para o dono do contrato          ���
���          �                                                            																							���
��������������������������������������������������������������������������																											���
���Uso       � Compras/Gest�o de contratos                                            															���
��������������������������������������������������������������������������																											���
�����������������������������������������������������������������������������								���
���������������������������������������������������������������������������
*/
user funcTion mt120CPED()                                            

if "SIGAGCT" $ SC7->C7_OBS															//Checo se na observa��o foi gravado SIGAGCT, se sim � uma altera��o de pedido de contrato
	reclock("SC7",.F.)                        
	replace sc7->c7_contra with SUBSTR(sc7->C7_OBS,10,15)				//Devolvo o numero do contratro para o pedido
	msunlock()
endif
		
return(.T.)
	