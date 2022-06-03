#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

/*
Ponto de entrada criado para atender o recalculo do ICM com aliquota do SENADO, neste momento 
recalcula-se o valor de ST.

Se este PE não retornar o array com a estrutura {Base de retenção de ICMS,Valor do ICMS solidário}
 o programa ignorará o PE e o sistema far	á os devidos cálculos.
 
Em 20/03/2014 foram implementadas funcionalidades por falta de PATCH de atualização para UF de AP a partir de MG
*/
User Function M460SOLI

Local _cItemSC6	:= ParamIxb[2]	
Local _nBaseSol	:= baseicmret //4279.08	                     
Local _nValSol		:= 0 // 671.45
Local _nValIcmIt 	:= icmsitem //98.78              
Local nAliqSenado := GetNewPar("TF_ALQICMS",4)
Local cMV_ESTADO	:= GetMv('MV_ESTADO')
Local cAliqInterna:= GetNewPar("MV_ESTICM","")
Local lReduzAmapa := GetNewPar("TF_REDUZAP",.F.) // Parametro criado por filial
Local	_nAliquotas	:= 0
Local cUfesAlcZFM		:= GETNEWPAR("MV_RPCBIUF","AC/AM/AP/RO/RR")
Local lBonifIVA	:= GetNewPar("TF_IVABONI",.F.)

If _nBaseSol != 0 .AND. SA1->A1_EST='AP' 
	nAliqLocal := Val( Substr(cAliqInterna , At( SA1->A1_EST , cAliqInterna )+2,2) )
	/*
	-----------------------------------------------------------------------------------------------------
	ID......: RECALAMAPA
	OBJETIVO: IMPLEMENTAR REGRA PARA UF do AMAPA, ONDE O PIS E COFINS É NA BASE DO ICMS
	DATA....: 20/03/2014
	AUTOR...: CT
	OBSERVA.: ESTA INTERVENÇÃO DEVERÁ SER REMOVIDA NO MOMENTO EM QUE A TOTVS DIVULGAR PATCH DE CORREÇÃO
	-----------------------------------------------------------------------------------------------------
	REATIVAÇÃO	 
	DATA....: 24/11/2014
	-----------------------------------------------------------------------------------------------------
	*/
	If SA1->A1_EST='AP' .AND. lReduzAmapa .AND. SF4->F4_PISCOF!='4'
		_nAliquotas := GetNewPar("MV_TXPIS",1.65) + GetNewPar("MV_TXCOFIN",7.6)
		If _BASEICM!=0
			_nBaseSol := _BASEICM * (1+ (MARGEMLUCR/100) )
		EndIf
		If _nValIcmIt = 0 .AND. .NOT. (SC5->C5_TIPO $ "DB") .AND. SF4->F4_ISS!="S" .AND. SA1->A1_EST!=cMV_ESTADO
			_nValIcmIt := U_TFvalicmIt(SC5->C5_NUM,_cItemSC6)	// Obtem o valor original do valor de ICMS_ST
			_nValIcmIt := (_nValIcmIt * (1 - (_nAliquotas/100))) * (7/100) //os "7%" é neste caso fixo para produtos de "MG" para "AP"
		EndIf
		If _nValIcmIt != 0 
			If nAliqSenado!=0 .and. At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. .NOT. (SC5->C5_TIPO $ "DB") .AND. SF4->F4_ISS!="S" .AND. SA1->A1_EST!=cMV_ESTADO .AND. SA1->A1_CALCSUF != "I"
				_nValSol	:= ( _nBaseSol * (nAliqLocal/100) )  -  _nValIcmIt 
				/*--------------*/
				Return {_nBaseSol,_nValSol}
				/*--------------*/
			EndIf
		EndIf
	EndIf
EndIf

