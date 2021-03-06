#include "rwmake.ch"  
#Include "Protheus.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACOM001     � Autor � ABM by JAR      � Data �  07/12/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Residuo Pedido de Compras                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User function ACOM001()  
Local aArea := GetArea()
	//Chamado pelo PE MT120BRW

	if SC7->C7_RESIDUO <> "S"
		SY1->( dbSetOrder(3) )  //busca pelo nome
		if SY1->( MsSeek(xFilial("SY1")+RetCodUsr() ) )  

			if SY1->Y1_Residuo == "2"

				if RecLock("SC7",.F.)
					SC7->C7_RESIDUO := "S"
					SC7->C7_ElimRes := SC7->C7_Quant - SC7->C7_QUJE
					SC7->(MSunlock())

					//LIMPA STATUS DO BENEFICIAMENTO NA SD4
					If !Empty(C7__OPBNFC)
						dbSelectArea("SD4")
						dbSetOrder(2)
						If dbSeek(xFilial()+SC7->C7__OPBNFC+SC7->C7_PRODUTO)
							RecLock("SD4",.F.)
							D4__QTPCBN := 0
							SD4->(MsUnlock())				
						EndIf
					EndIf
				endif		

				//SCR
				SCR->( DBSetOrder(2) )
				if SCR->( dbSeek(xFilial("SCR")+"PC"+SC7->C7_NUM,.T.) )
					if RecLock("SCR",.f.)
						SCR->CR_Total := SCR->CR_TOTAL - SC7->C7_TOTAL
						MSUnlock()			
					endif
				endif

				//SCS         
				SCS->( DBSetOrder(2) ) 
				if SCS->( dbSeek( xFilial("SCS")+SC7->C7_APROV )  )
					if RecLock("SCS", .f.)
						SCS->CS_SALDO := SCS->CS_SALDO - SC7->C7_TOTAL			                         
						MSUnlock()
					endif
				endif      

				//SB2    
				SB2->( DBSetOrder(1) )
				if SB2->(DBSeek( xFilial("SB2") + SC7->C7_PRODUTO + SC7->C7_LOCAL ) )      
					if RecLock("SB2", .f.)			
						SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC7->C7_Quant - SC7->C7_QUJE)
						MSUnlock()
					endif
				endif					
			else
				alert( "Usuario sem autoriza��o" )	
			endif
		EndIf
	else
		alert( "PC n�o pode ser alterado" )
	endif
RestArea(aArea)
Return