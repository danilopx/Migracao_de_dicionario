#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESUFRE   บ Autor ณ Eduardo Barbosa    บ Data ณ  17/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Resumo Notas Emitidas X Frete Calculados e Pagos           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO DeltaDecisao                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RESUFRE()

PRIVATE aOrd := {}
PRIVATE cDesc1         := "Relatorio Resumo Notas Emitidas X Frete "
PRIVATE cDesc2         := ""
PRIVATE cDesc3         := ""
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "RESUFRE"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := PADR("RESFRE",10)
Private titulo         := "Resumo de Frete"
Private nLin           := 56
Private Cabec1         := ""
Private Cabec2         := ""
PRIVATE imprime        := .T.
Private wnrel          := "RESUFRE"
Private cString        := "SF2"
Private m_pag          := 01
Private cbCont		   := ' '
Private cbTxt		   := ' '
//Private _cTransp	   := Alltrim(GETMV("MV_HATRAR"))
Private _cTransp	   := "XXX"
_cTransp 			   := _cTransp+Space(6-Len(_cTransp))

VALIDPERG()
pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| fImpFat()},,"Selecionando informacoes...")

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณFIMPFAT   บ Autor ณ AP6 IDE            บ Data ณ  24/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function FIMPFAT()

Local _nSubVol:= 0
Local	_nSubLiq	:=0
Local	_nQtdVol	:= 0
Local	_nPesLiq	:=  0


_aTipos	:={}
AADD(_aTipos,"Fracionado")
AADD(_aTipos,"Lotacao")
AADD(_aTipos,"Rem Armazenagem")
AADD(_aTipos,"Ret Armazenagem")
AADD(_aTipos,"Recusas")
AADD(_aTipos,"Devolu็๕es")
AADD(_aTipos,"Reentregas")
AADD(_aTipos,"Compras")
AADD(_aTipos,"Retira")
AADD(_aTipos,"Outros")
AADD(_aTipos,"Bonificacao")

_aOrdem := {}
AADD(_aOrdem,'Provisionamento do Periodo')
AADD(_aOrdem,'Vencimentos no Periodo')
AADD(_aOrdem,'Nao calculados')

_aStru	:={}
AADD(_aStru,{"ORDEM"    ,"C",1,0})  // P = PROVISAO , V=VENCIMENTO  Z= Nao Calculadas
AADD(_aStru,{"TIPO"    ,"C",2,0})
AADD(_aStru,{"F2DUPLIC","C",1,0})
AADD(_aStru,{"QTDNFTOT","N",10,0})
AADD(_aStru,{"VALORTOT","N",14,0})
AADD(_aStru,{"PESOTOT","N",10,0})
AADD(_aStru,{"FRETETOT","N",10,0})
AADD(_aStru,{"QTDVOL","N",10,0})
AADD(_aStru,{"PESOLIQ","N",10,0})

_cArq	:=	CriaTrab(_aStru,.T.)
Use &_cArq Shared New Alias TRB
_cArqInd	:= CriaTrab(,.F.)
IndRegua("TRB",_cArqInd,"ORDEM+TIPO",,,"Gerando Arquivo Temporario")

/// Montagem das Querys

// Localizar Todas as Notas Fiscais de Saida no Periodo
_cQuery :=  " SELECT D2_TIPO,D2_DOC,D2_SERIE,D2_CLIENTE,D2_PEDIDO,F4_DUPLIC, SUM(D2_QUANT) AS D2_QUANT"
_cQuery +=  " FROM "+RetSQLName("SD2")+" SD2, "+RetSQLName("SF4")+" SF4 "
_cQuery +=  " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
_cQuery +=  " AND F4_FILIAL='"+xFilial("SF4")+"'"
_cQuery +=  " AND D2_TES=F4_CODIGO "
_cQuery +=  " AND F4_ESTOQUE='S'"
_cQuery +=  " AND D2_TIPO IN ('N','B')"
_cQuery +=  " AND D2_TP BETWEEN 'P0' AND 'PZ'"
_cQuery +=  " AND SF4.D_E_L_E_T_=' '"
_cQuery +=  " AND SD2.D_E_L_E_T_=' '"
_cQuery +=  " AND  D2_DOC    >='"+MV_PAR01+"' AND D2_DOC<='"+MV_PAR02+"'"
_cQuery +=  " AND  D2_EMISSAO>='"+DTOS(MV_PAR05)+"' AND D2_EMISSAO<='"+DTOS(MV_PAR06)+"'"
_cQuery +=  " AND  D2_EST    >='"+MV_PAR09+"' AND D2_EST<='"+MV_PAR10+"'"
_cQuery +=  " GROUP BY D2_TIPO,D2_DOC,D2_SERIE,D2_CLIENTE,D2_PEDIDO,F4_DUPLIC ORDER BY D2_DOC"

