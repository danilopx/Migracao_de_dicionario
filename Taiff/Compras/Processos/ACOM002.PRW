#include "rwmake.ch"  
#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACOM002     � Autor � ABM by JAR      � Data �  07/12/2010 ���
�������������������������������������������������������������������������͹��
���Descricao � Residuo Solicita��o de Compras                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function ACOM002()  

//Chamado pelo PE MT110MNU

if (SC1->C1_QUANT - SC1->C1_QUJE) > 0 
if SC1->C1_RESIDUO <> "S"
	SY1->( dbSetOrder(2) )  //busca pelo nome      	
	if SY1->( MsSeek(xFilial("SY1")+AllTrim(UsrFullName(RetCodUsr())) ) )  

		if SY1->Y1_Residuo == "2"

			//SB2
			SB2->( DbSetOrder(1) )
			if SB2->( DbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL ))
				if RecLock("SB2", .f.)			
					SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC1->C1_QUANT - SC1->C1_QUJE)
					MSUnlock()									
				endif                  				
			endif

			//SC1
			if RecLock("SC1", .f.)   
				SC1->C1_RESIDUO := "S"
				SC1->C1_ELIMRES := SC1->C1_QUANT - SC1->C1_QUJE
				SC1->C1_QUJE    := SC1->C1_QUANT
    	   		MSUnlock()
			endif     
 			
		else
			alert("Usuario sem autoriza��o")	
		endif
	EndIf
else
	alert( "SC n�o pode ser alterada" )
endif
else
	alert( "SC totalmente atendida" )
endif

Return
