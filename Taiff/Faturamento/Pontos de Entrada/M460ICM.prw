#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

// Incluido em 30/07/2013 - Edson Hornberger
#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460ICM   ºAutor  ³Microsiga           º Data ³  30/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Redefinir Valores de ICMS.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA460                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460ICM

Local nAliqSenado 	:= GetNewPar("TF_ALQICMS",4)
Local cMV_ESTADO	:= GetMv('MV_ESTADO')
// Incluido em 30/07/2013 - Edson Hornberger
Local lReduzAmapa := GetNewPar("TF_REDUZAP",.F.)
Local	_nAliquotas	:= 0
Local cUfesAlcZFM		:= GETNEWPAR("MV_RPCBIUF","AC/AM/AP/RO/RR")
Local lBonifIVA	:= GetNewPar("TF_IVABONI",.F.)
Local nLinAsor		:= 0

U_LOGALIQICM("M460ICM",_ALIQICM)

If SA1->A1_EST='AP' .AND. lReduzAmapa .AND. SF4->F4_PISCOF!='4'
	If nAliqSenado!=0 .and. At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. .NOT. (SC5->C5_TIPO $ "DB") .AND. SF4->F4_ISS!="S" .AND. SA1->A1_EST!=cMV_ESTADO .AND. SA1->A1_TIPO='R' .AND. SA1->A1_CALCSUF != "I"
		_nAliquotas := GetNewPar("MV_TXPIS",1.65) + GetNewPar("MV_TXCOFIN",7.6)
		_BASEICM 	:= _BASEICM * (1 - (_nAliquotas/100))
		_VALICM		:= _BASEICM * (_ALIQICM/100)
		nLinAsor	:= PROCLINE()
	EndIf
Endif

If lReduzAmapa .AND. SA1->A1_EST != 'AP' .and. At(SA1->A1_EST,cUfesAlcZFM) != 0 .and. nAliqSenado != 0 .and. At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. SA1->A1_EST != cMV_ESTADO .AND. SA1->A1_TIPO = 'R' .AND. SA1->A1_CALCSUF != "I"
	If SF4->F4_ICM = "S" .AND. SF4->F4_LFICM = "T" .AND. SF4->F4_CONSUMO = "N" .AND. Empty(SF4->F4_ICMSTMT) .and. SF4->F4_PISDSZF = "2" .AND. SF4->F4_COFDSZF = "2" .and. SF4->F4_PISCOF = "3" .AND. SF4->F4_PISCRED = "4" //.AND. SF4->F4_BSICMST
		_nAliquotas := GetNewPar("MV_TXPIS",1.65) + GetNewPar("MV_TXCOFIN",7.6)
		_BASEICM 	:= _BASEICM * (1 - (_nAliquotas/100))
		_VALICM		:= _BASEICM * (_ALIQICM/100)
		nLinAsor	:= PROCLINE()
	EndIf
EndIf

/*
Altera a aliquota de ICM para pedido de bonificação desta forma atende o regime especial de EXTREMA para cliente de MG
*/
If CEMPANT = '03' .AND. CFILANT = '02' .AND. SC5->C5_CLASPED $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO   
	If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. SC5->C5_TIPO = "N" .AND. SF4->F4_ISS!="S" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA
		_ALIQICM	:= 18
		_VALICM		:= _BASEICM * (_ALIQICM/100)
		nLinAsor	:= PROCLINE()
		
	EndIf
EndIf

/*ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
//ÿÿ FIM DO DESENVOLVIMENTO - Edson Hornberger      ÿÿ
//ÿÿ                          30/07/2013            ÿÿ
//ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ*/

/* VARIAVEIS UTILIZADAS NESTE PONTO DE ENTRADA NO MATA460
	If l460ICM
		_ALIQICM 	:=nPerIcm
		_QUANTIDADE :=nQuant
		_BASEICM :=nBaseItem
		_VALICM		:=nItemIcm
		_FRETE		:=nFreteItem
		_VALICMFRETE:=nFreteIcm
		_DESCONTO	:=nDesconto
		_VALRATICM  := nValRatIcm
		_ACRESFIN   :=aTots[nElem][17]
		ExecBlock("M460ICM",.F.,.F.)
		nBaseItem	:=_BASEICM
		nItemIcm    :=_VALICM
		nFreteItem	:=_FRETE
		nFreteIcm	:=_VALICMFRETE
		nPerIcm		:=_ALIQICM
		nDesconto	:=_DESCONTO
		nValRatIcm  :=_VALRATICM
		aTots[nElem][17] := _ACRESFIN
	Endif
*/

Return NIL

User Function LOGALIQICM( _cTFrotina,_nAliquota )
Local _cQuery := ""

_cQuery := "INSERT INTO TEMP_CT_LOG_ALIQUOTA (DT_FATURA, ROTINA ,CEMPANT, CFILANT ,MV_ESTADO ,M0_CODIGO ,M0_CODFIL ,F7_RECNO ,F4_RECNO ,B1_RECNO ,A1_RECNO ,C5_RECNO ,C6_RECNO ,ALIQICM ,USUARIO) " + ENTER
_cQuery += "VALUES ( " + ENTER
_cQuery += "GETDATE()," + ENTER
_cQuery += "'" + _cTFrotina + "'," + ENTER
_cQuery += "'" + CEMPANT + "'," + ENTER
_cQuery += "'" + CFILANT + "'," + ENTER
_cQuery += "'" + ALLTRIM(GetMv('MV_ESTADO')) + "'," + ENTER
_cQuery += "'" + SM0->M0_CODIGO + "'," + ENTER
_cQuery += "'" + SM0->M0_CODFIL + "'," + ENTER
_cQuery += "'" + Alltrim(str(SF7->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(SF4->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(SB1->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(SA1->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(SC5->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(SC6->(RECNO()))) + "'," + ENTER
_cQuery += "'" + Alltrim(str(_nAliquota)) + "', " + ENTER
_cQuery += "'" + SUBSTR(cUserName,1,20) + "' " + ENTER
_cQuery += ") "

//Memowrite("M460ICM_LOGALIQICM.SQL",_cQuery)
TCSQLExec(_cQuery)

Return NIL
