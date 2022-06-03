#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³RODRIGO FAZAN       º Data ³  02/23/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PROGRAMA PARA EFETUAR O TRATAMENTO DAS POSICOES DOS COD BAR º±±
±±º          ³CNABS BRADESCO                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Texto retirado do layout pagfor.pdf
Para a Modalidade 31 - “Títulos de Terceiros”: Caso o código do Banco seja 237, todos esses campos
serão obrigatórios, e, se o código do Banco for diferente de 237, não será necessário informar o código
da agência/dígito e Conta-Corrente/dígito e sim preencher os campos com zeros - fixos, pois o
pagamento será efetuando com base no conteúdo constante do campo Informações Complementares
(posições 374 a 413), do Registro de Transação, ou seja, campo livre do código de barras ou linha
digitável.
*/

user function retCodB(cTipo)

local cCodBar := SE2->E2_CODBAR
local cRet	  := ""
local nLen    := 0
//local cBanco  := substr(SE2->E2_CODBAR, 1, 3)
Local cModelo := SEA->EA_MODELO
Local cConta  := SA2->A2_NUMCON
Local nPosDig := At( "-", cConta )

	if cTipo == "1" 					// agencia cedente
		if cModelo == "30"
			cRet := substr(cCodBar, 20, 4)
			nLen := len(cRet) 		
			cRet := Replicate("0", 5 - nLen) + cRet
		elseif cModelo == "31"
			cRet := replicate("0", 5)
		elseif cModelo $ "01|03|05|08"
			cRet := substr(alltrim(SA2->A2_AGENCIA), 1, 4)
			nLen := len(cRet) 		
			cRet := Replicate("0", 5 - nLen) + cRet
		endif
	elseif cTipo == "2"                 // carteira
		if cModelo == "30"
			cRet := substr(cCodBar, 24, 2)
		else
			cRet := "000"
		endif
	elseif cTipo == "3"             	// campo nosso numero
		if cModelo == "30"
			cRet := substr(cCodBar, 26, 11)
		else
			cRet := replicate("0", 11)
		endif
	elseif cTipo == "4"					// conta cedente
		if cModelo == "30"
			cRet := substr(cCodBar, 37, 7)
			nLen := len(cRet) 		
			cRet := Replicate("0", 13 - nLen) + cRet
		elseif cModelo == "31"
			cRet := replicate("0", 13)
		elseif cModelo $ "01|03|05|08"
			//cRet := substr(cConta, 1, len(alltrim(cConta))-1 )
			cRet := substr(cConta, 1, nPosDig - 1 )
			nLen := len(cRet) 		
			cRet := Replicate("0", 13 - nLen) + cRet 
		endif
	elseif cTipo == "5"					// zero 
		cRet := substr(cCodBar, 44, 1)
	elseif cTipo == "6"         		// banco do forcenedor        
		if cModelo $ "01|03|05|08" 
			cRet := SA2->A2_BANCO
		else  
			cRet := substr(cCodBar, 1, 3)
		endif
	elseif cTipo == "7"					// fator de vencimento
		if cModelo $ "30|31"
			cRet := substr(cCodBar, 6, 4)
		else
		    cRet := Replicate("0", 4)
		endif
	elseif cTipo == "8"					// valor
		cRet := substr(cCodBar, 10, 10) 
	elseif cTipo == "9"					// inf complementar campo livre
		if cModelo $ "03|08"
			cRet := "C" 				//374 - 374 - Tipo do DOC\TED (C - Titularidade diferente, D - Mesma titularidade)
			cRet += Replicate("0", 6)   //375 - 380 - Numero DOC
			cRet += "03"				//381 - 382 - Codigo de Finalidade do DOC\TED 03 - Pagamento de Titulos / Duplicatas
			cRet += "01"				//383 - 384 - Tipo de conta - Conta Corrente
			cRet += Space(29)			//385 - 413 - Brancos
		elseif cTipo $ "01|05|30"
			cRet := Space(40)
		else
			cRet := substr(cCodBar, 20, 25)	// 374 - 398 - CAMPO LIVRE DO CODIGO DE BARRAS
			cRet += substr(cCodBar, 5, 1)   // 399 - 399 - DIGITO DE CODIGO DE BARRAS
			cRet += substr(cCodBar, 4, 1)   // 400 - 400 - CODIGO DA MOEDA
			cRet += Space(13)				// 401 - 413 - BRANCOS
		endif
	elseif cTipo == "10"
		if cModelo $ "30|31"
			cRet := substr(SE2->E2_CODBAR, 10, 10)
		else
			cRet := STRZERO(SE2->E2_SALDO*100, 10, 0)
		endif
	elseif cTipo == "11"
		cRet := Replicate("0", 10 - len(alltrim(SE2->E2_NUM)) ) + alltrim(SE2->E2_NUM)
	elseif cTipo == "12" // modalidade de pagto
		cRet := if(cModelo == "30", "31", cModelo)
	endif

