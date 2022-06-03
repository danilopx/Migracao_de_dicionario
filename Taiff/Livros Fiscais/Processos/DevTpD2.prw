// inicio
#include "Protheus.ch"

//------------------------------------------------------------------------------------------------------------------------------ 
// Rotina: DevTpD2                                                                  Autor: Altamir - Kzl       Data: 26/11/2012
// funcao para devolver tipo da Nota Fiscal Origem num Loop de mesma tabela (SD2)
// Principal uso: Lançamento Padrão
//------------------------------------------------------------------------------------------------------------------------------ 
User Function DevTpD2()

Local aArea                                        := GetArea()
Local aAreaSD2                := SD2->(GetArea())
Local nRecnoD2                               := SD2->(Recno())
Local cTipo                                         := ''

cTipo := Posicione("SD2",3,xFilial("SD2")+SD2->D2_NFORI+SD2->D2_SERIORI,"D2_TIPO")


RestArea(aArea)
RestArea(aAreaSD2)
SD2->(DbGoTo(nRecnoD2))
Return(cTipo)
// fim
