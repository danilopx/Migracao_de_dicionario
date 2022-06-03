#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410CPY � Autor � Gilberto R. Jr   �Data � 29/04/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Valida se o produto j� existe na tabela de pre�o		     ���
�������������������������������������������������������������������������͹��
���Uso       � No momento de copiar um pedido                             ���
�������������������������������������������������������������������������͹��
���  *********     DOCUMENTACAO DE MANUTENCAO DO PROGRAMA     *********   ���
�������������������������������������������������������������������������͹��
���Consultor �   Data   � Hora  � Detalhes da Alteracao                   ���
�������������������������������������������������������������������������͹��
    CT         14/06/2013   PE acionada no bot�o copia do pedido de vendas                               
Implementado para evitar calculo incorreto de ICMS ST, j� que para os pedidos 
antigos a origem do produto poderia estar com origem antiga, causando erro 
de calculo de ICMS ST
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION MT410CPY()
	Local lRet := .T.
	Local aArea := GetArea()
	Local _nPosXoper	:= Ascan( aHeader, {|d| Alltrim(d[2]) == "C6_XOPER" } )
	Local _nPosProduto:= Ascan( aHeader, {|d| Alltrim(d[2]) == "C6_PRODUTO" } )
	Local _nPosTES		:= Ascan( aHeader, {|d| Alltrim(d[2]) == "C6_TES" } )
	Local _nPosLocal	:= Ascan( aHeader, {|d| Alltrim(d[2]) == "C6_LOCAL" } )
	Local __nLoop := 0
	Local __nSubLoop := 0
	
	M->C5_NUMOLD = ""

	SF4->(DbSetOrder(1))
	SB1->(DbSetOrder(1))

	For __nLoop:=1 to Len(aCols)

		N:=__nLoop

		For __nSubLoop := 1 To Len(aHeader)
			M->&( aHeader[__nSubLoop][2] ) := aCols[__nLoop][__nSubLoop]
		Next

		cTES := MaTesInt(2,aCols[__nLoop][_nPosXoper],M->C5_CLIENTE,M->C5_LOJACLI,"C",aCols[__nLoop][_nPosProduto])
		aCols[__nLoop][_nPosTES] := cTES

		_cLocal := aCols[__nLoop][_nPosLocal]

	Next
	N:=1

	// Verifica se � tipo de pedido que necessita passar por aprova��o de cr�dito
	If M->C5_TIPO = "N" .and. ALLTRIM(M->C5_NUMOC) != "CROSS" .and. ALLTRIM(M->C5_XITEMC) $ "TAIFF|PROART" .and. M->C5_CLASPED $ "V|X|A" .and. _cLocal $ '21|51'
		M->C5_XLIBCR = "M" // Joga para an�lise de cr�dito manual
	EndIf

	RestArea(aArea)

RETURN lRet



