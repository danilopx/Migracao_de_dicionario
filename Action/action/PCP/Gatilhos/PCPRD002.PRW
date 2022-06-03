// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : PCPRD001.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 01/07/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} PCPRD002
Processa a tabela SH6-Movimentacao da Producao.

@author    pbindo
@version   11.3.1.201605301307
@since     01/07/2016
/*/
//------------------------------------------------------------------------------------------
user function PCPRD002() 
	Local nDifTempo	:= 0 

	If .NOT. IsInCallStack("U_TFFPCPM2")  
		//QUANDO FOR ACD GRAVA 1 MAO DE OBRA
		If IsInCallStack("U_ACDAT001") .Or. IsInCallStack("U_ACDAT002") .Or. IsInCallStack("ACDV025") 
			M->H6__MO := 1
		Else //VALIDA SE A QTDE MO FOI PREENCHIDA
			If M->H6__MO == 0
				MsgStop("Digite uma quantidade de mao de obra","PCPRD001")
				H6_HORAFIN := Transform("",PesqPict("SH6","H6_HORAFIN"))
				Return(Transform(0,PesqPict("SH6","H6_TEMPO")))
			EndIf	
		EndIf
	
		nDifTempo	:= A680Tempo( M->H6_DATAINI,M->H6_HORAINI,M->H6_DATAFIN,M->H6_HORAFIN )
		nDifTempo	:= nDifTempo*M->H6__MO 
		cDifTempo   := ConVDecHora(nDifTempo)
	EndIf
	

	
return(cDifTempo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConVDecHoraºAutor  ³Microsiga           º Data ³  02/10/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³CONVERTE DECIMAL EM HORA                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ConVDecHora(nCent)
	nHora	:= Int(nCent)
	nMinuto := (nCent-nHora)*(.6)*100
	nSec    := nMinuto*60
	//cString := StrZero(nHora,Iif(nHora>99,3,2))+StrZero(nMinuto,2)+StrZero(Int(Mod(nSec,60)),2,0)

	//cHor := Transform(cString,Iif(nHora>99,'@R 999:99:99','@R 99:99:99'))

	nPos:=AT(":",M->H6_TEMPO)
	If nPos == 0
		nPos:=AT(":",PesqPict("SH6","H6_TEMPO"))
	EndIf

	cHor:=StrZero(nHora,nPos-1)+":"+StrZero(nMinuto,2)	
	
Return(cHor)