#include "rwmake.ch"
#include "PROTHEUS.CH"
#include "topconn.ch"

/*função comentada a pedido do Henrique 15/07/2014 - 12:45*/

/*User Function MAVALMMAIL()

	Local aArea  := GetArea()
	Local lEnvia := .F.
	Local aArray := PARAMIXB
	Local cEvent := GetnewPar('TF_MESSENG','','') 	// Exemplo 00121 , evento 001 - Ponto de pedido e armazem 21
													// separar por barras exemplo: 00121/00125 
	/*				
	If !(aArray[1] / Ponto de pedido / + aArray[2][3] $ /Armazem/ cEvent)
		lEnvia := .F.  //Para validar se o e-mail sera ou nao enviado 
	Endif
	*/
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Foi necessario realizar alteracao no Ponto de Entrada desenvolvido pelo Jorge
	| da TOTVS, pois o mesmo nao foi testado corretamente e com outros processos, 
	| sendo que em outros processos nao existia a posicao [2][3] do Array, gerando 
	| um erro no Sistema.
	| EDSON HORNBERGER - 21/10/2013.
	|=================================================================================
	*/
	
	/*
	IF aARRAY[1] == SUBSTR(cEVENT,1,3)
		IF aARRAY[2][3] == SUBSTR(cEVENT,4,2)
			lENVIA := .T.
		ENDIF
	ENDIF
	
	RestArea(aArea)
	
Return (lEnvia) */


/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|		Este Ponto de Entrada tem que estar compilado no Sistema para sempre
|	retornar FALSO, senao ocorre erro em alguns Processos.
|
|	Edson Hornberger - 09/02/2015
|=================================================================================
*/

User Function MAVALMMAIL()

Return (.F.)
