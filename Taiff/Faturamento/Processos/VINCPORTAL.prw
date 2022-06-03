#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TRYEXCEPTION.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	VINCPORTAL.prw
=================================================================================
||   Funcao: 	VINCPORTAL
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para preenchimento do campo de Vinculo de Pedidos Bonificados 
|| 	para os Pedidos Importados do Portal de Vendas
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:	11/12/2015
=================================================================================
=================================================================================
*/

USER FUNCTION VINCPORTAL(CMARCA)

LOCAL CQUERY 	:= ""
LOCAL CDBNAME	:= ""
LOCAL CPEDVINC	:= ""
LOCAL CSTRTRAN	:= ""
LOCAL CPEDIDO	:= ""

LOCAL BERROR	:= { |OERROR| SHOWERROR(OERROR) }
LOCAL OERROR

DEFAULT CMARCA := "TAIFF"

CURSORWAIT()
	
TRYEXCEPTION USING BERROR

	/*
	|---------------------------------------------------------------------------------
	|	DEPENDENDO DA MARCA ALTERA O BANCO DE DADOS
	|---------------------------------------------------------------------------------
	*/
	IF UPPER(ALLTRIM(CMARCA)) = "TAIFF"
		
		CDBNAME := "PORTAL_TAIFFPROART.."
		CSTRTRAN:= "T"
		
	ELSEIF UPPER(ALLTRIM(CMARCA)) = "PROART" 
	
		CDBNAME := "PORTAL_PROTHEUS_PROART.."
		CSTRTRAN:= "P"
	
	ENDIF 
	
	IF SELECT("TMP") > 0 
		
		DBSELECTAREA("TMP")
		DBCLOSEAREA()
		
	ENDIF 
	
	/*
	|---------------------------------------------------------------------------------
	|	QUERY COM TODOS OS PEDIDOS EM ABERTO QUE TENHAM VINCULO PELO PORTAL
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 																												+ ENTER
	CQUERY += "	SC5.C5_NUMOLD," 																									+ ENTER
	CQUERY += "	SC5.C5_NUM," 																										+ ENTER
	CQUERY += "	SC5.C5_CLASPED,"																									+ ENTER
	CQUERY += "	BON.C5_CLIENTE," 																									+ ENTER
	CQUERY += "	BON.C5_NUMPRE_VENDAS AS VENDAS,"																				+ ENTER
	CQUERY += "	BON.C5_NUMPRE_BONIFICACAO AS BONIFIC"																			+ ENTER
	CQUERY += "FROM" 																													+ ENTER 
	CQUERY += "	" + RETSQLNAME("SC5") + " SC5" 																					+ ENTER
	CQUERY += "	INNER JOIN " + CDBNAME + "TBL_PEDIDOS_ASSOCIADOS BON ON" 												+ ENTER
	CQUERY += "		BON.C5_CLIENTE = SC5.C5_CLIENTE AND" 																		+ ENTER 
	CQUERY += "		BON.C5_NUMPRE_VENDAS = CAST(REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(SC5.C5_NUMOLD),'" + CSTRTRAN + "',''),'C',''),'MAN',''),'MMG','') AS INT)" 	+ ENTER
	CQUERY += "WHERE" 																													+ ENTER 
	CQUERY += "	SC5.C5_FILIAL	= '" + XFILIAL("SC5") + "'		AND" 														+ ENTER 
	CQUERY += "	SC5.C5_BLQ		= ''			AND" 																				+ ENTER
	CQUERY += "	SC5.C5_XITEMC	= '" + UPPER(ALLTRIM(CMARCA)) + "'		AND" 												+ ENTER 
	CQUERY += "	SC5.C5_NOTA		= ''			AND" 																				+ ENTER
	CQUERY += "	SC5.C5_NUMOLD	!= ''			AND" 																				+ ENTER
	CQUERY += "	SC5.C5_X_PVBON	= ''			AND" 																				+ ENTER   
	CQUERY += "	RIGHT(RTRIM(SC5.C5_NUMOLD),3) != 'MAN' AND" 																+ ENTER
	CQUERY += "	SC5.D_E_L_E_T_	= ''" 																								+ ENTER
	CQUERY += "ORDER BY" 																												+ ENTER 
	CQUERY += "	BON.C5_NUMPRE_VENDAS," 																							+ ENTER 
	CQUERY += "	BON.C5_NUMPRE_BONIFICACAO"
	
	TCQUERY CQUERY NEW ALIAS "TMP"
	DBSELECTAREA("TMP")
	
	WHILE TMP->(!EOF())
			
		/*
		|---------------------------------------------------------------------------------
		|	CASO FOR O MESMO PEDIDO DE VENDA E JA HOUVER OUTRAS BONIFICACOES GRAVA NA 
		|	VARIAVEL O PEDIDO DE BONIFICACAO E NA BONIFICACAO GRAVA O PEDIDO DE VENDAS
		|---------------------------------------------------------------------------------
		*/
		IF CPEDIDO = (CVALTOCHAR(TMP->VENDAS) + CSTRTRAN)
		
			CPEDVINC += "/" + CVALTOCHAR(TMP->BONIFIC) + CSTRTRAN
			DBSELECTAREA("SC5")
			DBORDERNICKNAME("SC5NUMOLD")
			IF DBSEEK(XFILIAL("SC5") + CVALTOCHAR(TMP->BONIFIC) + CSTRTRAN)
				
				IF RECLOCK("SC5",.F.)
					
					SC5->C5_X_PVBON := CVALTOCHAR(TMP->VENDAS) + CSTRTRAN
					MSUNLOCK()
					
				ENDIF
				
			ENDIF			
		
		/*
		|---------------------------------------------------------------------------------
		|	CASO SEJA OUTRO PEDIDO DE VENDA GRAVA O CAMPO DE VINCULO NO PEDIDO DE VENDA,
		|	GRAVA NA VARIAVEL PROXIMO PEDIDO DE BONIFICACAO E NA BONIFICACAO GRAVA O 
		|	PROXIMO PEDIDO DE VENDA
		|---------------------------------------------------------------------------------
		*/
		ELSEIF CPEDIDO != (CVALTOCHAR(TMP->VENDAS) + CSTRTRAN)
		
			IF LEN(CPEDVINC) > 0
				
				DBSELECTAREA("SC5")
				DBORDERNICKNAME("SC5NUMOLD")
				IF DBSEEK(XFILIAL("SC5") + CVALTOCHAR(CPEDIDO))
					
					IF RECLOCK("SC5",.F.)
						
						SC5->C5_X_PVBON := CPEDVINC 
						MSUNLOCK()
						
					ENDIF
					
				ENDIF
				
			ENDIF
			
			CPEDVINC := CVALTOCHAR(TMP->BONIFIC) + CSTRTRAN
			DBSELECTAREA("SC5")
			DBORDERNICKNAME("SC5NUMOLD")
			IF DBSEEK(XFILIAL("SC5") + CVALTOCHAR(TMP->BONIFIC) + CSTRTRAN)
				
				IF RECLOCK("SC5",.F.)
					
					SC5->C5_X_PVBON := CVALTOCHAR(TMP->VENDAS) + CSTRTRAN
					MSUNLOCK()
					
				ENDIF
				
			ENDIF
												
		ENDIF
		
		CPEDIDO = (CVALTOCHAR(TMP->VENDAS) + CSTRTRAN)
		TMP->(DBSKIP()) 
		
	ENDDO
	
	/*
	|---------------------------------------------------------------------------------
	|	GRAVA O ULTIMO PEDIDO DE VENDA COM SUAS BONIFICACOES
	|---------------------------------------------------------------------------------
	*/
	IF LEN(CPEDVINC) > 0
					
		DBSELECTAREA("SC5")
		DBORDERNICKNAME("SC5NUMOLD")
		IF DBSEEK(XFILIAL("SC5") + CVALTOCHAR(CPEDIDO))
			
			IF RECLOCK("SC5",.F.)
				
				SC5->C5_X_PVBON := CPEDVINC 
				MSUNLOCK()
				
			ENDIF
			
		ENDIF
		
	ENDIF
	
	DBSELECTAREA("TMP")
	DBCLOSEAREA()
	MSGINFO("Processo Finalizado!")

CATCHEXCEPTION USING OERROR
		
	APMSGINFO("Houve um erro de Execução conforme mensagem anterior." + ENTER + "Tente novamente ou entre com os dados manualmente!", "Error Captured")
	
ENDEXCEPTION

CURSORARROW()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	VINCPORTAL.prw
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/


STATIC FUNCTION SHOWERROR(OERROR)
	
	APMSGSTOP( OERROR:DESCRIPTION, "Error Captured" )
	CURSORARROW()
	BREAK
	
RETURN