If Sele("TRB1") <> 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif
SetRegua(6000)
TCQUERY _cQuery NEW ALIAS "TRB1"
DbSelectArea("TRB1")
While ! Eof()
	IncRegua()
	
	DbSelectarea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2")+TRB1->D2_DOC+TRB1->D2_SERIE+TRB1->D2_CLIENTE,.F.)
	If (SF2->F2_TRANSP <MV_PAR03 .OR. SF2->F2_TRANSP>MV_PAR04) .OR. ;
		(SF2->F2_VEND1  <MV_PAR07 .OR. SF2->F2_VEND1>MV_PAR08) .OR. SF2->F2_VALCON == 0 .OR.;
		(SF2->F2_TIPO=='B' .AND. SF2->F2_TRANSP <> _cTransp )
		DbSelectArea("TRB1")
		DbSkip()
		Loop
	Endif            
	
	DbSelectarea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5")+TRB1->D2_PEDIDO,.F.)
	_cOrdem := '1' // Notas Fiscais de Saida
	Do Case
		
		Case SF2->F2_TIPO =='B'
			_cTipo := '03'  // Remessa Para Armazenagem
		Case (SF2->F2_TIPO =='N' ) .AND. (SC5->C5_TPFRETE=='C' .OR. (SC5->C5_TPFRETE=='F' .AND. !Empty(SC5->C5_REDESP)))
			If EMPTY(SF2->F2_NUMNEG)
				_cTipo := '01'  // Fracionado
			Else
				_cTipo := '02' // Itinerante
			Endif
		Case (SF2->F2_TIPO == 'N' .AND. SC5->C5_TPFRETE=='F' .AND. Empty(SC5->C5_REDESP)) // Retira
			_cOrdem	:= '3'
			_cTipo	:= '09'
			If SF2->F2_VALCON > 0 /// Para FOB nao existe Frete
				DbSelectArea("SF2")
				RecLock("SF2",.F.)
				SF2->F2_VALCON=0
				MsUnlock()
			Endif
		Otherwise
			_cTipo := '10' // Outros
	Endcase
	If _cTipo <> '09' .AND. SF2->F2_VALCON == 0
		_cOrdem	:= '3' // Fretes Nao Calculados
		//_cTipo := '10'
	Endif
	
	DbSelectArea("TRB")
	DbSetOrder(1)
	_lAdiciona := IIF(DbSeek(_cOrdem+_cTipo),.F.,.T.)
	RecLock("TRB",_lAdiciona)
	TRB->ORDEM 		:=	_cOrdem
	TRB->TIPO  		:=	_cTipo
	TRB->F2DUPLIC	:=  TRB1->F4_DUPLIC
	TRB->QTDNFTOT	:=	TRB->QTDNFTOT+1
	TRB->VALORTOT	:=  TRB->VALORTOT+SF2->F2_VALBRUT
	TRB->PESOTOT	:=  TRB->PESOTOT+SF2->F2_PBRUTO
	TRB->FRETETOT	:=  TRB->FRETETOT+SF2->F2_VALCON
	TRB->QTDVOL 	:=	TRB->QTDVOL+TRB1->D2_QUANT
	TRB->PESOLIQ	:=  TRB->PESOLIQ+SF2->F2_PLIQUI
	msUnlock()
	DbSelectArea("TRB1")
	DbSkip()
	
Enddo

TRB1->(DbCloseArea())

/// Localizar Produto De Amostra
// Localizar Todas as Notas Fiscais de Saida no Periodo
_cQuery :=  " SELECT D2_DOC,D2_SERIE,D2_CLIENTE, SUM(D2_QUANT) AS D2_QUANT "
_cQuery +=  " FROM "+RetSqlName("SD2")
_cQuery +=  " WHERE D2_FILIAL='"+xFilial("SD2")+"'"
_cQuery +=  " AND D2_TIPO ='N'"
_cQuery +=  " AND D2_COD='ESP000'"
_cQuery +=  " AND D_E_L_E_T_=' '"
_cQuery +=  " AND  D2_DOC    >='"+MV_PAR01+"' AND D2_DOC<='"+MV_PAR02+"'"
_cQuery +=  " AND  D2_EMISSAO>='"+DTOS(MV_PAR05)+"' AND D2_EMISSAO<='"+DTOS(MV_PAR06)+"'"
_cQuery +=  " AND  D2_EST    >='"+MV_PAR09+"' AND D2_EST<='"+MV_PAR10+"'"
_cQuery +=  " GROUP BY D2_DOC,D2_SERIE,D2_CLIENTE"

