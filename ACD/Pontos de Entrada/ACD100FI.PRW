#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)
//--------------------------------------------------------------------------------------------------------------
//ROTINA...: ACD100FI                                        
//DESCRICAO: PE para o projeto Cross Docking dos produtos da linha TAIFF acionado na geração da OS
//DATA.....: 02/03/2015
//AUTOR....: CARLOS ALDAY TORRES               
//OBJETIVO.: Filtrar as NFe ou Pedidos que correspondam à operação, isto é quando a OS for por pedido a separação 
//           deve ser para clientes com UF de São Paulo e os demais clientes devem ser considerados por OS de  
//           nota fiscal
//--------------------------------------------------------------------------------------------------------------
User Function ACD100FI()
Local nOrig := PARAMIXB[1] // 1 = Pedido de Venda / 2 = Nota Fiscal / 3 = Ordem de Produção
Local cFil  := ".T."
Local cQuery
Local cListaPedidos := ""
Local _cAlias2
 
If nOrig=1 .AND. CEMPANT='03' .AND. CFILANT='02' 
	Pergunte("AIA102",.F.)

	cQuery := " SELECT DISTINCT C9_PEDIDO AS 'C9_PEDIDO' "		+ ENTER
	cQuery += " FROM " + RetSqlName("SC9") + " SC9 " 			+ ENTER
	cQuery += " WHERE SC9.D_E_L_E_T_ <> '*' " 					+ ENTER
	cQuery += " AND C9_FILIAL	= '" + xFilial("SC9") + "'" 	+ ENTER
	cQuery += " AND C9_NFISCAL	= '' " 							+ ENTER
	cQuery += " AND C9_BLEST		!='02' " 							+ ENTER
	cQuery += " AND C9_ORDSEP	= '' " 							+ ENTER
	cQuery += " AND C9_XFIL		!= '02' " 							+ ENTER
	cQuery += " AND C9_XITEM		= '1' " 							+ ENTER
	cQuery += " AND C9_PEDIDO	>= '" + 	MV_PAR02 +"' "	+ ENTER
	cQuery += " AND C9_PEDIDO	<= '" + 	MV_PAR03 +"' "	+ ENTER
		
	MemoWrite("ACD100FI_SC9_PEDIDOS_SAO_PAULO.sql",cQuery)
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(_cAlias2 := GetNextAlias()), .F., .T.)
	
	cListaPedidos := ""
	(_cAlias2)->(DbGotop())
	While !(_cAlias2)->(Eof())
		cListaPedidos += (_cAlias2)->C9_PEDIDO + "|"
		(_cAlias2)->(DbSkip()) 
	End

	//MemoWrite("ACD100FI_SC9_LISTA_PEDIDOS_SAO_PAULO.sql",cListaPedidos)
	
	If !Empty(cListaPedidos)
		cFil := ' Empty(C9_NFISCAL) .AND. '
		//cFil += ' C9_PEDIDO $ "' + cListaPedidos + '" '
		cFil += "C9_XFIL		!= '02' .AND. "
		cFil += "C9_XITEM		= '1' "
	Else
		cFil  := " 1=2 "
	EndIf  
	
	MemoWrite("ACD100FI_FILTRO_DO_SC9_.TXT",cFil)
	
EndIf
Return {nOrig,cFil} 