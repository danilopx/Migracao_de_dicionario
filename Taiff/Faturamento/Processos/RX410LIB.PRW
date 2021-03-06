#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RX410LIB � Autor � Marcelo Cardoso    � Data �  29/10/13   ���
�������������������������������������������������������������������������͹��
���Descricao � ExecBlock para Liberacao de Bonificacoes                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RX410LIB(_cC5Filial, _cC5Num)
                                         
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _cOldArea := Alias()
Local _aOldArea := GetArea()
Local _aSC5Area := {}
Local _lC5LiBon := AllTrim(GetSx3Cache("C5_X_LIBON", "X3_CAMPO")) == "C5_X_LIBON"

//Verifica se o campo de Liberacao de Bonificacao existe
If _lC5LiBon .AND. !EMPTY(SC5->C5_X_PVBON)      
	
	//Verifica se o sistema esta posicionado no pedido correto, caso contrario posiciona
	DBSelectArea("SC5")
	If SC5->C5_FILIAL + SC5->C5_NUM <> _cC5Filial + _cC5Num
	
		_aSC5Area := SC5->(GetArea())
		
		DBSetOrder(1)
		DBSeek(_cC5Filial + _cC5Num)
	
	EndIf
	
	//Verifica se nao esta em fim de arquivo
	If !EOF()
	                                        
		//Verifica se trata-se de Bonificacao
		If SC5->C5_CLASPED <> "X"
		
			MsgStop("Este pedido nao � de Bonifica��o.")
		
		Else
			                                
			//Verifica se o pedido ja esta liberado
			If SC5->C5_X_LIBON <> "L"
					
				RecLock("SC5", .F.)
				
				SC5->C5_X_LIBON := "L"
				
				MSUnLock()
				
				MsgInfo("Bonifica��o Liberada")
			
			Else
			
				MsgStop("Bonifica��o j� Liberada.")
			
			EndIf
		
		EndIf	
	
	Else
	
		MsgStop("Pedido nao localizado.")
	
	EndIf
	
	// Caso tenha desposicionado o SC5 Restaura                                
	If Len(_aSC5Area) > 0
	
		DBSelectArea("SC5")
		RestArea(_aSC5Area)
		
	EndIf
	                   
	//Retorna ao alias Original	
	DBSelectArea(_cOldArea)
	RestArea(_aOldArea)


Else

	MsgStop("Campo C5_X_LIBON nao existe nesta empresa ou Bonifica��o sem V�nculo. Contacte o administrador.")
	
EndIf


Return()