If Sele("TRB1") <> 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif
SetRegua(6000)
TCQUERY _cQuery NEW ALIAS "TRB1"
DbSelectArea("TRB1")
While ! Eof()
	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2")+TRB1->(D2_DOC+D2_SERIE+D2_CLIENTE),.F.)
	DbSelectarea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2")+TRB1->D2_DOC+TRB1->D2_SERIE+TRB1->D2_CLIENTE,.F.)
	If (SF2->F2_TRANSP <MV_PAR03 .OR. SF2->F2_TRANSP>MV_PAR04) .OR. SF2->F2_VALCON ==0
		DbSelectArea("TRB1")
		DbSkip()
		Loop
	Endif
	
	If SF2->F2_VALCON > 0
		_cOrdem	:= '1' // Fretes Nao Calculados
	Else
		_cOrdem	:= '3' // Fretes Nao Calculados
	Endif
	_cTipo     := '11'
	DbSelectArea("TRB")
	DbSetOrder(1)
	_lAdiciona := IIF(DbSeek(_cOrdem+_cTipo),.F.,.T.)
	RecLock("TRB",_lAdiciona)
	TRB->ORDEM 		:=	_cOrdem
	TRB->TIPO  		:=	_cTipo
	TRB->QTDNFTOT	:=	TRB->QTDNFTOT+1
	TRB->VALORTOT	:=  TRB->VALORTOT+SF2->F2_VALBRUT
	TRB->PESOTOT	:=  TRB->PESOTOT+SF2->F2_PBRUTO
	TRB->FRETETOT	:=  TRB->FRETETOT+SF2->F2_VALCON
	TRB->QTDVOL 	:=	TRB->QTDVOL+TRB1->D2_QUANT
	TRB->PESOLIQ	:=  TRB->PESOLIQ+SF2->F2_PLIQUI
	msUnlock()
	DbSelectArea("TRB1")
	DbSkip()
Enddo
TRB1->(DbCloseArea())

// Impressao do Relatorio
Titulo := Alltrim(Titulo) + " ( DE : "+DTOC(MV_PAR05)+" Ate : "+DTOC(MV_PAR06)+" )"
//Titulo := Alltrim(Titulo) + " ( DE : "+DTOC(ddatabase)+" Ate : "+DTOC(ddatabase)+" )"

Cabec1	:=	"               Nota Fiscal                     |  Valor  |Frete-Cobran็a do Transportador|     Indicadores    |   Peso   | Qtde./"
Cabec2	:=	" Modalidade      Qtde         Valor       Peso |  Frete  |    No Mes| Fora Mes| A Faturar| % Valor  | Vlr P/Kg|  Liquido | Volume"
//          " XXXXXXXXXXXXXXX 99,999 999,999,999 9,999,999  9,999,999   9,999,999  9,999,999 9,999,999    999%      999,99   9,999,999  99,999
//          " 1234567890123456789012345678901234560789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                     1         2         3          4         5         6         7         8         9        10        11        12        13         14        15        16        17       18        19        20         21       22


DbSelectArea("TRB")
DbGoTop()

_nCont	:= LastRec()
SetRegua(_nCont)
nLin		:= 80

_nSubFre	:= 0
_nSubQtd	:= 0
_nSubVal	:= 0
_nSubPes	:= 0

_nFRETOT	:= 0
_nQtdNf		:= 0
_nValTot 	:= 0
_nPeso		:= 0
_cOrdem		:= ' '


