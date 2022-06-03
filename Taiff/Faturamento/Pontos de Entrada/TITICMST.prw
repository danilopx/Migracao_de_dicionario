#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

#DEFINE ENTER Chr(13) + Chr(10)

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: TITICMST                                     AUTOR: CARLOS TORRES                 DATA: 26/09/2011
// DESCRICAO: PE de intervenção no faturamento, quando gera titulos referente à ICMS-ST
// OBSERVACAO: A pergunta na rotina MATA461: Gerar titulo?
//--------------------------------------------------------------------------------------------------------------
User Function TITICMST
Local	cOrigem	:=	PARAMIXB[1]
Local _cNumNf	:= ""
Local nDiasVen := GETNEWPAR("MV_TFDIAGN", 0 )
Local _cQuery		:= ""
Local cAliasTit	:= GetNextAlias()
Local cAliasFecp	:= GetNextAlias()
Local cNatFecp 	:= GETNEWPAR("MV_ICMS","")
Local cAliasSE2	:= GetNextAlias()
Local lLoopSE2 	:= .T.
 
If cOrigem='MATA460A'
	If .NOT. SF2->F2_EST $ 'RJ|AL'
		//If SM0->M0_CODIGO != '01'
		_cNumNf	:= SF2->F2_DOC
		//EndIf
		SE2->E2_NUM 	:= _cNumNf // SE2->(Soma1(E2_NUM,Len(E2_NUM)))
	ElseIf SF2->F2_EST $ "RJ" .AND. ALLTRIM(SF2->F2_SERIE) $ "1|2" .AND. CEMPANT="03"
		_cNumNf	:= SF2->F2_DOC

		lLoopSE2 := .T.
		While lLoopSE2
			_cQuery := "SELECT COUNT(*) AS nCtaSE2" + ENTER
			_cQuery += " FROM " + RetSQLName("SE2") + " SE2 WITH(NOLOCK) " + ENTER
			_cQuery += "WHERE " + ENTER
			_cQuery += "  SE2.D_E_L_E_T_ = ' ' " + ENTER
			_cQuery += "  AND E2_FILIAL = '" + xFilial("SE2") + "' " + ENTER
			_cQuery += "  AND E2_PREFIXO = 'ICM' " + ENTER
			_cQuery += "  AND E2_NUM = '" + _cNumNf + "' " + ENTER
			_cQuery += "  AND E2_PARCELA = '' " + ENTER
			_cQuery += "  AND E2_FORNECE = '011101' " + ENTER
	
			//MemoWrite( "TITICMST-SE2_GUIA_RJ.sql" , _cQuery )
			
			TcQuery _cQuery NEW ALIAS (cAliasSE2)

			If (cAliasSE2)->nCtaSE2 = 0
				lLoopSE2 := .F.
			Else
				_cNumNf := Soma1( _cNumNf	 ,Len(_cNumNf))
			EndIf
			(cAliasSE2)->(DbCloseArea())			
		End
		
		SE2->E2_NUM 	:= _cNumNf // SE2->(Soma1(E2_NUM,Len(E2_NUM)))
	EndIf
	SE2->E2_VENCTO := DataValida(dDataBase + nDiasVen,.T.)
	SE2->E2_VENCREA:= DataValida(dDataBase + nDiasVen,.T.)
	SE2->E2_HIST	:= "GNRE NF " + SF2->F2_DOC
	If SF2->F2_EST $ 'RJ|AL'

		// Levantar valor de ST e valor da FECP gerado pela rotina padrão
		_cQuery := "SELECT SUM(F3_DIFAL) AS VL_DIFAL" + ENTER
		_cQuery += " FROM " + RetSQLName("SF3") + " SF3 WITH(NOLOCK) " + ENTER
		_cQuery += "WHERE " + ENTER
		_cQuery += "  SF3.D_E_L_E_T_ = ' ' " + ENTER
		_cQuery += "  AND SF3.F3_FILIAL  = '" + xFilial("SF3") + "' " + ENTER
		_cQuery += "  AND SF3.F3_NFISCAL = '" + SF2->F2_DOC + "' " + ENTER
		_cQuery += "  AND SF3.F3_SERIE = '" + SF2->F2_SERIE + "' " + ENTER
		_cQuery += "  AND SF3.F3_CLIEFOR = '" + SF2->F2_CLIENTE + "' " + ENTER
		_cQuery += "  AND SF3.F3_LOJA	= '" + SF2->F2_LOJA + "' " + ENTER

		//MemoWrite( "TITICMST-DIFAL_ICMS_ST_RJ.sql" , _cQuery )
		
		TcQuery _cQuery NEW ALIAS (cAliasFecp)

		If (cAliasFecp)->VL_DIFAL = 0  
			SE2->E2_NATUREZ	:= cNatFecp // Sobrepõe natureza quando não se trata de DIFAL
		EndIf

		// Levantar valor de ST e valor da FECP gerado pela rotina padrão
		_cQuery := "SELECT SUM(F3_VFECPST) AS VL_FECPST" + ENTER
		_cQuery += " FROM " + RetSQLName("SF3") + " SF3 WITH(NOLOCK) " + ENTER
		_cQuery += "WHERE " + ENTER
		_cQuery += "  SF3.D_E_L_E_T_ = ' ' " + ENTER
		_cQuery += "  AND SF3.F3_FILIAL  = '" + xFilial("SF3") + "' " + ENTER
		_cQuery += "  AND SF3.F3_NFISCAL = '" + SF2->F2_DOC + "' " + ENTER
		_cQuery += "  AND SF3.F3_SERIE = '" + SF2->F2_SERIE + "' " + ENTER
		_cQuery += "  AND SF3.F3_CLIEFOR = '" + SF2->F2_CLIENTE + "' " + ENTER
		_cQuery += "  AND SF3.F3_LOJA	= '" + SF2->F2_LOJA + "' " + ENTER

		//MemoWrite( "TITICMST-SqlSE2_ICMS_ST_RJ.sql" , _cQuery )
		
		TcQuery _cQuery NEW ALIAS (cAliasTit)

		If (cAliasTit)->VL_FECPST = SE2->E2_VALOR 
			SE2->E2_HIST	:= "GNRE NF " + SF2->F2_DOC + " - FECP-ST"
			//SE2->E2_TIPO	:= "DAR"
		EndIf	
		(cAliasTit)->(DbCloseArea())
	EndIf