return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³Microsiga           º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function digtAge()

//Local cBanco   := Substr(SE2->E2_CODBAR,1,3)
Local cModelo  := SEA->EA_MODELO	
Local cAgencia := strTran(SA2->A2_AGENCIA, "-", "")

	if cModelo $ "01|03|05|08"	
		_RETDIG := right(cAgencia,1)
	elseif cModelo == "30"
		_Agencia  :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)
		_RETDIG := ""
		_DIG1   := SUBSTR(SE2->E2_CODBAR,20,1)
		_DIG2   := SUBSTR(SE2->E2_CODBAR,21,1)
		_DIG3   := SUBSTR(SE2->E2_CODBAR,22,1)
		_DIG4   := SUBSTR(SE2->E2_CODBAR,23,1)
		
		_MULT   := (VAL(_DIG1)*5) +  (VAL(_DIG2)*4) +  (VAL(_DIG3)*3) +   (VAL(_DIG4)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := 11 - _RESTO
		
		_RETDIG := IF( _RESTO == 0,"0",IF(_RESTO == 1,"0",ALLTRIM(STR(_DIGITO))))
	else
		_RETDIG := "0" // quando o banco for diferente de bradesco, mandar 0
	endif

return _RETDIG


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³Microsiga           º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function digtCon()

//Local cBanco  := Substr(SE2->E2_CODBAR,1,3) 
Local cModelo := SEA->EA_MODELO	
Local cConta  := SA2->A2_NUMCON
Local nPosDig := At( "-", cConta )

	if cModelo $ "01|03|05|08"	
		_RETDIG := PadR( SubStr( cConta, nPosDig + 1 ), 2 )
	elseif cModelo == "30"
		_CtaCed  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13)
		_RETDIG := ""
		_DIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
		_DIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
		_DIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
		_DIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
		_DIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
		_DIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
		_DIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
		    
		_MULT   := (VAL(_DIG1)*2) +  (VAL(_DIG2)*7) +  (VAL(_DIG3)*6) +   (VAL(_DIG4)*5) +  (VAL(_DIG5)*4) +  (VAL(_DIG6)*3)  + (VAL(_DIG7)*2)
		_RESUL  := INT(_MULT /11 )
		_RESTO  := INT(_MULT % 11)
		_DIGITO := STRZERO((11 - _RESTO),1)
		
		_RETDIG := IF( _resto == 0,"0",IF(_resto == 1,"P",_DIGITO))
	else
		_RETDIG := "0" // quando o banco for diferente de bradesco, mandar 0
	endif		
	
return _RETDIG


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³Rodrigo Fazan       º Data ³  29/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao extrai o string de codigo de barras da linha dig.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Avape                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function calcBar(cLinha)
Local cBarra  := cLinha
cBarra  := substr(cBarra,1,4) + substr(cBarra, 33,15) + substr(cBarra, 5 , 5) + substr(cBarra, 11,10) + substr(cBarra, 22,10)

return cBarra


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³Microsiga           º Data ³  04/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function agencPag(cTipo)

Local cBanco  := SA2->A2_BANCO
Local cString := ""
Local cRet	  := ""
Local cAgencia:= strTran(SA2->A2_AGENCIA, "-", "")  
Local cConta  := strTran(SA2->A2_NUMCON, "-", "")

Default cTipo := "1"

