#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	MA461ROT.prw
=================================================================================
||   Função:	MA461ROT 	
=================================================================================
||   Descrição
||-------------------------------------------------------------------------------
|| 		INCLUSÃO DE NOVAS ROTINAS 
||		Este ponto de entrada tem por objetivo incluir opções personalizadas 
||	no menu "aRotina".
||		Deve retornar um array onde cada subarray é uma linha a ser adicionada 
|| 	a Rotina padrão.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	02/05/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MA461ROT()

Local aRet 	:= {}
Local aOld	:= aRotina	
Local nSize := Len(aRotina) - 1 
Local nPos	:= 0

/*
|=================================================================================
|   COMENTÁRIO
|---------------------------------------------------------------------------------
|	Será utilizado para retirar a opção de Estorno de Doc. para a Empresa 	
|	TaiffProart Extrema, pois não realiza o estorno da Transferencia de 
|	armazéns do processo de CrossDocking.
|=================================================================================
*/
If CNUMEMP != "0302"
	
	aRet := aRotina
	Return(aRet)
	
EndIf

nPos := aScan(aOld,{|x| Upper(x[2]) = "MA461ESTOR"})

If nPos > 0 
	
	aDel(aOld,nPos)
	aSize(aOld,nSize)
	aRet := aOld
	
EndIf	
	
RETURN(aRet)