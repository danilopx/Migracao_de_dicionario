#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MA261EST 		                    AUTOR: ABM						         DATA: 31/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para atualização do saldo do empenho na transferencia no modelo II ao estornar a transferencia
//| SOLICITANTE: 
//| OBSERVACAO: PE executado pela rotina MATA261
//+--------------------------------------------------------------------------------------------------------------
//| MODIFICAÇÕES                                                                        | AUTOR     | DATA
//+-------------------------------------------------------------------------------------+-----------+------------
//| Foram inclusas colunas para gerenciamento do empenho no buffer                      | C. Torres | 01/04/2011
//+--------------------------------------------------------------------------------------------------------------
/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Foi realizado alteracao no Fonte. Tirado a funcao GetArea e RestArea, pois es-
|tava interrompendo o processo de Estorno.
|	Foi incluido a variavel xNI que recebe o posicionamento do aCols atual.
|
|	Edson Hornberger - 08/08/2014
|=================================================================================
*/
User Function MA261EST()

	Local cAlias 		:= Alias()
	Local nRegSD3		:= SD3->(RecNo())
	Local __cEndOrigem	:= GETNEWPAR("MV_TFENDES","BUFFER")
	Local xNI			:= PARAMIXB[1]  
	Local nPosSD3		:= aCols[xNI, aScan(aHeader,{|x| AllTrim(x[2])=="D3_REC_WT"})]

	If SM0->M0_CODIGO == "01" .OR. (SM0->M0_CODIGO == "04" .AND. xFilial("SD3")='02')
	
		SD3->(DBGOTO(NPOSSD3))
	
		If SD3->D3_CF == "DE4" 
		
			If Alltrim(SD3->D3_LOCALIZ) != Alltrim(__cEndOrigem)  // ctorres - 08/04
			
				SD4->(DbSetOrder(2))
				SD4->(DbGoTop())
				If SD4->(DbSeek(xFilial("SD4") + SD3->(D3_OPTRANS + D3_COD + D3_LOCAL)))	
					
					SD4->(RecLock("SD4", .F.))
					SD4->D4_QTDPG -= SD3->D3_QUANT
					SD4->(MsUnLock())
					
				EndIf
				
	      	Else
	      
				SD4->(DbSetOrder(2))
				If SD4->(DbSeek(xFilial("SD4") + SD3->(D3_OPTRANS + D3_COD) + '11'))	
				
					SD4->(RecLock("SD4", .F.))
					SD4->D4_QTBUFPG -= SD3->D3_QUANT
					SD4->(MsUnLock())
					
				EndIf
				
         	EndIf
         	
		EndIf
		
	EndIf

	DbSelectArea(cAlias)
	SD3->(DBGOTO(NREGSD3))

Return(.T.)