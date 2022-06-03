#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT410CPY º Autor ³ Gilberto R. Jr   ºData ³ 29/04/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida se o produto já existe na tabela de preço		     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ No momento de copiar um pedido                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º  *********     DOCUMENTACAO DE MANUTENCAO DO PROGRAMA     *********   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºConsultor ³   Data   ³ Hora  ³ Detalhes da Alteracao                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
    CT         14/06/2013   PE acionada no botão copia do pedido de vendas                               
Implementado para evitar calculo incorreto de ICMS ST, já que para os pedidos 
antigos a origem do produto poderia estar com origem antiga, causando erro 
de calculo de ICMS ST
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

	// Verifica se é tipo de pedido que necessita passar por aprovação de crédito
	If M->C5_TIPO = "N" .and. ALLTRIM(M->C5_NUMOC) != "CROSS" .and. ALLTRIM(M->C5_XITEMC) $ "TAIFF|PROART" .and. M->C5_CLASPED $ "V|X|A" .and. _cLocal $ '21|51'
		M->C5_XLIBCR = "M" // Joga para análise de crédito manual
	EndIf

	RestArea(aArea)

RETURN lRet