EndIf

Return {SE2->E2_NUM,SE2->E2_VENCTO}

//--------------------------------------------------------------------------------------------------------------
//
// Colocar em Inic. Padrao
//
//F6_CNPJ: SM0->M0_CGC
//F6_INF: "NFe: " + SF2->F2_DOC + " " + ALLTRIM(SA1->A1_NOME) + " CNPJ: " + SA1->A1_CGC + " IE: " + SA1->A1_INSCR                         
//--------------------------------------------------------------------------------------------------------------
                                             
//
// Fonte buscado no endereço: http://tdn.totvs.com.br/kbm#30569
// Porem ao executar-lo ocorre erro no PARAMIXB[2]
//
/*
User Function TITICMST
Local	cOrigem		:=	PARAMIXB[1]
Local	cTipoImp	:=  PARAMIXB[2]

If AllTrim(cOrigem)='MATA954'	//Apuracao de ISS
	SE2->E2_NUM			:=	SE2->(Soma1(E2_NUM,Len(E2_NUM)))
	SE2->E2_VENCTO  	:= DataValida(dDataBase+30,.T.)
	SE2->E2_VENCREA 	:= DataValida(dDataBase+30,.T.)
EndIf    

//EXEMPLO 2 (cTipoImp)

If AllTrim(cTipoImp)='3' // ICMS ST
	  SE2->E2_NUM := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
	  SE2->E2_VENCTO := DataValida(dDataBase+30,.T.)
	  SE2->E2_VENCREA := DataValida(dDataBase+30,.T.)
EndIf

Return {SE2->E2_NUM,SE2->E2_VENCTO}
*/