if cTipo == "1"
	if cBanco $ "341|409"
		cRet := "0"								   								// 024-024 - Complemento de registro, preencher com zeros
		cString := substr(cAgencia, 1, 4)                                                                                              
		cRet += replicate("0", 4 - len(alltrim(cString))) + alltrim(cString)    // 025-028 - Numero da agencia
		cRet += " "              												// 029-029 - Complemento de registro, branco
		cRet += replicate("0", 6)			  									// 030-035 - Zeros
        
        cConta := alltrim(cConta)
		
		if len(cConta) >= 7
			cConta := right(cConta, min(len(cConta), 6))
		endif

		cString := substr(cConta, 1, len(alltrim(cConta)) - 1 )
		cRet += replicate("0", 6 - len(alltrim(cString))) + alltrim(cString)	// 036-041 - Conta Corrente
		cRet += " "																// 042-042 - Brancos
		cRet += right(alltrim(cConta), 1)  

	else

		cString := substr(cAgencia, 1, 4)								
		cRet += replicate("0", 5 - len(alltrim(cString))) + alltrim(cString)    // 024-028 - Numero da agencia
		cRet += " "              												// 029-029 - Complemento de registro, branco
		cString := substr(cConta, 1, len(alltrim(cConta)) - 1 )
		cRet += replicate("0", 12 - len(alltrim(cString))) + alltrim(cString)	// 030-041 - Conta Corrente
		cRet += " "																// 042-042 - Brancos
		cRet += right(alltrim(cConta), 1)  

	endif
else
	if cTipo == "2"
		cString := substr(cConta, 1, len(alltrim(cConta)) - 1 )
		cRet += replicate("0", 12 - len(alltrim(cString))) + alltrim(cString)	// 036-041 - Conta Corrente
	elseif cTipo == "21"
		cRet += right(alltrim(cConta), 1)		
    endif
endif		
return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AFINXCNAB ºAutor  ³Microsiga           º Data ³  04/19/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function retBB(cTipo)
Local cRet := ""

// COD DA CAMARA DE COMPENSACAO
if cTipo == "1" 
	if SEA->EA_MODELO=="03"   	// quando DOC
		cRet := "700"
	elseif SEA->EA_MODELO=="01" // quando CREDITO EM CONTA
	    cRet := "000"
	else                 		// quando TED
		cRet := "018"
	endif
endif

return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     ºAutor  ³Microsiga           º Data ³  06/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function xConta(cConta, nTipo)

local cRet		:= ""
local nPosTrac	:= ""
local cCta		:= ""
local cDig		:= ""

default nTipo 	:= 0
default cConta	:= ""

if !empty(cConta)              

	nPosTrac := at("-", cConta)

	if nPosTrac > 0
		cCta := substr( cConta, 1, nPosTrac - 1) 
		cDig := substr( cConta, nPosTrac + 1, 1)
	endIf
	
	cRet := if(nTipo==1, cDig, cCta)

endIf

return cRet   

user function xEndere(cEnd, nTipo)

local cRet 		:= ""
local nPosVirg 	:= ""
local aAreaA2	:= SA2->( getArea() )
//local cEnd		:= ""
local cNum		:= ""

default nTipo := 0

nPosVirg := at(",", cEnd)

if nPosVirg > 0
	cEnd := substr(cEnd, 1, nPosVirg - 1)
	cNum := subs(cEnd, nPosVirg + 1)
endIf

cRet := if(nTipo==1,cNum, cEnd)

restArea( aAreaA2 )

return cRet

user function xCamComp()
Local cRet := ""

// COD DA CAMARA DE COMPENSACAO
if SEA->EA_MODELO=="03"   	// quando DOC
	cRet := "700"
elseif SEA->EA_MODELO=="01" // quando CREDITO EM CONTA
    cRet := "000"
else                 		// quando TED
	cRet := "018"
endif

return cRet

//--------------------------------------------------------------------------------------------------------------------------------
// FUNÇÃO: xContaPAG                                                                 Autor: Carlos Torres         Data: 04/12/2012
// DESCRIÇÃO: Função utilizada no lay-out do pagamento escritural do Bradeso, especificamente para buscar o numero da conta
//					sem digito da conta bancaria e sem caracter separador 
//--------------------------------------------------------------------------------------------------------------------------------
User Function xContaPAG( cContaPG )
If SEE->EE_CODIGO="237" .and. !Empty(cContaPG)
	If At("-",cContaPG) != 0 
		cContaPG := Substr(cContaPG , 1, At("-",cContaPG)-1 )
	EndIf
	cContaPG := Right( replicate("0",7) + Alltrim(cContaPG) , 7 )
EndIf
Return (cContaPG)
