// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : ajustash6.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 26/08/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} ajustash6
Processa a tabela CB1-Cadastro de Operadores.

@author    pbindo
@version   11.3.2.201607211753
@since     26/08/2016
/*/
//------------------------------------------------------------------------------------------
user function ajustash6()
	Local cHIni
	Local cHFim
	Local nMO	:= 0
	Local nTotMo:= 0
	Local cTotMo:= 0
	Local cQuery
	Local cMens	:= ""

	If !MsgYesNo("DESEJA CORRIGIR OS TEMPOS NA SH6?")
		Return
	EndIf	
	MSGSTOP('ROTINA BLOQUEADA VIA PROGRAMACAO')
	Return
	
	cQuery := " select  *, R_E_C_N_O_ AS H6RECNO FROM "+RetSqlName("SH6")
	cQuery += " WHERE H6__MO <= 1 and D_E_L_E_T_ <> '*' AND H6_FILIAL = '"+cFilAnt+"'
	//cQuery += " AND H6_DTAPONT >= '"+Dtos(FirstDay(dDatabase))+"' 
	cQuery += " AND H6_DTAPONT >= '20180301' AND D_E_L_E_T_ <> '*' AND H6_TEMPO > '000:20' AND H6_OP <> '' AND H6_OPERADO <> ''

	MemoWrite("ajustash6.SQL",cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBH6",.T.,.T.)

	TcSetField("TRBH6", "H6_DATAINI", "D", 8, 0)
	TcSetField("TRBH6", "H6_DATAFIN", "D", 8, 0)

	Count To nRec

	If nRec == 0
		MsgStop("NAO EXISTEM DADOS")
		TRBH6->(dbCloseArea())
		Return
	EndIf

	dbSelectArea("TRBH6")
	dbGoTop()
	While !Eof()

		nDifTempo	:= A680Tempo( Stod('20180301'),'10:00',Stod('20180301'),'10:20')
		nDifTempo	:= nDifTempo*TRBH6->H6__MO 
		cDifTempo   := ConVDecHora(nDifTempo)

//		If cDifTempo # TRBH6->H6_TEMPO
			cMens += "'"+TRBH6->H6_IDENT+"',"
/*
		Else
			dbSelectArea("TRBH6")
			dbSkip()
			Loop
		EndIf
*/
		CONOUT(TRBH6->H6_IDENT)

		//CORRIGE TEMPO NA SH6
		dbSelectArea("SH6")
		dbGoTo(TRBH6->H6RECNO)
		If RecLock("SH6",.F.)
			H6_TEMPO := cDifTempo
			SH6->(MsUnlock())
		Else
			MsgStop("ERRO ATUALIZAR SH6")
		EndIf
		//CORRIGE QUANTIDADE NA SD3
		cQuery := " SELECT R_E_C_N_O_ AS D3RECNO FROM "+RetSqlName("SD3")
		cQuery += " WHERE D3_IDENT = '"+TRBH6->H6_IDENT+"' AND LEFT(D3_COD,3) = 'MOD'"
		cQuery += " AND D_E_L_E_T_ <> '*' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBD3",.T.,.T.)

		dbSelectArea("SD3")
		dbGoTo(TRBD3->D3RECNO)
		If RecLock("SD3",.F.)
			D3_QUANT := nDifTempo
			SD3->(MsUnlock())
		Else
			MsgStop("ERRO ATUALIZAR SD3")

		EndIf
		TRBD3->(dbCloseArea())

		dbSelectArea("TRBH6")
		dbSkip()
	End
	TRBH6->(dbCloseArea())
	MemoWrite("AJUSTAH6.TXT",cMens)
	MsgInfo("ATUALIZACAO CONCLUIDA")
Return


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

	nPos:=AT(":",TRBH6->H6_TEMPO)
	If nPos == 0
		nPos:=AT(":",PesqPict("SH6","H6_TEMPO"))
	EndIf

	cHor:=StrZero(nHora,nPos-1)+":"+StrZero(nMinuto,2)	

Return(cHor)