#Include "protheus.ch"
#Include "topconn.ch"

/*
Programa: 	EICDI154_RDM
Função	:	Ponto de Entrada do Programa gerador de NFE de importação
Data	: 	26/01/13
Autor	:	Luiz Fernando ..
:   	*** Grava correcao do pedido de compras e Item Contabil / Unidade
:   	*** de Medida na tabela SD1.
*/ 

User Function EICDI154()


	If ParamIxb == "GRAVACAO_SD1" 
		AADD(aItem,{"D1_ITEMCTA"   , SC7->C7_ITEMCTA,".T."}) // Pedido de compra		
		AADD(aItem,{"D1_CLASCON"   , "1",".T."}) // Finalidade == "1" ESTOQ

	EndIf

Return