If lReduzAmapa .AND. SA1->A1_EST != 'AP' .and. At(SA1->A1_EST,cUfesAlcZFM) != 0 .and. nAliqSenado != 0 .and. At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. SA1->A1_EST != cMV_ESTADO .AND. SA1->A1_TIPO = 'R' .AND. SA1->A1_CALCSUF != "I"
	If SF4->F4_MKPSOL!='1' .AND. SF4->F4_ICM = "S" .AND. SF4->F4_LFICM = "T" .AND. SF4->F4_CONSUMO = "N" .AND. Empty(SF4->F4_ICMSTMT) .and. SF4->F4_PISDSZF = "2" .AND. SF4->F4_COFDSZF = "2" .and. SF4->F4_PISCOF = "3" .AND. SF4->F4_PISCRED = "4" //.AND. SF4->F4_BSICMST
		nAliqLocal := Val( Substr(cAliqInterna , At( SA1->A1_EST , cAliqInterna )+2,2) )
		If SA1->A1_EST = 'RO'
			nAliqLocal := Val( Substr(cAliqInterna , At( SA1->A1_EST , cAliqInterna )+2,5) )
		EndIf
		_nAliquotas := GetNewPar("MV_TXPIS",1.65) + GetNewPar("MV_TXCOFIN",7.6)
		If _BASEICM!=0
			_nBaseSol := _BASEICM * (1+ (MARGEMLUCR/100) )
		EndIf
		If _nValIcmIt = 0 .AND. .NOT. (SC5->C5_TIPO $ "DB") .AND. SF4->F4_ISS!="S" .AND. SA1->A1_EST!=cMV_ESTADO
			_nValIcmIt := U_TFvalicmIt(SC5->C5_NUM,_cItemSC6)	// Obtem o valor original do valor de ICMS_ST
			_nValIcmIt := (_nValIcmIt * (1 - (_nAliquotas/100))) * (7/100) //os "7%" é neste caso fixo para produtos de "MG" para "AP"
		EndIf
		If _nValIcmIt != 0 
			If nAliqSenado!=0 .and. At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. .NOT. (SC5->C5_TIPO $ "DB") .AND. SF4->F4_ISS!="S" .AND. SA1->A1_EST!=cMV_ESTADO
				_nValSol	:= ( _nBaseSol * (nAliqLocal/100) )  -  _nValIcmIt 
				/*--------------*/
				Return {_nBaseSol,_nValSol}
				/*--------------*/
			EndIf
		EndIf
	EndIf
EndIf
/*
Altera a aliquota de ICM para pedido de bonificação desta forma atende o regime especial de EXTREMA para cliente de MG
*/
If CEMPANT = '03' .AND. CFILANT = '02' .AND. SC5->C5_CLASPED $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO   
	If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND. SC5->C5_TIPO = "N" .AND. SF4->F4_ISS!="S" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA
		_ALIQICM	:= 18
		_nValSol	:= (_BASEICM * (1+ (MARGEMLUCR/100) )) * (_ALIQICM/100) -  _nValIcmIt 
		/*--------------*/
		Return {_nBaseSol,_nValSol}
		/*--------------*/
	EndIf
EndIf

Return .F.


/*
Função para busca do valor das mercadorias para produtos que não calcula ICM para a operação MG->AP
*/
User Function TFvalicmIt(cPedido,cItemPed)
Local aAreaAnt := GetArea()
Local nValMercadoria:=0
Local cQuery

cQuery := " SELECT SUM(C9_QTDLIB * C9_PRCVEN ) AS C9QTDLIB "
cQuery += " FROM "+RetSqlName("SC9")+" SC9 WITH(NOLOCK) "
cQuery += " WHERE SC9.D_E_L_E_T_ <> '*' "
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = '" + cPedido + "' "
cQuery += " AND C9_ITEM = '" + cItemPed + "' "
cQuery += " AND C9_NFISCAL = '' "
cQuery += " AND C9_BLEST<>'02' "

//MemoWrite("M460SOLI-SC9_VL_MERCADORIAS_AMAPA.sql",cQuery)

If Select("TMPICM") > 0
	TMPICM->(DbCloseArea())
Endif
TcQuery cQuery NEW ALIAS ("TMPICM")

If TMPICM->(Eof()) .and. TMPICM->(Bof())
	// NÃO ENCONTROU
Else
	nValMercadoria := TMPICM->C9QTDLIB
EndIf
RestArea(aAreaAnt)
Return (nValMercadoria)
