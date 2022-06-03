#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	MA461ROT.prw
=================================================================================
||   Fun��o:	MA461ROT 	
=================================================================================
||   Descri��o
||-------------------------------------------------------------------------------
|| 		INCLUS�O DE NOVAS ROTINAS 
||		Este ponto de entrada tem por objetivo incluir op��es personalizadas 
||	no menu "aRotina".
||		Deve retornar um array onde cada subarray � uma linha a ser adicionada 
|| 	a Rotina padr�o.
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
|   COMENT�RIO
|---------------------------------------------------------------------------------
|	Ser� utilizado para retirar a op��o de Estorno de Doc. para a Empresa 	
|	TaiffProart Extrema, pois n�o realiza o estorno da Transferencia de 
|	armaz�ns do processo de CrossDocking.
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