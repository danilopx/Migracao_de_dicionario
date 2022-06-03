// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : MT120ABU
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 10/11/15 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"


user function MT120ABU()
Local aBtn := PARAMIXB[1]


If cempant == "04"
	Aadd(aBtn,{'BENEFICIAMENTO',{|| U_COMRD002() },"Estrutura da OP <CTRL+E> "})
	SET KEY 5 TO U_COMRD002()
Endif 
	
return(aBtn)
