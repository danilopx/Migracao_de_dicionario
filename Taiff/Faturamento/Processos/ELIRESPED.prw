#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'PROTHEUS.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	ELIRESPED.prw
=================================================================================
||   Funcao: 	ELIRESPED
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para Eliminação de Residuos, conforme foi realizado na Empresa 
|| 	Origem, para que os Pedidos (Atendimento e Origem) fiquem identicos.
||		Este processo sera agendado para rodar de tempo em tempo para  
|| 	igualar os Pedidos.
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	27/10/2015
=================================================================================
=================================================================================
*/

USER FUNCTION ELIRESPED()

LOCAL CQUERY 	:= ""
LOCAL NREGS		:= 0
LOCAL LVALIDO	:= .T.
LOCAL LMVEECFAT := SUPERGETMV("MV_EECFAT") 

/*
|---------------------------------------------------------------------------------
|	Somente irá realizar para a Empresa TaiffProart Matriz 03/01 
|---------------------------------------------------------------------------------
*/
RESET ENVIRONMENT
RPCSETTYPE ( 3 )
//PREPARE ENVIRONMENT EMPRESA "03" FILIAL "02" USER 'edonizetti' PASSWORD 'deutsch0204' TABLES "SA1","SB2","SC0","SC5","SC6","SC9","SE1" MODULO "FAT"
PREPARE ENVIRONMENT EMPRESA "03" FILIAL "02" TABLES "SA1","SB2","SC0","SC5","SC6","SC9","SE1" MODULO "FAT"
SLEEP(1000)

/*
|---------------------------------------------------------------------------------
|	Realiza filtro somente para os Pedidos que ainda nao passaram no processo 
|	verificando o campo ZC8_ELIMIN
|---------------------------------------------------------------------------------
*/
CQUERY := "SELECT" 												+ ENTER
CQUERY += "	ZC8.ZC8_FILIAL," 									+ ENTER 
CQUERY += "	ZC8.ZC8_PEDIDO," 									+ ENTER
CQUERY += "	ZC8.ZC8_ITEM," 										+ ENTER
CQUERY += "	ZC8.ZC8_CODPRO," 									+ ENTER
CQUERY += "	ZC8.ZC8_ELIMIN," 									+ ENTER
CQUERY += "	ZC8.R_E_C_N_O_ AS RECZC8," 							+ ENTER
CQUERY += "	SC5.R_E_C_N_O_ AS RECSC5," 							+ ENTER
CQUERY += "	SC6.R_E_C_N_O_ AS RECSC6" 							+ ENTER
CQUERY += "FROM" 												+ ENTER 
CQUERY += " " + RETSQLNAME("ZC8") + " ZC8" 						+ ENTER
CQUERY += " INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON"		+ ENTER
CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 	+ ENTER 	
CQUERY += "		SC5.C5_NUMORI = ZC8.ZC8_PEDIDO AND" 			+ ENTER 
CQUERY += "		SC5.D_E_L_E_T_ = ''" 							+ ENTER
CQUERY += " INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON"		+ ENTER
CQUERY += " 	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 	+ ENTER 
CQUERY += " 	SC6.C6_NUM = SC5.C5_NUM AND"					+ ENTER 
CQUERY += " 	SC6.C6_ITEM = ZC8.ZC8_ITEM AND" 				+ ENTER 
CQUERY += " 	SC6.C6_PRODUTO = ZC8.ZC8_CODPRO AND" 			+ ENTER 
CQUERY += " 	SC6.D_E_L_E_T_ = ''" 							+ ENTER
CQUERY += "WHERE" 												+ ENTER 
CQUERY += "	ZC8.ZC8_FILIAL = '" + XFILIAL("ZC8") + "' AND" 		+ ENTER
CQUERY += "	ZC8.ZC8_ELIMIN = 'N' AND" 							+ ENTER
//CQUERY += "	ZC8.ZC8_PEDIDO = '073781' AND" 						+ ENTER  // COMENTAR ESTA LINHA (ESTA LINHA É SOMENTE PARA TESTES)
CQUERY += "	ZC8.D_E_L_E_T_ = ''"

IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

TCQUERY CQUERY NEW ALIAS "TRB"
DBSELECTAREA("TRB")
DBGOTOP()
COUNT TO NREGS

/*
|---------------------------------------------------------------------------------
|	Se existem registros para o processo inicia
|---------------------------------------------------------------------------------
*/
IF NREGS > 0 
	
	DBGOTOP()
	
	BEGIN TRANSACTION 		
		WHILE TRB->(!EOF())
			
			LVALIDO := .T.
			/*
			|---------------------------------------------------------------------------------
			|	Posiciona as Tabelas do Pedido de Vendas e utiliza o processo padrao de 
			|	Eliminacao de Residuos.
			|---------------------------------------------------------------------------------
			*/
			DBSELECTAREA("SC5")
			DBGOTO(TRB->RECSC5)
			DBSELECTAREA("SC6")
			DBGOTO(TRB->RECSC6)
			IF LVALIDO .AND. !EMPTY(SC5->C5_PEDEXP) .AND. LMVEECFAT // INTEGRACAO SIGAEEC
			
				IF FINDFUNCTION("EECZERASALDO")
					
					LVALIDO := EECZERASALDO(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					
				ELSE
					
					LVALIDO := EECCANCELPED(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
					
				ENDIF
				
			ENDIF
			
			/*
			|---------------------------------------------------------------------------------
			|	Atualiza campos dos itens do Pedido
			|---------------------------------------------------------------------------------
			*/
	    	IF LVALIDO .AND. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
			    
			    LVALIDO := MARESDOFAT(,.T.,.F.)
			 	IF LVALIDO
			 		/*
			 		|---------------------------------------------------------------------------------
			 		|	Atualiza o Cabecalho do Pedido
			 		|---------------------------------------------------------------------------------
			 		*/
			 		MALIBEROK({ SC5->C5_NUM }, .T.)
			 	ENDIF
			    
			ENDIF	
			
			/*
			|---------------------------------------------------------------------------------
			|	Se eliminou o Residuo corretamente altera o campo ZC8_ELIMIN 
			|---------------------------------------------------------------------------------
			*/
			IF LVALIDO
				
				DBSELECTAREA("ZC8")
				DBGOTO(TRB->RECZC8)
				IF RECLOCK("ZC8",.F.)
					
					ZC8->ZC8_ELIMIN := "S"
					MSUNLOCK()
					
				ENDIF
				
			ENDIF  
			
			TRB->(DBSKIP())
			
		ENDDO	
	END TRANSACTION
	
ENDIF 

RESET ENVIRONMENT

RETURN
