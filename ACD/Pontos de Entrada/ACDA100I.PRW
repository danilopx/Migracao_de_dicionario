#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

//--------------------------------------------------------------------------------------------------------------
//ROTINA...: ACDA100I                                        
//DESCRICAO: PE para o projeto Cross Docking dos produtos da linha TAIFF acionado na geração da OS
//DATA.....: 02/03/2015
//AUTOR....: CARLOS ALDAY TORRES               
//OBJETIVO.: Filtrar as NFe ou Pedidos que correspondam à operação, isto é quando a OS for por pedido a separação 
//           deve ser para clientes com UF de São Paulo e os demais clientes devem ser considerados por OS de  
//           nota fiscal
//           Para todo pedido verificar o campo de NUMOC (ordem de carga) em ZC4 quando nOrigExp=1
//--------------------------------------------------------------------------------------------------------------
/*
Se nOrigExp = 1, selecionada opção por Ped.Venda;

Se nOrigExp = 2, selecionada opção por Nota Fiscal;

Se nOrigExp = 3, selecionada opção por Ordem de Produção.
*/
 
USER FUNCTION ACDA100I
Local lRetorno 	:= .T.         
Local _cAlias
LOCAL _AAREASC5	:= SC5->(GETAREA())

If CEMPANT='03' .AND. CFILANT='02' .AND. .NOT. ISINCALLSTACK("U_ACDRD002")
	If nOrigExp == 1  
		cQuery := " SELECT TOP(1) ISNULL(C5_FILDES,'00') AS C5_FILDES "	+ ENTER
		cQuery += " FROM " + RetSqlName("SC5") + " SC5 " 					+ ENTER
		cQuery += " INNER JOIN " + RetSqlName("SC9") + " SC9 "				+ ENTER
		cQuery += " 	ON SC9.C9_FILIAL		= '" + xFilial("SC9") + "' "	+ ENTER
		cQuery += " 	AND SC9.C9_PEDIDO		= C5_NUM "			 				+ ENTER
		cQuery += " 	AND SC9.C9_CLIENTE	= C5_CLIENTE " 					+ ENTER
		cQuery += " 	AND SC9.C9_LOJA		= C5_LOJACLI "	 				+ ENTER
		cQuery += " 	AND SC9.D_E_L_E_T_ 	= '' " 							+ ENTER
		cQuery += "	AND SC9.C9_NFISCAL 	= '' " 							+ ENTER
		cQuery += " 	AND SC9.C9_PEDIDO 	= '" + SC9->C9_PEDIDO + "' " 	+ ENTER
		cQuery += " WHERE SC5.D_E_L_E_T_ 	= '' " 							+ ENTER
		cQuery += " 	AND C5_FILIAL			= '" + xFilial("SC5") + "'" 	+ ENTER
		cQuery += " 	AND C5_NUM		 		= '" + SC9->C9_PEDIDO + "' " 	+ ENTER
		cQuery += " 	AND C5_NUMOC 			= 'CROSS' "						+ ENTER
	
		MemoWrite("ACDA100I_Inclusao_de_OS_em_ZC4.sql",cQuery)
		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cAlias := GetNextAlias()), .F., .T.)
	
		If .NOT. ((_cAlias)->(Eof()) .AND. (_cAlias)->(Bof()))
			If (_cAlias)->C5_FILDES = CFILANT 
				lRetorno := .F.
			EndIf
		EndIf 
		(_cAlias)->(dbCloseArea())
	ElseIf nOrigExp == 2 
		/*
		Para o projeto CROSS DOCKING definimos que a rotina de geração de OS não permitira gerar OS por nota fiscal 
		quando cliente fosse de São Paulo exceto quando for Nfe de transferencia para abastecimento. 
		*/
		If SD2->D2_EST="SP"
			If .NOT. Empty(SD2->D2_PEDIDO)
		    	SC5->(DbSetOrder(1))
		    	If SC5->(DbSeek( xFilial("SC5") + SD2->D2_PEDIDO ))
		    		If .NOT. Empty(SC5->C5_NUMOC)
						lRetorno := .F.		    			
		    		EndIf 
				EndIf
				RESTAREA(_AAREASC5)				
			Else   
				lRetorno := .F.
			EndIf
		EndIf 
	EndIf 
EndIf
      
Return (lRetorno)