While ! Eof()
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	If _cOrdem <> TRB->ORDEM
		_cOrdem := TRB->ORDEM
		@ nLin, 001 PSAY _aOrdem[Val(TRB->ORDEM)]
		nLin:= nLin + 2
	Endif
	_cDesc  := _aTipos[Val(TRB->TIPO)]
	_nPerc	:= (TRB->FRETETOT / TRB->VALORTOT) * 100
	_nPerc 	:= Round(_nPerc,2)
	_nFrePes := Round(TRB->FRETETOT / TRB->PESOTOT,2)
	@ nLin,001 PSAY _cDesc
	@ nLin,017 PSAY TRB->QTDNFTOT  Picture "@E 99,999"
	@ nLin,025 PSAY TRB->VALORTOT  Picture "@E 999,999,999"
	@ nLin,038 PSAY TRB->PESOTOT   Picture "@E 9,999,999"
	@ nLin,047 PSAY TRB->FRETETOT  Picture "@E 9,999,999"
	@ nLin,092 PSAY _nPerc 			Picture "@E 999.99 %"
	@ nLin,102 PSAY _nFrePes 		Picture "@E 999.99"
	@ nLin,111 PSAY TRB->PESOLIQ  	Picture "@E 9,999,999"
	@ nLin,121 PSAY TRB->QTDVOL   	Picture "@E 999,999,999"
	nLin++
	_nSubFre	:= _nSubFre + TRB->FRETETOT
	_nSubQtd	:= _nSubQtd + TRB->QTDNFTOT
	_nSubVal	:= _nSubVal + TRB->VALORTOT
	_nSubPes	:= _nSubPes + TRB->PESOTOT
	_nSubVol	:= _nSubVol + TRB->QTDVOL
	_nSubLiq	:= _nSubLiq + TRB->PESOLIQ
	_nFRETOT	:= _nFreTot  + TRB->FRETETOT
	_nQtdNf		:= _nQtdNf   + TRB->QTDNFTOT
	_nValTot 	:= _nValTot  + TRB->VALORTOT
	_nPeso		:= _nPeso    + TRB->PESOTOT
	_nQtdVol	:= _nQtdVol + TRB->QTDVOL
	_nPesLiq	:= _nPesLiq + TRB->PESOLIQ
	
	DbSkip()
	If _cOrdem <> TRB->ORDEM .OR. EOF()
		nLin++
		_nPerc	:= (_nSubFre / _nSubVal ) * 100
		_nPerc 	:= Round(_nPerc,2)
		_nFrePes := Round(_nSubFre / _nSubPes,2)
		@ nLin,001 PSAY " SubTotal "
		@ nLin,017 PSAY _nSubQtd	Picture "@E 99,999"
		@ nLin,025 PSAY _nSubVal	Picture "@E 999,999,999"
		@ nLin,038 PSAY _nSubPes  	Picture "@E 9,999,999"
		@ nLin,047 PSAY _nSubFre	Picture "@E 9,999,999"
		@ nLin,092 PSAY _nPerc 		Picture "@E 999.99 %"
		@ nLin,102 PSAY _nFrePes 	Picture "@E 999.99"
		@ nLin,111 PSAY _nSubLiq  	Picture "@E 9,999,999"
		@ nLin,121 PSAY _nSubVol   	Picture "@E 999,999,999"
		_nSubFre	:= 0
		_nSubQtd	:= 0
		_nSubVal	:= 0
		_nSubPes	:= 0
		_nSubVol	:= 0
		_nSubLiq	:= 0
		nLin++
		@ nLin,001 PSAY Replicate('-',132)
		nLin := nLin + 2
		
	Endif
	
Enddo

TRB->(DbCloseArea())
/*/
If _nValTot > 0
	nLin++
	_nPerc	:= (_nFreTot / _nValTot ) * 100
	_nPerc 	:= Round(_nPerc,2)
	_nFrePes := Round(_nFreTot / _nPeso,2)
	
	@ nLin,001 PSAY " Total Geral "
	@ nLin,017 PSAY _nQtdNF		Picture "@E 99,999"
	@ nLin,025 PSAY _nValTot	Picture "@E 999,999,999"
	@ nLin,038 PSAY _nPeso  	Picture "@E 9,999,999"
	@ nLin,048 PSAY _nFreTot	Picture "@E 9,999,999"
	@ nLin,092 PSAY _nPerc 		Picture "@E 999.99 %"
	@ nLin,102 PSAY _nFrePes 	Picture "@E 999.99"
Endif
/*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SET DEVICE TO SCREEN
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณVALIDPERG ณ Autor ณ  Fernando Bombardi    ณ Data ณ 05/05/03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica as perguntas incluindo-as caso nao existam		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Relatorio RFAT27                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function VALIDPERG()

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Nota  de         ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Nota  Ate        ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Transportador de ?","","","mv_ch3","C",06,00,0,"G","","SA4","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Transportador Ate?","","","mv_ch4","C",06,00,0,"G","","SA4","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Emissao de       ?","","","mv_ch5","D",08,00,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"06","Emissao Ate      ?","","","mv_ch6","D",08,00,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"07","Representante de ?","","","mv_ch7","C",06,00,0,"G","","SA3","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Representante Ate?","","","mv_ch8","C",06,00,0,"G","","SA3","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"09","Estado de        ?","","","mv_ch9","C",02,00,0,"G","","12","","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"10","Estado Ate       ?","","","mv_ch0","C",02,00,0,"G","","12","","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return Nil
