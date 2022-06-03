#Include 'Protheus.ch'

#DEFINE ENTER CHR(13) + CHR(10)
/*	 
	 	Nome			Tipo						Descrição				
PARAMIXB[1]			Array of Record			Documento:1-Entrada / 2-Saida										
PARAMIXB[2]			Array of Record			Operação										
PARAMIXB[3]			Array of Record			Cliente/Fornecedor										
PARAMIXB[4]			Array of Record			Loja										
PARAMIXB[5]			Array of Record			Produto
*/	      

User Function MT089TES()
Local nRetorno	:= 0
Local _nRec	:= 0
Local cQuery  	:= ""
Local aAlias	:= GetArea()
Local _cPSC5 	:= GetNextAlias()
Local lStackOk	:= (IsInCallStack("U_CFGMI02CT") .OR. IsInCallStack("U_CFGMI02P") .OR. IsInCallStack("U_CFGMI02T"))

If CEMPANT="03" .AND. CFILANT="01" .AND. lStackOk .AND. ALLTRIM(PARAMIXB[2]) $ "V3|V5|34" .AND. (.NOT. EMPTY(PARAMIXB[5])) .AND. PARAMIXB[1]=2
	/* 1o. PRIORIZAR O PRODUTO */
	/* 2o. PRIORIZAR O GRUPO TRIBUTARIO DO PRODUTO E GRUPO DO CLIENTE E O ESTADO */
	/* 3o. PRIORIZAR O GRUPO TRIBUTARIO DO PRODUTO E GRUPO DO CLIENTE  */
	
	cQuery := "SELECT SFM.* FROM " + RetSqlName("SFM") + " SFM " + ENTER
	cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'" + ENTER      
	cQuery += "	AND SFM.FM_TIPO = '" + PARAMIXB[2] + "'" + ENTER     
	cQuery += "	AND SFM.D_E_L_E_T_='' " + ENTER      
	cQuery += "	AND SFM.FM_TS != '' " + ENTER      
	cQuery += "	AND SFM.FM_PRODUTO='" + PARAMIXB[5]+ "'" + ENTER
	cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))

	//MEMOWRITE("MT089TES_LISTA_SFM.SQL",cQuery)

	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cPSC5), .F., .T.)
	COUNT TO _nRec
	
	(_cPSC5)->(DbCloseArea())
	
	If _nRec > 0
		nRetorno := cQuery
	Else
		cQuery := "SELECT SFM.* FROM " + RetSqlName("SFM") + " SFM " + ENTER
		cQuery += "INNER JOIN SA1030 SA1" + ENTER
		cQuery += "	ON A1_COD='" + PARAMIXB[3]+ "'" + ENTER
		cQuery += "	AND A1_LOJA='" + PARAMIXB[4]+ "'" + ENTER
		cQuery += "	AND SA1.D_E_L_E_T_=''" + ENTER
		cQuery += "	AND A1_FILIAL='" + xFilial("SA1") + "' " + ENTER
		cQuery += "	AND A1_GRPTRIB=FM_GRTRIB" + ENTER
		cQuery += "	AND A1_EST=FM_EST " + ENTER
		cQuery += "INNER JOIN SB1030 SB1" + ENTER
		cQuery += "	ON B1_COD='" + PARAMIXB[5]+ "'" + ENTER
		cQuery += "	AND SB1.D_E_L_E_T_=''" + ENTER
		cQuery += "	AND B1_FILIAL='" + xFilial("SB1") + "'" + ENTER
		cQuery += "	AND B1_GRTRIB=FM_GRPROD " + ENTER
		cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'" + ENTER      
		cQuery += "	AND SFM.FM_TIPO = '" + PARAMIXB[2] + "'" + ENTER     
		cQuery += "	AND SFM.D_E_L_E_T_='' " + ENTER      
		cQuery += "	AND SFM.FM_TS != '' " + ENTER      
		cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
	
		//MEMOWRITE("MT089TES_LISTA_SFM.SQL",cQuery)
	
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cPSC5), .F., .T.)
		COUNT TO _nRec
		
		(_cPSC5)->(DbCloseArea())
		
		If _nRec > 0
			nRetorno := cQuery
		Else
			cQuery := "SELECT SFM.* FROM " + RetSqlName("SFM") + " SFM " + ENTER
			cQuery += "INNER JOIN SA1030 SA1" + ENTER
			cQuery += "	ON A1_COD='" + PARAMIXB[3]+ "'" + ENTER
			cQuery += "	AND A1_LOJA='" + PARAMIXB[4]+ "'" + ENTER
			cQuery += "	AND SA1.D_E_L_E_T_=''" + ENTER
			cQuery += "	AND A1_FILIAL='" + xFilial("SA1") + "' " + ENTER
			cQuery += "	AND A1_GRPTRIB=FM_GRTRIB" + ENTER
			//cQuery += "	AND A1_EST=FM_EST " + ENTER
			cQuery += "INNER JOIN SB1030 SB1" + ENTER
			cQuery += "	ON B1_COD='" + PARAMIXB[5]+ "'" + ENTER
			cQuery += "	AND SB1.D_E_L_E_T_=''" + ENTER
			cQuery += "	AND B1_FILIAL='" + xFilial("SB1") + "'" + ENTER
			cQuery += "	AND B1_GRTRIB=FM_GRPROD " + ENTER
			cQuery += "WHERE SFM.FM_FILIAL = '" + xFilial("SFM") + "'" + ENTER      
			cQuery += "	AND SFM.FM_TIPO = '" + PARAMIXB[2] + "'" + ENTER     
			cQuery += "	AND SFM.D_E_L_E_T_='' " + ENTER      
			cQuery += "	AND SFM.FM_TS != '' " + ENTER      
			cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
		
			//MEMOWRITE("MT089TES_LISTA_SFM.SQL",cQuery)
		
			dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cPSC5), .F., .T.)
			COUNT TO _nRec
			
			(_cPSC5)->(DbCloseArea())
			If _nRec > 0
				nRetorno := cQuery
			EndIf
		EndIf
	EndIf
	RestArea(aAlias)
	
EndIf

Return (nRetorno)
