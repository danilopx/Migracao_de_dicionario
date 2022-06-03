#include "protheus.ch"

// 20-Out-2021 Ronald Piscioneri: removida a chamada da funcao Ft050Alter que estava neste fonte,
// pois estava comentada a sua insercao no menu, e esta funcao chamava outras que utilizavam
// StaticCall, cujo uso foi desabilitado pela Totvs a partir da release 12.1.33
// Utilize o historico do GitHub para consultar a funcao Ft050Alter se necessario

User Function FT050MNU
Local aRot := {}

aAdd(aRot, { "Exporta Plan.Zerada"	,"u_rfat008"	,0,3,0,NIL} )
aAdd(aRot, { "Importa Planilha"		,"u_rfat009"	,0,3,0,NIL} )
aAdd(aRot, { "Previsto X Realizado" ,"u_rfat010"	,0,3,0,NIL} )

Return aRot
