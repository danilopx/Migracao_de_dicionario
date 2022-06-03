#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TFGPM004 º       ³RICARDO DUARTE COSTAº Data ³  22/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valor do Bonus Action somente em janeiro/2018.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
User Function TFGPM004()

Local nRet		:= 0
Local j			:= 0
Local nMeses	:= 0
Local dDtAfIni	:= stod("20161001")
Local dDtAfFim	:= stod("20170930")
Local _Aaux_	:= {}
Local _caux_	:= ""
Local nValor	:= 460.00

//-- Somente na folha de 01/2018, empresa Action, Filial Varginha e Categoria diferente de aprendizes
If !(cPeriodo == '201801' .And. cEmpAnt == '04' .And. SRA->RA_FILIAL == '02' .And. SRA->RA_CATEG <> '07' .And. SRA->RA_CATFUNC == 'M')
	Return
Endif

_caux_ := AnoMes(dDtAfIni)
While _caux_ <= AnoMes(dDtAfFim)
	Aadd(_Aaux_,{Stod(_caux_+"01"),Stod(_caux_+StrZero(f_UltDia( Stod( _caux_+"01" ) )	,2))})
	nMeses ++
	If Subs(_caux_,5,2) == "12"
		_caux_ := StrZero(Val(Subs(_caux_,1,4)) + 1,4) + "01"
	Else
		_caux_ := Subs(_caux_,1,4) + StrZero(Val(Subs(_caux_,5,2)) + 1,2)
	Endif
Enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Proporcionaliza Valor    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nMesesf := nMeses

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Afastamentos/Demissao/Admissao/Faltas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For j := 1 to Len(_Aaux_)
	_dIni	:= _Aaux_[j,1]
	_dFim	:= _Aaux_[j,2]
	nFaltasM:= 0
	If MTDIASTRAB(_dIni,_dFim)	< 15
		nMesesf --
	Endif
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consiste Valor Minimo e Maximo         						 |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nMesesf > 0
	nValor := Round(nValor / 12 * nMesesf,2)
Else
	nValor := 0
EndIf

If nValor > 0
	fGeraVerba("135",nValor)
EndIF

Return(nRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³MTDIASAFASº Autor ³ AP6 IDE            º Data ³  17/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica os dias trabalhados do funcionarios               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß /*/

Static Function MTDIASTRAB(dDiaIni,dDiaFim)

Local _nDiasTRb	:= dDiaFim - dDiaIni + 1
Local i			:= 0

// Salva Ambiente
Local __aArea_		:= GetArea()
Local _lTemAfas		:= .F.

//Verifica se tem afastamento
dbSelectArea("SR8")
dbSetOrder(1)
If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
	While (SRA->RA_FILIAL + SRA->RA_MAT) == (SR8->R8_FILIAL + SR8->R8_MAT) .And. !Eof()
		If SR8->R8_TIPOAFA $ "003,004,"
			_lTemAfas := .T.
		Endif
		dbskip()
	Enddo
Endif

//Se tem afastamento abate os dias
If _lTemAfas
	For i := dDiaIni To dDiaFim
		// Se tem afastamento, nao e dia trabalhado
		dbSelectArea("SR8")
		dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
		While (SRA->RA_FILIAL + SRA->RA_MAT) == (SR8->R8_FILIAL + SR8->R8_MAT) .And. !Eof()
			If SR8->R8_TIPOAFA $'003,004,'
				If SR8->R8_DATAINI <= i .And. (SR8->R8_DATAFIM >= i .OR. EMPTY(SR8->R8_DATAFIM))
					_nDiasTRb --
				Endif
			EndIf
			dbSkip()
		Enddo
	Next
Endif

//Verifica Admissao
If AnoMes(SRA->RA_ADMISSA) > AnoMes(dDiaFim)
	_nDiasTRb := 0
ElseIf 	AnoMes(SRA->RA_ADMISSA) = AnoMes(dDiaFim)
	For i := dDiaIni To dDiaFim
		If SRA->RA_ADMISSA > i
			_nDiasTRb --
		Endif
	Next
Endif

//Verifica Demissao
If !Empty(SRA->RA_DEMISSA) .And. AnoMes(SRA->RA_DEMISSA) < AnoMes(dDiaIni)
	_nDiasTRb := 0
ElseIf !Empty(SRA->RA_DEMISSA) .And. AnoMes(SRA->RA_DEMISSA) = AnoMes(dDiaIni)
	For i := dDiaIni To dDiaFim
		If SRA->RA_DEMISSA < i
			_nDiasTRb --
		Endif
	Next
Endif

//Ajusta de Negativo
If _nDiasTRb < 0
	_nDiasTRb := 0
Endif

RestArea(__aArea_)

Return(_nDiasTRb)

