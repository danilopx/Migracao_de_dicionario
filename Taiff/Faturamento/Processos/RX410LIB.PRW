#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RX410LIB º Autor ³ Marcelo Cardoso    º Data ³  29/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ExecBlock para Liberacao de Bonificacoes                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Taiff-ProArt                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RX410LIB(_cC5Filial, _cC5Num)
                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		
			MsgStop("Este pedido nao é de Bonificação.")
		
		Else
			                                
			//Verifica se o pedido ja esta liberado
			If SC5->C5_X_LIBON <> "L"
					
				RecLock("SC5", .F.)
				
				SC5->C5_X_LIBON := "L"
				
				MSUnLock()
				
				MsgInfo("Bonificação Liberada")
			
			Else
			
				MsgStop("Bonificação já Liberada.")
			
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

	MsgStop("Campo C5_X_LIBON nao existe nesta empresa ou Bonificação sem Vínculo. Contacte o administrador.")
	
EndIf


Return()